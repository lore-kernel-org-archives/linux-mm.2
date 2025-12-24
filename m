Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D136E7545C
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 14:50:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A94056B0088; Wed, 24 Dec 2025 09:50:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A181F6B0089; Wed, 24 Dec 2025 09:50:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C5126B008C; Wed, 24 Dec 2025 09:50:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 789976B0088
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 09:50:01 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E369BB7D95
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 14:50:00 +0000 (UTC)
X-FDA: 84254649360.23.2EBD764
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf14.hostedemail.com (Postfix) with ESMTP id E0AB0100015
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 14:49:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="YAzX/bzO";
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766587799;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O8VCVFBIYVyB4enyF1PmIUKAF90SGYaRlZJ5H717CXs=;
	b=pG5v29Tk040AJoxBiexUsvitbgFVD0uhJk0wG0FXHhW7n1fi98oDjGu+XcfhQh/+hYimZV
	MYxkmpC9YqA2KsjVgG0/ZslQYuXxFZfyNsULjvS2lwDH0yvqcBvUd+bUVrnO4Ib3IpIkjB
	ZQo6W/NuJl166EcBQXmD1VReR6BbA68=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766587799; a=rsa-sha256;
	cv=none;
	b=e3WTFoXvtVyPStYD84pPn5EuttGuP8SycB5kaxWxcmqB+7p80+FUyVP5t9IR8L13FSD6oZ
	P7Oxp3JGVOv+4jTu9SBAnjqtmNWO1D2JHDrNG+EXkPaVBn5YN5qPkBBijAF8bEt/NCEyOh
	iTNGriD8SBd0QTkPRmuUggfoTNCtmPw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="YAzX/bzO";
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-64b9b0b4d5dso9145210a12.1
        for <linux-mm@kvack.org>; Wed, 24 Dec 2025 06:49:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766587797; x=1767192597; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O8VCVFBIYVyB4enyF1PmIUKAF90SGYaRlZJ5H717CXs=;
        b=YAzX/bzOGanSviI3HKSLlzWtYsvJG/6wS7ERIqLwONpqmMTV3bWczzmPAfXehdy+ZX
         DXJN2wcqkJmtVj/CfN5buS9OVOcq2ng3zreVUuSxI6mQqgBorzD/I7MnPjA6J0ZpWij8
         kOx9BluXC6vk/nqTjyreXLEhFpbpzfT3JRiEyNqaxcV2g4zXoBDo6Q0kAtKHhj0UbTav
         2F7311bojm/u/VCqQMGpng1A0Ez0dB4h1CU+y8j3YXsYZcAeq2bVnTcLFtSxpTTXruzE
         YFwho1l7+tP4J4GPa132mU78AIQUlsz1f6J6Ny5XfMGO2BgTaJpOo+xhu4nh/XoBFdkc
         2qhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766587797; x=1767192597;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O8VCVFBIYVyB4enyF1PmIUKAF90SGYaRlZJ5H717CXs=;
        b=FBGEal553qb9AQGByCk4/7F7E0jKMoWRRxhQ/H6IFz8i8U//JAjdFfvXC16CqvMCKP
         CDfzsf01kv+eb122uEZ2cTeZy0jtaxl4VkwWE4oxGkPDZmvh5nYR1du/FGM1SWQanlVB
         aDTmIeE35MiwsfFv/dIGoNUuD6OpXnK3okL1o3z1wSDPY2NZ7c7yzehk9afppz5w6Qdo
         aDAQDbmnJ+rGLrMj7kZgNQUIY5pTMSNh4PiwE47FuhkDISEBlWExMYGoBFQJsTi3pLXw
         gsHAz3B4HyBW8VVOE0sddiZJAPDF4bvhnaUXNaqn1BnYUjK+uQe2K8lCSgc46RFC5jnk
         2U8g==
X-Forwarded-Encrypted: i=1; AJvYcCUHfxtSb0M2q5V+ejYwWFfRJIpzQBryBRZQNTaqLNGGON7rwOmJlEGnHxd68kAAxeTY0GGaPcWdIA==@kvack.org
X-Gm-Message-State: AOJu0YweGytWpNVuq2tRVoGI6+DcC2QMCPlSx+YuFAaCsHlvF7e4xDkc
	prYvS+uhcC0/FgWWBTQmw6K333DnYP2HRhxi5O37A8/3y1RoGq0hHiCU
