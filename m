Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2221FF4210B
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 18:13:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40A3B6B0005; Wed, 15 Apr 2026 14:13:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BAD86B0088; Wed, 15 Apr 2026 14:13:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D02B6B0089; Wed, 15 Apr 2026 14:13:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1DDBA6B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 14:13:12 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D140BB9ED8
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 18:13:11 +0000 (UTC)
X-FDA: 84661586982.27.A4F1C4D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id ED31640008
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 18:13:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qxZOzqos;
	spf=pass (imf04.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776276790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=e6v2YQMv0aAfKuCo3VG7tzivrMOyJJWr4sPy5xqUvH0=;
	b=MUHosGcXQbjAXVmbWnrOtQL9w35BdiC24jRXDDBpZJMI7dIwgaeDxQDuXzM1IheP2tzZDy
	GsiNgoKrzhrumdCNyNM+LEecotPEex6LHKj2/CgDHAI3hAkhpgEQwZZMNWF8CTI2AwYRt6
	4ny70WlmI91+vgJzRInQSRNQWFcD6sY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qxZOzqos;
	spf=pass (imf04.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776276790; a=rsa-sha256;
	cv=none;
	b=ma1K7lRfa6lMiHKfCYiF8bMtybeoZdYA1CWW0Hcy9sAGSK31/kL4jUuFE6D0V7VktyIW8S
	YwApqbI+irRJGgEXhpxJJnnw1/H5SAVXmfI49GWLDL+Qjo8ho5wDDp3S/J93k/2YZLNZSG
	mD7Mh2dwDrn2N+SqjnBOcDhOpPwu5Q0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BB34C42B69;
	Wed, 15 Apr 2026 18:13:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96AA2C19424;
	Wed, 15 Apr 2026 18:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776276788;
	bh=pqca+cDpN9lOYE+RZg+bLXHh+xs5eDxxFQ7uEE/7fcI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=qxZOzqosNZm6hRaxRrESSjn3yrLLKSRkKaN2kGpxbLmw88hBq8rnN4SlsE8hXXp+E
	 Hu1p/l+cYv8afZpYMtOkcoPa0s+VXwnJqFvzn6/If0FVyY+TVk1rsCaCF6Vd2Q2RkO
	 3Wx+/aKqR+1rJRdAYd5beFqjh7DMq75zB67WuUBplFKyVqdvJ6559r4cnXzrSC78aG
	 L++ZSjdvM7ersM0KTDkjiAH95St6t4W6IF295OXvPYb/CToAF80C1shXUAhNICONiI
	 rCqH4RM649/tfKgKXqtDA+clDcp2z/VyB2DSVtJ84d6iKbpHfQaMqmiRb1SnTEtcTX
	 vqCok/QZu6CUQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3FD5A380A963;
	Wed, 15 Apr 2026 18:12:39 +0000 (UTC)
Subject: Re: [GIT PULL] slab updates for 7.1
From: pr-tracker-bot@kernel.org
In-Reply-To: <db0210a9-0bce-476b-920d-7e90f54fe72b@kernel.org>
References: <db0210a9-0bce-476b-920d-7e90f54fe72b@kernel.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <db0210a9-0bce-476b-920d-7e90f54fe72b@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.1
X-PR-Tracked-Commit-Id: 44e0ebe4accd67c67134cf3b805917153041a300
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 05cef13fa80de8cec481ae5a015e58bc6340ca2d
Message-Id: <177627675771.2375850.507133023710439395.pr-tracker-bot@kernel.org>
Date: Wed, 15 Apr 2026 18:12:37 +0000
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Harry Yoo (Oracle)" <harry@kernel.org>, Hao Li <hao.li@linux.dev>, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@gentwo.org>, Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ED31640008
X-Stat-Signature: x7i45ni6c973dhjwq5ju74doygzbswmt
X-Rspam-User: 
X-HE-Tag: 1776276789-973500
X-HE-Meta: U2FsdGVkX1+zsp1Zigi3O8z+QpUWGLCcHem022DFK+3jX24Xkki4Rj1iaAKRb6iS5OM/H2cRPbRvjfEwS879LbVcyhiX3edl5EDizWqwL2LV5c/ttKzbwkyBiskFrc+Smynjt7H01sWJx84XqHISf4gGHjobz6vyjQ7pL56ezj1JNXCQ0P2qd/8fUjS81GOT3ELg+YmCPrRE6l6Cdj4qzYbApLF0j0OUbKDTLY1cfOkF9Aol2rvlsDnIIs3uNvXKD1Qy8a+iZrxPGG76IsTMqzUE8u05OdXI6ULQoCAl8lPWVMtM7nh3P84KJ5J+bapeEARyL6K7GAitabSMfqItzfTN7hWYwkZBLxt6Z0IIou3oIZjI1J1zE0mQAsWRnr5hs42o/yJI2TCD6wIEW+iIptkySpqeezlgL8pjBCsEr8mub2x1x0cJSKYUkno+ocBAdKu8ZT+jEwaXHmt3i0eFKjW9ptqecyKBYz02tW8DTqAYrquHcld1f0qnUxlS41xPouMf8UU0X3XGS3kvlOlRe9Umjtc2H+XtCBSDILz/i1z4LxS7BZ14RKjA+Xags5zpy43SHV8nLYzcMaRos8oQPjOjEY8TI/KB8Yvg0gigmJYpbK4LUuV44/XuoaoOUIAOUD8QA+6QfBd8/0TbUxZbp6gJcZ7vkXgf6XtWZ7vgzXUQjiaCttewp+DoKi5wG3rOVhwJ9OJmUuCsICsHUNlovpmW0DHgVzNAkt3qthaM2iIRyAP7soRQXw5JCNCsUF9tSoP3OSwd2hHlj1160ksoPLIbwWoLln+wduPdyG8pQiai90LcAuhu1/ymRZtYSg77Uxn8PL1J7D9vA0PtDVw8N3yxRtFZ7bTXNAJNN9JvRDkq9+OmdfLr2EH0aJSDT1+gKkBUJCX/R4C3uf3Vk5tQYC49oqnVjxxDxl8wHcDtikRenJ/ldWYCTRwipg4wARBl99uX8lI1uhAIF5YB+LU
 O0DpLzUJ
 pC8yQTef4mj5fI3gHCZXee7jwx/hjghrIFCW68zqFoXjMZ2vi77VsKBWJbfQDYDoExnmEtRYZbmPCtxVSOmJ3pgbl5R5bk2Qnu0R8pQlHeAEqkw/O+ZhoBJG8k6BFYI3SVqzk1qv6wESNvuHe/vKYo9YATV3Qc/kQp/IqJH1Lj6oOtB3YH6CSJ/fWhSIsmTPqbgKVGtT0tXjKzB5PjuubhcZsEBrtdBdMb+35guyROvgL2wu2YikApNf+JB/KlwWo/iM4ZcR04vxKLB/OpNRuc5MMjhVV62m9ZkqhpME5kPY27UHce1TGK/wrvBQkQOiGPBgRrGcujmYJtnOzP+v4w0C3+Cs1d3x2bexDfcZZjHrNFqaxRoOCUf+OEq7YNdeul6YraYlJYm4ecwQ7yU/u9rkazcValSTrAVoIXpON6qLP8DClhL4BB7eBlA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Mon, 13 Apr 2026 13:39:44 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/05cef13fa80de8cec481ae5a015e58bc6340ca2d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

