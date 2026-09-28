Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB743CA5FA1
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 22:13:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA0DE6B008A; Mon, 28 Sep 2026 18:13:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A51D06B008C; Mon, 28 Sep 2026 18:13:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9410B6B0092; Mon, 28 Sep 2026 18:13:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F5E76B008A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 18:13:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 05AFE4033A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 22:13:53 +0000 (UTC)
X-FDA: 85264574346.10.88E5260
Received: from o1.ptr9745.em.honeycomb.io (o1.ptr9745.em.honeycomb.io [149.72.141.136])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1D78240004
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 22:13:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=honeycomb.io header.s=s1 header.b=xMqpEhE5;
	spf=pass (imf27.hostedemail.com: domain of "bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io" designates 149.72.141.136 as permitted sender) smtp.mailfrom="bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io";
	dmarc=pass (policy=quarantine) header.from=honeycomb.io
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790633631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LhPr/3N5CT4HP3diIFgEUTiiw9QHBmCdPdCTJgVnTTM=;
	b=c7copzlJvu6RSlnNaGN+IE+9CbrShp+erEWCL20Do/3Hn8wRmV51WOXH/03ifT8kdR6vsc
	TK9+xQVdN+Wjtef7KLRkNe6yEA3FXf+6U/ix/YFWovzKGFHfQyp4YiExqPq+zOg7h1innH
	6A1QvviweEZNhz0qerqCAAUG/3inlXU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790633631;
	b=PiVyTHQPScnHxPkfURDECSK+sysly2KEjCnmZFQocrw1natUPXawlB73yRE/DK9TKHqRhR
	R4nPMKbZNMSpNGEFK/vbxyibLAlAK3esPWEGUGM1FRUYhmL7m4J58oR+NNEx38TwWrXVph
	Z2izneb7gLiD87zIhM6/0FkRAGXTl/A=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=honeycomb.io header.s=s1 header.b=xMqpEhE5;
	spf=pass (imf27.hostedemail.com: domain of "bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io" designates 149.72.141.136 as permitted sender) smtp.mailfrom="bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io";
	dmarc=pass (policy=quarantine) header.from=honeycomb.io
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=honeycomb.io;
	h=from:subject:date:in-reply-to:references:mime-version:to:cc:
	content-type:content-transfer-encoding:cc:content-type:date:from:subject:to;
	s=s1; t=1790633630;
	bh=LhPr/3N5CT4HP3diIFgEUTiiw9QHBmCdPdCTJgVnTTM=;
	b=xMqpEhE5onvhmJUwCGRu0ueRhvnCyFfpSqVbzGhcC5+thgrQXTKMsshRzAxSO674H8GQ
	DlhWReUDbIZyOL34PQpjyiggwg2v7AyUl2a5zK84bPO7nrhTfgB0r/LhRqDdPjBB+RzSmP
	+G2Fl/768QVVZisel2lvZ8ypwMdx4SCKCIGuQBVIE9kRf7+UPNdGe1Yn3Hi3z7o1TD1xoW
	/XIoZrKn+/35VQ0cc65Ydgv/UXJPEWHVC4ERWIw77M3EcayT7GBZES5x/ECUrFxPmpFZxh
	gzGCHx2yocdZP5qWnKHUdh2O8WEkEWa1OF6R3l1b+i8vHbFeZ6ybaMlhcmtsiOMA==
Received: by recvd-canary-7bc664d96-rr7cp with SMTP id recvd-canary-7bc664d96-rr7cp-1-6ABAE69E-A
	2026-09-28 22:13:50.058278031 +0000 UTC m=+354514.976073350
Received: from daisy.dens.ffj.family (unknown)
	by geopod-ismtpd-13 (SG)
	with ESMTP
	id GsnC_o2GSBmkpLj7FchG8A
	Mon, 28 Sep 2026 22:13:50.000 +0000 (UTC)
From: Liz Fong-Jones <lizf@honeycomb.io>
Subject: Re: [PATCH] writeback: let foreign flushes reach dying cgwbs
Date: Mon, 28 Sep 2026 22:13:50 +0000 (UTC)
Message-ID: <20260928221349.1443179-1-lizf@honeycomb.io>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <ee85445f60194cfbc78897cb6fe744c7@kernel.org>
References: <20260926-wb-dying-cgwb-flush-v1-1-a8d898085a3a@honeycomb.io> <ee85445f60194cfbc78897cb6fe744c7@kernel.org>
MIME-Version: 1.0
X-SG-EID: 
 =?us-ascii?Q?u001=2ECuH7N2XAoeMR1zrzr=2F6NZrhli2vbKPOHff5fJuZuba6ZIE8QPyIf9mn4Y?=
 =?us-ascii?Q?ezqeFFjUkh=2FeROy4LtnO7KN9jZmeUC5kvTHBdlB?=
 =?us-ascii?Q?Y0OEXhZWKcE3XqZx=2F9VWoKqLYD00fyqtReTCMYv?=
 =?us-ascii?Q?qGuChLBBTQO4UfKoiNfWejExKSbUBMct5f6O6dr?=
 =?us-ascii?Q?D4rPhhPzCiXt5TB7HUQhj=2FT+roolQCgOOYVm7=2F2?=
 =?us-ascii?Q?p1heEPv=2FP+0PEnmwNeH3ucTQsvbkEByecGsHV2B?= =?us-ascii?Q?p8yB?=
To: Tejun Heo <tj@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner
	<hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
	<shakeel.butt@linux.dev>, Xin Yin <yinxin.x@bytedance.com>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, ian@honeycomb.io, stable@vger.kernel.org
