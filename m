Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5394C982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 02:08:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAB786B0098; Tue, 22 Sep 2026 22:08:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D83166B0099; Tue, 22 Sep 2026 22:08:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC00C6B009B; Tue, 22 Sep 2026 22:08:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A968D6B0098
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 22:08:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 36ADB4066D
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:08:54 +0000 (UTC)
X-FDA: 85243393788.29.9DF6A39
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6FF0E20002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:08:52 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LCZRO966;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790129332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Xadl+2XfugsueWfpjgIKjzsO4w2kEQaJhd+prKQ42Q=;
	b=kPxVPN79CUj10szd5AOSAf2rPN9mY2Fc4aLpVuew8G/lCa+3rMUeaD0ez1rkPjGUCCw+tu
	FxQMq4k/xIMer38autH9fQahdCNn6THFw7E25vgaTcQUt0D4CoXXICEBk1+8qVcR789BFM
	Ly//ShYQ8q+Holqmjw40fODePZ8d6z8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790129332;
	b=MMn7N/VARii9EjQzDcmBWlUWXkhiv83ZS+1WMC/R8t1xqiO2xqM4AAE7ApBnbGGv2SPPVx
	GPIqWxcL5jLkgnL3Gf1gOSB570Cx6YoYEys5Ro7RVBsh9rvpHGf4bYKeM23GEv2Xo8FaaN
	yPt7neIaWqkVYMiwCf/x2kh0JFa/SD0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LCZRO966;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8CEC5429FD;
	Wed, 23 Sep 2026 02:08:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6BCF1F000FF;
	Wed, 23 Sep 2026 02:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790129331;
	bh=/Xadl+2XfugsueWfpjgIKjzsO4w2kEQaJhd+prKQ42Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=LCZRO966MJXtXlmSnshT6skldVpCIVltLpzcANgImksrNBMw4dR0xcJfeHpjJixW6
	 /kLRDerxNAmBzlCUo+jtAldaykUQ3uGfcpfuCWVlmpjJjSz0B6vjzyBddSxi6twTrE
	 RUbUTdwWJBLX58EqtVnMHKXUEFgHN+FjKK1xGa1U=
Date: Tue, 22 Sep 2026 19:08:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dominique Martinet <asmadeus@codewreck.org>
Cc: syzbot <syzbot+de6fd6789748a8aa64a0@syzkaller.appspotmail.com>,
 apopple@nvidia.com, byungchul@sk.com, david@kernel.org, gourry@gourry.net,
 joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 matthew.brost@intel.com, rakie.kim@sk.com, syzkaller-bugs@googlegroups.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, Eric Van Hensbergen
 <ericvh@kernel.org>, Latchesar Ionkov <lucho@ionkov.net>, Christian
 Schoenebeck <linux_oss@crudebyte.com>, v9fs@lists.linux.dev, Nguyen Ngoc
 Thang <ngocthang2710.1999@gmail.com>
