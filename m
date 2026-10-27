Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7A65606A32D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 02:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=OAbO3ePQ
Received: by kanga.kvack.org (Postfix)
	id C9ECF6B05BC; Mon, 26 Oct 2026 22:56:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4EF86B05BD; Mon, 26 Oct 2026 22:56:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B17446B05BE; Mon, 26 Oct 2026 22:56:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 88C846B05BC
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:56:53 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 15B761C42D3
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:56:53 +0000 (UTC)
X-FDA: 85366893906.23.F115DDD
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5CC8E80005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:56:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OAbO3ePQ;
	spf=pass (imf30.hostedemail.com: domain of 38hLgag0KCPUhbsfkilrdeifkdlldib.Zljifkru-jjhsXZh.lod@flex--kevinloughlin.bounces.google.com designates 209.85.210.70 as permitted sender) smtp.mailfrom=38hLgag0KCPUhbsfkilrdeifkdlldib.Zljifkru-jjhsXZh.lod@flex--kevinloughlin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793069811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n7o+pR7kIh2/FhhUqUS8VpzKzJ7DErIKQHWtYktZq/o=;
	b=FuOQTp5AfJgeTwpWTQDhcF9SWAOJ1ArheBT08e9aL3FcrOy7E0Je91CfGJV6dH6DJxgd3g
	ZcATn6v7a52fjxFHbNua8ly6+W/U8+3iKOnJmqEl8S80vknnKw4K4OBML/z6dcVAS8U/oU
	kvBOZuW4YC/iZim/COr66onr8Zz3B9c=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OAbO3ePQ;
	spf=pass (imf30.hostedemail.com: domain of 38hLgag0KCPUhbsfkilrdeifkdlldib.Zljifkru-jjhsXZh.lod@flex--kevinloughlin.bounces.google.com designates 209.85.210.70 as permitted sender) smtp.mailfrom=38hLgag0KCPUhbsfkilrdeifkdlldib.Zljifkru-jjhsXZh.lod@flex--kevinloughlin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793069811;
	b=4xSlIZ1ZAgHGY1cN7QVQ194UX59GPvoIYGMg99k86hiDh/Lg5b14P8T+zF+GxXgj0yBzgl
	7GyL/aRZFRrWCCaws/RbjqjYoIxij06EwtjTj1y7S59pPhtI5V+x4I7zQ+uBEAgU7GhTvu
	XYu2ug8Ch1Xod0uLAS6dhqMlJ+gCC6w=
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-8490a7d657cso5550118a34.0
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793069810; x=1793674610; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n7o+pR7kIh2/FhhUqUS8VpzKzJ7DErIKQHWtYktZq/o=;
        b=OAbO3ePQjA+FuuQmtJOJsMjiE1FiW/80joCt06LRwW9GydGm5yhn/w1pxZGYHQ5bcs
         6s1fOgSl640fW8WQ5W2cW0iRde+29Pvgo9QW0W8q6Z44cPoO6YDbxapaTa9Uy8l2Uii0
         qaPf5ozETDqRvgqXQd5zeidHWZ7Jf3l8HC1KLszd868PAcYd/gi6imIhqsufpEZDyyNx
         /h2G1kUoglG8+q7bYK7dX3WBG2572djtIrZOVWihtQb5zhp/PBrlO9o/90zRiN7v8Viu
         kFuFrz5cT59Tks0ICTdcG7JziRQ2/87bAwHvL4i/shHtHOT4ysOJXDpP4/R6bcsBd0+j
         yuTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793069810; x=1793674610;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n7o+pR7kIh2/FhhUqUS8VpzKzJ7DErIKQHWtYktZq/o=;
        b=2cmfxoJdJazlwz5dvk6aSTOo4kF3Ptpz3E8vrmXff+wC7V5X8ZLvfg963VsvUhdzbh
         HYOSqGRZKdobEyJFx8ekxMW+iVZUVHgzy+nMwcVy+SolP4bzC0Pychiz4TL0WaPO96T9
         xcHd82q3ejB66CrQU9UlpZnePndA2YkX5E6OlsL7X0gSDWC3Wovq8/+8nbfuXjzBFEVn
         XBqgByLkCpw6s/tG3Lr+4GwGsAGKGO84Q1iuf6K+tddQS0hAVkZzPAKStDEIO9I9LgvG
         lIRxKEMzBJWkIpTfWZkPqicVmEsx+fxS1ZDjLSIF/6F+0XxmrMg8MrlpEdZU9NjAiwQZ
         LgCA==
