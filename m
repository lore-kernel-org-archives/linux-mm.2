Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81C1BE67482
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 23:29:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22AB86B0089; Sun, 21 Dec 2025 18:29:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F7C66B0098; Sun, 21 Dec 2025 18:29:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00A146B0088; Sun, 21 Dec 2025 18:29:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C1DBE6B0088
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 18:29:48 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4E770140628
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 23:29:48 +0000 (UTC)
X-FDA: 84245072856.28.26DE612
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf04.hostedemail.com (Postfix) with ESMTP id CB5444000C
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 23:29:46 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b="khpwm/PN";
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf04.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766359786; a=rsa-sha256;
	cv=none;
	b=LBtXbtXELm7zGvub+WuHFCMdfXREQTB06RIAF8FMKji+P1/IJoNxYt2WZ6Oo7XPTSNT2M7
	2UCIySk08JVclECBHWHhH00aXmFbuj7vG5eEwqlQGGB7u9WzL+21a/r4h4BuKZHvvEiIVQ
	4tpWj6+EKa8UuFMJorRDqIf2f53VHLQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b="khpwm/PN";
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf04.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766359786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=VtYWVH4kEDnjh9odMMaR+dSfiUF4Ruk5wQ7WUcoeW7I=;
	b=VZ1xqBilAmXy5nzGL1ENYSUiV/IBu5s3mKyeIrkTtQSdb6OB8MAJ56/mVIHC1NflbpEsOZ
	AM0UXnH7F2FxJvfizYuibZ1Y4R/wO1Xsc650qD4+43q7gCcvOaA10d1vcTdGcIAOiQdsT+
	GVDZsCoSlSPUXyCT/Z5xcufwgYCrqYo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1766359786;
	bh=VtYWVH4kEDnjh9odMMaR+dSfiUF4Ruk5wQ7WUcoeW7I=;
	h=From:To:Cc:Subject:Date:From;
	b=khpwm/PNwhL6sf+XrYApDAWMut8RQoEfVgea31V1L3B1jZO7iMXhepiwEtS4e49xd
	 4nJ34QCjGmPCUix4SkrAGeMDo3a331aXLfI5GMTpItF8ywOYJlABGW0zOb1yt8OqpM
	 eqkItYKxQp1d6axCdGx6RNpnMIhEr3I3yN7jMxfjEdQJO4b7YAfTMuH5zX3ALgpULd
	 1TiadjFlxRj6en8/ClDUef4FT1ikNrDDAK4L4rxKJaadYBbKMhf+wqgGz24Bu7Tq82
	 92/dWvdRd0RY7Ud6puy6hPzYiz5eD6lwsNwPa4WRrpLh8uGkAeucHKbeQ072cmJ8d+
	 uGc2UNEF5bfBw==
Received: from thinkos.internal.efficios.com (unknown [IPv6:2606:6d00:100:4000:6450:b8a1:16cf:5ecf])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4dZHYP6sxXzddl;
	Sun, 21 Dec 2025 18:29:45 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mark Brown <broonie@kernel.org>,
	linux-mm@kvack.org
