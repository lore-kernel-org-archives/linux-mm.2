Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CCDAFED2C4
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 04:07:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CD5F6B0093; Thu, 12 Mar 2026 00:07:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 785C46B0095; Thu, 12 Mar 2026 00:07:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AE6B6B0096; Thu, 12 Mar 2026 00:07:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5C7E56B0093
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 00:07:24 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0E7C6B994F
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 04:07:24 +0000 (UTC)
X-FDA: 84536076408.13.763D77C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2CB8EC0004
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 04:07:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hgF6Osol;
	spf=pass (imf10.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773288442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tCoh+2kLa4JaG6/3rXINwsFM1J8xAMKja4n+Ebyevk4=;
	b=nqdhUU/GhAyZlaPtvNdvV1DiQemiKwkD7aJn9ayUUriwTJYN5pIbobtZyTjgPL0lapX1zr
	QwzTFG40s72inEEDr3TI3t7C1c6OZ+srXXAm6tMo17u2mWiS4sCbJLlFs9uFR/ZMw6wMFe
	D5ucZ6sfXn/1M5X/QdPvbjqqHqweeb8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hgF6Osol;
	spf=pass (imf10.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773288442; a=rsa-sha256;
	cv=none;
	b=m2aVRn3RRmB4UJOfOg37MveVuBW3kERy/xxc710D72oV6KkfCXA6Elghg2EjSLcPC7wnm/
	/s3aMHa79Ys9tX0mAN+SW3yGNnMVChr7xO7oTxHXEItD29dBBUSB6s50pcdSBea/SGkYTN
	TrD6yTKFLknYU5GNXSkeiz3g4nQB+/g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773288441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tCoh+2kLa4JaG6/3rXINwsFM1J8xAMKja4n+Ebyevk4=;
	b=hgF6Osolxb7dWrUAiF4TQjHe7PDAzS2iloXcE2Btc8zhXgGKT3t/5+ufmrj2UW96oDydsC
	H+QfrzDLOywS4lK65+PL+ZZly7Aa/y4UXJXl0q+Rule5d45muCnbN76t7jznbwDpzEX3TM
	OrjnBnVqeJ9HyQJwxsaaZitPe7bFbf0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-161-pLXfbgt0NHKSRcTxT34plw-1; Thu,
 12 Mar 2026 00:07:17 -0400
X-MC-Unique: pLXfbgt0NHKSRcTxT34plw-1
X-Mimecast-MFC-AGG-ID: pLXfbgt0NHKSRcTxT34plw_1773288435
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6C9BA1956089;
	Thu, 12 Mar 2026 04:07:15 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.57])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1C70C19560A6;
	Thu, 12 Mar 2026 04:07:09 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: mkoutny@suse.com,
	yosryahmed@google.com
