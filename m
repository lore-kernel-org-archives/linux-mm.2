Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CF2AE784BE
	for <linux-mm@archiver.kernel.org>; Sun, 28 Dec 2025 19:56:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B06BE6B0005; Sun, 28 Dec 2025 14:56:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB4F56B0089; Sun, 28 Dec 2025 14:56:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C0D86B008A; Sun, 28 Dec 2025 14:56:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8BCB96B0005
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 14:56:54 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 16E8C1414CC
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 19:56:54 +0000 (UTC)
X-FDA: 84269937948.15.FA3F2AD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 78E2E140004
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 19:56:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="srfmoM/z";
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766951812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CJ/a5wItBY6GD4zGolKbvAlj2se9EVzOmn45HX6GFro=;
	b=8BC4BvCfFlyTkIkl8WUsC721fUJV/8qNoTSPf9Qhi7XApjEwJrKH6A+yLpPGW5caK7NCyD
	oH9pDVGy/f4sQ2xIC50VEKv/0qQsj5nSOrMfHiXfoVUWvXxjVhdtY+DpyXvgrLJBwRKIi3
	7Wr65ZIYmBU7GQ5bOQmquaKliufb+as=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="srfmoM/z";
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766951812; a=rsa-sha256;
	cv=none;
	b=hFXY6kPwf7nC2U/I+Q2UHOXYVWV8/xM5sYMBtnMZjlqKSBYtJavAJtKTE5xEzIAouu95K6
	qBaOp5MpQBLTm4t+J6Xxfi8LfZdj0fEOMAR7TE9cwNwlWvOBtu0LypTXxv2BWgik8MKvnn
	FZJTBAiee9BdcIf3glgy2hiMT6SDX5A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DD86E60010;
	Sun, 28 Dec 2025 19:56:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B29C4CEFB;
	Sun, 28 Dec 2025 19:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766951811;
	bh=rN34RmzLj1XbJv1vaWhI18GdGzzhsPmuc3P0aA9wQf0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=srfmoM/z+L37OjPSN5EAPW+VmuxEdPB+px9MHokyQImZZuF8uTNSYDumiZJ9x9Y61
	 Ci3s4g/g+To67d3GchpKs2546+dViZGzYJ0Nh+//tpHisaZORNfBfaV1bmfqhauy1D
	 zsq4ZQRXN1UszKfSUeiDaaG7irfKxmXwvRU00WLswiqyfz+DYw1lie2YHlcoQ4ztQG
	 cW9ak+EG49P4qG6fStyqWnvolCbT02LLIhm2G6e1158r/nX95+VXH+cpKj54cROGN4
	 iGPBAzBjo4zjWGIXPuNpBl1uAVpCMYBLFtpaVCvDRZ4uRGsXF5jcpFzGIVqNw4129f
	 gRaUZLOUPQ/UQ==
Date: Sun, 28 Dec 2025 21:56:46 +0200
From: Mike Rapoport <rppt@kernel.org>
To: klourencodev@gmail.com
Cc: linux-mm@kvack.org
Subject: Re: [PATCH] mm/memtest: prevent arithmetic underflow in end pointer
 calculation
