Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26592C79FA3
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 16:28:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7797F6B018C; Mon,  5 Jan 2026 11:28:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72FF86B018E; Mon,  5 Jan 2026 11:28:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6294E6B018F; Mon,  5 Jan 2026 11:28:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4DE726B018C
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 11:28:00 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F38B81601A2
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:27:59 +0000 (UTC)
X-FDA: 84298441878.01.AFBC5B7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 45832100008
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:27:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qSZNzxuS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767630478; a=rsa-sha256;
	cv=none;
	b=1ExtFeS2iNFY5BGnegK1Z/4Nr8CF9s1upnoDiTAEdVXWJmb1GbA6Fe7xRFlphp/dhlbdWG
	LaN5XFai7RE24z0b5Kcah+M/bNXfScfs260x5BstiZvjV51p6LU4gmLxhPVabZiPz0ik5E
	cPaaHkJ9Q6d0F+7pln6+OdJrblE7Loo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qSZNzxuS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767630478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Plf+CIWHxwvwTbVTcjFfDO6MsJFFMhHXH8fxWcJAjLs=;
	b=z03OlbK1K50n6wkzgm8Satr3+QaXfTfxG7ClveVsGQU298My7SX70lcwKbYXVD0s1uWEna
	Bfz6Vf0K3YYAtpwgnrhi19n/VBA7J9qUJAA2q0zcyTbEXB27y4jn1QgMUs96SmqEOVj2RK
	DdyB/LCaIrs+4ZlixKBiluwCoULmK84=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A543E6013C;
	Mon,  5 Jan 2026 16:27:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CEF9C116D0;
	Mon,  5 Jan 2026 16:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767630477;
	bh=/xldXt0ZTEtlBZnN727Bl0SHm6j6KmRJZBIePEBGVGU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qSZNzxuSkRIaAspqW/kVZv8G1aFRRlHNYL9ruZZx2gOJyH/VRUPG35rWEnlko/7gK
	 e6U5CCkts0cRPE6pBKe3SDvW1J3NBm+/dKBk5029l3PpUYwYIeQr6zhcTDXJw178Cg
	 j7e1ah5baO3SPwekzj1Qbigf1iQxrB7dt/7qm+Pe6jr2f+aErOlG16wBYQol6Mgbf0
	 hCcafZQXNVjottjb8oVH/DyeEz2FBaVwcgB8MTGyx5fs+2/SrhY04tVPgp8x+iTknn
	 VxrSVjfHWcRm8nRSS3Cjy/pXKT8gyqgP1KfURrxV7wA/jOz2vvk+LiVE3cdSoeeFu4
	 jF/83z3OKf3RA==
Message-ID: <c2b81430-e89e-49b8-8557-1a374f2e6d01@kernel.org>
Date: Mon, 5 Jan 2026 17:27:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/2] Optimize zone->contiguous update and issue fix
To: "Li, Tianyou" <tianyou.li@intel.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, Yong Hu <yong.hu@intel.com>,
 Nanhai Zou <nanhai.zou@intel.com>, Yuan Liu <yuan1.liu@intel.com>,
 Tim Chen <tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
 Yu C Chen <yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>,
 Chen Zhang <zhangchen.kidd@jd.com>, linux-kernel@vger.kernel.org
References: <20251222145807.11351-1-tianyou.li@intel.com>
 <011e2691-994f-4038-adf0-02e899eca777@intel.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <011e2691-994f-4038-adf0-02e899eca777@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 45832100008
X-Stat-Signature: 9a1b7p4sqjp7md7buuseiwq3ife4d4fz
X-Rspam-User: 
X-HE-Tag: 1767630478-687848
X-HE-Meta: U2FsdGVkX1/9OJSQcA4sPSjVjLfIG066dzof43HE6PnhmxHl749uWvTiRDsfKtwtE7Y/aDDtEj0IbuNNaWdzVUhAfS3bihSn6ynYLkAqAULjZRtWv0lkvU53VN1yRsxrZu9oEesVLBdO3MCaN+MonMgCxEQ7m5XManez/n9JJkuelZKYuNmhHViGDk9B12dxIZwWEz28dLtmyp8VppNgP5JF3ylgch5hylLz8qGI7Z6hH9p0P6DP66rdQ07uHrINIBFeqYC2qW9ciAvh6bSnMRCF/XzX5Hv6/I9EaL2Hm26MtIZapdjd3MVfhMpCQeyxQfeICl9LOvNIRgBZfwYvaKbF7SXrZ+YmPAGdQlMDucWi0mInDxzbKrRkKJE3Eq9FshTEeygnpISrdN9JFVCp7MGU7c7iZel+U8FtIilmXdl2LiUB9kMP3bwnPL544zHm/7mIEUWSb2WxKmEOGOdt/EU7X0+vc+HcgK8UocVur1oGq2TwYpCai8ZZUyBNY9VDA9sTd6BC6yfba3UVTx7P0SayVUSExhj/d3Vu0SS189nKpY2U7UJz6zan6zZOjhX33DMn34yIcacxsfgLUhSfZf8xxuHc2CRbBgpxjDFra1VfvXNfOBlAshFDgP+azOnPgJNOusseaR5KQC/Y8X3lrktN6Z5QBVQd0OZDFfrGhSyKLIQSB4vn6XSFWvYDUX1ZeIgftDpuOK6j9NXR7PKuqqXD4900Bg+8ZwNj0heLGq2NCsAUY6e/KFXhoLuEsYzMbVxp3+GXSB5XZ2fuMuoFwzWZRlISPkkiXcVqLVZM3aNnvjl20+WOC8kmsai2E/LgVEFMq7v1mvwq49LUUkFQQDY3aEBzfMoBNFiSrkKz6ntzyj78pSOMaTdBOKUhFSP0Sgg2Ts6tAIuU7jEF4355tv5jrcxlpGfPRHCoKfpXOgBLzm1I+5Y31ey8DCzkKjGLIDfdDSA+B58JG2H/8uw
 Sx/TBDbC
 vACCOiVXFYxBQG/uunT+CIqwGo7XoNVQxMtACuj9pOemngKRgpeE2VR1RO9CmWO6pUnjfIbnCeih8tHO5Jqk7vBcbfAQH1dw/MAitBOWNON3dsTj9b9t9tBw15SHwMh8vQ1umRFLEFxOYxYf+M9QPsc34vuUg9DjF66Yem/tOTGT005k9O2tiTCmapLypyTYDcdgOAb2zA8dz38r4/74dqUUWkv6TkD4Dy8aipK/8MU3wvxsgi4VCJSuqX36QiiWtWp0FOoi8mQZ3gEfLGI9x7FGUXeZvA8Q60sbpyNXYoy4NHyV7CaBOiXSEfmXK38+nknI+FEkC2pnIor7/mtaasRgRb6qV8G0V7k+lPBNtwUlJQXkdHcVdRDFK0zrFgribOpNy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/5/26 13:21, Li, Tianyou wrote:
> Happy New Year!

Happy New Year to you too!

> 
> Appreciated for your review and looking forward for the comments. Thanks.

Sorry, I missed this version (and the previous one) as there was a 
problem with me noticing mails sent to my old @redhat mail account in my 
@kernel account.

Will take a look soon!

-- 
Cheers

David

