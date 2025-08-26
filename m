Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B569CA0FE9
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 12:49:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C4896B0207; Tue, 26 Aug 2025 08:49:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 775256B0208; Tue, 26 Aug 2025 08:49:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 664F26B0209; Tue, 26 Aug 2025 08:49:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 524FC6B0207
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:49:35 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D22D15B7E4
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:49:34 +0000 (UTC)
X-FDA: 83818889868.07.C7BD647
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf26.hostedemail.com (Postfix) with ESMTP id C43B1140005
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:49:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hevt3vtk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756212572; a=rsa-sha256;
	cv=none;
	b=gGzweBT95w7hTbC3dhv4WybW7kxdxQn/sec0ic85uhbsaE4xzSnnIfB3b5qfm9XFNZgjSm
	Fj6v/9KZBA/+AIOGUKH+vi8hRzvrGlykQx56ktxY2fGxe8/ZBhq0rX9L0LRvnLkubgrTxq
	XULBi07tnfrYECRp+sHJKGojZ2QY6Ww=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hevt3vtk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756212572;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E9Sbt6rcunNyWvDfSlRKWRHDJPajA+dW2r+/5L7KKtw=;
	b=jFwpJOXW0AHIDZYB1wfBCm83GyS8qQqVyjxrsh2oluAG+LsikOcVzKp1e8UVs6otkNi9g7
	WYsnL76X6RWac/Ho3CZoMuu6PAmTJHY0i4eJgUUec/Kz3rRYUakkhkVaTrA861Guk/YhlE
	au+mihALWKXbZvH7HzkbpD9SbUn+QOk=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-afcb78d5dcbso795651166b.1
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 05:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756212571; x=1756817371; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E9Sbt6rcunNyWvDfSlRKWRHDJPajA+dW2r+/5L7KKtw=;
        b=hevt3vtk0DMWwWPs9TJCrIVGwO9hFrHoILCgXFD9tVmgF57UgtZ59qVZjwe7RhUr5R
         YYoBSnwPe1ihmHq/cfLkb7zL8H/R98jMD/+EDo8v8FdW/LTCzAycG+Evrad0X7NF0GIJ
         oVfMQQ0WTV8h+4G9dSofbkTjaWAOBSSiG7BpkMvcYfjONMi6ZzfgGvqWo9CjcLqEFqdT
         UzWuaPH0lBOepO73r+8ddDqC7bi3H3Lb1+2H91WA2hILseI8FKqpUFz6dZhKSNmMsseq
         isOzG0tqevg02SxPUAIo2ubNR/PHKTiUxuFJtsNeEE+eVVr/yQJnpQTwPDPU9AG4qv9h
         FjcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756212571; x=1756817371;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=E9Sbt6rcunNyWvDfSlRKWRHDJPajA+dW2r+/5L7KKtw=;
        b=JT6tOg3QuYDMrIy8cp5djwQieSiLcAs/8UvQLqPIcoFpz1YSPjDr83Lvft+R68h3yr
         00kP0r2+Ne40eS4608L8lJcOfhFllfKW7vrjAY2TrIrfHY/kaolhFwb+MUSvZ1yddk/V
         JA2gdW2/pehW5zuV7LdCoA0Cm6NX31snJQHKXuaTHSr8Mmmygt7VeEsGo2ql3OiB5YhL
         Xx37bYi7T6VTCDVgA5TnxFtMFgXteGA0K3kti59gAKM7j9/RAYHlMOpBOS6EX0+Mhmzu
         rkjeekDlN95bRkqIdVBmMj2JN9CS6lXx+y/ytOI97zpdpbJS+S2wgBW1QXlBjCvGuUF8
         z5rw==
X-Forwarded-Encrypted: i=1; AJvYcCWjsceiODrH+jP6ba6dXTeUj98pzZXzu1u4zas6Vw2iYCYGlpoHpvB/MR/tgH/cRYtW8C5ObytUtw==@kvack.org
X-Gm-Message-State: AOJu0YzYvPhcz/AZ+qXHobUTTMHFVNGDj7DV7BFvJsciFesCw0kQsFBo
	QhJ3wI9NjZAtL4wBokA4SKYGwAMQzNV/VbIFZHS9P1Jhi8BO7qaxFj6o
