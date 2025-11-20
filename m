Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B643CFA446
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 21:04:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD2F16B0026; Thu, 20 Nov 2025 16:04:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAAB66B0027; Thu, 20 Nov 2025 16:04:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE7436B0028; Thu, 20 Nov 2025 16:04:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9CA436B0026
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 16:04:02 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 60CE413A088
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 21:04:02 +0000 (UTC)
X-FDA: 84132212724.16.76A72AF
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf26.hostedemail.com (Postfix) with ESMTP id BCC16140009
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 21:04:00 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=lS1I1mgB;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf26.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763672640; a=rsa-sha256;
	cv=none;
	b=8ApZgGUxDVL04wmlhHZYXVreW3pAyBEQV9eboJxYjvteLJUkXrqI1M7j2OCZfGgLi3G9Ap
	vDh2Jm0FJWFccVEanoAU5UwDE0MnhHIKBb8C2P4hGQUBM4uaaS5TdPw/QUQpdZEKB7Bl6G
	hJKqFnXPm809TAJyxdlye05k1YjtW44=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=lS1I1mgB;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf26.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763672640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=v1+iPRnl2CJz3Y6EOfGCbzApG9MSnpiujyLXIhkhEIs=;
	b=0HcN3f4/jdPlqmAZYgUrEfpnTgUiqHxCPO6iBrNDz33h1hHO7TP9oRlOri9dAzmk7OcZkn
	huoKJZpBeDsn4fwDN7SMtRpZGa0CAy8BtMhxVuO8K3Bjw6Atfx42abw0v3NEqi0Li+Wsf2
	cBJiPjYSQwYkXK6pGZwTEW1IBi5MxDI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1763672639;
	bh=v1+iPRnl2CJz3Y6EOfGCbzApG9MSnpiujyLXIhkhEIs=;
	h=From:To:Cc:Subject:Date:From;
	b=lS1I1mgB0/MTUHG/NX1LUQLm4Ho2ZFEsstTyaYZAyLg+9D/deFZSDJivA28INgblv
	 1mcpvlpEyNPURDN6SUqHhdxKbNDX/hEgwHS4BuerLMMdkFX5LX7mSj1ThpGoFqtjjn
	 ZvKLuSlOgAAUbaC26H4+35DxTOWJ18U/eu+7IR5UM0jdv7u71jM9+e0FXF7Wdh0zLQ
	 NVeUpxu4MsTPXHj/OHxGIqLnhMugepLBcjow/56yzarqtMtwd2AEErere5G21zBOOQ
	 UaI3Xq8YEh34icjkknLAEawShi5wUPBpG+vhdwbazI47WYZkcnrP2esAebC/DDfbV0
	 4a6kGh75dNt1Q==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4dC9nW5NGnzNVP;
	Thu, 20 Nov 2025 16:03:59 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	Yu Zhao <yuzhao@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>
