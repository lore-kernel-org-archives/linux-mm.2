Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84BCCCCD1A5
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 10:03:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F8078E0016; Mon, 20 Oct 2025 06:03:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A4128E0002; Mon, 20 Oct 2025 06:03:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E88118E0016; Mon, 20 Oct 2025 06:03:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CB6BA8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 06:03:16 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9066713BB12
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:03:16 +0000 (UTC)
X-FDA: 84018054792.06.8E25D4F
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf24.hostedemail.com (Postfix) with ESMTP id D1B7918000D
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:03:14 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lSBuxv87;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 34Qj2aAgKCBo90IEDC8K6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--jasonmiu.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=34Qj2aAgKCBo90IEDC8K6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--jasonmiu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760954594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lWYMfKzAMwpC3rMo+EO7RJrq8DN+4fyyYi/w0NuGFhk=;
	b=6I6rFvm1llXNxVoxip3GMpBR5dH7ZsnMR2ulK2k09y/x7zDvcbdCByxvlrhNuFYnZesOwl
	dM1YYLrj4yu8BFiYt9J1Fkhl3OgmT+dypYimKhgjRa97BqiMCuMP6XHyHXFzlXVscC7o1V
	ORe613n4Ipeo5VrCLyAUHV/AsyI1cD8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760954594; a=rsa-sha256;
	cv=none;
	b=v5r4kvieEPA63lxDQM/87XrHiunLHRwdbxiM42+m8lGoHlRYEqwGU+/iC+9boU6wihst0O
	P0/vYWKfbfl0UFoJf/tEdZBvGSUIvV9zrTyTzaeH6fGpbxM4LpQ3a0oQNkg6lkjzbBC4sj
	tKJ8odxmACZMmCLIttqg3698st8ffO8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lSBuxv87;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 34Qj2aAgKCBo90IEDC8K6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--jasonmiu.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=34Qj2aAgKCBo90IEDC8K6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--jasonmiu.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3324538ceb0so7935797a91.1
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 03:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760954594; x=1761559394; darn=kvack.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lWYMfKzAMwpC3rMo+EO7RJrq8DN+4fyyYi/w0NuGFhk=;
        b=lSBuxv873MONv3byw4NPQ7cqILFtlnRxOaEIAATPaYkkGHgH/nVt7QBQtvYKVhrsKZ
         TevEhdFVjf/Jf69eb87UYQ9OVJAob0hTSRVHpHKXpKaVE/Uy5kchSqNXOVf0UALOT2MZ
         YJsUQTudBTFxhgh88HUuAmpAgT3Ce8te/Bwjqo5mVg2XFd5IRAWqSLtPnmFdozJOJK1q
         GpkAeynzjIK8xAbrSUgd2JyM8HN6RK6qfSJFlpdcTh2AMmvxwdni+wR0z5sx3wkBl1Pg
         ii4SdOIF/tN+9F8GUoHy1JOakOz/+xrPcIU75hQZ0M8OamEBtJbezgjdz2OEBvFjSXOa
         JRVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760954594; x=1761559394;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lWYMfKzAMwpC3rMo+EO7RJrq8DN+4fyyYi/w0NuGFhk=;
        b=KZfNyuePRkfhBfnKTAd7L8JpFUfJpgBK/jdHrj2mMV4loQXw3x4IY7288Rqzve9lCi
         XUgVa/IzK/+/mzEFUdd3JYB0kXHM7XvjuFiMK0zW/EojITrrwQm282k/VLuo5q55yPZY
         YDKU2d+oFxZqNpFctfCWNK6KbwBMk19iYjSaeITB0zm2nzdiStzzlxvF0fjJv6AcMLeM
         zDNQ+SFpVwy5+TYzE8ukh/nSZTe/m10d7M5nbWRSYjc1kA4FNtcfrLzm5KsAu0xBongc
         rV47lOttyrLkp5fba4tSpDoMoFDfFgDVHPFLiaz2nWvQ8wsnfCe31h3UX3/okCogr+N3
         8rdw==
X-Forwarded-Encrypted: i=1; AJvYcCUjNNmClgEd7SZ+7Y3hAIqB/Sd+k3+oq4OizQhL1CSLV4HxsKD5MzP+yn1PsxIapvowwb4PGPnPPA==@kvack.org
X-Gm-Message-State: AOJu0YzwtcX09hJ8tuFN75/FKVeGtOHejSqrSJjqMgHUJmnmZ0D97nQI
	6owWDtL+r+bDb09fIrvrbKtAwcSsVyzRxa2qDpObnXqjQKal9XV9AuWAk3rXgiiUxxq7BdH0Lk9
	3Rn9ZuRAwqIaPJA==
