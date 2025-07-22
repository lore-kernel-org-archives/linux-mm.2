Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BE55C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 19:58:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAB2F6B009B; Tue, 22 Jul 2025 15:58:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E35546B009C; Tue, 22 Jul 2025 15:58:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4AC66B009F; Tue, 22 Jul 2025 15:58:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C03A76B009B
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:58:32 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5F868160466
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 19:58:32 +0000 (UTC)
X-FDA: 83692962864.13.081987C
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf04.hostedemail.com (Postfix) with ESMTP id 80D4240007
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 19:58:30 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4BwxlzfX;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of kuniyu@google.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=kuniyu@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753214310; a=rsa-sha256;
	cv=none;
	b=EH390LtcizqQ4/w4Tozkflp8xTByNkwoHTZ87orhO7PXBvULSUoBg99/ZOD1jmZ6HAi5Me
	30VL4OCxveE9AUIl/wjdDAdIEadq3RTNuHJhma4UKN/imnFreKsNFRNxeTNncma0xHuoto
	VU0VzxJbpAwGVYAOvXLXOXSbRnKvWyQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4BwxlzfX;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of kuniyu@google.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=kuniyu@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753214310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cCReyCpTjy4nn3Or0iXYbxmyahoyxBHy0fmkPDXu2Qo=;
	b=0fHB6CpKcGc2fuLs+uuDnRfVTNw8VEEr0fW7KSu4f/yxxdkkq+YexdvrlwtTdLvSzy24Xt
	sqRkwH+AwR5GcEsUjfMZgWwLwxi5iNmlF6iYrSl3SNSV+S/MtaiGKvGR8bV62gyi48O2YP
	RzBAWiZr9Wh9iw1fQZEwgEyWOmn2tUU=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3122368d7cfso4528601a91.1
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 12:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753214309; x=1753819109; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cCReyCpTjy4nn3Or0iXYbxmyahoyxBHy0fmkPDXu2Qo=;
        b=4BwxlzfXjyhJnIdjiIDqcmu9033tMe3sEtQdJhYaR4tag4dw4E81LuABHGeOQpXkXD
         hLatL3cpdWJ5RYUc2DssINEPDQvUkKreBBkNUeyKuKQyq/IE92F0hWEiiNreVANtYWiy
         c425/IEXgrLPAFuyhl2ONSyH2sUnJg7QPbskSbwaxVMC/f0ITpUjZFrpb6KEz5yGfCWW
         INrKh4ZdSmmxg+qs5LGHWYnEkHS6Tus8HZN/u6dvV6Pe3dBNQLrNCT3TAR7FWTcbZ+xZ
         71l+ptb/5Nz5Ba2csZlQAvoLNQiL+vyj9AlKsedYiYVDNtaTimXdRFMzYqRWnTpghf9m
         B2iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753214309; x=1753819109;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cCReyCpTjy4nn3Or0iXYbxmyahoyxBHy0fmkPDXu2Qo=;
        b=uIhMtI2HW3/5dWLlpY8fbn+JKMeKp5Tbgn0wkmhz/CSeSmK6SpApA3EDLBLsLlOKR4
         9Dsz93xVSeu1izBGe7nMQKMB/HBaJKF8r15CD6nDW2cHNn2ZZhvWEXjzQS8/htNDluS8
         Tq+RZMx/xSQGp/eDdsGmoyYeMLrvKtzEoXfTCZ65ZG5Lc8tyU+s2VZdnQaXlCFFkuir5
         s8+uHpF385I2vpSXPFVSRGFmxAhEtCQaYzvjNsowhIVi21Z4Zy7AtFEcTHYhMkWrq8at
         Tx4OYce6CyYS1rq8sIx5bfyf4//erNYsGjguWu9HmoutJONpPg75fg9zYJvO58mWmFZm
         Jenw==
X-Forwarded-Encrypted: i=1; AJvYcCWn+zebU1fBQdzVq4d6rJ5v/Okor9JutBHz83z+zXRqycwBX/SWE5mobS5HVKwBrfAAUhsN63BmKg==@kvack.org
X-Gm-Message-State: AOJu0Yx7MQBEjgiIK2BGSMYKsCo+v2RzZNZ4PKNUHy0sTjTTfGd6Bj0R
	8XwaMmjSWpcCpuT52kGniEI9Dk80rYlLyuBUCAXvpiyjABb8njuOua7Hh/un+ZbVr3nxGe+zg0l
	Q1fB1rOMEIu/hO8SsPvoN5L9Sw05Gz8NFuTI9EWlK
