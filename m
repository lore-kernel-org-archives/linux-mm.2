Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9710ECD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 20:50:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCE396B0095; Wed, 20 May 2026 16:50:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2EF96B0098; Wed, 20 May 2026 16:50:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5A776B0096; Wed, 20 May 2026 16:50:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8C2C16B0092
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:50:40 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 272D0C18D1
	for <linux-mm@kvack.org>; Wed, 20 May 2026 20:50:40 +0000 (UTC)
X-FDA: 84788991840.30.F7930FA
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf23.hostedemail.com (Postfix) with ESMTP id A844E14000E
	for <linux-mm@kvack.org>; Wed, 20 May 2026 20:50:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=kaHUHZAh;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf23.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779310237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lHY+0X/XJqFghNgGFrGEkGoxXASaR9D81loKQ4ufczw=;
	b=Drfv+NEk164C3y2ClH9NFSgOdVy/Kw0ZsEexNMEeGZTOod6DfJJq+T3D2UsZ+IVfPhyDrS
	NEWic2UmQGfuTucGGSmlifLokEDgAV5QkSjInV8uJ24nn5rMqnWrQ1cPPikSxJrxxBywdm
	xh7P1G6flkW7xsiyiciZ4U3AYu+ne+0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779310237; a=rsa-sha256;
	cv=none;
	b=o8JAoaqR92lh1HbeotHKHht+WItQatEON4l3kp4bC0QbjZCqZs6yqEfGxN7ZjxqBip1cy0
	Z0ZO5FSv2/sDziNC+0A959nUMEdV1euZa8Dt2Ekh4H1p4ZEt3SYGVI8GCvwFhebYRB+dbf
	ldDQPGGKX5z8gd7gwBc/sKNl2e4U03U=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=kaHUHZAh;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf23.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64KKOHww1271189
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:50:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=lHY+
	0X/XJqFghNgGFrGEkGoxXASaR9D81loKQ4ufczw=; b=kaHUHZAh5ZMtAOg1RaAj
	fbvoq/zZamrz6Io2iKUo7qX8XFb2X2N4rSt8roOrwC/x3OdUaWhDCKDjUdOGViTv
	wUyo1b4PO6QxIUbl4HLUGdQKig6n1wo2iLN2YhAHMfDrFlUwGWu/9+jpMMiV9q4F
	CvidoNIBEpSziDNZr14flzKbcrTTlmS+iFpkI9bVeQNeQLPF7SlhURKthgnK1dE1
	JCVuIc+UVoVmqL/TBqZ6D/kUh6IEYE94lQ9t4Xq/posBDxTg0GBppkSluc0p580X
	l5+gzT81I4cSwgz+QvpI0PpvTmydo724t/ENIYDVM9DIho8cC3xYgwVia92Jl2DE
	JQ==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4e98j6wc83-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:50:36 -0400 (EDT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-90ffa709073so1230014985a.1
        for <linux-mm@kvack.org>; Wed, 20 May 2026 13:50:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779310236; x=1779915036;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lHY+0X/XJqFghNgGFrGEkGoxXASaR9D81loKQ4ufczw=;
        b=m7igZgZD4PgJ731qCoCA8BPNqDyScL5o38hJCNatOJ/SvOTPIKTRVYOjxrW1vpDOFX
         tXTnusrkOjpzYQbQtAKflRTXA3ELcoHIDLl75GP55zg/uXXrEV/qYKCatkl4WlAxv80T
         GgyUCIlCgmcTmje2Mbpivrwmlcl5Y1A0I+aE0cs4XxxIsKITUXdkYqs+P0iZ+EnUqv3x
         sWTE4x5VWPUOZL23VlO3a9f/E5b6RI7bXUX973KKYIbiVV0n0/75jyLVjLphk+dh2UU7
         v+yGtdyb/OEtdGPTdygH04u4REBtK2eSvpDjJhECIlZt4QA2ZT8VWRrwAOv8SzXQsjpL
         SxXw==
X-Forwarded-Encrypted: i=1; AFNElJ+Vfha7wz46wDu1QdjhX9K2O7nqZ1Bkn34q6UOqFj90az/3PSP4mponUPigyByV0YNavQOrHuVGvw==@kvack.org
X-Gm-Message-State: AOJu0YywG9HPgTIjUjo9QjxWh3aZCiVgwTPrUI48ksgRj4Vr6MBcCWnf
	6WVWJWLf+lnIAIMaz/WSpXnUJSP0hO02WkPS9t30DLggHkUmseFM0F16zBORdhiGNXEI0S+P75G
	ILYjEs+lCEb6UThJ0JCtzWEOIvISOGCFirOknG1RAM7p/px1d
X-Gm-Gg: Acq92OGZCrYkp+BMgCHwA/+acrEsgR6Yi87qXHKrD1mjq8j/sld3qh80mASk1nVZx6U
	x/zajUt/7CWEb4pmEUvOrTbT2QK6Ak8d8PAFszCphhIKX3DKb886YSurTYvIPcctgsbi/u3uOVu
	xrtKiaGE/RnQpwi8ovMGcSk7Pm20AS+CsUD7N5LTB3RGCpVqG/Oov8QKMjsGNcYf3fmVoKyQYcZ
	5KOCItN75pj0dprFpznb7iSZTJZuZ9PRdMVQ3qIdGsy00ikYB0sou/9GhCTDq9fDS/qXaTAitQ9
	sAAw+OGfVDtBhRaaL4W50MEY89EiAcamgx+YgeEKRDA6dD/M+REWnbcKkk8fHNXKaD6oCf96JxU
	2rWp12zWwRvW5zeiOFEuU/P3fHSGuefsabApnSY+EIrSuLKgRou0/CqOtyJDP+moX1q0=
X-Received: by 2002:a05:620a:2846:b0:90f:e17c:145e with SMTP id af79cd13be357-911cf4f4aecmr3823665885a.44.1779310234486;
        Wed, 20 May 2026 13:50:34 -0700 (PDT)
X-Received: by 2002:a05:620a:2846:b0:90f:e17c:145e with SMTP id af79cd13be357-911cf4f4aecmr3823648685a.44.1779310232558;
        Wed, 20 May 2026 13:50:32 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910bcf37274sm2232692085a.37.2026.05.20.13.50.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 13:50:31 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 20 May 2026 16:48:53 -0400
Subject: [PATCH RFC 02/11] folio_wait: move folio bit-lock and wait
 implementation to mm/folio_wait.c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260520-filemap-split-v1-2-c36ddc2b6cf2@columbia.edu>
References: <20260520-filemap-split-v1-0-c36ddc2b6cf2@columbia.edu>
In-Reply-To: <20260520-filemap-split-v1-0-c36ddc2b6cf2@columbia.edu>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779310229; l=42905;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=5hWRNnMyazR8+zx31stM4RbPYDDKhrjlnmiCkgNsqt8=;
 b=eRUUmgWS62zn8ouZx6cpoJmD4CATyRCEyl9KcvZyyVYzetqLLPFRD0R2kKNpcyQc/Q6p0uCUD
 VfjB659XL0qAPPVzPTGOzsuozp6E1QlkBNZAb9PnDkUWJ1K+B3thAGm
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIwMDIwMyBTYWx0ZWRfX+AoWp0ZPvuWr
 rzVA7TK+Du1I5ipzp8GktVaRo4ZAS8EdscUInbTAyjxLUSTWOUqBzJuVWDp6d0NXM5aySCT5ySU
 0F5w/TTsb44t6dw/v9fYAXnAKaHFMv+SAzGHYe+BJIz4WDsdUNAawVkH5f63G8/9wtV+BtR5ZeH
 6eOyFbXuaqle6taBcInAtLUJdPBvZ56UclGiPWgd68W2r1y9ItBjhpiUXtzVDeKHjIIFkeWa7Gs
 I7oudrImpaF9+sGD30FopVh4N73MUZe94kOLpijoD0WFrfDw8vn9cwDX9/upptJ64tJUiUL0jNx
 XiAoRALTn46Wmp7yfryUNhj/5diwcEB9EHvyz06jm5bmzZyIomQnMczYcAbmGtDCTEStHgQgYgO
 06rJkcWmZOL2+e8BZ+3SjX7Ob34iibyD5hYR+Ea57NDtglIgmjbGZ2Wfq5TvF503+75JcPdeham
 iX6Xm3eNZPkzTHzk6WA==
X-Authority-Analysis: v=2.4 cv=TsDWQjXh c=1 sm=1 tr=0 ts=6a0e1e9c cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=QOCMdifcju39GKoXhKua:22
 a=03yOF3r4bum_QfZ1A0oA:9 a=QEXdDO2ut3YA:10 a=O8hF6Hzn-FEA:10
 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-GUID: YQhF-lHdi0yFgV5IFaYYzLkXQ1meJi4S
X-Proofpoint-ORIG-GUID: YQhF-lHdi0yFgV5IFaYYzLkXQ1meJi4S
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11792
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 suspectscore=0 phishscore=0 lowpriorityscore=10 adultscore=0
 spamscore=0 clxscore=1015 malwarescore=0 priorityscore=1501 bulkscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605200203
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A844E14000E
X-Stat-Signature: ykjja4uqyzsmz9t8sc49gfb9169mfsg8
X-Rspam-User: 
X-HE-Tag: 1779310237-236892
X-HE-Meta: U2FsdGVkX18BMjfJjPsJCW/nyDsQHa1OZOlZdY2CUN07Idk6/NDYTBb6zc8d7h/24uU2mRLybleDa7SoRHqn/qxyg/ll1wXh2SMr+0mQamt+kEb8sb1Ophakn8L4bYtkQiZcv7wGW+cuQPnHYAtaRy9SnYy5d3ylNyd0I/Obol5RaBUON+We/NbkfMhjPt16Lns3ty3vnVQknLwcMDkQnLWpzlO8W/sxGgkbNU1o355gZybK4/SCpynxC4T23RP6c6UrIOD0EGZvfNXawWl8QSXsnZgwC373aDIGegDwuAKh7YPPCQD0DzdhBVbxA2zv5sgRw0S9YSvySStPpQYBWEginhhP3+yuBTIa4Uzp7iXeNzERIlGClMpk1rSez9o2iBX1muMiM6FilfSE34Uru0IyCsca6XTAQoKdNSZRRfUe7riOtZz6rSHIsxQ7TENRnWpl43TQnnf4neVA6EnceGP905vZ0sjZyObdQaljbEfLj3CTwy0h7T+rVoriC5OfoV1TOhv6DMQm85qYyTWdEvHFSwBB4bFFmAfA7iAfufzqgAa2KzHZSU6dVhyrmj+m1hnOuWuS4dOh8TJi3jmdPWT5dsDRNWl+W33BN7I9yxV8VYrevdINhw+rQl/hwA10GaLe4Sfm/fvm6TaMI4MeISP0TSbGa0gqG4tDBHCrFC/qtDC9PJJHHzkHB8yPDIVGqpXBkSGl7F356YeIoje1bs6I/CjEa5iPtttBouLqBLrl5cWd7SFqsCBg1kMDMl/+1Q7PeLsBgEOZvsd8k/Vzg9FuIFSwscc2g6T/FRl5stXZtajmQLj1WL8oQ1xwWldQ6SRqhxPYbfh7cPbtxMux0qZ0BoLhyOceFqv0wclw3v+NESuLWr0Z44QlM9m3nTeOQ/TIq7CFbz+2DWDHH+OoWD/CLe8GAIaFmjxYvxci0RSpn+CuI7qM42uYaRQnbr08hf+qpSSC8ZGknfTtz7y
 UZZ2ybaN
 l2JvunmH6ZSf4GYaWpQ6Khot2tlN6mGQm3eNqJTiLP3nsCHy1KAP1+xfHULRE4+U4eNZYcrRWJsypN0ar5SSsCUzhafP8q3QuKFmT9+GuRQkDqpZVwzG01gC7xbB38uUvz0KkO29e+euHmPS9MiIQpCo2WHQm599/9z1nV81XFGwZJkkNKmrZUK7SuLEdad7hFm/kAdxFWhw8n1wQKuzrIZItfyR+KwGw0TOy6EBjYuY1ahu+RjWK7cVkDBfSYqjhQO1ZeMnzXPg8BprJn2zlGd2wCFAYTklZK8PzkMVuKI3QPvPurgs3Y4nnkQGyvrh/pFqzCsQqfHJIUlUjjavDsSegPD33NwPd0jur5k6WUvZXrOngJD+V0OFlkHkHClAYGlVjzl/YJ1HAZiVzOQGh0PQ2ACSxbGbK0UnX2XBexejzT+f65Hc+OqSuHXqmiA6efHnrD9nIeN4HBDas7CEfuGq8A5SIcRyf/uRZ8Zx/uhhlF5l31BRYyUWOlVJyAoXvb/Vh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mm/filemap.c contains ~600 lines of folio bit-lock and wait queue
infrastructure that is logically separate from the page cache. Move it
into a new file, mm/folio_wait.c.

folio_wake_writeback(), folio_put_wait_locked(), and
__folio_lock_async() are made non-static and declared in mm/internal.h,
as they are still used in filemap.c.

pagecache_init() is refactored to call folio_wait_init(), which
initializes the wait queue table and page_lock_unfairness sysctl.
filemap_sysctl_table is renamed to folio_wait_sysctl_table.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/Makefile     |   2 +-
 mm/filemap.c    | 640 +-----------------------------------------------------
 mm/folio_wait.c | 662 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 mm/internal.h   |   4 +
 4 files changed, 668 insertions(+), 640 deletions(-)

diff --git a/mm/Makefile b/mm/Makefile
index 8ad2ab08244e..65ce5afe7692 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -52,7 +52,7 @@ obj-y			:= filemap.o mempool.o oom_kill.o fadvise.o \
 			   maccess.o page-writeback.o folio-compat.o \
 			   readahead.o swap.o truncate.o vmscan.o shrinker.o \
 			   shmem.o util.o mmzone.o vmstat.o backing-dev.o \
-			   mm_init.o percpu.o slab_common.o \
+			   mm_init.o percpu.o slab_common.o folio_wait.o \
 			   compaction.o show_mem.o \
 			   interval_tree.o list_lru.o workingset.o \
 			   debug.o gup.o mmap_lock.o vma_init.o $(mmu-y)
diff --git a/mm/filemap.c b/mm/filemap.c
index 567742fbaff0..079f9c3ac8a2 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1053,561 +1053,12 @@ void filemap_invalidate_unlock_two(struct address_space *mapping1,
 }
 EXPORT_SYMBOL(filemap_invalidate_unlock_two);
 
-/*
- * In order to wait for pages to become available there must be
- * waitqueues associated with pages. By using a hash table of
- * waitqueues where the bucket discipline is to maintain all
- * waiters on the same queue and wake all when any of the pages
- * become available, and for the woken contexts to check to be
- * sure the appropriate page became available, this saves space
- * at a cost of "thundering herd" phenomena during rare hash
- * collisions.
- */
-#define PAGE_WAIT_TABLE_BITS 8
-#define PAGE_WAIT_TABLE_SIZE (1 << PAGE_WAIT_TABLE_BITS)
-static wait_queue_head_t folio_wait_table[PAGE_WAIT_TABLE_SIZE] __cacheline_aligned;
-
-static wait_queue_head_t *folio_waitqueue(struct folio *folio)
-{
-	return &folio_wait_table[hash_ptr(folio, PAGE_WAIT_TABLE_BITS)];
-}
-
-/* How many times do we accept lock stealing from under a waiter? */
-static int sysctl_page_lock_unfairness = 5;
-static const struct ctl_table filemap_sysctl_table[] = {
-	{
-		.procname	= "page_lock_unfairness",
-		.data		= &sysctl_page_lock_unfairness,
-		.maxlen		= sizeof(sysctl_page_lock_unfairness),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-	}
-};
-
 void __init pagecache_init(void)
 {
-	int i;
-
-	for (i = 0; i < PAGE_WAIT_TABLE_SIZE; i++)
-		init_waitqueue_head(&folio_wait_table[i]);
-
+	folio_wait_init();
 	page_writeback_init();
-	register_sysctl_init("vm", filemap_sysctl_table);
-}
-
-/*
- * The page wait code treats the "wait->flags" somewhat unusually, because
- * we have multiple different kinds of waits, not just the usual "exclusive"
- * one.
- *
- * We have:
- *
- *  (a) no special bits set:
- *
- *	We're just waiting for the bit to be released, and when a waker
- *	calls the wakeup function, we set WQ_FLAG_WOKEN and wake it up,
- *	and remove it from the wait queue.
- *
- *	Simple and straightforward.
- *
- *  (b) WQ_FLAG_EXCLUSIVE:
- *
- *	The waiter is waiting to get the lock, and only one waiter should
- *	be woken up to avoid any thundering herd behavior. We'll set the
- *	WQ_FLAG_WOKEN bit, wake it up, and remove it from the wait queue.
- *
- *	This is the traditional exclusive wait.
- *
- *  (c) WQ_FLAG_EXCLUSIVE | WQ_FLAG_CUSTOM:
- *
- *	The waiter is waiting to get the bit, and additionally wants the
- *	lock to be transferred to it for fair lock behavior. If the lock
- *	cannot be taken, we stop walking the wait queue without waking
- *	the waiter.
- *
- *	This is the "fair lock handoff" case, and in addition to setting
- *	WQ_FLAG_WOKEN, we set WQ_FLAG_DONE to let the waiter easily see
- *	that it now has the lock.
- */
-static int wake_page_function(wait_queue_entry_t *wait, unsigned mode, int sync, void *arg)
-{
-	unsigned int flags;
-	struct wait_page_key *key = arg;
-	struct wait_page_queue *wait_page
-		= container_of(wait, struct wait_page_queue, wait);
-
-	if (!wake_page_match(wait_page, key))
-		return 0;
-
-	/*
-	 * If it's a lock handoff wait, we get the bit for it, and
-	 * stop walking (and do not wake it up) if we can't.
-	 */
-	flags = wait->flags;
-	if (flags & WQ_FLAG_EXCLUSIVE) {
-		if (test_bit(key->bit_nr, &key->folio->flags.f))
-			return -1;
-		if (flags & WQ_FLAG_CUSTOM) {
-			if (test_and_set_bit(key->bit_nr, &key->folio->flags.f))
-				return -1;
-			flags |= WQ_FLAG_DONE;
-		}
-	}
-
-	/*
-	 * We are holding the wait-queue lock, but the waiter that
-	 * is waiting for this will be checking the flags without
-	 * any locking.
-	 *
-	 * So update the flags atomically, and wake up the waiter
-	 * afterwards to avoid any races. This store-release pairs
-	 * with the load-acquire in folio_wait_bit_common().
-	 */
-	smp_store_release(&wait->flags, flags | WQ_FLAG_WOKEN);
-	wake_up_state(wait->private, mode);
-
-	/*
-	 * Ok, we have successfully done what we're waiting for,
-	 * and we can unconditionally remove the wait entry.
-	 *
-	 * Note that this pairs with the "finish_wait()" in the
-	 * waiter, and has to be the absolute last thing we do.
-	 * After this list_del_init(&wait->entry) the wait entry
-	 * might be de-allocated and the process might even have
-	 * exited.
-	 */
-	list_del_init_careful(&wait->entry);
-	return (flags & WQ_FLAG_EXCLUSIVE) != 0;
-}
-
-static void folio_wake_bit(struct folio *folio, int bit_nr)
-{
-	wait_queue_head_t *q = folio_waitqueue(folio);
-	struct wait_page_key key;
-	unsigned long flags;
-
-	key.folio = folio;
-	key.bit_nr = bit_nr;
-	key.page_match = 0;
-
-	spin_lock_irqsave(&q->lock, flags);
-	__wake_up_locked_key(q, TASK_NORMAL, &key);
-
-	/*
-	 * It's possible to miss clearing waiters here, when we woke our page
-	 * waiters, but the hashed waitqueue has waiters for other pages on it.
-	 * That's okay, it's a rare case. The next waker will clear it.
-	 *
-	 * Note that, depending on the page pool (buddy, hugetlb, ZONE_DEVICE,
-	 * other), the flag may be cleared in the course of freeing the page;
-	 * but that is not required for correctness.
-	 */
-	if (!waitqueue_active(q) || !key.page_match)
-		folio_clear_waiters(folio);
-
-	spin_unlock_irqrestore(&q->lock, flags);
-}
-
-/*
- * Wake waiters on PG_writeback for @folio.
- */
-static void folio_wake_writeback(struct folio *folio)
-{
-	folio_wake_bit(folio, PG_writeback);
-}
-
-/*
- * A choice of three behaviors for folio_wait_bit_common():
- */
-enum behavior {
-	EXCLUSIVE,	/* Hold ref to page and take the bit when woken, like
-			 * __folio_lock() waiting on then setting PG_locked.
-			 */
-	SHARED,		/* Hold ref to page and check the bit when woken, like
-			 * folio_wait_writeback() waiting on PG_writeback.
-			 */
-	DROP,		/* Drop ref to page before wait, no check when woken,
-			 * like folio_put_wait_locked() on PG_locked.
-			 */
-};
-
-/*
- * Attempt to check (or get) the folio flag, and mark us done
- * if successful.
- */
-static inline bool folio_trylock_flag(struct folio *folio, int bit_nr,
-					struct wait_queue_entry *wait)
-{
-	if (wait->flags & WQ_FLAG_EXCLUSIVE) {
-		if (test_and_set_bit(bit_nr, &folio->flags.f))
-			return false;
-	} else if (test_bit(bit_nr, &folio->flags.f))
-		return false;
-
-	wait->flags |= WQ_FLAG_WOKEN | WQ_FLAG_DONE;
-	return true;
-}
-
-static inline int folio_wait_bit_common(struct folio *folio, int bit_nr,
-		int state, enum behavior behavior)
-{
-	wait_queue_head_t *q = folio_waitqueue(folio);
-	int unfairness = sysctl_page_lock_unfairness;
-	struct wait_page_queue wait_page;
-	wait_queue_entry_t *wait = &wait_page.wait;
-	bool thrashing = false;
-	unsigned long pflags;
-	bool in_thrashing;
-
-	if (bit_nr == PG_locked &&
-	    !folio_test_uptodate(folio) && folio_test_workingset(folio)) {
-		delayacct_thrashing_start(&in_thrashing);
-		psi_memstall_enter(&pflags);
-		thrashing = true;
-	}
-
-	init_wait(wait);
-	wait->func = wake_page_function;
-	wait_page.folio = folio;
-	wait_page.bit_nr = bit_nr;
-
-repeat:
-	wait->flags = 0;
-	if (behavior == EXCLUSIVE) {
-		wait->flags = WQ_FLAG_EXCLUSIVE;
-		if (--unfairness < 0)
-			wait->flags |= WQ_FLAG_CUSTOM;
-	}
-
-	/*
-	 * Do one last check whether we can get the
-	 * page bit synchronously.
-	 *
-	 * Do the folio_set_waiters() marking before that
-	 * to let any waker we _just_ missed know they
-	 * need to wake us up (otherwise they'll never
-	 * even go to the slow case that looks at the
-	 * page queue), and add ourselves to the wait
-	 * queue if we need to sleep.
-	 *
-	 * This part needs to be done under the queue
-	 * lock to avoid races.
-	 */
-	spin_lock_irq(&q->lock);
-	folio_set_waiters(folio);
-	if (!folio_trylock_flag(folio, bit_nr, wait))
-		__add_wait_queue_entry_tail(q, wait);
-	spin_unlock_irq(&q->lock);
-
-	/*
-	 * From now on, all the logic will be based on
-	 * the WQ_FLAG_WOKEN and WQ_FLAG_DONE flag, to
-	 * see whether the page bit testing has already
-	 * been done by the wake function.
-	 *
-	 * We can drop our reference to the folio.
-	 */
-	if (behavior == DROP)
-		folio_put(folio);
-
-	/*
-	 * Note that until the "finish_wait()", or until
-	 * we see the WQ_FLAG_WOKEN flag, we need to
-	 * be very careful with the 'wait->flags', because
-	 * we may race with a waker that sets them.
-	 */
-	for (;;) {
-		unsigned int flags;
-
-		set_current_state(state);
-
-		/* Loop until we've been woken or interrupted */
-		flags = smp_load_acquire(&wait->flags);
-		if (!(flags & WQ_FLAG_WOKEN)) {
-			if (signal_pending_state(state, current))
-				break;
-
-			io_schedule();
-			continue;
-		}
-
-		/* If we were non-exclusive, we're done */
-		if (behavior != EXCLUSIVE)
-			break;
-
-		/* If the waker got the lock for us, we're done */
-		if (flags & WQ_FLAG_DONE)
-			break;
-
-		/*
-		 * Otherwise, if we're getting the lock, we need to
-		 * try to get it ourselves.
-		 *
-		 * And if that fails, we'll have to retry this all.
-		 */
-		if (unlikely(test_and_set_bit(bit_nr, folio_flags(folio, 0))))
-			goto repeat;
-
-		wait->flags |= WQ_FLAG_DONE;
-		break;
-	}
-
-	/*
-	 * If a signal happened, this 'finish_wait()' may remove the last
-	 * waiter from the wait-queues, but the folio waiters bit will remain
-	 * set. That's ok. The next wakeup will take care of it, and trying
-	 * to do it here would be difficult and prone to races.
-	 */
-	finish_wait(q, wait);
-
-	if (thrashing) {
-		delayacct_thrashing_end(&in_thrashing);
-		psi_memstall_leave(&pflags);
-	}
-
-	/*
-	 * NOTE! The wait->flags weren't stable until we've done the
-	 * 'finish_wait()', and we could have exited the loop above due
-	 * to a signal, and had a wakeup event happen after the signal
-	 * test but before the 'finish_wait()'.
-	 *
-	 * So only after the finish_wait() can we reliably determine
-	 * if we got woken up or not, so we can now figure out the final
-	 * return value based on that state without races.
-	 *
-	 * Also note that WQ_FLAG_WOKEN is sufficient for a non-exclusive
-	 * waiter, but an exclusive one requires WQ_FLAG_DONE.
-	 */
-	if (behavior == EXCLUSIVE)
-		return wait->flags & WQ_FLAG_DONE ? 0 : -EINTR;
-
-	return wait->flags & WQ_FLAG_WOKEN ? 0 : -EINTR;
 }
 
-#ifdef CONFIG_MIGRATION
-/**
- * softleaf_entry_wait_on_locked - Wait for a migration entry or
- * device_private entry to be removed.
- * @entry: migration or device_private swap entry.
- * @ptl: already locked ptl. This function will drop the lock.
- *
- * Wait for a migration entry referencing the given page, or device_private
- * entry referencing a dvice_private page to be unlocked. This is
- * equivalent to folio_put_wait_locked(folio, TASK_UNINTERRUPTIBLE) except
- * this can be called without taking a reference on the page. Instead this
- * should be called while holding the ptl for @entry referencing
- * the page.
- *
- * Returns after unlocking the ptl.
- *
- * This follows the same logic as folio_wait_bit_common() so see the comments
- * there.
- */
-void softleaf_entry_wait_on_locked(softleaf_t entry, spinlock_t *ptl)
-	__releases(ptl)
-{
-	struct wait_page_queue wait_page;
-	wait_queue_entry_t *wait = &wait_page.wait;
-	bool thrashing = false;
-	unsigned long pflags;
-	bool in_thrashing;
-	wait_queue_head_t *q;
-	struct folio *folio = softleaf_to_folio(entry);
-
-	q = folio_waitqueue(folio);
-	if (!folio_test_uptodate(folio) && folio_test_workingset(folio)) {
-		delayacct_thrashing_start(&in_thrashing);
-		psi_memstall_enter(&pflags);
-		thrashing = true;
-	}
-
-	init_wait(wait);
-	wait->func = wake_page_function;
-	wait_page.folio = folio;
-	wait_page.bit_nr = PG_locked;
-	wait->flags = 0;
-
-	spin_lock_irq(&q->lock);
-	folio_set_waiters(folio);
-	if (!folio_trylock_flag(folio, PG_locked, wait))
-		__add_wait_queue_entry_tail(q, wait);
-	spin_unlock_irq(&q->lock);
-
-	/*
-	 * If a migration entry exists for the page the migration path must hold
-	 * a valid reference to the page, and it must take the ptl to remove the
-	 * migration entry. So the page is valid until the ptl is dropped.
-	 * Similarly any path attempting to drop the last reference to a
-	 * device-private page needs to grab the ptl to remove the device-private
-	 * entry.
-	 */
-	spin_unlock(ptl);
-
-	for (;;) {
-		unsigned int flags;
-
-		set_current_state(TASK_UNINTERRUPTIBLE);
-
-		/* Loop until we've been woken or interrupted */
-		flags = smp_load_acquire(&wait->flags);
-		if (!(flags & WQ_FLAG_WOKEN)) {
-			if (signal_pending_state(TASK_UNINTERRUPTIBLE, current))
-				break;
-
-			io_schedule();
-			continue;
-		}
-		break;
-	}
-
-	finish_wait(q, wait);
-
-	if (thrashing) {
-		delayacct_thrashing_end(&in_thrashing);
-		psi_memstall_leave(&pflags);
-	}
-}
-#endif
-
-void folio_wait_bit(struct folio *folio, int bit_nr)
-{
-	folio_wait_bit_common(folio, bit_nr, TASK_UNINTERRUPTIBLE, SHARED);
-}
-EXPORT_SYMBOL(folio_wait_bit);
-
-int folio_wait_bit_killable(struct folio *folio, int bit_nr)
-{
-	return folio_wait_bit_common(folio, bit_nr, TASK_KILLABLE, SHARED);
-}
-EXPORT_SYMBOL(folio_wait_bit_killable);
-
-/**
- * folio_put_wait_locked - Drop a reference and wait for it to be unlocked
- * @folio: The folio to wait for.
- * @state: The sleep state (TASK_KILLABLE, TASK_UNINTERRUPTIBLE, etc).
- *
- * The caller should hold a reference on @folio.  They expect the page to
- * become unlocked relatively soon, but do not wish to hold up migration
- * (for example) by holding the reference while waiting for the folio to
- * come unlocked.  After this function returns, the caller should not
- * dereference @folio.
- *
- * Return: 0 if the folio was unlocked or -EINTR if interrupted by a signal.
- */
-static int folio_put_wait_locked(struct folio *folio, int state)
-{
-	return folio_wait_bit_common(folio, PG_locked, state, DROP);
-}
-
-/**
- * folio_unlock - Unlock a locked folio.
- * @folio: The folio.
- *
- * Unlocks the folio and wakes up any thread sleeping on the page lock.
- *
- * Context: May be called from interrupt or process context.  May not be
- * called from NMI context.
- */
-void folio_unlock(struct folio *folio)
-{
-	/* Bit 7 allows x86 to check the byte's sign bit */
-	BUILD_BUG_ON(PG_waiters != 7);
-	BUILD_BUG_ON(PG_locked > 7);
-	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
-	if (folio_xor_flags_has_waiters(folio, 1 << PG_locked))
-		folio_wake_bit(folio, PG_locked);
-}
-EXPORT_SYMBOL(folio_unlock);
-
-/**
- * folio_end_read - End read on a folio.
- * @folio: The folio.
- * @success: True if all reads completed successfully.
- *
- * When all reads against a folio have completed, filesystems should
- * call this function to let the pagecache know that no more reads
- * are outstanding.  This will unlock the folio and wake up any thread
- * sleeping on the lock.  The folio will also be marked uptodate if all
- * reads succeeded.
- *
- * Context: May be called from interrupt or process context.  May not be
- * called from NMI context.
- */
-void folio_end_read(struct folio *folio, bool success)
-{
-	unsigned long mask = 1 << PG_locked;
-
-	/* Must be in bottom byte for x86 to work */
-	BUILD_BUG_ON(PG_uptodate > 7);
-	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
-	VM_BUG_ON_FOLIO(success && folio_test_uptodate(folio), folio);
-
-	if (likely(success))
-		mask |= 1 << PG_uptodate;
-	if (folio_xor_flags_has_waiters(folio, mask))
-		folio_wake_bit(folio, PG_locked);
-}
-EXPORT_SYMBOL(folio_end_read);
-
-/**
- * folio_end_private_2 - Clear PG_private_2 and wake any waiters.
- * @folio: The folio.
- *
- * Clear the PG_private_2 bit on a folio and wake up any sleepers waiting for
- * it.  The folio reference held for PG_private_2 being set is released.
- *
- * This is, for example, used when a netfs folio is being written to a local
- * disk cache, thereby allowing writes to the cache for the same folio to be
- * serialised.
- */
-void folio_end_private_2(struct folio *folio)
-{
-	VM_BUG_ON_FOLIO(!folio_test_private_2(folio), folio);
-	clear_bit_unlock(PG_private_2, folio_flags(folio, 0));
-	folio_wake_bit(folio, PG_private_2);
-	folio_put(folio);
-}
-EXPORT_SYMBOL(folio_end_private_2);
-
-/**
- * folio_wait_private_2 - Wait for PG_private_2 to be cleared on a folio.
- * @folio: The folio to wait on.
- *
- * Wait for PG_private_2 to be cleared on a folio.
- */
-void folio_wait_private_2(struct folio *folio)
-{
-	while (folio_test_private_2(folio))
-		folio_wait_bit(folio, PG_private_2);
-}
-EXPORT_SYMBOL(folio_wait_private_2);
-
-/**
- * folio_wait_private_2_killable - Wait for PG_private_2 to be cleared on a folio.
- * @folio: The folio to wait on.
- *
- * Wait for PG_private_2 to be cleared on a folio or until a fatal signal is
- * received by the calling task.
- *
- * Return:
- * - 0 if successful.
- * - -EINTR if a fatal signal was encountered.
- */
-int folio_wait_private_2_killable(struct folio *folio)
-{
-	int ret = 0;
-
-	while (folio_test_private_2(folio)) {
-		ret = folio_wait_bit_killable(folio, PG_private_2);
-		if (ret < 0)
-			break;
-	}
-
-	return ret;
-}
-EXPORT_SYMBOL(folio_wait_private_2_killable);
-
 static void filemap_end_dropbehind(struct folio *folio)
 {
 	struct address_space *mapping = folio->mapping;
@@ -1703,95 +1154,6 @@ void folio_end_writeback(struct folio *folio)
 }
 EXPORT_SYMBOL(folio_end_writeback);
 
-/**
- * __folio_lock - Get a lock on the folio, assuming we need to sleep to get it.
- * @folio: The folio to lock
- */
-void __folio_lock(struct folio *folio)
-{
-	folio_wait_bit_common(folio, PG_locked, TASK_UNINTERRUPTIBLE,
-				EXCLUSIVE);
-}
-EXPORT_SYMBOL(__folio_lock);
-
-int __folio_lock_killable(struct folio *folio)
-{
-	return folio_wait_bit_common(folio, PG_locked, TASK_KILLABLE,
-					EXCLUSIVE);
-}
-EXPORT_SYMBOL_GPL(__folio_lock_killable);
-
-static int __folio_lock_async(struct folio *folio, struct wait_page_queue *wait)
-{
-	struct wait_queue_head *q = folio_waitqueue(folio);
-	int ret;
-
-	wait->folio = folio;
-	wait->bit_nr = PG_locked;
-
-	spin_lock_irq(&q->lock);
-	__add_wait_queue_entry_tail(q, &wait->wait);
-	folio_set_waiters(folio);
-	ret = !folio_trylock(folio);
-	/*
-	 * If we were successful now, we know we're still on the
-	 * waitqueue as we're still under the lock. This means it's
-	 * safe to remove and return success, we know the callback
-	 * isn't going to trigger.
-	 */
-	if (!ret)
-		__remove_wait_queue(q, &wait->wait);
-	else
-		ret = -EIOCBQUEUED;
-	spin_unlock_irq(&q->lock);
-	return ret;
-}
-
-/*
- * Return values:
- * 0 - folio is locked.
- * non-zero - folio is not locked.
- *     mmap_lock or per-VMA lock has been released (mmap_read_unlock() or
- *     vma_end_read()), unless flags had both FAULT_FLAG_ALLOW_RETRY and
- *     FAULT_FLAG_RETRY_NOWAIT set, in which case the lock is still held.
- *
- * If neither ALLOW_RETRY nor KILLABLE are set, will always return 0
- * with the folio locked and the mmap_lock/per-VMA lock is left unperturbed.
- */
-vm_fault_t __folio_lock_or_retry(struct folio *folio, struct vm_fault *vmf)
-{
-	unsigned int flags = vmf->flags;
-
-	if (fault_flag_allow_retry_first(flags)) {
-		/*
-		 * CAUTION! In this case, mmap_lock/per-VMA lock is not
-		 * released even though returning VM_FAULT_RETRY.
-		 */
-		if (flags & FAULT_FLAG_RETRY_NOWAIT)
-			return VM_FAULT_RETRY;
-
-		release_fault_lock(vmf);
-		if (flags & FAULT_FLAG_KILLABLE)
-			folio_wait_locked_killable(folio);
-		else
-			folio_wait_locked(folio);
-		return VM_FAULT_RETRY;
-	}
-	if (flags & FAULT_FLAG_KILLABLE) {
-		bool ret;
-
-		ret = __folio_lock_killable(folio);
-		if (ret) {
-			release_fault_lock(vmf);
-			return VM_FAULT_RETRY;
-		}
-	} else {
-		__folio_lock(folio);
-	}
-
-	return 0;
-}
-
 /**
  * page_cache_next_miss() - Find the next gap in the page cache.
  * @mapping: Mapping.
diff --git a/mm/folio_wait.c b/mm/folio_wait.c
new file mode 100644
index 000000000000..18b42488ce37
--- /dev/null
+++ b/mm/folio_wait.c
@@ -0,0 +1,662 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Folio bit-lock and wait-queue infrastructure.
+ */
+#include <linux/compiler.h>
+#include <linux/export.h>
+#include <linux/sched/signal.h>
+#include <linux/mm.h>
+#include <linux/swap.h>
+#include <linux/leafops.h>
+#include <linux/pagemap.h>
+#include <linux/wait.h>
+#include <linux/hash.h>
+#include <linux/sysctl.h>
+#include <linux/delayacct.h>
+#include <linux/psi.h>
+#include <linux/migrate.h>
+
+#include "internal.h"
+
+/*
+ * In order to wait for pages to become available there must be
+ * waitqueues associated with pages. By using a hash table of
+ * waitqueues where the bucket discipline is to maintain all
+ * waiters on the same queue and wake all when any of the pages
+ * become available, and for the woken contexts to check to be
+ * sure the appropriate page became available, this saves space
+ * at a cost of "thundering herd" phenomena during rare hash
+ * collisions.
+ */
+#define PAGE_WAIT_TABLE_BITS 8
+#define PAGE_WAIT_TABLE_SIZE (1 << PAGE_WAIT_TABLE_BITS)
+static wait_queue_head_t folio_wait_table[PAGE_WAIT_TABLE_SIZE] __cacheline_aligned;
+
+static wait_queue_head_t *folio_waitqueue(struct folio *folio)
+{
+	return &folio_wait_table[hash_ptr(folio, PAGE_WAIT_TABLE_BITS)];
+}
+
+/* How many times do we accept lock stealing from under a waiter? */
+static int sysctl_page_lock_unfairness = 5;
+static const struct ctl_table folio_wait_sysctl_table[] = {
+	{
+		.procname	= "page_lock_unfairness",
+		.data		= &sysctl_page_lock_unfairness,
+		.maxlen		= sizeof(sysctl_page_lock_unfairness),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+	}
+};
+
+void __init folio_wait_init(void)
+{
+	int i;
+
+	for (i = 0; i < PAGE_WAIT_TABLE_SIZE; i++)
+		init_waitqueue_head(&folio_wait_table[i]);
+
+	register_sysctl_init("vm", folio_wait_sysctl_table);
+}
+
+/*
+ * The page wait code treats the "wait->flags" somewhat unusually, because
+ * we have multiple different kinds of waits, not just the usual "exclusive"
+ * one.
+ *
+ * We have:
+ *
+ *  (a) no special bits set:
+ *
+ *	We're just waiting for the bit to be released, and when a waker
+ *	calls the wakeup function, we set WQ_FLAG_WOKEN and wake it up,
+ *	and remove it from the wait queue.
+ *
+ *	Simple and straightforward.
+ *
+ *  (b) WQ_FLAG_EXCLUSIVE:
+ *
+ *	The waiter is waiting to get the lock, and only one waiter should
+ *	be woken up to avoid any thundering herd behavior. We'll set the
+ *	WQ_FLAG_WOKEN bit, wake it up, and remove it from the wait queue.
+ *
+ *	This is the traditional exclusive wait.
+ *
+ *  (c) WQ_FLAG_EXCLUSIVE | WQ_FLAG_CUSTOM:
+ *
+ *	The waiter is waiting to get the bit, and additionally wants the
+ *	lock to be transferred to it for fair lock behavior. If the lock
+ *	cannot be taken, we stop walking the wait queue without waking
+ *	the waiter.
+ *
+ *	This is the "fair lock handoff" case, and in addition to setting
+ *	WQ_FLAG_WOKEN, we set WQ_FLAG_DONE to let the waiter easily see
+ *	that it now has the lock.
+ */
+static int wake_page_function(wait_queue_entry_t *wait, unsigned mode, int sync, void *arg)
+{
+	unsigned int flags;
+	struct wait_page_key *key = arg;
+	struct wait_page_queue *wait_page
+		= container_of(wait, struct wait_page_queue, wait);
+
+	if (!wake_page_match(wait_page, key))
+		return 0;
+
+	/*
+	 * If it's a lock handoff wait, we get the bit for it, and
+	 * stop walking (and do not wake it up) if we can't.
+	 */
+	flags = wait->flags;
+	if (flags & WQ_FLAG_EXCLUSIVE) {
+		if (test_bit(key->bit_nr, &key->folio->flags.f))
+			return -1;
+		if (flags & WQ_FLAG_CUSTOM) {
+			if (test_and_set_bit(key->bit_nr, &key->folio->flags.f))
+				return -1;
+			flags |= WQ_FLAG_DONE;
+		}
+	}
+
+	/*
+	 * We are holding the wait-queue lock, but the waiter that
+	 * is waiting for this will be checking the flags without
+	 * any locking.
+	 *
+	 * So update the flags atomically, and wake up the waiter
+	 * afterwards to avoid any races. This store-release pairs
+	 * with the load-acquire in folio_wait_bit_common().
+	 */
+	smp_store_release(&wait->flags, flags | WQ_FLAG_WOKEN);
+	wake_up_state(wait->private, mode);
+
+	/*
+	 * Ok, we have successfully done what we're waiting for,
+	 * and we can unconditionally remove the wait entry.
+	 *
+	 * Note that this pairs with the "finish_wait()" in the
+	 * waiter, and has to be the absolute last thing we do.
+	 * After this list_del_init(&wait->entry) the wait entry
+	 * might be de-allocated and the process might even have
+	 * exited.
+	 */
+	list_del_init_careful(&wait->entry);
+	return (flags & WQ_FLAG_EXCLUSIVE) != 0;
+}
+
+static void folio_wake_bit(struct folio *folio, int bit_nr)
+{
+	wait_queue_head_t *q = folio_waitqueue(folio);
+	struct wait_page_key key;
+	unsigned long flags;
+
+	key.folio = folio;
+	key.bit_nr = bit_nr;
+	key.page_match = 0;
+
+	spin_lock_irqsave(&q->lock, flags);
+	__wake_up_locked_key(q, TASK_NORMAL, &key);
+
+	/*
+	 * It's possible to miss clearing waiters here, when we woke our page
+	 * waiters, but the hashed waitqueue has waiters for other pages on it.
+	 * That's okay, it's a rare case. The next waker will clear it.
+	 *
+	 * Note that, depending on the page pool (buddy, hugetlb, ZONE_DEVICE,
+	 * other), the flag may be cleared in the course of freeing the page;
+	 * but that is not required for correctness.
+	 */
+	if (!waitqueue_active(q) || !key.page_match)
+		folio_clear_waiters(folio);
+
+	spin_unlock_irqrestore(&q->lock, flags);
+}
+
+/*
+ * Wake waiters on PG_writeback for @folio.
+ */
+void folio_wake_writeback(struct folio *folio)
+{
+	folio_wake_bit(folio, PG_writeback);
+}
+
+/*
+ * A choice of three behaviors for folio_wait_bit_common():
+ */
+enum behavior {
+	EXCLUSIVE,	/* Hold ref to page and take the bit when woken, like
+			 * __folio_lock() waiting on then setting PG_locked.
+			 */
+	SHARED,		/* Hold ref to page and check the bit when woken, like
+			 * folio_wait_writeback() waiting on PG_writeback.
+			 */
+	DROP,		/* Drop ref to page before wait, no check when woken,
+			 * like folio_put_wait_locked() on PG_locked.
+			 */
+};
+
+/*
+ * Attempt to check (or get) the folio flag, and mark us done
+ * if successful.
+ */
+static inline bool folio_trylock_flag(struct folio *folio, int bit_nr,
+					struct wait_queue_entry *wait)
+{
+	if (wait->flags & WQ_FLAG_EXCLUSIVE) {
+		if (test_and_set_bit(bit_nr, &folio->flags.f))
+			return false;
+	} else if (test_bit(bit_nr, &folio->flags.f))
+		return false;
+
+	wait->flags |= WQ_FLAG_WOKEN | WQ_FLAG_DONE;
+	return true;
+}
+
+static inline int folio_wait_bit_common(struct folio *folio, int bit_nr,
+		int state, enum behavior behavior)
+{
+	wait_queue_head_t *q = folio_waitqueue(folio);
+	int unfairness = sysctl_page_lock_unfairness;
+	struct wait_page_queue wait_page;
+	wait_queue_entry_t *wait = &wait_page.wait;
+	bool thrashing = false;
+	unsigned long pflags;
+	bool in_thrashing;
+
+	if (bit_nr == PG_locked &&
+	    !folio_test_uptodate(folio) && folio_test_workingset(folio)) {
+		delayacct_thrashing_start(&in_thrashing);
+		psi_memstall_enter(&pflags);
+		thrashing = true;
+	}
+
+	init_wait(wait);
+	wait->func = wake_page_function;
+	wait_page.folio = folio;
+	wait_page.bit_nr = bit_nr;
+
+repeat:
+	wait->flags = 0;
+	if (behavior == EXCLUSIVE) {
+		wait->flags = WQ_FLAG_EXCLUSIVE;
+		if (--unfairness < 0)
+			wait->flags |= WQ_FLAG_CUSTOM;
+	}
+
+	/*
+	 * Do one last check whether we can get the
+	 * page bit synchronously.
+	 *
+	 * Do the folio_set_waiters() marking before that
+	 * to let any waker we _just_ missed know they
+	 * need to wake us up (otherwise they'll never
+	 * even go to the slow case that looks at the
+	 * page queue), and add ourselves to the wait
+	 * queue if we need to sleep.
+	 *
+	 * This part needs to be done under the queue
+	 * lock to avoid races.
+	 */
+	spin_lock_irq(&q->lock);
+	folio_set_waiters(folio);
+	if (!folio_trylock_flag(folio, bit_nr, wait))
+		__add_wait_queue_entry_tail(q, wait);
+	spin_unlock_irq(&q->lock);
+
+	/*
+	 * From now on, all the logic will be based on
+	 * the WQ_FLAG_WOKEN and WQ_FLAG_DONE flag, to
+	 * see whether the page bit testing has already
+	 * been done by the wake function.
+	 *
+	 * We can drop our reference to the folio.
+	 */
+	if (behavior == DROP)
+		folio_put(folio);
+
+	/*
+	 * Note that until the "finish_wait()", or until
+	 * we see the WQ_FLAG_WOKEN flag, we need to
+	 * be very careful with the 'wait->flags', because
+	 * we may race with a waker that sets them.
+	 */
+	for (;;) {
+		unsigned int flags;
+
+		set_current_state(state);
+
+		/* Loop until we've been woken or interrupted */
+		flags = smp_load_acquire(&wait->flags);
+		if (!(flags & WQ_FLAG_WOKEN)) {
+			if (signal_pending_state(state, current))
+				break;
+
+			io_schedule();
+			continue;
+		}
+
+		/* If we were non-exclusive, we're done */
+		if (behavior != EXCLUSIVE)
+			break;
+
+		/* If the waker got the lock for us, we're done */
+		if (flags & WQ_FLAG_DONE)
+			break;
+
+		/*
+		 * Otherwise, if we're getting the lock, we need to
+		 * try to get it ourselves.
+		 *
+		 * And if that fails, we'll have to retry this all.
+		 */
+		if (unlikely(test_and_set_bit(bit_nr, folio_flags(folio, 0))))
+			goto repeat;
+
+		wait->flags |= WQ_FLAG_DONE;
+		break;
+	}
+
+	/*
+	 * If a signal happened, this 'finish_wait()' may remove the last
+	 * waiter from the wait-queues, but the folio waiters bit will remain
+	 * set. That's ok. The next wakeup will take care of it, and trying
+	 * to do it here would be difficult and prone to races.
+	 */
+	finish_wait(q, wait);
+
+	if (thrashing) {
+		delayacct_thrashing_end(&in_thrashing);
+		psi_memstall_leave(&pflags);
+	}
+
+	/*
+	 * NOTE! The wait->flags weren't stable until we've done the
+	 * 'finish_wait()', and we could have exited the loop above due
+	 * to a signal, and had a wakeup event happen after the signal
+	 * test but before the 'finish_wait()'.
+	 *
+	 * So only after the finish_wait() can we reliably determine
+	 * if we got woken up or not, so we can now figure out the final
+	 * return value based on that state without races.
+	 *
+	 * Also note that WQ_FLAG_WOKEN is sufficient for a non-exclusive
+	 * waiter, but an exclusive one requires WQ_FLAG_DONE.
+	 */
+	if (behavior == EXCLUSIVE)
+		return wait->flags & WQ_FLAG_DONE ? 0 : -EINTR;
+
+	return wait->flags & WQ_FLAG_WOKEN ? 0 : -EINTR;
+}
+
+#ifdef CONFIG_MIGRATION
+/**
+ * softleaf_entry_wait_on_locked - Wait for a migration entry or
+ * device_private entry to be removed.
+ * @entry: migration or device_private swap entry.
+ * @ptl: already locked ptl. This function will drop the lock.
+ *
+ * Wait for a migration entry referencing the given page, or device_private
+ * entry referencing a dvice_private page to be unlocked. This is
+ * equivalent to folio_put_wait_locked(folio, TASK_UNINTERRUPTIBLE) except
+ * this can be called without taking a reference on the page. Instead this
+ * should be called while holding the ptl for @entry referencing
+ * the page.
+ *
+ * Returns after unlocking the ptl.
+ *
+ * This follows the same logic as folio_wait_bit_common() so see the comments
+ * there.
+ */
+void softleaf_entry_wait_on_locked(softleaf_t entry, spinlock_t *ptl)
+	__releases(ptl)
+{
+	struct wait_page_queue wait_page;
+	wait_queue_entry_t *wait = &wait_page.wait;
+	bool thrashing = false;
+	unsigned long pflags;
+	bool in_thrashing;
+	wait_queue_head_t *q;
+	struct folio *folio = softleaf_to_folio(entry);
+
+	q = folio_waitqueue(folio);
+	if (!folio_test_uptodate(folio) && folio_test_workingset(folio)) {
+		delayacct_thrashing_start(&in_thrashing);
+		psi_memstall_enter(&pflags);
+		thrashing = true;
+	}
+
+	init_wait(wait);
+	wait->func = wake_page_function;
+	wait_page.folio = folio;
+	wait_page.bit_nr = PG_locked;
+	wait->flags = 0;
+
+	spin_lock_irq(&q->lock);
+	folio_set_waiters(folio);
+	if (!folio_trylock_flag(folio, PG_locked, wait))
+		__add_wait_queue_entry_tail(q, wait);
+	spin_unlock_irq(&q->lock);
+
+	/*
+	 * If a migration entry exists for the page the migration path must hold
+	 * a valid reference to the page, and it must take the ptl to remove the
+	 * migration entry. So the page is valid until the ptl is dropped.
+	 * Similarly any path attempting to drop the last reference to a
+	 * device-private page needs to grab the ptl to remove the device-private
+	 * entry.
+	 */
+	spin_unlock(ptl);
+
+	for (;;) {
+		unsigned int flags;
+
+		set_current_state(TASK_UNINTERRUPTIBLE);
+
+		/* Loop until we've been woken or interrupted */
+		flags = smp_load_acquire(&wait->flags);
+		if (!(flags & WQ_FLAG_WOKEN)) {
+			if (signal_pending_state(TASK_UNINTERRUPTIBLE, current))
+				break;
+
+			io_schedule();
+			continue;
+		}
+		break;
+	}
+
+	finish_wait(q, wait);
+
+	if (thrashing) {
+		delayacct_thrashing_end(&in_thrashing);
+		psi_memstall_leave(&pflags);
+	}
+}
+#endif
+
+void folio_wait_bit(struct folio *folio, int bit_nr)
+{
+	folio_wait_bit_common(folio, bit_nr, TASK_UNINTERRUPTIBLE, SHARED);
+}
+EXPORT_SYMBOL(folio_wait_bit);
+
+int folio_wait_bit_killable(struct folio *folio, int bit_nr)
+{
+	return folio_wait_bit_common(folio, bit_nr, TASK_KILLABLE, SHARED);
+}
+EXPORT_SYMBOL(folio_wait_bit_killable);
+
+/**
+ * folio_put_wait_locked - Drop a reference and wait for it to be unlocked
+ * @folio: The folio to wait for.
+ * @state: The sleep state (TASK_KILLABLE, TASK_UNINTERRUPTIBLE, etc).
+ *
+ * The caller should hold a reference on @folio.  They expect the page to
+ * become unlocked relatively soon, but do not wish to hold up migration
+ * (for example) by holding the reference while waiting for the folio to
+ * come unlocked.  After this function returns, the caller should not
+ * dereference @folio.
+ *
+ * Return: 0 if the folio was unlocked or -EINTR if interrupted by a signal.
+ */
+int folio_put_wait_locked(struct folio *folio, int state)
+{
+	return folio_wait_bit_common(folio, PG_locked, state, DROP);
+}
+
+/**
+ * folio_unlock - Unlock a locked folio.
+ * @folio: The folio.
+ *
+ * Unlocks the folio and wakes up any thread sleeping on the page lock.
+ *
+ * Context: May be called from interrupt or process context.  May not be
+ * called from NMI context.
+ */
+void folio_unlock(struct folio *folio)
+{
+	/* Bit 7 allows x86 to check the byte's sign bit */
+	BUILD_BUG_ON(PG_waiters != 7);
+	BUILD_BUG_ON(PG_locked > 7);
+	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
+	if (folio_xor_flags_has_waiters(folio, 1 << PG_locked))
+		folio_wake_bit(folio, PG_locked);
+}
+EXPORT_SYMBOL(folio_unlock);
+
+/**
+ * folio_end_read - End read on a folio.
+ * @folio: The folio.
+ * @success: True if all reads completed successfully.
+ *
+ * When all reads against a folio have completed, filesystems should
+ * call this function to let the pagecache know that no more reads
+ * are outstanding.  This will unlock the folio and wake up any thread
+ * sleeping on the lock.  The folio will also be marked uptodate if all
+ * reads succeeded.
+ *
+ * Context: May be called from interrupt or process context.  May not be
+ * called from NMI context.
+ */
+void folio_end_read(struct folio *folio, bool success)
+{
+	unsigned long mask = 1 << PG_locked;
+
+	/* Must be in bottom byte for x86 to work */
+	BUILD_BUG_ON(PG_uptodate > 7);
+	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
+	VM_BUG_ON_FOLIO(success && folio_test_uptodate(folio), folio);
+
+	if (likely(success))
+		mask |= 1 << PG_uptodate;
+	if (folio_xor_flags_has_waiters(folio, mask))
+		folio_wake_bit(folio, PG_locked);
+}
+EXPORT_SYMBOL(folio_end_read);
+
+/**
+ * folio_end_private_2 - Clear PG_private_2 and wake any waiters.
+ * @folio: The folio.
+ *
+ * Clear the PG_private_2 bit on a folio and wake up any sleepers waiting for
+ * it.  The folio reference held for PG_private_2 being set is released.
+ *
+ * This is, for example, used when a netfs folio is being written to a local
+ * disk cache, thereby allowing writes to the cache for the same folio to be
+ * serialised.
+ */
+void folio_end_private_2(struct folio *folio)
+{
+	VM_BUG_ON_FOLIO(!folio_test_private_2(folio), folio);
+	clear_bit_unlock(PG_private_2, folio_flags(folio, 0));
+	folio_wake_bit(folio, PG_private_2);
+	folio_put(folio);
+}
+EXPORT_SYMBOL(folio_end_private_2);
+
+/**
+ * folio_wait_private_2 - Wait for PG_private_2 to be cleared on a folio.
+ * @folio: The folio to wait on.
+ *
+ * Wait for PG_private_2 to be cleared on a folio.
+ */
+void folio_wait_private_2(struct folio *folio)
+{
+	while (folio_test_private_2(folio))
+		folio_wait_bit(folio, PG_private_2);
+}
+EXPORT_SYMBOL(folio_wait_private_2);
+
+/**
+ * folio_wait_private_2_killable - Wait for PG_private_2 to be cleared on a folio.
+ * @folio: The folio to wait on.
+ *
+ * Wait for PG_private_2 to be cleared on a folio or until a fatal signal is
+ * received by the calling task.
+ *
+ * Return:
+ * - 0 if successful.
+ * - -EINTR if a fatal signal was encountered.
+ */
+int folio_wait_private_2_killable(struct folio *folio)
+{
+	int ret = 0;
+
+	while (folio_test_private_2(folio)) {
+		ret = folio_wait_bit_killable(folio, PG_private_2);
+		if (ret < 0)
+			break;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(folio_wait_private_2_killable);
+
+/**
+ * __folio_lock - Get a lock on the folio, assuming we need to sleep to get it.
+ * @folio: The folio to lock
+ */
+void __folio_lock(struct folio *folio)
+{
+	folio_wait_bit_common(folio, PG_locked, TASK_UNINTERRUPTIBLE,
+				EXCLUSIVE);
+}
+EXPORT_SYMBOL(__folio_lock);
+
+int __folio_lock_killable(struct folio *folio)
+{
+	return folio_wait_bit_common(folio, PG_locked, TASK_KILLABLE,
+					EXCLUSIVE);
+}
+EXPORT_SYMBOL_GPL(__folio_lock_killable);
+
+int __folio_lock_async(struct folio *folio, struct wait_page_queue *wait)
+{
+	struct wait_queue_head *q = folio_waitqueue(folio);
+	int ret;
+
+	wait->folio = folio;
+	wait->bit_nr = PG_locked;
+
+	spin_lock_irq(&q->lock);
+	__add_wait_queue_entry_tail(q, &wait->wait);
+	folio_set_waiters(folio);
+	ret = !folio_trylock(folio);
+	/*
+	 * If we were successful now, we know we're still on the
+	 * waitqueue as we're still under the lock. This means it's
+	 * safe to remove and return success, we know the callback
+	 * isn't going to trigger.
+	 */
+	if (!ret)
+		__remove_wait_queue(q, &wait->wait);
+	else
+		ret = -EIOCBQUEUED;
+	spin_unlock_irq(&q->lock);
+	return ret;
+}
+
+/*
+ * Return values:
+ * 0 - folio is locked.
+ * non-zero - folio is not locked.
+ *     mmap_lock or per-VMA lock has been released (mmap_read_unlock() or
+ *     vma_end_read()), unless flags had both FAULT_FLAG_ALLOW_RETRY and
+ *     FAULT_FLAG_RETRY_NOWAIT set, in which case the lock is still held.
+ *
+ * If neither ALLOW_RETRY nor KILLABLE are set, will always return 0
+ * with the folio locked and the mmap_lock/per-VMA lock is left unperturbed.
+ */
+vm_fault_t __folio_lock_or_retry(struct folio *folio, struct vm_fault *vmf)
+{
+	unsigned int flags = vmf->flags;
+
+	if (fault_flag_allow_retry_first(flags)) {
+		/*
+		 * CAUTION! In this case, mmap_lock/per-VMA lock is not
+		 * released even though returning VM_FAULT_RETRY.
+		 */
+		if (flags & FAULT_FLAG_RETRY_NOWAIT)
+			return VM_FAULT_RETRY;
+
+		release_fault_lock(vmf);
+		if (flags & FAULT_FLAG_KILLABLE)
+			folio_wait_locked_killable(folio);
+		else
+			folio_wait_locked(folio);
+		return VM_FAULT_RETRY;
+	}
+	if (flags & FAULT_FLAG_KILLABLE) {
+		bool ret;
+
+		ret = __folio_lock_killable(folio);
+		if (ret) {
+			release_fault_lock(vmf);
+			return VM_FAULT_RETRY;
+		}
+	} else {
+		__folio_lock(folio);
+	}
+
+	return 0;
+}
diff --git a/mm/internal.h b/mm/internal.h
index 09931b1e535f..a121ca07f75c 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -102,6 +102,10 @@ struct pagetable_move_control {
 })
 
 void page_writeback_init(void);
+void folio_wait_init(void);
+void folio_wake_writeback(struct folio *folio);
+int folio_put_wait_locked(struct folio *folio, int state);
+int __folio_lock_async(struct folio *folio, struct wait_page_queue *wait);
 
 /*
  * If a 16GB hugetlb folio were mapped by PTEs of all of its 4kB pages,

-- 
2.39.5


