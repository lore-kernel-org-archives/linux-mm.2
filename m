Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14113CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 14:43:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 694E88E0009; Fri,  5 Sep 2025 10:43:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 645E18E0005; Fri,  5 Sep 2025 10:43:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55B2B8E0009; Fri,  5 Sep 2025 10:43:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4317A8E0005
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:43:52 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 57461B76D4
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 14:43:50 +0000 (UTC)
X-FDA: 83855465820.05.E1A9FB2
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5234F120003
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 14:43:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JSL63xeM;
	spf=pass (imf29.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757083428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gwJaAVz81BObi+H/arsIEh5sBDwsjXLHGvxI5p+NvZc=;
	b=naTzI0UFKmIZl2RqQcu15n2kKYTMpnwbvZDrlr6YqhR+PKrsGgSblGrCYDmBeqUpQ0xaqL
	8FArZ+k1uuk+ZKfIAuEM/IsiBPyp1LvVbueHVG/cKZddzQHMNmG5J+8JvWHMuCHFbSX2U0
	/XeHn3olh171783aZ1c6EXMhVliyg90=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JSL63xeM;
	spf=pass (imf29.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757083428; a=rsa-sha256;
	cv=none;
	b=0tosUMqJnK9SqaemjnaGYf2KxzgXHhR3jCl7/5ESsANwdvYq+kAodIc7/prqkiLoV44WGf
	tjyOAuzPychLa07GvFckbboGwViZbgWnVCrd/gEf4Kh6CgcByKuvHG6609GgDGb+m5qhRM
	SrMsrck0U5CrrmyKlX+9VLnlbrIcpDA=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-45ddcb1f495so1063235e9.1
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 07:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757083427; x=1757688227; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gwJaAVz81BObi+H/arsIEh5sBDwsjXLHGvxI5p+NvZc=;
        b=JSL63xeMLDMn66o8ef4I49U3ccDyFHU+fEgvLjKY1RC3OZXMcfx2FimW5RdZFYBFZ5
         z9MZO36wCZppuSQknuG+nhcDyZVpx8JzqOwng6S2ovM1EBBx2Xu3ctwTZZfRKlhfJSVx
         6DtQF4J8yOQK11Uybzf5EBzw4EOb0SXasLedmdN9mpmEvKkhjplA9F87vBXRdYB5Rqfu
         ivmwAgbF5ScTi6WdF38rDzTYP3bmu/r5HqK+I/mHMKrpv36M7NdsDVsHm4W7ZWHxBfxj
         E8yJJvYzJXqZ4ohte71KLg+dtAfitwY5W8KU6A6HG1SPIBmC3pEpGLvYasECVWD7prBk
         zvNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757083427; x=1757688227;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gwJaAVz81BObi+H/arsIEh5sBDwsjXLHGvxI5p+NvZc=;
        b=Z1j7kMMBhaJDtWzza8rt/1vTiusij/w+xScL2nHBJKQJdIMCmAZnPdzB/yIaWt5jdp
         v0sOI/hAHpuAEETjqF8p+qY2NU+WfjXimHhkHM5SDL7TdbypyA3GW0qUQUXFRqjzFWwj
         Wj5URmdz2pUt/J2o6v239xtFmCHa0DdXeOvhjqr75NmGooRC97A01U329ItOtmZ3lqwi
         btxczV5Yvh0rDtaIcn28JxKPsHBBD3zdGQgogWU1KZUCmYJaNVZr5Pz7KYED9MKZ+B+j
         bxnqnV52a0s+oOgKenRBCGtPa1epA8STM+5mJCQovstN4F2ly0SIYGJvMX3siAgyJ8p/
         BFog==
X-Forwarded-Encrypted: i=1; AJvYcCUAX6+XU+vcpXb90Kr8oc98q86vyzFv5/pZxWCHVpcPTMLg3m4amY+lD37KyCy1TrzhXvVauyEByg==@kvack.org
X-Gm-Message-State: AOJu0YxKSVuYgLap/o0jilYv5VLcYD5WCV03apo684LfL7VQkeVqHA0g
	Y0ZnR+DfE/RYapQYPa1b4vluq7IBjS157kU1jRhJ96hpVb5ARR5ic9r7
X-Gm-Gg: ASbGncs+4axmufpgXhkgauO4SuTK0THj0PNs1B9tXCDO3sUWmzY3sp/lezdHaMMjHrB
	WrM9S5V74aYmGKj2DmRXBvwpv/Q9QZsuHGEjgiP05SykOSGhkAUA6OyiBrzKPo6hJZvd3tspmHX
	E9F6r6kwggs4MMWEwOd8OCRvY6WikPMbiO1JnSNNal3VWyeZq3ow3Q+O9Z0A7Av1EN69FuE+Scs
	sSbR3l5zaWZi8LRWjgFPB0rGNZEaj8Gsyw0pIZv4TMgKsKdvsOB2LDgFTRkGkQvoSxzzjthTOB7
	gFRS+PCwcewT47NbT8EV8JGNKwBXfm3lw0nycP2xE3C5xbePS75P2Eb8Z2G/qgZ2HSw4o4kUUrB
	Mum7D4NcPmi9IBAjEEhdqjSX0a3sN00rkLZKMadIDhSzmkV1D3+l3RJqAqkfoFQ4G+7Lhdww=
X-Google-Smtp-Source: AGHT+IGTEmyI3GJ5+Bu7s94GgTAOG29U9ayxB6BDUIhPl8/Z0BjlcNHrWbUoE21RMRPW1bmYwLPBlg==
X-Received: by 2002:a05:600c:4715:b0:45b:43cc:e558 with SMTP id 5b1f17b1804b1-45b8558ad00mr208282635e9.35.1757083426547;
        Fri, 05 Sep 2025 07:43:46 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1126:4:1449:d619:96c0:8e08? ([2620:10d:c092:500::4:4f66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b8f2d3c88sm200044495e9.19.2025.09.05.07.43.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 07:43:45 -0700 (PDT)
Message-ID: <d5c34688-30b8-4360-bb71-8c85f01bc8f4@gmail.com>
Date: Fri, 5 Sep 2025 15:43:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm/huge_memory: fix shrinking of all-zero THPs with
 max_ptes_none default
Content-Language: en-GB
To: Zi Yan <ziy@nvidia.com>, David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>
References: <20250905141137.3529867-1-david@redhat.com>
 <7B0B1E09-5083-449F-851D-FD63D32D2B3D@nvidia.com>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <7B0B1E09-5083-449F-851D-FD63D32D2B3D@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5234F120003
X-Stat-Signature: cs6g8gipckqjw6qxgxxwx1ers73wbmic
X-Rspam-User: 
X-HE-Tag: 1757083428-408237
X-HE-Meta: U2FsdGVkX18DVXaYGH+TCWYU1UQf/9hTyrFrM5HLZQepopiuYxE4HQ07TocDEeO3y4cyBAsgZIYfhcvQ7Q++Ru5lm/FNqr75qnnFmxkFnyNXk+fczPomLGQieeDstuYA+FfesUaYqv9jwhJMcTQxvWd4g2c3/FBHMAdBDohI483AQafgRm+gEbDGFNgNfJMJNOG1y+KmmR9kReYCbulkB5MqTn4TXIQLaCVn8X2OBSWwvXVbznR8cxgNk9xMZfPybY4w/T6j/2/GbqEQ6gCwfasQ7V3lFz4U3CDNxBWElkpnyb02KXtooaN93jxFu45XpLiLzlXoi79VggeRItIDgIbmt2ktmfFU9XwIIABA2md9P61kFdOg6Ps1euW1nLTRvVTkzIt5l6knohIt8wlr9vKP7Aai8ksBR1WJsJwGQgyAxkXtJXA0PmU1MJRj8/2oV1qA5rBl3zoVfyr3QjbYng1BZru38JZPf58KqLldz59KR6ysqfbB1+S3gqWMI8WCYwoAV2lCGwr6X9eAy3qgEhH6B20SH8oRmJBcJAg4BCQdrEAoUgnKMDc/M7UptCFhSx6NW4+C/hPxMpQfusOrzSkt9wxzBHflyvCtGBYvRAr+kKwwkj1941vA0SMsjf7vJRZjUh7st3LLqKhw5P4e0qgNLXQDYOLGKyPWWnxfzO/Z63Zt29naV1QD0RmAugf9wg3IGrzu9dMSU8CKjHQp39i43Ljl4ZQuhIQWAQKSi6vj+QF2CiVqaFQ9mJNAaFvdsNCar8A9mn7PpwTKOBZB0MZIQ65HErrk2CB1YHHglSp7bpVXI/MB0bu9SzNCoZWkfJskOHw/YW/2en+A6GH8AHUDH1X75Nh5zkKZq6Odtk2Ff221W6FZpVf9WsHWKMGfueJx77FJA6BIqtkBcIXgpTBx0nSBxopKmuWTWy6XnaNVOxR1nxR/yLFGjasJTaYp31OdJCaJmud8qHdafym
 PpYJBRJN
 JTsCAGwI3aMk4XKYsK5HZaBXxIyn2jSYrYqNeZsMOnrbhUUYvf9wtkE/JrdG4dg53IHK4VFWF3wHTHZeg9Jqxq1HiOyr67h7yMt5w2Hg4KFrstXG4NOep7b2Fbo2hyHShzcjAwn2rimA4QCD8kZblzkYmCTUB5XFVbBZFJv5WDMRbUr0d2cawRl7ifKI3SRldZuBSoVogZDcUbIDr3D/qvoPeaKtaC5mZ7sE77OlmhiriyYtr9k0zqVtGOMiQNvDbNxk9JnkzPMPkxR/8SL85d7NP/U/SL/jQqPp540U9yNWXqJ+fWsGUHkiuPpdUl/dIYaaS1z/whLNwrhVll3yqwFY5M4PVmGik4sL+uvK95A1QzI7OIq3ZxDIUgdRuJoaHa/aYFXCKTRrmMnYyEMWxS1AQzqKjJcHcuE5R7TMKhJbm0P+ZeyR5ykFQF5nZ9j7yxse88gQkzakCxYtHqaaFHjH2D7vmsMowyPXDALpzSLIy/D6OhH9g/g2qeNNIsDJsGxHsKuT0VsY3hQQ8BSmilBlLtesrnQf2HynSVYYx8tYTZUJRRPRcO1upPQzHiCDfiahNhLZ/hYCyRqQHK96ZUj8wWyveoixoVLjond0X49aKupkC4WSDGJZOTTRPGgOXnYcamQqWh71gZN07pfNaNSFXOAJ0gSNmLCTkApjHqSbDHhDhmzFbAaOBt86Fyh3R1hupyLou1CpT+5rafNk+H3rULSl17N9a3KkteGmnm+0DCE6MkaBW7Sw+kIDpCBnzIGV4EdO3IZO17Py6FbT0tIUsggxJjR8yVI5hG7OSObaqdEg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 05/09/2025 15:37, Zi Yan wrote:
> On 5 Sep 2025, at 10:11, David Hildenbrand wrote:
> 
>> We added an early exit in thp_underused(), probably to avoid scanning
>> pages when there is no chance for success.
>>
>> However, assume we have max_ptes_none = 511 (default).
>>
>> Nothing should stop us from freeing all pages part of a THP that
>> is completely zero (512) and khugepaged will for sure not try to
>> instantiate a THP in that case (512 shared zeropages).
>>
>> This can just trivially happen if someone writes a single 0 byte into a
>> PMD area, or of course, when data ends up being zero later.
>>
>> So let's remove that early exit.
>>
>> Do we want to CC stable? Hm, not sure. Probably not urgent.
>>
>> Note that, as default, the THP shrinker is active
>> (/sys/kernel/mm/transparent_hugepage/shrink_underused = 1), and all
>> THPs are added to the deferred split lists. However, with the
>> max_ptes_none default we would never scan them. We would not do that. If
>> that's not desirable, we should just disable the shrinker as default,
>> also not adding all THPs to the deferred split lists.
>>
>> Easy to reproduce:
>>
>> 1) Allocate some THPs filled with 0s
>>
>> <prog.c>
>>  #include <string.h>
>>  #include <stdio.h>
>>  #include <stdlib.h>
>>  #include <unistd.h>
>>  #include <sys/mman.h>
>>
>>  const size_t size = 1024*1024*1024;
>>
>>  int main(void)
>>  {
>>          size_t offs;
>>          char *area;
>>
>>          area = mmap(0, size, PROT_READ | PROT_WRITE,
>>                      MAP_ANON | MAP_PRIVATE, -1, 0);
>>          if (area == MAP_FAILED) {
>>                  printf("mmap failed\n");
>>                  exit(-1);
>>          }
>>          madvise(area, size, MADV_HUGEPAGE);
>>
>>          for (offs = 0; offs < size; offs += getpagesize())
>>                  area[offs] = 0;
>>          pause();
>>  }
>> <\prog.c>
>>
>> 2) Trigger the shrinker
>>
>> E.g., memory pressure through memhog
>>
>> 3) Observe that THPs are not getting reclaimed
>>
>> $ cat /proc/`pgrep prog`/smaps_rollup
>>
>> Would list ~1GiB of AnonHugePages. With this fix, they would get
>> reclaimed as expected.
>>
>> Fixes: dafff3f4c850 ("mm: split underused THPs")
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>> Cc: Nico Pache <npache@redhat.com>
>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>> Cc: Dev Jain <dev.jain@arm.com>
>> Cc: Barry Song <baohua@kernel.org>
>> Cc: Usama Arif <usamaarif642@gmail.com>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> ---
>>  mm/huge_memory.c | 3 ---
>>  1 file changed, 3 deletions(-)
>>
> LGTM. Acked-by: Zi Yan <ziy@nvidia.com>
> 
> I also notice that thp_underused() checks num_zero_pages directly
> against khugepaged_max_ptes_none. This means mTHPs will never be regarded
> as underused. A similar issue you are discussing in Nico’s khugepaged
> mTHP support. Maybe checks against these khugepaged_max* variables
> should be calculated based on nr_pages of a large folio, like
> making these variables a ratio in other discussion.

I unfortunately didnt follow the series in the latest revisions.

In the earlier revisions, I think it was decided to not add mTHPs to shrinker
as a start, as there are diminshing returns for smaller THPs and having a lot
of smaller mTHPs in the deferred list might mean that we get to PMD mapped THPs
a lot slower?

> 
> Best Regards,
> Yan, Zi


