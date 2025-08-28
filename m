Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D1BBCA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 20:17:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 877328E0014; Thu, 28 Aug 2025 16:16:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 827628E0001; Thu, 28 Aug 2025 16:16:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A0E58E0014; Thu, 28 Aug 2025 16:16:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4F6BD8E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:16:50 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C7559117F52
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 20:16:49 +0000 (UTC)
X-FDA: 83827274538.28.6CA1FF2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 52B594000C
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 20:16:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GjfZ587K;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756412207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+uwHlyQ6LciyyA2ZqVWztkqsrihdSVO7uAsTz06acTE=;
	b=KrqN6/BJ2qXEnf8hp8t3iAJtJ3/C9lXwSLVYNR0uqa8AEF9mjIM4+8JeBD9p/KPbW/ifNg
	lGxN4fpZMwS3oHo9rdiNsLkd1WNB8tA0+Hl4lehTwPZcsjyIoGo6jlOeynYRo8NPK4IP3v
	ZLe97+QSsxsYyVjweqNkwoGOhxwT62c=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GjfZ587K;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756412207; a=rsa-sha256;
	cv=none;
	b=IV/x3kBH4Qz2LynqcHozQ2pOH8EBmYgoPCMR4xNxS0rAsBgy6gDTZ82rLpYx7lxCea/qTm
	8UH2Mw08X9+kRbAkB18Xz1hy2+3rafl8Vq8LcUuqT/cKdElBeS8/Ltrfgwc8DzrMKBWkey
	1hqDSqBtoeIDICdVegs6DJSTLt/3EzE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756412206;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+uwHlyQ6LciyyA2ZqVWztkqsrihdSVO7uAsTz06acTE=;
	b=GjfZ587K5sMopN56fcfJksmu36VuWTKiX33SBkkNKRJykR+Y/QvLb6ILf3kMfqz+c/r0o2
	dGmOAZT6VbjYnJuSRZ9PwaJXkbTmKEioh6n4C87uCq62vfJXZXojHdhv7t1PDzCNd34jTX
	7hGK8AcRAY/pmnJp+P1xLbT9PaGe5ZM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-304-SiKEuAQFNCmbvauYYSmU4w-1; Thu, 28 Aug 2025 16:16:45 -0400
X-MC-Unique: SiKEuAQFNCmbvauYYSmU4w-1
X-Mimecast-MFC-AGG-ID: SiKEuAQFNCmbvauYYSmU4w_1756412204
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45a1b0cc989so10702425e9.3
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 13:16:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756412204; x=1757017004;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+uwHlyQ6LciyyA2ZqVWztkqsrihdSVO7uAsTz06acTE=;
        b=L1IaaaXepWHVumf4ezYk50fgk2qMddrzzlvH2zkKYSrHQjpmKyllFovZkZk67xyoJL
         iyxb/mvsklze1eGpado8SaLU1dxiOtlBI8Ey+hjDCN9xn9k2HDMbir6V/gLsX6N6N0S/
         WhTvEixOURAV4Y1NpdwmOmIy5QNqu6GeYAkcXyhqx9tFiPvrmITFfZV41K8yERUaIjmn
         BYILpwN2Qq3lmFhgB6p6lY0hijbYtoJj6MryYSP9i0sxIA6x5qR/e5FBC1+yT1Z6/0HO
         jT+kOZ3VKUCfrhkA2N8Eli+CXaailyTvxJiZZIw08ZevkUBa2KYeUemDcVZRMjkFiec1
         xwtw==
X-Forwarded-Encrypted: i=1; AJvYcCVq6FV352SUmHnE7yuvExCXDvAzMtc8QeDAeX+nJnkIIVsQG2v5P+RzV13xRM74lWPT6qY2DWz8cw==@kvack.org
X-Gm-Message-State: AOJu0YwgaVJq/ctrAvvbdT9/ON3AlnB8U6+NmmS/ShDpX5ADkrr0rlPm
	TFTt3S9X9wzZUxSKNSXxAyIPI0iLTzBdWIBPmfyJIMYFlFfNPJtyHM/oQ7GwIOSFVb3kY108Dam
	JtvjjG40CHUpDi2GugwKydShMdwyL7VXsxD5FEBZQKQqUpGoU7cY2
