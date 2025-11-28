Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EE36D116EA
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 08:26:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 986E46B0031; Fri, 28 Nov 2025 03:26:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95E8C6B0032; Fri, 28 Nov 2025 03:26:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89BA56B0062; Fri, 28 Nov 2025 03:26:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 79A656B0031
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 03:26:23 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 214C550580
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 08:26:23 +0000 (UTC)
X-FDA: 84159333846.14.2ED3FE5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 87A3B160003
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 08:26:21 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aim6ke9Z;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764318381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DDt4b8LyBcxveIDIJQ9V3SR4ATungazMJVU6PjrwFLI=;
	b=i6LWg1ujGxlAUAze3S/5bxxq47dcPt32e5m+sscyGoxdXHza6ZJ8XSGmiqZE+uZzwJ0QKc
	CwDYEzd5UwMKuvDh+jWIr22K++RE5CSJWuqy6CiEer4T8f4GbYj+Cc10ZDSBpBYbSmGXIS
	jMdJ6AaGZg1JOFOCIfx1ykG9JrwbG8Q=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aim6ke9Z;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764318381; a=rsa-sha256;
	cv=none;
	b=3NtNNLj4P4coGve8W1dvOQtX7zOZ0pf6FWWEExZZD3IiFvqVRC1Kj9UkwvYUVkZ9BLq4pG
	fSi+ZOveqa75UsyX84kJr/6nHIGRqCiznf3jYmhS46kcZoXTzp+lsy5HMg7GKoqj9Pc+nJ
	VP+cTUYfsxtcHKIa5UiJE8G7A6lz2gA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AD31360254;
	Fri, 28 Nov 2025 08:26:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9E29C4CEF1;
	Fri, 28 Nov 2025 08:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764318380;
	bh=IpmHE4TTrvndRHadxSdi0TndJPA3BUmXMEgJz7l06iY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aim6ke9ZUHrxTdbMVGVG05sYSe3Fws4B7s4/WC5ikZN9cyNK/Twqt4ZCC+jLG3HdW
	 rop0mbHSuDI12O1PswPg7eQ16mowythFkRxbPecBlXhzTbz4rKSYB+h299SkTV7zTg
	 a+tDaeWJO9LEWPvhz4XjNO+bxVdSl0KiQ8i7isu3N+ZjLfw7ExtULGT7wCFbcOOwfm
	 QUNFGtOROf/FCD2W8OiDJTZsuFHPK6ceYI5mfUOXqxkMmEW7/hsUAqZZHXO4xU4X2s
	 O1m21CJYiNy1p2g0/Pu6unLJqZjJTvpuypXWjD1HJugNKj2P67QcRypss3z57//26R
	 T7cw7eu3UyC8A==
Date: Fri, 28 Nov 2025 10:26:12 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Usama Arif <usamaarif642@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, kas@kernel.org,
	changyuanl@google.com, graf@amazon.com, leitao@debian.org,
	thevlad@meta.com, pratyush@kernel.org, dave.hansen@linux.intel.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 2/2] mm/memblock: only mark/clear KHO scratch memory
 when needed
Message-ID: <aSlcpJzHw_khKD-Z@kernel.org>
References: <20251127203724.3177621-1-usamaarif642@gmail.com>
 <20251127203724.3177621-3-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251127203724.3177621-3-usamaarif642@gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 87A3B160003
