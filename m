Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CDA5CCF9FE
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 12:08:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E25138E0056; Mon,  3 Nov 2025 07:08:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFCAC8E002A; Mon,  3 Nov 2025 07:08:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEC668E0056; Mon,  3 Nov 2025 07:08:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B754B8E002A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 07:08:47 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6A875160AF7
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 12:08:47 +0000 (UTC)
X-FDA: 84069174294.27.B62B0A1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id CCE861C0004
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 12:08:44 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HK096hf3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762171725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cYCA/A3pDMqDmKQxMSerZc0Sd4+MTvVdqogc8ia6KkQ=;
	b=LgUfPZKPzdXHQg3nl57NvoySweNjWxuFs03r5dbsLBgFsraX1CDuDgS0XX1QaAK98sKYpw
	58mGSlePFyXlYLug+GbBgQr9QKHxXi8uv/jJeySkXVDy4ujCJZaMRGUqYMt9FtZXSKENcJ
	NtCgb6LYrC9jCi5QcciU5cOVGzOUIvs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762171725; a=rsa-sha256;
	cv=none;
	b=Yr7uPLEYkIJFvKJoHBYr2qqSbIXFeK0KVQOZm3tQrM/EU7g/gAqheDmwXNwsWbEOGV7c/H
	Gdxjxm0xZSxvj+CuKgOenbJLeSbJTR+mAzBHkmlWRuyivyNBADUmKr1fPweidQ1LNheWBy
	OXqe81etXMidENpeF9YEoo0eokI179E=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HK096hf3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762171724;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cYCA/A3pDMqDmKQxMSerZc0Sd4+MTvVdqogc8ia6KkQ=;
	b=HK096hf3xMWDB7dlq85D1YNAutVbS7FpL2Xz3+EUVJ2Pbli1sjKvCYAb8E77VdFHcRjELr
	0tvvaox7t9GuRIbMHF2Jz6MDaCbBXf1OTOZ3gC/BoqNLDg/MTAjybgo886lhbaYzlaxVeD
	3WyZCzFsS2Ho5guN6iJXShDakP9xtS4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-52-0iz3hUAkNg-9YerKbTt3HA-1; Mon, 03 Nov 2025 07:08:42 -0500
X-MC-Unique: 0iz3hUAkNg-9YerKbTt3HA-1
X-Mimecast-MFC-AGG-ID: 0iz3hUAkNg-9YerKbTt3HA_1762171722
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-477212937eeso30825875e9.2
        for <linux-mm@kvack.org>; Mon, 03 Nov 2025 04:08:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762171721; x=1762776521;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cYCA/A3pDMqDmKQxMSerZc0Sd4+MTvVdqogc8ia6KkQ=;
        b=xRPXU8vA85dzC6V6QOAwNFJ7cfyXgJoeTXo7h68sUVwc6KHkU94zPOBbCIDwsn/w6K
         hQiAJmSpsOu2ZYY/b6uuJjwQQc4Ff/Mbyu/Ax8X5rmcP+wH2nE8eYQHlaFP0aVBnPHyx
         IKb7f0ywbmqNjc9BxjRGppDnzbC79+eLKHxF4PhdQ49IRBCqveBHIAyKCwb4r87fle2I
         6k3OOwikibxctkxNR1uVVzbsKxvpRNCPm3aPJgW6+kSkPHivbto4XDbKUvGadBpDZd4z
         9gVM+buIrWu6OBG6JDtOWBJPKWtHmHPo2MVA2C91UAFKd+iWYJVNBWlKcSkuvcGoyyZS
         NqgA==
X-Forwarded-Encrypted: i=1; AJvYcCU45+H92fHwr3YY4LT4cc11BdKNkoFwksAv4vftzbS5BoSyn0sWGna+BoVgVXzpSx2rMZQk4FrHQg==@kvack.org
X-Gm-Message-State: AOJu0YxyK9vDZrICupNlumvFb4wOQ64lsdX2hHDwyNqN2N38y7Xu1auQ
	5SsZLE4bVmyCoqNAzak3/S8konH/BaZPKlUqE5W8ridX82XikHFSAclhqnTewQ5KiWvAvEl6vkD
	StqdrabXLIQmqA4gTPSsdMQSZXVTAq+NzuL+pWGFvCmJmoty/vBf4
X-Gm-Gg: ASbGnct+Dn9JAC5nCbFZi1nYtq2mQm/me3ATeeM3MN/GmueGh/KZYKSspCdTYGKw3ju
	9G0XSf6QWkpgL2ci6C3hl0qLGWuTtH27VaMjTtTt1yY9gvZwxPKAffDAB8bvWpcd6oeKXN3DrtY
	w85gq3GUGZP8pJzveBF3GdRd4oYraUa42qLBZEyqb+1fE901BK+Lemrco35wqfD5ePlCsdcy2ws
	BYlTnIQKoWyU0UhQwGsngAr5Yw1fG3EUEsJHBkR6WM1LB1lKLtJei7NEpgHZHtc+/4xh/eYbm2P
	+Msdsyc9vir9l9e7eO9sUe07nmTSLYWC1JGShYgKIfjuk2sW+TTKBeEIsmLWzP30x9u6G/x05E1
	2xGGqOo0aN3k+hDpncgqEYUz9UVE4o1wJVfM1kiEpazrn92zA+sNszgVmNKy696ctcuQTIh4U3q
	RW6pIg9LR6DsNu7+TZepktqG1XXZw=
X-Received: by 2002:a05:6000:250a:b0:429:d0ba:f002 with SMTP id ffacd0b85a97d-429d0baf1cemr3808951f8f.51.1762171721576;
        Mon, 03 Nov 2025 04:08:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFORN35rwn/ZHqlzoFuluITkWiBVqUu+wEC5M9/kjlhkeFWf7xzY34hBJFVBj9s+pvDlX+lHQ==
