Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D61FCA1000
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 12:02:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A83F26B0005; Fri, 29 Aug 2025 08:02:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5C086B0008; Fri, 29 Aug 2025 08:02:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94B5A6B0030; Fri, 29 Aug 2025 08:02:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 812816B0005
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 08:02:13 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 591EA13A773
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 12:02:13 +0000 (UTC)
X-FDA: 83829656946.09.28E0EBD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 974C64001B
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 12:02:10 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OX148GJv;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756468931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZYQANwx9dP2TniNNzJzejSk0KLOlcIb4cHUahyjX99U=;
	b=QKENru86R9YUonpPSPv9FHUVTJer0JOnjdlrwCEELCpPOjHOkTSX0zFhdlritZALODEYqZ
	hRGUW7WVwjmQF4JhLqdapw0LezhVEZ8DU9uehiEhzbiHg3DbQHKrkq2wO+naCI8xAkZMYv
	M5GCd0Vfni1i3CX1Ipw0yLjpB1domew=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OX148GJv;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756468931; a=rsa-sha256;
	cv=none;
	b=ZJ8vClajyYmiCu8Y64RZMu2zYHXwFl0v4F7c6AAqfZQImLw677/ZS4OCovLuCPBvB7werR
	vG1mYdPEGiZ1gJlQckH+XHb13cTozWfIUO/d+SUwwwk14TKhCCIlowvGcF9VsI3NDaZvm+
	BVY45qOjToSpDgG55an0Lkaeycll6og=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756468930;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZYQANwx9dP2TniNNzJzejSk0KLOlcIb4cHUahyjX99U=;
	b=OX148GJvbJAZ98zeKqIKI7vLm2n1C0pNRkSjV4VFLocJGil/YP4434Ny0xJxRY0epjYcbI
	MwEOmqVXYDeBhcVi1ZlnRhhwGhZRoUbuGXn/qtlM1NcUN3JwHhzaiu4BCGPSjjQvb7c5Oj
	IzglX9ww1P1anISyWu8WYN/KC5q92lc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-651-5KebpQsxOvGwOzNP4rkRWw-1; Fri, 29 Aug 2025 08:02:08 -0400
X-MC-Unique: 5KebpQsxOvGwOzNP4rkRWw-1
X-Mimecast-MFC-AGG-ID: 5KebpQsxOvGwOzNP4rkRWw_1756468927
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3cbe70a7861so1391235f8f.3
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 05:02:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756468927; x=1757073727;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZYQANwx9dP2TniNNzJzejSk0KLOlcIb4cHUahyjX99U=;
        b=fahvj1nEIwkHfa7CJmGa1mEO3VbnU+YbLj4L0XujUJLaCBTTlTn41RxNBWmjrOCGan
         OVGQmzaQl5+rN3AePzGhTQDKXai6aGi4v3Y44VlG78Ohn27KVOAxG7r7eWWPH3Yf9pjw
         hLtsGgrnCSbvsoE3Wtje9GeVlLCqvzQLXd1xDfz1yDVm0LcZepy73kyLR9o62siqcNdF
         EbiOsHwAhNpU+vP8Gh8fIAU8v6jf9HbodK4x610+P0CLUmo79SP0XkhnQBrWJQr9w3kd
         sCAP3PVv1+hvSDl+br0z7k21g730TspbyExD++Sq5dP+QYQPhHkKHP0VpI35LYRtf+1x
         pJ4w==
X-Forwarded-Encrypted: i=1; AJvYcCUmndaUBNdcfaKquU8m4PmmM8FFHepDr380NlJ4fUF5UI60e3olt7+Z9jo+I8nuVreox2VLIXScGQ==@kvack.org
X-Gm-Message-State: AOJu0YxcbjsC2szm6yazyH+BjfclBUVT7PoVjIZcO/TnMeeez2vsZFSS
	WBlk4CBDaij/WS32VynUdqnCzpeHQSavNIWx0EVcPuQOquhXKMTComgeMpMHP0pXg1RSIUDhbvy
	GEVRkcShYCoBCn0rQtDKduewa20OrBP3cUluTy0eRtzM39wqWIqwB
X-Gm-Gg: ASbGncs5IM6/QFu5Ggv41GcesL3ireuXpyOxsueSHlBP6N1mUQTPTZhcIcZsE9RNaIA
	GSKLfPJgl7S5Ts6z6iJ9G8qPpI6x8bvHKCg6+X6oP9vhszt5NFSAbcGBPlXJUJ0t4+An2bquSxQ
	9RNkl3+mlM03TIERK/ahpnzeDE7/gXM01NiIgZS6Lh1zNFmCrOZA7PpHLBdKUvwQzDzTaQ38Fn6
	KWHEQtibShPXgCwNAI5oObvomXBe3gvFKlw8ozSEpeOpJlLR7a79f442QQZXu3Wt2Rhl30SIPRk
	l0NdMDYQgfN6yjjHb1nOVyjrxUCgW0ZgBswogAQAETwEpGyk2JdcHOOxkjlV8unoBgyKwYVmT31
	nYcB23VqKeUNZjkw8sUcW9ACPx/GYh8yJ8HC2fJOtLQETV1TxZHHr6F8PKkkJ23w=
X-Received: by 2002:a5d:64ce:0:b0:3b7:7377:84c5 with SMTP id ffacd0b85a97d-3c5d7cb4888mr17563639f8f.0.1756468927122;
        Fri, 29 Aug 2025 05:02:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH3QeYJZNPVWNTyOlFRY+fpxC5ixu9vVBtJrj04o0E7yCOrYXtrsrSGdQYXBgGHm6MDxKQL7A==
