Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCA98CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 20:40:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39C1B8E000D; Tue, 11 Nov 2025 15:40:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34D248E0002; Tue, 11 Nov 2025 15:40:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23BD58E000D; Tue, 11 Nov 2025 15:40:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0EA0D8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 15:40:19 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ABFFF139861
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 20:40:18 +0000 (UTC)
X-FDA: 84099493716.14.9BD63EF
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf25.hostedemail.com (Postfix) with ESMTP id AF428A0013
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 20:40:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=BcsWNtLm;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762893616; a=rsa-sha256;
	cv=none;
	b=OJICaz9WkwpWNqMccP2Bm7+Xhr5yjRz+SSJpzTtpg+IctL9NV23rzy5a9dzyNyzcUeyhkT
	9eWYOYXqj5LjJSKmkBohf9+56BRkNiZS45jPsdwm84DOgNtKs/HBCenuAECIJ9174XBoxk
	grWj3eT1sxH+GzGb/79lHrb4di22w5A=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=BcsWNtLm;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762893616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FEWNC5DwWIOcHCGzzhjZ5KjnP7zvYaHcMNDin0urk5Y=;
	b=reCYbYgfbo/c3C5nWnKtdnH0oY7qNx+/eRyCsVQSG17JbfIvvMciIorbBFrio2iTzBtIGm
	83WSYKgVl8Kji+XJ5LzPM9FFLI8vj1v5MPsPYsb8bkZ3jlQaVw3Nnluvr26PTqvPL6Uwrv
	YuPSrYWU6VqrzzpYNvceQZAnF2DIoHY=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-64074f01a6eso129645a12.2
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 12:40:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762893615; x=1763498415; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FEWNC5DwWIOcHCGzzhjZ5KjnP7zvYaHcMNDin0urk5Y=;
        b=BcsWNtLmGj1uRvrf06OISdqepdk4QpJbzGeuulGZlmqNXNvzeF6YLN6r+GG36uYeip
         UvaZRmyD/JOv63PD9N/4x8f0mU0Dx9ZW9hZR+V84KaJ2OLsYank1le+52R7YGh7jXX6Z
         4KcPZuG8X8+8ZPmXZokL2srp9Mhn0Bm8RiCwprpmwi4zDfFZWHRN/1L9g6AEryGb60BA
         AFqTL+Gs16udID96Dlg8uD5PFxRGtaXZ8N9ACfI/gWSMYDBjwOp3cA50m7Tbu0CXOcZJ
         RVPpEwY/OKqyferLxTFMFzjdeau6GSR5Oxy+hi6HwbNg406PEIBcf8WZ1WiawwujnM15
         zZog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762893615; x=1763498415;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FEWNC5DwWIOcHCGzzhjZ5KjnP7zvYaHcMNDin0urk5Y=;
        b=oE9IQ6EhIXuJ0D7Qtm6QHKOePMSl/seUfZ/3sNJaO38NsyHtij+E4DYCfFi1m33UQb
         z+L/jv3+NseVRSYezLsenPdKCmYf8RPPFE+BxrynzERr3hFcOWZLAMR5ZyjQKpb1tTUl
         ycZcIMblnelsiFucwryiHY2RwuKKpz+9aSp7S7pUPtR6JMxxhHZIKiJrtzjWlTZ62fDC
         sfhPEqtKRK1GPbu95ppkXA+5pAR2MR+FvZF8Zn2F6ql9YPwPklOFvhR6sx8f1Hm1bREW
         fvpyfQt6CDEqETvPoeSJjNMjl6DM2Ap+QiMJ2eSmdfse12ZsoR+PZsEQ+vGo9ARbs+Q2
         o4OQ==
X-Forwarded-Encrypted: i=1; AJvYcCV7MUg/LVG3Vm6nL02asDDypfIlNt2/B/Unq12BrfxUXNEnT1QVvQ+6+ytuNOze7MuM6j/XoZXrIw==@kvack.org
X-Gm-Message-State: AOJu0YwoCUTf0FIjn9xVbSrHAIhoowbX0sB9rL7OYL/YG2dj5IPuQg4x
	DLUbW2qNm9AcahEo/w1NkqeDPah0dIUhU3niIKCCFkVu2XworAvxgfyPgRCxi+uw8CsFhShLc/W
	TArlIOrLhwpabx/NOhGZWFglqHD4UWLFvk3qEKDKEfQ==
X-Gm-Gg: ASbGnct3N+n5svqIshiIwpMHAcKm3S+MTc0crkAmdLM/H1H6sXn6Ptz3zV0rNKLQLda
	P2mpPYex3TdWfQTZgeuzzKeNVZd2dVscMkQQYSS5Q4TuQMaqNr4r2WHCnS8QDxs3WXKOeUgRQRR
	rNdShTopw5qaxgiBDpOQxRcG2NHrFkCq9ibkUHFyiYsLA50y7ANS8ON3vPXBimuwfhBZSAEpjcj
	YHiLUGU+0epqxUxQy2+rVT8gCOOqKRBXf9bVgPzDQM+caOlMsRy9qrjzp2l8HekvekG
