Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A56ECAC597
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 08:16:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C03148E00CC; Thu, 18 Sep 2025 04:16:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB3DA8E0093; Thu, 18 Sep 2025 04:16:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA81A8E00CC; Thu, 18 Sep 2025 04:16:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9859C8E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 04:16:24 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6659B1DFCF6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 08:16:24 +0000 (UTC)
X-FDA: 83901663888.20.A3F4A8D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 132141A0009
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 08:16:21 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BUp4Uyb+;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758183382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G/5PObydQBTPKRhudbGOIVgXgkozXKhQR5xYk0UPbFw=;
	b=ab3/ZnwFW2Nq73kCB+BT8iONuW4iLW6/ipOvPmuvEXgQOrphdWl28kTsGdP9c4EbCqBib/
	tYJBPMfLRlOD2hWanH3nqUI9dMnx+Q/7dsIpHARtW3qKCNDy+GHpxNLjgqWS7h2Wn2m6ms
	mgi09qXFaLdWgldU+PRbyh0nW5K1YTo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758183382; a=rsa-sha256;
	cv=none;
	b=ihsYt6hQahkFOQhG/VG3iJU8gsc+ZOznaDnPnJlRX4UKolYnCc5F1wHRLXNGpIiNfHirei
	cB4HGtP7IELnm1MJezT+A85w89Va8SBTM6o5SJKQHgzOXXiXcysLWONL/dLTOUGxu/k5F7
	+UqgUXGZCUVj553fQIV9niSWSAUkKSM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BUp4Uyb+;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758183381;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=G/5PObydQBTPKRhudbGOIVgXgkozXKhQR5xYk0UPbFw=;
	b=BUp4Uyb+ocTfjU7fRmOz7+6KhvuY4XW6FdlS1tGMLzsjk4BW3DaHVndKlhuu1W/O5L5NGR
	yVnYo49O2brZmgixPXcW2EYgd7lUGDve8tOzW8iqMMk/1BJiMRSm3H63F8iJC5PQL0q18F
	xspVBSZvMSPLzjvx7ZTuzyFSyKbHE0w=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-507-2cQepvrEMymY9RPzh0Wizg-1; Thu, 18 Sep 2025 04:16:19 -0400
X-MC-Unique: 2cQepvrEMymY9RPzh0Wizg-1
X-Mimecast-MFC-AGG-ID: 2cQepvrEMymY9RPzh0Wizg_1758183379
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3ecdc9dbc5fso390545f8f.1
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 01:16:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758183379; x=1758788179;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G/5PObydQBTPKRhudbGOIVgXgkozXKhQR5xYk0UPbFw=;
        b=FTziCwJQ51nHNjwnydh8qXvfrjBxRYp2Xn0ph66QJf2vA9+3EVYubQNqOfOuQ1UtyA
         VjQFoJmOzLayLwdD8si/HOyqvHonkHszaTPnyZCLPlf5Knyw5kttCSdrZOCZA6+z+yoe
         3+Z87/WMGoRrnNcNIA3Myj0ppJoK6p/dg449WkpLEM2mIlDZQlYmckgG2jsRaS3jlsjF
         i/MctprvzhSv5G0HG7W8FF1Q09rrYfF1PC2cvWG2Tgm+2uvTrr0tfYIaqwQhJdGOuE59
         pcRQLCiT7hnkJvYC+/Ml1k6W+t+Z2yJgeWi8vFYQD4GK8UFI9mQexzUw0GR23xRGb+Zg
         ymng==
X-Forwarded-Encrypted: i=1; AJvYcCW2+JSb0MscrQcHj/L55xbK/DooM5fuiuc4pD3qpC7Q8EVEpQYK7UaJ70q84NIBL8YV6iUnqTevZQ==@kvack.org
X-Gm-Message-State: AOJu0YxbM3IZ6q2jBLuW7wSyxvXYn5lC4Qdl9S/gvbi8oRYnOwGAysjq
	3hJ112mqsjsNdesfVhrSn2vcys7dGWWcY4fp5kS3MD1b9ytnFUu2wXqpgwgBv2J3whCOgARm0ze
	U1Eh9IUm44At0cUfs7oi8nJ/VJUuqVfFrmWjDEyDBihFhvMbKvrwP
