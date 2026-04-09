Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 123E6F364B6
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 21:09:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D57156B0088; Thu,  9 Apr 2026 17:09:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2EA96B0089; Thu,  9 Apr 2026 17:09:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C44C26B008A; Thu,  9 Apr 2026 17:09:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AF7206B0088
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 17:09:23 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 10F3FC1125
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 21:09:23 +0000 (UTC)
X-FDA: 84640258206.28.B77967C
Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0F732180009
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 21:09:20 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm3 header.b=o2L2wXFF;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="T ogtoZr";
	spf=pass (imf24.hostedemail.com: domain of boris@bur.io designates 202.12.124.147 as permitted sender) smtp.mailfrom=boris@bur.io;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775768961; a=rsa-sha256;
	cv=none;
	b=myrMHd61fxyMkrTb/QtbHkI5Gv/J3QxH4ZLri3ZMJcZvrjUvj2MXejEFHNx0Ol95EoCYph
	iT0RDuAbk3gq9Qc5qeZI4FHgDk/YdtH4wrAe8QkuOGQgWRnOXCuqxbAvxueIJfBs7LtPMs
	6/k4jb2hdxbmZJSCmQfgiBZYYifDbo0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775768961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=MZunF1xN5zrge3JmcTJNc0v9YAdspsz5QhxRbtTKwcs=;
	b=T4Q7WO+yRCpfN2bnT17bMyanoPxhP/+TFgLoYd1w1vvQmDFqEYbdfGeUJxgESHS18ICRvx
	aFiLzoMP35tCCY3JENWSo2VPayzcRjS+PBqUi/uBEzFAdtF5cyxv6wOnX5VwMU4ebgfsEO
	a9PZ3w/100Ll4/rJ/4N3w8pi6aM/ZcE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm3 header.b=o2L2wXFF;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="T ogtoZr";
	spf=pass (imf24.hostedemail.com: domain of boris@bur.io designates 202.12.124.147 as permitted sender) smtp.mailfrom=boris@bur.io;
	dmarc=none
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.stl.internal (Postfix) with ESMTP id EF21C1D001C9;
	Thu,  9 Apr 2026 17:09:19 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Thu, 09 Apr 2026 17:09:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:message-id:mime-version:reply-to:subject:subject:to:to; s=fm3;
	 t=1775768959; x=1775855359; bh=MZunF1xN5zrge3JmcTJNc0v9YAdspsz5
	QhxRbtTKwcs=; b=o2L2wXFFkxCVBbna22tFAs8DtCjafPn77fvQX55BlUe5hyLZ
	am0LxTcNf4z5FFULlAgQwj317NreS6UcntlHscIfFJ207fiw61//jTdwozksAlGQ
	xRnOYKHcn209iRF7JlDzTaoQUKxoHhy00VAarAxwuWiO+AoVIsJjVYeEGt3c7ayq
	LagUC7sNf+kArBNw6IKEqmCIx6km3FBq4nispZBa9XiQImZiAIcJ32cCQsE5I1P0
	W+Pf+DoJH04S6FCRq9USSq2O6XCk3G+iHVKHYheavy7OLGQsB8bcuxr9OIow7oP9
	uuvMOqLN0tb8K5HhxbtGFmIQZ5oqjIrlH86EoQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:message-id
	:mime-version:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1775768959; x=
	1775855359; bh=MZunF1xN5zrge3JmcTJNc0v9YAdspsz5QhxRbtTKwcs=; b=T
	ogtoZrxkMyhClXEh8CIly+y8MXpCcoMJf41gxBmru+I386BL+Sde8gLeltuKzInU
	jExRog3UsF/G5/9V7+8VmL5dFxRvQaF4ntAYDx4n1/AIC9WqQYkA3tlaZO7E9J2z
	FYeBAwAQV62ouLfop/bPUq8qj+HsYi8iaBhj2irlsSSDhRbEg4/Fl3N4INVVIOvT
	buBGIXsXrTCn3KugrZ2M4nSvngBGfYxho25insJrD1ZkhDNxpOLYxzBrKKj1Uvyu
	P30/o7RilhbTffVJE88RnmSgKoBeST7v+yNhdTOiC4GVIq9H8oWSwthIMVY02sxR
	bt+ynAL/FrGZz9YRKHb6A==
X-ME-Sender: <xms:fxXYabRkq9CslWKeydbjtoR9P20h378nO2y2TLbomNrSYPs_N8kwpg>
    <xme:fxXYaYPm-REosQhquMp4ZPzu8XwPqfVJwBgaIH9rIaoQO_I8xQDOKKJJDkgvL3SMW
    blVEVVnl47AYLLRDw59HXUvzIN02LOO7ZBbIr-zaBLtOCcvUrTkWc2a>