X-Gm-Gg: AY/fxX7rFI8Wv92fvrS4jbD0BnTRjW19zKmgMUQUDkL37mGRSHe12fIX/AhZ90Qms5f
	LyYyrLlWkxfHdBmP3AGpv5SPfurvgt5wVYcQd4mqIsDPnsYKSqFXIKmBmkh04XQ0mxulMWE/Fyj
	K5J/zfrfYcSQbMctSrYVfZVJOX9BS2CeGiIOQZFP81zLgPKZP0fzURi8tjo2Dg7A+dU3mYa2Hmt
	n6SEEMRCAtJw2AZeArAMklRLoPdsOIAJIEgrJD1zM3UfpNw312NM1uWT6naus/XU/sB2lwikB4A
	d7eDSQCMoMgSOHuSIh4+n1oBRvoRPjehsPOstUbcYfKDlwUP623UN7Ic+W0EOqLH1gA9Jn4hY2x
	1+OpvrXVjom819LdvRc19D6NXWV3UVfz02MJqqFh9JDbxcmkLO/1N7ZV5ZMGw5hOjJibDpfJX7+
	DDIPzvyxRTug==
X-Google-Smtp-Source: AGHT+IGVc8N3Ekuv3krfR5/4WYWMgPbABgaSk2fDbV45ocu/J32SwqTT0hgr0gzfus0eQXGkutgjyA==
X-Received: by 2002:a05:6402:b8e:b0:640:aae4:b84e with SMTP id 4fb4d7f45d1cf-64b8e94a858mr12861516a12.13.1766587797121;
        Wed, 24 Dec 2025 06:49:57 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-64b9ef904bcsm16397894a12.22.2025.12.24.06.49.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 24 Dec 2025 06:49:56 -0800 (PST)
Date: Wed, 24 Dec 2025 14:49:54 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: Shivank Garg <shivankg@amd.com>, Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	David Hildenbrand <david@kernel.org>,
	Barry Song <baohua@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Wei Yang <richard.weiyang@gmail.com>
Subject: Re: [PATCH V2 2/5] mm/khugepaged: count small VMAs towards scan limit
Message-ID: <20251224144954.2bhei4bk27f462nb@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251224111351.41042-4-shivankg@amd.com>
 <20251224111351.41042-8-shivankg@amd.com>
 <6b408736-978a-4d40-adfc-97819951c3a6@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b408736-978a-4d40-adfc-97819951c3a6@linux.dev>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: ngdbp641k7midujzi861adbxn7e4n8bg
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E0AB0100015
X-Rspam-User: 
X-HE-Tag: 1766587798-690227
X-HE-Meta: U2FsdGVkX19QPNA0MPizczJkNU1fJbPwYNaYDiMvyuZ4SV9pDoZ9nwZ7ITXshO+CXHqgPu/IQtW/umjKTunWXFIDpd0mjE/+qglzkBVT3aoSqVD2CWec5gqJ3NMC0DKOv4PTgCdpN3RdtAvT0CumrApzQZgYxgbSuVoFRCDekd/mq3NSwrcPnPdysXlBBhRH19QwUq4afCNmYSFE7O3dObRVGNKd1ygoQDykFathPbsddA/YcALwk2DN+AXHjYkChLcaGs/Xdf9kiUb7/uBfpQD0nA2iZxokaDWUl/7fR7XrWaMzgJQX+m3aB09ZAENJpJgnJlywehi37EucfEiSSxa3l/X79jA9OuKT/0RT8Ts6uBT5KSxTa9ydRzoGUFPbFWtQsk8/ne0RWjn//pThFmVMfsfCmII7jXDkWpzvkoHbjRrZniJHkWp5CKbhQp4NxWCHBG0XZQFXjeX7J2hidpQ2gAynRsJbaE3CUO9+gzFlBOJafdMbekXLYDkqeftAc3B5shRLfeWu55bDpMc+IHXVRvPpgpUnsFqBIcVmEdAKl3Wo2xLqEf9NYrRUcyAsniSRAZ+0WsKgrrNkCGqdnmkQ+HDiRbBMFYpYfrk+207rfxQKQmW0urWxMuoQmVk5qaRvq6cmYle6yrKjH2LFCIiF1LysbsVZSI7P6F8L+uUtatong3j/HiLgumOZxd1sUPVNWmZZ93jhr3cAgZRsllKR9pZdvVCB+AHbS2xs/ZB1d+XkKM89SVY7ao9G+OjubSlqPvtxciYS7iPDPfJSJsX5xA6+EcduamW+HXyTtbXPxw254Dv3aefLkeRxUAQlugXabxpDXf7URJU3HUns2PHd0H1E4hDJVR+GFus/R77W+6xG2Emh1jWKKC8g6c3HtxCFtGhz6/3A0wSu/nVuh7vIn93H+njMwyUpQwERLSg7+hyfwoaDx7P7xPv8zzbwe612m7T78ziFfqUT29r
 D29OoIah
 1VlGF2CMusULkUDHTXdT9hmpnYT36WvupMZU0uVdaVSOYvDS0jvTxqN4GCx4y7+A29CV9FC1Kx4ow1/1rxwVNAgJHwUKFQ8XY9UqVmFDHLa4t42w6jdDITSKLqArVz8PYs2tRtYfgRlF3RBwrImIc7XqMVs0jXHzh522XrdMn82IzTKAJutdQh1VjmKLnGGXN+QZ2qwl1/gWMzLu5SwX/nzP27OTOrYTOzHUSOd6Nv6l2Jd2VgTcTNbk8sbcrUkJTEUXYzRC0VvJByegY05SwQNLjqmlcrYv3/WvUa1yUziJbrMTjsFulv2GAHgvXJzJ0BMYqZn+oMvuo0E0GoHR1EuKJSpd9cCBzgYAPgwNDNF3eWO5IhzxNHwSLldsvOjEF8XREduv4lco5gQlcol0pWhLi7mXnpgNRYBfqWoJ9LSijAdIdL/88D9w8165t8NzjreA/hXVp+7uIBMYUCClM0iHFgM9Mfc1EgMFyqExKaJSY9JWPN27CyoQ+8g5wc1zdJi9Cb8HqMfVIufKeX0/K5fwPLrlnWaD/JSij8FdWpuyWbDS88rs+CgeLkS9IgGHymEuEEWN0QfWe/7/5nud5i62Bk8ETZB36XYq11IZBRnk1Aqlq5tnhaGjkgz06j5UM36NqpP5BYJwhj1+dGfAoG7wEC+O0yDNPwnLFVsn7MoVOVfT1+bnQQpSz0T46K18rrAPaer11sZ5b/wxaeHfSqq6GyQnjYnMIjia73ECdsy/ry4NuQNmn2oiAxshSddvb3aVB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 24, 2025 at 07:51:36PM +0800, Lance Yang wrote:
>
>
>On 2025/12/24 19:13, Shivank Garg wrote:
>> The khugepaged_scan_mm_slot() uses a 'progress' counter to limit the
>> amount of work performed and consists of three components:
>> 1. Transitioning to a new mm (+1).

Hmm... maybe not only a new mm, but also we start another scan from last mm.

Since default khugepaged_pages_to_scan is 8 PMD, it looks very possible.

>> 2. Skipping an unsuitable VMA (+1).
>> 3. Scanning a PMD-sized range (+HPAGE_PMD_NR).
>> 
>> Consider a 1MB VMA sitting between two 2MB alignment boundaries:
>> 
>>       vma1       vma2   vma3
>>      +----------+------+----------+
>>      |2M        |1M    |2M        |
>>      +----------+------+----------+
>>                 ^      ^
>>                 start  end
>>                 ^
>>            hstart,hend
>> 
>> In this case, for vma2:
>>    hstart = round_up(start, HPAGE_PMD_SIZE)  -> Next 2MB alignment
>>    hend   = round_down(end, HPAGE_PMD_SIZE) -> Prev 2MB alignment
>> 
>> Currently, since `hend <= hstart`, VMAs that are too small or unaligned
>> to contain a hugepage are skipped without incrementing 'progress'.
>> A process containing a large number of such small VMAs will unfairly
>> consume more CPU cycles before yielding compared to a process with
>> fewer, larger, or aligned VMAs.
>> 
>> Fix this by incrementing progress when the `hend <= hstart` condition
>> is met.
>> 
>> Additionally, change 'progress' type to `unsigned int` to match both
>> the 'pages' type and the function return value.
>> 
>> Suggested-by: Wei Yang <richard.weiyang@gmail.com>
>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>> ---
>>   mm/khugepaged.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>> 
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 107146f012b1..0b549c3250f9 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -2403,7 +2403,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>>   	struct mm_slot *slot;
>>   	struct mm_struct *mm;
>>   	struct vm_area_struct *vma;
>> -	int progress = 0;
>> +	unsigned int progress = 0;
>>   	VM_BUG_ON(!pages);
>>   	lockdep_assert_held(&khugepaged_mm_lock);
>> @@ -2447,7 +2447,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>>   		}
>>   		hstart = round_up(vma->vm_start, HPAGE_PMD_SIZE);
>>   		hend = round_down(vma->vm_end, HPAGE_PMD_SIZE);
>> -		if (khugepaged_scan.address > hend) {
>
>Maybe add a short comment explaining why we increment progress for small VMAs
>;)
>
>Something like this:
>
>		/* Count small VMAs that can't hold a hugepage towards scan limit */
>> +		if (khugepaged_scan.address > hend || hend <= hstart) {
>>   			progress++;
>>   			continue;
>>   		}
>
>Otherwise, looks good to me.
>
>Reviewed-by: Lance Yang <lance.yang@linux.dev>
>

The code change LGTM.

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

