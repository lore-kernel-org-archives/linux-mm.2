Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 770C7606A31A
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 01:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=ElbwF62M
Received: by kanga.kvack.org (Postfix)
	id 956BB6B05B0; Sat, 24 Oct 2026 21:38:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 907EF6B05B1; Sat, 24 Oct 2026 21:38:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F6CD6B05B2; Sat, 24 Oct 2026 21:38:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 420B66B05B0
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 21:38:57 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 28F911C3B3A
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 01:38:55 +0000 (UTC)
X-FDA: 85359439830.12.225AD97
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4E05080002
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 01:38:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ElbwF62M;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf02.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.48 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792892333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vX4jDwUVQE1PbT5Y2KzG++B9u8Cu7vIzDB5HJALt09k=;
	b=3ZmVij6Hyg2IL2dXZ1FugXp5SC191+NXkkwcBPzZY8cFzvWnP8P8A8BNVmhptbFoPaeXfk
	9i0kr7diJelEXbCAjw+NCLxFgNY7uQaYXEL0TywoBit/iH57USOO+B4qYRj/VRv9V8k4hH
	6Fh0ZgA2D+y+/2ONSRybuSohRJLNP58=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ElbwF62M;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf02.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.48 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792892333;
	b=dTq2bDw4cCTYiO79RwWgPlnNUegoMqnTA+MCiJnqzJEtaZDbhiukBX6gZ55uLJb3xAXKUd
	phiGQS/SCO2Bxb2XR+XbKF+ykCsH4/uHg7JjnKFjWkRDr6QKkBuGDEVJfCMQW4ewjFAFu3
	1kf0C4RwwP+63Zla7mA7dKHh1vi9KpE=
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-14fc585291cso698337c88.1
        for <linux-mm@kvack.org>; Sat, 24 Oct 2026 18:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792892332; x=1793497132; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vX4jDwUVQE1PbT5Y2KzG++B9u8Cu7vIzDB5HJALt09k=;
        b=ElbwF62MSpJAmlaojIExNSDgw0dmsDIMU7Np9baRq4fCNJrMAuAApv2D/xYYHFd0Dw
         JLmq8q4MjWLNX0qaF0pCv5NEl+Rwx1odkzNEwn6P7KnG/SdPVq2Gj+UVXE006p5wD3/l
         FJJWdhCNZA4UM9EjEVIuooON2hIFDJbLtpr7Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792892332; x=1793497132;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vX4jDwUVQE1PbT5Y2KzG++B9u8Cu7vIzDB5HJALt09k=;
        b=LpJ127LGNgaOdZy+9X10F9X43pYteQUB9fGti0YxR5E7WIoOxy0nxEveINFU1TSmuH
         xjdN6EMl9VD7nkqJsQpLuOAXnAoML2MoujnWwMLgitne1t5Migsc5OfOUkTJICZD6NGJ
         OPCvh6hwCgmuS1haxEhy26SUz+8efUKmFkrw8m3QV92bxqv8wlwFj8qzxlhSiRMCmPmZ
         sZ1tpZRcZfV7FDjRcpZrEOIP0ba5rIqzWI2/d/8OilTyWhSOuxZXM6ICT90jJiiyiIDC
         Pk7Tj9mz+oqZOUnGdb0bLxd3XMVKO44TbldmULJJ7kTsFE9S73rvSXdVjXbPPQFgp4aR
         MWog==
X-Forwarded-Encrypted: i=1; AKwUvBw4CpiPpl89WGK+WIdnsFY5JXq4qzTeibbPt0l/hLfWK1nT/7IH9jbmxMKaBgajv9sOsVjK1Vyaeg==@kvack.org
X-Gm-Message-State: AFq9FYIMtPWAQnjSjE2SdhIkW9lwu/eHMrIruZpHOeBvns+NXO1PGrXR
	/rrsXHi5NuYiNtibxPBc9kvm5FRj9qTgdDXHERGnYBMm+aJkKnZzsmAv3gDAuZq5Xg==
