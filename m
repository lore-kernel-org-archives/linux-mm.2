Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FA17C87FD2
	for <linux-mm@archiver.kernel.org>; Sat,  2 Aug 2025 23:40:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA5C46B0092; Sat,  2 Aug 2025 19:40:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7C8D6B0093; Sat,  2 Aug 2025 19:40:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 992576B0095; Sat,  2 Aug 2025 19:40:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8678A6B0092
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 19:40:51 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2ADE8C056C
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 23:40:51 +0000 (UTC)
X-FDA: 83733439902.10.2504291
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5EBAD100007
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 23:40:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=V17Gz7dE;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754178049; a=rsa-sha256;
	cv=none;
	b=mTi5lDD6QbmxAggLxA4te0f0ghWx7JgMk7ovQJmnNHMp/NUIxnQRcf4IwdW5qpUURAObBv
	JigC6QrI8vlFNvDphZHBAxbwkvC7dVSyYMZp2Hh1Fw1bkbz480F+18mtTTe6BLoZKzrYEP
	Are/hrMgxu4PjoPAuVWsmF3mr7+k0Eo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=V17Gz7dE;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754178049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Kwf5emshHgumx5UQOn1IaM+oO2QbnhutbCNNGQmoso=;
	b=tj0fQCDKHM2nyZs3rKH9soebnNwDz8uoOrbVeZ3MFn9mJCjOtVVD00eXkGaVrBDV4XyRVe
	M2gicLBZwIRa4/LuvA9f6++IH2H6P72nnXSYy5ZZ+h4Jk3XLWH0pkT1Ne94cNtlbNiBP3B
	xpOA0Yh3AN914j/Z5rmtkWFZ/CoVETo=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4aeb2e06b82so8445701cf.2
        for <linux-mm@kvack.org>; Sat, 02 Aug 2025 16:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754178048; x=1754782848; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1Kwf5emshHgumx5UQOn1IaM+oO2QbnhutbCNNGQmoso=;
        b=V17Gz7dEdYiACO3d6dXJ02sgG7fpoX5ewjRpsebyxpjvHRzfFF14kpdxe4AxiTo6ke
         Qa2TbhVrY6QY3DKgRP8mk7Qa4ckwpXVqfLx4mAvdjNN32HqGPrmja8oGx/1d5f1kSMtJ
         I9zE9EqNLITEScNn5KOVEA6oAPyUToWZxqsu7OS99YhNTsuPG8EnIz9tRjiofYHVj6yM
         gaqgRZLaWs+z7DY/jvb5mAdGjGbUNf1ixmOm1e/ge8YhA0guDgR/CBanNTYzJx4jBRmJ
         4XZrRJcKfbwxQeOxRid/G5a0t+3p2cofAwJJ3FgYCGz32kaGjlTpH+5W18j6HBurAp5+
         V3sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754178048; x=1754782848;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1Kwf5emshHgumx5UQOn1IaM+oO2QbnhutbCNNGQmoso=;
        b=d1rAk4IGYjNtSqZutCN9CRj6GPMUfVfOPXYJwUSVlEXGcJo9UCf0RtlHs2JiFhDraD
         Rw77mfdH3VXp7cXnkkIlswvt8lfTD1TzbPlu81mB220V2bF+4J9M1QaupMxQjB3Ul+fb
         V9CmnPQ36IDEFRToMRjaarEDyyQn1/2rhjQGjk9X95lPcXp9H8pwFQvK1TVnkm30ElLZ
         D5X4AfW4CppdbHcnxaRwLH2x64r9wnDs/4w2aXiELZruAgpe2KkyzKC36zPug+a9v6XO
         WWsmroQdYXvqhVCmNYcYH4TwM+MrI6yHhpfU85QUzRsNHKAnNUcI5z3bqsD+NHvRE04P
         uW1w==
X-Forwarded-Encrypted: i=1; AJvYcCXDVHgW2ss3FBD2bSTsOqVRqzUVgfl0sJ/HaTTduryTAzWPkKo/HCUUfxIXx9zNyC9zJ1R8V6GscA==@kvack.org
X-Gm-Message-State: AOJu0YzSaDryy7M93ic8d0XTw3lxuu5dFdgN2OKS3B/CPjAHmukzyS1U
	Ait2VGf4iFl+qK6F/s+gPOfRK6aBYfaXadAvM/PnhgR/H+MdDOlzSHEco++s+69+22xzi2STci2
	Btaz1r2vtxBg8BJhWc5T4GCN6pA+l5Nijp4VYQM+KAQ==
X-Gm-Gg: ASbGnctGIIBxJKqwdwcSq8UAce+3utu8JJFMJ6Cxwq315b+8ipS7FkEg/GB6UkHrvTM
	c+/n8Kh5Jc3EyO9FwZpUVHpsLxHinhYo47dowp1pi6ykR8y5kZ4W4VO5NmoqQcucItJdpKlmocW
	ZFomqe9tJixXYVF81nY/b2AhxuVgu8D9OPY79emLJBUkEbmEhPOyD43XXjXyw/GyjyFFlyWcg3b
	Y2F
