Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 161C6C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 08:46:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A12EC6B0098; Wed, 23 Jul 2025 04:46:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EA9C6B0099; Wed, 23 Jul 2025 04:46:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B1996B009A; Wed, 23 Jul 2025 04:46:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 764E66B0098
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 04:46:08 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 26591140627
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 08:46:08 +0000 (UTC)
X-FDA: 83694897216.27.5E7FE65
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id A5157140010
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 08:46:04 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dUorYZaL;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753260364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lwDwoJDkvaWB7LHjbQ9xfhrljLJHNe7i273NTEo5hSg=;
	b=52tvFPAT4SHHug57CmevqyIjrfJTViwLXEUAmRJ6o7gCWhp7dnvIPtYwfGmsEpfmZGGS4+
	Ksx065FhfXhNo+ZL7XS3FErlcQXQv3dgUCWz4h3jzo7sVEYuxoomPLTN8mKWbmnTykluvg
	/1utyaF38OXt/Mmqmgjg5iyJ1re7jvg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753260364; a=rsa-sha256;
	cv=none;
	b=qyKwrcd1VQtotOWT6WKPsK9a+KcFdyLvwliKx2XocQipwXphMy01ZgpvMvBakbCYRRMuuz
	1IpCYK8wwnx8X/1vfo6/hvMWUY6JEf80z3w9qSRaE4sbCHiY3bBpuhKwLt3T8zDKznA2Qa
	qgg/e72RYRqnuZU+OUeRGBQaDsqckhU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dUorYZaL;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753260363;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lwDwoJDkvaWB7LHjbQ9xfhrljLJHNe7i273NTEo5hSg=;
	b=dUorYZaLZggwRjGShboKVeu7uxfEgrIDzm3iU5Im9JmntiecVANQcUypuZ5CqUkKveMZhT
	gv5ExV4rsjulwF2X1gDqsny8/HbYllmqb6T/fUb7ID/SV2mOonKbYQ3Y6KIlsrkIs3w5ir
	fbjSYr1QAqj7Pa/rIfub0VxvepHghOg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-403-CyXQALAbO5mE-ulv5J0bzg-1; Wed, 23 Jul 2025 04:46:01 -0400
X-MC-Unique: CyXQALAbO5mE-ulv5J0bzg-1
X-Mimecast-MFC-AGG-ID: CyXQALAbO5mE-ulv5J0bzg_1753260360
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a4ff581df3so342042f8f.1
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 01:46:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753260360; x=1753865160;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lwDwoJDkvaWB7LHjbQ9xfhrljLJHNe7i273NTEo5hSg=;
        b=tL3bOGAteKUg46JM3CL31x+iABa7WOJcvBBxRK+QXM4tpwNYTvLlB30GqDoxzdKfIk
         Uy7hHSIdCh+9OcAt7Xm3zj6zEivKccD85cOsX27QDBLXue9n2MEBTKhPp7TsfaKjwgpu
         gqwAEr1SkBXZlix0G7KsW+t/1ElttJEB5GYJSe9qso1yqut+dhcqk4kK9DWQbIvTP6S8
         X8xHx9LhjqReuATzvIvoPbQTXchn52g71bvLS64zNDfcuoecR0mAS9wFyxcfl8MPNGiU
         rhpk4f6ZB9dnjenfCs3n7lWEbV+/NCddUz/+y7+K38UZlQDvdBiaDi7FP3Xc7auTUwhA
         di7g==
X-Forwarded-Encrypted: i=1; AJvYcCVsqry01MXofss6R+BQN6XR9MYyMTBLgVgEpFaI0YUZlt2+M1MScA/en8uf0hbYMrjYLNpviz9kMQ==@kvack.org
X-Gm-Message-State: AOJu0YxE5OfQbrxhEAB1UBt1PLigAqiwAr9RwblWSQdRRzJiIfg5s/hN
	lK/MofwGk9cLfQBxeA5Ubpv+Z2UW1hwtdQdZE/qyRVfgVNnHYYfOq3gN2q8iOSNwN6stjXiAb9z
	3Cb6COAXlet509KuyJTQPrDDZTP7kN4Fz+yZ3GtB1OhE5ChO55oHw
