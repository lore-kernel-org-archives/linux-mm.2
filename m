Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85CEBCA0FFE
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 07:46:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C2C16B002C; Sat, 30 Aug 2025 03:46:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49A556B002D; Sat, 30 Aug 2025 03:46:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B0186B002E; Sat, 30 Aug 2025 03:46:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2A5166B002C
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 03:46:33 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B9DDC1A0A57
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 07:46:32 +0000 (UTC)
X-FDA: 83832641424.16.AC5F785
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf23.hostedemail.com (Postfix) with ESMTP id AE345140002
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 07:46:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=adeoXofh;
	spf=pass (imf23.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756539990;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dXtX9Frtab9UqXTSJxGjWOLKxBJrHqjflBYkitY6e9s=;
	b=LbvBu9h3unY2R++ZAKC7hTP6xyQ03dg/Te6g7/lTlibLsUsxaxOW1M4XeDNb3KrdCqslRJ
	MKDZnLD5cObngloZHvIEzU4JqxI/Ub/F09dCo9pNwCNeknh3PAhOQb7BV3jfCNUEEJyIWy
	L1kAt1dFNuvbGROkWklPN+TSVKdzSPM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=adeoXofh;
	spf=pass (imf23.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756539990; a=rsa-sha256;
	cv=none;
	b=3oXoQdqbixo/A4s+nSjrhlnOruR4RGO1Ha4mzLPsjnFsDDTsW9HGhJX27rPr9G8HckDYmL
	km5R9CpLPifk5kweBvbGoZNBn1oG/C7rMFfJi0aPiRrwuIrcHvOjzsKJCu9i3nKhbYtH/J
	gvWY5VfMFeiYCa0bsJrLgRB7Xiu7FFk=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-61ca9a5b41bso3790314a12.1
        for <linux-mm@kvack.org>; Sat, 30 Aug 2025 00:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756539989; x=1757144789; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dXtX9Frtab9UqXTSJxGjWOLKxBJrHqjflBYkitY6e9s=;
        b=adeoXofhurYp6UNAS1pXWm3IExQmMPDcGBqIx/5hHob7tvOd3XrpPJPqGERgCXMQbu
         7hp6Ub+xlx2WCMfxBBZm2I9YM+jMqU3lqMDU2p+xTTiGZzkw+OJI6hpN/8Km6Pts19JD
         7pS7TiR2Ghx3As65Uf1LSt0UXhEBbppwW01w+EPD1Kn7CrresgSuivDUAcsJaJJJ28GU
         8WJ3QN8qD8YNtSJYD3ksOyFH/0/yyiVihPO0eqO4usZ4ooCokWzCmr7SWZSL4NXxz8+c
         sMgDe4/KZNQLc2MFpbdNAPZg3nI+fd2bN4S8JqgumIHrMr2CPN0K7QCJPFkk3aX7iG8u
         a0Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756539989; x=1757144789;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dXtX9Frtab9UqXTSJxGjWOLKxBJrHqjflBYkitY6e9s=;
        b=gHi4+r7YAX+U++kyo6NUFzekz4sdrbd0uDfOPk/bzehzHxFIvS804qLQJVGPYdgeBP
         E9765jQxBVrnHYgrAuDKVW8qrgV2k7A3hkZl21tKbNQTnB5Cv4YrxlCCJVw2lZNBtF6I
         76alILntfd6vb3eL/b9ntTraeCihYad7kXwWLXO5uR579WX0++w6gyNT5g/2VqIQ+k+I
         Iv1ISJTV/ywj9T6OqoiDvfHiT5XXUAznsxuugXkgpkCUP/eZVncaS1H2DAKS0ZoCdSPJ
         tIlpTGH4lrcatUnn3XHxu0zTwNGFoNxGqAeIbP7/r1u1zrKXBX3184DfWfPM3wufbd+q
         VA0A==
X-Forwarded-Encrypted: i=1; AJvYcCXhiPK/C2dOwVXqj8Rfv9e+Hwxiix+nP/3oLV2PpqedcDCd6WNN7C4pEtZF09f5hsYYSpOl7aKLPg==@kvack.org
X-Gm-Message-State: AOJu0Yxxjtr9HltEQUHB7DvMDCgrTsI56PQlX2mv84Noaisvc/Nn2y1M
	GJewEVtSVbCaPlxwngT8ogLXk+FUiKwkZXahxCCW1RG2HKde7EMwh5rU
X-Gm-Gg: ASbGnctChtfSaz19YoBlVIBA0isLoVZWLc3KVzkszwirCNJEU4jWgQPjoHF9NgfvqP+
	r0GIkThsqqewuoM7JLon/AUlbdMcwwItHPyJmxWp0Kqr8AqpaKytiRyxefnVAHSaxuiQTyVxev3
	6OhNquIG0QjLSpPKy0GquoygpzKKrGCH3Dm1CV6rkios+ZrIufkPkxudzmPAdRneTOPp9YjEjPs
	edsjjBmQTlQj7UwENcW0HZT/Rc31WyIAmLd3ILAWRT9s2fhvhlKOx8DNHsSES+E8zn06ELRfgg/
	xRJunqrpVCfdJcEs4sCF+OiO+3bc1xA/HVhQqUiC0LTqeP+wx4gIXNlmv8K2yXNCBlTkDauMi3x
	JFJ1EdWFrLeFCvVzbwjjrm8nQrw==
X-Google-Smtp-Source: AGHT+IF+y93hNDhCFHUAbkTqB7bJ7rRk1NYfczRqTKcmtM/XlUDeBnRrXCkQu4Z3SKAA1EblyKm2yQ==
X-Received: by 2002:a05:6402:3589:b0:61c:6fb9:c83d with SMTP id 4fb4d7f45d1cf-61d269881c8mr1010269a12.7.1756539988770;
        Sat, 30 Aug 2025 00:46:28 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61cfc1c7edcsm3185195a12.6.2025.08.30.00.46.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 30 Aug 2025 00:46:28 -0700 (PDT)
Date: Sat, 30 Aug 2025 07:46:27 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, david@redhat.com,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: directly add pagesize instead of increase
 until page size
Message-ID: <20250830074627.pitdp64svss6slyk@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250830023102.14981-1-richard.weiyang@gmail.com>
 <20250829200953.1757e85542b1126c4881d600@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829200953.1757e85542b1126c4881d600@linux-foundation.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AE345140002
X-Stat-Signature: ekrchfyah1tnfdbbx4s4pfkfcob81s6s
X-Rspam-User: 
X-HE-Tag: 1756539990-793745
X-HE-Meta: U2FsdGVkX18Bj6AUAaV/8pB5NawJyQ7pHjzWU+IsUkXlOfA2R1rsPWOtR3slATxjrUg44IYQvRGR4nzO7aXUkHSaTCAx/imGlN2cLV0nXgRrNkb2sDNkR/bREXLgWUP10mmIDqGUv9sw1rZYOV3QeVMQXowjeL+b2kWdjWK/uzVfq/aZvwyM9l9fApP5cUybVawj1cQttcngvowdzYCJtClccztQb7ZOy8FSt02dHGUFFLqwq870Aqmz0zf+G8/Tf+f3duEKp/aNFbVyRqWe8BRGII8Q1u3G4X9UcMbqEv2906bvqkXO9WcQusujD7mgqIf9ZHEkdxdNMuNxUgZLpWo+roUPpjsttvJLLvuUbx648d7ZCkwkpMfe5L7ZdjAyXLvOfyx9W0rzkZ/H3dM5l1oF6ew7hQaP9tYxsnHZtPmnLHZD53W7xm0ZaK9o5dYV6UalxnUUtSbNKDXJBPNIH7fAR1WXF+E+VUwuzzuAIF699SjR4dW4klaxSI3QMzTDEYqo2HPDvfGSj+q4yzVr0RvBM2TbnAtZTFF16xno97VdD8MM4fLA1SSPNa6OHlMukYJDyCAzO8AEaqZtuB4NWk5vJ6eTAFBPjhqwd0pBvnvTEUZp745oCUXUs4pkc6rKY+OcZvXwQ3TLRrqSkLVaTtCFgGMg/FDqO/Mg92OrNu5qhfi0PSa+24IEYi9GcyvesNAaTTkj4dRJT4ZWfijmPJoOwX9v/dI4XSqRU8HM0rv7BpyE4v35eVnuFY0CyCYu824aFPevDD8UpenqISc1Yaur+LU+8kdo33W7LTK6o0R8JH6PBMAhHzNxhrfLtxBTiE8+hdD/qtNs7o6FFay8Wt663FKVAL0ZE+lA7xgCQWrVgpOHdiowS521J+JKt7rwZHHKtGgbr3Sm5WmY3xgu59HrIYjwaqPOKH7xskd9iOxuLx53e1v+Pe/2P7ZO1YW7ecGBLriJSwkKV/lZkFo
 OBoXLs4g
 caZPxvi8DKZa8IL116NG5HKNH4WBnq+tgx8IkBJ3jJL2M/EaEzQ/3iU+60ce3ESdpIJkysdU053yKFW/UruldicuFe3kX1PympLDDZQCFjv0quyRDpG8GTACkuFysu1IvT1OU9D83Z3oiK5ZYxRXF2zx/JaW2QLkciCBHMV9zxYH09YZHZQnByYIc7w853JEoouNzJ/5aP30QRCMRKIdBhOS7A+HqU9VBwxWZwyFvI/gXbgfZXNJL0wOwBMA71+o4eJSHRI+pnnzScTtV4ptJm7i4INkJaUHdu4A1tGlw8DcMWvHsRsxnx7NNw8SmFxn2NirAgeHv0QPWabgbXfVLWLkrq6pa4dLO4WUT8CiJovrajhFZHkdu3ozHm056OlRuA6WdRUX5bBoUkXPvT3vtEnw5ns2PE/hp0RMmAJJDO0udU1en7qpbDfQw6bd+gGFmoRpo46WuR6R6w5B1SGxbo4z+uuCNDXdtHSeVzlcBY0FCzzHavjyEaHMcz+GIIs1KllUJmMLfD8iSpgM+2hlvNvUL50nHpa+0KDXcfLy8J2lJdoYIuLH9LFkpSkv3KfCaEfHfXOTLAZsR6Xz92oZCiHKAw+VFTSh2mCbZ91px8Cub9BQMG2OKxE9DzZSTG6+q2Aawpjd3Aw/aqZnV9dbv9Wz997MhhUjvgubhMZheiZ1ZonE0wIlh1hGvSborJsfVCAKPxCHw6chMAsxAeJ8P9dkEQJceQuel12dr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 08:09:53PM -0700, Andrew Morton wrote:
>On Sat, 30 Aug 2025 02:31:02 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:
>
>> The check of is_backed_by_folio() is done on each page.
>> 
>> Directly move pointer to next page instead of increase one and check if
>> it is page size aligned.
>
>Why?
>
>> --- a/tools/testing/selftests/mm/split_huge_page_test.c
>> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
>> @@ -423,9 +423,8 @@ static void split_pte_mapped_thp(void)
>>  
>>  	/* smap does not show THPs after mremap, use kpageflags instead */
>>  	thp_size = 0;
>> -	for (i = 0; i < pagesize * 4; i++)
>> -		if (i % pagesize == 0 &&
>> -		    is_backed_by_folio(&pte_mapped[i], pmd_order, pagemap_fd, kpageflags_fd))
>> +	for (i = 0; i < pagesize * 4; i += pagesize)
>> +		if (is_backed_by_folio(&pte_mapped[i], pmd_order, pagemap_fd, kpageflags_fd))
>>  			thp_size++;
>
>Looks like we're doing more work.  Is there something wrong with the
>existing code?

Excuse me if I misunderstand the code.

Originally, i iterate from 0 to pagesize * 4 one by one and call
is_backed_by_folio() when i is 0, 4096, 8192, 12288.

The change makes i just iterate on 0, 4096, 8192, 12288 and call
is_backed_by_folio() respectively.

Current code is not wrong, but not necessary to iterate one by one.

-- 
Wei Yang
Help you, Help me

