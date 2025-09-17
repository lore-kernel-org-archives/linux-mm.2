Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DE59CA0EE8
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 07:39:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B7E08E0003; Wed, 17 Sep 2025 03:39:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98F2F8E0001; Wed, 17 Sep 2025 03:39:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A5678E0003; Wed, 17 Sep 2025 03:39:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7DC0E8E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 03:39:02 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3548E1A0458
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 07:39:02 +0000 (UTC)
X-FDA: 83897940924.12.9964273
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id B53DEC0004
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 07:38:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iOrzlrPr;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758094739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ecjLuFYma2pmjKDGSxmd7rMO1bVxbe6uv0k2p4+S6ME=;
	b=NhJb4DLN4e77ZIpIKyHSNfdXGeveoJc/lP3iAMjQnvmgMdjml89y79GkiWwoA2Z+J0wFcx
	f8Kh8Opp3ABN/bZ86V7wt0Rf86ubG0wclrPXA5qiJU9SRckGIF5Sk6wUZrLzhYVjWGQ7Ox
	yCDHf5VO29bi66ik4Kq4Yo4j0ie7qzw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iOrzlrPr;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758094739; a=rsa-sha256;
	cv=none;
	b=mMh16lHStnje2d1ONRMSuDuBgvhE3UOc1/uZvnrNLlzej5QxlYDeSBxvsZDqKhdvkr+EB8
	/mSWefswhcQ+iVODvX62lmOewk4XUBg5Wv5EAly8twaCVp6RKX6kDnw8TbASk3zEXiN82o
	xKgK1tsaawfacpoO0u7H13nOAUW9QAc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758094739;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ecjLuFYma2pmjKDGSxmd7rMO1bVxbe6uv0k2p4+S6ME=;
	b=iOrzlrPrHA2p/nF8dG81QaqMlyuBOcK6/MaGOamRoev4KDSBvY2c/HFwNMjZVYfNti/f2S
	acKwsZo1bFMTvrj4hNpAGErAsMbTlR4zJNe/E2hTcIY6jj5/ea8IpmLNB4prZs/9vWbVpJ
	JNuff8DsnIi3kj/r4kMraLOI4r95lcI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-588-lQ5CKDYkOXCibiH_s6BAvw-1; Wed, 17 Sep 2025 03:38:57 -0400
X-MC-Unique: lQ5CKDYkOXCibiH_s6BAvw-1
X-Mimecast-MFC-AGG-ID: lQ5CKDYkOXCibiH_s6BAvw_1758094736
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3ecdb10a612so629914f8f.2
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 00:38:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758094736; x=1758699536;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ecjLuFYma2pmjKDGSxmd7rMO1bVxbe6uv0k2p4+S6ME=;
        b=I/RSp6W6Jf2s2/EAG4Ws8/49DkhQLnrMcl2l+pxdw7o/7d0z0Dd1vHh186asuzEPCH
         FedI8u0HyEtPrELkCXbQGHIBWA9aBuqQr1SPxpm3Uai6hhof//yYd7eLSAgG5GHZO3Wh
         Jh1JPSRG44j3nnRWx5TNDqqdcOGxu0DgXGNiBrn7gFIXE+maka6fgn62JKKvbwCshpAN
         NwWTZWirb4dDdfoAquRspGPzBxCFatVe9DvN8oQ1sMu2qx6GusSw3sG7SyRlX2b9/9Zm
         3KZ9i+q/8L6S2qUM0Fi0Ey0Jqni41cGDi524LU/14LpsxHQ/ks+ybEDS9ghCE3JVEwq3
         cTkA==
X-Forwarded-Encrypted: i=1; AJvYcCXpNhB2Qjd8czdVWw+ulIkbc4TADfHix5NHDeDSYMynrcT7mnQ9FdRBRGm5UUjMD5RxxM1T/BhdpA==@kvack.org
X-Gm-Message-State: AOJu0YzI5o9L7L+ySujTggzojKmLLns0e8SDGlCdGSlwh/OXO1boN1C4
	rO/pT12IIh0NPcG/uSYqxqYA+DqvkR0qtriwxWRoUHorkbydlL6nRshOH8Kn4/X5HaVhtZ/Dm8e
	//R7bhhHVBXrhBZiUKszY0tiOMo860CU027ziE51D2OVpPMzLHRnp
X-Gm-Gg: ASbGncsg//so8BJPhpHKvRMBZIghgOk/hhhNkNAHdXLWj/Z1+1HVrrsu8u2ygZdtrzs
	Q5u462HgcjQVO7Z/gw/Y9KuTG+JfYz8CEpucsjz/u18LJk6oL8OfoC9VxPomLZDuT1blrN4z2Uu
	76BEqXZbHai7SFXr7NhUykA8TCh+zmGs1DTlj5U+wC7bRKWj6naSwrGMT8ZinJi9/mB7RyF1MKc
	xQhOxMddpOtgs+bKhy/hS2CUh03c8n4BcDd09tYUxViHW4BxwzIUiVnBg63yoIP/uHFEoShuUng
	wLhuI24eeC1+e8UHnrD2DxjMIJl4nH9VR9UqW66ngGQMA14pt3vw30ibC4XFT2WtfM49mX2lcTn
	8G8bfHabL25cppMZw/UYBP29zzw6ekmSsSoJ6aCH42a8xHkmnbITGEPfW8cKYnvDT
X-Received: by 2002:a05:6000:400c:b0:3eb:c276:a353 with SMTP id ffacd0b85a97d-3ecdf9b479amr1090385f8f.10.1758094736406;
        Wed, 17 Sep 2025 00:38:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG9bJWm23LysPNDyBnHVvP/fmBhJ1zuxTFboH2BF4Lnv2ayY/DGUm+xwiSt1zWCebC8DkrtCw==
