Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B973AC9832F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 01:34:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A72DE6B008A; Sun, 27 Sep 2026 21:34:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A25236B008C; Sun, 27 Sep 2026 21:34:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EA516B0092; Sun, 27 Sep 2026 21:34:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6939D6B008A
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 21:34:34 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DC38B120B1E
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 01:34:33 +0000 (UTC)
X-FDA: 85261451226.05.2995C53
Received: from mta1.migadu.com (out-28.mta1.migadu.com [95.215.58.28])
	by imf27.hostedemail.com (Postfix) with ESMTP id 859B440003
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 01:34:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=u6ejsSAU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.28 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790559272;
	b=PWywC2rLSFTb2hXDzMjw3/1A1QjMf4Tfd4pHYOlP7ckVXFWI7QlTmcjOUHcfCqHQVV0oPT
	UyFDkflT5xGp1nd3P287qAm5bXeHpcNZUmGKBEEzhdC0sE1HwDJ3eajYW3DsuynVI8fs+4
	EEe4Cd1jeEIaIUdI9PAtKa+2pdI5yf8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=u6ejsSAU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.28 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790559272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kt6HlXHPm/TAGynOcD04EHDDqKgfHIJbZhEp51QngnI=;
	b=0H2zEmOXoIfeM3jHGCLC7/9xp8qkXUN3UFkgEQbgPbKBHnzMblwj2PagmZ5JXHlYO3WnLr
	1jS08H354aAKV5ScQk0rdpCEStj7jzzKVqIucjN7vQVcMWVuMraX1XHjUwkrB0epeLZpUm
	AQhTJwWBbC3+XsjRVcP59Bq0Sbdk4Rg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=HtDnyr/juEB3G1c1urS4f9LZZ2YiuyN8/uYT42pc12E=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790559270; v=1; x=1791164070;
 b=u6ejsSAUErUX+XC5r//LkwjYeh06mSDOYH6g7PJiSsKT6t+odf3SgMKEJxD/lb3/W3spQbjH
 Df8EiYmQWrvJI9zwHJxATfiWQwM7LGQhODJLKcfHasybSjLqhpGEJvzj9c5O8TgK8FYUZmC5HZN
 fmbxhaLRsvMvW25XjJNc5iOs=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id ed4aa777c3fb1996;
	Mon, 28 Sep 2026 01:34:29 +0000
X-Mizu-Trace-ID: ed4aa777c3fb1996
X-Migadu-Flow: FLOW_OUT
Date: Mon, 28 Sep 2026 09:34:26 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Klara Modin <klarasmodin@gmail.com>
Cc: Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org,
	akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	nphamcs@gmail.com, baohua@kernel.org, youngjun.park@lge.com,
	hannes@cmpxchg.org, yosry@kernel.org, shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev, david@kernel.org,
	linux-kernel@vger.kernel.org, kunwu.chan@gmail.com
Subject: Re: [PATCH v3 00/14] mm, swap: extendable swap devices (xswap)
Message-ID: <arnDuwI94lgTr7rm@MiWiFi-R3L-srv>
References: <20260916101929.149106-1-hebaoquan@kylinos.cn>
 <arTwYTK22Wm0u3BC@parmesan.int.kasm.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arTwYTK22Wm0u3BC@parmesan.int.kasm.eu>
