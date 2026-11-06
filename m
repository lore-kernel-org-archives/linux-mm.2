Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1F40606A32C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 14:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=shutemov.name header.i=@shutemov.name header.a=rsa-sha256 header.s=fm1 header.b=U1cM4ow4;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=yflA69rW
Received: by kanga.kvack.org (Postfix)
	id 0C8526B05B9; Fri,  6 Nov 2026 09:43:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 079376B05BB; Fri,  6 Nov 2026 09:43:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA9756B05BD; Fri,  6 Nov 2026 09:43:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C3E156B05B9
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:43:33 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C6011C0B7C
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:43:31 +0000 (UTC)
X-FDA: 85404962622.01.022AF92
Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	by imf09.hostedemail.com (Postfix) with ESMTP id A1B11140006
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:43:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b=U1cM4ow4;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=yflA69rW;
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793976209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=4JlsES4uLUIYYaP/yiOT2rHyGIzTwamik4bNttM7hYs=;
	b=0LsozxSuQURuz9bCRRcTQbgq5ssQArbnpdaNgl9LQk4pLD7jlPH41Zrbz2G6TnOLNDrM4+
	uf+23ACBor90gxq6sYRJ4ySFalVqRTCgbcy0YmUw+uxPyzZVIfx/oZ8hBPdUHi3X2EBPH/
	DVp49SaJJclDwIQ96KyWyqHFxH+Uv18=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b=U1cM4ow4;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=yflA69rW;
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793976209;
	b=NG7aC71phoJYf4cP2uNnoTNDw2nAEOZMw7OrvzYvI60NT2Y94kU8tXQEaFJmPO22VXJC7Q
	U97vylmnxKsernNvI9ml+2l+83quJCvrfBZlDd2p7GrRxUHU65zqnzNpz48DLbIeZRmhfW
	z1SFyeEpBxwGHTeBHBR895Bvs3H6sus=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id 0A9BBEC01D0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:43:29 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Fri, 06 Nov 2026 09:43:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm1; t=1793976208; x=1794062608; bh=4JlsES4uLU
	IYYaP/yiOT2rHyGIzTwamik4bNttM7hYs=; b=U1cM4ow4O99BMT/eebmQYjkJXf
	rhloLJOiicazLExlaBKmr9yIpUt1f9P7fbJCD+uieTEvtdxjnLcGrM6EAXcz8mEU
	OVtZgS46JzxKoSX45oFIaMFbMpgEspcYJzwz7cHzob9X2YgJMorIHGmdRkbvLRAS
	Lcyf4A27WfYmzmwB0eF1eMtVJxNy9AeA0ll5A1KGSieFZ26Hb6KR+kA7ErWy+biK
	CNGbOeKYZXILLSzdIXTIokIBI9bMYlVS7GBZ/Dt1AwMqG/i+pAOXoUgZqQLXFaYa
	c4mXFi4Al0vUjyhTTvMiCHaKLN1Pqr+qODC3z2OnLLiSaDtLInibi1k3MwCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1793976208; x=1794062608; bh=4JlsES4uLUIYYaP/yiOT2rHyGIzTwamik4b
	NttM7hYs=; b=yflA69rWK8GuffmyMc8r1ksMTIyLbmLQGCCGCrF+p8NoEdQcHuU
	uPY1pDlXoEQ1JCuvBjcyPSUt/ytfHhmpR4PjuhuFKRQF1W3BxnajNSCibOdLG4Ww
	IGo3BFEtzzwSDyB26M25me9XFEEK1yLe6oJ+tOXYETpWwdUWrZPBhaqL7Ka4ujwN
	XP2azL9qaLI8+qFl27xOcNRafnlFLct/Ops5ovUB8nBS9vYrn7QP8xQZbTajp/zW
	HZzntYNFdASRKEfEGCf5xAHJQR9lPGOiaB/h9eC/X9gZhkFQdPjG+tftGFhI8Rfu
	237vSZXjfKayxE+0R7k4SMTWcL3mnI7lHBA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=shutemov.name a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793976208; d=shutemov.name;
	mf=PGtpcmlsbEBzaHV0ZW1vdi5uYW1lPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm1:rsa-sha256:Nccs9mQfs8vayK1oYK7mbVOdkoYl9dezUp5qwb0wZQNjoMu
	lPcEapZKHVfODFhL43Y9BDrZbYElXGnI+/OorG9e+eqyJA21tBAzxNE9aNzLhDVY
	jm99heWwsCStvL36RNnHnZAaKbiszRFujA3qtJ+1s9dXDUc0iG6fnwxBQlF9DO3T
	2rexxIwwb+lxUm17U2BCiNWiBPhqlkOK4EABO/uv5jkKfjo0oX1+Ss62mHXPCfNY
	w8jntQaBuE+ZrSQ6Xfof0kaZCNy8pUiNlaFNDEG1nzTGReF0IDcgsVdVfMqnGY+y
	UMSbalWgbl/0XT1hTis79pBtJBR5zua0t4sXC+A==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:mAhdeZutzgxel4LfCIR4P0qGCtKeD7cSodqPFkRXA1A=:gcQGkw5DvWGcUvkEFyLdo943AU6EZF7qgzUb0avWdSM=;
