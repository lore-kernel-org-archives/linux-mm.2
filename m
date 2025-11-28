Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FA90CFD2F6
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 02:54:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA10F6B0022; Thu, 27 Nov 2025 21:54:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D29696B0011; Thu, 27 Nov 2025 21:54:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCB2E6B0022; Thu, 27 Nov 2025 21:54:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A2D4E6B0011
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 21:54:26 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 49C3C1602FB
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 02:54:26 +0000 (UTC)
X-FDA: 84158497332.20.CE17E0E
Received: from mta21.hihonor.com (mta21.hihonor.com [81.70.160.142])
	by imf25.hostedemail.com (Postfix) with ESMTP id E9B5FA001B
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 02:54:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf25.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=wangzicheng@honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764298464; a=rsa-sha256;
	cv=none;
	b=wi8RS1x5zhOMzaoBZbyZt2I2Ven1Wl10/4XBoq/sMi7Qgk4UyFaecOjPNkt99VVA3CDv8f
	i2cw7bDV6TMV3CuF0WC9pMA9FgtZWNSTH+aoyQ8kmfNJutkEK+cVn72HnqEwAB5cpiA22n
	v3eVFf16d8lsPfV8MCNFVLYsGMGG+iA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf25.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=wangzicheng@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764298464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=wsjNgFug/UIKFycNB6GOgIpj6egr0KvUxqRnl6lQhQ0=;
	b=ZeSV7eibSQ3BQLTP7zo2NggJx/0/fl/dpX0YfRoCBY0U1iqPAIpaxLxnOhjOULJET0wqwe
	21lzfq9fsHB2bt5CBfpyS+dac1EFF96CqO2yWlg6hhsGMNzFkXa0ZbjyyqCX9ViTRsLjN1
	f9BUXvTM4JfUAbKFJ+XrgjeDyBpcoDg=
Received: from w002.hihonor.com (unknown [10.68.28.120])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4dHdBx6bHdzYmZ9v;
	Fri, 28 Nov 2025 10:52:57 +0800 (CST)
Received: from localhost.localdomain (10.144.5.36) by w002.hihonor.com
 (10.68.28.120) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 28 Nov
 2025 10:54:19 +0800
From: Zicheng Wang <wangzicheng@honor.com>
To: <akpm@linux-foundation.org>, <hannes@cmpxchg.org>, <david@redhat.com>,
	<axelrasmussen@google.com>, <yuanchu@google.com>
CC: <mhocko@kernel.org>, <zhengqi.arch@bytedance.com>,
	<shakeel.butt@linux.dev>, <lorenzo.stoakes@oracle.com>, <weixugc@google.com>,
	<Liam.Howlett@oracle.com>, <vbabka@suse.cz>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <corbet@lwn.net>,
	<linux-mm@kvack.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Zicheng Wang <wangzicheng@honor.com>
Subject: [PATCH 0/3] mm/lru_gen: move lru_gen control interface from debugfs to procfs
Date: Fri, 28 Nov 2025 10:53:12 +0800
Message-ID: <20251128025315.3520689-1-wangzicheng@honor.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.144.5.36]
X-ClientProxiedBy: w012.hihonor.com (10.68.27.189) To w002.hihonor.com
 (10.68.28.120)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E9B5FA001B
