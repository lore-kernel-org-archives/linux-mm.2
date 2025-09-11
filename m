Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADC6DCA1016
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 11:45:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16857900005; Thu, 11 Sep 2025 07:45:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14017900003; Thu, 11 Sep 2025 07:45:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02E7C900005; Thu, 11 Sep 2025 07:45:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E3BC9900003
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 07:45:33 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8C5E1140440
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 11:45:33 +0000 (UTC)
X-FDA: 83876789346.21.67F8E55
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3BD508000A
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 11:45:31 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=J825L5w8;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757591131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o9x2oRFTlaYelJ4HJOq9E/+ntiY6YQznCq+0jBgMBus=;
	b=16VUfHaemGcL0Mi7c9keo21pGtQepexwDbGpVhJETNk9eOutOXn/1q44Ztf6eWBGX2noAS
	o6G2JSm6XOB5E4/7FSDceYZ2yQQLjVh+4S/vydNFlW8H0KF0/IjiFjjOStdSW3/pA81f8L
	jQK26ixADYF6IWLpqXIC6oXluVkpzzw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=J825L5w8;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757591131; a=rsa-sha256;
	cv=none;
	b=22R6O3QHbJRREH860AY0RoSfpcp0tN9Wda6uI8+BSgMXMFTHqVHm+yO47mlPV9tReO+9El
	l2K6nn5il+a1OgHt8DvfowDhy3SLUEwPnScIEnV/ENs+JfUPYtExT7bSed+qrTVRqZ5ofm
	tUDpK/vIAIQ69vZ5TQTBjr3oFnsZGA0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757591130;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=o9x2oRFTlaYelJ4HJOq9E/+ntiY6YQznCq+0jBgMBus=;
	b=J825L5w8r6iyD1979AaveyOLikKnFT7wjgIlfYuowBsK1W3a3C6b7v32nK9ognI9D+KsHL
	8meK3fdESZ3xV/J2uQStQuWtPswe2KPrPKr75gajsnedwsgtmmSJcEj825OLqFz+kFnCSe
	vG8fQN4l5Un7nuBqfVtXFg0oxgszV50=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-145-Kh5SaS8iN6K-AaEjZ9K9mw-1; Thu, 11 Sep 2025 07:45:29 -0400
X-MC-Unique: Kh5SaS8iN6K-AaEjZ9K9mw-1
X-Mimecast-MFC-AGG-ID: Kh5SaS8iN6K-AaEjZ9K9mw_1757591128
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3dbf3054ac4so364840f8f.3
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 04:45:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757591128; x=1758195928;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o9x2oRFTlaYelJ4HJOq9E/+ntiY6YQznCq+0jBgMBus=;
        b=FgIYfwXN3a3ybnM+C+fkSL7VJKK3oxlQt2DC1W7Li9Mhe9CSrtQx/m/gKp36LaLL79
         6GyU3Rq/wJ5H0MOgtrO1djWjbxJXRIFA/F/EFtsDiLAu+1ND5amPu1ybj+c4fDUZxzT+
         Ydk3Oi1ZP998iOIyLxz9HgHFrqMxAJXj5CRt39IikDJgj5/X9UfFUbt6gfvAWA1Ay47x
         ijNL9rjoI26OsaTdZkcJzuw3tom1cY/AUbtl49jTqmch0hrSqKrePamHAjpcIo0N6+Zw
         XobEVucvyqY0d50NAnoMOva1Jp7UGDYXkwZFAGC+QSC5YlaP5kCVK11uv249rYbwA8KG
         HOkA==
X-Forwarded-Encrypted: i=1; AJvYcCVnToqxP0h23h0QoeYAcpSmPC9lvR3xCaCMb9kGdHr9Lo0qQXXsp7h4AqPQ1ZykHKdZ9Uy18rryxQ==@kvack.org
X-Gm-Message-State: AOJu0YzzqmV0d1k/6HLubvb9c05ij4VEMMAiHptW2BW6LAQ+Ut6N/5cP
	E8uxOJMjl/VG4hukb1GsYuPrUsLWLO6SrtkwF3SjycptutEG+lVe7Le4D4wK6ZM0nd0qhIICgBa
	oZrLigymbOKVcSnnAOrifcs8duGYG0a9GOlYI0aKqe5ZEmD8dagX2
