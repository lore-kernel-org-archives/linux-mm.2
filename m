Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED7ABCDE00C
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 00:04:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B47906B00D4; Thu, 25 Jun 2026 20:04:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD13B6B00D6; Thu, 25 Jun 2026 20:04:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C1C56B00D7; Thu, 25 Jun 2026 20:04:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 72DF06B00D4
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 20:04:53 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A0C951A02C9
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:04:52 +0000 (UTC)
X-FDA: 84920118024.08.1C67A61
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1E53AA000B
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:04:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aOv30WBT;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782432291;
	b=7DIrhRWPfTBn7p85Yyqwp7+s4jhQc6GS6MybgEY2SUEc0Wt/Wnsa9hCrgKwvNjFwPub2b7
	pkmLpIcDDTzF/cHhymPgPTwtYKkWV5mDmmCtz5JeFMZNyE5NwiZhQvyYi8oYKV5O88xnA7
	WxuQG2XuYH2ATtZHCh5u+pTuS1yc1RI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782432291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9n4GXrjO0+9RUKqhp2Kca03H3bpbAY2nECwzkDNb0jY=;
	b=8K+xrQ8pUvt4Lhp41CfI52CVLK7Mug5QjvknkFjVhxwuRSy2nIXqdj8w7+ikd17MYj9Bd1
	3O9+g27xnH47d34amGQEui2Qre8RrG/JY5ldqEdHNFiVyBKFa/HBTjRNMZwrCNwgA5lEgM
	rG9YgSH7Y2jSf8TGbxlhQmQwhlV9toA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aOv30WBT;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A3EFA60122;
	Fri, 26 Jun 2026 00:04:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D991F00A3A;
	Fri, 26 Jun 2026 00:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782432290;
	bh=9n4GXrjO0+9RUKqhp2Kca03H3bpbAY2nECwzkDNb0jY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aOv30WBTgjIAshL6Kp9br1NXtPKhasfWIYVInsO/zu46FZs0xO2i+WXZFQ1EBN06S
	 LuLDulrRTOyyUkdzy/wZ8GGfC0aOYVSCdHA8Hwng/7LSMNwBpz9CW7eSQLJFpG1yLZ
	 HKyjoNqTzBS7QTVNLXd8mNwmbgFdTEzCNW3zoH/FsFtPfrWvFWPCNSx6Om+STkPpPK
	 FOnkByTytajn/R1TgP7j2jRB7QhWexkDCKv6+P+V1fUXPQ00iFjZplXkoWv43jpaa9
	 uDqM+qJUmEtYa0qNFBZr0U2c4kQ5W5jHcyNP+sLgrGsrxXP3+4ysEntK8Pxw+S8xML
	 Px3Xvq9qhLuog==
From: SeongJae Park <sj@kernel.org>
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org
Subject: Re: [PATCH] docs: pagemap: fix flags location, member name and sample code
Date: Thu, 25 Jun 2026 17:04:38 -0700
Message-ID: <20260626000439.85062-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260625174447.24292-1-zenghui.yu@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: agtxy4ngm4wngxsjs1yo9rqf6yatwisi
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1E53AA000B
X-HE-Tag: 1782432291-932769
X-HE-Meta: U2FsdGVkX188dqbv8rY6Z1A/Sl6E9yUgp78wKrabFeVVnl6jjCr1w9d4ryDNsvreV8R7X0/548htAPciDkUM2SjJ1gUVTHpCjUH4NxbXTyKCzSLgFtjVCLzhxgLNcckv0WhZ8ktQd7svVAFl66E7TeYlYtMy6vAxuOSXtM/G3Rng2RfKDPz1Mx8iIYgCbmWM3QEKbS4YjZNdm/4i6yWHnu2O+W0UPVJTUJhOdQsloTdtqHYNWWbE0kbkluP8/dyLbAZ1UkaQkI1sef8pzNltdFzQKPdSVymNOZ8kpyTVsLFMa0BFoKmrS7ABMIzrdU2NMffIkXVPao34zzjRsz9GCbuSJbWFJc+5KdUAuD3qk5SCdNYi594WjXL3UFb5/hdlHsmiHWYmwYQbPGVqtiUyCp9H+0gugFOIj7dc1XM29CjGPpMiZgWe2pxUo2G2DJ+x7lStqIZ1H3rh7lctOwM5bZlkh+O1NHi2i8U4OVe2xlvnCUt3quo/8ncpvLsogQWTIWGWjZEwwG+JEkyiionLmzxcvWzTJEJar4xH4Lg4qnPiaqGC4mOCwAhcJ2JgMD/TVGtTgwj7U1PnI3RQNU1NUSeKaQ/7kM8MamEfT6H+qrnIal3pyEk7LkvAFMLLPZeBqFZ4cc/2gHJh4NDqbefC8TtECyHUsme/4vX3KrDCNaVjA6eKQWj9BQQqMV2TpJ+PzZNPksVHDW8B9Dlx9EOr+yb0n7LwhvGoyNBPSooWhdRj0n/wIZ/iPl6O02p+7KatUbBzb9Ik4IEnU/dIDQWemWgfwwqKfoL+htOLJVxMjEXvkUfsXFdAHQ0qTg6f/En3KXChza7uPTV0keL7BIxOQShBCKD0/M8zRJ/Ib8OGeZ6/Eiz3jT/p192h9+RdBkMElMWET7/bbXJL1fjvZcg0/K3t+qv4RaQ2ZuKPdrThiY3ex+l8slc8cQazIAkGWIu1Hbu4Jb0F7cynpVq4x1G
 W0Pe8Lsx
 0zSTF9ODuj9Kt0OBVgFULGbGccLcOkoOwsT2C3XVomSE7YNFVAqkSsXNE9s+nuMqA0lohQ+9v7y3yyi6hv2/u8T2bTLBUGbWxE7p8RWe+QXeqAnAoK8SrtXH/5318TJ8Uk4obMXzPMwcxntOVIyPGPiWGk5fRP+tbepVj3vnv5SdEcGQVc/8N/wnvfv0255U+r6UcouG89WKe3ediIddtRQ42fEVMzZKcB8H1MGJWDdqC2yo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 26 Jun 2026 01:44:47 +0800 Zenghui Yu <zenghui.yu@linux.dev> wrote:

> The userland visible page flags (KPF_*) were initially moved to
> include/linux/kernel-page-flags.h in commit 1a9b5b7fe0c5 ("mm: export
> stable page flags"), and later moved to
> include/uapi/linux/kernel-page-flags.h in commit 607ca46e97a1 ("UAPI:
> (Scripted) Disintegrate include/linux"). Upadte the doc to reflect the
> current location of these flags.
> 
> The member @walk_end of struct pm_scan_arg {} was wrongly written as
> "end_walk".
> 
> The first sample code of the PAGEMAP_SCAN ioctl wrongly used the
> PM_SCAN_CHECK_WPASYNC flag twice, instead of the PM_SCAN_WP_MATCHING flag.
> The second one missed PAGE_IS_FILE in the required mask.
> 
> Fix them all together.

Looks good to me, thank you!

> 
> Signed-off-by: Zenghui Yu <zenghui.yu@linux.dev>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

