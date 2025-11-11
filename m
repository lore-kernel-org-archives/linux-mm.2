Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 196BCCCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 12:28:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56BDE8E0007; Tue, 11 Nov 2025 07:28:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 542FA8E0002; Tue, 11 Nov 2025 07:28:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 480CA8E0007; Tue, 11 Nov 2025 07:28:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 36CFF8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 07:28:48 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E8E604A551
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 12:28:47 +0000 (UTC)
X-FDA: 84098255094.18.0CE3D16
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2855C1C0007
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 12:28:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vKxzX0wr;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762864126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JTvP5vxQEYtfYTlHY1HTXzoO9Iicc6ibib68+E/xsbg=;
	b=G1r4G7luR5jn49FDlgs6fkruDUIbuuRWmH0VxD7ghmqF/KazEJPWH79zkhxGjMM9vIpT3I
	+FyPXPGlkNq9KJdxjKe44L7u7ZVMj/UIBXutgTKgUUQXeSSNpq8h81EshXuk5jG2fJkzhX
	T704+lzDkQm+X8fP+vU4m0stNm9gD1g=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vKxzX0wr;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762864126; a=rsa-sha256;
	cv=none;
	b=BNcW/1BpcCV9CNnqhPgpkeeih1ehJ3pPV03RuIMyOY8zl+1UAAHL2CoE6umAvd/7yHjIWK
	Wj3NC0mungFCIECcCnBn6Z477P/pl3tSSJbnK1iVc7Bu7g59UuXTrmmbFX8Libvrn8kkUu
	ZR8cnACN4hmS63JSyQHniYXJOWjr/J4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2558E4024C;
	Tue, 11 Nov 2025 12:28:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F770C116D0;
	Tue, 11 Nov 2025 12:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762864125;
	bh=QBPQY2h3jb/dwTv8ixDDU/KeHlFYOPsvatKmJc16Bpw=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=vKxzX0wr6ntIaxsK/A53hJWE8lLaVeIm69oxgve/EX5SRbhA+pZALO6oZirT/Ncwi
	 jUAHgUFt6USdqjMZj9fX0ByuYJS9TgpZrbp1dalhANR68mARv7EpZCA7T0WH1PJ1Ql
	 s96onujRGUeSVaDS57BbFqPQIkf68jPyOfckNz/F7YWI4ppD3ttAHnnTblSm67XLjT
	 pol5Cl5oPHZO1FrLjEgRMsnDwtaPc0ktaq/LnFNnSlUNquxzwSPzCDjgAhEJFgeLAs
	 gL80VUVermJRjuSoQ1suChEgy3U4XFDrDNGY9Up2R4zc8gDnU4jVyVobAoZ1wjVhx/
	 DQX5sdotI1TDA==
Message-ID: <2093f05a-542f-4d4d-b8e9-22b14d0a7a4c@kernel.org>
Date: Tue, 11 Nov 2025 13:28:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: restrict __GFP_ZEROTAGS to HW tagging
 architectures
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: Jan Polensky <japo@linux.ibm.com>, catalin.marinas@arm.com
Cc: akpm@linux-foundation.org, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, will@kernel.org
References: <20251031170133.280742-1-catalin.marinas@arm.com>
 <20251109003613.1461433-1-japo@linux.ibm.com>
 <690ce196-58cb-4252-ab72-967e1e1574cf@gmail.com>
 <aRG05VS-IIxV2y_C@li-276bd24c-2dcc-11b2-a85c-945b6f05615c.ibm.com>
 <fbca7868-6f68-4b98-a2f2-e39eb46b7f12@gmail.com>
 <aRMTdt5tqJhjLgGd@li-276bd24c-2dcc-11b2-a85c-945b6f05615c.ibm.com>
 <e2b1339f-89da-4500-b638-c915e15d6c09@kernel.org>
Content-Language: en-US
In-Reply-To: <e2b1339f-89da-4500-b638-c915e15d6c09@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2855C1C0007
X-Stat-Signature: iwum15p4uam1dnmj8it7wtmstpmf97nt
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762864125-608910
X-HE-Meta: U2FsdGVkX19YoGX5tgikkaRfo29h8XbTQm98EukKJINeAnfVlNmPPuDbbyFeiqIKYwAlH++WieVDcLTpiKGc8HzCTauPdpEzK4E6SdjS41SXmYjXTJ1fMv41N5rCvLLF8/vj1J/3vb2aTy3NldbiwGb5iFkJ83JRiMCcOBDPBg2amFvO1MI3S5zIfbIuNVsCWc5vMMTgsF+Jg56g4R6arW2xligVRzMeUeukyqecZ94QfYTZGtvXNDC0wSFfDMhCBiSkxB+iodE+fgFOSJnDIBVKIYHPLK2IOtCW5qJcBAY0iad2+keP9uFBHwptYif90loWIh9b45i61ju8A0SEQ9Bkipf0amQEbeyHp7Wulgi0Vt5MSJs0YKYWPpIlf3FtITgpbtwB6+FTuXaY4+99wfLvnZIv0JFPkeQUVX9JrLUrUSWYfkqgIAH3oZDGbcfTh/HQ2KGOBtnN9yIWeUSQmh48Xbcdembhk/R0FYpBzARAfNDb32G1WPzhojdCt7OPVdriSTU99B1TVMjp2x0TUk9ouYYNSgk38aeiTqFHZ+7ztNehGH2mpQKDrGL2jlreqiI1bGaDpb0wTuywondMpRLvRgTTZV9le2480e3UmHmtq9NZ9Zucw9dCdAdGVao3oHXPV8iJ75f6me9FGQLwzXQmj/V7GhTe80e2SR3MAFwzpj19J6fH3JNXm4oHzgt5wcERJe8uktLN+OJU5t4/mPlqjPOe01TKidVXWIeNvVywNfKJfpXDLXXAD1lgMJIpFfTFOanwFXBi//ntH1CsSM5sCfikueMysjuKkMzxSbWO0LAOfpIziY39f0x7Lwc1mtrFWgiU5kLv5o9BFX+/cC36fRiR9MNtuVHUbK6EJGjsABuqikEUtPkkESzvmDrpgFKSpJ+4eJvq2Xx3QBtQ31O5Z06DnNXfirWfG72QPwON3yL4ekHpDRVyPu79zutRiwxRcgHzlY9iFXPn1Ib
 chp1glsi
 KA/n3nDe74LFYU/BE1Ycj2+RExBmgLhpG9pTlaSSBtSYw/1MKfrHCURVQ/9i/GIJiRmmzldE5+w2Sz/6cw0VkRNqcLy2NXzzpQZmr//jVWMuYKnEBHYkIEfck5c1kGhI19JTmne2iZdTFtF20tqZIC27rvw0BGukxM0jGx9WrlBBK0AIMlR65lKstM2FAwrvGpyGs1L5dWvxZed9PNph77UUA5VBIyNYEEv7zBkbivkDmi83ktYRF1akvVmzKSDLSduKD3dKOef18dusuDRMRaqmcJvPys3wgYL1EN3fF1e9dmNeAPaBaMBCRUqc4DMCg1DaCfd4jX4+b2bg8pjy6nHekY78vC34omhRY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11.11.25 13:27, David Hildenbrand (Red Hat) wrote:
> On 11.11.25 11:44, Jan Polensky wrote:
>> On Mon, Nov 10, 2025 at 10:53:33AM +0100, David Hildenbrand (Red Hat) wrote:
>>> On 10.11.25 10:48, Jan Polensky wrote:
>>>> On Mon, Nov 10, 2025 at 10:09:31AM +0100, David Hildenbrand (Red Hat) wrote:
>>>>> On 09.11.25 01:36, Jan Polensky wrote:
>> ---8<--- snip ---8<---
>>>>> I wonder if the following would work:
>>>>>
>>>>>
>>>>> diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
>>>>> index 65db9349f9053..56b82e116cb79 100644
>>>>> --- a/include/linux/gfp_types.h
>>>>> +++ b/include/linux/gfp_types.h
>>>>> @@ -47,7 +47,9 @@ enum {
>>>>>            ___GFP_HARDWALL_BIT,
>>>>>            ___GFP_THISNODE_BIT,
>>>>>            ___GFP_ACCOUNT_BIT,
>>>>> +#ifdef __HAVE_ARCH_TAG_CLEAR_HIGHPAGE
>>>>>            ___GFP_ZEROTAGS_BIT,
>>>>> +#endif
>>>>>     #ifdef CONFIG_KASAN_HW_TAGS
>>>>>            ___GFP_SKIP_ZERO_BIT,
>>>>>            ___GFP_SKIP_KASAN_BIT,
>>>>> @@ -85,7 +87,11 @@ enum {
>>>>>     #define ___GFP_HARDWALL                BIT(___GFP_HARDWALL_BIT)
>>>>>     #define ___GFP_THISNODE                BIT(___GFP_THISNODE_BIT)
>>>>>     #define ___GFP_ACCOUNT         BIT(___GFP_ACCOUNT_BIT)
>>>>> +#ifdef __HAVE_ARCH_TAG_CLEAR_HIGHPAGE
>>>>>     #define ___GFP_ZEROTAGS                BIT(___GFP_ZEROTAGS_BIT)
>>>>> +#else
>>>>> +#define ___GFP_ZEROTAGS                0
>>>>> +#endif
>>>>>     #ifdef CONFIG_KASAN_HW_TAGS
>>>>>     #define ___GFP_SKIP_ZERO       BIT(___GFP_SKIP_ZERO_BIT)
>>>>>     #define ___GFP_SKIP_KASAN      BIT(___GFP_SKIP_KASAN_BIT)
>>>>>
>>>>>
>>>>> Likely we'd have to make __HAVE_ARCH_TAG_CLEAR_HIGHPAGE a proper
>>>>> kconfig option.
>>>>>
>>>>>
>>>>> Then we could turn the default implementation of
>>>>> tag_clear_highpage() into a BUILD_BUG.
>>>>>
>>>> I'd like to suggest to keep the enum untouched and only use the second
>>>> part of your suggestion.
>>>
>>> Why? We also do that for CONFIG_KASAN_HW_TAGS, CONFIG_LOCKDEP and
>>> CONFIG_SLAB_OBJ_EXT.
>> If we remove the enum entry, we’d also need to update mmflags.h because
>> the trace macros reference it.
>> Enums are compile-time only, so they don’t affect the generated binary.
>> My thought was to keep the enum list as it is and just apply the second
>> part of your suggestion.
>> That way, the trace definitions stay consistent without extra changes.
>> Just an idea, happy to go with whatever you prefer.
> 
> I think we'd remove the enum value as well, because then there is no way
> it could accidentally be reused.
> 
> And yes, as you correctly state we'll have to update mmflags as well
> like we did for CONFIG_KASAN_HW_TAGS etc.

/me realizing that my mail client decided to use yet another mail alias, 
I hope I have it fixed now such that everything is sent from my 
kernel.org account ...

-- 
Cheers

David