X-Gm-Gg: ASbGnctJLQP9qLnp8AROmU5axAcmob4ftyDfu6aWVXcKY/x3euOSgl3h5z0ukctIYe8
	QkRvbdY9wijb7KhN4Q6hh+WVS3teUdwe44iuG1UtHv7Yw0RnIUkKAP7LVFR62HAjB8YYfpApaQk
	d307UKhU3TACyC3/x+TjmJbOd/3j7rSn+XwrSMgtlk9YwWxEzXst4N/L38pLkPl0m9b2RSgtoiv
	CfmPHU7fbi8t4G8SbQ/+MerlVBh/qwcTzcL19/vGtWne8Bz7TGAwDDCDF0zHi0dXF6EukwfjZ5A
	QP0k+SJVikZS8GMNak5ZgmjjD/fg4PHVmphZxkn/kNJo25Kvcun1k1aVBQ9Fb2ohxGZ4bOxFMWa
	xoB50i6g4pwhI6hJasKgLtzfRSjAVc7FaQtkckvi3yAsh3cJlLjs6uRQpivxETloLJAg=
X-Received: by 2002:a05:600c:444f:b0:458:a847:671e with SMTP id 5b1f17b1804b1-45b517d402cmr220840405e9.23.1756412203970;
        Thu, 28 Aug 2025 13:16:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFop3NDQa/jvUw/7iAhPc6xPyo6DCTowuFm5PMXVJXqUwMAoM+eWtpd9lIdKLYbcTafxwGkzg==
X-Received: by 2002:a05:600c:444f:b0:458:a847:671e with SMTP id 5b1f17b1804b1-45b517d402cmr220840175e9.23.1756412203527;
        Thu, 28 Aug 2025 13:16:43 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:c100:2225:10aa:f247:7b85? (p200300d82f28c100222510aaf2477b85.dip0.t-ipconnect.de. [2003:d8:2f28:c100:2225:10aa:f247:7b85])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f3125ccsm87282945e9.19.2025.08.28.13.16.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Aug 2025 13:16:41 -0700 (PDT)
Message-ID: <c5d42263-7256-4be2-ab12-13cab0320ef4@redhat.com>
Date: Thu, 28 Aug 2025 22:16:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/memory-failure: Fix redundant updates for already
 poisoned pages
To: Kyle Meyer <kyle.meyer@hpe.com>, akpm@linux-foundation.org,
 linmiaohe@huawei.com, jane.chu@oracle.com, jiaqiyan@google.com
Cc: bp@alien8.de, Liam.Howlett@oracle.com, linux-edac@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mhocko@suse.com, nao.horiguchi@gmail.com,
 osalvador@suse.de, rppt@kernel.org, russ.anderson@hpe.com,
 surenb@google.com, tony.luck@intel.com, vbabka@suse.cz
References: <aLCiHMy12Ck3ouwC@hpe.com>
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
In-Reply-To: <aLCiHMy12Ck3ouwC@hpe.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2G2sLrhXDbfXTlsgCZ38qCSq1-wVHH9xkogtdC5KloU_1756412204
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 52B594000C
X-Stat-Signature: rekray7ywwcsoj1adz7nuh8hu93ywxwh
X-Rspam-User: 
X-HE-Tag: 1756412207-992647
X-HE-Meta: U2FsdGVkX1+6/1Hyz6SNBbUxvyTP9MZFxFekNSnAGjcUeafje67Ox1c+In82fGxb2bKbuAOSki/rNgBLcYySQIGfnii+M0gnSWcQUaLWhZwH+fUTppLfoZRvp1W0iQsLUCRchh6XG0bIf4FCE7lJ3l9JwryKb5CptQsO6EdwC3tZRwfdCbglB80/gtnjFPOUrmwXJvEqw4pqyiVS0kNf/mm8wQDEaXOZCwtoWoPVP0t7f+OyptDol4Q+UMXj5lKNkchL9RadjxWVhqIYnpqvViIM5K3kWzb3aZWLPZZFWhbyaT2DAWokxpotvoONeEROwuQMKG/Nix/wUP7v5C0eLeoVvBeWPo+32NncdD4QgbhLWmhuEAs+Qn/8A4Na+mNY9QHPV+z5iyeZoh28pZGo7IPBQ1oRdq2e/7NvWnjGTijUqT+S1uNaSZJGscUhzkCrzwouMadBavcKExnvmbs6dSJWESilmQvkNPI9uUvWZUK6FJHGa6baBv18hERoJrtP/x1XwYatZsltvTwcBqHOPrtgxZ6s5wPjbHRw0o9wDqZPj5Td6JKT7VFZNw1B1JrlL0KC40kCvaF9Uz8nuI33oX41lp40/vciFxakzpAW/jclWRfNx9ZGpaQ+guvhE8DeQgXSyN8vQ4JOSO82rf8rC7OXnocDfmnHHf/g60lr03ohNjcE8EdmSVGrDd4eMu3nzi0frS+Ba6i75MZPqVGx6fUbKqEO+eNXz0JJq0EYmXf3IuzC/96Xn8InZG0nX2dGvgOQCkXs3OzlcxWkO7p6TCr/y7d3zD4Nm6uqIgGO2JfWF83Bj60T393qoVr7GN0OrDir841aV79cR5Fw4BEv1VAf0FQLP7ZEMIeujFPWGXuJ6T307uA2aQ9isX5nmXmG5uIIq6CAn74g5ssB7XDD+7Imaamqx3sQ9JvXM0bZA/3HmzIVbT5POzlkilSzNZ73gHVtLAjEc/1CpF1Cpkq
 JL7wjZdx
 mvXYRl2ZEplg94nLc3D4tUQRSrg3eHxRMDQt1IrlAl8yJn+xcQIqGWcseuULRndJFeivsbDndSqpI7eDGxcBxeT+nHrN40Rhsn82wHncj1TEhTH4N5w3qdzqBLIoXOLsXN2O1JFlBrpksfrGc9qCW/lL6SS2X+88XLX75rQRamxRGOyxSy+++CX89fZDYz+RF7tWr3FiMHOG55zKrEnipBmEfep5aTkkchWo7mZ3A0SMZULAVzqNncXTMOOcY70uU1XxRwDmjW9+7cq2nBaNi3qjZu8QQpDmJRNVdVdeImu4rTBIQByuT4c8MJ5qdex705gw/5rdLiNB9uz08pMmJj9BSPxxm9R9GlUDwZ+J3t1Df2Frroa7bmm6QE632fuqV/VpeP+y4n3G2K6Kn8ky7dxAXfOfb+l3wpKr/3n2Y3Xjcn1T9TqJKL8nnu2EdYXqHEJCXyDVEUmQz30HFrpHO96NtYZF87YmvliIYuMu7c2Brd8a1maEp3tkynYG8VQxNwx6pJf/+8IWTsd56w40QpCwVxbXLNxcjWPIx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.08.25 20:38, Kyle Meyer wrote:
