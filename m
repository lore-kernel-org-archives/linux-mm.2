Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC9A760A2637
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 15:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vZ/BNf1n
Received: by kanga.kvack.org (Postfix)
	id B212E6B07DD; Tue, 27 Oct 2026 11:47:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD1016B07DF; Tue, 27 Oct 2026 11:47:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94A5C6B07E0; Tue, 27 Oct 2026 11:47:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5FC646B07DD
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:47:03 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EC93F1C4463
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:47:02 +0000 (UTC)
X-FDA: 85368834684.25.07ABF83
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf06.hostedemail.com (Postfix) with ESMTP id 26FEF180005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:47:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="vZ/BNf1n";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of griffoul@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=griffoul@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793116021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MS32UDs32IiiGErF/wdTg5BmBPNKRICu6EiQ04Jmka0=;
	b=K3VAvXkDx0uzdN/ALCAF7/YEWb/8LDVZuL+BGlDI7vviKu9KCK4iFWEAMFTgTspJJrHFN3
	wcXmAkA17rw8y3coSh+ULit2/kdZrSZlkxtYqjDjHsgJHPW7z9ipii9xxOq3RyqR4/Y3We
	MQi1sCm79skI6crDfYsZ5w3SjKOwN68=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="vZ/BNf1n";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of griffoul@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=griffoul@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793116021;
	b=kK87WvQT+kny9XWdK4b5Eljkge+YxqFhoYXun50A4mgMGg/HbeISf58xIpUknWSlG0XSa+
	6T/vbBzUlEdG/zQRq75Uzj3kptxywTFiKKaWhcoomdPB6+LMARUoMfHM2M/Mqg15QILtHz
	uqk1aOEmghOM9alSZz6aMxF/oi0okd4=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48b042c0728so1233688f8f.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793116020; x=1793720820; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MS32UDs32IiiGErF/wdTg5BmBPNKRICu6EiQ04Jmka0=;
        b=vZ/BNf1nGfsrHp+35j0uBWJbQqRv2j0SdpwzMx9V4owsr8uefOzaXBT5KQq58KVhBX
         flGreIUnd2aWbKH1fKc+Gbtg3MQ/ZHRSsRqOGIMLjiUnWh3wugUHSMhq7a6lUyE46X+x
         ABEGbHR+hXkZtlQzTg7uTrK8QH6h6a8aZC9/lToDlWD5O0WUtlX9lEMSx1zaj1MmQWrl
         b54+TP5qqCoFhxxniVkVr7XxC1mK/BEKc6MM35KEX9hMQiHvvT63wDvEYDf5nUVBTWQJ
         2E/k2vVASKkNMm9oZufRpSSEjkgQaA1DKYt/7Yn/hrvjtIZgOlPEHnoKG0TQjI4rgNWT
         E39Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793116020; x=1793720820;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MS32UDs32IiiGErF/wdTg5BmBPNKRICu6EiQ04Jmka0=;
        b=1AW9B8jBvWJXnNresoKdv4vqy490Q1hsBvgDTd6+bghnQ65b2bdmlKlU9ArhwcNMAR
         HnPPvKrWYjkCoMlxib9rsUOjsY68CBdXSIdBgJCa6qc90A/seQ3mdgUl/lH2E64VweUG
         J6JnO70KMsliVasFr/Jr9kcpoqPymT2qYNAwZR2C34PI+RpgSgpuytpPF3i31tJZhRZl
         8r1griSz/9PN0n1mvIr9i62EmnbsPMLjQkgMbu1DGp2qHbmvAI1XzlYRsXaLONzLvv5S
         Hp8AxvL+zwo+Vi62vixYlUEABxeVVbFjl6lJcJgNAVTssGXmoLeeouLfwm7IuEc0Oalo
         hR4A==
