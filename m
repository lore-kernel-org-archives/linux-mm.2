Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D91F3CD5BD0
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 13:05:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B4176B00D0; Tue, 26 May 2026 09:05:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48C586B00D1; Tue, 26 May 2026 09:05:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32B6B6B00D2; Tue, 26 May 2026 09:05:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 23DFA6B00D0
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:05:51 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E39A0A03D1
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:05:50 +0000 (UTC)
X-FDA: 84809593260.15.3E23972
Received: from fhigh-c5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	by imf17.hostedemail.com (Postfix) with ESMTP id DC5DE40014
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:05:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=noa0c8Mu;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="T C5fe7W";
	spf=pass (imf17.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779800748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1V28tiHbdQZRMQ0FP+jJ6/BxhOD+MMN4HsGSl4XnVFI=;
	b=PkR1x/3TeKPFjYWwtfdwHEp3gzmkcIwDgmFmW8jdmjtWJdWlzs8DWZYeRY55TzXr640JvL
	YwzvQP6OXJlyRCWcYlphb0G7wo6ppc5Anjm126AgdQv32GOCB7dgGiagEtjEWfdLJBzzvy
	yOAadUEUAmp75IY4Y4/ib6g46wAbxnA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=noa0c8Mu;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="T C5fe7W";
	spf=pass (imf17.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779800748; a=rsa-sha256;
	cv=none;
	b=vUBCfAf4q1IUa9Env+9Bi9LyT7N21v12R2/l+odppkCSm17KqiUmGKP5KFDs/Hy5CIcXkN
	+vwhcWVjE2EZMkzcc/kQJEjzmmA3YkCNCIfFC9RyQokHRTjWxfIPIbY7CZt4JLW+v+Ldps
	OmpgJSNh2z+2RqqXDEYXUwctCXWv4sU=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 8CE487A0084;
	Tue, 26 May 2026 09:05:47 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Tue, 26 May 2026 09:05:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm2;
	 t=1779800747; x=1779887147; bh=1V28tiHbdQZRMQ0FP+jJ6/BxhOD+MMN4
	HsGSl4XnVFI=; b=noa0c8Muk2ynP86tmjaF/SEF5jlhafsg+IQ51lc+WZm8vU4s
	uMf5JxI633Dy+YniEkD9zjjGXc8OyzYwjrU8y48gapBfWwtaF2iKOiotIq0gbx7S
	lxLAD3MO9RVCWv/ef0rLA2AG+HECy5zQhUL6W70AOCbB7bckfkp4xz4VmU2L9sxM
	DF1YjxZZqgM0JGRhUGaUTOK8Tjn+VLZH7NSkp0rC9iIoMuTd+V5v6hv3RvDDg9Sb
	O8z3mht26pyhzLPwTwkyrSWutG8UvtC9kCH3YTGSooNJWRgU9w14JRZfdPdYc1wz
	gJU7mxxe01kkrp4rqNkGN5niVRo2TCa9NMjAuQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1779800747; x=
	1779887147; bh=1V28tiHbdQZRMQ0FP+jJ6/BxhOD+MMN4HsGSl4XnVFI=; b=T
	C5fe7WcjMuIYwccTSfz704Kp/a7YuOPKZw6x7oXIZH5+gsNeQEzNiH36W86HwS9I
	dHBy7pGIW8KdTqibmqFgCuG8PiyereQi1EXKr4wojp4Dy9GGymQEFNXQZqi9PdvU
	o35ZCf/A6g+yXx3R1O0nXNDWEHPjaruZamuRklmdRQCap8699dw6CQnoU6uPH75N
	21MdBN1ercuJA8aH8FL8kqDVBV5oSghfEf77jcIQq/WWLNyklnmtkC/O/VPcxPc0
	oTrl2THIUF8NUpJPWRL2DMWmWXQdSsMRFT+uRW7WrvNZibn0qkDbc604vN+lmlMl
	dty+s9x5Zh9+yozpCeIRA==
X-ME-Sender: <xms:q5oVau8Wq0a0CmWW5I1G8QTepfMxVeFXlGOCSYRbCRUZatB7Ea04KA>
    <xme:q5oVairF8QHWFzZ2h0PNgZfdOO8PMTUIWAtbQy1Q_lt9aMu4XoBaXpLHz0RTyoBxx
    9feUtCd50BTVdixakjsYOfNffQtGN107iTYqwSRQL-GbQADtegLCcY>
X-ME-Received: <xmr:q5oVasjuiYLrMAC2ERmY8l80IN-lGRJ4WKyJpYmMIFzQTVurOGJ_vYMDkhEIgQ>
X-ME-Proxy-Cause: dmFkZTFRxKInQFecwZPuEt+LuNBlOJGP8RsxGpm588gQviVhNq1Pa+AqWD7JQeVUR2Swte
    eyzLZOEYFGJPBoftF7cmhN7hkCk3wRua/o4v8Bw72KaC1CFplNf1sAsIMRN76GRZVrrXJo
    4g3If4FQDoPgtrZ9saDLAexzQgvrfsTwQ3/KP0AGKCFmLiVvQMOmXCsts9ZOCGk1E95eOU
    mgzRkXibxyISOqgf2hZqBdgrV6ktnG5u3x8/zXY22S6cQZP9xSB0eE/pqpJrpVnOId2p4l
    G0binpu+ah/FFZH0esjGo/wTdPAqY9SKUVzl+zWcrHaZzSyBzEWlNRkrUo/n9HkffJzpVB
    tAXTyvFcGJ4L+WqhautPziTC+ot800EDoZJbryAf3DXYgwcjBJwcEUaPS9IlisE5rDyaeP
    2xnQ1aNKHrCfEz/y/t7ppZXR+kp7a3bd3dRZbeeynQkzsx2Z+tXuaRc/yrxOppSCJK9yO2
    tT2GNtMSSDJasr0JASxzy0b96TMuFUk06SmZwOnPhgeNNy+xy2G8pOKs0UUeabrWtvLHNS
    n5MXArGj3C0PDXWsCrayZxwUm3ECrUTXD1xCEH4qjhMa+Z7CWol0k1dxzdbC9NUieQXnfK
    0JsXtu6F8klDC6fmPWosNL6f/JzM8PF5J9z1IdV4RbazBitWRGHwbNK9A3ow
X-ME-Proxy: <xmx:q5oVagBsfoOFxfKTF-yhIW9TsEF97Vb0G_wRB6rEpS8S7mUwKU-n_A>
    <xmx:q5oVaqtOpPC-_kkFYheGP6vDCVjzmMPKA0p-7bYpArOzIcJJ3SfrLw>
    <xmx:q5oVaq4ykOPNG2LjyU7wN9Z8xaTSjkGtUNqeP11vd-AsP5KBNAB1yQ>
    <xmx:q5oVakcOR16RjOAtjVfbTsag-vhYIYiJGV6CaDqq2tBx1PxRgaDCFw>
    <xmx:q5oVapduAf0Df-M4p8TyofLuiq5Jog9WAsLoKjqse5zLlwI4u8W2vf5D>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 May 2026 09:05:46 -0400 (EDT)
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
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH v5 11/18] mm: handle VM_UFFD_RWP in khugepaged, rmap, and GUP
Date: Tue, 26 May 2026 14:04:59 +0100
Message-ID: <20260526130509.2748441-12-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260526130509.2748441-1-kirill@shutemov.name>
References: <20260526130509.2748441-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: p55tbhw6h1kpxhku7r3o5fe16yu57415
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DC5DE40014
X-HE-Tag: 1779800748-676936
X-HE-Meta: U2FsdGVkX18qOwwLya5w63eS7u2i/8nu0wBvIpq1iQzSAployfWecH9D6v3Ue+2dnY2uxIEU06ZaOsw3C1mFOBcN7kdFpWrJtBT333N0V1qIvlw/ikryxY/KeXjVi5eORqB0YcSY5gFDOzvjo4PSOIsQUJ1Yy4fQmqFmf4O63JC3fT+eW4gqyCIiI/sb0fd4gaYHFvcfgp0GtkjEuW7zk8+2yvB2dMtc9LEVpVHUWb/u9t4DgkP6WcsxYw9H4ZSrwvP4SC/CK1E2oRR5UMRPYH1E/vDiHGSPgdw58LUyp06Yj/z5uX8ilegrE/1D31x+pDw2EEm/pjexeNfNPThuGdVkphsVqf+xxn3lOGjpTAR9dVs3H+1lUoh+pwl/51umxyia0RbEqowaRKx1TLl3Y+kyu3ctDQVbOF3XnL8JQ5weWSkFpdBHj14x66pgzcJe8SEl8TlBXC0I9wV+kEAM4wyktmNvqOdXUCtSvn915Rm7beaya3C3+VlNwC97QgFOqObgJPI7F6Qa/9edAbQJr8kJ1h2kHBVIhNKCrTqXejFfOOBQ9XyK8/nAbMyfcFmJ5plOh2iFAgJOCIbAlIbDd0+/uK+KsaYflbuAeocs7FZPD+nCEmFb9s7t7NBSKXsiZjil+IDFIkieTJwihIOm6GG+Gwrxmvn3U0EGGsYIsKpDNdCjfaodpKydce1GcywiROouTe63ldfkwOxSKCHTJkCRMno2edoBNDPF1rHrShb31wP5yCqNHwKeDcN+0+cKeus8sJfm1KwB/iYcNmq8bObmvpVEKowBWyliFY9avKoi9kRCqkPA5isV9Q5vGsktS7VaYSn6Lm+j1/ks+I4/6GSa/QHR2zi2HPg6dsNdMXXy7qnsndL1RWCZAfDPqh78S4S8weSx8l7N5fTAFhPke9w0Kuh2J1GeVOFGZlXoPRaUH+i4c685ncXmJtHFQvL/5i07kXYNwP8k9AMxJi0
 Z2y2H9X3
 w2RIb5cpVZhjePMsN01lfG64oGAG+3ZAbFW5RJaHtowp8NLMpSrE1CxjWmyKlKNDSaKSuoWxoYwN6Rcykz+HT+VQTRLQI7A9uQvLa3afh4YNuVpM43szIszgimWNXr4zEOuH1PW5bA/uTR8XMQrLZJlJUzt6Vh51SK7afi2Oh4QLq7Kd2lNvaJ9Z90Traz7QT9zi+CQl3dsdewp180ziTDK7W944IZ328qawHGfA1W68cfQjtwty1FSDIij72jBUh9zLQx8Zo2OVcn+1lgR1wUtr0hKZf1+HMzZ7dZ8TWBoqE9fR9E9ssMpI1KxpN7hShI1JPK8isney3dLNn73g6Agp243dv4x544W836iudhtpJjXNZXVYwGa4c0NpVO+JwYcuNaYzBbLirldENUvdiOKnU9jsyVmx7wyN/tSE7OdaZkMDWhrO0MXSrtag4CqXhu/r4VZ+YFNMrTTlTYMcGzUfmIELMMSEOhHbwbrNlVORGoKCWYVvA8N3u91QcO4FQRBtThp7x0bAU56+xjdNdmrNHcMRhmjZSVaCv9GIBvtkWK4moSYFlQYmKzXXWygmAAewaak5O/cA7Qrl/qNp+TCqnMwTbKoBfmliTx5OCOnYQYm98B80g0w/SD33PDkDBO/i0d0TgjYZIpFvcG854hl/aEh8sgnokWL4pxJPwAIPCdFpA4AUvX4ylnsrj8ej9dhzkAZSNWTd3GAsRTVeCeoyylm6VV2c526rhmkgyztv/PjU6OQK0gEfSWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Three mm paths outside the fault handler gate on the uffd PTE bit
today: khugepaged (skip collapse on ranges carrying markers), rmap
(cap unmap batching), and GUP (force a fault through
gup_can_follow_protnone). Extend each to treat VM_UFFD_RWP the same
as VM_UFFD_WP; otherwise per-PTE RWP state is silently destroyed or
bypassed.

khugepaged: try_collapse_pte_mapped_thp() and
file_backed_vma_is_retractable() already refuse to collapse or
retract page tables on ranges carrying the uffd PTE bit. Broaden the
VMA predicate from userfaultfd_wp() to userfaultfd_protected() so
VM_UFFD_RWP ranges get the same protection. hpage_collapse_scan_pmd()
needs no change — its existing pte_uffd() check already catches an
RWP PTE because it carries the uffd bit.

rmap: folio_unmap_pte_batch() caps batching at 1 for VM_UFFD_RWP so
the restore path handles each PTE with its own marker.

GUP: gup_can_follow_protnone() forces a fault on VM_UFFD_RWP VMAs
regardless of FOLL_HONOR_NUMA_FAULT. RWP uses protnone as an
access-tracking marker, not for NUMA hinting, so any GUP — read or
write — must go through the userfaultfd fault path.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/mm.h | 10 +++++++++-
 mm/khugepaged.c    | 18 +++++++++++-------
 mm/rmap.c          |  2 +-
 3 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 9e62946af654..87db714e1364 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4611,11 +4611,19 @@ static inline int vm_fault_to_errno(vm_fault_t vm_fault, int foll_flags)
 
 /*
  * Indicates whether GUP can follow a PROT_NONE mapped page, or whether
- * a (NUMA hinting) fault is required.
+ * a (NUMA hinting or userfaultfd RWP) fault is required.
  */
 static inline bool gup_can_follow_protnone(const struct vm_area_struct *vma,
 					   unsigned int flags)
 {
+	/*
+	 * VM_UFFD_RWP uses protnone as an access-tracking marker, not for
+	 * NUMA hinting. GUP must always take a fault so the access is
+	 * delivered to userfaultfd, regardless of FOLL_HONOR_NUMA_FAULT.
+	 */
+	if (vma->vm_flags & VM_UFFD_RWP)
+		return false;
+
 	/*
 	 * If callers don't want to honor NUMA hinting faults, no need to
 	 * determine if we would actually have to trigger a NUMA hinting fault.
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index afa218be15de..4f3fedcd75cf 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1895,8 +1895,11 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
 	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
 		return SCAN_VMA_CHECK;
 
-	/* Keep pmd pgtable for uffd-wp; see comment in retract_page_tables() */
-	if (userfaultfd_wp(vma))
+	/*
+	 * Keep pmd pgtable while the uffd bit is in use; see comment in
+	 * retract_page_tables().
+	 */
+	if (userfaultfd_protected(vma))
 		return SCAN_PTE_UFFD;
 
 	folio = filemap_lock_folio(vma->vm_file->f_mapping,
@@ -2109,13 +2112,14 @@ static bool file_backed_vma_is_retractable(struct vm_area_struct *vma)
 		return false;
 
 	/*
-	 * When a vma is registered with uffd-wp, we cannot recycle
+	 * When a vma is registered with uffd-wp or RWP, we cannot recycle
 	 * the page table because there may be pte markers installed.
-	 * Other vmas can still have the same file mapped hugely, but
-	 * skip this one: it will always be mapped in small page size
-	 * for uffd-wp registered ranges.
+	 * VM_UFFD_RWP ranges similarly rely on per-PTE uffd state
+	 * and cannot be recycled to a shared PMD. Other vmas can still
+	 * have the same file mapped hugely, but skip this one: it will
+	 * always be mapped in small page size for these registrations.
 	 */
-	if (userfaultfd_wp(vma))
+	if (userfaultfd_protected(vma))
 		return false;
 
 	/*
diff --git a/mm/rmap.c b/mm/rmap.c
index 546bc1cf9391..9fb733489898 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1965,7 +1965,7 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
 	if (pte_unused(pte))
 		return 1;
 
-	if (userfaultfd_wp(vma))
+	if (userfaultfd_protected(vma))
 		return 1;
 
 	/*
-- 
2.54.0


