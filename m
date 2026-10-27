Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1A01606A328
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 02:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=fYek7+Dp
Received: by kanga.kvack.org (Postfix)
	id E25896B05B8; Mon, 26 Oct 2026 22:56:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFCE96B05B9; Mon, 26 Oct 2026 22:56:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEB446B05BA; Mon, 26 Oct 2026 22:56:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9D7BD6B05B8
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:56:48 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 18E4BC0840
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:56:48 +0000 (UTC)
X-FDA: 85366893696.10.8BD1537
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1D74820008
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:56:46 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fYek7+Dp;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of 37BLgag0KCO8bVmZecflXYcZeXffXcV.TfdcZelo-ddbmRTb.fiX@flex--kevinloughlin.bounces.google.com designates 209.85.210.71 as permitted sender) smtp.mailfrom=37BLgag0KCO8bVmZecflXYcZeXffXcV.TfdcZelo-ddbmRTb.fiX@flex--kevinloughlin.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793069806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nTmoe18Cl/4sVBSCzKT2MKtNZE6Kiks6IBw/3aH90Qo=;
	b=wfwVYEJJUIUVrBVd6r9c9ULJssX31tYCGnjwSOJYJoMV6B1CQODtTPRjlSsBc/seBaIkFX
	6pEfSYY+4Noj6JQq2V6uXXAiqreLSamwxc0kRi7epO/hn55vplpTwwoHhZ2gvGsXtEb5qi
	i6HVZwypMKZJ17cUBNOaWHO9MsT72k4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fYek7+Dp;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of 37BLgag0KCO8bVmZecflXYcZeXffXcV.TfdcZelo-ddbmRTb.fiX@flex--kevinloughlin.bounces.google.com designates 209.85.210.71 as permitted sender) smtp.mailfrom=37BLgag0KCO8bVmZecflXYcZeXffXcV.TfdcZelo-ddbmRTb.fiX@flex--kevinloughlin.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793069806;
	b=XmnTW4Er61eo2hRHyBjncNHAcpldXsTDF0TWWy9YLB1zSuPBwUXzHaJqTs6tj00nT8+fn8
	FklfI7NyF0H8WNWLCBPerbO6mO3pNSw76e7uvGR3MrtZ1JvshHsiNdpDd4i2MXxQa+yKOw
	cXvIKGUvsunogAUNNEeHK/uTtY0wzPU=
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-84586110393so4199907a34.1
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793069805; x=1793674605; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nTmoe18Cl/4sVBSCzKT2MKtNZE6Kiks6IBw/3aH90Qo=;
        b=fYek7+Dp/O9VlcREtgTdoM0L5VwQcy6zy/RbvGURDEsLTUskaHBXs1JwaImRMwrt3b
         xHZSwZDMvqqIMQu575eyJQ785QpCklx0xbwiiZpLD2n3ljPNEW+zo1/SCml5/ZYeN1u9
         eoj5HvDHgxwNakCxLql8f5Q/bui8uEu6pfgA1WMseRpvDUhxCAXKJ46/ukpcJ5tFUevK
         zQLIcgyz/W4+EA2jCeyqEuF9SkySL+j7zDIt7SrbaqS5GeMHUnuG4xa4+mgFnSUMnTT8
         8+oChj3Y+9/a7Q3fKXZly4fHrZAFPbmqgX/x1MFGCBFLMb9ZUxey7T6OXpqUeBlzeuBC
         h6ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793069805; x=1793674605;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nTmoe18Cl/4sVBSCzKT2MKtNZE6Kiks6IBw/3aH90Qo=;
        b=aqBHi+5T+56dqvV+rqtLpTg79X4II0tlddhACXU+8dp/1VHa9lF6PIm6cR9upRtBpy
         /tE5c3yo992VRFyF4HSqaoJNCiODjc0vfB+9DCS30bHX3J0mSOt7RZOJLioVafh4kIU+
         dXFcQZMvcWuZodvwROOcOrbpxMitOTiMcWgAtAn52edCo1yMDtUxm+rxt8MfSWNDCeKb
         5fZXrBtZgps3Ts3UJmbWaEBOr1vEg6aeyY7dR01c9fHiCeSvvtnULj0PK7a8JpgMnc8+
         1EZTyhbXjWbpborbCC0ku6fwa5Tgc0c67hFSMp6PjeUy90YQkrRJBIPUCPruspE+Dezv
         U4jg==
