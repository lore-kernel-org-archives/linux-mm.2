Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAFB0C5CFDB
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 10:55:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E26786B0138; Wed, 12 Aug 2026 06:55:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAFFC6B0139; Wed, 12 Aug 2026 06:55:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9E906B013A; Wed, 12 Aug 2026 06:55:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A0E646B0138
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:55:27 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3C0911601FC
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:55:27 +0000 (UTC)
X-FDA: 85092311094.08.B4DA4A9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id A2831C0007
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:55:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n8nYPjTU;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786532125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0fuyFHc5wlgCnwoU8B++ymoBOTLisMABJc8FzpoOvIo=;
	b=eUTj2BSi1nO5kM4z22SSz5Y9H3cw5v+mrcSw9+uXj3VDetlpGYNgYELsSwT3eSS+s4QXjp
	TZhHYobhVr/26gxoyWeWAK4xmP6AtuC8mfG5FUJfdlRjyT3nzwWI6f3wUqzq2nm0belPD7
	n0rlyUfieZPU9U9DYYcmjE3Slb6mlgE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786532125;
	b=TyIkquvZp6k4x0nryFo6U8B8m26zh2yKGHB+PfKxqgAMOEopm2h/wrZmJHmdrrdzLCLJKt
	9QrGQuORlH+Cl8RrQbTISeQtaj+jUkUwgcCoOiLaxnBtAtRh0U3kEHw/BkY4V1VFG7hV8d
	FcLUPk9lEY8na05nG48LaFu+UKd8Vas=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n8nYPjTU;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3CD4F60A7E;
	Wed, 12 Aug 2026 10:55:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 891421F000E9;
	Wed, 12 Aug 2026 10:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786532124;
	bh=0fuyFHc5wlgCnwoU8B++ymoBOTLisMABJc8FzpoOvIo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=n8nYPjTU4r/Nd5BTMnlHtCFatnQm9LWvS5aKvriT5WDtXSrov6/RjloLlQQd609BJ
	 +G89DQh9ybFgt26PdxwGCGvYh7592kAEzLdiTh+sfsMUT11eXw0FZ472s3CR1zIgcG
	 Uba5hjuzY3TzP4kC6eQYU7AUrBGYZ2T0O2di1ePKwMj090KwRprS8SBgMnrisIXZzf
	 VML+x1stzh5yEq2PsKDzuTLUppGzWe6NpmaBiYsXAgSY32m26r3eJ2L7aMmoIk0+GT
	 HkP9gazQTQYC/vi1R6za0hdZKOm3eBRZrN5AsnrpraXIhkJWIzxwlANPpWjYU7XeCh
	 RtP7C0BAoA3aw==
Date: Wed, 12 Aug 2026 11:55:03 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Xie Yuanbin <xieyuanbin1@huawei.com>, akpm@linux-foundation.org, 
	david@kernel.org, linmiaohe@huawei.com, ziy@nvidia.com, matthew.brost@intel.com, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, nao.horiguchi@gmail.com, liam@infradead.org, vbabka@kernel.org, 
	surenb@google.com, mhocko@suse.com, gourry@gourry.net, tony.luck@intel.com, 
	bp@alien8.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	liaohua4@huawei.com, lilinjie8@huawei.com
Subject: Re: [PATCH] mm/Kconfig: allow user to select MIGRATION if
 MEMORY_FAILURE is enabled
Message-ID: <anxQuhNh8rTUYqpN@lucifer>
References: <20260812091644.224299-1-xieyuanbin1@huawei.com>
 <anxOypktGGq_9PZw@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anxOypktGGq_9PZw@kernel.org>