X-ME-Received: <xmr:fxXYaUXrL88NJXiJoCdIbYyrf9VOm8enq-BR5SU-I1ck321gnudt9_G5P72aBlYorwFAymyP4NJ2HNlH6d6uBkAoATU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddvjeehgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhepfffhvfevuffkgggtugesthdtredttddtvd
    enucfhrhhomhepuehorhhishcuuehurhhkohhvuceosghorhhishessghurhdrihhoqeen
    ucggtffrrghtthgvrhhnpeduveeuteeufeefvefgtdeifeetgedvueefgfeuffelvefghf
    eijefgledtuefhieenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdihohhuthhusggv
    rdgtohhmnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epsghorhhishessghurhdrihhopdhnsggprhgtphhtthhopeegpdhmohguvgepshhmthhp
    ohhuthdprhgtphhtthhopehlihhnuhigqdhfshguvghvvghlsehvghgvrhdrkhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtoheplhhsfhdqphgtsehlihhsthhsrdhlihhnuhigqdhfohhu
    nhgurghtihhonhdrohhrghdprhgtphhtthhopehlihhnuhigqdhmmheskhhvrggtkhdroh
    hrghdprhgtphhtthhopehlihhnuhigqdgsthhrfhhssehvghgvrhdrkhgvrhhnvghlrdho
    rhhg
X-ME-Proxy: <xmx:fxXYafcQkBn3kzt5BaJu2kdJry-fMqsxpw1CAkSz4UFCQ5jnfaz7bA>
    <xmx:fxXYaQu2W8qMhERm3eTgoYgiRFfANb4VsXRg6hi_171RsLEk6Ebngw>
    <xmx:fxXYae-OX3BkObPDBmBGr1xIA2IvDGZWHL7a7JZaLNHBJqYZFxuCTw>
    <xmx:fxXYab1ShO5W28Sn5qoT5kCCCSCVIAQ30CHboTmO6E-b0UHWPval7w>
    <xmx:fxXYadnvMes_hzHxNipBwKkvFZnG_P6JjnV-HizTeu6ORW-EqQRe3W41>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 9 Apr 2026 17:09:18 -0400 (EDT)
Date: Thu, 9 Apr 2026 14:09:06 -0700
From: Boris Burkov <boris@bur.io>
To: linux-fsdevel@vger.kernel.org
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org,
	linux-btrfs@vger.kernel.org
Subject: [LSF/MM/BPF TOPIC] Direct Reclaim and Filesystems
Message-ID: <20260409210906.GA881465@zen.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0F732180009
X-Stat-Signature: 4smf14e3jfdayksa8kfjkat9k7raz7e8
X-HE-Tag: 1775768960-956161
X-HE-Meta: U2FsdGVkX1/fXV9/RrAf92RfofGQC/FX2LCoBxKqbf/gO2pltexfumKLb4O2tBOVV6a7raOeD2LUA1kJ3IEcTmsqZY5g9hIvdTrxWZh3LZ94ABHG5XKJbiWVfPXYCsT9qupngURlu2fPetYDoBYzUBMl9tQWmT/x9ViYCZ+wFgpHSj9P7diab68hhKPLwSoQcqLkIrw65oir6A9xTeDksSGGyVS2zOf5gXzCEonIQpjsMPcrw5Gqpwbv9RBkpGhz91s2Vib0HtSsgf2m7uF7gaZBEBORC9QRaKmQxw+AHr5WlQ4s0lUqEJqIDEchCrKjgCFbF8ocmcl5MeVAuEPZ3J497qOW7euiI+Lno0o48IS0maVTujbM/9LoOdw8Q3vqg0SDBA31Aefxkq6RmezxejLXwuyS8Lqf+ntnfKKmw5dyEGp+AIGB8w7FFWyEQ7C5VlloP2m69QJbqfyHVBXOymSq4BDATzGN6P3DW2RsoTLtqBauXgc+BzXYxgUlO/E0zw0zf/fjXQT/ucjYHRCapqJdtRH05o6iNEpT6KDaVvgwox4iDhmUieXDMGBcVEc7hYi+Rvbgc3ShaPxFHkeUjWwVW7fjrAIbRuLo0Z7gtx/G/yJdo7iyXFgnS0faGp68za8GQiLVhHiXWt+VtjRb2fym2dhY3lGjY6btm9KaEx+xrlGdcDJ9RHZtx5zUjwPFHjvroyYVxjipn27vPpZjY9zLUMkx8dPJ4QxsTQYslzH130BmHR5AXNBM30T9JLr0+Mf5uT3m4boqE+zFPLIHa4VgsXwuDeUhjNjCt5P2j6MlCbfavyBRNyp19iEGmL+ER07QVJnFg+QTE70uErjxRmzCVISejPwPU2TGWjnm8z58t4X2ozFiaIMtkZvg6crkS2FlTQyfn/IqvUrLStDTEM7Dfbre743BFKm82JlDTfVI62AQ8xxssY9/L//pwxJku2+EifPo7OXQF3R3d3n
 ioIQAbPC
 HOxYbq4ta5mPmAPoZR9h8bN1Y740U1CENY9IbLg0A4nRbuX3f8kd8eP/TupwWW0psjcEJ9xlBMEjMwJ6U3hUBUQeQ+Q7jUhZHdVZ4rs/8rZi10JA6lBgBAwbmD1UOfx/LmMsN+r+FBc2Pf1U+36NVWxYR8y9EMFJN6PFzTTwlIVeu2ZaBiLQIJRcpPnZ3SfBDtQHncDVsGp4rvsDgoGsZC1ZJfVnOxtcOR+fFjvlkUKgXF4STqBUtVIJjF80dPv/30v11m5+kaosB6E5nrKhOIjULAGh3AXBURJZpqnNEKcnEitrKYLCfB1S9YplRWj7bqVvzfM0EgxZ8GoXFPiaM9gNPzxyOb2JUrBxxkZK4U1XeirpcfG5SNV7u/SKMgOToBjehwjxljTR/xWOrHi8Nk1bQQ5ZqXBxVMrZu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

