Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44BEDCA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 09:13:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C0FE8E000F; Fri,  5 Sep 2025 05:13:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 799318E0001; Fri,  5 Sep 2025 05:13:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 688308E000F; Fri,  5 Sep 2025 05:13:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 502198E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 05:13:05 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0F805868EB
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:13:05 +0000 (UTC)
X-FDA: 83854632330.11.CA7F80F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id AADA01C0003
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:13:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UooSh1Kc;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757063582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QVvTdDDvCrzh90dm3ynP6FAoOKdgvK85lFiJLYQoTss=;
	b=2yULWYOItE40n4lT7qxFCR8fe5z5j29PnELgHZ+ei1mrM0TqmwKh/xyzlxUIX1Od0q7t68
	9TOjcV6wv8MA1OgwEiTjP6blw88yVuYXZxABIRo0mhD4YuxSmK2OPA70zlgz/NVvEzwiYT
	ZKMhQt/WPuRLP+EJ0JONg3VRv5BiCx4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UooSh1Kc;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757063582; a=rsa-sha256;
	cv=none;
	b=tJQTFZo26XeUmDKVchV57NUk872uenf2ThSLrQZP/RF99QdZL30fPX1BBRTGSR+WnW/fnA
	t9am2/78GBboA7uOUhnMZYRL48BlACg4f75W375eH1A88r7IJ1TrisSxod5JfbRSaPlJgG
	Z8QJ/fQYPvEXEajem8UGuBAoNTsJ25o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757063582;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=QVvTdDDvCrzh90dm3ynP6FAoOKdgvK85lFiJLYQoTss=;
	b=UooSh1KcILmHET49+Frrbfuzd9m9znX1EmJw/+3Fj64i7XtcUtf/QbDjBekb6+rIv9ywD6
	GC0B8yqHXIk7f92lpM+KHOlBT5j/XOaAKUbdR/g/funHF+6KTJaqD9CYSOW+oR/iR366qI
	UYH6XzmPgkoFxx/VDbWbj54JKc42TeE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-613-JOm-xVEjP4CqJs7B2sFs2w-1; Fri, 05 Sep 2025 05:13:00 -0400
X-MC-Unique: JOm-xVEjP4CqJs7B2sFs2w-1
X-Mimecast-MFC-AGG-ID: JOm-xVEjP4CqJs7B2sFs2w_1757063579
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3da4c617a95so1910733f8f.0
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 02:13:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757063579; x=1757668379;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QVvTdDDvCrzh90dm3ynP6FAoOKdgvK85lFiJLYQoTss=;
        b=KwlqgakO3EpP42iAoMe4DtHP7syYPab8NXP3zHit7KahWXp+kQwpDtP3sJc3NYT0f1
         pNbvsIiZTihE4STFHG3uM3xOtdlhXPPWKCb/IT7TDXzXJv8yYol3qj3+qRF4dAP1p5xw
         VYiGVoz3kafdFtIvJMcULb/M/C/Gchggwz9qLEwL+K68pqr/YqRZt6CidX+VL/hkuek2
         roO3tn5N/dZczUnmSi8+kdK9ZYsi8/Z9VrFYtJ6eelzQJGqavtzwIeANu5hJH5KKMQ9c
         BqloJqKmwITJplYY/XfkqaeKuYzYxieAZmrHwaIVTV5fjk5SotI0PxoLbGiK5lq/EhjG
         zI6w==
X-Forwarded-Encrypted: i=1; AJvYcCU5YDbNU7txEtqzyEjvhknXetE5C01FTMo38zXacP4AXBm2miPhaxDVlfEmkTuajyybPJe2WK+DjA==@kvack.org
X-Gm-Message-State: AOJu0YxbkpuBW9bN5gIZSpvUn/wzr4PDuGG8LYPz9h3YrBxBbBROP73s
	Yr8hou9Ckl90kd3zPWW5DhY41DwSKoZbp0sPNmecAfWXJhxmVE1zKcdat2nrlsOYTJen4lxuqAp
	1EVTX6XbUfTZgMni0Tv53L6ZYR41hyT3W5ornVS8lMbvA/knDWNlD
