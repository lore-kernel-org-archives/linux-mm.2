Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E11B5C9830C
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 05:48:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54A126B0089; Sun, 18 Jan 2026 00:48:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 501316B008A; Sun, 18 Jan 2026 00:48:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F6EA6B008C; Sun, 18 Jan 2026 00:48:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 317FF6B0089
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 00:48:28 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C328816048E
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 05:48:27 +0000 (UTC)
X-FDA: 84344004654.07.DB97F31
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 42A6A100003
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 05:48:26 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768715306; a=rsa-sha256;
	cv=none;
	b=bYyPG2Hfzqkr3YlfIoGxAFsJJ1oH5dRaA35hjExuEPwFfV7glPakpaGdz99z91nq+ReX7F
	TJI+rh8HWuHADDOxyE4EYoobgD0BLvijP/vyxywbuy3vM9tL3jYM29zAJZ37GBjWhNNI1k
	vC1vw65JDEeEQXdoc9gFMJpNxrk4n5o=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768715306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nN7mk/B18u5vi4ZbP3jpCZ2+drO4Ozs0PMf/ZFASc2M=;
	b=RrEXfQ2abqZ724Hjtme1YZ4E+CapWkocq0CjTz/9mZLkXSr3nNgyPryE/skPPXk72R0qW1
	gwZnJat13G3VaX6NWIjEj13/4O6/zrXgrNYN7827RMGhz13hTwtQn77cZ6go0W6w5iaSNn
	cJjmSFh2GaxCH/Jyd+cusoDof4WUtrY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A3D2F1650;
	Sat, 17 Jan 2026 21:48:18 -0800 (PST)
Received: from [10.164.10.251] (unknown [10.164.10.251])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 45E733F632;
	Sat, 17 Jan 2026 21:48:19 -0800 (PST)
Message-ID: <467ab4d7-1ce2-48d4-bff6-6579216569e2@arm.com>
Date: Sun, 18 Jan 2026 11:18:16 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 5/5] mm: rmap: support batched unmapping for file large
 folios
To: Barry Song <21cnbao@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 david@kernel.org, catalin.marinas@arm.com, will@kernel.org,
 lorenzo.stoakes@oracle.com, ryan.roberts@arm.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
 willy@infradead.org, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1766631066.git.baolin.wang@linux.alibaba.com>
 <142919ac14d3cf70cba370808d85debe089df7b4.1766631066.git.baolin.wang@linux.alibaba.com>
 <20260106132203.kdxfvootlkxzex2l@master>
 <CAGsJ_4yKRtyADU2ZxUMgvqdrhAEL4SpZxCMRt28gNJfUf--5zQ@mail.gmail.com>
 <20260107014601.dxvq6b7ljgxwg7iu@master>
 <db4d0a19-598b-48ff-accc-f5940a481035@arm.com>
 <CAGsJ_4zAxhSDqvN5tzSeHR-kifaxm_GbPhHCeSkYsRJk=uHN-Q@mail.gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <CAGsJ_4zAxhSDqvN5tzSeHR-kifaxm_GbPhHCeSkYsRJk=uHN-Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 42A6A100003
X-Stat-Signature: 3cib8gybhra5yui98hyp8gp8k9gxjmiy
X-Rspam-User: 
X-HE-Tag: 1768715306-958065
X-HE-Meta: U2FsdGVkX18S8NbsWhX6Jv4xkxuoxgY87yvc/b8Hl5h+oXklP8sRV66hzApauTtpREdbOcYf7tVSSRim5K2a01y2CNvyyyfVXEy1dQnXhVb+jahHhSLP390zWyF/Hty/DeLdpbCREtOd9pUcMzTX7ldLGmvFPkRWbtsaPPpvZjmwRNqtV6ysYe4l0rFJ+5JZo0y+us+Wa09Y7wi6wiKJvlm7Caxhe8LxpaK9wDwhPZ3MYWFKeITpUVu54x3fZWBWfw0pD12MS5f//6oMVYR91AGXrjHAIlzm6XqeIu76La/Uq19sQKlkmAnehXthQ5ceod6E/Cr8Ibljo4bf9Zr81Q3dtrr8+fraJNfzb0ZuM7Qz2ioGcKf0JS5pxmp9Jmvc9iSVRbZcqxFct0ARwMb2hLkCXCYD+gCreVCBD1mW7WI9/uiZ9IA+8jYd0kKvhugyZDBfx4kO/OI33rle897qYU8HrDL9f+5acyD7wmk2RbN693wGInqa9Q6dfxFMtVoxUaIlHVRGOqTxZPdAQFqo51a7aKyWl9QZPg/F13rgawxVAxLCwSFxm+eCWuIra7zbeG5uqyVWBRgLf6tOStieqRpfepTAuqJKd9pPhkKu9NmXlfI1gdcagVEszWyZXRA+ac0E9VOqt1voFjrxjAQLc19PnwQFpvrHYh+nsEuswKHorkaBYQai865J/OInMKTNOH31eCGBibuXa1ggTlE4NgAEwnhI5OEljTmu1e5LJdJLYcFD2l0JCTLNkllqU0apAsCIUH4SxFk6i/tnI2fY0pAb1z/FS9urCgGlLhOuL2LazV5k72ir3QSVYtDNpxPx/9LVwyt05vgunABJW14fHu+NfqssC7KuB14uksesDADUTOsiD2l0VZKGdudQUndp1CXezZI7cGIYYleeWwwR65UEAh/BV7tR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 16/01/26 8:44 pm, Barry Song wrote:
>>> I mean maybe we can skip it in try_to_unmap_one(), for example:
>>>
>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>> index 9e5bd4834481..ea1afec7c802 100644
>>> --- a/mm/rmap.c
>>> +++ b/mm/rmap.c
>>> @@ -2250,6 +2250,10 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>>                */
>>>               if (nr_pages == folio_nr_pages(folio))
>>>                       goto walk_done;
>>> +             else {
>>> +                     pvmw.address += PAGE_SIZE * (nr_pages - 1);
>>> +                     pvmw.pte += nr_pages - 1;
>>> +             }
>>>               continue;
>>>  walk_abort:
>>>               ret = false;
>> I am of the opinion that we should do something like this. In the internal pvmw code,
>> we keep skipping ptes till the ptes are none. With my proposed uffd-fix [1], if the old
>> ptes were uffd-wp armed, pte_install_uffd_wp_if_needed will convert all ptes from none
>> to not none, and we will lose the batching effect. I also plan to extend support to
>> anonymous folios (therefore generalizing for all types of memory) which will set a
> I posted an RFC on anon folios quite some time ago [1].
> It’s great to hear that you’re interested in taking this over.
>
> [1] https://lore.kernel.org/all/20250513084620.58231-1-21cnbao@gmail.com/

Great! Now I have a reference to look at :)

>
>> batch of ptes as swap, and the internal pvmw code won't be able to skip through the
>> batch.
> Interesting — I didn’t catch this issue in the RFC earlier. Back then,
> we only supported nr == 1 and nr == folio_nr_pages(folio). When
> nr == nr_pages, page_vma_mapped_walk() would break entirely. With
> Lance’s commit ddd05742b45b08, arbitrary nr in [1, nr_pages] is now
> supported, which means we have to handle all the complexity. :-)
>
> Thanks
> Barry

