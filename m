Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABA84CA0EFC
	for <linux-mm@archiver.kernel.org>; Sat, 23 Aug 2025 01:32:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CF5E6B009C; Fri, 22 Aug 2025 21:32:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 580366B009D; Fri, 22 Aug 2025 21:32:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4969B6B009E; Fri, 22 Aug 2025 21:32:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 34E006B009C
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 21:32:34 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D9E6A138D6A
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 01:32:33 +0000 (UTC)
X-FDA: 83806297386.17.DFE804A
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf16.hostedemail.com (Postfix) with ESMTP id D4046180003
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 01:32:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Kw5rXZ6G;
	spf=pass (imf16.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755912751;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EJZrbfzvth3UC+HZU+WUnSg75LyO0CB51/ryaxjmXYY=;
	b=BMpZulwPtQAsshePGmeRw684xqJAHUfrF/nCXdNLLi+6chug41oSR1K6ZsqwvwM5I/yxUl
	DTxobwIelBXGe+KZ1Qje9IZVFKmRJZmclJrYzij7wT9Mi0GAqUjTslsOizWpseXXvq3KMO
	v+rDk4f7FSGWdGekO47OLYDNMMKlB6o=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Kw5rXZ6G;
	spf=pass (imf16.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755912751; a=rsa-sha256;
	cv=none;
	b=zW4QzY04cmEhFPHo3ddbKCNBtsvQSwM83iWYeps02n3DXaW5Bz/KxOZ2iqgkiXeX9t7Ajg
	x8Si+Im3NGurqVjerNmxArSlF+ZTlQFwHheCzIKN5axu4B1EBaTtY5FBLoxINYbsclziye
	aPhAPY87A+tVChGvSE215c7JYGteDno=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6188b5ad4f0so3723673a12.0
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 18:32:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755912750; x=1756517550; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EJZrbfzvth3UC+HZU+WUnSg75LyO0CB51/ryaxjmXYY=;
        b=Kw5rXZ6GAzxkyNzBuTEC+5PMDzXzFlSsvt58ckB+lcQIo8Btpj8aO9oGibnS/GmQnL
         JKshexQi6gj0X2GMCSon79MJqoDiYRSPNpirSIPGodganWl82cePa8yrWvH7J4v0H/YA
         tr622VaEueqckOg4S0d/ZnIwU3qKQqnPSA10ysLC5iAHQMRFu25RbpNsj3JyE4HhapWZ
         r/Wy7cnWBq4JtXIdZ51UUJFv04c6LqNxaTHt8TQoaV3oLME2gvBc5CPXJiGzTeEmoiMk
         Z7IGR15VzIMyPFFztNEeTAnKfVuDLvIiWmRR8Fen8fNNdOPoJvct7doD1G6vNVFR70Sx
         AT9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755912750; x=1756517550;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EJZrbfzvth3UC+HZU+WUnSg75LyO0CB51/ryaxjmXYY=;
        b=Y6bB4qHlu8DkTaFn/ZAPBkhP7AmimMMb+itS1zPWWpksSaUtr9Bai1thMGPS6yCP47
         6oSlv6hQQrjs/jtdGyFnqQ6Efic39ZVAmR+SvU9uy9SBdaBr+VzIUv9oVT1/2cdGXuZJ
         Nqs92XSbUQBpZxDhj3n+SkiGUti9u7huO5AFXSe0Labrl+2UIcV+kt/FsBGeUIXHW9jc
         8Kx1lA66QsgA284QZsFYsEqIw5BWk02VPmVSrBesRo2k4RpytLXMwSg+3kDUd+3FKAi1
         FglyCD9l76tUvTXVBQ9VQN0Ko/WR79ZnYdXl0U2K5jP2lmE++wa4jnkyobcZBkh+O/W/
         LD/w==
X-Forwarded-Encrypted: i=1; AJvYcCXL8ZV7OQybhozgBw2kw6txAMsQTJHsl0NaeyRrxVU7Eg2e2LIfp9+2hu9LPz+KgEWkeIBN079TLg==@kvack.org
X-Gm-Message-State: AOJu0YxPuEfTmeh0Qd+Z4I6RI0x0rWcYab0ublJ5d7NOJNHLkPZjow/H
	fgjQFQbT13rexdprdBiPPF/F3tuRP1BGFSfN3HLonsRcMjvFskdEsuji
X-Gm-Gg: ASbGncvWi61hjnAAlao0/LnDa9z1VPgEUPtbCWndlUUFRtjEaofdyQ0kAoqag5L3omJ
	aeykpRGBgsLtXek55I6buzzu+QUtLJTxJfYl7yPEYfify4hBvOr8Jxvbo7kJdpN87emZnYzVJF5
	X/sL/+q4IuqvCX5Q9V0+pD3R8qOV8EDNge4dwkcMUudcUgDVqPChMbVgHfwWU35GRApsjPhfIXd
	Ln7HmwwrG3IIKXE+QC068DtwxqmxcL8rCDc4YE4nfQR2BZ8WV4PyMMs79TEhE9IVkIEiBySoSw3
	VYxVWsSqWH3OTl/JxuKNSxce+0aYlYwPwtc6DT4MTuy0gCf0z8KwhNJlFBQNGlb53dqsszq8+4R
	uLeD8NvXtJIMcIIgBoGI910njmdW7SuhYLqde
X-Google-Smtp-Source: AGHT+IFrUheQ0C0VLXzuSQMa42TWZMqpsBCr2Jh2MxTjESBmMtPLtQ5Hp5XdppMyJWgBmT5t2kHZMg==
X-Received: by 2002:a05:6402:a0c5:b0:618:1706:d48b with SMTP id 4fb4d7f45d1cf-61c1b714110mr3683563a12.20.1755912750201;
        Fri, 22 Aug 2025 18:32:30 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61c312c4cdesm770186a12.23.2025.08.22.18.32.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 22 Aug 2025 18:32:29 -0700 (PDT)
Date: Sat, 23 Aug 2025 01:32:28 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Dev Jain <dev.jain@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, baohua@kernel.org, linux-mm@kvack.org,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/khugepaged: fix the address passed to notifier on
 testing young
Message-ID: <20250823013228.5gybt5tuaygyunze@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250822063318.11644-1-richard.weiyang@gmail.com>
 <a68e4e65-883a-4625-bebf-da4569ccda7c@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a68e4e65-883a-4625-bebf-da4569ccda7c@arm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D4046180003
X-Stat-Signature: c344wqy7t7tpgcgp3zuwhc8wicqp4gt8
X-Rspam-User: 
X-HE-Tag: 1755912751-566272
X-HE-Meta: U2FsdGVkX1/G5e6M6mmXBDKOeqVxGGod6fNZ+O0ofhVEH/Z3BKaIHpwxir2prX7KTIzQMzuP84oRoPr5Wu3Hl1ZcvuKabhuc9DMlDOjgG8GM3pvsnQVvwob9R5794UyX/nz+5rtPBZ4v8Se7H8xxyEuGu1J9/KavvRl5nbzGjqMOgCuJMLk8qIM6WzVjM1sZ1sBX3t+CVIWMtAF0UJKXk+GbzpnKDvRhdg3XG+xAlQTKuz9A6BzuS4D0n2ogpT7t/ePZtapZ+BVdiOnNrVj42DRjgDPqTuDTvluqkRausFSxh19cBzf8ggcvR3q1ikIVOx7FLEFuen37IVdXoPH/onlWMRLzxzG8yXXW9mhgLF0diKKdYfLjqaj/HxLSNt0w+UaI/KoaLKGqXZ5KRJAw+x5Kj8qsJVxneymEK86yLBvocq8ssQAJx4d+Ik1XirpaWm6A6SwSd6dXTNW2mfVUfu+SgRjYD0xKJweTBPdnTKsGZysm9bwQ+mB/60tb8izQ2QvnLyQJgx0EdyIFWNra/MEB9FToeDJlSyCFgThjXyZPQ3TF7z44036d2VF8hYtzBtJrvh8BXFX/HR+NFcrY/Bl3LkgmMSaL9T/ob7LurMn8GXXBKI5x1BFAfdOyv1vtZWCbqleox0k1lUHuW5MaJXdzsOhHQBoG9sSclz6LktrijOZsz93FDifuqKE0npa3zxLoBjmcVhi+HgAcZG5XCxSFWAQCiEEgIH79xYWAxLUdeKixUUJIXHIi+WiDLBajYlcCBEAglaPnOMKvKLkrJMyV1SfqMY81O3VPetNZbqTMKsMUY5sqAb77fLtGsla3pyIUGZJqWNl6yXoDAobW8iw/9SDa6/oLYU/bWAxIj0WZvzxAlL/JRK7OE6qU1UVVQVmrASCjycTlSXswWZWwKpCIevHXXs4oS0sKRwaTqIxJATE2F0A0w8vA91QYBGztq+oHPVoz5CztCR31Q8t
 ZX1jB29b
 HsQFXtHZCtbUU+9rUOiervOWc1NZ+B7ML9YDcpfCCYHfdmJWwWD32sU0uNsSvvO8Naam+05ks0zLooGtp1il9czL1LJrlqg4GHLzLA6kWwrEy+WZZC2zQ0I8Tf2yBJTW2nLivmiy/1yeGBH/ESg6FL73Qjj4xZigWugyIQisSHuAC+kjd1FH6F8B7MQJxWADksqgslFKLUVWHjH7G54mUsKWya0cd6uAiXVispBASIhGGhWqvXTz8YWfqxGDxGCwpQUYY7x+Rxb4SDXd78s3c4s/IRnrCiEWJEAUKkXKxLTlETNJ0LTVSPOCIuz6Gil2pA/tTkh6hMPnNUoXaUI7Q3AbfTo0rTbmGModzWMTWp7yNzjuuk3BjfU0zGjmfJ4URfCqHjsXOp01W/1ANB8iUAStSaLYkIVv8vNrYJpAzbHlrgybHkf89xEVhuYiu8S9ZaeWqrhZMdMJ048GV9owN6vYSRHXkNXRjsLd3bBSjgt/b7okK0x7zECyWQJn0UR1Ci7IQROMhaTouwDQwF0c5dKS7+RJdfM3ZB1URiAcugQP7z4xfIrMtUDlP9N6F0xui0/nizr98ZV7oEF/Qxq54HdK8sqVDMFe9/z24QGNKrir+MGgeI7rRkwHKR1/7TcJZ3wis8IfI3mMncqKg1Z67kJZ+CNz+5H05zPwP2R1sROR8iVqjPBfmRa7gyhKvANW8AkOYBb0QKy4zk7GvgMFUKGzE0P2KlCuxAD4tHSkk2e4h3NJ/OJ0KWdozmE77PWI+V+wd5rsByNzRA73o6c+EZEUFz6Ptoy1weATBOjJEaV30chTssuaZpsprofYLUq34sdUTmLLLFqb66i0CVJANbJucHxpIgMaAFBpL/JzAjOgo2Dxto7uwiQ37LYjBZXDQRlcvAxkVceJeADNWkauIEQ8NAWGWRGCkxi41NM0EGD8j2Tsuf9J024hXBhI1qQ/eFidR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 22, 2025 at 01:04:51PM +0530, Dev Jain wrote:
>
>On 22/08/25 12:03 pm, Wei Yang wrote:
>> Commit 8ee53820edfd ("thp: mmu_notifier_test_young") introduced
>> mmu_notifier_test_young(), but we should pass the address need to test.
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
>>               if (cc->is_khugepaged &&
>>                   (pte_young(pteval) || folio_test_young(folio) ||
>>                    folio_test_referenced(folio) || mmu_notifier_test_young(vma->vm_mm,
>> -                                                                  address)))
>> +                                                                  _address)))
>>                       referenced++;
>>       }
>>       if (!writable) {
>
>Wow, I have gone through this code so many times and never noticed this.
>

Yeah, also I am surprised when noticing it.


-- 
Wei Yang
Help you, Help me

