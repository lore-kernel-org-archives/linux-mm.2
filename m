Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E4B1CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 09:42:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 559988E0010; Mon, 20 Oct 2025 05:42:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 531598E0002; Mon, 20 Oct 2025 05:42:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 420078E0010; Mon, 20 Oct 2025 05:42:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 322288E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 05:42:37 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C922288A22
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:42:36 +0000 (UTC)
X-FDA: 84018002712.30.1A656EE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3D176100003
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:42:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cO4RffEc;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760953354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jOBQ4PbHnqHIUCLaqEIn37FTR5dtbF8Dc9Z+ni8VzRM=;
	b=dzQBSKBiTAteGFthTD33c0OqmB4IYJiHoR7xdJNXqVOwF2VF3AevTAiYCRswEEabB+fhdh
	JtKE6oPI3zLybO0oEj9mV7j4GSzBIJgTswGu1bWmPoXt6kLOfhK68Bd08hH1o+wsiMZTFT
	u6YhjVvseoY40h0c0MnJ4MnMMGiSlSA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cO4RffEc;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760953354; a=rsa-sha256;
	cv=none;
	b=klPrD8ra3oF3lzld+RYQHzjECtngw8UBO9k0nwGFfRgAxz/f77cBhEhn3eHmJ73lGLQg7p
	Mvs5s+wEdh+X2NCHJ9GQV2jxFcH/1k1xdrdun3aPMBceXkW5JzvONKkPwh9id2jM7VU+Oh
	1gli5P51opl56ExCnAJO/Z8O0IihOw4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760953353;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jOBQ4PbHnqHIUCLaqEIn37FTR5dtbF8Dc9Z+ni8VzRM=;
	b=cO4RffEc6KiysO1ZMnWXUZyQwwEEzXf5y0jgZTg18bJX7uu7Lrf6BxXL6XbHdB3L6L1GdT
	hXaBF5crh7ewYjHI9rzga5cpKvbpMt/IeJvGN128LJeu8k/9VGK8AKYo7f4VHSgUmm4gg8
	ij/GwDN0/9M7+VnqwbvKLYYqu3GM+m4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-264-jDaNZPh5NEunLi8xcrbnyQ-1; Mon, 20 Oct 2025 05:42:32 -0400
X-MC-Unique: jDaNZPh5NEunLi8xcrbnyQ-1
X-Mimecast-MFC-AGG-ID: jDaNZPh5NEunLi8xcrbnyQ_1760953351
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-40cfb98eddbso2540539f8f.0
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 02:42:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760953351; x=1761558151;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jOBQ4PbHnqHIUCLaqEIn37FTR5dtbF8Dc9Z+ni8VzRM=;
        b=ucctYj+3RxMpPBOCHhmCF1y308JB5bGV0IsCI5eSjYsgqT3fIkkHqvQVBuqnl2EuoG
         RKGBLVkOdpFnAOkBwba5icsgiy+Rjaq7tEYdXOAQiLI1U8KEMiQotAR4asm+jh6dmPzk
         Xr7FxsW5229fAGZvgzqvTz4OW4+r1slKr8AKMLKW6E9i/r6Iadp/x9trrAwPJu7tTLFk
         Ad2f3kmZkTWvo2EQuom83RC3YR/EoNehc3XIKNJ67qB/nzcmTJWJA9UfoXnkqHCFbIZY
         rFHVY1gd1kHR2uzFygkziGh9BpeTwTVMhNSxUxoC3ttg5ZGQCar/CB+X3W1bMBq4Yg6L
         b+qA==
X-Forwarded-Encrypted: i=1; AJvYcCXuFpefeQ/PGiAkc/7VI2tL4U1CNejIYdQmVTgRn8kEP/tewCrSZtysSrK5eFPGPwSOT4fXDZzVug==@kvack.org
X-Gm-Message-State: AOJu0Yx+h0+YOaxkOfP3Me6S4twlYPrs7VLdtpLhugraEl0I5M14KWM2
	PLNgLlAs41ftjgeAfVilrAAYUu7j7ypwUlGunR4YXBTPzXVOOXSQZv7GQzo/jP81Jl31GVB4Ho/
	k2uc8R5FPX8wRRLxWyQ9Y6S01+YVyBvA/TL7iA5h4tU871cfmFSfk
