Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BD27CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 17:13:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B4B88E000B; Fri, 12 Sep 2025 13:13:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 585A18E0002; Fri, 12 Sep 2025 13:13:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 474468E000B; Fri, 12 Sep 2025 13:13:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3288A8E0002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 13:13:57 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BD0251DF8EF
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 17:13:56 +0000 (UTC)
X-FDA: 83881245672.11.C9051B3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 371064000D
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 17:13:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Um7vTKv0;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757697234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2YALunsK4g8WkzqephiUqE2mfLk4sdPgr1rQwcgrz6Y=;
	b=eZDhd2tTXUvjkeeycPMZliVSYTXiL2AtubBjj130mXs6EyE7blkqbWmOPAlJaAGuutKNrj
	ygBgbys6K242ZcMJoxL0l+AUfKjphP2o/tgGl3bjSpVhL6BWtaS6/hGDCy4Nubyx64CZXn
	shIVghDpGAfj3z2UbTdkY1a90XXC/i4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Um7vTKv0;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757697234; a=rsa-sha256;
	cv=none;
	b=PklR5HZb/Qp1wcmccjRZwKnL0k1g4BqLd48276DCHXreiVTeQt5pHbNbKhnLPuCvEqOuJL
	LAA388z4MAOM1/vLIR71WGWWF4uBex5ln0y1taveuD8c92Ytr8z5c4aGPuruwTq0JXkVwo
	2cCnhMemFLlXKviqVpnDwHLUGqnIL5Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757697233;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2YALunsK4g8WkzqephiUqE2mfLk4sdPgr1rQwcgrz6Y=;
	b=Um7vTKv0uU4UYUlO49TJ5YPAqy74EmoK8fYI1znjRoZT2/zJ3OP0V7ZVDFKqstKujO4Q4V
	IYjEX1Mf7Ga1cI6/9u72zff07ANVIVIQ9mfWagXbOMvbKSDiEcDnK/QHs8ZoCGFeZNGvZ1
	rWPCxRVmspfhp5THnbmuQO42XRztT34=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-669-dILotY1IOVmvpxtOo94hWw-1; Fri, 12 Sep 2025 13:13:52 -0400
X-MC-Unique: dILotY1IOVmvpxtOo94hWw-1
X-Mimecast-MFC-AGG-ID: dILotY1IOVmvpxtOo94hWw_1757697231
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3e68a54dac2so948636f8f.1
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:13:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757697231; x=1758302031;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2YALunsK4g8WkzqephiUqE2mfLk4sdPgr1rQwcgrz6Y=;
        b=TcitgyKL2UN3ZIA0DHKjlWfmRpi+Vp1OxuEc9Pw3Nyd0C8txovqd9XGNrbsQk0KaXL
         kTnFtYfV6Uc9hElb0m1a+FAFiggeAgTUtN24vxWdwncz+zsFMkQ+C1Rh56CVlF09WdON
         v6T66VrAjqXDDuZqKdJYHMAC79fuAMY3LbhoOtcs2egpGl9iPRrNUTBQK/AGlMzz/b14
         kmYMiCBMhSd4n7dxEhIlzbea2OWIiFPXUF0sdBL62Ih8Y+cgbfs1FpvuB3yxDMSYw83q
         v+71Uz707GRrSAciWJQh7x7L8ZOQ0ZnY2vfYqzPgkoqf/CzJV4Sk9hT6NR59FBJqOXNX
         PKFg==
X-Forwarded-Encrypted: i=1; AJvYcCUwkvWBtzhisd7cdpMOdSiAi+ArimLm850XjFjF3N8FMELAjbZdcc0hQQg3XQ+TD+ey5crqls+dnQ==@kvack.org
X-Gm-Message-State: AOJu0YxoiAgF4mgss2eN0deY+8QN+/OmWyaxPrphMqUZ17tx1etp/ErA
	2QINvVBuGeARe7tAwZsYELguORVJ+06bm1iJ/d18uoDDybiMc+ymD0aaf9OX6F7eIWKaYBuuE7n
	BbX2uRY0D/8SMZfjbz9yvU+BqJVhfnaeUbNd64fM+LnlCOhNsa/7g
