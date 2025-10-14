Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82592CCD18E
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 09:35:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE2AF8E00D7; Tue, 14 Oct 2025 05:35:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBA958E0097; Tue, 14 Oct 2025 05:35:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA8B88E00D7; Tue, 14 Oct 2025 05:35:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B61818E0097
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 05:35:54 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 41B69BB54F
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:35:54 +0000 (UTC)
X-FDA: 83996213028.21.6E5825C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id DE00E2000E
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:35:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XAtFp6Xr;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760434552; a=rsa-sha256;
	cv=none;
	b=dBM4yg6GQc25Y09wMZHxp+hIGFzWuo5lfNz7iNCtyUU4NgvKeKOgl1Xl+5bHD5QsKsVju2
	h45m+WpHbA6J1nkPZKCnKeLmaPpfGzgrEmz+ny6kgZ8nsbBx3IbXGmtijGB8CbmmXMZmeQ
	yrA9jDwp4q/Rdyc+ivSVCJ2GwqIY/WU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XAtFp6Xr;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760434552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y2F6jOViE63Bow9w5wII9vTrnKutraVO4tvBb2COsWY=;
	b=QbSlq0ROLc3RGeCFAeTy2K4NJy/zF3X439/SFedKQJne8llcgOyQCCcAECBzremS0LRrpW
	Z7oUf9l2rqFXKnY5Iie9x9fbF/gNhBCzLyQEHTj4dpX/YoErchkQ/CRRh3R2uRwaOX/Alq
	z0NbvdV2mmIbTSkVVKeOX5BURjRU2OY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760434551;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Y2F6jOViE63Bow9w5wII9vTrnKutraVO4tvBb2COsWY=;
	b=XAtFp6XrPBsqOftDeU6TwQWiUCfKEHqAybDwMXTHekK8RY7g1dJfUVu2d4koUS3+p9Z3wZ
	sgObsSy14F/THScFSyUMASDslGil3tcaHJXVutmp7BJcN2EBGN2rV9+NiL/KuEs+/LP/Ed
	Kwlg8JG0W06Hxv78n8YTIdJMJHsYka4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-460-XuZCGFQwMC-EOEyR_qJHqQ-1; Tue, 14 Oct 2025 05:35:49 -0400
X-MC-Unique: XuZCGFQwMC-EOEyR_qJHqQ-1
X-Mimecast-MFC-AGG-ID: XuZCGFQwMC-EOEyR_qJHqQ_1760434549
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-46e3ef2dd66so34125295e9.1
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 02:35:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760434548; x=1761039348;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y2F6jOViE63Bow9w5wII9vTrnKutraVO4tvBb2COsWY=;
        b=SOSdlWX/oeEeeFxE42WXFIUcJe+p5ougV5D6HwyVZoXLIj9baz6Qa4YCl83wPVUWS/
         mp74JS5CwUv88ZKhcY45mQfTM2p3Qh6j/D2g/Z3mJXYPK5YvplwCbyt77CS7FhpRMasC
         7i7s5vOP2LCamaOoe5cHhd5N1XA8MB5fpZ8stM+oUG+fvb9xDHpZsIaUluJ0R7jI4Wgs
         xXPfzeSq9nbJhB+OYFsq/OJXvmeVjRtDa34gqLbRRAFucBOB3Vv2y9nl05VR25B7Kxds
         U2P/g85lUeyPKikrU/ay29/VpFiMSuyuKXv8Yh5qCSYnh3euNzfV32UUPk+fsmD1HDph
         ngsQ==
X-Gm-Message-State: AOJu0YzkIuxlv0J9Ks0MPYHnb4025MNn+qs4DM29MJW/31h6iVmXFoVw
	P3dP71d4LX5q1DgRqJFVZWxN2Jmr/7uXUUsuC2WMBLxPx8Ck1mNJlms/zvHcdG9NSv2SuU4T/t9
	2v1TNOjts8ofoYo67MajXA9OmMX77/VtBD4AZNjW91eguP9asXidc