X-Gm-Gg: ASbGncvSG13wi36vhaS/x4Dc0Vd4DaeIai6EcOX7k0vKtdY3jIemNmWVmkzh525ANdO
	Tp01vxaR6GQFnlB4sa4p3UlpflzAn3rBhSwhnVt7focYFcQ5KORPGuxqj0H9Oba9p3HHcjViWEL
	+aWO7KRygjvfNBtZCnUx0jDdNIagRcgQpsZYahXYdltMYKiBSxEEmUDXVdy/yuA9pSSb+PLiRff
	VpTXj4g3Y20XaBAMYuUq0yZCrHHSumpIamACqMj8Lfpy0Yqa75osNUIQ30vQtd9XgF0g98mp+hv
	9lyTiqeTRoTlLcl+hQgcrUDHYNQIYN8AFEKlTeuqPWVIqF6YB4XvmqzyrlxB2etR/hp7yHppKT1
	VWj/QExXa5tHCA6cXQX44NH9Rnwvmllpj4YqYoGkLwV+fZ97C6CxJyT0Z7Z0xK9iXmS1SONsqRQ
	M/FEPtxvuANRAzGdt1tvczZ9qJyUk=
X-Received: by 2002:a05:6000:2901:b0:3d3:b30:4cf2 with SMTP id ffacd0b85a97d-42704bc0cfcmr8773925f8f.19.1760953350868;
        Mon, 20 Oct 2025 02:42:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEzHP9dNMLiAI90dFnuyKuwg2ijCy6uzjGDm2wugIYXFE5lmk2eMaJ7ZvkD5SNR6GU+S2J79w==
X-Received: by 2002:a05:6000:2901:b0:3d3:b30:4cf2 with SMTP id ffacd0b85a97d-42704bc0cfcmr8773910f8f.19.1760953350399;
        Mon, 20 Oct 2025 02:42:30 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427f009a6c5sm14619574f8f.28.2025.10.20.02.42.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 02:42:29 -0700 (PDT)
Message-ID: <320b8572-bdaf-4aa9-83d7-701d18a9628f@redhat.com>
Date: Mon, 20 Oct 2025 11:42:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] ksm: use range-walk function to jump over holes in
 scan_get_next_rmap_item
