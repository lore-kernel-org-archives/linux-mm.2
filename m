Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E77C6CAC5BB
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 01:46:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EC408E000A; Wed,  1 Oct 2025 21:46:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C3D68E0002; Wed,  1 Oct 2025 21:46:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 301088E000A; Wed,  1 Oct 2025 21:46:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2060B8E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 21:46:09 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C1912C01E3
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 01:46:08 +0000 (UTC)
X-FDA: 83951483616.25.92DA9B3
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf17.hostedemail.com (Postfix) with ESMTP id BDD2D40005
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 01:46:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HqqsRT+1;
	spf=pass (imf17.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759369566;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1xHe/BzI7Wn0nREN3sG+EtbX3FgeLXjNJMls3Nfj1NQ=;
	b=1nwNeBjILhQQs9itKYT2l/fp/On3SumDtewghDGNsGP+6S0Ee+8/1vS2c+rBzi4WaoDezd
	BIu2FAz9H6mC05RvH+diauNHAHfZxDC9/+fj/nOARz5bv8sPPdgRDjQrJVi0QgrDIiBHw1
	xvSzSObMLQbWWGt/2GkzQyfMc6YhKfA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759369566; a=rsa-sha256;
	cv=none;
	b=A6DkBqRf42b5XHJmiJJftfupBUojlLMZgEocELl+ue0Pz9J/xvFqOKqADnTnbkp7YnybC1
	1H7NwMfvq5hjk/qTIXT5ASDFk5iwB6qrYDkViHtH4X/9LoAMNObdvDv8ByWuxq2TirWrpT
	NC/+qvxqyfK8+IQvjgY8O9wP8NmzyNs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HqqsRT+1;
	spf=pass (imf17.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b48d8deafaeso12018366b.1
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 18:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759369565; x=1759974365; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1xHe/BzI7Wn0nREN3sG+EtbX3FgeLXjNJMls3Nfj1NQ=;
        b=HqqsRT+1sviKaE/eDlsBwHF00BIdWtdv1SffOBF23dj/ahj1rBcQxJb525EN123vYU
         ddC9ybwDzaFXx0FES8c82uB7rAiWXHHM7/DRz2YJXeNo1ow4TW2aMVQ1vdGS3su1McP7
         kVvCdnYS650uMts+Q6m23vLEA7jbmIi3+FJ6uUTbW5DLHB2V+Nh9VGpU3PV5rnsLvq5R
         4FWmhgOIp36v3j3x7/flZ77WWK7U4ZadwU9h3W5QHGLjM26rM738V+9pufceSknD4BnI
         PloX7Tg6PQO67dgdYbUTWochcVdVdHyJ0JStssGagZKR52ZNklmUndY7n02TnPVKtEQD
         Wu3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759369565; x=1759974365;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1xHe/BzI7Wn0nREN3sG+EtbX3FgeLXjNJMls3Nfj1NQ=;
        b=nuMXNkylKv+HFKGW/GZsMjV7WkWBLZlEkNPaZGvq9sznhQ4iOmHR4OyYXCUMXzkdV1
         GhnclutOYun8LAXUFN6mEl14Q8Dqw3bANGuRKdUquXoyEbdvs030PpUTkMQN9263e5J+
         LIk9lNYRBx12K2BrTZiYZHIgZggzEJiMI1qVDLKqZEWcmFSqtgjWhJPNEp1RY0Rg+czC
         6EC1H0gZNorIMapg5o3Or1nBvTXyJlGzpfgI/f673jOEPEyXM7sLCYNw8NcA/caKS8bh
         z35OIFyEDe5o6utTtJG2nhI+impYZ4+Y+Sqzue9d5FLEHI0/vWvxe+ZdATjWSORZX/Ll
         Kb8A==
X-Forwarded-Encrypted: i=1; AJvYcCXbvVNysNN4ncXZkU4HookrkOwckmssg+HlKk0txuB1X3N0kaNPioMNzPPpiVqzSw6lOUt/NYW37A==@kvack.org
X-Gm-Message-State: AOJu0YwUfGT6PiYQNVHvolgIRZKzVGFZy8Ir4MH1k91VS9xh8fmzkpd7
	ojvtTugMh3x5NxVirSs+4/Qhg9yfmr8wF2Jpfqkt6Y6j64++FEkcpDok0oxwaw==
X-Gm-Gg: ASbGnctk7612+tYccoEnazrPgbtWc7VvtNJDIykLOKaQN83McY10XzNdIwndZU+MJIq
	vGBnBbDD6iDkNN9yseHtX5R7ukUIxTgkKsjsB98b2yLp3jC9wwxQc5bAfQK4GG4LoCgV1nwJQ4z
	ZtLY6Fd5br02KG8MZzWwng1kNbWdMoeAcqLgFlQdrhdflYoiNVNEF5F4RH4x0RLfX45A//YgkZZ
	POp/c+cQGW7I9/NqMzbHco/zaES3+wSOCluttRrSMHFyD3NNPz7L60RknQc/V8YZamg87428cB9
	UM/eHUaoQRTyqaISDkGyGMFuGCssiLQK02rj1N1OAK3Lr62LGbRD2mRpD5wbsqQKDwXHjv0/vEK
	F9BC92us4p8lf3JgBw4rt3PPDX2FxYFYk4M1bpc5+mN/7AwETkg==
X-Google-Smtp-Source: AGHT+IGRgLhCs6G3HsEK2WLx4hBYdgbS142jXanEuUtlsvPi9RCUlq5c5Mm2HncdU0tePK8y2sKKTw==
X-Received: by 2002:a17:906:68cd:b0:b48:70a3:d45a with SMTP id a640c23a62f3a-b4870a3d69amr97232966b.64.1759369565026;
        Wed, 01 Oct 2025 18:46:05 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b48652a9ebbsm88540266b.7.2025.10.01.18.46.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 01 Oct 2025 18:46:04 -0700 (PDT)
Date: Thu, 2 Oct 2025 01:46:04 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
	wangkefeng.wang@huawei.com, linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [Patch v2] mm/huge_memory: add pmd folio to ds_queue in
 do_huge_zero_wp_pmd()
Message-ID: <20251002014604.d2ryohvtrdfn7mvf@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251002013825.20448-1-richard.weiyang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251002013825.20448-1-richard.weiyang@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: BDD2D40005
X-Stat-Signature: zpbg7wekox9r31se41zcn3siimnfod6n
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759369566-119878
X-HE-Meta: U2FsdGVkX18Jo/Uy4ABQDwS6O767/qyER/ZJtmEq4ABVjH80ifCZQfFgYItLHTStzxZ0ROTYeUo6tUDRPTi3CTodHOyLb/41btsgDSMpxwpZslD5M633hhRxwSTo9i0ZFkqqTDFJgPVRnK/lRJfpyyzw/Z5AwIpHAnC3yf/38cpxK6U/1l7IRVuiz/b2ddeWsUjHlgbAIXzSAFiyxhpfzRs6JH4tYAAPdJsikGD3aQsroP5rRFenwd1opRAadlw1tW/RGx68KO/C+jJTnb698i7bNGadnJ7agXT+fwdvitsMM/JKnMLKiniGySy3bCj8Ystj5z/mOhvxFDuSmqirN/XsSYOOhEWhoaHEow3LcXGVEQ7im/4529PBDlsSUGat673Sn+LayyEcMP1EQrElW4GUe8R82fmk/NZQcLz4SWSM90lEuQXCUntNLkCprrr9KFFCspSvAG4zioXE7TsMj2s8U/VxbzI7Zx1DQMBd9Yu6W6vFzVfsDlIaD8JiZQd3kwxnMeUkr+jaAdOhaZEhcdV5JOjv+tQAgzNiHD77MYUdOfb4dgGAWCxdfuuU0wTY/T32Lyqg8ieButgosqE1MhEgzAeaxjcVVI23SVP5Dd9W1SL9nxvV70Wiqm4+p3womRJLv/Tp7w6ByKVoGa/ZYtosLXkr/ctPzdTtOgFTE6MsT+QJhpqx7IX8Z0Q1oW5fAfB0dVSUOnyUNgjPJ7E4sXLLZ/ZML68zx2dneAcIJ1iI46CpwYRgomuV9x66B/IgNClukUJUj3gKQwRwF9QaVdwJRZDYlBst8Wp4ASjonJtbR80Iwn8xI2XioPYCFgFvdUGocwo4stjr7TJrmKn1PisXVi/tXOF2WpAHNN47w9xJ1yxJUCpKduwLKVVHbyBT+Iq5FyBLcTmKTiPBtZbX8bdHVoJmG8AQTvdmcR883/9QIiP3JhETpzWKOp2HhKNJk9mwKECAR6b9Z08fZsT
 slI8K1ZO
 bk1VTBWj+nzmN7squrBjj3nxkhpmnMIcmUVOCO6opo24uugL+/FPX65x3ND6xGabJvZiwZVRT/B8hTqIsuuWYEnpREw87sSVnfldsovnOKmx6LQVxnlqWoVkYs9zrxBWjcQBcH+gvPn9RiZvj+dDx1c/KYMzVjcro+DpyUFsWEMw5VcvX6OitsNVA/+Bx/HeYDHwmVO8soWL2QiURtD+8V7Ke7wcXTIXLdzzKGzvPlPFqwvgI9yhkR7wnBDoTe2XCPCiFitdgHv0agOJLqmUaU6D2YmWS1ubu5zdHIuXgtUHFGUj7Y/gnLLDNf1x20XBv1Zj0jc1rDJYShGeij5aTIk9gJ8zFqMJqWsIIUjRR3pIfA0JVfbEI+XApVwB9+jxEC03opejTpYOwyBUAwX3T9LYWgSI3VpAXwxzsYGsxI77d1fiL1Rjz5YT/2UW4R1Iu4ekQpgQxaluBB2GDf/XgaXWV5Nn9j7oaIw4LMdwLu7ZAFKQnWbuoVukc2dVGDoXbtVWPjwDIV7eiKf5cxr5cKKuAVvVysefkGw4ng4e6VBCEQDelbin38fabBUqcmk7BKoAuiE5StevxdAaGCKLf0mK8LPb7hEr3sDH/8/ymVbF7RwSCFxRvvQs69jeGrWFpul1u2Pfg549WDnS6wFRmIxEeZF5B5PpQuNoAyHjfSO0bPY0jPM8i/c0G5y7TAn2Zacd59pU5KrirhP1DLng6/zHfQNDxriMUltUXfqoJdeBzWYeGsANanhqnRZsmTWymIDJeOfTPHXfyChzJjvM73IpRkeeRA3ttljsGI8lQ/jdG/3VQNUkt7UKjyFWR1MXM2raTnhpXr8NlqujPhMnLjT2aSOHo9TiAOVUmpsbiTyA1RQJpTAazRw4VeHCXpzyPEFGc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 02, 2025 at 01:38:25AM +0000, Wei Yang wrote:
>We add pmd folio into ds_queue on the first page fault in
>__do_huge_pmd_anonymous_page(), so that we can split it in case of
>memory pressure. This should be the same for a pmd folio during wp
>page fault.
>
>Commit 1ced09e0331f ("mm: allocate THP on hugezeropage wp-fault") miss
>to add it to ds_queue, which means system may not reclaim enough memory
>in case of memory pressure even the pmd folio is under used.
>
>Move deferred_split_folio() into map_anon_folio_pmd() to make the pmd
>folio installation consistent.
>

Since we move deferred_split_folio() into map_anon_folio_pmd(), I am thinking
about whether we can consolidate the process in collapse_huge_page().

Use map_anon_folio_pmd() in collapse_huge_page(), but skip those statistic
adjustment.

>Fixes: 1ced09e0331f ("mm: allocate THP on hugezeropage wp-fault")
>Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>Cc: David Hildenbrand <david@redhat.com>
>Cc: Lance Yang <lance.yang@linux.dev>
>Cc: Dev Jain <dev.jain@arm.com>
>Cc: <stable@vger.kernel.org>
>

-- 
Wei Yang
Help you, Help me

