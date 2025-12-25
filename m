Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F787E7AD44
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 16:07:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F9FE6B0005; Thu, 25 Dec 2025 11:07:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A8236B0089; Thu, 25 Dec 2025 11:07:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF6B46B008A; Thu, 25 Dec 2025 11:07:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E0C506B0005
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 11:07:44 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 768B460BB5
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 16:07:44 +0000 (UTC)
X-FDA: 84258474048.23.1A64421
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9284014001B
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 16:07:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MCpPyu3T;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766678862; a=rsa-sha256;
	cv=none;
	b=0lqHYGI1m47JoNSNJ4BQw4l2gF2HhXp/oYFNLXJHvPglz5WN10DOnRDxGWPPH+GbHcFBRw
	wsWYSsmve4XOgPyI3vGgaDXEcXAshoNpvgEioOK0Jd12q+L43borhsUI73k5MDOgY8DzEI
	5wPCQ5mx3o0PxF5eEIXWrjps2ZI8kuc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MCpPyu3T;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766678862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gSdylL0kzo1qAqIg9RWcKD8ANXBxTC1rZj2m/98WlQ4=;
	b=LVCOt2i1vektm2azcL+OwxIpB2CjsxJ6G2pzBIvyn0szraEcVYRTnpMsR0YEjm0I987O0t
	jNQ4gOLAG2ns6sxOfXJMLRbxJud47hoAJgMIs8UURCdtzQPYRL9k375zqxMk9FJ/3hRIap
	APtuidc90iES1G4PEU4gDvr3clccPOk=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7acd9a03ba9so7031885b3a.1
        for <linux-mm@kvack.org>; Thu, 25 Dec 2025 08:07:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766678861; x=1767283661; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gSdylL0kzo1qAqIg9RWcKD8ANXBxTC1rZj2m/98WlQ4=;
        b=MCpPyu3T3kudzCOSf7dWGkQroFgV7b0wrcGIH/QBAPwVQJsNESZT1WbSEvet+x23m/
         aiA/RaFKDfHgtLo7VGayzmEWCH8B183RJpPXTbQZ1sBBB/JOx3l/Q9wpl09TtZndp5Gs
         qTovAqparP2sOV4IFtaVT3XRPkYet80UeEIru69P9goZNinbiD7N0LEizJGv+509o5mT
         aUvy2ZHJDPpuaQ8CNWXVvbfZPLNXGre4cHqN59Y54xE3hAS7vznYY3KZwzCKziiK3OCk
         40aOoMEmRxlB9Iisp9L631+4LAorPmsIGY3677+Jc1zgDLmuadw4tuYf+TxDMGXYOsgv
         vL1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766678861; x=1767283661;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gSdylL0kzo1qAqIg9RWcKD8ANXBxTC1rZj2m/98WlQ4=;
        b=u2XBqMOWlvKGfMRIRv/rm6rgG4VY551wk9gFMa9DcakuvoQrkCnCgAqa1SZLFF2f44
         ZVt0XI53sxJPiYCCbOI/DdjbxlV8PGorYjJeuscecV9uXpzxHcmXxR0h9cOkLrmOsDKi
         WuFUPa/TYNmMmQBRg7VbZj86aCJ1NZ5yNKEmuyKGCckiazN5bIO5iDjy+VQVUT1/rv52
         eQcFdLGfG3cjGgsTXasFLbRejdknXFwqcARh3wLLvSLIb4DSRrZHPxFBOgo1DO6HKsEU
         04dIeTupFHUl7nXUoKQXk/b4WpDmPMYR6uA9SoO0SmaUfIc7E9pq3ZtDTvvowNKBBWsq
         Jxqw==
X-Forwarded-Encrypted: i=1; AJvYcCUnUWMgXGxv1mieaOrlSr/jZ3Uuumw5s0/YHHAYMqYfZl4LEgZE/oARegD8jAZQc/ZsSb1BXA6gJA==@kvack.org
X-Gm-Message-State: AOJu0YwcpthH7UdiVYFWefzX+y1f8Ro99ygWyeKU4KAT/n9whI7akONj
	B681RJgI4rqXDHpIBuZdQ4L/TMP4/YW6hwxBBJUuvprhABIQXvE3V6vw
