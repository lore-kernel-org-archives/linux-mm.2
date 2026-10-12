Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AA7DCA9EC5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 14:09:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27ECC6B0095; Mon, 12 Oct 2026 10:09:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22FBF6B0098; Mon, 12 Oct 2026 10:09:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 146456B0099; Mon, 12 Oct 2026 10:09:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E314F6B0095
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:09:36 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5B5DBA7B4A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:09:36 +0000 (UTC)
X-FDA: 85314157152.04.29602A2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id BED9440005
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:09:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GhSiL6f7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791814174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WWaKYNS38cf3h2PFrUgpkP3ZJlOHalNpgeeuEBtJF3w=;
	b=mURbsC/JuYfV3B+MGC/pSytgBZw0KWTLd/lQn0IsPuFQQaEVFmbhQGFaUQslTFmtoPtcuq
	nu10rbOHZpVREy84hFFzhfd9jfZ/iE8Tfo8+C0lorjHadtoIvF7q967RNBYH5A0uDoZgAO
	0X65KN8+Fi1DITGXDdVJRSHxFl8XbFE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GhSiL6f7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791814174;
	b=mf/OP79MAKsFF9ffy54+Bc0amNhIr9Xwm5yMK5jLVfatPEeFPAz2mJcVlQKLBLaanRmWhS
	rSr5cFN/6DxJs5SgTy6A/bEfeFGIR5qMsedIgKkmqVnzkgFqxwH3LpssOXTFycNpR8sRCg
	MUIW8A739ok+WbpjYgzykZGq8D84TYw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C965943CF4;
	Mon, 12 Oct 2026 14:09:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 684B61F0089B;
	Mon, 12 Oct 2026 14:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791814173;
	bh=WWaKYNS38cf3h2PFrUgpkP3ZJlOHalNpgeeuEBtJF3w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GhSiL6f7O/lxsNHIi3zTK1pAe0yMcZJ5vSaTqQ4A6yHzNoSf42+s/LiKyUyFigv3L
	 YADCClytFTIOxu2FTn/4sR3XQIPpzSWdLy+ixhBq7vLs5EB5I5W30qCU4o2fIzP3cd
	 f8Hy2aXXnc4xXyH3XAkOX1YfRDzd9pFcnPU3bGQuBeqsqmYlRDPc/d1U/8is/5DqwV
	 vEq+EhYwnvl3pUnQTeLNmkvF1W3c2PUgCuanjh70jzRS4/fiDFDT/LdW5D+3naCDxx
	 yLr7Yddkb0tkcg7nMW3OXDnTMwaLpq5Xc1BuGJuwhiFBlAUG6mwmhzo6bVhDuQtN+f
	 w0hWp94pc1ybg==
Date: Mon, 12 Oct 2026 15:09:31 +0100
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Sang-Heon Jeon <ekffu200098@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Hao Li <hao.li@linux.dev>, linux-mm@kvack.org, 
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH v2] mm/slub: clamp slab_min_order to MAX_PAGE_ORDER
Message-ID: <aszp31zqP607YL18@thinkstation>
References: <20261011014841.405327-1-ekffu200098@gmail.com>
 <5895ceec-df6a-4604-a7b9-8138212d786f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5895ceec-df6a-4604-a7b9-8138212d786f@kernel.org>