X-Google-Smtp-Source: AGHT+IEYcb3O7V1ky5jKWFnqxa+/2YZV8/a9EZaxLZJsoQaIasplHaDB8TXWgZyuKJmpJffHcKoX/v4QSLaLJg==
X-Received: from plll4.prod.google.com ([2002:a17:902:d044:b0:290:b0eb:f853])
 (user=jasonmiu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:d586:b0:268:db2:b78e with SMTP id d9443c01a7336-290cba42358mr144766195ad.60.1760954593812;
 Mon, 20 Oct 2025 03:03:13 -0700 (PDT)
Date: Mon, 20 Oct 2025 03:03:05 -0700
In-Reply-To: <20251020100306.2709352-1-jasonmiu@google.com>
Mime-Version: 1.0
References: <20251020100306.2709352-1-jasonmiu@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251020100306.2709352-3-jasonmiu@google.com>
Subject: [PATCH v2 2/3] memblock: kho: Remove KHO notifier usage
From: Jason Miu <jasonmiu@google.com>
To: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Miu <jasonmiu@google.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: D1B7918000D
X-Rspamd-Server: rspam02
X-Stat-Signature: 6tktjxw4q39met4ct57zxm9fbbptj696
X-HE-Tag: 1760954594-475776
X-HE-Meta: U2FsdGVkX18n39ul16uIQWqouO0FrpB57yKrECoe26o5jTUBTDkFlDlAM8A31VPikRg0PgaqRWiE9i0PyyVhRhb0DYAiOG08RViJVWjrM9g5x/zFfJUVc24vWQJosTHebzKvz8uIWrTveo7kU6CKZthHXZA8l5YmpRG70q0FubA8yCuulwZgGhht8D6SP4sgXMD12qExN5Z/41rhAwuFoKcIfLCNqZrh+RDa5Q32tI791g0u25tfGJTozAyUHq2AhjamKs9WTAf2o50SkPzpwVm7DnBwG0MCuoiujJuZVpuezGWdBikv70mGUTPGkOiA+CRkMfXeuEsTaky9AHRRoH2p1CmEysKnWKkfjSxQLG7bZAcFOQLlrPbTv45MytWMNu1yfURMPiT21O1SJqXPkVK11MaThJ6kOz+rE9ymkQGhQTi5MHGAR7nHCss0ZGkYBUca+NlKMX5j2Ytgxk40wOYk+1NOeBjrAmhmT6KS1PCf3vy9UYsXzlDOn65r+zJ3TL0awY4qjNmMv5LUmKm4nSjAR6WWW8h7mOJs3Y59JuSRk9TJd358VO1kTmMgGclBe8k6ClGN3mitD4R720dNLtZzCIUMehTIZHrZH1IbzfVcb88XiIVJshPOefOq/ikTRr4dSRaUjR/grnR1fc88tqRXbSCNLXrjZdQKdACYXBmLnOzmcBVL7oUtBxXj99wZRnx8e929ZdvR3zp42Wj+e8pV9InaRPm9KVOg7upiqeYKUXc2WS9y7Hh0KEjnDK/Sf1jGeSZ12+Q391gz4S+778Xbj0ksNgiE+o+PzSOSg8luhz/GvU0iJ/6a+8QLzhyn923Wd3xcsYHG7bIQ0tS04AJrbIxLGiXc+QKe5l3qlOmVTPs1jfU111rlGAhoRc8KEtjIcyD02rcdxEBOKSFmpYxSVvWW+aaZZ6m6tu0hmPlJ66dJdIkc/sbrYi7DsB9WGDzoDE4BmX+b1sCgAkE
 rjBYUvzF
 zU689gZIXbujTtfkpQZqI7AAerpQFdZDrcUnuKdr8Gu8NJZ6B/DpzkEWfWkPoamAjTjcbAPWq2B7lozmAkvi2d3R2fnVfSKvqHhP75byor6oTNr13SOdWCbzl4TQVYOx4CVffwv6eA95bN2Qd3SzNBhrY7ilsfyl/GYXly9yiIAXszN0pxT1FGp5Z20fqBc8Lx5yUKd/FCnN+IeFFFP8rf5xPehftPRoVJUFhfCngUrgZoZwsxZFxb58k8oS3lkLcCDFfsXHQbj5aLmXVtMfqJ+EXzF0qtIc0MA4lvYT8ju/Vks8heUHpIpoctAbRzFOuUUFvhf1jixq/CyNWNkPxf2DQ38h6Gj1OFj8Epi7AfgbQVCfxwh4GTwgRr6NUCXGW+hk1mIo13BvbLs9aBUwj4wnLUdguHKEVqHzWiGLf2gsc7KGLh0tHYEp767TKRi2ECgBctYhmmQ24ze4QFka+VlJChX11TidPdZds4UeZWrovJjj5933FWa4iT0hBwIq8x8YQ9WN0CMsTaSAH3dusq4qGoNqCQuVs2LsGNUzTeBcjfqW4gTz3um2PhA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove the KHO notifier registration and callbacks from the memblock
subsystem. These notifiers were tied to the former KHO finalize and
abort events, which are no longer used.

Memblock now preserves its `reserve_mem` regions and registers its
metadata by calling kho_preserve_phys(), kho_preserve_folio(), and
kho_add_subtree() directly within its initialization function.

KHO selftest is also updated with this deprecation of notifier.

Signed-off-by: Jason Miu <jasonmiu@google.com>
---
 include/linux/kexec_handover.h     |  5 ++--
 kernel/kexec_handover.c            |  3 +-
 lib/test_kho.c                     | 28 ++++---------------
 mm/memblock.c                      | 45 +++++++-----------------------
 tools/testing/selftests/kho/init.c | 19 -------------
 5 files changed, 18 insertions(+), 82 deletions(-)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index bc2f9e060a79..1f2ca09519a1 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -27,7 +27,7 @@ bool kho_is_enabled(void);
 int kho_preserve_folio(struct folio *folio);
 int kho_preserve_phys(phys_addr_t phys, size_t size);
 struct folio *kho_restore_folio(phys_addr_t phys);
-int kho_add_subtree(struct kho_serialization *ser, const char *name, void *fdt);
+int kho_add_subtree(const char *name, void *fdt);
 int kho_remove_subtree(const char *name);
 int kho_retrieve_subtree(const char *name, phys_addr_t *phys);
 
@@ -59,8 +59,7 @@ static inline struct folio *kho_restore_folio(phys_addr_t phys)
 	return NULL;
 }
 
