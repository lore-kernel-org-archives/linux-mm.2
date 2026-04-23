Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEAD3FDEE4D
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 23:58:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C95E6B008A; Thu, 23 Apr 2026 19:58:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07A096B008C; Thu, 23 Apr 2026 19:58:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAB2F6B0092; Thu, 23 Apr 2026 19:58:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D6FB66B008A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 19:58:33 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9D7CE1B8511
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 23:58:33 +0000 (UTC)
X-FDA: 84691487706.24.6436ABD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id E62F8120009
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 23:58:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WYKb8Dqw;
	spf=pass (imf29.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776988712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+BXbTAM8txQm/amX+ogscsH/Pd8KELZZ45siFkZkOVg=;
	b=4cJ2w+U8+DZJg2SHHgeTU8G4tdADS6MBZplT+ujyZoZgRW4LwFJxJX0Pu02gvdP/eHs4Nv
	18fKtIHtadMSJ539CIu8vKZZY29OtHcpsAxl/Mjx6QMxm4j0Y9QULLf0d64yFGgSsvT4YQ
	R5LEDeex8gp7cWzZqTnKAPJqSw3K3w4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776988712; a=rsa-sha256;
	cv=none;
	b=RLc00RzmLzg3DDfD9COcEET93cOr7DakxAHPH72jB82bmPoMQSDi8kyyhmZaOtokAl474b
	1mh9r7RH7Oyrf7eWUl2BKQGyOfQ0WAV/ja0gDRefVHYn7xrbeGhOM6AfRTrRY6kjEPPnHJ
	3Jg+GkV/Ri1RVHgTRHddNPAznUfmVTI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WYKb8Dqw;
	spf=pass (imf29.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F12A843B71;
	Thu, 23 Apr 2026 23:58:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88191C2BCAF;
	Thu, 23 Apr 2026 23:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776988710;
	bh=/IDvk2X/nOzSmN3tu51oLrOY8xOBedWW+PR7mqnHCbE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WYKb8DqwYnLGFc398UDDvzV3m3BC53w0EdyaIz2Y88hcCR5wgrFpi5zzDxVAzEZYL
	 mkO+OUMMTA3/I2yMjX7t/cmfJacbNjiC2JFjwFmL4D6kF1v7GEmFW6ySDDUnZhumyv
	 gXnTqPC0kjQrfmn94OcOfIR9HbIvOAbxVPO3xR2SUPonWaPTiYwnTCRQ8soGWCYGbt
	 iHPsGohhV4NoA42tkbFfmSwJ2oLnnx7+NTGVFRaIvNXN2jUz13qPv3//DCrLjEl2mK
	 ABzKOsmvUEmPTIPQvb75hIlQhqP7oIUsoEIE3BuHeLJbTtPIepcpFG8cW4Z5TCbMOx
	 zke3XmP6EwMtw==
Date: Thu, 23 Apr 2026 16:58:29 -0700
From: Minchan Kim <minchan@kernel.org>
To: Michal Hocko <mhocko@suse.com>
Cc: akpm@linux-foundation.org, david@kernel.org, brauner@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com,
	timmurray@google.com
Subject: Re: [RFC 0/3]  mm: process_mrelease: expedited reclaim and auto-kill
 support
Message-ID: <aeqyJboSxs_wOsSH@google.com>
References: <20260413223948.556351-1-minchan@kernel.org>
 <ad3ldU4DZxga_J2L@tiehlicka>
 <ad6c0DN7AGoOQ_Iq@google.com>
 <ad9AXVYxWCkHmh6J@tiehlicka>
 <aeAeqoJ_acUAza8D@google.com>
 <aeCHvYOKP1exBBns@tiehlicka>
 <aeHRLv834FCAQlQ8@google.com>
 <aeHdGf7XDjvOES1V@tiehlicka>
 <aeagUxlju40rvkYQ@google.com>
 <aenPV9ewKAzRF2Vg@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aenPV9ewKAzRF2Vg@tiehlicka>
X-Rspamd-Queue-Id: E62F8120009
X-Rspamd-Server: rspam07
X-Stat-Signature: 5tgw8byogjcog9qnsfnfguoztjiyt7co
X-Rspam-User: 
X-HE-Tag: 1776988711-85412
X-HE-Meta: U2FsdGVkX1/u16B2I7OqZ/g7rVbvFdroOeGu1S08Gd9TW5cmdLtxA7+UWWBE0L43TxZIrlDXGYew6v39PnCVtod2xWS+t6R1BjAECFUaiZOzaU6OIaSQx/NApfx581GKET9YfgQNglx4SvNU+qV7f3LigI8R4o0NedEgTy9GB7rS4H7gFCQEUrdjn0IANBbZXg+kKJ2nWemZe9Mq4yoLbVSAcPevecf9LP+D4Ceh8ycNI76wZnj0P1PextIo9uUWhX5XT4tgn5fsKHF7CUSOd8+Eh+ZxeCEAF4DRyrUk4x+i9/ZNa1aCQZHsmODRjdIlJyUytFt0XlsFvytnf0YM2NvnjIplsWCbKZw2iadSO3ko3QIDFovnvPlzRDFdc2gQjOvm9p/PW5YMFmCTYmhVsn5eFQy5gbuZEQgifInZ921Z8VDBNkiT8C6gTjowK1Tx0eEpac6xOCFvTVBC85srlruL4ycPW/1zLkUpFj3mnfiUJCKUcuuyYW4RmJCrZsPF7i68jpJ03mQptgmiNZpozEUmyyB16RGvIPNZCl7RAy9Mb7CKF/zVZ8S7O8N01ix1bdmVWAmLZrOkZVgUUPhodcYLC/8kvcaAfd2Ch9Gi0Pudsgl3Fi8FlN+VxMhPAOOTWGCbYpwCcXsLj/4w+rFvGa33aeJAZKJnO5fqCPjgSrS6wYtUz0bXqHbwfhYWUrXWa1DFXqVFgXHDQm1AdHXCvYYv+1VxfJ1qCSVlKFGHvoE3sB3kPMXtFILWeFjJbK1VNyD3k/gGUHlzLgIiiu45zMjy7nAa8vgZaPOQxYD7a5mwLiEX2FsX+qZCtiXxx7hDUsaDugiUKUeY+a33d95uifv/WemOGjROmJT2j9KaeE9qgiJD1ai5RkWgcUnbvOcLnVwEuGj1T1uCh2jeFSzcLWd0VYqCR09LNkRiBHycn724v25B2OBecRPBd0LfdNCLeW4pLsh65stUVbV3nqB
 9g1nd5QA
 WjniaPGtZLu3bPA/Q46/ENZaN2JGkOtHejFLJScPfcKH31/m2RiYnT17d0cqNxKEtqb0n45MOyI/gkVKxtDJ91LbkGs8i3XFaUSmcOr3BUJOwQWjHplZ2gIsFSMW5/shuuQNOpr4976PNmPVieJ68DF8ebfNwvkJj+v9ZU/yelEvN5thKqQQHvtl4LVFlmPtd6e1Z0nMfgekwyPmuxCFuDcw79VSfJlQb+GVmQT/vNMb0lZJ8NM+XbMkGB9zmk6rCT8TS324MB3eu3iPcrvpFNp+zCChkom6WDLsg8olmP+pPDIPtUHUQVbVN/mPCmcD8r3a05v5AfQlD+2g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 09:50:47AM +0200, Michal Hocko wrote:
> On Mon 20-04-26 14:53:23, Minchan Kim wrote:
> > On Fri, Apr 17, 2026 at 09:11:21AM +0200, Michal Hocko wrote:
> [...]
> > > Yes. All which make sense, really. I am still not convinced about the
> > > clean page cache because that just seems like a hack to workaround wrong
> > > userspace oom heuristics.
> > 
> > I see it a bit differently. When paltform decides to kill a process
> > to free up memory, they want that memory back right away.
> > 
> > So it doesn't make much sense for the kernel to ignore that and leave the clean
> > file pages to be picked up slowly by kswapd later.
> > 
> > In some aspects, you can think of LMKD as a more specialized, userspace version
> > of kswapd. It has high-level knowledge of process priorities and knows exactly
> > which process is safe to kill to get memory instantly. The kernel's kswapd,
> > however, operates globally without this specific process-level awareness, which
> > makes it less suited for this kind of targeted reclamation.
> > 
> > If we force LMKD to rely on the slower global kswapd to actually free the clean
> > pages, it defeats the whole purpose of targeting a specific process.
> > 
> > So letting process_mrelease speed this up isn't a hack at all. It's just helping
> > the kernel do what the admin wanted in the first place: fast, targeted memory.
> 
> This is a very creative/disruptive way to do a memory reclaim. From a
> user POV I would much rather see clean page cache reclaimed before my
> apps start to disappear. But this is obviously your call and your users
> that will care.

The problem we see in practice is that kswapd is too slow to react
to sudden memory spikes from foreground apps. By the time LMKD decides
to kill a background process to make room, the foreground app is already
stuck suffering from direct reclaim stalls, which can trigger sluggish/
jank issues which is high priority rather than sustaning background
frozen apps user didn't use recently.

> 
> Anyway, I still maintain my position. I do not think it is a good
> idea to drop clean page cache as you do not know whether there are other
> users. I am NOT NAKing this patch though but please make sure you have a
> wider support for this idea before this gets merged. Also make sure that
> all the above reasoning is part of the changelog if you want to get this
> merged.

Sure, I will make sure to include all this reasoning in the changelog of
the next version.

Thanks for review.