X-Received: by 2002:a05:6000:250a:b0:429:d0ba:f002 with SMTP id ffacd0b85a97d-429d0baf1cemr3808909f8f.51.1762171721096;
        Mon, 03 Nov 2025 04:08:41 -0800 (PST)
Received: from ?IPV6:2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169? (p200300d82f3f4b00ee138c225cc5d169.dip0.t-ipconnect.de. [2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429d1a77614sm7726647f8f.21.2025.11.03.04.08.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Nov 2025 04:08:40 -0800 (PST)
Message-ID: <5ace86cc-0b2d-4306-8bc1-dfc34cccef1a@redhat.com>
Date: Mon, 3 Nov 2025 13:08:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] x86/mm: support memory-failure on 32-bits with
 SPARSEMEM
To: Xie Yuanbin <xieyuanbin1@huawei.com>, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, linmiaohe@huawei.com, nao.horiguchi@gmail.com,
 luto@kernel.org, peterz@infradead.org, tony.luck@intel.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-edac@vger.kernel.org, will@kernel.org, liaohua4@huawei.com,
 lilinjie8@huawei.com
References: <20251103033536.52234-1-xieyuanbin1@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251103033536.52234-1-xieyuanbin1@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bZ2pU2QAYZ1xhPeEyrGwk-CkkfA4BjRy0mJbqYeD5ug_1762171722
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CCE861C0004
X-Rspamd-Server: rspam02
X-Stat-Signature: i41yrmqf5kh6i6pfaexxusbwz7468whp
X-HE-Tag: 1762171724-689229
X-HE-Meta: U2FsdGVkX1/9Jt1ufETu/qDy2iS3o9JsIURaMau+s2Lkdt7zDaXsRq+dRh8AgemvRBLbJVevvY8HwQFe9IBC9bghwW4zYC2TBOBXv60bTbahHi93ihSRQ7DPXZesJtle7R1IwnNudUE7OKS0nF8clkTBa+Ri/NyJ8BD7LEKoqZ8rHDXNmaBsFKwkZLhnVQexXzwZmo5r+mfnpGuoMF5H4zDrjLIHKExiw1qPy+IoJmCBzVMiYrwn1jNcSnS53f/mXl9AUtTKGk8my7QkiE+7mKsx3Gygt1W+iyn4K+ZGuqBqt8vA1aqeLIOH5IGNhZjA7n7A5p2+iT6udN0A/mC+bse2YMnykRcAye8d9buwTDDt5TwyNWHKdt1H/E3VqbOBz1mXeQkHKxjb8Np07OFg0/O/CwrBPn5J9jp4Yb5RFBzo+GSkjgftpaYagodFJLkY1ckndDx/4bwVrgIN+lVeUWdlLud613Q+wUgQeiZVQ6PQiopMWbYDB118jXl7vxx5frOQ+U4C4lyZ+bXskGzEcPKAoXRnN1bkRrKpMznwg3qlYW8PeLHibOXmMNiX+Ikf/l+gU1pLImtHeg2fWglWjTvOSwh+bH7FJFYcnd/X0P/4dtER3h/T6pBM1xLL0DZDv1AYjp/Lk6B7ScO+0rV5ls35zq00fkZLYqmnWvnamfu+sFveXBDMQxXLIA+0ygCM76Akwn9lgdy8aK87qIZJlOMm1x2QRBXOBbjGNWpRw45q1O6ue/VV1KRpODL+J6WJCf0wfbS9UZMWUPAnWDNRZVvMCthMqOLXY6tFe54E4eTdkjrikv6wc2igFI+RKyi+QpK2nqh8PZaI+iLpfY0z5T4ORzYfCOL5j3JOMm/ur97qqFPC6RfOxE4uN1exbVmRlwJPRCELaUlkNvejcBreWy4vBcrOIiVtWOji5ww50Ht24iwku+UxX1FixvtySr+cjN8qLntSJhFQrCOVP84
 WmFoPchr
 FFwTxV/V8kN4WdAE0z6UjvFni3DUl6vmdxWeYZTQqv7gOKWhgb0or1VbhO1ULLgruL0uvgSL01+1ceduzuOVpS2RobvCA0U/lT/Er1YZQGA9izOH857r/E5bfLFhEDsZhjwfbm2XJeeW8+uiWmtZ98joQH05dzY84yKUelmjJ5urolHKrCQhcAeZrfJ+U/arC7kysj8PIaDyL83dIL6zkEZWfYPUFFGSVS8tAtIFQWVp4bBVlBlPSdGHCv4+99S0SpQN0fEfKPgGvPajgE3w7zQlor6yNURjkMYXlxWyHPV2CVjqyzQXetqB59VtxZGW8OE9urlQm8RoLkHfMReAkE1Qf4lHf8oUnpsm3nLlhLCBu7CZcqh4WnxIZvTCrlCc+9sOOYKHGP8P5uyOQDP+btdd0DT08IXOJAm5HZKwyeY9Oa57VIGMT4YalZ/tsqAJ94WOkNaTQ8LYhFFCJzd8pMrGYXqb0m36gLezyfOT9uYgHJEf6H2R6af2Tjw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03.11.25 04:35, Xie Yuanbin wrote:
> The historical commit d949f36f1865c60239d4 ("x86: Fix hwpoison code
> related build failure on 32-bit NUMAQ"), disabled x86_32's
> memory-failure when SPARSEMEM is enabled, because the number of
> page-flags are insufficient.
> 
> The commit 09022bc196d23484a7a5 ("mm: remove PG_error") removes a
> page flag, so memory-failure can now be enable now.

In the meantime, we added PG_dropbehind

-- 
Cheers

David / dhildenb


