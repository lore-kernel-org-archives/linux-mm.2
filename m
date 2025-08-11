Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03E65C87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 10:07:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3953A6B00ED; Mon, 11 Aug 2025 06:07:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36CF76B00EE; Mon, 11 Aug 2025 06:07:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 282B06B00EF; Mon, 11 Aug 2025 06:07:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1805C6B00ED
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 06:07:59 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AB0041405D7
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:07:58 +0000 (UTC)
X-FDA: 83764050636.05.8C316C3
Received: from flow-b4-smtp.messagingengine.com (flow-b4-smtp.messagingengine.com [202.12.124.139])
	by imf02.hostedemail.com (Postfix) with ESMTP id ADE8F80004
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:07:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="U lUAzQz";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=CNCTDk+m;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.139 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754906876; a=rsa-sha256;
	cv=none;
	b=AKzdWr9SCOhikdPNISGHpzs36CizVm6Ld2goOEJo/GrYVwkz9N1MZpEaa8pq1v9suT6jfs
	1Uw2mnTgKR4v1QHdhKbh/fXjZJQkdojTALBPk5n1QmC3WFoJn1wsOkdWOcabjdhbf807O6
	l6esxgBR79BepE+vxg7/h/vc1Sxab9Y=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="U lUAzQz";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=CNCTDk+m;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.139 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754906876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YMVHbKt84ajobxpDslMW7shZLCihMMdqMX7Bu7K6MQc=;
	b=ad/bWSkYrJvZPuJPodwSBEhNMBz8+O2qiEBQ67BlkeTjwabtLMSX4Mo1oKwJ/KAzc2x/2s
	2Gbo/3R/hpUB6NVD0h78Z3SwszYT2RF2HSDbzgsmF38anZOHP5xTVcBV5zf7rV93N+2tM6
	4OdmfBwozOwAuTowiFhICKXhrJ+aL2A=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailflow.stl.internal (Postfix) with ESMTP id 4A95B1300168;
	Mon, 11 Aug 2025 06:07:54 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Mon, 11 Aug 2025 06:07:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1754906874; x=
	1754914074; bh=YMVHbKt84ajobxpDslMW7shZLCihMMdqMX7Bu7K6MQc=; b=U
	lUAzQzLiTBAPDTVtOK64KS4Yag1rkY3R7Ig8f8E9UtChnbtz5HASBIVq2pl9rPIN
	swtt2+1lpWIHjNFtkqlMFLD8L9YSYFzC/Wy0LR1UQeZwJX7Kkjh7ltz00WVyflKp
	IK3L8Qc2HALu/gu45rStzT2u1TnbnKBZ8SBD9j/JqHTaUS5UG5M+rhqQZfPc3DWM
	vkRh7dQGN1NQTF4klOJsYPQFoTbufs8fd194I7lGGFPHxdtCNHVaJbwuD4DPpAgm
	FsWTzXmHUXcDpP0JfenrDpDiG9Duiu2z3alsiC4DS/9RwXlQaI9ivq/vr+ha1Suo
	TS3nkp1Lh0NTjQTdedI0w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1754906874; x=1754914074; bh=YMVHbKt84ajobxpDslMW7shZLCihMMdqMX7
	Bu7K6MQc=; b=CNCTDk+m/R8DW2A5rWRfgIuozvJ/fJg4fquLl5cey7hAs4g/0kL
	F8QlBLVfJRYav7mTNnNf4lHYIi60o9ACQP/q64y2XHedY9VDvILXG+5NNIV3kqWp
	eRPVx/BPAHasEXVsnoFK32WoE68mnIMCTdKk7hxLVRVS7LyS3JUPQMHS3PZckhBq
	TTkROi/cC8fPiaUe4TPK8eyXWzKQ2V0bVndfYFAnd93eBvybb+1fg2YP1WVb14k2
	Liy/M8Fv2d0/rmEmXzzuhsgHaavl/7QljjBY1dZka99D0XejlMZYvgYOuZZPdsmi
	UaVW2NQ93fwai3J65RtLZCDpUENyuEnUXBw==
X-ME-Sender: <xms:98CZaG9aKnMFKfDBk16aqYN5V9ARSsbYFCtJkucvVn8zvHCPCASnBQ>
    <xme:98CZaJrDhNJ5UQOyAV5SaCp6pswEZWT2w1WUvQk-vuDLTSKRYqno6rdYQt6fE_61y
    LaEtQbIpzxMJNEKwzY>
