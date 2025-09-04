Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A483CA1013
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 20:17:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E2258E000A; Thu,  4 Sep 2025 16:17:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B9F28E0006; Thu,  4 Sep 2025 16:17:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F6A78E000A; Thu,  4 Sep 2025 16:17:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6F2138E0006
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 16:17:30 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 18FAE160387
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 20:17:30 +0000 (UTC)
X-FDA: 83852677860.17.AA23A6B
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf09.hostedemail.com (Postfix) with ESMTP id 11D1D14000F
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 20:17:27 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LbtolF8z;
	spf=pass (imf09.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757017048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pq20/wlph+/sfx7lO2f1OE11IHMFYfLN+JkAAI1PIb4=;
	b=LfflfzTXZYhoJV1rmVV3QwWgGcXvuG7Hhh1LRxTEylSnrpn5jj1jj9gizhpoa1XqOnz/Aw
	fb3b8NA3gzKz2vK7nMDxDMKPDoUNLJc91c8I2JzA4gWKikE4LVYNVVA3PQvgmYTv+jycmq
	u6jbj38kaPe9rT7770N0bBUuwvI3zWU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LbtolF8z;
	spf=pass (imf09.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757017048; a=rsa-sha256;
	cv=none;
	b=sxYZwl0LATn/+gGIa5kW3kv0iUkuzwCyOMzSYqdM2lRK/plk+jXyS4xzyHzQScI3C8bGTE
	9AlZROaIWLd2MGVHKKXnOH49Vnxrp140LoAJeZSennufs1y0zjOnf8QjFbvPOYTLMDYRZ5
	+BS1JcgHf1xsO7sshLY9LovBn04lh1c=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-772679eb358so1402809b3a.1
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 13:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757017047; x=1757621847; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:subject:cc:to:from:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pq20/wlph+/sfx7lO2f1OE11IHMFYfLN+JkAAI1PIb4=;
        b=LbtolF8z+44nb4fLtuOs5xr5htOaQHpFxdaui7rmRnxR+h9xZ865mey32JAnINX6v7
         kMJyBK3ap4C3mdxXeQuRx/JveD0fxBdmrlQWV3arumCStgw31p8oXczAJclMyZ/PSygl
         0mn52qL0+oMGgTwRzMEOcDkrWYX5s31dH7Fi7xbGDXzdcD7Qi/wQIKcop7guLKnfp6bU
         JDrk+d0Xi2BmQ/sdALgv0eBZQYCBszNUPvHvMexj9D6zmkGVu2XGpFB8YKejAa6B9vMe
         my8q9xoFPHD73snk9dO51lP6sR6seAq75i17jR5IKRMg4j0A28BAlsWC3nP5Si2VrkFT
         mwOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757017047; x=1757621847;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:subject:cc:to:from:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pq20/wlph+/sfx7lO2f1OE11IHMFYfLN+JkAAI1PIb4=;
        b=rSO9wmcdjzkP97fDg5NwDKPtZPk3ZxGR0VzTpw8wunp5hVpqbuRxw9ZpbFxsQ/v0dp
         D2/pLXsf4zkrfCiqKy+/sK8hTqbY1IPexZIgVZ67QfoBUyAyXWl8YrmjasEuwKvmpAqq
         uFK7vX6gcHQ90FTedEW133PwpYkRJVYhAdS95MZTZglBX8PNBhJZSZTJwmwuiTBojZC5
         HIjShP8D2iA5JwgVTBNnUC9a4RHGbpuAGyVNO8x7ehSJeTOQnyJvXdncX7nmjSTPELWD
         P35eDAkc+3VYlcq7+CO4WjjUfZLffGaNLs1J/jvh6t9D94pFqfojr9naOBVbOdGe7hB4
         LAcg==
X-Forwarded-Encrypted: i=1; AJvYcCXPlpeurFjr/6fHZY9+BsizavZjcV5WvAN8zdpjykppwOaBJas1KQ1ccrrWgTzSQw17Ib4f39BFxA==@kvack.org
X-Gm-Message-State: AOJu0YxiloO+Xu9h1mNF7WneqXh+OoPVhCkkfw0+R+7uF1DuYhc4Ltmb
	HwNod5u4BFTiPGi9O4ajwcUnNqlVRFlYFyHo1g8/asAinB/oiLcw/B27
X-Gm-Gg: ASbGncuA8csHTS+crP8PNnAEDi91jtoZbgZkL/xGKfjndZOio564mCmnKU/9oPTCmxd
	yDORDCc1TJzA15JEYLeQ8J9GZDDgi+TTeuiTkGNRQY4idhaoT9GQ9tn9zn5yAmvWeDqqXM1bSc/
	C+XEnbyJ/RgCpgDZNpasXdMwY7LVUrNd/QtzL0I8pb/5SKgpfVPuIfAQp6Zy1KRTaCL8DD/WHwG
	m9QBerr/WUj8khOw1eifMh06rEVWoeoSU1Y+Nd+koYGczHgth/mOzJKGiYudRKzHZeXLp78NCLl
	5/uRIN29EHVT7seZ2WCIrwNDjkRJwFCTWZ49qMroM92Iqo8ZaWfTUiQfBQlst2tNjPTu7Kn9apb
	gHcj11xsAIFA6wafAlmzvI71nGMsegz/Wm4f70A==
X-Google-Smtp-Source: AGHT+IGtYbHSzsT/hKR4OTH/QsGVO8hm2oxQsP17KMB8YDd+oFWhTdXnU1XAVUUiBDw8vBTOxLxecA==
X-Received: by 2002:a05:6a00:2314:b0:772:bb4:a1c8 with SMTP id d2e1a72fcca58-7723e387c08mr21653637b3a.23.1757017046728;
        Thu, 04 Sep 2025 13:17:26 -0700 (PDT)
Received: from Cyndaquil. ([174.127.224.194])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a26bfe2sm20265198b3a.14.2025.09.04.13.17.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 13:17:26 -0700 (PDT)
Message-ID: <68b9f3d6.050a0220.174510.28d9@mx.google.com>
X-Google-Original-Message-ID: <aLnz01wMxA73GRA+@Cyndaquil.>
Date: Thu, 4 Sep 2025 13:17:23 -0700
From: Mitchell Levy <levymitchell0@gmail.com>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Benno Lossin <lossin@kernel.org>, Yury Norov <yury.norov@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Tyler Hicks <code@tyhicks.com>, linux-kernel@vger.kernel.org,
	rust-for-linux@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 5/7] rust: percpu: Support non-zeroable types for
 DynamicPerCpu
References: <20250828-rust-percpu-v3-0-4dd92e1e7904@gmail.com>
 <20250828-rust-percpu-v3-5-4dd92e1e7904@gmail.com>
 <CANiq72nnWmzOfZ1PhSid4t_e-yWEgi_hVx5Uj4hrB9wzpuP6nA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72nnWmzOfZ1PhSid4t_e-yWEgi_hVx5Uj4hrB9wzpuP6nA@mail.gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 11D1D14000F
X-Stat-Signature: oi4h3cokg1sc3zeh1wn1xz6i54yza1jf
X-Rspam-User: 
X-HE-Tag: 1757017047-166373
X-HE-Meta: U2FsdGVkX1+GuxAaWAFXUTxlKOeLT0ri8Q0UEw44oDpJWkWfYVQp/4hQqdO+VYSRC4thxXNrNz93nq0xEFU9Ptjmhchn1ohIydoYrvWMXGzV7QVA+594ixkwk6eJxrXMCWegfUVzgae966APkZHCVIRZAws+3s1znFhloOo+R6J2rqOI7hsJXs+I+QQ3kCn2N3YuDq8nr1IPINGtqLY6ODvrxfRV/dcGxaVJzWiUQWZuWEYOFJY48/D9WQxFvMa79HYWD75WMz55IonJD3wXo4vHKwSprUY88pVz4rlHzzqEt2b+svjjzM+vMku4GiV+P8HSnUmKRUSAh1MtGG0b+C6SIsK7+QFsPY433h7kttT4NIhrr/KaI+z+y1G3eowVLXH1pp5Hcg0DocJFr7PtXzQJCsU6y0o2v082vjZy4EepX0k2nX3i7E0+C19OGqxq0Mx87s+BpybUjxirqYNfOrqU8r2QX3x0CigiJ/GRtRXZSx124EVUFP3+XEjOKy/BvqF5EOre0JK2WL/GgV6ZWwQuleZbSv0+e72g4Dk0ZBMdRSS9vrpDtZI2/HLwOYGvL68TZu7C23Z9QkTGffzjoheGmGdnCHmke/j1SINn/MVTYLYmFY9a5Gg5+g7H4wwrEGu5BRWOG4xeq8ySmnyACt1FwQ0yj0psndcR8a0jYGvh+nUPDBn1B1kZiRAK/4+U9qFU+vdAZ4OI0p7AoDJAUC7FPwnEDsYXvnCJ2uEr7XgaYW6Oq+RY/MwXPT6QlO03Cpq9DD6qkXgKNDHC/r3CstWw2KJ/dp8F9OO8nN5uA/5ystaVxBPDCcQHrfsUh2/zbZTkVhSk6AgkdqGYrOXnfzbgqAITwFi88vI7/+tQCQYg0W2Wj2osy0NVPUZz5nbzWJijEz9nAK9DYpaMtXh8WFW1SjuZNZ3ok/Ut8+Pd/4U6sx/c88JBr8D3Fd9JcATeh93c241U/eOFh+H6NLP
 AphuDn5N
 xmjw/g/Zn7Y+P9/RKYrX1tWoYD+DllSjjedBYia4p3/bw7tTke5ee5PvS5rMQF2rcMihqMBqteET6fAe68yhwOKapLQE6tQGC5gK70nZ6t5PmyP0W2nkxkCxv1+g6r0GjijgUGOqZzQdPrzWtoAUhAwicFrQhYbmcCsuPEjGZyH2VL5roXnyH44GuUZnN7Em1dbrFcdzJdtdaFVrP+NqxvrqMDnI2c+VZRF6IdFnUNWIzNr5u+K9/xIPrjTrzR5bJkZEjI1tkBzoLz6HK7Av3A5QWB7rOuxRCoRIgQ7a/qRmsECWbUiIGWtWNELNVdoShj8CXyJJunPuwtHXVrrJhXFmQR4dJs9CAv2A5rlq2ba7aPlx7cy9UOblrO1g4FtX620GeetUR7vfnRCbrxW9YmBcNonNDozMQ+vV2dP2N9oG3r3hJ8PhNjtSOM9Ino1XuW9IJ7C5+xv6J1dwLmGqtAIKsfe8QbKx6f5hdicM6J87slhW9PuXe5JnVEcnzvPgjEPC1FVnBCVwtTF50teUhHzQfutJVVhLrTIXX5JIm7y/nuFS0PNpFXYFcNg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04, 2025 at 01:05:36AM +0200, Miguel Ojeda wrote:
> On Thu, Aug 28, 2025 at 9:01 PM Mitchell Levy <levymitchell0@gmail.com> wrote:
> >
> > +    /// Get a `*mut MaybeUninit<T>` to the per-CPU variable on the CPU represented by `cpu`. Note
> > +    /// that without some kind of synchronization, use of the returned pointer may cause a data
> > +    /// race. It is the caller's responsibility to use the returned pointer in a reasonable way.
> 
> Please try to make the first paragraph ("short description" / title) smaller.

Will do.

> Does "reasonable" mean anything different than any other raw pointer?

This will depend very heavily on `T`, there's a detailed discussion
here: https://docs.kernel.org/core-api/this_cpu_ops.html#remote-access-to-per-cpu-data

In general, remote accesses are strongly discouraged, and my intention
was mostly just wanting to reflect that in this documentation.

> > +    /// # Safety
> 
> Newline after section headers (also elsewhere).

Will do.

> > +    /// - The returned pointer is valid only if `self` is (that is, it points to a live allocation
> > +    ///   correctly sized and aligned to hold a `T`)
> > +    /// - The returned pointer is valid only if the bit corresponding to `cpu` is set in
> > +    ///   `Cpumask::possible()`.
> 
> It sounds like the returned pointer can be invalid without triggering
> UB -- could you please clarify why the method is `unsafe`?

Yes, this is true; strictly speaking, calling this function without
dereferencing the returned pointer is always safe. I suppose I find it
clearer that, when a function has preconditions that are necessary for
it to return a valid pointer, the "safe-ness" has more to do with the
functions preconditions than the act of dereferencing the pointer.

In this case, the pointer shouldn't be going very far, but I think this
logic applies especially well in cases where pointers might be getting
stored away for later (and so the validity of the dereference later on
might rely on non-local conditions).

All that said, I'm alright with having this be a safe function, with the
documentation noting these requirements for the returned pointer to be
valid.

> In addition, please use intra-doc links wherever possible (e.g. there
> a was also an `Arc` elsewhere).

Will do.

> > +        // SAFETY: The requirements of this function ensure this call is safe.
> > +        unsafe { bindings::per_cpu_ptr(self.0.cast(), cpu.as_u32()) }.cast()
> 
> Please try to explain why, not just that it is. It isn't clear how the
> safety preconditions, which only seem to talk about the returned
> pointer, make this OK.

This flows from the first requirement (that `self` is a live allocation,
which is necessary for `per_cpu_ptr` to return a valid pointer). Though,
as above, simply possessing this pointer isn't UB, so it's arguable that
any call to `per_cpu_ptr` (on x86 at least, I'm not sure how it's
implemented on other arches) is always safe. Regardless, I agree this
comment should be more clear (even if the function is safe, it's
probably worth noting why the pointer returned is valid when the
function preconditions are met); will fix.

Thanks,
Mitchell

> Thanks!
> 
> Cheers,
> Miguel

