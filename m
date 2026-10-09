Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97687CA6012
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 06:36:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 936ED6B00A0; Fri,  9 Oct 2026 02:36:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E7326B00A2; Fri,  9 Oct 2026 02:36:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D6516B00A1; Fri,  9 Oct 2026 02:36:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5154F6B009F
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 02:36:13 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BD90840252
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 06:36:12 +0000 (UTC)
X-FDA: 85302128184.23.6D66F22
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3B7EE40003
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 06:36:11 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="adm/PXte";
	spf=pass (imf27.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791527771;
	b=0JOAH56NIqEmnoWq3tf4EYvApkgid8zknOaDZCt0SGrMerQLgJPq5mTTLfdspA5FRb8Edq
	7DDHqaDdQYiBj76C27J/BskPr+6jE1jQO51WHcBk0UtCqPR+bZLwYKtiWzIMYAcK3vlCCq
	oaust4ZIyvrMna9bTeEmvgPb7ZpZOMg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="adm/PXte";
	spf=pass (imf27.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791527771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gDpTPyFrfxPK/Uf/lFR6lzmG1KtMFb1k0z6iyA57/Qk=;
	b=VTChfge1AdyBy6EBXzViz+pMPY+HN1QXlCJ9OFJur9rdaM8VmqAIUagrpkqcAzllyMjSFL
	5viZ/T/P/opQUcts3YZAu30cKIOeFZUieW0qxetM1N1cymFVIJR5uAJPncEes1YqVAF6Wy
	2EKj+IBDr36/sBpzHVVJ4sPs1roE9Y0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3458741824;
	Fri,  9 Oct 2026 06:36:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E7D51F000FF;
	Fri,  9 Oct 2026 06:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791527770;
	bh=gDpTPyFrfxPK/Uf/lFR6lzmG1KtMFb1k0z6iyA57/Qk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=adm/PXteCoY9Ji6saNhj4L6Dqguia+KG2/3Nr+/ar0UHgfEYUz2BGq6wjJLDGi6F3
	 liU8vicxy2gTOqC4yZ0W5OeGkkJJC0uPn5qOX1/HqutbBsxs3TigwAPxmIwOJzmQ6t
	 nJ9Sn5WzLPXhkmfTQBgZ7He7WVdlb0idBiQIE27jcKbGTZ9QE5yYOtgsUds+hBZGoK
	 bGoPuCSWqujD6cXwPoHslFO++VzLMCWxK29x5mF0jrnvRXkWgGGVihOsEr+E4lhcXg
	 76j+4XTX5LIPQ0B539LHeDrjQVMAD9e+yoPSzyE0uAxVqGBjuhgxQ2a9XcsGNk7BLn
	 iGbpxQ869yG5w==
Date: Thu, 8 Oct 2026 23:36:09 -0700
From: Kees Cook <kees@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Pedro Falcato <pfalcato@suse.de>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>, cgroups@vger.kernel.org,
	netdev@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH net-next v6 0/8] net: skb: isolate skb data area
 allocations into a separate bucket
Message-ID: <202610082331.853F0CBBA@keescook>
References: <20261006092030.got.500-kees@kernel.org>
 <asgAh4mrr_yd622U@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asgAh4mrr_yd622U@thinkpad>
X-Stat-Signature: xcir9daxhmdjoncs7c4i66xd9wo856ph
X-Rspamd-Queue-Id: 3B7EE40003
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791527771-810254
X-HE-Meta: U2FsdGVkX19FBGGs7n6K/Pm9bvmskAwNIAk2Rc9p9wIwNgIxy3D6bnSTPoh11QB2at7eP+lI/MuA1wAr8Q5l3wNwvO4EAsXd42fTAEQiC8EmRSibdcGjM/GL8krbegKTxBDBSyanUPfqo1eOhjCp1vp8Qac6zr2fKvIQYBu1kfO3PngCKKH0p+OBZI/OWoSzvdyxPVdAaHXwx3yq2uaFBaJaJ3IXE73K0lp2jpMZD6YsmdK98oj9lU8tYVw8lgi7BrS/cl0abNxu7GlDqFTxPx1dSoCRo/zW4IHO/Who1CU+IjHd+yCdFeoN9vjVFlS4N6FDM6ktEpoxSmMPuk0MMlztzOlAVmfZ1Dvs+2LfSjvUOkQr6XtQr5buxFhOlZbV7wd72yqPWjfsKDEiSmmgWAQTyd7b+XuP9ZR5Ctuz/dcuL86vjMUZOK5hsHz8PalcBCel/13qZfcfVAF4QNUwW458Vr3GxxiZq4dBY/3fUFn5zy3OVZd1f488E0HvnYkRJQ6Z0g+oN6cP2wHhw8D7iAOJs4/YeAuYnxSeBg0h05gkwtwTQ2zy2pA6XclJ0JbcZlVICJatRsudwDexIuzn6/O+XjOwF9Vnxqzi4mvpjlDAMPdpzqiCm/DK4mKYufd0DFs2m+starl4YkJpl0LRaIpoy7CozJ942xBAdJS/1xV2b/KT1RjH30hJub9rIUyk0Y9iypRC6DoDMOIvgEfVJOGoNdnKJwqNvK7ptt4jFLm7B7t2Qxfj5h0EC6nX95+W+e2D/SrdlEKbgfhUykn1fVE/uUkE8fFmm1bSUHmMV9piam1q09+tJI9eguTDm8/9hOKOn303ZyZRKcxHbJhlzWzuEPatOKkCbPLA+HEXPpFC+0BWrVcw8HLyrkAC/sch1vODdai9hpGTnrd/vycxLJVfFulItllou6tgm7JpebPfOC4R9OI7qjHQ86Nft9XvNARu7PBflLi/BTNhGmT
 tL3UlCLb
 ONzvcpdFmxEfehp+l/ojjTj12/KX9MZ7L+4my+RV2ZjMZuMnvO+gzocj9Q/QU+FH+veH1W/R3jHxZ73TUWHq37UsCfW7/sEKRAHsbd6QoJHdTocmHa70oTWlPzVaTAhHLtfHnlXKHf54p25caPkGiZ+p7aXO58kOrWD/ic9CUSmdBoHsr/uVKw/g4z1VakHlL4lyINcKRbYmvyvIYNR1GdElaT19vQUPi5HuJVtUK0gk/0LJA8WHrehwuQfqYQ6x15l1i
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 08, 2026 at 11:25:13PM +0200, Harry Yoo wrote:
> On Tue, Oct 06, 2026 at 02:20:26AM -0700, Kees Cook wrote:
> > Hi!
> 
> Hi Kees!
> 
> Was hoping to say hi to you at LPC but I missed the chance ;)
> Maybe next time. Safe travels!

Hi! Yes, I kept trying to find you and Vlastimil but it never worked out.
LPC is a non-stop hallway track usually. :) I will try again next year!

> > So v6 goes back to mirroring the kmalloc cache's alignment,
> 
> I might be missing something, but why is that a problem?
> 
> For kmem_buckets users, the reason* to specify alignment is because
> they might need less strict alignment than kmalloc.
> 
> (*Perhaps it's nice to document that in the comment)
> 
> However, because kmem_buckets can fall back to kmalloc on e.g. kernels
> w/o CONFIG_SLAB_BUCKETS, it should be fine to fall back. No?
> 
> Creating kmem_buckets with more strict alignment than
> kmalloc doesn't make sense. 
> 
> > and drops the ctor and flags arguments for the same reason.
> 
> Uh, for ctor and flags, yes. We can't have them in kmem_buckets.

Yeah, and given that these two, I'd just prefer to keep it a direct
mirror for alignment too and not allow for any configurability here:
they are supposed to be direct stand-ins for the general cache.

> Going thorough slab/for-next sounds reasonable to me once it gets
> some reviews.

Thanks!

-Kees

-- 
Kees Cook

