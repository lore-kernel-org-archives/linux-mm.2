Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED935C79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 10:09:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECC3B6B00A2; Wed,  9 Sep 2026 06:09:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA3EC6B00A4; Wed,  9 Sep 2026 06:09:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE1656B00A6; Wed,  9 Sep 2026 06:09:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B37F96B00A2
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:09:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C56F5A332D
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:09:35 +0000 (UTC)
X-FDA: 85193801910.05.39927B5
Received: from flow-a4-smtp.messagingengine.com (flow-a4-smtp.messagingengine.com [103.168.172.139])
	by imf27.hostedemail.com (Postfix) with ESMTP id D91B740006
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:09:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="d Hr5WeM";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=h2HgDVy4;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.139 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788948573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hCQxSP3iMVV7NPm73HmXp8MIEUwM8cXfnoRsOm1SuMk=;
	b=NXYbo/4PchiueW7WWkFxzg0n+vYdChTkkRSenJ3t8AMT6xetiUJOIjlbBKe1NQhq5vFApB
	T8IKkFq/dsKZkTmKXXYV2KnNALZqtJ5AiUpvH5KRbHq1HUlb3wU1eDt+7FxZU6VSj4D+qZ
	oLczd0GYKb5nmVkBGSf/Ej+3I3CCxkE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788948573;
	b=dDKYQJP4taup2wYKvzOFfRNweJKeN3ZB9h/eNglX5x4Crw5nmgGFpaX52IaI3eOHqGSlJG
	ajYH57Ox+4Qg3BrYn+FHViblq5yMTu0nTrABTsSPxlbYu6fDASAscMxQx37kiQ2bUjyzqe
	e8oZguXMI+aPV+vfa6ueO3RXt9cBP5I=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="d Hr5WeM";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=h2HgDVy4;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.139 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.phl.internal (Postfix) with ESMTP id 4CE881380293;
	Wed,  9 Sep 2026 06:09:33 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Wed, 09 Sep 2026 06:09:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788948573; x=
	1788955773; bh=hCQxSP3iMVV7NPm73HmXp8MIEUwM8cXfnoRsOm1SuMk=; b=d
	Hr5WeMlVnNZPiAsRPVQln0d4Xz50T0qoMS0UgyP99HPqLjUqkHG3vzqaXRVszVLW
	iyiMWzXE8q2BinbYdbDGrsxOneDAlC/HovTpKJgqRnadXy5FjR0Do5DoWFU3jEpt
	u2LtChwdgG+dy8DpVLdrC+5Z1lXqI3utaBIrcSSVKiSuawnWY7QWhFX5UmHgrBhW
	qx/dgLIDeGkxkFfkn32lJ6dsd4nmDzt5RMt8Rl+PHjmUFAGH4tw8nsxRUC6S3u99
	l9ykoylgMQw68Mcus9q1cNkQWYUK6i5pMMmt92c6dpEQwF9E5AXIsFc8UVKgEqry
	cXsCsxtdUiMV8WHxIIYdQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1788948573; x=1788955773; bh=hCQxSP3iMVV7NPm73HmXp8MIEUwM8cXfnoR
	sOm1SuMk=; b=h2HgDVy4rMVDFrD8a5Oe9f2hjrzVlDnu5TECZFlz85bRtUX038Y
	PhPZA/tuOD7mpjMhJCWRVRxCA0fShUPTA94qTF4kaDL4dW87lnIJeZTjV38y+mC2
	Y6VSxuvPeBOSSYBO82uTGj1l8IEvjQfZPncJ3zjDVDv5+V9qoQq7JHN6ArwbY2ZA
	oL8QOSunOiLd5Y9eiTIEmCKrP8uSKUbU9/ifBVigXgT2Vvx+4VDrO7rdJyOy86YI
	KrRYzBuomCEszbo8jgg/CZwUGbvgd8oJTd3nh9fHrCdLK1F2AK9EUtYVmJMwDbWY
	C8jw8PCz1qZSy72aznt1wWwfORMTsxWA0dg==
X-ME-Sender: <xms:XDCharjo66WAfwcvg_5lzdpIMh6Ll22ahn88vCBkwpu8HIUZbgyeXQ>
    <xme:XDChaotyb5ccBC3pgdMGr60S3y8PT5Vxl4yTMAJEbcmVDOFMlN4QMUCJDVkBXfnyC
    qaTpzYZqTom9Ib2pSv8zpdKbw9R_mKn3FfUE7-q-ng7ac2wb1UxvQjE>
