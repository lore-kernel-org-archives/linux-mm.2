Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6CE2C8303F
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 05:47:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF94E8E0120; Wed, 27 Aug 2025 01:47:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCFD58E0105; Wed, 27 Aug 2025 01:47:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0C528E0120; Wed, 27 Aug 2025 01:47:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9F60B8E0105
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 01:47:13 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 393F3C040A
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 05:47:13 +0000 (UTC)
X-FDA: 83821454346.01.E27DAC5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8B8CD1A0006
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 05:47:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pU97S1+E;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756273631; a=rsa-sha256;
	cv=none;
	b=iF2mSojsLn8BhR5cFsJRnllPwoTBKbnwe4wdJKo36SA16X9/yeS1uJYEAnZzX04nVnHoOD
	ktn68P3ln1B701UnhIokURdke6zscy//Rgf/QEAX+c18vBV97oGRGFcswS15NBNqN7xoXC
	gjj8Lk/x2aY50AiVEO7JDbl6qtro1Rs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pU97S1+E;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756273631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qlpP7YE/MqKuwxg9uA1aHnZFSu1mBt3hrTsCE0200RU=;
	b=N+3D7XNWqfGbEkf5CcYwMUqkxPBXhsr+ApwiDLveXdeKvjAbLmB29QDlc4x3Xd5jw1XGPG
	Z1Izb9YTfRDFTcsijO4iOwnaEvZaf6ZL2szrCA7mQz6+6M5z3THdTwRJs1JSvJ0XF6kTVd
	2O1xL+u5nCqG8SfWonGHQgYf6uQE5hg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 592AC444BB;
	Wed, 27 Aug 2025 05:47:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38DC3C4CEEB;
	Wed, 27 Aug 2025 05:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756273630;
	bh=hoEQy2EMzAl/DWp425B78q++EJxcTbj/XEoxlK1JLgo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pU97S1+EbF20aHx2YwKsA40Iv6lKwnnEYv+9jrBZ3Ds2AT7wiueBxdNvavyadX7PG
	 NqOX38GyyIcM+7jag8bTwO+v8zGWSfTmfWy4GOT5+Q0HqUK66pgh/Z3CAkehQRHD7N
	 0ETaa8miJK4GCSLLvZRuiEEkdn4L290ff5ndhE52We0JAUtC25nkt4IfII7MYVg3Db
	 7h8q2pq1N2QJqeoxQSWSmFrXJhWJi/398wMTZ/dtQUwQ5y/jUq/EGhkfGVX2zBfc+v
	 2As3XfN8VV+9K8vxBscut4Nez2H1HBDSZeISIhs/HzLz1Belx0dTrYFTX0XeA5Xtec
	 uABcGPypXjQ8g==
