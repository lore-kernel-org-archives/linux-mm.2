Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4730E66886
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 23:36:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3134B6B008A; Sun, 21 Dec 2025 18:36:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C0B56B0093; Sun, 21 Dec 2025 18:36:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CC686B0098; Sun, 21 Dec 2025 18:36:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 09E406B008A
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 18:36:42 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BCD6213BF15
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 23:36:41 +0000 (UTC)
X-FDA: 84245090202.21.FD44CB6
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0B0CAA0007
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 23:36:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=U5REKOKQ;
	spf=pass (imf15.hostedemail.com: domain of 3hoRIaQgKCAMelqjmldrjrrjoh.frpolqx0-ppnydfn.ruj@flex--bingjiao.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3hoRIaQgKCAMelqjmldrjrrjoh.frpolqx0-ppnydfn.ruj@flex--bingjiao.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766360200; a=rsa-sha256;
	cv=none;
	b=zyhFBjWY2Dus12djcQCUTsWjADcUXjCXzwhLZzo5YuUxVa2QcwcC7ncFcRGU9Sql7pYyoV
	xalY9waycWA6BTdGPZIKkJhojijqkDzhn+d662N37JGM10FqyREBYqkaBkQSunc6CwpHur
	J8JkN0QVEuXcI+Zy2brR8AA/FDlgZUQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=U5REKOKQ;
	spf=pass (imf15.hostedemail.com: domain of 3hoRIaQgKCAMelqjmldrjrrjoh.frpolqx0-ppnydfn.ruj@flex--bingjiao.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3hoRIaQgKCAMelqjmldrjrrjoh.frpolqx0-ppnydfn.ruj@flex--bingjiao.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766360200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b/ZL/U7sLuVrIZUvVuD6ozi7k6Z6Ly5Yuo8mcDrUYr4=;
	b=RK8ZxdBBbsgGQfYyUMFPJm93MWALTM3s4l64B+gT+KrgoKKg8JYeWUIZVo2KgLDe8Tfr2U
	6TJa8OdxLPuRRIWorpa0eO8Jynh9I8oPvCBA5yT/SKGSK+VjvLjU5AnsGoLNZcqg+ALDWW
	ztHPBZX19X5uifNMbA/LGPW8mQlPN0Y=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34ab8693a2cso9377337a91.0
        for <linux-mm@kvack.org>; Sun, 21 Dec 2025 15:36:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766360199; x=1766964999; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=b/ZL/U7sLuVrIZUvVuD6ozi7k6Z6Ly5Yuo8mcDrUYr4=;
        b=U5REKOKQGdMB8qHww/nZByR6O+ai9jxy3KVjnkPJTwLZvqBFp3hXTI4X6wmK3E9eEQ
         VW/s1roQvdcQfMeX4YUsHt04b2wG8PoW5IM1jFNjhImnWW/9iowi48bAOqd0eRFaaMFG
         m5xhGbslWBMO1MrLZxgsBGGPVwsxoH0Dq6PQNs6T/7pdqoKjZrrDvjr1NJvPItcM4Hf8
         TIwIZi8GqplqeNrk8NPGlryamFeNzbHiQj0hiS4n7UuuCxbMggtubebBc1MOnMdaxAe0
         IOZMTrScEDuHh96iDM8kFni7bW2UJNCYQ9iejOMu0/Y17RREE5ZAovhSCMA1NpJuDmGO
         hKXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766360199; x=1766964999;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b/ZL/U7sLuVrIZUvVuD6ozi7k6Z6Ly5Yuo8mcDrUYr4=;
        b=sRsM2M56vVqa5ZOzTkG2I86HQVa+2Ie+5RvhZW2iWoa9yg/pGtdJpYbChJgEhrQEAr
         /rf1Iac3YaIcCEE5692d6CIKT0ZjdBDv/ssOAVuM64PLxYEcG12S6D4ofTJBQQjSzxED
         GiQ0axvtdS65yDh83IFytlfze5DESzjn+UDk8my8q9DqKHqGNo/vLzJHCQEv67qOw7Kr
         Cu4o0S6n4CDwtXBTbcYPgxUVOZThmzykhcfVEZ2d9cd2zZ2yya81Tu9QAFwMWYdyKht1
         PD0cPLJ6/IcdLIM25pNMw97gVUr1fITp9PasWbM9Kt4Hr6b3kEGAYKcGd0dUFM4f6vtg
         8d4w==
X-Gm-Message-State: AOJu0Yz8vTMW8orqgWsdmzQv0fc9+VRmgBDmqP14t20C+QhLidHwEM/H
	Yx55o5tkotf9ebuoxsfG65OcfPZpu6ZDIW6LJRjoNK5y0eKaLOtqUsEKhzxM4K/DIdQA1NFCShZ
	5OW7r0wRKZX4V/pFZcvrKr81OgjNDzMe/rUNUh23D1ZKPgKovwLcWZ3LfAj9Qd5Oz1d7UrYSfJe
	Oi1yuA7EYFBYDU/v9QIa6fInRtcs6ihSOEQ6VUqlGp6A==
X-Google-Smtp-Source: AGHT+IFNZ+7Qz1Q6P/PmGGIYsIi2zzA+vh1m/QOlksmFymCij8EksYbFVSEHCVudpiyuUX8ENcyEAn/pbCN7kQ==
X-Received: from dlkk2.prod.google.com ([2002:a05:7022:6082:b0:121:7c06:d4b5])
 (user=bingjiao job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:248c:b0:11b:3742:1257 with SMTP id a92af1059eb24-121722f63fdmr13386671c88.34.1766360198470;
 Sun, 21 Dec 2025 15:36:38 -0800 (PST)
Date: Sun, 21 Dec 2025 23:36:33 +0000
In-Reply-To: <20251220061022.2726028-1-bingjiao@google.com>
Mime-Version: 1.0
References: <20251220061022.2726028-1-bingjiao@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251221233635.3761887-1-bingjiao@google.com>
Subject: [PATCH v2 0/2] fix demotion targets checks in reclaim/demotion
From: Bing Jiao <bingjiao@google.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	akpm@linux-foundation.org, gourry@gourry.net, longman@redhat.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, tj@kernel.org, 
	mkoutny@suse.com, david@kernel.org, zhengqi.arch@bytedance.com, 
	lorenzo.stoakes@oracle.com, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, cgroups@vger.kernel.org, Bing Jiao <bingjiao@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 0B0CAA0007
X-Rspamd-Server: rspam04
X-Stat-Signature: h8y9cf3kojchkh19sb1jhpm7m1qccs1e
X-HE-Tag: 1766360199-773623
X-HE-Meta: U2FsdGVkX189yDX2g13swoE+gqEuU4qLcvcP+0WdWMSqBqKjYUjV3/TsWR0zlPYwOCLCHVq0ZJVKskh192jMwRu4uUEfEcx0jKiyDr5IOxsbGEbVwbiHPRo5TCGHPyenjM4XCNqOis9ZwrHREt2m2kJQGzd6IvF9+Zf+4N/E13QmXbDTBlUosmk1sxFH2sdn5JXeQIusUh1K3AEAMm1Avfn8Feay/9qoLY6+9PRzAk6BbLhgWMpaNFyP8eBfPYwIgVfz7X15y6xXGZ0wUwOq91CVVzQLZg4JEg6J/HGhK/D+6gJ4KfacJcdQhlHnkeIp/PGXeU7Bz6hPgQ7dwzFKjzxO/KRidspdqryvW887H8mA3hpXS+T35fpRXwEcVN2E94knIn9Biha9Nq7Nsqi2dkLwSOJZ6YkUFo8y2fRI4q3GZBcpErnMnGcMEMB0sqHFbzLmKJJtPrvDLHJjJEe60eZzey/qxzRVdvsx7+XOD4MMrjjdQEnRW0D53RSu+zdKR1zBpleFD8hHRZ+2SR/HEG5ce0W/JNDrX0w/umuVznN9GawB8qMFZQKq8bCcDHIYm1SvH8BynMpvXDcelitUAYLzPLN8pIPCOYtSvLcnFYXwyb9WNH8P2qkh0KZ7X/uuek3iVuP53Szlew65NaBNFlfBU9aT5iwGsFKO+jdZyUW2rPEQSMNKG7ev7xGQ0QaAQtSsdARTkm7zq7dGim/ffA2or58/Ak+0FlNHo1KqORJpBnH3Vgrg9BCQhebT8vHUBjkM/Q2I3N9N+EVTOv30vCIXeWEjGB7SbCPo8eEqe93DV6ZbXaYIfBTQaxgvUwdskTLXdJbSQ2fLuq2dojWYSa56COx80JzgUvHx4nphLJRPeV/+tyf9upmgNbRnG1jGL6Y4/ThAlgNP338IlwM1dsErz4AqEFKN24kBN6EQq3fAk/CF1ozOk8xOtOF2oZH1Yp70INGa+k8Px6YwXaG
 plljx/CV
 62qqvkrkKN/dFVpky+R1q8TMQr9SIg6WQvO45Q6MWVoD51tkmflNUF+ylBD+WLp8vDXg8i97Dmbm+U8YoZVF95lZNTHPhwCfzyAGI4vq658DcBsS7seynJ0023qGq+ymOxvMBGIXUGxgIjOGHyisUs0tK1RLfyYFb7eccyjvV1d20Zy1CT8Ww5UqusSS6XtlRgI5Z8p5CoIPagpMvvSFAWPDxmMyQ4whPRdqOY33YtapHFm/VT3s/6tvaHt6Iz4zuD/yrzNuU0xywZixiCoXdvXG0N69gdWLOG9X82NnvqKf2QnsM9vM0FeKCwa2Ql+eqinAVD05u1JssyA6HAa8pBWUOZYI8BDHm3/xv82uRF+GX74UvT2RQFp35ahwMTcrUjT6WJpgF+3+FC0sNJSGtJAxLhTHvz30PvF8zXo2pQ6+IhhVr+ixDo9hp0Ro8ZzMI0NCnisWd1t3MTAP4cgXszNEs/NqlZ4m1bkz0UZkhik/OZXy25pHFp13CWbu6k5fCKV58HQ7bKPNWdxuS3jZMvquBW030TQHIRyYc8QJLhjdfNkjTiqER+tfo/DkFvGbjyoGQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series addresses two issues in demote_folio_list()
and can_demote() in reclaim/demotion.

Commit 7d709f49babc ("vmscan,cgroup: apply mems_effective to reclaim")
introduces the cpuset.mems_effective check and applies it to
can_demote(). However:

  1. It does not apply this check in demote_folio_list(), which leads
     to situations where pages are demoted to nodes that are
     explicitly excluded from the task's cpuset.mems.

  2. It checks only the nodes in the immediate next demotion hierarchy
     and does not check all allowed demotion targets in can_demote().
     This can cause pages to never be demoted if the nodes in the next
     demotion hierarchy are not set in mems_effective.

To address these bugs, implement a new function
mem_cgroup_filter_mems_allowed() to filter out nodes that are not
set in mems_effective, and update demote_folio_list() and can_demote()
accordingly.

Reproduct Bug 1:
  Assume a system with 4 nodes, where nodes 0-1 are top-tier and
  nodes 2-3 are far-tier memory. All nodes have equal capacity.

  Test script to reproduct:
    echo 1 > /sys/kernel/mm/numa/demotion_enabled
    mkdir /sys/fs/cgroup/test
    echo +cpuset > /sys/fs/cgroup/cgroup.subtree_control
    echo "0-2" > /sys/fs/cgroup/test/cpuset.mems
    echo $$ > /sys/fs/cgroup/test/cgroup.procs
    swapoff -a
    # Expectation: Should respect node 0-2 limit.
    # Observation: Node 3 shows significant allocation (MemFree drops)
    stress-ng --oomable --vm 1 --vm-bytes 150% --mbind 0,1

Reproduct Bug 2:
  Assume a system with 6 nodes, where nodes 0-2 are top-tier,
  node 3 is far-tier node, and nodes 4-5 are the farthest-tier nodes.
  All nodes have equal capacity.

  Test script:
    echo 1 > /sys/kernel/mm/numa/demotion_enabled
    mkdir /sys/fs/cgroup/test
    echo +cpuset > /sys/fs/cgroup/cgroup.subtree_control
    echo "0-2,4-5" > /sys/fs/cgroup/test/cpuset.mems
    echo $$ > /sys/fs/cgroup/test/cgroup.procs
    swapoff -a
    # Expectation: Pages are demoted to Nodes 4-5
    # Observation: No pages are demoted before oom.
    stress-ng --oomable --vm 1 --vm-bytes 150% --mbind 0,1,2

Bing Jiao (2):
  mm/vmscan: respect mems_effective in demote_folio_list()
  mm/vmscan: check all allowed targets in can_demote()

 include/linux/cpuset.h     |  6 +++---
 include/linux/memcontrol.h |  6 +++---
 kernel/cgroup/cpuset.c     | 12 +++++-------
 mm/memcontrol.c            |  5 +++--
 mm/vmscan.c                | 27 ++++++++++++++++++---------
 5 files changed, 32 insertions(+), 24 deletions(-)

--
2.52.0.351.gbe84eed79e-goog


