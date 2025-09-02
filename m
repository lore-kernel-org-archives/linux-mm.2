Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 048DDCA1007
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 20:09:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63AE08E000D; Tue,  2 Sep 2025 16:09:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EBAE8E0001; Tue,  2 Sep 2025 16:09:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 501868E000D; Tue,  2 Sep 2025 16:09:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3FB358E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 16:09:57 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E29401603AA
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 20:09:56 +0000 (UTC)
X-FDA: 83845401192.18.348AAC8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 91B0920011
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 20:09:54 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MywhPdyD;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756843794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yItT2cQsaw/fbz2dDlIsrigUmbNJq/0D5dgv554K35s=;
	b=gOtfpawvnf8PezBDfT6XZS0Fsjz5+H5X1BQUderM9TGBJvros5v1Hcd53ArEDalSGycoSl
	km/naKNzob5ve+od4uItmwSCiTpFuis+XTWAgTa/babq6zEvbnEaflxXBUlVZOtW7NwwZN
	Uix4yWWDIZUacpPCGqgofuCEE3dB5j8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MywhPdyD;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756843794; a=rsa-sha256;
	cv=none;
	b=GyoC9U5MOPUNMS4BjjKA2Nt+Tpqk/bS/QPg6BV1o1/J4aXTdLkACj/1lBdU+JC1ZIVfn44
	4VUyRtNlUcGJB11Xxff21Tu0RGdvMx2gSVBKJ7yAN0g7iomahXjAhZwAAcLl498wkxJAqz
	/9695EGwVrscJWklRylnDUm4zJncuV8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756843794;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=yItT2cQsaw/fbz2dDlIsrigUmbNJq/0D5dgv554K35s=;
	b=MywhPdyDL3rnSQ0QJVMGY4L3KLEHtK85kKFdt1lF2A7MOp9RKQf5J4dJrXNWxSOLWA5IA4
	6MXSl+CERCQOq+GXiMK+qcv5xOtxosaQqfZX1WkStizGq8OTaDJZFQGutEMIk1Smd6+fTe
	mk/sMLb6mmhZBHAnBXIQDxxV3+oR/Cs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-490-WhKNSmXlPTiId6GCNEnsqA-1; Tue, 02 Sep 2025 16:09:52 -0400
X-MC-Unique: WhKNSmXlPTiId6GCNEnsqA-1
X-Mimecast-MFC-AGG-ID: WhKNSmXlPTiId6GCNEnsqA_1756843791
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45b986a7b8aso7912895e9.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 13:09:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756843791; x=1757448591;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yItT2cQsaw/fbz2dDlIsrigUmbNJq/0D5dgv554K35s=;
        b=r33yshQqfvbZlRq1sHz6a8gvhXzqmf9OjVssr6Xbs4lddsMjGvI658z0JgxEkWE+t/
         s8203mCUPnHurri+qSG5rxl8hLDDnXRRZ2sP1OzMt0GajgSiAAF+RgSfDgXmmIhtKeEF
         rHSudgAzMQO1wYx+zA1dHNsL0st2BjyRxDztMRwnKI+LrxYwYLb1TpRnhAiKjeM4lqOH
         OU9Iy2syqU/u0llRg7qUP7/kZH7DBGGHWK/HlSN3Sl9YCg+SqCqXy8rK/VkJpMjLEonc
         jQVKUh+TrqLVclhZUUjIzTDS0BxgQNZ4vVyo4TXDI0e6P4ax/wDNu1DsngdZBG6BNXS2
         vHkQ==
X-Forwarded-Encrypted: i=1; AJvYcCWJyA1IYMAxtwpG7krTsUwmw+CNfC9BiO8+8RcFKYxB3HJYXzbTh08fibTjHa3XxiQdbGxcj66j+Q==@kvack.org
X-Gm-Message-State: AOJu0YzgvGrIF7htv4Upg9m/P4KqWGa+ocKiGzDp8SxKCUK1V46dEWDH
	FCP6qVcb7jZavReHJ89mmZcqGY6eOJLlVv6oGQkPo4lbl+MlPQanIU8eCd7C03HevgMfBNCAoTg
	te9l3ks5YacqqsvcypvXuP0+TZwj4lpRRfVAarrJQIkbBpB+5bROAfK7ihvyo
