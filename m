Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BED3A607084F
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 11:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=AK8V50RP
Received: by kanga.kvack.org (Postfix)
	id E10A56B00EF; Fri, 30 Oct 2026 07:53:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC0AB6B05B1; Fri, 30 Oct 2026 07:53:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD69C6B05B2; Fri, 30 Oct 2026 07:53:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A6FA96B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 07:53:40 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 276B88062B
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 11:53:40 +0000 (UTC)
X-FDA: 85379133000.09.948253D
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf10.hostedemail.com (Postfix) with ESMTP id A02CAC0005
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 11:53:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=AK8V50RP;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793361218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Ruvz+vAepzPKRTBn1LAj+/ZsyRqQngmycGqMeNBfwOQ=;
	b=G0L65qq1/iQpqbaMYnKmL0oc7EriAPbC5SJ6LFOnKO0ZGRFaOu+TSqIV6bR1YFNJqJWyyG
	UyaDMnoatLMDfR1KGqRQgf0VNtaE3BIkteorRJgCYlM2ehxRKl56XcvSDVMZ54XGXCYxrc
	BpxSu4hGQX7vZ4SpwinlCIZrCoD2YE0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=AK8V50RP;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793361218;
	b=tQ/LtW6SfFI+QowQf7/X3g2J7MjLe35gNtxxjyyPwdlgGjX74xqW6HKvsIy4+/SQGVecL7
	LcXPkjORavHoVauA+YzoHlhi4Lq+1DvoHhZgX1bd6jL9Z6sJCD8vNgAVku3iKyfM+QsoAs
	+XxLxPw3LKVE7oix9uIEFJGUqTQtrow=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8a05e3f0d23so265149b3a.0
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 04:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1793361215; x=1793966015; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ruvz+vAepzPKRTBn1LAj+/ZsyRqQngmycGqMeNBfwOQ=;
        b=AK8V50RP3zTppxAjEkX6geG4cvFTwUJgvfzUWd88K3g/OIihp4Ba5pKRC/ZUJ37ByL
         qbjRdI8/CheQICPGoVJry8S2mjm0V4f3KDy3h9bzadYeCRia8ELF7mioFLDaq2V51Se/
         Z2v8/SC6z9FrsuCKUQZaiN5QnKMunJK/DsmFWQ4VcZCuEey9W2/QmKY25N5153uvOJSk
         /GDQvVwnyfkDae1ucBKMgoiEM0sgzP15kwf79mNcUrJaZ6+kHJNfmn2C2IuSVcHn0HQP
         0iiqWqZ5MpDxnrbcJfbK85I8E6P7gRVsAIrW24If7g7W7JaK7kWoS36cxFgmW+jGD5Si
         mBGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793361215; x=1793966015;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ruvz+vAepzPKRTBn1LAj+/ZsyRqQngmycGqMeNBfwOQ=;
        b=IVokd4QrDdglGEo07wmvIPkgdIzw83d/KaEAkD0MVclpsx6Q3VLVk5+0elm5M9TkDp
         QNpkshBeI5P4C6GWmam59hCfy6k+n9n+eU7pOK2CkXqjXNUJOWB6doj+XUkVng4gqJ3q
         lj/6jRqx+FzSQfwEAlLUHTYGNGV+riqAHQz/gyZjffe+YyuV7YjJHCBBonxD/KWs54uW
         2XBc8cPlS13DhqWqS/DvvBZdEFp4UlvLVAmyKvDWfL7i52t1ur1GEfAFHTKHMWrL8d8P
         gD3DOLV164WOXH0WrmVt0JOh7W5T7bAEAKtOvyInXYctrFr0pOSXHA3SPMuGvtf92AU/
         ui6Q==
X-Forwarded-Encrypted: i=1; AKwUvBwZMVKfXOPC4SZ5LFegl9zmyhxjBW3reZbt+1rila6bDplqm99tPLGr1r/tYRNMepJoIqTuwJoDtQ==@kvack.org
X-Gm-Message-State: AFq9FYLwe98kGv4EngUZo2+Z+Q1D3zWpOPlvAsLCbTEtk98L98hJsszB
	ylYDPMvb/07K0HzPiRmBUvkv0biCN1yb8e+GnU+1lvdEYxNeOKsPZHpOLA/wX3NgkVE=