X-Gm-Gg: ASbGnct2Ned7WUv6CoXqO5LcbWi218sOXfsWW6PnoM917KrnjjQfOCAQfboVYnNj4Ct
	QB7Wwq9+7uORJXLDkWyANrpBJALF20MbUB7xP7U07VcKSEkI2iUy3L6I1FdjB35zKo0KnZF61VV
	kBYW1HnZdCABcBuscSM2/+LjtOEdda2RNhTBZx0roNjuLgW9BSEaOC4wfRFlY58yYKdg3OGxl+I
	JGKEiQbt6L/G1qlU2HyfQNpWBGQfzIToq3X18tm80X3klMhsDkFSH8WMiTiUcutBHQzcUaQRsQA
	tRzy5zo2mB4ObLSckFCGW4wS4cMQ/ux6FMR+eTYa4k+FoE62n7OTU2L4cYK654oLcCjjxzKV5hD
	bvTElsWT+YpFLSmMvx1Ur5fj4JNL1oRpdbM2H
X-Google-Smtp-Source: AGHT+IH7PQQbfmJgJD7GH8Vm6B00ERalcVbwZY3ujfWQ/Sk8USaPy2rNxpFq+BU/9m6gePXLTLpqZQ==
X-Received: by 2002:a17:907:7b8a:b0:afa:f1:ff98 with SMTP id a640c23a62f3a-afe2953d368mr1503376866b.37.1756212570825;
        Tue, 26 Aug 2025 05:49:30 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afe49310dc1sm771790266b.86.2025.08.26.05.49.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 26 Aug 2025 05:49:30 -0700 (PDT)
Date: Tue, 26 Aug 2025 12:49:29 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	linux-mm@kvack.org, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/khugepaged: fix the address passed to notifier on
 testing young
Message-ID: <20250826124929.w5zll53rzgdfok3u@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250822063318.11644-1-richard.weiyang@gmail.com>
 <0a2004c2-76e7-43ea-be47-b6c957e0fc14@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a2004c2-76e7-43ea-be47-b6c957e0fc14@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: C43B1140005
X-Stat-Signature: 7d437gqygepechzyh5ozqnmu1basboco
X-HE-Tag: 1756212572-882149
X-HE-Meta: U2FsdGVkX19L9g0km5v4KsWvXVnTgy0gfu+PNtqEP6jHz9p6/Tj4fI+GsrVZnxyWjnGan1hnCbIOZ+OiAnKvhVzbrWM8C5DBuAlkmgBnGoV19VKiAAwcdP0R1iB2FksSNCpABT0nKkoK7c5YW/INTNpRalh0RoEbt1uK3OQ4+UP3TbyxDYcf0odchDmM7lD5gSieRs4qighEXMHzDFbPKtAyhLFXKc6ME3cw+Ti9bFr0MfwZcVJrIDfVaPVt8TN/CvmW7tu+4FUmyHav8qyBzP/Hvb+4FMUc5+5R0Kcm4R5Xjqn0k1Gr1BXOo7fTNNoUaFgTmZhkT8EQk8QB1FjMnpYZaBiIf1mt5cykofFyNgpk/hNf3D2yAFdP7HJy/0P+tQAOM8EPBiI+AE9z+5auONg0sYbhjhUgKK0DRM6JDjAmfl9/+13yGKEV7lvKFxO+q8EUClvFe3c1oQECqjEiXUNheSiBTtdp/PeGHCiXFhJKFGaQbKPj3FaLUUAA8mv9IuyJRpDY0wQwQ+u/XA8EY1Y8k59a/mlR7cqjgIhJwphCKzY8zDl4DvhvW8IFEllw+6ShwHSK3ond66WaDu58viBLOAwndbwuJydDS2A+oaOW40Y76TWxmV5xf8JEEuHrwtUvoWWzQSc3L0Sji9GxqTu87cZy2tdp8l6TU+hHeuzEfTRrIIq9/hYtcbtZgKWRfATuik9MfA/dXP3h4+fSUjp/M+hxVL3TILJnD7bNfBcAsjp+jltcbgUpRoTzj2SXeGRlGsiNTJ4LqRpjEqOJpN1GLYNn6J8BQnRLh8+BGrpoCta4XRuo3NZYCaQ0wx32F2aTPWSvgtb+IUKgBXKdmVhXS8d4BQT4uUjvITO4PcFzsOjflrUUkh6VLZxERpnP73xm0THUM1Ob7NeYqXbXBVrC4aUaJ0rxjCcWhM08SvXYJMslE4cM/tcJFZXc6z/IezbXT0GBijevTkrPdNU
 Nu/7x5JD
 2FCaN2qricGhgeaAiMaaST2gDKFxAYByElt9MwY7GGByv/ilSwIXcjdcIUTpBXQ9eDzMZTJ8OdGiHq3Fkpwoqw2pPqi+dp/Ts1MmCFD+ntOBCmONpXY53BrO0ahdRj311Bppj4dWiG2PwpeLrQHQxdrZWNns/AVnvAt0adooC00OWvUHr8Xq9JG+Hdi4zOe89xcyHi+djZ04Vfs0SBqQUNP3X5QWmXX/fBSe80PgW5THd04SpCJvBoKfAJZoFVkLkzOQzWKOi+MvTBDayV7pRPpsX4RJvGtuKW8fa8SXGe7EA3mmr+MJTrutX4BiSYDRF3dSvlHRRYx/3eyrfOmU/yLg3M/UaKdARs2ShFQ8OGIoliOGIj9mtLTw4bG+DXXzEErOSD4wkcjUEpm6vFZm+qSwJphUKhlRfLayHryPQV0HJ9gSBFv8c3EyQVo6tndeTQISRSZymAJsB0WzKDfyqT26Xb8srkNKnvoiyzuCPg8iaWRZAMs+Gy+UxaaWPQX2kFKvhy7cIv66zijAmnSzYi2vtCrElqQ1HF1Zaj2lfZnMdhURAvc+ySZfaygbt0FowEBfMh9K0sLrsDdn7DkebPjwCPAHHCnObhqrhyvp+/gXGgMTLOzLLkqXQVfXPqUJFYh0q7t6CMJJ8/11ulFTZ8ksqJmRxI99irIuioqX6LfPXCfGnR9nCLhRNgPqGbOGjDa3vKofWONXVvhxzft49cWc8akuJcC+Osqu+9iyIsDEfpyGlVt/5qa0U+Lj+XSVRfsZlU4RUILl7WrjQuQoOKhwJSz/D0G0T5+Xs1wVdTmFcUwf0dugt4tF7iTCoX8+OwPc84Cj2T5I6CBhocoU4EXlnlhGo0eX732UKtqEHC3/W7QCUqRethZoJvg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 10:53:45AM +0200, David Hildenbrand wrote:
