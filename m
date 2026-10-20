Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12E83606A332
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 16:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=QcsoRHPe
Received: by kanga.kvack.org (Postfix)
	id D019D6B0517; Tue, 20 Oct 2026 12:10:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB2AD6B0518; Tue, 20 Oct 2026 12:10:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC9976B0519; Tue, 20 Oct 2026 12:10:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 821266B0517
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 12:10:34 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D6E58140278
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 16:10:33 +0000 (UTC)
X-FDA: 85343492346.29.DB1F2D8
Received: from mail-pj2-f6.google.com (mail-pj2-f6.google.com [74.125.227.134])
	by imf12.hostedemail.com (Postfix) with ESMTP id 13C474000D
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 16:10:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QcsoRHPe;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.134 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792512632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c4lo9c1DzgFzppkuIe3m48wNpvzpTiu2Q7BfuVscJUc=;
	b=nBfAVgsZkyBxxcP0/1zcBpXlkyRmbf7hdJectkfK9H8jshOpmjj+ET+DMD8REzQAXPKMVG
	85iI3qgdHkqw07uCj8e8vB/eZXR2V4urOtzLPtL0Q3D8YhyLYDEeO9TchvTa5He5/o4SEq
	CUL6YrH8aeAQMJkDdLSyvEG+KLxq6Sc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QcsoRHPe;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.134 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792512632;
	b=BO9JqL0KOVLDzz2pMGpCL7qh7PxqBBmu/Ddaz4Y9BCBtbAxENQ0UKgbVZ9kVpjBDiYlADQ
	A4LYhOjJ2yWdSBVxNj/wSrwEIRotOxLZCJeVDryDWZZm5y8cFZL+V7BOgPMshEtAAI83sO
	/Egmwnd6m2tckRdgxHhnT/Fix+r0XRI=
Received: by mail-pj2-f6.google.com with SMTP id 98e67ed59e1d1-3ad211ad92bso773190a91.1
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 09:10:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792512631; x=1793117431; darn=kvack.org;
        h=content-transfer-encoding:content-type:date:mime-version:references
         :in-reply-to:subject:message-id:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=c4lo9c1DzgFzppkuIe3m48wNpvzpTiu2Q7BfuVscJUc=;
        b=QcsoRHPe6tZUMbIQU3FaJR5Lej530hx9x1A8PE30fF5SrHzrOGbHwrnvvXJHFPMbin
         8EY7J9nvwoPdvKaG3qfcuhETT1zXxIpEmLMFDKC3/920/PCYqEkPQKVqbANGTM8DJivk
         ZhuDNFS8h55V5PCe+vWu04gNSjr9hNA4PztxtaronB+5/XMbdBhNCcyHVPCt/yvko/IE
         6Sc2SNLVJTI12fkXCMOtl5YOkX0VZrwxAEwinAZk1ru8w2ala4NIAuemZb9zRP+qxgQ6
         7FGJKLahTesexJl/orlVmpj+jEC2NBJbHxL0ubJ2dzf66GgE8w9fYBz38NPZOXwA+CTU
         xz7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792512631; x=1793117431;
        h=content-transfer-encoding:content-type:date:mime-version:references
         :in-reply-to:subject:message-id:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=c4lo9c1DzgFzppkuIe3m48wNpvzpTiu2Q7BfuVscJUc=;
        b=wEp5SP3VuIGT9bYrYlPaXCNmpqT/8djd/Aqf5VpvPjEkO4cjeoCh7FCj+uNSXvuAK6
         G26XZ/F+FkU4vLpDy014NCp3HLnH85n1JzXztG56+RL6ILpc8Gtp8ze3Ufv1OxvUb1rE
         57Wx7T58Ve7LtbuRBlQQOWwyBxtPwZ1gbQe/FaFR/XXyEfNFSG1h3TCKkrnoR3tRj0dE
         YJImRF3rKp5ou8aRJuzqr8L/QGat2J6eqJR0CmBfAPLdz07FFRvztRpOD0W5egzLOafs
         ujFfZVTBqLQIAZ8Nnr3DpCE2tmaSr5Qn2rf9cj4J8Jz9Mb4fyGyHX2b14a8DFjgF/uG4
         oc7w==
X-Forwarded-Encrypted: i=1; AKwUvBz4aJ9W42V3XNmUAxYkChTDQx+9dWEA3Dung8Yc50tLJVUPq1C9BQuGUdXs8IWnvT1c1A9MomQwDQ==@kvack.org
X-Gm-Message-State: AFq9FYJpLxCOg7wXFzctq8hpxBtpJG4vosePIsfIAc09KVVvfpdZ8NuM
	2zfu/k25Xu3WtqO3dnHPvYcY1M85BYtL92cZTHrMj4QWQUBB4Uh8QNQk
X-Gm-Gg: AYBFou1qDHUFbvgFdF1bVyxtSgnlN4Jhm1PkLYg9hKq9rO/ITS8JVFLESHNQEwI2CIx
	7s3KEwImlmUD1H0RTqy0WVFk82g/iH++Zz6WOskECmnPUQIJDwFVCJxz2xr/tk0yxuQLKKSCzzJ
	0NMWhKP+08hkcHQ0CqkZRjIJm9MQq3jMgSicpn1jpXXyff9mK7jRulYvMrmG4v8vDVWvrjIPHUo
	RcOoTFsAqHKRGu/IR57Hqe/pCkOrdlFD2BJTSvKXhpee7jskV+bJQbcpvv7r/3CD6sOkaXK/j6B
	zKti3F2nvuG271RnkIdWwWR/0m2ZbBbzVFFaxYaKzmydM+aB+OF/OOehvJqukbJyW2UAZqLXzcH
	J9F3ajE3clLMSefpFSPClHFCBLqHiSCBa7mHlVYPtCj4dPrH3HMq31gYHa/YAV9W+OD3JsjfGQR
	FF4zzj8mkphB1wNvuzSqBon+dBc7ebGhbhbsWNAHCMhX5w3DYmIqA69Xmy6v7Ti/DPJOlZQ22Hz
	mRihiaajFRsm4dHj61jsaWONPhv+1nvaNmCK3vGbZ48iDRDsQVNNIGOPMlAU42XjNw2NSU=
