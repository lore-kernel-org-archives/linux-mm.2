Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E4EED25B45
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 11:19:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F8726B0088; Wed, 28 Jan 2026 06:19:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B4726B0089; Wed, 28 Jan 2026 06:19:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BBBF6B008A; Wed, 28 Jan 2026 06:19:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 141D16B0088
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 06:19:35 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B2FA91405DB
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 11:19:34 +0000 (UTC)
X-FDA: 84381127068.24.9B1BFCF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2C0FE1C0002
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 11:19:33 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iws81zbi;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769599173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bHWoC5tDbEQIFq2LviXb+tDhAj/klqtg7FTxLlPDJ+s=;
	b=c7WrGvlETEgHUQBjt5/e5fFHrzW3oSSZmtAhZCFXCD1aaw0l9erbSqIV0l1uK/kKRcTW3c
	zTE8dLUE81tW1HfiyRkt8Tr3sK83NmZUoEHsGGJ433Q4UDAig21Uiu525F+o+fOAyyjhR/
	lLzZpxb8CtHr9D6sOKP2YFIis5l2nHE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iws81zbi;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769599173; a=rsa-sha256;
	cv=none;
	b=SbrkpFO2tEleG0wiOuPp8+kg2KOr+fWJBhq8Cu9GuUX5MjGhZpNH77JhOsMc1AWP27E/NG
	oKW5GuJu//0ABhuRwM5n0/WN5QAXSsoF2cRptI6N14ptxfiN2WbRE5ThnbVNWXXaa7KrFm
	BcZqKlXGVGJaIwZDmjuHX6kEWziDn9c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9897360007;
	Wed, 28 Jan 2026 11:19:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5832EC4CEF1;
	Wed, 28 Jan 2026 11:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769599172;
	bh=VXdMnc84zIOv8qrCFYPrv7ZeHqSlUhRquu8/asMso+M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iws81zbiLqR2d0Jknieyuaboguz7tctwvWpu06X6Q+hAeuXBr+pbQ+AtIRAk+atmY
	 h5HSBtDK8dihmHbkWeZD/jLGGI4YO9eDuQyiY0Jh52/RQzzPaUS3oVFHsGWQD7eUNe
	 gc7bCqcLRQiubeOFvDl6cUqqO36aDQIvER/3osWne5UnzsbxkhGM/FUvhEppSNXA94
	 kxK2/JrFLU5iIT2DI4WsA+Ss5AXpguuFfE51WHU5AgWR2EB8PRppEOgmEmosxQ7/T+
	 M8Mf3Svtpv4x9tnrhj3XF8BLByzvCPtN7RXJV5IGO9DTZvcmKh0uUaebPZwBD+l0uX
	 rMJ332eZCPDwA==
Date: Wed, 28 Jan 2026 13:19:26 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/2] liveupdate: luo_file: do not clear serialized_data
 on unfreeze
Message-ID: <aXnwvkuTBL1NLt7f@kernel.org>
References: <20260126230302.2936817-1-pratyush@kernel.org>
 <20260126230302.2936817-2-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260126230302.2936817-2-pratyush@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 2C0FE1C0002
