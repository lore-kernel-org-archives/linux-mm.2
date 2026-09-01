Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12CC7C624D3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 17:24:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 157506B00B3; Tue,  1 Sep 2026 13:24:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 108CB6B00B4; Tue,  1 Sep 2026 13:24:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01DD96B00B5; Tue,  1 Sep 2026 13:24:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D795D6B00B3
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:24:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4CA39160495
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 17:24:28 +0000 (UTC)
X-FDA: 85165867416.07.36805CE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id A868280009
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 17:24:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LA5VUHH3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788283466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FNtqw+4cMw2tiBTTuj3vqzwte2JlYbPEDqcQmayzdB4=;
	b=QbTOp4H2HeOh86etNF6/C+HLnj5Hx8tegPamoLO7QirFzv/PKGAGr+ZaxnCZD1dy4IYDBM
	n8YjUuIYz+YdgA4PLMtpvRExGOhnijn2dWjgL7/12La3E/dYmL6HrVTf+UNQiALr00ecgG
	YnkXtJiMnQdjOkIM3PtydDHhzNFXlOo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LA5VUHH3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788283466;
	b=rBUltPwPWQU/64K5uU0hrxGA0qsqkmr3qejW77z+UBwjOQ55NLTBJhbxb+ZqHktDGWClxF
	N/eyBBJh64KVtJG0Bkawx9+e9yVj0dCdO79e7a2+J8sBHK7tQhPL1Z7/Z1vEZ9BC6ZRMfI
	vyo+OHa2sLb+4oO9tBagwYQPt7XnZR8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0ECAB4351C;
	Tue,  1 Sep 2026 17:24:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B451F000E9;
	Tue,  1 Sep 2026 17:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788283464;
	bh=FNtqw+4cMw2tiBTTuj3vqzwte2JlYbPEDqcQmayzdB4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LA5VUHH3CQRbq6TtG7uAOUnltv/nWwvN8V4834MNvXbYRxwSmTotOmWteii8UiQS5
	 QR4fRDprMmPj5OuZI0MppUEPQ57nQvrdsdqpstxXyjI1E00zLmnpLMN9UloL/ZT3FO
	 0XmliimdrLwMGlqsl+hZIsTW4GKZKZZ9EEBZc2x2c4GzLI/e4yKx5tOAffPk/J5ASP
	 x2ZLdYf9X9nf1oK3mVaEG8OLndn+E+5n+OfO8fLsoGCF3JHWDts5Pv/MKpgYoy/yPr
	 NZso7dD+ZtKvquJLdY3TsryJ/fkqf89H3HUSu6B8WDndLzqUjSBpq32qmt4O6UVQE/
	 43dW7Sls5S4Yw==
Date: Tue, 1 Sep 2026 20:24:16 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Eli Billauer <eli.billauer@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Brad Warrum <bwarrum@linux.ibm.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Michal Simek <michal.simek@amd.com>,
	Ritu Agarwal <rituagar@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 2/4] char: xillybus: replace __get_free_pages() with
 kmalloc()
Message-ID: <apcKQBRCFeF-usK7@kernel.org>
References: <20260830-char-misc-v1-0-05e2ce44f291@kernel.org>
 <20260830-char-misc-v1-2-05e2ce44f291@kernel.org>
 <f6001085-9234-4025-ff34-6cc4a66c293a@outbound.gmail.com>
 <apVmYXlqsVr_p4Oc@kernel.org>
 <7adfefaa-91c5-4bf4-ff98-5dfbba0eac96@outbound.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7adfefaa-91c5-4bf4-ff98-5dfbba0eac96@outbound.gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A868280009
