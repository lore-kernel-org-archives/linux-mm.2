Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4158ACA0EE4
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 10:32:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C26F48E001B; Sat, 16 Aug 2025 06:32:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD7738E000F; Sat, 16 Aug 2025 06:32:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC5958E001B; Sat, 16 Aug 2025 06:32:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9BAEA8E000F
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 06:32:44 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3A9EAB6DA3
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 10:32:44 +0000 (UTC)
X-FDA: 83782257048.15.E208665
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id E54B980009
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 10:32:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ABGoWCFY;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755340362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=toLcHpWZWAB7qfcX/elcma9r2w13Qht/XhplG++yCbM=;
	b=4yCNb/9fUgrWNI2FvzLRQxpyb/KFJa0eueEsT/68LBV8zLJ7W5mj1HFUHSgG9I1cEirXP3
	OjZR1hseGWW2JbZlm+Y/fpBGE6xwAf1/flI3oCcIqFehtqlzDMq29BqAsNbFSnEIJfFys0
	kW5GwN0+lQk9tv/eW9aCPErFn5/34Ao=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ABGoWCFY;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755340362; a=rsa-sha256;
	cv=none;
	b=mAZq6GFxC4VrLVbc4FzN8s7OwNPT8C5//3CyYWRyzxuCHMs6NDW3+IvwYOaVHrq21j+O5V
	u708Uk6lilWlDmur3zZ2mXmDB09pItUdm0ZtGNqrLvnJ6AF9j6pjYSMz6WLUmjBef+g3pr
	Isyj+AM9bz+F83vYauMlt5r+kz4nV9Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755340361;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=toLcHpWZWAB7qfcX/elcma9r2w13Qht/XhplG++yCbM=;
	b=ABGoWCFYEHgHHbVnOxhTP9EpBPNfkQBaDBlZ08DWiFD9SVge8x1UCHGH08fEOotggbyfjL
	ERFROD/GkSwYV37ra2X7ok415D0Z+UiLaE+jExrKk/eQf1Zv7hIVjGHm3haXcmx2djTDwr
	a9/xqWwnLzwOoUY7Pu0aWL/id+HNpcM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-302-D_2JZpZ2MjyAOB4-GedoHA-1; Sat, 16 Aug 2025 06:32:39 -0400
X-MC-Unique: D_2JZpZ2MjyAOB4-GedoHA-1
X-Mimecast-MFC-AGG-ID: D_2JZpZ2MjyAOB4-GedoHA_1755340359
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45a1b0b46bbso11958235e9.2
        for <linux-mm@kvack.org>; Sat, 16 Aug 2025 03:32:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755340358; x=1755945158;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=toLcHpWZWAB7qfcX/elcma9r2w13Qht/XhplG++yCbM=;
        b=U3itSzl/WHRFDQxsAyJXtlfKiOnbCkrgR6Ryf/a2aC9ZMTGYEP4W31TFpiVrI4FUNU
         chAjBh+GAVoa1RMwpxUw6yPb9X1wD9FA3GuS3euyw50LF6RnNgG1o/V9XEEKlA4cm5+1
         L1VzgvXa1yTsijU10hOqeJj25Ba30W0Z/0BgajHVe/XBGOPmsWuLE6Jv+IoQpZ/RkYkg
         NF2GoPDZ1zQ/u+mLFuhJKinLvQObi8dkqSSTXn3vijhDTKInrP1GMvxC+38JFil4blab
         u7K6y6p+GN6gR0W8tV2P+Bd/FRe1tn9pdSNmD0ubwCSxfglo0HIfjr6E2mPkHgZaBpf/
         zc5Q==
X-Forwarded-Encrypted: i=1; AJvYcCV5vNRDGvrtLv7FOA0ny4XlC9PcGa4S923MZQBgcY2/TDA35jv5sHRfByFpjGSOzlgsMo4iJIg56A==@kvack.org
X-Gm-Message-State: AOJu0YzXOcGnhxn+WFVpqHW3Y79ADDNxJQJQSJGsNuyNEC3V3reqyVnp
	J7w2Byd1JcyDNxk51Guo/Dksy+HB+5WU6z3Fg5bhqosb/HRyZ2RfmtRPkfcqp6HPCXz+4teWHo9
	f+8DcqvMklIDwaQGYRRnfiBJ/Xlk3FXiqxmg+mVM1eyCcM7velQM3
