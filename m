Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD7B2CA5FC4
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 01:32:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D8BC6B0088; Wed, 30 Sep 2026 21:32:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 261C16B008A; Wed, 30 Sep 2026 21:32:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 103D16B008C; Wed, 30 Sep 2026 21:32:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CF7396B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 21:32:18 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4A02A140291
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 01:32:18 +0000 (UTC)
X-FDA: 85272331956.07.882BE55
Received: from flow-a1-smtp.messagingengine.com (flow-a1-smtp.messagingengine.com [103.168.172.136])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4A48620006
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 01:32:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=dU+0WpT9;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="n ykSWi/";
	spf=pass (imf13.hostedemail.com: domain of neilb@ownmail.net designates 103.168.172.136 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790818336;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v6sl/0R+rB68lGY0FGguwPrnWxhGA/6NlVevSXWfXMc=;
	b=NXu43eFAMFXKCKyoUYkJ15LqWdkEXkXKA/BzuwIHncDyUJ4lA5YpSTrmIwvQqB+cMZctdJ
	fk6xrz1dFnhQA/UfEqqjgAcPffSZefU6uQEP46XLLQHT7ZKkVNgwJ7bkScyu4a17YAvz7g
	OH8/1N0PTbuY0Cb4u770gZDzbVf5K8M=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=dU+0WpT9;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="n ykSWi/";
	spf=pass (imf13.hostedemail.com: domain of neilb@ownmail.net designates 103.168.172.136 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790818336;
	b=jswPF00cQgCo09aVApanIzZqNyOR2koqb8+3WDedDoIuIMx6zoexJyBxnxJQlxuWxvQn4V
	yTg3T1Mx8yEy/F9aERaE5LxGqucRCjqRO3mqm6Hmfds+7OLuuMv6+WxQqazJxq04l9vB6m
	TgRCJBm7wJ6m+8glXSl+vKiaMvkV+28=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.phl.internal (Postfix) with ESMTP id B6867138013B;
	Wed, 30 Sep 2026 21:32:15 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Wed, 30 Sep 2026 21:32:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm1; t=
	1790818335; x=1790825535; bh=v6sl/0R+rB68lGY0FGguwPrnWxhGA/6NlVe
	vSXWfXMc=; b=dU+0WpT9ayrHlXGiw2fE7NtD4nUKlPkDDP3/RGUUox8ZXvJoUQo
	oINwTLuzSo0Zg9v+dfBIplaHyARav2Mu8lCTqCAOo96G8RZvfBJi0GOymeRhi/dI
	f7XplgGDzIDMI1NiNvfl0Zh7g8pAGXhSyOM2ZuxW5gpn9bMfnBKntlbG0GmOil2a
	B91sBRg0ZDavly5kGWDikF89yurM2VpKV4qhOtg+jwnmZhRe5eEarAe582USAxvq
	3TpRvW/dssTdCeqkSWOs6STZvipHkq3bwiSYuWKRV8gjPh+rQa+uxuUeDyyZW7OI
	yaHU7NrMF786oNViHGBZb+A/zmB/ZU28Rkg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1790818335; x=
	1790825535; bh=v6sl/0R+rB68lGY0FGguwPrnWxhGA/6NlVevSXWfXMc=; b=n
	ykSWi/sGd5gvCHPUtRxJkK9qcoysaAZwvGnmOCwOtaQRRj1psP/USs+V1s3CCE8U
	bGXX2E4xnMQU2eypDh/nQ4BVxOh/jB80ebnekbDY1oAa3240VyEwbSN+2nHiBQg7
	kQTEDfjMQuCTtO/5lEEZqtGJvdfezRH80tHfoLaAYyvbV1vxa0wXlsMv0CSzAF1W
	IzJYOjwhvjlayK2Cce3kxXooukECSCZ8CEO+QC2UTlLIWfL00oyTSCyqiKtquJWR
	WNVkaXGTVvKYZyu/rAoJrUdPgNYilg28OA2T/F7ZfmMU+EBPOcfIPiXJIyMb+g3q
	Wd07JiigVXT8DStdGxSBA==
X-ME-Sender: <xms:Hbi9amRCw_kioWSBEhgnA4y0lG82UU2w07EeZKMs03XSK3bOCXF6nA>
    <xme:Hbi9aus6-sF1IYxOKWGWnSJ7esBELFJJ4RjqP7pbXWzuyw9SfNidEdevmUe2qrpPT
    6dBXtg9wpG_1KbOWHqWu7HcbCJn4x4SjDV-rfvmQFhNcSZy2pY>
X-ME-Received: <xmr:Hbi9asCM5t-3GQu68lUW4pPb12EVK7ZfxE5JiCn0jxXqtLlyltpHLJofGBy1_PCWUyE0cOmDB2n7mv8cveU-5a6ZpaCEunk>
X-ME-Proxy-Cause: dmFkZTG3KGb7tHgt4XbEdgaBbvRJJoXDWpMAFSGKnPa+FGRadeoOBQt63/9dFXh0uDdMHQ
    4iJ2cIgUNrLNuACkoRhTc5qxpMylSF3jV7QyvProt74YjF+kiQqUTZdmWNsWacBqmWB84K
    veH6OTbRcmsBVg1Wf2i8FMyZzc1eVaa+pkZCjnSlhdl4PlH1TysaXJbsGByCtBTH+n50BB
    bcLzTEbkv5u2szZE2cmghDoJokPu68Cm+X2VRhSm6wIj0B+fmNAmOyZWU4zuUgOTHOSYnY
    8OFG6vhsXQdCgKC6M6ZLdbcYz18tGTjcRhbAFMqiExh5vytioSAFh0IWdadZHBY/Q+YJsA
    ln/MlFLYMsinjIw+1kmsqp3DVjRD4Hn+KNat7h1gnG7JekPoGkqrnYyrqPZvn6fiBKUpEn
    0MDVBje7PRDGze3i9HFtvY9bUZlsY71046ZeN38zQq5h9E7XluoSZIuDT7WpQG37GNp+rF
    E1CpBcw0zc0B9qZwbqQWwlUygDW1onMVM0VOnhrcnxwCQ59RFCVQsv7t2U3/QMSCzEuWaX
    d8tEmDr4x0aozLp1DyF/IIcp6jGB2ETbZsjzbcpG3jEdtniaAruC9emGU9rvRatKlLHGfb
    RQr8YBl253XGkX0sH1oOBGWWEx8zXBUrG+J7MHy/si5zIydG76lUiyz2+k1w
X-ME-Proxy: <xmx:Hbi9ag0SmFUKJA6pqZNzQM73oSQuOS6JxCjWZ0qnhOnwy_oETfCYIA>
    <xmx:Hbi9auS6xhgyi0kKzqyjeQGXMDAuEAIZaJqH5HhIKYcDW6E6NgAWjg>
    <xmx:Hbi9avuA45NcxPmR8CruuVNHR7uHKgcEa3khA2ZaZ-H-_VBIq3pJvg>
    <xmx:Hbi9au6JtIyHmLZ0gH6zRoBQAOTZdhLvdp4YIL2YSwaLGMgSKC6big>
    <xmx:H7i9aqETvhFQVYysvlbm8o1zdHJwYsBkfqktEGeP4RoZ9q8OaxtXJYbM>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 30 Sep 2026 21:32:05 -0400 (EDT)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
From: NeilBrown <neilb@ownmail.net>
To: "Al Viro" <viro@zeniv.linux.org.uk>
Cc: "Miklos Szeredi" <miklos@szeredi.hu>,
 "Amir Goldstein" <amir73il@gmail.com>, "Kees Cook" <kees@kernel.org>,
 "Joel Granados" <joel.granados@kernel.org>,
 "Richard Weinberger" <richard@nod.at>,
 "Anton Ivanov" <anton.ivanov@cambridgegreys.com>,
 "Johannes Berg" <johannes@sipsolutions.net>,
 "Breno Leitao" <leitao@debian.org>,
 "Andreas Hindborg" <a.hindborg@kernel.org>,
 "Jan Harkes" <jaharkes@cs.cmu.edu>, "Hugh Dickins" <hughd@google.com>,
 "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 "Namjae Jeon" <linkinjeon@kernel.org>, "Hyunchul Lee" <hyc.lee@gmail.com>,
 "Carlos Maiolino" <cem@kernel.org>, "Christian Brauner" <brauner@kernel.org>,
 "Jeff Layton" <jlayton@kernel.org>, "Jan Kara" <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
 linux-um@lists.infradead.org, codalist@coda.cs.cmu.edu, coda@cs.cmu.edu,
 linux-mm@kvack.org, ntfs@lists.linux.dev, linux-xfs@vger.kernel.org
Subject:
 Re: [PATCH 4/7] configfs: remove d_add() calls before configfs_attach_group()
In-reply-to: <20260929050739.GB3909609@ZenIV>
References: <20260929034158.1455429-1-neilb@ownmail.net>
  <20260929034158.1455429-5-neilb@ownmail.net>
  <20260929050739.GB3909609@ZenIV>
Date: Thu, 01 Oct 2026 11:32:02 +1000
Message-id: <179081832202.37859.12981680448323688912@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4A48620006
X-Rspam-User: 
X-Stat-Signature: qhhjtd8ht4da9wisk9jn5dg1m9851o7b
X-HE-Tag: 1790818336-758261
X-HE-Meta: U2FsdGVkX18a/gJbcVLW5VSIzvOycrraFGOPGTmJckCYHCfPQk7v2GwmCJH456Y/tWG8Zd8gnnUoyPwS3uQ0mV3FH6laxaSUJrvJgroZgY4lju70UWAMTpA0FjPWprjj2aAOcGLeCuu4o5ZdZ0n7oI3Kv8T4jFPCIB2aucNqqsZWN2Pa3tsNy8Enu0iYfOf8hFoz5XIBop7SB1U5QYZiZrCf0GKrmKWmH/EVTANyVcBD3DNYo3LMr8tHWemyQapvK4ek1aTA4Z2Pi6mSczr9dk9PF0AXI5Ox1PVmP33uFQFM+CM9qkM/Q1aJGXm4mxejJalhT+a14PKrNUkY0xVc7Xinbfnx9a/6vhMKVhXHmk+Qr4eHrAKpd4Tb3KBu6nxToQ2z3m2X4k+7L3P/wTkrV9vwV/62dkmanUi6jpO1KCNcciRitOIhOAB7O8ORPLZUNqYX6ETqMrP5PnwGHG8Ttu7ifk6xZh6Z1F1CyA4bVJ07soWoLH2uUFUNrHky37DoKs7gqWdFVGp7U8X131/N+1lcMdqWH+bstBiad0KNPc4WdWssdbQviCDklnXsciqh/RAWdldiOB+0kqpDDdyHU8YUfx4nlV2vbnhYXAmMvQsMezl6fBLMcwb0xMPZ+RrF3K1gNS72OTn4DNB0l00kyf0Lzv8kqGyxaVhL+w6SYW5uh6j0bt1X9ofeOHPZbO4cB9EHIuo/l4KiB95lcEGGR8wzr3pQ9e2lmvz8lrjpD0gHvjABAP9y+QzJvdLR4Qe6x80szzUh2Qp5+kc40dwLpAKqG+zQ9+QCoFBF+Ei7z0VWsCBnqp5PD2rRBM/jvEIVpaa1aSVOfN2ZnBo33CYdmSweR9enNNNf9TNUEKiWQMj/lGT8pkMrwswkCUjwXvZz1VzMwD2VIhGmOD3s+5zx0SPHh67bCZbdCLebaWgEOaVBxA/p4w+wobZ+n7ievKlIxD28AL6sicQLp37XTHB
 hdURPB+C
 CyunM/cr7IMCFnk+Zfm6z0Bk7iEpXt3qxuKQ/LafIkLnO4eoE1ieeruQskscfTw6DCHRNFNJTKvha42SYJtl3ofqBGWHhXx41Fj77GfpJ4+9bkoXvXm7XLfAwD453T13QGVyWJ2EeAt0WNYd7jaUFHUEZ+6Z26TuUGhWkL5iQV+1ZO0y/1jL9wX0UC4iHYSAQ3iHd+yQClMN0Z7AGGAKPIPuXFREtLffCKzY/BeUz35yTPR/dLKbNBiM6E79sbnG20YfKyam3tT0WnTn/Q1b1G7AjhKbMd5x/qLR7naMuVAgb59awLDrR0yva9sQMA4qx5m53asfsIDXs6DOBrX+6mkLENL7edD1wPDbQbHk6wKnuVnEuPnwMsW0O1t/3yorjRdussppmovWaVZFGvjc3QMvlY/w6fzLDesehb2pYu2u4MVj3TolTDGUq6VJLYapXg4czDiXGAh2w4mBoe8YPwk/fPYL1wfSfZqRkKsoMrrJ5xFrGvMmWeQ1ZWXJreoQuGgMi+0iutG7GJ0ZD4Hc5PSV5esEQdbMqept2PffG/AGLwmH1ycHXR4h2BY0aS1ujBXghL3PH93RL0KZGYowaIWRjMRDxUXqsj2DGXJYof/0PW/6q+XXxzysuQlB8lRXGTmQI4nuDBk25fNPW7P9YotGPklmVZmDzTF1Ef+UxKQQudFgwg9rijl++jpJ82n1VwOlC72fmrlvSHmQprnMHwP/SLfjZDYWbYJwotwZRNtdWNR+gbUur4Z7c1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 29 Sep 2026, Al Viro wrote:
> On Tue, Sep 29, 2026 at 01:36:04PM +1000, NeilBrown wrote:
> > From: NeilBrown <neil@brown.name>
> > 
> > These d_add() calls cannot be necessary.  The inode given is NULL so all
> > they do is attach the dentry to the hash table.
> > 
> > If configfs_attach_group() fails, then d_drop() is called so the dentry
> > will be detached.
> > If configfs_attach_group() succeeds, then
> >  configfs_attach_group -> configfs_attach_item ->configfs_create_dir
> > must have succeeded, so d_instantiate() will have been called and the
> > dentry hashed there.
> 
> Neither in mainline, nor in -next...

I guess you are refering to d_instantiate() not being called here in
mainline or -next, because it has been replaced with
d_make_persistent()??  Sorry - old commit message.

> 
> d_add() _is_ wrong there, but this is not the right solution.  What
> we really ought to do is build the subtree first, then either dissolve
> it (without any pathname resolution having ever seen it) or move it
> in place once we are sure that everything worked.
> 

I'll just drop this patch for now.  I only want it as part of
deprecating d_add(), and that can wait.

Thanks,
NeilBrown

