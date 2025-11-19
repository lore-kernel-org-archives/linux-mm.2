Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 476C4CF3959
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 16:41:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A78696B00D4; Wed, 19 Nov 2025 11:41:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A29066B00D5; Wed, 19 Nov 2025 11:41:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 918166B00D6; Wed, 19 Nov 2025 11:41:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 79E7E6B00D4
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 11:41:19 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2508F12FABC
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 16:41:19 +0000 (UTC)
X-FDA: 84127921878.22.78DADBE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 57082C0006
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 16:41:17 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="orE1k/Vz";
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763570477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nNIh8qbJ19QLeHU07pLCa3IrEWT7XV1apL/g1/AFFuU=;
	b=ShHUIHpd4j1jM3mArTbzuxr2XC7Rp18szSqLNzYKQvS+nRQdDworVLLvryxXuqYxllyTQl
	J727jqmcC9UnIpO9IqJuZpGS4GDjjxhxAvc/qv+wNFSpsDGiPgEe1tH8HPBKCOxFY3Fr/d
	FAvrgNiBVAF1FKdoFp8FI0MC4iZDDAI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763570477; a=rsa-sha256;
	cv=none;
	b=YO6KLrzpWp2PKEztMgpXUOW3SvJXxwE3QoD5KfcRWe+S8UJfLox9+z1fkfVW7yknn+QBFR
	PBVmMV2USOS31uEJ+slKpD0rs2Wh1OGP+tc+YVgaOFu3Qis+IdjQb0OE2IndyCMK6v/og5
	cSoGP3jWFqoUI4Xj/8XV+Ex71J6LGpI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="orE1k/Vz";
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3D2B941719;
	Wed, 19 Nov 2025 16:41:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1748AC113D0;
	Wed, 19 Nov 2025 16:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763570476;
	bh=59551kNPC3dWWk2b79CBOZcdwg24stDVN4q/MYg3iWY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=orE1k/Vzpp7xhkzWnI6GnK+j7M5M1HpbQAmd+Tnrb/Yuws6ir0wRXw0wR4tNlNISk
	 /hIjz/5ynSeALu01KzZjBONLeyJ9dm3BrRkTHevDIKTJA6LdkSP+OSk5TjnWpXUD6k
	 k6dtjk7T3mGgRtNweKgZ68XtUAylpVFIFw8lgnNFCxFYTUaOA83gqTpg6S5BTNdLBl
	 5MdINS4KqyNvJBpXbdo+kwPrHDm5vGbvjFtPKUl0UedkssDzhDhzYoVKXGfKo3BM7x
	 UyVow7EiVUETRTouAZtXPuDvw633JXpXxek3ZTFj1aKeX0j0orb6zzRlVDqOqew87F
	 lfp5kInyQf7gA==
Message-ID: <3828920e-4a50-4f64-a25b-b6c677181fa9@kernel.org>
Date: Wed, 19 Nov 2025 17:41:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm/huge_memory: rename __split_unmapped_folio to
 __split_frozen_folio
To: Jiaqi Yan <jiaqiyan@google.com>, ziy@nvidia.com
Cc: akpm@linux-foundation.org, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 linux-mm@kvack.org, inux-kernel@vger.kernel.org
References: <20251119054639.244202-1-jiaqiyan@google.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251119054639.244202-1-jiaqiyan@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 44y16zw5b9tzbg7c41zokin3gcoiijmm
X-Rspam-User: 
X-Rspamd-Queue-Id: 57082C0006
X-Rspamd-Server: rspam01
X-HE-Tag: 1763570477-991295
X-HE-Meta: U2FsdGVkX1+tPe+3rA9uT4HjXuFAXC/QU/Fqpd+Ca2YZO4W7MiVRD7+tnTB60Tk+6M+P/OhlqEX768WujohsZJ9m5utHiEi+f7XC34+8d/2VXb/7BsexThNDTaVrhYFnms/T6meF988xq5AjWvmzjbLEbcn2R6K01A6XWNi0XsvBW+L20qY/JZuOSXm+/YTyzf/6TVTvzgnIP0tb+6eCswIjwWBCzvOIJGyZImU+9K2rIBTbQLh2tKmyh8+cWyMo4irKWWfXudiwQROnSru4IaC7cB9pi2w2DIWGyV7DOOGaLtsvro6cxLzrsZMjB9j5E7MX2XoHlKSMjPiC8YRooYgsT5sH56RXSZnwBrltN/yqJ5NmUV/eF0aLpYbmHzd/sAUkU7Xg9HgV+VmwCPvFh9vF8Pi5GBv7rS3YHo9f3pX73E/nTw97AxStog6CoQCe5dApawtR29gUTPEOf349mHiJTkahBVjDB01Lm4WubTsPnZMdQBAD9lTYFgbLkumjlz6q986P1d7JAHnNc++ewx9Il4ujoojvlpQhXOOhFVcZUn+GMkrNG68qK7ROsevaZmqQSr+QjEgfprB+hGr1AGyGCZRcdOkGC5c+ohYhMFwXIWLV3BW5qr3jMrdHRgR54nM7raOrqMeFxiY8/X94mmOQPU8S50mmoAkdJjYScSQoPat8wT1YCNd/4G3LG7boBa1ZzfvhjTVR0lGJAtQwf8yP8m5SSNF4Sys1JfPR/jRj2G42uAQBZPnbAyRkrMBKUdGkWxCcYA4kwhoLplo9abVrSJj0pVux8e73HPWFX/UPNAGumsau/u4MeQfcskOZFHs3PwdEGcnMBX/tYhE2Bv0B4+31PV52vrgxqHvHNZv3ngvN/oM9BDiB3wt//rpyVKSNnGrKxaYHznHVYT99AfMEsiBYr0eRFpiL8nA7gtFm66MwRHKRiUH80h8ifZILBens7UY5YKYBKNsGAVt
 PeehfKWU
 B6nJppaObr2cheOqSqqHs/aiCa1c7lsCbZU1GQjuA/GdGEPmP2yArwTyGRjTS6qTLCDNC7tDZCWakmXWVm5xIvfarRmq+EnMuhB5zw4IAea2GXXwdCUxfjLzcMFHeZhSU99LuJhh2m4SfQ8zYXhNGwm5QWl2+hoGFuGdwrXLYouNEGA8Rs+UqatTSU1I385NV5FMtys2cWzvjisirMgydxNYX/Hm6YvKqB7AARKwzdlTd1r4k/GCeb/U5rFoffOJsUKhUFgp/75GW3Ld4B9b6Rfca3t4SupoxW0zPhZvnwtQRMp42IMZekW/asA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19.11.25 06:46, Jiaqi Yan wrote:
> The correct prerequisite for this split utility isn't really about
> if the folio is unmapped; it is more about after unmapped, folio's
> refcount is zero and has also been frozen. So rename it to
> __split_frozen_folio.
> 
> Add a warning in case the folio has non-zero refcount.
> 
> No new function is added.
> 

While we're at it, can we look into calling this something with the 
prefix folio_split / __folio_split to get some consistent naming at one 
point?

-- 
Cheers

David

