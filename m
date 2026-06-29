Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE551C43602
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 12:08:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3536C6B0099; Mon, 29 Jun 2026 08:08:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32A346B009B; Mon, 29 Jun 2026 08:08:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21A156B009D; Mon, 29 Jun 2026 08:08:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D3AB26B0099
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:08:07 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3B1621C3666
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:08:02 +0000 (UTC)
X-FDA: 84932826804.21.A41AEF0
Received: from fout-a3-smtp.messagingengine.com (fout-a3-smtp.messagingengine.com [103.168.172.146])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4A1CDC0012
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:08:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="X EudZq5";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=NomMl8P8;
	spf=pass (imf10.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782734880;
	b=ItDMAoKg3ZcrbUVZEidMAaAT33oM6yMzxLGNjt0tRLP4XYsYD24K3aOA0GOxvEDJ8tsnL3
	xx8xphnFNJkWMaFckQya7R3w7dOh17qvgGuCpcVa0dEM7LOD6x6VOl+d/7e4xJCMNh3mYg
	1qxbxYQtSeq5a1wab5R12G6ax5kZY+s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782734880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KHWPH1BueoLrKJ2AnlWZbvIzikefHXu8fHT5GFP5/Qw=;
	b=w7RaMtCInH9MYL8hg7Ffh+APrtDvfanAtwNuF2Cipkvzc/6k2QUUMSSC6kkMblZvYI32tO
	wAZ8jo8EMSOeXVv+rby+SWNp9NUyCkPT2T6DVBcOF8XY0r3C/VxkMLRkrZAznw91biprTg
	KkaUcDEg3TEZANrRunrFXHfOXCspjL0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="X EudZq5";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=NomMl8P8;
	spf=pass (imf10.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id DF0AFEC0143;
	Mon, 29 Jun 2026 08:07:59 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Mon, 29 Jun 2026 08:07:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1782734879; x=
	1782821279; bh=KHWPH1BueoLrKJ2AnlWZbvIzikefHXu8fHT5GFP5/Qw=; b=X
	EudZq5APAcY9x0i5JcynwLKfmVnZTidKKxEBlHIIlkxHfc179qH46b49gjwuhwwz
	0C9mGWcwKw43YioI9o916ub2OqjJowMgNb3/qfwkm79mAMpo4mp1I1DPMTTeqD4U
	q8UOudfsQ0xIlAdE/w9y0drOyC9CQ7OjKmVaXGPyIFj91i+zOFVNRe/BM+HkBlw8
	gF0KLG7rEmFy+To5AYFcdLQq1FahameygMODqviUUgIztGRZnTwZqiqOEi3Gstvw
	KT1OlSgCsiXX0kOQ4G/FegAdqRSsDCim3860eQZhKE6CnR1YxhIJHtuiILQSdvNe
	YtgX4KGbHMovGdA9xJ0aQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1782734879; x=1782821279; bh=K
	HWPH1BueoLrKJ2AnlWZbvIzikefHXu8fHT5GFP5/Qw=; b=NomMl8P88b+n98yd2
	qDtv7bnmi4iYNquDZsQ8TiUCsL5zNgowlGj/eEGg+RdyiJqaSXgPN39oiimNJyN5
	h2JTm/KRQ2zWOgUjEtXqci6LlU/IOHSWgwu/T4Igy33mPsjhmy9ETQ5hiz9Gr0wN
	4t6flaq4TyHsD9KMWMRRDHigLD5LZYDN1icPDIRi0EsC6dNk2GblsVr8n8iyS6HB
	l0O0xapHrPoqecQa5cl7nhuLKRqlruy0cn4SfUm7R0gpDfte6Tr5PoXMg8gbBTXc
	KSfHrNGo2vQt1v7qQXri0izrjUtGSiktzNFgzSYS4PBQrWY5P27DnaYQjtYnrUtM
	TvpMA==
X-ME-Sender: <xms:H2BCasc1oX0PSNUjnjrqTLZ1yIoS-S_IkBOJFBe92PYjf8fF258Fbg>
    <xme:H2BCaiL3kkfdKymIuwVx6xBmHvhvB-bYptIPeUl0hHIhxYwr-EfjVTf6JFJZMgteW
    atCyrTVkVZYT75DiLdIxwniWgZAe_XkpHtrrD0ucSdBuZT1LBXNCio>
X-ME-Received: <xmr:H2BCamAFsRspgtl7er3uYKoqgemU2oUXsFf887WsGb74Ih1Cc4YswfAFvj0Xkw>
X-ME-Proxy-Cause: dmFkZTFY6shGePvmxOMh2n7JXpRvMYayhSPkReA/qp2Kk9FFh7qIwqznFdabTWQQmbT6np
    orb7nZimraCt1e9FjxE+D963WQ5XDZfLTwLobafoyB3i66gOkO3z85tAcKnmI3RB25+PVB
    EZ98eAuca1GkEm7XR3L2jnIB5DGE7Gq/dUpvQ2A9oIHx8hwh4f84uT4y/OhQorrh2fKXDR
    UYo9Jps0lppZOy2xiKorTonIMZqLK9GUCnCQcdTCD/z+aL3OihCctiT9iWAjf4SCGuOWH6
    0ORm+HxXgzRDvylsCh2WOkVei6ivCiAy/pOXBTW6wB8gDyVJ0wFaPNiIhLc7QTSUTVd0VI
    ej824Sgbwq2ofA/Ioj1fDQ7At6PANE5RJuIvat9cKb5nmKkgUcjM9JaWNnTZdbKavz4Mfc
    4Kx308YeGgSYgc/E0WAutMluVqrSUUQi+GIT8Cj5Jie2BrL4wnI6MO7mtXZGyYdBsdFxuw
    h7i5keIGR15n8ZnAwW3iQp/typHz9T690ycFYUeM6mzb+Z8cSnYDpIReqXcQ9ZnB2TWZP9
    7msMuc16hHHN8SKxxpjuyv8dGVe500dXtf1XzR7h/iCNWsgI9cqYwu2I5DIALaUsUBBg7D
    bwSThjgASdsBBy/qDbNBBnzdJkfoEaViWN5hpdJ1wHXRaUGUgPw3gZjxnEwg
X-ME-Proxy: <xmx:H2BCariaj3u7xWw_Rzf7fE_zXNQDCzTPE_IJBOfS65NgfyZ_J8t7ug>
    <xmx:H2BCagODjqEbvTv5kJd7u81JVLczPA8bXVV7e4n5znV5WsFIL4Zhbg>
    <xmx:H2BCaiaMbzP6Axw1X8OEvzfuJ0OIV7qOtwnx7aRLxQibBIoC3dXRLQ>
    <xmx:H2BCal_2YZUFrmAYIy84iWkdZoRrd79uEOJGyhxWFCXCl_nwHwjTtw>
    <xmx:H2BCaq_e6e9vHYyJSQaamtRDFheOWr3DCzj834rXqVILNqcBjljtUWKN>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 29 Jun 2026 08:07:59 -0400 (EDT)
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
Subject: [PATCH v7 04/15] userfaultfd: test uffd VMA flags through the vma_flags_t API
Date: Mon, 29 Jun 2026 13:07:35 +0100
Message-ID: <20260629120749.566063-5-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260629120749.566063-1-kirill@shutemov.name>
References: <20260629120749.566063-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: e7gjkzygwf1siqo8m3of7bzrs4hgxezb
X-Rspamd-Queue-Id: 4A1CDC0012
X-Rspamd-Server: rspam06
X-HE-Tag: 1782734880-666555
X-HE-Meta: U2FsdGVkX1+9eZwPEiS/wmukDLRNiEQGeFTUUjsPEP6jdIH05iO5Jl/7fFgL1XpT7fAUt+0URoE4aGhoqauC7sQIDq7HU3yRqohG67mj+Hpr5NHXNJCKQQpsRjPQYqCzOj3gDPKMhMqu2jN0G9ozwOpTxzt++T05VDMA59pA24esOMupcII5zMl0P5pxjrRRbNeGJhQ2awNg+p6o5L8Ny/yKLyij7To7Zz4eVf+rw/tvuqovsHh1cqwB7eZVbvziV4n8xR6s76TGxsQncsSiy62E1ShO+8k9J4xz5fmtKv8qjHIklTsoi+p3ajxEaNPa/Iv3Cr3/z98Rp59PRrHRHR/ZeTYxIpXv0NeWlhT/XGZMlSbDFbu/4lgwbmBfnxlBkQm7mxSBsrxItWXy13zF62AWTrLeEc4JSbDtp/TqWGLLS+OBXH4xoaYzwP42ZFhn2hJa9+/3vpPkdk6PHNDPbmf0RbzWa3kiRCtmUhZLLglrb27pqi1R1KapeAkSRgxevd/DJd2FE4DhXzA0xG9zRQANvFZn52X9q3GW36FIP4ulApJZDm/+NGLNYgy3xzp4mnBnjc7j85Hbnpb9ssuIpZoWHGg+Qy1W28vOyeHuF4jREIFz1x/KEcp6P0YN7tYJNcseEEz4/BhNXE7+aYU9dqOj4H8E0YM7eDabqsQNgsp1hU4g9jQQxQ9CqdSLrkHMlcHS+O/PAZw5qcM5QPlbfawaUXamzalj2O8D6bae9hSlNkDRSB5Qk47YezjwSRe/3aFRHvv5N9ZM51/0GM6/PJuViZ4Rs6Ym+mfIeyCCIeDp1Kts2jPJ4nOK1Uh/mx5XemDbJ6U4rPc68GbvZQUxX1ys9cxCWBCuTNWQN74Tql07lKj07baSt1YRxTdjLJT3MHnJptR2kusEzjaB9VbgtX6JpsY039ulpSJ6QnRq3zVixDBqF+tMRWNYtnTo05oIeLWIO7WU0oK2iT7hJFH
 9NouelAV
 EwijHA8eI5KgcwjrOzZAMpD8fMtDiA3Yrp/tyTloRmbAnUP7N0CvxwdEmsbxhx61Ll+SiVBgM4oLtMOesoCvWHgIHqocQ47dW2Kv9mXoyJFyVMaPLIRHE4lsO3ss5bG3coXl4lL7giSRzeqlzV2TU8ye9DPgFEMII628II7N5DIWZlBSZ2q1+Fb53CeJkiDWp9PdXejslT178tngv62hQtG0jwPaG6ARnK2leipQFHMm4P6klTNRTeBzEt0F7mojUGnWu8yvJ60SLDPL5bvVRnwrguN51yA8Mt4oxd/NEeM95Pv6+2wZDjbsuOhpNoRTXwYPt7R59lISV5lOrPvwpKSiMNv1r5NUtQ0FgAUAqjOixY16a66IyGNgp6JCdkXp32v7U43qwEncLGFSAQnJNu8hQhZxHdRlHx5KUqk8Q9INMi3KVpzjaxeM7kZ6ch20IeNAa0ORWklIqq5uJLCtO3cNL2WdDI6KPec08aVBIJp0jsMjL3GNZtloYdntm2TxqwBER3+dRXGFAqTrldB783YENnA==
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


