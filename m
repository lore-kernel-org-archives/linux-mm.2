Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE852C55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 10:51:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7113D6B0088; Wed,  5 Aug 2026 06:51:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E9646B008A; Wed,  5 Aug 2026 06:51:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 601356B0092; Wed,  5 Aug 2026 06:51:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3855B6B0088
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:51:26 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B9BC61A044B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 10:51:25 +0000 (UTC)
X-FDA: 85066899330.29.CFC95BB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 253B31A0007
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 10:51:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AGvE0Z3F;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785927084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bUFwz/ewG/apjoTiXimLH+ohEsgmfcNVTOd8zCNhE8o=;
	b=AfuQdcqSx/xgT2btd3gut14bFNg+uHgyphTbUPpTVXUgaqW/KFWrSTVG+UD0sg1itbiRHM
	fNdlJlnIe6J7Et74WXe5hC/Q71L0EUxPELq46j0LT4lzGu53ep4lQxuvN1GYN1IIPxYChZ
	8PiQjzykvPJp3InypjjTnsE9J71a5k8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AGvE0Z3F;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785927084;
	b=KGBLXwg0ng106uhi65nz7fpD42NOnaO3PB3vW/tOsU8m0x29j4uQD1BKf1oTSYtSQIqN1D
	VjMtUdBEecDWkTAarRlvjgNc0C3saRF9OV/v+k81SxpR3H6Vg+7OeOteCwZ7kT4otK56WJ
	AmDEkQqjMTuHhbx+NBqJi/IiLUHfTEE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9D6FE600AE;
	Wed,  5 Aug 2026 10:51:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C15161F000E9;
	Wed,  5 Aug 2026 10:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785927083;
	bh=bUFwz/ewG/apjoTiXimLH+ohEsgmfcNVTOd8zCNhE8o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AGvE0Z3FGYlXgvIUQ+NHf4C92EZPSHQDYUXRlsM+OtJ/bZLTbI2iOlQnd7lXv6NPt
	 plkX2z5V3jDxbZ+sk2bIYNssEwXSJErMX0fhkaNWDnGVjYLGevciyG9UqPLU2PhNlQ
	 SCp1QRzhfAwIu8dty7X+C7OFX8AvqizSZehvPH9wpcXozEDfbZMQX1uvPtoe+N/OBD
	 zfgtg+c4lxSlB+EA6MJaiwmXhAPaoXuzMs90ObsjHBpgCdHCoOwfz2N0Qb4SvtPMtx
	 Cs/74ajSwwpJXcfZydNkkhBhgV9UyRGGmVltLSZzOeS+FXiBCDzHBTV9tskpbJWMsq
	 71sbt4cfWwfOg==
Date: Wed, 5 Aug 2026 11:51:06 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: dayou5941@163.com, akpm@linux-foundation.org, ziy@nvidia.com, 
	linux-mm@kvack.org, liyouhong <liyouhong@kylinos.cn>, 
	Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/memory-failure: fix concurrent access issue in
 min_order_for_split()
Message-ID: <anMVgTWREJJ5IeRU@lucifer>
References: <20260805072625.2437636-1-dayou5941@163.com>
 <dbdb0f70-669b-4c68-a9cf-89d30c20f12f@kernel.org>
 <anL_I_2o3vfAaRLr@lucifer>
 <aaa9503a-348d-451a-b44f-9221517803c3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaa9503a-348d-451a-b44f-9221517803c3@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 253B31A0007
