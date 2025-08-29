Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F27ACA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 05:20:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 635D86B000C; Fri, 29 Aug 2025 01:20:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E5E76B000D; Fri, 29 Aug 2025 01:20:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D4DA6B0010; Fri, 29 Aug 2025 01:20:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3AA466B000C
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 01:20:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AC136118906
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 05:20:04 +0000 (UTC)
X-FDA: 83828643528.03.D170CF7
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf21.hostedemail.com (Postfix) with ESMTP id CC1431C000F
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 05:20:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=Wzu4q3wE;
	spf=pass (imf21.hostedemail.com: domain of viresh.kumar@linaro.org designates 209.85.210.175 as permitted sender) smtp.mailfrom=viresh.kumar@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756444802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w4CA+JjSxoJjZGOZZpzLlfb+zTcQOsCT88TOzSkzLZw=;
	b=v/IrOSV/Xvam/LSPAWK/rTltrM0haA3LY9QRGG4qApRcxRe+zeXeDh9OnYYVbxtXrpJsLl
	VQtkUJTetpNIwmncIvhR6uVPp9JzqFs57cGgn32QUXqb0PR7l1UKfTUhj+vowVLiL0kAJF
	MnQ2PWPI5lNUwvwL3wSayV2QDojdS8o=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=Wzu4q3wE;
	spf=pass (imf21.hostedemail.com: domain of viresh.kumar@linaro.org designates 209.85.210.175 as permitted sender) smtp.mailfrom=viresh.kumar@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756444802; a=rsa-sha256;
	cv=none;
	b=nZvGQMmDOi95E345kmGgio29g2aAAmGvhbkMSagm06pEOL+0Y9IsOTu11gWDoVonyv4aJ1
	OG/zWJE+LtnaY6pU1K38eSmrJYYK3jvnia0wNgWjXr35ToDMgL0dviWE5JUB/gVKuPY098
	gveMeUTeGsV5ZJMimZvtw/xUE/8Naw0=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7722f8cf9adso183312b3a.0
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 22:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756444801; x=1757049601; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=w4CA+JjSxoJjZGOZZpzLlfb+zTcQOsCT88TOzSkzLZw=;
        b=Wzu4q3wEt6sdFGtXMQb9qX5JJwt94B0Q4H/IhXgVC/S28vmMtETRVx0rkTRj4ruKEO
         3AjMJh28E0u27HrmeCPMog2AFa8UdwI7dur/ieJhmTk7Atz7jNSPrmVDeJ4rS9rgC4Da
         3s1HO/l72P6GCTJn7Kgnlw/DVcPSbD49/byh7AP9C0T9qgdJnpqHftquM6UKG7QTfpqZ
         O/SuIxc9w8kOUCTn+NduQN0LuogzN9xaOOKhIyYQllVi+t6pDKcui7To++QRE6O1/Bbm
         oTJfHkFeyBWh3RirEOumKujc+EfQlOD4uhbvMmGZ4UhGTYGt36YpSWxp8Dv/MLotlB8u
         GyVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756444801; x=1757049601;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w4CA+JjSxoJjZGOZZpzLlfb+zTcQOsCT88TOzSkzLZw=;
        b=ms3/Uq3XWXgjoyxSgL0WnDfYPmLBfSyBeqJPcJq8HZWT05gf3RiT0KmajQ87wRqEo4
         v7Nsl6DWyszx7aIzRU+DQCSX+tbhlzm3cctxkKZ/gPgIXgUHGxuqxVVhuSebBctMwWLA
         wY+owWOEvJEZMlAMLCczFmy9AaEquXykAepgEh5IzZdzXjcb5dfoPKZF2lPhxeCINAZh
         VgaqDxTg6OejtQTfU1di+R7VsM/fg7s29Fsk2T5c2dyxvXwI+jVIci2a45doJNIU8Sfb
         S5FIRYv+4elR+vDVVk/MX5q5a8SqrwozL6M2P9tg3zZq+0VZA2yVw4zzFg+C0dIiFzdf
         zzBg==
X-Forwarded-Encrypted: i=1; AJvYcCVyyVaAlKwB5zmZon5T1GsQDMR6msdI8jxJH4vng1kbPkn60LwgHX0BWnt6OSsyvlQeXzM27R+IzA==@kvack.org
X-Gm-Message-State: AOJu0YyVw1m4tPpzXu7TmwOpMohec1SZV5u4D6rwMI175i06lhGcPtBj
	tpN6PVKpKwUV8oQGKdDJgwdILyXNBhq9hPbpTCG2qnZ9KkP5qxi6hhvLh9kM8ncUHLQ=
X-Gm-Gg: ASbGnct6u0V8HepopRgG1mOd6rKAYxnKbk/OMfbePfMi1heX3cs1FwjBzG5qraK+wjZ
	S+GOxnocl810sjnNL6hnoE4i2PwEEEpW3mQwEMLmoNkPpmSj6bHDqzCe/8viX45/IhWrAhPBc9i
	Qyi9GAksfnFxKjlE0IOmss90a1CBBzBirXsNKoSAqrjGC62hZMDUfgzL310eskkD4MSs6F1EMPm
	lh01G7DVfdY891LaBlz81Gaw1forcR2inQtMUAdioc/uj9as9mc25ie5ATAVj03GPyyauo9EHbZ
	06NpCXjV6YtYXaLeEX94QtyxVi9Wgz40PzsX3b2opnvI23lqOJTx5+Lg+XPX99fDJe358Ajy97E
	ARSf3btN/GP6447laCLb9mvtrBv02NmGJaDY=
