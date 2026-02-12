Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAAEAEDF057
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 08:32:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 164996B008C; Thu, 12 Feb 2026 03:32:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13C546B0092; Thu, 12 Feb 2026 03:32:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03ACF6B0093; Thu, 12 Feb 2026 03:32:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E62136B008C
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 03:32:29 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8D597BA5F5
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 08:32:29 +0000 (UTC)
X-FDA: 84435138018.04.39D592E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 01679180004
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 08:32:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fwK27tqk;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770885148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tNUsWY0pSRjtqBtuT35P0+rj4sL140R5Mi2Tb/RoNdA=;
	b=yzi8ZvDzEB0SdusAK78FrD5Yeceunppqw1H72k4i4jnoEXFPFhXjv3HQeCwEaVDG+6oPYk
	MQ62hdMOcKKC16XkYKCMzg3wce5wUH7nGDiNopF3WNHWRo8MdLjYPrxvq54ZBkELQej870
	nwSzoRC4TEMHceGeuKr+yygOzu6zx/Q=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fwK27tqk;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770885148; a=rsa-sha256;
	cv=none;
	b=qL82HS9PHpnL+CEB7tQCKMS6ardrT0WnDMwq/zq+1U44dnXdoxcmxQkNONLKelUQqvaw1j
	VLETfXvdvSIjlkXRc5Qlrf55/3nqOL1Nqwq5YQu+/Rbudv5jUY2UWGEIGS3z65sR8OGb4z
	geFx4QJEJxKv90pv+ZkjpRLGaWKTGLw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6DD5260146;
	Thu, 12 Feb 2026 08:32:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACDF6C4CEF7;
	Thu, 12 Feb 2026 08:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770885147;
	bh=OWrJGgRpkgcwQTK2nv0DrDDpxOSvcGRxA+jICSBwnvE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fwK27tqkjGm4NaxvoxTtkIIZyltPbCMSDbaMEH6zmLpzD8Y6TJIfuFxjqCv4i+3zG
	 mHk46FkLOwdWg2BHhKMStXaILJUBV79jwwgXdIGtCyljh/qmjN8JS03AbW1TsPvL1i
	 Xqn6LtB3u0O3tsOGUX7bzvKEC+MY1zV+vt1D+2uoHAx5W4SxT62OHlZlsSXN/2nZhh
	 W3iioJWs5OtwY3qVII0S/rNvCeQsNvGRKscz7q72STpctfIyIHps5ydtQFXIXsPeeV
	 jHuT77U7O4VLmhLFQDOhA+1Ix4t+d+/wG2yDow6ToUwb2ScQnCyA2NEzm3Ne2DtQvX
	 7WYchcTBKfmTg==
Date: Thu, 12 Feb 2026 10:32:18 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Tianyou Li <tianyou.li@intel.com>, Oscar Salvador <osalvador@suse.de>,
	Wei Yang <richard.weiyang@gmail.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	Yong Hu <yong.hu@intel.com>, Nanhai Zou <nanhai.zou@intel.com>,
	Yuan Liu <yuan1.liu@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>,
	Pan Deng <pan.deng@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 2/2] mm/memory hotplug/unplug: Optimize
 zone->contiguous update when changes pfn range
Message-ID: <aY2QEr-iYBukIkB-@kernel.org>
References: <20260130163756.2674225-1-tianyou.li@intel.com>
 <20260130163756.2674225-3-tianyou.li@intel.com>
 <3cb317fa-abe0-4946-9f00-da00bade2def@kernel.org>
 <aYjmcZ4hg9bNbmiY@kernel.org>
 <6ea2dbce-c919-49d6-b2cb-255a565a94e0@kernel.org>
 <2cb55d76-4da7-4ebe-b23b-0abbc4d963f3@kernel.org>
 <aYsaBkMecDG595Xg@kernel.org>
 <b3777d0e-0b25-45bc-b387-e67fe5a0d328@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3777d0e-0b25-45bc-b387-e67fe5a0d328@kernel.org>
