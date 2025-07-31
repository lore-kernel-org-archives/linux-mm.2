Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D80BCC87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 11:55:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77E3A6B008A; Thu, 31 Jul 2025 07:55:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 755546B008C; Thu, 31 Jul 2025 07:55:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 671F56B0092; Thu, 31 Jul 2025 07:55:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5815B6B008A
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 07:55:37 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 17C781349C4
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 11:55:37 +0000 (UTC)
X-FDA: 83724405114.29.90575A2
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf22.hostedemail.com (Postfix) with ESMTP id 11A4FC0002
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 11:55:34 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lnL+S8uQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753962935; a=rsa-sha256;
	cv=none;
	b=ZLdNAoNVxSxcuqtmSoeC5ee8j2fS2nvZRp9BTqz3U2vKAnWSL3sk2e0C3lSDAWPgj5J4rH
	fTvP225zS6B3uMCLloji1olRcxfCQpd6YKdbEKcQSkqJpSOt72BiWIZz5kQi4WcHpOlkZn
	Pxddl9TE4uMxOqZmIzL1/rQV+pWmLrY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lnL+S8uQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753962935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ipebKhXuaFbN22VY/IL9Mx+5rUkpuKe4KBFjo3bkK6k=;
	b=i4cibv6Ds4KP40BD9tKScXT5EW2epX5tccq8RTYbcqE9cd+52AhnktRDECQmx+7wq9QKxK
	sWDw5WcGPJR2w2QcNonabYHqQ1AyhthD6WyxSOjRn1F0UpAX7JoMf7/bMchqn62GgfMnrS
	e6fmNQTthP2FB5XBACYRp9i+7Hwy3cs=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4561ca74829so8976135e9.0
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 04:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753962933; x=1754567733; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ipebKhXuaFbN22VY/IL9Mx+5rUkpuKe4KBFjo3bkK6k=;
        b=lnL+S8uQFwkHBql4Ek9W7Lh5jCNLxpGB67Dou+u58Bq7MLBXspXKW30J6ga8ZDNPAg
         Nxl9sjzcvLgDq+/a2uO7Nwy1MvCc9FFuEMld9Sudg9gZ7NPJx9o/L7oov9weutnrIZyU
         6g61ZUa3BS/umnS++lQNmJLF8qAiPVX69/c1eC2lB1Hcodalq62sV4na11wC4K2BONdj
         Iiw5l8/C7dgZZtnAQ9T45TpoJ8eSzHzTPQnHpLJunzUz9FfQ3L6Kj6mpwV+PcodGtE15
         +5O81WSRmTBplvKpzYKZj2Bu4fkVUpq03pbryvf2qQIOhl6YNQXTLsE3sjvY18n2oK3k
         lqEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753962933; x=1754567733;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ipebKhXuaFbN22VY/IL9Mx+5rUkpuKe4KBFjo3bkK6k=;
        b=WvJTBc161Tz4huBdwS+5jNjhhtl9kmGipaVZrYSThf0IYGx7CZHvzhYsP/D0GcdcOz
         OfcsfYSmfI+u4zdK9yl5Px1ZfMl8H+DIs60yxRtvU0NBOQocrjJPGttjvlhaNR0PD58A
         YiiiP4GC/1xXSjGQTRjtUl59Mkp+0hykctFqUgWShJBbU9W3qj5+x43omlKxSHakxQhb
         kr9wK0ZdUAnezvgcORYsTaIPSQ6QSgomE6AccNsD8rnPK+H498L7CVbfLr0lXHSZ/2kO
         860hFWRGRhBleFob3SkGpdJraMEVuXHruFgWRQyxFFWnaOjAuduqqDIwEsNSac3wml67
         IqVw==
