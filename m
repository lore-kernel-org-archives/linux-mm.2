Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D41A1CF45DB
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 01:44:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C8F16B0005; Mon, 12 Jan 2026 20:44:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29D706B0088; Mon, 12 Jan 2026 20:44:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A0896B008A; Mon, 12 Jan 2026 20:44:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 099956B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 20:44:51 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A509714107D
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 01:44:50 +0000 (UTC)
X-FDA: 84325246740.19.3808596
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf17.hostedemail.com (Postfix) with ESMTP id BB88240004
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 01:44:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YbHhg0Og;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768268688; a=rsa-sha256;
	cv=none;
	b=avugIu0H5kwlzRLoQxmlygYCIjJakQERQrjlLqiR+odDLyfvM3hKV0iM+wloy5rVsUW/0K
	QIKggiCU+ygjzi6VHbEBvRRxkHl7tR+EnRumZd0PRB2GRyRvN0aT4XH9LJ92x9YVX0Oyak
	loSpR6Yh1YJHkge8ccVzpWzKxFjxkLM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YbHhg0Og;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768268688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8QXuf4cwRpBOzqTZvP4qMKCqVPPc0MElEg+LdlADa3c=;
	b=6w88olrdl80JLC6rqkdsb5LWXLFsw2cjtJaw4UutaITEGrHd4UUW0/+uUcJhK9BcTr+PAN
	g2KaWo73i8As6cySnmFHKI5rIS3XKG4ryaq4vI34JYQdVuId7ITnYtqC86xXAVB/uo/+ph
	cRNnzmMl/t6M1dmDJhAEqmml+sK5ymA=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-42fbc305552so5187642f8f.0
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 17:44:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768268687; x=1768873487; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8QXuf4cwRpBOzqTZvP4qMKCqVPPc0MElEg+LdlADa3c=;
        b=YbHhg0OgYPVkmjSPzurCS9ljxZncAaJabNyB9/FKj7Sl9616asWbsRr3yQQGzA0d1b
         fBsTinSwBfQScla9Gn5corW87nUBgF06igOvvwi/ibaHv8y3IIvbZuVMsVnWY+BcpGGK
         Gno/khSXtOVVkqKA93XoXFc9H/YDkshLafPdcV/V4PUgYGYPM6j34hwVLkG8Jw5coNCS
         SjWJweduXkhahHaswkaML1lfp5FHZa0B83HUFlaYl3ca4TiB/vTeZD0uJGETNkz7k10T
         mz5TO2dheTYGF8RffvAG3gOxePP00sX4dAL6h+8a2cbSy3wE+3JlAXNWJxs1iN6nH5WG
         UfMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768268687; x=1768873487;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8QXuf4cwRpBOzqTZvP4qMKCqVPPc0MElEg+LdlADa3c=;
        b=mnLBdE3gUtr+ch0dP66hj7yoM/snyh2mclaazA4fTJHJ0evJuIn9eJxyMDNOP7JNAO
         NpZptpXrg7ZzxJP5BitTcvjTnjZAX2JgakHhJ74/3XNum5UFj81eQxHofPFrQP8TuE5l
         ZHVZG4FZBQmYam6vWr1/DI3/lJossv2eMBPF9wx7N86m68uSSnU7zrheyWzyxMQrufhb
         kKqbkgh2enudliPLo12sSyvEdIMDswV0Cn9QL1RRDmH7RLzdKLPrfeGs2mbxGLK73Em8
         PtWx5GvrcZV4ZXhw3np1VnRcygc3Ff7BUspRMlbXL0UgBoF/hWvm6Z0FI7k0kUZ1TQTx
         x9OQ==
X-Forwarded-Encrypted: i=1; AJvYcCWWSOLIsa9VKfj+1zIgjB1vJG/F+aKuukkztsWUYD27ZEH9gqH9vqWWqbHMmk+LqrywI0IPTWuzGQ==@kvack.org
X-Gm-Message-State: AOJu0YzsZ48cRiQrVnH67x6GtHQfZRon82jiplGe8+5Yttf39tOrNH0b
	wv6O2hYBG/jlrvck7SmdXRX5e3/2oqZF+4ZTW+U2uA2h041lF6ogV7NNn1cr58KHZi6ACHoKVqf
	T/t83Cc2ODXbPvW7uOQIF6D8oAEMzv3Q=
X-Gm-Gg: AY/fxX5ykj21B3R/3ocyEITecJF7CWPUm93x+kFjL8Qp7mjmNYA/hhjdbSY5cCCDLzh
	Nz8ASmMH3UVUjINhZojjB6y9zBxFZAPvoo6Ng7I7v/YEdJ5Ajd6X3MjIRo/MUMqJE1pNRKdhIoB
	WDdqo6hRncf/AK89XlzQEWG18ina8O/qeHU1QVCj9w3WlmcrEra8BbZsuoFIl3tG7741L6CF/eR
	CiFio7yj8+Q6k1X5/Ac1ScNOeFnXOVJIw2QJ/cX58Oi5ROQjvp4VN56Rzdroo6YCCT3hPPSpga0
	0tNwt8KjUDBc5t6QJmMzXbAZgD8hEg==