X-Gm-Gg: ASbGncsFabfa40VhotE8DoL+MJaiueXf2xACXnSQHpDAkdkAnJMyPrrxS8mD0Bsftek
	kkU0eHuRjKDShSWNeID73MTwvdvbd8S753YIS8Akyy8XL3YqKMqFlnfyBW4dP2/6Cpw9DkWtJfJ
	NH1TV74IodyDgBt0XC9STQcS9ZBRhIfVLUXvUpd72k0NUskNWcUN8BcE55zyXQoLXkRdCIMZB6W
	z1bvBRePBrOLak5sJVTZ9l4CA3dbG2iCm2Ky52PehY4ISonJvejOuJv5Z4Ts7gcmIlIPjGe60G4
	7ocwNKREMHPIpUh7NASheVQatkH0e95TEY48kuRhaG0MeW2xB+DViP4VzwkeWFNrSURNpb87won
	qElGrfmfryGd2nQczMRwu2OJQy7Q4VR2rGxsx0FFSPG06N0144l1R2gXlogqJrzegkKIO
X-Received: by 2002:a05:6000:2012:b0:3eb:2313:ec03 with SMTP id ffacd0b85a97d-3ecdf9d1628mr4864897f8f.27.1758183378607;
        Thu, 18 Sep 2025 01:16:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHtt7vZBRj0+uFcgr+tMEMlGdyMOg7OfiXBQjB5T17V9Ui8y9E//Vz8+/m+TtE2Xmiz5a1NNA==
X-Received: by 2002:a05:6000:2012:b0:3eb:2313:ec03 with SMTP id ffacd0b85a97d-3ecdf9d1628mr4864857f8f.27.1758183378121;
        Thu, 18 Sep 2025 01:16:18 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f07:dd00:ca9c:199e:d2b6:9099? (p200300d82f07dd00ca9c199ed2b69099.dip0.t-ipconnect.de. [2003:d8:2f07:dd00:ca9c:199e:d2b6:9099])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee074106f4sm2570434f8f.25.2025.09.18.01.16.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Sep 2025 01:16:17 -0700 (PDT)
