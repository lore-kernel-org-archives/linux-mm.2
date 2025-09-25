Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC70DCAC5AE
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 01:33:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D17058E0007; Wed, 24 Sep 2025 21:33:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC7E08E0001; Wed, 24 Sep 2025 21:33:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C052D8E0007; Wed, 24 Sep 2025 21:33:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AF46B8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 21:33:06 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6768FC022F
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 01:33:06 +0000 (UTC)
X-FDA: 83926049172.15.5DB22C4
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf27.hostedemail.com (Postfix) with ESMTP id 74CA74000B
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 01:33:03 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="gs9t0UX/";
	spf=pass (imf27.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758763984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OEqXKabMS+n5lcYsCK3x2z307rhYH/2IG8dggufLCCA=;
	b=4wD923kqW4rdbNlQHb+41ypxf+rUR4Pc0Vn7JuQm8wumt6Wn0RI91+cp4F23Ub/rnnELZb
	tXIITnNR0cH6yrbbFXcitwn2ccVdD88DuGX7XuNUiQyOldr/XxxFotICUksXxfDmXDc9Ss
	aw7c//dgS/txGU8T6LweS7DfxzMR/fA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758763984; a=rsa-sha256;
	cv=none;
	b=oAdS+Gx/xyYokqkcaPdLRml/L+9SSfxakTALG9AG7nuY7+Iju7QnDHKB1qFtabAiPkuARZ
	frj4wN2KOPeNbQICsHa21HS5XFSKOEWRpzqt3MmtvgZGFtWRdNUQuMMBpIiBrvlLaQ+TNO
	ivgMGtPg8rW+9frrKz+9d1j+ZLSTtuc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="gs9t0UX/";
	spf=pass (imf27.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1758763980; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=OEqXKabMS+n5lcYsCK3x2z307rhYH/2IG8dggufLCCA=;
	b=gs9t0UX/YvANEK3RexKKThxrBvm3M/qI+WQCyoElcKAXiaQEr6V4Y5cZYb2NWAutclhBLiPk4LFuPVIHe9i3d1n/7+TTDLI7Mn0QoxTACWx89XNxXRpnE1DqEPejba4I3vsuqL35MxVuRMaT92yRiQPxIZYZbFRHcWXUSwj2VX8=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WolUMQn_1758763978 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 25 Sep 2025 09:32:59 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Zhu Haoran <zhr1502@sjtu.edu.cn>
Cc: linux-mm@kvack.org
Subject: Re: [Question] About memory.c: process_huge_page
In-Reply-To: <20250924114619.2532-1-zhr1502@sjtu.edu.cn> (Zhu Haoran's message
	of "Wed, 24 Sep 2025 19:46:03 +0800")
References: <20250924114619.2532-1-zhr1502@sjtu.edu.cn>
Date: Thu, 25 Sep 2025 09:32:58 +0800
Message-ID: <87y0q3e2ph.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 74CA74000B
X-Stat-Signature: 11kxkxyn51gzc4ddryujsfj6jzgz1bda
X-Rspam-User: 
X-HE-Tag: 1758763983-809706
X-HE-Meta: U2FsdGVkX19vrygso0r6HhYcZCfusTJ7JbzdZDKXCXFoBhMW3iLtko9Mz3u/C2qphWsAfTIOxaRBMQKCKM31hI3oS3sN50Nqn/PbSMsjvP953/q5zxh74CM1oER6h5qzPnPPqGm9j7x6/KoQYlUPJiHzyWjNAR7tYE0oRo+7jNNiruEw44n93dYOlUmOf/8NX+0c6yLVMzjnJ3FxEEH4ywxzI/JlWYdnOgJVr3ww4j8p0miKeID4Yw6cWwC4VY7MaCqsDivwBB0bWC0npGq79hMgGO4qLOAoVwnV2klly+sQE8y1Luwuzp05YlGgxS86gcedVqh3ijBbfL1fX4vK3vXOBd+gFlN2xvY9Zjzttf4cHND9j5kQRkK48RMlHcigePKHP4+erfCEbZrbr3aakkOmUW/bJIcBQuUj63LtSWZzoXFLff28qNeEBdiGu9D57Uy6scotKqxqZyCH4KM+w+wqZGvEA3DewHpEiJfvtrL97biAARyRFxSjaw2IfyLfVNpCvBKcHAhMJl1hFAtwDzowp+B86spOtO0EgY3QatYDYn69X4gQRJNt2ALlSxR7r4z8J4NzY/RKk/ajTfVTFPSlREsgLCvVbin+YZUiQWEsNXsXVwRu0V8v+FRHGiO1OVL6E+dFDvTTBevgUZJhvowN5I4h5wknCJY6UYhTctZnQ0YRx3MDEEL1AoDnSITDcxqJ6RJX8f8/QvsmGJ/PpRurK5lb/IO0JeAdhDLG8sX3+ax7zNF6AQ0Bh91FGhSjGCm292P7gMDkhsuupGT6Kd75WI7MBnK6qThczsjEggI/QAu+zX4R5udmBYFEg7d2U2yIMJkLdh0D53oKQAHr07iFBXPSpG0DXvb6FWbFM9R4KRDdm+kgjPK9rh5ESfJmhIUqa70QStSnvGkL9bS8AIqp0Fp3VRO+++qEeWq3A8iSyS6i4ou3N7SyIJhobO4dLGlM4fNSmpYHEVL6jfd
 z9Zpf89P
 fIzuhdo8929xDLu2xHwhkR/RFTlXVMvi+P7I120Tc5GwFnGH8bXf0SlLBH9FFTLD6pXDlOfwszeqnhJxd3HJsO9giQNSRSRqO1p2o1oDrl3PvuxX/5nFjuoiUCCw9f1JvyTyPhsawcNXEZYOHWd3KCnvM10I6FugZRpCdPUn18PVsZkzsz+/ZOvLwtvEmDH8s3RZDpbQ76JeZ/UbNXqnRkddoVFvtPtt6ryOLkCpt5hydgYv99jQUDqxi/X9URHGn/jSFA/itLGuUx9T7lXNtMV7I/H+6+wYXIsKaLMPJKtPV56xJIbDazF90zcU63+yJSF/q10TEU+DgSB9ZwC/5A+4jw3t+nqoHeiTEkV/My35R4ugtUG/obc3Ucg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Haoran,

Zhu Haoran <zhr1502@sjtu.edu.cn> writes:

> Hi!
>
> I recently noticed the process_huge_page function in memory.c, which was
> intended to keep the cache hotness of target page after processing. I compared
> the vm-scalability anon-cow-seq-hugetlb microbench using the default
> process_huge_page and sequential processing (code posted below).
>
> I ran test on epyc-7T83 with 36vCPUs and 64GB memory. Using default
> process_huge_page, the avg bandwidth is 1148 mb/s. However sequential
> processing yielded a better bandwidth of about 1255 mb/s and only
> one-third cache-miss rate compared with default one.
>
> The same test was run on epyc-9654 with 36vCPU and 64GB mem. The
> bandwidth result was similar but the difference was smaller: 1170mb/s
> for default and 1230 mb/s for sequential. Although we did find the cache
> miss rate here did the reverse, since the sequential processing seen 3
> times miss more than the default.
>
> These result seem really inconsitent with the what described in your
> patchset [1]. What factors might explain these behaviors?

One possible difference is cache topology.  Can you try to bind the test
process to the CPUs in one CCX (that is, share one LLC).  This make it
possible to hit the local cache.

> Thanks for your time.
>
> [1] https://lkml.org/lkml/2018/5/23/1072
>
> ---
> Sincere,
> Zhu Haoran
>
> ---
>
> static int process_huge_page(
>         unsigned long addr_hint, unsigned int nr_pages,
>         int (*process_subpage)(unsigned long addr, int idx, void *arg),
>         void *arg)
> {
>     int i, ret;
>     unsigned long addr = addr_hint &
>         ~(((unsigned long)nr_pages << PAGE_SHIFT) - 1);
>
>     might_sleep();
>     for (i = 0; i < nr_pages; i++) {
>             cond_resched();
>             ret = process_subpage(addr + i * PAGE_SIZE, i, arg);
>             if (ret)
>                     return ret;
>     }
>
>     return 0;
> }

---
Best Regards,
Huang, Ying

