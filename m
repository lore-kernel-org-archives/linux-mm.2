Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02C4EC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 06:33:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B61AB6B009D; Tue,  7 Jul 2026 02:33:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B12D96B009E; Tue,  7 Jul 2026 02:33:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A28066B009F; Tue,  7 Jul 2026 02:33:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7DE4C6B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:33:36 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DA120A0308
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:33:35 +0000 (UTC)
X-FDA: 84961014390.04.024FC12
Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	by imf16.hostedemail.com (Postfix) with ESMTP id AE97D180003
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:33:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=ididrPHL;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf16.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783406014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VlXNw2eBmsyA44qk9Kj+8iT7ILOluejS36YD0QBD00c=;
	b=EFCms8CWkEIprbPrfeeY8jpv3WbvpKrXIcaKx8SukKcA+ZSoD6MgZJ6S6NUOzW1dXjkzwW
	iaHom47ryH81aSJq6qeLC4qJlJu7hr84sWnGeotag1HIetGnQCMlkRjfO7Wfi0dDmWACG+
	ILNC6B1MS664YNjCtLzZnn5pNmsPuQs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=ididrPHL;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf16.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783406014;
	b=0C9JBhttg2BkLruNDqlqIiK2QZyQZEGEWKxZKdhuf6loMir8M407i3pd55W5jkZfcHzIF2
	oLgB5APoK282KT2U7Wy1hCzu4/LhZibdx/PMmkSvy/FAATdlo6VZIhDlit0urJ+kYDs9FQ
	EovPKt1NtqyR4xU5OUFhKCKFcKTtbLI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1783406008; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=VlXNw2eBmsyA44qk9Kj+8iT7ILOluejS36YD0QBD00c=;
 b=ididrPHLfWDNNw0dAG1lSDQtTTT8WN/9ysUqOLgeS+2bf5x865xRpy7O0mfvl1wvLSQLqg
 w1i6mbVlmQnTattfJiGcMxUMCKe+nzB6uBIdQKPEbA5srpcLyAEQtD6eFHUKFEbHeXZKUV
 7u3LmUdIM3ElD9mGDI1IbJyHgMEjaT9Z9zwIUGG4SVlX8mlvTO0YwXGO3KvHTOVkgWJS8S
 9Y0Y4Xmk6i4mWZ9/+1gGrGR+HMbSNEMOkltUXGbHjZK3T5nk8+ob5Pr6fMTrUb/aOxgMhK
 68YpUqjD4SVo8tCguJha3bFfHlzpzr/FsLmcJX9L+NE4hvZeJNje7hb+NWN0kA==
To: <apopple@nvidia.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
X-Lms-Return-Path: <lba+26a4c9db6+944675+kvack.org+lizhe.67@bytedance.com>
Mime-Version: 1.0
In-Reply-To: <akxpS3WOP7oUBNKF@nvdebian.thelocal>
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v5 4/8] mm: add a template-based fast path for zone-device page init
Date: Tue,  7 Jul 2026 14:33:03 +0800
Message-Id: <20260707063303.40128-1-lizhe.67@bytedance.com>
References: <akxpS3WOP7oUBNKF@nvdebian.thelocal>
Cc: <akpm@linux-foundation.org>, <arnd@arndb.de>, <bp@alien8.de>, 
	<dave.hansen@linux.intel.com>, <david@kernel.org>, <kees@kernel.org>, 
	<linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>, <mingo@redhat.com>, <rppt@kernel.org>, 
	<tglx@kernel.org>, <x86@kernel.org>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Queue-Id: AE97D180003