X-Gm-Gg: ASbGnct5elzRcTGg++i6O1Q1cucuRXUtJzW+tZ33LO/eRj+fBVeybCvU5LcZNApIPf2
	iC5vBggqh21NbSWRFBnOKPw1/stYHOlc5VyyyOoq5Uldqs3W9hgDbTc6ln9ofN9gdi6uiGRUIkm
	0wH66+/LeZHPZWG6p8K2AVMoEk2XTsCvyyBx3A9mB30SrGhWLO2+D8vlfyIzLyR82T2u6Pkg2RF
	+RtYFjyLvzjUGjBU1pSSWBk7aCF1LZG83hnQav50DGZ3BP5ABTPvAEd2uKfkTzu2BiB1HXjx96z
	JH4Y3kUI7HNyExN7Mf0qP+VAQQW5w/zJCozwzE/QFH/UIGNzOf02Ka0x3r8q9iGTaTh8UW1qBaT
	gAH5whwzrF94TWUiVg6WDgcnj81GNPHJ/xhtkeYgh4xAjemGcRq8XbZZPtTzenDht2GM=
X-Received: by 2002:a05:600c:4e44:b0:459:dde3:1a27 with SMTP id 5b1f17b1804b1-45b855fc86amr96674765e9.26.1756843790743;
        Tue, 02 Sep 2025 13:09:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEAuTNanc/C1ZsT8U/zhQaFlozDe8jYnd2Fmk4HfNnyAQ2NgrSUMJoHJdGO9Rf2IEfrEQMPbw==
