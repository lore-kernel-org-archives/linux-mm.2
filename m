Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 710DECCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 12:27:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBA228E0005; Tue, 11 Nov 2025 07:27:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C911F8E0002; Tue, 11 Nov 2025 07:27:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCE308E0005; Tue, 11 Nov 2025 07:27:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA4EA8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 07:27:10 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0EE2988E40
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 12:27:10 +0000 (UTC)
X-FDA: 84098251020.02.CE2ADE6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4110240008
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 12:27:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iVfV3zZE;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762864028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uOKtIcKiSnqa9LQ6PDlJXgH7KMz7cEzsEEGJs0DM60E=;
	b=S1LpEIwmx7bMVNsTgfT4O6Lt6bnGVBm45Vi2wjhAsvFuSkxHNyZqZIqbwfs7ckdZvKgcgf
	Txt6+E2LiyonKqdOzwJ6ZzcfBK76iieCVcMdp9sBnWw85DYnbuU1yIChbajzgyqYiLLr/k
	htMoEJFbhwg/BOqbU4qFodMsu2cWBrE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762864028; a=rsa-sha256;
	cv=none;
	b=xXCBf9cci30v7+Z9bu6D2YCQOBIYiIAaLtZ8hNVLvVbdNzO9Vl6Pp0X2N1TdAgB9JAE4s9
	MoGyHN0MqnSnjHtDS34KLU9+9FSrodO97SwBdhn50b7iELgiqJgMfH2BCSvP7aaIBPTzdG
	p6463iBbXVpeYKB/1UH5GhHv3duJLdE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iVfV3zZE;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 262C243D23;
	Tue, 11 Nov 2025 12:27:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38FF9C4CEF5;
	Tue, 11 Nov 2025 12:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762864027;
	bh=aqDfiydvnVJkvaEowpMZlpXtb2930fTV0jo2nb/Yezw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iVfV3zZEbyZxRw8I78bwgSfHLHlmQ4HZ2Xz+2Mp2kY+F5vGfYhDYDMkU3/vBxRsoE
	 ChDQGktRiOJLXy6BU1cDG0ERZWNkiY++pQt9yqqVDKMjxrrjYJwdsAsQ0qRZCkrZZQ
	 IkMlk96jrxP8MRn4FolyyqVH47mqM8HE+czkR0ZpCkytflv1PlV3A7xN9XPpf2PVQC
	 Vd+EjGptOzFyPx1BjahnCgcwWVGBuZaAgwkgmvl4jLHrsOgXLIMe8lDHYlpSgAbBRx
	 CrNmx3gVtzLSjcQWWRkKfjkoxGVxiLDkRXTaObEuVDH+e/MKGO7T0DsISnrFaFAyks
	 cjsd+DewwrUeg==
Message-ID: <e2b1339f-89da-4500-b638-c915e15d6c09@kernel.org>
Date: Tue, 11 Nov 2025 13:27:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: restrict __GFP_ZEROTAGS to HW tagging
 architectures
To: Jan Polensky <japo@linux.ibm.com>, catalin.marinas@arm.com
Cc: akpm@linux-foundation.org, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, will@kernel.org
References: <20251031170133.280742-1-catalin.marinas@arm.com>
 <20251109003613.1461433-1-japo@linux.ibm.com>
 <690ce196-58cb-4252-ab72-967e1e1574cf@gmail.com>
 <aRG05VS-IIxV2y_C@li-276bd24c-2dcc-11b2-a85c-945b6f05615c.ibm.com>
 <fbca7868-6f68-4b98-a2f2-e39eb46b7f12@gmail.com>
 <aRMTdt5tqJhjLgGd@li-276bd24c-2dcc-11b2-a85c-945b6f05615c.ibm.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <aRMTdt5tqJhjLgGd@li-276bd24c-2dcc-11b2-a85c-945b6f05615c.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jrbwri43dmambm173un33mo91nfg1gjo
