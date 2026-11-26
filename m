Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2757606A33A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 18:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lTOoeRCe
Received: by kanga.kvack.org (Postfix)
	id E633E6B05B4; Thu, 26 Nov 2026 13:14:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DED176B05B7; Thu, 26 Nov 2026 13:14:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB3156B05B8; Thu, 26 Nov 2026 13:14:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9BF026B05B4
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 13:14:58 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1BB97160283
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 18:14:58 +0000 (UTC)
X-FDA: 85478071476.12.4523C2F
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf02.hostedemail.com (Postfix) with ESMTP id 14BE880007
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 18:14:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=lTOoeRCe;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795716896;
	b=DgQXfAQ7FWipeWUbJNpaAagx++xEYr/O7lp6Wfqa8+rcL1zXdav/gDEgpeEdbRPSkRdgYl
	DGp8+C+Si4LwjmvmRQ9qxrDDO/xaug/dziVOJ/wmA3GHt8WQ1MxcuqRftPhTrUpUhxxk0Y
	NTugiOgTLriREJW59u8cgIDpONfdIxg=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795716896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JJcgIq/HDSRd39VYibYL7fowv//3d+fQ3P9cW/IGDlk=;
	b=J1hSkt/nnQDb60AzrGrMGQ3+ig+Ile7VP8GVViArdtgqU+tsvJ28VpuIlwDfV/HXfyHk1y
	YR/TaJh5hxoKUxlKpw+lkXgx2bS3WjnKWHyMao33+PyW+sfPGU7iExUneJ2PAnLcRb9MWV
	Sk8PFwtOlEm8xTCfw0S2k8FOK3d9BLw=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=lTOoeRCe;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-491f34b4e0fso3353145f8f.2
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 10:14:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795716895; cv=none;
        d=google.com; s=arc-20260327;
        b=bj9GQpzq5uj1evJnTapHPkllTGwEEKJF4K6oAS+5/pl4C6QadwOnfnfDfXkHTmh2T8
         Zr8LLRC9BYpGb7dblKHH4mqzu5je6wPAYD7nGuA8xB5G63LUDW5fQ4wohqB12thskUmG
         fWE3kBz1/qJg1L9EqK5ibLiJQo0mL3Bl6D6q9Ucjfp7DqIaptHUC1c0HXaariU2oqyau
         na4k/GmZOAM7qKZ7C0gGs4sib0ZOUoWst7qYqILpVbdTD7s4ICjiOyn46lvG9B5qaBsO
         29ivuTd023c9CZ8fz37Q/xNMM81zH3ifQ2hQXU96ftVPek2eseCgIFJEHl46zLylGOom
         MaVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JJcgIq/HDSRd39VYibYL7fowv//3d+fQ3P9cW/IGDlk=;
        fh=0HeSeCiLAz5Ln4kj5D0pvbIpueyqF1G43QsqDeabDTs=;
        b=EvrQ7VqqQeWLo7wigvTcxtvXsD2rM6yG8zizt2LNBRh2BO+sz9eKguCLlAPEbMuvvl
         eUoueYQVDdMOLt/rOROBCpCzBUh5MgsqdA/rnKS7loe1Z2sGz1tpW3jlypROmXfuuAzP
         MDwH8UYKqg1pVypYKAv9dOsiiDw8tjldCLsmmg7attzFtPPE7Jdh5JiAIKSNPmnEPYAA
         N++3uTzFd2YNQMiTi0yRXl0lUNhPlK5e3eoFdKTL1RO+ZFZEZEYGLnCnDCLD4ROVMJC6
         rCKEPq2a+BuOe/JuZ6KLzCZtRbsUhPwO9z8HjudnjcL2ZSd/DY8rRh59Z92AHP2ib2+Y
         lVjg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795716894; x=1796321694; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JJcgIq/HDSRd39VYibYL7fowv//3d+fQ3P9cW/IGDlk=;
        b=lTOoeRCegYcsNiT5tCdgvwCrOpTJXqDaRXN48jytHtc9lIlZPjoyS+iW6hB9hKfE6l
         dyi/kmxD3s6TtcbhOh/DXt7r7aKrk+mvq1Wb4v7Q6kzY/niuGP+yOY0FQR1PJ7NneV3k
         aO6Y3E2LpTdwaXkOEwcONhhyw5xLvymf2vrB+xBn1/oUashwPlrlV1YAB1pS1s7BPHQd
         kkmnl7QPFELI3MLAmobWsDyCsi+w1MxqGbVMiHsxP+ib4RryBvDYKbX5fCrbwrEmpFCV
         4QRiwAEG2oBZ89DPYeelDexzGpshwn0y4Ne20gCiI0843C/NWH3M18caU3xpn/to9h6/
         4sZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795716894; x=1796321694;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JJcgIq/HDSRd39VYibYL7fowv//3d+fQ3P9cW/IGDlk=;
        b=rnxVy5zqwWLrrArqsMFUwpmwiV5a7rR63JshrYqBA3dtlYARcVJzWkOYlmyuconvR3
         e7R7esPCSgOumoaox0G1WHdwXBnG8A5QaLPigrPcPR4mx8Q/wgtbQck8SRLGPj4xDIJh
         HA3JSf5Zj5CecOy7EBoeTJVKM6WOlAzYARWiJtOQ5yKfTAsIJe48r2lAsAoVhP327E3q
         wJLfuzGqNq5Jx26D5MJXlutIudFiWy8GYC/cQkvYtR8FqesAZv10dloVrVEmbge7TqWv
         8pQKDQIgqXb8UNSQ1hCgPy0+fZzUHl1Fj6MB0GvYMmepAAIcv3WSKMknZ8d/yRfFNlf3
         RmSg==
