Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B814CC43602
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:41:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BEE36B010B; Thu,  2 Jul 2026 20:41:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 096FD6B010D; Thu,  2 Jul 2026 20:41:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECA326B010E; Thu,  2 Jul 2026 20:41:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BCF926B010B
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:41:19 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8EA911C2F63
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 23:24:24 +0000 (UTC)
X-FDA: 84945417648.05.47FD625
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 60ACC180003
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 23:24:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vXlGOuxj;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783034662;
	b=RukVz+HtxEU20pJbv2usXlT25E6x3d2RHLN/bxmHqPb+DEY8c2jlT0T/selXDe7xjcIT4j
	LYw/VDuXp2HCnWrNWz2eVQDPJYHPzXDxtnqowsv7vn6HxCr3zkWo/KtA7A3c42ckR4/h67
	bNNDu786SFHU+pGrqEGQFDlOk8gsnw4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783034662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9nAR8YU/o7p8fJF07xiO/e+rL8kilUhTDLlZLPJMmsc=;
	b=m+m6QJ598GKZ4jLRQVWepOXtoeFxEdVsxqITnlZB3qP7v/FLSG3PN6XOhNPQqWRnDybb9f
	Txwxr5xBCODwnuupySJ+4eCH0+OMnnUc19qQnuhX8+eXhktWsp6H98AO60+8VKDTHXcXo8
	wrNy/M6StP4JkSMvPes/9C1bjizHyZA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vXlGOuxj;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B8A576001A;
	Thu,  2 Jul 2026 23:24:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25FC41F000E9;
	Thu,  2 Jul 2026 23:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783034656;
	bh=9nAR8YU/o7p8fJF07xiO/e+rL8kilUhTDLlZLPJMmsc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=vXlGOuxjAvqEmI64WduaeIZ77NBbEBBdhXc6AY30OAe0HySgDgikjryaQMk2M1Tva
	 +1Ciw/6Wx0wuT84veROJHv6eF1uBMva33ce93pR7IlQUFIP2bpgtuSk/YxrY5C+SoS
	 X5ntIropOkKNGm+LFWRO3iCOEiOIWzMVZKBBZmhY=
Date: Thu, 2 Jul 2026 16:24:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sourav Panda <souravpanda@google.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
 surenb@google.com, fvdl@google.com, gthelen@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/hugetlb: Fix null pointer dereference of nodemask in
 hugetlb_cma_alloc_frozen_folio
