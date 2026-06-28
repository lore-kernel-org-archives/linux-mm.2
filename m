Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6B8EC43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 06:55:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 779FF6B0005; Sun, 28 Jun 2026 02:55:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72ADA6B0088; Sun, 28 Jun 2026 02:55:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 619E86B008A; Sun, 28 Jun 2026 02:55:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 385596B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 02:55:17 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A06EB120354
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 06:55:16 +0000 (UTC)
X-FDA: 84928409832.25.D22A3D9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9651A1A0006
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 06:55:14 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="jjFb/T/9";
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782629714;
	b=Ng76AfkyATXBEP215TZAP2OG9VzicKNTgPDXwX2DxynNzQd4FiysCtmDiyUYQKIJaDp98L
	vd7vrM4DG6IDgNvqXeClEmyk0AnGrByNWPcT5Zqo0Uvzec7eZpGjW9I1lHVowzr9xzB0gc
	POPW+RmvPH0QaZdXS1X+dWDrFOcBGcY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782629714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sHbfVijReW7xHmccVvO9CNsf1KBaIlaAL2mdy+NudTo=;
	b=ZxPAuLyuY4NbQdrhEFD/G9+zh9NdoawL8zxXUAcR+aVtViPq+CNosrThpx86N93VcS1h9O
	szvHkl+OM3QqPzYjtZ8u9rNWWwSnFn/CLkfW2eoU+/rnZetyMPattWCw/ZSaPlYVr0rUa8
	N7lqDwKg5/O71UaMeAqAGHtSKpscbLA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="jjFb/T/9";
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B44FA600B0;
	Sun, 28 Jun 2026 06:55:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3CA31F000E9;
	Sun, 28 Jun 2026 06:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782629713;
	bh=sHbfVijReW7xHmccVvO9CNsf1KBaIlaAL2mdy+NudTo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=jjFb/T/9WdwCYb7F6Yh7CUpxOCstY/0t304rxgf4JCp27/uA+vvISo45pIocdabWD
	 8mgCVrhhq2o+Rdc67Dz59ySst9iWpL0vnKVKitbWRL0S8aY1hjWoRruZ0Wv8FG1OGr
	 59l7p7TryXJJWvcVwZyfDH5mHRt5TXomgeJGuB+8=
Date: Sat, 27 Jun 2026 23:55:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oscar Salvador <osalvador@suse.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Karsten Desler
 <kdesler@soohrt.org>, Muchun Song <muchun.song@linux.dev>, David
 Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil
 Babka <vbabka@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, Andreas
 Larsson <andreas@gaisler.com>, "David S . Miller" <davem@davemloft.net>,
 Huacai Chen <chenhuacai@kernel.org>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/8] Stop special-casing hugetlb mappings in
 get_unmapped_area
