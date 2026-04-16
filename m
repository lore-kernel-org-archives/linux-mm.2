Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF2BDF8A16F
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 12:30:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B00E6B0005; Thu, 16 Apr 2026 08:30:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 260916B0089; Thu, 16 Apr 2026 08:30:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14F086B008A; Thu, 16 Apr 2026 08:30:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 046BE6B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 08:30:57 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D0EA4B5042
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 12:30:56 +0000 (UTC)
X-FDA: 84664353312.21.F230633
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id F391780011
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 12:30:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aREs4pY9;
	spf=pass (imf02.hostedemail.com: domain of krzk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=krzk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776342655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VyPrg9GQ2OOkA0iAAEE3gj1RNHhV/N2lAktXeN9rB7c=;
	b=ltlNnp4BpZAPS+uCwgiIZRvtt/FcRDhqfymze1Fprs6dW6Rx9nEWTS/Q9d5OUfOmo+QNsl
	vBviyLbWWphkZfAlG7FPrEHPWDiszHn0quTFDJePfJekTTnuRJ9OTYVvr/kciY+dlRguEV
	5U8F6t6C2t1QY5ie+SONNq6Fa7Uku9Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776342655; a=rsa-sha256;
	cv=none;
	b=ps+gUDsbi1tGdVp4wum2HcCzmezjsKhMKYuvPfQ10XZTxPwPQGtdpxaTWDYiok+aUat/hZ
	mxzdRVGliG4yxsICHS1ALCDjBfzPcEfUbyBrr7dgzBTvhdcly/HkZGzam69KFgiNXpWfpp
	+RHVI03yWEcB3MeWygAvEaHm2iR72TQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aREs4pY9;
	spf=pass (imf02.hostedemail.com: domain of krzk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=krzk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 91B2640474;
	Thu, 16 Apr 2026 12:30:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB8D2C2BCAF;
	Thu, 16 Apr 2026 12:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776342653;
	bh=0+upWZt1SQSfIz6OgmfLK1joGZgudnQ2lP+Bv+7s1DM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=aREs4pY9AFWiyPis1yCUHi655kH6F2cmateO3OS3vwiWh4XGstegazkXh9fTeJRQW
	 F7PNlGo+5uv4JS1ghUA7GmLt/nGdKTIiz0N3eNo0k9qdgxnlZ6UVo1xvuY/jm0Jsgz
	 6OXZlHvLM95FlzgQqthFFGhbIejPY5s4jQOos8SHiaMv+4GNWDNJ4NBjKmastJKLl9
	 B+kLcT7cwceOa9aKNihg3CZG+65E3BtgCcBvAVf5SIS4E47zAqVB8uUKfjkayyutdK
	 0Jj6v6r/4toyxe6BrveBQ3dEYq/LaiTL2nhXiDsBmOQK54Y4zcD7qDew9ISAzQHpha
	 d9g1fsIICa3fA==
Message-ID: <1fba96bd-124d-431d-8de8-78688c248600@kernel.org>
Date: Thu, 16 Apr 2026 14:30:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/61] Coccinelle: Prefer IS_ERR_OR_NULL over manual NULL
 check
To: Philipp Hahn <phahn-oss@avm.de>, amd-gfx@lists.freedesktop.org,
 apparmor@lists.ubuntu.com, bpf@vger.kernel.org, ceph-devel@vger.kernel.org,
 cocci@inria.fr, dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org,
 gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org,
 intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org,
 linux-clk@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-gpio@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mm@kvack.org,
 linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org,
 linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org,
 linux-phy@lists.infradead.org, linux-pm@vger.kernel.org,
 linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org,
 linux-sound@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
 linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
 ntfs3@lists.linux.dev, samba-technical@lists.samba.org,
 sched-ext@lists.linux.dev, target-devel@vger.kernel.org,
 tipc-discussion@lists.sourceforge.net, v9fs@lists.linux.dev
Cc: Julia Lawall <Julia.Lawall@inria.fr>,
 Nicolas Palix <nicolas.palix@imag.fr>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
 <20260310-b4-is_err_or_null-v1-1-bd63b656022d@avm.de>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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 a/A=
In-Reply-To: <20260310-b4-is_err_or_null-v1-1-bd63b656022d@avm.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: F391780011
X-Rspamd-Server: rspam07
X-Stat-Signature: 1mfrqa4pngret5yqgds4qgcs63j4y9oc
X-Rspam-User: 
X-HE-Tag: 1776342654-597140
X-HE-Meta: U2FsdGVkX1+ZNegevx3xRtrlzbEw0Due8SQzBY6k7jS0npY8BSbxo7UbyhIUk7FeBUggP4m/VzrvATmN2423+hXmhFAIq1LU+/hwQebDyJrtJjrJJTT3uQFeP+2u4QMSdebpefp4vDJMHiunVDT3fsHHDDyweLiEEmgfX9/KJoFFTLT8U6OALmksv7/w0iSAsxCvuvvGN4Euko+Fz+pl5X2yJ1vKuE09QFclISaiPF5gf0wG5mEAqshLn4aPF+ubCWNApcSTDwjML7oz2HSEQoijv6rRdLn+VDrIsXD0cIys0CGCbZo9ATWl5a6M/FfdUwj4uSHvieOqNC60Aj/7zTCcY2AqaJBrt4UBPKuenrDxhrsu5dRakXkH0UGcH71EmDOhYVAxBte10FCFhBPcAIdbaHZ+v9QLpDuyIzDZpuq92NFnmiGBifI1QYO7TrCRZHWNTioTv/2yNQfZeTbp1nNKZxpcQljl8qOfYsromJ3+JDfIur5/lF4LJyAPFhMLpRUAPM6rEuWq11YFEL1MbzfJfpC5EaZ3Rciq33p6hrFJsSdPdmvtljOmDdkr72uWK0UFlSXdHSDV+esRVJ0EtdmUCbUAYtLqdn30un7so0lgdD82HrOh8xLHUJPqNV0cpSo0D8ep5+7tM4h+bCghUuiPQqieOrM09YsZz6Doq3HKOM6/wKZ0Tup4vLLZ9SlwEqQuONig8VKaqZmtIn6kLW0SSVNQuDu2q+9sw9fK3x9ns0ZJGnF6X5u+KYjb87q1NK3sWTEw7fkvVAqq85rXMWZfEw4ek1mPECtAimf7c4dWBXuYK3JHTq2a/AEBLksXus96vBaEKRuVvkK8sKbpRmiupaPXJDgNz17e94QkwnCs9+bLCdWsWq+fcsZqDLYlUGb5ErI7SgOu0N9Guzq4905gkglmx0iiTikrKgJfhlqMPqTlcWzs1PXsr0jf2P8Zn0FdzhBs0dnPQPdJFsF
 RaRzu1PN
 RzkBCiAjk6069NtDLV4RV6LC6p8J9//pwl70u1CMppSxVaZsbUh7pRiV6bNsKhvAuevgyK1KgWtyFE3ptxZ29yZD3o+tj+FUmFrZBRwPQgkO4orEqToBdy7SFMwWifFzyH2bQeoUi58W3pViC1V82eOsCUIhNOSq3PPFNa15NKRGqz//0DDsw7Ji59TCiWU4zBy2Myp6pSqmW3aN0r4au2MA6REY8rPfFXG9eHiKLd6ySsrZotlUm7I8sfk+T7KSBsUQbFMR2zgsJPNOu6RV3Re24t1rEsO+LszsJtzGnFxYy5NEmdNN70Y9xlXADGYo8w1pqynF7k4044kVC2HiCecovddbT4F3Lp/F4yNXeBeYi25AllCYdSxlGtw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/03/2026 12:48, Philipp Hahn wrote:
> Find and convert uses of IS_ERR() plus NULL check to IS_ERR_OR_NULL().
> 
> There are several cases where `!ptr && WARN_ON[_ONCE](IS_ERR(ptr))` is
> used:
> - arch/x86/kernel/callthunks.c:215 WARN_ON_ONCE
> - drivers/clk/clk.c:4561 WARN_ON_ONCE
> - drivers/interconnect/core.c:793 WARN_ON
> - drivers/reset/core.c:718 WARN_ON
> The change is not 100% semantical equivalent as the warning will now
> also happen when the pointer is NULL.
> 
> To: Julia Lawall <Julia.Lawall@inria.fr>
> To: Nicolas Palix <nicolas.palix@imag.fr>
> Cc: cocci@inria.fr
> Cc: linux-kernel@vger.kernel.org
> 
> ---
> drivers/clocksource/mips-gic-timer.c:283 looks suspicious: ret != clk,
> but Daniel Lezcano verified it as cottect.
> 
> There are some cases where the checks are part of a larger expression:
> - mm/kmemleak.c:1095
> - mm/kmemleak.c:1155
> - mm/kmemleak.c:1173
> - mm/kmemleak.c:1290
> - mm/kmemleak.c:1328
> - mm/kmemleak.c:1241
> - mm/kmemleak.c:1310
> - mm/kmemleak.c:1258
> - net/netlink/af_netlink.c:2670
> Thanks to Julia Lawall for the help to also handle them.
> 
> Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
> ---
>  scripts/coccinelle/api/is_err_or_null.cocci | 125 ++++++++++++++++++++++++++++
>  1 file changed, 125 insertions(+)
> 

Neither this, nor try from 2011, nor any future try should be accepted,
because it creates impression IS_ERR_OR_NULL is somehow okay. No, it is
not okay, it is a discouraged pattern leading to less readable and
maintainable code. We should not have therefore any tools suggesting
usage of IS_ERR_OR_NULL, because people will be converting poor code
into that, instead of fixing that poor code.

Best regards,
Krzysztof

