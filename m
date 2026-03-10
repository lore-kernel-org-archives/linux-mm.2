Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDE4FEB1049
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 10:56:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A4706B0089; Tue, 10 Mar 2026 06:56:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 378E26B008A; Tue, 10 Mar 2026 06:56:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 250366B008C; Tue, 10 Mar 2026 06:56:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 143E76B0089
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 06:56:38 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AFC041A0596
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 10:56:37 +0000 (UTC)
X-FDA: 84529850034.22.960CA7A
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9F21B12000F
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 10:56:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EWBs83MH;
	spf=pass (imf29.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773140195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4qBpWaqAk74juZmeca9VRmKlmVoYIHqDYNOH37dt7g0=;
	b=18xneLErkrxEZf3VnGdWWCKU/C80GV9BQkC5PbctuXIfbDdMLNaZItL3VuEYDadVhM8IJU
	ygnUCFBpXcDHfvTsVE050T0P9trwyOeRq4qrdPnpuHVhuCe0/a381zv8j/nfb+44o0pciq
	Ss81Ysy1UVshU6/qU66jGJtWKntfmME=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773140195; a=rsa-sha256;
	cv=pass;
	b=cwKvlxn//p1kqLSgT68pDMfF94Nx9ybaezjrmzKmPnPnAK2ecXAfzGVq19peY5uxyIVTHk
	kkoXaM6M3CH6AaVEC6LEphxJmd3rrHFdeClpvGF97Bua7IvnAH5X4OAmbDPE4DVr+BsyND
	hfLkTlRjfqlJT11GaZ+xm1DdMESYtrE=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EWBs83MH;
	spf=pass (imf29.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-2b8095668ebso829448eec.2
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 03:56:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773140194; cv=none;
        d=google.com; s=arc-20240605;
        b=lBw4xnc84VnEesXkTzUHxeYJ/dwJrDOFdo8zaJ070ASfFKnwK61hBsoq7NYSp0qJv2
         W/Dx5r8fRQwi/8WQS7/XXqB55zoihr7xeATn0kitweCctzpQ3b0/3xJcqlH8fViH1tWi
         iBirjbAWWe/RGwdKKEYXdiaIck6VP72lKn81t4hmXIuNN6SKl8442vWMUZgOKp2rH1Gt
         IbRfVCQ+6F0EyFeINie/tEoYxDapmwTQ81glqL0Q9KWTs9dstAe+P2jwdckxMo9XEiWN
         suwS19P0GeneeqWJRfXe6PkUhcWOOqqLSlg4qHdL+K0ONa7uZIu73XrjrxiXWRSBjyTd
         qjQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4qBpWaqAk74juZmeca9VRmKlmVoYIHqDYNOH37dt7g0=;
        fh=uBkv/PmaYPlg9iFdj8+ckoF1sgbzenwlLpqITW0ZrAI=;
        b=RKsUZJoCPCrVw5pYbGm66RjjKsqfwM13FpFOMN5KErA1c/JSwdUQ1Py1vsh7pQirkf
         13cvOeTs8FsVAi4/bgCEOlAskAxLxVxlJqbir5CYNAGS2I7jkUcki5HkVT89SFF9ExQw
         uYqWwd/ffNMarv2Pb184MpoXCY27hNU2QJtaSUgkZni75Y51CKj+f4gjUroAbaT/5JPN
         Ks0Y6jW3g6lNhM9Zl+IuqOrT9EuWZrxvR1lz65Iss1D/yZM1ONlEF/AaRT2fqYaG7VKT
         s9SVyC5YILS3C7xpMeb6LpZDzT0CqV9xhXwwZUi68RgLJKjmbLfZXLnKmp1vn680mbPf
         ltXw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773140194; x=1773744994; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4qBpWaqAk74juZmeca9VRmKlmVoYIHqDYNOH37dt7g0=;
        b=EWBs83MHx/Ufn1nEeYR+JBDjGCUCLNt7OvaDJJv4RX6nACGJKPag40YB29zJU470vo
         2nNxjeaX51eK46jd131vfutPunhNT9O8Z4INUmXpFHcXtZZh/ChNCvkC8rLHEMm00T92
         Z8rAUhuTvolNf+giotUsRQ/LY9NSj2BIfGzgf9elkNcrfiHYm7JImfCCldx+Pmo0BJmw
         f+e+BSMhFmTfZ5N4/35tOifS+xREJnP6zOWykblT/LKzn44joljgXq6ZWB4M4tNJBPwq
         yd56mV3LS+mxVKyPPhLrkpzFqX3Ccb9BdE0W0+s5mTAcuJRm99Gu+QnKAKWtgKhoQAww
         SLdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773140194; x=1773744994;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4qBpWaqAk74juZmeca9VRmKlmVoYIHqDYNOH37dt7g0=;
        b=TrWTPwAFEonmhZtKontXX5SZsr+lnEVv7IV+ESn8mu7C+dDnE1gN16PADy8NbEpJtV
         +RD2jNVgOT+BHP+5Ph2DkVe4ELnvFJFTdIvZT3gSaJPlB7E/UEtxMsRCy2lyrqW6RXBn
         B5Fio0GDVBd5qbyM8henOA97HCC0wYci3x/jXc1xHstd4fmZzpxz1YACoEHaLDi7zsov
         h3kOD5EEpXuAVcp0LxHsMnNsgIh7T5xvu3Z275B/tMZxkpXbXaBfme7edqnZCc8Ml7Wc
         6yUfS7zVKQXB3IF0VJY9y7V4Nse78EeWXtZGn2xFTQHwbCgGEL32QzWeSBUKyU5lvjUh
         5wsw==
X-Forwarded-Encrypted: i=1; AJvYcCV7a8UlnX0oJw7s3UuOpvCbpn7phV+NPSpuJUKCMaCSdmS0lrJqMJ1afAmkNNS2C9bmQOtWMNzF1Q==@kvack.org
X-Gm-Message-State: AOJu0YxHZJRm9+HPi4Y0N9/nMFY+Y921EjBQfWyI7IN+ISLHZBIblGy/
	w0nmUTlnc7WA3SaRo6rIIPgZsyQfNVuC8P0VwBQOspPhtwP7/BfxX+sVIl7n9m9TjhIRDFLah7E
	tiHikzrJ5h5rtZzSALZysouO+vQsKQnk=
X-Gm-Gg: ATEYQzwzO39IuCHhL4d/rfAKnwqZUvjIuIxr1YjIg4/IExmwMJRlq6M3DqQDj0EJ3pD
	G4Br5FlYtr+VoMgxXcR51XU35I7H0x4KY6EYrSr7M9dAgB3d7GcCn8nx8nyzz1liR06DjK3lzIa
	tWlYCmuEOVrApxcw7cVCAlBePIYny+4MShO8uxWOX5xpQCPvt9/vm+tdPteYHX4I9CkHQ9FTlsO
	ri5KC7MbfjPTrBDpFTV6dWCQL5+CiPrfH1GIELofSw/0HDCxKyvKcdEPl6y6Ob3zDBqpZfAvlia
	OBAGeUnfQ6Ki/CRGUZu4yIY/6Xknf9XaJC+KpUnmptwMXhJJq6UJrgyyyzm95hiXsiv1Rqunb1j
	DbudgsLVoIc4MFQdK1bKH8PQ=
X-Received: by 2002:a05:7300:ef97:b0:2bd:bc33:ca32 with SMTP id
 5a478bee46e88-2be4e09ebfdmr2731651eec.4.1773140194353; Tue, 10 Mar 2026
 03:56:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260105-define-rust-helper-v2-0-51da5f454a67@google.com>
In-Reply-To: <20260105-define-rust-helper-v2-0-51da5f454a67@google.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 10 Mar 2026 11:56:22 +0100
X-Gm-Features: AaiRm523FMnYeZ1Cbp2n7uyCKjNSK8gDXCio5_BkegPeyUfSKYibfT47XJIo0_0
Message-ID: <CANiq72mT2-8m71NtnodVXVBRkhUSiK3Byq5OkBntEQpW9hbU6w@mail.gmail.com>
Subject: Re: [PATCH v2 00/27] Allow inlining C helpers into Rust when using LTO
To: Alice Ryhl <aliceryhl@google.com>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	Peter Zijlstra <peterz@infradead.org>, Elle Rhumsaa <elle@weathered-steel.dev>, 
	Andreas Hindborg <a.hindborg@kernel.org>, linux-block@vger.kernel.org, 
	FUJITA Tomonori <fujita.tomonori@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Michael Turquette <mturquette@baylibre.com>, Stephen Boyd <sboyd@kernel.org>, linux-clk@vger.kernel.org, 
	Benno Lossin <lossin@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Paul Moore <paul@paul-moore.com>, 
	Serge Hallyn <sergeh@kernel.org>, linux-security-module@vger.kernel.org, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Jason Baron <jbaron@akamai.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ard Biesheuvel <ardb@kernel.org>, 
	Andrew Ballance <andrewjballance@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, maple-tree@lists.infradead.org, 
	linux-mm@kvack.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Vitaly Wool <vitaly.wool@konsulko.se>, 
	Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org, 
	Daniel Almeida <daniel.almeida@collabora.com>, Michal Wilczynski <m.wilczynski@samsung.com>, 
	linux-pwm@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>, rcu@vger.kernel.org, 
	Will Deacon <will@kernel.org>, Fiona Behrens <me@kloenk.dev>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@redhat.com>, 
	Waiman Long <longman@redhat.com>, Mitchell Levy <levymitchell0@gmail.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Lyude Paul <lyude@redhat.com>, 
	Anna-Maria Behnsen <anna-maria@linutronix.de>, John Stultz <jstultz@google.com>, linux-usb@vger.kernel.org, 
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Matthew Wilcox <willy@infradead.org>, Tamir Duberstein <tamird@gmail.com>, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9F21B12000F
X-Stat-Signature: k7xmhx4tqaab41wbewdnc1e9xus6hnqd
X-HE-Tag: 1773140195-956104
X-HE-Meta: U2FsdGVkX19SGf7HqcEZT1EI53MP7YFGY9BfXRKYdkmKMWhtxHz47lwCxPJfMypYz58+VBzhIceMXjPTFKpjV/A3HQUNIPHUNyTVVCfe9GBqOxitznfRMSryEH9k1zLECeQejqf6jT4azNg3Byqd1yOZ2zV9DC6pJCdFRGHw7LtS6Xc/pPgQoo6ZykDZOVvZkr1y8b1P+5YW8UXhERKBawNGuPrlzVAG+cj3VOEGdScSN6SFNf9dJ9A310nVV3VxsWm0G1vWJYza/2F9eRKxDmqeFLzM45XX0YWYvQMM1oA4qF2q76RhDQc2Nbr2ebp4nnVzYQfbRKPZqRZGs/2kN7NeT9JXvCUbXCL1NUFZtwMj/+/GaattAa0vqHRhGNYWdJ2UV7RAkpcIB93nM2Mu0Iaqc2otuJ5ijU5m5MjOw8gJvUbbuL0n9ZImhyZ6vKStW3byk49DxY32ALESZqy9wHfl6j8lo8hBTPvajw4bszmkbf+3o2vgB2adha8sB6t9QnnahQFuG6Pe1jVM8S4OK+Wuf2f59I2bqUmNDhl0XZ6Rjeq0RInRGFBwJtI2b715rZjIEMqEQgajWnNlxYU6Ox8l8J8oI+a+CLy6Cq9u6kHIMpe9bCCySBG2GgxHTIRB6wvUlfuTYjfM2udmcwsFTbtpTNXMGVF2Q+HgB3KLtlU8DMg1i/7e2upG/k7qDx7frMiGX5/TbjCgEXIPLUQSNkd3qqVpJwdVq8tDz7KDk1TyjBEkd1vt13UqIZcbbjiuccoKs3SUeZEQHUAbMv4K0ylM1BvlVZAD5jl4Lu93ipX/64SqLxMBmbU9lRFznUpTv/HaL/y/g4EqNuucjbBS/PCl1owW/ftO/dOExsQNcoftyt/DRm5U+l8NZdTt1/fGxVi/LkMBXdcRK4G4Sqw8rlzuNc4aUG3s+NstzUo1f03Dqw7F/m1QWuBfbc5ulBPhLK570dGlWTVlb4Ubgy0
 E4wNUOA6
 2s1NIN4AXCgvrrXqWpH5zzGrLjfa7yL7Q807q20RjN6bB8UX5qCepBfHT21/dO+mz2/3lhHs1F+/5LtHqtPM6IIew0y2QuyzCpA+tCyuDt3s6FTI8cacOsRlaWmYiuHC7IY34lobSxZaZhVxy3+4nsbGWQck7E7nPYGnhOJcB3HJ/QrHCSpaFQgC4qKN1Cxb96s7T6aciUgmUCFqFlFhWjle+pcQ07c7Ftd7nycEN5MX1Vc98LQ3LjnzOxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 5, 2026 at 1:42=E2=80=AFPM Alice Ryhl <aliceryhl@google.com> wr=
ote:
>
>       rust: clk: add __rust_helper to helpers
>       rust: jump_label: add __rust_helper to helpers

Applied these to `rust-next` -- thanks everyone!

With these, the series is complete.

Cheers,
Miguel

