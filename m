Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48B31606A896
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 07:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=PX1+CERr
Received: by kanga.kvack.org (Postfix)
	id C91F96B05C2; Sat, 14 Nov 2026 02:10:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFC236B05C4; Sat, 14 Nov 2026 02:10:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABD1F6B05C5; Sat, 14 Nov 2026 02:10:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7C45C6B05C2
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:10:32 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 13F251A02E2
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:10:32 +0000 (UTC)
X-FDA: 85432851504.09.37B8166
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5653E40007
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:10:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=PX1+CERr;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.175 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794640230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WCui+DSNeboB03hP2f7maV0wOWIxjAUtx4hYmP2Ak68=;
	b=IdxRLZ+U70kqMp0SmZE0Ldc3wOMaC8817tCAcAcW9QbTWp/iQtx6rnOOkKi9HVrhuIxqcT
	61WH7jMpGgJvkbLJJxgb55NCspHjEZCJD6xuNz/RrG8EFYnx8j4f19EF6Qicy7GqzeQ2L4
	RBTmnT9l/+7GLTwwfAXiuOUh7ha4fSA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794640230;
	b=blFB4mXQ+T3ERM21istAiXAKXYxnowDSLbNTcYNfRt8/Z+zvHRHFb/QZIocEbphee5pi/6
	1/fDUrZP7KVmP2adz1CNe/pNcAtuQ5RupQEl/Ii3Bn2WGkInX4LaGflTHxBfP7Z+NeMpyr
	LOgF0JFtmOuCJ4lnvdNtg8PYuwZYit4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=PX1+CERr;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.175 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-949657a20d7so26131185a.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 23:10:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794640229; x=1795245029; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WCui+DSNeboB03hP2f7maV0wOWIxjAUtx4hYmP2Ak68=;
        b=PX1+CERrLdbaEys3HaiJl/Nb/ysffNByayj0JJGIuFATgK7NWPy5aQTF+wCZOee/jl
         I0tVTH9Y+0ulby02gINYmhxVrVQxNBL368BjGHYaqYlo4I3WdIDtYxwek3jp91vk8KQh
         UPvePkgcMaDIwGyRiSKFWFOdjY3HkpGg2qQcyRRhBrAifQELqrwTB8YqAiDHF8OJQ6VV
         SaP4PEBPnTVsfldXYGO5yf/HrPisQqSHBKEZygXoBbwQ8GULZ7slUQbe+2M7BnNu+mVd
         AI/bwjXWQyTxfL5daD5WWKY9n3v6q3bDKreCJpoFKHhoH6gW9+IYJZytGN/6cYvMldnJ
         lYFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794640229; x=1795245029;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WCui+DSNeboB03hP2f7maV0wOWIxjAUtx4hYmP2Ak68=;
        b=Xd9a5+qd+fpysDn4dpMY4+a8HRc6oK15LEgyJAu/gnS4CBcHbDt0OlGn6avuoQit5F
         eiSQfHzMHXrqWxUWt92yGEGvzphNAcvv7p9eUiYEKjgG6Sig5tcDnWMmbJxgLpfNu58n
         TGXFIqNCK9hLE2v6Vupkw3MBApdhuqVKAbnASiL3m+JWRKPJtlLEq/+Eyn6nyMvKfuYA
         o9oniJO4aNgyIz8pATLyXZpTpM2ED4a4KlitdnvARrtoRG2whoTzFTOU7OF/0+w0Ud4W
         7PJGauQ1H5Ju7UO+oO398tlSPSZ2VHLe3aqoCUV8vahBxLjbVFlKl2f+n46/UQBxQySf
         z1RA==
X-Gm-Message-State: APuU4Z9WZlbCC4h0f9SQzKHWsBPNZJOKq5mqlFlLHJOIdt6KVLIilDLX
	Ktwg/sSzzG800lmXy2Io3lr/jn6e54frwXNgRT5/p1oeRCRY8OtVfq8xOf2XQR1/dQKO6130b1R
	SqQNe
