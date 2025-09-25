Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ED33CAC5A7
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 10:57:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD5498E0008; Thu, 25 Sep 2025 06:57:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D84FA8E0001; Thu, 25 Sep 2025 06:57:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4D308E0008; Thu, 25 Sep 2025 06:57:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ACDBA8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 06:57:35 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2A4081404A2
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 10:57:35 +0000 (UTC)
X-FDA: 83927471670.06.89CD0F3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 97121100002
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 10:57:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CNPWv3ma;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758797852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0DYqCFSuCSIJ86o5nMb5XOn3j7sQzEpNp3r66bySLEU=;
	b=RhhrgaWPlVWMmS5lLphHkI7BdNnT0iZZyZ1EvhnfggqakbL6E72Xq+R1fNTkohDA5lFIlQ
	TniVsvyl1MLNhI3tMbdbyKjTmpogCAZ/B8bfmMWu226SjhtCHH4paFAWRiUy8LkZhwyQiZ
	FuseJOdBwOnnywhMfsyUCpc2nIdHjRw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CNPWv3ma;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758797852; a=rsa-sha256;
	cv=none;
	b=fuwrPpLq1dhO9NkpZ1QkLppEE6pTOCxBC8RJ964zl750rGeoyVsFWVW3ei2dGQEsK3garc
	QtPkIacVAnrhlHvWctnFzkpBfyfA+aeh2Ib17ly9OWJJByeux9pqbg5+YhggH9OXg7FSlE
	oT8AqTwIl2qQKLfxR3l6O2ovIXzL6So=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758797851;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0DYqCFSuCSIJ86o5nMb5XOn3j7sQzEpNp3r66bySLEU=;
	b=CNPWv3ma6h8RJatGmB/f7Lt7lb65ZZfEl6oV3b6pmIZ8ImhlC9YUOcBsiMULQmHorb8w0k
	FPksws9HQOGNBF2e/8/lBstojPScVeIaqDhyGDs7FxvJtGkdM3L+iQNbxnUmp23w3NL+5V
	ce775ZG262YXFEb0qflHA8C64ZEQHWs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-597-udF6OM5_PKSBst-VrwQkeQ-1; Thu, 25 Sep 2025 06:57:30 -0400
X-MC-Unique: udF6OM5_PKSBst-VrwQkeQ-1
X-Mimecast-MFC-AGG-ID: udF6OM5_PKSBst-VrwQkeQ_1758797849
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46dee484548so4782205e9.2
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 03:57:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758797849; x=1759402649;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0DYqCFSuCSIJ86o5nMb5XOn3j7sQzEpNp3r66bySLEU=;
        b=rcJag1Mvtmz3DxyQUb7QqvB69TF0SVkg3s8eytly6eoXGDVxmro4wY3DbF4rgmQ9OK
         sWWVjh9T08FRWF3/OpfjO9B131jxg2plM59YVwFxc1dqVQvZHTn5CHvaqbbehNwL8PE2
         oTR6MwOxOOhM5cTwrShvyGNUI5rhNbC9pexHFOG+AckhJI3v9stn7cxeD4cVvLxLF1d8
         F7vsbTmc6816oRiilku42Tvx+ApNsE9rjtsL4gy6/cywalspIVeyM2Az1q1qoJyqUOd9
         SDK0u+pjZHZB7K+dvsJIVKfTWsm8S6A+vD3qhQ20C1f4XbbrFvoR0tpZX9MjTo7BvJMN
         Pfeg==
X-Forwarded-Encrypted: i=1; AJvYcCUmIFrdBewfr/CVr9OdRzo+Hi+lnJZzcyh4xG6CXLmWElEKUdo5XVHWwEm+6QvZfUEbA2Q7/m2srA==@kvack.org
X-Gm-Message-State: AOJu0Yy3IdCuMJbuec+Hz2p3CJhjjq7J8Bn16XT6mCB1Yyc4SjrIGuG7
	681GsYuSzNa/wOnWSqNeWH9cAKSdL0lIiJlNG6qNRQAMVmh1EZ8zEsTgNpZDjDxuHsNuD61Xelp
	ledyLBtmGAV+KuOBNVLROG///KZX5cjcTpdxvIO++l6tVyHVd5lw3
