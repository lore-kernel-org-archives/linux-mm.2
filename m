Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 414FDEC01BE
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 10:34:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFC3A6B0089; Mon, 23 Mar 2026 06:34:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD42A6B008A; Mon, 23 Mar 2026 06:34:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A11DC6B008C; Mon, 23 Mar 2026 06:34:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 922F26B0089
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 06:34:37 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3C8581B9088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:34:37 +0000 (UTC)
X-FDA: 84576968994.22.1DEACDE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 93DB1180012
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:34:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=KVYos2+4;
	spf=pass (imf24.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774262075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=XwBOtPKW9u4P8r+OmtwZSyYDWfJNDQQ+la2B/wPTfh0=;
	b=eZYGBhLJD5m2x1OGRP8JCY55FTocalX1JIu7Dj7FP1MdY7sAS96GsCgZ34AbTn6NdbIxTU
	JK4uRKPKgnE3JuMY6PfkM/QSumY12YmQXaCYNJ8Y9N3njgj32wWlDB7jymxUehgACusD/I
	kJwkVWbBLYrABPJ8DBAclFbHCl+pX14=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=KVYos2+4;
	spf=pass (imf24.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774262075; a=rsa-sha256;
	cv=none;
	b=PXhpwfgSav9bfS9zNmsaFgGzKm8lK4/NwqJAU8l+zcHve82rFXq3ZZ1uwXPpCB61Ns+Qiq
	LnX+NgISpKtOWevAKwAxmmp6WHDHpOGYnxSDfDSRGjyvLcD9Kww+TyyhSMPJi8/9ljRMea
	ZPTjee1yC7MSxxyMbG2Av/SRnBXmxzw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F14A8600AC;
	Mon, 23 Mar 2026 10:34:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5121CC4CEF7;
	Mon, 23 Mar 2026 10:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774262074;
	bh=cUr3AhjnSYQ0VvNDJY5eOJglbIxgBybnBRJLi93r7ns=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=KVYos2+48K5lzl7P4GOS0MUFAysfJeg/GUnDsZdqJzVr0ZcEbLPg76bQtgDaywskR
	 YT1SVZflNIot/sxi9leFt4q10l4L5ZJQKGYryjWQfLdCYCL3AJyGQ1bcwK9ScJUd1P
	 WNUpdIaIIU9dfbHgWszE73ugCqchACM1nc/CKS0k=
Subject: Patch "mm: shmem: fix potential data corruption during shmem swapin" has been added to the 6.12-stable tree
To: akpm@linux-foundation.org,alex_y_xu@yahoo.ca,baohua@kernel.org,baolin.wang@linux.alibaba.com,bhe@redhat.com,chrisl@kernel.org,david@kernel.org,david@redhat.com,dev.jain@arm.com,gregkh@linuxfoundation.org,groeck@google.com,gthelen@google.com,hughd@google.com,ioworker0@gmail.com,kasong@tencent.com,lance.yang@linux.dev,linux-mm@kvack.org,nphamcs@gmail.com,ryncsn@gmail.com,shikemeng@huaweicloud.com,willy@infradead.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Mon, 23 Mar 2026 11:34:05 +0100
In-Reply-To: <0e918493-29b1-de47-9fca-b1fa93156d63@google.com>
Message-ID: <2026032305-unstable-overripe-b796@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 93DB1180012
X-Stat-Signature: oduot8e81pt7hbgbubi37h6npcknmkyt
X-Rspam-User: 
X-HE-Tag: 1774262075-775329
X-HE-Meta: U2FsdGVkX1/ojnc9qqlY+122sdXbicnTSG0yfv7oOUy2TTY175xOmeYqx3Z6tj3qbfUo19yQUe5QUaRKAtQCHznQAVMoN+TJ3RLdPo6YE/IGC1AYmHEB9HORHvfMnZjR1EAC1a+yGSr6tBCzPfZJa8YSTm0/gxQgMFBOBPrLBIXC3aG9PKFLqSAggi2Cddlm1YYKVmTuoWFlmlOqiCOtZ26m5N8yzWl7OomRMMgApBO9cbG2i4MXERwX9OgH5tv0lmY2S7wfWYJ4lNj09Tuzp9IwVJJo3uFtbo4aPjlZZvDYp2WHDzrD/V7hOhaBxkcLo2SKL8asmm9JuiI0Whtt9IDkTubNNMXBGSWLNBhHwr4zsE9pX9GlXD1DkVLmqyL4pI9fzhrrt9aCA+TvIBhUdwNmvzE+0gbLdKaHxl324Tc8pgz9yuFbDBcvID2EHbdFKf04Y//MwfwoN4f1yHlO6bisc5gMe7Jq/jx9XGsCO6IwN4DrxYWPSOShbvoOGu60pF7quuEReYW7+kSQfXYsMdczEPC0DKc+FJpGETW95I84kofzLY7sg7VlMZUeyOPiouWeDMFlKvt/Oxva/1d/VWNw+0p5uCJr37wgPMcnEX83wJbW/jDZKbaR+HEsOUievtCQJp1aNeIa95jGiXH8IBenjmPvSt4dZYeXRDlKOBTgh+5r3ykAT92T8XFB6Jtju7ftOO6Kw89Sqrjp0Ulkxwn3F+mVR43ABYVFcmG5wJo6GB9RTKHcl7Cvmo2lPfTuAJj9LuQ3XdoIgsNaA1XpRdtj4GZObtt0LiGLVi9AOeKF2oeVnwyZTraP493l0j4qIDUDq7uAUqnygvfP10KeEMiGnpKROHMN5e2SkezG4FT2Rm/BBRvp0tcYbzRh+fYOIoc3xGTCwzllDaBxEZo/S2VYaaqqEqj6x+5r/PiXmyDUb4rDgkaYBsIfTH5CL5+qhsFffK/zJrbnApa5IaM
 9ybFEadb
 Czf786Ms06Fydj3YmuAbdcm+FsnJZ1awU8/+qU8HjpowGjhvh2ZzN6rGLt/o+p5ogoVDVvzszm9ds41fZS9uyjbhB2jq0WCW3FVeVNYNBA+NFVbxm+IA0bh+OvUYZ120niMnImrnQuo+mBNL1cTdzmT9UnuZHp3TvUmhoYlZbIQzPVqbunJHIBA0yvPKhPFYlfm4Ifp6sYHK0h/3SsGmPlg1ET9iGoFBSQSGpzEiSJ/NpTFkf5/Jp6h7zyDrinNcaBtsmS14lxU2aATcY/F60F+h+oHhsa6Q96lHOZ9GFt/EYwLL+b5omc0v6OnXCoGcAtE5DtaCQmZuIZqsOtah2PiSSB/2C0vWc5ca4DIZJdJ9aombMXr8uwwCkcW2BKK49gTkMz6StWrBIb7iz3y3tu7lP1jQI+ttMmrGxq19dKFXP1B/sCqZ7Oa3wayLGU6RM37cX0S1QMeMklCg0s4FTASswKm2dCo296q/GAlZ/4aNQUjcWIytumfNnwzlUXBVjbfA6nt70I4JiFAup89HzPG47/vNusPUYfMOPop40JuN8LFNmlrMBTGViLVXnuwBr+6hob2upge6fAq7eJc8CQhmjHFSyVYXK0HAhZRdtMjcMLdtJzEw9AWGZd32KWvScS6JqP9E4u1yUZ4EL149rIHYUiAHoSRZbMpG6u4GnqgH8WPPr5rtrUqFPBseSSzz5al9+sK+YZ8MDnE0izscnm7A23X1eICLOSwP4LWhpquAJVWskYtYLORcSu6rvym4cYrfhJZFCdKSznrwuWfKG4fqpV285A2kIjZIyr7Y91NXhdYZQjHQdkve3+MDnJTGFNIF6qoU7i9dN/8sgKD9MLQyEVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    mm: shmem: fix potential data corruption during shmem swapin

to the 6.12-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     mm-shmem-fix-potential-data-corruption-during-shmem-swapin.patch
and it can be found in the queue-6.12 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-227930-greg=kroah.com@vger.kernel.org Mon Mar 23 10:34:29 2026
From: Hugh Dickins <hughd@google.com>
Date: Mon, 23 Mar 2026 02:34:19 -0700 (PDT)
Subject: mm: shmem: fix potential data corruption during shmem swapin
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,  Baolin Wang <baolin.wang@linux.alibaba.com>, Baoquan He <bhe@redhat.com>,  Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>,  David Hildenbrand <david@kernel.org>, Dev Jain <dev.jain@arm.com>,  Greg Thelen <gthelen@google.com>, Guenter Roeck <groeck@google.com>,  Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,  Lance Yang <lance.yang@linux.dev>, Matthew Wilcox <willy@infradead.org>,  Nhat Pham <nphamcs@gmail.com>, linux-mm@kvack.org, stable@vger.kernel.org
Message-ID: <0e918493-29b1-de47-9fca-b1fa93156d63@google.com>

From: Baolin Wang <baolin.wang@linux.alibaba.com>

commit 058313515d5aab10d0a01dd634f92ed4a4e71d4c upstream.

Alex and Kairui reported some issues (system hang or data corruption) when
swapping out or swapping in large shmem folios.  This is especially easy
to reproduce when the tmpfs is mount with the 'huge=within_size'
parameter.  Thanks to Kairui's reproducer, the issue can be easily
replicated.

The root cause of the problem is that swap readahead may asynchronously
swap in order 0 folios into the swap cache, while the shmem mapping can
still store large swap entries.  Then an order 0 folio is inserted into
the shmem mapping without splitting the large swap entry, which overwrites
the original large swap entry, leading to data corruption.

When getting a folio from the swap cache, we should split the large swap
entry stored in the shmem mapping if the orders do not match, to fix this
issue.

Link: https://lkml.kernel.org/r/2fe47c557e74e9df5fe2437ccdc6c9115fa1bf70.1740476943.git.baolin.wang@linux.alibaba.com
Fixes: 809bc86517cc ("mm: shmem: support large folio swap out")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reported-by: Alex Xu (Hello71) <alex_y_xu@yahoo.ca>
Reported-by: Kairui Song <ryncsn@gmail.com>
Closes: https://lore.kernel.org/all/1738717785.im3r5g2vxc.none@localhost/
Tested-by: Kairui Song <kasong@tencent.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcow <willy@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

[ hughd: removed skip_swapcache dependencies ]
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/shmem.c |   30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2132,7 +2132,7 @@ static int shmem_swapin_folio(struct ino
 	struct swap_info_struct *si;
 	struct folio *folio = NULL;
 	swp_entry_t swap;
-	int error, nr_pages;
+	int error, nr_pages, order, split_order;
 
 	VM_BUG_ON(!*foliop || !xa_is_value(*foliop));
 	swap = radix_to_swp_entry(*foliop);
@@ -2151,8 +2151,8 @@ static int shmem_swapin_folio(struct ino
 
 	/* Look it up and read it in.. */
 	folio = swap_cache_get_folio(swap, NULL, 0);
+	order = xa_get_order(&mapping->i_pages, index);
 	if (!folio) {
-		int split_order;
 
 		/* Or update major stats only when swapin succeeds?? */
 		if (fault_type) {
@@ -2189,13 +2189,37 @@ static int shmem_swapin_folio(struct ino
 			error = -ENOMEM;
 			goto failed;
 		}
+	} else if (order != folio_order(folio)) {
+		/*
+		 * Swap readahead may swap in order 0 folios into swapcache
+		 * asynchronously, while the shmem mapping can still stores
+		 * large swap entries. In such cases, we should split the
+		 * large swap entry to prevent possible data corruption.
+		 */
+		split_order = shmem_split_large_entry(inode, index, swap, gfp);
+		if (split_order < 0) {
+			error = split_order;
+			goto failed;
+		}
+
+		/*
+		 * If the large swap entry has already been split, it is
+		 * necessary to recalculate the new swap entry based on
+		 * the old order alignment.
+		 */
+		if (split_order > 0) {
+			pgoff_t offset = index - round_down(index, 1 << split_order);
+
+			swap = swp_entry(swp_type(swap), swp_offset(swap) + offset);
+		}
 	}
 
 	/* We have to do this with folio locked to prevent races */
 	folio_lock(folio);
 	if (!folio_test_swapcache(folio) ||
 	    folio->swap.val != swap.val ||
-	    !shmem_confirm_swap(mapping, index, swap)) {
+	    !shmem_confirm_swap(mapping, index, swap) ||
+	    xa_get_order(&mapping->i_pages, index) != folio_order(folio)) {
 		error = -EEXIST;
 		goto unlock;
 	}


Patches currently in stable-queue which might be from hughd@google.com are

queue-6.12/mm-shmem-swap-improve-cached-mthp-handling-and-fix-potential-hang.patch
queue-6.12/mm-shmem-avoid-unpaired-folio_unlock-in-shmem_swapin_folio.patch
queue-6.12/mm-shmem-swap-avoid-redundant-xarray-lookup-during-swapin.patch
queue-6.12/mm-shmem-fix-potential-data-corruption-during-shmem-swapin.patch

