Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2AF1CCD1BE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 11:09:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E9748E000E; Thu, 23 Oct 2025 07:09:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0999B8E0002; Thu, 23 Oct 2025 07:09:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7C198E0003; Thu, 23 Oct 2025 07:09:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CF3378E0013
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:09:18 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 770EA48A24
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:09:18 +0000 (UTC)
X-FDA: 84029107596.05.F211D3D
Received: from fhigh-b2-smtp.messagingengine.com (fhigh-b2-smtp.messagingengine.com [202.12.124.153])
	by imf04.hostedemail.com (Postfix) with ESMTP id 731A34000C
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:09:16 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="K TtZ9kP";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=ZvSBd6Pk;
	spf=pass (imf04.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761217756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e9KawlaDhjJS+ZMKZhm8w/oQQAYs/+bmrKLwAa9o+Oo=;
	b=SFsXSdSUa8fkD7oUW4c8SGx8nPoZKIH7faUAqo7pHynrRGswrM0TLtY563Qh6AOFyWq8eh
	KilotaY491K/Rt3dINxL4ScnuOF0lOGfSdw/VPEtJEB/KQ58uy9pKOh7+WW6oytVZmAndm
	v1fa+5shAeHDC4qd3CXFpcNGUuV2+6g=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="K TtZ9kP";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=ZvSBd6Pk;
	spf=pass (imf04.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761217756; a=rsa-sha256;
	cv=none;
	b=ywrcYul3qJ47xcm5bllzC/2b8N7njK2p2sg2LFgx4R+hcnszWpbqk6yob3DxjqlXDqTE8m
	yfjM5VOsPXC176cmcgvo4y0oPQzZXjhRi0flJ72QI8QvR23+9GJ4FArpbx+CsbZSXD5zJn
	oTSpNnMqG1GlXjJF/R0UdEecW2z0fFE=
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 54A967A01AA;
	Thu, 23 Oct 2025 07:09:15 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-07.internal (MEProxy); Thu, 23 Oct 2025 07:09:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1761217755; x=
	1761304155; bh=e9KawlaDhjJS+ZMKZhm8w/oQQAYs/+bmrKLwAa9o+Oo=; b=K
	TtZ9kPrsDfd+3EaDrvYvKpHAYzkTIVJrAmKe43FITa5lv0nU0iv1DvSxHM2brJHP
	gXTzRl0evfqb/S4E1iAxXB8h82GaBDpSCh81DC1kl1jdJvli7hF3tMxQW2BXQIfX
	C9TPWrTl258e/B7muQMshy7xxhDnc2hzV4ymHyBQr0pL1R0mz0HvVqOXyxjBT1gd
	FAK5k3Ab0NutyVxM7b/mHjEfS1zhsklO20wj3qj29BFELNA4MNl0klKX8SG3X7FK
	Tk+j8/6L/LHxHk9wo6ugVTSkkUDpb/IU5o0y7HmBoDrLB66MxRaG7NkTnx+6b3aj
	9+M5Dixxcx7gLWJceyAQQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1761217755; x=1761304155; bh=e9KawlaDhjJS+ZMKZhm8w/oQQAYs/+bmrKL
	wAa9o+Oo=; b=ZvSBd6PkTl7poelfrzGYRIkas/w2kqCzCVlPo33fflhWd8vbGGD
	QpOuZsa7EN85wVTexfkKIF24Ia5/TCUpbU8qL+h3KWOp8kJ/cYsCw/m0qryEg6ND
	D7BxD273UqTbDugWmRK8c2bZU2ObW/RUbITAwpMcIrw1eWmI5O82Zfb5UZ2q7/5W
	fApkBz1Nk+eD+UgFEdLSpvSDaj3toTfNrTN3eyYTeHLpuHXv/fbaZV3q/7DiWzve
	ZPiB/ockgXEUtYhDYcn/k0GNk9IF79AVhN+Q1S5GK1blhpv/J1laU8OqzQd+Hpk+
	pvnwF2igK+u6FU/zLCBq5ehZT/EAJpI3hAA==
X-ME-Sender: <xms:2gz6aLgPC_4h27QyswLx5Cwse3RkDSj_uz_4GZaG8mnNLHpnvEabCg>
    <xme:2gz6aJWyRsYlYESon6RK4edRatJupDlTRapA3AHpbp1OC7G-aAelaSHYHjSyTnKfX
    9YEjjSqwREQkeITFqtnRZ_BmWqrui-aoIUY0rsoMSJzjAWPlOIE8_M>
X-ME-Received: <xmr:2gz6aPvrFmO55TAZcbaCU-gBvZySktHrGHEVrq2_E4mX_Q8BWgYEbXORR3UfaQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddugeeifedtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepjeehueefuddvgfejkeeivdejvdegjefgfeeiteevfffhtddvtdel
    udfhfeefffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedv
    tddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepuggrvhhiugesrhgvughhrghtrd
    gtohhmpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhr
    ghdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtoh
    epthhorhhvrghlughssehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphht
    thhopehvihhrohesiigvnhhivhdrlhhinhhugidrohhrghdruhhkpdhrtghpthhtohepsg
    hrrghunhgvrheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepjhgrtghksehsuhhsvgdr
    tgiipdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhgpdhrtghpthhtoh
    eplhhinhhugidqfhhsuggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:2gz6aK-j5ahkGjat69k16dsaj_YxKtt6KtPiks_qU2wDXwki7BDPRg>
    <xmx:2gz6aPuITyhUJk6Nw5pKFFQR6WrAIQmg30Seq_-GRtZp0CNvCvcnTg>
    <xmx:2gz6aA6cv6s3eOCKW0IeSI7ZfBvceFJVxxXs8Xr538dmhrLrLBnkJg>
    <xmx:2gz6aINJcBwkBSnrruG4pP9k_2H-RjmOYbZ2I3uAnWQ8EefKooggHA>
    <xmx:2wz6aJnHpCeaO4Lu5OQQekx6DiIO6DwritTNhnpjWjS4xbjI3-7k-luM>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Oct 2025 07:09:14 -0400 (EDT)
Date: Thu, 23 Oct 2025 12:09:12 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/filemap: Implement fast short reads
Message-ID: <55p3kov54tjf5cr2sm3h3z7hv5cq6nlcqihlyxa427pz5mtkuv@nddjx4onw6mq>
References: <20251017141536.577466-1-kirill@shutemov.name>
 <dcdfb58c-5ba7-4015-9446-09d98449f022@redhat.com>
 <hb54gc3iezwzpe2j6ssgqtwcnba4pnnffzlh3eb46preujhnoa@272dqbjakaiy>
 <06333766-fb79-4deb-9b53-5d1230b9d88d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06333766-fb79-4deb-9b53-5d1230b9d88d@redhat.com>
X-Rspamd-Queue-Id: 731A34000C
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 8oqe9pfp4iwwu9wnn8b9z6aoz74gfgt6
X-HE-Tag: 1761217756-530879
X-HE-Meta: U2FsdGVkX1+grGl960ioNz7ustaVhEcbE9SxX7msUOwHEH0K7OiAect1Cidafn3f7WwLlq6rSuBlCVzY0Bj40XAEBU49o4r/28swpwO6CSWfY/yeIs2X9voWBw/YPSHZVKjMturpUnOHZlL+KobFlbiCWaBs3hf5+fa0hjUPYdkzx0E05ucZ92myBTpYh7wehjcvZ6Q+4/uBBVCTv35t50u/q4CXHVHn6/VkyG+A5U39EDpOuje3YdSqG16keR0Ox5v4GI2jOBJVqiz0NjEpY9DFcLkn5BIDg9wBphdKTK2DjcfxgUk9xGDmK7aFdBq66P/1upPTgjtQTY8I7WkIxdmiGj1vxP32ILFv4Q5BeodLuMn6e5qIZF+c6k5tTw+Ec1b3CIKr3EfXHH6U/CThgqrFG8i2uqp7PUjiV/ooPAaFubY6pPN3dWXT/mXf/hmgJm1wUigqitudHA7vQ1Y4QYFpKyFX4Eg6N6iB18fTPwQf0qHKqxWhehj8eOhwSrlMlu60+W1Dgpa0fPkkaANQcQcCdGI1OuXwHc4AXe4Q6UJPPUmYriu82PloBnWC0EcV/uNm0M3EzjjwrszygXaKwfLkNQfMXMesmOYRmz7U2ao5ISVvtbozBGJOPfUXxPg5nS7JPbdCglvaSz75chs3SLNKG/7uPscL1SbINJrrcXZ+8rZxZQD9d/pUErKGOvCE6cRrBxOBbAyK0AmF+rSGA+gKubXWcomr/qvHvsK0aNf/gf1ofum3a9qtxCbKEeQqicumvwGM83Tll9ktkg58S3xK8LPU70m8GwibayfNVESQE7mNuPP4yBUgHZpruvemUNmRDwoo7Yz7oC28gJsMt176V9iCppIPP471TE2KSvFZ0Dr+03jOL57vHbq52dflokWi37AQSWkoyAmunQvOiDdicH9kjfTeybaSVAtPKycqxu0pCN93Dp6pckEpFfGh0xf96jrP1U/0kxFib6O
 iXIM8maw
 nI5MC/r6Kw8G+CA2YdrK/xYK0kH4AtSkkkdF7sdKTgHKsG5EJHgRZKEUL+TlTZ1c5d44w/Qsli1la+9NFu3FC+VnvPEHEX7y2kM7pRVA1nZgCz8sxXTySe0BTB6b/ushWH2kSj+Ohq6BMm733JOwipzS62i9W41Y1BU0CiZrU5oXZrPCr8SGHrWwmRLW+KdkA8rDhZkrOrk5yO150FSJBjyw67zciqEsk1BT+rYeD3LWEMya7CoRPqtsz681cvn7cENFBdd9I84faeprws+8F+cwxfPRza6rQYZb91k6KfehDBWm8RcTDGSMvP85RC5plFPEAKVgCXsiI/ZOEZX1NZH0J8l+JMbKheuLsca29dwYhJrvQIs11L6QgQee1ueTjS65TGaskRXxohZjWM/UkYKdVs0pi6ar1EmgMW/MCkMpf/2FaJUB16bVF9Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 23, 2025 at 12:54:59PM +0200, David Hildenbrand wrote:
> On 23.10.25 12:31, Kiryl Shutsemau wrote:
> > On Wed, Oct 22, 2025 at 07:28:27PM +0200, David Hildenbrand wrote:
> > > "garbage" as in pointing at something without a direct map, something that's
> > > protected differently (MTE? weird CoCo protection?) or even worse MMIO with
> > > undesired read-effects.
> > 
> > Pedro already points to the problem with missing direct mapping.
> > _nofault() copy should help with this.
> 
> Yeah, we do something similar when reading the kcore for that reason.
> 
> > 
> > Can direct mapping ever be converted to MMIO? It can be converted to DMA
> > buffer (which is fine), but MMIO? I have not seen it even in virtualized
> > environments.
> 
> I recall discussions in the context of PAT and the adjustment of caching
> attributes of the direct map for MMIO purposes: so I suspect there are ways
> that can happen, but I am not 100% sure.
> 
> 
> Thinking about it, in VMs we have the direct map set on balloon inflated
> pages that should not be touched, not even read, otherwise your hypervisor
> might get very angry. That case we could likely handle by checking whether
> the source page actually exists and doesn't have PageOffline() set, before
> accessing it. A bit nasty.
> 
> A more obscure cases would probably be reading a page that was poisoned by
> hardware and is not expected to be used anymore. Could also be checked by
> checking the page.

I don't think we can check the page. Since the page is not stabilized
with a reference, it is TOCTOU race. If there's some side effect that
we cannot suppress on read (like _nofault() does) we are screwed.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

