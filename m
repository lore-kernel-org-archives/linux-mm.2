Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8323CA0EC4
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 21:28:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 793258E00A3; Mon, 11 Aug 2025 17:28:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76B188E0091; Mon, 11 Aug 2025 17:28:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 680B08E00A3; Mon, 11 Aug 2025 17:28:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 51DCB8E0091
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 17:28:07 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 036BE1372ED
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 21:28:06 +0000 (UTC)
X-FDA: 83765764614.30.DDDC3EA
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf05.hostedemail.com (Postfix) with ESMTP id ED00E100009
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 21:28:04 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eDcwTSCe;
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754947685;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u7emz6ROM15eXVZD/JHmzk6WH3TEb4rlVhorWWEnTJU=;
	b=2/NOBVCE/lfkmh0xM65JzzIkVaZxpsRmTrsL5P39oRaov9FIvibZAEk3QidPmKsoR0T1QR
	RctjhjXuLvJAbgSwL3ffzjY6zVd+F3vYlesmogBNqOhPKAckN7dCsj6cYTG/Tshrgw+cyh
	nh0h+faXHqM+fBXxS0qmokc1RnFOf+k=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eDcwTSCe;
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754947685; a=rsa-sha256;
	cv=none;
	b=QPg9QISRnGpK2a1eW9CaYMerOVVwRU93oLukFUERwckAKedD4eX/9lecMUtZQaCl4p0/bs
	XJhwEjXqFpt7CafQmrZqvglmxlGnfZ26U6YjDgYEbqTD51kxEsVTl3bZOYhLh/ZUNAea1G
	3Ghy9smQCGQ1Ql0F2Xoj6G8TodIsj1s=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-af9618282a5so929562666b.2
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 14:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754947683; x=1755552483; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u7emz6ROM15eXVZD/JHmzk6WH3TEb4rlVhorWWEnTJU=;
        b=eDcwTSCebK//TRJqcsHiIMbgceAXf40cHfi6/bHjogowtB+Y1Sn7By/U02QPju5SJH
         YLxrX5BD7nmmeMEXym3g6bvsmuXX2TC0rQGOxtQal0tXolwyhMIRhBCySeAsiINfjMTO
         ZX7B5u2raHO+8F6ctHNx40BXVd2qNKQpBu/EeGCKrkdLLFqHwtSq/Wb9BUajSsRxI+Zb
         ywCY8epvuN8Lp6EHclvDj3cGWyOtOIOTP+B/rOvAcXxuaJB+nTk5nVreiAJoDuV0GEav
         V36FBybZWuB20yP9KXF5UJzfGAppf/LMz0Le3+sp32uZnoFABojc2+NOsU3vP6ypV0B9
         vB0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754947683; x=1755552483;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=u7emz6ROM15eXVZD/JHmzk6WH3TEb4rlVhorWWEnTJU=;
        b=cY2NbfMpqFLIGlmAtKamAyTQJ0MfKGXDetzaBDSWwjHCNpy+5ChWgIKrmx8qKBs5fP
         W2d++3xtB1+VbAf6W8/SB8YRWQhql3JAAN95lUzk6mQYq60yHpjJX9u6pYARRWec5AIv
         Rs3WI0QAPsvyZYR60rp52REAHpkpQwDro4ZSGYoSlje1jJ7bG2j9D+ZMYkc4N+S+zU4j
         aoZwNCR+oXBzN7dmDQ7pv3GhYreT+GfeTZ2HYLPfhPjyzqDDfd23hEX/hYlYQhB6e6L4
         Cr7npN8+Ecsqs9ymhgkr4B7vuF4uxT+6XIO09VDa8cCCByu/CuLno8Ud72ElkUAVn8EJ
         ibLg==
X-Forwarded-Encrypted: i=1; AJvYcCWQsGkSMBn5Z9q1XHEtuGOUW6CYaXbqfweb9xPskdjUki86EtP9nx2fzog7kAAwXtflfU3GQM/10A==@kvack.org
X-Gm-Message-State: AOJu0YyRKOrOA3/S9H6moxvZ/qIhMJ5j9CQZDEYXf9rDd8P6+KXvY85s
	RkKTOc7QM5Rpf2B0ZErxPq1v6JLekpb1iPNvq93SOmvLkfKAXhdjGkLz