X-Forwarded-Encrypted: i=1; AL+hErFMZGig7lObbwqY+GWxp1Bs+cwye2o2oZZK7J2ySmxGC56oymmDDmfmmnAgZTvrF0eGLDCciMyGhg==@kvack.org
X-Gm-Message-State: APuU4Z8o6Iw12L5oSaPgPX1pTjILD4dc+62G4gFf0wdKHGLti6qnkdye
	JbCRwDexVeKLenYDAOEMasQIydYN82OSnF38driTIb03ERm0c87bideiHQynYN2b2Wbwz1wu6JD
	WDcc2K2NqsybQmLNcY+prndksGC7nam4=
X-Gm-Gg: AZFdTZeFPQl2gBEP/3XuukT1PSDLzMR+L6Bm7ndvOBZtJCzhwX1jPETmg1ylTrNZP/4
	VehPzKF+sR2tzm4jDBRIwdKTozuzkmIRRfwB0DAxazScF1FyC8of39KrbYrRiXeTMu6no2qADWm
	LyUM4F7cIrpgj4TBVtvXqve6To6KyFalRXAgljIOCfIwZ5hOYNZ9Ufctahtu33zyuFSOOmxFJsn
	3hqhz84NLiXM4PAkCIWZf9xbtVcWyZs29Uw4sFaW7mDdtSqmY0FmgGtDPMoRwv51HAk428mjUDL
	azr8Wp1fgrlUCB30uXqOTctLleB2g+Woftjj3cgsVpkT9gk0wtuDr5xdJAx2U9Z1OsA9VfkLvNq
	xk/R1iRIGhdUXbMghfmZAZtuKOM+kW2vltBRybxV5yvB44RtwCT7aN1XuGQNxQ/H15HzXtDP5/X
	LwwV5feBvz+f8Z1PjLbGCryWNRyA/STFtGQmNXMFDl+E+t9q2PPF5YFJywh6fdcwpgzlwJx2Zbr
	Q==
X-Received: by 2002:a5d:5887:0:b0:4ac:84c:70df with SMTP id
 ffacd0b85a97d-4ac085bb48dmr41879373f8f.45.1795716894481; Thu, 26 Nov 2026
 10:14:54 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261126094318.244973-1-alex@ghiti.fr>
