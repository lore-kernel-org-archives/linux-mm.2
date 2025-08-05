Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEE57C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 12:46:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72F466B00A4; Tue,  5 Aug 2025 08:46:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DFEC6B00A5; Tue,  5 Aug 2025 08:46:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61D186B00A7; Tue,  5 Aug 2025 08:46:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 54EBD6B00A4
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 08:46:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C60E38119C
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:46:36 +0000 (UTC)
X-FDA: 83742677592.15.0921D51
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf16.hostedemail.com (Postfix) with ESMTP id C64D018000A
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:46:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="HImTRzj/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754397994; a=rsa-sha256;
	cv=none;
	b=rI5hD7/xVTMEu5zMx38F3K2narvZ58CaZfDbb0bM70nJUHGP6srOfCsNayFIFiDu9Ixstb
	dNd2o5lsza039H+p+fWwt/tV8KxXX34N/3Padph5y7ht0s0SYB/teVVFs61p0awEtPGqDg
	vDzZBz5k/fSFl6nbDVA3Jhr82NuixSE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="HImTRzj/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754397994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kts85wOR8B785cDY/fcRHxCicRY9ydmXyui8WvGgCiA=;
	b=kXDih6Qk3hE4WxJXZNVC3BqjASIkTFeyaZfMJAaifEDEETRZTAcvV4DQFMYO85K6wejXJW
	KMKgltsjNEi/cAQ47PGNcQCrvKpzkCyo4RdmOUHoyVSUCRvzCQZzps5Z2CJts0rwzILOax
	hN0Hht3PeO058YWBT8OsUrMK0gCq8Nw=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-458b2d9dba5so23398205e9.1
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 05:46:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754397993; x=1755002793; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kts85wOR8B785cDY/fcRHxCicRY9ydmXyui8WvGgCiA=;
        b=HImTRzj/4utJA+l2rVXn7hYbF/M/cN7ThX3nyS7MmcAF3+Neow1VAMHjj/VmzuAjEM
         U6VYg4dpA4cX68kRnNG4PPIYo/CdpB4XEYN+0XfUhrRh2j959FNLIRGeahZQIPS8GpnQ
         H8fKbchTX19HbUQT/a9LGqY55S1pfCJ2ktq4tgxJci8hQ+dwcxt6rElpzQ0gZN6ZodE9
         0xHZwqd6Np8LpX6kM8XPppRotkA2k3RbWHNsE/QqmZWbPHxUrK6ToW/5OdQk1CgSAyGE
         WdUJ8HxI3Cc+akECuqn5Ej4T79chOHaxuD1+Q0U1x5CBDawJyJtLjRZ1uECOeFe0y7hD
         4QlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754397993; x=1755002793;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kts85wOR8B785cDY/fcRHxCicRY9ydmXyui8WvGgCiA=;
        b=T3a7W6rxiU2MICEOR0tk5lgMiP8PDy8Yj9m0/mK24OeD3H8XALUH4/uSGyNpxtN8xN
         YarO7Q0Y6GeRAUMNFNrDq/xALJ3cF/6h66ereDfnpTcXGoQt1ZV5XOQRtOjseX1e9Njs
         IIEeKsB93brWG7sqITgHgcqT5cTmgor8WlVnyiquYSN+uVcOpzVGjadWHNMD9tBBApnn
         sOtbg/8gvQlaPnYGRo1OPnuwCFwBtPaZnGHNOw4zrWlNahr/JCrWmltAix5Mh5gxtgjg
         TlpVejk0x0kTU9uf0hiPkGYeBrgtFkzBo8D2bVVCHNaGIlrJiGLUOvz1rZweZSFmm0bd
         b3HQ==
