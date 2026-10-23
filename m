Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A527606A31F
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 12:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=a84UeIwZ
Received: by kanga.kvack.org (Postfix)
	id 313D06B0B55; Fri, 23 Oct 2026 08:29:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C4126B0B56; Fri, 23 Oct 2026 08:29:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B5356B0B57; Fri, 23 Oct 2026 08:29:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F1D726B0B55
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 08:29:45 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7B4A8A7F60
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 12:29:45 +0000 (UTC)
X-FDA: 85353822330.14.897C496
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 718221C0006
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 12:29:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=a84UeIwZ;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792758583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NEJcOMfTiJZVdmiCS77heh1ShFCABv10BI4A16ZfUbc=;
	b=FWqA8ijaPzpBmnJeHEAg8iz/xwIdrI9ZTxxvV1lyhIZc2Qk5y8s6Rkau26kCL4JucSFhjd
	J97kZnEfaXeno2407Zzc8iMgD8gNK2+JAe1N5LqQWizQB67RdVfAjjew8l9bIIKagXTR2J
	ucwONcipgEJauu4uxlkGvc6xRxHWgwI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=a84UeIwZ;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792758583;
	b=AXiQ0RiHQqll+7uWOub/QBwU8L//7MCuphXpHtzCbD9MWULW1gLHM4nPfbarAoyTVhoSvF
	6JBmznHlyFY4zQqTLeEhppB7LdvmCM5fd8W3Tae3u7S838tmryKCIRKZpXHeYPz88b//MF
	gUpWsxnkaIGofN4palrnqT3qWznfGnk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4A4D51691;
	Fri, 23 Oct 2026 05:29:39 -0700 (PDT)
Received: from [10.163.161.88] (unknown [10.163.161.88])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 615793F7B4;
	Fri, 23 Oct 2026 05:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792758582; bh=glJJVuo7Jj0MPAIZEvy9G1wvvfwWvftfy6C/cnUNinU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=a84UeIwZiIEVxWvYmNK0k70X7sNaNvauZhafz5lN4xqtSdld7fh9Dn9aFFPi9hJ6k
	 vGcUsRNb6PgNCeNwEba6mzynHqhYbA5GwrZbP1D2NDiRewCTjIHyrLlDViZw9G+dZx
	 rWJ30/TratmPns+yAiKKVntmoHETZFB7sWsquD74=
Message-ID: <3c8d974f-55ff-455a-8676-d1ee823166e4@arm.com>
Date: Fri, 23 Oct 2026 17:59:36 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: remove unneeded forward declaration of
 __free_pages_ok()
To: Zenghui Yu <zenghui.yu@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
 mhocko@suse.com, brendan.jackman@linux.dev, hannes@cmpxchg.org,
 ziy@nvidia.com
References: <20261022124504.75642-1-zenghui.yu@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20261022124504.75642-1-zenghui.yu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 718221C0006
X-Stat-Signature: n93tfhw7dhjsh9dcjqub97d1hrtgp1u5
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792758583-943042
X-HE-Meta: U2FsdGVkX19VTOfI/DSPVIDe+wYCwR3dCta8S73RCUXXc3/4HQFejgZtTBolrCrFJhzcTmfEHnLYrNXbD98Qt/kfEMN5Ble179sF27c+OIyV2INoBimXNyPmK0C21ptWlIvgWub+aiQaAQe+AdehUZWLXMIN2wj3rRVIX0C3Z0XQymuRfoeef9yArJOmXnumKvvuEcx779d/ODyqMTQekORVQi+3y18NPJ/ZifqKWU/R9m1l7zyi+rT3h0rYiDRJ6lmKXMMRb7nbgC96rZhcwObAeno3ly16wUKrqGS3Fl+tpIwBMVQn0iYjqq+IEaktm+DIpRzzdOCcYcT+JSAJMxCCfKk0fBTLPVgSsJtCZck5fN4vLf6XsxYwSHlXVquHrGYotjrCGR2zIgwj/mh38M9GSeM8DwjwjzCtlSCEkJs43Hw0rRYjSNzqhaExiyaXer9B03+0nU8FGBUewTyRuWgJgJmczS6y1zGAPKHHPLFd3fM23YJw6d2NXLI8qI7r7dZak1Vd71HcQB55oHyhtoTJAhU+UIpGvkQKYkmq05hMsL1Nor50H6EqD//LTAuvrTeJ3MOPIhUPVAmIshY0kofC5UOcYt3NM0XkaewghOfBDjYzs4CECbp8mnsvwg6vl2NOU/bhNQLqlxFMptliSBLmWPOZ/cTnGG9Md2UNzLB69KelrduJJKZIPhyhpLhNp7hHTUHQvyV1JpOXyfvN7a8a1J/cdIToCAGg/Q2Nf+Cx+IoD38NeWsQ8b/TbpsNPBZETrgoL3vwKiTo5DwArcykWh8YRkpVlxZxwk53g195eqkvP2QuPq3q+lbOZJxAOpX+GLKv/eMA20/pC/DZaUigM+6bBz2MWaXr/NbLWLnCiUsP2ayUgXSRnU7dI/Vq449ZN7X8mLadxPLRRbKNVyVDjNWZ9wrY1vpFCXw+wcYqT8vtZcKtz+8YzbsG/hjJNdvvsGtm0w3hNNzMtBnC
 YMPkKrk4
 oYSm6ZTC5hGiEbLJg6Sw/QftQhriAOanzr6JRx3Rw8fEpI8llxqkALhhuGg8WlWpvgU9dTDwBZ2SCDD8aVv9r72lmMnEhlhToaTIJJY3zhahJMpXi6HNvn7u3qR/eCth5G7GZa6lJU7XMa7aKdeL97cxRIfRsf0Xyh2gB+nX8+topvGCvEW9s6YeAx7c5SaKQ+Z6LYMz7LmmPoD7aOSC3vkDzkQuc1eJfZSSPwfZlbgjZRKHVvSMzo+ecoEeCMr/pdSzwOboD7LcdXqg/bZT0PzLxncGpIn5oYdHzapSm9lerYjh2AbgRMmGWZ6hrxOvD/oJo3zAfv3xpMBlW9ieMad0TtQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 22/10/26 6:15 pm, Zenghui Yu wrote:
> From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
> 
> All remaining callers of __free_pages_ok() appear after its definition, so
> the forward declaration near the top of mm/page_alloc.c is no longer
> needed.  Remove it.
> 
> Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
> ---

Reviewed-by: Dev Jain <dev.jain@arm.com>


>  mm/page_alloc.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 0396c50b96f0..6db90e0aa929 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -216,8 +216,6 @@ gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
>  unsigned int pageblock_order __read_mostly;
>  #endif
>  
> -static void __free_pages_ok(struct page *page, unsigned int order,
> -			    fpi_t fpi_flags);
>  static void reserve_highatomic_pageblock(struct page *page, int order,
>  					 struct zone *zone);
>  


