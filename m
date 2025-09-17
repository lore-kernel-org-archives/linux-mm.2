Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B83AFCAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 10:58:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09C898E000C; Wed, 17 Sep 2025 06:58:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04B168E0001; Wed, 17 Sep 2025 06:58:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E55608E000C; Wed, 17 Sep 2025 06:58:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CE0688E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 06:58:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4AE2186CE6
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 10:58:46 +0000 (UTC)
X-FDA: 83898444252.04.1B3C0F0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id C634C80006
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 10:58:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PSMAaLYD;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758106724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7JkjtbRP7dMtBFUCBqCV1SQcXuhyJiXUoZv2gn/Tp1M=;
	b=UikNLX2U8tiaLSDHr6wnmt1nNKRqaxJn8b8FJJZ1d5oPrbFiljVa4mWCCtcNwbM0scU2J4
	ItkJnhfKrYEZWIKmTAYzF38FVn8bShrw3tusDiTfPn3OgVM7fE7n5WQsxM/Uqvuz8PVI3R
	ZBlb5OPAW4uuV4Fk8Jn6iGsI9kKcAkI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758106724; a=rsa-sha256;
	cv=none;
	b=cjfRCsdxDtL9um14+Y1KaC2o8Bvht4JlzDItt+pEwVbMShuxd/z+pSjeXpviS7vlWWccRW
	dyQcijkfVaddEPj0CCMzJhPECa4fVvTRQcbW7L9Y372Ww1DzkA0AckfdA3brs1IR1dtfLW
	2pVBEw/oUOjQHhmPxpqmAHU15nlwLbE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PSMAaLYD;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758106723;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7JkjtbRP7dMtBFUCBqCV1SQcXuhyJiXUoZv2gn/Tp1M=;
	b=PSMAaLYDrU2UF5XnsESWllYqAvAlPdgzq/XNgWhgNviPnoV4RA1zfQrtNaqOzWhV1xAhKJ
	EmyCq3X4fSVgkqNK21c3kKpAmaGf/wMI8Yhz1CayfQ4xQLDFxEZeLCoRpJSQX03X7KQbhO
	28VnishYXebFtBRJu1S53M18PW7n9jY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-468-qQ1Tx0maM261mNREIQiUSg-1; Wed, 17 Sep 2025 06:58:39 -0400
X-MC-Unique: qQ1Tx0maM261mNREIQiUSg-1
X-Mimecast-MFC-AGG-ID: qQ1Tx0maM261mNREIQiUSg_1758106719
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b990eb77cso6392275e9.0
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 03:58:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758106719; x=1758711519;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7JkjtbRP7dMtBFUCBqCV1SQcXuhyJiXUoZv2gn/Tp1M=;
        b=VL96T592KcHEWaluv7XVFOQdHQeTrzgbw0mCPvr7y1/C2IPlbLWN95eGVM1IMGhO/k
         +CoLh3RyZn//w+kI0Q+rTjQdCji0SLbrJYk9w9AGRC07aQUWQHKZvp4ohAWh0LoqUa6z
         PhwAQJZZQmeGKEf8I7OPmNZcTS/gj8P623d61egpu0rBFORXL5zM/r9zr7dr40caEUFw
         fHijQuDYzCSpQQxmjF3v8XsaiRK6wQ70Xa159jTJTrF4CN6PQcXrIqU6g6VmTETeBc16
         PDi4+y04peOFQEBFqLwWBgZZTMryGp/qftaVZGYKKibZ/H+08gcvfB0u2G/9waRxErLK
         P07g==
X-Forwarded-Encrypted: i=1; AJvYcCV9Q0NZQ/OmlVzCM+hho4n9HDNxYLo5dyHsPHTu6V7rnx/gV5ow2qU9lSZagtE7fxcM0ii7fJwPPg==@kvack.org
X-Gm-Message-State: AOJu0Yxjv8nt6FmiqxCJ7fCuPojH6wtQGL8RpoZI2BKHgo8fMq7erONF
	4kMbTjucU3Zh6J6e87LQEy1DXb9zzUmVdKur/f16F2W30XX4QGZdN7rvma9xZbjNXZ7KE4pmGX5
	B9vLE8TWmJ51dbf78cxxmnEKGtsY9Tmi/zSRSusrVM87jw0Gdi2H9
