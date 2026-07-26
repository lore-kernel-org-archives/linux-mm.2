Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12F78C531CC
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 07:03:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E27476B0088; Sun, 26 Jul 2026 03:03:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD8156B008A; Sun, 26 Jul 2026 03:03:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D15686B008C; Sun, 26 Jul 2026 03:03:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AA1A16B0088
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 03:03:40 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0E889120496
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 07:03:40 +0000 (UTC)
X-FDA: 85030037400.05.CB038FA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 784BD100006
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 07:03:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dUF2MOdz;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785049418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kdbLcjl6WNvMUmGYANLJvd5g9DECNaym80X7NqFHU+M=;
	b=gCkbGvaZp393+rtuX4U3/wx4NX6Zigd9r1XXmxacHK/95cICephHKRrjSLyMhiHlpuv6k7
	OfGbmWqsWnrf0MrUsk4aSjetWnySBm8VByNv2nXWZBT63ElHZRQvrHdXLm5GSchbYHhclS
	4XI3M/tbiKbF15Jt69JtdAPzuwYlgCk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dUF2MOdz;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785049418;
	b=rrGN65RFNuLPEftiF07Q7OV//4DciV37XBeFwgeVrJyUn662csToDRjHgMRrxjSZFHKknC
	ZDott51Ih9JU/vKTwSMunm5F3300Z04rL6hNfrqNkfv9MvcuzK957Hky0sqOV9hRxnk5WO
	/9zZz9M4D0OJYeQkeN67ZTY3mwIDg3g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C204D431F8;
	Sun, 26 Jul 2026 07:03:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B461F000E9;
	Sun, 26 Jul 2026 07:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785049417;
	bh=kdbLcjl6WNvMUmGYANLJvd5g9DECNaym80X7NqFHU+M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dUF2MOdzwq29dVuE0ufR2hlhLRTSkFOdEtXya6XFYfWR7QHSQNzFoD32jNwdCf3Kq
	 mB6OqBKncVTSu5dFUFnbGs5ZcdzLpU5Ri2uIfrMsPnYnuMxO5Y1/C3telAMQgKKqFA
	 S81qCQRPfJ/rQdmr1b6b0UX0kg+/gt73Y8SkljMOJbZBiK4eSnW4CELQMUSj/zIQWY
	 arcNBa3A639yqKLFtCr1G8Y8dr4XIsbYFYy1PQ5iGZ2WiQBlZlYLUdAXllTpUzF8AI
	 7mWGsfUqYhjqQGNOD18uVkB0nx5b9sxKDGRce/UR7lqy4H67tq32/fY0UVKcxkl9Yu
	 kmZjsrYrhBbHA==
Date: Sun, 26 Jul 2026 10:03:31 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Mahad Ibrahim <mahad.ibrahim.dev@gmail.com>
Cc: Kees Cook <kees@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lkdtm: use kmalloc() instead of __get_free_page
Message-ID: <amWxQ0bf4msx9PXT@kernel.org>
References: <20260722230246.2869-1-mahad.ibrahim.dev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260722230246.2869-1-mahad.ibrahim.dev@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 784BD100006
X-Stat-Signature: szjkjoyawpzpsjzuq36zf3tirzsf9ton
X-HE-Tag: 1785049418-156436
X-HE-Meta: U2FsdGVkX1/2ucqI/ysB1g1UL120PP3CWi1KHgWA5UocdyYA1Ednx2DRxX4Lv/bxbYahB8sfE+kFGSZPLIQVcPStzweaRt8yiI2P9hFWpIHSN76jQgNCgy4lwynOuLUnDEy5Ka1iYETZ6imm1TXN1ckpuJtd6w+B3hhQauCuIJ7c6MEszJm7bSVeRfh3JarXHhOzS06gWDD1iGqGwKzq0LTEBMD2eWG/f/NJBaDFLF5K4NbQe2TNDgmCViM1guln3XIX1mAx2t3PB7kG+qLgwSS5fdVBWQYd9Z/ot9DCsl0xGpCfTdjpGyJZHzgPcXVv8L28IwdnK1G2xV1+Sll5QfpmxWMH3eX+AfDVKicQd3k3RtrxH5hrrKww/q0HE7Wxh+H9KXa1S9lmhmw+DlDMmsulbzbOHvIx1rXpYsUzgT6aEnumzXUVK3E4rQBNLgsbQDn/O2+rnLS6/tOS4oHRnhNxr+0hpR7RbuAnc12lTWmzSKkyRzDESR2HfuXPW+vVs2tnqdj7CJVN9G5XnvxqzYZWynQzDuxELP13yzRHW5lMfexuHnLTa38tMNxfSJYpG85PUdxolZ4mkDQJ9m4oydk55vdW45piGR8wTZ15y7Cgx+ijlvwkM0ArzSeBkLmWYnaUKM0ZiIfA5vpcmxGOseUjL/8nLhQsjWZRu8im71hBexG0JJGqHKqYp8vsMJwMYvGZmQYF/vhzRTU+rmoIIYstw0vGvpDBRnwGC3HlPmRGKqdOF3TbnNcEyoUaA6u3rWrx+qPppy5Qsbcz2Gy/BE7Ua05ECnobF02MG9qj7uxPnimvz7wr4KgVudhZ0dvBZkJDK5dTaRUVl0IMqTpU7R+74V7gzNvUDmJTsDqB+xSA/usX6olNNJjTJfJVjys8McTuejOfcq0JVci+ec2MR2eMb4ZcnAaDrq7gtj8yB4DwG4NzLMuInQ2CZMWyNVlVFx7cQWUigy3OsrhGxpS
 bXRstGBK
 +ZQ38qB7yKDW74Hlon3YmkJWyTnzZvw7v/yxIWnhvp2vbCnTEbgnwNOyqLDJM+s6cxN026vGY0V35seulwygYLhttgoYp1wVT3zeXBACc1DGvXrLuZWYGsGtZ8Vg0mb/6xzk2g0nlHQpQNjQWrbjIT3blNAIULHdux2J2R3RXyWwPOlWcUb6JsGEnBp3zewD2+PpryBdXFvyyAi2rZh7yJ1av1EVc18lgsAiKDdPt85s2DywZ1NNf6WM8eBCmBr/7m7jICDeqX5dQ8J3f+//hsvds+5HS/PhYObcZ2cwLBJiBFuOjXQ9MqAnN6kJLgsIdqqohXUoOYgjbvFFxYx+vhrcGV4VpAMfyhV1b8MYwC1nCA4mjzRjIagKzBSOMbyV0xvHaQbdXwdds0qxzEYb8Y8+vd2BQzDWoWNspPSCtJ60D1Es=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 11:02:46PM +0000, Mahad Ibrahim wrote:
> lkdtm_debugfs_entry and direct_entry use __get_free_page to allocate a
> temporary buffer, perform copy_from_user to get the crashtype name,
> strim() to strip whitespace and find_crashtype to find the corresponding
> crashtype that is being requested.
> 
> The lkdtm_debugfs_read uses __get_free_page to allocate a temporary
> buffer to store all the available crashtypes, and then copy it to
> userspace.
> 
> The buffers that are allocated can be allocated with kmalloc as there is
> nothing special that requires a struct page, or the page allocator.
> 
> kmalloc() additionally provides a better API that doesn't require ugly
> casts which obfuscate the code and kfree does not need to know the size
> of the freed object.
> 
> Replace use of __get_free_page() with kmalloc().
> 
> Signed-off-by: Mahad Ibrahim <mahad.ibrahim.dev@gmail.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  drivers/misc/lkdtm/core.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)

-- 
Sincerely yours,
Mike.