X-Forwarded-Encrypted: i=1; AJvYcCWzNCeIYGUnn+PHz9YI6TJ7TlkhmOS12QxLyTny1hHIuQJyUmaT9OBRPm0o6KPQiv606KNPUnTOyw==@kvack.org
X-Gm-Message-State: AOJu0YxuCfRBkApKLjPOz8qdbUC1AB9gY53y8G5QJ2LAk9pY9mMf8ud8
	Prr7MYhOwJ8/D1AgIhinYZyW7Q2ko7mYYqpLXBo/wwy+mBvIIkZEp382
X-Gm-Gg: ASbGncsi6WXh4nfQ9YHb1o6WOhOCT4MvULxL+CM06YBwVQISaxQNU0a2d6bjGvjBOSh
	w0iGrNzS+ebqw+EOdSnrAcUSRR92v5rWUOYcJ9kgKpbVtEOCiiofNyN8Lhb9WmxwJ29yxNEqUzw
	GJNeoRnDQFbkvCqQt3Jc6oZ9UC/A4xYDepciUHKK0DOCt/WIZNAmTnHWXS1w0HhYp2CC1x1Dh03
	T7+Myl6UNRyS4ki7gmgROeYci85gBDyIY2vwPd7CCzXUdhMI+1JvURs3pM24h9Ji30hkyDu+NEU
	g1D/0rIEESbx6Q8V2QAjtbGtabXx314TmGZ90nNvvqQR7mrP3D7ESKl97yKArCMRUphSEtchbtp
	ivue2EeAXOK/xnvyf6xSmSTunav6Ko2msrKnkUb4JjhCWxgAWF3xlglvIBp+JFh9rXXWFmA8=
X-Google-Smtp-Source: AGHT+IGbwhKqeLKVbuUBtyRIXnxHc6wmxoB1d3BMQRjaQbajedNiSQ08om9tQBTpc0k2ftB702prvw==
X-Received: by 2002:a05:600c:a46:b0:455:f380:32e2 with SMTP id 5b1f17b1804b1-458b6b30363mr102873805e9.18.1754397993088;
        Tue, 05 Aug 2025 05:46:33 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1126:4:14f1:c189:9748:5e5a? ([2620:10d:c092:500::6:98ea])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459dc900606sm66735885e9.15.2025.08.05.05.46.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 05:46:32 -0700 (PDT)
Message-ID: <a22beba8-17ae-4c40-88f0-d4027d17fdbc@gmail.com>
Date: Tue, 5 Aug 2025 13:46:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/6] selftests: prctl: introduce tests for disabling
 THPs completely
To: David Hildenbrand <david@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, corbet@lwn.net, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, baohua@kernel.org,
 shakeel.butt@linux.dev, riel@surriel.com, ziy@nvidia.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, jannh@google.com,
 Arnd Bergmann <arnd@arndb.de>, sj@kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, kernel-team@meta.com
References: <20250804154317.1648084-1-usamaarif642@gmail.com>
 <20250804154317.1648084-6-usamaarif642@gmail.com>
 <66c2b413-fa60-476a-b88f-542bbda9c89c@redhat.com>