Subject: [PATCH v1 0/5] MM_CID and HPCC mm_struct static init fixes
Date: Sun, 21 Dec 2025 18:29:21 -0500
Message-Id: <20251221232926.450602-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CB5444000C
X-Rspamd-Server: rspam10
X-Stat-Signature: qdj37zotw9oxpdog39zf6otsao9tspkg
X-HE-Tag: 1766359786-337068
X-HE-Meta: U2FsdGVkX1+or3JZXD8WNHAp5tYC6QJPX1ydDyrB7BHmncTYMl/kDgnx706MVuuUOWQnJEM5PFHVPvVxmkQ4D0CFOXF1HT/jXjN8It22F1mFXmL/MqzEDtrLxcnDRu9hRLHH5nX1aKuxeAS3uvXRZQuQhbI1y7gY6ECDn9MqA4JyzzyU2TgtMFZ9Bovee+jbpxTNPgozcM4AXPBxEEEtI4n2karLKFQN6FoixUN9Ssc2r7dSdDUfjv/MVOAgZUG2tf7EQxuAq3gUxUUzXpfqLoA/6HifmQ8GM9bWVXWJmuiMOgAI/oEAY1upVEgKfvzL9ePnukQiFh5/jv2NOokD4O++WFCNHZbmHgU+4hocUulaxVRf4FY5tjM5rIVO/c+zPkaexsSCawFbwYghQCXAdoUJ0cWDq1KF8bsZVbsBWe2mDpUJ5n8Alhi3Y2ZxJyiVihWZFLOfRnkhmI2QyM6UxjXhbYfvNygQ2GdCWDVro19xuXtIu4oaaGC9FjotBHdDxrMoU/9LmQIzri1VSOxKAvI1obZjZVnZZIfAD80Lf66c6vHPKEiBLV8NKlkuFzXncbiDUYoyZuBTULYF2ZlW8v6fNJq0XG1FwzkqD4GuMB00DLBIk05tDLMxGIKYtIuu20Z6nBXQ/UoRY/sNvJMoQ5Rb2aZCND2xLvmhbEVoQNsjW5jopnnv4Nd8uiBUU+qakkr4mv/6IekBNrNWoCF9SQEm21zjFkorjPyDhdJzUD78sCLsFYAm44GkVP603g5SiqxuRNOzyEfZMt5+5/ozCF+a2hcv2j9pFTi/aZg/clpV6it22p/VoukSYTyOc6OYABF3TBhQ1egSbNFctFvXxk2PPlMES1l6ydSYNJHWFeQgM4qU+NLAWH4ybL2LvqYkxopP9qDmO37IYzv9O2BUfCmWtlxq/+n327WEhxhn//+BSSRSWAwZi3lXSRQxDj36VaQN4RE5fsFSLaQUXbc
 X8VRKng7
 eArpXQxuGhH6YnzomqV1P22nsR7xLdNYIGMcSVjmyOJYJGpOYJcwpLPFw+KM+PUUELwslMY/nao5RYzvzHFJBec9bpJw3ljFjbOQCBCKTG8R0R8nIbtcd7mGDLymdMqjEPQsguV9o6zjXSHDMCGmRxDKIPUbZ6m3mTEYBVJZTOC0b9enMgcA7s0MokfiLXgIrpTmXtRlS6po3uWzemFZvfHChS7aA3VG65eN/U2PJbNzExtW/rfEtA0y4m8IZblZEiDAWMqblT5gMum2vDRa3sNkiKOXyPLyWFjRh24Hm++bYNU6mq+cNzrdFxKhvc0ogdjatEoGURX5LjzXIuwabyQ68VK35t+zxfpugflKrrhz1G4DZAH7SvM3Si6lPUlzcea7I2A/tDrY/WviJ6NxbkidQDFRoENjlEtCwb2GgPvsyiEeVcQKfA7QeGNAp5mSp2nV22uvHd81AqWhnWIWSVHERzk1LuLRNxsdnpP74eysA+0QhakGy6pGsNasAUY1+bcKp9N3gl9Zw78k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

Mark Brown reported a regression [1] on linux next due to the
hierarchical percpu counters (HPCC). You mentioned they were only in
mm-new (and therefore not pulled into -next) [2], but it looks like they
got more exposure that we expected. :)

This bug hunting got me to fix static initialization issues in both
MM_CID (for upstream) and HPCC (mm-new). Mark tested my series and
confirmed that it fixes his issues.

Please consider the HPCC fixes for mm-new, and the MM_CID fixes for
upstream.

This series is based on mm-new
commit 287373d0b6ee ("selftests/mm: fix comment for check_test_requirements")

Thanks,

Mathieu

Link: https://lore.kernel.org/lkml/c8acf650-ef96-4449-ba85-557dedba0ffc@sirena.org.uk/ # [1]
Link: https://lore.kernel.org/lkml/20251122111336.56b060c86ff6ba41fe76bfd4@linux-foundation.org/ [2]
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-mm@kvack.org

Mathieu Desnoyers (5):
  mm: Add missing static initializer for init_mm::mm_cid.lock
  mm: Rename cpu_bitmap field to flexible_array
  mm: Take into account mm_cid size for mm_struct static definitions
  mm: Take into account hierarchical percpu tree items for static
    mm_struct definitions
  tsacct: Skip all kernel threads

 drivers/firmware/efi/efi.c          |  2 +-
 include/linux/mm.h                  |  2 +-
 include/linux/mm_types.h            | 18 +++++++---
 include/linux/percpu_counter_tree.h | 51 +++++++++++++++++++++++++++++
 kernel/tsacct.c                     |  2 +-
 mm/init-mm.c                        |  5 ++-
 6 files changed, 71 insertions(+), 9 deletions(-)

-- 
2.39.5

