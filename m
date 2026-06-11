Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF16FCD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 14:29:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C749D6B0005; Thu, 11 Jun 2026 10:29:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C25846B0088; Thu, 11 Jun 2026 10:29:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3B696B008C; Thu, 11 Jun 2026 10:29:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A28A26B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 10:29:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 49D971A0688
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 14:29:00 +0000 (UTC)
X-FDA: 84867863640.20.7184886
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id B667D20003
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 14:28:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IisiybxO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781188138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vilZoDQISoe1jlePuvDDEKBItD7TBlXWXWHI2v7ALUU=;
	b=FSzOkGO9tfQApWv1t6R+ERL0rUkmERn/HJ5k3EoaMPlGF5ytnN4pidUUPcpT35IhcZE0YJ
	eYl0daGkFe8vama/YZjPDWz2jJQclZOQRSVjpQx3v5G8K9tk712Q/UayQxmoL46UDNbC8M
	IObFzdEmxAed1VDGFI/kEcB/Y/a3sU0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IisiybxO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781188138;
	b=tLzKz9pzfHLiwp92M8BZ2G4eKgy8eovLTCRNsYuLrOF9m/1VwPoFvI9x+vm8r8qdZt7/wF
	Wg8u+B8Trkflx5e/lMgP3Hqxu2E+G91WGq4jmEcdpgJ17DxoRjs7WgEVIHCfc2AuuaTJ6Z
	cx5IX1wrPJsDzerfejRxRxYDyEW4fv8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2C8DB600AA;
	Thu, 11 Jun 2026 14:28:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 754091F00893;
	Thu, 11 Jun 2026 14:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781188137;
	bh=vilZoDQISoe1jlePuvDDEKBItD7TBlXWXWHI2v7ALUU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IisiybxOoGQs9Wo+hB/KOZUyBLt+NgYjVM4mvhXQBQC17BlI3E/2ywsHXeARxYD+I
	 HWseCM+NPPqlBpteLd+pE9e7Ak2d62iN48+RojGh3QpXhwSQKUPhcqezEgseYge7XX
	 qeoDRsE/9l0+RR+v2C+nekuULwqCcaegZ8eY6+pGTgjUnpl9bQmK/1Ww9qWmwmfVVq
	 ucfNUNGAzSxoxg61LYDYvnFBlylzrwx/zPNBbaS7lzxz1ojen3wJw+jZvJndhAB8ol
	 iDWjS5h3d56vh6cgBswDE7dfXZ2aBkH7eqhtXiQXZx3JS/2niwrFYf+9+8uJ8NCLdT
	 aQ3EUajXXtwZg==
Date: Thu, 11 Jun 2026 17:28:50 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Tarun Sahu <tarunsahu@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/memfd_luo: validate serialized_data before conversion
Message-ID: <airGIioUmTtU9326@kernel.org>
References: <c2478f79207b10a13282d917c961261d17b86a15.1781173768.git.tarunsahu@google.com>
 <aiqso7rkpX6oMer7@kernel.org>
 <2vxzmrx1qjuf.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzmrx1qjuf.fsf@kernel.org>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: rdwzynqpq9uzgjhgztdfnaj93dfk1yym