X-Gm-Gg: ASbGncsFozCd8mDdnJ2wE0+zCcy2peOmZ8t3ZlApXZFTy/T3Sd3T1rr+UyJrYfRgH0J
	RGevJPnVrE+7J0N8dD11K7iY6zgUGNnegMFDx1YP+irJ/T6hvuQ4Syh3EzyyRtsfpgJdKBlj2lY
	BDzA16apYY2iPAtrTOEzXLP0FAge24AkWhXcbWcHUBDA4yeWWfcjGtPcNhJUdFZCy31GV2TdZEj
	+Cp3Dvts9jcU8amqPgNyYdWKFq087Vf1DtZsw==
X-Google-Smtp-Source: AGHT+IG0SmhWW8QBqcQaG+aqdEHCX9MzB9En/e5DNQG/qjPLBdBSfDDibdJJYPPZ2Dilzt1dahxQKsGb6dQAJYiMO+M=
X-Received: by 2002:a17:90b:3952:b0:312:e744:5b76 with SMTP id
 98e67ed59e1d1-31e507fdbf2mr658997a91.33.1753214309139; Tue, 22 Jul 2025
 12:58:29 -0700 (PDT)
MIME-Version: 1.0
References: <20250722071146.48616-1-daniel.sedlak@cdn77.com>
 <ni4axiks6hvap3ixl6i23q7grjbki3akeea2xxzhdlkmrj5hpb@qt3vtmiayvpz>
 <telhuoj5bj5eskhicysxkblc4vr6qlcq3vx7pgi6p34g4zfwxw@6vm2r2hg3my4>
 <CAAVpQUBwS3DFs9BENNNgkKFcMtc7tjZBA0PZ-EZ0WY+dCw8hrA@mail.gmail.com> <4g63mbix4aut7ye7b7s4m5q7aewfxq542i2vygniow7l5a3zmd@bvis5wmifscy>
In-Reply-To: <4g63mbix4aut7ye7b7s4m5q7aewfxq542i2vygniow7l5a3zmd@bvis5wmifscy>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Tue, 22 Jul 2025 12:58:17 -0700
X-Gm-Features: Ac12FXxXNAuhn4Hv0iRIqcN8oUeZVkIDq7rLj71nMt9uRXTRgjxr4GtJpTqpIu0
Message-ID: <CAAVpQUCOwFksmo72p_nkr1uJMLRcRo1VAneADon9OxDLoRH0KA@mail.gmail.com>
Subject: Re: [PATCH v3] memcg: expose socket memory pressure in a cgroup
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Daniel Sedlak <daniel.sedlak@cdn77.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Neal Cardwell <ncardwell@google.com>, 
	David Ahern <dsahern@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org, netdev@vger.kernel.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	cgroups@vger.kernel.org, Matyas Hurtik <matyas.hurtik@cdn77.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 80D4240007
