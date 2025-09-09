Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59862CAC58C
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 20:15:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0EB08E0021; Tue,  9 Sep 2025 16:15:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 997FC8E0019; Tue,  9 Sep 2025 16:15:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 838F88E0021; Tue,  9 Sep 2025 16:15:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 68CA28E0019
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:15:52 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3303F140592
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 20:15:52 +0000 (UTC)
X-FDA: 83870817744.14.5259FE2
Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5A2D118000D
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 20:15:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=yandex-team.com header.s=default header.b=ypBkuNKW;
	spf=pass (imf16.hostedemail.com: domain of arbn@yandex-team.com designates 178.154.239.72 as permitted sender) smtp.mailfrom=arbn@yandex-team.com;
	dmarc=pass (policy=none) header.from=yandex-team.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757448950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m8A5M9SWZ4FduOae9/W265UdgKKBYKII8mDM46+RgEM=;
	b=HRdkHorlEBVYFALBeP1pnc1M37E9vk0WLGGszsTNH4uCDnVUGodWSJC6Xh9FMtbXDL1hZ+
	OttkWbpKI8KSj/sAfYQWjugQuc+EOW50VY2a1knuWHXcZX2oMpOjFxIaw4eldSQfNnKCL6
	BAwXMb9sG9mR4ryn7NYEHjJ4ivvMwSc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=yandex-team.com header.s=default header.b=ypBkuNKW;
	spf=pass (imf16.hostedemail.com: domain of arbn@yandex-team.com designates 178.154.239.72 as permitted sender) smtp.mailfrom=arbn@yandex-team.com;
	dmarc=pass (policy=none) header.from=yandex-team.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757448950; a=rsa-sha256;
	cv=none;
	b=gsb/IO0JS9fUTwZ7X8I/9qjRKW5QvxrC9fgoh0hrm29xBsneS1xWMkCmz87pL/rEI+c96h
	3EfrceDim2BBOhJNoL01WNf53F3U5PjTpNxG7w+p8TJrz78cjfSWXjrbBO5F9zL6vjo1sv
	Tc1gMBnmUQz6lzwm7FBBk1EUgbQdLV4=
Received: from mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net [IPv6:2a02:6b8:c1f:3a87:0:640:845c:0])
	by forwardcorp1a.mail.yandex.net (Yandex) with ESMTPS id EE366C01AB;
	Tue, 09 Sep 2025 23:15:48 +0300 (MSK)
Received: from localhost.localdomain (172.31.115.73-vpn.dhcp.yndx.net [172.31.115.73])
	by mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id IFQqlX5GteA0-QszPafCr;
	Tue, 09 Sep 2025 23:15:48 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.com;
	s=default; t=1757448948;
	bh=m8A5M9SWZ4FduOae9/W265UdgKKBYKII8mDM46+RgEM=;
	h=Message-ID:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=ypBkuNKW+ERXO+vB9wi+MesqhXDJci+Z58snBgpV01YxOdZZSgyD0EiGOS1d6ChRM
	 hs4mlstpXx3wA2LGBMtVkU4uQU0M8JpfQTx3pK+DQa36tE3REBAz6GdNN58l44rh9q
	 GyjRrorPLSUoRNijR571xdfTd90C7ZpqX08mC7Vk=
From: Andrey Ryabinin <arbn@yandex-team.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	James Gowans <jgowans@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Baoquan He <bhe@redhat.com>,
	kexec@lists.infradead.org,
	Pratyush Yadav <ptyadav@amazon.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	David Rientjes <rientjes@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Chris Li <chrisl@kernel.org>,
	Ashish.Kalra@amd.com,
	William Tu <witu@nvidia.com>,
	David Matlack <dmatlack@google.com>,
	Andrey Ryabinin <arbn@yandex-team.com>
