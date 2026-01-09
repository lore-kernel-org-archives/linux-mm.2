Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00442D16805
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 11:00:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64A4F6B008A; Fri,  9 Jan 2026 06:00:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 628E66B008C; Fri,  9 Jan 2026 06:00:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 534EF6B0092; Fri,  9 Jan 2026 06:00:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3FC466B008A
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 06:00:45 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CCC741AB9A6
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 11:00:44 +0000 (UTC)
X-FDA: 84312132408.20.34AF723
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf25.hostedemail.com (Postfix) with ESMTP id B25BDA000A
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 11:00:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=TtKgf9Ub;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf25.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767956443; a=rsa-sha256;
	cv=none;
	b=cahksVbeDMBa3t8Lu/Ocmyng9ekwcdo/tnvIOUZZBS/F5lOQh2HdvzxBfpVe9lFqQ87Z2c
	D/kkm1eavKkwXhpQgva+6fcuZHqU4/JSUYmmmOuIX5S6iVEvNthGvzZbfo8pxQOajKrX2Z
	rRXsXFZ+DFI9CfSsl6CTdaVjXsbJOs0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=TtKgf9Ub;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf25.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767956443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WAxQ7MQdYxU/tGt0pWJm8Xb00GKZdoezyggvKWirzVw=;
	b=OGORlaT4K04Q7hOeHCzaqXZEJMXTsd9lg0Iv0WPzK9G5E4xpKt16MupdWaES0gb0A3GtSt
	JzbTIk9yL+Xn3XaUDnyZXrdkrm0E+/DxHXJ3rkOOi7xYMr73H7xYLdMAHHb9XJoiB5A6WS
	WlfctY/yOBeug3EoXIYTKZ8AFKyUOyM=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-431048c4068so1743758f8f.1
        for <linux-mm@kvack.org>; Fri, 09 Jan 2026 03:00:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767956441; x=1768561241; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WAxQ7MQdYxU/tGt0pWJm8Xb00GKZdoezyggvKWirzVw=;
        b=TtKgf9UbtnITigmp+uMuOCzO2U7K9DZ6egkdAY3I0x4QzF5BIwJJ4dJByWSCJvV1GO
         8X5SbcMDhY4FmWujLzf1knDEmU0tQh4HlCu8ggYH5qLHLG27WBnlEVR5oNBdoNX54uX2
         7OwyXuiAOB/gSy3H7tGH59LOb7LsurMBKfMxhhZPoQT67wd+clVes7vij2Ag5qc6qn94
         Q/akljjMnWsXdjhapxqud1YJon+fQyPf97DHMEAfvvvwoZgMXQOyqMAPvru2YPL0It+v
         OlFcSAz0I5M89VblSMGerb8hdVDOmgrLxavS1cZUyukwI8NLlqDcWhAqcHK7fVfNPcvc
         H86A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767956441; x=1768561241;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WAxQ7MQdYxU/tGt0pWJm8Xb00GKZdoezyggvKWirzVw=;
        b=ofg2dCw6m7yM1jNj9FvJ79Y8oyRA8g6zu5Ss9RXuCtwCZ+7Q7m4lQAKmw8PEIzM445
         JZgjfF8atO/KY2KdFeeLlXSt6oCjFvd4EF7qT2l5E4xjBNGgwJIsQk2A741pPyOubftx
         rAqFuLBwftN/w7jlkyiNhBd0N6wIglo7QHrgqPvCFv9V0tWg5/Q+TBtezq4ghTUj9Kd9
         fR3Qbk8r6SluihSN+zfYHTaG5YsGrD9EeRQPIBCUijlu4FROJKnywWy4C3grbUQRaYsZ
         6hfeoCaU6c48ubkG3LQUGs5vIc8uUFlP4HvhcQMPpq5Kq0CYERu3gON1hXgz0iP6MvBt
         Wf5A==
X-Forwarded-Encrypted: i=1; AJvYcCXkfPC/xhfxYZ3DleSk714ep7P5yzMil8NScXIcvrg/BrYF4THoqEzLzjpZieTNn1a4bcnTqa2yCA==@kvack.org
X-Gm-Message-State: AOJu0YyBXxwDegAcbSDOhy9NrO3C2WFI2/m7EHg+vOdAKLQ7XkIk2ps4
	BE7ypbsD4rx+2kPVYDX8YjY/q9qsP04XYjuHgbovOBk20xQKi9GCAeYQjp/2NExhleI=
X-Gm-Gg: AY/fxX5R3skdwyuqlAZc47qhy5f3CGbc0q5ZEoblh3HWQG9HLuaJdtslx9xwwbOEK2o
	tqcvZP8HKHcxQ6A/MtqRiIlOd0yCbCiXrvlENf9uNVAwJq5jQRGpIw3vESogEoENni+PttFeQOH
	nl4zcMWuwcNUFk5Y2Yso6Rg3CKkLzUzLBUWsBrBXCIhji6aYQ3LWmJyars/qHyiaKtdrT7hUQE5
	PdlMVgdETSoWwk/NFg4YU2Y65NeT/uIVi1uU1hx2uS5JOy5uTPTgtAU2t1Ua/WQgY9g+peR3No+
	pBT480kndbtsQN02eSJ1LJPrtfa9RhvlO2w9HBUbJyZ2Xj/jKcTHO6ws9eMl+iMGXViXNMJmm4z
	vuBZGkW+ewN6UHruHJK3PnC/3ycnDrmyFGjs4qbKX7PzJo05s2xHgF20IjPZR1J0elApNInEwCd
	BZHJWQnq22JLT/D7rW9cH7eiD+S+vhmI0=
