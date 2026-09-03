Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6646FC61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 17:18:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 295F26B0088; Thu,  3 Sep 2026 13:18:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 246EA6B008A; Thu,  3 Sep 2026 13:18:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15D566B008C; Thu,  3 Sep 2026 13:18:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E42726B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:18:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 64C5A40594
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 17:18:39 +0000 (UTC)
X-FDA: 85173110358.12.425CCFD
Received: from mta1.migadu.com (out-230.mta1.migadu.com [95.215.58.230])
	by imf24.hostedemail.com (Postfix) with ESMTP id 305F418000F
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 17:18:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CCU547CJ;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.230 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788455917;
	b=RpZgTMP0gcVeXQw+J9N/QvYuf0DootDfOT3EYU22cWZ2Aw0rfD+rONts/xZy1iJsHVOGR8
	WuXkzeN7c9BwDDCjIEtV0rMjY/puJ0AjuAXzpmLrpvwCXEaHTFljVrkwdyFwC2Ye6LGT3h
	oskTDazf7UV7W0wI7WQyJZ58IPm6bps=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CCU547CJ;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.230 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788455917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LFAU6t7YY54E0iGryUd0dR0coUqlIQpw7kZy3NmLPgk=;
	b=G0a+AwEabQel0iGVe5SZr0a7SB/N368tgAEEMcHpK63Cs4ewo4njdoaynX2EKYKWZ7TZjH
	/yZqx8jZ+zCy6KSMT7yWX6dzksHpEI+ulKq6Rur+PWG2Q18h7ylG3lXGt2MVyjtpb6hCON
	4wmd6fHWLqnqB5JYTWKjSpsOlLezX98=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=48a3toOvR18Ra0dPY+h4+qV+F4oz76ihqdhRFA6Wyq8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788455915; v=1; x=1789060715;
 b=CCU547CJrpZEqm1O4Biy2wZ/MFRaL7s0q+gFZHL6/8CBE37QCU9mfwHKQvL1GE4N/E1H/CKx
 BOirddSxoKTTNZYvgDD//KycXBKpATv5MyMLYGGmVJXUAmjs8YV5Wm5Jp0elAKn+d4I+HpV7KZQ
 b7skKfPFxo8NLeqVEoBUog1w=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id fd62f8eb6babc664;
	Thu, 03 Sep 2026 17:18:24 +0000
X-Mizu-Trace-ID: fd62f8eb6babc664
X-Migadu-Flow: FLOW_OUT
Date: Thu, 3 Sep 2026 10:18:23 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, 
	Martin Liu <liumartin@google.com>, David Rientjes <rientjes@google.com>, christian.koenig@amd.com, 
	SeongJae Park <sj@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Sweet Tea Dorminy <sweettea-kernel@dorminy.me>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Christian Brauner <brauner@kernel.org>, 
	Wei Yang <richard.weiyang@gmail.com>, David Hildenbrand <david@kernel.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Al Viro <viro@zeniv.linux.org.uk>, Yu Zhao <yuzhao@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Mateusz Guzik <mjguzik@gmail.com>, 
	Matthew Wilcox <willy@infradead.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Aboorva Devarajan <aboorvad@linux.ibm.com>, David Carlier <devnexen@gmail.com>, 
	Josh Law <objecting@objecting.org>, linux-mm@kvack.org
