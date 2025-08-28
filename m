Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7237BCA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 10:27:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B87DF8E001A; Thu, 28 Aug 2025 06:27:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B38148E0001; Thu, 28 Aug 2025 06:27:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A26E78E001A; Thu, 28 Aug 2025 06:27:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8DFFD8E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 06:27:12 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4BCE385112
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 10:27:12 +0000 (UTC)
X-FDA: 83825788704.19.8411579
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 10ADE1A0006
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 10:27:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UPnguX3h;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756376830; a=rsa-sha256;
	cv=none;
	b=aHNi4isHjYSMHnz3fTeMbINK27lVniZnmJh7kVvnxTwE9GuanYX2w56IipHnVzc/7pv7vO
	xDDU7sEJwBN9V6OBQs1qxSZURF8WfBjHHoL9DaBBk+yxIuimxrtuc3fZyxfhCM8zZTLsqk
	15onSDsS/BvZFdk1F+bPlJ8z7thL3dg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UPnguX3h;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756376830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+boQAII1rVe8mjF/ARYqXtwP6OIEQU1CeV61LbixoDI=;
	b=ihmGSaTjj8Rxllvbf0hpfQv413hw7FYlLhrlr9/2wh/22PrdSLCKE8kKUagiFXIR/HIG4L
	RXgywevVKZgOfVjVtSqw7KVojX7MGMd9vtd7+VT3n0Vj64XYOLPZ16m+mQj9IuRdfPlOIi
	HTOsNYzjbLdreFlGmk41Rb8A6mUtFaA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756376829;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+boQAII1rVe8mjF/ARYqXtwP6OIEQU1CeV61LbixoDI=;
	b=UPnguX3hB+fk9knLQ7iwTvDuE6fyxQQILTzvlMLnmgOo3WmCa6yhZC7PYxhg/fxozhiXOQ
	JgWl6EdWrEu5Yy6E7EnK5G4oQOu4Jcdem/TivJsFPH3J7oRq1Xo4IXNdm3umGre3h2KZFO
	eG8GrAlp7Sx6niF714/JA78qzTbQRVw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-628-G8TKvEcjOLeT1d9lgjB61g-1; Thu, 28 Aug 2025 06:27:07 -0400
X-MC-Unique: G8TKvEcjOLeT1d9lgjB61g-1
X-Mimecast-MFC-AGG-ID: G8TKvEcjOLeT1d9lgjB61g_1756376826
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45b612dbc28so5380565e9.0
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 03:27:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756376826; x=1756981626;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+boQAII1rVe8mjF/ARYqXtwP6OIEQU1CeV61LbixoDI=;
        b=Mp4cm1DAm3llH3PWQaQ2o/44H0AQJx0+aBHLR7ae2iV3Y5UKKnOc5ZPhNq/eQEq0RX
         +hyGBzEgLLd6HB/u8cwgN++1VNRtAO40gsfMBt1pbc7ERbxXdnyfk06Yc5v3EsR1FK+g
         nCRwMYaFCMXtpSku17qjLy6/EWwQO4AgjugbIRN09+3exxQnYoV9P6ON1UrVEhGlXWK4
         wLEuBZw/S+nyqsCALMVjG5ayvASxICz3LQ5mAV8HM5tnoO6sSQoXi0IrfF43nQKCZoyQ
         1oiPGSMpb6OlbAoEPGwaFXebUbnxbB098mse+50kRKxas+qEVYZd4LXyKtUr/h7e8TNb
         6cgw==
X-Forwarded-Encrypted: i=1; AJvYcCWG57PJUJ3FumYr99xF2giivs3VOA3NI67gyMQuLSVH3LnagXnAMSROD7So8kgr7YTeyQANz+XEbw==@kvack.org
X-Gm-Message-State: AOJu0YyMIXRnuZoxce+jhbWL6auxX0/ZGPKqprCOEEBFx0jH3SImL560
	Hfo1hpWPeWA9KTBOcsFfb1zQloQ8TbdBymmAqQgF5l0/1X6/7XXsBipXFmRcbgMswWQ4stZOP6s
	l+H6U5X24b5rnD+HRZz2eeJszRTQoG6241ydG1XJHjxMkokUAhgxY
