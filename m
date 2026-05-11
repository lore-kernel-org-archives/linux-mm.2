Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5E47CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 12:23:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 156CC6B00CA; Mon, 11 May 2026 08:23:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 107786B00CD; Mon, 11 May 2026 08:23:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0455C6B00CE; Mon, 11 May 2026 08:23:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E90D66B00CA
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:23:56 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B13C8406A7
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:23:56 +0000 (UTC)
X-FDA: 84755055672.11.80C88EF
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf30.hostedemail.com (Postfix) with ESMTP id D3EE08000E
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:23:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=NpTUmzRh;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778502235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SbDN36wYJgxGt3TTHtTOmeJ9TYm+E0HO25r62nJLJVw=;
	b=QFruJ9/6S8Rt3Elz+s4r+Cn3z7LmT6eoNgv7gnJ+2lC8lTq/LhopCNp6GUcq2PNda9LHFD
	1pzS+XDE7QzkPyR79dvIGEzkUZtRa5Hx+y/nC0FZr2Gz8TJPtzLKjUJabZS1P0L6wS/NFn
	8XKxFImOM4EmmsIOdtxTCBzREALf1RE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778502235; a=rsa-sha256;
	cv=none;
	b=6EW94s3jVGo2Xm/+JwyMls35UlZnt0QL9KWZOKnzmKDmJE2wHoloPEmyGPz7IWSCz4iZU4
	Z6X//uyf17ylxSbQnZyPND5R9I0S2lv31QcAfGnPU0kOR5VE7D934WYEHZs1qH1JapXCeM
	n0VWTd+MXn6xxOUy6C8P1bLxmdBMGnQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=NpTUmzRh;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=mhocko@suse.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-488a9033b2cso39251775e9.2
        for <linux-mm@kvack.org>; Mon, 11 May 2026 05:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1778502233; x=1779107033; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SbDN36wYJgxGt3TTHtTOmeJ9TYm+E0HO25r62nJLJVw=;
        b=NpTUmzRhEVYBGonNs1Mm5lkuS1GY01KfL9XA189ufVHGjeeg6gPgFnz+cRWuLODkch
         g0WEzAWru5xevIZansg9mno3vld7Nb8SERYQUoTGZn6W+WjuPcTWIz6A9E48HrYXU4kT
         rLhsCUM0B+B3mwTIW4TYPLYJW+XfSqWjxrzCMJp153wfq6+9rPjoVks8LDYREjy4XFZC
         iJi+sHGgiNYIv71ddAhvz5aJcOrl3ou8F9wc/Ikdf6jnC8pFIIHMQ3hjNDtjJe7T76qF
         9r8jcgMzkZKMQrqQN6bSzBIpXzEnRbADAb0BadrwnZcpN377Mh1U9mIHV/hXP0Mq8B5P
         QmGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778502233; x=1779107033;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SbDN36wYJgxGt3TTHtTOmeJ9TYm+E0HO25r62nJLJVw=;
        b=OUygpdKCtVFKqpb30F+fbUDOUTFhtu3ZLLeghFDvZRGbjFEoPixtAGapKNQMC10612
         qU6dg5XCd7iJSjeTHJ3B8uKpAvEe7wP0telcuf7i1UegFs1PgPI5a7droRyip+6DxvFc
         3m09aBuWL895dHuH1JYy3fVrH1E4QunMeWYBibFuMtVWkIPoKpjDa8gCaqPDODZ6FLvQ
         1MxTRQJxz0qQ+K+crOLygR5FSIJQfJOnAOsbyl9e2pT3n/IDds2BzKyc0/TTktKrrT2G
         96FF6OdJoTJHqr9jLYyaW6riQEWYdHhLKQcinpfTBD5R3OwSMY7drhHbR/Q0ziPei/hP
         edSg==
X-Forwarded-Encrypted: i=1; AFNElJ+NvjjCoq2MHe8TFdCO4dTBrmyCnPW5N6uOylo/7sOY/ne7rqY59uXPKGk9rUIx2EffYlSapWEgWw==@kvack.org
X-Gm-Message-State: AOJu0YwVLyqi/7GUdf1J6oHm1uvxgkyhNTc6cWwS0cb1kq8itU9SKtyH
	JGx+jCSJUDiiLyTKsytwBke/q5yxeNZ26F4NsUw2ZuZ7SfwpH+ax85/pA3GWt4NmKPs=
X-Gm-Gg: Acq92OHWwe2ugoKYc1Q2EMePqxHc8wmu7EzAFxykWYJ8aE+1gJw/WiFekZoxaIGz3gS
	704nDJlARDmyt6A/uZn97PNWkfLLmUZCC9DxP2SBLS+wgEJMBa/BXVBVV1f3FYklRjxS80lyRHO
	Tzd0jv/o1sdNMd3C3u0IdKCjw0I0K33wOQurCQJerQOTJqtMp7LpjEEEBVavXeY4VqKk5zq3icn
	s8Fr8gSdUoMlZfQvdXe5kwuet0b69u8dUukiw6BSQAxmqdM8yI9GhdwjZXnHsdzZBCjIr1fEHvD
	akivp+oFUJgvfvkJXrrg4f0Dn+CrjK/WRX0gzRXIScSaNgwXFY67wZHc4Cx/l2zrPBZCeCwN7Ys
	iY8o5XmdZhJsoylrMkHOR114fI6YWMrBmXxEsL+p5KYf38YrAgyG/B1P5Rb78zYkfN6R4+8iyVg
	wJBsFVzBz0y4e3bhp8KizZ8/GcRJ20dzhjPaNT
