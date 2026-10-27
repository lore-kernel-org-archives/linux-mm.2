Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4461606B822
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 15:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MbAnzdC1
Received: by kanga.kvack.org (Postfix)
	id 74FE66B07D5; Tue, 27 Oct 2026 11:46:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D7406B07D7; Tue, 27 Oct 2026 11:46:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 490106B07D8; Tue, 27 Oct 2026 11:46:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 119856B07D5
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:46:59 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8A2AB140A3F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:46:58 +0000 (UTC)
X-FDA: 85368834516.05.0445537
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf26.hostedemail.com (Postfix) with ESMTP id A2D1A140007
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:46:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=MbAnzdC1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of griffoul@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=griffoul@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793116016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pWprt0VFzCZQuUxRfAXX7XDBBCxPrrxztMBOVVS5Pdc=;
	b=KtgZxeIzeAnCIPuCrxL+VaI2RdRRuSmtjhljzkuiHqoC+cReTIzPt9Gmx5ENRD+IzuCkmM
	aMdtNPK03QLFFUQTKCq/OCQL1lLA0ca+wUQRoXSmqwGAk2A3plwwXCMTt19L+fATbohyIz
	b/UhZw8gExUeURIA25kCCQYt3OK4OgI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=MbAnzdC1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of griffoul@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=griffoul@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793116016;
	b=WQkBI2KrizAz4CyQgaekmgFdoW2TdAwVuvvrGlKVPGv+vYbN2P9GTbZ9LSj4MCDFMQyOoo
	03gtGUVoXJnaMDhn5/PsMAc/jfyPfjD5lWnTLnMpNVVgBtc6uXmeRixTlpfb+fKlMqCjGL
	ibTiwK++Aea7NghKCKXVQKJOhERQbRQ=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-48b060ec084so2832983f8f.0
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793116015; x=1793720815; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pWprt0VFzCZQuUxRfAXX7XDBBCxPrrxztMBOVVS5Pdc=;
        b=MbAnzdC10dSbUeEiuBBjH3vNWcaf72SJRWP8z99tUYZSql77+cbTaMXrgf7Cx3okII
         R4O6ar6aUPRSvkQAdlF8/2/Au7Fi++S1AUsRfCbc1zX75Y/TigZVa22Daw2LREKgLGZ9
         O4wm3JAz9afsssJIpIVpvJxoAUkX232giAuWQCMbqfxQtTqAUtcBDSbxYTVwL9D+xdno
         IvAK0yN8Hju20ft0XdA8xmUkAmE8dgN06TPWWa6d7Bkf3twsdhAJFfmD40kEQ3CwFU7X
         UALNAknBWHkzl9ZwE8u1WBRKooNI8c1Ybkud5/vkAzW/QLyp/kdjkF5D6hl/OY/fW+xA
         IaoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793116015; x=1793720815;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pWprt0VFzCZQuUxRfAXX7XDBBCxPrrxztMBOVVS5Pdc=;
        b=JQRceqjgkzb1uGnA8IewJHXacThmGHPjL/NeuUVoHpaJc8zF7xCOK5ZMOFln0ImspR
         YJqHk9DtgGTvcGsXgHzTg20ZBbJPV4ipnniXkSjGrGdiyP3PVcnFr7kNR4xRAMa+HK4J
         /PMYCBTqcWG4rpKi/4BLm2N5Ugsp/b39gtIlxV4ry96dowiaTkMg6Vf2KvjEBv3HLkdE
         cq5OLGIncCyhROWgTfWdn4ZQrCTL6eaikI/QW9GA+pXvq8L/GjSZ4oXl1pGbxqRcdUop
         hah1roD7Vs468YPQ9Kgpx6SihxLe/CVtbRJHJ0hIsHyY7aW6JksbI1g4BpS5c41djzfN
         /U8w==
X-Forwarded-Encrypted: i=1; AKwUvBxiFVoWYQ1o2pAyNTnUc44dmcv7FkCBaiY7CkKw1krWXO/8s4NqUEIfFgwdHcUt+xByQugv7sZZSw==@kvack.org
X-Gm-Message-State: AFq9FYLtZN5No6IlZDMb1kUkmmJh3wmRagvZgQ/IeLNWadQkZG9NqaC+
	g3FF4mb5grskVGGnyd2QQCq1gU3A7NUwMPlbOilG8javlH5zXS4J/0QC
