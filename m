Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EE2F606A33B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 06:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=NdVLYk0f
Received: by kanga.kvack.org (Postfix)
	id 513CE6B05C1; Tue,  3 Nov 2026 01:17:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C4D06B05C2; Tue,  3 Nov 2026 01:17:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38CFE6B05C3; Tue,  3 Nov 2026 01:17:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 10D256B05C1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:17:30 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 00FDFC0321
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:17:28 +0000 (UTC)
X-FDA: 85392801018.25.0F9ABA1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id C8BA2100005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:17:26 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NdVLYk0f;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793686646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TVuWgoTT0NSjTET4nXrhDaEgg40Gfb3itKSJW0X7/Jo=;
	b=Vuaa58Bo9bg7KokkzdPkIqlyxqcnlLFk0UlFjBPmendbtgPRv/eJipcu0h7augPh8JiBJJ
	53j+AhaMsG71VPPk90faEPU/YUfiV8l8Ekvjm40nPG6xohggRuarPHbZt4VfHS6CuT9f92
	MFohuoAxcCTYP29eu2uqcZwhODrFxn8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NdVLYk0f;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793686646;
	b=cQdHVJVmrbIcamI5oId0y+eMQbHG0HhKD57ieqdySrlu2r0hnoFc+l7M9QVgryMdyLuNb4
	0+trj7UoM/PbPGuedh/+lybAi2zltTD/Qe1Jm4FXr65F5z+RU+et0Ko8oLwSzNy68ZyQe6
	2Fgp2GZW0Otc7g1dcxXauXoaqKz2B3k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793686646;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TVuWgoTT0NSjTET4nXrhDaEgg40Gfb3itKSJW0X7/Jo=;
	b=NdVLYk0fAuM7/GXgYcg+4TbujGBLdzFk76v8Aiet4s7AP2vLKQJFutsLbRDvf2hC/wtK0x
	diLuzQ2aPe+WJI3NR2oIQj2SOvabJimtYy9XwpKc3Z8bCzzxAtVUuQzzAPuYO7cBvWpFV/
	GqG637WZnRcnGAQfU0iPhjhe1CCLd9M=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-224-JWj68wYxOTmgxwD6oUZDHg-1; Tue, 03 Nov 2026 01:17:23 -0500
X-MC-Unique: JWj68wYxOTmgxwD6oUZDHg-1
X-Mimecast-MFC-AGG-ID: JWj68wYxOTmgxwD6oUZDHg_1793686642
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5be4b14ffd6so128870e87.1
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 22:17:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793686641; x=1794291441;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TVuWgoTT0NSjTET4nXrhDaEgg40Gfb3itKSJW0X7/Jo=;
        b=TXXYgMrwxTLbJeKtC61E9y6/DvmxIHZLopEEFPdSltpbBnF4VU3Bgua7MfufQlxbpO
         4LwPbbasozThVqsYgDc33Nc2YhXsRUFsCDYwI6u3iaAXh2IsSN2YwZhuTu33DugZOfL1
         hP1ZgBAtTpWisBeCExzPMCt67VMJ+XnWWrXRzqsSa9I9RUNa1k+XMk85Js34hK/l8IJR
         5Q9NHzNDLy0JNCXXks6oodl+nWpfW/YNEE5KYZhQG3lvNAOVwCAvRYMvAwYPmkoGEn2T
         NImETq0WZTtvPmcGr7qbINHU3uqmxQLjo2FRCLYD68W3KE0RvMbZRORvYetDzetLcXoY
         qiHg==
X-Gm-Message-State: APuU4Z/iCjUt/oRnKVv0hmVmeK4M7e+VIs6thLmU+GzRnwHyYy4PS6rs
	2dTCWl62Ou4fvXaEXih0jNSU0xmZuqCPBRCNG4GBY+98wLn2qtCaUaUBq1Kgz+CZM31oTIcROUJ
	EHMQbVVVhTVKDQeC4V6XwtmGN+bNU4pNkT8vdldZkS7RIVxGzp8HMy59PoKqdTdqN+jfpLoAALX
	XqLpuDLGj4pKKWunOx+oOM68BI2xZ5lA7uNuyNhg==
