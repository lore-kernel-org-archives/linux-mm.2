Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DD06CA0EE8
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 09:20:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B852C8E0006; Wed, 17 Sep 2025 05:20:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B377F8E0001; Wed, 17 Sep 2025 05:20:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4E6A8E0006; Wed, 17 Sep 2025 05:20:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9120C8E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 05:20:48 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 447B21A043C
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 09:20:48 +0000 (UTC)
X-FDA: 83898197376.18.2D9073A
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2780A40002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 09:20:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=IRGfObSw;
	spf=pass (imf04.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758100846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mfy72Mb7ZknB0z0xXbtqc/r/yzrvqlFzmLASJN5p7Tc=;
	b=ObRqWDs52az21zgJS4fFNEr025kyNt4P/N1ItTJSKR6I1zYH6OLcLHl8N6EIIJGOUA/6Bp
	rjtAqrKimYTIaSGFxonUcAiLqF7079Alh3wLa/24942iNwmooDDiIJ8ct+Sg9N9cbm+f6p
	eiws5mnC5Z2l5aRSwahenYO6tCwgwVA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758100846; a=rsa-sha256;
	cv=none;
	b=tUiOWHvs9KFarX2kAXclZQjnZqrGWgZt4Bo4Vv1VbU/ZsRblcwapLs4ZTHuitWsLVX/Aqn
	I6A3myzoNimSUN09XEi0AtpErZnawEcerllLKsJIZUeyvL9LWTjjj0isBBjC6+gVmZCvay
	2JIlGE0AbKSVpkC+4mRrFRrQ+Msnphs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=IRGfObSw;
	spf=pass (imf04.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b0428b537e5so876356566b.3
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 02:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1758100844; x=1758705644; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mfy72Mb7ZknB0z0xXbtqc/r/yzrvqlFzmLASJN5p7Tc=;
        b=IRGfObSwakUYkCSJMbDp7NQ3JG9JzfWogSH2RbmN3NbBmFaaS/W2BKCop2gzLMkJHm
         aa28wgYKAfTPSGysLXPgSbaQc6f0aEcIQHpzzkjT+b9BnmNWjfPTUmAGlE8tg1sLyL0L
         XB/mRt/KL8I5PaLOCw64ujyRYvOExmUlhVeppBf06nINTP+EOsmN0Bf12uRxezZEPwWP
         IMP342obJb10o5J/WS1N8stDVzXYmZ93CT1QSkmgcvpw9ybI4f8yNoZkPbIuPVT5wxuW
         8h89USk4TtnHr802/USreenNJ1iVfptklFUkI7gK/fRzq4CCiKcHAszLYqoK1vncP2rV
         3GKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758100844; x=1758705644;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mfy72Mb7ZknB0z0xXbtqc/r/yzrvqlFzmLASJN5p7Tc=;
        b=sKHrtBHifRkHd70EQwiI3myR6++2IcsdDg6fI9Ir+mWGmuck4x+yX9zYTTgBM73g9Y
         uI91YeChzoQXrzO4r0wWR+FGFZAn+Hgh3QHeUfMtuouwvl5KTBDLRLYu/dpLW1xLWNn1
         iPaA8NQbYNsQ/FG9GyXdSzbuZTtOFZ63TRcGrLs53gDcyeNUMLEQz/hRhL/DRUTgh0pO
         ARESWXUdvJPcgqU1TtWFPNVyqAygiWLL9+ZRuGp9meQrFhXHGEMNT11NDOP4IvNFyrBV
         Oy8ar+/uBLBsIBDR8Exf8hOszP/13Dqex3A4FsbVjhVeNd775W3jTTRkFqfcc2/y95Ix
         2/rg==
X-Forwarded-Encrypted: i=1; AJvYcCVqxla6vVQlkV/mXbwuhOQLe7J/uLZuOLWNGRHv+JTfR6O3downBoOR0wJPRapir+CYTrfXZVnrHQ==@kvack.org
X-Gm-Message-State: AOJu0YxMEifLXUB3QdxAofVnyCvDCo7Mn5AAnVtzfwefK0vPxy9IsT4n
	6APmkmi4ZwmRHNkicgp0hLZYkqOQBmjs3pLbk8spfpye7IHg2Y4Ruk//N/LuvVI5o8Uf+2Pcn+C
	oghnFG2thCn7MFRh+dT9eIGZdh9dmn93WlJFO+s8eRA==
X-Gm-Gg: ASbGncv6RA4diJ+Wp2/lQp4Pnj4VML5EYTivQCGl/rUQPzAXJAFuzTeDFjtWkFHTi6b
	Pa8DH42D7zUEaBeHI2hvBekCEopZ9LSg5uWvu5LazS6qYVcIblcAOKmbCAH99snwqnGuAeqewKq
	lLWstKeyPcR2nEhgd7XWc/Bc5gdNRUqelQtIVF306i/fCHCG+kGYPOSrGT07Q7Y0nLmXyTpV2QJ
	qT4TorZaL0w9AOdsQhmfFpXrH6TRY+lkgicno5cGvAS64A=
X-Google-Smtp-Source: AGHT+IEuwtAHMUHjO1x3ENSlxdOmbju+xnSnCyHh4cRztllkF7bNH5RwzXT8gyIuvTUrZr4/rmjjgYdEHERK/tIiwXE=
X-Received: by 2002:a17:907:94c3:b0:b14:53a0:5c61 with SMTP id
 a640c23a62f3a-b1bb4337342mr176847366b.12.1758100844320; Wed, 17 Sep 2025
 02:20:44 -0700 (PDT)
MIME-Version: 1.0
References: <CAKPOu+-QRTC_j15=Cc4YeU3TAcpQCrFWmBZcNxfnw1LndVzASg@mail.gmail.com>
 <4z3imll6zbzwqcyfl225xn3rc4mev6ppjnx5itmvznj2yormug@utk6twdablj3>
 <CAKPOu+--m8eppmF5+fofG=AKAMu5K_meF44UH4XiL8V3_X_rJg@mail.gmail.com> <CAGudoHEqNYWMqDiogc9Q_s9QMQHB6Rm_1dUzcC7B0GFBrqS=1g@mail.gmail.com>
In-Reply-To: <CAGudoHEqNYWMqDiogc9Q_s9QMQHB6Rm_1dUzcC7B0GFBrqS=1g@mail.gmail.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Wed, 17 Sep 2025 11:20:33 +0200
X-Gm-Features: AS18NWB7XvnaQ-WcvFZZGW6kOLpaf69Y5rLJa_6Q1pxrO9zJ4eZ1OfMv2xVqu3c
Message-ID: <CAKPOu+_B=0G-csXEw2OshD6ZJm0+Ex9dRNf6bHpVuQFgBB7-Zw@mail.gmail.com>
Subject: Re: Need advice with iput() deadlock during writeback
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2780A40002
X-Stat-Signature: 9rjzk1bbbaxs4r9a5m6j58u86qxmzxzw
X-Rspam-User: 
X-HE-Tag: 1758100845-78975
X-HE-Meta: U2FsdGVkX1+/S+mvD9KuCzKQvoAkqAfnKlMeIGx2ANwkpcXXbr6LeIlME/BpllG46m84lOdNaOBCqH86AC5i9x6KB+/wxxNcSBwZgi9LY+9mIjb4Gak4RYiYlXyBcWuBk7brnmQYsGrG46CeGXPxIuL2fKpyhhyB3vKe9ASLlEzKefZVarQKjqAae7BIiQL1ds/9bE79o/FqJ2T3Ptx+9R96jlPYZs0mzU6/z3DdEjlYbcwdZ9LjVlB3LwDnAsR0Ou+mzH8jtOqHOj++c7nEYAGSJU18XPz8ZOGK/JA7Nu6NtxhdnV1STsi8QR42sFSlMU2dWdm+wBJKHo73HloY43bVH4yacDS+lA9Pq4dUWX1aIKXsM/Cr/egUnGpHWw1ZHISHmQectEq4azNMPUIs06KQdPD1QRfYyJE4/pd+XumHsvjEP/iuInlrM4KALvIoUaf/Gvlw73H2qafH6Y32hL+jus/bMEcN89PG0QpG/OiAbqkaWA1TDOVusQaAZgJAnGEYPRc9wmSJ8EtynXRU8RfgxGVSDgqIH9fk69qBHGrZFIEhnyH2+owkAYwy4UdmqZCSafda7c8DUFBS/yn1WHqOa8dHbCnpQStG3gD9kzuu3cVfFpxCOxsbTuFZsihMlgCgK9ziA06aW2SyKCLMN/JxH0KmQ1G1jSgexGUanLdzBH54ukAqRMWzl8DSQ+Ih9RHE1sRbqTplC45CuTmg/qPDie0eDycyV7zGnykifvUgq10wwlqCiDc3hsjL1l2O5Fy+R+iWDyFzU0lcgijfZvyEiOdSICrPp6MjZWPcvyEKww0viEdXtFa6nKSbQIxeApgi46wZMyXmJxQrnrm1PzvwqRn6JMtvmBGD4AaRmRCOlbNy8kIwkexudbQ5PjBrRku5gkoaC9fzTkBrLD/8VwHkKzlG6prPQJg/xudz4/vdCPUhxHZV1KAvAT3D1xeGA3gDtN/BcCaMcnVE5GB
 5gxDsEpj
 VRXFUR2ri5Gky1uER0bi9j2l6eMOzCkjvxoFqmPb0fE+6EiCWl/HT1gwQwibNG6rchQGKVPEkbNKjopu3fMGaaHD4W4ECBCYQJWpExz7m3yrs0ssgvWK3l47zsBpO79V3TLGdk+lCKDNyblmF3JFScDmQpDjfGuflxPyQDNeWH65ObebMxjmNVMgpZu7I2eR8lmDIte17RC2WUBenJ/bJ6CFq24BVr+ACeHmEs3ktHInHHjbirJgcxh+pjJnLYkitVzT4sHuVxCf3WeLQMhUTRKERBpwia+J6GGyO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 10:59=E2=80=AFAM Mateusz Guzik <mjguzik@gmail.com> =
wrote:
> There happens to be a temporarily inactive discussion related to it, see:
> https://lore.kernel.org/linux-fsdevel/cover.1756222464.git.josef@toxicpan=
da.com/
>
> but also the followup:
> https://lore.kernel.org/linux-fsdevel/eeu47pjcaxkfol2o2bltigfjvrz6eecdjwt=
ilnmnprqh7dhdn7@rqi35ya5ilmv/
>
> The patchset posted there retains inode_wait_for_writeback().

That is indeed a very interesting thread tackling a very similar
problem. I guess I can learn a bit from the discussion.

> > My idea was something like iput_safe() and that function would defer
> > the actual iput() call if the reference counter is 1 (i.e. the caller
> > is holding the last reference).
> >
>
> That's the same as my proposal.

The real difference (aside from naming) is that I wanted to change
only callers in unsafe contexts to the new function. But I guess most
people calling iput() are not aware of its dangers and if we look
closer, more existing bugs may be revealed.

For example, the Ceph bugs only occur under memory pressure (via
memcg) - only when the dcache happens to be flushed and the process
doing the writes had already exited, thus nobody else was still
holding a reference to the inode. These are rare circumstances for
normal people, but on our servers, that happens all the time.

> Note  that vast majority of real-world calls to iput already come with
> a count of 1, but it may be this is not true for ceph.

Not my experience - I traced iput() and found that this was very rare
- because the dcache is almost always holding a reference and inodes
are only ever evicted if the dcache decides to drop them.

> I suspect the best short-term fix is to implement ceph-private async
> iput with linkage coming from struct ceph_inode_info or whatever other
> struct applicable.

I had already started writing exactly this, very similar to your
sketch. That's what I'm going to finish now - and it will produce a
patch that will hopefully be appropriate for a stable backport. This
Ceph deadlock bug appears to affect all Linux versions.

>         if (likely(!in_interrupt() && !(task->flags & PF_KTHREAD))) {
>                 init_task_work(&ci->async_task_work, __ceph_iput_async);
>                 if (!task_work_add(task, &ci->async_task_work, TWA_RESUME=
))
>                         return;
>         }

This part isn't useful for inodes, is it? I suppose this code exists
in fput() only to guarantee that all file handles are really closed
before returning to userspace, right? And we don't need that for
inodes?

Thanks for your helpful advice, Mateusz!

Max

