Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6091D60A263E
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 02:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=bQmhpCK7
Received: by kanga.kvack.org (Postfix)
	id A2D5F6B05BA; Mon, 26 Oct 2026 22:56:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A05266B05BB; Mon, 26 Oct 2026 22:56:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CD8F6B05BC; Mon, 26 Oct 2026 22:56:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 39B026B05BA
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:56:50 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B6EB44091C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:56:49 +0000 (UTC)
X-FDA: 85366893738.08.112693F
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0B307120005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:56:47 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bQmhpCK7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 37hLgag0KCPEdXobgehnZaebgZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--kevinloughlin.bounces.google.com designates 209.85.161.72 as permitted sender) smtp.mailfrom=37hLgag0KCPEdXobgehnZaebgZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--kevinloughlin.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793069808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U1tHH5Mqf99jycLltqjXTRn5xKYAyrIr2aHOwRziEw8=;
	b=U9BPH8NnrC9WQFMrgNI4gMvx9wmpv71XYbkikdThZoy9gMzCoy5BGE107DhOGtXoK9bYfI
	hipgR+F1BP2ibas5Kj23putCS8wyjdiRXiNz5nAfW5md9NEjWiWJnf0M4zeAtEPDNyYRkb
	GK2OA1qOmEdzowiKuK1ID3XLEJ8tfqg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bQmhpCK7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 37hLgag0KCPEdXobgehnZaebgZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--kevinloughlin.bounces.google.com designates 209.85.161.72 as permitted sender) smtp.mailfrom=37hLgag0KCPEdXobgehnZaebgZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--kevinloughlin.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793069808;
	b=ZVfAch3p0tuWkjRUMvdpT0vLd9p6w+hv83z9RtBPgqUKU/0I264wvu5VPWX/cliKtk4MQ7
	WvB+DDfbTErQnqMEMdSKsOxBfNpwJsPMsSbFYkYIpFCDq3vlr/0qBDPH/cHa8Dj4457RFL
	qw9elTLMK17M/wWtAECExPRdkLJYXbg=
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-6f56f3638afso4019890eaf.3
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793069807; x=1793674607; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=U1tHH5Mqf99jycLltqjXTRn5xKYAyrIr2aHOwRziEw8=;
        b=bQmhpCK7h+comfjBWFumAP96pd4tsKarh1AznczQoYVHhl8dqLgaHRRRmd6NRSidsr
         0RGEWG407PWfd88kfV9nX0icN9/l81ZXgpLfr7ZqQJKzqMg9DAfnqmBaUkSOTdgQ7Svo
         dMzT2JIIPeJcjvSeeibrT2d8QnVhlzYdBtZlXqEmIIKI7R+olVPSQb9emrVa4LxLYpTV
         UpEsELJoKwArk2Qal6Jl/tvpYHZnI88iTziqnDNH2a/VIX1O1NNg2A3MjJL0qHgC1TZ2
         yvxQXCoHNcvTJY5W1lfMRzHLH/K1/5gqFMlzJ7sdymjnj9DSYN70bl8ispVHRZK8TJTs
         lCEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793069807; x=1793674607;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=U1tHH5Mqf99jycLltqjXTRn5xKYAyrIr2aHOwRziEw8=;
        b=khFAPrSnz3mC73mHFft4CYoWgGTf01HBBxyfrLBHeGlUjTe0kzJp+2IaoAi49uPg94
         klaK+Z45w1qXNQ510LhAzRXvmXukt2v1VQqnIZshSMoavLALqSvPybKh87IrU3zOug8M
         kPv/Otc6yQPqhYjx3KSy2aZwymx1NaShbKdyg1SRBVPuc0y8s7t1y4nOnmuwJ8I2uU/A
         B+y/Yxmi7SahJM3nMnkrQKfXNzfa8Z7j8Aq5Ao4eICwOl1QTC4OigYK4SZ0eCgq5jVFH
         TNpK2bFagJrBwft6OdmDDld8P+wQYT2Evz/6dRfReP/KuabSPhc8UHSaiX5RRkWbr0mJ
         Usfw==
X-Forwarded-Encrypted: i=1; AKwUvBzEHCZqutcINqcRNZ9kuiozm8kFnS+ge3RIdWVJMKPTLHATfRxCo7YCG1or6GylFwtyqhdKXCdQ9A==@kvack.org
X-Gm-Message-State: AFq9FYJ16vMg0FeufOeq1ZiAV+WTpdCjzdljjkf3WsV4OKTCvuF/9098
	TAe6J/v6B3EJHY7fQHeaKeN+uE9WgYJoyIAtAvUxkmOpHkX1I9p8UEIJM44T5cyKtXdn1+wTNj9
	Vkz2PXYoeiPROI4Gi1uh8P9UXQtZx8z9g6A==
