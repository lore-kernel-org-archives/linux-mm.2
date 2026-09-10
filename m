Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE1FCC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 13:04:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5ACD6B008A; Thu, 10 Sep 2026 09:04:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0B476B008C; Thu, 10 Sep 2026 09:04:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFDB76B0098; Thu, 10 Sep 2026 09:04:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9CF706B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:04:44 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 421ACA3B90
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:04:44 +0000 (UTC)
X-FDA: 85197872088.17.9EFBCD9
Received: from flow-b1-smtp.messagingengine.com (flow-b1-smtp.messagingengine.com [202.12.124.136])
	by imf16.hostedemail.com (Postfix) with ESMTP id 43122180002
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:04:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="H bElgJR";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="oVBZsIV/";
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.136 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789045482;
	b=3Nl5SJUFz3ro3GRxyjkwBW824GgfriQNr6g6gLjJp9ivO5C/BI7ZHbT/wGanpasDfW0R4F
	T9hQ/ZlPibG/hBt+TA9RAtDjDelWYp2+4DHbI9U3B5KZdU6MF3Jhcim6nIx+IZfhBcjsrc
	CBaj/zUUqugBsE3zulCR2UIiW/GST3c=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="H bElgJR";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="oVBZsIV/";
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.136 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789045482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KV7XC8+HfJo2WCcRdFe2DjTL8zq9dSIHiccyK3AlT4Q=;
	b=HUPuF2EQsOW/A2QMQnG+in2SaBRlUkmkbZ3N8OZXkp8t+p1l9xLXsKeI5TASs5oj0M0hr8
	sD3gsM1IlkHW8Bbz5sJDVLQq5RpHYZzFTUqg+qvmlZXDVURjs+His79HME/+iSFvcmEnIT
	rjWx8lJhKZVL/JiY7bqNcEz3QMrKRQg=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.stl.internal (Postfix) with ESMTP id 311BC1300DC9;
	Thu, 10 Sep 2026 09:04:40 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Thu, 10 Sep 2026 09:04:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789045480; x=
	1789052680; bh=KV7XC8+HfJo2WCcRdFe2DjTL8zq9dSIHiccyK3AlT4Q=; b=H
	bElgJRMEbERl1+nAd+kW9yaqu2UYYpiIMMfqBOlgxuZCg8RzxiGpYJ3HJLUO1lzO
	LDl0gXvqTEsdY1A/P6dKgL/PlY39t3HlsPhcsQrC9g7ITFQiNILUVZqLE1lFKvSI
	hCYWo8hWgzVUu4/uegICPxVIYjvnm+BKURMtflLpLWaolzZJwSYLIiHCDtWpUTU/
	h1Uot5ZXV5vBIMZycPWrhHBouSonC0RIQn6CLlNKZFa9DrZ2gDkdjQEfn5MoLjzC
	Wl2+kF+G+77XzuHyHeZIaIDSqsxAIaxGxrc3XYvKLiyUJlf2AFwngH+m7IcT+jL0
	Xv0w/x+1LhsDBTd0/wwdA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1789045480; x=1789052680; bh=KV7XC8+HfJo2WCcRdFe2DjTL8zq9dSIHicc
	yK3AlT4Q=; b=oVBZsIV/jGPLkFnHK5fKCRceo2RhqyVWgJrMPfTJzhd3TzQxKIW
	sto0t6rW4VBiR/rPUkK/AdM58b7djr4IS/70B5HeMEQnKLQREe7aU/8gGTCtr5hl
	/3LxYzRh6P72wjkgGiUTcnvOgr9PB8DSpj/3iGi+tKgeWkA7wZuzeEJo7jjLbAUX
	ihYq0hMTk8uLu2m15H/zcD0MvC+oR/azRxVj5X6kz8Q5Ypi2IICQIUxD9sqD/tvq
	N3NE2uwVlXYjb+LpsFPKJwGw7S3JEu3asBHXTSoZS/pzHZTb8gM7EMopILscFFky
	0gfB6VrfHr5TuZ7fz6ZwsWjlwnRxZA7rsoQ==
X-ME-Sender: <xms:5qqianj176YN02lMJxSb4EhgK6XJtpxMm5s_wF8HORrZBsSvFLtVQw>
    <xme:5qqiaktgneoW465jMDoTGJ9mBgF3LIte14lEibp_-xu4Iud84BrOG2uotCs9MMzRu
    Jem2JRdAplIfXhDt53RLPVOh2ZTPO3Hm0JUc66BNJCgPG55Svj0OvSf>