X-Forwarded-Encrypted: i=1; AJvYcCW4UOamuyDcUsy9gDwPObVKQhNeugCT8U3FVCHAaePb1v22Ggvhl0v3gUejPYI2SKkvXujIT4JXag==@kvack.org
X-Gm-Message-State: AOJu0YwNJfbMadrATlvx6ppTz5g2Dhj9howTJh9JXACFD3U88JRQ5xL/
	CZ9/ejlLO1Qpg0VZXA07NKNjEfLg8mb+8y1b4dxqSmxm/WDLYVUV2VJN
X-Gm-Gg: ASbGncs508gWi8CUwxHePDS90vZVGXGpysmHpVIAh3AFO58uieM/nkAZ8PXdv04BG1S
	QHxIUXHpxNiopo35ErVRQQSBnZ/QJPheRZDnjcKDWjgWr+sZDyZbJrKSENywu6aAAHJRfMKbaTR
	PwAs5qgx6tx8MFnSt5J9g6FZ8miUUdgvEeabu8cxdW3sNAMPWpvybneP7ABOQXqJAa5IhcSGZ7z
	5KEQRsO2WQYwsRD+89HeOKESWTyNXMGdfzqhEt1u3VZe8omQAqbZ68SWYU2IzGOVtbNUeLbeGTj
	h5vgbi8rUbfIVUbvLUhCATfahNdwVy5NjDuFi5hU4bLEarsbr94i9/i722DibR05ad0Qh+ty+6+
	GhdKuEFwcEw50yKry2cBB2gxA12q8zRl7yghW3j+0wpx4CPg2zvZpNmcGKZMOud90ekYncwmw+X
	dJnRfgtg==
X-Google-Smtp-Source: AGHT+IFpJVxtyB0Gn+FN/gaWAyTmnRBEh3acsXFbFuXq96g08UWdRioIiv/+fMwh38/b4ZjhBXOsFw==
X-Received: by 2002:a05:600c:c177:b0:456:cdf:1ecd with SMTP id 5b1f17b1804b1-45892bde5abmr66124935e9.31.1753962933126;
        Thu, 31 Jul 2025 04:55:33 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1126:4:14f1:c189:9748:5e5a? ([2620:10d:c092:500::4:3f35])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458953f887asm63654145e9.29.2025.07.31.04.55.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Jul 2025 04:55:32 -0700 (PDT)
Message-ID: <2f73f1d9-ad0c-40db-9697-3070cd52f688@gmail.com>
Date: Thu, 31 Jul 2025 12:55:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] alloc_tag: add per-NUMA node stats
To: Casey Chen <cachen@purestorage.com>, akpm@linux-foundation.org,
 surenb@google.com
Cc: kent.overstreet@linux.dev, corbet@lwn.net, dennis@kernel.org,
 tj@kernel.org, cl@gentwo.org, vbabka@suse.cz, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 rientjes@google.com, roman.gushchin@linux.dev, harry.yoo@oracle.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 yzhong@purestorage.com, souravpanda@google.com, 00107082@163.com,
 pyy@meta.com
