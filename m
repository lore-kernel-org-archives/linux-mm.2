Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDB0ACCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 07:57:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30D9F8E0015; Tue, 21 Oct 2025 03:57:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BDFD8E0002; Tue, 21 Oct 2025 03:57:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 186028E0015; Tue, 21 Oct 2025 03:57:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 02F058E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 03:57:17 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9F9CB1403B0
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:57:16 +0000 (UTC)
X-FDA: 84021366072.09.3F759A4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 26AC940007
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:57:13 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ayr+HPDm;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761033434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fUep2F5lenxxRi6fdUvVCk4rNKrfMBfN9N3PQW5oVLs=;
	b=L6i1/SvbJ6euqCdKWkUQoSObEgrtWjUQMPGOgpSq+UJPcD0+FwLKl1lGekI2buEOLlRTfZ
	vOw/IzVoj3eyJf5lk188H0hKfLTDWnH0pLeSRitbIbDQ0wiEdr2l//WhO2tTfbQWP97ZTy
	RCiL6K5bHMWwxlkb3EuTUUnbCStuzCk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761033434; a=rsa-sha256;
	cv=none;
	b=L0Oiump8IAkB6hO6WyeH7aioK6tTZswVDcg4JykG2Xh5qeqtQIZBIeQ1ElOR2xe6g20VW3
	8MNk/ixT8HAaZvPsd2e+qFJI0yjNgoS+iZ8jEd1whdTbhrpyyR2MdNqfbhLtrjL5+MpEnD
	3VaFYbxnDyESN25YqVbgianh/kHo73Q=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ayr+HPDm;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761033433;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fUep2F5lenxxRi6fdUvVCk4rNKrfMBfN9N3PQW5oVLs=;
	b=Ayr+HPDmgDXCXU6zQzqozqZBbKq/HGxQA84Wl0T+TergI4cV/IeSmCe2jrR2xUUE34A8oq
	a7PmXeku6w8lFGbpUA0prhmlMf5qlHaQYP+CZ+GKZBryGEkdMLAC7YYWFo94ZZhgHSEWj5
	vjZk6NeAASHH9aR1wp4fkNdEnshdTjA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-693-gYK7ZIHAO-yw_CAJQw897Q-1; Tue, 21 Oct 2025 03:57:12 -0400
X-MC-Unique: gYK7ZIHAO-yw_CAJQw897Q-1
X-Mimecast-MFC-AGG-ID: gYK7ZIHAO-yw_CAJQw897Q_1761033431
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-427015f63faso2715264f8f.0
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 00:57:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761033431; x=1761638231;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fUep2F5lenxxRi6fdUvVCk4rNKrfMBfN9N3PQW5oVLs=;
        b=Hmoz/I2Ldg/He+yXeV9wOzQfLCkaXqMnqEYZZKupg3+J0X9OI5bMBcoDjIzi6oH801
         T3V1IwDuXUEfs6k78Zq+v/TALpn1SkOoJNz30bKOX7QjdskES/9PxHZedZZO2kweI57b
         7vsR6+45SR9CmsgQ6cYmLK2+zm+d/1RJImjI6deR4JfEGBl7HUL3r84mX/6xfGxrkEVQ
         p6t6dxCMGNtSK2cIKrrmAli8KNx30mfULaVce/MOSeIy0X8ja2xBEBo45l/NCpe1XRa0
         TZMwHC+Qw+r39VfaEThqF5gaziC5lOL70yHpf08YxThO79bHsI2J6acPfFm1u/DbBZTv
         2fTA==
X-Forwarded-Encrypted: i=1; AJvYcCV7PUO9tIpR3lBaCJqZGB+Lk8N7ErpuW2TmsF7FPy/TBzTS9QQhJE3j691IYTcdrSE3SGAqDZURtA==@kvack.org
X-Gm-Message-State: AOJu0Ywugey7FOPE4/I7XhEIn6tiT9QMXzGOXGNUzvSVzslHBZK2CQtG
	CbhzPf8Tib3MTzT7TpAIAVJmmN7o4pOIrq49+M7RnOGoMmFHFEtSK6K9LnmlwQtekQBC+M8ejD5
	NJchnEuEMkHcmSGiMRkApTqEhsuU9Y9IOhTsBaUUYR0K2jT4cHPAm