X-Received: from ilbeu28-n2.prod.google.com ([2002:a05:6e02:2f1c:20b0:516:ba98:55b6])
 (user=kevinloughlin job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6870:3929:b0:494:396:1205 with SMTP id 586e51a60fabf-4a83f49fec6mr6444601fac.14.1793069806655;
 Mon, 26 Oct 2026 19:56:46 -0700 (PDT)
Date: Tue, 27 Oct 2026 02:56:07 +0000
In-Reply-To: <20261027025616.1632690-1-kevinloughlin@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261027025616.1632690-1-kevinloughlin@google.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261027025616.1632690-5-kevinloughlin@google.com>
Subject: [PATCH 04/13] x86/coco/sev: fix zeropad #VC on unaccepted memory
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
X-Rspamd-Queue-Id: 0B307120005
X-Stat-Signature: iy8ijzwxutkyfyaocka9h39bjnd7jrz7
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793069807-103872
X-HE-Meta: U2FsdGVkX18an8u/MB7TdBimJXHVqzy0MfEr8X87kjISpTyMb/EMlCSREY5sodzNa5hdZnKV5Z2+lhrmtvn3w5aYcjOocqGt2gElF+SbD+ffm5FaJoiqqKBfdJjKDLo61VX1pujS+widv6ykcEw2+yMLtugMziPED//K6Qr/ksuFeoX1F/s2Mgqa3WDFbWQA99r9UZqSN0HeBB7vX0gsXV3iXkJU+9IY5UJUcqcWMCdfHe0TE3OnByZuZppzgvRjN2qddBwY5EH5Q9U1Y6rk4CsCpapZ52ipVhkt6oQkqNlfvl7Tb1dL1mnQXSYY/aaAqisJnZPqwObKZh0yJEpKJ3jIjt3Rw3WBiu0RVODAnDylzdpQHQDk0dD7u4HtP+hK7A2j1gmFfDALwCJOuxLvPBtdePWPmSCZK5nPpg3Z+opaw2nB1hAsOFH8/B39UyuporIU2cEU/mc+hKr4Qf8vQ9lTJkgI2Fhlu19IGsJi35ixd6E1gor85ztQMVL03QEQU9P+CMy1Zpc1dXxKdDTc/AunvCaCWWDafLSvCCd5fySWgURc3kIjBinjA9PdmYz0xCt85FgaE/3PDf4RcaK3LvmTBb6jVVyHPMIn/V11v/b8P0IZGEBk+99r8Ryvv8/hd0rcgMJKYjRoTdEWNqVRs08q13KaLL5uHxfIg5/HqoytxGAv/NT4/onmSD3YsmOAq4sdkJ9eO/RoiGR7gUORUHRqugIKXI5scNFkHkK8oQVRo86+Hq7ZpTqneY8gjRJ+KGUF/xxyCphqmizD/4BbEXteTCpMMq2Ca1OZ80+Xbl5Z1YN93VVDEieZ9FiipDbIsyspzHVRxE8GkCwLOATV8iYjr75863OaJQWMyRXLKy3eHS+C4tAkBkGTKQNoyaleXU2hKRuSW5CzxSvVGIjaEVgnw4P7oUUjS2ddwuwY3yu/E6AUMCgwQPPHxqYIdTPi6ZGo7Y+wvVsvS27wavk
 cIyNXkRw
 4KFh3+fbKSy4go7MKczJu+G0gzDUfjzf1y5HEdhNSgUaXhiD/61aBFiDESZKHmaWBY/0faJ/5fZgTHfAcyTnF2qFNj53FCBM3ZW8jvRdXOip5RsDK/sHVTSJhLpa9+fuDq+UVsvdy8/xb7N4JyEUxMyRrknmHthm7f/zEf2GUNlpeL2rlFZ+rr0dD2Nl7mfH0Jilt15iLY9goM6OsVH/ASM67P7LV3JYxE14OIGGLmq0H4XWBpG8h/VJuTL2O3jWA4PlndUcjqbHR8pxXgFrxbGdFazaeIT9VN6ryD39Nv/2KzIZukQpLu4IgGgY1Kp4VmK8YqOK7EYQosJ4Bnbf/QWuHaOf2JubtD3U/82HtrahDhtV7vj1bs+mQjwW/aK7ExsxARTXrXfmyNloaKf2akCNnY8ynj8jvAhqOVCZXMte/j2dM0tbrwRWqT+9oIR1BHlwOYpZrmrAY/BjLGYWCNNNbvoTSr81xcAYOB/mQuyZAs+GpI2RaxMyNjTy6PPu6HC2KeRnPfNkoaMOH2LGz/CLbKeLmLX22cJ73HG99rJ5EHnqdvX0aOjkU/3sdzaYAL9pXM57+SVSPRdW3emuTGpOmNU8P+LjOpVGCu97i9fbMMMx3uAVF3TZ5ORSDX1amFj5Nx7I853DG6vMrnhN2/iJjHz9x9795NoOV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When dynamic memory unacceptance is active on AMD SEV-SNP, an accepted
4KB page may sit immediately adjacent to a 2MB block that has been
unaccepted via PVALIDATE(validate=false). Speculative unaligned loads
across the page boundary via load_unaligned_zeropad() (such as in
dentry path walk) trigger a hardware #VC exception with error code
SVM_EXIT_PAGE_NOT_VALIDATED (0x404) or SVM_EXIT_NPF (0x400) on the
unvalidated neighbor page.

Define SVM_EXIT_PAGE_NOT_VALIDATED (0x404) and invoke fixup_exception()
in vc_raw_handle_exception() when an SVM_EXIT_PAGE_NOT_VALIDATED or
SVM_EXIT_NPF #VC exception occurs in kernel mode at an EX_TYPE_ZEROPAD
instruction before dispatching to vc_handle_exitcode(), matching the
existing EX_TYPE_ZEROPAD handling in the Intel TDX #VE handler
(ve_raise_fault()).

Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
---
 arch/x86/coco/sev/vc-handle.c   | 29 +++++++++++++++++++++++++++++
 arch/x86/include/uapi/asm/svm.h |  2 ++
 2 files changed, 31 insertions(+)

diff --git a/arch/x86/coco/sev/vc-handle.c b/arch/x86/coco/sev/vc-handle.c
index f25d302efceb..1ed00771d87d 100644
--- a/arch/x86/coco/sev/vc-handle.c
+++ b/arch/x86/coco/sev/vc-handle.c
@@ -18,6 +18,7 @@
 #include <linux/io.h>
 #include <linux/psp-sev.h>
 #include <linux/efi.h>
+#include <linux/extable.h>
 #include <uapi/linux/sev-guest.h>
 
 #include <asm/init.h>
@@ -872,6 +873,29 @@ static __always_inline bool vc_from_invalid_context(struct pt_regs *regs)
 	return is_vc2_stack(sp) && !is_vc2_stack(prev_sp);
 }
 