X-ME-Received: <xmr:5qqiaiLJoEc6orBizfd_a84A21rAjlmVVDjrAEtHakmiMH2QSSAXngH_Q3Y>
X-ME-Proxy-Cause: dmFkZTErqcWawBBo4NhlkntMFUoIJIaTUydErcobOOD2qAARaG/wohlBtCRTJcJOM32uP3
    Su2EbwwCyp3i+tYUvxY2bamyQSTy/GKV369qRr9JqOWEPBUJxU7Z3UmtAq5W/iHR2L9J47
    tt2BIFncpu5ZNx+sqC5cXqahs97pcgKZbPSGqXMpO/eInoNtlSNtCmaahg1NAfhhBYNSzG
    mdVcqjwhA4ZOSmHsK3bJ8OZwAmUgnvgizo6JLW2iY+tYJWxkD/JyrUUQkamZ3ACJHeWiut
    e7fio3BHz99JVq2AIaS7fMDOFkOm4z6epfRVHFGZ37qIK1VIWQ8NJXl+eU3AhPq8T5iYmU
    Kh3TN5NnQykKmZ6US7nhNTnmJ891tXgs7BvVN5lWXoG1cSxevyWz07UCYd+fVZ1OTe79PL
    MbYP5qPaBmTkSqT5lzJ0htc4A1Y0PDLTU+jgCIn22Jir/NPJEjDcjtFW1917V6SFWG4qzX
    IFtc0qLFt+t1dExkY8i9RuPI9QCj174skW5QzCXtckImpPHjb/mT5dOm5k3f8v9tZVPT0+
    bpHHEZzPhkRCWbEca5c01lLweMm0oZYg1/+cOpHlCpsfwVDYDZNM37VM2do+gv5D5NYyZh
    7gJVUH9jUCEYaFksK3SHd5B2ovWpO0fZH0AUyFOq2PvNUvlBRdEbHCJz4jyQ
X-ME-Proxy: <xmx:5qqiakQBUz5ibuwpZUvVFWhzF50qkaTG3wibznBs4EVd7YSkM4w2Ig>
    <xmx:5qqiansrfVFGHZBlEpqA73jPCfxbZFDsuj6W4a51WSLlNz670Hu3LQ>
    <xmx:5qqiargQBe4kcB93VgrvSkPR_d15jPamovI07Zy1lehQeVZvpRl5NQ>
    <xmx:5qqiao2S6dERuJZ6cSe5xZiW-MzHNw7oP6W2AzGNuaO954chXvrvPQ>
    <xmx:6KqiapOv4Km96vz_Hzt7vlskbffNMNn6M7FRmyBNRq0yuEjl_J8OndKQ>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 10 Sep 2026 09:04:37 -0400 (EDT)
Date: Thu, 10 Sep 2026 14:04:35 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	rppt@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, usama.anjum@arm.com, usama.arif@linux.dev, nico.pache@linux.dev, 
	ziy@nvidia.com, baohua@kernel.org, dev.jain@arm.com, hughd@google.com, 
	lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com, ryan.roberts@arm.com, 
	shuah@kernel.org, surenb@google.com, vbabka@kernel.org, agordeev@linux.ibm.com, 
	jgg@ziepe.ca, leon@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v5 08/19] selftests/mm: add folio-order check for address
 ranges
Message-ID: <aqKqr62-718Vw35k@thinkstation>
References: <20260908125105.1510704-1-kirill@shutemov.name>
 <20260908125105.1510704-9-kirill@shutemov.name>
 <feb76c81-db9d-4a36-9a31-0b2b31e3c3fb@linux.alibaba.com>
 <aqKFXlpSELmCtt-z@thinkstation>
 <65bf1722-c1fd-452a-88c1-c030b042cfbc@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65bf1722-c1fd-452a-88c1-c030b042cfbc@linux.alibaba.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 43122180002