X-Rspam-User: 
X-Stat-Signature: y7hskamx8gaq6ef4jny9g8h8np1up7hn
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A2831C0007
X-HE-Tag: 1786532125-624795
X-HE-Meta: U2FsdGVkX18vVSxxBk/OjMT8+J1x1cU4sKbV89Yh9etT7EmCe5f/tI7Osb57gl4YblHJVdk4sdtY84Ruk283NkPtY1Sa6p8QPAaq0zZQJev+HUCNpJlogrIHVxs2/dXv9FrIfXQiDcJ98mshU7PySaL9VvSbl5db9hBHCBdjZYejbVJiL6PP3jXMQ+woXE7Z05h/wUSm+SuEqNlRWP6PS8YJL1vrPV/WdRrQo1ZJEkeVZvhIMYcKQJReqwwmdHSr/bu0pV6q1+Bbf/A+RkQ+g8jUo4JlNTrWyVpBe2kwK0ar4D8BD4hFxOtlgCD12ydBJ0Z8aWzwbiRVQPMfyyI9vLgbUmZw44N6YX4ylF0FW1T1JFR7ugZruMlX2EwK4KZa9LhGqgVkqNgoKwDHIGLrUy0CarUCj0kZyqhtQKXAlP9HVfWteF1lDKt7N2fdzOzqkpz6Er0qFXx37b2RbUdSRwyPAN6SL7INvLZMYCkrTFi9lPdpJ36EB5ypz2MwhCwPid6xD3bG2BzQKCvEpNvlCdZUpSsgIGn9TgQ/LqZ9renObXOqGcxGV+vMCypxA9DVqfthu6ihmKGy5MAGOYRSs+By+yrjL+J/ium5QJybgVNeJ5D9klrlvv+oMn/1z+OXWotJ+7r1LRXWPj0MRSJ35Lc0VHBNFeObHG09RhB+x2xE9u2D9NCVtaOZFke7u9MJ5oxqIe85EGLptpRtWemIfdCJhcazDZ0KnIYuCV6orLf3PNZTvXSGL0NqVkc5BWtBOG8fUzxfDEU/AX0dtQSzOPpnD35eZFfpHnryoXB1+zy0tb6uOI/VQ/jqnC8kuNcwtlIsVOM8OIKv4iYMLr882Isevd1vNrxBXJtvBpbPh+J0u8l5mRC0y3x9vg66CqtmZzUsQmFUd1B3Jt7SqAlt2s0JnVUv5wFJ+0ru2AzmRDbvIqYjHvaHrY5JQUYCpcv5mdoQjjNEJ0b4cDiqGbc
 yHrEMFA5
 2dffGxm8ECBz/Ld5bHBiZ/WdOgGST7qijphsNvPGBdRJmGeoIq649ILDtAhM9tFw9qSu4vLDZZbnBJcG8/OH0rUVWEeilQzOMZYGguUvfMumvoyoZv3FBBBCfgCEbdxnbQQqjRZVHFpu05lOV3lquExIIii2tOtlK49H/E+Us6fobGPSZSMrxjU8O4fkX/NzF0d2UZPd+sYBkmWOMIUU8WocuDXlxeLtxoQfCQjFfjNIeCV7WbElWmGkgXEiXEgotOsRDpjNBFnfK9oP4sI7GJH8LCYoEVcqtriWiQSHUM/t4BeH5dHRnES95yX/l2XtuUUK1wM73k7cx5tArl3wDSJSn/y8SA+fytJwwNXCH6cdgdQJtTEAzp6a3rSeylLCeKVa+Xr+5N0dTPhw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 01:45:30PM +0300, Mike Rapoport wrote:
> Hi,
>
> On Wed, Aug 12, 2026 at 05:16:44PM +0800, Xie Yuanbin wrote:
> > Currently, memory-failure can be enabled without migration. However,
> > migration cannot be selected by user when memory-failure is enabled.
> >
> > Migration is very useful for soft_offline_page(), which may be triggered
> > by correctable memory errors. Most of the anonymous or file-mapping
> > faulty pages can be migrated to other healthy pages.
> >
> > Allow user to select MIGRATION if MEMORY_FAILURE is enabled.
> > Also, select MIGRATION by default if MEMORY_FAILURE is enabled.
>
> Do we want to make users decide if they need MIGRATION when MEMORY_FAILURE
> is enabled?
>
> Just make MEMORY_FAILURE select MIGRATION.

NO.

Explain first why the hell one of the other options that selection migration
can't be enabled.

Changing configs just to support a weirdo no to compaction but yes to doing soft
offline for debugging or whatever isn't really convincing unless a real world,
sensible use case can be stated.

The kernel isn't there to allow you to have broken configs.

>
> > Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>
> > ---
> >  mm/Kconfig | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/Kconfig b/mm/Kconfig
> > index 8a24c130d008..b4c217383b51 100644
> > --- a/mm/Kconfig
> > +++ b/mm/Kconfig
> > @@ -682,7 +682,8 @@ config NUMA_MIGRATION
> >  	  demotion for memory tiering.
> >
> >  config MIGRATION
> > -	bool
> > +	bool "Enable page migration" if MEMORY_FAILURE
> > +	default y if MEMORY_FAILURE
> >  	depends on MMU
> >
> >  config DEVICE_MIGRATION
> > --
> > 2.55.0
> >
>
> --
> Sincerely yours,
> Mike.

--
Cheers, Lorenzo

