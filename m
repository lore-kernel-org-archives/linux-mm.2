Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4A66C98324
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 08:24:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A3BC6B0088; Sun, 27 Sep 2026 04:24:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 655326B008A; Sun, 27 Sep 2026 04:24:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 543C16B008C; Sun, 27 Sep 2026 04:24:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 262806B0088
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 04:24:27 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7F0151209CB
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 08:24:26 +0000 (UTC)
X-FDA: 85258855332.22.125A67E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id EB2D710000D
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 08:24:23 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LiwPjk0D;
	spf=pass (imf05.hostedemail.com: domain of pabeni@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=pabeni@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790497464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CwGov1WfVqjaD3uyRV6IMvRELVNTsPWtY2wOQdAbySA=;
	b=6ngTjkf8sY77RjQw8JxgTzNA8k/IgaAx5kCK0HADjHTu/yZ6H4t14c1TryQIVddc7LqCSu
	pXL8jGJ1OeuWYaKV25Y0lieA+7o8mo3pupybe7vuILAR7QtvyIIRRAN1FP05GwCjiMr5r6
	q0WTfD5Sy+AMcNN6jmaumjL6sDE3ypU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LiwPjk0D;
	spf=pass (imf05.hostedemail.com: domain of pabeni@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=pabeni@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790497464;
	b=cU+78aEpFoQcbw9v/ObtNW0JSF2n9ZUnDB2NU5I9oZEXDmpmMR5a64GM0k3eXKEufSYRpA
	lvHMyC5GHUcNVxWIvBQfWxIqA5c89kdRPspDNFY2OT5i8A67WmU2CuoG8uZbf1zfOIywtZ
	u4x7YxgDSVZBFcTyrYIfunRcghC1Kh4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790497463;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CwGov1WfVqjaD3uyRV6IMvRELVNTsPWtY2wOQdAbySA=;
	b=LiwPjk0D+ndrNTCR+LMbb5/pDl9PZcbJZvbBXQp/QSyZHyc840xLgbZiYSQg8kZ3TTzjY+
	V+9/FAZY0Kv2+peAPhhy2vGTqJ8HL1s+nDmGqFVaTwKDQ2+EEvHbGfCxm1nT+FizRT12dP
	PHcjXwJGrhnO1loZVGLR0ITS7aLK4tg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-678--A4mdtfLP2m9IfvCUpCUcQ-1; Sun, 27 Sep 2026 04:24:22 -0400
X-MC-Unique: -A4mdtfLP2m9IfvCUpCUcQ-1
X-Mimecast-MFC-AGG-ID: -A4mdtfLP2m9IfvCUpCUcQ_1790497461
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-49e661c6440so13325505e9.3
        for <linux-mm@kvack.org>; Sun, 27 Sep 2026 01:24:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790497461; x=1791102261;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CwGov1WfVqjaD3uyRV6IMvRELVNTsPWtY2wOQdAbySA=;
        b=YH9bT/sj85Xrn4tA6akxw88dXIriSxQSuYu90C1/zK4h70GtZ/q8VtK70cTsbdNXMc
         oo6kogLyIDrD68Ubc6cDG9MbSXwFFUKLJ5/XpKP/JjRAiVJZ21LKYCwLzrsXOBao9moX
         Ane0ec3XCKiDxdy98LzgBe2O79v5NXVfbbay+DhIJClDsAWqvToJNm47HYv/FKzyF7Ic
         C4DV8na0pShWO78h26lK39nver9q7lVJZKnhwsr+FajQNHrgP7AvgQYqFb6JtcUI2JGO
         2apAydewdbkIvogleMw+ZWEezO8IRkay8CvFNrvN6fNyRCdlmDGX05wavzjmCuq62aja
         GjyA==
X-Forwarded-Encrypted: i=1; AKwUvBwYtetw96vgmvuY6JUf0IiZPc50qp5Gu056TwkieyoE6MtdDLVG10a6AVT0isMr935iNPU1skm2Sg==@kvack.org
X-Gm-Message-State: AFuF++keCik/I3eyz3l7HFzkNaMAAp0iH4uieZP07QcpRKzQE04nuw3l
	GUmx6ollUlhYTHiv173p0W6Leq/Fasrr25DWMSt3TVvWwJYhW6UNwQYgo40NYW5VqmvCREpcSfn
	1LRwUEEFtlQSZ03HTVikFnwXAvHpJQKYOe5hsRfGV9J0RO+PUEmxF
X-Gm-Gg: AYBFou2ZXAddWB0bz5EMux5MYmpI/FI5yNxjws0hkJKXreYrej/ULN7J04mMTZo11Xm
	o9Y/1HswRRLWVL7UPgToMTBIIJy73j3ehdUpmya3i1Z+zpSHCJIRWZx0TYYwcPVghyMgwMSC+C6
	89Cnz7lwMf/AOYgP+Uch3yJaQD8OKvItoLZXBQYIa2DM78P09UeVeqamsWBJQp+NukgvQPcopV3
	Qi5mVG+08ngfzKPZn08k1POynSWRHDgysfeB+XQVpDdbNHLpEBylt4fuz5EgPw1Y0iK6WbANg2R
	p5Svu0aGQ2Ml+wWeLrIgHe6FLAk7LCYd/b+TdWsqbpXmEmFBfUkElTnq5jriZ8kaC7VCuHpwcpO
	HvxaiUZYZ9qznG1dnPPIRMZRs/1ruHiHclIt9H+rB89wEwdP9pRdfNafmdWbYXoPLSxjzyLSxWg
	==
X-Received: by 2002:a05:600c:83c3:b0:49f:fdca:c348 with SMTP id 5b1f17b1804b1-49ffdcac594mr41988965e9.10.1790497460714;
        Sun, 27 Sep 2026 01:24:20 -0700 (PDT)
X-Received: by 2002:a05:600c:83c3:b0:49f:fdca:c348 with SMTP id 5b1f17b1804b1-49ffdcac594mr41988585e9.10.1790497460317;
        Sun, 27 Sep 2026 01:24:20 -0700 (PDT)
Received: from [192.168.188.234] (ip232-47-231-195.pool-bba.aruba.it. [195.231.47.232])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a0018f3e68sm40012525e9.9.2026.09.27.01.24.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Sep 2026 01:24:19 -0700 (PDT)
Message-ID: <8862b9ed-6f96-48c6-a134-6e8635c38987@redhat.com>
Date: Sun, 27 Sep 2026 10:24:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 7/7] net: skb: isolate skb data area allocations into a
 separate bucket
To: Kees Cook <kees@kernel.org>, Vlastimil Babka <vbabka@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>,
 Willem de Bruijn <willemb@google.com>, Jason Xing
 <kerneljasonxing@gmail.com>, netdev@vger.kernel.org,
 Kuniyuki Iwashima <kuniyu@google.com>, linux-hardening@vger.kernel.org,
 Harry Yoo <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?=
 <bjorn@kernel.org>, Jiayuan Chen <jiayuan.chen@linux.dev>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260921075811.too.775-kees@kernel.org>
 <20260921075820.1718334-7-kees@kernel.org>
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20260921075820.1718334-7-kees@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1d5KFaacxwPjUh1jIuVWJhwFCwVpNpMJvTMfHKTZoQU_1790497461
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: j6qr7gk1zgeqhfr15ofjqcxybhdhodba
X-Rspamd-Queue-Id: EB2D710000D
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790497463-316613
X-HE-Meta: U2FsdGVkX1/4zurxz5rhuU+d68ByrC1AlTr0U6KbIWr9KWtYbEcKSAujiZstp0AeFC9ELW9U3YxxFlD1b93kTWeS5Nb8cJg75g8XcSkjMEay7QgYNor0WGm7H3xLEOKDLkT6hfZi7iZDa4Hifo9f8C4ESCk2QfX6VI5ipGuHzncW/QAex/A5f3GyuAdycPj4zOMqLR06j4s+j3qfriEBw5iyYPpcDxy+2VN8UA5p54ncElw6Xn4j7U5SyEymMjQY/poFFYoJdiY+QVK0xJUd20fgxCxAWLeGfbGf6C20VwcTSps5Rrl+krzqu9KLv3JcAA9LeO5v8ABtuNm6K9ySKLmcIx9vv0E9sO+IGJZ90bSC9FX3iiu5PVlZisg0I/4pT5PFmlGCp3hCzqXPbRgbQCJ3XRv6pbKSRz1eiMdMQh5oK7qbE7LIH7FpNL4W348FQ5v7mjPAvaihSg5HkLS0utpB8NbHX+Elgm0c57e2jUWHpqwk6+fNWrc6hQjn8NFjjKpzvimsr64L9bbYM9ffjVTHpaAzIxmRf74htD7BpTvgR9ZOmsF92S9bl+B7YAaq9jY7IidsFMrzkxNJpmNdlH3hVSm82EXZ1eTyWl5bUGVgFKqN3xcoI5vuBgCyWEL/EJXbF2NJ2xQgb9I79g75V1oZO2P8qb4m5sJRwq0ewAGl8AQWQfBkDUgUK3HIdgFIsfXaCOkLET1EfrXeWFgbdJHpt6cjHXd9K6IRmlglMXwWzpt5IFGd5+n3HzJRv8lPzNaPZnHid6TO2181yKRS1n+gQTiFZmTmjKhWrE1FeCADijusTP1DDpGrVVtP0yp9JoEdiyUT/MRIL1ZECh5WlzFnz1wCv34sJqNVLqP7p4WtkbiMZ+P91YXXGUHndU4DSJwaut3qF3j1ET7Z3IZClv8aXviV2cBXwVB2CWcdhXmnwB3z84D8JPp5O7Z+e4KY0dXb5dgj6QtpUd/NZGy
 D4kHC+k8
 KDPab1MBHCONnL6WSos5P4BCxbp+mUw6TMWwYAGpToXH8CqrUr4WFje9uabQZo/Q27tOd1hA4fKQsl19o4VO2nHONGVgIvUikE+KEy08xmrYldGMZ8q8ZOdm/4K3cT4A/OWi6VuvonsHXTO4cpHXmraU5FNDp4y9XYelgmxGWAXw5VxiXQxJbFPMhe+m0rRdgJiCiBQM2IXXxLrlWbyGJaKcoVL88U/BPq7qkicFGYkRgpTkgvdZEbEzPBMM0bboEpUF/cuJGIAxHf/RiIIytrjLenjt4gbnXux8IxDQPxxdEfCxLYSE8pHV6VGMmRgpEg6Fuf15Vbvmj727H5HqNk7xgxv52+U1A2A5mROeYYJvvTYy0AJ1BokB08lgyPAkYxP/tB/KtPWGODIQ3urO9hF3XcS7ejgkfEogKmCfwfZrRFv0JSA+WAorE41acP45Exc8i
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/21/26 09:58, Kees Cook wrote:
> From: Pedro Falcato <pfalcato@suse.de>
> 
> SKB data area allocations (as done from alloc_skb()) use kmalloc().
> These allocations can be variably sized and their contents can be more
> or less controlled from userspace, which makes them useful for attackers
> that want to overwrite a use-after-free'd object from the same kmalloc slab
> (which often just requires the sizes to roughly match into the same kmalloc
> bucket). [0] is an easy example of an exploit that uses netlink skb
> allocation to target another similarly-sized accidentally freed object.
> 
> While other mitigations like CONFIG_RANDOM_KMALLOC_CACHES exist, these are
> probabilistic. Use the existing kmem buckets API to further isolate these
> allocations in a guaranteed fashion, when CONFIG_SLAB_BUCKETS=y.
> 
> Ask for the accounted kmalloc type as well as the normal one. AF_UNIX
> sets sk_allocation to GFP_KERNEL_ACCOUNT, so without it every AF_UNIX
> skb data area would fall back to the general caches, and those are the
> ones most worth isolating. GFP_DMA is left to fall back, being passed to
> an skb allocator only by rare devices.
> 
> Link: https://github.com/google/security-research/blob/master/pocs/linux/kernelctf/CVE-2023-4207_lts_cos_mitigation_2/docs/exploit.md [0]
> Reviewed-by: Kees Cook <kees@kernel.org>
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>

I would be curious to learn how about the memory usage delta.
However I see buckets are protected by their own kconfig, small
systems can unselect them.

For the networking bits:

Acked-by: Paolo Abeni <pabeni@redhat.com>