X-Stat-Signature: jq35emu3znxpgtxdis5wi34bqh3g6g4k
X-Rspam-User: 
X-HE-Tag: 1764298463-911341
X-HE-Meta: U2FsdGVkX1+tTOcwNYP/i6io+DnA1Nc3Lng2m+0OanesUYv0T9dgrVKv696OgyFwKLzqhAmKoCuAGiYA9yh14XOv3yLpQt+49FBSJ/Di/ZoIbVM+k1Fe8K2sBphhLDMR/F8xraZEFxLd1G73/ca6UDPPLG+DBxskeKmS7waBJgpqREYR9L3ihUB49+x5d8wdnlpQGq+Tx9PoeFl+fBz2mQNd+/jvWTyEJbYNOP9NtTkAalcdbuLfj+y2Fze/FkVp/YTK8+YtP9H9JRxgYcet6tvOIjEPZ+SryI7PYt8sLUfFxs7sKCcGYOVb/0NTiU5angMbM3Cvj7YmiRwZAQDR6hasfoTvv2YcSN3Rzk4eouKIO/BZKlVVZq2S7SK2Rw9wGx10JyR8QETjLYV+zECjr5QolsQZyb8lXtsBAoXiaIhykkiv6AKD1/2z2zf8X+3AtLRqlFa77YvuyLJfJTr4Vm5NsswwY4XxIwlDq1i9sk1M171dTBaYCcCgfu2J4McFlkByD3rktkTkEzqOVW9+o+bhpEsjd/p6xprw2H/qKl2yqIJqxUDaEp0xN7WVe51YoVBy0/GZA2slDz5Wz3xD/1BsgcajScyhA/FAYlq4XtN+9o2IgD1LsJEcIdXukNyW5T/veRIUfOmAZavafZzKgLa3FgAjmFeFdh/9pHoTzh4PxByQktpCH4SLMMgWVsjj4FrxzG6ONIQ238u4DCh0jtDdDEGWVSLuWWjqdj8ltbiWKYI2BAAGz2cgGVWiQs63Im3zd7u4VHYx79FlHmfY1x+iwCttJokVzO8tfVy+GfW27E/6nvApJMi5xSNbr+zlXbUGUruUUEAm0lJ80N5rcUipBPhYXqGtgtkDwd5ATu2l8PKJEnzkCchkt+HZWKEvlkCnYUxog0R2uQHtu7OMiFeXEtyJnhYoCgGm+o9R0s5Vx8PM4T0EuFl76ZckUD+Ogg47Ir9ioJDA8mrApcQ
 es6Va5cX
 uOOA3lR6I+4gVwmO2KcRqE2FvcwbjZcNjMsuP2VW39DvdXFPi0HSZsMX8dYGGkkIBOrLeKHntl/Q0MNOnSuDXzMz4VeZ1goa/uzpNOVRvQOvhw3XLuDYylqmrT4YFAEJlX8azY8/89pygjCT3HUkWKC24Jh7tXK84k0a8ge28oRLA+dMg1xXveE/d0pTrfzCA7w2/8cJ5SZJIQRIBZaVlT4MGr1zj2gZ6Gi9F5JcNYfXEKhKUuYne7+1qIqAJlfrfidDQdMaTnl+g0MFi9C6rInQYc+xAIdKc63YGHQitEKPkxiU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patchset moves the lru_gen control interface from debugfs to procfs.
Exposing the interface enables the capabilities for *commercial products*
such as Android to proactive aging and reclaim.

Two main reasons:
1. The MGLRU reaches the stage where its control interface can be
consideres product-ready, not just for experiments or debugging.
In specific scenarios, proactive aging with reclaim can improve
overall system performance.
2. Commercial products like Android prohibit mounting debugfs for
security reasons (selinux neverallow). Without moving the interface
to procfs, Android cannot utilize lru_gen.

Case study:
A widely observed issue on Android is that after application launch,
the oldest anon generation often becomes empty, and file pages
are over-reclaimed.

In Android, each application owns its own memcg. When an app is swiped
away seconds or minutes after (cold) launch, it will be frozen and
part of its memory is proactively reclaimed.
At this time, both file pages and anonymous pages are temporarily unused,
while the system load is also typically low, making it an ideal time to
prefer reclaiming anon pages while retaining file cache.

Keeping more file cache benefits the system in multiple ways:
1. The device can retain a larger page cache, reducing IO.
2. When memory is tight, evicting clean cache pages is fast.
2. Super-apps such as camera benefit from reducing the chance of
slow direct reclaim on the critical startup path.

Experiments:

- after cold launch
```
Kernel version v6.6
memcg    54 /apps/some_app
node     0
1     119804          0       85461
2     119804          0           5
3     119804     181719       18667
4       1752        392         244

Kernel version v6.12
memcg    84 /apps/some_app
node     0
1      38428          0       16424
2      38428      24307       14997
3      38428     126529       56452
4      37980         27           1
```

- proactive aging 2/3 times
```
Kernel version v6.6
memcg    54 /apps/some_app
 node     0
          3     172432     102532      103441
          4      54380      74803         854
          5      28892       6496         229
          6       1588         26           0  

Kernel version v6.12
memcg    84 /apps/some_app
 node     0
          3     819624      98726      166045
          4     819176      14849        1543
          5      40000      41328        7633
          6        960          0           0     
```

In continuous app-launch scenarios (e.g., After boot, retail demo
loops, tech review testing), our measurements show: v6.6
1. Available memory improves by 400–800 MB.
2. Direct reclaim frequency and latency drop by more than 24%.
3. memavailable/cached levels aligns with traditional LRU.

Summary of average available memory (MB):
mglru without proactive aging: 6060
mglru with proactive aging test1~3: 6988/6432/6837
traditional LRU: 6982

Camera direct reclaim (10-run average):
mglru without aging: 1050 events / 460 ms
mglru with aging: 789 events / 316 ms
(25% fewer events, 31% lower latency)


Signed-off-by: Zicheng Wang <wangzicheng@honor.com>

 Documentation/admin-guide/mm/multigen_lru.rst | 19 ++++++++++
 mm/Kconfig                                    | 10 +++++
 mm/vmscan.c                                   | 37 ++++++++++++++++++-
 3 files changed, 64 insertions(+), 2 deletions(-)

-- 
2.25.1


