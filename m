Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB17CCA0FFE
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 02:17:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 845E86B000D; Sat, 30 Aug 2025 22:17:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F6E76B000E; Sat, 30 Aug 2025 22:17:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EA516B0010; Sat, 30 Aug 2025 22:17:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5E21E6B000D
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 22:17:34 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 01F43586F3
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 02:17:33 +0000 (UTC)
X-FDA: 83835441228.18.D96265F
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf14.hostedemail.com (Postfix) with ESMTP id F325510000D
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 02:17:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Yw4oPECk;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756606652;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1WeT/zjIwqOiQO4cUG7X3O0wwJPbXUK+ur0y6w+idiU=;
	b=sAepQ2vg9TMaQu/DICEyRxv3v+ld+Tlz3B5IoPorfZkNQ/VOOErFn/eYu3mPL1+LTD3kLZ
	QmJ2MmaafLRM0LJeG7QVmi6p7nw0MZ5IkNU3UgJJ9UhrsHOtnJ+zMhpwwQEqZSdWZ26oOr
	5Q75TGs5vWiZSWEBzMglJxNzCvsOrvE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756606652; a=rsa-sha256;
	cv=none;
	b=537z3WQaKCjfbJMgANAC7ii8Grbh45X6DKQYy4tctVid0DjSnn0Lf0OmUhmJLj86576WN4
	9rtwnV8GgwoIjHwqGkZqllmfEtaIKHWo22bdUoEqF8nZvKrrbBc6N5iiiEBWC88KcVKnAR
	XBM82yJE0wlWrVLwGaC+PTTVd8gaRKY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Yw4oPECk;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-61d3d622a2bso429519a12.0
        for <linux-mm@kvack.org>; Sat, 30 Aug 2025 19:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756606650; x=1757211450; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1WeT/zjIwqOiQO4cUG7X3O0wwJPbXUK+ur0y6w+idiU=;
        b=Yw4oPECklb2CtnZ0S5YFcj8noReIWGMhS6z9sGE1GbWB3lX2+wif2vxnPDmlWBzO4G
         JqlQkthrXYu8PGOh1vXfrVcD0tWFh4uQuI5QGRLMAbg8RXsDOwHa6GzH6OMxRcfXZjr6
         45Klch58W2rEfOlBC42i4AB9ltLmPyCNk7OXgPshlEPMWzShFbRR1VLEt8aAH0CxwenF
         62Kho8oTQm+aSBGGp30HGQ4ceQRHzsRBvsanOLVO/1S1blvHnSwW96sqkAFi73FzM9Cb
         ZUlqXvWnEteKPlZ01U9z7za1eLpGnzKWg2WKgQAigHIM4FzPb86dXa/7U7uvcC8gAbQw
         Le+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756606650; x=1757211450;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1WeT/zjIwqOiQO4cUG7X3O0wwJPbXUK+ur0y6w+idiU=;
        b=Or7//uXfaOwn+6d0OZzSz1Q8B1xaoc0EfJIYZuDlNY9d+i1mAHQ7TaxtARuaLaoLEC
         eqKsR4B2AGUFl+fYPFufOAFu7VhNQvHQRdUGMkAdnuk3SFOylNXDpvkn0N1M1pkYOk9t
         0D6kLOoZHkPO6iGwy7gJPLheDqgE1s2TsbBalwJQ227PpwOfDZB6nMqapcKQYxokViyf
         JC9R2uY1vWSG74nDfSxive04GQN0MqcesfHOD8+Dcs8PAxgqVmQmv+gjJXp16Kj0J4Za
         qlyP6n0yf3TKd2DfNU/1ldIdQrK0MnAJFGFNPiWCtU6+1lCY/EaRqzxDi9h3ovzUeTyZ
         J/hQ==
