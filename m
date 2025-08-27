Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44573C8303F
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 09:35:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 680726B0195; Wed, 27 Aug 2025 05:35:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 658236B0196; Wed, 27 Aug 2025 05:35:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 546756B0197; Wed, 27 Aug 2025 05:35:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3DC956B0195
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 05:35:40 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E8E69C0503
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 09:35:39 +0000 (UTC)
X-FDA: 83822029998.25.12CA912
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 74A0812000A
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 09:35:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EfMEX70+;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756287337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z5fukYO7kXwNxBLuSBlCYQ0Hv0U0IOhmRPFv+8P4+0E=;
	b=PDxQY74pDtHRAEN8svP3Q70MbRrwbni72+4AX50i84OPOCqg2obbJdWNE0YpAf9O/c9kPS
	tI9+EzbGAWu1590jog1n0av/20twrSQ1xIeJBz7O+vXGn2pot9u8aYVzeqhJpdaiREk2it
	aYT06f+GZ7EbsnfT4mJtFYYvPNQx3jg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EfMEX70+;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756287337; a=rsa-sha256;
	cv=none;
	b=8LSk5u5iX41r7gdAUa2Vj5hO0SeDGcT/t9FmqTH4vEgERZVyUmNjkaNaKPVeRxDhTJdtoL
	F2JXWV3ZtDcma07uQTsSMENf/ukcU6s79i2TrUIfzqtTbppThdqKZgiXXbCo8rizDJEJs6
	CNlZ/pfmAWi3Q5+xuTF96/2F0nZoAVQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756287336;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=z5fukYO7kXwNxBLuSBlCYQ0Hv0U0IOhmRPFv+8P4+0E=;
	b=EfMEX70+i9xsqHqNSLH5STbuETnTfDPmelLEEHcMYmI/FM1Xdbroj+rfD/pZBZ+avt4h4d
	64LjevrKlCdwXa7GnmCU9APG5eeMZkvSBav8F74V1Q9NRTZzvR0cBMXKkxSCsMvnIXB59W
	8xDP85KQ2tyWUnVc/YSTR8ZpvXdXTPI=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-18-C_mlrT5TPC-3l160DMP58w-1; Wed, 27 Aug 2025 05:35:35 -0400
X-MC-Unique: C_mlrT5TPC-3l160DMP58w-1
X-Mimecast-MFC-AGG-ID: C_mlrT5TPC-3l160DMP58w_1756287335
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7f737071bebso159176985a.2
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:35:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756287335; x=1756892135;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z5fukYO7kXwNxBLuSBlCYQ0Hv0U0IOhmRPFv+8P4+0E=;
        b=gO6kzVnK2A8WfHlQblxnszk2UDSd0cftQ9P26c4Lqkc1yalgrzTnwXM8L9WxIwhci4
         vnIEC64Ncn4FspbbO/Df5qE93iGUL4pIRu/LA0IcT1DcE8W0kVusgH0xZ3ZuX1bSI+3n
         7Vl4iOhamcJJRtclhnORAqyqXXk8cUSmfyLsK7za07ftBmNAP0usRdBJcx12QsXFi0Ri
         hAtm/X1wpbdlxLXimps/iU0acj+zIJi/vPGyIqe03ATQZ9OPTIq2+EBNjWKRCg40WgKb
         N12fkARmtrqGdo9oOZ4RI0d8A1rpdSa9zvl1vA2ppA4Z8S1jkiz2p27h0zM1cTWTno3m
         WbGg==
X-Forwarded-Encrypted: i=1; AJvYcCUItEPXObxa8XI20BMpZ440y19+72zT/iMzt5r1x+PCwzHs0YCaCJhrRkuFYXddxnrMvld/r41o5g==@kvack.org
X-Gm-Message-State: AOJu0Yz9cPDv+5/y1x6ikyGRrN9n0aog29CgP6u0VfjNdVy2lGQ5QyKn
	BigFe3H2HmMKqwNsf6EsmOSbG0i88sQ/c6i0l1L70Ighk8mjffHRRrOgqx4KiwCnlv/glaaZT64
	UtaFixSyddmc+wm4lzPn3v+INsRgzACvwwTzQQ9YoUqtvg8/FC9Xg
