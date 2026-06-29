Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59452C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 12:25:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E712F6B00C3; Mon, 29 Jun 2026 08:24:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF9FA6B00C7; Mon, 29 Jun 2026 08:24:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4C626B00C8; Mon, 29 Jun 2026 08:24:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9132A6B00C3
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:24:52 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0BB99120641
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:24:52 +0000 (UTC)
X-FDA: 84932869224.03.E3B4ECD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6463940008
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:24:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NIIvri7+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782735890;
	b=HsPqKSjhLGxINYd62keUfSp+Wdz/T2iDbnwh6xMMLdM4ngAOMzgpWh6FSzqVEQuSHlcwBj
	RUAWOQ+IOPNGC4L6+U4l8UvOEKLVLfADxhF2eySSF+R5ictQ0wZbORxMx7zBtWMSlEkLA3
	llsFTg41irop/XmzrH4Lb5XJvqAz07g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782735890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pNf2vZLs0Ll45B4pKyb976+6a6p0KPUKwIl6t6WJtJE=;
	b=RqcnM0G5Qv72HfNGc422WVUtfJcNX7qanWh00m5KGe47T871xgcWDZ4eHDFtKNKtIGdRY1
	vYjgiLS9QT04kx7POsDp8I84Apb04QfAfSEu0ACXrqA6AmMd16tmuz3LvUMjogNW9WbJrp
	KSXy1sAetqei51aD+Z3C+1vvYpiQxZk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NIIvri7+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9D65241905;
	Mon, 29 Jun 2026 12:24:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B13381F000E9;
	Mon, 29 Jun 2026 12:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782735889;
	bh=pNf2vZLs0Ll45B4pKyb976+6a6p0KPUKwIl6t6WJtJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NIIvri7+xMYzLim1PkfG/ho1mN+c9wfJYOoMG5RAAbL4KacfAhSRvbPZdT+r5T04k
	 WAZFffkPoN9trQ/+yCnF2yVOcZikQi67qHMu8Gkfbdgz9aWvYK0MORbqEDNaMw+x56
	 K8lOXoq6WRvCNKB7YFZpD6ffvCVeS36Nh4pQ82MX0sqTXfUyNE7/zj8ANh7D70Jpu4
	 +Mi5eloSuherPvTbQK0z0Z0UtoSMHj1IP+0q/uR2bJt+3EThjagVfw0k0q3Mm9d8M/
	 6ev1pefTPiYeFjOMFmb+/b0HMnsv1ZDkoYky7cdihOqNla7gdHc5hH2+xVLh2cAdxM
	 K1VekTqZ/PREw==
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <linux@armlinux.org.uk>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Dan Williams <djbw@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Matthew Wilcox <willy@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	SeongJae Park <sj@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Hugh Dickins <hughd@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-parisc@vger.kernel.org,
	linux-sgx@vger.kernel.org,
	etnaviv@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org,
	linux-tegra@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-mm@kvack.org,
	iommu@lists.linux.dev,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	damon@lists.linux.dev,
	Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH 18/30] mm/vma: remove duplicative vma_pgoff_offset() helper
