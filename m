Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ED46CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 08:13:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B6688E000C; Tue,  2 Sep 2025 04:13:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98D588E0006; Tue,  2 Sep 2025 04:13:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87CB68E000C; Tue,  2 Sep 2025 04:13:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 79F948E0006
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 04:13:55 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6FD3B160B27
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:04:28 +0000 (UTC)
X-FDA: 83843573016.23.DB876B9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 336CF18000D
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:04:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cOCdvZPy;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756800266; a=rsa-sha256;
	cv=none;
	b=pXF3UVCvyFVfM/lWjUm8y+vEsvuvIM7+L2hSVICNihvNjM4skx4P7VeH+cNkgYmsd42CbJ
	CeqG6CEw927YI9A2FUllzuNKc6anHthHCH6eAlpVzJaN2VxtCU7+mVvfEwAcAp4JJmqjRI
	ViIWQC4T2t38ulm/xzLCMhHtIuDjDdo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cOCdvZPy;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756800266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iWRs8dmxjkSLC3xxQFUr/zOxuf3XJeRB+0HV6i1wagU=;
	b=CSx35PR219tcsAxKwkO7bv0200rjX1hWw1k94b4GvEFeFhKrlBBOWeiqr3r+tyRj8WoNa+
	rfEmRrffi4JCPQW/nqSpsKOWil4ck0MRZJkr69tfOqNqeRwyocwZKxkZgrPi/ikj09dUcf
	eAS0AyVhjIrG1qOPiRhVxGfGGnx60So=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756800265;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=iWRs8dmxjkSLC3xxQFUr/zOxuf3XJeRB+0HV6i1wagU=;
	b=cOCdvZPyWgDCWeMzoF5sJlQAJDCJNnmSX8ktlBqwV2/DS/2OwrRAaYiGjUf5BVsoVpU5yZ
	WE+joqBeF46foipZwpYhO6+olSLTQXJA6wflfRpGL0Rm5Y0dyhov9H38kfGcsAEUQhEmrc
	H7v7kPsK7wI/M2naWYlkuct8wfmD3ts=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-313-C2qZq-3dOAyE4yqdehh28Q-1; Tue, 02 Sep 2025 04:04:24 -0400
X-MC-Unique: C2qZq-3dOAyE4yqdehh28Q-1
X-Mimecast-MFC-AGG-ID: C2qZq-3dOAyE4yqdehh28Q_1756800263
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3cbd6cd78efso2285640f8f.1
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 01:04:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756800263; x=1757405063;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iWRs8dmxjkSLC3xxQFUr/zOxuf3XJeRB+0HV6i1wagU=;
        b=imUZk8DHGgaUmA5s8WLe4EmLv/waDsts4Bwo4pbHD6sJCePqb6ZgPcu8kntmOjdzKl
         sy/YkSj7d1JOSzJml4HdInhiA5SDYL5mC5X7Ia9TzQrD6oRYsDhEPYzNlRjlVjimu3eT
         OVIUiRko/wSi6OiSgmsfEWeHPgGh0FxA7sgbPcr71zHfLoC9NB/qT7SEgE6118TV6nxX
         s9U5HETU+wJEqKC+/F/79u1E4oBs7S3Vz//xp49xCU+gFI1HwB9npfTzlf5UZ4/reK0e
         Q3jwQlk02RHle2FUSxa77Tee4tQvNLBSR/SCBUGBA+/VLceL81/2AaYWFHECmVthUesw
         3IWA==
X-Forwarded-Encrypted: i=1; AJvYcCVH8V1u2sYM6ZGuAgiDizqIq016oaW4r1HPhHCL1JLrTiKpcszyAV3ano7913U6NtFJYJ7wJ1xFYA==@kvack.org
X-Gm-Message-State: AOJu0YwySvyjnMOuZlhjSzPnheotL+DkAsTM3HdJSN2GdnoAAM0ozHky
	sfc89YMLOCruKtK7aYpizSyLp8B7R7Ow9vBoLtf/wbZb4pW2CPzPOQf93El4ymGllCZ9faUzTNW
	t41jdIgT/T2aPuBbdAVxE+RMoIf5jWUqPmK6jtRaEwogzXa0cNHoE
