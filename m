Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D947BCA1012
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 23:05:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C0A28E0007; Wed,  3 Sep 2025 19:05:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 071ED8E0001; Wed,  3 Sep 2025 19:05:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECFFC8E0007; Wed,  3 Sep 2025 19:05:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DA9528E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 19:05:51 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 72481C0673
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 23:05:51 +0000 (UTC)
X-FDA: 83849473302.15.5B00FE8
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 85D40C0009
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 23:05:49 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FUGlFCGZ;
	spf=pass (imf28.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756940749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SAh+dME9OWSqfZnxDjcTM+6W1pRlteZ4zjfIGpBbxFM=;
	b=YNRO8bTDymmK6x9yCuCCY2HNGLkxp+jt1jcxfShJVBlkMw5fVogsjIcOE18W20zqo+915J
	vvf3/UgsrzTDtVj7lvY9MmfO7nC+JwaVaLzKik0FcOcCmuKWJuWIy7ujCArX8zq4WGZiUj
	J+sE4twFGER2Y4g9exkV0sBrJSL4yGo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FUGlFCGZ;
	spf=pass (imf28.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756940749; a=rsa-sha256;
	cv=none;
	b=d2w3xBdbIMgoyaWbh40SbWmgZo0O5M/ri60aKoi7CC+91sjcteLqFN05NoBhR53dnPa/N5
	467z/jKe2MvqpkTTNr+OxTcz6Hr5pv9aQTZJmR4NxJsIDNYFZ2stltswpFWwT22LU9fiCJ
	Xmv5NyO+RATKInziRvL8H6sRAqkSgDA=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-24b132bd90dso688865ad.0
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 16:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756940748; x=1757545548; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SAh+dME9OWSqfZnxDjcTM+6W1pRlteZ4zjfIGpBbxFM=;
        b=FUGlFCGZQ1CZlUuim7PExF7cRyeexpEPwtphvKaRvnRTrhS5MppSa80isd4UMwpILF
         TBTgzB4PH265m7BHekHBC8VdHnhAvMcD1rMeuqAdjyfPwKFq7sZ+waBHHTv/Jl68e3R9
         KMb27MXGsgxI7eIAzWBjFvr0BL9FNO6lFhhuM/W7Wv8UF3A6iabTDj3LuLRzaeyuGaex
         k1bo3RmiiYiLbFei7bogwOlszNLXBiK/OjATgtTEaBaOplqWhQrvpkte6l0yGhmolkpd
         UHdo8NktNQKSmlXtXYsaRrqHOTF3S5YRsff8GG2hD3ZAxeZfDvnDxBwJUjjDfOhfZnUR
         CpZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756940748; x=1757545548;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SAh+dME9OWSqfZnxDjcTM+6W1pRlteZ4zjfIGpBbxFM=;
        b=dDhEiBVilu/9p/4nNsYxXDqpFHsFfK4ThAzfzG+Pd913VxOyY1W2bouKu3Ts4kPA3p
         IVjOQsAGKpgiTxuxEOD+jsFJmr1ccwwmlqD+fGUaG+BY2OvLjboG5swKMNX2u3aKCXSB
         eTt5cYqjOYs/GmwfkRbeGt3IvSw2FUPNhC+EjoYUv+/w3ESIaksoIhJEliuV5sv3Y5nO
         BzImqIZNsRUeKjXVtQ5XbTnaSXWDKTkuJleCgoHpJ4cWWl2atigMu6HP4yhmeJfvJ5H1
         FLQbHt3tUawVsFM/UkNeEtf+Z71GzExqVaFYTzmKpVAZcVlyRxiNrwqqIbTLAM6240aw
         Go6Q==
X-Forwarded-Encrypted: i=1; AJvYcCWUM4RqnkxFQ1zSRVYW7vefgbcaIKINhYRR4ZVYRwFCA73y+OygDsDFTx4K/uc6+cJHjVCo5EAIrQ==@kvack.org
X-Gm-Message-State: AOJu0YytyGXZGFtFZHfNlQZzbDUFF1Igk6JgzA5Aj6f7mkWshEIeZeQJ
	5O7KdjtHgx9K+GNzDWIVrtKxi0SvI2Q1hwbVWlez4FGcfOC55q7Wv1JjghGt7d0/sg9/NI+M1uW
	Fj5eGZtzZdGyTkpcH2GROQe60NCkLprQ=
X-Gm-Gg: ASbGncsrY+rkkrGf/kbo6MiJJQIrwYuamn1CrmCl3vKdKj9LNFPsHJYPLYnWddzkGeK
	tlKSuSjtOrlkTRmSCOn6QsLHcXJn43fF6fUUbjdhF7RA1sMz7ifsyySF8wBzQSUYNXU2780PeE5
	+SklVMUYr0sOt5EBZphtAnEhV9mwjqXDVTkgIYVTVwUmnH8mzC3h636Sn46fVr/h6uO7hr841nY
	LxhmgKfroZqMZSfmwtHLqR8F5yYj1jT8IWA1RRGacc/2Fs7GPIFMXYqaJrsm+ALQxoE24tTTF0p
	n8oYcRUUIwv3Km+p8+U00P3ogA==
X-Google-Smtp-Source: AGHT+IG3ySswXqKjDVnI6DYwqiLKZ+zahBDaGUECQtFUfaWb6/E3RF2IzUEhOFKBc0MKjkW2U6s15CTFTiZJNbe+kmE=
X-Received: by 2002:a17:902:ea0a:b0:248:7a43:e1c5 with SMTP id
 d9443c01a7336-2491f112bdbmr141413195ad.7.1756940748238; Wed, 03 Sep 2025
 16:05:48 -0700 (PDT)
MIME-Version: 1.0
References: <20250828-rust-percpu-v3-0-4dd92e1e7904@gmail.com> <20250828-rust-percpu-v3-5-4dd92e1e7904@gmail.com>
In-Reply-To: <20250828-rust-percpu-v3-5-4dd92e1e7904@gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 4 Sep 2025 01:05:36 +0200
X-Gm-Features: Ac12FXzihGQzDs_GFutYOUS54a14oRZ9cA9ZcvsQfbCtCM9R-v8HIZFcT-sGIq0
Message-ID: <CANiq72nnWmzOfZ1PhSid4t_e-yWEgi_hVx5Uj4hrB9wzpuP6nA@mail.gmail.com>
Subject: Re: [PATCH v3 5/7] rust: percpu: Support non-zeroable types for DynamicPerCpu
To: Mitchell Levy <levymitchell0@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Andrew Morton <akpm@linux-foundation.org>, 
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, 
	Danilo Krummrich <dakr@kernel.org>, Benno Lossin <lossin@kernel.org>, Yury Norov <yury.norov@gmail.com>, 
	Viresh Kumar <viresh.kumar@linaro.org>, Tyler Hicks <code@tyhicks.com>, linux-kernel@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 85D40C0009
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 8un8i8zbqrqycybrp7zipyushm49q5tj
X-HE-Tag: 1756940749-857482
X-HE-Meta: U2FsdGVkX18k3hIJNdM8zJif4vLQJoFEqit2xTf1ptP8yJOJ8piSBaSUdANaR/8TT5vSeLL76dcKJ6uNkEyKiUGzWja+i0lZ3a714tHhb1HQKZghm7fJ6TU+Rljhhay1ziZuxWaNmzigBfeF2LlJ+nRk5VQd8bE1QBSls92o60hrsCU3IFyfCq0nIekoopbYry8r0mPEECwct8sNsQrAfzAsTVA4j9ffe/s8RghfHUcBQUxhEUZwzAQEiLlciW4J+s/7Ig5pDsHFMpAxqUNpr2wc3RxC/jNh5VEddloVrvQg8+0AvfRFGi6+b170UhVU6s1C7CBDHtcnSlVNKFC4mkzz6WC5lXhmYchhRUs3PVZ7d//WcVRtB8e+advvP7SvjoHOuDKf2WPYVv1G+XhYgmYkOIfLyzIJscKqsUtErMty31m3Qcyjoy7n1jAe6g9CiJn5sYkIU9AuRo/yRDq/UJxtCZegWGEvoybquAmMsBiIL8awWVrPTCMdAbQADpyI5qT/DBf7IbEaxMyBbr4kEf2eL66KrlKAi71tau1hmLstJqcQHwU11IHI0aNVEekN1NRqi2dEp+gLnj6ZbCs2dud0wQe3ZWztxhOOZMxkBLtD4wUe3tW/IoA05okmjc+q3pspr6rj9jGtXGebIh0zdQgwVSSD59zvVnKUmo40d7soiiZajaj7Gmg7DzvjTVoQz3ZoJnOrZ0KVKA22iVb9TaxJcr0ToMPrzedk+fnjtwTYfb0NwRdx5pgX1QCuCBLYwqMDV5fJEGyqxkTso1z+g25JU181j/I12oRbahes1BEZQR3+ObB+lCs3ZcanxhdVqpDBPhpsSFsfq65YlNRtO9/KVdA+6JYGTu87khKt2AUkcGUHuXMA/r0VeAn7vTbiTy0Bc5iNu4pi+NySPDpbDahJfnAck3NSxHc3ifuJG9KnQBrNjNc/utlfQ+sdIZo5eiiy+1hUoybZtmoBiTP
 HcKZ9ARm
 TN9MdMAaWvHKuKTaF8rK2imJSBwVjTyfL7Mwn8z/8CL2hBHtRyeHHg1NHsO2CG1+cVHvmCS80IJ8LTASspkH7JQ4qVDSrOo1TECUEhvzkyLTe1jC3sJIyX43lOzUhvo7n6KlpoetP7AWhSCxkzwazZv6A6NS4Xiokj2XOil35VTfPbcMfbKIoZ5+/u6BzZkFYuOClZrf6dUqUBfvlLjZdF+gw+DvJ1rNDK5Y1UqZhMfn4nfHBuxkXZco1BFQDY7rlSi8ac5f8f86JVFcpkGOE3PbnWW4P6SHNzetJvdpeWgkTK2uh3Bd2vF6dfuBZ+bakV2JMRlU09rdffltBXr1FgGgSY3+JvB0rOQnFuR2ouXW4XOwDvblwO6i+zlYU0asfgyVa/g8bTVkkB8WZf6TtkdSYJwNiXsB4hwTcvcj+g54SLe/3zUE8J188suEjTHL7XwqdjKfGXX4AkzZFHJmeThTVldthGYL2+VA2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 9:01=E2=80=AFPM Mitchell Levy <levymitchell0@gmail.=
com> wrote:
>
> +    /// Get a `*mut MaybeUninit<T>` to the per-CPU variable on the CPU r=
epresented by `cpu`. Note
> +    /// that without some kind of synchronization, use of the returned p=
ointer may cause a data
> +    /// race. It is the caller's responsibility to use the returned poin=
ter in a reasonable way.

Please try to make the first paragraph ("short description" / title) smalle=
r.

Does "reasonable" mean anything different than any other raw pointer?

> +    /// # Safety

Newline after section headers (also elsewhere).

> +    /// - The returned pointer is valid only if `self` is (that is, it p=
oints to a live allocation
> +    ///   correctly sized and aligned to hold a `T`)
> +    /// - The returned pointer is valid only if the bit corresponding to=
 `cpu` is set in
> +    ///   `Cpumask::possible()`.

It sounds like the returned pointer can be invalid without triggering
UB -- could you please clarify why the method is `unsafe`?

In addition, please use intra-doc links wherever possible (e.g. there
a was also an `Arc` elsewhere).

> +        // SAFETY: The requirements of this function ensure this call is=
 safe.
> +        unsafe { bindings::per_cpu_ptr(self.0.cast(), cpu.as_u32()) }.ca=
st()

Please try to explain why, not just that it is. It isn't clear how the
safety preconditions, which only seem to talk about the returned
pointer, make this OK.

Thanks!

Cheers,
Miguel

