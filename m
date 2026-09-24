Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64A4BC98321
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 15:05:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46A8A6B008A; Thu, 24 Sep 2026 11:05:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4431D6B008C; Thu, 24 Sep 2026 11:05:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 359A96B0092; Thu, 24 Sep 2026 11:05:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0EB886B008A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 11:05:01 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A33521203BE
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 15:05:00 +0000 (UTC)
X-FDA: 85248978360.02.566590B
Received: from fout-b6-smtp.messagingengine.com (fout-b6-smtp.messagingengine.com [202.12.124.149])
	by imf30.hostedemail.com (Postfix) with ESMTP id AF82E80011
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 15:04:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="F VgIabd";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=KVVfqYfw;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790262298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DIUy5vQKOXFN2lL08HviUA0o+FdVXhGJw/1j1iGsdzE=;
	b=GicIdNA03kx65Ac933jVzmCBeWz0fqT2Qidb2OTr4sqlfFVkXEB63oXoTLSUQYthxPTu94
	LiFDiJWPltJYu4yH8brRN/3n5hj+gS3GKqNLopORMxOsdnTciAnSvd+bt2/+lPILEuOlvc
	y5LDJcVbfBVUTFhpXejAMgkoscteWHw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="F VgIabd";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=KVVfqYfw;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790262298;
	b=dJmn/knOQ00W2nLL2aqgZo25gSO8832PuyDG2liuUz1ScDJuTIO/ExZlQaS9OCZ5J1G3Cy
	S4OKTgwGWEdMqfjL/qCiDIiVuI3EBE8BiVmUDSNzi8nBe9RKcaAQD1hkuw9i4O+DN1HC5x
	ZPN1YiYPlZYaQ5/NOFkKMLjm4gyzRA4=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.stl.internal (Postfix) with ESMTP id 35D311D000B7;
	Thu, 24 Sep 2026 11:04:57 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Thu, 24 Sep 2026 11:04:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1790262297; x=
	1790348697; bh=DIUy5vQKOXFN2lL08HviUA0o+FdVXhGJw/1j1iGsdzE=; b=F
	VgIabdj/7yB6YPttCLEQcaHgU45z4O2cS79P8HixtF6GKqms+3c6SqqEzVk4ZgNJ
	1epuQPfTpV3akQ+Wr5ESA9053FYEr29W5Stvm/h6s8kyKw/Jl3VnNA1Zr+jjCxzi
	ApYMX2XeJXhCxHyundEz6WPdW9DUfwUjOi6F8r8IjNJw5GhQNTHnoEcXPtpLqk0x
	+fXXaj9jT6pgosvDdSj4jph7xG8eAFE6OAmAH2MFnCU2XYKs/Uv1pfYI8+iu4p60
	7TFHyWxFycw/kJzj56TcMxiUK4/ho4dt6Sgv9hNwoUDOwBNuAcOfZ+0iNl+5IJiA
	LYuTeIfD6k1yktRAhRNgA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1790262297; x=1790348697; bh=DIUy5vQKOXFN2lL08HviUA0o+FdVXhGJw/1
	j1iGsdzE=; b=KVVfqYfwW+bbAGInMakV53kEiLbWzeITtbsCyhv+y1iyVDtjMei
	ccN1Vqo8bEfkfEN1itSX2qv7q0qZdZ9jZhJ1WxRAuFBYabMzgvhRElwZxw1e4sjW
	btlvCbA4OEHuKtvwEPZy/6E7JkJt+CGmrWRSdaU5nqyGkEp2vYY5lf2LdIP6sAU1
	WAhFK1RfSKDertk7fiAyWe5EMe2A8+yNioTsWnBJbmG0G1UFN4Oxow1yJAe5hGK5
	DowwpaWEOI6Uv5I9d/CUKw6ODmtmXwFQ6kxl7KuA+u9k/rbbXl8MnqLX4aQinUUy
	ppY3iGrnYkIwP5Ch7an68Kd9qpa1IA4kjgA==
X-ME-Sender: <xms:GDy1am6OPeKzxeojEiSENrRV2geg7audtUUKvSwxP3vFXAqO-Zi47w>
    <xme:GDy1akJFvCWFh0kb6CLZxGI4ixWmN3ExsS3mftHpKO9hqHbqUNVUe0yK3_4fAv8yW
    TiRDEL1FygNDaIreiPVF0r8Oy3yJciHKTBq8XtiJGLtRsbxXYmdgysMfA>