X-Received: by 2002:a05:600c:4e44:b0:459:dde3:1a27 with SMTP id 5b1f17b1804b1-45b855fc86amr96674585e9.26.1756843790317;
        Tue, 02 Sep 2025 13:09:50 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:3f00:731a:f5e5:774e:d40c? (p200300d82f1f3f00731af5e5774ed40c.dip0.t-ipconnect.de. [2003:d8:2f1f:3f00:731a:f5e5:774e:d40c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b66f2041fsm173854155e9.5.2025.09.02.13.09.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 13:09:49 -0700 (PDT)
Message-ID: <bfd5161e-c76e-4a0e-bc1a-bf7510868827@redhat.com>
Date: Tue, 2 Sep 2025 22:09:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Where to put page->memdesc initially
To: Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org
Cc: Jason Gunthorpe <jgg@nvidia.com>
References: <aLc_nckaDc2ePRv7@casper.infradead.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aLc_nckaDc2ePRv7@casper.infradead.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6OUm-1grwnLXkZdDchYooUxhS5ie3O5vGRLSTY8s02w_1756843791
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 91B0920011
X-Stat-Signature: 8pe5p4b3h5us15w7qt7zw3u71u1qe3su
X-Rspam-User: 
X-HE-Tag: 1756843794-387763
X-HE-Meta: U2FsdGVkX19/5hTbG4T/CSkiLBS/jtFMc6GFw/s52GWzI2/el+hyqnDopFjcSoPjEB/o411KMd9Inn23zDEQJeW8I2vayQ9klLlmGZGbDwSnlG3fsnr/EVYIqqlDGADuEZ4v9W6byawck4sarSEjap/G/Wm9zvZYHCdaBHaGVJMbpkjY3hX1jo7afWPTjRE5w/rpWfpn8KzAHqztSqbDWlX6/BhddvhsjxuF/ZiJvU0l+gt/K1GxPK/kz8kK+KpAnFTC1C8IksOzuTWkOQqpkKWMbNZlBY4IDDuABHi70OKaNlW87tVOVfDRL/g2j6aIe//HwK8od7hYXHdULuloB1q36CI6qpadarVzoJqGkAGW5vqK/jbKvrwvqccL3sVE4O2rGEa6Y5qIaOnNfHdKU+nrnEONynioahkJqiNjkwBIH+Xwiya5c4Yv2yNSMdb8GMl/feIgug2jlQl49kzkC1x6D4r3pN9r4UH0wfN8rBzGjAUiMZgeCwxOftnl4NbgWOrT+ad0CwuT/26imL765gGxtWJwu/EV+QCMXtx1N1gF324EWbUbDotE5NzhXNy3bvcKc1+0EzrjN4CKe0sK9i0JjgeUwdzPeUXEnrzpJBpH0FBP3GWtKEMcbwri9hps1WqIP8TjOs4H8TMQx3NVqtv6ECafj1aeG0e35ABW/UDv7PxkAj9zNxbFLTl9NwwvKOJWlgWUuRwcKWi7LJx4GSl5mtOS9xJQBEZ303yXs1hitLr1c5etnzA4b0YUyYRdhQH5XW0qKGf28xGEyxo0SVVs9eWUHbNVpdF+w6joc61jMSg8WVK3dG9dTwqIYdnXsccHA6rB2EKcsNteyLuD1/vYrsMg8g6MfYbI2/sGb56erPpCnT2S42KH4RuQtzNLtTb7KDLK9F5h5UFSVhsedtBc/67Y022VYtg0clO1YxD7ZW6jHAhNU3DQ86dXXSL/eTTZau1ZUElQNjzjje6
 XOVyJObr
 WWtsfyh1VT6/DPHDUXTPnp4NSpY3sm+PLAClIJ3589dQVwvf+zbRzACDHvfs4vYZ4TV3I3yxci7onjyidAsr+0Dzrs5Oqd/gq2REpRgZmvRqz3lffbQurH6U0+Hd4baI5XIMrspjwZ1TQSFzMkZwlrrGz8qD9KUvWSOXLZwFbWeyvDuxZBW8OtMNtNilgJRawBQSAS+vfGlRtjwoDqTHYXjMExzMgyCzDw+09LaEn/ozkmAEiu77SxarO0JvIR+u7YMzCZJ5hhE9uyik+u2AQR74ZLB9rmvYHjrSanox+s1egtdRuynfPqR+EMr/LiTpkzlFxNZUW/spk2kM4U0WtslE4tkqmvAvBWVwI8qXo8IInwvYeMTKEttsOtI53sOCtSZJhH+6DskBUrAipILN3SUxxrTLsbg3WO/4+9C/EByiV6qrmc0OnPGr5ljHFA8s5gxmRPwykG5YqfdF+stvcS/rIErgiDcIK9dJFC2/yklHQl4UDCWkzHw1r3IgEGeLn9jTBzUYc32WD5wg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02.09.25 21:03, Matthew Wilcox wrote:
> With the recent patches to slab, I'm just about ready to allocate struct
> slab separately from struct page.  This will not be an immediate win,
> of course.  Indeed, it will likely be a slowdown (overhead of a second
> allocation per slab).  So there's no urgency to do this until we're
> ready to shrink struct page, when we can at least point to that win
> as justification.
> 
> Still, we should understand how we're going to get to Page2025 [1] one
> step at a time.  I had been thinking about coopting compound_head to point
> to struct slab.  But looking at the places which call folio_test_slab()
> [an oxymoron in the New York Interpretation], it becomes apparent that
> we need to keep compound_head() and page_folio() working for all pages
> for a while.
> 
> As a reminder, compound_head() will _eventually_ return NULL for
> slabs & folios.  It will only be defined to work for page allocations.
> Likewise page_folio() will return NULL for any pages not part of a folio
> and page_slab() will return NULL for any pages not part of a slab.
> 
> My best offer right now is to use page->lru.prev.  At least one of the
> bottom two bits will be set to indicate that it's a memdesc (we're only
> going to use thirteen of the memdesc types initially).
> 

Just so I understand it correctly:

Would you want to move the page type already from the mapcount into the
memdesc? That sounds challenging, because for any typed folios we would
not be allowed to reuse a field we want to use for the memdesc. IIRC<
hugetlb pretty much uses all of it.

The easy way out for now would be making this page type specific: Only
selected typed pages will store the memdesc (here: slab pointer) e.g.,
in the old page->mapping place.

So PageSlab() still checks the existing page type, put page_slab() would
simply lookup the pointer in the old page->mapping place.


> There are a few overlapping uses of these bits in struct page, so if we do
> nothing we may get confused.  We can deal with mlock_count and order (for
> pcp_llist).  But the biggest problem is the first tail page of a folio.
> Depending on word size and endianness, there are four different atomic_t
> fields that overlap with page->lru.prev.  That can't be solved by using
> a different field in struct page; the first tail page is jam-packed.
> 
> So, page_slab() will first load page->memdesc (the same bits as
> page->lru.prev), check the bottom four bits match the slab memdesc, and
> also check page->page_type matches PGTY_slab.  I don't like this a lot,
> because it's two loads rather than one atomic load, but it should only
> be present for one commit.

As a first step, I would really not use the bottom four bits. Why
perform two type checks initially?

-- 
Cheers

David / dhildenb


