Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7F59CCD1A5
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 19:18:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 315CB8E000B; Mon, 20 Oct 2025 15:18:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ECAB8E0002; Mon, 20 Oct 2025 15:18:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DBD58E000B; Mon, 20 Oct 2025 15:18:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0D4D08E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 15:18:47 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9B2AE13A3B6
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 19:18:46 +0000 (UTC)
X-FDA: 84019454652.24.C31A68D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 27422180009
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 19:18:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="gBd8A/ht";
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760987924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U3DQcRoLyYvhq2b3CfiotZ6Bx3GJ7cUvWYSw6ndhrIE=;
	b=EkXz/41YeVmbA8D9TdGoWLFqSbzRPB48MV21hMnBIuxFakvZylUJImsvpkRloPaOp4ARCU
	3zk37CHyGviAOIyk2i+6rPkU5WsgEyc5OHwiIojlk8OOcvnYZqmEEpQ+BXbREJIeZurLFS
	tr++Cynt3ZAhTvQPyiSIFeKM0Dj512s=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="gBd8A/ht";
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760987924; a=rsa-sha256;
	cv=none;
	b=oPtb10leqxbeQvt2uDyuhCH40anWa4amm1dGdTL2BMM1iubfgTwOWUT21Ao2zrvWaAgtiR
	qmSljZikVnS+QcWMk3DMLvaONfVsrnvHjHMgEXLkSdCWyR6BgmNsxh7xAY9Tvy+PMM1XiT
	UOB8ABSRa7tNC/mrq1fqGl1I8cFpgps=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760987923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=U3DQcRoLyYvhq2b3CfiotZ6Bx3GJ7cUvWYSw6ndhrIE=;
	b=gBd8A/htOdSfzUaC0ZUIix0kQ/LBPnD1qE5W3G1kIP/expAhiz4ohL1qGcHoytoSX3S2TX
	ruU1O1ndv+TBBuhV1pYENoHN23cuW+3mrAH/GtlPUXYviRyTv9YYW8ZrymUOVfmtler5Pa
	xD4DsJwiqHQY3mnW3YWzTquSK3SbNf8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-619-c3dKNPoKMN27FLhsENK_Ow-1; Mon, 20 Oct 2025 15:18:40 -0400
X-MC-Unique: c3dKNPoKMN27FLhsENK_Ow-1
X-Mimecast-MFC-AGG-ID: c3dKNPoKMN27FLhsENK_Ow_1760987919
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-470fd5ba449so16743375e9.0
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 12:18:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760987919; x=1761592719;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U3DQcRoLyYvhq2b3CfiotZ6Bx3GJ7cUvWYSw6ndhrIE=;
        b=KA98wH+qZitVjp0bqfQwUdJvK5QeJQJi8/54vuSZU9KjpHpOpO8VjfzEBmhnrr5KDc
         BQQWm7UMSEoewMAbTZZqRN8NTqjxLvHhbrpy6Bn04h13EJ+eI1EvYT1rCxmx9lNFoiGX
         FAOvWGP4fy+rkmq4ao1qiwob67TQ9Y3gYgZoiEKpo4rD4dbY5vZSryzcmIlF72hFXu4D
         8/osn9uezMuELaH9H4MlZTcLgPqsNGi99kw1mCLRdSyen5BwkXPEzLiw27C/qXgZXWHq
         ghuQYVC7v+wOPudkLO68SbOt51SkS0bPEtg5pqWe3FwSE12qEjwLIzY+ZigafJ5irBU3
         lNhA==
X-Gm-Message-State: AOJu0Yw4BovH3grqS5eLBgzw1og2KXu8IXg2JqdLqB3Fq5sJs4ah7UgK
	rMmkey906IWavdzKmPFj+zeGeVolHiwGvTlDcp6Jf/AZhmKV84wPHlJUD9GiOkstXq02EBmKP53
	9el7hucOsP0YiuQlhdjKdNHiDXpueKLFBi1C3iuDKy+dYfMxcuF2G
