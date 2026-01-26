Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5921ED13C1E
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 14:37:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DA046B0089; Mon, 26 Jan 2026 09:37:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75D196B008A; Mon, 26 Jan 2026 09:37:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65F396B008C; Mon, 26 Jan 2026 09:37:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 53C8C6B0089
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 09:37:33 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D8F98C26A4
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 14:37:32 +0000 (UTC)
X-FDA: 84374368344.02.93CDE98
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4B2C2140015
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 14:37:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rf6nge47;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769438251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yuekLC8en0td7oT7zIqcqIdKfiM7LVatOtq67QDUGkE=;
	b=2HMA+wDzscH0fgjRnwBo4ZoFL24vkwHijDWSIuObfwOAySaQONVXWbipIRpTN/xTuUs9Ok
	XlrTEJcZvMCTat5WpGJNkfWJ+SeteFIbn4iRQqSo6sGbOZkKMPIocEntYQH8cfVpW8TEZx
	zO8a9qXq1g2KyTIdDRi8jbHOBEv0JdE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rf6nge47;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769438251; a=rsa-sha256;
	cv=none;
	b=waI/mQkJ64n1vNuiJizydHiF9lQ49zs5Z7TknRdBJA74WuNgHfgC2nj2I7ojuxaIbevqSf
	Hy8GqzRnTaZzCd6utzWj+yX+rPxwo37kPFdHyu7s5y6PZAsHodisAC6G+ZTupFsv3K2Utd
	I/NVaZJXp4Kwq3vDhcG5FJjsqW0MxCE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9CA1660136;
	Mon, 26 Jan 2026 14:37:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0CDDC116C6;
	Mon, 26 Jan 2026 14:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769438250;
	bh=gdfx2feLN6TCXDpAa4ggnSeI5KqTW3J3K6FBc2yfOFE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Rf6nge473dxjqTDe76VCvV99QZTDzBZNcuE4AVsvRCx1tVdM4YvKftbA0xuh1CZ63
	 iVw1pHZyedxQSBviJM/DhVKJzpNTb25ztptjSIqJv/oD1AfIzNakztu1716jOz++yv
	 FRkE8N4q762X+u0hBJQlN1daImLdQ4h+qGCSlSjfEVTnS+dpfVnkM0LsFkMVerHwiy
	 /K25y+D3H/rD9K+QXYDiF4Z/y/NOiPEqicW6qbDLZ6tS9GbZSybVTjprj65FtqeaCB
	 hZdClXbebcJoi9B+cRjIMeYgpJS8aCMazKmgbhPli7JipLNWZZCLJKE2MJqzutD9Fs
	 llFvM0qNIaMUw==
Date: Mon, 26 Jan 2026 16:37:23 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: memfd_luo: preserve file seals
Message-ID: <aXd8I4czYUpl72qq@kernel.org>
References: <20260123095854.535058-1-pratyush@kernel.org>
 <20260123095854.535058-3-pratyush@kernel.org>
 <aXYGkb-QtYNaWYw4@kernel.org>
 <2vxzqzrca6cm.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzqzrca6cm.fsf@kernel.org>
