Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78476CAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 15:22:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD5808E0010; Mon,  8 Sep 2025 11:22:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C85D58E0001; Mon,  8 Sep 2025 11:22:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4DB98E0010; Mon,  8 Sep 2025 11:22:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A072B8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:22:33 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 50B5B1A01CC
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:22:33 +0000 (UTC)
X-FDA: 83866449786.12.A030E5B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0603840008
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:22:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=B+VTzXyi;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757344951; a=rsa-sha256;
	cv=none;
	b=AkSjiI9Wq6ooFAIqV9bH5+VV4+3Fyqxd5jbMtMXcF4cvbPLvL844o1ZpWzkp95gRIl4F5Z
	0eh2UlrNYZIBV8r4lR4Kh9cLsdlzcuxKiN8AwoaqB6AetycnKofJX8UUM0QNXWuBWBJyja
	OGmIC0R2QzO73D7Q+tJ/SgHFWmG5Jms=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=B+VTzXyi;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757344951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w4KMjz9pZf6Gn5SDTmwCP/agoyxxfuBiYUtMKRyfuzo=;
	b=fgjeC7/vXWxAumHYyZCvilJdyscpJQSOfHvoOdHXnXPrcNhl562Nl8FlBKf/ES4YVrolRQ
	EFRwOO8Gy6WhJlOdGXme9DKDEyNJ+8lCPdB4epIBEG4FfbAF/+Oj+VUXx2ARGonHcIQ6LX
	uPbhqabYqFnAz7qtTlH3Edt3TCrA6Ck=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757344950;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=w4KMjz9pZf6Gn5SDTmwCP/agoyxxfuBiYUtMKRyfuzo=;
	b=B+VTzXyi7V+Tf2jDC58RlR3q9cOdsYcSpsm8+lGDA39vIDrIxePyKl5JVYeB0cwENOrDa3
	TWmsRe9o1PoQc7+QMnCpTZe12KR36FNRFLil66QnOVpAPjenoY2cgN4qFQ8F+0o9Ww/pcK
	pedG8ZLnNTb+ZaIp34sk7McerhCz308=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-aXlRyesMNX-XftENf9A2Pg-1; Mon, 08 Sep 2025 11:22:29 -0400
X-MC-Unique: aXlRyesMNX-XftENf9A2Pg-1
X-Mimecast-MFC-AGG-ID: aXlRyesMNX-XftENf9A2Pg_1757344948
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45dde353979so12497295e9.3
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 08:22:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757344948; x=1757949748;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w4KMjz9pZf6Gn5SDTmwCP/agoyxxfuBiYUtMKRyfuzo=;
        b=aaSeN/fPjrQgRsIGcQ8WViM+p8AVQN5JFCaZmdzRTccOR/KekqDQYZcw0Kyy1gdTsM
         FZ0tu36ivxs8PDdjBTMlf/G1Zhxrn31iXw4LVgqiPdx0b0E+UoHiZ+Tf9rJ3ZA3leXdo
         EAeCyv2wbp3vOEywZSlLt5TRrimXcWGW2GT0Zx0yNnmCiBrf1EwI+0scnpzhAm7xWhcn
         zzyoUHmTFpS+REKg5OxtFL6xDvqE5h9NA3j0eyG0InKdBVJ+8TIyWfGt+J6CuL2ItKwZ
         99d5dhdC5cvbK+/S3KUTVW3PRpYECL2W9Ym7ET8ZbVhql86Fx1eBUm4q3Q7+P0zb6t+4
         Q6sA==
X-Forwarded-Encrypted: i=1; AJvYcCXSTUoebPsuKb22AuhlS9f44+EW7G75mtjJc7XWQqytCJEw49IQMdDoOb1UfjHxoM0FqfI0GPh0VQ==@kvack.org
X-Gm-Message-State: AOJu0YwHAHqOmyty5pV5125zDLQgqCO9MeOKPxef9lKAvopt7P5WkVGr
	jgsrNmvJ6N6C6Mxg6ggDuYb4EP8T9eCbMq3Ct+qhdpbKHVo5qoMjwx+kJML3nUzy6ooI+PrMrcy
	/dS+V8ZWVd4utLW33DRgbWfO0r6jseklXk4xNB2h0pSKb+GuLe0E/
