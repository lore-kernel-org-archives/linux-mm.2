Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA8CA10F3DCE
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 13:29:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F7F46B008C; Sat, 28 Mar 2026 09:29:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A8FA6B0095; Sat, 28 Mar 2026 09:29:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E5996B0096; Sat, 28 Mar 2026 09:29:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7ADC76B008C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 09:29:42 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0F1801B6B80
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 13:29:42 +0000 (UTC)
X-FDA: 84595554204.09.54F3587
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 64034C0002
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 13:29:40 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L2TTFNpT;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774704580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FYsn4jybLblLnlcr5sKr79cYdRGJEnPo2ulnXMuzvYE=;
	b=PKLlvLGOhhgsRfuuTxmdpzKT42cFJKarh0h7BsCl3lm0XxGAy34eOiV9C5Gi4yBG7EO97v
	vGxyA0OXPYZzGjJu2yKxSoMntcJyQNWBlfdbSyUuNtl6fL4rwx3ibRCEPyBmiu4/iOQ3dh
	nhPtNIMUxxDy9+i5WooDG51Fzqu67z0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L2TTFNpT;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774704580; a=rsa-sha256;
	cv=none;
	b=iLzdlIze4gETcVz4MDXS3lGSm6inkF2Kb0FXAaxez+Pz9v42v1gs0q/wZ+cXzykCNYPWG9
	aDpa/URp88nHAIpyJ4F6iWVwN/cRir/zB5HisGZUNoBHu/J0TUapRvj4ekCFLIm5+S0ZiZ
	K9ARIoB2kwpf6QpqaoMrYP13KmFhiFM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4CB59403AC;
	Sat, 28 Mar 2026 13:29:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15303C4CEF7;
	Sat, 28 Mar 2026 13:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774704579;
	bh=mys/1ZYPavmeUV1mqT0qVhxOQKC1CUsE60UApH2p0p4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L2TTFNpTfHJLyJoK802k47RjtRf31xzwqkhKxJKVxRzy7fF3oJKzJjyjyi4P9N/fd
	 Lqn8s+yJoa54lGFZH6owgV6tyYvsDEZuhXjKB97M578ISCy3qLDRtfK3zm0gWoPATn
	 1GB89BKfkXG+FAyMvpvg2jhOdvhi0B24HgwcCkKOq08suy8vSTEuW5XdrklTnLFLC1
	 mjujOW0OvEJBtD9lXFMuC7YR65q27aCa7uMaraWIx0rjhLYtSPnwqsr2c7pEDhqKr6
	 D/5IM8H7uBoDhWN/lgEyCKMbjj507cyg25OV7W5/eVcQkHZmTfoabUaZkZw8m3SXfh
	 d29zyZ3arbb/g==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon: validate addr_unit to be power of 2
Date: Sat, 28 Mar 2026 06:29:37 -0700
Message-ID: <20260328132937.9580-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260328022651.41744-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: phwyrg8fd3med6wuinmg866s1ee56ksy
X-Rspamd-Queue-Id: 64034C0002
X-Rspamd-Server: rspam09
X-HE-Tag: 1774704580-589894
X-HE-Meta: U2FsdGVkX1+/lQ/8YxO012grhYFj8m66q+SU7cF3Mn/ecyrhzdj1qA7Uhyqy0+xXPv0qaZX/958DFZLs0hg4xCJMhvSswEn7JQ5zIvU2wp0KXhe0iiil72IJk/MovFeBJ3rCBclVMDICbhe8WxpHlEWhrieXYmfY0MXb61+535Cw5LrN0HpdaQEqvFbciNy0sMYZeg45lhku0QVz6dzR0z/akPR3JaXUk/q9Vy+ITC+pCFOParZ3FsUloejOe3dUYEj24DXVvCHOyQtYULnkkeHVYwcCENlLubKrmcbypmy0I0LD2LJrMX2+EOkKF8mWZHvjQPLREYWymbd/HUBllSLlFohl/xHMB3pEKpsBAaDY8qBcQ9XsSTclffT7NTOCZpFqMuQkTgHZahKU7pGqFXkt1HM86qXzBGr7QrDTXTLdXUcii3Q7MZhi9/2Hl4Kq7qTPVqVapCwIsM2r4XhghclKdEhN6aTNq7LVhFCJFX0JlVOckQVq6HSGwUcCqdwpHSM+rKtlxC1uehvxn89ogMUA3t4P/KhrewKv91dp31PlBpgtmeZbwviCnQLjy5n7O6nXhtG33A/02SjjcyB+cr1pFZJ8f/63Eo2+zpMP7EnOoi9J09oq7Y0jfNKQZfZ2RCCWeeAqRw3K3MwG0yWweYiS5Tc2XCOl1xlFjh/qO7UKF+nTVLOlmOw+DUaUePUSm7nJpX9N/g7V+DeM841VBvYTMPsNz+FwDrNt9vVzPb6TdjjSl35+q0QIK0claq+oP5LYmHp0yFTItADOc5H0YXjNfU53MN/ZLzf8pfitYUN+gBuY/l+E17U5NbYHSvpeDYa6BTFBTixkosTQPH9Y7eyuxGry8gymthE054zte5e7RguAMTglCN48lajqIqRxYU1SSy9SvLsaSmOsazQmccMcQg5G+fA4xAVifm/LW9l/aFtz01gRtaXxrkqDhcdIE9Yfz5kyKNL14kGJoyQ
 v+pZyO8K
 tO+5XTuSTQ1C48iyTy3tuxeUu7wCiLfKTJiLsbOTAkMV0eBFl9v26hICFyhxdEP1gwe9j9/0xHdvhcCLXk9Zw5dwp73vYdh+hrRGvdP04yz0jeHct4bf+3sxiAuEYOpwW44M9AMNtKaKFK5TgwlwU5qlQH/oaM3Y9n0lMMWIQaPGJLcV7HqOLfkyIUq1PITf6LYJlLXTSmg0+fzTXXx2FQAGHUHUusy+2mV4Zm9pMtCPVlTcPDJmHN0BWQN11M3JEjtr+a+XxQ/sjBCPVGcNWOmdSUCXmeyL1qMPDailKb1zsf+M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 28 Mar 2026 10:26:51 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

[...]
> Just to make sure I captured the full context, in my earlier follow-ups
> [1][2] (in case they got folded in your email client):
> 
> - Does the current kdamond termination on invalid user input align with
>   your design goal mentioned in [3] (stopping only for "internal
>   errors")?

No.  I still think it would be better to avoid wrong input-caused termination.
But in a simple way.  Also, it would be better to be consistent.

> 
> - Would a lightweight fix be acceptable? For example, performing
>   validation at the very beginning of damon_commit_ctx(), and returning
>   -EINVAL before setting 'maybe_corrupted' to true. Since no
>   modifications to 'dst' would have occurred, kdamond could safely
>   continue with its old configuration.

I suggested you to try something similar to what DAMON_SYSFS is doing.  But I
didn't get your response to the idea yet.  Could you please let me know what do
you think about the approach?

> 
> Thank you again for your time, and guidance. :>

You're welcome.

> 
> [1] https://lore.kernel.org/20260327064517.68131-1-aethernet65535@gmail.com
> [2] https://lore.kernel.org/20260327121009.38374-1-aethernet65535@gmail.com
> [3] https://lore.kernel.org/20260319151528.86490-1-sj@kernel.org


Thanks,
SJ

[...]

