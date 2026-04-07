Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0354EEDB7D0
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 21:51:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B60F6B0088; Tue,  7 Apr 2026 17:51:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5673D6B0089; Tue,  7 Apr 2026 17:51:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4554B6B008A; Tue,  7 Apr 2026 17:51:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 341F46B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 17:51:14 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BF0361A09AE
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 21:51:13 +0000 (UTC)
X-FDA: 84633106026.04.232D9F0
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf20.hostedemail.com (Postfix) with ESMTP id F3AD31C0008
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 21:51:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kulemmEO;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf20.hostedemail.com: domain of vannapurve@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=vannapurve@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775598672; a=rsa-sha256;
	cv=pass;
	b=4BcXPlJL/dT5fgE84tK6tCW7X+eKs1DqdzQu5rLIR+0x6pP/wPyCU0+GPcp4n43Kh1TlEZ
	bbNRu/en7muY6oMYQl7+GP3LsVg65fjMpj7pGhMTUzLnNbaHiJyQ75ycLtUpYcTGAvgYUU
	lB41Y4Ftf8xQONquC4390pE9CwXyGHo=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kulemmEO;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf20.hostedemail.com: domain of vannapurve@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=vannapurve@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775598672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gaxd0JUvuI19hIXHFFbq0Nmmwdg7JnIiT63vLMwEkLk=;
	b=bf2qYticRKkpcHpne57bdrK4pA1qnekGcdKgc1DtA1wfE68XSnEXuXlKXDnit4jgE/iBnd
	BEzsYSlVCQ69TQVYSbO8Ab5EIaOcCPlYZEq3z+uoBozCPjmWpPlq4mzkKKeyCQMBISeqzl
	8O1Fo/SS27Zp/VGLHxrOSr5IBUhCeRQ=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-50d8c7a393fso97261cf.1
        for <linux-mm@kvack.org>; Tue, 07 Apr 2026 14:51:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775598671; cv=none;
        d=google.com; s=arc-20240605;
        b=ZbldTrdmgWp+/jRcnktfxzlTiJwCkzOPWAKLYmx7oNiGjt5JCjcIeKZt7XeKjde1mz
         Wl5d1WpvHGy1Eufgta2WQ7XU/UFKE1sl8knNjRK3ff0DqqcClW70946xnaAlYkfP9bix
         0BpPKNW4ddr5WWE4WV/YP3eyyZsML5V3X4odf2rc8r6iWmtdeshtMHPlJFRdlfY4fhMo
         xtBKCH7qdOTIWt2mh/GPGhavMbAjnAm3EjiFl7DvX7qGazJ6ukzQ9jnfdklvH32rh110
         pumnL3RpYryzPA+vBvzRyris8L6jtbwA68k6+1181ZvMGAd/8vqDakkIaTjCM0j+1Uxf
         cDGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Gaxd0JUvuI19hIXHFFbq0Nmmwdg7JnIiT63vLMwEkLk=;
        fh=U/Yt2VcRIIfvE1E/CRlhqtehqqKyA87MdsXw7OOrJQ4=;
        b=k5lKEOPvnTo+2GoJElZUeG6Vm8W9fXMQqEo1DWSVuS37lQfDsN9oQVHIUAvTxpSJPi
         cu/n4QIATNHahZUUmuNLa1cxjxw02MDet1arh+iUTrMek71m9dRA7xrBmCWl2k5DPRXh
         qsru5saHpBoNtw34U2Ur0d9+lwgWAwSKBo1Q5aNV0EdCRTG3hJa20KwJngQ4sQWlo3PI
         21kKpkk1M4FC4VLc6ZNE0StZuEkwAp5NSy8jial16Llh0LOPMHXFgyUjUzH3cRXwShaN
         DQnXg3iWFDHLW89iDyeRETa0HEQoVBpzGWUh5V337JQFE9RGEUnNDjQT1mmit28x/Zm1
         DM1Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775598671; x=1776203471; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gaxd0JUvuI19hIXHFFbq0Nmmwdg7JnIiT63vLMwEkLk=;
        b=kulemmEOfvni4W6NohxqzmydvvVJ0d9kV96W3kL9kDMdWQbBu107rn1F0b3DVqOxN6
         ac2ekma0MMoLIh5EVqGm8/IdypTnXuj7Fw141PRinZ77mSa6Xa1LEiIkAQWnZfJoRsb5
         JhAOs4AiWoR/bZGRkyVnWrFXFThLiC6tE1KPrTGlB7M1cEvghVh6O1Y+ZlBPfJP3tQWE
         c/zqepjC7a7pDoRvvTMq6dbQfQdG8ITohQ4jEpJnevUp6Ywgzjvr3lWnu0XUaEtifprz
         5fL2azdxouUFDiybzDoEcvHMwLMGU00khiEmiY8Hz1vwpp7i7cFm3/jX5+WbPGv0aUxf
         cO0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775598671; x=1776203471;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Gaxd0JUvuI19hIXHFFbq0Nmmwdg7JnIiT63vLMwEkLk=;
        b=gKaDEHaYbW1EEGr2Hjsy07kqmyDW/M8vtyj7s4c6lJLc5bLn6+sospNyYEVij0KpHf
         MMHtSrdP7GrNGGPwUP7z/1DcJoI6dQfH8dk7OhPsKXsNl178O5ZEM8A4TpIV1jS7xVQu
         N99D0IurCeAqxfvi+5mbDdfQXH3IAfxSTyE7plffwTYUFKaf9pOXJfp33OQZBzQayV2l
         +F6P/I1kA9X+5xXAVEDo2hrvaMcpvgb2sy3kSfjrhYlPhJjfwnix0/jcYhiAIRb8lX4E
         /Zmlf6+YSHyYHflKAlb3DIknP1GMQSSUzkhuXNyixr92oLaQ3grB9iz14PPzuzbjXcZI
         NMfA==