X-Gm-Gg: ASbGncvREQ226l2bX0Yy1eDvGvc139GH9RLBKvseI8+j8oVFva9DTjYEVyGWM0551Y6
	0i+K+q0A8MeesX/ZcZ70FuU+H2mMoIZwR9zR8YtJVPjBYY86eJ9GIYNWyfDzQsnQs9uhwYGuj64
	zI69LOC9dDT45cLGe6R4go6BEeqjoWTeWkpy6H/FnC3VoBoKuZ5bhoxxIQMA+s16eXFOLvZ6Z4B
	MsM8xxGRnGlm1buy6nNFr3yNE9zh1POdWfl+ci0TTk8PrAdPeg6Ayx1GfWVzBYugaZHSKvoeHzd
	uOqjLOT3hJhqIcmRsb+4lPgozVZcmWEwTDK8BneqF23bN4094DAo3xmuqgri4fM97op1ufnw1X3
	oNQcXDFfG1Ob+SciN6WEKeYnLSc15nMGoV8Zj7britJdjFQSxshbgd6G1Xf5gNA/C4tc=
X-Received: by 2002:a05:600c:154f:b0:458:6733:fb43 with SMTP id 5b1f17b1804b1-45b517c552dmr175226205e9.19.1756376826331;
        Thu, 28 Aug 2025 03:27:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGPPKlRhmhqihhHf2b6I8uk2qPvwY6WU+Zs5Jt8nlR70umt1Km4fvCsG1mTvTrW6wkpR7QnGQ==
X-Received: by 2002:a05:600c:154f:b0:458:6733:fb43 with SMTP id 5b1f17b1804b1-45b517c552dmr175225815e9.19.1756376825801;
        Thu, 28 Aug 2025 03:27:05 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:c100:2225:10aa:f247:7b85? (p200300d82f28c100222510aaf2477b85.dip0.t-ipconnect.de. [2003:d8:2f28:c100:2225:10aa:f247:7b85])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b79799c4fsm25881455e9.3.2025.08.28.03.27.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Aug 2025 03:27:05 -0700 (PDT)
Message-ID: <786503d6-e58d-412a-a17b-f5e4e481c3fe@redhat.com>
Date: Thu, 28 Aug 2025 12:27:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 05/12] KVM: Documentation: describe
 GUEST_MEMFD_FLAG_NO_DIRECT_MAP
To: "Roy, Patrick" <roypat@amazon.co.uk>,
 "seanjc@google.com" <seanjc@google.com>
Cc: "tabba@google.com" <tabba@google.com>,
 "ackerleytng@google.com" <ackerleytng@google.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, "rppt@kernel.org"
 <rppt@kernel.org>, "will@kernel.org" <will@kernel.org>,
 "vbabka@suse.cz" <vbabka@suse.cz>, "Cali, Marco" <xmarcalx@amazon.co.uk>,
 "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 "Thomson, Jack" <jackabt@amazon.co.uk>, "Manwaring, Derek"
 <derekmn@amazon.com>
