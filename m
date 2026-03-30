Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B126FB3CF5
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 10:12:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADE6E6B00AA; Mon, 30 Mar 2026 06:12:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8E3F6B00AC; Mon, 30 Mar 2026 06:12:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97D4C6B00AD; Mon, 30 Mar 2026 06:12:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7C4E56B00AA
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 06:12:43 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 42ADC8BFE0
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:12:43 +0000 (UTC)
X-FDA: 84602315406.26.29243E7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id AC3BF140007
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:12:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Vz5P/Ehl";
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774865561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e9y2awS9LuRlealZ4Gy7NH1RFxFMmoDwRiQnqQfCsJA=;
	b=qFbtCcctWeHpXx7L0d1X332I0Okh2W5NgQ4P8W/UcGW/87sUu79PxNnNZXPC3du8hDwSqH
	5T36SY3YYcWisEKbm1UFtoVT8Vr6oaDvZCCeWf8KcvJ2qeadTZdQPLzCSV1S9g00RP2z7t
	6J1L2oWTaBktGX65gKWDgfnDQ028WL0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Vz5P/Ehl";
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774865561; a=rsa-sha256;
	cv=none;
	b=4+teRhGqnkwc5VU9Ys+hurkW2FxZaX/m4l9klxHm4ojDjzUSTxeMq48WoKFFtaFDdd8tCX
	dR4koGASwhae+U3OuH9rTzoTu1+bbMHCBaXnVoWBsF8xGUFpCYJaQL0ox4Rcd3yrfhVasQ
	5IzqB0RsTsMEzxBMivN2cHEjZwltNXs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3BDAD60054;
	Mon, 30 Mar 2026 10:12:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF1C3C2BCB2;
	Mon, 30 Mar 2026 10:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774865560;
	bh=5vaQGQBc3neyldkli11Rg6Y+SDtyLj7BMfixF4/GPSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vz5P/EhlcbGrf+EmyrZRJlmlJMQol7XOzQNEor1Xg8Btoz8JyeEVcJwg+zd3jjia9
	 79uY/smDhLCPcI2vi/sG50tuN1FQiIJ5GJEFQZFBRzB/UNYlGVAxij9dSHQvV3kn16
	 UrQNH9lW2NvzWOT4w/05YnP6ez3HMLGLcwuNdxcv8+SXpC4Tt7TPIf6aUcQR+L25Wk
	 z02GZvjWjqt/TTkKbwfaurOmdXFBzGou6+Y4yglTGV6i/CqRIqc37p4nniK0sH/Ytw
	 6mGvTJTgBidX783DjCgVKlho/aslUpIMMPjjG2rFpGM3akpXKXCB1ht1u/v3+8bRPO
	 BpF9ymuGtg1bw==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
	Andrei Vagin <avagin@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Harry Yoo <harry.yoo@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 11/15] userfaultfd: mfill_atomic(): remove retry logic
