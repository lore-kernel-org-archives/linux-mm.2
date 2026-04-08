Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EA88FD5F80
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 06:30:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 394586B0088; Wed,  8 Apr 2026 02:30:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31DF66B0089; Wed,  8 Apr 2026 02:30:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20CC86B008A; Wed,  8 Apr 2026 02:30:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0B3516B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 02:30:03 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 97C8EC3099
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 06:30:02 +0000 (UTC)
X-FDA: 84634413444.18.985DFD2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0A946140003
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 06:30:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c9Dp0WlO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775629801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mpjfdzD5bedx9XSSguRL5PftLWr50qCZ4XwgByViAHk=;
	b=fjxRtnZVvZhtlRVAqDIT3xgfMD7wvWe0CWXoYEgrR2PsalpS8eNwWs0vZAKscMMLMmBixa
	dXfAZnMCcBPaP/wDVD2JoOfeqQ1WkH5vN0MmDuAxSZodqHkhRTwatSRZuvR5xfwtec+DmH
	lcPUwO01a2BcTN8wNGewAamTjAvEXZU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775629801; a=rsa-sha256;
	cv=none;
	b=5vYXRJdrcmeYYpR1zomBrurTqk4g1ssNIX9eOgieZ08+5uXcU4p02wc2gGp4IjA+PIyHf3
	Re3AEESTY+uEb3wVZwfLwkq2b2FNkbQZVzUfoHGg2JevXE5TVph/B1pChAQXfMdG5cnlvJ
	rBkmFA8/igVNdrAe8zJ/OiqZns/3hjI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c9Dp0WlO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3146E60128;
	Wed,  8 Apr 2026 06:30:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E8DCC19425;
	Wed,  8 Apr 2026 06:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775629799;
	bh=ovbUEOVjJO64+CfNHS3rFZZC8A0ewJiMcBpdXhlNrS8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c9Dp0WlO0O9Ngp1mzaFP1ikpqJfn2/KNRZpSjEil7gT7ayajSd1vQijyYAKVJLx8f
	 KLfsDOELg0wHJKIz7fYGnwGm/1NNDjEqp1iUvNhCsakaE9KEfYm0evdvdEU9pGM/5Y
	 GJSKQghniPmjhEnCSOVAaIRKf1VMQdeHvwzacicq+N2USAnSP3kWM9FA5siW/D2Wj3
	 4B+ovkrAo9hnQZHGF1yQnd5mypogkWVXvByUeqsgY3NDlknraq/sgBdjLW2fseczcg
	 suBYcoO8pnUfObxCK6iHsZcRH9aVKzSl0I5Z0AqLB3rzZXivBNAMjxsTIsk/UsT/6E
	 wQEq7xOHmXnlQ==
Date: Wed, 8 Apr 2026 07:29:55 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, xu.xin16@zte.com.cn, david@kernel.org, 
	chengming.zhou@linux.dev, wang.yaxin@zte.com.cn, yang.yang29@zte.com.cn, 
	Michel Lespinasse <michel@lespinasse.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] ksm: Optimize rmap_walk_ksm by passing a suitable
 address range
Message-ID: <adX1qd6yDCeUhmI5@lucifer>
References: <20260212193045556CbzCX8p9gDu73tQ2nvHEI@zte.com.cn>
 <02e1b8df-d568-8cbb-b8f6-46d5476d9d75@google.com>
 <20260405140132.3a518740c6c1d68843f44aaf@linux-foundation.org>
 <adTRPwNMzogT1OYO@lucifer>
 <20260407142142.cd093ccafe62eaaadb5cf11c@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260407142142.cd093ccafe62eaaadb5cf11c@linux-foundation.org>
