Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63671C43602
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:48:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 783D36B0102; Mon,  6 Jul 2026 04:48:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75A556B0106; Mon,  6 Jul 2026 04:48:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 621E06B0107; Mon,  6 Jul 2026 04:48:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1D3EE6B0102
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:48:21 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 918E7C1624
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:48:20 +0000 (UTC)
X-FDA: 84957725160.30.1DF0CC5
Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	by imf30.hostedemail.com (Postfix) with ESMTP id A3D7280004
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:48:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="q AoW93O";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=L9ldnKnc;
	spf=pass (imf30.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783327698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KHWPH1BueoLrKJ2AnlWZbvIzikefHXu8fHT5GFP5/Qw=;
	b=LHmKQyi0dgQZwOxXbBmAT403ZVdx8IqMthnYO6UBqBKIY3QzWSSbcMOljAce1Gay56yW8L
	vawzCJiOA8HO2tUNcb1CnxEXUu4rMQCGW9XNSkWjPgT5mYgrFMvTfLxRvoIdIsUWiQIkwS
	xEfk/U+KAB5cEcrTSawkCNkbPQTjdBY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="q AoW93O";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=L9ldnKnc;
	spf=pass (imf30.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783327698;
	b=qBd7rpNsYS+3BRloi0zDSdIi5I/wEPpwmL+cYkr1uxjCMX4fQs4W+Uhhm0XNlA6ZdfZvyL
	rzOfobyoOl0wgsKSwp/gO7/OLnwFPKargK7O+2zhZivDncOPr6S7knLR0IKKiQe3Q6047Y
	CWr1yUJ91Cc82SN+pR+NJgA9DSdHcms=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id 758181D00112;
	Mon,  6 Jul 2026 04:48:17 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Mon, 06 Jul 2026 04:48:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1783327697; x=
	1783414097; bh=KHWPH1BueoLrKJ2AnlWZbvIzikefHXu8fHT5GFP5/Qw=; b=q
	AoW93Ob61ZDMeWv3+veGAfnpE6MRSoflezRdz5KMJDU1e24LHC12UTP1q5WESvDi
	n7uHF5Ct29DnEAXskC5/j5tthjKW/5gzEtUm3W56SEyekcGsxLzOH8PtNvfobdPY
	bOx5sYC9qkS/eiCNTaz/CEiHwySqUfjNWsFrMCj4HhUhKb2aTueX+Boz/+ynwMi5
	fwv4lbDSLxY3oLIClMzvusll4/dPZVv6GDz7jpf2gdnNEfKe4n7jWYn9mJmvEEzm
	Lm6CUpVCBytXoF66bGSCUE7xn0qz3zVSNVJfO0pxqE1XQPdlkUKTQUrum5eMDDDP
	2VSSCSZEibhI3ZFREx+hQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1783327697; x=1783414097; bh=K
	HWPH1BueoLrKJ2AnlWZbvIzikefHXu8fHT5GFP5/Qw=; b=L9ldnKncfgP0WMEX9
	RZ+jAHliQgtbm+bPNi6Rn9I5AXEhbhKWQq8rNzgTpC3lI3Dcj2P20HpEAtH0goRj
	+Tu+jCegb2AqXEmZ2/AGF8HLLGSWJj026KGeIsNI0dAJmXFwCjM72npT2maVbtwc
	LrcSpSr55NeRqFuttt7j8VKmXeJ5jk8oPdFRq01ejems+0HnAjlLDpvwLncNVGJQ
	+Wsi0o6x67orBsr0uqi2nSbOMwH77SKauIOdm7FEpJlR6wVd5zK3VBjN6d7VCUjs
	cCc5jxQoEHg2AEHB73sbceAFi3rMDI4rbjymKli1Kxp/WDiTsbT7ahyuusVqin22
	1c6cA==
X-ME-Sender: <xms:0WtLase6eky5k9yFBGsY6pUnhqeLVkwCiPQYv4RZ_VTOYB-RgsFj3Q>
    <xme:0WtLaqGQQd6UZTiPFXCLGMUviZjWnclrvDcPlruIvFEMB4eXxzI229rTU1tdqvLnt
    dxoelEdNuTMeI7c6LhO4_GwuDXBmGIgh0a6QUV_Z4Z8-zMexfr27OH->
X-ME-Received: <xmr:0WtLamVLI-58J2unkBAtQFq0vLG_82CoMGv_ffnr9xStsbFqc2VFX_HOqO-t0w>
X-ME-Proxy-Cause: dmFkZTET0Fy/mQ5GxzVkQ3gF7+kMhlrCFV8qSTPNB/FMzugyamnQzrMucqNMsaFIbnsWDS
    3jROHvtXXewIALBwtzeLi4ehIRfdxkunZt5jjRrCRxJei7s8CxoLlASfjBq8RK3uewm/Rq
    uRAT8JnF94hU7TjV6P6upYkUbh1epL0j5kGSBOBVhQdyB5AsitnuuDzqvdW5SWYeMkpb/z
    4GJwYftRBV5s9rVqMXoOBF864Rdc0C3wjYZZxm5WCWO7+uAnZDT04L14GFTXm8KkHgw5DW
    CWb7yXPC/MOZEYPY5k1KGuVSi5ef/GhpKzsuc6EC7FHA/OXjfZC6Mku40qXEIBFc1PlPm5
    B+ozC1p/6+plR6xDn5CuYDWSsFmr7/ZJ+0codrF7awO/tzpw1O9Auhug7XnMl9JZcQDJpE
    kZmISsSjzI+wCjhH8VDP3PDU6sLbUtp4P6LY8bjSH63yg2On/aOiiGHb57yGaP5vEQE16D
    j+a2fRh7SW0QuPEyMUTTLQcUir5zDo+HFFONGOzj03IkUvk13dmEIcr60YPstp/iqUbAZk
    ebsswMENplkpecZ/Sv10qiRPycd66JjTolj8EkJFo0J36NOoacihRxUOpAzXgBukEkfvJ1
    NcBThyrNIpCZ0oIh6GDgRTGifwVtRBL8XqGW/W0yOlXZgDPjPn4EpsWgb/ZA
X-ME-Proxy: <xmx:0WtLaqwqqACmmuvsVrBhYeRwbgy7Wo4yKybYKFlm3dXh3bFOaIu2QQ>
    <xmx:0WtLahvFydun9q5BcMBFjZWuOGoBEXC0nE1EADExuL-0iCQEaaXhSg>
    <xmx:0WtLarBU1EpAyZ7M4CcBBrkyQO8NVwjKrNDAy7LDlhvQdaSmUW9ujw>
    <xmx:0WtLatpdYKtPauJhfwMov5U48bCLFYVFtproV3c0OWZuY9A4WwAK_Q>
    <xmx:0WtLaqeQglSoaL-RZC2oWApOKhEiOcLGdfRMGARWsfe0In_c7D9HJXfX>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 6 Jul 2026 04:48:16 -0400 (EDT)
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
Subject: [PATCH v9 04/15] userfaultfd: test uffd VMA flags through the vma_flags_t API
Date: Mon,  6 Jul 2026 09:47:53 +0100
Message-ID: <20260706084805.8400-5-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260706084805.8400-1-kirill@shutemov.name>
References: <20260706084805.8400-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A3D7280004
X-Stat-Signature: nteupibrqcq5j4nuadieudiusij45eiz
X-HE-Tag: 1783327698-192447
X-HE-Meta: U2FsdGVkX1+YKKx8FsAzG69ELzHV38pEnXd1flQbvRz/jkIKjpt4n+li9rdezspgnp+peiWjTyyfG2e0ApNTZxt5WEaKpWBZxBqBE7+ha8NLRAETVB4l8uetHtBHiJOxkyL9+ZjCwRX+f6U0JB+BQ2RHbv2sb1817HT6ykesdkq4Oz47IgSWn07sirjnGNFE1eTPz1BVjttC5edgFCxT2iUaxnhQ48LrKyuQDZLdCxeZQK8Y1s+HQRz41ytoaMbCjPr4y11H/FciY61y0WDjgOrLmF2Wm3od3Z6X/+sSH84iWSJKSjADOtV0U+vmz5PQZ1EEMI3s0KeVCzv6M3g27c5gEiMf3dis/BDXbQt5s/B+QSPoxLvs9DmQA7HNSmEU+f7dOs0PtjX1zprht4PeLR+th+59RnrfacjUDW6PpZj0iRqUoqB0KrOhnMrmHPi8n/xqQgyqAQKK+xJDwSLKN8dhTL4HCjl94ihmtaLhssd36tUdk5x0RORw5cp550cUcboiiCh5v0M9TdkNlyxzej8uWozkHfq9L42Silj4NzS9NAkSx/jvDOEAStIB94wwpvwcgisFf7ks7DOCy3D580DP6oorKaBNC5WfX+aqenctCldP+KMJL+HXtRQaDhcWwbh+VEW449GnAgoCxD4Cu6u8ULkoJqyxan0VVyRQ06w8T6Pp7/F9vk9wKXg5HM3NPnaF1MtV6udb0WWCcks3We5vaaWMWEXdEc+ZHlKOoNbuuq1glQndnWV0IYE9Y4eHFTW58Muzx2TEEbKoN3Mpb9xetgeAvnifd/uItijk40nxqg9ai8Zv9L04+pATMxnWevdEevQDLbq5Rrqqulb7WKI5qnG5PsPE9vKwMLUxHRXPdDFmT0e8vWPPJWslMDzNtJUxzMnu4/7Eq46JBeeyWSUeCoN00Q5bj2llsxvELaCt1V4FxVE/pVNaRMmZdGDi8vS04iUzwXfuMgDUlkq
 dMQ9Aeyw
 0vxEHJBWu0zbzXwxrcX6PKFkp+/3kqYG4skfuSCs9Y+G17h0RzS9JvQMjO7j4FeRp0UKTbt7/s3eacaHMr07Ad92jq7jvdu2pibNHGXYDidL3a6roP0Y3BinI3FrzI6/1d+ZassjSWWloF0dGdYbtHkbc6bUHAUI1gJWW7s4uK9JTYDKFTG2wBbx3aDnfzyHFr7IHwLr+QPPMeFADy4RZ5vTk9agEBgqZ4Mbx9hRrGbUd0CwvGL4KFoPBxIAKRC3L61m9qwe1DnHAX+ZeGeOrK0Gmajg3/+v+ah5Bss4v2NQhnTbpBjZ1Zw6rdEetlI4/w3x1mhSkK+RHsc9dKqjvG0ZSzQjowCtTjslQoWm1LOIKmTS+zlVikKaf1pVpBnUDWoEDSsnrQUC1q3Apayj+HMzcQULlJzUkkuCnHhvGNAoQwgS3SREJ/0K9DR4nM/IdnhSofv66iO7CrlYUiHSl7y5FGd5X4EivGQ8uBIHy7I1gN1w2Rkp8I1NB2CvgXi9Rr013uHA6yGw0rCTl+OvZJv907MpqTB8M1fZuynCiMEnuSfYzzgQgGLLwyD2pxEHnXexq/GXJFBJNS4VEmGS8yfFHzpD8Nm3J+QBL
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


