Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39CC5C87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 09:52:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBEE88E002D; Mon, 11 Aug 2025 05:52:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C96968E000A; Mon, 11 Aug 2025 05:52:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BACD58E002D; Mon, 11 Aug 2025 05:52:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ABCA88E000A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 05:52:21 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 21BA2160798
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:52:21 +0000 (UTC)
X-FDA: 83764011282.19.7CEA806
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 196BEC0005
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:52:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TAforr8z;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754905938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YXhxGhlzJsMH44DSBwLZywxa+L4HWbx5c6OEzPGb9fI=;
	b=R2FflSvxaV1lgLmuoyCsEQvi3JRg8QcfQtYykok4kGizRHQiiggTxCNGOEE1FTFI7bYyz4
	8B1Ut2clEoIxNeYpS5pa2mPMN9P5z2uCDFVjVYMjUKY4TD0vQDSV7KNgT+YWXGnZkd2Wyp
	JaoL/ifkZ1XpddjDSZYpaWn3cVEzReM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754905938; a=rsa-sha256;
	cv=none;
	b=3YNG9JH4nIpBrIcOWE5QmGsAlrvNUe7FVRV49FpBeRDvAYb6SYzOYBgp21rD51F1kWBvU/
	7DdAVbsSTzGG2CN8dUqQK4BLOrpEJHBlZKFVOXdc4Z+j/D5zZZ1IccGy/8Bns8Ig4/oXXb
	dy8lmyxBmhKsX9xBfZPeW6lrldhL+kU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TAforr8z;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754905937;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YXhxGhlzJsMH44DSBwLZywxa+L4HWbx5c6OEzPGb9fI=;
	b=TAforr8zDtAzvRSj7w401taho2c9ryUTcV2yOabFFZRu96/mBAu6E9tqV50S5P1HxFFeU6
	trSRynsVtNnsQ2WxGkwjBFIMqePChfRY9ifDnK+mj9UmtzHJmBuMGZwCDJ+FUMLtdWqMBL
	3D+6nG2RaFSk9SPBETgOpxv6T6GI2/0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-222-9YNTax2fOjqh8ae9V0B-Mg-1; Mon, 11 Aug 2025 05:52:15 -0400
X-MC-Unique: 9YNTax2fOjqh8ae9V0B-Mg-1
X-Mimecast-MFC-AGG-ID: 9YNTax2fOjqh8ae9V0B-Mg_1754905933
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-459d7da3647so35576585e9.0
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 02:52:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754905933; x=1755510733;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YXhxGhlzJsMH44DSBwLZywxa+L4HWbx5c6OEzPGb9fI=;
        b=xUVxdB9+I0KsK/NnsuWv8A+PMRX7t3J4CJZAN6NrvDzFRagPn5wm3fFJWuCTLjOkJj
         YOlaiT+DZBBZqeItYsfuddkLayp5jU7PjP1CH9vNlcJqIhUa44KmeiM/doWSOBqA2tX5
         eCGr3h+85zbFPGVuCAuAWmx7WkQVgzasA3D1JcaYouCCWzH5Ygb02cWKXF1TohGT6qez
         xFwNiJBGnjRrM2hi1KwnjVwxERfGTtbcBQ7SJLQjxEv0hRzKUfAq31Pbc7KaglmUXVti
         KMdp6csPPAFbvAJRFOYxSEK8kj5uSWXz8xDtBau+inG5EF3EQBn0VhIAem4qqlO0qrFn
         shjQ==
X-Forwarded-Encrypted: i=1; AJvYcCXi24a8/4LfBxi7Au7LNf77QsWZEzlamCHojvhqse4MknRjJUTDEnn/O7MmeJfd+1iVyH+xC76LsQ==@kvack.org
X-Gm-Message-State: AOJu0YzX6YTfXz7iGibWv1h+nX5/DLyJn1Stf+odqsFpZ1c3uTpYUR4G
	YUXj+S2w3lB57OQRYVwJmCf3UH8E6ozR0/VAnZxqUOHGeoU1IcbgzW1vzXDHcEGJJKQLHODy48W
	hEveGsf3Q9WUDbdPh2fUcwhxPe0vIxNjhCE+4xliiiCpFLUkptkue
X-Gm-Gg: ASbGncsJe0PkntexwOzxNj5EN5Pnah0T9W34CEpZ5MkizOZAdbAo6FwS5KTn3NFzvEE
	40O52SPskdw/5wUK2lqq4AXQGVe3sq0lsQgvuP9xuEzAu92ozUuUoxHjwRQQ3wGGQzM3DauAdU/
	D7M5rmBpn6Yf9TEvauDK84Zj9ThJ3c2RoBWExYnGOeLX/CyTjXR/FTCOxV81lnWFKR+mDHQ/og9
	tb4HbsN44kEP8PVnSzsoHQQcv2DtTMz7J21zlZrUJp8q+BakvV5sRywnLHYqzkE7BdBxh/uiNSg
	XFfvfY2+RED9IZeo/2lHGFHe+RZ0tsfVbbLE/PzQotjDuLKurSE34Bp+t5dtbfSlVYtujVvQEh2
	OCVWEHI2cSzOeGgMg5QNPzYtsu3PyYQgixQU5hq106Mn+8NhheEASCOsbMP+3tpLS89k=
