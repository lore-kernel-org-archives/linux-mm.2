Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F20E1CA0FF0
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 22:01:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CAF98E010B; Tue, 26 Aug 2025 18:01:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17B9F8E0105; Tue, 26 Aug 2025 18:01:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 091D18E010B; Tue, 26 Aug 2025 18:01:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EABBF8E0105
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 18:01:04 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 76DC81A034B
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 22:01:04 +0000 (UTC)
X-FDA: 83820279648.16.ABF0825
Received: from lobo.ruivo.org (lobo.ruivo.org [173.14.175.98])
	by imf23.hostedemail.com (Postfix) with ESMTP id 89D73140017
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 22:01:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=none (imf23.hostedemail.com: domain of aris@ruivo.org has no SPF policy when checking 173.14.175.98) smtp.mailfrom=aris@ruivo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756245662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0x5Xj4NGXhoikuoW+nUhn+/CSEwIITWgKqBqA0XFyq8=;
	b=0FBJj3tyHoa5u/udJgQ3TSVBeWn/XNoT1WGFzzBR2/AvUuCCX7hjlBmBxeC2JRiMlcXntg
	62Nu9pefO/eygYZ7pg7wUc41BpyeLh3/BvxtYdEmIj88tACffzdLFHLzuDxaW8z31tAMNn
	qn/URiB60hb/YVCtYv1M6cOZiEs+qwI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=none (imf23.hostedemail.com: domain of aris@ruivo.org has no SPF policy when checking 173.14.175.98) smtp.mailfrom=aris@ruivo.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756245662; a=rsa-sha256;
	cv=none;
	b=bBCW+l8bWUedubdFMVe7PD7umDPPUiXi8iupa/9rWhJ1PZoDo20qgyTMTrw3Qdj7s8i0n5
	fy3yiN+qyz3HdD4Gr7AMjlyJ4gdrY/zJF23BzvxjGUoCcxZGv70LIndnv9p/LYtebBKRKi
	C71wI71yRG8Bn3oHToBUp2ryiOdrw7g=
Received: by lobo.ruivo.org (Postfix, from userid 1011)
	id 831C252723; Tue, 26 Aug 2025 18:01:01 -0400 (EDT)
Received: from jake.ruivo.org (bob.qemu.ruivo [192.168.72.19])
	by lobo.ruivo.org (Postfix) with ESMTPSA id A8D62523AA;
	Tue, 26 Aug 2025 18:00:41 -0400 (EDT)
Received: by jake.ruivo.org (Postfix, from userid 1000)
	id 8BAF517A0A4B; Tue, 26 Aug 2025 18:00:41 -0400 (EDT)
Date: Tue, 26 Aug 2025 18:00:41 -0400
From: Aristeu Rozanski <aris@ruivo.org>
To: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>
Subject: Re: [PATCH] mm: make folio page count functions return unsigned
Message-ID: <20250826220041.GS3581799@cathedrallabs.org>
References: <20250826153721.GA23292@cathedrallabs.org>
 <aK4EOf-EE43pi-xq@casper.infradead.org>
 <a959a7f8-20c0-4c2a-9cef-ffad4f8b805b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a959a7f8-20c0-4c2a-9cef-ffad4f8b805b@redhat.com>
User-Agent: Mutt/2.2.13 (2024-03-09)
X-Stat-Signature: hdk7cy9ip188wf581pacs7i46k5jjzfk
X-Rspam-User: 
X-Rspamd-Queue-Id: 89D73140017
X-Rspamd-Server: rspam05
X-HE-Tag: 1756245662-532400
X-HE-Meta: U2FsdGVkX1/+5FGBT/kEM3wNr2Yq6VNJ+SkQY7vjxLpU9LIWsPKJQLexNaAj/boa8c4eTeYcqmLhsoxXFDyJj/Zsl1+uMCrdx5LZgDrlFOkR4FKKwOgHmOKKx1+EJTDSQob2CUGhl2HYMpIEKzwseAPfRnBIXLZMnSS2LYHB9j63xy3yeYy2SckpTMBjeeTLmPa7BCMSN++Z/vyquIgs4uNHBHr8J4SlkZP8oEcmMIkvJ2zE7PzpEchMWUqmUBsbZbA1y4bPDfXh9JwUuvExayE7Wx8dU2mMtwDUu4xP2fMQI7k1aj9tV6MciC8Id2d5q070DG0jWXMpPRU6ZPgQzpoULnu4rFxrdQSVCLi90kMY5WE1cXdXkMgUoA+pLc/vayCQWjtjZbYNB1E5QqjFSV0r7FjApVW9J5J+w5qn4J/azsgdPa5DOrWtW1jX6GKA+uiiEEdrJ7MVh+vqbnyqoqqJF8IVifnSyCoIwXDwG75lq5p2lRos8TIOpWP8TUgkHBv8GKcaNx0I+iY+A+NJkrZvP938/80r2BISExs34jhpNkXp8Sfq5tlaZ042hznQIAFJrsAgQw+c67VS1MfABfcytslwgIJfytS7hqurqMEXGylDZP0AjILy/WF1Api8aFnJwDio3QDGhudBHX88f9yVekhulJAsZzDGoRAfOVeXQdPjVIFes6ft8YCTHOMems2ksxfBTwZKwAWMClusQgDMDQHgUmFW2tm5sngB99KrzPq8ilnlzMtuF5tHJToKrPbtK6W4X0r9Obd0ve/GzQnPZYzDCboSkCl1ea6eLr6jABSFvoRCzYcHqbSAU+XL8G4UNjkjWn5myhS0YcwZ5fFryjXV0bKs1pJ9Wzrfu53uujh4gIe7/onEQqoEqP12HSS70TPyzpeZ0HeioU0BFf/zI05bFRxWUiYaUiSmUyRwKYc56/+UcQ22v80RidiAfgT82nQJmYMCFLWfFQl
 zB9OKmgE
 sOj6JEeP/I8I7Q2MDhy4nGDkan05oDHlJN0vwWZc3BHM1WZAX+YrXMd0+Z7ndbe8Jg1OrRasCmWwqP7I+s+uoWLUGPNkTTYfzjo4Q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 11:45:52PM +0200, David Hildenbrand wrote:
> IIRC, the issue is if we pass -folio_nr_pages() to functions that expect 
> a "long" and we are using "unsigned int" as return type.

some actually expect an int (e.g. memcg1_charge_statistics()), it'd be a good
idea to get those fixed.

> Then, e.g., -1 will be (unsigned int)0xffffffff, and casting that to 
> "long" means trouble, because we wouldn't sign-extend properly and get 
> (long)0x00000000ffffffff.
> 
> Using "unsigned long" instead work perfectly fine.
> 
> e.g., -1 will be (unsigned long)0xffffffffffffffff. Passing that to a 
> function that expects "long" or "unsigned long" works as expected.

We could run into problems if folio_nr_pages() ever returns an unsigned long
larger than LONG_MAX :^)

-- 
Aristeu