X-Gm-Gg: ASbGncsW5yT0XTqmtn0jeOfz4ln7G5cwiQNTfKCNp0JvCrNwyUwlUqN1nIGVH5BoPBe
	N1wfeiHcYh++K93ewwp2WtZ7kJRdSppQsCPAGYuBfO7rd3EJDgdLQXaYIBQBLJfx3bdEG22/e1f
	wasf64x6onxTg16OuVPVws3WDMGN1J+6QIVgo+HV6TAwGAmzad4XazXMlz3RpiPEtO8WLT+RE0W
	vBwqDsrb0x0MarJqUrriVVx596k7hut4iYExyAgZV1gf1Utbfusjuuax1e214F25/neAlCds1ri
	2mLbkRAU6nfKk0Zw+kApoxbfw7KgFgn/tUky5OVlad/b6wrSaQHg9PDXhyx/olCU5plNhvFEDNT
	CtCMKz5AV9csv4YfItTnsdyrI7Yed6iFB6C5OYwdfF6WMXdRh44WKdcIkyGjZr8FUDvM=
X-Received: by 2002:a05:6000:1ace:b0:3c4:bc55:65e1 with SMTP id ffacd0b85a97d-3d1dd434397mr8245289f8f.24.1756800263129;
        Tue, 02 Sep 2025 01:04:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE7tZ84tBomOiZJ2viM4EfuscitGcpK97LthdnhgXpe3SACLWjKyv/xkWV2kN4g7adtuOE+bw==
