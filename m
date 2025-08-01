Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56A9FC87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 16:50:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6AAD6B008C; Fri,  1 Aug 2025 12:50:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A42A56B0093; Fri,  1 Aug 2025 12:50:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 931BB6B0095; Fri,  1 Aug 2025 12:50:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8315F6B008C
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 12:50:27 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 46990B835D
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 16:50:27 +0000 (UTC)
X-FDA: 83728776894.09.BDCA9F9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id CDDC740009
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 16:50:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=J5G5ckkM;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754067024; a=rsa-sha256;
	cv=none;
	b=WrIyEMkQD9YGzz6bZBLg0bPk/9oii12yVzApu6iJH97jqKY7ADYIf/T4mCJ88AxEj3SYC4
	r+uZK3XG/TDYsyjRv98NCl3omnQRz6l14VTP7JLD+SxtRtx1UkdgUvXrm4D45m4AtLuwZo
	p+V3MayOAlv+HE4fxDBxXgx3tJXySZE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=J5G5ckkM;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754067024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SYsDt9m5yC5GNXC3mMT2zgYZ8KAanzc8ZMb75eA5bZA=;
	b=BrGxGSIjp1jcVg1PcZAcUnko7vWrU84s5smafx5rRVL+3lCMvp/zEqHFWfWbARusN1kPgl
	ewnsm3D5dHz8kisUuAydEkqDaOUZdppb73rwM4tLhRAKgga7uo71YYjSU6GPTz/cTfpEPx
	xFFBaQkTkTSNty0foCtze31y3sFaHIg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754067024;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=SYsDt9m5yC5GNXC3mMT2zgYZ8KAanzc8ZMb75eA5bZA=;
	b=J5G5ckkMxIkdLD8S8KtiYTEuq9urFHrRx+GY8HTUxweTJ+TxahQgnhZcV3LXN67s6FdZ20
	S55NIYTp0sUDxi40ff6NxnZ8tGcRevEbmhBnGeHZDQSBWmFtMvnnnhEfmUBb6UMtk6ROwc
	IvDvmWLSl1auMK9jhUTPITJLJaedAa8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-187-91Ug6gd_MvyzDu1jk5QYaQ-1; Fri, 01 Aug 2025 12:50:23 -0400
X-MC-Unique: 91Ug6gd_MvyzDu1jk5QYaQ-1
X-Mimecast-MFC-AGG-ID: 91Ug6gd_MvyzDu1jk5QYaQ_1754067022
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-451ecc3be97so11118475e9.0
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 09:50:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754067022; x=1754671822;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=SYsDt9m5yC5GNXC3mMT2zgYZ8KAanzc8ZMb75eA5bZA=;
        b=TWFPWjXJfmm6JXWzkI85uwmAthIi2yrBpxGSfbOkgLKPxSrmAj9dt7KHcWFT0xGQU8
         UI2p/wt0ZgtEpkYPl6yD3IY6C55efd1su/0GnzhY+k6Ip5BBwhe8OrYeVgp7PfgeX4Pj
         VU2LuSsjaV/E4KIEMorbl5gODaihhysvVOD4Ohkkp8Mmn1foC/xIVFc29PnbtN28HE8b
         XPG1FSEhMfd1qDj4llKXVcnayH4JgGqiAPEysalLOL2ux37gI1u4wyapEPENFJOhdufy
         yIvc6NbtgCNJQ4rleEnLDnr+pzQCBco1WBgoYavChKwwbEvMtGV32lu1yV4pB76OXUa8
         Wq0Q==
X-Forwarded-Encrypted: i=1; AJvYcCWzqgjAQX+GltKuXY1boonmUXbmpioHWUWlSH/63jLArP0THQxOrmZxmaRtJG77XExmTkFUPFXqrA==@kvack.org
X-Gm-Message-State: AOJu0YzD133WezrAa9XaBgPfmB1E+mzozZLBE0iSO4u18qJjQvJsr7bG
	OxrciUFikWEXJLn8A5CkxsmbautPceJnGdYVNrKAab/E6RuZuPLPPbu4fSopf3ZkVsZMKZmPIZn
	5bj3KgX/4hGnY019U+NClXA1t5z7SxF+wyBhv2zzgSqWmSKbUSO72
