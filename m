Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D555CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 07:02:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 064146B0095; Tue, 29 Sep 2026 03:02:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F30A76B0096; Tue, 29 Sep 2026 03:02:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1F5F6B0098; Tue, 29 Sep 2026 03:02:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AE3356B0095
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 03:02:09 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8DB0A160431
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:02:07 +0000 (UTC)
X-FDA: 85265905494.11.D178A00
Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	by imf31.hostedemail.com (Postfix) with ESMTP id F1D952000A
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:02:03 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=dgu-ac-kr.20251104.gappssmtp.com header.s=20251104 header.b="sr/7opcr";
	spf=pass (imf31.hostedemail.com: domain of ts930@dgu.ac.kr designates 74.125.227.171 as permitted sender) smtp.mailfrom=ts930@dgu.ac.kr;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790665325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=SgyANliL/9OSzsbx4LMgJ4Uc8A7rCA+xzM8G8mL5nTg=;
	b=jP4CLUNT7sSL79ChLBT6ivLwz4uBYaTLzrbWsI8IzoOTGm+Ka2O9kstrKWTLGXxGYJnwzr
	Nrl3KrHqPE9nT8JSAtHTQvup0zKamQshCBzLyD+X93098cCDPbN6ayaQJtd4YgCEuFWeh6
	4HebPUyG76xVJNNRpgnIPbrI/7buuPY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=dgu-ac-kr.20251104.gappssmtp.com header.s=20251104 header.b="sr/7opcr";
	spf=pass (imf31.hostedemail.com: domain of ts930@dgu.ac.kr designates 74.125.227.171 as permitted sender) smtp.mailfrom=ts930@dgu.ac.kr;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790665325;
	b=8p8hrxe1gqaauG5Q0uDEdub9PVq/wsgYZajJAo5Os4Y4DjF9VtyJMAokCIcCItshXwscXt
	TApWZZHQ0CzxE/i3omirzG8txJdb1DfNoKQFLcWFANLEJ4IVrRig5R2eHKCyZ1VDkzsQbZ
	hdRvEmgOXGUlUYktOJlBApMNzwEgbs8=
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-396ccb1a98dso2170265a91.0
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 00:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dgu-ac-kr.20251104.gappssmtp.com; s=20251104; t=1790665322; x=1791270122; darn=kvack.org;
        h=cc:to:message-id:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SgyANliL/9OSzsbx4LMgJ4Uc8A7rCA+xzM8G8mL5nTg=;
        b=sr/7opcr6rdichns43OUuV7DScePj9KdMeO8uBczOAwxSvSweOjs8uG2UCIHl2m3wx
         YiFT0f2i8/DM916NpCgq4szqlOA6CqXgkUuXu2cadSOT/uOncpCe9kaHRgAqHLZFT/EP
         s5VLAzSG1XUzjmkpcB9VMZud1YlCrpT2ucVfyyt+64J9WZcoUXKZbt5SejMzNB2+baXB
         DG5GSagQ9/Xyrq0P3lzyiMhyF+IvntG5Me2physUwc6xXs0cDIY6ZI1DBLUAlZkNI3Sn
         CjBLAsscn7w7g45GJXFModpivJT2xIosLJtheKpHLNQYMmQUHAoL36LqYOP+ISXCpGLR
         xubA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790665322; x=1791270122;
        h=cc:to:message-id:subject:date:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SgyANliL/9OSzsbx4LMgJ4Uc8A7rCA+xzM8G8mL5nTg=;
        b=qNAG8e4X03pYwpB0pS3gICqoFNoupGpTYpr4QiThGNs7nQt4nK/rLGA7o8C83jpf9U
         szgrX+V/t/nzny1Tp6oYoTxbT0IpFEjVbCV3FsYnqS63SGNutFPgwv0YHbqzjgPmVNdH
         iOQMFbVxrtldDvNncmWYzcpWDkwLubmiHvEh8CLzvsNW8vxuNe4h7/sJy15I4yKnpw8b
         B2+bhXNaa0aCRvQyLNaUqzya5ytRhULjxQyHihgPCe1o8YEg7aXCVWoTIcA0WCdu5JPy
         pPqbPAGiWA4T729umg6pkQD+uuYkpwY6D5mvq6N48PeVY7TVWuYAIu+HNrv75HIe+8TH
         oyvQ==
