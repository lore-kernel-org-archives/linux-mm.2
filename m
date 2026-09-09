Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F991C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 14:43:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB92B6B0098; Wed,  9 Sep 2026 10:43:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A909D6B0099; Wed,  9 Sep 2026 10:43:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CDDA6B009B; Wed,  9 Sep 2026 10:43:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 81D676B0098
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:43:20 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E33161C1125
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:43:19 +0000 (UTC)
X-FDA: 85194491718.05.5FCE644
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4888114000B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:43:18 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dGNXFG3q;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788964998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c1hwgXWxZ0ZvoTcNt6lGAe9EqL9kR6PwfvJHBh/+4Zw=;
	b=PZ609ZmD+UKRXEbfkRi+hq9n9bmYqsULJN6+zBKDgo8T0+p2xW11TTeP7j3ykAbCZ/UhVq
	TsVjUYJe7d92dj6J5PyCtFWjcHk6W8XcA0R4BYfMQ1vw9GhlIvWQIzYnU9toR/YRpf/MCl
	lnxVisrFLEZEyDJmc65Ws/lCiQ49R90=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dGNXFG3q;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788964998;
	b=wnPaSjHMdv7TGuuHt1kKJX9deYR5JPTAp7isqgoBmTpenM5ESBtIQhh+1IbDyXSjvJJdsk
	FoOYKuHrBog9GGLN+pRDdCSXobJ7bnwEgRF95R/WfM0nVSOHa3MvNkZ+YznUlgtErfHzVe
	pMPW25sNjnaSpdtDEg4veXwwH7ZY0ZM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0C9444038E;
	Wed,  9 Sep 2026 14:43:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B39C21F00A3A;
	Wed,  9 Sep 2026 14:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788964996;
	bh=c1hwgXWxZ0ZvoTcNt6lGAe9EqL9kR6PwfvJHBh/+4Zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dGNXFG3qh6sPrMF71B38Ur31/d2qagzKp354yvPFIioxM5g9vP/re9IKijSXNnj/8
	 LY+eV/yOJCQ+3bagFO7MyuAEzUw7r4Ij1cmFNYxs51Uc8Ez4HhH+pQyrlBhb0m9irO
	 18ZEwF6FRT1Kr/qSNu0K+xF0a5L94WU1Wz/motRW15xwNxQ63je9sfYNHd/458jS0W
	 GGcdk81pW2iriyQai1ZY6F+oYxDHjf9hr4Y5HxJ9WjYWIOUQICLlRfbEtA7Qp0M6US
	 0sj8rl7EDb0JJGGyhKmh1MgPe5+eLJ/EgX5xBG1bmvs+PtmEqf5uXZF+Ty6BtxXEup
	 EjRLYhS1Q/hIQ==
From: SJ Park <sj@kernel.org>
To: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH REPOST 0/5] mm/damon/vaddr: support {prep,apply}_probes
Date: Wed,  9 Sep 2026 07:43:09 -0700
Message-ID: <20260909144310.107006-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <8f193651-9a6a-421b-91a7-df4a231786fd@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4888114000B
X-Stat-Signature: my7g1on3xj5a5887ykyjo6dbckzrnk1r
X-Rspam-User: 
X-HE-Tag: 1788964998-753017
X-HE-Meta: U2FsdGVkX1+3wT0hzJZH7VrTn5J3WJvgmi89ttPJVAkvxEp78ivb5yY1MR0Z7R8bc1ndPnGwnucDFGa69b6B0Yr2H3L0EQ8wkl1nqqUs0qbwJnf5giJ0dqPglJCU78reerJgFftVu77VsCzZzXOZ5SYp12K70DHfXEbKRuK+XWjaOXqWTfBMsFhSgBjlhRc9EL84WnYAqGSUwp3okOGfhfb2HtDcWvz/if68i6a/mb6H4C3hdDnagtltWQ3ev1xRH7EgugSOqFf/3RNXIz83kLoPFdoHAvtbksGFuEhwSMQ35dVKVn6+PGYCpCdXPHj/7rKNBqdnn9o2lc8Bc4IKm2EFS2mpUanU/yQrVxXhzCJy7kkzwcBwPfcVTHyXm1iq2p5vzuP2WTMMiLvIqRNC2yfvU3eTouuYO+mfQIWFMCVS4nmOwoSU8UJiOY0PTgFnu9mGK21PSPMvgOpEO4jeT8yY6MonrzEupEFqz7XdgKi43FdY31f+d9Y01QVReg93BBWP1U9DAal8Z/FHHFafilcAHW4FO0pTx6EWen3TnEjcIGjtYnh0J597pm0e6T/V3eQPaEzQGRMeaY52KwLcM04ga8v6CO1ga1ptk8SWgSXlivDsZfaNYHgZ6BXi7FoOocostw/PxLz0IqbJt8mG/VBMhy5ZnqQVZMzotNq2zeBYSkbxspPvMHeVOKo7HriRXfSkT3HP0c1rQhrVht3Zd5R4cERSjv45GbLdl2+YZhm/ptI/+wF6u51ySySA9cCPkFBztxmfHutz/4wc0r4eVMKBI/U17lE9CpIKVpCg8HJB8u4c0eZrWab3H192KiRVGeXHTKRXFcXPDJAuL5TPyRW7Bu29MZsMh/aT6a4YWZ9dHmlDZJkD0njJ1iAQ3gkCwq/BGMimDEBr4cl9ry4IIhVIVSnI8rQUrj3zRgyq4VTIhE1489rOHF5ara6JCVd+luTEgpfU2aJWfroMTVx
 jnl9fuyi
 Cvy+tJQ8PywEkFrMEM4mM+WsZRNlE8ddH0dTjwrtzoqysQlrendFHSz5Moq3zl5Q/wnKrFhb2d70JbAC3TAqTo80/sLcIhhjuryT3paFUWxLQgOfp8zx2sQoG+HIVjSLaTkUe3L6rDXyatqmp77IyFriGB66pKQq/etE168zHs4PZLEY295PN6K+Zx501QtlRmE9LXuaFqEQ24ZlzuNJ97PgxqXSkqhN6DQ//S5AivBNIGpLgxqxM8m/1/crCFdM3Mc1IiejLQvDOoYlIVtGz3qFux8hZqN5ZDSgeSSmMTWCAnJuinBTPTghHkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 9 Sep 2026 17:39:23 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:
[...]
> I was under the impression that with the change, all possible operations would
> have a prep_probes handler. I just noticed that we also have fvaddr, where
> ctx->ops.prep_probes is NULL.
> 
> Ignore my comment :-)> 

No worry, thank you for reviewing this :)


Thanks,
SJ

[...]

