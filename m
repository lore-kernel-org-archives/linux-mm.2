Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D8F3CA1013
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 17:53:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99F0C8E013A; Thu, 18 Sep 2025 13:53:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 977478E00F6; Thu, 18 Sep 2025 13:53:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 865578E013A; Thu, 18 Sep 2025 13:53:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 763E98E00F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:53:55 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 253021A02ED
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 17:53:55 +0000 (UTC)
X-FDA: 83903119230.16.08B5152
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id A7210C000A
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 17:53:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EiADCOUg;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758218032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UOGyHUePXUSTkgL6T5C6Zo0wP3Y1TdpMhWHXKu9OKzo=;
	b=lwPg74Rr1QfkuBSH7PXkFQWVgsVCb9dCPI3G+HLaf1t8BzTWfzg2Sv6zS7WiGfTD1m43Bh
	fYcwChV/h/QB26Scj4MzC5MbzP5Ra1pJHXFjdMcbdJsz2oIFx5POIfJHboj5pHQTWQxzum
	yFR6dzqjjyFfJMGZnlYpqIqHGPQHJMM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EiADCOUg;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758218032; a=rsa-sha256;
	cv=none;
	b=mVB9EdQ2rBeiBi4Np0jXA9M8XL58OrGfaLhapk44GMARy71fA4CkX4iIU0gXhrG3BSGmV7
	yEhDLAUa0X6GxTLqIcsdQHpn1owIEwUGHKfJGQh/lcZ3Sf/KnReNv57BaAkqj7YZ6VDisL
	9I9OU7WSkvobWFgciX/CuhCYfIJ+CDM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758218032;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UOGyHUePXUSTkgL6T5C6Zo0wP3Y1TdpMhWHXKu9OKzo=;
	b=EiADCOUgXNJ6CFDJY437FsfOCm5hwn8sUZ+WSf76U4vXfJLjQIo+oM6iyqs04ZBIPC10KO
	UjXhFdkHbasb8n2WYcqnCHxuvecdASm4vO1jGR8HvnwhqyHeBJ4Ob6yUSOXPVb7Mt895Ab
	Ob9G2tEh+v5n+pBSrfoJ7VP7WWI0AJY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-410-2sgum9_nMYKY5coqCISrgg-1; Thu, 18 Sep 2025 13:53:50 -0400
X-MC-Unique: 2sgum9_nMYKY5coqCISrgg-1
X-Mimecast-MFC-AGG-ID: 2sgum9_nMYKY5coqCISrgg_1758218029
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45f2b9b99f0so7645195e9.1
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:53:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758218029; x=1758822829;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UOGyHUePXUSTkgL6T5C6Zo0wP3Y1TdpMhWHXKu9OKzo=;
        b=W3wZNv5xZ4nStPTdLfDq6e4yf/tR7qesQp1jENop+xAQ/fqY3xMwUeK9Ijmr+bn1YC
         SDjFL4C1jA7fK+4ZYkM2nWdy0hY7Sty78hTzY+XCTuqdXqBauI5aJgRmWNWZ4eXZ1fI5
         6IJwadgAsvjxRDv6QgKSRSIaFBjkg6caKsMXx5CXsdyjOKWdRHuJXIiZCwRhJoeT8JQf
         /WYNVyHEeM+IkYJew/gwnBXXyA6PcrFCnTxe2iRmokuw7a0VHtvUqTVPW6NU0ON3hubr
         68Oz7JuexyHL2sfmO7W0SoF5KW06EbiF32QS3fym3MwEtsPj23AAsLCFgRQPHPAh2oxe
         OkkQ==
X-Forwarded-Encrypted: i=1; AJvYcCVhn21P+iDZrwo4xEXbJKz5eHOep3J49E+QBiTQzIzxwpCFn165ROOyqj3wSeJ8oXy47ohyrQbO1Q==@kvack.org
X-Gm-Message-State: AOJu0Yz5tyP71j7eDVY+Urc9X/uOd9l2NhKrivX3rePocVaImz+GMwY2
	mOwOsHFAVaNcPfFxpXB+dRsccHFk6EoXP9d5+3VUtE6XiF0Xr9UzTwKwHoLLJqHCHFAngqkwxvn
	b4h74LlhD54MKQJTd/pLUCM/AaFGFXFh8cXvxdEU/1PyJ/yyEUUCs
