Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D0CED11183
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 08:54:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6A616B000D; Thu, 27 Nov 2025 03:54:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A41BB6B0010; Thu, 27 Nov 2025 03:54:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 957216B0012; Thu, 27 Nov 2025 03:54:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7F7F56B000D
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 03:54:07 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E330912C52
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 08:54:06 +0000 (UTC)
X-FDA: 84155774892.12.03C3831
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf13.hostedemail.com (Postfix) with ESMTP id E200D20013
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 08:54:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=e2HGyoX3;
	spf=pass (imf13.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764233645;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uAS+KqqG+zBZqw85pJZVsdMz12CbK2R9tQD1fbotlzM=;
	b=DZ4TNIWlHAXRlbEZp+4r+iupJBwW82KnxvKRYs1109V1G4BPy9SUsgb38/IuJ70x2VULSn
	HUYIJJLV03EIVLrT9QKt5kiDtmJINFZAr1Z35ch2gsaham4PgAdA2E9FXV1seie5CyE9Ix
	B2aXXc3r+Qv4pnknsoAC75SG5uaV7ZY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764233645; a=rsa-sha256;
	cv=none;
	b=myr9Kj0kUe26cB0N0wXDezJuF+75GP02hF00CH9NByNUanRpWmyD+QsxmrcYSPlI/ENcWp
	AaWmpPshUQK/zUJoo7mNdxiHiMdRVXFbxDum06t+xlFKX4Zhxhbz/MPiKNvlx1Tz7SW0tM
	xrlxz4g7OeICDWsDrRGkGiJgABjuGOs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=e2HGyoX3;
	spf=pass (imf13.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-640b0639dabso1128985a12.3
        for <linux-mm@kvack.org>; Thu, 27 Nov 2025 00:54:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764233643; x=1764838443; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uAS+KqqG+zBZqw85pJZVsdMz12CbK2R9tQD1fbotlzM=;
        b=e2HGyoX3NHaD6ZazB3Wpdk8PasCEO8G+K1vl3Po7CbTYqHI3IFyQZAOwHL3qq2YKZE
         GfSAkL5bvAuGN6HlmnMo0ZaFi0dvAOXudaygsoqPEs/WsnTPUkxgLv3fAMRiVPIiqAub
         6DgDH1BrFJhc0QBQZPVRWSAcpOJEP3grfmprjbyNcYD1bo6BRBRPivxwOfkD/Wwkw6yH
         FLjiTQaG+3cJZOiymsiUgwF3OSbgsc0t3QfHjjz1pGwJ4DUrSmcmyLYNVkad2q+xaoJn
         5KbhXqIg0VFIyvNCCMOmRQsYpWWkAYJKDq5xawp5htDkRlKUVZV5PlsndjigzGif7Kjr
         mCAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764233643; x=1764838443;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uAS+KqqG+zBZqw85pJZVsdMz12CbK2R9tQD1fbotlzM=;
        b=LRlKCnFiyDLTDcqV/MPbyGqC6vHfvL/4LNK68xN8k/uREqGF+ePWJwNvZ7jsXS+zni
         3wn+MsNe1oi81Q9mayfJ8ut+8BYFqXd00IdrumrK4p9a7i8GGe8eNjq0fy+A94u9oE5p
         Wbpc4zzZQpqa5tHyYtWd2PzZIRgpen66ThONlQo2Khbqa475N+r1EyneMM3c4TfxdmEh
         segM+UeB94wOlB3eQ2YnLy5ik0v59gqUDEC6vcIe+H7cL0yMvCJy3QzpxhKHx76jXYtM
         YXdYeAJ+pM9E9/XC7DeAWm1GKXKWjV+qq3uiNqfoTz+2xbH4PwK0kPCOahmkAK2u9dVF
         uONA==
X-Forwarded-Encrypted: i=1; AJvYcCUzuMoMg/vPEMaiAA8XIWyN7JRHRLY8Twe6bItQSgKssm90diR0f1V4lxQ/gpvmnZuy5BIB6jt8NA==@kvack.org
X-Gm-Message-State: AOJu0Yzr6M2a8P3iCO8PVrV//21+S+T49pF4WX8t/rIxUn5rrOqDRw2j
	8m2EcMh237MWyYO5kvhGLimpz5coLKIuLjU5WQHnu+FlP+2P6ZCq6O7Z
X-Gm-Gg: ASbGnct4/rBvKcvYq3Fpp/uPBIm+rwB3sS3OxstQ8x2Kts2xjaJ2Wj3xxYHozKuox3H
	geiAvgBzNwHxKwDb/UugIWrwmQmi5K0wxzs+7lcX2nRYhbjt/rMSlIJdfBQtTkjkL2ZMEDCohdL
	WQCYYjrblVmHjgrh1yU+h/CLrNbtYFw4el8pYTv6jikh85eAE4lQLkh9JaMaZUhMYWUs1x+fkWx
	lfNpz0dZXcvK4Gvo4c4Q0X+8jDTgcREUKZw08K0XFZ/vzmylGCOHFr/284+CWT5PuR+bNgiSzHG
	XATX6Bj6TvaFkfxEOVP4hxJufdEgb156kYbPvqDL7rehWarKZ40fOeYQF92tRp9OKiSX89zYjoG
	FqnYUT53OltRbmgc/mmGOb5txbFtKIVfbBfF1W9FW/1Fj5PWCjYcqGaShWlLszqljrMUW5vLIqO
	3upbR/0Y3VUg==
X-Google-Smtp-Source: AGHT+IEl2e2hl8F/WVPbAlYmr1govia2itm5jJX+NxRFS3EFJqRH7rsNW+SA9cBdxwHyGWwJf+UGKA==
X-Received: by 2002:a17:907:3e95:b0:b75:7b39:88bc with SMTP id a640c23a62f3a-b76718b286fmr2719657866b.58.1764233643148;
        Thu, 27 Nov 2025 00:54:03 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b76f5162093sm111521166b.2.2025.11.27.00.54.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 27 Nov 2025 00:54:02 -0800 (PST)
Date: Thu, 27 Nov 2025 08:54:02 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH] mm/huge_memory: use end_folio to terminate anonymous
 folio remapping
Message-ID: <20251127085402.gtbbechjwogot7uq@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251127022436.20734-1-richard.weiyang@gmail.com>
 <2fffc8d4-6cb9-45bc-99bb-b87f580aec42@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2fffc8d4-6cb9-45bc-99bb-b87f580aec42@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E200D20013
X-Stat-Signature: jobb3dhkusapx1mg5kaocdjhgiuziyc8
X-Rspam-User: 
X-HE-Tag: 1764233644-360151
X-HE-Meta: U2FsdGVkX19/tq1aPD0a+U+r55Gum4K3q1w+n0yVYnf/fQMRJyeOffGXklmdMqaufJ2V5NoCh2E4tjYyS+CtlNJi2/k+yCavKArQ76GGjHwbhIYDHVuyt8hT0pQbP3DSEjzrijhLleoM+5IqtmrLawp2l+kmLCCBeLMPotL8KPbBmh1AjPQB72DfFt6BYhm4Pr8tKiPRn+SNF25QY2EbMUiInlIvrwusSGlpjn+CeqKCcDOYZi8ltwHYESwd2cmuIYsyEP36FeTJmNhrxPDSQAT8GmTT5r88Gk+QSeaC8hCMBYsFEPEobJAojuS1ConzrqqqUz4sdIS7G+XR3/EsUjHTkDJ6+LAZWBz4SyG0OMexmkuusQB/d+afzgFR+k0ZV/JbjAsAr9AjWjefi/DF0YmX8YZtPo1PZifQYWY7b3ddzML1qxrUz5vU8OloA6XVMXM35TqYrH3NoqhXO0IEThgVw2aVY1NHfrsyDNvu9K4RJuAtKrBT1Jm36d1ckXPG1S22tuiGNOh0/iR1x+/XUs2e1Bcy+UqjdKnF/3UKQRjtQFyUvLlO9grI3vxN+ZaxtwbZWqOROyqJAfEWLqgjxv9jRVxfnrg5U6YmZZfJNRxqruGPnPy8Mw9p0naagmdydUiRMbtp+jyZS/xpKgqO53LY83TgRdI91ZAC/s4QevLyk7v4iB/CavR6TJY2XOxIGitDBhxp813b+i2QBvFU4GhqyTByOZwvprpDe2Yf0jAqVi5hFigxONBMOgix5KROIfnZh6LjUwZHFwbJKXwfeyAc6ti7Qf2eHEuI9F4YSBIBFC+trEfPCeu7bo7G0Lxx338emaxwp5VjTKFUXOhiYyfcn+6kFv6w26OtdVQJ0vmNvdmhmtP/VG6H1w7/jo1Yb7STIrMexi21M1QOXazSPqxf+NgpXuN/RYU84bDKp3c0KN4k7ZUBWI5vi+vfYuAcyf1Y3P6ZeFUc5I0TD+V
 HPhcKlcf
 M5lvtntdMH0t7jclISeJyycNeNwzmphKAr/1mHKyLw1PpmTSTAc/eRVz27x4HNB4Hvpu43zZIeCIXpbGMy3V5yi69CC8cd4oKYJQY5gd9CNJ0pOE8d35qfM2oQtO4l2js3km+Upiv0udLMz69WR/RFfQRIM1+YZTlEFC/wCsKaK0VOA0BOK/yd8p1n0+wt//Eu27oxIWS/vMsFDFPlZA6weIQ2WMRMkY9Ehtl61MqTboFzSr31JPc+nAYRbpsOZytJVpEWLJo2pvriFYJmA756bJ0p1qPG3Hqa4RmrGKZcARuNevJ6qV7z84psxC5mt/VUBaCAsMriHlU8/NOnwwsAA+EV3A4HvD2xZgZTyorTibR2YnhEX5AdUtDlFJd3iu+Rj+n3xJEZrDT4BGkVpGBeHTS0y13wZzK0C/RO5GY/jxIwP26pTXtmkd8PxEkKJXfaHUD6TiB3Sk6dM1xoIP7Yzzi5pvwZJOPOCn0qYqv2CAvkIYwa/kqPRUeePILHb87LePhUjxthwF7CFTSbXoUFWeDi1uoWi/Pjz2CfpnAvKJDC+ZxTbh3ZFCAEHhZvVUl+TXUP37VnmYK2Q8/1sq/aGZKkqpybllW0CPj+GsW9EckON3PnKJQDm8r9TIEcDHlVKYI6CRpQwajhZZbyDXsySeVMWuikcIES7O76o5X86f5UfT2yPcOTgtPcLRt4zldZ1AJuQqIJ6PDglsgdJ9BhljmIWMysanfoY64SYEqme7Izx13zzgp+Jf2XadVUMy4BMEWspTRFVRblZxDjQBuKlpocRiR1QBC0IAnMW1Y2nGq3MM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 27, 2025 at 08:22:26AM +0100, David Hildenbrand (Red Hat) wrote:
>On 11/27/25 03:24, Wei Yang wrote:
>> After splitting a large folio, it is necessary to remap the resulting
>> anonymous folios.
>> 
>> The current implementation determines the end of the remapping process
>> by counting the number of pages that have been processed.
>> 
>> Since the final folio in the sequence, end_folio, is already known and
>> tracked, this commit refactors the remapping loop to leverage end_folio
>> as the termination marker.
>> 
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> ---
>>   mm/huge_memory.c | 14 ++++----------
>>   1 file changed, 4 insertions(+), 10 deletions(-)
>> 
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 553bfa961fce..afc7b2f91e99 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3414,20 +3414,14 @@ bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
>>   	return __discard_anon_folio_pmd_locked(vma, addr, pmdp, folio);
>>   }
>> -static void remap_page(struct folio *folio, unsigned long nr, int flags)
>> +static void remap_page(struct folio *folio, struct folio *end_folio, int flags)
>>   {
>> -	int i = 0;
>> -
>>   	/* If unmap_folio() uses try_to_migrate() on file, remove this check */
>>   	if (!folio_test_anon(folio))
>>   		return;
>> -	for (;;) {
>> +	do {
>>   		remove_migration_ptes(folio, folio, RMP_LOCKED | flags);
>> -		i += folio_nr_pages(folio);
>> -		if (i >= nr)
>> -			break;
>> -		folio = folio_next(folio);
>> -	}
>> +	} while ((folio = folio_next(folio)) != end_folio);
>
>Rather ugly.
>
>Nothing lost by just keeping "folio = folio_next(folio);" in the loop and
>focusing on what your patch documents.
>
>But as Lorenzo said, the time for such cleanups is after most of the current
>stuff was merged in the upcoming merge window.

Sure.

>
>-- 
>Cheers
>
>David

-- 
Wei Yang
Help you, Help me