X-Rspam-User: 
X-Stat-Signature: bk3q5pxado55f7r1gkaik4jgd8f78ymd
X-HE-Tag: 1789045482-261079
X-HE-Meta: U2FsdGVkX19Enh3lvlNXm/l22/LV6I5mXQBxQhK5db0lnVU92aGvZ0pOG5SDwIzWwv42EQzpNagglyD32VqgmiaO1JsPVeaUFWAQZIsSrgYUJoYoTdLetbnijbmXeSIaguTXcXGBpFNN3q9Opk4vhx8+CKNco8KoGFrvcNj6Bvr5kIP8BHbbO4ode6wGHf4ulDH028kMd45QbGJGybXHJJT4/LOgdxPr52NGs7pEAqQG8o7NTgzDyxUmfShYq0ukMraf+GNldaXhLBU5P1p4mgMjfz3pdERfvJeougpKpBO62Bi2jCC80Oo8FHDt49PJ7H0D3fqqqfZ7b99qtZzV6kGzN8uRSa60IxwlJUHeiNmpcWbM1IyMuyOCm89JhA7aGUu/0bYDsfOrsuHXI1oKMzAdlrQJjehwSFMMnkqirxkDuGBNsS3KXF6cwn4hpZ0txTdrtKNLYiN03r/U1JpsAoryPzENkTS//48XDtyocRTUCRJyk84A1dOMjPU9+5TYJIeapG/KWJM7bJWzxceEqaDj8KMUO0ThWGI5wbkI5SPafYznlFS6DsxMbaFynyOm+VLSy545KRRfQMgACxJV3V9HP4yX+0axaWG+MasNiUbx3W8HcqaHM272U1Tp0P2bqw9HS99oO5QaTaWlcLndsJHWAJEOaKpDGG1QYjBIkZehWdK1R2qYMiJFtJhxLbFnSiJClHRxTkD861wkehN3VMT06+qw2OfX+f42Xp/8NZUksi0XjlkmCtPZvVsMUnfqzFFen5TBSeN9U9JP17EXyY4zAbYM2QxEDY5DR1om2FbUcg+3KueE3T9Ie++pOQaYepIg9tJ4drJq6IlII+c2ebuuuRtaXdTDuzwl0NzDOAOUBN06C6xPHAbBtqbbcRyqJxOVYTfQxhHMDeznles3nfGLm8iPCh+Ba+ghMThLQzEyG4tjeMW+o75b6PLZvUZlzW9uF0ZMs+D73tekwQH
 aILaDtOR
 C0eeUw4E2D0DuBwxWwAeN7UnngD+vumYBIBTnkhiQm9z+C2CeALa5SSQfxf7kdkDMqFyvyrp03IjtmwYSNz7rcYU7BGTKeX4/rwhR1f/fBRS0zeSUGkoD43eJNupdqUt1GdIJb1qNm6vfNHOO4aBwfsYvQvERQ0hi479FykuXAg4fUYxQYLy27UNXo1pv6O633r4mtDAlRGVbxkWTKJDNTp5NF+bxmDQE2Q9z2AWOvxuctHHqJ82WiwdN+BvwC9SAgMRuWVd7s/qY8qt2/gz1I68vfj2npRI9LXbi62BDakuc1D7wC99Z1nZS+1YE87Z0Pw/ZI3hao9t6T+8FREB3LHcVJfcYVDEoRnPjFbwYRf91HjKT7jlOOXmvXQ4Sj5oR92lW2FJcWlkCPy91imHyoRYrPZbLi7JHT1dOOH9afqHUYcYYkceLoSTKOaZw9PjU0BXe0MVAZhDS61VPDFUXuvJ9Ig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 07:14:42PM +0800, Baolin Wang wrote:
> 
> 
> On 9/10/26 6:45 PM, Kiryl Shutsemau wrote:
> > On Wed, Sep 09, 2026 at 06:01:13PM +0800, Baolin Wang wrote:
> > > 
> > > 
> > > On 9/8/26 8:50 PM, Kiryl Shutsemau wrote:
> > > > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> > > > 
> > > > An mTHP collapse test needs to know that a range is backed by folios of the
> > > > target order, and that they sit where a collapse would put them.  Nothing
> > > > answers that today: is_backed_by_folio() classifies the folio behind a
> > > > single page, and check_huge_anon() reads smaps AnonHugePages, which only
> > > > accounts PMD mappings.
> > > 
> > > Have you checked check_large_folios() in vm_util.c? It seems to meet your
> > > requirements, or am I missing something?
> > 
> > The changelog is out of date, sorry: since 6dedaf0d46a9 check_huge_anon()
> > counts mTHP folios through check_large_folios() rather than reading
> > smaps, and it is what check_huge() already uses for mthp_khugepaged.
> > 
> > It could do this job too, called once per window.
> > 
> > What is_range_backed_by_order() adds is alignment check: the folio has
> > to sit at the window start. And check_large_folios() reopens two fds per
> > per call which kinda wasteful.
> 
> OK. But can we extend the check_huge_xxx() functions to meet your
> requirements, for example by adding a check_aligned_huge_xxx() that wraps
> the underlying implementation of check_large_folios()?
> 
> I still find it confusing that khugepaged.c has two separate sets of
> functions for checking large folios.

Agreed that two sets is one too many.  Yeoreum's series rewrites
check_huge_xxx() on top of pagemap and kpageflags, which is what
is_backed_by_folio() already walks, so once that lands the two can meet:
the mTHP branch of check_huge() checks each window for a folio of the
order at its start, and is_range_backed_by_order() goes away or becomes
its internal.  That also makes the generic mTHP cases stricter for free.

I would rather do that as a follow-up than fold it into either series
now, since both touch the same functions.
-- 
  Kiryl Shutsemau / Kirill A. Shutemov

