Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76D22CAC5B0
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 22:39:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFDEF8E0007; Tue, 23 Sep 2025 18:39:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD5378E0001; Tue, 23 Sep 2025 18:39:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C120B8E0007; Tue, 23 Sep 2025 18:39:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A52468E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 18:39:28 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4979CC031C
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 22:39:28 +0000 (UTC)
X-FDA: 83921982816.02.B76A82C
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5FB52180007
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 22:39:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=SojriKu2
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758667166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kMNRIy7juPEY6DIXxF9DZzfJvByV0E5yz461o/FuEmU=;
	b=jpSDtesvCHfF1eUwrR3K68m11F7LWlSODolbnfKvZ9DC4iKzV5puA30hFhAnfI7QZXM0S0
	z2XB6Q3KlieyU7PJKl+SB8O/41WKuA/8ps3BsAdc57pKsAFzUrW5H2GGG9OEsgbwkewA+3
	yH8Ru9ZgM2DmpbFx6x+AV7+BqOKwC/4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758667166; a=rsa-sha256;
	cv=none;
	b=WhKAwiR0m4CdfS49aZhK2cyjFqRoARemXAlRY5bxftv/AlmZX+pz42vyCJd4zoUaO3gzTE
	gtm8zoryTDDFooNnQt+99THjzo7zbt4Be8IoP0wZJBiOYRkuaHiFw1ysAGAG7ma6FWKwzO
	ErF4ChYcGRVdOqsSeQaurSEvlnBWA94=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=SojriKu2;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kMNRIy7juPEY6DIXxF9DZzfJvByV0E5yz461o/FuEmU=; b=SojriKu2ZEAiqDCZFCDQRhRKhn
	nKspnPTfBVKaUKc77OtjSxdvixl+GHzCJK/5nnDH122mvTIjGuaDBtfO2/vhms/1t4MnJvEPwrhjB
	SL/CfblZqb+J/Mg1qpXUiH8CIEeTs7RnM5SEdFEjpxScnHE1UEuvNZ37MUF2Idfeulhmd9iuFHN+X
	YneEJmmbwYFcgPkAR878Rq4Hy6K/em+73ZwEXsSrT8HKSJSfk8+IhYUuoVieViWI58YHUR7Ufjd3M
	/5l7MwBlIgT3Gk4OECBaBAUXXAeZup1SPEBlZdCDvKR6uwJtaxODOFfE3ZGINd6WxrnAwhB2zzg6Y
	5izeBW/g==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v1Bf7-00000002lyS-1MIl;
	Tue, 23 Sep 2025 22:39:05 +0000
Date: Tue, 23 Sep 2025 23:39:05 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Yin Tirui <yintirui@huawei.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	catalin.marinas@arm.com, will@kernel.org, paul.walmsley@sifive.com,
	palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr,
	anshuman.khandual@arm.com, yangyicong@hisilicon.com,
	ardb@kernel.org, apopple@nvidia.com, samuel.holland@sifive.com,
	luxu.kernel@bytedance.com, abrestic@rivosinc.com,
	yongxuan.wang@sifive.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org, wangkefeng.wang@huawei.com,
	chenjun102@huawei.com
Subject: Re: [PATCH RFC 2/2] mm: add PMD-level huge page support for
 remap_pfn_range()
Message-ID: <aNMhiZ4FiEE1Rk_T@casper.infradead.org>
References: <20250923133104.926672-1-yintirui@huawei.com>
 <20250923133104.926672-3-yintirui@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250923133104.926672-3-yintirui@huawei.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5FB52180007
