Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DCE5C5DF89
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 14:18:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83BB66B009F; Fri, 21 Aug 2026 10:18:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 812C66B00A0; Fri, 21 Aug 2026 10:18:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 728B56B00A1; Fri, 21 Aug 2026 10:18:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4FBCC6B009F
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:18:41 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D58D81C0141
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:18:40 +0000 (UTC)
X-FDA: 85125482400.15.C837528
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id DE0D920009
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:18:38 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mCrlU9qn;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787321919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=25aRKT2H17E3+b7/M5uXvQXwb5OfRhehW7b7COK86RQ=;
	b=8RZEHCOqOE61SZzVxIu5xRlG+k3Fccb1HFrFMMLcK8npbKx7+EZ+UbV6t3ARP6C8iaTy8r
	0SzAgzbOypSrkD6DqYtjgyOImiXGYmlQiSONTi3NHf05wN0JIeSNFwnd+33io+7CqQ1Nht
	7w5c7VxB9C8mhbI0g2UQ4E+FbnM0Zvg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787321919;
	b=gnakmuMfdj+Ei+9nyWg35csl1CyxAKduc7Kgce3/Cfk2OnQayytM5zywsmVpoJDjKlRjBV
	ScS2vyc/FE5boFHdJRrhLGFDFWif0NkJG8ZmIuqndAz44AKSOsxD3WYhmVkxKq2CcjOvwD
	31xWGJ43qJMwSNk85NVeIkSn/nhZ4MQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mCrlU9qn;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 007D1413DF;
	Fri, 21 Aug 2026 14:18:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B9141F000E9;
	Fri, 21 Aug 2026 14:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787321917;
	bh=25aRKT2H17E3+b7/M5uXvQXwb5OfRhehW7b7COK86RQ=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To;
	b=mCrlU9qnLmCDoMjoYWy2y0kteLWFvhGmH4vE46dQiE+IlMGWWq8McDNVEzD9elWx3
	 juv4qEb/MC/XNLRAklmjfLHtMHpTTvfP7oFgME+Rhl27NzU6spRtGwNmfWK4EEyMqT
	 9t3bYLGlSPN9dEP7JKVf14K131nuy0Q27ZhwLWf09RqEwaiVKjfypqlxLrzG+VZn9V
	 rO67iYJpwiEMYMyxDQi1csCNK9oWDQzBQMnxI41NR1WVZGTFszMidaaQcA26nTZMBo
	 6XmAJt7zrmAJTzv9Rogz+Ve8y2GeiqFxsBr2iucOrW+9M6FNqTwvnWC3DRDfNM48FF
	 BQ9vTfkzJLoqg==
Message-ID: <cade8707-26e7-4f8b-a056-95094bf8756c@kernel.org>
Date: Fri, 21 Aug 2026 16:18:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [RFC PATCH v3 0/4] mm: enable lru cache for smaller large folios
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
 baolin.wang@linux.alibaba.com, dev.jain@arm.com, lance.yang@linux.dev,
 liam@infradead.org, linux-kernel@vger.kernel.org, ljs@kernel.org,
 mhocko@suse.com, npache@redhat.com, rppt@kernel.org, ryan.roberts@arm.com,
 surenb@google.com, vbabka@kernel.org, ziy@nvidia.com, hughd@google.com,
 ackerleytng@google.com, usama.arif@linux.dev, joannelkoong@gmail.com,
 hannes@cmpxchg.org
