Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B63FCA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 08:05:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D01A98E0003; Mon,  1 Sep 2025 04:05:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB2748E0002; Mon,  1 Sep 2025 04:05:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B52E78E0003; Mon,  1 Sep 2025 04:05:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 99C008E0002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 04:05:57 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 531C0BB010
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:05:57 +0000 (UTC)
X-FDA: 83839947954.19.875AD1A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id F28F5A000E
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:05:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=B4wg+NKo;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756713955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m6Q0PjFvhv0lbIlS6wSpELNOmrbahmb2W78rqQSaNd8=;
	b=XZrARsbFG+zYe9qmOe2vcpKGMnbTRCgrgz5qfEU1fKmshH4DUhQVzB9M2lC+rAFGIL/8fz
	RC++27EL/UOr/v5ZVdW9XOkj8HKQvg1Pwj7lcoAVcnUQKM87I4b3cUMHSw9/JYM+L7gRtQ
	bLc4TevtY+zHGkYHDduRhNH4V6df8PA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=B4wg+NKo;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756713955; a=rsa-sha256;
	cv=none;
	b=btTWwherMhR+UspacrUaJThD9Yl/70laGwmpKqnLfJqGbU/iFwriyUZaUTDTTDUFI5lo3X
	JUcPFmvMDQnQIK2XeVybY7Ah9qVymjRPMfmiJbTXtuxXa9xvcZS11FhhRcja+/5EyZvmAM
	4z/f+nIi9jFgkPy78AAB2c1f57sVi+w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756713954;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=m6Q0PjFvhv0lbIlS6wSpELNOmrbahmb2W78rqQSaNd8=;
	b=B4wg+NKoekLaXgaUL6Pz/HDSkwA1uJAPjUS0Dz65qlqTrtgLKUumL8TULbo8ZnCtqfADAh
	heHs6wK0Naoe26BLhNj0BSq7aJPWwegQlh1q6b5yz85B2U5JD/iHj025iHzR2yMXgHBDLc
	r6smeF/WomIg/q+iUZG9a7HTlcgg74w=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-43-tuzGIhVwOGOMg50_u_L9Ig-1; Mon, 01 Sep 2025 04:05:52 -0400
X-MC-Unique: tuzGIhVwOGOMg50_u_L9Ig-1
X-Mimecast-MFC-AGG-ID: tuzGIhVwOGOMg50_u_L9Ig_1756713952
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45b8c9dab79so4143925e9.2
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 01:05:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756713952; x=1757318752;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m6Q0PjFvhv0lbIlS6wSpELNOmrbahmb2W78rqQSaNd8=;
        b=hyeLA//Cv+IWLKEhHVnqjrqPueUTrwGPLXbSdIVefetdmZhy5SkT3KQroRAZHHhqN/
         ldbck4t/3Fii2RG+atOT8wvOr6OAMb2eAA9E+WbpuoYpOHdlwQ4lVaiVCjLZ1HpwwpkX
         poBVKKuV7SoBDiY4xNRvSew5q4DjO+ON4t942o5V0ej2vkO+dDxdxzBgbbFgzt8Li6ww
         V3mKU5IWvOWcHRAobRfIXklBbOIUtFZMkiXaQgIrzsA+HaowbNg61eZijbkZG8yjb3Do
         z8/JFCuaVbdbDOWIN7YNfW8xgqqZrLx4qaclPq2sqtwBusDTW+idTFTa8O9EpmCMavim
         mbrA==
X-Forwarded-Encrypted: i=1; AJvYcCVGm0JTanM+LAvTk1esuKGQnZDwuAL/5eI11QZcWlyuMJnPL15I8aXlWLcZ/mElkkZNGKNtwMcVsw==@kvack.org
X-Gm-Message-State: AOJu0YzPCWaQ3iakYszfvcIdLSUHJtTsBXJG3GzqILIIpIFFfg62Fsb3
	hA4XD92E+Ce7GpS9bthkiyQOlfkafk0XFvzONALc87IzCXWqHbKyzszYV1AfSr7ZNuh69kN+kES
	K4ijtReRf0a2W99Ijlg8ue2jAE9SnIwYAX4L+Z1aG+xKZoELYJTJI
