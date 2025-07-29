Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF354C87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 00:53:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 755B56B0088; Mon, 28 Jul 2025 20:53:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72D386B0089; Mon, 28 Jul 2025 20:53:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66A4C6B008A; Mon, 28 Jul 2025 20:53:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 58D046B0088
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 20:53:58 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C9E91133D8F
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 00:53:57 +0000 (UTC)
X-FDA: 83715480114.01.519EB7B
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9012420005
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 00:53:55 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	spf=pass (imf13.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753750436; a=rsa-sha256;
	cv=none;
	b=UAR5DoZbuptUvc5R08eF0OJBDWP1jRPCmjCSEH/Vjy03X56gZkiR3SMvDXr1nc/HdqOllw
	bafCK52a+ymDILNKlAz/aAuy4af8cTlkbgKArBzK1wR8oh0j78vshgIlC1KoGpG23XHVWr
	rfz4UqLKwEpJK9a3j0EKdRN/RiRgwNo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753750435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cxXsokvgg2CpkCcmwdiuoNxZKNsJOfi1ZAxH0GtOnnc=;
	b=Cdz5Emu6noRmxOSKvNFHmTPkBk6CUbowCh0N1Ni6EV2oXgwzE3wRj9ltyVRxQknnElrKv/
	l/ID9kc5BMkVjoBX393x4WQOUNQPZVWQDLA6Dr8Od/sbd9w9z2drCtLP9FLuOf+hNLpFrN
	NnnC+NT/L/pcZfx8Fcb98OIGpHliJ2w=
X-AuditID: a67dfc5b-669ff7000002311f-fd-68881ba231f0
Date: Tue, 29 Jul 2025 09:53:48 +0900
From: Byungchul Park <byungchul@sk.com>
To: Mina Almasry <almasrymina@google.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, linux-mm@kvack.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel_team@skhynix.com, harry.yoo@oracle.com, ast@kernel.org,
	daniel@iogearbox.net, davem@davemloft.net, kuba@kernel.org,
	hawk@kernel.org, john.fastabend@gmail.com, sdf@fomichev.me,
	saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com,
	mbloch@nvidia.com, andrew+netdev@lunn.ch, edumazet@google.com,
	pabeni@redhat.com, akpm@linux-foundation.org, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	horms@kernel.org, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, ilias.apalodimas@linaro.org, willy@infradead.org,
	brauner@kernel.org, kas@kernel.org, yuzhao@google.com,
	usamaarif642@gmail.com, baolin.wang@linux.alibaba.com,
	toke@redhat.com, bpf@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH v2] mm, page_pool: introduce a new page type for page
 pool in page type
