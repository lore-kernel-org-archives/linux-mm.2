Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25B44CCFA04
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 14:42:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E95428E0042; Fri, 31 Oct 2025 10:42:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2B338E00F1; Fri, 31 Oct 2025 10:42:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBA9B8E0042; Fri, 31 Oct 2025 10:42:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A6F818E00B2
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 10:42:44 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3D60316050E
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 14:42:44 +0000 (UTC)
X-FDA: 84058675848.21.D829A05
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf26.hostedemail.com (Postfix) with ESMTP id A4D5014000A
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 14:42:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=vrYl1tBn;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf26.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761921762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=mn4Rixq7zXBuMBlaqQmjCKrD+qIqVw6PlXV4D24CrIA=;
	b=h/5RuMW5fO8Vl1Q/DBR4XiI1i2sMM9qH14O2YLDJEKuNlxRKCOjjog5kiIJx3VTdAnrIyc
	mX6/xslDuLlRKb2EZt1WOQA778VwQ4TFIn7gtJOs+wyWD1DdLSSP+caefrzE0qmKIUDQl9
	lOjeTIhTRy9TzUVhJkkd9F6AsAM9lqM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761921762; a=rsa-sha256;
	cv=none;
	b=xi2p+pPyB+HeXDdQ8KPlz2WadLCL0+NQePPlE1/YscZbcKWClrx+CNh9idrAmRi2y2IjDO
	qI/amy1hi6zkPWAruEHCkqfm7zr77fcS3fCkKa73SHk0q3sdb7/73HFBWwcAc54o17j6Yi
	PiHKwXT4xxplggYCWpOGsWfTVMHndvE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=vrYl1tBn;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf26.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1761921761;
	bh=mn4Rixq7zXBuMBlaqQmjCKrD+qIqVw6PlXV4D24CrIA=;
	h=From:To:Cc:Subject:Date:From;
	b=vrYl1tBnleKUc4qHluXabp2KWvP7tFw41yKB5QTaottntuaQHyecL2vgW+tfXF4gz
	 darLlhPDsAeHo6IkH5oZ4g1u4DCfVlN4rz2N1IhzSND/lFNGYQQskYOgsNer6VoZ8b
	 tKgvQ7MwI2+LrvpgEwtUjYIsB//ERgHd+dUnJv4u6aZbr/Ixk7R9fa59XS6vK41wBl
	 eaEnB0Sa+VLgsEfaJ8w4tTbi25BuQQOn+cyNcpXZXstZxTwCNsFJ1roNAUU6LYq2zp
	 sGulXKyqQ8oHirybdrD4cWYv2jjkjSe5HBj19iZSXoBeqlsiszvMtXmfnqnI3uub4S
	 cYsNGocmld9Ig==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4cykGn4jKfzGXX;
	Fri, 31 Oct 2025 10:42:41 -0400 (EDT)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Mateusz Guzik <mjguzik@gmail.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Sweet Tea Dorminy <sweettea@google.com>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux.com>,
	Martin Liu <liumartin@google.com>,
	David Rientjes <rientjes@google.com>,
	christian.koenig@amd.com,
	Shakeel Butt <shakeel.butt@linux.dev>,
	SeongJae Park <sj@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	Yu Zhao <yuzhao@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Matthew Wilcox <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>
