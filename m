Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B4C2606FC8C
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 15:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cktTisMW
Received: by kanga.kvack.org (Postfix)
	id EF1496B07E1; Tue, 27 Oct 2026 11:47:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7BC86B07E3; Tue, 27 Oct 2026 11:47:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF4096B07E4; Tue, 27 Oct 2026 11:47:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 998C46B07E1
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:47:06 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 668BEA81EF
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:47:05 +0000 (UTC)
X-FDA: 85368834810.08.8FA648B
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf16.hostedemail.com (Postfix) with ESMTP id 94DED180008
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:47:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=cktTisMW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of griffoul@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=griffoul@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793116023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c+t2RCt7p+zsicFUGs0SiXsBnjjHZ+TU2eQo8OoRVfQ=;
	b=Oz81r4itVNZcbEE1/3MvQzF6CYqJcPTa6v0x2It69iAB2P4b6Q6g5996TKPdnwFpBkwSEs
	70e9bYs3PXpJrfZI7cV4oFW5Uol7PE+daeWM53MlAK1uvuLlWdH4T28tfl/PmPsi6XjbVh
	nWOb+BMMfi5yJWGFZU0ggyySbtupi20=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=cktTisMW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of griffoul@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=griffoul@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793116023;
	b=iA/YiiQXRVW5+SBO5Qiua+H2ujuBSAaiqmfIZ+DxSQ2jYAQr8EoSlamjB4p2/7ObCp8AkS
	mPSrRO1q7SB5crTC/wSZY0MSuRuqKUToQK4H06Oew/uyliyEhzgTfF/yCsZj3dEeXk9Rxj
	fNUMd0c3om7ldT00fJ43Ew+MeraSBKU=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-48c5358fc28so3887417f8f.0
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793116022; x=1793720822; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=c+t2RCt7p+zsicFUGs0SiXsBnjjHZ+TU2eQo8OoRVfQ=;
        b=cktTisMWa2B9jlkcPX2NHmtXFBST90If1LboXFjRXVhDpA+3J4h11b0tVHzoQCcIV7
         4sWZH0+rLdxIyMqDuJdSlt+bfmmVbLlKXlnrSJod+BH7HLVbBgqJ6z030RJejZWEuJYk
         2v0AruXK/APvLHCNwSmYJF5FcrpSQb5Z0rUbKCPUmSg4Z/Fv/TAHc+H0PorOGfVA/otm
         hVITsCgKdYIb/gMoY5Nq9rZKICNQVY/ry+IyTI4kyBQQU72vPqpyTcurKYBViBL15waG
         VgyggHqj/3BFZ5HD68k4F/Bj5Jj0PldE5bR2IRLElgM3jLube6jhYVH5HHK+qdtZXlXI
         h+Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793116022; x=1793720822;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=c+t2RCt7p+zsicFUGs0SiXsBnjjHZ+TU2eQo8OoRVfQ=;
        b=mTxyIaLnVb9QUmVcymnNuBn0p5FVSa+mimtGFIcGjtT/ULx/8bsBWM79OduA/JpXxR
         BC0ea5AIvbHlPSwDYqA5zY6jyNJVtyNxIXKCDwIlY6RuF2d9gBv0YJ8UPD4D6P0zEcyX
         t5TAq8fGkSESTmS00VJv5JjVpHifOOMXOmkUgdRtcVMr3orjXy9n/36jbJGjwSWziwo1
         9iLWj1Nh+8kKafrgWvK/DREeN585DLvWXIwAQJoEGx3z8knsnusj32FLPv1ddkdhYsHC
         yU6JohJRB2EGU3TrAeGiONK5I14rEW8Bqfzuzyx+Ol/1CgayZpyURR5F9RMa5uh//wU3
         d0Bg==
X-Forwarded-Encrypted: i=1; AKwUvBzQWmYoOUFxquGCK2t4D8q/p9136NdO8yFUyg6wDF+ih0MqZzNefmHLydDePl4r7rx/Q9hu/RSppw==@kvack.org
X-Gm-Message-State: AFq9FYIJJQvseUNj1Nqp6gjOXXfb6lViVitZUVN9MYbaCD5k8rvO6VUu
	+W4gSZPNcGMt7tKl0vOkoBc70YzKY1yIRoxUDEDAVhUeCOYk0LHcMtGR
