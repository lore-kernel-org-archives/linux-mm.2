Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A8EBCA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 14:33:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5DDF8E0003; Wed,  3 Sep 2025 10:33:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0DFF8E0001; Wed,  3 Sep 2025 10:33:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FD258E0003; Wed,  3 Sep 2025 10:33:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8EAC68E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 10:33:45 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2CC24C0722
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 14:33:45 +0000 (UTC)
X-FDA: 83848182810.04.F228C85
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id D28ED160007
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 14:33:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gdag9emx;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756910022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/220hvN5lbAQMJA12z7WMtiNilLFilf+4JhsLwhDHhI=;
	b=YqV3R787H8kEWcllYVHJHeNQAS8xw/HLCWLe1x5Hy8ZlRzpTPw9KZPzi2Vd9c+KGni7SC9
	OWUF6ntUi6d7n/9B2qhP6Otg+1tt6FKEn3WJPnzdUrzoBoBv4ToHzMUjp9OKG9myu9Jw+0
	WP5Dt8LDeCHfhGixpx2bjftC9einN/A=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gdag9emx;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756910022; a=rsa-sha256;
	cv=none;
	b=dxuQakQTBNE56kzkwvM2MKbiPxHnEaYQAov17h1edqhthsgiCOZpR1A7C5DHQ2bFlMBjv+
	GRZ94bfxqanHz/UJY8d3Rd569yaMmxQj/tBQ+Jw70UkdLapl8GoSINgXCFXEZA4psaPGkG
	aHhoWJNNqhVmtdUBQKTm6D9sxF8n0Gg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756910021;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/220hvN5lbAQMJA12z7WMtiNilLFilf+4JhsLwhDHhI=;
	b=gdag9emxfRSmRGEIKkL4Wn0g4lrc3DkWQumVVHYfxAdDwXt855zaREaDjFBz7In479H3ef
	WdcXt1MQ/ExcCYXQq6fXwDySaM8rBrXBNms0pbl9oL5Vmgu+0fyVhVYsiGTvGNfIT/ULpK
	k1qqFZWC3zWduHL5GKbYME74ISZgmuc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-632-TlVaRYPjPVe0snRaGo13fw-1; Wed, 03 Sep 2025 10:33:38 -0400
X-MC-Unique: TlVaRYPjPVe0snRaGo13fw-1
X-Mimecast-MFC-AGG-ID: TlVaRYPjPVe0snRaGo13fw_1756910018
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3dbc72f8d32so643844f8f.3
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 07:33:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756910017; x=1757514817;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/220hvN5lbAQMJA12z7WMtiNilLFilf+4JhsLwhDHhI=;
        b=cXymB2+7ngSGcB2pn5Fqact9ThKjEYCTJ6663s3VU8psH+5WHbUXBOgTdPuOQ0DAyx
         8XRlocDV3HL6JGvBJ6OG534TMnrFEp5TwE2LtVYXK6N4N9h7BuTJBYKsXR60S0BmRPeH
         LYnadB/+R/GfFn6HlVLYlE0VjA/tHWI7ZR6FvuV0tigRxABpjcCTnv81RoJVwTnRRLpW
         kRyiDpaee7o28W4zDg0kZLhQckogPRvANq8J2DnY0Z2tzehZOZBCzwXTyX2nkfATxNpF
         Yp2vdJljamgSW0hmZ0xuVeLG0KK79qb1LQRn3YtFoxk+e8iYtBaMx8FfAEIJESCGPPwT
         5kvA==
X-Forwarded-Encrypted: i=1; AJvYcCVd5ZI0hDz26dsv+ODCvFNoT6WqI4o0N3P/up6uznvoHJJ1RDkzpio03vXNv6BgbFpu1zkKzdRxXg==@kvack.org
X-Gm-Message-State: AOJu0YxcOatL5PKfcxycncUbJ1R17VQYKjocck9NyNh7Kml4ZBQgCOQt
	AkngbKoqq3yKeTXFp2/R4XCwVVsTAnNOd8ruEPr8MFdJJaHnds4K5nn0BwNSPAZC0xed9ddXDX/
	mGNaURbrOkyir7W/B0e8sdsZ9tCn3c2D57Ywi9miQyDkCvDZPyeRC
X-Gm-Gg: ASbGnctqIpRkSVKSD+xw3nqolZTdwZ7LkArcV40Hjefvn4SG6nQ79hjp6X3ssGiDk47
	NXox7YvfjNzYmDJtumWtaJgwTD7hFOZiGsEUUWxW33jH8etfbTXuXkLwYCdL4CJxdEwkYz8pzh4
	2BPdiQqERzmzT8LY3u5NRtflPQZdaxNMhKm0PLdO7ERK7PWnV5N7lJyuoGsJY7TVb12FC9RrBll
	1UEpBIfHQI1gDiPW47evgbtyntdBHCQMFdIBxJL3yuEiXh3vbi7f4z7kP3is2QcfJ1dgb8epgWw
	Ok0/vRMHIVPq+KiHIKYyfZmzYwR8G3HaYrj8E9HJtF5XCCYADEmBf3X9NxBya8STNffozYqQh5L
	Uk0ApK3MOGMVPf5gvQT1m62AXTuPK+n3T22nbJD6XBUyf6hjlnMCU9/oB/frOALF9ruM=
X-Received: by 2002:a05:6000:2dc4:b0:3dc:2f0e:5e2d with SMTP id ffacd0b85a97d-3dc2f0e5e94mr2575498f8f.0.1756910017497;
        Wed, 03 Sep 2025 07:33:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE4D1SgBSF3QNwERMDvj9DR8nykgfCFIE0z6hJzwxiK3nhnnvUFuUO7W+qHUce+DDdOjsRNyg==