X-Gm-Gg: ASbGncvKVcjCOioAArled+lEOY9SM/EtXcq3hxx6f5eE0uBMMuabqq5PuUI4iArlL1k
	KCRFzoizW7yJLvNDDlVYdh/TEysvtkcwyc9J5esZQ3uGsOYuTQa2uKMiC6Yn/vwZQQcQyT/g3vr
	N8NmXIx814E2tZkRFRf4sc9FYvenkFOT2IYcCw+PPtsgqohitIag7N8jxRTwjEsJSurxAKu7ff0
	gipbZbw+KiVrEEt18aTGmrOt1Rplzfol2oCaPp8gdcJx04O9kV/Ke1U/0RV7t5LAP2p8jUIQloe
	/Vhn4VEUcNdIkxYBdgzLW8l+HamOmeQ/Iz75ajz34rgnMZ2nf/lRrDs5c/Q92SvcKfr55xFn8Ou
	zg1SRcD3E8WcFo4syDWqgDBUQnciYO31uzYHkCHfRzIbot1j8A/y+UgqJRNWaLED7VmZc
X-Received: by 2002:a05:600c:4f0e:b0:46e:1aed:5d4d with SMTP id 5b1f17b1804b1-46e3299eefamr35424305e9.4.1758797848863;
        Thu, 25 Sep 2025 03:57:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFfukPcY+om6jUefJHcDfs4SKfKvCwZQIFFSmlxwA+B+iUL77hVfMVdeVh9JpgCh4NypDIokQ==
