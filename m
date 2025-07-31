Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5040CC87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 08:57:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E42B56B007B; Thu, 31 Jul 2025 04:57:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCC686B0088; Thu, 31 Jul 2025 04:57:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6C926B008A; Thu, 31 Jul 2025 04:57:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B3E916B007B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 04:57:01 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 53B81809E5
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 08:57:01 +0000 (UTC)
X-FDA: 83723955042.11.9662EF0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id CDFB0140004
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 08:56:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=R2UWelSW;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753952219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M+5TNyfQXvfnFi1k4pdD7pee/s+gNchOD8LjTo4BFGo=;
	b=FsOaEwrPXW/9ToE7PGAhl14bkF43VtGbDSgtlsOSgpRdAtydYwihDQpk0JxxdwmOnnLrlS
	ptAjvBFuWpS11JBvKOd38HXVJM6LqOoUbrYOyOF+/s6Kcs1/ncMl9yyQuM3xPZCMm4gJJL
	8e7Iw/plkZt9FQowNIyCbCVFWD6oOe4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753952219; a=rsa-sha256;
	cv=none;
	b=mzjg2iPtkORHcauV2wCRhMZbT80ZCSXo4DXsZ/Q/zb5FXPLZ6Dh+A4tOLZRbbY5edMpi7Y
	QjKWeEaEEOHTwYQOLHP2v9Z0Tw7Xcyd0YT+GWB2cuHvWRTEI2KOR0k4ujKcJ2Y2SHpm03L
	treURyA9iwFRLWzAB2NAsYf/WnTrcGM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=R2UWelSW;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753952218;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=M+5TNyfQXvfnFi1k4pdD7pee/s+gNchOD8LjTo4BFGo=;
	b=R2UWelSWYD4k6ngZWgPfZeABCHjBoMG6e6hO74UdSTpWz8iPlWxrBcrH+IylGnNHhMvOXM
	rqy3d4UDewpz9Z3NeCU539d+1jvnZam3ugNba/UEofovecVow75zzrwaOqtEa/IuZS3wJT
	jQzn9KtwJCoTbfcAzEwcA0sc+IatQoQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-311-xq4d2pDoOeenxWkANJrm6A-1; Thu, 31 Jul 2025 04:56:56 -0400
X-MC-Unique: xq4d2pDoOeenxWkANJrm6A-1
X-Mimecast-MFC-AGG-ID: xq4d2pDoOeenxWkANJrm6A_1753952215
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3b782c29be3so106044f8f.0
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 01:56:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753952215; x=1754557015;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=M+5TNyfQXvfnFi1k4pdD7pee/s+gNchOD8LjTo4BFGo=;
        b=nxS4uy3RPiinCLgb7OM9gS48oN+aag/qVr80xoAu1b6DHU9NL5MxKKsrecCg/q6I8d
         Tv0d2iC7gf0iAtfhdzaFTEXpm1wwPBQ2wslLTIB8tnoVnBuEDZVmD7AVG6L8w05HHiwQ
         WI2HSbM1LkHFU5jH8mWvu5lfyvyIQOXwU7yXSVWehJwcWz2P62WLpe6xFhtydwVpxs5d
         ntY37KkageztM0ANksstHywPtIsZf9+mfebb9IJsTipAFCW4Rq4RbC68NPN0qN0pn9jF
         PjCMcPPXOWezR3ipCtR9W8/gUhBd8ormv8YLq+6FWcTlUa3Z4hJdVPTEs02DkkhH/y61
         gDfA==
X-Forwarded-Encrypted: i=1; AJvYcCUGOgKz95wUlPPx2B9z1jIUNlOyqHOLk3QqnKXsQS9wFuj/wjwWXtmWdfEs5lDwKinvlW4Ru4L7Fw==@kvack.org
X-Gm-Message-State: AOJu0YxJtrtOvSAIhSPhcB8VOodF6RIUfX8AzYvs9clzIUyOzlbWcO/a
	VHNtnddZHLhxYnlIQtBzisB/1Y3f4IpDk23RV130Tdw7ePbupsCPvzD1NsoDleNI5RtbvRVWc/6
	4yh/ynrW/LitMm1odyeHb1ZDxf5sDtlZW1sq3QngfeHRh2+2QnKNm
