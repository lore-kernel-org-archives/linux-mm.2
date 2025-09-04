Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CDDCCA1015
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 14:11:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CD098E0005; Thu,  4 Sep 2025 10:11:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 756C48E0001; Thu,  4 Sep 2025 10:11:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61E4E8E0005; Thu,  4 Sep 2025 10:11:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4AF338E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 10:11:10 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D67DE1DC51B
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 14:11:09 +0000 (UTC)
X-FDA: 83851754658.21.A2FEF20
Received: from mailrelay-egress16.pub.mailoutpod3-cph3.one.com (mailrelay-egress16.pub.mailoutpod3-cph3.one.com [46.30.212.3])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4577C140013
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 14:11:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=cOebGlCu;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=XDWBDbeY
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756995068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cuct/RPYsog3+FtV3cKt5Z3ifZSx4ZMCF7gpniW4mCI=;
	b=GH+Pgy3CxC1wf6Oajp3iNZ8GkIqWQY7q4l6DunrJBNNAXFqiezrNg3Nudcdj01oSa6c3RA
	U6pjoDPFyW1+/MqaqVVd0LQzhIJZ9stBjq60QwcawAuqRAdO9wsg4OcpGsvxYqQG60M7tj
	lOrX43SHKd3uxjjw0U+/KtBKKPzQGUA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756995068; a=rsa-sha256;
	cv=none;
	b=1V1dbdHeLU4LakKsODK9cVM/ja+3odXPVWcduR+GEAQW1monTGGLxRuyNNqVDC1TDhxI5D
	IOIVkPIQANugGwQzcosVNvJmhyr3uzAECUuOvkOxqQfwtM2sW21mem6x2J/nLV4OMMDG/V
	q9Q+N6oKDWoPJMb+ilPBDFF9mo8L5oI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=cOebGlCu;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=XDWBDbeY;
	spf=none (imf23.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.212.3) smtp.mailfrom=vitaly.wool@konsulko.se;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1756995065; x=1757599865;
	d=konsulko.se; s=rsa2;
	h=content-transfer-encoding:content-type:in-reply-to:from:references:cc:to:
	 subject:mime-version:date:message-id:from;
	bh=Cuct/RPYsog3+FtV3cKt5Z3ifZSx4ZMCF7gpniW4mCI=;
	b=cOebGlCuczRNUo4g4d4ajARv60jt0S+Wqh8jmDRu9Mf8FSF2YmYLUMztYuqnrS4XJpBsG/xg1SVS+
	 RnSqIoV1kkhmJ4y3BDMWwp5XlyiWt/dFGIGcOHfmUIv+yMDcvE7rBC6BuBYcbNTCMLLdohKwwSWIsl
	 nC4aiyT77ewScMsTXAI7wi46r4YPrGNI7i0JyYiDSX0gPwx1U8UKy0JTnqVk+rwcy96mexlsJ+pUsV
	 dA/VEP8cYUpBEbkmua1h4auMdHVoG9vmCwmZNmGUM5Ek3Tug3qqjnV7ewydRTgOPCEnLgz8xfRCcql
	 OOOQ0wMx2o5PiJZkInAIMx7sRP3Mf5A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1756995065; x=1757599865;
	d=konsulko.se; s=ed2;
	h=content-transfer-encoding:content-type:in-reply-to:from:references:cc:to:
	 subject:mime-version:date:message-id:from;
	bh=Cuct/RPYsog3+FtV3cKt5Z3ifZSx4ZMCF7gpniW4mCI=;
	b=XDWBDbeYOioZ7VHX+LhpdlOj714dmqlpXCpsNZKSu/SjlWyYcRG8rDDbnJO5SdO9yda8iNTFDQHot
	 PnZ+fFgCg==
X-HalOne-ID: fd8e0ca1-8998-11f0-9595-c9fa7b04d629
Received: from [192.168.10.245] (host-95-203-16-218.mobileonline.telia.com [95.203.16.218])
	by mailrelay1.pub.mailoutpod3-cph3.one.com (Halon) with ESMTPSA
	id fd8e0ca1-8998-11f0-9595-c9fa7b04d629;
	Thu, 04 Sep 2025 14:11:04 +0000 (UTC)
Message-ID: <1d42c513-cc83-4f08-a10c-cbd6206070f4@konsulko.se>
Date: Thu, 4 Sep 2025 16:11:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] mm: remove zpool
To: Vlastimil Babka <vbabka@suse.cz>, hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Christoph Hellwig <hch@infradead.org>
References: <20250829162212.208258-1-hannes@cmpxchg.org>
 <20250904093325.2768507-1-vitaly.wool@konsulko.se>
 <7b1ca42d-1b89-44f4-bffb-e6b09f86fdc5@suse.cz>
