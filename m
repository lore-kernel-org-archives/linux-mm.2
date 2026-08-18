Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E7F5C5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 09:24:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CA106B016C; Tue, 18 Aug 2026 05:24:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A2416B016D; Tue, 18 Aug 2026 05:24:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B8416B016E; Tue, 18 Aug 2026 05:24:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2B5EA6B016C
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 05:24:41 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B43DE160B14
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:24:40 +0000 (UTC)
X-FDA: 85113855120.05.463E9A9
Received: from mail-pz2-f0.google.com (mail-pz2-f0.google.com [74.125.228.0])
	by imf11.hostedemail.com (Postfix) with ESMTP id EC44440004
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:24:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cszILyjq;
	spf=pass (imf11.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.0 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787045078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xWMBqkj73rVQAMFA4LqK7WvxQ0Lo75WvfMJxyxluc60=;
	b=HLq/D+Al7Iu5obcwKJ4UtkGfcw62uq9NmufV+y3GcU6xq1/UaxbpyQ9EJG9oTaxhozwHhy
	z8wMv2z63WhoMX1s75vBsoaoi5n7aT5jeYm5Nhk4KGhAgZ70Kyo7ttPZ1ZI/VdyH4PXrvF
	yZ0uUs9fYdeM7rHQ+VIhWVP8G7nSLNU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cszILyjq;
	spf=pass (imf11.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.0 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787045078;
	b=ggwKclAGIUecplyV1F5NVDXecCih9qF9paOoIRdLqjt0889YUvPRfgCrhjM91pl7tFJ1vK
	wL6Gn1qq9gH7GZJODpVtWKMDbpqBSfarh5MCj8JVMp9cM0YY24ZGUJjjlK3INKRPKxdIsO
	6fvjDC6xvf/timut9sfi54GXViO1/tQ=
Received: by mail-pz2-f0.google.com with SMTP id 41be03b00d2f7-ca7fcfe1669so1641508a12.0
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 02:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787045078; x=1787649878; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xWMBqkj73rVQAMFA4LqK7WvxQ0Lo75WvfMJxyxluc60=;
        b=cszILyjqmws+mXLmTrfE4jlTNMQLn13TWBMVDRxcL5E/QImQgT5XqXmpdvRJPIoISH
         ep8QfKm/GP19+MjAQP9ksWYH+mpgcvcPwl9zSW/DVkrV/P2SnvKvghIeVmon09MY/HlP
         uDZ2lLHtD96DbBhQqRIVcjBL6M+UdOytNZUAHVAs9MyDJ2eYXxFmfdUUIO5io2eNoB9E
         S0kS1blnfLc30Bpc7aTXrvO5WFxZCZEygt/Yeml5qd3rvkrgg4xct69ZdNntCLoavDkk
         ybOagqxtverKMZYyPKQbtBpzLSP65ZH2SdpIngucZpjAWmzyI6xBRCm9SoYkLKPUsIXC
         k7dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787045078; x=1787649878;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xWMBqkj73rVQAMFA4LqK7WvxQ0Lo75WvfMJxyxluc60=;
        b=H4mKsRhjaZWKRXrPMMhoEhPreWTJ1fXTXwg9SGSujTx39rsyN2lwz65JNpNNThnMyh
         HmLOXrJJXy5m9dRJRsytDgdhB2TB6cZR/e5i3HFXFNZjT6S94Sp7Ks9QZQUZ4HIU3M/N
         GEwNnV4JPkSU8yLRIZlIz02OhENGK5Fyp+LkqDDgsOkcHypNKjR5zEVauxKJX+NGtxah
         JByBhskjkT64zh8bfJ2UAhrHeIlH0Zg8wAIl3eS4D+UmX0gp+MEAcXcP+abp2XZMKUQK
         dAHmR57QNNe5HMQTyihtpRgRqgdFp3Ro2rT33Ji6lwUrPfpPRIDuhaBYWjvMAIkaADyq
         Lj7g==
X-Forwarded-Encrypted: i=1; AHgh+Rrr3kLnecTyW6Z1hBhtx4kBGhGW0s5zxAyROPSQPgIB8fGf5OpwBBIdc/Kb4n9inX06nLzEXHGM1Q==@kvack.org
X-Gm-Message-State: AOJu0YyESDqzaAgGWLANUuc6WK0AKqK8ANdWWWyXU52YUNG/vPXk0irV
	JsVg/8eiMhoNAj0sqCKADT/N7wwlAlaM5QL+iUu7gjO0xrtJpfpjvMD3
X-Gm-Gg: AR+sD13rh8sh0JQbiVEc7vBsMvT3/28+Xhm/LfBVIK6hCUfefnr5xDoffpBJA779y0v
	opMOWH+DGyh1ljzQyx5SKYHBROHZDlNBaGvNFc7WxzIZr6drSnRtgTq9sDXguTHaFszNCQ93faE
	bfEkcDKFlG7ueuQBAt/TcMEHz4lu5pSi0wp2bDLL80vtDfYnNr56fv1RyJC/JgApxHhiq/cal6X
	pudnCpAz63z30OvjVO38OvOXZwarcoRy3E/Yc0kASPSD+KDL7n9kvWl/hHImlIWTATwY9FM2+Pk
	J+reJ/9A9VL5suIhW5XyrcjR5XZPYtjM8mI5NfNomwFsbo3Pjy8QeBFpmxv2FTz33nc30mCfkb4
	xYiCf48YBfLl9697V41jwb0PhZSUvMMEjVmuCrh2Xt7SJugNYsxzsYqCclCOKQXI1e/CdcHi0tY
	P5Nl/+oJn8Bn7vGI9Q91fWBjFmsobkCJB6gjWYou3cWqMoaT7H3rfWx1h1fosMTEdIQ9MqvMzX
X-Received: by 2002:a05:6a00:1149:b0:847:7ffd:ce35 with SMTP id d2e1a72fcca58-851b87eaa83mr7838506b3a.8.1787045077737;
        Tue, 18 Aug 2026 02:24:37 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc13c036c50sm1855975a12.26.2026.08.18.02.24.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 02:24:37 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: robh@kernel.org,
	saravanak@kernel.org,
	rppt@kernel.org,
	m.szyprowski@samsung.com,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: akpm@linux-foundation.org
Subject: [PATCH v2 2/5] of: reserved_mem: reject static regions overlapping no-map memory
Date: Tue, 18 Aug 2026 17:24:17 +0800
Message-ID: <20260818092420.2859026-3-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260818092420.2859026-1-chenwandun1@gmail.com>
References: <20260818092420.2859026-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 56ug8xit61bt3b914pckuuz476hz865h
X-Rspamd-Queue-Id: EC44440004
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787045078-608535
X-HE-Meta: U2FsdGVkX18TI8hkS8a/PELPC9sScUxDCJdnreEbN8Fgbe4R10LSsJWOXokba3WKYgum9XcR978svlmSAR9MQHVDbLpxRNVkMrPpmg0bzfO0pYv0ZSTnKOjymv9KpyWc0Nm6h5yoIML52fxUT8QVleRxE4rdL0nqtAfvnWKdg1Zy30TTi3pKMJXd981vbOwqQQmawblcCPo8lct62/zaUtmDjmw0kKYcqTM3RioJTookYJmi6rrPvOqno5PpKDUkU1yY4mIzsyvktTTzGe6FWWSzgbr4fPahQJWfiyvXIDt2cbbS7eujoDllLVIx/F3nRmKOSUZSffAJxfnFBz2SCIMcZvfZ3/SFINrgdDF3DolBycc1ghHB9Hq07L20PyDlSC4SCte4HdXS45AhzqCktB4SArHFS1tSbl5H226ACyJzoZVKyDp9y+HIIigcyoEbNqUhBFexsZ8D9ZtyxpCE4qiL2Z1L58qpepm36QaVnLG3jY/6Jz7ykdZyE8IH355Hj+ZPAEG3x4//dvWUKVnbivsDk7I3RYPLqm3ixtZcbg5vfza28XoyC1zd7LEJB259mDLBoeLeBesKVExCBpmruzXFhzpxrYRW0VNc7ARV3WF81Hy9wz9HzwMEp6QEln5+5W4Pby81qnnQzn0Uql2ONcP1uVXlg7nPGZjdpEX5+a9pVhPYzQr2F5bvcGis77D2vs/mT7xl5MJY1cSuj3m9+SbNH2H5otJgUBn7Dd9+ku1btrPFHdhDY+5p/ByIY6NYKEJo8pB+mn+YmHn+IOYsrlXgc4x77bqnG0gOZELlt3N5wxU3BNBxWqNORb51qyK4wup7etDJgvZKFIjoP5hVaCJQtCkIpnZUQ1NUVAQQIW71NOXEm4YjXME9XD7seHb1M6cx5x+kU/ErRtTiMp2H1zG614uqZuzhv6WlO6qNWEM/yFmeSoENvSjBW+xtS1XtYMDAlwMD/45vma2QfSB
 FDwK3AC7
 RdL1dEYBVV6XuBOFPKgF++k1FzvFtupMnLSwTT3xiR8IAkbYDkAJT7TCMXdn0lgSRVqoZ5Bo9pCM6hsP0GWm9HMYL60+6qX8XstrEWojIZpsWQMc/I2x1ILlxS/k5XBklZhZSPaGOXcFeFMlKxDhtQNxsj3jeyHEsBJ4zqm3qUDHKYuFn87kYILowzUq3cgCGZXcM3vtXZpAM0/Tq7AIniVtJ9rAFhNGW8fLArCvCF6PiYJzWb6Qx2LWfxJDXFOobdVs5bWb8gGFS7ZPU1R/EgKabFFLb40L5cgN9ajz3Y/W76IEDaXj10LL5G8K7bCE6LpHWobBA4qq2EsKgW9Id3/eHPuVKaKL9rn8Ykb62fHlZrJkPuU5l6yVnv9z06AejlazW9Yvw/Ya7QRpy2NaKF7d6JtNeUxzgUdKtmdNJYvLiQ1XLxt9iQZPKAtnpG5iJNgZeRGrTTXBzkVtFNKuy62+JDE3BtYMrARkCZJFpaOHTobcsiAG7EkWVkJxuj4vP1yWq5ypzdr9UfmYRtIr4f6i458sPX0edaNXAXjjbBHFajY09WKwsOnqWTdG7WB+fYxDE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wandun Chen <chenwandun@lixiang.com>

Static no-map reserved-memory regions are marked in memblock.memory rather
than memblock.reserved. So the reservation overlap check does not reject
a static region that overlaps existing no-map memory.

Both regions can then be initialized and hand the same physical memory to
different reserved-memory drivers. So reject a static region that overlaps
existing no-map memory.

Sashiko found this issue in [1].

Fixes: 86588296acbf ("fdt: Properly handle "no-map" field in the memory region")
Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Link: https://sashiko.dev/#/message/20260814084718.29C341F000E9%40smtp.kernel.org [1]
---
 drivers/of/of_reserved_mem.c |  3 ++-
 include/linux/memblock.h     |  1 +
 mm/memblock.c                | 14 ++++++++++++++
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index c6e73d710ee1..9fb2e4c29443 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -152,7 +152,8 @@ static int __init early_init_dt_reserve_memory(phys_addr_t base,
 		 * if the region isn't memory as it won't be mapped.
 		 */
 		if (memblock_overlaps_region(&memblock.memory, base, size) &&
-		    memblock_is_region_reserved(base, size))
+		    (memblock_is_region_reserved(base, size) ||
+		     memblock_overlaps_nomap(base, size)))
 			return -EBUSY;
 
 		return memblock_mark_nomap(base, size);
diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index d62db9e776cf..27d68fbb3157 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -148,6 +148,7 @@ int memblock_physmem_add(phys_addr_t base, phys_addr_t size);
 void memblock_trim_memory(phys_addr_t align);
 unsigned long memblock_addrs_overlap(phys_addr_t base1, phys_addr_t size1,
 				     phys_addr_t base2, phys_addr_t size2);
+bool memblock_overlaps_nomap(phys_addr_t base, phys_addr_t size);
 bool memblock_overlaps_region(struct memblock_type *type,
 			      phys_addr_t base, phys_addr_t size);
 bool memblock_validate_numa_coverage(unsigned long threshold_bytes);
diff --git a/mm/memblock.c b/mm/memblock.c
index 9ce86349a29f..4cabfe365ac4 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -202,6 +202,20 @@ memblock_addrs_overlap(phys_addr_t base1, phys_addr_t size1, phys_addr_t base2,
 	return ((base1 < (base2 + size2)) && (base2 < (base1 + size1)));
 }
 
+bool __init memblock_overlaps_nomap(phys_addr_t base, phys_addr_t size)
+{
+	struct memblock_region *region;
+
+	memblock_cap_size(base, &size);
+	for_each_mem_region(region) {
+		if (memblock_is_nomap(region) &&
+		    memblock_addrs_overlap(base, size, region->base, region->size))
+			return true;
+	}
+
+	return false;
+}
+
 bool __init_memblock memblock_overlaps_region(struct memblock_type *type,
 					phys_addr_t base, phys_addr_t size)
 {
-- 
2.43.0


