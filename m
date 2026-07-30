Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E654C54FDF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 09:06:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D0596B0096; Thu, 30 Jul 2026 05:06:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4804A6B0098; Thu, 30 Jul 2026 05:06:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 398996B0099; Thu, 30 Jul 2026 05:06:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0DE066B0096
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 05:06:54 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 731644094A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:06:54 +0000 (UTC)
X-FDA: 85044863148.15.A6C6FFE
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	by imf15.hostedemail.com (Postfix) with ESMTP id B370FA0008
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:06:52 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YDYL2iL7;
	spf=pass (imf15.hostedemail.com: domain of iprintercanon@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=iprintercanon@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785402412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HdEg3D4TKN236ca6jYDlc0P5L4Wo24cZPSMmhVdO09s=;
	b=lwfoqEAmkqJm/dWZ3BDfs3YJFkJTeI6Is3ZSNZeeFGUEQwCQzSf8uapY4oHjmsVFB3nHHn
	WXQxSYlAZLFbQSSEyXOcXc5rzF4nXIUgMbSUKq7MW8PiiMa84G9sn4cj0n/R3/PLJUMS+V
	T/t/Tl4kaOChcD28qd1Vl2wlXcQAXCE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785402412;
	b=QBINpFg3cPQWPyZaMNleneID+CYMGA3FGt4pMDAXvdo3YtDSih84SqxmLbpaLT78PVJ6ur
	hHUHuI7mA8l+aJ4dN9hKFwkiv0b9RBo63TH6+NbY4NiDl/u18zBZt2RHxUS+9bkISpKfkP
	UgrPbKzRj9P830lrdYrluwo5YHbk2Tc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YDYL2iL7;
	spf=pass (imf15.hostedemail.com: domain of iprintercanon@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=iprintercanon@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-39f6265a5bbso9933201fa.0
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785402411; x=1786007211; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HdEg3D4TKN236ca6jYDlc0P5L4Wo24cZPSMmhVdO09s=;
        b=YDYL2iL78W5iQjXANRYVUVcMENriwAUrqq4KnLQ2eanjxl6aRdHzzWeIm4q8Olfu88
         c2sbfrAZC4HVUiXSlyOnMzI5XAeaSOEO4EqmPqBOCvRUVMCsPsDMY33RVoonK6lvHgoD
         pUNvY6e9F3iOAGwAisTa0nnFyYzYLcnT3I/yhl8rfe0F/MuK+WVSIgT/RisifHU0t/6Y
         YMf2VmkYFNhgCdhP/7Zhp4jBZOYz08YyEuFq0nEzwI3xyurM+O2s61s+KsmYKYBmsaI2
         ja8bIoB7xIoSQldIF8x/oQ4fekVR7F+oD0bqkehjBFStSk1WlWOcANb684yPCTzY0x8u
         tQ/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785402411; x=1786007211;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HdEg3D4TKN236ca6jYDlc0P5L4Wo24cZPSMmhVdO09s=;
        b=loSJ2onHzav4xQjLqRwfOvNWjcpZZaK6GiSQcoJFHlGRlrxOvPuSA2sfEzVZR4PXBJ
         46+Qn1lqMSEHHCwjqu8j5pQXQTTapSnvDKCa5HJM95/F03pnNF/BOry5GiOb0kyds9eT
         YQfNVMBYFNpaosBcXo8/VvDmrNnunCf/cdwlnA/joVYcpWf3RwGcZHxYQsmbbbtIeuJQ
         0PcbVICa8lHVnCjUrGmC+haDz0ogGHyzYdmmbZX+PEkSQUc1qg8b0hw3R5AcrcUqisP2
         bUmajNJ8NjXGoY+UBLVqp960PhdcwzZySLfnW8uojtau1sjcjWUvoILklAYK2xlIFLCj
         XrfA==
X-Gm-Message-State: AOJu0Yyut3EEY/a+LIhY1yzv8uFwZaKVUpuHtprxtsv5h778BN5QtV8U
	cbiUZYBuN4jKMaEj7gm4MOuf8V4onmT1eSKNeVK8IwjaKOjELITPbutkSp4Ttw==
X-Gm-Gg: AR+sD1190gSR3sp2th4EIXJf5X+YSXH5+9KyhKCFP7y31oxF0DcQmtOC3uhUZDfGirK
	pvT8fv5pfGwcr0CRs7dn9s5UQnHVnpb8CiABkkgY/K0X4A8L0HX0AjNQw402clhPSY+DEcdkRh/
	3jkNcWhyTzAepm5C0X98orVeAUCpd/gFCLvQuUuI3msAgddfSlzbDqWDgsZaK4rYGxApTqfRnVu
	8U5UABHCUgH369H/Pw98+wwc1JKE1WyhMxe/sjVboKKfmZqgc9DTO4g9FeCjQahNf4vClLmNP9h
	7atCj2x8fvtcbNv5IBNthztLxsE26VfFJSjrjFXCU0eQxOF3HBWsx9jFIZwTwvL/h1JGo4VsOFS
	xTz3pITF3J3cwggryI9xlP7KzNd0cMkaytA/SpdvZhCl8L/0rBjteYd2hDyPirOQLLdzxCEK+62
	LkZNwaLSfdvpskbmwIQB9NTHZJoumsd89O/9B+qtOTWwpbA5cCL71uu1i8BVef4jtTWo6LSso+j
	H5sprqV+/qxL17KDYj7ERtr026vEBJUZUF9l+A7hABAwOzv2VVLF2szoA==
X-Received: by 2002:a05:651c:18c6:b0:39c:a346:8a36 with SMTP id 38308e7fff4ca-39f6d0fbf2fmr3486971fa.8.1785402411014;
        Thu, 30 Jul 2026 02:06:51 -0700 (PDT)
Received: from localhost.localdomain (46-138-176-102.dynamic.spd-mgts.ru. [46.138.176.102])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-39f6ac80d6bsm1928641fa.29.2026.07.30.02.06.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 02:06:50 -0700 (PDT)
From: Artem Lytkin <iprintercanon@gmail.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	urezki@gmail.com,
	willy@infradead.org,
	shivamkalra98@zohomail.in,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] mm/vmalloc: fix 32-bit truncation of the area size in vread_iter()
Date: Thu, 30 Jul 2026 12:06:26 +0300
Message-ID: <20260730090628.65814-2-iprintercanon@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260729175708.7074-1-iprintercanon@gmail.com>
References: <20260729175708.7074-1-iprintercanon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B370FA0008
X-Stat-Signature: o8o3bxu1nhihu4a7cemz7mqnyxrxc18z
X-HE-Tag: 1785402412-405548
X-HE-Meta: U2FsdGVkX1/C+3LwVSmVtqyoNuNRpbUnhUTF9B+KMN4ZekDhtwVjwOLTz6TVigJsCaDY8jQ//OUzvGkQvBiKjoXAui6AgQY5CFLbOEx6p8W6zeC1wkkHDSm+Dh3bpMeeV8urzeJFXYUX1XDUGA6KwpOpliVeMQxy5AT3+giGZtQtsKgu0SudA0z5OMJQ6A3cWL+STLSO776PykaLTfAaIFsVXM5C87+9bzbGHn7Ntg8TdSgGic/X+lzQVxUy6cLHMvgRB68pPfZoXBXINSPxk/am3Hfw0NvS3qrIbOowfN4RgBp/YWKf4q9sW9f3Y6oq1B9py9Jf+TSu8hax3+x3qmpCjOPngyfFNmrNj4t3iG7dlkxlexVTN7moNneLd79cn2YtlNIYGy5dovhJ3wxURMYtt4zN5gbrJcmA+WJYZGLc8aIym56wGIoh/BkDuAPQS+wMQFwtqrRRbIFr+gVuU6Q6OqlzpMc+zviBJRsI/MRrAOfWxvnC9Hq1PmSkBVXX6u4EJJiHMqoH0za1hRYC/oZv3TYv4xTWnJOnNPFrzaGuFcuN5EI13igI7nEUCmZXfHALuBnvFoYgDgYCTbDryhr9RcC9Zv8aoB5YbHWl6hVa/0fpF0YdRKiYwxoKUSzQh7AUHtq8MmisOhedFN3dDt5C8xVm8NkFLkNDeneKdmbxK1r65BOynz3BskhlczjFpy+1qGX/uCUjdcjzVYU2zskA05undAvPd61U9s++UEHQR4ASXvuMUisRwL4rJCW0zT8B1d4KAUVjNgJE0d8GMKO4x9VZ5eJfA513RYaqz5Yd4NalBN+9zw2XZ65JoeDe58FAoAF8Pi0Lr08/nC1ttd76bPkEgTf+1TQ8DubdwGHWSKUwwX74XWM08x+ZBjQh7W9qN1QuZEtaLSsMs4L8QunsJxhMghhGzLcAlsKvQU4EnxiPyDRqC8tLXE3UDXKtvuula6PnBzfP3ZukUxS
 tGZOsmHa
 uqN+S2ud02ZuD9cd19dcgNiWTu+f0LkPMleaRtBGKGPVOxkzxzyKwmXKrGs5XQh6T0Pf4I4+l+t4WTrZfW6KBOk7wg+0MhLR5YiJ9wR9ZkvME0bCzBTmmo1i6PHRiQEG0xFUCRoFl+gkxsWV7e+uuA2VsYLzBxkEKbDP138EJxKJohFqBIfcZFgScBFrFDSvXyaZdzyZqHlG0xsYrNxi30tWZJfzrJ67tp1j3QVFZ8ch8x76OR81jFtILCf4JbKmBjMbcEH+EI3eo6cu+rpb9HZDG2/W4aO5nPqmjEGHYPu4FLiajG9cGgeoIL1wyUlqYoF2fNmf3HEL8IohjvBXHLFgdmaUdoxGQA67mrgYBkXqjTbX5cHSheM1scUsyKN89j+T1b9xzY3sUEYmQvUfxIQ4sCDFnFjt4CmaC+dvUfjeCSoMZQv8wWjW6e52MV3/8pdYBVP6PLwlOdgssosh0qgVrSTNkzH4DIYy6zHjnbcEbMzrfQZRq3Zn/sNmQTDPCaZQfgXioWAPMDzZ9oCMj64AgaYMmMgSvcrOUinQ8jmdV9bI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 0bca23804632 ("mm/vmalloc: use physical page count in
vread_iter() for VM_ALLOC areas") replaced get_vm_area_size(vm), which
returns a size_t, with vm->nr_pages << PAGE_SHIFT.

struct vm_struct::nr_pages is an unsigned int. The shift operator does
not perform the usual arithmetic conversions: the integer promotions are
applied to each operand and the type of the result is that of the
promoted left operand. The expression is therefore evaluated in 32-bit
arithmetic no matter how PAGE_SHIFT is typed, and no matter that the
result is assigned to a size_t. Once an area reaches 4 GiB the byte
count wraps, at 1 << 20 pages with 4 KiB pages, 1 << 18 with 16 KiB and
1 << 16 with 64 KiB.

nr_pages counts base pages even for huge vmalloc mappings, since
__vmalloc_area_node() requires area->nr_pages == nr_small_pages, so a
huge page_order does not raise the threshold.

The only limit on the size of a single area is the totalram_pages()
check in __vmalloc_node_range_noprof(), so any machine with more than
4 GiB of memory can create an affected area. One example is the zram
metadata table, which is a single vzalloc() of disksize / 256 with
CONFIG_LOCKDEP=n: "echo 1T > /sys/block/zram0/disksize" allocates
exactly 4 GiB and needs no 1 TiB of anything. Sufficiently large BPF
array or prealloc-hash maps do it too, as does
"modprobe test_vmalloc run_test_mask=1 nr_pages=1048576". The KVM
dirty bitmap is one path that might be expected to reach it but cannot,
being bounded by KVM_MEM_MAX_NR_PAGES to 512 MiB.
alloc_large_system_hash() can reach it, but not on its own: it caps a
table at a sixteenth of memory, which is 4 GiB once a machine has
64 GiB, and the automatic sizing stays orders of magnitude below that
cap, so it takes an explicit table size on the command line.

The effect is confined to /proc/kcore, the only caller. For an area
whose size is an exact multiple of 4 GiB the computed size becomes 0,
the

	if (addr >= vaddr + size)
		goto next_va;

test succeeds and the whole area is skipped; for other sizes only the
first nr_pages mod 2^20 pages are read and the rest is skipped. Either
way the bytes are zero-filled at the finished_zero label, which returns
the full requested length, so read_kcore_iter() sees a successful read
and userspace gets neither an error nor a short read. Live inspection
with drgn, crash or gdb silently observes zeros where the area is
populated, and cannot distinguish that from genuinely zeroed memory.
Before the offending commit the size came from vm->size in 64-bit
arithmetic, so this is a v7.2 regression.

The truncated value is always less than or equal to the true size, so
vread_iter() can only under-read; there is no out-of-bounds access. Both
the affected reader and every producer above are privileged: opening
/proc/kcore requires CAP_SYS_RAWIO and is refused under lockdown. This
is a correctness and debuggability problem, not a security one.

Fix it by widening the shift, which also makes the expression consistent
with the four (unsigned long)nr_pages << PAGE_SHIFT expressions in
vrealloc_node_align_noprof().

On 32-bit a widening cast cannot help, size_t being 32 bits there as
well, but a 4 GiB vmalloc area is not reachable on 32-bit either. On
64-bit the cast removes the truncation entirely, which is why replacing
get_vm_area_size() introduced a regression rather than inheriting a
pre-existing wart.

Fixes: 0bca23804632 ("mm/vmalloc: use physical page count in vread_iter() for VM_ALLOC areas")
Assisted-by: Claude:claude-fable-5
Signed-off-by: Artem Lytkin <iprintercanon@gmail.com>
---
 mm/vmalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 26f32949c2f2e..34e10b825889a 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4895,7 +4895,7 @@ long vread_iter(struct iov_iter *iter, const char *addr, size_t count)
 			 * mapping types (vmap, ioremap) don't set nr_pages.
 			 */
 			size = (vm->flags & VM_ALLOC && vm->nr_pages) ?
-				       (vm->nr_pages << PAGE_SHIFT) :
+				       ((unsigned long)vm->nr_pages << PAGE_SHIFT) :
 				       get_vm_area_size(vm);
 		else
 			size = va_size(va);
-- 
2.43.0