X-Forwarded-Encrypted: i=1; AKwUvBymyTnvdf8wxGUkclC1tNt5u3gwUf/THNvHtG3L4JzgGyTXjZUPGgj9f8uPaSuugzFiuBdbk+WLlA==@kvack.org
X-Gm-Message-State: AFq9FYIdqykKaIFl2ysmZOVTyLXibPPcDY/a9jsYG8gXWOHLgCR4TdyY
	tpGgdcfW5tlHLVwLEQFZwxiIbZUZoCPtWDK+C8sWuw+1MuXOMsqUymJtF6ETGxu80tnGXV3McXG
	Y8oxDp8ItYteisVl2Kpnn5mmPMc/zmjX6fg==
X-Received: from ila5-n1.prod.google.com ([2002:a05:6e02:5205:10b0:50d:41bd:b30])
 (user=kevinloughlin job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:c0cc:10b0:6dc:6e90:f650 with SMTP id 006d021491bc7-70ba0e0f19cmr3730965eaf.15.1793069804982;
 Mon, 26 Oct 2026 19:56:44 -0700 (PDT)
Date: Tue, 27 Oct 2026 02:56:06 +0000
In-Reply-To: <20261027025616.1632690-1-kevinloughlin@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261027025616.1632690-1-kevinloughlin@google.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261027025616.1632690-4-kevinloughlin@google.com>
Subject: [PATCH 03/13] x86/coco/sev: add snp_unaccept_memory()
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1D74820008
X-Stat-Signature: qn5scht7973r1rhk9nimtzxmr9xuyeu5
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793069806-384762
X-HE-Meta: U2FsdGVkX1/i0+OSjV2w14Md8meTqBsQswNbCyxj2hnqZWhKF9wgHCsALKXJoFNxMPNgXzqDUtRNKxIG2e+69F7gg4cN5vEW+2LNRg4MdsDrtV+AIN2If+h3Nc3sqtCg+bRjM48T0oPVCbAc6Lt/jUyuh2hKkaWzzwuBvhtWCFyin1n+6RhSNZcwyBcZueGsix81UfJWK8omTAI16EYobO45M9yW/mufkOh1Vn8ee4/nz4PiZN6g+aVHzKN9ucdEXBdsMLf4Izih4MYdF63eeZVieTaSmu6qL+7rgL5Mzczx9gdZtBfR4ApCSdfKzf+eU0JA1YfQqo042JOsOmiSragGja7mVwsTrMYDrmErkgIqFiVhH+FHwq9Q50QZ94FUI0c6lxpDLLYaHkP7fg8wLi5drJHpPxe1KBYmOE82TzEju60y83wHyguiJvv1vzCAQo/mlYMyrWDaLbdsGbwMdq7vCClO/MzMw4RNq0RtQXlrJE32Zic14D7iWPo6wHZYpnKxw0oJWcA0owxVOpYsLlprJ1x6Cm3T958IjX7lNwhKQ2AC7DwXuzvwOv3BZlhKhzsjCNdyVl3uFbJz+eXu2SkbrVu+1ud/G0h6xzkHRbes9gPVSyq2HmF64D+emZ+vXZqfte+dSrTbjWuVQyEBBHg13Udr/G6XM71Vy0cCFtzuWA46137YuwvbkLuKrwQlFh/74JbA6d+SnwCa4m5QvXSsGn0BO7l7inKjK9NJIC0uGm6tQsjCdlt08bZqI7aeWTCMnHJQ4a8nQSn5uESzU9S6M5g45pimP0HGr3R1VA47s2s/3NxD2jyTlvfuDpCIJTn0WzNYRA7KIJKvMfLjA8BFMi05HeBS4McavMD2ESHHfVggWeU9Oe2FbQoLtx+n4H6qaR5oIoddsXqmd/uEe5xJUeAgjdcY5hnkiyd3CQ8Zq+wnLK5c7gr4ys5Wc5lq2q47b0F1MD/HW/r3+j5
 RPbVL/Lw
 tNxmWAkZUX/YIvyX3EoRTvEbIFOm8A+jBBSgKi57dI7x+XWqmbwgmjT5qQg47oexCrGkSKPv8zw1YKKhSjWhpq3AmAcX3l7U9KlRp+HvG8qZZzHN83kAyflGxuDrVTEgN3TNuQHSz80nypb8LFPBpCGLy45ezxM/pmC8BDX9ipepwrEvLyTqUy/bLQa64DyepbOLpVhSGrbuKUe2hnX8Qdo1ng4ypnILdWULSL5fM3drtr6wmNchU7O/PBijpcn8bRxD9gU3AzhxhB0OB81hFX7SLU+ugz6v2my77s2wZDJEpZyfSoe0zBiCjssTUgFs2IJv25FUQudGK3OsL+94qzwgwd52AANfP2rq6sjXMPdyQAxM3K9pypnWhqqza6BHZeu1NVLajT0eqPYwgi2pkJ76JAxLRbCV2jjWolhYP3kfgZTOUCcjmsB4FGRgXLqKbSTgUmy6I2xHoCnyw1pC6PMnQMZAAiJoDG4uc5hkp1Y/Bd7yQnGH9M29aer0azxER9kc2yAOWbkbgNKfNtLwfIiB6yw3xMaZRLldHj07z3FKULA9GDsI1qTGg0fq34UxLOIGjbCUBIG/IeYKMD5RipRf+ksh8fIE+em3K47BgiNslg1BA4x6JPkIsSR+0dgzS94LSg+3Uul0IHxl0HHdBVtYlbIIZTvafv6Jp5EADkB8QCHKXSabx/lRwZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add snp_unaccept_memory() and wire it up to arch_unaccept_memory() and
arch_has_unaccept_memory() on AMD SEV-SNP guests.

When memory ranges are dynamically unaccepted (such as during
virtio-balloon inflation or free page reporting), snp_unaccept_memory()
invokes set_pages_state(..., SNP_PAGE_STATE_SHARED). This call rescinds
guest RMP validation via PVALIDATE(..., validate=false), handling 2MB
PMD pages with automatic fallback to 4KB pages on RMP size mismatch.
snp_unaccept_memory() -> set_pages_state() also issues a GHCB Page State
Change request so the hypervisor transitions the range from private to
shared symmetrically with snp_accept_memory().

Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
---
 arch/x86/coco/sev/core.c                 | 13 +++++++++++++
 arch/x86/include/asm/sev.h               |  2 ++
 arch/x86/include/asm/unaccepted_memory.h | 14 ++++++++++++++
 3 files changed, 29 insertions(+)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index eb2e853e950a..3f8809bae14a 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -432,6 +432,19 @@ void snp_accept_memory(phys_addr_t start, phys_addr_t end)
 	set_pages_state(vaddr, npages, SNP_PAGE_STATE_PRIVATE);
 }
 
