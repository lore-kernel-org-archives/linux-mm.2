Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7895DCA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 11:59:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C074B8E0008; Fri, 29 Aug 2025 07:59:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB61F8E0001; Fri, 29 Aug 2025 07:59:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A566C8E0008; Fri, 29 Aug 2025 07:59:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 91C758E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 07:59:30 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4B0C31A0661
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:59:30 +0000 (UTC)
X-FDA: 83829650100.11.4E0AB0E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id EC34D80003
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:59:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i3QdRllr;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756468768; a=rsa-sha256;
	cv=none;
	b=hhVkCo/d7bFQN10FeXTaOBF3Cm6RCSqlMYBkQWeYRVC7F3MlmSZKxNUM6+FqNORnKQ5B8c
	Hk9fdmSTeVdiW20y4kxA7+XF51Jb2ugkosH6aF+JSBMdCsBDWLB43Aq6Z/o9dJLwdzL1WD
	ra0WTiid3wNvFNEkAR1xCGcnalu8vYY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i3QdRllr;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756468768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bF6XoHD5pMX2I9dADLrcLi6kiYTvPDGveY8Ow/uEvrs=;
	b=PBmrjjms9AaFjUF+mWVEQvaegseBNXpx1sT8ZV4wAziQn0jx2HGi8JvBaPEtIUS7q9bUyr
	GKzaDyhYZgOQwYsNRmJjabSA+uWEerbQwne3jW4OtbvZJJ+ADVeLcky01iKfXoGgD3A28h
	8OW5ccRld/4UbV/P7Hb0LqCCSQBKSSk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756468767;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bF6XoHD5pMX2I9dADLrcLi6kiYTvPDGveY8Ow/uEvrs=;
	b=i3QdRllru8ccQFS/x9UAz2iGIeAuLUYCuRLzV6e8PFxV2+Tt6EJJnum8igCm++SxkBU6eh
	t7RBjC3I9wIyf6/cudOwJo1w5jXTAZnG1LfFCyawEqY/VaJeCEbs9+shxSL7Mms6VF0rvQ
	meq/HyAkKPkqpXQQTQAS1ZdoKauaoNA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-503-IpOZ8KluNm-jILWss4cjcw-1; Fri, 29 Aug 2025 07:59:24 -0400
X-MC-Unique: IpOZ8KluNm-jILWss4cjcw-1
X-Mimecast-MFC-AGG-ID: IpOZ8KluNm-jILWss4cjcw_1756468763
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45a15f10f31so20927405e9.0
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 04:59:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756468763; x=1757073563;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bF6XoHD5pMX2I9dADLrcLi6kiYTvPDGveY8Ow/uEvrs=;
        b=EO2toSOAsn8tr8XXn6tf7+IXJ5Tj6insbLujNX5gB8hAFfwtcNmv7gEdm3UOz6M5sV
         BeWsUyURZ4B/uTPzIYmFw+FF6F68aJdnAHh3R5qIU5QmfcPmOoRNIT2STsgZiI0xg/B7
         Od8g0XZ+Qh/5vZeGcYa3U5acbytqOQFm5ob5SmdVB0KnuCjLn/dqQVF+lI7LwqetcWBR
         VOSQuw+bPiYDR6b8OebgAHedoOcfzI+W1fDCJOXVFsXVXKZmuzI25Xm0sLurO3wH4wLe
         +PyQzwCYtyIbDtVppMFob0KuVAMbcZeKPRq77e3Bs7caw5xY2pW3WLJej9xGvZmhhuDC
         JwpA==
X-Forwarded-Encrypted: i=1; AJvYcCW9/QxKwm2ykp4OfJGQt4cRSDKo173h/6rCRL1Vuc4Mn/UuuMh7ycCAmiHbKSgUKoW05L3ibJigrQ==@kvack.org
X-Gm-Message-State: AOJu0YwdZDNRVVc7CV5tugesuhzqLpEMqvqsmzoXdJNMaqvyg98bLNST
	Z7gR/4QocyG4IZ4WqQSpk1avwt+xa+VRRRe9WiMY5dVtwTVFT2sdcYyNey+7ILCP/go3Zt6PvK0
	K5ty022HhqGtRDvdLK3Ju8MJgZ0e59aUodXs09yCOTbL5MSd8ydK6
X-Gm-Gg: ASbGncu/twE4D33iswjUyI0G54vx7rYk3N9nicYD2BSzK/rLI4tq2KUgpIDffiN0spt
	6j5jJAEx6eMIkcfYTg0oYvDbxMAkVuAziLG+B/SFPmGRt/MNl2eLNh/ZEONIykn4ZrI09J4dyr4
	FXAfhsfgxFuY5706CpUCvUs1vq0Ar5KS3/L9ljYgZjNentO+ljmHoL8J8W0JS59obLL5YsZkVgE
	DlB4hs+7PIsm6ckmvKYkF/rEEpXzrAc6R3+IYlZ2/BlcpT+95MQgHibE8Nsa6CW310WPtn+Qbgf
	I+SRJzyyoA5dDh3Y5wpxa5+o1t84Nf7CEpAfUUo2sZCx9SzarowHAayvukoi1LUZpLygrQoILNb
	mcAet3/CdwuxYZAMAQy6pMY2s55febjK2+ndSh4MmwJ0HDI3+QWtnpPDJ0aEAfKo=
