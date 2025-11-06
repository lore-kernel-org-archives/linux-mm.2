Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B54B0CCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 11:08:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FD838E000F; Thu,  6 Nov 2025 06:08:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AECF8E0002; Thu,  6 Nov 2025 06:08:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09D9C8E000F; Thu,  6 Nov 2025 06:08:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E8B4A8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 06:08:42 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A061A8932E
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 11:08:42 +0000 (UTC)
X-FDA: 84079909284.25.6804461
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0D7B2C000D
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 11:08:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JDWpa02o;
	spf=pass (imf10.hostedemail.com: domain of asml.silence@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=asml.silence@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762427320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3smk6GeMQLyg2bWpqf+opFvd8OFCVzmfS4zTn2VVngo=;
	b=e4z/nF//hH3qZH3eZ80dGKonFkV5AmhUZXMzgcGRuVXfREr1eHS8Hxr4u9aEKCukN7rBoT
	7WomW0ot9+pLdhTa22QPk0dbsYMa6bCHvoe0DOyN+fdHKJFU9gxemI8VvyKlmNQ7CPfyVi
	xh8r10z9tq34Xuf2GpK9KmkxPGqtUmA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JDWpa02o;
	spf=pass (imf10.hostedemail.com: domain of asml.silence@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=asml.silence@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762427320; a=rsa-sha256;
	cv=none;
	b=Po7oefxCd6NDJuoiYObmdUHMPCJlUv9wKwHDKtkaZ9xQ1sUEWZCFfK49ZPpMsdmFinfIQ4
	2iuCS3f4gdWAqVxy9siLCgSoeigZOEI1wh6csGyEsXWdgUofImFYzJ9jkw+CNXzG2QO74j
	aB/eUlEX6Celtyx7qFoZjeEkWR6637E=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-477563e28a3so6703485e9.1
        for <linux-mm@kvack.org>; Thu, 06 Nov 2025 03:08:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762427318; x=1763032118; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3smk6GeMQLyg2bWpqf+opFvd8OFCVzmfS4zTn2VVngo=;
        b=JDWpa02oAZk1pulH5EbkR9YG0TpBU6uUTeS6+r42JwVslcDIhIqQjSN/Wg0LKwqj/a
         ZP8O9tpSyshIaK2YAtZq4seRAr/gs+gaeYV+STWqvwgz+c4VcUHD6ZrH1jeG4nkSJwll
         U13BgbWvOBDEyPel3dc4WPEgtuC01Zv7R9mdQON+rdOCIGCULXsNv5Vf3iY8TnKCgjEi
         dg0HKJnvwzG3NFdg0rq+CbZhGfnlzAaa78mJ3JBmmVZ8sRf6TnD0Dg7B7fHijv88f6W+
         RyLcufT8sUAnlsk+/eM/tAphNzwMMldrP2nEGJjsCxEvHaKfwIHFr47Zk6fZThe0ZsHl
         YqNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762427318; x=1763032118;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3smk6GeMQLyg2bWpqf+opFvd8OFCVzmfS4zTn2VVngo=;
        b=CZT1EnmlNqAihnK3aHGqrl6lUj0bWPmJjTRxzwpGuYgBl14A2r4hixwQ0HaNQg/CmH
         pjyUkKxUa0nPGYE3Jhre3QegqaJJ59KXnHeUPbX1WPPczD5ufLCr3yoGeszhg5Pc58Lj
         AfZmWccRyOUXJqaWxRJZFaJDf9DCZbuPr/tp8ehItrN3eeOFamNkODKipkQkyBk81NY+
         Bw5GpwiPEKqAJNQaHOk5hI7rl4CR5BgdRfzeVoUQU9SXTBFBdHegVbCv/7rb7dszOUSe
         c9ad7uZkopTMiLK8GmsVZJOjZw08KTy79/ONhsX7D5Zfyls/XvqVstcbLNJAGOsjOYm8
         ZU4A==
X-Forwarded-Encrypted: i=1; AJvYcCWXAKbQaoWVRiD17p6ZzAN/8LEIqGURWDCToaBI/TowJcqR6kLVNcIDFKg5AhdX8k8ugVL6b9uIwA==@kvack.org
X-Gm-Message-State: AOJu0YzoA3HeLaYBcWaIm3pad91uLh8EQjrxccuO/eNm6/WU97pWqutt
	2AhdbHbtY7cKHtVkAY7Sq8oRztFFMK0kee6dlqJkzSK6ONi/oaKjvQg6
X-Gm-Gg: ASbGnctOT4niTQe2nvzp5E8i97NrE49cMYHS5DQZzlMGl47tuAPVOa07ceeVNhHd6uy
	z+J7wVZLgCg+yumT0+ftLSW1HTgC04/r08xgw7UGcNmf8E8Jmnstz9Di1KayefloMwrlnSyTTtK
	slQPFmNY4ZX0VtiwBYKq8FkWaECdOideKWKoTEXi6Q6EgKY4A19/sRzJ1YthuLiXCgJauhzrCEP
	gCeGiqPYT7jhpKzgwLerIPnx9ZqHb79bTQoJLp+bm0IBig42wZhFh5QREbPlTDka+uDHo8XSB7B
	qXM14Kj+PuH15xdOf43XRoMpJd9tBeAB1LQ+D4Ridlt0M8Vqb9YSN++RYk6ojdVVUVm5TRThjSJ
	41PExdxyafRljA1nYy4V7QFSvaiIdIahhsN+SYA27gHDpFqA4Uf3qq80VgzDOivX/S3Qdb2CihO
	vMYXGTEOktct0JKFfamnKbX0fquywnRj3XFmPgaXGrJq6enIBUgFWD7yubhJTC+A==
X-Google-Smtp-Source: AGHT+IFUsWMoUQp2LAQBvEqelZeh8+i2mx6qm6o3gPPvtfcki9Q9yd5em3sUzeuAg53ANmu2/8izdQ==
X-Received: by 2002:a05:600c:4c27:b0:477:14ba:28da with SMTP id 5b1f17b1804b1-4776201cbb8mr15583175e9.5.1762427318220;
        Thu, 06 Nov 2025 03:08:38 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4775ce2cde0sm102571845e9.15.2025.11.06.03.08.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Nov 2025 03:08:37 -0800 (PST)
Message-ID: <4ab9d277-97ef-414d-bb5d-910fd8964c2b@gmail.com>
Date: Thu, 6 Nov 2025 11:08:35 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC mm v5 2/2] mm: introduce a new page type for page pool in
 page type
To: Byungchul Park <byungchul@sk.com>, linux-mm@kvack.org,
 netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
 harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
 davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
 john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com,
 leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
 akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, horms@kernel.org, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com, ilias.apalodimas@linaro.org, willy@infradead.org,
 brauner@kernel.org, kas@kernel.org, yuzhao@google.com,
 usamaarif642@gmail.com, baolin.wang@linux.alibaba.com,
 almasrymina@google.com, toke@redhat.com, bpf@vger.kernel.org,
 linux-rdma@vger.kernel.org, sfr@canb.auug.org.au, dw@davidwei.uk,
 ap420073@gmail.com, dtatulea@nvidia.com
References: <20251103075108.26437-1-byungchul@sk.com>
 <20251103075108.26437-3-byungchul@sk.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20251103075108.26437-3-byungchul@sk.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0D7B2C000D
X-Stat-Signature: 78iyaxbj6h9wq7ntbjb3wbcktjsgitr1
X-Rspam-User: 
X-HE-Tag: 1762427319-504560
X-HE-Meta: U2FsdGVkX1/WCm5Dd3CM0rl0aH/lhVVy9YDtLN+MKZ4rp87gfiyAQajJdmOGhDJ43fWTq6zIcejqvRIYLUaxG1ZITXzamusDawnd2gyF/CtbCNkufE+784CAS4y6f1ohvezWxxetWthNehZGhMcegEQ24COb53BAc+Mh7Rp/FIy00qx1zr0SgCXWVWlyxilkYP4IEmOJTOs+hDCGfPTtMqITaJhvc7TvJzNfxJDT5bZNew2+LNHzZqQpeP3jhXzOYtiNl+b1PmQCgwdLMBOgZ9Xdwo4N7j7j7wlAVpjxG3qfZ3kuw/twIRWYSkMklDwJoNb5+F9FqsyqYmTJ4In9hsVWjU9IzZquVuTRzCUBgk+Jy7oFx8E+tcQ9zHpb2yqpNhmujO668rPPXaZyiMIQPbjDaAGD7Q0o4CZDiu7zquAk1oG29wK+hYj42FjH88Gdc4ogFintj1JOOtcpHyNQRcosdH6O9fPjf/Ja0Qk9QXPYxm+kkE9MdHYUxaYqYapOHyLCNFg/Ltxdai1UKO6GW+7BSO3uVGpmp17DBfsYYkZzmFMbXJvOTnozJeJG0Ro/D/+J6C1VymxJ30J4hPyWc3jSnD8wOlILnYbeKoyuMIpFPGRPx7znDEC8CXm3BWDrLd2TtkDmFbkOwFHJdockKc81CaG3pWkMl8kqZ4/2yhTBQafB9LOPsTo45ZqVO7mKw0s+cRg1k4nCzhR61PTFFapTCqIruHMZBtOxhCZzJ5td74O/1IFOvVrlQDTdm7M1CnUU+xr5DkDn8SB2DZmeKhkOwhMaDLECvWsBrPELCtNimgYr3HMhiaDU2V94teDKA/YgoPnWVgIFHCbUH52JW4/PjE7KNxZyRz0ucJmAbQNJ5fwJ+FMw3KDDFdSU5A5GxL957GhhyaYcO8gVxZWzBtLal3bpXFgD3K2SP+ItfuxlPeyZmNDzHV+xwtj4NpahK3DseCwfE+9N0Z9crKG
 OY1BsYKn
 EChkJ92Hn6sawqgidIcYMDA+g6uNFmeA4TYTXXU+Z6fnpBpf40CZrWeBhyzUHQ4lZrQ9j8zAU4/383Ar7MbXbdoJi2R7xMZVoS+RPYIfypn9/NNLf4h5TCCLtfI+ZsunlnMGu/qpfvcV5N4+pn5y+chDvMbc4q9bMyuZA43Cg6fS+/ZQsIrGk6Y1oEjunhkHEtoTcbCqgnfrP+xxSKI+vSCAM2SZ9DIG0tMzqRTO8AcpilsWVyQjwWunhN680uwecX0OXEON8IIfmXs+hhfLM3fBCTJVrzuoreTPJcN4kYx0Tj9yD/ZeIjOrts2048/iZQhL2DmZ9kzzBlx2/DBl6YIfPxswVssXK5lv9QOc05sO7305KVkQLpM/1mqQbuL4v538bKoIa0NFFrpOcihtAHj+1+oKe/mukGB/OmUT6Js7GVtmFl+Ni5I3ygBA3H9u1zCmho3baq3+hQIOHMgtXT4ieuC8kizneyjs6TqbGd7Ciozx5IxKremcALuUEzPqrEJ+0uab1yVVUbmEq54OR/ugbmu2i+7HmxDmb3pskEZ/A7OuXkI22N8dsIMO8HaZh6lXNydB+28PknjCqqD3Qacf27QtsrnM/NS6BCD7mqZjr9h3WpSQtQQQiJypUJ0GjVZ29
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/3/25 07:51, Byungchul Park wrote:
> Currently, the condition 'page->pp_magic == PP_SIGNATURE' is used to
> determine if a page belongs to a page pool.  However, with the planned
> removal of ->pp_magic, we should instead leverage the page_type in
> struct page, such as PGTY_netpp, for this purpose.
> 
> Introduce and use the page type APIs e.g. PageNetpp(), __SetPageNetpp(),
> and __ClearPageNetpp() instead, and remove the existing APIs accessing
> ->pp_magic e.g. page_pool_page_is_pp(), netmem_or_pp_magic(), and
> netmem_clear_pp_magic().
> 
> This work was inspired by the following link:
> 
> [1] https://lore.kernel.org/all/582f41c0-2742-4400-9c81-0d46bf4e8314@gmail.com/
> 
> While at it, move the sanity check for page pool to on free.

Looks good to me

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

-- 
Pavel Begunkov