X-Gm-Gg: ASbGnctj3Z0JhkIMfBzQ+WXcTFUf4ntjX203pcxNWY373hPtYw/wU1vdU+hqOf3hVlz
	08e4CIFNz6ElcZGSaBe6x8I46uZdgrzZKxlLI5W9Gbfkk+th+OaOp0RmzHc2LwfR2hDGRN+4NPY
	5V91crGUwGv1Yg7fI1cnwiHO/ey1jeu4DGaVCbCB1nMdtTEnqbTilTT3DdMcQymaEotX/eUv1Vl
	GGnxw2sldNZ45OLqRQwHmQCGSgI0EQrkBWTT07oNwKO89JWVeXB5pRCunfibR+qKkUq5nChl86N
	eEKCKaAnEdt+GSvbLxQWkNBg+CC/VdXA3UOVGap3G1XJfaulbg6LIR8rBX2Ovvg7HYmArsF5tVO
	UDiCNBL5/uW3Xvr/2k50ZCr3YfnVvSfoVZFqWhfQw/RJo/CX8lxUE7X+924D6lPJp
X-Received: by 2002:a05:600c:34cb:b0:45d:e0cf:41c9 with SMTP id 5b1f17b1804b1-45de0cf447fmr65101035e9.22.1757344947798;
        Mon, 08 Sep 2025 08:22:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGHYVI7uetiSbrjm9XefV08PSiCwYstCNobj3gljiWL9Oji0Bqd7BtZyoiA+b/dW0fMqgLp+w==
X-Received: by 2002:a05:600c:34cb:b0:45d:e0cf:41c9 with SMTP id 5b1f17b1804b1-45de0cf447fmr65100515e9.22.1757344947304;
        Mon, 08 Sep 2025 08:22:27 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:700:d846:15f3:6ca0:8029? (p200300d82f250700d84615f36ca08029.dip0.t-ipconnect.de. [2003:d8:2f25:700:d846:15f3:6ca0:8029])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf276d5e5fsm42252142f8f.27.2025.09.08.08.22.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 08:22:26 -0700 (PDT)
Message-ID: <83d3ef61-abc7-458d-b6ea-20094eeff6cd@redhat.com>
Date: Mon, 8 Sep 2025 17:22:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 19/37] mm/gup: remove record_subpages()
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Marco Elver <elver@google.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
 Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
 Robin Murphy <robin.murphy@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Tejun Heo <tj@kernel.org>, virtualization@lists.linux.dev,
 Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org,
 Zi Yan <ziy@nvidia.com>
