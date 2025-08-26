Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C13ECA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 13:14:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6779C8E00D6; Tue, 26 Aug 2025 09:14:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 627B48E00A8; Tue, 26 Aug 2025 09:14:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C87F8E00D6; Tue, 26 Aug 2025 09:14:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 34EAC8E00A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:14:58 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EBC0DC0806
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:14:57 +0000 (UTC)
X-FDA: 83818953834.16.DAF18F3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6668DC0005
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:14:55 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Nn2ZGpIK;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756214095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h4qLg0Z7RJeXZ+liB2F7ZceD3X4eKwxABDfUe0psFqw=;
	b=0IDFD+UxSbSc35mv7uoFLQsmswPHjsHjGYorBoNEZ/IhYttOzvKtMY3NZ/L3vgXgBdykhA
	/miPGp6vP4TgkQDCToo//Br2YhXoX5r76ubDsc0q02vCMCii3pWbdUAYKGPpJAAn5RJpGr
	gIZscqUP7nEKzUknT5fisg+u7S+Y4kQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756214095; a=rsa-sha256;
	cv=none;
	b=tpmx6OFTquoa9xWo0il5rrP5m6RNsjmnoOqlDvYPhcl3Wd7w8o37HXYFI9Z4aXZnGE+jrc
	UIXxMZlH/kW3hOzM3H5crYuJZKaxF8nS1pLZeejagu+qJ1T4HJ1xRZGHxuOu+iR8U3gaD+
	6iGfAS6KnwkhgK32m/aSuFR/3lPLtI8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Nn2ZGpIK;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756214094;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=h4qLg0Z7RJeXZ+liB2F7ZceD3X4eKwxABDfUe0psFqw=;
	b=Nn2ZGpIK+DaiBP1HFDasRl/CT14T2SMrm5F2HFrC6Hv+zFw06gvWKcMOX57z1g9fAO4QGG
	VOuzQoeZEGjNIvDL6UwaJko0KAZl/PhqBMe2uNLsIDi2cEGKP6nR4DhWuiSKwoqyVfUYMd
	TRUezGqsoXGtdoc4RwBt/p5jov1Ckvw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-505-cZ49huGFO1ez5Won9ndG5Q-1; Tue, 26 Aug 2025 09:14:51 -0400
X-MC-Unique: cZ49huGFO1ez5Won9ndG5Q-1
X-Mimecast-MFC-AGG-ID: cZ49huGFO1ez5Won9ndG5Q_1756214090
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3c6abcfd303so327939f8f.3
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 06:14:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756214090; x=1756818890;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h4qLg0Z7RJeXZ+liB2F7ZceD3X4eKwxABDfUe0psFqw=;
        b=WihzeAP0YXBAL0a0VuHvt7XhBihg/kXkKTmOgoU+0x/9OkqB5d+G7YbkZ/EzHfuiDb
         BJorImDlJJp9yvnq63ywwqjjXUUoZIMndtE32GfabI1H4RamiW7cgjpHlLJHbNVVhylq
         DHnocgmj+Q2MsmkkaQrqzRy7YMjVhsMeyihZ2FceBtdE6PNRAJm3li4o9kiNjHYPQkV3
         7KEi2wfmGk8PjqRMkYs+g8HPeaCU2BMOE+Sahz6rZUeQmc+9B8fKocGnSrLlFKYVcoig
         pQUGQQukTDB6eUdvbK0RE0lOIIJYP1tHqrL6oIEC0Q8CO0Xn/rtoU1YPTGZ203+0PS6b
         zi/Q==
X-Forwarded-Encrypted: i=1; AJvYcCUw4Z/4MVTeNXLnW7ob8nCEz9FTTsjbKCtxZXR2Vg/H/rXs7F+FSGYms0t/4oAOFeocyYVqJfRcDQ==@kvack.org
X-Gm-Message-State: AOJu0Yzfii3YxTGRmgBzhBKjukLvrDEwW333WWR4k8gkavBKGj7re6ia
	6w0ZkKUTvqiG2jH+bFc6zZIExqqZx+OTjfSiw329Zp/6vEBbC0SjTFHDxnkv4s+z7Sy4g44/OHR
	stsH0oR5MKiCxcZa/sEeqk3XQN6Xr8fqdVTMLqNpcr2XdFYxPmspT
X-Gm-Gg: ASbGncsI+yVC+xn8Q44LDqgiUbyB9Gi+AAUsezMYIeGQjWXkPpOu6pSPITfxuV7X4rE
	lWRPCaJJb5qUVuIfKxgnQ4EbAVGaARqv6WFHVTSsgolmYa8J9JwXvR8y84kZVIHj18UENNew2xA
	/zLWr6+VKLo9COkxl33beTc3F82ONBVlMktS4j4uLAvPHYziwF7M7aWKYXhaga6TywSJaj0gCgI
	vLjgOg4N6U5Ru9r98dMQODEGCYAccUhk/9XIpEtua74j1YJKSy05xR9tV8IKBTwEW0mrf3HY5fC
	dPJiBxwePB1wloQOwoXWt5oXb+PyNDuWL+tXsSLafvNz+HqPl30r7MM7iiboxOyW51qvWkosAQ=
	=
X-Received: by 2002:a05:6000:250a:b0:3ca:3b3f:ecac with SMTP id ffacd0b85a97d-3ca3b3ff253mr4644641f8f.51.1756214090139;
        Tue, 26 Aug 2025 06:14:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFBxiix9EiCqvJBpQQjXaUA1N0jkH3xcoDAAfi7RmH608N/z47kGY7AKF95A+U1U8bw2sBezQ==