X-Forwarded-Encrypted: i=1; AJvYcCUq2vh8/G4U3KAI7iYx6dYKlvyfxLJFEhx8r3oMzuOr4I8+wHRX14dJIZrhzdF/AXWh/6x9jW//9w==@kvack.org
X-Gm-Message-State: AOJu0Yz+ektwg5kdVGF55yhKpVn0MCXveU7VuydQwDiufTbV6mek82Bl
	IiWzxV+6M8ZJNiABeT8k1MXo3ZYFd0hY3vDRvqd+0ra9OC+Ot9OT+eUg
X-Gm-Gg: ASbGncveKV8UNW/WsPdUgoYRyuJNHjajvbhBWpn9IzSHFklxa3/Kl8H2St75PQ5hCbX
	mszX1nLSyg1chgzseOv2XhwhqQBXCrTrYXdGq5oMrImX+SzdJVFyXY/IqJXRviE1W1IV0WzNyr1
	qntpG9SRF2XnXUMHWS3xtyftB2a+U19eyHEYt6HyJ4KwSFEuL4FR0WsJanheAzUxuUR540TdayR
	MGoXCQ/lX+yKx2EhiiZovSNiQtgGt/LKZ4O6xiLqjNxJqMs1MXsifcBBWS+V+VaOAPME+U7NqlR
	/2mZWXCVi2LuhLfJ1undknEuxdFmeFnMmgKa8BiV6rrwi7h/ti57+wZf+it0jNeZ7YDrL3Df9op
	ye4f6g5TXKFfCUQkYVrAizIi7zw==
X-Google-Smtp-Source: AGHT+IHpaE4oQ84bPky6E3Gt38jrVXiAH5Rw5HJyfEG7UTk3O51dnCY5NKNk5Jf8sLxJx9Xd+oG5ug==
X-Received: by 2002:a17:907:97c4:b0:afe:d5bb:f41e with SMTP id a640c23a62f3a-b01081b3e5cmr457418566b.13.1756606650001;
        Sat, 30 Aug 2025 19:17:30 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b04189de5b5sm80240266b.10.2025.08.30.19.17.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 30 Aug 2025 19:17:29 -0700 (PDT)
Date: Sun, 31 Aug 2025 02:17:29 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@redhat.com, lorenzo.stoakes@oracle.com,
	baolin.wang@linux.alibaba.com, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: directly add pagesize instead of increase
 until page size
Message-ID: <20250831021729.seingx2yto677ngq@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250830023102.14981-1-richard.weiyang@gmail.com>
 <E0C570E7-C4CD-4E41-9590-DDB64757CA2C@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E0C570E7-C4CD-4E41-9590-DDB64757CA2C@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F325510000D
