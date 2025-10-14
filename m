Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A051CCD192
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 14:38:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51AD38E0131; Tue, 14 Oct 2025 10:38:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CB308E010A; Tue, 14 Oct 2025 10:38:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 408078E0131; Tue, 14 Oct 2025 10:38:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2F4B68E010A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 10:38:09 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D87FA16096F
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 14:38:08 +0000 (UTC)
X-FDA: 83996974656.23.31525F2
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf01.hostedemail.com (Postfix) with ESMTP id E9E1740006
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 14:38:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="N7PD/BUD";
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760452687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O+WxWTN/C2HyVblMAccwywFAotrd7QpsKNQRxf1sI58=;
	b=8KNNVUqKHR1nFWxGSyy9VcNw4T5/ryxFGRm83hfngRbDFgEWx+rtm2ufzsltovQl1UtPVQ
	hqdVB00oSaQAx3vncpL3xGsJiTJv1YX3d59OdLfwu6Tnlg4A9Ih+jqfWpw+vLBErmKDUJ7
	Ez/ExwN/g8gmXrcP9H4Bffy0cd5e6Uo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760452687; a=rsa-sha256;
	cv=none;
	b=FHf/I4bj9cuoFr1NTjIQHWrxAMZuLZgVXe/LwYdb7I/wGA4/DbI8s7m5s4ghQSBXroP9/K
	r6GUpfb16SfP/jJDEjpwVeWr134ggw0EKEpXOh1eTu0MDS8qWoHBKMo8hWhMjvh+S9TPYj
	J5BRuceuT70mRgMeVUuw1F7T9cpxbZw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="N7PD/BUD";
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Tue, 14 Oct 2025 07:37:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760452684;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O+WxWTN/C2HyVblMAccwywFAotrd7QpsKNQRxf1sI58=;
	b=N7PD/BUDXc/bOVA2AS0yKahxhqfyPMfGVj13erv8XHxrFxgs9quAQp7uIdx7ICDzbZMTS6
	/pd4lzjh4mPDJMpa+8NUiKnRE6quyJb5WjesKAC5YmqWv0+fbd8lZDwA3zzAFWkaSNd/WK
	yqDMrA9ChLKXKNM0Q+XNxGFRKTJ5ncs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Barry Song <21cnbao@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>, 
	Matthew Wilcox <willy@infradead.org>, netdev@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Barry Song <v-songbaohua@oppo.com>, 
	Jonathan Corbet <corbet@lwn.net>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemb@google.com>, 
	"David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Simon Horman <horms@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Yunsheng Lin <linyunsheng@huawei.com>, Huacai Zhou <zhouhuacai@oppo.com>
Subject: Re: [RFC PATCH] mm: net: disable kswapd for high-order network
 buffer allocation
Message-ID: <pow5zt7dmo2wiydophoap6ntaycyjt2yrszo3ue7mg2hgnzcmv@oi3epbtyoufn>
References: <20251013101636.69220-1-21cnbao@gmail.com>
 <aO11jqD6jgNs5h8K@casper.infradead.org>
 <CAGsJ_4x9=Be2Prbjia8-p97zAsoqjsPHkZOfXwz74Z_T=RjKAA@mail.gmail.com>
 <CANn89iJpNqZJwA0qKMNB41gKDrWBCaS+CashB9=v1omhJncGBw@mail.gmail.com>
 <CAGsJ_4xGSrfori6RvC9qYEgRhVe3bJKYfgUM6fZ0bX3cjfe74Q@mail.gmail.com>
 <CANn89iKSW-kk-h-B0f1oijwYiCWYOAO0jDrf+Z+fbOfAMJMUbA@mail.gmail.com>
 <CAGsJ_4wJHpD10ECtWJtEWHkEyP67sNxHeivkWoA5k5++BCfccA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4wJHpD10ECtWJtEWHkEyP67sNxHeivkWoA5k5++BCfccA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Stat-Signature: jet7auk4kt5m1n7sucydb68n7f9xnbgd
