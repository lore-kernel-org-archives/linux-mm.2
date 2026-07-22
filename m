Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F472C4452D
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 00:39:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2082B6B00A7; Tue, 21 Jul 2026 20:39:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 191EE6B00A9; Tue, 21 Jul 2026 20:39:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05C786B00AA; Tue, 21 Jul 2026 20:39:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CF6716B00A7
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 20:39:43 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4E04B1C004A
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 00:39:43 +0000 (UTC)
X-FDA: 85014554646.04.9866B63
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9BACA100008
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 00:39:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AK1Hw3Sm;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784680781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y4T+aKPpaxnS+ujMYR/jYT/mPnpjNhh6DW0nJJXIn5A=;
	b=iHLCNB+rMg2P3i1STeQFZaROcMcZrqT67MeckggA/lMZ44hFIDCnmtfC73yMNVNSXYQk1d
	fwGkJLQDikIiO8L7J0gaBQ0AXzUY/8vcTjoq5JA+TRmQrpVtWFi6dsUv41rdqFDgdgLSfi
	uTWxawFy35BXEwFonHq81F2dUe1fxyw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AK1Hw3Sm;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784680781;
	b=MOb5vKLK95kxyTp0jftCDC5Cp1J6+Hjo4NUxwyAWI69dlcdM5+GrK6i9VVrUJ12+Xjprlt
	KZxqG4kwQd2+312TpYemRS0TCP0duGzrCh7i8H+uEyODGTYLVTs0qC2xYaXLVzr8bzxRPR
	lyytDTtjA479NgMrwxqB2ilqP1jiwqY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 675B54026D;
	Wed, 22 Jul 2026 00:39:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E418F1F000E9;
	Wed, 22 Jul 2026 00:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784680780;
	bh=y4T+aKPpaxnS+ujMYR/jYT/mPnpjNhh6DW0nJJXIn5A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=AK1Hw3SmLevzjCH/JoH2SIgM7swWP4Gt2HRraacUJ8IS55kQUs9s/QyO+ZT888jkR
	 6ZTufHq6CG6vgzXadLNeUebypKQ660K4mFGmJB96nZDpIZiC1nlmHvnLUVqQibY6+5
	 rHdoMJqu6RE6gCj/eBpUTy+g4tmbyBu1Zvu+P4P8=
Date: Tue, 21 Jul 2026 17:39:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kaleshsingh@google.com
Cc: surenb@google.com, kernel-team@android.com, android-mm@google.com,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro
 Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] mm: proc/task_mmu: Use walk_page_range_vma() for smaps
Message-Id: <20260721173939.6bee67b6af17b54961daf4f8@linux-foundation.org>
In-Reply-To: <20260721051903.691848-1-kaleshsingh@google.com>
References: <20260721051903.691848-1-kaleshsingh@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9BACA100008
X-Rspamd-Server: rspam01
X-Stat-Signature: 4c7h6keadxupwox83b3qtgsdzm9k8kdo
X-HE-Tag: 1784680781-529309
X-HE-Meta: U2FsdGVkX1/mHmT38F86U+MgcFm5IpxQoBl7j0LyU0J50HPP4jZd7LgeeKmLATzmqbcvJmd1KWJ71dLJ954Q5eEX564ySkZXxXcvRhc0lg+jfTywE5Z9T9OxhTUXZFmuvWMp6JQtrPScc3Z04yoPJYsqcfXoxNkkCKlsi2vmB+CVZ9NxikjqDl9E/UOTb9GpTk1YqBrKBjF7aD+EwLzck7Ms8kIwf8YU6/XlmHL+ca/IquD0QhaMjyQzd13Pi6Ccx7P3eOkbjk13Onz5PT4D4mJhsGyvsar57pQ2ozF2Kgz9q2Fuh8KbgGSTgtM2hdvaGjwMgCbHhWmOThqtnegR1pYdMguC2JAwk7o3i4k7w1z7hXnYSDalXhg5L5QMbCnDrR0GNvzkLchBrn8FW8OBPwp8ACmALChQ8XLPoYrquZkTvGOuGOY5YRw0fQZ4E/vrjGN6NOGpXsECc91B7e+C5z8hYq+iYnoT9R3jdwa+NStIHlyKIxnB0WDViMfCPHOEjdbdkpAvf1UDCSXO3/jtdO0+SveKFgVGnvITKnUmpbr5rPy0Bi/y0U7eMr88Y6JtTG6dzCb1uPF15K9yknQ/SjYykXxS2ElkrpCxlq4bnOgXE1jTdfYGskEeHNgkU12gJzYWoyFIrEFRu/y5C7L5aY2bb0DSoXkNredn38gqC9wPQ0d1ZZ9IQQIoziqVw3C8tBmShZTDWvO/9dN/WOw2f7bFtYgkQEg48tuau9ir9d13WHsnHbwUiKC174fz1FUkDhS1e8IUR4c6JmCCf/Mey1axTiSm0qta5grAzHPHx7AuPnfU1Qzk55rAU5GSwt3h0fVML3XPNgl9PDNHy38bwQQjEmDqFF5KLYfBITnUzFcLLSMBqH3sjQ7s4bprwPZnq0sY5ugGefIrmoBS8cUaWJNy5KFwZ9PXa/tAzIBBJl05nrk049P7EtfnGb2r2lNoO6AyFHCkzcM3LJnjjyO
 p2lL5fhW
 /NCINMHUL8PuDENW9eiEY3spEe64QFwfut1N6wXTVq/y9U9w5SZ3IMhivvsMB+AsOh4WDSZru6TnalCg6mKDdc6nWJtOlmRkwawJU+mZTc12wfAnWIVSNQhVcnFd5WOIP590NEpaMDftqv5OWsAeeoBiHhNM/g9PRRCS4GxFCG/hkZSANwOnqpEUZtTvQngT5V+fnb64fUv0SA5NYtcCTVnkb8zbjxe0QSytiquQADVM/j20lQf14M8BRZ8lYrCGY7FoHXlbms0iIcxJs3T5uf1qpk1uLkKnIXIshY3lJpyLRXOEi7LgF2owh9S+4T+il83gM7Zf4nWOTBNUiqDHn8xGd+RmhedKShIrYrvlrtw59XorctFUj4CyFknkUmnLruJzn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 21 Jul 2026 05:19:02 +0000 kaleshsingh@google.com wrote:

> From: Kalesh Singh <kaleshsingh@google.com>
> 
> Modify smap_gather_stats() to use walk_page_range_vma() instead of
> walk_page_range() when walking page tables.
> 
> walk_page_range() internally calls find_vma(), which asserts that
> mmap_lock is held. This assertion fails when reading /proc/pid/smaps
> under per-VMA locks (where mmap_lock is not held).

So the kernel is emitting a WARN trace under some situation?

I'm surprised.  The offending patch is only six weeks old, but we'd
normally hear about this very promptly.   Is a bug report available
somewhere?

> walk_page_range_vma() walks a range within a single VMA and does not
> use find_vma(). It relies on the VMA lock instead (when configured
> with PGWALK_VMA_RDLOCK_VERIFY), making it compatible with per-VMA
> locks.

Sashiko said a thing:
	https://sashiko.dev/#/patchset/20260721051903.691848-1-kaleshsingh@google.com