X-Gm-Gg: ASbGncsP1AisxWd8BDPfRbYGs+1DpHCATi541vfyQst8LqM25OlHJfDeuwCnISDGUkz
	iXq/MTfBFNmm/44gGyqZylSZtoB/QzPepw/QooKbNI6o2mMaWEUlCkyTdwRfVjL1myPHDe4GOAG
	2403zGdzzOh44n/01jE9wi9ryhVn6OIsBa18ybcEQEFe229OeQyCQKdAn1J4DdV34DnXtAyt6C4
	qzcNKfLdjyyJYw3qv4Q80BW2hZ1NcJ58SdGftfsBVrCcuaqaLngkpNvOZTCiNDscLf1gf7KYigd
	dtjcI+TnuiYi0El1OoMbhxPCSGWDRSvzkyRevA/IXtTVyjNgP+CGexUvqWGxfzrr2CrNxaToTSk
	9mHls8usV+Rlf2/d2MQwRkz0VnfXerlE5sjiRloS2G035SP1DF/Zs9cIRhnOQRv6DpKJSnfIfeB
	5PXxdhmDuCfXm3myuHw0jQo3gQhMw=
X-Received: by 2002:a05:6000:2507:b0:414:6fe6:8fa1 with SMTP id ffacd0b85a97d-42704d95645mr11202336f8f.38.1761033430879;
        Tue, 21 Oct 2025 00:57:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGBqz1uZsEY1jCmnK5iipnnYUKFUGDAKuTU7UXJ/g7OrVHjIjgtlWv7fVh/TELjD+hkmZZH6Q==
X-Received: by 2002:a05:6000:2507:b0:414:6fe6:8fa1 with SMTP id ffacd0b85a97d-42704d95645mr11202325f8f.38.1761033430520;
        Tue, 21 Oct 2025 00:57:10 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427ea5a0f7dsm18728294f8f.4.2025.10.21.00.57.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 00:57:10 -0700 (PDT)
Message-ID: <32a9b501-742d-4954-9207-bb7d0c08fccb@redhat.com>
Date: Tue, 21 Oct 2025 09:57:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: O_DIRECT vs BLK_FEAT_STABLE_WRITES, was Re: [PATCH] btrfs: never
 trust the bio from direct IO
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>,
 Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, djwong@kernel.org,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-mm@kvack.org, martin.petersen@oracle.com,
 jack@suse.com
