Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9B45C44501
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 11:14:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA1036B0095; Wed,  8 Jul 2026 07:14:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C78F66B0096; Wed,  8 Jul 2026 07:14:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B417A6B0098; Wed,  8 Jul 2026 07:14:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8BF006B0095
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:14:33 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 158C51C752D
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:14:33 +0000 (UTC)
X-FDA: 84965351226.25.066ED8C
Received: from fout-b6-smtp.messagingengine.com (fout-b6-smtp.messagingengine.com [202.12.124.149])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2202E180004
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:14:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="A 4+wb7r";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=IonbHU3W;
	spf=pass (imf06.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783509271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KHWPH1BueoLrKJ2AnlWZbvIzikefHXu8fHT5GFP5/Qw=;
	b=Fk/31mY5/BY2gU82LyunXZjtZWrr7V+uGjI4psL7p/2BfGUmlGTV9zFFOIqObul/YQe9An
	1iXeDJaoYpGRR+OgAQ9wciFcElBBbtxyz1iqBr5NXle6Wa+emJQzdqlsr5mEdgj+i4CxUH
	ZIr2MViY7Bc0+hG5D1PYCU/reSPsce8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="A 4+wb7r";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=IonbHU3W;
	spf=pass (imf06.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783509271;
	b=zAvET1M9WIALXSg2wDak/3ZE+ZbqBLOnck2hNxQygLTP/uNapdT7AZFuQw6DFc8c86/N/K
	rKJwj3UVdI2SKg2yad9KGop1BLVcKkPP4YomtMVQ+yQUTS260yK4FONPiaclL6PJgFaEUC
	o1fJFNySliA/vrgcR8SVGu/zVliCLds=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id E18BE1D00128;
	Wed,  8 Jul 2026 07:14:29 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Wed, 08 Jul 2026 07:14:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1783509269; x=
	1783595669; bh=KHWPH1BueoLrKJ2AnlWZbvIzikefHXu8fHT5GFP5/Qw=; b=A
	4+wb7rCn/35uZe1LOC31HNCxrSmlDZa1pEMLJvp5kBKjMRKc2V6bzdgRQYZNEQQj
	IWLIMrAW/el+aVWiSDnGC6tKiSxxyuQ/T4vISRLtGdaNZiGbme8SY4TA4942Gnml
	zGDh0i8GK0Gke7Ct4RjOZZEkR2qM5pSvE42b6UQMZ76UG9CXv5rnfOhS/SV2kMgy
	2U7htMr3yC1zySUMVk8QuVMYmxQiDqF17/XNmSMqbjeRu0WyTXzdTcgrqceVIuL1
	HeXE32u5kHNXwI6GR+eqqt5Tjfv7tBkQ6ruz35Tcuck/mwDpkHX/ttPeY0eGS9/1
	/frAl/L0YWnAGjiNMGcCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1783509269; x=1783595669; bh=K
	HWPH1BueoLrKJ2AnlWZbvIzikefHXu8fHT5GFP5/Qw=; b=IonbHU3WuIu3RNgS6
	hXINaWGxmcZzjlpRJ8ReqS5LyISBfc84Ftji2N7ANyoarnARqQfaH5fAaEMaAHq8
	7EQ9op02tQIeXMAOdgN3s6V7HrUK30tTfOUpYkn6OxzRStGQxZ+uWwH1mnxw4k9T
	ExPxu+zAxa7ZEJKXoNhaXRQOW5htcOHe3hdloS02cfoPhgpq5ZU5/CNOdyexPO77
	DnAS4ZL2G0SoMYeIzRq5gYDcj2g0OyG6+ETfgeEgBFH23n/dgG/dpxPmbznMa4YH
	Uo8/OVVHGe+EPUqdGxnx2ag1G0s6wQk+jw7W5oSDm7JDVD8ZA+9HfxVVDO4f8wgA
	OcAMA==
X-ME-Sender: <xms:FTFOalKhKgQKzjwTORA8yRywQUBZpkUefoLUHTaOWGI-335Atbc34A>
    <xme:FTFOalGj2LQwOwjVCnVMJwM6krkIH4o0G_TZcJhsCsIDw2s_665KCtH07WgOsBDfh
    Lu8NAvVLSzCMvK37-IF9aMW0WATToK-z3TUz-SMVMGGFAwvhKU1TXnZ>
X-ME-Received: <xmr:FTFOamOPYbiHFQBVVkUCRSVoWj07junKbvgluAQKX6wxsr3lEc55QD9ATopXHQ>
X-ME-Proxy-Cause: dmFkZTFrgK+JlrVaprEdMCCT9jL+WeqlR41PWLlswNzN7Q+R9eHi8slIfq82AsY5fCzbDR
    FF2c6/38vqfy5yn0mfN1Q1IuR0w/6jjhcBlbbYbwVeHRfHyttYIq8Oj6v9pP51nLVeKVF5
    08J2hQde+dVWeXYQH682oaYmn32K1d4rnz4RgIn1j8hjtXUL5IxvtXbrp9YKRUv370bN2m
    UN+Zd+JxmqGqLZtvxlNtOAXgPcUE/BQPZ7oqAykND9BbS/e5r3R+8nAwQL3YfeXzdQzT7u
    8EidJ7yOHxiJJbRHrAGeZIH1+iybwcJ1viiDHX7PYKqYv0VVB7VVolJezAJqTlXxgJaxRM
    3ThiLxApzLqbqqYrfIhpjK6gEBmC/k4qXCx8v2AGxu/dBZDG4cm2k7SSljLRv/d06xaQkH
    O6HdyEwpDT9bpMasaSEfONz8qeJLMIDgQv24qrEIiTFLtNOTXdmJu8iDJSRFYRp4bR3F0o
    A1+ylmxjF3E0/9b50RHOsOcqEL4hsWe6wUc9GznweCniRfcxVGWKU9JUA0uEqpMcCxuzX+
    N9/zNLSpu1SPpvZW4SHUhLfktWRpl8uMd45JV+TwzbkPvSxxok3m1sQVDvcoK/XiIyDau+
    YVhqKRxOA47Dnjlwn325FlfP0Q/eCX/PrmaYv5lFO3x9VU/CwSalbmZ2yeqg
X-ME-Proxy: <xmx:FTFOav8PfaPEYAHn8foyMsSx1HJbseg2ZNyzCkDRj5RhBztw6uGnLQ>
    <xmx:FTFOaj48e6h-zeuQyHOBe4MCNs8fln4wwSjCGuyOZ7vYpBK3uKkFcg>
    <xmx:FTFOakVsCcEZ0isz4qL1K_BXu-2kpPkNEP5AJnhcA9NQag_1W4zJMw>
    <xmx:FTFOapI91p2uHJ-k-g87Wd5mnCmw1-XoqXmgEEEF2VJ6w9Qx5pA1gg>
    <xmx:FTFOauLmcFJYYgUuCFXJvSYB0vpUQ1UQJ28c_SA8CX1I3xtN_c1Db7kp>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 8 Jul 2026 07:14:29 -0400 (EDT)
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
Subject: [PATCH v10 04/15] userfaultfd: test uffd VMA flags through the vma_flags_t API
Date: Wed,  8 Jul 2026 12:14:05 +0100
Message-ID: <20260708111417.173443-5-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260708111417.173443-1-kirill@shutemov.name>
References: <20260708111417.173443-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sfu8u8ibhj3xeetcekio9eo7dg9i7mkq
X-Rspamd-Queue-Id: 2202E180004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783509270-725456
X-HE-Meta: U2FsdGVkX1/v6yANRdDzDy5uztx+blqpZvRyKFcnpXqAYOFrcz3f/eUaIfu+SjFuTbOACw5oJBc5r6WgjdxdVMkteOJh/nj2AsxfHPnN10jjQexcLftOlihqIM1yRoPDPNPq5T/yb/1tI8LvZt4L0J0Z5P+D94rVzJ631e96jIe5hwsSO/R8WQPVk+MUifKo4QNjkbz5ZgWQWFUqIricX15Bf85Z2x2CuJ/fyiybi6k2zCOWyNAzyQNs/lNyfuu08+7xyqT2HRos7GJ/I0jNVcdxi39VRYPbbhKm4opXAjfe1lBhOnGtxAw3jBz1wwJRUxhmKOuppzSW6h7uUVlCTajKbgZWOFzm6oO96CdbJHmq2NbGdt8fxEPX5XIwotztcdq6vl+v8ygBE3vpfU5m9Sny/HIe480CtMPNx4dcXU+aYOlfTRaxyhJs4WVyacZRtZnlj47FaqFDvnyXkWkhSD6UQi+NNQU9N7i2C00cfpDpFNl3mlyi+pfO6GXkspeY8IUytuQaoC1j8352lkpE/vrUU3T0UIJA9Dq3Rl7jNMpl/j+mhn02rFoU5qpvgINaGW83FCu/PabwUOOEbolrBv9ss1KwYtOUxdv9N5uwzlEoDKzs8cQGRqP9RK45jFAoB8NNk/MPKlfCUaDHEx2MGcE+tj99vi4eDzsEX1sL3MZkD1tKdsmMOqb/c1jsW2rf8xdTJQxKz0aPkKtcX79DwjdG09AkPuY91mIEy77hd6g7lwc7gNCqhCQm6sp6uJ6aRWG8XUptFMqJjD+upnP6kV5XJIU+ZcP0BfsuPjSIrBzTJYpGz4rVZeMbFIDcQCfcl8pBhcTMdUGrkypH6mYto8A+Uf0GsrDHNaCErwpcgz3ReRl+EvoZrSPXyYfAaJXxQlLupgho8c/qP8L6azbXlODmO4DYM0njxJvqZ5io0caakjvK5e+bcPwIDSM40EGj9/BMpKPSJNGOLj2XOBq
 yhqwkUoy
 kvQuGlmnsUK0R7X1kqZotnT+YH+73V2KIGH9GzNbcKEp7Rgo8NAE15/PHnwdh3UiPChYFWc2nBw94OyINZtEOkirTuR0nfqqafKKit8bj9ceyfRgkpX9bxlTKYbBBq73FTpXgK44GqD6V5B0tY0sxlWKd25gF/3zCKkTHKPuan62ZfEyR4xYOvzjZh9m/g4fI/DlT00Kp4OuJ8OL8KhSZE2dd/uOs+DfeG09vkdwZmpnhfU9QLMD1TBB3K2LQ4Xjlb46ufALO1UNSlNZByRH/Dfvtvf/vx8p9YbGAiDyYJiS3/J8nmsLtRFjwbsEbE2vT/uiy30h9PwzLipgLJU8/A/rs/EFIZdBH3iO0LhgrakmJL3Vh6/sx2ctG8wu7+WknHZSulBRcpWb8VJNQVZB3YiPxlBWgS3MNk5ZyFuFuivZOWI87mVNkaOh/TcoSEj7m5Rx2ogPBE3uo7cM1bGS95A6s5s1lMi8O5nlZJTWfvFV9jrViwFAbUZTpjJGoi6W8Lb+L7InfWa9DKMm7XPYbzwpNuuHh6CElS37Ego2PWVR4IAzOeBCbsx8Tirugtt9O4YbfegHjbXjlqke2mjbrjtoedvtvA8Bm3Imk
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