+static bool vc_try_fixup_zeropad(struct es_em_ctxt *ctxt, struct pt_regs *regs,
+				 unsigned long error_code)
+{
+	unsigned long addr, fault_addr;
+
+	if ((error_code != SVM_EXIT_PAGE_NOT_VALIDATED &&
+	     error_code != SVM_EXIT_NPF) ||
+	    user_mode(regs) ||
+	    ex_get_fixup_type(regs->ip) != EX_TYPE_ZEROPAD)
+		return false;
+
+	addr = (unsigned long)insn_get_addr_ref(&ctxt->insn, regs);
+	if (addr == ~0ul)
+		return false;
+
+	/*
+	 * load_unaligned_zeropad() faults when an unaligned word load crosses
+	 * into an unaccepted page; round up to the crossed page boundary.
+	 */
+	fault_addr = (addr + sizeof(long) - 1) & PAGE_MASK;
+	return fixup_exception(regs, X86_TRAP_VC, error_code, fault_addr);
+}
+
 static bool vc_raw_handle_exception(struct pt_regs *regs, unsigned long error_code)
 {
 	struct ghcb_state state;
@@ -885,6 +909,11 @@ static bool vc_raw_handle_exception(struct pt_regs *regs, unsigned long error_co
 	vc_ghcb_invalidate(ghcb);
 	result = vc_init_em_ctxt(&ctxt, regs, error_code);
 
+	if (result == ES_OK && vc_try_fixup_zeropad(&ctxt, regs, error_code)) {
+		__sev_put_ghcb(&state);
+		return true;
+	}
+
 	if (result == ES_OK)
 		result = vc_handle_exitcode(&ctxt, ghcb, error_code);
 
diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index e80676185092..38b8e0c2f5e2 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -101,6 +101,7 @@
 #define SVM_EXIT_AVIC_INCOMPLETE_IPI		0x401
 #define SVM_EXIT_AVIC_UNACCELERATED_ACCESS	0x402
 #define SVM_EXIT_VMGEXIT       0x403
+#define SVM_EXIT_PAGE_NOT_VALIDATED	0x404
 #define SVM_EXIT_PML_FULL	0x407
 
 /* SEV-ES software-defined VMGEXIT events */
@@ -237,6 +238,7 @@
 	{ SVM_EXIT_AVIC_INCOMPLETE_IPI,		"avic_incomplete_ipi" }, \
 	{ SVM_EXIT_AVIC_UNACCELERATED_ACCESS,   "avic_unaccelerated_access" }, \
 	{ SVM_EXIT_VMGEXIT,		"vmgexit" }, \
+	{ SVM_EXIT_PAGE_NOT_VALIDATED,	"page_not_validated" }, \
 	{ SVM_EXIT_PML_FULL,		"pml_full" }, \
 	{ SVM_VMGEXIT_MMIO_READ,	"vmgexit_mmio_read" }, \
 	{ SVM_VMGEXIT_MMIO_WRITE,	"vmgexit_mmio_write" }, \
-- 
2.56.0.307.g5fe7bd680c-goog


