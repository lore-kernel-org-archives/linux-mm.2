Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5225C5CFEB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 14:11:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D62406B0507; Thu, 13 Aug 2026 10:11:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D396D6B0509; Thu, 13 Aug 2026 10:11:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C76EE6B050A; Thu, 13 Aug 2026 10:11:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A6FD86B0507
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:11:22 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D3EA514018D
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 14:11:21 +0000 (UTC)
X-FDA: 85096433562.11.705BCD5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 427E540004
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 14:11:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C0LPBiv3;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786630280;
	b=qdXNw0snYKMN5uD82HqAkFkg3rmRPvz3bMuXPtd72OZJF6lHviAMKJJqFrkSKy+E+5lIiH
	lFlngsVUZ4vUSOptJlEAIWQFkVgaLuomOwFduN56mBLuu6rSEuQasXmw7xEJZKzgroh43u
	WmlPTWpiDvXk9P+KbQk+RJ6ewAjTnso=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C0LPBiv3;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786630280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i5xAL+Z6ioL1kBxUqERbF2n1+xxFZM3APIleQ/627xg=;
	b=OW4BVjDyvrGKmHmD5nyPzQcfAKIE4nMYc6e5TWXTaXRVkMaGx+F4XoC7MERn0dBLwRNXfL
	XyDgrTgnroLUSzKAABe0QyiW+Moww2yLcDw7o47GVUrenD55/2OU0dCQolZYGF3V7yMN8l
	2tiBH7YQrg+KCAWAt+JAw2NSfWqCY9o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C85EB61895;
	Thu, 13 Aug 2026 14:11:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15BD31F000E9;
	Thu, 13 Aug 2026 14:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786630279;
	bh=i5xAL+Z6ioL1kBxUqERbF2n1+xxFZM3APIleQ/627xg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=C0LPBiv3ugznhdJe2Kxnmfk8+i054ETuqXdHulKqnl6sEdQRjyAFzmJGpuHMDagFD
	 q7Psv29rlT+SxjseUoDD7KqNUHPP9PJspfrL8fke3bZcdG+T3QheYoIutMkwY9XUHX
	 iGjeOuGJfuIT9Kydmd4Uh5brx/KPWXW3rQFQEAk7oW1ka0xxQyT74dimFPL0p3YdBL
	 sEuFvfc2bs4QFmHQlcTtk/X0xG3xkyz1BAG8aQBld3f0t+13006b4uxU3OuNlt5JxH
	 ulqxu+YMkIHKFRFmYDqcivA9S/9L/aNWjvNykv2H1qya4UaA5zwHtfEPdEEDjkukhz
	 d0PYjywOjc3XA==
Date: Thu, 13 Aug 2026 15:10:59 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Daniel Palmer <daniel@thingy.jp>, Hajime Tazaki <thehajime@gmail.com>, 
	linux-mm@kvack.org, geert@linux-m68k.org, Arnd Bergmann <arnd@arndb.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH 3/6] mm: nommu: fix an issue on map request to
 /dev/zero
Message-ID: <an3O9QHUZSSGIiZD@lucifer>
References: <20260813063401.1786548-1-thehajime@gmail.com>
 <20260813063401.1786548-4-thehajime@gmail.com>
 <2026081355-remold-sterility-84f9@gregkh>
 <CAFr9PX=zC8GnxwrR=wTwA4xQq89cHYpxZWooS+-=Q-WuNbjanQ@mail.gmail.com>
 <2026081308-amigo-paragraph-3afd@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026081308-amigo-paragraph-3afd@gregkh>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 427E540004
