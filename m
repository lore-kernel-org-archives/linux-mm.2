Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0455DF5A8A1
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 16:57:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 582E86B0088; Mon, 20 Apr 2026 12:57:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 533046B008C; Mon, 20 Apr 2026 12:57:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29A426B0088; Mon, 20 Apr 2026 12:57:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 07B366B008A
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:57:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AB5DB160B04
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 16:57:22 +0000 (UTC)
X-FDA: 84679539924.30.1F81824
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 90A8F18000F
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 16:57:20 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hrutyRJK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776704240;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NsYHpAy1de7pVVNqWK83+WlwMXH42Hnt5IjbIJp1VuM=;
	b=5ZcR7Nuht8G3uTdhqhpv0JislNkYtUml1w5PfMb2V0yS5Ul4r2fDZgSI2sZEJhBtBIWnI4
	RlAfrZfXu7/HqwZZTE7A9wV+ujR9coDhVFwjJOUDxWHncxUJHYARmDrh5tU4TW9+3NYO5C
	eRii2xn3OFzASUOVSShhj+YmMEa6AYU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hrutyRJK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776704240; a=rsa-sha256;
	cv=none;
	b=HhASCqyULSjTysyG0oRkOUnkNlSnh88vXTmZZ/OkkS5S3JGNBCttaBFW3c1M6p7LuksGNK
	5nBXMNuX2Tk8HunsZ5vxnQr5cVelJd7bDGKKCzcqmKjSOgiWVSuhppFM1Jb1C1SKmArJVZ
	tyB8yPH1bORj4W3R/2KM6Vhsk78G5qc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B1CF444CB;
	Mon, 20 Apr 2026 16:57:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6076AC2BCB8;
	Mon, 20 Apr 2026 16:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776704239;
	bh=w7WwPKWlE7tC0vV5+G5MIRv2zSA/nkARAEI7OpAmJ/U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=hrutyRJKsEhec8uSASXDJsTZpMceAqlVsO89RQemu51hpSAwIkbU8cSz8oZocwph7
	 mtj+IGFxl06nnVRMXjAgFEC/9JzHGZHXJl6j5BNbkuUoyu51Zn5eTnGyNQxu6jGmxm
	 DqvNo/ubcq3TEZHEuDuFQ856e+KVOqlRQsilkZnLcaEdCp4tD+EU71JfnvYLJpQg1G
	 A3cVV9KlN5A6xDBPGLyhH7TfBlH4wonOA2AVqKOT9yTqvsijaMMhjC/TBqnmAFu0K8
	 17kXEVwRv5K0z41Aug2G4YbhnYh5ANLmPLH6NCubbiPJ++bcqFvmBMxpQ241BK3oS/
	 N43MI8aciAZQA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52655F5A8A2;
	Mon, 20 Apr 2026 16:57:19 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Mon, 20 Apr 2026 22:27:10 +0530
Subject: [PATCH v11 2/5] mm/vmalloc: use physical page count for vrealloc()
 grow-in-place check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260420-vmalloc-shrink-v11-2-cad80b00853a@zohomail.in>
