Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63DFCC79FA1
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 23:46:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5E616B008A; Tue,  8 Sep 2026 19:46:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0F416B008C; Tue,  8 Sep 2026 19:46:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 925746B0092; Tue,  8 Sep 2026 19:46:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 628176B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 19:46:00 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B874A8071C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 23:45:59 +0000 (UTC)
X-FDA: 85192230438.23.0C00E75
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 04EA0C0006
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 23:45:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LtxwYooG;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788911158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YluYVMKByfxU0jhrfhAXdNg+GL+9Wi7y0AV09M0/EDg=;
	b=mU/aUfIEpRCTmErh2APDWMwkq6xjOXGXJDmkPtGfD4OfmxEhRrmz7C9kaU8jQ5guCSRIsJ
	j8/rGYjQdH7THVAGS9WmeuFbhSkq7kgxwCQQcYgbK/uuXHvM80vVefbXQQLa73gkzVQoXy
	m24P58xXrqVHSn4dAn+s23jBlMXUPAQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788911158;
	b=C0orgMk/NO6DlJDKUUOCyM77ly7mr1c2Xy64AD3oRu4wf7N2NIOtUCcPtjAKzXmjyfyylz
	G8uwqa5sA2kG6I+KUG93P1dXkv7OMcFoOoX2Zv6kKudvWGOkfK0JkCO+lHRTm97xsS2CDL
	kKblAxpllLabMgKsdZn90+F60FAV3fE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LtxwYooG;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9342E601DE;
	Tue,  8 Sep 2026 23:45:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8271F00A3A;
	Tue,  8 Sep 2026 23:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788911156;
	bh=YluYVMKByfxU0jhrfhAXdNg+GL+9Wi7y0AV09M0/EDg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=LtxwYooGM1HHVGcczPSCT9m8ZaErT53MmLnTvSFuygid+bQEwhZaASugrIOMh12pD
	 BrNacsADi+fSErVF+GHr0LqnyguMwRdXSGWtF+phvEdI9KqZvARfPvq5h/w+cB/3aZ
	 wa+Qr1QYe4BOmgodLgUdQd7EiEJygMD8PJDEeKSU=
Date: Tue, 8 Sep 2026 16:45:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro
 Falcato <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 0/6] mm: make MAP_PRIVATE-/dev/zero mappings truly
 anonymous
