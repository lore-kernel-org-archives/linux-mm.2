Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDA4EC87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 15:34:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 617B78E0005; Fri,  1 Aug 2025 11:34:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EF428E0001; Fri,  1 Aug 2025 11:34:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DEA48E0005; Fri,  1 Aug 2025 11:34:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3CF2E8E0001
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 11:34:05 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0371A535C5
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 15:34:04 +0000 (UTC)
X-FDA: 83728584450.14.D516296
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9E57040008
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 15:34:02 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZYbekagL;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754062442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JHgBzHC9Il8/iD1hFbNzn8RBxkEg4S2pBSlpVReUImg=;
	b=lGGkBJMO1IXxbSgkmy1xNiPxbm/z9rSDB7y7vPATBMmikSE7s9OcYLNk2l+8eWmVacS8V+
	hS0exrVzQ6ptvdnlwmCAkrEZld6gs70jSGlYSqGT8yv1UdyRldlSZb1RqxwU1bUumu9CdS
	dr9qEOPohzClJNLYEfxX5TDxnAGatuk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754062442; a=rsa-sha256;
	cv=none;
	b=q4GEZFOHC8iuce8bl6WKMmI5vaCZw2tS0P49p3E1lOpzLxEvbZeI0Xp2RPOcoqz7qNSxVM
	hZ7+Gafqke9fyYOckOuvSlbzHNtBYVjT9DQj46UIJFyuL/qF2/Z47f6uK4GLnZfzbR42wK
	2w62ZB8wB/xQly9uDBSG/SRH4T2xdeY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZYbekagL;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754062441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JHgBzHC9Il8/iD1hFbNzn8RBxkEg4S2pBSlpVReUImg=;
	b=ZYbekagLtj65JDZ89cqE4XuntVSEBBhNvt+sXogw999U7xD8sdZJ1sPz+BXcIlVBgxqKm8
	7ovHDQxmbH2Vh4kxrn5+NtygnqSy3kxfMrbNNgFjYc75XSXlLd0WrYBzyeFtt+p8PwTOgR
	TTNFhZVR6c8cAyxT862GnU6lICPGqyY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-52-cF29On_YPzuyBEFrDtMLIw-1; Fri, 01 Aug 2025 11:34:00 -0400
X-MC-Unique: cF29On_YPzuyBEFrDtMLIw-1
X-Mimecast-MFC-AGG-ID: cF29On_YPzuyBEFrDtMLIw_1754062440
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4561611dc2aso20947315e9.0
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 08:34:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754062439; x=1754667239;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JHgBzHC9Il8/iD1hFbNzn8RBxkEg4S2pBSlpVReUImg=;
        b=AGuHiELPL2ixCLnFdnkL/qfzYlPm0Qg5v52eU1Eobeu5w4+Zk38+F5ZaRpcRc2A1Wi
         +5yAoOUHDDN3IeVIXoGV850cbibqP26Wp8lz1XTNreZKLxF8BfV6yDrrdYffaatX6zPj
         aVsBHthWB0ulLaRqGNs7cMYkN3UWILITpV4YqMRIYiu7u9hVWx8d7tFT8PzAAMQ/pvs/
         UjVC7lrstr8Dj/3auB35c8wAIFXtJIp+k8on3GBMrTZ05aUdIc0OoRotFrra+1Y6cXo3
         wkwyOnF53NvoKVeA7byl4GtRHgSk4/xY6r36SX02nbIbNMSpqzhh7XzNerkTUu1FlgM4
         ZJ+g==
X-Forwarded-Encrypted: i=1; AJvYcCWpyvsX1Mg/WEC2GhLOoxs461wEKGeMzo5a5I7EE6ihoWcHPLnYuO52DfbnXUYGOx0N0OsQ0io8XA==@kvack.org
X-Gm-Message-State: AOJu0YxMTDLFyYpFUCmfomBXMfbg+R5kGw8vCSEPfwBY2ojVZP8BYkGO
	vTIaqd34X/05obOA0+3SmldaZNZ41+NZqpundg9/vcLVZhiOZ2lgwGIV1K0VTMhnNpPGSYBL3fi
	L1GfBdlpSc7yl7evUs/NI1lKqIRSdZWBRb3KWCdA9Di/bPQa3T8BW
