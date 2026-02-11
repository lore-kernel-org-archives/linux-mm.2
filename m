Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76800ECD6D3
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 18:00:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 828026B0005; Wed, 11 Feb 2026 13:00:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D5766B0089; Wed, 11 Feb 2026 13:00:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B6F56B008A; Wed, 11 Feb 2026 13:00:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5776B6B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 13:00:53 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CAC648BC66
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 18:00:52 +0000 (UTC)
X-FDA: 84432941544.11.019BCE7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6B85B100020
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 18:00:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KPAUTwBY;
	spf=pass (imf05.hostedemail.com: domain of boqun@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770832850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3nQuj1RMBLAXoYOm0MfNj+Gfb76N0RCn5RYJP4HF5tg=;
	b=2CmlATiCIVQ3F9IJ+4AyVSU6Q98VHwbNQxnpPeK0pjEPnIxGiWLCMJM0dkxLnvzB905MQN
	8568YE6GQQhiJs8zjaoYPq6Rdx1/x4wFQ4lgCCDi9GooimW/F6GW6EJLv0cRLYy9NMNvnW
	s2RMV+WZ/Dab9zsI3x6aOdRx1SlGXlc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KPAUTwBY;
	spf=pass (imf05.hostedemail.com: domain of boqun@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770832850; a=rsa-sha256;
	cv=none;
	b=v0WP04AeFxdy1wDNy0N8/cFZUteh4KvG+ZAhsTibaEHLMDOpNzKHVXIXdxEUj3xXfI6HEM
	kJTKs+wTw34sBEl+a4shELWqQdEkHWx3uqtIlw9iKFo3BNnk/OoI+KL3F/o/JSSNVKDj9U
	bjOROdzJdKDi1TL75xDd3RWjOeYpn5Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5154440424;
	Wed, 11 Feb 2026 18:00:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 867F8C4AF09;
	Wed, 11 Feb 2026 18:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770832849;
	bh=1WYEHNgPZqycDcwjtC18SrIZuGrOjuIzLtIfXRu9r30=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=KPAUTwBY+LRo8QEOuMnHrXUKJbZ2NsPdIU7/G1CrIQ/egUNs96yqXfcWFwdYF8WLF
	 w+Ps1VdkByMXpvcDUDuOVenKFv1Q6h0ShJw098vtB+s9Nm0QtyiegPNWcDSbvPXG4d
	 j9+Y3uXFlTODBRLQjh4l1rz6iLlkYw5rcxC1Eyxo8ObIITKsY2sPq2YEIU2CtCd95q
	 yU/JacOSka7WykG0XfiUNTd9N6Xtt3p2pBJTeC/CSDy7wG+Aa1wvXOSZIwmiZKDaOV
	 xUOpgPyJsYi4iMxGYgzoRTDheoLxLNGQXw784aV4bbYoQkHqXbCWTXE/njkJSAPenj
	 j2WYMGW+eM22A==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id 7F820F40068;
	Wed, 11 Feb 2026 13:00:47 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Wed, 11 Feb 2026 13:00:47 -0500
X-ME-Sender: <xms:z8OMaeEHvfGtkevvG62gipz25cRNOxLrRDRJ5FdxKA---xFTfiO25A>
    <xme:z8OMaaWR2JVzgHzy-U_-xtJDBgKIxjQjRcBZzyNV4Rvic9lS8XBM9UHdyiCx-F8kt
    qhGb9AGl7Ca3LRCIcUUaWoASh9nivERKuh8pA3Cxsr9WHQzD7Pc>
X-ME-Received: <xmr:z8OMaeyT9IgoILcAGl59JcrDIT2NnX5oKtePeQZyXYq1AYiJO9a7kNw2kLPZfqzSaVufNvGHRAXxBCSJQcoC9dsUWw7vPNHa>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvtdefvdduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvffukfhfgggtugfgjgesthekredttddtjeenucfhrhhomhepuehoqhhunhcu
    hfgvnhhguceosghoqhhunheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrhhnpe
    ffveffuedvleeutdeijeelkeelgfekffeuiedvgeetjeffieduffefgeekheetteenucff
    ohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepsghoqhhunhdomhgvshhmthhprghuthhhphgvrhhsohhn
    rghlihhthidqudeijedtleekgeejuddqudejjeekheehhedvqdgsohhquhhnpeepkhgvrh
    hnvghlrdhorhhgsehfihigmhgvrdhnrghmvgdpnhgspghrtghpthhtohepvdehpdhmohgu
    vgepshhmthhpohhuthdprhgtphhtthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlh
    gvrdgtohhmpdhrtghpthhtoheprghlihgtvghrhihhlhesghhoohhglhgvrdgtohhmpdhr
    tghpthhtohepthgrmhhirhgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopegrrdhhih
    hnuggsohhrgheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepthgrmhhirhgusehgmhgr
    ihhlrdgtohhmpdhrtghpthhtohepohhjvggurgeskhgvrhhnvghlrdhorhhgpdhrtghpth
    htoheprghlvgigrdhgrgihnhhorhesghhmrghilhdrtghomhdprhgtphhtthhopegsohhq
    uhhnrdhfvghnghesghhmrghilhdrtghomhdprhgtphhtthhopehgrghrhiesghgrrhihgh
    huohdrnhgvth
X-ME-Proxy: <xmx:z8OMaVsV4hFcGV8P1iyxjGP3LQcu-Au0BOOHhehloEUXgkMMpaECWA>
    <xmx:z8OMafD_R6aJ7hgwBW0BQU5G-R9ycyk7bS_Qyy-97hAsyZTAo_Qitg>
    <xmx:z8OMaRrIe-bwTiNp3Se4HFWM0KbRieu9m5hJ7y6_o1TP-9oVueKkTg>
    <xmx:z8OMaWbbvYRtEwby_KNKxi6cawCeIhG6xvm_6EybhRWVYtdxfz8xjw>
    <xmx:z8OMabGpWGEpN_v9gqS2iRczbLwHAMUKYar2DLGcZFjNruFIxS164nrF>
Feedback-ID: i8dbe485b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 11 Feb 2026 13:00:46 -0500 (EST)
Date: Wed, 11 Feb 2026 10:00:45 -0800
From: Boqun Feng <boqun@kernel.org>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Tamir Duberstein <tamird@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Daniel Gomez <da.gomez@kernel.org>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 05/12] rust: xarray: use `xas_load` instead of
 `xa_load` in `Guard::load`
Message-ID: <aYzDzeh1cTN2TEVz@tardis.local>
References: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
 <20260209-xarray-entry-send-v3-5-f777c65b8ae2@kernel.org>
 <zqo3qcdqlrxnqxl63kqeuvdacpbbywdrcir2kfwh7j6zvbfuq5@wspy4e75axfz>
 <CAJ-ks9njGhT85pgUSahki989Y9vn3XOBNO5wxB8wE+KvbL00wA@mail.gmail.com>
 <6sd4numrxigibwynr2lfmtdj5uabggrx2l57igtjbnq4uwddrm@wipmwcmqbkjn>
 <CAJ-ks9knC3pKpiMaG6f3C1Kr6su9p26hM7YvVMzsVwYVHGtm2Q@mail.gmail.com>
 <CAH5fLghKwNEdVeRi3H3LQ9NTPYprpAeY41-jgfq8YEST9PaGdw@mail.gmail.com>
 <hq46fcdy6zvwcwlbtbjynqadiwy3wjs7raxioime2et5amzez6@wvzzlkiijwvf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <hq46fcdy6zvwcwlbtbjynqadiwy3wjs7raxioime2et5amzez6@wvzzlkiijwvf>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6B85B100020
X-Stat-Signature: memxjfhg7uxmba41fd1cggbkm1nws33q
X-Rspam-User: 
X-HE-Tag: 1770832850-360778
X-HE-Meta: U2FsdGVkX19NuKA+fMIMGcAiEXxNCmvTAkvbgpick1AC6P4ryjCU3MfPhrbL1QXB3jLyAISDpVI2Lpj/YziluuL76KJs9GNkehoYyFaHh+hlDgAyU8oXLgdiZC/u3SfaSvd0MJtO/BYi5ZHmE6qOgUZbZVAxg5JI4gfS89YQ05JanXu+84EioaGBadMm0T9JIz21GfhRNtKggt2RTilvyDPKwLsGWTsJ4PMwESHtowa55m3c70gfYPpwZGpsEVqKrBoW/EFYTWr1oZaPMAW1vonFzoxJKuHzNOaIt+f/RH/X2UaEgJRqf+GGlR6AwZdViJHTAVJdc97zU4h3Q1jXB/w89eCnEJTJ0kayn98uL3enp95OgJ+L6y5264ceSLJSOuAm1TK9bThlDCsIQ5HVtIdFL3DExX2C2Wi0fgt4wuaR6qmhinwttlIoDBpaTSDipKwKiUxrFuWl1lwvjAlfIhAySwdybs+CZXK2+dSFbdLJuxztYzUoFM7ZDnaM92c2MSGbDzCQDt1h/xX+h3WAe/WTgd9B+gDY8GOG4MrrQIVGnwDUIqCsd5SFH96tsJdA7wo9GkvSBzcDXOP3W56XZba4h7yMVpLz5++PQbjoydGJkwEesRm6weWWoEVUOLBf3HBQWnT/DDU9IQ+n6uLnoT3xjCprmMaQhZiEckWgJRLLRlGbcgaY38rFD9uF+EtTioDq8hFj6gDc6z+6MlTdGJCwiCBJulc1nccz6seiGNur74Bj7C2LPlxjzmwzlgl4pLn44ShW3BXfjXQZoEHeNr4xnMXHI3/peCXHZIuH8FjVTzcPwMcP3eux9n0fi5xyj8lTYOptifkaQeR0suD8nkZ+KKRhU7ACAyz17tOKcQ+HTVtfyraLtiqohzF+nD/QIjlvKl5psY+n29yUABK5WBE4C0+/n7vw8rTLL/oADeHzmX/h2ZAIk3Bq215tW7WmTsO7iYadqScT4n3b+KR
 kLFbCZ3R
 hUOWcbT846jvrq3OmNzo+BbFQBUH6hOq+cDNBiCL+OTmFUPRC9rxDOpvl8i8iDFCQL8ON3UMG5y81t5+5pDtadcGTsHB5CJMkPaRq/0uLmzyfe/TdxQACk817optvQr8mYa1l4hRpuixECmQf94XzYMDL6arUnuS24S5lGIONgThjdB5NoSfNNbJ7MmI14imSeJ59K0nRYhs8ZaVkyuCyvx09R7QSRvL1BSgQzxsF6mIQFoEp39ZUccNC+BwbfpF6KDNL9vs3HuW92FbR3HuwP87kLu9k4SK7EZ4p46chdkiCQaT5VN8Fy32nMvaN2K/+j3HGUhVzxk5ohCo97/K73pwN8ERyOQJcnM4zjsJSYYxyBlHrlnNcFDgRz54rf8+fbX7dJI0+LH1rCqc1VTCLFcnWp5WUpYC7Swu4+HqCv2vNPtftCO08eZKLUFXeEnidfrgqLIMSU/DSVOs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 09:32:36AM -0500, Liam R. Howlett wrote:
> * Alice Ryhl <aliceryhl@google.com> [260210 16:34]:
> > On Tue, Feb 10, 2026 at 10:23 PM Tamir Duberstein <tamird@kernel.org> wrote:
> > >
> > > On Tue, Feb 10, 2026 at 12:59 PM Liam R. Howlett
> > > <Liam.Howlett@oracle.com> wrote:
> > > > Is this a temporary limitation?
> > >
> > > Maybe? I don't think RfL has good abstractions for RCU yet. For
> > > example, exposing load directly on the xarray using xa_load would
> > > require a way to guarantee that the returned pointer's target isn't

Well, if we only return a pointer, we don't need to guarantee that,
right? Because it's up to the user to provide that guarantee. So we
could have XArray::load() (not Guard::load()) that just calls xa_load().
Also see below.

> > > being concurrently mutated (e.g. under the xarray lock). I'm not aware
> > > of anyone asking for this, though.
> > 
> > It's relatively easy to add an rcu-backed load using the RCU
> > abstractions we have today. I already shared an RFC containing such a
> > method for the maple tree, and it would not be much different for
> > xarray.
> > https://lore.kernel.org/all/20260116-rcu-box-v1-0-38ebfbcd53f0@google.com/

I need to point out a difference between xas_load() and Alice's usage
(also what Tamir mentioned above) there, what Alice needs (at least from
her patchset) is the existence of the object is protected by RCU, i.e.
if there is someone else dropping the object, a RCU read lock would
still guarantee the access to the object is valid.

However, the internal RCU usage of both xarray and maple tree is to
protect the *internal* data structure if I'm not missing anything, i.e.
an writer may change the array or the tree while a reader is reading,
the internal structure itself is still consistent and valid. But the
nothing guarantees the object you read is still valid. For example, you
can have an xa_erase() racing with an xa_load():

	<writer>			<reader>
	ptr = xa_erase(xa, idx);
					ptr = xa_load(xa, idx);
	reclaim(ptr);
					use(ptr); // <- object may be gone

the users of xarray needs to use other mechanism to guarantee the
existence of the object.

In Alice's case, she in fact used an RCU read side critical section with
a larger scope to protect the object as well, which is definitely nice
to have, but not only way of using maple/xarray.

> > 
> 
> It would probably be worth having two loads then, one that does
> rcu_read_lock()/unlock() and one for writer/advanced users like we have
> on the C side of things.
> 

Agreed. But we may need more ;-)

Here IIUC that Andreas does is adding a `load()` for `Guard` of
`XArray`, which is the load for a writer and most certainly you won't
need to take an RCU read lock for that. The load of a reader can be
added as I suggested above (similar as your "rcu_read_lock()/unlock()"
suggestion above), but no object existence guarantee. We likely
need a third API that can provide the object existence similar to what
Alice had in maple tree.

> Or at least name the load() function to indicate which is implemented
> today?
> 

It's a namespace thing ;-) , the function in this patch is
kernel::xarray::Guard::load(), and as I suggest here
kernel::xarray::XArray::load() should be the same as xa_load().

Regards,
Boqun

> At least on the maple tree side, we have both interfaces and users for
> both.  I just found the change to remove the rcu safety odd because I
> assumed both are needed.
> 
> Thanks,
> Liam

