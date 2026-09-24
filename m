Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C136C98304
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 02:37:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 671BF6B0092; Wed, 23 Sep 2026 22:37:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 648AC6B0095; Wed, 23 Sep 2026 22:37:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 586A36B0096; Wed, 23 Sep 2026 22:37:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 37D6F6B0092
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 22:37:24 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A0D85A020C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 02:37:23 +0000 (UTC)
X-FDA: 85247094366.19.8A0927E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8D44080004
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 02:37:21 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=JdwQyTYy;
	spf=pass (imf30.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790217442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lNw5PLgLy3N4zJJXXTRDcMcTzvBwO6Pk4n5mJr3iDWw=;
	b=mO9H8RAlzCcqSGr9M/TQY/W3qYbt9sK5sU3iX/pQrVQ6VOB7geqF8quugbAJOa3FM15pP0
	TMtqRO7moKJ41McgRtrYnDbksJg1xSQ1ieQASTLQ+gHbR7FJeKgZ3aYVtLc+yHRKaEojzy
	GP3k+gWwGeTGaXyq3okW+VDqrQrq4k8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=JdwQyTYy;
	spf=pass (imf30.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790217442;
	b=qkUPOhOlbH1bPQwZDrU/E3/bhKZPEgWVKvYMRrefuYbc0XrifU9G9pBux9GrOd0gv7ywTA
	TNn/yV3ugU/pPRDwKbTQOf8LYr4XSV8s5nrF1cHZwramyriigKQepapNT6DCbRrSqTERrd
	JrGIFfwgM5/YbN1GSFH7L5uj5hTXJFA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9BFC8152B;
	Wed, 23 Sep 2026 19:37:16 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5029B3F632;
	Wed, 23 Sep 2026 19:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790217440; bh=GiKDHzPpFLpGJ+NyI2Fn3PGxG+LBOmciezdoBuMh62s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JdwQyTYyCLq2dAuQ3V7VCWTu7ZEUpTZ5e32h5cPG3Zz1eFNKdLIfN2dBRnFOvwzm5
	 rVWcH6DnePga5DgN3Bo9/TWjlLCe275AZ9dIPbh6NN7n6gwtT2c5DnIbABUnJVjQQD
	 OCsyLaai6eUN0qCz9hghvtEi1pBzfk6yIuiOFGYk=
Date: Thu, 24 Sep 2026 08:07:16 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: linux-mm@kvack.org, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>, 
	WANG Xuerui <kernel@xen0n.name>, Helge Deller <deller@gmx.de>, loongarch@lists.linux.dev, 
	linux-s390@vger.kernel.org, linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] s390/mm: Drop all pxdp_get()
Message-ID: <scg5ftqczjhpoa4k3htrm7bzdf6rbxrk3dtwvgdfzg537is5dk@hykspk4yq2en>
References: <20260923043226.331880-1-anshuman.khandual@arm.com>
 <20260923043226.331880-2-anshuman.khandual@arm.com>
 <20260923091629.9636A36-hca@linux.ibm.com>
 <echvqvjj435meeh6gcrqewysdqbtkrsgayvsyfcr3q6h3bh7fn@hsa7xh22l4rj>
 <20260923143247.9636Cf1-hca@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923143247.9636Cf1-hca@linux.ibm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8D44080004
X-Stat-Signature: 1c8gp91ikf6bcre9rttaag394xap1c4p
X-HE-Tag: 1790217441-141326
X-HE-Meta: U2FsdGVkX1+to+0aqlyrShzpv/4mvYiqizZiVjKksPy+6KSTdtuxEbCHMnklUkn7xpCgSU1OhBnbd33tq48Hg6Rjo2ZSQ+d63RMbCWb3fe84yKqNAtFhqN/Lz0dxLCbIXNIMpARFUq8kjLcjXNTJqqYYfSS/hYPym+X7UW3tisb0irdXX89brbgICRaphAjqoDxXzEINTeaZs4AcQtgV7vojmKHS1xJcEOkxOMPE01vpVWVaDujyUu9gf0ql2XJuVj8XnfWeVrJ7s8TmwlN+6cn7v0GEwN4xyAMkzXUeZc5848OO2gpkrcL4102maW6ZMuMGw0Fk8H/vH/+WTcMxxQghm9o6zyPDBapZfaEPigHIuluX+nxfx7uKkrszYND5wlA/43QlCA/yG4XTWWSo3SZzVRlMA98HTq/+oktpSnkvn+xXHsntkB1P6tkBdnmjl+PMwGV/tiwsU1XKsGZOJljNUoGtJa7ygVSrgZe/8pGDyuB/h+XXEGWAJgl5VT7p4IO1T7HO7Lv7N+Glj+lEKAuXI9n6tuhHMxO+stcpzbB4jmluQo9LKDmpmMC9Eya34afA4fEufIZNMUwagnwnZIOhPS7iQ+mjRKBoNtldzPQWS/sxxit64cqgompnzNlcbCOb7zCPdeQT7HYRHisfGqJRcbpJlbFhiKIsKRKXt/wxIbbgZmg9axTfzca0xH1uxzes/MYyD8EpiizrJ/C5GfGxPex19TPlcNgH9jmcV8RCOtS1vGkOrYYhVggP+pAFRHF+MP4fRjChL8/iepSNlclseaUqwFlBH8MemtmZoaI2vRnNNJ9igk81COjxJVrbuG2CeyNB9yhhPF0ucf8Aw1D+pXBtYnrwaFTZQ2loKopNGAcsEkmS3RmtMe6GtLc0+3tTsTzSiYFvDqgBHZqx2QupI+BvUVEZCHzOOn1IZ6wohd1XRAp9z9oNbELhI4e5Ins4/qEcx00nzkqOZnt
 aUv8Sdjw
 KMn26cX5sFOoLwnOH09wvp1VDNL5ZfdsE3/SSDEhF5Tm2s8usgonvkEPj2QimEDyLBxBqZ3dNgrx7MJuH6BDJ/mu620SRKdDBWcgxroYHyLY7KHTzIb20SHzsUbinC0eMTvIE2wH1A9x/RiMlnbR+JKD5JyGGc8Sqtxo3aIdN54mA2UYDDlwvMWX6Hs2un/1S1xMiNP3V03z1ATwOgo1sSc4621OWpwvqqMlmGewnUvxGuPjeNNbhJqpuOqxgaCXg3w3f4/Ljl6hbq4Z9uSybTYCr1lBTBZjv3/lp7nd67YXDeUkn7iBzGlxuxrxda3V4vqXy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 04:32:47PM +0200, Heiko Carstens wrote:
> On Wed, Sep 23, 2026 at 05:42:00PM +0530, Anshuman Khandual wrote:
> > On Wed, Sep 23, 2026 at 11:16:29AM +0200, Heiko Carstens wrote:
> > > On Wed, Sep 23, 2026 at 10:02:20AM +0530, Anshuman Khandual wrote:
> > > > +static inline pte_t ptep_get(const pte_t *ptep);
> > > > +static inline pud_t pudp_get(const pud_t *pudp);
> > > > +static inline p4d_t p4dp_get(const p4d_t *p4dp);
> > > > +static inline pgd_t pgdp_get(const pgd_t *pgdp);
> ...
> > > > -#define ptep_get ptep_get
> > > > -static inline pte_t ptep_get(pte_t *ptep)
> > > > -{
> > > > -	return READ_ONCE(*ptep);
> > > > -}
> > > 
> > > As reported by Sashiko, this results in a compile error due to conflicting
> > > types; but I don't see too much value with this patch if a forward declaration
> > > of the common code implementation needs to be added instead. Looks like s390
> > > would be the only architecture which would have that.
> > 
> > We could move pxdp_get() caller functions from this header inside C files
> > like other platform changes proposed here. Would that be better instead ?
> 
> That would make pud_clear() & friends real functions calls instead of being
> inlined. Function calls are more expensive, so I would like to avoid that.
> 
> I would prefer to drop this patch.

Alright, thanks for your review.