X-Gm-Gg: ASbGncvM6PeuQGWU/z3Roz2SKZY2kJa6xzW0AZTt7FrNKYrpHQ1xFpp8zFzqVsqJ5Q8
	V68rcILRWEqO04d3GKIsGrINqTEnsDSQ/YS3Ts+IRMsoStaqu3hTzwlRxZUowWx2RJ+2iGN6BDK
	LWsMsYBgeyCHrok+8dL0CKFmJWe5DbtUUxC0EbNo3EwE9cSzv2/ZCLTuvvz2XlufWNBfFu0YVKK
	cJae7/bpIg4OHvMbvGGng8YubE/A/gs+7Xz9MvN23pg2CQypvsdhVtBoLmZ9y0CCszSRnXuTanO
	YHMEfjGQstvUy7meRhxKtDMDZDDGYzsJS6g5C2vJfOkkM7djRwKtTBw+IQuiK9bwkiLj2H+1ory
	323yT9pTCqwGMnjp+65ETQ5OSFV/gKAxZ1julXXkloIQ4ShV1c2tQyakl
X-Received: by 2002:a05:6000:400e:b0:3ca:a70d:5710 with SMTP id ffacd0b85a97d-3d1dfc07359mr16418655f8f.41.1757063579499;
        Fri, 05 Sep 2025 02:12:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHwFJy7qhgjRNCRj3exLbKYmipQkpcRWo8U390ZzooMqsl81hg/STCVqaAiOJLTltnhZ93cNQ==
X-Received: by 2002:a05:6000:400e:b0:3ca:a70d:5710 with SMTP id ffacd0b85a97d-3d1dfc07359mr16418622f8f.41.1757063579054;
        Fri, 05 Sep 2025 02:12:59 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4d:e00:298:59cc:2514:52? (p200300d82f4d0e00029859cc25140052.dip0.t-ipconnect.de. [2003:d8:2f4d:e00:298:59cc:2514:52])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf34493b8csm30046369f8f.59.2025.09.05.02.12.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 02:12:58 -0700 (PDT)
Message-ID: <3ed39039-e20b-49b4-a589-665d55105f00@redhat.com>
Date: Fri, 5 Sep 2025 11:12:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] huge_memory: return -EINVAL in folio split functions
 when THP is disabled
To: Pankaj Raghav <kernel@pankajraghav.com>,
 Kiryl Shutsemau <kirill@shutemov.name>
Cc: Zi Yan <ziy@nvidia.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Nico Pache <npache@redhat.com>,
 Dev Jain <dev.jain@arm.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 linux-kernel@vger.kernel.org, willy@infradead.org, linux-mm@kvack.org,
 mcgrof@kernel.org, gost.dev@samsung.com, Pankaj Raghav <p.raghav@samsung.com>
