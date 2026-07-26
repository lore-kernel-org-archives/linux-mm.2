Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4282DC531D0
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 02:07:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AED96B007B; Sat, 25 Jul 2026 22:07:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1605E6B0088; Sat, 25 Jul 2026 22:07:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 075AB6B008A; Sat, 25 Jul 2026 22:07:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA3076B007B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 22:07:25 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4D01C1401BA
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 02:07:25 +0000 (UTC)
X-FDA: 85029290850.20.3FCE883
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 26006100009
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 02:07:23 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rqpHEHE3;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785031643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jpS1B8a886qs16d5r0p1aEXd05mNAw05WBa0cxlnrRo=;
	b=r98Zt0G5qtS4BAPiNwwN/6NGbsvYRODsqU8sT/1KaF1+sKdJbooJZd2sptk0rdARK63jnp
	3wWEJbGb0CdQ7CaeaaB6c9p8xK4YReIPKWN+ufCpSvwJp8hDxkEHDtI6CaMTjjP/QoQq5Z
	WC1MC+h+6oKMoipD5gAUbYoQvb7FZcY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rqpHEHE3;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785031643;
	b=BUima8dj9TxdctOwKIBmc75vVKqilO8CX15HGLEJYvaxA5F4vdkb9sncQ5Y8LO+7MemT1A
	u4tT5/MRhKCpX0iWhxIQlvG8ICGvJSMBPyzmWjhxx96cQcAlwxWvHM3cLMlfSMtKGPV+5V
	GZ5HBK39ouxoM7P5EIy2VEB9UFaMqMw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6BE9960008;
	Sun, 26 Jul 2026 02:07:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 954091F000E9;
	Sun, 26 Jul 2026 02:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785031642;
	bh=jpS1B8a886qs16d5r0p1aEXd05mNAw05WBa0cxlnrRo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=rqpHEHE3dWIiDp9qwv4GP3PS/PvMosPq/5u+hq8fGt9a2Rea8tbzjficfSCq+jv23
	 SMXifRgp8SBonUPe5DDBWrkNrYQq5g46XjM3pmyFbcAEfzMYUbMCm7Asc2pJymXbOf
	 38vNQGtr38lbJNCNEvhAZAKE4BtMlFXXsqutO8Z8=
Date: Sat, 25 Jul 2026 19:07:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dev Jain <dev.jain@arm.com>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, david@kernel.org,
 muchun.song@linux.dev, osalvador@suse.de, riel@surriel.com,
 liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 ryan.roberts@arm.com, anshuman.khandual@arm.com
Subject: Re: [PATCH v3 1/5] mm/rmap: convert page -> folio for hwpoison
 checks
Message-Id: <20260725190721.f2e121f118ef817e42bb3874@linux-foundation.org>
In-Reply-To: <8d2f756a-12a2-43bb-8849-3e71c1ce5d8f@arm.com>
References: <20260713050050.1017741-1-dev.jain@arm.com>
	<20260713050050.1017741-2-dev.jain@arm.com>
	<amMtRejoVMX2IV2V@lucifer>
	<8d2f756a-12a2-43bb-8849-3e71c1ce5d8f@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 26006100009
