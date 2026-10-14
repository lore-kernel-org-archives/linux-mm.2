Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6787CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 13:16:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F255E6B0092; Wed, 14 Oct 2026 09:16:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFD4C6B0095; Wed, 14 Oct 2026 09:16:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E13346B009B; Wed, 14 Oct 2026 09:16:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C0F5A6B0092
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:16:52 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 54785802F3
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:16:52 +0000 (UTC)
X-FDA: 85321281864.06.0D90015
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf07.hostedemail.com (Postfix) with ESMTP id 719D840006
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:16:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=WApaJg9B;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791983810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dCpsW6YU/0L4WqTH5RPpEDwn9rrogta3oLm9yXxgjmg=;
	b=aBs86sBCv8qthRuwbSFeGOxGOdeVDCxr9HyND/NuHk5L4AX5KUv5OReBcStMmLJn0yyZoY
	unBxHQN1h50Y/jYwk47SBZvHBLOGzUzVCBHnoyyynxlR2JVb4AKweVT0lW5U5N+mIbiF5S
	82gf2360xkDXPICoftJX2frUtcQHc8U=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=WApaJg9B;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791983810;
	b=uxnuMyzf+RfFM6e+nFO+MjN3VOQaWBmt6VR8G+oTFEwd6ZcAfX+azvrTa1CmUUMD+jqZ4m
	pz43KUmwJqQNoU3HGYD/9WEjSgXnRvq/6TUarcoknKW4sRZV8Wlb6ZlZNzOH42u2rk2eD6
	llbi97fWAb9dJtbOuwkuVx2Xll7X7iE=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-535f9de49fcso2216601cf.0
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 06:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1791983809; x=1792588609; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dCpsW6YU/0L4WqTH5RPpEDwn9rrogta3oLm9yXxgjmg=;
        b=WApaJg9BYYdefIblyj3lW+4ov5L4OBEFguFSo9hPh2B6DT+D+i1g3sOr4FfTJKR309
         x1mEag2/+u05D+haFftbgeORswCEzY1lto4V8jgk6+KxqKN6txkFLjxoCGJF8y4NNH4p
         3uJNZ3tCxrGONTpXlbj2Vp0dX6t8xgVVnjSKV6P7/5HbGLDlEpOGQGYSGNhYxA5BJnYN
         AqMATYIVH59Ir02QEsAtDcmEW/sohxzsz0lMh2N19i1iN3eBEZpzTNO00emugSuCZkHv
         sMIiz3foWY7z9xeqg824PVF3ICwdAzZI1a02fweH1BlJqxExyO/h02r1YFvXzc7xN9Gw
         pTrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791983809; x=1792588609;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dCpsW6YU/0L4WqTH5RPpEDwn9rrogta3oLm9yXxgjmg=;
        b=ZEkxMdDRa5M4w4Uxv7YyfUIqewYEL9s1Sqy6vbjQlzwCTgK3f05Dgv+vyPMavnSfhe
         SiIFuLWW/EZIdQNuCNoZjJ1Zp/B3+Q+OoyhMaC7t6Cjza+rSVUzufws85iRYocvbocbH
         z3ZJO+THEh5rv7I5CsJvAXUt8LESvftxcYNBF+R7sO2kk3XE52oGIH8pWW3mLX9lHqjH
         QEQw9XzdUpgJ/LUdGUAQMtAYkxmlZMirPPC/6MzDGhH/dR6Vd069bJ2mkSLZOeK/MwMJ
         LoCzMSn6DeStT2bZew+dWXhAQMZ3M1tKL6pGqUgESIZVOa/evdwxPBStJq8RAbXPMZ0C
         N2EA==
X-Forwarded-Encrypted: i=1; AKwUvBzQQJYdox1/+pwfPLP7SBdxL0/11A1Aw4cHGHBg2PKqoQ5KpA8a/cpbucx9LWYCE67C1/Pj/0tSRg==@kvack.org
X-Gm-Message-State: AFq9FYKhXrWQnSGtgnm/jWiM657JJbI3vPgaJGsCNsMEvDFW5wBXC7NM
	6M+AhDje85DR0N3bPd/mCiKJWHBVVO/6HG1wxbnTKTCliQFODkPJtl0mLQW3Ch+dQ7M=
X-Gm-Gg: AYBFou0B+jo/XqR0akW65TcnklBH5Sb/qvfu3P13pBGVf60gIN0d8k7gd+1p1cdeyLo
	mdnpkLiKs66RdSIaXN4FibeMUzMO9DAPLtRB63KbL8gYIRHZ/Q0ntGiWXyPs62zdd5UNfe2nvUl
	HvqoKuH0X0ifdFcYO1yUebZkQ77PpyDmjNuenUUb5VQq9spqqj5zMI1TgPKSJAz1BuH3gtNrBd6
	OJ3KJzbykQ8F01jEBtSlSynrSobkB4oqcFQRMFKfOQULQntpJBoQUcg7zVKKIfF5apdc1CtB3ls
	V1j3yFutbKOq1ZpKMb5G6Q2qc2QpgLPtJNgWaK9Ym3GKtpv598y1zscUST3YS2i8mpUVYgyTHXF
	SkaUj18UHyFq9mc+AysHTjukLiNiT+HASoeZCz2NLaNiPqAoVq0tNSNdS0E+A+MR5ZdWtpAg2pn
	epSdrNAt0v1HP/q9WhL5tlznXb1b6s09jYJYEeAqSGN5fT4X15yd+idaHHkXRwp4dneuPRXtLSH
	Od8Ci/6o5y386Vts98ZJaRGCWv8JEVod8RCRX+1MwF69AGkInDZuqI=