+void snp_unaccept_memory(phys_addr_t start, phys_addr_t end)
+{
+	unsigned long vaddr, npages;
+
+	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
+		return;
+
+	vaddr = (unsigned long)__va(start);
+	npages = (end - start) >> PAGE_SHIFT;
+
+	set_pages_state(vaddr, npages, SNP_PAGE_STATE_SHARED);
+}
+
 static int vmgexit_ap_control(u64 event, struct sev_es_save_area *vmsa, u32 apic_id)
 {
 	bool create = event != SVM_VMGEXIT_AP_DESTROY;
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index c7ea9845351e..464a721f8889 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -514,6 +514,7 @@ bool snp_init(struct boot_params *bp);
 void snp_dmi_setup(void);
 int snp_issue_svsm_attest_req(u64 call_id, struct svsm_call *call, struct svsm_attest_call *input);
 void snp_accept_memory(phys_addr_t start, phys_addr_t end);
+void snp_unaccept_memory(phys_addr_t start, phys_addr_t end);
 u64 snp_get_unsupported_features(u64 status);
 u64 sev_get_status(void);
 void sev_show_status(void);
@@ -624,6 +625,7 @@ static inline int snp_issue_svsm_attest_req(u64 call_id, struct svsm_call *call,
 	return -ENOTTY;
 }
 static inline void snp_accept_memory(phys_addr_t start, phys_addr_t end) { }
+static inline void snp_unaccept_memory(phys_addr_t start, phys_addr_t end) { }
 static inline u64 snp_get_unsupported_features(u64 status) { return 0; }
 static inline u64 sev_get_status(void) { return 0; }
 static inline void sev_show_status(void) { }
diff --git a/arch/x86/include/asm/unaccepted_memory.h b/arch/x86/include/asm/unaccepted_memory.h
index f5937e9866ac..931d1388973e 100644
--- a/arch/x86/include/asm/unaccepted_memory.h
+++ b/arch/x86/include/asm/unaccepted_memory.h
@@ -18,6 +18,20 @@ static inline void arch_accept_memory(phys_addr_t start, phys_addr_t end)
 	}
 }
 
+static inline bool arch_has_unaccept_memory(void)
+{
+	return cc_platform_has(CC_ATTR_GUEST_SEV_SNP);
+}
+
+static inline void arch_unaccept_memory(phys_addr_t start, phys_addr_t end)
+{
+	/* Platform-specific memory-unacceptance call goes here */
+	if (cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
+		snp_unaccept_memory(start, end);
+	else
+		WARN_ONCE(1, "Cannot unaccept memory: unsupported platform\n");
+}
+
 static inline struct efi_unaccepted_memory *efi_get_unaccepted_table(void)
 {
 	if (efi.unaccepted == EFI_INVALID_TABLE_ADDR)
-- 
2.56.0.307.g5fe7bd680c-goog


