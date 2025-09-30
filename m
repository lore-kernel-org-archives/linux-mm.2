Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1511BCAC5B8
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 23:48:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F2288E0005; Tue, 30 Sep 2025 19:48:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17B808E0002; Tue, 30 Sep 2025 19:48:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 043758E0005; Tue, 30 Sep 2025 19:48:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E11438E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 19:48:48 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 93BDEBBF68
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 23:48:48 +0000 (UTC)
X-FDA: 83947559136.28.2A72E75
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9EFAF4000B
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 23:48:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=EYzSfdQd;
	spf=pass (imf12.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759276126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4bm7dBKTe7VHUpax5O4A5sblWjBcLkrJbyIa/W7uP1A=;
	b=OBZ/6tFNX5Y1MHmnQSveGnVw0PEwP6ngxezD7/jl1+ydqyhWCmuqxjXW7vzPnwq8y7mk9e
	gS2pe/Qntnkx7+K/UAAYrl14RM+Jj/il7u/bR/t81sjKWm/KNbVSmJ2GM4J+ShFTUn4eL2
	JhyBbJlE3bCaH5CL27HlrpXy3vIpZ5Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759276126; a=rsa-sha256;
	cv=none;
	b=Y2S2+BZIoRMEynSMovLdFgErWdu8FLtnOYiPFyORaACMeRP1XjAbsTzAGLPbL+B/f9Cjow
	bVAUzlixRrC/UDehxI+gsNc5Q4IeWk/ctclHT3m/KYQ9733QF+P0umoY16rG+lnLfbMPMM
	OJ8Raq4AS2I3VmtP7vbt/wNCCXdNVNw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=EYzSfdQd;
	spf=pass (imf12.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b57de3f63c8so3967210a12.3
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 16:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1759276125; x=1759880925; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4bm7dBKTe7VHUpax5O4A5sblWjBcLkrJbyIa/W7uP1A=;
        b=EYzSfdQd5YYW8Q4puIwdBfMktQ+A2EhPHmLHu/l/kOjmaCYMxrroqt6jCW2M2oHIL0
         rw5EZ5GaCtGTp/Btxdmahtzp26gqYNlH54ix8+3/2J+2wo52hJ66bJBlLXQJa5p/RznG
         0shQvdj4TWztsPwv7uobj7AD77masYqesdu788eyHnaJ+R4V6RdE21Q97lTAaXN4tnA0
         x1l3uFS6FtlINCp+zvU9uzgDBXH0Hld+rBLmtYQbVoJvkPG/las2JOZpGpJhmLsbDOB9
         PZPXx1WA1IfNSu6CHjoc1QIsvpx+ITqKhg9ZJPJZn6SiH1ETuvS3ooXOpbkRMXnuEzx3
         i31Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759276125; x=1759880925;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4bm7dBKTe7VHUpax5O4A5sblWjBcLkrJbyIa/W7uP1A=;
        b=H/2HIbjrd34jGUTIpkmoRY1xGPec1MVN8V32jkm0hVPK9Ct33XsbpqtvEJBnl0W0e6
         QRLWvPM0WdZSspLT0PcdHVpPb1CovlI0jNwXNznTXaqhuiTOzL8tfEfLDAaNSjrYSs9P
         ZVZxwLU2rLtmOGJtzBF9EY2dIeZJs8YuZa+5wfBzHJsvsHrwqXejkPqFFlX5qjOJWxdO
         GelTBpCywQutDoCyblZKSq4pl77RLmk3FziDar0rEX+IxmHFgGg4GONIYKEujwSvlVdC
         XWCmmx+3fn1Jp5r8eixkRqxi73NPIBbor/b52Bqgn9kvZSfXy0egsAW9SNRjnzGv5aol
         daRw==
X-Forwarded-Encrypted: i=1; AJvYcCX1cVuGMkHeRNwWnEFQn44TTpHEuUL+MVd7DaY4QnEzKZnIFYBK/1e2TnnXLHT06/vefJ5ZSAk0+Q==@kvack.org
X-Gm-Message-State: AOJu0YyEaCXtGq8wKmRwNk7ovgfJogUFk/wnjH+plAkUuXsr/WRKqkj6
	QAszDOhQY56EzXGd8zserpdYlj+6tXYTLf+IuVAfee6le0XFL9YMhl5HznFeF532SaQ=
X-Gm-Gg: ASbGncttWXFKLfPLNEwZ6QlIKJN6vZs9Ob5mayr6aqk4O/IZPJUvUeriZz1dXlZTgz+
	ndaCsaTHBjTUQV6rchgT2lJ4u75Zbianpi6t/DvyTfyZbXuhPyZblLv9/3lN9JZg6RbDSxD5TGc
	xpLGxWVZC9Gt4X7WKo+xYqg0ETjn3IaeRjSZe8t/H0Zimvd0Ju2jIomlYc5gJN/WPXc1q1qbUqu
	OXDd5NZXx6u0PYb26p5/JyRExwrce/GPHVV0B1kAkT6LMVLiWfOr1Dh8CC90zkRRi48J+cKPA48
	kI/57byj/ou42Z9mk9fhrqnRtaEkAXgQvDN3iQjZkThIzMWw48K5xQwkuWxK8pgLFvmeLVI0JBx
	uAxe5ByWeKHBQ9vjWO+9tngPyxUSYfBR6Gc6NwLL+vpEuUbAQL47dlNyA
X-Google-Smtp-Source: AGHT+IHuRRsekWNjgE7yCPLG9pq3eS/GOyyUhj/f2Q9rAEjbYAirvs/e72q2qhgNkEK8PrNvRevQ9g==
X-Received: by 2002:a17:903:3d06:b0:27e:ea82:5ce8 with SMTP id d9443c01a7336-28e7f291db3mr15309515ad.14.1759276125338;
        Tue, 30 Sep 2025 16:48:45 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed6882133sm171972415ad.89.2025.09.30.16.48.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Sep 2025 16:48:44 -0700 (PDT)
Date: Tue, 30 Sep 2025 16:48:41 -0700
From: Deepak Gupta <debug@rivosinc.com>
To: Florian Weimer <fweimer@redhat.com>
Cc: Charles Mirabile <cmirabil@redhat.com>, pjw@kernel.org,
	Liam.Howlett@oracle.com, a.hindborg@kernel.org,
	akpm@linux-foundation.org, alex.gaynor@gmail.com,
	alexghiti@rivosinc.com, aliceryhl@google.com,
	alistair.francis@wdc.com, andybnac@gmail.com, aou@eecs.berkeley.edu,
	arnd@arndb.de, atishp@rivosinc.com, bjorn3_gh@protonmail.com,
	boqun.feng@gmail.com, bp@alien8.de, brauner@kernel.org,
	broonie@kernel.org, charlie@rivosinc.com, cleger@rivosinc.com,
	conor+dt@kernel.org, conor@kernel.org, corbet@lwn.net,
	dave.hansen@linux.intel.com, david@redhat.com,
	devicetree@vger.kernel.org, ebiederm@xmission.com,
	evan@rivosinc.com, gary@garyguo.net, hpa@zytor.com,
	jannh@google.com, jim.shu@sifive.com, kees@kernel.org,
	kito.cheng@sifive.com, krzk+dt@kernel.org,
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org, lorenzo.stoakes@oracle.com,
	lossin@kernel.org, mingo@redhat.com, ojeda@kernel.org,
	oleg@redhat.com, palmer@dabbelt.com, paul.walmsley@sifive.com,
	peterz@infradead.org, richard.henderson@linaro.org,
	rick.p.edgecombe@intel.com, robh@kernel.org,
	rust-for-linux@vger.kernel.org, samitolvanen@google.com,
	shuah@kernel.org, tglx@linutronix.de, tmgross@umich.edu,
	vbabka@suse.cz, x86@kernel.org, zong.li@sifive.com
Subject: Re: [PATCH v19 00/27] riscv control-flow integrity for usermode
Message-ID: <aNxsWYYnj22G5xuX@debug.ba.rivosinc.com>
References: <f953ee7b-91b3-f6f5-6955-b4a138f16dbc@kernel.org>
 <20250926192919.349578-1-cmirabil@redhat.com>
 <aNbwNN_st4bxwdwx@debug.ba.rivosinc.com>
 <CABe3_aE4+06Um2x3e1D=M6Z1uX4wX8OjdcT48FueXRp+=KD=-w@mail.gmail.com>
 <aNcAela5tln5KTUI@debug.ba.rivosinc.com>
 <lhu3484i9en.fsf@oldenburg.str.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <lhu3484i9en.fsf@oldenburg.str.redhat.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9EFAF4000B
X-Stat-Signature: 8xz4hbkwxyg1e7gipstre7wuba6qngai
X-Rspam-User: 
X-HE-Tag: 1759276126-134630
X-HE-Meta: U2FsdGVkX1+77YatgGf6aKHSOCIR3BtHQQe19s8tda9xUUHEwbHtcA6K/XvWI4GlU4OhUuFPc9vLF0ZRiLiH/5Ja58gjhM2ctkj4UE0cOXUIZpzQ7s+S4DWKQhGyqIllMS21L8GOYmxpuCgCTBAxT4qQJeUyXKohl2XsoG7XMxHH9B7GfDdgN3odSh9+B/2eUCGqtd4UIWcXv7Sq1bMOTe3YPDEUTUIRygurn1UED+gTXfHBq/qVeyg/Hmz7Pez1qZ5kC0gRNsa06yd9+2GmKFfKlEQjUZTz/IG/Y9iUaiQ8g77/JP1I43ZY8gUTlAoJWRujhnGHkEyFlMS6ktMcUEDU5Gk7P3ZsxOp6xfSdEfQiY9PLYrhGo43YyGVUEJ8AzG+sdq2y+LUmXlzPl3uQQFO6xhOEMNAaRJMdoE9WMlhnykx4ctjQIS+4lIIzAVQvyLIMm+4N+3Gh96/d2QAjT6z6v0sor2XzB6H4Js05sVy3Nf47mkGknEgaWuslmb3t9ZNqkYh8rTeyEgOzAWgpJc4BtRRtJVVX4gh8GA2gj3VtnwKdoqsP+ejhlRJXcdIXOEJUZV/IrKpp2Ga1uTyje/RiNyJ0Ql6ZHNCcx7I1PW8NYQYRGlWJIObFBBIk6qudJC77Xx3mYkEKZH1gP6sSA6cFW+EeHCtMbWfdA7iOne9RERzXn0lenMq+dFN9ZTnvQljpxVQloyjoiEmq1jVRzNbgZtVlL0LBgzjBjAT7hur8lkVypDVeppiObs0qaGNPBGQtVdmALy0kx6Z9fMlwoxFU813dNT5CsK2czODpmYd7fq+Jvkwcl5GkH/vSp5sqQ8MetT9UvbxxZwSLb3K8Pl4YSKG5CJtTze18ydAH5m+V+nLLQNquIUDG3HEzVKIkcu6U5zGwjx+9g0/noaV9dt9Y1dDSOELt4/XrF/g9ub6UWtsUmSaeEGmgVSeFBsJokUDcicb/GTCIlwUmBCW
 ClV9va+a
 FbFKduGUofhjpACsyIuzci4jS/gkjwsf+MrmRYB42lK328jTC8/ieGitXdwSSIAZYAOHIw8UCumXapSK28PxtRfoFM+crMxRLJ91hJMGIw/Ih99bFh/i1335yUT0P3spGMuooRfujtlcFxh1ckbt0bO3rmexK2I/hU3wCF9To3i5KMUUiaTx3Bv/fbsMV6zbMyRZvePv8St65lMqy9vXTr9GPxzSEpt0YUTw4RiY7+sUuXNPGgNGaQRTGRDK+rVsgRlg2yWETzREmynz6IRBk9x/jByGvKg0AaILkHHVKJlAUAm8kYiFk5pn0ksbwxalTQsNk6VahegtFmk0DcLJtH/7UBaR6+vECJDpYZ+Cu/a2O8AnWpvEp/0H2BJ3qNzqtBDNsvOwSRVB4j/U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 30, 2025 at 11:20:32AM +0200, Florian Weimer wrote:
>* Deepak Gupta:
>
>> In case of shadow stack, it similar situation. If enabled compiler
>> decides to insert sspush and sspopchk. They necessarily won't be
>> prologue or epilogue but somewhere in function body as deemed fit by
>> compiler, thus increasing the complexity of runtime patching.
>>
>> More so, here are wishing for kernel to do this patching for usermode
>> vDSO when there is no guarantee of such of rest of usermode (which if
>> was compiled with shadow stack would have faulted before vDSO's
>> sspush/sspopchk if ran on pre-zimop hardware)
>
>I think this capability is desirable so that you can use a distribution
>kernel during CFI userspace bringup.

I didn't get it, can you elaborate more.

Why having kernel carry two vDSO (one with shadow stack and one without) would
be required to for CFI userspace bringup?

If Distro is compiling for RVA23 CONFIG_RISCV_USERCFI has to be selected yes,
kernel can have vDSO with shadow stack. Distro can light this option only when
its compiling entire distro for RVA23.

If distro is not compiling for RVA23, then anyways CONFIG_RISCV_USERCFI is by
default "N". This would simply build vDSO without shadow stack.

>
>Thanks,
>Florian
>