X-Received: by 2002:a05:6000:250a:b0:3ca:3b3f:ecac with SMTP id ffacd0b85a97d-3ca3b3ff253mr4644587f8f.51.1756214089584;
        Tue, 26 Aug 2025 06:14:49 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c70ef55aabsm15821870f8f.23.2025.08.26.06.14.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 06:14:49 -0700 (PDT)
Message-ID: <c0b20bf5-5224-4aa4-b76e-22c6826c3632@redhat.com>
Date: Tue, 26 Aug 2025 15:14:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/10] mm: replace mm->flags with bitmap entirely and set
 to 64 bits
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, "David S . Miller"
 <davem@davemloft.net>, Andreas Larsson <andreas@gaisler.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski
 <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, "H . Peter Anvin" <hpa@zytor.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 Kan Liang <kan.liang@linux.intel.com>, Masami Hiramatsu
 <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Matthew Wilcox <willy@infradead.org>,
 Mateusz Guzik <mjguzik@gmail.com>, linux-s390@vger.kernel.org,
 linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org
References: <cover.1755012943.git.lorenzo.stoakes@oracle.com>
 <e1f6654e016d36c43959764b01355736c5cbcdf8.1755012943.git.lorenzo.stoakes@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <e1f6654e016d36c43959764b01355736c5cbcdf8.1755012943.git.lorenzo.stoakes@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Wc3LYoboDW4KSquff9Tjg5DU8hqDUw1kpub9XhXtBd8_1756214090
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6668DC0005
X-Stat-Signature: 3gna7j7bicbm8qranx1yr4qetw89u8pm
X-HE-Tag: 1756214095-796864
X-HE-Meta: U2FsdGVkX1/QFpfr6vrUqlLzpdB5MRQAHwD5EVYUJOuU0dM6ntjRG0lwPkT+PUI5eQT9THaA8CMfNk1kzqwU1RDkacICzo6OOwIVp5dja4WeJO/Kp2EhCRmcORcKL2AqGDHqGFFUxD25VkrARaJ9ynYuWR5DoYy1hJtiU1EsEQ0E5JLRVJ/KKjAdu1fE7sp5oNmpQCukYapwFl1VnBNSLH6ZXjzHMnARkdMYXHcKN/b/l9Trt28IFGnFDyMDugHkz1AkLLJS15sacCqz6J4MuE6+ZXB49aLEmEmGISWBKGugm8GvObgX625sH0LkOojINSSn6UBjnb0dN7OyRgcVRse7jJ79qmlq7bPBZ4lBlc0fUgMhZdZi9prSwBuhigvPEPndMIQjjfI1Iy29uBZPuXO4xqHdhnFM6FP/Wl5PJqBvaSOH3YtWBIBjH6LBnlmTkU8s7gKqgT7qhdvrKsTK1w1bHQPI31Fvx5vKTZk05+iAml1Lr1cJQtcw6xS7FrxOQB2iGiU7Iqq/Us1u2pfaOyEXpBZG/F+CrOSPTi4OXCAYZJ06nTMhIKgo6/k/787OB/UoKEChkwBKFHNKsJ6eq/0v0vQW94nSbBVqQBA8cmbNHzRDq6S/AFtSF/Ea8U0s/e23J1uFDrXAEtVwEjy8VgeKb/GH5kkBvR2vE20x2asEcO/VsNHTqVvnjhXMmdo4M3u7IXJ5sOzUHXvz3+YGSRCjUe51LmEx62hq8/jPi/trkP7XqCwpOb4RmbN0Uaf+znf5vYSlklP+gSXc8hIjEBiOoRs+BxTHDJX4RG/MRv8S0fX3vwh3Q+bIqaSJyFA5Pe8fsq0mRSDY/y/jmZvZuSBALbWU/tOHbAX1c3Wv4vUkKYFr3rboVJrxCqTBRUpTzrQPx82EWexQNDyrIG3cQFAXxVHWZq0n0Ef9S5WX3TIvoBDCMZsIqZ3STEYBjp7rIn3fb6qY5rhQMcCqofN
 fpWpEwqO
 wbwL80s4faQfcWj1wDA0rGR9Jxqr4FYtKlg6y6QUYQiPCbnEbYsnzTsjPC7Sn3uUmNTYYGw/V2hJrpWs8c5DcdtbYGAIYONwIacdREykx3mbwqpN8mvtSEgXxed6TceVUrscH+l8XjBX7s0y95+wkl50J9Hbx3yIsrCva9U8VGiGV2d1LJGpW+7dJAIZYUDCdRqZsh+fD5LhpAotX+p1nluvH6+i432RAJMLeQSGI5tWGqZ+qnP4IJPKZH4EUmreZJkEt9gC1NkfV2gBu7UA9vfeJYS9PprK6K1qXozN5HetFhIjwcmO9kxM+tCHZkjIRBP8MFplqP+aPbC5UXshaAW0CMdRA/WEM/wPO2ztx9G0CHCsBPsWLjItZA+OZiIsEM/LRNgSbqu5zZxSHiqlTMpXtPg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.08.25 17:44, Lorenzo Stoakes wrote:
> Now we have updated all users of mm->flags to use the bitmap accessors,
> repalce it with the bitmap version entirely.
> 
> We are then able to move to having 64 bits of mm->flags on both 32-bit and
> 64-bit architectures.
> 
> We also update the VMA userland tests to ensure that everything remains
> functional there.
> 
> No functional changes intended, other than there now being 64 bits of
> available mm_struct flags.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>   include/linux/mm.h               | 12 ++++++------
>   include/linux/mm_types.h         | 14 +++++---------
>   include/linux/sched/coredump.h   |  2 +-
>   tools/testing/vma/vma_internal.h | 19 +++++++++++++++++--
>   4 files changed, 29 insertions(+), 18 deletions(-)

The vma test code duplication is still making me sad ... but I'll get 
over it I'm sure.

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