X-Gm-Gg: ASbGncvndyOFpb15EIvXliKsqbQ6AYOXKeBxPMkpbjDKLgL/OG1bgLksNIxU2mucH8l
	V2IujTppFftAdFmEbkeQoUuZ93HBgZTdiywxOSkLR2/ytM8OOdBEaS2SFG43aTpa9xkEsOPzeHw
	kVAPak2WgC9nUK8mujXjThJECkwXDMCr4Iz2vRfG+mdL8gurxaH7AoBJiYXRq8FmRHZf+GBC2mV
	2/DVpG1ilia96M2uzB9FJGqFM6he0UNIkRkDBbcKHRStlepKdcK5r7YJ0HMsyqPaX2g6t6XfWyo
	o5alxzCY8vsQf/MEWYUleuZYvm0rgBhOmI+GklL+Ip0SHqaWGgTRV0BrQwMUZYqcQVIHbsQOory
	9OTUIO5sn5gG2tUY5t0Snp1CghQjKawkKZut8CyNJx8BiwmOErNQfmW80e+4sXwXWkkw=
X-Received: by 2002:a5d:5f8a:0:b0:3b6:cdd:a41f with SMTP id ffacd0b85a97d-3b7634856bdmr4370301f8f.4.1753260359797;
        Wed, 23 Jul 2025 01:45:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEUs2CRV37bzZdlRoxR2LvzpvBXfCJ0+7JD5T3DxPlzrfYBfN8LTRYpQ8VI2W2Kjgb1pSmm0w==
