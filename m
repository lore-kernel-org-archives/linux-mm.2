Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00ECCCD4F4B
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 17:33:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 405FB6B0093; Sun, 17 May 2026 13:33:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B71B6B0095; Sun, 17 May 2026 13:33:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CCB76B0096; Sun, 17 May 2026 13:33:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1E5A26B0093
	for <linux-mm@kvack.org>; Sun, 17 May 2026 13:33:17 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E03C8C203E
	for <linux-mm@kvack.org>; Sun, 17 May 2026 17:33:15 +0000 (UTC)
X-FDA: 84777607950.20.BC5B1C1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 59791180002
	for <linux-mm@kvack.org>; Sun, 17 May 2026 17:33:14 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s2dxYeVo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779039194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MW+H3V8e0LDnsKJwU4Yin0CQyrhuOE/niANZI/vpt50=;
	b=siutvr8G/5YtcY1wh2W6FiKSES+ZakGo/YSDANepwQwVdrsRQ4M/hDIw86SaJrd3wvTelF
	4/gaTVBGbrYdR2p84iO9x8NYJDe/hkZcQebzxtqqsP70OKqAW6yzoeeAgiy2o9OlBaw4TE
	liiXXr6YAW/LP/93aMDELw5oaU+w2k4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779039194; a=rsa-sha256;
	cv=none;
	b=n1lvpIaGNgVsY1Junv/pHEwXsDH9glV5beo9jv1uXmeUaFsKDjgSqGPpJfihdwXinllDzd
	BcmOuTz2FYNDV3GLkIV4+ZC4k5H73eALOXtnq09JDs0Uq9j/YyQQ+7HHyIdJ87dH2IjnjV
	ovx+PMz+EAJ+r1m1t4dIWXP4Okc35ak=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s2dxYeVo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C02F060125;
	Sun, 17 May 2026 17:33:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A1C9C2BCB0;
	Sun, 17 May 2026 17:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779039193;
	bh=MfKwn2SskewqeDZpjMen9el97DJDPcfqGZU8duSRb4A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s2dxYeVoaZOazfHyFr5HmEW7yEF2kyENZxJLO/bkIVU+4YswTAsFte42VtYXPpwAp
	 MtiXJVjzK3d+sKMWBdG2ylnIFkyg2p3nCbnuoHEAd+Hl9tLlsD1bnHV8FWqBp6OPoV
	 9WDfFCEaxEkER7apciERu/epb8TpNRMc5JU8Pp7i33WFUAClkZpW54tXiz4HDyFsC0
	 CpaESd73RCAGj4mgv0psl0EnT+vo+NZWn/bsnaQS9hAvuI+kqkCC7QTWGMJrIrozan
	 brMnso4HosoEQucy47O1jFex/dzPDgzd0Zg/QeTqyxC3z3lL89e0+EYCIsqIiF9LIi
	 VlOFgH3C1ubzg==
Date: Sun, 17 May 2026 20:33:05 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org, shuah@kernel.org,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	skhan@linuxfoundation.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, corbet@lwn.net, dmatlack@google.com,
	kexec@lists.infradead.org, pratyush@kernel.org, skhawaja@google.com,
	graf@amazon.com
Subject: Re: [PATCH v2 06/10] liveupdate: Remove limit on the number of
 sessions
Message-ID: <agn70Rol6l0Okp9B@kernel.org>
References: <20260514222628.931312-1-pasha.tatashin@soleen.com>
 <20260514222628.931312-7-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514222628.931312-7-pasha.tatashin@soleen.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 59791180002
