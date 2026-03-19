Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4321E108E1E8
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 11:13:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75F966B047A; Thu, 19 Mar 2026 07:13:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7373F6B047C; Thu, 19 Mar 2026 07:13:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 674456B047D; Thu, 19 Mar 2026 07:13:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 56EF86B047A
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:13:08 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1B81D1A0494
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:13:08 +0000 (UTC)
X-FDA: 84562550856.20.A8D6F47
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8B8B21C0010
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:13:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oGEsB6fb;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773918786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4aGhCkvep3z4IGyK/eGTBo8Z0Wlsdk46Z7iUmouA25s=;
	b=Wp6KMUg8AikJbPslm9ozx9Mh4xr1jNxc5AGv62M8eiyl4jMfyHCo20VvjEMS6bDUJWytK2
	v8fRf50arRPk+lxdCbFh8ynS2D3/wh9pLXSz9DKt3P7zk4INLv+CNjTPYkjmkgU9X6lRjB
	eVcKC6Fswu7mXfp5GxhgmF303tf8bxc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773918786; a=rsa-sha256;
	cv=none;
	b=D4xCknADGnrd3z8LNRUOAEHYecHgIwSf+HlVVZlnRq+0kjcBIZO6g+c3b/Me+RTwUIpTFo
	Npo++od1pYkt+y79/E2VIXC/6g3nfxDvPar7gEuhK/Ob8QTO4QEX/bho650UL9iz31cuEo
	xxHb+6o/60pU2HvKyuEBo+At1pHi++c=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oGEsB6fb;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0530D60126;
	Thu, 19 Mar 2026 11:13:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AEB0C2BCAF;
	Thu, 19 Mar 2026 11:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773918785;
	bh=4aGhCkvep3z4IGyK/eGTBo8Z0Wlsdk46Z7iUmouA25s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oGEsB6fbV/dzhN37U1+RQ28sdVXA7PV+Jhd23VCCc+m5vRC4YFVWL63sjPl5Z83UT
	 sHcQuNkGTTugbpeJ6266kYcCVb8QGuK0LQEOzfsKwPsBtzNJWezcytbztyPa1gmuVU
	 FnTYCjFRtbID+jp/GOdlTRMdpbmi04RQdpjF1cgvAQI/zlwGyb5E4RzCzSY9j0DDDW
	 WbM3MsTVHumEgm9UduB1aKyeF1dvNhib7upT+Urp//4wdQ8tZC/Ycb7JeGBIi0bBGO
	 g2W2/yJ2QSAneLThgB8/4GckV6yVcR0IKiphUzjGSnK8jsFXBv4JxKClFa3r933o+e
	 eXabq9uB5ahtA==
Date: Thu, 19 Mar 2026 11:12:59 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>, 
	syzbot <syzbot+8961cb270ae74b4129fb@syzkaller.appspotmail.com>, willy@infradead.org, baolin.wang@linux.alibaba.com, 
	npache@redhat.com, linux-mm@kvack.org, baohua@kernel.org, ryan.roberts@arm.com, 
	syzkaller-bugs@googlegroups.com, dev.jain@arm.com, ziy@nvidia.com, linux-kernel@vger.kernel.org, 
	Liam.Howlett@oracle.com, akpm@linux-foundation.org
Subject: Re: [syzbot] [mm?] kernel BUG in collapse_scan_file
Message-ID: <024ed30f-db2d-403d-ad3a-3e74a55c6a4a@lucifer.local>
References: <69bba3c0.050a0220.227207.002b.GAE@google.com>
 <e92ca212-9ada-4cd0-8d54-2f433d6d47a1@linux.dev>
 <10e5f1d6-077d-4783-aa16-6c8b98cb9e74@lucifer.local>
 <c3defcfd-74f6-4e70-b002-85bdcba44df9@kernel.org>
 <b963c391-8576-4351-b121-67ab9a9b2a1e@linux.dev>
 <8ab10631-4672-4196-b32e-7c5a01707424@kernel.org>
 <ecedbb39-2df6-4300-99de-a56c7490c3d9@lucifer.local>
 <37b48d94-9576-4529-8576-d4ed615d4768@kernel.org>
 <b5e33e17-86ac-4587-903b-b277fe5b752e@lucifer.local>
 <5a4fc5ba-ab0b-4294-9577-9b5ee30b2c56@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a4fc5ba-ab0b-4294-9577-9b5ee30b2c56@kernel.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8B8B21C0010