X-Google-Smtp-Source: AGHT+IEebGw6L+DCEowzC1fWnpJ9/6F/tHC8QlJPrsrlqIYFHxBkcEnJQunhABrVxJS4ojuoSVylquTQBlixDe2/UhU=
X-Received: by 2002:a05:6000:25c6:b0:42b:4267:83e3 with SMTP id
 ffacd0b85a97d-432c374f5femr24312893f8f.5.1768268687045; Mon, 12 Jan 2026
 17:44:47 -0800 (PST)
MIME-Version: 1.0
References: <cover.1768233085.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1768233085.git.m.wieczorretman@pm.me>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Tue, 13 Jan 2026 02:44:35 +0100
X-Gm-Features: AZwV_Qg49kJdgHS5b0feyJ3FQ4qpkZSxgMzwvg9-kXkrvqB0Op5YiaAIZPipNv4
Message-ID: <CA+fCnZf5NMa=_Aic_gVQ05rvAvYx0xUpbZ=hOg2=7A9=ZbPdFw@mail.gmail.com>
Subject: Re: [PATCH v8 00/14] kasan: x86: arm64: KASAN tag-based mode for x86
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: corbet@lwn.net, morbo@google.com, rppt@kernel.org, 
	lorenzo.stoakes@oracle.com, ubizjak@gmail.com, mingo@redhat.com, 
	vincenzo.frascino@arm.com, maciej.wieczor-retman@intel.com, maz@kernel.org, 
	catalin.marinas@arm.com, yeoreum.yun@arm.com, will@kernel.org, 
	jackmanb@google.com, samuel.holland@sifive.com, glider@google.com, 
	osandov@fb.com, nsc@kernel.org, luto@kernel.org, jpoimboe@kernel.org, 
	akpm@linux-foundation.org, Liam.Howlett@oracle.com, kees@kernel.org, 
	jan.kiszka@siemens.com, thomas.lendacky@amd.com, jeremy.linton@arm.com, 
	dvyukov@google.com, axelrasmussen@google.com, leitao@debian.org, 
	ryabinin.a.a@gmail.com, bigeasy@linutronix.de, peterz@infradead.org, 
	mark.rutland@arm.com, urezki@gmail.com, brgerst@gmail.com, hpa@zytor.com, 
	mhocko@suse.com, weixugc@google.com, kbingham@kernel.org, vbabka@suse.cz, 
	nathan@kernel.org, trintaeoitogc@gmail.com, samitolvanen@google.com, 
	tglx@kernel.org, thuth@redhat.com, surenb@google.com, 
	anshuman.khandual@arm.com, smostafa@google.com, yuanchu@google.com, 
	ada.coupriediaz@arm.com, dave.hansen@linux.intel.com, kas@kernel.org, 
	nick.desaulniers+lkml@gmail.com, david@kernel.org, bp@alien8.de, 
	ardb@kernel.org, justinstitt@google.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, kasan-dev@googlegroups.com, llvm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BB88240004