X-Rspamd-Queue-Id: BED9440005
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: 3n7ncp4faz3tk79875udfb9r8wzj66q3
X-HE-Tag: 1791814174-19366
X-HE-Meta: U2FsdGVkX1/90Jr7bL7BF83eGfzMngS89gHCi0iK5dfq59d8r593vlvj5G2IBvi2m8gN4HgFq4bQRXNnMbAd83pHaNEdqTZJ8vjlRKUkot+iEfHAH957rRnixXrt3xR1W23PsS0zD9R18ZzxedlpvdPnzoGjgff9h75yZt7iPvqBVxmYrErQtE2APvuNf2dXBL/jV1S5itBdS1Is6Iev4keD1WLBta2VRM4Yt52kyjTI4vvO1cQapkCF42Jk5xo1SLJPErKF7sHyHk4diHQSbV9cmY2aER4I0Zs3glqVqxII2JnPTs7Gk0Crpl8SrwP81ASZxETy++WoAjiM0Q/nOefN1YSNRPWVfQeYYYkXFYqvZ+AqyI/drc0kYvbY/u8FMmaITId3pqhVP0lDgMbxYKCBZrjz1dJL5e7o1eW0CtsH+KFb1cYPJ1QVVVnbwO/5W2e/V9Cdq9bc7FXyp8+ZbfHCUTGX0T5YltKpiHc3LtuL8NijI0rUkBpIjvr4SguuhsMZdkRhU1i3krSU/nH/hOe/Q2aah+KWQSdx2rujw61IEavciGGncxPR05LZ+1ErhMykTEjjssIS2pgl6qWd2T0zJQSw67LlemqRubeKjqDMNAig3cJxhoqznhBpOfjuUzsG04ys8VKRfs65Jz+sOXNksmnONNbYW7UzMM2ktkS/zrBCaX78ySTgZpnc+jdF5iBbImK3YCQaDQYW0vhj0jvMTwkYzoUOQzudH+OdfHlQoF/5BZSHwSUMQsQ5vh1yqVoZDEL55RLk//bW9cZGBPz4GR5/vgC1QVx3BanSIbDcCjVvkwO2JyRzm71gmIqU7AND83cnYh34/udTs0F/UafaeZZEFEE272BxTJ1pTvXO9fB55agoNBkCaS6yeJ6PNY6O8Q0v0virJkERkDqWXTPbJuNyBrkAKmHANe9Nwv2abH9bgrkzVCHZOoBQ985kC/h7xcDHw3gLnWJfSyh
 AKOp2b/f
 nyICgfoagkNDb0K95pkkdpXwI8Ant2JmhiJlGWA61ECHBLiH022ilo70RY/BqbE9LEMTdPrJjhYnNXgNB6eerNY+W0QXK/HHrtWbjFeg3uOX50T+qHhC9xHDnFo2oKuUOcN4mKIaupUSxvZ0rXO04wpsxMarjpI43IasVt/Za5RoGNXl3ljpdYx1osSNg5/jjuB0clk0tramDTLabwroarsBEWDKFNJADgr02wfW6LXKoIakJE4cYkv4aWyP82DWzuk4/RMoZ5qLBaGkZTjvs6l5//C5qx0t6IUVNFEvJpXMHUFTwBzUr1idl++HHJiozUHY1q4bXnfI/eyO8zUE+cVraqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 10:23:16AM +0200, Vlastimil Babka (SUSE) wrote:
> On 10/11/26 03:48, Sang-Heon Jeon wrote:
> > setup_slub_max_order() clamps slab_max_order to MAX_PAGE_ORDER, but
> > setup_slub_min_order() has no such clamp.
> > 
> > The buddy allocator cannot allocate more than 2^MAX_PAGE_ORDER pages
> > at once, so slab_min_order above it makes no sense.
> > 
> > If slab_min_order is set above MAX_PAGE_ORDER, it can even panic at
> > boot or invoke undefined behavior in order_objects().
> > 
> > So clamp slab_min_order to MAX_PAGE_ORDER as well.
> > 
> > Fixes: 81819f0fc828 ("SLUB core")
> > Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> 
> Hi,
> 
> this is effectively part of my bigger refactor here:

Ouch, I missed that point!

> https://lore.kernel.org/linux-mm/20260923-slub_tiny_rework-v1-1-a0e66d536eb5@kernel.org/

Looking forward to seeing further updates on this ...
(and hopefully do more review)

-- 
Cheers,
Harry / Hyeonggon

