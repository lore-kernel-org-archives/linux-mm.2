Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D854AC87FCE
	for <linux-mm@archiver.kernel.org>; Sun, 27 Jul 2025 11:04:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73A7D6B007B; Sun, 27 Jul 2025 07:04:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EB226B0088; Sun, 27 Jul 2025 07:04:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 627B36B0089; Sun, 27 Jul 2025 07:04:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4CD556B007B
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 07:04:19 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E24F780113
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 11:04:18 +0000 (UTC)
X-FDA: 83709760596.19.3EACE14
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf29.hostedemail.com (Postfix) with ESMTP id 409AF120007
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 11:04:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=198YEp3A;
	spf=pass (imf29.hostedemail.com: domain of gregkh@linuxfoundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753614257; a=rsa-sha256;
	cv=none;
	b=p6/zXNXS7scCAeUKlOhBZO9/g1gePE3uw+ldxwCVTdM3f1+colMfUR/rQHzlsv5Z0IrtyK
	ec+HPxSoMpDWp12wUTVACMV82gYiu0UIuf1Znn0BKt4X0NJt5PDsTeCw4gTFzew6UhVwc4
	uc+iB9lKwEIAiZgPEsHZ0b8gS0FyrKg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=198YEp3A;
	spf=pass (imf29.hostedemail.com: domain of gregkh@linuxfoundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753614257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4nMOqWPEKS9v8wijo9DCNiiX47Yi5DdAc2AZ4z5jE0A=;
	b=l92m6TXm+gPW4/U9VLKW7UqkvevetISb/fzJRyswllTwqAlxetC/c9hJNDcaPeVh14oxnv
	Dy81hFGEq9MUYlVg+6qNT4LvCuG38NbVeWE930gDv3S5XNeiMD0ST41KcQtobVBY31r8UR
	t/xRZaCv7riVbNvEmfGf9uKnaZg9Ypg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 3DF5C5C56A0;
	Sun, 27 Jul 2025 11:04:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FB47C4CEEB;
	Sun, 27 Jul 2025 11:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753614255;
	bh=hOWw/pQy6Gz+KVeHJutSYWukt54uM2KDMCpnL4Q6wYU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=198YEp3ALIjYytbTi02mn4kw6encHSj1jC2SYJuAv4835uk8JXxqQasyOHKJ/bjRC
	 6eDRHfRRe88iH0zhthwJtrzkQuKCc4MzRozWibL7k2NyYOz3qJ3zBSu7zgZ+y4eodr
	 5iuKcIPnSIYRvvZQ4p5Iu/okgBZcfNffekW9832c=
Date: Sun, 27 Jul 2025 13:04:12 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Danilo Krummrich <dakr@kernel.org>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@redhat.com,
	mhocko@kernel.org, zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev, lorenzo.stoakes@oracle.com,
	rafael@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] mm/vmscan: fix inverted polarity in lru_gen_seq_show()
Message-ID: <2025072700-jailbreak-canister-2aea@gregkh>
References: <20250727105937.7480-1-dakr@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250727105937.7480-1-dakr@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 409AF120007
X-Stat-Signature: hjhus3x1er89jc9xw5m63ymwsaw8grk7
X-HE-Tag: 1753614257-193256
X-HE-Meta: U2FsdGVkX1/I76TYLoaGtzz3PVUApezsY5lkEugyr6UqUYNi5JrRJOxefGhbdllyjYAlHDGS8EqeJphjUoSMwk4m/5O2LaH9219i1lhpZMgCS8KxT4PU1NiCrhwzdvPR1ARwo9EJ1Aiby9I98nFO9FZJ1cuzB03xoflliRerdjj8JY4KIKq26uDuhAexjX38UnW0T+4lvq7Y4eeU3nNhkYvTMxWVJ7n1BvWCKyLdt9E76u9yN8mF1wC1edeFJnUTCYrnhEoS5U0IzGERt77RVe5zrWTWrHqXY5bP1TLaOqvODncFOyHtojJnZwNrNX3yASkSLjUNnd18cFqj5NmrUEeC/6wsorphgq0amCT9vQjj/x1qEW3EePVfo4TWSzXvi6tyCEh7K11GT0sCWSTQFDHaPoDQqLxOo18OZ8qOyZroca563R7EHprxGkxW7lsKGugbo+ajSp6DAnrtFsIJ+qh5UZoIhvTfR3PMoUiNUDtDfeQ9DywrFCd2fZgu3oqxuT26jJcYVWTlclb4rFq8EAGte6cwSrJmvBiSD1hyIf6ZuHW8TaAlgUTH/Ru8Pqz4lhUALkhe9rfpCNfQC02Zxn20J3uOZ/csZ21jHEAKGtoieAnDKgpTG4LcnONVG48lSQQY2va9k38YfHUgLfC+Zpbw5j/5B1mPAT/mAMwZ2k24s8R0D1GVhpMcR2tFwDlOnx8sgwtQvMC0mTnDrcwdJDQBcmkYcQa0qIkXY0YX1WZS0FGebxNpwemec9AkkY0V06p2lHKaaU2C8+/cKpqmbS8x/UXQRGgtwNOE8J0p6RUk5+mU0Jea1LMw8iuzxilfd2JR36eA5UtOLHtfKsNIC7Sbl+1oF/JLP4dFWWuiv7k/ifa0ia3kCJpXvNasoHtz5Gajam/Sw1QIFntoimSqdujOO6Y4CED7eg3Rsob67DIOZzTkEtOFOAU+n5nPqYqaeD+/jd7qRRonP+VQadj
 hAHDlJgD
 oxrrpLTDwEbQPbinDlAc5tyhdbRZAVAtt/amX12ra8aQE5rAVybMchQ0pSrzXnjGl6wkEBNZS2Bt6GEdOOVwwBHritoi2D4QXI3rjpKNb5LiWy7wMsfZf4zLH6VOqgbMxwbYgezCeQB427We1mhi4IROeBQot1MCu01b3HWG8vNWWv2Rw8W1IJQo8BkLj77rfxjjbf5F758CL0FBdp28gqLXqb1Hm+hROXXI8aeI56y6saRb+A9fqjmm5QAG6xAvgy2CzhINA7Hv1mvrizoVzlv97JS2B5hnscISXpD9Uf1IBMR+jm744NtLBnSSsEVXycYCCqthZUNaK6niPqv9grKeeocAHMJyjmcd2dr45j/R9sCW0ZcjP2ZHkVW7KTn0WxbVzOeE8jTcwAv7coTwiVSsh0H7BtcXrDo2F1FkwZwhgLr95mLZYo7vg3JvXWtslWB5yABlPG3/8bUl+HbNJa8hDfybBfOWDoIXofCESIQthngv2Zf7VzzHVxRbtQn+PFmmj2gXyJJRD/yT6ZlvZDRThbHZQBApjcYKo+Z27PDRz5Y5JZCJav1RdJFM0SOl6Abey
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 27, 2025 at 12:59:06PM +0200, Danilo Krummrich wrote:
> Commit a7694ff11aa9 ("vmscan: don't bother with debugfs_real_fops()")
> started using debugfs_get_aux_num() to distinguish between the RW
> "lru_gen" and the RO "lru_gen_full" file [1].
> 
> Willy reported the inverted polarity [2] and Al fixed it up in [3].
> 
> However, the patch in [1] was applied. Hence, fix this up accordingly.
> 
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Link: https://lore.kernel.org/all/20250704040720.GP1880847@ZenIV/ [1]
> Link: https://lore.kernel.org/all/aGZu3Z730FQtqxsE@casper.infradead.org/ [2]
> Link: https://lore.kernel.org/all/20250704040720.GP1880847@ZenIV/ [3]
> Fixes: a7694ff11aa9 ("vmscan: don't bother with debugfs_real_fops()")
> Signed-off-by: Danilo Krummrich <dakr@kernel.org>
> ---
>  mm/vmscan.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Nice, thanks for fixing this up:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

