Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38034CAC5B0
	for <linux-mm@archiver.kernel.org>; Sun,  5 Oct 2025 01:05:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 165828E0003; Sat,  4 Oct 2025 21:05:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 115DB8E0002; Sat,  4 Oct 2025 21:05:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02B718E0003; Sat,  4 Oct 2025 21:05:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E6E838E0002
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 21:05:16 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5856A13A3E8
	for <linux-mm@kvack.org>; Sun,  5 Oct 2025 01:05:16 +0000 (UTC)
X-FDA: 83962267032.29.7EDE384
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf14.hostedemail.com (Postfix) with ESMTP id 53F4F100004
	for <linux-mm@kvack.org>; Sun,  5 Oct 2025 01:05:14 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DN7pemEO;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759626314;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UxmchDTPhZsqpU6gIxr0BxrKIvUH4UuMs0rK+gl2l/I=;
	b=ucijDSkLeS64yFLJlMVFY7K/pXyBKWWNE+rBz+MNPGk48iMjCQ0BPwqtx6I6dn5J1O9c9x
	EYv7yixbFKog4l4/t5rN4ABOfbsV/l8IZZC6nYXKm1/02E9VqEUp1eAQt+i7f1opFLSRpH
	pueGHXhSqjlMGyZogyXxyGueXR96iuU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759626314; a=rsa-sha256;
	cv=none;
	b=1mLl495UE0sVlwF+B2JVwgAh5CGSBs8JvsxOMt14lOfw4VGRTEpxEsgjd2v5nJRrR5syxO
	Pjuz2ldor21Q+U9K25EOZOmnDXuFQQ7N1TUaBoiTU7m2GF3lK/zJqQtC8sBn75SpEatjr9
	5eHdlTsfVsdhs6qS4H2YeuC+RabkgEE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DN7pemEO;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b463f986f80so417011866b.2
        for <linux-mm@kvack.org>; Sat, 04 Oct 2025 18:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759626313; x=1760231113; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UxmchDTPhZsqpU6gIxr0BxrKIvUH4UuMs0rK+gl2l/I=;
        b=DN7pemEOzonmgKqGHgjpFjuymkIngCQxOOKaJZHgwi4S8aa4idM1kFYGFkkc1jqvcd
         jgHuHFN1x2jO2Kc6YMg0z7nO74OCKse06obIbAeiwkWW8LDHmOnCeFX6xKxlv2/LEJGB
         tIxpSyhV7lVgveJVq/ku8/mUx6Z1D6g/Tax75MjT8i4wiTKVdq5mN3XtBoFJPkGe/YRd
         bbnYR2Nb8wDD0GrVbvAnA3kpQocInWErAo7U5yyXuHCTr+LoD5yfrN19AufvZaSDQLGG
         WS+yFV404f9Ggi59HfDpmn987KT+pJIIrdRnguyqrg55SZV7NSNSB5Bx1zjs2zFtENI6
         J0oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759626313; x=1760231113;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UxmchDTPhZsqpU6gIxr0BxrKIvUH4UuMs0rK+gl2l/I=;
        b=Ab3+9Sz8MBvBtLFP82sRlE8v+N3Stpbk+Nx/k3NQVoAuYWlcECv3835S0M5sTv27NM
         7flvwdQJe4oxHU5XPsIN1e3XwkUJTJERG9kiSGXwpFou6me8kgjQhGJQlREE/pTlVDYI
         N4cCkAojr9g46AIiKflvP7QU1uFOGniNZK7urayTsDKyjSOoOgrjgGnxtInjn17ygZof
         Pg7MLQbEONi9EWcWJzNu8vuHaeTF0bEYf/yJ8iqfieMD2T06kEzrTj5Z++00DCwvuCa4
         eIVcdylKmkRzz+a4ze2XTZBnVuZspQE525ams+mfDyyn/umkkAQJzcS6DFq8yo6Jm/Om
         Lt+Q==
X-Forwarded-Encrypted: i=1; AJvYcCUFgek5UyS7FlkxMTAsuOOlN7VgkxWfGqvaHMWJxTeAsHbivHt+E9/xBqOhsNaSIm1D5gYNi6qigQ==@kvack.org
X-Gm-Message-State: AOJu0YzmWoedfHF21ZYzF36JFPi2CnJ29imKqoj0/6HZaM5ZSGWi8dx2
	Ha0lwFq3Ub9Vk98vVQL+dFDiyjrNC6JtPuNzn9QVC2MHaqaJIUp09P+X
