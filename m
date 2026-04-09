Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4077AF31E22
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 15:17:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 811EC6B0005; Thu,  9 Apr 2026 11:17:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E8E16B0089; Thu,  9 Apr 2026 11:17:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7265B6B008A; Thu,  9 Apr 2026 11:17:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 617976B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 11:17:42 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 21D8714047B
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 15:17:42 +0000 (UTC)
X-FDA: 84639371964.09.38A3963
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 67409140014
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 15:17:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Qht0fFe/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775747860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nbr06xUxYlzqYLI3d13wLA/zrqb+kMb6HGm3++yLxR8=;
	b=lO2yOPDg9bNSHIpnYnD6i02Lj//itGk0Mcx2Dq1EOtSPUDXlhS9WyAXQ+qBJbOijJjWDey
	qUW6SSRzwnTqcTV/Ff0oSj+qgBZfi3NEvG1CRzjH8vkPCOZ2gpBsVWcuzkyWToxdR2fyev
	3XnJao+Ycj3IyoFAJWeKkUQPtGQRXBc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775747860; a=rsa-sha256;
	cv=none;
	b=NNDY11tenY7bGI8JtK6TV6xTqmqDIosHheYcl8TTwQTSMHJSRh2Et6Xzs/fDxHbv0Ge5hE
	Bdx1R/o24eiNrzgMP3tgaW+HK5+K4Z+V/V1qxAupgis3wfgiHuEAkWZiU4KQltRhzcBWro
	8BVzBUsQqv44/jkezwi94FYzQkceHPY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Qht0fFe/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6697F43FB0;
	Thu,  9 Apr 2026 15:17:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 926CFC19424;
	Thu,  9 Apr 2026 15:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775747859;
	bh=sAn4kmA/v5fslLSRk7scPloEbnAS+gMCiSVeAY7naxU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Qht0fFe/mAYbgemHSrTJUo++6CxWDoPmooLnV8Mh+eLdG0nRX6n9/3kNfXrV6fK6u
	 1IOsS72bzgsHmIjHQsmj6DxoD0K9xK8F+reRJx4L9gaTBzbkYf6VfezuwKZF/KpURX
	 pvpBEUbxTUQPfmb2WFB7KZWcFgNbRMw5kbbjtRbYrhz6xu448ViLBRW7fRq/8sw/5f
	 99kGM+McX3C63N32vBWaWN2FBEnxBCM61AA3iAzmQbf+YgB6jJLDp3qX9VeDL9aRDR
	 /h1GRhpWpMU+9nwBZlTNSMfqiUxIZ2WCbdPg2XlTs1P/yC7XPqvESzIz3OeKz13Lig
	 CYrrj9wd9kEsw==
Date: Thu, 9 Apr 2026 18:17:30 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: "Denis M. Karpov" <komlomal@gmail.com>, harry@kernel.org,
	akpm@linux-foundation.org, Liam.Howlett@oracle.com, ljs@kernel.org,
	vbabka@kernel.org, jannh@google.com, peterx@redhat.com,
	brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, usama.arif@linux.dev
Subject: Re: [PATCH v2] userfaultfd: allow registration of ranges below
 mmap_min_addr
Message-ID: <adfDCpTH9n2lG63n@kernel.org>
References: <20260409103345.15044-1-komlomal@gmail.com>
 <d4xigmgectqbv5q5dxsrlunea3ynexa4ym4nuxy2rokrawsqu6@yfhzm3hl5nya>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4xigmgectqbv5q5dxsrlunea3ynexa4ym4nuxy2rokrawsqu6@yfhzm3hl5nya>
