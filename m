Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0E95CA0EC0
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 08:25:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CE998E0013; Mon, 11 Aug 2025 04:25:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47E6E8E000A; Mon, 11 Aug 2025 04:25:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 346C78E0013; Mon, 11 Aug 2025 04:25:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1DFEF8E000A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 04:25:36 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CF9D8137BD0
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:25:35 +0000 (UTC)
X-FDA: 83763792630.22.3BC9A63
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf17.hostedemail.com (Postfix) with ESMTP id 50ED24000C
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:25:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BBu0tV7S;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754900734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D6mDOZNO2M8bgcPUt67qcFUpkk7LTdWtsD73Aun5+3g=;
	b=35HVKiYF54bOr4C/xQw4eOCdqyewFG0pq8WjGfN1q8Ii7hJhl+mtr9up7J7ueD4TCbc7V5
	2qLpFPkeUbTh/hPBH6dA5EAPjqGW6Y7USmcD1vAt10ata35AdbKU6gFW1PdFCwKlq7VIYN
	PUJ21xH4zrh2EjrXVP7xmtJ/VXI34aw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BBu0tV7S;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754900734; a=rsa-sha256;
	cv=none;
	b=AluHulnyCYivnNiyRV7VvxoZiBRFy293UZ0VRy82E/8w7X9LBmAsOcAqjipH6y0kWBhsPm
	8jvc+ZLWB61FUe8/nR2lo8uya8/0AjZSdu2Q0a61aF3Lu453IdFfZgoTI/lYY9GarYu630
	fMJxSgyEtiH+1BHcZacdzz7uki8FcJc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 8BF7F5C5E4B;
	Mon, 11 Aug 2025 08:25:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6E4DC4CEED;
	Mon, 11 Aug 2025 08:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754900733;
	bh=AX4qbF1XwwQU81rpLwIDoyjLFeF3rSGWbifPTbjdHrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BBu0tV7SisZJigpGLwfJlV2DUdG+zG1xMTy9xi/TIyeMR5QWWzL0vrHVWTDRyETLf
	 9wif8JusDG/lncKaw75hHOvcdqYqn/hmr+fqPbslLarR0lND4TxrjqOXleCy0VgHww
	 GueKwq1d+VQbbVudmODDZr+IKPx3dEjguWd30pfO49xBo595IUSrVNKUlqaptMEDm9
	 KP31uI9G5AP37tXrvaMBfcsjXU1W0CCSlWIXI4CgqU7P5fOOJ/Xo7AU7E4ynb4fCqu
	 n34r44Dg10BdzEJjqjj3L+enf9CPz3opBOem/pEGx2qDAobHWQmPbtyV9jD4PbU+67
	 7mhcCWzujOfug==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Graf <graf@amazon.com>,
	Baoquan He <bhe@redhat.com>,
	Changyuan Lyu <changyuanl@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	=?UTF-8?q?Thomas=20Wei=DFschuh?= <linux@weissschuh.net>,
	kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/3] lib/test_kho: fixes for error handling
Date: Mon, 11 Aug 2025 11:25:09 +0300
Message-ID: <20250811082510.4154080-3-rppt@kernel.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250811082510.4154080-1-rppt@kernel.org>
References: <20250811082510.4154080-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 50ED24000C
X-Rspamd-Server: rspam06
X-Stat-Signature: zgatwshz1gwraxbf68k4dugcm4bonrxt
X-HE-Tag: 1754900734-588779
X-HE-Meta: U2FsdGVkX1/6jhDWQQpu8yeLGmSpktutZy27Vvkaizv5+CYO15O+s4P45uVX8ypSsJDGzdZrzdkM2zf/RmqiMQGQuNXseagP2K5waTlOWEM7TJvCGkIziL9pmoEjsBzMqCzv/6aHAq17bjI+wghgM3DmWxwdo8b3luVXAVtkEIGOzTp+045xCRG9vGdKrem30QByMdhdRJgBN2wDKlUZgKWEayz/oWE3j+VD3+vu+SFWPHyaOjj4O66NRE16aPlIZ2B3Iuwi4XbIfhr/X1k63vlgPaIDPbERcJSHD/rKg9Z7G0VCm9w263gWekVRBngFFl2lNpVQ9lFpbcBKvaD51S5MfRoPUTv8dbuo0wrLNjnRpjiAR0BJZijtI2dFeX7nmZh4mpEbl6RHqi6moGwQwQEpo25msr0v4ZD7jFx2oZnpilvPjf07aDqZRzIbOFtaN9HU7mjoxqfjqkwwhcfvhLKQ/LRi4E+u1Aa2PxC46upESsL7Kz9loASnxiwHXCkN2sDU+hHBJv3vMHJ0lrXqA/gTsj2Zsx/pqW6ZOqk5ygOyZNhZ4HjRKmckkRriffZ4OLZWWMHqQqHLCmMONyXChNGknr1baVnISn2OMkV82zmcfwGFAtkkTHBBdbV+x8vLHtU5ZW7kcFt8mzPb8al0+CxX2yaZ+TNAdtcPdKUnx88PFWwtE/NEiBdlfOzXu1kP/uPdOeC2LALV+kViFU5wk8urqxEwCP2aeqkRGwWgqDA191csIiKoppRW6IOi42s3GduHMbdADKvKk6tWpkqr6cAWp4t9B4yn14vnJI4/zfZUogqSTPLzFoDLbGNAFWCqzHGkUyQPfg9XBmlG8XoDd+5OFX8IW1x4IGgqdWTKTxm4VBBN5S5q5HM2C5/KrNz2ZndouF/N1W2AIzsFJwo2LV39sRZCuW9awhud7Us7AdPL931mQmgzLNOLcs0pfEG4QjclZim9qN4yFLfDXE5
 ODUromAf
 4VlI7NczO/22HWhk3+Wr6sSSK4as/7aaIOYg/WyN0UPJ6rolzxfQju9HSF5vwSNE9ap7enXZH+nPQzMo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