X-Gm-Gg: ASbGnctC47qrsBMyV9OBi+47b0afbu2JotZVdZsM8vzHH2zqHWuhOJcARE/Bd7V/jjt
	Zxkm/nJZGk7/Yofq4IQ/YqtzbgU0MBnrF3pspfVa1zIqoVJgYHTAu8T0kAEgUA7mykt0I9Q9HsU
	FD3slBLKyaG+gXTU57yLqgeQu9nCi1BvQKfihVqoMi/UyqrKzdKuBU5ZNPKt+XeL9xmmdQUsrwl
	XLYCvLYhM9CknE8x+yYZdKL9xl4V5i1L0oXxrjP8RLlgAQ0qSYO+6Cix20c+dTa9SKiSw5j/PQK
	BSljc+Vd0uUvmmVV0mCy0/QUlYNS8ehs+eqOjUZW6DH7GzB/htqUGxATTimF8XIN7Asy01e2Hw=
	=
X-Received: by 2002:a05:600c:6011:b0:45c:b642:87a6 with SMTP id 5b1f17b1804b1-46fa28bbca1mr142788835e9.0.1760434548606;
        Tue, 14 Oct 2025 02:35:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGlkAHGXny2AktZfU6F6Ctm7oqV+VbH4UKxyISSjJEN6gm5yYBb/IdMAma5QouQOPHbRHD5KQ==
X-Received: by 2002:a05:600c:6011:b0:45c:b642:87a6 with SMTP id 5b1f17b1804b1-46fa28bbca1mr142788655e9.0.1760434548106;
        Tue, 14 Oct 2025 02:35:48 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce57d3desm22829660f8f.7.2025.10.14.02.35.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Oct 2025 02:35:47 -0700 (PDT)
Message-ID: <e6bb05f7-8f05-409f-9d87-2d25f66942a9@redhat.com>
Date: Tue, 14 Oct 2025 11:35:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6] hugetlbfs: move lock assertions after early returns in
 huge_pmd_unshare()
To: Deepanshu Kartikey <kartikey406@gmail.com>, muchun.song@linux.dev,
 osalvador@suse.de, akpm@linux-foundation.org, broonie@kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
