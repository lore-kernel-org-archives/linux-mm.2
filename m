Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B45910F3DCE
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 14:13:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 864766B009B; Sat, 28 Mar 2026 10:13:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8150F6B009D; Sat, 28 Mar 2026 10:13:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72B4A6B009E; Sat, 28 Mar 2026 10:13:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6161F6B009B
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 10:13:28 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 22CE31B6B3E
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 14:13:28 +0000 (UTC)
X-FDA: 84595664496.06.4FF83E6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 94714A0013
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 14:13:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M3GFE9C6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774707206; a=rsa-sha256;
	cv=none;
	b=vza09yY0uuAMGzsqTkGiuQYb7IyWph3FIb2ImKRYIcoBo1nV+pcTrVwiBSZm1erC/7vbJd
	9D+Pr9FNHo0L/yJdXKZanpsuHvS8X0r9thVmAMDLmQUpaGJLeEEXSTGZmxMNnuWOFucBkI
	8ODLWu0IAe1zypsk3gBp4jWPC5vVd5c=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M3GFE9C6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774707206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gceGMqW/+BjPoyzQo+v0+EregOPNDLtGPa/T0dMNxPc=;
	b=NHSDuM67MxwTSznJEZvqOWkoJgbOUDcx9c9HhiGnqDq2vlni3CdfLcT5LXh1zL6JcbVz0f
	RyktdA5G5fi3OJY2cx3zV5TNNeaESINvx4L2d/kTH8muLvMAygEx8BCXtyWLVmMp47baTb
	ilAv00Pjy8Yjow3N4chMLyVF+40DtWI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 922AC4013D;
	Sat, 28 Mar 2026 14:13:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C51CC4CEF7;
	Sat, 28 Mar 2026 14:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774707205;
	bh=fmCYbzGjhlcCuEkV1MgP++GQDUCnffzSmzBNprCRYt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M3GFE9C6d3w5gL3tGUfmdYYzvBiPWbbkhYEe+CRSAwLByGI7gqlnpT+I7wuZbbHiQ
	 2KDyY6thwP/IXilJoSukBLgYT11v4rEM0NghycahRJZSfNJmvt+UfUq0cCts+aiDMd
	 bKnl92G3ieB2wuV8EEpOH1RRz3mv9Spgc0/xs267OA4VAM3qjapoEKyOq5o7ijgvCo
	 Rv9Yd2Z0HRyJP+8sKmPLJ07KwN3vVeB6dePLW2sjJV/hyUPef1MTtKXVO2+FmpWGzn
	 xRNSGQm0gmbssCUQmjdz8H67OmGuv/JGr5KWE95V61Szk/GdkF9tXtPt7KXXW41a8p
	 W+G++FdMVf5TQ==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Liew Rui Yan <aethernet65535@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon: validate addr_unit to be power of 2
Date: Sat, 28 Mar 2026 07:13:23 -0700
Message-ID: <20260328141323.10540-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260328132937.9580-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 94714A0013
X-Stat-Signature: 95ynk1m4cad67p1egsngtctdzfd81rag
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774707206-877298
X-HE-Meta: U2FsdGVkX19K9bK1gBB3Wpg7jSLuP5TKq5/Mtpd7cGKUSwxHH83Z4BBTCizkP2Zn55tKc5kZvf5ziDrJor67ldqyumWFVXqaf30Oy8J4pYn+06ORLzsLygYs6FJpRFRKCVjMkXLt1eFkVdJXH/eR6U2Vo/PSX2Ns1Z73qTMjsa5bBLGeGN7/sGe3Cumbqdj7DS9p2JX67+grmPlu86MzLn3nnXLHj43rBC3MbUjNgzAD11gM+/+mwFYVLPSwlRpG/8K5uTbmzpHsjQBxvdWoxuXbR7dUifOR7ovDOs5eGSSepzR/XzNKHnUVacQ9YgEb5HBpgilhbryjIR73yhLIofMHdlpndPRLeCGHMrkf2dBVPLhiwH5aLjXkgjXvtSCzHTXHpPOmAcWx86l58TLaDUvfDkiaiZG+xFMbXLFCmOrdE0n90L53xgIbTftUMWclH1y4BH67eNCBWaqTmcx1tNjaXk0d+DvNk/Si90Ziw7AsDJlwUW1GhsYjB4ZWiPngx84LmwjhFNUM+QfL815cN46T9YHOo8TjnMyRTywXGKjpqAj+2GGGZ8ALLbSI1UbBZH2sjz64pHGmMKejjt2+Z3DbpWrbBIfYEW3LCNgnuvz9MQakckvDbXdOVDOyzHFoq0uuzq3TBBK1vmIRpUKHEp8DlttkeDMP87iqT+bkFepuobmpRMFkO8Y9SKqnpO8bjtDMe39fE0Ja87YsyYnKClnfPzLQ4OYCbiUR0Qw6iasN93YvgdEGt8RUSByi341G2Kh5vFx3D9NZK55PxO4TLwIoglcjCkRq1XeVKEZzErhupn0sSKTrnNVfoT+ciWJ+hPskaRYIlK++4mUE5IQYVL4Lbmdwy3p1CovYjrnTiMMWBkHVRFurBQmPy1dewu//88t6Aga1duMLM88bLP2MFU3yBMlokEZFVg9x1lo2Ly3cooG2/Jw4OaPrgLSZDjWcNMJw8SYGX1b1qFNNiX2
 9jp7xmvM
 jNzdL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 28 Mar 2026 06:29:37 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Sat, 28 Mar 2026 10:26:51 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> 
> [...]
> > Just to make sure I captured the full context, in my earlier follow-ups
> > [1][2] (in case they got folded in your email client):
> > 
> > - Does the current kdamond termination on invalid user input align with
> >   your design goal mentioned in [3] (stopping only for "internal
> >   errors")?
> 
> No.  I still think it would be better to avoid wrong input-caused termination.
> But in a simple way.  Also, it would be better to be consistent.
> 
> > 
> > - Would a lightweight fix be acceptable? For example, performing
> >   validation at the very beginning of damon_commit_ctx(), and returning
> >   -EINVAL before setting 'maybe_corrupted' to true. Since no
> >   modifications to 'dst' would have occurred, kdamond could safely
> >   continue with its old configuration.
> 
> I suggested you to try something similar to what DAMON_SYSFS is doing.  But I
> didn't get your response to the idea yet.  Could you please let me know what do
> you think about the approach?

I was thinking this one more time.  So you want to ensure DAMON_RECLAIM and
DAMON_LRU_SORT not passing wrong addr_unit to damon_commit_ctx(), right?  And
that's required because exisitng inputs validations of DAMON_RECLAIM and
DAMON_LRU_SORT are not checking that.  Why don't you add the just one more
check there?

I remember I was saying this kind of change would be a kind of whack-a-mole and
therefore prefer DAMON_SYSFS type damon_commit_ctx() based checking.  But
that's not a small change.  Just adding yet another simple check on existing
validation logic should be fine and small.


Thanks,
SJ

[...]