X-Stat-Signature: su181bswo1ppxip5dx5mkce9ofwd63wn
X-HE-Tag: 1785927083-962140
X-HE-Meta: U2FsdGVkX18IDUmxGV+Qh3NcAL22yTJLqAp4BSbikFcU0x5L+GGLIHYrSa5QhhRPpg7bD16e0mAwYf1e3irkwhG6KVmLPhd/4vz1kQ6KjwVfM5WMpF/L89knhp9mGcFt2GgXnnsZGb7poAzdTyzaFIdEf9YraFlkP8bJgOxY7eRgB9TO1IsyVw2Mhdv3fQVrHFFGF8o6JExvKPd7DZAEfhynFChqS8FQI1rTn2usaFZ3otdVYD7KnofDbWzHWcYYfD51ApvLQSjx9F3P+HiOcLtOtsJZ8XnbFLwQegcdvl0t4SjtrZCbcyC+d4Huoxq9yqLo8sveikGPWa450g7wU91IpK3zuO0yb3gxVSIAzzad24J9YSxrlywdDHZlC43wb1OFseif7LmYZX+MP5JDZ9tDmJN5jn5oq+Nfl7dvCJLnuUOfkaGD+7udhrY62kgEof1TVdUBoa/RW9jHRXKKHc03vOGo7esNz0rfhoaCDUTmD5jN5++gYnXLVh3aSrYQDhJdej5l7+sg0y4lHkcC4vZXkXBiEYyODksPqp+WFnNtm0GUuvz6OebGrDz0huVAFKi+Cpqn6bab9qSX9SOT9HhmQPVDja4ZykR+zwsEjb071JMIZFO51tNwpg60Phefnf3Mn/BuMR/l8dG32LzT2rjxxBcx2LnUAs/wg1c+EdoyfBjkYdeMi4hX5pACe+0wuiNaDbBJaPGp2y7DehPCqKjAKsON8UakuOI7Zd4fxOMukKuvPmOZ6+Fh20HHZmyxTPW5Srl9MeR0oqgOxFzNRmYYoMmHNM2Ed/bmZWF5Ku1QRNMR2j9OInQgu8003idG73m9/oFPcTWLz6RF9Clle/QIr/e5FK4xU1R4stVM4/WvGUqgIWPetzHEsO38xDGde8BQYSMWAL0bU/AxsqHcZBC1RGeAN4AXJiqdraBhB3tAwBj0giuXu7vxl5CHJ9ohM3VyuO8OKJsKTjyM7W5
 nSpoLMJl
 uwNrTJCzCKvEfi76oNAm5HkqnY47bqSpKPBp3qK9FjiJ0cYlz7+rECHBmzCLeBxAnoGlH9iM8UMJjgUHaIWkVXuA7GJSv8BJbTC5fbc/LFwPOEffTJL2ffp4WirtK3HxvqygRUm5r9dQS/miBxt8pg/lXDaoKgINfR5X+/Vlzx1SYJGDCp3k2gDxgNb0wW/2zDHab4YJU6sEM24/pXxpKLoYdSNUaAS06zAfstfXZCQFVQ/hWLQB6lPhP7cnA7ETtNqfiEhoZR0A0nWG2BWyUba2rTxrRPnCNeLxkARpv+N9I5Z0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 05, 2026 at 12:03:24PM +0200, David Hildenbrand (Arm) wrote:
> >>  	/*
> >> @@ -2862,8 +2841,7 @@ static int soft_offline_in_use_page(struct page *page)
> >>  	};
> >>
> >>  	if (!huge && folio_test_large(folio)) {
> >> -		const int new_order = min_order_for_split(folio);
> >> -
> >> +		lock_page(page);
> >>  		/*
> >>  		 * If new_order (target split order) is not 0, do not split the
> >>  		 * folio at all to retain the still accessible large folio.
> >> @@ -2871,8 +2849,14 @@ static int soft_offline_in_use_page(struct page *page)
> >>  		 * preferred, split it to non-zero new_order like it is done in
> >>  		 * memory_failure().
> >>  		 */
> >> -		if (new_order || try_to_split_thp_page(page, /* new_order= */ 0,
> >> -						       /* release= */ true)) {
> >> +		if (!min_order_for_split(folio))
> >> +			ret = split_huge_page_to_order(page, 0);
> >> +		else
> >> +			ret = -EBUSY;
> >> +		unlock_page(page);
> >> +
> >> +		if (ret) {
> >> +			put_page(page);
> >>  			pr_info("%#lx: thp split failed\n", pfn);
> >>  			return -EBUSY;
> >
> > Maybe return ret here? Seems a bit pointless to set ret, gate on it then not
> > return it (even if result is the same)
>
> I didn't check whether a caller actually relies on -EBUSY. So I decided to leave
> the behavior unchanged.

yeah it'd still return -EBUSY it's just a code neatness thing, otherwise setting
ret = -EBUSY is kinda pointless above :)

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

