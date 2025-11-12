Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FECBCCFA18
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 03:40:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 336BD8E0008; Tue, 11 Nov 2025 22:40:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30E748E0002; Tue, 11 Nov 2025 22:40:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24B658E0008; Tue, 11 Nov 2025 22:40:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1499F8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 22:40:13 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AF6821DE129
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 03:40:12 +0000 (UTC)
X-FDA: 84100551864.03.9B0E803
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf14.hostedemail.com (Postfix) with ESMTP id AB81310000C
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 03:40:10 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BIPYPr+h;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762918810;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uk1xKl9hVOEOer9KHgmgb9FzMefwD8xwGbf+okGf4zc=;
	b=ICB3yML59wrEyCi0IxPOIALRBP22pEOWSLLMSVdclGcSsAXkCoHx7/jJ/8s6LJOPSzK3h2
	BlBNMXa3ed3uIxboXWzglqyYgphdPlXqSYRJzksbYQIggnqEjIPXmyIMHHBixF9bYazye5
	U1m9iZc8kCBtxzOwr/GOoGzRz2S0CH8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762918810; a=rsa-sha256;
	cv=none;
	b=mdXYETV1gbvdbkxlsG8GiqckvG3BOouVn3CPaH1b4mQ4sGAGtOsZiVzaP9aqWPjM97JIq/
	G0ewm7ws23EysHKNz3ynUgo6wFdRC/aEQs7dGrjwgm8/tKepCcxLpSW63OsX0uKh4j+pb2
	jDoSSxRCKNlbWogO38pcSdDaeMMY88Y=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BIPYPr+h;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b710601e659so70208866b.1
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 19:40:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762918809; x=1763523609; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uk1xKl9hVOEOer9KHgmgb9FzMefwD8xwGbf+okGf4zc=;
        b=BIPYPr+h9HhvJIE9ywILsr3c8ZfgKfAfWY06d2MMqwqMeLm2F9Qg+vDujh9F9X5oEJ
         WFhHg95wKwNraOrXyssP5b3rmR9iwGaVouxmxHnFo8tUNscuueZRkeJJajV3gVIgvRtx
         W0E71YCZLZeiSBZUz/HNgHFY+UEs7+H6btivwIMStVm3tlJanJKnZit5GfSTUhLk/oZP
         QS5NgTpzJ9spJsEgrRNSqsWmpK7UHyQQX+GsehP6xYIafi5EdZRuFpLYLhVzs/6e89C4
         YmZocfiTgJdeg14y9WBlS0eZC8rZ6PRJqZoi2krMtovJ+y2Oa/bE4Dq9ARlXO7mxH/pb
         4byg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762918809; x=1763523609;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uk1xKl9hVOEOer9KHgmgb9FzMefwD8xwGbf+okGf4zc=;
        b=GyJfnh1L8nMiccTvdW6icWKbEvW+FZGUOZqpMbBKeFWJS7p1t8etwnAQSbW9hGhDij
         2Y9fQDkefEJ11pUVpXJ63E4vKe5fSnQnsRDj/7Eq1FWHG4lOnrfNbuZym5w0/PXtlQF0
         Q8ja4VyUW9h9QdwG7/e+pLoMdE/1ZCudSLiru3SYFwI53UFX/g0uOuPjH00v+KP2qeQR
         94UW7CeYZXk1tiJ1cpawXlWfuBvrwrwdvWJrMXIKYnJG/3UOAfMDBsq4qgWRKxlOnNJX
         2+pCCght6+mQHyMFIdQESd3tyaDJ3LwUdQkdLYUGUOkLQHjmymLVaygYxC1GjHwFVw0W
         4Nfw==
X-Forwarded-Encrypted: i=1; AJvYcCWuHWcc8TF2ml61jehNQckCMuOd23IZ0djl4N+nzaw/9zceWxtUVwWaC3PZpiDR4hG+a8zj5u7aFQ==@kvack.org
X-Gm-Message-State: AOJu0YzNhG/dR3ds93xC93W0zZ2Pk7CCPYkCXgM0lifRi+QV38Opqrnt
	A0y/6DLUQsr+UzIfg2I4eOn9RLgcmgatqYOz0xha5GopXz1FU6TdWTnS