X-Rspamd-Queue-Id: 0A946140003
X-Stat-Signature: z1oytj1chjtz9hpb6a1cgectpedbaao8
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775629800-72160
X-HE-Meta: U2FsdGVkX1+FhwcxN6VtxQPYP01BRO+iGvMRQtShWq4rox/TpubqPwgpncLaf+IlOThGxT7QSlnb81BBcaM7K/aPbQT+OrbixyejuJb5f3VKMHiYskhePkafkGX2u0CH163meNTxtajSgzzbA8Vq5gPzWatCzV5zf8qvf9oDL6vt5FFezIBl+fO+26wrkp8+KcO581oiSe4mKOY8MXBEHFFsZ16wQK6BM40dujMyQdF33/Uiri6a+6LGFL8Eg6r9glBH16TS8AazSl7+b9EaFRBv5QcqfhFKzLdil2MSjlpTQC6hqtPxmfEGsbBlvyxEhn0Wi2F5XIRy6y+g276HGD0hMpZDGYcf8MvnDU62j/k+ipFN3KTluOD3RiL2TyQH7TBnIdMzv38JXF+4OEuJPSx4+4Ab0svvNesQryycMvI7k3OoRCmsl2Gx6mAL0/wE5G5jliKvhFrdCBoiiZcixiataYcxyhqt3dVhDEVcKOZdS0keIxs3zOJwH5Eo/23tKG2zhkrjUsYWMiuGi4O6yM3y3EGUGuQvEAvoITW2Ffs/mMCzeNcS5RHLl95rIeM4FMeJYqDQ+M+DhNwAuvbckLu2T2rkbAawxYWiejbtYYLQE4px/AHMA5WDd0fbL4qAOPeIjE0pGE4/+x4aGq0AtA7ld5HudX5+3yAQdLrt31/c+QksLc5SSPZ15J+bqjzoe9c16JOrpqRtPmFm1UAATdRyJy36n+NdjTBQYQCqhx3UbnDIqw4tDgmicyizO2I5JxnavMTApu3inAJfx4ONxVFwM0BsdfThxBqgq1fUpfe7/iSs5sfRWuw49VBs493+iY1glq+NLnErJnI78I75oOXUHTlwR73y7JqSrvDMLXMzTOjuf1g6k9BDmKUcowwXt38+d2K6cSw3/UGNrJSQOxMb3cdWSlwxm7akKmqGhugBQSwjo+YApOJpJK/cP+X8HfYEiY5Iz/2lPOcGW7I
 weFTuKb4
 3xL4KTsraSTNILiV6xn4A9J2G4n6RoteL1IWy1BLSjiXGZZeBsYd3B0xhIrM7GfgTzypwyGaiD4tb///PVd3m++SCw15mXqZQ3og+i5KpoA8GAQ0q5cBxGn0BRVQ71woLaBkeqTk00Zr0dPTNOGteUv1LtsieBOG3uSKvwljy+zYqEaJlotBbMahM1ugdZAXRPOwptAqbGoKTP/b+q7OvOKx18nR8bspxZVWOziAhdjBeYwhaL28TmK88G45F4dB192CBnd4z8g0RJV6sNOFtsBf34DuIJnwAP2qbLg2X8705xLCBnky/oRvK/FlMqjvOYzy6kjOdLBUbrPpeof2GIGnrf3Pe53Yei4LMKXHtTona6hBQSPtPobKxi5Tx6+yENZZ8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 07, 2026 at 02:21:42PM -0700, Andrew Morton wrote:
> On Tue, 7 Apr 2026 10:43:12 +0100 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
>
> > > Thanks, Hugh.   Administreevia:
> > >
> > > I've removed this patch from the mm-stable branch and I reworked its
> > > [1/2] "ksm: initialize the addr only once in rmap_walk_ksm" to be
> > > presented as a singleton patch.
> > >
> > > For now I've restaged this patch ("ksm: optimize rmap_walk_ksm by
> > > passing a suitable address range") at the tail of the mm-unstable
> > > branch and I'll enter wait-and-see mode.
> > >
> >
> > Given we're at -rc7 now, I think we should delay this patch until 7.2, unless
> > I'm much mistaken wrt Hugh's concerns.
> >
> > I'm concerned this is a subtle way of breaking things so we really want to be
> > confident.
> >
> > We should also bundle up the test at
> > https://lore.kernel.org/all/20260407140805858ViqJKFhfmYSfq0FynsaEY@zte.com.cn/
> > with this patch (should we find it's ok) as a separate series.
> >
> > Really overall I think safest to yank until 7.2 honestly.
>
> OK.  But let's not lose sight of those potential efficiency gains:
>
>          Time_ms      Nr_iteration_total    Skip_addr_out_of_range   Skip_mm_mismatch
> Before:  228.65       22169                 22168                    0
> After :   0.396        3                     0                       2
>

Yes, sure. We could possibly achieve similar by doing a quick search first then
trying the broader search as suggested by Hugh?

But want to make sure correctness is there!

Thanks, Lorenzo

