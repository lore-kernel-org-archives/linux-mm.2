Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7D59106FD78
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 04:36:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24AFA6B0089; Fri, 13 Mar 2026 00:36:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E1AB6B008A; Fri, 13 Mar 2026 00:36:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F1BC6B008C; Fri, 13 Mar 2026 00:36:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F03FA6B0089
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:36:03 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 920E1C27B1
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 04:36:03 +0000 (UTC)
X-FDA: 84539777406.10.DCB3F04
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id B04B0A0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 04:36:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Cbbt13W7;
	spf=pass (imf15.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773376561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mANu5JTngoht673DDmFsfxzBZTyPV5zWpLjDuRKk2EE=;
	b=jq+VaRs9jkyxp8uPgZfGNTEKkvhAe8XgXs/tonfJ3sEHcFocEe8bXZqU0iWdouiMZ2lS4x
	Ur8GOM90M8bevWrV/LGd4vyQuprcpmPUvm+I7fVxAhvX5IbVEhNQpFeThEuG2WlWiHRlW+
	rtDf9YeWmy7KaGhWzLkP6vFGjupiCJc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773376561; a=rsa-sha256;
	cv=none;
	b=8hTU7FKud3x6hWVc/YHg7Fyxybp/A8LEPCrvOxPn96LFxnQObnU5rwVsr5SDmG7evVTCl/
	JwmDw4I79yZG/CJ1mfgEF//XZ1Rn+xMehn33iim0odpju4V9kGEMgusXeJOAv9YimQYuKj
	0BfuFRXbSlvxOIY3f4fQ2R4nvv5v9A4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Cbbt13W7;
	spf=pass (imf15.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773376561;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mANu5JTngoht673DDmFsfxzBZTyPV5zWpLjDuRKk2EE=;
	b=Cbbt13W7ZJrDivYCbSUcyQU2mEz0Tv/+GqaGnvfYqSMzJVWjoeryMNT3RINjuP29PWhyOp
	m3OGgapupLjKyjC0d4qaNAjrsLcrUqZ/5d0u+PkwqLZiDvKE5AjMkB7Yy/UrOqiPC+iFwD
	/ZGpvVCLh+5FGISohk2tqeq7ioSfbKQ=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-512-77vDwfrhMyaYvAkdEQSqsw-1; Fri,
 13 Mar 2026 00:35:59 -0400
X-MC-Unique: 77vDwfrhMyaYvAkdEQSqsw-1
X-Mimecast-MFC-AGG-ID: 77vDwfrhMyaYvAkdEQSqsw_1773376557
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A9966180049D;
	Fri, 13 Mar 2026 04:35:56 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.18])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8E65919540C5;
	Fri, 13 Mar 2026 04:35:50 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: yosryahmed@google.com,
	nphamcs@gmail.com
