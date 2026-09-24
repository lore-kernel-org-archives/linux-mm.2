Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 833A7C98310
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 06:54:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A5E56B00A7; Thu, 24 Sep 2026 02:54:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47D4A6B00A9; Thu, 24 Sep 2026 02:54:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 392C16B00AA; Thu, 24 Sep 2026 02:54:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 11E2F6B00A7
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 02:54:18 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 95D50160287
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:54:17 +0000 (UTC)
X-FDA: 85247741754.18.FD4D7DD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 63FC84000C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:54:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cTSEUo1D;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790232855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xEEzUKmwPcuLDb8KHUBfxekosp3Yw5qO1BP0yTFVDsQ=;
	b=Im2AnXi+ha4c3E95t1ATAHyo0OR0BmkNDL14Wga6cJyKOMttnfJMNkZ0eZiCfcLebtCvQb
	vvvHNPBpHAEhPwbqTAHcQUyG9bZps3456/7brRoXUZbZOulxkRCPH6t72iv0zmcf0LE7O1
	aMcPI7J+2O35VDlehjbpZXET3N1/5PI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cTSEUo1D;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790232855;
	b=OtgzzP/kB2S1mCg+NY66edH45S3Aqyp6LcsaMMtYsCj2mtA3V+dCdS5oLxxWWZuLKCIDTS
	XzEW22UfN/IEu1m4aa1MQTSWZ9CG7a1DX26Ziop/5fPVALgJ8YKdxnQQ6bivtXD7tXVMLd
	/F4sLLNA458VZkQ9xO2F+XwFEQalP8w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790232854;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xEEzUKmwPcuLDb8KHUBfxekosp3Yw5qO1BP0yTFVDsQ=;
	b=cTSEUo1D3XX3wu7A3iwGvAMOU3Out+bBd8NDlcCK4g1FdbjG3Uln6i57ky0hgQR+B9j2hc
	F0B+jrKX9Ay3PVkpHZIGjCpYCa+wsc1GfAm0R3/XbpwLG645BW+udFVTwXq2U6Ul2BA5Dk
	VEKYVSUmB1awHet80N9Fw1kLPq0LQ5o=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-443-2HkMSkHGM56kgSupZC8_yg-1; Thu, 24 Sep 2026 02:54:13 -0400
X-MC-Unique: 2HkMSkHGM56kgSupZC8_yg-1
X-Mimecast-MFC-AGG-ID: 2HkMSkHGM56kgSupZC8_yg_1790232852
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-3a6442413adso1038951fa.2
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 23:54:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790232852; x=1790837652;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xEEzUKmwPcuLDb8KHUBfxekosp3Yw5qO1BP0yTFVDsQ=;
        b=jfoGqzvo4bS7UI4Fd3UMwWXv8Yrwi5VO8xFnRgu2I8EvR3rbHEClJQViG/vCqxDoEw
         ZoEMXqRTSjbu/wmEhvD1NqSf44ScvjSknpjEIu09mRVFzo9BrMJux+88O39o20Aox16P
         4IHgUFj3ZO3v93UGkGJk5rpYIPBgubJZTr9N72C87n/bmYIo+grYuA0cQ00zvFN5TpXa
         GDMRZRJx5tq92CFJLgGql2LM7HYrRFtx1zDZ+gMjcB+iYg8Rropi3uczLYYy/qawUqKn
         5gzpd2JS6rJ4GbSyGH9JPd2eJ4kfH8kVWaT+xvTdvEHW9UVF8N3DZi7gcFOK/RQPCqVb
         ihHA==
X-Gm-Message-State: AFuF++m3UYNiILYBOeKH18AHdvpj2fRpwyDWVghqUiAIQADYFHkRfAhX
	fsuf2crj2fH8D6RdvsDUvCZxQ0bXZgzDZeoJ4ZlciLeK0LM5oTL+9s/HEDdctuPDTlsaRglPlYB
	monfeDzLXIxqxu6ku226aXbAumhPeqp6oijQOBamrsbiQNFS55VuumWzWS+95Ko9ylcVyCNabYK
	/JCauvlMGvLXnHtVHuY81wpILXx/yiVwgMlpux/Q==
X-Gm-Gg: AYBFou0qnAtL4bQroV3Y75uMfpby0HRq/FGpf5U+G4qgd8uahVahI0KGwSAbxo4ktcE
	DKLw2eyItAS1sdxGoA/86QDqSwK2pzadBk1rBSFTZc1wfdFO1hJHS6nnaalUgpCUMLuAaV6lXt1
	2Ili9ImJF3Zb0XHIW2GBjN73D5/y4AY5to0BsRjS4muq4VCRLscKwgxo8yRQKo3jaHVnT1ujL+D
	X01swqfwQZ+MK31sSZqJrvKDAQIovYm6wQFAoHMjf5ZHOjHuQZCWNGKyTtHPKPaLVN81bsXdTx4
	rz3I5Qo5sjQ5Tl+lT/C0xncES5/Y3mRpVnv1DXKZgT5NvP1HSl0GoRV6VR+TYvXNC1RYv0gK4PG
	wkIiusPYnJwUyhCgzQI3z
