Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80658C55172
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 21:53:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD00B6B0095; Fri, 31 Jul 2026 17:53:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D80CD6B0096; Fri, 31 Jul 2026 17:53:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C221E6B0098; Fri, 31 Jul 2026 17:53:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8C1736B0095
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 17:53:27 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 035901A0165
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 21:53:26 +0000 (UTC)
X-FDA: 85050423654.05.48DEE4E
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5580D100005
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 21:53:25 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pR7lhR1y;
	spf=pass (imf14.hostedemail.com: domain of 3UxltagoKCJQ9C4yBC12994CC492.0CA96BIL-AA8Jy08.CF4@flex--loganodell.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3UxltagoKCJQ9C4yBC12994CC492.0CA96BIL-AA8Jy08.CF4@flex--loganodell.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785534805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AKxRO57RwKQvgozbHnUQp+sB+wk0XehXYqNUOkWbMpk=;
	b=pUV4NZs44HNIWepg5+Gv4atDGA0j8ySk/lYGH2MUKyy/F/PxXMdNB9AZZ3wtzf0WMru1kn
	JpVixsP3lNCr6NENWjCbFa0qTyeDnsSt3MBo7EHGuH5b6tK/EXMo/j92uNrUjjy9Tfv/Jw
	wqC43DvP2fsTjlWpmVM1H2750QWCDuU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785534805;
	b=8qUV/cj30jyneP2O5nsu8SMeO/slvaCioV2a2hohzP8EQwVEp0OJrMEUTx4VKt8STzB4z0
	uwctaNEY4vJ+flu6CGbT1p/HvryK1xME3+Slec6WIn6K3dIRsgOQmohkCFzyeIi4+B9tMa
	R4JWjQ64yN6cQyRCTucbAG2Kciqyp/o=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pR7lhR1y;
	spf=pass (imf14.hostedemail.com: domain of 3UxltagoKCJQ9C4yBC12994CC492.0CA96BIL-AA8Jy08.CF4@flex--loganodell.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3UxltagoKCJQ9C4yBC12994CC492.0CA96BIL-AA8Jy08.CF4@flex--loganodell.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38e11baa66eso1356614a91.2
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 14:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785534804; x=1786139604; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AKxRO57RwKQvgozbHnUQp+sB+wk0XehXYqNUOkWbMpk=;
        b=pR7lhR1yLDZ8+DFDdMy5y/96QOG87wRll16/UFw6rs6ck0+1VsLl7JjLWvBx+xO8ZC
         hpxBCyGzfOvfFBE+sK2pjUW5LxJ6TiURro4tS229vqP3lWwEtV6YPnUmUZjmgesaUxku
         FkU+ngeOzunqeVBEVnVpm5I1n2s0VXTYS1vXX+VG70w26ULWxod+i3UIOvkToQFlQMn9
         SFE4D1Pl6i07OYVBTnX4U0FkbrcT99w0EKRSasfHdXABByAcam8RvN9yDk2bPuOplFuk
         x20BIZZNLXeTsgcr4ctsKWaAm76xJjVgmGMMA2Ij8pdXfB+LSbFDMVl4tupWxt1FEdST
         JfTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785534804; x=1786139604;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AKxRO57RwKQvgozbHnUQp+sB+wk0XehXYqNUOkWbMpk=;
        b=VwcgHzAPVwHonzYkB4AbclArs+1JWExZU1LYEDS8QLD6fI6TH7z3GlxElGwUUfUzze
         nVxnDoSr/7/+Tz/J9hwTbKvBODIqzLR1ICJRXkRH3A8RdCcj1ZbvhjG4bfyMuCtANl3d
         ORYGVwr5Cq7BlMpAxEjQO5qq5KfubXtm1YH3Umt/V7XLhhHcozf6VENDth6O2kFnmWFe
         hQULvQ7JF/wQ/SrL6e5AQPrplgyCQqMl/sYGlmGb+rQYSWx5aFYfj++o+XCwbkEZI7pb
         eFM+B6Zzzp5MANjBXc9wslaF4U7B/U36iKSVQZ8/30ZCBDEEKk5PUfnQy2kBqgsSRoCa
         uQvQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq+egA9M+TzbK+L74y6Q/uC1kxfLTIfZgvCL1FT8mUKlQMVf5znuiF51h6nr8R3l20SAR6Szt+j4A==@kvack.org
X-Gm-Message-State: AOJu0Yz0t1OkYa07MxbHvHx6BXDvIPGMhPXuPrN3YItml5GbcgusWKw0
	RfmSw2IMGDU9dGRzTGSV6GXkbwYmSEsBTnHgVHDGMD8yaZQsCI9WSHWuCf/sEUuZS8T7yJ5juzs
	ILRk8Z6vcVNpWe9GJ2isWZQ==
X-Received: from dlan2-n1.prod.google.com ([2002:a05:7022:eb42:10b0:13b:9346:627a])
 (user=loganodell job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4c41:b0:381:5a08:6291 with SMTP id 98e67ed59e1d1-38fbc4bc175mr1169108a91.20.1785534803987;
 Fri, 31 Jul 2026 14:53:23 -0700 (PDT)
Date: Fri, 31 Jul 2026 14:52:24 -0700
In-Reply-To: <20260731215224.831696-1-loganodell@google.com>
Mime-Version: 1.0
References: <20260731215224.831696-1-loganodell@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260731215224.831696-5-loganodell@google.com>
Subject: [RFC PATCH 4/4] kho: Add test cases for versioned subtrees
From: Logan Odell <loganodell@google.com>
To: graf@amazon.com, rppt@kernel.org, pasha.tatashin@soleen.com
Cc: pratyush@kernel.org, akpm@linux-foundation.org, kexec@lists.infradead.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Logan Odell <loganodell@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5580D100005
X-Stat-Signature: 68cg991dtgg45nfw4x9rpzgy6dh16m78
X-Rspam-User: 
X-HE-Tag: 1785534805-79299
X-HE-Meta: U2FsdGVkX1/R38Rb09qDa0WXI0P2ywKiOzKjZBk0FxwX3eYCbwFnsSVvx7VJE/5SKjeC/oZMx7uNLcQWTpAwr6xc7N35/e1fLIE9HsuLIDYt4BU834fRLurdvfsRIahh5oJaZHcjM++RKTboJvc+TCF/UdV+l3gDWWdUitIYCzUqb/r5xULn7Hmi1uUFGMny9OoPCiTEyOTCQceDdV8t+Mbb7AILUuBZaYF5fub6TGpGJfGgqArhT930S7P0Q0oaqovCi1/sEdsV6A439+83IhddR1AqTqAEns5zdOAO4sgyw1Odh9uDNtPufykIzrR3fBOyUw2FP6wGNQ2KlXmSMntfCoVwkFJiiXeA8iDxOkczg0U0W7Fn/v3if/tDoa7gC9bgSLnEYk9lez1wpDl+AGdCiu5pEcVi+rf6akldTvUZZU3PeWH42kr7z+dBMTFEO1EJXrSyl+cPZxlElBzh2j5tHnztQo85JPIAybTk3fFoqB957DBH2AwJ9VGdhYrald6QPALVZzmLFvFdtDyC1lbdfLwd1DKCfY1pzHWwEt505qZeVJuDstMALreecq5q//CcA3Ic+HvbU02VZLWSzp8askAxZU9YYVuTtzvVCUUyNsrfxWR1mhzzkyR2LSIXXq8H2ym+aCuPY5NTOfiqz/f5koSloXVPcjfSwLnYdwEpnfDoYtA4Z8+gQ9ifJp6DGOi/aSM8rksL/mM9sd7YlwmSlPymEHszIgfC175bNFTXHxgfJQ3KqEWIVZbhgeST+NniBweEKrKKL0HlF6PXpTFo7nx+eF6nQZAX2Sr36cjbvZ9MCg2/hjUb+z8zev9MRK8tgUrwz0O8EU/KBVV0x/ZRGG1StAPpcVyFc8PsSCV8HMzqcyEcVTfCaOMHsWOyFfWqPAbgW4lFIjHUKs9pN1RXKhGyxEgQuyYJfwlXOJwLmpaLTrQRgxIRlnHxpd1pGXbUur4wW/Rwt0R/GaB
 NdIlNwBV
 wE5M6X4gf0/7qAy47XDuyE4dJFFPcKvpEqGggwoNV1+Zj0uHQQyidNHZvZcXoXsr7P6HqGt1Ype1+Nq7sKvHSdmEf1Im7NSqthE6FOxXak4KebdBMtpc+4LBEJJvmluY8P+LxawvVznC+PkexqAM4QYTj/0oqVMVD0bamvCeK7yxjbiAPBuNxj/oYKOZWkUmKNJ+NNNQ563o6myj+HDv7d8+77w9EMOw6VbYKTLAvYdK+lUp/+i63WECQ+tHfqtCTQEGkkozHAEJgs1LjRqn4mqoxknQz/zViKU3bAA1G0SZ+ItF0FtWZSxpTnOVznCWI/ldbjzEbZRnYxa0/5vXPhZK7i39yO4b5UtPcYOMJmNJzdkkSg0ZDDD4tjCirP8E3vUSWxlF6HfoPrEoJaxuujn7S1VPhdOxuUh/bbzSXX/kUIwMXIoKUw7P/nCgOqgoLTXz4ilXca/VOfTVHlWy1i77Eox2oYtAiM6OxBlD66k29tl04Y/Ft8sXVyq2Hb/GqAnRPOTt8+etxfENnT5uCtZbtO5/C+fHGaffpHKONHLo0vAM+mHcAHy4BfhUQXcAJl0jNlJa9fJVHgAEG/ih3HxAS/Cohipp6uwIEDpu6Q+N25T4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add new test cases to test_kho.c to verify saving and restoring
multiple versions of a subtree. The test preserves versions 1 and 2
of "kho_test_ver" and retrieves them, verifying their contents.
It also ensures no memory leaks occur during the restore process.

Signed-off-by: Logan Odell <loganodell@google.com>
---
 lib/test_kho.c | 266 +++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 245 insertions(+), 21 deletions(-)

diff --git a/lib/test_kho.c b/lib/test_kho.c
index 7ef9e4061869..db531da63576 100644
--- a/lib/test_kho.c
+++ b/lib/test_kho.c
@@ -310,52 +310,276 @@ static int kho_test_restore(phys_addr_t fdt_phys)
 	return 0;
 }
 
+static void kho_test_cleanup(void)
+{
+	/* unpreserve and free the data stored in folios */
+	kho_test_unpreserve_data(&kho_test_state);
+	for (int i = 0; i < kho_test_state.nr_folios; i++)
+		folio_put(kho_test_state.folios[i]);
+
+	kvfree(kho_test_state.folios);
+
+	/* Unpreserve and release the FDT folio */
+	kho_unpreserve_folio(kho_test_state.fdt);
+	folio_put(kho_test_state.fdt);
+}
+
+#define KHO_TEST_VER_NAME	"kho_test_ver"
+#define KHO_TEST_VER_1		1
+#define KHO_TEST_VER_2		2
+#define KHO_TEST_VER_MAGIC_1	0x11111111
+#define KHO_TEST_VER_MAGIC_2	0x22222222
+
+struct kho_test_versioned_state {
+	struct folio *fdt1;
+	struct folio *fdt2;
+};
+
+static struct kho_test_versioned_state kho_test_ver_state;
+
+static int kho_test_prepare_ver_fdt(struct folio *folio, int version, unsigned int magic)
+{
+	void *fdt = folio_address(folio);
+	int err;
+
+	err = fdt_create(fdt, PAGE_SIZE);
+	err |= fdt_finish_reservemap(fdt);
+	err |= fdt_begin_node(fdt, "");
+	err |= fdt_property(fdt, "compatible", KHO_TEST_COMPAT, sizeof(KHO_TEST_COMPAT));
+	err |= fdt_property(fdt, "magic", &magic, sizeof(magic));
+	err |= fdt_property(fdt, "version", &version, sizeof(version));
+	err |= fdt_end_node(fdt);
+	err |= fdt_finish(fdt);
+
+	return err;
+}
+
+static int kho_test_ver_save(void)
+{
+	struct kho_test_versioned_state *state = &kho_test_ver_state;
+	int err;
+
+	state->fdt1 = folio_alloc(GFP_KERNEL, 0);
+	if (!state->fdt1)
+		return -ENOMEM;
+
+	state->fdt2 = folio_alloc(GFP_KERNEL, 0);
+	if (!state->fdt2) {
+		err = -ENOMEM;
+		goto err_free_fdt1;
+	}
+
+	err = kho_preserve_folio(state->fdt1);
+	if (err)
+		goto err_free_fdt2;
+
+	err = kho_preserve_folio(state->fdt2);
+	if (err)
+		goto err_unpreserve_fdt1;
+
+	err = kho_test_prepare_ver_fdt(state->fdt1, KHO_TEST_VER_1, KHO_TEST_VER_MAGIC_1);
+	if (err)
+		goto err_unpreserve_fdt2;
+
+	err = kho_test_prepare_ver_fdt(state->fdt2, KHO_TEST_VER_2, KHO_TEST_VER_MAGIC_2);
+	if (err)
+		goto err_unpreserve_fdt2;
+
+	err = kho_add_subtree_version(KHO_TEST_VER_NAME, KHO_TEST_VER_1,
+				      folio_address(state->fdt1));
+	if (err)
+		goto err_unpreserve_fdt2;
+
+	err = kho_add_subtree_version(KHO_TEST_VER_NAME, KHO_TEST_VER_2,
+				      folio_address(state->fdt2));
+	if (err)
+		goto err_remove_ver1;
+
+	pr_info("KHO versioned test save succeeded\n");
+	return 0;
+
+err_remove_ver1:
+	kho_remove_subtree_version(KHO_TEST_VER_NAME, KHO_TEST_VER_1, folio_address(state->fdt1));
+err_unpreserve_fdt2:
+	kho_unpreserve_folio(state->fdt2);
+err_unpreserve_fdt1:
+	kho_unpreserve_folio(state->fdt1);
+err_free_fdt2:
+	folio_put(state->fdt2);
+	state->fdt2 = NULL;
+err_free_fdt1:
+	folio_put(state->fdt1);
+	state->fdt1 = NULL;
+	return err;
+}
+
+static int kho_test_ver_restore_one(phys_addr_t fdt_phys, int expected_version,
+				    unsigned int expected_magic)
+{
+	void *fdt = phys_to_virt(fdt_phys);
+	const unsigned int *magic;
+	const int *version;
+	int node, len;
+
+	node = fdt_path_offset(fdt, "/");
+	if (node < 0)
+		return -EINVAL;
+
+	if (fdt_node_check_compatible(fdt, node, KHO_TEST_COMPAT))
+		return -EINVAL;
+
+	magic = fdt_getprop(fdt, node, "magic", &len);
+	if (!magic || len != sizeof(*magic) || *magic != expected_magic)
+		return -EINVAL;
+
+	version = fdt_getprop(fdt, node, "version", &len);
+	if (!version || len != sizeof(*version) || *version != expected_version)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int kho_test_ver_restore(void)
+{
+	phys_addr_t fdt_phys1, fdt_phys2;
+	struct folio *fdt1 = NULL, *fdt2 = NULL;
+	int err;
+
+	err = kho_retrieve_subtree_version(KHO_TEST_VER_NAME, KHO_TEST_VER_1, &fdt_phys1);
+	if (err) {
+		if (err != -ENOENT)
+			pr_err("Failed to retrieve version 1: %d\n", err);
+		return err;
+	}
+
+	fdt1 = kho_restore_folio(fdt_phys1);
+	if (!fdt1) {
+		pr_err("Failed to restore FDT 1 folio\n");
+		return -EINVAL;
+	}
+
+	err = kho_retrieve_subtree_version(KHO_TEST_VER_NAME, KHO_TEST_VER_2, &fdt_phys2);
+	if (err) {
+		pr_err("Failed to retrieve version 2: %d\n", err);
+		goto out_put_fdt1;
+	}
+
+	fdt2 = kho_restore_folio(fdt_phys2);
+	if (!fdt2) {
+		pr_err("Failed to restore FDT 2 folio\n");
+		err = -EINVAL;
+		goto out_put_fdt1;
+	}
+
+	err = kho_test_ver_restore_one(fdt_phys1, KHO_TEST_VER_1, KHO_TEST_VER_MAGIC_1);
+	if (err) {
+		pr_err("Version 1 verification failed: %d\n", err);
+		goto out_put_fdt2;
+	}
+
+	err = kho_test_ver_restore_one(fdt_phys2, KHO_TEST_VER_2, KHO_TEST_VER_MAGIC_2);
+	if (err) {
+		pr_err("Version 2 verification failed: %d\n", err);
+		goto out_put_fdt2;
+	}
+
+	pr_info("KHO versioned test restore succeeded\n");
+
+out_put_fdt2:
+	folio_put(fdt2);
+out_put_fdt1:
+	folio_put(fdt1);
+	return err;
+}
+
+static void kho_test_ver_cleanup(void)
+{
+	struct kho_test_versioned_state *state = &kho_test_ver_state;
+
+	if (state->fdt1) {
+		kho_unpreserve_folio(state->fdt1);
+		folio_put(state->fdt1);
+		state->fdt1 = NULL;
+	}
+	if (state->fdt2) {
+		kho_unpreserve_folio(state->fdt2);
+		folio_put(state->fdt2);
+		state->fdt2 = NULL;
+	}
+}
+
+static void kho_test_ver_exit(void)
+{
+	struct kho_test_versioned_state *state = &kho_test_ver_state;
+
+	if (state->fdt1)
+		kho_remove_subtree_version(KHO_TEST_VER_NAME, KHO_TEST_VER_1,
+					   folio_address(state->fdt1));
+	if (state->fdt2)
+		kho_remove_subtree_version(KHO_TEST_VER_NAME, KHO_TEST_VER_2,
+					   folio_address(state->fdt2));
+	kho_test_ver_cleanup();
+}
+
 static int __init kho_test_init(void)
 {
 	phys_addr_t fdt_phys;
-	int err;
+	int err, ver_err;
+	bool restored = false;
 
 	if (!kho_is_enabled())
 		return 0;
 
+	// Try to restore non-versioned
 	err = kho_retrieve_subtree(KHO_TEST_FDT, &fdt_phys);
 	if (!err) {
 		err = kho_test_restore(fdt_phys);
-		if (err)
+		if (err) {
 			pr_err("KHO restore failed\n");
-		else
-			pr_info("KHO restore succeeded\n");
-
+			return err;
+		}
+		pr_info("KHO restore succeeded\n");
+		restored = true;
+	} else if (err != -ENOENT) {
+		pr_warn("failed to retrieve %s FDT: %d\n", KHO_TEST_FDT, err);
 		return err;
 	}
 
-	if (err != -ENOENT) {
-		pr_warn("failed to retrieve %s FDT: %d\n", KHO_TEST_FDT, err);
-		return err;
+	// Try to restore versioned
+	ver_err = kho_test_ver_restore();
+	if (!ver_err) {
+		restored = true;
+	} else if (ver_err != -ENOENT) {
+		pr_warn("KHO versioned restore failed: %d\n", ver_err);
+		return ver_err;
 	}
 
-	return kho_test_save();
-}
-module_init(kho_test_init);
+	if (restored)
+		return 0;
 
-static void kho_test_cleanup(void)
-{
-	/* unpreserve and free the data stored in folios */
-	kho_test_unpreserve_data(&kho_test_state);
-	for (int i = 0; i < kho_test_state.nr_folios; i++)
-		folio_put(kho_test_state.folios[i]);
+	// If we got here, it means both returned -ENOENT (first boot).
+	// So we save both.
 
-	kvfree(kho_test_state.folios);
+	err = kho_test_save();
+	if (err)
+		return err;
 
-	/* Unpreserve and release the FDT folio */
-	kho_unpreserve_folio(kho_test_state.fdt);
-	folio_put(kho_test_state.fdt);
+	ver_err = kho_test_ver_save();
+	if (ver_err) {
+		kho_remove_subtree(folio_address(kho_test_state.fdt));
+		kho_test_cleanup();
+		return ver_err;
+	}
+
+	return 0;
 }
+module_init(kho_test_init);
 
 static void __exit kho_test_exit(void)
 {
 	kho_remove_subtree(folio_address(kho_test_state.fdt));
 	kho_test_cleanup();
+	kho_test_ver_exit();
 }
 module_exit(kho_test_exit);
 
-- 
2.55.0.508.g3f0d502094-goog


