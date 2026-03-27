Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE3B110ED67F
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 14:14:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C5EF6B0092; Fri, 27 Mar 2026 10:14:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3770E6B0095; Fri, 27 Mar 2026 10:14:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B4306B0096; Fri, 27 Mar 2026 10:14:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B4856B0092
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:14:56 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C8AC7BE7E8
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:14:55 +0000 (UTC)
X-FDA: 84592039350.10.DD44FA4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id AE9D64000C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:14:53 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ma3mjiH6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774620893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J0QMj3ElIoI1HpdCI7HOYIFKOPnFr+zs5JHCns2ebgM=;
	b=Ho37QPux2axN48HXd8DmIeXrnXVCHu1q7tDmZWy110PL6SV+mrYmTaGOAmTNmbe/GL904V
	ibRTPcCX/DvANM4mmaaDJdTvzyb+FA0lanKp8e6YgRSOAlX4GFdqdxJxUR2ZuSE3Jjn+9q
	Yv1h+oaiORCmRNBJk1ADPjsz0HhWKGo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774620893; a=rsa-sha256;
	cv=none;
	b=MwcltxeieftpFbDGHR4F6Ce7MDIbAUAV/CUKsbFP7BXVK95v9GOhqzGUHbVZ9JwLne+ISO
	pFBOLD+i3DQ5mur/8XJusMfAL0yBVdG45SGdUDty6GsW+wMe+TF6VIMzwm8lA6jcvaxy1E
	WKCmtzWp+Wvu7CizrTSOIDG/ZaKYB80=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ma3mjiH6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BFC944054E;
	Fri, 27 Mar 2026 14:14:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89550C2BC87;
	Fri, 27 Mar 2026 14:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774620892;
	bh=yXQlyWWnYNtbPdCh0r4vV5036zoOZh+s+XBcJkWFfmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ma3mjiH61nNEDh7izYui/7QrjOoglBmcXne6eWRWUIOBZbe9IXEBoxr5zSTBqD38/
	 cVcljtJIDfSNx6eWcpo4cEr+GQZWgC/F4nvDySDRmO74Cy/aNG2JSQqgBGPkO91vEC
	 bkpaVZ79YQMRunRGZn67AN2xLyVdrg3YT77DcCn7G4gecRK6rMbGl3mFF2K1Nl3T5P
	 jPAwbKOf1tx8Pz2/HOlhirMDv1ZU2sbMv3ZVD4c2w9c7+V44BioJ/r4bALZ+1CT9zt
	 DM6Lo9X15WqpBJX4jNWXva4efUd62euN7TiAhsgeXXFJb7dg8OG3vq2h17fXvcNfb7
	 c67rM4czVINnw==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon: validate addr_unit to be power of 2
Date: Fri, 27 Mar 2026 07:14:49 -0700
Message-ID: <20260327141450.4345-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327062627.66426-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AE9D64000C
X-Stat-Signature: enfgcs8qxqmhuogbbs8z68ddt5x8pwuf
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774620893-804342
X-HE-Meta: U2FsdGVkX1+TxVRZO29nE/G7DTagI2jjEfvQvruIaXp7IhuOvyTRM89xcTQLt7iJN6mhI6lPQUr1iAynphX59MVrBnlUFTD/EHIFgIVPrAIpIj/X5MDPO5QO27R2CZ1XzViqHfxsh8yOvqaWlFSOsOhYBA8I+n4Fa46V27mvvOJkkhKewhCgh24irqkdd7l1YzbqRMMZqLBMWL48ifiA3H1D5YpA0zA2rjJZzI2GLTrGfIiM1QM/6kE+d5VfFtcCsheTAlnwL6woIVA1g0wCnRu/kccSbw777hM0+uPtWKGUAb7FCfTQnKukPhqp95bD0yhJD5BCob7ECbU6jqEj0w+2pMVRUWmwNAgBd587L1ExznM1DAnlzcCf2P4zN8WGoNc5BGAqij5BEL/KuQ9NYT+Ko02pcPTRbD8E6h3APbKoZwyQggZaG0U154WCyLaC+cg0ZWJFycQ540+PtQ++6QMHcHhHuDGXzFTc+lL6HsIpgxk9AHgpO3s0UoLqh4aFduRlWPFg4hS5bwiq0AfquSI8gU49RAA4RU+M10MQxsWfW2WDKwYpOtwgbX13hCFTu/d+yP5tEpnXhlz4cFj0p7SEzp9MqWi+WXxYUhSC77Nami6p7MSs4O0du5AkctkL/4mMabO9OWDAvBgrCPdZHYdZGLZoBCLoumsEVGK0/PFd2ZBYjXIWK3U3ksO4ST7MaHMAIYkszpQRebUJyomh+M0HJd7zsESdx4JaeTzTUOd7h3S0DHmEbnZFa8ZGb4OsIzdV0n6ZUAeYqo/wiPl78dgjKU5F96BEw6S7vz1dn29LvDO7hb5iZdQ8Z7YVymTJy2meoGGajflH4a/ONGa37sLj+rrFh9pnbUQHykOQBfTfuccLBugBAjcCbJHq2q/pZD/BYaYlgjvcQNgtzekdBok5EuyhBPTOG/Xt0Fi6iCh50Z1XSiA5dQBWPPqd0fJvTMR4xjCXBShvBUsINqv
 6SE0gz1T
 Nd0Tkr7cONpIbErdI6EbfNlr1eVQtDhQMxPL3GxlAd0K7aFkPinIjlGG+gXQFshdfz+f6wdtpUY4VtdHx+5+s9bfmRAx8BQnkWLDZjXyIinVTqevKLHV0w0kgrTZVn0upXvyJfD9gcFvBuLmcSvxmg1DHVRg/p6UZ5LgXdv5diQG0LICKZBuxzpsl69TcQwYYvsymjjkJsLBL/nF1nzexrW8lu1Udv22i3nPJoUaqhHBjoOW1pqtaWSgUp/U5XxUK5IKWYB6qVUIEJc5kR/mL7CwDPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Liew,


Unfortunately I'm bit confused about this patch.  Please answer below
questions.

On Fri, 27 Mar 2026 14:26:27 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Problem
> =======
> The 'addr_unit' must be a power of 2 for correct address alignment
> calculations.

It is required to be a power of 2 only if it is smaller than PAGE_SIZE.  Refer
to commit d8fe5d2a3379 ("Docs/mm/damon/design: document the power-of-two
limitation for addr_unit") for more details.

> Previously,

Can we make the timing more explicitly?  I'm confusing when is the time you are
mentioning, since a behavioral change was made recently, by commit c80f46ac228b
("mm/damon/core: disallow non-power of two min_region_sz").

> writing a non-power-of-2 value
> (e.g., addr_unit=3) would be accepted by the sysfs store callback, but
> cause kdamond to exit unexpectedly during parameter application, failing
> silently without returning an error to userspace.

I'm being more confused.  DAMON_SYSFS handles commits synchronously, and return
error to user space when it failed, iirc.  Am I missing something?

> 
> Solution
> ========
> Add an is_power_of_2() check in damon_commit_ctx() to reject invalid
> inputs immediately with -EINVAL. 

If invalid addr_unit already makes damon_commit_ctx() fails and therefore
kdamond exit, why we need more check?

> 
> When damon_commit_ctx() fails, the kdamond thread terminates as
> designed.

Again, I don't get it...


Thanks,
SJ

[...]

