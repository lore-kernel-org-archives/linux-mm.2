Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20A84C98318
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 01:00:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54B656B0088; Thu, 24 Sep 2026 21:00:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AE3C6B008A; Thu, 24 Sep 2026 21:00:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3275B6B008C; Thu, 24 Sep 2026 21:00:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 04AE66B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 21:00:43 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8E32C1A04E0
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 01:00:43 +0000 (UTC)
X-FDA: 85250479566.05.C400C5A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id CB3682000A
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 01:00:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XAnXNKC6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790298041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zGt/QJuXYmz1FRSRmOhHZebQauxVGaioH05IWjWbi8s=;
	b=hYtBW+t2CWx/bNMuKOaA026lnqZx2N04rOejqDotNMyJ+fZG+Fbt7hVW+YfaU9U9MMo4jV
	95M+IQrqkXhOXD/HqOq1cwhx/vsYzeAzrZN0MP6k+hi1UWsPPVG72lnftJZPlhlpCceDef
	xKG4txcq6UyXbpY25+B74XaLeHVPa1w=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XAnXNKC6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790298041;
	b=kGvn/Qu4FC76NO6KTKDREvqoB440xtVco1RHLnQPqDGA6ITXM7LEhVT3aLxhCfhHf9kMad
	KQNPAvvrFmt7y1M5CcQPv3X7cMWyzEAyz39/6H9BzAhLYTZDYhUP46ruoV5WEZdmHjqe+0
	KiOrwKSiBAYydsZbYiJi3SafXvjwizA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DE02340752;
	Fri, 25 Sep 2026 01:00:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4461F00893;
	Fri, 25 Sep 2026 01:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790298040;
	bh=zGt/QJuXYmz1FRSRmOhHZebQauxVGaioH05IWjWbi8s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XAnXNKC6Zq14Zt9SIfzI3L/LSHhEAIyJeHjMuS1eXzEsLIzj8XfD7kokWyb1Lmcb6
	 3AWiUliSPoDFnB0+Ua835jlZLlOKe25jr/hdD6kjvn0KrmvRmbTFjndr7vCr25B9ru
	 n0QUHaMAYbygcI0Gzk8d36sT0tQtZSLIWfQbYKW2LNjMRV24rR5m+FtW4DeHqxH9ur
	 b1KXStABsK2Jd94K2FSpZGdf+6JtIYjxEll9DE369uKn70zH9xmF0VmuWdE65t/6Va
	 BDqwwU9TwG8JflV1zb+zOe5ef9gORRPElIM38D+9zZo84DKypA5Q7eD8pgdPujiTuH
	 KXKExAE2P2f0A==
Date: Thu, 24 Sep 2026 18:00:40 -0700
From: Kees Cook <kees@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	Pedro Falcato <pfalcato@suse.de>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	linux-hardening@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jason Xing <kerneljasonxing@gmail.com>,
	=?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Willem de Bruijn <willemb@google.com>, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH v4 2/7] mm/slab: Give bucket caches the alignment of the
 caches they mirror
Message-ID: <202609241759.28EC6970@keescook>
References: <20260921075811.too.775-kees@kernel.org>
 <20260921075820.1718334-2-kees@kernel.org>
 <arEdcaJz4i5HP26a@thinkstation>
 <202609211620.342AAA61@keescook>
 <arViR2Miz61-3fV4@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arViR2Miz61-3fV4@thinkstation>
