Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC0D3C53200
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 13:22:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BE226B0088; Sat, 25 Jul 2026 09:22:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 445AC6B0092; Sat, 25 Jul 2026 09:22:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24A446B008A; Sat, 25 Jul 2026 09:22:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DD5216B0088
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 09:22:30 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 817BBA1215
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 13:22:29 +0000 (UTC)
X-FDA: 85027363218.29.F866A40
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	by imf11.hostedemail.com (Postfix) with ESMTP id CEAAE40004
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 13:22:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TcKW4x6t;
	spf=pass (imf11.hostedemail.com: domain of iprintercanon@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=iprintercanon@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784985747;
	b=pZGYFzyF6QEyDu2hcddpgB6N47gRjzRgTaUehynhWIaoi/OpMByvY8EuPXTDjnzV6AIUlT
	KMIc8uxmWs3AOnHDUcErQrBXcZqz1kbC6i7lojeqJP9iZacwi+fsH38YPLjYJBoaL7lWgZ
	8+PnEhdUwzaWvjhJzhT2lyluH7mH0Aw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TcKW4x6t;
	spf=pass (imf11.hostedemail.com: domain of iprintercanon@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=iprintercanon@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784985747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Kx85czVOhBPoFkPfr8PjazcziqRbOedPhUw+46jDybM=;
	b=JyomuKVRNit/IfTat8mjFTJuZZhTYzrazNh/REzwB0lPavv3yDhz5SQT0sOrfjqbamDz1q
	+g/PQoic/TTK3oT1IsZMJOoJMF3nyN6zqiE+j98KkGRGT87WLB27P7pRHt4hESvZht5p50
	aKIv6Yk537kQyEpayFEW9NeWZd+ch98=
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5b0117dda13so1325464e87.0
        for <linux-mm@kvack.org>; Sat, 25 Jul 2026 06:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784985746; x=1785590546; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Kx85czVOhBPoFkPfr8PjazcziqRbOedPhUw+46jDybM=;
        b=TcKW4x6tkV+sMJbOCkFOZOFNOAdWufYLhqIMmSc1MSED3Y8+1qM/KH1KgDBHWqLCYe
         qfDDhK5EDHcs7GZeb8khEMttWgptkg+e6amIcrUeQtdEVejfpswQVhHtu9Xli2dQ+UcX
         pL93RBIluqjGEKzI/pmeqM2JfqfyDLnTD+Iw+HtJe8dpfcg8C8BO6CWoZsNyrcHQnBO0
         v03NBbDFIhvbHqT9CJ8Zpown2fTeb3+3+mnizouGJcopl9jhpC14egcD+2Bq0TGZwK+5
         Cp3OdTXlAHw0/5Y2oiPz1z7SGPciZp2Wk+wqrGn+Yaf0V4b/9fWYfnStQOQGb9pNRtBN
         ynEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784985746; x=1785590546;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Kx85czVOhBPoFkPfr8PjazcziqRbOedPhUw+46jDybM=;
        b=WN/qLXjt3WAdHk/InPrRsVcss/1FQ4/SFOGgZFBgB9AlUuBkO7n3fbEIa9ZNoetugd
         mcIkWcot7h4oJgY1Pgk+uvIiIgcGk6If+KeoYVkqN4OEUhdBgMHJUmMVNn42W/PaGHZx
         AAn7HfR7D6HrVtNgfjEokK2yYRB44QC8JxjEmndyh1PV97Z1hBBROq2AJviHz+j9mH5X
         03bq9Rw4VMhLaOLX0wzG0Uj3iA38g1kRyIK3TImc16U9sWjBcB8jBpQiDtNXcRX7AtK6
         0LvzVVXylX4Yxb3Ke2TyAohGogtnv4ljDd9nR4bl69hwubKzmLDsb2psM1+UF2bx6SEl
         018Q==
X-Gm-Message-State: AOJu0YxikxCvPq7x81pOBk9ranFDEFTGs9AOnj4FwFuGVup/xt4iuK1G
	hBIK9k4s3zE+mjYTA77FMVuAEKD6Bn0+8uUyU94AlpprCpr2oJQR3tlG7IJv+GEU1OQ=
X-Gm-Gg: AR+sD13swO4bzN+gcOMl8CBAkDK8fygK5xHEVQEt3Nu3vOVEpjabNs6EGfpVaKJecSS
	3RhMPo+GnwdEYYm40gNxBGcS/IaXqHLSm3hK6ph7S20rHK40u1YrkI4hi6zljiD34bHur2S7HRr
	N0IfEZ/3uCllQbpYF7kyhMT50ouK6Oy0o0QLV+iH6T3EKa+t4/8RRBarJtHhVYxT/KPE/Oys2G+
	GIQTr0SLtKPKSx9ztGCwsggU834pDqxdfurc+Q/bVixhhGt0GC3WdnwHSq4x7yn0jXeTlsE4YW/
	HDrouvFJ/TGbtPRyAEj+Nf+1Wxwx7u5TYYroXHDPtegpAIrqWLXjV1O5G6OmQczpVbzQYU7znvL
	qyuaDyec+jzwZKjdaI5pWLpQGV2ys73VqdWm7aeNbZuOKKhx9OFCKEpJlsttyoIvSomwpEfDid/
	EhFu7rgkl92FsFmdyMq2d6fX9tbftB9RdpJyc9+/Y/lZahsuQBNWziNcP1YWcx3pmAnLg9Qcc=
X-Received: by 2002:a05:6512:12c7:b0:5ae:bd65:9e04 with SMTP id 2adb3069b0e04-5b2c1af528fmr342408e87.8.1784985745841;
        Sat, 25 Jul 2026 06:22:25 -0700 (PDT)
Received: from localhost.localdomain (46-138-176-102.dynamic.spd-mgts.ru. [46.138.176.102])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b2be1d8509sm417670e87.38.2026.07.25.06.22.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2026 06:22:25 -0700 (PDT)
From: Artem Lytkin <iprintercanon@gmail.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	urezki@gmail.com,
	shivamkalra98@zohomail.in,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] mm/vmalloc: fix 32-bit truncation of the area size in vread_iter()
Date: Sat, 25 Jul 2026 16:22:00 +0300
Message-ID: <20260725132201.88279-1-iprintercanon@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rhqwqwhkj1pyth3ddapcjyob3qz4y3to
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CEAAE40004
X-Rspam-User: 
X-HE-Tag: 1784985747-160339
X-HE-Meta: U2FsdGVkX18qIDT+/hHdO6rkJnXk/gqnCkgDXjKruVgRMZvtq1lF4faK6QhUSCLM/h6lkquSJPRi+Y6MZSk1OHkDGWhLQpPyPqWcmjkIUocT4RDmkQ1HfwqwG4y0rEVuk9ZbJaOGni4nH099zbo3uGuM27Qt3+b8g9OWF9mrP27vvZL91pIqCWAzfbf6o+ksta96OBQ6KBkhdmDu0sDjS8ir53YTS3SyS/SHWDZpEp5yUgOx3/f/2TiTlHh2NryqeG3yAuKqncNxZbEiNgtrfOSabv68SNow6h468f+bdnGwJbwckFYYq87xd6UWquQIJTdWVUjiKgvyZl2vCS11gctxKMFKFD1KqFIISJ7Dk0+8VatvM0R5U0A4qu05FMehzlkkT20AjScwBfoA7roG0lR0muLmWkoZU7M3qRG5cM+/hUyzaxvyDYSjISOoLRO0COBdLI5aXXXK1PeUxdQ54DTYioazZNlPqQZR9O+P3FWYAl39kYs5SycZoMeVJ1dtl35HlVi1Rv43udbvLq9uG4yko31FLAjT6vEAGoJ2sRIZJ9CQLk33dj6P71/NPyYqc+//aCXkx/b0Z0jbChY3H8LOjAX3qCh//vhsGg2lK1IjC6/i0Ey8IE7+uFVelSAgiuV0tvPFRVxXGtlb3UnmaqILO8IYIYu1KvhHF/LiW/5oeioxMdqVb1SPu+fRhzlCumiM3N1i2IhDs8OLua23Jifi/5tAEFGtXSiqPMbsuMdbGl/Xf6UWxE4jXZ19hAEYnXrWb4vXLv6ld+xTeBdKwf1hbxvbMtE2A8TRJ9+Yje10vz8XGzng5H3lGkXaGwPYdVUcZx2BTzmQh1qlnH07gUhj+4vX5yuS3xPhyPtQlNlB6DhtgKPB+q7ubtkUI7qLEJqboHkNnrdfbfIT5vWcrgW6H7eDBm5qBXgVFnOKA6NQNUewTZwLN+GS397AooaixrrTlx4bzt+x9olHLXg
 Cvk1f4bE
 TUaqeKbS3CVajkMeE8gS02Y/2CsmnBv5p3Ue9i7k9jPtmnAiAXPYWDtAjexnbMHLLfG6et5JF7qcqPSy7fltwFc4qS7nab+9Vu3SPjc/IXZhAS7cuYIOY1RigJBmJSQg/heaWe21bGHMNOuMRWt/fWf+fqGqtpiGHcETYFUgGmXTJcfmX4W0lIl5eCMHcsCZsiQHjDNLirfeojfBGBNb9ppZtPwzlrczWiZ+08Mm3n1o1cvCLUV+2JDWdayfp1HaJt32/gJ7byzt8I2EpZdHMhwIthZMBFQKuYJF/4T2zYvDAxEpLYcrf9ybRcuvbcthXI/VIUvU000Y6dhUi4MHXlFA76Q4pRZjAtkWepd5+NEIOV/d8IK86DlcftebPWDAqdp75Jb3A7SOgcrefKzL8sj+9cv0mnKlxeXqWiPBNbqrPyIrpxov/bVbrNfTny2VH2SG1fzgKUAIgNexbX8izk21O7Cg0nIAbTNGFa5Qq4jxjne739lRQnc+YLrsqKZ9pKkxGCyHgYocMz/V9w2tkeO2lwVLpWNJtKTaCrQ0xlpUWIfY=
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
"modprobe test_vmalloc run_test_mask=1 nr_pages=1048576". Two paths
that might be expected to reach it cannot: alloc_large_system_hash()
caps a table at a sixteenth of memory, and the KVM dirty bitmap is
bounded by KVM_MEM_MAX_NR_PAGES to 512 MiB.

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
index 1afca3568b9b6..44647e189f7d6 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4722,7 +4722,7 @@ long vread_iter(struct iov_iter *iter, const char *addr, size_t count)
 			 * mapping types (vmap, ioremap) don't set nr_pages.
 			 */
 			size = (vm->flags & VM_ALLOC && vm->nr_pages) ?
-				       (vm->nr_pages << PAGE_SHIFT) :
+				       ((unsigned long)vm->nr_pages << PAGE_SHIFT) :
 				       get_vm_area_size(vm);
 		else
 			size = va_size(va);

base-commit: 248951ddc14de84de3910f9b13f51491a8cd91df
-- 
2.43.0


