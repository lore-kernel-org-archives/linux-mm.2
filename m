Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11B1ACA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 12:25:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55ECA8E002A; Mon,  1 Sep 2025 08:25:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 536BF8E0013; Mon,  1 Sep 2025 08:25:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 424E58E002A; Mon,  1 Sep 2025 08:25:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3119F8E0013
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:25:25 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B6B0E160823
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:25:24 +0000 (UTC)
X-FDA: 83840601768.29.DDEAA8C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5A58C1C0004
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:25:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Xkb/L480";
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756729522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ry3HTsvjDYn6ZhWkEuXZ7HIdFuNl7/b7zLeVSRNzby4=;
	b=4h7i2IrI0TGVJ6mtFX4/acbN9VeEti5i6PInLxIsvxg5zSufQympnAPgdzJl2MxLZwXAgI
	S9fU11fsxnc2U89u5j68Ph4+SmspPjRQ4MTJOFy3l5QmUtscTJzo8xfP0WARQCt/Fp4bzD
	0eXsttfcYckP4pIwnIyoz1xvFbEul0s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756729522; a=rsa-sha256;
	cv=none;
	b=hYJEt1Z19GDhriv1sTvHWuZW8oz6ggH+wr8m0iu/qRJidRvClxUKa65lEukvRo9A0IigWb
	+Ww6SdO88Ea02klxrEa2I3eXQukrf/ujhNjnYc/Db41YgJWBZxvJiHGXCC78FiHwv1CUJY
	2OoVe+blabhqWKC6WtEWuv90tglc/kc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Xkb/L480";
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756729521;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Ry3HTsvjDYn6ZhWkEuXZ7HIdFuNl7/b7zLeVSRNzby4=;
	b=Xkb/L480w/F0gcNyYwSFxayB5yRR/0q67Vi+fqEe/ob85rBgCZsGO1X5XsGCetpPsCDoma
	7m01I1cmeCyee1RFkC0qejO+K8yB1wVbKd3mR+hZWqjDhN5J4aa17VkDiAEGrGTDTeoskw
	jQMspH/SDTCuxU87+5tLDkrQftddPxs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-444-nzDPECsrPiK3yzYOvKPwGg-1; Mon, 01 Sep 2025 08:25:18 -0400
X-MC-Unique: nzDPECsrPiK3yzYOvKPwGg-1
X-Mimecast-MFC-AGG-ID: nzDPECsrPiK3yzYOvKPwGg_1756729517
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b83ae1717so21033655e9.0
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 05:25:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756729517; x=1757334317;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ry3HTsvjDYn6ZhWkEuXZ7HIdFuNl7/b7zLeVSRNzby4=;
        b=YC0toz/dEjMyzjbuFFopGGPkLKJQLVZjyfCPSs1sawhiO16k6e3Hg93IjyWuJMJ4rq
         56IGxZvlL8085f9+hizhksdvy8MVns7sm/jaSEpjis4CappX+J75kDKmE64MxnJ3lwyz
         7Z717+wUdmJrnlofB1yGI+logj/rXRij1/nq/bMaLtXpZhVqnGYWACfaZZ2VEl2enIFv
         qc9saKMNzwqu4k3wpTTIVoU6BL8+ZzyDzn1pa3w5Um5A2lkGxxtgHq1pH7QOgQk8xU2t
         kbbUfYtc8SEBRzKyPnxB/nRYaP7moGMI8bw19Rc76XjLz8xWOYHwIG2j9muyo8i8PXDR
         LvcA==
X-Forwarded-Encrypted: i=1; AJvYcCWmF4Dew6mrrlPh3AwLc0XmLFw2z9TTmEFZs1WObJCeSTBLdECjFUDBO+kRNnq55OrkCY7Rkze4mw==@kvack.org
X-Gm-Message-State: AOJu0YyMW3/uQR1q2IVBBUGvI7bXCMMkgeEicYkrKGxWMPxIt2xiNYb/
	AsNSg1/0oubTzlmdmce3LitwBcDn3NRuQKUrH1zTHAvSkDDRtbpObSC6fs49oOCTBe2zScOS/sL
	oK8zboOkg9nHPZfCWarV64e791jzCGMH4xsXM+o61FIHprvaF2hqw