References: <20250711002322.1303421-1-cachen@purestorage.com>
Content-Language: en-US
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <20250711002322.1303421-1-cachen@purestorage.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: rzjas44eakfjwayxmsyky8jj4kjsywjz
X-Rspam-User: 
X-Rspamd-Queue-Id: 11A4FC0002
X-Rspamd-Server: rspam02
X-HE-Tag: 1753962934-764609
X-HE-Meta: U2FsdGVkX19tw46PLg55ELR1oJdowfMkFHEmg/sQ9YubVXolpQxzWMby91XSRdPptOLDl6OOvnmAXdi4jpVuBQgx4f4zFovXLm/eoGrYMonEx+nAx270b53zFo5yzcZ/ekAKfojKJOmlH2uh6MvzlG/5AFNzsbfFSOxL1Na3WFulYPNg4Wwv/g4JtIodPiDA1pp8ebcsLfCFKMbYL9UyMHZjI6GWCtjzF8e+imWDyqsn5qs2RAvEtmYJNM1qriF7KDGsTbLoOM8uBzD5Q+XD/QgtrmasgsvCT6abHoklzkXTvyZz/jArxPIiCWISCGmpN9s2uB+/iLwmC9N10Y9PcZYGBiaVkAL/1nwu8Kz0AdkOeuLtGh5CskyEl5r9bjI60/XyD60SaySGqR8If86crFTT8nUfIy8tCJomntaQgWAfHD89of7h+eQ3GXzNbhYTtHPlhf/NPBEV3YfWYvO1iTzheYf82evSnbgdsWkaJD/ZTQ/29BOg4idIbLirJc16FqQSATHlkbRYcvNWtP1XDIhYvfxn1dgbqovsra93VMdO5SDQFHHyu5xZMxnD7jdIJRAJdsII4sfDTmvKWP0ofYNiocjZorfr4HZsdco4ifGnzwrw4RQaNl5kCrSTN2xaoAlPSAniUY42noPrTQqpB7M+whDXClI1VsaCXgqnju6qQLQ738uFXx1/ZWdJSbyZj/Vg/V5E7Ur7g+nuj+27dTX7PPLJ4bMNUs8CW7UbxltjcU3b0htj4ceJUPWPV9WzIz5TvMzJt0lT7IGjXL3RHJinnJVA7Jie5gAf9VJpMOMk2XsFYFYvq1KMkU5x01shzLYL/Lo/Lb74EwY3pfv5nMNNlzmSIFs/3obi8pR47ykEjm+Alvg+DtzlVe7NbNHWcBlymCmWhbiRYmjq3cCfLje9MuVfCmplvehycQENA16kGlfj5vZ4I/e/kz8eFkBODOWu/esKQze5qapyuZh
 VWplskt/
 dYyAFWvgnl38EXlJ3jBKv6RfMyjmr7upK24N7x4rhex2CpfAEeVA8awMMRqUSEsrkAQuvlQb2kmc9Ku17se5ZT3yv3WAR/zw5BcIFXaOnuV8oretKXrOw74a3cBWoGEFPjmZ6Lz9FfNIedNlpDX2H/B2/CvxvIuoS06IzFLMXDdoHfWPKan9H8ZMDR7BZTa/tVigJ0f0huIVY2dYQGgjiIuxE6rWQzSUaZedS7v7lqg8SwcKBy15qazO+uT0DeRyCjGiGOZAZZJ7thDfeVD0bQhq3XF7PZh3kIXMhJ888BXM5bADP3Q2tQ089gjL4KaH76wb9MXjQNL17XBGFrpPCAClKPWJPHhexWHm8jSynCy965+liM5/PDnJLEyWvTPa4SdPqokp1cJJlxxvUv8/LhpHEPaoBKM5Nul47fcGTuc6OqFZ3ZYUo+Ga2q8pzBcl8hk2E3nG/o3uJ9YfzTo+tTsw6E0f/rCg1kD10AVtCzGevN5CEthf5X51uZBQ/i+b3Qf+tWAfnfr4xXRJ9rDSunE0iZQQe68BjzVTdpMhnDv2VQsWp9AnWTTMZ/tJ5p3ptuk9ZJb+xEgR8hqs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/07/2025 01:23, Casey Chen wrote:
> This patch adds per-NUMA node breakdown of memory allocation,
> enabling more precise visibility into memory usage patterns across nodes.
> It is particularly valuable in cloud environments,
> where tracking asymmetric memory usage and identifying NUMA imbalances
> down to the allocation caller helps optimize memory efficiency, avoid
> CPU stranding, and improve system responsiveness under memory pressure.
>

Hi Casey,

I was just curious how you used the output from per NUMA allocation profiling
to fix the issues above? (So that we can do that as well :)). We get a lot of
NUMA high level meminfo from /sys/devices/system/node/nodeX/vmstat.
Are there specific allocations that are more of an issue?
Do you monitor these in userspace and use maybe something like numactl/migratepages
to migrate resources to another node?

Thanks!
Usama

