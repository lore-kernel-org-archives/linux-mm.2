Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1176C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 10:55:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0109D6B008C; Thu, 10 Sep 2026 06:55:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2A3C6B0096; Thu, 10 Sep 2026 06:55:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E18B26B0098; Thu, 10 Sep 2026 06:55:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B94A46B008C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:55:20 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 164DF140498
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:55:20 +0000 (UTC)
X-FDA: 85197546000.18.9F923AC
Received: from mail-pj2-f8.google.com (mail-pj2-f8.google.com [74.125.227.136])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2E31A40007
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:55:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bSc1eTU1;
	spf=pass (imf27.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.136 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789037718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I/lsWiPytaCYG5VQwzNu/fNcbbKarnBsAuYB2BQ7P9w=;
	b=EcRQ+QzjJeu3Zix1GWRB83WmnzlDACC1y0tp8ph/Ktg+62o6bmy5HeDX0kr8tVUu5ISO5O
	Ipa/Iv+GUgLkSN+nkQp28NFYIIN1Wb4wqWgLkQ0+JYu3cAZkGB+76rz0nPmLV4nZLnwdGI
	qAF6N72IjLvG+qvfGUJvweWy0efcb+Y=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bSc1eTU1;
	spf=pass (imf27.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.136 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789037718;
	b=PEN38UpiF/9Ad1wDVyu7pb8ARor+9npfHoGmCfl3c7zz2NfJ9q2+p4Wz5O+5C1s2e0P+Vw
	GNsmQtI4QAsO7IOwYBrIbdeyqEoMY1xlxp0zrHn8W9L4ttJ47MRD7vNfT8tN7wMXpd2ICX
	wjNGBYrmlLZwTg11O7ZObv2apfs8Wik=
Received: by mail-pj2-f8.google.com with SMTP id 98e67ed59e1d1-398b9f722abso2264142a91.0
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 03:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789037717; x=1789642517; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=I/lsWiPytaCYG5VQwzNu/fNcbbKarnBsAuYB2BQ7P9w=;
        b=bSc1eTU1xF7m354KF/n4o0iO3GSE17TfSVCRriL9pCOd/O3v9OxCDrVoih9jLZ08mc
         obvwlpb11xTxe/ufbMYhwIlGMTirFJErCJtYcGoSCeuAivDtF0l9Uhmhg0Q3sUWnFqwa
         zNSTxYhNFfaXMiiZdJaAsApMt9DHwAKdRHzMsurQQMqc3IZLEw+FHN24KKvnxoI6QlVi
         2aPqaxBlr1WWdvUDv6+41QcyBQ6HXFb5sYTPBu1A/TJDftJBa3EfrBDP5X5TCNkTvVaj
         0SY2HsixLCyKldClhoAOIaMg6Y2+wLUXvo0KrYg6+61VwEOvoPBiekXGrc9Ng4YN218i
         kruQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789037717; x=1789642517;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=I/lsWiPytaCYG5VQwzNu/fNcbbKarnBsAuYB2BQ7P9w=;
        b=bHKJWMZkEIsQvB9ngI1BZwQ8RThB2t4MEa1I6CujLlCSzo/RG04EixtQPoRz4kI9p1
         Y8rvcsP+EjH0ckgfs+CxnDyU8EUutO7njemoCOB6Q6qWESdRCaV2IOJciI6ybBfzfuND
         qr+RG7fwO2V/hhn9o9j9mCn9R6wQfwrsBnVf4tzCqI6lPNh3m5zxG9K2htkx8BH8sX5v
         Pavvyl/3YWZrxrfw/TjV7ZY9gEISJDHJ3WT9Qf9pi7QgzpX7RZCpuEbc/AGiwJ9htudI
         N7KdH9grcI1rJuR7cUX+kAxaCwTUumF2OCb8woA6VP/t01NNfhZXoGlOIshYa0eI3Is5
         RA4g==
X-Forwarded-Encrypted: i=1; AKwUvByKB/hBAMQFFP9SYoQQj3VWl9anixvYXkQhXucSKrmNoKDr4lh0ggzTiQeoaxq/CRtyYMec5wY9wg==@kvack.org
X-Gm-Message-State: AFuF++lhV+TfvwMQqqXPllFJwdjm+85D0h461dTm+NaCxxX0tf3Lf9G+
	T5F+Z/fiCWd2hATyVR3kc3UZ5pDRTS30Jy1hpUnGFnDRkSpx5UocrUTd
X-Gm-Gg: AYBFou2mBu//TMfU2dXYV8qWZgRjRJfqoIvWS+3RY400NibeOE9AIUIkd+NISWITksx
	8+qrF92RK3kWGChgsFgfAeeQxEQQY3x7O+fl9PznwsRQstNLRFiche/eOKWwoaC7OiKRpy6X+NJ
	qD7pVfrzgzkqG233ldI0SIVRTEOA4sI8Hq4sydYhWX1qUrqEDruAcfRVandlQh6wUgg2XMDGxGO
	seFXI8YUDAdqB3CV3/66uQ6J5i/OrL1q+gSA4lLtoUMIF4eIzHOKJs7LlUPNdcO3adyFmYvHxqt
	/sysuzlN+uqZCaKLQT01aguRJmoyx2IYdjksxZa/XUZJX+5YQUgNGIr1abBz0Qam+rg8VcdvQwJ
	vlffjAy/uz1gdY5D7T0wsZ1NBI9mc1/UYoZ2oPQiMJXiQNxAuQX0Plbc2HGdAyrvzzSh8OytE6H
	vrOonhr9/Zp3Mh3J8xji1cuV+335HEM2vf0H3kNhRz2vDZ0fGCaLFIw6T+zhiXZ7xgM331IS46v
	Ie4Fal/LiuSY3+t1w==
X-Received: by 2002:a17:90b:4c44:b0:38e:97f0:aa4b with SMTP id 98e67ed59e1d1-39b261cdb38mr58067406a91.13.1789037715868;
        Thu, 10 Sep 2026 03:55:15 -0700 (PDT)
Received: from [10.125.112.20] ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d7e77611asm3990224a91.6.2026.09.10.03.55.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2026 03:55:15 -0700 (PDT)
Message-ID: <7dd9e1c3-ddc8-482e-a560-e8dc4f2f0aac@gmail.com>
Date: Thu, 10 Sep 2026 18:55:08 +0800
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
Content-Language: en-US
From: Wandun <chenwandun1@gmail.com>
In-Reply-To: <7a964778-adc3-4186-9122-3858bb61c372@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: r49e3dnhboafoxtp86itom5bfh39kde9
X-Rspamd-Queue-Id: 2E31A40007
X-Rspamd-Server: rspam07
X-HE-Tag: 1789037718-255973
X-HE-Meta: U2FsdGVkX18E2IHIx5jWe29z0TmkcDrP8Wh/zLebLs9kIWaywaEURsO49UHmHwSgBUSjuFLqClSARGxtsjdhZ3ewx+DLf+Qt5nTcjugUL77mv7V8psZTB9VnFKmN7QW/pXReLT+aGZEC9QJTX5QLNVnkcEsAtneSHadGczEzC8CAUBOz4llT0ybpWsNanhZ81OgVzSqoDVKdNPjyiuhvOfXo5MExxEd49AIe5QMEMBlrV1mS5csJ7qFZ0eHA8EfeFdj2V+8G8ancjTOu8puViaRUtcf1KGDnKYB7TvzjNr6Nuhyxj7f/jDHsQyNwWmcBa7hKl0OK8K1rzz2H4fpYxTz17VcwvuT958D0hnDL/0EBxw56G+ef/mbjNK3ykUDtvXZ7zaBxoqBxeELEBKk3rGmKuHiGiwQehpbKw0CR+Dbhbzz3/wXrDywbGWWWqo0At+x7lJKnUah1c0JJg1J1P+BDe0qi+z+2IgC1/aO2P+7+c4U5D9uG7bDtQSlN2A9ITSU/sHTPTZMiafVWoDq2zgYmcuVacDfdUey17/xEpC7/iCVjFaX4T63WXzWu2MTAJpMSGRIfwB05uPJ7OzZfBYbvkNVJ3TO9crGC5X0xKVc0nhH0XMZNQZ9Qqzzs9G3kZoKFAugguybslMlzskhu3TJgBGR7NLsGlSurLso7hQqy5l6Ob+Jl82FoD2SKv1dIES3sHKE0WxknGyLnDya1Rjg6J3lTrvGahqMFFYK7xyUfX5Srg5vGl7HMvvHcISfPYev8x0Heeww4MOVum2wbExmO67qplLfSOE9yDBOvXDdmEkOU2HmoNJQKYSSmnitpMlgR+JzRmcb0/v4rKyfoS9XgErYX9cSYWHKNFCk8+2eu3t3JsC/7cExVxcH1lodkvksmHoFTehSY5VoxwjJJeUv4bR7AvLx5GnnlcFN/n6Bt31F6MeN2gTUmTdsPaKXdJN1OpowtpIwmoxSgviv
 66qtukta
 WXi38QSTJ5C2iv81GsDNxPJxwkIayn4Q7EYbTSovi8tCgWMbqxJPNlviSDwFnBbOrKnL42FsG2AdOH4Pm0XmipwpvHhDYssdr2ZzELzXLceSzXlum5Y7o9gN0O8nkvd35k7pn7x/ehWsqm67FoH9uqLc6EfMoFEgSS46uhhXIsya1ChSdmxq7pQN7bhtACanuS7Ha6B749/o5RB5mpFt5BFjPTIQX9mHILiv0lkl4YnQyfa07I3qeTBAFMY8LPytd5Zzg4smFCOzHY2+3pUYLCpUschFVyF0ugICsEQ+6WcKhZ0rTvX28cpjF2/SrW3C4qWA9orv/hTJ5k7FKqpXJWqv3c4yKP/ZqVAgSFpB9/eghWhHgeHGT2AF+GHGMJiZqAsBHmXvsy/qQLDi4sK1/cT7lgwltbB47U+AadRRI2BBGRLEv52OQuTdddtMTfnvEMNJWkN6qzEvHqR6Kwrl/5RjM9+1v+iFaKTGCaQjGeVWkwL73EsdJzmHWdESmpKSRUQYhClXYLo2HQLtoWl6FF8YVhERbtt4FiWg6AyJ02XsStDdGBmxdDl+uRbTdDaLrZxwQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/4/26 16:49, Marek Szyprowski wrote:
> On 31.08.2026 15:04, Wandun wrote:
>> On 8/26/26 21:14, Marek Szyprowski wrote:
>>> On 18.08.2026 11:24, Wandun Chen wrote:
>>>> From: Wandun Chen <chenwandun@lixiang.com>
>>>>
>>>> __reserved_mem_reserve_reg() discards the error from
>>>> early_init_dt_reserve_memory() and returns 0 unconditionally, so the
>>>> caller counts the node in total_reserved_mem_cnt and the late scan
>>>> initializes it without checking whether the early reservation actually
>>>> succeeded. A region whose reservation failed is then handed to a
>>>> device assuming the memory is protected.
>>>>
>>>> Propagate the error so failed reservations are no longer counted, and
>>>> record the failed nodes so fdt_scan_reserved_mem_late() can skip them.
>>>>
>>>> Recording the failed nodes explicitly is necessary because
>>>> fdt_scan_reserved_mem_late() rescans the DT independently. It cannot
>>>> tell from memblock whether early reservation succeeded.
>>>>
>>>> The failed-node array is bounded by MAX_RESERVED_REGIONS, the number
>>>> of static regions is not bounded by it, so on overflow the extra nodes
>>>> fall back to being initialized, which is the current behavior.
>>> I'm not very keen on such partial solution. Indeed we have no place to
>>>
>>> store the result of the early init call, but we can check if the given
>>>
>>> region has been earlier marked in memblock as reserved or no-map in
>>>
>>> fdt_scan_reserved_mem_late(). If those attributes don't match the
>>>
>>> region can be simply skipped then.
>> Considering the later patches that reject reservations for overlapping
>> nodes, checking the memblock state in fdt_scan_reserved_mem_late() may
>> produce false positives.
>>
>> For example, if region A is reserved first and region B is a subset of
>> A, reserving B will fail because it overlaps with A (in patch 02/03).
>> However, during fdt_scan_reserved_mem_late(), B will still appear to
>> be reserved because its range is already covered by A. As a result,
>> B would be initialized even though its own reservation failed, which
>> is contrary to the intended behavior.
> Imho the overlapping reserved regions are some kind of configuration 
> mismatch and it is enough to detect them. fdt_scan_reserved_mem_late()
> can first store all regions to dynamic reserved_mem array, then check
> for overlaps, and only then initialize those, which don't overlap and
> have proper memblock attributes?

Thanks a lot for reviewing this series.

I did try this approach, and it looks clean. The overlap check works
well for regions within /reserved-memory. But there's one case I
couldn't make it handle, where it seems to still produce a false
positive, please correct me if I'm missing something.

For example, region A is reserved before /reserved-memory nodes are
processed. A is not a /reserved-memory node, so it never appears in
the reserved_mem array. Now region B in /reserved-memory is a subset
of A. At early reservation, patch 02/03 rejects B due to the overlap.
But at the late scan, B's range already appears reserved (covered by A),
so it looks like a successful reservation and gets initialized.

The root issue is that the late scan can only tell whether a region is
reserved, but it can't tell whether the reservation was made by
/reserved-memory node itself or by something else. Maybe we still need
to record during the early reservation stage.


Best regards,
Wandun

> 
> Best regards


