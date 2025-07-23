Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 822CDC83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 08:05:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1157A6B0088; Wed, 23 Jul 2025 04:05:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C7996B0089; Wed, 23 Jul 2025 04:05:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF70B6B008A; Wed, 23 Jul 2025 04:05:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D9DD36B0088
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 04:05:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6C887BA2E0
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 08:05:47 +0000 (UTC)
X-FDA: 83694795534.23.838DF40
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1911FA0008
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 08:05:44 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MFe4RGK9;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753257945; a=rsa-sha256;
	cv=none;
	b=0DvMqjpTh6Z9kSMwK0rlT8RuOg9J9CeK1pVJoTJ0CRmI5CA1aI9jkH1f1aUa+cEdCkfYXw
	/pYhC6tQiYmomUmH6A+h38UA4qPBKdeGmSdAqvqn23WlBQ2nEu9V5TY0DRuDCyW7vV1sOp
	QeE3BP7lD+mPtZrh3bMlVRxQ8KBo/QU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MFe4RGK9;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753257945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1MDkeWmxyoVFcHmHc5Ml+3hXrUNIffMq/rZBas/7Tjc=;
	b=c7giomjd3o1KPE7jLNrI+PUKXJ6GM6/VfFRYb0GDRfT6FeEOAc2chwHzQIznH7JF99yiYD
	/OdL4uZKfdrDg+7I/17M/h0VuxR6Cp13VUSP0GYfdZz+ANiJWUJxqwElaNpbMn4aKwqUVu
	pYdCXDnrjZj+spv4yCYG/FQ5W/ZAxFE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753257944;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1MDkeWmxyoVFcHmHc5Ml+3hXrUNIffMq/rZBas/7Tjc=;
	b=MFe4RGK92YLl9olbU4+aYW5yA40E/7d83PByAFvYlQcOLpyaXS3BPa+88TtFLNDcbBrHIo
	a9HjHGtI4N1SfQASwprBUXkMsvQfEDeUcLSo73DxS7wWzJczvsrVeryPLNnhcwbTc9wE4I
	Sqz+9tAmtBNWPWyaLfVsvEY+qOJyRUM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-275-c42T56ebNoutcsXuuTWCGQ-1; Wed, 23 Jul 2025 04:05:41 -0400
X-MC-Unique: c42T56ebNoutcsXuuTWCGQ-1
X-Mimecast-MFC-AGG-ID: c42T56ebNoutcsXuuTWCGQ_1753257940
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45626532e27so42411935e9.1
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 01:05:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753257940; x=1753862740;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1MDkeWmxyoVFcHmHc5Ml+3hXrUNIffMq/rZBas/7Tjc=;
        b=nem+YG6gzXNrbSvEQuuzaQIUu+KnWigUibhSitQcNQXiEGtyTNXVmyeXfC6NdWIQ/9
         hC83vTX55F8dWnzVI9BY3m9IDoJ8l/V7he0qPmnQcbPCpZKU9ETuvvBsVH6hKLAmqegt
         VDbsT59yssz//M1VqjwTAYj55gmd/OR1LCEtTCP99MEKqNDxnojY828/Wvb/m2HjQDA/
         8vHGKqgrfKNWUMC8krnKPmnroqwZMu6kdBvrtXkBM71ql0RbPUPlSjfAexORtzSzYjF1
         zDaA95znNvyzCirYnR/CZ2F/HgxmE2XLrq2uytM2DrTz1UM2FXaN74gJZxzes+1jLWWX
         /XxA==
X-Forwarded-Encrypted: i=1; AJvYcCXzziaXQDlYP5gWnTyCuF0OUIefwMRuyYEWXXBBEkl8VCzqSJm0/sL/XshA7VQ8TOiL+x5CpySAGw==@kvack.org
X-Gm-Message-State: AOJu0Yx/LHYN2b58U2Vq46e+j9pmv28aES1v/EyNNHUvSvTOWJqR88UV
	auNF88tKJlQpzwdWxE0nVixjLo++tXDY8uhEWs59Lu8CYL8NmLR7gMulAHu08nwfHfT44tfL17Z
	hxz69qwVYDt3EVBfU1gPjqCMBbOaumBLx6o+Y9rftvTbDU7umg925