X-Gm-Gg: ASbGnctyQy7nfoq3AMoiydCaVZKoD0b/NM6VtX2LnBfo7WIqGslPYhumQ6pBVlHqaYs
	7IGzxMT8jXuPlQpcGacBUcHIy5IFuXbueEn6kzlcM/TLQUM9I19faj77sSvG1mXygg8yLFuzUcT
	6NjN9Mi7eNGLXyCTnW22c1nTnRDyfhz7rGqV7toPAJKmrHsWx+DQhmz3s7w90zvLmy6WXA1b6hC
	kLSrrkrtnJpxpQrNXGDCSoAWJ0GwhbvyQOm7eXzXUJTKvnBC4BCQTFrJHaFcJ5/DxbSQ10ZMfpR
	+/Xrei5AU/nMb0PFMZqNVM2BR5WMeJ/7Lvqt0FQJKYMQCBnjtLUKn+NIiDVhU8fGnUdm6eFHwPJ
	B6/WKZGrGHrllJK+/THGtkupAiO0zitNIgKUFIeRcinTwoNosb/U7i8/t3amCFtDq9js=
X-Received: by 2002:a05:6000:230a:b0:3b7:6205:25c7 with SMTP id ffacd0b85a97d-3b794fed24amr5151697f8f.13.1753952215140;
        Thu, 31 Jul 2025 01:56:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGxkTppl88wvOdBwkP99hPIcrhZK2fqjIYGywzpVNBSO26NwhtR9aUcLjL2G5jko0Gp1MZknA==