X-Rspamd-Server: rspam07
X-Stat-Signature: 45uz4r77jd66b7y3meo8h1c94ijy87k1
X-HE-Tag: 1769599173-992499
X-HE-Meta: U2FsdGVkX1/o8+QzbkNg6/U8/eReI3QtSUvaob3M90T0sJwnV2Isg1GErB/VYsphymxtBMvEULsnQ2PFkHCB81DG96k/l/jmC5hjelM/wCz5bHtwNC7D8pUMr67GC5q2aGCdnhD6uf33LJ7wrK3uBjVU2/c/r0ouMC6wPlX+VC0LmsWwPaWaFs/J2MzvBl4G5fVclxmVa1q7JsjZh/K8ofJywmqjBUpq27cWWG5LoLO7UCw33fDvzKhUsmFTgnwchh/YPzOABhGgRLJdhHVTeT9RIXT0FTBKahPabLDPNB+aXgfIU/Yb/T/BQSf+FHioPOTMcZnlz2oSQypZfUNPV7zEGVHi7o9dDAq11UjERgZZ7+99wa8fgxitijJpeEwad/lbmFXsAXfovfjcknrWdjZLFh93SLP59nDm3oZRpqeDZ1dD4X3RaJbAyxmzT7+wyCwlOyMs9OlbgaFvCVsnlCbqO6n+dsQb/Qbu3pCvVwA79JSzVLv/ZgCOwEyMHPYrdwZ6Bk4QDMjT1S8OZPB1rdQpHcfQCPrmVGpdpIM9GsrtKAkyRBnQ+a33W9WXB0Akdab+yTd/pXw7ytxWyNWpEkO6njy3OPSVmzEOKKQNffG2bl0yGbFz10UaL3dmnmK20v9bv/aUSoMxbGRfTfHqbePxyt7g2GDSZHBXCz6ZCzSGdraZ1UsD0B6g5QPQdPhbt/d7YC1m8CYvMdanmI6C5odjRCu+Oc8uP51ud/AGC2B5rvBGjbqKoLzIlKDIVUaugqzvt+hBCsxi3SxaKYUev2lVn4FG9AJGRHaI7SDest/rGs71EQKa5h+5PEd8JC4hWGs/ZXw4fIwqI587XVzu+ctfAsr73tkT50ro+Jr04i2ZAjdmgmGtWw3g7q4qK9dUPd0EUvi6PsR7xC5R/Lo5oJ5rXY/V3eAmkPJANXuLsWx+k+Mub6tTSwAf9tUwKBKk1ApV7Mp3EcFsHw7G/sw
 4B9Uk9GL
 lt8zFQziuN7bZpAsdpJzCf+byAkpxwOh1M1K9OU3znSXfg6CIYlAxIDxSPsRWs/L/b0cMDkbeXK5VdQv9RZdiWb13Pp4gCM5thGpm0GRidEmzWO+OxkGMI1s13Mj7osxuGmUfPx24yQ4ZAqIP3Fo5sUXUHS5VIxXhoGxRhdbTXe6CIwtC18crsEkJENjRcSF7tCp7sfygbOYNRt7pHl2uO8tykuSa0Efyf+cyW9TxXUzD64DEqv6Gga8ma44H33WKIbXAN7iwXDq1TUHvdL1VYdOr5oR3Z82jnNtjD8ZU8etbG3zKPhzFxYLOrtlGEOGjsR+Q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 27, 2026 at 12:02:52AM +0100, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> The unfreeze operation is supposed to undo the effects of the freeze
> operation. serialized_data is not set by freeze, but by preserve.
> Consequently, the unpreserve operation needs to access serialized_data
> to undo the effects of the preserve operation. This includes freeing
> the serialized data structures for example.
> 
> If a freeze callback fails, unfreeze is called for all frozen files.
> This would clear serialized_data for them. Since live update has failed,
> it can be expected that userspace aborts, releasing all sessions. When
> the sessions are released, unpreserve will be called for all files. The
> unfrozen files will see 0 in their serialized_data. This is not expected
> by file handlers, and they might either fail, leaking data and state, or
> might even crash or cause invalid memory access.
> 
> Do not clear serialized_data on unfreeze so it gets passed on to
> unpreserve. There is no need to clear it on unpreserve since luo_file
> will be freed immediately after.
> 
> Fixes: 7c722a7f44e0 ("liveupdate: luo_file: implement file systems callbacks")
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  kernel/liveupdate/luo_file.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
> index a32a777f6df8..9f7283379ebc 100644
> --- a/kernel/liveupdate/luo_file.c
> +++ b/kernel/liveupdate/luo_file.c
> @@ -402,8 +402,6 @@ static void luo_file_unfreeze_one(struct luo_file_set *file_set,
>  
>  		luo_file->fh->ops->unfreeze(&args);
>  	}
> -
> -	luo_file->serialized_data = 0;
>  }
>  
>  static void __luo_file_unfreeze(struct luo_file_set *file_set,
> -- 
> 2.52.0.457.g6b5491de43-goog
> 

-- 
Sincerely yours,
Mike.

