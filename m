Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1DB1CCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 20:10:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25F368E002A; Thu, 16 Oct 2025 16:10:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 236E88E0002; Thu, 16 Oct 2025 16:10:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14D338E002A; Thu, 16 Oct 2025 16:10:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 044D98E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 16:10:30 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 39C3DC037E
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 20:10:29 +0000 (UTC)
X-FDA: 84005069778.08.5AF7B76
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id D85171C0003
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 20:10:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DUhQegqE;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760645427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M+VdGM0UbRtMsT3TBAGmrGdUEQampC1uqTX4aLTscP0=;
	b=sA2aO3IUYuN66cS4Ul9kLQ7uhMuFFTPyZw/zi7Q9cN0fEY+FwF+BvBiobmVgNC8thNWl+3
	zSmtfImpSS61y1/yAVKMRoL2IvLA+5/c6hVpoNWLpbEQNTNUs1omhP9V05ZVv2IbgDF1YF
	iFC1irvjudx2+4x65EssZLcTbrsXqXQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DUhQegqE;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760645427; a=rsa-sha256;
	cv=none;
	b=0evF1g9Mu1dU8+Ic2TtgUvO1yG3uwCSwuTEjc1z30guvbBpF2bXb0aVsC14T4kE3JdtVQj
	dNdoQmniV9MdP+vMABktB4BaMOOMIX9JlpTv9Qchj+R6Y0t+SADnEx2+BVOAUsI18YvyhK
	4b/cJXdtz3nJiwMwS3pU7RrLqwv+hw4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760645426;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=M+VdGM0UbRtMsT3TBAGmrGdUEQampC1uqTX4aLTscP0=;
	b=DUhQegqEY/RVNahXtsyKLA4DrvoQkBskYwlqyQ5BnwrEWVS6yPBnw6YGNKi3q8QPwB7aIg
	HuusGQrTyCww0IrWPf2cMbv4B68iM5MiX9PtGscsf4uL3WUZGJB6UBp0janGluoJbZbdNs
	vz1Ra64wgaEMPqBtB9OS6Gg8MTY0xWQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-333-f9C1yavSOfu_ofRbTIc1wg-1; Thu, 16 Oct 2025 16:10:22 -0400
X-MC-Unique: f9C1yavSOfu_ofRbTIc1wg-1
X-Mimecast-MFC-AGG-ID: f9C1yavSOfu_ofRbTIc1wg_1760645422
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46fa88b5760so4107005e9.3
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 13:10:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760645422; x=1761250222;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M+VdGM0UbRtMsT3TBAGmrGdUEQampC1uqTX4aLTscP0=;
        b=d3PSeSbvmem6x1lujlBWslpClwTKpvpk+nNwPTwo+H5iH+gcpkjd4DX0dtozQHwDp6
         qHVeFcs57zV+J+q35SYOqgRNLMlZhpnhiZqJ1maX9gfZVR/jmi+69LAXAXb2fQqANtPl
         EC7MO21X5YtPZOVptNe+QcfZ7kq9fFWyPiJIHXcH6ORr5Bcbhnta4IqV77tKv+CBr5fo
         jTgWsZfsalV/Jpw18llV6wBQMfxpV81UrCwobe6bTeSrboS5PWHcm9zDoSmqQAGrl7ix
         wkIPyr51YMWG8U3xIUHPMgdgbXsiLHS82wAYLtSdyn7Mv/vABGjyrDKRynQMcwEUZlk1
         eLyg==
X-Gm-Message-State: AOJu0YxAN1KI7xJfmoX7jIiMaTOIiHW9wOqBCQSd0dwHRbu+lv4PBcU+
	XN/3nzpNUGWcsrlB32ElvgATweQjor2Ud2zxTdo50KWT74y/Onki/gn8z9WrYIHiYrrK9BIWzA5
	GHqMB5t9QJ8pIJrmeF2nej6wlGuiNgdw5CIN6KjXVqxrHC+Yi+pfM
X-Gm-Gg: ASbGncvWzWBBH3HdvFN0W6In7E/pC8keyf5QfsEN4Un4uVg3W78fyWJau9NSv2wKF7M
	fVnsJ9rkxJb9k9YUvL2FXYhEIDhyq5GLHO5Sf31F+baY7sm5kt/Pp51L/ZCe6UvfQ7vTZxyn1z8
	c+SKLREVqcFL6nd4EhBffPrOQe25d8ryfco9tivaZz6J7sd+euQX8J7Hn9XigGPHnRwSPvYgQKa
	f86ESiUZD7MICVeuMOe88NGM4NK8rs2AOvFlo7TrcU1njrSMQ3sidWaCxXgjLdyIO9eN2A+ilI2
	QmuYZKwXx5qR/uzoDgJhj82iRZTQplgyaF/CWx4JlWjKuI8RlLhngDi2g7OFtOj3V0AulcV5O2g
	MqpWqaZZby4Dgpvsb7e0wpcorKHcg2Exkios7thu+FdH7q14DnJK4qFZLZLL9iRtK8JYy9lInDa
	87JXLk+UrY1/y+XKhAG12V/bO08GE=