X-Forwarded-Encrypted: i=1; AKwUvBw25s8SEbXmZcWPW9QSQ3+3bMdwikEwfVWUoYd6cZ6z1kD129z1pginteYgNuI9JOPyP9K5fNHFmA==@kvack.org
X-Gm-Message-State: AFq9FYKYDQ88maAvNFublT99mTHaNsm4c1yfFAtnhBPYXLb1mT8TRG9Z
	NgKICc/vVCcNrWUGgwJRPLNDdjl00AFlt/uicqpXM4fMpy/woaReRNsq
X-Gm-Gg: AYBFou3yWD+OZHoNQEdyfQh5kaEwvxfsB8cTktrkNQiQJMoA8XAsiilXbsCrhdaXURq
	+r2yjrL3Un1NqFrCoZKxuvQVrO3ICNoj0t6UrUqBg0wtkUM1X7ykoCetE+Db7Qe1y9GXOmXRrOl
	1twLFPJJ6q4MCx1KBB0sYxUfvnIkGNLOKvb8jjKU2tIcWTgYzW4weD8dX6MR05FJ+C4ZV8nYIVp
	f8oDCYffroR2kr5A26/VUDVCsXyfVYQJcwFziJfUWjZqVzsYfWEwdfE6Rk4cADKXdSKTxgYp5Qv
	V5IyAzukxG1ny+B9cEPo3ZE1Gtw72HzgDG31fz1t2D1EDyiM9qkP9CWOldyLIaPiqvrlfgpz90P
	Yfy2nqCzFou456IOgTEMPN340xO0dBem/zNDzLT8ziiqxHF6vxj7cd3p1B6XTUBI+7FcSV/m8eE
	ugT8UZv8HyHiFIs9iRydifJlXcgrtr9lKIPUpeDnInP8iiPbC1owDofWnPmyxVyGct/ALy37GAi
	9HN+kxdZbRMVrRA26jr3BP0YZyFl6FWoHJ3VqOs25I6YP7eR37GsF/SCT7SrDirNn4ZoxjL7z5/
	Of+OBDMGrY5tdbi3693/e3peQpJG1KXO23AUdG+LsMRQB0FoHdmO7vemqfyuNdWJZOFRl40z7HT
	O8TwnBRyA4YzUhCsI7SqOoWi8mYhj+LC52QH7OQ==
X-Received: by 2002:a05:6000:2887:b0:482:fd9c:3740 with SMTP id ffacd0b85a97d-48e3eb925d0mr20061072f8f.22.1793116019635;
        Tue, 27 Oct 2026 08:46:59 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebcb958sm23845574f8f.21.2026.10.27.08.46.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Oct 2026 08:46:59 -0700 (PDT)
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
Subject: [RFC PATCH 03/14] KVM: guest_memfd: Allow other subsystems to map guest_memfd files
Date: Tue, 27 Oct 2026 15:46:38 +0000
Message-ID: <20261027154649.91571-4-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261027154649.91571-1-griffoul@gmail.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
 <20261027154649.91571-1-griffoul@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 26FEF180005
