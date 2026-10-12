Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C8DACA9EBD
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 02:40:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E89AD6B008C; Sun, 11 Oct 2026 22:40:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E13BE6B0092; Sun, 11 Oct 2026 22:40:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDBC26B0095; Sun, 11 Oct 2026 22:40:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 99D6E6B008C
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 22:40:35 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E57DC80905
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 02:40:34 +0000 (UTC)
X-FDA: 85312420788.10.D9D67DE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5C11EC0002
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 02:40:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="UBPtu/9E";
	spf=pass (imf22.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791772832;
	b=QcQr7cGF/CPqUm6Pgbb+ZeqzH82OhZtr/iXuZPJkteuUspKIMQ4L94Av1dy4gkC2Q7nVuW
	d1U3hLM3xVo5SeJdJl6lfBml0mGq259GciYYrqmgekQsp8P/8CREPuJjfqM3s3a1w4VA6c
	qpooa9u1rY7cmgUhY5PUUODavcD/tus=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="UBPtu/9E";
	spf=pass (imf22.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791772832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mptis6qqMpkv7ium90UiEIS1Bva/bRNNiMhKtY2RI7I=;
	b=QRjsaMAmBcm07m0k22U3G5S4QWizLM+mYV/k3uxsWakk3VKLkBGeHAcYD46f9jFlaOw0Bh
	gfJBK6xUnRJRhQfA9J4lmX+yib9zNvWJ0I3BmdqLC/IkXNxoaglkbZhihaRLJOYusaSFe5
	WNucwx8f7/FUKE051tL8g9VGqTWBuVc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791772831;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mptis6qqMpkv7ium90UiEIS1Bva/bRNNiMhKtY2RI7I=;
	b=UBPtu/9E/vWZkp//rdMpiDgwYU1OvG2iw0SKWc6HiZJNai7UTs4mwSADnet/59A5NFJq2f
	pozY2LfXL39tv9BedtUUZgfrYb8A5G+yNqE19eNKiC4Cw+ba0OTzVaNJeCQIc28+EyvrPG
	AYtiK4le72ABkO89GoC4ZKyRrKBg2RY=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-365-9DmYLxtBPcOYcIBDNsnDSg-1; Mon, 12 Oct 2026 02:40:28 +0000
X-MC-Unique: 9DmYLxtBPcOYcIBDNsnDSg-1
X-Mimecast-MFC-AGG-ID: 9DmYLxtBPcOYcIBDNsnDSg_1791772828
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-5338cfe567eso33051211cf.2
        for <linux-mm@kvack.org>; Sun, 11 Oct 2026 19:40:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791772828; x=1792377628;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mptis6qqMpkv7ium90UiEIS1Bva/bRNNiMhKtY2RI7I=;
        b=mytnSvCh3eyR8ofrEmzhQrRg4OWWuKIPZSCYaek7CRBp0R7y4EeTy/Pccz9dzGLs0q
         HW1R+AFiTxR3VB2Ys5RfHxHnHFpBU0Jg65k0pi7SwB1zGFX8TRJ/lj1pSdpHEity9JYS
         RJoElbbuMhn12meb9NUIfcA2p2ycEr0qHziEnvlfHn7t3pmXeW1GKw8gQS8fE+40k62H
         MU5g2BzftM0geaHkBopGdf84YdnCJwd9P72an9gwXkhYTxRsmw7J2E1mi3pWeIh/UGwE
         CYDyjRN7Wd2fsFCsUlZ9rn1A37q79z2JIdDFP5DgmhQYsRv9+gQZNqozmjPBxyGyiOfc
         3L2Q==
X-Forwarded-Encrypted: i=1; AKwUvBw09gsilnzdl+OtuLn+YnZt8U9umYGRjdgcCpY96HFnOqJfAevTsfgvqYKst7zndCQzbRDPP/iDKQ==@kvack.org
X-Gm-Message-State: AFq9FYIkbi0LB2p4Cz6DzMSt0d2bEwRnQw3eNav7cERaSoW6su7AGIH4
	vppG9aoT2/0Wq5XERF0rOrF3MEICB/ppuwQ+L7TBejMHGZZpU37o6O6WnMn2CLAR2OlQ3JEnOkB
	dTU7kZ0hklV/Z0UdxdLJKzeL7hxsYoytQ+INDIQ/HCyBlrFpHZxg/
X-Gm-Gg: AYBFou3QujL77OIeO+pbZWs3khwMBkpQMNrlxEGq5Lmh+iKOLQgrZpvg3jLbSZDVWQT
	fMDAVuShnzJ9SooHdpgCMP4ESWJ5tqywzaiBeyE6xa8tlTXXEKR5JgXc2+4pH7QwZCIAc8wApJO
	GzleODm4oy8Sp4E2XKMUM0uKJMuyE4vWBaUh2OcVkfmMoX+9Wq2NPmVArVEspG9lb1jfi/v9lUP
	9rZ35A4WWR4pndHgLia5swN64Xy2CgUk5GZKRCKHjcPAECLWt2Xx6s2RNZcW/VLlJsiamW9Sf8E
	VwSZ1kCZzQmAVRHTg47q8ltOq3vwrXMMHChY5l8xgU4rvG9eIOzIQQLeLkmSVZaIQzovTIAovH6
	kWMM=
X-Received: by 2002:ac8:5f4e:0:b0:533:97ab:dd45 with SMTP id d75a77b69052e-5359fb3dceemr148577441cf.36.1791772827782;
        Sun, 11 Oct 2026 19:40:27 -0700 (PDT)
X-Received: by 2002:ac8:5f4e:0:b0:533:97ab:dd45 with SMTP id d75a77b69052e-5359fb3dceemr148577221cf.36.1791772827331;
        Sun, 11 Oct 2026 19:40:27 -0700 (PDT)
Received: from [192.168.2.110] ([142.172.30.162])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b812ba8c7sm15440366d6.38.2026.10.11.19.40.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2026 19:40:27 -0700 (PDT)
Message-ID: <aae9d468-2dd4-48fb-8e2d-d6997ac8e723@redhat.com>
Date: Sun, 11 Oct 2026 22:40:26 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] x86/corruption-check: Remove the BIOS memory
 corruption check feature
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org, tglx@kernel.org, mingo@redhat.com,
 dave.hansen@linux.intel.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, corbet@lwn.net, rppt@kernel.org, blum@kernel.org,
 david@kernel.org, linux-mm@kvack.org
References: <20261010153604.1885381-1-luizcap@redhat.com>
 <20261010194519.GAasqVz2brXiOLegQi@fat_crate.local>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20261010194519.GAasqVz2brXiOLegQi@fat_crate.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: IRrAJKoJqOSBwY8zvN6WHIEnqhufrcMIwxbKezUFKKk_1791772828
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5C11EC0002
X-Stat-Signature: 5ds4q8ub19r3a7hqjp47spht1zpz6ufn
X-HE-Tag: 1791772832-388168
X-HE-Meta: U2FsdGVkX19XefawW63fNmqgGU/YDvAPsstbwiMr+ECKkd4B8rQ7h+z46HD6OqR+o5y7+cWOS9sWjSHlBFaOinO3SwYrroCOO7YjDBGxdjzQG9wjz/b5Rl4ARXzA9NX6k4tnOWOEymXJCxQ9ZcAEJTX7HWYC0YZfRT1FdjEHnSZS15KrtTh1/p6DinErSuAZNdWLRaxDuVIr3tChR/Y6LetoXHLTalyPJulknj91yH/SxUZD0n3ygCh1V0pWGBLKyFWBA9kndvzZUbf2/MdrNF5Su288qB5pS2U/p6048uD5D8Gbre33Sk7940cEc06a3zASdBT1vK1uCl+RqXVpHpyjN5vhxc+plWl8a6jV9dGQEcE43NJzsMxBEOFTS/3tHHR5ZvGrAEdKhfa/+nSJyRGCcArSueA5NQDie1pLxrhLQv4dWWUiplJiwquINTgfeV47bBigqrTuBcbupSFQYnwWV3uoDk5PVIBe0CgLxibV2oiZAkLMS5WMWX2JtXpCmTKjWCKLsr6BV5aGDmo37JTogeC2aVjs+17dOSKMudLfPzkqrS0Dt9sRxkQOaRQABHqsjptrKKcRdeXSHflLHdpT/PrePplA4WLmuLSuI7yQojbE7LOn/Q6ZxfEqXCOvdmEktPbKV5bSiWi2/9EtInuDNMAQlYAqrHTcfvkNGftgURmbU2AJ1yvkLsFx5elMKIk/khkzaeYUCXnSxjfjw1V5/xSAwRoSU0QuvMc85GPgqLRrRQIp5bjwxKU/y8/K/+b8rzVJ4e8Z/Ca/Jod4gYL0kKF4uGrLr6Uixrm95eiR+sJYJ17rp8RcfuYORt/p8xiWo0nft0ORQYsb8yksSi/h021KpZdai5p43muLXnckSpGmyuwZMWp5QhWRuVKDHPr3LsE42t3bldJiqxVSGUnJfc9IS5nhZWNmEhVeYwQlug2E1rKpETztNFnHXtKllMEy3sjRoEvEeKTYOrP
 pHApXcJq
 Z2vwn3masr8WvTlafGkcMUD8UC82mosHUbR4LsCsebABpWlqOyYidJlYXghRpor1mdwu5ITRxqscSNPs8bsAZQg047nuoJeeOs+m7s0w8Ls97bTl8HsiN5i+heLeAaZpWFGDv6OaFT2g9gAMYce8W2mOTynQxjkH6GJeFiz3GLdARF5hoTARAqNDrRm8UBTUAfgyzzjHIpgx/mfa1j3j5bL0MJKPP+itdXAJG12axqleK5a7kiigmChgJvgn80HsWfmLTTKPHd1/VVX9DBiOJeudug/vF57B6TBAn0oRkSLSKA9TeU9eiSLgc2IXfMd+JF0O9YtgbFcnIeh63wckbnPutqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/10/26 3:45 PM, Borislav Petkov wrote:
> On Sat, Oct 10, 2026 at 11:36:04AM -0400, Luiz Capitulino wrote:
>> By default, the BIOS memory corruption check works by reserving the
>> first 64 KiB physical area from memblock, zeroing it and then scanning it
>> periodically.
>>
>> However, this functionality has been broken in its default configuration
>> since v5.13 by two commits:
>>
>> - Commit a799c2bd29d1 ("x86/setup: Consolidate early memory reservations").
>>    Moved trim_low_memory_range() into early_reserve_memory(), which runs
>>    earlier in setup_arch(), causing the first 64 KiB to be reserved (when
>>    CONFIG_X86_RESERVE_LOW=64) before setup_bios_corruption_check() runs
>>
>> - Commit f1d4d47c5851 ("x86/setup: Always reserve the first 1M of RAM").
>>    Hardcodes the reservation of the first 64 KiB early in
>>    early_reserve_memory()
>>
>> It might be possible to get the default case to work by allowing
>> setup_bios_corruption_check() to run first, but it's just not worth it
>> given that the kernel will never access the first 64 KiB area anyway.
>>
>> Lastly, note that it's possible to get the corruption check to work with
>> a different region by passing memory_corruption_check_size=. However,
>> the main goal of the feature was to check the first 64 KiB. Besides,
>> the region picked will be almost random as setup_bios_corruption_check()
>> will pick a region by size.
> 
> And?
> 
> Do I want this or should it be fixed or the first 64K are not worth it to
> check or...?
> 
> That whole "rationale" is not really clear to me. Yes, it is broken,
> apparently. So let's remove it but we might get it work still... So which is
> it and why?

Right, the changelog got convoluted because I tried to document all the
options. Just to make it clear: I don't think it's worth fixing this, so
I'm proposing to remove it.

Here's a rewritten changelog, if you think this is good I'll send v4.

"""
x86/corruption-check: Remove the BIOS memory corruption check feature

By default, the BIOS memory corruption check works by reserving the
first 64 KiB physical area from memblock, zeroing it and then scanning it
periodically.

However, in its default configuration it has been broken since v5.13 by
two commits:

- Commit a799c2bd29d1 ("x86/setup: Consolidate early memory reservations").
   Moved trim_low_memory_range() into early_reserve_memory(), which runs
   earlier in setup_arch(), causing the first 64 KiB to be reserved
   before setup_bios_corruption_check() runs

- Commit f1d4d47c5851 ("x86/setup: Always reserve the first 1M of RAM").
   Hardcodes the reservation of the first 64 KiB early in
   early_reserve_memory()

This has been broken for years and nobody reported it, which suggests the
feature might have no users.

It may be possible to fix this by running setup_bios_corruption_check()
earlier, but that's not worth doing: the feature was intended to detect
corruption in the first 64 KiB but the kernel will never access that
range anyway.

Note that one case still "works", which is passing
memory_corruption_check_size= to scan a larger region. But this is not
useful either: the parameter takes a size, not an address range, so what
gets scanned is whatever memblock happens to have free below that size.

Remove the feature.
"""