X-Gm-Gg: AYBFou1Xj/mNiidHO4z7qRwEv3ePRb4LxD4pXM6Y4k37hbbdCvLwn1pN/frJQGaSn0A
	teScEl4Tc/XB0mF3BnbmylqfcIGdHg+wtrFFENXQ6lS09U8JTys6+TU4vJ9EajAu2l0pf30RJoB
	BnDQQmdUqA6L3b6xom9mppxoIaTAgBuiQvWTF4eJN7dYhWdPLs6BTNpDMZrFflCZKp1xqIVArS5
	OPVlzlnMP8ITVlFkWNuD31+XlRj8DiwrOOBMGl/Z518bG87zsYE3lHkh6JcjJJhJZCyaKG6m8tI
	gGdo2So+bUG0LPsLcDL27i/Tk+FjWuwQ2vL24Mo3e58cVNSZkBklKGzoqSeJlBLa+RfJil5fkNv
	x/xVPxsQRlazfT3dEt3i/CVTYqy7Qn9xvDkx5tJ/2b1VpQ07Yzw6ceLHuLtXBMdqE6olOhdwmLo
	54Ajvo60ZZaDRQa4i0Xj6Sv5vZFl3dRBU75OaP+q/PAtdXe50yB9WvwJiMDe+xSQ4DhJyRLQLaM
	zGGR9nrIXbQPO7bHGc0wXabib9Rue6ngFQ91/QCCCfpk9bdByJfAV8tg0Vw7bQAeRM2idZmj8/i
	kkNJpahdCotLdInYAyXASyehGE0AwLeRLe3Jrsgo6xFmhJ7+LNTt8mqvdeZsUlVVsHu6H9De7t6
	FwyIAcBP7l1U5+obyCw==
X-Received: by 2002:adf:e282:0:b0:48e:c0:9441 with SMTP id ffacd0b85a97d-48e3eb93390mr14113375f8f.29.1793116014709;
        Tue, 27 Oct 2026 08:46:54 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebcb958sm23845574f8f.21.2026.10.27.08.46.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Oct 2026 08:46:54 -0700 (PDT)
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
Subject: [RFC PATCH 01/14] KVM: guest_memfd: Clamp the order of PFN mode blocks to what KVM can map
Date: Tue, 27 Oct 2026 15:46:36 +0000
Message-ID: <20261027154649.91571-2-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261027154649.91571-1-griffoul@gmail.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
 <20261027154649.91571-1-griffoul@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A2D1A140007
X-Stat-Signature: hwozbwrpt97b1x68aoozozjhuqfa4c3k
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793116016-414033
X-HE-Meta: U2FsdGVkX19l4C/XmmDUYgHmxJx/xJbY/+/99wRokNjsIOIsCgakixcMc3K+zB2y/TSFEiamdzMTLQ/NipQGAM56OAimeXMqnK27Fx3HZsUq4wd0Xt2CdYlubfFFI0yloJg8lJ9WjW2VQOVfDY40iwuO93pU8EyfcyKMYzi4foT3o854iNy4Eur83oQA1EYSDqILm1/50wzaDcYCl/InjXRRCpDulDojGmNkNsUAtK/eL96iwUYlQBEtKPdPO+e6YmG+b8e2Nh2sIHNCln2XYzNvkvrOUA5s4odVvMK0EnyQNd9jLVTfjyU/wGGGVKik0W4DSRQt6WyeNJABjh1Fla6F5JdR7s1g7HNgLzd8nu+ZEwowg6vWIxS70IQxPtlC8VAsrMzu7JYedtSOqNNu0KDWfcVXq9DtN1FhIS8TQOG/0C3MuYzZ9BHZru4OwEYxx9WfXIYhNG0IvAkn3RfKFdjnEqPIs94q226fKGCB0/bgTZJbm/oT5ZSR7ntdEQGCRlHPc8I02sxgObEPXgXujdBkt5FO3nXCnbyC2unMu7xNNO8DTbabwaD4uoMASrYgpgd1e8C5+gpb8aEcBgUyKpyP/q6vxCpxIDLyny9HKIKIwX5HCLMzq3L5ey0ZDBNwqilC4TJPUNhWKA+QFiFWIooTZqr3CSaC+XC/uQ6E4kMb6NszIyRK/iHJ7TyF68mWmT/0NbPkHj0YmBFrOSkh+oi4yJYE3L82SoB/1mpUweG8tyzKAhvAd7XKcq+lak1/OX8VibE0vZkWyogVelL6VXjorPZ2rxAGA0ntIJ1NFODtRAJ5CUcAkaI0vW+ZSEOv7T3of+q5OCeuBV18FALBls1Y3dvFs4eQms6qrOkziMhLHov0PmsAp0+a+tKsjRrKEKJOj3xGMeMZVbERb/7GITWo0nnRS0Jvog00uIt2w8/nQ8QiQAt1cx9iO6Ya8nsxUgaEWsJUyWOGQIpKxKP
 pCvVgRsB
 7nXhEX9I/kGQFAWpChpnbxc3e8piCLWjn79yq0+beEqKj65IjxW3VssoNLRrv/LCimfSKaZ488/Ye8EeLeti+95Oot/peYg3niKUje3NcLFiSv8s/udj8qsR4fYp6s+HHIbzYkDEx2u0a3j/1oS5HjDd6XQzY/clQmdCk7YDiKRZjH4FCKrhRMAz9rtoPzF8XkKn1AAQscwcqKwXWYLNf0nCW0XhfIonOIdK9fIfW/tGPQwbF6KYQG3TnZKUELAIYhP3wUZRktU9JEvQxvZnQC/nqI++ZOfzBYHylEK1lRRrdR2qRknP863loQ/ueTRTv/XlTjkkWf7ew1pImUf0rvpHfGFd7MJCXJBI0CCMlF8woChEN2bAJV0s93pYgZpc4nDpPRYCA4yXrP34vWzcgpacWWT55bbQl/SiWFTzQpmkMgJY7itjLJbxtJ+w2en6NouUAsSnG+9k1An6X5F5ilpNgQNNo9TYY07Jh7ST1A7xLOz4+aIrNZQD/GQ6oFYScedxYGSllfiu02iqqgkxIcmrnQLZd6FFZqopIwDwCsbfsP5G5bZsb3vZ+kB0vNIUQTcWM/jRsK7XvmQ5j+nKpScjpxCVKLnhXOcx6JBNSqMkHukGMksIbOmWlMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Fred Griffoul <fgriffo@amazon.co.uk>

