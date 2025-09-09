Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66F77CAC583
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 16:15:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B02A88E0007; Tue,  9 Sep 2025 12:15:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADACC8E0003; Tue,  9 Sep 2025 12:15:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A25C8E0007; Tue,  9 Sep 2025 12:15:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8ABC18E0003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 12:15:26 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 36ED01DECB2
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:15:26 +0000 (UTC)
X-FDA: 83870211852.13.A86A5A2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0716D4000F
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:15:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VQAbuCKX;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757434524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DULaN8FQ4FQ8+JpWrIkbkq8ORxl+FvcAutXuAs4Q8P0=;
	b=KUfEmTDDByLnq/7MNsnOlDT9CEo7SauIeh7fAabN7QNkigJBaKHnbGyONpUgRxaanDzSlj
	PwdCV5HHes4OwcfEI9Vj7pQHhjnrfUtZS8MtzkQ6pSzlMW1pRpcRBXOZBSpuHsHyoLrBfP
	ttBnrZWPKA6EoFpQarDG2MF77xK08xo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757434524; a=rsa-sha256;
	cv=none;
	b=QaVP2S05n1R5SlFSCO/1YQr2+edLLuTena+IZh1zQ7pvcEjgSXOL9eTAepmuL8KRAuGf/6
	QbiCZ/mimxnVR8bP7wFwThIV5o0BTwbDPeydVKpXYXctbqmcn/OI6+7Golhp4OW/kZP8Yo
	PBC1HexOwNnh5cYgCY5PlVd+Tri0RYE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VQAbuCKX;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757434523;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DULaN8FQ4FQ8+JpWrIkbkq8ORxl+FvcAutXuAs4Q8P0=;
	b=VQAbuCKX/tgMK16qLWSSMq29QigsYDDcppFRYikco27+TZMcIXfGVlxRb2w6jXP+F23du7
	0HcAb/Gw1qya9f6O9VHtinzNmuz+sCiPQ5+UCjrMAwKlbGhpEpNh7QEgMuwOdU634/nLxr
	r4JzFzXG/IU91nm7cGsigFL5MZyiv6U=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-587-UIjbAHIhMHOLdOj9fLzZzA-1; Tue, 09 Sep 2025 12:15:21 -0400
X-MC-Unique: UIjbAHIhMHOLdOj9fLzZzA-1
X-Mimecast-MFC-AGG-ID: UIjbAHIhMHOLdOj9fLzZzA_1757434520
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3e40057d90aso2295794f8f.0
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 09:15:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757434520; x=1758039320;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DULaN8FQ4FQ8+JpWrIkbkq8ORxl+FvcAutXuAs4Q8P0=;
        b=vTdwm3OoA3DUA7itrrHeLhfFgBrMmxGMS3Rc0PQ+oBlASbO9ZoGgfkfZNmtdYLyY4h
         j2hKgnR6bCRiAEWBzGV1EXz80kZSN5KwGCrD5G3hSZScf54xA7PPHtgGUU5Gvvb+woDB
         BWCHy4hVjSPeXFiEpBeIZUMjjhsaBSjHyj2DpQEAbbP4x0L2yMVzl3tZVbnpWnksZ8BW
         KIS54zo4A+Yf16daMdsVa3hH0GAYjyJAnIw9pDRFWlCDOck1DxFLt2/9L8z1UMi8IRHu
         /wtDD6vG+1TvkRP183yh08zjfTkYcjk1c4ph2OKDDd4zKD/rJbqM0dMptPXj9621SwrX
         /28A==
X-Forwarded-Encrypted: i=1; AJvYcCV1Py/lFMv2HBim+8m4NCXmER6CIdR2LZSVF+dM5L632u9ov66+lByjMC2tAtqxiuxEh2s5GoGhRA==@kvack.org
X-Gm-Message-State: AOJu0YxIYBRabDCQPpDmmnwrDIBX23GZToqEbtgEpc6Qspv5jV8SGWUG
	jv8dEQ+95oajwFPJTIN3qjEqTVyLEaiLjNHrDLyjgIFVVKD+pJ+RHRdgFfoh0y1fONkVGjwl80Q
	AX+rMtIiwyAeZj9a1noiux8m0IUl15nTpE5DaU+4xseSOAyFNU15T
X-Gm-Gg: ASbGncui12pPrJHmH++sbg/U8xd+Af9rYHsE70WoYJbeYBeb9QzHvaOdcRyuMBQOtva
	yY7AL/vMgcbHkTazjij+vL+dxv17t2cxgKutC9MV4ex3qR5i+awIHeo7ud7Bx/Sn2sZinETSFGX
	zQ5i3tySkobqiIBs7M7PpUkyddunLfxbFzzkFHDSxqWHvMqIic0lRdeCdueCoht1XY4M7fOwf4Y
	A/540L5/bXmvn5hg9KA6Fo/OJuV5GX2MRkWClo2AGAbfYz+CarWCWEDeZcfp+dq995WpioOsRcr
	aL+cbOusKgtCjHYLuF/xBZTllY2IAikxQFoFZyBqD0KP9XZPllBOrlSNGSaAmFtidaiOmSv6NJi
	eb46dWoQQa3AInhk15MnsBTUTCyoyIT33As+OkFfXKKUJDRJmFXe2377DGG8YHZloA00=
X-Received: by 2002:a05:6000:4410:b0:3e6:f91e:fa51 with SMTP id ffacd0b85a97d-3e6f91efeecmr4995394f8f.8.1757434519692;
        Tue, 09 Sep 2025 09:15:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG9InWvJAwy9lkxysPqm4Le0o1CsvWdRiHnZwm16w1dhVKD+GnoSIETjUZea0fauM3ALyDmAQ==