X-Forwarded-Encrypted: i=1; AKwUvBzSqxvfGrESFl8erZ/aSpp9T4QvYjl03cFvZY9PA4CC9to6F1X7KDeNNi7vxMsEjKjGJpnHt0FKhw==@kvack.org
X-Gm-Message-State: AFq9FYLFJ5OShq67zNZaSq7A51kIOQ3q/94DUCl5Mz/GwzpjkF8km5af
	YWlcYAVbk+tg4SEKaOXR7Qa2ExHpI3h4U53ujnvH4G5REEdns/p/WHAue49AyeTxpEU=
X-Gm-Gg: AYBFou0zh3yXpH976JgVuBeXpcJxy8Lnxm4occqLVIURsnT+Z06VyhJwhNjDVNM8Y+e
	VebhPgsiGbGQwWCzrL4NRzcRgW71wrcH2u/bCmgaxvp4iTktSpw0B+w2jnnbtDnullnsvThpevh
	VWtE4p+fs6FRfXli/S6I/yVTR7DoG4u75d5cZanSd+dsAGm69svUwNogOM0jEHO7rjs4oYtw8ZS
	39atZUrAcsj1LxXJEURPlH/EwjQbfs5/CEDIj/NbzsnsC8mCxnH1gtGWyQEL9DRRHAzvaC4/Kyc
	0m6IAsO7S0AYXbgx35JPT+/cj1JhTcYBA4FgjdEjQr1CGkN02VvyTleVQBdZJBOZmAYJslaHfPn
	OW8uWTDJi0XVNlYue+azz12vdHi7s+0TohMVpsGvEInyrPaDPHJeBkv4TV0GCk6Hmb2crDLoywD
	EedJqhMOJZ05zSegljVZYALkeDpJvSrUfCio4APebxjC7jWMidmFxk5rk=
X-Received: by 2002:a17:90a:902:b0:3a0:d9ae:4f3c with SMTP id 98e67ed59e1d1-3a0d9aef037mr5103648a91.18.1790665322087;
        Tue, 29 Sep 2026 00:02:02 -0700 (PDT)
Received: from PC2. ([175.193.106.181])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a49869b9fasm4329281a91.12.2026.09.29.00.01.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 00:02:01 -0700 (PDT)
From: Park Tae-sun <ts930@dgu.ac.kr>
Date: Tue, 29 Sep 2026 14:56:34 +0900
Subject: [PATCH] mm/mlock: fix zero-length request normalization and integer
 overflows
Message-ID: <179066531783.50175.13377521828379196177@dgu.ac.kr>
To: Andrew Morton <akpm@linux-foundation.org>,
 Liam R. Howlett <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Park Tae-sun <ts930@dgu.ac.kr>