X-Rspamd-Server: rspam06
X-Stat-Signature: rm7fk9sumuaeud69kbureo4s899ay6b7
X-Rspam-User: 
X-Rspamd-Queue-Id: 859B440003
X-HE-Tag: 1790559271-789375
X-HE-Meta: U2FsdGVkX1/PK+UgOwHVKcjKOLkWO0VLwW9M+VLRRlybiZ5k41xXepT3zAs7W7Jnny85Yno+vgCTmp9DrI3jiafWY2Ziy/Vej9ziiACvtvajx9JA+xrWjEFVddr2zknUpYuo7pmcbF+vU49Z63gGd7SeGFpszpJlTMX4KcKhJ3tYAaNAXbXCgREgdhugEncRMpJ9iIheaoLAKXocd+w7PzcWELVg2fPK6ejuRkq9oiUNszWbbPWT1vF6Zzw+2EzBgvfwpKmbmWzG6Cc5P/ZN3zG7+7L+jPQJx1fBDImdpIpaBNNTWOczYbB7eRAenaZuJYm8ldFHJCFqGf9QXI+aKXDCyw7SYv8pUpdRG9jvWhvhSNi9tjpRhCMjcBqVff9h2cv7+UfU0XqAOTNLjp1rskMGA15ft5KC2Q8Q9RbNqHtISjJ8aSEfm1GUBTNsx/JU6lujH9ee+2Y8wcLOtujWa4onS5p+G5E050nCJA6DCLP24v3mIKleFXyPAwGOh+s6tyxmoa68SMYpDMCvceFdVEubcP8k2Z6pvXr3y72ubLgaUVtzRTlbwItxrL+KjkoSTzZCb2Y9SS2DVb4Hfie2do/W7BZTXsAQQJLoFEpziAI1w7J8CJqIjSzBemZvtNi2Kg5qpctLsqG8ge+XQKjJTtETn55J238b5VprRvOJZl8lGpibDjVADCmUMskl0Srah/saY+PMF3yTtVoKqpaXlIKFcrgt8k8xLmYiJUnfmcRxmrUrcCfYhrri5G22dAwiKt3HVzjprLvcedtvHl8RwuGQLGFR2moTXOLoR4yeT+howTjNtrhwL3hdEdEsYD+j500CTfO+Psh+PS7XylvquijPF1Wxsy9ubj2dYBb39Oo2jjNcJ4XCQPSUJtXfYB0Zyv9dJ1cnDDa8OXPeGQmLQl3GOeUP0pPajHNvAoUXh7IUMA/69Pq30XIMEeF/53iR56yGiNBoohV62TTgEmV
 /q5cC2uP
 f85mMw2ALahrvNd1xjCTdU8W7DWhyXGUdIzRMDfL6N0QCoIap2eK8lMrJKnNREzqstjz4Bb0/I7mfjtt4iFgQvQF90ZOvNkpzxy9x72IjFKqBsoryeZqI7AUTRjBfmPrrjrtTrre9uKs2unfgkTMGew0waPPasjDibMpLoNi5zeRJQWjRA/uIX+6ZsU1pU2sjuTZidALVPvXNkCuANjhiuw4IdscXL4DFQaTDXMLYK47K+zt1bZMQYaiNsZ/8QXlGyrH14N0/l3EOkNmzrm+WuYSioH4aOf8Hiz6sKtpqkvDdlCzccj1V5WQGfQBU2T52ANvDKr5xZW4548cBlkKYOF13LuXm/cqe+1f6dKd0BKS6LbTqeJaDenWNFdhwdl4jk6e/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/24/26 at 12:00pm, Klara Modin wrote:
> On 2026-09-16 18:19:07 +0800, Baoquan He wrote:
> > xswap is a swap device with no backing storage. Swapped-out pages live                                
> > in zswap. Its cluster_info[] array lives in a VM_SPARSE vmalloc area,                                 
> > and the area is grown and shrunk on demand as swap usage changes.                                     
> >                                                                                                       
> > The problem being solved is the static size of compressed swap. Both   
> > zram and zswap need the size fixed in advance, and neither gives memory 
> > back when the workload shrinks. The solution should be a device whose
> > size can scale up/down as per usage. xswap does that by mapping the
> > metadata lazily instead of reserving it for the whole range.
> > 
> > Design   
> > ------                           
> > - si->cluster_info[] stays a plain array. Access is still
> >   &si->cluster_info[offset / SWAPFILE_CLUSTER]: no per-access branch, no 
> >   RCU discipline, no tear-down state machine, no NULL return.              
> > - Only an initial chunk is mapped at creation. The rest of the address     
> >   space is reserved, not allocated, so an idle device costs nothing.
> > - Growth is driven by allocation. When no free cluster is left and the       
> >   address space has room, the next chunk is mapped and added to the free  
> >   list. No userspace involvement.
> > - Shrink is driven by frees. The free tail is scanned, and whole chunks
> >   are unmapped once the mapped range is at most half in use and several
> >   chunks can go. One chunk is left mapped as slack, so the next                                       
> >   allocation does not map it straight back. A ceiling lowered below the                               
> >   mapped range skips the half-in-use rule and is enforced at once.
> > 
> 
> > Size
> > ----
> > A device starts at 1xRAM, rounded down to the cluster. That costs
> > nothing, because the mapping is lazy. The underlying address space is
> > 2xRAM. An optional per-device cap,
> > /sys/kernel/mm/xswap/type<N>/limit, lets an admin lower the ceiling;
> > the excess is unmapped right away. Grow and shrink both work without
> > it. Creating a device requires zswap.
> 
> So I can't set an xswap device to more than twice the RAM? I suppose I
> could create multiple xswap devices, but it would get tedious fast on
> systems which have a different amount of memory. Is there a particular
> reason for this limit? I think I could create an arbitrarily large xswap
> device with your previous version which needed the specially crafted
> swapfile (with only the header).

The 2xRAM setting was derived based on the current system condition.
Assume we take zstd which has the highest compression ration, the
compressed memory accounts for about 30%. So I set a max value 2xRAM
based on my own limited knowledge. I will fix that in v4, let user
decide.

And yes, in earlier verison, Jonhannes disliked the ghost swap file, so
I take a file-less sysfs interface way instead.

> 
> As I wrote in the other thread, I would rather not have to set a limit
> at all, or at least have a limit I'm sure I won't reach.

I got it, it will be changed in v4.

Thanks a lot for your careful reviewing and testing.

Thanks
Baoquan