X-Received: by 2002:a5d:5f8a:0:b0:3b6:cdd:a41f with SMTP id ffacd0b85a97d-3b7634856bdmr4370260f8f.4.1753260359215;
        Wed, 23 Jul 2025 01:45:59 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f00:4000:a438:1541:1da1:723a? (p200300d82f004000a43815411da1723a.dip0.t-ipconnect.de. [2003:d8:2f00:4000:a438:1541:1da1:723a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458691b2b36sm15638745e9.34.2025.07.23.01.45.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jul 2025 01:45:58 -0700 (PDT)
Message-ID: <e6648680-da88-4f01-9811-00229da858e6@redhat.com>
Date: Wed, 23 Jul 2025 10:45:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 0/4] add static huge zero folio support
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>,
 Suren Baghdasaryan <surenb@google.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Thomas Gleixner <tglx@linutronix.de>, Nico Pache <npache@redhat.com>,
 Dev Jain <dev.jain@arm.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
 "H . Peter Anvin" <hpa@zytor.com>, Vlastimil Babka <vbabka@suse.cz>,
 Zi Yan <ziy@nvidia.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, willy@infradead.org,
 x86@kernel.org, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 "Darrick J . Wong" <djwong@kernel.org>, mcgrof@kernel.org,
 gost.dev@samsung.com, hch@lst.de, Pankaj Raghav <p.raghav@samsung.com>
References: <20250722094215.448132-1-kernel@pankajraghav.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250722094215.448132-1-kernel@pankajraghav.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: AHfwIgWc98-MRNiiR5J9-6ZQuCD5cMZIlZrLwntRXQw_1753260360
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ukiz9u4h5t3nxdf6on3r3khhjfsnsn38
X-Rspamd-Queue-Id: A5157140010
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753260364-981662
X-HE-Meta: U2FsdGVkX1/9oMfJgl7Iyq7SAxkjv7pjRrJFd8XVS7S/O0ZQOMCvRh64vS3LRHl86ePnCLZ3bX/fW+XzZ44aTsI6sJI54NVH1iOFjeIDru/0ocBZGN1uPEgH2DGSciFcgLaEGEeIBvNsmxAndznn5pq4MvspWRncSWOkH9kAQZ7GbjQodPN/N4DfGAI9I+ijxHXINQJ2f8drIdD4xG9jtHI3ikUZ67Ar4iDNFS1pKsY909/kaeQkwoPl49y/+m5suy056GeDVdji+lAtXkT7wK1fr3LfSpqCK88gJoSHZu5tb4Vll/6RieOlrwqImaVspZG0p0XZcw+aMqlgyqQ/XOK4kQzycbW7KVkDZOxTAIaGvXiCGZqVCKYf5ilDlQVCek0TbqnKGZwZhfZEtksPYB5rxBWfiL3jvHT4M6ViOaP34lefevoargZE560Ipi0qm3ByLK6kfoeG8WODvQz6YxIlbpyp3O1AIVguccGHvXhNRW+PEByaDFQI+IuycfCKvCBVzTN8vKwCM/QgKelWjcDcPczHNTGf5yQ/LPswAf/txf32Pwr/ZODUSnK2Gqf8U/qBuUehFlinoXJO9bJFjTrm4a2JQ4SVIsb5BtKGVR5vYimPtNs8BE/TAJKkk728R96shESOgagXfacMuU/nEeC1ndTEB8gLcxhf4Sq1lMCE2KnIX+raU+YR4jmEQnwKjqhCszpAtYpKFIOBuXN6CMLMvCfqdZ6OxuYBL0KP0vaPk2ElE1+2V8Y5ZTrLKL22YpbDBQe/9CY6l2RlZnVFtreZqNv96tITEsir4pP8rwoQE/ejQhD1tKAS3MzoAnXGeYK2AeKgkFguTolNlls3HQJ/g6bcx6e8K5hyH1ZSrv54j8YVETbg+Ue1LUSeTyTq8sI1AWULfgmvqXitSM+YSqp+VuIRskBDes+Y131OetOpdUckDvIifAYI2wgRxri4TOI9INNZmIjoPrk/iPS
 2k7Vfa4E
 5YGflZxkc9Pp+fM7YiOX5ndsuMbhUezP5hLE9NiZ36D+uZH1TFBnIgwuT9aiOWnbEfb0FknBGBm6oGkpH1bzoRdAs7QasCBD0josFGuHA5hD1fMwFHdy8tNXiAgnmj3IaiQD2k7Lx5fGQq/H6RQ0FJ2ki9bOSgPKj1OH+nWxxE9YaU4NQgAGbnSlw/SAADlpEnuuduSc+ycryAyCnEuAIYGUq/HAyg4v8eTBxn7raCDX1H0XXMSchuKs2HM4AoP4EAsdgYQ/LtoML2B6zYsDV+hvsDP0YlfafIYDEgXEgrAmV7kUTxbb15pSfYGWxsSmkoMZTRSGrOpJ/ZZQvCIwvCjIdtFQLk81fppIN+TtWpJlzl1MOktQ2PsLWelJ16rniN+tORuY1nBnW34YlMdFwI7bPrWbcbNvtWXMUOVKQmNwpwmlzdjeCzse22JJslqiG62q6Mx56gxy1Z6wENuuWUZCHomNc7Sy9ylAwaKG5T2cuJfs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.07.25 11:42, Pankaj Raghav (Samsung) wrote:
> From: Pankaj Raghav <p.raghav@samsung.com>
> 
> NOTE: I am resending as an RFC again based on Lorenzo's feedback. The
> old series can be found here [1].
> 
> There are many places in the kernel where we need to zeroout larger
> chunks but the maximum segment we can zeroout at a time by ZERO_PAGE
> is limited by PAGE_SIZE.
> 
> This concern was raised during the review of adding Large Block Size support
> to XFS[2][3].
> 
> This is especially annoying in block devices and filesystems where we
> attach multiple ZERO_PAGEs to the bio in different bvecs. With multipage
> bvec support in block layer, it is much more efficient to send out
> larger zero pages as a part of a single bvec.
> 
> Some examples of places in the kernel where this could be useful:
> - blkdev_issue_zero_pages()
> - iomap_dio_zero()
> - vmalloc.c:zero_iter()
> - rxperf_process_call()
> - fscrypt_zeroout_range_inline_crypt()
> - bch2_checksum_update()
> ...
> 
> Usually huge_zero_folio is allocated on demand, and it will be
> deallocated by the shrinker if there are no users of it left. At the moment,
> huge_zero_folio infrastructure refcount is tied to the process lifetime
> that created it. This might not work for bio layer as the completions
> can be async and the process that created the huge_zero_folio might no
> longer be alive. And, one of the main point that came during discussion
> is to have something bigger than zero page as a drop-in replacement.
> 
> Add a config option STATIC_HUGE_ZERO_FOLIO that will always allocate
> the huge_zero_folio, and it will never drop the reference. This makes
> using the huge_zero_folio without having to pass any mm struct and does
> not tie the lifetime of the zero folio to anything, making it a drop-in
> replacement for ZERO_PAGE.
> 
> I have converted blkdev_issue_zero_pages() as an example as a part of
> this series. I also noticed close to 4% performance improvement just by
> replacing ZERO_PAGE with static huge_zero_folio.
> 
> I will send patches to individual subsystems using the huge_zero_folio
> once this gets upstreamed.
> 
> Looking forward to some feedback.

Please run scripts/checkpatch.pl on your patches.

There are quite some warning for patch #2 and #3, in particular, around 
using spaces vs. tabs.

-- 
Cheers,

David / dhildenb