X-ME-Received: <xmr:GDy1aiaBIlZfn-W412WsWw2JQR4zsdUFRVNzEv4LjcQRa9nFw95DLFPo-k8>
X-ME-Proxy-Cause: dmFkZTFzzxO9GJhqZRji1U6WGYOtJqo/8wd1m7DpqAhEfQiHM8PxAKtb/PHZIPTqGnlPtr
    IC38LgcQRtUfA+YRBrZJWxbfx6lsLVb1v3GNlP0+jHh2kqX4Ftpr2GDF/HH3teNPK3KaKJ
    CsKnbAAW1AS2xRVPSl/y/lQWswF5+0OC6tPdFVXYaJQsbfWCLs2STIkyocP3Sh8H08P2Yu
    WM9C00Tj47pQ7RE2vUqA7gFpfBGXbODUxPDjlzJxZugssHuBlpgTnh/CZ4rS7Z8bpezHXi
    dyfBFQf6icVSGVPtAhlwp2P5Z4QY7BdKiKf0e3OGpYiTDoU12wiBHOoju2BjX9SAIbTXgI
    xg01kCdH/QEBMW1GIKXf4ZAl6G76XB8/iZz0Ys8MFBTxg1DwWHlQQHwuvk7X3UGHxdqr1B
    LkN29UBO18CsmUuNux9suhAaLtphzwp99F4fJfX8OZ+neMo/BoXY9hv2bPTtPZgNZYUNVR
    2uV+GqVROrVR2j+bNmUjvKy0yNURWiZ2yKsb69UompmbbvcPSjaaW87772D6SIbJTam7F4
    f6ycHTqKCEv5GfeeU6i/QpCIsmq/Qc1GpitRbR+GHdwWJNl6EM1tWw49B2D8rWHhslCo+G
    a188bYAdw1EdBvmuIQi3LrOuId/ErPJAvFEO/IdZ/tsOpvCqaVwDUxcxPpjw
X-ME-Proxy: <xmx:GDy1ah2iUJM60SwA2yZxaKmwccrpVQhvN6VpiuTwemYika0H8FmS0w>
    <xmx:GDy1akNflc6PwdQ2ge_iYAc8qRxEeZK1Jpyh62poezyWs4I2eZkA-g>
    <xmx:GDy1arLdSNImBl_Jzd3p603sJWSXflkSpyDt5t_4jPzoRSGlsIlMyg>
    <xmx:GDy1at61LxDHWHm_EXySHUQhdAhqDKGWTAxlwCn-cGx4CeKxQib8bQ>
    <xmx:GTy1apBtitXHdVwxb9S77uNAY3FaDioGxJN_Mav4XpN7E1vO6mBsP1eZ>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 24 Sep 2026 11:04:55 -0400 (EDT)
Date: Thu, 24 Sep 2026 16:04:54 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>
Subject: Re: [PATCH v3 10/12] mm/collapse: work out the orders a VMA allows
 once per VMA
Message-ID: <arU7iYmDZj93KYnc@thinkstation>
References: <20260916093145.4022188-1-kirill@shutemov.name>
 <20260916093145.4022188-11-kirill@shutemov.name>
 <b5e5e4a2-db9e-4d8e-9f9b-954f3aa3a3c4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5e5e4a2-db9e-4d8e-9f9b-954f3aa3a3c4@kernel.org>