X-Gm-Gg: ASbGncu1xiWlZ0iuHMWQ9H+pQUtJ3mpocqaPW/sxoZtaNCA4ePSJZEXYIN5Fg6fYLEF
	T+uoi+nKa4M5Jb0TRk9OawtXxlAChnMKJTY0upBbHzf73uwd5EuXFYPQWpuP9lIhJQa5jXpfejg
	FcO1suMEQTT3w+q5F753KZtknsnPVMY9PTszkNO/qbkLACz+++y/rQ9i+3UXQxYE32opSXcXFyk
	BvlrObaVs2B4QjrnL/xBPMAK3k6OR/h+PCZuvHrJxL6634Z/4UNhEXPDSRIygsvNEKuHWWEjSHd
	+5VPKrgv/ooUYUL7KVwuaEZKmurIvZt/iu1nEF3DQUV/FpFHQoBKhJZhaUc/5vKRPlTaCogmnIx
	l8/gXxpvDIyLIQd68TuoC1NEImstnydoNNWAyKTGTSCjSFh/TFK9qc0Eq78JCk7KA
X-Received: by 2002:a05:600c:8812:b0:456:2397:817 with SMTP id 5b1f17b1804b1-458930ecbccmr78899405e9.13.1754062439572;
        Fri, 01 Aug 2025 08:33:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEVwQY4nbqQJMBDn5fImafjO6gVC20KrAkByKenJ+HrlbIwqOuIdKFnknmS+j6WRtdBcgZGsw==
X-Received: by 2002:a05:600c:8812:b0:456:2397:817 with SMTP id 5b1f17b1804b1-458930ecbccmr78898885e9.13.1754062439134;
        Fri, 01 Aug 2025 08:33:59 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:7500:5f99:9633:990e:138? (p200300d82f2075005f999633990e0138.dip0.t-ipconnect.de. [2003:d8:2f20:7500:5f99:9633:990e:138])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458953eb7acsm105359625e9.28.2025.08.01.08.33.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Aug 2025 08:33:58 -0700 (PDT)
Message-ID: <8368f30f-19dc-4272-bc36-13d6c2377bdb@redhat.com>
Date: Fri, 1 Aug 2025 17:33:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 3/4] mm: add largest_zero_folio() routine
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>,
 Suren Baghdasaryan <surenb@google.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Borislav Petkov <bp@alien8.de>,
 Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>,
 Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>,
 Mike Rapoport <rppt@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>,
 Michal Hocko <mhocko@suse.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Nico Pache <npache@redhat.com>,
 Dev Jain <dev.jain@arm.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, willy@infradead.org, linux-mm@kvack.org,
 x86@kernel.org, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 "Darrick J . Wong" <djwong@kernel.org>, mcgrof@kernel.org,
 gost.dev@samsung.com, hch@lst.de, Pankaj Raghav <p.raghav@samsung.com>