Message-Id: <20260702162415.142571f4d8c43aa4b95b9f7c@linux-foundation.org>
In-Reply-To: <20260702215713.627941-1-souravpanda@google.com>
References: <20260702215713.627941-1-souravpanda@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 60ACC180003
X-Stat-Signature: z5gbw9iipuqcd74519hdufuyi8fhqpe5
X-HE-Tag: 1783034662-284165
X-HE-Meta: U2FsdGVkX18wIaYZ+AjK54kjD1DZ0W9eMXOGsdEQEYE2fU/KoPXAxHdRnEN+MjRuKsE2Lbml9y1qyK5hyNMreoO6oorD9cEm1vRA94JgK6EELqyPo4R9fGm5mPOTFlGVLPDAJLjxp8r/r/MmC54IZb/DFutNHpD/7cpu1Kdo2jOwH/PEjSk7jQyfTNpB4GarGfgeEyZ8dbgivH/FtaU//0/4JSSAwkEUznzawrsMul3CIc2rPPgchYUj0PJEN/HyOA8AezCwmf2Dza4ofZQ/7m571VhiWGOLWxi0Di5oGn5RbCcjHR06XGWaYrE/TF5HwoHN2hwwb7Vi5DUtP6dlqkNZkRyUaqU6YcLa8pTN1yyc61IDOy5kjm3TRqm9Pi6V7H8EMlx6NYiOGa09iQt1BOU0DInlKNL6P3O7JOAWYlGCunisQBQMBoLdE6LXSrPkvijo6FpU2zztjXJnMtB8lorYZ7mx5lX5CjGr/NAC2MtRl6cONKAqzub9c6ikhMntU7Bqi5vFLGB2X3LJ28PfZEgqM1PrUxob9j+e63M/oqkTz1tXahdPb7RQjmjrzl8xb8jMSEUUEmbay0ZOU91xFq+d22rilrc6h3ORtPNNwSJuMXcq37Sb6VxGxmapttf1F27gQTX0v6u82equ7R9NXc77vtRiQtktW+WEA2tKZhMiFUTWbP7S74sq6UrLoGkheltmCp1OwZX/mQBa5plzC65kNkJVdKEeOXziyjGVDTYCwseFsqiSAHEc68X443St7oXr9vVZOaITY95dEAGybJ1RpHwc4WlANao2C5JpLJ/i6baw76q3BDH7BXT0Q4IQstfI5fRGrZeiHYmrHNsdJwzSUAEMyP3WbH0SyZZojrkABd6NDUaJEmS1nnN4inEI09lAkRlStz2lHr9fkFMhElVYnxUuDghpoqjt5MiqR9jH3fYLyxK/4rrBYwecKizPjhmWFVu78GCz2rMIvJ8
 wUk0paKZ
 eHnq/CXADjD2BNxVZ0GUfp/BzXQ0gtFja0k+HDnSOFGKpwzs4kGqqPQGmtDsLI0YqfbAhsmoksvCybNO9MMtcSeLs5x8FACDvm61QF1XaGIAnBv1OzvoyEZWD3PbEf2LH5fMUbSo5eWgDqG95k3phZ0EbPsrwgaWfRVxLGXbQDe6o9Gk2C8FXOsU5uczYhe3ZteCKXFNBD2DNyNgswvu8F1MzTSfEklDRs/4nMol2EkhhVyTbTSQGwQHG1SyqEtV3ghpXmeWdmE9Q9K+n0ouIbJHfRr6KwA+qIsaFJD6NOXCNU9DRba0vcv5ujcWZCnGzpApXTUvgX6fRc3cdRTio3zFlYcKyW88Yd6PEO31V97CcoblspPbiyLNMnWCDrJiT7KIkIsylRYUjgmA7R7SpOGq1/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  2 Jul 2026 21:57:13 +0000 Sourav Panda <souravpanda@google.com> wrote:

> alloc_buddy_hugetlb_folio_with_mpol() can pass a NULL nodemask to
> hugetlb_cma_alloc_frozen_folio() as a fallback to allocate from all
> nodes. In this case, hugetlb_cma_alloc_frozen_folio() blindly
> dereferences it in for_each_node_mask(), leading to a null pointer
> dereference.
> 

oh.

> Fix this by checking if nodemask is NULL and defaulting to
> node_states[N_MEMORY] if it is.
> 
> --- a/mm/hugetlb_cma.c
> +++ b/mm/hugetlb_cma.c
> @@ -34,6 +34,9 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
>  	if (!hugetlb_cma_size)
>  		return NULL;
>  
> +	if (!nodemask)
> +		nodemask = &node_states[N_MEMORY];
> +
>  	if (hugetlb_cma[nid])
>  		page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);

It is possible to hit this with any known testcase?

If not, why not.  I smell the smell of dead code somewhere?


Sashiko said things:
	https://sashiko.dev/#/patchset/20260702215713.627941-1-souravpanda@google.com


Ackerly's "mm: hugetlb: move mpol interpretation out of
alloc_buddy_hugetlb_folio_with_mpol()" made big changes to
alloc_buddy_hugetlb_folio_with_mpol():
https://lore.kernel.org/20260702-hugetlb-open-up-v4-2-d53cefcccf34@google.com.

If this bug is real then it would be better to stage your fix ahead of
Ackerly's series.  Possibly with a cc:stable.  Then I can redo
Ackerly's patch on top and we'll need to check that this bug isn't
reintroduced.


