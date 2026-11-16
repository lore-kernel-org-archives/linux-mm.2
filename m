Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0650B606A329
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 16:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ONwX6dMP
Received: by kanga.kvack.org (Postfix)
	id 030816B05B6; Mon, 16 Nov 2026 11:10:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 008C06B05B7; Mon, 16 Nov 2026 11:10:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E87676B05B8; Mon, 16 Nov 2026 11:10:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD03B6B05B6
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:10:54 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 39BE1801A2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:10:54 +0000 (UTC)
X-FDA: 85441470828.02.1671961
Received: from mta1.migadu.com (out-64.mta1.migadu.com [95.215.58.64])
	by imf22.hostedemail.com (Postfix) with ESMTP id E082AC000B
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:10:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ONwX6dMP;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.64 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794845452;
	b=kMxZkFvV5puCfBj6q+eLF+DlhVy1WWwJ/8/QI8Ea/pzyCyv1AaElvYk56hB1qexSRN5ugi
	1McbfCWWx3JV2DB1cXU7dG5vy96RQIt138pTTN5zmLQMPlfsxz3ugOSeuV61qRv0tY9pyB
	5s1OqG2fwodk+sCPfL5/DgVOqzjHHV0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ONwX6dMP;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.64 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794845452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oadzkl3ORJ3wQkyJMXU/6qO7rxNx4uwgoabiDJ+Xsug=;
	b=qqiEeAQizYnoH3E0+mfFlitCy2gqzinG8u+CP0bGCy+KFTejBlr+2DgE9TMbtp5K0uDnYQ
	qPEJtq7gURecTbartzoKaGgRlNSVxxhXYoTehImzV89CXMp08N2sta0n1IRjoU6YS6DgKL
	CG1DwCzCWF3CX0e/QTGyzmqw8KQjCRw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=eCHYxBdwWeLQPnYgT+I0HAdi9TUCI4ucB5iF6HP0g60=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794845450; v=1; x=1795450250;
 b=ONwX6dMPf46nLT1v53fiElgDkjxy9Owao356TieVrST08i8VwXFPRKMbeA2jfCAdv22a0uCo
 HZs3SrUe13JBeeGk6yiGy/d40N5YXu58i2CVaYLnCZT3dUlP+VJgB9vfayu5ArHuQa1HRCNxIJ7
 +wnOkVEEOeLoApKlRanXhfho=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 266450e47dd57905;
	Mon, 16 Nov 2026 16:10:46 +0000
X-Mizu-Trace-ID: 266450e47dd57905
X-Migadu-Flow: FLOW_OUT
Date: Mon, 16 Nov 2026 08:10:45 -0800
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Yingjie Wang <x-professor@outlook.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	Manfred Spraul <manfred@colorfullife.com>, Alexey Gladkov <legion@kernel.org>, 
	"Eric W . Biederman" <ebiederm@xmission.com>, Vasily Averin <vasily.averin@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Michal Hocko <mhocko@suse.com>, Alejandro Colomar <alx@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, 
	"linux-man@vger.kernel.org" <linux-man@vger.kernel.org>, 
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v5 1/3] ipc/sem: account dynamically allocated sops
 arrays to memcg
Message-ID: <avsq7s-CVIFiB8y-@linux.dev>
References: <cover.1793250194.git.x-professor@outlook.com>
 <07d9034ec1fb5b6fd5eed2cf60ef3c84d5149e51.1793250194.git.x-professor@outlook.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <07d9034ec1fb5b6fd5eed2cf60ef3c84d5149e51.1793250194.git.x-professor@outlook.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: E082AC000B