X-Stat-Signature: qu89yxsqqi4ciad5ixuezgncynjcze7t
X-HE-Tag: 1756606651-165024
X-HE-Meta: U2FsdGVkX1+3LNp3hziWi7WnCPGIIfSUie8joPh5MIVAPxdEK95f6gDnHuxwO+0QbW0X1w+Adbh27k7FPSUgGz4hUUVoHPExf6OOIeDfmeZQM3A4UKtSodI0/yT5PdZcRGNt4awAJrQpRjGYjQRWdmShvmwwjtOmispkKqvolhhAxeaquxfcB7RGf5uLNmmpAJ+jyBfqDDgGR2Bhj/OJFh89hOOHEnV6T3RQyyBwzRevcnFi4aErcB9beGKQhnzEW0DbwMh62wAMgmKibof4QRjMBUSffxe5SXzxGXCFcu2K7+FenqrLKXC7OGXRRYPOz+ooXSf+3yTxS3Ha/txXLOZtyYKjHdrh1h4uncCFFT7zO4VApZRz4zcinuCv4oUNGNBxpSqKOf/dlXr25hoVKucIkD58PelQKif62Bx/LmF1NWNH+sKoeJjeMcfAnXzJl5C82QIJtUh0zl9EsYPAQHLl61Okv4ZLV6FC0d71qGPE98cY6z6gJfBhl3p+d9FS7NBt0BH1CBj0Z/7KtHbsfE5Q02GQVcI/wiW2RNMye1N+fzErq+rt0czWW3M3aXyZO8uyCU65AOO+2/6UjoJ9/6VUgp8OI3kMkfBeIIiWZpMsMROL1xNfakmM6AWOZ2sRtuwRzq98gL7+bcqjg3PdQycuqKAZXwDlMkPaT5jIR1bymMUr5oHUmJVtGLsKGtoHyuw7+ZczX6NVdiAHZeYVw5BaRDIaHotN7gK6/MkSkskUrtQWvkuSv4dqJ8Eu8Kvyf3rM6YDT3VoKJ/M+i18SNNxrMm5cEVA98j8+IWp8iMjOYrzNdtvmXrge/45GrTmz8OIS6AYjSbgeFwgjwmosqVRMazRONaNeD3TB2f39t8dnNS+JnmNsgDUz4/MyGHlZFJDWhXcowoaSJZYNBgoVxwxMjA9Eal4z+GliYPd+RQuzufrhHxojOXvKMu3u0gAqkANtOonJma6DNj4aKkp
 u+8t8Eug
 glfeO3U6Xx08w39eZuSkhwheCbqA3dg16UXyIbFZoAs5LzNGj03FXyfwEpPlfdJ2gmnK4tL/84HKKFlDmDtGhQnjMauFvF7NFxLBNuFdgKPlrZZ0szAUNl1SNpe0Sjx6KZ454OBx4bzz7bx/Efg7FgVmgQYERHEI5R12gP4i8SvTrgZFMVE7aJK7HX4MxwaeUE3zKUHvtl5UKVaL0Ns56lE9Sj+3a7mIUtjcotGcZfZC0teSmcgulz1P1/lXm2qQToaeIAcAK5Ohc3CiLDL6gQ3m1MK61ngUBXQxq8dDv0m176p8GazVEDG8dC2dl8L2ux8UTn3F/NnjiH7sgj1+SnyX8aZpCEVjbtMhyy4k7w68XTM8ZB4koj2B+16MFUYLDKNipMnIXd0uZCOQaXkQSOS0fnuV/joo5l9g2hdZC15h2+5FfpUqC6WCw8+ygq9rjDpT372uHXCW+qoiIC4m37ljGY/PTN+gucPgbHI2LmW3XSy/n1eBfoET4FbRp/fqTYf+DK+KZ+GGGgqzMzrNXHQ/qPHaDS+tLufQcjj2JcFwd6UESi8u0gucCofBITHeMfyMoxgKnBnymAv7y6Gat0YtXtxd0mlkMFCYub9BuxIzp9VNcHUw+lC43nPxoj6dPehVtAn7Foz3StOD7e/ITevKIlrRlMAEW1vO3aph3YyEz/nRFJ0qb4EvaTHY+poMRvbDk0eSwG+ER9ysE7R5LLYQ6c+xHKQLRDKJU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 30, 2025 at 09:32:58PM -0400, Zi Yan wrote:
>On 29 Aug 2025, at 22:31, Wei Yang wrote:
>
>> The check of is_backed_by_folio() is done on each page.
>>
>> Directly move pointer to next page instead of increase one and check if
>> it is page size aligned.
>>
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> ---
>>  tools/testing/selftests/mm/split_huge_page_test.c | 5 ++---
>>  1 file changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
>> index 10ae65ea032f..7f7016ba4054 100644
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
>>
>>  	if (thp_size != 4)
>
>It might be better to add
>
>if (pte_mapped[i] != (char)i)
>	ksft_exit_fail_msg("%ld byte corrupted\n", i);
>
>instead to make sure mremap() does not change pte_mapped[] values.
>

Thanks, will use this.

>--
>Best Regards,
>Yan, Zi

-- 
Wei Yang
Help you, Help me

