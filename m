Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0C32CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 09:46:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29E098E0008; Mon, 10 Nov 2025 04:46:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 275498E0002; Mon, 10 Nov 2025 04:46:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B1CC8E0008; Mon, 10 Nov 2025 04:46:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0A6938E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 04:46:21 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9FD1A4CAD1
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:46:20 +0000 (UTC)
X-FDA: 84094216920.30.EF4CF94
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8CCD840007
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:46:18 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=GehTLk4A;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf04.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762767978; a=rsa-sha256;
	cv=none;
	b=aOALpPe5F8TDrgxzk/FV+RBENbONXAOpVpZCTy4aRljjdjIv+2Tsa2F61HcUPa0MsADPj7
	qilGl3AEnqLpveEtuKA8/HfAW8qmiVvvYjpUV/r0auh764AL76Ag9kvlbCy9vGwjDiw85X
	lejcXTSBqr9STTyXsYqWgWiTfnKsMHc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=GehTLk4A;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf04.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762767978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7+ENjiuiICq/dHaWISCwIQ30N8r+q3a2JUSxj4I5SZ4=;
	b=dzcyboQvs/ny2cI7Q2iNNkkvopMMXSCZxjPu0ZV3x18qvhZve2E3IDYmCQIpQOh2BXItx0
	yZgFnVNiK9ZqhTOl0CxtdT2olZ2r4/GHcu6DoiUmxaUkj+YvqP3ssHOwpVigk51pcOjFXX
	GG+rh9WPll7VskE5a6y07SAq6bazxnc=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-641677916b5so2410567a12.0
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 01:46:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762767977; x=1763372777; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7+ENjiuiICq/dHaWISCwIQ30N8r+q3a2JUSxj4I5SZ4=;
        b=GehTLk4AzvC6dJCndXePwW7tufc7ZSVQLX8AX7g3hNudbSCtVCeVsVq6gI+PzfliKT
         14XIj0u0XIPF6uGQ/UFsECj8qsghbUyJgHjiJDVeFNSk0Mx/Oxw8Z81IRmW+3UTXt/Ak
         oMPhyNLYTZwL5DUUc9WMp0J2k2fGgXi2c8MUA0g+hEiyBwU+J+CCJcVo+lReJG1/PeMd
         74fuuwtS4mWNxaaAVssqSDQCrOikXuHdyeM/cRGDNcXs7kdgQp2nPBnUXu+z4j/z4qYa
         7PXL1mnFZYDwJgymYR0Mp9kJL03KOvwGeLIhLY4WZkL2Jg7Z1Q0QYM1IMaksyx+sXIKn
         UjKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762767977; x=1763372777;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7+ENjiuiICq/dHaWISCwIQ30N8r+q3a2JUSxj4I5SZ4=;
        b=pM846+T2sRFQPCo41Z7/BsNDQsLbbZ+Ud78mm/oLa4g2+azd8pIrkffyRj2sKoUCxm
         ZO1oSsiT8XrYz7bN+A619lGtihkSOgVNeIEztm3P0HekRzOmYxhD2xkNH+9ljiga+UFg
         hDbn5GMiiSmjB53Gig7c4ASFsF7zzXNWggPr9a0STOTBJ5dfDH+0vYMmZCgQkfjx/X1U
         tlISB/mz1qNBUhcArz1IbK9vcowLfXRcipgMlZXh/aL4iZ3GOX75/14heuohnvTpddfB
         QlYUjwzmWRL6EQipwxscfxeToOIRojJMv2JYBcYUa/p9Ffk4D9hKcw9WpUDy+QGYXDxQ
         opyw==
X-Forwarded-Encrypted: i=1; AJvYcCUWnA+annWahz3jGeowCG799f45fNJddTxjaEVBxK15nO5s/VRmWfpOgauGdEZFOxNmKWdmtDH3nQ==@kvack.org
X-Gm-Message-State: AOJu0YyNXboZJhfBs9Wsoss/yzD3FMQUWyLneb20A160N6sIsz70Ixg1
	fSg3QAZ1uOgpiRF/du5JwgUp1ap2yHZytyVyQ4rCfeip+Zjk2alsBWb5JIm1D284VoE=
X-Gm-Gg: ASbGncuDSW+qp5AOGDDqf1ou7DxK3LwF7iQ0VCZzu/02+O30cIZO76xTfHyM0KEqaAN
	XOunW2G1l7HVA2pfFIdNd4Dst2EKskQJl61X/MZszpHbvMfJBK6mX9I+T51LkQTGqJ6hwf0JJkK
	bcAxZakBV97lEJNytzcziO4pVu0QPidNZx4MkyDJV7ZR9yn8ho+vT+ak+98oeUcxsWPSUrKQW7o
	bNYi4Qz3yYFwtva4wI1H/8FkzCnWx3yqUnMN0kyhR2VAGdDmNfMEmWo4s7Jj4gfxuN2rqrwL6m3
	LF97g6CHf6gd3HZ9/ga/j77HdDJJygBuFrFmfm40x2HGqsE21cV9Q38Qhw/AlaC9BZMEluOIisJ
	6evduu93pS70odpbFWVfhUEzlz4xbobJrHcgcaC6mL/XGoXizI2XK31Jj3MsSZQePxMw7qDcxHE
	9duHujWZw68gYJKQ==