X-Gm-Gg: AYBFou1u3bAGgcSVKd+o0NTEcpKZl++LRqcdQENPwHyRCurdCfmgV7DnemPD05D5uCx
	OK39vtujzZ3Hdaxf67b9vVSvdHxN3Vs1aHL/rSwAodeQjYRPt/IH15lxDKk+vY+N3iyJBO1gmIs
	ivrKkOiy+kL+LuLSdOpymt4TR00Jm0ATFX8ae5bmargkCpEmkxyT7tk0CzrOUTyT+d8CfABiS7j
	Wyp2zzyI9E3+3+aeG0j+u14vhcu/A7tfeL0m/QNpap1mt3vsYwCPNQlTKR3ysMBembPFAnEPqpJ
	8V6tMNf6nzqQlsV0LMmRgn3x7oYB8FB+Q9AoflVJMLfPpZIT/De9tsp7a0zzrZO5e59rq3xS8lO
	nAynzuOPmL/G5qoC0yc6wSsE0uLvEN/AxrvTP9U/h3EPHGFYa7n+GAwm67mxDal0cVW9KHM0JhA
	H/67G5zWJ6iglWvySShcdyjX3SUybTxkyiCdemEceYRnLaNb3Bonunj6I90Bpt53xl87NkIxMC1
	66MocuYOXM8tL6Ax+YCilQg9msJHnZLgqISthzBJYvj0N8aRRlKoBQgvnuh8RbiRvEkLM0ZAHca
	fTFekYEmCiDHKxr3qw3qh/NdLeeCHJW7Twzlw7wBDw==
X-Received: by 2002:a05:7022:7f12:b0:176:2095:1ac4 with SMTP id a92af1059eb24-19935be809dmr4891737c88.18.1792892331865;
        Sat, 24 Oct 2026 18:38:51 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:9f87:66fc:8c85:11bb])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-198a21bc6cbsm11000132c88.16.2026.10.24.18.38.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 18:38:51 -0700 (PDT)
Date: Sun, 25 Oct 2026 10:38:47 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Hillf Danton <hdanton@sina.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Barry Song <21cnbao@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH v6 09/13] zram: split zcomp into separate R/W streams
Message-ID: <at1cSbfBXdYIAIyT@google.com>
References: <atxFgutP-N3UZex2@google.com>
 <20261024101401.1035-1-hdanton@sina.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261024101401.1035-1-hdanton@sina.com>