X-Gm-Gg: ASbGncsdaqDXTkTt1Uxrhq1d7xo4YBFVlsR15hB128Q8m4ThUVw+FxTaiDxY1lbYzt8
	lNJWaNE9wC713IciEB/rcdArsIANPtDq9XoEduLzOKlIy3hUMg68BRHUGTIHtfc+OcDjv+D5mFe
	nIcoV5qhTjIV+m+t9ASMC0MeRbngoKmzfaGwdN66o0d/2BT8E74Jb8YtXa8jBDvpv9s1z2ZTljq
	mFYCy4ofv3fdpMc6axO5T6mciMKrhypyYPQKMNg6U6oUo+d3hC2Alox4o9ZVrYLpKwNrihOuJYx
	gdMjbjHLdHENW+MoTv62unx3YUN68cwDF+A007LHT+iM0teE6R3fUWL3QHhDzvxSCIFNlzGmlU1
	bC7ewmZrcS59DWenqPqk3EQ==
X-Google-Smtp-Source: AGHT+IEJ09ZPMSOGoqTX4r3ubN8xEk05FcZvRutxM05qzde970yiia9Wthp2LHeb/ElEnlKIxxnWBw==
X-Received: by 2002:a17:906:f5a5:b0:ae3:f903:e41 with SMTP id a640c23a62f3a-afa1e152edamr90815566b.54.1754947682935;
        Mon, 11 Aug 2025 14:28:02 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91a0a3792sm2073582166b.50.2025.08.11.14.28.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Aug 2025 14:28:02 -0700 (PDT)
Date: Mon, 11 Aug 2025 21:28:02 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, wang lian <lianux.mm@gmail.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 2/3] selftests/mm: add check_folio_orders() helper.
Message-ID: <20250811212802.gsvbeqmo62v4tqly@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250808190144.797076-1-ziy@nvidia.com>
 <20250808190144.797076-3-ziy@nvidia.com>
 <20250809201836.jegaanplfcjak44f@master>
 <B13F65A9-B001-4494-A060-23D95055553F@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B13F65A9-B001-4494-A060-23D95055553F@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: 88qtyb8a1bhp5bqhdqyt44zgnp1epeyk
