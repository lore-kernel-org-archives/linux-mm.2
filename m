Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A65FD1088E60
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 17:38:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B35A6B0563; Thu, 19 Mar 2026 13:38:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18E676B0564; Thu, 19 Mar 2026 13:38:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C89E6B0565; Thu, 19 Mar 2026 13:38:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EF4566B0563
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:38:57 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BD45C13B53A
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:38:57 +0000 (UTC)
X-FDA: 84563523114.12.EC49776
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 75ACC1C000D
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:38:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bQt4o9D9;
	spf=pass (imf21.hostedemail.com: domain of longman@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773941935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=GolfCpcwvGX7ESq6QSakQqV8SX3HQ4CiS3Tfxd8agvs=;
	b=n0ThbFEoRckAj+x9ZWXVFUmmrqn8jQ17/fNSEamocRaRAM4orJ9EPOkTq+LvGm12SYMjkt
	cqtxezjgJyEGORQ3ISNyEa7u8YTZPEziVY8KwLnvyCBOr1Wug6wLLCdeTlgbAKCS+a+Ytc
	mYHAjOjSOkZIfV7SDY9RTuHbMeS4iek=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773941935; a=rsa-sha256;
	cv=none;
	b=FGSwKhxDWjHHvQkO3WtNN8PUEcNl6d9KP6Sv0rAu3MUMQ77mNbe1PTQg9QsTERr2KeYe5+
	owuTc33ynpwS+nDq3wmoNBDTjeJQjMLz/K0aJV1oJaL03Iw4r9lGfcVH7bOzW+bFkyEMKQ
	13ftGVYMFx8of4uLcmNVoFwSQBzaFvI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bQt4o9D9;
	spf=pass (imf21.hostedemail.com: domain of longman@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773941934;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=GolfCpcwvGX7ESq6QSakQqV8SX3HQ4CiS3Tfxd8agvs=;
	b=bQt4o9D9xZcMYHBCHuVEe2AqGX3gRINQ9b3N6oEJKE0KDk39ompnflHoFe1QP6Jx6httJH
	h/P3YKJTY60YetbBD8RhoYtW/S0+XpMVvW1eYHTqw+axmwK97GUveqoJLNtDbRtSOeTPEG
	9zxpASNNUGnFqgGHBe1qgAVnjtk/fT0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-389-oho6wAX6O5KCaQuvtplSuQ-1; Thu,
 19 Mar 2026 13:38:51 -0400
X-MC-Unique: oho6wAX6O5KCaQuvtplSuQ-1
X-Mimecast-MFC-AGG-ID: oho6wAX6O5KCaQuvtplSuQ_1773941929
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6B87518002CB;
	Thu, 19 Mar 2026 17:38:48 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.westford.csb (unknown [10.22.80.194])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EA7F430001A1;
	Thu, 19 Mar 2026 17:38:43 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	James Houghton <jthoughton@google.com>,
	Sebastian Chlad <sebastianchlad@gmail.com>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Li Wang <liwan@redhat.com>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH 0/7] selftests: memcg: Fix test_memcontrol test failures with large page sizes
Date: Thu, 19 Mar 2026 13:37:45 -0400
Message-ID: <20260319173752.1472864-1-longman@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: Qyw5csg8Q3SYGLK3fr9MNVkd7vWrlVtftP24Pj5qlWc_1773941929
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: yszdphpa3spxzqk7powtc9ikxj7xh74e
X-Rspam-User: 
X-Rspamd-Queue-Id: 75ACC1C000D
X-Rspamd-Server: rspam12
X-HE-Tag: 1773941935-164458
X-HE-Meta: U2FsdGVkX1/gXtvGmOXz2cjcG6hTCxqEhyXEMchmRk9+JFQYHvejm+3+PxDfzZ58q3sDql0OyD+5D0IDEqo/7NbswCT0PHTUOZ9SPin7wmrwW3LkdjO2I0Mu7cOU5YckR2nZNc9wCt5409HNzmPKAwO8a7ykNqIS4MIt/ts4a8NHcZN8cDyiCT4sfdaqdCtt5Ors33TqnoTAtgrSG65iinyt2/1qcxAGj5iBki4ahyeo4AliqfhwX2IcheB4D3vmJo9xLCRAhRaMcvgUFll0qBGYRKcyovCEIGn0sp1Z7V+CdV4tQ+bQDwZHARX9wQzxbKWFQMtcBbJHqOq0fYZEs+imk1uacupnsbY096Xv4JccwG92Z1D+GeG7JEIAFTDPzO0VUL5+8Esk65vuBlzh6AbD2mj3Zl9Y3/AzMDM8iEt/ii+73h6CvQ6p97LpraDsuJexz5BWpPov9iCVn9SCxhsiw1U3CZBHSslxN6ZrF0UyBwi5p1BeU0J+f6jVa6jDdJob7SM0RjOdA+/5Y+A1C0EgLbA7WFwl25nHHqWhU6pjm+HJySUuuF0SxHUQXN/Bw+UgxNs4ahTHzPHl3XJDG+YP8d5oQC7deFBoHvmR7DriNE82z95ZkOSjpQRXqJ/QCM60+YJ+U+eXN95kBDWnSmenE1qj0u2GL8K5lnVvhhX0ODDgzYcW9bu2XB4QpAMX1mT/cjRXwolw7lDqbtYWFQsY3dKdL2VS5LV65N81d0uwvPd5klF69k4ZelC8zpqkJxaFq+gi3MlKsHfJMQQ9k2V7jDV0Cwo8s3tkA2ZKPswFyzR/wRTvYey5zPbvfLYLe9W6MFJtlQTwq4eAqsNJiypDyUrUGPJD6UFCLFj3knIZvZgSQHpkutTSVjPoXy+CaHUvZbRchrpmv6I3w9M8ZaE2yUV5TErgCipJ3ECWwuXfNsVw0GvtplrZdgYtYN/OxBLoMaiIPQHeNcizIMm
 dYGOa3V5
 xGzoJ11Mb1D1jEB3APW4ai1ZBL+8KjvLDS07Anvwjpd1sHQyUi6upU/A5gNYGhimq7mpMgA0wdwfraWSx9UnEm1ibwDnI415yK0ZloN/Sy8zeHDM7PA/iwndnN/W6LvmstqVe1Dqiv/I7iSWGWhDGCGoBC5Ux+36KArnOkJPbElvffvhUl6a0DttMwjH6y8/TtwmV+zya9TP0meWpQX8yqM+BU3FKzucNerkduOgu1xKOkhJPZZ5PzP8n0ouoEYURQ55zHYtjhwFpAlwj4nY9/NgTLf8SrjHHpWj7rk2C7pbQQmvPIQnsw/sF1heRSxWq6Cy0K/itoaOklmB4k+c21NYVWi3+N38iTTZdT/tNaF+aY1Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are a number of test failures with the running of the
test_memcontrol selftest on a 128-core arm64 system on kernels with
4k/16k/64k page sizes. This patch series makes some minor changes to
the kernel and the test_memcontrol selftest to address these failures.

The first kernel patch scales the memcg vmstats flush threshold
logarithmetically instead of linearly with the total number of CPUs. The
second kernel patch scale down MEMCG_CHARGE_BATCH with increases in page
size. These 2 patches help to reduce the discrepancies between the
reported usage data with the real ones.

The next 5 test_memcontrol selftest patches adjust the testing code to
greatly reduce the chance that it will report failure, though some
occasional failures is still possible.

To verify the changes, the test_memcontrol selftest was run 100
times each on a 128-core arm64 system on kernels with 4k/16k/64k
page sizes.  No failure was observed other than some failures of the
test_memcg_reclaim test when running on a 16k page size kernel. The
reclaim_until() call failed because of the unexpected over-reclaim of
memory. This will need a further look but it happens with the 16k page
size kernel only and I don't have a production ready kernel config file
to use in buildinig this 16k page size kernel. The new test_memcontrol
selftest and kernel were also run on a 96-core x86 system to make sure
there was no regression.

Waiman Long (7):
  memcg: Scale up vmstats flush threshold with log2(nums_possible_cpus)
  memcg: Scale down MEMCG_CHARGE_BATCH with increase in PAGE_SIZE
  selftests: memcg: Iterate pages based on the actual page size
  selftests: memcg: Increase error tolerance in accordance with page
    size
  selftests: memcg: Reduce the expected swap.peak with larger page size
  selftests: memcg: Don't call reclaim_until() if already in target
  selftests: memcg: Treat failure for zeroing sock in test_memcg_sock as
    XFAIL

 include/linux/memcontrol.h                    |  8 +-
 mm/memcontrol.c                               | 17 ++--
 .../cgroup/lib/include/cgroup_util.h          |  1 +
 .../selftests/cgroup/test_memcontrol.c        | 83 +++++++++++++++----
 4 files changed, 87 insertions(+), 22 deletions(-)

-- 
2.53.0


