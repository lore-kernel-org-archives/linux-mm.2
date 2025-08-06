Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED160C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 11:29:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 766DC6B009F; Wed,  6 Aug 2025 07:29:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73E926B00A0; Wed,  6 Aug 2025 07:29:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62D206B00A4; Wed,  6 Aug 2025 07:29:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 52A006B009F
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 07:29:05 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 037E01A054D
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 11:29:04 +0000 (UTC)
X-FDA: 83746111050.18.13B9F0B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 99AA418000F
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 11:29:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="B/i0CAGV";
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754479742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lYbYIyAZ4oaVOmnPS9kKuJWUEwG+7pddjOFtFzW7yY0=;
	b=kevIMA3aRV4JQiN95KQuLb4K8s+ZqhGiI2orq/9ZNig78Qqg1/f3ENB20raZbpMmSdl4U6
	MdHar8eELlCuKwnanRIPPzBEsFDvy20kTMnwI0pdv8uUUcXKgHdp7tnyBWxVLTwketJuLq
	zhnl84UOFK5EnSHgLzz6J8WCxoIENHY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754479742; a=rsa-sha256;
	cv=none;
	b=GMu7BjCTwsnDsleFmMJ9Zu6jhzY3FWkZh44ALKzA49RexaJ/2lEUrQ0VktXLBc7MrMv8ab
	PyBa0NnowIi0YhlWaQ6mNSrjWFOSJ1gAY+UAyrhbhMNJn8t99XPcsY0izRZdd/i7XTn8c4
	BdJCwAsxW7WMeChIy0HyrA+Ww+GIYyo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="B/i0CAGV";
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754479742;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lYbYIyAZ4oaVOmnPS9kKuJWUEwG+7pddjOFtFzW7yY0=;
	b=B/i0CAGVSxAv90nCW1Wj157OtAkrjIHmYjrlrRxq9qALrLMz918Uw+xoXzdw20jmHYqDQX
	/PDRwupUqns/l/hXgopcINs+/BjSvvQLdy8GktFve5+9MA6CDANHBX0cQWuzILHrEZtguI
	/7S/quQoLnIZRw4gaK2vF6/Adlgaqts=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-27-pAJeeoRNPgqzeDARd4ZLHA-1; Wed, 06 Aug 2025 07:29:00 -0400
X-MC-Unique: pAJeeoRNPgqzeDARd4ZLHA-1
X-Mimecast-MFC-AGG-ID: pAJeeoRNPgqzeDARd4ZLHA_1754479740
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-459e0f54c88so4944285e9.1
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 04:29:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754479739; x=1755084539;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lYbYIyAZ4oaVOmnPS9kKuJWUEwG+7pddjOFtFzW7yY0=;
        b=kRgLZ5zNjUIn0VXcNF3K8gH01pOmDXld00oNXjp8gBr53cYt6aoVICCoI/fYBc1Vgr
         4ky+UuG3PoptlgRE0FS2fY2IE45r508FbQgrQhtxUM8MSFk8T4bArl4P1lfbhvu9W9rh
         O0g9HOY2RlKNE+n7fr/1ZOC58O6pGsWIOb2lOzKDfnUQHhiPdYog9lT0uyNBWkKyoFpG
         l4W6xpr8cFBlyB0uKOKeLDSPY7pMx/VsJ3mDbwXPTYNwP71iJdZ1qCj2xPyKgrm1pNpT
         7+/8ivLWraSDDTdUXNQmkn5iXDEz/Rw9aupPwWyJxftvFkcEkNEvJusOYjdVSgfGeNGv
         uLUA==
X-Forwarded-Encrypted: i=1; AJvYcCX5daaDg/aEi7rOsCdt3Ac7TC8+qAbo5TbGuEhUCQhR94muYRHT/ZVNdKQfsWvzmjTpvHh5y+fUVQ==@kvack.org
X-Gm-Message-State: AOJu0Yx+Yn7NrxrEgEXu5NHtgb2SMjZ1PtdKGvnFI2zqcrEbQUymyyPn
	R8E+LDx7KbIKdXLqjioXdD8KewF3SEhAPgkguXGVPc8bFM0elBnRJzcFsHZVJqfTVqOcnI0XWxD
	InHPa6h0YH1vut+xhwpxtuKq6VMCA5TLok1i7Vp6EDJ4I7JM7BAzF