X-Stat-Signature: pje1cbqqpjne5mdk7h3sp6f6fmw5qs6t
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AF82E80011
X-HE-Tag: 1790262298-171196
X-HE-Meta: U2FsdGVkX19VGFc6Ur0zkbDwsk9T0U1QujZJriUZQ8mLk27vc+8ue0+9V7IOIo/XWDbbYP09wlFrRGKsupoC9ZynBlP5slXFyqu80e5N6K2PlkJWkU/NPziJxyt+hp2xy9iyZuBiqBd91veoLEogcs4WMNTR3SjdcViMEqyJZP0CpzwNBUuS0YJ41XJhADXiyOgTsKfdNYf9VPjWUYgMP1SqfG5w/53f9jziXVas/Ru3Y/VrpQZxWwmj7w08xgA51Ze7RUqw7vVBOKjyeKn3fj82ecsz1RJHZC/u2FfOuI0bbC07Q23nwOK/TIC33itNPSuu42bx3xGWi0xrqvRBZxzxHuje+Ogf+XNynwSvFf5xpzMyWc2kpxxxha019QaU4El8lS5Wc8/k9rR5AOhbOvrjKhVxleo7C9EAQAWUHuRRAKn6xtP9TmNxqaTOGGenAzRcQcnxDG4rqcYzXP+9owIk5xeQLmtIOmJugT5bxZ5PuH++TzYBKI9H1Hw9biLA0Nli2PQAsoTjVgHLvMYb+WwVs4pB+l3K6jvpSY3Mea5KpWNDMyu7T1u5tIHespoT3SQe64qYyAgAMtXB6esx2VWEsQqnZIMc/qmGVPIQZhqHSdSGbUpQRrV/Bb+BMErzQfdsb7TrZRpr7ggtbo89p7eXMNOcVrllGcayXsbzp9C5cs9TOsIxcfZZkRbBKAybOdMmNAIhclDWyMshSKVTGG2bqXwn/TRtX+7J6YWzktg3CXkqSsfZ4bruxy/I+Kqs9Nm+dUo9SbpH1b36gdBxB823IFcLrXNrAUuXozmJSrlQYaHa+RNmQe7IOIAz9xM4UQb87a3KNr3mGwB+Pv+jP6p3MkMGePi7cr8Ae3TbME9ztk0GRUWp/uL9xrLZ/u1KMeY+JIcQRMSYOjzFhU9DGxIB9WucdHbM+mFxAetiY+D+1Jtklml8Ile8QG55+VbzpXcmwbXYBs2AFmS1RKG
 3zl5glZc
 0jTz95lk4P+mHwzPCrMlPbyCvafF1oAPxiSDWZgSjDKjEL9cOGBV2Cf0fzmqlPAQ+VePQ/1FwGD2oECfY2EmG3qZ/J32DazQgSm8xpb4e8LThxoGbfmihZCnlQWH+ANKBGIEQDDFntBq2CckZxLBtuffEymWAvluaPbzYaOTTKvE8a/c/FgJnoBb4oUH1le1V9zlQe3uh0ECznOP/LTvHX678Cl0EpnGMC+G7nh25E0ykjPQ8WU82Fjry2RWcsoXbtPAP+TFTH5HaNPyjc7lvFEKc7N+BURDCufyxxnR04YngXrwVsAhYJ6wodAs2X9MSfATJQCpd5ht65VYml3Xj4ndiKeie7HX4Ds959ENl8mgaEWcxKvrsQJxQnbfVTPhsxKhyF+IWwKtNR+ye7LTxdD6rCgYJ92oAmbHmVEUBGnM9cRVnAK8/omFTig55reTKQMO/oBPbTFKjC3oqP0S6Z0rp2+f0VTZVr8mH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 03:19:36PM +0200, David Hildenbrand (Arm) wrote:
 [...]
> 
> > +		/* One mask for the whole VMA */
> > +		orders = collapse_possible_orders(vma, vma->vm_flags,
> > +						  cc->policy.tva_type);
> 
> cc->policy.tva_type is always sattic here, no?

Yes, TVA_KHUGEPAGED.

> > @@ -3252,9 +3254,11 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
> >  			}
> >  			vma = found;
> >  			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
> > +			orders = collapse_possible_orders(vma, vma->vm_flags,
> > +							  cc->policy.tva_type);
> 
> 
> That's always TVA_FORCED_COLLAPSE, no?

Yep.

> It's a shame we cannot get rid of cc->policy.tva_type because we need it for
> hugepage_vma_revalidate to calculate orders. Which sucks a bit.

It stays for the engine, not the callers.

The fixup I will fold in v4 is below.

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 2a10a30055c6..8fad934befe2 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2905,7 +2905,7 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 		}
 		/* One mask for the whole VMA */
 		orders = collapse_possible_orders(vma, vma->vm_flags,
-						  cc->policy.tva_type);
+						  TVA_KHUGEPAGED);
 		if (!orders) {
 			cc->progress++;
 			continue;
diff --git a/mm/madvise.c b/mm/madvise.c
index 33bcd390ce43..3087640ddaad 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1010,7 +1010,7 @@ static int madvise_collapse(struct madvise_behavior *madv_behavior)
 			vma = found;
 			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
 			orders = collapse_possible_orders(vma, vma->vm_flags,
-							  cc->policy.tva_type);
+							  TVA_FORCED_COLLAPSE);
 		}
 
 		result = collapse_scan_pmd(vma, addr, cc, orders);

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

