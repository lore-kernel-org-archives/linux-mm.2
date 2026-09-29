Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF0B1CA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 13:02:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6296C6B0092; Tue, 29 Sep 2026 09:02:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6012F6B008C; Tue, 29 Sep 2026 09:02:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47B706B0095; Tue, 29 Sep 2026 09:02:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1C6C06B0092
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 09:02:17 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 909B84044F
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 13:02:11 +0000 (UTC)
X-FDA: 85266812862.25.F76D741
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf13.hostedemail.com (Postfix) with ESMTP id 33F8A20007
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 13:02:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="LIvFe9/k";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf13.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790686929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=slvHoTQRjNrntVAntkRlhQEzR8bZ4lJQ4rBgjdoTYUk=;
	b=WVGqz902CRnKl6HUdJRtNcu5j9b+lcvIxaj3SzuyNlQDfLCVIiOu/QiLLFxsjSrls8OR3m
	ZIsLSCr/xyT2dKnp0ygzev5y3lzG9cIOJVWGPwvJ0P/2uF3M9Gd09nTsCR+mkkQc5M5er7
	SAIuyaEJcHrV80r35AjjbiMAGeBtD5k=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="LIvFe9/k";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf13.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790686929;
	b=A9U0JRk/tgu0OyT2LNG/lDr4WRtxg4n+meoU3tQthEkIVYLr38mcAkBLHNsSwMBzm55/dz
	qpn/Stn6WgpsmxmqU/wlDxSd4xXaRgZS16G0KdH+CaxbtIiM9BlTDAIkZwoJhes4Qpfu5O
	jL/0c8lUGaqA53tSeTakWJBW0xEpc/w=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=slvHoTQRjNrntVAntkRlhQEzR8bZ4lJQ4rBgjdoTYUk=;
	b=LIvFe9/kBmoJ4hrz56JZGCTKFzU/k6S+xnzxjEWNqZVNbbVzP/l//oYaAOeYrCv4ysw2/mML2
	21jCkP24AatQFzPskRyO7QJEM0doyCJ71InXIGr964RS8bMi42jLBV0uZqpKxVPfQnoqlrneLuN
	iTQCU2Asc2iiWESsoV4Xgvo=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4hvJ104rSSz12LHh;
	Tue, 29 Sep 2026 20:49:56 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 4A4F440575;
	Tue, 29 Sep 2026 21:01:59 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 29 Sep
 2026 21:01:57 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <serge@hallyn.com>, <kees@kernel.org>, <akpm@linux-foundation.org>,
	<david@kernel.org>, <ljs@kernel.org>, <liam@infradead.org>,
	<vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <mingo@redhat.com>, <peterz@infradead.org>,
	<juri.lelli@redhat.com>, <vincent.guittot@linaro.org>,
	<dietmar.eggemann@arm.com>, <rostedt@goodmis.org>, <bsegall@google.com>,
	<mgorman@suse.de>, <vschneid@redhat.com>, <kprateek.nayak@amd.com>,
	<paul@paul-moore.com>, <jmorris@namei.org>, <shuah@kernel.org>,
	<oleg@redhat.com>, <brauner@kernel.org>, <alexjlzheng@tencent.com>,
	<jannh@google.com>, <jaime.saguillo@gmail.com>, <elver@google.com>,
	<blbllhy@gmail.com>, <bvanassche@acm.org>, <pjw@kernel.org>,
	<broonie@kernel.org>, <debug@rivosinc.com>, <tglx@kernel.org>,
	<aleksey.oladko@virtuozzo.com>, <linux-kernel@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>, <morgan@kernel.org>
