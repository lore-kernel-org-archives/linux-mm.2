Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2E9CCE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 18:46:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EFD08E0023; Mon, 17 Nov 2025 13:46:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C7EB8E0002; Mon, 17 Nov 2025 13:46:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DD7B8E0023; Mon, 17 Nov 2025 13:46:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EA5168E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 13:46:05 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B2EC386DC6
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 18:46:05 +0000 (UTC)
X-FDA: 84120978690.04.2C9816F
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf06.hostedemail.com (Postfix) with ESMTP id C7CD118000F
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 18:46:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=CjCXQzL6;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763405163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9L0PWDNFpIwYA9Tdoy4gSq9mMo+JaoLTYqKodPhceek=;
	b=GQRJbTVaiV5eEo2t/NSGmMtHJ8Yhw5nyRgtRzrX5VLu7hcuI55regMSDh+0u1kBAVij2PU
	czQUktisSdQzP9gKRxhwgLlu3/foi8afmswWQ26nKNhrFEWkF+TQT9fU4bqWhWpZwgVjkj
	nUbKKLFYOEIsB1gts2vu1t/4jXRNGLU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=CjCXQzL6;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763405163; a=rsa-sha256;
	cv=none;
	b=NzgLa91Kvd7/sLKCf+Gvqclh900qu05m1WiD8w/I5sB0lwHdvuSlmEF3anWzNAdfsGeb0z
	Ojw4gY6USnYQhKY8UxwzPHgnUkwL72iqlGCKJaDO3aK8gj64/Z42jyg7zn7qiA7PLHCMPn
	pNPkIleGPAynrMCgBduApdeFRqJHiXc=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-640a503fbe8so8035124a12.1
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:46:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763405162; x=1764009962; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9L0PWDNFpIwYA9Tdoy4gSq9mMo+JaoLTYqKodPhceek=;
        b=CjCXQzL6wJ7XG5kb5f2K6Rru31jYJ5jZITYUdwvh+heatBwGvQwkL13bAccVpw6rTn
         +iE/SAMqLWQvQAPZ5QOsX5Noj4/i6oi1FbxxUa6OLxgQajK0su62SwzNqorNSZR5j4Wt
         tqeoXyhkTkSoYmK7iMJ5Nd24vHE6hgpLmgU2P/dBYj7KFombzbDFnHiOoFJ3QqC/cDHe
         k+WwusMCi6preI+6aQ/Sct2EhUwxIsC7KkQXz6+F3QfzQqMfLQNj8kwfJKsZQmvtrBBV
         YjFBKSvNpmGsXnbeKBSgWAY/vzo36tgVWp5ciSNGELn+rLdfTGrjBOvusAKCb5WyQKVU
         EIQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763405162; x=1764009962;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9L0PWDNFpIwYA9Tdoy4gSq9mMo+JaoLTYqKodPhceek=;
        b=PjOY+UlBOnCH/+ZVgFWE6IAcToAJdXJRv08nSD96LuaJW4ueu1zwa7QiVrPdHupBbd
         gzDjJUdMUA4NMUOTCmTrbwqK54sPAmCVhlf10FzR2o9jBLXE+HhEPQvpsIn6ycFggnsa
         Pd5hoVtFPJWrCe/bz/ZoZquSOhiAc/jP161QTPiYJNeqHlV1j8tfZ6nmmsDLROqTY0mF
         mBB6LgrOYq9MzRXGqPciSZQNCxC5d2hXUxd5N+NSJCgn9LmOFjZARf/r5hQ0jjfSiLI2
         iOpJkoJAGWDEWKgMiTo3/t6qT3ihgqFLazZTedCYKhTG91pzIimTVOiVJv5vDVYi5QY3
         dH1A==
X-Forwarded-Encrypted: i=1; AJvYcCWCe0LOuzl9/5EVo4V5aV9hKVqQUnF8LsnC2j06OcMoLkVygglCOhaR90aIdfEtrD13HAdUoKopfA==@kvack.org
X-Gm-Message-State: AOJu0YxChxo9zTF0ouMToUI2QrCAzEer1WJe3PZy52jWwdwx82VRBr0f
	fu43Tei1TQsqxa15E5IuagHKD0swdqLS4CdmX+JOUmbcowbty1jHS11JQ+e2zzjIkPcRw/oUqI2
	J0gA7DbMpdcPCL1FzQTNqjTwB8jHixLQQWKkvuiNjaA==
X-Gm-Gg: ASbGncvOtIBsA6+IhiThsn4Eue+fwkoOg2KmCnobDZq7nMuZOUrRMr5diqDKpGgkmce
	YnDPT3qLDZc/icyR2FYM3EquzKMo7Cdslrl8hclQ1B5UEsnjlWnJtc6qp/zW3gIG/hhZC2ewDX6
	1HpfsnD/iRw9K/D5rqKnUCYOmPaWdQxcmZ/PacXQJLs11v/G/BSaAFm6vGewtMd6/QF3BY/4Oh0
	9FU+Bx1m3w75mw7wonAPl/maSTTnYeJ9e+gyeerTkSyQp2Yk9pOTG3Msr1X4EFCu/Z6DfrapS33
	IDk=