X-ME-Received: <xmr:98CZaCzWWjtIjDEIbmyf2PmDXrzPc4yw5ycncCFoqEazPriq1FiJQypuoia->
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgddufedvudejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepjeehueefuddvgfejkeeivdejvdegjefgfeeiteevfffhtddvtdel
    udfhfeefffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeeh
    iedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepuggrvhhiugesrhgvughhrghtrd
    gtohhmpdhrtghpthhtohepkhgvrhhnvghlsehprghnkhgrjhhrrghghhgrvhdrtghomhdp
    rhgtphhtthhopehsuhhrvghnsgesghhoohhglhgvrdgtohhmpdhrtghpthhtoheprhihrg
    hnrdhrohgsvghrthhssegrrhhmrdgtohhmpdhrtghpthhtohepsggrohhlihhnrdifrghn
    gheslhhinhhugidrrghlihgsrggsrgdrtghomhdprhgtphhtthhopehvsggrsghkrgessh
    hushgvrdgtiidprhgtphhtthhopeiiihihsehnvhhiughirgdrtghomhdprhgtphhtthho
    pehrphhptheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepuggrvhgvrdhhrghnshgvnh
    eslhhinhhugidrihhnthgvlhdrtghomh
X-ME-Proxy: <xmx:98CZaIk1g2pwnQF0ZCmAGsoZLEWfhdiqeMEMRwt6usFGJ0Z10Eq_3A>
    <xmx:98CZaOnLoiGDJjCwNk9y_0rIqxSexo1YPGRQCKaef_P_Z-NeIQf8hw>
    <xmx:98CZaOwcAoRr88sQNj8EsQDLYwPiFrzeoGpcp61tm8q1HdOyhfhrgQ>
    <xmx:98CZaFZ-7tIQCWXSINvVQZEBCDXAn-WG-vqKTLT35EnFrp5WIzvP9Q>
    <xmx:-sCZaCvSYdCPW6f41s1J5E9AZKAdplnP3VG2J6p6QFiaKVLC-CLJYKox>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 11 Aug 2025 06:07:51 -0400 (EDT)
Date: Mon, 11 Aug 2025 11:07:48 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: David Hildenbrand <david@redhat.com>
Cc: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>, 
	Suren Baghdasaryan <surenb@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Mike Rapoport <rppt@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Michal Hocko <mhocko@suse.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Nico Pache <npache@redhat.com>, Dev Jain <dev.jain@arm.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, willy@infradead.org, Ritesh Harjani <ritesh.list@gmail.com>, 
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	"Darrick J . Wong" <djwong@kernel.org>, mcgrof@kernel.org, gost.dev@samsung.com, hch@lst.de, 
	Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH v3 0/5] add persistent huge zero folio support
Message-ID: <rr6kkjxizlpruc46hjnx72jl5625rsw3mcpkc5h4bvtp3wbmjf@g45yhep3ogjo>
References: <20250811084113.647267-1-kernel@pankajraghav.com>
 <hzk7e52sfhfqvo5bh7btthtyyo2tf4rwe24jxtp3fqd62vxo7k@cylwrbxqj47b>
 <dfb01243-7251-444c-8ac6-d76666742aa9@redhat.com>
 <112b4bcd-230a-4482-ae2e-67fa22b3596f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <112b4bcd-230a-4482-ae2e-67fa22b3596f@redhat.com>
X-Stat-Signature: 54hs4tx7zzenr6fec38ymzps8pp3u8jw
X-Rspam-User: 
X-Rspamd-Queue-Id: ADE8F80004
X-Rspamd-Server: rspam02
X-HE-Tag: 1754906876-701014
X-HE-Meta: U2FsdGVkX1+d2mlYZae9k56S+fng6oRPM3wzI+5FI2lnOXyYrg6aJ+TLIwoB2FULIcZrkuJ56D4PXU5VTsyT9Pi14m8ft0AQv0je7Bk1GUkCulaBeLwYByf+BKqlTnDCvpztSv72l1szomDhZDw24KSBfrtBn5+LMazg6CNoFhys+P84KLjJTlo3I7HSvVNO5APvl6LewvYRcJ6OyieSaeu9GGU9VWT8bwEiWIfHIzuy/RASlGVo4a+FkLlvWlAMpIYyA4694D5/cgQqd9ulFnLOKzm1IDZns87HWomCf4TZeXaa4sfF5bv+qc+nKm/ZKHzwgmfJLCN9nQknX+Em4sfeCeIqISnRYgDGGLXCwDs7FUPzK2ueC9YNQLCRhqORtJqyVW5K/zyhFBRxFfBrqeS6owEgFwwW5LBczuN+Yon9LudwH+qNcxlMz7e7vGwNdpC+YXOBOVMkkJR+wYa0GciwimHCzntKLWgJ0/e5B/OlqbivozTw2wwaRuTl1Ud3NjkFdmsz2Zwbvxp0ReRPunuTHHh6cgZi44rcy60oOvdJmN20BagjjAUu6CU5TicGigBpOUyvyxvUxdK2aezBT6pE1UlmSV3YjMTG2zB4Tr70tRgmZ4jDAhgo/XtYSNH1P4wr2GV6knckv2BRrlG8m5OvthlUcTjT3Z43lm0lPXBIswZdJcV5jF1rjXedgF5NhS1Pux4Mb9BexvFbmCoi4oNcS9t9fpZameEawwqbEXDSrl/zztJ/a+kJcAWNjJ9DMNVaY4sMQo0PZAJRT0PZmpg0z3rG2jVQHnzx/gAHJgFUXbo6scferav2QRHOiaxZftK5YZVj+fQAWLBfGWOMOhf4psSgJFt3TS+s+4i2swcJOO9m9AOBeFmvlSDze0uR1bgEB36bn+vuH2Fv+hGBADgjoJZbX1N4qt8yBjSsAG9N1zuhiOFNZXEJJX+gdfn/HL05FkQwg5cKVN9OR+J
 Gdwkgw5X
 /8brAH7uF5jSB9u2R0VfPQ+7dGlyVhJZKfyEsl2anq6HjV7IiXmEtgQvHKxfemVpKm+NWLSpGpMoIhwvglt8yAQckWirProQXuOWThTF43XAdJsoe3ineB0/Cbub5BBmyv1fpEJ4rH48boscFbRZkrCtYAtMLSrz7Iwt2Nkxf/hx9fgdbDzof/sRLzo7pncfsdeOvIZJgCv5QQR0q3r7+A4+ojor4t0FFupTYaZ4M8Q7p1v8F655ERkxltA5Op3ZuiiALgWLZemaOCo+fj9RDJgJHWcilkWNO7q5346xR1+PhgukvL31HHMDcfKy7tkeP9X9/GwF/np/Q6Eifs73WsCj3a491npcaXuxBDJ/sfsdhh3/v6rppvM1FUqGkJxCuVL5BklRaddwT4RBKJjR8BakWB5q50WdP1hKviIAW1MW62PLTm9OS6+DsnNa36Hr1sPYqxcRiNMQby91oawsqnVUq59u+E4B3nXkoSXRSXIIvkxDSiE2Ff1pj8VaAEyGpkWh3rx5VlzLO+8TE/KaCvw5Vre2FlfTfUvTJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025 at 11:52:11AM +0200, David Hildenbrand wrote:
> On 11.08.25 11:49, David Hildenbrand wrote:
> > On 11.08.25 11:43, Kiryl Shutsemau wrote:
> > > On Mon, Aug 11, 2025 at 10:41:08AM +0200, Pankaj Raghav (Samsung) wrote:
> > > > From: Pankaj Raghav <p.raghav@samsung.com>
> > > > 
> > > > Many places in the kernel need to zero out larger chunks, but the
> > > > maximum segment we can zero out at a time by ZERO_PAGE is limited by
> > > > PAGE_SIZE.
> > > > 
> > > > This concern was raised during the review of adding Large Block Size support
> > > > to XFS[2][3].
> > > > 
> > > > This is especially annoying in block devices and filesystems where
> > > > multiple ZERO_PAGEs are attached to the bio in different bvecs. With multipage
> > > > bvec support in block layer, it is much more efficient to send out
> > > > larger zero pages as a part of single bvec.
> > > > 
> > > > Some examples of places in the kernel where this could be useful:
> > > > - blkdev_issue_zero_pages()
> > > > - iomap_dio_zero()
> > > > - vmalloc.c:zero_iter()
> > > > - rxperf_process_call()
> > > > - fscrypt_zeroout_range_inline_crypt()
> > > > - bch2_checksum_update()
> > > > ...
> > > > 
> > > > Usually huge_zero_folio is allocated on demand, and it will be
> > > > deallocated by the shrinker if there are no users of it left. At the moment,
> > > > huge_zero_folio infrastructure refcount is tied to the process lifetime
> > > > that created it. This might not work for bio layer as the completions
> > > > can be async and the process that created the huge_zero_folio might no
> > > > longer be alive. And, one of the main point that came during discussion
> > > > is to have something bigger than zero page as a drop-in replacement.
> > > > 
> > > > Add a config option PERSISTENT_HUGE_ZERO_FOLIO that will always allocate
> > > > the huge_zero_folio, and disable the shrinker so that huge_zero_folio is
> > > > never freed.
> > > > This makes using the huge_zero_folio without having to pass any mm struct and does
> > > > not tie the lifetime of the zero folio to anything, making it a drop-in
> > > > replacement for ZERO_PAGE.
> > > > 
> > > > I have converted blkdev_issue_zero_pages() as an example as a part of
> > > > this series. I also noticed close to 4% performance improvement just by
> > > > replacing ZERO_PAGE with persistent huge_zero_folio.
> > > > 
> > > > I will send patches to individual subsystems using the huge_zero_folio
> > > > once this gets upstreamed.
> > > > 
> > > > Looking forward to some feedback.
> > > 
> > > Why does it need to be compile-time? Maybe whoever needs huge zero page
> > > would just call get_huge_zero_page()/folio() on initialization to get it
> > > pinned?
> > 
> > That's what v2 did, and this way here is cleaner.
> 
> Sorry, RFC v2 I think. It got a bit confusing with series names/versions.

Well, my worry is that 2M can be a high tax for smaller machines.
Compile-time might be cleaner, but it has downsides.

It is also not clear if these users actually need physical HZP or virtual
is enough. Virtual is cheap.

-- 
Kiryl Shutsemau / Kirill A. Shutemov