X-Gm-Gg: ASbGncv3nojzylsJjqE+sOuFGxngKpSAmWgOdJZ+NKOC7l+DwL3Mk8VRfEMYeDN1spD
	T0KdlgsNOEstRGB9uKHVEmhhUKK9gVL2LTU+ajNrmx8USqZk9eXbNRNSJWNJnmegGs9/gt2b5yJ
	31U3sVNSutvFjJPw++8TGjkkdjI4+sC9t/XhTr6hSR8+H08BUwZw7OB5us579Bt8AUgnaN3pJEP
	jCKUB61Ll9RAV3Q17I1oAhcTd6E27YLjtU9JbeSqzLDSqSkBOnYvHfXZ7ATSR2BOFo9bFVj49ZD
	xkbWFkvQUyCgMY4fHnEfdEoY9RtDHGlrNbUL6N/bqEjEZlHTrtwDiVDd8YM30vzIEmIOo8AFYKu
	Wc428HLiA0rWTsFX39MwTC7TZqBv81icA3kw7fNxgRyXokvykI1vdtjkww1ot6efi3XLc5Dsfb5
	CzPkQ6UOP5TzmeNOWC1wvw7pKbLuc=
X-Received: by 2002:a05:6000:2410:b0:426:fd2b:25b8 with SMTP id ffacd0b85a97d-42704bc0d90mr11819405f8f.17.1760987918990;
        Mon, 20 Oct 2025 12:18:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEYbOFgfXtsl4V+IXlQsTJKLseum2E9JtQa3IP+ennwBOv0bsTQGGaaKspULvmUG93wUYtq4Q==
X-Received: by 2002:a05:6000:2410:b0:426:fd2b:25b8 with SMTP id ffacd0b85a97d-42704bc0d90mr11819380f8f.17.1760987918547;
        Mon, 20 Oct 2025 12:18:38 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427f00ce06bsm16367483f8f.45.2025.10.20.12.18.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 12:18:38 -0700 (PDT)
Message-ID: <272c425a-b191-4eef-af6e-2bca1db7a940@redhat.com>
Date: Mon, 20 Oct 2025 21:18:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] page_alloc: allow migration of smaller hugepages
 during contig_alloc.
