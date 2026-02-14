Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BF3CEF584B
	for <linux-mm@archiver.kernel.org>; Sat, 14 Feb 2026 16:33:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7601B6B0005; Sat, 14 Feb 2026 11:33:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70CF76B0088; Sat, 14 Feb 2026 11:33:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60F0B6B008A; Sat, 14 Feb 2026 11:33:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4CC496B0005
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 11:33:17 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ECA641B48E3
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 16:33:16 +0000 (UTC)
X-FDA: 84443607192.28.05FA111
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf11.hostedemail.com (Postfix) with ESMTP id C961540002
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 16:33:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=iEVGLAW3;
	spf=pass (imf11.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.51 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771086795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kA6VAxOWDauWFxEq78jrwhCl0SItPqg6zULREpi5MKE=;
	b=lM+sthpcSca69+58D4zUfgXUHbe9ukqhq5niBwXEeHc0Bo/5/qn2HvR0tfrBtVdmhY7JoI
	Ia4fm3CnQhWxziwRjU0pf2qgQj7ZzwQClpc/tV6/G9xXmnmezYuKZkBhYe9+Y6YWcBUqD6
	x2YOw5Dank9Q6QNIFADwStwdOi+0QJ8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=iEVGLAW3;
	spf=pass (imf11.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.51 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771086795; a=rsa-sha256;
	cv=none;
	b=g7XY1rNFCMcl07ny36RKxxtWUqMP+kwxR9eaCuqe9UI2/ScvX0jmvX02Tjl9CB/d8FnaU6
	BDfUnzcYJP/oOSNJMoX8KgyMpD8Vee6QItflO2Wo2yExWXrm1fRSe21irErn6Lp2p60dyi
	FbyyA2BzIfYlPsUvnBTM+uRBnp2vHwE=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b8849dc12f6so239040566b.1
        for <linux-mm@kvack.org>; Sat, 14 Feb 2026 08:33:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1771086793; x=1771691593; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kA6VAxOWDauWFxEq78jrwhCl0SItPqg6zULREpi5MKE=;
        b=iEVGLAW3dTQykXt6rriA5mCoipOhEDreB88HlVT7dd6Op4fqlohP7gko81HFpwHsZx
         LLNII5OH6nw999iHyANaC5G4Qg0L7jAB7n4x5i3l8u+0DVjCYmZvDFu2ZqfZFgfVYHiB
         M73ntkc335sp1J6uPbJKKKKVVAfp87fL+zDBM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771086793; x=1771691593;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kA6VAxOWDauWFxEq78jrwhCl0SItPqg6zULREpi5MKE=;
        b=kx6tSGj3hsi6TCb776+ZLF0C2VUO9n7Mv2uELsH5pSqDInVw1ztl5zHmcrWD1uaNbN
         /UAn8sGEtYbKRfS/DeSpuPgPTXsS2jUbKBgS2NP9yvoyB4kGUNpg15Td0eYxvuSW/ZPY
         bzwoLFvRIaj8Uv826jhP2oNwHH+VyXUZWcKXq4uHxsEdsf63lPjBXhaCwa1n6paOu+a4
         CjDLyQ5DSYER+AbhyY2bLfqnUmbDd/KYstzWRF1Ol8lW4X+3bpaKlL+tIsczBgaH8f64
         jcLYavLVBMzef4xxQYwxib0dYniOd6veTirLgYH7t6/mRQnsGk4JKgZdzt0AMk0lFk/m
         Ou8g==
X-Forwarded-Encrypted: i=1; AJvYcCWPosTxS4dE6LNqNDfkRqQ0bpT3Z4Hnox0ro1ptyRKlD95QFErz/lmKnMtVaJ2pgVfN2Shyc/qODA==@kvack.org
X-Gm-Message-State: AOJu0YyFIHPlo0dyM00RLefbQRe2cFPFAkqwCpxzgnwCqvjSqQ4kHDw2
	Y5mCIM+bdsWCGLfZ2NS42RBonfcwRh3jNmJlxfWp0cu7FxcdFlc6AFFn76WmGGxJISU16I2+pfM
	hLsDD81Y=
X-Gm-Gg: AZuq6aKPKio9j5MHzAFRjmbUtqgjTJTtq+bvDof7+5JCt4TzcFTuTGB98t3pM7r4deY
	OuevYW2WwHC9I1bb1uF6ijXx5LU5EpT9IflLFZlCU29YvJm/yJ7IXArM99xBQeb0JfAV3DITOq6
	Dh5QvjoWFxQg3NRGZHQfZynEJry168CMc51oXTMl/J+1fb3bzCtJxgLet10YeiXMYf2IJ4m2LBk
	d3aG3oAJQs3bJKJ2CA7iSW70Iwv4Bj1i01IQvv1ndovT+0nUZmqtc/VeJ0fUlwhwUI2LFI8W3NI
	cQeUbj4SuDbaPxNpv5Vq1GLv0g9tEYWPROJCWLKJTS9sB6KysGINBpQoqogPn1GoeUIJtKWz27d
	laG2Y07PveyqA0YCXYY7ePDl1UN5wr4Stso/zOcQ74EtrtoZT3KmgxG7oKw5U5C2+ovU+nJSeg1
	XJOfRmSfJ4FXwS8TqG9W2kr2OpZ0XDZq7yRbfcuLBUhT1GHTBoqOUkuwn0xiZd+JymhFZxV8Pg
X-Received: by 2002:a17:907:3f2a:b0:b8e:3877:d1cb with SMTP id a640c23a62f3a-b8fb477843dmr285367766b.62.1771086792601;
        Sat, 14 Feb 2026 08:33:12 -0800 (PST)
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com. [209.85.218.45])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8fc766579asm78628666b.54.2026.02.14.08.33.12
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Feb 2026 08:33:12 -0800 (PST)
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b884ad1026cso250213166b.2
        for <linux-mm@kvack.org>; Sat, 14 Feb 2026 08:33:12 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXQ7XEfT9kcQISmlyZXHioHVk7ZPY5UtGHxnVXIPR2FoXS1qk5E7b+nll3yJeBzQ5KmAjyiXeflmw==@kvack.org
X-Received: by 2002:a17:907:1ca2:b0:b8a:fcc5:62a6 with SMTP id
 a640c23a62f3a-b8fb477131bmr288214366b.61.1771086791765; Sat, 14 Feb 2026
 08:33:11 -0800 (PST)
MIME-Version: 1.0
References: <d762c46b-36f0-471a-b5b4-23c8cf5628ae@suse.cz> <aZAWGwZP_Z75YHKt@casper.infradead.org>
In-Reply-To: <aZAWGwZP_Z75YHKt@casper.infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 14 Feb 2026 08:32:55 -0800
X-Gmail-Original-Message-ID: <CAHk-=wg9F6iW8wuH8bCDFRJyFCdtin5bXJW5v4WjNyynD7eoCA@mail.gmail.com>
X-Gm-Features: AaiRm52CYyrFYJUGAg2XKhRJfejVrJvd1HdsP6DMfwUot2K5zPVK4w-ddgH79Uw
Message-ID: <CAHk-=wg9F6iW8wuH8bCDFRJyFCdtin5bXJW5v4WjNyynD7eoCA@mail.gmail.com>
Subject: Re: [RFC] making nested spin_trylock() work on UP?
To: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Will Deacon <will@kernel.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	LKML <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	Waiman Long <longman@redhat.com>, Mel Gorman <mgorman@techsingularity.net>, 
	Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C961540002
X-Stat-Signature: 79secbb81e7k61bpdxgzapi4k4pqwg8j
X-Rspam-User: 
X-HE-Tag: 1771086794-956068
X-HE-Meta: U2FsdGVkX1/5Gv/Dc/EOiTKJFD87DmY1F48iIYb0BQvqwm5DDpdcdThKkVvVGtSXfvnUHvk8q3UEnazHkxRemQRlvaNtkGpSIcNvJdcJfL28/2onAUy0UJKltzPWpFecEIlgAPRxGebZxNyZdCOo3AWW7hg3Cjt4HLvIANfTsbtoHS6RrlPt1czhiMpgxZu2S2Sp45/2263Sj9foDeMi4RVtfIzS5vFOV3QKiG5XsIJzYQ348pmzJExZc2EsrxPos8VVmK3n71lpZxad9CeRZfiOBxp57u07Ix9MUoB8voVmtawlyDo920OILA+4kkwXWiA+QkMqx6mzybsIMS6q6Vbyw42YzUL0AfsviM0pikJjAXRgryyofvzQayMMTd1yWae8Uaa8Zz4RHWGYScjDHeHrRsrkKbUcT0rXh/EDKfZzmnE0/zZFeUJqr3ibj2ePfxxlSoNzZGg4DV6xWjNkTF4SDi85fQVOdXHK6gS5c63OCXIi5QtO1ibfzV6kKqW5OIGtVah1dg3Has18yDbT7VVSQPUllPp9lbkfMavDDkgP7yj0J/xdtAXz5a3Zs58K5VHp6CNu8Vui0wjwS+WAu0TDeobrqKU9OrBKq5CERFc38V8QjKGjGkP/FCS4Qn9h0LygaDgHcOI+JcSR2TqgKvCx8fKvv4OigsfTqGEn+OPI6XW29Uc9SHJAKqyjHIom0WYQHRalPmNnNOukvIhU/OC3FxdJnoLstcUcOx4clCld56cyDhuBlQRNHEr+HrDkg3JGZ+OWSoJIkky1HoMxqIT9lfYop2Nsx+/X92dN3hBcPq5oCZMxsx/1h+mQu94xLFcK2GRlu7aL5cN6yOvNcgnFek5defbgup1OMK4yk/oSCsd5S3eWOf9VfMRWKTDMgYx2mrtWL2x0ksUekaqxuEMUerKU0nBKbln3oVoZjaLpFozSbnqP0gLCESKG2nO+BHQGJiUNbXb1JavKo3S
 OvVAwiG3
 QtUiPljK8y+Px2Z3rwAze4Yd1m3Nnml1ZOA9U1AcvmJq2DiYwjO5fogjlkJ9hhePYSHaXrvTgJv7DD5J3gZ5FW+2gKm9AWNJ1cjRFIwyaqlI1aYjBZHj8dhjzRK1GL7fitMwrtKJlMxDRM9d/wrByjVFhHY2pzpkpemT1eGzR9GmMrnkdYKE1pEvLyrHu+AX5llQwxezKePwmuVlNHfid1OLnWq8ANb4xmg9vTSiozP549MpbfyFrNzSKgOvfLRAlS2XltQfn432IkxrM8UVE8h+I4YHXcHiFiJt5maUKTKgGvDFmgsFMSCpfC/KpTAU1RQJuXSHajqMW4Irsv7q5W91KLOqPR8EVvLxncXEaEWDwiAA7gjJ4NRfVbGBrmKBs6F+p8HW6eh4cOMI5qT8BECEZHO+vD/BiHzImN2504yH8dPGenJEGy0tZfPhGZz9lZILlF8MflzoGbFJpMxgeRyj43rMXjsXesKCj2lkYlzvzgncsDSzuTUHNPKExLxdOVkaWG85WHWT+KZLtRa6PST31D5n1/W2f9fUjy8gB4TlswD1Tk58HDZfVy7mgzMibQIrgyB+VIkoG8wbUPqD9buqt2qH5nRs8F/biG/xQ0z4I8ovosJBeVLx+oYgWz1yYFmC9baWVu+HTfai83dbxKiqp/FjXF8F3g/jmjfhxchv5kv/FpwDe3Gg7td9XqMqMyPHHmXozjCYQW/wTwiH18ooKiO0Vxaawh032
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 13 Feb 2026 at 22:29, Matthew Wilcox <willy@infradead.org> wrote:
>
> What if we use an atomic_t on UP to simulate there being a spinlock,
> but only for pcp?

Yes. Please just wrap this - very unusual - use case with a special
wrapper that can then be entirely different for UP and SMP, and use
something like the suggested "pcp_lock" that becomes a spinlock on
smp, and just a tracking variable on UP.

And I don't think it needs to even be marked as 'atomic_t' on UP - the
value is going to be idempotent even when modified from interrupts
(because it will just be modified back), so no need for any special
logic, I think. The generic 'atomic_t' ops on UP disable interrupts,
which is horrendous.

Changing spinlocks globally on UP to be something they haven't been
before does not sound like a good idea, particularly since no actual
developer uses UP any more (and  honestly, UP is dead outside of very
low-end platforms or legacy like 68k).

            Linus