X-Gm-Gg: ASbGncuZNN25/9r++t9/E9DiNlUxWz6kzPkTk2Xoh94pKGqL5XVPP4f0Y1wdPkxw+54
	WmZWeH8mYXqD6MjvYWK6cTX6/cXPh0wLjp4Oy2aa6rqfAtIbsIkYbGukn6VqXNmWhbdOVEsh+ze
	zfrnzskY7PwEk7k5En3IBIiI1jRVt5iCXG3pXSxOtyuQJRczjNWZcOjPVAFPkwZD7TEY9leBC1A
	fSnc6C6YIILFombVp1MwPbmp2QNHPTYh6xDnRGL+70kHsNi/CaMMznoszZ2r5CflLqJUKx8ONR4
	gwSw685bjjwBpgUO8CtnO2lO4y8GaRKg7vSkzSxNPunFWT6XdMlsIWdlPGCrjkAVEPk0GI75mVS
	i9Oi0y8WEmFM+uxZps/KS5CLDLEaSzVIDJwRBu6s7tTH7r7pPlu4gjgL/C2Zj5cTExto=
X-Received: by 2002:a05:6000:4023:b0:3e7:5fca:2177 with SMTP id ffacd0b85a97d-3e75fca25admr1970155f8f.11.1757591128140;
        Thu, 11 Sep 2025 04:45:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEa0HyuoBMgXbrgW1aKPyOqqhh/6si3sYzr8/7yDCFvLAtQpjNsjahBvQsXtj6+uXFhjaDQfg==
