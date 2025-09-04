Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1BBACA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 21:50:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39AF58E000A; Thu,  4 Sep 2025 17:50:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3731A8E0001; Thu,  4 Sep 2025 17:50:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 289028E000A; Thu,  4 Sep 2025 17:50:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1510F8E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 17:50:30 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AB5B5B75AF
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 21:50:29 +0000 (UTC)
X-FDA: 83852912178.05.91FF280
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf09.hostedemail.com (Postfix) with ESMTP id A825014000F
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 21:50:27 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aj1bfNgW;
	spf=pass (imf09.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757022627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EzWsxCCVon/G+ryLza8yWbR2S2Ik/r0FDZw8OJQuNvs=;
	b=40x+aDsYhVk7NsfEviF3KAu7swzvZfjbO3TUudwrHU8JHOM5tLpPxmJuFLAswLMIJr+Gla
	NX3vAA93wnyyd13QmGf7HPMZEXY26+UCM3c2X789rsRezj8wOD6UwgYNhiE4zzR39B0/m3
	hiyP+K1okgepZBF+JhY7ducd4170580=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757022627; a=rsa-sha256;
	cv=none;
	b=hZ+bb6oYTA8fJ0oim8AWo0pIfM2iLvvnR+B9jndWhxUL/be0HH5Kos8KqZEJZtDM8spfPm
	+EcYUmNBqTXZtUqNr358z2cPzCsMC/LVg9wlMR4QFzmVk4cDl9IBy4bxIhYah7DeA3ZebV
	6YpJrlYcKJg52+2cJvY+/4BlD/ZJ8aM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aj1bfNgW;
	spf=pass (imf09.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-77238cb3cbbso1659938b3a.0
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 14:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757022626; x=1757627426; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:subject:cc:to:from:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EzWsxCCVon/G+ryLza8yWbR2S2Ik/r0FDZw8OJQuNvs=;
        b=aj1bfNgWsJvWUWW0dJBsbxbHIEz8WEcj+l2m0OZc6+mDhqPw6bPe1oI8EGHHniSvCO
         OwulBBBck1k7cHi81+1fNZVcpTV2bEMohpR2UsDjS9TEjS9BgLSvzHL4v+w3jhDd7Cgy
         U071dh8+hXaQ+PAoj+NcJhm6d6kj3kaakDLT2KBclvFtagdhxPCQEAHVjIPQBoFTWZGy
         oxQKBa6fXn91GtUULV8sdaEFDnWpMUGI05ZSX0XdtYPHbE9FheTYknm7Y31sIDdoWl9E
         0SnBe64nFzgtChmU2Q20/fVttGWQEZWCjxwtF/82BIQnbroWPyPsDh4nsW6zm+iRkhiS
         TGSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757022626; x=1757627426;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:subject:cc:to:from:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EzWsxCCVon/G+ryLza8yWbR2S2Ik/r0FDZw8OJQuNvs=;
        b=gx3YToWGsxd5RG19/u6oUJF7RamXZuUiVNE7Kw7O0k42WAUdCUv5Hnb8G87XdZK8BZ
         4vjLKO567qBDpJHkX9Z34I8mb/TLdmqh+Djv1GFIo+qfCom4ItOSX5ETAjEZPznMfb1b
         KAiOVgRAuZHBRAJ/TP1uSIyYPEhIQnUE0kk5laFCVQKWgb7PIKmI04UDEM0jxzTyGZIo
         xSPaZUUzlQptiaeFIfT9E13InrawwohdpJa/uO4MESHV3GOofFVvI+cGd3tYIhAXuwca
         9ww6WWv3DFWNsMSslnl3pd88r9k+tEah3bU/nDEzmqbPvjF6JC00rU4+Qd6e7Szp6ZE/
         T4zg==
X-Forwarded-Encrypted: i=1; AJvYcCWUs1rWUVMNfpkucgXyAbgwjnsivdB1IBc9AIEPrpYc2rlOCxmOfs0FB3v3ZlPYFDKdowINNjWL/w==@kvack.org
X-Gm-Message-State: AOJu0YzOeAdYmwLRpq2mxsevhYXPDTA+HpD9vg6gf2UzA0rD8tIKHoDC
	kgXodjEgmBkqYPTomAYEsYOTCwjKavxzbpWoWzE2PNKWOr0LSleh8YvN
X-Gm-Gg: ASbGncuAAnYIbj8wLm5+jW2YfB5QGtuK1zR7gf5xFY7klbH14RGpbeAtmKkgUQBmDPG
	w+3SerT2sm+F3TWSaV8kZfZLJwleWrLv6jIz21cEB/R/JhGK9tHGommsUY+o73fqz6jEzaq3xrC
	iy1eFMXQsjJg1sKpd1ShJ83VrLyiB5oUfFU7NlzMAcrVGelXUN1zA+FnmupZt/FIeX0M3cdl13Q
	cJLz6smhuT3Ih62hBAAQ9k2ZepbkGcVOgv26S7wn7d5k/h2qOleY9peubY/tcBIG8vG/+zbevUb
	LCMTwukxaGZOKrXm4GIG9h7RTYMomx4k7IM8Nq7t5M1D1NpqvFAqPaSCeVxCEgwUrfNuI8kjhDs
	wfmPbcUnbhHsANXQi0Cf3nABkhOY=
X-Google-Smtp-Source: AGHT+IE45ytdzBxMga75esb/Y7Im/l4pSAA616Pe798pih9rJgiPf5vYwPMS1Fhq7qCOSOl6pr2tkg==
X-Received: by 2002:a05:6a00:ae01:b0:772:45ee:9b9e with SMTP id d2e1a72fcca58-77245eea098mr20166665b3a.9.1757022626403;
        Thu, 04 Sep 2025 14:50:26 -0700 (PDT)
Received: from Cyndaquil. ([174.127.224.194])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7723f4858e6sm16575595b3a.4.2025.09.04.14.50.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 14:50:26 -0700 (PDT)
Message-ID: <68ba09a2.050a0220.84a5d.2f3a@mx.google.com>
X-Google-Original-Message-ID: <aLoJn0T1uXHCe1T9@Cyndaquil.>
Date: Thu, 4 Sep 2025 14:50:23 -0700
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
 <68b9f3d6.050a0220.174510.28d9@mx.google.com>
 <CANiq72nkZ0F1_YUfBg_y=JcEMnQW+uVr9v4BXONUJdor3ZJzgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72nkZ0F1_YUfBg_y=JcEMnQW+uVr9v4BXONUJdor3ZJzgA@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A825014000F
X-Stat-Signature: 3i7ffwg1jzwp65h1pz93ibfujdpf851p
X-HE-Tag: 1757022627-330227
X-HE-Meta: U2FsdGVkX1+dG6apzEBfyxlJ0LSbE3nvPxlExdp6lOW8DD0rKNTBvRbY7wUHFy/fbdOFHYOLOS4/WUSwv3u/wN5ul6a/GuMW/b13CQzBgM0d4ReDN6RndRrksPh3feYkwgWVP0Jpt7oOkIT2FsNXdPG869OWktPsyR4AqpgcE/zk9ToBUQxYG1I7Mk86k/WKC9SKprf+xAL1cBDnP8lMdPR0/fi7uenj1K2H9CqXO5vH12Z30n+T/60jhijJ6CxnyP3YK4ila5g5c0ixFFTNWanLYzunBqX9eBp7mzG38U7dQVyWo2cgrkwm6WwO3xR4vmjqqbMb6iQ3GT3qUGsYX1oau3idqe0cGNxHO+ZnUQV0o8dnTxUjEV4eV9cuxdvhoi7txGyPlcCatiQPiQmM4gsKDmEzFCavVsVdSX4mVRK2iWU5K6zLUw3W2SgmLKA0csEDPXTL2OWB34kxXXZklkxoGwRJUaH9N2lwHVIcUfLH6HPglbV1Kx7xennVD/Wk6cbuI6tkpBPccONEowgevmIXxrLaP9p3OAmotf/VvYj5FITVQfUpKPY+38l86LuQtSGwkFaejM8ktl54/Fjaga11Iy+hKyzbBtd14B94r8SXIOG3HxrPj+YeGaAZeFlEc+LxWx7vjbq2Ye3zI7M1qWKLAJv516EZ188+COb1h6CGGdKL49h+ep+P6ip0ubBcmGl3aibrubMjyrfGU1M2n3pwV1rBoAH8/6tz1Fa1ZrRYcuIESHy5tQ0QkAMfqyR/QWsJP4h8B4bhvNbaqJCDBEdodCWHTeO+is4El1Du1J2r58FmWPxPuVND5rKl07V6TjNT4bUsx/IBBez5jqpxCxbqlRjBZIewR9qAFcp40D0zAXV4u9e7PcEUDgtfxe1Pf8yKTZ1r+72XXjDVtKjRrNnBYypZJD4TmRVw9DrmK6AEBrrrkDgZeSNiilSzY174gs2OphCw6/81R1oMEtH
 9tHw/cJB
 XXEZzfR1Fq1dBD52g3p7p8LTMjHAIi6MYiFkkbizzGLfPNFjFH0HtEQIWF1UdxVWFT6estmAtPa5NsF1VhmtmOun5/kIu4hAfbVtKkvnqsy1ziZsnF8EHNBIhFiI6Gu75XACvQBhG3wroe9cwuDHNgvvIyxmbyew+kaM3G9DF3QNw5IacC9LORxp9J9u5peO4J8m2+fMSn4L5jJc2ozmM7NNbr7I9sTeVunWbnmTavCODiGCdisjYExbfHUi3apT6+Jw1DvaEno0Af/s8GntJvT+zTzHtN4kOWh/SqHh7odlNRVRaMEZ50gEb5Iu8YvEWn8gzF2SVUG0dk0actC6VZJ+5rwUquDosCOzMf6iY+nqa8oVFXQAjlXA3phj3CuYm74iD+V8qYWvdIuXl5R/2JjlaEW/Ro+MqgUnnxNe+LLfpuhB//b/ZcJqNIjyk8d80F8sLwuiDLekwJaCkSf0tSdLkLsG2sR3RuPk0vp5h+s8GZH8uPzQydDr98nitNMWU2tmY0DyoBy651PtFC5YNrzLQ1JFUO6quvCT8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04, 2025 at 10:37:48PM +0200, Miguel Ojeda wrote:
> On Thu, Sep 4, 2025 at 10:17 PM Mitchell Levy <levymitchell0@gmail.com> wrote:
> >
> > Will do.
> 
> By the way, sorry -- just to clarify, I didn't mean to remove
> anything, but rather split it (likely at the first full stop).

Oh no worries, I gotcha

> > Yes, this is true; strictly speaking, calling this function without
> > dereferencing the returned pointer is always safe. I suppose I find i
> t> clearer that, when a function has preconditions that are necessary for
> > it to return a valid pointer, the "safe-ness" has more to do with the
> > functions preconditions than the act of dereferencing the pointer.
> 
> In that case, I would make it safe -- we don't use safety
> preconditions to mark "dangerous" operations, so to speak.

Understood.

> > In this case, the pointer shouldn't be going very far, but I think this
> > logic applies especially well in cases where pointers might be getting
> > stored away for later (and so the validity of the dereference later on
> > might rely on non-local conditions).
> 
> But that applies to any returned raw pointer, no?

This is a fair point :)

> > This flows from the first requirement (that `self` is a live allocation,
> > which is necessary for `per_cpu_ptr` to return a valid pointer). Though,
> > as above, simply possessing this pointer isn't UB, so it's arguable that
> > any call to `per_cpu_ptr` (on x86 at least, I'm not sure how it's
> > implemented on other arches) is always safe. Regardless, I agree this
> > comment should be more clear (even if the function is safe, it's
> > probably worth noting why the pointer returned is valid when the
> > function preconditions are met); will fix.
> 
> Sounds good, thanks!
> 
> If you have cases you think other architectures may have different
> requirements, and you think it is likely one could enable the support
> for other arches and break it, then I would suggest adding a comment
> about it.
>
> Or, ideally, try to see if other architectures are fine already, even
> if you still don't enable the code in other arches.

Yeah agreed, I'd like to get ARM64 support going soon-ish at the very
least. My hope is that I should only need to mess with `percpu::numeric`
and `PerCpuPtr::get_ptr`... usage of `per_cpu_ptr` *shouldn't* have any
prerequisites, but there's just this note:
https://elixir.bootlin.com/linux/v6.17-rc4/source/include/asm-generic/percpu.h#L29
so I don't want to make strong claims :)

(note, I think the comment about x86_64 might be out-of-date, see
https://elixir.bootlin.com/linux/v6.17-rc4/source/arch/x86/kernel/setup_percpu.c#L32
and
https://elixir.bootlin.com/linux/v6.17-rc4/source/arch/x86/kernel/setup_percpu.c#L165
)

Thanks,
Mitchell

> Cheers,
> Miguel