X-Rspam-User: 
X-Rspamd-Queue-Id: E9E1740006
X-HE-Tag: 1760452686-669500
X-HE-Meta: U2FsdGVkX1+8pO9bw+CFDsk5LD/eTfNhqgm2KX63dmcpRc7PaIKv6wk3afxppkeJ8iRzRT3RiRRSzAeVhbn1ikwUtvbba7CiJcucr8PaK23hMeI2i0v0jdwx5/Y1SxwttWf1h1RtUdi0cx4PDdhsskn3t6AJyjSNkMxvLWkmA/FHmJcZDUVguB3ev6asd5RIjfAHFTcXQAamf24+92qisv1IqQNFkDKQskhL7NKyTHFUutugu7d5RHi/FenzjFPBhpBFpqBu5u36GKU7LrTY0LWcnPJKH0/DYBjYXiZhvG4hHmPx+eD7YKJtJrUMD/SAvp0has56L1U61o1hqIw+YVM6qKVwZV3F8HBGEh/NVsFVQp/6w0mXLiu5BQyl1HWsxDwsAUbi05aJawbr5AyQhqM5L/38qQo7vt+mfmC+vsqOOWsbfH2ESmCaf1vdFKGDswKAeSoKv2KBCXHSdYo1C5PQIBlm/rglmIHeTW6K9y8Cbe6OnFTZKidRa5uu2YFcV9L4LUItvyu7ILPEFBtGdCQpO5mDC+UsTRdtU//yafyRE+t3/uiT+89WzWz1awhnAWAxgcG4plaaRbKWgqQuUaUOr9wp0ZBRqqufKn4Y8j7FDTx0Z01yQZcTBgUW+NUiWXP/f8Hz5+adz6Qlj+yfxxxAXPcR0u9Suqo/M9djv4Hq2DZAiRDgKQN4JA1W36otcAmOSLE+EwMYi5pOZCzvKWICGH8XHu3RKoE/cWdbPyFJe3YB+D+jXH1MvKSMrEHadWgP3cuPp9Dpjp3jB48oWCHb4tnaKK49+iR7fSm3lkYwxaUqU/z5dDci+CowcTTN5CRqtJ3Vm9/RXyEtLLtn5lbPVVfFnzKpvPMNgIewQA8W3h9f/ZZSPpUdtQi7ZBmccJWk2MGxD8z4ifLsrJtJ+3TWjbVfuZn6XBDhwg7lXrALP1tnJdwOWBMpEC4O8teQiEK3uPWL8PVmXJpukqJ
 vW9hfREN
 0T+gho0zeZ0RAQc0yFjHC8JvRmTU0cAoW7p/qcmruA3EX4vCh1KDNKrpr4lCbQf81Jqk5DqQ+8z+zDsd6p+KSujegxKwhQCt95iXaT/NoXPKDzXAixhgQxbAuzHsY7HE1WozGmi8q80pnZqryTyd1cl7U2XpamUElC5UJT2LDy+EwoLhJ0SmlHNvZbh5eSiBcqszcu+XX/NtIBSB9z3ZhuzMItd13JV4AcWOXTdnT1Z3Vxg7uu3V4ghK5Q1b18sebig4n
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 06:19:05PM +0800, Barry Song wrote:
> > >
> > > >
> > > > I think you are missing something to control how much memory  can be
> > > > pushed on each TCP socket ?
> > > >
> > > > What is tcp_wmem on your phones ? What about tcp_mem ?
> > > >
> > > > Have you looked at /proc/sys/net/ipv4/tcp_notsent_lowat
> > >
> > > # cat /proc/sys/net/ipv4/tcp_wmem
> > > 524288  1048576 6710886
> >
> > Ouch. That is insane tcp_wmem[0] .
> >
> > Please stick to 4096, or risk OOM of various sorts.
> >
> > >
> > > # cat /proc/sys/net/ipv4/tcp_notsent_lowat
> > > 4294967295
> > >
> > > Any thoughts on these settings?
> >
> > Please look at
> > https://www.kernel.org/doc/Documentation/networking/ip-sysctl.txt
> >
> > tcp_notsent_lowat - UNSIGNED INTEGER
> > A TCP socket can control the amount of unsent bytes in its write queue,
> > thanks to TCP_NOTSENT_LOWAT socket option. poll()/select()/epoll()
> > reports POLLOUT events if the amount of unsent bytes is below a per
> > socket value, and if the write queue is not full. sendmsg() will
> > also not add new buffers if the limit is hit.
> >
> > This global variable controls the amount of unsent data for
> > sockets not using TCP_NOTSENT_LOWAT. For these sockets, a change
> > to the global variable has immediate effect.
> >
> >
> > Setting this sysctl to 2MB can effectively reduce the amount of memory
> > in TCP write queues by 66 %,
> > or allow you to increase tcp_wmem[2] so that only flows needing big
> > BDP can get it.
> 
> We obtained these settings from our hardware vendors.
> 
> It might be worth exploring these settings further, but I can’t quite see
> their connection to high-order allocations,

I don't think there is a connection between them. Is there a reason you
are expecting a connection/relation between them?