X-Rspam-User: 
X-Stat-Signature: q9cfwwqdhu5ofi4ctuodsjhi85ms4hjm
X-Rspamd-Server: rspam04
X-HE-Tag: 1785031643-966934
X-HE-Meta: U2FsdGVkX19OC5darW4FTelDTJGlgO3KPRZjiC8rgxX6Wou2TzDoZk9LOdwIT9C7sHewYecJ865oc7P8EcgieZGfe52iA9dC4rYEMhft3XZJmo1shM4fZW7+K62jqq881ODlvQ/Kre2pqFfDa3BJCjumoUkqhf17JSYh9sFFHmOHScwjpTESrkI1fzkWgi4KeyGfDM9kxkYhKANXzLpBrd7TvjwMTLyAKGG0OPPOIg8kclBQoufgxYvuLzAumKn0uWyXq1WjPPSMH3DFehxAIAHrWqL278IcTnjnavC7esD9rYBpcgCEYUbzwjYU63SseO/WZ0a+LZscqDLRzSlaK7EXefNM/ZHA8B3P/1cxDnTvLnpZ5fho2BYSNbR76AxqUUDnrcC6RKZVAMLggVhsasx7DcFkw5C6jsbTHY5ns/CkfZh19PTBlLYvKkk/xHv8l5ew08zwVEWS9EppOGCSlK6fzrI+Gw2YwbZINMavk5AvhzNA+C4FOVbX2JlAfRXFFe6A9weipxMmXZdbPH9sdLSUYHIHZ83qLSqjVXmrhQnf28eZlDcp6KGglZ0lz6YQsdon/anF3VjLMtq0QQs4hAy8XNToIaw35UHHCZlnFCisRiGC5DuONwcJazjYEb3t7mWTGtYeRJOx+m5t0JI6TiwX3FhIC3iP8GoXTxpgOIlP4v0sDJxk7L9ku9X1YzPvSe1RFDNIzEypkMILW028SFIdlZe+ZTitwFf8ZkTEfxRMG5f0EtLZJlr/03zDR/Ig5dmMm03/Mj9RAS6o6jATc8D5E+XPNC91FrtvlCAOQH2ifMie+Ob1yCkbV3yF5nJTsrK/gdVoM3V9GF23vL2Ux6Dti/1/XqUsXC8L3qUtPg6eqg6WHG9yj+h8R2eeK/Q6+eC1fcQKLKWBD3AP5tIn5A9SJbmn1HwDlJdjxNTN7CzYJ7RpnY8EUFgz1VgVyvzGPCINXFxPVeKgnbRH2EA
 2NIeyto4
 Tl9iB+EY6l47w73Ri4tgK74TqcAhDQRY42IXur4RhkXZnrComiRQXMw0tfvUl+1UqVgM+LPZaUhyhmO//bn3HH4lQiFgkUY09o+DGw3r2ZPpxuofJmt6W/SA1PK9hQi+dO5JPNDW9/th1dw5B5ScRhpHk+HW38l/ViN7i5089gUtrhH66ifL+VkvssTw3O4+CPqUTtoc+lHpM9wQU901WJuAahKfYitzVy6ja6kSZgw79sbo2gWBEvFnVXHDTIbirIFb4SotUQBAlAIGZ5GPN4+tlHkMuEZejy0+EP4rzOuW1Lon11GKCouAaxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 25 Jul 2026 13:06:25 +0530 Dev Jain <dev.jain@arm.com> wrote:

> >> @@ -2204,7 +2205,11 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
> >>  		/* Update high watermark before we lower rss */
> >>  		update_hiwater_rss(mm);
> >>
> >> -		if (PageHWPoison(subpage) && (flags & TTU_HWPOISON)) {
> >> +		/*
> >> +		 * With TTU_HWPOISON, we only expect small folios or hugetlb
> >> +		 * folios here for now.
> >> +		 */
> >> +		if (folio_test_hwpoison(folio) && (flags & TTU_HWPOISON)) {
> > 
> > As per v2 discussion, I feel this could be tightened up, maybe something like:
> > 
> > 		/* unmap_poisoned_folio() only refs order-0 or hugetlb folios */
> > 
> 
> I can do this. But note that this series is in mm-unstable already - what should
> I base the v4 on?

Ordinarily basing on latest Linus works.  But this patchset has ~450
patches ahead of it and a quick trial merge wasn't promising.

I could drop the v3 series so you can base on next mm-new, please lmk.

Or

mm> git log --oneline | grep "mm/rmap: convert page -> folio for hwpoison checks"
bb2f8a7eb126 mm/rmap: convert page -> folio for hwpoison checks
mm> git checkout bb2f8a7eb126^