X-Google-Smtp-Source: AGHT+IGRsE8Hv/AUhz+iHbvTJwK3vPHDZw2H+8Bf3HHUP23TuJFtXMnG1VVlGoGvmO2o8IeTQqDYgw==
X-Received: by 2002:a05:6000:3106:b0:3ea:6680:8fb9 with SMTP id ffacd0b85a97d-432c362bf54mr11704014f8f.3.1767956440814;
        Fri, 09 Jan 2026 03:00:40 -0800 (PST)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd0dad8bsm22304319f8f.8.2026.01.09.03.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 03:00:40 -0800 (PST)
Date: Fri, 9 Jan 2026 12:00:37 +0100
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: hui.zhu@linux.dev
Cc: chenridong@huaweicloud.com, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Eduard Zingerman <eddyz87@gmail.com>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, John Fastabend <john.fastabend@gmail.com>, 
	KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, 
	Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, Shuah Khan <shuah@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Kees Cook <kees@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Jeff Xu <jeffxu@chromium.org>, Jan Hendrik Farr <kernel@jfarr.cc>, 
	Christian Brauner <brauner@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Brian Gerst <brgerst@gmail.com>, Masahiro Yamada <masahiroy@kernel.org>, davem@davemloft.net, 
	Jakub Kicinski <kuba@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, bpf@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [RFC PATCH v2 0/3] Memory Controller eBPF support
Message-ID: <tuxit3rxedp5ujprdnkzqarwbjw37izpp45u5ryn3tg5h4z7hv@a73ydhb2gona>
References: <cover.1767012332.git.zhuhui@kylinos.cn>
 <enlefo5mmoha2htsrvv76tdmj6yum4jan6hgym76adtpxuhvrp@aug6qh3ocde5>
 <a935563217affe85b2a6d0689914d7aba2ce127f@linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="6ugyd27enu6zatdi"
Content-Disposition: inline
In-Reply-To: <a935563217affe85b2a6d0689914d7aba2ce127f@linux.dev>
X-Rspam-User: 
X-Stat-Signature: g1j9warzcmgnpc57b9ncg6omzq88rph5
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B25BDA000A
X-HE-Tag: 1767956442-422439
X-HE-Meta: U2FsdGVkX1/PsOVwqTrRHNLuvrVylpQh7rpgL+ncO3uqe4xTg3cRBxTdjl4aa1NelLq93+eZ1hmu9y5m04jGYvSiKx69ERsJmjttNpKWwV5px8MXC7Znr8mpEUupgAXcbxD1Z8Zwl3CvdtzJt3CK3vOT/kKvZ7vlPaRVcVd2X+agfb0gwjQuT0TQ6pJZCK9nLVNYztTad6/xqkHWTt06VIQDz8yqWL+jFfbwvfZcGsRCaWrryIqhNTPoMPSf05fo6VenJIB3dkRLI7RW/Eik7ZDeUxv/1nCKTWra1WWTQZGtr8QRUGDaQjF+wwY4lK4HylVSTbd9M2y2Wp1n+sHg+qttHfqE3pcQvYFkG5LvsNQxUfasuuDm1Cwd5UV31eT9yGB369qx+UJGF8xY//a2Fx+k4ALHI/Rpg6dgBDE37UqvqEmlsNYBAuFuSXlMmmqIxscAp8Ab7E1sveU4q+H3gVUeDzAnFS2GXQWFRlNYo0zfEFtVmu2JFjuvXjhrR7bWn1j5ATwzoz2jRzTJFrX28gIuCnkXGWWYSWILRxUM9EQyL9/HCthw2BDGmu1/as3//HRs+9TxnubwO1dGQoOroLWQZ/XYvLhhPvHG5TDLn5r88CrA/CS17vM05TVfs471MiZiNieItm5r5WwdtMbR2VjaP92DU5oslwvJf/T6ItyNkPfZEreoaSCM7Vb0+NUt5myCoSYkxXTTm5j8BbX8e54gGuWjriJeQ+n1V9ZxG5v5AHM2xQdSQxlcwJJWMHEaf2j0a82RH+Hc8c8OKqP7JqOjeBxWHEMrkUgzWHzqsir69tmVPgeil8qrCP9cgZhJwH4Cu5KhWenfl6eCArG9JYD7tb22EbXgoT3L3mNKlsZj2LprRWdPITDdJK9Mt9lsu3iw1o9ifTj3H8bGtPITmW7uBT4GBeMKr6UQ7oHaoDEnwp4NtVjoIXvjwCi4ZvKrD82QTRRvJhwHpuvRXXL
 Rlo9K/4c
 yx+ApzfgHBHPnfQq+t0ZF+wL0pJzDbsEniHDNbY6pFe5vptnyW0wmaBWhcpQO6fxE2zBdr4D4dcVCCyR7suuA3veekU7LHt6/dFaQRKAWZVkPsZVDJjFLKm3Iq/L82xoJ1I7qpG2rF6C2b7LnPkepQwoEcQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--6ugyd27enu6zatdi
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [RFC PATCH v2 0/3] Memory Controller eBPF support
MIME-Version: 1.0