References: <20250724145001.487878-1-kernel@pankajraghav.com>
 <20250724145001.487878-4-kernel@pankajraghav.com> <87seibr7do.fsf@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <87seibr7do.fsf@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: adsX30g0HWtAJSxKCUdTKgE0gaTasl3tLpsZ40OUrcI_1754062440
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9E57040008
X-Stat-Signature: jer4nxoif6b5yaspp7g1aa7nu1ijafep
X-Rspam-User: 
X-HE-Tag: 1754062442-302752
X-HE-Meta: U2FsdGVkX19eiCO3RyotxBxGZr93BinDqMFwPux2G4xrAZScJRlZ0MAVpI+XCdd02h2kihrguniZqu4fHLPqbQJM/tsq5HMg/p6IeD46USWW2Q06O9o62oaMECCfspAqsqU9G8ZEwybW3R/zgLa2cxi+afZI0PTYUNO/BW9kt4qCdVNKq3qucJpzh4eZksGHHvAib7lEnnvAZjvzwLfRVs1ot4wSeJXv1HYDjCadtoG1qjJ4gnK9QCpzyvr95Trk7SgJ+Sg23l4Mc/b3vJrR082+xX750C8yY6iNrvYr3QJAzf4F/9vl5wuUv2/L0VqgkgTP6m0nteJUUihuSOnYJOVM3NU9zyfcRbJj6aZZVXWykv9zngwyYegk+S43T3Uu6xZM5mkt0Zklox0wMqRqwWfdb7I+1cEjotXhAsl3iGTJmJT2h3Ob8htHlmbHGddQIkexArcvIGdrdvCQy4A+MNdK3BAKe7A3fkXqt2qb750zBp93zRbZR9B0Yk/Y7856MdanP1a3z9BMU3Rk7+/f54zMIyA48LkNoCME3MvGmyW96KtIipO12tYAcvaGwFF0dyTQjyhlAyTHbztkmvZlpT050FupRqGQRGKyY7oPXBwX2DlEAGYGvH740r8Cr1K8QaOVU7C5fAjfmvvo62Ha6d1ylgBXcO+7bUMZa3TJql4bshZk6Rj0uCzFJ2nEQtWFq3s7TzAJAQA/OvrYXRBYIe/c1QkhJ6+XRlINhPWnkHfSCrZ6Mf+rOAT3o2cVmIeIVl4Ou/2Ig/pW4LfBnxQPpXEKWTQHxB7WmgqMMjxz+tGox4V0meWoitK+2pj4e7QbuN6zGh6FQJUAwg1VErJE7eggi951G0O5xYucm9DMORHt3wiba4IU094HJLvEpq+MUlj+C8gEiqpqxD2GoDE95N44R1HX8V8j6FfyrHI9oMlBQJ0Iy/wpw2hNW+I3bF1Kj58ET4L40YSo3cbHRQy
 sh/QTy1s
 43DLprd2OZKlXzDDyfpSgpGVyIMGYqRIbVZ43oRV5DHZ5w3waA9k0u/Y14dJEISU6/h2hM3uq+7MJZGjUP13qLwJ+QBSESjof1BaJmy8FzRPZKnlwJYvOR74B9QI1ulol+3BDw3vo695rAGqjujn4GtwfQBVHn0RrOfq0yPjkqFuQ+cjc11ceXu0X7hkBKi84j1FKjnwbs9bQrFB+9hy9QtM+qaYN70mSpeXSgqcpfIDSAqr915pkMvKPX2OXXwFL1uVwQy2f00BpspwVgPNi4FWZs1N0PfYp7/5z7VY+DTdaqM3+mybwe1mwCoKQ3N5qrePPbtggbD/67cMFPLlGlZoGC0uIL7I8nlqGBjflFB4wUSdY+YgWwGtU6k6YjdY/Fi05raaf8QrSRaCudX2wlDsPSvXR/CU7/iaAWfym8t8dzfoi4o16HbZXEMAwWrQTbXsDFiHh3C/Ojt9B4PgKx14vhJHmTjXFbr0nDnvlFaHesWsAwkEwceRcUVRz2ubiaNzkIfLqZXHedo2M0gEJYw5HhUrGd83XCUS3xSwCOMV4SFUXH6mqeg6NJA889a89VCgULkyOgmnH9JkqdpFbTgIj3jEaVGtUD0s7QIdyypphP+y5xcBpjBni9vPJSOL58WhQKmM4vl5NMcIHn9vPy0hAWQy+FPGsJfFB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.08.25 06:30, Ritesh Harjani (IBM) wrote:
> "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com> writes:
> 
>> From: Pankaj Raghav <p.raghav@samsung.com>
>>
>> Add largest_zero_folio() routine so that huge_zero_folio can be
> 
> [largest]_zero_folio() can sound a bit confusing with largest in it's
> name. Maybe optimal_zero_folio()?

I prefer largest, it clearly documents what you get.

huge vs large is a different discussion that goes back to "huge pages -> 
huge zero page".

-- 
Cheers,

David / dhildenb