X-Gm-Gg: ASbGncv23OxOPqQ6v3SMe4lAxNXsJwgfjKa8mxJyEJXbMnXPE0oCN0B2OjmLy4gRFlL
	Fu5dqajHa7WSOKgNHheezmqP4N5NW5LrIMGOwJWYFl78YpAoIBB3Bdkm9OtmQT0X/ApY5SJV0du
	DqGT9Bb2ffTnaO/7xCuixhXEAIHXFb+IurZYFPhtlorP54hFHKrQ0dFnyfb1mLoeQjkq6N8cz1A
	k2yqNebnGg96n/zXyYvUEnKDZFwL11EKDvpy2M3JHhrj2r+JL+h/qhmEk5mOCxeA4Lb/bY4YFGB
	jThPg/lRzJrDOQan6tv+tjUYwsfwgDJQkaVgPTkqCktTf6gqLmqdYLDW5XR4kV5cLGv89QTCCSl
	Qdwp4WcKTco9GQolco225txRQdMm0H7JqMfW7r+5fQIFM2U3mLpTBbxi22DowwXSX5m0=
X-Received: by 2002:a05:6000:1ac9:b0:3d9:a7b3:1b05 with SMTP id ffacd0b85a97d-3e75e15c1admr6736604f8f.25.1757697231125;
        Fri, 12 Sep 2025 10:13:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHdRuP5+++u4mPF1dSEU3FtB9l/UJjeEm9l6i0OeSGdideE7lj1C8hRYAaMPCus2MbDdEb7xQ==
