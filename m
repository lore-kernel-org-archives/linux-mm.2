Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89374C44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 17:00:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86C2A6B0093; Thu, 16 Jul 2026 13:00:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81C4F6B0095; Thu, 16 Jul 2026 13:00:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70B756B009B; Thu, 16 Jul 2026 13:00:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 483886B0093
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 13:00:54 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6F7094027A
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 17:00:53 +0000 (UTC)
X-FDA: 84995254386.22.D9CD98C
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf19.hostedemail.com (Postfix) with ESMTP id 15B471A0002
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 17:00:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="gKXuKFc/";
	spf=pass (imf19.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784221251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ryLZfzu7w/33tZHMEAX5YS1AtIi6A75xAvSnQuDhpy8=;
	b=6yATuAZHiPr0ZO24Kv3udHS2XVq9Ui15IZLsuIYB6uNoA0AlEX3+g61TglATcZq7YAG9Wk
	HWpk6LxUStB350e7tV6JPOfQtDm0d3qG61R5rCR84gNWYnx9Gqlkr4XhXeafuCjc7Uoh+f
	JIVeWZlesaeZXVUVz0CTT0+2AQTuV4w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784221251;
	b=FTg2rwy+dwQCVm4evYFCCntgj61S7mQz9onmzFx7Z/kgSV11O7j9AAvypBDKDUzpO2yi3o
	MQs69CU+ZOFS2gB+FpnYtofGP7ALP0BQ/BYZk5YwGar9PEHxAghwM9/zE+wEVevfnZXf1x
	ZV2oDml3A6qjfvuHFCa2Ukg80HxKP4w=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="gKXuKFc/";
	spf=pass (imf19.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784221248;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ryLZfzu7w/33tZHMEAX5YS1AtIi6A75xAvSnQuDhpy8=;
	b=gKXuKFc/Zc+x61YZilf5Od0LX0/TnweLJkY6B0iS5dDK1rmx2rZT6ibR+q4XB4vp98ECAJ
	usgRE3P9Y3i2YNrl1JiIwqE/t23GTZbcDGdg5R0zMUXBaD+s+ENmZK2riqG0XJstPAQl7N
	n59nA6ONzcF/mPCm/md31OknwLidCVI=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 16 Jul 2026 17:00:38 +0000
Message-Id: <DK05N5JBJWQB.2QSODJ6JABRIN@linux.dev>
To: "Brendan Jackman" <jackmanb@google.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>, "Matthew
 Wilcox (Oracle)" <willy@infradead.org>, "Jan Kara" <jack@suse.cz>, "Joshua
 Hahn" <joshua.hahnjy@gmail.com>, "Byungchul Park" <byungchul@sk.com>,
 "Gregory Price" <gourry@gourry.net>, "Ying Huang"
 <ying.huang@linux.alibaba.com>, "Alistair Popple" <apopple@nvidia.com>,
 "Hugh Dickins" <hughd@google.com>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Chris Li" <chrisl@kernel.org>, "Kairui
 Song" <kasong@tencent.com>, "Kemeng Shi" <shikemeng@huaweicloud.com>, "Nhat
 Pham" <nphamcs@gmail.com>, "Baoquan He" <baoquan.he@linux.dev>, "Barry
 Song" <baohua@kernel.org>, "Youngjun Park" <youngjun.park@lge.com>, "Joerg
 Roedel (AMD)" <joro@8bytes.org>, "Will Deacon" <will@kernel.org>, "Robin
 Murphy" <robin.murphy@arm.com>, "Huacai Chen" <chenhuacai@kernel.org>,
 "WANG Xuerui" <kernel@xen0n.name>, "Thomas Gleixner" <tglx@kernel.org>,
 "Chuck Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>,
 "NeilBrown" <neil@brown.name>, "Olga Kornievskaia" <okorniev@redhat.com>,
 "Dai Ngo" <Dai.Ngo@oracle.com>, "Tom Talpey" <tom@talpey.com>, "Trond
 Myklebust" <trondmy@kernel.org>, "Anna Schumaker" <anna@kernel.org>, "David
 S. Miller" <davem@davemloft.net>, "Eric Dumazet" <edumazet@google.com>,
 "Jakub Kicinski" <kuba@kernel.org>, "Paolo Abeni" <pabeni@redhat.com>,
 "Simon Horman" <horms@kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-fsdevel@vger.kernel.org>, <iommu@lists.linux.dev>,
 <loongarch@lists.linux.dev>, <linux-nfs@vger.kernel.org>,
 <netdev@vger.kernel.org>
Subject: Re: [PATCH 2/3] mm, treewide: replace __folio_alloc_node() with
 folio_alloc_node()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
References: <20260716-folio-alloc-cleanups-v1-0-5363b8e92d33@google.com>
 <20260716-folio-alloc-cleanups-v1-2-5363b8e92d33@google.com>
In-Reply-To: <20260716-folio-alloc-cleanups-v1-2-5363b8e92d33@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 15B471A0002
X-Stat-Signature: tru893g8gmu3o1yyjuukwfzb3ngf4ma4
X-HE-Tag: 1784221249-570887
X-HE-Meta: U2FsdGVkX1+k202WQNq/R/mKhWtAbNFk4VBlaGRjk9jHeGcoYJRHw5Vnp/Z42fPOWyMDDW4EXSL2A5yxinC/KNGgbXEmAaLunw/eMOnqu2hOKrEc/Z65/4t7Lg5RbsJlXY291WfoPpIs3L/FukZupqKpqunHutYKOHd53dXyqF+YbbRXZ6KfBAUh3b1FCXGWz97aoHMEWV78lmikMkYUojvlyD20FP88E47+zitzKsAN0FgBCJrCuPB6HB452KD4XnOL82rteVOdGUV2PTFvV/jk5svlgHJQFOKum1AyuuLdahl0oJgcxPGbay/m/g6/dn8cEeTL9cnxd2SZ17lCX8ZGsZupZjJiPBwOp3eLaZeYEvhtto3V62Z21k7FTtI4Rplm5Xl9WuFFkJyjMLbcU14BC99miHQx49Oq8Rjog49vElolF3bZbzRQb9cz87Jh0nllowyc5IuWB+1NxFl855r2CZLcI5cUnm7L3a0nw2yTXoDmA9pmYKgXhaqJ00IcX85sAXChFT2/T7KuQxMvZJIDnlf8YzucDkPC/8K/wPD3bfM2f8BDftAwze9cJqkSn6c+fgUKb27QhJknk7abLSKKykjGfUCyaIYk/EpQsQVYCLCWEfTzSBEwBIePGXB1zslEYet5KRuanOmOY5NnvhJS2FgCbuQzgGD2o2HeuYDh7nfWEwn7cvLrF0G+K/jmLKzx6i6nSfuPbIMyYLXHmSBNGcqpYxgzsRfkCKL7Cn5pfhTXQ0eAWQZZIJJ95gfrLvOoyCHtHDK5X4twJ+cjw7u95w1+A1Qdal7yCpymbnjf/C8ECFRIhRm+DShgzH9KARipcl/2DTPG8kIPjS7uZYSU4rICUxi1jfFx7F96hbTy1PHLevSX9dV2+beLzdSg2DcrQ/WFvJse8fcEeNWTLUWqo3MTfChuAkkKl2xyGBOvNmwXaTLkNBmwjWzeErSR8vM8I/Fm5EJrYVDesl4
 x1q60gJu
 sJ5e4sGjWLlFsOM/0MvCwmUeHnx6AbUij4fKVsVhI38U9LRgzA81gFYkZdHoz/FLTPe5C+pb4zMxIzCpBK89A4U6KL7DgsTZghHPacSbdtIvqKZVGShcDzYTOw0PDwfCbsH4HwhorOFSynvweDLwN6svAGL3tDoxXK9TzXdsB4qBNg5VF9lS9Mef7nYmWucURLJ1N/EYs7RdliGCC451EC6hpW3xNvs3LIu+Ol2Xf+qHrZ0rHnXYHnH0gYY0TWDnQIc2YIGvhUwENgeyyrtDUvZDfgyjEhUik1h5ZE1I0wOZCY+6NbOBsWmUG3G0FHBTE8T+YXvyl5NjpbbN9ux3AxefSrSWaUNSku/VMtmvdPJ1CDWo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Jul 16, 2026 at 2:30 PM UTC, Brendan Jackman wrote:
> Commit 5b584d2d22dca ("mm: remove __alloc_pages_node()") removed the __

Oh, I just remembered this commit hash is unstable. In fact it's already
wrong.

> variant of alloc_pages_node(), after users had been migrated off it,
> since it just complicates the API (requiring users to handle
> NUMA_NO_NODE, or risking hotplug bugs) for no real benefit.