X-Gm-Gg: ASbGnctHj3z5IcFhwc+y9Albuvpzm5zljSTcggHjdCd4TuomwUQ2qZhAB6cT20WC5xN
	4PVPrNaHsH2H/m2H2xB3QDd1jy6BW5K/YaP4smhbjpreuaHm2CZe45H5s6TvpmxxZTVlmMjzMVv
	Y4SHYQ74Tj6rBmGlobNV2r0XjngdhjlrZiRrdwEIFcxAT+eNKYzyrUiBZajIB0kN0oRVbeV+zdC
	cMSxafJcu+yn4FiZmNgeQ8qg2Ja9H+n4MPWxoYtY9oX3idRYajRvSSxmYSgEJ0C56En/rwjELpt
	J45m23Je/zEocvrA2/rl593k5PozHTTgd+SbGha7ojZGCGsFlE9rutCaPawrL27VKCkLdAa2naI
	UYacSMEk3xPNpJE6K8+F7WGwR2/+savjw6zcRZnhg39GOTjuytjlnkQpPsyISALRexjY=
X-Received: by 2002:a05:600c:8b17:b0:43c:f0ae:da7 with SMTP id 5b1f17b1804b1-45a27f08040mr6151705e9.7.1755340358670;
        Sat, 16 Aug 2025 03:32:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHwzrSTrJx/W3CU88hLFZh3auEhf8a9uIqz/FNG3ZDCO94i4Ny1kK3k4I+RyZYze2lor3eXew==