X-Google-Smtp-Source: AGHT+IG2cjRv3TGWEc4gZfDUbaiY5wslxoai9FVdySiZOlZJ96VFj/VlY7pkuIOjpI5WMCQnGxd1eAfTceeYneOMjsI=
X-Received: by 2002:a05:6402:26c6:b0:639:d9f4:165e with SMTP id
 4fb4d7f45d1cf-6431a5755f0mr427744a12.29.1762893614411; Tue, 11 Nov 2025
 12:40:14 -0800 (PST)
MIME-Version: 1.0
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
 <20251107210526.257742-3-pasha.tatashin@soleen.com> <aRObz4bQzRHH5hJb@kernel.org>
In-Reply-To: <aRObz4bQzRHH5hJb@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 11 Nov 2025 15:39:36 -0500
X-Gm-Features: AWmQ_blaVxPLNZ6NFksFWHSVRdEa0McmUdt4XuCrjKEh2bGQvzq2cMu3aSw5QAM
Message-ID: <CA+CK2bDnaLJS9GdO_7Anhwah2uQrYYk_RhQMSiRL-YB=8ZZZWQ@mail.gmail.com>
Subject: Re: [PATCH v5 02/22] liveupdate: luo_core: integrate with KHO
To: Mike Rapoport <rppt@kernel.org>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, 
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net, 
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, 
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org, 
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr, 
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com, 
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com, 
	vincent.guittot@linaro.org, hannes@cmpxchg.org, dan.j.williams@intel.com, 
	david@redhat.com, joel.granados@kernel.org, rostedt@goodmis.org, 
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn, 
	linux@weissschuh.net, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org, 
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
	myungjoo.ham@samsung.com, yesanishhere@gmail.com, Jonathan.Cameron@huawei.com, 
	quic_zijuhu@quicinc.com, aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, skhawaja@google.com, 
	chrisl@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AF428A0013
X-Stat-Signature: hrk9x8rqg9uznfe11emj5af97z7fo89s
X-Rspam-User: 
X-HE-Tag: 1762893616-265426
X-HE-Meta: U2FsdGVkX1+lA2oOekHCD7IhnmrF7L+vNxYRU2+nA9M+tOlwQhF2nHWTfcBgglHvQUuVhmjSmtI6n6DrOBaxjnOYree74ihCdHgTMK+FX6RtK4Mln1GkHNbIkYJOWZCYcx1q2zzDgsGe/yBkBi4YLWxF7XZE46oE82Cc482dtKGnIIfXbiZSev1gOULUxOqyS9pN20Qch0jLr+OITP70Ey8Zi6pX+MAT5M/sSg+638TqZdy6ndBTdGXzohMAM1Ux/F9LpZFjR1Hi218XnXgudgPDt3qmkK7WypPuNzZgnZ+ZxZb8+hv4i+TdKFSohgPxpA6XexYd5Ilw8v8W/ACVZk1m+S0iZQLJ+WYf1SIPYce+7kYGahh+b5kUwT4ej2s3OhjdSvDmCtTjKVFkyNc+sgK3xh9cUQ/AQYd28mv8guJExgRNZdN2uJMwgn98JL7SDoKjxiaq61M6Vh729USn0IV0WTlw2d3cKomexCSVaC2Qtury+DFgvXQBuCmH3fDG4cAe2wfCBRmMEWSavh2T9NF+jzU7h4Z391CrOYY+JJTzNakZDffGKCJxZ8gc7fWRhj+WSDs86qZwCexJeWHIi9c80KROBbkdjODlss4TP8AxBzUtgDjqoBsw4gnqqs30hmOEwzojm8LYooXP8NcF5Ha2JOQ+SlHTal34XJdfLYbHeQiRBSiNKL0ulp2wpwz+OuowVzmMv5Qy3DUd+j5zJ/KajcSCi5pUa6KJS5gPu9V09DVIhvM+Emf2LvA63kOus5t0Qxb8A3O2n0a9V3m1vtklzMW871Q7Xjj5OY61znQbbeOKJ+hwHWzYqQ3dUeXBNeYhSxFuUA81aIW5LJupRgPemVre4T0pZpwGLS1x6pYBw26yB2Z4hjQsKN4TKLNp10pNg+I9XDPNDenbJUg46byFDDTnABxdqpHWnEyBJO0b7WbEjeieBBxvhY0mPDndCaK64z6Vw608MopiuyP
 kjBab1A7
 z2YC3qk6Xg81t8PnUPL+lRaC16mXPqAOUyJQIhAtppAQQwnU3YcVxcTm2vEp5Ex4cGD1XWG8snrrw7kOE1NETgE5Q/zLUHp2H/G7Sv2JVFHnVxQ08oZ2pYZ5l803edt/bqSAb6zlHij2BIGOeC29lKfEWx1sIzpjyMf1W46fRgmD/XLtkStBPkmLRk8JIZmDZrPb4N3ubp86Gt5cdN5qD471LBLvBGvbtQOaqRU5Ba5349VIo52hylPvvxqnip9UClzEIFtfKWwgES6c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >       kho_memory_init();
> >
> > +     /* Live Update should follow right after KHO is initialized */
> > +     liveupdate_init();
> > +
>
> Why do you think it should be immediately after kho_memory_init()?
> Any reason this can't be called from start_kernel() or even later as an
> early_initcall() or core_initall()?

Unfortunately, no, even here it is too late, and we might need to find
a way to move the kho_init/liveupdate_init earlier. We must be able to
preserve HugeTLB pages, and those are reserved earlier in boot.

Pasha