To: Andrew Morton <akpm@linux-foundation.org>,
 Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Cc: Xu Xin <xu.xin16@zte.com.cn>, craftfever <craftfever@airmail.cc>,
 Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251016012236.4189-1-pedrodemargomes@gmail.com>
 <20251016140735.d7d4c282f0fbf22954a4b4ee@linux-foundation.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251016140735.d7d4c282f0fbf22954a4b4ee@linux-foundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1kaaky8QdLoj0PmV1TCxEeI9b1Pb_jDduXjaso_MzPw_1760953351
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3D176100003
X-Rspamd-Server: rspam03
X-Stat-Signature: 4db5z3dffkgsjz5gwqdo8sgayin6f514
X-HE-Tag: 1760953354-94605
X-HE-Meta: U2FsdGVkX18duoe9n0/bYucO/08R593lMEhOJyRw55M3KEYHQa70S6PbM0vUzERidP9FncRZVcNrfCy1uQFWKOdU646TOxT1OySDGNUNrq59gbAUXwgAJ4iNqsTM8qVJX14MnjiAvC+D3RqUUqyRWHsmsBb/BDy34IkHOK9J7L/ADJimL7NivHe5NPp+kukGztHINwPF5RzDug8zYrm0ouIJ0XPUbTX0d2oogGZV+R9CN65fLOuerOBcPB1IrREo5Warwsf2lrchekdGgtnCrKMqNtEIf4xa/bghn6tsyq0bjyTgyEN4JSnIgM6UJjSQ2feaAUkbt5PR9VynKoF2gIJqmNtZZr/Dix4OgT013EfmgquRW7mtAR1xuQRcJQXRBypyOIxk/WY7JhDzzUiUWCwnw4y9URLz4JiS4s6fAkU+gub+3lvbJ/OvqR/tbR6vb14gUsaaUHb2YQ2Ta0yMrhJm4rLK1yfCWbsbpkB2NpJdTeMAP8yB+88cc83NdkbWlCdkBV5fADnsJEIVmUHyReP+3lgIu/7q4mUAjAHOF0pXBN4Wh647QK8nsB20zjgIfazk+ojPhzlizoTPCUDYzOd6mnhMigA2FrlyTU+RVc7YktWTJvvg0c1iLwDMVbq5wJfNnQXzO9+osHsPTeXjLLrHprjjuA/Hs+jVxc1Mo9HeVSahov2ewfwnBSDzC+Onk5yccXDgEaZ7hHA4HzmKwxtq0OM57qGsBGvXzVma5dbIEVeaNM6iQuSRq5W2kMuOMo2c2F9mFXlmU9mLwighWywsgyJuXG8hubYdO3KBDUsCQ+LPlLklehAdBgGqITHd3LKhPEjf6amBUnIQAwmxKdQeIMiIBJOK0rvSI9ACiflo7cghFsxtTbY4ezOdd52at+W0iNpJCTtPJcFFDvNSyEmL1Z58uyUg3TwHRa3pz9PIV1f+8JcuzlsQjAKxgBHWiOYRdYtNs73uK29jbvx
 y4WVgUPk
 flv6edz0bkGxtrryKEQA3l+hKieGa+Bq0MYgtSi5nXdChGrDVjwGHJPrJuLok2+/+Os+Jf1t0MNq+vNV6J5aX3nOe6ZFoIbV+irKvzBEQWJQraYQY99KVJUKmqkLWoksrowZOPp2CUb/N5zQebNbzGh3xN8f6aRAbqT+4VzjjDEuVv0pc8Wqc2F5ybqWBWyXR0gJ78xRyg4CGSY2rrnCJJ2XvRuu2FEILiQAxj10RgYc5FXfjZeVQOV4y0q+Yx8PFBqLF5hirZf2H4S8twG2hchAGue1mGyRIJJZZSUuoN++KKs9dzCb2C+1QRFjbjTvV40DgxUv/YFbn1nPzElPfZgG6LkXAQw6j/4aw+Z/VUOi/xWa4/kbIYa/lSsfeJXK+jGIqUiUNBC2+c471hVdN/OdUaf/OOwZGA+mnqMmsEW4k1ImT5RTver9/OTMvS/5XgGrpoh5iaIq58wEFaWd16C6H3l82xowloTO7g+eddRQRE/etkzxH9K9hmjeiNDHFfkbK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16.10.25 23:07, Andrew Morton wrote:
> On Wed, 15 Oct 2025 22:22:36 -0300 Pedro Demarchi Gomes <pedrodemargomes@gmail.com> wrote:
> 
>> Currently, scan_get_next_rmap_item() walks every page address in a VMA
>> to locate mergeable pages. This becomes highly inefficient when scanning
>> large virtual memory areas that contain mostly unmapped regions.
>>
>> This patch replaces the per-address lookup with a range walk using
>> walk_page_range(). The range walker allows KSM to skip over entire
>> unmapped holes in a VMA, avoiding unnecessary lookups.
>> This problem was previously discussed in [1].
>>
>> ...
>>
>> Reported-by: craftfever <craftfever@airmail.cc>
>> Closes: https://lkml.kernel.org/r/020cf8de6e773bb78ba7614ef250129f11a63781@murena.io
>> Suggested-by: David Hildenbrand <david@redhat.com>
>> Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
> 
> Is Fixes: b1d3e9bbccb4 ("mm/ksm: convert scan_get_next_rmap_item() from
> follow_page() to folio_walk") appropriate?

No.

That commit is not the problem.

The problem probably goes back when scan_get_next_rmap_item() was first 
introduced (likely when KSM was added): it simply never was optimized to 
deal with large sparse memory areas.

> 
> The problem which is being addressed seems pretty serious.  What do
> people think about proposing a -stable backport of this fix?

We'll likely have to backport it to each and every stable tree. We could 
think about limiting backports only to kernels that actually allow for 
enabling KSM for a complete process.

So that would make sense to me.

-- 
Cheers

David / dhildenb


