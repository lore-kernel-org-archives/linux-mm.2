Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0715DC44500
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 13:36:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9BC86B00C8; Fri,  3 Jul 2026 09:36:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B25596B00CA; Fri,  3 Jul 2026 09:36:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3B006B00CB; Fri,  3 Jul 2026 09:36:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7905E6B00C8
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:36:31 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 86E821A0119
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:36:30 +0000 (UTC)
X-FDA: 84947564940.25.9631BF6
Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	by imf11.hostedemail.com (Postfix) with ESMTP id 92E4E40003
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:36:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="M HG8Ay+";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=rWqDEXuq;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783085788;
	b=U7cZxSRVqYMf+yVmC8zicXn38LbUWZ8oNtW4S7EuuymKavIbIII6+5Ebl0mFUw9QlB2cwQ
	euWLZ+quFDJVmwzRYeq6+WEOL0VDZn3CEH9VPRbgtXieo01ITmHXCEj+rT1Xs4P3fJLVCn
	3cNtqdXzMwbZFEhaXz6pDDQNRUxOZDo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783085788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KHWPH1BueoLrKJ2AnlWZbvIzikefHXu8fHT5GFP5/Qw=;
	b=0Gf5YCqBOu9xC3iQp/KyUorIC/yqpOXV+Af0qkaP37CU/QP1wsS6Y/+AP3wnUExGDmr81w
	ecoRbBgk5J6fWN5zQURxvrmOyFZUaBgCvq4ud3PAkRbsqBuijMxyx3Qqa5bx/4TgIskGtl
	pm8bPqnMFQKAUe0LHrQOID/NzzBn3hk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="M HG8Ay+";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=rWqDEXuq;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id 65F3D1D0008F;
	Fri,  3 Jul 2026 09:36:27 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Fri, 03 Jul 2026 09:36:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1783085787; x=
	1783172187; bh=KHWPH1BueoLrKJ2AnlWZbvIzikefHXu8fHT5GFP5/Qw=; b=M
	HG8Ay+Qks+uAN4YWnGVQypkPkpba8hY4zn2qBGcqoWwNvDjV9bGdPax9Gu1GZtAA
	AR7zJV/9CQViysTWqeuSTOZFcBPiIu+OASmZ+/2d+5kiPv5QfKTZHU3OplPWDe8P
	CzGMJoV0fm8OtTtSTfpE7z7eb1GmxGw0m0FZNeWpc2APg2HhDMj3wVNNQ38DlHGp
	T+/2swdoDa9tMV3JPnryOm1qv3w1sC20YkbvlwsAkmlsjbnmY/9ong1KBsx4p4x5
	9RKIv/YRl7JYzDoJ/XzI+f7ON2ENVUDz9tzpezk5UdUR6F7LuFC5P0Trdj6hEXZH
	XsriPM/7datB1Hwy6Vx5A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1783085787; x=1783172187; bh=K
	HWPH1BueoLrKJ2AnlWZbvIzikefHXu8fHT5GFP5/Qw=; b=rWqDEXuq0XjOhUDst
	CY6oQvgrvmNxfCZbrCi0taFetQWguJMCzTS8ogrvoeQ8rsus2rhlpwP70ixbp4vO
	zFhXrbh04F5LQaCgIIc22/DmkDFF4LkECFHnxHcZMEMG7FXOKQ1Se2g6+zeytijh
	iBOdsOwxoWNCWFbYQwSm+CAFJE+omq0llTm/dIDJe4+BXL8GYT8a1im8QlQo6+Qj
	x39WHW0+0I9gEF/VDVYkMwZ3h8gyoZs9V9ujSiEJm0eakhB5uF37VuCJxo98ADnW
	7f7hTHjQVrhpIaOsd5/m0ZJ3dnnZ/qll0rNXlNiGNOasPjxS4bKh8KJMauUX3dcI
	Qr2eQ==
X-ME-Sender: <xms:27pHan7JRlV1gNKzWbpDVGW0DEWCer4aaBUpX5j0ZVKBS0qzLyNCug>
    <xme:27pHag1Gfbrtv78kK03PcbA9qVgN-3VRl6uej8WZOROiHmoMsh3GGUKWSJAZeof-K
    e-277HAwBMHqmpiJCcEPRD_EBOr8WDRu8dh81Lp_eLyEC40cL9_bQ>
