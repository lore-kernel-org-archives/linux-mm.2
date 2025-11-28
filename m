Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2366CD116E2
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 10:44:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BD696B0012; Fri, 28 Nov 2025 05:44:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36E616B0024; Fri, 28 Nov 2025 05:44:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AB3E6B0027; Fri, 28 Nov 2025 05:44:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1D9DA6B0012
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 05:44:43 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 73A4613AD34
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 10:44:42 +0000 (UTC)
X-FDA: 84159682404.02.AB5652D
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf05.hostedemail.com (Postfix) with ESMTP id 98A0710000C
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 10:44:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JC0hv+gI;
	spf=pass (imf05.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764326680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=/3UNOdECGML4434dXSC9vT4570MnbL2LpUQEqXY2+FM=;
	b=bdi96iJEg8XAhQdEnhlJFKeHR8wdN7SuyDYzgoT/k6RP/rEqOcGE9LUhUegCJveF5/d6s2
	l0WMAob2BL5P2joARbhNivNYMECQ3DeHIGKVQzD77xg4MrOflAEYjBhzwxGAqpdDjSZc5e
	9xXprrO7mZ3eapt6WzeL+CFUbXBY+Bo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JC0hv+gI;
	spf=pass (imf05.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764326680; a=rsa-sha256;
	cv=none;
	b=XbsMguufEbyGER6DFIPcMF9Z8tQz1dOKnXRRlerc+1sqUN4M7x8N8IWtIC4OIbi59cWVYk
	Grh7f01uDVy1dbgd3u5bnqU968cD6zsAsYLxGfjz1JFztCANmw1u8wFkZydn4miOOTVpXA
	B2TOZqK1mvzgD34oPWzmS+ZZyTZcfeQ=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-34374febdefso1862231a91.0
        for <linux-mm@kvack.org>; Fri, 28 Nov 2025 02:44:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764326679; x=1764931479; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/3UNOdECGML4434dXSC9vT4570MnbL2LpUQEqXY2+FM=;
        b=JC0hv+gI2+3cr7VB88znGySehCNe8K7KeQMbHOaxgiJFvDwE3OJKbdNVYB1IsOem7I
         GdfPqg1fuXWo0SzXT40FNlulr88qu3q5hTOqVFqCstZ5Iw0GtBPCEC9Nbac+d96Y9CLZ
         x6yrHOD2TbmXZ8NSuUKhaE85vbaCKOOA/djwqGq4daj3lMBxgiRHgmzubAhOAYeCilXp
         LVk0ZSwDsBw+Vq0hc5d5AKUdbfjg++Lx5MTEiTQdW0urg4F6uw1AsRpxbpZ21dO6GhgE
         6n7SkF8D1v4zQzbahlp5GWxikr5EB2e/ySCtWExyusiVcTNeC93ysRpfUEuffSCryvt7
         LOHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764326679; x=1764931479;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/3UNOdECGML4434dXSC9vT4570MnbL2LpUQEqXY2+FM=;
        b=LUNaMzi6UEydFD04UTFJG/5jNlTikCj9QQQahCYzqYa0szZk4cO+qhJD9jAx9XXwBo
         wItr9AG3tEwp0Sz4D90d7pl9BmMJADv5t5sys3gv7wNbwDunGawUIwScMLMvCTS+83kb
         6cAXfaTcliuNM7dgcPnEpgwc3L6YG57tFILzSBE43+fRbBrGz++JULpNWcKPMaZuUPKh
         e1wS7akz6lsvdFGVR8IP6eZe0RS5HPz0Pn/ldjzo8nI4IVMPNIWkFdqTwlG546wZ+oTd
         CfxzIhgGRQTJx7Ug+MCxy0SZUftlcqWKSf9pVOmUzvRyd9XTS1bPtVQoCPseE8NVfGkl
         2KkA==
X-Gm-Message-State: AOJu0YwFLuyQZ7LuHUpnN0E2yFb59yenLWT/kq3UDuY4Uddr3MT0Ilwl
	zqrpQwVq6p4qwNri02t/BJxbTEv/mloYK45BN6Svqf4SORVWeHpJecsL
X-Gm-Gg: ASbGncsM0lda0Glz5MGwdXNW04vvgIW9hadl9vDJ6/qNqhXTW1jJkUJQPgK2X6sMkDT
	jov90udCBewEIXd6/zd9xANgzwwWoEqjBipasVaGYZoV2qGTL/x19DKeuMN3hJSDGoeRPoizIXK
	p3lTiHiRdmnLyGFdq5ESrjGbkKW1kOjZAbqFvy0n3xUz68d+tH3UJW5cWOL92dFc4co+2zo1sFV
	1O8ArVIb0J7gdXXIE6Uc0dZJP/WTFMp0oqpr0TkMf+7aLTO4VgtIlm7nLb+gBhMWom+udhDNPC3
	ePapsvKcPMxA2JKDHKtpus7UY0w9uUz7Puh+UFr3+LwpsK5M6ZfAm+woIy9GcV5C6FTqxE8G4IS
	msmNWazeqf5bLIr9SSmruUOBDcjJGShjG04e32yXQ0otQCkE4HvJ6K+zXS8N6lzU5QpJfeuGkeE
	Zzc3Hu9A==
X-Google-Smtp-Source: AGHT+IHySGrEhslcddiDsWyGiuUGKUH3oJsCwwn3sNjphn+JRsycDU0fK9T8rv64Q7YwDQvk+pmHog==
X-Received: by 2002:a17:90b:48c5:b0:345:badf:f1b7 with SMTP id 98e67ed59e1d1-34733f3eb64mr25904802a91.28.1764326679392;
        Fri, 28 Nov 2025 02:44:39 -0800 (PST)
Received: from dw-tp ([49.207.234.175])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3476a7a4c12sm8416592a91.9.2025.11.28.02.44.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 02:44:38 -0800 (PST)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, Andrew Morton <akpm@linux-foundation.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: Re: [PATCH v1 0/2] powerpc/pseries/cmm: two smaller fixes
In-Reply-To: <189ac734-b194-4b52-9752-18d8c0b71377@kernel.org>
Date: Fri, 28 Nov 2025 16:10:47 +0530
Message-ID: <87tsyemocw.ritesh.list@gmail.com>
References: <20251021100606.148294-1-david@redhat.com> <557b5500-412a-4d26-8c4b-147c9a00d5fd@kernel.org> <87zf86n3vq.ritesh.list@gmail.com> <3cc7d401-c77c-4ac8-abb8-c264fbd9aaf0@kernel.org> <87y0nqmwaz.ritesh.list@gmail.com> <a3bb0e8e-72c9-4a9c-b347-e899ae29b289@kernel.org> <189ac734-b194-4b52-9752-18d8c0b71377@kernel.org>
X-Stat-Signature: kei1fuyb6ayrk8yi6k195np3yhgpsi9d
X-Rspam-User: 
X-Rspamd-Queue-Id: 98A0710000C
X-Rspamd-Server: rspam09
X-HE-Tag: 1764326680-720620
X-HE-Meta: U2FsdGVkX1831boLktAW/Rvzzvht50wKspfBKH3vCnAnbGcNPIvAE79ps4uVhjufeIdrYsEKLNvK16+iqSQ9vG0uiP1PosA6tSWb6EnEzAb2ngasTk6pXWOsUOrH0jTxNmcrLpw5L95z8qXPA6MaoUNHm2pHVYEZWoC1Lb9GvBLXKG7H+CU0VogKLDQdLy986uDdv4RMi2IyEAdkt01qUI9I2czjlZqtUOS5aogpvbz4yl+uXwqYRIejkWt+tuurmqNX+n+37ia0odWFKeQEdtbkUSI3FOrzugxK+oPu8F6ICtYb3AvrLRlmDrupWMbdiEqvAaL/HCYUeB+/8CbNrS1m+Vy1r8N1BBhNyWBrePOmbnXMOMe1VsAeVm7doopFpEY/3PxBYA295BqWSUgqiWcviS/vYp1wWqSt5zow3oLTk4DZSynQGmCjQKUb5JnOckULp7F7U/yRYVg0FoZ89ObUDdz/UJTnn031xTBLJV2rafSsd7Vlj4DG9qi7tfn+B2vDpZbIm/7LUhrtSjLGKWQwZGSc3cLYiUOyop4KpvFqhxfzJzLwlulg5vw7Uvgo+wmVAvuLdgGqdkj8Ty4xOBOFcbfzgXWyf9az7Uhg8+DfdPY1/Fs1kNSFpN6qkSHVHVSkMyAppSczBMS5yPNB73knZN8WhPuyEdxFC922SsbUBVPMneMUg18Nn32ZgUVjiqijg0iEWxaEhTYOEzcnWgvRpP9nKwdo6Pp/1PyAo/TJ+8NfS7s4lsygvpjRSN354XVswVd6esyF2AXLVDTehsFjE6iGrK74u40lroFmkvivut3Ewqp/qd1W5QL/SYSMRZ5nZfnEqhroFk4NVgCqsORyM0noa9OmCzWIXCQTFfQaIzfgaSRe3jVWu/JOV20iN2roqVr2/yuavSqNBL1fxvt7fT9sC4w7ZZvp06dGgcd7RKGOkFeFmPXaMq1kaXHoiJpoLkH5KJdROkRnSof
 gz5obnN8
 HFJk0f/w+pStzPKWYXg0a+pUPrGqkousBYFl/9DwVanw8PBgjMNPh494kImGDfXjrwrLUKdMbfkLe4Wqyq61WpdaD6bYMC0hkdQ/3afQjzn9LVIM1zRE1m3PBg231Wb+48vo+AFNLOAKDevwrqAaS/13rlfqzvo1PoDRPFAsAfHnviJe3kNchVjQxJ1b5VLPIo/4Mdea3+umU/XYEqGYJQi2YTq0+GbaE/GNPjEgYewTxXYzxokj1+YgEpszhfZrTMTOQRz7BM0BpYUKM5XxTepj8rKROeCUAydnmFOS0VVlZiRc4GoDAME0exyottGz7alf+2GPNNA2g8GIp22ANAv84/OLPSEovzpJoXs3GzMncf9oEYdBUPtJistI6H7TIlg04D6qG49c1toWMmUp00PaVHDL3CgyrzKxfDWFLAJ51VHRaqGV/9HANhSccvi93tparVLbooXMIM8Pgzm1XeOoEMA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"David Hildenbrand (Red Hat)" <david@kernel.org> writes:

>>>
>>> Right. Let me give it a try first with pseries Qemu. Otherwise I have an
>>> access to pseries LPAR too. I can verify it there.
>> 
>> Ah, now I realize my problem: I tried with Fedora 43 in a powerpc VM but
>> the modprobe didn't do anything.
>> 
>> Looking again:
>> 
>> # grep CONFIG_CMM /boot/config-6.17.1-300.fc43.ppc64le
>> CONFIG_CMM=y
>> 
>> So modprob'ing won't do as the module is built in.
>
> Right, so doing "cmm.simulate=1" on the cmdline in a Fedora 43 VMs 
> properly creates the CMM device.
>

Right verifying using simulate mode is very straightforward. Thanks for that!
So.. using various random echo X > simulate_loan_target_kb on a VM...

~# cat /proc/vmstat |grep balloon
nr_balloon_pages 16
balloon_inflate 1638
balloon_deflate 1622
balloon_migrate 4

-ritesh