X-Received: by 2002:a05:6000:1ace:b0:3c4:bc55:65e1 with SMTP id ffacd0b85a97d-3d1dd434397mr8245260f8f.24.1756800262587;
        Tue, 02 Sep 2025 01:04:22 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:3f00:731a:f5e5:774e:d40c? (p200300d82f1f3f00731af5e5774ed40c.dip0.t-ipconnect.de. [2003:d8:2f1f:3f00:731a:f5e5:774e:d40c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e8ab14esm200784145e9.21.2025.09.02.01.04.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 01:04:21 -0700 (PDT)
Message-ID: <5529a696-4f6f-4bb9-9bc2-ba5f9f72ec8d@redhat.com>
Date: Tue, 2 Sep 2025 10:04:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 06/12] mm, s390: constify mapping related test/getter
 functions
To: Max Kellermann <max.kellermann@ionos.com>, akpm@linux-foundation.org,
 axelrasmussen@google.com, yuanchu@google.com, willy@infradead.org,
 hughd@google.com, mhocko@suse.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, vishal.moola@gmail.com,
 linux@armlinux.org.uk, James.Bottomley@HansenPartnership.com, deller@gmx.de,
 agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com, hca@linux.ibm.com,
 gor@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com,
 davem@davemloft.net, andreas@gaisler.com, dave.hansen@linux.intel.com,
 luto@kernel.org, peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, x86@kernel.org, hpa@zytor.com, chris@zankel.net,
 jcmvbkbc@gmail.com, viro@zeniv.linux.org.uk, brauner@kernel.org,
 jack@suse.cz, weixugc@google.com, baolin.wang@linux.alibaba.com,
 rientjes@google.com, shakeel.butt@linux.dev, thuth@redhat.com,
 broonie@kernel.org, osalvador@suse.de, jfalempe@redhat.com,
 mpe@ellerman.id.au, nysal@linux.ibm.com,
 linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20250901205021.3573313-1-max.kellermann@ionos.com>
 <20250901205021.3573313-7-max.kellermann@ionos.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250901205021.3573313-7-max.kellermann@ionos.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dtxqp22k_E8o95zwkrdyI6UiGUICOTtOqXNLEpmRXaI_1756800263
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 336CF18000D
X-Stat-Signature: ptdzfe6aechk6c9h1kbz7y6mxn3gwjd8
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756800266-352146
X-HE-Meta: U2FsdGVkX18tlNrJKB3X9tLyT98FfOVqPb88OgvIVAHZbhBbxA7bDoSI/3sAl4DcmRpExmBXcQzf3ZqJupCNZi9d+t80c4MbUzwnOiDLMQSY2TzmiUicfIOqdRiKHUOT2dhG3ss5nGGVjN7yCFlndhxN+otqzRZpypy5SBYS1DLqEMJUJfi6J5jfp3Brf3S8K74bULqYLQEhvFBO4uZ09mqzZW7pKz6v4CUfdpXnEmI1O8ilGZ/pc9Oe9sZHDlRVjUW6r5K3mWVDRtuAWmdC7aj4kC6l3sQ4fI5d5mqWnBQb0aF+fo9poVeOSuwxGPOtT2fOt2ydm6SHwTVtr0JPnFy/rjQnhmmt48mDpCNtdj5rztBdFRmOXLa3d+F8NQQswzIBAOzZI4BNVxuyCVOBVtFMULlLvTh+S0SIyrDeeUwDlYMHUaTHeMyWyIyjPghQrI2KLUi9bSVZOgFi4ijS0DbLFh2aYjVrJLXx0NhhWsL7g/peke/Jb2AwWHc7OZOG2A1SYI11KGZBqaVprAdJp+ZGEo2tVUOk2dD6PkYHzmxJljj942h33b4ofmhXoDfWZf0Rz4p0JciQwb/aAFQvQAt2zCAEJfwm6D3XEpt/TdCFqBC2mj853FPgpDeYn8Ndmk3z09QC3xwVt8braq6tbMmamsnSwlIibAWlvmEyQzfHDAQAaK+KZyw3Xh0c4NwKEVB+OcUpgpGvK+nkoWJfO5s8yYjkbgwkG3RlmFkx7Dl8cbUyo3b9QVvHjg1p5t9lQNC8fzcVO3V9BqqwlpEAYGg1GmuPsKZVj4D0xoy6fz9YKyJC0bCxbj6kU1D4Qu08tB4LF0uy/o0cR36/7SWxLI916IWOzZMsAExDIlQcO5PfeLM85YGnnIlNOvWbFuHikyL5rTg5rmL+eCDY/F26FyHTxsLF9Hq+doh7XAkzCQGC6qKxSNkrEmXcwJ8OnGzmHH41bsAekG83dhoZcoV
 qJMdv3Ij
 Q0eHMjUuP2G9Lq4nANuSj2o8zt2Ik6Wtj5dNJqYHIOnjUMEO/RcSNK/d7+JlWyx2k3sl9GDo7BdI4ML95n58hOia94Q+vrFwXeiQa8ATstgQL1odXqU4qnEjV53sdSYNILecVTY9c8ck0ploHGXvzLbuT64vkZHEkSSQhF5QOqwBzFgYw8rE2WjgJE3wtUnQaaYc9rsRl9AziW4myKt6nePj67x+Ppgv5+fUUAUrSgQhoX/e4U3sSL7JLvL8ptMjQ11FmPIOwrFK0MEaiATw8f/exNcj7qHxL8gS8QUBHCkELI0eCd0Z5WQPmMfaK7/ij2JFGFeE7wv+jnirOpxp42hnHluXU8J8n08sTvLyJ+W3vHCfOhAJugkBYsjOfaxi73VhMiG5/PteKCouHdzQf4O5qYFkS3woa2BdvvffT9WbhKqlW89dOtZPQxy1D+h/OsYl+r+/g1qFsIF9/RYEi0x+LWt1hUHuh66YORs/Z0f44NKEabtG30QVXn4izzAccLR+UvYfXJVuLX2QLRvW99sNQFdgXdzFK3hKNkGPp1ZhB14+np2nbpPSU2bmH6mzPTthF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 22:50, Max Kellermann wrote:
> For improved const-correctness.
> 
> We select certain test functions which either invoke each other,
> functions that are already const-ified, or no further functions.
> 
> It is therefore relatively trivial to const-ify them, which
> provides a basis for further const-ification further up the call
> stack.
> 
> (Even though seemingly unrelated, this also constifies the pointer
> parameter of mmap_is_legacy() in arch/s390/mm/mmap.c because a copy of
> the function exists in mm/util.c.)
> 
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