X-Received: by 2002:a17:90b:5112:b0:3ab:c80:9365 with SMTP id 98e67ed59e1d1-3acef0f47a8mr9810302a91.42.1792512630823;
        Tue, 20 Oct 2026 09:10:30 -0700 (PDT)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad80cbe295sm87743a91.5.2026.10.20.09.10.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 09:10:29 -0700 (PDT)
From: Aveline Noir <jm5905938@gmail.com>
To: SJ Park <sj@kernel.org>, Jinjie Ruan <ruanjinjie@huawei.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org,
 rdunlap@infradead.org, damon@lists.linux.dev, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <179251032453.2.6166799753856435091.damon-watermarks@gmail.com>
Subject: Re: [RFC PATCH] mm/damon/reclaim: allow disabling watermarks to force
 reclaim of cold pages
In-Reply-To: <20261020135822.85334-1-sj@kernel.org>
References: <20261020133233.3920818-1-ruanjinjie@huawei.com>
 <20261020135822.85334-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Wed, 21 Oct 2026 00:07:00 +0800
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 13C474000D
X-Stat-Signature: oxjtjjkx37yqkr19b54mdp5k77fw9w7r
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792512631-373098
X-HE-Meta: U2FsdGVkX19V588hszUm3OCQFaWJjj/RJZcy2bKwRQH1ajLmxN2zDCPOJaRg491KH6igScbw56BCcJhAAlHasz7iA68Ah/9OVfHn6fXxSLq1QAFsi85FHL6tfGbWZX983YL2ryzOIhHtDz//x/iU1sw7HBAuzQ0cozYO9b8rAd/40wP1RPIqkfm9WLZ1laxPnFHnWPcjjAb+x4KNefviVqif0mU1WaoN0m2u7BiHXvTE7MhGC8LQ+NTNLyRM7gOmIbu7hnIHonUFetJUCF/9/WBg30btf8t41NAoIJ3+GjIJxQu4j1JqvclCilipFnEdvtaFSYZbrw3BR97hcj6mo2xXW6ygUPoTyNYQw0fQPeosERaV+1Z5a9x3sHh0EupGh/CUgB4kNn1GyVsxmbeI+sYkOn9cxzBr9YMCT/30jLYjaxytMXhnncuBXl+XgON9ux//u75cufCyITuAYq0v3QTLA8o8gSyxqqiF6Yl7rWE/7HP3j+JNVNreOxsMnLf+qfgbs6t6AACHuH5KjbILUnj7rVG2C1Q3I/BEY1SgNdQRLW07qlvoxXXk13hIY9aHNoC+srnnY/zwR0eGnhng5m3PzUNrK8DtXgFlwexSrvaH3JeRBfwUa6WKAzsuxykbhrVrZ8c0iNrrLIxaBQRcJBROOPUhwedRTiDx7NGNKLRgiH/S783E7+prPA2fvn+4WJQ8ysukRxxHLmmbex0nTw7XvwEbVltqQl73eCE779C9ygLN98OifLLpiFbk2p5GbEGFoZMt7naMaKT5e81s6xW4CqnaynjU20+8hMPQXyFaP4DSH9+Rzr+eWRk9DsBQA5rhQ+H9vAErMHtWbwZK7wcitTfXkoLmWpOjorcu13aS6y7nUXFlpbyTd6Nf2z5XNgXuKZiZ814lFUZ/1Bc2KlEMAsteLokQ86ptjL+ieyF5O90ySMysH2uM4aYQpNQ/LS2equdSQyyymAoEU7c
 UVjFWXkX
 hen6pDyxtF2kPTNQZ0ehmkyOvtWhrd0s0Ytfy8Z5kw87grf+slteA3cPIqfrdUELqW4+pp0C+TVKW5xmFXhLOMO1cCrjuBKpeoCPjvx7349slLaQK9DFQnpNn+a20TwXA6s0LSfQTaaigLtz6SVAjDUzxLrrB3egXI0aHtLiJxxYm23B0MHWYzqe7GIAkzMkHFXcH11M1UphlV0Eu9DKcJpiUrC345onpeD16nQEFFmDwYivDWzAZJeAYEilUL+I7ADyrQC6fITzmexSoAsL4OYMQGsGTnnNxyVi2RxKsOR2jpXucnaJTb8ZOJnjkG1xgCGgVQndxlvEMX930/Tl5w8UKz6xV+SH+9nQoZymug1eyE4ZqBUHGOnlxcRY95h4GYXzU0GzgbhgIj0T3CIRWlh70C4Ev462oA3xl0xz8+3926AEcbmoLA4dgbDLBxAfr4h8sBRXhbt7VSHLQ46KgNw1duGpA+zpfhoDhy0HkHQOzsPE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

> setting wmarks_high, wmarks_mid and wmarks_low to 100%, 100% and 0%
> effectively disable watermarks? Have you tried that?

That worked in my test with swap enabled. Agree that documenting this
combination might be useful.

Thanks,
Aveline Noir