X-ME-Sender: <xms:kOftamgWQduRzFONPFTcWIos3i3HPa-lIEPFUG1wg93apomkVlxuGQ>
    <xme:kOftandtYuCNjAq_gmRq6H-ZQhxzTOQt4QKT_UUlyW79K_88VpOEpiFNBSoFohIEj
    hZb5xEH8GaO4tYwBCJ-m9026RFYE8nplPWnFql4-u_ymcJmHn5iAOER>
X-ME-Received: <xmr:kOftat312HR9KcYnj1ohQT3PifXe-3GPCgaYzqbmPh_L5AyFWl18ledqD4Q>
X-ME-Proxy-Cause: dmFkZTEVyi++14NxNXhrhQvWfvjlAPlwXEA1wBKBvLE0AxcstoZuNgjT8CEJY3+Dpk8v4o
    3zadRI7ItJ0yvlmlUXvyighpPOjkwnnJ1aCWXF9uPXp3YsZjLZ7JHNPRPt7LBo3ZqxDQhu
    RYF61EmzuRQ5IiIBv/fonHwsAvacjt08M10KWOmuhlizcdpqtxR1hAJbku1N9QaybuWg70
    y3X4jHPSfETDmAdoEKlnQtvk8LsNFq2v+rmWQa8HQfi/z0u0UyT3A0VhsmGKVoTnMlII7u
    0HpGg4SiOpQa5vo24Ox6FgZcOb1jj0DOSDQO8pT9sMRmU4n72a+nYSLdaMGbgB7YtD3ER/
    c89GwVaOUugTIbweoqtmNrbobf7u8j0HKUO93+OtuRmfYjhmct+E5vPwVY8lUqSWY633lm
    u4APdjacP8VDb6UP9h1bH1wzNv0in2FYQLoXnNQE1GG6Mk2NURyIE8FqjrVrmYUD3wJBJs
    BsqpApVEBWHY9hKJ3xYZEdmKyBvYbdpI3XQW6IfWpixnZQIu4UbuiCavvDaHVTafeCrTRT
    nNjJWoO5ZfYk6fb7cwWPB0vKUd3icxxSwASEqLZkt33FwpSu0QtDccIXvDnYg4emEf/4XG
    60FDjuYkMhtpM1UcbbAZbqDqgrzkFvRSmz5pPylqNm1LlhkIXhthSx6aclwQ
X-ME-Proxy: <xmx:kOftaroMk1EM42H6nDaEHzD_VIFPD6wf2TkTgBC7T1hE4XktrcusYQ>
    <xmx:kOftatiRLvs1M1abJ36jKUx1x2GnhEHQpT-t_QAeqUTrl_0Xc2KBEQ>
    <xmx:kOftanmIr0Bl6pcDvQommBy8iSjyEajTFxDrLzG-xIkAjpDsNcfMXw>
    <xmx:kOftampZNxFKMugkdOp9rs0pgOWWrZj_KmNHQ4SaBeRCJeAFR96ZVg>
    <xmx:kOftar0XkI40B59ajnM3xulM6jTa4rcK44UiXxyToiYwqMGS8YtGNLL->
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 Nov 2026 09:43:28 -0500 (EST)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Hugh Dickins <hughd@google.com>,
	Chris Mason <mason@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH] mm/memory: refuse to map page cache folios that are not uptodate
