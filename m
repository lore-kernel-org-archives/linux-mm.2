Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13A2DF531E5
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 02:12:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B56326B0088; Mon, 13 Apr 2026 22:12:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2D0F6B008A; Mon, 13 Apr 2026 22:12:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6AB06B0092; Mon, 13 Apr 2026 22:12:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 98BAC6B0088
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 22:12:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C0C468B5CA
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 02:12:25 +0000 (UTC)
X-FDA: 84655537050.24.C78A8A8
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf03.hostedemail.com (Postfix) with ESMTP id B7C8620005
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 02:12:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=D28Suhfh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776132743;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RnjfpD+5B59teRstSFpwFq28zSHyCsooHf0UM8fMsW4=;
	b=Z7dr3J7chUNKegTNa82E+yUrgHf4THJy+7w46vRrJwuWx0bDpXQ93DuNq8qD0Gc/BylM4n
	2Rvetc64uIBOpz/sFelTk9Ac/hUjymT6Z8w6mTy8dCTD2CC4x2COHMVc9qJH5nEGTJShqw
	qZV7jEe6rZc/ie/Gl6RgWW2HWJYQ+Bw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776132743; a=rsa-sha256;
	cv=none;
	b=knjvZM69yv73SXq0ODH+ez7w7rlM8rsLmRvXbRnnQ6rXWrGL4+JjUY4HwEKUUNlH/phxDP
	UjrnReHxiQaKEUegq+OVWBH9KjplNUmqWg+X19sfADHNGR0iT0foU+dUvHNXWbCdrJABC2
	oiE67tVaP0e8snK61xgkLXhUrXcQ/l0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=D28Suhfh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b9d6c8871c7so736739866b.1
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776132742; x=1776737542; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RnjfpD+5B59teRstSFpwFq28zSHyCsooHf0UM8fMsW4=;
        b=D28SuhfhBgSICbkHuxmZqkezrcCOwvC/nHcU4OQd5pfgbevqhaAb9nt/jwYN2Pbw4g
         ntlb8yVHyVj3V3WFv5qdbe9R59estvdXcrP0pqrGot7ux7mfLZxhHdeBXxIn5N7E7r6e
         PrPqmycnO8Sr1qMqlWbLq44ZnklXr5mjQxQKNXV9eanQlnrHOf3nKaA+dCvadxX+r3le
         /ZmaI/jX6+PmTRH8pmCZvF5fMs4YQDzXufM2v/mPAWlASOPxl2dp6YVn5L6w8ZF39i1W
         uN0y6NqSVK6VPLuarrCqH/q7X6cTBOmbb4gemODKbfYq4Np21NuLZ709449zU5KwXFRf
         woVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776132742; x=1776737542;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RnjfpD+5B59teRstSFpwFq28zSHyCsooHf0UM8fMsW4=;
        b=A6a3QKDzrdpHZQYLXZzVZXxJWSvogjyI+Xz3SCxpAFoIv8Tu4tBi2xV+su6rpHHdor
         NEW6AWIyDR5e1En9Dss/Fvck/YHN/oHnl9r1f4JuPRDsgFNkIWsis25jJAWz4JVpnjOZ
         jz61KDgJrylewo0WTH5QRFXmXPYrs/ti+Af2z77nPYoNI83o7L3Ci76YcBQfnfkPBXRi
         HEM9UqCVzyZ6HIU57HHYHEutyCg6mwKqsUFMBgfG1R+Uf1RQHPcnPA5hug5fCqbkZSNq
         JBpb/gfkexs1ajFF+BprMrCjTNUi9p8413gIVSyitQpNXKO4o4Qc+PM8chjjEyrWLMVH
         SJdA==
X-Forwarded-Encrypted: i=1; AFNElJ+GAVJI72axbdJR4dkFWsCZvbepCzeEDp6p3RfwiUiROLpY4yGq80n1l1fTZXtzEUEmF617WoIIxw==@kvack.org
X-Gm-Message-State: AOJu0YxqK32MPZfHWxSr2FVkKCbs95f/peYz8XhfCFwk/Wpvs6oYPMek
	4l/QJ8JvzUeUosjFhes8LIzX+drL7UQO2v0emeLychStcaZbtzVi+uTu
