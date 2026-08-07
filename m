Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFE3BC5AC7C
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 08:52:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 878A76B008A; Fri,  7 Aug 2026 04:52:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8027C6B0092; Fri,  7 Aug 2026 04:52:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7181C6B0093; Fri,  7 Aug 2026 04:52:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4E2506B008A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 04:52:19 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B7D1D1A0116
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 08:52:18 +0000 (UTC)
X-FDA: 85073856756.25.0BCEB9E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 09740140002
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 08:52:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nTcT8qQ5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786092737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5dcfVoJ6AbTamxtwDiIevecxcWgLUpSF8Abt8+46V18=;
	b=u9xt+JE9TRSlA7dTVnOtUM0u6misMDcKxEe5+9LpItKL4KlBd1oRRDs/GshEnjtl8g+7J2
	5HJnPrNdUob8EnmX1lljknmBar5W84QK5zdfL7HbrBU3pQl93QYVgo8TuQGXUkJjprQJPW
	ecu/6C4dPFzAYdzPxK4otc+Hfek1a3k=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nTcT8qQ5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786092737;
	b=Wgess3MmVluuEq1WP+m60gEWROIyn2rbSAAJEDjkshpnRzHf4N3ZW9dNUDb3qhY3XI0PqW
	iFkoVeuH0YEVx3L1SAi0hLWQ3bjDRql4mUP3vDxeaIUzAWwM0ttQWWGhyzDIg9mpQvsVZE
	3py6MSVQ6KyMnUSZv+G/5RUgz+1Yl64=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 344324172D;
	Fri,  7 Aug 2026 08:52:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CD961F00A3A;
	Fri,  7 Aug 2026 08:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786092736;
	bh=5dcfVoJ6AbTamxtwDiIevecxcWgLUpSF8Abt8+46V18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nTcT8qQ51DH5ivaM/QlGSUOmHVRTjTlaGZWUFmg7j5tGviiEE7SKdugJMY4FCLM0b
	 bHPUbO9slRGyttKW5PcGlGFgT+zn1K0M7Mi+BC/LnadNL4IhuOQI1p4oBfeVsEVWd4
	 MY3wnYZve+r6QEI/Ue6Tb8OgO6pcif8+fTzSPSCAhmWis07T+fW4Tycszd8mhRyGG2
	 IxDDzD3eCjWy2Nib9EvdAgr5addJt1zZG1gGH+kgPQk1EjtxPmC3LqEC6GPBPqHDfp
	 XXDgvo+Lzz2SeVs3Cp0wsWiD1QRnE7omcZ46bUsGL/MrxC4b0C1jvz6eX9iWo9HbmS
	 oULyXfwS+jcrA==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Graf <graf@amazon.com>
Cc: Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	nh-open-source@amazon.com
Subject: Re: [PATCH v2] mm/mm_init: fix out-of-range first_deferred_pfn
Date: Fri,  7 Aug 2026 11:52:02 +0300
Message-ID: <178609265194.1678924.36219766049856904.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260807031243.87904-1-graf@amazon.com>
References: <20260807031243.87904-1-graf@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 09740140002
X-Stat-Signature: qeb7n1nh3wtqddfjcw6biix93f5gttus
X-Rspam-User: 
X-HE-Tag: 1786092736-313245
X-HE-Meta: U2FsdGVkX19Aq2lecQod/pKWHDmx8yFJn7Mg1s97cfcempM7C3UlJooyk45temlWc4OOYGoD4ftP8oNBFRMKsZKIlv9PtUuNBgkt1FuLt6ZyC5rPqSpWkn5JJ+ABUvFroSKpPdH5uf7zyUhbjl+tv/lmM7NzdLTyHc1E+ZOKZFwh7SKsS8a8rQ6pbMN0N2lxpBjGNz2fGmM69R5rDrGpsQUNRT221T1/cbk0uMnzkgCMqrUhlTJkGEzIQKWHnnByF+U2/8KSZDWyhmc3NUADiCe8i4UuPNlj757pIqASWqkGDzSyLEJF0NX0y9EAw3lt8a4hFW3JqZ0oXtrswp3i5wGkBnOTUc83pGUgBMIfWuXVlecKDh8Wg8jpZiw+tqcQFHhLtGg8Hen7jFQcEerLf+heX/MG1/NCGs36wMru57g4FTzMnQ5vVoGcAfNANx5q1qKU4A3MUgkQ1itTbvFtr6PC2SipsXRz8G63uhPtZyBWazo3H6LC7rC6iLZBa7NpFiMHOJfMlklOzqz8vNSZCy7Vd5SjGgWiiLvb7xyufbEabNMsji8Mboph5ULNdkXXsHTncDQa5mgamw3h2scNDGxh245hYsK2ejpiskP5F+Q4qbqo3XrP9CP2HcApXiT+MFGVmYU0QCUD+4Oq9b6xvyISaImR6PKR6QtxRPaPq8pseUePTdFfrkWrMAGAj1C4oarpoXktjwKFa5nj1GJ+0L3nlwdW4YOYZ7Q+90OOrCE7maRWSXjCVIO5mscjaHUDAQhW3gFnfSJHlJp5K2R1nouN0o4f9tZP3MZ3O11S0MiasUWLveQ2L+LldT/WIhg7eVHZ6QfA/qk8KEJ3KvS04TRsauiJmU8L+BsB9PI2zzJ49wAuGsU9d9AdCWwytsI/C+FSTVTDcm0WbuAyr0CGzvT7AL16/4gvn1Qs0o7vhYxzoS01idW2ArBBvz9qVujS+t6h16JKRR8teZqjKGa
 WKixy17E
 f8gc61XwgiED5f30+8nT2dzeo/ocqlrSRo6xJpkPMcxnKBmiIVQi8krm/fCcXl2aTolpqo6EgsAZRtwFiKjfprMLAe+pTYZmkT/7fG7Qp8OawEfqI5qoRF2v3bxjbnzeynyFRwFVefyMs1FPNmzCn/hm4MR89lp8VLiYCNXH/Wqb/vJm5/zYC1ESfs1o0kkI+4lz7OvH7i89SmqPHb1R/QPOUld6f1JYDj23hln0zWYgdxTfJDcjGHrGV2hUI7rhubYWl+NPtZFaYHLOxwlILbzcWigB+9+2RYsHWm6GDQFcinhC7ZjtYczlQPwyvOEirAN21GGGZD+OVyx9bjSl8QbA+eDe6nsY13cik/HyMDVSPuJQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 07 Aug 2026 03:12:43 +0000, Alexander Graf wrote:
> With CONFIG_DEFERRED_STRUCT_PAGE_INIT enabled, deferred_grow_zone()
> undefers struct page ranges early in boot to satisfy an allocation.  With
> a large CMA reservation in place, the ranges it finds may not add up to
> the allocation it was asked for, and we end up undeferring all available
> RAM and still fall short.  That is fine in itself: the function accounts
> for it and leaves the caller to decide whether it now has enough memory.
> 
> [...]

I reworded the code comment and the changelog even more and
applied to for-next branch of memblock.git tree, thanks!

[1/1] mm/mm_init: fix out-of-range first_deferred_pfn
      commit: 97090500d776c3f6d08e857e3a0a7cf092999094

tree: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock
branch: for-next

--
Sincerely yours,
Mike.


