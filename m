Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75EB1C61DFD
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 00:12:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 627716B0095; Mon, 31 Aug 2026 20:12:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D7C96B0096; Mon, 31 Aug 2026 20:12:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5187F6B0098; Mon, 31 Aug 2026 20:12:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2EAD76B0095
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 20:12:10 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9252640336
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 00:12:09 +0000 (UTC)
X-FDA: 85163265978.13.80EB23B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id DFCC640010
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 00:12:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="0G/0Jcyb";
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788221528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bdSr+i9cBp7FwG5sfqW1agj3CB0fz+rTkg3Azl7c2h0=;
	b=HWQubeykBRoaGdU/Q3p7GRiR/VypvbHk6FMCpSENbZSdG2N/wpYG396dJGlEsMoyYQIsrh
	ug0mOesI372twJjiDTF4C6Iid1J53sJmXj//TrxTZ6ig4zHON+HJEBba7C/96NNNy+XP2S
	Epou/OwgMn+aPYiPJXBKno/BAZ4hpRk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788221528;
	b=xWzmSIuJw4QvLhcAXNQ2s8A1m0umE582L3V+DhuZGcwo599Go/JBNOqQA6yF6+oRjSv1yA
	+8f/JCiuiy1ScPmeNSSqQykbtUnOhJ6exsdME7wnvzWmAWU3xcxPEv188OQwfGLrc1G7Wm
	nmjIbLYq5/Xc+TGPZcezHU1MLudJ2K4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="0G/0Jcyb";
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AF400406FD;
	Tue,  1 Sep 2026 00:12:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57EDF1F000E9;
	Tue,  1 Sep 2026 00:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788221526;
	bh=bdSr+i9cBp7FwG5sfqW1agj3CB0fz+rTkg3Azl7c2h0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=0G/0Jcyby3mLtIFfRj9YYzME6z+ZmSLTmcxgR0x5iTwgW5ZoRT7thYuOiq5Poa92+
	 UKxQTOlPKsnhIe7GDmY8oWUEVEs+M6UrqvfFDzluqf1zlFHKGeF8/2qfiLQRBXh5WJ
	 uREfa7XESaC18PPOPJ8HgXzYoGcELmuXx3bjO+6w=
Date: Mon, 31 Aug 2026 17:12:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Kiryl
 Shutsemau <kas@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/gup_test: report actual pinned bytes
Message-Id: <20260831171205.9463e83d82da2a0b403da26a@linux-foundation.org>
In-Reply-To: <20260831101304.162867-1-sarthak.sharma@arm.com>
References: <20260831101304.162867-1-sarthak.sharma@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bkzoty6dn4zh9e5m46ejht5prfckjwyc
X-Rspamd-Queue-Id: DFCC640010
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788221527-327686
X-HE-Meta: U2FsdGVkX1+IsiWFrXxrsog2v+TIv5SWqc40N8RKwweZHdm+h6BHDTRaQVIIjS6bcelvj93SYlrJd2fP5+rzJKrscH9XH95ASs4xfxhFPvgELqg7mS4aRuxFJBIZTykIZzZN11XDRVARfCXMBO7IFLezP7jsc5lvANXGLcU6HD8mF+Vi5okObUzUs4QrctmM8pavhvmu++QnWnd+tYz/ggFD9nCp2uBk84FPBsDzI3SGkpSehP1DeeVmdjxvT+as3iZq4+WNSKCbAzi1YvYztZ3iUducnqXYQBCnVG1Unp+Hn6T1gdQb22QYPgjQHELsT+HSdnxXCWanIHGKDYf4h+8fZUZb7nvLUajlJLNriqCJhzTPphVbW//Lt5QYiRIhPWsuHZD37nMDOMgf1xiqk6vy+jVoDR3mJMmT7B9C3dDB9/p23F/EsvPrXFfnBCucX/QPXC3OeIWa6UFRyoDgayDTX8kI5gNgdy92DW3nkBfALG5nt4pkN/GAExLJbO2iBZi9ct4KBcHT3OCb2k9tEmFq247UBy8DCBSK/wR4uj1jwYj7umBNj684gftqq+apf1lRUvLFl5pyZ38fRVjI24tKkamt1JCBwk2A5gTSBzrceqCW1TXFI7WUNXmgnRmI4xgvBG5Gl/f8d48NOIsO+Si481MLqsLC4KLm1rawhkLorhwXlgnTONxdsaABdq5XMy3U3+zRqjIeBW5X78aXG0Iy7ITzPMD5O/HZePyeSEEhurD9orBE54fmjqwpTM1tMjR8rlLgeECSS4NFOOap/6RPxN/1TLY4S6QxbKIEgbTdP5R/ccIjZQMw3jujZ6fSRCCoWEGUplzIhjnJTBvFcD3Db2kSmKkNADnbde5yVGncXJjJHJ3veAGNxvUrhxx+v1gP24mWhvKr82rdlwwxheoCkEKhB8iAatEod8V2NlEWUGY8M88pV3SFDbs3IzGBwP/+IYLIxWT7CNS4LKl
 z0hD1o1s
 +xh6qZE/KVZnLlNG1kMlp9GMlSWd6tpBIdw3CLp4+uBZyoMVNMlcKj0ZigmpauO5suYaLsU79HOzCNyTMcDV1W9jv1jIg9dlKNHjf50XbRtfrdFONWhp61lihLoU85cVGkT7iSTDKTuyjPAVMCCBuGzp79b6PWRFsit86PpnpwmxWWW+cVL8vLYhZGGSAjr0pJHhEd+XRIGYZ6Lxmhr7hXESQPueVeUjUbiCn/NrlZVJRKIYaBcdGhikchnTOhjB5naeSlG2N6wI07EVxQ7OJv4V8D73kdpz1d+rvRYLV80wRYmELF5WyZ6vSo9j69ctuj7SMjlgkHhFU+tFIwaR33uoBDZJb8XeWSXJ8+hzG1bDUu6welJV0JnOuVNu8keXHvn+Zj6XJJDrUGxd5heBW72rk27gQQGiuPpeUNistL8L3wUfm7VeJ3TPRl6WuhlMhbco01yZ3fQOu8h9+8tHJtjV/9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 31 Aug 2026 15:43:04 +0530 Sarthak Sharma <sarthak.sharma@arm.com> wrote:

> __gup_test_ioctl() advances addr to the end of the current batch before
> checking if GUP pinned the entire requested batch. If GUP pins more than
> 0 pages but less than the requested batch size, addr still advances by
> the requested batch size.
> 
> The next iteration detects the partial pinning and breaks out of the loop.
> Again gup->size is calculated using addr - gup->addr, so it also includes
> the unpinned pages of the requested batch.
> 
> Calculate gup->size using the actual number of pages pinned multiplied
> by PAGE_SIZE.

Thanks.  Sashiko might have found a somewhat-related overflow on
32-bit.  Maybe fix that while we're in there?

	https://sashiko.dev/#/patchset/20260831101304.162867-1-sarthak.sharma@arm.com

