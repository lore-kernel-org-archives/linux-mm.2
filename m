Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96287C5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 10:06:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57B226B00A1; Fri, 21 Aug 2026 06:06:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 553F46B00A2; Fri, 21 Aug 2026 06:06:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 468E06B00A3; Fri, 21 Aug 2026 06:06:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 21C3D6B00A1
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 06:06:44 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A1F3EC03C7
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:06:43 +0000 (UTC)
X-FDA: 85124847486.29.3EC70AA
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf03.hostedemail.com (Postfix) with ESMTP id E3D3E20009
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:06:41 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="d3fGZ/2J";
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf03.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787306801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J9aqNAg5ul6RSq/FAIbOKx+XdwPAzQxJAO/zzCdAwHg=;
	b=j3wPV6FBFhwW06qE6xX5tApQE9S9QwA2lLORnZRB6LifntBRjd+gNPnWqUgR8Bx4Iv200K
	uE6CwehPMsnW8OK4IiB8a9wwPgvpOanmrA1f+i6JvPMnVoXfXOv2EHsT276heCwZP+DCEH
	6aM3e3jgKWB89pSxpJRyhwRpuyD2tz4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="d3fGZ/2J";
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf03.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787306801;
	b=KlMC/NmtOVH7lMkwyv/l1oTju6af/NVrY1rKOHt01MlQHgfqOaEb2sjuF8GFOd+sADtX4T
	8lF/yuY8jGji03xXBDPLi4ZvwzhOpDqP4cN/sh+3J/zaprj37Vij0AKVXZZSQ1K2aGHzhj
	1bqQTqjYyYz4MqSa9TjjBGJvR44TcOc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=J9aqNAg5ul6RSq/FAIbOKx+XdwPAzQxJAO/zzCdAwHg=; b=d3fGZ/2JK5ycFLowGuvx2sagko
	DBQC52aw4xCgc1cWiJbV9UIZom2VHDYnjCdzz4+Zs7vfUzWC9oWMy2wvhCXLPtTXVohubf+jl/8WL
	GHZg1C1sKs1U3I72psWlyb1VIr8I8nGdzyhcCjny5UKMt5NbHxQE3xz5N88QiCGoDXM/tpGnyK+cc
	xLaGOF2RhrWVCKNwptPd7+DLoWzAZBVXhrkHmY+v97JsTUtYNJZvlWZpRj/iRqnGYH1PQppHiKjGg
	o6/LHvG9QSGIWKWMiwCM4iOQAgFT7FiefMM38b7sNMdTIS/LfBwbyRB5XgvU8YpvTZEJNzdU9wrJa
	aFMZU6UQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wxM8z-00BGBQ-0B;
	Fri, 21 Aug 2026 10:06:37 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 21 Aug 2026 03:06:03 -0700