To: Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org
References: <20251020170615.1000819-1-gourry@gourry.net>
 <487730c6-423a-4a03-a668-9b9ff92a5cfb@redhat.com>
 <aPZ0OKx_VnQ4H_w1@gourry-fedora-PF4VCD3F>
 <609E7E01-33A6-4931-AC89-1F4B2944FB64@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <609E7E01-33A6-4931-AC89-1F4B2944FB64@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _S3oMKN06FsrilSoqZnPQO2S-IaZq4welogssF3hmPY_1760987919
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jjph3dgbfinw3qm9bfa63g5myqg18ujn
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 27422180009
X-HE-Tag: 1760987923-451688
X-HE-Meta: U2FsdGVkX1/xvqWp+UkO6UGl6j/uk5LqsdOnx3lNCcxGbG7Bmxg4u0T6XJ6ScwzjVV2cxc7Si8OoOfuZ0rbzEbmpHfvKDI3W+A39hdOdzCZIpCf9KQE6Js9qBeqDZ/Xal/wzvF8ha1Ud2+ajcf18+gsSv4e+rAadJFpe+A4PJdk0RvusS94SKVPeKqBlm/g+TLqYDXvbPOBM92EEq8ncteypL3X0L8vs9oZ/Eqwi9pX2Aokz5TOxChiWbrh1XnoN+S7OBQQaFHWHpxn1ozDR6JatbTfYpgkn8kyjpMLEujxEYWY34u9YlfhzBBqVhK7T7F5tkipJVY+nt8auc6dITyzoOfcrUk+roaSwL+jrVCHkkwEJ3bMbknpwx3LrF8wq9Yq0EYyyBzwe8caCC4IsyPAgqBzHI1TCcCLALRoPRieAwnd0b0ALsf1RieCY/e4X26E76RuISxyV8UX/NxOriS6FX7GsCQ64sqMS/0MNe0RdgaxC3ffw+AfL9sXjcBuQ0ewuDWfcBI26orgP17Pd82ImHtqD76USEpco3Vp8Fi0PdudcH8KJSMZRIbXribMi2Prs0RB/XUW3pD2Xmvj1sz0wmjAS6r2BDdCqf2BmA75JcMTO8ig6Mi1vyL3G3hU0hEzP1rIPdksHGDcIxI8eppeNganOHfBiRcEEFGUDeexK5G3o1Ek40avcTQs+EBeqbxaVYQi3K0hn3rA64B5mNHhAxcozC4gBEOnb7cohalSust5U+CDsDskqMpipuJTtRpjjit9YERjsexbR3IL3qKN+UqWeSLhFVB9Kf5nHr/zPOaeFaCviUbZeS3jchaP3cvcViQq4nNZ/eaiUkbwO5Ei7JSQ3pVqdaf6lWAyaDE2WMqmmumPq1nnBM2m+P8veIJiA6wN8WTPTUvhHchaxukCWle8L5PSs2kR7+6vXU8pUVIo2ThVEe2Yy/nPRePXM5tEYM9g4q4hU6YJ/wwl
 O0gWhVNU
 scTjfM4qOqD0PuHp0vsdXk6MNT0yt7TNWzGqDgsilYtkmgLc8Ru9QDZP3uV347azVv6Nx7ADGOf3sfofPHubal1FNdFoPYAs1M7VM9tJNQzFE+Rlo04jowkmjXUgj31z6SDZ3IZcRzH0Sf7Ywt8oLSaObXvl83HWY9tHT8sZFb2ogQbBHIvKFQK/+CHYehiyc32WOePm9UatFnRf51UcoJMCL3IUemo0Bo6CCIYw1LOsKu1Zs8a8Y0jyGZ5Ojo6kSqjMeJTH74Gcr57DlDNfWBIFcoKvhBlaUvN+2nOiqzwPEiNvwuU8OmyY9m2STaSShM+eX/4DrQs2J0qv+NAPYYpNqWWu1Kx6sFktJ9YKSPlloySMpZVHY0aMuCVzyqUVJekp2fgCR340CVEDHULO96I9jWPpzSXHCH9M6ZiQnoqcWnlzyJikR0XKCZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20.10.25 21:15, Zi Yan wrote:
> On 20 Oct 2025, at 13:41, Gregory Price wrote:
> 
>> On Mon, Oct 20, 2025 at 07:24:04PM +0200, David Hildenbrand wrote:
>>> On 20.10.25 19:06, Gregory Price wrote:
>>>
>>> Do we really need the folio_hugetlb_migratable() check?
>>> This code is completely racy.
>>
>> My thought was it's better to check if any *one* folio in the bunch is
>> non-migratable, it's better to never even call compaction in the first
>> place.  But you're right, this is racy.
>>
>> In one race, the compaction code will just fail if this bit gets set
>> between now and the isolate call in folio_isolate_hugetlb() - resulting
>> in searching the next block anyway.  So that seemed ok?
>>
>> In the other race, the bit becomes un-set and we skip a block that might
>> otherwise be valid.
>>
>> I can drop this check, it's just an optimistic optimization anyway.
>>
>> I should also probably check CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION here
>> regardless, since we should skip compaction if migration isn't possible.
>>
>>>> folio_nr_pages() should be fine AFAIKT (no
>>> VM_WARN_ON() etc), not sure about folio_test_hugetlb_migratable().
>>
>> will change, and will check/change based on above thoughts.
> 
> If it is racy, could folio_order() or folio_nr_pages() return a bogusly
> large and cause a wrong result?
> 
> In isolate_migratepages_block(), compound_order(page) is used and checked
> against MAX_PAGE_ORDER to avoid a bogus page order. I wonder if we should
> use the same pattern here.
> 
> Basically, what is the right way of checking a folio order without lock?
> Should we have a standardized helper function for that?

As raised, snapshot_page() tries to stabilize the folio best it can.

-- 
Cheers

David / dhildenb


