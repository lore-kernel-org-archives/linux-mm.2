Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41A14CAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 11:32:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C2078E0005; Mon,  8 Sep 2025 07:32:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 899CB8E0001; Mon,  8 Sep 2025 07:32:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AF668E0005; Mon,  8 Sep 2025 07:32:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6B2868E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:32:13 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1F51C5C11B
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:32:13 +0000 (UTC)
X-FDA: 83865869346.10.58BDECA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id C43AE160005
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:32:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cYe1RXZr;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757331130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RYeX7k5oRCR16YPZ+uV5QGYD9PnDjnkG4tjflkns4Go=;
	b=v+uaOW64O94PqcA1A9h942qa6COymO3XgnCjEPsbEjLxLOz8FVtR0g71US/SXCvWrA35iz
	eYhkpYXCtCQRnviE9jV7yi95YiAHXam0+spHhTmsDrOrY4PZgQUpmPMIvzLUm7SiUwImgi
	P+54zQ/EGsZGCT7mFmI7hWl7BkWR9DQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757331130; a=rsa-sha256;
	cv=none;
	b=fY5gX1fHDcUBQdPiCgLTFF1yQ/Ls9S+HY2r8ltfbCOu2HDhKlut0IbjOwpl5XBR51qEpm8
	i4xPPeH9gZO9GKoP46AKJAzdmurSLK8UFR8y76Fg4mHADvji/ihxG2n2EG+mjESkoZaR2L
	1VqG3GwPJFNX5wn/d0E3tqjt40ygMyE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cYe1RXZr;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757331130;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=RYeX7k5oRCR16YPZ+uV5QGYD9PnDjnkG4tjflkns4Go=;
	b=cYe1RXZrhMFPLcgAq7bhQogw4J1YxOnObNgCca5J8kBSEnPotzZ78Rd0ABYTr5JpXjMtTy
	OyhifihtMMKY3/wnXmmNnQ8v4Gv2z4WDfqcLUUjE+GszsZYs37r0QRwezgp/ZFCJnicxyG
	IRTIY8A/oVauo9rjKxkeJybhssRqCz8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-427-sE45lIHSOTW5e7FYBS94vw-1; Mon, 08 Sep 2025 07:32:08 -0400
X-MC-Unique: sE45lIHSOTW5e7FYBS94vw-1
X-Mimecast-MFC-AGG-ID: sE45lIHSOTW5e7FYBS94vw_1757331128
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3dbf3054ac4so2500048f8f.3
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 04:32:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757331127; x=1757935927;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RYeX7k5oRCR16YPZ+uV5QGYD9PnDjnkG4tjflkns4Go=;
        b=BQn67AO3ne81f4eVdjgRTyZPOu2WEWus5pgKqmEOH8JvR5xjpfCfGKCVsD9M7RzD3m
         coeX4e8I4WFiAxkQSg5I4Ey+o9QQw9u/ZxopGz/FeQHAjkCnnoLaaivagZnKfotK4M5+
         USPPYNfqToTW8urP9fGvC7ktQ68AcDbcLWy22/KXftRbttx9I2RCuWqyjcDHe/d1oxT5
         urXee7bIFCVU3cTd+2cSsZXSVY9lEpZ2fRv4PsEScD9e/USWa5JjbQIIoqz/Sd904S+g
         NB0gEfpihAqq7Hk4ju8sjFf6+cz2iU5muQh0g3fTV/pgUOPsZk/QFddbbPUcuGas/caA
         tRLQ==
X-Forwarded-Encrypted: i=1; AJvYcCXP4If9TDEYF6YmCw3z37wE/iQVeGoEzksjgKTZQWJkYc3Sjako1IAzyCu8y2WnC/qCV/0MZYA6fQ==@kvack.org
X-Gm-Message-State: AOJu0YwVRdYUGHeB1UcKQ4Ov1ofuHWjh0Wb4aCSS6+/nSXizHkE7WIC8
	imKCAu97pASDjzkaRdUgKtBne3+hPPoulYsRYhNj3TOcvL6tnyCcc8Lvew6HFHysHmSY6FRt97k
	D7wpvaIMG4HPfLkHCt2vlilnL/jR0XTDkG+sCpBu9KpuIvMe4pI66