References: <20250901150359.867252-1-david@redhat.com>
 <20250901150359.867252-20-david@redhat.com>
 <f5032553-9ec0-494c-8689-0e3a6a73853c@sirena.org.uk>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <f5032553-9ec0-494c-8689-0e3a6a73853c@sirena.org.uk>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GQYQVsY6opG4gmPXga8B21_uLzA7wawP4S3E4UEYq-4_1757344948
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0603840008
X-Stat-Signature: ihpt9wiontsg3bc4qrwuefb5y1m6m9dz
X-Rspam-User: 
X-HE-Tag: 1757344950-736031
X-HE-Meta: U2FsdGVkX1+74V4VnDeFu+jg0PstNBskqz6ReIVRyJXkBOWRo8QlwdF3YW+Cj2MUNCPxK5qyTSYSeFFZni/LO5wt/9qYOFLNqyX/j1ennUg1fy35KjsP8K01HayQMymEzPFXQfJv/tdWDvu2cYck/N8j10/dXYKeg4nxHc3mfALe8V0CaeMgwCAAq/MSR06EnqJKAsSjd/gQD5vcPwjA3T8OH/pzsCzqlX1G/+LhPYvI/kiQ/pSkaZoT7lKmhSrBi0Adlc/MkEx+4QDkTl7vdBRo39iF2CcJXLwYXAS4w4SzU8T8Mu5vrLKaXv/LLQ//G25V3FUdXrzVTo5L+kD8F8zozTCGJ4LVHVtBS05MOKxhFN/i+PVIKXqZZE0C30RhR0KntEfme/Eur49U7fm+9z59bGAgXdbCVX5jRp3ihwB3k9QD4kOoD/Lc6fcQBAGwADjQNyDgmbNydl4PrNCf2dgUX2Ia9+2Ygt6AimIXzl6loslSG/IHEn1s6rfP63CVEksN1YDhKIXfPMNxizgNRzzVOpJwx2FjMOjQ9gUc+lhHOkZu/NvnyyiY9peHB6/qbHwnErXH1JPhWq7j1I+lVKPjnnE+SFx1YbWMY3vljY3Ml6Ughu8VhuCjjf2bFJ0M48SGLUyKdO4+c2iJLDe9FVjp4jCC6h2OzTw+Jfwf32YAN6YhPDhojoxeA9KoMu/igPCdaA7A44pj7L4rapY7MQRWUeWSq56Xgv9+aOspUWEILsswwXWFw/MXmc9UubLhA/0CN64f5SiQ+Vr7AyoeLZ4IOa7yOUw4E77cUhHhFqJXwtZt4iB4sJJ2v0o2c9vCmYDFrq0GX7zvY1OP5OibwR9Ox6dWVuYvoYqGm7pNjtAjN5+2a8jrNP6CEF5bdmUcBPHmtAbazqrFDuI0p22fIey+klyAH72v7x91I8eipOY2jMFzLhEClhwvnsOae+eoWSh2UxYo8+BG++9DKD0
 EP7C77fD
 8qUzh5kIIHnh9TIoFl+IBIt1euindPP42IJd8TuRYLORbtHnOFTGsvEV5ik2fORm92pOtBfmqRY6WMcl+UStX/Rp9VUfjH/ATS0c4USDPJi5KH7K+x6RssY4UJmFC+DcehcQs9UYwZ4SjLbCNUvjEE6j3ms5Ip+QGsf9/gYyG3uBoNedV3kwHb/Wr/dPr0ixPZ6gIku8cvkfT7tfRNJFcwNYQd5/VQo8OWxP7N1P6RbHVQir4mUJUkDZ37aIYga6TDiFX9GzFHSiPKtEneA3VbO6Dgmjj/0g2EQE4LSJJT8NoqAkceX79U0NJyJtGgv4Bt78DkpVrqdeVEgrc0eOnOD5Rth6nMOxDpsA85GU+p5CsTdH7hmlv/d/kw54jTgCqFVi/sYcBHzoz+pmYrL9MWedjkELCT3titmRpmsBDno7DqTM0Rcw5GXEhK7PPT+Z3qt1hXXUDsHY4hPEpk5mxLwtzZ6Xx9sb/nnO9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.09.25 17:16, Mark Brown wrote:
> On Mon, Sep 01, 2025 at 05:03:40PM +0200, David Hildenbrand wrote:
>> We can just cleanup the code by calculating the #refs earlier,
>> so we can just inline what remains of record_subpages().
>>
>> Calculate the number of references/pages ahead of times, and record them
>> only once all our tests passed.
> 
> I'm seeing failures in kselftest-mm in -next on at least Raspberry Pi 4
> and Orion O6 which bisect to this patch.  I'm seeing a NULL pointer
> dereference during the GUP test (which isn't actually doing anything as
> I'm just using a standard defconfig rather than one with the mm
> fragment):

On which -next label are you on? next-20250908 should no longer have 
that commit.

-- 
Cheers

David / dhildenb