Message-ID: <20250729005348.GB56089@system.software.com>
References: <20250728052742.81294-1-byungchul@sk.com>
 <fc1ed731-33f8-4754-949f-2c7e3ed76c7b@gmail.com>
 <CAHS8izO6t0euQcNyhxXKPbrV7BZ1MfuMjrQiqKr-Y68t5XCGaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHS8izO6t0euQcNyhxXKPbrV7BZ1MfuMjrQiqKr-Y68t5XCGaA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02SWUwTURSGvXOnM0OlZCgoV4lBq8QI7vHhuMTlQb0xajQa4xIjjUxsIyAW
	RTAxKdIIEltco5ZKcEE2tabsClTL6gqpYOoKIsVEEBWEgDQqlRh5+/Of//zfeTgCVj6XTRa0
	MYckXYw6SsXJWfkX36tzrgWnauZbW/3BYr3FQcFgAuS0lcnAkl+C4MfQGx5+V9Yh6Kup56Cr
	uhfB9asDGCyNBhb6rT8xuOvaeSiwbYDWm50sVKSUYmhPb+DAaBjGUDnUw8PxslwGLIV6HppK
	TDI4/zMbQ6m+jYcX9ywcvL/1WwadDiMLj8x5LHy7UIOh1bQS6rImwsCTbgQ11lIGBk5d4aDl
	8j0GzjmzOPhoaEXgrG5n4YInlYOMJBOC4cGRtp7TP2SQUfueXxlGq7u/YlqU94qhrqrHDC03
	v+Nplu0wLcwNo2kuJ6a2/JMctfWe5enblxUcbbg0zNLyD4tpeVkfQ43JPRz97n7N0q9VLdym
	gJ3yZZFSlDZe0s1bHiHXeO4M87H9fgnJjalYjzLHpyEfgYiLSJunn/unG5pPYK9mxVDiND3j
	vZoTZxKXa+ivHyjOIjeqzsjSkFzAYjZPKuxGlIYEIUDcTe7al3ozChHI/a5PvDejFK2IDDXk
	4NGBP3l0uYP1ajxS6sl0Yu8uFoNJzi9h1A4hycUZf20fcTO5fT7Aa08Qp5MHJfWMt5KI3QJp
	e/BONnrzJPIw18WeRv7mMQTzGIL5P8E8hpCF2Hyk1MbER6u1UYvmahJjtAlz9x6ItqGRL7t5
	zLOrDPU2bXEgUUAqX4XmZIpGKVPHxyVGOxARsCpQEZt9QqNURKoTj0q6A3t0h6OkOAcKFlhV
	kGLhwJFIpbhPfUjaL0mxku7flBF8JuvRjlX7hPQWu5/7WAobmGBJ6viuiHhKPIIDO1pCL7rp
	3fVdiutHloTPnng0opmuydg6Yxze9KtzfVfRt+0d00x7TGtDQjZveR1UHz3VVfvZTz/YbFxT
	vHqafYqiuijo7UtNX1hoXQ6T7Ybi3WftBwv9fFfYN64y7Ej/TGoN67YlhavYOI16QRjWxan/
	AEcuyGVhAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUzMcRzH9/19f/f7/TqOnyv81AxnClGefcis+cd3nlbzh7GZbvrN3fRw
	u6tb2VBKzk1HZLguMup6wLVDXY90JcVa3MkiijzN2IUe9DTpmOm/917v9+f114fD8lKJP6eO
	SxC1ccoYBSOlpTvC0pZeDTColpV8CgOL7QYDJYNJYH3jkICluAxB31AHC2M1jQh6Gx4y8KX+
	B4JrVwcwWFrTaei3DWP40NjNQol9O3QVfKSh+kQ5hu7TTQxkpo9gqBnysHDMUUiB5XYKC/W5
	zRJ4UmaSQPZwPobylDcsuCstDHTeGJPAR2cmDc3mIhq+nW/A0GUKh8a8GTDw+CuCBls5BQOn
	chlou1RJwTlXHgPv0rsQuOq7aTg/amAgJ9WEYGRw3OY50yeBnAedbHgwqf/ag8mdohcUaa99
	RJEK82uW5NkTye3CxcTY7sLEXnySIfYfZ1ny6nk1Q5oujtCk4u06UuHopUhmmoch3z+8pElP
	bRsT4bdHuiFajFHrRW3oxiipavTWCKvpn5KU1mrAKejyJCPy4QR+ldD0LAN7M80vEFymFtab
	GT5IaG8f+sP9+EXC9dosiRFJOczns0L1vUxkRBzny+8VSu+FeTcyHoSqL59Y70bO25Aw1GTF
	f4tpQvOl97Q343Hp6GUX9t5iPkCw/uL+4jlC2t2cP9iHjxRuZvt68XR+vnC/7CF1Bk0xTxCZ
	J4jM/0XmCaI8RBcjP3WcPlapjlkdojuoSo5TJ4Xsj4+1o/E/Kjg8muVAfe7NTsRzSDFZpjp5
	QiWXKPW65FgnEjis8JNp8jNUclm0MvmQqI3fp02MEXVOFMDRipmyLbvEKDl/QJkgHhRFjaj9
	11Kcj38Kuha0RPN0paeoOHtqQem2uo7ywvSFvQ8iTkdaXNZUeDs5sEMxq8rtvFJ74YjhuH6t
	9WcN9G9SzYsQs9a0Dkd6tlaFJkKdvmcFhzU2yqKgf+3Gn7emboienV0Z3hLo7iiLeuE796ih
	IJ6a8Yiw603Xc1t3Ooxu09z14XdjUfBZBa1TKZcvxlqd8jfKgS4ZQwMAAA==
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9012420005
X-Stat-Signature: q9zonmhw16cjxub74oe8rk8seo3zyfwm
X-HE-Tag: 1753750435-192174
X-HE-Meta: U2FsdGVkX18fqLetZrU7eXoD/fqA2F60T+lY13NAa505WMvKQOvwrccuKX6zRFwPDW+LxRLJmFhF5iYx8Hn/SLPuJMs1NmVpogQWeKaXZFPt/CG4xJI8qiG6KGdoGhdfjUt1IvSeAxddSJP6C1W3voFXisLWRlxCn23r98Lo8z+hZI32LtfRr45zy5bZz8TQVuQ2XjGfvlPAvPV38Ssg27gLKEcjjeqwfSlL0dz7nIcJEP7omwxwk4jjR9YWgg9ey0IwudwNx9ba5GqZT9chwRdD448PFY2qWBspsw7p9ZCYnAoiQX8oqhZlrptPFixr3scFrfDxcYyzTEHRm6y7G1peva4C0wc7DvKd3nnxhWyFL90oPg4gSK5HLoj9Fu9fBMV275CMsTxm+kmMJvdFYJguaKNcpMkKpx0R3uvxGvXmUF4Q2MMChd2Fn8HUgoBef9P6ViJa06HxdFBuEEQo03q+skqTUZsvtBO26jxqK9/3VF7s2yDpPLku1NR6Q5kb3wsRGter01Djjh5vmvUKVJy4sX0FBh6VLynjPtjJuapoho/vaSuLy/jDdSO2z5PAdPtNXqrcc2ciN3rCBdccnR7Nj1Ceao6RGx4h5PCbckUynHJK02+cM6m4ulQFOgiPJFTvxRhG6IIzFjH9ri5bghxmQkZbE7AtRNl/Q5SBp4ZCVS37b/lfQooXAc5ZFHq3xirjKFATz5VpBQVYSS7Z7r62utZpJbMRwHbyG8NVfgjlk5dwE7u2pyi8Zi1iUp8ZYlGqya6+ZgS7py49D5ET2Lh+BcaeYyjdJwv+PxVm3EPAxCsBmswqTmYJxOiUsVsL6UEmvwAezM98Sul3Blc1FBXgnMlQwZ13SUhSVEqohM57iqi/mCElwkwviR7kbw/VxugBml0A6LeFxI+Fvp0rmv76J38sWnIltQnrD17h92mxDDK0T++o0xoPKlVJ4zI7vtbCKvTzaB+mzkZANZp
 1buBtEXs
 tOcdM6IdAFnD3Dv7zI01MfQEMFAk3awrkHtP7GCK4q9iXvuloOY2wA/O/72EgM6+CieAOAXN3rP4FB6NSPNgePmhwfRPpXoWVDftUcC5XjJcoYlzNDh7ri29gzVaz5cKjhFCmRFoXZDulIx8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 28, 2025 at 11:39:52AM -0700, Mina Almasry wrote:
> On Mon, Jul 28, 2025 at 11:35 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
> >
> > On 7/28/25 06:27, Byungchul Park wrote:
> > > Changes from v1:
> > >       1. Rebase on linux-next.
> >
> > net-next is closed, looks like until August 11.
> >
> > >       2. Initialize net_iov->pp = NULL when allocating net_iov in
> > >          net_devmem_bind_dmabuf() and io_zcrx_create_area().
> > >       3. Use ->pp for net_iov to identify if it's pp rather than
> > >          always consider net_iov as pp.
> > >       4. Add Suggested-by: David Hildenbrand <david@redhat.com>.
> >
> > Oops, looks you killed my suggested-by tag now. Since it's still
> > pretty much my diff spliced with David's suggestions, maybe
> > Co-developed-by sounds more appropriate. Even more so goes for
> > the second patch getting rid of __netmem_clear_lsb().
> >
> > Looks fine, just one comment below.
> >
> > ...> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> > > index 100b75ab1e64..34634552cf74 100644
> > > --- a/io_uring/zcrx.c
> > > +++ b/io_uring/zcrx.c
> > > @@ -444,6 +444,7 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
> > >               area->freelist[i] = i;
> > >               atomic_set(&area->user_refs[i], 0);
> > >               niov->type = NET_IOV_IOURING;
> > > +             niov->pp = NULL;
> >
> > It's zero initialised, you don't need it.
> >
> 
> This may be my bad since I said we should check if it's 0 initialized.

I thought you wanted to explicitly initialize it in the user sides, but
seems not.  Okay, I won't include the explicit initialization from the
next.

	Byungchul

> It looks like on the devmem side as well we kvmalloc_array the niovs,
> and if I'm checking through the helpers right, kvmalloc_array does
> 0-initialize indeed.
> 
> --
> Thanks,
> Mina

