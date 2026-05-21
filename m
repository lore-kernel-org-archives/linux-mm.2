Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC90CCD5BA4
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 11:24:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F9FE6B0093; Thu, 21 May 2026 07:24:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AB2F6B0096; Thu, 21 May 2026 07:24:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F02FB6B0098; Thu, 21 May 2026 07:24:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DB17D6B0093
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:24:26 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6610F8DBCC
	for <linux-mm@kvack.org>; Thu, 21 May 2026 11:24:26 +0000 (UTC)
X-FDA: 84791193732.03.5B6F45C
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	by imf22.hostedemail.com (Postfix) with ESMTP id 66FAFC0006
	for <linux-mm@kvack.org>; Thu, 21 May 2026 11:24:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=nNMF3lYW;
	spf=pass (imf22.hostedemail.com: domain of vladimir.zapolskiy@linaro.org designates 209.85.208.176 as permitted sender) smtp.mailfrom=vladimir.zapolskiy@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779362664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zOXAaGKHIrljocIh5BlaWvl6DIEbTF3k9+Gpg5TlS4o=;
	b=wmM3vG+ewSzEvy4dHK756ncNuU1m8yNrpzGeD0/ZtAayDUGTOyGDVUQflIa7nnzRWQeZhE
	fSK6S+/D7Bfh7tTEa8/C1eo7qhqUgUPXaSoAfCcNEyO3jGBdB7HOLVgPs0Jwx0mY2TZRZ7
	HWwpPhquAU9XknmeHWVS17V0zJH3dkM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=nNMF3lYW;
	spf=pass (imf22.hostedemail.com: domain of vladimir.zapolskiy@linaro.org designates 209.85.208.176 as permitted sender) smtp.mailfrom=vladimir.zapolskiy@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779362664; a=rsa-sha256;
	cv=none;
	b=p32DhbbXAdBHx4Eh/0xd4fNqRt3AJHAbVm1EBEePAIQ5uNFpeEMnkhjjFwvifCqXC4G/jc
	6OefGh7KyfZTAYHYMcbLrKrR0Ye/hIap7iGJD9I4aksU2q96voTYc4A78Hyf1N430uCT0+
	c8HTQv64BA+nfbASIRmsfXJjVXO/IsM=
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-38e935bd6e5so6019601fa.2
        for <linux-mm@kvack.org>; Thu, 21 May 2026 04:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1779362662; x=1779967462; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zOXAaGKHIrljocIh5BlaWvl6DIEbTF3k9+Gpg5TlS4o=;
        b=nNMF3lYWPWmilbw+Zz5dgercAPxbWZyziWw7zegSQEk7ed4s22BgFsvDo3Yg3mj35c
         /YsoZCC5VVZrCXlrNESk8LxwXQKEpiLsQ/FghuR4zS0Sz7aVJYNhfTsJJtyajppXyCDV
         ZFBB/82AAkiB3FKEA2RZdkdL7jj+3IMepvfKIlNlMCksdfqY47ZEcGD+DQQ7QpQwHDx6
         VEVVlMIJ967a/m6/TBI621fdihFiD5gcHyKPDobJ5Ru5olXBA18ZcdKG2X2i0pq0If4h
         vsf58tDX0ZIoRC0SaQ7SbY4pxedciznW33RO87Ecsfv8eLPUKc1iTJBCOwJD97buOukA
         JT5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779362662; x=1779967462;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zOXAaGKHIrljocIh5BlaWvl6DIEbTF3k9+Gpg5TlS4o=;
        b=OG1vYXu+9cVP1PyF1jquBhjr6azB94qx2ukDuRM9sdPv2KvDgoF0wuB9XVDUJToDYu
         VTHrymzma1Z5BSMgFIzDlpAjG0SwM/SCL3jOhnqEbQm/BZVnhz5nd3DcXREHtDAeJKyP
         vuxGTTfY/9nphCnxAsM2kk6hCWf7S09ciP8lP47iC1Nhgw9wuEXSFcXiu7y0WoYaiSLQ
         VmTOB97TMBSfnriPWDecySbJMLG6xYp/37Unvu0K9PlRrI8XZjknmiyP73KsUxwYYVdb
         XfGhoCRXrOBojPeodn7A3/q3lGocFl+wf8FDa8uf4nbuc/zJYoT2dsKF6D9UMXxQ4NV0
         KUCA==