* Update kho_test_save() so that folios array won't be freed when
  returning from the function and the fdt will be freed on error
* Reset state->nr_folios to 0 in  kho_test_generate_data() on error
* Simplify allocation of folios info in fdt.

Reported-by: Pratyush Yadav <pratyush@kernel.org>
Closes: https://lore.kernel.org/all/mafs0zfcjcepf.fsf@kernel.org
Fixes: b753522bed0b ("kho: add test for kexec handover")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 lib/test_kho.c | 52 ++++++++++++++++++++++++++++++++------------------
 1 file changed, 33 insertions(+), 19 deletions(-)

diff --git a/lib/test_kho.c b/lib/test_kho.c
index c2eb899c3b45..fe8504e3407b 100644
--- a/lib/test_kho.c
+++ b/lib/test_kho.c
@@ -67,13 +67,20 @@ static struct notifier_block kho_test_nb = {
 
 static int kho_test_save_data(struct kho_test_state *state, void *fdt)
 {
-	phys_addr_t *folios_info __free(kvfree) = NULL;
+	phys_addr_t *folios_info;
 	int err = 0;
 
-	folios_info = kvmalloc_array(state->nr_folios, sizeof(*folios_info),
-				     GFP_KERNEL);
-	if (!folios_info)
-		return -ENOMEM;
+	err |= fdt_begin_node(fdt, "data");
+	err |= fdt_property(fdt, "nr_folios", &state->nr_folios,
+			    sizeof(state->nr_folios));
+	err |= fdt_property_placeholder(fdt, "folios_info",
+					state->nr_folios * sizeof(*folios_info),
+					(void **)&folios_info);
+	err |= fdt_property(fdt, "csum", &state->csum, sizeof(state->csum));
+	err |= fdt_end_node(fdt);
+
+	if (err)
+		return err;
 
 	for (int i = 0; i < state->nr_folios; i++) {
 		struct folio *folio = state->folios[i];
@@ -83,17 +90,9 @@ static int kho_test_save_data(struct kho_test_state *state, void *fdt)
 
 		err = kho_preserve_folio(folio);
 		if (err)
-			return err;
+			break;
 	}
 
-	err |= fdt_begin_node(fdt, "data");
-	err |= fdt_property(fdt, "nr_folios", &state->nr_folios,
-			    sizeof(state->nr_folios));
-	err |= fdt_property(fdt, "folios_info", folios_info,
-			    state->nr_folios * sizeof(*folios_info));
-	err |= fdt_property(fdt, "csum", &state->csum, sizeof(state->csum));
-	err |= fdt_end_node(fdt);
-
 	return err;
 }
 
@@ -140,7 +139,10 @@ static int kho_test_generate_data(struct kho_test_state *state)
 		unsigned int size;
 		void *addr;
 
-		/* cap allocation so that we won't exceed max_mem */
+		/*
+		 * Since get_order() rounds up, make sure that actual
+		 * allocation is smaller so that we won't exceed max_mem
+		 */
 		if (alloc_size + (PAGE_SIZE << order) > max_mem) {
 			order = get_order(max_mem - alloc_size);
 			if (order)
@@ -165,13 +167,14 @@ static int kho_test_generate_data(struct kho_test_state *state)
 err_free_folios:
 	for (int i = 0; i < state->nr_folios; i++)
 		folio_put(state->folios[i]);
+	state->nr_folios = 0;
 	return -ENOMEM;
 }
 
 static int kho_test_save(void)
 {
 	struct kho_test_state *state = &kho_test_state;
-	struct folio **folios __free(kvfree) = NULL;
+	struct folio **folios;
 	unsigned long max_nr;
 	int err;
 
@@ -185,13 +188,23 @@ static int kho_test_save(void)
 
 	err = kho_test_generate_data(state);
 	if (err)
-		return err;
+		goto err_free_folios;
 
 	err = kho_test_prepare_fdt(state);
 	if (err)
-		return err;
+		goto err_free_folios;
 
-	return register_kho_notifier(&kho_test_nb);
+	err = register_kho_notifier(&kho_test_nb);
+	if (err)
+		goto err_free_fdt;
+
+	return 0;
+
+err_free_fdt:
+	folio_put(state->fdt);
+err_free_folios:
+	kvfree(folios);
+	return err;
 }
 
 static int kho_test_restore_data(const void *fdt, int node)
@@ -291,6 +304,7 @@ static void kho_test_cleanup(void)
 		folio_put(kho_test_state.folios[i]);
 
 	kvfree(kho_test_state.folios);
+	folio_put(kho_test_state.fdt);
 }
 
 static void __exit kho_test_exit(void)
-- 
2.47.2