X-Gm-Gg: ASbGncvdJcCxWoL9U3B7fw13db2lvigznxQa7uWYxom6kAutQb6HB8eUeILjeIgBEhp
	G06ajzh7Yn3a8R0ObmHTPiXvcP6TWeQ+zEAyf7vZqHpEOwOmfNRU5+h4fSGhAdOEUHx/+abXsCP
	MEBfK/7+PWQH4IKT6afw6ewX2D5Ofit0oj97SFtq0T25QWBfVUWcirjCxRaiU76wIcJne88OBTD
	89iFIhocDY8XBEG5AUwiZocitXadD+8Yiwb/gUacrP4+YUBaPGXQknNNneo9/GFcqI7BEbIys+A
	4Si36upelPwA1uxmqx/C01Y/C9OmjGrKpldp/KN5xl3e4qgsfMed1uBEPa/HxsnEHFRz7a8EBIF
	AQZF6cUeX7nR5wD31ZTls6KyT6YUpmmzqVCMAHKSK5yo6wH9RJzm1r3498R8JXxTTTD8=
X-Received: by 2002:a05:600c:a08e:b0:456:2ac6:ccc3 with SMTP id 5b1f17b1804b1-45868d6b040mr14029775e9.25.1753257939869;
        Wed, 23 Jul 2025 01:05:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGrPYLIbj2mPY9A575m8HAPyrIhR31gSEJiKJqJFhiM9K8YO2VigwJNsUvVl2NYwIjh9jmjYw==