X-Received: by 2002:a05:6000:400c:b0:3eb:c276:a353 with SMTP id ffacd0b85a97d-3ecdf9b479amr1090361f8f.10.1758094736053;
        Wed, 17 Sep 2025 00:38:56 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f27:6d00:7b96:afc9:83d0:5bd? (p200300d82f276d007b96afc983d005bd.dip0.t-ipconnect.de. [2003:d8:2f27:6d00:7b96:afc9:83d0:5bd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7e645d1fcsm19329609f8f.48.2025.09.17.00.38.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Sep 2025 00:38:55 -0700 (PDT)
Message-ID: <c4ba8fa6-246d-4a6d-84fd-3a14b4d0dc1b@redhat.com>
Date: Wed, 17 Sep 2025 09:38:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ksm: Use a folio inside cmp_and_merge_page()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 akpm@linux-foundation.org, xu.xin16@zte.com.cn, chengming.zhou@linux.dev,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Longlong Xia <xialonglong@kylinos.cn>
References: <20250916080533.2385624-1-xialonglong@kylinos.cn>
 <20250916181219.2400258-1-willy@infradead.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250916181219.2400258-1-willy@infradead.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 29a0mx84gvqxnRXDi9AJPt5BI8QR-VNMMofGZpwINh4_1758094736
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B53DEC0004
X-Rspamd-Server: rspam05
X-Stat-Signature: dd3awgqx7ms85andodpp5ghp13763w5s
X-Rspam-User: 
X-HE-Tag: 1758094739-607355
X-HE-Meta: U2FsdGVkX1+j44ZqfKW5T6lIgEFKsomchH7nzg1VIthZjiMFD9PUvfa4O0QSxXU2Pw6hcGPvv0zrySscIZRJEoa/LGmEdw74lSWklcrH9VlynnpMJzvgtWarOvJUxYuU1pGlrOmX3LMgQLKoLPLoMQLoYoMQfAwyl5yGcW5+PZPiGjeq2mlbvxUll52BYxvGudFEpsUOLm3FD1/Bw+DT8oVbjx8+aP2tA1elYZWncaX60Re33KlIMkBu/f3cvoO6bJE0oqJ7VzOsC2kIvlCyYUHwiVd8yfo1LX/3iVQeu/PisTLDHeBtVJuk/YwwlxlxVq8ne+/sMEFahxM0Fcmopte5LoZixO2+hYRf90jUUSQJCgCbjO1hZyZ16nRds7zDX8xXULyjSTNHT416a1P7sucSFZAarAKdmT/Vb6ZHKpah+FnMAp2FkZPzfeGqcUskUd8J05cABii49WPTR4ckUT+KOsEaInwLWZAcPd070TxD0g9uy1cqiMBu6uY+kP0iZAY/9SaniYJTfLvtYkOctNtpDgX/uQRgSGqHbBr5DbLo2pz4WIbsuByZ953weRWPoYG0a2zv5O1oiKMegvkT6T0llwM7TzXFPuyZrPjinKmCyPQT5mAFy/9Tr/YSBjI9aXiHGaFHkt+FTGPqGPtGif+PDMGw6ElU3KZHXQT/U9m/rqDJV7Am+5EMkQrslmnk63bMio+3C/3K2uF3uVJSVc56i6sNRu1kv1ipHNkRlVPBeJliuC1mV4ffOyUAXB6W9PbnM5uRE5rz1DGPUBDzTsy4mitADnw1yu3HnToGq6XnXZS9/DwQAbPzuerCk/UT79qZvr8LjuvAovIMTb6AIYmNrkxhMdBwiSARJ/QvgZnHS7Qj98+aVHpyCA4xWe8NnPFsdkJL+LwtDPhwuVh84lIwh2aW97iFVjSJ18y4i8bh1CgqFqLZKe/YvFxBHRhniukL9XAZZn6ohRPwvLm
 WWEcA4l9
 8+bkbLqzrD8hW0LXpNXhyb4xOYZNCaPfokngq0hburWxTdv0GIYURdIr7iqouDsVA+bJ0yUizeNRrP9Selu71wmn8iNvPFdcUHAQnA2Anf4hRx5AW4EaLXxUi4xlXzxuG4//pFPwvmcCSIanNWgxYYJdbg3rlzTxPoorm5OXeb19ejw9iCFP9aGmgeuY8L2BbTpn7Y5oN+6Vswb3/wXQCpuUvP+O/5r8BhSL23Dmzlk0iHEdi90mfNiiLfuBuFC9rWZdCIjYp5lBv6FlHGtFvDyL5wS6w3tjztiwMk5Nhyvjv16fvMqQ0EnL1eooTQkxzuKEIiOmcFaEYLHno2+bn2LgKV6ucojmDCGbl1DPK1t4OGcAbvf5wDnn2BAmhmzft0+4dK4yLwaX0txDe1tfjpwB8J7myCUZL0vpMtcAlEXUQdqc0hM6Chqx06Xp0+R9xcTtka/ZhnxX1Yonv1z9l8aluhtLPGaCO/sh/65hgGT6SbMjgpHU3YyowAW/mNPdyZ9crJYcjtCM2UgDn0vOtQDSIR32qz8IPMlWoyissv+j2mxo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16.09.25 20:11, Matthew Wilcox (Oracle) wrote:
> This removes the last call to page_stable_node(), so delete the
> wrapper.  It also removes a call to trylock_page() and saves a call to
> compound_head(), as well as removing a reference to folio->page.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


