Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51105C87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 12:37:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD5D76B0096; Wed,  6 Aug 2025 08:37:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B85D26B0098; Wed,  6 Aug 2025 08:37:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4E056B0099; Wed,  6 Aug 2025 08:37:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 904A96B0096
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 08:37:01 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 36AA781408
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:37:01 +0000 (UTC)
X-FDA: 83746282242.18.4698057
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id D60431C0005
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:36:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="I7EM/9bQ";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754483818; a=rsa-sha256;
	cv=none;
	b=MJfqsvoMgbYbsYkVM1a9rJ+UFlkZJcsNWRsRioaHAFcY4golW0vhKL1M/LSI9udOJvxrYS
	ENUILK1Tu65zt9QposrbAz8wM5wZY3tiCvI7HbUgcQAhG9LNlGty2YZxH2xL739fhJCSh0
	FQMZWy/8IHResmI/Bmi3fF4bHagflZQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="I7EM/9bQ";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754483818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Pkv5vGb4vPizTClmmeLaanBjDjkluYiNpS+o2ItZmg=;
	b=LT7NfRcBW5tzBRkLkEfNFFcPfyGAeVoqEY0C7Sv7VtPc508FbQvCcVN1Dg02WIXHNAGMr7
	OVpNnBYGY/B61GVw/qW46Fuo2w/IVpVCi4QwwSVCadtJaW5PZg5jJnyQ0K0U8vMYThenHh
	KeyAgmsKFTDBwa/SUoZdhIaCViecOak=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754483818;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6Pkv5vGb4vPizTClmmeLaanBjDjkluYiNpS+o2ItZmg=;
	b=I7EM/9bQfnMBniOXxnU4phfZhxJ8285hVzQthvXF1cdwcBrcwqj1eEsuiQUPYAqVJBCCRB
	JLjHAafboCNz2WPuFkBXvmksy8oa81gfB4TGNX7B0AkU0NTS56NJ5q0LqW+/ewroNAx0Rw
	MIlujF8Q0DoOFnKBZtgVdoL+KPsCCbE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-368-22GEFCbON06rLCMAsSxbPw-1; Wed, 06 Aug 2025 08:36:55 -0400
X-MC-Unique: 22GEFCbON06rLCMAsSxbPw-1
X-Mimecast-MFC-AGG-ID: 22GEFCbON06rLCMAsSxbPw_1754483814
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3b78329f180so4719206f8f.3
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 05:36:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754483814; x=1755088614;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6Pkv5vGb4vPizTClmmeLaanBjDjkluYiNpS+o2ItZmg=;
        b=U3dAb5pedIJY8FovksKz5BUQ/vumSz6STNELyyzd9FvNf+ZlFce6NyiEIEfYS2laaA
         1AXzae6KWkAcZ7JrWpMd/m/4OkClfQ2o+xWZBPcOir3OKjZb6k82IKcLoSutLBMH5xvF
         hAROLhCSJ3WWKe8eltKqKcS1ilTsEJ6u9+W12gdjPRbunCaheBKoII3Tv7opsCuoGch8
         bsu+AUq/nWJ4xFaHJERe65M4FfY7eLFwJ18Rlnm+GY1aPUGGc/9b4uehzyQQ3gH/KCli
         rnKWettSzsFY/1YSyBpp2YGpLIU0jrZMiy8Ciyfveq/nEMwSQCBdQnPKCAAphNp5bvCv
         0R3w==
X-Forwarded-Encrypted: i=1; AJvYcCUoHKRHPYx2yyLnGt9rOTtCTbDFRcBznJg44Xp+LLaMJu+Zx4WwY/2LOxPKj5TY5sK0WyFUlhFZZw==@kvack.org
X-Gm-Message-State: AOJu0Yy2K6YHNEYHxHcmqkry0ki3hOJF158Cmd1HWw2W2M65Kyq2sqbi
	NjMhqa92YF7ZqFBbfO/0h8kcnWAT3e0mTb3SFkqxr3H4ud/NjVDCUgFyKZnwO91q9mO3hcKR/f0
	BToe4zUc0IPXT9sU640zI38Jher/WIja31dL8nCvP63kMGxt4T/1M