Content-Language: en-US
From: Vitaly Wool <vitaly.wool@konsulko.se>
In-Reply-To: <7b1ca42d-1b89-44f4-bffb-e6b09f86fdc5@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4577C140013
X-Stat-Signature: aj118gwngr35yinieabdznwt6g88a7xo
X-Rspam-User: 
X-HE-Tag: 1756995067-704320
X-HE-Meta: U2FsdGVkX189AuSXYSs9MpDUKSDAaMsS3ie7xg7s9nJ0oZuEmd83iDx9kmKJQTZO5+GaT7K4XzeFo8QSNfcmx+bSJnauhoZQgDd6kpdnocBZtM+ofeysFugI0LdX6FIY+dBkRFVlKetdPWxwnEAuxW6LBNP7qlP3S0HbzBQ7uV1c8Nv1SQpeXcghiCH1kQiG0uRlYKYY1k6/mKvG0kPd/DAMXcPCZTmdLVnH+g7xrzSv2XeVs2Wu5iz4QsiIcpGIEiy8msYvsc+fP80C7fWJe4pvBk9nMHzs/USvljbKu4CP748CFteYKwR34JP/yYxYLQQIfm6vVDOoBcyF6to5AM45V5mbZdsmmv62ETYP6490IACA5cLedle56PBu3UbiEvQYbshxfEvKpI0v6hcWOxacoOtUwQ4JJcwgZEwb3S8ESIvOi29CnlMfF5OdxYf1dthq+NecHxYpUiXRzWgAuFqSCPJTUA2V6bciCIcY4pMUrnA1aCZu5qEpVi3zUm9Oo2SlN6MMTjTOquTn0PJF8PpDFuaZIxYasRO5fDEjhUeT+d+JJmNAQz/iMnAXnr/FKxCZY/otFT+mTlwNo7lrXJWsymyUkUdFwFTsPR3QWZfBwthB6j9A6NT2P+4wT1aEaI2GRsy9WDBXSjrUDGktStIFCDc02v/5n4HPbDSCW9hWl3I3j7cu1qvdwwQf5/BFHg0+fRdqfA3VsTHUEjEnD2WCma31TtZ+8GJsnT0BuO1YQxUcIm9F7Yq5fKnDbGOeIFzMF6ByepaIHT9s9JWN2dcuvKVcDWhq8i6E/LIHeWs0KJ4J6UYkGJfqScNwLEN14uiCJ2lFvJ/N/91phfzMVn+30yTZun8BOTmCasi+KGg+KRAJZSBJ2P1u+R4v6xJqLP9VqPmuj9WRZFPys1dfnPG4nwZYHy5zDiibXROjT1xMyw/uI9dK4x5o8UX9YhMqdiveTa7sERY3YG2SsDS
 472NxyoX
 awUeW32G8dwr7gf+4qQs9t27YScUa0zoFoCR1viAxLqcMFos2GzOa7X/mSt4zND1Y/rHEHj9eq1dlcVNh1rlC99qMo/l8DetxWXE8EDKJ2Z1sLUmHzuhNujUo6aYN1x50hwY5dCTjYMxdCa/rMM/jRe+V1tj4zRWSst95gcCHIqGieFxCZDnvEGsG9GlX8TcTXBHm2seVTbtl+mkdnuEZZMzeINw8yZFfoYgZIgNn8iUmQQnw2sXW5DgDisCfNMjMj1PDvxHtthD0Em9Wjgnj887G5EzkYSrR0mr+Gsup7oxrJzg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/4/25 12:13, Vlastimil Babka wrote:
> On 9/4/25 11:33, Vitaly Wool wrote:
>>> With zswap using zsmalloc directly, there are no more in-tree users of
>>> this code. Remove it.
>>>
>>> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
>>
>> Per the previous discussions, this gets a *NACK* from my side. There is
>> hardly anything _technical_ preventing new in-tree users of zpool API.
>> zpool API is neutral and well-defined, I don’t see *any* good reason for
>> it to be phased out.
> 
> AFAIK it's a policy that unused code should be removed ASAP. And that's the
> case for zpool after Patch 1, no? It could be different if another user was
> about to be merged (to avoid unnecessary churn), but that doesn't seem the
> case for zblock?

For the C implementation of zblock, no. But there's another 
implementation which is in Rust and it's nearing the submission.

> My concern would be if the removal breaks any existing installations relying
> on zswap. Presumably not as a make oldconfig will produce a config where
> nothing important is missing, and existing boot options such as
> "zswap.zpool=" or attempts to write to in the init scripts to
> "/sys/module/zswap/parameters/zpool" will cause some errors/noise but not
> prevent booting correctly?

I don't expect heavy breakage but misconfigurations will definitely occur.
> I mean if we were paranoid and anticipated somebody would break their
> booting if writing to /sys/module/zswap/parameters/zpool failed, we could
> keep the file (for a while) and just produce a warning in dmesg that it's
> deprecated and does nothing?
> 
>  From Patch 1:
> 
>> Note that this does not preclude future improvements and experiments
>> with different allocation strategies. Should it become necessary, it's
>> possible to provide an alternate implementation for the zsmalloc API,
>> selectable at compile time. However, zsmalloc is also rather mature
>> and feature rich, with years of widespread production exposure; it's
>> encouraged to make incremental improvements rather than fork it.
> 
> With my history of maintaining the slab allocators I can only support this
> approach.

There was the time when slab was the best option and it was more mature 
than slub, which is now the best and only option. Thus, the "maturity" 
point is indeed valid but not being backed by anything else it doesn't 
weigh too much. Besides, zsmalloc's production exposure from all I know 
is limited to the 4K page case, and zsmalloc is truly struggling when 
the system is configured for 16K pages.

Things keep changing, and some of the proven solutions may not be a good 
fit moving forward. While not suggesting that we should have a handful 
of zpool backends just for the sake of variety, I'd like to emphasize 
that there are good reasons to have zblock (especially the Rust one), 
and there are good reasons to keep zsmalloc. That leads to the 
conclusion that zpool should stay.