X-Gm-Gg: AYBFou1XeJRZ9odV+dbuePu3w3ewqT/WnVT3zbcQvwhTfg/f5f8jxHEcv8061hPUpD/
	ycoN6pvq1I+uVS84QwU4xisG/F0B0id1oVgAheFaeQoMYmGQJiqaeBwu1yYEOLHXoFqAxmctXYH
	qa1Ntb2skXhtR97XAN2HkjEkmKPBX7csVrBqB+SdDPlmujTiZ3cYyFfNgTs81+zobKDC6QkFA0s
	prhsl3S9q5BM/juYaMwEQ1yZ6cCQPcxL03cVIX5Dd8+x9ZK/zdXZPgPtwtVj7ed7yUL3ARjg8eL
	LIXJ6OiFvu+yMo5FGFo1SowqSQ6+o26nu2jdNtM7Ny7dGefElf0WD/dPM8i8/R//4WSuWjvnx+L
	syb6e0JsX5wcUiIaLE0bfoxdnBTIZ2Av+TJI6oCAN2hFaHVE0BtWRFcZBxtcvCeRpCKGAOGS6CP
	c7VLPt7qfKtJwS3VIaAT8Ri0jYqQwOx7g6pvfS1MnQzb9sf4YOE1oFrmovQ72OsjlUhFwUFIQ02
	8Nov8K1uhJuaIQIZyirDt7vy9loF3F4THhyVlpkjyMs7NL9Z4ZtdTLQxkKAT4v0GusItAUiX05X
	rp07nXJ+oHEAYqMafvncKCVLn9HeDRV3hNEnTaTfPY1ANoB5Nik=
X-Received: by 2002:a05:6a00:3a21:b0:881:7ff5:606f with SMTP id d2e1a72fcca58-8a9bf71bbb0mr1772756b3a.43.1793361214559;
        Fri, 30 Oct 2026 04:53:34 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.101])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a9eff2684csm663223b3a.48.2026.10.30.04.53.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 04:53:33 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Ritesh Harjani <ritesh.list@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Pavithra <pavrampu@linux.ibm.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2] powerpc/mm: fix uninitialized ZONE_DEVICE struct pages with PMDs
Date: Fri, 30 Oct 2026 19:53:25 +0800
Message-ID: <20261030115326.1005755-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A02CAC0005
X-Stat-Signature: xue19qpipyqrkz6155dbaoiog6nt1e61
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793361217-995329
X-HE-Meta: U2FsdGVkX19Wl7vWpwV0cqz5coUZsPtPNO1qS+w7OsGqr4bW3mABf/spXJoVORA0LamWVvbLLjtXTcuMiGv3Lw6qiwwCsy+1iRK0YDcrE6xTvYdH+um6rb/wQQCD+04TtZ3Yzi2KGPL/vkbV0MD2X9kMdHR6d+rRMNMpiyyN/bptJG29x44nRZEPlR+IepMan6gS0rlW+V1+CtleVe238WtNL2hJDXp4Q7plgtY7vSBVooA3mViJHhn45fZjdGH6BGEUrv3xDOtKSLdYF0rETmZ3ZEerbWjqJzVIAwp3xUefbLF/l6eROXOS0n+vdPMOwTrTWlOcYUuK8mG7EXE2T53z6HeDWXfIqrvY0jMZG41c/Xeyh4R7iqsO5WdsFV301WTG0HjhgvELF00UGqtAD5j8n8AHHxHt8cU2zwFxYgLrPupI5Pey17QS1YyWdQUovaB/zWOFV4G4mbajKLEcs0RHqf4OhIe9N0n9sLKlLoU+FWL5ueJa9MYM569fR1LoBCD480ZsFfV8szyGjh5yspPpui2CkwKAF4wO8852iClBYXLcIIFkNq7P90/mXyiPXEbV8FST9Pdp3kRD49zT4nkN9mHIJQVAFzH4kg1USE1nzfglnQXzNaiPaO4iQmZuylcb8qi6fweLrJ5CSSEr97gnPa05HEPsCt8OzIL/hBTCH4c4fnY9uc6u5vvGKwKLrvH2YIc0FVSohPLhDVbHetIuii2oqoE8RIMc9+g2KW+FSFVYc26TX853xPq6g6785XXyaqswdZ2uFnajnGXDdXqG8hRh/tcu4UlFft3xZz6VP31VStqbY3sbUauFHjUna0ztoJQBOe5UnDy4jLia3wyjkZp/e3RXVejwNpxjyAGm7+NwI8991W7nQXzz4YGyiIulvxIjEpaBl/y5mcy3XpjT+UleQH0/YnR2M4j7f+PZqKMIBatCJSEHoZDtB5M+eZODIhGsAE20yr1AXVU
 xyAsirI5
 JF56OmTrcQKvok+xUQRVdEoZr03xDX5x6UDolvqVpjJeXLzVeaDEzcITP4QhiOrYbxINd+Wr6pwspHx5WYdlh27l7sADbx6gVbakrs0NPlxDXR2DoTb7WsxJMC5f829hasQZXp4Fz7ZXysPox9uvUCHV8grsF7JyA5o/rieYAvavuvSIp7cbskCOwfSWiIibLPYhI2zqweCp9V0SDOuZ621EAWR1yAU2LmpKb1hBss5Yc20ZqQyHbPC1eqeEhRUs/i6gH5qG3tJMXRULVEChhu/GSm1ityJpY2GtfsS9NPltmfJukzpVs1dAQioHSiiMqC/5Wre+zQlmP1aWgisaWdPbut8XlAPE+wbb3Y88SXxH4H7PAHT1fFItuAxhdcqO4A3AKGDPREVHlQr4bPUleGSPkkIHf1GX11RYpbuJ6i9VnJ/0y3WkY4pWqa2gvIQL4t7f2mXOKykKuKral552cLAQBOZWQDMgSnpO5olCQMyqmlljBspQsh+AUOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