X-Gm-Gg: ASbGncvWNfgm8Q7KGxN8I0654KEWT952/bEWCF3rQiH53Av8qzF/bvbsNrFdCsv6EFL
	+QjMjE2zDOQNQiyR+Cj2o3wXGJu0GyNRyotUUauNPmOi0y1fJG1PWwBRNbB7wDPnuUZaQ+gJWn0
	v3/A0gQ2mvkdE7/GutpCzvTpeJTqB+N9Iuxha+Qj6Z3G5VsNPkNIhdd4WwOlDXNoJ+DuF33lpZg
	DFdvFbzTNUsxLgjgan39eiKnNXoToIlabYvhJXWSxmDoqWYhBWoy7s3RRsBsUNG9qDWHNXhWESh
	VQvDGwyjePnRUCZm3/ivRSzs1c7FOQX3FOHvNJQsUPr+ugpS7EAXtq5wBg6TCIKXJwokIHVjc0c
	VBwGMuoSmnNx+dGlHcCRdFw5oya6lFzOhdKiw3Pt3Gc6kFBxrTSWnXPLZ/622lfoG
X-Received: by 2002:a05:600c:4703:b0:456:1560:7c5f with SMTP id 5b1f17b1804b1-458b69dd754mr44945e9.14.1754067021744;
        Fri, 01 Aug 2025 09:50:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGUJvJDfGtRlezSck1ccdAzkOu3spyth3+j0p67V1PzuOsPCcnJLkOSxAdJi2jdJrgCyEaJaA==
X-Received: by 2002:a05:600c:4703:b0:456:1560:7c5f with SMTP id 5b1f17b1804b1-458b69dd754mr44755e9.14.1754067021341;
        Fri, 01 Aug 2025 09:50:21 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:7500:5f99:9633:990e:138? (p200300d82f2075005f999633990e0138.dip0.t-ipconnect.de. [2003:d8:2f20:7500:5f99:9633:990e:138])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c467994sm6378420f8f.50.2025.08.01.09.50.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Aug 2025 09:50:20 -0700 (PDT)
Message-ID: <b8009500-8b0b-4bb9-ae5e-6d2135adbfdd@redhat.com>
Date: Fri, 1 Aug 2025 18:50:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] mm/hmm: HMM API to enable P2P DMA for device
 private pages
To: Jason Gunthorpe <jgg@ziepe.ca>, Alistair Popple <apopple@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>, Yonatan Maman <ymaman@nvidia.com>,
 =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, Leon Romanovsky
 <leon@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ben Skeggs <bskeggs@nvidia.com>,
 Michael Guralnik <michaelgur@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>,
 Daisuke Matsuda <dskmtsd@gmail.com>, Shay Drory <shayd@nvidia.com>,
 linux-mm@kvack.org, linux-rdma@vger.kernel.org,
 dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, Gal Shalom <GalShalom@nvidia.com>
