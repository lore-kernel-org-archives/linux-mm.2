Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4239A1099B37
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 20:43:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 431086B00EC; Fri, 20 Mar 2026 16:43:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4092B6B00ED; Fri, 20 Mar 2026 16:43:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31E326B00EE; Fri, 20 Mar 2026 16:43:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1EA2D6B00EC
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:43:08 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CF295B7F2A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 20:43:07 +0000 (UTC)
X-FDA: 84567616014.02.2405F0D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id DB4B61C0007
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 20:43:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JqMRHv6A;
	spf=pass (imf21.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774039386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=mzDJOwyHBDBq1BCeO/lk8RpHfJAtuh1dPDmbb+C20QU=;
	b=7069H+tpSadltbjKwtg2bVeoS3Vazy02xQrHhx+/BAJnw98/lwcTFSXtYPFYGjX4NDVK3r
	/BOuAUdrMJ4jIbQzESUDo6fvl0pncZHd9vBd0sry6V0xcv6orL7YfSPN1Vy6zfkl/Z8yBD
	Ys3/Rx0bjnpTGEGG/nTSqhMD9kmkXGA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774039386; a=rsa-sha256;
	cv=none;
	b=7OjjFYZzGYL9h90CNhvKACx4Sp7Kca2W0MMmP8lz2UYRdVCjAQVrQ8sm//hfSgseaGr6Ez
	FGrTKnGMApo8IYZLqdofUVMobNQllEO11xL83uFKs7U2WVkxz2S2qdAE4RbZtnlCixynNP
	3rstiOnxG08WpFtAG2qQEe+11miPfrQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JqMRHv6A;
	spf=pass (imf21.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774039385;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=mzDJOwyHBDBq1BCeO/lk8RpHfJAtuh1dPDmbb+C20QU=;
	b=JqMRHv6AhrHEKiu/0fuzTUxXsvvL8l0wOQDJUwbQ9mTP1/G34Vl0j2Bz3rr9EfMA1wDt1M
	X2GotSqp3xjkvv6TA/H4Y+mTjUNgu4HuRllh7jFMQp/lIfCP12+Hw49zqBqMcoTeTwKePi
	xrQpd+kgmZLxYkQVtfzP+mEMF8r32x8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-568-JHNhGB0_OU20nOz6yFSHTQ-1; Fri,
 20 Mar 2026 16:42:59 -0400
X-MC-Unique: JHNhGB0_OU20nOz6yFSHTQ-1
X-Mimecast-MFC-AGG-ID: JHNhGB0_OU20nOz6yFSHTQ_1774039377
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 64FE61956055;
	Fri, 20 Mar 2026 20:42:56 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.westford.csb (unknown [10.22.65.139])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 93657180075B;
	Fri, 20 Mar 2026 20:42:52 +0000 (UTC)
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
Subject: [PATCH v2 0/7] selftests: memcg: Fix test_memcontrol test failures with large page sizes
Date: Fri, 20 Mar 2026 16:42:34 -0400
Message-ID: <20260320204241.1613861-1-longman@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: yHOvOytY0CJ0XQqFo6Agkmu6oy_9Irabw8dAX7Azmsg_1774039377
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DB4B61C0007
X-Stat-Signature: i3cucdqmn5t8m7nbkqffocw9zgmutd78
X-HE-Tag: 1774039385-945142
X-HE-Meta: U2FsdGVkX18aU1Z448f8hxgeA/iowwyUVluSv27M8tWC/gaeQvQZN9d6K3PmVw1laEGGDdglHhahQ8f0DbSOFlAV5fW4zwI1VTKBy8KscworLIpDSi/NBt9zkBsnwKEanpvWFAypreSwfo9BsY8eEl457+xgf4BA7V3ZKrqws9wh6qV6PMZdSZVjglbs8/qcil0ioLgsbAf01UQWrNsb4oqdQcxV+CbxuGwMb6UCaqpUDOo2tJ4lXepF6wGE5YpHi1x8ItEarrc0LE/5b5XQSFGCTH7kLJSHaEAWkeG5mV9mh+K52yzJtnGUtVTmwHmGJYp55QVdWYP11kNHMbjQZr0rzjvalRyhBOg+ZdxfImcVL4xpIJdfMN5vIUmWmtQMTUwWQw5uD/D2wYyWgGGCp4n0aO9WRRKtzEkWERK56feT/OkTgw4dR7zaqwUqpXuAkIVs1Qo4vqbd4Q+PXYhrsM6NymtwKAWIV3yhrm1Bo4TcEQvZb78baKkff17URoPHzjg/oBjxoTfseDPhCbXsrhwfH8xAnml55gr/1qjBVoT7eyW8z3zDzKrvkjl0UGnq7/2e1/qWW+F1+IuFfn+sZ3HJyG8aJ1b6lP3W18Au3p4myVY/xJW6RL5qA/2Oh9nD4t7zds+z7x2JMKLYYAtcz5k2+dPiKzTQAp4ucuQ+MLWYru7yvv2IGXYftEc4c3vU4WKsVRls8kMNVz1a74xmg1hdn5P9BZNU1DSrga98rnXeMBNLGCQr6xfbKxkYCK38KnyQSOpQ61xUXPWO+L1r/REwyDeRWrO/mKzrZDYujvhX1wgB20vNK30OF9yVyGqB0DBPFCnyge7SieOEfBqs179TAv6yAUfZdWYZEnurwt9oUa5KOKUhvYTx+Rxkk8fJypfozTvq5Lk40dlvI+bAjkg0wtd+LuVo9ZV0z9fS/CNxHj2nRo/1Rr+Mk5N4/KGgKpfXebBh8wu9AJCqA5s
 qc/mdKrz
 IZViWekDt/YhkwdE1WwFyaHeQIhZLOTpQoJ8AqLsw7vizyhvOyYO5+ycCPpB+m+G08vTWfQpDqNMu9ScyLoHBvMRYdzwNPeoTmJkfPdyrdtoq55JpPVsDyUJBenhw6B6F0iiH0n/PmV4lORM5CO1ahJSezpRmbbI47G/6IB2tKRnu25cBNlQohOdFsJSrak1/bIgRvhv0dyMaTl4z28JPk9aOZsaSfwar40RhGXnqFY28aqpJFnSmDaJjcgwbtiQ8aG58QgOQAwOT2TDtqNBmo7e+oYBwJcYOJDTd/ja6Vl7Mag13XT1rV+c/anKhfavEAXoR3R+FUOhe9tAeW+byEadejjWPsP0B/btoyXkjVqcFyQI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

 v2:
  - Change vmstats flush threshold scaling from ilog2() to int_sqrt() as
    suggested by Li Wang
  - Fix a number of issues reported by AI review of the patch series

There are a number of test failures with the running of the
test_memcontrol selftest on a 128-core arm64 system on kernels with
4k/16k/64k page sizes. This patch series makes some minor changes to
the kernel and the test_memcontrol selftest to address these failures.

The first kernel patch scales the memcg vmstats flush threshold
with int_sqrt() instead of linearly with the total number of CPUs. The
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
  memcg: Scale up vmstats flush threshold with int_sqrt(nr_cpus+2)
  memcg: Scale down MEMCG_CHARGE_BATCH with increase in PAGE_SIZE
  selftests: memcg: Iterate pages based on the actual page size
  selftests: memcg: Increase error tolerance in accordance with page
    size
  selftests: memcg: Reduce the expected swap.peak with larger page size
  selftests: memcg: Don't call reclaim_until() if already in target
  selftests: memcg: Treat failure for zeroing sock in test_memcg_sock as
    XFAIL

 include/linux/memcontrol.h                    |  8 +-
 mm/memcontrol.c                               | 18 ++--
 .../cgroup/lib/include/cgroup_util.h          |  3 +-
 .../selftests/cgroup/test_memcontrol.c        | 87 +++++++++++++++----
 4 files changed, 93 insertions(+), 23 deletions(-)

-- 
2.53.0