References: <20250904095129.222316-1-kernel@pankajraghav.com>
 <2psecfvsd4lbgcm6aflifi2kc6gof345txsvk7wtsytre5ehqt@4wyru36aaeel>
 <e8d5eafe-db58-4b78-b029-de6a59fc4fd7@pankajraghav.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <e8d5eafe-db58-4b78-b029-de6a59fc4fd7@pankajraghav.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rPLFFcBRRYNQD7ZDetSYFHMSpf5Ll8s3QH4s7Rki1c8_1757063579
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: nfierq86xgz9odxarjs8fz8kbsymxd7r
X-Rspam-User: 
X-Rspamd-Queue-Id: AADA01C0003
X-Rspamd-Server: rspam05
X-HE-Tag: 1757063582-509879
X-HE-Meta: U2FsdGVkX1/u+t+TPxVE8rk3NT1clthx8n/LeRBHnQncHSM3H+b7wfQkirL+bk/ecp3vPp+ccLhGqa0dybyNcP0IznkI5zTM0LjAFQHcwKswIdUrTbjK4qFyajsnD21msxl9QptEc1Me7Q2HjErOBJnqERrA6Pp/B9eXFtgUGcuQIqbnE1B+ziwp6qB7QwOeg2xfAwJK7oBxAy9TQKDFnE+RSn/JasnfAHQCZV2nJznCSFYWAu2l1Oy4r/rS6OGdcZc3kzi542ESREnHls0zbdD4752wCyEjPBM+rxCv1W4spbyhoPdSz7m/QJV73Y1/V51Ares8+WhKuRFKZAkRbLThB1suPMB/KgyOaHxyIAx0xNKOybpVwzlcC8US6CnwIduDvj6IPdDpoSU1+egRAbEIESpElNnWFXNNaMQx89a3VK1FVof8fp6oP6vtQjXtYWBkNRI2uMHuWTlDlC+8miTJJY6IIXJnbuN7TvP2u3zoVdUAIIN2tS1KnR6oPwdRdqshrF/+DJvwmRgKXZJ3NH6ZRcZckpbhlLPDaCAAM5chct8V/z6YKDOVApivi7hr7uwtM28SBo5p54ie8XHbqbSYl7k6ORNZEb9VfPQRPbkwnWsGubKSdSvbl/ch2C/0BgA2hjDdDmC+qlwE/LVjODqFlq7odbMQcK/HEjThQONdznLHzsUM8GVtUX22quh1BQkB2Wg9wgz1IkshcGYjyJZ+a6zS0lEXBnvxj8EUahXeulri+S6azqAilHVhDD3OEkksNemg93UUTlrPQDdPt+kxk4gHaFv32wjXsfW5iUrIQD9Wzn17lEwb0fzbHuFZmk4vRVGF4qmbjO/jiVzTxZCIZdEkE8OwOYZu/xGDjGnNyi4Lhl13DMcIydTETGPBQchYusMjzV6VlyUY1ZjjFkCIBK586bKUuR7HSCr4eGtpREnl91rElM1snWeQrE20rOTf8T4gK79ZTFb+IRT
 jhVL/d69
 jJuMI6nfBusie+o1SacvYQkXWFTau900a7Iz2gK9duPMqtvClD9WiL7DhdJofGv3nTGol6t8H91QTPxWTOXvEqmvTNShPemwF0acbRTZ8JsEizlRYoB+TXw1MrApYHmTYM+d2wA/g/PIhRGMH7Rkz1DmkpUCvlxJG4DWPt0OPTvdxrcFXt101IHh8qa3QOAWD7WJQlZA5S+LIiLAj6zQdvry1MN3m8BfBOK9dLCwYp0mo/XjY6dA5ggGqcR1jiUVvVWKQHwi2EGOLYgO6dZJSDSRWAWzhVaPGDf5Vtn7Zch0FBMHgei5BNlhhlQImyAtcN52JxcQtlC6oLwgnpQ7se4R0ooJ9gl7CWSZDYeuDq80XHW1YQwm8k/coJpCBRNWs1s89yBm62qMScsngf9E2/parEGsQG+CaUxwx0bL0ksHNybnNmRKbb36+PPfU29Bqsmv/ZRF7IFDAEdYcpT0e+asL7MYmSosIr32SsiEpFrj/4T6mjMv/4V2QZoKOgJnGgbG9yijOqNEo2Xs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.09.25 10:13, Pankaj Raghav wrote:
> On 9/4/25 17:26, Kiryl Shutsemau wrote:
>> On Thu, Sep 04, 2025 at 11:51:29AM +0200, Pankaj Raghav (Samsung) wrote:
>>> From: Pankaj Raghav <p.raghav@samsung.com>
>>>
>>> split_huge_page_to_list_[to_order](), split_huge_page() and
>>> try_folio_split() return 0 on success and error codes on failure.
>>>
>>> When THP is disabled, these functions return 0 indicating success even
>>> though an error code should be returned as it is not possible to split a
>>> folio when THP is disabled.
>>>
>>> Make all these functions return -EINVAL to indicate failure instead of
>>> 0. As large folios depend on CONFIG_THP, issue warning as this function
>>> should not be called without a large folio.
>>>
>>> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
>>
>> Acked-by: Kiryl Shutsemau <kas@kernel.org>
>>
>> Just curious, did you give BUILD_BUG() a try?
>>
> 
> Yes, I tried BUILD_BUG() but it actually fails the build because truncate_inode_partial_folio()
> calls try_folio_split().
> 
> It won't be called in runtime because there is a check for large folios before we call this
> function. So a runtime warning is better in this case.

Right, folio_test_large() is not compiled out.

-- 
Cheers

David / dhildenb


