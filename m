Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7DA7CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 13:58:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43B328E0025; Mon, 15 Sep 2025 09:58:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 412B58E0005; Mon, 15 Sep 2025 09:58:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 301548E0025; Mon, 15 Sep 2025 09:58:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1E5E88E0005
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:58:57 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BEDCA1A0696
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:58:56 +0000 (UTC)
X-FDA: 83891640672.01.3126C98
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 613DB20009
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:58:54 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Ny/6R/Em";
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757944734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KplBuZ22IZOGWRL/FpbuNQDyW9jhWweOev+kRyWsIQM=;
	b=ncN0r2PY9LEnSAN5dgai0YC3ZzeLuYIRvUE0NMhXkFMl1kub04pqA4Ruamk859Dl4787HY
	ms7CQlhl/FWOJ+lN6Mbc4Tr8+N8/q0FfmxImjT6SGQATXHfPLDrpqvF52lMcvhzCgL83xK
	Vawrkl6m4BBtzHgqOi4/jkeNgJN47DU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757944734; a=rsa-sha256;
	cv=none;
	b=FC6bt4P2fSVW1ozTSeB6bhsD6JU5v64s/oeSdZF4mnDC54sjnpV9Ncgzz3aV+4vfJL9LWU
	ikQY3MTWmJingi9llWk5t3EypilxcPb4gJSpZR2YvZHPD00hZR6J2GrtfBMb8RG7MIKq/5
	9eWD3Vcxx1s1gh0YxgPlo3H1n/380rs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Ny/6R/Em";
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757944733;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=KplBuZ22IZOGWRL/FpbuNQDyW9jhWweOev+kRyWsIQM=;
	b=Ny/6R/EmR8evkSV6B+ouFv3zLTBVKpJceZNsXqlFYyNl/tVJ15VgsrM4tpNE1h0w/kEwvR
	HUsZq+E2sKSE5qfqRpv9cr8vh1ajCr5mJCGt9TSVP4njoTvsnf953DfwooVyh4IkLn4wRi
	kBeWsHKJiVTmj2eM1hE0x3X1F+QMpOs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-465-ke-mrwxoPD6HxHMkO6bFYA-1; Mon, 15 Sep 2025 09:58:52 -0400
X-MC-Unique: ke-mrwxoPD6HxHMkO6bFYA-1
X-Mimecast-MFC-AGG-ID: ke-mrwxoPD6HxHMkO6bFYA_1757944731
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3eb8e43d556so315180f8f.1
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 06:58:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757944731; x=1758549531;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KplBuZ22IZOGWRL/FpbuNQDyW9jhWweOev+kRyWsIQM=;
        b=fWPumWCBjHz9SVQCKUxCqfIM+QUHKM5zmjCcRf9BuYuSoCR8N5b493OFHopFwD4sB7
         +WsNuXnHkmMCUhY2fQw1qM08tUFjomAQpQu06i6g1O1qIo93vWNg6/vVoJD87/W6zUju
         vTyNWu/gE17ANB/czK4toAYPD1RTBRHTDBbRaypnqd8jvOZgv4Z8/S6zglHRQr59+Mvd
         PsznopjfrYLE9Oc1dp82/M20oZmGzooZiYJlSTMC72u7m/FhOSSnKP3XItHLBFKXe32B
         6Jr4a+RMnTXjzNDo9ttZg14j5l9kAiIE860HtMJtKoJTwW0SxfZzkpTYuXijx32ioQNf
         wreQ==
X-Forwarded-Encrypted: i=1; AJvYcCU9aFKl5ijj1ugbmGdGLcQySVhbsVLWhbj7tqZEaCHyxKXKiRe4gJ9J5z//swhTG0TKhprauCXvsw==@kvack.org
X-Gm-Message-State: AOJu0Yy3bBfzBsWrrrnmcEwJb7a9yIfSHKIR+/TnNd+i+wn9WpGgPKio
	Ublu1sPIJt7gwJ5bzzz/vF8MdjapHXcUPUoSgL44eAZs+czTQ9boTKGCGo4Yd4+enqxSwK3jITB
	JgvP2jJRKYX4JuF7qxYNKYAReq0mzsXnOfRSazP6nLdiCVx0vxQ45
X-Gm-Gg: ASbGncuHIa74XwmzwkjSl2PdWWCXiEeugbAJKQbRhw2wH8sS4IOZRV8KCut3lHwcS/7
	797LPHqnOS6inW5wi/JT+0GoPN1ArqcOx6eilEMcyguB3b/irVBLW+tdGvYTNDFqwMCMOx9JBtN
	BhIUUisVhAMc9Oi9k8xx6hd+EEUZ6SKMriN/wtY8bwEHgIKsNHaB00v8de9nhWSQh6Uc3vaPvJf
	/lVL164WTbYha2fxW7m7r6H53iUvg4gUOitaxWnYRrhR93lJPG2GtgSPPsuK/atZESSk0soAJ+L
	zs00pq5r86gycwRqG+RTCOmoWkLNK93clsajLTdmQb3BWkwSykEW+t9ZBT7w/pb82lDn5gL9bAD
	JqI4ErX8nkstLnMqDfGsAmojtrKQXewVgfS0098rq98G1KGjB/XNkkED005MEPjCU0jQ=