Date: Fri,  6 Nov 2026 14:43:21 +0000
Message-ID: <20261106144323.3634477-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zpakumr89jqstqrqk9guawr5s5zkb41d
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: A1B11140006
X-HE-Tag: 1793976209-224927
X-HE-Meta: U2FsdGVkX1/Vb0EQdd6KCRM97SpCWu9w3VsaDIlut8ULHKRT1FiZ4KPqsT3X0nFVd22/aA/vbVRecuCsdUtUprYYiUhcQfc4vlLLbqj9xi0iSEC+DjrY40iLIgCinnZtfbXxVdJAOjfNRw8qwOTq/8siiuAEfwlc/kilB7rmESA8XN49py2lV5lgj/l5cdmC6+5JHgvVICWFo/IDDhoBXwQiCRMVDqNEiPry/YPOPzymEpwFiBhexC98I/Oy9/LdmrfuH/yqoHCrl9F7q9i7HIb6tbsgPnN0xwvhveXPIqKflbjsdEVyFDclf7JINiflcAM7MV+wHKsCb87zPHqjRI49FDIvRbkVlnrJ+65kfowIDUADNzalClQ4brGsN3G45qRFOEzQyLLG5VbeLbtb/JDDAGepmMzxGStwWR8pdxW5Fkoz+ueqI03o99eJ+uCvaOAqkP6/tneuP/0tWAtrEVz9mdjbR5zCQD3itAUqLthGtD6INDreNpFl84kD6bTuILeoORoDrEDxSq7fZ9wBH0DRow43cgoQXPhA+R/y/Z7qao6Ho7QLbgnJZXSYns/LlNv71oay80kRRg4/RBpQrrv60C/QPSxB7C8fMy+yvXPlypwW8rhj8LnI6umKSgyqU1l5QX2rdq2M/Qi9x0sxoTRV9gb7rLYdtCUQL+cMUG1J38/ifey4/uvB7QdK7xqNardvC6c0tczAPEM6JZa4ymF0bwgdQqVvh94z01l8SUlYH5wHtoMhg/Uva+2R+StkhCze4VilsQDyAJ41PKNZ+U7xDZ9CkSP3CR3v1QLTnlWuNw2ZPNcJYVyeKyj9ZilW/ZuYnR0ntZkjrI3uRk4Y1b4wIDWQFQKIjxaN0eQ9fBFDPo1O82HIAiJc484Y8em+FuaEknifCUeYI+qM/vEFoNxq5mEwQ51iUEZLuGrWU0XlPClxNKWe5GZfaTl4DjY8vFCwbXVjCiaKzJL/aEv
 SRcGaYHm
 0z94eu+i3XC55v6iYgyXm+ENn61yg7uHO360PVgC7JBc4wug+3Rz6Z0jyR8lwiJnIFYRN8tfNwCT21qWNdrjRmxr2ojq0KUNKgQBWZpfG5E9sJoWh54pyGjaqj44GXqhQqLQ3Het6WqpFkjdBpQZm7+4WSNUjIiRVCEZsORxcqJo+33G2QZ2PgHVJ2ZfUhEfjyzZQe5l3az5dt3tgOJbS3YwKkplxmRtmg8UPNNLCFAmP4wYOSA0ayycwmQpNexH/anzCAM9jwh5NVHDGa+6UHWDdVMRUxyzFnFNUQkKWWjog/Btwj+cCvdU6IsOdQW9FR0cyx7eMuhwtq+AHKuck/84ZDXJ75ClXX66uGoTaG3limuJSEeu6gUYsko/9C0B48DMhA6hmDcosIK0AFPjROfU0AMMgExWGIAfdUv+KHhFP5EKcCmPGPatqvyYOvbd41zs3KLGasY2f8nyxGiUZqqnYmmcr6P+ayxThaBkjthlTtMH0zCOfEbEOL/4ptoWhcgN++L7p11etEjM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

A page cache folio that is not uptodate holds data that was never read
in or cleared. shmem fallocate(2), for one, adds such folios and clears
them only on first use. Mapping one hands userspace whatever the memory
held before.

Each path that maps page cache checks for this itself: fault-around in
next_uptodate_folio(), a fault in filemap_fault() or shmem_get_folio().
Nothing in the mapping code does, so a caller that misses the check
leaks stale memory silently. MADV_COLLAPSE did exactly that with
fallocated shmem THPs until recently.

Warn and refuse the mapping in finish_fault() and do_set_pmd().
finish_fault() checks the folio ->fault() returned rather than the one
it maps: for CoW, do_cow_fault() copies the page cache folio and maps
the copy. do_set_pmd() covers MADV_COLLAPSE, which maps without a
fault.

The fault gets SIGBUS, as for a folio that fails to read in.
MADV_COLLAPSE fails and leaves the range to be faulted in.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/memory.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index 6fe0b7dab927..ff2f2deff761 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5674,6 +5674,22 @@ static vm_fault_t __do_fault(struct vm_fault *vmf)
 	return ret;
 }
 
+/*
+ * A page cache folio that is not uptodate holds data that was never read in
+ * or cleared, and mapping it leaks stale memory to userspace. The callers are
+ * expected to check, so treat a hit as a kernel bug and refuse the mapping.
+ */
+static bool file_folio_not_uptodate(struct folio *folio)
+{
+	if (likely(folio_test_uptodate(folio)))
+		return false;
+	/* Driver pages from ->fault() never get PG_uptodate */
+	if (folio_test_anon(folio) || !folio->mapping)
+		return false;
+	WARN_ONCE(1, "refusing to map a page cache folio that is not uptodate\n");
+	return true;
+}
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static void deposit_prealloc_pte(struct vm_fault *vmf)
 {
@@ -5714,6 +5730,9 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
 		return ret;
 	page = &folio->page;
 
+	if (file_folio_not_uptodate(folio))
+		return VM_FAULT_SIGBUS;
+
 	/*
 	 * Just backoff if any subpage of a THP is corrupted otherwise
 	 * the corrupted page may mapped by PMD silently to escape the
@@ -5849,6 +5868,16 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
 	unsigned long addr;
 	bool needs_fallback = false;
 
+	/*
+	 * Check the folio ->fault() returned. For CoW that is the source of the
+	 * copy; DAX CoW has none.
+	 */
+	if (vmf->page) {
+		folio = page_folio(vmf->page);
+		if (file_folio_not_uptodate(folio))
+			return VM_FAULT_SIGBUS;
+	}
+
 fallback:
 	addr = vmf->address;
 

base-commit: dba8aba0a9a00ff781c03d82ae534fc6f8c2e263
-- 
2.54.0