References: <20260818225904.55236-1-baohua@kernel.org>
 <c8287b5a-8f8b-4110-ad47-996842f01bfe@kernel.org>
 <CAGsJ_4xT-Nga9yCa_QtbmFQ3tm0LJF0doCsV3pJpO0i+2z4yww@mail.gmail.com>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAGsJ_4xT-Nga9yCa_QtbmFQ3tm0LJF0doCsV3pJpO0i+2z4yww@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: wk9zampa6w58jbhdoro9rpbowqgwjshe
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DE0D920009
X-HE-Tag: 1787321918-301830
X-HE-Meta: U2FsdGVkX1+uypnym62Ws5hHO6z6sVgM1JcsubatOhPi8uTkDlDb2VTsaooNpSFAxb7WfoXMu+oQ64vLT9zRt0LN5ytT4R3l0/r894SAUtq8w69SJxOXI0Aifqk35DJ3iReUE2abw47BuFuIaO2qtr7egnbf6xoTpsuyti1chK1uvf06CqgQbONmsz16YRIoxkMl2foVYqQtd/6B8E0DPvBU3eveEwhl/yOv9QU2npel6499hkyPHmAtR/Xbyly7634LOxtJgaSMJlrtoC795Wo5Bqtq1ocV2yddeVCobZiO01WKZSI+sEohMwMf28eg3sFEIcuP9Cne0YjSSLd0aBLh52tYzwJjs5SyhoHY9rsZZtfOdAMsrLdQR/meYruj5fCQaPp3qp/MXsoYak0irbbBP15tnS7riqGhMI+qWDPgCRIh+kbrxjLoMF69hmleNWjxdsaKP1nyHJlry6Zminr+GvolR4qpIOmRF2HjPxG+A35CQgy15WmBY+e5cIk5o40A3w0OUmratdS6GxczOY/8/+71V0gJ2nhekvV336u7SJbU5cfZJPRhknyNoCXsSFn8V3mWPdfKZyyzEwGt/8etRmQvUFkeh9Q4MWCwgtrYH08z77o1JG65KZ6K42iC2ECEXWzt+dvMXqQ4Nk5rcSTmmSraaLxbZmccHs/pb9SHOoJGiE5ws46PAWzOM8LJbVTxL0jiCN1C9qwkE/iZ8aMRrnCZg13ULTvccCXKun2e9A1YyYVv2Js1CPOF+2m2Fbvb/Atr2e+0Srj8tsyKpFBMCo4nCM6sCpQyjAWnnknYmQdU5a3ZVyBNnugTDX5+7nuHBz+9/g1xXwYqCHIgSbinIwFBGfNfcx32ojl6FMiSyCcmaZwsyAxcyLd9hZI74DN8bidwR8kKtw9ZT2wy9owalServDMRpuzk3pwPuqA0+0qLcjVosJs1rNhaFHrWOkpf0eGefN6eHMT+Y6W
 oNIoT5zQ
 nw5SzPnHEl5eSxbnO51c4IOludj0NTO3prV7fV20Qf5wivASh4MjmKQ2nTZzeJH36GxpRpQJ7TxTjZ+ADMm1ELQtmadCZoQleT9pj/ZXGMufUE1Z3itikFk9i1eujpewedHEpJRD+HcQwwXzwue0egoOLeogLE6lO1h+1jioj58W7kGqmCDnTJcud5O6pQgOKAvhq2jnfhNtb/zMHGoPEbb/pL+DVbiGQoppmKjXfjyLdMGgOCHrG/nj2xEKJ1Dh8oRb22Ovkcnk+5m0j560KB6vI7xdUeW8im65FRbuzwUPEpD1gwgwL7rOAPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/20/26 22:18, Barry Song wrote:
> On Fri, Aug 21, 2026 at 2:23 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 8/19/26 00:59, Barry Song (Xiaomi) wrote:
>>> This patchset enables the per-CPU LRU cache for large folios with fewer
>>> than `FOLIO_BATCH_SIZE` (31) pages. It also limits each per-CPU LRU cache
>>> to at most `FOLIO_BATCH_SIZE` pages to avoid negatively affecting
>>> accounting and memory reclamation pressure.
>>>
>>> This is particularly beneficial on systems that use relatively small
>>> large folios. For larger folios, the benefit is likely to be smaller
>>> because far fewer folios are expected to contend for the LRU cache.
>>
>> As raised, there is this problem with collect_longterm_unpinnable_folios()
>>
>> (see
>> https://lore.kernel.org/r/20260806-lru_cache_drain_for_folio-v1-1-c6287d295e99@kernel.org
>> )
>>
>> whereby we don't know how many refs we actually hold. Certainly not 1.
>>
>> We might have to wait for Hugh's cleanup to handle that cleanly (and avoid all
>> the other LRU cache draining).
> 
> Hi David,
> Thanks for raising this.
> Yes, I saw your comment and took a closer look at it. I think the
> best approach for now is to leave that part untouched until Hugh's
> patch lands? 

I think we should not consider your patch set until Hugh either resolved it or
we have a better way to handle draining. Building on top of this for large
folios now just gets painful.

> We might end up doing some extra draining in that case,
> but that's safe—any value greater than 1 might not be. 

We'll unconditionally drain all LRU caches, which is precisely *not* what we
want to do in the first place. :)

-- 
Cheers,

David