X-Received: by 2002:a2e:b893:0:b0:3a2:f233:5c6e with SMTP id 38308e7fff4ca-3a63bf652b3mr3928481fa.6.1790232852121;
        Wed, 23 Sep 2026 23:54:12 -0700 (PDT)
X-Received: by 2002:a2e:b893:0:b0:3a2:f233:5c6e with SMTP id 38308e7fff4ca-3a63bf652b3mr3928141fa.6.1790232851558;
        Wed, 23 Sep 2026 23:54:11 -0700 (PDT)
Received: from fedora (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a63bf57909sm4803141fa.29.2026.09.23.23.54.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 23:54:08 -0700 (PDT)
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
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v15 11/11] Documentation/mm/hmm: document migration through hmm_range_fault()
Date: Thu, 24 Sep 2026 09:53:13 +0300
Message-ID: <20260924065313.899730-12-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260924065313.899730-1-mpenttil@redhat.com>
References: <20260924065313.899730-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: b8FYJYgRoTe8n8cmnpigKWwgKJRG3GkwKr3LLheKbWw_1790232852
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: w7bgimr4czkf684euwghm6fnz1creb4k
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 63FC84000C
X-HE-Tag: 1790232855-727120
X-HE-Meta: U2FsdGVkX18JKqD0wSgBzvgAu4P/GDtKzyN4AkF0tZnA044QlxrbTqf+7TNBPFTl6m18G9ztUhxEaKZdht1852UeSulWYLJHrePC8jWYM9w5aaIGipxxeA+g9hEQ7UcrQE6MnGIZZtQpq7LCTvXCpCnRSYH7dE4SiaYuBFYzVVg6vH1Ry2u7JoxN7nlRuEkSU+ffgbE7k6WPp5f0wpiw6BSxqiaqY+3pTmWInuIEJzrwRJ4FL4Pi/BaOXnzm3WB+F+/gqYC7HCNemfa7DE811CPzq7AHKaKXXUj0kaGKjf18PU5txuC+gR3UUBC1fKkwGJY4fosCGxvSPaICK8KxWclyCjYJOzRxB76SGwMwKB5lfifCgFvTSU5mEaml1Yrd4lG7i8Xo5SdTctjIXtC0gIzxE6DKOuYql9v3B/tv5CyAGR67az/8pRy/6gRy0B0BaDRvNMGZZsHOY6zuZQYr8QVYMVqytkYj5awoQXANv1bdpdAHnZMo2u6gty+yjbV4rKCTWFe22nMhYHpgkf51XfTTNb9V+0OZTMx6l3e9ZFdlRUm/XI57O4Geq2lQuK6SdT3wXoTfOLRyhLVRzg+NuIebdMXJ1AHv/x5U9tA5w6KCyuZv3i/uPca00WIVfRh2fI0uv/dE/Py11T0W4XmN90IEFNHyBZiFj/ZtR/QUXlQ7Ru/wlIxIMzjNHDhFfNoLXsWIgPAJL4eJSn3uMxhuY2ytxygxEicLUBS0Lj9hvBSoWtprLkxfWcp2rR0pOqhvBtz2NVoaXlilynbZJHevsZ/S587s0DYsMNDv2uxn64y3ynBSzqevA3FmvPPxcWAKxJx/p6lzF+Jm2lywbHKrMavTWZyIIkRZltH6ZtxMnyV4CuDwKDAfpKQrQTcs11Q7xqroDpNP7H0dgfU3LvbzT0FeonuxhwcSXcTawpOQc04dge3cZU+1CkhNy16sM6OLQgjPft46Ue+WVZiM5Dg
 M1S8tSfp
 dY49DGrgt6CALBYX5Cafg+S/aLDFRSniE6D9JwLCuAvpKCSg3X4guLsCKP5z1uMeIgsT7Tc/TH3/TgbAQKCWzeDc2ufL2nJvNZG7QRz4wBxN9XDaLWYC4NlpYvVwyUz0xwkh1U+MisGM+xGgy9oyT5uNFZX3S3YajpSvTR9MiiN4A4Npxb+Bd7OutWL3spFG9LI+z3sB6FlCVGbzGHtXNAY6X0DNUkU3M2g/N4hxA85x0TONvuwQVqGViPFgUxqia04v6cXpYwyHt+x2QM2tyqh2pqeNp2m+q4XOXVBWVhsAS8A4ntYr1PHS8qG15wTdi2h4vyaeN9FVz9vryhknKDWYX0fetYnG4U7XZHg5y9kfbuWx/w1WE52nFuSsm8QHelBWnyWEMFQ2WQGjoq+F0wdQHgBRPSF7j5Od1LP039uejBHVeTLZ5jXJm8O7EiR6rN9Nece8ihdJXzwFg+iaQfnKMGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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


