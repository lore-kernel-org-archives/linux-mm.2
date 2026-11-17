Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC833606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 03:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MevL1yT7
Received: by kanga.kvack.org (Postfix)
	id DFFB06B05B1; Mon, 16 Nov 2026 22:09:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAFD16B05B2; Mon, 16 Nov 2026 22:09:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC9066B05B3; Mon, 16 Nov 2026 22:09:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA5DC6B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 22:09:16 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2D5B5A701B
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 03:09:16 +0000 (UTC)
X-FDA: 85443129912.25.6396AF7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9B6DD40004
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 03:09:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MevL1yT7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794884954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bsKdpnnbNLZITb4IXi8YQJrmOxF/yvbqsGdvFsxy/Ks=;
	b=UnS55QdcxU568fv/j06PWoK3zjQ749uvMdZTgunHtCvzPzQV4LkTw4pM8CC893m/JvfZVL
	7jocvku7PlHEgekb4DQHiYSgA5X9iwuQyojXF5/qGaXftnk0gCDhdy5MRX99Zb0HfCMgmo
	uJ2jTjQCYXv3eDc5J4NNxRaesfX5lAI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MevL1yT7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794884954;
	b=QTx0RbEGQZn6NNDqa3NXvPwgAg2mZiMRw2jR8X3zaj6DIQ8WBrEKxPRV+iElyUEBG/pzvg
	1rP5sgJnhsnqs8fCUYN0S6GodFMlddbhEYKKi/npek/wDA0l1DUMx/JgCyHX9mvSCd3xzh
	EqI7ybiReESGWOxesylBGyoY5/l4gzc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7DF80438C0;
	Tue, 17 Nov 2026 03:09:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AEFA1F000C4;
	Tue, 17 Nov 2026 03:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794884953;
	bh=bsKdpnnbNLZITb4IXi8YQJrmOxF/yvbqsGdvFsxy/Ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MevL1yT72wWCYGI4QPeV4DwsylX64DMvU6yG3IpfCnar6ZOm8i080Ib16BKsIaems
	 pF24awB8cOeXE/dCc/LJzuDF1rjhPAMuP1ZBe0PJUVnBUyhxKIv8+D8TJ7ug0t3RUt
	 tJH0+Rsn7Z/ftsUNmGv8j37QoVd1764IJa8sHFVlXVKrNdvgQjnxZmnm7Z8UuzMCOZ
	 g41WU7ZU13R3jPgLZYIY6viiSjF/Y4epbov2E8uISiT7Ko6VTiFaecHv/gEwQKUA/W
	 Kt+fMTAHCTxKyJYVRs1w94IaPqPfnYo6KghUvqT0GSlIb+gst0KpTiatyLgPYORg1g
	 5XmYEv+hid13Q==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Mark Polyakov <mark@thundercompute.com>
