Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E629DC88E6E
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 16:12:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 905016B0092; Mon, 14 Sep 2026 12:12:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DCB16B0093; Mon, 14 Sep 2026 12:12:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F3D86B0095; Mon, 14 Sep 2026 12:12:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4CEAD6B0092
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:12:15 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 981D61A01AA
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 16:12:14 +0000 (UTC)
X-FDA: 85212859788.29.E824DAE
Received: from mail-qv2-f12.google.com (mail-qv2-f12.google.com [74.125.230.140])
	by imf09.hostedemail.com (Postfix) with ESMTP id 89947140010
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 16:12:12 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CoFyq1aN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of ackerleytng@google.com designates 74.125.230.140 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789402332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZIrwzndTIJn+zc3gui4wMdEbuLT5FkETFxZVrQW961I=;
	b=w/aPMPSLGAYulfPtTvLGkR4RsxfobaVfCs6Sd5CBSzVFaOoXqmqJGkd6/YqojBKKxPDofp
	PEzdqrGy1w6qq1ZwdXwOLq3j51WJONYlPcp5ht4fS14h+WT5RCGwRfcAldfQMFWlpeU/n+
	xVmFK0WB0wRmfbmbjelJukJqabSYJBs=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789402332;
	b=t9XFxiaAwSLEtv+pM6BVoonRIObSNQU88DcDix8toQqGa0JXFyk/EPnuL/WxGUXXd5l0Ul
	koSum8O2BGNPOR+ckUMP3Ch+OrjHFdKDBMiXT6cFadqatgivpZec/NXrGZnod/DhZSX6fZ
	Uwp6JKbwxHRWNzeywsxnhz3Q2rACLJE=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CoFyq1aN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of ackerleytng@google.com designates 74.125.230.140 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-90cdfc9b6ebso25210596d6.2
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:12:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789402332; cv=none;
        d=google.com; s=arc-20260327;
        b=jfiPPJA0ZafrGbbsDaRLCSTDShqPMGma5zPxE2/L9AEleLZWjAxM+9lAUAGCO8lZDk
         CVkXiaYwyjmNtJklwWo66pdirJ99IqhsLYkg+nDLpEfS868N+gOPV1idciae5xPHbfrO
         3GfdA34qZM6n3vwWMKiTs1M60HkFrA/qUlkKBp9suugb6nwUUKns2mr2gab0oOtJBDMP
         E3zYXK/7TEoLFS1/l8qbNbFcsF9XOSYjtqRTYIVjZeRrp2d/yFLcqBsHUHKjn3hCB3AS
         s4pKwJcQtV+JeNYfHVp5+Ly2PHxSKgQkkbyHcZpmLRFTVLtojBEnqVj28Yf/U4iY1dwb
         ZaVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=ZIrwzndTIJn+zc3gui4wMdEbuLT5FkETFxZVrQW961I=;
        fh=7jTghUIFh7rL7fI7LmAZ7h5qdj9PMKlAhTYSuDPcT5Q=;
        b=arzRwDgwYWrWrisxRqvUylPihBsZLZypfrZwggbOhXoWSE5OuJMzY+V7OHccbK9eIf
         UbfsRegItNYWD916xSQRgeu9YeCVp64W/O/IgOiCdRtMx3bYrmBHizZStoAkmMf20z4M
         zj1qjk+shBVCB0kHxwA6U9ittCwc1PbqeapJUCLJS1UGp9KnMCxgrC2n0KJFOM2zGmfb
         O10XfjU9SzCoEbIy7oyDsT+N/gbzn6DcLmSpvb+v4sSYCUkfOGjeS6zUI92dUQxz+jin
         ht6NYMdVVpzJZXe49xugcyXMSZmi5X3tuJXa6B4I/m17lmFkjZw71miOErLDOsnQNmu0
         L0eg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789402332; x=1790007132; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZIrwzndTIJn+zc3gui4wMdEbuLT5FkETFxZVrQW961I=;
        b=CoFyq1aNjxykZqpOaM2GNAFWKVn5Z43oTMjXu/ME8PxiXO0AvYB27SsGrCZVOHtm6Z
         uXMI2oLVe/KN0/VlcHgsB53HNwQFYLTHrRiXgk6CIF9q+J1jLzO1ZGUXiAC88qpBtgNM
         KEhgZzL5WYQbYO99axwEskr5x1Zba8NZdF8rAsKL981EIwSSpE7LJxN48irMh1732mPP
         GgeD9Fz8WX7VVXUkfb46CUxm1Zchcig8TSelIyA/QCROgvAQoEwVt8uv3R1cAsmAM1HY
         FSLJkZqoSmMfZ5AwXpGonMG/4bCWdeJRYXc6j8jPpszu1ABqI+4Hr21kwSzvyDgNxqBN
         /k3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789402332; x=1790007132;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZIrwzndTIJn+zc3gui4wMdEbuLT5FkETFxZVrQW961I=;
        b=JuIPSQckSLAhWnaNxZxWlDpV2lkq1i4NVPTwGBz+I25xmnfL3LksYt3Yfq9DKHNEOK
         3a1M/JEs+IZijsGTKIkK6s8vqSKwV9UQjJfdpaA0lOQW3fafspm/hdYobgCtWUOpkNIS
         IXkPEyFzNY2wDO4vltR2qYes5P59YgwvHYPH3JXPK01PMm1TPfsyDIKZTsQQPoauRamv
         v8YFCZLZqxDeRtIV/mw3xrUn3DAvCYSqc6xrOmXx/0LKpBX+B1isx2uBmxnWDoV2mvpQ
         QNrjLUBOvac92xK+agVR+9nlwTXPQrFBZ25sWzlN4szIemgXn3CXM1U9fKS1RHhbt5Os
         0vfA==