CC: <ruanjinjie@huawei.com>
Subject: [RFC PATCH v2 0/3] security: Add PR_CAPBSET_DROP_MASK
Date: Tue, 29 Sep 2026 21:01:57 +0800
Message-ID: <20260929130200.1638343-1-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemk200008.china.huawei.com (7.202.194.74)
X-Rspam-User: 
X-Stat-Signature: 4jq54twccu3pfp3dd3ci1tbyapiyzt3x
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 33F8A20007
X-HE-Tag: 1790686929-288541
X-HE-Meta: U2FsdGVkX1/f+CXvOxQfosaTO630mqEaueHONKhN3PvlMCH8KrNzJHYb615/s+yw5qUtdL82SEgY8WiTklhU342ZNNzghTMGmgYDfVDMvmDoymUneacqe2DC6JVBqtqsHaOFAZBi0uMZz9qy/1LgNc+CE0+AAy+Bls536Sv6JczJ/Jg78YyVO4UfP/62mWfqwlC6Ol02EX0sekihH/zQY/QL95UamYH9YHz1sGJBuf5c6yiLy2kTVOKX4bC/BNYUWbJZebUE+vQkVdFdgQE37o2cqWsvnn/cJDPzka5pN065gsXoDfs15vMLMjde0q1vjRu3cfmj0iJSZxntHf1LgJAQxeV7B3nZWtRJrqOKoVN48dvzZaw3V0/ZjnY6NtQazl4Az98iI9hrfaZIlOSUVX3MgRX96Xw4weEMym8kEFBW00BMFKlY8f/1a6HL2OnRu5KyQLqJjtao+P5CM/D4h36uDy2ftsMk53qVaFHlyP1XUovOM40gSsVPKip0i/z9E3/NzSNRWpHUxChPxfbdJkx8EhINKCVkbIuOtmctrPVA0sV54nvoBYfgRfwVAYpBcQTTzhRQJ5YcvwZKM3FIfK7u5oS7pWNNA7AQB5UlR4gNZmkPi7NaQ8Hx97wxF4cWY9SqgCbYApV4ZIlBBOTcEAAzWYcRqzkBGGNrWGYwqnNEkWxNqwMU2A7WltF07/ZUycXD4M1GMlmq2q4m7jWohmTi4c1oMOQN5bsGD0g2UZxVuXgW9eOCohLp0Qb78Xadg7qxAbxMnAEahoUdH7fqhnAOzPNUk/i1wMHzoJgNVtqL3Dfh+Up7DEtfrYAX2sVU0ErQ1A/blFhLJj0iwoAUNe5Jjvl6NQlh5MEAT7DxnHfhIOH7HUFpX6oHk4KeaxBL6TVWVTbG81PL6O+K0EBceS6mIhRPatSbYnelvCdkKYBTeFGK+jWa8Ko2mJHN+IrABBzWwohddgfrICzoCVH
 mmEzx3Ck
 er6mKjP2FSM/nDt/RwqQxk+AAAIy54O4S9ACPMq+sIsXgo/JLMVoNoyk/2mErMyBCbQi16MPhVyB3NDDSB1EiFCuqbM56552V5NyzAp9nUNVP9eIiABYJKnamY9k+2/Ip6YunSgjjBi7H5jgbLHv4ZK5k6oqcyRrVdsJ8xQ7ghIQjetchOmIppRzGLlMUvYWNKx55BYCb4ATSwQo/Vewnu6uwuDc+M1iOTlD8YA2eWi8sCjdeKl8LgiKcS6cpz3Y3l/q/bH9mZvfGQp3o4uzg7BMUmjOcQ6YPd9CcWm/AxMyWg9pT2jm/rzL11DfpeZED3bWdzt3FGVM3I4+uXqX8n6zmh00K6zoXI5gk8K984JnST9UdOqmbF0qc95sLT2soUri+hSQnNst8ZOaBgRRNQwE+QsgkOXmbSEs78N+SoP59zl6SKeCw8qzfURldWhm6Rh4bI4//CxG4mKkdjnn5Cs3mcrpB3vkOQbc/ngU49rkvSUeVBZJb9rLlWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PR_CAPBSET_DROP only affects the calling thread, so dropping capabilities
for a whole process means one call per capability per thread.  For a
long-lived, multi-threaded process such as gVisor's sentry this is
stop-the-world signal delivery and costs milliseconds per sandbox on a
many-core host.

This series adds PR_CAPBSET_DROP_MASK, which removes a 64-bit mask of
capabilities from the whole thread group in a single call.  The drop is
recorded per thread group and folded into the bounding set wherever it
gates gaining a capability, so already-running, concurrently-created and
later-created threads -- as well as children forked by a sibling -- all
observe it.

Trimming 41 capabilities in an arm64 KVM guest goes from ~8.5-23.6ms with
the per-thread loop to ~11-14us, independent of the thread count.

Changes in RFC v2:
- Solve concurrently clone and concurrently drop mask problem.
- Solove sashiko problems in [1].
- Link to RFC v1: https://lore.kernel.org/all/20260922095816.1191799-1-ruanjinjie@huawei.com/
[1] https://sashiko.dev/#/patchset/20260922095816.1191799-1-ruanjinjie%40huawei.com

Jinjie Ruan (3):
  capability: Move mk_kernel_cap() to header
  security: Add PR_CAPBSET_DROP_MASK for process-wide bounding-set drops
  selftests: prctl: add process-wide bounding-set drop tests

 fs/proc/array.c                               |   3 +-
 include/linux/capability.h                    |  10 +
 include/linux/sched/signal.h                  |   8 +
 include/uapi/linux/prctl.h                    |   1 +
 kernel/capability.c                           |   5 -
 kernel/fork.c                                 |   1 +
 security/commoncap.c                          |  91 ++-
 tools/testing/selftests/prctl/Makefile        |  12 +-
 .../selftests/prctl/cap-bset-drop-test.c      | 641 ++++++++++++++++++
 9 files changed, 759 insertions(+), 13 deletions(-)
 create mode 100644 tools/testing/selftests/prctl/cap-bset-drop-test.c

-- 
2.34.1