X-ME-Received: <xmr:27pHam_B_xZgG53ZfehgXjuAoJ5rUU_UVB3kOZZUHoCJDWhzYPgmbfmPzCHPtQ>
X-ME-Proxy-Cause: dmFkZTFObHtmDrEiOrTAooOaqm6z7haasp/DWQQxlKuCoy/ufJ3arR423SUx8KwajdRAx/
    x0jPezqhC2sfr+GT8jp0q5YshlDTqzRRtEcPa6we+rqnGsfCS52ASTIDLyRO3E+8Tw4Gkd
    hUYHAtthSIAZ0n/QBAQDdRZKW6Ycha11d7X1KClqXgbrby1IrGiAakMxQ1tKTVdk1Z1U2Y
    qaozPC9bPprAHNQSJYBq6ybm39ut+Xfo+PDjx6Fm6+BBWKCrbmDUn/uVEkD58GhSYrCfJV
    yqyM77j1SMH6pl73i1/aHZ7qpC77EiRuuqTw1xYDw27obDrQCQCJYR+4WK7HlJzcEtYQaT
    dJf4pk1iinRLlhGNiNT7+ECw+6k+oWLF2eyThkvJjv/kSscSbcEdvaj2JzVK4jG3XTDhsY
    3SD4yjvmunE1bGbQ87xxX8xVabpo53MEIXpayAkRhtsbZbL3sKjAjDo2HqLPxHNJpbtuzy
    poj1xl53R7g4P7GncFaiw1//qATVkwmBOG0ZGXwFdS7Cf6ikCcff3zPPzEYKMLpzHElVJa
    TArsXXV8lt7PPh9mBi1RPWLTp7m7bW44mi1n9YkBROts5z5jm1ovdenZZz4oKkqtfxIwRF
    1D4l6/7YaC4xvDkw9VMs9xJRyyC6sSmmrNNLLd+C+TAwjWuk3DdF4jIAzslw
X-ME-Proxy: <xmx:27pHahsn35gqfgMI5pNCNOWMTFYzs7vz_xHX3TgAH_ud4BXrms_5jw>
    <xmx:27pHaio70tkXiwPUSGRH7cV6R5jTQGy64ogoCe_cvb4Icby4CsY52w>
    <xmx:27pHasH-q5Vu0VR-VYRFgVDmIt_iK-M_ZzdGd3l_uVUmwanKRUKWoQ>
    <xmx:27pHal4E-shUiMQcSjHHdPE6Y8XG7WJpSAvnRm_fqlBOl3vjzCqZmQ>
    <xmx:27pHaq6xDX_V7ZfTw9LCztxJ0j9hn58Fs5Ux97DkfaEtCa9u7ysotvuu>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Jul 2026 09:36:26 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	david@kernel.org
Cc: ljs@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	Liam.Howlett@oracle.com,
	ziy@nvidia.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	jthoughton@google.com,
	aarcange@redhat.com,
	sj@kernel.org,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org,
	kernel-team@meta.com,
	kas@kernel.org
Subject: [PATCH v8 04/15] userfaultfd: test uffd VMA flags through the vma_flags_t API
Date: Fri,  3 Jul 2026 14:36:03 +0100
Message-ID: <20260703133615.1039465-5-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260703133615.1039465-1-kirill@shutemov.name>
References: <20260703133615.1039465-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: n9rh9yyobggxihji7ij4hkuot5iis8me
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 92E4E40003
X-HE-Tag: 1783085788-407111
X-HE-Meta: U2FsdGVkX1+4tNTNgOWeMfm5/b/GF7AM6ZZUWITy+fzzqYtskcyPFUfgzVNz0uiuyOLqgXRgnONOhXspWoajDQwcRR+9KCe7Yit1ZNvLfZ2SdU4ency955AiwwGmP7mPgNBcXDfNNxLpgxYrG5ZGuOWNzcOSVz4FAIvqCvIx5xXc9XykVk1Bg6HSuEXDCm4I07T7HiFkoQzbRfAjXszcoBgHBOdmosZLmyxbTCXkrL7P+j+YWS4OduLHnqCPm8WZg37KIkaJyOFxD6zD7sk/Aj+R3sjLpKLIfdtEghC3zxRhrrIyCG3QYkOCwl6Ueeosu6RKZ+eF92gXXgWPOSLU2gCE8K+n6OIVgb5myCm60ECkhF9ZAnEjvXayz3tYbl6tipt4F6pwjOVZYlswhc1ZcqpeiOOZEH3OHJBQJvCbmUzcxazFFca1fUWSGlzlPZSNocCKDPJm8vyI+tU2IF/yNy4PGd0mxE2mu2ETSetTA/GfA/CocDSnm6Ib0FKqU1loZqxATy+Il/HP94gj/Q0oTJ8GaVZMceJ2Ns61AAp+fldrkuzA6L5zBaxJ+AxfZNf6Fe0TGG3SSUN70SgqJ8ISeCO2Krmi4dLlREsnGJblQDZa2JDFNLRfhXj6o8Lw6h/0n3iw5cN7FTBU3UpuKVNHlZh/7yHUAMWmY3rru+srwOylyH1DTqNIIiKefRuZcE4Z1QVg35Vh1UutBHV62JIrznEUj4xjz2jTLGSFxTNCiEfMB5B2zbGznkEcUT19yvubsKuH83yQK6YXSSZ/TlQhJC1zp4iYFgxpnFwdo237exGUYssSrMby3JFlj+Gdh7Iq4PMPhPkneKG6a/UqqgxXWo9iwxgNGw62oZ2ROPFPfW3UXyaGOBIdSzFr1qdE9wtklDazcI0ppJjytuUqmtoIj4C/EcdTyVPOQmnYHrQnS5AuwloJu/Oo7MvgI1blFzPpKn/Icg7ggN9MLg86PAx
 Jwb39/ju
 LEE1QiAOPh11pkTyOoLxCzGiY+9BXr3DwcXckRnSc2keXBohK2yigBGWl8GwZteMbE/mckmnLmUEOTNkCO5qVXmWjpXEFZwKCe20JMQnhNXuSBFAPFDYHc72IpC3mBA+EmG49BjLld8da5L84erDDhF9zz0V65bghegX9gQn8UHSQ9sKSvEilhFy6LHM82bKy57+MhllInMFCbR0srdHPfpe3EIit/qf8Zn6+PkxXPFSKlLsu/nQlmQNriS0U/8HF8tnzunw7LoPiLgw7HNHLen4pm6F1Y6Y7ko716PfwrrFNrmkEnWmvfRZ18X2BhcVrnsJGSjeXEvnGdzxvunnTde+zCuLdwXwbCJGRzaIY5hyrC50gyNYMKOKGFiIEJWvMxg5+ReE5jwiQAAkgr+XQhbBHV67fb02GOFw2lISHaNexWIv+7t24XxTCHE+hIDO0ZCtvPQMV1b0Psd8NFe2FRlzGqvpBaxo6DW8QE+FJ1pZBxkXtBm7hLz/H30/yWg0kOb8Nv4P+lsUNBROltu4fxAsi5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The uffd VMA-flag helpers read vma->vm_flags directly. Now that
