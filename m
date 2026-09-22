Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 784F1C982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 05:35:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73C716B00B3; Tue, 22 Sep 2026 01:35:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ECCA6B00B4; Tue, 22 Sep 2026 01:35:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6032B6B00B5; Tue, 22 Sep 2026 01:35:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 372136B00B3
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 01:35:25 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BF433120385
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:35:24 +0000 (UTC)
X-FDA: 85240285368.09.A456252
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 913F918000D
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:35:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZfWgnkUu;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790055322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xEEzUKmwPcuLDb8KHUBfxekosp3Yw5qO1BP0yTFVDsQ=;
	b=z3Ded/vvi7JB/oTTajUfXb4UCjDyprgcWbMfB6L9Yiv+DTiiGC/icWDxWhRl2ee1WisK8L
	GIhIgJn2+5/hJ/yWZhUQ0tniLw+1wuI9MxequDXLiCsOnp/hnIyJ7RaUOK1vr/Q9oEN3DE
	WwCJLodwI0yf9qGdkyNORhasCnh8fdc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790055322;
	b=1x382wdt9BLJ9YFq9WvMYOUO9c4jQ8WKBk64+gg4fomr/TSCySmLPeWGwipOlQbV6Qqb5m
	/Fm2kHlPVJg2SED76T+VJRfQPuWinJHpXJqSznRC8u2y14RJVSwDL9ZRJiMr5QSwWzD6BD
	Wu4TfP8iZFZ3lu1JxU9+k+luki83WbY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZfWgnkUu;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790055322;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xEEzUKmwPcuLDb8KHUBfxekosp3Yw5qO1BP0yTFVDsQ=;
	b=ZfWgnkUuT8BOMZ6/Ov5jFi2KSaaNCmDkX5umKNBEsKvsGD9DgOJ+HJIsSz+043/znjaRZE
	qlqZ+MBeMYKTh55pu+DRCOx8h0cQb7avlbFU54m27nUd9ine39pv4bdsMUwJBldKYEvWCd
	CKNJuBSzAA54aeY4fVqkIDplb6M+Fe4=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-450-LV6R6U-XN7y8zCsRWm7fig-1; Tue, 22 Sep 2026 01:35:20 -0400
X-MC-Unique: LV6R6U-XN7y8zCsRWm7fig-1
X-Mimecast-MFC-AGG-ID: LV6R6U-XN7y8zCsRWm7fig_1790055319
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-5b8c58cd8c0so2124872e87.2
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 22:35:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790055319; x=1790660119;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xEEzUKmwPcuLDb8KHUBfxekosp3Yw5qO1BP0yTFVDsQ=;
        b=kEV8P5yExxRNRxJfr5h09Clrd6TN1UiIo1UBg+bDJZhNcDBb+Hi7A0G+A7TgIDXUUi
         7qhkxd1WeD3/fT5jztYS8TL1W84mkGkmNXYoYN4iHrd8RNw3I/Or2dG6aVkCPCQL+QdY
         gYZN2R/i9XpI4IST6KlSpShLCg5Yb78qtRb75++j/aN/198La8UaAmprA+rBgTOaCfiW
         u5LesZhZQWBI5RpRNRVQTq2kVRKi5rANbu7izLJWTJe6fAZzDXWEInKdDdSO4wvPXhFh
         /4nPA5a9zYvCHBh32i7hCT3fKbw12kAQfrHbz4noTAK0I3wk+yB+6oPCo0Osxn/s4Yd1
         0B/Q==
X-Gm-Message-State: AFuF++ljKmbHmqdU4cRYWxzpHWOg8K3sIzWAC7Yu36TSGbV/3IPVClfp
	7bcL66GuxaoBj25cwXBcXvKKfvqM2WR+p9sZLUDpyIKkHWbWQCv3yTz6g0K7c7sD1SebTySNBZo
	cDn5sclq+8rIgGvPRMIvzKEVOojRWVI/z3Khj14xgDv3IXzwUm9LENF5K7xlqIU7mIWo3J9r14i
	5nKmoWakY4Vc51egbTRnN2FGLJwqxYTIWUtz+lVg==
X-Gm-Gg: AYBFou2Nb9YlYoNnFrzemMUdqJG5Fb0dOxzP0F7zx0ne+sLsJ3ufRDN5RpXBinySDhT
	Lbd5s9tp6Xbf5lKMrPJrMYFhjb8wUrNrFsvtFEDvSjSEQdZ8qbAIQKy6EstZMKbPg120G1E5Prx
	QzsgbF1pnkVNL2gFn/2lCykAXlGNScc/bzIXLEK+syFE+RiBPMDdXvsCYPyNq/x/9NAj0ZvkEwl
	mSTPmxWBFB5bHkmZX81SIeyhAvYK01IyBD838HdE4WGiZQKUYu3JSMQLcMVNyWCC0zb5gxnCDkr
	FcxhXvX62MEOFj5uloS1h6iSKrNdwiqeIaYdaArEPM0iaHMcXHUDsOW/VXGroBNR1jz9eBWS6Ir
	2H9LksPxheBhgbv7Z2Kt8