X-Received: by 2002:a05:6000:2dc4:b0:3dc:2f0e:5e2d with SMTP id ffacd0b85a97d-3dc2f0e5e94mr2575471f8f.0.1756910017027;
        Wed, 03 Sep 2025 07:33:37 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f09:9c00:8173:2a94:640d:dd31? (p200300d82f099c0081732a94640ddd31.dip0.t-ipconnect.de. [2003:d8:2f09:9c00:8173:2a94:640d:dd31])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6b1cdf05sm186906445e9.1.2025.09.03.07.33.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 07:33:36 -0700 (PDT)
Message-ID: <5775f660-f83a-4912-9e2d-1e92528f2e29@redhat.com>
Date: Wed, 3 Sep 2025 16:33:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm: Drop all references of writable and SCAN_PAGE_RO
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, kas@kernel.org, willy@infradead.org,
 hughd@google.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250903054635.19949-1-dev.jain@arm.com>
 <20250903054635.19949-2-dev.jain@arm.com>
 <e37bc789-cb53-4df5-8297-3be146d2b620@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <e37bc789-cb53-4df5-8297-3be146d2b620@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: B7pnhj6zVeZ7MEXJs5Bm6HfqQEZ7idp5fBVAY0o1mtE_1756910018
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D28ED160007
X-Stat-Signature: h6bisiy77y7ipc7bak5ysxf6w47wd3je
X-Rspam-User: 
X-HE-Tag: 1756910021-858908
X-HE-Meta: U2FsdGVkX1+Yo1YKG1oMhhyMTJ90hWYATVf4JWz1Dx7zXWfYibFJiKQ2wmqGZIMNaBUUS+saoFs/l0oFeqi5kO9WBhxk3d2GqPDNePJGjcL0pwFIequn2XMG3gNGxVdu8xBmYm5ByCaDnmtUnfIY36oqTtUlRdnmTz1xqt6EquXJD9/yOzUhhvC47t3ZfmQC+j7XWLNKz5s0D4XBZaFubdwOBf+8jsRRkg0OrGotLhqw/g/4jxmY4/RSVqoO3i6VGZg9n5qD57VEjiUhFSpgvM/Oy1iYx3ajTMS+i2pp0CZOJXsL8asrJUpaBD72Efv86LmD0NmujMG8wGc1V7IcPoa1SChhajvpSvsOttLnx4bQ17q9fO7JiAnj36CU7IS9Vxxhr1u7M16l1z1IeZJ9L3KESImpzEp+2EeLL8ReKZ+v1jkmOEUQHqFeElZv3zyxM2B675fdP/fgV4VQYB+McHxTqQLD8VXE2jEDM47ZE1AZsct0zexja/SEbbY7wAf2Rk28GMYNbHIHSY0xrv7m2rCHe9E6uqp1Ynvi1ZKoOVkPx/kpRiGJj1p5Sq4KTrzm8Ny3b+S/NitEj2RBgfDacEXcXVV+5gpCADDnoD9759UWMVhzJkTiqhHTejnryijSeHN8cT502cVw7dfZjaz8O7yRrw7C/ku4tkGl4uqO84PHmhLt4mhjMIAUVpWGP47H+8HzM+UueuuTxHw+ln3WhUPxVg4RYqEDOCo8C/go+ejVvPm51Ts9VDmXd4FkghhMo7HQlUjClSb3kSiJQ2+/50SUJh9e0xbElGJRrQdrc4A0TyQUekijZA7Dn76und5zau0muELQP9XzO25GmjGYNdZyCHp3N83umRZ0zGKkULe8nqdIhYD+nwjsCD7GVtrZcvXO4I2BwOAHbWtX9PSr9cCqbn2zaV9Cn8j1uPlC6YPeGvm8ehXGjuGJ6fjILDgrEh2SFTQsVn+27ast7On
 lEJ8Cgem
 czsGogRj4zHnoqjg9aYK602IvZ3MKqT7wPX4FQe2RaWkgvxlE8xEAr5nEL3/D/DPv+68GwnIZ+f6gTLe4PuVKJ8IeI+xyVYNLWcpQ4kT4Ws74eKjKQzEC9pg9I0zHWTe20yEUAUN7EvE39ung8rh4OruLqNlvRgWkWeoMWHnmVAAKQDLOdBeHGcqY6LPuE0w+9N0EpnPmgdXmFE5HcRshIjvAPG5BfEPyUL+YfFMZZ4PbWQ72S78LR1TmStuE/091rAMsAUZhMj9b1TZeYs3SuQpD29VGWl5GlbvXYyuAsMpc4FpNOp3YGvpLKqkkLzbElNoGE1YNKdNKNduo5BiQuYKrF0Y/yZbJvsWyl0BK6rtu+qeoTskqChzD0+Sy/lqFK1x4G6xotDn1tNB8/B5ymigYtMPWhIKC1Qghorq8In15jQ7dn1+Xt8D0vupU2fPIgb6cQ0LnDUDi1G1HjqDMc8G8vyJJ1E3oXSR3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03.09.25 15:26, Lorenzo Stoakes wrote:
> I know it's a small thing, and subjective, but really would prefer a cover
> letter to a 2/2 replying to a 1/2 :P
> 
> But others may disagree, just a small trivial plea :>)

yes, I was assuming that I didn't get CCed on it. :)

Anything with more than one patch should have a cover letter.

-- 
Cheers

David / dhildenb


