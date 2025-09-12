Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C48DDCAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 15:21:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28C818E0008; Fri, 12 Sep 2025 11:21:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23CA38E0002; Fri, 12 Sep 2025 11:21:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 153278E0008; Fri, 12 Sep 2025 11:21:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 042E28E0002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 11:21:35 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A8F111A087F
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:21:34 +0000 (UTC)
X-FDA: 83880962508.18.39502A4
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf28.hostedemail.com (Postfix) with ESMTP id 306D9C000A
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:21:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=nTauwZnj
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757690493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d4L6UERSUOracgIwE3XhKEBtUrUmqFBKh6Ibcm8VYUM=;
	b=FqMW0anHC8CojIbw+uluvfnCmDGZJncl88UroSTt82lHX19k5XoYuLHLG8SQ38OeFA8kUp
	QHyzbw2tq8HOeujZbZPEL0QjUDaPflS91ckes/qThvw32tf9htIsTdDkCFu89AuZGhWJ1d
	iOiZmVNS4fhjQQKOmVvj042tk+mO3uM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=nTauwZnj;
	spf=none (imf28.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757690493; a=rsa-sha256;
	cv=none;
	b=je9vkDGutVZdmwAcDNE+B2mX3Mem1KHzQ1IkYMgLtNmJYGGfV//7tnc9fSb+kRi8+aNkp8
	uyz7ibFFn+Gfb4Z1N24D0UpMh9OxOzV6SRqyiSEt9AgZa9/MnyEmrtfFyQMcFbxWRaKX2P
	FtdGA98s3Xl8VVvoFVT48pZKnzxU8C0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=d4L6UERSUOracgIwE3XhKEBtUrUmqFBKh6Ibcm8VYUM=; b=nTauwZnjXYiFWYrr31vLVhi97Q
	DBH7B71TT7gySBI68eEf/NWSX4SMiDjI5BveiyHNlHwXWKWNtliCE6fSkcJjh094ugEjD9RU7fls/
	NEs8xvD3Ix1B+JTG5+qZfQOODH9QxhJ+AIC27ot1slnF/qgxoO3+hEGljf1gN45mt0hchWCD67QAv
	pkf/gvQ1QwAhBqWTYLlJ5/9ceVxjO3uMwSGKXVoi8CtNmldKnP2b7UMVvtoa36fGc2R3mDeoqfJMN
	RUZWme9gU4OCncQ5XsWfkbGMNY6NP5EQTsvjGiKCXN1UYjLOlSBdaDbPQVWteL8AUBRW52og+99z1
	4ClHuZqw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ux5aQ-00000000rLL-0XaV;
	Fri, 12 Sep 2025 15:21:18 +0000
Date: Fri, 12 Sep 2025 16:21:17 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@redhat.com,
	mhocko@kernel.org, zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev, lorenzo.stoakes@oracle.com,
	hughd@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: vmscan: remove folio_test_private() check in
 pageout()
Message-ID: <aMQ6bW-OoMWMVEFF@casper.infradead.org>
References: <cover.1757648598.git.baolin.wang@linux.alibaba.com>
 <b8c0fe71982aa1cafafd59d8e71064efaac16007.1757648598.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b8c0fe71982aa1cafafd59d8e71064efaac16007.1757648598.git.baolin.wang@linux.alibaba.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 306D9C000A
X-Stat-Signature: 4dqjmw8yqieah8y4xd8jx4i6eg3ggq4t
X-HE-Tag: 1757690491-919097
X-HE-Meta: U2FsdGVkX19SmkK+KkWw218tNM7JYl7C6yEctHLsB74o43SS64Oe9z1xRjbTtfc0ewo+vtoXsOBV6a8XVVUviKO3PSZXo7eg58QCpxEz6mTByg3FP2eEQzydLJHtRdHcoRFPo5+jpUNSggeIF9Lrn3l/ShfHXELnc7HrfBLxpe3c0UFVV379/X0R7Ucz6rIQH+ar8sNtN3hNeNDuYNplJZ1uYtjLGfe5XaEs+sG6clswp0Hqiwq/0wbavNIiF93iBsVolkiMx0E+FTw1i4rXfgXNAQSvEzcECE59/u1aTeOOzYjzkfKIfK0si4dWFGu/HT8JWeJu5JjNn6dMH1pDDgpHFi6LxlpZOt3al6hr3JZFCWBoqYx7YlrJQjY2CxXJeZO2gnC0V9pBwZEtSxb2g55Dpk335JyB6ISyUG5bm7vBiSCud+eZ7+1pI8ppHPsf7oT3lSMxZzupkiXSWyRaQet/kZQa0ijPWtk9blru2qZXvKfiKbCVKCpvJjxwroJXM6rdiMPjMWiEGQYybR9raFDgha6Nzz+To6QWkTZDihD1Zw6QDwK5HeOML0SJ43IODOn6qCc/qJifhkvvY1BMbOCF3hs9k9z/ozGqt0ska/vgYYnNBNpUmqFGyVLKF4Evv944wmbr70o3jEo7cERpbkpS6Wv+s2aOz/2u6aM73nqgE5KCK2v1HisD4+C08qr117eBIep/G3dHxcpQd/rOt3G+a8mGaleTF0eYunoliLHaZKBzji96lK6IgKM2r3lip9TySEpSol98F1Z5jhQ50+YlR0NZuZXYFP/LFyLTGDaj663iUHNjpFs1k+XYydKmiv5gf47J75/AFym6F8G5+tRBru5F+upYghPqu3HhnRUjrYdrGuGl6E2DWB6WOlZiSNLE1upwW+ylbIxMeUgQgWr8KDxDo+AhPv7fjXMDd0FCHiprLYWg7Hoc2jppPlXT9O7IjU+cDR62blcvsxb
 ww2YExX0
 WQweZn1Bvf/ir55/D83+h+blBL3T9kLnqMRBsdKVThoydS8uAo5nzmjVnBeTyhhj1tJ4Ru5nxwb0tW3vFx+zaQYy+BSiyzdzfIYb9ShSsbc8jKzA2+EFBaCCAyZcBOiGHD9gCtl8MsebTQB1VK6K1xmq95cJfAwIut2Vc/Cdh6uXmta16OaOk0Cw8sKVl8U5FU24yKsrIhNaH195W6lEYoFeaw5/N3Vynbb3I
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 11:45:07AM +0800, Baolin Wang wrote:
> @@ -697,22 +697,8 @@ static pageout_t pageout(struct folio *folio, struct address_space *mapping,
>  	 * swap_backing_dev_info is bust: it doesn't reflect the
>  	 * congestion state of the swapdevs.  Easy to fix, if needed.
>  	 */
> -	if (!is_page_cache_freeable(folio))
> +	if (!is_page_cache_freeable(folio) || !mapping)
>  		return PAGE_KEEP;

I feel like we need to keep the comment (assuming it's still true ...
which it probably is, although there's nobody who would think to update
this comment if it became no longer true).  I would certainly wonder why
we can have this !mapping test.

> -		/*
> -		 * Some data journaling orphaned folios can have
> -		 * folio->mapping == NULL while being dirty with clean buffers.
> -		 */

I approve of this simplification, and I think there's more work to be
done in this area.  Thanks for doing it.