X-Received: by 2002:a05:600c:19c8:b0:489:1c2d:211e with SMTP id 5b1f17b1804b1-48e70687ed2mr158853185e9.5.1778502233329;
        Mon, 11 May 2026 05:23:53 -0700 (PDT)
Received: from localhost (109-81-87-110.rct.o2.cz. [109.81.87.110])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e6d8946a5sm107220655e9.0.2026.05.11.05.23.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 05:23:53 -0700 (PDT)
Date: Mon, 11 May 2026 14:23:52 +0200
From: Michal Hocko <mhocko@suse.com>
To: Zhen Ni <zhen.ni@easystack.cn>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 0/3] mm/page_owner: add filter infrastructure for
 print_mode and NUMA filtering
Message-ID: <agHKWCw3CFO0CZ_E@tiehlicka>
References: <20260511033017.747781-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511033017.747781-1-zhen.ni@easystack.cn>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D3EE08000E
X-Stat-Signature: x57gsrc75zq9gor5bb6q1ro6ap76tuwe
X-Rspam-User: 
X-HE-Tag: 1778502234-427745
X-HE-Meta: U2FsdGVkX18RX2ERTGL7w54EcCSR2kExPW7ccKV36S9kLbdGchh0exlp7HcLuZl96jH10cPuO/VPMZxyQl+F/GS6kRRZsRSg9GMWOcjfhRojA4CopW/kTBbd0e8bcDPlY6NzS+SxYX6e4oX2zNRvcsM2LfQejYjw72udY3MPdvDkWJ3yzaAsiYO9Vnk7rI4yWUilJCrJ4ovCV/kWe1riHwSI733qHh6GDIDF9falWrtZMXNEheW362WMkgXVim8L/STw0zUtxaYrcKGGIV/9GbtPRdJ6fb9MYnzlAUhEgmCNn5UfIQOnTEdHc/yzbRysXRc1Gr575y7gQNidv+JIFw0ef7IOouO+DdTdYcC0QrzmrDuNlfXoR25nv2F5C+yPULN80M/r/o3tJ63jMk0BvxHTWWFa3AN5wyEt0dOZ5hGhuesRAiXlc9YJjzuJEz1fFRpNfqJ3Dl+Xc3oPVUoiYpCWk7cMHn6flsyE+14B4iwjmEaj7dsM7CvXF1jpiPP3IfZNnvrHbBSMIzYz5lk89/9y69+sqPYoqey19CN2np15YuGWf5c3n4r7gWXNMxfXjDlqbrwbIX4lHsAkRoSBjWOYKWy7KHnsVoKhMjWjTtJIHT+bHbpNCE5b2jZ20yp4sjPNhQXF2tFl8ohAvqHa2vYyJJuutYIvbKg6bM+VxumiZacPgMS9QeNpUBdgEZnstUtPKZONd1FafHHa9ZdOZhv20+OrhPaMUQGDmj0aauVt3ocAozfwtBnjLU/DSk31l2TSrW44JPW5U+/XBCwFfwN+AmlaE1Ec1ViOBJanxUXKv+G8FMJqXKbgr7Yt4shs9W4ll8LxfY5tIqnCq4iC7rYNu3OwaVpAICD6FMGHbT2W0RaTl05ovz9e+aLwpZiTiRmzrX0ypJraYtvs5FR9BSR8MBgCRUlgKpjjaqkLscUw601zRlfmqv8czuQYve3SaB7t5BUYLrrIGMKpswG
 94lH/LTc
 /JlqBrkpnhn+v5iVpCnr68NQ1ObO9HPZHvWg1KvwF+3FY07foUtYc7RCIHSTeGb2w74urEUPV5M85OFxx7BrkVeMWVwZql5gViXYf+OOEzGcGZrKvA369zH1OLC76MQ5/15ah9bh1YZjnR/YSJUSW7POz+c1CR3n13HCNgZzx/QAgLQNUAa4jkm8HOWKrYVzJaL7Z0EmoYCvUbSL6J9Am5vYolkmzdnsxaZo5XVG/SybzNIyQpkU9j6wP+ju8mxxKWuvy90jc/ukrQN7eUrzp/jIq922vO98UOiRab/xPpfzW6wtwO/inbCEA6E+3mpwghT7/RdPFfhAokkFTwjyikPsC2a4dG4JAJCLBRu1fojFLaE7kBu3P2ZlTwVT192/Z6KbQ4b9PhmqsxtwcM9LTBtPNZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 11-05-26 11:30:14, Zhen Ni wrote:
> Solution
> ========
> 
> This patch series introduces a flexible filter infrastructure with
> two initial filters:
> 
> 1. **Print Mode Filter**: Outputs only stack handles instead of
>    full stack traces. The handle-to-stack mapping can be retrieved
>    from the existing show_stacks_handles interface. This dramatically
>    reduces output size while preserving all allocation metadata.
> 
> 2. **NUMA Node Filter**: Allows filtering pages by specific NUMA node(s)
>    using flexible nodelist format, enabling targeted analysis of memory
>    issues in NUMA-aware deployments.

How does this work when there are multiple consumers of the interface?
E.g per numa tool to watch node lock page_owner information?

-- 
Michal Hocko
SUSE Labs