X-Gm-Gg: ASbGnctq7thyw/UO7rDI8sXABE5d37uSj8UQS1XI0jKJEKnn7ZZWgcASyOpd3JmviFx
	Dx+q2a+D3gPswdsTrnEerafbpxG/zTE/T8qBKW7hy6ZfYYr9InxaxYo4sZBYhkwuuw2QBcGaHB9
	m2cbtQSAeXzxTXqz9Hz+HQieUSczqHs2g4Oy9dR1aZ/ovwfF/yt5OJM51pF9++9qcpoa0mda9z+
	REnQ3oYZ1UVchvWX26Q3BsO+ND8vAR0fZ1ShX+AYFc7s1S7DkO5P69KTHAkmVS9Z7lun+2BcKt1
	/tns472WLRNLpukQw3mOD9+R16vSBf3QiElbVbdDR3E6Mo7WsoReHcVH6HVVsheN82IjJ4mHvsl
	meMsxNVPX8xRZZh+gJqm+XE5z1PJmiAWkhr7WGZwz2gYj4lyt6uJwwpIdOMjaPCbe
X-Received: by 2002:a05:600c:608b:b0:45d:e775:d8b8 with SMTP id 5b1f17b1804b1-45f32d002bamr64516635e9.1.1758106718658;
        Wed, 17 Sep 2025 03:58:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGYHfjJCnarL426rUzCpUmPlFf0QrjHqktYk5gtQG/LD4ICoTbUxGn3yS+4cVVuXKN0QVM+1w==
