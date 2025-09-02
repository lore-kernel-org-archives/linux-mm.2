Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBD83CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 11:45:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32C0A8E000B; Tue,  2 Sep 2025 07:45:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DC348E0001; Tue,  2 Sep 2025 07:45:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 219358E000B; Tue,  2 Sep 2025 07:45:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 101538E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 07:45:02 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B57B711AA2D
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:45:01 +0000 (UTC)
X-FDA: 83844128802.17.9739672
Received: from smtp-out3.simply.com (smtp-out3.simply.com [94.231.106.210])
	by imf13.hostedemail.com (Postfix) with ESMTP id B472120008
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:44:59 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=gaisler.com header.s=simplycom2 header.b=jXmzEnXa;
	spf=pass (imf13.hostedemail.com: domain of andreas@gaisler.com designates 94.231.106.210 as permitted sender) smtp.mailfrom=andreas@gaisler.com;
	dmarc=pass (policy=none) header.from=gaisler.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756813500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=voGobjfJ+JDIyxPuu8fGQb2u9QP7Z513vboXRHjWrpI=;
	b=zaTau1kdfXAvWsK5jutfCwlrfO/Divaw5kgFnUbHQhtyGe5zJe+uJwcXcjbsoXJHOvjQ+t
	o3y1TXHB56uV3V2WmrVBRf/0A2kVdv2kbXOaQjk8qalAlxWfzlF3N1v+H7R4Gv9bZYeNQI
	w2JUWjYaqekvVDZT5T+beUP/9jjbiLE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756813500; a=rsa-sha256;
	cv=none;
	b=agybrtoaX6Q4PV+qE4Fu5D6NNc7tM/AVr0yxuKtLcINSTrF1o6v9nwdUI4WeUMQoGhT8R9
	0OKTPMMwPo5MqnWKK7qFxgU1bO4C00+W/tG/gBoHu9eAmbbas3o2LQbCjL+e4L/p3/co6p
	xkjUVik4ScF3X6rvRxsNb66AQqJ/KD0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=gaisler.com header.s=simplycom2 header.b=jXmzEnXa;
	spf=pass (imf13.hostedemail.com: domain of andreas@gaisler.com designates 94.231.106.210 as permitted sender) smtp.mailfrom=andreas@gaisler.com;
	dmarc=pass (policy=none) header.from=gaisler.com
Received: from localhost (localhost [127.0.0.1])
	by smtp.simply.com (Simply.com) with ESMTP id 4cGP6x6Rpwz1FZPJ;
	Tue,  2 Sep 2025 13:44:57 +0200 (CEST)
Received: from [192.168.0.25] (h-98-128-223-123.NA.cust.bahnhof.se [98.128.223.123])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by smtp.simply.com (Simply.com) with ESMTPSA id 4cGP6w5mgsz1FXjD;
	Tue,  2 Sep 2025 13:44:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gaisler.com;
	s=simplycom2; t=1756813497;
	bh=voGobjfJ+JDIyxPuu8fGQb2u9QP7Z513vboXRHjWrpI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jXmzEnXapdgWj3k2C76LGG7k/5mt1kwvMqAYSfMFYlJ0dMOQ80Oj2YE0pnZAtNJ4t
	 tXQk/LzaZA57Nv160y42KGcSc12HLtx5zDkXLTwO001yujBIUCUp0jXWbSqOup1wEK
	 caelEQWo/j1aiLxV7BPWjSbstlue7ClkuM93YSG2cSzlCJSLWryT6cSw2EEQcr+aVF
	 FTt0lGn6fnMuHg7U0U6sd3U2Ku9tEiPKwlVMzDHUsOHxPUryMAOV1qAvelOgjen0aR
	 RoDQinmHdiIG1eCVLztKOXDNMYphrSPAPE4G8u5ceaF4FDq1DzCH6UTTJUx5w29cc0
	 vZYTj+Lq2QLjQ==
Message-ID: <92bace9a-b5c4-4ea1-a1f7-4742c15a64a0@gaisler.com>
Date: Tue, 2 Sep 2025 13:44:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] arch: copy_thread: pass clone_flags as u64
To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 Arnd Bergmann <arnd@arndb.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-csky@vger.kernel.org,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 cgroups@vger.kernel.org, linux-security-module@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, netdev@vger.kernel.org,
 linux-perf-users@vger.kernel.org, apparmor@lists.ubuntu.com,
 selinux@vger.kernel.org, linux-alpha@vger.kernel.org,
 linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-hexagon@vger.kernel.org, loongarch@lists.linux.dev,
 linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org,
 linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
 linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-um@lists.infradead.org
