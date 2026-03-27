Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A54210ED645
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 09:48:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7B536B0098; Fri, 27 Mar 2026 05:48:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A086C6B0099; Fri, 27 Mar 2026 05:48:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DAF96B009D; Fri, 27 Mar 2026 05:48:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 69A446B0096
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 05:48:43 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 350671A0F7F
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:48:43 +0000 (UTC)
X-FDA: 84591368526.04.284B127
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4D829120004
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:48:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rtEZrHO2;
	spf=pass (imf29.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774604921;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W2jkZ7CKG1HEXEW/3WJEqugv9Hb29E2vs/Zn4NaEXJY=;
	b=0ZC9RnfAmRTa0Yr0aUTi3LAkDi1ZId8VL7lyRkT1ArFay7fOp2T2mowJiNZFJVURa8Wu6f
	faKM3SM/6hlsgaUT1AjIHYQRWgzZlLqYJBbHSlBdQI9mT/u2qGsC6sRZeHmyfymNqboH3s
	/sw0xqlaLUF2U7ubglLQxgIFS4bIVYk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rtEZrHO2;
	spf=pass (imf29.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774604921; a=rsa-sha256;
	cv=none;
	b=qbVeZgknKJjPrTwUVYucUS3AjML5zVZ9yWBhyKTd4A+4iI7udI+fpqhLq+0oG7cTH2NeZG
	ViGJ++/FcBQ4O+ayCqZBrmnLwDUcZ2YgWU/bYzteCEkGc5Y88bs2uhYPV+z+yq3d1kvgf9
	PRggweIiFN1piqdTsVQlDA2ni88b8UU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A9D7D61338;
	Fri, 27 Mar 2026 09:48:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7CB43C2BCB6;
	Fri, 27 Mar 2026 09:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774604920;
	bh=VAn5qbLsvUENIW/va6GuMZmrw3yUMFjIWRDfQx0oC18=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=rtEZrHO2SlFLOfw3fqO0+ywOHHW6vpglwQibetS+TFxd8N/FqQ2IOEmduenSBVq/I
	 7Q/TPqLOIFcpzLJI9QZ9VOakktLS6HT6CKgwAONPzB8fDyMz4+Y9ds/Jpy3E4lngk0
	 UyzClMeGYlAlfx44amUv91slA+w+rHumhv6WWynLn1+LM47ZycWs54wC215AwLqNQ0
	 vIYzT2gnVOkG497UQ3RkV1lLoA22cSmB7+QByGkh0qBD/884BCl8e+/9Ipqg6IWatI
	 awofZ7mPS3GA1xOfSOr1LPc7BmdvCG3y6qsP0z8KXtHLRnWxcRTg1Dh9epNd8SXmKB
	 uKR6qK1x2y5ag==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7155E10ED647;
	Fri, 27 Mar 2026 09:48:40 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Fri, 27 Mar 2026 15:18:41 +0530
Subject: [PATCH v8 5/6] mm/vmalloc: free unused pages on vrealloc() shrink
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260327-vmalloc-shrink-v8-5-cc6b57059ed7@zohomail.in>
References: <20260327-vmalloc-shrink-v8-0-cc6b57059ed7@zohomail.in>
In-Reply-To: <20260327-vmalloc-shrink-v8-0-cc6b57059ed7@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774604917; l=4140;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=yGSj5LIL6EaRfv6ZvzI9tnknpwNqR3EakaaeUvTgq0c=;
 b=yVF907VkAdaIM4lQvlpR88OTp+REg4u+jdY88y3PxpHAqm6Bz3MM0KyTpgnQwxXaWM1Ung3gd
 wuG0msrMscMDV1Owh6S2AakGeW6x5cnTOOdhyjOEnNbxd1L2FcwiDJD
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspam-User: 
X-Stat-Signature: utmm38r9tynkp5ndfrjqe49gy9nqko5k
X-Rspamd-Queue-Id: 4D829120004
X-Rspamd-Server: rspam09
X-HE-Tag: 1774604921-789058
X-HE-Meta: U2FsdGVkX1+G+CKwXxGFl+qZFVnyw4z7vWBXPj9/bh/no+3nKD6CEf5qi4gdL268ESz79nCDoZgpi5HW2KIhCVXAv43KX5Q9Y392EhCI1Y4eeh7aZr4pQdwsq3b1fngoQ0KKhIqnMLHh5kasuqliLvuL4sGscyMy8CVIThDY8aOQMY26xIotESZNO/5y4B8h/Md7a7TolgT6XerjlroiToUHVmWyzww50RMmEA1uU4k4dXqzDmCw50BbSv08IVFVm8I2boZNccGHEIX//lD7lkuBlQZoHwpnmkRNdFIVHWa/aYsOiuTwlRfQpE8WvExbt6dSWYtNHez8vH3/wA+53vHZRQACBJY2IEJVUqpY5l2zJbocZ6c33aZBZId5zdb3Zu0lbObt2vmGpFwxz+fhcaQHiV1VxKa04wQA98yiZupRXNhnoxuRSLTuUOObqYOvH7acc4KJsDTeBLRvGlBA2QhZKhuMNSnrYV+aT0nM1wspDjYr4lcBU5f3/dgtoyglRszIp7KpBkIH9IygbTmE2bMT8khNnanhw6yic78s0G6m38cmr2CPuWTRpXV2OR4LEFqkEcQPGdIfWJ7+GBp3XQGNn062NSn+dXbCh52ldASIfV7DHFXGV5aCGomm2WZbRKEh00ww0UZEop/LlVn5O4hQLTGzmcwT9lcxcOw028OiTJoaNdDbNlrvICa0yWCncikkenMA3aDU/IAgAjp6a42HY3LsAa+EcFxBYbTkJLFSBk7akTo/pPkLjKbeuleBy+S/3rC+lgqLHv6OOiYIgcaZMXeYfmNMI7gCgQENhlyIc52CURWXwaj0gSnynFpF4Tzz8mZjzzs4FSkuYOzPyIiTaD6moQRNAKk6jV5n3eacnTfpb9F7OIZ56xnT11jzX3ThGGixepEL1SQIV77H83/qdke62Kl1OE8o+sv7of7JRMM7ejAeWrlfnN9ZXAD+DmlMW6g1AFz9Eu3nXga
 wX8FXuPH
 yhLtbuixU2UmM93xVHJ4itntmJ2a7Gx2T5sAjs8EQnUHEZCPJCrgumI9mJ2+5EQ1ZiizlI9e9LQp4YxYWfYqNPXTVI+ufVgshVpZnB0DldsWSLIK/zxWf1uasMkb1To1tkRiKxVZ/XIikvuZDNT+zz2Es4FnrN4hn3bUYa8LXO/UJW7YCyzoKxIGwtq9lU8Q3sPRqVjUvDLDhV9cnf7fwbpbX26JuOmHZq/S5gsS+kvpAFuGKndy4/5MSGTANr4xiR/RzhLUzHHV/1gX2hwa5cQXrp3ds7NZgqEYIBxWDpatA6HdZdBOhzgXgg3aGpruhq5eWVZIWLnAGgKXXGVGCK+frPFsppHO0rAo0Xy7PPzSCUzT2uicCiYLgn1okjosNtWqK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shivam Kalra <shivamkalra98@zohomail.in>

When vrealloc() shrinks an allocation and the new size crosses a page
boundary, unmap and free the tail pages that are no longer needed. This
reclaims physical memory that was previously wasted for the lifetime
of the allocation.

The heuristic is simple: always free when at least one full page becomes
unused. Huge page allocations (page_order > 0) are skipped, as partial
freeing would require splitting. Allocations with VM_FLUSH_RESET_PERMS
are also skipped, as their direct-map permissions must be reset before
pages are returned to the page allocator, which is handled by
vm_reset_perms() during vfree().

Additionally, allocations with VM_USERMAP are skipped because
remap_vmalloc_range_partial() validates mapping requests against the
unchanged vm->size; freeing tail pages would cause vmalloc_to_page()
to return NULL for the unmapped range.

To protect concurrent readers, the shrink path uses Node lock to
synchronize before freeing the pages.

Finally, we notify kmemleak of the reduced allocation size using
kmemleak_free_part() to prevent the kmemleak scanner from faulting on
the newly unmapped virtual addresses.

The virtual address reservation (vm->size / vmap_area) is intentionally
kept unchanged, preserving the address for potential future grow-in-place
support.

Suggested-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
 mm/vmalloc.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 52 insertions(+), 4 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index c6bdddee6266..57aec552e038 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4351,14 +4351,62 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 		goto need_realloc;
 	}
 
-	/*
-	 * TODO: Shrink the vm_area, i.e. unmap and free unused pages. What
-	 * would be a good heuristic for when to shrink the vm_area?
-	 */
 	if (size <= old_size) {
+		unsigned int new_nr_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
+
 		/* Zero out "freed" memory, potentially for future realloc. */
 		if (want_init_on_free() || want_init_on_alloc(flags))
 			memset((void *)p + size, 0, old_size - size);
+
+		/*
+		 * Free tail pages when shrink crosses a page boundary.
+		 *
+		 * Skip huge page allocations (page_order > 0) as partial
+		 * freeing would require splitting.
+		 *
+		 * Skip VM_FLUSH_RESET_PERMS, as direct-map permissions must
+		 * be reset before pages are returned to the allocator.
+		 *
+		 * Skip VM_USERMAP, as remap_vmalloc_range_partial() validates
+		 * mapping requests against the unchanged vm->size; freeing
+		 * tail pages would cause vmalloc_to_page() to return NULL for
+		 * the unmapped range.
+		 *
+		 * Skip if either GFP_NOFS or GFP_NOIO are used.
+		 * kmemleak_free_part() internally allocates with
+		 * GFP_KERNEL, which could trigger a recursive deadlock
+		 * if we are under filesystem or I/O reclaim.
+		 */
+		if (new_nr_pages < vm->nr_pages && !vm_area_page_order(vm) &&
+		    !(vm->flags & (VM_FLUSH_RESET_PERMS | VM_USERMAP)) &&
+		    gfp_has_io_fs(flags)) {
+			unsigned long addr = (unsigned long)kasan_reset_tag(p);
+			unsigned int old_nr_pages = vm->nr_pages;
+
+			/* Notify kmemleak of the reduced allocation size before unmapping. */
+			kmemleak_free_part(
+				(void *)addr + ((unsigned long)new_nr_pages
+						<< PAGE_SHIFT),
+				(unsigned long)(old_nr_pages - new_nr_pages)
+					<< PAGE_SHIFT);
+
+			vunmap_range(addr + ((unsigned long)new_nr_pages
+					     << PAGE_SHIFT),
+				     addr + ((unsigned long)old_nr_pages
+					     << PAGE_SHIFT));
+
+			/*
+			 * Use the node lock to synchronize with concurrent
+			 * readers (vmalloc_info_show).
+			 */
+			struct vmap_node *vn = addr_to_node(addr);
+
+			spin_lock(&vn->busy.lock);
+			WRITE_ONCE(vm->nr_pages, new_nr_pages);
+			spin_unlock(&vn->busy.lock);
+
+			vm_area_free_pages(vm, new_nr_pages, old_nr_pages);
+		}
 		vm->requested_size = size;
 		kasan_vrealloc(p, old_size, size);
 		return (void *)p;

-- 
2.43.0



