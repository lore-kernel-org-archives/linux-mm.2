Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1DCEEDB7C4
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 07:18:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 297716B0088; Tue,  7 Apr 2026 03:18:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 247C96B0089; Tue,  7 Apr 2026 03:18:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15DB26B008A; Tue,  7 Apr 2026 03:18:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 06D206B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 03:18:32 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 934228C25D
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 07:18:31 +0000 (UTC)
X-FDA: 84630906822.21.639FF5F
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf15.hostedemail.com (Postfix) with ESMTP id 204DDA0008
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 07:18:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=nImR+pzl;
	spf=none (imf15.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775546309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NDKl0CmwVm2mvyWYjyJbm938Bi5mo/cdP0hUqRq6tEE=;
	b=GCGph8S3MMVBknO/Gfu8xj1UWOdemxshfXzEj14Uq3pT/T8M+m4BuO+6Gu8XcE3UwCn4jz
	LuUDZTMzWTuNJbVUCIWGkb2Swzd6o3JKiKFrppFGxsQ7izCmndpEYJUvOOPRqW4fMgf/Ey
	OUfAw2L8k3l5YSFBOFXDdRf77XF+9cA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=nImR+pzl;
	spf=none (imf15.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775546309; a=rsa-sha256;
	cv=none;
	b=j+OcGCuj4O37M9ArXwiayr4AZ5CsTnrrkIMGg2yCoPkM3niB8yBW/MxkEdL7ba5uwVKdXZ
	Un5QASdacyNhQHGqFrnua+ZEV0m3BzrYB7VIqcrGqxVqEo/o6A+0h6MnAvpzxKs3ZrghQA
	+uANHJywRiX8/kdVCObxqdrG2wemBBA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NDKl0CmwVm2mvyWYjyJbm938Bi5mo/cdP0hUqRq6tEE=; b=nImR+pzlf/E+k6Ma2TQTt6jT6l
	2JLKZVmBxi17iw1W/l3Ap5rhlCZD1Sc8D4LNAz+UHSJhbItR7ODULzTGUXb9Nzytd/4aEziswqZXw
	gPaLLGQv6i+rQKdovhwW1C42vaUPoDgcxwKtBaFFcHlCEZTRKwDRVgnvRTsLFMoCdCxaxGIkonduX
	S3QeDEMcyVEWErBSyZ0ptrLQy4W1OdtaXKe8rSmHZDd22q+OtGs5+VXMOZz/P7fSvk9jox/wVhCT0
	dMekWcdoBdB93vT4UGHyKzaP8Iep7ySwxQGJj8vjB8snrYcT4suIoX5TaTsDWFXaUB7YmCKAa0k24
	p9hFBJfw==;
Received: from 2001-1c00-8d85-4b00-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:4b00:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wA0hc-00000007kG6-3xHX;
	Tue, 07 Apr 2026 07:18:25 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id D7DB73005E5; Tue, 07 Apr 2026 09:18:20 +0200 (CEST)
Date: Tue, 7 Apr 2026 09:18:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf/events: Replace READ_ONCE() with standard pgtable
 accessors
Message-ID: <20260407071820.GA3738010@noisy.programming.kicks-ass.net>
References: <20260227062744.2215491-1-anshuman.khandual@arm.com>
 <1267a6c0-f8e7-4708-96da-4d131b5c6069@arm.com>
 <c7688962-d10c-49e1-a434-ab7ae2c64cdb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c7688962-d10c-49e1-a434-ab7ae2c64cdb@kernel.org>
X-Rspamd-Queue-Id: 204DDA0008
X-Stat-Signature: chbj7fmp6dne9rjnxonso6gey95jryz3
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775546308-854649
X-HE-Meta: U2FsdGVkX19F+iby8FVlLbHMjoHcsztg4SIKQSH4sXFSw+8+2AthUH34eh7UxiDaSMGLiGuX4PagCoNoO926ZaFOYrj9Iwpwa8epI4dCyktVK8Fchc45GzYM7rlVyMTMEidPlAT+BZYXSxVvArDdYJrGuA2qxTDkwSBmFRyQXo1rQCQHzpFSx1eyGqy4vSaehLtekO4SNW/q/DMrKwkDE09/FzSTfcAlEKc4Ucvd0MvXABwXv7F29jnmFFZtSTEfT2Md/k401PqjAV/8QF4/8SflPLB4RrR0Tqzjrz+v+JYEiYxrtJ/SuC5JoMucVo+A0sTKD1n/tlYtDp2PfaFViYwbPI5WGtquOWjM7jy8QJerc6l8us+j3nQ6YAK3Novt8CbFyF8+/7LD+DsW25nLBr87WjxsprCHShRlp997Z49MtTTeEKe32BkD5TEbBueaD8JUTtS3GmsV24v3nEX3PbwFof6nEYKtB5EomF9Nauan1aC5gR8mhWXxKnD8CdXQ2VWX0oiPgZov5dwVyhJ6pGO0xf9mX5mD8NCTOXXOtb7eBJsjmWqACe0Go6/3Q6feBbtGDpKSTY0XeEMerwetFdbUSuUYJ0hDN1s5vtl3ZaZHFkxYBKpgQzEJyGBCnPCS5oek/05ss2HCbYFHkmw+zU/McZlAVbcrVwvD/CVXDSz5YuiqEYMISzWjAx2wmaCuDZlNcYrNZfB33ftjr2VyJzARpRGsBqsTWw53gwsRDEzfaQcbxNxn3K+W1lIm5OP9xTfXh7R2bBJ6oCR/JtCa8MYDbaJI62Uk1t4uBm6TXMipPVHFhPCNd2Cg6PpdXgMBgSqshjlTTvVYDDV7phzplfY721sjhR3iev3embFrkhZA3OZBfcFwlU9KJDsBaGRgf6ww9Jt4S5PTmGgXeagvKvop4IYp8cwusLOjtLSsI60DkZgQ1NU5nKX+8VxKq9Mz+Gs2kWt5cPRm64gatXU
 6TE3EBkK
 2991hpG+mp0idjkLhD8vusD2Hyz+21jKgr5SQsCyRmSEJ0jH5Z+Mlk50yTJyk5i3z3zoZCNCFGzC65WnRumiavOzhnKMBaEAoD3SqXLVYbEI3RS9Gjk0KTxwPQidHaikmcmr/6CXoVlSfadSHaGzvJ52EY6FNTvjDSFfK2E6DxaPj+EqF+GXX5Op1PeOhF7/G/yT+VjLTAY01Oo2RqTAPRgm6hgugbgIykP5zlQ6ddBpVbour1M1bhlfE5edjGZdFJM3Ml2QlacxykjeMVsjehTvsamTUm/0T1DevAtbpwYzSv5yrwtTvuagXrmKarRx4pLp4xa9M7dMWlOlrmcaTnxJTwSdZL5fiiDFYXo3Sj3AspM23wcb/Cqz1bDCntrXwrMsk4YOwKBHTYqAmuMxWPl61ScdWe54Ci6jogdJmEYjtyaWB6k+NlCFDj16M2u0k9FkAlBOiSMIpZbG8YpPfCkwiGrpLtjZRQGstW2Ce0WF7c0m5Vc9H0ZQp+YTSsZAZDP8oa7udVF9i3AXC0hEWavQuTIvpniMMbPoUNvq8kxV8qvutfwulRZKMOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 07, 2026 at 08:48:22AM +0200, David Hildenbrand (Arm) wrote:
> On 4/7/26 05:28, Anshuman Khandual wrote:
> > 
> > 
> > On 27/02/26 11:57 AM, Anshuman Khandual wrote:
> >> Replace raw READ_ONCE() dereferences of pgtable entries with corresponding
> >> standard page table accessors pxdp_get() in perf_get_pgtable_size(). These
> >> accessors default to READ_ONCE() on platforms that don't override them. So
> >> there is no functional change on such platforms.
> >>
> >> However arm64 platform is being extended to support 128 bit page tables via
> >> a new architecture feature i.e FEAT_D128 in which case READ_ONCE() will not
> >> provide required single copy atomic access for 128 bit page table entries.
> >> Although pxdp_get() accessors can later be overridden on arm64 platform to
> >> extend required single copy atomicity support on 128 bit entries.
> >>
> >> Cc: Andrew Morton <akpm@linux-foundation.org>
> >> Cc: David Hildenbrand <david@kernel.org>
> >> Cc: Peter Zijlstra <peterz@infradead.org>
> >> Cc: Ingo Molnar <mingo@redhat.com>
> >> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> >> Cc: Namhyung Kim <namhyung@kernel.org>
> >> Cc: linux-perf-users@vger.kernel.org
> >> Cc: linux-mm@kvack.org
> >> Cc: linux-kernel@vger.kernel.org
> >> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> >> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> >> ---
> >> This patch applies both on v7.0-rc1 and mm-unstable.
> >>
> >> Part of the D128 series but independent. Hence could be considered on its own.
> >>
> >> https://lore.kernel.org/all/20260224051153.3150613-5-anshuman.khandual@arm.com/
> >>
> >> Collected Peter's tag from an off list conversation.
> > 
> > Gentle ping. 
> > 
> > Still don't see this patch in latest next-20260406. Hence just
> > wondering which tree and branch this patch is being picked up ?
> 
> It's a trivial change and the last generic code change required for you
> arm64 D128 change, right?
> 
> I would assume this to go through the tip tree, but if Peter agrees we
> could route this (mm) patch through the MM tree.

Right, I thought this was part of a larger series and figured it would
ride along with whatever other patches.

If you still want me to pick this up, I can, just state clearly where
this ought to go.