X-Gm-Gg: ASbGncs32As8oS80lKRgUb+br8PZODXG/bDHBdckmm84xR6UeXbmIVqX9r2VCnUgd8X
	Gh1A0r1L9fLCx4WOdO4hCSM0kEC71QuiCNGPL5XgD4FefTTjus3gZ07uY2zKaVdRhlSH+C/0tyN
	oURWf51oe2Px/v4DJgz75kQH0BL45FMEQvB2DN1a/PEaqpkdjcxJLweaCB1KyXiCwFhqmnX9NpQ
	geZFf0Lm8xRf/8LLJQkaQBhDbqD6tv6PJHnMDSuJIK4VCnw+UlOYEPocf3p9b3XfeuQurckNIa9
	Be57yMyFFui1K7zlMUyu/x3PV9nb3e1EerdYQxhFbPhckKCuAe/kE9DcwURjbw==
X-Received: by 2002:a05:620a:1913:b0:7f1:9a91:1dde with SMTP id af79cd13be357-7f19a9144d8mr989205885a.20.1756287334735;
        Wed, 27 Aug 2025 02:35:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE2aVIZceEmeuIaXPM4E0OwdyqHE2I9pakBoXeuwOZHcZ1gpwYn5EvPozgzRW+JuFbVfaucVg==
X-Received: by 2002:a05:620a:1913:b0:7f1:9a91:1dde with SMTP id af79cd13be357-7f19a9144d8mr989202885a.20.1756287334240;
        Wed, 27 Aug 2025 02:35:34 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7f4eef7101asm266977985a.38.2025.08.27.02.35.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Aug 2025 02:35:33 -0700 (PDT)
Message-ID: <4e148b62-a7c1-4162-a487-1ab0199b774e@redhat.com>
Date: Wed, 27 Aug 2025 11:35:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] huge_mm.h: is_huge_zero_folio(NULL) should return
 false
To: Andrew Morton <akpm@linux-foundation.org>,
 Max Kellermann <max.kellermann@ionos.com>