>On 22.08.25 08:33, Wei Yang wrote:
>> Commit 8ee53820edfd ("thp: mmu_notifier_test_young") introduced
>> mmu_notifier_test_young(), but we should pass the address need to test.
>
>... "but we are passing the wrong address".
>
>> In xxx_scan_pmd(), the actual iteration address is "_address" not
>> "address". We seem to misuse the variable on the very beginning.
>> 
>> Change it to the right one.
>> 
>> Fixes: 8ee53820edfd ("thp: mmu_notifier_test_young")
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
>> Cc: Nico Pache <npache@redhat.com>
>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>> Cc: Dev Jain <dev.jain@arm.com>
>> Cc: Barry Song <baohua@kernel.org>
>> CC: <stable@vger.kernel.org>
>> 
>> ---
>> The original commit 8ee53820edfd is at 2011.
>> Then the code is moved to khugepaged.c in commit b46e756f5e470 ("thp:
>> extract khugepaged from mm/huge_memory.c") in 2022.
>> ---
>>   mm/khugepaged.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 24e18a7f8a93..b000942250d1 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -1418,7 +1418,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>>   		if (cc->is_khugepaged &&
>>   		    (pte_young(pteval) || folio_test_young(folio) ||
>>   		     folio_test_referenced(folio) || mmu_notifier_test_young(vma->vm_mm,
>> -								     address)))
>> +								     _address)))
>
>Please just put that into a single line, that's a perfectly reasonable case
>to exceed 80 chars.
>
>
>Acked-by: David Hildenbrand <david@redhat.com>

Thanks.

@Andrew

Would you mind adjust the changelog and put it into one line?

>
>>   			referenced++;
>>   	}
>>   	if (!writable) {
>
>Maybe, just maybe, it's because of *horrible* variable naming.
>
>Can someone please send a cleanup to rename address -> pmd_addr and
>_address -> pte_addr or sth like that?
>
>pretty much any naming is better than this.
>
>-- 
>Cheers
>
>David / dhildenb

-- 
Wei Yang
Help you, Help me