X-Rspamd-Server: rspam04
X-Stat-Signature: uzfh6ajygt8dxnpdem5is96gd91ucs1s
X-HE-Tag: 1779039194-55170
X-HE-Meta: U2FsdGVkX1+liPB4WiILpXMMoo6bXjAdocgz9vOdbe/o5k993VelfNfrcYBfkS/6OONbWC00dfLD8x4nfRjRRUd57G6pvGgcuBt9jQzAFSOrwIZAWyDS53sYXo8Jyw0kZ2GNsB62aQsBwp63M68HTvEBhwFWH5ngyN/02IigSHP9Ql44tNiTHMD4yPUV6Q8rY8Usp+fHRFpWRbVElnJQ+MCKSeb5Vghy+tLyia6sLkd9Pe9wMwnaGywHjXmzFqS2bd57t9MOwFB6jLjivjRZNJOqDGYUMCiefkxN+lxvNjs18uO6DGag5RnEWsGc8bfPFNsa5EOtVSd9cJni+9Caf7Ss6Fs9zxCA6XR7F9GbGrf/A2JfpymLRxcgbWrMFAIuxIDynSmV+moXg/UOhCxRDVbhtca7Yi65GgZUf7J62i9ljbC2Hc5gk9ETflG+j4gUcvPCBI1c7zg4UGX9Nsp1S80Zhm1OHWMNW+JTZG1GODoARCF7IkMN2PXItSe9PhweaM1tIQE+2wv/0wVQlfOCu9/7Jr/guZ/grhGIY5cCkXw+di5FWDCVStF2lG70CETKD5jxu/FqLQvWeIsxAqBmU+o+3fZCYJoUS7ZG9GBSMdubJfpCP7wJJCBixiXE6p+zXR4UCTCKbTEUs4AgEYQJh22yjByj9FGMAKEgdm64c3yENeC4eayRCfvMtguDGYvRik4r1OMw8g5F7lLY0lFjtKUuwqjl3iYHl8IGJr9pcMKO1bhp/eKWDBGtTHxyN/6O4NqVaZX3UpnKK3kWtAO9eFEPXMcBq2pKBcxzNNPfyuxk6t6ZMINt+vjkgvOrUWO4FmemJTqTiTIPODKrq7TffbMq2BOhd26G1YTcqSu0G3LBCwAh59tSwJRVLPS5NdlKcKgvCvJ13kPm7+ZPuqp8+fygARI72mKSybVfDk3QhveSqiz7vgNMsMuChKVNCVWqaiORuHRsbewkYjSSLXD
 zRxjun5H
 jaUP+5MZYu0XqiO7oo7Sjx3K6Hrl5MmO8kFm9iZ7597CH0SIPHYdX91WhdA6YV7yeUnel7n5yUDCIH1ZBAsdV2BeMgxlaWP4mvB4sHuWi9/6maHrSAvA17ABGwl/8unWR76dY6Vrd2RQ0akd/grSYwSSs1FqsN56uBdAzlN3hp0Hl70dUgEK3prDxqwQJMMDp98yX80OMYkp2V3xLHVVm7er0AoHPHv1pcd/CofBI8NqSy/rQDNQ7WBNOzqa5qhVmTTJxJVH+BquUJBFV7kdiW1lZBc5dzvx8Sl5R6d8rNCyQ+RA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 14, 2026 at 10:26:24PM +0000, Pasha Tatashin wrote:
> Currently, the number of LUO sessions is limited by a fixed number of
> pre-allocated pages for serialization (16 pages, allowing for ~819
> sessions).
> 
> This limitation is problematic if LUO is used to support things such as
> systemd file descriptor store, and would be used not just as VM memory
> but to save other states on the machine.
> 
> Remove this limit by transitioning to a linked-block approach for
> session metadata serialization. Instead of a single contiguous block,
> session metadata is now stored in a chain of 16-page blocks. Each block
> starts with a header containing the physical address of the next block
> and the number of session entries in the current block.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/kho/abi/luo.h     |  24 +-------
>  kernel/liveupdate/luo_session.c | 105 +++++++++++++++-----------------
>  2 files changed, 50 insertions(+), 79 deletions(-)

-- 
Sincerely yours,
Mike.

