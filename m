Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63A46FF8855
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 13:54:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C758F6B008C; Wed,  6 May 2026 09:54:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C267C6B0092; Wed,  6 May 2026 09:54:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B15186B0093; Wed,  6 May 2026 09:54:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9F0296B008C
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:54:07 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4421F1C0177
	for <linux-mm@kvack.org>; Wed,  6 May 2026 13:54:07 +0000 (UTC)
X-FDA: 84737138934.30.F6BA0C7
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1824E40008
	for <linux-mm@kvack.org>; Wed,  6 May 2026 13:54:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=cEhfVII0;
	spf=pass (imf11.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778075645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6KlB82Gzxw6Ep4hdvTnTO13cUo4z1IlE435VWxqkbhM=;
	b=qaZgQgJNxVCDXFzNJx+78Pcy2UCxLZh285W3qX1OzmaTVeHdCl8e4LmJx8H4/Av6dWHQme
	4Gjaatqfv1PC7tyPvjieiIxlxxxb1sIRkWln19kMU3OxiQFW2Y6lW9Mt5WYJKYbraubelm
	1ls6R4j+PKChxrkDG7TEsYXDV4vtPE8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=cEhfVII0;
	spf=pass (imf11.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778075645; a=rsa-sha256;
	cv=none;
	b=fvzZdQ1BCAeV1CfVzOTYPzWClwZdphL8wP5/UwmJw11cZ4FRnQXFyzdJMys8xpipcZhbZn
	lHLJyWhErUrCP2ZtIh4ihWAikcLoKqFjtwh4AdJXMuenyHSek5gbOIamXfA9LhjXjg/fqu
	etKmsf0TVwV0GQME0A5zAiGx5gY8u5I=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4891e86fabeso77472235e9.1
        for <linux-mm@kvack.org>; Wed, 06 May 2026 06:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1778075643; x=1778680443; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6KlB82Gzxw6Ep4hdvTnTO13cUo4z1IlE435VWxqkbhM=;
        b=cEhfVII0Fz5rI2a0TLtdr75kdg3FqcBKJ/45yka29KItKfmrUSGZAtHQrLptSkeyjt
         PketICpk54dKrxKvIkaS+Z33Be8M0j0vTEheuj+9BG6SI/yVVkefRTBsPl2yScdmq5Am
         Xpc+t+cDLxCrcHBzRxqEECtMS89xIbExVEeASW8XFZ/pFzC7beHm5HbXPjsG8D3OUNrS
         ElHT8RmqJVwnJDSb3vfXLY+zz2LYmsrjy0omqBZNTUU2i0YLOG8gbyjsh8pVpaj0+lOV
         j/i88CMDWJOqfC9Ob4DHlnWB+gILdZ0AdtzS53fEXZ+0PV2KYFUO3TGtIisyFmuAm2us
         N3oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778075643; x=1778680443;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6KlB82Gzxw6Ep4hdvTnTO13cUo4z1IlE435VWxqkbhM=;
        b=DUU3mjHdQ4DWqjnxnyo6hHhsU2DBu7vKJMjK8F4WfJq4AImG9ylo9yuShyzBNNYhVC
         hLhSAuX1vhRIJIFk0rRVbuCmUOZ8fwetQkjxaNOauKXToHhezRyQ3DB9usQfirQA9knJ
         47X9YXdzHMOCCAC3/SDVcNKsGjNb8BOZPUB+9jA7jTpth7PbXPcPp7/IiOWw089GL2NJ
         3rYY41Zp9VT+ElZN6zpgn0W3IufA5FBlTc9qZnXkHIFVz+09TzHbFrn7fzjWUB5q3msa
         uciQEHXisz75Z6VKSpZmPiYFEniMZu8p+g6QIqQi2Dva7oS0xz7+OMfElyK9ugFcuZbt
         Nf3Q==
X-Forwarded-Encrypted: i=1; AFNElJ81ZyatveQdaf2nfO4U/BeI6vitj83AtZUbBBBcHnjUevP6ABt3x6vrW8ou7ikQ7YRNeBfR74eIGQ==@kvack.org
X-Gm-Message-State: AOJu0YyYygK6JjK8+ic1BaDwKBKKLOkU7Ie000VfaxouLxvAbxPE/UcB
	CQKHvAHbhHfmgtLOt3vPCaPv6eKN96m+VxmVwITtmcPPlfLKFT7+pWnMGRMjyUgdqg4=
X-Gm-Gg: AeBDieu+ft3fm59IRQQjqybs/gb53o83QX47ZE2t5IQGxYIgRbDhnxOBY7rxS23EMfv
	4EKXwTofz3I9FzTBkKf2j7C/DUVagxiCfuQtDRcKXs87ZIr7BO29WSGGQDMtVAh+K7EGNbpwbfv
	crLS9q8SAao9WxHmPapziJklL/DOSTsSc9ZkZJKEGK4zdOdiNabxDCupBqA5lXKAZvs4w1T49bY
	NLaF9TNb2aRvYr2EqkkoLwJsrsCq2E3qQkAunJ22UlVgZtLH/g0GXMICjyzemWZtEtbWyj8Srie
	3rlSzGaEolHonOBCF1PEWOwtmC8OxPGzhU5igiczRgHxze3rh8k3kY0rLcdGUU88UN9jpzHzfbd
	IwSZcho9CJzIGEcerKGNa+XudFr23iRYDcJd6hEf0/EVeragVzW3g9Z2tLflvmOwwWop2tuBovM
	oTLqyya0oyTkutek0Sx8KrLr6HFzZlDOpAUUMdXPs9sRNEALzYLL1VCDLFZ3U=
X-Received: by 2002:a05:600c:c082:b0:489:6c22:e081 with SMTP id 5b1f17b1804b1-48e51dd3a1bmr46595295e9.0.1778075643420;
        Wed, 06 May 2026 06:54:03 -0700 (PDT)
Received: from localhost.localdomain (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e530b19adsm17343205e9.3.2026.05.06.06.54.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2026 06:54:02 -0700 (PDT)
Date: Wed, 6 May 2026 15:53:59 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Maarten Lankhorst <dev@lankhorst.se>, 
	Maxime Ripard <mripard@kernel.org>, Natalie Vock <natalie.vock@gmx.de>, 
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	kernel-dev@igalia.com
Subject: Re: [PATCH 0/2] cgroup/dmem: introduce a peak file
Message-ID: <aftB-cc5EhDXxCGA@localhost.localdomain>
References: <20260506-dmem_peak-v1-0-8d803eb3449c@igalia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="reykr6qmcqnxtkqn"
Content-Disposition: inline
In-Reply-To: <20260506-dmem_peak-v1-0-8d803eb3449c@igalia.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 1824E40008
X-Rspamd-Server: rspam06
X-Stat-Signature: pygzm4ow8makykpcta47xgpigaby6ujd
X-HE-Tag: 1778075644-124150
X-HE-Meta: U2FsdGVkX1/+J6R6fNxBjein/eVuuGP4F2PQymX2SFF+B69Irqf2F0rmkO9ZuLEvpRo8Drx+00GGjsYtVERRKfBRzKgrV4BFuj9a+wGtOfI6T7stvfWAee4LwOydoywR5D7tLzrjzrCZw/1OnLNYegSGczFZQkMPQ2M9hkTFEZw3xTlFzRWtqWzHEg2cicuXxD9OC/OogG3dZAkNxbXT/Sjh46W0TMwEV+/+k2RCu+iyr2zTUAkR6zg17mSQKZ1HCAql1yy2DobGErb0QMPf0WYlNSMLyUMpNGQQqL8zXUZYEtY+ELzh6ihCBBm64Tjg0TrY3tUebprgL7JfLB/ZCmyr+GLEm4SwzYmukSY6cssN4IreAHm3VI7Z4QRDqd5S7GVY2ugfliP2YbpGiYYLvYsfgmG4NPMwByPqn3gwmxCx0SZb4y2DIw5vXXNN/LNUG5JVmbwH/Ph8/KCd52ZhJwPBwUVOa90CMBa1HiwnrdbsHB3p66iCdIgKeC1zFxMsyy6ltt+9MzWTnUozMyPT7YmgvGzCdwR1zJqMTxu18YdXdtsuW4rwnqJcZWk/udlfjEIFVRhsV6FDJ/YgQsT+a7Ojyg/N8ep/bmy/vnyXpCIJalKIU+m6zXQZDBfszrir6xTOqzPyPU0hssXHdhiUAJs8YDpZAcXUn2uuJiZmk1qWcxV8mDXBky9MvyNeFnp+YPgSVj0zCWWsuXYCjfb+Qm1B1KFEucKBo4Hdg3lpCu8Ti349TA/tI75WSNqg96+hD+SWR8QNmw7vKn5NliaouCFhjk8MwtuMXurs7vOPuLS6p+5tHUdjWS5D0+ZdR9jiFrGsqDHwIxYqeZgQtQ/HG8A+TeXvPhWNWI4xuG+yIgVmVNLSDMc5R7v0jTDCFKpaX6zL+GCxgIbi73YdwRW53lHey+5usAGojclKhqme46awWpNIdDmz5RJaqozeLer9YkHYys9R1m1tlzn5OBF
 NgLlyeFN
 AlK5o51nwOzQj9fCW3oTfHH6xyi85wi0FIlwevHpP0U6K8phJLwLIplbti4AUWV5W7u4fPUalML8aKlpseU/QcSwBhKZp50jjY6Ntbr9XGk+DS/5whJiy4iyDRF1DDuUYIh1FcyREUNrUs25jlvsCeSe/+DWlj+cwAhWREEnBuLvgK77VMRPWwZDVy1QayDFM1EM0JKiP7MSpY4tua/RiFUg9CkLSKbcJZtqnSihazm8X0UwXeJB3MSmZNNcyQkQBdCOOjG4Jy9CniOHb3cIPwVAfz78btM4G1bN0ttA4bTetFAYJAVy2sNQJ+yPPMFJzkMV9PpUy7ib+MkK9aQkWGmvL5ZEc0b9c71TpCy3bBFjtiqwUYCA0cj8cVjlhlaXkOFJS+PlHM/ClL9HfOGLEnDvjheqiDVAT9Bb35K0KVrD0NqoYhfUlzW2LslSMTZI5kzPqJXgYyC4eHfk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--reykr6qmcqnxtkqn
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 0/2] cgroup/dmem: introduce a peak file
MIME-Version: 1.0

Hello Thadeu.

On Wed, May 06, 2026 at 08:58:23AM -0300, Thadeu Lima de Souza Cascardo <ca=
scardo@igalia.com> wrote:
> Just like we have memory.peak, introduce a dmem.peak, which uses the
> page_counter support for that.
>=20
> It can be written to in order to reset the peak, but different from
> memory.peak, which expects any write, dmem.peak expects the region name to
> be written to it. That region peak is the one that is reset.
>=20
> That requires ofp_peak to carry a pointer to the pool that was reset.

(It'd be nicer to have generic data in that generic structure, at least
some void *priv. But see below.)

> Writing a different region name will reset the different region and make
> the original region peak get back to its non-reset value.

I'm slightly confused by this fds x pool matricity when there's only
a single slot in cgroup_file_ctx::cgroup_of_peak.

The intended use case is that users should maintain one fd per pool and
not mix it up?
This stanza would better fit to cgroup-v2.rst proper than the commit
message. Or make it simpler and start with non-resettable peak file
(like memory.peak had started too) and see how it fares. WDYT?


Thanks,
Michal

--reykr6qmcqnxtkqn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaftH6xsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AgWBgEA78n1QkHtqLX1e7j+HqA5
/0hULtuyP0LvN9r2E3h2FskA/0/p9uNIv1XoJqaVguIXjyHW7Kp9SnAM0puHxrMQ
TzMA
=pFLa
-----END PGP SIGNATURE-----

--reykr6qmcqnxtkqn--

