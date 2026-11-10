Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 429FF6070315
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=leVbjtVQ
Received: by kanga.kvack.org (Postfix)
	id 12BD36B05BC; Tue, 10 Nov 2026 00:02:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 067EE6B05BD; Tue, 10 Nov 2026 00:02:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E49F66B05BE; Tue, 10 Nov 2026 00:02:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AE0816B05BC
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:02:15 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 30E40A84D8
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:02:15 +0000 (UTC)
X-FDA: 85418013030.26.F1F03C7
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6D273120008
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:02:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=leVbjtVQ;
	spf=pass (imf29.hostedemail.com: domain of 3U6XyagkKCMY5m36z4mt6s00sxq.o0yxuz69-yyw7mow.03s@flex--tarunsahu.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3U6XyagkKCMY5m36z4mt6s00sxq.o0yxuz69-yyw7mow.03s@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794286933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7IgLF3AO1jBgBbxTE6gThjrdHr/S4nDjr0YcBANCh54=;
	b=XzIxfeM7Zw/IL2L2GCAICNk8NSor1Qm3AvEnjJBVcoXLXp6i7pA0p15MTTXhh3LtYvt9Zo
	7IDJt3uIz/xVZ/a/Sd+poMaqkEQugC/m2SjLfADdnUMjKpLNLegMPx1qG+C56xI1UnqPnS
	pS+sQJ0BRZOrNd2q+mTolRvler0ze48=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794286933;
	b=yQS/9TjR3CDT9/SdxzC/xWQq6B6OsUB4ZxNkoEgCYh9g81JiI/Ck2MlTYcDxzf0q2HqYLd
	eh5JVXXmhrQboQKigxenFIWx8Jy/NnDoyiU9hXQvW6CE6cHIEH5fBdO2O8M25FKCVZIr+H
	vWJXfi30Yh/IEA7M9rZgrU8NcFBpaYE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=leVbjtVQ;
	spf=pass (imf29.hostedemail.com: domain of 3U6XyagkKCMY5m36z4mt6s00sxq.o0yxuz69-yyw7mow.03s@flex--tarunsahu.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3U6XyagkKCMY5m36z4mt6s00sxq.o0yxuz69-yyw7mow.03s@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c4d288b67ccso132810966b.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 21:02:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794286932; x=1794891732; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7IgLF3AO1jBgBbxTE6gThjrdHr/S4nDjr0YcBANCh54=;
        b=leVbjtVQDL5UVm5Wtp7uqQhZizFh9UXzYvJRIK+r1SfumR17045P3+rAyfoRAdOiPs
         AYeXQ1uTMwAzR19fTSZg/v6uDsAg+8iFLDkxRA+pO5c1gagzwiJd6wPp7+KtShlaHUII
         9emnD8KYBa0hKP/Rr3B4BF7B5Ac0k7c7PjitxRVpVXGERuk3PmFFMOGFFdsTduJ+Bvm+
         RqqDwOXf4524PTJ4bBOIyUjmeGi5X6HKQ3A9BaywVYERWTIgTSyB1mmdNt/bdtOs2d/y
         gHd5KVjZWsUfPdLmu2BJ3nsD38HfHIbYJNc+m7MLBxlGJrs6JcmYvPd+mCpKXXm/9xCZ
         JSgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794286932; x=1794891732;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7IgLF3AO1jBgBbxTE6gThjrdHr/S4nDjr0YcBANCh54=;
        b=JsCOUz6mvDyiFGCd08og28UUm+6WZ50RrmvgPG7v48xmaiLP0xLr8NHLB6ugQpD2oF
         IwvimNzfBpnXnuJn3k3E7fF3Ew6Ld5Gc1okSn6R+o6SA1S9cK855BBKXTz8cw6Kgq+Wu
         882CJne9FY5dsdvkkMZP9LGYnqRn8YmDFS1oo8Q0PVDgpeS6WhJDGU0w4hrobBNbffEn
         W4TUDcgxf+OBPhGwvL5cXmIu0BWqnhM8mwwzlV9FaF1aV4x3dk3PUgnm3c3B/ZaB4ydv
         4NUN5e5ReVX8EBtFgkINa/MURFiilpGeUSQL/j8A+AMRJE+SDjKG7vSQSMyUN8sLN2qS
         RGhQ==
X-Forwarded-Encrypted: i=1; AL+hErEjLRv58HA83+kyFXIA+dEzafR7ASQRBks4XlaO/85Zszy2gg8nj54tdW9bNddElCdA1tf9DyPRHA==@kvack.org
X-Gm-Message-State: APuU4Z+wyWMHehxukvfYJuQ0TeZaZBE51IeNB56fxBKEcaModmakPsZ8
	VE0k+Ua748Tv2rkHQuV/bygfrkrm55ntygZdiY0VnNxExYd4yKen7g7PtW1lA7ivwcVBCvi2yVU
	P0/tBbI5051COgQKTpQ==
X-Received: from ejbwr20.prod.google.com ([2002:a17:907:7014:b0:c3f:b33c:8124])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:3f0d:b0:c2e:4a61:d436 with SMTP id a640c23a62f3a-c50495d6ee1mr114117566b.36.1794286931810;
 Mon, 09 Nov 2026 21:02:11 -0800 (PST)
Date: Tue, 10 Nov 2026 05:01:49 +0000
In-Reply-To: <20261110050202.529473-1-tarunsahu@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261110050202.529473-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
Message-ID: <20261110050202.529473-7-tarunsahu@google.com>
Subject: [PATCH v4 06/19] kho: kexec_metadata: Add the feature header
From: Tarun Sahu <tarunsahu@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, robin.murphy@arm.com, 
	maz@kernel.org, will@kernel.org, David Matlack <dmatlack@google.com>, 
	Alexander Graf <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com, loganodell@google.com, 
	arnd@arndb.de, dwmw2@infradead.org, baolu.lu@linux.intel.com, 
	Bjorn Helgaas <bhelgaas@google.com>, oupton@kernel.org, alex@shazbot.org, 
	gle.com@google.com, pbonzini@redhat.com, 
	Andrew Morton <akpm@linux-foundation.org>, kevin.tian@intel.com, joro@8bytes.org
Cc: kvmarm@lists.linux.dev, linux-pci@vger.kernel.org, 
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	skhawaja@google.com, sagis@google.com, linux-arch@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6D273120008
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Stat-Signature: 6byx41iw5wyx1ycmb5ud97at9n1esjte
X-Rspam-User: 
X-HE-Tag: 1794286933-856879
X-HE-Meta: U2FsdGVkX19PM+Xn1NdSlFd8P5WOmZFgbxCpuPPXKsUx6KLcwdqYaGTfdo+oxzuKoXIzAyOlP65SRqsO3WEzaaSHFpvj0UQPpmO7Scia7WGa2i+eiAVtzBvoPB5bFl2Z3ALtNRbcN/ERXpwY0hdXhVPHXKbjLNXkg40lAIySB6z+FPFWq3tA2w+VHthqEM/HXu/2i7kRFJtIBe174IXMNCrxnGV5s9w2lTMRSf2fFZDNyGhacRdk/AJby0fY94rYuBH2Lordl8kcXdMTwh1siRuaH1mkpZ0apOznsXOxc5NQk9DD0BWQUocfFOntWggIq54u3+dF6HxT2Ndf7roiTnKQZQqg1evrXmI7Eo4I2iANu+BRFcwU+emUem0eyn0BQY/QchXwbAUBM84JYv6k1ulV/KRMwYBP6z80MQkWwwLTHfgGTHMHmfFr6q/tctAmW9RMPmG5IINPMlTuEEm3sKnh0PtlFKoL85tCXEDT2BE5rmXdteMU65ugK5dRMAJcpqCtXz8c+Z7YJpzP8oKmuhmUApY9tWjJ+5BZNmWyUzApG2xLRPkCFHZrNE8UdVCiQR/BKD8nzsB6kYZMt3gJqsJlEEjDXHA6FKAJsPE2+n6EQxYRyUqKZ+GOEgaS/Mo0kKBHDIjOLC2WPpUt9VdZtpDX30orbxta7oTbQkqH3L/QxNAUe4ykVQjJCeqmXo20RtCcyKy5IgoyyCF6chF8DLujBb5HjtmmN8FQqDz67topm2tB8SwYwEROy8l1QqqGbavw/xeMnmX+plCVSHJezTx408KxTqeYohU6KSfUcVur+lFO0mhBJrmRIeBSL0fmu7Q0mJ6waweOMbqbJm5Brab79Iqekw7pjZFLGehRlidiHn8Owqyo+OJRme8XTAund6dN76XWGs69zsKTG0rlIPovo4lU7SpkaaRP/lzNzlkGDanb079Fruc8Tsb8cE9KIe9VjrENfxsxpm9AoaM
 QldbwVUq
 VghaFUJ0UZpN2xnyTVJCx0e9nuZaELdIg1xhI9OGl3EzJeKcDkV7AB+llo0+EClQXIdzgcotc3KHYxo6bLUxxcQTOdkzkjCLTtyMqn/H+5bEgFD68NaVQf2EUqrswg3IOCW2pKJ1oVzsDnNWSVd0MKYBjWE4kxLBPpnImKR99Gq2/CL4vtTy+zWzDVehnVH+zpMdlFeR01w0A0kQATnfz5/dsRY2C4ANZ35Xgrv5rWlJvq5fwe5rGWYJJ9Eiaxr8MgV/vIv+TYJszYzVkD8QPfE/LzknuVbX084adfvTZckaYV9sRYjf2OI3zar58B4uWOlanEss+ddwTFpjw4wfmdl3WW7W7Qndq69HX1L5mUJrEzhPsRnQbYgxuvPdaOYzk6JAMRixbh8hPMW9KwVYoNZqt2jYH2g2a/HORMmdpGYIaqeE4Cq7Gb0QFTlPPFT+M98nkMeKTD7uxTTk4bSZgxO/7MMDHA8YbjLRHrB5WIENGhB5c7wrVKAv/mjZrsK21ciQ2Q+w4Un8uuLm0rGGGWBhugI/UZPXyYdlhmzs9C0Bmk7giAeFV0AIAJS0PBiDTv7n8x7Kif041K0dOV+uHDHVADZwbPnWrGvy4DbfGXgPQ/4MJSJrw2eCpCtC0AfHK5OqT1JxNtrDmHbS3JTC+00vucA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The kexec metadata subtree currently uses a monolithic u32 version field
to identify the metadata structure layout. Any change to the structure,
even an optional additive field, requires incrementing the version and
breaks compatibility between adjacent kernels.

Replace the u32 version field in struct kho_kexec_metadata with
struct kho_ser_hdr using DECLARE_KHO_SER. Later fields can be appended
under new feature indices without breaking compatibility across kexec.
Also make the 3-byte padding hole between previous_release and kexec_count
explicit as reserved[3].

During deserialization, validate the blob size against the header size
and reject unknown required features. A legacy v1 metadata blob is
ignored with a warning.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 include/linux/kho/abi/kexec_metadata.h | 17 +++++++-----
 kernel/liveupdate/kexec_handover.c     | 38 ++++++++++++++------------
 2 files changed, 31 insertions(+), 24 deletions(-)

diff --git a/include/linux/kho/abi/kexec_metadata.h b/include/linux/kho/abi/kexec_metadata.h
index e9e3f7e38a7c..316b3e5ad01b 100644
--- a/include/linux/kho/abi/kexec_metadata.h
+++ b/include/linux/kho/abi/kexec_metadata.h
@@ -18,28 +18,31 @@
 #ifndef _LINUX_KHO_ABI_KEXEC_METADATA_H
 #define _LINUX_KHO_ABI_KEXEC_METADATA_H
 
+#include <linux/build_bug.h>
+#include <linux/kho/abi/feature.h>
 #include <linux/types.h>
 #include <linux/utsname.h>
 
-#define KHO_KEXEC_METADATA_VERSION 1
-
 /**
  * struct kho_kexec_metadata - Kexec metadata passed between kernels
- * @version: ABI version of this struct (must be first field)
  * @previous_release: Kernel version string that initiated the kexec
+ * @reserved: Reserved for structure alignment; must be zero
  * @kexec_count: Number of kexec boots since last cold boot
  *
- * This structure is preserved across kexec and allows the new kernel to
+ * This structure is preserved across kexec and allows the target kernel to
  * identify which kernel it was booted from and how many kexec reboots
- * have occurred.
+ * have occurred. Preceded by &struct kho_ser_hdr.
  *
  * __NEW_UTS_LEN is part of uABI, so it safe to use it in here.
  */
 struct kho_kexec_metadata {
-	u32 version;
 	char previous_release[__NEW_UTS_LEN + 1];
+	u8 reserved[3];
 	u32 kexec_count;
-} __packed;
+} __aligned(8);
+
+/* Register kho_kexec_metadata with KHO serialization accessors */
+DECLARE_KHO_SER(kho_kexec_metadata, 72, 0, 0);
 
 #define KHO_METADATA_NODE_NAME "kexec-metadata"
 
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 4b1d173d48ff..641a3b4c88fb 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1762,6 +1762,7 @@ static __init int kho_out_fdt_setup(void)
 
 static void __init kho_in_kexec_metadata(void)
 {
+	DECLARE_KHO_SER_HDR(kho_kexec_metadata, *fhdr);
 	struct kho_kexec_metadata *metadata;
 	phys_addr_t metadata_phys;
 	size_t blob_size;
@@ -1773,27 +1774,28 @@ static void __init kho_in_kexec_metadata(void)
 		/* This is fine, previous kernel didn't export metadata */
 		return;
 
-	/* Check that, at least, "version" is present */
-	if (blob_size < sizeof(u32)) {
+	if (blob_size < sizeof(*fhdr)) {
 		pr_warn("kexec-metadata blob too small (%zu bytes)\n",
 			blob_size);
 		return;
 	}
 
-	metadata = phys_to_virt(metadata_phys);
-
-	if (metadata->version != KHO_KEXEC_METADATA_VERSION) {
-		pr_warn("kexec-metadata version %u not supported (expected %u)\n",
-			metadata->version, KHO_KEXEC_METADATA_VERSION);
+	fhdr = phys_to_virt(metadata_phys);
+	if (fhdr->size != blob_size) {
+		pr_warn("kexec-metadata size invalid (%u != %zu), ignoring metadata\n",
+			fhdr->size, blob_size);
 		return;
 	}
 
-	if (blob_size < sizeof(*metadata)) {
-		pr_warn("kexec-metadata blob too small for v%u (%zu < %zu)\n",
-			metadata->version, blob_size, sizeof(*metadata));
+	err = kho_ser_validate(fhdr, kho_kexec_metadata);
+	if (err) {
+		pr_warn("kexec-metadata feature validation failed: %pe\n",
+			ERR_PTR(err));
 		return;
 	}
 
+	metadata = kho_ser_payload(fhdr, kho_kexec_metadata);
+
 	/*
 	 * Copy data to the kernel structure that will persist during
 	 * kernel lifetime.
@@ -1813,23 +1815,25 @@ static void __init kho_in_kexec_metadata(void)
  */
 static __init int kho_out_kexec_metadata(void)
 {
+	DECLARE_KHO_SER_HDR(kho_kexec_metadata, *fhdr);
 	struct kho_kexec_metadata *metadata;
 	int err;
 
-	metadata = kho_alloc_preserve(sizeof(*metadata));
-	if (IS_ERR(metadata))
-		return PTR_ERR(metadata);
+	fhdr = kho_alloc_preserve(kho_ser_size(kho_kexec_metadata));
+	if (IS_ERR(fhdr))
+		return PTR_ERR(fhdr);
+	kho_ser_init(fhdr, kho_kexec_metadata);
 
-	metadata->version = KHO_KEXEC_METADATA_VERSION;
+	metadata = kho_ser_payload(fhdr, kho_kexec_metadata);
 	strscpy(metadata->previous_release, init_uts_ns.name.release,
 		sizeof(metadata->previous_release));
+	memset(metadata->reserved, 0, sizeof(metadata->reserved));
 	/* kho_in.kexec_count is set to 0 on cold boot */
 	metadata->kexec_count = kho_in.kexec_count + 1;
 
-	err = kho_add_subtree(KHO_METADATA_NODE_NAME, metadata,
-			      sizeof(*metadata));
+	err = kho_add_subtree(KHO_METADATA_NODE_NAME, fhdr, fhdr->size);
 	if (err)
-		kho_unpreserve_free(metadata);
+		kho_unpreserve_free(fhdr);
 
 	return err;
 }
-- 
2.56.0.506.g506a7eabc5-goog


