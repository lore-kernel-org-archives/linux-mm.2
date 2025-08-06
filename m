Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD17FC87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 20:06:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E8F96B00A2; Wed,  6 Aug 2025 16:06:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 499CB6B00A4; Wed,  6 Aug 2025 16:06:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33B826B00A5; Wed,  6 Aug 2025 16:06:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 202C96B00A2
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 16:06:54 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E81095AD8B
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 20:06:53 +0000 (UTC)
X-FDA: 83747415906.01.6588953
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 51A5D2000C
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 20:06:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WaCWjWb1;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754510811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GJ5H/AIPeHLukWekWKnQHiPq6Mf8Cz48drJCJ8whLqI=;
	b=fAmdEnO1zpyngDbGXF0RVVp/i0KsfOkuYL99y24rkQpIyx/1tbBmcwCVpniSgmRuXow8K2
	OC2YA+QvHlKtcTvhUns3VnxMM08CLMBi3Z+qV+5CvLOPFuYLfBkViCTBYfJCwhABw77E+z
	QvgY06hp1n22GQ8mc3AgfSQE7OfUNq8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WaCWjWb1;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754510811; a=rsa-sha256;
	cv=none;
	b=ugd9zdvHsndZ1NEf/FTC9/VGtBvbvSpaYBqk1l9pPo2r3VzlNpt9dnyI8SyVW8J7OjNJ5L
	e1Y0GKMJ7x06GHmxHmyG7addm/l+vDTC5sOCJZemdyImtIZkKlXPUts5AsTPQDFDNUruf1
	vM8HqBtESiq3Yt5b2B5Dmzvga/3hcJo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754510810;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GJ5H/AIPeHLukWekWKnQHiPq6Mf8Cz48drJCJ8whLqI=;
	b=WaCWjWb1cuf/sPBWR9n60f8Whbbs5heYrBqQ0tVFTEHpm/o75Q6JTlulcdhM9E7V/VoUuf
	L+QZn7gyW6YXFz0j5Y7hFZVBKemfLunxNBWb0fFsbEFjBhrXX3NMDNLwnAbmDMWTQ1euRv
	wpWVr3fGzaUJmEBoAlzeZncOCYklUJw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-572-su-haQ52NfieCgm6eyWIiw-1; Wed, 06 Aug 2025 16:06:49 -0400
X-MC-Unique: su-haQ52NfieCgm6eyWIiw-1
X-Mimecast-MFC-AGG-ID: su-haQ52NfieCgm6eyWIiw_1754510808
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3b79ad7b8a5so86901f8f.3
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 13:06:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754510808; x=1755115608;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=GJ5H/AIPeHLukWekWKnQHiPq6Mf8Cz48drJCJ8whLqI=;
        b=e3ONX5+82NvUHhkuXZzPLvJinzzOl7tG5FZoil2QK+l11uZg7Fo3GJS569De9Ni1Vk
         Z5eDDSz1zB+oZMU1B3q8nVjad2DinC3rLENg1ioCq9+LO3dDQdIzZnJ0GaacUdicWLHR
         qKX84HwFKTCBi99XqgTKwGH96a+z7Av3C3i4NdoSfqZVyA/LjUcm65EdM0ZJUdpNAMmV
         YA6mu1JndG1jIeYlnnia4jpR3BoFChR3mPPgv9bFzvQ3HF0Fzg4zeZ1dB/DtmYe53nJr
         miezWD1Y6OJ3T3W3nlL20WzlGHEHh5A8Llz1gecF5nhifRW5pOMmBNw7HElp1ZiByqp5
         kQRQ==
X-Forwarded-Encrypted: i=1; AJvYcCVr+uACKA9rJ9qWrcSnsyFfDmsmyxc6tDYXUHsNUymZiD9eS+0669v4VBVsj4C2ETETxvduTEd6EQ==@kvack.org
X-Gm-Message-State: AOJu0Yzz+0awqeMDUxwVIhuxP76f6rSoVG+cXEIGUi2WN01hE9AtVd1E
	KchJFceDzDZYZW9wjvnVPnK/u+EWkpjFpHrct8UtxwPKn7UKXHdtd4ysCE1WUqNsjZEhhD6CIfL
	aapiMN3yODEg8gt6DhJo4PavPTpRMli/xkhigOq5EK04/Npru/OSs
X-Gm-Gg: ASbGncs94cdKXZIzd1NFNBGTLZW4o14nz5OkGbIP3enQvRGrUy0QsE/qDz67lIuY44f
	mNCF9J25x4O3j3HuQEhRmbBjL4fT3FRXtp/JzQnSV+nuQumLK3NarI/s6D/z1X0L1AEVNStkNNJ
	6nAPOYsZIY1A4jo7ecprpTI7KDLbDmblryYtGtytOT0IT9pqs7v2PJ4X7SQBMVfAfn+jiD3NLQj
	Dv+Mho7AnpTVCI9LHZcBxQWCP7FKRxUARuVcFkHQNz+EKdnIkwdPljuG2cvuEd6AIsdAT6S/ur6
	aTvjXK96wUYsx/cf3uHDVZPy7iPX4QTWGJI9iMrAwKTV34d5XAcwdFLI8WPNJ7V+gUFMtRE=
X-Received: by 2002:a05:6000:2485:b0:3b8:d901:fa33 with SMTP id ffacd0b85a97d-3b8f41ad591mr3232103f8f.42.1754510808196;
        Wed, 06 Aug 2025 13:06:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHwKvTA1/FVCHzgwsnSeHG/W2ZTK0EicBHSibWy5AFsnV3x3+BVIKtUS15h4G7Ic7YZPZtoXQ==
