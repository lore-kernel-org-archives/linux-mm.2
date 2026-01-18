Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA4C8C9830C
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 20:07:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C9AE6B00CA; Sun, 18 Jan 2026 15:07:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AB076B00CB; Sun, 18 Jan 2026 15:07:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 382B36B00CC; Sun, 18 Jan 2026 15:07:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 28CC36B00CA
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 15:07:03 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E43461605B0
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 20:07:02 +0000 (UTC)
X-FDA: 84346168284.28.59CBAEC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 278AA20005
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 20:07:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=oItGBmPo;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768766821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MSducsx58Zk03TfA38A3SqbHeH4ROtt7N7+S00R3lEQ=;
	b=lTVEiBwdn6DAF0uRDZkGR337aJi08wtrvaKA3mssarL7CuFK9hWEoXRTBv8N/hbocg4FbM
	tOYFXJqZmyDqirTkQuV83ReSVyVkM1NKxH2Jz5o7d08MB2/7FIDZcymcZOMzWGdkg9d36w
	M+AGwp6jB7D0UR8SBp7WxJgKpXbTfqY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=oItGBmPo;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768766821; a=rsa-sha256;
	cv=none;
	b=uVxdcy2DRumL3fEKT8lJr9qgptPT/P3NrCbTlhrxzzMrnMhVhQYb/mE66ujkqr5r+219J6
	INah0OdZapCZBrQ51b2+aIrqoJ3x5IZ1yPoMeFHnb8KjvQskt1yylwei7w4Oj4kIZqSzDs
	Js3SFY6TORFN7EUuaumo29SsclUPikY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D09E443446;
	Sun, 18 Jan 2026 20:06:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE6BC116D0;
	Sun, 18 Jan 2026 20:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768766819;
	bh=fL7JMRl2KU6exx6Vp3urFWHTgbHwpYDux1TKOztPPjQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=oItGBmPoVsI9z1OhB8ZVgEOUoSMxboHNTct25GO6b+lUeQsYjCNWfeGrqtHXUYSjz
	 y6i8c9QpDuOAQDMomau0kMg7jrGDdK+IWyOR5L6LOtrESwl9B4+gKdZQfJQaIp4wvd
	 BYRrvhWON7GHFQe1t53Jt9xMfBbM+DYOsV6XEsxk=
Date: Sun, 18 Jan 2026 12:06:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Shakeel Butt
 <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, Rik van
 Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, Jann Horn
 <jannh@google.com>, Mike Rapoport <rppt@kernel.org>, Michal Hocko
 <mhocko@suse.com>, Pedro Falcato <pfalcato@suse.de>, Chris Li
 <chriscli@google.com>, Barry Song <v-songbaohua@oppo.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/9] mm: clean up anon_vma implementation
Message-Id: <20260118120658.8da21fc257774feb4e753969@linux-foundation.org>
In-Reply-To: <cover.1768746221.git.lorenzo.stoakes@oracle.com>
References: <cover.1768746221.git.lorenzo.stoakes@oracle.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 278AA20005
X-Stat-Signature: y76qz3xqhsmsn3bfye4acp6ciqj3ka99
X-HE-Tag: 1768766820-963152
X-HE-Meta: U2FsdGVkX19H9cXfI1CGZRqYg6GodC5cAGoNcFSltHstHjkf8iIo4XrseFHhn/FPMxuIVblbb3qBcaaU5hnu84QCeCsbrr6Tr2h+M5UwbYXmJRJz5QfjIlqgKo9gk9d7QrF4aimczTnvYJmbUK2vTPAdq/Jw4GY8ulFfBQVKVd8EJZJvOMjHJn+KtCwrxqkluiWRse+Gf1zd0LDPoXn5yiftASnrzUWZmurCxTmDe9nImdbrY51djoDB3hCNzqt1IaMsYANuWs7NQ/UMg7TS7UFn4teT6iNXnobsbu9wcadNAkuK2UNvXYfdd/JVfcAwBrAT+ocatDOGnfH8yHXrbe8eiC/wPHlATNIqaVzzERp3bPqsUI79u7oZoADCVTCXb8zS5QiCM69td5QD1t17wf/+JzGsBLGsakFGYOWorRtbVo0HGkYV84aE/C29vO9W8rUfM22KojhYr55hp53HsPCQvhqq+Xq1BV5aa6eZBLV9Nnm+TDZgxoBtssiSrd5QgiEbNYm0OyNRwq4o86ILKapcwC0SzY3UvUvPOAh8Y8mjNFTwpxJtXsAHFZV2YoHwNQ/JtkbyQZG0x2QuP+G6bIag/pqkyR8+AMOU5f6b3qaTOp7ViSsBgYUO0IVQP7DFZNP9PqfLqtRkhGWDMcj42ioO1aHXYQsJYhthDo3tWzGCpZ+zUUldd15D0Gw67hY0M036Fkry2GwHcB8X2Q0m1o5V9upxUL8l7N3Dew3caA3Kn4Q5rgSmXMw2KggodrdZfo21uVm6adWMV3YVuw/cBVIrxWTGh35zgm6wd44rfLdxbnBuDPaoRhwvIjwUFi9zqryV3f/mnPoXihxHbHyFj4nSfvo+Mp7I8x7pxnPJ97QyJhZdy7g3iBYOyWoUT4Y1EQMTQtadHk+qtJa8A34BGvr7WaDzMDxCJQX9J5rWPtEhH+RCZZFFNT/qWRCgiqg7QrEC3yT5Zlv28d2IY55
 FDPIQWcp
 t7qL77UBwroXbcY6Ka2ok0vJGaeCc8tnaFHokLzve7xwQCvuOxXwb/5bYg32vtC7PBoiRdVmXrzz6Q4WvZAshRrdA3loFQYiis4AsoujxcMh0G3jxVcobu3KvHyfWDEamja8PHTZlpoCaVD+CAgKikIZIgIzjjICksQYXyhSJEOCtEbtN0tVEc1V4+8EmuRUFyXJlTvCELjkKIy78xLA/lpL4lfy0JgvwTATsgp3p4yk8NQSMbwH8KZNQ0YIsPd7AHlqVlgMr04KZrrYdSPfnAtF6hehw1eMZBJFM925w0A9PL+su8JSWm4hKNbHueIJueyyy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 18 Jan 2026 14:50:36 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> The anon_vma logic is hugely confusing and, much like a bundle of wires