X-ME-Received: <xmr:XDChamIOeOwblLyo9MBXL6JBAtI-xBoqEfDYY71_y8XZjzVDk3TRA-jqpWI>
X-ME-Proxy-Cause: dmFkZTEiW/+nV4rYmizBlllYjdWy9jqvSxZvqNJ2q6qUteD5fJ9Zyb9yTBIim2RhNlQ4b7
    dMU4PfWTx+fEvDEUlrXRcrV/figM7CPym5AZYRJVJNmn85DqGnaTTKigjK7TO+5UJNb5+H
    zZTX0MOEmeJWrlS20GJ9h9BA11Co4qs4/a7UaXtQDfPG2no4Lspj7lqjKuTCNe01mTRxvB
    qtVY9Md4LCjxgbvXrRnHrCR0Amf/AJXmWm60OREt75lWIqdbMok8Gx8O2c2GKF2WYbp0JD
    T+RmkJhw717rL/zb2n67g2KxEzUEsb07n21PWMubViHRv40sddXv9VXogYAhZryvsNmyJD
    yO0fVz6/nZRMnhslX8P6rOxVoIZtPCMapnMTJmJD6RDaFyV/wCynU2R1uVnpblGxkDvjqp
    9FB8hkLOcU/XtSz3LO9vhiLyFDztFrfCizSXvok5/VSsBXgu3akdPY/LVH8FFQLplkHdHH
    oUlyi/jFqhkAhkvYUPtQyUQ2V1Y4biHXW7KkqiiVmzzb/UtG1pUfUuZdIcaow2LZjZCW/Q
    6OYCRBVbtdFTtmpy4rp/eq4Jzw63HjVE6SdCAzkxfXKuApgtWjgU5+uShl2JPPIvbfypYy
    DQTs2guYTe0360dg0KUjggE7aMxcQdSVyqo6kC7VOzXukdb1+aHUp38spJxg
X-ME-Proxy: <xmx:XDChaoT9Mi3oXF210UIpyYKCmcuwrI_FNGLJ0DSyjUCwoXHQLiA6cA>
    <xmx:XDCharsSfU6L978DjCNzkyGOTRUwtbsO7xjyif50d2c1xKQDyXKWHQ>
    <xmx:XDChavgGvj9BCNmP1Hz7qbUe2wBz4zMedsxxqzo7SArFo5ULQocckw>
    <xmx:XDChas3r503mikOJvxls3XXGwC3dSawaWXvyBE5hh7J_gpes4eGCnw>
    <xmx:XTChasBKVHnDnA9J4uZmm_88pbEwcS2Xy68NsGIYcdTYE70cqP6kC-X0>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 9 Sep 2026 06:09:32 -0400 (EDT)
Date: Wed, 9 Sep 2026 11:09:31 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	rppt@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, usama.anjum@arm.com, usama.arif@linux.dev, nico.pache@linux.dev, 
	ziy@nvidia.com, baohua@kernel.org, dev.jain@arm.com, hughd@google.com, 
	lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com, ryan.roberts@arm.com, 
	shuah@kernel.org, surenb@google.com, vbabka@kernel.org, agordeev@linux.ibm.com, 
	jgg@ziepe.ca, leon@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v5 03/19] selftests/mm: scale khugepaged's collapse wait
 with the PMD size
Message-ID: <aqEvyYMGaPiyW_Tt@thinkstation>
References: <20260908125105.1510704-1-kirill@shutemov.name>
 <20260908125105.1510704-4-kirill@shutemov.name>
 <6ac7ea7d-38ae-45eb-8d98-f626951a43cd@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ac7ea7d-38ae-45eb-8d98-f626951a43cd@linux.alibaba.com>
