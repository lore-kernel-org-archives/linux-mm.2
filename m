Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB04EC4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 19:40:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B56726B008A; Fri, 17 Jul 2026 15:40:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2EC56B00D3; Fri, 17 Jul 2026 15:40:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6C1B6B00D5; Fri, 17 Jul 2026 15:40:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7AA026B00D3
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 15:40:03 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E823F40206
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 19:40:02 +0000 (UTC)
X-FDA: 84999284244.15.C8AABBD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 18BF71C0003
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 19:40:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=MwZTrKk3;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784317201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iyfkphrqCeDRYVOH+L7t1qg0gMyCglA6AMvMBV+tJlA=;
	b=UPK5GWgnSZeBlp2uEbUc08epTdv0KuUsAnXfXv3kJKqwkNyP/C6UfcfQhtZBENVcC9Iukx
	aiCe6uEHOfr2ijDC3LC/YSKyJrxjj7f0UyYAVTtOErAsHiPftr6vXGcfBdSWfRCNiX4pRF
	xPZI430cCNmwRsnX8PcWxq5A6u0d9mY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=MwZTrKk3;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784317201;
	b=pijPhLu/pe15/9MJFjY0mXGezfUl4DBs0py4E6j643KCLuKy034/QjminUF7GpdBLRq9ke
	FY9KIaciCN0EFCqpIrzxxmm5sfkDH7DXo5+Hvtbh061pDlKbYi+cyRvdCdVvKjXi26DesS
	sFCkGhFTO0bDBAds86DaJ0kJvIrWsZo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BF8DB43FEB;
	Fri, 17 Jul 2026 19:39:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3D91F000E9;
	Fri, 17 Jul 2026 19:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784317199;
	bh=iyfkphrqCeDRYVOH+L7t1qg0gMyCglA6AMvMBV+tJlA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=MwZTrKk3vTa1tRaaX4wi2tiU/4Vrt4o7NMcor3OxIkZ5EFBHemIIi7ZLnr5ZdnRGf
	 gEFBn9kxOmX12rdjTPzpBi72IDFLyHRCjeG1MGX1YPD25GABaRCY4IAbi16flGaiLW
	 P+mH4TNOiikbaY+skDjOEDSsHu3LFUhXVm8KpI44=
Date: Fri, 17 Jul 2026 12:39:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato
 <pfalcato@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Kees Cook
 <kees@kernel.org>, David Hildenbrand <david@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] mm/mseal: further cleanups
Message-Id: <20260717123958.98f965ed7996804e6157b399@linux-foundation.org>
In-Reply-To: <20260717-mseal-fixups-v2-0-0daa0014b813@kernel.org>
References: <20260717-mseal-fixups-v2-0-0daa0014b813@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 18BF71C0003
X-Stat-Signature: bmxjxhmo8fy1caikupqemozztj9eom8z
X-HE-Tag: 1784317200-259238
X-HE-Meta: U2FsdGVkX19/JxK8Qp4PsDsJP2giYE3jMGq6Ral0s2VZVL6Va6bKxRRn5ekQ8g61p3DuqmcboHCrFgQLSYuXUbNgXk2A6TFBGUSFvkTUprvzXhu2uMphYzhvLNRZrbKuYXHOeB5hIXnkt7/l/BdTA/N2W2KTzafVKuGwXX25u2V+sPlKZdeuch9JjfmulJ/VnXrMH3SKrZAxHqwpJrf0m9h782Oin6shnKzHhzibqq6N9rD0PSvtGo39sdHleTNn8z7KLeXJMk7HMz5LjHM+OxrKawby9SEsLuH1cJdiese423gWLRLUeMtK1ozpvolPYD+xYWsWGFOjgjVAK9rQUkgUEg9JxmCzBryPhpdZJNjnw7YuZPF1x7fE3xXN1ACVyA+GSDjwPI7mU/tZJ8ZczBsSW8ESqgRGu6bQnYcLMcCw96NlukzJpaGHIhNqR8V6GQhZZ6v8lBYN2s09axwBhDB3nJyGke3K+T1nhqvnCRCZblyQWlkAkC1a9E5OEjbAEjZ+tC8q1xIwh/s6JlhPinRYImyHhwvJyZg/b1/Uw8vnQ4GTKEaiPGijwGg1GJYiFEcfAoTIp9RAevur66DZBt13dqOvwI4Cb0kDpcSSo/mwx1UWg1B1FcCYNab2fcxQs1ARobbe+i6l52MZkH/5jIBMAdemq57f48WWOqEFLoEKSFdpfgo9SjjLxJWZZ7BHQcsVoPPnbWWcg6f+Zm5qaOy9MqlDMWHL+QYQ0e5IhSY+sg2OG2KKYqxVRmlVTr6fLydeaKBjjaUvpv2xvQjxJEW+cE960DrUS25by0i21ovBOV5j1t6z22cAj6B2lwN1lZY/6wVT16ORgIB7FDJ+lvjejdqywVdtMe7lUxP45vaAj3wlcEakVHoGyqys9raCcDoGjKLrpVqtn8XGjWSTrlj1lY6FAFPprFeW3DV7DTeN8/hpHM403vMH/vYCrXYMjhsJXcTnAYNIYkIkW2H
 uNedgLiQ
 0glUEX/NoS8Vbo60N6s8Ghhl6S2E57a8kowVqEqCG24OFnoGY9L+wtAUdJLXE9V6MC2a6jdG193WiYf3NYiqlEMyr9kLXf/RZJLmlVVyvsrJQ0MjSMjxGVT6KnbDojkWEcWJQNB6KRku7XzGBUGgVCNPr6Fk9k6iAQQwZJE4KQLrr2Y6cr91xktjYayBOXY/3/DfamjuuNusk0k9TugeGbpAE35tGdy2X8wfDpCRZHnAzwLJJyLo+cVNUc05RvqRFnJ3tpHju9ISFsyDA3Fw8jYNChYj22JG68esHWizPrd+XTsHqVVsTu1l3Mg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 17 Jul 2026 18:27:08 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> 