X-Gm-Gg: ASbGncu3PYnREMUbSEHghgoysvAWOxiia7d6zUx/hzgeNY4goZTWCkyXLU5ioxcUMAN
	iYjypf4LHh6b5AWeyemWvh7F/8Kb+bc6wPLhcBvqoY0CKfpbg8GF7A+4MgUZY2DVw+/RB9qeJT8
	r4w1+nrjTZcBdZxjAuOGsXt67bYTR351h2aSM7ZKEGbr2qBC6ielYkEc3cvTHSFZc1z12t87Iq7
	/yVKIYGbyO1CVilD8AacxUaVYhRp4gSKV8m8hmtao0HQxvny1U3N8uCMeRu8gNsVGurrI0TyT2E
	xEPpVLWs172jnbeFoDK1FD4wibcK6HeTABhhL89/gUip39vxeVxGFQxouT7Uzt912xWekQ91eVx
	HDulhI/7lEWjmzyK5F4LQAXqniEVdwhXTkDRXG3mRG+P8z7fI08xdnTXTE8mflZ47yyw=
X-Received: by 2002:a05:6000:178a:b0:3b6:1630:9204 with SMTP id ffacd0b85a97d-3b8f41660acmr2148744f8f.19.1754483813810;
        Wed, 06 Aug 2025 05:36:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH/C9vY/dvP1mbV+qxCth5dE78JyvweRZ57dT9MYy/JANGVHP+NO3YKBQ/xfyqGVCamQ0UkKA==