X-Forwarded-Encrypted: i=1; AKwUvBzP6xbCKzn3sVNIs1rPBjnjCCok9bQTrkUTta0fBpdztGB6PVxSE30mMSOMj36WaCRvy8EgeTvFYA==@kvack.org
X-Gm-Message-State: AFq9FYJPnTXpIiMc2+O9ZZgYiSDnTg+JxSPfb16rzY+tNgKXx/NB5Ff8
	EC7HcOnTBBYu6k41Wd9RO2TamxXwdf/HI8zykM0/XKjczJrWhabGyuBXmR7XmWGrAKdyqQbOyEj
	SJToc7HRRxvvKvU3HoEYVyIoToT7o2LomFQ==
X-Received: from ilbdx1-n2.prod.google.com ([2002:a05:6e02:4201:20b0:51a:af50:87cd])
 (user=kevinloughlin job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:5601:b0:6c3:19de:d1ef with SMTP id 006d021491bc7-70ba0da3184mr2895148eaf.20.1793069810059;
 Mon, 26 Oct 2026 19:56:50 -0700 (PDT)
Date: Tue, 27 Oct 2026 02:56:09 +0000
In-Reply-To: <20261027025616.1632690-1-kevinloughlin@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261027025616.1632690-1-kevinloughlin@google.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261027025616.1632690-7-kevinloughlin@google.com>
Subject: [PATCH 06/13] efi/unaccepted: add mark_memory_unaccepted()
From: Kevin Loughlin <kevinloughlin@google.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, David Hildenbrand <david@kernel.org>, Jason Wang <jasowangio@gmail.com>, 
	"=?UTF-8?q?Eugenio=20P=C3=A9rez?=" <eperezma@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Alexander Duyck <alexanderduyck@fb.com>
Cc: virtualization@lists.linux.dev, linux-coco@lists.linux.dev, 
	linux-efi@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Sidharth Telang <sidtelang@google.com>, Punit Salian <psalian@google.com>, 
	Peter Gonda <pgonda@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Jacky Li <jackyli@google.com>, Steve Rutherford <srutherford@google.com>, 
	David Skidmore <davidskidmore@google.com>, Kevin Loughlin <kevinloughlin@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5CC8E80005
X-Stat-Signature: ccwx4hftmm5bxnf17ocdg6cfg3pdkfdj
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793069811-807381
X-HE-Meta: U2FsdGVkX1+CKdGWr3LmNWZ+k6g8suPwvRgGGrg8Xq/9fY1JVfM/hlpgjGAlF7/xkh25Ez6jYqD7xoAaNcMX8k/zOIuZ/BuRKpeqmM1+LTxWRV7sCpV0mRSw0Id89dnZMa2zZdi+wR1nCkqg+TA9IPfO3ATW2JPywLdctmE6jF5tSvvyL7SP61hn9+U9S4/cYJcqouiGnanxFFKwApXTq7yAN4tvdm1SX/JHn3fhE8CbLW9E7fM57b/dAg4i2B7CWRwWYokfzp05va+jm/SOGETmoFUTGGRu9UyKF4vH1CJb17SlNN1Npubi6zSVh1yZ1h/yB2+dINEM9n5L59QZMzprKaJX6zSlV3COXTKMQR3GDBLnIB8BT/yz1hqK1cNCFnhCO/r18hVEZUuXbEM2osrWrSgQA4FwkEemVuqp3ev1DTYDtKgkoWVno5j1hs9CvNPP87K2/WxFmXS6NZklYTCYYScvB7ZUdtPow7IFnhwNTAJl+HSxUoOTPXWKDVrrTGqQh+dLeZM1R9o6SCN2Ep+rA6FoCEpHOXZGCN2PH5fQkFkqlLBSdqHtSEHqWxxxr2qR8V2RWvbybH01/A4fVVvHjS+vdXd97rCMgRAq4CX3uk9Vuq31KE2GBPqllb1WQIMTBp3vGLpZ4umDLDoZcT8gp/VneI00dL5geT8fqBCuZIh7eI6wPXu3jVy8Il7P4YnMHyi+7LaDC0Q+LQAb1zUsfZoPAhrIWYIh744U2AkVJ7IhZ9EM0itMzb97b6AJrLMqeOvCBfF3EcZbGKNLAcZ4x2X+65kvDgNd3pCuQryuWrZIjegLzlXx1s0GK1t67tW/3b0eNdzJv0Ouc4aUR/UzZbtUWYl5tsQeUSnSB2mWrUGlh8OcNki4BVdTbGIR0SmBZA+5m+bjNv8CbbOn8EjfsSTok3lsxfS0Ha3CVGxiC4FBjfEXn8MtHWVNFpXjSCC44scQkzrgVpzEeeO
 yU/jClFG
 BfFV6EGp5UrMf+AdX+X1r7qQKOe1W5wn/UYDg+0WmXS9eBx0R/NQQIjHDtIxI4mjfMjOFeSCPYAr/vwJHkgNDWIwM+mJ57r6r1EQIj4lGArzdnD8PILCpIQEGrVEGF1QVzed+FnYnS55rC/w8dzkqM+qy0QlGUjT5vIFqnVuCPh9fVa/ut367bPoRFMnBaSMXdl/u63tmRolbKNrKwpcPL64PAmhip73kDMlgAXQ3+iW89mVJ3/m2+yHpGWMRoBHeg3dNQBkRQGo05XyzJwMdQGHLTFn58OjyA5Z9h47+G/MJOhkX88FLY4b6qf/qOAXbWCpfbqKloDNzjdwCMAxZFOEeibeF6OAm6+wajvgaM1L3JKU0nk87Uyqz/mWiP5FO7jhOKEn3A3chQgt+M1+l0nDqo//nEYuxnRljWwSXy77j0SQ9ljnr981Hnt4ah0PIklZKVXo/wMYeGWEUf6j8fimlmyfc0DUUz56umIxM+t33a7d1XanbtpD4CR/JtAMUOdEXamPsEE7VKbfJfXST2oi4ebRVhKCUZYfR6LRnOJwGoSK4+J+vV7WkPMRWDsao8T9hMJr9nzXHvoOevA/+/OL5tQHJtWMi0+HIu+eU+TKhN+Q8yhpAMelsjKboDFS5BrkcnkfxGyk9nbGTtDb1zQVAR7RnviK6QkK9ymNzyFVs9ZqAe/cox3n5/M45xHdnGMBLFg3sO8y60QeGKTlg74q8zw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Introduce mark_memory_unaccepted() to mark a physical memory range as
unaccepted in the EFI unaccepted memory bitmap. Use
unaccepted_memory_order() to query the page order matching the EFI
unaccepted memory unit_size granularity.

Synchronize mark_memory_unaccepted() with concurrent accept_memory()
callers via accepting_list and only invoke arch_unaccept_memory() on
sub-ranges that are currently marked accepted in the bitmap.

On platforms with dynamic unacceptance (arch_has_unaccept_memory()),
load_unaligned_zeropad() across page boundaries is recovered via
EX_TYPE_ZEROPAD exception fixup. Thus, skip extending accept_memory()
and range_contains_unaccepted_memory() by an extra unit_size guard
block to avoid corrupting the acceptance state of adjacent 2MB blocks.

Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
---
 drivers/firmware/efi/unaccepted_memory.c | 107 ++++++++++++++++++++++-
 include/linux/mm.h                       |  12 +++
 2 files changed, 115 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/efi/unaccepted_memory.c b/drivers/firmware/efi/unaccepted_memory.c
index 4a8ec8d6a571..128bc1b113cd 100644
--- a/drivers/firmware/efi/unaccepted_memory.c
+++ b/drivers/firmware/efi/unaccepted_memory.c
@@ -5,6 +5,8 @@
 #include <linux/spinlock.h>
 #include <linux/crash_dump.h>
 #include <linux/nmi.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
 #include <asm/unaccepted_memory.h>
 
 /* Protects unaccepted memory bitmap and accepting_list */
@@ -86,7 +88,16 @@ void accept_memory(phys_addr_t start, unsigned long size)
 	 *    if 'size+end' is aligned on a unit_size boundary. (immediately
 	 *    following this comment)
 	 */
-	if (!(end % unit_size))
+	/*
+	 * On platforms without implemented dynamic unacceptance support,
+	 * load_unaligned_zeropad() across a page boundary into unaccepted
+	 * memory causes a fatal VMM exit rather than a recoverable exception.
+	 * When dynamic unacceptance is supported (arch_has_unaccept_memory()),
+	 * load_unaligned_zeropad() is recovered via EX_TYPE_ZEROPAD exception
+	 * fixup, whereas extending the range by unit_size would accept
+	 * adjacent dynamically-unaccepted blocks.
+	 */
+	if (!arch_has_unaccept_memory() && !(end % unit_size))
 		end += unit_size;
 
 	/* Make sure not to overrun the bitmap */
@@ -191,10 +202,11 @@ bool range_contains_unaccepted_memory(phys_addr_t start, unsigned long size)
 	end -= unaccepted->phys_base;
 
 	/*
-	 * Also consider the unaccepted state of the *next* page. See fix #1 in
-	 * the comment on load_unaligned_zeropad() in accept_memory().
+	 * Also consider the unaccepted state of the *next* page on platforms
+	 * without implemented dynamic unacceptance support. See fix #1 in the
+	 * comment on load_unaligned_zeropad() in accept_memory().
 	 */
-	if (!(end % unit_size))
+	if (!arch_has_unaccept_memory() && !(end % unit_size))
 		end += unit_size;
 
 	/* Make sure not to overrun the bitmap */
@@ -215,6 +227,93 @@ bool range_contains_unaccepted_memory(phys_addr_t start, unsigned long size)
 	return ret;
 }
 
