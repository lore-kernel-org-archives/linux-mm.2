Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3AFCCCF2D4
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 02:11:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A61796B00AA; Sun, 18 Oct 2026 22:11:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F0566B00AC; Sun, 18 Oct 2026 22:11:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88AC86B00AB; Sun, 18 Oct 2026 22:11:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 583696B00A7
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 22:11:31 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EA80C405CE
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 02:11:30 +0000 (UTC)
X-FDA: 85337749140.23.81DC5D1
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6A4C620005
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 02:11:29 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=MLUvrMmw;
	spf=pass (imf31.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792375889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PhWkLfOOfteM1FeePp68BcqpwCgdE0YNcf9YXtfJq5A=;
	b=e8J24pH1FjpTJnNS6ykrbIjJSIhFvpC6f89KxCQVlf6bLVkD+1QhaRtZBfuJB1kWz0P2r6
	BQ/ZnuyNpMboNFKC5WEioxsd+QVouV3InyqaqUR21iq1oGrQPQXKB92f/DVzGimrV3beoG
	gb/5W6/hpYkWVE2YRm9ZdQ8v28WzAvk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792375889;
	b=bRUVttJZchMvAvIG1v6z0wozB6aMChBoNBHmsRxozGq63VYjwYaa1KMNNSbYN94sX/loZD
	vVuHU2QJETT/pvIfqlP+ev5M3tTu98pExxPefsVR+dpwwqzc0fL+mRCxxy40voPU1pftTU
	cZeT6XILUj/eAm88tiM4wEWht+j+cHc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=MLUvrMmw;
	spf=pass (imf31.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-7c3b6e8225dso1045169137.2
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 19:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792375888; x=1792980688; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=PhWkLfOOfteM1FeePp68BcqpwCgdE0YNcf9YXtfJq5A=;
        b=MLUvrMmwrMlr65IYMFmXsRq2wgi+TfzL3/Ho2j7avt9mH5s/VatwSUY3y5dYPRavaK
         ip79/URCelEaPFwAUcfOJxQQTTGQnHjC1ELIVE8mNSyUGl6mbHbZFtXdzRIgQYWIHC76
         fjiL7zJfh/opXoPmka+62zt2ZTjYuArHXItCjQ/GXxOtiyVqnC71LeWCd6fG3Odif/+h
         GJs/gOC9nUXALpCHqIq5oFPoqTn/vAcuS9KR5RVG4w9h0UwjSDICnXhFdhezi30HrfNQ
         oa0SADo/HkfzwJ0cIHJOhkrknKO4dExk/a7jrhbh81+naJ1MvCu4Yxwho6LYamVs2089
         W6GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792375888; x=1792980688;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=PhWkLfOOfteM1FeePp68BcqpwCgdE0YNcf9YXtfJq5A=;
        b=B64NHO3eNHXAIn059EwRHGTsQxJyxUE/zRpixzDyUQNzJxsz7KvqeTwSunM2oPRSGq
         2HqG6PMQDLu+ju6ifooCwtdgKJ4ekiSKayAd70IxdPOqhv3Y7toIOu/TTOIAcqIhUBKm
         E1wOt+Ki1SUa3hG3QjCSIFKJAEsSuy3/iiFLsPKE6TcS9lroypsVam5AdaMhVUc2JQHy
         m0lYK9hpf10nuqFCLjt7JdIlUARhLQ0iMMXDDl79LtApQSZcZ5oAAwhhIuo1KKUFmRQp
         AzjWameOv/VbpFgoxCQMWK/AQdNGfTHuO/JM2JCVUt4O6uAGYVLaidrmJfxycoQ1GF2S
         YSmQ==
X-Forwarded-Encrypted: i=1; AKwUvByc24cnXrlRjj+ArGl3BFzAt96Go/S/Mwn2bNL014/NryVaPdIHBxqgVqXf443W5IsZgiDBdfspZw==@kvack.org
X-Gm-Message-State: AFq9FYLSzjMO5PhAS2zpJAQanJaKiPN4wXkxzenH06DMDiswfmCpCNCo
	P78568pcl5mqumvuVbt+ZdsTAsAaPImA876YrSzK7xv1SGWeCPEdRuoBKFJXMvF80RY=
X-Gm-Gg: AYBFou0f4f9H/06PcdGcA1S4jM+pkvHghsx6X5vLZP3wad4G1rAMFgaY4vrDlCGvQr7
	DzPeLAxRKUolp7MiXCBzX+pYiHfSJ85jCjQsHowrQ6KlZOaVo/cRf2+KdAy7nYvTKgmauJDr3CR
	atuT/izSiUo+8FqAIzK8govkyyThZ6fIkBNyyCEQsAn78EYRSaXVvEuRW/0huqw9f26aVDV5KKI
	2mvN46UyVoN6MfIuErLKROmaMqVUehsnzQxO4LJpzbTRokxTZpFe19YtGrEkwbQOxcddgYRJnf7
	nQalxxWtK5f1nU9AvlBBbfscaRstuAPmzV7IIHt6O09PGmmElrU0e8VYYa1KWMu4mu8Ham1PJoa
	XsRT/faBbVriseBWOOkO3K+rX/v/mdq+15nB4Mh4RSb3C23JcbGGwWOPZrd2fPs8zpSXWUVVr45
	Xr1MVtHqeMo36ARJqll/pFOYmRerklEA0UnlOSqPcqvLdKBeznGltlXv/4C59JnA+UOtF4QDH40
	ltpdJmzI7iV+cBxcRx6b/ve65ZKkJEHawX0lgOKO2lmX7JtvOPKKA5pAdksZCj31HMcid6JcXei
	XQG9X8LDiZ3XGeM1Ifq+GDtRdYJ1cw==
X-Received: by 2002:a05:6102:849b:20b0:7cc:3eb0:6ef5 with SMTP id ada2fe7eead31-7cc3eb09b24mr1037299137.11.1792375888447;
        Sun, 18 Oct 2026 19:11:28 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5eabbd9ea2bsm4271383e0c.2.2026.10.18.19.11.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 19:11:28 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	kuba@kernel.org,
	enelsonmoore@gmail.com,
	bp@alien8.de,
	shuah@kernel.org,
	david@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	vbabka@kernel.org,
	dapeng1.mi@linux.intel.com,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	surenb@google.com,
	pasha.tatashin@soleen.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	elver@google.com,
	graf@amazon.com,
	lirongqing@baidu.com,
	liam@infradead.org,
	jlayton@kernel.org
Subject: [PATCH v1 7/8] kho: test: support read-only KHO mode in test_kho
Date: Sun, 18 Oct 2026 22:11:10 -0400
Message-ID: <20261019021111.990394-8-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <20261019021111.990394-1-pasha.tatashin@soleen.com>
References: <20261019021111.990394-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6A4C620005
X-Rspamd-Server: rspam08
X-Stat-Signature: e3bz3onjjtxwdhgoen7uaqx1jgc1b7p1
X-HE-Tag: 1792375889-93094
X-HE-Meta: U2FsdGVkX19tty/lk1HDPcF0yJJbsJcfAIQSccXUtIq+uxSN2kxW4BUsPHU7RMCp1DSjwl3esRbL0uC/lEPqnXVUXe4j8JFru0v8cBZ5loFPGRjavSbbqrtx+b3yRIyoraYecmgcEK/gBnPOugHAX2m6iF1DmAHoxZe4NdV4xZTr7esry5C+bYucW9wNomeXEoD50QrUMoTLaETNzBMaTgBiAfcJzjyK173+SVxE29wWuwROozTnYPAfcrK2AyqfxXGwxEenVk4rrw9idGEXfQNYHFXG8NMKeZGHZGXJddmwv3WPBuoQHMfiNH0PQ3/kytPzqihT5KJN3Y3wBpE9jTk0XHKiYZwQFhOBYsUv3c96xPiR2rcSasRDyjkNn+OevJTPxyt6piFgBn9H1707wh/SCzuWX1KozyVCw0iLzb6FesJ+/J37KmV8ykwa1vw3inPNcTnuWtVYyuwLvPmRlc+PC03ZNYG6zWrdqwkQrtoijsk47tFXBhkrnWkwDWx0jcwiuZ6MuCczg2Bj+NJdKQJ/eA992g+TghMJlDO3nKmu/25U8tLMfWWTjkiEZSSlU/5crvfSZAa6Nr1Vmh1gyI9eIrjNGREIx/NMedxt+df7sP4fKcBwjKTqf3QaXUJxLAJ15R4QNbiMYb5PqealBYEUt/JnOLbtafscO2tf+Fg/MZiXTGoMyfr+j22GrmdlttCQF/Ermjb5puwy+UPlwioH/6qJOP75jO/eQWe+6fh7cHwhPcCxfh7kA18zvssynzcqpCFswcb8V5tKHvmj6nJlale3RI9GcRC1bM+DVr3bdVl2tK0Euck1jkg8TPiEspCEGMvryF463MD4k7FyrpT/tcH/W/OmAOgG/CnT3jlmj5UaMN8mEvlP61ZbOmod84kqJ3idw3U8IYfPJnJ/th2TnzRDLSZ39dqpVtLomvOnsFi/Ep/hriFuR/JjLFbr3+jQOJA9IgOwAL5h0t1
 B+hTiFmY
 xqmtt01pVZb72zC9IAAqmSfn54exE8LVbkyMgNwdI0fXBjBH/4LErH6RUykXYelb1QnvVLhajwTTOj3uHUQxKmwarPCzgEtKxFnzgSkj5Zhw6UsrlFS6eshVFzrjzYfXKXq8sEI1/h+xzX6ZmLsCTYgZ4G5rWADmNJwKuMoqQtTdGRG3dPAugN3aj3VHEmMczJ6+eaE52EVNvgTrxHXngXmZZJkgDfwUaF2Ve33GnVw5C/FkJ6R+7zJErya/GcSKnLTqSdLJ68PAAMASfXSp+H/vJExvgJREczk7+K420z/dQJmIY9kTo1wYsjQ8P5dIqe/O+Fv6G/O7SY0YkQwvP1n7Vl6F4CxRg1Dx0AHiarfjsd4PYTQlKHOoHnJnI/UIrYhvA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allow CONFIG_TEST_KEXEC_HANDOVER to be enabled with
CONFIG_KEXEC_HANDOVER_READONLY and update test_kho to verify preserved
state when booted in read-only KHO mode.

In read-only mode, test_kho retrieves the test FDT subtree, maps the FDT
folio via kho_ro_map_folio(..., PAGE_KERNEL_RO), restores the preserved
vmalloc folio descriptor array via kho_restore_vmalloc(), verifies each
folio's preserved order in the KHO radix tree via
kho_ro_lookup_folio_order(), maps each folio via kho_ro_map_folio() (and
unmaps via kho_ro_unmap()), and verifies the checksum over all preserved
pages.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 lib/Kconfig.debug |  2 +-
 lib/test_kho.c    | 68 ++++++++++++++++++++++++++++++++++-------------
 2 files changed, 51 insertions(+), 19 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 134b15a44625..74223ef8bd1c 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -3381,7 +3381,7 @@ config TEST_OBJPOOL
 config TEST_KEXEC_HANDOVER
 	bool "Test for Kexec HandOver"
 	default n
-	depends on KEXEC_HANDOVER
+	depends on KEXEC_HANDOVER || KEXEC_HANDOVER_READONLY
 	help
 	  This option enables test for Kexec HandOver (KHO).
 	  The test consists of two parts: saving kernel data before kexec and
diff --git a/lib/test_kho.c b/lib/test_kho.c
index aa6a0956bb8b..1e0f257a5854 100644
--- a/lib/test_kho.c
+++ b/lib/test_kho.c
@@ -239,7 +239,7 @@ static int kho_test_restore_data(const void *fdt, int node)
 	phys_addr_t *folios_info;
 	const __wsum *old_csum;
 	__wsum csum = 0;
-	int len;
+	int len, i;
 
 	node = fdt_path_offset(fdt, "/data");
 
@@ -259,11 +259,28 @@ static int kho_test_restore_data(const void *fdt, int node)
 	if (!folios_info)
 		return -EINVAL;
 
-	for (int i = 0; i < *nr_folios; i++) {
+	for (i = 0; i < *nr_folios; i++) {
 		unsigned int order = folios_info[i] & ~PAGE_MASK;
 		phys_addr_t phys = folios_info[i] & PAGE_MASK;
-		unsigned int size = PAGE_SIZE << order;
 		struct folio *folio;
+		size_t size;
+
+		if (order > MAX_PAGE_ORDER)
+			break;
+		size = PAGE_SIZE << order;
+
+		if (kho_is_ro()) {
+			void *addr;
+
+			if (kho_ro_lookup_folio_order(phys) != order)
+				break;
+			addr = kho_ro_map_folio(phys, PAGE_KERNEL_RO);
+			if (!addr)
+				break;
+			csum = csum_partial(addr, size, csum);
+			kho_ro_unmap(addr);
+			continue;
+		}
 
 		folio = kho_restore_folio(phys);
 		if (!folio)
@@ -278,50 +295,65 @@ static int kho_test_restore_data(const void *fdt, int node)
 
 	vfree(folios_info);
 
-	if (csum != *old_csum)
+	if (i != *nr_folios || csum != *old_csum)
 		return -EINVAL;
 
 	return 0;
 }
 
-static int kho_test_restore(phys_addr_t fdt_phys)
+static int kho_test_restore(phys_addr_t fdt_phys, size_t fdt_size)
 {
-	void *fdt = phys_to_virt(fdt_phys);
 	const unsigned int *magic;
-	int node, len, err;
+	int node, len, err = -EINVAL;
+	void *fdt;
+
+	if (!fdt_size)
+		return -EINVAL;
+
+	if (kho_is_ro()) {
+		if (kho_ro_lookup_folio_order(fdt_phys) < get_order(fdt_size))
+			return -EINVAL;
+		fdt = kho_ro_map_folio(fdt_phys, PAGE_KERNEL_RO);
+		if (!fdt)
+			return -EINVAL;
+	} else {
+		fdt = phys_to_virt(fdt_phys);
+	}
 
 	node = fdt_path_offset(fdt, "/");
 	if (node < 0)
-		return -EINVAL;
+		goto out_unmap;
 
 	if (fdt_node_check_compatible(fdt, node, KHO_TEST_COMPAT))
-		return -EINVAL;
+		goto out_unmap;
 
 	magic = fdt_getprop(fdt, node, "magic", &len);
 	if (!magic || len != sizeof(*magic))
-		return -EINVAL;
+		goto out_unmap;
 
 	if (*magic != KHO_TEST_MAGIC)
-		return -EINVAL;
+		goto out_unmap;
 
 	err = kho_test_restore_data(fdt, node);
-	if (err)
-		return err;
 
-	return 0;
+out_unmap:
+	if (kho_is_ro())
+		kho_ro_unmap(fdt);
+	return err;
 }
 
 static int __init kho_test_init(void)
 {
 	phys_addr_t fdt_phys;
+	size_t fdt_size;
 	int err;
 
-	if (!kho_is_enabled())
+	if (!kho_is_enabled() && !kho_is_ro())
 		return 0;
 
-	err = kho_retrieve_subtree(KHO_TEST_FDT, &fdt_phys, NULL);
+	err = kho_retrieve_subtree(KHO_TEST_FDT, &fdt_phys, &fdt_size);
 	if (!err) {
-		err = kho_test_restore(fdt_phys);
+		err = kho_test_restore(fdt_phys, fdt_size);
 		if (err)
 			pr_err("KHO restore failed\n");
 		else
@@ -330,7 +362,7 @@ static int __init kho_test_init(void)
 		return err;
 	}
 
-	if (err != -ENOENT) {
+	if (err != -ENOENT || kho_is_ro()) {
 		pr_warn("failed to retrieve %s FDT: %d\n", KHO_TEST_FDT, err);
 		return err;
 	}
-- 
2.56.0.176.g3575e65682-goog


