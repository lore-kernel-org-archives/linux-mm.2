Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2C9AD3EE66
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 15:01:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3D776B0208; Thu, 22 Jan 2026 10:01:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E15886B020A; Thu, 22 Jan 2026 10:01:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4BA26B020B; Thu, 22 Jan 2026 10:01:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C19B36B0208
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 10:01:56 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 63725B8DA1
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 15:01:56 +0000 (UTC)
X-FDA: 84359914632.09.8D96223
Received: from harvie.cz (harvie.cz [77.87.242.242])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6E547120016
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 15:01:54 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=fail reason="No valid SPF, No valid DKIM" header.from=gmail.com (policy=none);
	spf=softfail (imf29.hostedemail.com: 77.87.242.242 is neither permitted nor denied by domain of tomas.mudrunka@gmail.com) smtp.mailfrom=tomas.mudrunka@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769094114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=gmnFDYkBU2/QBLzqCjUdIhU686MtzIg6knsPKwVyrJM=;
	b=4MN9GnlEtJgfO9gAYtxbmKV4t0MyY2NLUfl2GkAXOd5cyeQmlTSOvxdGqxR+M5da+GD1sl
	A/LORRxvD0284oRtoQ9ovbMnEfjNYM4PgzE1LJY1xfNkzqQYPMrIX3MHbrxVQ6vhUwcF/7
	LgO+2KbFXNON0DSGpzx+hkaG5LwltM8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=fail reason="No valid SPF, No valid DKIM" header.from=gmail.com (policy=none);
	spf=softfail (imf29.hostedemail.com: 77.87.242.242 is neither permitted nor denied by domain of tomas.mudrunka@gmail.com) smtp.mailfrom=tomas.mudrunka@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769094114; a=rsa-sha256;
	cv=none;
	b=ahwG/9HOwdKO3pMjWCyXBA0tZEPvkVT5M9mk1/qiGHZv7jI05Ng/w8TOOQeHF1rkPlpqxH
	woY56x+pd31wiS/DM0vXhzHBVlmyoa2EnT3sI0L3BnzbmB7CCpU7rbRs6w8eNrySjS5n8T
	l17O2RIBm+z2pW6Sw+gQ06WDY936gJs=
