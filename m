Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62660ECD983
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 16:48:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A102E6B0089; Thu,  5 Feb 2026 11:48:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E7906B008A; Thu,  5 Feb 2026 11:48:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F3BA6B0092; Thu,  5 Feb 2026 11:48:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7F6276B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 11:48:41 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3F6AC1B28E8
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 16:48:41 +0000 (UTC)
X-FDA: 84410986842.17.E602A79
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf18.hostedemail.com (Postfix) with ESMTP id 87D771C000D
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 16:48:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=MMnVnRsR;
	spf=none (imf18.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770310119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yx/d01Y58MDZvuU9Az//GxypXm/UanK1HY+5wvpwfYU=;
	b=bTKnZLnyrHNeqYMVSbV14o2YyX/TVxpbuCPAurZyeFbvOYHKnXs5aFc2IAtWdrUSrNVcoA
	NOPy5AclKeOM3UGC+n2ZXsxwhgsHuidHyROuW6xuS1wekCNx0VK6dleX+tuVFmrlHfHWzD
	j65S2Qc/pVG3KiEszOOi0TPgaB4o56g=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=MMnVnRsR;
	spf=none (imf18.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770310119; a=rsa-sha256;
	cv=none;
	b=mg5u31hfwOd42z2oIMnMpOtvMcAXoatNzVi/JZoojn9rrRMsVld5Jp6VUzW4gCIRPD6Bvy
	DPg3nH/Ibded2XCKPkRmnien7weHA3RhcB1LBEnbCoVkkR3B7EQwIRE2IORqh5PcVMpTGy
	UKjq40gEAFxDeOZceL8fIKHzHfY4jDQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Yx/d01Y58MDZvuU9Az//GxypXm/UanK1HY+5wvpwfYU=; b=MMnVnRsRRqqFRmmqm8szxt55xC
	kumtGKJdsNGk1kzy5/T3qafT1MGgU2cyyBGV7bHPnR7O4Gh3dHG7iA4iulap9fnlIK594qOoyzuB4
	SVND5ODlyYngv7IzrVCeW4d01m9p7gb5Abo1jCv8lodGXGY9zl+G8QcqV0MyUZPRC++OePTTDS+8J
	uCGDnccOQoLRqUlTap688HhAGnOPvG2RtjFzFGbJZePYaReJhbIxVuCCsQKuqZ/fgpqAVsHkQuyA8
	iV+1jAgW/LD2kocjmOpkRhJtk9e8aXYQ6I1HL2ds9nwQlDVOgvXaqc2zWr9bHLK+Tx3jF0OJtp0IH
	wtE6Vjpw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vo2Wb-00000003tzE-36Oa;
	Thu, 05 Feb 2026 16:48:13 +0000
Date: Thu, 5 Feb 2026 16:48:13 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: Dave Hansen <dave.hansen@intel.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, Liam.Howlett@oracle.com,
	akpm@linux-foundation.org, aneesh.kumar@kernel.org, arnd@arndb.de,
	baohua@kernel.org, baolin.wang@linux.alibaba.com,
	boris.ostrovsky@oracle.com, bp@alien8.de,
	dave.hansen@linux.intel.com, dev.jain@arm.com, hpa@zytor.com,
	hughd@google.com, ioworker0@gmail.com, jannh@google.com,
	jgross@suse.com, kvm@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com, mingo@redhat.com, npache@redhat.com,
	npiggin@gmail.com, pbonzini@redhat.com, riel@surriel.com,
	ryan.roberts@arm.com, seanjc@google.com, shy828301@gmail.com,
	tglx@linutronix.de, virtualization@lists.linux.dev, will@kernel.org,
	x86@kernel.org, ypodemsk@redhat.com, ziy@nvidia.com
Subject: Re: [PATCH v4 0/3] targeted TLB sync IPIs for lockless page table
Message-ID: <aYTJzft5cuqD9akC@casper.infradead.org>
References: <20260202133713.GF1395266@noisy.programming.kicks-ass.net>
 <540adec9-c483-460a-a682-f2076cf015c2@linux.dev>
 <20260202150957.GD1282955@noisy.programming.kicks-ass.net>
 <d6944cd8-d3b7-4b16-ab52-a61e7dc2221c@linux.dev>
 <06d48a52-e4ec-47cd-b3fb-0fccd4dc49f4@kernel.org>
 <3026ad8d-92ad-4683-8c3e-733d4070d033@linux.dev>
 <64f3a75a-30ff-4bee-833c-be5dba05f72b@intel.com>
 <c985a8ed-37ad-415e-b7b4-18a66b4da3fe@linux.dev>
 <647cbe2e-a034-4a75-9492-21ea1708eccc@intel.com>
 <99237729-f2b0-4a7a-8213-65a2f1c57744@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99237729-f2b0-4a7a-8213-65a2f1c57744@linux.dev>
X-Stat-Signature: d5i1z88exifo3os4yrim74co8et8k9kb
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 87D771C000D
X-HE-Tag: 1770310118-449788
X-HE-Meta: U2FsdGVkX182Yv8yinBQ3l/kGHphUSgxF22WW8INNCjUVUctfagmICX+XITd5IeSrlM3+hUMvHyhRoZI7jrDSqOy35Y+5tmFtqi/mH3ltOaAynA+dUSootZaja7YqZwsMx/K+C1YpsatNilHfLgnv5EKF6YXu0WuNDTxh1c9zL1AHSXxodpRl3mwut7IBu7nicwgV+k874qHv7+bBol/9h4nBVw1w3o+WihX75nJZKsy1y0YA7/2rALWR+bb2VKwcH3jXPpVOQbBxq1DIPyNExD8W8SWJSdWBVoIWgGpmGC0+uOceroKC5ElvNXllrCCi8okpybQrLNN53CKLHFAyccJ0t+N7ddf5VvloyNe5cY4SfbwHKpbV6YH26tcqmAfT/+xPh4um0Q13S5TNatHlM6Ag3QWvxBIqeoTQxdYHTJ6BkubRJK4jMLioeDFjHFaAovDq+2qgg0mXKHIOIy51wVQlxeuHR97qo9uW+oqcFFB8YcVcQRa2fa4FZQfe11Nmtw5Mt3vrD6cg0TYa32b7GqCYfgPwUOLChNi/aKl6jiFvlh7NvPG9Aycx/EL2LRMHXorsEfCzr/YoxI/iz1ysKMZa1VBuS2biBWgxfeIkuuKiKbM66BDZw4s83pTdGinR7BnC/Dn3Tp3jkcWjqyTnF4J69k817ktvCfKqK4yeHU7/VrrzaLWpOnGd8pwqB4/hLb2YW+/mdE1HlD4IOrRdcpdbZjwFNmMDjo/s8PTGjdOp75xuZiilW9Ln9J/8qP9nBlZTNeb84GeI4vdqGRvT5vgqKNTdQtREJ8w52aP+1GKVxxBdXwYPrgznd0gK2h5mq4lGZlE6QlbRXfolhoN8dr09xaDTfd/C5dxIDA85jJ5BTVL9asAdS7o+uSXIsBU37pKq8ewNWMdpdKr/KpIFPdNqu8zBoYaH3rlkW2DHFDXRww24LrkH5XEQu+6i44scw9GKbXykzgM4kOrr62
 fDZlaCtv
 JLux8wnvsQFyB6T4rpU9hZYxIT+tMexHzw8fG2WDTKl8Cc0q9JnayWcz25B4hnhrjVMctEvE8l8/+1EUG/1gtnKKcFHHlg13HjQRLER9Vyfb7jTi2g2eLMI8VVWZ/PkJ/oI5tE5qp2AlTb5Ft/aCT1x9E92ySRzNqeBX+IkcStD2PPNM3kW++WZJ8KevaA9dJDoi/2Aqs7Nwnnrzmw0xT4Yt3DhWhZiiBuR1bFbLEzIuAATOwpgpIqGDmrvIHKh+5mRxT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 06, 2026 at 12:30:56AM +0800, Lance Yang wrote:
> On 2026/2/5 23:41, Dave Hansen wrote:
> > Yeah, but one aim of RCU is ensuring that readers see valid data but not
> > necessarily the most up to date data.
> > 
> > Are there cases where ongoing concurrent lockless page-table walks need
> > to see the writes and they can't tolerate seeing valid but slightly
> > stale data?
> 
> The issue is we're about to free the page table (e.g.
> pmdp_collapse_flush()).
> 
> We have to ensure no walker is still doing a lockless page-table walk
> when the page directories are freed, otherwise we get use-after-free.

But can't we RCU-free the page table?  Why do we need to wait for the
RCU readers to finish?