X-Received: by 2002:a05:6000:1ac9:b0:3d9:a7b3:1b05 with SMTP id ffacd0b85a97d-3e75e15c1admr6736578f8f.25.1757697230633;
        Fri, 12 Sep 2025 10:13:50 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:da00:b70a:d502:3b51:1f2d? (p200300d82f20da00b70ad5023b511f2d.dip0.t-ipconnect.de. [2003:d8:2f20:da00:b70a:d502:3b51:1f2d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e766659ea0sm3822008f8f.43.2025.09.12.10.13.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 10:13:50 -0700 (PDT)
Message-ID: <36bf71ea-f6aa-42fa-9fa2-53d00f351777@redhat.com>
Date: Fri, 12 Sep 2025 19:13:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/khugepaged: Do not fail collapse_pte_mapped_thp() on
 SCAN_PMD_NULL
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <xhan2av3fyl7qpsl4bhjtds2zeegrl57ehtc5grtkua3c3v3nz@vain5s6gpycl>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <xhan2av3fyl7qpsl4bhjtds2zeegrl57ehtc5grtkua3c3v3nz@vain5s6gpycl>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: eLXfwmenv4goOlHBPF4TFXVtzA_oX9PmiQm3fd2uJ8k_1757697231
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 371064000D
X-Rspamd-Server: rspam05
X-Stat-Signature: 4b8d895zbyxjpjfd99br1xxmp3n8yu51
X-Rspam-User: 
X-HE-Tag: 1757697234-815588
X-HE-Meta: U2FsdGVkX18VA7/C1HsPZblw/BNOdbfNKBdAGVb49GoeuUqN8ynpMyVbZdROVvmTULUIy4IbcR2HwPjg8AJ8mhA7tPfbw43wh5jL689gjG9SU3F+YCDrwCnNOuc3QuUQKNsWwcbBCjAnZGcYbDYsU1SBG9q5DCe4MOz7YNJ/FooEo8S/o/lBMvSrfH6+SF+FoDmSq+iNTtaDSkubJNi0VyqGRZImd6FSnQDWD1I2o6Q1aKRCDGjHKG8n7rb8+5Zv/Jrn7S5ItHL1sL8eiMd/gAqNkN29u/8XJv3sswkfy4xwZtw7u/unJVTR3xDHhaqVZkRou53GhQpfNoq7naarDcj0FYc9BDSQ+/j2BLgd6n02lkyNnbQi4TJNQtfWtP0cu0PeXaMnYaLOgtFnyavSXRv0SEy24AH6ZiRqPtBBesTq58DHxeJzNQQ5pMZQQH1cC16FA/kgcoTo/5+dEnwunjvtnyQhYEEVfTAhb/7DKblc3Sk+MH8ZmydP7X+gxAmYVZlnVOncMPkT0AwAkhe/CcTuFhhvzYx9XVP2iS7wQF1IunhMlDWRAwy10aTDKh2zQnRsj4IvwsMo0sTO3t3pqe11SBk4mL6KKgbzoEahtLz25BVnrkYl9jnpT17I3c9cmsvHgQuGi0IZpdC4HfOEPkVytmpSbzJQfvyzetG8beZztLdLbovSmcxxklHgHrGMx1++9wS1wjQHxgqeFcqpGASCNXchU5n4+YeJ3U5SHp/6zChgkigfTMiKcMOnd+Wpp7BSeA7HizfKhwokltUnURjCgA9cSWc8eQwp84pkJhxXVe7mRLH+msRj5xOydT9lojnx40DO5iZShyn4faA99z3h9TuHlnkFPXXESHHD4gT3RRRB+Im3eRVKlRD8Hg1aqoZHkIWWoZ2g9zfpBFnh36aVJAwz1ObzEpMHrNFhcFEgzwxmMNbwpCFoYTUqe/LG7XIviQhT3NBdAHl/0Ne
 1IFIBVf9
 ZTzRTdjSZD/z8bQIhFyHKVpUi6sb7p7udjH5F3xQIcNqIyY0lN/bUGBE5yccOMpdxsvKfVUVeMx6oJVXbIaLNZRg6bZYXRxpTeQi19XnHbQSigrggmhkiBQmWyPEMB8cfvfqirYBQRMyTJTOSXDIxZRXJHPfMRg8HrBukv68JyhzjQIE6kBOK4f5yKaf8Pa08lIu++Q2vqLI19yC06CsmjFKbdhzyTejLFQNTUSmMh7d6MXVcdr3xb1UFYpwYgkPEXd8jeZjYNqIGT6QHGWZ2+MinesZO0aJvyL8X2wCNmaDak/ZAKhlPpjxG0VUbHca4B+veCd0TA/0rr+Coc9oNp2V3/G9+NdfZdylKfURlcfw7PWn5Vr0MPbLc8kl22T/6B/Q8UOdMCPrf3kchpMCP2VY0ldZpq91/4lpLsY89U9FZElzVDYgGSsDEj5e/VXmyf38r25miKFJiCO521bSPrtx6CD4w2hq+JFkHaMrsA9dENvCY4SjhdRzq8HMS4XYq3Yf3o8YDhADBZcI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.09.25 18:58, Kiryl Shutsemau wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> MADV_COLLAPSE on a file mapping behaves inconsistently depending on if
> PMD page table is installed or not.
> 
> Consider following example:
> 
> 	p = mmap(NULL, 2UL << 20, PROT_READ | PROT_WRITE,
> 		 MAP_SHARED, fd, 0);
> 	err = madvise(p, 2UL << 20, MADV_COLLAPSE);
> 
> fd is a populated tmpfs file.
> 
> The result depends on the address that the kernel returns on mmap().
> If it is located in an existing PMD table, the madvise() will succeed.
> However, if the table does not exist, it will fail with -EINVAL.
> 
> This occurs because find_pmd_or_thp_or_none() returns SCAN_PMD_NULL when
> a page table is missing, which causes collapse_pte_mapped_thp() to fail.
> 
> SCAN_PMD_NULL and SCAN_PMD_NONE should be treated the same in
> collapse_pte_mapped_thp(): install the PMD leaf entry and allocate page
> tables as needed.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> ---

Makes sense to me.

Is this something we want a Fixes: or even Cc: stable for?

I assume it doesn't really happen frequently, but could also happen 
after MADV_DONTNEED'ing the full range with pt reclaim I think after 
having faulted in some PTEs, for example.

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