> entangled with one another, pulling on one thread seems only to lead to
> more entanglement elsewhere.
> 
> There is a mish-mash of the core implementation, how that implementation is
> invoked, how helper functions are invoked and concepts such as adjacent
> anon_vma merge and anon_vma object reuse.
> 
> This series tries to improve the situation somewhat.

Updated, thanks.

> v3:
> * Propagate tags (thanks everyone!)
> * Fold fix-patches into series.
> * Add fix for syzbot report about an accursed partially-initialised VMA
>   fault injection error path.
> * Fixed a typo, a comment whitespace error I noticed and add some comments
>   to anon_vma_fork(), set anon_vma->num_active_vmas = 1 to make it clear
>   that we're setting this on a newly allocated anon_vma.

Below is how this update altered mm.git:


--- a/mm/rmap.c~b
+++ a/mm/rmap.c
@@ -333,10 +333,10 @@ int anon_vma_clone(struct vm_area_struct
 	 * are not updating the anon_vma rbtree nor are we changing
 	 * anon_vma statistics.
 	 *
-	* Either src, dst have the same mm for which we hold an exclusive mmap
-	* write lock, or we are forking and we hold it on src->vm_mm and dst is
-	* not yet accessible to other threads so there's no possibliity of the
-	* unlinked AVC's being observed yet.
+	 * Either src, dst have the same mm for which we hold an exclusive mmap
+	 * write lock, or we are forking and we hold it on src->vm_mm and dst is
+	 * not yet accessible to other threads so there's no possibliity of the
+	 * unlinked AVC's being observed yet.
 	 */
 	list_for_each_entry(pavc, &src->anon_vma_chain, same_vma) {
 		avc = anon_vma_chain_alloc(GFP_KERNEL);
@@ -379,7 +379,7 @@ int anon_vma_fork(struct vm_area_struct
 {
 	struct anon_vma_chain *avc;
 	struct anon_vma *anon_vma;
-	int error;
+	int rc;
 
 	/* Don't bother if the parent process has no anon_vma here. */
 	if (!pvma->anon_vma)
@@ -388,27 +388,35 @@ int anon_vma_fork(struct vm_area_struct
 	/* Drop inherited anon_vma, we'll reuse existing or allocate new. */
 	vma->anon_vma = NULL;
 
+	anon_vma = anon_vma_alloc();
+	if (!anon_vma)
+		return -ENOMEM;
+	avc = anon_vma_chain_alloc(GFP_KERNEL);
+	if (!avc) {
+		put_anon_vma(anon_vma);
+		return -ENOMEM;
+	}
+
 	/*
 	 * First, attach the new VMA to the parent VMA's anon_vmas,
 	 * so rmap can find non-COWed pages in child processes.
 	 */
-	error = anon_vma_clone(vma, pvma, VMA_OP_FORK);
-	if (error)
-		return error;
-
-	/* An existing anon_vma has been reused, all done then. */
-	if (vma->anon_vma)
-		return 0;
+	rc = anon_vma_clone(vma, pvma, VMA_OP_FORK);
+	/* An error arose or an existing anon_vma was reused, all done then. */
+	if (rc || vma->anon_vma) {
+		put_anon_vma(anon_vma);
+		anon_vma_chain_free(avc);
+		return rc;
+	}
 
-	/* Then add our own anon_vma. */
-	anon_vma = anon_vma_alloc();
-	if (!anon_vma)
-		goto out_error;
-	anon_vma->num_active_vmas++;
-	avc = anon_vma_chain_alloc(GFP_KERNEL);
-	if (!avc)
-		goto out_error_free_anon_vma;
+	/*
+	 * OK no reuse, so add our own anon_vma.
+	 *
+	 * Since it is not linked anywhere we can safely manipulate anon_vma
+	 * fields without a lock.
+	 */
 
+	anon_vma->num_active_vmas = 1;
 	/*
 	 * The root anon_vma's rwsem is the lock actually used when we
 	 * lock any of the anon_vmas in this anon_vma tree.
@@ -431,12 +439,6 @@ int anon_vma_fork(struct vm_area_struct
 	anon_vma_unlock_write(anon_vma);
 
 	return 0;
-
- out_error_free_anon_vma:
-	put_anon_vma(anon_vma);
- out_error:
-	unlink_anon_vmas(vma);
-	return -ENOMEM;
 }
 
 /*
_