Subject: [RFC PATCH v7 0/2] mm: Fix OOM killer inaccuracy on large many-core systems
Date: Fri, 31 Oct 2025 10:42:30 -0400
Message-Id: <20251031144232.15284-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A4D5014000A
X-Rspamd-Server: rspam02
X-Stat-Signature: yfh43efse5go5bmup91pyxaxegjy85gb
X-HE-Tag: 1761921762-271716
X-HE-Meta: U2FsdGVkX191zv0Ir0s7iMgF35j0Rqg6gbdhwjVWAx18O7DsuMwlcnginbQ/vZUjMJ3XJ1pSXb1Ubywri32zfk+OjDDl9MVWP5cCLpmB5uNgLWjqy2cRXomN1nZtWeOMv2IB0QKoPARfyI0LEgiPPNlzwBQxhEsyOorgJ0QNW7s6HqtyY1vGf1aWYW0RNqa68x3fNGBRR/mPZGVlPNELHqcKLcoBOHB02qZjKGh8ebAzy11h+HlpPoyGK9mZcwsq028IqmS9HYr3vTnqnmvklFyuK9ptNmP4lsxJGnkf27FDNaqsgIvAhU64jBCgGcSTm/IKq3k5T0HX7yRAupyqTbpSC0ozYVCfro9GUfDTRwzK5Gv6J6Fr2JqX9SKZG05OJm9WaRhShkv9Ks2CV1dB2nPMoGQhb71unBfK7gwY/3A01kNVslNAqqOGs/2GuTxBfyIoQr7HuhnStnzdMs53jmcHWdwizmSQ1/S1CL/k4g6OgC/WRhwJtpB2I8DRieokqdP6Rm5MMiWFMB7PoJMjB6u94LKRkMyAftrp6QnfXtAneE03ZCnQdN4tnrLRet3NrdJ36cgFSrFUtSNinSZ2UO7Rb48YGIRacU7a6GNnG2a7u77/MT7jUAVqxryY+Jzpa0Nz0xu5MvW2HZCvGEoN6eOAAMXCh7MvUajq1i3zCC/V8E/eMqBokI1hvTQ2fozBOayfXC7G6TRQ8EN47VP/yRcFVX70DOK0oplN72xLRyP1TEMQlMxkyOt+dX8+GldddUX+ORfepz43/1VfByHF6vq6NzYL5uHvgQWTxfKEuaFe/BaexS/C/cfdwskwaJeMljshjvo7vRF8WwuvJ05L6oGB+N4Br76lpAFDiIVy+xhLNUXFmuqnHnZ950NnsRkjWE/3e1ciSTWsg90wudmypLQa0li3Cz4/mXOWUickTYWbOIFRfLww7z0r3LLilu/qsELcJ7agvH0RYyTwrt1
 t71ZdSdT
 js6Xhl+sGdzc+yAe1wqJuhTq+mMw0fThiO0K5h4sTK/mhNcZTBqk8nVHueoEdmTW0zfhZzYrUs4QPbmwO4PyMcRVFmbTlyvE03ZGx6NYOiOk0ibi6F+Ws9DHiovJnOYiARXDRhHPQSDGM8h/A7Pwucp7I+hpu0aVj7p4af8qHPQpcwRUL/nFoSIxUlYWRtSx/JFLV2gtIDCMwl6Nsg2B9TXB47Tkv4oqWd96dUKFldZJodZKYWTIZKKeH/wx9xmDi4tlVLbaAeVzHa5sEQXbAiK16NHmmekK2GAfBvHVyAuCU4YGaw39oLoXueSFfOwNsyTMTx+tl0QBJph49UXXNrz+DBZKwAbwWWsYE5+i9vL6m1IOnq5C2x//fXEovSYY3ia96y2897xZ37P6FWQvUU9t3BiJslatY+EJq3K3GJmIt+viZG2dzyx7dzm2DZWfv2UnPJO0zFHWgvW/RRbZDGQGzYYeQqZTAsUDTyEJBVOE2zwR3KQCu2d3Ce/QsG+KfWeW1/XrRxlTu1J3X1Q3if5m2Sl2HqqADcduPfwJQPXOKPxVJ88o90lLCSqbdBTIUMJWFcYOLcRtUC+J/wiXrz3cwltEXkKraxif5XNAwaWYEtNGzIyORHi5pFR7mLg0RxTfpMuYJkddfmj+1dSNg55FA899y0wgtuedNiO7yuBJxJ2CHpOfXb7bPsCMsHfv4sBJCNhQOR5DQlif1aRso5V4qKy/uawQTeHl6s+59OEbCKwkD1ecWhWir6YAoDVbAXY6D9jze2w5Nko/ER9ExJEfbaI0vMrGjIZcURAVemlweIv6aQS0IcC9rfxt6uWa8SUPfZdsLARiZz/uwh5uoWhJi7kpfGo3hiZQ3k2d8MSTaLE5wdl6zlNOv5ecX6+aHCZiSjaMNvPbCxant14iPaYH8l9MeNEmXfGdGPUEZ3FIC3tacrfAAsszLZpplRHXV/KADg1ftm/3pfmipu+A8jO4aUY4n
 OE40TJuR
 S+3a5kiA01FKrG/eSnGk6YOTaFwCXdoQIXpnh1QtDWFHJD1ClM/AqCP6BabMo4J+fxSIXTm+Z31+SStte+vk8g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce hierarchical per-cpu counters and use them for rss tracking to
fix the per-mm RSS tracking which has become too inaccurate for OOM
killer purposes on large many-core systems.

The approach proposed here is to replace this by the hierarchical
per-cpu counters, which bounds the inaccuracy based on the system
topology with O(N*logN).

Relevant delta since v6: Rebase to v6.18-rc3 and implement
get_mm_counter_sum() as percpu_counter_tree_precise_sum().

Testing and feedback are welcome!

Thanks,

Mathieu

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Martin Liu <liumartin@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: christian.koenig@amd.com
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: SeongJae Park <sj@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Sweet Tea Dorminy <sweettea@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R . Howlett" <liam.howlett@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-mm@kvack.org
Cc: linux-trace-kernel@vger.kernel.org
Cc: Yu Zhao <yuzhao@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>

Mathieu Desnoyers (2):
  lib: Introduce hierarchical per-cpu counters
  mm: Fix OOM killer inaccuracy on large many-core systems

 include/linux/mm.h                  |  10 +-
 include/linux/mm_types.h            |   4 +-
 include/linux/percpu_counter_tree.h | 203 ++++++++++++++
 include/trace/events/kmem.h         |   2 +-
 kernel/fork.c                       |  32 ++-
 lib/Makefile                        |   1 +
 lib/percpu_counter_tree.c           | 394 ++++++++++++++++++++++++++++
 7 files changed, 627 insertions(+), 19 deletions(-)
 create mode 100644 include/linux/percpu_counter_tree.h
 create mode 100644 lib/percpu_counter_tree.c

-- 
2.39.5

