Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26F9AC83F17
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 17:37:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB3306B0088; Mon, 28 Jul 2025 13:37:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3D276B0089; Mon, 28 Jul 2025 13:37:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92BD86B008A; Mon, 28 Jul 2025 13:37:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7EDB16B0088
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 13:37:10 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 020FA13393A
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 17:37:09 +0000 (UTC)
X-FDA: 83714379420.02.848B7C8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 64BFC16000B
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 17:37:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="G/hWdlN3";
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753724228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cSK9HE2m4u6xZ+c1BZrTVF4ULoOPWicTEKQ9AdDTKRQ=;
	b=1AuCKTAUY2rBPGkijfcleXN2BHtfMONGLV0FYW1CpG56GRBth34Y6t5OpTyrFIrDTd0P5J
	1dhI8RbnLro6boi+e8gpgdqiT4Cr2K6SmMommXhhjD0uPcogWZI+2/BPTgE+2YWMofFhCJ
	HAsEpwuBVO7mcQ5K2pOLfPqNkGqcsd0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="G/hWdlN3";
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753724228; a=rsa-sha256;
	cv=none;
	b=Rxf/fyE0SWgHpvMg/yDAcnMNoYnjNg/qSTGiNtXVqqtv4uDO7A7kyBHzQC1bCdnLVexRKg
	H7QAAjlUQi0aHMTFqjiAdnsqHpulnUFNG2RRnAMpBQ6R49C1Z7HQ73r2ywQcpEe+outjla
	XsaplnLYNMnNw8SaDgW/UBScMkLXLII=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ABCD1601F8;
	Mon, 28 Jul 2025 17:37:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 419F4C4CEE7;
	Mon, 28 Jul 2025 17:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753724227;
	bh=cSK9HE2m4u6xZ+c1BZrTVF4ULoOPWicTEKQ9AdDTKRQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=G/hWdlN3yvstdBaKkjqftnG5aXqBHaOnE7r0j34FA7NyOMPgE1vQwWR9vZ3i1Vhw+
	 ugWzpzuAfOIITCHW4HcEtYi0PVUsaLvkVTDv2vVsetMEk//3yw1VXlQogleFQAtYJu
	 SfDGaTS35MhuYzncnwRlfbQKgg5aUsqKnfqv26gY=
Date: Mon, 28 Jul 2025 10:37:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org, Marek
 Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] mm: Update MAINTAINERS entry for HMM
Message-Id: <20250728103706.d3d0b968f9e092193a1ae196@linux-foundation.org>
In-Reply-To: <20250728132128.GA36037@nvidia.com>
References: <0-v1-a1df5219c7a3+1d981-hmm_maintainers_jgg@nvidia.com>
	<pn4672gpfjtov7mbnzfhzdz6zdvb5f3sxaeo6cctvccvzn2y3m@bzpkkvmqnpm5>
	<20250728132128.GA36037@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: i3jhga8gdzufgnob9abrn5hgy5ioe4rc
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 64BFC16000B
X-Rspam-User: 
X-HE-Tag: 1753724228-134346
X-HE-Meta: U2FsdGVkX1/eZVrRVo2rzec45tApbvSvl0Uihe1vO/ta3mULqiRPqOnb9ZR5zRBlssn3o1EIjAtp1v9b1+lovwHWQ0dUbRKu1E8I285oyInLNBRmmrwLXtMderPnl2m8npXH/BZ7d3ocUG0Tz7v3F41mBQ4FBTYgxiH4B/DeuH0icmgr7rJ8uChCtFiTaTPkxIJAWk2BfbroY72cV/KRUm614UxWzm3qIdpIV0MNsQAsJvzthH8uHWqy61XtC+AMSGlyRwVFojhCIensGVJ/HHmnByaObyhPsv19ebP816/7eXXdnaxs56dBbr/Z+NSIg3YgUNb2YJXuB6DLm2DCUEiFQE0nXVK6sSOsk6dZT6axZauBf6V94puUChdNUipTf+b85tcxqBSUWLIE9K9QlI4MEUQm05z3O0L8y2iOekWUd0mrxbt55/TGzyXEq5WoAFHKGlTFxdFB8rSrRZY5dxOiWWOKmtVnyZ3Iu+wEfoJi8mAMRIXahWVmR9PSTsar2sdizJY/roxUTfrsMhDsT/hqxELzpYakOSjVX9mxL+yy70JZ+Gjfn6mzQJGJXFYUxJEO0xqRdrtj7Em6oqyf5L6vJsIMWjMgO1WPOdToWL8aQpu1UwPOAhUyVAmtomGMoLmubYg6lirPQVChgU18vTgJUX8Di4E9gFEZVUU3cTsIUxdzV9oxyCKpWPkByAk8kapm1pM1ZptmaCLUHnk/L2gRr4ROw9w7yfkKVKz1dFSeDAGp3009BoQYFGTLdkzG+Ck2LZGNZEiPLTseo31vHeZp3iAwfWMsfxa2cOukRh37jJI90BEK0nreLS2GJZL8Xtsh1PmYSbWFjSIiqELNSf24rE+zkzp1O3qQlk+Gh2YplZlIHjrA5HO1UuaRcujEd/yUqbP2rSs9Q2hXKzW1JPjhoHGNpImUBAtcqdBdUDA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 28 Jul 2025 10:21:28 -0300 Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Jul 21, 2025 at 11:28:27AM +1000, Alistair Popple wrote:
> > On Fri, Jul 11, 2025 at 07:34:44PM -0300, Jason Gunthorpe wrote:
> > > J=E9r=F4me has moved on from RH and has not been looking at HMM patch=
es for
> > > some time. I've made the most changes to the core code in the recent
> > > period and Leon is now working on the HMM side from the RDMA ODP.
> >=20
> > I've spent way too long staring at the HMM code, feel free to add me as=
 a
> > reviewer.
>=20
> For sure, can you send a patch? I think this got picked up already?

Yes, it's in 6.16 as d367a177e2e4.

