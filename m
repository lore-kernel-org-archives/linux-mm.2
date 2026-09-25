Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3C70C98325
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 15:30:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 870F26B008C; Fri, 25 Sep 2026 11:30:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 821656B0092; Fri, 25 Sep 2026 11:30:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7378E6B0093; Fri, 25 Sep 2026 11:30:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 412506B008C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 11:30:52 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9E376A6AF1
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 15:30:51 +0000 (UTC)
X-FDA: 85252672302.01.A8AC5AE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id E203A1A0006
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 15:30:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ocKGoS7N;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790350249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CR/C+cs2zl5Jt3ClpZFmEiihTiP2YZT1I9/49Mhx+qY=;
	b=5CdhR9RdU4XRyWkFoSq0S1rrpPCU048yQO3K4o/G1ScusWCEbUFPh3WJNp7eEPy2dZmn7s
	Algc+HSVHSr2tcD2NysGB5dkS96YAowG3qPmKCAzIwfr3QSlXovgo5nDv+jrY32KYxtBkl
	0iyaIPRxHBi+2x9C1tMyVqKkn4RqBzc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ocKGoS7N;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790350249;
	b=F/eaJwN1STgk+Qoe4j921nl6K5AFHNhWBcMGVq03ZMIQyWiuUaazQmmemt10cA1sT/TaLQ
	2atz7/UDkm95M7A2cAGvCUI/gvXg1nmYZaBFLoNjeQYyhJRcv4P0hXX0E3bm0pN37SUNoS
	ONAOPSuB8E0bD55KEE0XiwPrgGocxP8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 236D740E05;
	Fri, 25 Sep 2026 15:30:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 382B91F000FF;
	Fri, 25 Sep 2026 15:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790350249;
	bh=CR/C+cs2zl5Jt3ClpZFmEiihTiP2YZT1I9/49Mhx+qY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=ocKGoS7N+MWhkj7FfSY5L+lMrSHb/K3Dj/KT/kMDgP8edyH/RZFFyMCQPI8SyU81d
	 zysagF130aWIY2lRIa6ESs5WEAFnKMY6TRp3ejHTEfXyjqWoZxUvKsKsXba6IsZCdd
	 4gWNFRJis4RNv5mY40KCiRK4DYtaLCMyiLgyaRAwbxheJM6bkVAiSHU4rTIGUaAqz5
	 /JoeUxW6oiS15vhUBpFlYYY6kdaHaEZJAdBZ/53iF7pKSgBZyGubc3rJ8+5iGfymc5
	 AR420lNZaiFRqHNnoMlfj+AaX+BSWoRj5yf2SnBUidcaIS6JdRlsL12pLaDmycq9EL
	 9gTjCXYQlhl6Q==
From: Christian Brauner <brauner@kernel.org>
To: David Howells <dhowells@redhat.com>, Paulo Alcantara <pc@manguebit.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>
Cc: netfs@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Erhard Furtner <erhard_f@mailbox.org>, stable@vger.kernel.org
In-Reply-To: <20260923063759.34667-1-hao.ge@linux.dev>
References: <20260923063759.34667-1-hao.ge@linux.dev>
Subject: Re: [PATCH v2] netfs: Fix missing alloc tagging of direct mempool
 allocations
Message-Id: <20260925-murrt-kolibri-skeptiker-f6aed7d7a0ae@brauner>
Date: Fri, 25 Sep 2026 17:30:41 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=894; i=brauner@kernel.org;
 h=from:subject:message-id; bh=dY/RqwsLlvaqaqIVDLHTNvPGIdn2+AbvEIcmdODh7WQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRtm7y4WeNQcEONvYaLTtbNKCFp54SO4N+/7+mwMUmHl
 kjad3J3lLIwiHExyIopsji0m4TLLeep2GyUqQEzh5UJZAgDF6cATORKKiPDQtPLsv9C9F7adosb
 LdgYr3o1+Yd69EFPjsCz4pxfpc9tYvgfpFl3uVS4RqDgUSMXf7d/h+I25YCvfz9wyq75IffvcRo
 PAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E203A1A0006