config-gated per-mode masks exist, switch them to the vma_flags_t
accessor vma_test_any_mask(), which is the going-forward API and keeps a
single place (the VMA_UFFD_* masks) that knows which modes are available
on the current build.

No functional change: vma_flags_t is in union with vm_flags, so the same
bits are read, and the masks fold to the same code the open-coded
vm_flags tests produced -- verified identical on gcc and clang, 32- and
64-bit.

Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-8
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
---
 include/linux/userfaultfd_k.h | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index 658740df2978..c4f2cc6dfcf0 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -178,7 +178,8 @@ static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
  */
 static inline bool uffd_disable_huge_pmd_share(struct vm_area_struct *vma)
 {
-	return vma->vm_flags & (VM_UFFD_WP | VM_UFFD_MINOR);
+	return vma_test_any_mask(vma,
+		mk_vma_flags_from_masks(VMA_UFFD_WP, VMA_UFFD_MINOR));
 }
 
 /*
@@ -190,22 +191,23 @@ static inline bool uffd_disable_huge_pmd_share(struct vm_area_struct *vma)
  */
 static inline bool uffd_disable_fault_around(struct vm_area_struct *vma)
 {
-	return vma->vm_flags & (VM_UFFD_WP | VM_UFFD_MINOR);
+	return vma_test_any_mask(vma,
+		mk_vma_flags_from_masks(VMA_UFFD_WP, VMA_UFFD_MINOR));
 }
 
 static inline bool userfaultfd_missing(struct vm_area_struct *vma)
 {
-	return vma->vm_flags & VM_UFFD_MISSING;
+	return vma_test_any_mask(vma, VMA_UFFD_MISSING);
 }
 
 static inline bool userfaultfd_wp(struct vm_area_struct *vma)
 {
-	return vma->vm_flags & VM_UFFD_WP;
+	return vma_test_any_mask(vma, VMA_UFFD_WP);
 }
 
 static inline bool userfaultfd_minor(struct vm_area_struct *vma)
 {
-	return vma->vm_flags & VM_UFFD_MINOR;
+	return vma_test_any_mask(vma, VMA_UFFD_MINOR);
 }
 
 static inline bool userfaultfd_pte_wp(struct vm_area_struct *vma,
@@ -222,7 +224,7 @@ static inline bool userfaultfd_huge_pmd_wp(struct vm_area_struct *vma,
 
 static inline bool userfaultfd_armed(struct vm_area_struct *vma)
 {
-	return vma->vm_flags & __VM_UFFD_FLAGS;
+	return vma_test_any_mask(vma, __VMA_UFFD_FLAGS);
 }
 
 static inline bool vma_has_uffd_without_event_remap(struct vm_area_struct *vma)
-- 
2.54.0