X-Rspamd-Queue-Id: CB3682000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 7w6wxzx5kbhg49cqokqtmwohbdks3fsh
X-HE-Tag: 1790298041-131014
X-HE-Meta: U2FsdGVkX1/4zG5vtbsnuIsU/lYJswKRf3g/jGKvH+Q+3J6SXo/Eex9+Ef9PIw/RNc26DRs6BO1vRN5nMy7452ORRsRjxEB3XPsL8pHVpDgPMHytXUhbJAIvefHpzdKZX58nVhoXfej3YxFA5Az2N9bwF1mJYr4qy8w3YocaA+rhYcLCys6ujBJ+jMJeP5xnVGoeLU7DeXgAvQIOypJXyhIl1y+5ojCWaYQvI1WFqcSh3f+ba9Mlrjvc0ZSyGLS9SU0pvr15fJrz2yTIMn/4/EOt5gjiSi7YiBnoEI+Adf0eYiEoGtGfsSBqJgxzceVmToO4jFe+UdMGxXuXDI4rtkYWufBigZKhVCp7mMq92mdNFbibPrV4fwMSDmGViitvOx18q5ECEreCXS8VeQqDuAayvmSTUND5zrylTliT9dskBgxr1PWXbrLfJ6T4tHIdf+PjJTCqr0vIywlFvXZlopnQUuPeWlVwskXy1+CyH1PgQ3CV9UhpMqMLl9MhI3u+dPBqi02g4dIuYqpIx89285ufhajb9Uj3D6gx3jyIrK4/YAhb9+479Y6llR4iHOxu4U8M+aNG36C7FUuYZJmAKEzTmBM/L2WwFDl5A9oickyJ8n0DVEiIozaNCU2tXFv7Ss3CPrw6EjVMEJGMjskEkQosS6FSxQ/ECw3dDZEeJNufFbZEZhFoyUWrcbzzDQ9exUznkXy8gM6p+232Sou9SWoJMDhEuqbJIv/bvLFmeTBw6m3MTKcgOmlogJDawMCEOsOw6fwO59OEup8c+qei/8TNQepMnF+oj5nhyi317nHzt7qBpCQUvekGp/rFxjIBmD4z0eZO9mgQG484G7WnPsCNXFQrVk4/hUxApf8vlWvsSr9yLRuUu1QRITFHHNKb43Tr+7DkPcLGBa3xLxEifmC0q1LVWNtpdjWFZa+vDZipuT6a4strVPSPW9mEEjXsX0l0TdwDkejy9hO9FgO
 0LOOqOAb
 QRRz9Ml5pKtakh1jURLzscEuOO4q0XyxLJ+gEzg/eX8pLFU/+zxTPoCaGLNuilkC8skr1Rv2gW+GhW3c7fNQCGv0MHKhLcdgIPNlFFzU7A89Xy7aOV/D6SWEhhArl7t/+91PeolSRv321obdFf16Qktlw4c70gSvxRGmWTBOVj5qTl3dEs366U3eXrZl3A4D51N2HX34jBSslCdhOGkyp6MDV2VG6dO5wn74zuOt90HqLiqkASKMDWk0ihAjgr2hNyw17
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 07:22:58PM +0100, Harry Yoo wrote:
> On Mon, Sep 21, 2026 at 04:25:25PM -0700, Kees Cook wrote:
> > On Mon, Sep 21, 2026 at 02:17:21PM +0100, Harry Yoo wrote:
> > > On Mon, Sep 21, 2026 at 12:58:13AM -0700, Kees Cook wrote:
> > > >  			if (WARN_ON(!cache_name))
> > > >  				goto fail;
> > > >  			(*b)[aligned_idx] = kmem_cache_create_usercopy(cache_name, size,
> > > > -					0, flags, cache_useroffset,
> > > > +					kmalloc_caches[KMALLOC_NORMAL][idx]->align,
> > > > +					flags, cache_useroffset,
> > > >  					cache_usersize, ctor);
> > > >  			kfree(cache_name);
> > > >  			if (WARN_ON(!(*b)[aligned_idx]))
> > 
> > It looks "obviously correct", but I probably failed to correctly
> > describe it. I'm happy to do whatever here.
> 
> That is correct, but is there any reason why kmem_buckets users should
> not specify their own alignment requirement and inherit the alignment
> from kmalloc?
> 
> For DMA yeah it might be confusing for every user to figure out that
> the alignment should be __kmalloc_minalign(), but otherwise there isn't
> really a good enough reason to inherit the alignment from kmalloc, no?

Oh, so you mean explicitly add an alignment arg to kmem_buckets_create()?
And perhaps if _that_ one is "0" we can fallback to whatever
kmalloc_caches uses?

-- 
Kees Cook