X-Google-Smtp-Source: AGHT+IHTS9jPR539K9D88biPeBpW9OArAzo2mtlZDaqK9aFcfZt0G8LfWzYGUIJ/Wa0xrvoSHRJmq2qQHBOC/QtRtDw=
X-Received: by 2002:a05:6402:50cf:b0:640:c9ff:c06a with SMTP id
 4fb4d7f45d1cf-64350e1e3c6mr13108669a12.15.1763405162259; Mon, 17 Nov 2025
 10:46:02 -0800 (PST)
MIME-Version: 1.0
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-15-pasha.tatashin@soleen.com> <aRr13Q1xk9eunilo@kernel.org>
In-Reply-To: <aRr13Q1xk9eunilo@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 17 Nov 2025 13:45:24 -0500
X-Gm-Features: AWmQ_bmw4ppe8XlI-hroPbUkA515iug7-539nPCKhJSWJUeaHTdUDKi6DO6pH6k
Message-ID: <CA+CK2bC2_r4Nbjh0CuJwcMeGxpctSZMTodG8Cf=zoue6zj-gyw@mail.gmail.com>
Subject: Re: [PATCH v6 14/20] liveupdate: luo_file: add private argument to
 store runtime state
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
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	rafael@kernel.org, dakr@kernel.org, bartosz.golaszewski@linaro.org, 
	cw00.choi@samsung.com, myungjoo.ham@samsung.com, yesanishhere@gmail.com, 
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com, 
	aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, skhawaja@google.com, 
	chrisl@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C7CD118000F
X-Stat-Signature: bx6skm1rz89r96npsc8cm7y7ysy66o6u
X-Rspam-User: 
X-HE-Tag: 1763405163-436267
X-HE-Meta: U2FsdGVkX1+Sh+kBXMKzEdV7jFx0xNrsD1rzM9fcj3tkr4wKWVIbajaBhcEQAwgmNUzinv5fhNPIEHG3T9DOh/pS9rzOvQP1v4PU7U6YaLqZvRLi10rEAkZeaiCa19mNK0aSMv2EZcsVJhk6ToHPuH0KEBLBMGWjnL+Vmsh6eeaWavK8Fo7/tFjCuZWTsQU1kjZtYOqeTGz6WH2ybMVaVkOzvt0FJn6qrcDRU2VyDbFEmiB0tiZi0qHbHGypqcjZQIPb9dOJehbGNtr0HR/3VTZHwrp7KYjobSQwcbrjw0spbzeS9012k+Mi2i6rjw1cm/U/PLAMKzdNrXrbuIC2Eb93W7J/SFTcEJeipyuaFbOW0CRvtFcVCdobBC5OV1smovXNDLdzC21uuPXL5rGTZCOisi3J9pYGHfQDzgI84rRUAkKW3YRFf9iw+s2ARkmE5Fn8/yAGHQ3JRwKVfoYuSTPyc82UUDQo52YZ7zDJXBOSODxdL1XlB0BeuUXWp4qs39bxtoKJoW/wswi3MOUTNJQby5EVELV+wqy9qLlpDOmN1fEzpgh4eDMYCPabeGZZ5H3Ux33UbWPCDKdIEZHh2Cjgl0/AgbPWjaRN8pFwB6ZwSdPLcA7obDowdU50G7NtKEaQXDowBy1eTz3KkgYt0FZ8Z3pT9p6QPmZB3LGKgAKgURhUMqw0QdDIZEIGzzJjfmA96fIKzsmWRhvH2Okm6jYS+DLR9m4CqgvYWVWy2VIHeOshlx+0jwlCeir9b4LjEIPaIjf5uc0JHRdil8kKxwmQ8aip2TwkiDqU5T5C1AgGBGhVvk2qSgcN1EhhVjFi8cFmk4S8c5SYYTt6gXSoa7N4jJN94zEdjnknGjaf41wgYH3tgrUW8m+h9FctAkXKq5D5WIX0ufYpGu4p8k+Cja9yhqTBX1zYm/5W1KzYQjbQjSZVElWCP2zRVlT3OZABe9KllxHo+4nnpINQXyt
 PmdFTGeA
 bvjMQNwkiNXt6jv205DaU8WjPYm+vLwhmq+XGzrd6gqa+eKlV3OlrNEPBbpYM+mFSVcq7avqDJ1jVFkbshSlfuekHB1HVpi0ynI8kJPsFnUvRmeyy2o40DkUnaTiwNXd4yMJHHwaEr5GlZYraplQ5C0XfM9vZHZYq6ynRKhtxjKhvADofvF0vzyHQ7pmJP8VQocrsCEBjs0zGMGWz7f7DtNY/vTousS0JbdjFQ9JnB9sdqn+YYxLMtXbpRU7u02B/v5z9HwZZKC2E4J8DEspo7wcQbk/4sqDmFPkQSjvZFfGd08UtdR8Pf3FQ4b1I9Aox1wUwPfz/v1tAFgKiCgkBK9x4QucrIQVg/KuDSXCwwj8Wnadwv6Z7k8Uf0/3NorBE/aDiIkue/5DJS4mFn5MLjMYq3kbBPXB1n3GI5y40ljsr7A9cF/8qd02zTqle5Hwq1kHaKQaMwYZz2fosXFYIaIL470/Speni9QyvOyiyrD5r4PG9lizvSjqAZgTOua7UVT0A672aR35bE8YUGqomDZrA89sDAWGnU3QM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
> > Co-developed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thank you!

Pasha