References: <20250828093902.2719-1-roypat@amazon.co.uk>
 <20250828093902.2719-6-roypat@amazon.co.uk>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250828093902.2719-6-roypat@amazon.co.uk>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kERy79lP6l1aYnNJcSXh65P0Su7vvGx7BKqzcX5xYNA_1756376826
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 10ADE1A0006
X-Stat-Signature: 3bqci96tgahmyyy4omppnm9eu8dmmenm
X-Rspam-User: 
X-HE-Tag: 1756376829-81710
X-HE-Meta: U2FsdGVkX1+JxxKwXl3STD40arfdp7n9FvTZqBfSVeV1yIc+ogwVHEEXPAq2cwV9aMzuYscjZPJBN+dS9/V3mLwFIB6Inl4cli9tCI8/Bk7sNCwZuZ20Sk5LEAIIDET5wQDCTvMHa7ZvKewWqBN44/Cxp3+9xmLxXepV0W2GQC79dcjQ/jV0BTcS31L7Ccd73HzXGKDOlD6ycOTlQPp9qMICsmlHMfbyTFjWB1N92Tf1fP+09RCDDOmaoHdACJRPfnUOSh2lKw/SKbgm8VKJ+4zfFCu9/sBU1fjhXG2b4TeLBui72ujzQKddKCcJ5twFyhzLB3HbJQDA2TUYT/4wH79VIAC2WfdlhOOLa8NpTsAIqXVyv5s8a/nbLgKE7rsfymqF3g6IsIN+QgtZTE6iekUgxrI5nI9gS+rEu9WLzY2KZTs6MvEVFFONsyGj74gXzwLDKzsuJl11cjMC6V1trq7jeSVG87e1BYkq7NHBDHegFJw7NibdU+RKzihnYVhr30bPC2b1tHvNFLZQQBZdkt2e4yoHP9VNHFQrUZv1OPtuy+/0kYN01TDuRLT3nA/NfdkZcV/loVqObK1VI3qbaAjUNNQxA9KogqZvQN8CTGqiCpAhPJblfHjD5POfljnpFWjPsAszLniC9dodS4NEs0MBtbnqs+SpmHI2ifKFt5akEPHRwEYafet17scj3qhvE1rFYWayiTAMuXj/ScpUoskuUQSC9N5kTWtrqvUCH+AlfZARF4zb8iAb9njdRH6dqLpPaRJrgXqMjSr5d31cmBBReDvUEDC3tX8mHJvGKsHxmulat31KLy5h9M0pFF0TXGJf6W8jaStuv+hDHdA+GF1NeS/H9DX6DxZ1IR8i3T2q6uO/UVw3PQVfbINu1LJ1M/q1Aj3bv6ZjKHhDTjOhGZDx7HfFpsSH/1qo+vVRDWyrD+p5VN3u3hTPDKYlwd7KHOCeH3+GQf27DUDAg7g
 SDRUEA4y
 m3eU8e/2HaQTWawv2xb5HxtGAjpGXEFlk5Xv/H6ZUGW27LFtz3q+WkyjVZVPe7LajgpfKGfNzb05EATc1jdITsfYRG530rye9yAD2N8wGuiFXerJs3jgjcicL5TxLwdTpIAJvQIwEMuXW3NIprI5eVfYbja86m35HkwsaoFibm+btqWijb+Qd3/u+72v/p9U2mj4PukOnlGejcb66dMqU3Vuw/viRy2rOjoJq6Er/rNgXAS7va1Tp7d11u6JC+emxIh9uq5jkJjabKLM7j9CblyLrW/bt/440/qcrFt62nHAjjWcgcifFAsFyXOsMWya8cvpzH55FoalJ3f2sdS/pPClM1HxAHmQKfliJSXbd4fKVs/KpBllBd/MQ97eSr0ftlePM+ASD99VLNnw193Drnep4g0pcbdqzrtO4q1UsCq9Nyko/J2Riw7qNjUHijMNfBj3WQ8aYYO+0NzbHy6sYYeio4Iot7UCo26Sw5fkoeDK7IkMD9jrwkU8hRpc6iXBgdzu/XWPdAKYkm4ZTXjQNtEg6af7eEoyqYoUC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.08.25 11:39, Roy, Patrick wrote:
> Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
> ---
>   Documentation/virt/kvm/api.rst | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index c17a87a0a5ac..b52c14d58798 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6418,6 +6418,11 @@ When the capability KVM_CAP_GUEST_MEMFD_MMAP is supported, the 'flags' field
>   supports GUEST_MEMFD_FLAG_MMAP.  Setting this flag on guest_memfd creation
>   enables mmap() and faulting of guest_memfd memory to host userspace.
>   
> +When the capability KVM_CAP_GMEM_NO_DIRECT_MAP is supported, the 'flags' field
> +supports GUEST_MEMFG_FLAG_NO_DIRECT_MAP. Setting this flag makes the guest_memfd
> +instance behave similarly to memfd_secret, and unmaps the memory backing it from
> +the kernel's address space after allocation.
> +
>   When the KVM MMU performs a PFN lookup to service a guest fault and the backing
>   guest_memfd has the GUEST_MEMFD_FLAG_MMAP set, then the fault will always be
>   consumed from guest_memfd, regardless of whether it is a shared or a private

WARNING: Missing commit description - Add an appropriate one
WARNING: From:/Signed-off-by: email name mismatch: 'From: "Roy, Patrick" 
<roypat@amazon.co.uk>' != 'Signed-off-by: Patrick Roy <roypat@amazon.co.uk>'

-- 
Cheers

David / dhildenb