X-Forwarded-Encrypted: i=1; AKwUvBznGpO5pB4ULSO5zXZ9QgFuNJs/MaSvpJLG0PgtbpebVVmK1cwFqwMA0XHRTVapQImPey7lMnfChw==@kvack.org
X-Gm-Message-State: AFuF++mvYC4DwTIOd60Dr66KOwy6lQ1mjYXwrDJ2g5ygmYFQU3NZuj5d
	ekkhqU9CRp+PQqq852jP19+ZeIckGfCQ6q06XSkJhc1rKGyE8Yo7coqYub2PhjMEDzqLbLlh8A6
	XKTEq2OGexzuCeMu3bHvSNnI9MtK7ZI7bdK6pdV5y
X-Gm-Gg: AYBFou2qhPSynObx41r6+ahAdXU6ZKgR8SM/qlhiLiMznL2BQuG4T0NM6F8j+3rC49n
	nbF74kI6O2trQRtGELWd/Qbydia9DHYkOD9weUHC45LF5OyROPANx71kncgEiv2Lr026Gj9BUB5
	yv5BLZjJ7d71Mt3eu09nclkkxeKirCPLPtPFN4ZrRgaYAGOewiQoExWJD6fYPrIv3kKxVnwLey2
	nGq4z48DolXmKsPPmIXSTYu6MjtWewndR9MfA/BGdwftlfuAGjp6QYztG1stK7Lz1WYzGQ3WUy8
	6mUwZnqq4dI26okUluDFtIsCCswlHJRj2EEZyC2SvtnIUROxSYwto4edGC2/SvgfRqBg/ofXfXU
	gDUznpgUDFQ==
X-Received: by 2002:a05:6214:4188:b0:910:3453:7d8d with SMTP id
 6a1803df08f44-9122e68cb26mr52724686d6.34.1789402330683; Mon, 14 Sep 2026
 09:12:10 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 14 Sep 2026 09:12:09 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 14 Sep 2026 09:12:09 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260911140816.3236725-1-joshua.hahnjy@gmail.com>
References: <20260911140816.3236725-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Date: Mon, 14 Sep 2026 09:12:09 -0700
X-Gm-Features: AcwNN1WUbkCX1sstQv0ZWJuvqOHMzCSyd9_UN_yhDwBAx0uKe7xefyFjGTdT2Vg
Message-ID: <CAEvNRgFme=qjw+T8NoKwLuhVLBGYeXGFaNM_jB9tR3WkgPLjHQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] mm: hugetlb: Track used_hpages when
 getting/putting pages from subpool
To: Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Dongliang Mu <dzm91@hust.edu.cn>, Hongxiang Lou <louhongxiang@huawei.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Michal Hocko <mhocko@kernel.org>, Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Nhat Pham <nphamcs@gmail.com>, Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Wupeng Ma <mawupeng1@huawei.com>, 
	Yanteng Si <si.yanteng@linux.dev>, fvdl@google.com, jthoughton@google.com, 
	rientjes@google.com, vannapurve@google.com, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 89947140010
