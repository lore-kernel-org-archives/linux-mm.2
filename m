Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F328E606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 01:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nH06Dx5P
Received: by kanga.kvack.org (Postfix)
	id 99EA96B08C7; Tue, 24 Nov 2026 20:46:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94EDE6B08C9; Tue, 24 Nov 2026 20:46:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83E286B08CA; Tue, 24 Nov 2026 20:46:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5C1076B08C7
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 20:46:11 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C9F38C08CE
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 01:46:10 +0000 (UTC)
X-FDA: 85471950900.20.4D7CF44
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3A20BC000B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 01:46:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nH06Dx5P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795571169;
	b=lfg7+7VxrgXbg32LziIcVb8qad5lyZ9A8EaKysG7xP7XqWkfr4fswM4kR3VwLRDjv/c8SG
	7L7J0i/6unHHip5Pqlamp5O8o3i3gO44BWSntEEEK7sjT7GTQoIgfYkeuTVtc88MSLtgAi
	cOc/n5u0tcHTJAhqItTzRwKgRy4AXUk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795571169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v8v8+B2s1x/OC+2e/Qjn0YMmUDX3uWey0kH3oGaidV4=;
	b=HYvvm2ek14FjrNLJ9/re3MPhJjWKnEMxxw2hSfPhD8CH2IbgzDId6toMwocWp6doeR4DPQ
	CN+8R1tYpwisAs+U98YKp1hPqp5zS+PKihyY8AJytbiDooFdglrLqFJvX3KOiXvnpBFQSt
	/TFVWywwm3UNgXRKD6e59Cyv4RnKAZo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nH06Dx5P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A72A260DD6;
	Wed, 25 Nov 2026 01:46:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F4E51F000C0;
	Wed, 25 Nov 2026 01:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795571167;
	bh=v8v8+B2s1x/OC+2e/Qjn0YMmUDX3uWey0kH3oGaidV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nH06Dx5P0Yi4GgYiauESIEHDhrZ5h0ePu1XxUj6w9X3ipZubgua+BknUm03wE3VgQ
	 LbfPIPccvlhWg2C2vt/tZZuCh85f8uuaPj5MRM+VcYZF2D9jg0QtgOR+YTv07qoHzd
	 Hnj0e0/HGED3nzGUhIE2LtG3dgNucQ/R8hwcBKul55Ko2R6NfMgEWvEGShIMcqW/1L
	 5wd6iKhbeEK/13TwJ61qp/ZkqWfJBxEVGfHOM4dCoTrUliThw2bi3OqFNlaI/roYdP
	 cUB/KTngPRtJnE6Z1HVAnyHi4tbrC2P2dgMFOvALyqyWboRnne38lNMgRzSiOFWQYv
	 sVxKrHTC9Q/Fg==
From: SJ Park <sj@kernel.org>
To: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Chris Li <chrisl@kernel.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Nico Pache <nico.pache@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>,
	Zi Yan <ziy@nvidia.com>,
	Gregory Price <gourry@gourry.net>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	Hugh Dickins <hughd@google.com>,
	David Rientjes <rientjes@google.com>,
	Yu Zhao <yuzhao@google.com>,
	Vernon Yang <vernon2gm@gmail.com>,
	Zicheng Wang <wangzicheng@honor.com>,
	Tal Zussman <tz2294@columbia.edu>,
	Kairui Song <ryncsn@gmail.com>,
	Xiang Liu <liuxiang.277@bytedance.com>,
	Ehab Ababneh <ehab.ababneh@intel.com>,
	Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>,
	Lian Wang <lianux.mm@gmail.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Hui Zhu <hui.zhu@linux.dev>,
	Maxim Muzafarov <maxmuzaf@gmail.com>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	Tianyi Chen <hi@tychen.cc>,
	Kairui Song <kasong@tencent.com>,
	Ridong Chen <ridong.chen@linux.dev>