X-Stat-Signature: sn9bt3698pwomikitgkzc7jwsnqh3bzz
X-Rspam-User: 
X-Rspamd-Queue-Id: D91B740006
X-Rspamd-Server: rspam03
X-HE-Tag: 1788948573-271556
X-HE-Meta: U2FsdGVkX190EpPZzD3BYL2IqHPW+xWk1NR/UEzz7lX/eXledYddC2Mtw7+gO73qxWsEDpG15rZHM7Z0qjrdtTMBE3LQIPAepw9txH81SKck/JR4SdZsV38l1gHyiLjNWSuk4U9ajGQeyMCaPAWWVCB0DP9Qy7ktuCc+1TNUlW/EfCqbLpIvD6WedfaZ2hPydHhOTMUWe+J5b7TAZK4a6pdF5mDOY/DeOVJXOuhQj7S5ByBOSwiZTC6eF//l2e3tgt0+RLIoYcmCMtn1XzzJCZKRedUwOyrr3R5kovFfjsfApKZwqyfIs0q6NUdNINWkMzHaHMMpXEE5FyQAkDlsHUSBlEUYQIn4Om+7DpqtNKaLRohj2rKu816s34SdfCpe85aRlUX5nJlsJ/tfAUVefXS7GpAqGBPzbIZmOfzAVAriBl413SnnKYr4qxe5/GG1hwf/QwBksOTIC2a/mMGVjosQdvqNB6hYEGKwUbiEcCqG+n637FK/GgydkqLPnG0NMFJ1LeYKY6Wup6kYwHTjM91PPNOgS6fLYSZVsl5ere3Vz9EDKxmcGXs6Re2LG/JpgFIFmgNgr8dfRLxH7YKdjr81X7t4E932ZOeMzb/DHzgrUeE5xDDV/zNiDfeodw78Cfq1u4ftIjfvRGuvfZkO3Ibiqx5zeDDh6wveRBfrfeVnkoE9aZZjBvfECVpNzfE1ViLjGJ7mR0OdKxNf9xpABI5JNAZ1Prmw16GQXMYWuUU5ggn31uIxvXsanejpaPC/JcmOk6qta03b7MK8edflG+i4DUc3z7sdIqKpZvNh0knn+fzoTR4bOS8LQ8OrWJTHu1d8PTYVyJ2Xhxe5SGkPrGqQWAJly7lku0xXq9cZGxR3CrjduNdEMHTI40+UTtzrw7JdLr3nEa8SS2tHH6uU5zqDYk6h7RGY2B4iJiiB5ZubkQaoF1Xji2F4b8iawP3uq7nfE5ekx3+kmiI1Em0
 J8Rswa76
 HKeJ3GHARBdmfp5LJZuOEMwB6ZwljtQh42EqhE2dLVXgTDHia6+11Aarh7UgXK+I3te2yPefS7HhTBFVAbKl/fHsChygG9zdskRKWuJfbleU0rqUMIX7F8wZpXzPbUKbeYmOiFqVi8wY3GTTsTeUJeLSmZzIjTHP8ZzCCacNdycQAf0KkzMJEiSRwxPItzNGWW/IUlXc8iqhNaVbMngFPf7Du5aqe2Lup1MmiyZ2ASL1vB5cbcVTrcRcBaEmj8+n2nBRyjNU6cSI4K938MCeZSm5IuwF62/zr6XO97wDjWyImZtLSWoDgdSuhIqNzaI4pDM8v9ncTOZzSSzdaFGkmhcxQFxeHeJjJ8d2OzyfDhluyGyBh9wpUDidmrx13vtzaavwTelIKzgdIqK4oAyC1qSYMXwlJA/lUh+/WVcvXT1yFgRj3+dlauXrzyzMZOnsn1sEooFSNKxbV7wqBt+j/Z4/f7zlqE/ms3nv/ak23Xi5/g6owF6NUxMIgOOcxkyYVFG8gCt9Jp0ijzmnlsHc1QIzpuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 03:59:37PM +0800, Baolin Wang wrote:
> 
> 
> On 9/8/26 8:50 PM, Kiryl Shutsemau wrote:
> > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> > 
> > wait_for_scan() gives every case the same three seconds, whatever the huge
> > page costs to build.  collapse_full() asks for four of them: 8M at a 2M
> > PMD, but 2G at a 512M PMD -- arm64 with 64K base pages.  Three seconds is
> > thin at that size, and the case has reported a failure for a collapse that
> > was still going.
> > 
> > The timeout is a ceiling on a poll loop, not a sleep: the loop stops as
> > soon as ops->check_huge() sees the collapse, or as soon as full_scans has
> > advanced by two.  Raising it costs a passing case nothing.  Across 80 runs
> > of collapse_full() on arm64 with 64K pages the wait was half a second in
> > 73 of them, with a tail to two seconds.
> > 
> > Keep three seconds as the floor and add a second per 128M collapsed.  A 2M
> > PMD is unchanged, so x86-64 is too; a 512M PMD gets 19 seconds.
> > 
> > On arm64 with 64K pages a passing ./khugepaged all:anon takes 49 seconds
> > under TCG before and after this change.
> > 
> > Assisted-by: LLM
> > Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> > Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> > ---
> >   tools/testing/selftests/mm/khugepaged.c | 7 +++++--
> >   1 file changed, 5 insertions(+), 2 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> > index 1ca7c6978571..48e0040d53b4 100644
> > --- a/tools/testing/selftests/mm/khugepaged.c
> > +++ b/tools/testing/selftests/mm/khugepaged.c
> > @@ -556,8 +556,11 @@ static bool wait_for_scan(const char *msg, char *p, size_t len,
> >   		int nr_hpages, int collap_order, struct mem_ops *ops)
> >   {
> >   	unsigned long hpage_size = page_size << collap_order;
> > -	int full_scans;
> > -	int timeout = 6; /* 3 seconds */
> > +	unsigned long bytes = (unsigned long)nr_hpages * hpage_size;
> 
> We already pass in the 'len' parameter, and its size is also 'nr_hpages *
> hpage_size", so you can drop the 'bytes' variable. With that,

They are the same for the PMD contexts, but not for mthp_khugepaged:
mthp_khugepaged_collapse() passes len = hpage_pmd_size, the range scanned,
while nr_hpages is the number of folios asked for.  collapse_single_mthp()
asks for one order-N folio in a whole PMD.

That matters on arm64 with 64K pages, where the PMD is 512M: with len the
single-mTHP case would wait up to 7 seconds for one folio, with
nr_hpages * hpage_size it gets the 3 second floor.  The budget should
follow what gets built, not what gets scanned, so I would keep it.

Does the Reviewed-by stand with that?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