X-Stat-Signature: z1eqghifski3nui395gcde4i4uejtqri
X-Rspam-User: 
X-HE-Tag: 1758667165-745348
X-HE-Meta: U2FsdGVkX1/hD28WlZoqKmMfaxghNjl89hCazmoQIna6gQRGJIoh0fRVG4eQEa4FV+eEs8zBe2YVw6+8ah/hsSufcAk2K/XIH0X/FWeVUIw7rQkfpDvKvcUrMvrqSYDlRRycuxpEtEYEWJPK1+AE1rGLe7MRsRsg7Y64jd050EZKel5L+8oPWhY9jkDT7gX0Exu4UzMofBe7JNu0wiHpYTryUOs6ogEv2iNK7Brb+X2KPOLcqubAfdZm1i0Lh7Fce/REgR+QTmWyDukIJjrez0ZueTTzjfvRpttR7fumQ8zxaK096VOTbM7v4/mBSuwegKVS9ZVmHM/5ppFluFnHSLcHa2q+pZSkJ4kGelxOn0aiByjffUHDDgGLPuLs+MSHtVdUMk35M65CmCVG7UsBBBcDm03bOophtfTzkwEWU/Vk12OAojHUeAO7nnDxB1Ry7Uothzi3X/gddq7BUzWjR1uB8hzlJKMwJlqM5ABh1fpGHrLYI82rbddl+mnsUTCezMjIpTveM54E22drWvtsnfT/dUwCKzbUMmEohGn3JH0mvd+Ndeib41jxkcN/YJAzfD/9KoI2/rhNAj3vmYEiV7WMuTez7B0cLbQO/QorLoqlWkj4rQmxzhyEuhK5e6MZm7Kmqyg6Ud9smPo9wh9NmBKZr30+fm5uVIBNziRciVugnqyTVcwSe0nfMWiq3UebZ9/pywd5IdudD8HIFMDaoZKrWMYCMdHIoQfnMzZvefMuU00p6DfTMcNWzuu6a/4NPX3hRxav0zwgGQfTtOXk1bkP84x2oj3jg9aGgXMIUPiaBFOTrCdAbB6RTJv/8Lnwy5j9PtdDV/YTA8pAGaCKgwHsKnrt5dOguC+dYnuQ28l+FxReS21JOE9T8BKVkKBb8HFkf1c+CwhHWCt3LJDSirkKm5E79nKBoUWtET+DJO1H0KIjc9IFKhmVjwIYStDcvynMYr5kdyZiHiU1r8u
 K4EEGrsC
 a/qpeMDbd6tLazHFs6aN7PRXsB6pg8txBH7Q6t5oueE256UjNwsi1E2v9SQjyVu354o3YY4iVTVFqbxXKOjbkOQPu8mRWlzoQY8BwzvgN3Qb2/dHoDQrNN5KAA8QbqzgBVTVyWaiU2Uasd81sJOWuLjI2UbagJ9cSdwXgMw3aHBzO8Uvh8TJkoxaqsiuyCur/hbyDP0e6HZe7MmBQGmhxL1prFNeJd7IyRDGFQJF/M+hyYOAkFyNepp1w5m3nPTMN/OfBldafIJ/HSagBJjY6acAhCwQpRJlYo9tvSE3A/EUSOoFOofosK95Ftw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 23, 2025 at 09:31:04PM +0800, Yin Tirui wrote:
> +			entry = pte_clrhuge(pfn_pte(pmd_pfn(old_pmd), pmd_pgprot(old_pmd)));

This doesn't make sense.  And I'm not saying you got this wrong; I
suspect in terms of how things work today it's actually necessary.
But the way we handle this stuff is so insane.

pte_clrhuge() should not exist.  If we have a PTE, it can't have the
huge bit set, by definition (don't anybody mention hugetlbfs because
that is an entirely separate pile of broken horrors).  I understand what
you're trying to do here.  You want to construct a PTE that points to
the same address as the first page of the PMD and has the same
permissions.  But that *should* be written as:

	entry = pfn_pte(pmd_pfn(old_pmd), pmd_pgprot(old_pmd)));

right?  Now, pmd_pgprot() might or might not want to return the huge bit
set.  I'm not sure.  Perhaps you could have a look through and figure it
out.  But pfn_pte() should never return a PTE with the huge bit set.
So if it is set in the pgorot on entry, it should filter it out.

There are going to be consequences to this.  Maybe there's code
somewhere that relies on pfn_pte() returning a PTE with the huge bit
set.  Perhaps it's hugetlbfs.

But we have to start cleaning this garbage up.  I did some work with
e3981db444a0 and the commits leading up to that.  See
https://lkml.kernel.org/r/20250402181709.2386022-12-willy@infradead.org

I'd like pte_clrhuge() to be deleted from x86, not added to arm and
riscv.

