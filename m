Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 189A1F8D762
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 16:40:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38AD76B0005; Thu, 16 Apr 2026 12:40:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 362406B0089; Thu, 16 Apr 2026 12:40:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29F086B008A; Thu, 16 Apr 2026 12:40:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1915D6B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 12:40:47 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 43A1FE4A44
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 16:40:46 +0000 (UTC)
X-FDA: 84664982892.14.ACA246E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8882A180010
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 16:40:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bX6Niq2f;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776357644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IUZqLd1e6mQtA0r/0InujOn54jhuCfx3vO3Aq70vCls=;
	b=ssG+lpEUFik+gHDA9bnlLzjB++n4kZzPCbTgpycPvOMNspiLpH4wsvLdOh6v77nBel3uHq
	VP9bBE8Ehs0R0cykupN98PW0y4imADw2EnTCcrLR+dHssCrwqZSFcQllsdKmlx6dmAXeYU
	nThknpAAA9trIZIn+0Sg8PS1KEU9n+8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776357644; a=rsa-sha256;
	cv=none;
	b=yLoiUoWx6d+68Yw1JYGkgbpR9vY3NoBPidYBjRz/VDKTXdir6n1MEwLYBKax8Y1LdoXvFh
	PdHprLZ76fGW7IwnllJeiKFRPzxNdJl5uMMlntddEyqOW9M9GsSwvYYF8t1RAmuChFWk8l
	D6jzd+9VtH0suvhk5qdmQZIRCl/qZTM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bX6Niq2f;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 72A26440E8;
	Thu, 16 Apr 2026 16:40:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E96C2BCAF;
	Thu, 16 Apr 2026 16:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776357643;
	bh=lCGmJ3F+1zjEehNS6SOPtlYDsWuMjRcxlWpNpztwY20=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=bX6Niq2fCvU2FntF15yZDWJ/6kd2Cd766Rcq3gRZajZ7zH3dwUYzJXmr3v8Ej0VpI
	 Y+ZtIqhAupEVlrXQmQ8VS3DghuyFB5ZRtY0zXOhvSgnMw97KPaucJzr4KinUEczUZt
	 vbwJSi8fzOpDoIxZJa5Skk/0FyALPGDeCO96pXFXimupZpphGc0JKQEtmSQ/bi3c3V
	 7kEbSX0DJbwviS1cRP2J1VRrqS2AdpcLykzDmygRjkuduwfIPwBPhsAnu2Jf+JO97C
	 QPFjR8EZgaVOY4z2jDxxSJMLj/PyyrwZLTSwAQS55NRu/jGwNQ+TDD1mCHqRNGdOFf
	 Rh+gML+PhNJ0Q==
From: Pratyush Yadav <pratyush@kernel.org>
To: Evangelos Petrongonas <epetron@amazon.de>
Cc: Pratyush Yadav <pratyush@kernel.org>,  "Mike Rapoport (Microsoft)"
 <rppt@kernel.org>,  Alexander Graf <graf@amazon.com>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Rob Herring <robh@kernel.org>,  Saravana
 Kannan <saravanak@google.com>,  Changyuan Lyu <changyuanl@google.com>,
  Andrew Morton <akpm@linux-foundation.org>,  <kexec@lists.infradead.org>,
  <linux-mm@kvack.org>,  <linux-kernel@vger.kernel.org>,
  <nh-open-source@amazon.com>