X-Gm-Gg: ASbGncsErle+fIuBAvFlf73Ckic0ez1YY3GtyT/bbiBIsOj3kderuM8tdycwzhrG0/I
	REb472rOgwvfvQD4bunXoriAuWX2md7Wb0vzt6jafP4m5BtOOwWSZ+gVJ0BD9RV1P0ZTBcpbry3
	J7uJvVewKXmR0tbuILLLXq0AFq5gAAkYQ6nKF6dUCF7ny5fCWvaWvby/6KFTkmnsuUSyfd4mD0l
	ja7lG3uBSj9VasChQbkC04Ii/MRu7Cfl0PxrIYLAy/DcdLLsaFMI01sC5JjJ9qhtWYw/kw/n3me
	+n8aCcXnHV/LtNHibkQDD0atx0GuSizQgGsui3zrQVvN7Eb0iRegi/X13N5l8am9rRRlsZYAbZv
	1NC0MnVwydnRgeOz+rjpL/n37kv3wy6dxOcz+5RP6rwDjwQsyG9Ps5aMNHXszVOR7
X-Received: by 2002:a5d:64c9:0:b0:3c9:b8b7:ea4e with SMTP id ffacd0b85a97d-3e637370e00mr6117579f8f.19.1757331127583;
        Mon, 08 Sep 2025 04:32:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHY+jANGJPz1N5JVRub3EJpf4jLmRvSxYXoqHXGGBahJ9/Jyo/gddwYQiuqVCMXaKAZtZzmog==
X-Received: by 2002:a5d:64c9:0:b0:3c9:b8b7:ea4e with SMTP id ffacd0b85a97d-3e637370e00mr6117547f8f.19.1757331127112;
        Mon, 08 Sep 2025 04:32:07 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:700:d846:15f3:6ca0:8029? (p200300d82f250700d84615f36ca08029.dip0.t-ipconnect.de. [2003:d8:2f25:700:d846:15f3:6ca0:8029])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf33fb9cebsm41095491f8f.46.2025.09.08.04.32.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 04:32:06 -0700 (PDT)
Message-ID: <9a0c07b9-5bf0-4251-8609-fbaf0ca75bf9@redhat.com>
Date: Mon, 8 Sep 2025 13:32:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] mm: skip mlocked THPs that are underused early in
 deferred_split_scan()