Cc: linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Subject: [PATCH v2 7/7] selftest/cgroup: fix zswap attempt_writeback() on 64K pagesize system
Date: Thu, 12 Mar 2026 12:06:27 +0800
Message-ID: <20260312040627.55257-7-liwang@redhat.com>
In-Reply-To: <20260312040627.55257-1-liwang@redhat.com>
References: <20260312040627.55257-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: Bzskg0Ym_RwfewFiWpwz6CQzThq-gvMjnnfgQXipoi4_1773288435
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2CB8EC0004
X-Rspamd-Server: rspam07
X-Stat-Signature: a56khejtnphknktbnywf49p899fikh77
X-Rspam-User: 
X-HE-Tag: 1773288441-860695
X-HE-Meta: U2FsdGVkX19IRZy3CZtSEbriyrKnWDIzms9u9bKFzqn+YVB+R0yleMB2Kpfyn3KgAO90iLpoifU9KPOgmcoejKL7dl5iBS1np2o8cUL3r6Sz+9gG6enGlozw4bXnBhAOwqdlavjPs0bVFGORdTX+B4vYtxk+nquiklzMGG4WTrdA0mGjjxXCGOwnwN144snRX4zk6PV7Pr+uWdTlhXbIZJikirlWy10xqYAcG/U/hxA80COANJrtXvIQnYXAOhtzcIGOcJDTvYl0sFDTl+L+5V+vkBMUmjBF6c6KkOAIramn4/x1CnVXy2JCmSF7XUZYqRN1MS6KBhgX6ejk8Rt5FzaZb4YrtIHWGCrC36smID1QjxUaJI20IYwfecAJMbSkHuQC2/MYsOZsGwsQgLwiazcUH907bGK1rDJKEXb41+y6Y5KpEFML5REEkCU/PZxROTfASSAau4TTIg8E6tyKMrU5aFDP2K9yH/s3KGWNFK8VH5H0FzWjlaorQd4vJZ9m/kjB/NR8aVJL8dpYds4kBZgiVahYh1+5xuCo+n/jLwkZg31fi7dp3X79V9k4EFOPjGnGREvca35ZqU7eqhJG3iymDaaun8Yn63zxT1fWanx9ExgMmJOD/4ruO2aT8pqy6BD931EGDBF1TBrXZO3e4szZuBiBsc+vyWN1tCWhXatq4tajZ3lwvTugdfnz3X98EyBvs6p5q91PIV8zyNQk/nmnXjfzxoBoFF/M5xxZJo96lkL4osg188llaOZeoU6EX1Z+ttW4GCp+lLkb6gOuX7L5K/LsZW6uDYE5x/LxReiNWv8vrlJRllZj/pAU3s+8ZzsiWthPinUVztfBRJvRHbGt8W4C+xQUXSzrxi7MIq9z7lkIzrRMJGDtflWWeALZowfGnaehzR1FmSruu1i/TauIiR6J1z98OlyfMsC7nHSSgu9ywtVcfJaOCYuuGoSLnSuy57snQnRiuwsCOZH
 ekTnCH6p
 aYmwwR88/njGHBrZgnTWsXXUtWZmMQtN2oA+HUrR1H+Co/rfD83kV5qJTwdQEbZbIB9XrGfqTlL8EdDZiMTk5DaF8AK3Ra0SsQxeizWrkSCBdsMaguBBbYqjleMnsGdQMMvHwX7FDSd7K4J3qHtwYaOZclGgQPsepVF7/v6JbqNphbPeUbMEqXiKRAW3N9leF03sTDIDmh+LFWvYmI3n/HtoguyVjqizPbCEVXJJzK/AXvDvCnRfeXIcadKjKkBSOZF+Ut2EAoTyKrOum0kvXb/CAYcoOG1z6NrNd8CpSxFYqJdioVLUgBxEfpwn+ldCMrFzcV+YDDR44m7uYVnlRYylfwsYDbMJinVGpNE8E0z7TD1K8QAH1521VNwkIKrnr4VKWCZqe+tXGtxu9PSpJddD6CeieYJ1s0ofjZpMVrWVFmctn/MoUrjXzdXrxITb7yKuh9WjKFuC2+pSVWnVaAVXNU678E+hVYT66AT+93nJ9AOWZdslYVNn67Y4mIzNQEW6gHGt4LegnCg4hW7YFY9M3vfYXPL+PVieYu5ENVXvzNQEh9zCzg9Smxy1q7IXqWR1HtjxeR7IGj1/9f5aTucG5RsEWUmcy2HFR
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
zswap_usage/2 insufficient to create meaningful writeback pressure.
The test then fails because no writeback is triggered.

On 4K page size systems this is not an issue because 4M covers 1024
pages, and file pages are a small fraction of the reclaim target.

Fix this by always allocating 1024 pages regardless of page size.
This ensures enough anonymous pages to reliably populate zswap and
trigger writeback, while keeping the original 4M allocation on 4K
page size systems.

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
Cc: Yosry Ahmed <yosryahmed@google.com>
---

Notes:
    v1 --> v2:
        * use pagesize * 1024 which clearly shows the page numbers

 tools/testing/selftests/cgroup/test_zswap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 4eb88930b45f..acfa0045d2ab 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -264,7 +264,7 @@ static int test_zswapin(const char *root)
  */
 static int attempt_writeback(const char *cgroup, void *arg)
 {
-	size_t memsize = MB(4);
+	size_t memsize = pagesize * 1024;
 	char buf[pagesize];
 	long zswap_usage;
 	bool wb_enabled = *(bool *) arg;
-- 
2.53.0


