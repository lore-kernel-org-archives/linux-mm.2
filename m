Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D61EECA100C
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 09:39:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D20B6B0005; Wed,  3 Sep 2025 05:39:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 282F18E0003; Wed,  3 Sep 2025 05:39:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 123E58E0001; Wed,  3 Sep 2025 05:39:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0011B6B0005
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 05:38:59 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9AFE413B246
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:38:59 +0000 (UTC)
X-FDA: 83847439998.06.E35DC7F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 46C5240002
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:38:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MNnnhWUM;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756892337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+7IELifXVtOgh8jBkcKlpBaM2M+qDATOGCIwNfd79/g=;
	b=HiYeiwLjg7IPCJsjr4FsxHJ1+WQr4R25JqlxEC+QYNYVxVXtW1CzEzJuQhcc5pL7NBHIq2
	zcK27bGCGBjHMO8F2zqh7it4qohjfQaa2J1NnSfBDwr1molBF7WPbbtNzuZOj0d45cZ00J
	U1NutS9CLddpkbri28rfJcATPrqGPBE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MNnnhWUM;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756892337; a=rsa-sha256;
	cv=none;
	b=WcGLjTdYOOpX8nwJB4SKBrRboTt0mOUuAYZSabie4qO3sqrFa0aLFKHURjmVHm/qmhIzBy
	n4NQRmXLQWmVpQ1uBgygExh4QD9IF+MBQojb2HCPS2kUMEXRCXHRjtpjJHneN6KBHf5KiL
	liTVZy00sdCCIiAZT40uZvPPdxMJQ+8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756892336;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+7IELifXVtOgh8jBkcKlpBaM2M+qDATOGCIwNfd79/g=;
	b=MNnnhWUMQoWRAhqTeWTpo6jNRjsZqDx3H8kHY/Ih4rSYzwDD4A6Gzw5bIXyZU6bBR1qPX5
	+Tkp9i7vK4l92ov+qYd8fXjEM99TPng3fzDPCUBp2opL2kIKkjQX9waxVEoguTUw16DttA
	lNJCHPTn8atcSsvAj5Wd6yD2U5YFPMg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-106-PqM9H7mcOgGCw3W71J0IKw-1; Wed, 03 Sep 2025 05:38:55 -0400
X-MC-Unique: PqM9H7mcOgGCw3W71J0IKw-1
X-Mimecast-MFC-AGG-ID: PqM9H7mcOgGCw3W71J0IKw_1756892334
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45b869d3572so16837485e9.1
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 02:38:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756892334; x=1757497134;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+7IELifXVtOgh8jBkcKlpBaM2M+qDATOGCIwNfd79/g=;
        b=o6/u6LEufQlnlD4rsSXMNwxzkQN7ZNjqvfe1PEYhitKBbzyK3ugkPUF9as0kTt16d1
         KwxVo8XyLvNCc1TBQF7ldJu5QU9FWrIYbnV4RZ+g1HbiuHOXN86KYUfyhsQ48CWCNtbS
         TlfN7KbhGt/OXjq1RQpRDbL6G/YyGVmz9v5ZbEqyN0Ieha8istaI316bZZYiqRZ9fgZS
         0UioFiuYZWPMxiXzzmsg4qyMbRNyXR/OCHJELN37VBFfqZoPe34SYuVPm9soP3R9Nv0L
         3l9N5valXvljth1VcQYrTGCLFjEj9W/EM7obsnN72HsEDKpm4Njih7UIkYHdWlEGYZWY
         3ypQ==
X-Gm-Message-State: AOJu0YzgSaYRH5OXYyGw14TCu1q662mCKhw+FU22QfsJ1g/kyC1C/EgT
	T+T7gCerp+neYlk9NWjeFtNDsPxsmjbALMO0ikcLsMmrmY1WTskx89W/uub/tB2ruJQsRAGZDSz
	Fb0C0UeYXIHGgC3YMcI5x78hqatyA8VjeY6GtjPsvB9IF44WEbz0X