X-Rspamd-Queue-Id: B667D20003
X-HE-Tag: 1781188138-222557
X-HE-Meta: U2FsdGVkX18OyuHweSxkblMSyH6lxWbPG91Jp8+s+60pkxNO1gACxdpx8isaO8cB2/Q20qwzGB13zKbOW6OxByGVP3WwUQEdkkrdyP9zH4mRqSwJjTyf4XbUy1C3pLFmavA3FJVkbJZFYQZeetTj7u0W+7tNk6S7h768UchwGfE9fBlX9G24eLXfrNvJHoD3f4r5+83OJmNJE5d4al3B5byJV8x18yne5xtbR/UV1IGbeY2dM5NMEKYzx1FJBqBq2ag286eWsdqjDQHM6kUih455M2xs22lG2BnBZqQt/eVrlPzTM9h/vi6yFOKCON43ciGzO50MvWrvM0BjjNwBhuYqd+C5kEhuRf8ncC4afFCT+mJiBulYnS41u+3YX+LY7NRmcniNUGLwvliVNg/26U+zBo7SQON0RhWHOW09PxUJKhw9UsgGCMX1ySzxmhO4Et34PB3yrH2I1+uwatDRi7rnbLXGJiCvCBGf3/57cZC6UBeva8/BnEid2v0eInn7nugRC2JZVNhVS/CdYPMbseQyWnLJwNcHs4ZhT3boyfikNRTVGo65QRcUmg2fQqj8xWncNEuOGNrbYu7GizFl4xOX+2oJcfqlFrn4ECGFjDqJodXVytHrXphMW0mlxO8QU8SCdE0AJ7NmZYowRPEMq/tPtPL8R5YgjQS51+r+NHk+vgAY9jbOLDMEKE+deIR2BMoNxrkU90vJKZ0GP4iszvz8+ZiR+SPFdcyZytMfqElkgYlfmYdrA00xOG1OvL2PXhAQQd5Ux1LOmXE8t5yueGXYw2omJSglCI015f/9Y0hyZuB5IAPwsKnneCyQcPpL9D/MA07uWWaC/QJUYVXzrPy5AYQwHFRyPBQiz1I7S5hy8I+oLm/HjOUKA+AjAx8b0R4bvQd8bgEyEe9FI8Gvhdt4R+JjXUysimon2iFIOUGG8m6BaBPewOG45uJbSeKYzhHnibmLewdH9uL0ubt
 kU9qTXgW
 DCDnPWPOO/UcJeyBVUir1rgvi6CurQLDE+0suodO10yfLv3vzqSbY1rM61rjNhfksHQ12gCxaSQfcxjYE/e2W5EAS2uF2J32txerRUwdovfKAstEEBnmfW8xV2FuIrmQq+5kDa+mWoBYSBPShIsnaXg4ox03zLJKr6grcYZNiMHV6fDPuMNc0t4oz+/nZsfQFD11OG6P08iWtIenFFRHLChd9alS85vBD1wPKXCMulBCZSnYcgaM9sqj+pDmog87p0I6NRhGSp668xVdzwYgfZDsbbLMwwNsDNiU1yPLGOp9ZDZVB2rJZ1je0sKM+YYOTgAbF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 03:37:12PM +0200, Pratyush Yadav wrote:
> On Thu, Jun 11 2026, Mike Rapoport wrote:
> 
> > On Thu, Jun 11, 2026 at 10:30:03AM +0000, Tarun Sahu wrote:
> >> In memfd_luo_finish() and memfd_luo_retrieve(), phys_to_virt() was called
> >> on args->serialized_data before checking if the physical address is valid.
> >> Since physical address 0 does not map to virtual NULL (due to direct
> >> mapping offsets), the subsequent check 'if (!ser)' was ineffective at
> >> catching a missing serialized_data, leading to unsafe dereferences later.
> >> 
> >> Validate that args->serialized_data is non-zero before calling
> >> phys_to_virt().
> >> 
> >> Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
> >> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> >> ---
> >>  mm/memfd_luo.c | 10 ++++++----
> >>  1 file changed, 6 insertions(+), 4 deletions(-)
> >> 
> >> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
> >> index 59de210bee5f..10f3983b0060 100644
> >> --- a/mm/memfd_luo.c
> >> +++ b/mm/memfd_luo.c
> >> @@ -397,10 +397,11 @@ static void memfd_luo_finish(struct liveupdate_file_op_args *args)
> >>  	if (args->retrieve_status)
> >>  		return;
> >>  
> >> -	ser = phys_to_virt(args->serialized_data);
> >> -	if (!ser)
> >> +	if (!args->serialized_data)
> >
> > We really should make args->serialized_data a KHOSER_PTR
> 
> Hmm, that would also be a good idea. I suppose then it would be a better
> to directly convert to using KHOSER_PTR() instead of this patch?

Makes sense.
 
> -- 
> Regards,
> Pratyush Yadav

-- 
Sincerely yours,
Mike.