X-Gm-Gg: ASbGnct6MbzMFcL/WhJclEEsh893OKEnjn5Rup4e/KO5DZwaBbyY7EZSOZknYyoQXZD
	BtdQWhNl30noi7dLL7IW/BxXNxpjUdP4ftPbDDqXfjgKuphskV9l1qDVr596uZFTjbuHAv4YaRk
	5ePAqSjSHYm6+81OnYzy8PV7tQmJ2+/k9499dVn1VMEuMLAD+f7UY0WkFJoCHO0YPrFeRVRZQCU
	X8XQk8T8g6tjCmy2OnlNBG/s/zsmfyrhkZAesPo8Bm2SCedZLAFdZknv7gExSZGVsKvpSkAcqRl
	gRu3PqI/bsH6TV45ECHkncanjUcvV7BRYT4SL56QcTGZJtk1ujJSa3e+/UDaRuRCPw57v97AZvf
	qV3lCARtVnOCEFBECGFlrsDAlClyiODQ3ZrMmjTVH7ZUfjfm0GehluIrBw55rFyFvVe8=
X-Received: by 2002:a05:600c:1e89:b0:45b:88ed:9558 with SMTP id 5b1f17b1804b1-45b88ed9bc3mr51982145e9.30.1756729517125;
        Mon, 01 Sep 2025 05:25:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEMGDtOgsZk0c5UDFaUJZJgP3BXCuLTMzz4/00ieMVST2ui2ccALyIM8NlgAkQyyG7Klnzysg==
X-Received: by 2002:a05:600c:1e89:b0:45b:88ed:9558 with SMTP id 5b1f17b1804b1-45b88ed9bc3mr51981875e9.30.1756729516581;
        Mon, 01 Sep 2025 05:25:16 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f0c6dc1sm237238175e9.1.2025.09.01.05.25.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 05:25:15 -0700 (PDT)
Message-ID: <dc21e54c-d7ae-4d7e-9acb-6a3fa573b20f@redhat.com>
Date: Mon, 1 Sep 2025 14:25:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 0/3] cgroups: Add support for pinned device memory
To: Maarten Lankhorst <dev@lankhorst.se>,
 Lucas De Marchi <lucas.demarchi@intel.com>,
 =?UTF-8?Q?=27Thomas_Hellstr=C3=B6m=27?= <thomas.hellstrom@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Maxime Ripard <mripard@kernel.org>,
 Natalie Vock <natalie.vock@gmx.de>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?=27Michal_Koutn=C3=BD=27?=
 <mkoutny@suse.com>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "'Liam R . Howlett'" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Thomas Zimmermann <tzimmermann@suse.de>