KVM maps guest memory in 4K, 2M or 1G blocks, and uses guest_memfd's
max_order to choose. A folio of order N is physically aligned and never
mixes shared and private pages, so the order needs no check. A PFN mode
provider's frames need not be aligned and the provider does not know
which pages are private, yet kvm_gmem_get_pfn() passes its order to KVM
unchanged. KVM can then map a block over the wrong frames, or with one
attribute over shared and private pages.

Define the provider's order as that of the naturally aligned block
around the index, preset to 0. Clamp it to a block size KVM supports,
in which the gfn, the index and the pfn are aligned alike and every
page has the same attribute.

A fault that sized its block just before a revoke or conversion of
another page in the block would not retry, since KVM only retries
faults inside the invalidated range. Make every invalidation of a PFN
mode file cover the 1G-aligned blocks around its range.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 include/linux/guest_memfd.h |  5 +--
 virt/kvm/guest_memfd.c      | 63 +++++++++++++++++++++++++++++++++++--
 2 files changed, 63 insertions(+), 5 deletions(-)

diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
index 3e2c0714ca33..a38a81693422 100644
--- a/include/linux/guest_memfd.h
+++ b/include/linux/guest_memfd.h
@@ -21,8 +21,9 @@ struct mempolicy;
  * @get_pfn: Obtain a PFN for a given index. The provider must ensure backing
  *           memory is present and is responsible for its contents, such as
  *           zeroing if necessary. On success, return 0 with the physical frame