X-Gm-Gg: AYBFou1qbfNz4AYFO5XInQAWqw9HZtIoqjH973DVxPkIggOu+6Bhm/pHx4+ieDenmxX
	87Y/5qu6+dSwBOltqqntlfCC6hbeBFi+IXnWgfCP/re7XHryOJ3+kCli/YfRi1Yl/SXCAA8Ga3/
	mfNMLwUsOax/s8H9ndwPXdfeA0v4r2iYPDf3aTWYyEu+fH22WUuqUXuitDhDuJEITVZ77PDabc+
	j+b7YoMLfeiBSBEhnlomVfAWAV5HKzIZFFk+8p3oEhhq1/z0k+NA41OPtkYqCycwXOOV0gj/EEE
	G1zacRKas5YuH8jgNZLvZUGjPckNHJ/MVdz7k8BC+lahUdF76fa/jfRKIiBHcoMffYyqDpQHzkM
	nM9sljM7Ho5k9Bm9gc9s9ck7SE4MItbQTnmbV1G25FOOhJMjGikQqVjYObZ4kdx1XBy2kj40DzR
	HxUzc90t5mc5sm7724PODa6RgssQMuPQpGK/+HhMY8zv+h1gkwgUomlCzeNLh+x16rg6/yVNI3q
	9uvzvJKZI51OgmmBRWkGkM0RckLHDaP/qMvi7PNRFmQoVvCeui+pEFnZPMyxnlG7U8JodxYGDqB
	l+aUKyHQFXBojA7IV+Ly1/kBXCDuEe2LtvU5QY2eNuR1pT8QYcOo/Fpg/RxbfQFcbZ3ouxnau4H
	g8PrXTSHF9bDReCs=
X-Received: by 2002:a05:620a:4005:b0:940:e34a:aead with SMTP id af79cd13be357-9494b9488f8mr838653885a.5.1794640229507;
        Fri, 13 Nov 2026 23:10:29 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23db3a99sm37730986d6.40.2026.11.13.23.10.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 23:10:29 -0800 (PST)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-serial@vger.kernel.org,
	linux-pm@vger.kernel.org,
	damon@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	johan@kernel.org,
	jirislaby@kernel.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	pavel@kernel.org,
	lenb@kernel.org,
	hannes@cmpxchg.org,
	brendan.jackman@linux.dev,
	ziy@nvidia.com,
	sj@kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	xu.xin@linux.dev,
	chengming.zhou@linux.dev,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	matthew.brost@intel.com,
	byungchul@sk.com,
	apopple@nvidia.com,
	rientjes@google.com