References: <1ee861df6fbd8bf45ab42154f429a31819294352.1760951886.git.wqu@suse.com>
 <aPYIS5rDfXhNNDHP@infradead.org>
 <56o3re2wspflt32t6mrfg66dec4hneuixheroax2lmo2ilcgay@zehhm5yaupav>
 <aPYgm3ey4eiFB4_o@infradead.org>
 <mciqzktudhier5d2wvjmh4odwqdszvbtcixbthiuuwrufrw3cj@5s2ffnffu4gc>
 <aPZOO3dFv61blHBz@casper.infradead.org>
 <xc2orfhavfqaxrmxtsbf4kepglfujjodvhfzhzfawwaxlyrhlb@gammchkzoh2m>
 <5bd1d360-bee0-4fa2-80c8-476519e98b00@redhat.com>
 <aPc7HVRJYXA1hT8h@infradead.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aPc7HVRJYXA1hT8h@infradead.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _5UBEVlqtdMPop7XyqPCSO9EMZjGT8n2jlQOtnSogiA_1761033431
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: s9d5mhkrosi9mkcp3ngzoa8aqwh8zz7i
X-Rspam-User: 
X-Rspamd-Queue-Id: 26AC940007
X-HE-Tag: 1761033433-499347
X-HE-Meta: U2FsdGVkX19dzbLZCAkzmneYoOlS60sTiYTi9Y4pXWZkmTnj1bSsVxT1/PuMA8VKL31/A0CZv985KSB9gMqoa2/HAcOYI5NbBMP/ElNYpXFrQCqdytzxybi/zpkY9j+CnuwLNSZVpQrFMAUA94tVPi12cr1hC5UCkOw0OjY+MyNRZBoDdBnA5Ne7mZzPdAJvXu8Z/OlJvGS/ZiVATQsKu3PDxJZEwJgGbzoHVODzENIDRfAL6TDYmRQDDhB2EvvaX2auGFeWTsq0bjG0xiuSRrV0tj7PyWdfFozLTQAP6uNoY3KUfW3WZgmLRyGEY3hojhsz/jsEvWvkmj6NDKEHCOeEpCUVsGM9eDhg6Lp+G32JP3fhca3zRiRL7WCaWxrJ6Btca33XcvC7d3DfVfvTDz/hiNBrWqNu7u+kgej+o5KP7Lwsj8L7AuMByh78IlC1Cm3BNwTJbr2xeA9TiY5j07M851e+RQ5bWLCGvDq1qRJqDzUHd57UYIaaGnXERpdX4riBsnyW4jH+7eUeRzVrjltcdojADuOFdJNmpC+qU10wyIYVQm8tJr7PKzpXzj2RUzF75VnN85vDHVYITUR4gwX1hi8WQYCHRmKbBjKT0ZRfi+oAepJDFY1DpUmFLGly6wMf+vbjqwDZ1/AUv8ug0JLKovMDFt1q14DMSlzze5T2oTJ8dJXRd3000KDGm1kINuulrww5M4ThVAD1mjW/M904IGgRdAn88mI7bE3yfIydfuym/eD11FZqIVZbzVCErqjka7uFBku9gbehmVjTBbgF/r71uc0lzRjz8bi5rm5LLH+wNv9yarwHQV5O3LUzEFnGGE88Ev2udPsFVKjdAlmTo3BjtisoX14CIACAyvODEdGe6QzJNxj9olBq1WEqAqEwc8TKfueG+3UT8IJWKDtNwU2i0AXZTXuFB2q0s8QwSN5ie7BTI3oN786ngppyuhEG1F5YrOoGd2S4MsE
 BcAkQzc0
 Pz1+yRcfGixcGPvrsR/LWjBU7ccVmaq/D0kKDqV5UMWTZeHOzpg05/z9Q8B1aFjEovYvOjGCZ2Y6OlFmGnt032PoIoa3p6317SRIxf6HYioOuFoHvQa1t5S27dw/yELIxgd7//KqG+cHG7bQgnb55TVe1IlzzflyZoTTcF1FEa+LC/2SLWOJLNXyIugVPwRO+glQH/5mzyU00o4aRAKMxrhjGde/Z5QLkJpJ372cE/fyjlHYb+zvrL0Jx/AtKDl+m7PoaKPDX7KeDHZdcByIV8u5eQn1daRAE1z6AfZgzbR6GAkQ8gsGCrk/6gS7y2x3VeE+P/QFTobpleAzk/HBGlkFY7E9ozX+WELD98ghoknj2M6E50yxsdsqXmUgyxIvHOa6S4d5NspK7FMjYXVDFSPYIeXT/ox8YSw5+XoBAjeM9tEtOxXkw1f0yS9Nd+5fqa5czqSQw4hj2PghxGdNrlKi+BvfOJP+KICuN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21.10.25 09:49, Christoph Hellwig wrote:
> On Mon, Oct 20, 2025 at 09:00:50PM +0200, David Hildenbrand wrote:
>> Just FYI, because it might be interesting in this context.
>>
>> For anonymous memory we have this working by only writing the folio out if
>> it is completely unmapped and there are no unexpected folio references/pins
>> (see pageout()), and only allowing to write to such a folio ("reuse") if
>> SWP_STABLE_WRITES is not set (see do_swap_page()).
>>
>> So once we start writeback the folio has no writable page table mappings
>> (unmapped) and no GUP pins. Consequently, when trying to write to it we can
>> just fallback to creating a page copy without causing trouble with GUP pins.
> 
> Yeah.  But anonymous is the easy case, the pain is direct I/O to file
> mappings.  Mapping the right answer is to just fail pinning them and fall
> back to (dontcache) buffered I/O.

Right, I think the rules could likely be

a) Don't start writeback to such devices if there may be GUP pins (o 
writeble PTEs)

b) Don't allow FOLL_WRITE GUP pins if there is writeback to such a device

Regarding b), I would have thought that GUP would find the PTE to not be 
writable and consequently trigger a page fault first to make it 
writable? And I'd have thought that we cannot make such a PTE writable 
while there is writeback to such a device going on (otherwise the CPU 
could just cause trouble).

-- 
Cheers

David / dhildenb


