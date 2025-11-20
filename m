Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CC76CF8548
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 07:13:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79B9E6B0029; Thu, 20 Nov 2025 02:13:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 773C26B002D; Thu, 20 Nov 2025 02:13:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B0D16B002F; Thu, 20 Nov 2025 02:13:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 59C2C6B0029
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 02:13:30 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 08F9B4EBA2
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:13:30 +0000 (UTC)
X-FDA: 84130119780.11.9AEAE43
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf05.hostedemail.com (Postfix) with ESMTP id A8CB310000F
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:13:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf05.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763622808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XyLewB9RXDZzvpsB5byQTtrR8XxEN8PIaHRcBBAsRkE=;
	b=e8QNCaEITuQDr7qOjFDW5ZiEQus859L4chttB33S2G8J58I9hmBad1lt/bppU8N+f4DGua
	KOkw6Hzhno0006riRkkEsovDv55GlAmT/2B9nXPz/vx/O43k5oJXDerEFS+SBJI9khNVWg
	smD/gb0Epk+6XZjutZU6HanUCKg5tBU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763622808; a=rsa-sha256;
	cv=none;
	b=aIThaU9KzSbiivQ2L9c6kVcTbAR8Ut/6KrZ7XK7nUJe+pgA20/yw30MpHY1E8IPQ0RcUgz
	xnMAAp3kkLSLLm7MH/XV1dB9Dp9HjaDReFwZjV6klruza7xSdkqed8tN4g0ko1XPOu98sX
	oYRWGFJJHv68OoCiZPJyA1TByC9THNY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf05.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 20 Nov 2025 16:13:24 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 20 Nov 2025 16:13:24 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
	Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH v2 10/19] mm, swap: consolidate cluster reclaim and check
 logic
Message-ID: <aR6/lN6fWi9qQD8J@yjaykim-PowerEdge-T330>
References: <20251117-swap-table-p2-v2-0-37730e6ea6d5@tencent.com>
 <20251117-swap-table-p2-v2-10-37730e6ea6d5@tencent.com>
 <aR6/Kc0kag8Z9y6y@yjaykim-PowerEdge-T330>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aR6/Kc0kag8Z9y6y@yjaykim-PowerEdge-T330>
X-Stat-Signature: fgj7519haxtqbjidd7r3h65gd1w5f4ek
X-Rspam-User: 
X-Rspamd-Queue-Id: A8CB310000F
X-Rspamd-Server: rspam10
X-HE-Tag: 1763622807-185169
X-HE-Meta: U2FsdGVkX18PVuUUJVeOi0aBIl1Jf5mSuNpR4qpCDytX1gbPcVbd/v2l7D/4gLcFADynffccXa6vhLz7W8fgRQV36MJTc9pa3zFTg77vN2hWU2jt0AuedTintWrauWNYeywX06zFQg4AUoTHvawXwixT8ilW+1WwOo+tqAcDwseuPGpyc20+WIzmM3Md1FMvUoYDkJuzu66x06wA6VMMcel2IzfGcAjzJ2YZmRJ4UbgtTxIszyUbVpVK6LCUwiSrCYjhPgUwa7QcvqiYslVYl5kvD/TElioZdZXcrQ43q0kYd/MtCrmnSsiwZydNvVma85epY0grM4sb115IPrMgq3KSZTeLhSWiOCwKR8Kcr/5vnhvLzc4r+zUFXqImxgnOnKQYtBIaFDlUr8joubxhjBurL9RF5P5jPvslp7oVIrjbozjbEI5WrRaGRWk3e0HyQBEfQB0vnVoqRWb9jt1oi1BONL+WYD1INljNyNkcBtMYuWnIqvCLo3vY/nf2pu3qLkH7rc4DeSPT2Xh1aftE8xkPMG56sUUC1k78H6gBE+QaUZmVQ9wouqt1ayoueITtQ4EnJ3HUMnx/BFr8YcB8c73oR1C0FV1ehzR0YtQPxek9SlCMWBP1zGLRpJEjEboZ7v97ZMRUW3uddtG1Hq0VAQoWueObInCjkN6lmiS1Qdj498fpCq00B/5xUOXCfP2MCbC2f3/veASwZrcCKmDZqMvP9pHert+fi794gjuSnMyOteDEu2H6+n43QHe8RYTFhNkR7saEZXhyjru+FD9YPVUtIamuhcODginZroXQxuKplvxYnLwPPVZyoEgjVZTr7OHASt6iPGm5MPgVnekkrCb46TQ8E3rjcnA3n04l5HtPi8/2wE0OOg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 04:11:37PM +0900, YoungJun Park wrote:
> I found the just very Nit comment cleanup.
> 
> In swap_cache_add_folio() comment, it mentions "SWAP_HAS_CACHE bit
> to avoid race or conflict." Also shouldn't the comments that reference
> HAS_CACHE(the word, swapfile.c) be updated accordingly?
> 
> Youngjun Park

I added reply on wrong patchset, Sorry.

The comment is for 
[PATCH v2 18/19] mm, swap: drop the SWAP_HAS_CACHE flag 

Thanks
Youngjun Park