Cc: Michal Hocko <mhocko@suse.com>, intel-xe@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, linux-mm@kvack.org
References: <20250819114932.597600-5-dev@lankhorst.se>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250819114932.597600-5-dev@lankhorst.se>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: RreSc00HlX7VWPS1ENEk4zi1qe0KZlUVVHlYnxjm88w_1756729517
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5A58C1C0004
X-Stat-Signature: ujxk9bsxu6mkzcggtuyo6uw8ons1mizo
X-Rspam-User: 
X-HE-Tag: 1756729522-165587
X-HE-Meta: U2FsdGVkX1/agpI0YAVUbjI6RSIQcRBwaBFssHWVQHwj7R9XlZtNKPA6AdYiWDIo4w7h6WI8W8S+Z0I0YDmgST1D4LQN/0kpFqZK81yOOwqlZb8lv3kCThKF2w+01H8dAADDF3ymePZjirID45SwdztjJVuBWl5QaRUcg6bfOkngMAvf3pA7SEFbr9APyvPm0wg8fbrX7dD9nJeSH0t5jyImzEGW7d41VDZWk6Yo7tYkePCIGSOjqn2fWPkH3AsI5a+hnKInWNld+0sFq/j4f8RqgdPu2Re9l5sn6t0ZSxowUseaY9q0Nrmk/5QOu7pTmZ2QbUbxXVBB14iw4eTt66IY9HHZ47qXw/tUkCBBGx4IZWHxz2252ilHRGELGNTFgklF4bViAbr4f8DuNpQruwgdNipOte8TGd6xv9m6AiaL8BfwUflB50zMax3UxH3+9w0HCV6G3DujugVcdVuYnH7TwOCuzCj1jBcUxu5Ecf1C1SGT6KEyuGwCtL/WPRexmS2WBKqnD1irDZ85g1cWanVsTQEYFgsjQKGHNycGn9x8p0ZvM4kDBaKcuKFjK9Rtz9bOvuoBA+BBru5GF/3FFBfhKRTMJx1k4XzR/2MAzl2iBz+QqtjLI8Ysg0qjp6G9/k6FYoR9rIXVeBOWk/UThx8jPHpFokxrwNKz6XoqgxL9Xquf+j6cYpLgpYzRVrvIEBOoEoorEXCMiHOeCgCCvXjg7tqug9UDpEiPxuz1ga8eFABmUAG0tVlT5/P6LEXkYBEPZIzqeMLaDQYvI5rkB/XD7BmMbNRncGXvSgPBdeOlgRgvPXqWhAAMcfWJdyVW2g6HVTxitVJm/4noy27ldM8LH8hv7mbkZWDKGH9VZxG0c4gI1v/PFM+LbLxB6w3pEwMq6oY8qYgtZ9CrI/O30ySeWTyeebxbRoKRxOfm1TjJRT5oNYo+0OyQMdCmuX0ETwgSXsR3zpSb7rjyi3m
 EmEZfzVY
 WKV65y8phIU7cgkYCdH9yRccKY+DifqS93AIeKogLKygH5kTwiXnusNa8lR4B9oOPdQTYsy8m8obBy/jD53n15DsdOwZE74FyEURRldciXLBA8h4fvALjsKSVkwxhS8BovidJM7KRKqizykpSkGVgLr28BesnHS+a1PeTNr2x10n47JgaCDyijgBTV4BZ5sttRnu4gf2VfPqaDUl0Gv3hGHOTVEiaf9WC29iJoAH5z+N2rpqxKtoGVvU3ckl2TOLQo/MlkDgs5dEUcase89Pxh22eSoVMC4vBD//jS1rph2qQ+AZ1WKGxHH4cCM9I41uon+ZIuYvQMzUKH96PiE4C2C2CEQJ6oKo+Zb6uFmcE8OyMfeg2MQa28IeNJ7O1TxrMVYrFXAyhrmvvEv/WeMS33K1oadIYu4bkuOy7Z5ksrG8hTDOiq45HjifYCq4r2IxObD7VvXSadyZseGTplt//sjINaTqzjrBDWP4I8E+ibJ0xWiatREs6IQLH5CaLnNKLwmVn8G7fmrXi4DM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19.08.25 13:49, Maarten Lankhorst wrote:
> When exporting dma-bufs to other devices, even when it is allowed to use
> move_notify in some drivers, performance will degrade severely when
> eviction happens.
> 
> A perticular example where this can happen is in a multi-card setup,
> where PCI-E peer-to-peer is used to prevent using access to system memory.
> 
> If the buffer is evicted to system memory, not only the evicting GPU wher
> the buffer resided is affected, but it will also stall the GPU that is
> waiting on the buffer.
> 
> It also makes sense for long running jobs not to be preempted by having
> its buffers evicted, so it will make sense to have the ability to pin
> from system memory too.
> 
> This is dependant on patches by Dave Airlie, so it's not part of this
> series yet. But I'm planning on extending pinning to the memory cgroup
> controller in the future to handle this case.
> 
> Implementation details:
> 
> For each cgroup up until the root cgroup, the 'min' limit is checked
> against currently effectively pinned value. If the value will go above
> 'min', the pinning attempt is rejected.
> 
> Pinned memory is handled slightly different and affects calculating
> effective min/low values. Pinned memory is subtracted from both,
> and needs to be added afterwards when calculating.

The term "pinning" is overloaded, and frequently we refer to 
pin_user_pages() and friends.

So I'm wondering if there is an alternative term to describe what you 
want to achieve.

Is it something like "unevictable" ?

-- 
Cheers

David / dhildenb