X-Rspam-User: 
X-Rspamd-Queue-Id: 4110240008
X-Rspamd-Server: rspam01
X-HE-Tag: 1762864028-784155
X-HE-Meta: U2FsdGVkX1+XRStxCGTEzUTxh05EuJf40bEr+c/5vJbBeXVIk8tZRFBhLhKw5svmFFu9K+HJQ4+vNZpoFXNnziRPWk3J0TRP01jRuZI88Jt9DQt0Rh3kWi9glFKIF/3xLGNyhPdwiA7Eqo/yy8baZ+gMilU/vTZ2yK0gkPD1oB0rcl4xyG3TKWhZuN454G+PxjDLYbVIhtEUE/HDRxdYDXqMJLgDiuZiuZ6dahgUPD1KkcKnQYPHOGjVQWEhe9ksbanQTfRuqgsHPMLZL7U3u/c2ukh5+918+J2r1ptHHJgp7sxwbmBnlrbkoo7s+m1D9OwYz4n3mhoZIBpMNeArRZ6k8kNH1KSQ+rupmWc3Phz9whCVXIw0s04xL0PXBl1LDT5p5RUFvh0DXu4McQZj2F7j+SX4wnG1QWSOP3P+C5ZjFpsIvPQ9DU5SBPgD2dXuOrcJZmemB7pJ78+timbiq5ImodizX3Q1NSnKTzwjD5GRPvf5mdl5kTOt9EMn2XiqA9Jt54SN+p1U+1KKvQGYbuCXZl7gOkl3PE16v3YAwqyhSZEVojlRujxtOx7su2HADdAqLfNSIdrJV3q335iuKk8gDWofBl1ooWDCCgGwCL2i2QLr4az021DuLKiDF1cAUcdcjV4ZUcot8/EtCOjQNlLRLTnmveKE2DCOso0xkoyh8W/QyPduWf/AgjkLUS6pVbOxVw/n8RsX3izc046G2owlUSMkocOXKTDHs2AFtm8s34sUn+FS4eV0/GbJBDQ5FN8YWmoBrZfxDo5rFFxNu6GJHHt+fkdeA0mp8grG+XzOhWBw14U4lKXGKaY5Lap72gwfLwTzeC2qMGyDG6QKTiWze54EV78nJbSRCykJQWlhxvNpKP/H9tLBCXeqdVrbecP49z0SvgXyTM8L3CbBXRlzTOmDkA7FtUo7/XJFP4wKGLjjMNgCNq9L0KUBzdVsAqbKR3/hdvIuDpnfvFU
 gvM3wGct
 iq7JFU1gaJkvWn22Azu4e6XJo8dnYIFbCevG9nS1cdi3HpmKs7sxVoCYnT20o+xo00bFy9TanHyMlTL9EGDGkgo+hl3t+49go3wtImBt9QXrxzjSKMBp9AIsk7NyaRVKGMiOqNnyMJJ/cn0Y21ex7dWtwo6X7mZXJrlOFJGDajjTq90a55hTkrIAr/DJpyncR+BX6otOvi/43dnYs+SWxcjcs8JHzZMjKbo4cALE/aeUyRBVYHK/ebysjrR5SOtTsekjHNj4bhdL34lS7xnHP0FBRlr3+D2qx+CRCSdHOYwv05ZaEJUrMfiGbzroSRzQFQcrTwtj4EQANeqU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11.11.25 11:44, Jan Polensky wrote:
> On Mon, Nov 10, 2025 at 10:53:33AM +0100, David Hildenbrand (Red Hat) wrote:
>> On 10.11.25 10:48, Jan Polensky wrote:
>>> On Mon, Nov 10, 2025 at 10:09:31AM +0100, David Hildenbrand (Red Hat) wrote:
>>>> On 09.11.25 01:36, Jan Polensky wrote:
> ---8<--- snip ---8<---
>>>> I wonder if the following would work:
>>>>
>>>>
>>>> diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
>>>> index 65db9349f9053..56b82e116cb79 100644
>>>> --- a/include/linux/gfp_types.h
>>>> +++ b/include/linux/gfp_types.h
>>>> @@ -47,7 +47,9 @@ enum {
>>>>           ___GFP_HARDWALL_BIT,
>>>>           ___GFP_THISNODE_BIT,
>>>>           ___GFP_ACCOUNT_BIT,
>>>> +#ifdef __HAVE_ARCH_TAG_CLEAR_HIGHPAGE
>>>>           ___GFP_ZEROTAGS_BIT,
>>>> +#endif
>>>>    #ifdef CONFIG_KASAN_HW_TAGS
>>>>           ___GFP_SKIP_ZERO_BIT,
>>>>           ___GFP_SKIP_KASAN_BIT,
>>>> @@ -85,7 +87,11 @@ enum {
>>>>    #define ___GFP_HARDWALL                BIT(___GFP_HARDWALL_BIT)
>>>>    #define ___GFP_THISNODE                BIT(___GFP_THISNODE_BIT)
>>>>    #define ___GFP_ACCOUNT         BIT(___GFP_ACCOUNT_BIT)
>>>> +#ifdef __HAVE_ARCH_TAG_CLEAR_HIGHPAGE
>>>>    #define ___GFP_ZEROTAGS                BIT(___GFP_ZEROTAGS_BIT)
>>>> +#else
>>>> +#define ___GFP_ZEROTAGS                0
>>>> +#endif
>>>>    #ifdef CONFIG_KASAN_HW_TAGS
>>>>    #define ___GFP_SKIP_ZERO       BIT(___GFP_SKIP_ZERO_BIT)
>>>>    #define ___GFP_SKIP_KASAN      BIT(___GFP_SKIP_KASAN_BIT)
>>>>
>>>>
>>>> Likely we'd have to make __HAVE_ARCH_TAG_CLEAR_HIGHPAGE a proper
>>>> kconfig option.
>>>>
>>>>
>>>> Then we could turn the default implementation of
>>>> tag_clear_highpage() into a BUILD_BUG.
>>>>
>>> I'd like to suggest to keep the enum untouched and only use the second
>>> part of your suggestion.
>>
>> Why? We also do that for CONFIG_KASAN_HW_TAGS, CONFIG_LOCKDEP and
>> CONFIG_SLAB_OBJ_EXT.
> If we remove the enum entry, we’d also need to update mmflags.h because
> the trace macros reference it.
> Enums are compile-time only, so they don’t affect the generated binary.
> My thought was to keep the enum list as it is and just apply the second
> part of your suggestion.
> That way, the trace definitions stay consistent without extra changes.
> Just an idea, happy to go with whatever you prefer.

I think we'd remove the enum value as well, because then there is no way 
it could accidentally be reused.

And yes, as you correctly state we'll have to update mmflags as well 
like we did for CONFIG_KASAN_HW_TAGS etc.
-- 
Cheers

David