X-Gm-Gg: AYBFou3o1F7Ruw4uWfh3Mj0EL1CwKy+NQHPmw8i67A+XFWJmTC/elUtVPYAApHSP1lp
	TikZRVP0ZD61I+ZWp5C/K/L5GfskD+eZNogFaTguv1Q1Ap7/a47Ac2PshgKRGNLDKeN14qtuatz
	jvyh7jDkedyncE+ruaEOFaJd/o7BTuzckd5qy9A86LumxNC4Fb8/+J6W7CTAFGrkrKBhHeJJoIZ
	f05y2WbgoACV3NyITtY8lQ4WKATJG5sORNO7EKV+YwQ4OlVr8oZXMhjeyfhCgieEn/5rxgCfAOg
	HeSyNafY0Zaf6xGvS/FiGtGVFSyEoLTt+dTI6M2mCGMmzwg/RX6MNiU1aKnJMV/+eToWhCvYHJU
	hJivc3WP7Nuo6f65yM+8gL1gELYjTIQlPPce7dYRiHCfAwc8wfDcKxWAbvecbfi63/KJ+nQ==
X-Received: by 2002:a05:6512:a83:b0:5ba:3e27:6a32 with SMTP id 2adb3069b0e04-5bfd12073cfmr4453060e87.29.1793686641526;
        Mon, 02 Nov 2026 22:17:21 -0800 (PST)
X-Received: by 2002:a05:6512:a83:b0:5ba:3e27:6a32 with SMTP id 2adb3069b0e04-5bfd12073cfmr4453033e87.29.1793686640906;
        Mon, 02 Nov 2026 22:17:20 -0800 (PST)
Received: from fedora (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bfe073e0f9sm1964634e87.54.2026.11.02.22.17.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 22:17:19 -0800 (PST)
From: mpenttil@redhat.com
To: linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH v17 11/12] Documentation/mm/hmm: document migration through hmm_range_fault()
Date: Tue,  3 Nov 2026 08:16:28 +0200
Message-ID: <20261103061629.972669-12-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261103061629.972669-1-mpenttil@redhat.com>
References: <20261103061629.972669-1-mpenttil@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Jm8gzygkdMetOQNZe31F3g15QLO_JnSlBKCgwAio9YY_1793686642
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C8BA2100005
X-Stat-Signature: tahgzztc5cisuommysnu6ncps57oh583
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793686646-153510
X-HE-Meta: U2FsdGVkX18Zpss9jb7H3uqF2HhOJCju63It0gyQuSO/dib4q26LTf/12pfuMDaNzbSPbUAZddH6RzbGiJqdWogEp2JG8bgPRUO29Pb3por4J9t5Hiyqtyhb9LDVc58uOX59IN3MDCaYTBeUPikKSL8joT1DhV6IuCD/l0Om2kqyYz0LPNILCcKRnjbRJ5gzLWdvMNiPkquqPdUfIawDkhCP8/M+f61uDGjOCHPEwgsQLf2CLJwojb3dY7DALf+6IMeEgUBPU/2f4VW9IkSIC6mQqPMlLDCrPim8EnQr3XOwVF4tcqjGoOZPzrIbqVkB0XEiXka6zHBq/FuzCbt7EuzYpPaAemNQuCu68f5PaCUQgZKve2HEH2v5mYYFpoKAtSvLJa5q02i+mOTDdCqxIwehcyIl9VULic7ltokQHljj2mNdjKfyLo2F2uTzF3P+dZG6By9gPOQH5YoHW2wt2A9Zqt5CTqtjn7GKzRltkgL9plhdz+pp9+2/PazIgCYYTZH/f0bfvjGrV4m7w0DkmaGfpG5ANIP7xokLcLsOBUiffr2+TPe1swrNDaDFys8OeQ0OtpsBnSN7Mii9Wqic2k+qVDJ6IN5Wk8QUQXD76x1SG5K7FjDe8mk87ql6KJhsWs4mO3gV5yLOdE5eZbfY9D5bkl5HCah78LUMcFfSqxVoWq33i4fSvIHxoA5uuRHiWPhM8m6Ztkq3FlzSs+Mjj+YyZB4Bnz5rA6+ZtTBGZJAqN4x/f/App9ajmYb/f6P/W0YE9pgKX7lw5jQ91lVE2BJnd5VXh913FElpsMTAQ7JEpCbN8SZ7DEYZ6NQeeqOn31dRxxS/KWzR+mw1qDERDQVRpwic39pAvBgoRKAXJ0ypX6pJsJk1OxsSkhgpJcHYWbMepDxOTVowFfPuCUvoGBUxM21T/BwH2qlILy49XImPsQIBiWoOaNI8JhE+di6xAURnsdH7c1OxkCRTIWd
 ltUrKo0J
 dnbEssQ/Dx0L54pjrcYyC4XYYli6lXpDfAJGHQHyY8gBf47s/n+8sLBsA8BdiH2aLYN/dJtDZzvcdOanwovtzMkxsMxs+vntP/M/KhNkeWBPx91q5ejm7rkXBhCRI9GPpHfREAYQ7pv5CWjYJtAIiDNTEva5VNli2dIQFL/cp96yhtGfexal+Colwv9TuN+Jr5QNEB6S+9lvlEvAxHPTSCsVbVaW2ZsVptGEXdhCojlW87XYMpZDV9q4nlUBVfnfrwOjj0XEuaoWqstMH4M7jTTWA8yQ0XoXCYM0X4pIwVMuLEMAN2fCn2WITi95thhNyaZmRK+VMQUIKKHjjiV/a1oz4q/WsODcxvv57CjKaGZlFa263ZqhuhajjbNWzQuvnaHiJRqznZZjK5a0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mika Penttilä <mpenttil@redhat.com>

