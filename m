Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 411D2F4369A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 13:03:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 647FA6B00FF; Fri, 17 Apr 2026 09:03:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61FCA6B0101; Fri, 17 Apr 2026 09:03:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55CEC6B0102; Fri, 17 Apr 2026 09:03:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 429BF6B00FF
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 09:03:12 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BC9D7E2C20
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 13:03:11 +0000 (UTC)
X-FDA: 84668063382.27.870DD8D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id 32CF714000E
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 13:03:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=gllMaTR2;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776430990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jFGslLQL4z4PowPtlmAyWHQnyC73HKWsGKqT1Jxz8S4=;
	b=1PN7w9pYaQ72q98QAqg7skxeOQiHphNkdLtSpKmMnaiOIjECeafvc2uIoNASjAbYi9irwK
	SGNeU88BSEdRqzDrzooCM+wnDqkBzljWAA1dW2ExmQpK0vixs8868nxAW6jjwU4jWCYfSP
	e3SO7RPJuXO10srWBzt5olJxYu4AZgg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=gllMaTR2;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776430990; a=rsa-sha256;
	cv=none;
	b=pJNc8Gd7+0LND1eYRr7FOY3N6Ixui8mG94t/X6NGkoAOhCVuzKH7nqvnHyEBy2aGj7ELFG
	DJ3rX31N+TjqItBR3Dqvb/6AgiO6fgZerjuayKjt53f+p5EC9Z22X6vkeJV9NTkSXpQh8s
	k1kk0Z0Rq/a05uT9wtaJeOQhpp00rdg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jFGslLQL4z4PowPtlmAyWHQnyC73HKWsGKqT1Jxz8S4=; b=gllMaTR25EYyatLlF8y0M3xjAF
	xpLAuDE/TPabF8Z+htIlsJ8V1jsVuL7xJZrNjITB6SvlxlfYokpEsKUEuxgup0ZabgACniihz6hGM
	23rAe3oeFAX6MIc9ehLHgZBGqewYviRVNy32C+CS1md0sYg8z8Wp529i03Kdb4W9rSCWozPUiASOn
	JvMq0Ha6dosHgcx5yjDahZXljsKsJ6wMKR/4Jcb0yuSBW/nCFsTLKEd5Ozq8zVibegoucxBPakr8n
	Vqbmgobwr9F/3dUvLjW6uvvuYTaV3CGRPhrFXAL/KyiBBOQTI0sO0OhMlTkQntJZBFMTYefStsk42
	yhrKHNJQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wDiqe-00000003w2e-221V;
	Fri, 17 Apr 2026 13:03:04 +0000
Date: Fri, 17 Apr 2026 14:03:04 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: ZhengYuan Huang <gality369@gmail.com>, akpm@linux-foundation.org,
	ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com
Subject: Re: [PATCH] mm: prepare anon_vma before swapin rmap
Message-ID: <aeIviKEdw-52J7JY@casper.infradead.org>
References: <20260417011606.1089985-1-gality369@gmail.com>
 <66f67e51-819b-4c60-9f61-170db32362a2@kernel.org>
 <fb80d953-93de-4ce3-80c6-15cd53dd956f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb80d953-93de-4ce3-80c6-15cd53dd956f@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 32CF714000E