Subject: [PATCH v2 3/6] efi/libstub: add the poisoned-memory EFI table
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260821-hwpoison-kho-v2-3-5743791e48e6@debian.org>
References: <20260821-hwpoison-kho-v2-0-5743791e48e6@debian.org>
In-Reply-To: <20260821-hwpoison-kho-v2-0-5743791e48e6@debian.org>
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, rmikey@meta.com, kas@kernel.org, riel@surriel.com, 
 kexec@lists.infradead.org, Breno Leitao <leitao@debian.org>, 
 kernel-team@meta.com
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=4996; i=leitao@debian.org;
 h=from:subject:message-id; bh=PTHqnbiTjtXvlEVFVF9aFX37DcM4Tdef+z9pkL5DEHI=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqiCMaNchcVhpLMCWBvw7ck5ypAhOqMQ6wjKKz4
 yvqQ/qq1eiJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaogjGgAKCRA1o5Of/Hh3
 bVD/D/0cN7PIq53NaWJ3IfCKiuNgIT98qPysaWAKjlETFbTUAQ1ql+39PrqBCdKE+THtkfP67Er
 DvsnOCjOXbWvAmFm9gqHdKX1dA4ugJHZRNFITE4uN2q7cDGFOeFVyzojQIuflFeCoRc9GovH8KH
 6BGU1quCuQWBocXDYLzILv//F3gXL47DO4IdI211yz+4jsOO0xPFEslQNQGXL7Q7UbRs46a3RzO
 P2jNzMggLWP9v8QbyM10ERON/iKEdxowGYdsQThd1STszA4xWHwQ+nZ30INvFCdxL4v2+SvsT8e
 JHxJbFjLeLDGkHMaK0+YmWF9JvjU7iInpO2zDVfNr2DE9u0wWALpZXDq/gYWDwh2rNozVXcfx7q
 1bWpej1lcTO/Z/lTjdbOay1iEv+xkyM+R3FaFB0K4EjzTfn2BqQItmwe1kLKKLSYNOCKO42PyrZ
 Snor5pRDsihsAxDXXhf+KQTdfCDwdvsqZfSiQA9ubP4qadteH22Uw7pQ7HaZXDqnZtvR4W34Bnh
 EoRFa3fF8JMIPuPsw47d1tVtXUOjXmfIV3dVQ43KGcc6UpwvPNNY0aDTOOksGdZynw8s0PxstCt
 tD3psHOQMQDZTO0vlqHTfhW4guGQZFmQJzyHzjyaaY7cExTdWGYEMeiXarWgg0IYHN0Apn3YomL
 uzN/V/b6T+Gbreg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Stat-Signature: cwcy8w5kb8xfnxht77ecjfoyx97fz6pm
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E3D3E20009
X-HE-Tag: 1787306801-232365
X-HE-Meta: U2FsdGVkX1/6hcQ0IYoeJM043dRj3sZis3tJwZHpPx9oNJpCEo0uveuEbf876dWjbozBZx9srElMI8BxjTpQQPtsTDkYY0q/tYRJgyvvnuhkFUuHBsb5JeQp68FaKezYmTWy8a9ZnoDyX/8VynfmcX9VSiE5ZFCehzqWsFGj3U14ALWeNLAKvwlOxQIuPpALz2SKckDrGm3+iy9koHcLB1fuGGAXe6JSpWcYCWdkxZcSqGYac4PWwiicbTIo5wSAOylDrpVr3sZBXs2BjXFg2b4aB04+0M4Xd6rVViro7JTHeMIYn6Ho2LJuuWT90wZJDSzX5RMKtDy+mIJfrPuBaJ0CVYKK70Iw2wpI2RvVqadhbSVLmAY1ef8VS5OAUckNKuJZs+EBMdEILPfZ6kIa+J6DtxEyoPk6fyXciI7so4NXHkkfFuVGGGDKa0uIg4kAdd7zQ1zbL2C5yeN2U3c4UJRrFiUgW4dAl4rZgytXGig2BVcV1S7nmcVi4MdmPKPqUlO7sUbTsAwjeANzN3Pc3k2aoTNaFpVqm88rb34Txo0Vx7aDkVcYPONvMInTb2n4DYNIKezuNEQZ4I0W9YaEvFLzoEhDZLQ8vHM1jd97DmdrQh5xomy/wzox2IJSINkCW6A0e72ZanYzziNlqGCCz0DOn2vzWQNyPAmq8vN+2tbbauJeaUJ3hoJ2AelAKSp7bEtOxoFZbNIICl6Y3nArT1hClBHvtLG4BgWLKxWgyfOAQUb7kyVmEU3jFFrLvL6dwxtw+TLtHBp5TdejI5Tbnn0IdJCjB5H0EI4E/Xl89wB44J4h4/12UDah5k0Ko53tflctRInKMwgKn6jeEn4eiRYbn3uWD4rdEFpXwqnDejW43emVL0sQDRZ5Rz1kAqXcbJdfcDJskEflMZziqBl60bjn31c5xSLv2d/owRV/4SrE5AVGZaNXPLk9hMiGRnT4cqLxTrZHzr3bdA+zXp9
 o6meKdJP
 NidG43D2vqGKPysOn7XuGnsm5mb+JbQP1PrSjZu07mrsM6qM9f0ugIa5yQIPAw6pTT41qa43aVV+bh20aZfsD9OU/GHMQzEOt9lh8wDftrv/fIAXdSyIaGhL6lqVgf7WMZ7z457afuZKrO1qgItCm8sCOrLQGCnSqgpRDcceORI0XSJxJncO6JNt2UOgO0O6/8UxjvIojeUL8/TVRoyHM2tDu4QBPlxn9e/MJ9t4lxRX/tpnlAUTMbFGnDze9KxGTipyFK2fT46VUqIMjHQW9sFxN7CySi/K3nf4rl+hdLOjCx0ZXseR9+Ewqw8llpRkTdPQx5vsAsb9mtecZiDHPDYeW6m8WUI5NX8ddDEpmLbMkOAY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A EFI config table can only be installed while boot services are
still up, so the stub has to create it; the running kernel can only
flip bits in a table that already exists.

Size the bitmap from efi_get_ram_top(): bit N covers unit N counting
from address 0, up to the top of usable RAM, so the table tracks
max_pfn. Memory the firmware hot-adds later sits above it and is not
carried across a kexec.

At one bit per 2M that is 64K per TiB. The 2M granule is called "unit"
here.

Cap the bitmap at 1M to make sure this doesn't get too big.

The next kernel reads unit_size back out of the table, so a wider unit
only costs precision: more memory withheld per poisoned frame, nothing
lost.

Allocate it as EFI_ACPI_RECLAIM_MEMORY so the next kernel does not take
it for free RAM, and install it empty.