X-Stat-Signature: rnx977sj9fppowo46z3cjkhrxpb6cjjj
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794845451-541554
X-HE-Meta: U2FsdGVkX18PaXDcXUaNKsrTnum2BMWvFFZYJgCgkYgRU6GO+8aPQJlVcqybGjCCnYbRfnQ4EK35syMew2ozIxm92k6Ec15mVEsHwHHZt3aPUIC2YtnVkXGxy9drGOfL2kzWE6nq8X43/04RIK7QbaVmvuKrTH1lsMn+TYQWnJv7zr9EpIfWFoQGwxzNZWqTy2+oTVeM3MGvCBbsoIfRiG9xZWtoiVHkfCDmXRjmwoh0RnbVkeFmL8SCbG27baPBZOAFNEvfvViOc2XNBEt0sMp5LS1vaP8bW1H/o2408t9qn3xTTg4hsRwElYSOgKKW11d8sQ5xNB1QZ4VGhvkIuBNlBUWN5cjxWdRQ7r/4wamxJIONnEGpr0upiEjSQRZCCl1gcT3HwY3s/dOoE2t4npy0RsR8Qvsae7lvL2A66ExhlZDVl1mUY8Zn9tu5jfzswPmSGyth9kz+v0sLLYnHCgbLA4+hwNujvJJO1eZxZsrLOjWJrnOyHdxiTrgfTXZJKpFJR7aoe3buMyQcpsJMwwgHwsDkAxrprtuvusmOw/eddo9FxMbxQ+UCVF6ZEPxj8M+zDmTaMl4ChnfmIsVtjayIV8qu6SnsUPfyx2v8EdxiM5zlKQFZ/IuJqHnuT3uWWLM/lokuYhiMTbWALKcfxiCUCJvDFAtFSh+nG0U6gAho8Qp7U0xKc7PCDwJvmVecWtA3nIaIsz8rDRUSOASQ2kgzqqCMKr+UCefTE8/uhvmli6xA8XznlLMfhdfuF6Z328TsBkg3L0yIzHJaiQMnoRCvFNmgNNppKSqfVXw93lbnPGS0G+8LDHg+cnjgMwZ6SYO2qm6al2gaMtW1m78wKEFovxNPZvhzEIpX+IDsapXeGfLL/eVAfXB1NaUnpZYYNZW3sEM3MGlaITBLyVyUWHzU8x5+7cVuTKClkLVImZppFGDHbXjT7S5bglJmfLSPvbxMO0VtPVjM6Iav67H
 9nhqUq0f
 iPsYPx+bR7jxp92I84OI6l3jWbudVHI4quYtZeBSvYHHfDSRm100F39TwAwF/Ojz7QpBf4bSimOb4JqPA4UurV+BwTpR7DdtoNL1gt4EFhc3sTxls3qGma4Gi4DYFuunF8/D47KT+Q4WIoPQx/5u6xncrh5YOjyT90sT8fIZrluSculRDPVI0uR7Pwic2rIhYpff5EtCnXDVrmY85qLM000pP2Qtp3h5FEa0uFFhiHSBalIcuycov83LOTsaJEuFkDjeshPb42KelqytVfE7E91v1JdhoWhJCIltEKBRvPD2NJWVKe2Mz94Lq5STNJUBxQWD8kR/syLPBtBuPqizxa+huaVDMojxFlJf7m2vk4kM1lks=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 05:03:25AM +0000, Yingjie Wang wrote:
> Commit 6a4746ba0619 ("ipc: remove memcg accounting for sops objects in
> do_semtimedop()") removed accounting based on the assumption that sops
> arrays would remain small, describing a maximum cost of two pages.
> 
> SEMOPM is a UAPI default that can be changed at build time and through
> the per-namespace sysctl. Commit 50ec499b9a43 ("sysctl: allow change
> system v ipc sysctls inside ipc namespace") made that limit tunable by
> IPC namespace owners without capabilities in the initial user namespace.
> 
> do_semtimedop() keeps up to SEMOPM_FAST operations on the stack. Charge
> every larger, dynamically allocated operation array to the caller's memory
> cgroup. This avoids a second size threshold and prevents a configured
> SEMOPM limit from expanding an unaccounted heap-allocation range.
> 
> In a 4-vCPU KVM guest, with the benchmark pinned to one vCPU in a leaf
> memory cgroup, accounting raised the median time per successful semop()
> call by 2.3% to 3.2% for 65, 500 and 1000 operations, compared with
> unaccounted allocation. An invalid semid, which allocates and copies the
> array before returning EINVAL, rose by 5.6% to 11.9%. The 64-operation
> stack path changed by at most 0.9%, and successful calls in the root
> cgroup by at most 2.3%. Each result used 21 samples from three boots.
> 
> Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
> Link: https://lore.kernel.org/r/20261016152609.2528805-1-x-professor@outlook.com
> Fixes: 6a4746ba0619 ("ipc: remove memcg accounting for sops objects in do_semtimedop()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yingjie Wang <x-professor@outlook.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>