Date: Wed, 27 Aug 2025 08:47:03 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Changyuan Lyu <changyuanl@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kho: make sure kho_scratch argument is fully consumed
Message-ID: <aK6b1_UI-xw2rtlZ@kernel.org>
References: <20250826123817.64681-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250826123817.64681-1-pratyush@kernel.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8B8CD1A0006
X-Stat-Signature: 6fj7ik4paz77z7mb6iqb49zereo8swqw
X-Rspam-User: 
X-HE-Tag: 1756273631-319828
X-HE-Meta: U2FsdGVkX19C8C6KQZIdLUw0J1EEeAn80vH8n1HCD18rRXeffB+YR+lk9l9MwWFB0pdK4IRqqtDJi8x8bNiw8VvqNDCBHHe3e0fTyd/lp18M0i6B7k3mS32a6kBxBDdQLOCIo1bBzzPehy2sb7MndE/yA62dHpgIziWIeP/+D2+MlcUVEa+NA2I0wFkbVxHTf9coUFuyWGWfjqg1fS7PIu3QrwYjpFoSRyCA+A3WVNOcpN23dejoPg9Ilai5D/55ipbBSXBXeohl1jl/t3GCE8hEc7BkYU85inMqTy2wygAZ6IGUkdPbK3PT5JisYLkEfx/wwHC9dQK7TT2QDb2NO9IOWEJsfY9wL+XAbfZEIlcPV9nxtXKmxTHdBRX+Xau0DbYeB15v/RA8a9bsBQYS7Ct0LtU8nlF1jBlHAr6w5QXcZermHXTqoyy5NpHRaiLStZtQR7tDWNUSgHSO+BhenzDt26T7VtdB3la9Wq0FdU6aoTccKUyVDLotfnMYCDm4IOl+EwKJtFWMn2ODtv6LuADvptrT8U15Bd1ottUnbXHODLVrmouqUF1NLz5UXEuzDbLwNqvdv2ZoBNe1ynIXsbb1wQ13+j0VF7vvKEUqP108JYv6Db9Frmnuz9yYN8qIIvPETZyWGzJ/HWiq72UvijjScujQNCIfk6OYEIW28cAZzzRht6c9xAgDdzeo8v4mQ3RF9q7YYwnuyZSSKJDQDEbtYaYL8h/rt/Ek2TRwcL+2nFWYUQCLTDERugPUOUPNaOvBHU0wta+J3lGBKtqfX1wOfHviuQnaLjCryoZH9PRsM0iG9wPV6zj9O34aVeU4tfFQtOnBMD1CKQn2KBTaDfKwP44QWzSToiWVAejxyU35oTyOpZI4aiv00g+l9CTF8yWkEconQCKONMPikpi72AbboTKUQIRsgDcT5FMlQ8cP7OHV7KKyTwAKvW1rZmw/yfF/0Vk0jIwCkeoYwRl
 OOyrIpwY
 xP7XcRyGqMW3Qxtr/pmWWhcNumTul22XUDv07TFAZNgp/FIDfLOYm3U3+Jrb/HbAHCBfig2EPcVzPuFWp+5WyfO892vJ07tAnTedZxoRMb7P6dv/b0BjF5zRw8LzmTt3c6poF9hQE+oPgLwqv31ksKKapL2DiKnHPZS0RtJ/rOEFi7mzbGGaffYBGYo4JS9UoHnWWjuQ4pXpZACVhVtM1i071BvthRTlkSiZQ37MND9iA3b4nVRC/s58UNKK3XVzp6jfK4kVDfXOkyrNrRdTcaalybTCtHjXkCct2Cp+YcxrkdaIg3X01xY+d8q+eZllnJV+k
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 02:38:16PM +0200, Pratyush Yadav wrote:
> When specifying fixed sized scratch areas, the parser only parses the
> three scratch sizes and ignores the rest of the argument. This means the
> argument can have any bogus trailing characters.
> 
> For example, "kho_scratch=256M,512M,512Mfoobar" results in successful
> parsing:
> 
>     [    0.000000] KHO: scratch areas: lowmem: 256MiB global: 512MiB pernode: 512MiB
> 
> It is generally a good idea to parse arguments as strictly as possible.
> In addition, if bogus trailing characters are allowed in the kho_scratch
> argument, it is possible that some people might end up using them and
> later extensions to the argument format will cause unexpected breakages.
> 
> Make sure the argument is fully consumed after all three scratch sizes
> are parsed. With this change, the bogus argument
> "kho_scratch=256M,512M,512Mfoobar" results in:
> 
>     [    0.000000] Malformed early option 'kho_scratch'
> 
> Signed-off-by: Pratyush Yadav <pratyush@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  kernel/kexec_handover.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
> index ecd1ac210dbd7..a90d55121a7a0 100644
> --- a/kernel/kexec_handover.c
> +++ b/kernel/kexec_handover.c
> @@ -446,6 +446,10 @@ static int __init kho_parse_scratch_size(char *p)
>  		p = endp;
>  	}
>  
> +	/* The string should be fully consumed by now. */
> +	if (*p)
> +		return -EINVAL;
> +
>  	scratch_size_lowmem = sizes[0];
>  	scratch_size_global = sizes[1];
>  	scratch_size_pernode = sizes[2];
> -- 
> 2.47.3
> 

-- 
Sincerely yours,
Mike.

