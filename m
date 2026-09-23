Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1EAAC98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 05:42:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F8046B0088; Wed, 23 Sep 2026 01:42:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A98B6B008A; Wed, 23 Sep 2026 01:42:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4979A6B008C; Wed, 23 Sep 2026 01:42:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 116B56B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 01:42:39 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6C1191206CA
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 05:42:38 +0000 (UTC)
X-FDA: 85243932396.30.FA1A692
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id ECAA820006
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 05:42:35 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ID+KMPHx;
	spf=pass (imf13.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790142156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Owanqqlm2F+zzhHdgO4ILjDMn6+LQqunLulaO+aFb4U=;
	b=InDfzmTT1sLHu8fKkuWjTxbtxqmGeWkyqSvsP3CoQOb0sDumNbtSOD8gAzuklduLnP5vzn
	GRc3Ki4BQhP3ohfMGgAKGplQWk6QvYZRVKFq6iIU/rB6iNylZ9MwxwF8irATEHI3Fyhw4u
	YPvpVdHRV/3IBn9tc29OLghEtg8fPic=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790142156;
	b=r6sj3x3lcTJEdVAGRbamGRmHUfipMa+n1JRFsAgM8pD4u+7Cevur2YH+S61O7YyhaWagQ9
	e5gwdrTx53f7VIn2KHM4it7Z+T3fLSO9lAjFZAeh11E1/8EvU1XankCgYzhQe5SfkS95Qk
	1NavODWFqzF61Y73P1E4G9rmw4h/SWI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ID+KMPHx;
	spf=pass (imf13.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790142155;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Owanqqlm2F+zzhHdgO4ILjDMn6+LQqunLulaO+aFb4U=;
	b=ID+KMPHxfJvnQOUhcKBuOy0zCXb6WY9IjAE7jqI3dMkA2kaNkN9kKVQlUvn4w9hzQ9A5pq
	OBasZRF2bjyhYXKFWnKOLDjddatmaEOEFOVWeustLV4M0UdxNWeKOOEo+yA1vCF7FkIRKj
	u9QR/dgHWZ9WCAAPucRlw90vug8HCHA=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-589-zbTf5o-fOWqm9CmZL6UgsQ-1; Wed, 23 Sep 2026 01:42:31 -0400
X-MC-Unique: zbTf5o-fOWqm9CmZL6UgsQ-1
X-Mimecast-MFC-AGG-ID: zbTf5o-fOWqm9CmZL6UgsQ_1790142150
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-3a3395e2d7cso2385121fa.2
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 22:42:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790142150; x=1790746950;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Owanqqlm2F+zzhHdgO4ILjDMn6+LQqunLulaO+aFb4U=;
        b=LdlVw7QzlJqIrZjrj5WmZOjExBDuv8JoDmGf3pxFjkygUbMzdHvdc1aJI/akBS2Xyq
         sP3BxiXuGFmXMTG2fHOTrcxY09fs+uyqlFT2KTB2NnUAYm705vvo3w6hl3lRT2kpbQcy
         jajta8+MYtGS2x5jX+wkHwVk0OdrVUvaHLpbUToHIv1buSsMKWESurXvPkUuIFduj00I
         M0pwuIssOjRkBwFiYYdOgXDcXJsT+z82x8tQTilbrpaeZUnypp397pHTUva//SwFDET/
         TzW+qyWn3H+gr/cUGapALG0eDeIa3BUEt79g3Ydg+liGE5jhYgEFZkPrA/7Nhvpysgo5
         Zkwg==
X-Forwarded-Encrypted: i=1; AKwUvByyZQ/QCNcqWqMjcn1BKw5WEWrMUW4nyG87TuP2vwkNKQt9jKH4iFnaB4pYOP9q0u2PBRpq0g86XQ==@kvack.org
X-Gm-Message-State: AFuF++ky3qg/lNQxAWpFmtZq9GD1C5drRtH/puSMK1ypQjxTPvcD5Ys6
	dA9rdFF5uTcaBER/oGk6I9nW0XOcqTb1oO2x0Y21V2/B/4MQkeU7WKbWi25xkFFdmMnsZ0Cqvdd
	5uMK8XOfHQ2CeuR+kJfWBQ9pktiOfzjPEWW1Rst4yntmcaBehydY=
X-Gm-Gg: AYBFou2MXI8YBngzhd6gZh4mIsTXEukQxPpyBV4q3ftdq2nNW1NslK9Mfdk9KkoQSgO
	hb4eL3ei/YMq+4buBIOMBijvxPNJTkncfN1mZMJkXz9xQutBV1kGKLYxa6AYekM0iYvZ9roX8RS
	uwH+hoUxyRb9PeNviqlzqovJ2Ig3xtmSdy/Gl0m9/yzT52pr2QSTCTc22i4bmTA+Mk4OkAcs+Zh
	VeG/I1NnJx36BThsLPpZGeohUCUv9mo0e0s4U7Bq4u29REAh1u2VL27WW/zGg8CDxjMZb56wvnV
	zY18gFvZE/88u9sz4Lf4E5FzTdD6KpzZhYc6I8OJwEEHMFsnQs4lHdCwUGc+MPln5NOtFrd8PTG
	QetbFPEdbhG4gAnCYsBQyO7Z+/7Rowl8=
X-Received: by 2002:a2e:bc0a:0:b0:3a5:e541:4205 with SMTP id 38308e7fff4ca-3a630525d38mr3157881fa.0.1790142149998;
        Tue, 22 Sep 2026 22:42:29 -0700 (PDT)
X-Received: by 2002:a2e:bc0a:0:b0:3a5:e541:4205 with SMTP id 38308e7fff4ca-3a630525d38mr3157781fa.0.1790142149515;
        Tue, 22 Sep 2026 22:42:29 -0700 (PDT)
Received: from [192.168.1.86] (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a62f4f10b0sm3956141fa.8.2026.09.22.22.42.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2026 22:42:28 -0700 (PDT)
Message-ID: <8523ee92-04c1-4e52-a418-a3ab110bca38@redhat.com>
Date: Wed, 23 Sep 2026 08:42:27 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 01/12] mm/Kconfig: changes for migrate on fault for
 device pages
To: Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, David Hildenbrand <david@kernel.org>,
 Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>,
 Alistair Popple <apopple@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
References: <20260922053421.4092027-1-mpenttil@redhat.com>
 <20260922053421.4092027-2-mpenttil@redhat.com>
 <c2b28c18-3717-43d1-acba-05eaf9b1b9cf@nvidia.com>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <c2b28c18-3717-43d1-acba-05eaf9b1b9cf@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: pl6GnJpD3vAza6KW7ccKmD1Q1sTrrHSm-svlIvDzkus_1790142150
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: uaj7j5hwzta5b138si6nf3zystfmktjh
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: ECAA820006
X-HE-Tag: 1790142155-680247
X-HE-Meta: U2FsdGVkX1+b8GZg1O+ctN37HiBqgyf67JXtPJIYuPX9Bz0ELUDaWEiUmiXTBqcSRgeY/rxJawgomwzxn0kzLQoeT17Cacxm/vlPWxKC2dy/nQFmIu4hxLqPjcA/wB08EkFCxwYGC6n9QuVc+HzO6OSbcSccBo/uNTLCRMJTLxmAWpwRyeDVXIv/+fxOhV+OdxKWjdZzj/zryl9BlvEdi7AN0GsTtpmsR+elGENf299uHxjxjFOJ20iabohNpb2pSHnamed7AblZPNQc49YO1LNw5DMgQSrAqWdxxsgA4PbT7VZnQlKfCmp6jY6UxEuOB8FcK8mQZzdl4nFw5XakfWNkHL+M/zEQa43r281nHEY3mX//NHBP8nYlm0z18TwsTmphIJbgLlxmd6YTSaaAIJcj5e/+4d0qYqbZ2rWODUyYSqgZrfvUukUZ4NBm6LZ19hskViDxzUoyvV3uDCRLrm9uvztjATlmlfOku1BYhbwocr9AP4ZVpwOBmDadrGCIABU+KYNVlVS2671d3PIZWxUrTKoYuMA8zoUMRAQ9eGHK33nbfZpjJDrxyN8bzGeB4OR/TOyNJkO3Pts+ZRZ/+F4K1GkxI2+WiBVofh1O1gCGq2SbQsPYlLWZG7Ff5VgRi6i0HNP/0R8kHbO7eq5DhvcOMs+6PEvqLib8pUVOWOZ7LWAhW6VptwqnRQDb5mfHQD6k/02yJiBHujXhj8/sJfn+5rhMlOEGecdYw/gdI/yOh+YllFS3SwTDQojUz+Or0QJw84qI1YJ257orn7M4BGmdCoGQCd1jhkMaqQYq7CjvsBxUKkF3ZmK3uKwPIc98EK81QGgF668lez5f2bSDyjth7rcIbR6I30HeVTG/oHF9DF3G5E4U3MFdqjd2HX2RxoIKreTJLQt3PryXqteVuUw+u+AB7poUqTubq9W3oc87Qru5SlXUU3TBEW5X6hswKSTOIkBe/J4LRHYEin4
 Q7qw4Qe4
 aO0za3qJ+Kp44gQsEKmmlSBh0zkt/s8DJYDtkpk5EQbJ4/7OW+M5d3VKr4YvVQMVXrnlvPJxMOE1NX9gwa2/Id7/XnVxzsZ8c7+Y8FJ1ETZMAVD80RiewKF3xoQWNUdt7cmIYaQQXmxfp/oc17txh+XQquG6tl5lGEyhHs1mJGerLuRbYlgyQ22a/Aycfej1D9WM3mZK9RL9hTMf0VfgW71qnkKXyiHTZ3tQwO/XKeMND75/9vHN6jNAiFnKV9K60gn3KhnIzGNeUn3gJI5ddrzdWJf4yf8JGz5t5sXD8xpHxaaWh7GRUTj4qm5UGYW9bq0P6phA+fY7sbgLUx5F+5VaUqf+3qGsO6rnijCC8upuXD0nR8iPbe6lqCmvGyekzCtff9UTeZzZcFe7IytlsFp1Wdt713bA9I7xWe217A18Od6vpj8T7YuIi/IP0/zTbv3VUfiSx648Fnt/Z5BPVBD7Ca7nix0xshnspqFn3soxW+MMhFZM0i8nNYAIP+xMPsELQBikG9oggrEy4ktuUl0P1CmxQjc1lXBKjzBOhZK8B19o5KgNdAB5/sTaHTGtbkLRO6LxXdf6bpQggWWkFl6bLy7TftGwy+EwoKFKrQ+7gRSsh/UdoL+Z0KVmGcIhfzNV0PnF3mnTKRAD/5P1LVbFem632Y82zik0DqXiNq3GEPgm8B93gwuKeeuTFEZIDlyGn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 9/23/26 01:27, Balbir Singh wrote:

> On 9/22/26 3:34 PM, mpenttil@redhat.com wrote:
>> From: Mika Penttilä <mpenttil@redhat.com>
>>
>> HMM depends on MMU notifiers. With the unified HMM/migrate_device
>> page table walk migrate_device needs HMM enabled.
>> Enable them explicitly to avoid breaking random configs.
>>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: David Hildenbrand <david@kernel.org>
>> Cc: Lorenzo Stoakes <ljs@kernel.org>
>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>> Cc: Vlastimil Babka <vbabka@suse.cz>
>> Cc: Mike Rapoport <rppt@kernel.org>
>> Cc: Suren Baghdasaryan <surenb@google.com>
>> Cc: Michal Hocko <mhocko@suse.com>
>> Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>> ---
>>  mm/Kconfig | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/mm/Kconfig b/mm/Kconfig
>> index 604c58199acb..b7a485beb9a7 100644
>> --- a/mm/Kconfig
>> +++ b/mm/Kconfig
>> @@ -687,6 +687,7 @@ config MIGRATION
>>  
>>  config DEVICE_MIGRATION
>>  	def_bool MIGRATION && ZONE_DEVICE
>> +	select HMM_MIRROR
>>  
>>  config ARCH_ENABLE_HUGEPAGE_MIGRATION
>>  	bool
>
> Acked-by: Balbir Singh <balbirs@nvidia.com>

Thanks Balbir!


