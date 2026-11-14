Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7907E606A32D
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 11:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=Kjd02PN0
Received: by kanga.kvack.org (Postfix)
	id A0AB46B05B2; Sat, 14 Nov 2026 06:26:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E1CE6B05B3; Sat, 14 Nov 2026 06:26:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F82A6B05B4; Sat, 14 Nov 2026 06:26:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6078A6B05B2
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 06:26:14 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 036551A036D
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 11:26:13 +0000 (UTC)
X-FDA: 85433495868.27.010EFDE
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7D5AC40002
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 11:26:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Kjd02PN0;
	spf=pass (imf01.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794655572;
	b=1Rd+zPZVBBhkjznuTEGv7ni+tihQEYB6+PVXRhSxJzVmbfnnwRrSGBPDYdScqQN3eZyTZp
	d090ee1Wl3AOXT/U4e9l8daeVeEwxUjOEFGI37c54h/Hsu7CaGOw30R1CAe4/grIMF5+Jx
	OPwFd+kQ+BqXh2+V1bsbW9jwvh9laXs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Kjd02PN0;
	spf=pass (imf01.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794655572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yojspyjk6M/XCMUXwgemrJOhlA57VD8UrAkmCoHaT+M=;
	b=l9fLnRaDdpBrX/kKyq+CWvBJ6f+sJ6GzwjtqzsYPtGVRFf2yHdL1zgJLzEuIhECFqg1z/V
	XySm67PxNEo2Rfqsq4CQmDqrhNR6XGQeGFEd1DzlDcCC5s/RQMcqpMI0/hjvxc7WT21MIn
	r4Fh8iDOVSD8ld6NVGK/af41XyeWUzw=
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-36eb1cb7aabso2374456eec.0
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 03:26:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794655570; x=1795260370; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yojspyjk6M/XCMUXwgemrJOhlA57VD8UrAkmCoHaT+M=;
        b=Kjd02PN0mYVcGpA9bpugKw1eVlI/AQZNrBYcdOn0gulkaTVogcwpHs1Ll5yObfWFuA
         NpkTZqe6nzEDae3jjC21ENyq2lW2leCH/F6HI6MYONmO8hbko8X2kQXYFzzytas4iaTc
         agV/Z93hhrgbqNogm35Ysaz4ls9v8Bkq0+3OhpNRQIMYHYQw219e4A/txyf2vao4do/9
         qQijyqEJVJLhZX5FoJNSQwQGJqIwaBb5VtBQx6TrcD8Ml54juvvOwMl87BStwsZQdG4u
         5M4qa5EBw2spYbOefsMK+5dPfyVALv0banDesTISm7eUnxRreDZln951vZtlyvzZ5mLe
         HGcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794655570; x=1795260370;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yojspyjk6M/XCMUXwgemrJOhlA57VD8UrAkmCoHaT+M=;
        b=hTafHKr1XJCCRpkY/GElfmfWUR+FE6sgaw8Z0MWUS9zX8qB3Qfxk0G+nBxWsGNdi72
         xDiqh4p5dHwtieD7bvoc98B7hjs/zcRnUJqOszYWiF5DXeKa/mqPQK/wOFAuEK1uRJsW
         ONv6rtzw8cKO188nA61C9VGk9iJgm5BixD2wZX08ixSEboH7eE4L+rlPW42wCR2i0xnR
         5i3KTzLDo9tPQSVg9L8CCJ6+Re+FJeSTQR02KtA26k4W/6biJFysOIZAtugxu00CFHSF
         q/GXTQmY5wPWzSjTHlTyqi+p6vAyksba8oHXclnMPnwotY2d3Kf5P5SNTCg3icaQYuf2
         r0+A==
X-Forwarded-Encrypted: i=1; AL+hErFulNYM9gsansQluC3vqYe4JQLhlZ4MTdeNNg918tor/DS8mZgqV10zU2A8KES+FX2if3ikMtliwg==@kvack.org
X-Gm-Message-State: APuU4Z8g8/n3Ruvb3hZTuoRVQHvJMejc+WjVHaBajhBmDS9PVOFQkoJo
	nhEEhzIRdSYzf9YtaaSWPL6XwRSRaHBsVzK/616hS4Fb5UbUQXmWqLwpZ+ZWb4Z7eoM=
X-Gm-Gg: AYBFou25wL7awY93p8RSOC8BzlNXhKkWWnL8H413+HEHZ9YQ3OVEUdYGkjTjf/DL+dm
	hwHFOaIIn+7s7Fp+htCJBdcqAtgV9VV5s+by7fOs8ej1aGutQ0QaFURO9y6CJNu2+YJl23nJO24
	qrd8j8uon+JuO4w1PQreuUDjN2+eSs3sRTfwTj9Th4Fyj1vpFzXyoEzM38Qg7npBzLgH+HYJDOu
	AbsZO9KwQl2dJezj2xs78hLBB5LXd5HTg5+9DSeSifVY/a5h+SXsGZFbH93CXtCHbGfq3rpXlWR
	9mhuG+99HeSl9lFbSF3U2+asujnfjx3MPIGTTMFYI8N1gxreXFE+CE5tMv1zwNNhUXDbiw5SPEf
	5E60AsZdhia5L0fBpd/as6/6DrKWR6iMtYElSMJtWpXv78D3Tq2CsAF5hjwsyVDSfxDprtNkziC
	CJPX8aYP04D0Xmb72a1V/yivkd4xg67Tg9HuDoj9tN159ieAaAXw40b1wWC5XpaQDIAo9NFtswQ
	q7tASev5Aquz61WFdiE7kqS+Ah4oY1p8eyBfEgypfDgSos0ZKcswBucmkkm71iyYQEvtZRTWf38
	L9Fhawrs+54tR/SW5V9nbYldTzVqA58zVimQFspryFy+O9+dwHYpS3/IpmvsGfKLLJ4DGYuKt7L
	lEWDj1w==
X-Received: by 2002:a05:7300:5609:b0:377:a1c8:a628 with SMTP id 5a478bee46e88-3796676addcmr4689862eec.6.1794655569869;
        Sat, 14 Nov 2026 03:26:09 -0800 (PST)
Received: from G6L4RL2QG9 ([2409:8a00:1832:6900:9d36:3b30:f4a3:7b5f])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-379553316fdsm16190627eec.5.2026.11.14.03.26.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 14 Nov 2026 03:26:09 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Sashiko <sashiko-bot@kernel.org>,
	Jiaqi Yan <jiaqiyan@google.com>,
	"Jose A . Perez de Azpillaga" <azpijr@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 2/3] mm/hugetlb_vmemmap: fix PMD split TLB flush race
Date: Sat, 14 Nov 2026 19:25:22 +0800
Message-ID: <20261114112523.75208-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261114112523.75208-1-songmuchun@bytedance.com>
References: <20261114112523.75208-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: p6zpkpzbsc91hfmyfzb7yh1xs4td4s65
X-Rspamd-Queue-Id: 7D5AC40002
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794655571-482406
X-HE-Meta: U2FsdGVkX18eQEsciDxyP1UWp3MDPlJlNLUMy+5IeeKcAJLz7Jd/cgZTS/RB1b2wQnHdZuvcgEIQHgN+6aGZXzIjatp1IR9HC6zTk91fdgBj/LFvrN5HQD2m4mjMc5vVZAJCZE1tQYUO3J35Ha72jj1v7DcLIFWnk6ZS0FfaCCbeb1hMHIPEcAQkHbdbSnIoO++1rEUEzWgDAk1p6PTrhVeNHupr6xLdnHmnV3jN+pO+mGBDrwqhWaAVgM4kMx1VMQSuOg3j7lUddB0/bg0wDvaunN/3YXa4Gt9xgJEQuv96h7hIgDOLa03Fy4/4n0NS76LwAwzlkOZwXMAfQwWPlyAQeipN6PHD4B90K2tXDCllEXld6J4hUL/o1mmt72Sit8zMxpUUOyclVp0UsEJcXJS1Nc8NvhWwvUK2K4Y6Wll1o584tAEdmHsWliZHP/GlGryQRoq1uHHCx5vi6E3Syd7iHQHJFt3HcUTJd9nz4Ox3/1CnAT1663I1uX6sNgR0F9HjNInqKnNYzp9c2aNtMfuH1tX9fS235o1IwtGy2LUs/P09+LSmtysNo6lUe/I/3ocWuHRQDIqbwOTQ9WmDuyGpLldYq+qJJdfzH8xXByknbT6jQ2qgeUneD65c218Q+bcoHsmia/7IhjrHVi3VRx1/i2r70BR/VZmS3CRheiOc6sW1hKo0o2q34v13njl8f7GHG6Jk9Ut1nzTqaIwzSSBClbsB7dLbq6gjJIPIWSiyGczKQGKw05rRNnoX+xI8BMfcWEHY9TK7lrgE0ERz6VUDuFP8x+/0jXKInlNn8folVge1ABWcyl/0l5iN0A+VqlN3ktAdSD9dMAlRvKWKIYCfu6ROU+eg26hszEOoBs1BvXkMlweTwpS1jWRzM4g+xhKQP5BA1c8+PDy0PMqQddIt89ZY24qeVbxF/qnrNdbF95Q0Cr8zD2pngnzxyVyhXNVISTYLMzb1zxw6qht
 f2YzRXTb
 x0caXWE/ic66wGSs1/Ga33BnapnOT9fsE0HagjRW6L7Dr0XC6W56j6FJf94ZRif4q51MMZQ7RleAvNdO7JM5GdbuN53zpaAJF4npBvInCwiJUmD4pXI5RMJelZke9V8n/ON6yx1gsbZhMQ4LpMprHWznmoL1kkszRfcPxo0jh/DUHUQfbiaSV5iPWP+P3TfrfJQ2o4nVKnqxkw/RNdnvFtXDpbVbnAjcBfL3GzgdVppDHZ2lbK3IHuY9chljLCDlAujK+we+X2iBjG83204CDX1A4MKi2ucbMmhkY8bbx9E2rseFLFOO/+LjvXiyuy9iJy1iprXrfuZGcOwOOSzmrRz0kG93bAIC/ZjsbEbgLWpqUyfJZWH58blodqWiM3ArmKE5plMmYIeyjx3wNWfQRReR6mwoEe3tDRf8QtfWC0GwuaE/ZWuo+h6VQHxtfXhfMLl0yNerfeTyTDctG//pD/HYA/6Pn7f92MXwdWlTdolSXwxvENZN0AOqxbhxDAeKH1iRKAT+bPJF5x4ZUl8B7MPOyXAOHWi79S4/u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Bulk HVO optimization converts vmemmap PMDs for a list of folios into
PTE tables before issuing a single global TLB flush. After publishing
a PTE table, a concurrent single-folio optimization can observe it and
remap its PTEs before the deferred flush:

CPU0                             CPU1
hugetlb_vmemmap_optimize_folios()
  hugetlb_vmemmap_pteify_folio()
    vmemmap_split_pmd()
      pmd_populate_kernel()
      /* TLB flush deferred */
                                 hugetlb_vmemmap_optimize_folio()
                                   vmemmap_pmd_entry()
                                   /* sees a PTE table */
                                   vmemmap_optimize_pte()
                                     set_pte_at()
  flush_tlb_all()

Modern MMUs permit overlapping TLB entries with different mapping
granularities only when they translate to the same physical address. In
this race, the stale PMD translation still points at the original vmemmap
backing range while the new PTE can point at a shared or replacement
vmemmap page for the same virtual address.

Serialize deferred PMD splitting against PTE remapping with the HVO
rwsem. Hold it for write across the split-only pteify batch and its TLB
flush, then downgrade it before remapping the folios' vmemmap pages.
This guarantees that no PTE remapper can observe a newly split PMD until
the stale PMD translations have been invalidated.

Fixes: f4b7e3efaddb ("hugetlb: batch PMD split for bulk vmemmap dedup")
Cc: stable@vger.kernel.org
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/bug/linux-fbdc3410-a4cf-457e-88e6-684380fbadfe
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
---
v3:
- Collect Reviewed-by from Jose A. Perez de Azpillaga
---
 mm/hugetlb_vmemmap.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 79ca68dff635..6fba3184356c 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -311,6 +311,9 @@ static inline int vmemmap_restore_range(unsigned long start, unsigned long end,
  * is skipped, the caller must flush TLBs after all pteify operations are complete
  * before remapping the folio's vmemmap pages.
  *
+ * Note: The caller must hold vmemmap_remap_rwsem for write from the first
+ * pteify operation through the final TLB flush.
+ *
  * Return: %0 on success, negative error code otherwise.
  */
 static int vmemmap_pteify_folio(const struct folio *folio, unsigned long flags)
@@ -321,6 +324,8 @@ static int vmemmap_pteify_folio(const struct folio *folio, unsigned long flags)
 		.flags		= flags,
 	};
 
+	rwsem_assert_held_write(&vmemmap_remap_rwsem);
+
 	return vmemmap_remap_range(start, end, &walk);
 }
 