References: <20250901-nios2-implement-clone3-v2-0-53fcf5577d57@siemens-energy.com>
 <20250901-nios2-implement-clone3-v2-3-53fcf5577d57@siemens-energy.com>
 <f2371539-cd4e-4d70-9576-4bb1c677104c@gaisler.com>
 <11a4d0a953e3a9405177d67f287c69379a2b2f8f.camel@physik.fu-berlin.de>
Content-Language: en-US
From: Andreas Larsson <andreas@gaisler.com>
In-Reply-To: <11a4d0a953e3a9405177d67f287c69379a2b2f8f.camel@physik.fu-berlin.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B472120008
X-Stat-Signature: ikysuwyzbrko5ticx9wiqrwpwqrhxzd6
X-Rspam-User: 
X-HE-Tag: 1756813499-797758
X-HE-Meta: U2FsdGVkX1+x74QGqLRkycJI41j+Nriq5dp6wf/TfVmsOye5EKlvlwAQzdbMjnJEB0uz61hEWu72XPq1jLhOKkpvwG31x/VF1/uKK03Gy6jz82VhFjutInpLhF0A4OVxybwnxQ1zQPS6ShIHvTqdOz/JO4YUsLLf2+TpaoNlv3UZeNE11AXfo6C0n9ybQLG8GdhkMHRcAgfOGhu2co2rbXQrSh/QkVUK2nMEcielnqZGJM+tzA8FbOn6lpwBZ6ZTyB8dPPTSbj0FZHwJRIdlXaV/Ky6mAJ5edzT4rvghzBVxZTgSTq1a/w9e63LFS4VqS+IQxtg1SBIluWehUdHi0Ur7jEkGACYLWuLDsVABpFnNKUdK8Iff46Pek4oQDEGKmhToWXNFWfyKKHtEk/PyWAey32l4g2pEkzdHKq0Go0WPaXWOf6xtDDROcdbuTZCddnONAmh9lc/t71wK0vbkTCXjeuyHvqgFmDWy8BHJ2+GJybyUd5hewuzvIuIhKGYq89SspL+nDAYKzuI9EHEB9VVx38vq8Mqm0KEmgbkavdF+s/deKuC+3yg4aqLCyIVNDXLylUD9NvbU4rtd2xc/yg7j93Vy44Wl6jJX9F5wG5A4oWQKIaLsAmQ6Elq3K5kOE8H5VvAGf/TaN+1eiGUto9wIw/rpNmtfXBATdIeuu7idsAlz453puqn+z+eet5Z3/YpdHKrQju5+IKNDDtZDa7Enuu9AOkmv/zXlMg302J/uXiq/gbPbD47/seafpDfBBjsV/YKjPARrVlXm3vVIw5JvJhcWE20FqhVGgYz/p8MRFna5VTE004YMIL3J1uv3mtZPAMxJkxIHyjrQgSrJZrdrQgMAi5uySUW0zjd/4KUO8ZFp6htutXNTpOKU9R9TnpgBu0U/etJaoM/LkSjZEv5VBOpLub6Rbsc/cG0l/nB7oSFeQXBXJaBp6K+oT9+diwJUJWUWRZ95j33h/h6
 VhFmNe9c
 HoWA8+XazxP6NjeTOSAtdc6URzYK8KaCCoLJ/fhyEo+JEM8mP3DGbbBnnYCvFiBuBZOGLnfZO7mkyqt1cSYfS0CBKaKFyxh7sirikLrJX/FNsKQYgufCvx0TijS79zgXW1gn6Kt4uEaSb2bE5Tg9euvHR4dzrDTHE1C6SdZhqAs4s6N9+wnMvYqQ1tLA9BaLNz+xCuZJyY/j5J5/Fhz8t4LoXJLB+rC+gszwVKE2Ewh3oAy+D3wAvPjg/fQbGiKQa+hdb1+VgLA0+USGYkmOu//Of1viSKXRz/iR2xbBb5Vv1ygMQKEV9ntnwwBgmmCHyUmryflfMPK9ZHMihA61xIZbkz55wfWyDJZIlIBeVQj8l8IA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-09-02 09:15, John Paul Adrian Glaubitz wrote:
>> Thanks for this and for the whole series! Needed foundation for a
>> sparc32 clone3 implementation as well.
> 
> Can you implement clone3 for sparc64 as well?

(heavily pairing down the to list)

We'll take a look at that as well.

Cheers,
Andreas