Message-Id: <20260627235512.787d09b15b3d2ff9441e604a@linux-foundation.org>
In-Reply-To: <20260606035003.529685-1-osalvador@suse.de>
References: <20260606035003.529685-1-osalvador@suse.de>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: xwbpphnujuhiugrxiuatmx8ije1hs1aw
X-Rspamd-Queue-Id: 9651A1A0006
X-Rspamd-Server: rspam06
X-HE-Tag: 1782629714-310276
X-HE-Meta: U2FsdGVkX1+bcbbgqfwunpZv/ysA6kJmBl/pj/v6MnEZ0IwG0TtZvUB7RNrWxIUVbP8giRRM2u4CkagRGsD1T+lQAYiZp3oUA/v1Fz5DjsbMwjD4Yfd2v7IVamIRVMp6Newl+t3rXw0Tu/V32xo+o83MNxR43vIQnyOPrvZGtuYlwc0ijC87Lj51ajL46PuXLeMFU0vVE5KCbZmWegKx56qHHYQFMW2HhddQwCJ9aMsI7KhuGTbXxKgevSLiF3Tt3CstEDrbF6z/jWi0rTkwAGEjd/1MpXLWmDOmXwTo4ZgMOh27Eten2dd2NNzkgdJSeHLkh6KMeQYDiksuPLb4hWwFt2M/aggOBKd6a9xTE5/g6y0ayFYTft553hliD8zhOTiFp0xGIjoN9VLmZWBCT2WxdZ9pxMLAzz1k4vsPqXH02txDqC8im3wNisYYnJPakrLgUoaEIO2AeIqdofPxX2X4buG/ldmlCdFdu3stsyy3Kp0rNC2R5m52SDj3gx1BLVjBAr9g/Og8YMKo7MY/K5aUKLTKYlskDRD9+QDI+wRQF48C9pM8o/rd2N5LkrtJ2ytBWf2QXnqyTiSU9ZOANY2b7euIh/GfqrGWVROkIT7LgFy+8AXywCziMcgg6l9REvjfcl3akI131EiGr8d8OCxgrpZ+WwISJBkcYBXJ9GF316FvxAk1hkvE01vFtzL7BOth6DTTwV0LHi4P4hGxeO/pOhW5Y33z/mPNtLBcRS4CXHj1urrNz6Fvk9LhlGAjSWQxaiOKaNYd25JOhB7Vs6V4llxiedB9E1YurW+UP6nelAiNEKbNrPlDuRvqME6gZDAztVowQMtmUZ6oEOwZu10cO0q9ArUuS2gDaM8gSS1FxUErFGHeKTdxQ9gQM5Hmnwc7v48FyrFmHr0Tpb8VdxTfNtjiM7+hnoEqUIjKUz+HszMl8Qw4OO+XI+1qUT3LmCExIf/+t0AA8Wlatbk
 ak0z06LV
 4IU3Dl2/On2lRNpo3u8ASeGhS1gWVr5EC7c/dZWk7Iu0fauR9r/aH/aQp5XLPqtQ+PWWQlqcbS7NqYgCA8iEud/G+HiFJYmj3GPK6tMGw+eQwgFQaVosE8hiLeu27eZUH4SPAQZ2Bfe4Ooab5241J0v7XT79WokSL7O3b+YBb8+niIQnWgoXr9VcBBfgpHHdOdkRADzQ8ixtkb+GjQ8iO+hkRdAiF8wYSGVQeG7GgW0OLynQXOav8Trvt5xuL4Y2Y+TWQ4n2zajohI/otH3zItnq4YzNi9QeX2HvDFClMYukIRpNxiLmYg+9kEgmo9XXXgbECHxIoM8Amnukg2ZqgOvZn3Ep2u8AWEVu15Kp8cTrWZ0k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat,  6 Jun 2026 05:49:55 +0200 Oscar Salvador <osalvador@suse.de> wrote:

> A regression was reported on AMD 15h Family for hugetlb mappings when 'align_va_addr'
> is set [1].

It would be helpful to say right here that this regression results in a
runtime BUG().  Helps get attention ;)

> Historically, for hugetlb mappings we always ignored 'align_offset' in get_unmapped_area
> functions, but after commit 7bd3f1e1a9ae ("mm: make hugetlb mappings go through
> mm_get_unmapped_area_vmflags") that was no longer the case for x86.
> 
> While we could fix that by work it around in x86 code, the truth is that the current
> functioning of hugetlb mappings with get_unmapped_area functions is a bit clumsy, and
> we can do better.
> This patchset aims at two things:
> 
> 1) Fix regression reported in [1]
> 2) Stop special-casing hugetlb mappings in get_unmapped_area functions

OK, so the offending commit was about 1.5 years ago.

Do we want to fix -stable kernels?  If so, can we start out with
something minimal for backporting?  And narrow down its Fixes:?

The series was sent at an awkward time in the -rc cycle, which perhaps
explains the lack of feedback.  I suggest a refresh/retest/resend to
help bring people up to speed.

Sashiko has quite a lot to say - I hope some of it is useful?
	https://sashiko.dev/#/patchset/20260606035003.529685-1-osalvador@suse.de