+unsigned int unaccepted_memory_order(void)
+{
+	struct efi_unaccepted_memory *unaccepted = efi_get_unaccepted_table();
+
+	if (unaccepted && unaccepted->unit_size >= PAGE_SIZE)
+		return ilog2(unaccepted->unit_size >> PAGE_SHIFT);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(unaccepted_memory_order);
+
+int mark_memory_unaccepted(phys_addr_t start, unsigned long size)
+{
+	struct efi_unaccepted_memory *unaccepted;
+	unsigned long range_start, range_end;
+	struct accept_range range, *entry;
+	phys_addr_t end = start + size;
+	unsigned long flags;
+	u64 unit_size;
+
+	if (!arch_has_unaccept_memory())
+		return -EOPNOTSUPP;
+
+	unaccepted = efi_get_unaccepted_table();
+	if (!unaccepted)
+		return -EOPNOTSUPP;
+
+	unit_size = unaccepted->unit_size;
+	if (WARN_ON_ONCE(!IS_ALIGNED(start, unit_size) ||
+			 !IS_ALIGNED(size, unit_size)))
+		return -EINVAL;
+
+	if (WARN_ON_ONCE(start < unaccepted->phys_base || end <= start))
+		return -ERANGE;
+
+	start -= unaccepted->phys_base;
+	end -= unaccepted->phys_base;
+
+	/* Make sure not to overrun the bitmap */
+	if (WARN_ON_ONCE(end > unaccepted->size * unit_size * BITS_PER_BYTE))
+		return -ERANGE;
+
+	range.start = start / unit_size;
+	range.end = end / unit_size;
+retry:
+	spin_lock_irqsave(&unaccepted_memory_lock, flags);
+
+	list_for_each_entry(entry, &accepting_list, list) {
+		if (entry->end <= range.start)
+			continue;
+		if (entry->start >= range.end)
+			continue;
+
+		spin_unlock_irqrestore(&unaccepted_memory_lock, flags);
+		goto retry;
+	}
+
+	list_add(&range.list, &accepting_list);
+
+	range_start = range.start;
+	for_each_clear_bitrange_from(range_start, range_end,
+				     unaccepted->bitmap, range.end) {
+		unsigned long phys_start, phys_end;
+		unsigned long len = range_end - range_start;
+
+		phys_start = range_start * unit_size + unaccepted->phys_base;
+		phys_end = range_end * unit_size + unaccepted->phys_base;
+
+		bitmap_set(unaccepted->bitmap, range_start, len);
+		spin_unlock(&unaccepted_memory_lock);
+
+		debug_pagealloc_map_pages(pfn_to_page(PHYS_PFN(phys_start)),
+					  (phys_end - phys_start) >> PAGE_SHIFT);
+		arch_unaccept_memory(phys_start, phys_end);
+
+		spin_lock(&unaccepted_memory_lock);
+	}
+
+	list_del(&range.list);
+
+	touch_softlockup_watchdog();
+
+	spin_unlock_irqrestore(&unaccepted_memory_lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mark_memory_unaccepted);
+
 #ifdef CONFIG_PROC_VMCORE
 static bool unaccepted_memory_vmcore_pfn_is_ram(struct vmcore_cb *cb,
 						unsigned long pfn)
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6882ad400935..27bb40651c85 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5362,6 +5362,8 @@ int set_anon_vma_name(unsigned long addr, unsigned long size,
 
 bool range_contains_unaccepted_memory(phys_addr_t start, unsigned long size);
 void accept_memory(phys_addr_t start, unsigned long size);
+unsigned int unaccepted_memory_order(void);
+int mark_memory_unaccepted(phys_addr_t start, unsigned long size);
 
 #else
 
@@ -5375,6 +5377,16 @@ static inline void accept_memory(phys_addr_t start, unsigned long size)
 {
 }
 
+static inline unsigned int unaccepted_memory_order(void)
+{
+	return 0;
+}
+
+static inline int mark_memory_unaccepted(phys_addr_t start, unsigned long size)
+{
+	return -EOPNOTSUPP;
+}
+
 #endif
 
 static inline bool pfn_is_unaccepted_memory(unsigned long pfn)
-- 
2.56.0.307.g5fe7bd680c-goog