Subject: [PATCH v3 6/7] mm/memblock: Use KSTATE instead of kho to preserve preserved_mem_table
Date: Tue,  9 Sep 2025 22:14:41 +0200
Message-ID: <20250909201446.13138-7-arbn@yandex-team.com>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250909201446.13138-1-arbn@yandex-team.com>
References: <20250909201446.13138-1-arbn@yandex-team.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5A2D118000D
X-Rspamd-Server: rspam05
X-Stat-Signature: 1eoq7tg6mub5g8ipry74j9r3r5b73c5t
X-Rspam-User: 
X-HE-Tag: 1757448950-256321
X-HE-Meta: U2FsdGVkX180EpxRBqCJo2XCFMs82lkXc3KvZIioSxa0wLcots+DU2JLsQANkO83JFsMkL8K9CI78GAku0VZXxUcsIbJj5wMtX8fnA2dTRtTGmhgnPJNZnRJSXw0VSnG1FVB4wuMF8g/kkOO/icrBZteRybDQo3QIgC3z/o73gABxyem3pamYUvYwwT7edvrs9B1NgEI2/mA9Pmrw8d46RjFaEpN/nXJDLKI4/MSe61pd0PMbKjzEsXtQZJskeo6CH8JNqKbiWw/85Ym+94QLNfCpvxTQKZrKfl9z4jojpeT4l2jRU1DTnUlLHYJ41r9F33plRMfQNz+mvxQFRgookqeiyAj0aEqnPuvj/Xcxos/5G2O0Wmmd8zyK3+5bLkqastewxHSVU1w3xwjmiviOk6uMS35h4l+gDdNv2rQKD64L46piYbYAeKVGJ6KHpEsPcwvl7dn2oIqX+1ilmDiEXd18zXbF1wE6WlX+2dqLzy4qlt8AcbQ2OYwQeVUqemhT/OnuG0+/hmd6pMgJl7DZFHyvuEUHtn3JuYGQv5llJt6eXq3qGRQqEUj36Y4f02RjIy4+NbtZyZkyjvDE7iMSEZi8CtDAc19t8DIu2p4y8/TqWfs+yz3SS45XBft18NTc2/bqtiHrPOVb+dM4q1hiFpY80Elu9fH6WmIU+9EKkyAi0hOpUb5VVNfKxcYMScwLuf96jJWboXlqP7idqWQQVErF7G2JmLc7yruxmAqBYsJPpvstTRk1d4st6edilIS84rh7n4iT5C0bGqJ4CMtJMCqKRlDecNaypDMiXx4e/0xqoJgQ/C+uc5CTFOBVrjd0MTvBh3lTwmcsB7bZvYnOBtyqotVBQv4/M9zZDyNAs1JVrqKVReMQ7HJPmCh3lJGkIRUQhL4QLTxTLvi2Py+c/n9AE2dbisl3nr9B6p3d3jkrVmGwFpc7Suia/ySbKlPLNHTYK3XGQCCziZplKd
 EftUTYpN
 1fHQozNfmXg/h6ASZ2CrMqyCOK4ER9dhh4G7NoWYjSkigH6N12PSjwJ8c6IMfSMoyO+TT6vFUYgX4pUCHU31ESI806Z5D1lAAqMG98GYPgJqiEfWhX+USv2ygk/O29sY+velXTPP2hBu9tlNdtuDfwIzJBoEqf+gSnOczEzSUvpI/vZ3eeXnWBXMytm7nwOmeGSTgRP4Pne7+4nDc0eyliX3RgA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently preserved_mem_table serialized/deserialized using fdt. Use KSTATE
instead as it makes code simpler and more compact.

Signed-off-by: Andrey Ryabinin <arbn@yandex-team.com>
---
 include/linux/kstate.h |   1 +
 mm/memblock.c          | 158 +++++++++++++----------------------------
 2 files changed, 49 insertions(+), 110 deletions(-)

diff --git a/include/linux/kstate.h b/include/linux/kstate.h
index 0ced0da37c8f..db8ba07e2319 100644
--- a/include/linux/kstate.h
+++ b/include/linux/kstate.h
@@ -97,6 +97,7 @@ enum kstate_ids {
 	KSTATE_KHO_FDT_ID,
 	KSTATE_TEST_ID,
 	KSTATE_TEST_ID_V2,
+	KSTATE_RESERVED_MEM_ID,
 	KSTATE_LAST_ID = -1,
 };
 
