Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60EE3C88E42
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 06:37:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D96C6B0092; Fri, 11 Sep 2026 02:37:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B0DF6B0093; Fri, 11 Sep 2026 02:37:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CACB6B0095; Fri, 11 Sep 2026 02:37:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1C9596B0092
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 02:37:48 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DD97BC0715
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 06:37:46 +0000 (UTC)
X-FDA: 85200525732.12.D415F29
Received: from mail-pj2-f8.google.com (mail-pj2-f8.google.com [74.125.227.136])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0C23F20002
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 06:37:44 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fBLoZvPR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.136 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789108665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vFqFJVoBVN5kZfJxUCTmdBnEcYhE5q7ZSLbJrzghpqw=;
	b=Omr6ezCQ1niVUBPVDoq5qlBdZfqYoz4wTFq6JLQQZT7UBSULUoNRGP8zcWGUsfSt3cHU65
	S5lWRbGq/Hb7cVtUR7C6waUDl81wm8OqXn+ciT5mqhdDq3TPE3fEOHRcYpFgYbSVNvueSU
	Bg9YEADshqLr2vMS90riXDk0nEPvFMw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789108665;
	b=EXxlXzjSdOmDCubgxmfR1yRoQ90F/gDfbglar+dieUkdI0p7/7is3mTiHdZzPyiC4jm5C/
	pInwM8kBQ97kD1oBBiCEZ1bU3aFxplb5d8Dh3ucX5oUbpirPFU1emZ/JXe+G8lb1UXUyLC
	b8zL9xB+6wIv/TvKX6rs6g7WF7dxmsM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fBLoZvPR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.136 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
Received: by mail-pj2-f8.google.com with SMTP id 98e67ed59e1d1-39b456fc4cbso316706a91.1
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789108664; x=1789713464; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vFqFJVoBVN5kZfJxUCTmdBnEcYhE5q7ZSLbJrzghpqw=;
        b=fBLoZvPRbncCJM99+1Rh8rkgYbOaAKO0s9h0kxu3Yuwg/bxmzVOCYswU1TEXZ6E/87
         B//DCUfZLYBW2QuqxHHaUWX/RX0qq7t2rYsc6BT7K3CVnshZFBQ5rXSelghDY16jc6D1
         KTzLPZua8pD17gPH2d5suZA7tNARI56K2NUjVmlrtOIwHt6asrIRkTaQw/sMDHyN+FUT
         9G+J0MnH1GmK1AXu8z5nyDxKQwGZITsvVu/ayKEpbMLttlRrq4p9gdhVvg6Pn/ejddGS
         soSEfkwUSO7dO2WjbN6aBD7l5MpBM03La7jBHFyxWVbRpkk0Z5vMBCXMFPxK9kccAw78
         epeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789108664; x=1789713464;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vFqFJVoBVN5kZfJxUCTmdBnEcYhE5q7ZSLbJrzghpqw=;
        b=OhzYF+D/mkWEjSdmth9S5Q6Sq5/sXJMCc5BoH3xmFiElL/1YVb44lCh2t0U1Yev43c
         H+g+zi7F6MzNcwa+iwOxM8Fq68TXIM8WPpojDqzriCa045kvV+qkEA909ssxXEw6b5L7
         fDn+mj2rFSjqBHv5e/dH8YBJxtlJh+gfN3RbUysVG3phULRuSCWCUj8jtYlHnaSw6E2D
         DJW6sVmpMYfhf7MI9XAtSjWNPEbc+9l49CyK8ksQKA0hU64j9hKCY5aDPLKTgSj10WOy
         V2uhhFmZZb40Zgu1D5WjQ3EcREBwkXwWM3Ue30AAhArDLs9YjS9V+9KbJXKg7oWG9AvA
         MGTw==
