Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE76AEB5961
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 05:20:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 995296B0005; Wed, 11 Feb 2026 00:20:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9430C6B0089; Wed, 11 Feb 2026 00:20:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84F1C6B008A; Wed, 11 Feb 2026 00:20:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 720796B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 00:20:16 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C45A488B2D
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 05:20:15 +0000 (UTC)
X-FDA: 84431024790.19.ECC7D40
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 18182160002
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 05:20:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rryqsuCk;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770787214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tSRn7LYq7bnXwyk5PY05gVUZNySxO94RBH5QOr3ID8A=;
	b=GBRC1ZcaaHf1bSr9CG+EZ1Ma1CfJmjNC0G91lkOaNmfCiWqZDaErF/3tgKOBPxnFdm49AJ
	fkzbq0y4JR94iswCcnpYSdC14T4orByFHxHqk+l0afgv8MdIf2WMLIz8GHNYYXMRnaX4hL
	VqG0a4ZZZVw8CwDwukLbOa0BXwV+PlA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rryqsuCk;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770787214; a=rsa-sha256;
	cv=none;
	b=OzMQWWfAeqEzobka/voTmGYfqYjDkOe1byQKk09Dt6oBLx2311EO7D7RlljVHe6SJjiWH/
	oCS6NvEthSfbfJk9rGSREXtS4Yr4avvbu9XFBR2ihbez9EobdJOsPn6mw/f4AG8AMhk53K
	l6iy4yIT1BHKGY4xXMtd8Q9sFhq7KJg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D3A7444021;
	Wed, 11 Feb 2026 05:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B7DC2BC86;
	Wed, 11 Feb 2026 05:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770787212;
	bh=JplVZb2hPJHGSjo9zbzDnnP9KpCnKpC4XDGriMrERSk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rryqsuCksMEbOdlKRVbg+eh4HniIZ1p2H1OAHKFYoFwi6Dhath1jM4TzxA5MxJ7PG
	 Hd6NvDYyLj2GjfwwO1RImnzuOelyqrU9cVCBc8y43yOXLKIDyqBVaH/+fpdstQnAB5
	 CAb5KMUBg67nK6F4Cl4eUmVc1ZSY7GLZ/xKDgtT5Ba033+n+cbz6mXWk16V0H0VVyl
	 D4SAO2XQuJifB6meAc9Pb1S7vJjkel9trgam1Ez8WSiswVP6H6Qrus7cgNWwm5PCvF
	 968eoRB6w+efBf8INuez7sPsUhWmTcoHd9Y+lx9uxolKgcTtInEzUghK4Qnp8LZUyT
	 qFnR1MShovlyA==
Date: Wed, 11 Feb 2026 07:20:02 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-mm@kvack.org, Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH] mm: Fix memblock_free_late() when using deferred struct
 page
Message-ID: <aYwRgvjvAgKhNsTq@kernel.org>
References: <279931074239b7f3812c4cb3969f887303c8cc26.camel@kernel.crashing.org>
 <aYL3zxuTLT8N7C8-@kernel.org>
 <c3769af482913dd7ee9d5302c8afa990255691a5.camel@kernel.crashing.org>
 <aYXDeN0WGQG8-cxe@kernel.org>
 <bf0231accb89709968efb4d8e1be9970aeb716f8.camel@kernel.crashing.org>
 <e5d5a1105d90ee1e7fe7eafaed2ed03bbad0c46b.camel@kernel.crashing.org>
 <5a44609fe992624573a3ca0a293888bd623e2a06.camel@kernel.crashing.org>
 <0344bfbeb017cafc0f7bd4433eeacd9bc802d9c9.camel@kernel.crashing.org>
 <aYtBctm4TlHGnzXV@kernel.org>
 <684d84272e7dcd2ead0770843a7e0afc625c87c9.camel@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <684d84272e7dcd2ead0770843a7e0afc625c87c9.camel@kernel.crashing.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 18182160002