Content-Language: en-US
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <66c2b413-fa60-476a-b88f-542bbda9c89c@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C64D018000A
X-Stat-Signature: zdhwoxsj3fwa91zi7fcqmhzjkoyqscrh
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754397994-273305
X-HE-Meta: U2FsdGVkX18i5BL2k82NddFxA7a/n+0vi7Ar3qiEJLVZfKw9CpoPBvHK4OcbWQOZqAoY8EMuG7yVkTRHU1loXnGdvlwKCG9aHMs/kKQbYxgqv1luskYKFdGas08MWG+orfeIrhRkfwsNii9hBL88zg3ZI4uC3fckmS9J6zdssn9D/kTQ9sLCkxa8aJDC+q9AqdnH2m77un2Jw2VFxSdeymHiwW8ObEDzZdSj6G+VgYgRj0KobnoaoTOTVUkExEP3kOmhVbAqm2lbCEzF3xTVB6muumoG7S6bghxYAgVPvinQSNGF8G1ldxhgJJA5tSvmVG8p4woounvZ27kgXUQeI/xQRWw2zZkU/i+gG41vaeupDJwQwnoKwMhqBia+Ldm6gCCdKQKE1k2V2q7qxqo1JRdVzUuJxNajhFpMr+dJZ/zXfvtIVlK/o4w0qLQZHvPaKgoQnczsngI1/QCi2oOqoY6XEMDjYMNxZjwDEQWgudIQkESCcE4pWfboqy2rai6aHumfzJiWDqsYvuwBO4+cnTnTw0fcZSZCol+2bwulu2k6eHfJqhh5L5ZoB4a6Fpm0Lct28LhuvtE7rnG2wsQOtfdsGlQWAWSXF3DYNntrVXfkFmZDTMsj6CBLb8Ha/GkXXlbzNrzThQRLTSXt4tsTqrU2j/fDF5u4R8iAqd91Jkc2n8cM/HyyFtJ0uVd2seLCKHVFhHj2WalSde3tklieb1tdeqfF+usVf+bUu2l5SBIFnLNPwUsTU8v9P6cyh37XuvRpM90eEm0ioars1RGjrMHhBk2H1NiR1iPRiJLuj42HGvpJHRUXogUhCQbr2lpasChQnFxl7bg0spmEkHoSWiIfAuj7WU+tmiiZAVpqXzrzOBv1cqi/FN+PSj4u7DwWqO3orX4+qCuOsopWSFdJIT+Rh5VJB1GCH+pOXLohEhapTmnZGt+SSIVeIKkDvKo+/VBY8nfsncs5Xc2a++U
 xP+ZXxRs
 sEBspuBLWe5q4rF8tRjzv57UbcqdFu2F5INlIdqloWgKYXKZWkefyKk83igbqNFtHgonk7BWCkAdbBW3z77FZutTydtXZvAUDUCesMz4Ifdn2vonAokxAoMYUb8GMo+BXpc2mh4voy0wv6LKz/IvVQlLm3OzXV94HOiwU1zhn0IbXXuu4k8EPAK+HgqkMQDmLAO5IeAtbW9yksBzcQCD7Dy21U1v/iwbI5Ys0pz7SIQetYJ7BCit8CnwGHmdllMUpv4GdtKCkt/dc94FrOQGmHwbzKyrY39thANqmVCUkIoULStR45e9a4dYlQA2c14YhQWXvs/hKST5OQU52/gNGoyy6EQxrv+YSUM0hCStwubeMIh9tGKdq9h21BJM8Di3OJ37A4xemXjJXUL11T3phDOoG7MDRPhJO06P6JGr4qVj2CBlcWNb2y4c3fE2R2enRMG1zdW3C+UVSRdowDkimZtXIPPc3D6H8Lgo5cZIWHJTQFicU0//vaYtGGlvz+PVcpZE5sFbay+/VGZP6F9yqqcrbz6g/HdA1Y4k2MqFqqQ3NenpjpO9F7uFOENPYt6pUJOwqkY+b3uxsCCbm5KxUxUx8SgoM4bBbtxai
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 05/08/2025 13:39, David Hildenbrand wrote:
>> +FIXTURE_SETUP(prctl_thp_disable_completely)
>> +{
>> +    if (!thp_available())
>> +        SKIP(return, "Transparent Hugepages not available\n");
>> +
>> +    self->pmdsize = read_pmd_pagesize();
>> +    if (!self->pmdsize)
>> +        SKIP(return, "Unable to read PMD size\n");
>> +
>> +    thp_save_settings();
>> +    thp_read_settings(&self->settings);
>> +    self->settings.thp_enabled = variant->thp_policy;
>> +    self->settings.hugepages[sz2ord(self->pmdsize, getpagesize())].enabled = THP_INHERIT;
> 
> Oh, one more thing: should we set all other sizes also to THP_INHERIT or (for simplicity) THP_NEVER?
> 

hmm do we need to? I am hoping that we should always get the PMD size THP no matter what the policy
for others is in the scenario we have?