References: <20260420-vmalloc-shrink-v11-0-cad80b00853a@zohomail.in>
In-Reply-To: <20260420-vmalloc-shrink-v11-0-cad80b00853a@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776704237; l=1711;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=aeGg5lwRHTMk0K+2dJ+u29myWJHCj9HiY2k+TFLXFfY=;
 b=O8wYeWoimURVBA+aNcK6Q7i1GzfTIJSlkRFvb7sohqALLUPWR6yNP3UmsRe5bB2fPKrNeok9p
 J/l3hmoIKgSBiTyTUmC50uSWCEbqYGjzGM+jwR9NleBuN1TQv8Du1Uy
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 90A8F18000F
X-Stat-Signature: m64nyj3kh718ow6r6q136dmhgfo8ityj
X-Rspam-User: 
X-HE-Tag: 1776704240-890191
X-HE-Meta: U2FsdGVkX1/AtYBKKdf+SrHKG+XtuBtT2EzzjK7QhrTaf3QBOQWE9PNVvs+2x0xhZ6FIZT3FEbG3DFy1HcB4ZqT2PbQK8SgR+W12Uw6IHs6TpK17xl0KaZZD/h6wPoW0u/0X+J5EqSKECyn5duk/dnWwWOF/bKrZgKWW6awzl3vZ3TK/3Ol+TMTxU2V32RXfMfM7xHOb9jMwdyiM+zU9DPP3/k8nMV5KAmV0tO+pFtn6caUhmk6agZc0OKsvwCX5+wQt/WATe92EkKkXu257Who/W12BetGuEeIMJkfvkDO5G937ugYeXasDaTg1L0UBc6jQY/XqoajC4ugP1iM+fF9a4elIdCrCoZrq6f9VBdCwnP80AniNgJd4a596D5LBsKGtTkaKtWQaerA5FX0ZR0VOiG+oJl455mMhACQGCXLxkO7qC+Svcw4+Dv9xOGVQvndrFKxfp9e9n3llB2lNKtWQWFprZDUeZZ8Maxz465ac6CUgIlgn8pwwErc3p9xXsmv7owKOVrJZIgAEdMSo2rc7AhwFPNiLgzsUvDqGIbl2qezZZ+NvCWERnh+1kPq4rOFFtIB70s/ny1dmsgiC/3HnoLaTLeH+IZOmn4AI75O9eBG94XDuut8z1Ge3To4JwoTQG4DKPY6p9WZMORA6q9Pn1OzYADFNfAzpQP41UWiE3u29V3Kam4FsafOy1LssXk2EIzEbeU1jSoRezTCGd8yplNcMmI8pknjtaqgxqXXoDRcd/K8BSG72Y6fPXNFEMYJpZjRSTaI7zaGjaWFN62Yll1dCS2RdvVOIVZNpk/sou7jICjbZSb+7tKi4TMh4IbILmHDmHExmmYwsymbuj0/DnRRGAf/bWeZDklX7Hlx7/w+tFyQXt5BFdbwlZmLsoESWx4rvz8vnOmPD/3tVbGXXm+hGsOcgCmglsbBiTV1RWWc6u1okTyULRdi8YyouLUf2O+Vp70UulXCsM5z
 b24WdDVN
 66WpGMn1wT+A/lvFBue0DrmIE5ycvQPjPwxKBlwHrNj9+I+Qgn1kBkqqsoDFrIxGTnXo7tY1iTv+hjdPVx1b0XH1aWcdzAN8bqeejg0fld+hPTozi/UrvjqjcRTT8u3eHJAK3W6mzvL6t3/G8XBIiWA0UE8WQxPYfyDoYWykNNKNT73rVt6v4PikXn2BJhemjDh+YTH9O1evTgh1DaEr6qAAtzDOW2vwZFgurDQRzbbEUbLsHYebKtaqmvDpTZdnbMG6ddWJalca71cpCKyoWDJSnyWzn3BFggbZd7FjAfi0MAe1Whek78oK7sg269WG4Z+tPd0kFidIBC/uFnLBJ2WllkM1HUrKJ85Ntc/4Z/0K4wT0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shivam Kalra <shivamkalra98@zohomail.in>

Update the grow-in-place check in vrealloc() to compare the requested size
against the actual physical page count (vm->nr_pages) rather than the
virtual area size (alloced_size, derived from get_vm_area_size()).

Currently both values are equivalent, but the upcoming vrealloc() shrink
functionality will free pages without reducing the virtual reservation
size. After such a shrink, the old alloced_size-based comparison would
incorrectly allow a grow-in-place operation to succeed and attempt to
access freed pages. Switch to vm->nr_pages now so the check remains
correct once shrink support is added.

Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
 mm/vmalloc.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index f1be263fdc58..9e2a08c56322 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4343,6 +4343,12 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 		if (unlikely(flags & __GFP_THISNODE) && nid != NUMA_NO_NODE &&
 			     nid != page_to_nid(vmalloc_to_page(p)))
 			goto need_realloc;
+	} else {
+		/*
+		 * If p is NULL, vrealloc behaves exactly like vmalloc.
+		 * Skip the shrink and in-place grow paths.
+		 */
+		goto need_realloc;
 	}
 
 	/*
@@ -4361,7 +4367,7 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 	/*
 	 * We already have the bytes available in the allocation; use them.
 	 */
-	if (size <= alloced_size) {
+	if (size <= vm->nr_pages << PAGE_SHIFT) {
 		/*
 		 * No need to zero memory here, as unused memory will have
 		 * already been zeroed at initial allocation time or during

-- 
2.43.0



