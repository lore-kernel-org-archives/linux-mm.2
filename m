Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23388C4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 20:56:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D121D6B007B; Tue, 21 Jul 2026 16:56:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC3446B008A; Tue, 21 Jul 2026 16:56:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDC336B008C; Tue, 21 Jul 2026 16:56:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 909076B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:56:18 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 12AAA40174
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 20:56:18 +0000 (UTC)
X-FDA: 85013991636.14.97C250C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 526A6C0004
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 20:56:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WDdidS21;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784667376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=effgOexwWcG/ga7iXqcUg9L0kW3t4xU7toK0kCCOMRs=;
	b=PslYJRZ0YIiOcL4RUuwBL7VmKzfsocFjtAwGyysK3Yo9bNcAB6hnJ5uiEpfm1css223zwo
	kxplmcW+za9i6S3lp+SY62AiZ4yBlAkLIHi0Gmy26E95RiuXmQw0JBeAKhkfD3tzPsivBJ
	0gauKGL32w1aIFHnP5Z36Jc7YJ6X8Ek=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784667376;
	b=HulKo2NNa9ZXSEy6BchbP4gjikW2N4Gas+5ABuo6UYKEjjBFtMXSdsw419eZsDiyjmigar
	BLpj8WLsTjD5Evw9/jFQ45690eGJNhY2HU9edyIz/I3NpK+gH1lRiPBU87WypnZBkSGS5k
	orKoWeqK1gasF23BzvvdGenPAKPcIfQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WDdidS21;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0F30C42A62;
	Tue, 21 Jul 2026 20:56:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD2F1F000E9;
	Tue, 21 Jul 2026 20:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784667374;
	bh=effgOexwWcG/ga7iXqcUg9L0kW3t4xU7toK0kCCOMRs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=WDdidS21FUy7qaVnd9wBHMLIAIRyeZiAMpxlV5b9CapOu25JIGj29Vqa9m5EyUae/
	 1/Z4L10d3urWhnPHK0dR28hFfNMz8MNU75HCo80UA9bheT1aLCNzcdlevs6fx0NkJ/
	 PX2/6yhfPDTe7p4kK0/hhBGi0sKmKjW5LUom/gCg=
Date: Tue, 21 Jul 2026 13:56:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ren Wei <enjou1224z@gmail.com>
Cc: linux-mm@kvack.org, pasha.tatashin@soleen.com, vega@nebusec.ai,
 roxy520tt@gmail.com
Subject: Re: [PATCH v2 1/1] mm/page_table_check: skip zero pages
Message-Id: <20260721135614.7aa2d8d9a8a732a66ba623c3@linux-foundation.org>
In-Reply-To: <1f8848512d2e3ded944f8d595c29faee8fdaeab0.1784645969.git.roxy520tt@gmail.com>
References: <cover.1784645969.git.roxy520tt@gmail.com>
	<1f8848512d2e3ded944f8d595c29faee8fdaeab0.1784645969.git.roxy520tt@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 526A6C0004
X-Stat-Signature: bgmpyq7jizd95uoebnbu56hz656bcqyi
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784667376-116809
X-HE-Meta: U2FsdGVkX19Rww6vOQ6q4WlL/h+UhWZJkFwXxuvoYaGpTAfV8XX3SGpOtiwnPglG/SCpblr5952JGM9bknsqkDCpSW0XBn36WwqwrfrbQB1d5/2X8PDUbFY60Ccb5CWnnQlfBNyLfw6JmyfGIBb9kD0l8fZ15tnAVCOryyvIvmJvY7Q7bj5Y9TRNU9DgIL1ufQ/rr8f6d3QdBaawctVjhDSRz+tUE3pz8I2vqdpWYdVz8UZN0vnIiFNjfA6A+L1mykSqV7VYNsCILlr4c0vd7ViYimPnWtY+P/RRBSgBtiaUQGmmd4R4YzBabZLaI4kA6DFo5EpgBfDYQllpHmcbxKvvsiI2p9TpA6o/bzZrsTqq6WmreYCnPox03Kn36WANYaqhnwozjDQkxZDRuk2I5zS6VT2qLZobSHi7KXssp4TgEDA989kEZEzHkgeQU+BD2wlouI0MzivbYeT1Qb+JHWProUepOBWXHdejdIU481fDjAWBMjqBcjTV36mnsJPZTF8mgfEatHZffCfaQoSNo+8EITO+oBRWbntm4la6BRjHsRKLbi0hTutpg+mzTUS5PzFLlWVxQhGiapnDiHcMx/RsjRcEFl+L6LCY4dYQr6uGCbVPNFxSmP4nQ4s8GpLvucQgU/gK6WUtvbOMk18BsvHKdhwPDEfVvqoDI5hhX873KUbJOHOuuhoCbwS9s72cb9TsXcmP8PpBmhgiSszz87KSLKuDMkodiromT9cKCPs1DZp8uLZEElYV2zT8HugDn/SJBX8x0a+9v5FO2ruwZnsHkj/xt+qCJ13QzxPlII/oVz0S10GYQX1B5le9i3k2e9LUyWLLp9EKiqm+f8XBPLYfGDbNkC5aSq09mpnjQ4tBA0fSiNgdtnXRQP8XtFYGpgRYx4QE2dra/n8mVNfJOXM0c9a/TPUFte9BCHERIOCDsEM/Ik2UOh7SQ2tFETLR1WsSEIzTjHBy15w2lh7
 yUTU/+sW
 3rZt/thCefPXXE4JNvyRAxnXLP1KYlWtYejK086kWGVr1yE82/UQhBoIR2wBTs0RrThk7c8tZzJVM92VevkJLaLM1SYKMm6RloBaHA/EVUmWQIdGzn7OKCCqUXOHqbKiGmEblQ5HWp4UFsTwVuEzJAr3NbOLdot4aRxDHnCCA273akwEOjJ7tG8euIDup/JHAbM6duxdwBwkF0YDqHIGMetVdm5Rn3sIVeeYIK9E3ImtJnQR3Zr+V5/XBqOmf/iksQLgE1GksD0C16DtzfCGoqiypMv4b2XlEWprecjW13LvcyO5wIM+twzmddSpgtOAWJRmulsgQjGf4htkKbt/7OHmonxhmQoWr813upehYB9NGzD2VEzB/uwXhRgRRh5FZ/Q++
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 21 Jul 2026 23:56:38 +0800 Ren Wei <enjou1224z@gmail.com> wrote:

> From: Zhiling Zou <roxy520tt@gmail.com>
> 
> page_table_check_set() accounts pages by whether they are PageAnon().
> The shared zero page is a special page, not an ordinary file-backed
> page. Read faults on private anonymous mappings can install many
> read-only PTEs that point at the zero page, but page_table_check
> currently accounts them in file_map_count.
> 
> That lets an unprivileged process populate enough zero-page mappings to
> overflow file_map_count and trip the BUG_ON() in page_table_check_set().

Yeah, we don't want that.

> Skip zero pages in page_table_check accounting. They do not need the
> anonymous/file mapping conflict checks that page_table_check performs for
> ordinary pages, and this keeps the existing counter size and page_ext
> layout unchanged.

AI review:

	https://sashiko.dev/#/patchset/1f8848512d2e3ded944f8d595c29faee8fdaeab0.1784645969.git.roxy520tt@gmail.com

claims that we're missing a barrier which, in the unlikely case, can
result in us "mapping the system-wide huge zero folio as writable".  We
don't want that either.

I'm not sure why this is described as a pre-existing issue, as it's
this change which adds the is_huge_zero_pfn() check.



