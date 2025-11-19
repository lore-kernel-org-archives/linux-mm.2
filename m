Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BE78CF258E
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 07:15:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB9466B00A0; Wed, 19 Nov 2025 02:15:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B69D36B00A1; Wed, 19 Nov 2025 02:15:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7F926B00A2; Wed, 19 Nov 2025 02:15:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 936F06B00A0
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 02:15:09 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C0B2A8857B
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:15:06 +0000 (UTC)
X-FDA: 84126495012.06.8156E8E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 25B5110000F
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:15:04 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mhzsuhQd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763536505; a=rsa-sha256;
	cv=none;
	b=Lr1IXT+wixmQi+REtPlOYooEdm4A61591A+WvlE7KEzZPN4UJzsEmduRetdkFbF66wKvTZ
	PKELtlsvhAnN6rDgbeQijF/4sj8Ts0EIXDDZswnRI37BFXJCwIbBBFwzKOLPnZGOsPm+sV
	N0YeR3vyo9GPdZeBUn1qnKD2aNHbB3E=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mhzsuhQd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763536505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wtaO5Ys1AQZRms0CqHXkRockgCcFIcP4Xe8jI7gJBUM=;
	b=zN2CK5Z/oRlpc9kse9PNHahaO8v04HW6YuRGWohqqOkZiYFLOkeAWY2l1mxPDP0UlZ9V7U
	vo1InhR2MosbUXvzOK/DUdjY6aoK5/0SsoeEk24xtZo0jpXX2V/3idjo8SnktfJ4GtyYqZ
	B1lzzem6JlCkC48ywKSL6oGwDnpZih0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0EA8B40448;
	Wed, 19 Nov 2025 07:15:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1EE0C116D0;
	Wed, 19 Nov 2025 07:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763536503;
	bh=85Q1fxYUc90RG8bi1kmn3NZavgBysfdLuTimKjiXkxE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mhzsuhQdkBNdpM22TohLCYrXugC3eqDOXwXSBlT2Kqn3T0x4zqom5ZBKDLT8BMYcL
	 6YjA/CQWCkydZGaSHPQc/q+Z3Kxfy7J8YOr1WDi2DmKmY81Ci7gFp+Ft8KZecP6JY7
	 eFDAnJU4Oo0EwGBEfylOcOpNeKIF6JFIQ5ncSJO5AeU8FZEM91xrIcFatDtPT3YIRD
	 MIrDg8lEUxqdPGLROzLl62TPJ8iZkgCjN0kYBFCAL9ATf4MN0V0mOtik9ylXL0rtzO
	 GgAHV4jY8JH51UsCRL0d8teCKcEt/nhsXWQFExg19GOxd9eVcQfO2Neu/ZPkJhs/9g
	 8pnwd6obqtSzw==
Date: Wed, 19 Nov 2025 09:14:56 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: add test_kho to KHO's entry
Message-ID: <aR1ucHaX8z9qV_oi@kernel.org>
References: <20251118182416.70660-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251118182416.70660-1-pratyush@kernel.org>
X-Rspamd-Queue-Id: 25B5110000F
X-Rspamd-Server: rspam07
X-Stat-Signature: 75on9j9utstui6a743iuauycatte7iqa
X-Rspam-User: 
X-HE-Tag: 1763536504-822861
X-HE-Meta: U2FsdGVkX1/UNY8cXdO4BcD3b07+74w8m7DH9ghXNxPv7LC3XwZ9mBN+PPLM4VYBHfE9709gHQnVzPF0iZjBo77gLI0ieVmjKVbXFdc5k3ZAY+gYJZ0Kr5v3N8GhD/IajJVaVXNMcJ0evJXVLNgLO/wUYNOJqW94hktgN27MeTuUlrMh7QW7nIQj7gR5aIn44RxOjdMbfOIIuwKIVDe/6LSZcU5nNVJdpMUXDLeUuUctuBGK6Srphp4snjXeUhMRYAoqx+zq2x2I0y2dbUWrA/dugeULLMuLHaEGjVau/Ii8rzjgYKhNp56U7USIe2ffd4J9zNMMEgEE17zreXlrmGV6XSV+qdKViohxJ/SoNwBwiNvBRZM+QmCzHhPK+4I1zGaVnUbejCnHKf9UmP1ZRXaZ9/8il4eusfNZCBxk/bQZgXEXF+8a00y358IHqfPkWLKQL3O5w7vCW9/o2lv5uAR54Eyx+prPpCgkR5o8+AvvArDNGWV6y2HI4MKNO8elNcFduNFGIQa2JMfj0lY/teurnWPo50ABDGQSPdtvFs3MWigTKSa2QOC3b+2mRLIbRZAV2W3s1JXOzr0d1+p9yw3skcNnZCx7boy1s99NHLUpA9UZ0T5MCu1NV9Zq4RnmAkQEGU32PQeXj7/rF27sddtvlIUgI8dVT8dKalPbDGASkCY/0kdFNHrtxi1sJHRz5jJRR+T5PBb4WJMYz58LRfbg26qxtlCx3PHvcB7hFIUuEBzIV+lNFSTQfrr2rACJwkvrN6z4IugiEMVDIjny6EQeivOHFIkdPyHDha21qUQ9lwbX+jRnZZcAS1Z3otJtMZsnrkyq3D0XHEFxqaLDlc0c6KsneiZVZL6n9oQuQCH2flRWdQd/rDaWpwWd/+KgLqvTOrNr+Itj3OakbErPN6LZWx66jOQtuNbS/jE80h3aTEhA3XwBNQxJEzp1fMqwnBOVpdNhtxsrjsSjpBr
 1YdcxRNl
 fuQITEaO3VJfWSoqxX5oYyOrusEzmv7peAZeXqE3iNLkdoPHz75KHg1faWmw3QRNRytw6Ib/5pY0FV8MBH/FbxY/8xPmwuKjyh6gbPA7O85NlCiskFK0aum+FJBd3w0oeLPtGMRELpT0RG1BEXoMsYmAtbawE9MjEZTYNkDm889yKznCkSTB5LPXarkm4cx5iq/FJPVMYvrRrSUYmKY9TlqKcs4i1r6spyWC+3gRjrnfZrOZ/cTm0krV0r9lKEGpUq0vTA0RWSzyc5h0aqC4XNpI9GLitryRihZcNZdUmmxZ2NUD0Xw0kkm82EzN2rmtEhNO2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 07:24:15PM +0100, Pratyush Yadav wrote:
> Commit b753522bed0b7 ("kho: add test for kexec handover") introduced the
> KHO test but missed adding it to KHO's MAINTAINERS entry. Add it so the
> KHO maintainers can get patches for its test.
> 
> Cc: stable@vger.kernel.org
> Fixes: b753522bed0b7 ("kho: add test for kexec handover")
> Signed-off-by: Pratyush Yadav <pratyush@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 05e336174ede5..b0873f8ebcda6 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13799,6 +13799,7 @@ F:	Documentation/admin-guide/mm/kho.rst
>  F:	Documentation/core-api/kho/*
>  F:	include/linux/kexec_handover.h
>  F:	kernel/liveupdate/kexec_handover*
> +F:	lib/test_kho.c
>  F:	tools/testing/selftests/kho/
>  
>  KEYS-ENCRYPTED
> -- 
> 2.47.3
> 

-- 
Sincerely yours,
Mike.