Subject: Re: [PATCH v21 0/6] Hierarchical Percpu Counters for RSS
Message-ID: <apmrfy5zsjmWMNj4@linux.dev>
References: <20260901182857.26690-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901182857.26690-1-mathieu.desnoyers@efficios.com>
X-Rspam-User: 
X-Stat-Signature: tu6a6b6kethnym5wdnmfij313r1b474n
X-Rspamd-Queue-Id: 305F418000F
X-Rspamd-Server: rspam06
X-HE-Tag: 1788455916-545812
X-HE-Meta: U2FsdGVkX18N34bimGk6RVJG7woqvYhh1aT8JMs42XPVb5N0GPDqFbjNMJIHes5UyNsLMjuXrpy5HqOunrTbCJEtAESzv1mHzB7qeU9liy/AXDOP5Uq0Vs327yRARGzeKpIxExw6Qkgc9tNjoypulx2VkTxQSTDMdGceCwNQwki1fzpL+BbgdNGoyi5KrWJJhOQvLdMS9gt7oG9nMKzhT+X/sPm3TGvWQcYTefMV6A8Aw/gUAL4tDaqcNHgPXtPuhj5fsufygPlvUH1aFM9LMvfrCxuzfa2Usk50Ff2DkyEh6XJmubdmqjy7ZDA3e5nOk58Daj6l5eZgTo882EWh7wCcDeaClcDMBMrkQPEbBklFB5RE4VVZ++yMicPDE6V14gkXZUn3f2yScKk+vXLL5kUH9AU4PWqGoWpG3M/Ezc1LzqEnelGHOu9QZFnwXtb9gfTrBGciX0OhyjbN4Q1aNLZ+7b8GxQhA6QpYWlMh0d3ffOXlh8W8eMO9w89yJFjU4ygA8XMB2RbOQ2ZK5UcgCuGabtrlncQYTfypMpE6PtFIrqRC9hCbMmzf9g9HEGxAnKiUntU1g57HEpNCpWTlpNgFgUeC9Wc/+D7CTYlbjOFSR30xrg22M+OxV7zOdXTRceOhTAzc0fSp0rzaQEYKYUaB8znCnqfCMyy2nnOIg4c/boIEBaWJXWF+tcjt6zalTejmWz2itKISqpczkP3ogJwvc+igFqCp9ZU7Z7rZ+AwRvhvGlDHjfggeUahfcl92GWs4feA9xk2V+bdyrXJPh1TMtd5TzcLlhzFaKttZu9p+j08JhL3aaQq7wlEBSX6FyHYbSRKVAlW2jpcLkSCRjGmaiQdX9kN3k4uUiKGvFDd9G6UExLOlXaot5sQn/QMJu3eEVLhjuGvtyhJHcDpKgy1/UohvRpehmP/d1kl5kD89IaZp369fMKnnPpwPmEfuRmXzlV4fzkpnuiWyMQr
 eRgmkc1f
 6zfnhTT3YFzqSdTJrsqEVDX3+nlCaGktnxpRdHjbxLQSBI6dafkLqhgTgFzWfws0qtU8eErFgb7lCbFs33Fno56a3SMbU6jVOwdOtQ/Bi2A9sw5dxkUlxzj3DTjKoAEZsS/d8wp55nWDrc28P5pgdFC23JuhuVqU7o8rrkyfVzQdbgtz/KJjHSJOOouo3Fa9t1J/IhktVDz6KnyOGUHS7YhKeVf5K2W+qB6bmycactkFRR+VILRGD978AbMCzFbzm65HTtK8aSkFOV/xewrOO8CTp/1NQVT91JhGRqGHqb9dw94o/CXN80unpLr5CgPf3FiG08rq9VCy+YTZ1l8SvONk7v1qIJ1QPUPXU1jstIWZjpjcjJNLdfa5o6xfN10faFdxTJW+WQ7HicM8vCWtUnNjaLC5JJnudlb2Vxbqax+jcA7oDJllAYls5NLGEXqmuQPP3HQcEHGI6w1t6CI5780P/4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 02:28:45PM -0400, Mathieu Desnoyers wrote:
> Hi Andrew,
> 
> Here is the hierarchical percpu counters for RSS accounting series
> rebased on top of v7.3-rc1. It includes small bootup fixes which were
> needed to fix bootup sequence on specific architectures, and a rename of
> the test config option to include "KUNIT_".
> 
> This aims at replacing the prior version of the series you had
> in mm.
> 
> As a reminder, the goal here is to provide more precise RSS counters
> through /proc. A future step would be to also use these counters to
> speed up the OOM killer task selection when OOM is triggered by
> memcg. In whole-machine OOM situations, latency introduced by the
> OOM killer task selection may not be too much of an issue, but for
> memcg, where cgroups may routinely depend on the OOM killer, the
> acceptable latency tradeoff is quite different.
> 

Hi Mathieu, can you please comment on the Sashiko's findings [1]?
Worth addressing or not?

[1] https://sashiko.dev/#/patchset/20260901182857.26690-1-mathieu.desnoyers%40efficios.com