A table installed by an earlier boot rides the system table across kexec
and is reused as-is.

Nothing calls it yet; the stub entry paths pick it up next.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/firmware/efi/libstub/efi-stub-helper.c | 89 ++++++++++++++++++++++++++
 drivers/firmware/efi/libstub/efistub.h         |  6 ++
 2 files changed, 95 insertions(+)

diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index f27f2e1f00199..7258ecdf1f7c2 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -774,3 +774,92 @@ void efi_remap_image(unsigned long image_base, unsigned alloc_size,
 			efi_warn("Failed to remap data region non-executable\n");
 	}
 }
+
+#ifdef CONFIG_EFI_POISONED_MEMORY
+/* Cap on the bitmap; a span too wide to fit gets a coarser unit instead. */
+#define EFI_POISON_MAX_TABLE_SIZE	SZ_1M
+#define EFI_POISON_MAX_UNIT_SIZE	SZ_1G
+
+/*
+ * Bitmap geometry for a given top of RAM. The bitmap starts at address 0, so
+ * bit N covers unit N.
+ * In the following code, a "unit" is granule of physical address space that one
+ * bitmap bit covers.
+ */
+static u32 efi_poison_geometry(u64 ram_top, u64 *bitmap_size)
+{
+	u64 nr_units = DIV_ROUND_UP(ram_top, EFI_POISON_UNIT_SIZE);
+	u32 unit_size = EFI_POISON_UNIT_SIZE;
+
+	while (DIV_ROUND_UP(nr_units, BITS_PER_BYTE) > EFI_POISON_MAX_TABLE_SIZE &&
+	       unit_size < EFI_POISON_MAX_UNIT_SIZE) {
+		nr_units = DIV_ROUND_UP(nr_units, 2);
+		unit_size *= 2;
+	}
+
+	*bitmap_size = DIV_ROUND_UP(nr_units, BITS_PER_BYTE);
+	return unit_size;
+}
+
+/* ACPI reclaim memory, so the next kernel does not treat it as free RAM. */
+static struct linux_efi_poisoned_memory *efi_poison_alloc(u64 bitmap_size,
+							  u32 unit_size)
+{
+	struct linux_efi_poisoned_memory *pm;
+	efi_status_t status;
+
+	status = efi_bs_call(allocate_pool, EFI_ACPI_RECLAIM_MEMORY,
+			     sizeof(*pm) + bitmap_size, (void **)&pm);
+	if (status != EFI_SUCCESS)
+		return NULL;
+
+	pm->version = 1;
+	pm->unit_size = unit_size;
+	pm->phys_base = 0;
+	pm->size = bitmap_size;
+	memset(pm->bitmap, 0, bitmap_size);
+
+	return pm;
+}
+
+/*
+ * Allocate and install the poisoned-memory bitmap while boot services are
+ * available
+ */
+void install_poisoned_memory_table(void)
+{
+	efi_guid_t poisoned_memory_table_guid = LINUX_EFI_POISONED_MEMORY_TABLE_GUID;
+	struct linux_efi_poisoned_memory *pm;
+	u64 ram_top, bitmap_size;
+	efi_status_t status;
+	u32 unit_size;
+
+	/* A table installed by an earlier boot rides the system table across kexec. */
+	pm = get_efi_config_table(poisoned_memory_table_guid);
+	if (pm) {
+		if (pm->version != 1)
+			efi_err("Unknown version of poisoned-memory table\n");
+		return;
+	}
+
+	if (efi_get_ram_top(&ram_top) != EFI_SUCCESS) {
+		efi_err("Failed to size the poisoned-memory table!\n");
+		return;
+	}
+
+	unit_size = efi_poison_geometry(ram_top, &bitmap_size);
+
+	pm = efi_poison_alloc(bitmap_size, unit_size);
+	if (!pm) {
+		efi_err("Failed to allocate poisoned-memory table!\n");
+		return;
+	}
+
+	status = efi_bs_call(install_configuration_table,
+			     &poisoned_memory_table_guid, pm);
+	if (status != EFI_SUCCESS) {
+		efi_bs_call(free_pool, pm);
+		efi_err("Failed to install poisoned-memory config table!\n");
+	}
+}
+#endif
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index 77ba576779aca..b5e19ba50ddae 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -1171,6 +1171,12 @@ efi_enable_reset_attack_mitigation(void) { }
 
 void efi_retrieve_eventlog(void);
 
+#ifdef CONFIG_EFI_POISONED_MEMORY
+void install_poisoned_memory_table(void);
+#else
+static inline void install_poisoned_memory_table(void) { }
+#endif
+
 struct sysfb_display_info *alloc_primary_display(void);
 struct sysfb_display_info *__alloc_primary_display(void);
 void free_primary_display(struct sysfb_display_info *dpy);

-- 
2.53.0-Meta