X-Gm-Gg: AYBFou0bLd3EgcKv3SMOe8BWD4QLDripZMTIIk0P+z28wdsUbfRR1BZ1D8r0DNx7FU8
	g0GgbFnmjx/2stYt3vZkyFfoMF1lzXDkDR3G1I6a0x6sj+deHKA8Joj2eD7qbK3vet3ufTW381w
	Fab6ymInCPhdCmWDwLEX22LQcIXWczKPnPQb2WEaDyxUBPSvtSJRomyUnee9cnYxKeaIyCQdvfD
	PnrRcRJ2TmpcvTDU4TeJoTFlg5upuv9It7iDHZPytiK2qDlp/VNxXZzPUruJ0WU65VEawIajs+9
	aIEM3B7ZzYCCmovPZ++xjYxXmJnfnpsd9W8sBVY9M6KmaCpHi6R6bGx+2/Gfgfywb7E3SxWcrWT
	qOyVTtk1LXyZEAICk1yBeJQbWmJOTs06t3wkOMCQEJtj/WJq5RMbip+DrBqUVm3MNzJ0rEFDZ+R
	xewqRg3piw9Niys5YDONQaBIreppiotsme/2gCmXRzS56HqUOsgCs9MECyYbtjcjLXCWUj66O/D
	OrbARUCsiNGkBZNlFXVWZ8APRNTc/sXYax+BAE6uWeTwjST7szzpeBg+5uAWDOxrhfRzBCzlCjf
	ZpxoZTaV+7PutPEn25u1DOdW4l0V7FMdZLQQ3SAuqeRHMDG2/nchXSNLZ5b5lcbPORoJ93Qx3aD
	RoCe8fJhOn33mCidzxHrVRa2I86q4hqEzpcSC1Q==
X-Received: by 2002:a05:6000:469c:b0:488:5d44:6680 with SMTP id ffacd0b85a97d-48e3eb9161fmr12046915f8f.36.1793116022012;
        Tue, 27 Oct 2026 08:47:02 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebcb958sm23845574f8f.21.2026.10.27.08.46.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Oct 2026 08:47:01 -0700 (PDT)
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
Subject: [RFC PATCH 04/14] KVM: guest_memfd: Keep truncated folios until the exports are updated
Date: Tue, 27 Oct 2026 15:46:39 +0000
Message-ID: <20261027154649.91571-5-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261027154649.91571-1-griffoul@gmail.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
 <20261027154649.91571-1-griffoul@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 94DED180008