X-Received: by 2002:a5d:64ce:0:b0:3b7:7377:84c5 with SMTP id ffacd0b85a97d-3c5d7cb4888mr17563581f8f.0.1756468926590;
        Fri, 29 Aug 2025 05:02:06 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1d:100:4f8e:bb13:c3c7:f854? (p200300d82f1d01004f8ebb13c3c7f854.dip0.t-ipconnect.de. [2003:d8:2f1d:100:4f8e:bb13:c3c7:f854])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf33fb96ecsm3144067f8f.45.2025.08.29.05.02.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Aug 2025 05:02:06 -0700 (PDT)
Message-ID: <d2bc788e-abea-4453-86fa-daa68e280d52@redhat.com>
Date: Fri, 29 Aug 2025 14:02:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 15/36] fs: hugetlbfs: remove nth_page() usage within
 folio in adjust_range_hwpoison()
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
 <20250827220141.262669-16-david@redhat.com>
 <1d74a0e2-51ff-462f-8f3c-75639fd21221@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <1d74a0e2-51ff-462f-8f3c-75639fd21221@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bucYPQngXR-M6_6-fcr4ZtnpUYbRiIhqidqcUIbT2Qo_1756468927
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: a81dq5furg971gkrmdbuj3195sjxgqc8
X-Rspam-User: 
X-Rspamd-Queue-Id: 974C64001B
X-Rspamd-Server: rspam05
X-HE-Tag: 1756468930-102100
X-HE-Meta: U2FsdGVkX19kGLINaDjKGFfdhfhU0Fz/gWsNlFK3p0kudehwAeS7S/3wwTP3EFJxEzEi18OqFiAjES9wbLC6EYI7iNI7eFyKSV+bmw9YMhxLL035xtGE1sQtsIoLWK/hNnO2FanBZsnUGPCuNBEqRwaUHvBvTcISuUvkbgLoi5cWYapQpDSB0/76A7LyTdgCALVkTrG2EacK5XfcYvSF1kzNgcXk0eiQ0h8hBtgIGpBDgAB0EsjbJwQkwh4tGOtBXwHwMZL/f9ES5nKR9+W8mpIeF9Qh6OayHoNOvEBAt78MLgZFlWgmnxdf9BlOMWLilhmmnqevLKBrKJ9gBNEs/k7wg5xpCoKnvlp5aZWNQijKc82ysDRvVo45ezVaOlYwoPAaCg0zslx9ewVBzrnX33Xx66yfnDv+7w0YLQ+YaS7iddxwWaPPHc0N76Hc56G8Tz2O2EQr1D0Ru6lZn3zT0+GLFbEDeBtZgL1GBAc4tzQfFmKMwSw1xLvjClcdVFzuAm3TOKZJ+hT6AVmOumNfPr4qqIGI0Bk+Xl5JCivW1k6GlQv01fkt+73dDs5Mjj/P9JyZFlHOffcGSXFigV9qae1I2Bb/+TmZ7D4Mss/zThjPnexo00YaGVHs2Y4KDysrotQQwufO9LlfTuU/oukc3a7aQI6xOByXxsSGZw7Sv4LfrTLfXzxxa3yLtWfiJ8YB0exBMRF1EcBzCyrgrXbyJ8FgYVPr9LCDFTaew7AQLVITqJpkg+E+xMErzkh4PFw4D1BBYwokEj1uwDuZINxjj0D5MfHvYQmtB3T/ZO/IRbvbEICLVHkEdRXkP9CgNX45UkeWD5s5p6eurUBVdSDHx4OX3fRBCyygcVpA2O2cNJmtvuVSw0qyabWogbyBYWfAtZCbkv/Un662ez8flZucUHxX1sTY+WVQSFlCZj2s+G6rg+bkhrHpVc0qWB/Rcszjh8hzTNDJWTRdgi0fE3J
 9z3zTAiu
 za166HRoMQIAb9QYSAvNmI1OSI9cLkdEBYc2YDWpw05xM/LOezaYPN2vMlv2Vf334wvDs2I4xIT7SZe88WbFwCAO0FYiiNSOoBK+YBGqDjgjL2a0YdcdHmDhahtWNqs1Zn+uc6GBdngpJmeCapy/Rls48rh9TLYvtuc4E1UrB5KkA77sTxIllLCUFO50MssMDLljdzN/JOnWs6JuvtCKeYACqHtWvnJHbnkRIeQQv7Ot3bnW/QYLC+ZfEKhwG9v91/1wyBo1RbXa9bfeZFEoBVHr1R3oceYWXhgMvYa6d3Yxs55f+yCJk+GdS4DJFR238L/0axw5MVOCUAWRGeyHmc3R0eAhJZHTrn6trrQRLelrtQqp4yi2e5tv557Snzo4RhoofnpblFp+T4EsV82CdZYA6BRn3/Rt6g4LQUr4HjCR5Y2acxLqeqP4eyi5I/spcG7qxPOovPz1a8NNgox4XOJ42nbFN11ccDEKh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.08.25 17:45, Lorenzo Stoakes wrote:
> On Thu, Aug 28, 2025 at 12:01:19AM +0200, David Hildenbrand wrote:
>> The nth_page() is not really required anymore, so let's remove it.
>> While at it, cleanup and simplify the code a bit.
> 
> Hm Not sure which bit is the cleanup? Was there meant to be more here or?

Thanks, leftover from the pre-split of this patch!

-- 
Cheers

David / dhildenb


