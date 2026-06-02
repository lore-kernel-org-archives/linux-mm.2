Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D401DCD6E5D
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 20:10:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 189316B0088; Tue,  2 Jun 2026 16:10:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11B8C6B008A; Tue,  2 Jun 2026 16:10:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 028A16B008C; Tue,  2 Jun 2026 16:10:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E22BF6B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 16:10:53 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 86A6F88731
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 20:10:53 +0000 (UTC)
X-FDA: 84836065986.28.A075450
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9589C80017
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 20:10:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FlQf+5kL;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780431051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NRCYIXk5xTkfp82OQZJovt45Ucm7r0SKmvk+xAm+PCY=;
	b=r7L5jOnFi8b42hD3ORPb2PsenHvW7aqOqBmd1tSFFFDTE5bCs468Blx5UiwdqO82MVF2YY
	yI/mi6ZRbznoV0VfG5q62rij4rCYaUEEOHyB7CQ42CCNVB5hUf1wQupM+XLk48IDgOHjP7
	sRtCenfhzVQkziYneIcZ7SX853+er4I=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FlQf+5kL;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780431051;
	b=jk24chTTcSYYubg/bCvEAEg1R3w/o2Qct+GiWoG1aCR2Vya2z2Zar/X7Afp7BBSFjtqb8y
	PZvHpfLFR9rPXG1xvKiFUTWLNNHuGOGJxDOIVfVRP12GdIeYhsQHJZMDqwK5OdPNuc/UiN
	0zO20fXAspZoOTHT0UmpSVlomKQ28To=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8D2C843929;
	Tue,  2 Jun 2026 20:10:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A6C1F00893;
	Tue,  2 Jun 2026 20:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780431050;
	bh=NRCYIXk5xTkfp82OQZJovt45Ucm7r0SKmvk+xAm+PCY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=FlQf+5kLpzBZVFvOeRcxtB8F6UOvyf1jDzq9+3UuWxdF3xkWE2UAV996mFLpzOrjQ
	 EQQCrzBuG6yPBC2nBhYYIkj54I/oym5OyAKtWYfmcRDpTd+vUBy5sFuPaCJWJiROO2
	 4V85lGSfsE0NPzeBweamgMvxTUhJ0838w2S9ZOD8=
Date: Tue, 2 Jun 2026 13:10:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn
 <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 0/3] remove mmap_action success, error hooks
Message-Id: <20260602131049.74177bbb6d85fe01ff6512ff@linux-foundation.org>
In-Reply-To: <cover.1780397980.git.ljs@kernel.org>
References: <cover.1780397980.git.ljs@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: keicusn6bmru8e4bchejtdtwurzjkcmn
X-Rspamd-Queue-Id: 9589C80017
X-HE-Tag: 1780431051-76541
X-HE-Meta: U2FsdGVkX18HiKN5M0z2J9ySVYxoWAKhF6XeoZXyEHsTngngW0qRqVXhVrFNIK33TaH3FmFSuOaPd7whI+3G+1OCdHwARxXudLk0Dn93D0hJpT7v9McmzOkkIw8zYF0H+l3h9PH+AK3gxDZrcAIUMZ1X+EPkVK2muUKW7FyWnNKARbFn6/jjDYZprJnSGQ4ZPEMF5bM6rDQfnQm8x7Ig6eW4/rUvIU9MOmzrzgRRXh5W20JsZShah+Khaxzp4LRm3kieo7UA7XFSDs2aMRF229Uv8CUX1vjsYutM9GEPQfDRju3zekyzxyaTIaTUj99usEOTu78VNejO2vGdZxBBikOIvMbgdab/bev8mAGEV7DsCnLejgukVeKKsxaKGmHa6uOMKIt09kpLMTyIvEBSwHNQIViY3/Ysg4s45rzWfacrwULFaqq/+WaTedpZXBJW4miSsdFV5TH4cVW6Fe/nExI4EMSWRrpU8npTm47F74EPEeeKUym/K97DppA8Pdfa5L5Ry7ev3GYkgZ/KXFXppmfTG+d8blkTqDF6GlZiQhINEnXt6oqnMJgygQtVlkW3nxsz1faKWMWflx8kSjJc4awenBo0pN/fR7VtIue5XhHvFMyR24dVZS9MwOfD4vdccL11TsdShu2pow9ceetKaNZ0kJZgeLmUbCo8/cV0MYw5FL4bMcb1DwI52offfUwAo691+s0fBWCH+zdqNtdXfnKPRD0w/tEHmczYdaMXKHCJaA0HN8L26fHeZ7mFt0nJthG8/3SqU+/0K3AcicfDyxrNyHd+72XvZmiIeLOVivNQUWHn5tP4vkRpKOX3HadqA20ztWWZHgv0+aIgJ1E5ZFRphKJU6TNxvNJ0sAfK6p1V4X7Zt2Ug23R22p9Ug4EKcE/y/ry6geS7VeyOaPArPoBwq5RC4DR74qDpFMVeIpzGgOx+yLzwRk4HE9DG1p8IR0dyLE//y4T0OZ8wBFT
 H6XSCkSF
 5zA8TPDxT7WVNC1r4Ku+rkTO+ICh+HMhX0Kxi/zipxZ8K6Y6ZGYBNj/ZErW6h+BQn7wG8b4p+yaHl2muWzG/6DmP9EBJN6rHOfVbJD06oPWM5L851ma4Zj3w1GBnLNHmFvgmRqAYTc3/61VishqU8iDVE0w2JTeFANFFK8bnQFyc3L22gjs+abESkkblVAoKCLZ0z5GMIFRB4tR0sTPLgSZT5QumMfUK02hu/W88Oc0afK06YHJJ/0tzknqP0SHCX0A2z4Q5bZCJDihcnJt8JO5aAjFMOTSwoydKuxr9LJhz3x4eyV+Qbfj4CkMS4rYOiur8g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  2 Jun 2026 12:06:24 +0100 Lorenzo Stoakes <ljs@kernel.org> wrote:

> The mmap_action->success_hook was a strange beast added to enable code
> which appeared to absolutely require access to a VMA pointer to work
> correctly.
> 
> Primarily this was for hugetlb, however a different approach will be taken
> there, as clearly more work is required to figure out a sensible way of
> converting hugetlb to use mmap_prepare.
> 
> The other user was the memory char driver, specifically /dev/zero which has
> the unusual property of explicitly setting file-backed VMAs anonymous.
> 
> Providing the success hook was always foolish, as it allowed drivers a way
> to workaround the restriction that they should not access a pointer to a
> not-yet-correctly-initialised VMA - which defeats the purpose of the
> mmap_prepare work.
> 
> We can achieve the same thing in memory char driver without needing the
> success hook, so this series removes that, then removes the success hook
> altogether.
> 
> The error hook is also unnecessary - the motivation for this was for
> functions which need to override the error code when performing an mmap
> action in order to avoid breaking userspace.
> 
> We can achieve this by just providing a field for the error code. Doing
> this means we don't have to worry about the hook doing anything odd.
> 
> We also add a check to ensure the error code is in fact valid.
> 
> Again the memory char driver is the only current user of this, so this
> series updates it to use that.
> 
> After this change mmap_action has no custom hooks at all, which seems
> rather more cromulent than before.

Updated, thanks.

> v3:
> * Rename error_filter -> errror_override + update commit message as per
>  David.

Here's how v3 altered mm.git:

 drivers/char/mem.c              |    2 +-
 include/linux/mm_types.h        |    6 +++---
 mm/util.c                       |    6 +++---
 tools/testing/vma/include/dup.h |    6 +++---
 4 files changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/char/mem.c~b
+++ a/drivers/char/mem.c
@@ -357,7 +357,7 @@ static int mmap_mem_prepare(struct vm_ar
 
 	/* Remap-pfn-range will mark the range with the I/O flag. */
 	mmap_action_remap_full(desc, desc->pgoff);
-	desc->action.error_filter = -EAGAIN;
+	desc->action.error_override = -EAGAIN;
 
 	return 0;
 }
--- a/include/linux/mm_types.h~b
+++ a/include/linux/mm_types.h
@@ -844,10 +844,10 @@ struct mmap_action {
 	enum mmap_action_type type;
 
 	/*
-	 * If non-zero, filter errors that arise from mmap actions such that we
-	 * return error_filter instead. Only valid error codes may be specified.
+	 * If non-zero, replace errors that arise from mmap actions with this
+	 * value instead. Only valid error codes may be specified.
 	 */
-	int error_filter;
+	int error_override;
 
 	/*
 	 * This should be set in rare instances where the operation required
--- a/mm/util.c~b
+++ a/mm/util.c
@@ -1415,16 +1415,16 @@ static int mmap_action_finish(struct vm_
 	len = vma_pages(vma) << PAGE_SHIFT;
 	do_munmap(current->mm, vma->vm_start, len, NULL);
 
-	return action->error_filter ?: err;
+	return action->error_override ?: err;
 }
 
 #ifdef CONFIG_MMU
 
 static int check_mmap_action(struct mmap_action *action)
 {
-	const unsigned long filter = action->error_filter;
+	const unsigned long override = action->error_override;
 
-	if (WARN_ON_ONCE(filter && !IS_ERR_VALUE(filter)))
+	if (WARN_ON_ONCE(override && !IS_ERR_VALUE(override)))
 		return -EINVAL;
 
 	return 0;
--- a/tools/testing/vma/include/dup.h~b
+++ a/tools/testing/vma/include/dup.h
@@ -483,10 +483,10 @@ struct mmap_action {
 	enum mmap_action_type type;
 
 	/*
-	 * If non-zero, filter errors that arise from mmap actions such that we
-	 * return error_filter instead. Only valid error codes may be specified.
+	 * If non-zero, replace errors that arise from mmap actions with this
+	 * value instead. Only valid error codes may be specified.
 	 */
-	int error_filter;
+	int error_override;
 
 	/*
 	 * This should be set in rare instances where the operation required
_