X-Received: by 2002:a05:600c:8b17:b0:43c:f0ae:da7 with SMTP id 5b1f17b1804b1-45a27f08040mr6151565e9.7.1755340358292;
        Sat, 16 Aug 2025 03:32:38 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f23:c700:d8ae:41bf:492a:9e4c? (p200300d82f23c700d8ae41bf492a9e4c.dip0.t-ipconnect.de. [2003:d8:2f23:c700:d8ae:41bf:492a:9e4c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a215c324esm32782675e9.2.2025.08.16.03.32.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Aug 2025 03:32:37 -0700 (PDT)
Message-ID: <aeb43195-64c0-464d-995d-0fe53d5674fe@redhat.com>
Date: Sat, 16 Aug 2025 12:32:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] mm/rmap: could be partially_mapped only after no
 entire map
To: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>,
 Wei Yang <richard.weiyang@gmail.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, akpm@linux-foundation.org,
 riel@surriel.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 harry.yoo@oracle.com, linux-mm@kvack.org
References: <20250815084943.23063-1-richard.weiyang@gmail.com>
 <20250815084943.23063-3-richard.weiyang@gmail.com>
 <458c4ea9-1e33-4159-a545-6ad2c5b81add@lucifer.local>
 <15ccbbb0-8ebc-4c50-a1c8-fbe5416ecf46@redhat.com>
 <20250816090654.u5eoys2vkpswe553@master>
 <88117e56-6b81-4601-a954-26d5f630aabd@redhat.com>
 <d18b67f8-92a4-4e10-9341-fb7e075a885f@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <d18b67f8-92a4-4e10-9341-fb7e075a885f@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QO9l2gdDj5CKMNhR-kn1ctpo7QBo9xnleYjxAc8g5Ec_1755340359
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: q61jutuk913haawbqa6yoysqoittnbni
X-Rspam-User: 
X-Rspamd-Queue-Id: E54B980009
X-Rspamd-Server: rspam05
X-HE-Tag: 1755340361-487957
X-HE-Meta: U2FsdGVkX1+K6Ubep4s9hGIoshnA7v5WFUwIk6MGlA37nAFBK2oKN6MZfviitHRm6CqefSw+slw75NjK3EnbhhzxXnMMWXAaTlznYY9pOSJBTGNjj7NEE+hSWCiNKoJs51iLAPH5SjCed72MkiJWoYmqzGKd2Yl1wkB7GDhA88J+i2Src1+BBVvZ5/PmR88rEl+wlN3LL1QvD4DOhEELiI2lRUULSL1aEnmn37lFY636gyDbar5ffKIrjgl4hqtu5b3aW3SkszzJIclDQjOzzpfHM63rypkkBI2XAnU0nZtuD2z/JeXmoM/jwwk8c3pCfF77PBJf1pdCz6Es5JLKaZSc577jR+X6N/uPY6xbo5qPQhOvREOMNdebu9d/MpFV08TX31d4SZtWgd7uIhvO8UwzvbFzXwOEESnSlyUniI924wzJwBwnwUT6u3xB5vLf+mmgo2frLzqK60Mdrx0wTh6CVGnKD+xpnkQfgjIovNngt9d/W1LMAPD2wI+YsIlphivz3YUUymS/C3iqbX9nnrWJQeU9N2B9mNlWPkZJ7k/McfqZJ8RijOYXCJK64ferwGR6MiIAK6C7hZ6o3PB7mbqf+lfwsdUz7EPf5BwpDVV7l3DgUh6LpGH0i/9/hhO/FEMx1c87lHN2Ed0A73JzGkz4w6Bmk/TmrGfw3kV0Yp8wgdtG3FFMYJ5G687lg7on4wCj1wKanAUL04KuRw9WFJVzk342s5vdpsUo76+mLGE7QvEmypfMSfglh8h8QvqAzcbn1R1LwNvSSQpEa23WOQ0208Amzw888irNiOie+z01f+r0n1HAfF0BHf/Su+s6Jk/GMZyyJB7IVgKN52kWBTEO/y5kSZIc8Ccl5E5sA7axQEn8y2n9ezqgmyc3BNu9V7e/x12CicPgitqReFa+Oqf93EL/XDDAKVzhHU/MM56qrGifCx03wZK05C4z0zBWpfe50and6YH7kZ7xkTp
 84NgQoMJ
 V/Ib7uN9IG7vz+3TtuOLYsM7C6UtZRcdb+FpIqot8Rl8W1tUS3s8pkXH8+F11JGQLN9KXI0sPQPi1+p01LnbkiXqFoQbpyp42ZaoZyC3XKSJ6bFkCbu2o5gCijwnCmKec54hf93fFSHl8BtkFngtQZTya59i5oP/mL/eJQhomIpmwcfTu6aEvg62H2NAax6MKaG3QMDyzZmaX/Igm+d2VcDHLI8X1qjARP8yDtLzKG8HSvysnMrYKsbeaNbb5BJ7oeZzvoFO1bo9d9wp54GCCJrfTq3uqXRr+ajmaT1H+FasYVZelf7FGC4w1dhgmqz/eLX6l0NAr9pbwjMGFbHfeLyNncjv8l2XONj7Yf3jo1oJMTfOUfv7rtab/SQbH+9bD4mePnHM0eptepCOp1hQNHf6nNMS6F1Hjdo7ezCSo/61oXQlcwXgtcpHD+5d+y8tsqrHTz7hjV0BfO4+Z+xpuwcOiPjRgxwVDbwYsML9OvH3HdlL2RA1CvG5hzH9TjxfGygEria3/Q546jMRKHj2yy2hGZe+Eu2q7GxkuYZ82iU9r8iJpuN8BdvFTZjFEgtSVGHWIgVpj6l93d3taU1r8pkYepplTLx0QHEnVjQUSc0jIi/Vj5fC0ZoACuMBrBpIOUJwje8palS22L4uSutBW0HJAHTcwZucCDHMk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

please don't top-post.

On 16.08.25 12:05, Giorgi Tchankvetadze wrote:
> Since the compiler can prove the expression will always be false in one
> branch, there's no need to execute that computation at all in that
> branch, right?

It's mostly a matter of making the code easier to read. The way we have 
it right now, we calculate partially_mapped in all cases just before the 
end of the case.

For example, partially_mapped is irrelevant for !folio_test_anon() and 
!folio_test_large(), but we rely on the compiler to figure that out and 
optimize the code accordingly.

Having something like

if (folio_test_large(folio) && folio_test_anon(folio) &&
     !folio_test_partially_mapped(folio)) {
	switch (level) {
	case PGTABLE_LEVEL_PTE:
		if (IS_ENABLED(CONFIG_NO_PAGE_MAPCOUNT)) {
			...
			break;
		}
		partially_mapped = ...
	case PGTABLE_LEVEL_PMD:
		...
	}
	if (partially_mapped)
		deferred_split_folio(folio, true);
}

Could be done, but it's arguably harder to read.

> 
> On 8/16/2025 1:16 PM, David Hildenbrand wrote:
>> The compiler can figure out that it can move the whole statement to the
>> "if (last)" branch because it knows that nr == 0 otherwise and
>> partially_mapped == 0 already.
> 


-- 
Cheers

David / dhildenb