To: Kiryl Shutsemau <kirill@shutemov.name>, Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, Liam.Howlett@oracle.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, dev.jain@arm.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 usamaarif642@gmail.com, ziy@nvidia.com
References: <20250908090741.61519-1-lance.yang@linux.dev>
 <niywtremc5kfhs3lenmfxvbiiizyexnaw3m25twedmzovfoeno@lk2o46tfdklk>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <niywtremc5kfhs3lenmfxvbiiizyexnaw3m25twedmzovfoeno@lk2o46tfdklk>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: L4l1awbld8jQ-_H7RHXjz1Ubb_-2QHh4bZaAhSF9DHA_1757331128
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C43AE160005
X-Stat-Signature: uabx97bbz45pxzm5h8hdsr6isn355jrk
X-Rspam-User: 
X-HE-Tag: 1757331130-679686
X-HE-Meta: U2FsdGVkX1+2hdZ5m3sHtUIokKbBzig5i3OPDgJUri5T03+2iAfUi5EpS3s56+nLs1DjSs0VA677nkIL3efItTRNROfDB60jo/PLYEhwJGR6d7/GPJ4lzwW0il6ajQnxENVTcLuY7NitB+wjBHXpZX83L4Lnl6DK1R74a5QkNlQYraDRDbRKdF/zFIhZ2PLiQFpZ0+agGOha1YgP5LFBE/yUyo16QNc0CQtd7bhd1zvOf1z25GmNAexntUGbOcCRWwXxdA6ADzqkJs3X/v+yd7cIslL2JQACzqCB0/C5qslA/LQC64IDNrBi0fxO9Ug1kgwrBaVrxjRE2rRTzNjSpBdbDBsY+g5wqTyYETn3HI2ULed0ju19g9mEuFSNkZeHLMTNHTclJyeC+0AFwEFH/yCVWE9owjqEXByR+/5PnP3xd4mTiO0sOLGsc6Wlsck67lCu9giIqwGYNoo2YdaQoq/YhkxlLGVZacFBFbk6ytYDNj9eEylscr+9n9cdf0V3mR+4MJF2pxaDllL/jVcMvKKIEqd8U+yL/auvtgERCttI41+4Kj+ynkhLXY/+eS1mhkdWnniVv9XPCdNWLyop5tksbMr/pkHR8ituY/svo5jRKUa30qUbLthtbX3ev7M5jYoZJRyAiOmLMhIsiv+aGkhxUSeiHruHXm1XIsD1ESxcbrim9yDLLAv80OJ2bO+3EWzS2E/ivrlVF+fvqUTE/IFuLVHaE08HtJN9oLvIEBuD5mvkG/xJb5K6PRv90a4rJzG8qMH+Z2EaVa43dfp1tnbjGmkBou2/b4dECJP/716m51sQ5SqTpq9gECXgMDNdqVCkq21iznXLinmuraeyqmMd6Th4PNvNNbPy+/LUeIykUPgQxsm0CQCUSfMXXvEu4Q+hWaoLPx1R3X9XUo97MBdXjcmN+e4u4J7MRCndL45MTrvktW+r4XtF8ebcxqqEjt2TGmVPkEbN2Ew4Qi1
 yY5tCNTA
 kdhTV0MOiBUnrL7CwayRRoYU8k1d/XP9gM8mwNfd78A0BwIv0nNYbUbQdX/xSvLNGY5o4YuuckuW5mxu5q4hk9HoWwudcU6+uZSnUE+DNSaFTPZQR+72ez6H/HG5/3+fuoZUEwB/rRZKVq7Oi6WB86XrZPx6xpb3Vh+hzwBYZ/x3nFjdCGQW6CFpijtAvZ7zznKev2KmQ/AsBpXRYIRONocRlHfrz9rl0KRxRZeUnPpx9VNKEsBa8UH5QZoUWpwPCCBy6x+E6iXmRWx/Q4mCyhjVoL4FzWHWiz/09R18wnGLDv6mdLP52pktcHC2cL5is8tCoUo1OViRIr3HCdoI5V+ZdaY6HyQyLqyVdWYceOzzp2DJKkuAniF/Ed5DOJ43S6TAVxmxiMs/PcNfswT4G7pwUijLU3puhfMq7/JowpTHcztqb5mAPsQI2U6SGqfP+tBqpmpOp81MnFzooRjIUb1wFWuEkXjxDHbjk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.09.25 12:38, Kiryl Shutsemau wrote:
> On Mon, Sep 08, 2025 at 05:07:41PM +0800, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> When we stumble over a fully-mapped mlocked THP in the deferred shrinker,
>> it does not make sense to try to detect whether it is underused, because
>> try_to_map_unused_to_zeropage(), called while splitting the folio, will not
>> actually replace any zeroed pages by the shared zeropage.
> 
> It makes me think, does KSM follows the same logic as
> try_to_map_unused_to_zeropage()?
> 
> I cannot immediately find what prevents KSM from replacing zeroed mlocked
> folio with ZERO_PAGE().
> 
> Hm?

I assume if you're using mlock and at the same time enable KSM for a 
process/VMA, you're doing something wrong.

In contrast, THP is supposed to be transparent (yeah, I know ...).

-- 
Cheers

David / dhildenb


