Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69195FC72AA
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 06:11:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBFF66B009F; Sun, 22 Mar 2026 02:11:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C95E96B00A0; Sun, 22 Mar 2026 02:11:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD1CE6B00A1; Sun, 22 Mar 2026 02:11:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AE1496B009F
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 02:11:22 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 724B6160794
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 06:11:22 +0000 (UTC)
X-FDA: 84572676804.12.0583003
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 94076140006
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 06:11:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=He4JkeXW;
	spf=pass (imf09.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774159880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fSV+/tqM70wKgndqvLBa1N8bfrFGZwvNXk6Fa/4Lros=;
	b=WXSfMSnXtmydE+4Sj+49FsYKhrA+fM1YBF1AQNC2WOo9OLfy57oIH4KD1VRZu37N89JS/n
	3Kyi+Coa66gWZV00KgrwHwxmIQAmPArhAidccQ8wmOgKPfFnDMqyREA1oXACo6S4ae9WM9
	vyW0lWSOa916OsogDBojQPSE/AQGIuo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=He4JkeXW;
	spf=pass (imf09.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774159880; a=rsa-sha256;
	cv=none;
	b=BTKhhdlr34oP1ksWK7Ulma99TLUnmrtWLQNMG0rVuFXWlpmkkYJvWuTZyOdtcYcxDMmeES
	RTUrQX7a21MsReSHG1MtjhM+8lNyC0u6X4TRbbfZ5hSOHSIS59Y/LiytbRJx3sSv2MJ1C8
	Aa+jpmmaAPhVSjtjOCkgwls1MZcHqmA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774159880;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fSV+/tqM70wKgndqvLBa1N8bfrFGZwvNXk6Fa/4Lros=;
	b=He4JkeXWoh31vxb4AXacHtAGn38gAonnCoN3yBiMrahKGUQXiCoX0i/tk4O1ZdXOkZ/zGu
	K26bPuNH/QrOy7fvkDJCeDtZC/ifq/X6xR3H7gqpmc5LuJOGfRJba+tIXVZwUcGsSTc33v
	Lfv4d9ZaAcAswcknWVkTrKGQg1QKDFI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-402-wBx07rGgPOyTWL5happl-Q-1; Sun,
 22 Mar 2026 02:11:15 -0400
X-MC-Unique: wBx07rGgPOyTWL5happl-Q-1
X-Mimecast-MFC-AGG-ID: wBx07rGgPOyTWL5happl-Q_1774159873
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F2FFB1800464;
	Sun, 22 Mar 2026 06:11:12 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.34])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3E2F91955F21;
	Sun, 22 Mar 2026 06:11:05 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: akpm@linux-foundation.org,
	yosry@kernel.org,
	yosryahmed@google.com,
	nphamcs@gmail.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	mkoutny@suse.com,
	muchun.song@linux.dev,
	tj@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev
Cc: longman@redhat.com,
	liwang@redhat.com,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v4 3/7] selftests/cgroup: use runtime page size for zswpin check
Date: Sun, 22 Mar 2026 14:10:34 +0800
Message-ID: <20260322061038.156146-4-liwang@redhat.com>
In-Reply-To: <20260322061038.156146-1-liwang@redhat.com>
References: <20260322061038.156146-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: AhgQPgwTVdGhqlgWx5g2VEPRDEpho22EZU92nXRyvFs_1774159873
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 94076140006
X-Stat-Signature: qsgaamfp6hbh8cumexpeqobsyg5wyskn
X-Rspam-User: 
X-HE-Tag: 1774159880-886145
X-HE-Meta: U2FsdGVkX1/WbEHJpagosfD0rGePbchFXKyZCgS6585YDQK1hj+S2ay6YHCZYpo7aGLmzbm7jPzh4A8ToEI2mnMj2h/csX1e9Z1S5oxktgRjpVX2/4IGyPKCyZPIcpECHQNzedwEgzOBWHnc8E+EhU80qgQVuWTqSSJK92zJx6TyF9qvfCBdJJppTSoyymC0xghcRbXjJNrkGXMXbruszMj7/9PLofV1sLlHIQcho2srplbRhFo8cHTjg75ANIpRPsVg+nsJOOLw9P1zRXmUQSZ4X0DofyF2ZcVkqpWR3MTVtnYURbn/yFMn9p9SiFo0CnxerJ4vSpz1IDw31zsAu9iasWVHRRjBWOC+SZfuXq/TuPk1z7W/JWhh8/FSoZ3FpC2qkHEYThWr/VkbJv8ntJ5k3vNAZb3wB/8feK6w0mUbumwCoOT/eLTHGxBVy8OxhymD7beJ66jetRTfOBH7xa4ZJPp9rnVCJQOtVKBOUw9aFroYveQsX+5KtY6IuhnDPE4Tg6Ihn2XKXo1+yEdDxEo6UqWe+huve06kmCe3Hy6Hi2AvTiY35+fYMsTdrnop+0Srd9wHW8UOFFl25DFUy0lZYUJYDOmeXug2oAcMZvMe9vHEYisuTAL1U830XyYUz2qfGbuJfHr4Zhh52dOuhv6XkxcZcUxk3KFVVfvbRqOWs26PTOSKZIeOg44Xu+e4oGKz8RRVKuSawYRynu7ZClmRYqlUtFC7YlOYeJ7/nwi+65nNd0zL+3yX4NbewyL/SZn0q+B+6belGikeFSwCcwvTNy1u9l96o4dSUYNJKoo+0KCZnufcnZaXtGVU5hmieiy6hapbXnz/oa4/81EHdUXQUfGgzsbZOasQC5HTlRP90rEzWYpQWOs1uYuBOndjNOKrDEXJgznLZIbvGU+YwVlmBTweiuUJ5hQqORoCVHet+0rETEs8aInYEURKhm3hqatHzFZnNa4A5UyTG/v
 pof9s4Eo
 YyftPXf4f1nqgyiR7mazLAhUJpmwn4vAVfAq7NMxo/gFK1W5jMW9OSH6bUis02nb8slPsX4a++xKEa2HZvUXflBS6d3XAN1NRIPg4K2pluIGlpBVb+7zzzChw8VC/u2PDWyMkHmEGVcH2UeOcBB/GPLBfdQ4eGFIqL5rIoFLmTZKIse/ytVbXkQ6ZO05CFrkIxYGBwui1S8T6cnKyrsdXX7loxSLJiYvuMN7mZjUlWgr3mDe7JcS2KZ7xh5e3Rr4fMEzjcOidf5jzJtrDQ6yszerF4CrU83x3zMfz81c7YwRBnnDMnqiAr8SmXZgXg5QIYMQhu3EmPXEPr6TrPVzvdmnTIz0E7nv9ItmgaD9/+dcHbKSLkned0oT+Hdd0wmDyf6MGVzSq/dJ+N9XJXMH++pX3N1AtVdxaguFjcg6WA7bHFd+PiXYV1MR4goJ4EoF0PzZGQY/x5Gno0EVr+feObh7YXKfa9xsIJxFKbG5/I61dYzvJjDF0Ba/uFucMpTO+zyPXtCWG4LYJKmTi5R5zIZOSsA==
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
index 4481db4bc0f6..4982e8c4759c 100644
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