X-Gm-Gg: ASbGncs52zac9jrc9hT0C6iz0GLL135QYt4t04T/kiIcUwZ+Po9NH0fBM8YkSee8Q6F
	HoqD92UvkVpLLesT2pI/yviuxMYd2NQTZdedG0PFi5hkwx2om0DfWx2dyEoWZJScMKAkO0CZfAR
	0Bl4UynNM6ZQln4JsE3vqbA5RSoAY4fdq27uSCg4VTMvaj+08LUDJOIhhTsSC/Frw3fkTDqAErO
	bEB+5ZVQSrzdkbHDK5iCquvoysyqEm2BKstQXbRkHJOD3qnOw1aoS2DwPkwxX4kuAv28SrurozW
	jy7upsqXrNppICm2X5swQpjH73Z27wlhS0vpsDdWeD9Um5wjz/B4x5tl9kaRGtnNcNGUpmv40jq
	h6k4CyqwWiWJQXtYSF9NRhl8PSZfpNCdgdQotS5KI/JgET5GKNWAC+SfelV0AL7uk8JI=
X-Received: by 2002:a05:600c:47c7:b0:45c:b6e4:f947 with SMTP id 5b1f17b1804b1-45cb6e4fc46mr4703735e9.17.1756892333893;
        Wed, 03 Sep 2025 02:38:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFn5yt15/ZSYYF65FNuI3su0j3CtmzKDCCsa6n2y7TZ8GyRf3qj/SC9zfLd4W1Y8gvhNY5u8Q==
X-Received: by 2002:a05:600c:47c7:b0:45c:b6e4:f947 with SMTP id 5b1f17b1804b1-45cb6e4fc46mr4703555e9.17.1756892333504;
        Wed, 03 Sep 2025 02:38:53 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f09:9c00:8173:2a94:640d:dd31? (p200300d82f099c0081732a94640ddd31.dip0.t-ipconnect.de. [2003:d8:2f09:9c00:8173:2a94:640d:dd31])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f0c6b99sm314145815e9.4.2025.09.03.02.38.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 02:38:52 -0700 (PDT)