Message-ID: <780aa9d6-a85c-4050-820e-c0ca9f5bb658@redhat.com>
Date: Thu, 18 Sep 2025 10:16:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vmstat: add header line to /proc/buddyinfo output
To: Ye Liu <ye.liu@linux.dev>, Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ye Liu <liuye@kylinos.cn>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250918071741.526280-1-ye.liu@linux.dev>
 <aMu01xIkj-3hgW88@tiehlicka> <1a9f44a1-855c-450e-9dc4-415a29b90011@linux.dev>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <1a9f44a1-855c-450e-9dc4-415a29b90011@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5XzS4Ta5uCKlNhHBNQrahd9DdQ7B1arcdCXflvn6K4w_1758183379
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: b684nyfmyednpq97zjq95e76e3h6fuwy
X-Rspamd-Queue-Id: 132141A0009
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758183381-899364
X-HE-Meta: U2FsdGVkX184VyEeO5pCja+s/OhN59O9Op5oPfunEURHiPpu7ulV8EbZQ2pCaS4sHC+TSWWvCZcZNkDsI+NUQFIcT22aBNjQXewaDGmVWCwBfvxXiT/QrD7huTOrcTxOypVLcD0NAZX0Ha/l//bC/o4Jx3XoAaob/KpfGKFO0TzLprsXbb5AtzYp5zaL+tUn6vhpcH/RARAiz+Zc8VWxrSoOWk3nW7D/gK8SEqjuDUnGxVHLbnhKOTqdbl6QpOjX7E5YRiTGooB7Q06lRaWXoFTolcH45+H44dm3h2cIk15ey6UYigVuBkgGht6f5T9qgeUPxGPgVYei1r+BwccgLId3dQt5JPLTOXQFhdv05jWehSKP/8+R1J5Bph9fX5T9tWIY6vp5QnjRMjtiD+43EO+nmql2IGDXfBsSAZzQU/QsXpaqY3BCAnhor2LosR4ox45OEtSj/SQrckBtmNk4vDGXUVR1cqjhw2w0pLRDtr6Lje10kUqTFMZGsXodXjN90GYQhsGioNO94IEf1gCPcYvSONgCLhgFkz+j4oouEnaucFwPAbvVIYYtfEAFZudFs7K/TfZFvwlH0lRpZOmsc1jOTxzXaUKSEPr4Dj36JtbUs7BOpjG2j8XRxJ1mC+tILAAOPbZfVolj6JKT+x1QOrchKxX9LydiLFERGkHgNuXLsFBYxw+fXRnwFnWUyWwVhLw5JDo11hVJ7koO+AcnTi0iSKJl8+1DAFWiThKYazkbvY2J5LiUDOorId9DjqXuPvs0unevegppBay19jtFjb5umPsthBd5Pb/HOde6ktO3IDeh/KdF5Ti4NEiVbv7VWk4HDQG1An5Q5IvYt9/uJfIxAr6SiAgnBNeXsF73vPYyBA2g5ymLkR2b4619WjZB68UpKZCQUHeYVHxOH+GuvBdFjOw/cexG6sAzXPQJ6yzfKYcpeeXZZxCDALT3xKGJwq1ziFvow/SVocHUymP
 f8jUI9Fq
 9mVFzDm+t8gYjrsQFzMHmaQ8UxrEMvef9FLlSGB9ckw3PwlNN1u9/X7rDyoNEKtfnZVMJa0kqS5536s1wF6T54NLEtmbMCNqkE48meWD3AfB/XU1hBQjIjQri7VUBLrYQowxVvF0IzECperyV75mnycxBOXUcy500Hw76Jp8y9/uzcNTIcA6/fCcn7B6SYC44OJkqKms3g+fFIY+d2an64pu9Dgq1ofD3shwmNtLEdCuuWwSUt5GN6x5axidW/Bn0HCK3lCnNkXpAZZrtgGGib2Nmpblwa5eY+CuoXXBD1FpOxK3dFVpi88puXd9n3Qjp5J2jMQPI9m5PD9LYoBijqwzKNPQEO8DX1HEJOtEJICAksOYaSmgVCK63WApWjnUKo/lcwtiyS2hUo1kbSvamHsVXjicsOIphi1Zu3a+Icn6GsHTSR+f4bDdbstyz9hm//oSFIM0L4M1CUXI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18.09.25 10:11, Ye Liu wrote:
> 
> 
> 在 2025/9/18 15:29, Michal Hocko 写道:
>> On Thu 18-09-25 15:17:40, Ye Liu wrote:
>>> From: Ye Liu <liuye@kylinos.cn>
>>>
>>> Add a header line to /proc/buddyinfo that shows the order numbers
>>> for better readability and clarity.
>>>
>>> Before:
>>> Node 0, zone      DMA      0      0      0      0      0      0      0 ...
>>> Node 0, zone    DMA32      5      8      6      6      7      5      8 ...
>>> Node 0, zone   Normal   1113    351    138     65     38     31     25 ...
>>>
>>> After:
>>> Free pages per order       0      1      2      3      4      5      6 ...
>>> Node 0, zone      DMA      0      0      0      0      0      0      0 ...
>>> Node 0, zone    DMA32      5      8      6      6      7      5      8 ...
>>> Node 0, zone   Normal   1113    351    138     65     38     31     25 ...
>>
>> Why is this needed? And have you considered tha this might break
>> existing parsers of the file?
>>
> 
> Thanks for the review.
> 
> The reason for this change is simply to make /proc/buddyinfo self-describing.
> Right now you have to know which column is which order; with a header it’s
> obvious. This is similar to what /proc/pagetypeinfo already does, e.g.:
> 
>    Page block order: 9
>    Pages per block: 512
> 
>    Free pages count per migrate type at order   0 1 2 3 ...
>    Node 0, zone DMA, type Unmovable             0 0 0 ...
> 
> Regarding existing parsers: the patch does not change any of the existing
> “Node … zone …” lines, it only adds a single header line before them. Most
> parsers match “Node” lines and ignore everything else, so the risk should be
> low. If you know of any existing parser that this would break, please let
> me know so I can address it.

What if there is a single one out there that has hardcoded to skip the 
first line only?

-- 
Cheers

David / dhildenb