Date: Mon, 30 Mar 2026 13:11:12 +0300
Message-ID: <20260330101116.1117699-12-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330101116.1117699-1-rppt@kernel.org>
References: <20260330101116.1117699-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AC3BF140007
X-Stat-Signature: qbk4mgo453cbzodqf8fab7cjdi71hc3t
X-Rspam-User: 
X-HE-Tag: 1774865561-431492
X-HE-Meta: U2FsdGVkX182Ojr5mIxql/jBRbPQWHMMO07I7zAALrKyUHRINMFlDpahIDSXBQCpOpHT0e7z2+ctQ4Py38OjDVsupeH3b6034iGKS8meGeiS3T9olBI2/7eVIUR9+SYeb3xSJrAfCLz/v2zJfueYlx6g53IEyZlCVJNyDarpU3S0wOkQutaOTTYQtNkyldTaBMl41m68xAHuCgGVP6top087266igDhlbmX2/KH/RD/RCMsxypdj/I9a9sU8pGHxitfvhVvmopGupS4hipCNnIDW50lK98f3loRQ5QvvVsOczqJjpjAVdvUZfmPLU4FnY8qtifVzJcDRrGzbntSB2bd9CT5mN7TLyJVcDPJg2zc2TNSQnSlgqjsmAS1VOyTRO4WloguM7O3XaFe0r6Qj0OevjmY/NYyzz8rxHp/eamvvfGQ1hymI1vxc3EmpAtBoPdtIGs/1O80UEYarmVEJHjPP7ZahCTpKjtChcGl0QBJeUg2NACFVKE7e23fUVB3yBYEYtwfDu/NFpvFugv8kG5iVlzDhSg/yE9KuHHS3gozwmKx1n/DYMhEr27B/2Vr5snyGhGy4usD2H/U7VJGJl5L3tiT/almhwQWTuZq+XHPGtyM1fEPoKK3L2y23LNJetoNAeGBr5r6UVUT8ggxuSSwPnygarEjDGyPMX8mP17hzw1GNOE9VaG61JpWYVZ+HI00AOgNIMj+fbbE1RKNDNFoyVO7jAyaev6eOUBzplhMAbyvGbnmcbISkFQcMqpbL9irsIvpHVGtd3KiEc2T9l/t1/GQc1DQMCeNfUSeDoJzjmR6IYx7UqQqUnrdAu5WK0fQBHUr/63VZ89CHwc7NRXjiipXTQNVGQiHL1yVD4v9RefmJRHBtXamLnNXNN8v+XXIpoMNO6c9jJF9WFh87VeSKt9G110ncA0j4kdXovINCTPxoEO+tEt8tEDUUGQJJhkHuL2X1ZbAGA5nMocu
 iGWq1xYd
 yZaoKqR6aTVKXqEwJmWi0YkJjqDa4iiXTtnW2tGQ3ZV9Qd1haOSj3HjU5LA2+Ckz1o4LuAdDOTBqUj22x0N6LP8jJVldZN6rNz3gVLwpL8FacaFRtHmilWYnconlenE2lYjDakwZNSwNlRZvc1CnDwWy++JhmkaaGoyryy8OY5pCyKQOqxHCEwdUx8ZNyqDJHZM2txmUDUv//rmSxbunxeiYOTeFE3C93ocCKg/2bYOmECqb/2jdoAUW2vbAkcyXeSZQe5bUSAQjvx8Ji4Pea2cKXRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Since __mfill_atomic_pte() handles the retry for both anonymous and shmem,
there is no need to retry copying the date from the userspace in the loop
in mfill_atomic().

Drop the retry logic from mfill_atomic().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/userfaultfd.c | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index e672a9e45d0c..935a3f6ebeed 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -29,7 +29,6 @@ struct mfill_state {
 	struct vm_area_struct *vma;
 	unsigned long src_addr;
 	unsigned long dst_addr;
-	struct folio *folio;
 	pmd_t *pmd;
 };
 
@@ -899,7 +898,6 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 	VM_WARN_ON_ONCE(src_start + len <= src_start);
 	VM_WARN_ON_ONCE(dst_start + len <= dst_start);
 
-retry:
 	err = mfill_get_vma(&state);
 	if (err)
 		goto out;
@@ -926,26 +924,6 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 		err = mfill_atomic_pte(&state);
 		cond_resched();
 
-		if (unlikely(err == -ENOENT)) {
-			void *kaddr;
-
-			mfill_put_vma(&state);
-			VM_WARN_ON_ONCE(!state.folio);
-
-			kaddr = kmap_local_folio(state.folio, 0);
-			err = copy_from_user(kaddr,
-					     (const void __user *)state.src_addr,
-					     PAGE_SIZE);
-			kunmap_local(kaddr);
-			if (unlikely(err)) {
-				err = -EFAULT;
-				goto out;
-			}
-			flush_dcache_folio(state.folio);
-			goto retry;
-		} else
-			VM_WARN_ON_ONCE(state.folio);
-
 		if (!err) {
 			state.dst_addr += PAGE_SIZE;
 			state.src_addr += PAGE_SIZE;
@@ -960,8 +938,6 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 
 	mfill_put_vma(&state);
 out:
-	if (state.folio)
-		folio_put(state.folio);
 	VM_WARN_ON_ONCE(copied < 0);
 	VM_WARN_ON_ONCE(err > 0);
 	VM_WARN_ON_ONCE(!copied && !err);
-- 
2.53.0


