Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2F49C83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 01:19:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EA0D6B007B; Mon, 28 Jul 2025 21:19:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69B7A6B0088; Mon, 28 Jul 2025 21:19:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B0386B0089; Mon, 28 Jul 2025 21:19:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4EEE76B007B
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 21:19:51 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E9ED316048D
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 01:19:50 +0000 (UTC)
X-FDA: 83715545340.05.CE45858
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf01.hostedemail.com (Postfix) with ESMTP id 457A240006
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 01:19:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	spf=pass (imf01.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753751989; a=rsa-sha256;
	cv=none;
	b=EYOszbVQ+tnlVTlX0lVC+N+nujGB8QHsKXHD+RWkX0Gse9mobIuGshZWlGwHSDayjWBTse
	74pKbCKeXXl1tWbNTHKE4aOlr9msT5xyC4tblgczC82hltK1vIn/23dbpfxjn2SiBQj/vI
	5aYw3xmIMMMGkGidvD10F6VnQR97KTM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753751989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fEepzYMzG5pRwws2o6NcVSxqCuKtnS0JwxpVap3v3gg=;
	b=NhNHAuMkt029mo3VvZG2V5IWIw1EYGRTyR1mcm3KdiQDglS1FcaIhgMroBJzXXSXANPEUD
	1JIQlrz4ZfZTfHhBITVYyuZleLSxBOa9B7xRTh5dYUK/mDjYR0G7zWaE04AVZ5rtqkawM5
	v9wCCuo7VXnVQR44Pq+Q/vQvk9vTC7Y=
X-AuditID: a67dfc5b-669ff7000002311f-64-688821b27ee0
Date: Tue, 29 Jul 2025 10:19:41 +0900
From: Byungchul Park <byungchul@sk.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-mm@kvack.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
	harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
	davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
	john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com,
	leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
	andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
	akpm@linux-foundation.org, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	horms@kernel.org, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, ilias.apalodimas@linaro.org, willy@infradead.org,
	brauner@kernel.org, kas@kernel.org, yuzhao@google.com,
	usamaarif642@gmail.com, baolin.wang@linux.alibaba.com,
	almasrymina@google.com, toke@redhat.com, bpf@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH v2] mm, page_pool: introduce a new page type for page
 pool in page type