X-Stat-Signature: 9gq9gm1cru9ijit3ikikn7aa6sdes14p
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793116021-712037
X-HE-Meta: U2FsdGVkX1/iTlLR3YCZqgEt3/bcF5iFDcadcNbzw1TyRCc116fCp+luf0hHerGde2Sa6RDivFOgyZuqIvQuDlmN5udLm4l0mLsJNkVBZuLCR5xAl/Pql4evOvGUDpnaTi7/an6xjuHk9xiqWBm/4qn68R5OWtx7qaycY7Og3yg15Hl9HqLweOKFMsnObaQ7peMYuVjo7NaDZOwISCG5qYZmeQsOheZvxtultcqUjGJSlHjLakcnub5BDRwYEzI9mLxBTVYv19hW1oKhb2C/g0TwhBQD0r6GG4RJz9IDSn1kVnFjtxSoyD12MR93F4yL+9n/HPKokxvc8eRQ53Ft3bm8zVAsnCny5Shbli3BdMVwL+iU4aja6sIM364UF/eqBt/2lb7OY0s4MXGwPW/oOlW5lz97nIn9eaxDKdNREYCz+aUUKQqHGykmTcg8t8y2AtKhpJ0Ob0uH4+TUj5qu1dDgcblwctkCAYKKNtycvPwNvUkgbnjuBUSZF9HThH1yjoMiaSU0hHJrZEOYURUJy45o4tAPCsRlSK9SEYm298goxDhxhmCNNdgqIbEmxoFfbKwoedL0dbPUzeDk6P+eSN2SzdTCMlxmm3FsBsgEuGyRPAcIXWz+ws3XSvkzx3TpqUX+pi4GtZ4HMzG4ak+CdJTwWvkHXLa/ETwP8G725/PFhsl/hXBxhDhZpPsne4+05mp/7wS+gz0sifPxAGb2zNrooD5Hk5KqWT7nNP4bbsq8om89Pe//06ZsS1ZeOGgquSAN8GgEILh+gbqFmSn6IZ5QoMqKJJ+kJXQXjdij4wC6SNrgHnvhmS8U2TrmtCvgYSoEhJqM+wNcT1RMcC7LzvjyfZwfAK4xVotkoGaIWuPUFHfaTahZCuxQOmJx6mxRGFrkqqn8ulBMj0EaWZj8t053HXJA6fZ3fL4/T0bOe05o/A/wrEKSCzdrkiQY867Lz02aPyN+bQ4MoRvFnCO
 v1wWIJCk
 L16t1l8mMq68eUTKxZU5Wcf7abAlaJMvCUMkQG5CrF79xsldKBk1ZX3s2HzjfsAZnJlds3iG2Ufgt4XDQdfALgCQSem6RJDNCu2iywpPLqIpNoAlkIqVJ5I6Do9OMiD4qF9FFJpCEb0Qdyb8WzdPqxDWQwT1N8Wy4ULcegrNRGbB+plsGQKpasW5dUKqLT5ca5GZd3LmuB7NBc9FELGaCxiyY7hIQeAAwmQIv6WSgR7NQcoIug6DFx5Uq5QqsiuMqrFS6FGiv8ckaNhRjXeB5qDoB0ySZYkfDeZ6ZYI+X1mWbJA1nNqukmm7OhHYgMchpOb7pkxBo1rOTpU5kKilXdUVMoK8TbHBgNKvm6BYekWjs3+4k1DYXMhqGWMnlARRXhwc9/X3mv1RyNL7SpJs6Pt8/cD3jRJHZFu+aZtc01inbOBMc0Gc9353rGmM3punekNPsSBu7dTFlzLf2SNEJ+KfrbmMx1fNT+6a7quqhw1a745sNFIKf55JMHMERjHKCzQsjz3GxfntyHTR049/oCHguFEVPRUxZOnI3Lzf0DRLT9MgjLiw5wvrxE17W46iypFaQ/NPkU/DorVJY2Z4O+DrMVcCklUCDVAQLIQrF9aAHEvNoR9ifIpvd8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Fred Griffoul <fgriffo@amazon.co.uk>

A device assigned to a guest must map the guest's shared memory and
lose a page whenever guest_memfd takes it away. iommufd cannot do that:
it pins what it maps, which guest_memfd does not allow, and a device
cannot fault.

Add an export interface. A subsystem attaches to a guest_memfd file,
looks up the frame behind each shared page without taking a reference,
and gets an update() callback when what a lookup returns for a range
may have changed. The old frames stay valid until update() returns, so
a device that never faults can switch each mapping in one step.

