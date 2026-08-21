Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8958DC5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 11:51:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 928266B008C; Fri, 21 Aug 2026 07:51:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D9226B0092; Fri, 21 Aug 2026 07:51:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 815A76B0095; Fri, 21 Aug 2026 07:51:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 614C56B008C
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 07:51:44 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D290FA2DAA
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 11:51:43 +0000 (UTC)
X-FDA: 85125112086.20.C747F04
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id D3465C0007
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 11:51:41 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eqeLOlyR;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787313101;
	b=NpZIwEb6vp4L7DBZKIMjxVQzHhKNT7Hxix5eI/IWDQNIzgSAfBoWZnNZT5p6jFbVww6l/j
	0WxikXMUfFCnX3R5SROeLltpLPbBWkX9FIGAokqVXept3ZBbYXCgYaF2SM245luMmsncaZ
	uVXkR+6O/GkCoJZ/o3s2/oh9G59xH5o=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eqeLOlyR;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787313101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sBpMKLMCpV2AxfNqRU5qSpbkRSV1+US95VjWx7rNRF8=;
	b=rUJX4tjEuIL+X1Gb1uhwbtLloEcv8azAzBwajl92r+c8Lh624qGz7uTbQqzph67KY8yNC4
	3qtcrKGR/XDRCY3bRuyDkFtrDKDLSPKAUPnsXzVVOWn5q1HMHZ/vG7fFvvAoKe7bpO9lXT
	j9KFo7Nxh8iUoFNf7n+fndjzU/TmvmI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BF5E342DF7;
	Fri, 21 Aug 2026 11:51:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF6D1F00A3D;
	Fri, 21 Aug 2026 11:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787313100;
	bh=sBpMKLMCpV2AxfNqRU5qSpbkRSV1+US95VjWx7rNRF8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eqeLOlyR4+rgSoG3eVry3aEncsV6Y46NTXrIU+4B1Ewqc9OkFka8zAwrx6AxpmcMY
	 1/RgrhvVcCqjpoexzMc1ZTPySmd0VMgynpzMy2tA44sfXlHMtF7nqi2qo+sN3YVoMt
	 5gP4EbnTlC46kkBUEdhW00pSr+5ZChFtdUVZ7tnJSyfI8Uvz8Ko6qpnBBtxal3h0fJ
	 CdLYKOfwuCrB83yvhsF235Z9hJu/E+fsOLm77D00KgCcLbmSTko3B/TN8T7OaDoYS2
	 TCSWbCjz/mC4p2rF1VsVxo99rneRyVOzfxuYqVZ7ciN191NmPmbXjd5Y71eiuc5MlJ
	 WFs2vdm0DtBBQ==
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfauth.ams.internal (Postfix) with ESMTP id 72BA11980052;
	Fri, 21 Aug 2026 07:51:36 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Fri, 21 Aug 2026 07:51:38 -0400
X-ME-Sender: <xms:xzuIao-UNTuh7jdnMg-X77Z0xxMkKq3OlEUrkuxpz-IlLBBhol3buQ>
    <xme:xzuIauIA96Foe0bv9NGipTbBqiztVzEXtIvkcwRIlfYCafITkGIZ0qcrU34S41Uo9
    -S0_DsRhUonwIwz-4VLhWtrVZaZ_IS33LfGWXTsjxnQ8uQJ6jpZao0Q>
X-ME-Received: <xmr:xzuIat8nn8vxcLyjvU-PUwhAGkBqmf94OXOtZqUzKmXRBrPwhH3-GylGf1g>
X-ME-Proxy-Cause: dmFkZTGkobwOJDXfmDVQnTznTajLF1+gng1DwxP4wyWzTCBiX4TmWfUTIIyia2/B+dSgwA
    STm0VnjeA3gf6v/mcV6BalUqH8ECjST+EleofvJRKrsyN2NupbIpJquZovYUNNk0U6Eomu
    WhAtF5pnbt7hYJtbns0BYqJTie5NhdvuO1mhJgr4BELW3bCr1zqqvJcro1IQSF2ZKXB8DA
    0OQXpq/9SOu19gzyOKSjGFBwxEyH+DhBFMLo4iiWifqLV5zkS/ouYeekSqXQFPoPPchPlr
    CO74nMl7Eikd90vhEMTpNsEBcdkVE9IgK4oQEB2sJSIkY/Pecf0l2qm3eHkbY8CRnkxRdQ
    5JCqN3LVGR8BRgIFSZ3MsakQ5IXa7UU/uv4Y1/kU6PoC7jhSmdoDZOAxAWyiakOKUJ6UKu
    EcX3j/zjIM8WAmWhziX24j8dcoJUnn3l13AJ4oN1zKBwmBvCHWK2SoNIvxbme+VmL6x53X
    I7ONH4f25zJDU9t0KejOxyWwabWZGwjKWsi/BE+TY5HeArEUswR9Bu2dK4iei6/6AXhlIQ
    5SkNJohggZqlHZgpYtWTZxnvPK2oqQ5F8MvAn1xG8iraX6BbsKZltxe1gP/36QTzpJdAS1
    E1ApgNmjYzxh0z7R6fhuUKPP7EQmUhDqtbi+YsifOzYWAThUnXMcA52KK1sg