> The mseal implementation is still rather confusing, so tighten things up a
> little.
> 
> The only user of do_mseal() outside of the system call is the MMAP_PAGE_ZERO
> process personality - retain better control over how mseal is utilised by
> providing mseal_mmap_page_zero() for this instead.
> 
> The comments are overly long and confusion, so cut them down so they're a lot
> clearer.
> 
> Remove confusing mm_struct params (mseal can not be used on remote mm's) and
> wrap the actual system call logic into the system call declaration.

Thanks, I've updated mm-new to this version.

> v2:
> * Added tags (thanks everyone!)
> * Abstracted mm as per David.
> * Renamed [__]mseal() to [__]mseal_range() as per Pedro.
> * Moved to reverse xmas tree declarations.
> * Tweaked commit message for 2/3.

Here's how v2 altered mm.git:

 mm/mseal.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/mseal.c~b
+++ a/mm/mseal.c
@@ -18,9 +18,9 @@
 
 static bool range_contains_unmapped(unsigned long start, unsigned long end)
 {
-	struct vm_area_struct *vma;
-	unsigned long prev_end = start;
 	VMA_ITERATOR(vmi, current->mm, start);
+	unsigned long prev_end = start;
+	struct vm_area_struct *vma;
 
 	for_each_vma_range(vmi, vma, end) {
 		if (vma->vm_start > prev_end)
@@ -32,10 +32,10 @@ static bool range_contains_unmapped(unsi
 	return prev_end < end;
 }
 
-static int __mseal(unsigned long start, unsigned long end)
+static int __mseal_range(unsigned long start, unsigned long end)
 {
-	struct vm_area_struct *vma, *prev;
 	VMA_ITERATOR(vmi, current->mm, start);
+	struct vm_area_struct *vma, *prev;
 
 	/* We know there are no gaps so this will be non-NULL. */
 	vma = vma_iter_load(&vmi);
@@ -66,7 +66,7 @@ static int __mseal(unsigned long start,
 	return 0;
 }
 
-static int mseal(unsigned long start, unsigned long end)
+static int mseal_range(unsigned long start, unsigned long end)
 {
 	int err;
 
@@ -76,7 +76,7 @@ static int mseal(unsigned long start, un
 	if (range_contains_unmapped(start, end))
 		err = -ENOMEM;
 	else
-		err = __mseal(start, end);
+		err = __mseal_range(start, end);
 	mmap_write_unlock(current->mm);
 	return err;
 }
@@ -92,7 +92,7 @@ void mseal_mmap_page_zero(void)
 	if (WARN_ON_ONCE(!(current->personality & MMAP_PAGE_ZERO)))
 		return;
 
-	err = mseal(0, PAGE_SIZE);
+	err = mseal_range(0, PAGE_SIZE);
 	if (err)
 		pr_warn_ratelimited("pid=%d, couldn't seal address 0, ret=%d.\n",
 				    task_pid_nr(current), err);
@@ -139,5 +139,5 @@ SYSCALL_DEFINE3(mseal, unsigned long, st
 	if (end == start)
 		return 0;
 
-	return mseal(start, end);
+	return mseal_range(start, end);
 }
_