-static inline int kho_add_subtree(struct kho_serialization *ser,
-				  const char *name, void *fdt)
+static inline int kho_add_subtree(const char *name, void *fdt)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index 2fc5975690a7..1138b16fa546 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -688,7 +688,6 @@ static struct kho_out kho_out = {
 
 /**
  * kho_add_subtree - record the physical address of a sub FDT in KHO root tree.
- * @ser: serialization control object passed by KHO notifiers.
  * @name: name of the sub tree.
  * @fdt: the sub tree blob.
  *
@@ -701,7 +700,7 @@ static struct kho_out kho_out = {
  *
  * Return: 0 on success, error code on failure
  */
-int kho_add_subtree(struct kho_serialization *ser, const char *name, void *fdt)
+int kho_add_subtree(const char *name, void *fdt)
 {
 	void *root_fdt = page_to_virt(kho_out.ser.fdt);
 	u64 phys = (u64)virt_to_phys(fdt);
diff --git a/lib/test_kho.c b/lib/test_kho.c
index c2eb899c3b45..e4307587a713 100644
--- a/lib/test_kho.c
+++ b/lib/test_kho.c
@@ -38,33 +38,16 @@ struct kho_test_state {
 
 static struct kho_test_state kho_test_state;
 
-static int kho_test_notifier(struct notifier_block *self, unsigned long cmd,
-			     void *v)
+static int kho_test_preserve(void)
 {
-	struct kho_test_state *state = &kho_test_state;
-	struct kho_serialization *ser = v;
 	int err = 0;
 
-	switch (cmd) {
-	case KEXEC_KHO_ABORT:
-		return NOTIFY_DONE;
-	case KEXEC_KHO_FINALIZE:
-		/* Handled below */
-		break;
-	default:
-		return NOTIFY_BAD;
-	}
-
-	err |= kho_preserve_folio(state->fdt);
-	err |= kho_add_subtree(ser, KHO_TEST_FDT, folio_address(state->fdt));
+	err |= kho_preserve_folio(kho_test_state.fdt);
+	err |= kho_add_subtree(KHO_TEST_FDT, folio_address(kho_test_state.fdt));
 
-	return err ? NOTIFY_BAD : NOTIFY_DONE;
+	return err;
 }
 
-static struct notifier_block kho_test_nb = {
-	.notifier_call = kho_test_notifier,
-};
-
 static int kho_test_save_data(struct kho_test_state *state, void *fdt)
 {
 	phys_addr_t *folios_info __free(kvfree) = NULL;
@@ -191,7 +174,7 @@ static int kho_test_save(void)
 	if (err)
 		return err;
 
-	return register_kho_notifier(&kho_test_nb);
+	return kho_test_preserve();
 }
 
 static int kho_test_restore_data(const void *fdt, int node)
@@ -295,7 +278,6 @@ static void kho_test_cleanup(void)
 
 static void __exit kho_test_exit(void)
 {
-	unregister_kho_notifier(&kho_test_nb);
 	kho_test_cleanup();
 }
 module_exit(kho_test_exit);
diff --git a/mm/memblock.c b/mm/memblock.c
index 117d963e677c..602a16cb467a 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2510,39 +2510,6 @@ int reserve_mem_release_by_name(const char *name)
 #define RESERVE_MEM_KHO_NODE_COMPATIBLE "reserve-mem-v1"
 static struct page *kho_fdt;
 
-static int reserve_mem_kho_finalize(struct kho_serialization *ser)
-{
-	int err = 0, i;
-
-	for (i = 0; i < reserved_mem_count; i++) {
-		struct reserve_mem_table *map = &reserved_mem_table[i];
-
-		err |= kho_preserve_phys(map->start, map->size);
-	}
-
-	err |= kho_preserve_folio(page_folio(kho_fdt));
-	err |= kho_add_subtree(ser, MEMBLOCK_KHO_FDT, page_to_virt(kho_fdt));
-
-	return notifier_from_errno(err);
-}
-
-static int reserve_mem_kho_notifier(struct notifier_block *self,
-				    unsigned long cmd, void *v)
-{
-	switch (cmd) {
-	case KEXEC_KHO_FINALIZE:
-		return reserve_mem_kho_finalize((struct kho_serialization *)v);
-	case KEXEC_KHO_ABORT:
-		return NOTIFY_DONE;
-	default:
-		return NOTIFY_BAD;
-	}
-}
-
-static struct notifier_block reserve_mem_kho_nb = {
-	.notifier_call = reserve_mem_kho_notifier,
-};
-
 static int __init prepare_kho_fdt(void)
 {
 	int err = 0, i;
@@ -2583,7 +2550,7 @@ static int __init prepare_kho_fdt(void)
 
 static int __init reserve_mem_init(void)
 {
-	int err;
+	int err, i;
 
 	if (!kho_is_enabled() || !reserved_mem_count)
 		return 0;
@@ -2592,7 +2559,15 @@ static int __init reserve_mem_init(void)
 	if (err)
 		return err;
 
-	err = register_kho_notifier(&reserve_mem_kho_nb);
+	for (i = 0; i < reserved_mem_count; i++) {
+		struct reserve_mem_table *map = &reserved_mem_table[i];
+
+		err |= kho_preserve_phys(map->start, map->size);
+	}
+
+	err |= kho_preserve_folio(page_folio(kho_fdt));
+	err |= kho_add_subtree(MEMBLOCK_KHO_FDT, page_to_virt(kho_fdt));
+
 	if (err) {
 		put_page(kho_fdt);
 		kho_fdt = NULL;
diff --git a/tools/testing/selftests/kho/init.c b/tools/testing/selftests/kho/init.c
index 8034e24c6bf6..211d6bda8961 100644
--- a/tools/testing/selftests/kho/init.c
+++ b/tools/testing/selftests/kho/init.c
@@ -27,22 +27,6 @@ static int mount_filesystems(void)
 	return mount("proc", "/proc", "proc", 0, NULL);
 }
 
-static int kho_enable(void)
-{
-	const char enable[] = "1";
-	int fd;
-
-	fd = open(KHO_FINILIZE, O_RDWR);
-	if (fd < 0)
-		return -1;
-
-	if (write(fd, enable, sizeof(enable)) != sizeof(enable))
-		return 1;
-
-	close(fd);
-	return 0;
-}
-
 static long kexec_file_load(int kernel_fd, int initrd_fd,
 			    unsigned long cmdline_len, const char *cmdline,
 			    unsigned long flags)
@@ -83,9 +67,6 @@ int main(int argc, char *argv[])
 	if (mount_filesystems())
 		goto err_reboot;
 
-	if (kho_enable())
-		goto err_reboot;
-
 	if (kexec_load())
 		goto err_reboot;
 
-- 
2.51.0.858.gf9c4a03a3a-goog