update() is called on conversions and memory failure; punch holes, PFN
mode and pages that get memory follow. The functions are exported for
symbol_get(), since KVM may be a module while the consumer is built in.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 arch/x86/kvm/Makefile       |   3 +-
 include/linux/guest_memfd.h |  55 +++++++++++++
 virt/kvm/guest_memfd.c      | 149 ++++++++++++++++++++++++++++++++++++
 3 files changed, 206 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 5fd01bd19d1c..25fb3d6e2032 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -62,7 +62,8 @@ exports_grep_trailer := --include='*.[ch]' -nrw $(srctree)/virt/kvm $(srctree)/a
 				-e kvm_write_track_add_gfn \
 				-e kvm_write_track_remove_gfn \
 				-e kvm_file_to_kvm_fn \
-				-e kvm_gmem_revoke
+				-e kvm_gmem_revoke \
+				-e kvm_gmem_export
 
 # Force grep to emit a goofy group separator that can in turn be replaced with
 # the above newline macro (newlines in Make are a nightmare).  Note, grep only
diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
index 9d8764b93af2..fdf7f8404d6c 100644
--- a/include/linux/guest_memfd.h
+++ b/include/linux/guest_memfd.h
@@ -3,6 +3,7 @@
 #define _LINUX_GUEST_MEMFD_H
 
 #include <linux/bits.h>
+#include <linux/list.h>
 #include <linux/types.h>
 
 struct file;
@@ -82,4 +83,58 @@ static inline int kvm_gmem_revoke(struct inode *inode, pgoff_t start, size_t nr_
 }
 #endif
 