X-ME-Proxy: <xmx:xzuIaqHsbj7vVwwwNp5W5D_DmYi4s0cMkJC0VbwGkiydyrbzCFyoAg>
    <xmx:xzuIatO-Aystk8z6Aej9SnIgmw1uvm2drJdWm04g2LCTwBoQmuDE7g>
    <xmx:xzuIapQD7IO_EW7A8eUz_MZhoL7Hoe-6UI09xnUnZDyGBUtBzmxlEw>
    <xmx:xzuIakTn9SQe7ZjkAN0tZ4IiQMaplFTVPI_umTFY2LBN2VE9KiWOYA>
    <xmx:yDuIajbvORkshWti5lpU2jvUvh80MNtzsmL4ltiYN-8XSzWRFfDjgs3P>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 21 Aug 2026 07:51:35 -0400 (EDT)
Date: Fri, 21 Aug 2026 12:51:34 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	rmikey@meta.com, riel@surriel.com, kexec@lists.infradead.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2 2/6] efi: add the LINUX_EFI_POISONED_MEMORY
 configuration table
Message-ID: <aog7bwfMVpSy9LcY@thinkstation>
References: <20260821-hwpoison-kho-v2-0-5743791e48e6@debian.org>
 <20260821-hwpoison-kho-v2-2-5743791e48e6@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821-hwpoison-kho-v2-2-5743791e48e6@debian.org>
X-Rspamd-Queue-Id: D3465C0007
X-Rspam-User: 
X-Stat-Signature: pfppowomu7zefnx4fymzgnnbsdnur4xi
X-Rspamd-Server: rspam06
X-HE-Tag: 1787313101-118911
X-HE-Meta: U2FsdGVkX1/P0s6TVshNjUYpryznixSt7WzofA1qwVW5ryDptiOcNyV/w/nEpAEx4pVO7D1KR4YCVLNulAR8re4p4+RS7ibrLP0zxYjzPxANtPe9iQWWmwpb/8DPf0pEYt8E8C6I0Kwl1W8ogmPijH9ni9qmlaXXlONvgkiYAwpgpc/84uswhGDFN5H3kWLl5Bf/H1Zk/gGpl5RtDA8AmgzyDBIWWPSkC6oyPgngQtvGwahLwKChnQeCv63DyrBK2iBUuESmAzf1m4ZMGA2n8/l4PxhYwTLrt4xBFDBiby44OJeOda0OQewv++6OxfG3+JlskqfpSRSZVahxQ33v3SopnJIcn5vZXqEGt7fRyxpu1AVGuSBQ5qKHLsSFp4wNxO0lv9LRzhD9/OwMJ7aJUehev6TOdoPl0DWvDrk4XTeG/qqYYV7tSqxnnmb2ccLmZg09TWPnqG4tOy7BVWUe5stkZvy0JmUT8WaU2qKz1+ncFXvy3OcHKgZUblS+R6MfNbsBbWGyyJF0eNIj13QyOgRql7+rnSLL3wyLNd/+Tx0lDQbpZ8q9+cUoAWS0rcE02oRD/Sr2SkUq1t1GClXXJRjJhsznU4aKplJ3S5w8dsC25p2IhMwd8ZmKypxanJxVJNbYUhhQX1VXj68UM8V+U9GxA7cQTip+3ngsenimmCotizEgJYoy5I7ApukO8m7Yk0zVvlwmj4VdKosqTlUtvG7Cw9aJA7+YrMc8pVDprNv076KYn1Yt0ns/ssvBx96iVzVJ9RS6YiAj27gWFKHa7BgJQC19EH+X8UcMavR4eBILur+0mU1lELIVimMhF1vHlaAKG4HMK7Kk2cGfMrUVf1+eiF4/8ysE91J/ZP5+FjykoRjD7l2E+ETcME4ldoKY4tcVQzup6uWLlunjZdec28umds16FqWA5lkyRmttb0oPVFCbp71Gl+mGj9LqHstWXvoZh/KjMDBvnR4s4/3
 cfvSBLTo
 9xSr5ryI8rbwlRhplJ87gP4/nmqdpeN1NAMTD2ZHUP2LcUi9TLKKyboAMXL9teUh5H82SRb6FXB7mcIw/4Rq3HAdgbDofReLIWtbLnKAtFimC2sOdZtqgvtDMw53HKDwp4nvoNuPYWSad+tN7c/fs09T9qCelV70DBfvLjY/lROMDeTMm/wFMxogU1WEwyT6wLiyF0+aeZ6DvjBylP85mrLmD1yF412LcK56pT6tRN0kiWpaXWD4TUPKsAhH68P2CNMFyzmdnQ6Y4IEAI3P8c9uXajy/0gYmiMqWepAt/Z+MoZujAmT352TzpMneNOgTJ9FMdDXrZRgoT+sDUFOmHtuE7Nu9y2oHb4H9/5Zs8XDx07OJpqYQ1nKpgU2O9o5usG1UadeLIp1Qr7z/B5B4myR9Y9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 03:06:02AM -0700, Breno Leitao wrote:
> diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
> index 29e0729299f5b..69c0dc02bc112 100644
> --- a/drivers/firmware/efi/Kconfig
> +++ b/drivers/firmware/efi/Kconfig
> @@ -263,6 +263,16 @@ config EFI_COCO_SECRET
>  	  virt/coco/efi_secret module to access the secrets, which in turn
>  	  allows userspace programs to access the injected secrets.
>  
> +config EFI_POISONED_MEMORY
> +	bool "Carry hardware-poisoned pages across kexec"
> +	depends on EFI_STUB && MEMORY_FAILURE && 64BIT
> +	help
> +	  Record page frames that are hardware-poisoned while this kernel runs
> +	  into an EFI configuration table, and honor that table early on the
> +	  next kernel so a kexec does not hand known-bad RAM back out.
> +
> +	  If unsure, say N.
> +

Do we want to make it conditional? Maybe just for everyone with EFI_STUB
&& MEMORY_FAILURE?

Where 64BIT limitation comes from?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