Message-ID: <b3343977-a4cb-4f9a-85c1-9ddf654c7569@redhat.com>
Date: Wed, 3 Sep 2025 11:38:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Where to put page->memdesc initially
To: Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@nvidia.com>
Cc: linux-mm@kvack.org
References: <aLc_nckaDc2ePRv7@casper.infradead.org>
 <bfd5161e-c76e-4a0e-bc1a-bf7510868827@redhat.com>
 <aLdcPeb8zrfDwd2p@casper.infradead.org> <20250902211514.GQ186519@nvidia.com>
 <aLd8l8v_DL75NU43@casper.infradead.org> <20250902235740.GD470103@nvidia.com>
 <aLfIEKLqpe_xB7mW@casper.infradead.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aLfIEKLqpe_xB7mW@casper.infradead.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7huhhJjlz5KIBr5k9Kg4DBhvpXeT5Gs15Neit5_qDrc_1756892334
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 46C5240002
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: jkdfyfb8di183phfsjy5g1ua9r5nxxkb
X-HE-Tag: 1756892337-987767
X-HE-Meta: U2FsdGVkX18EsqYwiM0PJaHnVhewLaEjbgBCeeKCNY57gwzrDNw3nyQQSde3UXyvXTaqWU2TPgWWQ1rTIx4YG2AdeCyHpvSELra1YhxlGt8/KPeuU4LUb9GdbtPVI/hepEeBRZSCzuBfmsbLKHOgvvjpz4v0rTy24kkTf8uDJCwe6cYnWTXJpJxjILRstfQteHH6jDFXFsKwJTyjzJ1mgkzE6tTu20I/ybT3MR0VyMwLTd2ZDgUJ3a/KgLl7nnNoLMRPS49D5M5xfSaFilsq0uO1vsBx2XwnZno1AOJ+46aKciwNLD/2YCF4q02RrkwHfy6MyAEWiVIsKjb/e61kwADWIcj9zpml5VVsb7vnIrtunt+iYm4obh15RZvlXOiDTCsaA2pqlzPWRx0ULtUr0/JCXVZHl8EPVaQZ8rInFCBTIi7L0YzdcirPxHMGdQjI9eMie25+tdG3zvk/nEBId8JmbwtlluKoqOGVrCZbcVg5/3nNQXvOFlS02dkBC5pwCMvt8r7YjCLQfYfDqkgb9kxYoWSSrWhENXZAYBDUOOr5Nry3U5RmsganbfoAXoJ1hROG6QH08Yuog2vv6XAkDoKKBujBq/7K5VeTXf0ycjMkoG3guEKxzEQZPWV+yQCYy8OBOqBF5E/QAiSGAJ1AHbFK8c63Um0Yxv1KgnFlv1ga/132Pl58V8EZWiJk4FkgFDYP4P/Wqv5j+4E8Vox0G4q6fNL+0i+/nag7u0smt+UwJItVzJXrWIy9RqCWAOUgsLspmES0fl+rzM0f29GFFM+CBWSandU40QddbI1fG2OyZtyk/ynyFP/6xlcpby7UcMWn3XBVQhEgQ/w8/hG9jBxW5PFYmcZ+Xf1jk0lpS+nIElr+UIfZzA9Lcmv1nelAJIlcZoYbBvkO43HVPecd6jqEVZkkhmolAZ0jSPeZA35LnYLL1e6mcISTDF1p1WHvBQnDV1ekO1uMfrSp5d+
 +DtzuQcp
 cxYCrKiRfCfN8RArYMwe88BR67r1TRLp2SO9NsdCROmgVXldgT99bSX9ghULbRv0JqBxE/OVJrKOxgiZ1brjAHHyV1Mr2zL0tRpeEADrZIBH9hMjl4W32K97mUfkY93Yy08Nv8e4tZRsRJixUkNPiIjYKNX9wApAnO2WJZio2cShVQQIsYxn0D3GRb1m7UVQEclRrKTFTb/4M4ybxk/DSmIGXf8uQOS5gavY2YvOGpCWtZZIKoXPbRIXp/8c36WXLAU/DaN1zcLiwACQBg+zhw8xc/lvS+uCmzFTtECOnlAeD5CZN+Q9dIcsibFTTuvBIxZpuo4mQVMo408YaOJl8lX43EuPe+/3onC5sy0ialrqYKIyyQpUJjA54E7xhy/QxpOesfiHawmBTRe4Lx07qiS6lFVETVw3bPkmX2gHouP5rsbE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> It is the same as GUP fast does for the PTE today. So this would now
>> recheck the PTE and the memdesc.
> 
> Ah, yes, I missed the step where we recheck the PTE.  Thanks.
> 
>> This recheck is because GUP fast effectively runs under a
>> SLAB_TYPESAFE_BY_RCU type of behavior for the struct folio. I think
>> the memdesc would also need to follow a SLAB_TYPESAFE_BY_RCU design as
>> well.
> 
> I haven't quite figured out if _all_ memdescs need to be TYPESAFE_BY_RCU
> or only the ones which either have refcounts or are otherwise
> migratable.  Slab should be safe to be not TYPESAFE because if we ever
> see a PageSlab, we won't try to dereference the pointer in GUP,
> pagecache lookup or migration.  I need to look through David's recent
> patches again to understand how migration is going to work (obviously
> we won't try to migrate slab pages).

The long term plan is to work on frozen pages (with balloon pages that's 
easy, with zsmalloc I am not sure yet).

Migration core will be responsible for freeing these frozen pages after 
migration succeeded etc.

PageOffline pages won't allocate any memdesc. Zsmalloc will have to 
allocate one.

I would expect that the ->migrate_page() callback will just get a frozen 
page and the callback will figure out what to do in regards of the medesc.

It's going to be a bunch of work and I am getting interrupted working on 
it ...

-- 
Cheers

David / dhildenb


