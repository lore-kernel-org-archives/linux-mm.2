Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45609CD4F54
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 17:27:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7EB56B00DB; Fri, 29 May 2026 13:27:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2FBE6B00DF; Fri, 29 May 2026 13:27:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 945516B00E1; Fri, 29 May 2026 13:27:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8320C6B00DB
	for <linux-mm@kvack.org>; Fri, 29 May 2026 13:27:56 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4748B12026B
	for <linux-mm@kvack.org>; Fri, 29 May 2026 17:27:56 +0000 (UTC)
X-FDA: 84821140152.14.6CB8FFA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 508614000A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 17:27:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nec8atXG;
	spf=pass (imf27.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780075674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SQ1nDTsRLGDl2EAMFRNs5j0bNOh8Bj7CANx4ag7x/sY=;
	b=hcCi087BLsLHXljkSHj39PRSXNBMMMiopU/wPBNmyQhN/Umy6eYv/fMybtufaN0wqnkv5+
	Yna3NpM8uGZrKwmVl+KH4NvsaaXMfqSLlKn0kUaOFofXlSURlAKhnB2kdsuApIOLwxbQM2
	cCf8f2n6Wgg1DpFx8PIFnpyO8e26Txs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nec8atXG;
	spf=pass (imf27.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780075674; a=rsa-sha256;
	cv=none;
	b=HhfB6PWr4YYA5TJdNuXvzxnZHu8rQhzdirfwG+izV1fSFfPIz3JNbHLixihwIfnCzi6H9/
	pXVor0NMHYIpDPENyQ0SENHtoRJ734/D5YKHnleB6hfZ+Sdt/QSN2gcpJQRjQFFNi/FaCF
	IX31Z1sn2yjbP/3GjswsQAmwRM13rWY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E524C605D7;
	Fri, 29 May 2026 17:27:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA4AC1F0089B;
	Fri, 29 May 2026 17:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780075673;
	bh=SQ1nDTsRLGDl2EAMFRNs5j0bNOh8Bj7CANx4ag7x/sY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nec8atXGkJujJy7W2x4RHeh46PyG43lwX17Al4yfDKD2PJi9hzW+FGqt0/jfwtaxv
	 8Iz8IXxQt2kesi3AVnRMvmM7gQtKPiuw/755WryrO0nCG5ESZ42N4YTj0TTgANSpH5
	 Dn8STpqqEFEj93dlVLHoCOacVswN4P8LSw6nwdZOvjM768/1s3adgceTMnkqn0f8v2
	 mkX0T0NjgYuWFQiHh1R7QLORYC/4HxgqrNOhcZuR23mgXBXK5aIB9Wqj7A2fHTiMuX
	 MhxhXkrLCzfBEkjGKrj1NuGymRZkdd4wiErdmHAjdQfWxf7y8Z9Ya72AnUnfFRmPk0
	 iLz9Sda5XClWg==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id 13B7DF40070;
	Fri, 29 May 2026 13:27:52 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Fri, 29 May 2026 13:27:52 -0400
X-ME-Sender: <xms:mMwZataQBwkAuGSzsJdlgqbFu4hB7fOQSLqO9IHHZZqKkX8BpoZfVA>
    <xme:mMwZaoU2y4sOdXm4hc57giUEm2IYFv2CZ9Lvi6vSutUbz4qplttYbsjeTt8VusIxH
    k7PAJ5o7mPv-XOQmBjJgCHI8zxS_LSLBKoOw5Cppss1H4TDTyEl3s0>
X-ME-Received: <xmr:mMwZaof02vmZPAh9NSuJoRC5idaSuS5pyUWuqWG4HoPkbGU7N6GVluko3zZefw>
X-ME-Proxy-Cause: dmFkZTEUyOwNbDmHa1KNnZhhp0sknwyB5iYBikO499ls5PXcb2OBGZ+LtCI75nkUeooCiF
    UzrXo04XJ8+Ua/uZDk13qfrbBwlZ5p9xJmobKJQlMbnj7l7Wa1HVN1RPiFo+pMeAxt22yi
    61vTsKtOSGFbPiuQJwzf8kDMk7i9oYKVPojpqHuO0mt23+5gFs2X9nq4e5eFTuainOibKw
    /PjyCpBsVGYk6ilHJDmI324wGNqP1tQqUfnSbHSEKXH/CNKWAMLzoIWnryvyvz0mzyGoSH
    2C2M5+XUQ3GxwG6CgDLP16c5lhscyjq12y5muGouPR8MZ3kTeYPrBARrvcwg6KATek/ZWq
    +dP0D1rsZmQ1VFiNA+xyuNFvJNCjaMNMPCLtlNpIj6q9b06VrZoOfLYh6a5mPwNib0hkRL
    c+ZWzy8ciJA0v6d/VtEpjxVHWwAipQCSTrc9sxdVPlecEW53mOgLz+tV1zJ7JLvKwfawMO
    qVXArPzUPOoTGowwQnDvJrO7egZwJGKJkwMQDaQbsj+yUcxyiVKnn/amGJ9qd5HJ9Sp4sO
    7gte4/4huMO65wclA1C+VepBODWBRI0A5r+98PASSCy+d7rtf8X9OJnFiQibhGontdXFK3
    qWaGg4A2UenLkAl7DzOZU688UcpGeTPHuTKZu/nwkn6RY9O7b2wuki171pbQ
X-ME-Proxy: <xmx:mMwZalN4OwoS9J1r7c6qSZ2cRpNcVkaIEM_T5vYZyWev-4WYa2I77g>
    <xmx:mMwZagIguX5ExgrFreFQuALWRzdHd8OdnqhslN_tEma2KIBe4wHRgQ>
    <xmx:mMwZarl-tYRoGhZPOhI6mAG3iKJZNU0I2B5ZHliu1Z4BUWkICTB23A>
    <xmx:mMwZavZQniFpJBej5AJGO1IDL2mZtuovV2zk9fCECmydqdLvle9Odw>
    <xmx:mMwZaqirj9zWG3hh1xGvkPz3mckosWYd0VlCrqCCYal2WJeHbzvM3_qP>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 29 May 2026 13:27:51 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
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
Subject: [PATCH v6 04/15] userfaultfd: test uffd VMA flags through the vma_flags_t API
Date: Fri, 29 May 2026 18:26:33 +0100
Message-ID: <20260529172716.357179-5-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260529172716.357179-1-kas@kernel.org>
References: <20260529172716.357179-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: onjedismzdxzx6366jybbtfugug587bg
X-Rspam-User: 
X-Rspamd-Queue-Id: 508614000A
X-HE-Tag: 1780075674-442419
X-HE-Meta: U2FsdGVkX1/wPw4OqzoNHa+53WpArziOcqfMgGmJBG6KCSn3FTLpFONJ2PAYL79U+z+Kw/jXrdjikYV4Bhgsugo/Ny0WczRaaSIhDvrm+hcIc774AQt6u96rvAJo3CiRgd3bmN1VnBu8v3ZAR6WDhKdd+kA5ulpzUF9yvkhLCV6mX9M2iM48TpBpMV7wrrWkz/icGxzpB/ExiK0pxzwsXRmUf7llNAGH8gbUfoZ2zlZ7Pj7IN/Ub7JYbELXnbnizj+soiFA0EOGRSdNw6xZJ11naKjaPhKeTZUbAU1AwcTqI8lLpqkLgkJmxkpk8wLwVPw3F+uz58Ty/j7thgOh44ZpKXrOLMMa5kg2e/pz3KgR2+nLXG765IjKXx+Vs4mttxBEfVwiaS0bMFYFGClNFQQeq6a6VBwbdZlMc0A1RxuWn6xVxa9BnYSjamJQTpTu/SPxJPm/yIGujlJ+1SVG09FpO510hkgDP8BO7UqfYPepmbL5bhcr9wK35j/gOYhbu2bnLRCnAyM6Ek3Fhp8pprRhP+8jgOssI49ZhWkJnB1x+w45lJArowvzRP61ieXNFfNsbga4+C961FAJz5mZliKiJr6Xn/DWXoCmoJ6XqsDiPfSZnPT0ttvgk7Rbxh/j7hovW+GLwvcIo/cxNe0xPDVxdI7pWPoS0INNM6C9WaxDBc6Ppnl4ltrs4flJLtHwIKtNqlnzirYrJfgcVxMa1OVFktpNLUoOAfKgb2VdFzxE/cby9ovpzTfzT7qCnekMdqz8mx/VJtNadQIxeQZG7ZLAX+Y9clfWqkz85VLCaclgmayhq3xvb0OvO6xwp5O6e7esKl/fD8DjIc4IaYmx/+uvPSg8RwzLod3fceoWcOIGBs6JyPb6q0Xy9wqeHfr+H7AXu1dboAHfLwLGsPRRnIfW3E5N5rLLJB/nEyIN8xFG1gYsgwEJJUkD4NRVMmv50S3mmIiP/rmGBxuzHNSQ
 zf5tg6am
 hcmHd18krSI+wZpibIP4cJI5aCGPp0eEAj56AbFW7QnFs07HsBtWJk3Xud060U4knxcY/ALD4uGH7Y+ozXprhrDM0WuaUrD7cq09JWrF49dYHmRD+RM7k7StRTGDkN+BgryVGCnyHPyhWtFGcJKtzvBG8h/rIZq321SoH2TCxXVVtPYKH7fex5N6DOwbhxL0ZzvB8s4pVOhgzgv1ddjHkLvhttGAGDyGfXPKsubp7edJiQ3a1NJZ0WrnYBeAUm4JXLjK5f/fKncQtFyBPUoGkKdRbOFZ0DtFBJm2O/bBt1Bn85F/rOD8QLuV6Vf2bT5KyyCmi9wnTZxuDIQaUpZdyZJ81HRrsTYmBdwRRK1H/C51FGwcD6HVTuKt6tg4/O99WPCiv4FnBJvDeMMiqrSQzfpa3BBtv0MSQhVa7ZKAzEnJhDpU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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


