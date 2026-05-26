Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF74ACD5BD0
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 13:06:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF4D56B0098; Tue, 26 May 2026 09:06:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA60D6B0099; Tue, 26 May 2026 09:06:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9200F6B009B; Tue, 26 May 2026 09:06:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7E48B6B0098
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:06:01 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 29D9140403
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:06:01 +0000 (UTC)
X-FDA: 84809593722.24.745535E
Received: from fout-c3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3390520007
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:05:59 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=Pj5lWzCu;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="Q XRbsLn";
	spf=pass (imf31.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779800759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PX7WVh3vuRh+AWp3LK4dcDvLj/dnD9e3A7FTfSbgriA=;
	b=7mCZ9wT/QV4MvOT9BxVit4hYbLIinXDzjxE2fhazaXLsg7YvU4cqRD646h5XYE/FJz2Ap9
	l8BZtN3qzbzQC8Fe0mJ67TyPUi56pHMz7Q2S9fboG4+OU9ZnrV7MMyVqU/CTckiOTHXPxT
	FT/4qqNEzah+8iq9g1MhE3/eLPgPXh4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=Pj5lWzCu;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="Q XRbsLn";
	spf=pass (imf31.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779800759; a=rsa-sha256;
	cv=none;
	b=yWyPQth+UIJCStxFiJ5/WNeRyICZIYQCBIWYnEBwOTG41A6NvfyXC5kVYDFgXeglpohpsr
	jjU4xvSoEwr46iG4+NfK+P9g7K5Jjy8DBThK1S7PQSMFOm3pwDwslvYOnMG/Px3/J4mXKZ
	6CFY61l2X7IwE4W1LmnZXeLj8zx39Hc=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id 125D71D00136;
	Tue, 26 May 2026 09:05:58 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Tue, 26 May 2026 09:05:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm2;
	 t=1779800757; x=1779887157; bh=PX7WVh3vuRh+AWp3LK4dcDvLj/dnD9e3
	A7FTfSbgriA=; b=Pj5lWzCue8Q8I4gSNZUws3uuEoltzDPmchbsGtHhWMBA2CHn
	Gq63JIIzUI3DIkU44mTmrQJmQ0pj+GFyH+b/Zg1N0qAY5EoIlE7p6WzmGFLdOZFS
	YxXHdO5Y2q5SjtQTX21L5Ac0K6dYZIXt+9RsDiYt2Gm0iDG5K8TcFPdpwpoCQnVG
	Dc6JhD5NzxU7/MqsE7aDo6eYV8cuy2JYsbMYM4puHjakgx3clYG+EyUHNE6VjS4K
	oaltnFd6Xy/b6wn1hFGhu5exrowndMhxAhgYwTGaJV2IAn1Uzc4AeX/wdB3/x0L+
	E0755kfdcmP5yR0ExbLVWTx5HcCaYTSN87HJhA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1779800757; x=
	1779887157; bh=PX7WVh3vuRh+AWp3LK4dcDvLj/dnD9e3A7FTfSbgriA=; b=Q
	XRbsLnlb66uL1qv+t9az7DSjL14e+4qFSDIzEyRmgbGf/XSrVkJ/WlrSg391Idhi
	DEu0FkdAzcM454QVho6NFc7gEmpPsOpQLkV1677XH9B0qY3nngc9rnHAQ/jebENg
	K6fh1mwAh/YqNxeKFDECsl4owTML4VguW84dRAlzZnUDYOMprldePgQ9WfNEMGg4
	gRpaL5GIdrsW86GLQGHbsun3TWSyEXdGDiOqZ9wSxSd7Q3uEoO4N16LAa/1nP6Ys
	St0SO4cDuFKf9cfylwscr8X2swCGz8JpoJJTEeVEoS3RJ81IxBvPTXbq7gPOSLX/
	oD185uKnQU4aQ6XK0hllg==
X-ME-Sender: <xms:tZoVateHBeA_Dnn8YTGcJ00sybZMaoNvUwsFpPoMcGo5g0Bz-nojRg>
    <xme:tZoVavJHxNT_kJCIDmJDS63mUSQXFl4Rzrh_f_7RnFtOEt-PxfpD9BiZQV9Ns6Q2I
    nHgOVP-iGaSrp2HhkLWtbfDQOeiQ9T9KjyIsR_0qHAprZWb8BuE-7e2>
X-ME-Received: <xmr:tZoVavBNC2g72bJmrWRofuinNHa34raE8Ozo8GeqjaPpok7RrwDn_VXVMqgkQg>
X-ME-Proxy-Cause: dmFkZTFRxKInQFecwZPuEt+LuNBlOJGP8RsxGpm588gQviVhNq1Pa+AqWD7JQeVUR2Swte
    eyzLZOEYFGJPBoftF7cmhN7hkCk3wRua/o4v8Bw72KaC1CFplNf1sAsIMRN76GRZVrrXJo
    4g3If4FQDoPgtrZ9saDLAexzQgvrfsTwQ3/KP0AGKCFmLiVvQMOmXCsts9ZOCGk1E95eOU
    mgzRkXibxyISOqgf2hZqBdgrV6ktnG5u3x8/zXY22S6cQZP9xSB0eE/pqpJrpVnOId2p4l
    G0binpu+ah/FFZH0esjGo/wTdPAqY9SKUVzl+zWcrHaZzSyBzEWlNRkrUo/n9HkffJzpIG
    YNd96Qkbq/e1nWeI9VaXxlgB6bhigF2yF9kzoOWWlkbPaWEfZgm9ZlbVFTye1qLkpHcjku
    Iaz8PgLGUHYvM/ync2TXfGgwLkD6Vz5TZO6pdeXMBTFDj3tOs7FT0dO3o4taXMCZwG8J1q
    8DhkwncpnIntNd6tei3BLHi69PfftgA8eOctrYKfllNQgHdVxpSG6lOkga+WwCKwOsRuZt
    e7C3UM1H7m50VgshlO21HEXHe8MXOntZkRuVTS3U0qT8joOsFHgDYmxr+HnD62HyL5BgHH
    ESVpY1z4Mo5iBeMXEk03q9wHa91ACKa+7sQXLltbUnBuUffFpzCIUErPhXCA
X-ME-Proxy: <xmx:tZoVagjg8d8aSSu54Boddqv86H1HA2ePDmmZtaKssrj8iv97OGo3-A>
    <xmx:tZoVahPma-8MUs_kJ_rkXvGgA7MkScMEFy78lHXxXPXMIWEow6RQww>
    <xmx:tZoVavYZc3Q-Pl-z5U3MT0JoGQZ8rJF2for2wv14B2ShEc_Yi5smzA>
    <xmx:tZoVau83DpGAyVvab5sxO3_lyLROhdmQqCsh2N9wjp02EJrmWbfaXg>
    <xmx:tZoVaj9Qkt4QpilgwYlcQB_Za-TxVt0zV3pfHfUsEzAhE00iiSZhMcHT>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 May 2026 09:05:57 -0400 (EDT)
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
Subject: [PATCH v5 15/18] userfaultfd: add UFFD_FEATURE_RWP_ASYNC for async fault resolution
Date: Tue, 26 May 2026 14:05:03 +0100
Message-ID: <20260526130509.2748441-16-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260526130509.2748441-1-kirill@shutemov.name>
References: <20260526130509.2748441-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3390520007
X-Stat-Signature: 8sdrs84seea7phet4a5ma1mqbcya191f
X-HE-Tag: 1779800759-644428
X-HE-Meta: U2FsdGVkX1+y+rYfrE211xEht7l9Lxau2xouEyyE5NoCJsY4+2gk0PFodBX9hpO/aqEK62Z3Z4fDip6HibX3+04mqalnOxIAJaMe3ofAIhcAWgL0hfbIJuxmW87uk1Wp4R2xQzwL7UY9+sNn2uEDxIR/vW3CHCaVlDgcMKidzYHihb6HFI7taSZI5MccCsz9yvuuuOiQNEW30IApGDsnYP1jC/0iI6eZ5vG/cX5XT5Q59+NePPyFnaEDRivzLMuEd7BjVEWWGQUZ7hh3Kjxf1mcsg4KxD5oS197BSfQPGtw0T21AbMu0QdetUcxNAQyPK7UgcFmDBlC/dY+ZcqVRdYj1S7stqozU/8ZsRm277bzQc6YubU5V3qMnLyV/HGN5L8hs3Rgdb3r1FOfeZvRt2wexn6wVl1mzDwQ8QiCw20ZULXdqNyOGwcRe5InipsS4tbTKS/jGEGktUEJNWhOnmhZ635huE9503ricguaYb95Y9C9EGGnpANnAnGiLbdbwaabLencOJ1hUvSzg8sPAx0ZrEnxh5x+2z1fHU0ujv+VRkITrUHBALjetmSL5zNndKU6CPFe4o/0OrHh/qF6vmlcDlfgHIazKqgLSjj2PUHp0u/CN+85KGDxIvxpUoIchAfqv2BZE2wAgRlgZAYuXfO43DIGfAAQ3vSwjQ8rB1do+MOUpkod33hID0dnpifE1e9v5L5rboavLXJEDKsJsWDKheYCnxp9hDz0VhYHtgQe16BjsZdpUfDK1byrihQnvDxCfjRegm5atvUjxeEwnhvqz5pJe5+Oc3eH1TEfC9NRTsP2hvUTdkwcLefZbT1HMWey+gzBXB9rbYqF39F/IHR5iWkf38mlobf5qlng/Sv1Tcp7524FvPiBbmDg1oc9ZEhgFi8/X3UXZIVO+zNlGmDyY2G6UXGP+ByPdGdueIlLCWqOqIugB9cDL96twVHQz/c5XxF2s0swSHRVmvUj
 FonKaYsL
 JGfNz28RZPjI40gNtdO0I7VotlSSDnKZ1RZtbcdsx9s9XyoIvkVYT9GQlZfC8RksZEUeeWiou2W60+sS+A4UYBXcaCidgh3U6JMG/tbETM+IGMZ3/jD7+8lkht3qOG1z7jsvcC0Xwjvwx46F4Da7tDj9RFH24/huq4t430BjQTKtTn3MccIeerq0tu3z3IokOdg9WYh6kAr0UBSMT6aOFwmyMEER3EsSImEb3cN6T2MsOeHxZ0hTFpAocc6kS8ZP2BcMOqcH15qxI7gj02eoH1/aWJvVPiLAujUjEoS+stJyunIbrHVlsheYNvYY0MT9aalpz0AhzP8LMJNOP2ZMJsdD8kSBtQQ5IsH0XXhaN0iEB9EmP9NwaDJ2qaFrn5mk+Xi0xImviihGl6y2dFn50zm+qJxJegjMWcMSsdE7rO+SdmFGmI6ZH2OvxiMSgHokcZnWVVyE5HC601C0dzhdSpa+rz2/MxAEPzcLTlkJx/3Eykkrw0doQPqSMO70D1VB5MZEdOOKgQ3/d3ICpXtmxcvYKIycpuDzOmIWSjZXxJuLHDJEFGnTeL8GH5a4BW1iZQBieD1qsGftJIvjGytlctT4cMuDs3mIoZQQcrHaxINWfatDjxQy2yCyCv1uO7AX/iAM8X+EKVMpmH9a8+15bmO9oxiX0lpKHwnOVyJctjQff0wltq219iMFHPzIrLWJigq2L1YPjbp9XR+i2n+NtflwWPHWQcDbCOThoBLUMLRPSVAU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Sync RWP delivers a message and blocks the faulting thread until the
handler resolves the fault. For working-set tracking the VMM does not
need the message: it just needs to know, at scan time, which pages
were touched. Async RWP serves that use case — the kernel restores
access in-place and the faulting thread continues without blocking.

The VMM reconstructs the access pattern after the fact via
PAGEMAP_SCAN: pages whose uffd bit is still set (inverted
PAGE_IS_ACCESSED) were not re-accessed since the last RWP cycle.

Worth calling out: async resolution upgrades writable private anon
PTEs via pte_mkwrite() when can_change_pte_writable() allows, mirroring
do_numa_page(). Without it, every re-access of an RWP'd writable page
would COW-fault a second time.

UFFD_FEATURE_RWP_ASYNC requires UFFD_FEATURE_RWP.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/userfaultfd_k.h    |  6 ++++++
 include/uapi/linux/userfaultfd.h | 11 ++++++++++-
 mm/huge_memory.c                 | 25 ++++++++++++++++++++++++-
 mm/hugetlb.c                     | 32 +++++++++++++++++++++++++++++++-
 mm/memory.c                      | 27 +++++++++++++++++++++++++--
 mm/userfaultfd.c                 | 19 ++++++++++++++++++-
 6 files changed, 114 insertions(+), 6 deletions(-)

diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index 332fad1560ec..87386b79049e 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -278,6 +278,7 @@ extern void userfaultfd_unmap_complete(struct mm_struct *mm,
 				       struct list_head *uf);
 extern bool userfaultfd_wp_unpopulated(struct vm_area_struct *vma);
 extern bool userfaultfd_wp_async(struct vm_area_struct *vma);
+extern bool userfaultfd_rwp_async(struct vm_area_struct *vma);
 
 static inline bool userfaultfd_wp_use_markers(struct vm_area_struct *vma)
 {
@@ -456,6 +457,11 @@ static inline bool userfaultfd_wp_async(struct vm_area_struct *vma)
 	return false;
 }
 
+static inline bool userfaultfd_rwp_async(struct vm_area_struct *vma)
+{
+	return false;
+}
+
 static inline bool vma_has_uffd_without_event_remap(struct vm_area_struct *vma)
 {
 	return false;
diff --git a/include/uapi/linux/userfaultfd.h b/include/uapi/linux/userfaultfd.h
index d803e76d47ad..c10f08f8a618 100644
--- a/include/uapi/linux/userfaultfd.h
+++ b/include/uapi/linux/userfaultfd.h
@@ -44,7 +44,8 @@
 			   UFFD_FEATURE_POISON |		\
 			   UFFD_FEATURE_WP_ASYNC |		\
 			   UFFD_FEATURE_MOVE |			\
-			   UFFD_FEATURE_RWP)
+			   UFFD_FEATURE_RWP |			\
+			   UFFD_FEATURE_RWP_ASYNC)
 #define UFFD_API_IOCTLS				\
 	((__u64)1 << _UFFDIO_REGISTER |		\
 	 (__u64)1 << _UFFDIO_UNREGISTER |	\
@@ -243,6 +244,13 @@ struct uffdio_api {
 	 * UFFDIO_REGISTER_MODE_RWP for read-write protection tracking.
 	 * Pages are made inaccessible via UFFDIO_RWPROTECT and faults
 	 * are delivered when the pages are re-accessed.
+	 *
+	 * UFFD_FEATURE_RWP_ASYNC indicates asynchronous mode for
+	 * UFFDIO_REGISTER_MODE_RWP.  When set, faults on read-write
+	 * protected pages are auto-resolved by the kernel (PTE
+	 * permissions restored immediately) without delivering a message
+	 * to the userfaultfd handler.  Use PAGEMAP_SCAN with inverted
+	 * PAGE_IS_ACCESSED to find pages that were not re-accessed.
 	 */
 #define UFFD_FEATURE_PAGEFAULT_FLAG_WP		(1<<0)
 #define UFFD_FEATURE_EVENT_FORK			(1<<1)
@@ -262,6 +270,7 @@ struct uffdio_api {
 #define UFFD_FEATURE_WP_ASYNC			(1<<15)
 #define UFFD_FEATURE_MOVE			(1<<16)
 #define UFFD_FEATURE_RWP			(1<<17)
+#define UFFD_FEATURE_RWP_ASYNC			(1<<18)
 	__u64 features;
 
 	__u64 ioctls;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 72cb44332004..8f120452d995 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2291,7 +2291,30 @@ static inline bool can_change_pmd_writable(struct vm_area_struct *vma,
 
 vm_fault_t do_huge_pmd_uffd_rwp(struct vm_fault *vmf)
 {
-	return handle_userfault(vmf, VM_UFFD_RWP);
+	struct vm_area_struct *vma = vmf->vma;
+	pmd_t pmd;
+
+	if (!userfaultfd_rwp_async(vma))
+		return handle_userfault(vmf, VM_UFFD_RWP);
+
+	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
+	if (unlikely(!pmd_same(pmdp_get(vmf->pmd), vmf->orig_pmd))) {
+		spin_unlock(vmf->ptl);
+		return 0;
+	}
+	pmd = pmd_modify(vmf->orig_pmd, vma->vm_page_prot);
+	/* pmd_modify() preserves _PAGE_UFFD; drop it on resolution */
+	pmd = pmd_clear_uffd(pmd);
+	pmd = pmd_mkyoung(pmd);
+	if (!pmd_write(pmd) &&
+	    vma_wants_manual_pte_write_upgrade(vma) &&
+	    can_change_pmd_writable(vma, vmf->address, pmd))
+		pmd = pmd_mkwrite(pmd, vma);
+	set_pmd_at(vma->vm_mm, vmf->address & HPAGE_PMD_MASK,
+		   vmf->pmd, pmd);
+	update_mmu_cache_pmd(vma, vmf->address, vmf->pmd);
+	spin_unlock(vmf->ptl);
+	return 0;
 }
 
 /* NUMA hinting page fault entry point for trans huge pmds */
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index d4da39d698b8..9da52d95b3fb 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6070,7 +6070,37 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	 */
 	if (pte_protnone(vmf.orig_pte) && vma_is_accessible(vma) &&
 	    userfaultfd_rwp(vma) && huge_pte_uffd(vmf.orig_pte)) {
-		return hugetlb_handle_userfault(&vmf, mapping, VM_UFFD_RWP);
+		spinlock_t *ptl;
+		pte_t pte;
+
+		/* Sync: drop hugetlb locks before blocking in handle_userfault() */
+		if (!userfaultfd_rwp_async(vma))
+			return hugetlb_handle_userfault(&vmf, mapping, VM_UFFD_RWP);
+
+		ptl = huge_pte_lock(h, mm, vmf.pte);
+		pte = huge_ptep_get(mm, vmf.address, vmf.pte);
+		if (pte_protnone(pte) && huge_pte_uffd(pte)) {
+			unsigned int shift = huge_page_shift(h);
+
+			pte = huge_pte_modify(pte, vma->vm_page_prot);
+			pte = arch_make_huge_pte(pte, shift, vma->vm_flags);
+			/* huge_pte_modify() preserves _PAGE_UFFD; drop it on resolution */
+			pte = huge_pte_clear_uffd(pte);
+			pte = pte_mkyoung(pte);
+			/*
+			 * Unlike do_uffd_rwp(), do not upgrade to writable
+			 * here. Hugetlb lacks a can_change_huge_pte_writable()
+			 * equivalent, so a write access will take a separate
+			 * COW fault — acceptable for the rare private hugetlb
+			 * case.
+			 */
+			set_huge_pte_at(mm, vmf.address, vmf.pte, pte,
+					huge_page_size(h));
+			update_mmu_cache(vma, vmf.address, vmf.pte);
+		}
+		spin_unlock(ptl);
+		ret = 0;
+		goto out_mutex;
 	}
 
 	/*
diff --git a/mm/memory.c b/mm/memory.c
index 111fdae14120..5f56dcc2f265 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6147,8 +6147,31 @@ static void numa_rebuild_large_mapping(struct vm_fault *vmf, struct vm_area_stru
 
 static vm_fault_t do_uffd_rwp(struct vm_fault *vmf)
 {
-	pte_unmap(vmf->pte);
-	return handle_userfault(vmf, VM_UFFD_RWP);
+	pte_t pte;
+
+	if (!userfaultfd_rwp_async(vmf->vma)) {
+		/* Sync mode: unmap PTE and deliver to userfaultfd handler */
+		pte_unmap(vmf->pte);
+		return handle_userfault(vmf, VM_UFFD_RWP);
+	}
+
+	spin_lock(vmf->ptl);
+	if (unlikely(!pte_same(ptep_get(vmf->pte), vmf->orig_pte))) {
+		pte_unmap_unlock(vmf->pte, vmf->ptl);
+		return 0;
+	}
+	pte = pte_modify(vmf->orig_pte, vmf->vma->vm_page_prot);
+	/* pte_modify() preserves _PAGE_UFFD; drop it on resolution */
+	pte = pte_clear_uffd(pte);
+	pte = pte_mkyoung(pte);
+	if (!pte_write(pte) &&
+	    vma_wants_manual_pte_write_upgrade(vmf->vma) &&
+	    can_change_pte_writable(vmf->vma, vmf->address, pte))
+		pte = pte_mkwrite(pte, vmf->vma);
+	set_pte_at(vmf->vma->vm_mm, vmf->address, vmf->pte, pte);
+	update_mmu_cache(vmf->vma, vmf->address, vmf->pte);
+	pte_unmap_unlock(vmf->pte, vmf->ptl);
+	return 0;
 }
 
 static vm_fault_t do_numa_page(struct vm_fault *vmf)
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index db3707b9d977..f40bf473a6f6 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2487,6 +2487,11 @@ static bool userfaultfd_wp_async_ctx(struct userfaultfd_ctx *ctx)
 	return ctx && (ctx->features & UFFD_FEATURE_WP_ASYNC);
 }
 
+static bool userfaultfd_rwp_async_ctx(struct userfaultfd_ctx *ctx)
+{
+	return ctx && (ctx->features & UFFD_FEATURE_RWP_ASYNC);
+}
+
 /*
  * Whether WP_UNPOPULATED is enabled on the uffd context.  It is only
  * meaningful when userfaultfd_wp()==true on the vma and when it's
@@ -4408,6 +4413,11 @@ bool userfaultfd_wp_async(struct vm_area_struct *vma)
 	return userfaultfd_wp_async_ctx(vma->vm_userfaultfd_ctx.ctx);
 }
 
+bool userfaultfd_rwp_async(struct vm_area_struct *vma)
+{
+	return userfaultfd_rwp_async_ctx(vma->vm_userfaultfd_ctx.ctx);
+}
+
 static inline unsigned int uffd_ctx_features(__u64 user_features)
 {
 	/*
@@ -4511,6 +4521,12 @@ static int userfaultfd_api(struct userfaultfd_ctx *ctx,
 	if (features & UFFD_FEATURE_WP_ASYNC)
 		features |= UFFD_FEATURE_WP_UNPOPULATED;
 
+	ret = -EINVAL;
+	/* RWP_ASYNC requires RWP */
+	if ((features & UFFD_FEATURE_RWP_ASYNC) &&
+	    !(features & UFFD_FEATURE_RWP))
+		goto err_out;
+
 	/* report all available features and ioctls to userland */
 	uffdio_api.features = UFFD_API_FEATURES;
 #ifndef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
@@ -4533,7 +4549,8 @@ static int userfaultfd_api(struct userfaultfd_ctx *ctx,
 	 * but not actually usable.
 	 */
 	if (VM_UFFD_RWP == VM_NONE || !pgtable_supports_uffd())
-		uffdio_api.features &= ~UFFD_FEATURE_RWP;
+		uffdio_api.features &=
+			~(UFFD_FEATURE_RWP | UFFD_FEATURE_RWP_ASYNC);
 
 	ret = -EINVAL;
 	if (features & ~uffdio_api.features)
-- 
2.54.0


