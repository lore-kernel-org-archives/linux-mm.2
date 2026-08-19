Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE4D0C5DF81
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 18:22:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B524E6B008C; Wed, 19 Aug 2026 14:22:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADC3C6B0092; Wed, 19 Aug 2026 14:22:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CB336B009B; Wed, 19 Aug 2026 14:22:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7CDE76B008C
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 14:22:28 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 176F9A2F29
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 18:22:28 +0000 (UTC)
X-FDA: 85118839176.18.E3CCD32
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1C2F816000A
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 18:22:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="M pczfKb";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=bSAVEfLX;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787163746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sd171Njmo7N9wtDrBKRjpfDcqAauw4CAX4wRLBvZeJI=;
	b=HrocpseUh4dbLwzg9wShlEddJdgmQfLhhZj+3uLFjW/qSrl0FCYilbiHRdJ/9Pa/564iL4
	A1M15juZAe3fGxQHf53FNtt4lMBoNb16hFj649hLvrswdwRWvbxwIAuclkIPdOlvdPE3Ly
	fQ9H06iGbfJAOfv9yx4On86Tku7ZEGY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787163746;
	b=YiJh1NOyQlfQJNvufyq0jwj3Rk/Qzef0PhcxdAx2mb8c6pKWrPp8EFCW98x0nLIm8whoQd
	q0LBqRWmZzGRqL3J+d6X/turHh3cBlNVbYPnceIVCF8GwMsdbLxrEM8MsGR5PLJldbk/jY
	7yUmocNjSKnoXHCrca1GMRwoyzhp4VM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="M pczfKb";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=bSAVEfLX;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.stl.internal (Postfix) with ESMTP id 0858313000DE;
	Wed, 19 Aug 2026 14:22:24 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Wed, 19 Aug 2026 14:22:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1787163743; x=
	1787170943; bh=Sd171Njmo7N9wtDrBKRjpfDcqAauw4CAX4wRLBvZeJI=; b=M
	pczfKbvuvYwR/5/OH3QjADkMQz90zU9pK/MNC6i3dVAOb6bMLd2I0LEIn3SGr02I
	a7uM9IYZcoAxi15C/3tSsaNZwyj/55m1MntBnq/UDui2miaGZiBI6KQQjiAFg8Dj
	bOvZ5P0u5YqUjsmrlN0CCUJtJ4KFIIt5XIbj1QM2wJXdFHOsvHuC/GAq/MIAyy28
	EM7oqfxpo06pHk/L0HE8LmspFtQLWe6Fzy4UU1c51YAexppzB68I0hhI2IVxjYH7
	Xr460rhgbgRBZBL0r8l/j0igap84Q6pfg3sTSlMpKw3ROlXTlWY4dC6giKcw/JHv
	1dkrayFXlcBiWi9jwW/xw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1787163743; x=1787170943; bh=Sd171Njmo7N9wtDrBKRjpfDcqAauw4CAX4w
	RLBvZeJI=; b=bSAVEfLXEmUY+no1vZXDENyl6pBoc+nFVKCclkeu0au2ZFJBure
	iPRe9SHmUq32bXKInB9Iwj6xG64cQ2jLGnsvitjm/VJmbqz2QykzyArsxNb2PSRK
	7WDGLDhBDdvMvhZBQsyaPt14Kt7m98jVCtHFPm+pgLqThcjI9KvlW/mYQ+CMVooM
	9NGz5BJRB0Y+nDmJ2GEz++F95kQ/oZg6/XVkrtmNAmqhfIE2VqrkgSTYlB3eH7EK
	8gHEr0h63eXWRJn8w/kJ1TFwSB5//15ZZEYOEB/MysE/FINz8BaQBe5nIXWaTsQ6
	yYig/7d2MT0VHVoWdpkL4UdQ/eHGEJ+LOag==
X-ME-Sender: <xms:XvSFagyp9s38xSM7-XvSftydsJ8ueGh6BT813_BgNx5AgLJQYo1zlg>
    <xme:XvSFamlYWTksNF4YskWHfwtFDMyiusZDn3C1CgDR9p3k4R2hRWp2IZU8wUyQiTVWP
    FbP-mnyIwnUvpXcqAvikU_widqqH2MWoGClRnZKXzIf6tVZ3o7zkLw>
