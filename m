Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 663C9606B2DD
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 22:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CNO+9P4p
Received: by kanga.kvack.org (Postfix)
	id 4C7016B05B4; Wed,  4 Nov 2026 17:17:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4784B6B05B5; Wed,  4 Nov 2026 17:17:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38E366B05B6; Wed,  4 Nov 2026 17:17:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0301F6B05B4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:17:43 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5DB9E14068A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 22:17:43 +0000 (UTC)
X-FDA: 85398849606.02.84E06AD
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7BB59C0002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 22:17:41 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=CNO+9P4p;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793830661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zy3RXc1tcA1988kqstuh2d2K+SulFtJvQ4wEaNytXWM=;
	b=jqHxAu+Nxq67TQ5I5Byk8fE9iMthDhyH1J7aG5v+upefdqVkdcqrO4hvvvUJ6tmi9P84oU
	m145u1X2l2CkLnG9J3zvDiPwjeQexCDT9jy0R66Km99Lhl+oBiZJIXVMj//NKQPMEGkEbK
	+56jUVDNEtNfcaSKKzw2LTyjrqhjYfE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=CNO+9P4p;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793830661;
	b=1ou89yBPTPbC9FhENnfYkA6BIXOM/qoPgS4oAU5uYS+c14JTxQ3YjfRm2UINxSPuuw6It9
	MZRibCFw/AGBsfBf5z6MzNGUb46jl/Z8RNuCV1gRp+e1LNkIG4UFecReyg7zBgs5zX3O/3
	zM77MJESYdvIzB5trjoq60JL0DkMhVo=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a2167bd087so10093675e9.3
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 14:17:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793830660; x=1794435460; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Zy3RXc1tcA1988kqstuh2d2K+SulFtJvQ4wEaNytXWM=;
        b=CNO+9P4pYg2lk9vYOGMwb6xgJYembzV2J+fkycx4PZP2TDzydd/IFhTNsUQ3/5F4fM
         byMOWcZmcBsIxBwQ1wrXz2WIurMIEA/QalPEHiWXwsyqb18PrHfyUGKkQp6c58ggtI79
         xaL9xLf42hA8oygbmhhq2lzmMOCl/2j9IWIK0J4PoYtNp1X9hdxgdRCgc898pU5ZD6cc
         dpINP4akEAog/9lZttA95GrRYMGZSGXB51ffns8Uh0Kp0gXuqEsLFusw6uZHJAo6snaF
         vmCmQTnuOl6qJASCQuyvU46fgNW/irD8w1bTwNUAeZF/QWblVs3iHmQFgqYsmuJk/+TB
         z7Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793830660; x=1794435460;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Zy3RXc1tcA1988kqstuh2d2K+SulFtJvQ4wEaNytXWM=;
        b=mC3+rIjTNmqWaYARSwehTk68pZnx8B4MOqQtax207Fj/skumx/CdIpjBywTabccpiV
         Jx6JIGs0T+Y2IWHYgqV6ec6kSS+PqvKaJ6QcRhz7B06h/PraEQE4UgxCUOuojSxZGRYk
         UriMR07lILrl2292Gnt62kcVPFhqKAAFsfflDVaZ/L8xJjT4CVhto30lgeimcjdot1gL
         JGyPbujYWR5J6cFQY7/MqqzahNDNRMMLM81qp6+EBxRM1XViVBWIFQtx3uvczhVLmnzc
         Poqr6hLlT1/l9oSOkiSROEkqXomkWXZyCeKCBu6sopm/yN6dvqDcFTeaPFViopVKmhv8
         ph8A==
X-Forwarded-Encrypted: i=1; AKwUvBzR7MW7HWKV+hiEFnMKZU7b9SwKQqdEvXVGSesbU0mdi7uY5jl3fH691KF4iGM1cv8wNSAaArSTXA==@kvack.org
X-Gm-Message-State: APuU4Z8UwTYFx8rlKmuOtXOPRYojLn7OPuawhptYJgQkqdJQaqo6hZlN
	iw2YWgt9EFBftxIygB94dP9km6ueBrFSnRv87N+uXBlWtnuHTKj1t+jT
