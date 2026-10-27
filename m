Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 617E5606A332
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 15:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aANjwK0h
Received: by kanga.kvack.org (Postfix)
	id 618326B07E7; Tue, 27 Oct 2026 11:47:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A1F86B07E9; Tue, 27 Oct 2026 11:47:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41BD36B07EA; Tue, 27 Oct 2026 11:47:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0C25B6B07E7
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:47:10 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8142080A39
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:47:10 +0000 (UTC)
X-FDA: 85368835020.23.350A6F6
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf20.hostedemail.com (Postfix) with ESMTP id B5E231C0010
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:47:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=aANjwK0h;
	spf=pass (imf20.hostedemail.com: domain of griffoul@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793116028;
	b=Gwu1UUNcNBFrSKSfD9X7yNwgdcrJTdnQ6l8k1GpOXyunqlZ0PnGp86H9Z50JX4lRv0stob
	eEu2csJ9XsT/on6grQAOVjv1XkV8dq0qwfYydYutLd5y8HsPdsxRBwN0L0zLj44QDJqGr2
	vooOwAnefQkG3IKn0lrTNeniv3PBwdk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=aANjwK0h;
	spf=pass (imf20.hostedemail.com: domain of griffoul@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793116028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I9tKrbL54EVqcIFPPtB7uxrxNAXJtibM80HAzpUcWLM=;
	b=Hg01Lr8basUigd4u0odRv3VsnXbEqQac+UFuYZep4ijlbdFsXcSjjwS/Ph4u7xGCkigZcj
	jzR1MGuv1DwQ9IPMquXnXhJrjr0vXwOF3UTlGVVG5rUmd7Q+MxaMiNQ1hIaGLE2EDhLtvH
	Cr5EHamxfX3oxYV0NepniM32Ur4j0Xg=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-48e0d1da913so1104363f8f.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793116027; x=1793720827; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=I9tKrbL54EVqcIFPPtB7uxrxNAXJtibM80HAzpUcWLM=;
        b=aANjwK0h7CbmpXpr/cXuaTiZMXfqZWu1pHJxW65TJIAQIkiDv9QFdKEbtv6aRMH7Ii
         4TIrz8hqKuUkRqv6OvbFo7eWsflyQtDE/+lDfNgtVQEF98zYDMQix7lPZvZuvpzbRb3v
         AX+HFMZM83utYXZIErTuOuBOGvg1KhmnGGIutRrtSfOXNoHV/CqIyKjOPVKj/MV4ZFjP
         6LigX4hyNk+rJNx+rEzxPXJRC4Y95nTorOq/gfZLvXlkD0o8wqxY4mP6fCXPKvoF9uio
         QyZwruGaIix8iPVLW+rG36veYHS0Dvm5jHQj8Uj5DqzNO3vQdAEbnZMBhR+ksvd6atPt
         SAvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793116027; x=1793720827;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=I9tKrbL54EVqcIFPPtB7uxrxNAXJtibM80HAzpUcWLM=;
        b=OMGJAY8GSUmPnbMPm2LQWEAz7L/liOkh8zNGynYEtY8wLmW6EkFtUC3xPxoMH91B0O
         syzeoS/of3i/VzGFDH4JlPouelNKqvW8DJekIhH1U9oAu/c6mXrixz4pwduk0SaGtgbs
         vemXmUF50yCrDSEe/sCWj3X/iR8QW3XuIMFHnKcIY/NHreNsKO8t/Pm/fu6Btlir5Bk3
         5QSrUs0XBJB5dQ0VU+O/nKOViElYPPk14pRSLsSJrSXAhSM2aaF43oL3dEGz/5QNcVw+
         SAdELR7PDLfID2m4WunZbXciiSdUzSjWG8CuZnty+saBx2YsyMaHP6LYfLC52b/yZZVg
         mQcQ==
X-Forwarded-Encrypted: i=1; AKwUvBzudgYvwoH6VssyPwR6p+twC/md0ASx4xRah4gX/wSJWX+UOUbXBXeo5YdcWZQFmNf1t4VnssOAPA==@kvack.org
X-Gm-Message-State: AFq9FYKwNIG5AvpoiJU6/5LEm8dxQtBal6SZ2pHPzDgtk0ehpr+mzHYt
	pdkhwuDUrFHMWIW9PZAaX9paTa7e/r6xyYC/I7eIFMoEJji3bjZ0a3OF
X-Gm-Gg: AYBFou1+LZWO8bauFwsLyyeheOFqQozzX/hWZEYYwPYToHlweee/YueGBIwCqVOJeTD
	YHekKw0kd8f1TyvylB5PfWMRzQobQGMW5Qyph6Y+mz+TZyu/7OzV/Tiq0hOxZczv4Mtqqb+dB6T
	sYYB0EEMMRS/2YyBdUi0rRyk7xahWcbKz++U9kMMY05Hoe8MG2rD10rlhT8Yr5ckvQb/1Rk+UfM
	3NCQjv7XaBUTL+5HGVRIkV+BI1M2eMLnt0Pp55AsGvIl49mnoikpa1ZFQBqFb5nWHkryuENupTv
	0NjfCCWXD7zOFkQOoFqu+W9j16+EcPhR3UWTjQNuFgy/BxFB+frElWFIIlfhQZGpkxs618uNqI0
	Kj66hAhSzJyipsrq8lyZnjeE+4OWvkKPhuKoE//ZFTLF7+XB/kmGdK/ym6xwKkLAISNaielZM1G
	7skAxJ7ovFu7CKXn/2LEKRI3GeT9xiHYlhAgfAvG8tsFd3JKVnDk+5M7Q8jJc0IuZLRaqbl0w2Y
	7+kZyKBFuXkRT90ROeSbpCOrVN++ESPNOqEZss9UpxXhzMyXiNz+J/LUSCZaTWcVQxn8f+SISOj
	fJ64kJdH5ccTcDnP6w9HcrDiAlxT6/edL4P2BmG45QHsud+Yad+5T5ua/lOavdn54NhrS0Ij86d
	eQU1+r0FSjRej21VosXLDeKouM2AN13zh+j1JZw==
X-Received: by 2002:adf:ebcd:0:b0:48e:4ad2:32e0 with SMTP id ffacd0b85a97d-48e55a5a8bemr4605062f8f.29.1793116027147;
        Tue, 27 Oct 2026 08:47:07 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebcb958sm23845574f8f.21.2026.10.27.08.47.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Oct 2026 08:47:06 -0700 (PDT)
From: Fred Griffoul <griffoul@gmail.com>
To: Ackerley Tng <ackerleytng@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kevin Tian <kevin.tian@intel.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Alexander Graf <graf@amazon.de>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexey Kardashevskiy <aik@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Baolu Lu <baolu.lu@linux.intel.com>,
	Bill Wendling <morbo@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Brauner <brauner@kernel.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Connor Williamson <connordw@amazon.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	David Hildenbrand <david@kernel.org>,
	David Rientjes <rientjes@google.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Erdem Aktas <erdemaktas@google.com>,
	Frank van der Linden <fvdl@google.com>,
	Gregory Price <gourry@gourry.net>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Hugh Dickins <hughd@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	James Houghton <jthoughton@google.com>,
	Jan Kara <jack@suse.cz>,
	Jianxiong Gao <jxgao@google.com>,
	Joerg Roedel <joro@8bytes.org>,
	Joey Gouly <joey.gouly@arm.com>,
	John Starks <John.Starks@microsoft.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Justin Stitt <justinstitt@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Michael Roth <michael.roth@amd.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Oliver Upton <oupton@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Tarun Sahu <tarunsahu@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Tycho Andersen <tycho@kernel.org>,
	Vishal Annapurve <vannapurve@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Will Deacon <will@kernel.org>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Yan Zhao <yan.y.zhao@intel.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	x86@kernel.org,
	Shuah Khan <skhan@linuxfoundation.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	llvm@lists.linux.dev,
	iommu@lists.linux.dev
Subject: [RFC PATCH 06/14] KVM: guest_memfd: Report the size of holes in export lookups
Date: Tue, 27 Oct 2026 15:46:41 +0000
Message-ID: <20261027154649.91571-7-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261027154649.91571-1-griffoul@gmail.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
 <20261027154649.91571-1-griffoul@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B5E231C0010
X-Stat-Signature: 1cgujnpcg18zeznar93z3cqjfr4rwskj
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793116028-581724
X-HE-Meta: U2FsdGVkX198CCjcHWWgqBckBwxQ1yK9riNa2QqffJkxwCwTrjN4HDKdYN812log9yA+9gux6wST1Kf+3fl+CJ0UbT0cPoHNV9q9dbZfpfkGKwR7KftSIywaOtgiM4I5dC7uWIPbvLhWRk54iy9vtf5Oe8kf+y6KYg3j1B1D4dJKFXHF7k1w1nHrPmY1Qhn/52BcZZnvBWWaqP9t4m7NNTD9+PvjWQWFd6m1h5e+iDHZdwxYfItr1VkOoXB4DY+Sm9aQ5SbfWPDald0hBrAUIbf7vaOtkspO7jhpY6OWjggTQuoF0ZYVbtJHXTgQYqjQ0kBNiELtsy1WepXB3ROoa67oeMlhrUWgGlGAhixcMBLbkfouo5TAJjxULYc7iNBEoXHhx/Twh00t96A/nrsFYQYtNKC75Yny8+ZyAFasSjT7cJubUrUqB2NpsZKfedSawVAIKZf3mEN6LmyfJoy7EY2zFb80yfdMoPi6ErGI34khBPQ5FxDCmqbBW/T6lnZlHet/QKHEZlCAoJMiNhmkWOaxKnKPZFiZSNtDe9RjxR3Mmm0oVjzLAWLOlTotlcdwcHLmzgnvOWviJcLmqCnUO37Y4G39KpumN7qHTE+1Zt0bfkSJr189nHsx0zhp6sfD/8Gwo7bVKEfiiaLOPHHRZCBguAA8uQ1UCO5ZOuGpF1sLyi+M3oY7hkGhSs7bajhnBuS975fw7U7lNg2dNlX+4Hn8fM8wE0zE4xXHKH7Y8SgMs1YmsL/qblkOif8uy05X7JJt37NXqABKNNm5afx1HfEDVqGDC5Q/tJnOi/+fACy5+yT80ToYYKcRSZ+aqDAidgoGdw+stLK4lG5Q3L7+6RM1vhDeuP56lWIRKo7s0oUlgpHFRVARDVTArf+4UVWYdi3wKw0YgT/F2+0ddf9fBsczzk5YxPpQ9OpvJd6iuiO4lmDejsPw4Qa6ZnZIdw0JaI4zeqOmqvb9Ed1LxWh
 UPebBuHq
 6n8/AjidQmzmyoO9SVjtuZcrg7FbsZ78UkvJxU1ENM32fZ2azNMkUfi4h4TM/I5AdzrS5Q4hHa0Ni0BApJsmuXiCbGjdA8SG0+m1fa+WR6PZuMfY/Z7xEkuSS4scaCpii0Z9dR0KSE5pJEnCwj5SqVpQwwjam6xllqLLyIu9ncDR/lK4OOhzDVvHw1MtUil3SuBAFJXJWd/jcL0k20EtBTtYTh+lEA5KToKehgqe73MzqFSxc+wGh2w/MlauZ+IedJaTlw3e0OQFWcXwa09tvKOsE7FUs5kn7AVkIYixGFVrr84510LEdkylI7/0bSI2jQi0LZhYvfaKJxEZ459i4yaatqSgo+zqWF9DBQiqNsTejyYYQ2UP0tvqsREN0oPNKiYZ1ibH1XIKmnFsVnP5IIXFwm2YfGbZ9djdL9N7qdXODwfF5fdJQh6iOY/MuVMQpRGwD9gYTtYFqjdM9bZLWQnlbo+rP5nYiCzd+TJCDa8Aq0ZhQkgCHDK6tbbUpNKGSmr8YPXQtvcpX02ETgECLKk/QWsxybUFAmdkXZkjU0hia6ijEC1CyRRbf7MSsJ+4Mbxx/dmsguAFsl/m1lUVILloAuiO+2dUWPC49yNti+KG5T0AXerKH8sqQug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Fred Griffoul <fgriffo@amazon.co.uk>

A lookup reports a hole as a single page, so a consumer walks a large
private or unbacked range one page at a time, and cannot map a large
hole with one entry, e.g. to a scratch page.

Report the largest aligned hole around the page, up to the order the
caller asks for. The search checks one half-block at a time, so it
costs about one lookup per page of the hole it finds.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 virt/kvm/guest_memfd.c | 48 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 46 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 015f6657c386..1c5826c5384e 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -1417,6 +1417,48 @@ static int __kvm_gmem_export_lookup(struct inode *inode, pgoff_t index,
 	return 0;
 }
 
+/* Does no page of [start, start + nr) have a frame to map? */
+static bool kvm_gmem_export_is_hole(struct inode *inode, pgoff_t start,
+				    pgoff_t nr)
+{
+	unsigned long pfn;
+	pgoff_t index;
+	u32 attrs;
+	int order;
+
+	for (index = start; index < start + nr; index++) {
+		order = 0;
+		if (__kvm_gmem_export_lookup(inode, index, &pfn, &order,
+					     &attrs) != -ENOENT)
+			return false;
+		cond_resched();
+	}
+	return true;
+}
+
+/*
+ * The order, up to @max_order, of the largest naturally aligned block around
+ * @index that lies inside the file and has no frame to map.  Each step checks
+ * only the half of the larger block that does not hold @index.
+ */
+static int kvm_gmem_export_hole_order(struct inode *inode, pgoff_t index,
+				      int max_order)
+{
+	pgoff_t npages = i_size_read(inode) >> PAGE_SHIFT;
+	int order;
+
+	for (order = 0; order < max_order; order++) {
+		pgoff_t n = 1UL << order;
+		pgoff_t first = round_down(index, 2 * n);
+
+		if (first + 2 * n > npages ||
+		    !kvm_gmem_export_is_hole(inode, index & n ? first : first + n,
+					     n))
+			break;
+	}
+	return order;
+}
+
 /**
  * kvm_gmem_export_lookup_pfn - The frame behind a shared page.
  * @e:         The export.
@@ -1424,7 +1466,8 @@ static int __kvm_gmem_export_lookup(struct inode *inode, pgoff_t index,
  * @pfn:       The frame.
  * @max_order: In: the largest order the caller can map.  Out: the order of
  *             the naturally aligned block around @index that is contiguous,
- *             shared and of the same @attrs; 0 for -ENOENT.
+ *             shared and of the same @attrs or, for -ENOENT, that has no
+ *             frame to map at all.
  * @attrs:     The GUEST_MEMFD_PFN_* attributes of the block.
  *
  * Takes no reference and allocates nothing, and may be called from the
@@ -1438,6 +1481,7 @@ int kvm_gmem_export_lookup_pfn(struct guest_memfd_export *e, pgoff_t index,
 			       unsigned long *pfn, int *max_order, u32 *attrs)
 {
 	struct inode *inode = file_inode(e->file);
+	int order = *max_order;
 	int r;
 
 	if (index >= i_size_read(inode) >> PAGE_SHIFT)
@@ -1445,7 +1489,7 @@ int kvm_gmem_export_lookup_pfn(struct guest_memfd_export *e, pgoff_t index,
 
 	r = __kvm_gmem_export_lookup(inode, index, pfn, max_order, attrs);
 	if (r == -ENOENT)
-		*max_order = 0;
+		*max_order = kvm_gmem_export_hole_order(inode, index, order);
 	return r;
 }
 EXPORT_SYMBOL_GPL(kvm_gmem_export_lookup_pfn);
-- 
2.47.3