@@ -400,6 +405,7 @@ static int vmemmap_restore_folio(const struct folio *folio, unsigned long flags)
 	if (ret)
 		return ret;
 
+	guard(rwsem_read)(&vmemmap_remap_rwsem);
 	return vmemmap_restore_range(start, end, &vmemmap_pages, flags);
 }
 
@@ -568,6 +574,7 @@ void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_l
 	if (list_empty(folio_list))
 		return;
 
+	down_write(&vmemmap_remap_rwsem);
 	list_for_each_entry(folio, folio_list, lru) {
 		int ret;
 
@@ -592,12 +599,14 @@ void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_l
 			break;
 	}
 
-	if (!nr_to_optimize)
+	if (!nr_to_optimize) {
+		up_write(&vmemmap_remap_rwsem);
 		return;
+	}
 
 	flush_tlb_all();
+	downgrade_write(&vmemmap_remap_rwsem);
 
-	guard(rwsem_read)(&vmemmap_remap_rwsem);
 	list_for_each_entry(folio, folio_list, lru) {
 		int ret;
 
@@ -620,6 +629,7 @@ void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_l
 	}
 
 	flush_tlb_all();
+	up_read(&vmemmap_remap_rwsem);
 	free_vmemmap_page_list(&vmemmap_pages);
 }
 
-- 
2.54.0