X-Received: by 2002:a05:6000:2203:b0:3ea:c893:95b6 with SMTP id ffacd0b85a97d-3eac89399f3mr2857007f8f.27.1757944731351;
        Mon, 15 Sep 2025 06:58:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFIBtT4aq3cbJaZEsloIj9LKZOAl7+0MXz1dTLWOlVPNL7ugkjzjyk5jkvOXhyuIKcyfXFb/Q==
X-Received: by 2002:a05:6000:2203:b0:3ea:c893:95b6 with SMTP id ffacd0b85a97d-3eac89399f3mr2856982f8f.27.1757944730925;
        Mon, 15 Sep 2025 06:58:50 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd? (p200300d82f18f900e0ae65d58bf88cfd.dip0.t-ipconnect.de. [2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e859a278c1sm10646171f8f.24.2025.09.15.06.58.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Sep 2025 06:58:50 -0700 (PDT)
Message-ID: <c852577b-69cd-4267-9a27-dcdae2b849bb@redhat.com>
Date: Mon, 15 Sep 2025 15:58:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2] mm/khugepaged: Do not fail collapse_pte_mapped_thp() on
 SCAN_PMD_NULL
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <v5ivpub6z2n2uyemlnxgbilzs52ep4lrary7lm7o6axxoneb75@yfacfl5rkzeh>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <v5ivpub6z2n2uyemlnxgbilzs52ep4lrary7lm7o6axxoneb75@yfacfl5rkzeh>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wgc084nZJ8Ig5_cEq3baMWmxk72-6nbnCUYYmrHou_c_1757944731
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zhjy5cdny68hqdn9kkggzpjcjrzg5jjm
X-Rspam-User: 
X-Rspamd-Queue-Id: 613DB20009
X-Rspamd-Server: rspam10
X-HE-Tag: 1757944734-856736
X-HE-Meta: U2FsdGVkX1/1mpbQNAAxF9/FdUkX87HCMOIQ/3Kmkd9GhajNw6NfLlr4V/+SRxN7ChWhx20gQ/MrwUzOhH1oAZXaKEM+uxI0T30fK7C53I7TZxedrheElhfQIo+Xu3kkGlQ9Df3fIMSaT1kP5iXrtVmg0GvzTbw0V0WTSzRZu/Do2swgB3CyiPVCrYrDUmQQaIj62/RUd7b4tixUTxhg21rZ2m4ABcjPdzI6BLNclMz0XoOlyfbTIB18u+0nA9e7kE+vnISXngaDr/gYls/A1zojr//VyIHoHyF7+hoXXnxxJynRcK1CUqnr4AxOk0bvJts0PrfpaSYUOvNidY4lMguZ71yymGEi+wVOKXCfXnMm8fmepfD94MhrpDiMltf1mwm20OOcxG+CIkxXKacEpnYRMvZa5IJX+S5zztEEGESTZbPyDiWwXrzY19xkUt9QL50gkM3548t4Z95UpFTwCuEW775ekhlkmInyoQFMUghNnkQpsBIHINB64btD0oDulomS0j5ZDCExYTH+TEzkVHprjw4ldkdVZ9X2SAWdojMnwBytwAYyOUiBQ6azfG1RyoLBCtkOYJRZjX+C5qDftkGtRdmlRW7LAmm3kjBto6pdZ4v32jqMsloyuMaKEzsMuf1NwAjz8iwuE4S9JIavvqGeQtyPjquU7sy8ulnCxfhi9x5bLxJOzQQzfA3YkjPu58XsMy6MTfjALTjglfMdF90TYR6OxlS5VlT/8hUKkdUpt1+X/PivCLLoo7ONMuY/AF4nZKBbQuWoXmiodRa5oYbJo9GyhmJHMSlGPmA2Y//4pS7hea4Z8+vCLVHnJ0tEtqCr3RG+BJ0oC7EFf8m1bUo0znCNwyRZTY5li8LKVnTIrteXm8hlWmw6WeiznqoFT669RBYdbZ67xcv0w6jnAYfu7zqnxlgLQWxVElcZFQlEVq3ULPp77lnHNmxHnYToR98Dkuz7PBtCeaJo78q
 9cCmeifs
 4hYWKI2UKG79GA+WjX6Laa054HRkCKBaVUht26o9mz3+S0rOARD7apXuicWmkCgClgOxFqd4NZ6/B6GbvKM1yeHyDw580O4Az1j9k7fwh/duHMS5DkXR9lvigWBiZsQF2OF4oQ7G2WtuaEDF793zJEV9+taxh3NN+TOlK4OiLqKyYxvmJXo+MzszDs3Yl5Q6DzKG93AQdbCPciaPBru5ND7mBWZl3kVvEtr+J1PN499UvBuyU6FxEivjM77Si+vStj293KBJQvy2oeV4xrABf3VSpQ4O1hNcvHVVJLC+vGbAwq7UGDRIC59WDvpDyy+J8TQyWjSxv5BjtZAHZYIaWKA8T0Kt7jL8/L27UY7L3Te1/r+c+ul6xBiaVV5TEoV3uPh+v+fFNoI1JO/Bau93QLsqQ51d/H9S9JdY6UE9xmuBrNhj4CGm+rYxNFcBLrWm9qoUR56L+QmJ+q4hlWFb21M0hStEtc/eDw8DMsZ3YGlM6ZzTzKOInjWQgQQd4JhrcRpf3Rqq6anU+S4I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.09.25 15:52, Kiryl Shutsemau wrote:
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

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