X-Gm-Gg: AY/fxX6OrDw/caNPmXMezMgYZNyBLpkGzXPIMSLiMijigCO0MowExKryqRRGOpd4EOD
	T3+r3NaK+OsvKgqZSwLzmjKi6vSheJ2MGYnMaWcwzu0eWHFcyRHV5dremPRmsSwhpIKEfWbTU8l
	jgOZaQdRqymxQ6hBlUZsSMkkbTW4R2TxnOETnQ41XHgg8OyvSh5pdcCDfM9b+GfsUfEWbB/Xdde
	Xct6tSVvnc/rxYZ3NcRkbzQ7Cb++T5WPJej4SD+5GfWmnzuTduxpljK+uHqoYwGhKDeASfDwFGF
	BhVJUICAAhml84jUKk/kG6WZkiEXE4LdhVypb+iLCYaE39ckSPjcus62T5B0rMt1uKZTg7p84fy
	WtKoyoHAMWyC5SR5DC3OaU4ODKPTl6UU8pSKEF24J3anskGnq/7FXypjZe5RMfPvKCyW0tuLr6P
	k/NKvSKlOJSD73m8KhQ5g02QHZSUAIoxCoyA==
X-Google-Smtp-Source: AGHT+IE3M1jIp2dTo5Yh+s4BN1GgV25SwcPq11QHnHjdl1EeBTIENzCwOPVudIPtwjHf+f3N7ov40w==
X-Received: by 2002:a05:6a00:302a:b0:7a2:7458:7fc8 with SMTP id d2e1a72fcca58-7ff6421511amr18630130b3a.13.1766678861358;
        Thu, 25 Dec 2025 08:07:41 -0800 (PST)
Received: from localhost.localdomain ([121.232.80.251])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7a93b41fsm19557576b3a.13.2025.12.25.08.07.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Dec 2025 08:07:40 -0800 (PST)
Date: Fri, 26 Dec 2025 00:07:33 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: Dev Jain <dev.jain@arm.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>, 
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com, baohua@kernel.org, 
	lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH 2/4] mm: khugepaged: remove mm when all memory has been
 collapsed
Message-ID: <rejhtz6lttfqhvpvegy4eaph3dyajeoqi55erljwhubsxtlmcb@ugq5cueg7fkb>
References: <20251215090419.174418-1-yanglincheng@kylinos.cn>
 <20251215090419.174418-3-yanglincheng@kylinos.cn>
 <26e65878-f214-4890-8bcb-24a45122bfd6@kernel.org>
 <djh6xaia56grmgxdok23kp6ly3oe3ugsinxdp6jie3k2tzwaml@57gbrcr75jng>
 <52174c05-e9ed-4049-ac05-d0d0b3228f2a@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52174c05-e9ed-4049-ac05-d0d0b3228f2a@arm.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 9284014001B
X-Rspamd-Server: rspam10
X-Stat-Signature: bd4h3upthjoij9h3tduyh3epugt97c1z
X-HE-Tag: 1766678862-602414
X-HE-Meta: U2FsdGVkX19bl8NmHkkhYX4q4SuHSJibFfhLwmEOtv00NpXS7V+XAdMahsoL1hx0udPYmuUU66/fEYHCarpibzRHnOFW4KFcszUw0dzEOprPqo1ChTZcjRobtHSR6LCqs8ZsE1ilOSMr+mvtWCIIkkw1O9e4Up9ZqR6Z8ltXh/QXMUZsOMQk/q/ShhS4jIFm8/z20fh+YJbwgtXOv0MHLUB4Dz/zr0I41sq8c4Y0z0SixbOYJMLQyIlR2txTvNb4ArhRTWBWoUWzoq1wP6Xv3ayNiAuHJIzoPZVUDHaDGkExzatFdSsKczGRYmE75yQNfffVHI6Bdlbf1ifj7uTtbi6Xv8Tm6UUiDWb3Tl2RNpfGBLtHwCHecHb4ylCos2+KCpM3GVUIIt/RpPyv4Vkxf3NCjq8anV2ONz78SxUpZ+0XhqU6XTFNl5R4JVTn3KcgSYzDa2SsX1QenizgwCKsbTxwNz94TUcVL94LCR7H22SEQbj8Km852LzwnWI1v66YucIf8eMJhFjEhO4rJVDtTOd+0NAFxYU9tXadJRr/J3rL8YC1fMIVKZAdfJeTyl6MrpE0mWvGs4NlAUhPgDYccIraDo2vUBzHZphXb+bK5As+AezLiOOniXhF0zdjckKxh6ymQ/N9QU9TIMzLogkjnGm7WlynPeXICZU9V94FRTf+9uSiuvIWcRL3hjquiK/UOkFpYnkbmCrepf0J8ppylPr7VmDXw3zAx1NBqx3zPLpuB3wgNPOxO5Sxcm/52Tab0CCagemsVh7tT2EU25N3rDHkZ0+9zltVGI/Y+o4HImSrlyF6I4UDOhbnWfLND5eGXqcWRXHxkmtO4OCDY4rDhcRACY7c7kaEINKpm+Oe4hyEZl5JEn0Nce+C3T6Q/d6vx3afyHJlUf0SXW/exxJTbriXEPH0NK3AXPBorq+NfubVPOolx5DvDP2/jVOqUNepWil8v+O/2KfVoQMw6vZ
 K8JGtICt
 tvPndYYb1rQaj5LqOZLUUvgBbmqR+DB5Wp2StOQsISL/Fn2rD8urvg7vw4V1JwavFVbzm73TTwZ47D5G7Y3F6/0JsVzanaWp5gMDTXetURnIJDVjWYXwfmH1FyhSudd5XvqGg18frFW19NuYrMffa4lc2AOYpHqfPZjEL8CWBaM4PKmqon1u7ujzhbaOIjOO7Sa8MrDCafcIuOcYN4PEGi/plLBdbVroxjrxSCmSEsGUV+NFfh3WWiIUZj/JOd6LD0k63EjCgPAMnK2qUYSbO2Y/TtOxMilBiL4QVhjQVPHwUDzDGgQVQy/DOE6m83ubZG3UctYE0mYx87es8uksqK9J9dIj/8gX9zip8cf8SOSt2TF81PLG3lheLVRWpiXtaeMLif0C574blawPGzymZ0/8zU0nJeIsIhSf9qVll76chMhNx+LHAxO7HpoHaQ4x22HYHwYRCdKEr8geC54RB4NwFAD1feTMdGYgnIeP+d/YhQghvpuUvNQnNdoeSiDtI596CNO0AM31z7eiBRhRmI7IphQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 23, 2025 at 04:48:57PM +0530, Dev Jain wrote:
>
> On 19/12/25 2:05 pm, Vernon Yang wrote:
> > On Thu, Dec 18, 2025 at 10:29:18AM +0100, David Hildenbrand (Red Hat) wrote:
> >> On 12/15/25 10:04, Vernon Yang wrote:
> >>> The following data is traced by bpftrace on a desktop system. After
> >>> the system has been left idle for 10 minutes upon booting, a lot of
> >>> SCAN_PMD_MAPPED or SCAN_PMD_NONE are observed during a full scan by
> >>> khugepaged.
> >>>
> >>> @scan_pmd_status[1]: 1           ## SCAN_SUCCEED
> >>> @scan_pmd_status[4]: 158         ## SCAN_PMD_MAPPED
> >>> @scan_pmd_status[3]: 174         ## SCAN_PMD_NONE
> >>> total progress size: 701 MB
> >>> Total time         : 440 seconds ## include khugepaged_scan_sleep_millisecs
> >>>
> >>> The khugepaged_scan list save all task that support collapse into hugepage,
> >>> as long as the take is not destroyed, khugepaged will not remove it from
> >>> the khugepaged_scan list. This exist a phenomenon where task has already
> >>> collapsed all memory regions into hugepage, but khugepaged continues to
> >>> scan it, which wastes CPU time and invalid, and due to
> >>> khugepaged_scan_sleep_millisecs (default 10s) causes a long wait for
> >>> scanning a large number of invalid task, so scanning really valid task
> >>> is later.
> >>>
> >>> After applying this patch, when all memory is either SCAN_PMD_MAPPED or
> >>> SCAN_PMD_NONE, the mm is automatically removed from khugepaged's scan
> >>> list. If the page fault or MADV_HUGEPAGE again, it is added back to
> >>> khugepaged.
> >> I don't like that, as it assumes that memory within such a process would be
> >> rather static, which is easily not the case (e.g., allocators just doing
> >> MADV_DONTNEED to free memory).
> >>
> >> If most stuff is collapsed to PMDs already, can't we just skip over these
> >> regions a bit faster?
> > I have a flash of inspiration and came up with a good idea.
> >
> > If these regions have already been collapsed into hugepage, rechecking
> > them would be very fast. Due to the khugepaged_pages_to_scan can also
> > represent the number of VMAs to skip, we can extend its semantics as
> > follows:
> >
> > 	/*
> > 	 * default scan 8*HPAGE_PMD_NR ptes, pmd_mapped, no_pte_table or vmas
> > 	 * every 10 second.
> > 	 */
> > 	static unsigned int khugepaged_pages_to_scan __read_mostly;
> >
> > 	switch (*result) {
> > 	case SCAN_NO_PTE_TABLE:
> > 	case SCAN_PMD_MAPPED:
> > 	case SCAN_PTE_MAPPED_HUGEPAGE:
> > 		progress++; // here
> > 		break;
> > 	case SCAN_SUCCEED:
> > 		++khugepaged_pages_collapsed;
> > 		fallthrough;
> > 	default:
> > 		progress += HPAGE_PMD_NR;
> > 	}
> >
> > This way can achieve our goal. David, do you like it?
>
> This looks good, can you formally test this and see if it comes close to the optimizations
> yielded by the current version of the patchset?

Both can achieve this function, reducing the time of a full scan,
previously tested.

About performance test, I will test it formally.

--
Merry Christmas,
Vernon

