Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8CC6F9EDDB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 14:30:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E57276B0088; Wed, 22 Apr 2026 10:30:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E08806B008A; Wed, 22 Apr 2026 10:30:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1DB36B008C; Wed, 22 Apr 2026 10:30:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BDF186B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 10:30:18 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6EFF81601E3
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 14:30:18 +0000 (UTC)
X-FDA: 84686426916.05.417DF19
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 141B4100006
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 14:30:14 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XsS4Z1Mk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776868215; a=rsa-sha256;
	cv=none;
	b=Mo6b4lfmTaybaAlIwTgFc/12EMc8ikzt6Ay/QtF5h4p2BE45EGWCZ9iIGn+wTmuGdOZ7+8
	gQQlewUHMgDP6o8/EgKdXMo0/lPiy6WwjFdB0GGWobG9D16ByUVIPhhCExZFGbBjCiQ4WI
	HjORaqVFhxfr0kXrCleWZfMR3v+pHUo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XsS4Z1Mk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776868215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gxmvri1vydfPT1cQguH0c/J39KhdX4jCvPohLNl42p4=;
	b=m4k61ONZ8ICLFPx1tWJdIkLN37kPVXPvM9SXTVslzphyXzeg8BW4fs0FrVEXdp/WZdavqJ
	pp1Zxtg1r4JbZxNfWKCuNDy6KpbyWKn81pR81N0SqjWmLX0Tjv5oREpfgB5VwPlBCB0qjj
	WdKA/2pm36PDBiGzDgn9YQc5677Qifc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C8956442D8;
	Wed, 22 Apr 2026 14:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91268C19425;
	Wed, 22 Apr 2026 14:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776868213;
	bh=+AApuSx3VUN8zmQL3aTVwqVWL1Kh6nlC5CEFRlMZEpE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XsS4Z1MkUUltQ9hnKB98bBEiDYfF1hFZ1JtMBSsNSRkS0ws1n3u+JLIYk+aKCoxrw
	 tMTbC/XcvqfEs8c5MLPIqgTD1uQnP90JwuT/Ys3zJd/lRDS+aj6qMZQHlynSYdD7Qj
	 hO2IDF8sG1Pz2bjCly+NVZn0qHGTVHishJIzjEwdpsx+e/PdmO8I+k/TF7lJtbhBpy
	 WppBjFM7VWAY8p2BReqnSNdMqu8t41/+iVe0IexXJpNMYI8fGHAOe1E7RSL59Dl+sl
	 zq3Fs+rLGdE6pylbwsxdjOaBPRzSBu0ch7KaS2ZacFkLJ8UVZ3HftBh38fMtWIrNE7
	 eNIBhZfBQ7UUg==
Message-ID: <214ca3ac-45b7-4131-86e5-ac134ab0bcbd@kernel.org>
Date: Wed, 22 Apr 2026 16:30:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 0/8] kvfree_rcu() improvements
Content-Language: en-US
To: "Harry Yoo (Oracle)" <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
 "Paul E . McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett
 <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>,
 Zqiang <qiang.zhang@linux.dev>, Steven Rostedt <rostedt@goodmis.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, rcu@vger.kernel.org,
 linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
References: <20260416091022.36823-1-harry@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260416091022.36823-1-harry@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 141B4100006
X-Rspamd-Server: rspam12
X-Stat-Signature: 1qme57csn15kjb5ngo6k33jans3n6jgp
X-Rspam-User: 
X-HE-Tag: 1776868214-319654
X-HE-Meta: U2FsdGVkX1+S1IOUi3IYsOteqSTbAUGKRh3BMDl6NO6gCT9HUzVrT6IKz3XSwDLV87jt3CFVKpVGnEECGlTVBc+KM7he3pzyUpQcQLM4RKM+aABitxBmXY0fiI9DC8VmpqiPV3V/BUmRy99CSXg5sNzv0qCTbdp/AAvZJOvyoFf6ZUln/HYA8Y2fOMRzuR780P3Kce9hWp+qy415huNB4p+INNAkqaVMn1quA0r3WlrN+3rPoRZkWICuTlEql+LkuEQbEsDOXc7HItekBiKH7QYl4LZeC0KWToyjwzWwopt0RhtrEiPP6rA9BhB0v0vEibdBvIFkK4mMjWzgeruUQ/thCmOi2X20brl8Rk8jKXkU1V+pxMEnu5IEspFa962v8+gmWJepCQ5O6it/L7Ch3VhVhi3xU8ejaACjJsEvK4iBYFFwR/6/jbGclYlrmHrYV5sSB67B/swcNUGMjoRG6U0/en884+e8X35F6r62gQo5RqtjwvMGbSSPLXVu5IkZIa6Jtf9QXmzny3DdUySMztGeUbs50r6fe5Qq0HdfASIH7E1Z+GuxDM9il+OWYgVCqGozvWvJVmo1fM/x74UVh8DyZyf/MXdC1Ab5kmrahST6gJd+yH8ZJFHY7WIWuFdkjt3lCx3/mXU4vtud8dOpKHLZhYucTSdJJdLLTcSm0IWJWfmnVKPtCIsrZVLqczkjqe4RHouCrCIHc7w0g3u39+mwUVs4l3lO8ktfXwC0adq2C2mk5fZH4gjSJcxn2/Davu616UY/fZ9az0QZ1Ly6mMGpWTeWWo59O+zMM1NPQOR390Oz/UzHo4EGGuzu1z4lTt+Kv+nSw2SAjDYlKsgvhXHEsW55ffXCLz1/sc9TspyzHfNBvkeLke0tcSOjD/XzfwrqA2AmJYTRkyStCP25MuETzdE/lIQbk23Hg0sQCDwTrzzezPfYg6gCEdYhIG74UEgI0U1yUDg68vWcvP+
 yUJdFIxJ
 PxpRRX5cwH7PRzwHWEeno0zNM4SeN0Oop74qw+4nvTdeKaQPXB1L9UYNXI+QGoe2HWyOSSJrn1Pu/5lO1TKhwyPZp/x+Ml53Aj4LvWDHOt9hUuXYb8UifvgmZLUYG+52BEZtTsUIIo0ac9K+seF1r3G7ocSg/Kl8xByQIkCJd0e8VjjQaF8SFWZ6ptJfw2iFjPIlobEjy/FSHqhREZBWiQESrsHGUesh4qkyrIGa76WToBTdzQ+2zk7kZ0+qdeS08QrxWwpVFY7vC8S5AfwYHwFjey/3RSsP8I+RcGnTeNln4IkUSCsBRG8267A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/16/26 11:10, Harry Yoo (Oracle) wrote:
> # Part 1. Allow an 8-byte field to be used as an alternative to
>   struct rcu_head for 2-argument kvfree_rcu()
>   (patches 1-2)
> 
> Technically, objects that are freed with k[v]free_rcu() need
> only one pointer to link objects, because we already know that
> the callback function is always kvfree(). For this purpose,
> struct rcu_head is unnecessarily large (16 bytes on 64-bit).
> 
> Allow a smaller, 8-byte field (of struct rcu_ptr type) to be used
> with k[v]free_rcu(). Let's save one pointer per slab object.
> 
> I have to admit that my naming skill isn't great; hopefully
> we'll come up with a better name than `struct rcu_ptr`.

"rcu_ptr" sounds too generic to me. Things like rcu_dereference() talk about
"RCU-protected pointer" and it could be misleading that "rcu_ptr" has
something to do with this. Only if Paul think it's ok :)
But maybe just "kvfree_rcu_head"? As IMHO It's an rcu_head specialized for
kvfree.