X-Gm-Gg: ASbGncuEJQen8ETbt9x263LgJjynwdx1p/As5G95x2AsxdvmkbsFO0SNCsI5hQcpjVS
	bQFii1skhwa1nBQmQRLSAQsSJq/VnEgM6IXgbsVyTw/Pv3UZ+qyy0Wed+5R/z+Iq+NUcZS3IAUh
	pD0jfLSYOk+UAz88n11AUtcQhavBIZ5IIQALS0uch87PvT7wjGPQRGV4635THaIQBLc39u5YxdW
	ZPVPpnoHruNt2elk+0SBxK1vpallDuNVYPyF+k8gs6aeq2ZIM7Fq7WFVR1Pnwz0dLICbKoriGUc
	qTBfnngtU8l1TueB/mPlIH3nG018j2jCuhLfA5j5VKHQgiZnZ5EgI7KNV3nFJCGdzbwzWihbJPM
	b6t2O+OxqZsKYXQAoKo/QUn7HgYVaI/zeF4nF72Nmyxo+WJsK2w6bSretjGSHmBDsNGQ=
X-Received: by 2002:a05:6000:23c4:b0:3cd:14be:6937 with SMTP id ffacd0b85a97d-3d1dfa19a58mr3646981f8f.36.1756713951670;
        Mon, 01 Sep 2025 01:05:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFcHfPInp2BDxJOllzL02W3FmjrmeT2s65+VAuK62AhF4Rnxj7e61tootb2p5GHc9847at8ng==
X-Received: by 2002:a05:6000:23c4:b0:3cd:14be:6937 with SMTP id ffacd0b85a97d-3d1dfa19a58mr3646946f8f.36.1756713951224;
        Mon, 01 Sep 2025 01:05:51 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e8ab093sm150508665e9.22.2025.09.01.01.05.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 01:05:50 -0700 (PDT)
Message-ID: <e3922760-b074-4d5a-bf4a-9d7cf7f5f914@redhat.com>
Date: Mon, 1 Sep 2025 10:05:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/7] mm/gup: local lru_add_drain() to avoid
 lru_add_drain_all()
