Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D048606A32C
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 06:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=NraaEPkS
Received: by kanga.kvack.org (Postfix)
	id D9F226B0621; Wed, 21 Oct 2026 02:06:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D28E86B0622; Wed, 21 Oct 2026 02:06:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF0196B0623; Wed, 21 Oct 2026 02:06:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 95C116B0621
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:06:06 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 255FDA0478
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:06:06 +0000 (UTC)
X-FDA: 85345597932.13.FE92473
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id CE8AD140003
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:06:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NraaEPkS;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792562764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xEEzUKmwPcuLDb8KHUBfxekosp3Yw5qO1BP0yTFVDsQ=;
	b=FL7e/qJTnnrZocam4IbAYqv1i2Ngr4BiS8ukYdMeOijeVemVsLIp6f1ua7LZ+c9B261viw
	PIxLYdIohXIy5XG6CMIdymOJmhsWT0zPyuuccXbedbmi/n7RqAPHv5tLCvGeFHnMQUX6xd
	6dYmcd5QvY7r3SMU3DyHZaXZMfoLuf4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NraaEPkS;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792562764;
	b=FemYcezvooi0eqmVFAgBm1B2va6PsZ1M/QNTasJcSWYiCEd1LEGAERwoBRJZ0vl5+RWbZJ
	fz4Bz8w4FtlZZR1W2Y96st/joY0e3YVXEQe6ISi8Xwiq21jZRX6CbpdS2N7fDDhQxLDUk6
	DL5cvcFFiI+3+cxLArYIEIYVZEyCgcE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792562763;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xEEzUKmwPcuLDb8KHUBfxekosp3Yw5qO1BP0yTFVDsQ=;
	b=NraaEPkSN/Hr3WuxJQQo5paoUHrhftKerHAxndKyvxulEm473l9ApyHWUOCmKzPwcJRPMh
	1Qbw5RJ/0zzSZfnHEW6/dOe5RkrcKQJpuCeTTB2v2oTlvpG20yzBe/IFb5WqwTRVoqii13
	WNl2V4gisMNzVGSnaUgvigB4ohhX3Ao=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-674-H9_TFkvNPmyReYGQmMN0Yw-1; Wed, 21 Oct 2026 06:05:59 +0000
X-MC-Unique: H9_TFkvNPmyReYGQmMN0Yw-1
X-Mimecast-MFC-AGG-ID: H9_TFkvNPmyReYGQmMN0Yw_1792562759
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-48af5a07314so224635f8f.2
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 23:05:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792562759; x=1793167559;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xEEzUKmwPcuLDb8KHUBfxekosp3Yw5qO1BP0yTFVDsQ=;
        b=Lh8AfKI3vI9YDoMr/lzAfLshiIG+MKqnBsVP8yjrVYEOzf/jmKSSijqiTuU/ifbVEz
         sCakhYRWnDcwC9l5MJdZf7mCl40dZ81dCh5A5jqGB7o8dj9fUvFfnNy+wcI6V3jKv+JP
         B4QDJvAPkdi+ZWGVGOv/otwcxfH1qU75CYT8bp7vp4Tr05P8CjbMUFrxMnAio1zJpImI
         i6I0Ltk6ldaaUMwKykxGvtXEYrNtR/BEg/W/5GeppkGWgeNcMPLx9OfHGn0uPIvZ/i7C
         iPa6XegC/xPZJsOgt16zQ13fmX24BHT9dFEXHue8ZRjQtm9gZ+6DpU53kAuI+UXWVSov
         xN3g==
X-Gm-Message-State: AFq9FYIKzQLDtgT2lwzpf5oYRGrziJvf67u5dZRNlQ/+eS3jm4f2X8ny
	tPNDUg+fiGz2WxcBrpfBBasmIr0SWC/54mAKnikLDeVfvf5fZ/eepwmOnEmoJyWocpnnJktQPCq
	Lf0SuuusBTj7Fbfp3ZFlDFoGTEHYK3kaqpCR/WzOBnKDID4BUL36VPKmBh5F6tqxeuF5wLKPww7
	hTGS2F6IpZ3SVf5ADOAAWzJnW3t1RoOaz0Oe3blA==
X-Gm-Gg: AYBFou1Gw1UAlVyd7fipjZyPmF/Sun9d3C1YUaXWyaUI8of6WGZFpE46iv/WN0mNr9N
	yWvEABH9kiWRXyKXC9l2Jb02hV3p2hqZgk4OEKZouDvpwRe6FjVa4movh9rV2txIkn7KACyRtJe
	qbk3aY+JgSR2NBVhQZ4fIkaQD70VhhW6ogdNI1HcRprtFy21Rvr9BxdCeXxNK2XkhYhKt6Sr7Lb
	/mZO/+rvNCPTE4+5BppUmp22LerT2Jmy2fi7Xj7rZrENq87A/1hJD03drTudkZcuUwQOw3GLCoc
	XUnGScFJkMDzCB+CtCJNwpCSNujTA9JiHFqd09/eI5T/NRap2sA4nGK/t18N28oN6LM8LEEqwDz
	Z8yOPFjVcifvBTB41fWd4IdVxwxTHpthflr9b