X-Stat-Signature: j4ts36jz5fjk3gy8eihxuiaxsua46kez
X-HE-Tag: 1786630280-78893
X-HE-Meta: U2FsdGVkX18wK2HZWdqkX6gvkCVbArBBWlN8oxFtcTETTYJTeeSR2reX/u8q2CBk8pb2zQlC46WH5X7+gp4WXf1VuHIzjd7oWoJwh9YSuvWoKk5A0+oODVw5JlYvTiy44enx+7JUHQ6PfgeYlihvcC2V9FvJPfxRzGQC7ZvNJZ6uy6vlvI9kKg9bxC9rTZrdoQzUViobIXRi76UtlCFhzM4hv4EqSaK6dDXOIL4Zp5yR8/LxSzOwIaubAeBkxOh7MVjU3kCWaTekOATka37gdiSwoe0RujocUSEYTJovxKh2P83NdwctwguL4pAe63HdErh/gfbr1SHT2e7LRDHNv/7J6B+fJY2mTHVjQZGVtHgoH1xp3EZL+JCD+lJM12pmQfVoeddU6loS3gyOacSz8phZgYU2cRl0SFIUkx82/iInArN23IGn89X/jXjZpWorkC52bup5fYQzkGb1JZlrEb+Cv1wg2JF1LZV89ep9PdYNfMfStVzyUzFJAMW3FXagbjiVzA9Ks3KLBDdalW17S+sz/cCYlB7NtFJAjGDNcMbt9zmwZv5E85JRWpMjZzwjFpvkTj7Xd+L25XYA41AFj5vnAl/UXOGZFjcPOLs4K8T7zOKAsZKHgjhoDKaBFnP9nIholaEvDXlBSonC2pnQdxozV1EnxSFraUckns4ajiEksxidvBl5SMgS7wsyVdxPLHdV/Navk4naFOU/K0wKeSqhuu0xO+GFjHEuKfcYDXdeJTrb+EZxBebNQRv7GGeCZsVG+Xh0A8k8p+p7fK2WKER0XPk91xr7Y7oWTP5xEho1fR7zGwatv8KXQveaJfELwU16SkuvLIB//YV5ce2Hyrkh9L/oQpVGb+Jcb2GBXLO2KJLYc3DczZNbyOxQq7F14YI3MzB3Jpjyj1R5x4pHMsgZBdY6LR9/r7rERSF3L+cD+F5C062V8N8f2/hCnFfasbktBfe6MZ/Iqux4MQs
 nSGUMRXC
 8jG7Aue1bD4BjGNVZVMnTowXLpChwqmkgkUclLjloPjQNTc8VO5gHCHULizEWRLCXWCOt7oJsYukVn1iejYQLo54J/L7/rKSEtxSyKXz4wU/Iw032yZ45l9+NI62g77Ssq3NU+59cEQrOzSI5f4f1eSqxuyKLuJmeydQDEuEu78jlQcMMCq+E56Sr8GKdF3gByXhq3ZuGY5pv8OOzIVLsmf2io0BypOREoIKDX6+tJfrl3eXF7lnbhiZPlBZrPk8sPe5GfQsg3KopCRtzdrzdjD7eL6hywP5QiFu7stkbRTybNbAAh84QYkiZc3yeW+AtHd7hD9BnghNWMJZ3MAnl/YrP0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cc Christoph

On Thu, Aug 13, 2026 at 11:02:18PM +0900, Greg Kroah-Hartman wrote:
> On Thu, Aug 13, 2026 at 09:43:37PM +0900, Daniel Palmer wrote:
> > Hi Greg,
> >
> > On Thu, 13 Aug 2026 at 21:26, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> >
> > > Given the age of this issue, I don't think anyone uses no-mmu systems
> > > anymore :(
> >
> > There are a few of us using it for hobby stuff[0][1] and there are
> > apparently people using it for actual commercial stuff.
> > There was a session about this at LPC 2025...
>
> This patch is fixing a very obvious issue that showed up in the 5.10
> kernel, which was released in December 2020.
>
> So I think the fact that no one has reported it before now means that no
> one is actually using it :)

Maybe Christoph has a view on this?

I brought this up a couple years ago and he claimed there are commerical
products which use the latest long-term stable kernel (6.18 at the time of
writing).

See https://lore.kernel.org/linux-mm/20241122123833.GA26432@lst.de/

Christoph - can you explain why none of these vendors encountered any of these
bugs or breakages?

If they are doing fixes that are downstream only, then that argues against
upstream nommu.

If they are not, in fact, using long term stable kernels, that argues against
upstream nommu.

The fact they seem to be assigning zero resource to upstream also argues against
upstream nommu.

nommu continues to be a ongoing burden for core mm that interferes with work on
real architectures on a fairly regularly basis, which argues against upstream
nommu.

I'm curious to learn what the arguments _for_ upstream nommu are?

>
> thanks,
>
> greg k-h

--
Cheers, Lorenzo