Message-ID: <aVGLfmQJf4BPDTUq@kernel.org>
References: <20251220151019.19473-1-klourencodev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251220151019.19473-1-klourencodev@gmail.com>
X-Rspamd-Server: rspam02
X-Stat-Signature: cxgujbmaqa3ydjwehuxop367txnd6i4u
X-Rspam-User: 
X-Rspamd-Queue-Id: 78E2E140004
X-HE-Tag: 1766951812-653896
X-HE-Meta: U2FsdGVkX18PappyIbShOdGKWSAsDHdyDJxH6WM+8IwY+1vBnxVVaDuDQYQDvPaYNFDYkvmiAPnfCvWsPa7YJzHUi39t1EDfKOtHipEftSiMSId8t5eylaI0lDzm+J7VETzcKtoRqerDMzIj1OvXYxH/xsjQzZOl7iwBIaqDPv2S7a8qSuZOqeDtgWbEynpyL1k8l1+n+CS93ZSl3sCPCQd+vZwoVwfNg0RO7vGLh3Zf3lKW3lURPrBXU9wuhiJXVY77/9K3Ld26tL9mRdV3cZOUU5uLJkiWn35eiJzRBEBufsfNKM9Aj0LOS21i8UdQFkKSSHeGI0q3aJ5uFFWJK2rhXATqIBefhESHz1U0WMnYgmhjfjXDvWnpIYfDTAe8c3dj9cMnh061vQW4A/k3gR8Lk0mZhJAA7tgimrbA7GCB9HwgM16e5/PsgDQf73HZTd0OzyikE1PAj/p4pzuOX8LPAwdMgWPnAfbfxDJwtLl00Vr3vkPEi32JHrv+ZlvE+JLxSJPXES8yJTiJDmqnucN2x4eLm3igFGFb559f+Yglil4oMZdOfr/b/COl0QwVCkaXKjhInu+Nx540iJoPogucKL4S8jMkvM3B++zYQPp5YU7LIvu7S90uRPwKG7P33K8X9EqYBna4NUkQ95bRTZd8hfSdZr4XZScLu+q+7qnTgAH1EhSQUI0mpnpORBBWWMTod1kN31ypa9aNn7zCLsh95PmoEJemZcTiIy/VNqQs/968gnRsRSb5oIUFkvPmIzCQRc3eeWDBao2o7i86xrxlx7kUHqFr6j0xFj+gw9SEIF8uJZUIxvS65UM7u/NF/Sb6Mmu0tigUQ+3V81JSql+K5Eu3UA6XEYzE8xviJueAsQZtdJqXkrI0QMGu+U36lOrXA0hmBBFWpf/vqQeCQ23Od5NOFCWkvXfYEu3rzl4NuJU5vQggJEF7QFHF1XKq1JEhpy5SBCEHPZ5uM2R
 Az+4fpMS
 CBoZQrThyWNp0WcHKHrvNOr0U0HdTe86q6y89hR8qChtiNPIWEL8c+uL2KK3JrrWqEVvl8u9GDadFnVyo9X9fC1YhMOt2aGyNODl8MzYlzUksT99003/e2F+DBYjbaTk0lDXO+wAI4QJ1LfN+z4QpbxMwXjIfgCl7c4P4hV+5xuBogwbihtIH0sfnFsOSGGKA/O7eBNcIeLsETC31cHjH3rJ426TTMD5vH+VzMA3gh2uc8AJ2X1OX96GBxXWtnKsd4nn+HIcgFD3c2lLrCJAYSFg3BVWdo3Of8BYOMpruR7dqCdPH2Ayydl6J/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Dec 20, 2025 at 04:10:19PM +0100, klourencodev@gmail.com wrote:
> From: Kevin Lourenco <klourencodev@gmail.com>
> 
> The computation of the loop end pointer can underflow when size is
> smaller than the alignment offset:
> 
>     (size - (start_phys_aligned - start_phys))
> 
> If size < offset, the unsigned subtraction wraps to ~0, causing a

Is it exactly ~0?  

> massive loop iteration that writes far beyond the intended region,
> leading to memory corruption during early boot.
> 
> While unlikely in practice (memblock regions are typically KB/MB), cost is negligible
> (one comparison), but it prevents catastrophic memory corruption in
> edge cases.
>
> Signed-off-by: Kevin Lourenco <klourencodev@gmail.com>
> ---
>  mm/memtest.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memtest.c b/mm/memtest.c
> index c2c609c39119..d86c41f1c189 100644
> --- a/mm/memtest.c
> +++ b/mm/memtest.c
> @@ -41,12 +41,17 @@ static void __init memtest(u64 pattern, phys_addr_t start_phys, phys_addr_t size
>  {
>  	u64 *p, *start, *end;
>  	phys_addr_t start_bad, last_bad;
> -	phys_addr_t start_phys_aligned;
> +	phys_addr_t start_phys_aligned, offset;
>  	const size_t incr = sizeof(pattern);
>  
>  	start_phys_aligned = ALIGN(start_phys, incr);
>  	start = __va(start_phys_aligned);
> -	end = start + (size - (start_phys_aligned - start_phys)) / incr;

I believe VM_WARN_ON_ONCE(size < start_phys_aligned - start_phys) is
sufficient here to detect those theoretical edge cases.

> +	
> +	offset = start_phys_aligned - start_phys;
> +	if (size < offset)
> +		return;
> +
> +	end = start + (size - offset) / incr;
>  	start_bad = 0;
>  	last_bad = 0;
>  
> -- 
> 2.47.3
> 

-- 
Sincerely yours,
Mike.

