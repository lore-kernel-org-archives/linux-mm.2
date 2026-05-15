Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF61ACD4F25
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 13:41:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10E5C6B0005; Fri, 15 May 2026 09:41:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C0666B0088; Fri, 15 May 2026 09:41:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F188E6B008A; Fri, 15 May 2026 09:41:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E105A6B0005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:41:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 62A731607B8
	for <linux-mm@kvack.org>; Fri, 15 May 2026 13:41:58 +0000 (UTC)
X-FDA: 84769767516.02.295C00A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 896FD16000C
	for <linux-mm@kvack.org>; Fri, 15 May 2026 13:41:56 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AugRaeYN;
	spf=pass (imf08.hostedemail.com: domain of rostedt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rostedt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778852516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KWH7vaNhM6PmdSZb22BZbRvMdnfDKgvemK+XoxUxSSo=;
	b=ywxJ9jfvaH65Cb7iIlCV2qaoKNhwpzL/9dNZg7Gf9n7Vc2DXrwoOEv3rt/6WVXq6SnRpUb
	O3uFyVNrP9/0NNtHfcvvoITujTYheTLERESv3mGjDh9lxPlb2mBOWLgdwydmz7bvNTgFD4
	AFczzWyW1jm087CBCrz9lwoadAX2Dzk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AugRaeYN;
	spf=pass (imf08.hostedemail.com: domain of rostedt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rostedt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778852516; a=rsa-sha256;
	cv=none;
	b=tZhd4R88DSb1tbyBrgRhMCqeQG2PEZ5vxS7z6C9F/EhmW0mAGutDo/bm9H/xmJaS1M1ZXx
	uvi5OP288+exTXQgU/RAXZZnEOA15UNiwrnFJdLIoN73hF4XMSpYGeWbasB4UbgVnT4oTI
	TDQDspcyA0SW4/9K7MQbCAtSiZ/+8zY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BF12C60008;
	Fri, 15 May 2026 13:41:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7897DC2BCB0;
	Fri, 15 May 2026 13:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778852515;
	bh=dF8/2AvCYzAsPz5MCg1NH8ZqpJpB36nf4ons1zCuVUI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=AugRaeYNYhPyevIFvcHp4avTmPBe5sA1DfL4MVewfH4PM69Yj3QWKq/AMtyNAQBsL
	 HmFsdvMpHR6P0SrNxYSjXtPHuswv94obMCIlOMJz0YwyTwjWBZtgvS07GgmnQMrg6n
	 Uaaru+sWnVLF9CMoTOefQ+wHi6IW3Xh+Q81NMiV+eXRkNHg9ANqndSL5u7EC0A+Rf0
	 Evnr9T+gEAlV3jnCuawXX9Dm744ia0CgndzdstqU4ZUHNBw4pYz/2eG2rfjl1izoqF
	 MO4EPc454/yJQeNO+Sw7WiZiAhcAFBpUcOnzv8aM1FrxF2BnuR5tJIWtHJ1rjwxj/v
	 uy3OFUXWDWn9w==
Date: Fri, 15 May 2026 09:42:01 -0400
From: Steven Rostedt <rostedt@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>
Cc: SeongJae Park <sj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 linux-mm@kvack.org, Alice Ryhl <aliceryhl@google.com>, Andrew Ballance
 <andrewjballance@gmail.com>, maple-tree@lists.infradead.org, Andrew Morton
 <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2] maple_tree: document that "last" in
 mtree_insert_range() is inclusive
Message-ID: <20260515094201.5321d1b8@gandalf.local.home>
In-Reply-To: <lcr4xm7yqwxcodhpufhrmpysuhowiy3bjt4ptuk43o45ql2cbk@po7q6i2cmb34>
References: <20260514100723.4af0d7ba@gandalf.local.home>
	<20260514142311.119947-1-sj@kernel.org>
	<lcr4xm7yqwxcodhpufhrmpysuhowiy3bjt4ptuk43o45ql2cbk@po7q6i2cmb34>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ddwq5wf8gbd77381t8ccua7it5ww69fb
X-Rspamd-Queue-Id: 896FD16000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778852516-274282
X-HE-Meta: U2FsdGVkX1+E12KcmfGT8Q/rb/LGJiDXv1TPG8wkjAiEEoQ1jDMvEisP85Gq7uNUxYXqgvJbRlR3jENll7RikYyaotrl9Q6jITFh3o4hKn940KWi8ojDcEoXAnfSEWQqk4rGNKLJIMmWVas6mOaumO9n+wX8G6clkLsAWDVJv20hLqlOoh/4PtNgFD6kJv2AS/jiFZAjEh2PcBQYZECCiszXLvaO3d3RJ2mzLR9j1M+0j/ocM5odwb8NUmJ/cY/kDJW1H86cHCGsNHTk3SmonnmAVInEO/G40SWFn9EPYXCKiSyEfdvCPjhgb/0rfLuyTGRVeMH5LfQJcQGsggLcgZ+rT3p3h/T1NQsRLeN4uRABzanhfgTZFoP+aNGiEeiFuTWr552krqDK7wO13VQdovrO/Rp1UmjLpOEZYS1oBsfWEc24BVNkmCE4ZCmbp87RXjnyFEBg/ueYLSZpvNqB7qCYtst4SbUvwiirBnVV8u5OZCuD/2DpaCRwHPT6bG9QoPE/FtEveOe4bSbu1CHSj6EDvzn23apeHLPQf9A5b3/k4/LYkyGNBiZHUlz+7IeWW8J/fMeFpDqyslN/jvmkY2Ndq7kICknf6lKx5LVQk11Ch8uKG5fAMpo+t0sTrc8imtsysXSby20A+s5QpClmT4WM4PYic5cjXLIbqjLTUZJcgYSlp2pn30cqRuZvY2xvHE5vZAzuyPESRZ1v0uoVnRSSMvrwTJyypWllILC1yLc3S1u5aCBrlCDxgSgzR9iBTGuf+NGA7V4T8pAmnbn5ILR5WvNkiG2iYU/LRCSixW18JjWURsorIJ4PJF7CL/sdVU7SNCaS2H2Y62Flsn0faiamJqpKaIy+R+kkGUnTPZGBcriSISiLEbKfqc1qZvYiETFLj6muZTIO9auptNuEOHKYtK+gp/Z+Gp5feXJVNcSXMu3kNoBvB36rovyb37u1SmLOv5409d16s8zs0b+
 LlUSZU7v
 YnPnzGxVxuYcGVCZsIEPahGO5RH0REiZR4k43IWOq+9TgnQvl4EW33sH83DW/Mx46rdV8HdAac9q7QGzgYN0RWxvHmvdxZQYda1v53cK+bFLOjvkTUujherK20Rb2Q3xDinEJOqznMfxdUIm/NtlqwqmU1bz6r9VN5PkinY125xK/L4JD8gDcXnuIQwem/826ANVwcIC9L7XpUh5q05g0ZCbR8hsELNsX8PdT8PfgEYmuUrOjqbJi5D1AagoVYt1SIUpTWJzAv5H/+rxRGeHRikFJB2yDi48x4GpEcJXtSacl32USlxBVENGYzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 15 May 2026 09:35:25 -0400
"Liam R. Howlett" <liam@infradead.org> wrote:

> I'm happy with what we have.  Steven, since it wasn't clear to you
> before maybe you can say if it's clear now?

Well, since I wrote the update, it had better be clear for me now! ;-)

-- Steve