References: <20250718115112.3881129-1-ymaman@nvidia.com>
 <20250718115112.3881129-2-ymaman@nvidia.com>
 <aHpXXKTaqp8FUhmq@casper.infradead.org> <20250718144442.GG2206214@ziepe.ca>
 <aH4_QaNtIJMrPqOw@casper.infradead.org>
 <7lvduvov3rvfsgixbkyyinnzz3plpp3szxam46ccgjmh6v5d7q@zoz4k723vs3d>
 <aIBcTpC9Te7YIe4J@ziepe.ca>
 <cn7hcxskr5prkc3jnd4vzzeau5weevzumcspzfayeiwdexkkfe@ovvgraqo7svh>
 <a3f1af02-ef3f-40f8-be79-4c3929a59bb7@redhat.com>
 <i5ya3n7bhhufpczprtp2ndg7bxtykoyjtsfae6dfdqk2rfz6ix@nzwnhqfwh6rq>
 <20250801164058.GD26511@ziepe.ca>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250801164058.GD26511@ziepe.ca>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: cM9eKI5DnWBo98dFqaVDue5rX7oUCmKCpTvKRUJrBAk_1754067022
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CDDC740009
X-Stat-Signature: n6zhu75gmxucrcn66eukhbfdmqj83j1d
X-HE-Tag: 1754067024-164641
X-HE-Meta: U2FsdGVkX19gurwijCOSxoXT4lc0kpzzK/LHzEvts/bCOUgmhB1DSOd8J8bYhZd+NtBBZl3fW+TB17d1PBFkNI96AV5+izkqQ/0vbP2W9hjVqq+aops5tcB0FgW1iN0tuDuj4ACW+zOxc76NBk7V+k8VeLks+sJDsi1Z87zMu3aX5GEwKVwGQALFpn5bRkWXGyyjzVTDhT0n6UTasJgkCNoVUtkqMN+UI/1TqqtQ3VRzKtNWfVExKiJ7K0t/3Sq5Jy7R67Zs3nbvcOMHHOmuUh688zEm9sKRaYBrmhTLbU4mqlK8dLUh9YheyCFTdeIVoqzZLFIQDS9A9ioo5vB1Yap02ynK1sTv8CfpESkR9hXwJmJOYeGJRdJ9N/GY8u80yUV+jTFaG6x4xCtab1r2Sn8fstU6EnSL2cLVsW5iLJSn1Y3VJhFPyohcuKN9tWi6IdMw9zhCzZJXDxjjP0CcUtc9tj7aVc7tZanRQ+wLoX0QF6kTbR+4K3JD7SIK62cXc9kD3LY5Am+EoLJc11da+ph29pfFo5VU+oh8ABYTGISyrdj+vuBdrikZfkp4JuVf3iAvm17dbdqn0uD8/APGOdN+4j7Q5j9ytoYCsvxI3HtTVAEaEf6BdxO/roI0DFaid2WQj43FYWmHKv8UohdtRfFP7cX67zc15l8sFx+1BWfJ/VpqnZ4PPtpNehA1IwaMcJb5tD7N/miKiQ8OtS5YqNibPb0TPbcZ/tJvfixQ0lffwYLGpEG+i57dd8rZGVnJX33KhO+CYBz/TgHM5qQwWBPTbC+lYKV+onvvNFCQdFvcXU5EelS1gxw3p0sCGgql3+0BSaKzndeMqJXoZ/6osporFqQQjOc1U9QmOZpcaE4SVFcVrmULNZDm2UeoMxCYrMqKJcsKaYNX0lodE4XIL16+1ygD/+vfWrERckQTB5bqjAHvYGNvmZ/E+Cp78R4L3Rtz4+pi2VKSY1lnUPy
 nGknVh8T
 kYcv53rU1va8fJG8T59Ike6yDwZ2CKWo2wh4bMiFUm8rN29/eTIo3hd8rJQSfNtwpUIJD9Ys+fM86jfSb4k4XkP0MI/RAzinbNV2Uk364rWJ2agKbkBbiZHCgYlXEgCmsSnSz3V/N4iH4N170TYT4ZO6y15s2irJCy3X0u9A7BLkyxfGunEZ0g4hVGStbX4pCpS/7DOigwdvOB1Sa+Fg4bizdvOkRvYYy6vpwBUyzgQvCoc4ZuBfifmJiok4ioVfdotW+cvGUA2n113fRQ3GOJ55aJEMh5u4Xpa5JfDXh91CubR+1MfrBbDTQDk4WPKLZJPCXWeljSjwHdQoWo9l8p3dnzJR2JsaCNqPDUsf52yGHAPDzOOSMxKcqcevHLO6BrB1RNlpPXN6/SbMkvRCcOeuBIlJPO9CPtA3QX125GeNqoZa6phweSgfPGHl6Sug3Al+S9R5vCliCNYeSuqSpGJWx0Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.08.25 18:40, Jason Gunthorpe wrote:
> On Fri, Jul 25, 2025 at 10:31:25AM +1000, Alistair Popple wrote:
> 
>> The only issue would be if there were generic code paths that somehow have a
>> raw pfn obtained from neither a page-table walk or struct page. My assumption
>> (yet to be proven/tested) is that these paths don't exist.
> 
> hmm does it, it encodes the device private into a pfn and expects the
> caller to do pfn to page.
> 
> This isn't set in stone and could be changed..
> 
> But broadly, you'd want to entirely eliminate the ability to go from
> pfn to device private or from device private to pfn.
> 
> Instead you'd want to work on some (space #, space index) tuple, maybe
> encoded in a pfn_t, but absolutely and typesafely distinct. Each
> driver gets its own 0 based space for device private information, the
> space is effectively the pgmap.
> 
> And if you do this, maybe we don't need struct page (I mean the type!)
> backing device memory at all.... Which would be a very worthwhile
> project.
> 
> Do we ever even use anything in the device private struct page? Do we
> refcount it?

ref-counted and map-counted ...

-- 
Cheers,

David / dhildenb