X-Stat-Signature: j1xightnksrrzatcfcjzxh9jqp7ereta
X-Rspam-User: 
X-HE-Tag: 1790350249-167487
X-HE-Meta: U2FsdGVkX19MIo4YWl3QYx1TQgZyKRSYNNFFGadBK5URoENhrdjaG/nZW4qaiC6/zXnXuH97iAMq74icc7R0LaNjWUBKanXfpdIiMQ+GfhScv5X6ArT3UMBNYGomz6mx4JFp6CkjkkBPfrt6eabQIkgER06JZeCxXtL/p1oXB9aak/pYnFh78AYB+L7Ptr8NsT/1M+RGRG1u20IpgE5MYSCV8bQb2HJBfjyWNKC1bX4kTebTsBV9ZoMvh+2Uh7hpYHI1SWIVlnJFOXBFAb8Fs8U7rLvnl+lT/w2eB1aCICYbIi6J4PpU/hH5Z9kV1uSrkxr4eLxpd8HhGeHtf278iwrj2Lqfnf2xF2MNj3VUKX8CPLvePlvM0+ci/T4XEsILdL/6/yRlDBncTy+eACXPK6tXTZcxGQhKn9iS1uHvWrCUSy5YhGZJTDtzv3bphYNhXUVH89TztVPm8qyzjLtpzUDkSyWVREKhdVn8GmVJtQbgOc0vUpgjgKcpnXnJS76Jo3657BOrNhdjoshR/4K8s5YrjhiJx3AR8bc1+CThW1jYd8VAxs9H2Z/CqxwyKcQ8inh92lcg8JU0XHrHEZ1P92CNOPZe+6RiThXG5RSSUmO0v1rQklbr+gH0CdKQnfO9L8WCFmLDTOAieytXkSvCMjQrrirIrybfYGimL1VFY2UP1yUwEJA5Mbul6UyW0GuTxQkBxqgDEOYt7orCEHsMkkjARZ6lIIzlv1QoJEvCE2lo2oDshlShjSDzaa56tjL9RYiRlvihNjCa7DFTmbqCh8QljjTMB61IJCx7JLDcRi5oLiJhgVSnIV6mUrq9gHg7rDUzMlsnUNK5folEQdXurUYF/9F5RCig7LcUPntN2PG1qti/lucvZk9av3Qb6JRZKwXay12uVLSj2HQm1dDHB7kLx/XCS5ClkzO/4GgmCse/K7TQT7MaqNl6UG8k27pBehyhF6cAFxBMHToup+1
 e+IZTT9b
 USYe8uEI8jvzY0dSrBVdKcjfZr68kjAo/4L1STkyJiU1sH1opQarYKONvzCwFG5HBLOj2tKqY72fbdFestOqAGS5CLa7V4yRwbVMkPqpxsa9mRkPagLrqNNJT46wk59Gjij+zxleGGs+xoGTPfao0obeobte/BueaR46eYxrNxl6M84B5O2LoqJ5Je4HZc3zgz0gA3n/gqBRgS4PDiRiSZNAKvO7U5XuXJi4NjU3TOglMbHatzBkCh3OL/dmCgdm+r/la1nXXoIEgky5gQtPepAJ0qBqLBU0e6wip
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 23 Sep 2026 14:37:59 +0800, Hao Ge wrote:
> netfs: Fix missing alloc tagging of direct mempool allocations

Applied to the vfs.fixes branch of the vfs/vfs.git tree.
Patches in the vfs.fixes branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs.fixes

[1/1] netfs: Fix missing alloc tagging of direct mempool allocations
      https://git.kernel.org/vfs/vfs/c/b78b728e21c3