X-Rspam-User: 
X-Rspamd-Queue-Id: ED00E100009
X-Rspamd-Server: rspam05
X-HE-Tag: 1754947684-334981
X-HE-Meta: U2FsdGVkX18AapihaRWhHdhOxq+8gE8L1n49hOzWlN4ullTTTUzVKNVcCGX1xS4c7pM1o7hHSx0WLgMBpJk5cdVeUKHQJfxl1jT+DZy4cUp0MVKKPIyFuhhyv5G2FldKBqwaydPJS02f5doJ1dWnwcFLwy+8HbfKUtfl9AmW5VhFudX3RJh5S0uRpXZMyWgPXK4IsdV30DQDX2PuVQLhn+sTqm+iXJqNe5SI19R56iGHabo5/UmpDeu4rY9ajL+2xdLkyVmGIsdKJFKnthvjKcyjj/WpLx4vokiMt7jVwjDUNuntfLhydQjHD29hXktjMT55wGJ9EfaDW/r4w63PtJCcUQc5JFGoPSFjAkkyYF3hhTLHO9Iq6y+b4ckuw0FIZi8/3humI2egzUvR9xQT6uLGZ8Q3MREFM8BCgNYawzasOCIHCyZNxvkXs9jq3aenVgWMvTE6bDWdtkYq1SyNnTi61j/K1rxBIDPpnccWlOBthbg5GUS2yPWOZ4/Y7TXOX0FFMAHMjxnBE3cqhtYz1TOvSQKhJ8K+X+nLcL8B93Hdc0nGb99DvmJWahOlmUL6gjbaqT9K3gdsMF8/KJGP5Amt90C1pCfdkLI0H+Ipjrx92GgeuDnjRRX9N22UwSG68GAkauAkY5HAZXYrtEpGbrcBVpH2uYTPtZttnHAg8eNHB8Eix4h+AkiMm35m5uYVCUM/vDi7IJMsy0Et1ZxiP0fm8tEVTVSziQofWXMGBM/dx+m0aE1jj76Jgz9nQx8+89oHxjQVUUt0ztSY6jD8Zt9/nZc47GiSICGpx7z1xDPnFywgz5rqV/BEOEzospH5UNkOLLoxTGoAxb4cmDU+rWATy3XE7P2npEHaO3S/YwhstIWaMeuxk8y/nbjmyovN6DN1kpd1Wn2FnltTCZAyvBIzqkFu1O+CKzgrn1HQlD9PLeGh8YMnmRV/HYN+Efj4Om0U7YgrYnTYn2oe16a
 EGoMcyPJ
 4P1LF02MOtPI1xjMdnI6HKELfytWqCixXBDGsAdVtkNGSdMmQ+H41cTWbbO52Sf7LP/DqzVP8aOKorSHt6mRotmdL/d9y81ZR+Mn/neGQTad6lsfCIdNQiO15WDEcko82aQJRx/4cf3PfDiXHWIxA0d7iVAXvHTQk58pVNKTMMBV9UzJ+97BmR5PMKmrGfaaztvjRuzIfZVehUhc0Ff5hBDeU45PX7bV1hKtkRSc/t30b2snFNCvpbwGHrm6k5Xx0K9y8WjL9T/evDfZ8bFAlkd5uQBW+W5Dd8T0EiHudFULoFV3CcrqXxvVY3qMPceaC7Aue73SZXkFyEWO4RdxGkopSLSboEJFLlAGsIIQ6BhTFuC+UmXXy7u1L67XmKBl9ZLNBNudnlGd1Uo207UyWydIVIkwzf7sAvJTjmnW9jwrMJHAd7WfquanqztJAL6B7/Ho1NIHZOzK7MzTzK9E+X/Wy7X3KmHR1WgtUCWBi4TKczdFOIgoHyYlSyXOa6Jk9uVYLK5NNozQ5uz+zvvF9hw/L6BGBsGJvY+X+qEY8fm8UHL9HlO7wAF3oxwauwo/oVpKmq0wVN5+6EgL36nfwaCJdFJ9ttHE0gzCsa2KHT6ecwNDC9T9BKgHy6hh8Cr6cA2U8jUp949o2OW31+54sVSQbPlGl+ALvODHCPyv2iYMZkzU+eCtW4rruuOCmLZ4wyA2EBFx22pT9mYzEOPdSYhOzlm4ZbEXcJgXZwFwnZxQuLOJwl1V5Qi9ndpbwgNrkr9ig
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025 at 02:39:08PM -0400, Zi Yan wrote:
[...]
>>> +static int gather_folio_orders(char *vaddr_start, size_t len,
>>> +			       int pagemap_file, int kpageflags_file,
>>> +			       int orders[], int nr_orders)
>>> +{
>>> +	uint64_t page_flags = 0;
>>> +	int cur_order = -1;
>>> +	char *vaddr;
>>> +
>>> +	if (!pagemap_file || !kpageflags_file)
>>> +		return -1;
>>> +	if (nr_orders <= 0)
>>> +		return -1;
>>> +
>>> +	for (vaddr = vaddr_start; vaddr < vaddr_start + len; ) {
>>> +		char *next_folio_vaddr;
>>> +		int status;
>>> +
>>> +		if (get_page_flags(vaddr, pagemap_file, kpageflags_file, &page_flags))
>>> +			return -1;
>>> +
>>> +		/* all order-0 pages with possible false postive (non folio) */
>>> +		if (!(page_flags & (KPF_COMPOUND_HEAD | KPF_COMPOUND_TAIL))) {
>>> +			orders[0]++;
>>> +			vaddr += psize();
>>> +			continue;
>>> +		}
>>> +
>>> +		/* skip non thp compound pages */
>>> +		if (!(page_flags & KPF_THP)) {
>>> +			vaddr += psize();
>>> +			continue;
>>> +		}
>>> +
>>> +		/* vpn points to part of a THP at this point */
>>> +		if (page_flags & KPF_COMPOUND_HEAD)
>>> +			cur_order = 1;
>>> +		else {
>>> +			/* not a head nor a tail in a THP? */
>>> +			if (!(page_flags & KPF_COMPOUND_TAIL))
>>> +				return -1;
>>> +			continue;
>>> +		}
>>> +
>>> +		next_folio_vaddr = vaddr + (1UL << (cur_order + pshift()));
>>> +
>>> +		if (next_folio_vaddr >= vaddr_start + len)
>>> +			break;
>>
>> Would we skip order 1 folio at the last position?
>>
>> For example, vaddr_start is 0x2000, len is 0x2000 and the folio at vaddr_start
>> is an order 1 folio, whose size is exactly 0x2000.
>>
>> Then we will get next_folio_vaddr == vaddr_start + len.
>>
>> Could that happen?
>
>No. After the loop, there is code checking cur_order and updating orders[].
>

Oh, I missed this.

-- 
Wei Yang
Help you, Help me