X-Forwarded-Encrypted: i=1; AKwUvBypqhElZ+7RQkdis1bropWup5SY3dbLebGGnzyu1ClAmMBv2hSCw7Kpi2NkmoIM7krr+sq+6mCUPw==@kvack.org
X-Gm-Message-State: AFuF++kZ40fInm1Nyg1sjWbe1XcwZpxEWSKWgMezPCKoyi7YX7hPOOuu
	137w9qmXqmV3uZtsA41Q+4G2IRRNQsbp2r1/p2IjCwXyoBXquxDx1N26
X-Gm-Gg: AYBFou0DBtQ9ifO+rENzAFf+JzQUur1xahwrl8GCchKW9+UhIaL4ZDZ46AYHjez8ZSl
	89cTT33zdj/rwzcHgt8VqOY4+AzQqaitPIl79lrrSapI+5w5+aH+nQ3elU5H0efjL77MCNm4s5b
	5lzYZCznWZAHU/evNJBRzL2quQGTNzoglAsFbzWOzCeJazzOisdwVVR7e98UEWb6pTQH/SbTY3i
	2cu50nozjz5D4nJ/kM7PNTmQtyO7sL6sUy1ECPLQxNvFi4H697hQocTNxX2uFORLqK4S+Z7YY99
	YSCyM59uAwVbxrfOlXsONjPGPy1yd+bF0PDAKT+HIhdawqZzSwPE0OifuHdRqhD2iTgnth9/aj1
	xtWvCKzvU7pZUamvah9Y/BgpSDF4Uqpt41Tf9iVJ5Tpu7UpAxanTnd84MaBoEkFeWuYDoSGxVIn
	6qFBbcYdsnE+wYX39ht//YPZ2KDVHZtcykcR05VEkRIF+tI+glyNrLzRsusFTSgmRAWF5wJvTv4
	nrkrw==
X-Received: by 2002:a17:90b:548f:b0:392:b509:b1a5 with SMTP id 98e67ed59e1d1-39d9c1db3d4mr4983638a91.14.1789108663538;
        Thu, 10 Sep 2026 23:37:43 -0700 (PDT)
Received: from [10.125.112.20] ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39da6016718sm783381a91.15.2026.09.10.23.37.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2026 23:37:42 -0700 (PDT)
Message-ID: <cbbe6ba0-5ee2-4597-92b8-3257e152be75@gmail.com>
Date: Fri, 11 Sep 2026 14:37:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] of: reserved_mem: skip init for regions whose
 early reservation failed
To: Marek Szyprowski <m.szyprowski@samsung.com>, robh@kernel.org,
 saravanak@kernel.org, rppt@kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: akpm@linux-foundation.org
References: <20260818092420.2859026-1-chenwandun1@gmail.com>
 <CGME20260818092438eucas1p20115e5d33908e32ef4433cb246da8098@eucas1p2.samsung.com>
 <20260818092420.2859026-2-chenwandun1@gmail.com>
 <72074a49-2963-4f96-b939-79bf95a829cb@samsung.com>
 <af87036b-0809-4880-b088-545780b4d963@gmail.com>
 <7a964778-adc3-4186-9122-3858bb61c372@samsung.com>
 <7dd9e1c3-ddc8-482e-a560-e8dc4f2f0aac@gmail.com>
 <518729f2-db28-4af5-8ed3-9985c124db3e@samsung.com>