To: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Will Deacon <will@kernel.org>, Shivank Garg <shivankg@amd.com>,
 Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@infradead.org>,
 Keir Fraser <keirf@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Frederick Mayle <fmayle@google.com>,
 Peter Xu <peterx@redhat.com>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
 Alexander Krabler <Alexander.Krabler@kuka.com>, Ge Yang
 <yangge1116@126.com>, Li Zhe <lizhe.67@bytedance.com>,
 Chris Li <chrisl@kernel.org>, Yu Zhao <yuzhao@google.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Konstantin Khlebnikov <koct9i@gmail.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <a28b44f7-cdb4-8b81-4982-758ae774fbf7@google.com>
 <165ccfdb-16b5-ac11-0d66-2984293590c8@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <165ccfdb-16b5-ac11-0d66-2984293590c8@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: nS04l-FhbILlTgyJ2yulG_9_C8XGU81EtWhn5SjOF28_1756713952
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F28F5A000E
X-Stat-Signature: em53piz91bhymzgqw6pe9jmmxd6qazo4
X-Rspam-User: 
X-HE-Tag: 1756713954-167724
X-HE-Meta: U2FsdGVkX18Bwsk+NbPhgc3o4nLH0ToCmmunI6kz5UOHGIbvPAzY0m2KF4z9CaElYGnc2G7IRhA5g2t4EfiuyCV9G5/vfXLOKDF98D7fQ8zs+0rTbeVWLG4H6I3py4+HcNPGyc2vXOpqFc/zh3oeFmxy1ViB6ELta4SbDomFwzAHG8T6klXa2vom/sjaz87MFE1TxigP/479O1nBs0v917L9UGbbbA9ekVZa1wtUUMFtLtKJOxRgUxq9ke9pNLPUoW26TBdRQ28H15Wuv3FYqznb96aEJB+20zy03HdNdyR5pbzz505erJhkrBeN6CuwtCJk3s8dUShtZ96LgyTX5Y+R8EqBEBOvXKGccddWJCfCnLY7BmxtyZ7ciyPRdwgH8zskVGuaAeufBs9efrE+ce2yM+6TInu8wgeiK2MpodgxR/FfBIOxhdj05k8ItIzpyAyPUwRrxXU+OgM0/JbMvJktD728LtYmHuuduQp8Jm9A/eWjKoUxccKWha/62zbzgoWwnjrzjhQ91KzxxX8MFZmHBrCmluaKW3FoYkDA9GzAZmdG8yhFou1HRApOLstn6xE9q7yPept8pMYGXKxRwvvONMWQXE4w+wmA4YoRZ1zmrNTaybvLs+SAU0NvivlVzvsUEDaef8xAaNLLSe6F8vocwd8X3VMJW/KfbxI/ZNsTyEMqzfcgcqz15CCCNd+lyDWjYPeFsFGCch04tLhsjwIkZN90Q2Wq8ydOH+/mzPcSXF04f33g4tFvRIxt4TMD4j8eKhDdArdZPzAg6jCgI3FX1PY9xM1u93Vz1MdDHhXbGfOmUIG/crDrzdtTUkgZLXsveP+TBFLCHylwZe96iweLHMeEUcthkVbGEOSHAxOSfD0RqpKdlgteCW8T0BoVj++6jLTeU48mF2qaat/5QKl4pOim0onh72Zxdjq4VbMl+beVsj3uOblow3cBAPVeg/GnwbOjmfJMq+/b84h
 4lLNS1kq
 eqJ1mwpB23K2F0EMbcFKXK068RKrEJp3TgmY+nYhFvwqp5nQXKCQMju5ao7KDmcRx9GS4NZ/m/ygUSqR1v2uEhCOKgbdRcVTF8XZ/TgHmbaJEKhqH8Q2R/1fUX0kjVnymdb3VrwgwNaPSbBZWMOhTTjza7sXAvDdWqX6KkO0l9WXLx34m7PZBPs0QCIMBIxFTTtx3gOB2ukZuCWTZdsMWh0N3VGeSJuaqaLSL5QDAS/v5yVzMcerFd8HSN+P/FwrPikbexHRzL+5vy4TFJeVAp0q/FB0JSlCtWd0sJBB1aMUydpWmitYDYCjRecy2pvVJsneaGIA/3wDQ2Xl/W1J08WL0o+m6Maj6t6GIDgpfLYGcSukk9bbRqW3ZFdH9+sHswpkz5AcjqXClvGIJhwnltoTEgsqX+7brY5Pljfz8E6bjkUgV+JiL4D7NtQj3Q96nbc00lJUEr0JdIRhMtuBRjDv8VkGBXhnBW7ZTDdsknJ+aSWfxhFmQMT6O9ce8RwAKzMDwSZKA5ayoAmwq0T5cy3w9bE5Guj98HiS65eefllHg7VxIHsU4PpNpb09gw5uqdqyf5Uma+0qmhiaGfb8T3cO1Kv/N/nGXcc1Kj0y5IXJQCV+elqVHuk05dbzkHMiLwyh/p2ml10SdEgVgeFe+Dg+iYoIiSZnfeYacwQpJCByB9JFmmZi+ruGwEgryxC2s8XWs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 31.08.25 11:08, Hugh Dickins wrote:
> In many cases, if collect_longterm_unpinnable_folios() does need to
> drain the LRU cache to release a reference, the cache in question is
> on this same CPU, and much more efficiently drained by a preliminary
> local lru_add_drain(), than the later cross-CPU lru_add_drain_all().
> 
> Marked for stable, to counter the increase in lru_add_drain_all()s
> from "mm/gup: check ref_count instead of lru before migration".
> Note for clean backports: can take 6.16 commit a03db236aebf ("gup:
> optimize longterm pin_user_pages() for large folio") first.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Cc: <stable@vger.kernel.org>
> ---
>   mm/gup.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index 82aec6443c0a..9f7c87f504a9 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -2291,6 +2291,8 @@ static unsigned long collect_longterm_unpinnable_folios(
>   	struct folio *folio;
>   	long i = 0;
>   
> +	lru_add_drain();
> +
>   	for (folio = pofs_get_folio(pofs, i); folio;
>   	     folio = pofs_next_folio(folio, pofs, &i)) {
>   

Do we really want to drain all the time we enter 
collect_longterm_unpinnable_folios(), or only if we detect an actual 
problem? (unexpected reference?)

-- 
Cheers

David / dhildenb