X-Received: by 2002:a05:6000:4023:b0:3e7:5fca:2177 with SMTP id ffacd0b85a97d-3e75fca25admr1970100f8f.11.1757591127572;
        Thu, 11 Sep 2025 04:45:27 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f42:b000:db8b:7655:f60f:812b? (p200300d82f42b000db8b7655f60f812b.dip0.t-ipconnect.de. [2003:d8:2f42:b000:db8b:7655:f60f:812b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e0152ffc1sm12562165e9.3.2025.09.11.04.45.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Sep 2025 04:45:27 -0700 (PDT)
Message-ID: <8c5267ec-cc85-4eff-b890-eb705472e2b2@redhat.com>
Date: Thu, 11 Sep 2025 13:45:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v5 01/15] mm/zone_device: support large zone device private
 folios
To: Balbir Singh <balbirs@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: damon@lists.linux.dev, dri-devel@lists.freedesktop.org,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20250908000448.180088-1-balbirs@nvidia.com>
 <20250908000448.180088-2-balbirs@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250908000448.180088-2-balbirs@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VYKqLOAVPKgN98rMjhg_SgzeW2eiIRVle4Cex6cqcE0_1757591128
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3BD508000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: o53ee3t74z6fzfca7j8ioos458k9krak
X-HE-Tag: 1757591131-404634
X-HE-Meta: U2FsdGVkX1/oCLHhGcQXhGFOmbQaLFWKmkftFmbS1yTmszoeyf4EGoGNTlFhhF6DOI7/REV/8/N7r7JTVrB7Wvh+3hzAlNiEyeiJ81/ZMZHf7I1s5T1OH/I3ZJYofQtq01sqXXmeqOWT/sJ4Hi6sB6m2f3Uo4D3ZHMdY4stoLKY4VLgJkHvnmbDs0prXAMNDuLkyRKtd9Tg8YaJkcaiGSbb6uqsw60ROOH7tVwIE9W3oy6KslBLcCS1Lz/vVqyA75jS+MKav1wuCgJ1NHvOwWwFn9hLNEVmDkfwMJARFIV/vswoCefl+P4ylS4MZ77cQP4sLBCp7YZPDtnfW1va4K8pn9v2iaOkADD7S2AzcLBIQp6mqz67SB1xL4iEj796vAKlzKh7z1BWyHi5xyr9y2fvWk4LA1CetnrhGPv9G2OmmyuA6cDLU/D7kP44WiYDWMRygZ++d4/6p0pYuhofXKZg1b66fhrUHSeU7eU/pWrcchdDB2sUbI1XDGT3/C/59VJSeK5gfVvEXVLgY7xd7tW4qFgoB5xXSJP3nbY7+c+cEilgdeagKhfAoxcItIfjoa9yRnz0Y9K5UUXsgcTKAoqNc/xpy9rN2YpHuRDgwjLx0d4uAQKJgQK1D1EiD6rG56KKZeumFjiDnHpz0iobTjMWfvoyP5CCRrh8VKqtSQh2mRDgpubFx+lCEbOAaxktaulAofGVGu/ht9UBVQdMeJJcIqi405Wh8MVMIanFxx+QRTRvjwqw78N4DkshpmLE9aw/BkSEXQpbUpsRoKdobDAlDCow4zY/AjiiYJ58Qqzd9Ot6UESr+WSONVTzL86dOYuihijyiU1aD95tjfgs0UcUTmyUQ18L+onkScl5luJ6LZnn+7INg5XJmLxrIbVK0ZGX3HbxikjQEbmLVLFy9oOoKbqH4T7dByau/BMKphXoxA/F2RETHY6SNlEgXeHmg8gkuXojPWHX+mfdBide
 Aki5sIsr
 WTi01cOjnznCscjrhCQ4h2lrRGgvaG5SEjifionUn/siTfkCp8arFZ6BA+lLXv/6U5dBqivyOHXjUrr7Qi9lPN24P0acUNgWDFxtTDP7SgYTPYIdxp50ZwlpgcRhXqwL6COV/10jq8Q9Gj+OEmIjBemtZK2GgRh8BUHcv98rMXjzSoBQPHpebhqsKaYgeUM0XGO5ibt63c++LTJYQ8XYiYnbCAy+Xv5woBk/FMCToS2PM0zC08haJEHqso2E5lGuajsI2wbT5a0gvd/azTB9r5mi8HwNhs+x7XKloIa1lbrQfAlvL/h92x1nz8QOfg06vtsbiAvEmQCJvX9apfEULtgVOhAkO+vnQByc3xoxSe8Ib77KWsOZ3P37BgWLCNvKDD9fU5shNnf4MCN7rdDgjRtRuPqOHKa5KjvmCvqWYKHBBaq8tGXZSzByRf2X02amKAHcGvV/l8GUhEjuFSMYPbRHGu+YsqGbatJsLUog3LEvo2JISGNWpJseqBj1HshjJTlvPB7dGidQwBbTQ4z+BEDmAN/gfYBvTbF7Ae8jRc5921G6H0GpXaqGNfQT8grXuZYBIEjAEyI+EsvzZhYvUZ3JMLA21E2BtG9/jMDPHMFozMoDYEHh0UtzUFSgambyQIvTqoAsBjM9l0aL+S0Dk5h2yy1DkXpX6xQrl9IRvcQ+/1zxhovtt7muP4z3SuC5ufQB6Bkr8UIcljZ9Etae+Zwi1zRfMoHga8VvAdT5A+LuyQ4SFRdYVVDSniBkzq4lDR/idyk9LHfSFgc81VRi0tytgM9YcugsLT1MZJ/F0+uA6HLIRsI1QJ0OOeVlKgxLMrXNjcXEWnx2n2262vjoyFjuMP04OIRXb3TV2UFihPsTSRH9ioywBSmETmnFlR/h7hnvd5tcu9zAkyihq3BIsc5JZ/JthncjvK+28vLsSq1uAwrMRbuMzOBvQEg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.09.25 02:04, Balbir Singh wrote:
> Add routines to support allocation of large order zone device folios
> and helper functions for zone device folios, to check if a folio is
> device private and helpers for setting zone device data.
> 
> When large folios are used, the existing page_free() callback in
> pgmap is called when the folio is freed, this is true for both
> PAGE_SIZE and higher order pages.
> 
> Zone device private large folios do not support deferred split and
> scan like normal THP folios.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: Rakie Kim <rakie.kim@sk.com>
> Cc: Byungchul Park <byungchul@sk.com>
> Cc: Gregory Price <gourry@gourry.net>
> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: Danilo Krummrich <dakr@kernel.org>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Simona Vetter <simona@ffwll.ch>
> Cc: Ralph Campbell <rcampbell@nvidia.com>
> Cc: Mika Penttilä <mpenttil@redhat.com>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Francois Dugast <francois.dugast@intel.com>
> 
> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
> ---

You missed my comments of this patch in v3.

-- 
Cheers

David / dhildenb