Subject: Re: [PATCH v2] kho: skip KHO for crash kernel
In-Reply-To: <20260416161744.GA65710@dev-dsk-epetron-1c-1d4d9719.eu-west-1.amazon.com>
	(Evangelos Petrongonas's message of "Thu, 16 Apr 2026 16:17:44 +0000")
References: <20260410011609.1103-1-epetron@amazon.de>
	<2vxztstf7ys7.fsf@kernel.org>
	<20260416161744.GA65710@dev-dsk-epetron-1c-1d4d9719.eu-west-1.amazon.com>
Date: Thu, 16 Apr 2026 16:40:39 +0000
Message-ID: <2vxz8qam7ta0.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: g5tkjagokzdyszzhp4b1t3o5oapo5ra1
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8882A180010
X-Rspam-User: 
X-HE-Tag: 1776357644-331501
X-HE-Meta: U2FsdGVkX1/H1ZYVFziNhPT/ThB9wIibumiS8sIGL94yySVQ2KSX1XLt7UrTMkz40Oc/8ymhPtMakMPcMf3402YcX/jU0ucVo0cNbB6AJd4XpWXVJmOCKjgpowxYXpoo8XEnSx9MmNBHlGrMVL3SmT8n6TmWRDaaqcMkV//QNi/gyu3HCSsNtyf+HTydYE/KfBgpWQTI9nNHjmjZ+4uhvYC85/SrWZS7EsYz7qg/Rx5qhTJ5bA0GwIYI+j25xfGGyXqZQoPxY31KrVx3ALhcuwnhbLpqyrq8sF/WbP8WxhwINmNAq6JgtsvQEhwkSNIWlD0Omflvu87HDb+naFZK/TJcuEF/xJtwOAwW8aCI8EHSmIveABFTtP5/YhCwQmZCb0kFa4WhMGdQVOvv7f571wUh000/o2jXU8c3lWc6mGAGUFqdlfHyRM2Jblelj710BdUcfjMWkWXvVvwExrlYMZ8R5f0aqI4Xbnm06T8xBNIlFBZvB4497T1Bd1EH+2c6+YTJXwEhC1W0X5FpgYV3VnX5D6IQSpPNTMahH2KjUwdvA9rVnYyvoL4dq36oZPJaDug4w0h2r1STJe/IhF0a3AeYj3CeOo7B6og1CoIYqaMDqrWhWyetkTQEOr4Npn4s2tresaNEMWzGOjFEHZICui5MKVm5o/ipXZmkzbEzVkvZ6pSbHembktrtANwS/yl8KKttd+p2bS4KMkk3Ju7J6u4SIwkJ6tHEN/lcrk0XtOfHvae/0+NmCpmqWexw2uuhjN48Cwsx5mGY9Oa81hIndnUsQoS+ZwrJF62iLCEGZyADnSNzFPIC5QYddId2tMhzE8ivAe1MkTqH8GjnAsNwAvuXCfWiWMtCshGZzyKgqlnftmr7MzW1gBKTiNOviPYLFVGkNGwHvZC89FinEPNOs9eWi85etgY7AUU49NZfW3KrK3/c9wifQDRqahfyiukk6Oc8s1uuF+aCOB+TFhm
 4saKgHLQ
 dHKAcxkZB53Ofasw99Uj6aRXNDPbUxky4BaXWduYXq4+BHvMDUh1PxMqo5tlun5BAsmgOd8SJ4BJC0PHJVkzG/UkcBY7YX/0MfSsUuHny4+6GacYEvvoBjm47nHjAO+itSGDSWO0DW7G2s/s6+UvYybWlng4XrqrKYSEWo25f45Lrasc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16 2026, Evangelos Petrongonas wrote:

> On Mon, Apr 13, 2026 at 01:52:40PM +0000 Pratyush Yadav wrote:
>> Hi Evangelos,
>> 
>> On Fri, Apr 10 2026, Evangelos Petrongonas wrote:
[...]
>> > Note regarding backporting
>> > The offending commit was deployed with 6.19. The only other supported
>> > kernel version with 6.18, unless I miss someting uses
>> > ```
>> > if (!kho_out.finalized)
>> > ```
>> > which in the case of crash kernel it shouldn't be finalised.
>> 
>> While normally you should load the crash kernel early in boot and at
>> that point KHO should not be finalized, I don't see anything that
>> prevents crash kernel from being loaded after finalize. In which case,
>> you can trigger this bug before d7255959b69a ("kho: allow kexec load
>> before KHO finalization") as well. Also, before f322a97aeb2a ("kho: only
>> fill kimage if KHO is finalized") (landed in v6.18) kho_fill_kimage()
>> was also guarded by if (!kho_enable). So you'd hit this bug in all
>> kernels before that point in the very same way as today.
>> 
>> So should we update Fixes to 3bdecc3c93f9 ("kexec: add KHO support to
>> kexec file loads") and Cc stable?
>> 
> But in this case it seems a userspace misuse if it finalizes kho for
> crash kernel. Whereas with the current state we hit the bug with a sane
> userspace. Yeap we would hit that in earlier kernel than 6.18, but none
> with KHO is supported is it?
>
> I don't have strong objection for backporting it to 6.18, but it feels
> unnecessary. 

Fair enough. Let's leave it as it is then.

[...]

-- 
Regards,
Pratyush Yadav