X-Gm-Gg: AeBDietWP+2yrgSQVK+9UPOQ3ocQQmSsjDpkYsX0oWhUlwV5BdLrGFJ85JzrCb0ZFuJ
	plHwFjJcsDI0xCiEb3LRjkivsywRe8LVw5O9X6ZC1/Feyglcnwlzv0FtCSaazOMB+Ok5kULswVb
	7rlJQh0e2WQdG0iOfZqJ3NncnIFtWM0cJAFVHB3EMvw/vfTJuJNw71qyvIFwdap/rclxxeMXBP9
	rN3ljXrs5yGQeHpcxbgood6LVuNguxbeBu14sbl3ZMtONvvZk5C+kHUJ81bxBT5njt07xlA+fcG
	Ie74iSLcLYOvHUqthSNfE+beuJR9wxwoqeI8CBGIAyML6X9ODitmyEFj2sPXAJI+BgUY8vExzbp
	6BiRtb7uqFOK6uicoLt8yP84OJnjpARKIIMrU9J2CYY1T+zRR2ur9YjqUokF1ALwjuK3RMc7mJw
	i070TGspXif9xdFG1W1yVPWA==
X-Received: by 2002:a17:907:894f:b0:b9b:207c:f7af with SMTP id a640c23a62f3a-b9d7267bf50mr841919466b.42.1776132741794;
        Mon, 13 Apr 2026 19:12:21 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b9d6de97e93sm351679766b.9.2026.04.13.19.12.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 13 Apr 2026 19:12:20 -0700 (PDT)
Date: Tue, 14 Apr 2026 02:12:19 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, Yuan Liu <yuan1.liu@intel.com>,
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
	linux-mm@kvack.org, Yong Hu <yong.hu@intel.com>,
	Nanhai Zou <nanhai.zou@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>,
	Pan Deng <pan.deng@intel.com>, Tianyou Li <tianyou.li@intel.com>,
	Chen Zhang <zhangchen.kidd@jd.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/memory hotplug/unplug: Optimize zone contiguous
 check when changing pfn range
Message-ID: <20260414021219.wayysugpfbzirzh6@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260408031615.1831922-1-yuan1.liu@intel.com>
 <20260413130633.knzkliyqvjhuz2kd@master>
 <1928b6b0-2ec3-43ca-a41b-e880d974af04@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1928b6b0-2ec3-43ca-a41b-e880d974af04@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: B7C8620005