X-Gm-Gg: ASbGnctUS5E0eVgQTrXi20sBWI5ckcQCiU3Q+eWpSFPk45bqLIRDpKfhKAFx76tVFaj
	Nry4m8bRP+d0ZW+fuMVvw4aBVJCtyU56W+j3ovx4yAGLum3RLnu79zFEhPg3F7i9sZe2u0CAc+B
	5cQzLs/u0MAinXF96DYI4CCwbp08HPo64o01mHpVRGLbcPoZvvQt3LIG10N1Ad3WKHuUqBOWFuC
	YQKEvkTBI6eh8O3XGDo1TVTD/H55G+xEZpznFy4jxNB+ehTuo1NrYD2wb+TIHa1V8kPllvRzQGy
	EwkGC3x6TkO0nICsR4TKxmgpoTvswnRQLWUE6hJ1WTZMCg2OpyaPGqRpIR7H0QVHdirxyBsA6Gp
	pdlIw7INXIg6HvXIoWAoI9kcgV3duaqMURF7/qNaR6QMY9yRl2Bzy6VxAR5uuq5Dul6o1
X-Received: by 2002:a05:600c:a415:b0:45b:92a6:63e3 with SMTP id 5b1f17b1804b1-4652c9ee679mr34100195e9.9.1758218029202;
        Thu, 18 Sep 2025 10:53:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFsPNevUVmagPBLbTVnqFKQoRMUe2XIHZTkFltgj83DMjpa85O1tzzT/oNH+xW/ayF49guR1g==
X-Received: by 2002:a05:600c:a415:b0:45b:92a6:63e3 with SMTP id 5b1f17b1804b1-4652c9ee679mr34099935e9.9.1758218028737;
        Thu, 18 Sep 2025 10:53:48 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f07:dd00:ca9c:199e:d2b6:9099? (p200300d82f07dd00ca9c199ed2b69099.dip0.t-ipconnect.de. [2003:d8:2f07:dd00:ca9c:199e:d2b6:9099])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee0fbefd5csm5098723f8f.51.2025.09.18.10.53.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Sep 2025 10:53:48 -0700 (PDT)
Message-ID: <74b92ce3-9e0e-4361-8117-7abda27f2dd4@redhat.com>
Date: Thu, 18 Sep 2025 19:53:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] mm: Introduce vm_uffd_ops API
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Nikita Kalyazin <kalyazin@amazon.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
 Muchun Song <muchun.song@linux.dev>, Hugh Dickins <hughd@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 James Houghton <jthoughton@google.com>, Michal Hocko <mhocko@suse.com>,
 Andrea Arcangeli <aarcange@redhat.com>, Oscar Salvador <osalvador@suse.de>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Ujwal Kundur <ujwal.kundur@gmail.com>