X-Stat-Signature: haau5f7etn6ndwaxrqbiussxaf87d8oo
X-Rspam-User: 
X-HE-Tag: 1764318381-631201
X-HE-Meta: U2FsdGVkX1/JsPuejMVjqmAo7R81Csf2HCcuuOtPtoKfO4DeoZ4d8ybwV3j9eXWSWrDj0sFFmvnJ5PW8Uj/vkUn0zU8RJCYxfUM0w1KwBKAko7fo+KqO96Wi6IfezZWo3hzlJgwzhzCfOyStmNr/wPGpzHcg+H4pMw/Auu5WVN+m7eJKK94dR+sssM1GNV5ko0c2wn9MS8VPiEgaxEYFOWy8wF+SMwdxiaKuJQD6DLm/FV4brLgMH64nbLozBLg8wTbx9Q/DDrqrAN2FnjrNwznY2AzPiH0XwtVaX21SnnzhVupVt9/y9b0XNRBWoZo7HfTuPgmA+zJhAMjVbeU3oUeXB6yA2OV1JKGOz4isAEUNzqmKQADpnQ+ZATGFUbvNqINDmhJeTogKxLuSeOu06cp52LzR2p1W/mZ7HOmzWL/Aj9JdUpFfKgzc3MflTXnBT6vBE3+6pglvdKi7EdMxkCA5q6N8XsYbk4EPZHFgm8L4z1Lved7gsS7sx5XcUirsNFaTUrCyHo8ov14txevkA06HbjpLyNyUZ25bQboC6fidk3RsL6uZPBuXRhfVUU5TNgQDwJ12Dv8WkM8KDZB6rdt0LPZEcpvEzT8QmFv9CoqnqdUiQ4hc1edXRJADb7ozXAGHkEaK56g5lBeJkA2u3cPfRxRHf9BUj/k9z2/GipY00lRG/23Zkvjo2cj92wzto/C6HBk7yDdNtxkmF5E344a4BwbBCIaQNSZ1XxZSaondnbt0tJ11B0Jrl+stIYv4zp1CuylObuaMJ//Z98LFtWUL70b7BFxzqbldhFW4DM2O2q7X38yuXDzli9O3c66FR4OH8NyYEM85+4OD3xKHv/GDhUk7+rCC6Zxis7nMWPeGkDyysdUU6LMHD+K6pucfBHUOdNqTpSPqvEoVwzcip7QUlPNUGxW5ZQkN24ExhgD87VLx3cXXFIPp36Ki5xts4q1Rl5uxeDzSi3zcj06
 9Ixwh9AC
 kd/zzf3eilBGWwKbFFlWFlrXN3gpRSqiTiIrPiwI1+h/5fz4O0ddL64UeqIW+RkD56Lt8oYz3lZ1RHyj0nXDSr8b7PyPWBjH6ZgZYDWTpUvWR6gMnW/CjruE3HGckSBOF2VkbB4wkQZDwdywDcyk3dE5yrKabStyyg2RhVss6hfgNEeM8ff+tTk4307XgdQ+McOQmjRlN+etL89ARq+nODxptzzyuK4NoBI2FlLWejvaYVxRaErc6XTAa9xx5HaLU/LJOuh8Ddz+P0FDydKQ83Xe5DpGDE+W2TXjr5Wm3B0kUgD4uVysanD+i9aN45CI3SM+Jlei52N6c0kAnKvZs70k+tGYIiCT1lPhVp0QBFXjStP8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 27, 2025 at 08:33:20PM +0000, Usama Arif wrote:
> The scratch memory for kexec handover is used to bootstrap the
> kexec'ed kernel. It is only needed when CONFIG_KEXEC_HANDOVER
> is enabled and only if it is a KHO boot. Add checks to prevent
> marking a KHO scratch region unless needed.

Please add a paragraph along the lines of Pratyush's note from 
https://lore.kernel.org/all/86bjknyxgu.fsf@kernel.org/:

  Yeah, I don't think it will have much of a difference in practice, but I
  do think it is a good correctness fix. Marking the lower 1M as scratch
  is a hack to get around the limitations with KHO, and we should not be
  doing that when KHO isn't involved.

> Fixes: a2daf83e10378 ("x86/e820: temporarily enable KHO scratch for memory below 1M")
> Reported-by: Vlad Poenaru <thevlad@meta.com>
> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
> ---
>  mm/memblock.c | 74 ++++++++++++++++++++++++++++++---------------------
>  1 file changed, 44 insertions(+), 30 deletions(-)
> 
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 8b13d5c28922a..8a2cebcfe0a18 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -1114,36 +1114,6 @@ int __init_memblock memblock_reserved_mark_noinit(phys_addr_t base, phys_addr_t
>  				    MEMBLOCK_RSRV_NOINIT);
>  }
>  
> -/**
> - * memblock_mark_kho_scratch - Mark a memory region as MEMBLOCK_KHO_SCRATCH.
> - * @base: the base phys addr of the region
> - * @size: the size of the region
> - *
> - * Only memory regions marked with %MEMBLOCK_KHO_SCRATCH will be considered
> - * for allocations during early boot with kexec handover.
> - *
> - * Return: 0 on success, -errno on failure.
> - */
> -__init int memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t size)
> -{
> -	return memblock_setclr_flag(&memblock.memory, base, size, 1,
> -				    MEMBLOCK_KHO_SCRATCH);
> -}
> -
> -/**
> - * memblock_clear_kho_scratch - Clear MEMBLOCK_KHO_SCRATCH flag for a
> - * specified region.
> - * @base: the base phys addr of the region
> - * @size: the size of the region
> - *
> - * Return: 0 on success, -errno on failure.
> - */
> -__init int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size)
> -{
> -	return memblock_setclr_flag(&memblock.memory, base, size, 0,
> -				    MEMBLOCK_KHO_SCRATCH);
> -}

No need to move these functions under #ifdef CONFIG_KEXEC_HANDOVER.  We
already have inline stubs when CONFIG_KEXEC_HANDOVER=n in
include/linux/memblock.h

Just add 'if (is_kho_boot())' here and in memblock_mark_kho_scratch().

>  static bool should_skip_region(struct memblock_type *type,
>  			       struct memblock_region *m,
>  			       int nid, int flags)

-- 
Sincerely yours,
Mike.