X-Stat-Signature: 8tm7e6xau6mw53anpwiqgdo7jyjxru4j
X-Rspamd-Queue-Id: F1D952000A
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790665323-678509
X-HE-Meta: U2FsdGVkX1/Qf0lVhG637rWTELWg4DDzpGi9SE0C0F042RdKqTLfRXAguCyFurrYdrKj1L9lPfcs/5skTwHnx6wSN2YUUCacyvS7NIumBb63fUuIBNYS0LowQjisMy7g8w4EscqXnjh8clpiZN51fr9uDTorx3Mts6izqxEF/WjoZMGGGi8IauEOF6L7LL+ljUTLhj9fSZ2DQClHw2GMUMAvH/1evO0fBMvv0rCffowavBjCeXAF5HpkNgv0IdcMyaj4TWIl2g6CAR0dI2rn8tbDFjrHurfrKTjk4LtISmT2BUELMECF32r88T5wN17SW9ZeSr3FWiO3V6gVcsW2EWWI3uB4Ai64QmjfIFbc9CYhFNCwiWeBz56UmYGHH0tJMbQc1RmqrzZHnOyauxkJiMrSR96rMAPr3TklmOOO2cwEJPWjadmocOJbDrha0MW5+9MFqCibFLnnOSH3LD/hevBhoFQvPuzae5dDpmALQY7o13pTbTMqovX5u/x/E3upkgFPM36KJl/y4b/9FLOyxc6zpgAD+z61r/lPeWrhKk4qgPEK9GfZ3qPtUTYwmvjUu2MnN9jC0TaHOqtE6Mb90YdRw8OeqNAEE6DUzi5aqrpQ5oo9JyP1NsS/rqdNHklS/yMs8rg+REbpk25WDouE0RYw4VwuIYkT3ZfHdewT2NHUPbKOejbbZMYvsR1aXWK9DxSOwmETzpfE+p3OhZrltvT/iz72v9LfDVssrxEiQSeeLoslq25mDlJehZu6yiVVC4zOl1Urfsi6A5GlTUMWOAzdE+uv9nmL3ktRjpaUHsRYr6nWfNT7NjyNB2oi2athMvsTUIRosiFlLOUbZpvnSykue6kWIOpM6sHGEaHJCs8bpdLj+NSVdJUKWyensqtbLFz/IcxPl0WVWWfu4gbKyI9VwlNN+o4U/BL2jG526UMXMdSD2S8VZAQeDch67Yz3uFq64baIvqSazszo4Nr
 tdx18b+u
 cYBVOj++O9itByYwV9+Or2JdHj1tQo2wGbmyOY84QrMJ0dma3jMHdrNSbo7xuKfv2MoWojl6nDavSADfVK2DIVMFuObWCWKLaCxXaIW898qrTo7VSRVyINWXqRigtiy1HZn+ioDxsN56D5Nyd3b9kcxNBRJfUYDAcUUfxtwSuA5mTcCOKLeWInxnRuN9JKvLHvzhsPASWE7xWJzdVS9kA6iwXhPeUVISGMU1mNmVBNJQ9OeyNA/0VsK3yD3x9+OZ71J1ffeX1Vb2NcRy3EJLfcrxAfH20eEADZSSg9G7IiGm3ZPHtOmBYu8zUgS9eGDECli6KFyKBLX/D1bJa86vwVXHJ5wO8+E3m5qM/kyQCqQ+J77j+RDW3ohS1+Q8825ss4iH2UkS+GQMXoQDSDIrOTJafVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mlock() and munlock() currently normalize the requested address range
using:

    len = PAGE_ALIGN(len + offset_in_page(start));
    start &= PAGE_MASK;

This performs multiple arithmetic operations on user-provided values
without validating intermediate overflows.

First, a zero-length request with an unaligned address is incorrectly
converted into a non-zero page range. Because
PAGE_ALIGN(offset_in_page(start)) rounds any non-zero offset up to a
full page, a request such as mlock(0x1005, 0) falsely locks an entire
4KB page (or fails with ENOMEM if unmapped), and munlock(0x1005, 0)
silently unlocks memory that should remain locked. Conversely, an
aligned mlock(0x1000, 0) is a no-op. Zero-length behavior should be a
consistent no-op regardless of address alignment.

Second, a sufficiently large length wraps around to zero during page
alignment (e.g., len = ULONG_MAX). Because PAGE_ALIGN(x) is defined as:

    (((x) + PAGE_SIZE - 1) & PAGE_MASK)

when len is close to ULONG_MAX, adding (PAGE_SIZE - 1) wraps around:
on a 64-bit system with 4KB pages, ULONG_MAX + 4095 wraps to 4094, and
masking with PAGE_MASK clears the lower 12 bits, producing 0.
When len becomes 0, the subsequent check in apply_vma_lock_flags():

    end = start + len;
    if (end == start)
        return 0;

evaluates to true and immediately returns 0 (success) without locking or
unlocking the requested memory range. Similar wrap-around issues have
previously been addressed in mincore() and madvise() by checking for
zero length after PAGE_ALIGN().

