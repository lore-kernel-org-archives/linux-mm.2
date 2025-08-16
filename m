Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75F8ECA0EE6
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 10:05:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DECD8E0018; Sat, 16 Aug 2025 06:05:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B6B98E000F; Sat, 16 Aug 2025 06:05:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CCAB8E0018; Sat, 16 Aug 2025 06:05:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4AB988E000F
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 06:05:13 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BDE67C0196
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 10:05:12 +0000 (UTC)
X-FDA: 83782187664.27.9DFED64
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf26.hostedemail.com (Postfix) with ESMTP id EBE0214000E
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 10:05:10 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OEF0Lmzc;
	spf=pass (imf26.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755338711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CxDv8OHf8HL4ucJb11nPt7YcC5lE7gHGLDMJMXw1j90=;
	b=NsACkm8i/DkRuexhBPG8KCS0y1gRlIJC5j2WXmW12NSLFIGqW5doWO0t1Eb2EEL/A7PBhc
	V8eTIZFuzDdMt6Q3bN8EVpMtHiwYpcs7+PcEjt1+nsWSPrFSZqrGCxzzW5lDSK27AJ9Olz
	NPMy7CygkcJ7ZQUyKbnv8GOLHiSb114=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OEF0Lmzc;
	spf=pass (imf26.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755338711; a=rsa-sha256;
	cv=none;
	b=vLMVxZiIYGPMYY6CEWyZVvVk+w7LJ/ePO0XLp4ykmte0pi+6H79V7m5wPeigW7cl8qXu/Z
	72NsPas5fJHLWOPmU1wT7gtF1N5XcMMF3w7bBAPqgBuJ8Z0sHSc2De2EWN6I1NxFMCK8uF
	R7YpcrZEALJuu07dshmb5I6irJPl+W8=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3b9e414ebb5so82642f8f.3
        for <linux-mm@kvack.org>; Sat, 16 Aug 2025 03:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755338709; x=1755943509; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CxDv8OHf8HL4ucJb11nPt7YcC5lE7gHGLDMJMXw1j90=;
        b=OEF0LmzcAq1E+snjQNwWSUZ8yYHNsBLZQdu1r6WfAzFwvC1g1GPbhjBc8eDDcxdbCK
         PbYxSiCGsZEV9oJPBgqf31DWkIFrni1696YZadQ9ETLCkNItaaW9FKyDWE4smq6lvQvr
         qc8RTb0UEHyucF60QZ9NpWCb4G+/4IgmrpOeqTCynZUVPcMCrtxlKi/vRkZL+7N/+cZx
         jeydtxP7rEwvb0LAAlhZOTULJTO/g1IWNwmI+eqrpbf/hljgKslMXOIg4W5KSQ2SeIxq
         2CkKGs7fFGmsJLoJSbzTbEpTkclcsQGZZ3pmxWOsYJC0uAbHBwVV7doDSe4EG3LUJmBv
         uLMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755338709; x=1755943509;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CxDv8OHf8HL4ucJb11nPt7YcC5lE7gHGLDMJMXw1j90=;
        b=D3YD6zmf1awYL6S3ylPl1rIVCxu8hbPZdvUNFvxfxXP+2e0SAZSg/zR7fb5aTwXmdp
         hBGNrSGNB7JFq4VmFJZ5UQhD4HKtLiozZfND+lOCO5uhHr0ec5blcV/fJ8Ak2IB9JkAz
         4BwPb2fQC6NwOy3EOWblW894X5x3Brj3AaC4Mf4VGL4zusbJhlH9DT66AYz5evJcRmYX
         GqbcjIixxJJnHk/S1NBf+Wp+FqGwkjDZPOjt94izUOM7bZvFp3N5oP40Dr8h2VdJ1wD5
         1jylXG+oBFI2UYzfbEh+wr/7q/bAzzzRk5OCUNPMTXcK6dePm1zaAmfIY1/8sdJykZSq
         lcXA==
X-Forwarded-Encrypted: i=1; AJvYcCWwznb1Y56RFnoLclGgW3tbSkF9RWxM5CnxC8sBgU6vEW3bjaPPa+zMq0kf4XJz9sEVfb+F7GQHlA==@kvack.org
X-Gm-Message-State: AOJu0YzVWfZLwUbsLQ03QMM0fxB8P4PC5UkbUDSYdH8trk4K8oFjvMSr
	iK+SUvPI0hIg5mlsLvFLrRdSJ6UegTbvn7Rd8NnbhaMkZBeXOGdMOj3N
X-Gm-Gg: ASbGncvxBPA4eoNyxVxVAz1rE8nqyxYvkbxZTH9F7Q1Kg8mI286d65HGKrAHL4gNPKq
	lSLbqboiavooUIfY643ouG2MzkYRM1i5VnZS/ywN6OFkG9itGVXw1kpuW0vkKmQD5CMriRY41ym
	JFq31/C1HyGA76EGhRj8D/lBnWOhNSobcG1VLq3PwC7VOnJ6OYGtfOVDdHoQaZDOkZSThxidf9z
	kINsHnmWUu0pMiiL5SlPiJPN6olRgbssMvui7NxLaAAdUgpa0XqFl9TTJW39EyHnLkyq3RQQLjQ
	p8TPo1Fi0sltMWXhK9DyyNZWLg3ZJEWFMAqa58ekoTwrjSWeej5FuuSurlmFspeCMQpW+X/AVFG
	q/0SzSiTRVGEM1cS/lyqGfqvGGfbtldh2YrCZbkZh7LnTyXZyL0uc
X-Google-Smtp-Source: AGHT+IGk0QiO93qwLWgp2oMN12N3vGTw2Is+g3e+INhg8F4TqlnrWbctD7RK33P6CnmYO98DFd0wdg==
X-Received: by 2002:a05:600c:46cf:b0:459:ddd6:1cbf with SMTP id 5b1f17b1804b1-45a21781fb3mr17025265e9.0.1755338709086;
        Sat, 16 Aug 2025 03:05:09 -0700 (PDT)
Received: from [192.168.100.4] ([149.3.87.76])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a209c25a1sm61067435e9.22.2025.08.16.03.05.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Aug 2025 03:05:08 -0700 (PDT)
Message-ID: <d18b67f8-92a4-4e10-9341-fb7e075a885f@gmail.com>
Date: Sat, 16 Aug 2025 14:05:06 +0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] mm/rmap: could be partially_mapped only after no
 entire map
To: David Hildenbrand <david@redhat.com>, Wei Yang <richard.weiyang@gmail.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, akpm@linux-foundation.org,
 riel@surriel.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 harry.yoo@oracle.com, linux-mm@kvack.org
References: <20250815084943.23063-1-richard.weiyang@gmail.com>
 <20250815084943.23063-3-richard.weiyang@gmail.com>
 <458c4ea9-1e33-4159-a545-6ad2c5b81add@lucifer.local>
 <15ccbbb0-8ebc-4c50-a1c8-fbe5416ecf46@redhat.com>
 <20250816090654.u5eoys2vkpswe553@master>
 <88117e56-6b81-4601-a954-26d5f630aabd@redhat.com>
Content-Language: en-US
From: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
In-Reply-To: <88117e56-6b81-4601-a954-26d5f630aabd@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EBE0214000E
X-Stat-Signature: ghputy97kwcefxwwegiezf9r1oabi9xh
X-Rspam-User: 
X-HE-Tag: 1755338710-963594
X-HE-Meta: U2FsdGVkX197xR0MfQp1C2xVq4w5/PX3do3d2OM5q3Eac+69YB97BClP/hYLiuDz6xjH06tPJnExzLry4NY+bg2ULFkQNeIkFhdC/5eja1/9nLRynfwuORbgXsyeUpN7KhZSoygkfP8ClJGvXTxL2VRNQhba//e72K8+n4UoxcuoSPf7WLvP/ZDGrEH3DS0o3ASvFhD3mnE0woVEBlUOE4MZJzLvVxQU8y+pLKEjkPpLLXMo5k0a8HAnAgiXdgXr8En3EfIF6QCdjf6+crpHpz/kGLylWUmSMWJ6/tR3PWwUyoB+SMEkKg7VR1T1KYjj8j3rJJpyffS7jOKwIJL2VlztY8bZAWuID0WrmYfOem45rfO2+WYxpC3exLFGlzwdGTbzfJpOuEIR84j0bCvHUHRhaxtHjUUXQSYhQ9VdcGftqCEMhGZ3ik+VR3Tu/2NEyzbTOOWXO6z/HIWKHktL1LM7aOKY9P2S9036p51n+KAr21MD7ZglOCtjYbYDxXx22nsGP/8PAx5uXhcw/oln5KK20qA5uFQ+0JPVIUf2brCcZEvh/OrFYeLm+LHM7AByIO0wCQz2xCGLpIcDuvhZhFJLQj3kj81O3I7+A8k7UYSIPPM3mYuvORtJ3LT4sX+F8AUpeYGP0rGWZpoX/F73D12rFldnGHtFiiluVf3Pe/Vw+X2J3wDXv9hmyZWH1dxSIywUmjYhu++Lya7h6qoF6pPLKtGAY1OMddgmn46DzkWJRySG7MX4cWTWh+62tgk5eAfvjQRgMJAXYz5laAtysAtcJOIXWvo25la+hW0OalOLUwEAnsisnN6FXFv88KPcCE+hsqyHbi+GfjnCddhnmt37pRk1wXgublSJFrpwYXpp2lQu7y3TfHnyTylfmiXnp4ylbKOxKkunhU/NOrmLk9FBnsr1N+cQJXWWQmdIWPu3Qi8MhCYWVCai8U+xN3+Vc+qr2H531erorbCvBeC
 CDDjcX2P
 Xk/rjxvlFB5t+roRy8pknRh9bwX+/rhoO8tj1KG/RCS2Xo7SFNI35mA6REJSYwVIxI0Utva/9XJDTehIfgSOqcBez2/rshazorrC0apucRqx+Uw/Y1Qa43NbS/lm3Bw3ULBWW3uILJXfuB4syL74AFI3yFmhqqZR9xewuvnKsXPLKn/Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since the compiler can prove the expression will always be false in one 
branch, there's no need to execute that computation at all in that 
branch, right?

On 8/16/2025 1:16 PM, David Hildenbrand wrote:
> The compiler can figure out that it can move the whole statement to the 
> "if (last)" branch because it knows that nr == 0 otherwise and 
> partially_mapped == 0 already.