In-Reply-To: <20261126094318.244973-1-alex@ghiti.fr>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 26 Nov 2026 11:14:41 -0700
X-Gm-Features: Aa3M54ocdxc6P0mj2duHnArbXItHxXS2zC57rOsuchv0wogkpi5TRPQQGAGSQyY
Message-ID: <CAKEwX=Pt1ke4MdjDB=bpQn1bBbdxVao4sx1ruTawYQUY+ROvNA@mail.gmail.com>
Subject: Re: [PATCH] mm: free the swap slot of a dirty swapin folio
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Barry Song <baohua@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Kairui Song <kasong@tencent.com>, Chris Li <chrisl@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Baoquan He <baoquan.he@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Youngjun Park <youngjun.park@lge.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 14BE880007
X-Rspam-User:
X-Spam-Status: No, score=-1.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: exyudan47s514fiufnyn4jb6wgd8qbyz
X-HE-Tag: 1795716895-287490
X-HE-Meta: U2FsdGVkX1/gLTEymXPER38eV09qSdMjybxVHMACoDLjiDdPJpNx+o1pbYWNsEUvY2K8hhHVe5KsvQ/PaI8KTM0xUEMHMrVjLz5CNwOdh/I7QARRQ0lLFzmH7EL1Sgf3LgnyJSU3XQOXTZvyGxITL0bKDXNLAbemuddrqsOaAJvT7+VL42KyjyYRfCfoMGl/tWwuNDcb1XD/2XiX3yAPUQEUaCqrPz3EIoLAE9o3Z1SjHhmuOzIb9sSmNAgg6Lw/5XpTviKN2tBx+p20JDc2lPAns1hXZ7aJJdOBXU6GL4yP2I1WK65GvRrnHKlHVYka0CmSFuK4P2A1tU4dKLpfxPEG3ZMC3C3wYDBIApwG9OyttQk4YL6SSu3Bm18/IuXs/+LEwjAigT3JVWOyTBvewbwHhS8ffCpnDHYKyjgx2X70ObxdPDrmNTWc/PabkI29Z/MQVY/J8C8JxdkhvO4MuM7GonaW76scaKbZJBQwzcM4Wxz+PbmOfOuiqIis2M/pOpPFH5o/R7Ig/c9q0+ljVkxY2pT64f4xVfddcU/RmFQueMneXg8iYcHE+CN8RYqOQaxffJ2NkKUMhHfGNu6yPO//JuP1w+gLleiheUnFr8v6LC5h/RnlJZOW6aDw7sdsWmQpNCalOJAlecKgAKdL4Qc3wkq9FACNl1ihM+uZkzycGdGzMDv41mjEniBj2H5p/raFVfJDVOhOcnKzcJeoAbwfTq4MNLPt7EeiMDgH5DFlObaWh+wpBAuQritiZjpB2OfyhTJWnDETV3GnJj20Kk8cMlu52tCpvL/+i4g3DcrrjM3DKNTpMS8EougrCdIrmxjXV7HUiGvPU0/Ok6qef9J7vXYyPDJ0yWpcBQ/Y+Cvin1/xpW/RCs+2m08brCk2LTHKq8TIn4aIwftr2Li2H/VB8e/pShSjuiV523IhGDpSymSUEPy5IMk0OKdOczmp+1tv+VZlYM4rPhzu6wm
 zc7ocgSu
 PrIQ37KgKOGYVJdbvW7J+U+M24Kgaknrsc5Hx1tsnhgh0U4RvOJigl47QqOOKFC1MyRG34Cucka8hlQ8EO4LVUAOHKK4oCohFz5I4hqAZEk0YB+9UUBbQXyY6y9+2A37xYSMPG+zNgr2qgwyNLLYKDxIoNzGRXTu5oRYB6AQGHlcurc9lF443vNBYPG3Je3vpZZ/lK1bvOKqVjRjac86PTqVIDbfF+eTrNo2QoosypzA5BRCGT93U+k1bLQF7Cr0TTIYGpSypf8OSQmzIU1Jud6qcmgkP/jQ2mAGyYMJstPJTe86zc9EaLgGYgIeikihi6a5EtATzgkKZk6mN5LX1ZUERoEUquAGknQMG2i1FHbas98yIJ0XdykEemPYrSs0xnxYvf4Nc+eNfOKsQGFMJnsKFLFYaNtEej6zmXbAEAJiIZNtWxTreKsSKXo2Rwc730NKhOuvttnVsQpXeO3Y2pRX2IzUeMBG4ohDr5OdXRBzQfg7favqLKHyu4MXkTtdlCebp3SY15/iqX03p0IAENYQ7TVMt3zJR5U/XENIcum/g+H6bXhy08HomDMMtYyp4rUWTvmLhokL2K7pfKak/KEE2Zj1x0w1bCS7Gql6wExa8QL0WtdrrOfE5tg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 26, 2026 at 2:43=E2=80=AFAM Alexandre Ghiti <alex@ghiti.fr> wro=
te:
>
> do_swap_page() frees the swap cache of an exclusive folio on a write
> fault only. A folio loaded from zswap is dirty: zswap drops its copy on
> load, so the slot no longer holds the data and only reserves swap space
> until the folio is reclaimed again or its owner exits.
>
> Such folios add up, and they are expensive to free at exit: on a large
> production workload, the exit time doubled when zswap was enabled. A
> third of the increase comes from the folios left in the swap cache,
> each costing about 3x a resident page to tear down; the rest comes from
> freeing the zswap entries.
>
> So free the swap cache of an exclusive dirty folio as well, so that the
> slot is released at swapin, as is already done on an exclusive write
> fault. The folio is dirty, so it would get written out again anyway:
> the only cost is a new slot allocation on its next reclaim, which write
> faults already pay.
>
> On the production workload, this patch removed that third: the exit time
> decreased by about 15%. On a simple microbenchmark, 4 GiB of anonymous
> memory in a memcg pushed to swap, read back, then SIGKILLed in a QEMU
> guest (mean +- stddev of 9 runs):
>
>                      base            patched
>   exit time    989 +- 24 ms       502 +- 28 ms   (-49%)
>
> The cost is paid by folios that keep cycling between zswap and memory:
> each reclaim allocates a new slot and adds the folio to the swap cache
> again. On a kernel build in a 600 MiB memcg (-j4, defconfig), this is
> not measurable (mean +- stddev of 5 runs on bare metal):
>
>                        base            patched
>   time (s)        592.4 +- 1.1      592.4 +- 0.9    (+0.0%)
>   sys (s)         256.6 +- 1.5      257.5 +- 1.4    (+0.3%)
>
> In the worst case, random reads over 4 GiB of anonymous memory in a
> 3 GiB memcg, so that half the reads are zswap read faults and the task
> spends all its time in the kernel, throughput drops by 1.1-1.4%
> (mean +- stddev of 5 runs on bare metal):
>
>                        base            patched
>   reads/s, 1 thread   37310 +- 182     36889 +- 77     (-1.1%)
>   reads/s, 8 threads 291937 +- 802    287954 +- 373    (-1.4%)

I think this worst-case throughput drop fine.

With SSD swap, I think the number is even going to be less
significant, and furthermore it will be much rarer to hit this case.
When SSD swap IO completes, it's going to be in clean state. I guess
you need to have a reader race with a writer who wins the race and
dirties that page before the reader?