X-Received: by 2002:a05:6000:2485:b0:3b8:d901:fa33 with SMTP id ffacd0b85a97d-3b8f41ad591mr3232078f8f.42.1754510807673;
        Wed, 06 Aug 2025 13:06:47 -0700 (PDT)
Received: from [192.168.3.141] (p4ff1f974.dip0.t-ipconnect.de. [79.241.249.116])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3b9074sm23670680f8f.17.2025.08.06.13.06.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Aug 2025 13:06:47 -0700 (PDT)
Message-ID: <ab2f8752-6bac-43c6-b889-f5940a6c94af@redhat.com>
Date: Wed, 6 Aug 2025 22:06:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] mm: Correct misleading comment on mmap_lock field
 in mm_struct
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Liam.Howlett@oracle.com,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Feng Tang <feng.79.tang@gmail.com>, ahuang12@lenovo.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250806145906.24647-1-adrianhuang0701@gmail.com>
 <9305bdaf-9455-4c26-befb-471466f952ab@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <9305bdaf-9455-4c26-befb-471466f952ab@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: stuf8GA8-mxcOMrY4SDMYeMkSjfP-ebWewH_bjGTRT0_1754510808
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 51A5D2000C
X-Rspamd-Server: rspam06
X-Stat-Signature: 4k4jyx8zn1bhh9jpkziigtmi9m43sxm6
X-HE-Tag: 1754510811-15239
X-HE-Meta: U2FsdGVkX18UWEzQdLaIwIxEAiFdMKZQQ/c0nv/qBWbfXDNX/XJJDEyj4XU9oW6OYqhQlTI8diRP+eD84dpeZAYwQPaetDxe7MP4RBJbBhYP+XdGUvFUyH9iUh6EU9Nz8NSoyn2IDPpXWlq1+wmOGLJXEwQeKpFOxUBTvKa83Egr+JB46Og5Int9jKlQIAQbJSMv5C3OiMlFU18limf2X/3OYxtH2yuTpXF+oV/ou7KsukvuIqrvhd2dwtEAw2/c03K9ZxGj2C1X5h/VEb1PdHsIIIblFjg1YhIWwF8ySWphJY2Tf7Yx+uuAr7iH4uwppSH1/CJd5s8qxqghMjBooAvmXnRJOaZsWsQaOLpkNcL/tRgFfZGrYNphT5hpEEQ38DJt3P+q45uLf/a93oD/6IT33rrkw1R7ykt6uzgxwIEvk5dJGGawpHu7ItnVeeLWhA680YUH8L/Evl08SsT5oKnzD+uO2X1AiHPpsLsr0AaE776s1QTHMgKUXqZJ1JfI/glWuXlpHrzarvBmAm+o92C7kjhZ9YRGRSNjMvHBGvN2M9gAQthexTrNv5c9iG3l3Dm0TD50DMHqXfpKi+rU3EkeS2BMBkH6GFk4Ehm2YL94rtbP+egrAECARgx86y7fmw7s1Ssr2GNVY9cQ1YmR50+WgjEwHURYINKtMm0AeXME49ANRofNOtukgPMGPk7CPPq6cK03oBx9RgwusIz2jEqTvxpOOskyKMQh/KuAzLDuidhVw7toioTydrK63nfnOPQ9aawz5TVixaDW3EhQSVsk9gr56NbqSqsOWatjtW3994D0qDLGzboiC5OV7/iSc51yR9ujTMTm5dLX4YsyM/WOe5etx4HSuw7xnMi42UyHjnWoPuObQTpuREYtWOBVzfVVEnHQuILpw96QW7j9d5geDFouENrZVRXNq4exkl7eEHmCeS87bdvmKwkHPDu+pzTIzMjCid7Sv7LzTLW
 jGyDqzw1
 Vr/+VwraCpNIgKwb/n1q6n3OzkTzVlfufTlBNNE4MSwlaYcq0nEMs4Fys5x7o1IgrGkdC4UoJSmXiGNTVS2N0CxeoWhc3SpP/2XegtkGMUZPBrR16rYmRoCqzvC5nJq2T3FCoVaYyLo2TboQPz6GkLe6n+DJf/kqmFraBNHxfetSr+6Oo172yc9wvOCLVL37nlt0QLFBry6rwcnCzqZEbO0+mJtUH5wmuCwxGR7HyMp+gXhLeduXbu+B/dTjgsYdoUrGrd2SOlb86xkFcuo6/rm3ts8JU3GpdYpcF/M62oFRxfG7Yhd+IH565KUm+5cYsx5ZW8k1Nfb7qJhNfy/vroAM4lbmyFSH+6nPXo4w2W51XbbG1bIPM2PlCeSTnmAQFxoAf1CrNBv68mB0UcNb7LW0l6JM1J1pTm3sVlOSK0VlR/I/JDSdNdLT1tKR5TGODHZNoUOhP1qoina66iO+PHDVEdd1OrXTg8JqJh2V6Y9SqToH6N9Xyqb1zE2CbKR1jHlndAVPbEatlcoTyxoMoCvex2h2bKENjaVJ9/a8KBBWealh2ves+DvBzsTFDfNwWV6APLLUbLdwjTtqI9BLHBr4dimFDDuZEDUnzi4H6sKByHo0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06.08.25 21:07, Lorenzo Stoakes wrote:
> On Wed, Aug 06, 2025 at 10:59:06PM +0800, Adrian Huang (Lenovo) wrote:
>> The comment previously described the offset of mmap_lock as 0x120 (hex),
>> which is misleading. The correct offset is 56 bytes (decimal) from the
>> last cache line boundary. Using '0x120' could confuse readers trying to
>> understand why the count and owner fields reside in separate cachelines.
>>
>> This change also removes an unnecessary space for improved formatting.
>>
>> Signed-off-by: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>
> 
> LGTM, so:
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