+/*
+ * Mapping guest_memfd files in other subsystems.
+ *
+ * A subsystem that maps guest_memfd pages, such as iommufd, can neither pin
+ * nor fault them.  It attaches to the file, looks up the frame behind each
+ * shared page without taking a reference, and guest_memfd calls its update()
+ * whenever what a lookup returns for a range may have changed: conversions and
+ * memory failure.  update() makes the consumer's mappings of the range match
+ * what a lookup returns now: a frame, or a hole for a private page or a page
+ * without a frame.  It may be called for pages that did not change, and for
+ * ranges that do not follow the blocks that lookups report: the consumer may
+ * then remap whole blocks, also outside the range, e.g. to merge them into
+ * larger mappings.  A consumer that can fault may instead only remove its
+ * mappings of the range.
+ *
+ * Until update() returns, the frames it replaces stay valid, so a consumer
+ * may switch each mapping to its new target in one step; once it returns,
+ * the consumer no longer accesses them.  update() cannot fail: a consumer
+ * that needs memory to apply one, e.g. to split a large mapping, reserves it
+ * beforehand.
+ *
+ * guest_memfd calls update() with its invalidate lock held, exclusive when
+ * pages convert and shared on memory failure, possibly with a folio of the
+ * file locked; so update() may only call kvm_gmem_export_lookup_pfn().  Under
+ * the shared lock, updates may run at the same time, also for overlapping
+ * ranges.  The consumer holds a lock across a lookup and the mapping it
+ * installs, which update() also takes.  Lock order:
+ *
+ *   guest_memfd invalidate lock
+ *     consumer lock
+ *
+ * A consumer attaches and detaches outside its lock.  KVM may be a module
+ * while the consumer is built in: consumers reach these with symbol_get().
+ */
+struct guest_memfd_export;
+
+struct guest_memfd_export_ops {
+	void (*update)(struct guest_memfd_export *e, pgoff_t start,
+		       pgoff_t nr_pages);
+};
+
+struct guest_memfd_export {
+	const struct guest_memfd_export_ops *ops;
+
+	/* Private to guest_memfd. */
+	struct list_head node;
+	struct file *file;
+};
+
+int kvm_gmem_export_attach(struct file *file, struct guest_memfd_export *e);
+void kvm_gmem_export_detach(struct guest_memfd_export *e);
+int kvm_gmem_export_lookup_pfn(struct guest_memfd_export *e, pgoff_t index,
+			       unsigned long *pfn, int *max_order, u32 *attrs);
+
 #endif /* _LINUX_GUEST_MEMFD_H */
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 1554a17906da..81031483a1f1 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -38,6 +38,8 @@ struct gmem_inode {
 
 	void *provider;
 	const struct guest_memfd_provider_operations *provider_ops;
+	/* Subsystems that map the file, see include/linux/guest_memfd.h. */
+	struct list_head exports;
 
 	u64 flags;
 	/*
@@ -420,6 +422,21 @@ static void kvm_gmem_invalidate_end(struct inode *inode, pgoff_t start,
 		__kvm_gmem_invalidate_end(f, start, end);
 }
 
+/*
+ * What a lookup returns for [start, end) may have changed: exclusive lock when
+ * pages converted, shared on memory failure.
+ */
+static void kvm_gmem_update_exports(struct inode *inode, pgoff_t start,
+				    pgoff_t end)
+{
+	struct guest_memfd_export *e;
+
+	lockdep_assert_held(&inode->i_mapping->invalidate_lock);
+
+	list_for_each_entry(e, &GMEM_I(inode)->exports, node)
+		e->ops->update(e, start, end - start);
+}
+
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_RECLAIM
 static void kvm_gmem_pfn_reclaim(struct gmem_inode *gi, pgoff_t start, pgoff_t end)
 {
@@ -1130,6 +1147,9 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 
 	mas_store_prealloc(&mas, xa_mk_value(attrs));
 
+	/* After the store, before a vCPU can fault a private page in. */
+	kvm_gmem_update_exports(inode, start, end);
+
 	kvm_gmem_invalidate_end(inode, start, end);
 out:
 	filemap_invalidate_unlock(mapping);
@@ -1204,6 +1224,131 @@ static struct file_operations kvm_gmem_fops = {
 	.unlocked_ioctl	= kvm_gmem_ioctl,
 };
 
+/**
+ * kvm_gmem_export_attach - Map a guest_memfd file in another subsystem.
+ * @file: The guest_memfd file.
+ * @e:    The export, with @e->ops set.
+ *
+ * guest_memfd calls @e->ops->update() from now on, and holds a reference to
+ * @file until kvm_gmem_export_detach().  May sleep.
+ *
+ * Return: 0, -ENODEV if @file is not a guest_memfd file, or -EOPNOTSUPP in
+ * PFN mode.
+ */
+int kvm_gmem_export_attach(struct file *file, struct guest_memfd_export *e)
+{
+	struct inode *inode = file_inode(file);
+
+	if (file->f_op != &kvm_gmem_fops)
+		return -ENODEV;
+	if (kvm_gmem_is_pfn_mode(GMEM_I(inode)))
+		return -EOPNOTSUPP;
+
+	e->file = get_file(file);
+	filemap_invalidate_lock(inode->i_mapping);
+	list_add_tail(&e->node, &GMEM_I(inode)->exports);
+	filemap_invalidate_unlock(inode->i_mapping);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_gmem_export_attach);
+
+/**
+ * kvm_gmem_export_detach - Stop mapping a guest_memfd file.
+ * @e: The export.
+ *
+ * Waits for an update() in progress.  May sleep.
+ */
+void kvm_gmem_export_detach(struct guest_memfd_export *e)
+{
+	struct inode *inode = file_inode(e->file);
+
+	filemap_invalidate_lock(inode->i_mapping);
+	list_del(&e->node);
+	filemap_invalidate_unlock(inode->i_mapping);
+	fput(e->file);
+}
+EXPORT_SYMBOL_GPL(kvm_gmem_export_detach);
+
+/* Are [index, index + nr) all shared?  Without the invalidate lock. */
+static bool kvm_gmem_range_is_shared(struct inode *inode, pgoff_t index,
+				     unsigned long nr)
+{
+	unsigned long first = index;
+	void *entry;
+
+	mt_for_each(&GMEM_I(inode)->attributes, entry, first, index + nr - 1) {
+		if (kvm_gmem_get_attributes(inode, entry) &
+		    KVM_MEMORY_ATTRIBUTE_PRIVATE)
+			return false;
+	}
+	return true;
+}
+
+/* What kvm_gmem_export_lookup_pfn() returns for a page inside the file. */
+static int __kvm_gmem_export_lookup(struct inode *inode, pgoff_t index,
+				    unsigned long *pfn, int *max_order,
+				    u32 *attrs)
+{
+	struct folio *folio;
+
+	if (!kvm_gmem_range_is_shared(inode, index, 1))
+		return -ENOENT;
+
+	/* A folio that was never zeroed is a hole. */
+	folio = filemap_get_folio(inode->i_mapping, index);
+	if (IS_ERR(folio))
+		return -ENOENT;
+	if (folio_test_hwpoison(folio) || !folio_test_uptodate(folio)) {
+		folio_put(folio);
+		return -ENOENT;
+	}
+	*pfn = folio_file_pfn(folio, index);
+	*max_order = 0;
+	*attrs = 0;
+	folio_put(folio);
+
+	/* Nor may the block hold a private page. */
+	while (*max_order &&
+	       !kvm_gmem_range_is_shared(inode,
+					 round_down(index, 1UL << *max_order),
+					 1UL << *max_order))
+		(*max_order)--;
+	return 0;
+}
+
+/**
+ * kvm_gmem_export_lookup_pfn - The frame behind a shared page.
+ * @e:         The export.
+ * @index:     The page index in the file.
+ * @pfn:       The frame.
+ * @max_order: In: the largest order the caller can map.  Out: the order of
+ *             the naturally aligned block around @index that is contiguous,
+ *             shared and of the same @attrs; 0 for -ENOENT.
+ * @attrs:     The GUEST_MEMFD_PFN_* attributes of the block.
+ *
+ * Takes no reference and allocates nothing, and may be called from the
+ * export's update(): the answer holds until the update() that changes it.
+ *
+ * Context: May sleep.
+ * Return: 0, -ENOENT for a private page or a page without a frame, -EINVAL
+ * beyond the end of the file, or another error from the provider.
+ */
+int kvm_gmem_export_lookup_pfn(struct guest_memfd_export *e, pgoff_t index,
+			       unsigned long *pfn, int *max_order, u32 *attrs)
+{
+	struct inode *inode = file_inode(e->file);
+	int r;
+
+	if (index >= i_size_read(inode) >> PAGE_SHIFT)
+		return -EINVAL;
+
+	r = __kvm_gmem_export_lookup(inode, index, pfn, max_order, attrs);
+	if (r == -ENOENT)
+		*max_order = 0;
+	return r;
+}
+EXPORT_SYMBOL_GPL(kvm_gmem_export_lookup_pfn);
+
 static int kvm_gmem_migrate_folio(struct address_space *mapping,
 				  struct folio *dst, struct folio *src,
 				  enum migrate_mode mode)
@@ -1241,6 +1386,9 @@ static int kvm_gmem_error_folio(struct address_space *mapping, struct folio *fol
 	filter = kvm_gmem_get_all_gfns_filter(inode);
 	kvm_gmem_invalidate_start(inode, start, end, filter);
 
+	/* Lookups see the poisoned folio as a hole: take it from the exports. */
+	kvm_gmem_update_exports(inode, start, end);
+
 	/*
 	 * Do not truncate the range, what action is taken in response to the
 	 * error is userspace's decision (assuming the architecture supports
@@ -1867,6 +2015,7 @@ static struct inode *kvm_gmem_alloc_inode(struct super_block *sb)
 	gi->provider = NULL;
 	gi->provider_ops = NULL;
 	INIT_LIST_HEAD(&gi->gmem_file_list);
+	INIT_LIST_HEAD(&gi->exports);
 	return &gi->vfs_inode;
 }
 
-- 
2.47.3


