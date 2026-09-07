Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A748BC79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 12:43:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A95236B009B; Mon,  7 Sep 2026 08:43:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A45EF6B009E; Mon,  7 Sep 2026 08:43:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 983F46B009F; Mon,  7 Sep 2026 08:43:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7AE706B009B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:43:54 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 182F2160150
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:43:54 +0000 (UTC)
X-FDA: 85186933188.13.0BB1EBC
Received: from mta1.migadu.com (out-201.mta1.migadu.com [95.215.58.201])
	by imf22.hostedemail.com (Postfix) with ESMTP id 678B5C0008
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:43:50 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uZ8LOHW1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.201 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788785032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=itAebKJ8+btJYYB4R/X99UsKejgANSJEmmv0OeYDmQE=;
	b=L4f5WqEKo7xK6wQJnjD/YlmVhH0useZspUDIpLUZ1dbOCdtuENLk3XapRZH3DWm6CUZLR3
	rQWLyhyQDmn8vu4Ho32AFhbEgSSCNmz4RqJQBHH3q0aynn9vD81OuRCHsnoXnIJ/7O0sqY
	y9J2BLCd6q0E4s7rrzBzuiOhQqmdZgc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uZ8LOHW1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.201 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788785032;
	b=PCUbMIp+GuLXN5znKDT4ngIz5BVfE/+Pb/bpOKK2yQ+ADNojfKI+PwqZWSbGTKOkBUftqW
	dHVMH0kSBAWk99UGUCngOkbch93MwT86NdON5I6uP4aPJzVUeBu7X0TpQOADrHckNdLZIf
	rboS41fDbq9BiJQOj7MJwzxhe0tUQjs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=JTPAy2jan+rYgiarymBDIzjQvPOSEW75t+/yX0tY7gI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788785029; v=1; x=1789389829;
 b=uZ8LOHW13rVsRDybKgeHk+rQA7icJ+fAZU/1WkpY9HE5ii5kMWveNdLZBmndyZHrplGBl4Pp
 5NPlX9kiR5qmCXDDd2lgmJK9xL8+zHWe5ENKaO0Y3E9nLNtDbBqhjRYdjwHzAMwxZdKKuFhLc48
 RIZl81RME5DT78z9eamH59Js=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id bc25794ece1f1b64;
	Mon, 07 Sep 2026 12:43:48 +0000
X-Mizu-Trace-ID: bc25794ece1f1b64
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: tujinjiang@huawei.com
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	minchan.kim@gmail.com,
	lwoodman@redhat.com,
	kamezawa.hiroyu@jp.fujitsu.com,
	mel@csn.ul.ie,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	sunnanyong@huawei.com
Subject: Re: [PATCH] mm/rmap: fix missing barrier between anon_vma init and vma->anon_vma publish
Date: Mon,  7 Sep 2026 20:43:41 +0800
Message-Id: <20260907124341.81999-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260905061820.642437-1-tujinjiang@huawei.com>
References: <20260905061820.642437-1-tujinjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: tk53c61z44n4t3per1n9szpdsc7dsndy
X-Rspamd-Queue-Id: 678B5C0008
X-HE-Tag: 1788785030-298224
X-HE-Meta: U2FsdGVkX1/VvCFHRdPMZYpJLad9803r6jHoeOIL1EA3nZmN7t+GNgGMW1DEPrSaM2jPz99iqgR0pULfh8/6XWZ0lsMoeYub4yg5/7B9pxVFpNyPrP8yvN6egiosnZ2OipFMYjkMf0FOyy/lUTH40/mxUhHzLPd8eUviRmJtKUUHaSOD6SR//iAbKU9sJbJVDrsFFsmrvyLupcbiwNP5LgMsBF0AQGsd8iwmxNEzKgj85doTV+rkSR7hiYDTBJb0xTQRFBoQ+hCYSA8sOwFfuLz1BK97hymVzzjKkq/hPob7VeusvoRX1isE8jDJs51gFo9pF3tM/p7pkc+Pijtx5OS2tCyGsEO5GyKwL4OTAwEA+uQNPcFjdBhmZjp0gmiFaP3ke/QgLBqLCxiyJtKMa912+XRBCACTOSL3iWox/3JewS4LYO56250GcvZuWy6BshBlDDbve8R0HqrADktjDUMxHG+TLQPNJ2oM7shqdBqzFobPFH7km7fozUuDRex0tTzPFf2jQESXM0CxsQFqavTbb33bAeUu+g912XACo3XaUR3CLLAEhFDVYWIDSefDJOImBckgeX0P7i0H/mhc5eqyN4ny5lNX8EAaryDnyeTGe0L00nY4M3hc+h9RuDifiVETyAPr6DheQJ1W/EpBcns8rcfEpTdwRRcWWgOpFbpEHbhbTmzjpE9mBwquhqFjGelU7iu53LpsR5GacmVoIbHJsNRuWxEcFK7f/sKSplfIuFzPpW48dwgn21mP4lONX++wyOVQF37PjRTA2DVB7i2bGAiWXd2T6mWgoYDydZhrRUcgR6Mglo2y3+NFJF8Lh/rNUUS46SpkEYFBXh+Lw8kmi+aWHuth8i+i9jGmJemSS7k8hd9ro4RJ86KCGyFs09cHrSwc+vJBK1aGb//8wTsHocQub0hTqaU621tTpHbs/NPnsPA2yb8d5rvQXsT7BB9PMiU2nZUEYc1Uewm
 zIQzkaxN
 5qQmV1cGcbDNVL9Rf/eTCtWBE6ZWN/evL4yiCsv4LxzgljdKN30grMpgF/NCH9vqApepf7vXGYldcyDrcDAPedp1blQMUgFkYIGnlizAdn1bwnamnr6NuwxOwzVZiln1gZD9+MSDu0TP+o86fk42tnsnBJHWSmzqN5xfsp0SUJ8TRC+WKRZeihiQIixIMfrVa2d4/thHsctKFkzF+NOL6oYHqzVPFxSnfJFt6qJ3QGJomkuAUGchEj0YFvrZm+oKsvh+20YGXOGno4y+9hH/Ag3rFwoeiEqR7ZV183FeO6/w0mpDxj5voupqImWWUyJ4Wg0W4gkTMkpJb5cr7Igmo1QuHaIi78yK3v1SBA5AVgy6T9gdYQtT4MK8oxE/CicM5OXghsRXHHsD9IN48Qq+M6thLSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Sat, Sep 05, 2026 at 02:18:19PM +0800, Jinjiang Tu wrote:
>On arm64 server, we found  __anon_vma_prepare() reuses anon_vma and
>anon_vma->root is stale due to missing memory barrier, leading to
>lock and unlock two different anon_vma->root, thus leading to a anon_vma
>will never be unlocked, and another anon_vma couldn't be locked anymore.
>
>The race is as follows:
>
>    THREAD A                             THREAD B
>__anon_vma_prepare                __anon_vma_prepare
> anon_vma = anon_vma_alloc();
> // writes may out of order here
> vma->anon_vma = anon_vma;
>                                   anon_vma = find_mergeable_anon_vma(vma);
>                                   anon_vma_lock_write(anon_vma);
>                                     // may still see the old root
>                                     down_write(&anon_vma->root->rwsem);
>                                   anon_vma_unlock_write(anon_vma);
>                                     // see the new root, never unlock old
>                                     up_write(&anon_vma->root->rwsem);
>
>thread A triggers page fault and calls __anon_vma_prepare() to prepare
>anon_vma for the faulting vma. __anon_vma_prepare() allocates and
>initializes a new anon_vma, and then publishes it to the vma with a plain
>store. anon_vma_prepare() only requires the mmap_lock to be held for
>reading, so two threads can fault on adjacent VMAs at the same time. While
>thread A publishes a new anon_vma, thread B could finds the anon_vma via
>find_mergeable_anon_vma() and then locks anon_vma->root->rwsem.
>
>However, due to missing barrier, thread B can observe the published pointer
>but a stale anon_vma->root because the stores from anon_vma_alloc() aren't
>yet visible. What's the value of the stale anon_vma->root? __put_anon_vma()
>doesn't clear anon_vma->root, so the root of the new allocated anon_vma
>may point to a valid anon_vma.
>
>As a result, thread B can call anon_vma_lock_write() with the old root,
>and call anon_vma_unlock_write() with the new root, leading to a anon_vma
>will never be unlocked, and another anon_vma couldn't be locked anymore
>(it's count is dropped from 0 to -1 due to wrong unlock).
>
>To fix it, change the plain store `vma->anon_vma = anon_vma` to store
>release, so that the fields of anon_vma are visible before anon_vma is
>published to vma->anon_vma.
>
>We don't need a read barrier at read side for thread B. The load of
>anon_vma and anon_vma->root have address-dependency. According to
>Documentation/memory-barriers.txt and some investigations, only Alpha
>needs address-dependency barriers and it has been handled by READ_ONCE().
>
>This issue needs two adjacent VMAs aren't merged but are compatible for
>anon_vma. We reproduced this issue in v5.10 with KSM enabled. The kernel
>doesn't merge commit cf7e7a3503df ("mm: prevent KSM from breaking VMA
>merging for new VMAs"), so there are many adjacent VMAs that aren't merged
>but are compatible for anon_vma.
>
>Without this fix, our production environment could reproduce this issue
>about 2-5 times each month. After adding a smp_mb() before
>anon_vma_lock_write(anon_vma) in __anon_vma_prepare(), which is different
>to this patch, this issue hasn't be reproduced for one month.

Good catch, thanks!

>Cc: stable@vger.kernel.org
>Fixes: 5c341ee1dfc8 ("mm: track the root (oldest) anon_vma")

Shouldn't the tag point to the following ?

Fixes: 012f18004da3 ("mm: always lock the root (oldest) anon_vma")

5c341ee1dfc8 introduced anon_vma->root, but 012f18004da3 made the lock
helpers dereference it. Before that, anon_vma_lock() used anon_vma->lock
directly, so a stale root could not cause this lock/unlock mismatch.

>Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
>---

Hmm ... no luck reproducing this locally ... Still, AFAICT the race is
real.

For the read side, no extra barrier needed because the anon_vma->root
dereference is address-dependent on the READ_ONCE() load, IIUC :)

> mm/rmap.c | 6 +++++-
> 1 file changed, 5 insertions(+), 1 deletion(-)
>
>diff --git a/mm/rmap.c b/mm/rmap.c
>index d1819fd69938..a868e835eadb 100644
>--- a/mm/rmap.c
>+++ b/mm/rmap.c
>@@ -209,7 +209,11 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
> 	/* page_table_lock to protect against threads */
> 	spin_lock(&mm->page_table_lock);
> 	if (likely(!vma->anon_vma)) {
>-		vma->anon_vma = anon_vma;
>+		/*
>+		 * The fields of anon_vma must be visible before anon_vma
>+		 * is published to vma->anon_vma.
>+		 */

Maybe be more specific:

/*
 * Publish anon_vma only after ->root is visible, otherwise a
 * concurrent fault may dereference a stale ->root when taking
 * the rwsem.
 */

Otherwise, LGTM.

Reviewed-by: Lance Yang <lance.yang@linux.dev>

Cheers, Lance