X-Google-Smtp-Source: AGHT+IFpEg+BtKr96Wd9jX6hc7J1lAyOtlKRV5n6zcMT8sF5wnH7KyD9LNxhPu7rDIt4u7A627QHbMmxIWZ6L1slTdA=
X-Received: by 2002:a05:622a:5591:b0:4ae:6a54:b989 with SMTP id
 d75a77b69052e-4af109e000cmr81212541cf.15.1754178048447; Sat, 02 Aug 2025
 16:40:48 -0700 (PDT)
MIME-Version: 1.0
References: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
 <20250723144649.1696299-5-pasha.tatashin@soleen.com> <aIdOcmTl-zrxXKAB@kernel.org>
In-Reply-To: <aIdOcmTl-zrxXKAB@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sat, 2 Aug 2025 19:40:11 -0400
X-Gm-Features: Ac12FXz8HYSIPcbtEM3vy-98nOIq6tA9NVRJ7b2LiTxllNWUeuS6IULQVPJlPpg
Message-ID: <CA+CK2bBiEUqMotOZJa-DuAfZVXYn97F1byvjg-ezXYexHrgLOA@mail.gmail.com>
Subject: Re: [PATCH v2 04/32] kho: allow to drive kho from within kernel
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5EBAD100007
X-Stat-Signature: rpj6tpuubbu3mqdz9jbfjkh6cnxjrujm
X-Rspam-User: 
X-HE-Tag: 1754178049-471908
X-HE-Meta: U2FsdGVkX18Rn4MKiTu/b5x9EGD/y8pqMMxwIfbtRKJ3H+HVO1NXTlC4Vfz/Yn7p1chDh8OFw4SqnAq5cG3khVC/bCLJkWrupVr+UPo/J5ifkbmH2J/let1qXWS/rN4x6pApUQMOJvZzBwdBfZmvEg+lXiYfXTX1+eFZkNWJs3u7g0kLnCXJXbJxbujBp96oQS4AWj3rOMOkxRT3KzDFGNaPxMrYUtf0mVGqFMyBgQNpnrsehzEeKv2b3eSU6ztChUVHyzFzrtLMQXP56cj6Lquzmc6YwS9svXI6057Cz7MKgdQTjHN7B5K8JqZwf8FwY+LnxzlehbfCjcxYedNeHilFUgRy+G1+QXmnlj/hGLGu+Zia4hJLjyeKjfSlK63NwodovnCPtcxs6W3bzYCaF5JHWba035+ypiY6dwxJCxNK9Jzj+xVoUly1QVOBF1zCjPM2fUVbPSQrZXrdkY+gAL0qtEtmqWDxxeU9iaJg1cx35ShtVdg0/VDHiFztE7NxnkhB3y/zKNiQz+TfhbX07dm8PKyKBZWv/nb8Ankr0WfDa7bka2wE10UrY3rdoRkq47oZa62NvdqM29y6xhpd27h0nR+BC6QKUmTLqPwbkLlQBc857M+M63x3lte+Dpg3sMi+00gSOGqB2MQmHHZEMsbilmYmIi07YXmORfwl9vEPomtvbzxbf0CS9mo6R/VhEpBVz6obwrqXE9tMaf5vbOXUqaVzDRs2YV5AvMu2XKVadpo4j7bBxLM6L+5AQD5eCp5PxxOhxLyV80XX5ElU5oTYWMhZJ9xJ04hn3tt33bTumyRnNi+TBh6MsmqTLnJsdn330lVEoyGuxjOoYepaJzN5ZLs48w+SRxFXZNCgKwHAk5JX0fd7DwaJqT/hmTWQHqAAjU/zTd35EryfRYTnTjUkC6n7H24acEjVLveVO4qX5KyHaM4RXwG/yQEVwNQ0OGgY3wbETDIqM+eFnCH
 XwbDusMO
 YSLLBvsZ8a8j623motf+TogjXbur1uylzuJda0d4tC4FE8lP5xCz8duWzPXA8vzV7P2R76N3MWtfvnhgVFe9C2BcnnKcf7574tSIdBIkZjgfIa1hQpG+MXiEvQg57eLemr7tp7EpGWhM3fuTAu2HyunBr4Kzn+WD+hGnmtoMdkEy6PCkvfkhxpXoEEiZF7yrApKZ1LzveZYMoDxPGmE4sdNOZGOK8P/idJQA6zqV1wLC0OgB4SZpLs3fOMf8ZsuMvTRw4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

Thank you for your review comments.

> > +     mutex_unlock(&kho_out.lock);
> > +     return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(kho_abort);
>
> I don't think a module should be able to drive KHO. Please drop
> EXPORT_SYMBOL_GPL here and for kho_finalize().

Agreed, removed these exports.

Pasha

