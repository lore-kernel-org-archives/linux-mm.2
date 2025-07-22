Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D094C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 19:50:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 267E56B0093; Tue, 22 Jul 2025 15:50:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 217436B0095; Tue, 22 Jul 2025 15:50:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DF7C6B0096; Tue, 22 Jul 2025 15:50:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EED316B0093
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:50:20 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5D57A591FD
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 19:50:20 +0000 (UTC)
X-FDA: 83692942200.21.783470D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 041681C000F
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 19:50:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eu2U6g49;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753213818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4CYJo6AX22LVhclJsQOSW3EWxZhNyBIePuLSfFpCwQI=;
	b=mJG4CJdzyCAWoV+jjKqltUXMdKjmfVfbkZ74VWpPc0E9pUg89ylISKVdEZW8Ow0R9UTSYN
	VZ8ynmDqC/tNPkVcyTvCNPhdGO0+jW27+/T91fkb0TXRagwhDFE2oqZ2BvrpgCxycOfKhA
	/hMZIhOv9M1fZoOk8rkW9lKUuFADvNw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753213818; a=rsa-sha256;
	cv=none;
	b=47Zq9f0Egw+O4LWdgrS2WPD5OFjhJigPs8vm9im1iQDlUJ8n16jS+CfmQNH2xlLMUbvR9f
	uMeIS/OwnwHthYlKlTSzRkJVyUL54etaRmDcZrzzHCkX91HWjEekvnjZGpWQS1gOexQBek
	RBK07tO+IdnnqL1qy6wcC8OIQjUX0no=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eu2U6g49;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753213817;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4CYJo6AX22LVhclJsQOSW3EWxZhNyBIePuLSfFpCwQI=;
	b=eu2U6g49YQiWZLlOobze6bFeGM2UrIAJWc0c+YBiaslgkpoHBIPcE4QxCoJ2+MtEgm7GoX
	3SRhD/+n0bSYi//XCPr7w3j5lAfrUy1uBG6A4j5zYwraNUxdcII3Q3L5rEodp8b3uREsmw
	snj2J+gCGhRHQzv/nqg5Y55tP8ijbsg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-163-e7bA9ecCO2iblDXL29AWjw-1; Tue, 22 Jul 2025 15:50:15 -0400
X-MC-Unique: e7bA9ecCO2iblDXL29AWjw-1
X-Mimecast-MFC-AGG-ID: e7bA9ecCO2iblDXL29AWjw_1753213814
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3a4f858bc5eso4726287f8f.0
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 12:50:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753213814; x=1753818614;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4CYJo6AX22LVhclJsQOSW3EWxZhNyBIePuLSfFpCwQI=;
        b=mQQxwBbEXZJ193zHBZXJGP0eoIZQhAGFjeuMGvHurx2Oup6OBhkDojMGMxY5zpnJki
         Lb/dTvBksHNPHPD0RMkWGmdp3BBUkSH3lN5tWkoousqNliGZ+us2hL1u3+t8tDzbI9ph
         6rujH4khXzauLQUiOWiWzUWzLKMtrBEq4Ayc9BHQkK5Xi0DN9uzDXKIMIh5Zw0/MvNQo
         wmHNsRpIi07u+R+3vVzN2myMVlnuXnzpNgSNg723ZJphJ6WN5VhLE3xuyWsP4e2g9HvF
         x3IsJ/zgJ5EjTbDmRtmD0NfNsmEsm7gxVmDzkXfBD9na6pCoz0rWSVYwkVP01Wh1mj3Z
         my0g==
X-Forwarded-Encrypted: i=1; AJvYcCVJ9pz55PSg9UnUiabzTQGhNdh1lHfrnmTwonVOLlkdj4WT3dR6L03+a0SmbWn95J6B0OQlLL4MBg==@kvack.org
X-Gm-Message-State: AOJu0YwNXw7mesvq3P4FdrgeIWokMqDcsLrZKb66DAtyl0vaQxyF5hU9
	zHM9wDdfNM9pfrHj2c0W1gejbbJIFWwmJxL1qWN0oWK70JBWMVZicj8CkaIO0HCxAcYnXD4ZEXv
	2YgkhTnZ1mG+uVso1njsdFUDIpEaOe0ew5ZzU4FY1AL9vJEaEU6bK
X-Gm-Gg: ASbGncsucnN4cIho48Dn9seTC2AtZ72DA5AOoT5pM/ybLlThBx8BzL9m0i0Gdvnjqx7
	xJAbJq3NWfCPYWx3xm49xxYB6wAeWYUc4RSCYErKhr18d+JQgdguEiL5eBNVSkNoARY7EhPyYpQ
	O5mulOTHKXalcmqGqHrxxnAk4+3A0K+9A4qz31mwzqj+y3E17Rwo6ewhP/fyH4newO2imMPku1k
	3XXWhGKteLobtZfQHiqn8pMrKG/S9YQHv0EypwsbjPVJAfgI7AUZgswtW64+dqHEtamTcWTLOal
	nsQpzhPhXorUKSbOvJnU5LU6xvHISy/z/LiBxq4wAf+3RHkc2E6qEblilereissRuoz4GB9i4NE
	EFWzXyQnF6n+cYCFUpmG+fUB+rN/rgkK8BJz9GyportNJd3QOjXUeg07aLswRExdHOJI=