X-Stat-Signature: beh6rta6xb6nun4rgcropudy6snzy8ju
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776132743-555343
X-HE-Meta: U2FsdGVkX1+PI/lgGEAeTkJtiPASRIWTIYAwNwu62Earkhymvj4WgyrzVitrpkWVkh1QEJsHMz4jFFgxB+D7os+ZZReI+NjWkb7qZTsar1JckLIRza01g4cYQI9s2xSvfrpExfa1Ib0h9UpKKij5hQPt22BKA0AQdKS02aYKYXMii5NfOeyeIsZyQTPJTfYtLnvEn5/UhbHI7PI5Trs+2eu4VD/Cy0/MZ54zqiXiFV8WmvhDriH86aCqy0K0/4Ie5kA7pe/T3x+a1EF1x5sSFTW6y6TfhxpVbZlWC8oQFum2vgWFWBIsuDvNH7idB8RdRItDbvCi+26slaknEW5N1r0ROv+dg5fAV0IcAEDupnBFovuSuLyPVgDcxB+Zqgc/qWP8l7Kyz+Kdy9bQRZAz5QKAuy6qM0LjoNKs7cIUaDU/QgRaN1L+Sjb2t9uABPME03aSHnxCR+Uf1vxi9YekjT8jiQJtKqRl4UaLWEminMgVVAssvhrqEYrtmL2e5HsUusQyhyvOWPtOfBq3QvXVMR563ZpX1wfRYqvWY/54YF46xMA/tb8JhaEUihnYY1S1L0TZZssMhd9rXICZtjrEHq/w+5wtnBdFpfol37QRagPH86DBtYmi6ORecqhRJqUcU9sksBzgc4KcROAag2Dfu5Gsz7pTQG1MHsOGd4opESyAoB5xTCUGbLqgLnYulu9IkEfgkNgsBrr4d9zy8D0suN3t3PXy93UP0U/TeI9zNJRWcdJodFPts0Gu7CuoLKcNv1tdrLTtoJMFdRnNvyFP6iu9cMxZ6+5nchEEsYVccLJllLUjXIBVkHKjVXYyWxOU4E6RAALu6LtcyRE+kN4++lEF1lrGzfyoPtC6mzvMBliLn8FnIiVIj1UQ1z8nOEcv/1PkefoL0Sh/SE7fFhzbqTsgxFDo1XMX/g35g+vyREYiwRWxDPwp2VrVWdm6yJhvTrDQ6fLVvQu/3I/d3Rq
 yXrgddHB
 pTWBwJyXwoBGRvfZVy4Vy234PXHpFBOaML79wBa/HM6AYJ2+4zATVqvybLNlpil5xtnXLqMyCq4VDs+ba64B5Zf80m6VYzmb2QVLERN9INeca1o/+efWVs0oMeII1BTYITNGAYkpSAxNPdFIks4sCjHF8hd4IQu5V+xx9w9H7Sz8vvxlt+jYcy2gSbV9mgk6OmsQcOmJGw/J0POnY4ZEbdCMdU4rWOe8MKuYrNdtvACZ3efxvuZLKFjYVtuM68s0KlvFPggWnhx6DjFaAC7aI4RsgrrKQeEqYrN0f3CnY4jrpLS3pUyzuV4/f7QArGhe7bjwUMyJ5KwSNVhTNJQYx/JT1BVUq+3XhhUSAp7lME19Ff2wRhb6xPZZ274ySC4GO276kva5TFrVUSahxp3uZm+bnmyJCYsAUpqJyU6r1dL6AoriSLHkUSvJR6T5LbYTEPH3AEc/eWVcFoh8M9LJSp8O0YTSRfCzfQ1l3PXn9ckUrnFNKghwG5YfWTnLdO/Uxui/ZC22bVG4peI/mu8WWVhjGRUPhJCuI0rzMR5dmCF1Jz5hNeg1A0N+2fRDmsaHh1yhI3+xkk0UkMHa13RCUow4wWNolchKYrYurG+jOuQrO4jEFFtRa0MCLrD9LcQQGKDIJNAy0dwBzM35Df4kdPiWfl+9vKk+7v/qzD/xotYm8wHwF43276PoFnFOrF4BxxghzgKgm4lo4252i6J/4MIoBZV67FXtrS9FsiCI473Lyae14jOJl5f1LV7lzZ4ehKBQylQbQjjSQZrCna3Ahd4y6uEbRSGZ6eEsi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 08:24:05PM +0200, David Hildenbrand (Arm) wrote:
>>   With the last memblock region fits in Node 1 Zone Normal. 
>> 
>>   Then I punch a hole in this region with 2M(subsection) size with following
>>   change, to mimic there is a hole in memory range:
>> 
>>     @@ -1372,5 +1372,8 @@ __init void e820__memblock_setup(void)
>>             /* Throw away partial pages: */
>>             memblock_trim_memory(PAGE_SIZE);
>>      
>>     +       memblock_remove(0x140000000, 0x200000);
>>     +
>>             memblock_dump_all();
>>      }
>>     
>>   Then the memblock dump shows:
>> 
>>      MEMBLOCK configuration:
>>       memory size = 0x000000017fd7dc00 reserved size = 0x0000000005a97 9c2
>>       memory.cnt  = 0x4
>>       memory[0x0]     [0x0000000000001000-0x000000000009efff], 0x000000000009e000 bytes on node 0 flags: 0x0
>>       memory[0x1]     [0x0000000000100000-0x00000000bffdefff], 0x00000000bfedf000 bytes on node 0 flags: 0x0
>>   +-  memory[0x2]     [0x0000000100000000-0x000000013fffffff], 0x0000000040000000 bytes on node 1 flags: 0x0
>>   +-  memory[0x3]     [0x0000000140200000-0x00000001bfffffff], 0x000000007fe00000 bytes on node 1 flags: 0x0
>> 
>>   We can see the original one memblock region is divided into two, with a hole
>>   of 2M in the middle.
>
>Yes, that makes sense.
>
>> 
>>   Not sure this is a reasonable mimic of memory hole. Also I tried to
>>   punch a larger hole, e.g. 10M, still see the behavioral change.
>> 
>> The /proc/zoneinfo result:
>> 
>>     w/o patch
>> 
>>     Node 1, zone   Normal
>>       pages free     469271
>>             boost    0
>>             min      8567
>>             low      10708
>>             high     12849
>>             promo    14990
>>             spanned  786432
>>             present  785920
>>             contigu  0           <--- zone is non-contiguous
>>             managed  766024
>>             cma      0
>>     
>>     with patch
>> 
>>     Node 1, zone   Normal
>>       pages free     121098
>>             boost    0
>>             min      8665
>>             low      10831
>>             high     12997
>>             promo    15163
>>             spanned  786432
>>             present  785920
>>             contigu  1           <--- zone is contiguous
>>             managed  773041
>>             cma      0
>> 
>>   This shows we treat Node 1 Zone Normal as non-contiguous before, but treat
>>   it a contiguous zone after this patch.
>> 
>> Reason:
>> 
>>   set_zone_contiguous()
>>       __pageblock_pfn_to_page()
>>           pfn_to_online_page()
>> 	      pfn_section_valid() <--- check subsection
>> 
>>   When SPARSEMEM_VMEMMEP is set, pfn_section_valid() checks subsection bit to
>>   decide if it is valid. For a hole, the corresponding bit is not set. So it
>>   is non-contiguous before the patch.
>> 
>>   After this patch, the memory map in this hole also contributes to
>>   pages_with_online_memmap, so it is treated as contiguous.
>
>That means that mm init code actually initialized a memmap, so there is
>a memmap there that is properly initialized?
>
>So init_unavailable_range()->for_each_valid_pfn() processed these
>sub-section holes I guess.
>

Yes, I think so.

When memmap_init()->for_each_mem_pfn_range() iterate on the last memblock
region, init_unavailable_range() will init the hole.

>subsection_map_init() takes care of initializing the subsections. That
>happens before memmap_init() in free_area_init().
>

Yes. I guess you mean sparse_init_subsection_map().

>Is there a problem in for_each_valid_pfn()?
>
>And I think there is in first_valid_pfn:
>

You mean there is a problem in first_valid_pfn?

>	if (valid_section(ms) &&
>	    (early_section(ms) || pfn_section_first_valid(ms, &pfn))) {
>		rcu_read_unlock_sched();
>		return pfn;
>	}
>
>The PFN is valid, but we actually care about whether it will be online.
>So likely, we should skip over sub-sections here also for early sections
>(even though the memmap exist, nobody should be looking at it, just like
>for an offline memory section).
>

And it should be like below?

	if (valid_section(ms) &&
	    pfn_section_first_valid(ms, &pfn)) {
		rcu_read_unlock_sched();
		return pfn;
	}

IIUC, this would skip hole and leave allocated memory map uninitialized. And
then those pages won't contribute to pages_with_online_memmap, which further
leave the zone non-contiguous.

But we want zone to be contiguous when we have a hole like this, right?

Sorry, I don't follow here.

>> 
>> Some question:
>> 
>>   I suspect with !SPARSEMEM_VMEMMEP, we always treat Zone Normal as
>>   contiguous, because we don't set subsection. So it looks the behavior is
>>   different from SPARSEMEM_VMEMMEP. But I didn't manage to build kernel with
>>   !SPARSEMEM_VMEMMEP to verify.
>> 
>>   I see the discussion on defining zone->contiguous as safe to use
>>   pfn_to_page() for the whole zone. For this purpose, current change looks
>>   good to me. Since we do allocate and init memory map for holes.
>
>Right.
>
>> 
>>   But pageblock_pfn_to_page() is used for compaction and other. A pfn with
>>   memory map but no actual memory seems not guarantee to be a usable page. So
>>   the correct usage of pageblock_pfn_to_page() is after
>>   pageblock_pfn_to_page() return a page, we should validate each page in the
>>   range before using? I am a little lost here.
>
>These non-existent pages (holes) are no different than allocated
>un-movable memory. So compaction code must deal with them. Just like
>smaller memory holes that don't cover a full memory section.
>

Thanks for explanation.

>-- 
>Cheers,
>
>David

-- 
Wei Yang
Help you, Help me

