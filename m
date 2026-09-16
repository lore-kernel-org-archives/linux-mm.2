Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B862C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 14:09:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 474EA6B0092; Wed, 16 Sep 2026 10:09:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42B906B0098; Wed, 16 Sep 2026 10:09:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3156F6B0099; Wed, 16 Sep 2026 10:09:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0A9496B0092
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:09:04 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 76AE21C2DAB
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:09:04 +0000 (UTC)
X-FDA: 85219807008.20.B8059D3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id E153212000F
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:09:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k3IOKsrV;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789567742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P2FyxGgw1ikYY2FCX/RdMpWGC88woDzIrvMXKz3/vl8=;
	b=444VbCbImGVaQvkoZ+DKqGz7/+oRBdDVcfZQTv7e4W9ns1XVfhnItFdPHxROOcgzocuK8c
	AKNFuO/ckivEsK4U0iyIp7wx7gqTX1sZIaKTXKyuxKfEELlpInvnyX6yKS4L9VpE0Zv7gR
	vbfbtvi55Vfvma0DJaaGN+4zKu5cP3Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789567742;
	b=5DfljacdyM2+bmCUkuy4hoyesGaiqHKw3xpYZu9kQPpD1TLpsHiwUk9L2rQFPn2fZPJWl9
	TMB/Ja1oMJARrmI9jLNjxI9uEbL4vP5pKsmNcNrdqDptCLPTLw/S8qXhTEPEtERYK3IEIb
	6iGoi9qdH8NaLEUnnNb/3G+N2vmWBJ0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k3IOKsrV;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BE50260234;
	Wed, 16 Sep 2026 14:09:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FB6F1F000FF;
	Wed, 16 Sep 2026 14:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789567741;
	bh=P2FyxGgw1ikYY2FCX/RdMpWGC88woDzIrvMXKz3/vl8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=k3IOKsrV9yyi/4efi5YTBfCdN6BT4WiFqtM9xMibfeZ8L1JLvwZnt6FH4xJ5EPlj7
	 fbcF7iBBEBjlNYvZH0Zl1AevtDgRZ+t/3/Wo91VAtHPzDOSH6Wbo1AyjsPi8xrWtS6
	 f+9fp1cRGGUS8dJV3qx2C2524oHeoyofz1cnix+QBGaaZyEXNVK1m5aY0eFnWS0HfT
	 WG/4Lbir4gbnFT/FxZOTj8JXJEu1ogRq6aeB3Si12XyNlz3aybYnQiqy6A9LCcTkLF
	 BLGY4dBxqbXGvK3jCfMxqNgl/TzycjY5J/AsYTyFaXLDTJ/L/r9ytSIv6NIFFLCx1L
	 xJ3iqBqVDOtPg==
Date: Wed, 16 Sep 2026 15:08:55 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, liam@infradead.org, david@kernel.org, vbabka@kernel.org, 
	jannh@google.com, wangjiexun@tinylab.org, sashiko-bot <sashiko-bot@kernel.org>, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/madvise: reclaim isolated folios if PTE restart fails
Message-ID: <aqqi1KWDD9KMa0FO@gremlin>
References: <20260912110832.3203902-1-gourry@gourry.net>
 <aqloB0zm3RjJ47m1@gremlin>
 <aqlzzwLOVT79Ti_7@gourry-fedora-PF4VCD3F>
 <aqqTtW3vjfzH8bcY@gremlin>
 <aqqgeOtYBcRdVqmI@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqqgeOtYBcRdVqmI@gourry-fedora-PF4VCD3F>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 5sgh7do6zdiksc8bbqtyam7stm7qiwbg