X-Received: by 2002:a05:6000:2881:b0:3a4:d64a:3df6 with SMTP id ffacd0b85a97d-3b768ee04a6mr365284f8f.3.1753213813979;
        Tue, 22 Jul 2025 12:50:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGTGClSNX9mUSWtmXovYaFOq4uYjzpLv10wKGZfAItrjjD7uCRR5y1Y77Cn/0hc29Z3GFAHmA==
X-Received: by 2002:a05:6000:2881:b0:3a4:d64a:3df6 with SMTP id ffacd0b85a97d-3b768ee04a6mr365259f8f.3.1753213813446;
        Tue, 22 Jul 2025 12:50:13 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:de00:1efe:3ea4:63ba:1713? (p200300d82f28de001efe3ea463ba1713.dip0.t-ipconnect.de. [2003:d8:2f28:de00:1efe:3ea4:63ba:1713])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca4d7efsm14361183f8f.67.2025.07.22.12.50.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jul 2025 12:50:13 -0700 (PDT)
Message-ID: <38daa60c-927f-4076-b1b7-bf81c49deacd@redhat.com>
Date: Tue, 22 Jul 2025 21:50:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: remove
 trace_mm_alloc_contig_migrate_range_info()
To: Zi Yan <ziy@nvidia.com>, Richard Chang <richardycc@google.com>,
 linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, David Rientjes <rientjes@google.com>,
 Martin Liu <liumartin@google.com>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>
References: <20250722194649.4135191-1-ziy@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250722194649.4135191-1-ziy@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LTbGwaMoengTRdpfRJ62bRBDC3mQVHrD4BqYGDjfyLk_1753213814
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 041681C000F
X-Stat-Signature: 5oqz3zdifspmt88pjm1k3mw7mqhm1gxc
X-Rspam-User: 
X-HE-Tag: 1753213817-255621
X-HE-Meta: U2FsdGVkX19e1duDQJ1Olph6BA/DQeWzXCluak26fG50VL40YXj6Npju9b8oyoZFlBxcY8vrR7QWrNmJJZRViR87Vd8dXWLMT9HyU4jJUMhZ5xuz+9c2WIK/hDGawT+15Ljz7GJKWwIAiB8XwOuVPX/0QhmgYGduL7QHL1MpqWCjU0hjVQ9E2yS81maOXn3DbmNRPYyeWh54aOujAK2+ZoPxOdSXrEI6jarTAe/Rkvp8wUFPbZeKvAkqcmiaEuOhnROdfd4qY5kXnNhFi2AHpdsvkqsbMh/RNwwtUMQHZZVg2+5c3TLShP0jDgKz544tWX8b9g0cC5x8AbBVbjdgBwhZEnXmK2LkzVZlKC0KjNxTvJHWpqqESKPZ4QWgO7CSf63TEdP826EjAuePnxiRG3n1bhic+sLmFbaIALGNjQeN1Wgyh8gu4M6UW1YZG5mM79wjnFky+1l8WKbZT7oCTuKl3RQq034jszxaaxpecPz7ip94p/1liz8A2OFgxCxCTAZuOPmPYK6T6QeMHkyFLTxCI2mfUmFgdidS2zT15JQCAAhbojkkRI/OYgNe4HPP4b7R7XZmHiVDvOfb1PIe1ZKDt1xSqlskwSitgi5H3DTCWSkbcT636nhACcPsL0hj1eemYf0pX0NmUx4i2wxXl2eTgoutTG1qxrHvu282QQzhfFoIvWw8xLWnVxcDIcBvkf0Rk8bGsj5OZxh3D2nVtjhmbvRERKAIwj3mPDzhWvNjTBE/AeEP5psPyJi1yaT5QgZcXyTAgmZ31fZwJDmtnTBstknahRmSxFK0arYdg4c1LZj1NwEODYbcvGaBXGMw8LSjEJq68zHuuif8cTwgVJKZMTuluWsGieJe0WVlWD5ptY1qns8cDetD3B8rmflPkzH0rmO9593n/YuWGcR7NI9XnmCdl12/LgTM1820aTXNQib2LbmSn0368iTwY8Osn4ce1l9ooTKCU6zCb41
 epnqqB/o
 htUMOASMwqzu6HD9zZFnGikBJ3FigUkGXMnA27vb9xRwdnl9cfNqIMkJT1vQ1FAn3ceSCtGFYqv9M3sPntpiV7PSXX1npREOr/pXNBn94irTq7R+KTibjKNCT3+VeK+a66RTI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.07.25 21:46, Zi Yan wrote:
> The trace event has not recorded the right data since it was introduced
> at commit c8b360031218 ("mm: add alloc_contig_migrate_range allocation
> statistics"). Remove it.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202507220742.P3SaKlI6-lkp@intel.com/
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

Yeah, right call IMHO

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