X-Gm-Gg: AYBFou231WIPYTBFHPCE89fiM9LluWevK6e+NFt9yPko2hL2iUBrRstKE6wZsjgwofj
	37gNUfvoxcWmMf3xjXiz7iVy79tu0t7ejuGXBMi618FOzC3Ew2xqkJHBCVm5KzQqXLTbECO/gVL
	567msuRo9sKwkjo94I8AAVUoIAKLd8d0WylzmiAumo1lnMPztLOR/x//54HTMVIz3SICLPPN1j7
	DXFkuGL2a6fuqzK/nTVHnmAtZ29LKlMPLAbk/WGJqOWmFv6Gg1E3JBISmBhBcCtw20IBbtO9vyF
	XkILuZq5UkLaTZ1UNasv6haOsNCUAH2F58ZzH1Pcha/4oHQH5l/kyoA0UDaBjOsXMOfD6jFNZOD
	yxTt1ZaR41jDny3LPWY2Ss4+sqIxMUtDLCNJP2hjr5WheHJTi+shNz08EOI7I2d4+8jTKgC4zO1
	k85QudOPb6T4jMTnrDeZYpMR0TnMte9Y7bnW1EjhBZLH5eOPUFjyGVSOT3FHXHhFHthQGgt1EYs
	rzOS2UyKl+mu8QbSk9Vg95gsPHkPqvtBcnB92lrh8cLUT8rC4VXDtNrqh9J09wmd74qCJ8DXVo5
	TQSPa5ZY2sxyBZv0ZC+KOHZi
X-Received: by 2002:a05:600c:1f93:b0:4a3:2f35:38b6 with SMTP id 5b1f17b1804b1-4ac180f1e69mr370561825e9.24.1793830660020;
        Wed, 04 Nov 2026 14:17:40 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b56b78d656sm16661715e9.0.2026.11.04.14.17.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2026 14:17:39 -0800 (PST)
Message-ID: <7b3388a4-31c1-4966-af92-367e1219cb42@gmail.com>
Date: Wed, 4 Nov 2026 23:17:38 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] kho: fix bootmem sizing
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Chen Pei <cp0613@linux.alibaba.com>, George Guo <guodongtai@kylinos.cn>,
 Kexin Liu <liukexin@kylinos.cn>, Sourabh Jain <sourabhjain@linux.ibm.com>,
 kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20261104-kho-bootmem-sizing-v2-0-b0d1a834780f@kernel.org>
 <20261104-kho-bootmem-sizing-v2-3-b0d1a834780f@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261104-kho-bootmem-sizing-v2-3-b0d1a834780f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7BB59C0002
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: fuq4fcdj1b7outxx1kf1y8gt971rzwhg
X-HE-Tag: 1793830661-961546
X-HE-Meta: U2FsdGVkX1+WOFPHnRTDAJ6mvC26iKtcLSE8aaxe6i+9xwuUbAgOgsEpSHgab0bBxHxVaDyk2tIyN+JSxlZk6UI50AM7tgGZ2OHFYawYyDwY3vcHwVUYDuLufs+eNSdOH7LIe/cPeQVPbzEJDIXyEo+1L6NPF+8qruEBB42WmwKsGKgEDJeimxpm+S1BXPX1gUQAlgDVCZI6wfZO+IAMCxL7IdnOaXgXye2Xmtcquv2sBG5mMtJFGxSQP2S2dLYvnKE/DdtnA5kTXUovlJ0SnF/vIkWl31U7tFdlj0rdUbue1Xgvd6yaDdUivt+LyPTi6S5vNEOm9qY/RbiVPkuLeyOQh3gErpgIARs2It/tYDx1PnFtT1uSaftWShBXTnJDV8gIlvY3P7t/4saTBGnTNYfxgmdeLlBFVvVD6m2NnoPEco6pCy2OnC3IH26QTAg1sYH0ZApSNY4vz+S/4gD33tzGiWN6GivNabS8j16fEa+kGp1Qn7AUF8y+xmvQG9ln0g5ciC/qAYqOaFKF94yKWeZATPt3soXVvCNvIUQ3w67cPGF/5EGvg2VNioyn/VQLWDy1R//I7Qn3EIBJgYnRIP7+S5qwjGiSNV2mSATwzAClHCOE3g5Lp0Ah8xjDFIsR+D7pjstwqwz23iDoiCR2R13hJUr5jPZs4rCMP1cOF/3tNi3D3oreTSs0ywHBtg7lCL4ZCpVNPwaXQW1UZ7ophvWbT3UNUJuIORXPeIXy8OmFzhZjBv9sSrpmNNqX4fiwg5wIOtk2dF4naEuZPVI/n9HNd1FEvkzdcEPa9Dzpvgi5XJAu7Q9FPZqStqZIbvLId4ZGX5qoswPQ2EpmfvfePgnbvrZyI5MUkKgvhYZqHYr+NPB2XjA7asAbLcAbZNvHLZHr0vJ2Cxw+r8A/uJXb8Jxbw2izMhNLwwLAKrTtmVfdn0sNzUhMZKntpIz9CgYVUtwGkrVhN/sbnjZNz9O
 AIoAWXGQ
 no1PmmB6FMCuT4TS7vyH54wdUNHVj5BpH8xDSobsu9xXSJMiIMVZcUoaclGzpDqpFAoUDFASQh6cDDkLvD68w6gLJvGSphgNhRAV/lMHb0gjkWwih9yEacyCNl0jrhNij/XSCtaowEQeADhRB/inwsFi+Oar7ARutboOZrhyym54Gg4r4pqBBTFknximZ/uouPxVRbOJ8tcPFkUKWSNx9mhnPJm0t1AAz03JeSiYkNTdk11g7cDjI2nhNid+LAIIhvE0gEwbMf7y4cbOXYFQ6CtD6PfC5bm7wezhcXcCyMaiEcd5ZgJkISNYTLBS9//2YRgTouvO/kxXw1MVnScayXrWRx6u5EHwUCv+al8bY7qKVs0dEnl7lzcA9JiZHZ69VJQZllIgt/CuiBdmSEL1GUdtLrGhAzMJmW1jSZ+TooYGSuxC7oxublyh5ob4IuZeJ+cu2PRmQ+0HxRI/KVAkqWFPacmJQBllopcnUiTjWBmvVpHBCJQ+vhSfIJSNz0nPa6dXL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/4/26 5:50 PM, Mike Rapoport (Microsoft) wrote:
> Bootmem areas are sized from overlapping views of the memory reserved in
> memblock:
> 
> * the global area is sized from all reserved memory, including memory
>   allocated on specific nodes, so on NUMA systems everything allocated
>   on a node is accounted in both the global area and the area of that
>   node.
> * per-node sizes are calculated after the lowmem and the global areas
>   are reserved. With CONFIG_NUMA=n all memblock regions belong to node 0,
>   so the lowmem and the global areas are accounted in the size of node 0
>   area and scaled once again.
> 
> As a result, bootmem is about twice bigger than it should be on NUMA
> systems and about four times bigger with CONFIG_NUMA=n. On small systems
> reservation of the bootmem may fail and then KHO gets disabled.
> 
> Make the areas cover separate parts of the reserved memory: the lowmem
> area covers allocations below ARCH_LOW_ADDRESS_LIMIT, per-node areas
> cover allocations above it on each node and the global area covers
> allocations that are not bound to any node. Calculate all sizes before
> reserving any of the areas.
> 
> With CONFIG_NUMA=n the global area becomes empty and it is not reserved.
> 
> If ARCH_LOW_ADDRESS_LIMIT covers all memory, as may happen on arm64, any
> area can serve lowmem allocations, so don't reserve the lowmem area.
> 
> Bootmem sizes in MiB in x86 QEMU VMs, before -> after:
> 
>                      CONFIG_NUMA=y     CONFIG_NUMA=n
>   1G,  1 node         176 ->   92       320 ->   80
>   4G,  1 node         508 ->  332      1264 ->  316
>   16G, 2 nodes       1268 ->  704      2944 ->  736
>   32G, 4 nodes       2296 -> 1224      5196 -> 1300
>   64G, 4 nodes       4344 -> 2248      9664 -> 2420
> 
> Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
> Reported-by: Kexin Liu <liukexin@kylinos.cn>
> Reported-by: George Guo <guodongtai@kylinos.cn>
> Closes: https://lore.kernel.org/all/20260904025101.9959-1-dongtai.guo@linux.dev
> Reported-by: Sourabh Jain <sourabhjain@linux.ibm.com>
> Closes: https://lore.kernel.org/all/20260922131217.698809-1-sourabhjain@linux.ibm.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