Received: from anemophobia.amit.cz (unknown [31.30.84.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by harvie.cz (Postfix) with ESMTPSA id B135B180116;
	Thu, 22 Jan 2026 16:01:51 +0100 (CET)
From: Tomas Mudrunka <tomas.mudrunka@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Tomas Mudrunka <tomas.mudrunka@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] MemTest: Test RAM address bus for stuck bits
Date: Thu, 22 Jan 2026 16:01:14 +0100
Message-ID: <20260122150116.3409572-1-tomas.mudrunka@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9h6hh835xs58srq3tm5uodfgwqgtmema
X-Rspamd-Queue-Id: 6E547120016
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769094114-309116
X-HE-Meta: U2FsdGVkX19p3E9OLvSbuxn586sAAMz40yRFX/W10JgW+2Tt6eysROgpi9g6GbFIng0QFb3MnvTvXzf26ZTR1pyxyd22b5VhMi6wIVW1+whYPuC6Tckjec/v4wT6kSOPLcQVDut2USqFys0czVpxnwxgpClhUby8KOtVIv/PhSqILVpABfv1xqrIqa26lHEQ35930mgzYbGUDQH4PJxMJ0rLvkxWDTGfe+D7cTyayJGeoA8LwaBhVj1R//LEiV86DbjVVchz3v1omUnyFZY6hBBC+Tp8qWBpjIfsf86ykYUpTBe/0zdi0jfnqsnLZSYxfgspxD0BHvKkz82TCGZ+0Fh/UxzrmL9ec6S6XjI+c3Rrlb4BPU2wGM6illK7tVDLffwM6QeBIwZsb9uobIbUTODbR3Aek1uRUUGmTXaf3nz+Wf7V9BGSYoBHeH5bzdxRa8oh6rwj6RbrOzTy9ljR3aZRYy6aZmUNtWd68/FThOkTYAyV1mERDvM0zPxibbKLb+LNIzUEKH8HIQqZJWPEgVfVligTYgN0eRoORivgkLcZmisMHIaiJlMaRrdgtJmLlK7dnMjuoxJQlEgv5hwwTtmIMsEqiYtMVxn9nwShL6Fw9Wl3cwrok2H4wE2hPgnjhDe5xZ5dYjs+lV/HfStCtDB6flgBKEplsFCllMkccMqdtADyquAMrwY0/BpDPgnGg2ijN/HG8o+yAvfg4lJ3Xh0IwyITXS8izasOGxrPHrkBIiqcYLmxOnqOA19P5I6rjtlgOUhsCjrUTiZLPr3LSuUv3vxv9iN6mzEuuiOCchx5mTQKui7AV9EzEgwP6/aTjoXYW+LnQpq89o9gpu8Pabc+6KFyXu0OVJvpg1mEWLWC4tB/OoRwwg7LOFPusFrTXZL8xjKn2A2MbsHnDxd2Qh0x4cjyQ0i4uGiUtgVf5RHR93N8aqLfNQWMfSK+b65U6tZiBbZEv+VgTZ8Fiuj
 rAz7bcq4
 ijPEc0lVlGr1XGBpvt6Erknhj6N86VJ63aPFAaqHIpVK9DCP2Gt7OSUfZu1fe8A9lUVDyhbrtxDZvAYBGYuhGTaMEhnIUrRi+D2fOPdLLvreOsXsSfeKLGz0G48n/ZJIz0+M0XZtZrqrA3UZyyBWUgxd81b0N9Ll81Eu5vXB2v+BU33x9T6/KIwCZjP3deX84vNb1ZS3F2gNMJ85sDBPAEC49jw+LMBk+IlVAJ5sDgpQcx64LhLP6R7rpIQcO4OU4JLUlKwofkH5kvF+BYk1xqKfqMypvKnfqy4sxt8pOdZ3Zy89ZUSYO7hRduRTyRY9t6YoXnVhNnpv3hvmPf56sWlOf0QEUhDX8L6UuKuCC7j+twryrACAPhKqpwqQUHZCyuISHIY5BeojFh+mHPHY8qCBYcVdsCk1SVbBpPNnuFapILIVjCaakuI/5BLF5PlqgfAM3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Adds new test to early_memtest() that runs every time memtest is enabled.
For each bit in phys_addr_t this tries to find pair of addresses in free
memory that differ only in the tested bit. These pairs are then tested
for aliasing/mirroring. This should detect loose connection or short on
RAM address bus. Such problem would be traditionally ignored by normal
early memtest. Result is then printed and exported via EarlyMemtestBad
in /proc/meminfo. If there is no free memory pair found for given bit,
it's printed and ignored.

Please note that this mostly targets systems with fully parallel address
bus like DDR3 and DDR4. Systems with DDR5 and similar are unlikely to boot
at all, since these send multiple address bits in serial over address pins.

Coming from heavy industry, such hardware failure can be caused by
vibrations and go undetected for quite a while, especially on higher bits.
Therefore this test is very useful for early warning self-tests and
quality control use cases.

Signed-off-by: Tomas Mudrunka <tomas.mudrunka@gmail.com>
---
 mm/memtest.c | 118 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 118 insertions(+)

diff --git a/mm/memtest.c b/mm/memtest.c
index c2c609c39..9b63f7917 100644
--- a/mm/memtest.c
+++ b/mm/memtest.c
@@ -4,10 +4,15 @@
 #include <linux/init.h>
 #include <linux/memblock.h>
 #include <linux/seq_file.h>
+#include <linux/bitops.h>
 
 static bool early_memtest_done;
 static phys_addr_t early_memtest_bad_size;
 
+static u64 addr_bus_failed_bits;
+static u64 addr_bus_skipped_bits;
+static bool addr_bus_test_done;
+
 static u64 patterns[] __initdata = {
 	/* The first entry has to be 0 to leave memtest with zeroed memory */
 	0,
@@ -104,6 +109,114 @@ static int __init parse_memtest(char *arg)
 
 early_param("memtest", parse_memtest);
 
+static bool __init is_address_free(phys_addr_t addr)
+{
+	return memblock_is_memory(addr) && !memblock_is_reserved(addr);
+}
+
+static bool __init find_test_pair(unsigned int bit, phys_addr_t *addr1, phys_addr_t *addr2)
+{
+	u64 i;
+	phys_addr_t this_start, this_end;
+	phys_addr_t candidate;
+	const phys_addr_t step = PAGE_SIZE;
+
+	for_each_free_mem_range(i, NUMA_NO_NODE, MEMBLOCK_NONE, &this_start,
+				&this_end, NULL) {
+		candidate = this_start;
+		while (candidate < this_end) {
+			phys_addr_t test_addr2;
+
+			/* Calculate address differing only in the specified bit */
+			test_addr2 = candidate ^ BIT_ULL(bit);
+
+			/* Check if both addresses are free */
+			if (is_address_free(candidate) && is_address_free(test_addr2)) {
+				*addr1 = candidate;
+				*addr2 = test_addr2;
+				return true;
+			}
+
+			/* Step to next candidate */
+			candidate += step;
+		}
+	}
+
+	return false;
+}
+
+static void __init test_address_bit(unsigned int bit)
+{
+	phys_addr_t addr1, addr2;
+	u8 *vaddr1, *vaddr2;
+	u8 val1, val2;
+
+	if (!find_test_pair(bit, &addr1, &addr2)) {
+		addr_bus_skipped_bits |= BIT_ULL(bit);
+		return;
+	}
+
+	vaddr1 = (u8 *)__va(addr1);
+	vaddr2 = (u8 *)__va(addr2);
+
+	/* Write different patterns to both addresses (1 byte to avoid overlap) */
+	WRITE_ONCE(*vaddr1, 0xAA);
+	WRITE_ONCE(*vaddr2, 0x55);
+
+	/* Read back and verify we got what we wrote */
+	val1 = READ_ONCE(*vaddr1);
+	val2 = READ_ONCE(*vaddr2);
+
+	/* Check for mirroring: if either address doesn't read its expected value, bit is stuck */
+	if (val1 != 0xAA || val2 != 0x55)
+		addr_bus_failed_bits |= BIT_ULL(bit);
+
+	/* Restore memory to zero */
+	WRITE_ONCE(*vaddr1, 0);
+	WRITE_ONCE(*vaddr2, 0);
+}
+
+static void __init test_address_bus(phys_addr_t start, phys_addr_t end)
+{
+	unsigned int addr_bits = sizeof(phys_addr_t) * 8;
+	unsigned int bit;
+	unsigned long failed_count, skipped_count, ok_count;
+	char result_str[128];
+	int pos = 0;
+
+	addr_bus_failed_bits = 0;
+	addr_bus_skipped_bits = 0;
+
+	for (bit = 0; bit < addr_bits; bit++) {
+		test_address_bit(bit);
+
+		/* Build compact result string */
+		if (bit > 0 && (bit % 8) == 0)
+			result_str[pos++] = ' ';
+		if (addr_bus_failed_bits & BIT_ULL(bit))
+			result_str[pos++] = 'F';
+		else if (addr_bus_skipped_bits & BIT_ULL(bit))
+			result_str[pos++] = '_';
+		else
+			result_str[pos++] = 'O';
+	}
+	result_str[pos] = '\0';
+
+	failed_count = hweight64(addr_bus_failed_bits);
+	skipped_count = hweight64(addr_bus_skipped_bits);
+	ok_count = addr_bits - failed_count - skipped_count;
+
+	pr_info("Address bus test: %s\n", result_str);
+	pr_info("Address bus: %lu OK, %lu FAIL, %lu UNKNOWN\n",
+		ok_count, failed_count, skipped_count);
+	if (addr_bus_failed_bits)
+		pr_info("Address bus failed bits: 0x%016llx\n", addr_bus_failed_bits);
+	if (addr_bus_skipped_bits)
+		pr_info("Address bus skipped bits: 0x%016llx\n", addr_bus_skipped_bits);
+
+	addr_bus_test_done = true;
+}
+
 void __init early_memtest(phys_addr_t start, phys_addr_t end)
 {
 	unsigned int i;
@@ -117,6 +230,8 @@ void __init early_memtest(phys_addr_t start, phys_addr_t end)
 		idx = i % ARRAY_SIZE(patterns);
 		do_one_pass(patterns[idx], start, end);
 	}
+
+	test_address_bus(start, end);
 }
 
 void memtest_report_meminfo(struct seq_file *m)
@@ -132,6 +247,9 @@ void memtest_report_meminfo(struct seq_file *m)
 	early_memtest_bad_size_kb = early_memtest_bad_size >> 10;
 	if (early_memtest_bad_size && !early_memtest_bad_size_kb)
 		early_memtest_bad_size_kb = 1;
+	/* If address bus test found failures, ensure we don't report 0 */
+	if (addr_bus_test_done && addr_bus_failed_bits && !early_memtest_bad_size_kb)
+		early_memtest_bad_size_kb = 1;
 	/* When 0 is reported, it means there actually was a successful test */
 	seq_printf(m, "EarlyMemtestBad:   %5lu kB\n", early_memtest_bad_size_kb);
 }
-- 
2.52.0