X-Gm-Gg: ASbGncvzI0RmMxmG9PTwxuvkgKsH5WsrDYm+Jq49Es1AcyxS9YJrM6hMEEi8YEAnPGu
	SyO64N7vIZ7C2AEvWl4d63FEbS0qsiQtKy4lPd/Wj0hz9o2leSIsyJgrbRY06kIPhGgTkjEUaa2
	jpJ2rztT8lJUsnjuEixKNCbfTCBjehO8aPfs+0Y84QH3azzB5cNLw7nQWf/Lwh+joMh7qQ7tqYX
	5NHp7kuLH42Vug2qFmIKw15gfn2IiUGej2Lbo4BKJMISzfhovV/8L5i3h3jmPUh0TCf57dm6QX7
	7jO79BiIDHXJKPb6C359XmTk2rArzVQkzuM5icQQomiYPHsCEufDsYMOju0v1YQKQzIOI8VaD8s
	mppsAbYlDVp5NoicNZ+Fclb0BxeD5xKp/RY5h0HCplR+zVlRKKg49r0lcDYn7fv21A2tjfiwVgi
	keCF/vlBwjttWaog==
X-Google-Smtp-Source: AGHT+IGcBpPZmpXKaktAd5SSQ3T611kRrVapSrbZd0YFzlbDuzM5j1vws0bsR2eGOyGgMXdGmRzEbA==
X-Received: by 2002:a17:907:9727:b0:b72:af1f:af5c with SMTP id a640c23a62f3a-b7331a4bf63mr141985766b.31.1762918808891;
        Tue, 11 Nov 2025 19:40:08 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b72bf9bd36csm1535716666b.61.2025.11.11.19.40.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 11 Nov 2025 19:40:08 -0800 (PST)
Date: Wed, 12 Nov 2025 03:40:08 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
	baolin.wang@linux.alibaba.com, dev.jain@arm.com,
	Liam.Howlett@oracle.com, ryan.roberts@arm.com, npache@redhat.com,
	baohua@kernel.org, akpm@linux-foundation.org, david@kernel.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com
Subject: Re: [PATCH] mm/khugepaged: continue to collapse on SCAN_PMD_NONE
Message-ID: <20251112034008.ojwghkko74psu65v@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251112020031.25350-1-richard.weiyang@gmail.com>
 <06096f8b-4da0-4b5c-af3c-fd8871437c16@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06096f8b-4da0-4b5c-af3c-fd8871437c16@linux.dev>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AB81310000C