X-Forwarded-Encrypted: i=1; AJvYcCXR/eUo0twsVxkNptIPokfU/dIYacR8UbE/qqaxlBrFDeFWAoUTsmhvQLN2zc7QHhwQsWWfds0gCw==@kvack.org
X-Gm-Message-State: AOJu0YwTtCGd8zaxxj9x78Ar/3f3qBRe23Q2Mj2YY86xvD3Qg9Y9mxY3
	wwhy2OV+peOdZ4BauePlNC55N/7tHlmBkgDucvZog1Fa1WTOxVxQJpnCbxYe/wayLbT6RURYA95
	y2rzbfufkmooIL+3MIksx7W8WBOR5c91W+p92GFRJ
X-Gm-Gg: AeBDieshKoPqlX5K+78PIutTIBSygIWg86wSl0+e84UCqc1QQ9KWZ2mcgIL+/LEjxUE
	w1KB8u1NcI2wMdNMw44An/SVY5OzOLZWfoz1DL4XVNL/p5kfR+Q0yt7dDQVLQycJvM6mq2pZ66V
	cSQ/AOZ17cBdo2MqH0ALqSJQwDBMQJ9hxJs2CuN28x+4JTZD4/zHNDs1hyZ5dENcHPdhPyif5be
	ltYgtg5MYqxvobrZiH42PbY4Z3sU73t84yhya3Z7vMnMLQXVK4Hk6US4MLapN4OzUczNuh69Q2h
	oys9TNP3oCTlBFJZmKJMsZ3UWDb4QUfY/tbuUQ==
X-Received: by 2002:a05:622a:cb:b0:509:1d4b:f86f with SMTP id
 d75a77b69052e-50db3e1cb76mr314121cf.14.1775598670174; Tue, 07 Apr 2026
 14:51:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
 <20260326-gmem-inplace-conversion-v4-10-e202fe950ffd@google.com>
 <2r4mmfiuisw26qymahnbh2oxqkkrywqev477kc4rlkcyx7tels@c7ple7kdgpo3>
 <CAEvNRgFkusZeKxGctUpTTbYjdi7nZL1ZZar-gT7XRUOCZ2xtpw@mail.gmail.com>
 <CAEvNRgGm9icDK8sK5ZfqHEOEqSbvjwtihE4p9d3vpBq-NfVjmw@mail.gmail.com>
 <CAEvNRgEtigp7+PVDkyu_DH947CUqDt312d+P+hWjjd2fHONiag@mail.gmail.com> <yvfwexsub7nrogh67hzcsupbrkzer6a7kbeao5tlq4elrzc2iz@xrwdjd7p32pp>
In-Reply-To: <yvfwexsub7nrogh67hzcsupbrkzer6a7kbeao5tlq4elrzc2iz@xrwdjd7p32pp>
From: Vishal Annapurve <vannapurve@google.com>
Date: Tue, 7 Apr 2026 14:50:58 -0700
X-Gm-Features: AQROBzC6YaFafHUDv2MGa2x0Vz0Tn9NeKXIPzVzTFxz7s_zDJ7AzU9trGlNgYrA
Message-ID: <CAGtprH-kgRByFvvCYeWMXtsvpb6qpaWAo8k-3PEnioyPg-LEvA@mail.gmail.com>
Subject: Re: [PATCH RFC v4 10/44] KVM: guest_memfd: Add support for KVM_SET_MEMORY_ATTRIBUTES2
To: Michael Roth <michael.roth@amd.com>
Cc: Ackerley Tng <ackerleytng@google.com>, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, ira.weiny@intel.com, jmattson@google.com, 
	jthoughton@google.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 1ip684gc5u45d6pbhwf38d4656knqktd