X-Stat-Signature: bgepsz1xi3pq39bpjhpb6yhrs445bcsr
X-HE-Tag: 1789402332-572025
X-HE-Meta: U2FsdGVkX199xeCXHiJdIe75kyPYd01gJG35ZW+njrnCvPE0xQNuP+rROGjnbVl4jHAyW2JAaYAxThQPM3Ch5bki/G/4ZX9GJ+l+wgf4i26kvt6mpwXMtX98RWZMtHk5QE5/YNDq+kWbqEI4aHTEUofjUFPvHju1DwrTf1OxihOVK1x+VGteC09y0P+38lt4leafXA+J0041Cp8gGUvS0i7j6pwTHMK+MkeK2AIDd4ESbPuev5qc/ki97SX62Apgkg5mZWa6XTm/ggrGWHroKl4J+JZrgksgA8fLY9+//Ct9sMYK+pha+quVE7MJs3fgWeRGdCYv86FwEjZ1wjDRV3Jc8AftBtKe8F1ZPVgBuTYvdyE6N1NGjcnAtBL+B441WCvPYdAGzkPmMetYyXMAHNvhC50pVFQnKQsI7/ip4s45L1923YDjsJWdMRXGXU4zzLmRuhT01Yustv0qrqUCf1CbVUfOTmraIxkfYEoasqfgPLi7D5jcm1V27HofXy3YnKtLbziF+0+QoVNfTTqtt3WrnTYe1cQQtmMrA8a14/kHAVh1mahnuly0ue7fLYZ96Y5/Rp/LLKxYK9gRSQAlgObG7UGvqgkFQf+F50IYbHaEev2SOYPXUTFTFmpAGPLsdYPXZX6abhIv6xGfNn0YYLQugQc8tFHJAVlQW10yhnc98yj6lYmhLnjaSyr3qxk2J1kXbo3uq3nBRPmNVJBKejhJKcl3jxtxfJ1sadXXts10SXvsstoLO2IQNy1VIY46+ByDPD5YvzFbmvV9F0jCZz4YeZME3BsfeLBVX4/FSpPEnfJcAyksEMhhaR0F8s/0YjP5XdIM7+qhFL19s4JSFB5f6vLOzGQ0mdbJFF0ZgPbm66KV3PuKemhaMLzGB9NPJNdWt9XyUW+wzJsGysJWEmYX/rmCcEtECAtOyYDYBTWXBXyDau13v7sig6UPkDjVMaz5cNDULcVSa/kynda
 x8J/hTfE
 0/EgdZL9zlTRLZAIx3uuBg9LDd+BUW/D/t9RCuniFjrINeqFfaHbYO5sw61Bxp05Ks2OZegVxBZ9R+jMWleo23CdTQ3hkMhCGOIfjMLFiQiPQG67dWtQ5eiaK5GY6z7T7ElnJ/mAYDTCdWgBGBKuhyUmoDHQ7batvUIi+0px0Ew2tKo8pOtPN5Crbw3/mEapvmRaOIdPduJMMSjdhcDCRJZLIAQorK4RX6s0DYUAwFzRMaF2WIAHt9kuUIYjMTupE3L3ff/Otx8YDpOXe5nog2lUzS8iBpOWAtxX//knLcCw+M5wZ5h7ycZOmUK5Vg19/bM6LfQk16BXjB+gOxWcCbMnorGUOyjkF6lH5zKrxwaXZsUWQ/YoInAmnZ5qSx/epkxDNYmwhtmJp9tZ5YbQcpvdP4fWronhEhiin8/m5671JEASLNRqRfdTHBfd8coZ/g8+TyKOzJyxxsvANPlaTqTkwRYMqdY8ScaVy8OZ/cwfF/l5Zty1bJn9L8J9O8ie7K6NNblyEqjkmO+w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Joshua Hahn <joshua.hahnjy@gmail.com> writes:

> On Wed, 09 Sep 2026 14:49:26 -0700 Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org> wrote:
>
>> From: Ackerley Tng <ackerleytng@google.com>
> Hi Ackerley,
>
> Thank you for working on this fix / simplification!
>
>> HugeTLB subpools currently only track used_hpages when the user
>> configures a size limit.
>>
>> This is buggy since when there are existing allocations from the
>> subpool that would have satisfied the minimum reservations,
>> hugepage_subpool_put_pages() will still restore a reservation to the
>> subpool. See below for an example of a false reservation.
>
> I'm not sure if I see the false reservation example, could I be
> missing something here : -)
>

My bad, I copypasted from the cover letter to this commit message. Will
fix in the next revision.

See more at [1].

[1] https://lore.kernel.org/all/CAEvNRgEwbUXj5cVQq4A-U=AMOzP3S1mjnrOC79Li71wf-E+dDw@mail.gmail.com/

>>
>> [...snip...]
>>