X-Forwarded-Encrypted: i=1; AFNElJ9T+ObBxLy9U5lJulcCOFz35P5djctNadauJTE98ORRWqjYZjSxZmkPSOqqXs6NyoKM63Uu5BHt/A==@kvack.org
X-Gm-Message-State: AOJu0Yx+v2Y2hf18NGdX1+tcsQWOoR4VLYUXMry8xR0m127Tij8IVydk
	BDantIehzOQv9u9JsrkVfQIRHkF8om3MssjX0eVURA2Sptt9gEr3IaY0xCQ1jeeWzpxyjvRRU41
	oZggZ
X-Gm-Gg: Acq92OHg36MrufY0JI9+sySi6xvpjVV0KqGZx/wAPoVPptbFIv81H8SvOLvP1NDHSgv
	pa29pUgoEvnqZfCBnjogJi+J5OBDX+m8abgod+rZzKGlc2GAHUS1CJ+P61/m4pSIS8M82HipgXj
	IVeOW1SJruEMgpAInYUa1EAzyN+3PSKkPmbu2u1fiIq65TXHlxv177LHxAMgP//WYs9/MhSCs3C
	Ah2S2r7re9VNWpLo35GfsGC9B7xsZRQRvV0L1CozqpMKchDT2xtUsukfeoHUx2DitlT68YLxGJU
	IvbgTsTikfFphzKmvnqDrmh/GrL5xJZJ8j/VyFRniPz75PkHBMJdHgNzIRZrv3wDPNjWvpBUdy1
	cIueSO3gaRct/Lobq919HbJtSQk/S9SCTkSFPyksF7KNTUGaKZXDeGVlXVjRaRxx6Jm2+QR8lgA
	Y3TYiT47HwU3xXrfHyvalCaIIaV18cpvZ4S7hwQeb3K07Ej6w5ER7UqLk2mETrQyv3zceIhEfgR
	uJ2eQ==
X-Received: by 2002:a05:6512:405b:b0:5a8:76b3:7196 with SMTP id 2adb3069b0e04-5aa2ba6a288mr372957e87.2.1779362662464;
        Thu, 21 May 2026 04:24:22 -0700 (PDT)
Received: from [192.168.1.100] (91-159-24-186.elisa-laajakaista.fi. [91.159.24.186])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5aa2f15783csm166677e87.83.2026.05.21.04.24.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 May 2026 04:24:22 -0700 (PDT)
Message-ID: <e63e9232-6802-4501-a76b-a0cb93c77d5c@linaro.org>
Date: Thu, 21 May 2026 14:24:12 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slab: fix probable issue of dentries registration
 under /sys/kernel/slab
To: Harry Yoo <harry@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, Hao Li <hao.li@linux.dev>
Cc: David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hugh Dickins <hugh@veritas.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260520011019.1707010-1-vladimir.zapolskiy@linaro.org>
 <8a80496b-1568-4a0b-a878-836c27d19ad5@kernel.org>