X-Received: by 2002:a05:600c:608b:b0:45d:e775:d8b8 with SMTP id 5b1f17b1804b1-45f32d002bamr64516205e9.1.1758106718247;
        Wed, 17 Sep 2025 03:58:38 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f27:6d00:7b96:afc9:83d0:5bd? (p200300d82f276d007b96afc983d005bd.dip0.t-ipconnect.de. [2003:d8:2f27:6d00:7b96:afc9:83d0:5bd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ece199ad24sm745170f8f.50.2025.09.17.03.58.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Sep 2025 03:58:37 -0700 (PDT)
Message-ID: <1308de0e-bb5a-481f-a447-ee4440ffb419@redhat.com>
Date: Wed, 17 Sep 2025 12:58:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/7] mm/selftests: add max_vma_count tests
To: Kalesh Singh <kaleshsingh@google.com>, akpm@linux-foundation.org,
 minchan@kernel.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 rppt@kernel.org, pfalcato@suse.de
Cc: kernel-team@android.com, android-mm@google.com,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Kees Cook <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>, Ben Segall
 <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
 Valentin Schneider <vschneid@redhat.com>, Jann Horn <jannh@google.com>,
 Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20250915163838.631445-1-kaleshsingh@google.com>
 <20250915163838.631445-3-kaleshsingh@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250915163838.631445-3-kaleshsingh@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mXf5E2t9XUNXMnNAS60alywKHNJ5RFFFl9sy6sEhaHk_1758106719
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C634C80006
X-Stat-Signature: s9owhtwgndsx6yhruysd5wktyxgoxegi
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758106723-893842
X-HE-Meta: U2FsdGVkX1+g+hiIlh+oZfxxn+yXqpsMH0paWZmXe7rVMzeNWyn3hGZTR7pnyf2aPkO+E1ZbLRWeQ0KLtZrN/izr0D+WoyhNwDYHHq4rFaStjVY8DYj+qcu1a07D1OGAzccpHU077bi00s3g+fB9HCICiUJuV1uOTsrghOYAf95AlyjBlYSdAZfmtZXMtHX3CjwenQhyz6dOfoQOaBCVNEqwa6vT1BVZp+oIwNN+d4vssBcbjpwQd/etnb3UALwgLwlmm6UntmBEdaIIxypiVHG+h5VGoNBJ7YFJYrZHUNQPmpf45313MMGt39PLba6PnaQT8jlGJozzsNfpeWHa/c304mXeh7kZohFQc/Zj7EzYrUJ59K1TUK16/iku7IutUwcGBlUt+IagXcKY5iR9NzpXucRS+Ig7sTi876lrvOnRGJdmpzqcITsjON5lnxf4SshFSM00d7Bv5uD4BvmfWoBdK00yYcqc3DpqKfUUMfmXupvKugWTkLTw0RpbAt5GGmGy24nmgPK5lXNGIGiTNTOyarLz0QtuRKQkMiqoeWRcUAI/OkVyW7BPqVXFtJDNRbY3tgVayXlT4wzuPyOfcTZsM1hof+2xm3j8Ya7ZboXyUlzcVMY6SXzEYBRKqwDWkbC/bi/Jw6EKjX0+nzB+P8Gt/7Ily/xYH4Hapss/RHwALcrzLjhRmGw5z5/laJsYipkvmjzSvY+ONm4rvyYE5pXKNWifmz26qXtCEnzWwFsplMPGiK1nngYf2UiaIMYEwnGBffYe6+dS0ybYAwwq6SngjjmNn3G/cC9KSeQ/s9tu1QQyeULBfy7wWNVuLUYYVkiYA9/fmdM6njM14dYyPjCjlUOMvQmlxvSa7YfX0UyeRjd2kQh+jy9TN+7uLAFIEVMKKMAGR67pp7lwB3k6ES5V+a0B1TXOfePjLHo1tb5DT5TFgOkQswvl2S5Pp6woqAz8piu1jalnt9IdVyu
 KjReHUIr
 InKwDqAMFWl0ztngDBFTa2ioyhgwD9E4lNB1yFWVq3upgIJg97uitZ+5p8ncEV4Q2V0O5EtvWcGVjr2oklfhID016gKHAJn/iUCzNlaWeRcY1HpTZDhRguAXLZAvBJJtkr2SFQjphqHTLjZln/S53sNUo4T58enVz2jlllzNyheblWBZRNOB/uOPvG7OgccsKuNqAN4yW2e0HE2AIBLp6m8ZffCUcgmG/0BVpWbyu9SdoPizWTN/0sjVoBtj7djvsv8ybQ5M0D4pEBxic+o2OqUvix1u6C7zsyyEVpFLLK5eqdY8XSnPcREOEKaMpM/igdcDZo8jRnsTqKXtyEq8YlR59rIAbeD0pdoXABPkTexV3OnjDFJXaWpx8TTJjpYIrSMks/ukIhAXHe9ZAC2QG/lTuIzXHzdj2LcQgLZziPvTC+O2Essp8HR5FEjjLGsBqZD5GcXvIId+HLa3HWV1GQwsBbAEQyd/QJT6O
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> + * test_suite_setup - Set up the VMA layout for VMA count testing.
> + *
> + * Sets up the following VMA layout:
> + *
> + * +----- base_addr
> + * |
> + * V
> + * +--------------+----------------------+--------------+----------------+--------------+----------------+--------------+-----+----------------+--------------+
> + * |  Guard Page  |                      |  Guard Page  |  Extra Map 1   | Unmapped Gap |  Extra Map 2   | Unmapped Gap | ... |  Extra Map N   | Unmapped Gap |
> + * |  (unmapped)  |      TEST_AREA       |  (unmapped)  | (mapped page)  |  (1 page)    | (mapped page)  |  (1 page)    | ... | (mapped page)  |  (1 page)    |
> + * |   (1 page)   | (unmapped, 3 pages)  |   (1 page)   |    (1 page)    |              |    (1 page)    |              |     |    (1 page)    |              |
> + * +--------------+----------------------+--------------+----------------+--------------+----------------+--------------+-----+----------------+--------------+
> + * ^              ^                      ^              ^                                                                  ^
> + * |              |                      |              |                                                                  |
> + * +--GUARD_SIZE--+                      |              +-- EXTRA_MAPS points here             Sufficient EXTRA_MAPS to ---+
> + *    (PAGE_SIZE) |                      |                                                         reach MAX_VMA_COUNT
> + *                |                      |
> + *                +--- TEST_AREA_SIZE ---+
> + *                |   (3 * PAGE_SIZE)    |
> + *                ^
> + *                |
> + *                +-- TEST_AREA starts here
> + *
>

Just wondering if we could find a different name than "guard page" here, 
to not confuse stuff with guard ptes

Will the current "guard page" we a valid vma or just a hole?

-- 
Cheers

David / dhildenb