Subject: Re: [PATCH v6 04/18] mm/mglru: make generation page counters atomic
Date: Tue, 24 Nov 2026 17:45:58 -0800
Message-ID: <20261125014559.98601-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124-mglru-fg-v6-4-8ffea39934a6@tencent.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 3A20BC000B
X-Stat-Signature: qartku9tut6un943ougpa9gtfgawty1s
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795571169-5920
X-HE-Meta: U2FsdGVkX1/OJbVQtSfFtI5gW/EGAjmEqwmFifjYYxQtKKz+EaBaRNyjTFThc4wHB1nGjqvxmBOmgZpPSetyyuP4ApLNi/X3Z5mYNYeLQvF7cny1pmcb4+dTzhy9enKgTMCJe0ZuodLvbZV/dWsQPBI++IQSebx6tl7/SMrsePCyTLXNeqi2a9/F4KS1YqW672D4E5+OWnKIEvTDNTf/NYltsjrkw/rKLntVTX7XK9HBwUenw3vAYczrmFnp1U6PzwxI9PK3uB9lQ/YOls366SEkD1fZJKsgXAKAOso+zlX82TRbPPRRTxbeXFYk1nBNh8CkOPBZK7KzCpYMiMtXB4zNfKZiYUgfRHyiOQ4hmIW689drN0pywHLsAkVSai4K5446AkNJOHqeoaJrESjyCMEDy2yKqAKetRc5DwjmcMd1K2BtRxx46ndRnsyeuijLyrbKhe0heXOG0tc5zU0rACzur/hiWwb1ibSx4h4ds3ZraBNVZkWwoCnYleGpSaSHpeKnlJ27GniUORrpIgjfyQ9cHKVD7W/bT5OuoYLouK8Z4vht/6i8NldPlOSIt94YJs3o5MXofOpcoGr+Bihx8Uk5oWc+rgje34eSZPHRV/gT+43p4I/BxuVqmnSyeHym8NpF4PID8KRIU72sV/jV5qYO17rGPTjRPulqqp0HghYKZQXqzGWgUbNRLpJfMYHX0UEOFOssomGKL8Gog1JlKP62w0KitP+RPMfD3AC8kQG1VPbElFrXpP1LJHvHv8QMomMm95AJAxDHHjtl6Rx7VrJPRsvCJda2Yne/Q9bEwkyc+fz3DikIJ0Cp7WEIMRbqEFexRobmaL2hI2sq7g6SnwTuKCc1e+7roNO/SdTmfELHgGilA0XBcEN+0+0AlNQ/Sybw2Bgc7IvyAdM3XXqFikBbTIA8hew9/vn1rBQxBfawMr7hO1DIiL49wexCLJ1jps/7se9vPWrLNO9pxhc
 Xef1hj1Z
 zQMH+NdMZo2rNGmG5hNmRtVmU55z9JZE3CaAco29rdYySxd69aVw8FxhBBajrXJaRldnqc/mb3scBu6o/ckmtZh62+jqan00wPTD5987txiOqy9T8JIdB2Xe+IVvJXNW7y2122zaYGyKkiv3+OhxSKJDCqyyN7LlcanP6PPNrkV75YDQg7bFMAgmb2wfvye89LdpN04JPqscEg32mMmLB0Q6mDxHHr/NU83oWYCmefmQv4ZccgxihcenzJiuKH87jcTSSK5+Q4UgcOZ8crl5f1snik1CvP992tE03Z108Jvd10hZAHeaHkFkTMB5fenfrC75vMa7Tp/qhij4ntkDrC280KuqJlQOv/MLkuOX1yDqWbV+qGeeR0ak+riWcrJlQs7lAwux2lxSHjF48KV6Ma/g3iqLJvUem8hY+cKwgTjvI/7m3lUY/7PZP/303SZVoiXBeK1raR/2+5xXbVdRnXfMjgSAdACGI1oxIRE7ZfGkJatsItuWgowKocIZohrlXRoyAAyX114Pxp9yKvhEqzNnZRPcagnLWyvIWK0nq77rHBAV08k8JUOLM6mJ6M31gp/W2DmMsPqhmr54LSj8UrenhCDodYooJyvEkUvd/7uij205alIl0Wfw/sconj63zX6TWNF7AjzOvYYX/yGjSlMGWtDUrvJUO2WKWW+4G61p+mHO28KIPkh9ieYJCgvdU4Si7D06ypIOTAYQm/tIvCd26/V5LRIkZdm4SCOAMJnxlFCN/F4uubqtZmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 24 Nov 2026 02:52:56 +0800 Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org> wrote:

> From: Kairui Song <kasong@tencent.com>
> 
> No feature change, convert them to atomic so we can update them without
> holding the LRU lock. A temporary underflow is fine: readers clamp a
> negative value to zero, and the counters only need to be eventually
> consistent.

Makes sense to me.

> 
> Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> Tested-by: Andrew Morton <akpm@linux-foundation.org>
> Reviewed-by: Lian Wang <lianux.mm@gmail.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