X-Rspamd-Queue-Id: F3AD31C0008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775598671-727035
X-HE-Meta: U2FsdGVkX1+McyLA5CYe+yjXFOLXjfz7bmi52d8/StvRcMEjxpBU1YLsWKwltDpzHKGPqUF6DjVWWTnbzHymcukfbKi9LUeEkJ/JLOpdM7vl6J2AFJFgPGiE1Xo8H/G87Z6ac8es5BCyhtY5Fbur/GQsXK3kSKaE+1QlWWtrlYBKa9/etxa3CuofFdrZ1l80URUXoO7tIxcGK4NvosaZC9rhFQRgCBUKIyQkjZ+3Jq6u1L8B31MGkeu6zEdHaR0ZJbMPL4n5oApMyyUnvQDlf2tYqJanzadr19nGYuI9IAV68k72jZJDjkuvVCfFhtLdpU8QqZQGAMebeuAA7qVg07c93eXYdy1WBqzbBspWhrPmuvyzIqs9eEKhUHV/Lw9iFug5lVOy4/Y/7Eg4IlD1g4CU/ObuH+3Ts130fYH2FWKPEogam3vJGnJJnK2RdxeKTUsIczeiYOFagc+S3IWY+7W2Efpz7JUx3mFSl4XljjqxIS7l8qzf4R8TtEulX/8jCj3ZBnnGwn+dTPvcDB1TUlpy4I/H/sY7yWntQ1rNd8+O7lvQBv+B/dAbftXjqdIrjAt+8C+LfBgsDWVfIq2hPKhb1isVtoudSJTvZBIuNm0WIAYOh2Jo4gaRXSGwcZNWVdeq//odoezyAwg/WwlX0K3P7JEbQq04HuXzQRPrSSReKEB+pODk0uoxqA2T/YIW8wzmDoamaD4G9PiEYOO824tYFuCEOKyyvMCIgrQBq9petjCGC8xONUxhNs5KJ5HezyIse1uCTzs3BME5M37t60eVHeKh0CRpgxwnrtp3thrKvx5Yp51OGgUHM4cuEMqzMGQ4S7M6AWWrIqbKeoBYNG9GRVUZj0dJvgDp1l6XDTwdcofZUOaeTgu/r6U91LB7J0MQ9ADT1VcCD3WaueiWBfx8YwuE/TieF4jIBvDxb0AAviVeA3mlaPIVhbfNSmzLrUlOP60BckQkNk5Ywfw
 ZYyovWP1
 9HkK0Bmp1tdHgK3lrEW5JUO/Bag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 7, 2026 at 2:09=E2=80=AFPM Michael Roth <michael.roth@amd.com> =
wrote:
>
> > TLDR:
> >
> > + Think of populate ioctls not as KVM touching memory, but platform
> >   handling population.
> > + KVM code (kvm_gmem_populate) still doesn't touch memory contents
> > + post_populate is platform-specific code that handles loading into
> >   private destination memory just to support legacy non-in-place
> >   conversion.
> > + Don't complicate populate ioctls by doing conversion just to support
> >   legacy use-cases where platform-specific code has to do copying on
> >   the host.
>
> That's a good point: these are only considerations in the context of
> actually copying from src->dst, but with in-place conversion the
> primary/more-performant approach will be for userspace to initial
> directly. I.e. if we enforced that, then gmem could right ascertain that
> it isn't even writing to private pages via these hooks and any
> manipulation of that memory is purely on the part of the trusted entity
> handling initial encryption/etc.
>
> I understand that we decided to keep the option of allowing separate
> src/dst even with in-place conversion, but it doesn't seem worthwhile if
> that necessarily means we need to glue population+conversion together in
> 1 clumsy interface that needs to handle partial return/error responses to
> userspace (or potentially get stuck forever in the conversion path).

I think ARM needs userspace to specify separate source and destination
memory ranges for initial population as ARM doesn't support in-place
memory encryption. [1]

[1] https://lore.kernel.org/kvm/20260318155413.793430-25-steven.price@arm.c=
om/

>
> So I agree with Ackerley's proposal (which I guess is the same as what's
> in this series).
>
> However, 1 other alternative would be to do what was suggested on the
> call, but require userspace to subsequently handle the shared->private
> conversion. I think that would be workable too.

IIUC, Converting memory ranges to private after it essentially is
treated as private by the KVM CC backend will expose the
implementation to the same risk of userspace being able to access
private memory and compromise host safety which guest_memfd was
invented to address.

>
> One other benefit to Ackerley's/current approach however is that it allow=
s
> us to potentially keep hugepages intact in the populate path, since
> prep'ing/encrypting everything while it's in a shared state means gmem wi=
ll
> split the hugepage and all the firmware/RMP/etc. data structures will onl=
y
> be able to handle individual 4K pages. I still suspect doing things like
> encoding the initial 2MB OVMF image as a single hugepage might yield
> enough benefit to explore this (at some point). So there's some niceness
> in knowing that Ackerley's approach would allow for that eventually and
> not require a complete rethink on these same topics.
>
> Thanks,
>
> Mike
>
> >
> > >>>
> > >>> [...snip...]
> > >>>

