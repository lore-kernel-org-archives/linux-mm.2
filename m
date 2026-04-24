Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 787BEFED3F0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 16:50:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A39466B0005; Fri, 24 Apr 2026 12:50:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0FB96B008A; Fri, 24 Apr 2026 12:50:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 926EF6B008C; Fri, 24 Apr 2026 12:50:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7F07C6B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:50:48 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 217C31C01F1
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 16:50:48 +0000 (UTC)
X-FDA: 84694038576.30.5AE74BA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id BABB940009
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 16:50:44 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Obv6SLiw;
	spf=pass (imf04.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777049445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=keHZ0O/SFDCod4eBPIiE4SkvZSALREhE81hMbz0IYMs=;
	b=1bbzGwEnXB38W8KutIQEYNMq3EmjHlD8NPgn0mErl2hbQ80EkMc19+6XJWhRg4g5UIs+7O
	6VPUj57em9PvLAEHxIwSj7KQGrJIWeb3Xc+UxflTi4PPB8BFs+ksOVDnLaYu9e4nxth8/p
	wNw8KB+HtZpaSICNSpAD1dJqr2bLLxI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Obv6SLiw;
	spf=pass (imf04.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777049445; a=rsa-sha256;
	cv=none;
	b=53XGMF2cZEQWQCuX2Q595a3CsfSYtL8zkPU+1y/ZjHmvNxxrVtrOwiQdpDnXXG9Wg+/FZX
	Ag+krqttYhFvmq5XVNwgs1XOagI2NCxax8glLAsBqXHIEQtnnNbvgQa0hIIa03zZM+P0E5
	nNaBqtxcXDGPBzQHikoXHYAXQCvjZTA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777049443;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=keHZ0O/SFDCod4eBPIiE4SkvZSALREhE81hMbz0IYMs=;
	b=Obv6SLiw+onWu+wlskfqZdpv3gR1UoS6bbbbcWcSxjf7e16zAE1eobexyTBvqvUzC4ydvR
	VYukKlET/i4nkGBabzfdHyylP7DsXMIuJIFUhVQ8Sgi0cLdiI8CWbSRRS9+LOvEQXL/Oxr
	X63Vn+E3KL7jyHz5JTtPWrfZfDlKj9w=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-367-iIPinvI8OAi0rhzGQav0_g-1; Fri, 24 Apr 2026 12:50:41 -0400
X-MC-Unique: iIPinvI8OAi0rhzGQav0_g-1
X-Mimecast-MFC-AGG-ID: iIPinvI8OAi0rhzGQav0_g_1777049440
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5a3ff732c58so6788835e87.1
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 09:50:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777049439; x=1777654239;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=keHZ0O/SFDCod4eBPIiE4SkvZSALREhE81hMbz0IYMs=;
        b=pZjPAw/KOdnd5ZCTECXLsKF9Hh8xZ+L5VAw9AhiHg3vlDaBU3XzcsEuIUWMIGqetBh
         7XGhtOGC+9DTUvHscZi8c1pR9PBsP2+Aa9Vk8TrDMsZuN4PmkmsH/AmeITC3Af2OgD1N
         sLd8NjtTsOzSdaH96DfG66SjWTNEfYNmYg8UmFLnOS7M/oKCH85OcOwOOS2r2SkWtnth
         pGVhFGz57gNmB4acPsvKEEBytTtg2ygNqlNHdTfHJD1KZHsafBzPGRWxZfFB8UnBCqQ5
         LEGYsdlN0H1FBfoMbO7eCGGKORY9yUIKysGrXBwbDnvPCnnJJ8kxa9IkO79QaZOmEccg
         jHEQ==
X-Gm-Message-State: AOJu0YxpW8pn2zqjes3TO4Bx1mruTVllDcTt6OZcSynhaKqXIHJUdcJW
	P8WwWl9vl7oZ0PqH69eJ5taHvy/Sy6HLh4N5BP0KAyrfC2Y56AI060y1xMOdXuA+V/O52A2oUoB
	jEnDhAbDZvX+dQJK9Vvlvqk4iOAdu/cPgK5j162eWrn5kmePjwx4=
X-Gm-Gg: AeBDievne0LLIllCfHIjT8nXU+CsqO+xIlBBJCJOX5Fa87s1DKhd6LwLKe/DK2qrnYB
	FK8whAhw8Ez/Ey7N+lIePnmXU0y9ftUoh9TEBszMXA6QjKjEMSK3yXiMGTCEC04hY/Gm5vrBW46
	UW/uWAgCqxloXuxxkM3DIYpG44V4U8dMaJh7HwprwcYLAB+ELZxLIvi2fIJPCtHxErz9XfD01BR
	8ztE6g9As04qlhwQNPaLRp1TOJluyuiCzvmXc5w7+P5gBxDxnB/M8YMllF49naB+F0ppACEQgkX
	hGTVCgln57lDpeCn5mDAmhw8fm2O3pxwgj5CTdCi+/xp24WFlpfH7Sfq+a6j88oXt3No1p/Kg1a
	XiAVE8SupQ6cDawFTePDsbSqBF6Ffcgil3+n3nBPuKKCDz9qfv98q1SsoZA==
X-Received: by 2002:a05:6512:3196:b0:5a4:56:aa88 with SMTP id 2adb3069b0e04-5a4172e7bd3mr12410416e87.27.1777049439436;
        Fri, 24 Apr 2026 09:50:39 -0700 (PDT)
X-Received: by 2002:a05:6512:3196:b0:5a4:56:aa88 with SMTP id 2adb3069b0e04-5a4172e7bd3mr12410391e87.27.1777049438914;
        Fri, 24 Apr 2026 09:50:38 -0700 (PDT)
Received: from [192.168.1.86] (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a4185bc297sm6104200e87.18.2026.04.24.09.50.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Apr 2026 09:50:38 -0700 (PDT)
Message-ID: <3faef07e-5093-4d9f-bb1f-e9a1f2dc6100@redhat.com>
Date: Fri, 24 Apr 2026 19:50:37 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/5] Migrate on fault for device pages
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
 Leon Romanovsky <leonro@nvidia.com>, Alistair Popple <apopple@nvidia.com>,
 Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
References: <20260414041226.1539439-1-mpenttil@redhat.com>
 <20260424092336.7f8f5b0c00f4b46f9e0879d9@linux-foundation.org>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <20260424092336.7f8f5b0c00f4b46f9e0879d9@linux-foundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tRNp2dR4TPOfQA2ho7wlKe2Y8bkP-3QQm1Mv-CKBjqE_1777049440
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cb6i414pu4w1c6y1xou8yyr1tdxyyy5x
X-Rspamd-Queue-Id: BABB940009
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1777049444-361206
X-HE-Meta: U2FsdGVkX1/Jsl58Cds9EFVxX+Xml5zYK4CuSZ6vqSpV/MlQ/oozBscR1HCCNd0aD9hwqmIadeYZ3RiGYBlDIaYhHd7RhpG9FIdoGl+/2QQN81i5Vu+ZA1OCsS2CncOxvGS6F65YM04yO5LAcPdUm2nTwVxwNIW+faSi18uQQIzwlOtUK9HrQqGRI7r6WnKWCl6GgImRwlqc8cpAAgmSFHo4yQVvXCDLwBak6j4vWmEh4f6v66GLtxtOK4bAQsKJOp5Xa6jEQg3uvvUFs15d6YgpQlzJMACMSBEjqgc+ev8j0Pm6X4rj5MCXLS/YBjmXn5OwyMPJf8S0Zo8QQBMlxZgDsUnY8rqxJ1nMQohqqZWwveR9cWNYxLVACfdmHUm9qGd0UG8upNFMino0kMgFPlad5SsYLolGtP9RUN1gbmya8fSIXAkfsPBCgLhxLhTOCe7SUBsA+/w71ucgElG4ygyx8IT5zzF7TVpu1JrKiU4pCHy+3ITNT26fbvj5SBgiRbh5pIXVouk5UQu+5jomPmg1hrZudEEZa5+/ZmVzQtVc8MI1PVyGa10062yTbCE0BQxZfvY0HhbaE0uwwcC9ufgCMFSRitceeXtKdsewRfsWU/JaCU9ZI5jpE8ko9ch4MMCgUWHBFrea+LXMhl1xMirmfdveNHcNkUBcsrD8QT8Xij7t+Kf1l7ThFbXrMrUX1r2uJKD7kWbPD0xjElUD+xoCgUtFPZFv7R830IPoMME0hz5AKDprjF8Hw1fUVmbrw9GEG2++F3t//cg9Y2LW63PBYL0emym8UMx5j74pL6kzAfeVrZBh17XRRxR0N9/G9bzkHgtuWSLDTJHiZQBHHug3MGW5WijjTTzLTL0obpJYVK95MUi4+1XI/7vvSZlWnkeUD/7ib7AsoSQs9thQEqiKQPKL/wOsiERU/utIMl0o/Zy61RX1rQXW0AtI8DPPQ36lm5eI9V54anki+se
 PdvR9dbT
 JXEeoDijQFlnKxRZQiRMpxzKpQ8q4aeE//poha2W21lPa02EKRPRBXNdUaq8d3sPyyeRbKZ3C63RAYVfyNRtyOZHJ6PdfpbA7chkZO6LmTa4Y+cqFnDCSjBbQGNidO1BtwdNHFpqVIwmanubea/Shu4U297xzuBkLNbs+mQtcqJ9Gc2Mg3JoONnaqgylm6mFs0EPbl5IBgCjtyipN2KI732DG8Z0T2OMiLpDp/eNJGWIqLu2MkDFQSGIcDz8ECWpBf1U/A+ulm3lPb0KPd3F0hyFDs/7kbpqbeZoLTpnO5gLb6AbnXBQ3UTuHapXk6ptr2Bgl1jh5JLshvRLfEqr/DlhxwsDzTuaEkiDahz2cmPVHCk/v/khSvWsR08WSolpmZZl41UXl2EfQqDWAW/6euB8b9jZsYHOPdeKe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/24/26 19:23, Andrew Morton wrote:

> On Tue, 14 Apr 2026 07:12:21 +0300 mpenttil@redhat.com wrote:
>
>> From: Mika Penttilä <mpenttil@redhat.com>
>>
>> Currently, the way device page faulting and migration works
>> is not optimal, if you want to do both fault handling and
>> migration at once.
>>
>> Being able to migrate not present pages (or pages mapped with incorrect
>> permissions, eg. COW) to the GPU requires doing either of the
>> following sequences:
>>
>> ...
>>
> Via which tree would it be best to upstream this?
>
>>  include/linux/hmm.h                    |  19 +-
>>  include/linux/migrate.h                |  26 +-
>>  lib/test_hmm.c                         | 101 ++-
>>  lib/test_hmm_uapi.h                    |  19 +-
>>  mm/Kconfig                             |   2 +
>>  mm/hmm.c                               | 821 +++++++++++++++++++++++--
>>  mm/migrate_device.c                    | 589 +++---------------
>>  tools/testing/selftests/mm/hmm-tests.c |  54 ++
>>  8 files changed, 1053 insertions(+), 578 deletions(-)
> Looks like mm.git.
>
> It might be more useful to add it to a DRM tree if there's ongoing
> development against this.  But please no upstreaming without good
> review!
>
> Anyway, this is a bit dated and Sashiko AI review wasn't able to apply
> the patches.  Nor was it able to apply v7 or v6.  So please refresh,
> retest, resend?

It is against Linus tree v7.0, base-commit: 028ef9c96e96197026887c0f092424679298aae8,
but applies and passes hmm selftests on mm trees as is.

I plan to do v9 refresh and maybe minor updates in week or so.

--Mika