X-Received: by 2002:a05:6000:178a:b0:3b6:1630:9204 with SMTP id ffacd0b85a97d-3b8f41660acmr2148692f8f.19.1754483813326;
        Wed, 06 Aug 2025 05:36:53 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f35:8a00:42f7:2657:34cc:a51f? (p200300d82f358a0042f7265734cca51f.dip0.t-ipconnect.de. [2003:d8:2f35:8a00:42f7:2657:34cc:a51f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c489e81sm23114781f8f.68.2025.08.06.05.36.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Aug 2025 05:36:52 -0700 (PDT)
Message-ID: <9a657c84-99fe-41ba-88ca-097acab4b96b@redhat.com>
Date: Wed, 6 Aug 2025 14:36:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] mm: add static huge zero folio
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Borislav Petkov <bp@alien8.de>,
 Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>,
 Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>,
 Mike Rapoport <rppt@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>,
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Nico Pache <npache@redhat.com>,
 Dev Jain <dev.jain@arm.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, willy@infradead.org, x86@kernel.org,
 linux-block@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>,
 linux-fsdevel@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
 mcgrof@kernel.org, gost.dev@samsung.com, hch@lst.de,
 Pankaj Raghav <p.raghav@samsung.com>
References: <20250804121356.572917-1-kernel@pankajraghav.com>
 <20250804121356.572917-4-kernel@pankajraghav.com>
 <4463bc75-486d-4034-a19e-d531bec667e8@lucifer.local>
 <70049abc-bf79-4d04-a0a8-dd3787195986@redhat.com>
 <6ff6fc46-49f1-49b0-b7e4-4cb37ec10a57@lucifer.local>
 <bc6cdb11-41fc-486b-9c39-17254f00d751@redhat.com>
 <bmngjssdvffqvnfcoledenlxefdqesvfv7l6os5lfpurmczfw5@mn7jouglo72s>
 <e67479f5-e8ed-43a7-8793-c6bff04ff1f4@redhat.com>
 <iputzuntgitahlu3qu2sg5zbzido43ncykcefqawjpkbnvodtn@22gzzl5t77ct>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <iputzuntgitahlu3qu2sg5zbzido43ncykcefqawjpkbnvodtn@22gzzl5t77ct>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: juGP4IPvYWyw12apm7oai98IN_2Afc8vmWcZl6PSm-M_1754483814
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D60431C0005
X-Stat-Signature: qfr7gpfksr5bo6g97nj5bzc9ihkswje3
X-Rspam-User: 
X-HE-Tag: 1754483818-428412
X-HE-Meta: U2FsdGVkX19dXTjRbPJkQ6QhZuj4mbIn5cKEt0QvdtLBT9uGd/3ZBctLYLIVUSzVq1LU3if1Q/XZnyGEl8p8Il6xKAvhnNCoM8Zak9mSDioULps4PPnWMKqhdzb5A7AGYOxShCA42P7Q7mSHSXEmEh8nfiXIihmFnONNf+MPx1BhBJtiNIPGhhQbROH6OWG+PBiYkVFftiejtF+bwMGCXg7KeQa45ebbTRJgJDklawnZUIYYYCTWE4PfBKG/PiE9EaLAnPFOPOpTJg05FDJI/bZoYOxUBH6Hx9kRfJ3Rj5N2MH7YwPPhngs0u8YnS5KfuJAZzQbLB5VcnTbhACO9s4lAUSMOWG0KxaXrqY7pvN5YJc0SDWJMjfTyPmu7EoX/TWKIo3LymLYUROKHrFQBCRi8CGjXZF+OrE2kcqjAWX+Aiq7qnU0k2d0JfvKyuI6V3PccJWKkOKvghPSZYTJNs0KxKpG5c0lMo9W3S+f7D4xx8fkhJEQ9EH7c5JCfyzMMjAsYJTXnTwxfOE7+t+MmgObK836QySdjfUrE8PRn/N8PAto/0n/DzmJ+OnprKiALXwcg+ZC4BacYUvqra2/otC/4OpJqkh6xUHe2IJs1YTcfiUdzc79+w54wGsswrmLRpqE48qnvf9gViBiFigF/u2ubXvPNNVVwTmTCviAroF2MHJcmAhDn9CVeZp/zEfDD6+j9hOym5Cl8jxK/tbOx85jgkvvAuWp0+ZNUsCZJJUAm7HeHcKhKMIaouNGUA20v60S8FgoyzzHCe07kXuIzL+NKNOWkRddsJDZCBnw32/RrnyqII/UTNefrelxrwTPzhy3AfR8ujuAPHvLNFI4veyPul6m68lBNAnpszTFJS1vJcYhunM08ZSb/sfcM4aJrtrU4idznKuhahUaHIXDxdTsN/ugMPY2hmTCFTtGbmlfpzkU1Mw3ZIpDb2Ox1U4uEccRphtpZLbIC1wCfvvN
 veielpFc
 YJGqB9qc5HdXREzqf64Tj1JK5G3NNGIon4sOEWZ/JqUszWYXqQxtXLUfyOGhWkWPrfzLdSCdGLM8U36ukQmfE4ue4Nz5a+Sxf8Q8O1hctPrPK99JtEWfgxHM4/g9vwGA/dCtS9MVniLknjEPJ6dsYOid9jv2tkzhSL/rkhP+n7HtL7vrtBqkSuhtMrphMa9W0TesYfY9BlmOBkiF7f3Zhfpfee3EkmCIivxhhxeBKh+83Ph4YuEKgFvoFWq6dKkpu5YwtSPaK+nIllVdnLD9CnVXVsJJavKBhVBVXJdmeTZCDqXcsiHlupySXePx1thtUJvr0LR8Ity8F7aIY/x0GWmR6tkkbIl19Gqb+jy79atlzl6Q0RwFNue0LllT52mFqNEf7Hq7oVqsMob9JX4V2QVOH4V7ThUzNPcla50YHiwsnfBIXwnVwuCRNczeUZrcHR83wOKP5yUND1QM7H4+iptGQRqS1eKkxaKpCkaKIXkwVHduXl9MNWHVV+2Tc09I4jpnrEfGtxD1+2FgoJvo7HBY4vLDi2A/xk5J6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06.08.25 14:28, Pankaj Raghav (Samsung) wrote:
> On Wed, Aug 06, 2025 at 02:24:28PM +0200, David Hildenbrand wrote:
>> On 06.08.25 14:18, Pankaj Raghav (Samsung) wrote:
>>>> We could go one step further and special case in mm_get_huge_zero_folio() +
>>>> mm_put_huge_zero_folio() on CONFIG_STATIC_HUGE_ZERO_FOLIO.
>>>>
>>>
>>> Hmm, but we could have also failed to allocate even though the option
>>> was enabled.
>>
>> Then we return huge_zero_folio, which is NULL?
>>
>> Or what are you concerned about?
> 
> But don't we want to keep the "dynamic" allocation part be present even
> though we failed to allocate it statically in the shrinker_init?
> 
> Mainly so that the existing users of mm_get_huge_zero_folio() are not affected by
> these changes.

I would just keep it simple and say that if we fail the early allocation 
(which will be extremely unlikely that early during boot!), just don't 
ever try to reallocate, even not when we could through 
mm_get_huge_zero_folio().

That sounds as simple as it gets. Again, failing to allocate that early 
and then succeeding to allocate later is a fairly unlikely scenario.

-- 
Cheers,

David / dhildenb


