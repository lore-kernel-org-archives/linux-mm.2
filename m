Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2782E81A2F
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 14:52:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AEF96B0005; Mon, 16 Feb 2026 09:52:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05C556B0088; Mon, 16 Feb 2026 09:52:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAAE76B0089; Mon, 16 Feb 2026 09:52:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D44276B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 09:52:06 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 75C921B5315
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 14:52:06 +0000 (UTC)
X-FDA: 84450609852.07.DC39017
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id E9B9F40003
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 14:52:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VEO3gqdv;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771253525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lhQL0EIMB00WZNtKVX+D6Ps1VRZbog7MstMgvbYtabA=;
	b=DiFR5fBvtEmPeqGaQDjWlcj55ESY1JqCfWBcqTEvV6JY4v/bQ3HLk06OxL3DCQd2dbO31W
	5olKPtIolUV22KySZ0fMio8O6c+jQLsf6iQ/VvrnYBgAQWpe6IgQ5C+5EjGcKx9E3mkkck
	jWjKxotLtEazuqHLjNQvvFLtQLZrGNo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VEO3gqdv;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771253525; a=rsa-sha256;
	cv=none;
	b=oqA24Rybgz0XRVTp0JNnyPqpfDHCreuzN4M4Cez9oECB7/guKT2kyuGmRgmcMcpG/EEMJg
	I+uLiTi6S1H0xkhZUTmN3RN64ADsAJ+2GWL1R1nz381CE66dKuH/QsgZN301bFYMh6h9Kz
	P5f8enJfQH37/DBhtqlTBeHrMbnYC6M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E65A4406E4;
	Mon, 16 Feb 2026 14:52:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A23AC116C6;
	Mon, 16 Feb 2026 14:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771253523;
	bh=hG0c8Mrja1+MSA9V9tgUeaCss6j9bWCBInleHisLE24=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VEO3gqdv2/aaC7oikECT6XmGucBKzsdhSGRKRVN3DU4bjvZlLsYUQUKwZlXUWw7EY
	 oqLOiQ/wZaDYQQE4e86li+3IgXzBAjMuPHx6/1mnpnenOrU9J2w0gyrQ0ZJX5vDezK
	 TJ4NLVTrwMOliNLilhZ9Z0lR0/6qYwWDKWpybq39z3kZ7nRUtEgy6UzgwnvK9Jxhui
	 4k83pbBb41va3ZBXuxxcBZ3K+4RPLtBseBGq9MWLvYqDxaoq60/d9So3sC0qYfbvQg
	 CIPEnrNPlzU66q0E/tdHOHyjxMqorOiqQwSXAUbg+OvOBsYZCXQLfPqctwlMNwBdoe
	 +4RyNazHhNk/Q==
Date: Mon, 16 Feb 2026 16:51:55 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>, Ard Biesheuvel <ardb@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org,
	linux-efi@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Moritz Sanft <ms@edgeless.systems>
Subject: Re: [PATCH 1/2] efi: Fix reservation of unaccepted memory table
Message-ID: <aZMvCxV45Uw8YPhT@kernel.org>
References: <20260213154838.46567-1-kas@kernel.org>
 <20260213154838.46567-2-kas@kernel.org>
 <b3b073e4-d51e-4fd7-ad7c-7465dab412b6@intel.com>
 <aY9Mf8oZODGiDoXp@thinkstation>
 <6d6dd421-774c-4f29-84d5-3e449240eb93@intel.com>
 <aY9c80nXefdXjGXh@thinkstation>
 <aZCaE04vDpf2hDEc@kernel.org>
 <aZMn5_uLLH61Fr6o@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZMn5_uLLH61Fr6o@thinkstation>
X-Rspamd-Server: rspam11
X-Stat-Signature: 5jpfna9rmx3anbapzi7rfae4z6gjuk8w
X-Rspam-User: 
X-Rspamd-Queue-Id: E9B9F40003
X-HE-Tag: 1771253524-880608
X-HE-Meta: U2FsdGVkX1/TI61yxQ/FRFlT7RxRmkaS9twpzzrqbAu171oFsBYPTr/ktuM1JeuB1NbG8N6fbMQrBKPvms8beqLHledGGNN3wpTbmB2nlFU82zJhWEgw5P0Nf34DVzIv9+JP/hsy3/+BNyxQAvKzAPLQbu6lxXOf9jtFPour0iN2bpLdmmm4jrxMuN1R6sURUR3XnE1yOmtMgp1vaqKv8y1+KbOIqo1IkcDNr8N8ODYt7codMAr+1IhHWkAP9X3HFec28j4o76SW7ROxigSNAEzh319obbSw0OYpynoYc8Buc/89zbyEr04feSuOO7CqFd/ty4hwrV3oDwQ5tNbJCgFXunpAMbh9EUM60/yZxxXbXEE8o5A8lMho9t7n1j2puksS6yKzcEA/f6LpHUKMQveOljR9xs+KFb6qj63frpg6v/tTZgh9E6uaua2JeAg9dXrjXV7edtKq0eAlEzn0xoS47vZ2a0ZwIHImLnJiGg6kgDQnuRYYPyZjwyrykyDS5DAwjOqIvFt/2JadjfJsI4OLdcB8FV17GWonc7PDj9OPnautsncaH3s8YiGQYm9V+lKNiQ9YTGtVKvl7wlj4Z6n6Z32qPBlt3f49F+4T7b8piMGjyFeEKDng3SsLD8RojhmM7bHkuSfc2Lpi30TIuVqez82dmvzSdkfSVU9k7L7KZ0Yp0iY1zJG2qb5Ftlj6xHEWPfZcpTBoO73Uf3gZFz6eM1H7OGDK7OiXRLt2c1qPw3ZyqSOrjaHIA04gJ5J2Qo3oRPe8BWYlroErBqUktqZj0zJv8/5PRLB7j5g25X640cVZq4FfntoE70ueaiELFApUS2m4UMSjVhOVBXQt/qWS+wPMmDYX4br7gg7T2QPArZdPQgpQCuYy5J1yfkRwJvXPgXYKE5GLxrY/EmwmYuIQ6Mo1C3t47zDHnBhufGXxn4Bc+cUBsQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 02:22:49PM +0000, Kiryl Shutsemau wrote:
> On Sat, Feb 14, 2026 at 05:51:47PM +0200, Mike Rapoport wrote:
> > > My guess that multiple memblock_add() calls might add up to the full
> > > page size.
> > 
> > I'm not following here. Can you explain what do you mean?
> > 
> > Multiple memblock_add() calls to adjacent ranges will coalesce into one
> > larger range. But I don't see how is that related.
> 
> I tried to find justification for the byte-level tracking by memblock.
> Not in relation to this case, but in general.

Probably somewhere deep in git archaeology :)

I presume to not waste a page for every small allocation.
 
> -- 
>   Kiryl Shutsemau / Kirill A. Shutemov

-- 
Sincerely yours,
Mike.

