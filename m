Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A064DCAC582
	for <linux-mm@archiver.kernel.org>; Sun, 14 Sep 2025 11:56:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 831468E0003; Sun, 14 Sep 2025 07:56:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 808C98E0001; Sun, 14 Sep 2025 07:56:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71EB98E0003; Sun, 14 Sep 2025 07:56:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 58FF58E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 07:56:32 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 068EE85C98
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 11:56:32 +0000 (UTC)
X-FDA: 83887703424.27.0B77C3F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 57C78C0004
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 11:56:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ol+Jb1WD;
	spf=pass (imf10.hostedemail.com: domain of krzk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=krzk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757850990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0lA0sZ0scMI1vlgDRPbNSunRy05u3Azkfkcb6cStDwk=;
	b=1L7ellWbpGy3dkAC1/0jLQqzyFXVPvd1e/UUotm0ZY37+l9aA5fYuMdCHzSAdMCUMwaJ5L
	Ez8ZVrPhZtBxnRT41joLDAPHyy7/bGaToBVT2qo8mG2YxO4Tyy7QmJ74BBtTXSt8pHO65h
	JpVpWbzAR3SXdgx0Hu0dwdDGj01aae4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757850990; a=rsa-sha256;
	cv=none;
	b=b9GvK1OcjLb24kOB3CvIC//bIPFXsxwjLirGNqtw2mIyXcr4zINwcsg+q1dKmWx0szrNvU
	b8hz0vCXOBgZXDRDTudobThx0aV1uO1TxdtPkkXvxBl3rDaHy580xEWpEdbO2zq6OM7vN6
	A3qO8lEyZ0H1t5FkaF3E16nzeAarU7U=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ol+Jb1WD;
	spf=pass (imf10.hostedemail.com: domain of krzk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=krzk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7FDFA601AA;
	Sun, 14 Sep 2025 11:56:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DCCDC4CEF0;
	Sun, 14 Sep 2025 11:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757850989;
	bh=72P1XeE7gCDZuUaE9HGq0KcOlPy2jCWwmfe+8Bijb1Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Ol+Jb1WDabHGqEYRRuzYJnuUlxI0TPcRedF4LOzhRwy8qt4x/RgCwK7skMLAwSCSh
	 kZUkFrMXD36Md5U34jeUcfO8IsPsChQea4GO3wSj6dgx8rn0TDd0HQoUGmVtT5Jm7w
	 4vbO2KEvBayBBL0avTBS1NNFdxwC06aRJ3zBRaFGXdgg59vBDvifFKbvWJV/W8zhJs
	 h3JFikHNdItKWRo559a/vTFqgiVliY+2fJdgzM8XEPmEB2JiOHbpvs3YlcflCt+R/7
	 XiqGeb2dS0XeZBx7XaJNdBDxXpg6OqUGJCvXInpFKLUIh1gsjUw2C7plVitmtAaXSt
	 EMbSMqiD9WL/w==
Message-ID: <21e78a0c-f1fd-4476-9553-c3890d05b635@kernel.org>
Date: Sun, 14 Sep 2025 13:56:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC][PATCH v3 16/16] dt-bindings: Add Google Kinfo
To: Eugen Hristev <eugen.hristev@linaro.org>, linux-arm-msm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, tglx@linutronix.de,
 andersson@kernel.org, pmladek@suse.com, rdunlap@infradead.org,
 corbet@lwn.net, david@redhat.com, mhocko@suse.com
Cc: tudor.ambarus@linaro.org, mukesh.ojha@oss.qualcomm.com,
 linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 jonechou@google.com, rostedt@goodmis.org, linux-doc@vger.kernel.org,
 devicetree@vger.kernel.org
References: <20250912150855.2901211-1-eugen.hristev@linaro.org>
 <20250912150855.2901211-17-eugen.hristev@linaro.org>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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 a/A=
In-Reply-To: <20250912150855.2901211-17-eugen.hristev@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ypzwacnaas6uw8py1zyjgudwat5zhacx
X-Rspam-User: 
X-Rspamd-Queue-Id: 57C78C0004
X-Rspamd-Server: rspam10
X-HE-Tag: 1757850990-759705
X-HE-Meta: U2FsdGVkX1/9oUY0K4Lb6u2M10VI5tv9JnRX1K2Yv/zbCFHmVa3pCbno6wRYk/mQ8W1Yr6ZuJbPK/Aa35RTuJAYpcy/NMrszw0f/POoliOSYt4C0UEO4mFLJjJ6tRPn67PYXbQWq7LByNXBL30wVjMb28SmDg60akB97WRKmcodXz6aCluqTL6s2m0boqqWnw7SNW5aNu8mvuPe6MRF2ihTfI04kEmAs1JQexSHWjkBStQ7ZF4+HykELL2ITI0gjkiHUtciaHZ6jhzYuBZbHhlAByvzmJ78WwVrf4k7reWqGynvxtFh64toS1EQuBcqVI+3gJiD6Jtw8YQ32MPsksQ1k9HKTezYkA3G+Z5/HGQAhVTrPbn/cvGdKmRKAnGsVAzHcMj4eZXRGmDWdRx3Sd9Dgaiy4zEvpIRtZJGMYJII3OcGGZox3ujtl+oKM/x4+c3RxcLPPrEbp0pLhAvRNKFxE2moXSh5jpNMkkLXW2NuO+8iGqM2qUzdAcUm4oKlnGx4McUsGseRAK11sHf+nsKJh95IoHSuRg5v4BqB47s3S8QdN5IQxesnELVKCRrohGfaT83wPSDBBBrudraa+issKCf6Uny72rw9P0eJd06OwmCBOuNfN0+HlaiTSJuOJMWhNCpM+DuzujHzzHpcNXVqVbUPoQAGKkWyoZqth6YO7Ucc3+VXqyaIWMv1p/LpnqaCi3EZqAbW62TJu2F6ZyuigpJafQZkZUrAZgZRrVo6qH+v8LMb4pt4U0HWjYaNsNUk4YQrVDta7TGAn3yH4uKwRU7JKpKXCYfYn0Xw5h1cdIxV6JIZj3C6SCFWBds+IKkBWHney/8ibMcYkVnny/iaHy9yIXXPMSWZtlhXd9ftUPK8e01s67IwVR3RaiEqcRV1aCgdPgeMWvi7E0kQ3dUV7NmnzZERXdkGDgTR7iS4fKzJhzVmkiE4FRqU7/Uy5dFtYoarjYqtIq6CRQGj
 4soD1Cw0
 V8mFedlAxWFJj164ziDjF+nMDk0WQdpK3t8AlfD7hu4LatoJqUWVsaa0hnyzzxARAdnohZz4Szf3Pto0tK3sMwk4v8S0aGzsoqqVpyUu6teQHkSn9ZhVbWfscPD6qquhbP2/yItV1/8m1efsrBOrxu2FMcS8tvyidTqTiAl8+qZhIrLkwSIT0FA8fWjNYzv0O9UXmB4ttgR2W/Ra1ytqjj2FPqP6OxVYMAvP+Dy5aYpH3CQLtD2WbN5jZrwAa/tuQmLaD4uwcOLQpQqdbrFN2Up/NrkymAIxhoDKGr+UjanGvCVCefJakfp5ufVqG+y32wPz1ff/OKvJPiENfIQCiZw0S5v0Nal6FJr+2/iCCRaHQuadKy/Ze9ERvNg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/09/2025 17:08, Eugen Hristev wrote:
> Add documentation for Google Kinfo kmemdump backend driver.
> 
> Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
> ---
>  .../bindings/misc/google,kinfo.yaml           | 36 +++++++++++++++++++
>  MAINTAINERS                                   |  1 +
>  2 files changed, 37 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/misc/google,kinfo.yaml
> 
> diff --git a/Documentation/devicetree/bindings/misc/google,kinfo.yaml b/Documentation/devicetree/bindings/misc/google,kinfo.yaml
> new file mode 100644
> index 000000000000..b1e4fac43586
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/misc/google,kinfo.yaml
> @@ -0,0 +1,36 @@
> +# SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/misc/google,kinfo.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Google Pixel Kinfo debug driver
> +
> +maintainers:
> +  - Eugen Hristev <eugen.hristev@linaro.org>
> +
> +description:
> +  The Google Pixel Kinfo debug driver uses a supplied reserved memory area
> +  to save debugging information on the running kernel.


Bindings should be for hardware, not drivers, so this does not belong to
DT. It might be a dedicated reserved memory node, though.


Best regards,
Krzysztof