X-Received: by 2002:a05:600c:4f0e:b0:46e:1aed:5d4d with SMTP id 5b1f17b1804b1-46e3299eefamr35423995e9.4.1758797848412;
        Thu, 25 Sep 2025 03:57:28 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08? (p200300d82f3ff800c1015c9f3bc93d08.dip0.t-ipconnect.de. [2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e32b5504csm16667385e9.0.2025.09.25.03.57.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 03:57:27 -0700 (PDT)
Message-ID: <17a11d85-9e27-4d9d-8109-302ef9cfb8ec@redhat.com>
Date: Thu, 25 Sep 2025 12:57:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: move rmap of mTHP upon CoW reuse
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Lokesh Gidra <lokeshgidra@google.com>
References: <20250925085429.41607-1-dev.jain@arm.com>
 <072b8684-47fe-4a2a-bf69-f6d348f0489b@redhat.com>
 <45e08ee0-c85e-469e-a3eb-4ca2e8b7ec0c@arm.com>
 <462bb4e3-7a38-4155-9f95-52fbb4b6d464@redhat.com>
 <26ca0d6b-5fd4-42f9-b985-936d9a72d307@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <26ca0d6b-5fd4-42f9-b985-936d9a72d307@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bLnpTGp6qD41T1yAxsfvR_XkHXu9I2hcXReOP69gfmc_1758797849
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 97121100002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: rhxfxx1mp89zn7n5izfcic4sghgk73bb
X-HE-Tag: 1758797852-349322
X-HE-Meta: U2FsdGVkX1/3yr1OUiaiWTyP6cDVvmwP5ZK+N04iFQc8T/G5oqtLG7cPaPF5ccj3zVUcMZxh12HBDxbOVOAhwL/SjFSkkSmJCEkEyBBcY5onYVoi4wz2AYVsnq9EQKEKL+9JMy1DlMe/I4+O86E/PaoAg6SHF2MP3WkfQlry6ugdj7r4ZAbRU5BvFNsRbHu0u0H0Bd0MF9CmfI/EVWd4VZHTlwWv+rO+W9GVkCA2vHtkb5An03+QU72/YmxlZa0hHRXTLm3dsHo/09FCC7fn6Lgk7YJ8n4u70H/mllWRhoiyaJNL/k9c4wO/RJoOjiWYkfNCyRifBf8j0p3NE9WRDwTc5OGS0JMgzyHQKfa3lvZGmWCuu5JwYKPTIRxMAR2SJKPewHQx3B/WnpaRyE0HdEJUKbEzjPQ8QoFTos1+X1cv97ZFUMo/kPyFxrqG0JdV5h3AM3CrQq1iJh8KRjL7c2Pyxcr762GM70eSDVM7ajDt0Zw0likcmJzb+gOb8GPfxtX2J+HO1g7DiSCDWcRUG/yx35UmaC8n8XLEdrae4tDgP6s3ZuSqZqavEOoD9qnLWUv4C5NNokRdq3sHjGsgl2nRdZ6z33XksELJn/Z6uoa0HiPGZjJvAJeHpNKRhAQWkbVTDGaJdwjV1eshm7wyTxqtknfBa4dgvkLin/xafraYwt76ROJpp4orGcWoBFspshsYFbSNMvMgC0XYLIWsWcNYvb3B7/4DhAKmhtVm4xjfcUB1S5KdQprqN3OG/6ezhshEHpqSTwfHsDv2gt5eR1WvIpxBg09K6vDHrSl1v0HplKtB6Emu8Ad5sC6OiLkulyPzxy6Jbjy4mAu7hTNQWz3GKeM4vcfxTcnCJXocfmtsXo/uStB+ikP8ShXIkCkuTa6O/freRBD188+rUGhuW8s3O0WL9+aXHIS9jItvnkjgmAxHmaQr1ZNrQA/XAGzBWs6CXzhEaQsKjdbvAGL
 OqCzZXIi
 oQU+UnQJo85X5HskEAS6hZojMWHCZF9x1tVIEBumwFv4BmW20BsY8qqPCU/FPXQ//J8QLT2lbx2ddYPet/K1QNKAmYLGWneeeLVLRrKlcCqXpFuv/xCqo2jZOurv7uLDca6FQq1o03ZjsOjinkH2WNXm8BsfY+QCcOCYR74YaadXpi8H1+hWJlksUSyGUk3gpx+ufnairjqhg5gkH3tTku2y1J41eJTcPJJVyUNxxq3EXcGozhOsPUBbyPNsnRHA1fVBHjqsK6KYjtbZjlg70O5gsnuU+SwGGFTXIt6+XFoE/cg7oBNGY7imt3jPt89FYuNns9uvew6QsI4JeO1F3Vfo5ulT7c5+KuLfuOwIXhRJZv9EKjNFHaXWP5kyzDxgNbhPRhhruaACPSFdi4ZyBWKitAQwlfL5lHlXPBKPowPo5VvWENM5ClvvxQQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25.09.25 12:50, Dev Jain wrote:
> 
> On 25/09/25 4:07 pm, David Hildenbrand wrote:
>> On 25.09.25 12:33, Dev Jain wrote:
>>>
>>> On 25/09/25 2:46 pm, David Hildenbrand wrote:
>>>> On 25.09.25 10:54, Dev Jain wrote:
>>>>> At wp-fault time, when we find that a folio is exclusively mapped, we
>>>>> move
>>>>> folio->mapping to the faulting VMA's anon_vma, so that rmap overhead
>>>>> reduces. This is currently done for small folios (base pages) and
>>>>> PMD-mapped THPs. Do this for mTHP too.
>>>>
>>>> I deliberately didn't add this back then because I was not able to
>>>> convince myself easily that it is ok in all corner cases. So this
>>>> needs some thought.
>>>
>>> Thanks for your detailed reply.
>>>
>>>
>>>>
>>>>
>>>> We know that the folio is exclusively mapped to a single MM and that
>>>> there are no unexpected references from others (GUP pins, whatsoever).
>>>>
>>>> But a large folio might be
>>>>
>>>> (a) mapped into multiple VMAs (e.g., partial mprotect()) in the same MM
>>>
>>> I think we have the same problem then for PMD-THPs? I see that
>>> vma_adjust_trans_huge() only does a PMD split and not folio split.
>>
>> Sure, we can end up in this reuse function here for any large anon
>> folio, including PMD ones after a PMD->PTE remapping.
> 
> Ah alright, I was thinking that something may go wrong through
> folio_move_anon_rmap() in do_huge_pmd_wp_page, but

Right, there we have sine VMA and single PTL.

-- 
Cheers

David / dhildenb