X-Stat-Signature: 9pgz11ju7fhajigxkyzs6uwcfgwt451g
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 01679180004
X-HE-Tag: 1770885147-163386
X-HE-Meta: U2FsdGVkX185ACiL8/OtOe+xDTV23b9qquioIp5IQ3SubIeiyEdMaq54XdU/N6WsWJ3aHXJ7rjDu8KAKoPv5nydFz2A8FswCRvd01HyUB/xGnL7Twtqfg19BiyqcU0sL+dR9alSB3dnlnbes6/LKP8Sa/pwvED45cyU8c5MM3WX81xfML2R9OKyXuBrt/Caj2Wbw1TeMpZXiSaLOwEzI4G5aG00LT5HdsKB6Y9/KhVz02FIBTmeiVNXvmME50GJyPpzHCbsA9Z56tbK+ADq/syFYuwgasE9o8Ys8WpVVsuEs8aylhW72t/ZesFgYh9AAOCJGGyH1E82LpHt6FYx/p9Q2A9MOTuE/vKM014BQlP3SAeZ9cKaDmhylqQy92WPc9hoMVmVppfCN4AioYcpdzi4QqgQ4pWI4Etdh0J7m5T7xx23fuwWNMI4zKIsZ4qLHrYEUBui2bZSrWCq2PagXJyZxkMnSl3s0Fi+ajFI3byimdIOucaTkq39P/H6TTv9ykMSOcuAz+29Oi/iElVaoC7Q3Jqhf5GNbydOgzrwaMRi/Cbd/kQVVDjQzJzE7/PjVweBsnbM2Up1l9pKU2Q0U2DqoiqLYUI1T12zvZKtC0PLBEeLh30nSqvzBeRSSA1nLPDS+rVYUjxv4g8PeF4wCv7SVd7D1nSH11yEPNiFbTlE4hvTc7KfGsBVktJqOjXauvZjSE8VuaGORXb5/W2kZdc+Bq0s/bo0QJrgH3HBNdPW2iPPpMIVdknSGQHUS4JPBNzrUeoYW6calvRH+UwEj/0BFY4SMDcCq18gUtZmfyNSQ0OL1c/dwj6gC2I19cXQZqoEzCuDbMEBKig/+ALY7IwXTzjelzSleyEULSh8LKu0Fdn+8CLECMs93eodeMejjujxCeDVnJEyM35+C/0lKi+bx5we+DbbIp0Yso0w8u7RFnOoaFea6xqMJbxRjLyCZBHLbiCgxP9FMOEp3cr2
 q78NbcOU
 Aq/+WtBZ0xAIYK3NkamCK6XEsaYezq+8NqUI/oz58pF/vd2jus3mL0l6wxEPNUB+qffCzADnNOUituPM2P6fHyZDdYnDoqFICx5/SsVNoCGhOAs870ygoKU0sHkFTJFYB05OCimyvVmRIw8xK+bc2cDvZg/mxB73fAarP0PvLsNgtZPeN+xMqsMiEfHK/ywQyx7lC25jQkZwAWjidM3Hrgq7e39sTw6KRra+E4vhf45MWFjaxSHQIeG8T4Y6AeMEyvLSSal7PnfaofU8HXXZKZxhrz7kfV1+8b1PYcKbL00OqxzvfC/p/8MPqHpY8eO8DdVQ6kVg6jPg5ERI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 01:19:56PM +0100, David Hildenbrand (Arm) wrote:
> > >   	 *
> > > +	 * online_pages is pages within the zone that have an online memmap.
> > > +	 * online_pages include present pages and memory holes that have a
> > > +	 * memmap. When spanned_pages == online_pages, pfn_to_page() can be
> > > +	 * performed without further checks on any pfn within the zone span.
> > 
> > Maybe pages_with_memmap? It would stand off from managed, spanned and
> > present, but it's clearer than online IMHO.
> 
> offline pages also have a memmap, but that should not be touched as it might
> contain garbage. So it's a bit more tricky :)

Naming is hard :) 
But I still think mentioning memmap there is useful :)
 
> Looking at set_zone_contiguous(), __pageblock_pfn_to_page() takes care of a
> weird case where the end of a zone falls into the middle of a pageblock.
> 
> I am not even sure if that is possible

It's possible if a pageblock crosses node boundary. We also might add
VM_BUG_ON(pageblock_crosses_nodes(), "FIX YOUR FIRMWARE!") there ;-)

> but we could handle that easily in pageblock_pfn_to_page() by checking
> the requested range against the zone spanned range.

Agree.
 
> Then the semantics "zone->online_pages" would be less weird and more closely
> resemble "pages with online memmap".
> 
> init_unavailable_range() might indeed do the trick!
> 
> @Tianyou, can you explore that direction? I know, your PTO is coming up.
> 
> -- 
> Cheers,
> 
> David

-- 
Sincerely yours,
Mike.