X-Entity-ID: u001.GRlkmHQ+Ka/CKxmoC/CxTw==
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1D78240004
X-Stat-Signature: bmhqdx64nsrs7bwseydpmnffbubdx8uf
X-Rspam-User: 
X-HE-Tag: 1790633630-939354
X-HE-Meta: U2FsdGVkX19w7KXrt3NbWhFVDk5tyTxpOo2rXWFk1qtx/W1d/QjRZ6vqxDlvI2jPAFNkiyEqWXDO7zH4YVufjy8TiXZmkJ7AMvT193oMDKx8tj2Cnj3h+CT7VbrlsfmK2WFQRCyKyQjHlS29L+bRpKnIO++dOKfHwezCfQildLkWl6W1iBlS9x3S/rEPbNLSrm1VqbyNyBtNMEeqRxJ+/i6wbQBBI/IBTf2im5yFlzAu08zjGQHE4wV5GtiMw8x/dTwNnp19vkZWLWA4JS55DmYP945oGnug87goaofaIyuTFJramlUctaDwxrMOGnWIYIGupPUbBVKtYMd/RhKiK7ljVieVlLg/7LQjz8iWhhfvq6wRJ3p5BjDK79p8eggzJ64ZQOffrGFtemQ3+AR108YQr7PInU3IQ+2BfpMw64ABWImTW9nhKE3kbR9qQSB6StNMDfQOWbloUoFnCIofNS2WBr4rZsancx2b1cnvcj4o5n+aXIsOY1hFy0imKAWv29q3OpBfPvYYpwm8lXNqcPGdCik1cRkDhwrR0kVF8ChbpRSw8eX+VFFQqtIk/3zMERB9/VHGsLbMGn5c0hWqvrB8ex8sSaWGlv+hPafztqmb8CUEh512XblXokR7lJl90PkLo4VQMnWk1S/KbvBkKFg/Y6guobBnLIlystp612sj/7tb2bdYUtTc3/eXnQ2vQr18ee8bQTikApAUBdy2fYZw9C/M/SULWQuLYNJ45y/ugwxOU3zRB4psJ1m52ZBAJ6CJTtqjfmTMRmGzt1B/3+oce2ZbjOMa/PimyvGObLpUO/U1+UhLPTTg7/p/fsQz4/iJBOa+pL9/nif1J5nrJdUTnGP8pCgm9QBc934kNIyU1uOjEZ8F9LV1XPf40JLymeGBf+HHsx8573LSFxpmv1khRKkVqZ9ykfn7vJuhLCddTlaxhZhR8bZj+x+LVFX3ieQi11n0P316cIDsuAm
 g7OlSe/1
 vksSlkZ1RJibT2Mog8MLacIIbNUVpnGgMy9vcO1/e57t4Uk/lvxWqLzMwEvnXIrXDJfxmO9kzoGC2PrOWM7oVRf6ERyN3dOJEXGdwfDGEqtZT6PhOcJSk8KPUlEaaTM2zphHegmTLH7EsrfC3oLZ0W8/6YG2tfyCjcU08ImanIci3yRN5a6TamhPg4ybeAtqw4MMTv+IcPshbAV8shP4JkFDUJc3ztKTvbcNPde1FqL8PLiaoLJbGmwnmvROoiZLUctTKemA4DbfbPV4GbhD6YH/IzeH4WP5wpvCWUnqutJUPbZFCk5ehX4Wtth46nj6dU1iu7wdwEcyJE8eHxA2mfsLSUuz/neQhpl6ZG/+jhAnHyxvovBqS8OfMWYQjDBJqkSI4F2jp12D0NXnkcpL7VZ0+4viQwWFATWdPIRF8ehaB9nPDnrnv2EC9BxhmLyVf9PXEsu4jKJxT7PcUBzJszlbrddYnvu+ihmN8P0cn0G2ov8oD+MEd4et32nfguhGW1P9C6hIoN2iOVa7F8Ds7BIYB4ucjO238EbAVIfVYagRkd59tG70unCiheWIYn+imnRSI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Tejun,

On Mon, Sep 28, 2026 at 09:19:37AM -1000, Tejun Heo wrote:
> Instead of walking bdi->wb_list, can't we update the lifetime rule so that
> a wb stays on bdi->cgwb_tree until it's actually released? That is, remove
> it from the tree in cgwb_release_workfn() instead of cgwb_kill() and have
> the creation paths skip dying wbs. cgroup_writeback_by_id() would then
> find the dying wb through the regular lookup.

Yes, that's cleaner, thanks for the suggestion. Implemented in v2:
https://lore.kernel.org/all/20260928-wb-dying-cgwb-flush-v2-1-56b54cda74f2@honeycomb.io/

One edge case: a live memcg whose blkcg association changes needs a new
wb in the same slot while the killed one is still there, so
cgwb_create() takes over a dying wb's slot and cgwb_release_workfn()
uses radix_tree_delete_item() to only remove a wb that still owns it.
cgwb_bdi_unregister() skips dying wbs so they aren't killed twice.

> Note that the blkcg association check in wb_get_lookup() would have to
> move to the creation side.

Done, along with a wb_tryget_live() for the creation paths, including
wb_get_create_current().

> I don't think this qualifies as a fix. Can you drop the Fixes: and stable
> tags?

Dropped in v2. I'd tagged it because foreign flushes can't reach the
owning wb in exactly the case where its memcg has gone away, which
looked like a bug in the original implementation. But we avoided it in
userspace by syncing after the old container's last write, so agreed, it
doesn't need to go to stable.

Thanks,
Liz

