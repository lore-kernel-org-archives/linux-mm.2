Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64027D6E2BF
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 17:49:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7E236B0096; Thu, 18 Dec 2025 12:49:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C48F56B0098; Thu, 18 Dec 2025 12:49:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4AB56B0099; Thu, 18 Dec 2025 12:49:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A25DE6B0096
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:49:01 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6B3A9C01D5
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:49:01 +0000 (UTC)
X-FDA: 84233327682.22.05525DA
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6BC971C0020
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:48:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dNDmyTxA;
	spf=pass (imf20.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766080139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CAT4NIB50wSSQJ2eRS7sx9I/iK0vGJNZ4n3UlMbS9UY=;
	b=MxzsYC9sDn+ti+D3Qo6TG8qIZ7oO6x/7VEm8cERf/N/sF/1+cp+h1tdnBo+msWSOq9jELz
	1NADw3K3rkocwpCaDExKbDWJERK0AwNO9PiUZFDE/TFwJqHQJN4b7aeoxRXJJG4wI5F5HE
	kzhmTZnt20OBvP224empX4S7FAhLj5Y=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dNDmyTxA;
	spf=pass (imf20.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766080139; a=rsa-sha256;
	cv=none;
	b=0EAklBkq4ccknK1uRl3b0Lw0Ve0qxuA5hBSdYpRR3lOigk51JZltcPVP0Oc8OeByptYErL
	d+JtRCtROv3UqQ6UerO8dtWJGnFS8vuf52Oo+lQMRrpeXL4Jpp230TW++/z8DtSU4rAOjY
	WimYZzbNxZWtgqnfnwU8zuCpahki/VE=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-64b7b737eddso701043a12.1
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:48:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766080138; x=1766684938; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CAT4NIB50wSSQJ2eRS7sx9I/iK0vGJNZ4n3UlMbS9UY=;
        b=dNDmyTxAuT/UGyDXQ2c3SeL6bQ4pKISZ/v/2MxasCPmuvEqP0ThOTyvR+HnpEVnVhW
         3uWCp1Dn3EazaUSqTkcy8cGAH24rlWk5Zjr0AhZquzoKtgYeiBc9IM1UlKZZ6mRW5m08
         SJIT/n8qdwLcw5riiwIeWLuHjgMMWXgCT5Y2AcW5UzBJ//mUJORcFOAy5uZNWyAkeHbY
         SVNGePJvGiegNurw/MWV9aOCXaWyGoLxSAkuvKeQTG3Tds5JaOAyeA0aB/KipyQLszV6
         AuI7TtxqbM6/U8OBr4ZAC5cEBB7xMBj/A9UR+otXLIU0ODn8OVHxVN3tvXknyRmQcOyf
         s3BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766080138; x=1766684938;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CAT4NIB50wSSQJ2eRS7sx9I/iK0vGJNZ4n3UlMbS9UY=;
        b=g5kgR8axCDRBDtGN/Tm68YmPW/hPiXQpqmkCu1NlhJeWpSJz28lMclxEy4mbKlU65I
         74DsIj9zfhDbNNbOqRISjCirGOgp1w3ich7Mf5F8sIHz6SFIEckzzrYQ1HhB+nncVAJE
         IDTZd8gIf8SSmmgZgPv+PjNcmpKllrRb2yBn0mcS9oGe9VGp0zLD8I18jB6GPAGqw3I0
         X88liQmKTdix1DNUuPPL/b626ZvW5AiEK2ifXhdVIXbcxyqnXBZQGUG1rCXSPmN5qiEN
         M+dVRGR3oDNr3CEugyYmqXSCD5x0pDQO7kjsPSOn6HBJKl1Mg2gXPgxDHbYuJXWOiZUM
         Ohvw==
X-Forwarded-Encrypted: i=1; AJvYcCWGO6Ey9z5UmvJKmHjz1JNur0bat3WobzwHC68yXqN3MX6VplUaM4dHk3T7rw1ngN0U/OVF66zm2A==@kvack.org
X-Gm-Message-State: AOJu0Yz4pXOa8eFQjl4tO90rejJe5w2NC15bTUbfkqYoKKgI5JYNFCEK
	I8DyO3mZ+y9eLnZfCdC+WWW0KQW3eyFzhxvK0TV+5LEWViaJTBTtNVxU
X-Gm-Gg: AY/fxX7mGREkr2KQLps8V/i9U6Rov6F0GchyHa0kuJ4xxqsB5YM97LsSNcJ1vYYGUaH
	xSa2Nul8EoQnmtegQCADZdyhvqlHpu7OhPN0LAbz8rKIW0m0XYpCQ4ad3ESV/36RfWgzrMq1AM6
	7H1Kvk1PJsda7yzNiQ4w5cjNr1u9oKa6WkLNEcSgra0kISdVKz5+xNoEEC1vImQWv5J51ykTu2t
	s2Wla7x+gvXyQFHec+M6vjLh8iRD4eVDFl0VDd6GRgTeFiRSLpWvUj60gjsORq24RrGfcj6Ako/
	VWVkJz5+/PvGwWhqRqRM3THRfvYH408jlxDu9QHZWbewakByCQ1C2PcW7lkuzTa8hpZqRw0yd0x
	mMAMKK1RhPzFHaZrZeBIayH8ui9DJdv6GAf7/o1HI4N3b6xBhkB8kfjRXEf8M7K4QRceE3QhsDs
	UQzSLFbzeWZlkwF99FatMAAzRnT8T8karxgl0O3WNHqLLtqKHShWTuzPM7jSSLj7E=
X-Google-Smtp-Source: AGHT+IEX3LAgYnT5Lo93smJLzWDPMc1uQ4Aj1gMjYO0ty7+7jdOdeZ5GXQKimSTh9jzRGuiit8vdow==
X-Received: by 2002:a05:600d:1b:b0:477:a219:cdb7 with SMTP id 5b1f17b1804b1-47a8fa81e14mr202186375e9.0.1766073295465;
        Thu, 18 Dec 2025 07:54:55 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be27b749esm48092275e9.14.2025.12.18.07.54.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 07:54:55 -0800 (PST)
Date: Thu, 18 Dec 2025 15:54:52 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Joel Fernandes
 <joel@joelfernandes.org>, "Paul E. McKenney" <paulmck@kernel.org>,
 linux-kernel@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>, Michael
 Ellerman <mpe@ellerman.id.au>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Sebastian Andrzej Siewior
 <bigeasy@linutronix.de>, Will Deacon <will@kernel.org>, Peter Zijlstra
 <peterz@infradead.org>, Alan Stern <stern@rowland.harvard.edu>, John Stultz
 <jstultz@google.com>, Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, Linus
 Torvalds <torvalds@linux-foundation.org>, Andrew Morton
 <akpm@linux-foundation.org>, Frederic Weisbecker <frederic@kernel.org>,
 Josh Triplett <josh@joshtriplett.org>, Uladzislau Rezki <urezki@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>, Lai Jiangshan
 <jiangshanlai@gmail.com>, Zqiang <qiang.zhang1211@gmail.com>, Ingo Molnar
 <mingo@redhat.com>, Waiman Long <longman@redhat.com>, Mark Rutland
 <mark.rutland@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Vlastimil
 Babka <vbabka@suse.cz>, maged.michael@gmail.com, Mateusz Guzik
 <mjguzik@gmail.com>, Jonas Oberhauser <jonas.oberhauser@huaweicloud.com>,
 rcu@vger.kernel.org, linux-mm@kvack.org, lkmm@lists.linux.dev, Gary Guo
 <gary@garyguo.net>, Nikita Popov <github@npopov.com>, llvm@lists.linux.dev
Subject: Re: [RFC PATCH v4 1/4] compiler.h: Introduce ptr_eq() to preserve
 address dependency
Message-ID: <20251218155452.6ae47481@pumpkin>
In-Reply-To: <cb55e583-395f-4b83-925f-c341c95903c1@efficios.com>
References: <20251218014531.3793471-1-mathieu.desnoyers@efficios.com>
	<20251218014531.3793471-2-mathieu.desnoyers@efficios.com>
	<20251218090313.33923750@pumpkin>
	<cb55e583-395f-4b83-925f-c341c95903c1@efficios.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Stat-Signature: qi81zeipdqq9mi94jy3781wjrfui1ee8
X-Rspam-User: 
X-Rspamd-Queue-Id: 6BC971C0020
X-HE-Tag: 1766080139-697337
X-HE-Meta: U2FsdGVkX19xoHTQlYaoX8bioRp4FVdkxSLI1XY7GF4M74xIjQ3GfrHxVE13nkqq2XN0eARASryfcm5jkC0M0FSJ5367VhsWltut3Y7AyCbzhJtPV4v40utqQpWTlenZ93PGWIo8AFNERFojhzru/zpyhgSfFFln9zjfahNb5Xb1FVnKUKKcC5kPhhbYNjf+M5XEVisH0decNpWrRpPlgGPi7MGIjhImozJlrO1xOBflPSajDAFKVTWwILyXMhDVLIwBkyfmnWuZ3yFd6QG5Hw7wBi19BSVMXyTdOZuyghd2rDpxuD5An3duwBcAv+kGlD0fjCk9NxC0ssBYvDlzUqd0uRaPfhykkcUXvEedOfiUfL7YAd6aSyuOjIP+sSA/Q0LugJOSPqkysWzpOHlcdyqzA5n8xIGQ9JIXqYayAoxXr+F4+RsXMG52FrlpBrmW77By50cPoZWBMei8A+FO7cHOGY3DoJPdTQ6vojLh6J0exqEC6PYWPxFcfPbZYuABgLchAW9WRJ/PqL7S1OG1O0W/O504EgvbBDXaWsDNdpxs7qurZwG8OMNLZ9f/AymJ91yAlAgNIyC/gFTE50unYqK+9MjQh9NewQtoWgZnmlhjWqAnQaP/00RmvXy0U+FF1/vndL9MgJHxyM3waMjxeLJ71QmsJ73QzTiG7rzw15BxCTjCuZFmgVYpwrObN7koxrZSVVFfKtoyUAjcopYXUIm3IacyktM6R3gCo5iN0PO2427k/FI4UnXfMuLKRKifp2qFPy9EHQWabCY+suprJJY0bZ+dHjVjT/bX4x0s2UnEEYhX59YI6xNesNyr5Xk2TOdHyuNaQ9AUhIuD/vE8xVqM4/31+hVWH3yiuSeVatuAxikuE8Itt4e2FMFo4WAILaaNVwT+Nb/pL8s65EZOqUedPvKdKS/tehwCNWh1znrM3aNzCrHvYDHBmL4fh88vCu8TBwsprQlp1XwLu8j
 1AKpAG2Q
 Z67KW5Z/dJZ9IxvS02LcdjUPWZNTPepD2kfpY8WWIubR350z0BAZLD/len21bPF8MrxF7Ee8fcU0FBOxkL18ZyR///gj3BS/eyJA/F55twbMHcG3j48Z81f2YC8cLDZtH0osOtD9DA/lJQbL34SFg6xRjLtbIuWiKOM+x7gNk6QW83RYnIAZLqB9eH3+AX2juiU69MWLtbcMmSG9ywa8NxGrF6PgufAAv3sbawDjrO0yxHZgyGrRdUQ/KFq4BCg2DIt29WPob6kvQTlOAzlIpkC1ZVySUbo4Z7Sv8dvultpXvX1oH2+tTN/k1fFNeLT+AGorUIRGRppGJ394Mdc0RPEanmOK2pUk5yTCfJYFYMCtzig3qyIUEYegH2RxP3zx0M/zO7DuOHh7z5DYvSbAbHq4OwKybG/7/h79Azbet9hmAQ4P/MOxgcx8MLoM1tnLQ0nDZRftPAUbnIg3GTpQ3abWODXAYOMeRypjx5gG2j6oIfMBT8KszA6/OiuOEhS5Jc5+UctKws7Q8oMkab8ZoMOd3SZyyHrgyBbEmQhvj/B00UY7beQrzYoXcqaa842lmSCzEgwEbLlhUmikCL1U93JM1t663cs+NUKe4j0pnf2HIlsgBb0Kj93DXGWgJf6VjWBuEXkDUHJOKnX1/HjMJz+V9NQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 18 Dec 2025 08:51:02 -0500
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> On 2025-12-18 04:03, David Laight wrote:
> [...]
> >> + *
> >> + * The compiler barrier() is ineffective at fixing this issue. It does
> >> + * not prevent the compiler CSE from losing the address dependency:
> >> + *
> >> + * int fct_2_volatile_barriers(void)
> >> + * {
> >> + *     int *a, *b;
> >> + *
> >> + *     do {
> >> + *         a = READ_ONCE(p);
> >> + *         asm volatile ("" : : : "memory");
> >> + *         b = READ_ONCE(p);
> >> + *     } while (a != b);
> >> + *     asm volatile ("" : : : "memory");  <-- barrier()
> >> + *     return *b;
> >> + * }
> >> + *
> >> + * With gcc 14.2 (arm64):
> >> + *
> >> + * fct_2_volatile_barriers:
> >> + *         adrp    x0, .LANCHOR0
> >> + *         add     x0, x0, :lo12:.LANCHOR0
> >> + * .L2:
> >> + *         ldr     x1, [x0]  <-- x1 populated by first load.
> >> + *         ldr     x2, [x0]
> >> + *         cmp     x1, x2
> >> + *         bne     .L2
> >> + *         ldr     w0, [x1]  <-- x1 is used for access which should depend on b.
> >> + *         ret
> >> + *
> >> + * On weakly-ordered architectures, this lets CPU speculation use the
> >> + * result from the first load to speculate "ldr w0, [x1]" before
> >> + * "ldr x2, [x0]".
> >> + * Based on the RCU documentation, the control dependency does not
> >> + * prevent the CPU from speculating loads.  
> > 
> > I'm not sure that example (of something that doesn't work) is really necessary.
> > The simple example of, given:
> > 	return a == b ? *a : 0;
> > the generated code might speculatively dereference 'b' (not a) before returning
> > zero when the pointers are different.  
> 
> In the past discussion that led to this new API, AFAIU, Linus made it
> clear that this counter example needs to be in a comment:

I might remember that...

But if you read the proposed comment it starts looking like an example.
It is also very long for the file it is in - even if clearly marked as why
the same effect can't be achieved with barrier().
Maybe the long gory comment belongs in the rst file?

I do wonder if some places need this:
#define OPTIMISER_HIDE_VAL(x) ({ auto _x = x; OPTIMISER_HIDE_VAR(_x); _x; })

Then you could do:
#define ptr_eq(x, y) (OPTIMISER_HIDE_VAL(x) == OPTIMISER_HIDE_VAL(y))
which includes the check that the pointers are the same type.

But it would be more generally useful for hiding constants from the optimiser.

	David

> 
> https://lore.kernel.org/lkml/CAHk-=wgBgh5U+dyNaN=+XCdcm2OmgSRbcH4Vbtk8i5ZDGwStSA@mail.gmail.com/
> 
> This counter-example is what convinced him that this addresses a real
> issue.
> 
> Thanks,
> 
> Mathieu
> 
> 