X-Rspamd-Queue-Id: 67409140014
X-Stat-Signature: p876yyr1em6mfjsfajsup3jgpcis7ead
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775747860-659269
X-HE-Meta: U2FsdGVkX1+9BSYi+1b5t7HLrq7uOrkYshdQWHhX0d7E2vDFBk7XZsxDGo5WVIqxTl4JVghzBJX5Yly/ul+H3FCQ7KnMEFY6JwQ4XGb6PaRat3yO2ScgGHL4LDjATuTzOGBR2dkjn7U/zSdZrZsEOsCX9Gz8wnv4ZFO8Lt4lA/TXIpLaAQZij5tm25DC6i44IjextJCTMk38Xwh0j73gzXhVDu1WnQr2yMMKlJ5buksymgDUAwJSiyX4+MWacHPk4+mUOEZMQTwyA6S4T5I6KxwjmYqX6kRFyeSwlI2xN8y62XBFZHuVnTiKLCDgiHFsYwKrBZOgW2nAGoRKJeXeXx57fRnzt8/NMdWo33+9J/bAqY3V2xcaQjS/vmGwO/IZivecqqC1dfR6YuhWuRQ0ql88UEfoLtO6zoeflT3pCEVt1+HNKyBQjqfcmvb+ZfMjL04MdbMSKCMqdUcoD2tuvCMe1M85ThucLOEQ0/CqxF1tXRdeQ06abiGtuIold1f3Xg9Z1TQ3Dm/Qu/WPP0WtXYJdIx7l4eQ79QGfYnAdtJ1SBbtOpmXiaFQy1cVLO0+cVdxdeFkFZrxJtv/hVxSxQiyZc6Rm49EQCMuu7Nz5yFNdZKtdj0YC8BJ+NBDqylMzoXlMYQw9TehHOaFYNjLVq9sc6wg7ZYKpSDJICeZCwDh7hn9po/rA/vs1UFYgH7nR8+Yd5VOaCu1tLRf8s9J69mMKykp61lzxcYlrbHbR5+vbGu2EBr/M2LyoLGYL3RNEydhlO3gUy9qwB6xvN4M4isKHidpTSqNdlSWrHFAA02DzbA54wVZ/bm+DtXtpw+Sb3f6VfytJRzWlRpoInKZotCfLxrweEzE1wOat+CKhrVQHukKmzooJGtQjyk5eWdVP67aHQh6b77m+N1NmqFaJvKfWjbMmfoEP8SRS8T4/42sc4BhQrRKrRdwVpXY1ztZetT5m3eegBbJ8/Q6UZjC
 0rk+PV1X
 kh8hJlR8ezYyHi1mxn4+rZnxgBbGKTkqTcR0wRlfV2prNdF/SWFoF4AKqGOE5aj1CYKoO5nHsycURM9HCoqip8kgkvMVBn767EjrxeKyfKZG1gqNWH+X1F0kezu90LE1ndwdBRuA56h4ZtVaQbJwh6N+JvMNSbeEb23lV4GYy4TaiKNJkXGjTilf+MS5KNSqxONNIDNURnhbP+VjaBlVXrJYPQgW3mhedjNvvsUw5Ou0O2H7ZqgWU6qfvjvOrUyZc/yEUDyhxmg7JhNPUsmA0/ia0a4BMgYbVEBL1ftOACGJkML67NuI4amNiPonX+J8w1GdJW1Q+eLAOwak=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 01:30:07PM +0100, Pedro Falcato wrote:
> On Thu, Apr 09, 2026 at 01:33:45PM +0300, Denis M. Karpov wrote:
> > The current implementation of validate_range() in fs/userfaultfd.c
> > performs a hard check against mmap_min_addr. This is redundant because
> > UFFDIO_REGISTER operates on memory ranges that must already be backed
> > by a VMA.
> > 
> > Enforcing mmap_min_addr or capability checks again in userfaultfd is
> > unnecessary and prevents applications like binary compilers from
> > using UFFD for valid memory regions mapped by application.
> > 
> > Remove the redundant check for mmap_min_addr.
> > 
> > Fixes: 86039bd3b4e6 ("userfaultfd: add new syscall to provide memory externalization")
> > Signed-off-by: Denis M. Karpov <komlomal@gmail.com>
> 
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> 
> This looks relatively safe. However, I'm not sure if we want this in stable.
> This has been broken for 11 years now, with no complaints.

I believe Denis has a new usecase that wasn't there for those 11 years :)

Denis, can you share more details about your usecase for us to better
understand importance of backporting this to stable?
 
> -- 
> Pedro

-- 
Sincerely yours,
Mike.