X-Stat-Signature: h7i11n5ucwgq4a34tjbkqag6jes1n6ai
X-Rspam-User: 
X-HE-Tag: 1762918810-963634
X-HE-Meta: U2FsdGVkX18RuUR1o9hNEfBizF9RU7VDh6Sr3kNTxgE2r4imST3gbHNiw0Dl7qqVqQi5AV1LCBdRifqV2TpER51LrqSb7lbMPyc7ltqiKvEfCMvBiAMMBOLVqKwRV6kirvZ9/0yeR0CfIzMohfQ3EWorr1WQGhD3q9/uV6gclTfJeCNz6gvHdud3HEvT0yg+BiGrznzRpb8dlqRPuKdCJ4zFzffCGeE6li4cM/wYAkRx5MBlF8Ptq3uZgET/jNDOC7j6RxVskoS22DrU0fNBYhrhuQnzglUl+fBTnXvW0aYxDGIiX356VwU384kYZc0P9ogIWqgoHaJti8DgxWqcg/yo5BMdOJH8EUrqNEEKqKmZiXHPdLVORtWNOxB2tkqeTePIGiPUX26vLHgkPJxsxgmjtUfve45vZuQBxsCkB31X4tXcLBEfDtrs9IUfFGG8FW1SMWkhEEGbX3WrNMuQl+KR4W4TtF4ByRA/D3wN5MbRSbveTBErx3P2QRk46w+8kfGgOoFEzKAghc+5ZUUYz13jqTzzlYdKjEjhM9FgtTQNhCNS58xSGj93ImCWr+RCPBFRdR2QzuTjI0TbLLICoz0+M0deeIPm4Ka5ykIKyC1h2YohOVR2i+91GGJCMf3ynXfjLPr4SazO3l3jI29mrIS97EQzfeu4cSPjpg3DhYfZehZgsBo1SccCy9kAOpImlj929lVnVvun6KgMOXyVxcLoohjJS86H0VeCJhI81/hdqNFxVqGX6CDnwbPppgYXO7Z2ncLgKG2reJY3tU/cy7upre99lvYN4dO36Svs4kYWDEqldAsj4qWuViPpaOkyZGLttAbVkD51m8X3Z7ce84vmeTOoo6kAuJehmT3yeE9Ilyg711BbFyxSfGFMJ0E3TskxuemPPdnkZhNef8RDIEypsDSkuqCnkedg/4DTfFd5dFt+DYnWfP3oFlS/HtZlmKfh8TWk7rCtwd7T6rK
 Gwgg1gaU
 2ErHEQ48EEEW8WVuX+eMja3BCfFgexnZoKR0bcDClbmoiAwHOvminBXSwMZU3G5krQOOs9whYUtT05ARyeH3/PGdlRkHbIAT+jOi0xzlAJ9YD7yq9Eai1FlpVF1Q+QTk/RTeW+e/1l43Yd6Ho9CvLM6O7JBMPPB2d0FPdZbv63stb4KyDRaI8jBGadXMgnFL92wPaYWgODxLktsAI5fxGFswzlKWe8kOCcpEz2wAYW4x4DYxoUIaKf9I+bWPawssqiKzL/MAhms8vi63Q3IfkXkiZ3eUXmb7hbx59bLOnsPkmk29wtsw7hNMMCsC7g4K37Tn2Ze7Y3NQ+l4X8p0bC5MKq73ybcb5JbyjrDokklsCcKUWPPe9NlEzkWLcZrT5i6znQznhXiihuiK7y406j9RXTsHmxOqR8dkY24DpP9awCRj/DUgs09P0UQLP01NrYPz/67NBpE8I0uVw1BVzZsY5x9fnXqwUTx6eu01WzRZqBf/294N7xQyjbuTULAXSMvRBWFN2mjHWWBapxOWrPggCfdmpC0UAveYuLJyFt+HDgcoJZLd2wPrUfnNwRujV6tFZZABuNVFJNSTY+3uqxA5tPWqynIigu3cBjG98Ki60MG9lJyKVxJy/RVKlwFCCd+JGhEUDTynOovWoy9+T8P9fMnSr/Qz8XlopOqP6Ao/I8hrLceWE7poMisiOErQ2r3X6K3D+28PLt5Po8ImULrnuPwkv0qvc0ttUfO2o9ufJctRmXKcrmsoP8XBlM1vTt8ZEmC62ek9ZnnIURU+VhLpS6mw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 12, 2025 at 10:37:06AM +0800, Lance Yang wrote:
>
>
>On 2025/11/12 10:00, Wei Yang wrote:
>> SCAN_PMD_NONE means current pmd is empty, but we can still continue
>> collapse next pmd range.
>
>Right, bailing out of the whole MADV_COLLAPSE request just because
>we encounter one empty PMD is too strict ...
>
>It makes sense to treat SCAN_PMD_NONE like the other whitelisted cases
>(e.g., SCAN_PMD_NULL).
>> 
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> ---
>
>LGTM.
>
>Reviewed-by: Lance Yang <lance.yang@linux.dev>
>

Thanks for the review.

I'm currently evaluating the use of SCAN_NULL versus SCAN_NONE. It seems their
usage in the current code is intermixed, and I'm questioning if there's a
strong, practical reason to maintain a distinction between these two states.
Should they be unified?


-- 
Wei Yang
Help you, Help me

