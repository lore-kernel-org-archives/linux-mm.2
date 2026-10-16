Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1789CCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 08:57:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE2EF6B0098; Fri, 16 Oct 2026 04:57:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBAC26B0099; Fri, 16 Oct 2026 04:57:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF7996B009B; Fri, 16 Oct 2026 04:57:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A81D56B0098
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 04:57:26 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3A2AE4036E
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 08:57:26 +0000 (UTC)
X-FDA: 85327885692.15.8136907
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf01.hostedemail.com (Postfix) with ESMTP id 50B0440005
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 08:57:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LbQdULI9;
	spf=pass (imf01.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792141044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x/q2L7BS45aTpoyNh7m1QrG5eRubgbrBzhsyuMzS0/Y=;
	b=kLZji2JSrzjDpA+CefpZxRQl1O4t3i9mKhVyfAvilyo3oOZMzIO538HI/b62QbSiDyn1SY
	8dTqMb+6wv12LEwUPKcxUqQFcMNGQqQfLdt8930lJWH2p4lH4vXlR0N15ZOVUhx9wQjJSD
	08s2XHgyl6K0+c5RxnH+Gaw8JV9bmxU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792141044;
	b=EMeTLBHT1/uYfT5Be3E4zoI5m3zijuDDMgH3tpRww8YsQNbZ9qnHXR86xCfi0DEcrghDEA
	+ltP6StlmpL0PX14XoyescwPh+04xzx66MUbCQlPppPjQsLloJqC6tLsRuhLbFBMcBQ2RX
	Lr6+8CY/z3lZfCvmI4xYblwL6j2OSQM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LbQdULI9;
	spf=pass (imf01.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-487049569b6so4284474f8f.1
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 01:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792141043; x=1792745843; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x/q2L7BS45aTpoyNh7m1QrG5eRubgbrBzhsyuMzS0/Y=;
        b=LbQdULI9dZPA7fs+MG954Gve/7AMXIjnmm/68/L876D9+LsZARG3LpEH6fIicEVt2/
         nXAyL1NDAaw9Ps3zQfYJRsoRuOASbri1Xv0wh4Lj1FjOU5JqAxeyDftwEWEzk0DtKKVN
         t/Ej8PB9+Fexn7oBu8WrvkkZa/xdwUkjyHef3fo1lylzeL2uAecDI1ks6PVVWsYE7JK0
         781Kh47KSA6wTYrrvDEqn2b8ziMbEIdVb6sgkNV41XebzjUuAiFbZbZNI2Iyp/lVCYLn
         Qmgh399KhWSB09YAGmluUYbaDC5pkwng/ouKzI2k9i6r31D6bMoMPmyNhzPeJNWqA+5s
         jMJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792141043; x=1792745843;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=x/q2L7BS45aTpoyNh7m1QrG5eRubgbrBzhsyuMzS0/Y=;
        b=owMmh4o4tHLxjjrRhRrOv/F7qP3v//Eg8eOcQzjmGlq32pfkdeNV5tQA7Y4gxSbipY
         Z6VP//o+piva/90HFJlc5x4XF/gGNQhw55zZklk/gocKV8TZJPVHqDoQAIpkQPHAQdRS
         RO7jM2BxH9DS3yKg2WhP9Gm29BAB5nv0hvpwiEJ8x1u7lE69SKT+ObNWgqweVr1PXz2F
         dD3gD0jzMawA6stBeWkFQvyO/JskMESpAQ69iXMLJKwFqN+0V1BTwJhPNuqPdiEhEYYJ
         sDm8LUurnsdjv5jSuqCN8xgmQ7P7ZUXmPJDLexa04Qmh8BAI1eiYeNqueAhl/oeHwJOo
         gDIg==
X-Forwarded-Encrypted: i=1; AKwUvBz9Rd6y+pgpNSXHbwm3sPq3C/SG9F21Bbz7SEDm6XoxfBn0khAWs8n+i862agfkBwRFMJtKjU9tzQ==@kvack.org
X-Gm-Message-State: AFq9FYKdvEsR+eGGazOOKRiQrdU++Wn5gYzyPhiNHRGLiTvkXXXOIB2/
	T5pIHCD2tGSMp7bjE5XMiThWAc5YwzEpK8lVUxxNL/fApeXgNi2tMnF8
X-Gm-Gg: AYBFou00O+IGZHeQK/uIzBLRwtYWVrNsU4ae/WKvfsrn8HjXfFijkSdaIpyDnYFy6Zl
	gZpp2VXCLG61QhmtI2QHYVr0sWg1N1j7X6d+9ceyU/fNSOkdks2Fykyh6+zjBYRrsAax/RMKNjS
	3GrN88oHSMDKlZHcYS5+sFR+WNeiXupnB+z4cALRoPOlVgpDePSrSZ/9Ivlpw0wrSOFFOQbV4ck
	cl3C/pBGlwy4tdbzK0MR+ELm/z7zL5PMskwv6PpI5MHvQl+yYd/vYrY/Ivl4bgMzvMmKucp2kTY
	FSZLJnpbTovkAvsHQ5m46m9RCaWY7bJRS9aM5vIXPCodZF57DKR/IrspGP8X0XA86E8lcAUgIY3
	AnrTVWFSK+E9txermJ6fczDMgxTIuv2kbc6Mvos+gS4ayonGRfUsxbsSsYJfKqlZO2sU8yOv7oq
	DQpatOGGkx5Vbx8yncmSCtHWErNZNT24a8oM3USb1gyYWEvJzMSLquPGKXaXGQXYCdlHtVY+57h
	S4XjeiRJBMw1p7icyFzHKghssc8kPot9dRzXrKO8eYoZi68Vtk=
X-Received: by 2002:a5d:5e8d:0:b0:48d:f7ef:721f with SMTP id ffacd0b85a97d-48df7ef72e4mr8636884f8f.11.1792141042620;
        Fri, 16 Oct 2026 01:57:22 -0700 (PDT)
Received: from [192.168.1.18] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfdcc0f20sm3509146f8f.11.2026.10.16.01.57.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2026 01:57:22 -0700 (PDT)
Message-ID: <eaeeaecd-f51a-4c2e-8439-36c7b8f6721b@gmail.com>
Date: Fri, 16 Oct 2026 10:57:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vma: avoid spurious write locks when mm->mm_lock_seq
 overflows
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Daehyeon Ko <4ncienth@gmail.com>, stable@vger.kernel.org
References: <20261015-fix-vma-lock-overflow-v1-1-01beb245d9da@kernel.org>
 <f5548d05-5aec-42d0-b9d9-c14fb575dec9@gmail.com> <atHa3-KlMPg6oy8v@gremlin>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <atHa3-KlMPg6oy8v@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 50B0440005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: j7x9xadsbsen4dz939zzzi55xjggwfu6
X-HE-Tag: 1792141044-56469
X-HE-Meta: U2FsdGVkX18mZSDsRdxYxPpPQG6qXJNuoIDngD5xctPmZnPbO6CHX/scEyJRwfCBJfXBDOLhhZDdhK6MkeqRRUcrFU9LdtAOPSKeNeZQV74mGlcqLJZUgYm5x6zesWrLizIhP4tD83Nus7RHXzCs/92g8SNjDfkH2nnqGxRbB5mUHr0IsmqMFMgmgRccVRrPaFoWnNO/Akx0kzJ2jDRq4MOXe6omc8opjjBAiJDm1YJ1VV2qVh8FWT3DaZnXiVg3dDY6bFhpN4wF6wn9/uPPDTYXklAx8xW6V+GUOqGp6+4D/JLJOSNk5J3jOXd6GrW90ar4nqakQf6EH3Hk63XRSY21SO8K4gFhlXRdpcS2aRRrdtI8xWMbr+IgldGEchjULcMyLgfYaSfRv7P6GQ6DEwGPzfoBk8l9Q4xVukjgt6HNACQRk1hdfziwKHcw+u264+4ssD1qPXoGvOeKAPb3OHDxK8ZwG9fE3CELNxPMx7Q0pCI7nbndwvRv/zgZ9L0YScbKD/oLM9NGpzl5LLX6F8cUNqzNf+CdiCcIenD9lX3QH0LE2kUJn4ldXKd1HCEPZBw2DXDTUQrwCIGRuiN9JJjAPpB6FJ8YwUIylGqaIojZZRo/Ya4T66K7xfvrlNKE1GrwyaqWKnRVvKLCyymy9W9t+DhMsDA9osMQJEtNHcqI7Ehq9ucfCfqVl+Ek2t1joPDLxHAGWREF4sigLWPq3fES1Ex62k3kIWrxC0YqeevOW4AeQLBF9//9hR/nadgyNbDGEDvblal4Ag3T7fd22qthBbkrqLJvV8V0a23dXWzca19txKGued4vZc3yEnsFSe0yMckwb5jKkQkkt4dR6l02zCUsqnNh3k5jA63wUHxDVL0fTNIrzZXL2OFOncg7UM7Gx94iyvpURwxykWFz/tI18NzlDUmT+OQXl/drf0AJJLs7lFmpASUOx8F4pJNKlfblPzsWdePR4x7eYsi
 K6BzNIPe
 OQasU/weGtIRvlC+tT1kG8yG8iVuhd8uyUW/N8sWl0bbaBzBXAbggmoxYvx8iVMR4701b3QqD9jzFE40QXMf5Ue6D1tawWWEZTK1OsW4d5Zb4NawVdDNSCsPry837nqoea3lEBoLj3sPeMy+mu0jmZNW49uY+/OIrTecU4zyfuhs/OjJ8jl8gt6zpljhSAlXP/F4EiehUXQ3q52q6lRqNkd5Jd4Bp1/sm1g1l6RiZbF8DuntzFD9uoZZ+lP3H/LwBnw2/RGVGORo3vCV6be9VMHoOCC33PUY5JErGqPvap3kZO6RKRAWPaNnIVc6pKcLwZ9qv2QrEVzaBQaJAi+Kg/11n0x1u/qmzKXak5xO0x2o5P64RUsxGFGqvwWiRYgv0POClr7R9dNwOlfQM0X8smMYMcJ3XEWJnOyaVgYxzE7kSPltSVX2WxQMz/Y5aGH3pTvu+d+nomAz/BG6azP5s/J0GahRuf7JYEp/9urDgOHlk0q+0wBF/0a0v6Fx0zwhcBesq7yoBrROiZ5BKHq2ghJUdSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/16/26 10:19 AM, Lorenzo Stoakes (ARM) wrote:
> It seems likely that you're using AI to generate these review points. Please do
> say if you're doing that, thanks.

yes, I used an LLM to find the commits I pointed out and check if my
reasoning was correct. my bad for not mentioning it. anyway, I reviewed
everything and checked that it was correct.

[snip]

>>> Cc: stable@vger.kernel.org
>>
>> the parity check relies on e5e7fb278e59. before that, mm_lock_seq only
>> increments on unlock, so locked values can be odd or even. should this
>> be limited to 6.14+, with a note that older trees need a different fix?
>> a straight backport of the odd check would ignore write locks taken on
>> even cycles.
> 
> I have a plan for older kernels (just make the value 64 bit...)

okay, I didn't know.

-- 
cheers,
jose a. p-a