X-Gm-Gg: ASbGnctPUJQZRIOfK20RUY0gG9TyJ/ZE1Do/N8iOUQACJPBIQyC5XMz5eBcDuLEeNtT
	g1klYz0ymcvtD59Yd4SE9Y4feYv0ELvXi1SW76oCYxI0xwjm/yrtmkXmTlFxVTQhUyfJv4bKj8S
	jW55P4FIefKp40DhQ3DYXxGaMvRZQO3A9GdicIwDwJvswUA4I5Dcbw2IgU77ZZMLmVYN5hWXChM
	wlWzL37KSkD44YyJiPDTUvzzduynUBNGU7B8UpYPGPwQwCg68zKuccXFUG6QI6Sk/VyejRlWmk7
	2sy5a+Kl+F0Z8cc7BqqKgRp8qqbp3OmGazd+XCoEtIF0logj5elOPLN4TQXWXdRT0N+rQiFcGbD
	D1m5LVyi8vR4V8ooIyLqvOu7igsu9iezedYPtEVQffx8Clk7twzWlkH2J5NEXc4FNjeo=
X-Received: by 2002:a05:600c:19cf:b0:456:189e:223a with SMTP id 5b1f17b1804b1-459e70cdc76mr23327015e9.10.1754479739609;
        Wed, 06 Aug 2025 04:28:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEy2UbQNnTJj8kSlOYhDTdXWzLJg+Fm8eoPyd02PfblipaRgBhM/zfUmFaLs0jdNDHqGe+LMg==