Cc: linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH v3 3/7] selftests/cgroup: use runtime page size for zswpin check
Date: Fri, 13 Mar 2026 12:35:28 +0800
Message-ID: <20260313043532.103987-3-liwang@redhat.com>
In-Reply-To: <20260313043532.103987-1-liwang@redhat.com>
References: <20260313043532.103987-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: pfljNdmmO3dK_nSDblwkJ1S4iOn3yWN6Qr60pxSSJc0_1773376557
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B04B0A0005
X-Stat-Signature: se1eaa1efhu9aa9z5tyufzbfp4kesm54
X-Rspam-User: 
X-HE-Tag: 1773376561-115879
X-HE-Meta: U2FsdGVkX1++ykScN2LIinRUQKMI7azJNczhFVzYq2FiUgvrBNBpBb1ejsGZOo4/UMlctx7vHpDTN9epyUXwQnTVuOvEYPKW8xi7Sal7PfTmUGEb6sJhCHd3wsvduTGuT9QEkGJZCLdgDv8r9wCqV3/b3qZWe8KeVX1hMMBVwGIg67JJZwviVti01hO+hvHLd7XjuHb34YIo5S4f/TKhoUyTmQYeCE8xB1e7czSZFYrRzuaCz3U8dZ/YGGkDkm8c/k9wYicZ6Yr8jp8CNz2GQYHCaiJIIZySA80Oqz1YI8NymPnviv4iE2KUm5Hj0mOwG4TZOdul41uLb2L3W+yU4x2EjVL+b+zlE9q/IBsLNJWRFXGgWoXp2BcFJ56RWgMlQ2UiAREnC58k7/COulvocw2beMw0s/yyjz6QDYAZfQZ0yZz6lTQQTLUKpbInvVSwJou2vDjy60AtuhQ/+TmmV1Z3BlTC8k1S0IuDK0xAbMvvA8uDv/mewn+lElec1+q1ubCW6POKELN8ZI+v+fzrWHWajHPAH7ecXr04v8lu01CjgTxMW/lYm5Ty4xDi6+Zwty4/PiI8LlohVSoLZk/qHyMoVOcbS2XChEVpTJ00mCaiNOtNy6uosN41GboIWHR8E8LPzZMkHmz1ZD1mDvKPi6Je2oHXF7yKsBcOBpZCV+g4lp2pI80ghMtC5e2vyEz1Ley5pXCT10UYfYIkncqBTlp1/AZ/HOnqzUdJof3exHTFtgbVmrcvMEesoI9EyNJz0WhlBD9YkNixkJnMOeBnu9YObgmZuJWl3PFNN4Q6+FiR4YECjY9/IMZmUHnXr/R35ttyPuOYQ6tpC4YUuzHotqig6FbwsOMG9DmIfEm5YLTGMoJsfuc3DaDlxgDjFfzCe7bAUyr+qqqvZ2e79ObajFmqkoDDdg3fhDbVq86GAVW4Odni/DW61IjFoFebb2gQ/Qd8ojUUescabFCIgD4
 8HQpvoDs
 t7BHPM/dG8uTsQVptBCvKsdUG312WjNEkwVhcULhFRd1G3ZZh5hQnkuHpbumd+lL0Cs2g+RAtWS+sugqVEXryV17pIfhmlUfjXrv4mz8J/vebn3XXz62h6rL/+LlxyCXYCwr6VEDh2PGjeEds/FkjvPfiheaeQvBXM3FPF4Up9PAC74YX9FO5sqbQ0gyV+6iKrsA1+NtmPzB+4mltBLsJbP6Agvb5XLkqb8+PePP34qah/HPGAuMgbifpAUW4GE3oJoV6AMMTEdWWI6bOuKVcgU2ZR4fKxj95bKqcoFLcVEJYoB5zq95ewleZM2R+Jb9nB9SsnFq+i2qEjafjdy4e/vXmgqvKvagU/QhPiYjZfaRA7lFy2Mb2W9QJqakYv5znEybmfk7C5JGoVAL0Ap9zO0YhPLjk+GWojuK3N4BIerkffyktMmIGlrCJ7lUthyGzXxsioAoOeGO7DELot2XqfgzJL9wfZJt25f5KkmTpUNWDrLhXy9CBnztck4DniZvQMlLeRzJNJesKG+cb414ouV23oA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

test_zswapin compares memory.stat:zswpin (counted in pages) against a
byte threshold converted with PAGE_SIZE. In cgroup selftests, PAGE_SIZE
is hardcoded to 4096, which makes the conversion wrong on systems with
non-4K base pages (e.g. 64K).

As a result, the test requires too many pages to pass and fails
spuriously even when zswap is working.

Use sysconf(_SC_PAGESIZE) for the zswpin threshold conversion so the
check matches the actual system page size.

Signed-off-by: Li Wang <liwang@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Yosry Ahmed <yosry@kernel.org>
---
 tools/testing/selftests/cgroup/test_zswap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 04796b6641b8..74b57331cbf1 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -240,7 +240,7 @@ static int test_zswapin(const char *root)
 		goto out;
 	}
 
-	if (zswpin < MB(24) / PAGE_SIZE) {
+	if (zswpin < MB(24) / sysconf(_SC_PAGESIZE)) {
 		ksft_print_msg("at least 24MB should be brought back from zswap\n");
 		goto out;
 	}
-- 
2.53.0