Date: Mon, 29 Jun 2026 13:23:29 +0100
Message-ID: <10671c2fc5d0dd4e3bf497181923e63e46053df1.1782735110.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782735110.git.ljs@kernel.org>
References: <cover.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6463940008
X-Stat-Signature: fy5bi3qr4m9u96d7wudufirz53unh5gy
X-HE-Tag: 1782735890-450797
X-HE-Meta: U2FsdGVkX18IEmeXk5A97n/2a/xy7qQOY7E5PPTMk8l5H0a9ayp5RqORXfv2+M4+dasf6WfXo60pgpkpdGRyX121APEPVvgPZRMdnon8izGHCFPfXHBTAobvPgW794OIe6cdpLbXZ19PiXRu05JmSJaqX2czNQk4/4P3bJHCEQcunSlXNIdVG3fPFn3z0T/AfvFl67M0Yvy30OUHMBI2nrN1MThzi/6p2uwCXvF3q58WCR9mwJ5aIXzkzT1o4qiPiAAQ6i9S/9wOtuwUrsGugaQmtyV2VozzP9Xuk8fh2Jt1AtninRgHLNCyT1orq4eljvkS5cvhgBwfdlV/qroAPKmjDrKG2NcBm1ieXOwqjmeJnyp/TC7ldlkUoL3TgMeRvYxWamXSNtaGIhmCvlysqLNy0lztTu2xSV3uUK7VK71UjLsOG9K8Jbbpp5j7uRRPMV9G8BOnK97B1/GOz/EQrecX26OmYbNjmA+vxseKVNZBb27WVnlNMPgV3BgY9Ryay/UN9vkZzO3CrrFvNXxUZttXSn8g0knnvIYDOAWDqpCmQ7ArtgqqrgoKyM88i1ed+DuRobshiWtjnjrfQcMXnIV9LT0PFvaPy/Kn+kBj33RyQNcmAx/KjlABANl1w96D8lyppRXXqd8dneJ010X+/Yp7b0um3ASPzoSrZ6NC1OMJsR61XUYZf44PYC7Abqwu707Vr8wBg8q84g1IxQDY/i8/lugJg+KyQ/sK1NyQoKGbAd8p6UvzGkJYkeUr5/PwqFkraDidqxdbgiBT8RPjHVFEE3zBTyEWGlM8BhH2n66Vl0e2R2xVYXomAqwCuBjdBPLoGowF0ayWdkfqBXecZlCmw52yxnElfkOkjV9FAM+nTVVJiZtEGjHzge8Ax3nezUqEthoOZ99TvOHNLLXu484tZHiVRXXNaUt3e0GvoIb9QujAOwhIBK+EflERmJzNhUl3UAg3PwmJaeyfY7H
 /VVQoLYE
 hk/wTJSBaHmwKa7pD9+7/giSZ5++ncj7BfADqtIx1lLxF8RRX0CiQjmcwXRP2kSgZbWprjNBaAByud/uMSlYLKkMW7VyAkFjbFfLVchDxxk3mlgK2lWTQBacxKVBFsm+cSS8p4zGO/Rvjfe2GFYlqsYE3KsguCNifiHpJvrYB52ujBAfY0c33Q45BQhwt2SxQWEC/pXzsbpn0oRthuj67KEYdD9Pq5j0gS/iYXXt0lHKyEVMW7RvLS2ECgLEVLElsMQ8Oy7agt/hqy3xrE0UrDqAQuZJ8W/VMojsKsUTDEtjzE39fwBFnmJfXGEApynL0AHbuszXFWzYGmov5IrfZ59dZK+xhu+T5xaxUl1Ec2nhJF+A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is doing what linear_page_index() does, so eliminate it and replace it
with linear_page_index().

Update the VMA userland tests to reflect this change.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/vma.h                        |  9 +--------
 tools/testing/vma/include/dup.h | 16 ++++++++++++++++
 2 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/mm/vma.h b/mm/vma.h
index 527716c8739d..2342516ce00e 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -247,13 +247,6 @@ static inline pgoff_t vmg_end_pgoff(const struct vma_merge_struct *vmg)
 	return vmg_start_pgoff(vmg) + vmg_pages(vmg);
 }
 
-/* Assumes addr >= vma->vm_start. */
-static inline pgoff_t vma_pgoff_offset(struct vm_area_struct *vma,
-				       unsigned long addr)
-{
-	return vma->vm_pgoff + PHYS_PFN(addr - vma->vm_start);
-}
-
 #define VMG_STATE(name, mm_, vmi_, start_, end_, vma_flags_, pgoff_)	\
 	struct vma_merge_struct name = {				\
 		.mm = mm_,						\
@@ -275,7 +268,7 @@ static inline pgoff_t vma_pgoff_offset(struct vm_area_struct *vma,
 		.start = start_,				\
 		.end = end_,					\
 		.vm_flags = vma_->vm_flags,			\
-		.pgoff = vma_pgoff_offset(vma_, start_),	\
+		.pgoff = linear_page_index(vma_, start_),	\
 		.file = vma_->vm_file,				\
 		.anon_vma = vma_->anon_vma,			\
 		.policy = vma_policy(vma_),			\
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 535747d7fee4..7ed165c8d9bc 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1548,3 +1548,19 @@ static inline pgprot_t vma_get_page_prot(vma_flags_t vma_flags)
 
 	return vm_get_page_prot(vm_flags);
 }
+
+static inline pgoff_t linear_page_delta(const struct vm_area_struct *vma,
+					const unsigned long address)
+{
+	return (address - vma->vm_start) >> PAGE_SHIFT;
+}
+
+static inline pgoff_t linear_page_index(const struct vm_area_struct *vma,
+					const unsigned long address)
+{
+	pgoff_t pgoff;
+
+	pgoff = linear_page_delta(vma, address);
+	pgoff += vma_start_pgoff(vma);
+	return pgoff;
+}
-- 
2.54.0


