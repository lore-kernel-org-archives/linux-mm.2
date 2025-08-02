Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 876D5C87FD2
	for <linux-mm@archiver.kernel.org>; Sat,  2 Aug 2025 23:33:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6DA66B0088; Sat,  2 Aug 2025 19:33:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F7446B0089; Sat,  2 Aug 2025 19:33:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BEE06B008A; Sat,  2 Aug 2025 19:33:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 77D8C6B0088
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 19:33:49 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 46D4980D3C
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 23:33:47 +0000 (UTC)
X-FDA: 83733422094.22.52C80DB
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf30.hostedemail.com (Postfix) with ESMTP id 772C380002
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 23:33:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="k5GVtg/+";
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754177625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kJsgdU92CHKcumA558FjE09dL3p6PDIATBJc8UDK+q4=;
	b=Y7kj4zdTJtn+QVDN6GISi0g39GuAZ3g18wClZJ898LJUWm15xKMtdZl1PJy2WBERQ5Y9a5
	GINNqPEpF+s79P/4z5fKT+eM5cM0GdJrjFJGigqjZXoieS+CNrf0vPVp7w68YyUTtnmLwV
	JWJ+0VZ4UDktyJYnOVJhqzW6K2V1Prk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754177625; a=rsa-sha256;
	cv=none;
	b=1Ny1kw4xLu0+ULRsN7/36t8wx1zO88FTqMAsndjhunOnOVJmpYQYm4IpylXrEzER+KE2tG
	0NZaFcsSXO0Nd9UXij8jOAAuB1CD7Tf1McEwJBc2bHhmyxRYjZxR9zB4rbBbwp9NgZ61i5
	w/ytA3ZaWxfzhP/q54P/UhKgZmJ9vSk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="k5GVtg/+";
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4ab5e2ae630so27558411cf.3
        for <linux-mm@kvack.org>; Sat, 02 Aug 2025 16:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754177624; x=1754782424; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kJsgdU92CHKcumA558FjE09dL3p6PDIATBJc8UDK+q4=;
        b=k5GVtg/+hqlDpm6SlcbASNeYN/fkvG2pZRwknxkT1P2C5FtTSjCvvdyo/qKZw6DU/9
         kP56fjs7VVN4hvRLgGA4fE8NG67zzRH3uLXRf8K870qHCFadL7POGpDb112LbKOysmG9
         6lDwkMu7JT75avhLbmNdGswGFERwW+t94A26XyJRORiCaw8FmO1DmLsiPDJXNN6Hvkw6
         nlbjgFPCMz/CtwWQmVdNVJdPkbjsdVPsAcHjHjOJ69qOP5+WLiqLhlqTS84exVVAV286
         dzR5+94+yVcyqW/bUjtfv6fjgtraeJOXRxc5QDmdf8GtLdE64tOnyIDykYtOdRvOubCC
         4zQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754177624; x=1754782424;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kJsgdU92CHKcumA558FjE09dL3p6PDIATBJc8UDK+q4=;
        b=s2eLJTMSa1N2KGWRQZCpKeVLNgzhV0Fo6zYt197cTBPyj53FQhZ/vdNHNfoeiHJwd2
         r5eofo8TWOryXIK7/NZ06eBQN6nFDrqkLcvzGbRqqBk0SpFP//+WhRMRAjmSDNXxDbt9
         Jj02tzNQMDoLpOjN6sYngmRcqADeZzGPxzz3+UrXmb/2XQssiOaPPWwUBNEaSH2wkgu5
         SfP9ogw7YUdLpT+dUr9dI9hSIoZ7jX6Gb4c1N5CNkqkpmTjtfuQZlGPNxvaVdTA1S7BA
         CnqcKZB5ag7XIJD2Zl/6FRp8MTVelOcTW+vb3ogoprpAcPQbQAq/wz6Z9dPpWeLoTKkT
         ylwQ==
X-Forwarded-Encrypted: i=1; AJvYcCXzZkVSBnRjDcqTT5nEPOippnVEA4J88PyzaioQ4psDOuhMjp3Jcq/XY3J5dMeutZgkwRm4e07QIg==@kvack.org
X-Gm-Message-State: AOJu0YxgHUqOgVwvk5RfrxpxBEXB8RrEveXoR4supeNX+NtdZ3roQ0mv
	JLXTYaQCUYez/lT+NKF3/hdDaU1GWD7xomZUC/8HsGrh1gol1B05V0AcTYfRSrg/X2UlUOJuc7o
	QCJ6DteicL3nOvpVsE8DfW46MM6+8kXx/PWVWJxUA/w==
X-Gm-Gg: ASbGncs0IQj8JLymckBAm/3M2c/k9QNENgvA+m8gr1KxX3sCWCD16Y6Gluu+zq5dQYD
	PXeKG0gXR8EYvYAZBIywmTb2wVei90OxFddw0ndJo6tFgHx0gP8eCtlHgj/DFZTwedfaHnVnXBw
	eF7TPKo9G/w31A3jZTJ532zJMD/8CNNGyi9w9n9YJrhI71zj4ZFvUIGst6/gJJIzXLW8In3nf8J
	VuOcPhHJplsr30=