X-Received: by 2002:a05:600c:a06:b0:459:4441:1c07 with SMTP id 5b1f17b1804b1-459f4f9b5c6mr84913675e9.20.1754905933439;
        Mon, 11 Aug 2025 02:52:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGdmdGHNNshi3yohcSrFEtt4H3QesbQ89l/f0p1bYBymKlSnx3ncfbPaKz1LYKXIyvDOoZ7FQ==
X-Received: by 2002:a05:600c:a06:b0:459:4441:1c07 with SMTP id 5b1f17b1804b1-459f4f9b5c6mr84913375e9.20.1754905932957;
        Mon, 11 Aug 2025 02:52:12 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f06:a600:a397:de1d:2f8b:b66f? (p200300d82f06a600a397de1d2f8bb66f.dip0.t-ipconnect.de. [2003:d8:2f06:a600:a397:de1d:2f8b:b66f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e6214640sm256183205e9.1.2025.08.11.02.52.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 02:52:12 -0700 (PDT)
Message-ID: <112b4bcd-230a-4482-ae2e-67fa22b3596f@redhat.com>
Date: Mon, 11 Aug 2025 11:52:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/5] add persistent huge zero folio support
From: David Hildenbrand <david@redhat.com>
To: Kiryl Shutsemau <kirill@shutemov.name>,
 "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
Cc: Suren Baghdasaryan <surenb@google.com>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Vlastimil Babka
 <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, Mike Rapoport <rppt@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, Michal Hocko <mhocko@suse.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Nico Pache <npache@redhat.com>,
 Dev Jain <dev.jain@arm.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, willy@infradead.org,
 Ritesh Harjani <ritesh.list@gmail.com>, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
 mcgrof@kernel.org, gost.dev@samsung.com, hch@lst.de,
 Pankaj Raghav <p.raghav@samsung.com>
References: <20250811084113.647267-1-kernel@pankajraghav.com>
 <hzk7e52sfhfqvo5bh7btthtyyo2tf4rwe24jxtp3fqd62vxo7k@cylwrbxqj47b>
 <dfb01243-7251-444c-8ac6-d76666742aa9@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <dfb01243-7251-444c-8ac6-d76666742aa9@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tk1fuU23hau4pdnPnqXy3ILdNha1tMa7MJWQr94KWo4_1754905933
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 196BEC0005
X-Stat-Signature: ttjoe8ud6ft8qg6by3psjmi6fzuhr9k3
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754905937-930733
X-HE-Meta: U2FsdGVkX18XuxFlM21So2Te92eDJVlNhWhBvBFaKZwg8DkynSQ5uszm3UUrIzcoW2P4SjIo1LMYI1os0etJDDBixzTVEnWCmrcUQAITgLGj0Fuu1YsZHYi8xaG+YSYMzkUlJdNC+v3wC6BW7U1cZ4KOgehJXH7p3gQ3sn2xiI3XsmtZfrMEC+mpo0C7Ul4md7tNtNFVL6CxTUdPW6EcLiNNI15nCiDL1fpXL+4umbLSJslKRgIfkfdkQlO7fJbCMsyv1nHVpotmXDcHvIZUjTJscnLESdeaHdNek4fYmcmyNMFDY7Wehk3/gkHr9AHOtH/5HYff/m167GM4Y5SbLAOe5OOUIZhT6BF+XaYdSm4hBoUW6WSD8U7oFc4Lg+PHvZxl3Fvln2w5n0jvmkOtZyWv7zqZ8RJUlqnuOypENJPx71IZX+krQy4ui1aiwy6W4mKFgsgrUGewKMuk49eO2kRPFeNtaOx6+UcFtYVyriVNh074nuj2CuIju7ALVCCnsUqmgZC8kwD1N9f/6XItKR7Zl8I1Emkzpvn0SOZPOOljqx2biq/3P79YIjJlHSwKWrhG1c6nuDkY8FKMP2BRr0YVuf7HIlEH8g5oNedpESiroDv0a2a4bl74VaUzKkxcSVhbAo1hS2KfpUWVsPToS3qxgMC2pOcEYzImN0Z+bJ/ncC31JBO/RfwvlIx1ZObmCjVHAAWtpwxL2nO51mKi2hsuEKAqEdUjlr63deJWubhIzSXqr+1wsonxYmsK+SJ/qjtNrd2TGMPCMC7apXb9tfa2tmnoz/iz2Kcy7djBEb5Ms8T6Zsr75yG4zKbvKzzcWnG74AMezaN+H8ID13w8w5L6enlq7yznQqvFiOFQoh67J5qb6QdottsP9m9XAKJUuCXLcfE6GXnMtynO4JK2j/Cr73b8NYUjnK7ImdKEuum3ZuQjN7wec++OmmSwzQp3C6ERYiXWRi8ZVYCdqD3
 RvQepKZE
 KDmfg+8EmnVQqRLT41vs0488wUAQSMwMrmoIVWZotfKGMVuKg99K+WKvnQ9Us986a7hIBMk8Yuhjhrl9gSOzR+nkF8c6x+dKH/gM3KB7qkfmMFWibPZdHsgoIOQCkF3kRghVS9pZIJn9lxHnzATL2jaOAT1GQlRVPC0eKw8Wh0/mEsTj23WX8IVfpmASKtI978xnHw4ncpuZuD+7ROkNB1YR+fiqg0v1b+a4yiM0ZbxlE9gArY+MIXm8ne0eF6bZjHPm3MRXO9gFo2MKPrQhSeCeOrLkKfSp/VdUjohGBXFb5JbmjBMHK1iYm275EU9mdKCMbnPyuvCVQbtE8bkrC4wWedhbU9UHQ7uteweuBmneZ8QcNTTApNrTFrzUBp/Cg8TnEpOPvNJt2ueMzq32GLU5eDlvLOiz7twEAo6+X5bJsdL1aarEBHGu0KUyf0VwW79dakEbgjQXzaB7S2qc2Hu4b96CxNa8ETrymrdjoFkPFJJnTbNNaaBrdMljvlkBl4mUzsPE5qzK2Dx0OHUXsLD3YbbGOpj4CXUa9OfuFgR9svlbKiHSTWDrHXg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11.08.25 11:49, David Hildenbrand wrote:
> On 11.08.25 11:43, Kiryl Shutsemau wrote:
>> On Mon, Aug 11, 2025 at 10:41:08AM +0200, Pankaj Raghav (Samsung) wrote:
>>> From: Pankaj Raghav <p.raghav@samsung.com>
>>>
>>> Many places in the kernel need to zero out larger chunks, but the
>>> maximum segment we can zero out at a time by ZERO_PAGE is limited by
>>> PAGE_SIZE.
>>>
>>> This concern was raised during the review of adding Large Block Size support
>>> to XFS[2][3].
>>>
>>> This is especially annoying in block devices and filesystems where
>>> multiple ZERO_PAGEs are attached to the bio in different bvecs. With multipage
>>> bvec support in block layer, it is much more efficient to send out
>>> larger zero pages as a part of single bvec.
>>>
>>> Some examples of places in the kernel where this could be useful:
>>> - blkdev_issue_zero_pages()
>>> - iomap_dio_zero()
>>> - vmalloc.c:zero_iter()
>>> - rxperf_process_call()
>>> - fscrypt_zeroout_range_inline_crypt()
>>> - bch2_checksum_update()
>>> ...
>>>
>>> Usually huge_zero_folio is allocated on demand, and it will be
>>> deallocated by the shrinker if there are no users of it left. At the moment,
>>> huge_zero_folio infrastructure refcount is tied to the process lifetime
>>> that created it. This might not work for bio layer as the completions
>>> can be async and the process that created the huge_zero_folio might no
>>> longer be alive. And, one of the main point that came during discussion
>>> is to have something bigger than zero page as a drop-in replacement.
>>>
>>> Add a config option PERSISTENT_HUGE_ZERO_FOLIO that will always allocate
>>> the huge_zero_folio, and disable the shrinker so that huge_zero_folio is
>>> never freed.
>>> This makes using the huge_zero_folio without having to pass any mm struct and does
>>> not tie the lifetime of the zero folio to anything, making it a drop-in
>>> replacement for ZERO_PAGE.
>>>
>>> I have converted blkdev_issue_zero_pages() as an example as a part of
>>> this series. I also noticed close to 4% performance improvement just by
>>> replacing ZERO_PAGE with persistent huge_zero_folio.
>>>
>>> I will send patches to individual subsystems using the huge_zero_folio
>>> once this gets upstreamed.
>>>
>>> Looking forward to some feedback.
>>
>> Why does it need to be compile-time? Maybe whoever needs huge zero page
>> would just call get_huge_zero_page()/folio() on initialization to get it
>> pinned?
> 
> That's what v2 did, and this way here is cleaner.

Sorry, RFC v2 I think. It got a bit confusing with series names/versions.

-- 
Cheers,

David / dhildenb


