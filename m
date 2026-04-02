Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC490CC6B03
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 06:38:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 362646B0099; Thu,  2 Apr 2026 02:38:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E59A6B009B; Thu,  2 Apr 2026 02:38:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D45F6B009D; Thu,  2 Apr 2026 02:38:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0AA546B0099
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 02:38:44 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C4E111A0506
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 06:38:43 +0000 (UTC)
X-FDA: 84612662526.22.A06D102
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id E2744100008
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 06:38:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YOI0GoQh;
	spf=pass (imf14.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775111922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FLyaDgFkfHvrMzV28TVPMgU6GEppSWS1kB1nw8OA6yE=;
	b=zzryWLYILrklmHVtDsyaagtj5Fwzf5KqihW8eNAmbExUO2HuSAu3fR0Lu+/D927TPEbpjd
	NoReaD8VkNx8rpcD0nSEAuC+X/iYU/zJJn8g/j9eQcOogTQ4H3WvB9hZZHhNt/1myMed+A
	lRWKhHRIHKpr8Q5t/RX/nAXBUHb4icM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YOI0GoQh;
	spf=pass (imf14.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775111922; a=rsa-sha256;
	cv=none;
	b=asr+8NKd2fg9ki9SdzwEdpQlo+N74QjAueWMj2AEdo7v6JDRZMhgRzljrGRNhx9D9KMMiy
	p0078br5/t3QEZTWRSuJWFgfP79PmWrLHpAXJudhXQ4uGaWB9Ui1g10ILrdAl7SuehWbkM
	0BasVeNwLrSp/7eXA594D8r1eDBcg3I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775111921;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FLyaDgFkfHvrMzV28TVPMgU6GEppSWS1kB1nw8OA6yE=;
	b=YOI0GoQhPCg6mof+pTC/p2pWAXzRdFlsKjEj7uQonrKvqFbkMDMKOtMdA6jVqmRgudcUPx
	9+LncR4Y8hC3mkUILfcr2U5CEGiK1YrHi9w80fRuKDm4wjQ1rPCMJXyIe63XCKH8uqmzXN
	ypOvVXxMHDBkWIiX9sqUWUAeQiHSMJg=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-396-6dIlcf2TPkS6AUr5eh3JIg-1; Thu,
 02 Apr 2026 02:38:36 -0400
X-MC-Unique: 6dIlcf2TPkS6AUr5eh3JIg-1
X-Mimecast-MFC-AGG-ID: 6dIlcf2TPkS6AUr5eh3JIg_1775111914
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 160021956096;
	Thu,  2 Apr 2026 06:38:34 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.158])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A83B01800351;
	Thu,  2 Apr 2026 06:38:25 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	david@kernel.org,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	mhocko@suse.com,
	shuah@kernel.org,
	chengming.zhou@linux.dev,
	longman@redhat.com,
	nphamcs@gmail.com
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Michal Hocko <mhocko@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Subject: [PATCH v6 7/8] selftest/cgroup: fix zswap attempt_writeback() on 64K pagesize system
Date: Thu,  2 Apr 2026 14:37:13 +0800
Message-ID: <20260402063714.55124-8-liwang@redhat.com>
In-Reply-To: <20260402063714.55124-1-liwang@redhat.com>
References: <20260402063714.55124-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: UTgmOO_bE1cHqGcKD5RE6tdDB4vKn_Ei6PNduKnfXnU_1775111914
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: yn8fwbpry8yzkfycz97jra97ximpumak
X-Rspamd-Queue-Id: E2744100008
X-Rspamd-Server: rspam09
X-HE-Tag: 1775111921-441981
X-HE-Meta: U2FsdGVkX1+7uPTkoUX98XSCXqITNgZ0M0rIqy3WsAUTX7vbFnEY+BMhDa6GA1MI0zmcMQPpzbsKGNcDAkIK6hOdX1g7QeU8fSGQhi4iSu38BVvnSknHHgRbrB9ZhJMeOOTeUedjgL5cf6HQXY40ML10Z6CZPUQHDwW4dQJWIcbyMfnjrFl1f+o9MXESrO8H532dVLh0YTqbqcHKh7ZLJaX4Nwkj9aB+0ILvTDpnOtF7aQwG0NNVqezPJSMzWqPWumrrCdFQiV7U+5Ho1fqZg9VoH6CmdebCAQFcXvgeNML53GO2Ml4F1Xug/T7Fiiae/HC829b0kkPr19Az9unLu6GEWVyTqjiixdSxs2VyO6PSh5FD11Vj0UzSr3lW3ruhuIfm7Rf3znwetqNjeV66vhBjKc3t5ljJPtRMiaVe5ZEpM7JY8xFIkPhrLPs+bMozdx2FgctXvlFVrW+XNPrk7hhTnllzkK/KlqqggXn20Fdpx3CUZ4QfRveLd1ZKLhko87HO71nHJvVtYVTFxej1l4z6ZMAvQwq5S/h1dkv7gHKERnJrKedhP6va++8zGq5WO4cgMAeAgpF0lGR6DxX/sVVjLbAv5favIr2EYB7VE2E/cMOH+zjkCDL8YRPOwXip62hZa1pAbj6VGPVquyRAG0mlTLEgwYLGXUVKN2m8MVfZVg7dpGWNMLdHW2+YS6YOR/J9YI18oSgrysk5x+KV5sy9WejLZy7O/8ecEFpDjOGRGzeYjVZA1EzZ6uu8Dl2HX9ApU4wit5RLxMy3Mn+zgcCXdUlyHn0NcDtYooIoaB81yhdpEz8XERyaVl9Lli33NHSWd2iAZhuH8KlfN2MamAqo/OXEKeTXVVsfQCZnZMMdi/pkrLfBN9YOTbVvSCVPVwJNu12DKylYlbCEo33ioC26yBVTBqeA105VDktQoH4M8+7Qeww/SW9WbS0j65LtMmfeICbniBqw2/bJWs+
 i2ggCeLV
 V4jKa/teN+RngUIX4k9I6A44GxI/Ex6e6fnmDqKpjfqwC7AJmOad76DWC4pzR9/5zbbyxr6/n9rM6GnlqRgVmP2So9p3wUR8GfnUBISlY/AGtu7qBfp6EdUrpw6K3M87VbZ1/Tg2YX0Ruboc90YC2drnAptF102sl11r4aSGuBa/fiB5L6X8lSNKXnpnILT2O2yhQmE2J7ShD6qF/DStHejYOx0CxfjJW6aOarkvd5eocx30w3VH+aAArSmk9Q3abqsPIG5ZnIMyGvDy+TznvI/tsqsdh27jJfb4Kl0Ebi4orOxOZBGWa1jK1oYvhv7/8Ftv4jlB7c8AQms3+qpmF4MBPOrdEYGg+kbxDiM+ZUMiTVkkaog3/yj+OmrZ9zOZ4N6xFuGSiJg9PtETWYNT6vLSzWPbFAQbpgA7WQzgNewtLIjYokt+D+jE8j9thftL6qli3LqEtCndzZbyCJf29KohLUKYTYAbZWxrxYrP2Z6jTxWK6USdQQbe7R81+Qvc3NSjDP8dYPDNG1V3mdiU0oeaQW9pAQe4VJdxjrfJy707yg9UCixQJlempJKSMxGBurpy4cN/tgszGlgs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In attempt_writeback(), a memsize of 4M only covers 64 pages on 64K