Message-ID: <20250729011941.GA74655@system.software.com>
References: <20250728052742.81294-1-byungchul@sk.com>
 <fc1ed731-33f8-4754-949f-2c7e3ed76c7b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc1ed731-33f8-4754-949f-2c7e3ed76c7b@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0yTZxTH87zPe6Np42tB94jRZFW2pMvEC4lH3YVEPzzReItLpjM6mvGG
	txGQFKygMSmODSXAiHdLmxQXBCpZWYtQtHSjYBEvUdiY3URANolXQHANFQNSL9Fvv/zOOf9z
	PhwRa89z8aIxM0c2ZRrSdbyKVT1RV3zq/vCQsrhzJBFsrloezo3nQlW/lwObswHBs8htAaaa
	gwjG2tp5eNQ6iuDnijAG240CFv53PcdwLzggwDn3eug7O8iCr7ARw8BPl3koKZjA0BwZEuCg
	t5oBm8ciwM2GUg6OPa/E0GjpF+CPCzYeemunOBgMlLDQYa1hYeR4G4a+0mQIOmZD+OpjBG2u
	RgbCxXYeuk9fYOBol4OHfwv6EHS1DrBw/MUhHsrzSxFMjE+nDZU946D8Uq+QrKetj4cxra/5
	m6Eh/xWGNlnvCNTh3kM91XpaFOrC1O08zFP36BGB9vzl4+nlUxMsbbq7gjZ5xxha8v0QT5/e
	+4elw/5uflPsN6rPUuV0o1k2JX6RolJslR6cFVTnDnd2IwvyxRShGJFISeR+ezPzluudbi7K
	rJRATp7oEqLMSx+TUCiCoxwnfUIe3QpMe5WIpRMCKXT5+CIkirHSDlL326poj0YCUtoUYaOs
	lRRSfaMMvfYzScfp/155LOlJaPIBEx3F0lxSNSlGdYz0Obl+seLVqlnSAvJ7Q/ub03pE4rl/
	4DXPIS3VIbYMSdb3Uq3vpVrfpToQdiKtMdOcYTCmJy1S8jKNuYu+253hRtPPdPbAi+1eNHpz
	SwBJItKpNcrhQkXLGczZeRkBRESsi9NkVf6oaDWphrx9smn3t6Y96XJ2AM0VWd0HmqXhvala
	Kc2QI++S5SzZ9LbKiDHxFvQRZ1aSuDX18WMJHcsrZtpTHC3L988fLLTlq/M2Fi/WTs7bYKw7
	Y9kaCmlHOsD18GKny+ANqlbr/U89a2ntwy295lmTaQdrMtTJPfZ+d4J6ddV4+eZbfn9xy0bf
	vnUzrv3wi92+curPu+GFc37d+dWIM3/V1/O21UaWNa6Z0fdlS46OzVYMS/TYlG14CeEPn9JI
	AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUyMcRzA93t+z1s3Z49zeCYW18xWXof5Wpi8PmzMX4wRR888x/XirlI2
	HJXSKomi69rOKNVl2dWqI7G7nELikg4Roc20Xk/Ti9Jlxn+ffX7fz/f3z5fFimvUTFYTHiXq
	wtVaFS0jZTuC4hda5yZLSxxmJZhKS2iw/IyFWx+rKDAVVyDwDL5jYOy+E0F/7WMavjv6ENy4
	PoDB1JhAwo/SIQxfne0MWKzboa2gg4TqpEoM7RfraEhLGMZwf7CLgXNVhQSYygwMOPLqKXhR
	kU7BlaF8DJWGjww03TXR8KFkjIIOexoJ9cYiEnqyajG0pa8Dp3k6DDztRFBbWknAQGoeDc05
	dwm47DLT8DmhDYHL0U5C1kgyDbln0xEM/xzf1pXhoSD30QdmXaDg6OzGQnnRG0Jw1zwhBJvx
	PSOYrdFCWWGAkOJ2YcFafIEWrH2ZjND6upoW6q4Nk4Lt0yrBVtVPCGnxXbTQ+/UtKXTXNNM7
	lXtlq0NFrSZG1C1ee1AmmfLLcKRzUmz3y2ZkQNU+KciH5bnlfHmxlfIyyc3jr2a7GC/T3Hze
	7R7EXlZygfz3Fvu4l7GYy2b4pNJqOgWx7FRuP3/nQZB3Rs4Bn24bJL2s4CS+sDED/fFT+Pqc
	LxMecwG8e/Qb4U0x58vfGmW92odbwzfcuz7x1TTOn39Y8ZjIQHLjf7Xxv9r4rzYjXIyUmvCY
	MLVGu2KR/pgUF66JXXQ4IsyKxu+l4NTIpSrkadpiRxyLVJPk0oUkSUGpY/RxYXbEs1illEfm
	n5cU8lB13ElRF3FAF60V9Xbky5KqGfJtu8WDCu6IOko8JoqRou7vK8H6zDSg2wtobR93aM7y
	zf01s1PTxE2GeKdnj9/plzMKfj1JWe9xzgl9kFgX+mLYcvJoozNfyny+UUtdalrbMuJ3oiF7
	V4n/UHavo7Xcz9Ua3bCS/ZW3NcsyOWhZ2PxZpLIo1bw540bj6sToEMuGm7XB056eCXnW39Iz
	q75jX6bfp+NLfsiDX6lIvaReGoB1evVvqtLRXSsDAAA=
