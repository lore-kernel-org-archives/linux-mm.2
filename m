Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38399C5CFDB
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 20:56:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C03686B015D; Wed, 12 Aug 2026 16:56:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB48E6B0168; Wed, 12 Aug 2026 16:56:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACB4B6B016A; Wed, 12 Aug 2026 16:56:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 84A056B015D
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 16:56:05 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DFB58C035A
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 20:56:04 +0000 (UTC)
X-FDA: 85093824648.12.6FA1EFC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id AC7CB10000E
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 20:56:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=sJuD0MeZ;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786568163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=82pZ7FBofPwXZDC19M5abl9obtJ4k7a/DClzoby56us=;
	b=XPZKUiZsw2E7RdD4nsux9AuK8+x47P8AgXui26A8GPIin3NqwmC57vuQYJu5zcmQ78CRJs
	G9ky0pBTVQIc0N4J96bEBFgdpTKwq5rxvHVcvrCj996v3cHT4og+LhvNGyjW4hYZ2m/Dy+
	MhNaNWefESj7ZXmVTmhWn7or3oHonNU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=sJuD0MeZ;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786568163;
	b=LY5tjnDp7lwFLG38kU8Kmi1hUbrPWkLhN7zJT+vZP4ZgwtSglWOzsIeW9HgUO7tuVjb3og
	jYKyKe+B7kETfb8LT5et8/MuTTDuyWnhvzP/6QhCdXxQr5x8Cz4/XgH5gSdNBS6m7fgV6w
	X4yHebZOZGoU4kxq7N5VpRVG/mHKdiE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E9E9E600AF;
	Wed, 12 Aug 2026 20:56:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 539091F00A3A;
	Wed, 12 Aug 2026 20:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786568161;
	bh=82pZ7FBofPwXZDC19M5abl9obtJ4k7a/DClzoby56us=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=sJuD0MeZV9Ay33iB8f9ooLxiB6V72jxWnkUS0PwKrbBOBARbX9W9XiG1cbk3b+v5N
	 M+XaVJTq7xWV7b0Xj8lcCCbw1RIWJfUhr4U1unpASod0BvTiaUUin4n5bxCh1qSDEX
	 m4zwXPqEOZjm0sH3N3aP9HcMdt6TwK0Wx40ySi+0=
Date: Wed, 12 Aug 2026 13:56:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Youngjun Park <youngjun.park@lge.com>
Cc: Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Kemeng
 Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, Jianyue Wu
 <wujianyue000@gmail.com>, her0gyugyu@gmail.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] mm, swap: keep hibernation swap slots out of the
 swap cache
Message-Id: <20260812135600.b486a8217c0bd1396f397693@linux-foundation.org>
In-Reply-To: <anxjcYKBMeAlgrBl@yjaykim-PowerEdge-T330>
References: <20260811132209.2862708-1-youngjun.park@lge.com>
	<20260811114622.6a04927b0c7ca0c2d6b39cce@linux-foundation.org>
	<anxjcYKBMeAlgrBl@yjaykim-PowerEdge-T330>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AC7CB10000E
X-Stat-Signature: p7o18146qd19qyws1zisaetfd71xme34
X-Rspam-User: 
X-HE-Tag: 1786568162-457981
X-HE-Meta: U2FsdGVkX19i8XPjsjWcwm+aqz7Q2KWR3ctvz8LfGRUaJ2hZqjRSc/uDPiK1nlGl4p3IgW3IGVgnmWpkatzwjCv+zBxoo0QdPOcv+MDsuGU2Iegz0SOw+qm0ZgvFp0mVvZ9oJnVOyujOfqcJiABxgKuDciMaSSE8xnQqQI9apU18gf+Buanc7vHcIkZ1qzSHFK/eBlbEDaMA3VvwiFs79N9f6VnzB3Lmt34QCxLgutPE4tuf2PzJAM65GwYiVHHJ8iHBQwB0fR5TX6nuHE+gEucTyz22bNAI7PPJIB+yCjl49gZmiZXPX0jznU0RDKpj0v5r3AfdCD2Rl+jTa6zj2Vx6HYV/JXOz0GHnPrioLkIX6FKhWeZ70bZaI0HNz94EyKCEH9MjbUeVv7gTIsQtDT3QkYDAPZfVbRSQDXKoQ1A3+w89BtCt1TgKcbxj/hLsNDQl6jEXJwVqJADTeLAKn1SVQlHeITHX5cutDnNpicdofQEuR9hQrO/Hptkb/oDfNn4JSg1WwL1//Cd/Lmx4d55ukfyZ/2A9e1mpnLz/D6jPl1vKtS9OPbFFbtzzXrpx1nWGG7PKQc4atjIJVie0EHs1XccLKE+k+M8XiSkaCkrSlBERwD79GJO8auyGuhRGTm8jhr5idTBaSOaT7Zl0r4cR62Zm9RQeIGofEy9mZl51zhhPnJEwAzc9bmmlePMbWzyVQQrcf+YvVoZjhLT8DB8HgBIackdYxaOogLOw1JOiLoTajMSHTWkboGxmSaRuxFohtscbNYemIX1/k7AkbUMsN96+0sdlf+22iLLZVgzYW3pDsLcestSDVriTK3WmsXYg3PoG2PkmBhJGWS0EV4IVS33hzVLHpgJJdpdNr9i29gZGunb4Z6lklEs6RxpV4DQwKvVMswJ9faVncjEndPn3kNasKodOKrs3422st6LmKRcthn4dYFE6JqYqSfZqadoWgoGhsZuNArVrYHi
 ei/lVPGv
 x4/z4u3hSkWrBsciWpmsrjJdBcWnPaA9t+TQsToS6sOsHCOnzcLO+nGZJtQ+npsc/hh3Uh0Xgp+Sb8raYeg7yLC/2mOi5fclRGXNF/wHzpKwmEa0JONAqqXlyoyDVvwdfZJV7bdPCbOnyE8OQGO4IvmmPw47el3X5DbJtEAErOPmLJ6ZtEIPDcs0z5XRqcOwiORyOnEtqU0h84gf2tdP6bDjUl4PfFQXzwm7zUrh3HLWoafn9ZhWsOcJI60wv2eB7VRxuA/Q7Q/zB+493nu6xh6rrvxCo039C8ycv1K1K6zvuSFd4CqwC9PF4SATWsqI5PsbdMnKmQWIxhMka+xhebXs1jUR+XB/eXizXFZXAToffNqAdm1xlX5HCM5ixOLCl00GfcGGBqBfjdlN43i4zKaJUSyIHJUE+oeMEIg30eYPkSVg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 12 Aug 2026 21:13:37 +0900 Youngjun Park <youngjun.park@lge.com> wrote:

> On Tue, Aug 11, 2026 at 11:46:22AM -0700, Andrew Morton wrote:
> > When fixing things, please always take care to describe the
> > userspace-visible runtime effects of the bug, particularly when
> > proposing a -stable backport.
> 
> Thank you for the advice and sorry for it.
> I will make sure future patches describe the userspace-visible effects clearly!

It's common, trust me ;)

> > For [1/4] Gemini tells me "At a high level, this bug triggers silent
> > memory corruption, process crashes, or data instability across
> > completely unrelated userspace applications - typically occurring after a
> > system resumes from hibernation (suspend-to-disk)." Which is what I
> > figured too.
> 
> That is right, with one small correction. this can happen with
> uswsusp while the hibernation image is being created, not at resume
> time. Memory corruption, process crashes, or data instability across
> completely unrelated userspace applications can occur there.

OK.

> > Do we have any reports of this?  Reported-by/Closes?
> 
> I found this while working on giving hibernation slots their own
> marker in the swap table, which I had discussed with Kairui.
> (https://lore.kernel.org/linux-mm/abp7aDgYLrxF3Me8@KASONG-MC4/)
> As far as I know there are no reports, so there is no Reported-by/Closes to
> add.

OK.

> > I'd like to grab [1/4] only, and defer the other three until 7.3-rc1.
> > This might be mistaken, but from a quick read, it's not clear what
> > benefit those three patches offer our users.
> 
> Simply put, they are close to cleanups that remove unneeded work.
> (with a some little optimization.)
> 
> Patch 2 keeps bad slots out of the swap cache, so readahead no
> longer wastes a folio on them.
> 
> Patch 3 keeps hibernation slots out of the swap cache, with the same
> effect. no wasted folio at readahead time.
> 
> Patch 4 removes dead code.

So I'll retain [1/4] with the below changelog.  Please plan on
sending out the other patches after 7.3-rc1.


From: Youngjun Park <youngjun.park@lge.com>
Subject: mm, swap: don't free a hibernation slot that is in the swap cache
Date: Tue, 11 Aug 2026 22:22:06 +0900

A slot with a folio in the swap cache is freed when the folio leaves the
cache, not when its count drops.  swap_put_entries_cluster() follows that
rule.  swap_free_hibernation_slot() does not, it calls
__swap_cluster_free_entries() whether or not a folio sits on the slot.

Cluster readahead can put one there.  It walks a raw page_cluster sized
window of offsets around the faulting entry, and a hibernation slot passes
__swap_cache_add_check() because it is not a folio and its count is not
zero.  Freeing the slot then clears the entry under that folio.

The folio is now unreachable from the swap table, and the offset goes back
to the allocator.  The folio is still on the LRU though, so reclaim can
pick it up later.  It then takes the old offset out of folio->swap and
overwrites the table entry there, which by then may belong to someone
else.

This bug can trigger silent memory corruption, process crashes, or data
instability across completely unrelated userspace applications - typically
occurring when uswsusp is preparing the hibernation image.

I found this while working on giving hibernation slots their own marker in
the swap table, which I had discussed with Kairui. 
(https://lore.kernel.org/linux-mm/abp7aDgYLrxF3Me8@KASONG-MC4/) As far as
I know there are no reports, so there is no Reported-by/Closes to add.

Check for a cached folio before freeing.  The slot is then left in the
ordinary state where only the swap cache holds it, and it is freed when
the folio leaves the cache, either through the reclaim below or through
normal reclaim later.

Link: https://lore.kernel.org/20260811132209.2862708-2-youngjun.park@lge.com
Fixes: 0d6af9bcf383 ("mm, swap: use the swap table to track the swap count")
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
Acked-by: Kairui Song <kasong@tencent.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swap-dont-free-a-hibernation-slot-that-is-in-the-swap-cache
+++ a/mm/swapfile.c
@@ -2196,7 +2196,14 @@ void swap_free_hibernation_slot(swp_entr
 
 	ci = swap_cluster_lock(si, offset);
 	__swap_cluster_put_entry(ci, offset % SWAPFILE_CLUSTER);
-	__swap_cluster_free_entries(si, ci, offset % SWAPFILE_CLUSTER, 1);
+	/*
+	 * A slot with a folio in the swap cache is freed when the folio
+	 * leaves the cache, the same rule swap_put_entries_cluster() follows.
+	 * Readahead can put a folio here, and freeing the slot now would
+	 * leave that folio with no entry behind it.
+	 */
+	if (!swp_tb_is_folio(__swap_table_get(ci, offset % SWAPFILE_CLUSTER)))
+		__swap_cluster_free_entries(si, ci, offset % SWAPFILE_CLUSTER, 1);
 	swap_cluster_unlock(ci);
 
 	/* In theory readahead might add it to the swap cache by accident */
_