References: <20251014050609.349461-1-kartikey406@gmail.com>
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
In-Reply-To: <20251014050609.349461-1-kartikey406@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: aStT6VJADdqaWef5l2CR5AWwd_nfs0joQHWQFZwJsYQ_1760434549
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: g1ckdimjsb1emzhdrbohbo3d65943idx
X-Rspamd-Queue-Id: DE00E2000E
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760434551-910848
X-HE-Meta: U2FsdGVkX19jWeLJDWcieWcDRja1nR8ztW+Yfc+chAUhiAFXNNE8hvrUGgIc8Kr1j2VKu9I6jVsUih4nMPYTWumipy1LE3ZkIUFR3QVxJnP3fH59Wu8cKVA9ZSvdBDU7KOoCzfzF/xbtOxuq9DBv1iC1vJw7WEPdFa0ILOctpyFVG7KrTRXvbdTKNqd0EaX/ODo0oJkaQa1Kkq3eANDn1MGSh4Uh5fM5je0r6nPc50S2Y7bpUR8n3LQ6JV6VgmCpDsFGIaHx9P5HRAj9B1xDfM2VXHW8ACNG41OMnSzVtEgVWsU1ZJ1Dwynef5VUGftw0pvAOsuiuqLaBhzQOhdXobahoq1mtuLqF21CgFPFxMWQmsr9gjqcULdWn8w6VbPShJv8uwyqwJdHEI3BiF4t+NfFK6yTElUnOa9P1C36xoYsmCECWrfPP4Q2tMfBl7/c7sWpdsZQIsLuu6Rm64tmzTjBMVQqk8GGRo4XKbpxGpC7sQmN+LP271mjWGrnFMwtWjNnki/exDJofpph7ylw9BCLeeGN5wY9pUqTGWHAWrI7Y+i4CFFA4gUYX6yO6j3tuelT4cYtZouev8lv+0R9h82HGGtRkVE85PBzoim3irsdkFnWZ80sz15AY/HDnoyc43tUdDhltwuMap36h5nhLaY9dhu0BupTFbnXfwhqKeEYUVf/zs9NIgQyTKlNUwrer52x8ptuoMFJCdZsnGF3KBESWyNkQcPtNInKK4xD+F/Tehm0aSNlFyGcwpKiZmimbNR6bzV9oEZmdednA98ANup31SxFtoYGV4HZ4veZgT0XHFNqZ6OtNjEbib9cuYjpWSbeJ2+chejcypbxK7rVJqynnpSOKoGN/pTTU9Gc2FQSPaAYHCrSksry+AhByZE/rbi6GlIb+f6ojBfBGfIS2weeXLUGh0O65HNprHp+FUKHwDlDza50uVlJUgnHJdSSMTkT7GAFpv8v35WUKIX
 bxL887jv
 4CtGuPqQmkDx+S/GJrxOnBfdirWY535wJbwSWCTFKSIK3zqu16lL5j7UPxZwBzwGJqlUfYd0aiZX/C4q+mOra/STDvoqLHuRwW76oy1q+2t2fFah474F7TqyH9q9SATYjBTZWwXQPwcuNIztEfuURWGk4rSTQOoyGSE02+NpsrWIUb6oTExduUwRxsIQfjOrYJMNN6tRceGyPu96RfniqM5YYjeV4b5Bu2kmlJa9wsm1o6MY5DRVBeFCQLVzxMuc0nTXddL/qVZBaOXdVYXHcvvDF9Qc4Y4K7aFMvMsMAnMYk4rJJ4v3RAxTIbzRqxG179MVR7NCqx7kBEfVJDcAQHBKmMNGesrsklG4+paV2aRguSLtwbPLg/nbJQeWcBm5R9uvz6KqDB9LY3Zw5ZMOK6NOah60sWTYtda2f7W0w/5DQNz7c0ej+qD8SvtZMDJAEpqO7zB9a44SEf+mfNJ54QQbwDpwoqO78+vcM+cku9LxNyVvhvxgNIgh0AVyvksLhCz9iBgHJdyxe3xWGOo47hVm7WiHngv8Cj3DtVsxyaMp424if6lo80aygxFIMBvWBXFpISZmnB7Qv0QrfXdedTTlHvmhI+xZOn/DTFRNRJ5nz7M2t4BtWiH4qMyPf5IMjnEjFe0gqhnMkIfcvMpM25qc712zyHRMT3KHriowVydY8zvosnVEZRFffmKR0IIgZi0T9HhzS3IBNtwGlLpX+znDOKSBcy5amTqUDzISmwfGSqnim0ImIPbuEIsbjYTiDlpQdIbwSmvTGsgDs1WtAYKq2EMM8HEuuqbx7m7XLkk5LRe8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.10.25 07:06, Deepanshu Kartikey wrote:
> When hugetlb_vmdelete_list() processes VMAs during truncate operations,
> it may encounter VMAs where huge_pmd_unshare() is called without the
> required shareable lock. This triggers an assertion failure in
> hugetlb_vma_assert_locked().
> 
> The previous fix in commit dd83609b8898 ("hugetlbfs: skip VMAs without
> shareable locks in hugetlb_vmdelete_list") skipped entire VMAs without
> shareable locks to avoid the assertion. However, this prevented pages
> from being unmapped and freed, causing a regression in fallocate(PUNCH_HOLE)
> operations where pages were not freed immediately, as reported by Mark Brown.
> 
> A subsequent fix in commit 06e8ca1b3dca ("hugetlbfs: check for shareable
> lock before calling huge_pmd_unshare()") addressed this by checking
> __vma_shareable_lock() in the caller before calling huge_pmd_unshare().
> However, a cleaner approach is to move the lock assertions in
> huge_pmd_unshare() itself to after the early return checks. The assertions
> are only needed when actual PMD unsharing work will be performed. If the
> function returns early because sz != PMD_SIZE or the PMD is not shared,
> no locks are required.
> 
> This patch removes the check added in commit 06e8ca1b3dca ("hugetlbfs:
> check for shareable lock before calling huge_pmd_unshare()") and instead
> moves the assertions inside huge_pmd_unshare(), keeping all the logic
> within the function itself.
> 
> Reported-by: syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
> Reported-by: Mark Brown <broonie@kernel.org>
> Closes: https://syzkaller.appspot.com/bug?extid=f26d7c75c26ec19790e7
> Fixes: dd83609b8898 ("hugetlbfs: skip VMAs without shareable locks in hugetlb_vmdelete_list")
> Suggested-by: David Hildenbrand <david@redhat.com>
> Suggested-by: Oscar Salvador <osalvador@suse.de>
> Tested-by: syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/mm-commits/20250925203504.7BE02C4CEF7@smtp.kernel.org/ [v1]
> Link: https://lore.kernel.org/mm-commits/20250928185232.BEDB6C4CEF0@smtp.kernel.org/ [v2]
> Link: https://lore.kernel.org/linux-mm/20251003174553.3078839-1-kartikey406@gmail.com/ [v3]
> Link: https://lore.kernel.org/linux-mm/20251008052759.469714-1-kartikey406@gmail.com/ [v4]
> Link: https://lore.kernel.org/linux-mm/CADhLXY72yEVDjXWfxBUXfXhNfb8MWqwJmcb1daEHmDeFW+DRGw@mail.gmail.com/ [v5]
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> ---
> Changes in v6:
> - Remove __vma_shareable_lock() check from __unmap_hugepage_range()
>    that was added in v4 (commit 06e8ca1b3dca)
> - Move lock assertions after early returns in huge_pmd_unshare()
> - Complete implementation of David's cleaner approach
> 
> Changes in v5:
> - Incomplete: only moved assertions, forgot to remove v4 check
> 
> Changes in v4:
> - Check __vma_shareable_lock() in __unmap_hugepage_range() before calling
>    huge_pmd_unshare() per Oscar's suggestion
> 
> Changes in v3:
> - Add ZAP_FLAG_NO_UNSHARE to skip only PMD unsharing
> 
> Changes in v2:
> - Skip entire VMAs without shareable locks (caused PUNCH_HOLE regression)
> 
> Changes in v1:
> - Initial fix attempt
> ---
>   mm/hugetlb.c | 7 +++----
>   1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 85b2dac79d25..0455119716ec 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -5885,7 +5885,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
>   		}
>   
>   		ptl = huge_pte_lock(h, mm, ptep);
> -		if (__vma_shareable_lock(vma) && huge_pmd_unshare(mm, vma, address, ptep)) {
> +		if (huge_pmd_unshare(mm, vma, address, ptep)) {
>   			spin_unlock(ptl);
>   			tlb_flush_pmd_range(tlb, address & PUD_MASK, PUD_SIZE);
>   			force_flush = true;
> @@ -7614,13 +7614,12 @@ int huge_pmd_unshare(struct mm_struct *mm, struct vm_area_struct *vma,
>   	p4d_t *p4d = p4d_offset(pgd, addr);
>   	pud_t *pud = pud_offset(p4d, addr);
>   
> -	i_mmap_assert_write_locked(vma->vm_file->f_mapping);
> -	hugetlb_vma_assert_locked(vma);
>   	if (sz != PMD_SIZE)
>   		return 0;
>   	if (!ptdesc_pmd_is_shared(virt_to_ptdesc(ptep)))
>   		return 0;
> -
> +	i_mmap_assert_write_locked(vma->vm_file->f_mapping);
> +	hugetlb_vma_assert_locked(vma);
>   	pud_clear(pud);
>   	/*
>   	 * Once our caller drops the rmap lock, some other process might be

Can you resend based on mm/mm-stable please? Looks like this one is 
based on v5.

-- 
Cheers

David / dhildenb