Subject: Re: [syzbot] [mm?] WARNING in v9fs_fid_get_acl (2)
Message-Id: <20260922190850.02e782b7196791602163a3a9@linux-foundation.org>
In-Reply-To: <arJAGlhkDJbcy2sw@codewreck.org>
References: <6aae188b.71f81b7d.15fa6d.0004.GAE@google.com>
	<20260919031451.3f47a8da8405e88fa1ab5398@linux-foundation.org>
	<arJAGlhkDJbcy2sw@codewreck.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: em7ibsd6gsz99rzxpocpcjpicp5ps3n9
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6FF0E20002
X-HE-Tag: 1790129332-510590
X-HE-Meta: U2FsdGVkX19wfiCFpTVHSODZ42MZ9BlLfT+YShCAOqI5jxmKHlaXC/dFg206OfYOQZD7JKbUDBzcgKiqKRNLTYtXrebfSVGIfw3GFIZilIZQbfjf25dp/O9zM81X6VwJuae7OPlJu6XSCMWGc8LHh7BoaS2PzjL3S5fNQrnqzVbuDDUUv7Psk9KFtlK7sw2q4BJNBjTNGljgZd1EpgPs/+9Hf6tHfNFyj12sFvuDPYex8bYA+Kfw9gpPs/En94ebkr2G/yNEMLm9WYlnDuPgByxJits0yC3wWZanVBMq2HR7oS3HwcLu/4b5zyskXTdAHwLRfFPNx2gAE1sGqQZTcbBKQrjhlWiEFfuvC18Z8cgF2yPQ8Fnf7KDYlRR0SDtJ6qWYFvNaOWxJXUdc56IUkoxdOuI6hme7y0ltRBl9FzyKaWus4a12phmbvjI/FA3R5D+YJTdXZLZGeoHRQIiJOEXA1k1jRoqAT41IdKrN/O3K/TnNnPQYQXClZLVBTyKZM7w+yq4qZTYA/bYf/un1vTicIVy61+3cjeUP22Y/0jwa76ZRCi0/v0KFtPiqdLynfFXCEcqHgqiApOkEj+lvMNr8Vr1TB805wij14mX/mcpWKvDf9TuUYMB7wTXHhZaoafLyYiCzQex6hIAqq+jV/1PUwhHj2b8hrEp3im+M8/zG8yk9FCGuPcEc61ejRYQcZ4y/CUv4jhTECKb56WjTNi+6a9ZH8tVWNS0hoaANWEEJEygb0WaYJlbR3/uOmJsWi/lb6lev6kQtGYYsjSmgHmQaxcW3W3ISoMOGSAZ/05u/yWnnmfnSk+LgP6AcbDH6I1hLWM5dCPNdV6bWr8aV+X+1kq2kUgI8L4Gk4llgWPV9i43uUYgIv75mt2DVJ/faOk6nX7HGn207nFmtbsz+aLqzrNjUPC+T7E+Kp0OSdyVC87VMzPWXQ43fLLgWl+hQg+oCE9uY9e5pNGpDPvu
 7sRWhZ98
 RoE8ET8bFuSRjEz2nnvtYBUR4t+YHzm9xSGBByKL7qkPyod5t45/norbpKIvWjiFmeyEtWV9wP1iJ44lDkWScCGH7Ln+Aj+a/CL9I4dPLsn2Uw21xEertP+LrHsQ6T9jI7WEJkIhGHdxiXA+n4qE54TvM/gJGhpBR/nPfPDqwFuFqSku/wBck7PB9fGY6anbQdPhcmPCwXEnESOueXzhsSVi6xvPEJ489PKul0ziRMi4MCx/sI08397vYP4SqzmZ8E/DGqVZBd3Z0Kc1ffRmXu7GZLSJi/kaT9doms1wVvKSxDU9GkPxdwPdCnq/0Ma3Y7g0Hk9zEQEkjPDwpVFnM6iBzXmC3d/qPhEwpxD2M/DvvmoDhSSQTaIMMCPfmN/eP6Ulsh1XljCR7VEbWUQIYVxIi5KXVGRdUAlVe93dNZji2beyK1cyd6ZFj2zon2jxrE8BfMEthk9xDxHlDsLXfHKsOW19V3wlJVMYGlnQ7QNjCESThOMecVDbAoQape3h7l6QBWSmkC3NoPVHD2nuM8bZVb5gMX1RAkQpEo5c3+VAFPrgJOyrFihiDnYrdvNfBhlcdo/X6DdaIrhBdahAr407pmq8fJzeKo+94ZMcwtVL/xkTMED59ttWdeI6KjPuDEjjJkBS7CtY50PEvj9t/G+yuiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 22 Sep 2026 17:45:14 +0900 Dominique Martinet <asmadeus@codewreck.org> wrote:

> (+Nguyen in Cc as he tried resending sloppy patches after this)
> 
> Andrew Morton wrote on Sat, Sep 19, 2026 at 03:14:51AM -0700:
> > > WARNING: mm/page_alloc.c:5340 at alloc_order_allowed mm/page_alloc.c:5340 [inline], CPU#0: syz.1.357/7872
> > > WARNING: mm/page_alloc.c:5340 at __alloc_frozen_pages_noprof+0x2137/0x3300 mm/page_alloc.c:5397, CPU#0: syz.1.357/7872
> > 
> > Thanks.  Caused by an old v9fs bug.  A fix was proposed but never merged:
> > https://lists.openwall.net/linux-kernel/2024/02/02/806?utm_source=chatgpt.com
> 
> Right, we've been going in circle with this since forever, and nobody
> answered Christian Schoenebeck's question[1] about what the limit should
> be, and while I don't care much ultimately I sort of agree with him
> (e.g. limit should be XATTR_SIZE_MAX for anything that the VFS layer
> touches, but acl are converted within the 9p subsystem and could be
> arbitrarily large so status quo of a KMALLOC_MAX_SIZE limit because they
> could come from something else)
> 
> Andrew, if you have an opinion on whether we should cap the acl sizes
> anyway, please say...

whome.  Well, if the converted ACLs can be large and it's hard to
figure out how large then yes, some pre-canned limit is difficult.  So
it's OK to leave the decision up to kmalloc() and just put a (nicely
commented!) __GFP_NOWARN in there.

otoh, if we're permitting workloads to trigger a large number of large
allocations then that might be a problem from a utilization or even DoS
point of view.