X-ME-Received: <xmr:XvSFahEi8Gvu5s9jdHUJJ6DMdp4wvi5iCPRy31buv2B4q0zOrKFnYGs2DtU>
X-ME-Proxy-Cause: dmFkZTEc8eAdlmAO+7Pou/CI2g2vMZ+SBHPEyBpvlaspGE7alyk+914Icm8/RhGoTPP4s3
    JPbd41O5HXrSLFGLpJE+r7+dmvBIQrpY4tORlWpGM6e29MaP7bgfO5k5JZAuQuaCyLvptB
    vGqIl8B1rdV7WGfjTX8AVsba9HV5pnTMHskYqSe5muw3bkHCq16rFGhWxyRtppAa7725RE
    mGYvn4dj1AQ0yc1Ss3kUrcwg/E09Jxc2PShZG8tzFvwOnT4E3IBvcKn9tj4Apor7nsDuhi
    RjEoRTHloezvXPvMcoZCz/1VtBzdJ+4nII2hAxILFAT82+xKQH4TOwAwJ/em47iE3TD9Lq
    cLXlERFA0YoTifw5ySfqW9b4B+p3A230UBY8O0qbKJv4U26C4q0qKhO9hwCN9l6GAnKmPY
    lxFTowMxsM6TAzVVt3s6MNCYSursXbX1oP6jxEp/fWhRlK6NruqcMeIQURcSdpOQICSNXG
    ACBQb2bnqLNmk7/T8zgom5XFmi0/6q7wQJAqeWQnP0JXH0FnHWdXhJJ3UGLqlq2WdVTSR7
    eoBVZ8UDUeAs0QpyKYRRi6H/syUMssCXuMcEn1sUDCHAMefrRFfFR8NzqR4ybzWthYx5g4
    9oqZmJtD/yaOvOVgpmIi229oaZ6zy/y13gK7bh+gmC53di10lEy2YwZtudAg
X-ME-Proxy: <xmx:XvSFaoszFeNl5z-w307eur06VFMGGpwcYmYXSxc3iydE69jQdSogdw>
    <xmx:XvSFakkPBZOEOv91tfL4xIxhgEvN0dupYLJKxoC4bbHqJt6IPB7cbA>
    <xmx:XvSFaowqrYRDntwWsQ7b05HDZe73x53UJrR-b_Se_PmghYuMILvFPQ>
    <xmx:XvSFaqz4CE0xD778dBqvOD6WGPKyPX2VOPwOf6qj3Jlq7GY6rEk4Mw>
    <xmx:X_SFagPirkEpzJkwyVu2NN4TXosURJFJil-8eydlUCC28b_hzTBGImKJ>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 19 Aug 2026 14:22:21 -0400 (EDT)
Date: Wed, 19 Aug 2026 19:22:20 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	akpm@linux-foundation.org, nico.pache@linux.dev, baolin.wang@linux.alibaba.com, 
	baohua@kernel.org, dev.jain@arm.com, hughd@google.com, lance.yang@linux.dev, 
	liam@infradead.org, mhocko@suse.com, rppt@kernel.org, ryan.roberts@arm.com, 
	shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, vbabka@kernel.org, 
	ziy@nvidia.com, usama.anjum@arm.com, agordeev@linux.ibm.com, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, jannh@google.com, 
	willy@infradead.org, pfalcato@suse.de, rostedt@goodmis.org, mhiramat@kernel.org, 
	linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH 00/57] mm/collapse: rebuild collapse on migration
 primitives
Message-ID: <aoX0FF9ysdc78UFG@thinkstation>
References: <20260816224609.308019-1-kirill@shutemov.name>
 <aoLAly-oL2OAa4n8@lucifer>
 <aoLkMUtmzRVuv2Hx@thinkstation>
 <99138bda-55ba-4c58-9b79-b76e9daecdde@kernel.org>
 <aoRuqbgFAPyZtUli@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoRuqbgFAPyZtUli@lucifer>
X-Rspam-User: 
X-Stat-Signature: hyp1pg4qp74pw1thnh4b1wy1dif79cx9
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1C2F816000A
X-HE-Tag: 1787163745-92518
X-HE-Meta: U2FsdGVkX19XoISVgVfJrr3ctO69HLgksGRGgUG3/Sv8G3/FkcM/6OJ6URH8vUb5XCdIumiVIUsdQa700XMhuP73nCdRtaqLTtprUfCqFc9k6HxJEqNsxXmDEMWyXVX2OH8KUVjMCYXmKIqiw0OPPNIc/MMKfc7vh/A3LuyudHYAdBFcpWpSwRzVV0v+R2wqOnBxlDipqVnEJ3Uk/TslolhRgWXCGWXUKJHuP9cE21KqN+GtqInocxwDrbng0/IUWKnOp2YSIZ++MxtJBPnu+FfUwjyKu7PpvwSaShOZxcsPPVHQkOgiNTZuVFuZ+56ia3uJC9ECMygmBEUM9/KnXfsbW2wVE1m+mmwIHnjXjp5bcNx5nYUGGLtBWNSz2OMfe/vxZ1K5S7pz2kC3/bPL9F/RNczVBjh8qjokqtSY/IscoRDHcGB2/7gYLl885yt3GoZq8GMxXx1CSyaNISb3EtJp5I0cmkjFz5C9HMw1A77jQ2Rhd3BWf+Dpyp96qX9wmap3VEy+gzuLYqdkcJh6vKhNEzO8bVgQG5f6MOZybBD2xmbT06ax1L+8o9+0TRU+kPldkzwkWTMr2LWVh52R6kOGakDEU3zf4c8n71jlq5tKzdmO7So9HcVj3Fc7OUM0vvJU/0m32fgvIa+pUSwfmxvOkuusHhoA4SHe1fYMtttsh1Fxnh9Xpx1b7TqDxGdhPfvEo7fqg0PhHSPRSFu29s72u3iXRsN8Atn8eYupGBdC2mnsawnoMbMPUIV3sBb51klzqH8+Mt2N8Kdqh8u26hyea0MXS+ppmlcRX76Kib61p8k+NBJrsHEKp81OyYeGpcI+UqCFh+1RAfmaqkn/IIWLGsrdBchplE9u8mj9USHdu5j0L2yKfTfWcjSPncYWqoCbVLXwvs+tKjKwLVQzhihHyUnPChh/doVgs72FLeMh4HH0InHkwInsV5ZtjOCH6z/80C9XnCKP5inuD8/
 CBIW4N32
 7CM69eOLBMeypk8cHmZmcYb5negg3PSN6NLfc7aLTCvTXBHzbIfoDB7ipSS0UOuaVUCGwJ3jFIG5ooArlOODJompKdmtmsJrXzJIW3dm2VsjQx2LJZA4j08jemtdZuI2WNFzQF0VMQIya4Wyf/oBawqq2h4tTOwIbRfu+UpGqT/IyDG5zgUb/eEcf879psAixX02YrC8OID/g2rdkmdxYF0l24EIZs4oo6T1Q/zPSm11WS72euD6L+qHeUjZlmYacBzyaGLhSSt238eKoX3AbonZTP4TY4nmggrOOXllbp2ODo5JyvvIyBbs71waP65tzBRYYbquNMfZJF3t7qI40P1WDzlVC01doAnuGy4gcSHUKgbiN0VNuzxdSql1J+eNTAtZNOdu9vZOvvVWVTOIvZNT2hyfGuCaAFhES+LEQnaTDyK/RwBSwnWQVSvhL9neiAM8E
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 03:41:40PM +0100, Lorenzo Stoakes (ARM) wrote:
> > Ah, I missed the context in my other reply. Lorenzo already had some patches at
> > some point to split up mm/memory.c into better chunks that will also better help
> > our subcomponent maintenance model.
> 
> Ah yeah I kinda lost those but indeed doing this is a good idea.

Oh, well, I can give it a try from scratch.

> I should try to dig those out again or look again when I have a chance...
> 
> >
> > I think the challenge is how to handle huge_memory.c, because ideally, we'd not
> > have these stupid callbacks into huge_memory.c once we make PMDs just a
> > first-class citizen.
> 
> Yes and another point and I think it's one that Kiryl also gets at is - can we
> _please_ stop pretending huge folios == THP == what the page cache does == page
> special cases like DAX? :)

Yes.  That is also why I want the split by operation rather than by
THP-ness: a PMD case belongs next to the PTE case for the same operation,
not in a file that collects everything huge.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