> Duplicate memory errors can be reported by multiple sources.
> 
> Passing an already poisoned page to action_result() causes issues:
> 
> * The amount of hardware corrupted memory is incorrectly updated.
> * Per NUMA node MF stats are incorrectly updated.
> * Redundant "already poisoned" messages are printed.
> 
> Avoid those issues by:
> 
> * Skipping hardware corrupted memory updates for already poisoned pages.
> * Skipping per NUMA node MF stats updates for already poisoned pages.
> * Dropping redundant "already poisoned" messages.
> 
> Make MF_MSG_ALREADY_POISONED consistent with other action_page_types and
> make calls to action_result() consistent for already poisoned
> normal pages and huge pages.
> 
> Fixes: b8b9488d50b7 ("mm/memory-failure: improve memory failure action_result messages")
> Signed-off-by: Kyle Meyer <kyle.meyer@hpe.com>
> ---
> 
> v1 -> v2:
>   * Continue passing poisoned pages to action_result() with MF_FAILED but don't
> update anything.
>   * https://lore.kernel.org/all/20250821164445.14467-1-kyle.meyer@hpe.com
> 
> ---
>   mm/memory-failure.c | 13 ++++++-------
>   1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index fc30ca4804bf..10b3c281c2ae 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -956,7 +956,7 @@ static const char * const action_page_types[] = {
>   	[MF_MSG_BUDDY]			= "free buddy page",
>   	[MF_MSG_DAX]			= "dax page",
>   	[MF_MSG_UNSPLIT_THP]		= "unsplit thp",
> -	[MF_MSG_ALREADY_POISONED]	= "already poisoned",
> +	[MF_MSG_ALREADY_POISONED]	= "already poisoned page",
>   	[MF_MSG_UNKNOWN]		= "unknown page",
>   };
>   
> @@ -1349,9 +1349,10 @@ static int action_result(unsigned long pfn, enum mf_action_page_type type,
>   {
>   	trace_memory_failure_event(pfn, type, result);
>   
> -	num_poisoned_pages_inc(pfn);
> -
> -	update_per_node_mf_stats(pfn, result);
> +	if (type != MF_MSG_ALREADY_POISONED) {
> +		num_poisoned_pages_inc(pfn);
> +		update_per_node_mf_stats(pfn, result);
> +	}
>   
>   	pr_err("%#lx: recovery action for %s: %s\n",
>   		pfn, action_page_types[type], action_name[result]);
> @@ -2094,12 +2095,11 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
>   		*hugetlb = 0;
>   		return 0;
>   	} else if (res == -EHWPOISON) {
> -		pr_err("%#lx: already hardware poisoned\n", pfn);
>   		if (flags & MF_ACTION_REQUIRED) {
>   			folio = page_folio(p);
>   			res = kill_accessing_process(current, folio_pfn(folio), flags);
> -			action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
>   		}
> +		action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);

Was briefly confused by that change, but action_result() now essentially 
only traces + pr_err() with MF_MSG_ALREADY_POISONED.

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