X-Google-Smtp-Source: AGHT+IHK7fLZil0+YTWDez+wvKBQ8V6Jt/OxjDZMFuEzIGCH7fVFxrWmUeAnr0aeRkYb+cC5kQOxq3dgtd4ni01q4II=
X-Received: by 2002:a05:622a:8cd:b0:4ab:3ffe:409d with SMTP id
 d75a77b69052e-4af107905acmr85155491cf.0.1754177624500; Sat, 02 Aug 2025
 16:33:44 -0700 (PDT)
MIME-Version: 1.0
References: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
 <20250723144649.1696299-2-pasha.tatashin@soleen.com> <aIdNTN1qd0dTvsQm@kernel.org>
In-Reply-To: <aIdNTN1qd0dTvsQm@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sat, 2 Aug 2025 19:33:08 -0400
X-Gm-Features: Ac12FXzhu6LQ65rG6yLekEcwlc9H74rWaGowwnkVgbEc9_PttPli4Tw81uem1BM
Message-ID: <CA+CK2bD2pyWmnzDyRA54nXQwB1ABPKqWP2yH6bVnnE09ogCHXg@mail.gmail.com>
Subject: Re: [PATCH v2 01/32] kho: init new_physxa->phys_bits to fix lockdep
To: Mike Rapoport <rppt@kernel.org>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, 
	changyuanl@google.com, dmatlack@google.com, rientjes@google.com, 
	corbet@lwn.net, rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com, 
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com, 
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org, 
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev, 
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com, 
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org, 
	dan.j.williams@intel.com, david@redhat.com, joel.granados@kernel.org, 
	rostedt@goodmis.org, anna.schumaker@oracle.com, song@kernel.org, 
	zhangguopeng@kylinos.cn, linux@weissschuh.net, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, gregkh@linuxfoundation.org, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, rafael@kernel.org, 
	dakr@kernel.org, bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
	myungjoo.ham@samsung.com, yesanishhere@gmail.com, Jonathan.Cameron@huawei.com, 
	quic_zijuhu@quicinc.com, aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 772C380002
X-Stat-Signature: umh39p1bf8isfh9eyby1sh3q4rn8exjd
X-Rspam-User: 
X-HE-Tag: 1754177625-815825
X-HE-Meta: U2FsdGVkX196EHMKYsmrWMfoly6Dh6/LekoCOOgzECGk9itm3yIfrzqHnxAwB/F4rNk4wHVFX9nBV551H96JCOLDeGTAayumQupr8gNhXeSB3qMS6PvlY1JOPEY9BLDpIlt7teQKHDuYb6OTuvnmGZKmNRrjjeoCM33cGQAgDMeBJD3WYidTRAKDR3ksXlsB2u5myO6rjphHNnS4x9xPIFczZYmamoD3353I48qulZ5cizQw9Ujf6UeR//yn5Q6Tb90xODDzdUrpxvtqqwI387d3CbGG/w3UpvNnpE5iX/nzMH7AXAQVelm6Is1yIxgHlX6/1mKrV1zWTHn69etB4x0QE4XasZAGSfqq296YVvsBVC2CU596DgPrKzqurodbj9td16P8XZlHG6u6TOr7pQ8CSxg7EkkZWnvWbSU8iqj5LJ4+MQ6oSfdEy5UDoaskOcwP4ffzrZYCUzOUZDn+mb/OLJ3UCyWGqPR3hcbxZzfedskiOhSzUJGzme4T2pBA7r2XpjeJ9Y5huRfdDcip3SPr9CzP4YkOkHwvIUR3AJS9cuxeaqhKTNDEn/d1iPC/hnwhWtHJhYV6zKaDs/D6ikbZfQ3w6ki2IAgYK6360Bcea8gItdvjswAgTwv+mXeA8HpHm+mapmry6mKyj+0WuaoMYa925/6+5usKKNXV73FjcETbdE0v36ibMYaBES/64u7jLkvDiQKdwVm8MM9Ht2WPfTnz043gWXp/klTh57EQpCpp/ssgTbkJtRrdFESJj/1HO4L5Igiak5ODy8gxj9VlMU9SNGLmPuher0RqVCRJ+rzO50e2UbbI15AKD0CrMxb2hXRwodrTO71P6fboyoqwJdDu86UynFL4yHFKFpFEXmcWFY73bUvtggeMKO/x1sSpJskv9A7zeKBcKiws5izGZo/bdgDCjJBj04oIl5f2KJs3UqVgxXj2RghBadunqsQmYALpP3pLorea5gb
 qvL0dxCo
 Wk+JUt3sY0nqlmxFEoOdeXOqEM1aearA9mSjBFznK2C75azkC34f1QoyBtegdrqwfWDBnXH8FeiqjDdxN5AzvuRY/zAu7nd00lRIhUHYzCrQlk9Hf/mt4HjjnDN02vknREyPqgrErso4dBklhKOsxPSz8hJCJcINIdtKXdGJT1RM7ekrpjQKlLSPViqgeQUuIWbGMWDmJYIypLD/eTaPEPIFen09PJdNkQD57/LGC8xvxGo9r7jaZzEEf4g5SEd+IqDDhqYjKGwnAa4uOElWS2qHYijRePR3tIX8CR+fl32ogy8sq6LaWfm3+OMks/VZr1Ru0nqWrjInWR/OAmLH80XDGQdD141V9biiDZAiCIBdFDqc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Just int err should be fine here, otherwise

Done

> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thanks.

Pasha

