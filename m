Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EC9DC5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 13:23:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25B1B6B0099; Tue, 11 Aug 2026 09:23:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20ABA6B009B; Tue, 11 Aug 2026 09:23:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1215C6B009D; Tue, 11 Aug 2026 09:23:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E71746B0099
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:23:50 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 79538C03F1
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:23:50 +0000 (UTC)
X-FDA: 85089056220.21.1A651A7
Received: from lgeamrelo12.lge.com (lgeamrelo12.lge.com [156.147.23.52])
	by imf18.hostedemail.com (Postfix) with ESMTP id F37781C0005
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:23:47 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.52 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786454628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UKxRuo4pSeC7LqpuXp3BDVPoTGQXRVqbUCb3RMfEnRQ=;
	b=vpmsXQn8kci41KmTZFIy/0iUWrL/u79ZLk8t/Tu4RXkFX4AEUXQCYgTgr/v9WIyExveBrX
	oaLvbTod+gpmuWMaPYqddLakKsgezWEAoNSDlVmNoUOrxgOJtudYCqoB9xLqGdZzuIoWdT
	5iU69ARkV/PC+ow+vmcmRKjEXVjIQ2A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786454628;
	b=1FmSugB1BUVwBcKYOM1N2EcmVt3AOs6Jy49eM0902n8/A6VAr2vGNAiBSnE3gQE+84Bw8s
	Gh3ddNbJS1Lw5UvDdtE3zCwclAoJXClFqnjYtBbeivwnK1pwT5f9yTlzQ3ww+RwqsqqAqH
	FY7RjT4hIwAxJdAuqkBFhaCVsuJifDY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.52 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO lgemrelse6q.lge.com) (156.147.1.121)
	by 156.147.23.52 with ESMTP; 11 Aug 2026 22:23:45 +0900
X-Original-SENDERIP: 156.147.1.121
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.1.121 with ESMTP; 11 Aug 2026 22:23:45 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Tue, 11 Aug 2026 22:23:45 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>, Jianyue Wu <wujianyue000@gmail.com>,
	her0gyugyu@gmail.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] mm, swap: keep hibernation swap slots out of the
 swap cache
Message-ID: <ansiYRpljHxWMtiQ@yjaykim-PowerEdge-T330>
References: <20260809144559.2104856-1-youngjun.park@lge.com>
 <20260810151642.871c9b5d9cd56f6efd45ff90@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810151642.871c9b5d9cd56f6efd45ff90@linux-foundation.org>
X-Rspamd-Queue-Id: F37781C0005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: yyrxepm8aaqgy6tt9gyurxqhf86scw74
X-HE-Tag: 1786454627-149872
X-HE-Meta: U2FsdGVkX1+cPJ2v6/E5wKoxTCWpR8h+dtqxQCankQiMtj5v5XHYwSmUs5BFmribhdOpUBPFRa/rA3tP+ivrNQYhjB5zvZvGBNEKKHDJRPCBDr0zOHvmIq1mVKHEwzOBJ75fUop9nO8FhoeMtRUh555mzaG7XEcHXyxDG7bQ2HzAN+TWYPuq3BycfTFmUbJgSW3serMHkABMVk1GuAFNi6TZg4fPTnnPrNFXP25SOE7Jq0x7tdqmnK8TLz1L/ERQYs1cnmiQS6sjxfQv4B+z0HsEZ9n6OFsuULezYZdnBq44j+oH+TNk+k+XbFxAyA4kLBSXIVH5BN+LdbEx2HoeIwlIAIyYrfcclcb6H3Gf9D2FPF6B2L7KsRxrC1O1OiHRxwhdEu2GSSfI2SiMyToD6QBEUky6SLHEHS0xbseeqeFaXykQqrtZRsFGvSBY1okmQ2PsgBabUXCr6He3akR5P7mTGy2CQZcE0kk2b+hma0fp7dT3fHjEfDLK6vp0nCXz/w/SDAG0K87RLx9qBVhLv0b/usUg69Q4g8SYEbetwpkSLbTGMoyYe1dJ8BhARwNVKDAmykVy/zQ5Q4Y8aPD/ZbAy1NsFc4Yuas4+a1RmLom/veLVY7Y5Z9OwFFNwl6HX+tGpGZdbf429UTEEPu63F9He3jOoGyQgsjgniCcvlmpY9ZRA0+Mxtvb4fkkzg8sVSDxLmBW4VY/VYjy6TKzGbiOnL6sMSwsU9fTNhRD05Xu/zwWB+DHB3lxCSYj8AyQFbyufG3Z15OPH18fsmedE8f67N1vnNO0gO3ZlbE+qDJyUXeQ42qBlEvYc+6GdICB0aaP5xXUNRd7vq9uGmq9nUtjr9BOnC6aAhiI6pu2HrwGFpATmhPqOCnN8W4bTJkf0ccJqh4b2JdnbtJwcKYfPxR0MVC3eDvqDpEQffAMftHiCSlPyBftE2X9xvMmx0LFF3kQm4V6SfVzC/84o7YW
 WAtmP8LO
 mSFXnCZP78cYQjrdVZ+iKukUq/a5ELH3MvMspiiv4Pdc1ilHOD2/zXZXxlLcQ9z+HWm5TZRIW59YvgqaJRVQ7XR5Y3isz0cPItKKgZYp3sveAaRtrov098EChDk3x4ATjk0FdMgLjSVXybMdO3IcXzkroaUj+6swa2hkIfi7Ev5O4iS6DB3T3NQT5CtdaBiSM1k/HLglFTlWRaehZ0WwO1JyWJsM8ZDLdJBZglIUsgkxGp14ztveIZWkalwM/1Uldh5z8BjpEXz+EV48=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 03:16:42PM -0700, Andrew Morton wrote:
> On Sun,  9 Aug 2026 23:45:55 +0900 Youngjun Park <youngjun.park@lge.com> wrote:
> 
> > Cluster readahead walks a raw page_cluster sized window of offsets around
> > the faulting entry.  A hibernation slot looks like an ordinary swapped out
> > slot, so __swap_cache_add_check() lets it in.  Readahead reads the offset
> > off the device into a folio and puts that folio in the swap table where the
> > hibernation entry was.  This has been possible for a long time.  It only
> > wasted a folio and a read.
> > 
> > That changed with commit 0d6af9bcf383 ("mm, swap: use the swap table to
> > track the swap count").  A slot with a folio in the swap cache should only
> > be freed when the folio leaves the cache.  swap_put_entries_cluster() still
> > does that, but the conversion left swap_free_hibernation_slot() freeing the
> > slot either way.  Nothing points at the folio after that, and when reclaim
> > drops it later, it writes to the table entry at the old offset, which
> > someone else may own by then.
> > 
> > Patch 1 is the fix and the only patch for stable.  It puts the missing
> > check back, so both free paths behave the same again.
> > 
> > The rest removes the cause.  Readahead should not touch these slots at all,
> > so patch 2 lets only swapped out slots into the swap cache, which also puts
> > back a bad slot check the swap cache rework dropped, patch 3 gives
> > hibernation slots their own swap table entry type so that check covers them
> > too, and patch 4 drops the guard and the reclaim, since no such folio can
> > exist any more.
> 
> Thanks.  It's late and review is only partial.  I'd prefer to wait
> until after 7.3-rc1 to process this series.
> 
> AI review suggests that more such fixing is needed in
> __swap_cache_add_check():
> 	https://sashiko.dev/#/patchset/20260809144559.2104856-1-youngjun.park@lge.com

False positive. But, more fix needed by different reason.

The walk the AI review points at is the large folio swapin path, where
swapin pulls the neighboring slots in together with the faulting one.  A
bad slot cannot show up there.  The range comes from present swap
entries in the page table or the shmem mapping, so every slot in it was
handed out by the allocator, and bad slots never are.

The spot is still worth fixing.  The range is not pinned between the
locked check and the locked recheck, a concurrent free can empty a slot
in it, and hibernation can claim the emptied slot from the allocator.
The raw count read in the walk then trips the countable assertion under
DEBUG_VM, even though the -EBUSY fallback handles the changed range
fine.

I sent v3 with the shadow requirement of patch 2 extended to that routine.

Thanks!
Youngjun

