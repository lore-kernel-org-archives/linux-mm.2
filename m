Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B937EB491B
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 13:00:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C48B76B0096; Thu, 12 Feb 2026 08:00:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCC746B0099; Thu, 12 Feb 2026 08:00:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B041E6B009B; Thu, 12 Feb 2026 08:00:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A06F16B0096
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 08:00:14 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1BC2855EAC
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 13:00:14 +0000 (UTC)
X-FDA: 84435812748.01.276516D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 582EC1C0023
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 13:00:12 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MAiS7gpR;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770901212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BVBtdpurmpISIWqOJSTlNhu6Q9/g7LJUy4KVjqUl2oA=;
	b=mlhQjkUm48jWHRipdp50jT+b8kgeJFO3cvmLSV3NtjCPtXJrwjM9HmpzENR9R+1cY2AFnz
	tzLE0VXnZNeTkSfJAuWO573Az71THEH4SvvE6FUjrl1i6hBQ30q8NW6DRtAlUpdekIn3tJ
	G/Qkm6cNL1I+iJVHADVQ5EHBs5TqEK0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MAiS7gpR;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770901212; a=rsa-sha256;
	cv=none;
	b=UjpOnnXly5QzMmS6vNVe/gGEFhte9nm4SrqRDUjSeR5PEH4qisyiIm3FhUi9UFjSmBgE40
	QVIwyBq/Wqxroy6abhUZqJGcpyM3wlcw5Ni26atyKDAWHcWl1hJ6UVtsyfQGVt6pkVPf/G
	YizKlhEH0lb0oFp6PJ9616KbZoX1CzI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B28D3600AD;
	Thu, 12 Feb 2026 13:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0C42C4CEF7;
	Thu, 12 Feb 2026 13:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770901211;
	bh=O5e7fgGGsspQKmJs+VnIOdoxwBywu0PNxcVSDMoHR1Q=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=MAiS7gpRChWMkBleP0fbfSBAS5JNHzbs5ICrudjJXMMMjh4MHvlq5PemVLmqQ4MHB
	 b/MDSCX1rfLU7xJFGa4SzX8vukk6y1M57V3/A1bYZEV56rPQTOl6Pn61Qz3VsgMYQu
	 nEsqFt3UOaAMRljHco7HCmC47DuKsNfJ7Ao929/JTI1OfGC1RqR0sIv38NZyOH8EGQ
	 yLoo+35f/z5nYObdiNKFaHIsop4GYh2OOg12HNiPuUfg7GxWKB+PQEaI9q+LNzDMqE
	 tLyz3+5ZgO4YszChx6U1WAhW/dc5SXOXX6BCSQZGex85g+eELXTgP9pKJY2qP+wl+0
	 N78Y17TCV6Vlg==
From: Pratyush Yadav <pratyush@kernel.org>
To: ranxiaokai627@163.com
Cc: graf@amazon.com,  rppt@kernel.org,  pasha.tatashin@soleen.com,
  pratyush@kernel.org,  akpm@linux-foundation.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  ran.xiaokai@zte.com.cn
Subject: Re: [PATCH v3 1/2] kho: fix missing early_memunmap() call in
 kho_populate()
In-Reply-To: <20260212111146.210086-2-ranxiaokai627@163.com> (ranxiaokai's
	message of "Thu, 12 Feb 2026 11:11:45 +0000")
References: <20260212111146.210086-1-ranxiaokai627@163.com>
	<20260212111146.210086-2-ranxiaokai627@163.com>
Date: Thu, 12 Feb 2026 14:00:08 +0100
Message-ID: <2vxztsvmqfqf.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 582EC1C0023
X-Stat-Signature: jz465fpcrz4cd3ndddattn7bfn4gsobg
X-Rspam-User: 
X-HE-Tag: 1770901212-21115
X-HE-Meta: U2FsdGVkX1/mQJ08fgEp3pgXm05w5lRyXyGr5hS6VwJxaC7Hc0N9hYBFxQGBiQei/OaFrSNh7baC8bUqOryW4r7fgfsmXi+w2H9vfCFMFGhP1yuUKfo1tsXxUBdaVog5KWGgvF2NnWdMLUwBgGHNkpAz7z03Nz/rhB4di1kwWm1sNbz/yYmJzrlvISI0Jk8eLmVwitdkW9fhZeFSkbl6f3vj/r1H30WCUR5lVeXUP6iXs9UJnPugBjeK3ioDqAdg2Ed95obuFsMC9aV1pvTHIm8SDeRQbt5k+Vk6R0cf1ugEbf4se0u21/iSWDIhY53UQZqS7E7G5O6PSqfKsXu0YM6DhLxz3G138Wi6Ly1JlkzjhVkvntjfWuVj9CHTxkObNErE5z7VWJXQYCC5e9yUSFYnhVJ9CwupdgCxWw6Qtt6bVh4YOncAniAJP81jAPMJ5p6Lx+WFj7Qi+0ddL+2hU7xLL0+nOF1XrbrUbtE35Zau/rVQcofNwCOK5SvnfGi/S/LvzWquqQQISz8BEknC4WajmVPE/YQyvDUa+fr7X8l/feaexY5HlQHhej1t5+ji1lha3B4vl1ldqT3fOjznZNg2amLn/K/7H2GNQtzWKIYoq0F1cVEVF9+zd/VIBdYnr7shf834eDD6t4rO6RxyMf9SGT7SNOtXnRNSO4SPmQjgGJWpQiidqOH8r6tw42syq5sdiJ3keGU219W07MIwKeHmaHCZkkRakeGxiREsFEoravnJscqPJ0veGnDMHIab70MGhz+mx7kQBspLtELFMKkc6vEUojT3SiRmbzW4xrXHkgdxZDF0A4oIZErnFU2SNIPzX1HWnUTFqDwbticTMBkwPh70imhWJY17tBVAHFjFa1KRb2CROef/NQYmgjg6l+UIugpdB0/geC519/DGWDQQ+eQkqMOD3tR3rAxgHIQq1m9jpuTy2HTRPZi2+hYtACL5RUtwJMj89Un5NyW
 za4Mlm7Z
 QDvIysY2ky2V1/NOZty2LTvEXPoRWO8ukG93YnL58bNUZZBWmeI5AnQSB91oQXH66rRtbNwaKYhKvtUTSO6JzVWOuByKsU9/tJkHl47edaaSrKscpbxa6ZePpHXTAOi8MTPzn38iS4XrnQQfjPTSFX8a13pn6RFGwTNK00AsTGI7YkM30vMLwvnDhEOBoP3TlgWKXG5rYZdlw3WmACoT9dNbYJMSVHWNvhscEconh0SWUbPayoMl4fS0TMF7wGkw2iqCqEjkV6oi2MqWGQDv/61HQQmvFjmUkWKEUg4Y21ijbDoEbGby05p5/2UJwBtGG8jeU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000002, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 12 2026, ranxiaokai627@163.com wrote:

> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>
> kho_populate() returns without calling early_memunmap() on success
> path, this will cause early ioremap virtual address space leak.
>
> Fixes: b50634c5e84a ("kho: cleanup error handling in kho_populate()")
> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>

Thanks.

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