X-Stat-Signature: ebpm8opdj39iqcir3u6upkfjqmcfkntz
X-Rspam-User: 
X-HE-Tag: 1773918786-32177
X-HE-Meta: U2FsdGVkX1/6oYp177GiV7QlpD82YzdSIh6rCVYQoX2DL8bgXwLA2XVZzUVEN6EpjSCN4zKZmUfggWsjTAGzEysz8MGDd4Vl+w5Bk06BncKpw6f8IhoZg4gH1mYYjdpRREkZcGNUOYGKuIhk8ncTbiFOZH5ZLLJ0Ob8PrlcR0RH9p9J6QnySsna/XRLx/sS1LiWS/1AJEeRAkorxQj0RTxwUNj04/LCfPdW5aLRDUdllya/kXhMeTvOpEr8s+DLOmcuI6QnF7forFbMPGMdvUWSWVQi9wFxD/YUA/uu1AG6PxCbQ/BvBAwP7DVdOxW6qslOVeLSBxrGIV1UsjD9Cq2uDpQyFPPUO4Ss9/2B0mdKhi6XpLdWo6VZjq+VYDP0N8Ol7r3ADXeo0vSN1no6Ilj2mcNs4PRCWOXD1hB6UbF2gV4QiR7Ar+MJgkECQhHZn0/eYG5R6GnHUSopCLGdMiDLxME6s8ptE0Bkw1Q0Qo8meg9XlwwkHhesAV46obh7WNLFsZRcPy9M4c0dxGXU1R5CLeQ840K7u2eKaAbB+gVZ53IldwvrAV4g/cPcyZM8pt09rihMDbLLsD8bDmdXZUpeXiQjGfbZOET38+W7fDehw8lfgFjPCCqYFK4FLkFgf6wn/+cLzUFThzJe1NNooozyoAobSEjaqYj1VB6V+KzC2HoJb7TrSDb4Nq/wk8g9wnVaeZ+GbJFj/8WVGxrkEDBybaF/IjJ4FQ3BLkP6x3sZGurgvlCdocFZO1v0TZ+l8zg0Nmw8Ro9VK2/wvre88aDPohx1fQ2oNEuutT04KlXJKFSLxSg9DEuXXsoRja7eLcGJpWhJjZ60wsQX9U6FsUbr6tMGCDMpo5l4ovsewyVov7IJNKk/hOEpjo6AHUwN7AFkWwrTg4726NR7R+rzqnQ79Syc7617q9Kzb7D0koZcJbQ3Cw7QcOf9GJAjbkDSXDSCUSI8+A4A14VVpz+O
 RuRjMgSM
 g4KIw7nAAcC6KtBSJyaBCA0hlfosO+XAnXWXEZndAiSGPkYjlcVGshCzg6q/LuVYQzugVgwg1bfm25lJ0k+T3nmlRegfc6339GrbWAlYR/GPrforitwhFQYXk+SbimpfblgQOiaamRDdEytsZq/7BK6NBpJ4KDZoOETXeXGgf6PyfkZuVaRqE61vL7MMZe12tf9cTkF8xLutAD5qhGvbh3Wrm+m94nUBR3G8oEqvG4liP8gscoxrpV80UD0A4qPp6z7L/9qN3Y4nn1iZQTEBxDM7+gLbZ6icKGS1Bu2hK6Ti+FCzjtpsrBsL1PweZVi9XLc4wmwm6rpDCYTXl6PKO1jVkXgt7Tq773lXygAjluzVMft6gSS3nKLKxHDdFjTaRNFrcQplbC6yGQTKGj75GgOQjKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 12:10:36PM +0100, David Hildenbrand (Arm) wrote:
> >> "This isn't the kind of thing where you can just jump in with a one line
> >> patch and actually be helpful, sorry."
> >
> >
> > Yup, so again really I don't think the kernel should take the xarray debug patch
> > until it is discussed and verified as correct on-list.
> >
> > See the discussion with Vlastimil.
>
> Agreed.
>
> >
> >>
> >> So I am clueless if there is a real problem there or whether it's just a
> >> false positive. And whether (if it's a real problem) the simple fix
> >> would actually be a good temporary fix ("make other bugs more likely").
> >>
> >> I can try finding some time to look into that, but pagecache code is not
> >> particularly the code I'm familiar with ...
> >
> > I don't think we should waste our time on it, willy's series should be yoinked
> > until it can prove itself for-sure well behaved.
>
> I hear you. At the same time it has the smell of "test case fails, so
> let's remove the test case" vibes.
>
> Well, arguable, it's worse than a test case that fails :(
>
> I'm fine with dropping that asap. At the same time, I hope we won't lose
> our reminder that something possibly bad is broken upstream.

I mean hopefully once we have a _working_ version of this it will get reflagged
again in any case.

The uncertainty makes this worse than a bug report unfortunately because it's a
maybe/maybe not and there's literally nothing we can do with that :(

>
> --
> Cheers,
>
> David

Thanks, Lorenzo