X-Received: by 2002:a05:600c:6291:b0:470:fcdf:418 with SMTP id 5b1f17b1804b1-47117911694mr9392055e9.27.1760645421758;
        Thu, 16 Oct 2025 13:10:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG+GnPGkb2zNI7ov1Rfz2i6B5C13+a02AQ6xFKfPA0OrCbdKXgC6k2VmFJaIsNQaDWfMGRyHA==
X-Received: by 2002:a05:600c:6291:b0:470:fcdf:418 with SMTP id 5b1f17b1804b1-47117911694mr9391915e9.27.1760645421395;
        Thu, 16 Oct 2025 13:10:21 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4711441f66dsm43882315e9.2.2025.10.16.13.10.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Oct 2025 13:10:20 -0700 (PDT)
Message-ID: <99d5c245-3b0f-4b33-8d44-bc2b203a5a51@redhat.com>
Date: Thu, 16 Oct 2025 22:10:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2 2/2] mm/huge_memory: Optimize and simplify
 __split_unmapped_folio() logic
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev
Cc: linux-mm@kvack.org
References: <20251016004613.514-1-richard.weiyang@gmail.com>
 <20251016004613.514-3-richard.weiyang@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251016004613.514-3-richard.weiyang@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: L1jUmF4o0mgPBKZa_b2bmb9s_XbZEWVbNl_5F9vCFdQ_1760645422
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: kqjb4wib47t7qka88499ee8hr46bbd7y
X-Rspamd-Queue-Id: D85171C0003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760645426-553376
X-HE-Meta: U2FsdGVkX18avDa1YMIoXv/U/r01iUQQ9KxtitppkloH/dKWwcocvYjmMohWyo9czwUden4ZicUewC4IJM08zvJV7SlmdQRQzHnO4zq5yUBMUl2Ltzmi/c1+KxXqXyM4O4xIbfbT9tjPoEF14laqG5co8pOq6OBLtp8QxFvGxgO5gGp38OCvV5SWG+QsPxqMX2MlPbGCWVdL2YWRnP0ETQryqRGwQnBIjzrwSZ9MBfGmNlOt4W7Lagk95PLsznAloDkOc+GNx0g+5cworMxgq0QGrGcNXh1KVCs5U4tQd0D2LBDga6Yr0xe3J0hegrizWsOZHPIubC0e7XyDt2u3taWXOh+sDjhAqdax4ydIlvKsPEkcig5CJ9eT80SZxg/F7PU8/mo2C83DdDkHoBE0iqTtcAjStul/uu75oFNaFTFf4D5t0PRobsiGcNc+DRl40bWlR5912BGQcTdTmKRZ79p2bjSsDnzcDs8zIPoalS+Frh/bV+37AKKF6aqri6qRu+4Ah4T4TXW8U3Uur5aGpn1FYviNeVVf1BOuVVCDrY/pxJue8N5SbZsoivV+eOKQWeqX4leKsgGOlHD59FqdZPnxyu2mlSzDiELTtvHUjgD/UDBbzkn8+3K9J4xJ5flswEjGssxm0TLX1HXipl8outupevBhz/KHMQMI4f/eXsJEjdihNipvHV2kLD4WRw62jdG/hS33nMVHAd5Snyo6fplK8c2eXCQN8cCgXhxqvVOTGWpfEEvcZsg6IRECtSK9xjXXXnxfSP+F+3R1fOI7wxBUABBZqjnN3Kml1xEFwVwzWUYVKyDByySTb+59GMcKFRNstGljMOla3bPNa6vJUl5hpUBy7quKcZO8aaN3dDyGP2G5R4glIYk0+E+JxTXyvYnP7Nc+G1+YstFntfFjRklR4BcETKNYu0dnXGaV+ydyfbYOpH9ipdnZozISwuPA7O4Q3iMoxs+MbMUp3cw
 CgvN5ht1
 Ul63X3NJ3+cFk7vjIBMjeB8PCY+uHsLaCLHYeLJplhgDYN84R0AcWH8AAy+REcMCSKkSVHChLYrE6noTh9MZJnqZukyZAhWF/af/TNEokojCvrxSoVt7q3sFVeePMVfp66vJpYD3q7zLkpJ1HxP4dznIh1CXz14yzkIzP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16.10.25 02:46, Wei Yang wrote:
> Existing __split_unmapped_folio() code splits the given folio and update
> stats, but it is complicated to understand.
> 
> After simplification, __split_unmapped_folio() directly calculate and

s/calculate/calculates/

> update the folio statistics upon a successful split:

s/update/updates/

> 
> * All resulting folios are @split_order.
> 
> * The number of new folios are calculated directly from @old_order
>    and @split_order.

That makes sense.

> 
> * The folio for the next split is identified as the one containing
>    @split_at.
> 

That as well.

> * An xas_try_split() error is returned directly without worrying
>    about stats updates.

Why is that change ok?

> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> 
> ---
> v2:
>    * merge patch 2-5
>    * retain start_order
>    * new_folios -> nr_new_folios
>    * add a comment at the end of the loop
> ---
>   mm/huge_memory.c | 66 ++++++++++++++----------------------------------
>   1 file changed, 19 insertions(+), 47 deletions(-)

Skimmed over the rest and LGTM, but it's all a bit complicated to 
understand.

Trusting on Zu Yan here :)

-- 
Cheers

David / dhildenb