X-CFilter-Loop: Reflected
X-Rspamd-Queue-Id: 457A240006
X-Stat-Signature: 46ewo3ic998y5waqebezjro9g7auf7zy
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753751987-876808
X-HE-Meta: U2FsdGVkX18aZSR+hfkkdJ/+8NTaC0wuTbIuUWHSNSFLh7xL4rDFZ372ugabqz7dyLdhPojyGRsqab0rdx3jsO9G38Om5jqucfoBNtACf97EzirXPp2iiYWvrec9Xf+YFRIlG4Goe1t6UcQ82nWzmLabel3woJgxwb6SCLRBKaAC57O5GkRld+og6Bg+PFFI27wCui23hx7syi783wdy45wc9EQTU8VR2Uq0YXWMvazC5mUKY+ACmDfjtGBB6vDJOAONTzVYfkbVoU5VivlIsy6NxoPrmuPzLkfpKpSpBE88RFU7imXVp3iIAoREBGCal9d96u83pdWBEzZla2YYBqTvBlueixMKiGQCRgFmrhR1ukRVY6TyaOrEsWtt2QVkmhN77cfPn5bCQdFjcegISIe9RH4oEd5D5+iSMfjywzuiGS2eyEUjfBp7j1/0RxI6RU5nu3Gx09yKbM8U7TwQEQI9SB5lpgWk/dj9cOlVWgq8jyEzvqzZzwdJZ/VxJ+JO1U5UZ2lQgMFW0oKkvJkY7K6CF3fFvV7Gm83tXjQgLR5tpl4UpZNpR5dzAIydp+ECt0z15SdeN2x5cb968xOf/dNL5A925GB5UqNLVEOo0t1txMOBjEdP+J2kbtwUV6J/1DgbmifRhhAPNSAreppzk2EKphdwid/wvZypM3GQoRiQ5U8uIzJ3KSHjsvp2hEcJPau+G1+YWAWEpys4gZDR6fpTK7+139H13sTrinNT34kKqLCLtt14cYiVNHiWxI3pYNLSO//ReCKz5KGu89fenzKtJBM0D0Fos1Q/BKaj5U0ASXXpLRopQgrOLYrq/EMDjM3X+CmoVIbGflS0+lTYlhqnt1SlArutzfyz1N/l5VUFTakPwnz4dU23pj3wDMP961gAtZydwot2Xra0PchTFvKlCDoh5WkqfZBvLV6yenI5UmwsgMI4C5RN5QRl2T6O2Zie/SVEMV9abujcRZn
 WY3ztjHE
 FGTIeeIcAZAx5VGrKXRHTTM7SEd9JT9fXWSskrlPWw1rn14pHiKYJqPrxtyKNXMgSVTbbdMN5GalgW+b4KSOb+KFscgfza54DdM/e
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 28, 2025 at 07:36:54PM +0100, Pavel Begunkov wrote:
> On 7/28/25 06:27, Byungchul Park wrote:
> > Changes from v1:
> >       1. Rebase on linux-next.
> 
> net-next is closed, looks like until August 11.

Worth noting, this is based on linux-next, not net-next :-)

	Byungchul

> >       2. Initialize net_iov->pp = NULL when allocating net_iov in
> >          net_devmem_bind_dmabuf() and io_zcrx_create_area().
> >       3. Use ->pp for net_iov to identify if it's pp rather than
> >          always consider net_iov as pp.
> >       4. Add Suggested-by: David Hildenbrand <david@redhat.com>.
> 
> Oops, looks you killed my suggested-by tag now. Since it's still
> pretty much my diff spliced with David's suggestions, maybe
> Co-developed-by sounds more appropriate. Even more so goes for
> the second patch getting rid of __netmem_clear_lsb().
> 
> Looks fine, just one comment below.
> 
> ...> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> > index 100b75ab1e64..34634552cf74 100644
> > --- a/io_uring/zcrx.c
> > +++ b/io_uring/zcrx.c
> > @@ -444,6 +444,7 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
> >               area->freelist[i] = i;
> >               atomic_set(&area->user_refs[i], 0);
> >               niov->type = NET_IOV_IOURING;
> > +             niov->pp = NULL;
> 
> It's zero initialised, you don't need it.
> 
> And a friendly reminder, please never send patches modifying a
> subsystem without CC'ing it, especially kept in another tree.
> Sure, you CC'ed me, but it's easy to lose.
> 
> --
> Pavel Begunkov
> 