Message-Id: <20260908164555.50a996a3f716523ddc13fbfb@linux-foundation.org>
In-Reply-To: <20260908-map-private-dev-zero-v2-0-acc7b5625305@kernel.org>
References: <20260908-map-private-dev-zero-v2-0-acc7b5625305@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fwyd9jgizqsaxey48dbtg45awyk3aj1k
X-Rspam-User: 
X-Rspamd-Queue-Id: 04EA0C0006
X-Rspamd-Server: rspam03
X-HE-Tag: 1788911157-190259
X-HE-Meta: U2FsdGVkX18oKrNQwFYGjISxIwwnVtHoHRIYUBKR7do9UyAk7ptaBcy3mymsC4Gg5mNacGO8bXD6WR7TDXzufp/qZIt2/IHENTX29Us4B2vMljeVyejtuRfWS+M0macS26J48jxWeChjFhwc2WqdZkKLoJXCO+DFhinyR1yeAezc0f6vWx8CFOd3ujQLxtimkUjxrlsIsBQgtjQBPMnOlC6ZwcOM4fLCoK0Oe3utMEqpBJ4QV+N4RK/ulvL5YiVDRCGz0LNdo/Q5deTFgNXEfqX3qfBRs7v5chtQdCKb0bOeSl1G3dBJrk+lEfWH//MAKoN1h2JtrcPHSuv5+ttbhGckpokOY7HHRxW3QcVkYxjHJblPTElrRrmAF7LmRAwFvRJHU+9sjrJoKbvarzTvNJZKY9OTvFfXlehOspjaEktGL3YZI6ep3ufBiWsBNx76kWGKtWUOMw0/hWZGFj3GsjtfAoQVwmp56T+7hZdSNsWbnjXAZfengs/xU7Cum/IQnQmCp+dTBG7MuA4T51SY4aSLE1CTACEisuKj310sCKpkxhTJbnrHyjcSWq9AgDtL/EpSP4hff7WKvI0mPkgGWzhqndNa6vojzVWsEerJnl/9twSwJGY5iDc/EX4XirZRkx1FIPZ52U+euq4qsT+X0zB/z5YnNXXoDB/nie66iV7EQTVZPz9OECCzjGyfl56KvSK4PKTMd49olx0KRd+65fxRGU7YY4z59vpWMWAC4QbxGKsl2RcttPTgR3nrGTAxlgTwu7iItaKOxvjJCTY5zxBT1xG35JJMk+p5yvg1yUl5aX7nltxJTj5aU0VxPadfth/T5b9rkRdzeWUYJcgcmwRblrfWEGjCfJQLMlTT2NygnWLgPk6vuvn4D88faanuJIOYIpSNTmCDetllbAceBu1xpfUYo1H8/shnm21RMu06Yu8KkJFI2GfkjDXBJPZ4qVbiFkARgpU9ANqQvhF
 1ZBdByKw
 64wfBEwS7+hb7Zi1RlqbeAUp2c9166jOnRjXka7EnJq9YZFPqjTRsdENx6ZATB1RtI+ja73ic05fuk4AI+F4upf5eaXdzZcZaPpSVUbwPhafAGhEaK8BQQJHr4Vkr32YRBWOCnozzOsUGjxgooit7cv5AAh2kr3SOnSO2Bqkwjz5Dk9ubs2uFMOwn+udehqE6dStANLlmSp55OLtahK9uAHkMoUjGGhmlNaLtTXuyOKgOTyjjICph+MidsVD7tGWdtawyjmxXAckOg2wfBq+EDYsfdees+6CB7YdYdjkknsfc67ufJ+h0IrT4JIBPLjy9uvro
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 08 Sep 2026 12:23:37 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> Historically anonymous memory was obtained in linux by MAP_PRIVATE-mapping
> /dev/zero.
> 
> The canonical way of doing these now is mmap() specifying MAP_PRIVATE |
> MAP_ANON, but we must continue to support the legacy means of obtaining these
> mappings.
> 
> As-is these mappings are an unusual edge-case - they satisfy
> vma_is_anonymous() but have non-NULL vma->vm_file, and their page offset is
> the offset into the /dev/zero file.
> 
> Commit 93c0c8dc87f6 ("mm/rmap: use anon pgoff to track MAP_PRIVATE
> file-backed anon folios") causes all other anonymous folios to be tracked
> by their anon index (vma->vm_start >> PAGE_SHIFT at the point of first
> fault), leaving MAP_PRIVATE-/dev/zero as the outlier.
> 
> This series remedies the situation by making MAP_PRIVATE-/dev/zero mappings
> truly anonymous with !vma->vm_file and correct anonymous page offset.
> 
> It starts by bringing the memory character driver into mm/ - this file
> implements /dev/zero, /dev/mem among other things and is already (as
> clearly indicated by its name) within the remit of memory management.
> 
> By doing this, the file_is_dev_zero() function can be provided, internal to
> mm, which allows for positive identification of these mappings.
> 
> Using this, first prevent any other mappings from mapping memory
> anonymously, then make these mappings truly anonymous and eliminate all
> code in the kernel that previously had to account for these strange beasts.
> 
> Finally, it adds userland VMA tests to assert the behaviour and selftests
> to assert expected merge behaviour.

Thanks, I've updated mm-unstable to this version.

> v2:
> * Added tags (thanks everybody!)
> * Reworked comment about mappings not setting themselves anon as per David.
> * Fixed up test typo as per David.
> * Fixed up test close() as per David.

Here's how v2 altered mm.git:

--- a/mm/vma.c~b
+++ a/mm/vma.c
@@ -2801,7 +2801,7 @@ static int call_mmap_prepare(struct mmap
 	if (err)
 		return err;
 
-	/* Hooks cannot mark themselves anonymous. */
+	/* It's invalid for mmap_preprare hooks to clear vm_ops. */
 	if (!desc->vm_ops)
 		return -EINVAL;
 
--- a/tools/testing/selftests/mm/merge.c~b
+++ a/tools/testing/selftests/mm/merge.c
@@ -1381,7 +1381,7 @@ TEST_F(merge, merge_map_private_dev_zero
 	 *
 	 * With these being made truly anonymous upon mapping, they will
 	 * merge. If they were file-backed VMAs the page offsets would prevent
-	 * merge:
+	 * the merge:
 	 *
 	 * |-----||------|    |-------------|
 	 * | ptr || ptr2 | -> |     ptr     |
@@ -1389,17 +1389,11 @@ TEST_F(merge, merge_map_private_dev_zero
 	 */
 	ptr = mmap(carveout, 5 * page_size, PROT_READ | PROT_WRITE,
 		   MAP_FIXED | MAP_PRIVATE, fd_zero, 0);
-	if (ptr == MAP_FAILED) {
-		close(fd_zero);
-		ASSERT_TRUE(false);
-	}
 	ptr2 = mmap(&carveout[5 * page_size], 5 * page_size,
 		   PROT_READ | PROT_WRITE, MAP_FIXED | MAP_PRIVATE, fd_zero, 0);
-	if (ptr2 == MAP_FAILED) {
-		close(fd_zero);
-		ASSERT_TRUE(false);
-	}
 	close(fd_zero);
+	ASSERT_NE(ptr, MAP_FAILED);
+	ASSERT_NE(ptr2, MAP_FAILED);
 
 	/* Assert that they merged. */
 	ASSERT_TRUE(find_vma_procmap(procmap, ptr));
@@ -1430,10 +1424,7 @@ TEST_F(merge, merge_map_private_dev_zero
 	 */
 	ptr = mmap(carveout, 15 * page_size, PROT_READ | PROT_WRITE,
 		   MAP_FIXED | MAP_PRIVATE, fd_zero, 0);
-	if (ptr == MAP_FAILED) {
-		close(fd_zero);
-		ASSERT_TRUE(false);
-	}
+	ASSERT_NE(ptr, MAP_FAILED);
 	memset(ptr, 'x', 15 * page_size);
 
 	/*
_


