Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 278FC109449D
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 00:35:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5224E6B00A3; Sat, 21 Mar 2026 20:35:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D3666B00B5; Sat, 21 Mar 2026 20:35:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E8DB6B00F4; Sat, 21 Mar 2026 20:35:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2DE526B00A3
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 20:35:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B4BBE8C1FD
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 00:35:04 +0000 (UTC)
X-FDA: 84571829328.03.547AB55
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0784A16000A
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 00:35:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dzSLKcIf;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774139703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OLVd8aBKLHeRty0+f4yLvGtzGEh7Q0AeN1Se4cetUPE=;
	b=PYLKyH2FurdxHP1MzQ264ZuSjbx2jfmd1mqWiKZ6zO6ihmV+0XhL9c3o7Jlt6YSREmEfdW
	Y99zfHndgrNIqv823kdNcEnLshDAYe6uWuvc8wQsA4KlQUgJSZABBdsDb/KOPaHAAb1cjc
	2lhWjfMPvbvfl/BYidni2nrwJ4+330s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774139703; a=rsa-sha256;
	cv=none;
	b=0WZ2yrKuIukeEaEBU5HdP/axGLXzytqq3Kd5VgBIwMEEbW3PZd0XVlAaA4RbsqlVGoUoI2
	abxRkwfuT0frqekUocEpNh7evxkdozX9YmtXCxEPM2t6CB+lp/3nDh5j7hYHTLF8u/+i2A
	c7l3xU+fKAC+EKeVPPEhwpCPXIqNKQU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dzSLKcIf;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0D014441BF;
	Sun, 22 Mar 2026 00:35:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD47CC19421;
	Sun, 22 Mar 2026 00:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774139701;
	bh=Wt/h4AN1e0QgCx7j7jEnWZz6uKMuHWliIpQ3bGwhTuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dzSLKcIfyc/SrR+kVqO4Lun+8kTCE0KKvE3gmizGnjA0xvJb2HSNoygbYUeljY0vk
	 ASWiT3mbHNpJtJznhjJAfDUe37meu3KnXynUv6N5vXRtO3XbXP1V6YGF34/er6aK1s
	 uMV7dmcC0zYn47Y3bZ8wjmBF8EioBKQJFfoVtCtZrkz1b9bfQLMZtln2pCIACyTpPB
	 WUmW9n6mBNbRWxPaN1PXSNROr62McwR/uAEevlOmws9Xt17Gwn5H39ZLc85CAsu+sg
	 GC0cnjWplQKx+1MFFO0tjVA+QPJl3zODOjBcYYBVGawL3htOzPR8IYrlIkby7SzrP5
	 AaSPEC7JhJbGg==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko) [PATCH 01/10] mm/damon/core: introduce damon_ctx->paused
Date: Sat, 21 Mar 2026 17:34:58 -0700
Message-ID: <20260322003459.86313-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260321202858.98091-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0784A16000A
X-Stat-Signature: a759i4in7pzzqkhm9e9rzahgn9oxtuxi
X-Rspam-User: 
X-HE-Tag: 1774139702-44545
X-HE-Meta: U2FsdGVkX197NG1EtnnTP4UtqWi/PmbBSp4Qa0OBbge7X8LUSPtYjeK1+FgrOpjPw1qV30qPJ3A7xGd5gDklsQzLiGJQZVgtOldLuIwDxJ5Eyg0y758mGYTx3Ww6uEiYsIUbIrk1Y/DggyYVVieC3aqW5fKyhRyDGx0mR+cqDXYD0/P+BHmZSF/06roEHgcTywdZQNQ2Ynz/y0GYrqMzD/Cm7bjQ9+4WcdVvBypjSUhJaBotV74JmNUs4bFOMAv9LTr6Gt8f2ccafY2/++v/p8JUOiyCE6Mv14JdTVXRqf20vLN8qGYblCchlCVQTro4SDyi5HW85DegXO6CYhbD42AsXDPvmTbjDX+zf5+yJn7+JdyUHBuS8MypcGc1jZ/8SCbFjTcnvihcT/usXxKefWEXGWUOwjLGgLMVseJoOnJf5QwaVSEKbiVnQneKaZWm5f9RxuP+X5G18WcCJRI22pOjhAR9c8TBX9n0tiMhFZMHj/z1z4rmJ4VOK+U/ua1lVMw2x4MJOfBndEXe0q5n+STX9eNHhIXmQTPnbaI4ZIdOAA00wUeT72QanRHqpmxo6AujgB/9MKhjVt4szaYs7R3COJ/WQIajL2NgyNTt9sLHLuMouC6JDzUCYXjQ370RTmziy39N7exeqMsmP7TzPx8OhqaGn/GldZzcNSflwE48HyQ7VdZ3iqS5EDJgwvjUj9zZQUwRCA0rOWb3QYCUu6Q1+BCpnPI5q+9nC3ZgYTCzB2VxDk7Olqg1mvOiZBXOrgWV2WOYzdZzueuZrIylfLTvesfctNJeYzstUdpttQjo2I4VRktbzTrAyQjTGS5glzTErnJM4cOG7KNR2EjGz9CyY6lIZ/COx6t/mYwfql8l0mESuobF8VrwGVha3tAFdL44E7O1UhW7VtGIs5g1BQxijvwZdk+wHHJsOP5vfXbo4PrQK7wbS3pqzevCU9eQM+KtH0Npq4XxQcWvJxY
 C1blUUng
 W5PjxXigIMwKuoSYzSvhXKk+FyYNXYp5TarcRnA2WmmcA2cXpLKTInpm9Dyb9ydCV6qJNDFUFMxTqjfdSc1YkyiFaDd8spKYVL3wYMYhNWrpc5nSkDxRdWViBs39jJvJ+Ha7kjjQOYEjJTC3QDkZWPV+Atnnx+oiPemglx512p4aaBXTG8j4oxPBFB1x3axfuNumXTaLdB+BfA77xSknrsP7MywkaDQJkZJGRoxSeM0B2qHXLvv1c0MMgLeP4BChpK16Pc3Qy85OFq7c2FWbpWQXS62PekuuVrUiHqyeniQ0/P56ZMffxBbVDeQichoeIXpO4qJxTrTINCtl5u92j6K5rs1/bK18d7QAIKcTabjYVwMBQnKdfeCb1tWT8DZ3hmlFYJaWn7FGdpNI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 21 Mar 2026 13:28:57 -0700 SeongJae Park <sj@kernel.org> wrote:

> TL; DR: I think this needs a few changes.  That can be a fixup (picked by
> Andrew) or respin for v2.

We already have 436 patches in mm-unstable and 40 patches in mm-new [1].
That's 476 patches in mm-new.  The total number was 392 five days ago, which
already made Andrew concerned [2] a little bit.  I also agree the concern, so I
will stop sedning non-RFC non-hotfix DAMON patches until v7.1-rc1 merge window.

That applies to this series, too.  That is, I will post the next spin of this
series with RFC tag again, tomorrow.

[1] https://github.com/sjp38/mm_git_dashboard/blob/master/summary/summary.md
[2] https://lore.kernel.org/20260316142636.0c29d431b1c8bf03e01c3630@linux-foundation.org/


Thanks,
SJ

[...]

