Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25A54C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 18:41:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D860E6B0319; Fri, 14 Aug 2026 14:41:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3E856B031C; Fri, 14 Aug 2026 14:41:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4CBE6B031D; Fri, 14 Aug 2026 14:41:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A2F0E6B0319
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 14:41:05 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9713D401F6
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 18:41:03 +0000 (UTC)
X-FDA: 85100742006.13.2C07902
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 97041140008
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 18:41:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=MKV6Xn1V;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786732862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SjynFagSsl8rrsVnx8pJ8OUq9MeSaNdTy+JC8pLJaXI=;
	b=Aqq4Dp4QQWhOszFUwE7rn+w33hW7lHmNGNXVlpWK0VpdlVaCACaXOGbn/4vNWXetpEWbBV
	IrmMZWgVzCjr0IEFZ8FOTb1ZmGXXRpjyvNOwb3XbchnKw5xv3Ypf+00HV8g/sz+kpSdWxh
	bkz2FkUIhVRk6tea9Tg/wOw8KcA3r5s=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=MKV6Xn1V;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786732862;
	b=ZuTQQLTEht7ntnnqI2EN+bQgg3ekzxTZcQKBl5tRcerFs/+utRP/A2nHpXcDCVK9zzEfBu
	VJzW5qjnt7aHg+TwZzp3N2OTmgsH/wr/8BHFcZ4VOhGB0onzJRAvRaQWZbdNARKY1kCDxD
	knnI3B8Hp59v3e/e2O7rzyzCAAcaxis=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ECAC8409D9;
	Fri, 14 Aug 2026 18:40:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97ED11F000E9;
	Fri, 14 Aug 2026 18:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786732859;
	bh=SjynFagSsl8rrsVnx8pJ8OUq9MeSaNdTy+JC8pLJaXI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=MKV6Xn1VKPEAbBc8YKVm/3C6/b462nCDy++aVXbZ80VyB26Y6xSAZhrWBCnCCWNIG
	 q9V7cdRdJ9cMeOTWQFp8Hg4GwqXE3ORggzTwsLohnOEeBWMa1/lnkHnNJGs+Vup2bi
	 aMtCXQBk5NXYgduwmdC/9d02D/Q4MS8O7DDDdHnY=
Date: Fri, 14 Aug 2026 11:40:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Longlong Xia <xialonglong2025@163.com>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, Jinjiang Tu <tujinjiang@huawei.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Longlong Xia
 <xialonglong@kylinos.cn>
Subject: Re: [PATCH 1/1] mm/hugetlb: keep max_huge_pages when dissolving
 surplus folios
Message-Id: <20260814114059.c9fd2ef48f4f1b71a8b437f3@linux-foundation.org>
In-Reply-To: <20260814083027.1419487-1-xialonglong2025@163.com>
References: <20260814083027.1419487-1-xialonglong2025@163.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 97041140008
X-Stat-Signature: kznt9w55hab3umeoip59ik6dnw4y6ppj
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786732861-642175
X-HE-Meta: U2FsdGVkX1/AlUkluvAQlaGPudkJgGe+Jhq5bjC8rYecqg2cGOrUtk28jwqNyyVPN4kd7AdxDC1Z7KG1wpapeBndKeQujiVWSEsUxypJeDXPyMqlyhxuVQOXP4YqtSq+jcDcgQRUWpd9AoKeIJPh2xW0kpqKpbugoEHPQAjHUW/ghvK3vDeCt6ja4erX3uW39GirKERdO8D2s+ZpC8MSEV1Tvb3b37Py9miIYZhBQL/V3alJ6iyG7b/ZSMasJAZCeD1LfYVuE3lX6tJxeOfH9n+XYi0zWX+kIpKOiZkdrK0vHcbZxor5pJg7wAEw53QZ2EVenWQ7G23aOQrrkiDoLcMoRfY4QDsYKakEqY9U5Ou/2DN7zUzjcOS4J18lkXbN9+NdUebwUMCtaXUWLkHFWOgutFPvuciorfS+AeHgJktNnLTxhRTjqJRQyG9ujmazVxpltAIPtoF0KGkGc3e21Np2638ZrRT+VqhgE8XL8tH1p9/sDFefN007p+E+rlWiAu0JT3xVYFzXArJd6C9VQ0Yhgs0i6earRvvEaJNGck1WqwcFkAfdrGv4UFUdJW/w/UQwcJk1dKfF8bToOWjkLFRYTWrgbDqzMdJlmg9I3neO5C4mAMkjr4Wvk3TcAupLzi59hK4YDJ7XOp34QGYy+kgNFNc7Ddd4pCxRsJFYRYzUR4NkVNuPhmi8N1Yth9hFjDRwFrG7Ko/HLFGALdn0CZwKE4CVVbou69O230NPP6/D3Gmqz60NHSlbaieEhh/ACJEeg5QXfXJkgUz/TW6Sv+nCYP+n4tIwq/Pxf/Y3LcQMWngmoFjppt7X2qCJ9vBbX3eKYRgYD3DoyNSp5QGWNvkt7VOOm+GWxx+UZVpLbOc0u4BZhPOMqbqSQfrFgDkjHl20UHuElkWqslAgrTeLedsoAqzIjpuXFKYWTd4dbDATo//LhZKiT+YodBeYGVgH4nu3d7ejCUrJSBMQdG1
 XQveg0dn
 awdeGTL6DnlKAnPwCx8QV1JBlGZrl0A4GQ5t61008J7nx7+tY/OXjhXmJBSMr/Rh3e8p72St2jlgkW8MtsS4vpk5P7bh7o77/wc4JhIV6cNv7WQYw3aEqkhW4lshAcuWjlWK9LQzdT8IO/+wrbYmROObW49ZBLzJhxeum9VrY5izOphTDSV8HXPjYNmg3tg478RV6MT4TFYiCgh0+Z06zFiS6ekbzodILZDvo4J+2dmvMcKUi4Tk/l80gGjtmlJMOJFKItwUyPT19H4skJQff/VG1GG88ZlWjGCwIvWvYNwGAxlA8G6RcmYJkaPxSbIi3kLnKRAjDlKERJoPOaFOfO5PRNnYW/WOhFvDJtE11XE1VbUgNnpSs68MxZxqiBByq7T/W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 14 Aug 2026 16:30:27 +0800 Longlong Xia <xialonglong2025@163.com> wrote:

> From: Longlong Xia <xialonglong@kylinos.cn>
> 
> dissolve_free_hugetlb_folio() can remove a free folio as surplus when
> its node has surplus pages.  In that case remove_hugetlb_folio()
> decrements both nr_huge_pages and surplus_huge_pages, leaving the
> persistent pool size unchanged.
> 
> Updating max_huge_pages as if a persistent folio had been removed can
> therefore corrupt the persistent pool target and underflow it when
> max_huge_pages is zero.  Keep max_huge_pages unchanged for surplus
> folios, including the vmemmap restoration rollback path.

Thanks.

> Fixes: cb402bbdabca ("mm/hugetlb: fix surplus pages in dissolve_free_huge_page()")

That's a year old, so I'm assuming there's no urgency here.  I'll 
save the fix for later and shall await maintainer input.  While at it,
please suggest whether we should backport this.

AI review might have found a couple of bugs in the surrounding code.  If true,
they look rather nasty.

	https://sashiko.dev/#/patchset/20260814083027.1419487-1-xialonglong2025@163.com