Cc: lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
 bhe@redhat.com, chrisl@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250826231626.218675-1-max.kellermann@ionos.com>
 <20250826185515.7fbe1821713195b170ac1b31@linux-foundation.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzSREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT7CwZoEEwEIAEQCGwMCF4ACGQEFCwkIBwICIgIG
 FQoJCAsCBBYCAwECHgcWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaJzangUJJlgIpAAKCRBN
 3hD3AP+DWhAxD/9wcL0A+2rtaAmutaKTfxhTP0b4AAp1r/eLxjrbfbCCmh4pqzBhmSX/4z11
 opn2KqcOsueRF1t2ENLOWzQu3Roiny2HOU7DajqB4dm1BVMaXQya5ae2ghzlJN9SIoopTWlR
 0Af3hPj5E2PYvQhlcqeoehKlBo9rROJv/rjmr2x0yOM8qeTroH/ZzNlCtJ56AsE6Tvl+r7cW
 3x7/Jq5WvWeudKrhFh7/yQ7eRvHCjd9bBrZTlgAfiHmX9AnCCPRPpNGNedV9Yty2Jnxhfmbv
 Pw37LA/jef8zlCDyUh2KCU1xVEOWqg15o1RtTyGV1nXV2O/mfuQJud5vIgzBvHhypc3p6VZJ
 lEf8YmT+Ol5P7SfCs5/uGdWUYQEMqOlg6w9R4Pe8d+mk8KGvfE9/zTwGg0nRgKqlQXrWRERv
 cuEwQbridlPAoQHrFWtwpgYMXx2TaZ3sihcIPo9uU5eBs0rf4mOERY75SK+Ekayv2ucTfjxr
 Kf014py2aoRJHuvy85ee/zIyLmve5hngZTTe3Wg3TInT9UTFzTPhItam6dZ1xqdTGHZYGU0O
 otRHcwLGt470grdiob6PfVTXoHlBvkWRadMhSuG4RORCDpq89vu5QralFNIf3EysNohoFy2A
 LYg2/D53xbU/aa4DDzBb5b1Rkg/udO1gZocVQWrDh6I2K3+cCs7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <20250826185515.7fbe1821713195b170ac1b31@linux-foundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: iq30lV6L7I99bboXeGt50OBtChHj3ool6onn9EC7Qo0_1756287335
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 74A0812000A
X-Stat-Signature: b5695mt38rtnhkww38ttb3p8p1ukusj3
X-Rspam-User: 
X-HE-Tag: 1756287337-377642
X-HE-Meta: U2FsdGVkX18dW/PGWTerjDh+z9Z8776pvyU1Qx5JR28d+lZDBsDqsQ4KQKhBsv9ndfRnIaPB0eEQtBNgC1MKI19rgvT9tHkyUaHdDHkB1teqcWXOtq9sQwgi6Ontmg9rtEFjGImi8aPGnEyX07XOC3EiNA0vt9iUavKX+Ox5jLA2Yd0DTxIz9ccItJ8+mQaFpqrQ0uTphXVdwlUCzZFftT5drCAS72waVIe6d2DRzoh/uioRE4Q/40Oetagy0BjY6LBNV7/yKQ7PX0CwNtxLKvU/o0mMhs3DUwT0HMKXs6AnyQe0QtWNQxZJ3RlionEGp54OBsCMq6j6y7Vhvp/ZssOacNc4h54wESL6APUAcpNYzF1dKb760cPQuuW/nVBDqQnugSu0JMEWzMGkhllRaCM6AcWvaNnl6IuxWsHnKSZVYKNTwN6TztEJQaLlSVdtp/J8DGFMypxVOyX3X5FtzOjc1ZWafp3qup3O20xx1MosE6B9V1e/ix3mTDS2sTiXNX2t6A/5N9H75Iw+E5os0IDmOPTU0OYv/LiRE7sWBPs2laLhf/FL6uIjyZW1j0XS5pPETKN0BqNB1dPRqkGqavVVCd9KI+1cPT6unQfub/optwFOrzr2KMMqu0nguSBFwJTdxBbIoAcf1vRTZ1E4PrCHRD2iyJWOg3+5M3bLYva8sh5cvjqhGELhJf3/Vadzs7VwwkyUo60U51KcurPXqIqq6Q9JNwhwpNr/Jink9NItx37XWZhVRPtMMLCQGmGQDNVLQwvcgqfWWCFOL3SWuln9k1+YHoVy2bIXEm24MEhjrFgwwBncJaYqQneMgqQxUq8rRHt0uqWGFHex0jvltS3tNc7nNfdIzYYNQZTUZqDTu+cbtXpAw3Y9lZ7wuxQ44cZp47TmVpLWx8IyLExzhgZ2i/yHj7aCJc3XlVHxFvTQ9KdC0ncxk7MTe4QmodrzzA92/Y/IGKB7XrLpufM
 XlqwONWx
 SMPF138tG5YBZH6z2Xnw7Ym9eWyZSPGWts888vafYvXxlH2+iiJBY0xDdy/ouUa9d/TjVj24hU6BDL2hftqUuV+4Tajnjbf0yijUFQymPyPtIlM+w0CZeDewhW5N6tkz005RZYgOt8H5cQL+E9n2HKoji7ehF8J++OzNKSeMgl02sd+XdJk8te0ZQpSB5lAuf8P4xvN3RAnUOhoR4RAEEn8fiW7H6lgNINVEYgGFG1TPHDMzUr/ynitFLJ63mVaDnH5VyLa/slGEr6fa2RXU+kQM1FL9/2sxigw0bL38RUYtP6gXANTKnXVFRmGohHW3ORv0sfh883efdsC1rRUvCUR/f0uQdRxk7k5DXLhCyhB1A5ERAixClXTjlTNgxriFsNf+AJa6U/HV+h2ibLmBCprXigG5ThXlrXi1IQxSpwNkJGeSNqLZqGUflGY6oQCfkr3GhL+4L2+BEDur5ylJsh6NAe6S1spR/KkA3c3al9xjnVz8EIbvhlAAAwg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27.08.25 03:55, Andrew Morton wrote:
> On Wed, 27 Aug 2025 01:16:24 +0200 Max Kellermann <max.kellermann@ionos.com> wrote:
> 
>> Calling is_huge_zero_folio(NULL) should not be legal - it makes no
>> sense, and a different (theoretical) implementation may dereference
>> the pointer.  But currently, lacking any explicit documentation, this
>> call is legal.
>>
>> But if somebody really passes NULL, the function should not return
>> true - this isn't the huge zero folio after all!  However, if the
>> `huge_zero_folio` hasn't been allocated yet, it's NULL, and
>> is_huge_zero_folio(NULL) just happens to return true, which is a lie.
> 
> Isn't it a bug to call is_huge_zero_folio() before the huge_zero_folio
> has been created?

It's a bug to call a function that expects a folio without a folio.

> 
> Being a simple soul, I'm thinking
> 
> 	VM_BUG_ON(!huge_zero_folio);
> 	VM_BUG_ON(!folio);

We should just do VM_WARN_ON(!folio);

-- 
Cheers

David / dhildenb