X-Received: by 2002:a05:6000:4410:b0:3e6:f91e:fa51 with SMTP id ffacd0b85a97d-3e6f91efeecmr4995382f8f.8.1757434519270;
        Tue, 09 Sep 2025 09:15:19 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f23:9c00:d1f6:f7fe:8f14:7e34? (p200300d82f239c00d1f6f7fe8f147e34.dip0.t-ipconnect.de. [2003:d8:2f23:9c00:d1f6:f7fe:8f14:7e34])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e752238755sm3139523f8f.32.2025.09.09.09.15.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 09:15:18 -0700 (PDT)
Message-ID: <1228a0a7-660e-4993-887d-66bc2c37b8f4@redhat.com>
Date: Tue, 9 Sep 2025 18:15:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm/gup: fix handling of errors from
 arch_make_folio_accessible() in follow_page_pte()
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Christian Borntraeger <borntraeger@de.ibm.com>
References: <20250908094517.303409-1-david@redhat.com>
 <20250909180757.1114d727@p-imbrenda>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250909180757.1114d727@p-imbrenda>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SXISUjftW2PBYI7zcxGGc0hC88ErjW7NlsHaxTLdoa4_1757434520
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0716D4000F
X-Stat-Signature: uk7nm3mhwk8ik4cwt4gytbqmeotzp13s
X-Rspam-User: 
X-HE-Tag: 1757434523-495166
X-HE-Meta: U2FsdGVkX1//8g4uHWhafRBIRW0UK/1VkXtex0UVaXG/1f6drYQQI+qa6F/0SJR+7uLGJKJXlXuQhn3KUe6T/R11B0t/AhBkWa0+HgBY+GO1Um5mwDMjLsRvJ8f9MJjtyYMg9dPpCmdlNqFaB/Cre4haDYrBEMEqm4AruOvbyFBa3zfkq/R0vGjkTLqFqX0yVkx/MCpdfDvwyTxPUoe9foa8/SJxPcGi10MoIvXWH619Bzzd7qXcczMCM5Fy5d5Lk9Rhf9mEMR2F+L57Dkd3lkcCxxXFyflhPyu0Ijq7BEjO7wXK9FaCyEs5G7xIxluB54S97P8c3VuLOhTJI7xv172LfYTW7FR0to/LkWvxOOtZaxWJGA5j0VNmStRlo0K+0B4BISv5StpTTgB/V9PBmzNPbIXHnwYLHEh6aY6fAlD9NYFdUQQ304jHmuj1kTcA5eekS7Xao7Adqyi6Z6qJ4JZG02c3+MpmKWZDYGadBdvbvyLT3kFcqmBrZ19l3wdxw7+csgVs2Nt7arU1Ov6metI58dfqFdeR/XejHl8NRcoSLFlNsM8hAtyuJOSGz0tkY3TQYZ+wKNPhnQeeub1WzWPMZY9+eZaekSA28QYc42RAxacN7i1mBRmH0usSBgOZ12SiHFm75IFsDq1q2g7gKDZ/nubma0anRmo+lQj6dGLTHt+s1kBPR2pXH0Mxu543KIo4FN17a1HPPvieKpAIJh3cua4JnN22TqP+2IOKddvKZY784pi4M6jeSCZLW23IyeiI6u4kO+RxIqkp5r+VBT42eiQ8r4nS8La0wQRkJV/Njv9d9dgCZ7pjCzlLFFsDc7p8+vq7wxznZUZJkWQixt68SuFBEjmn0COXeu+CNymcDyK3YmcLDFNENjfUIDdj901mH6sakBIJZ1JJLYu1WK+BBVR7Bvnd/oVCbbPBcVxw2/W5BYWV/1qAj6UWGPpfKZhKtuyTV3VM67n2izI
 rjZ/wKrt
 4d9VyPMB7dqC0QODGZ74dmIav2YnCXXvQfcGK8OcKOraff5KMBvx8nJtkr1O1/QyNunbkFoi7TZAsjh90E/ZB6AN+hw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09.09.25 18:07, Claudio Imbrenda wrote:
> On Mon,  8 Sep 2025 11:45:17 +0200
> David Hildenbrand <david@redhat.com> wrote:
> 
>> In case we call arch_make_folio_accessible() and it fails, we would
>> incorrectly return a value that is "!= 0" to the caller, indicating that
>> we pinned all requested pages and that the caller can keep going.
>>
>> follow_page_pte() is not supposed to return error values, but instead
>> "0" on failure and "1" on success -- we'll clean that up separately.
>>
>> In case we return "!= 0", the caller will just keep going pinning
>> more pages. If we happen to pin a page afterwards, we're in trouble,
>> because we essentially skipped some pages in the requested range.
>>
>> Staring at the arch_make_folio_accessible() implementation on s390x, I
>> assume it should actually never really fail unless something unexpected
>> happens (BUG?). So let's not CC stable and just fix common code to do
>> the right thing.
>>
>> Clean up the code a bit now that there is no reason to store the
>> return value of arch_make_folio_accessible().
>>
>> Fixes: f28d43636d6f ("mm/gup/writeback: add callbacks for inaccessible pages")
> 
> Ooops!
> 
> thanks for finding and fixing this

Thanks! Is my assumption correct that this is not stable material?

-- 
Cheers

David / dhildenb