X-Rspamd-Queue-Id: E153212000F
X-HE-Tag: 1789567742-200098
X-HE-Meta: U2FsdGVkX18mAwEv8iY5UG3qTUGxSeSv0Sj5xBVY6VcYaUTCh/lJeSjRwBEWpay6roavA+qJZ19ldXnTyRxC8bUVs8XdIrqkaekch6fWWRmPKNI7LpbcZ1pGp4MRo34czcXmm8P5kSH99cQu1JnX5KxNEfFjYArUDNfKvM29uXD1AVw/n5MlC8CA4HF4EpISTDel7/DPRPmOhaCcDMe4jYriuG7f7vp4y3ldA3JycAIKK2k0SRClZ1tUqh0FGqp2G0DQ8dEhQzZn9Gzla9+HA0FdyeQZKgoPgFtG4pbFBo3oV59JAe1y3i9bF7GT1Jdcnf6lv+h0mwXXQtGU3qdDVs/qmlVfsonPEtKKGRwiW5rHn4YB0T1V2B+Bbc+5KVIgUAr5gFEXZt/oTFz7qU62YnyySI4s4oIYUIBJl0U7AiaSnQPZnYI6LFEo4e0b1vN+zftBLQ3hYluAQfQ0nT9WRNa8/f3pd6wHM39/wF84pbvgcdPdCWy+dugWEkIawUIratd7g+kgGq9Bzb+Qdo8Fh5vDrufz3RBtVqRfsI/KK1SpoDJ/egjpqYv2IbBYLy8uELpsPSJNnvqv2k9VYiMlJRofLiUEtcyLC9/v9THqh7xfInrrO4QV8NHXE/A6Tv/9b/TeXW9YDwUlEtQn9iCKB7ZSZWOTAiILwkokMxLUov2vupP28XQ5+MFNnbgGMtvfjvSfaTQDzwQzDEqsVEo7yPQ8he9JXiYgG4L//nJG50eAR4UGxuikAqeSfd0l0vF5Z+3B2tY3xv1dulaGKyjE231Zh46MS4Zr69ZtYaN3aaD9nYHcY7OVUffkaaCa+PZxotcQNiz0A5MPKJveTfLtbHx5qgcUXbqvS3jsRz5aMYJ2mfLOZBCG9N3eQz+Mx0q4gjLG8MgLC90c/4xp2XPudRP2EiahtG+IYp+SHM0Wd4qlZTwq5hhblUpug2r6BeZ2OzLQQBtFF0uG0kHjbLz
 sT9UfMA7
 Vnv4pmla/FU6yf/1pgi2t6rQj+uXWnQiupaqTWDYsA+9MiXlcf93Dlvvp7PUNU7m2rCFw8fmprRIhLCGop4GrIKczWqMWKsijZvYZHoGlQ5a2alr57k24LvJc7Knq6RNOUz6SBfpDn9V8T3f3YvHZPLsv0pZq7J8n2WumAwAmGNw4by0xEKclU+4eZh6Vnn5gfRM+4+GzYQ8FkgAI+PObut0tp4zWgOlOS4iKx7Z19BJ3zaPQhu25GrNfaQ/MMfsHWobSnZLuIQne99N0wdNvaAT5JL8Ybtlz9ajBQjkUwgYSUS+xNh8uYsqxVrWCnCmAPgp4kfK885Adw02HWp1I1c7W30mD//+2+xtHqTE01GH4T5bD/bMGlxg5Z1xELMj2tnDPnMkajD18J+FPDYjQxqzcdA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 10:02:45AM -0400, Gregory Price wrote:
> On Wed, Sep 16, 2026 at 02:18:36PM +0100, Lorenzo Stoakes (ARM) wrote:
> > >
> > > relevant meme: https://i.imgur.com/W0N40BK.png
> >
> > Content not viewable in my region :'( seems I do not have a loicense for
> > that!
> >
>
> google "reading other people's code meme" and find the comic with
>
> // this is bridge
>
> :]
>
> > >
> > > No argument here. This function in particular is really horrendous.
> > >
> > > I think i'm now 4 or 5 stacks deep on the "Thanks for fixing a bug, but
> > > while reviewing your fix sashiko found yet another CVE-worthy bug".
> >
> > Yeah, I WISH it wouldn't do that.
> >
> > I mean it's helpful to some degree and it finds real stuff.
> >
> > But it's _where_ it does that and the workload++ aspect of it.
> >
>
> In some senses - yes it's annoying.
>
> In other senses, it's saved me a lot of pain debugging my new work, and
> I'm willing to do some cleanup on the way to new functionality.
>
> Someone's gotta be the janitor I guess.
>
> > > I suppose reasonable to say the goto is worse.
> >
> > Yeah I know it's all a bit much of a muchness, and obviously my suggestion
> > _duplicates code_ which is also not wonderful.
> >
> > But the control flow in the function I think is a bigger issue.
> >
> ...
> > > I'll spin a v2.
> >
> > Thanks!
> >
>
> Given i already started rewriting and validating the entire garbage
> pile (see other response), mind if i just leave this as-is?  This gets
> completely replaced anyway and i'd rather not have to go backward at
> this point.

Sure

And feel free to add:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

If I didn't say already

Because the code is right (or so I convinced myself) :)

>
> ~Gregory

--
Cheers, Lorenzo