X-Google-Smtp-Source: AGHT+IETrKdzQi92QZKgjAfQhANfI2QmqLxzCiedM4++QowtrwcfkvZwuaEDKRt3EM2lOAmU2MJx8w==
X-Received: by 2002:a05:6a20:7291:b0:243:b144:adaa with SMTP id adf61e73a8af0-243b144b09emr7531411637.54.1756444801693;
        Thu, 28 Aug 2025 22:20:01 -0700 (PDT)
Received: from localhost ([122.172.87.165])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b4cd006c340sm1082278a12.1.2025.08.28.22.20.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 22:20:01 -0700 (PDT)
Date: Fri, 29 Aug 2025 10:49:58 +0530
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Mitchell Levy <levymitchell0@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Benno Lossin <lossin@kernel.org>, Yury Norov <yury.norov@gmail.com>,
	Tyler Hicks <code@tyhicks.com>, linux-kernel@vger.kernel.org,
	rust-for-linux@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 3/7] rust: cpumask: Add a `Cpumask` iterator
Message-ID: <20250829051958.s4635ztvmctki7ol@vireshk-i7>
References: <20250828-rust-percpu-v3-0-4dd92e1e7904@gmail.com>
 <20250828-rust-percpu-v3-3-4dd92e1e7904@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250828-rust-percpu-v3-3-4dd92e1e7904@gmail.com>
X-Rspamd-Queue-Id: CC1431C000F
X-Rspam-User: 
X-Stat-Signature: 74fdimdk946xsjz3cmnartq6s31srtsu
X-Rspamd-Server: rspam09
X-HE-Tag: 1756444802-115212
X-HE-Meta: U2FsdGVkX19M6eqLte3iBE8emLtylUc1HBjtAE0+OnQ0OcBjyKpp5egWUjP7m15sTaCS5EYpwmzSBwJ5WBQvP6Dhtbv1hSkx4xLoedyqtPEWL4414p84MC9h7ka7+I//E3MsYvf/irYvUOykr0CaeHJlQE1ZHTNI5SbrX30SSZ3fjPoLpDEJTqPpzUdQcLoTXJkoBbfDwdIx0DkMWjd96ev29j+TJh31M1vLygmPK3Lp7ddAklYSLMhrT0Qhb7VBcZziaEQhBDwYqZ80mXQ9VvzHWHzGrZzxjco5WDs5MT1qKTGqUWup1whLRdNBcs5OsPEHkG7KzEILtp95+JJ76Azz1XuERjPNKWFuvtdmOQYCTV4YxZ2K/KXyH4Xpk3EniEhSYoMkA+kOHjnhky5bU+YrpRqRXtNJOknBDnqn9M/wMrW/GZDU9LXdRbT3ZVkON7ujKS+A+q3UAgDmJUwSNB76ysad9PNarkrdeV+YgKszuW/HJV1LgbwXjaVmHfZ/NkqFSjcltfRI3g8IB0vHq+HSP9oZlhD0hYuvFQoJ4O0+9g0zl/bUU6uP4DpUlJ+DSODol9MFBqe7/ci8rXdgsorbuyHKohBLFJCu/ze5iH9gV/KEISOU0E0hWm9B39AQ6Mann7AD5xr2rtcWtZuRqaz/TiuXVezNjycYTlKElyJAlyZE7r8IDrtKvIJEtdcYoxiogBEmg/0syZHp/7W9ZqXOdnb2XZemB7HPrGIa1mBuvOPwAaz2LxF55pKw/AQv3pU/RiGkEPu4N9Sy+0TjquBAFiH3A4u7FKmzqzBIBB2euDD6fK0fX8/jgCqkkc9zkTcJ80nxa6GFloKEF4nnt4Ai2yrKU+wFqs5yR8p9xWkVA72Od/PDoda47Ba/X3JhTEOSL3nrbHOrJnOCb5YYHzOL/O+QSlAOMxelcTG+jpvTe5uqvkEMHB7SUBThH1g2v2UYZ+xE3h2wNrv1EY/
 wPCjBO+W
 OhHXP4nq+RAE80HbqK4FsNfWS9dDao4P8LiFJu4oaTww+7vR8XU9/+SzAlbk0ceGsvr/PckteERs6KRVcBDUKdv+ghzNLoStJqM8vwdgekPM+cg4vuWGDaWJjlaC86wKDCEZEs42v8S7F7KsW7X5DvBE40telEjRBQBDd1qX6pJq0A+E5ua5V+WpXQ32q5saDNPXQfGwosj4Ac4H7xCjbUEjL1NSDhWPtd0rmUyE9Ay8ufeshNwk4MyjsYLMaD4b4KgRJTtMED1tybnFIDTYhPM6OswrQsPv9uEyD98oJ58ROnxCfHgNLUq9j4imUsUYx9NMGuIWJ6sNr2DEbVjUYg6KZw9Td7NmvUJatARvGNhWy5E3y534LU5OjFSWrOxHTcCiLoZB/7Zly3+XnZHOlcCSzXEXrF06bwPbBnXDTEdQS1AAa/M5SfY+m16DsTuCwCQRzzoxV4xFrM/ch+S32aFwFO5o/kbSa9uKNJecsshkod/UK3lnFB6Oqyf7aj735gSIj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28-08-25, 12:00, Mitchell Levy wrote:
> Add an iterator for `Cpumask` making use of C's `cpumask_next`.
> 
> Signed-off-by: Mitchell Levy <levymitchell0@gmail.com>
> ---
>  rust/helpers/cpumask.c |  5 +++++
>  rust/kernel/cpumask.rs | 48 +++++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 52 insertions(+), 1 deletion(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

-- 
viresh