A theme that we (Shakeel, JP, I, and others at Meta) have observed in the fleet
at Meta is a tension between btrfs and direct reclaim. This has manifested in a
variety of different ways. All situations also must be considered w.r.t. memcg
reclaim and global reclaim. There is no overall "assignment of blame" intended,
just a desire to build a deeper understanding of best practices and paths
forward for all the components involved. I work on BTRFS and have minimal direct
experience with how other filesystems besides btrfs handle such challenges, but
I imagine there must be some overlap in challenges.

I think this is probably too large a topic for a single session, but I am
curious if any of the categories of issues are broadly interesting. I
personally think the one that cuts across the groups the most is the question
of reclaim cpu usage.

- The filesystem triggering direct reclaim [2]
Especially when the filesystem is holding a lock like the inode rwsem or
a filesystem internal lock (like the btrfs btree locks), this results in
unexpectedly high latency for the filesystem user, and in the case of memcg
reclaim and held locks, will unfairly affect the latency of other cgroups not
under reclaim. We are working on categorizing these and reducing them case by
case, but a clearer statement about valid allocation contexts and GFP flags
could be broadly useful.

- Reclaim freeing metadata and/or forcing metadata writeback [1][3][4]
In btrfs, this results in redundant work fetching and writing btree nodes if
it happens to hot nodes in the btree. Should we be trying to lock some of
these nodes down from reclaim? If so, how many is appropriate/safe?

- High reclaim CPU usage [1][4][6]
It is possible to rapidly generate a very large amount of direct reclaim, for
example by doing parallel page cache reads larger than the cgroup limit from
many tasks in a memory.[high|max] constrained cgroup. This will then use a great
deal of CPU attempting to do the direct reclaim. This CPU usage can become so
extreme, and can be emphasized with cpuset cgroups, that we end up being unable
to schedule tasks holding important shared locks and massively tank the
throughput of the system. I have been able to reproduce conditions where even
killing the offending cgroup can take minutes. Some crude early experiments have
shown that throttling the reclaim cpu usage reduces the intensity of some of
these problems. Can this also be attacked via cgroup cpu throttling? Proxy
execution? What about the same issues under significant global direct reclaim?

- Filesystem doing expensive work while in direct reclaim [5]
In BTRFS, compression can result in relatively expensive work while trying to do
writeback urgently. Jan brought up issues around synchronous expensive work in
inode reclaim as an LSF/MM/BPF topic already.

Thanks for reading and thanks in advance for any feedback and thoughts,
Boris

Links:
[1] btrfs memcg accounting separation (AS_KERNEL_FILE)
https://lore.kernel.org/linux-btrfs/f09c4e2c90351d4cb30a1969f7a863b9238bd291.1755812945.git.boris@bur.io/
[2] btrfs readahead direct reclaim reduction
https://lore.kernel.org/linux-btrfs/9fd974c2-00aa-4906-8cab-ec0d85750c4b@gmx.com/
[3] btrfs re-cowing inhibition
https://lore.kernel.org/linux-btrfs/cover.1772097864.git.loemra.dev@gmail.com/
[4] btrfs csum tree write locking reduction
Link: https://lore.kernel.org/linux-btrfs/aa5a3d849cb093a767e08616258c03c7eec8fe26.1753806780.git.boris@bur.io/#r
[5] Jan Kara's proposal to discuss complex cleanup in reclaim
https://lore.kernel.org/linux-fsdevel/c18f8189b755c13064f51d93bfcaddb15300f9f8.camel@kernel.org/T/#m319eb6245485bb7c71171a55bf700cc1409a144d
[6] LPC previous discussion of cpu hogging and locks (unrelated to reclaim).
https://www.youtube.com/watch?v=_N-nXJHiDNo