X-Received: by 2002:a05:600c:19cf:b0:456:189e:223a with SMTP id 5b1f17b1804b1-459e70cdc76mr23326685e9.10.1754479739099;
        Wed, 06 Aug 2025 04:28:59 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f35:8a00:42f7:2657:34cc:a51f? (p200300d82f358a0042f7265734cca51f.dip0.t-ipconnect.de. [2003:d8:2f35:8a00:42f7:2657:34cc:a51f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c47b10asm22303636f8f.60.2025.08.06.04.28.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Aug 2025 04:28:58 -0700 (PDT)
Message-ID: <8a39bcff-d0cf-4c1e-a076-f676a9ace4ba@redhat.com>
Date: Wed, 6 Aug 2025 13:28:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] add static huge zero folio support
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>,
 Dave Hansen <dave.hansen@intel.com>
Cc: Suren Baghdasaryan <surenb@google.com>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Borislav Petkov <bp@alien8.de>,
 Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>,
 Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>,
 Mike Rapoport <rppt@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>,
 Michal Hocko <mhocko@suse.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Nico Pache <npache@redhat.com>,
 Dev Jain <dev.jain@arm.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, willy@infradead.org, x86@kernel.org,
 linux-block@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>,
 linux-fsdevel@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
 mcgrof@kernel.org, gost.dev@samsung.com, hch@lst.de,
 Pankaj Raghav <p.raghav@samsung.com>
References: <20250804121356.572917-1-kernel@pankajraghav.com>
 <c3b0adc9-e8e9-45ce-b839-cb09dcce3b50@intel.com>
 <sqpsvjefzukhqbumjmnhsotixw2vpdy76d3batdtlbztzk4q5w@osrjvx22pvah>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <sqpsvjefzukhqbumjmnhsotixw2vpdy76d3batdtlbztzk4q5w@osrjvx22pvah>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0nJqjxrniqYFsxzKPeQqc4eEp2Bfg_eEIgOeHBuIVHw_1754479740
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 99AA418000F
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: iehthhmzbo5w3yg6wfbd5wysm8m6h34r
X-HE-Tag: 1754479742-676580
X-HE-Meta: U2FsdGVkX1+lY26CIZFFWb9mbn82Tx/S//NyYpaCOnDeVXJjzGN/w/5iP9gUtZELymhmE4WSJm0NCOW1doOxFl6yyDGV2SKVJEnWxdRydgJf7rISEYcoyDQ2p/c2uHIPl8Ls6YKaMYEvZ0e5a3gi5NxqP1xixgNrdMedp28uVz0Vt0muTId69in7lmW4BIhdDrZQZFVEDOOI+lYIgHP+xyYPkSmVv32vNIcDJ+xFQYGtGWz40ihzV2Ysrj3dTp+Cpj04pch36O9QdGAqh2ZIYsuIqDlocZiJeSNSzyybRVmBr8Oh0gfwa2mXkiQ0pGpsoyepcXZJD6RAyo/tR2YOgjKm4eJScSzXxRMcC06xuyUr/x3DY9psM7eG1gjUFqfIsOK7bnFNHXQ5fMOdJJdxSG+Oa35/7xlBPkUMPGQWw6+zY7rn5rkDS0+o+jp0VzkPnutCrM4rpIyXertRF7qD6a0soL0dGU0N+Q4TydPUzpU4sIK7uosVGE+fUKSQ+YTYamM2AxFztlmhlvaEOVZd89rSNjufFnpoRqsh9v4DkWIWzZ9iJBn4ohDH2Ju6BTP1U5zoLfYP3nMuBcor6HZizoyrRyYYjYWeESKYgxDSvq1vQ2kqerOAigzBHrZoCcMi1xdAnfVG931KEE82p+OG0FS1asONz34R8orHVEtZF+1dPPVLLTFXmLj7ADV/COxorNmTuwoCoxVx9FhgVsSVwNNh39xMPjhuvkkrY87wl6NhkOTDxVH9HTufaWTJlttoTntHrT+uW70AX81DnuMwyYzko/a3kSkVTnWP4r1mKD0OtCHu2ZvJNwC2/sj5wvybfq3f5C9VvTFBXMxclborC/MYDXNDuXL5DfXm+GtF9AcytJiGL0DtI6BiHWLAGtjXEp7K/3bWGV9avyizhpC6wPgBmNUa69nAwVDp+qHp8LiMQ6J+HULo7xt5kSiiA2jrwMeqT9rD8f0kSaiRqgD
 6Gj0YCGh
 mLIX4Zh84TsOsSHn8mI0uvYPZyC9PWFvlkycn+OC9ICVfN81APcZ//7WUUa0uDcl3inlYHPX5eSiB9NSb8yb31gagZc08XWKtXXaBA8XQqdTK5V5MF2eSza6D3SOFoHrIY4f1WqDBKPgxiVk1lyG5sPO5rVH6c6ldRfoE9dP9PiIAU8WEvGLlMmjIVRzwyrCbEwCLTwL3SnjAFvxe13R1E3XaL9aD6JY0Gwd6RnI2evCQBwyI1XVp8htpgu1g/I3yS6iQ1TpIoR6BPovv3fgXw2eZ034ZuRK58mI+DlAafT2DYIDwvROwAIzMLSy37ZhOe4zP/cMdmIVUpWMSderGb2j3FwgGxIqXQpLNxGdAE8E7cQGSqlxdqDXssBKABbsetJRYPomFgoQmzCaf5N8lR5jTLhBvBG6B0wWLym9LQS/0eOfbibruzuACx8Mi8dw0BBhXdK8jnddY/YxuK/YC18JVZsuy224K1w1woAUbFlA+MWeBuW5JQyG1jaFNMq474GR9rLi0DEvO0InRfK3kZWltnlMNxhdlKAKw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06.08.25 10:31, Pankaj Raghav (Samsung) wrote:
> On Tue, Aug 05, 2025 at 09:00:40AM -0700, Dave Hansen wrote:
>> On 8/4/25 05:13, Pankaj Raghav (Samsung) wrote:
>>> Add a config option STATIC_HUGE_ZERO_FOLIO that will always allocate
>>> the huge_zero_folio, and it will never drop the reference.
>>
>> "static" is a really odd naming choice for a dynamically allocated
>> structure. It's one that's never freed, sure, but it's still dynamically
>> allocated in the first place.
> 
> That is a fair point.
> 
> I like the rename you did to PERSISTENT_HUGE_ZERO_FOLIO instead of
> STATIC_HUGE_ZERO_FOLIO as we still allocate it dynamically.
> 
> @David, @Lorenzo and @Zi: Does the rename sound good to you?

Yes, sounds good.

-- 
Cheers,

David / dhildenb