X-Received: by 2002:ac2:51c3:0:b0:5b5:e86f:3550 with SMTP id 2adb3069b0e04-5b8c1833648mr3732751e87.9.1790055318654;
        Mon, 21 Sep 2026 22:35:18 -0700 (PDT)
X-Received: by 2002:ac2:51c3:0:b0:5b5:e86f:3550 with SMTP id 2adb3069b0e04-5b8c1833648mr3732729e87.9.1790055318145;
        Mon, 21 Sep 2026 22:35:18 -0700 (PDT)
Received: from fedora (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b8d46e0966sm191742e87.55.2026.09.21.22.35.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 22:35:15 -0700 (PDT)
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
Subject: [PATCH v14 12/12] Documentation/mm/hmm: document migration through hmm_range_fault()
Date: Tue, 22 Sep 2026 08:34:21 +0300
Message-ID: <20260922053421.4092027-13-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260922053421.4092027-1-mpenttil@redhat.com>
References: <20260922053421.4092027-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: o7j37jrGKtBjCYAI-ESrs32I2cDhjRs0NuR0TxOzFSE_1790055319
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 913F918000D
X-Stat-Signature: 9r1w851gssofqxj34octqzcuo6q4p3no
X-HE-Tag: 1790055322-133927
X-HE-Meta: U2FsdGVkX19FNG2sAZ/8PaM+4FbiqVyvxY1JYzIsJqMB1qNU6uBdCQ8+13Wtdz4UYyRSeT5did4bqytb9JJaW+j5Xz5CS8xAm5nQ2aw1MtDS1JU0zLWXkfU++lNMH7uOPUS8RkSAJeYnPidorIhyOGaWyaEO40K49Tbme2lnVOWeXUyzIp98JSo/e7K9BeLzeSrbibw/EYNC5e0Ir/YfRiNSOFqi/+p6ucca7JL3nwNLQGfFTVIrY1h9YrJzNeNkKIFkzwYUVk46+szOizz9ImIBDv9FN0WGM8RkY6N/zSkcX/Pt6xso+UxnUx9nqdN/bKhRav0T9OzaFcm7BcrwaN7hew/PiWUdABedVlDMPQkpIBFsBRGuUo46/3ZmwHnoyti19tdMuWVQ32KAQlCjrSB6j/yY46k7kqMaqm+ZmYxW73eygp1jnU3g5ddc0BMmgZhUnTfRm0O6iyUNh3zewOFjzfBH4qcb41uvGJIOz5hHrjpGz/CSuHBwiIRjagMFeffXfijWfgVx8WzQVs8pyJS9WJemMSoU2yqsBm5YQhyVeMTnX2n0uJd49jEyD06yukJL1K/5sMaCj5Kc4aANx34KHHW760d6iIzIowc5buAiGEzD2oa/FOkLXM/bsZPoyVyJ0DSVZUVwJdVDXc+ANpE5E++dgPoAIxq0wb6Pcm36AtHyOQhg+SXyWPR01/Ug5NlA9fRtasrh2xwKK+AQ0i68toi4d1eXAK5MgjcxSd5C0d1X7Qsa+wtw8VHQJQk1ax07Mpqi0Qg4GUQqAY5V8kmiQlPfxNNgTHqFqZ09bEzH5JFuOw6Vz+mbva0H6IvotzvbF/YA6LIAHms1e7DdDNL/1orQWz4b2Dx8mJtUveQugsrSIy3ndO3Bs4xxL8iBHP5gawNjmQsfQ4UkrzETcIvnJuvesUftZ3zLGNyI2HB3Z8Q8FKYBEyf8EFigDAmzH21Uk/CjCcI9blDm+eL
 OZQZie23
 RatwhB6ON5/zhwblWvEaf3aO+f0tPUq7Yx1FRB/sf9AHfi1P1DLQvvMO5bjF3+y1y2A/RJpn97E+8UnN6vOZ2QDJfnsoDhNaMG9C0cGkTsxFLyFRLma/PGDZCQsws3fNIapK+4vg3smorO8f8SYnQB2XkFzSlEvQrUyBQ5JwTUY3vszeRGqCZqpaLlhDn/RUfAboUyfiXB2o2yC3XKYhF9ocFO6FbgMSGzotO2Q7OCrBpO17KhHr3wL94dTA3gv2aGJb2km5hS2rS7Jftf85mC2rT2uMX/Yy/J6BWVGvfV5eHjdMjVDuSKbEdCRkMkhpClqJYCTCtpy6EAZ3TNwpV7+/NoQJNrJfa58yVEBXxPqkyz3l5P//h4CM0ZqeGFBf8XgssUrKTxJ030DIqAbFK2SwGQexWvFm4Nqo/FEcPU97kViV40e5hlAbibyZmlHWQYq0Nx0BFoaCYRkd+IVltPgDURA==
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


