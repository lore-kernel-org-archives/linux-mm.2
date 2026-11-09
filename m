Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 724D8606A339
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 04:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=J+aTWeug
Received: by kanga.kvack.org (Postfix)
	id 84A706B05B8; Sun,  8 Nov 2026 23:34:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 827546B05B9; Sun,  8 Nov 2026 23:34:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 761636B05BA; Sun,  8 Nov 2026 23:34:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 564526B05B8
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 23:34:00 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C0D13C0294
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 04:33:59 +0000 (UTC)
X-FDA: 85414312998.19.CD96E49
Received: from mta0.migadu.com (out-128.mta0.migadu.com [91.218.175.128])
	by imf14.hostedemail.com (Postfix) with ESMTP id 93B50100003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 04:33:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=J+aTWeug;
	spf=pass (imf14.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.128 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794198838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4DN1Y+t6vujW8S/AQPbCJ490d9V4hkbmm812BgwtOTM=;
	b=yzLmA7PDea98t9OTHbaf49i3DvD3oHtY11oNVS2s5zwkG46V9U6gjIv+gtd+pJ4+U9zg4l
	OD27kJFxx++Chonby1xJVuvC+Aqqk2GkHl/pdBkkAAO6UCmCfTV++YjQTJNl34W9fV5bCa
	Vhuphgql1lalY6V4p8x2bb++VNC89nw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794198838;
	b=WTryf2NdBaoXpi7FoAkXSQr+BTYwxOhcjdjLiRGRFRKvf4FTW7/5UUWLcDeUcF1Ex5J08q
	ZSrTYBnCV/vvrns7e9WLhEB6iPg2Xx5phU6KCoADWN4P82amT9z6xFdiK1xQCM6LnQL7r1
	1GDj8z4NBaJxTxiGW7Is2K603f0EcoY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=J+aTWeug;
	spf=pass (imf14.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.128 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Uhs7BWZm2N+gFKXL/TmYjVQYKnl8VlxGISFVM5NLm40=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794198836; v=1; x=1794803636;
 b=J+aTWeugil4lbZaw86bysXlj72KJ1YDD/oBtNnrnxpwFt1Zv3v92oWKWjh4hCRQhawyW6UvD
 SrnwHPTpMGnc32HdDCtbC3titUBPWUSWN+J0XGBgJevyXUJILOhMtgkDhR1TxBlSmyoG0ILcNWb
 71MK+oj5lMtq7adOxfFCoBjg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b7fb94620bed6bfe;
	Mon, 09 Nov 2026 04:33:56 +0000
X-Mizu-Trace-ID: b7fb94620bed6bfe
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: songmuchun@bytedance.com
Cc: david@kernel.org,
	maddy@linux.ibm.com,
	rppt@kernel.org,
	akpm@linux-foundation.org,
	lance.yang@linux.dev,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	chleroy@kernel.org,
	ritesh.list@gmail.com,
	sshegde@linux.ibm.com,
	osalvador@suse.de,
	qi.zheng@linux.dev,
	muchun.song@linux.dev,
	chenhuacai@kernel.org,
	kernel@xen0n.name,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	x86@kernel.org,
	loongarch@lists.linux.dev,
	linux-s390@vger.kernel.org
Subject: Re: [PATCH v3 3/5] loongarch/mm: disable device DAX vmemmap optimization
Date: Mon,  9 Nov 2026 12:33:46 +0800
Message-ID: <20261109043346.38778-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261107043122.25650-4-songmuchun@bytedance.com>
References: <20261107043122.25650-4-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6i7zhayifj5rosqpomigx16endw6pn81
X-Rspamd-Queue-Id: 93B50100003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794198837-608841
X-HE-Meta: U2FsdGVkX181NcVAN8HjYF1ZkYGCxvvdl+uC2Of2JIgZI/NTVVFnsix86/O1ve//EQFkpKkSExK6dKpU6gjd4StTHpJKPtMsvU2s0unP0mCbkKlTTZ6JmMjRAZX3ACfn+HUlsZ3Ev0wfF+egGGENEDFEruXAs3taC1nX3F/P9i0mpWGUk9wFKc0SLObPSZwRherp7139AV+SNkSjzXE+6VmRrY319Xy8d1J/usq72ZytXM6MDgRrUlPfjEUiSuz4YVHaGulcLH0apqh0QIoUjUij0XoFXZJrVwvfwf9+gldGjnOkZ/phVW+m3h4K2Z23OuZsq+rKyY+QLKak+qR8ICbBbQt/hBSgE7tm2sYlwsjen78BwwAN9g/GUAwGDMvPJMAuwIu0Rwht6cN296FIHNF12ptML8s/1kuyxh66sptiLb9qF3eTXDOMagey6poB7d9P+lW0VPrshGdp/vwIbpIoSNBaaACitqFSlCie+0l4/H/+MRJxBAUymksYSmO/Q/IWNJ0q152LsU3PxFprBOyUutIFlpEgE9Z4FZS+NwgVEmuNuVpNEiSS6ZOKRbIyjd8tX+03sR7yryVt+oogXGUDLpVUNHGp6BBtDwFYoG/NTGjEVP3rBxtX86XulmWJPOAwCSYPWcxJyHTbSznEles890VQ14XCTEWKwwHLDTkGdS/WUmHEYhNYJ0+WuU/fFzwdyURvXpa7EM5ELELb3WbgWdIvKEb+/OeJvsIRRDdA2IGuLQCin8GzVDQkXdE/zqV+4/6uG2UsFEHIIyORD2TQTOasskl7ZDeLIimLktSzydV3/bHf1ZvxFFXHUmU8XPy2pbHyR2hq6XjrxE5Mjus5dadaNovzWjKOD/aNbgs1FUPdDCLS0QkdjzsSXBIVsnA9LiZqj5Jl0jmYOB62W9ZAT/ihCOgj/eglJZ1mbCLM93OVTpuLUYBJePZXjYxDCssdqzER+zGu1IKlxOa
 oYeHiKrw
 ZJqvEg2Z1klYSaX06rSKuvyGRqi+ppgaNNYmImR3mH+86zhL9nWXvwk5OIQK3gntIs1j68IrIqiq1Evh3OOuDPxlb4fbZOC2Cyy3/cZPjA1egcZrQkUQHm+LvkJjMZmiMHBaO81qZcDXDvIsA53xE4ugQ0kVx9oQqjGr3VNvijMxPFBZZyinXPpFEbKova+hMH3+M3K2rIdMYZJQb0411wLbyBgjvoLlcVl83N+PsznphaJDUQKG4xvcrV9oNl+FZd1LVo/IPbuvD9/snSNSvcLno17xGW1ubJEoN119vOBUbjNh4h3pF3/w1vj18ap5A3NJs10/SYV9RK1G2K9fTK4vjcAEFzMnRtQMk2VZoITKBV+X+lf2Y8ZRA4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Sat, Nov 07, 2026 at 12:31:20PM +0800, Muchun Song wrote:
>LoongArch selects ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP but not
>ARCH_WANT_OPTIMIZE_DAX_VMEMMAP. Its vmemmap_free() implementation is also
>empty, so it cannot tear down optimized Device DAX mappings.
>
>A later change removes the generic Device DAX architecture gate and lets
>vmemmap_populate() decide whether a section can use optimization. Clear the
>section compound order in the LoongArch path so Device DAX keeps using
>unoptimized mappings.
>
>This does not affect HugeTLB HVO: LoongArch does not support gigantic
>pages, so HugeTLB does not use section-based vmemmap optimization there.
>
>Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>---
>v2:
>- New patch using section_vmemmap_optimization_disable() to keep Device
>  DAX vmemmap optimization disabled on LoongArch (reported by Sashiko)
>---
> arch/loongarch/mm/init.c | 2 ++
> 1 file changed, 2 insertions(+)
>
>diff --git a/arch/loongarch/mm/init.c b/arch/loongarch/mm/init.c
>index f801f7097f03..ea769e479241 100644
>--- a/arch/loongarch/mm/init.c
>+++ b/arch/loongarch/mm/init.c
>@@ -15,6 +15,7 @@
> #include <linux/memblock.h>
> #include <linux/memremap.h>
> #include <linux/mm.h>
>+#include <linux/vmemmap-optimization.h>
> #include <linux/mman.h>
> #include <linux/highmem.h>
> #include <linux/swap.h>
>@@ -143,6 +144,7 @@ void __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
> int __meminit vmemmap_populate(unsigned long start, unsigned long end,
> 			       int node, struct vmem_altmap *altmap)
> {
>+	section_vmemmap_optimization_disable(start, end);

Yeah, clearing the order here keeps Device DAX optimization disabled once
the generic gate goes away ;)

Nothing jumped out at me, feel free to add:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

