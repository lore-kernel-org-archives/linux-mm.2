Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1742BFF885E
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 04:00:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35A006B0088; Sun, 26 Apr 2026 00:00:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E4176B008A; Sun, 26 Apr 2026 00:00:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AB4D6B008C; Sun, 26 Apr 2026 00:00:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 063086B0088
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 00:00:55 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 97D901B8189
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 04:00:54 +0000 (UTC)
X-FDA: 84699356028.13.DC25DBB
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9EF7714000B
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 04:00:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="lRBHe/b5";
	spf=pass (imf23.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777176052;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=30kEFePSCv6k+rR7C3eCM4pXv1NgrpkpUSRGNoUTIh0=;
	b=WhM/whR7j128amHsuKdxk81kEkRWDMIezd45l9mMsdqjai6Mw/TtD4cIpsqL0tZPU4V1Ke
	+Kygwk/ngaBxWY2OnZCLGxSj2Hbcm9Aidql0G2yY7D+V2rcH5MRs9ke5G6kLzBJbcIyTRH
	FYuJpP6JRh7SaAQfV05wEEAf0yjdDJM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777176052; a=rsa-sha256;
	cv=none;
	b=TqUk1NsPBvcyP5rsT00WRdqhlJw7zo6paXKt7NJU6Nv6ALFP/uCVHWeBNMAx+URrhfAIbB
	f5MBWUGyaibKsaTAhMTSSxUeda6nINpAfPK1UhgZ3Tx64C0hPQ4zId0+485JPjxM0pL8yz
	N9Hs248u7OMLqARxN1gUsHCxkIWWp9Q=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="lRBHe/b5";
	spf=pass (imf23.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-672c12e95e9so12960334a12.2
        for <linux-mm@kvack.org>; Sat, 25 Apr 2026 21:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777176051; x=1777780851; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=30kEFePSCv6k+rR7C3eCM4pXv1NgrpkpUSRGNoUTIh0=;
        b=lRBHe/b5DlytSLMPV8VIXZl5WGVEYdUDdYlkhP5bkGQkO0BqHN06qLPRaTSMXpW5Ow
         t+aMGuHDDeint+9JvnZBSkilA/YxkwNMer7IhcamorjgDH9RjYaaPcqhm57H55Bddh0G
         JSEUGpf7GqsnuW8nXmTN0vM+vr8Isf2GRR/gXQP7cfTBcOQU6kcIQh9c52EyEHzFgUJF
         /CDWMyD638tmGbA+tZ2kGOGi95GdRWUSV1ImQ99pHfv/KEgO/2e6+DWe/pr09FGQeRnC
         JjRwRmJohzl065+rWuJKpppah0lKL3Up5lq3JHLMwMWCGNuC1UXbfnUp3kFS7MLptR32
         2cIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777176051; x=1777780851;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=30kEFePSCv6k+rR7C3eCM4pXv1NgrpkpUSRGNoUTIh0=;
        b=KXlK1+Yws/TQSQ43fHuk9golgKKzHSP9nOwN6TF24dqN9SZ+TYdFmlRxaah88AncMm
         QkTwM+WMYrcZ4Rwol+lnD4ZAnM7bkvcobL9ZO5tdwVrhPf2t0XXWsIdn4XO4KJExinBj
         SyS5XvHNbrwXzY53xDeDPorTOkgHO0OTsUfU9gCE0jMs1YhU5T1vVzGVZNgSgJAoZDYZ
         0Qe2JNrMqhTdoMNMXGZoQ30ix9XyHDgRWNi0ozfAlucSFJ3WkHAyven36Fc68BZFDEGH
         QAJQpyeuBKSUSpRB1W42nI/aYTHDttZL00fwhZ14TxlgfPDCDTOPRvVvDBboBR/5Yj66
         VT5g==
X-Forwarded-Encrypted: i=1; AFNElJ+dBz5TBY1rrUCTBeqO3+ALcCBrQQYyjownSuz6w2m/OBID5Q89rpU2R/Sc46b0vRvWRBeVR/P6jQ==@kvack.org
X-Gm-Message-State: AOJu0YwCPHIVErIpx1muZ2aK+Ed8e32dvK38gv13UXVAfsWLWdTEXjYX
	ZwlITR4Z3JB7+OgvgewljFBKt3amy4+cPWgPWDa99P/1a4HRP/t29P4F
X-Gm-Gg: AeBDietbGJ3XRHuh4yA1k73xbAkTxUd+UMLGgRwloaeCErrmaepYo/wcRCCf4mCWgqT
	xdJ41kRTRSmxHgn3yi+PETL7Ky6eawupOzx1eDoNnb5+7C8IvlTzH6w6zcxTeM7g98cxCrL/S2/
	wV1FdNmwiX/1RfDMduTZVX+IsuGzGf32MMIEBenxjca1dt2iuvkOfLln6j/clpKYyHFJyUyj1YO
	1RzaV65bdfjOslOKMGRz8PCxsq345Xj9pCXDChP1WUiHjSepmSrcENxQRlvOuEzkgLTDh9xYr2a
	kZJDZeWqVYQS+q6IjMxwo1MbL9nCBRfWy8QRIdTgH/i2OthMjEcanJjhMtom3z18tg9Lis8tw+Z
	oh2TInldzThb579WKKpYf5wuGEStCpOGKqUsH3k/LuWtHiSSH5HwVmrWjPqfV3pQw3GOxOPxiIf
	bHtRVDZyVdcTx+vF4R74Yipc6aBP5LubS3
X-Received: by 2002:a05:6402:3214:b0:678:edab:6f40 with SMTP id 4fb4d7f45d1cf-678edab712amr1823623a12.4.1777176050801;
        Sat, 25 Apr 2026 21:00:50 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-67935440d52sm83328a12.16.2026.04.25.21.00.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 25 Apr 2026 21:00:49 -0700 (PDT)
Date: Sun, 26 Apr 2026 04:00:48 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Yuan Liu <yuan1.liu@intel.com>, David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
	Yong Hu <yong.hu@intel.com>, Nanhai Zou <nanhai.zou@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>,
	Pan Deng <pan.deng@intel.com>, Tianyou Li <tianyou.li@intel.com>,
	Chen Zhang <zhangchen.kidd@jd.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] mm: move overlap memory map init check to
 memmap_init()
Message-ID: <20260426040048.43sh3dgtp52eqcjw@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260421125508.2317429-1-yuan1.liu@intel.com>
 <20260421125508.2317429-2-yuan1.liu@intel.com>
 <aeyC9i2TziSzY8_Z@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeyC9i2TziSzY8_Z@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9EF7714000B
X-Rspam-User: 
X-Stat-Signature: 4z99kitouumygramm578gzyce8f4u1fm
X-HE-Tag: 1777176052-93744
X-HE-Meta: U2FsdGVkX1+4za8dr3ec5yH+DPQEBzs7hbSxiUy7T997ObypPbII+nScDE6N0ZvIkdMAUOBoc48d/miefYQ3sRZypYTAzzphKCUvNlNp6NqyGMnOZj4shWLiY6djcqUzecDs5d4NefZNjScztwY6hhMPt2jDOsqiAk1OKcTCC7g/gO80Xf7kRAY6/dcdE7amFeLPdIwh9wgLoB72xUQBpEbPedEMqL89K6/xjldPOsOk1j+cXD7B2m4e8Kc8sk9b4bEjfs85ZIFZNrWig0bxpsnoK0Y3gQQnP+TZMNMHEc0CGTT4QSeyhBi6Hj9tv6M9LGFqWoKPSb2WP8NY+ZRb46vLKveGOMjZuxEVrzA1xPNauW0YnTGnmLJeUn43TRLCN7bGQOMd+9rnKF7ZYH8sv0S/Y4/CHRq5XW9Y8JGPJC/nRBYCMIzrbXIT1xxzxbNz3BeoC6Gc2E66F/6Nph9meMuiOFVhDCC6SyCNFN6ee5aunRAuqJQ+KOUUw9fcgCKzns+Cd/GZER+H5Ps510F9mB/k5HNhvWVklT5MhflB4af1BMCaB0nMaWJ6dh0dC3a87975fOB5SIKHo8bud47NyvrEnzG4j3En04LPpKzaIf7r2rmSXCulPU2vDO1fCzfyiNChA53OvKxBTObmqFfhHnwPUzCWT/vM0uK5dbZ7t8kDe5SQKMduOKMTUkBSNApr7XVVVn5pD2psqM2rYhqge0xNqUhitKqMkf4bjUPa9j0z6MzQHTng5zeZmSHCoXUBIK9OOEqI0v401Dk44kNzuQH0SCLFuuqXEafP2Xw10sCyvBtFsmbTvUsXJG367IU+ZYyjcg4fLidPGQKyVr9lsFOVIZxzK29ZhsQPcTnzbT3LInNw7WMoMcRhTSlOuME5DlWsCHWSBNV/EQpr5+c63+C3J6acva/knT8lSbn+DRl7T63oyfZCohvrswgWNg63k5QtHnP2pA8NxpAGemK
 GJKme22T
 AYLkWXl81dp7xjCQcbWURjMttIZ178km9cp7/4MJXnPWCRtiu4ShQ3KnTxZ24HHGghnSw9BmZvVV/HY9GEeEeMF92v9BdpaOZodPl8R29/owbFliMSF2uFSUrrZXYyL4pjHRY5bElpbwLsMLOMBfhasA0Mr6RToBRrrGUfeZojzyHXLFYBePQZFnlS64jekE0cpdx6KNv/XDtcCR2ck5jMnbil/H8+jHHaMCxTW6GX0gjiptJ283YBKHa+kE8E3nlmMin2uACzkqxdWMV6wL+NRjDz6JorH3N+Im3b/6QxLZeoG9MLmnQOh04ni16zxM7vMUXagHug2iW1Nq32nMWJX9PaQwnVHnXpsoSaeFWkxjxUH/7VmQ2oUU7s7FXhr//HCemY8h/eJM8pemvayXQvmxQ4NXAxvSCYlcFOi8Cak/9mSGlgZmleOqA3Na5NzU7xLb3IZu/Iec1xGv8sNS4ObWeywNAfSYY2k2rm3KcDJBsDLIBAWgkiu6Hd01ajtvazb0d7xE8jCor+JS/c1pGlKBmUJq+6l1UYXJ5eOj8znYrrzr2U0s+5iZj11/ml+7g8fU/XgAuzLceBDHjQYj70z5Ny9ML7qhzIvx5ukfNlAFk3flPeUetE47r+l+DZMGosH9iJEUnrI54gP7+9+BKKmzPw0MYDn1zwXcMDgtog+FWcnVplEsOi51iOqGeYDlL04rPr5lmZczDbL6wg/k3tTHuRMdqxxud9CGG8IxaXQ5y7dEOzslp4JtBl0m7hHkLoY5cb2WLGf5bmT3Vs4Gv42la/zJxobxhi3plNHvjx6Oh7KFfg6LbZ1c+KnQ9YGrfduIdSIQqEgjYfB4iq1Ko+uPAqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Apr 25, 2026 at 11:01:42AM +0200, Mike Rapoport wrote:
[...]
>>  
>>  		for (j = 0; j < MAX_NR_ZONES; j++) {
>>  			struct zone *zone = node->node_zones + j;
>> @@ -978,6 +955,18 @@ static void __init memmap_init(void)
>>  			if (!populated_zone(zone))
>>  				continue;
>>  
>> +			if (mirrored_kernelcore) {
>> +				const bool is_mirror = memblock_is_mirror(r);
>> +				const bool is_movable_zone = (j == ZONE_MOVABLE);
>> +
>> +				if (is_mirror && is_movable_zone)
>> +					continue;
>> +
>> +				if (!is_mirror && !is_movable_zone &&
>> +				    start_pfn >= zone_movable_pfn[nid])
>> +					continue;
>> +			}
>> +
>

Hi, Mike

Thanks for your review.

>I think this:
>
>			if (mirrored_kernelcore && j == ZONE_MOVABLE &&
>			    memblock_is_mirror(r))
>				continue;
>
>would be enough to remove overlap_memmap_init() and keep the existing
>logic.
>
>I wouldn't deal the theoretical cases Wei mentioned in this thread for
>now and prefer to keep the things simple. 

That would be great to keep things simple.

>The assumptions that mirrored memory spans a contiguous range below some
>limit and that mirrored memory is not removable existed for years and I
>don't see why we should change the logic now and complicate the code for
>exotic theoretical memory layouts.
>

I don't follow here. Still not clear what the memory layout should be.

IIUC, case C is not real, but case A/B are.

I took case B as an example and do some tests. Below is my finding.

Here is memblock layout for case B, with the head 1G of ZONE_NORMAL is mirror
memory.

   MEMBLOCK configuration:
    memory size = 0x000000017ff7dc00 reserved size = 0x0000000005a939c2
    memory.cnt  = 0x4
    memory[0x0]     [0x0000000000001000-0x000000000009efff], node 0 flags: 0x2
    memory[0x1]     [0x0000000000100000-0x00000000bffdefff], node 0 flags: 0x2
    memory[0x2]     [0x0000000100000000-0x000000013fffffff], node 1 flags: 0x2
    memory[0x3]     [0x0000000140000000-0x00000001bfffffff], node 1 flags: 0x0

This meets:

  * mirrored memory span from low to 0x13fffffff

Then I add below change along with your suggested change.

@@ -964,6 +964,8 @@ static void __init memmap_init_zone_range(struct zone *zone,
        if (start_pfn >= end_pfn)
                return;

+       pr_info(" [%lx, %lx] init to %s\n",
+                       start_pfn, end_pfn, zone->name);
        memmap_init_range(end_pfn - start_pfn, nid, zone_id, start_pfn,
                          zone_end_pfn, MEMINIT_EARLY, NULL, MIGRATE_MOVABLE,
                          false);

And see the last normal memory range is initialized twice.

 [140000, 1c0000] init to Normal
 [140000, 1c0000] init to Movable

Then I removed your suggested change and adjust code like below.

@@ -954,6 +954,7 @@ static void __init memmap_init_zone_range(struct zone *zone,
                                          unsigned long end_pfn,
                                          unsigned long *hole_pfn)
 {
+       unsigned long old_start = start_pfn, old_end = end_pfn;
        unsigned long zone_start_pfn = zone->zone_start_pfn;
        unsigned long zone_end_pfn = zone_start_pfn + zone->spanned_pages;
        int nid = zone_to_nid(zone), zone_id = zone_idx(zone);
,
        start_pfn = clamp(start_pfn, zone_start_pfn, zone_end_pfn);
        end_pfn = clamp(end_pfn, zone_start_pfn, zone_end_pfn);

-       if (start_pfn >= end_pfn)
+       if (start_pfn >= end_pfn) {
+               pr_info(" [%lx, %lx] skipped to %s\n",
+                       old_start, old_end, zone->name);
                return;
+       }

+       pr_info(" [%lx, %lx] init to %s\n",
+                       start_pfn, end_pfn, zone->name);
        memmap_init_range(end_pfn - start_pfn, nid, zone_id, start_pfn,
                          zone_end_pfn, MEMINIT_EARLY, NULL, MIGRATE_MOVABLE,
                          false);

This shows current code already could skip the mirror range to ZONE_MOVABLE
for this kind memory layout, since ZONE_MOVABLE doesn't span to it.

  [100000, 140000] skipped to Movable
  [140000, 1c0000] init to Normal
  [140000, 1c0000] init to Movable

So I am not sure the real mirrored memory layout could be. Would you mind
giving more detail to help me get on the right track?

>>  			memmap_init_zone_range(zone, start_pfn, end_pfn,
>>  					       &hole_pfn);
>>  			zone_id = j;
>> -- 
>> 2.47.3
>> 
>
>-- 
>Sincerely yours,
>Mike.

-- 
Wei Yang
Help you, Help me

