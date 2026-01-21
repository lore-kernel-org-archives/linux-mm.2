Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6F4DC44525
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 12:40:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 187526B0093; Wed, 21 Jan 2026 07:40:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 131BF6B0095; Wed, 21 Jan 2026 07:40:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 054A16B0096; Wed, 21 Jan 2026 07:40:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E8D766B0093
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 07:40:36 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8BE5214014C
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 12:40:36 +0000 (UTC)
X-FDA: 84355929672.21.27733E7
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf03.hostedemail.com (Postfix) with ESMTP id B8A1320006
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 12:40:34 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vYegVE80;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768999234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P/QIycmg/Rp660OZ1P92MK5kFHPJosNCmQKo3uxOY+w=;
	b=Hv+AUre4B/lGMnvWro2h6T4FyPiKJv8Ghg820yciC59JdAu3Nk1ZTdbQmP19mQzn7msWns
	WZaU5KesX5PpbDqDHFe7g9fl33zy7zXnRlozsN0VTbpMWFqXQDSTsC+Vl78R0efyUbvXtV
	vc2S3gcnzisV4RKy9cZHDWafaOoJ8F0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768999234; a=rsa-sha256;
	cv=none;
	b=WWAo+NzTu+Nifj8etW8nkg3eYSWNRwO17VZ3UwYYaQ1jc0tbnEW/c+Ja6fGeV5XLMFAf78
	EffD4Sis9J/uJismW6qFDwPd+Adm4HCcXTjZ9GppygenSRYvYtCT3SyVpUeCIJ1TFJnxzE
	Bl70qVGajaZLima8MYTglIcdecTuwLg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vYegVE80;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768999233;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P/QIycmg/Rp660OZ1P92MK5kFHPJosNCmQKo3uxOY+w=;
	b=vYegVE80q2P99aKNiXmOPWPUQvsIvoabN/PTHj4Kum0jSGe4HmwxKwWaVgP+XTxQLU9Vc+
	xDL3GVtpm/ae90vlif6u21ElxIQ6gqwqm9oy1I8eyEFB4UGCb5zfTqhGJgQigxRYLi34D1
	Ueac4zqmHjZtQ1v/IRwv8W4qr+aZYv4=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-mm@kvack.org
Cc: Jiayuan Chen <jiayuan.chen@shopee.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 3/3] docs/cgroup: document memory.lru_gen interface
Date: Wed, 21 Jan 2026 20:39:49 +0800
Message-ID: <20260121123955.84806-4-jiayuan.chen@linux.dev>
In-Reply-To: <20260121123955.84806-1-jiayuan.chen@linux.dev>
References: <20260121123955.84806-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: uksuwaraff1puy1958gaszgqq89gkwro
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B8A1320006
X-Rspam-User: 
X-HE-Tag: 1768999234-197746
X-HE-Meta: U2FsdGVkX1/w6aaTBCOEvFfHcumoEbMA4sA8+dSmfEUvAywabixjLTdosrKQNyUd1GY7DLa8gEYxLBHNriidaxReE6TQaGvSlAsK9/GyQ5tsFxmcqJo7BJJDdM3W13wYDyNU9j/lvxqhMUqRFQY93rC7oqGM/QS/xNPEqOkW6WLIlOJ0l/JbWfpcSaRvgL4HiFEm0jIYoaw/iROcvoLyd2lsyqgS1p7i6ftjFpTxSOppCzlruphgXxR+D4MfRTvD9n0xMw9z1pY3y6wSBR2OBe8vYT8Xf6U7Y7Fvs09EVG0hQp3r7nENjbw3eAm2pknSN93f4xjzC7t1eKUilsm0ELgBAsfe3vzOcnzqc/KmlDwWE17x6eP3/f7jdk4iXLUBabn2swDbRlb9WduEicT1xV4rv/bkdZH4wVS0drYCeyXuE3Nq2pQUw3y3elvB30XgtKhEjNizdHBAigaPasU/J4a1Bg1ik/FmaNe7N3NZUrhq9uMJPr1E4z7fZLOFH6A2TPd/lGcICo9bK9VsPk1tQat1VqmarlbQQ+TNGbrZZAKImCAJEh+IUrPIZh8lXGh8nifw2UWqunfALNn1iFi91ih3WN4NIwXU9NKauf4jruFk0czcSgFqtqtPb/1afy0H54mEeTB/nXYFpgHc9oZhohhl6vmVTPLQRrgjNbKwluD0WDZi2JJr4k8hhD4OLSgKGTrgEoCAqsVxFUj4dhIrjTDJVVHVhO5YleSCTjj17CXkqoKfReC+WeS8aUA8d9kQV1Rze+1QSWa58z2Y29lNHPodO+mpVTgGPxliWm6zwCTqc07nlW2o8faup8/RSYzeRryubz8MDg4WBMQ6QELTVdQmS9vjeaOwCqpY2xzTd+XQIgUfpgpq8oWGVHEVmZXwdtOjGVtkM1005RiSISXzTjEOMtrHQ1wj536njT8f4rDpsAeFRP2hLzIpRYb+xOm06654P2KxyR54tt8EMpQ
 IeMgI4pa
 ch8bpnqrgN6nmR0CYqRzhTNmqIt6vSISok0H7lfj+8p2Rkm2ienMnqGIz4RnoCOk9AzTIQEfwG5crMVb7wAu8j94f6JKE9BbLAouHRJx0NMrGRvBzoxGzJw5kr7txpMqWkprV+Ta1J1l5D36EH1Sys18RGIreznHBy3YB+NPRlUbJiCzA2no7niIgusj+pnRpmRtdjQpKX88lnDLZJ9Q5hpKQkp8YuGWQcAEfi4a70XL4ihLlt1JYo+UcBCNujWySVGuk6S3D9T4by4d88NLczmHds08ysqJXolrKyjjq/Zo3IA4HO11WFd9XuxEGWIUpFfD/cP8JgauZ4OxRlTAfY3e8fw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jiayuan Chen <jiayuan.chen@shopee.com>

Add documentation for the memory.lru_gen interface in cgroup v2.
For detailed information about MGLRU and the command format, refer
to the multi-gen LRU documentation.

Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 7f5b59d95fce..bb3ca7ffd600 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1426,6 +1426,23 @@ PAGE_SIZE multiple when read back.
 	This means that the networking layer will not adapt based on
 	reclaim induced by memory.reclaim.
 
+  memory.lru_gen
+	A read-write file that exists when CONFIG_LRU_GEN is enabled.
+
+	Reading this file displays the multi-gen LRU information for
+	this memcg, including generation numbers, page counts for
+	anonymous and file pages across all NUMA nodes.
+
+	Writing to this file allows performing aging or eviction
+	operations on this memcg. The format is::
+
+	  echo '<cmd> <node_id> <seq> [<swappiness> [<opt>]]' > memory.lru_gen
+
+	This interface provides the same functionality as the debugfs
+	lru_gen interface but operates directly on the cgroup without
+	requiring the memcg_id. For detailed documentation of the
+	command format and MGLRU, see Documentation/admin-guide/mm/multigen_lru.rst.
+
 The following nested keys are defined.
 
 	  ==========            ================================
-- 
2.43.0