X-Google-Smtp-Source: AGHT+IGmZmcainr9lTW69kXNHob9h7gFoRrMJ4orD0WaJEzcosAR93nxuffTYpmtgx+UXuB6Sga00g==
X-Received: by 2002:a05:6402:1d55:b0:640:ceef:7e4d with SMTP id 4fb4d7f45d1cf-6415e81207dmr6218186a12.32.1762767977000;
        Mon, 10 Nov 2025 01:46:17 -0800 (PST)
Received: from localhost (109-81-31-109.rct.o2.cz. [109.81.31.109])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-64179499189sm3896343a12.8.2025.11.10.01.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 01:46:16 -0800 (PST)
Date: Mon, 10 Nov 2025 10:46:15 +0100
From: Michal Hocko <mhocko@suse.com>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	JP Kobryn <inwardvessel@gmail.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, bpf@vger.kernel.org,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Song Liu <song@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 13/23] mm: introduce bpf_out_of_memory() BPF kfunc
Message-ID: <aRG0ZyL93jWm4TAa@tiehlicka>
References: <20251027232206.473085-1-roman.gushchin@linux.dev>
 <20251027232206.473085-3-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251027232206.473085-3-roman.gushchin@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8CCD840007
X-Stat-Signature: fjskjf4end8o9smz1nrobitsku5wf685
X-HE-Tag: 1762767978-799823
X-HE-Meta: U2FsdGVkX188paj2bGf9mHfbPRMwtOBoJxtkDZn+BP3xxFSoNxfjk6CzaJpuTCs1YXsmYJFJfmN1UjkPi0mVLlsN3NyxIbtYM3D7GFHJgdQteWHku0Q9BTu4zEK6ikSWcUPu1AM/wse8uj1SRAm+oRlumQ3FigQqN0oHjWHwmNxVROertgFyHvT8NN9nC0l5FaYDkuDC38wAMXDwXp5K3IO6B4vDBJEzWXqaZeLxDyTa38UDwgZY5gqbFF1LawajL54unZHXb2VqVdqftyrXoudPyzWofRwM/PrwTGojqY2YkoX7eYEOXHAwYMlK4e2537jjTLOJfhXLg3e9qAVPBhS88odMR1pB3tbZwVYXzkA/kMhQdqIzhTXx6HMf+VzLg0xCG8SUjhsanN+gH6CsmwR6CiJdR3dt0iKS9AbH8ebp0+5ggkL9SRjcQPcHYzPkEi4fnRVzfrqbGcKE8/WK8MqTrxBahHTWXzZBv2+CYXhuGDjLAcANebHZFy3xv74QQWmYahZinHBPWlT1BrAucEKz3Ru+pbUBtrOfSNkrkIdMt4ak2K6nABI0TydAu0K+8RF/pz2yjk0zrPvr/pTVR0ntEiKIL/KlyP3SjLozPB/pAlLhxv0GIhgizgdo63ZV1AelqN9k/aNRtKNA1M18HWYlGvWmzf34g/anW8SMRf/7LLYPJ2c8vIsDjQxHarGAvuJ8K69SITYJI7qgJ726PrIQ9bUsTjMnFlTk5rnh8PQ+5FeHh0xzGlVJpDYG+hBlYpFoabit2ITEw2OoBp6DN0n722B3Y87heNGxCm+P3aBhBSLXfUwJ3le4QPceaktCv1hfBXnBEef9ufW60pSj5QI/GpmyDckQKE3jvfsgR9pIKFtAJiq/phYGL0rcBHPR4uFe2g4nlGVB6rwg1otvenvXPcK9Ab4Egkt0HzwQGg3Y8pMuvl6dL9Qtm4quu8nxdl+ADuQG1vT5m99DP4h
 j+6q0tIQ
 +/TIf1eB85Q3FkVO3NWfAO8XbLd6EfDIgcq3hhk7vf+Wp9e3jMOUSlmKXmDjFSfm3V4Hcx+/T8WW+UE4eUk67TY+E2Vy7XIrEt7mlRpOg/rS38iumhtg69kGnKN799gquZRylYdwvmRNJHtAA74u/1oaxEAIf4kBI8CIc6VQRRBGVOCi0EFoxebCpZMcPh/V6ibxHwLmDJ2CoEc9PvWLnRgn1wAcLCuLQvvc/SHOLUGi+QLpv8917YsqDiCxJrT0/7TuzYnG3G85X9bIof9Rsw0BSh8mjcBc7VIBEM2VxRS7AAgUq0S9pseuaLuTx58oxF7ZEJmdXiXoqjZmgAWdD9jgX1ptXxJonYOT54c63u6ETFFG4KC2zVRtE7f9FNL+8g0vswzOHBCGTiW0hm36OTS8gog==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 27-10-25 16:21:56, Roman Gushchin wrote:
> Introduce bpf_out_of_memory() bpf kfunc, which allows to declare
> an out of memory events and trigger the corresponding kernel OOM
> handling mechanism.
> 
> It takes a trusted memcg pointer (or NULL for system-wide OOMs)
> as an argument, as well as the page order.
> 
> If the BPF_OOM_FLAGS_WAIT_ON_OOM_LOCK flag is not set, only one OOM
> can be declared and handled in the system at once, so if the function
> is called in parallel to another OOM handling, it bails out with -EBUSY.
> This mode is suited for global OOM's: any concurrent OOMs will likely
> do the job and release some memory. In a blocking mode (which is
> suited for memcg OOMs) the execution will wait on the oom_lock mutex.

Rather than relying on BPF_OOM_FLAGS_WAIT_ON_OOM_LOCK would it make
sense to take the oom_lock based on the oc->memcg so that this is
completely transparent to specific oom bpf handlers?
-- 
Michal Hocko
SUSE Labs