Subject: [PATCH 12/22] mm/damon: restrict DAMON-native folio operations to common memory
Date: Sat, 14 Nov 2026 02:09:49 -0500
Message-ID: <20261114070959.3490008-13-gourry@gourry.net>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261114070959.3490008-1-gourry@gourry.net>
References: <20261114070959.3490008-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dntejoedrod68jdx6iuic4x5qbu7e99d
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5653E40007
X-HE-Tag: 1794640230-624629
X-HE-Meta: U2FsdGVkX19zNKWXydsrw1r+fXY7EMtSbLms7G660VmfiOVlUkya9RF9XI9YnG1PmZKAkYAXSOt8WAIeQql4PmHovPy6T3zhawmOsPBFrfLNox7MlY/8eQa2dpepBuf0W/joCHvIQFotZVuDsQbz7xXwakckj05X8xSJyUjD4Y6mWWuXbsK0Cyiv40NPXPSELiuLZaF5qBLvl/kUl4Hbm8vfkQLqGHEyjMaCsAuyby/XVM5yNqeyeV72E/CGVPfWz3JA9QwgIo+eHGyaAqzJjTvEDlqsCwTl7v3Jd2Sj6+fPbJ1354HIYG8rsLXox2AW6YKqsH8tTTsdsgR1o0lDEWt0VVkK1tvRDCTegvOWrD2bvBEGcTJrI/p06k3e9chTgvXi9MxQm2DfV/OR8g5IMqujX/k7I1sjPAb3rQC437xyu0b7ZycjLyYUXbx0JA9/8eyX0FPZvGUvz6/OnWWXqDzf2FP7kjVJCKfoHXD7CcmF7DvzZTLKK/+zVMjC2aeAArTLYhav4yF5z56Xq4qUFSNVq+onsGf0zAlKrYXwoT4vc/3pbTKh6utch+2XJn9iXu0rmYAVX8VGOLGPeb+CB5X+9Xw7rVRXahW0DowuzrZ6bS1E9oBHvH2Rqhh3wFwuIOPW5XX9hk8/wkqYhzS9OQXHqKEx5JW+AMN34f2UVH7KhEfKKritimfr78sTY3bEkNU1/U77ttFNyKkTJ2VCZzsMDme2aZnVu5dKNwA2d9tUFTGm+HVMvsQdx3xy+B8ZMI6+aBoRKvBxJ7shayUrfKF7EheglpLKoKAaIk6/0JlPqTWAAj4Y8QT/3PQ79yFiOnBwqcUzd3nKY0z2s8xLKXlRQrLu/lJXpGzwV0dooYvPNsSqISGovZ6m3e7hOSmV9npozeE8uy5X/EUZvJdmcct5D2J+2x7C2jpYNyvYrIJVApR39d7qYQFRrWwq/qUzwjxH+dB1Hi9jyUQa2TP
 7zlOq9q4
 m42dDx1PKv+A0YfHuMV505xxu68bek/LnVxKWMb+Gozz/1fTOBNUCt8fRvZQrFW0VMQZfGDZ0Zjw/jL5N+XOgnn/tnVtW0Yf6NrWXE6inRkOaFRNIw7j92aFxqzq93H5q/7rdeqGPVFq6wDv1WQ54COhyZE4iy2jySBjRZT57da+WUWrwMqfu0OPUhW/awl0pjmJRwOSqnW9WGYj1MsYLT2SUEIw1S/zYZfAdloLuJzoytDjOnaOn9XNgIo9r3WhXKwoQa+TTnlGH8RYU58sRImXTxKVwCWiGmIoTshTv2J+1AFXLy5Eam2wZQ5Jb4Hy8O4uMBJw5T0+gGvot2Ed4EcH/vG5+itS3wo0IulmBT0d3MUeW1dSFN7iYTHzgHvoryUZe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

DAMON acquires folios to age them, check their accesses, and apply LRU
operations and migration. Treat these as general-purpose MM services
and restrict them to N_MEMORY_COMMON.

Memory outside N_MEMORY_COMMON can still hold ordinary LRU folios, so
it would pass the checks that keep ZONE_DEVICE memory out of these
operations.

Treat these folios like ZONE_DEVICE memory.

DAMON cannot acquire such a folio, so it never ages one and virtual
address monitoring reports it as accessed, and DAMOS cannot isolate
one for migration.

Reject migration destinations outside N_MEMORY_COMMON.

All memory is common at this point, so behavior is unchanged.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/damon/ops-common.c | 7 ++++---
 mm/damon/vaddr.c      | 2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index b9571f53e538c..51b4b5d572e77 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -17,8 +17,9 @@
 
 static bool damon_folio_acceptable(struct folio *folio, bool monitor)
 {
-	return folio_test_lru(folio) ||
-		(monitor && folio_test_hugetlb(folio));
+	return folio_is_common_memory(folio) &&
+		(folio_test_lru(folio) ||
+		 (monitor && folio_test_hugetlb(folio)));
 }
 
 /*
@@ -498,7 +499,7 @@ unsigned long damon_migrate_pages(struct list_head *folio_list, int target_nid)
 		return nr_migrated;
 
 	if (target_nid < 0 || target_nid >= MAX_NUMNODES ||
-			!node_state(target_nid, N_MEMORY)) {
+			!node_state(target_nid, N_MEMORY_COMMON)) {
 		damon_putback_folio_list(folio_list);
 		return nr_migrated;
 	}
diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 1e65e7651cd98..338876559140b 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -830,7 +830,7 @@ static void damos_va_migrate_dests_add(struct folio *folio,
 	if (folio_nid(folio) == nid)
 		return;
 
-	if (!folio_isolate_lru(folio))
+	if (!folio_is_common_memory(folio) || !folio_isolate_lru(folio))
 		return;
 	node_stat_add_folio(folio, NR_ISOLATED_ANON +
 			folio_is_file_lru(folio));
-- 
2.53.1-Meta