Content-Language: en-US
From: Wandun <chenwandun1@gmail.com>
In-Reply-To: <518729f2-db28-4af5-8ed3-9985c124db3e@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0C23F20002
X-Stat-Signature: 8owkicuddmisfzijnkf7yzjgcymtkogx
X-HE-Tag: 1789108664-974149
X-HE-Meta: U2FsdGVkX19K6FVHrXsbAPSxktrK8PuJV8bcsi6HkVLt7rkHxLDahMuRCKAPfFqEnkpS1YANf/QMc1vfbSfPoYIXpbVKPxpk6xuNw4XcAMgAsenEV56b2H4IF0UpF4bbavjGxGBww+hBBBEnBSvOnyPnYvwfv3miR85Rd+6jdmQ8MeK+B/TShcsgbqBKX/d7pmrct6AztVknbmy4JbS4Xr1zYLXPQqqiQp0iT4EOBh+eM8pOOTb2iFyBMdPOPGj2a88JObSd63DjVhvhNqf/epnfJ62XvsZgu+vbvVsR5zYlVsxY1WyOoHvG+RB83aZOr9TAgHGH0SSn0NGcrmfQ3Z0RaaB1QamQTDAF09g+HMw1NQgDkulz7jR4YvfnU3mXLjmE+AJYefRGU4XiDheqDmbbc4tKwiaQJGzR32rnVoz8AExm6CGbajz66CIhFIRiiQMf6w3U3QciqLGa23WefdrwVbY4W341Byu58JZyzQCUz+JGFJoD1bQhXvNC8tUvbY/jxL43qKhrb0jK5TKtDPKW49DLLenz6xX1Mr8nEISvq0cdMzqNar5IrJsgYXK++cjpjlSr1XfChRp92+Yt2f7/wIpL03nY/F/c6HrIgOmCugtRNjdatC6NnjgfYRdgAde3yRjn1kC9ibODO19EllRTTtBCbacrcC47DqHdbtCazR+cS857SRMl142jz4Q0lG2hCcGDiFcwSyQWgrnFrhKGfCd9J+dwbQmBcKroMfbk2c+g3ZvPpw4KSoIS1CvE2jrZcUcE9dpnsNBWfciohv0VUip67UgKCUSnlS7jCvKgOOGSUGhmmaRhTOHWKTVuurptapdIRl5F0CnRqKaDq6z2QqgZ20oppSwb+9mg7zAmtzsgj8HMV4Ll8fIKmHRsfRQ135WcxHahLpYMPb0eQ72nsDd/zvLEwMYkZ8zkv+YnR/f/rEd4uxfUX2J1hlWciQRW/XybvpvdcPqhtk3
 pAkV2/Hd
 gawi7Z3shzUn/qOXercRiyRBSVySuTYGip7TesrmtSwYBfZL7YjedS05gxkz1XRCk+2n/lO1fFIoxiLbyAbXHUqZB5sUOsfgsMFRiV6V7/EzPNJTt+EL8vbgSPxQh6cR1dyq/6gAM0eou9Rkl6wvIsloTnocanTTmJ1A6zD7wT/hd73gOfXPRnFol0KMCJIZW9Mb1QMTBykl6bkUscd8srMFeaNU7fdZF8NjjZcCaGLRd++CaLWs/vi150ZTXXuMi2yPIAuMV2KgWpRlEJaPRt3xs3vb2976io8433I9ghw5yj2c7+vgYfFg6nIcFNAt+m5aSFDIyjq0b/eCvIonIju7USrJJ29b3JNkZShX2XtxGFHjNiqeH/GCUAMj1Vi9iuIHphw9uh5QWIXNl0IK/Z3188gYjmcUVYy1BQKw1p4D2dy+NRr4kwz1Eay2CvbIg2cw8veV8ijm6kbdZrvNVspW3Ifv0zZbAsLMlrvqRyGgkbL/zfPm3iE/qY5g/QedMpxvWViepXQluWE7guX8bS9pwcCFX8T3I6//27bO3Rqu/8gk+8/MseEB5jpAXqpQvvsWH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/10/26 23:20, Marek Szyprowski wrote:
> On 10.09.2026 12:55, Wandun wrote:
>> On 9/4/26 16:49, Marek Szyprowski wrote:
>>> On 31.08.2026 15:04, Wandun wrote:
>>>> On 8/26/26 21:14, Marek Szyprowski wrote:
>>>>> On 18.08.2026 11:24, Wandun Chen wrote:
>>>>>> From: Wandun Chen <chenwandun@lixiang.com>
>>>>>>
>>>>>> __reserved_mem_reserve_reg() discards the error from
>>>>>> early_init_dt_reserve_memory() and returns 0 unconditionally, so the
>>>>>> caller counts the node in total_reserved_mem_cnt and the late scan
>>>>>> initializes it without checking whether the early reservation actually
>>>>>> succeeded. A region whose reservation failed is then handed to a
>>>>>> device assuming the memory is protected.
>>>>>>
>>>>>> Propagate the error so failed reservations are no longer counted, and
>>>>>> record the failed nodes so fdt_scan_reserved_mem_late() can skip them.
>>>>>>
>>>>>> Recording the failed nodes explicitly is necessary because
>>>>>> fdt_scan_reserved_mem_late() rescans the DT independently. It cannot
>>>>>> tell from memblock whether early reservation succeeded.
>>>>>>
>>>>>> The failed-node array is bounded by MAX_RESERVED_REGIONS, the number
>>>>>> of static regions is not bounded by it, so on overflow the extra nodes
>>>>>> fall back to being initialized, which is the current behavior.
>>>>> I'm not very keen on such partial solution. Indeed we have no place to
>>>>>
>>>>> store the result of the early init call, but we can check if the given
>>>>>
>>>>> region has been earlier marked in memblock as reserved or no-map in
>>>>>
>>>>> fdt_scan_reserved_mem_late(). If those attributes don't match the
>>>>>
>>>>> region can be simply skipped then.
>>>> Considering the later patches that reject reservations for overlapping
>>>> nodes, checking the memblock state in fdt_scan_reserved_mem_late() may
>>>> produce false positives.
>>>>
>>>> For example, if region A is reserved first and region B is a subset of
>>>> A, reserving B will fail because it overlaps with A (in patch 02/03).
>>>> However, during fdt_scan_reserved_mem_late(), B will still appear to
>>>> be reserved because its range is already covered by A. As a result,
>>>> B would be initialized even though its own reservation failed, which
>>>> is contrary to the intended behavior.
>>> Imho the overlapping reserved regions are some kind of configuration 
>>> mismatch and it is enough to detect them. fdt_scan_reserved_mem_late()
>>> can first store all regions to dynamic reserved_mem array, then check
>>> for overlaps, and only then initialize those, which don't overlap and
>>> have proper memblock attributes?
>> Thanks a lot for reviewing this series.
>>
>> I did try this approach, and it looks clean. The overlap check works
>> well for regions within /reserved-memory. But there's one case I
>> couldn't make it handle, where it seems to still produce a false
>> positive, please correct me if I'm missing something.
>>
>> For example, region A is reserved before /reserved-memory nodes are
>> processed. A is not a /reserved-memory node, so it never appears in
>> the reserved_mem array. Now region B in /reserved-memory is a subset
>> of A. At early reservation, patch 02/03 rejects B due to the overlap.
>> But at the late scan, B's range already appears reserved (covered by A),
>> so it looks like a successful reservation and gets initialized.
>>
>> The root issue is that the late scan can only tell whether a region is
>> reserved, but it can't tell whether the reservation was made by
>> /reserved-memory node itself or by something else. Maybe we still need
>> to record during the early reservation stage.
> Then maybe it will be easier and cleaner just to add a new flag to 
> memblock_flags (see include/linux/memblock.h) and mark each successfully
> reserved region with it? There are some spare bits there.

I really like this idea, it's cleaner and directly solves the
"late scan can't tell who reserved the region" problem. Combining your
two suggestions gives a clean and simple approach, and I'll implement it
in v3.

One concern: a reserved region carrying the new flag won't merge with a
reserved region wihtout it, so memblock.memory and memblock.reserved may
end up with more regions than today. When fdt_scan_reserved_mem() runs,
memblock is not allowed to resize, so if regions in memblock.reserved or
memblock.memory are exhausted, panic will occur.
The default regions number of memblock.memory/memblock.reserved is
INIT_MEMBLOCK_RESERVED_REGIONS, it can be raised if a platform actually
hits it, so I don't think this blocks the approach, what's your view?

Best regards,
Wandun
> 
> Best regards