X-Received: by 2002:a5d:5d03:0:b0:48b:69d4:bb35 with SMTP id ffacd0b85a97d-48e26493dfamr1855076f8f.12.1792562758655;
        Tue, 20 Oct 2026 23:05:58 -0700 (PDT)
X-Received: by 2002:a5d:5d03:0:b0:48b:69d4:bb35 with SMTP id ffacd0b85a97d-48e26493dfamr1855003f8f.12.1792562758183;
        Tue, 20 Oct 2026 23:05:58 -0700 (PDT)
Received: from fedora.redhat.corp (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e254f02f1sm3413741f8f.3.2026.10.20.23.05.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 23:05:56 -0700 (PDT)
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
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH v16 11/12] Documentation/mm/hmm: document migration through hmm_range_fault()
Date: Wed, 21 Oct 2026 09:05:05 +0300
Message-ID: <20261021060506.2377545-12-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261021060506.2377545-1-mpenttil@redhat.com>
References: <20261021060506.2377545-1-mpenttil@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VNArv0ntEofwag9C3T7VIp-Y6S_cP2z6qWSz-C5hK_4_1792562759
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CE8AD140003
X-Rspam-User: 
X-Stat-Signature: z5q4hobi5q536k7o7ajwffe4sjrbihzx
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792562763-269201
X-HE-Meta: U2FsdGVkX1/mOQjNomlFaiI6IvlHkrUJO/Ktb3uVLyx0fVZvoOyv6+fJrA1n2KUPP2+OzYpuZHQEGVupdrEvJrDrhZv5MdjW+YHRWK8t8Un7mPeNJl3RodsBfUomWv511Od4W5kOzYs3jt3PI71aVVflOnDIGJhwJBfyrvnk63FV6lA9AhNM7fO85GFc7GQZ9ebzdZKc6vtIE5J+/unYdC8cr84NiVA9+ie48iJKWWNoWhkeYek2WwuvFp5s9TlQB0U9VijEueQrFLKXe24Ew0Q+CO8x/kpNQFO0ZXrlCkCeg7z8pLTxSG7+RrBG2IHDCCjcpiea3r+6Hp2/LU31ztSWZjz3MnPTZXdH0MjVYpWLnK4jWMbRwcFABE9aLY/da2AVXSwof/dIDB00ScMRMEbN6ey0Pgl7AcZQSP/8mmEMXr64GOHbBpNfwcHqtLXrfa+j8C10rNXA496xNuhPz8x39kHHseiOW/VHV7dMI1U6LnJEJIcBWSVABTuGb7X9reGpWMK+wS+F8dQzhUPTMzzSueqzvbXyu0zrM6uYDr7ENYK0S6NqNiaX089MlanIhb8HPM7CLpSea6gves9n/okBrJ6tXb2S98vmcN9othkDWma8rTKKQ/c/JPkUCVZu9/ek5mcNLqeC/whFvYHjOxegdjJ/Y3KFFHL188YYpt4wOWKAdEzql2NDKfUQI96JzuPvRTvdl+V3oTR+nh/byD3Pp8z1hhjta4oBonRH8toMdDSwLoK/gw/ugJ0O+7O7aJ9JdAKNMJ4XU5hlPE9jajRBikUYl1isBc5hhGx7vkUgo4y++YvC+zwe5v1PeSpsDTmQdqvWgosB/B4NfQs86s5279zA/3pmClFEnsk3HgIJuVWf9WKGhUYAH2JUib0JTbO59MRwovHPuyXRDHkRqZ9o0NxKzfIOOsfDt5+mgZI4hLR6JD0PRXP5KMeyhD2L36QeMnwzgXee3g/NCgK
 qw5xKcCe
 GeRzKog3YlzaphoM6EpwVm3Dozfr6NaX/s1hyJGJCC8mfOMq8DUE1V5zV7rJUQnw7d8arrYy3wjtgcdd19WQo1KByyXDUA1YM5B+PsrBnw/hylmJZspXbtFLtN7K78v0qYHWprbDUawKXSduFFMAqcQCZgVvAgrNb3B9nvmwAKRpq41qoiccmV8185b64QzoTL4rhf0x1ZILhxIDfJfeZVrBr1WiRDraye/eV3g9r4Lk0DLZ0WjH5SrrWqIs939khIguW0PNGADwC0f/hwgiFweJJt+piB+fPnJ5JjWqTJXvqh7Htk4afIpbOg+qjZoyXZjeDpz/oqq2I4lhnZHBIFpJRiS3CjLhIUArX4ejM9bqyDUf+Zfnvhjm0T8wREzlfE0j+VoXb5LcHhi4JKtIP6ctv3JN4aqzlTuHqPCD7DN80zEkvxeY3U2OlDxMMMbUDmYb8p4NWKgmOoYW0L5on32yMQw==
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
 Documentation/mm/hmm.rst | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/Documentation/mm/hmm.rst b/Documentation/mm/hmm.rst
index fc1b8dc19825..58424e5f5873 100644
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
@@ -427,6 +434,38 @@ between device driver specific code and shared common code:
 
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


