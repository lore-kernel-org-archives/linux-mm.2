Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24CA6EA7963
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 04:17:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F22E6B0092; Wed,  4 Feb 2026 23:17:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89C376B0093; Wed,  4 Feb 2026 23:17:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C5E16B0096; Wed,  4 Feb 2026 23:17:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 69C816B0092
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 23:17:29 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 395DC56CD0
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 04:17:29 +0000 (UTC)
X-FDA: 84409093818.20.1FF9743
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id E24D0140003
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 04:17:26 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=T5Ngi+c7;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770265047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pf15hugocmsBA1n+k7JdTpjyzGH93mUVvu7n/6Ol7+Y=;
	b=wniE0OHhNMjaqcXQNldop5k94fQUosNoSTlH9UPpOYKL28HkoOKwnBP4gmHNRp4PHRwRfi
	Z/mdTSNIcqsGLfu2SCmQeA6Zsyk6QPqlv7ZDFObp1fQ5wskXo9NukcoVXnMdOcamrY8mqF
	6cGgLgeKi78nmUBjvVs54CDjG01+z6A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770265047; a=rsa-sha256;
	cv=none;
	b=54btrH3kZkTSvzlL53n4Ki3+JhiCgrFoHwPrS5aFAl9RU8Zxrgj9mfAtyg8ex/K824Sg5b
	sGqNELkAPHZBNHyqtCA0UahSfmoE9F2r3KA9iIhq80v3uZG5vHujr2n5VPwLEibK1x0bhi
	exM1Sct6YCUhvEG+JC0dUooTiHduWI0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=T5Ngi+c7;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Pf15hugocmsBA1n+k7JdTpjyzGH93mUVvu7n/6Ol7+Y=; b=T5Ngi+c7LeRLgjSaxA3vtckg9A
	9jUrICdhn7T/tw4zJksOJWYF7LdWvpPZVYzPOLA0Q9RKiSe9bb7GJoylJa1BUijxUZBtdPMOjwHMz
	F3B+OIUjgFGtkQlXJ/ZlNv7kJ+/y+QMRIZFs0zDlifSyeDldH8OwQY1K9GFxD+qtlmPrfVIWBUcSJ
	x0FNxg4StrlPnALcFtZBqIUhu1qcm17t29082HqOIFlZzRkXm/rk22h+Y2cNTt8OUZ0ANn0NvDUDj
	gfCJmLmKzzVuOquCvHpjLSZyD8uJjfkB5VydNjvSRkJNj5fGYU51evnMQ8k5JDZi8VyKlzKwIS81X
	QtXsBp3A==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vnqnv-000000035OP-35v2;
	Thu, 05 Feb 2026 04:17:19 +0000
Date: Thu, 5 Feb 2026 04:17:19 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Usama Arif <usamaarif642@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, Kiryl Shutsemau <kas@kernel.org>,
	lorenzo.stoakes@oracle.com,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev,
	baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
	npache@redhat.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
	vbabka@suse.cz, lance.yang@linux.dev, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [RFC 01/12] mm: add PUD THP ptdesc and rmap support
Message-ID: <aYQZzw8kJFsy1mMW@casper.infradead.org>
References: <20260202005451.774496-1-usamaarif642@gmail.com>
 <20260202005451.774496-2-usamaarif642@gmail.com>
 <aYB75cWO2nnTx2ch@thinkstation>
 <63D23D5F-AF35-4199-B52E-DFFC16DFDF91@nvidia.com>
 <05d5918f-b61b-4091-b8c6-20eebfffc3c4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05d5918f-b61b-4091-b8c6-20eebfffc3c4@gmail.com>
X-Rspamd-Queue-Id: E24D0140003
X-Stat-Signature: ue7z1aze6p1zuidq8g4p9hxu4xfi6zdo
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770265046-74792
X-HE-Meta: U2FsdGVkX1+gIi0qJw22kadqFsAkC/JmT+hWUZNs24Nphce1MKd9VoveIueKOxCIQILM7xjtZlCESanRvCMHOZ+uoJAtMv+i9gnmGrZh2CCP85kQ2qhyJ3pK76O51CavRzjNfcS4Y4zqO1IfwbyAl/PgOAIZuIpzcynBKUoDbeoQdG4tmof5YpMNDfjsj/0O7CGl0HO0fGJJtScT08/STXMnouiJVhNFPNiEO8c4w2ubtwu8y734FrtFF9f5es9tZU2+yE6EMZbZsy1VsjF71uavZ6hZ1dnD3W1Qz0b3BYscMH5O2HjamgVW58UkSbJtfdmZqqWlOvu4lNXkCxhPa6P32UyVaJrORyuH6NRz5RF+20SObuPbgzcCBxWQksn0IllJMRx/pI5XyXzir9Ur1uqtX3g0z3CDk4GFjcGbBPmvoxb60YdOO8i3TCbhHxzACjfQVwTHNouCm2fFRgZkhPhO0j5vn37dhKtGpKZEtyWCP0J7sgiZIb/uFZRbub91Umep5XSVXTwX7ynFqzumX/c+GX/ZwhdmdORcjk6qU9nTrHC0zME60Rnh1yicIOxSALfKkzGk8DnGwglE9GHCcqOZTM2GMnfu3NPkXbZLNK/vSYqAPI4SrMt2X0UvDvvyCC/upG9lU0SgAS6NCP1IjQaIZ7kKj5nDLKT9r7MZgqWCVQMhbUnBKzlEJXJrv+PsyHz7VLZFrxE3HZJFDz4iFqY8cczkGaadLtv+KaNh0nNn4HanQGv21Xl13U649LsIUw2SjXFS5msFEhSgaV9GobVjcAKrUNOejyhk3coekZ1VYm6PHsxXdJAMgdGuVruWBoWPnTIPLF4mP4JKDzy9Mm+yqlZLoojos5K4Qa0fc9qKPeLIN11Q23+rjVtnv/2F7UBipJtwI5kP3emVFKY0O1wWP5FDCYg9NRAQQtGvWMznJzazsf4MTUACubTr/usDTbiSVVCBNuTPqt6C1Jz
 hlvodVz9
 ddQcF+tumraDAA7whywaE665t7J0CTUjwRy+1ya2J+2KxagO/Qd3Y5YAi9/TxXrP0MPjDxCc+JWuazwExVtl6ESSy7L0m+rB1kTR3V4Lk7HsULQ7XCT6uUtwG8R+v4utdG18Rn+xff0OCAnKG3tHpF+Gblw/y8fz+/6YDuKyUoxZ1sZiroGzprB/yol9a1kIE4aXw2Pn/sxa1lzPOLaXGG32kg24BblChNuMdfwq1V9q1YmlFXNtH1EToMk9oCN92Xv4u
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 03, 2026 at 02:07:25PM -0800, Usama Arif wrote:
> Ah I should have looked at your patches more! I started working by just using lru
> and was using list_add/list_del which was ofcourse corrupting the list and took me
> way more time than I would like to admit to debug what was going on! The diagrams
> in your 2nd link are really useful. I ended up drawing by hand those to debug
> the corruption issue. I will point to that link in the next series :) 
> 
> How about something like the below diff over this patch? (Not included the comment
> changes that I will make everywhere)

Why are you even talking about "the next series"?  The approach is
wrong.  You need to put this POC aside and solve the problems that
you've bypassed to create this POC.

