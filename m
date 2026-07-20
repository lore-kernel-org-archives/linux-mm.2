Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB05BC44527
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:56:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9E406B009D; Mon, 20 Jul 2026 05:56:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4F0C6B00A7; Mon, 20 Jul 2026 05:56:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D19036B00D6; Mon, 20 Jul 2026 05:56:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9C9AA6B009D
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:56:46 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 26A26A1012
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:56:46 +0000 (UTC)
X-FDA: 85008700812.14.1AAE994
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5F70B1A0004
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:56:44 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Bl5kuH71;
	spf=pass (imf19.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784541404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T4P1uAuS96oO2CYd5dZWKgEcG7rXEBr6r3ZYGLFiIQg=;
	b=LEwj5R9pdBJiIDb3g0vZJShly/eS4dSc3Ms5DeKga4fuLJ6nZAbILUT/JC4USrH4+TQRhs
	ElyJ9M/0z01bJnoxusfP1M8JkWi28pSZHNUvHbptHiUZeQG8ks0GbpYxSeretshSEB2+Sg
	SozHNs4M1oxYsQFo2BBpy9MbdRgPUgs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Bl5kuH71;
	spf=pass (imf19.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784541404;
	b=6Fbt2E4xATerEjV8FIuMAWuKBcCOV+S2ZMnQ2GQ22i0UVA17eiIuRoOkdP5HtHQW8V9Qh3
	pGSomthVJ+cROXIhfY6zhcByMLFvz9XmHdnHQtSDeK2wnzEkRalj1xHeiPzSpmqbgzXGkv
	v6hxQ5XBbPZTASuYxSgT3DvonK5Cv5k=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2cf52d15d88so13229165ad.2
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784541403; x=1785146203; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T4P1uAuS96oO2CYd5dZWKgEcG7rXEBr6r3ZYGLFiIQg=;
        b=Bl5kuH7141Ppa8Cq0dEc4CWvL4d+49IhAiysagBNnuB7K8WjKaxakYdidN1+hdSe4M
         84zPZ/6ETWmSTwET3KolzsDhkLCaqWzJfYMHlE96rH7VTngebIVgWHun8BsygNA7LNuE
         2HkNWnkfPlbP9Tpq6EhoytTKdmUdfboWuCYNS4vA9ZnsllInxg221HIoD/U1bVHQjg2Y
         ve2ASjUpSJlLA65Ep0aNWEFRqkI9fdGj104waITISSoCJ12MP9BN5xHiTpZ7W5oGGDqR
         BVSa42iJWLeIc7QNLaTAmax9+1xEAxUkXHObTm4rNCNXGijyYZFi6tTiLkrNou32zNns
         PdKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784541403; x=1785146203;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=T4P1uAuS96oO2CYd5dZWKgEcG7rXEBr6r3ZYGLFiIQg=;
        b=UbpHc/goaVWppeajdiU2/4mkRcl6WfDah/covLzm4qGccmASRNayx6CsHfkMQRlapc
         Iu+nZd50uQEUlfJiXhRg8OR6EJKFEBlcN3M6G3l0xb0Pa5d2/GzS723Wt+PZLl/lw3nQ
         2CJ0BnfbcAg+LIFbgYZ4Y9JsGDz+slDyrfcCQQSw4RmzZcakBm/SXPEFL4VlCJZA2Qt6
         9aFaqHC9Qu2i2he6CCXMdtAp7pfjiCMid1r5/eruXNHGdhs/7sftrC1dG7mGCMsGrCX5
         70abZApb/WWqEyma19kP6e5Se+pWBLGKODIKH1uE0roVO2VutYJSicYtL1wPi80XnO1j
         NIwQ==
X-Forwarded-Encrypted: i=1; AHgh+RoE9E0clmA/GGMBU9MrM0zCAl0m4OMSZu8ytGWZZRpx78faQ2hdm64zcX5NW8DpyDcf73BNndHFEw==@kvack.org
X-Gm-Message-State: AOJu0Yxdw0bSaWINABT4eAzqUirNkv0zLACWyDTl7NGxVP3q9UN6E3tD
	B8QlDpatNbX0hveJN42qJyUnLe+oTT0YVC9n5GbO0ppbprPrOeA8Bb6P
X-Gm-Gg: AfdE7cl7L+u/kivVH/QeB2GsqbNjdclY0O3zumV3zulG7JDbatsdSZKUAothhFBRr5G
	KAtvnOAyB4yPEo52lhTp+W+kNo2+SZzDjrrrJCCR9Nk6rndS7RfZLnHG6yJcHwEudMyv1WS1H5t
	2LW7aoFn09O518kYVw8D+3fz+NYGRdgElBgeGoNABZx5UoKXkxVDyO5hmDkreqDzB+6E9rkKVul
	qV0iTMoakvmOHBMcga1eY5t/oKyxR+F6567qZWBexsQAbPi5LJRixPc0YCAp9IUphySFXH+WKtE
	CBhzYOKHqZ1aO4reGltapdGp+pHExZKJrD/YKSb++Kd6EthxGPJPPCxFhwXpOwBpxHLM6iBz5QK
	5MgMohu9vzuSgNjYvU4PznDqHW+iL4zTBnnCEawRRftl1NY6oPjO3fJHVclMyRpBjrVQNx9XPGt
	QiYAQf+6TMMDkWSZo7C008keYHJT8=
X-Received: by 2002:a17:903:440c:b0:2ca:1594:451e with SMTP id d9443c01a7336-2cf3496b583mr155402025ad.31.1784541403123;
        Mon, 20 Jul 2026 02:56:43 -0700 (PDT)
Received: from localhost.localdomain ([112.65.87.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf344bd3aesm53940335ad.26.2026.07.20.02.56.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 20 Jul 2026 02:56:42 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: david@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	sj@kernel.org,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	npache@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	ryan.roberts@arm.com,
	daichaobing@sangfor.com.cn,
	wangkefeng.wang@huawei.com,
	gutierrez.asier@huawei-partners.com,
	zengheng4@huawei.com,
	kasong@tencent.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	lianux.mm@gmail.com,
	lianux.wang@processmission.com,
	kunwu.chan@linux.dev
Subject: Re: [RFC PATCH v3 0/3] mm/damon: introduce DAMOS_SPLIT action
Date: Mon, 20 Jul 2026 17:56:33 +0800
Message-ID: <20260720095633.32281-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <59292ba2-e0cc-4e50-bb26-be9c15843a41@kernel.org>
References: <59292ba2-e0cc-4e50-bb26-be9c15843a41@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5F70B1A0004
X-Stat-Signature: 9r7nwa8ymhyab8mp46hx8xbwwzpqqk5x
X-HE-Tag: 1784541404-707695
X-HE-Meta: U2FsdGVkX1+e/IO/W0jaySzVg4qhmr9idsG1xWwUQf6Cl91nCvB4tNxKBPip43q+7vy1noYl0MuAdwuIDkyaZArbawy0CZ5+AU3Z7TO3BvDG1DzEIdu/9dXwtaRTLnEz9hnTAklltcQBQUBGTZwZj+yYlrWJsp94kcGoq3UHviuhcMG2Axe61kqD/BKbXA6dyD2F3r4+flkoMlsg5tLX7aeDVv/Rt9jEW0gLm6NksMIiJ3PtfUyK+qLCi0b8RKodpgeQm8rS92LJYu8J+6mNVV4xNTPNX7aWUt8/J/KGKGaPTN9JdOaYYwmbR0ONCvRMzxWW366/phkQOvz7MaKRc1hCBTfnAsozRNMoAwWFEp8Ccl57xm/jDXSgJcJAtGGxreiMfizfqWh/su0ko+1ng22MnXXRrxt7xZmBLSH47BrkAVBvx7mmnVZQuVRahqHI/6siCrtRubgvlHitsPfH+AehHJL6ykqr0j0tcRlkc+QQR+78qE0HAcOCAXZCH7Pag1FB+Moot/vl2iAbIEpZiPKaQzCqqTXPrbqWFundTmKPD8MdGI+kwHjv85+mq4LldeRHLE3GahApE8W2c34wg9ck7RNJsd/fZgOd462pE49vLJ2wOL7oGI1kafZCgcGAbzqgaPhgAjeoRrVg5iYl4+Cx8ke/rbbJCvW3Zxtn3zSTWc8DQWU5AqvI5I8HP//s/7hox9rDmHHWJ9UeTj6fpU093bXPeFdPk8vFwggWSZckznflnXrAhRoLnV3jZmipELTW2IwDIujV8L21taE0dqeAG3qbR1U2MPiapvI79cHPjizaJdRVXtsxLKyDsL0BWJt/Ft+oBC2AxD3r0T1XS7DS+L7fWuDoVvyHBHnz6twuTTlQrKCKn96y3RHPEAgu7Jr8+b3YjNK2a/hTiuYaFn4eR1BvOxb2b0/m/fMtSSvuueIAegGHrggqzFU+lac9ueSEyiwTlK5xJUf/5jq
 ZFXPvN5G
 aOmfwm8E91R6zYqL903KY2j+zYpHrE6DUwRjwv0af0VvO7G3pCG11dxUoiL1YMBBbtKdzHKbnKcfaD1Ui0TPytgEYYNnrqsNQfaB4erW8pw0S/WNk28mLGnnj/97ELg84r59vdDIrV45qiqgnT+sKTDZZA0IncfbYEpQX7kvThsiZN4awTM7sl+gWjx5gAMH0+f27qIiASAjhDqbhj6un0BJhD/wCJ61aGOHmela2bPCzJJLnh5w9kB00hRwvcweD5gRTnGE9EJP8skEaBw6iMcAOsUC6sXVkhIqL6ORdyjKEgiUlyfj111Ij3gvUYBHvtmC3GA54V9Ip8ibTk0Un5hzpVCBr6ZlnLB3RsRdl0jhSXakC03jRReVDQrfa8Eh+npu98m1RxGULOqHRkDoPZbdY709SjPS32iM8qbVRBxmeHFsW9u8YtvYB/LR+AO6mj1/YEsRPBUHdLnZ9EDrOFHtIvXreLeFd/1NroXXApVkb6oUKR9lDv42StBwdu4TA4n8vIOyE+zLfqj1A3jXO29beuIHGefA8cdQY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

On 7/20/2026 10:44 AM, David Hildenbrand (Arm) wrote:
> you give no real motivation and evaluation why this is required or
> why this gives the user any benefit.
> A SPLIT with an explicit order is not really want we want and it
> does not fit the existing primitives.

Thank you for the direct feedback.  Let me explain where this came
from -- the cover letter should have included this context.

This started from a real problem at Sangfor.  The scenario is:

  KVM-QEMU virtualization on Kunpeng 920, with KVM guest memory
  backed by tmpfs shared mappings (THP=always on the host).  An
  Oracle database runs inside the VM.  DAMON monitors the KVM
  process on the host to measure the hot-memory ratio.

  The KVM process allocates and uses a large amount of memory.
  Under the same workload, DAMON reports a significantly higher
  hot-memory ratio with THP enabled versus THP disabled.  Direct
  tmpfs write tests inside the VM -- touching at 4K and 2M
  strides -- show a clear gap between the two cases.

  DAMON parameters used:

    operations=vaddr
    monitoring_attrs/nr_regions/min=500
    monitoring_attrs/nr_regions/max=2000
    monitoring_attrs/intervals/sample_us=500000
    monitoring_attrs/intervals/aggr_us=20000000
    monitoring_attrs/intervals/update_us=60000000
    schemes/0/action=stat
    schemes/0/access_pattern/nr_accesses/min=1
    schemes/0/access_pattern/nr_accesses/max=max

The underlying issue is that under PMD-mapped THP, DAMON's monitoring
granularity is coarser than the actual working set -- a single
Accessed bit covers 512 base pages.  Before SJ's probe infrastructure
arrives, there is a gap: DAMON cannot distinguish hot sub-pages from
cold ones within a single THP.

Split is one possible mechanism to bridge that gap -- by dismantling
the PMD mapping, each base page gets its own PTE Accessed bit and
DAMON recovers fine-grain monitoring.  It is not intended to be a
permanent API, and certainly not "the opposite of collapse".

I did not write this scenario into the cover letter because our test
results do not yet show a clear quantitative benefit worth claiming,
and I did not want to oversell.  Without the context, I understand it
looks like I randomly proposed a new primitive -- that was not the
intention.

SJ acknowledged [1] that the monitoring problem under THP is real.
My RFC is a concrete proposal to start the discussion.  If split with
an explicit order is not the right primitive, I would appreciate your
thoughts on what the correct DAMOS abstraction for this should be.

[1] https://lore.kernel.org/20260620203915.82947-1-sj@kernel.org/

Thanks,
Lian Wang