Finally, address addition overflow (start + len < start) is currently
detected only inside apply_vma_lock_flags(), after mmap_write_lock has
already been acquired and memlock rlimits checked, improperly returning
-ENOMEM instead of -EINVAL. Per POSIX.1-2024 and man 2 mlock, arithmetic
overflow of the requested range represents an invalid argument and must
fail with -EINVAL before modifying VMAs or acquiring locks. Note that
apply_vma_lock_flags() already contains:

    if (end < start)
        return -EINVAL;

but this was obscured because rlimit accounting preceded it.

Introduce a common check_mlock_range() helper to:
1. Return 0 immediately for zero-length requests without taking mmap_lock.
2. Validate intermediate and final arithmetic additions using
   check_add_overflow().
3. Reject lengths that wrap to zero under PAGE_ALIGN() with -EINVAL.
4. Detect start + len address overflow before taking mmap_write_lock.

Signed-off-by: Park Tae-sun <ts930@dgu.ac.kr>
---
 mm/mlock.c | 55 ++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 47 insertions(+), 8 deletions(-)

diff --git a/mm/mlock.c b/mm/mlock.c
index 39215a3eab1f..203017797076 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -616,6 +616,47 @@ static int __mlock_posix_error_return(long retval)
 	return retval;
 }
 
+/**
+ * check_mlock_range - Validate and page-align the requested address range.
+ * @start: Pointer to the start address. Untagged and page-aligned on success.
+ * @len:   Pointer to the length. Page-aligned on success.
+ *
+ * Return: 0 if the range is valid, or -EINVAL on arithmetic overflow.
+ * If *len is 0, *len remains 0 and 0 is returned; callers should treat this
+ * as a no-op and return 0 immediately without acquiring mmap_lock.
+ */
+static int check_mlock_range(unsigned long *start, size_t *len)
+{
+	unsigned long end;
+
+	/* Untag user pointer (e.g. AArch64 TBI / x86 LAM) before arithmetic. */
+	*start = untagged_addr(*start);
+
+	/*
+	 * A zero-length request must not be rounded up by PAGE_ALIGN()
+	 * to a non-zero range when *start is unaligned. Return 0 so caller
+	 * can exit early without modifying VMAs or taking locks.
+	 */
+	if (!*len)
+		return 0;
+
+	/* Guard against addition overflow between length and start offset. */
+	if (check_add_overflow(*len, (size_t)offset_in_page(*start), len))
+		return -EINVAL;
+
+	*len = PAGE_ALIGN(*len);
+	/* Check whether PAGE_ALIGN() wrapped a non-zero length to zero. */
+	if (!*len)
+		return -EINVAL;
+
+	*start &= PAGE_MASK;
+	/* Reject address wrap-around (start + len < start) before taking locks. */
+	if (check_add_overflow(*start, (unsigned long)*len, &end))
+		return -EINVAL;
+
+	return 0;
+}
+
 static __must_check int do_mlock(unsigned long start, size_t len,
 				 vma_flags_t *flags)
 {
@@ -623,13 +664,12 @@ static __must_check int do_mlock(unsigned long start, size_t len,
 	unsigned long lock_limit;
 	int error = -ENOMEM;
 
-	start = untagged_addr(start);
-
 	if (!can_do_mlock())
 		return -EPERM;
 
-	len = PAGE_ALIGN(len + (offset_in_page(start)));
-	start &= PAGE_MASK;
+	error = check_mlock_range(&start, &len);
+	if (error || !len)
+		return error;
 
 	lock_limit = rlimit(RLIMIT_MEMLOCK);
 	lock_limit >>= PAGE_SHIFT;
@@ -689,10 +729,9 @@ SYSCALL_DEFINE2(munlock, unsigned long, start, size_t, len)
 	vma_flags_t flags = EMPTY_VMA_FLAGS;
 	int ret;
 
-	start = untagged_addr(start);
-
-	len = PAGE_ALIGN(len + (offset_in_page(start)));
-	start &= PAGE_MASK;
+	ret = check_mlock_range(&start, &len);
+	if (ret || !len)
+		return ret;
 
 	if (mmap_write_lock_killable(current->mm))
 		return -EINTR;
-- 
2.43.0


