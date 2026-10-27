Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 386096073507
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 15:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Vc51GerD
Received: by kanga.kvack.org (Postfix)
	id 247BE6B07E9; Tue, 27 Oct 2026 11:47:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F9406B07EB; Tue, 27 Oct 2026 11:47:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04C3C6B07EC; Tue, 27 Oct 2026 11:47:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C5E166B07E9
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:47:13 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 626601C440E
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:47:13 +0000 (UTC)
X-FDA: 85368835146.11.71061C2
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8CFBA40007
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:47:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Vc51GerD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of griffoul@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=griffoul@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793116031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d/rRV11tp+2yuBy0nAi8FWDuCnsXGLzbLZWeXfMh4bw=;
	b=E6Gxlj5dvjut/N8QJZFzKQyudTPmvH31A1IeGlPtAiqPrwC4ZPYlks4s4IzE5wCIgj9dzU
	Lnsu0fFV4a0eWdWXQfzrXltitt8sNXQ8NGzHjnXtafPNf35VN9moY20M/Fun/l3F9LrJRX
	HedhrtgoNRnsytufu8/IYSvZHYabVmc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Vc51GerD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of griffoul@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=griffoul@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793116031;
	b=IeXd3u1rDVSJxQ7tU9hDWKe3zCUkcJetCkn5pNVXN9+HQqlB8aqBzqjl9lq4/qIyTL3I6A
	ITEQlCzwjVmIpUM0HFzIiZice0BSBE95AnSrREgMHWSwoiNKaXnsTQP/KAR6vf10vwh/Pk
	WHwhXh3+rhUpVe7/6k1+BzKcueGnDn4=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-48b060ec084so2833203f8f.0
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793116030; x=1793720830; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d/rRV11tp+2yuBy0nAi8FWDuCnsXGLzbLZWeXfMh4bw=;
        b=Vc51GerDEkIKvbNqMrKxPykUy4+NTJ0abbGoOdxk2sUv53tXmTCjNt9XUGtV/l79/u
         VC10a71kLbrVCQK8YS2DxEFZwc378XVUNi/5vks48he99YO3pc/tFbBAlurH9/L03p/F
         G0uSR2pTsFvx5Y8207s95yWtiKW5YRSAHwP50hjJHOxvwCEDhIV2bxO//cLjwohg9tuf
         MITRLdSPIxloTJkn/TEu7nI2QGNAWv4refhyq/N3UY4CYLMefx9MJ1TvdcNFbj80SRON
         fvDca4YwpoKwG+5XKNWxZLLJxEqoGuadjvMTGvPnT5uAlEv4DWgrNsvlALwn1gyrdIkI
         0qVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793116030; x=1793720830;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=d/rRV11tp+2yuBy0nAi8FWDuCnsXGLzbLZWeXfMh4bw=;
        b=2I5dhS+nYxUjk/dFaJs8B6CjAAp24P1ei6o6iD+h6nQVWT8Cw37yi3kbzGfcHcd3Tq
         P96nLVtRpNjbnF9k4wsBfdWYJirnxdJ9CnWyT2+giGLcdcUKYI2aThKKWVP6cU05E21i
         MR4/jnd2QufOipcMGsenHhKGdPRvPWM3NuzO41zeAYMg5M9za4L1fpWqt+Qy8qwjVWSC
         QbnfCUnyWyXJZuYEm1Re0hs1HUyLA6byhmrZI3KHvAZ30KuMeQ+nX3M4IJHDrNGRfmzb
         FH7xM3EVW4CH954tLefQKxM2y0ne49ji2qwvrk5eUzNW4HwRd7CwkcDUL/9dvX/FEGKY
         qf5g==
X-Forwarded-Encrypted: i=1; AKwUvBxfv7sdxdlipm4w3y4zTMjn/2tBOT0Zzj55E11iPjNAhNhBFFjxIKYZzGcFphm0EtevBf7cwP23QA==@kvack.org
X-Gm-Message-State: AFq9FYJfERirLRSEgXfSPhdebQWPAa1EA7MyQmtIIbN0A8LKhSagjWKk
	D+dMHW9mUoafG6MokJbzdz1uqU347LCsxyARSTWj1L3BSv/yc1t8M6PW