X-Gm-Gg: ASbGnctwe4gb+UM3/g3yZ++5tLAh/oAawzCFNtI6CU0pFqPpp0/higenMoXoWIsief+
	nLtKsd+GxJN9oV+1/VFBpYNX47EtC8lVZg8qT0wBLZQD62moIC2r1yIQg4u4O7KTz4EdoLTLhPl
	WPLbW4Q/2bjfqkvNKqdXo04GWIcGioRkdqTM4ukYyPItEJi+GUpkkmas6QqUoxxZjrpKy3dK9tp
	O2V3J7b5jqT7GcGs/pl8TXYoA6XkJigFY0fCa3e44roQxUWCtcb1bEcAD8gky6yWZKRA4CNFD/9
	V1DaUTqiNwAhbzZi1cAabHhPkvCyXf8+78q0/BHSUEujj89CbpiBynuSIolLx0EK+DEOt3kgiDJ
	TKh4Wua6NXiwwDK7bw00oqcv+SDiJm5L9MPFJQFha2FCon09TNHhGxW+rUvu2Aeljq6Y=
X-Google-Smtp-Source: AGHT+IEJ+DV6wCXDb2a3k9uAeEgMCr1cVjIoxxlb4UYBMuoIs2Zd0lJV3rJ10CH8141p7yP2iS38cA==
X-Received: by 2002:a17:907:2da6:b0:b2b:59b5:ae38 with SMTP id a640c23a62f3a-b49c2761ad2mr1100209266b.40.1759626312428;
        Sat, 04 Oct 2025 18:05:12 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b486970a60dsm794414466b.63.2025.10.04.18.05.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 04 Oct 2025 18:05:11 -0700 (PDT)
Date: Sun, 5 Oct 2025 01:05:11 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, baohua@kernel.org,
	baolin.wang@linux.alibaba.com, dev.jain@arm.com, hughd@google.com,
	ioworker0@gmail.com, kirill@shutemov.name,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	mpenttil@redhat.com, npache@redhat.com, ryan.roberts@arm.com,
	ziy@nvidia.com
Subject: Re: [PATCH mm-new v2 1/1] mm/khugepaged: abort collapse scan on
 non-swap entries
Message-ID: <20251005010511.ysek2nqojebqngf3@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251001032251.85888-1-lance.yang@linux.dev>
 <20251001085425.5iq2mgfom6sqkbbx@master>
 <1d09acbf-ccc9-4f06-9392-669c98e34661@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d09acbf-ccc9-4f06-9392-669c98e34661@linux.dev>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 53F4F100004
X-Stat-Signature: nu9sscxjhqias5zrsa7msb9tbyj7umiz
X-Rspam-User: 
X-HE-Tag: 1759626314-148619
X-HE-Meta: U2FsdGVkX190WIl0u6K1+4YRRq4FBNaxGg5rNk9AHulgFWqmbEqIJQNgoxd9oWhT4bUxkr2Daj5W22f2IEaHrXMZaNed0fEXyGUuHLRBROG6mY1WiMAhaV5KXOBMezqmmwyF1AmzaM/6MXiuOqfhs+GQWcOcNDHysZsWsdQ5kzBDI1eREAVOlibC32n1Epq7g14C3vh8iOihnw86M5iZzvzDU9W7wYoRwYOKjAiABivubBVuOxNfY7VzO3Pa+evuIjoofYT3pPZUvj3BGmdhKIJfHQFUguEsINTUiq8p5uwkG9Alsw1Zi915hJxU00l8ZqYCChNgG2Tl7JVpzpac09j26uTvJ+LOBAFVhVQyXWQ06iL1VzK60wDhlGVqZbEUfqeoi1HIOka92FbqULrkSBl7/gC+2xwo+FRB+XCL6JwGFxf8in4t6AYflRbo2I26VkjIvZfuqyYy/hIRfF6dlRxpWNLHyBzUANkbK5nWjMwoLdVvbMOeod8mk+a3fWMDEZVoqfXQI7zWipOZEG5NyMDX/a51j6BBZhAu0fLGvCkDU3/2nxlCZv+ht3wDy11SyLNkZN2rQQG1aoFhNdMRt8+wvMo0JLCDeVNOWE+OhyCkgd9TQpCDPXea4xRWF+2geNTnaSVZubbBoGVIbZmqtVDr8k0AW9E4s+H1HiKQUvyDjPZ0+eHZEBkwhNDozEeophpT8I/EsTU6eK4pf7Yl+2kF4B4oQJ6WKd+qdJbkuv+CkImDyL3iDgpmeU1xoaInaHkEdRWmGpeDXT+qHesV7E7yHlltBJGcY8mwpm6SQXYb7hCR79POxC8rslv8Qe6wUIIrm7hEAXEdiG8NKwot5XlOHfBT08UMRZq8i0hngqCqK09jxA4vJv4f+VPk2QiIMKzlmD4JHug3ph9JsCrbcWJ2VjemV1l7O9QQvkhjmWMTMA04+zmQBk6l0vcUfDDitZU4xRGjrxhJUSGjaZz
 pXIYp7r1
 orhK9f+jdv338YEGiIZTM0iFBTEJc0lxezsC1aoswuExoZRiFoqqbqz6khNoIr6K5KpIsX3WZtjcpT11juM/R6Q6Cyn/lwvjiMP1W69fo2nZ/JqoLOd3GHA1DFEjWz0jlC/sbqLYfUpj4vNrFh0J7JCfOxCk6OQJnISDgIqsLOKvCz1lG4jiYORUVNX5YjrBseK3JO4HdGl0/73ZIMHqDux4lH9Aqxp+E/7PYX0yZn1lfck8CBKuuZNGbrsygER4HEXphNOyqKbXrvh1m2aI8KGQZOt/W2cMICmNO5QSqjKttUDQ0kdApVQ7+HmNQZpYli7km/nD3I72BZQpSV660Ozid2XaNoyr7SpCBGWhHKH7XVZG9FZFxLcjx/6bPG9XKoLNgQbOHvGizc8AKWcA7caOuIituYPFYMaJwTEnRUHnz93CZQMXFA3ls30c67Gd5gnfkBNznQU2ZSEmji44bzaBI69LWFIVuIFUkrlPoG/Thc5z+rOsWPfZ6q9N3rlqfi6U6O0MQGD8zkNdx06iUmvg587aR27B8xi54GZJI0bSnPhFrG3piDrvwxOq4pUux+eXjx6PhkeGiv/Up6xdyd5fkDUjSSjxpuB+H2pnUJOTqAVcK0dV2EiflWlXpfA8lTYGqpNgCTsfJZR1TxTznpI3Kui7pUzczqcXyPQe24y3w84E4pS80mHYqScMqjlnns1JZ7e6Z1Fn3Ue1pqOPF5Cb4WA3fcVA10wo3pSBw9vsUtDe6NGgZQ/OaGA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 01, 2025 at 06:05:57PM +0800, Lance Yang wrote:
>
>
>On 2025/10/1 16:54, Wei Yang wrote:
>> On Wed, Oct 01, 2025 at 11:22:51AM +0800, Lance Yang wrote:
>> > From: Lance Yang <lance.yang@linux.dev>
>> > 
>> > Currently, special non-swap entries (like migration, hwpoison, or PTE
>> > markers) are not caught early in hpage_collapse_scan_pmd(), leading to
>> > failures deep in the swap-in logic.
>> > 
>> > hpage_collapse_scan_pmd()
>> > `- collapse_huge_page()
>> >      `- __collapse_huge_page_swapin() -> fails!
>> > 
>> > As David suggested[1], this patch skips any such non-swap entries
>> > early. If any one is found, the scan is aborted immediately with the
>> > SCAN_PTE_NON_PRESENT result, as Lorenzo suggested[2], avoiding wasted
>> > work.
>> > 
>> > [1] https://lore.kernel.org/linux-mm/7840f68e-7580-42cb-a7c8-1ba64fd6df69@redhat.com
>> > [2] https://lore.kernel.org/linux-mm/7df49fe7-c6b7-426a-8680-dcd55219c8bd@lucifer.local
>> > 
>> > Suggested-by: David Hildenbrand <david@redhat.com>
>> > Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> > Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> > ---
>> > v1 -> v2:
>> > - Skip all non-present entries except swap entries (per David) thanks!
>> > - https://lore.kernel.org/linux-mm/20250924100207.28332-1-lance.yang@linux.dev/
>> > 
>> > mm/khugepaged.c | 32 ++++++++++++++++++--------------
>> > 1 file changed, 18 insertions(+), 14 deletions(-)
>> > 
>> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> > index 7ab2d1a42df3..d0957648db19 100644
>> > --- a/mm/khugepaged.c
>> > +++ b/mm/khugepaged.c
>> > @@ -1284,7 +1284,23 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>> > 	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
>> > 	     _pte++, addr += PAGE_SIZE) {
>> > 		pte_t pteval = ptep_get(_pte);
>> > -		if (is_swap_pte(pteval)) {
>> 
>> It looks is_swap_pte() is mis-leading?
>
>Hmm.. not to me, IMO. is_swap_pte() just means:
>
>!pte_none(pte) && !pte_present(pte)
>

Maybe it has some reason.

I took another look into __collapse_huge_page_swapin(), which just check
is_swap_pte() before do_swap_page().

We have filtered non-swap entries in hpage_collapse_scan_pmd(), but we drop
mmap lock before isolation. This looks we may have a chance to get non-swap
entry.

Do you think it is reasonable to add a non_swap_entry() check before
do_swap_page()?

-- 
Wei Yang
Help you, Help me