X-Stat-Signature: msronky97hoykgd4mjwopcybxeh5i9wq
X-Rspam-User: 
X-HE-Tag: 1770787213-766316
X-HE-Meta: U2FsdGVkX1/F2p5opBEvZMue6HVasDfGmFnX9a7GsYJWdU718cA7owVr0saqk8hhcRNTVcMn81SJIrlZbbvUiJphRjJZhIklRPcmAajr+QcXDHLSsavvcyRwvGezuW+vA4R3xTjgICbSaBd8fffTuEUitdNXRf4z4rg8sGMmXX3sd9hpaNL85ZWdBmQmFYrieqx9nwVhQ3fnIcYbdu7lFnx4ZOFvIvlFpEc3TiEHvTtq38rvssDeHUNruZ15BQlaV2p9bj9j2eyB3Im8p0ggjMueJpp+2jGj3iQE47t10+TFSJYfA2AOvCaWLG2EPK55Nva0TZw1fgq5T87HSqXmxnKcV0aM0JT3FqU/mMaM+0JhMtkxXBgWEi6zUvOvK9zxvVFYWijEM1PSZH9BpfGWtxdyZC2hnM4Lt4jViNkeLWQ+oN8rx4imBggqF1AL+LRZoCFbB6vL9Edpr9G1Qa8otkXmPo7nebZBqaEd8ECscKrM5szuDW0Q7hGAlSHrefxQNC09Spg/XcAUI0uUiXEJgcq0kIBeFz+yIxQsh+FlUw8YdGNNpXL29UBDQJ/ju2O4gesSukivO3ZRr84mMMR6RUSs0dP6xxr6erHCTbJuiNqqp+Fp2ZF/252LgyLYxNX148VsAiQzYUXkG0Jan2zhzbI+9qucnYt1Im3DEEFs+edFpdcUnvBaS3BQX/PJ6toDlHEn4KKfqCzMj4pznf2rtnx93IAb0mkhe9dQrn4sCAEtKFi760jY8RRPHHpE104eZiVZjl4F4SPBMsKbcqhjdjA/3WjcXoHK/+j+dGHI8QLf0VnwvuQftzQcTn0AIulL7ntwedXyyuegKQKG9moy6ZR/eqH8Ogww4bGd0HXXdhmLYAoxUmxtUIMWkrpp4dnZRPoTLflM7C+MBAJ7ngZTcTL9CFZPcW5hz3ITUZt9cR8dPLLYWHBBItnD9lDwVr0CoO6cb6Wzj/5HrEmQPU5
 hCgZMw3i
 Y4Lu7Cr9nHEVL2UbUpBzvaVhAlwoMsGW+9vNIJLgQZaR5+0kk9cfnCH5Vk3Jrr3R3QkSbq8OATUXKjF4HZBM0ssl9JcM3t3Vy8bJv0GxjlXRyxWGOM5O/S76kTlkhat1N00nvt2ic7JXmuQDUR3KOpFAl2vZVokuhDn1Z2hw5qSFmzf0Ya626EQ5PsTcGvJoRLaDY8iF0qrDUpJ6vWmtBxjOTobcCM6Usqp6ZNGG30bvOkx6KNa6DesHkk9YrNz5Qs82vkYQXXhgNMkqEuQlXsoEyNJWn7vkZz+AF/f5cHWvgQKD9awkYcNeCK4YPjYzfv2uQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 10:23:06AM +1100, Benjamin Herrenschmidt wrote:
> On Tue, 2026-02-10 at 16:32 +0200, Mike Rapoport wrote:
> > Hi Ben,
> > 
> > On Tue, Feb 10, 2026 at 07:34:15PM +1100, Benjamin Herrenschmidt wrote:
> > > On Tue, 2026-02-10 at 17:17 +1100, Benjamin Herrenschmidt wrote:
> > > > 
> > > > So ... that was a backport to 6.12.68 and my original patch is
> > > > crashing
> > > > the same way ! (it was working last week interestingly enough,
> > > > something else got backported that gets in the way maybe ?).
> > > > 
> > > > I'm going to have to go back to digging :-(
> > > > 
> > > > I suspect the pages aren't reserved. I swear this was working :-)
> > > 
> > > So I rebuilt with a bit of extra debug prints, CONFIG_DEBUG_VM on, and
> > > memblock=debug ... it's not hitting the reserved check, but it's also
> > > not crashing the same way (still 6.12, I'll play with upstream again
> > > later):
> > > 
> > >   .../...
> > 
> > Do you mind sending the entire log?
> 
> I misplaced it, but give me a few days to dig see if I can find what's going on.

A log from any nano instance even without debug would be helpful. I'd like
to see what e820 table it has.

There always been some gap between e820 and memblock because historically
e820 does not consider some of the reserved memory as memory. 
If large enough parts of the boot services memory are E820_TYPE_RESERVED,
there might be no memory map for them at all.
 
> Cheers
> Ben.

-- 
Sincerely yours,
Mike.