From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
In-Reply-To: <8a80496b-1568-4a0b-a878-836c27d19ad5@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bird6p3y8buc1bfutjnjhq4fsbgm8chh
X-Rspamd-Queue-Id: 66FAFC0006
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779362664-715316
X-HE-Meta: U2FsdGVkX1+Q9ehKFh1EhF+bTyGMU9YBBOgpBPrJM5f3CzJyBgkSpvF8deqYyNgtiOUY24C8KJif88pz6db55bz/AypZvZpKd3bBwy0w9C1NZK34glauLB4BZ7TRZ55qzzWZBA7IZBzYHofadQB2EwDs+50OppBroh7CvmQddem8jFbuyzE5cy5Q09HrUs/HrVphTtG5KfqVMTznRig68oFS7e0bo1z1FZahxr+CgNSnaDaOy528PqvT51g81onnWCRVJBTrUCT1MXrAItCY7M4y57gTrRxOFdl6P9O5bruPEcD1qhKihYcOy1UfkojdnZObyJN4SWXw/Lv5Il3+7eSebGjlvtnDUP+Dge56fi3O0IDgUWzkCd40cbvTbPt0zBuwS/27k1egYyQsPC61VEcl5rU7i/Uxxw8LpjtC48KJ98phGcaOZY2BM8uhC4uHmwUuDBZiD02rGH8alU/YPzpc8dSRzYbGQOe3eP8IPLTdsyhm4vosKQUx8YL/r2oXl2vcTpsy0aPcFTGQVMvDrkVzvkSIcOpUU3iDZyZy7jucovICDo1epg/9HBeuxl54bvs9PZcoqLQnkvlMLxuBPkwjcpRhQvTu9TWZIR0H3XE0VjO2tP5k1Fiqb+wi+17a6H9VkD92bjh1CChXmN19w0RrQc6yg7W4k37izCiV3tLMoVzrAHKiP7TQ1XvYP6aboGvJbElQn8GNizIjYYs3ItGMhk4Qxqxlhdb/tXIe7hF98sBsYTzgbvjhVRTmohNe3cYLqOZA2H+9ldnl63JQbjQLE1lq2p41k6o6y1hdoZVNo/n5oBfbD4S5FrnBygDib/YDCo7koYCA/05PgAwAtPpLEXiTAw2vF9wj2P2PF6T7yYa/JTwZ1xJqjzni1JKRxoj538mrOWyd6y/G/hqlFVbRxYZfWVP/4iNGlmo/T9WHtHkpet47fNcaktjQgi134ipLlGAvEk3108sH6cW
 tLPJwkkC
 FxIr+gRZ0xFNwVeqKYiLbXjSNoFJ60w+HCYLEociJMD8uxiQkDwvkbMqYpBM87bOyAP0N9i8nMTKzmYpBwx8zjyKmxI+HsqENyMqa0D3zyqrx8zIM3Z+NElqhcAXWKnXBVpGLLMbEbUOUWBgmexjUBlfrvqWeTfZyJbSJ16RXtDIiZd4V/Wbva95sZh6Zc0Xpcw5wUIePpkfpFDCFNTxigOt7EgKjxBlhVXTFfwfzmGkpul8TaI9ZEcujJ0LVUNW7pPImZPLyJslkEt7q3Quka/Ke5z+4y5q7phAmt6xG7rFqte2QH/8q576k6XTeX4NnfyYlcECyIfLbBtphY2cx67aBpyPRdQk4NV4M/1Ef/vjFtVPxDNYXx4PtlA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Harry,

On 5/20/26 06:42, Harry Yoo wrote:
> 
> 
> On 5/20/26 10:10 AM, Vladimir Zapolskiy wrote:
>> L2TP/IP and L2TP/IPv6 protocol names contain a slash symbol, however these
>> names are blindly used as symlinks to slab cache objects registered under
>> /sys/kernel/slab. This kind of symlink creation is successful, but its
>> dentry is obviously broken, as well it breaks the access to the list of
>> /sys/kernel/slab dentries.
> 
> Oops. I just loaded l2tp_ip module and it indeed broke it.
> 
> $ ls
> ls: reading directory '.': Input/output error
> :0000136/                        kmalloc-rnd-01-16/   kmalloc-rnd-15-32/
> :0000192/                        kmalloc-rnd-02-512/  memdup_user-32/
> :0000560/                        kmalloc-rnd-06-192/  memdup_user-4k/
> :0000768/                        kmalloc-rnd-06-512/  pde_opener@
> :a-0000168/                      kmalloc-rnd-07-4k/   pidfs_xattr_cache@
> :A-0000184/                      kmalloc-rnd-11-8/    RAWv6/
> audit_buffer@                    kmalloc-rnd-11-96/   rpc_inode_cache/
> configfs_dir_cache@              kmalloc-rnd-12-4k/   task_delay_info@
> ecryptfs_global_auth_tok_cache@  kmalloc-rnd-13-128/  TCPv6/
> fscache_cookie_jar@              kmalloc-rnd-14-96/
> io_kiocb/                        kmalloc-rnd-15-2k/
> 
>> Likely L2TP protocol renames cannot be done, since the defined protocol
>> names are exposed over /proc/net/protocols for years, but the symlink
>> names can be renamed, because they are yet to be properly created, and
>> this should be eventually done by this change.
>>
>> The problem manifests itself, if CONFIG_L2TP_IP build symbol is selected.
>>
>> Fixes: 81819f0fc8285 ("SLUB core")
>> Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
>> ---
> 
> There is also a debugfs feature that would cause a similar issue.

thank you for review, I've just sent v2 fixing __kmem_cache_create_args()
side. As for debugfs I haven't reproduced any similar issue, please give
me a clue here, also likely any non-slab changes should be done separately.

> Can we replace '/' in the cache name, without renaming the protocol name?
> 

I believe that's exactly how it's done, the protocol name is left unchanged.

-- 
Best wishes,
Vladimir

