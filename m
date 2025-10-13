Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 222F7CCA476
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 08:06:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EA1B8E0016; Mon, 13 Oct 2025 04:06:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79AE98E0002; Mon, 13 Oct 2025 04:06:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63C298E0016; Mon, 13 Oct 2025 04:06:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4AA678E0002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 04:06:01 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1ABAD5840B
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:06:01 +0000 (UTC)
X-FDA: 83992357722.10.0D2BE84
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5C6A840017
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:05:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JoJ5YBKd;
	spf=pass (imf01.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760342759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OXwozSeMlS70Sl3oI0odNiKy3vdryBhBgECDo9dwsrQ=;
	b=1Vh5prBTF+nsVIo/D0FeuBpulC+rlZtODEL4k8ca006AMoZ/bViHblysW1Sjq+Ei0+7ZUl
	OfLkF4YPpX4NE4D3d3Jp90UkoELFtFaKYMC/45Ud4lxgO5oBbb8geApwdGV9h7qyv7jebC
	u6VV+GSr6o63KhqsA8xnpvF2GdXBPAc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760342759; a=rsa-sha256;
	cv=none;
	b=26AnuO/LkfPmezPzt4yWP8z4NqYl9h0auPnl8Y7tVD3z4xzyeK/ahQ6QfcJyxW2CZT/bOB
	ZtU0IqQ98OKLI+zTKKKDPS4+sQzN9jNz763uz6z4eNaFqrKiCZdTXHAYlAT9vEdl9ywJuW
	f7rrIlluIKb80UYhWne/+spY5N0mf58=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JoJ5YBKd;
	spf=pass (imf01.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A47A06111E;
	Mon, 13 Oct 2025 08:05:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB19FC4CEE7;
	Mon, 13 Oct 2025 08:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760342758;
	bh=5HsWbtZ2dcB7krEcbKjne7KnS+nPBJU93qavaxJizuM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JoJ5YBKdMmynvxsqiAkHkZbrbXNbh1kQQdkhIKnwG6b9L6o3Uzqi1X27KlKrsP3Fl
	 R+lbP/clJGXkbhS5NEhqi0WhSG87d70ezCBhCv1BktJRTGsKjbOMR2s0X7m2rPZ0Za
	 aJ89IXK3xmT7/fyqzwHbHH3uYFwcU8sSKoILbJ6+EgEN5d0jr/somN9ZzIA7z4pSU1
	 vSAsqr50CL9MnLXn4g22yvpe4Rxs3HtQAYyAu3lN/RpP31W4v5IU0188xLD7bhEdEo
	 rs2FORcAaC7QLU5udePhJZbhtXDoEEFtFdrkp7D0ifJNyNJWapFn9NwLgNGUylYwx6
	 Gyj0yBRoVk77w==
Message-ID: <227fc5f2-c16c-4fb2-be02-e7b1f37559dc@kernel.org>
Date: Mon, 13 Oct 2025 17:05:53 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/10] mm: remove filemap_fdatawrite_wbc
To: Christoph Hellwig <hch@lst.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov
 <lucho@ionkov.net>, Dominique Martinet <asmadeus@codewreck.org>,
 Christian Schoenebeck <linux_oss@crudebyte.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
 Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org, v9fs@lists.linux.dev,
 linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
 ocfs2-devel@lists.linux.dev, linux-xfs@vger.kernel.org, linux-mm@kvack.org
References: <20251013025808.4111128-1-hch@lst.de>
 <20251013025808.4111128-9-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20251013025808.4111128-9-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Stat-Signature: rh1a36gdxyxypu1qww3xpegpkntztgbe
X-Rspam-User: 
X-Rspamd-Queue-Id: 5C6A840017
X-HE-Tag: 1760342759-91030
X-HE-Meta: U2FsdGVkX1+IOByfnmTuTGlDYbjyP4l71lcgCa1FHMDQJto1gfOsWVqW3ybC6OYPfxx/nlF+UMrE3xv+BG0K3Z2dut2vYgVL1ccvP+HNmGmfaC1QT7buk16CNgoEhXFkhR3/v89/tEcK+vS7GmRf6cQ6c7+114Bj4/IhNaFWGjag09b2F8CglhUP2aOS1pdNLLCBJ84hGDbB7QfME8bM5AGI2sJByM6KaOEMLow6u8uordqh0GR2bksZcjAhPszTZp1WZYbtyE854ZlFSe7trOy43W2jPZnnIdOYnRtoPNeUYvjxSoLPEQ0V80pF3O3W3JM1ZJL5pHznuV9VC3HEshFRxuc3XxrvZhWozIBGKYM/X89jHwn/ipT2WY6wqTKGj6DlXUfLtjqvFVM7MxstrqqYpjhuFbeakDsaaUpZYNQ76XecoQUASdZzoUStzfYahwxCn1XPI+XTrbe0NEi8bJAu0maaz6aQRpcBiN27epuoX91rNzVX2sumL/zej15twDLpPjLNzwopMXHYyrVIiWoIoILgCHu3/VyD9VPYShnO4O0d7RIoNx2xBVkH7e5U+Vbx/d0eIPkT/nmFNqRsEn5GDbbtw+g9Sei+hR5ouzSj0yUbPcp9q8qetYLuOH5yOZ2NijJjzA+by8QsOstUF/gJSfcBUE4Rgs44RVc9SYv4REhpc85R4mjrzKu4ulGkv2UK6RxHs+jf6EBzF7X6vao75sdwmE5x2p/WHBOrqCLE7ubYPIl1HkkJGPoGH/DQh5C9NEqzH7UfBP5dBPgREmmMhcbkMNZ9zE73wFgFeOnWqL2+SvO1rtzIWqBnrW8sKtCnIrbHEOnidrrDMrxAS3xkR0YDPQ9j9oUQtewY61kM83q170uSs0i7yy+6eWLN+jJr+F9eQJVuIPLNWdHrZTC5lotcin+v4NqUG6xZWkcFDl/aPxk0yCe+qdSZmPzn73/AOrv876ZEcHNDwzf
 rY5OlcLX
 E5LLXM7QtSik4tu8k0E1uYLus9I9NmcC79fihGypTrV4UKTw2tSjT0RRKDD3b4nBrvAHdbwqeobB3VTsCmNZ0LIHczzbzo7J2bvvura4f3qf+FrclxyO2AfSNYvz29J9s4MAZuvymZTlQerCuPwDM4wemyiwtbB5C+1T5L9rqV1epKySBaZlh+9VspZ7mf7Ht6HJUKd8X0sobGLBn/1X5kULAznvmX7tyxgNfU3XsPhZUU46Y8EtVZDoi+zPTX8RsLfJUvTdy+2aRppuAyNv6DcF9fHqhiGWTboH9/LezALa3fXaTBnrxiiKjCdQNLK/ZNH2UHZElucFNwLI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/10/13 11:58, Christoph Hellwig wrote:
> Replace filemap_fdatawrite_wbc, which exposes a writeback_control to the
> callers with a __filemap_fdatawrite helper that takes all the possible
> arguments and declares the writeback_control itself.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