On Sun, Jan 04, 2026 at 09:30:46AM +0000, hui.zhu@linux.dev wrote:
> memory.low is a helpful feature, but it can struggle to effectively
> throttle low-priority processes that continuously access their memory.
>=20
> For instance, consider the following example I ran:
> root@ubuntu:~# echo $((4 * 1024 * 1024 * 1024)) > /sys/fs/cgroup/high/mem=
ory.low
> root@ubuntu:~# cgexec -g memory:low stress-ng --vm 4 --vm-keep --vm-bytes=
 80% --vm-method all --seed 2025 --metrics -t 60 &=20
>                cgexec -g memory:high stress-ng --vm 4 --vm-keep --vm-byte=
s 80% --vm-method all --seed 2025 --metrics -t 60
> [1] 2011
> stress-ng: info:  [2011] setting to a 1 min, 0 secs run per stressor
> stress-ng: info:  [2011] dispatching hogs: 4 vm
> stress-ng: metrc: [2011] stressor       bogo ops real time  usr time  sys=
 time   bogo ops/s     bogo ops/s CPU used per       RSS Max
> stress-ng: metrc: [2011]                           (secs)    (secs)    (s=
ecs)   (real time) (usr+sys time) instance (%)          (KB)
> stress-ng: metrc: [2011] vm                23584     60.22      3.06     =
16.19       391.63        1224.97         7.99        688836
> stress-ng: info:  [2011] skipped: 0
> stress-ng: info:  [2011] passed: 4: vm (4)
> stress-ng: info:  [2011] failed: 0
> stress-ng: info:  [2011] metrics untrustworthy: 0
> stress-ng: info:  [2011] successful run completed in 1 min, 0.23 secs
>
> stress-ng: info:  [2012] setting to a 1 min, 0 secs run per stressor
> stress-ng: info:  [2012] dispatching hogs: 4 vm
> stress-ng: metrc: [2012] stressor       bogo ops real time  usr time  sys=
 time   bogo ops/s     bogo ops/s CPU used per       RSS Max
> stress-ng: metrc: [2012]                           (secs)    (secs)    (s=
ecs)   (real time) (usr+sys time) instance (%)          (KB)
> stress-ng: metrc: [2012] vm                23584     60.21      2.75     =
15.94       391.73        1262.07         7.76        649988
> stress-ng: info:  [2012] skipped: 0
> stress-ng: info:  [2012] passed: 4: vm (4)
> stress-ng: info:  [2012] failed: 0
> stress-ng: info:  [2012] metrics untrustworthy: 0
> stress-ng: info:  [2012] successful run completed in 1 min, 0.22 secs
=20

> As the results show, setting memory.low on the cgroup with the
> high-priority workload did not improve its memory performance.

It could also be that memory isn't the bottleneck here. I reckon that
80%+80% > 100% but I don't know how quickly stress-ng accesses it. I.e.
actual workingset size may be lower than those 80%.

If it was accompanied with a run in one cg only, it'd help determning
benchmark's baseline.

> It seems that try_charge_memcg will not reach
> __mem_cgroup_handle_over_high if it only hook calculate_high_delay
> without setting memory.high.

That's expected, no action is needed when the current consumption is
below memory.high.

> What do you think about hooking try_charge_memcg as well,
> so that it ensures __mem_cgroup_handle_over_high is called?

The logic in try_charge_memcg is alredy quite involved and I think only
simple concepts (that won't deviate too much as implementation changes)
should be exposed to the hooks.

> Thanks for your remind.
> This is a test log in the test environment without any extra progs:

Thanks, it's similar to the example above (I assume you're after "bogo
ops/s" in real time, RSS footprint isn't the observed metric), i.e. the
jobs don't differ.=20
But it made me to review the results in your original posting (with your
patch) and the high group has RSS Max of 834836 KB (so that'd be the
actual workingset size for the stressor). So both of them should easily
fit into the 4G of the machine, hence I guess the bottleneck is IO
(you have swap right?), that's where prioritization should be applied
(at least in this demostration/representative case).

HTH,
Michal

--6ugyd27enu6zatdi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaWDf0xsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMSwyLDIACgkQfj0C55Tb+AhD7gEAqbDeK7bs5Q5B6uh4H3ax
vNaAumbDhzgQCFvmqk75yM8A/jgi6uwOxMpREcWR0EkkxBTGpymsLE7wBTJyBtKE
ksMM
=HyJ4
-----END PGP SIGNATURE-----

--6ugyd27enu6zatdi--

