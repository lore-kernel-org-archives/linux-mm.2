Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F321CCD195
	for <linux-mm@archiver.kernel.org>; Sun, 19 Oct 2025 07:51:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 967DE8E001B; Sun, 19 Oct 2025 03:51:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 917D38E0002; Sun, 19 Oct 2025 03:51:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 806648E001B; Sun, 19 Oct 2025 03:51:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 685738E0002
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 03:51:11 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DD065C0559
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 07:51:10 +0000 (UTC)
X-FDA: 84014093100.29.CC21FDA
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf12.hostedemail.com (Postfix) with ESMTP id DA60040008
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 07:51:08 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CIQ6BQtn;
	spf=pass (imf12.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760860269;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ypkd73druNXP019v4tiDfOhsVxCl67Os1cWm2iyI5fo=;
	b=n77F962bPnf0RYmpaLlLFW6nwWII3WjaKprrVovDBRYarN7+1cvvgX1e0cJ/ExiXXmbB6v
	+RJ+j+RxNV7W1dpUaWaSLr+hDO6B9RSUucBEPjIRpdC6o429TPYUdrKmV0qosFmPx8av5M
	jZBpAPh31usTNu7X+WiogAv1kJ0iX+U=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CIQ6BQtn;
	spf=pass (imf12.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760860269; a=rsa-sha256;
	cv=none;
	b=toec/OH/soVZWz5ped+RtEqbkUjBSkmx8zjiePAaCq0OqGQ/HEYE8H7q1lsPNTXMIRXFpY
	TqzlzHOJMRlVUrdZEy12dx+rJdnPPDWLXUoyGa0ciUtMsj2P15vvwj0LogwXbaSuA/10GH
	WTRv8+eL1ywpDuDtSD4thDw8tbpBNd8=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b457d93c155so481628866b.1
        for <linux-mm@kvack.org>; Sun, 19 Oct 2025 00:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760860267; x=1761465067; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ypkd73druNXP019v4tiDfOhsVxCl67Os1cWm2iyI5fo=;
        b=CIQ6BQtniLuh0xvVGya6WMTH2AvD7bEcyNbjjMqBBpHW7AZLYx2epp6nm02uJKfncC
         uxjgPVnviRyqb5T8AzkoXNaDF4Ld2Uk0IPhKElUr6L6wifpW2wd5LIzlZZnYxaNTcQTS
         +yrEcTw15NEvWKdtSF6OltDCaBvkgKSlhnY+8AoMVQtJz+Io8eeGXGqUdnlBfgYRf1mF
         U9c+7ufZ2eJeCBsc1lulyHFcaNyXdbjxIZmRcdSg9YslvSvyw9Skzlgz8sVRL7R25a79
         PtyZ27PFtfyyZ/+WMfQWBKtsKb0BkV6+z1D5F/tqNW+8BrEeUa1199j2cfSki8m3NYFF
         iIRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760860267; x=1761465067;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ypkd73druNXP019v4tiDfOhsVxCl67Os1cWm2iyI5fo=;
        b=jzl113lk8+KsB/EYvdCQY4P0jT2YcPlfyNFlyGQ4P7Clvmkxz6i/X041fu4/I0X47x
         KXqgQY4T1qPzKq38JpseWPvgFBwizmEwabm7veaDnYQotkdS5KZ/sGkDEDCB1UjYDvuq
         u1WMwvp3tEdNaZKgGhuSd91lIDaopGojSZ7Xl+J++nvwRs3CAD1dzV0QeGNR689ho8N9
         dStd9A5RkR3RXpmnofKEYFCzXITjypzIeCrZalm2VoMWPq1fJe94ZT3+W7bX5S7I9kUc
         gtTsVO7GmaXEdjDWu4jeUF+u672chti8m2f20GeQdItBWHHpw2aXMYwNdT8jTNVV4OrP
         UqsQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQkwE/7q36VikYHwqnjSHbjkb3Z/Zm3uTh/05HhEzTT0YDouED2oSqqTqTPVVroc9B/MWaC2ySmQ==@kvack.org
X-Gm-Message-State: AOJu0YwjmHRI7df2IR/asG5FIalwtA5B5tWqCg68gwcgqlybCyfU8Knn
	S+25uYpB2Nsu77yxlEuqYgoCAAPfBI1zwd1Fxpye0KHgIfC3+bgKd+XR
X-Gm-Gg: ASbGnctlQIlK5Rq/U8CiGcv0H4xhb/RMrHo+8KK0O3ELM35+YS/mXwjqpyVhIO6ftxP
	V/pknkK+++dTEL2ZTDFwGMD4vv6ZOm6Yy4oCuDWIp6sIJVYZj2k+Ed+SjbdmEzWw6EviYOpmS39
	Aho87j4GdCrFqEr1NPlFijuOV/kayilzW0rw8jvU9mVy/XdpUAnxJGB6Q71sqrdoNdDz5p/1jhL
	O2aCIJA7Fgxm95dQ9vcmg3gRTzF7YlzlC6m5HF3m9o2X2V1muLYyydyIzTAJBYLsbQJjZ3k3bMo
	8Y/m6QjbaHJota6hUnRj93B3uOCE1aMEdmN6rznxVK6/ZCRqOhzCdE0oHi8Letn4r/ykBoMfIFr
	+ZtacJV4NWhB/apEPB+mdUJFxgaLdklgnUNlqaAx8GInPNj9VCdaA+c0d3OnORoZGljnEE0fWZw
	8ZH3/QLwuM4S0IxA==
X-Google-Smtp-Source: AGHT+IEmg3bXseriMu/V+jASe+v0H/yns/gzxzzu0A23Eiv20soLkljjxNaG09+oArf1hj4b/zFRFA==
X-Received: by 2002:a17:907:7207:b0:b0c:fdb7:4df5 with SMTP id a640c23a62f3a-b6472b5f08dmr1064767266b.18.1760860266935;
        Sun, 19 Oct 2025 00:51:06 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b65eb036a3esm451254966b.46.2025.10.19.00.51.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 19 Oct 2025 00:51:06 -0700 (PDT)
Date: Sun, 19 Oct 2025 07:51:06 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
	linux-mm@kvack.org
Subject: Re: [Patch v2 1/2] mm/huge_memory: cache folio attribute in
 __split_unmapped_folio()
Message-ID: <20251019075106.jbnmgazdu77qyd76@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251016004613.514-1-richard.weiyang@gmail.com>
 <20251016004613.514-2-richard.weiyang@gmail.com>
 <3d4b9f1d-a420-4961-ada5-355b60909d4a@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d4b9f1d-a420-4961-ada5-355b60909d4a@lucifer.local>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DA60040008
X-Stat-Signature: arz7g373k1pufz7u8jk5eha5z68qoios
X-Rspam-User: 
X-HE-Tag: 1760860268-265751
X-HE-Meta: U2FsdGVkX19Ey8NqVhugCqTo6DybMrqWP5vYB1uOpqH4Y3UhZQkIDgh4/2DASDXwDnqjk/A/cvXYiJmKCB6YFaCZ/KDfKTk5oyQwQhLwJ15UiH3mkgNAh5HtviN+Huurvpff7U7Hu8RGZM9GAMRypdKE//tPNmpOsIKr6lRJVzXqoUSpmMagxIpAjcL8OGnk6TXRldEeOiLB0u7vCuAF+iXT/pWWOruIaLO9PpJcBarsd9Ud74FTUAXSa8LBhIM6LjZfz8/Bq1cqWjsn0DcpGCrMgxibJx7afjSlNUJOy+pHcqD/Q3s8j+R9AgKQvaJadS4av3cbrQFlKALu9sg/LkV7iL8wOUGs0ADsLSaHZN8WyxlRwynEVVwpsj6bDhDjVFSRjL2D81oy8dhY5fh5fSa1UaOLrc6ZV7HAsO+yjjWCpW8yByvEC+5k1DueEUllDaRjTIsvXOAe5WGx7TI5pMN6Koyb4YctMk7gwg1q3sxiff1TfVYY+YExIP17h6OJ3AjzI8b7HTp7igM7B+9jGO8hHeqarLqVDpOz3c9uKTH2iWrpdfu7xy4LaKMh4/TQToMPPrUsJL1twacHYXj4pM8pbXRZBnmuv+zAWS1/qSfbfCOCYrK6dUTLkEKuKVJ5cKrHeEUioPG2BlT4cEgIU2TuFRMKoqBAcOA/b23Yzzaf/OIl8jcKNobHZ+sSaZXtY4Iz1OA4j0/gVUliCytDkkTNYXi7PhA15eX/y5rhUAW4NfefAINEaX9n9bEIqie2714WOGH9/jIg5WI/cB5KwzblJkhrEJF8dkGxMLr39HcpzFvgjKG2h84oKg5/Q7x+xlqFW9slgaYWUbDp5PSfnhvK5RZjxDvvljm79WV4qgowYP8+4UO6y8emOA874OLYyUVlGWHGnW/n9Izpr+qYPZglid/AHmm7/6EWZuYrKPCi93+4Wkg8fe5EzsLybUZiEZ5rVyeVGGKvgSyaZQX
 i+pnBdvS
 Z8couI5zJxFnFZNYhU/Suj3nkI02bK8Lp5rBarzGZOBIi8ptmNGUiVXMDqBdb0YA7U8r0W0ZBGgFo2BW520VdkceoJ5GAsQ0G92NLqimkEkxrH4yxRaDQFZcVhznQZ3m6CuUlL7dMe0hrPFqVuPuIS6mviOpY4SBh+Yo9+CNVi/VINUqKL8Z4dgyd8Bw4sebxmeXLz5JC24pvUo3oA63kW/qisPEj3kkezvewR9UM5AtvdjT4NJ5cYU6xA+HcvwARFJ1c/8FCY8TRIDC6q3+s7/Do59ez143vVCkGg8SLpLP8Y/16dSlCSgBt2i8KHC4eJOFrZ6iR4hxp5DbvWzujR2+tZ9Ecd7po4CUGojM0ZWJOXBAK6yeeVSs8PHat7oSSnNECbdN3hYM9/vUNMc0UeYDmsM0oJlaeeyPeY6sqvmDSorxiNe2HE2y8+ofR9Km58EJMXKBCx0wTa+gW0qBTqzXadbIokNarF3u8uTFiKMUebO8TMDakomQTelJXmXE/5kCV4mAIl+j9hSnJhwOxaWBLDt8mCjjA/V7to9ItRgOV10FPP2SVnZM+Jzpnkwy9piM5u8lYGJfAG2atgpoUQQehib6LxoxPTQZ7Ka9Ufq/zMnpd19G2ZgCtKsh/PL8AZ8o2uCZAC5fp1EWlHw+82UFIaGuEM352ghm2AD4ZXe6/9Xk5aedRe5HOy+GYNnbec/4RMcVb3I33BJWp+4TyTLxt8ScMXrXJfe/UWoUFkNK3DQ3GkIFx4c/0ORov+artr76K7HF8e5JUlZtihCnTyIqjbYgEnul/KCelnIZ5TvaErGQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 17, 2025 at 10:46:43AM +0100, Lorenzo Stoakes wrote:
>I don't like 'cache' here. You're not cache-ing anything, you're relying on an
>attribute remaining constant.
>
>Something like 'avoid reinvoking folio_test_anon()' would be simpler.
>

Will adjust it.

>On Thu, Oct 16, 2025 at 12:46:12AM +0000, Wei Yang wrote:
>> During the execution of __split_unmapped_folio(), the folio's anon/!anon
>> attribute is invariant (not expected to change).
>>
>> Therefore, it is safe and more efficient to retrieve this attribute once
>> at the start and reuse it throughout the function.
>>
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>> Reviewed-by: wang lian <lianux.mm@gmail.com>
>> ---
>>  mm/huge_memory.c | 7 ++++---
>>  1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 3c74227cc847..4b2d5a7e5c8e 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3527,6 +3527,7 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>>  		struct page *split_at, struct xa_state *xas,
>>  		struct address_space *mapping, bool uniform_split)
>>  {
>> +	bool is_anon = folio_test_anon(folio);
>
>As David said, make this const please.
>

Will do.

>>  	int order = folio_order(folio);
>>  	int start_order = uniform_split ? new_order : order - 1;
>>  	bool stop_split = false;
>> @@ -3534,7 +3535,7 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>>  	int split_order;
>>  	int ret = 0;
>>
>> -	if (folio_test_anon(folio))
>> +	if (is_anon)
>>  		mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
>>
>>  	folio_clear_has_hwpoisoned(folio);
>> @@ -3551,7 +3552,7 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>>  		struct folio *new_folio;
>>
>>  		/* order-1 anonymous folio is not supported */
>> -		if (folio_test_anon(folio) && split_order == 1)
>> +		if (is_anon && split_order == 1)
>>  			continue;
>>  		if (uniform_split && split_order != new_order)
>>  			continue;
>> @@ -3603,7 +3604,7 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>>  				if (split_order != new_order && !stop_split)
>>  					continue;
>>  			}
>> -			if (folio_test_anon(new_folio))
>> +			if (is_anon)
>>  				mod_mthp_stat(folio_order(new_folio),
>>  					      MTHP_STAT_NR_ANON, 1);
>>  		}
>> --
>> 2.34.1
>>
>>

-- 
Wei Yang
Help you, Help me