Subject: [PATCH v9 0/2] mm: Fix OOM killer inaccuracy on large many-core systems
Date: Thu, 20 Nov 2025 16:03:52 -0500
Message-Id: <20251120210354.1233994-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BCC16140009
X-Rspamd-Server: rspam07
X-Stat-Signature: q9n5ez551wydfndojoipysgk5yap6zfg
X-Rspam-User: 
X-HE-Tag: 1763672640-746401
X-HE-Meta: U2FsdGVkX1/nXNr71P4iTaC+9VTKrHFlv2mb75Zmrbxi5LmbH53/YoBFGuD0spKqlooPhDeEyjw/4Fna+w7dl7Veo6zbFIQt3T7NS4BYI7zpLKMgtspO+RQmm5TQYJsZtsNbzp41KeEl0GXFdzWpYoDVV3C9LM3WcfuH3o0APNxTJld2YKlvuaol1Uwxc4y4MDuUihbe209s967Nuq8WxU7iZXWnZgjKrG8RPH8Eju6OZo96w6ZI7pXgnzBzxDhRvfcYCbF2ZY4k9wVJ7nWAQrhIk5+q77IABFKuJOwrt+DKxUXFYIpsZaDfIB++n1NDZbVH8+L2Fst9t86c3Ctg+japC6AUtmb/SfKjBxPT+2bszyUXKDth49qpB5kHpBbL/500lk34aiQnpYd5efHAcytJL82d9MJIabKyLTpw8OkSvB1LfgQSwDdG8+f08PJYPQbOlmGfmVK1Xz3SKl0tVzrFha8TG0qM48r7p1ebdp+pyztO43+m4nG/scLU7p5S4zfzRqneGPPYm69g9v4bgKiJT6KmQbz28nG7isOOgmLf+SyVeqY5rjc0u2QKjdddR1bXHwLK7cijbhzTOH/bdFe8y4tRZDiJJRvfbLpz4QyCZAFxaLxriZEcTFglLfWrAamcudVipndzPV4zDFC3837l26Yr8THbLtQNLpZ8FvvIsiy1xMLCbQWXl8KYeXV4nOIJ5Ya4fi/c8+oorDUHRkYkCGDW1OMgUHsi0HZMZgDdu0GHfRJus4uTBk/6lBZ4JKaCjujd5JILrakMz7UbcRJwDD3jHFOPzVmhcmv53bO5iskJv3mEdEInetEsem5r1+Wce9H3UkPXG5iZY/dSTsH4roROc7EXRJzyJK1FC4dKVQ9e2Wqg5Nh5gpN7r5GxkI1Y3Z7bIJxrNYOfgWcvttOKzpig3KvW8n7WS/b6C9HmB8pLXpC/8P3aK2GJL7msOooCazKpUdbbbdeR1N1
 dJX4CLlT
 C9sa3TeIyShj1hZcdwCciumRZNPFR4sRj1Ei4hxo25IhKiNkklSTN1xDc3DCU2v/m+Yx8PS9zhqtfzCtq9LfHXaPCDxdHGpiI1vUknJV63A2zmVGW/3sFaHuop6sKJkz6Ruo+7cUH0xkcLaG4kreFu6WKKs+BnbXpxvZKsZw2UC6I6T4PIa9lP8YTzGZkIILrQxuvB+3eYG7EAl3ZdhaeHxRbIROZOc0n1gSBzOCSW9LiHpkrmKhyAi7N1xKKQU/vPHO8S96CXtX4MAFP3BZfPOnkkDRMwvsnrBexdApOJm4baC6+XIPnqDI8154DxFFoX8X88CR01DC8LyFW4NMEnGooLSj9iusr9AfijnKPNMZhVIwFFZZBWewCY7plq04bu0UeKyDCxFORd+nRlrxSdP3uSNvvT2UZ9mfWYXQvY65uO9EH8VsqPDbTXmezSVP3XmAsIlzMktq0Kj6VrHGOQ3Certl+QBbg+/D+la6lgXiq3kXJ+d2dESnSg5sfc/4OACIZZgBSsXBadaWZ8w2YH6g/UZLy/yhEf86knixQ+KfD2MlioJH2NutqwH9DOQ83f3YxotH9YCA/Q/3eJGHTpcW7a48fQ092HsmtBCvKmlgTytWb1glhI26acXENUe6nczprBDqt8J1tQyJJNU4ovcpozG7g0DIgMYpr9Kx4nvgmblKxnVbMoh021+zi8EeAj92plrVMziPjJq+8DmPu2dKey9d78tosFQi92Hi/RXs8csSlCQgdTwWnvCS1c03CWTwoWStiooc3a6+aPSe/vnmL1lRncWR78C1f5RyRpCmQ+s1EbxVkMI4HN797vfPBFdx8vvdC7RT6qmYnNuizaWJv2b2iG9rv0g5EsIYnTsody01QJA2Sr6r7PJPTNsse/TzK44V0KiYh1fo2vQzoY36lQwpM9os5UNWiwdZ2IuR3m9xFgC9LXPic1XniP/FWXoKenwy1tYzCM/2yjxY8RutamI26
 wadV3G0X
 vFxDbAAmD67/kFWypx6AXTdXmNS5NBsCpUg4ROzmZ1zgZsDS+uEiw9wzy+saHqpgrIzVdJDrL3D8vorpAuL5GA==
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
Cc: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
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

 include/linux/mm.h                  |  28 +-
 include/linux/mm_types.h            |   4 +-
 include/linux/percpu_counter_tree.h | 239 +++++++++++++++
 include/trace/events/kmem.h         |   2 +-
 init/main.c                         |   2 +
 kernel/fork.c                       |  24 +-
 lib/Makefile                        |   1 +
 lib/percpu_counter_tree.c           | 443 ++++++++++++++++++++++++++++
 8 files changed, 725 insertions(+), 18 deletions(-)
 create mode 100644 include/linux/percpu_counter_tree.h
 create mode 100644 lib/percpu_counter_tree.c

-- 
2.39.5