Describe the two new MIGRATE_VMA_FAULT / MIGRATE_VMA_WRITE flags of
migrate_vma_setup(), and add a section on driving the migration
collection phase directly from hmm_range_fault() via HMM_PFN_REQ_MIGRATE
and migrate_hmm_range_setup().

Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
---
 Documentation/mm/hmm.rst | 45 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/Documentation/mm/hmm.rst b/Documentation/mm/hmm.rst
index fc1b8dc19825..914ef6bfe848 100644
--- a/Documentation/mm/hmm.rst
+++ b/Documentation/mm/hmm.rst
@@ -348,6 +348,13 @@ between device driver specific code and shared common code:
    Currently only anonymous private VMA ranges can be migrated to or from
    system memory and device private memory.
 
+   By default only pages already present are collected. Two additional flags
+   ask migrate_vma_setup() to fault in missing pages first:
+
+   * ``MIGRATE_VMA_FAULT`` faults in missing pages with read access.
+   * ``MIGRATE_VMA_WRITE`` faults in missing pages with write access
+     (implies faulting).
+
    One of the first steps migrate_vma_setup() does is to invalidate other
    device's MMUs with the ``mmu_notifier_invalidate_range_start()`` and
    ``mmu_notifier_invalidate_range_end()`` calls around the page table
@@ -427,6 +434,44 @@ between device driver specific code and shared common code:
 
    The lock can now be released.
 
+Migration collection through hmm_range_fault()
+==============================================
+
+The collection phase of migration (steps 1 and 2 above) can also be driven by
+hmm_range_fault() directly, sharing its page table walk. This lets a driver
+fault in and collect a range for migration in one walk, which is useful for
+migrate on fault.
+
+To do so, the driver sets ``HMM_PFN_REQ_MIGRATE`` in ``range->default_flags``
+and points ``range->migrate`` at a ``struct migrate_vma`` it has filled in
+(``flags``, ``src``, ``dst``, ``pgmap_owner``). Usually ``HMM_PFN_REQ_FAULT``
+(and ``HMM_PFN_REQ_WRITE``) is set as well, so missing pages are faulted in
+before being collected. The mmap_read_lock() has to be held for the whole
+migration, since the vma must stay stable.
+
+Migration requests come only from ``range->default_flags``:
+``range->pfn_flags_mask`` must be 0 and ``range->dev_private_owner`` must
+equal ``migrate->pgmap_owner``. ``range->hmm_pfns`` is cleared at the start of
+hmm_range_fault(), so per-pfn input, including ``HMM_PFN_INOUT_FLAGS`` such as
+``HMM_PFN_DMA_MAPPED``, is not preserved across a migrating call.
+
+hmm_range_fault() collects the entries the same way migrate_vma_setup() does,
+taking a folio reference, locking it and installing a migration PTE. Collected
+entries are marked with ``HMM_PFN_VALID | HMM_PFN_MIGRATE`` in
+``range->hmm_pfns``. If the page tables change while locks are dropped the
+partially collected entries are rolled back automatically.
+
+After hmm_range_fault() returns, the driver calls::
+
+    void migrate_hmm_range_setup(struct hmm_range *range);
+
+to translate ``range->hmm_pfns`` into ``migrate->src[]`` (``migrate->dst[]`` is
+zeroed) and initialize ``migrate->cpages`` and ``migrate->npages``. From here on
+the ``range->migrate`` struct is ready for the rest of the flow (steps 3
+onwards), i.e. migrate_vma_pages() and migrate_vma_finalize(). This should be
+called even on error, since hmm_range_fault() may have collected part of the
+range before failing.
+
 Exclusive access memory
 =======================
 
-- 
2.55.0