X-Stat-Signature: z3hqcy999d11x3n9cu4rkg4p3kqzx5df
X-Rspam-User: 
X-HE-Tag: 1753214310-635987
X-HE-Meta: U2FsdGVkX1/u85Jpq6OvkWe9YVJE1+lSlI5EUgQ+biJ0owL60z5KcQMTd3tPS3yKQsFozax2JwyK8dO9XB6jK+DsTDrfX2+B2bd4VhIJtiwkhW1cRHe+9P5RZZobp0fGoVtRuP8R+9R/sJQmMnm2vbKlNEFB5guoblduzd4btuUM9d0OmOMIRYpte/ljZZEl2QrNWMUm/WLu61td9fh0J1sUEZ8QcpGunbonpCtnWH7uWJi7u8CtZ7EJdpssWW8JRvkkf3mZm2BKODaGehCkftgOb6NzijigT+QBCzNf41aMJifHKq4PiYXAesq8glBvrAst72Iutu9C3b4bxflw32boNYkTG9b8OH07Ps1kwg6C4iZ/Iffu+QQFKKAOkqZkJmeDGfS/nA/zFVw7ExybOHoS7kJ7xGbcAk4Q8v0gCWqtpsoVs90N5PzbX6CvT7ls+CwsxlAdS15qZW9cVxhRDdaGoLBOm2mpLSlVkzDUS+GuXJR6h/tbe75fUNln460l+xi+iSKkIKua3eBQCEsvUb8ghtwPeRYc8aRWnFovrUzVi9YdyAPyW3sldvtmCuRhlags7Jk6sCYpQr7nkkBmjaWSkNn3Orol7tWYzXYeVqBMys8NPlL5Pul+iGFB2XzCH/ckmsHbMD4Oisirki5O5y5Zzq+X/Q+Euhs3ynBZJjrisGvQWAJNrmgW/i3DRFvwcwhr1ZLoPmRUUWYTXns+lBhMogHD6OelRenc3D9ZppWUSWYUnWYC0T7rCcGzcR3bgbHG1+WTGW+iDUdmOhWcdvbWok/BT7grtuh54eeAeXX5Ev9SxJb6W02vPF7dLu1AC6CdikKsuDtlmyhouXJO8H4rpzOE9IpXK0EOs8D2et9n9vrL0AN7K7B2fhwJ1Au9zdzXqOeOowAFBlW7TVDLxPYa/He0VHDaimVz+xrKjU7y04YXetup9H7HSJmizkYUtT9m/VSYOZJpPWsZyb0
 wD17bAWh
 /MhWkpHD3aFLKvZNlvuDlf5pJdfOBSGwRMVavJXa2Qmuy5rRtiwWgUsjZ4E5CDzhBwGFMbWOx1B3M2QNnUCVMDH7bQaDVw8BwAgUq+HhUH9R0Hc2Y/gDJOzM/g1ZZFHU7O/RBjAaDGVSVe2IIWzCxbG29NIBksBTdeIHgsAvq7+1BF3U498Enz2EyIgW38LlSpKREaCcgAyJew672pMqruj6clWxh8jjCO8s1//0sQugRCH4p5Yj/2RFPW1t3BAVsVnrBHvNcej9ekSKCGyGtRVmUtaN5LkN//qvpqnja2++l9MwQaUeOZpWWVQ/klYQL9g0V
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 12:05=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.d=
ev> wrote:
>
> On Tue, Jul 22, 2025 at 11:27:39AM -0700, Kuniyuki Iwashima wrote:
> > On Tue, Jul 22, 2025 at 10:50=E2=80=AFAM Shakeel Butt <shakeel.butt@lin=
ux.dev> wrote:
> > >
> > > On Tue, Jul 22, 2025 at 10:57:31AM +0200, Michal Koutn=C3=BD wrote:
> > > > Hello Daniel.
> > > >
> > > > On Tue, Jul 22, 2025 at 09:11:46AM +0200, Daniel Sedlak <daniel.sed=
lak@cdn77.com> wrote:
> > > > >   /sys/fs/cgroup/**/<cgroup name>/memory.net.socket_pressure
> > > > >
> > > > > The output value is an integer matching the internal semantics of=
 the
> > > > > struct mem_cgroup for socket_pressure. It is a periodic re-arm cl=
ock,
> > > > > representing the end of the said socket memory pressure, and once=
 the
> > > > > clock is re-armed it is set to jiffies + HZ.
> > > >
> > > > I don't find it ideal to expose this value in its raw form that is
> > > > rather an implementation detail.
> > > >
> > > > IIUC, the information is possibly valid only during one jiffy inter=
val.
> > > > How would be the userspace consuming this?
> > > >
> > > > I'd consider exposing this as a cummulative counter in memory.stat =
for
> > > > simplicity (or possibly cummulative time spent in the pressure
> > > > condition).
> > > >
> > > > Shakeel, how useful is this vmpressure per-cgroup tracking nowadays=
? I
> > > > thought it's kind of legacy.
> > >
> > >
> > > Yes vmpressure is legacy and we should not expose raw underlying numb=
er
> > > to the userspace. How about just 0 or 1 and use
> > > mem_cgroup_under_socket_pressure() underlying? In future if we change
> > > the underlying implementation, the output of this interface should be
> > > consistent.
> >
> > But this is available only for 1 second, and it will not be useful
> > except for live debugging ?
>
> 1 second is the current implementation and it can be more if the memcg
> remains in memory pressure. Regarding usefullness I think the periodic
> stat collectors (like cadvisor or Google's internal borglet+rumbo) would
> be interested in scraping this interface.

I think the cumulative counter suggested above is better at least.

If we poll such an interface periodically, the cumulative counter also
works, we can just calculate the delta.  And even we don't need to
monitor that if it's not always needed but we can know if there was
memory pressure.



> If this is still not useful,
> what will be better? Some kind of trace which tracks the state of socket
> pressure state of a memcg (i.e. going into and out of pressure)?