X-Received: by 2002:a05:622a:999:b0:535:958:b9c1 with SMTP id d75a77b69052e-5359f46f32bmr248930831cf.11.1791983809565;
        Wed, 14 Oct 2026 06:16:49 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-535f4eee7bcsm30668321cf.30.2026.10.14.06.16.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 06:16:49 -0700 (PDT)
Date: Wed, 14 Oct 2026 09:16:46 -0400
From: Gregory Price <gourry@gourry.net>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	joshua.hahnjy@gmail.com, ziy@nvidia.com, mingo@redhat.com, peterz@infradead.org, 
	mgorman@suse.de, riel@redhat.com, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, 
	bsegall@google.com, vschneid@redhat.com, kprateek.nayak@amd.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/6] sched/numa: make free-space tiering promotion bypass
 configurable
Message-ID: <as-AV04p-AZ45-mw@gourry-fedora-PF4VCD3F>
References: <20261014094347.99157-1-lizhe.67@bytedance.com>
 <20261014094347.99157-5-lizhe.67@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014094347.99157-5-lizhe.67@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 719D840006
X-Stat-Signature: md3i7hxmc3abyukrzdz6e967j93zc6ye
X-HE-Tag: 1791983810-601754
X-HE-Meta: U2FsdGVkX19bK/OO129gHjwKP6YpDFplDlqD0efue16HEVWSKk0Lr7ARkVQMR407uMQwGFvzZQNOoXaGJ1m5BsesC7WvmoIbIgSVFk0gSxRVv4ovlSJ4yowaOKNm7OHJLwqMWICv0iPyfwLWQYKZDG5CMnGxMZT4WcgSLg85mFWwkxPiPVPpH46x4m59oHA8wQCYVrVchU28Udg0RyLAAURtksAG7SMCQ6HZzyxZRTju5jf0Gc2G3ADSuX0gKJGsOoiJ2IwsZjP5y6jftPT4tLg9w+kOJH31e4Q9QhdU78O3vKz4RYJc0TxcP4lDEKbvHcv0d7LkeFp2TvGs8v9Qlq5+LV/2FOAcRc/ZwHXADy0F3YVnhmltL+V7EUcbisBIRT74/nAXYtS3N+mdV4ySTmtX0dQlr80frMwVeHa9ITKCCyN4nPUC6uujPk23EzdXN7rd8Mk1FXv9DsqfTHLxl9rInJWYMsMzPrAsPn3FOIG4gXl7+PTxXIEKJKQ+Yg+NGaPT3mKqHAFsHYGPrA8lgm/8u96p7wq38pMOeFZyhZjMT3zomGvasoHdLu6GlrmdGpt/2HmcqS71c7paDN2XS9dM/ujv01ouA6IYlBGqwC5MtIF+W47xlO9tm6AK/NAw+JqZ05oL8BOc13QcL9cz8RW7ztWJagl5s9z536JdaGKCo4DybzGx6rz/mRAQ+yBTEOaw7SvNotYCNKPOiVT1fNs/4ZkX1dFaOXzOMMbGRfO7mLGPKE2h3KBrOtwmMmmhRCSW8aYMf1EPL5NA+Dh8vwoORrDUEV13znXRFPZe2x/Eq35jFVRP7N6+cQ6W8xtU2P00R1o6wYwX6ROgzNsiV40w3uLH6q4qh3lm3reRUptK/14GXq8NyQkZ7MHVGSKfKR0V6aUzzJgaUiPZzlFTv1+aQ8Ysj+54V47zjLm2Q7GVJKBazCtqr8OT9EMXVCoBBtlIEDeus2ncz3aPizS
 WAkSIVfY
 R8+zWiU6vJ8edx/z6SBc0UrU+q2dcin9vK41GKHKAnVNYb0i0XU3u4cyuso1Ids1o6aMsJWiLwpWvKo4EXSlSqVN+qYeS5qYl8gpi3crfO4j6i203Z6KOS0t9EFNilIOIMzfIXL5AOnkUFnbhPFJuZ8g1Il7x86i2BlpeGGIHlLHB5nzaGgrUxeb/6Q+eulai+0pJKC9sd0mAZDWmWVpJyppMX8XiJCsFGmEK0YJ72laa+bUbPzSqL91pDQo58jtq2y9duyl32XNrTZvUlRseuzSpzIJProaF+QLRdaVjzObTFTaARonCfP8QLrpRxgQuCua/zHHRPLlIDJ+tXeL58rF+v55tHZ4u2Ir2dL7pqazwzGvTJAI1J3HN9jiOnM51F4GTRy/IiB5mcAshHY42H5uAtg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 05:43:45PM +0800, Li Zhe wrote:
> Memory tiering normally promotes any recently accessed slow-tier page if
> the target fast-tier node has enough free space. This preserves the
> existing policy of filling available fast memory before relying on
> hotness and rate-limit control.
> 
> That is not always the desired policy. Some workloads may intentionally
> place memory across CXL-attached memory and DRAM to use aggregate memory
> bandwidth. With the free-space bypass, cold one-shot accesses and bursts
> of hot accesses can refill the fast tier and pull the workload away from
> that distribution whenever DRAM has free space.
> 
> Add kernel.numa_balancing_promote_free_space_bypass. It defaults to 1,
> preserving the existing behavior. When cleared, enough free space in the
> target fast-tier node no longer bypasses the normal hotness and
> rate-limit controls.
>

A global switch for this is a poor solution for this problem.

Also, if the memory was spread out intentionally, it presumably was done
so with a memory policy.  In that case, if the user did not set
MPOL_F_NUMA_BALANCING - that spread is already protected because the
mempolicy overrides the numa balancing fault and no migration occurs.

I don't think this is the right direction.

~Gregory


