Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A515BCCF9E3
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 02:34:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11DBA8E000A; Fri,  7 Nov 2025 21:34:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CEAE8E0006; Fri,  7 Nov 2025 21:34:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F26E48E000A; Fri,  7 Nov 2025 21:34:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DFC3B8E0006
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 21:34:38 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 78E12160671
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 02:34:38 +0000 (UTC)
X-FDA: 84085871436.05.9296DF4
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7205F40004
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 02:34:36 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NJMpB2Ss;
	spf=pass (imf07.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762569276;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o5potOoY7oJuZDgAPEu8n/B2FvMnFZR/4eU+wIwynFI=;
	b=UYQHIFT+HuU6aV3jss0hLP23P3ZHXoGaLVKN43XDatWrEc47lmwk7TrpN3kQiLu7lnHMeB
	9WTfaYYxSNb2G+j6xPWPZabckgz3sbcXokskf8bxRgfV4bvGubXD6sBb3jPN/EClyJwnY9
	+9bXnR6+YOQFkBHZ3VwBMEyom7zcUrk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NJMpB2Ss;
	spf=pass (imf07.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762569276; a=rsa-sha256;
	cv=none;
	b=afcRnDS+iPaLtzCgsmXQOWyrt3OP+wUx1dcEhOXNThqa3aP1F0FDSuYp+82URT846y6r1C
	4BVuWsOeTcPa1MkzrJVAtCgWQb995A322AgtkNW/FXe+Q1LmTllGFCKtxlNuXT3Mx9Uj5f
	jtRk8vDb/PHFHw6TrdrmaHS3voInOLg=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b71397df721so153354966b.1
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 18:34:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762569275; x=1763174075; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o5potOoY7oJuZDgAPEu8n/B2FvMnFZR/4eU+wIwynFI=;
        b=NJMpB2SsjTW2zyTKaN/jubJMh151zTnbxzEvtSjV5RtIRkzaNOp6wPgpvmCOC8nqpa
         cCb9h+7g8c9TAQMm2H5D2XirRSGF8gWKLKBLIU30OOEKRVQAqfluuo8Fc12leoUu7bs9
         Zv/lEQjGFud0lqO1SX9h+z1wYXG2MrTg8fjMW2bZQ3ScC99hfcXmy72WpmhXt660X2Eu
         gW1jBaAYIxmEtDEzf29nPwULjaExQEsyi6LR3uyqHKGAC+V8ay6vfUXCQTiSNWnh2x4k
         bBj8wtFGYC/n7xJYsniNZqoZi3zEDDwCJ00IOaLETf9mRvY7Ov8/YeRAenEuZjvmqGwI
         yv/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762569275; x=1763174075;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o5potOoY7oJuZDgAPEu8n/B2FvMnFZR/4eU+wIwynFI=;
        b=Wzm1kOnmYWaMtscWlHdtP/wXOAo7FtFYnjNwF3/NDjQQ4ceWtZcZ+9T7GFDEohm2BE
         X1m5Muz36295FfeAcE4fwUufosgwqsVmYipmvG0jXjTGZlqTJTeL5j+Zww3TfV8goHKw
         mUBvGlIEbQo5RFUdjXnQtyBMnaLLn/TI5YpsP+S0ayVVvppsr//oQhEUv0Nrch/EQKzy
         nFWT8cG8O6PwuSYisHnhi5bxEkBBwo9ssyOrCqRz63/RZemByTomKYgyRA1Oozs8scOA
         73165a14V3MTiNTlFEJwfOkDqlTxKJBHIk6pVHH6TwppmqvVQzUwEJYyj+/ZwYmDTqrx
         dcyA==
X-Forwarded-Encrypted: i=1; AJvYcCUGLH5JSenpT3D5DjVJeC90r0GFmzaPcwcIFXTq2DjHcLPKCfTyTd3CDAeRU1rHYisbStEk/RKwZA==@kvack.org
X-Gm-Message-State: AOJu0YwQo2C5oKI3Raqj2kS1oUxt8aCvyVWXCi+RVupbYATrd/P1LAwq
	ndncTeHzJLOIq0swcTNKCqQl12AVgU/n65zi+ekgeCBBS3NEdo7QMt8Qih+O69aI
X-Gm-Gg: ASbGnctjRQvclBit6Q/Cl4Jifk6AThfJt0jo1Ppg3d2kqHjfgfsdw0TWFc4WiMaYzyj
	0OVxACOuWc9QVTHBGqYpXesEReEMdBNOwxH5U8YpotGz9Z3tosetuBorSiGkFx0mxnPYQ4mj05B
	0i04neHJazpyyy8LnpTXqAWF57+mOvrcwCsHMkuLVT4EhEOcJyDsvGmlCfETzelPn0nopZHxf0f
	oEeG17fLDyc2SV3DL8qk2JlEXQEdFQdbJz5gSqJlmceaMFSjyK4atBODTSFyR7I6AkggYYyFhhT
	ApPiCcXtKaV/xDfOjBhEKwhWYSzWoER1NnU2oh5yH0bpylfDlbHelYoy8NjqFk9GhJO6ivq1O2g
	pS+mJxZDE0GbM0sIc8OjyTDu/IsF+fvfcclWe+W2b1w6LINszgCZFvArRn+RHMsT+ItfH0rseMH
	VVweh1NVUJBg==
X-Google-Smtp-Source: AGHT+IF8sH5AJD5BmsEI+wfEUF+AscOx+lX9t+VpBog4E5GD0fnsTzO8XVh1qgisOXry5AIp9gqKVg==
X-Received: by 2002:a17:906:ee87:b0:b6d:4fe5:ead0 with SMTP id a640c23a62f3a-b72e028a487mr148451766b.10.1762569274625;
        Fri, 07 Nov 2025 18:34:34 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b72bdbd1ecfsm391337166b.10.2025.11.07.18.34.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 07 Nov 2025 18:34:33 -0800 (PST)
Date: Sat, 8 Nov 2025 02:34:32 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-doc@vger.kernel.org, david@redhat.com,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net,
	rostedt@goodmis.org, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
	baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
	wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
	sunnanyong@huawei.com, vishal.moola@gmail.com,
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
	kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
	anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
	will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
	cl@gentwo.org, jglisse@google.com, surenb@google.com,
	zokeefe@google.com, hannes@cmpxchg.org, rientjes@google.com,
	mhocko@suse.com, rdunlap@infradead.org, hughd@google.com,
	richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz,
	rppt@kernel.org, jannh@google.com, pfalcato@suse.de
Subject: Re: [PATCH v12 mm-new 04/15] khugepaged: generalize
 alloc_charge_folio()
Message-ID: <20251108023432.yqw7u7wnh5x3xvgh@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251022183717.70829-1-npache@redhat.com>
 <20251022183717.70829-5-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251022183717.70829-5-npache@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7205F40004
X-Stat-Signature: 99ho86anh1hn81z1ghcnmrqoixgt1t7x
X-Rspam-User: 
X-HE-Tag: 1762569276-744305
X-HE-Meta: U2FsdGVkX18WpnwFFe7fdH+JeuH/GD/F1klSN9EQSYJLT05BwB4yCizmJ81bp1WDsmA7lobsjNVwbhWuhbZOkD+3UaGsbrW3lS7UZym9hv+6DVVf9ZqLy4U+zyjuWbLTv/sP6QDGmbIHUBPLE670Yb74Cfe3BcpXICOGX+JbqCShryXJiBq+ar8P9LG+67YJxmbUcUUyBdqgQbDqSzR25/koUjaTjsAlykTbryIfWR9BmF4gWG/tR/Z65ezwGju1O7oywEgA/RTHB0rnToHPW+8Y6Dr33KAiMHBSLAT3/I0Rx0uVrLHW+9w6yCUU9J/H8jFPKNBAKeDKXF7ZaU07X8xyyMhEryVzckm12B6Jv6PL5q8928UaQvIsiZ7bnORcbYSqqksd8eCxm0ickhc7i0fdknx/kJBWGszGh+XF+P0smITARtx7N/0+s5nNvBepknckz6oq8OYdWT/j48Lm7F7pvBUh6wNBsOrI5ntnDXeyiKkbakeskijMJU1oolEr89QLeehL83woF2CiXEAhyNSu+Q+Q8+GKh2baFxV6YIzO3Xphl/Y78xcOM3uJQTlROAwpmhCaW5C4rV90Vw8ZnghrZGJQsnlHkL8wyocRRyf7EYA6AzUpEYkcgFpaB6pSONftKeT7vqLMXHlHr5QymYOTRmQ745SxqJkdibqD9poEqpISNCCl60OZstiDGst65iWtFM3pDwpnKiuWyXArtkgZlF7pevVRK3d81tHhjQ+oaVjXHbtrxCp+t3NFkS8rWlZfGdZYxZgbs7ITXA62L2ygIaSRwZrvfKPARmodwAJGuRf6BZoS1mUW4Fr3rnd0v81CIAgiowu/CxsdFxwIRqiVzXA6R6qah0RWDYCiCT61i5iplt1sCBdmy9EYaMyURZT0bODJ48FOFZ97H9ldSHVYqqxVvNJnJTYW+AsXZ0O31ocn1CXps+mr+yl6faYtfIL7OOBrwir9ZaeDb2I
 wPDsfK1e
 W8CnN1SDODDSyafw31/C2+cSxtf0SETYJgF8ym421vK5GP73Z3JB1kXu8ifCjzInlBVrwWBhTYQFhpxfVNA5OfB7oj8RUFuxpHI8ajHyaGAgc7PWcB/+seHKWrl9qg4CrgmCYsk/0wFRIORjqcA7M+Ws39o/k5pj9FcdGmC6hQXHAPAgLg+WzRwjcDM4/0P/pLgKZLNA198JGlhzDKZ5ZSXkYk5Bhlht/HDvmxwG0wwwhTz/QHyPrbSgLQ0Pd+hoxaYxtXHxgXuMW5EKWaJBvNqg0V9rQXy+50E+tMSVNEWf6IPQl6ohjBFGSFRoD5JJfRKEHlCGxEYg2YQDwUyw++6agOMsAAFsip8pTGjGZZe5tED1pJgju8quI3Mzvakuw9PBd477ETLZ13CmA43gNrxOgpllDJVoFfVsSaNY8cSyX0QpjwtKGQ+IyiErJTIhzIgyKI3q//xSpf/PedmBtKX2NCkgJdGLC0msa7n8CX6fp1n7b5wCnVZ+cMN0rvzrye4kgVFOTvFdTlSx5cmaHgkdTOFGMXM5vLOmRqCjDFbDNFeSNoLLvJCg091441ook2yo8cb79sx0cccKapY+dT6t5HClXO3IB4JS9F8PuGAERqCzMfEwmZUpUEvYcw8PNSGYHbcLQ1dRLqFsoplEVkaZJqUHCTH1wXQ6HCDu2efLpRAT7LSaSkMjx4HsccUoYY3t8AtD2A3IzM8dwtSh7qUB4OJTYqtQav+AWeHV88yejvGPWbDbAecXrfoXUGqCiuKKHTmeMZh6PfoIXxfBm8i/pl9zaGXmV2qbBfNnop2XOAHB9tEOFSniqYYK+guEdPDbiJruUdaS6mvbAOv94fAlAy4uUp0h48AvmgT44Gr+3Nb+axQLPfu04B7lvHkFRDdW5AbxkeLt9U96UgrDQHFB8tw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 12:37:06PM -0600, Nico Pache wrote:
>From: Dev Jain <dev.jain@arm.com>
>
>Pass order to alloc_charge_folio() and update mTHP statistics.
>
>Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>Acked-by: David Hildenbrand <david@redhat.com>
>Co-developed-by: Nico Pache <npache@redhat.com>
>Signed-off-by: Nico Pache <npache@redhat.com>
>Signed-off-by: Dev Jain <dev.jain@arm.com>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