X-Gm-Gg: AYBFou34BpoOJ7gSADS5fGsWNU3h9yJL4A55p7nPQ+MtwH+mC1gIChjxgu5gXPhkO37
	+/Y4leySLAwA6wDvHMmzcTgMc/cBsz/DEV7PZRqOp627NViJfgzPtWFm4DUfwSjx0FnSTz3w1vN
	EF2k7pPGTjhG9k3df3SFDMUvlxjfirhmMtS/JM94cjLeYrIcJ6rSthuM6zv0lbFOEj85Kerfg19
	tYmBVEyIV6Oz+9ncGdyxcsihgmQQEuyBFQHRDhNkerJgb3dhluylnkh25uCKsfMnJYZjSoAMMKA
	FkVbxVcXQVIYIVwRvKKhB2dEyHE15Sa/bZnPwqoz//LBttLvgq97J5uObT26Wvt+Hjh2y2x5gSN
	5tNtI6potZksGjTc2pt2eD243aQSD184/F1Dh6jFnqBNHHP7jRFVID5EPzSIfI9qlGeb7pLBwuK
	4zmqSOok3uuLKs273SkB2V2KtvtEITC4hjSM1toQTKWJY1FWHbXe9vmjXcsJ7Za0kkexpD24ozM
	SdSk1ihIbYlGhlbOtBSpLSjq6MWVBTGKuB1KhoX6BBRfB4FxrczAPznOX+047JA8OBGkL5uPgFm
	yBS3OLaV/TH/gZPY6pA2Bl6MKUnSpBjyiBVatKRVl2QFm2sU90gOKuB+DX33ECnW3rcYrxnsXDE
	QYt7sS4l+1zZbcvCY
X-Received: by 2002:a05:6000:188b:b0:486:f9ea:796f with SMTP id ffacd0b85a97d-48e3eb9ed13mr20773527f8f.41.1793116029637;
        Tue, 27 Oct 2026 08:47:09 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebcb958sm23845574f8f.21.2026.10.27.08.47.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Oct 2026 08:47:09 -0700 (PDT)
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
Subject: [RFC PATCH 07/14] KVM: guest_memfd: Update exports when pages are allocated
Date: Tue, 27 Oct 2026 15:46:42 +0000
Message-ID: <20261027154649.91571-8-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261027154649.91571-1-griffoul@gmail.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
 <20261027154649.91571-1-griffoul@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8CFBA40007