References: <289eede1-d47d-49a2-b9b6-ff8050d84893@redhat.com>
 <aGfsaIIzHWfjcNFd@x1.local>
 <e7vr62s73dftijeveyg6lfgivctijz4qcar3teswjbuv6gog3k@4sbpuj35nbbh>
 <930d8830-3d5d-496d-80d8-b716ea6446bb@amazon.com>
 <jxekhkhbn7uk23oe24svxrs3vfuhseae57sqagndqgh2e7h33o@kfkygmrvjb5n>
 <aMp-kW3OLqtZs8sh@kernel.org>
 <du5pzxmfk6lile3ykpaloylwz4eni6disj2oe25eq6ipzqemiw@ybcouflfnlev>
 <aMvEu9m7fJLnj862@kernel.org>
 <4czztpp7emy7gnigoa7aap2expmlnrpvhugko7q4ycfj2ikuck@v6aq7tzr6yeq>
 <a1a48a0e-62d3-48d0-b9c2-492eb190b99f@amazon.com>
 <7cccbceb-b833-4a21-bdc4-1ff9d1d6c14f@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <7cccbceb-b833-4a21-bdc4-1ff9d1d6c14f@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Vy7ewHeJjxOiJm8VA88HtI-24hMFSftdm17x7a0vdDc_1758218029
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: utyonxb9aiaukoa3fjib5gj8tenhctpf
X-Rspam-User: 
X-Rspamd-Queue-Id: A7210C000A
X-Rspamd-Server: rspam04
X-HE-Tag: 1758218032-461113
X-HE-Meta: U2FsdGVkX18GK96WAtY1FMjjxVEgaBGeN6hjmo6dRCM9wLmJ2UE8AurSkBAmONBSHJmXMz3HQ5W1ZGM5Zi40LUPedepvdFpsXKsaKe5GmdOSqt0bZYb6otgnk9z9g/3I0XSoeCYnaC9XzRJncNK9xFm50jcEY3ih0xl6b+uOJQ9EXm6Pry7RB3Os25EotGfuEPo4XJF8Ocp0IXwJoSa//PGqoUCeH2RwYWnAvSyfOc8MTu4tjzWoDZQaKB/hxem44iQGyNIW2HpPpTI2QmnTriDKU/EklN9ekMQgQOAEduecKPflY4Ns74+N/N74eMzXmvfNM5TemUHtaHDUIXnYGlxGJky3Fjk7kjaVYtcYgTAAEImCNcAqwvwCJJM8dZbC7ZTDZTVu+xRmL+D9Sqne2Zldlr2hzn+5g+Wz+WLJl1xSJNeqPpWW7BDVH8WCYYCW6hoIhpvK/upCCjf5TG2FNHIXRz8lPhsJ4y+mE/ph9whICHArdSITEWyeNDl/AP8+8e6O32aMHGnHWLeQXKYDdpwW+MBK2XRtgk2OdPAJC231g1+orjHM+vztzHlXS3kogyLR+YZ1EOpCJ/biH9iZPSrts8hB2FThl8qdMFY1TDQoR7+qTj8JiW0uBR66Fud1WpoMNCYU+q5tX1Hn+4CzVjlhObrKTTeTR0o126WJ0xfNLUzy4ZBF0DQ3SDN/91Si5d50vP+tqSZPcwfti64wYkm83+JEH6B4Mu6Mm4bC8dHQUS5bynUhfNlwOQC8ktcSUBke/Pj+0jhKL4ACOMR/6UGI++2Rre2RaBSC2uuxpk9L0zSOKC3dr8B3eN6aicPaqLXHIk6ud4BjaDkNRY68X+k6WnP2zzdtC2TFeUWnQ2PZfbLVMsHyus57aCT73Ao1NvDmpdxyKQ3hqHdhOsrP3VnZ+6WTu6bjw5fZ0xlduYf9M2CVRd/Zr/XZFUcEefthCS2bohoa+aAPt8me/ZM
 dtpF7R7e
 cCxre2FNxrP8hVqPasd2SSq9sthPqgcHG09vwva7IhkOcBPpYiXqEdWXsDUm64hSN4MNH5fc8da9a7Hu8o3oqKjF4Wq88i06PQ1VNY10xQ9J6OOxUC/5Sk+vyClfRygPXLIxlQVGqR16Hed3BeN9XODIgmlBF61BSmPyer2ilKkEfFzMIm9d8786+7W0c9Kd8rm3HbAV7ieuVpE/AuOQ6HmELOf3KCnER/dseobIOj/+KS+7lSx5FLbDgFZR1EZsDCZuJhMSt2OGyLa6RJANfjHXicxf3mSh4cDdyOgiGpLzQZJ4Oo6oYGwz63qssB3MKE5d4aRsjpXt/dkDn6K9iSqEhtynLJ5kSo7oO0aFD/B4P/DXZGkUS5/+8DvPXAnOvSQDOr7LQyTrzN48gE6vDpJ2RqEAtbvpF9ylLHt0br+LyF++nKR+gsUHN1DL2tnRphFVNCuNWfIvAJIyH4gJyB1BJ5xe2MTKWK6P1mXcvzHNUsx7Ttb3/wlqPF/gA0QtCBHi15H5EisGmr+Tp85HtERMDxEaAjdH7jSPpvG5gGVIar2cYSWvhNjl/WyAEefMKbq3+wu8qedfcJVK7KLxOXmc4xA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18.09.25 19:45, Lorenzo Stoakes wrote:
> On Thu, Sep 18, 2025 at 06:15:41PM +0100, Nikita Kalyazin wrote:
>> The other patches it I was building on top were mmap support in guest_memfd
>> [4], which is currently merged in kvm/next, and also part of [3].
>>
>> [3] https://git.kernel.org/pub/scm/linux/kernel/git/david/linux.git/tree/virt/kvm/guest_memfd.c?id=911634bac3107b237dcd8fdcb6ac91a22741cbe7#n347
>> [4] https://lore.kernel.org/kvm/20250729225455.670324-1-seanjc@google.com
> 
> Note that the mmap implementation is changing to mmap_prepare. It's the
> case in point example of where we exposed an internal mm object (VMA) and
> experienced significant issues including embargoed critical zero-day
> security reports as a result.
> 
> I took a quick look at [3] and it seems you're using it in a totally normal
> way which is completely fine, however, and it'll be very easily convertible
> to mmap_prepare.

Yes, we'll take care of that once it's (finally :D ) upstream!

Re Nikita: If we could just reuse fault() for userfaultfd purposes, that 
might actually be pretty nice.

-- 
Cheers

David / dhildenb