X-Received: by 2002:a05:6000:200e:b0:3d0:820:6814 with SMTP id ffacd0b85a97d-3d008206caamr1378523f8f.30.1756468762686;
        Fri, 29 Aug 2025 04:59:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEmTZMPZLsWUlDoIJtYZ4y1n4323fVpiEEHsVmNFQad1skciXIKlgwtKzfxNR+9KUHASW5nzg==
X-Received: by 2002:a05:6000:200e:b0:3d0:820:6814 with SMTP id ffacd0b85a97d-3d008206caamr1378503f8f.30.1756468762265;
        Fri, 29 Aug 2025 04:59:22 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1d:100:4f8e:bb13:c3c7:f854? (p200300d82f1d01004f8ebb13c3c7f854.dip0.t-ipconnect.de. [2003:d8:2f1d:100:4f8e:bb13:c3c7:f854])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d0c344f6casm2018873f8f.36.2025.08.29.04.59.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Aug 2025 04:59:21 -0700 (PDT)
Message-ID: <0dcef56e-0ae7-401b-9453-f6dc6a4dcebf@redhat.com>
Date: Fri, 29 Aug 2025 13:59:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 13/36] mm/hugetlb: cleanup
 hugetlb_folio_init_tail_vmemmap()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Marco Elver <elver@google.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
 Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
 wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-14-david@redhat.com>
 <cebd5356-0fc6-40aa-9bc6-a3a5ffe918f8@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <cebd5356-0fc6-40aa-9bc6-a3a5ffe918f8@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1EW-whPhKFUgCmlQJXHbERdpnvIyqnVCQEnsrqkibIQ_1756468763
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EC34D80003
X-Stat-Signature: 3kz3n8hy6ij3kudz798o7jowbn9o9ngj
X-Rspam-User: 
X-HE-Tag: 1756468767-860950
X-HE-Meta: U2FsdGVkX1+XW1+qq7BHHn1K9qcwxaNf8D+eNaDsFfSnUMLrGXsCF2vulmeoRtaTWajWu+p6Ob0NGZjTzVi5n3IKF7taHm4iBXtED/nmRJP+JaSDmK+bIm2O/KZtJDF6mYVn64Erz2jsQRAn+oRindtWfpuC+H85OuahgfCIhwquRiqWJZAvY42UlIDUibeOCabJPIuIbk0o74T/SUOJ1Ihc8o7zS4DGprnR4xD0wpFl0F2OrrrUQ4Xy34H28LnXuTxzCpulY1FRCEnm7rCbKlVR6XME6NQZG/uyzBZbYtO/LpMbNs1GdObiUMtjy5IjJ6yd1wHK5zt3rbiLGNWz32zBLZhOr6JjtegblpLnOFHaRM5ZwOH8Wl3t6XnkyNmYGUYlAfNKVyZkl1sHpeie/okUs273bOw3uKzqtmSG9Yw6xfPXuHG8eCfe2ADQEWxJTtfTGA1GyNRZvc+QyTuf++cTmyBSjlBqORR0FV61Yx1/TCCnQ4VSGvbzZRtqrRmcOWddarOhcX0wKo3xzHGRo0E/ym+SNyopeQ8nemGg3rLI5SwsGGAvOtfpWF/RQOvA9PFSd7Ey148fw6yJ7Igg34SVL+ZhU64sDQymf+XlbAlXK2aSPXkQb2AqruAAUGJor071qqT1+9kPzurB2G5/0Pu0I8xpW6juqLFI+Uw81s7rzJnlbrkNg7ZHRDz+DEtIy+5irHLx/3y3T2TNu0Z2XcXiWFKv7gIN40jo8mpPSvhzOWEjgS+ZhoPLniES5b+Ts54++ROx73ML2qgjQzNMgiRj9Eaqzly4dYLei0Ac9cueCR1PxECp9X6rVtlvKLEAXbM395RAc8uaiMDukgyyE8X8uKaSFx4zO+SntK9tvKWVW1SYJKJnqtQ4OMiplf6uMRMd2eZuUcN5m5arGKK1Imv74ahFIJuW5ZXhh+IlQMIrGyxXs5u+9ZMmIJ3Q7kN0erKmTuccCpsAi7j2cFF
 CF6PpOzU
 wCMmKRzi5U5KHeVe6RQwLSMmV1ugWLrgqd1RlRaya9NkOb5DGRJxNQQIqSkhe7YMuGIwFKavdTMNKs2x97NtKoxHrcw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.08.25 17:37, Lorenzo Stoakes wrote:
> On Thu, Aug 28, 2025 at 12:01:17AM +0200, David Hildenbrand wrote:
>> We can now safely iterate over all pages in a folio, so no need for the
>> pfn_to_page().
>>
>> Also, as we already force the refcount in __init_single_page() to 1,
> 
> Mega huge nit (ignore if you want), but maybe worth saying 'via
> init_page_count()'.

Will add, thanks!

-- 
Cheers

David / dhildenb