- *           number in @pfn and, if @max_order is non-NULL, the maximum page
- *           order of contiguous backing memory containing @pfn. Returns a
+ *           number in @pfn and, if @max_order is non-NULL, the largest order
+ *           for which the naturally aligned block of 2^order pages that
+ *           contains @index is backed by contiguous frames. Returns a
  *           negative error code on failure. The provider must define
  *           @lookup_pfn_range when @get_pfn is defined.
  * @lookup_pfn_range: Look up the PFN for a given index. Returns 0 on success
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 3c4bedceccfc..be26bd16d420 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -147,6 +147,8 @@ static int gmem_provider_get_pfn(struct gmem_inode *gi, pgoff_t index,
 	unsigned long raw_pfn;
 	int r;
 
+	if (max_order)
+		*max_order = 0;
 	r = gi->provider_ops->get_pfn(gi->provider, index, &raw_pfn, max_order);
 	if (r)
 		return r;
@@ -326,10 +328,13 @@ static enum kvm_gfn_range_filter kvm_gmem_get_all_gfns_filter(struct inode *inod
 	return KVM_FILTER_PRIVATE;
 }
 
-static void __kvm_gmem_invalidate_start(struct gmem_file *f, pgoff_t start,
+static void __kvm_gmem_invalidate_start(struct inode *inode,
+					struct gmem_file *f, pgoff_t start,
 					pgoff_t end,
 					enum kvm_gfn_range_filter attr_filter)
 {
+	const gfn_t blk = kvm_gmem_is_pfn_mode(GMEM_I(inode)) ?
+			  1UL << PUD_ORDER : 1;
 	bool flush = false, found_memslot = false;
 	struct kvm_memory_slot *slot;
 	struct kvm *kvm = f->kvm;
@@ -355,6 +360,16 @@ static void __kvm_gmem_invalidate_start(struct gmem_file *f, pgoff_t start,
 
 		flush |= kvm_mmu_unmap_gfn_range(kvm, &gfn_range);
 
+		/*
+		 * In PFN mode, a fault may map a block of up to PUD_ORDER
+		 * pages, sized before this invalidation (see
+		 * kvm_gmem_pfn_map_order()): make faults anywhere in the
+		 * blocks around the range retry.
+		 */
+		kvm_mmu_invalidate_range_add(kvm,
+					     round_down(gfn_range.start, blk),
+					     round_up(gfn_range.end, blk));
+
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
 		kvm_arch_gmem_invalidate_range(kvm, &gfn_range);
 #endif
@@ -374,7 +389,7 @@ static void kvm_gmem_invalidate_start(struct inode *inode, pgoff_t start,
 	struct gmem_file *f;
 
 	kvm_gmem_for_each_file(f, inode)
-		__kvm_gmem_invalidate_start(f, start, end, filter);
+		__kvm_gmem_invalidate_start(inode, f, start, end, filter);
 }
 
 static void __kvm_gmem_invalidate_end(struct gmem_file *f, pgoff_t start,
@@ -670,7 +685,7 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 	 * Zap all SPTEs pointed at by this file.  Do not free the backing
 	 * memory, as its lifetime is associated with the inode, not the file.
 	 */
-	__kvm_gmem_invalidate_start(f, 0, -1ul,
+	__kvm_gmem_invalidate_start(inode, f, 0, -1ul,
 				    kvm_gmem_get_all_gfns_filter(inode));
 	__kvm_gmem_invalidate_end(f, 0, -1ul);
 
@@ -1535,6 +1550,44 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
 	return folio;
 }
 
+/*
+ * The order a PFN mode block can be mapped at: the provider's order, no
+ * larger than the alignment of @gfn and @pfn to @index allows, rounded down to
+ * a page-table size, and never over pages that are not all shared or all
+ * private, since KVM maps a block with a single attribute.  Called with the
+ * invalidate lock held; an invalidation of any page of the block makes the
+ * fault retry (see __kvm_gmem_invalidate_start()).
+ */
+static int kvm_gmem_pfn_map_order(struct inode *inode, pgoff_t index,
+				  gfn_t gfn, kvm_pfn_t pfn, int order)
+{
+	u64 misalign = (gfn ^ index) | (pfn ^ index);
+	u64 attrs;
+
+	if (WARN_ON_ONCE(order < 0))
+		return 0;
+
+	order = min(order, PUD_ORDER);
+	if (misalign)
+		order = min_t(int, order, __ffs64(misalign));
+
+	if (order >= PUD_ORDER)
+		order = PUD_ORDER;
+	else if (order >= PMD_ORDER)
+		order = PMD_ORDER;
+	else
+		return 0;
+
+	attrs = kvm_gmem_get_attributes(inode,
+					mtree_load(&GMEM_I(inode)->attributes, index));
+	while (order &&
+	       !kvm_gmem_range_has_attributes(inode,
+					      ALIGN_DOWN(index, 1UL << order),
+					      1UL << order, attrs))
+		order = order == PUD_ORDER ? PMD_ORDER : 0;
+	return order;
+}
+
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order)
 {
@@ -1556,6 +1609,10 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		goto out;
 	}
 
+	if (kvm_gmem_is_pfn_mode(GMEM_I(file_inode(file))))
+		*max_order = kvm_gmem_pfn_map_order(file_inode(file), index, gfn,
+						    *pfn, *max_order);
+
 	if (kvm_arch_has_gmem_convert() &&
 	    kvm_gmem_is_private_mem(file_inode(file), index))
 		r = kvm_arch_gmem_make_private(kvm, gfn, *pfn,
-- 
2.47.3