X-Stat-Signature: cubnymaiwzcsym534osym1j78papdsop
X-Rspam-User: 
X-HE-Tag: 1768268688-858665
X-HE-Meta: U2FsdGVkX18uZOd+qllPU8sKvo8ucJwflqeBYSQjgY5R64b+3XPxM7wKI+utsmOwIDZz4Yfc3LGdqj/OdyR780LRE4ROtWhtC8dBGI+YW6bU8oBvXB9N+n/umghtQxzddx2+x87YbuIyT2bWW+3Fy4RtHDv4LV5jgIT1juDKwf7SLhsV4LxzSdK3IPVIDFrJVabyZrnuNc0q/n7F7NenDeEBihE6e2XcxjY2hY8++fjuy3T0D6IeWvGa349KWkaQNdIw3VoF7JrHPzAgcxvp7qNN/oTFETbkmTGMFh0ZLxXv4lnyuy0TxytLXvOhguRFmLMWHqiKhvDtlVPCM4LM+CfU22zywU/djAFJ/Qbymny/cxixKG755SgdPjqglbicYLgcifJ4/glY2Ty2OAPAEaHA/JzSQwa5hY55IaehmpgsWGwpfHci+xdBFIttO/2hUIxg0Rg88mfEhYBzC0JJGwBEDAYpzqSImwJkaAHBtrMkqxTzDtv/q9aLKJX+ftVyK3KEwKDkDGLmRXCAUPTobYEjG/7ktNcQqtqtHs0lzVZ8oo0g3CvPE4RoKEX+CmUytmTdPuXqyGqCVQjqZpTuwoKmWtlz/pN1VEvVgXzaEriDTf2EtuK3ch762K2osr3L/5IhOGF0Ac8us8mOYq9/vziNm55/73P5DDLfs1QJ1lKTWqEpR/tC72yFcTCqzgxX+NU0tYc8AU6+/l8tSEPbp+TwM7JvouRJyvvL+mm4gqwMDzIwt6d2WrDtcoY+dkt62q2er46pJil8IoXCMMu8hrBR0r/UQ/cFp0usJaCffnrtsOacr3hNEXmYNGXRLBUnv2lg9hhqt9n5/sPx88AA9Mt7WTiFPPUpKxSmucFHO3d2bTEyZbh6gzHftznf3Jp1zPP1+I6P8/ySRbFLKAVQuQOESU5f816+jshljWM1C85mvNrbQO0LebAelL/SZ6dJhSR0QGmKG+fHOPxMy/O
 8WPgrtph
 /NE6kCRbcRQ1XJ4ei7AJrF1cvQzUjiFG2dAgHdzeoxcGbynfY8y/gJgVQaoLzLvGd77FU4U/MZ2yzO2BxX1sXgBIN2WRoj7jNB05LEveAmOsHfnBWtex0qh7+RQDuGymY3cDd2u0xhnSHrX6OJXOWXy/tpfQXTa5w5bFDXtTwfPST8G9YjJp5YHTBkkcvqHWweftTk/uFTzQm3soQAvJJ12QvvJNQwqT/OR2cbneS0v+bF+iDp5Z1oq+0iV/UD4fZjht55aE5rzknHKZplujbfLTlkaAU5wmhvWrATww3EE2lmceIULGEaeMk/HgNk+64siHjLGTYl7U3nqzn0S7eL74qR6mFRwWH+YegTt63iKniIgLGddnEFB+sLckXBZV7th2Sd6xrjffv3HmOLRy1zLGy1KOfEtpI6NlKoCRXmXV2MNo4GZ824cZPepaRPdzWqYhRGogDpGcyKxsFhlTjHWj50mav6wg3lFk1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 6:26=E2=80=AFPM Maciej Wieczor-Retman
<m.wieczorretman@pm.me> wrote:
>
> =3D=3D=3D=3D=3D=3D=3D Introduction
> The patchset aims to add a KASAN tag-based mode for the x86 architecture
> with the help of the new CPU feature called Linear Address Masking
> (LAM). Main improvement introduced by the series is 2x lower memory
> usage compared to KASAN's generic mode, the only currently available
> mode on x86. The tag based mode may also find errors that the generic
> mode couldn't because of differences in how these modes operate.
>
> =3D=3D=3D=3D=3D=3D=3D How does KASAN' tag-based mode work?
> When enabled, memory accesses and allocations are augmented by the
> compiler during kernel compilation. Instrumentation functions are added
> to each memory allocation and each pointer dereference.
>
> The allocation related functions generate a random tag and save it in
> two places: in shadow memory that maps to the allocated memory, and in
> the top bits of the pointer that points to the allocated memory. Storing
> the tag in the top of the pointer is possible because of Top-Byte Ignore
> (TBI) on arm64 architecture and LAM on x86.
>
> The access related functions are performing a comparison between the tag
> stored in the pointer and the one stored in shadow memory. If the tags
> don't match an out of bounds error must have occurred and so an error
> report is generated.
>
> The general idea for the tag-based mode is very well explained in the
> series with the original implementation [1].
>
> [1] https://lore.kernel.org/all/cover.1544099024.git.andreyknvl@google.co=
m/
>
> =3D=3D=3D=3D=3D=3D=3D Differences summary compared to the arm64 tag-based=
 mode
> - Tag width:
>         - Tag width influences the chance of a tag mismatch due to two
>           tags from different allocations having the same value. The
>           bigger the possible range of tag values the lower the chance
>           of that happening.
>         - Shortening the tag width from 8 bits to 4, while it can help
>           with memory usage, it also increases the chance of not
>           reporting an error. 4 bit tags have a ~7% chance of a tag
>           mismatch.
>
> - Address masking mechanism
>         - TBI in arm64 allows for storing metadata in the top 8 bits of
>           the virtual address.
>         - LAM in x86 allows storing tags in bits [62:57] of the pointer.
>           To maximize memory savings the tag width is reduced to bits
>           [60:57].
>
> - Inline mode mismatch reporting
>         - Arm64 inserts a BRK instruction to pass metadata about a tag
>           mismatch to the KASAN report.
>         - Right now on x86 the INT3 instruction is used for the same
>           purpose. The attempt to move it over to use UD1 is already
>           implemented and tested but relies on another series that needs
>           merging first. Therefore this patch will be posted separately
>           once the dependency is satisfied by being merged upstream.
>

Please also update the Software Tag-Based KASAN section in
Documentation/dev-tools/kasan.rst accordingly.

