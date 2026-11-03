Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98C6F606A324
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 21:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GEwro61u
Received: by kanga.kvack.org (Postfix)
	id 825EB6B05CC; Tue,  3 Nov 2026 16:20:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FD456B05CD; Tue,  3 Nov 2026 16:20:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 629766B05CE; Tue,  3 Nov 2026 16:20:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E9C3A6B05CC
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:20:49 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 689054057B
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:20:49 +0000 (UTC)
X-FDA: 85395077418.06.FFEFB26
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8DED51C0005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:20:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=GEwro61u;
	spf=pass (imf20.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793740847;
	b=q2O0t0cnAGYy01HUJrGY9WU/MpQR71RDcOYfv8SbTvGts3H1Y93OvwyJNvYMpajw/9E+pQ
	jhDYVBlOtOqIsIYKFi/cIK9qLTs2BeLY0R6zSD2+DyRvYPhumYlf/faiaUTojcC0pl65IA
	vaeDO2b2nWkmYeJKNlHsCRjlrcdk+M0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=GEwro61u;
	spf=pass (imf20.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793740847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OZ6XLqG5LRudiOsl6Zbb90YMCl32+mvVGLRJTzftgn0=;
	b=btiBiDOx+NyqLgK8MR8LHlnfOT/hE55MESKWQuhpYtR3gaoliemCx7cVjL2dHsHA45fmF9
	O8N9R8kX+bp9dSXZUzxZzd7FPjkZmSzb37ayhEInuN/qMt7339hwAjqtzStba8k6i292cx
	DeEFkKjqqtF3Ts2M3WAoAa23Tqnrw+c=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3ad41b47541so73014a91.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 13:20:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793740846; x=1794345646; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OZ6XLqG5LRudiOsl6Zbb90YMCl32+mvVGLRJTzftgn0=;
        b=GEwro61uy4QfgaC2PkjBQn7gEn1zt49nHHhlm1ZqGsaoe+2hMCh1iB6fXIvHksC9Gf
         vsxZ74AOF3JFW1N8vkIvDsiZk78L5iwtmMJgXFxcD4ojOKVb2knkRzQ7PNCVEy+1S6nP
         WovqnUayOsKS5YP9wklCTq1DEBmYsTiuKkYeZckDlhGYYQedei0ovqzqQSXvJyegQ8ER
         HxMhrHXeOISbNyQLfr5kac/asbt2AfW3NsBs/ih0CYvqqWMGtkF/7ArOkG6V/fwqbvPd
         GYppDaBOBMwP+YEuk5hCFpo4EtZFSAzDLB2GQeDmBz0Ki0nqamAcuJH21cDQyl2c7zta
         v6Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793740846; x=1794345646;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OZ6XLqG5LRudiOsl6Zbb90YMCl32+mvVGLRJTzftgn0=;
        b=uLhNfBgeYw8JNy6zOfmpEBAuhfybijOM3B4NGI3b62hkOrqL6ByStof9FmTPVVzEJX
         DsVq+GH+8wHOEOcz9rKz5q9VsmDPKIsvzHQUR3lLF8Fp2v3n/k8K7hJ7FwjoodFpjK+U
         icRXa3V1Zea58u1sBak3TrLpPVQNwVTToPJ+qXhEdvlKJNDKvop0066AmsyZbUCoTZ0i
         bvbLOvNo7laCQ0fWZ1ZTMMUrkdiIm920ms8wEruddc1X3Ik9+qMKkiKnG39hV0fuX5DJ
         yJOZLFikf03bPxrepudCwzVEG8u1rIJL6M3F3INLR796hqDgQV49VVCHSN7ihKUaJOR8
         wscQ==
X-Forwarded-Encrypted: i=1; AKwUvBzrS+V5oWm0857fdV4kLIiL25/GIOFZXui2VkTXD0SkYEGlXWbxWhfiejEJVfjINKQAe61O8WGPEg==@kvack.org
X-Gm-Message-State: APuU4Z/ZarXLsQcY5D7GYSfGYC4ISIlSEMk5vfXiMFl1pOL/OTxmF+9Y
	LZlFzmpq63nLPd6n5DS2vy8914CNkAONnuHJaQ3whuS10Iee+ghd04kf
X-Gm-Gg: AYBFou1ZqubP4J2gHZfXFjgGGTy3f7iTRoh++ziz6Az5DE8Q1P6fAiAs2x45S4n610+
	cJLBz/vrVtBbdt+QDPW3kehnsJCKDnxrKyUn1XhkakpOM3Rx2suDOHHvqHGfToqLsaYYjMzUZX7
	+K2NPYrnuKX/NTPjMMISJqw6957dSqC1gpotd7nRKQATDcoezDaOJ8K5XVQRGYaz5+L7Ldhp3bI
	8pfV8Gj1Z4dk1j0KlA3y6ddosPdob4SaHzLVG16e+DYNhjsl+zDUaUyfcnfEd+L/xW2iHO2tgkI
	umWsC3vF7CFb6pwLWyTs1zTwNqnWmF7pZz9wSBykIoNxSZU4tKiFMXWymcyC4z2jTfWjtgpW7Bk
	OVkvxVT8Ox/MtQtsfYOFWf6HuCYjN6y3cgFCT+NDlMyoK03S+IzXup8nLyH1vK5rRbn5y74M/A+
	cyWJRQ5JNePs8L7isWN6oXQ1X32kTWlgdakE6EXRr9pN8w7oRWg6qEyDhKJuUkA9rWV+bFw1jVf
	nbW4QYYrsqTEgy890lK1EalQuxN/C/DbXW4nqirYobJReeyguxoL0rFMKIDsML8cEUmU8Nrcq3s
	EAjo/yx1GsaMUXIEJ1snpmTjtWPk1hCvZ8VQvuDyALnQXu7rOCAATQ9PfanzJK/EC0WKPtIRNdZ
	3zPAEiQ==
X-Received: by 2002:a17:90b:584c:b0:3ab:d26b:c2d1 with SMTP id 98e67ed59e1d1-3ae89724955mr12139638a91.11.1793740846460;
        Tue, 03 Nov 2026 13:20:46 -0800 (PST)
Received: from localhost ([2a03:2880:ff:45::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b08759344dsm3888853a91.13.2026.11.03.13.20.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 13:20:45 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: baohua@kernel.org,
	usama.arif@linux.dev,
	hannes@cmpxchg.org,
	kas@kernel.org,
	alex@ghiti.fr,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	willy@infradead.org,
	linux-mm@kvack.org
Subject: [PATCH v4 4/4] mm: add anonymous mTHP folios to the deferred split list
Date: Tue,  3 Nov 2026 13:20:04 -0800
Message-ID: <20261103212004.1356327-5-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261103212004.1356327-1-joannelkoong@gmail.com>
References: <20261103212004.1356327-1-joannelkoong@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gkeki1nsrk9f1oskz1xsg77sj1e4rz8n
X-Rspamd-Queue-Id: 8DED51C0005
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793740847-556643
X-HE-Meta: U2FsdGVkX1+7CXJtXsAKw8lmZWmTkMb+kSNByuIUHfQNnesGh3JceSL05babWZsU6o5xHJgOwRjYbca/GWwNMMlkuVyy5o1+M4aiwSDSolYtqMnPFbREdiMutQ+5mbbUeV41IIw9gotEHxKKHy6qlrNRGtjnvRTAuQaVIsz+63bfJ2nkB6eYwoGSvry88lcrMyWz5bICiPN6Vr6YHv214FgKJIbu8bqAJD9xGel6m1Q7z1EQqmcnKYBAak2gIPPJScarobZtAzGcc7AEmhj4HEEQVN012Ahh0bU2pPwDjnXXxYV3VcmLbB8DBys71YEWZuzFpRQbZHNoy2VxbVhFJ6dGVb1Vi33wZAc+smzrGzzM2QJRYTApUcHS3j97i8W32SQSFXmuKcSQGiok9MCH0Io6QpKn52H1gnjSWF6oVOLK16cDuoL+JVEpFzxxnVbfZggPo0NB0E2xjtLbkJOB7NgimlDle6zSsj5UDOB1LSeVkOvWZDVBQhssS/peQKwHvWDUGzDsvdYACCNWO0X5HIwPc/JGqp01w+iriHGj7WeKp6swiwhpgn9k/Q7TsZFDlE823X530bz9Z+d2/xNwXP+RDpGMJP3lSFhsTeVypVmq4OvfcC+4UhcUqktiuIb7ahQ5XniruZlFNedTYb4ZRKCrZ4Fywbr3rEG09PXyjhY7/rHai+iVhuezaqzOczFZXXuuN4jNTAP3BtutYf+5V+ARb6A8k1XgnMx0KRj3BArpw1wiUvBxgl5+//JVwmV/D5DN20Z36TDqKuO5/Tak4KuJbIMWI63VMZ6eGJb8nN73S/nAnqd/c9hzgY/9KDk2RGB43dzCuBCfInvOH6MtHsdbyKG6KdKSMZN1XoYhjxLMXYO/xHmlBpSA+TRzZ1Bu1eCcGsZPhJ7X/oULLzi4O0NZASoksOR9okOV9T+Zy88Yy9ADfGvnaBBwUqLpqgOjlOxvx0nzI12v52QfZr8
 1JsxlsiT
 OfYbp+qZaAcQ8yq/GiguUZok/65zjP7eqqLw229g3vMeBxK/pJcwYSSaRUMzueGsWfvjpEBVVoAYn1Vwil1ye1rd+KLYs7YBU0CTq0cHfN0eXnmS/iRM3w2lZqna4Q6kChFQoglXMQNm8s1EiRuE+1fUCDPV+J8pydeSu8TJBuO3EDYnPl+9xuqUH84+zdsBCT29uedxEm+RROJZznZzLwsq3S6vFme/x/mx4WDdvNJ5Hp0cuKnRqgBVE0ynOUEurvFT18oNrKXWGfdwQrlD70ZGrm16KEjljGIrupt5VSOUJVh212ZkG06O778jGnFW6lW141Xhfudde5ZxuaYAjtgkzx7xGR6qDKYmvgMWtNiCp3DjQOIIXdtBqqUzmfG6c4nUp8VG8hDj6AzgQ4kmGUa1X36MseHt2fR/JoblDCzbYyUN5HdPL2W0WXjdMg3aNPbXEbBMVSzQmEsc85JCwPZlw8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Unlike for PMD-sized folios, an anonymous mTHP folio doesn't get added
to the deferred split list at fault or collapse time. As a result, a
fully mapped mTHP folio that is mostly zero-filled doesn't get split by
the deferred split shrinker when the system is under memory pressure.

At Meta we would like to deploy 2M THP=always on arm64 with 64k base
pages, as 2M gives the contpte benefits while the PMD size (512M) is too
big to use. Without underused splitting this causes memory regressions,
as the unused parts of those folios can never be broken down and
reclaimed.

Add anonymous mTHP folios to the deferred split list from
map_anon_folio_pte_nopf(), mirroring what map_anon_folio_pmd_nopf()
already does for PMD-sized folios. This covers both the fault path and
the khugepaged mTHP collapse path. If there is memory pressure, a
zero-filled mTHP can then be split with its zero pages remapped to the
shared zero page and reclaimed.

Only queue mTHP folios of at least 2M for underused splitting. With
thp_underused() scaling khugepaged/max_ptes_none to the folio size, any
folio of order 2 or above could in principle be underused, but for small
folios it is unlikely to be worth it. An order-2 folio on 4k base pages
can free at most four pages and on systems that only enable small mTHP
sizes (eg Android's order-2-only configuration) zero-filled subpages
tend to be few and short-lived.

The minimum is hard-coded rather than a knob, since admins have no good
way of choosing it, and is a size rather than an order since what a
split recovers depends on the folio's size in bytes, and the same order
means very different sizes across different base page sizes. It can be
lowered later if data shows smaller sizes are worth it. PMD-sized folios
are exempt from the minimum in order to maintain backwards compatibility
since on some architectures (s390, with a 1M PMD) the PMD size can be
below 2M.

To minimize overhead on the common order-0 fault path, the
deferred_split_folio() call is guarded by an inline folio_test_large()
check.

Suggested-by: Usama Arif <usama.arif@linux.dev>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 mm/huge_memory.c | 14 ++++++++++++++
 mm/memory.c      |  2 ++
 2 files changed, 16 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8f90fb609e57..cda3c886ec53 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4575,6 +4575,13 @@ static bool thp_underused_never(unsigned long max_ptes_none)
 	return max_ptes_none == HPAGE_PMD_NR - 1;
 }
 
+/*
+ * Smallest mTHP folio that is queued for underused splitting. Kept
+ * conservative, as small folios are unlikely to free enough memory to be
+ * worth queueing and scanning.
+ */
+#define THP_UNDERUSED_MIN_SIZE	SZ_2M
+
 /* partially_mapped=false won't clear PG_partially_mapped folio flag */
 void deferred_split_folio(struct folio *folio, bool partially_mapped)
 {
@@ -4600,6 +4607,13 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
 		 */
 		if (thp_underused_never(khugepaged_max_ptes_none))
 			return;
+		/*
+		 * Keep queueing PMD-sized folios as before, even where the PMD
+		 * size is below the minimum (eg 1M on s390).
+		 */
+		if (folio_size(folio) < THP_UNDERUSED_MIN_SIZE &&
+		    !is_pmd_order(folio_order(folio)))
+			return;
 	}
 
 	/*
diff --git a/mm/memory.c b/mm/memory.c
index 0c9ed04528d8..44376321180b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5477,6 +5477,8 @@ void map_anon_folio_pte_nopf(struct folio *folio, pte_t *pte,
 	folio_add_lru_vma(folio, vma);
 	set_ptes(vma->vm_mm, addr, pte, entry, nr_pages);
 	update_mmu_cache_range(NULL, vma, addr, pte, nr_pages);
+	if (folio_test_large(folio))
+		deferred_split_folio(folio, false);
 }
 
 static void map_anon_folio_pte_pf(struct folio *folio, pte_t *pte,
-- 
2.52.0