X-Rspamd-Queue-Id: 4E05080002
X-Rspam-User: 
X-Stat-Signature: n4dwb8t7nxy6mxkwxuke863m391opm96
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792892333-850951
X-HE-Meta: U2FsdGVkX18giSkgJXOPHidXj5H8kQHRCcN2WTep0MvxylFefYxusDA3/ILOJo14kYPsZrQIJCPMPVyKUbmi4MS8tAc24kJkOJnxm62g/n1ldWaCMibw3KZsRSAnqn9k7d94qIhuy/blsM9q9zNhGWR9G6y8FAJXc100haZWzFe8GOJzhORctE3Cis1d+JGLJ5Tf151lKaMvdo4h5G+FSIrpj2WfMWaJkpYt1zrzKjmOoidm/YCg7jgCAnwcQy+JEoyeJFAG9J/s2Ob/xjA2qOn/TU4nQ90kdU8sowfmjQSGs28LeEKtET5sgW0w+nM/OlriXepoqMY9HJWiJWa/RaFnaafKFbyduQB8g/yzGIAOAQ7HySQ7+ylMlM8E5QOce8YuXd3A+46Saoc2sn/KZzuvzr2riYgL4ssBD5ne+hsz+9kgDitWEO6Z+sAd5OVzLsAqNq8Y/Zim1L3nO/7A2OBw2DFkqAeI5oaq4XMoRpNqYXD+whEAL2CHiQIbYZBLWHnBc2uJ3VKAYQb5k5wYmGl6y7ReE4comc2D8Z5oMk1TcQW9mGKssqwV2KgyPDQJi97aTPXYsRL/MqMTyEBnpO6uc5NjMnt0A6l3enEjJhliSunzqsrAe+kIO/FOOD3pE1YUsdD6elkFC88BKnyuklinh1UmRWzu7yzrm2wMCsWCIIO0AnaX2Ls5NyTa3wC5QyTKIEpdIA9TYdwAjDp6vNgrQV578oEhOoLNb6soSOHcLcqSpmKqFbZRwLvNlEufersUF7emRUS1F2oWvH0id7cbhq2YElNtuAifn/f0qjEff1iDMQBDBKcLT89tJjaVymMO3Tus+0AyfuZImUoeN5D5eIsCmBRraSSTR3HJBJRlh6XH5fHh6R7Pl3H9XLLCCFn42aTWCD3URbSptqam+07U1AxmSD5xdIlmUsS0uhE9NfnQojoJlXJT4LfqaPyY1P+n1lDYK6Eiye9UZNa
 tEnPutia
 eQN+16c1wj5Zuo4TL5MSCw/MHe4LdX0Lq187QduLYuQPDzVvKHec3iwAq6ow2HNhwvLpPlfGKUCbXelHiMvoE9C37Oge1hHYFg0kMG2b1ZcD6K2KC4j8hMd3rmKN82qjCvzYJSoFTj0pzvL/hVgCbH3cJivSC3KyPshhNvNf7bh5DPaZ5y4zelBrlo1SVatXiUfO8kPzEori2dFsmTwNBKmgsu7DP8UZd1+w3jVcHU7orBmd68XDe+udu8G3PZTDxVHn2ZKT+4reOHZiviijoSSHzM4oFOa08/KsZ9KjRxXi/OxgCM1aOPWOql/6JtdAN6gTYE4OMqJTOahd8crAUGhFKGeUdI30DKky2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/10/24 18:14), Hillf Danton wrote:
> > (PE enabled for all tests)
> > 
> > ######## zstd compression level 3 W-vs-R
> >     BASE     IOPS 1,154k  avg 7.84us  sd   444us  max   697,634us
> >              IOPS 881k  avg 14.16us  sd 2,242us  max 1,387,000us
> >              IOPS 704k  avg 20.43us  sd 3,499us  max 2,058,300us
> >              IOPS 563k  avg 29.02us  sd 3,910us  max 1,649,800us
> >              IOPS 626k  avg 24.79us  sd 4,013us  max 2,085,800us
> >              IOPS 976k  avg 11.54us  sd 1,518us  max 1,165,800us
> >              IOPS 1,178k  avg 7.44us  sd    22us  max     3,103us
> >              IOPS 1,120k  avg 7.39us  sd    21us  max     7,222us
> >              IOPS 522k  avg 32.51us  sd 4,311us  max 1,598,300us
> >              IOPS 581k  avg 27.54us  sd 3,626us  max 1,448,600us
> >              IOPS 1,160k  avg 7.69us  sd   352us  max   702,099us
> >              IOPS 1,169k  avg 7.52us  sd   129us  max   281,428us
> >              IOPS 954k  avg 12.06us  sd 1,705us  max 1,545,600us
> >              IOPS 1,029k  avg 10.24us  sd 1,156us  max   976,065us
> >              IOPS 1,169k  avg 7.48us  sd    24us  max     4,305us
> >              IOPS 1,177k  avg 7.45us  sd    53us  max   118,777us
> >              IOPS 579k  avg 27.43us  sd 3,661us  max 1,615,800us
> >              IOPS 1,169k  avg 7.52us  sd   115us  max   228,074us
> >              IOPS 1,110k  avg 8.59us  sd   985us  max 1,288,000us
> >              IOPS 1,177k  avg 7.45us  sd    29us  max    72,245us
> >              IOPS 580k  avg 27.74us  sd 3,755us  max 1,507,000us
> >     PATCHED  IOPS 1,179k  avg 7.40us  sd    23us  max     7,404us
> >              IOPS 1,179k  avg 7.41us  sd    22us  max     2,857us
> >              IOPS 1,176k  avg 7.40us  sd    22us  max     6,615us
> >              IOPS 1,175k  avg 7.44us  sd    23us  max     5,623us
> >              IOPS 1,176k  avg 7.42us  sd    24us  max     5,625us
> >              IOPS 1,173k  avg 7.42us  sd    24us  max     5,632us
> >              IOPS 1,172k  avg 7.41us  sd    23us  max     6,223us
> >              IOPS 1,173k  avg 7.40us  sd    25us  max     5,848us
> >              IOPS 1,173k  avg 7.40us  sd    24us  max     7,563us
> >              IOPS 1,172k  avg 7.42us  sd    24us  max     5,625us
> >              IOPS 1,175k  avg 7.42us  sd    23us  max     5,626us
> >              IOPS 1,177k  avg 7.42us  sd    23us  max     4,243us
> >              IOPS 1,170k  avg 7.46us  sd    25us  max     5,622us
> >              IOPS 1,178k  avg 7.40us  sd    22us  max     3,213us
> >              IOPS 1,167k  avg 7.43us  sd    25us  max     7,593us
> >              IOPS 1,174k  avg 7.44us  sd    23us  max     6,971us
> >              IOPS 1,179k  avg 7.38us  sd    23us  max     3,477us
> >              IOPS 1,180k  avg 7.39us  sd    23us  max     2,894us
> >              IOPS 1,145k  avg 7.37us  sd    21us  max     4,048us
> >              IOPS 1,177k  avg 7.38us  sd    22us  max     5,620us
> >              IOPS 1,177k  avg 7.40us  sd    23us  max     5,623us
> > 
> >     IOPS: BASE 932k (+-260k), PATCHED 1,174k (+-7k), 21 runs each.
> >           significant difference at 95% confidence: PATCHED is 241k (25.9%) higher; 95% CI [+136k, +353k], Welch's t-test p = 0.000
> >     max latency: BASE 3.1..2,085.8 ms, PATCHED 2.9..7.6 ms
> >           runs with max over 100 ms: BASE 17 of 21, PATCHED 0 of 21; over 1 s: BASE 11 of 21, PATCHED 0 of 21
> > 
> > ######## zstd compression level 12 W-vs-R
> >     BASE     IOPS 690k  avg 21.53us  sd 3,088us  max 1,635,500us
> >              IOPS 478k  avg 36.51us  sd 4,385us  max 1,941,300us
> >              IOPS 822k  avg 16.13us  sd 2,865us  max 2,263,800us
> >              IOPS 1,161k  avg 7.73us  sd   114us  max   190,307us
> >              IOPS 780k  avg 17.56us  sd 2,717us  max 1,550,500us
> >              IOPS 1,166k  avg 7.66us  sd    40us  max    94,522us
> >              IOPS 585k  avg 27.51us  sd 3,847us  max 1,550,600us
> >              IOPS 1,147k  avg 7.97us  sd   344us  max   496,483us
> >              IOPS 1,166k  avg 7.64us  sd    49us  max   115,243us
> >              IOPS 1,163k  avg 7.66us  sd    23us  max     7,006us
> >              IOPS 1,071k  avg 9.42us  sd 1,489us  max 1,915,500us
> >              IOPS 962k  avg 11.88us  sd 2,168us  max 1,904,500us
> >              IOPS 607k  avg 26.05us  sd 3,538us  max 1,591,100us
> >              IOPS 1,167k  avg 7.63us  sd    23us  max     2,903us
> >              IOPS 1,157k  avg 7.78us  sd   198us  max   418,930us
> >              IOPS 1,163k  avg 7.66us  sd    40us  max   100,346us
> >              IOPS 1,162k  avg 7.70us  sd    32us  max    82,602us
> >              IOPS 488k  avg 35.43us  sd 4,340us  max 1,786,400us
> >              IOPS 563k  avg 28.85us  sd 3,989us  max 2,209,500us
> >              IOPS 843k  avg 15.43us  sd 2,490us  max 1,572,100us
> >              IOPS 604k  avg 26.30us  sd 3,560us  max 1,555,700us
> >     PATCHED  IOPS 1,166k  avg 7.60us  sd    23us  max     5,623us
> >              IOPS 1,169k  avg 7.58us  sd    23us  max     5,629us
> >              IOPS 1,157k  avg 7.67us  sd    27us  max     5,639us
> >              IOPS 1,166k  avg 7.61us  sd    24us  max     5,644us
> >              IOPS 1,160k  avg 7.64us  sd    26us  max     7,543us
> >              IOPS 1,167k  avg 7.60us  sd    24us  max     7,514us
> >              IOPS 1,160k  avg 7.61us  sd    25us  max     6,643us
> >              IOPS 1,162k  avg 7.65us  sd    25us  max     7,315us
> >              IOPS 1,161k  avg 7.66us  sd    24us  max     6,237us
> >              IOPS 1,158k  avg 7.62us  sd    27us  max     7,688us
> >              IOPS 1,167k  avg 7.58us  sd    24us  max     5,637us
> >              IOPS 1,165k  avg 7.59us  sd    24us  max     7,098us
> >              IOPS 948k  avg 7.58us  sd    23us  max     7,808us
> >              IOPS 1,166k  avg 7.60us  sd    24us  max     5,621us
> >              IOPS 1,166k  avg 7.58us  sd    24us  max     5,672us
> >              IOPS 1,162k  avg 7.65us  sd    25us  max     6,824us
> >              IOPS 1,165k  avg 7.59us  sd    24us  max     7,078us
> >              IOPS 1,168k  avg 7.58us  sd    23us  max     6,191us
> >              IOPS 1,170k  avg 7.56us  sd    22us  max     2,851us
> >              IOPS 1,171k  avg 7.55us  sd    22us  max     2,834us
> >              IOPS 1,166k  avg 7.59us  sd    24us  max     5,627us
> > 
> >     IOPS: BASE 902k (+-269k), PATCHED 1,154k (+-47k), 21 runs each.
> >           significant difference at 95% confidence: PATCHED is 252k (27.9%) higher; 95% CI [+142k, +367k], Welch's t-test p = 0.000
> >     max latency: BASE 2.9..2,263.8 ms, PATCHED 2.8..7.8 ms
> >           runs with max over 100 ms: BASE 17 of 21, PATCHED 0 of 21; over 1 s: BASE 12 of 21, PATCHED 0 of 21
> > 
> > ######## lz4 W-vs-R
> >     BASE     IOPS 1,422k  avg 3.84us  sd   418us  max   619,495us
> >              IOPS 1,450k  avg 3.57us  sd   326us  max   609,723us
> >              IOPS 1,414k  avg 3.92us  sd   543us  max   879,815us
> >              IOPS 1,451k  avg 3.56us  sd   253us  max   503,428us
> >              IOPS 1,460k  avg 3.40us  sd    68us  max   135,825us
> >              IOPS 1,413k  avg 3.31us  sd    44us  max   188,450us
> >              IOPS 1,432k  avg 3.73us  sd   503us  max   844,228us
> >              IOPS 1,387k  avg 4.20us  sd   719us  max   961,827us
> >              IOPS 1,464k  avg 3.38us  sd    44us  max   133,675us
> >              IOPS 1,469k  avg 3.38us  sd    22us  max    65,812us
> >              IOPS 1,465k  avg 3.40us  sd    49us  max   111,788us
> >              IOPS 1,465k  avg 3.39us  sd    64us  max   174,040us
> >              IOPS 1,467k  avg 3.38us  sd    36us  max    97,821us
> >              IOPS 1,445k  avg 3.63us  sd   343us  max   671,026us
> >              IOPS 1,472k  avg 3.35us  sd    27us  max    86,795us
> >              IOPS 1,473k  avg 3.33us  sd    44us  max   138,096us
> >              IOPS 1,439k  avg 3.71us  sd   353us  max   619,815us
> >              IOPS 1,398k  avg 3.36us  sd    54us  max   206,815us
> >              IOPS 1,471k  avg 3.36us  sd    15us  max     2,832us
> >              IOPS 1,407k  avg 4.02us  sd   629us  max 1,074,800us
> >              IOPS 1,465k  avg 3.40us  sd    63us  max   158,779us
> >     PATCHED  IOPS 1,471k  avg 3.30us  sd    15us  max     6,946us
> >              IOPS 1,473k  avg 3.29us  sd    16us  max     5,618us
> >              IOPS 1,474k  avg 3.29us  sd    15us  max     5,615us
> >              IOPS 1,473k  avg 3.29us  sd    15us  max     5,625us
> >              IOPS 1,440k  avg 3.26us  sd    13us  max     2,829us
> >              IOPS 1,456k  avg 3.30us  sd    15us  max     5,623us
> >              IOPS 1,476k  avg 3.29us  sd    15us  max     2,835us
> >              IOPS 1,464k  avg 3.28us  sd    16us  max     6,063us
> >              IOPS 1,468k  avg 3.32us  sd    19us  max     6,692us
> >              IOPS 1,465k  avg 3.30us  sd    17us  max     6,834us
> >              IOPS 1,468k  avg 3.28us  sd    16us  max     7,268us
> >              IOPS 1,463k  avg 3.31us  sd    17us  max     6,480us
> >              IOPS 1,454k  avg 3.33us  sd    20us  max     8,418us
> >              IOPS 1,452k  avg 3.32us  sd    19us  max     5,621us
> >              IOPS 1,477k  avg 3.27us  sd    14us  max     2,834us
> >              IOPS 1,468k  avg 3.30us  sd    16us  max     5,617us
> >              IOPS 1,475k  avg 3.30us  sd    16us  max     3,884us
> >              IOPS 1,475k  avg 3.30us  sd    16us  max     5,692us
> >              IOPS 1,471k  avg 3.30us  sd    15us  max     5,616us
> >              IOPS 1,473k  avg 3.28us  sd    16us  max     7,014us
> >              IOPS 1,475k  avg 3.28us  sd    15us  max     5,616us
> > 
> >     IOPS: BASE 1,444k (+-27k), PATCHED 1,467k (+-10k), 21 runs each.
> >           significant difference at 95% confidence: PATCHED is 23k (1.6%) higher; 95% CI [+11k, +35k], Welch's t-test p = 0.001
> >     max latency: BASE 2.8..1,074.8 ms, PATCHED 2.8..8.4 ms
> >           runs with max over 100 ms: BASE 17 of 21, PATCHED 0 of 21; over 1 s: BASE 1 of 21, PATCHED 0 of 21
> 
> 
> Lets see the data from another pov (feel free to disagree) -- in the android
> phone/car cockpit environment, the render frequence is required above 60HZ,
> IOW a frame rendered within 16ms, so what share of the 16ms does the IOPS
> account for after this patchset, for example when an app in background is
> brought foreground?

A single 500 ms read stall is 30 dropped frames.  Across 126 runs that
I ran, base+PE had read stalls over 100 ms in 108 runs and over 1 s in 47.
The worst read with the series+PE, in all 126 runs, was 8.4 ms, i.e. within
one frame.