X-Received: by 2002:a05:6000:230a:b0:3b7:6205:25c7 with SMTP id ffacd0b85a97d-3b794fed24amr5151665f8f.13.1753952214679;
        Thu, 31 Jul 2025 01:56:54 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f44:3700:be07:9a67:67f7:24e6? (p200300d82f443700be079a6767f724e6.dip0.t-ipconnect.de. [2003:d8:2f44:3700:be07:9a67:67f7:24e6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c467994sm1683864f8f.50.2025.07.31.01.56.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Jul 2025 01:56:53 -0700 (PDT)
Message-ID: <df265383-476c-4f0b-87a0-37b5ff8e203d@redhat.com>
Date: Thu, 31 Jul 2025 10:56:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v2 00/11] THP support for zone device page migration
To: Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Karol Herbst <kherbst@redhat.com>,
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Shuah Khan <shuah@kernel.org>, Barry Song <baohua@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Matthew Wilcox <willy@infradead.org>,
 Peter Xu <peterx@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>, Jane Chu <jane.chu@oracle.com>,
 Alistair Popple <apopple@nvidia.com>, Donet Tom <donettom@linux.ibm.com>,
 Ralph Campbell <rcampbell@nvidia.com>, =?UTF-8?Q?Mika_Penttil=C3=A4?=
 <mpenttil@redhat.com>, Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20250730092139.3890844-1-balbirs@nvidia.com>
 <e0153fb2-af59-4bcf-a07c-d650fa56d55e@redhat.com>
 <1fa09b2c-4845-445f-9343-3a169e202ac5@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <1fa09b2c-4845-445f-9343-3a169e202ac5@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: CUuwRqyUk7DG0-u2v5HuAGA7HUybjYoGB90lDB3XKA8_1753952215
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CDFB0140004
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: i8q3tw8e1n1ukxin9p55698w6bxccn4k
X-HE-Tag: 1753952218-110132
X-HE-Meta: U2FsdGVkX190MtpPMSAJCeKikyaVbOr7SKNXcqDlg0BomXajYvd1CV4nv4T8ax1fbIUQ+ozY3XJH+vKevhpsBlyIeXha28tlUHcF+VPY9cBjpW820lzwFXMekZMz2daFJuE9nqTZ4WUKVr5vHrRHqgQq4lUyxhwhWBVib9g7n/A/qldpFLNvAGL0qPb46fB5daVpn2/6QGJCLjZG9ueDwZH5hta6/6F7cch+B6lGcBB+QPngaftB4Ld0RYjXns6yj7IvrJn4NfD/msCdpf0scF6CfcBsaLEGxWms+QDJMr0P/ewNfZnR/EVEJDBOUMLJKHguZPvCasNfSffrowXDrkkZcEruAwU9lVhi8aYnoVRUHnbkR/cw5tGKs5KglYdKpJFYvzgAdLTOQHVKy23zC+1/9iDDtS+t6ejxX6UJ5q7xz1djlEwYe5Pn+jIQ7HWUgjPC7M6dWKCVGUOSrxQtncUW1FuNZlB6IcYWRAwOylJzSKq2rvBrN1eG3lmokYYMtSbQ0MbrG6SrObwViNZwTYPMlt1nRsvubwHhqNBzK6cTgrRZ88yd5cbQrgNqA1wW6VWsl3CCQpXVdbBeubPu0io+qvup/YZD19SW4JHf5anPHlZf7Vc+5pBDclb5TM6TYvskdQGZttTA9VAfuDqz0FAwhjlTQdBsuaphqud7pJfCw7eKaPhrYE+U9x79LuzpfwCveRTBPM9E074TzDdgVt0SrENiVyedJdmAlFF6bLwrmanEyoYVgRWk0cyJHau5xbS/vM+VOqkZuUEq1dRmv/VdeTdHJ10xkrOpJgTYhP8XyZWBuY2WVrZzuuC4G0PI1/d1Z7VMcEa5uUDs1tXq7QeXexYEvb4hvV3NWLyu5JnG+N5yDzZdOk8d24rWx6xPZ/TSZ36kSyYjQWETiIgaUSf/EFdIkqIZBsi5YYQPMcGhDb/ju96ATXsUMRaw5/3rJj4zHSeyYmYymAlIloj
 v0FD74n0
 47Jw158CHskDqENKfhHSb0n9Vgq09tAmfY2YabR1QANz+xX71EQMBb+NGcmHlTcsEovWOp/OhscavuZCG7V3VCFVBTsXpHw8AitEkeYkK8WS8LrbZtF1eYSF0O6dePA5WPjq2tSlZ/1C0M32pnlHwJR3LL8mB1l2jS0UllwR2GnP4slRmHGb/frQt5UooDdyT0Z4YwtkoNP8eb2iGwdJ8yQzw8u6JTdhidUUQOj+8zIKPyGAajAhoXCdyTQSzrdvxXK3/kG41iPgDKPtRLJdszfhPJ6Ghnccv6YPsdrGKyhi+Cwj/PZ3DK5bpKz1j6qfjP3N2nPPUS2JK/PvAVDBWUgurBL5bJ9+S2bnE7wkc2GC0LZ6RqaYWdJg5dOw9x8BxcNL45iuzm7Cndws56TM3/D4GQNCuuBM77AYeGky3avZSqcYKF378Z2juKQLuXvMLW8vSATBtQzJtTOkbkg5AXArmBg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 31.07.25 10:41, Balbir Singh wrote:
> On 7/30/25 21:30, David Hildenbrand wrote:
>> On 30.07.25 11:21, Balbir Singh wrote:
>>
>> BTW, I keep getting confused by the topic.
>>
>> Isn't this essentially
>>
>> "mm: support device-private THP"
>>
>> and the support for migration is just a necessary requirement to *enable* device private?
>>
> 
> I agree, I can change the title, but the focus of the use case is to
> support THP migration for improved latency and throughput. All of that
> involves support of device-private THP

Well, the subject as is makes one believe that THP support for 
zone-device pages would already be there, and that you are adding 
migration support.

That was the confusing part to me, because in the very first patch you 
add ... THP support for (selected/private) zone device pages.

-- 
Cheers,

David / dhildenb