X-Stat-Signature: sdsai7y85xr881otbwpe758od6jst96n
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793116031-370381
X-HE-Meta: U2FsdGVkX19KBjevri9jOdsCW88GKp8EXyujXUj49fwPuY45uUKOtlDaJzeMWCLDaSKtvxHfYUaVUzMI6Ky/+xrTjS1WKV1qqclXvCzchfA5LK2qwCjZRFPFdprt6M6tL9dMTHyY7rtLY5XIMINhWBVk8uWcvb6jeUgh6CbvlBmvjR95+yuJ+VE2E+8YIYDr+ZYQX6RvVm5+3BIUmjirZc6dpjls7eaBK1MlssWJCjqSbjFZQxS8nLunylh44FwZm08R/qPl8/wSko7Tp0pWh8qajyhfuLltG2iNS30WSGe4an0abyEUuXNk5zv8u4vzr80Bw6yIhSIqNeVTEzRYTp3tYJ79kCcYbH6w5JxhmJ1xUgFeUNIRilArBdda0NJ4TCNrcxe9jNP5W7cWustX77+D9UiFLGU7662W/p8f+7HqBwpnNaMUqTmOFJJ41bsVHnjZcwikTLpeZZvPob0v2YxDjm3xrBNxP4z8i3bJ2bBzz+SUYjcUS4svStD/4Ecuwhy2ZDuLW0/S7sjXeABruqtfI/wM7+QHO4cOHD5YYvk2YaUB0Uzpye5li6QnuxEwMYt5jcYQ5HWrekQp7Xehah/rCS67YH9Fgp2iOWim9Zs9h9ziUSV7wE7h3zyngrDED0v3iDSd4D1cM30OwiIOvRWfhpHpJW9gQyZTGbKGrUN72il3xnl54tZOgxil3Yq7akg92oNblUSMS7XsVg/VpGV+7EkRWVy/MOyMuw9kbaVWL8J1145M5G+RC8/wltjU6evwnbRrVTFSZoTLihvWA0lqYJko3YTMdqgTpMJB7QkwotB3zWZ6J0RL3p7TiYLSYZstwiNDVZvh70ZlkiV4ZySWb4rKL460Z2vfqdeO6mDi5MBflvPtV0WYWYBRo448gaVgFIV6CuygX2+bgpjKGeU1DNZuGKiySeHqaqUG+L76+bXsIgETViy75+Cwu8QyDzj9bXqdUUDVFHnznza
 vqAaLxS6
 +eLX4++z22KSQ4waYDmmZBMJuuSvNG+NDv61FuHlsFtr4Z3ad1BXIWVgx5dVrUSuMFzpDDkZp2aM9Wi6HPvETPzTD/pNUI6XC8lRVas0AyKTdc1O89TSXcMfzIXFXFRKBHBfydmL+pwhT/EAJjyTisYCPsGue8O5ApvIipXN2EsH3UN+xGSs4tv+FrjmjvGZr1r9epAV3D+kLVzJP6zS68movCFsEkPX0Y5eDauryigFbl47Li8+vImu5RSt3BJgoQrR5Gx2/yiUxb2C8BoBOTNOw0tCjdJ1GUVRDax3Op1utlGlaDFFcQhJvn1lz3nzmPSgEdtjkj9JuXZtOFpDSfVZKzeO804z3eSd7DYqBKK+6Auf+rAT/WBTCmjmswLoUMM/FHni/xtYmrffZ/cssNTKgu+4dyhAB7SAJxiZp8I/ShwNYwPRfEe4cclezr7yWDB0mQiEBbc92C9562ky0ClvbhftzyKHY4e04iTgnvZTwnMJ8BQSbklv1dA4hwGc7bKMmBIRU0wupq1Sm0hPmXJnoINvws+jA/hY67djY13JIGI2V2Hcf78iJBHY7tIPiQKH23NcmhdkgaDn8M+3H2CxWrCrvq3ZymeYM6Gg7AM2IeCVXxeSDjhJqag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Fred Griffoul <fgriffo@amazon.co.uk>

An export maps only the pages that have memory when it looks them up,
and a device cannot fault in the others, so guest_memfd must call
update() when a page gets memory.

Lookups treat a folio that was never zeroed as a hole. Zero folios in
one helper, under the invalidate lock, from the host fault, KVM's
get_pfn() and fallocate(), which did not zero at all, and update the
exports for each folio zeroed. Mark zeroed folios dirty: lookups hold no
reference, and memory-failure handling evicts clean folios that nothing
references.

In PFN mode, update the block that get_pfn() reports when it fills a
hole, since the provider may back all of it.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 include/linux/guest_memfd.h | 26 ++++++------
 virt/kvm/guest_memfd.c      | 85 +++++++++++++++++++++++++++++++------
 2 files changed, 85 insertions(+), 26 deletions(-)

diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
index 937693ae9573..f8e89723dd68 100644
--- a/include/linux/guest_memfd.h
+++ b/include/linux/guest_memfd.h
@@ -90,13 +90,14 @@ static inline int kvm_gmem_revoke(struct inode *inode, pgoff_t start, size_t nr_
  * nor fault them.  It attaches to the file, looks up the frame behind each
  * shared page without taking a reference, and guest_memfd calls its update()
  * whenever what a lookup returns for a range may have changed: conversions,
- * punch holes, memory failure and a provider's kvm_gmem_revoke().  update()
- * makes the consumer's mappings of the range match what a lookup returns now:
- * a frame, or a hole for a private page or a page without a frame.  It may be
- * called for pages that did not change, and for ranges that do not follow the
- * blocks that lookups report: the consumer may then remap whole blocks, also
- * outside the range, e.g. to merge them into larger mappings.  A consumer that
- * can fault may instead only remove its mappings of the range.
+ * punch holes, memory failure, a provider's kvm_gmem_revoke(), fallocate() and
+ * pages getting their first frame.  update() makes the consumer's mappings of
+ * the range match what a lookup returns now: a frame, or a hole for a private
+ * page or a page without a frame.  It may be called for pages that did not
+ * change, and for ranges that do not follow the blocks that lookups report:
+ * the consumer may then remap whole blocks, also outside the range, e.g. to
+ * merge them into larger mappings.  A consumer that can fault may instead only
+ * remove its mappings of the range.
  *
  * Until update() returns, the frames it replaces stay valid, so a consumer
  * may switch each mapping to its new target in one step; once it returns,
@@ -105,11 +106,12 @@ static inline int kvm_gmem_revoke(struct inode *inode, pgoff_t start, size_t nr_
  * beforehand.
  *
  * guest_memfd calls update() with its invalidate lock held, exclusive when it
- * takes frames away or pages convert and shared on memory failure, possibly
- * with a folio of the file locked; so update() may only call
- * kvm_gmem_export_lookup_pfn().  Under the shared lock, updates may run at the
- * same time, also for overlapping ranges.  The consumer holds a lock across a
- * lookup and the mapping it installs, which update() also takes.  Lock order:
+ * takes frames away or pages convert, and shared when pages only gain frames
+ * and on memory failure, possibly with a folio of the file locked; so update()
+ * may only call kvm_gmem_export_lookup_pfn().  Under the shared lock, updates
+ * may run at the same time, also for overlapping ranges.  The consumer holds a
+ * lock across a lookup and the mapping it installs, which update() also takes.
+ * Lock order:
  *
  *   PFN mode provider lock (across kvm_gmem_revoke())
  *     guest_memfd invalidate lock
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 1c5826c5384e..42bb5f263e23 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -286,7 +286,8 @@ static bool kvm_gmem_range_has_attributes(struct inode *inode,
  * There is no backing storage for the memory, so the folio will remain
  * up-to-date until it's removed.
  *
- * Ignore accessed, referenced, and dirty flags.  The memory is
+ * Ignore accessed and referenced flags; the dirty flag only keeps a zeroed
+ * folio in the page cache, see kvm_gmem_folio_zero().  The memory is
  * unevictable and there is no storage to write back to.
  */
 static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
@@ -430,7 +431,8 @@ static void kvm_gmem_invalidate_end(struct inode *inode, pgoff_t start,
 
 /*
  * What a lookup returns for [start, end) may have changed: exclusive lock when
- * frames were taken away or pages converted, at least shared on memory failure.
+ * frames were taken away or pages converted, at least shared when pages only
+ * gained frames and on memory failure.
  */
 static void kvm_gmem_update_exports(struct inode *inode, pgoff_t start,
 				    pgoff_t end)
@@ -590,6 +592,64 @@ int kvm_gmem_revoke(struct inode *inode, pgoff_t start, size_t nr_pages,
 }
 EXPORT_SYMBOL_GPL(kvm_gmem_revoke);
 
+/*
+ * Zero a folio on its first use.  Lookups find it from then on, with no
+ * reference held, so mark it dirty: memory-failure handling drops clean
+ * folios that nothing references from the page cache (mapping_evict_folio()).
+ * Called with the folio locked.  Returns true if the folio was zeroed.
+ */
+static bool kvm_gmem_folio_zero(struct folio *folio)
+{
+	if (folio_test_uptodate(folio))
+		return false;
+
+	folio_zero_range(folio, 0, folio_size(folio));
+	folio_mark_uptodate(folio);
+	folio_mark_dirty(folio);
+	return true;
+}
+
+/* Zero a folio on its first use, and tell the exports.  Under the lock. */
+static void kvm_gmem_folio_clear(struct inode *inode, struct folio *folio)
+{
+	if (kvm_gmem_folio_zero(folio))
+		kvm_gmem_update_exports(inode, folio->index, folio_next_index(folio));
+}
+
+/*
+ * get_pfn() in PFN mode, which may back a hole: then tell the exports about
+ * the whole block that get_pfn() reports, as the provider may have backed all
+ * of it.  Called with the invalidate lock held.
+ */
+static int kvm_gmem_pfn_get(struct inode *inode, pgoff_t index,
+			    kvm_pfn_t *pfn, int *max_order, u32 *attrs)
+{
+	pgoff_t npages = i_size_read(inode) >> PAGE_SHIFT;
+	struct gmem_inode *gi = GMEM_I(inode);
+	bool hole = false;
+	unsigned long raw;
+	pgoff_t first;
+	int order, r;
+	size_t nr;
+
+	if (!list_empty(&gi->exports))
+		hole = gi->provider_ops->lookup_pfn_range(gi->provider, index,
+							  &raw, &nr) == -ENOENT;
+
+	r = gmem_provider_get_pfn(gi, index, pfn, &order, attrs);
+	if (r)
+		return r;
+
+	if (hole) {
+		first = round_down(index, 1UL << order);
+		kvm_gmem_update_exports(inode, first,
+					min(first + (1UL << order), npages));
+	}
+	if (max_order)
+		*max_order = order;
+	return 0;
+}
+
 static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
 {
 	struct address_space *mapping = inode->i_mapping;
@@ -619,7 +679,7 @@ static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
 				break;
 			}
 
-			r = gmem_provider_get_pfn(gi, index, &pfn, &max_order, NULL);
+			r = kvm_gmem_pfn_get(inode, index, &pfn, &max_order, NULL);
 			if (r)
 				break;
 
@@ -647,6 +707,8 @@ static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
 
 		index = folio_next_index(folio);
 
+		/* Zeroed now, so that a device can map it before first use. */
+		kvm_gmem_folio_clear(inode, folio);
 		folio_unlock(folio);
 		folio_put(folio);
 
@@ -819,7 +881,7 @@ static vm_fault_t kvm_gmem_pfn_fault(struct vm_fault *vmf)
 	u32 attrs;
 	int r;
 
-	r = gmem_provider_get_pfn(GMEM_I(inode), vmf->pgoff, &pfn, NULL, &attrs);
+	r = kvm_gmem_pfn_get(inode, vmf->pgoff, &pfn, NULL, &attrs);
 	if (r)
 		return vmf_error(r);
 
@@ -873,6 +935,8 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
 		folio = kvm_gmem_get_folio(inode, vmf->pgoff);
 		if (IS_ERR(folio))
 			r = PTR_ERR(folio);
+		else if (!folio_test_large(folio))
+			kvm_gmem_folio_clear(inode, folio);
 	}
 	filemap_invalidate_unlock_shared(inode->i_mapping);
 
@@ -891,11 +955,6 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
 		goto out_folio;
 	}
 
-	if (!folio_test_uptodate(folio)) {
-		clear_highpage(folio_page(folio, 0));
-		folio_mark_uptodate(folio);
-	}
-
 	vmf->page = folio_file_page(folio, vmf->pgoff);
 
 out_folio:
@@ -1887,7 +1946,8 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
 	}
 
 	if (kvm_gmem_is_pfn_mode(gi)) {
-		r = gmem_provider_get_pfn(gi, index, pfn, max_order, attrs);
+		r = kvm_gmem_pfn_get(file_inode(file), index, pfn, max_order,
+				     attrs);
 		if (r)
 			return ERR_PTR(r);
 		return NULL;
@@ -1903,10 +1963,7 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
 		return ERR_PTR(-EHWPOISON);
 	}
 
-	if (!folio_test_uptodate(folio)) {
-		clear_highpage(folio_page(folio, 0));
-		folio_mark_uptodate(folio);
-	}
+	kvm_gmem_folio_clear(file_inode(file), folio);
 
 	*pfn = folio_file_pfn(folio, index);
 	if (max_order)
-- 
2.47.3