page size systems. When memory.reclaim is called, the kernel prefers
reclaiming clean file pages (binary, libc, linker, etc.) over swapping
anonymous pages. With only 64 pages of anonymous memory, the reclaim
target can be largely or entirely satisfied by dropping file pages,
resulting in very few or zero anonymous pages being pushed into zswap.

This causes zswap_usage to be extremely small or zero, making
zswap_usage/4 insufficient to create meaningful writeback pressure.
The test then fails because no writeback is triggered.

On 4K page size systems this is not an issue because 4M covers 1024
pages, and file pages are a small fraction of the reclaim target.

Fix this by:
- Always allocating 1024 pages regardless of page size. This ensures
  enough anonymous pages to reliably populate zswap and trigger
  writeback, while keeping the original 4M allocation on 4K systems.
- Setting zswap.max to zswap_usage/4 instead of zswap_usage/2 to
  create stronger writeback pressure, ensuring reclaim reliably
  triggers writeback even on large page size systems.

=== Error Log ===
  # uname -rm
  6.12.0-211.el10.ppc64le ppc64le

  # getconf PAGESIZE
  65536

  # ./test_zswap
  TAP version 13
  1..7
  ok 1 test_zswap_usage
  ok 2 test_swapin_nozswap
  ok 3 test_zswapin
  not ok 4 test_zswap_writeback_enabled
  ...

Signed-off-by: Li Wang <liwang@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Yosry Ahmed <yosry@kernel.org>
---

Notes:
    v6:
    	- Adjust the code comments.
    v5:
    	- Setting zswap.max to zswap_usage/4 to create stronger writeback pressure.
    v3-4:
    	- No changes.
    v2:
    	- use pagesize * 1024 which clearly shows the page numbers.

 tools/testing/selftests/cgroup/test_zswap.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 2b14683f9a77..ffc037922e1b 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -266,14 +266,14 @@ static int test_zswapin(const char *root)
       This will move it into zswap.
  * 3. Save current zswap usage.
  * 4. Move the memory allocated in step 1 back in from zswap.
- * 5. Set zswap.max to half the amount that was recorded in step 3.
+ * 5. Set zswap.max to 1/4 of the amount that was recorded in step 3.
  * 6. Attempt to reclaim memory equal to the amount that was allocated,
       this will either trigger writeback if it's enabled, or reclamation
       will fail if writeback is disabled as there isn't enough zswap space.
  */
 static int attempt_writeback(const char *cgroup, void *arg)
 {
-	size_t memsize = MB(4);
+	size_t memsize = page_size * 1024;
 	char buf[page_size];
 	long zswap_usage;
 	bool wb_enabled = *(bool *) arg;
@@ -311,12 +311,12 @@ static int attempt_writeback(const char *cgroup, void *arg)
 		}
 	}
 
-	if (cg_write_numeric(cgroup, "memory.zswap.max", zswap_usage/2))
+	if (cg_write_numeric(cgroup, "memory.zswap.max", zswap_usage/4))
 		goto out;
 
 	/*
 	 * If writeback is enabled, trying to reclaim memory now will trigger a
-	 * writeback as zswap.max is half of what was needed when reclaim ran the first time.
+	 * writeback as zswap.max is 1/4 of what was needed when reclaim ran the first time.
 	 * If writeback is disabled, memory reclaim will fail as zswap is limited and
 	 * it can't writeback to swap.
 	 */
-- 
2.53.0


