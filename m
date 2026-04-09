Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20104F31E21
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 14:26:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EFE86B00A4; Thu,  9 Apr 2026 10:26:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A0916B00A9; Thu,  9 Apr 2026 10:26:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B6C66B00AB; Thu,  9 Apr 2026 10:26:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 38F166B00A4
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:26:04 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 01F8D140873
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:26:03 +0000 (UTC)
X-FDA: 84639241848.07.13B3DE5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5AC6940017
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:26:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AyOQ2Ned;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775744762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zDMMuMjkCH/zvpm/wBiiLnM4NhgXDlBnFuaba8hq630=;
	b=0qlGwJz3Zqs5e4XKNtdQ/XG6f/YyzqcCGXPltXOpazrNDt4AxvbdsFbt52zufIxf2j8PDS
	1EGG/zrPmpbhDydidBoJLb6fPtEmCJ8o1q8KmgpBQRImv5KMe0QGKU6CcZqGp1TyA2AIeM
	wSPpxILWwumzHtcKdQNXK+Cmrzf6kQ0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775744762; a=rsa-sha256;
	cv=none;
	b=iVs600JnakxDsprUpGTAHAU03oNSx2Kdezg28+mWDLCYKJsstakWbCBG2T7uy2DIM5zh2e
	6nE3G8ndyWcyQ0y/yX5wLrPRfTpsSyyzMnAqVJH+sA7n9ykiXYIcZCEvc5hsmehEPcM7K7
	x4LBMjbiQWdgbErGN5joiIsVGNVHknQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AyOQ2Ned;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B35BD60120;
	Thu,  9 Apr 2026 14:26:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B25C4CEF7;
	Thu,  9 Apr 2026 14:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775744761;
	bh=fu+LIzuUi5owsNa6jgIR1Y2IJXiqfxhvVZVLMHNlvzg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AyOQ2NedlinVaantTOIWp8Mbve3ID4oXOIpjPPLyzN8e9mYyxAx+aND1P7Va31kC5
	 l7CNesPCXFHnVMyvRwV0lYPoJl3gdQuBpGZIRXG2NCgT62eQuF9NkK72rDMQAUBrIq
	 i+dpZCmEeSgu5exbmRjV5nCCsWY3mWtT8Wdaywa+x/tX67bl/kuqg+BpApFljIYpAb
	 hexJ54xSDFSPBtrh4UIr6MUgzWj9XCed2mgh34JZilViP6jLAfi8ieWZEB037RKqQX
	 7wuyjFpF7flx11azbTJ63ioEUUirWYVTJnykqa0SfqA6hhdaeIjLviKXG4RFYxfANy
	 rxfNOl66xintQ==
Date: Thu, 9 Apr 2026 17:25:55 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] kho: fix error handling in kho_add_subtree()
Message-ID: <ade28zxgU8gLofnB@kernel.org>
References: <20260407-kho_fix_send-v1-1-b21977feb960@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260407-kho_fix_send-v1-1-b21977feb960@debian.org>
X-Rspamd-Server: rspam12
X-Stat-Signature: 8966tup6wryp9gq3dedamowsj6g71kpk
X-Rspamd-Queue-Id: 5AC6940017
X-Rspam-User: 
X-HE-Tag: 1775744762-638976
X-HE-Meta: U2FsdGVkX19kIgqO7pTyePeWqARUlaTa75LXzwnOvRjtrJwBgDr3F1e1U5/Odq0LbnF8hjcWvuBd7ChN2AeDT0Ohya0W/K/aCG6iPvxosvsFYzdHsSHsaGyf7x3h6rlN4ou+7DXCvd/Ck9QdTQuQ2Zd0AMiDgHB58kDss5U8E6sAUe63DHnUq+AGbQQeCr2BcYVCB6sChRnLQebKl8lDw0H3oB/sStoq3og3nyk4KZzT6yGeXIh5FhmI7su033mGz/+3wt4LN1iT2fyJS69gGv24MH7FiDWztEZtqqQcy49kYF4hTZ603Sjwp998gHgkBp2AabYMLdDDLPr81sAejozAEfUPJ3VBH2VpsFf2u9+8zRjx2o0WW8mG9KUgIwG28SHkl9p6pJTGNsY6Nw5csz3ra6Ndy1pVPrUxXzYCJns7AMaDeP7XhYmwukOXEoAozy6Ua4Qx9a7TMR6eeDLCaDvp189ojOAVQ1EskzCR/H2HwWsIzblN5cjwsyHqTgRQ5mP8yQKl3IjVkx/NeYvweR7yTw5hramR6GFYoHDZHLPmiTaG/AGMOI2oU+lMlBVO3/R5R5WQfZkp0XCYo8N14vKl3gBGNUutFeRYgypGGTJYajlW8Q6euJPY3TKlBk11R7HL+juB/rOvBZOnH0BqooOViEsYZd0MUzHOTtssW7WwzB/sdBbdQSy7kMUm+Nl66JyATtm4KWOHdLQGUNA7TlgoRiNzOeWOaW10BgX7hWW4MuXlQUoF39WhbQXz32YWwJhuYrK4UD5+RD7W1G2gdgcU49M8DQTbWTrODQX5tl5ON3EDrUrT3efzZ/rzXfCrII4CMPRtTg4G7CSv+z2dN7WZvs2ZUldSUyiPjpt+qZx6XYQ6daUL7QuxCRRE2drC9SmqIcIHwsy2fPOmVCTpPFBqSmfsn58/R8YFNh8oHmfpjKjUUxEYdPJN0tH43xBYRzZYwtTFjTN1vCm7Dp/
 MiUTeQDY
 R7SVHNinSPgCv/qmlmrvq85N/53m/2G/dGOH7O9Uesvl8zTLjHkVq++nQ5pBsggNAJeV7GZ3hcCB834pme3w4fJNq9G8AbYL9qCF6NFE1mBelnXM0G0TP1tf62HcallWzZeMKvrozE2b3fzb+mFJtZ8C3RQHEwg39SfzkjOMFj6yEofLZunOBvMNM+jzLYsnATgZYwmzy9hACG44ChzvirJf1uuAslgVfVkmdv2cl/6G26dcbK03aA9G9wiT3xybfCl/Q63nMxN2jI0lDCMptatvarSw6SynP/EckPPUZdNDWz4xeDmBKXJz2KINWpOokIO4lz0wiMgs9T0O/LbFiobLNPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 07, 2026 at 10:01:47AM -0700, Breno Leitao wrote:
> Fix two error handling issues in kho_add_subtree(), where it doesn't
> handle the error path correctly.
> 
> 1. If fdt_setprop() fails after the subnode has been created, the
>    subnode is not removed. This leaves an incomplete node in the FDT
>    (missing "preserved-data" or "blob-size" properties).
> 
> 2. The fdt_setprop() return value (an FDT error code) is stored
>    directly in err and returned to the caller, which expects -errno.
> 
> Fix both by storing fdt_setprop() results in fdt_err, jumping to a new
> out_del_node label that removes the subnode on failure, and only setting
> err = 0 on the success path, otherwise returning -ENOMEM (instead of
> FDT_ERR_ errors that would come from fdt_setprop).
> 
> Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
> Suggested-by: Pratyush Yadav <pratyush@kernel.org>
> Signed-off-by: Breno Leitao <leitao@debian.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  kernel/liveupdate/kexec_handover.c | 21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)

-- 
Sincerely yours,
Mike.

