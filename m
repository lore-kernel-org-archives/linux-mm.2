Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C921FED2C4
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 04:06:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EA856B008A; Thu, 12 Mar 2026 00:06:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4240E6B008C; Thu, 12 Mar 2026 00:06:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C3346B0092; Thu, 12 Mar 2026 00:06:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 172BB6B008A
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 00:06:57 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C21D613B982
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 04:06:56 +0000 (UTC)
X-FDA: 84536075232.23.2144F23
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id CFF80140005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 04:06:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=co+d46a9;
	spf=pass (imf09.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773288414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1oqyGkpiXQH6MfLqjVNkFfBzl0bb79Z7LYQCcOdDcbA=;
	b=zeKlxezL3ShtKbYoajoUhv614G3NOs07Kz+ks1dCkry0vAuEYRiwWDUzMP6UV4AIAlJROf
	myRtgj8P/OvKqgCacFAohbbsTLWGKjguMwDOeyr7OdooB09ERUgmS/93cMR+9U5JMJB8OS
	hLx9yqyEuHj5f4JH9p1CnZrll4MG56k=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=co+d46a9;
	spf=pass (imf09.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773288414; a=rsa-sha256;
	cv=none;
	b=4mPWEuCZB+tkHSLYvHXR+ncq++hnccrEz2xLYavnKoUu7XeVp3M+ceONv9jkadm63BuOLA
	VOoYif4isgxmM6ILJB+Q1uQW7nLJbQBj+pywIrRtDRJPFfEjSXdX4njPZb1Zzv5uzddKJZ
	kedlLucd6y8omO9AuACLjXFTEQZOGY4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773288414;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1oqyGkpiXQH6MfLqjVNkFfBzl0bb79Z7LYQCcOdDcbA=;
	b=co+d46a93Xjs5XbffE4s3if+Ni869Cd4aE5LLUtbIq/61I6vtGLxFjTK4tkCs3kvqAcOmJ
	0QPP5NRha/17EDI6qrvACOkOpIzA1pjpFUZI34PQfw2SohR8PZdla2IprbfXVU8SBgtMcK
	4VtlYhGPeREMgxdi/jzhA7q7osfaryo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-523-fYOGFEniNoKoO_H95PMI0A-1; Thu,
 12 Mar 2026 00:06:52 -0400
X-MC-Unique: fYOGFEniNoKoO_H95PMI0A-1
X-Mimecast-MFC-AGG-ID: fYOGFEniNoKoO_H95PMI0A_1773288410
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AD60E180044D;
	Thu, 12 Mar 2026 04:06:50 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.57])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C1EDA19560A6;
	Thu, 12 Mar 2026 04:06:44 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: mkoutny@suse.com,
	yosryahmed@google.com
Cc: linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Yosry Ahmed <yosry@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Subject: [PATCH v2 3/7] selftests/cgroup: use runtime page size for zswpin check
Date: Thu, 12 Mar 2026 12:06:23 +0800
Message-ID: <20260312040627.55257-3-liwang@redhat.com>
In-Reply-To: <20260312040627.55257-1-liwang@redhat.com>
References: <20260312040627.55257-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: acdE11ZchufUQGLckdSRzjRpwGgntNNA3lXo5WBf6Mw_1773288410
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CFF80140005
X-Stat-Signature: p3rmgc8haaq3om6o5q9wukotd3946q5i
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773288414-511605
X-HE-Meta: U2FsdGVkX18L4vWJk8FX6nExMhBa5CW0LIEFhJlxwNQTcA6ZbGhlLACRriuMmuVWGgKPqPYBQnmISKOAWdliOK+hS72POmD7HHn96Nqnu+sKbeXxNAwXOUA3PqVd9Z+ukiXMZYXIuB7Pej6LvMu6PirUp0pyI2Fbt/0H8M3dDVjKDUtlZwSZ1xlmCJF+XyDO7rQSAbLPWiC5CElaR+KDDV5PFFku2bKHJm75VNiHIyQqLjUVsiCfFjxcAaJRi6G3JsfsPgyMoSRmTEzxiAfxcBfqqY0lq4b0F/s1+eO2VYs01K5PE5nfdmlBzp2y+FA+50PqCvTW9st4no02aJpqR/G6mmEJEhGaYRchYbSFU5wjUmM2qmD278cPHsK5le2LYejSPuzGtG16OMJZlH5wkhMfyN5vrz718xSWO9+/NsA60TAnk+8cKPzOSR/ZFhoMnvwCTMfGgC5PDS6xqJkRhpbuRt261WWKdv0mDvH61xM+zb1kVc8Rk2RXMUHxsF3MeHxYRl51gx9wTCOZv/AcHBKePyTLId5Jg3Xdl/kNq0HwjPsusrAK8u3Cm18EY0g7HlAH4k7NKUbEU2+yjDyqn79LjbF0fY85XF6G5pARf84yO8TMA1rVLJHnuk8tXzp99pqFQUZxa9wxn0fxlBhFtHLXBXjaaoLSQrgaAsb75LvwxDZJO/TImh1z45ybtyLbd9ltLHa3SasKxASgfPNu+oOAhwoTvEPevgwhYbS+oVEhddMv4Y7La1fDSpC5ZnkBTakJtI+yvyg9ixRE4/NiAaN0zkdmjmz893mDxZoJ6Bo/WOwe4FGWmXjVOgCj8Y5ZCuHPkcAn4xAEx6BsfDC/XXA/unDARQ7j8mTUZ37pfn7RvXZbysWyoI4UcxhBuzJ5Dq037LWMyE4xokdwvzNRBgIJm0lGVoFP9LiaqVKM+MPOh9x8V+E5PqK2Gn1fHQR8wgnlAVfXYbe0PurEHC9
 DFkHPpVa
 s7wte4JW7sOq5ZAcvf4dhUfaznxFR2lUjrf7nNEUZY9OzKUrV5MKIgj1RRxUm3+v3D8xAoMs1ceFLhUNheXd+cEIm0SofujbFIVPpXUYV5bbYmvRLwk7iJ3FvSsSL2sb4M75ryGzSdWUaH+9Y6fUHL1GvEO9/uXwp6x2ZFng//dR2ZTVW2lElw5fwmLxZYZqlMjUpbNruqVgmbUKgqLdwsgVUBBZP+Ik6yeGr6cjyHzagpsq8ORE1uZbEd3PUfyDPe3rdwTMWNYaC9RNTnO12d8+sDWMAr7jxXOYbT8g2gSrDzWXwns2PrB2gt1gWCorDL4Tb7eBcWOlYHzBMetg5eS1LzmgHpUozCFPmEVyDl75HZDpo5QK/oriT0uaXvCJH4Yia6rbQT+7w/6/egu/gnG4n9uusqiRbyrtmxbA4YnyO/fhqqSIcHvEdVlpc99wEASgDsFKEsQOnz8kX0F6SnJZmZ2jVd7sa2zo67UqWNGVoDke9H4BuHQ72hkSDQkweLpt/tDJCMzGNQUBrmunLAqn+OQ==
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
Reviewed-by: Yosry Ahmed <yosry@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
---
 tools/testing/selftests/cgroup/test_zswap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 8bf5fc34bb23..032c36658a15 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -235,7 +235,7 @@ static int test_zswapin(const char *root)
 		goto out;
 	}
 
-	if (zswpin < MB(24) / PAGE_SIZE) {
+	if (zswpin < MB(24) / sysconf(_SC_PAGESIZE)) {
 		ksft_print_msg("at least 24MB should be brought back from zswap\n");
 		goto out;
 	}
-- 
2.53.0