PowerPC radix vmemmap population can reuse an existing PMD mapping for
a device DAX range marked HVO-enabled. The reused mapping is ordinary:
its tail struct pages are not remapped to the shared tail page.

Leaving the section marked HVO-enabled makes memmap_init_zone_device()
treat the range as optimized and skip initializing real tail struct pages
that remain in use. This first triggers a zone mismatch warning, then
faults while initializing the pageblock flags:

  WARNING: mm/mm_init.c:600 at __init_single_page+0xd0/0xf4
  Call Trace:
    memmap_init_zone_device+0x164/0x430
    memremap_pages+0x43c/0x93c
    devm_memremap_pages+0x3c/0xa4
    dev_dax_probe+0x264/0x3d0
    dax_bus_probe+0x140/0x1c8

  BUG: Kernel NULL pointer dereference on read at 0x00001400
    __set_pfnblock_flags_mask.constprop.0+0x34/0x160
    memmap_init_zone_device+0x358/0x430

Without these diagnostics, the uninitialized metadata remains latent until
userspace accesses the device DAX range and triggers a later panic.

Mark the section non-HVO when reusing a PMD mapping so its state matches
the actual vmemmap layout and core ZONE_DEVICE code initializes all real
struct pages.

The Fixes target predates the section-based vmemmap optimization
infrastructure, so this patch cannot be applied directly to some older
kernels. Older kernels instead need to pass the vmemmap bounds to a
range-aware vmemmap_can_optimize() and reject optimization on PowerPC if
a PMD leaf overlaps the range. This reuses the existing mapping normally
and makes core ZONE_DEVICE code initialize all real tail entries.

Fixes: f2b79c0d7968 ("powerpc/book3s64/radix: add support for vmemmap optimization for radix")
Cc: <stable@vger.kernel.org> # see patch description, needs a different fix for <= 7.3
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reported-by: Pavithra <pavrampu@linux.ibm.com>
Closes: https://lore.kernel.org/r/97f85592bb78a273be8519e6897e7f9b9bd31469.1793070429.git.ritesh.list@gmail.com
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Tested-by: Pavithra Prakash <pavrampu@linux.ibm.com>
---
v2:
- Rewrite the commit message.
- Describe the range-aware vmemmap_can_optimize() fix for older kernels
- Note that kernels through v7.3 require a different stable fix
  (suggested by Ritesh Harjani)
- Collect Tested-by from Pavithra Prakash
---
 arch/powerpc/mm/book3s64/radix_pgtable.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index 44868b62b14e..4f75f10ed68f 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -1261,7 +1261,16 @@ int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 			return -ENOMEM;
 
 		if (pmd_leaf(READ_ONCE(*pmd))) {
-			/* existing huge mapping. Skip the range */
+			unsigned long addr_pfn = page_to_pfn((struct page *)addr);
+			struct mem_section *ms = __pfn_to_section(addr_pfn);
+
+			/*
+			 * Existing PMD mappings can cover the edges of a valid
+			 * HVO populate range. They are ordinary vmemmap mappings,
+			 * so the current section must not be treated as HVO-backed
+			 * when its struct pages are initialized later.
+			 */
+			section_set_compound_order(ms, 0);
 			next = pmd_addr_end(addr, end);
 			continue;
 		}

base-commit: d865f2677c44cb2171b833d6775cf692756fa8be
-- 
2.54.0