X-Stat-Signature: yxar9osbf6xix6371mfxs9atj56gjasb
X-HE-Tag: 1776430988-238004
X-HE-Meta: U2FsdGVkX18ChJ6hg4wLu06vFEQYLBzldJdw+3i43RQrUHB+GSt/CytcgmYu7EUruxv6d3OTy2CUJOU3+xdO39uAwTqhmBf2Lw0VlTmcp+34mnSwmgJ7W99zLE7O1DTgMFQZ0LsmnwK4PzCHux6+MqyVJu8PTxiVGmiL6sQpnaGjJSPdCOKU3jZzp4NE3UtCjZ1/i3waIeEeNYdduO+/bRX57QL063iWiuzp+EqZU1D4R9gMe4okAWhlprefsJkTjrrUxibtYQDqApHnuREHbPGVBEoM65S7iicNdDoQosKdObt+I98b2lvXNvYETL7mDLt3vn6NE5OFbOngchDvOkI65QKAT9WCE6jtGOy6r2gvgHNqLkcDkheh1ZClTlEM6JhR0e9N/ccfE4hV274rHC2kQZMYW8aK7aYHo6qR0cxtXpW/pEUpjHBRB9Miew4Xku2FWgb1KEs/oemMFKNwpOkY8nHHoPOXIk+TP8giCDgoIJ09OFIl8AT0fJ5LEUU5mGtRxa/oKezRxGXrL6EedwIhF6pwH7nS9WDYEqgvy5ulgvVWJ9ghwaSJ9fqWQhF+0oodtn0mmZcwH+rnumO9mIPPuvDT1SHheiDN1AuBnDyuOgA5ctS14GGApg54jKKEaGsPzZUyboMtNjwpdGUWop8lJPOhrj5KKJ5ulVsmKMiWZPOockIfemzoj9LHNAZL1IWQhI212CtqvCJo55vgigbxGW3YNeHeYrHwv0HQIA8GUF+7upF+l+U7VwQdUjE5MxWGBXXBqJNDWSR2IqQ698QbkTdUlrSKU57kADsJsIrV3XlZ/1+RbWCpVpFfcvS2IRrnJ+bhhwntgslxwC8vvjbuF/1HmqvGTa41bMyQdoyAVEOI0RLVynOso8wri7i87+82TIY9uSDiOECedPAqodxWX7KN4GK7FmmMogoLZis49tcrqJMXqm2bbIPxoS/i88EzhepH/uRlXnXODBO
 MzCa/2Vg
 9wfWvmGrA0X17plQjXxQZ8UyJMRsR49siuvbEWBciohDjIC9PbdFAGq7mKQiATtL8HDgCVf195ffcgw+6KBaHPVTf/WbBBGkTKSDBLFAeqGmO4ux205hoJUohPpDtOJwsx/rQlqsBOI8y/8GQzsckhvjIKStIbI36fFt+6AJZJrnmls6rr02Rfwto+cfhflfXWKNJiqDp+vuwJU4s6kvqyj9YXaoRPfp8h+tR9brPeDd2h/wS+wbp3X4DXDymCNUW0YAmo/vXGV8oAOAuuCoJK6oTSGx8Vh9TaglDyYvzxOsYZHc0OxpOZSZo5KzCdnlAGzgB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 17, 2026 at 01:57:59PM +0200, David Hildenbrand (Arm) wrote:
> On 4/17/26 12:53, David Hildenbrand (Arm) wrote:
> > On 4/17/26 03:16, ZhengYuan Huang wrote:
> >> [BUG]
> >> madvise(MADV_HWPOISON) can fault a swap entry back in through
> >> get_user_pages_fast() and hit:
...
> >> I can reproduce this issue deterministically on v6.18, but I have not
> >> been able to reproduce it with the same setup on next-20260415.
> 
> Just speculating, we had
> 
> commit 3b617fd3d317bf9dd7e2c233e56eafef05734c9d
> Author: Lorenzo Stoakes <ljs@kernel.org>
> Date:   Mon Jan 5 20:11:49 2026 +0000
> 
>     mm/vma: enforce VMA fork limit on unfaulted,faulted mremap merge too
> 
> Go into v6.19.
> 
> Maybe there was a scenario where we could have lost vma->anon_vma during
> a merge, resulting in a swapped page in an anon_vma.
> 
> If this cannot be reproduced on 6.19+,there is nothing to worry about.

... except that 6.18 is LTS so we need a fix for that kernel version.
And maybe 6.12 as well (a373baed5a9d went into 6.9, so no need to
go further back than that)