X-Stat-Signature: s5jo48row8mpiyw9odpsg7hzkm7ig11a
X-Rspam-User: 
X-HE-Tag: 1788283466-218864
X-HE-Meta: U2FsdGVkX18unMgOXjrR9UloLqX7Aro1K8gR0TYWp0/TP0Kl/+dFX1LHIZ4/sczkyek43/ZANQe014pjwm+5r3ifP65tglmcoi+YC8i9pxknby1Bk0hTrtsaa/Umwh0TmIMAs2rZUxzAMSeSOcPwlsOvceWaW3ofwOxQz9VemC5+ki3naFeBmK0ERaTVoiQuoOEvVaxvc38Cd8mFAwoonIkcn3rnIiPVv2xhthfHxnv0uO4xBaC9OFjEtR7RXW5gNSS9WGZXiIaKdPz/4utCMF/cyqU6a+Yssk8vCcPPRI8MV4dTwhNnsr01p1kapMqPbXu2U/br9rNa8AUJSjN0tqpRbbZGefpLgmbx5p4Hj90tTo73kvhDQbdsUy+ma1R2jg/71kE1WotFIVvoJRN/0pYIlDHTETWtAMSwgbGSz5iJBnh4wMviscWydMFEy1ND0EWseyYRfc3258PtOW/5UvlgMyJgZBHdDPQillYMUUTPiFb+URh941m0q4FtUfABwOHcuPkhNH9sPMbza8vHuacYm76OFKZ9kN05tDGe5ifoAMlRASZwjF7NI4CSscIgdRWjueOWh9F/Rxe8CqDc7U7eP26Xicfaj+c7GSPt1SYO0JF2O5L0qbotXzNGAue58IzpYAU/TrkDY6vZ8nG3LzfQyHDvkBJe2bT/XkpjIEUsrq6WdMASCU+5/Uv2LhGUBuFMg+aEx20x8qL0OOlcTDWItQ7366i9KTGnriA6etLgpf6v4qTvzvKLw4GpygaZiIo5kbe/aPgcY4vkElPbjNmJceI9t2K+vyLfQI4hMU2/Cz1rGVyPOVRcE8oJiYZfcQ9niTr/2a8BLimA4nKlxl3mb6AyZb+3xYhrPkN3w02e+Qffb3wqWTFAvcXNmes7XtN9WH0XqZYDmWgp9O9f9LZupRbQXuV+iIX4Hr51oayowZnMemZ7+fPcYzYNLsMSEe9duzDvd8jD6ByJF9I
 uUZdyFvy
 cmJtdnS3zQ5XPUkx0cZLTgiW830bJpHWqYtc0yGtz2MUjv7QqFn0cZ5Gq1tZHDTe3ZNUOKKJRL/EmiIGZ5gB3pYgb0YEFnf1RGTLKgqZc3Z+Yjdn8cmkwwH7+qAFHq2Vakdtw+GjVU13x5/bR1p10geeX4kvJYbNdy5nG6NzOpZcyokL7/T9dfYpbAU7KNRpa81JAcPVc/wZ91NAATfiAHh280c6lFIsOeI3Xba4pErsOFU+M6NdYq19BzGYAOrwEceO8LMp+GsxGp83Xy8SBZQxQ2O+rTnJKo1+HnC8H4P1gfEQWsV6XdhDw84LuCbYOnov2xlOyPL4NIX2Jm9rTN217ZD0uQX0sLUetF2FO0R9xASzhFNTi7TLWnniiZS9U76lcgs749cfBQG01pE+1Op85Cw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 10:42:47AM +0200, Eli Billauer wrote:
> On 31/08/2026 13:32, Mike Rapoport wrote:
> > For large sizes kmalloc falls back to page allocator anyway.
> > 
> > And the doc is out of date unfortunately.
> 
> I think it would be a good idea to update the doc first, and by doing so
> officially change the API. After getting this change approved, it's indeed
> safe to rely on kmalloc() even for larger memory allocations.

The documentation always lags behind the code and "official" API is what
include/linux/slab.h says :)

When I wrote that document, SLAB and SLOB were still around and had
different properties than SLUB for larger allocations.

Still, the documentation update is on it's way upstream:
https://lore.kernel.org/linux-mm/20260831-docs-memalloc-guide-v1-0-547718c274c1@kernel.org/
 
> Regards,
>    Eli

-- 
Sincerely yours,
Mike.

