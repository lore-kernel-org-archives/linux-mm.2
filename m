Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 621D3CC6B0F
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 10:06:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E05EE6B008A; Tue, 13 Oct 2026 06:06:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB6156B008C; Tue, 13 Oct 2026 06:06:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA48F6B0092; Tue, 13 Oct 2026 06:06:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9FA9E6B008A
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 06:06:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 04447160408
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 10:06:36 +0000 (UTC)
X-FDA: 85317173634.24.36A9180
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 59FA14000A
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 10:06:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bm5Rr0+o;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791885995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gU5utLVnwFgQmWLZFQ4HFSchng7Sy7XfB2Vr8rq8k3s=;
	b=RPtBqT5c5VnjDbOG5UAmV8uv8s2x5VpTuZw0aFAOS8zTr2fetE0g8BnJh72j38rpBfafDZ
	Soc1DxN5dHYVvdhxgQti+jUWxZm1NDfGHgiEo8U6i1Jned4tL0Fcopbig6lWjfT0MrwIsn
	Sbt3lF9a3hXh8i12GBPA6UGXJFLgJ40=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bm5Rr0+o;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791885995;
	b=532ys+JzadxhsjygR8A2WW5tlz/Vm8EyaUm9FJLEeOK1o3cIRaoJa9Ct18mDbq0Xh2fRZ9
	QuN3AdnZpryl1/hiIRnd7sLJdK1OBrGMfTEQDF21UHhQVKw29m37vKQItOJIxu41qENTLK
	IQdaII1JMhPMpMDNSy2G2bhoXihxUa4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8462D415CA;
	Tue, 13 Oct 2026 10:06:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 287461F000FF;
	Tue, 13 Oct 2026 10:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791885994;
	bh=gU5utLVnwFgQmWLZFQ4HFSchng7Sy7XfB2Vr8rq8k3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bm5Rr0+ol4pjiJzwi/GQKJ0ntegEVZPrz4cJnarSTTrO2k5Etyt/wleY5J38Ll9d3
	 4XNROqEiPrx7zUF3rOmVGAi08whzPjLZoLyItDQukcM4GczFOp0rERJ9Vd4737LeQu
	 FuHeXWHT+swUu4L7Eb1fb+bi54KfTLOAXebsIXVAS460rKVp82oAHQRbL0606tkr2J
	 wEZEN7tLiPwGNYTjRo6Rrlqe0aCg5RLB8qMfWcwHq4G6A8Es1LI1uy41aUF7+oerkv
	 BvFUMMHP0u7GRBvfEujf/sMCaRuDCErqPAtbDKwvEsz+JGvGNAnKFcvf2GYIvymRrn
	 UsuItD5TgJMIA==
From: Mike Rapoport <rppt@kernel.org>
To: dmatlack@google.com,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Tarun Sahu <tarunsahu@google.com>
Cc: Mike Rapoport <rppt@kernel.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] memblock: drop for_each_memblock_type() and open code its users
Date: Tue, 13 Oct 2026 13:06:27 +0300
Message-ID: <179188590478.4188181.17324869307973975022.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261008190828.3221718-1-tarunsahu@google.com>
References: <20261008190828.3221718-1-tarunsahu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 59FA14000A
X-Rspam-User: 
X-Stat-Signature: 896sgshcqfpi9pcs9tczmdrt6m58fi5k
X-HE-Tag: 1791885995-413628
X-HE-Meta: U2FsdGVkX18VNuVXKZ8kh7K5SJ1oMKTGca8x6pjj/EiETtCJLGMjhR2pUEFLLJv8gHtRi151Cf7B3Gz+6DWwRjgQyE/PGexrpZ9KSVmNLRCJODjCNEb0juB+1lpzXz42pLR3oCCH6iRJRGfwNBZGkDRD6HIJG6VvZp1emO3RxTNJ6Shiv6wlgLti4fgV7cF19676G42mA/0EHoiWWzCBh+VuZ5PNv4sk10lmRk139h7YOXV6WxZTb7rq+BzRsSmSLYheJmbsl7N/Iuzgi/zLCHbXKTnCR1rCP2pNRNSLdbquKyj4cYYoFXdQtVDv8NwyxBuEg8/3bLK1BJZMsMvreqoXT4L4WHTU1XczgkAKj92s5FsHo3mOuQ5d2Ic88a76lIWccRRVh3cUJkMNT1doEmmMMkUn23bNzyM9WAwuwPCmoXKHsID+CFhnQj2FZtGBG9xhtHdYghOnjG6O2e5RyQzC+9vUAEygC/aM5Vh0YOcu3/k5+IN4kSmO0JHc6RO00it7Bz/0r/cldgDi+JtEPpAw4vfRkfdBRXdXx97QjdHUFEX24CPp3SwnhPamtUKVzpo8nUKmUrWi+UDJCxaNK5abPF/IkA0WBpM9QiKVNPESkfTIP8LDBvzYM/4wyTu+acrkl68dFZg3l6m7EpdqjYO2MkUfbmUKgmDgx6l37L9c+QaxhGy/UeZlkwVOkUm4/MP636yB+QdCuGhKi5+H1/zy1slxUhSwGoxQARKciB6fIelQ/q4i4loYaqLW7bM0Uli+FatOC26zCyZSCrjIsRrc5uF07SzsOwx6mKuhDhjJCthCs0YqeLXwcAU5xo92NXUPnt4hEudvsMYTXWzTUmvdeooWi8sgaHeXSHhwFWrLEbw8vsdar7sdVrdarA2HNE2VTTX7Xhr0AW5hfJy/xZU+ualzInmzzq1tVxzDf0VlSLgP4gfWLFVxy1em3ZfJg8/ZdoIlPNVaKmOhVns
 K7PLcjMF
 /X1poII9W3RzaQOqtSzIaI8wYY52cknvC/+oczrroMFqw5WZ2nj9Aw6HfoNDd8lI8XErUF6nz8wtj3KnJczT1NCYsDCXR4rqiKKNbscJYQGoPqwef2UqdHo65+rmacOxnSAARrr9Ni1RcSpzWB1m64EAKAmmQiKkPT8+mkZd82Z6rCJN+9+bIqyBuhYNHMxXNHXrAyPdwTkyCYfr49ZFIfA49Iw8zrCQLCK084rTCS77Y5OJ8Mf8EMyj94rqemPPC5X+f8JQiI0/J/Hz6qWOOyAKJdEk3SmvxnWv9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

On Thu, 08 Oct 2026 19:08:27 +0000, Tarun Sahu wrote:
> for_each_memblock_type() always starts the iteration at index 0 and its
> body is a trivial 'for' loop, so it hides very little. It also gets in
> the way of iterating from an arbitrary index, which the next patch
> needs.
> 
> Remove the macro and open code its three users: memblock_add_range(),
> memblock_isolate_range() and memblock_dump(). While at it, move the
> region pointer into the loop body scope.
> 
> [...]

Applied to for-next branch of memblock.git tree, thanks!

[1/2] memblock: drop for_each_memblock_type() and open code its users
      commit: aedb8dde08f8cd93ce1cc3a23273f2ff7238f832
[2/2] memblock: use binary search to locate candidate regions
      commit: 7a3477ec5793ab8c25be4db3e7dfe8a461bc775c

tree: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock
branch: for-next

--
Sincerely yours,
Mike.


