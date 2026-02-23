Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 542D1E98DF1
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 07:05:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B9796B0098; Mon, 23 Feb 2026 02:05:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9503A6B0099; Mon, 23 Feb 2026 02:05:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8088D6B009B; Mon, 23 Feb 2026 02:05:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 56BB06B0098
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 02:05:04 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0F4758BEFB
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:05:04 +0000 (UTC)
X-FDA: 84474834528.05.903AE91
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4904CA000D
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:05:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cWSY2EUs;
	spf=pass (imf25.hostedemail.com: domain of 3HPybaQsKCNc35D7KE7RMG99HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--ackerleytng.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3HPybaQsKCNc35D7KE7RMG99HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771830302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LofWqILwJgF/mJhvsOWfJxePDPZCogY694ZgccXLsPg=;
	b=Bp4kvmfrHZnwnFPZ+4S92Hvk6hXhXlZDQ6gQMijJu9DvAnDCCKxltaWFnQHOUAJGo0Bgb7
	ej8HhItU/CEiVCl3Px9v+983m/Sfx/g30g4FEJ9AhefL16iJMkEk+6i9fTRqWVBTrPknf9
	kF3WPZc7sivkToEVP6zJedb5Uyz7Ww8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cWSY2EUs;
	spf=pass (imf25.hostedemail.com: domain of 3HPybaQsKCNc35D7KE7RMG99HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--ackerleytng.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3HPybaQsKCNc35D7KE7RMG99HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771830302; a=rsa-sha256;
	cv=none;
	b=4rf37mi/lyUL2Q87280O12IAs9428rr4j+GnGlci9I635WiE2NNwaRznGcRfT4LzTxKOkU
	DlF31KcksIV0KYynTF+B95nFUopzDFlk5X/Bw5otl24aqlGmBAVZu6S3C0xbsSa1dA9vYl
	8m6P+huG4eVLKTn+xbNRiS7kVpYS7SU=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-824f75913c4so1823913b3a.1
        for <linux-mm@kvack.org>; Sun, 22 Feb 2026 23:05:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771830301; x=1772435101; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LofWqILwJgF/mJhvsOWfJxePDPZCogY694ZgccXLsPg=;
        b=cWSY2EUsvQL5mPDzqlRJbZohY/P9SkS9c9+1q0Igj7SN+3NLmU9Y7bn3flqOa9VoFY
         oxq4THeR/A56HbndrZv8jQ31pj6Qv6Du9AHKfX201Jxdmwh10ddGJ5hH4uaJHcd9jkoc
         yVqm1BhjEX7x8fWV0S87f5cWoFO7H97Lki5rgE9dOgeNbOjKSmMQSWJxtrNRYOY7+IV5
         cpIlnp9k73TsrPuykBcDtm2lNftYUaVzDyFWhWJZCaIKmO5hirUcQdvwZKjS6CrBb0yV
         MMNhJe+zWbsnaFuE+ibuq7664LEH4TxaRU6qTC+BEUJrQ6v5rN7Rm5yVkkUqoDiecpfq
         OpBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771830301; x=1772435101;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LofWqILwJgF/mJhvsOWfJxePDPZCogY694ZgccXLsPg=;
        b=rT7t/t3r3DOjj24gfA6vPDqIp3Em+i4O3SXC1h3C0IL+azJX0DQCiKCzyhBH1IcHe1
         kX6qCzt2ubIQKlpYDL1CNPTSe/0kiWkLtEczm6Djl3HQ0ZLaaq/9mI/03jF+aXsll+RE
         9VYT1Zge+1A9ktoAbX5+gYkHjWkNNsHkjTFE0UK2l5yhxUzLc7NkfLDV24xmyLMrujmg
         nVCSKfAscBXrWUjww5ZVhkgmP7wB2OnmofR7kf3ya6mZqpvYgGmxZKp7K7L3qSjLEDWR
         a7MZuk1k2Ykc+e2REYIqpkCgq1YSL++Eurj40XjsS//4hs5RogVVuC1fua1kWDEgvv4E
         wd8w==
X-Gm-Message-State: AOJu0YzH1aYTEpCR9JISrlzEVcYwfu7tNJJhYa80NEMRl20PyjD7EWbz
	bnANuYtj4mk23/FEnfUmK+ni3AoFmPBfwo2rcz1hvleydKm4HGSwW//oxK/ExWuESK0fT82AD7p
	l9z0jGhy1Z5pnuco2f1YknEBe8vdWHpBAqOMNPs9dViNQXYY/tQfBZqBeZxNJng9sZML3vf6skf
	6RkP4ELozweNguKBSa2myDdvx1Hzu/hndSoSI17BciJRDpx1Vma0t73mk+Yg==
X-Received: from pfwz14.prod.google.com ([2002:a05:6a00:1d8e:b0:7cf:2dad:ff87])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:438e:b0:823:3056:78c6 with SMTP id d2e1a72fcca58-826da9f10bfmr6260281b3a.41.1771830300774;
 Sun, 22 Feb 2026 23:05:00 -0800 (PST)
Date: Mon, 23 Feb 2026 07:04:40 +0000
In-Reply-To: <cover.1771826352.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1771826352.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.345.g96ddfc5eaa-goog
Message-ID: <976ac2117ed9be6339e898cd80daed8f32b5044e.1771826352.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 07/10] KVM: guest_memfd: Implement custom truncation function
From: Ackerley Tng <ackerleytng@google.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, willy@infradead.org, pbonzini@redhat.com, shuah@kernel.org, 
	ackerleytng@google.com, seanjc@google.com, shivankg@amd.com, 
	rick.p.edgecombe@intel.com, yan.y.zhao@intel.com, rientjes@google.com, 
	fvdl@google.com, jthoughton@google.com, vannapurve@google.com, 
	pratyush@kernel.org, pasha.tatashin@soleen.com, kalyazin@amazon.com, 
	tabba@google.com, michael.roth@amd.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4904CA000D
X-Stat-Signature: 1apb4w9dnexfa1i3ntwmmabc9jsjr3pe
X-Rspam-User: 
X-HE-Tag: 1771830302-969063
X-HE-Meta: U2FsdGVkX1+OdcjFFhofSG4AstmvPxP9NELDFqOzvTNQbU8ZIiLrhI9aWYvKPkYnfxrEOt/rKyH56Qk3mTYv7r/hNLttZf1nPA9xAoUBEvo/MQF37yAOGOxl08S9v8SHC55utH0wwoH00lsfYEyPE5iJ8OSaRCsIh0PBQ3TjeDVBn37ZuwgVnR6rCSw2LRZ0i46/cJwTHIjFq8j+xJbNauYNrsSkqMluMC+oR2Kt84ZcKqgNiDEQBMeLOeyn5BH3kOGNwN2sj0EyijLkWkYgLw+d76GELmx33kRyd3t1onnnvmmPTCAMGrEQgD5C0IE8K/oUHv57ZGXfglLK9RUk0xAp75BWfOwxOIIRFunhyX4Uw820FyINaVzcwB6hSjH7HrcQtsjG5mrOwcmjSzl/NFkjCq70JfSfln5hnV05+VjKPu4vMKiUxbcQn5isWLZJqkbDXjBBTH5Okqkvlz763zh4t+JvPtUCcwKmx0HFF61hQjAOLfq5oa406bO0a4QSNivnnWMjylySvdFoYpSIKbkom2onSLjLoTTpXZV47B7OPTG5sFM+acUTyYz4kKfm/9IQ4CUFP+68cw+lPeqaD5BGhLc5eY60MLydwBUnEn3XeEDKclQ0SDR9x2SuCuX1kAR7v5Ve5ZdDKvGltNykdIuC8eLDwSeuyBtuY4KuW4qqKmsxNY45j4Z54qqKcr+CTJneMelWEV0kLNntUfyPZLFW1ao2+hWU2Tcx6oxvKy5LiaSlnolgJg4Kh7z9rpeVIrY+PN+DMY6ARUSMUAazHpYhOm9mhNAMhphyuhd9pl7PpMOStEEj5srzkkdx+O2IkVDjBUD/m8WRXr4C3DSnaVKXYQtPyiYv1x1BLvLKFoYMKbXTFURGojM+gTPIzkp+3gFiKcpNwE8wvG4xRewNWiVZzeAYDRS6U3rK1lLaYtkvWFtMR4bqu5TidgcKh1H17JBDwT7JgcQ29/DCan6
 PBWSboTh
 LcnEvGyPrVhLNSpvw1imEemdpBzE0it0SUlZzh8eH2SpisYPfr1BsAixKwhTxfxHKLkdpiDQoYQtlSjyVosVpycaiJ1ZyL3QulUoVfc7rdOwJfxuU2iUB3W9A5R7nHu/5YNqO3MtUsJlcMeatFcM9a6925DM++rAFQ/zBdfeMYeC0UaZZFGPv+px+/RDXfgG0XMuc1L+HbMDOmpiroIP5Nm+IgpWlDp9dRZEfkD2l+EiblGUjFydfJBVuDNQHD8yQiOa6kgL6grwAm1oo+n480GZpM9yn1B8mGFs581kg2AtYASgpU5aV25w9tnuHYyODqPTgDxT2sPYrjHqd7PGG/1giHdYnHMKaZVwks7kqsC7rOSgJG1tdiOgDq+JgaY6xETC2ZIWNhb2CMY1lT43SEdwVVIP2omRqRd26LOoBlLYQiAVvVymEPIfG6YzV4Ay9XEKTYC2qZiMNzyBUbzPF5pdlGwVESQksbCL5t5lT7bCcip10SflFFS6ZfEq56lCdH9AoJmmM3dbLiyibr0a8W3qR+HNNsuAxPEVjUeDwqgvH2lZ2iROV/SMxWIK9+v18NWap/UCbqmfNRUYcAuI6Z3fGjR5i8XaSi646OcJwWqkqG6IR65O5x7MAFjIgpI4Lyvbn9ihabAtV/E8WYw+FiFnA0xQGE/yZ6Q5ONFd1wJTR13CmBVP12ZZ1wP0k+YuiCjNAsaHHXdsMy4V1nYXhI6axYbOMCLXe/eF/n/32hCgVBG6woZoxEo1Hzmv5NEJt8k15
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement custom truncation function for guest_memfd, and replace calls to
truncate_inode_pages_range() with calls to this custom truncation function.

The custom truncation function removes a lot of the generality supported by
truncate_inode_pages_range() not required by guest_memfd, such as

+ sub-PAGE_SIZE truncations
+ Support for writeback

In a later patch, guest_memfd use this custom truncation function to handle
updating of i_blocks and i_bytes in the inode during truncation.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 43 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 41 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 57dec458bfa77..e6c66ab7062b3 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -247,6 +247,45 @@ static void kvm_gmem_invalidate_end(struct inode *inode, pgoff_t start,
 		__kvm_gmem_invalidate_end(f, start, end);
 }
 
+static void kvm_gmem_truncate_folio(struct folio *folio)
+{
+	folio_lock(folio);
+
+	if (folio_mapped(folio))
+		unmap_mapping_folio(folio);
+
+	/*
+	 * guest_memfd doesn't need writeback, skip anything to do with
+	 * writeback and just clear the dirty flag.
+	 */
+	folio_clear_dirty(folio);
+	filemap_remove_folio(folio);
+
+	folio_unlock(folio);
+}
+
+static void kvm_gmem_truncate_range(struct inode *inode, pgoff_t start,
+				    size_t nr_pages)
+
+{
+	struct folio_batch fbatch;
+	pgoff_t next;
+	pgoff_t last;
+	int i;
+
+	last = start + nr_pages - 1;
+
+	folio_batch_init(&fbatch);
+	next = start;
+	while (filemap_get_folios(inode->i_mapping, &next, last, &fbatch)) {
+		for (i = 0; i < folio_batch_count(&fbatch); ++i)
+			kvm_gmem_truncate_folio(fbatch.folios[i]);
+
+		folio_batch_release(&fbatch);
+		cond_resched();
+	}
+}
+
 static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 {
 	pgoff_t start = offset >> PAGE_SHIFT;
@@ -260,7 +299,7 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 
 	kvm_gmem_invalidate_begin(inode, start, end);
 
-	truncate_inode_pages_range(inode->i_mapping, offset, offset + len - 1);
+	kvm_gmem_truncate_range(inode, offset, len >> PAGE_SHIFT);
 
 	kvm_gmem_invalidate_end(inode, start, end);
 
@@ -984,7 +1023,7 @@ static void kvm_gmem_evict_inode(struct inode *inode)
 
 	truncate_inode_pages_final_prepare(mapping);
 
-	truncate_inode_pages_range(mapping, 0, inode->i_size);
+	kvm_gmem_truncate_range(inode, 0, inode->i_size >> PAGE_SHIFT);
 
 	clear_inode(inode);
 }
-- 
2.53.0.345.g96ddfc5eaa-goog