Subject: Re: [PATCH 6.12.y] mm/damon/reclaim: use parameter context correctly
Date: Mon, 16 Nov 2026 19:09:05 -0800
Message-ID: <20261117030906.117403-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117025144.117100-1-sj@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9B6DD40004
X-Rspam-User: 
X-Stat-Signature: i6j8fozuz1ffsycmehj94efxmhsfgq7i
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794884954-278885
X-HE-Meta: U2FsdGVkX189LW2GiX+Eh2QA0XgIrHPc2W+jD0who+BJvz+/KMxyZINGAvJtdp+rU/p+VMMRP4di5EFhC1bpyxnAjAvyevUpjZhrITDKkRh9wZpc7VcCy4UUYwhFWDUF6vSPZ8w2R5hVjeDKEnEZReGrrxYUk/GHMghdMSGB/9AQc4taLfz9jnEKrfeVx/Z1G4GmTaT+dRtPX3VDhu5sETj8kKIzMyHN3PDNHxDV5ejR7kQTWUfuQl7D1IDoggpKCGpriSJjJeXcA1VSgIAclxrDXIS1pPDauDG3F1uYD+1Hnb5ypbhxtUBzH7NuIjph/mdqJiSN2oyN2RCBvtFWUNDyXFsyBfFl65lw/3UWTN4wNmsbM/RVUhrytFBxpFG1wMpn+eo/HVJuZSI6Fm7n/YVyThqRdM5S0nYMF+7c9Pqsgch4pNoiZnC2cjs2ApqDQm4GtQjZCeGeS2ilqQYgR7hLfpgkY7k7TQJKIFzK7sNzjV6GeFSUN2qOSWYKzYZXFSenJiMKjBRIIw7cXqYiIxRyX3yjNzFnscPHp1KwivxrGmSAylhLR1DTTNTSewZUUy1+qdci9sKzwFytQuHEONA/F+LstrWmWbKEkI6j2a8LrEz22w4AFRRUPEjRaas5kzJAvcreBjtzRPf/JR/3oIeugRpolpGJJb3gkYxZd0Mo2lzNRerXZY5liLMht+quHTXSlJzkY2xnFTC4ljXyWvRvhz67psSUyvDcqVA/X4JhR4dgEiaXJ+xJU+GHP8PkSpm3ICNDax7t9puwbALFSwGnYr/M8MfOu8KgSgH1Ebn1TbykR6fKcRTNzGgS4pWQl4y0iiFgLfDqnX5dl+FzzYTd1IayFNeQn/BwO9tZ697InIkuxp6nnMEleNie7E8dz+jRS6mnKByrN+hiUs5r/Cp2tAcdkR4zZbTc8BOIoIyNYBoaZKSHJKGCs8bpioHaCY+toe+dym0ILYomY0F
 4I9vmCOB
 yABofigofRCr9wcRPVDc9YMLEpmEbgg2XI/x0hLjO3fjuZq+6k3e/wiQFwD6m7EBJPA39YqwzFVDdEoKtfrAb2F63gKxNI9jVedJhM393rk8xi4Av+EJgLKgAK2zlYnVbj5f5n8w9zOt9ZYLVU0Abe8sxUnu05Zs+GKubkSOHLt8ciZ7wQh9nODATLXRvL7mEmAdneCZk4YToytjuBQj9rN36rFWLZh64oaO+VbZvs9R8Pz0PUav+khyylY2ssWtVaKoqtyirkL9l6g2CkxXpo0XH6rhDcoL+JeoCyo2DKbvgNi7uJ7iCFJ0tXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 16 Nov 2026 18:51:42 -0800 SJ Park <sj@kernel.org> wrote:

> From: SeongJae Park <sj@kernel.org>
> 
> damon_reclaim_apply_parameters() allocates a new DAMON context, stages
> user-specified DAMON parameters on it, and commits to running DAMON
> context at once, using damon_commit_ctx().  The code is mistakenly
> over-writing the monitoring attributes and the reclaim scheme on the
> running context.  It is not causing a real problem for monitoring
> attributes, but the scheme overwriting can remove scheme's internal status
> such as charged quota.  Fix the wrong use of the parameter context.
> 
> Link: https://lkml.kernel.org/r/20250706193207.39810-7-sj@kernel.org
> Fixes: 11ddcfc257a3 ("mm/damon/reclaim: use damon_commit_ctx()")
> Signed-off-by: SeongJae Park <sj@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> (cherry picked from commit fed48693bdfeca666f7536ba88a05e9a4e5523b6)
> Signed-off-by: SJ Park <sj@kernel.org>
> ---
> Mark Polyakov found [1] this patch is missed in 6.12.y and causing an
> issue.

By the way, it was not picked for 6.12.y because I underestimated the bug and
therefore didn't Cc: stable@.  Sorry about that, Mark and stable@ maintainers.
Also appreciate again for the issue report, Mark!

> 
> [1] https://lore.kernel.org/CAA5JH2yO-gw1gn_172hv0YWFfQpkXz915a=uoVH+e49P_D8-+Q@mail.gmail.com


Thanks,
SJ

[...]