X-Stat-Signature: 1axw69bz3ffk7r6y9bmix84fnan3bxox
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783406013-297838
X-HE-Meta: U2FsdGVkX190G3J0E4IWW2eYNyfXVI35EBiBpcQyjqWeyPi00A3UTN3wyS7M010YPfZh9o1CHxwGok01+fXqwF57RbNHO0uY6o97/kLTnd68ZcFR7jCmLuvO44o2CQKEPEiYRU3/A831zDo1j6rXD1pYA+dXlEivfLilI1bshuxSZPgYOzaJEoFMpu6gQIvAP0EhVbEc0/cBOMer9Ln5x0qw5Na5+OxWcvv61+Ic5/LgXrHgd5UiAhUtfUZDTeM0A/Zu9R5vwcSy13oDuYzzKcCgKII+JQB42C1u0dipmiw1Y9XpOXikWgmnHoGgNcmG/RoALh2V+EG6AOpEJvVAQlEOgS5/004rbnpMc6ybFi+57UTiR+epz5wXXBTbjlm7/1aisr972rrlMAXHmsNlqnHW61I1gZc8QpSp8RcCyt5o9RFDj+7eyah8VhFvorQA+fGcybHrTE8Nv6R/j9PKCIpa6Tjb7B8XungwUIiIWB79SCzA+Tp/gKXI36BsRwr6sJW0LUDz6l/WjNI7rVJgm8ZuJZoO1mM1Qzor94esQGTbBI0qyQPxySyybdBFLLFKKtYy0rtx3tGr7x6bv78d5//WR1M7uBMwqyW/SZUT5p19VTeWEV7nDBayDtMuXbcHgcbUYcCjjF88paPS3L6cD0rtxV0OIAM4is209VT59s0Zt1PsTRI9Qd46DN3F2qJtuE8OqDIXrK2qXekVRYD36dLktIpW3Ha5bWNqpOb3weMTmFwT0OzzqCa3cexZ7J5/bxzZ2y195d93ZGKgVU1Gijf4aMh+xrhpYpJBgl0XmzqeXw8njai0tyWbp6QmLJU0bzO5OUpZsG1Ab36DWp7lIA30JGXZKVTjGUT0kwRgUY/kplwOq/j/vQheDkcz6VJ2IV2ZTaAPrtfrxP27Twc5/uwagVdEKaMvY7rBfu2NmedoxhnfsRRNO5bs2DzLSlYfOc3nqNn/Arnw9wZ4nc7
 JV+Gf22i
 Pk7CJ7Wty6kt9vJrCZdL4OD1+bdoo4JfLppUT2XyHyEUNb/ccGwk3fSCUt8IseRQbYPqfHhPNsMsohup3CZKWG0QBg6AYxGhZdb0gZ/+2UrNIT+IQd05MH7NhvkG171DLtXvo0QPnRNY9DTQWrwlsKywLSnGxnoqeVc4pyym9MFu9qcgxv+JLahqGohX9guSyOuZRnTRwYe6AcZOqKHu1tsWitbrdtkWBga4rZusYzN2zE964DwJaKqYfW7lWlEOzo68k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 7 Jul 2026 13:02:52 +1000, apopple@nvidia.com wrote:
> > +static inline bool zone_device_page_init_optimization_enabled(void)
> > +{
> > +	/*
> > +	 * The template fast path copies a preinitialized struct page image.
> > +	 * Skip it when the page_ref_set tracepoint is enabled.
> > +	 */
> > +	return !page_ref_tracepoint_active(page_ref_set);
> > +}
> > +
> > +static inline void zone_device_template_page_init(struct page *template,
> > +						  struct page *src)
> > +{
> > +	memcpy(template, src, sizeof(*template));
> 
> I'd drop this function and just open-code the memcpy as I think that ends up
> being clearer and removes a naming confusion - I kept mixing up the purpose of
> `zone_device_template_page_init` and `zone_device_page_init_from_template`

Agreed. I will drop zone_device_template_page_init() and open-code
that memcpy() in v6.

> > -	for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
> > -		struct page *page = pfn_to_page(pfn);
> > +
> > +	if (!nr_pages)
> > +		return;
> > +
> > +	pfn = start_pfn;
> > +	/*
> > +	 * Seed the reusable head-page template from the first real struct
> > +	 * page, because the existing page-init and pageblock helpers expect
> > +	 * a real memmap entry rather than a stack object.
> > +	 */
> > +	if (use_template) {
> > +		struct page *page = pfn_to_page(start_pfn);
> >
> >  		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
> > +		zone_device_template_page_init(&template, page);
> > +		if (pfns_per_compound != 1)
> > +			memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
> > +				compound_nr_pages(start_pfn, altmap, pgmap));
> > +		pfn += pfns_per_compound;
> 
> I think it would be clearer and less error prone to not unroll the loop here.
> Instead just initialise the template page and leave the for loop starting at
> pfn = start_pfn and let it handle the rest of the steps. I can't imagine the
> extra call to zone_deivce_page_init_from_template() would cause a noticable
> perf impact.
> 
> It also avoids the obvious danger of someone updating the loop but missing the
> unrolled version above.

Thanks. I will keep the initial slow-path template seeding as a
separate step, still using the first real memmap entry for that, but
let the main loop start at start_pfn again so the first PFN goes
through the same loop body as the rest. That should make the code
clearer and avoid the duplicated first-iteration path drifting from
the main loop in later changes.

Thanks,
Zhe