X-Stat-Signature: i78z99kuta14ykfmnjw5j44xe341c4mk
X-Rspamd-Queue-Id: 4B2C2140015
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769438251-522072
X-HE-Meta: U2FsdGVkX1+WrU5dC4Savrtu5VijS1QNCAcPxzqJslUzr3ftkl8tKWMNUHhWvBWxl1pgDH5kl9cEI4ZkR0WQAE2pQRx3sLad7a5mfUnlK+Lt/eHdGRBgs2+fGj6j5KTwm+CSZ1Runw3C5mA5zNR+9iaW5thR/8fB53hcOc9yMF2P/lDB5MsS8fllygHW6Jow0/3l5aFTfXEmi58rfHiP+ivcYGRh9JAHV05/jgd1GLaGD4owqRQD5UyNFwplVkV1xYsQ/f6m0IRiiag9yW4WpJzIpXyLCMxiwC/HSRpovq6rEI2TZodPT57PQcfAUfwELqoJggckItdCxODBCW/MjiulhofgXP+kzGA35l31juKdbWX90EtmNKBmN4OkkglI1CCs2pizkJXdsVPHkfMznUjWDdD2nJ4Mw8aaDWVX4cAW0gl8taEqLJ6LWKUiBX7yTDksf5A7DJxZMOmPtDBrK6Ral33aZP8UBQowlCC22mtCKBVyxX+NJLscgCvDtrKabn78yG0UqWqcH08hXqLkmLcZfP0Yr37hA5wKVGQEnvqoVpwh4H2YsM0I+FCOR5j+jrwgpr5p0Y4i3/CMj+0+VSkRSba6FF+7KEfd0l7vKrXh8+BlhOQKmQuPqWZvB9Vns8NiQoD60j1yLBDRCBdZ+x6q7gQkZJe5g/vmPc+uVKwP8Ic8QbxwSpsG0LqgvXJxXVUlNYz642ZKx2KTvYW/YC+iLlsv2gAmOgG4xqNYlh5Jaeap3KADlDUZjJuKaR5yXMuhHb32e87XV6G8BDlY1XgTW0A+n04JqkQd5HxuRPlP2tB2bw3rZomPG7eUdbexDhiBdLy+1+kI+uFSI1LMMJIPgBKudessqfaJzHuhS8qReELI29VYldVLqMTeuvJblRXtIPqIEFcOukcyn6zEFlVsC2xLaAMg8qEcx47Pw8ALZZsH8DCsBvgogAb8te9zuzWg5XXZbvzjV2IWiHn
 t5fBB6xG
 Fwh+euNlv63MCsMGgx1+N97xlJEn3WdGfY+YO9R8c285K7XYXhvOx7NAWAIJqdByGgobmVksVX4G9RMbe41VvBf0a4X7kWmYQmEwP11uKtrQqSYcbR8h6SietMKSZO0hX0wWO0rA/xsqGAmQ1IqeBkGbWSwUq773e/Qtq0hl+XGkwWF+hzfYG5qi35u8sI9uyL7tBV63jjnmSF/6U/OVvwpf1CY5ZKA2gx62XFTDwAj18oKT+8XGRl1KPeezfqXp1hUpVR4SLixcuBTJBNT+pS/fIC7+cHi1RsnASvuoCwKQEPFc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pratyush,

On Mon, Jan 26, 2026 at 01:47:21PM +0100, Pratyush Yadav wrote:
> Hi Mike,
> 
> On Sun, Jan 25 2026, Mike Rapoport wrote:
> > On Fri, Jan 23, 2026 at 10:58:51AM +0100, Pratyush Yadav wrote:

...

> >> -	file = memfd_alloc_file("", 0);
> >> +	/*
> >> +	 * The seals are preserved. Allow sealing here so they can be added
> >> +	 * later.
> >> +	 */
> >> +	file = memfd_alloc_file("", MFD_ALLOW_SEALING);
> >
> > I think we should select flags passed to memfd_alloc_file() based on
> > ser->seals (and later based on ser->seals and ser->flags).
> 
> Not sure what you mean.
> 
> I think the only seal we can set via memfd_alloc_file() flags is
> MFD_NOEXEC_SEAL, which is really a F_SEAL_EXEC and plus a change of the
> inode's mode. And now that I think of it, that is a valid use case that
> we might as well support. But I think that should be done by preserving
> the mode of the inode directly, and then copying the seals back. The
> main reason for that is that the mode can be changed after the memfd is
> created too.
>
> Other than that, all other seals are set by fcntl (via
> memfd_add_seals()), so I don't see what else we can pass to
> memfd_alloc_file().

Hmm, "using ser->seals" was bad phrasing :)

Now we add support for creating memfd with MFD_ALLOW_SEALING and at some
point we'd want MFD_HUGETLB and huge page size.
So I think we should have a field in ser that will define what flags should
be used for creation of memfd and based on the value of that field pass the
flags to memfd_alloc_file().

For seals support this field can be hardwired to MFD_ALLOW_SEALING at preserve
time.

> >>  	if (IS_ERR(file)) {
> >>  		pr_err("failed to setup file: %pe\n", file);
> >>  		err = PTR_ERR(file);
> >>  		goto free_ser;
> >>  	}
> >>  
> >> +	err = memfd_add_seals(file, ser->seals);
> >
> > I'm not sure using MFD_ALLOW_SEALING is enough if there was F_SEAL_EXEC in
> > seals.
> 
> Why not? memfd_add_seals() can handle F_SEAL_EXEC as far as I can tell.

I just noticed it behaved differently :)
Looks like F_SEAL_EXEC indeed can handle it.

> -- 
> Regards,
> Pratyush Yadav

-- 
Sincerely yours,
Mike.