X-Rspam-User: 
X-Stat-Signature: cy1mfezepfnykkz9syfifeamjy1yfs6r
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793116023-492167
X-HE-Meta: U2FsdGVkX19un7AtNTkQDx9daU/ejdJD7Ax6NAkXet2FoBW5Z0c9bsHI8yScuAHFt5OOPPabFMPZll4Q12RGRH4/j+o0nOjm2UEQ3AJ3FlUsMihRswkkwPPf8DvSH0EfK13ivNBHnPcnV2xp8vrSiwJC1bAd8DQENzxze20LzYC0bf+nmghtAwwCTUAp2rEWMsjhCtjELZZG4TKtSnwhu0abp+jOjvJW06ZDjZm9+XEcdo29spbaF7ptkCb9odDCfBthw8/UZa4fiEwGGCaQj2zzLW/ergG9e3Mf8+IJ/1kohSgr0t45XREVlqZj5mZiTAVdRM37ABfFldLhVjoogimg0oogyy83JnQ4aoOKfhSi9HwiziNXBs2mr4QFRqqvVjlDqYckuOaQMLItcEMSu/DxahL8USDyGmuqUOuSYIUlPxZ8VHZozIo4AbHrJziRreH/JbRjtWc2a2pWvIzitj4fVrYughBwn6RpOdxZ6bPz7fuCxZI/BEwOzz1E7k5jj1+16v6/DgPFAHZV64zvT2tYHnmH0m+CkOkr4Odcr0cYPFJoQ1N+x4+qrCxaXzrN5Gn9dCnZHnkS0v2lBSPocXo0Ms9lpwuyJyF5/JCFT316AsSI+hzROXnrKoVvIvtXErWH3XvPQbdeBPzUPDb80/CMCflSjsI9M/RM9A66y6lsO1DFUJGi3Ki1kfA8XiMEQA8UUSdaWH9fIdb8b8kw7nOshQ6bPM92LO4/PDn3MmA5kBRgjUkekcwlKOzY+02V7xlKMprTYhTaJj6ovvC4aNrlppUyce1IM96We6fKk280NlKJD0daz2pMd/AEWKQSBBzxg4MO7bLrvGePtM4L0tcYHC1SSuszEWfcuk0QTAIFWge8CU8P97MK961yAdFebegDnXcletCN/CpJe0CRLgb/mV5R1LxuFb8pIS88CG7pDStbCXvvsZGTf+8oM8y9vMdhyoO2zqXDut9G7vg
 RbLKMleC
 lEFhMYGEYYvIGaTXNH+UDtsIIvQ8AEOMzhgiJgukFCxcVZizfKDahqIXX3PtBrOSn30xQhYvdkc9DZWyFRBtGnP/8uJrTIh2nQrH6+fgiExLFCGoYYCr6Kzi+VQwkgRFx8RBfXdX2218xH1z3r9sWkOT0MYf+581i5unFI2M5DsA6XlOgEe8StykL6k2P6FrrORPwy1MdmIg8UI/RXWZPFtC7RNgABZBrsJUbyWhun9ha3nN2opoTejpRsItSCpmybLhrc4Pb+jCZka6ZHfZSD4gITbJc6VWZ57uAU/3Yq9bb2y2qzCul4vJq6JvJGEGNVEptyN5oNoHwsb/wyziWZzefAOlq72N9+IkIzD0uc+YZqtk2s7hBOcRuLm2GtUzc+qhQEhg53HJ2NAW0mtLw56MliQlmMMaOKCZcapSaBuBMHkywsWKsq24scP6qxPUg+tWgzmTS7PmoROwEEcKUhMWb2j4fh+PXPfIlQskJatfsqciIwFRs4XV31jA6FpulN2RoncPxpT7nQ0X8fooOKYpg23mRYMCR8cUOIRicZSeCF0MsO+nOccybZ3kL52kBz4e2qej639NA8RXgvNHEFZO3AAzHMOLq8h4dmjyzIBOGSpgz8/E5KMsD4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Fred Griffoul <fgriffo@amazon.co.uk>

A punch hole frees the folios it truncates at once, but an export may
still map them, since it holds no reference: a device would then write
into freed memory.

Truncate a folio mode range batch by batch, holding a reference on each
folio until the exports are updated, so that a folio goes back to the
allocator only once no device maps it.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 include/linux/guest_memfd.h | 28 ++++++++++++++--------------
 virt/kvm/guest_memfd.c      | 30 ++++++++++++++++++++++++++++--
 2 files changed, 42 insertions(+), 16 deletions(-)

diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
index fdf7f8404d6c..ba3eebb1ed1a 100644
--- a/include/linux/guest_memfd.h
+++ b/include/linux/guest_memfd.h
@@ -89,14 +89,14 @@ static inline int kvm_gmem_revoke(struct inode *inode, pgoff_t start, size_t nr_
  * A subsystem that maps guest_memfd pages, such as iommufd, can neither pin
  * nor fault them.  It attaches to the file, looks up the frame behind each
  * shared page without taking a reference, and guest_memfd calls its update()
- * whenever what a lookup returns for a range may have changed: conversions and
- * memory failure.  update() makes the consumer's mappings of the range match
- * what a lookup returns now: a frame, or a hole for a private page or a page
- * without a frame.  It may be called for pages that did not change, and for
- * ranges that do not follow the blocks that lookups report: the consumer may
- * then remap whole blocks, also outside the range, e.g. to merge them into
- * larger mappings.  A consumer that can fault may instead only remove its
- * mappings of the range.
+ * whenever what a lookup returns for a range may have changed: conversions,
+ * punch holes and memory failure.  update() makes the consumer's mappings of
+ * the range match what a lookup returns now: a frame, or a hole for a private
+ * page or a page without a frame.  It may be called for pages that did not
+ * change, and for ranges that do not follow the blocks that lookups report:
+ * the consumer may then remap whole blocks, also outside the range, e.g. to
+ * merge them into larger mappings.  A consumer that can fault may instead only
+ * remove its mappings of the range.
  *
  * Until update() returns, the frames it replaces stay valid, so a consumer
  * may switch each mapping to its new target in one step; once it returns,
@@ -104,12 +104,12 @@ static inline int kvm_gmem_revoke(struct inode *inode, pgoff_t start, size_t nr_
  * that needs memory to apply one, e.g. to split a large mapping, reserves it
  * beforehand.
  *
- * guest_memfd calls update() with its invalidate lock held, exclusive when
- * pages convert and shared on memory failure, possibly with a folio of the
- * file locked; so update() may only call kvm_gmem_export_lookup_pfn().  Under
- * the shared lock, updates may run at the same time, also for overlapping
- * ranges.  The consumer holds a lock across a lookup and the mapping it
- * installs, which update() also takes.  Lock order:
+ * guest_memfd calls update() with its invalidate lock held, exclusive when it
+ * takes frames away or pages convert and shared on memory failure, possibly
+ * with a folio of the file locked; so update() may only call
+ * kvm_gmem_export_lookup_pfn().  Under the shared lock, updates may run at the
+ * same time, also for overlapping ranges.  The consumer holds a lock across a
+ * lookup and the mapping it installs, which update() also takes.  Lock order:
  *
  *   guest_memfd invalidate lock
  *     consumer lock
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 81031483a1f1..65a951fa49c2 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -424,7 +424,7 @@ static void kvm_gmem_invalidate_end(struct inode *inode, pgoff_t start,
 
 /*
  * What a lookup returns for [start, end) may have changed: exclusive lock when
- * pages converted, shared on memory failure.
+ * frames were taken away or pages converted, at least shared on memory failure.
  */
 static void kvm_gmem_update_exports(struct inode *inode, pgoff_t start,
 				    pgoff_t end)
@@ -437,6 +437,32 @@ static void kvm_gmem_update_exports(struct inode *inode, pgoff_t start,
 		e->ops->update(e, start, end - start);
 }
 
+/*
+ * Truncate [start, end) of a folio mode file.  The exports map the folios
+ * without references, so hold the folios until the exports are updated.
+ */
+static void kvm_gmem_truncate(struct inode *inode, pgoff_t start, pgoff_t end)
+{
+	struct folio_batch fbatch;
+	pgoff_t next = start;
+	unsigned int i;
+
+	folio_batch_init(&fbatch);
+	while (filemap_get_folios(inode->i_mapping, &next, end - 1, &fbatch)) {
+		pgoff_t first = max(fbatch.folios[0]->index, start);
+		pgoff_t last = min(next, end);
+
+		truncate_inode_pages_range(inode->i_mapping,
+					   (loff_t)first << PAGE_SHIFT,
+					   ((loff_t)last << PAGE_SHIFT) - 1);
+		kvm_gmem_update_exports(inode, first, last);
+		for (i = 0; i < folio_batch_count(&fbatch); i++)
+			folio_put(fbatch.folios[i]);
+		folio_batch_reinit(&fbatch);
+		cond_resched();
+	}
+}
+
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_RECLAIM
 static void kvm_gmem_pfn_reclaim(struct gmem_inode *gi, pgoff_t start, pgoff_t end)
 {
@@ -499,7 +525,7 @@ static int __kvm_gmem_revoke(struct inode *inode, pgoff_t start,
 		if (put_pfn_range)
 			gmem_provider_put_pfn_range(GMEM_I(inode), start, nr_pages);
 	} else {
-		truncate_inode_pages_range(inode->i_mapping, offset, offset + len - 1);
+		kvm_gmem_truncate(inode, start, end);
 	}
 
 	kvm_gmem_invalidate_end(inode, start, end);
-- 
2.47.3