diff --git a/mm/memblock.c b/mm/memblock.c
index 6af0b51b1bb7..b9d84d1ffd83 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -14,11 +14,13 @@
 #include <linux/pfn.h>
 #include <linux/debugfs.h>
 #include <linux/kmemleak.h>
+#include <linux/kstate.h>
 #include <linux/seq_file.h>
 #include <linux/memblock.h>
 #include <linux/mutex.h>
 
 #ifdef CONFIG_KEXEC_HANDOVER
+#include <linux/crc32.h>
 #include <linux/libfdt.h>
 #include <linux/kexec_handover.h>
 #endif /* CONFIG_KEXEC_HANDOVER */
@@ -2498,140 +2500,76 @@ int reserve_mem_release_by_name(const char *name)
 }
 
 #ifdef CONFIG_KEXEC_HANDOVER
-#define MEMBLOCK_KHO_FDT "memblock"
-#define MEMBLOCK_KHO_NODE_COMPATIBLE "memblock-v1"
-#define RESERVE_MEM_KHO_NODE_COMPATIBLE "reserve-mem-v1"
-
-static int __init prepare_kho_fdt(void)
-{
-	int err = 0, i;
-	struct page *fdt_page;
-	void *fdt;
-
-	fdt_page = alloc_page(GFP_KERNEL);
-	if (!fdt_page)
-		return -ENOMEM;
-
-	fdt = page_to_virt(fdt_page);
-
-	err |= fdt_create(fdt, PAGE_SIZE);
-	err |= fdt_finish_reservemap(fdt);
-
-	err |= fdt_begin_node(fdt, "");
-	err |= fdt_property_string(fdt, "compatible", MEMBLOCK_KHO_NODE_COMPATIBLE);
-	for (i = 0; i < reserved_mem_count; i++) {
-		struct reserve_mem_table *map = &reserved_mem_table[i];
-
-		err |= kho_preserve_phys(map->start, map->size);
-		err |= fdt_begin_node(fdt, map->name);
-		err |= fdt_property_string(fdt, "compatible", RESERVE_MEM_KHO_NODE_COMPATIBLE);
-		err |= fdt_property(fdt, "start", &map->start, sizeof(map->start));
-		err |= fdt_property(fdt, "size", &map->size, sizeof(map->size));
-		err |= fdt_end_node(fdt);
-	}
-	err |= fdt_end_node(fdt);
-	err |= fdt_finish(fdt);
-
-	err |= kho_preserve_folio(page_folio(fdt_page));
-	err |= kho_add_subtree(MEMBLOCK_KHO_FDT, fdt);
-
-	if (err) {
-		pr_err("failed to prepare memblock FDT for KHO: %d\n", err);
-		put_page(fdt_page);
-	}
-
-	return err;
-}
+static int kstate_preserve_phys(struct kstate_stream *stream, void *obj,
+				const struct kstate_field *field)
+{
+	struct reserve_mem_table *map = obj;
+
+	return kho_preserve_phys(map->start, map->size);
+}
+
+struct kstate_description kstate_reserve_mem = {
+	.name = "reserved_mem",
+	.id = KSTATE_RESERVED_MEM_ID,
+	.fields = (const struct kstate_field[]) {
+		KSTATE_BASE_TYPE(name, struct reserve_mem_table,
+				char[RESERVE_MEM_NAME_SIZE]),
+		KSTATE_BASE_TYPE(start, struct reserve_mem_table, phys_addr_t),
+		KSTATE_BASE_TYPE(size, struct reserve_mem_table, phys_addr_t),
+		{
+			.name = "phys_range",
+			.flags = KS_CUSTOM,
+			.save = kstate_preserve_phys,
+		},
+		KSTATE_END_OF_LIST(),
+	},
+};
 
 static int __init reserve_mem_init(void)
 {
 	int err;
+	int i;
 
 	if (!kho_is_enabled() || !reserved_mem_count)
 		return 0;
 
-	err = prepare_kho_fdt();
-	if (err)
-		return err;
-	return err;
-}
-late_initcall(reserve_mem_init);
-
-static void *__init reserve_mem_kho_retrieve_fdt(void)
-{
-	phys_addr_t fdt_phys;
-	static void *fdt;
-	int err;
-
-	if (fdt)
-		return fdt;
-
-	err = kho_retrieve_subtree(MEMBLOCK_KHO_FDT, &fdt_phys);
-	if (err) {
-		if (err != -ENOENT)
-			pr_warn("failed to retrieve FDT '%s' from KHO: %d\n",
-				MEMBLOCK_KHO_FDT, err);
-		return NULL;
-	}
-
-	fdt = phys_to_virt(fdt_phys);
+	for (i = 0; i < reserved_mem_count; i++) {
+		struct reserve_mem_table *map = &reserved_mem_table[i];
 
-	err = fdt_node_check_compatible(fdt, 0, MEMBLOCK_KHO_NODE_COMPATIBLE);
-	if (err) {
-		pr_warn("FDT '%s' is incompatible with '%s': %d\n",
-			MEMBLOCK_KHO_FDT, MEMBLOCK_KHO_NODE_COMPATIBLE, err);
-		fdt = NULL;
+		err = kstate_register(&kstate_reserve_mem,
+				map, crc32(~0, map->name, RESERVE_MEM_NAME_SIZE));
+		if (err)
+			goto out;
 	}
-
-	return fdt;
+out:
+	return err;
 }
+late_initcall(reserve_mem_init);
 
 static bool __init reserve_mem_kho_revive(const char *name, phys_addr_t size,
 					  phys_addr_t align)
 {
-	int err, len_start, len_size, offset;
-	const phys_addr_t *p_start, *p_size;
-	const void *fdt;
+	struct reserve_mem_table *map = &reserved_mem_table[reserved_mem_count];
 
-	fdt = reserve_mem_kho_retrieve_fdt();
-	if (!fdt)
+	if (kstate_restore(&kstate_reserve_mem, map,
+				crc32(~0, name, RESERVE_MEM_NAME_SIZE)))
 		return false;
 
-	offset = fdt_subnode_offset(fdt, 0, name);
-	if (offset < 0) {
-		pr_warn("FDT '%s' has no child '%s': %d\n",
-			MEMBLOCK_KHO_FDT, name, offset);
-		return false;
-	}
-	err = fdt_node_check_compatible(fdt, offset, RESERVE_MEM_KHO_NODE_COMPATIBLE);
-	if (err) {
-		pr_warn("Node '%s' is incompatible with '%s': %d\n",
-			name, RESERVE_MEM_KHO_NODE_COMPATIBLE, err);
+	if (map->start & (align - 1)) {
+		pr_warn("KHO reserve-mem '%s' has wrong alignment (0x%pa, 0x%pa)\n",
+			name, &align, &map->start);
 		return false;
 	}
 
-	p_start = fdt_getprop(fdt, offset, "start", &len_start);
-	p_size = fdt_getprop(fdt, offset, "size", &len_size);
-	if (!p_start || len_start != sizeof(*p_start) || !p_size ||
-	    len_size != sizeof(*p_size)) {
+	if (map->size != size) {
+		pr_warn("KHO reserve-mem '%s' has wrong size (0x%pa != 0x%pa)\n",
+			name, &map->size, &size);
 		return false;
 	}
 
-	if (*p_start & (align - 1)) {
-		pr_warn("KHO reserve-mem '%s' has wrong alignment (0x%lx, 0x%lx)\n",
-			name, (long)align, (long)*p_start);
-		return false;
-	}
-
-	if (*p_size != size) {
-		pr_warn("KHO reserve-mem '%s' has wrong size (0x%lx != 0x%lx)\n",
-			name, (long)*p_size, (long)size);
-		return false;
-	}
-
-	reserved_mem_add(*p_start, size, name);
-	pr_info("Revived memory reservation '%s' from KHO\n", name);
-
+	pr_info("Revived memory reservation '%s' %pa %pa from KHO\n",
+		name, &map->start, &map->size);
+	reserved_mem_count++;
 	return true;
 }
 #else
-- 
2.49.1