X-Received: by 2002:a05:600c:a08e:b0:456:2ac6:ccc3 with SMTP id 5b1f17b1804b1-45868d6b040mr14029325e9.25.1753257939360;
        Wed, 23 Jul 2025 01:05:39 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f00:4000:a438:1541:1da1:723a? (p200300d82f004000a43815411da1723a.dip0.t-ipconnect.de. [2003:d8:2f00:4000:a438:1541:1da1:723a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4586918b436sm15026595e9.9.2025.07.23.01.05.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jul 2025 01:05:38 -0700 (PDT)
Message-ID: <119c3422-0bb1-4806-b81c-ccf1c7aeba4d@redhat.com>
Date: Wed, 23 Jul 2025 10:05:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: add stack trace when bad rss-counter state is
 detected
To: Xuanye Liu <liuqiye2025@163.com>, Kees Cook <kees@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250723072350.1742071-1-liuqiye2025@163.com>
 <202507230031.52B5C2B53@keescook>
 <c7a32d87-efbd-47bd-9a18-9eb51e441a7f@163.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <c7a32d87-efbd-47bd-9a18-9eb51e441a7f@163.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 22Lmc2oibUjxQ9JvO-uubVxZrV-_pogqymsx8qQgyHk_1753257940
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1911FA0008
X-Stat-Signature: w8ysw9hq964pe5yjq3bmrauc5d33azdq
X-HE-Tag: 1753257944-259961
X-HE-Meta: U2FsdGVkX1/TjjPhjvZ0OOK3bR2ZI8uuTDn8WpkwlWPTQyKBSYIx7rKYeg9msebbp6Xh69ZJwdCcV7n9E4PAHy6VRngTcU0xVQQ+9rPU0r4J42mcza/qxqUyxBPQjilE+Z/CaVrFsyRldKvtVOyqTHfxbl5D5VAgTEdjt0dyYiYnCjn0qqmDi/BP68w5gYCCTzdIVuC5RH5yE0pSND5il9DLahjaT0PuA7mORPIFZkVRgAyRSLUFaTaezIOeoyfvaxQHJm3FQ/L0VOUL9t4+hyMmBdiEc7K6uONTS5rl1bVyGCQ6kKs/tlzEBPk6sCJFFXJHblPr/eCuhxuSFvB9ECdvvf6ePkA5q5GXJNsntstDLzGQsDbAuU8B8AVVddrgCaRZ7LjpWsWZxKT18dATdcenTl/Y9YUcrb6JcbvbzOgSRn8sMVggP8MJ7iUxKkFv0YDwG4tEZQAVE7iT/az0NwPjcR8aaaFqJua8RVaOKT6OvCzu3v8/vfvOwpp7gqr3losvpxl8LM+80ATiWGievusZltCQwB+Gky9huSMuNLIb5ltkWy3NBvVL/KRUY4Ql+Sq4s4wmmB7CUTlH5iWGjkv/Hfy0PRspfzx20qMuopu6Pega80FXlJSKsWicewPdQl74aviC6nriDTCe6gC6+nWXz747/naLP8NMm2tCgkMPmqKHyPcuWjE1r/cIvGO6tDlvQ7quIdX+OWE9SXbfIpw/YcC9OkTBWCy07XBS+/5ju6YYZt0FH5lVQ8Y6MdSOVz7qe6H30EbVlWnE1Q+osOixIou7rSblKaK6VUNcLRMwCbx8VBC6Hhb6gDS6SJyNr3B4Fd9t/SUMzzLMWfMiBZKnDaXT4Y51m+5x7rDQsNjJQzghz5jY0IgleqM2AiQ3G5TmOkOkHg+d6+s7tWG+QXPBABZd9t79QTXf7U10Zb7/KFsokjWCv7eQlles3pTzgau10F/5ZzG0BK9h39s
 Ag8Giiy/
 wya7NlWj4BpWcb6P9aBfTyIt68zF+s1CTSu3NLrLuKE+sXFzXDA5eWA55ZtGK5cNwSWIqsvlrNRSqmXb5bp+uUyvf+to203KtYWHUabjZqRgpq50Fa1SVeYrJH9xWjq2eR+XkHpS1a/h8tR4a640M2FIIbgKcnjoGKHEEChy1l94fURYmvu9bpbT12Wbtkg58iREteg/DX25xtJGqL0kNErXH/5ZXVt1yNqsWAWI1UPdTEHceki1R5GLYbWXOa8XrhBNfPkd/69KNGIR7xaHyjGA5RO8KXr7Q2ulNXC+7nyjlyG8YgaxXtgv0sGcvyekAfEmsqhg5ZvbnDxFdc/9JUgEjZEkCgjugLoaJIL0YaTXfGhTRVhyfzDP+9nxjAs3Dw5wAfhdkNbBB/OZYVH9JzkZsOZhtNUz9bW09k3un7hxSRzfBJxw4nsbpFMRBIhhXMFBEz50jw7wkYJB6cRZSe5NaFkLIkHjW1kYnGJ956cj6rEg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23.07.25 09:45, Xuanye Liu wrote:
> 
> 在 2025/7/23 15:31, Kees Cook 写道:
>> On Wed, Jul 23, 2025 at 03:23:49PM +0800, Xuanye Liu wrote:
>>> The check_mm() function verifies the correctness of rss counters in
>>> struct mm_struct. Currently, it only prints an alert when a bad
>>> rss-counter state is detected, but lacks sufficient context for
>>> debugging.
>>>
>>> This patch adds a dump_stack() call to provide a stack trace when
>>> the rss-counter state is invalid. This helps developers identify
>>> where the corrupted mm_struct is being checked and trace the
>>> underlying cause of the inconsistency.
>> Why not just convert the pr_alert to a WARN?
> Good idea! I'll gather more feedback from others and then update to v2.

Makes sense to me.

-- 
Cheers,

David / dhildenb


