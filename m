Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1F97CD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 15:54:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DAE66B0093; Fri,  5 Jun 2026 11:54:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B2636B0096; Fri,  5 Jun 2026 11:54:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EF716B0098; Fri,  5 Jun 2026 11:54:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1E7936B0093
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:54:31 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E18B9C0C66
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:54:30 +0000 (UTC)
X-FDA: 84846306300.08.FCB6AF2
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf31.hostedemail.com (Postfix) with ESMTP id 036192000F
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:54:27 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=SINscNok;
	spf=pass (imf31.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.43 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780674868;
	b=uEapzP+2l5PpsRvmmQwR6XQ4U4g/IR2ABTVGjzZxTvVYU+MevNGB8ru1U5+xRdIXERhzTf
	a0qt13gDR+aT4DLa8EN4NutThXFMPGXdJjszegR0vCUWDXD9Y0XUydUSh4MIzrU0XhAgs5
	/x8Uex1xKskHonnXfhWcoyL9xruY9a4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=SINscNok;
	spf=pass (imf31.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.43 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780674868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1hPSWEkREGIx4yoYWkytVFmLCkNUDGfpLW+35vC71FY=;
	b=mttQhRzEHaym4lm33BAy+uic6Ga2GlCV9/2TJgaS8ASwmSKMpyGYyZPJ9kgd5FWNfbtwyH
	ydc/DYYOUKxJ2kzUWQHCV2mVyEUz3K2+pNQmRFw+p1Nmobd9VnMA8ffywcjC+xQiAO8C8G
	uwcrbjEh0NjqtQXvGlTS8iLHEb940ok=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6914a658115so58003a12.0
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 08:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780674866; x=1781279666; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1hPSWEkREGIx4yoYWkytVFmLCkNUDGfpLW+35vC71FY=;
        b=SINscNokwFFAeQycDM6VXqp+0qhS6DtYMS8kduzWQcStpZMXrAAK294RAETT5wrmHR
         Xgje2vogWgZmiYgVeSwtnPD/Hze9GrHLojsQy707+Tc27DxW/VZIxPy5aeV22Wv57Yl1
         efGyUbFtIu+2ZxaDwu2Ovv5kJpY5jr+uZ/Ni8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780674866; x=1781279666;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1hPSWEkREGIx4yoYWkytVFmLCkNUDGfpLW+35vC71FY=;
        b=ZAX757ERiYbIq6OuhZJg7rF0oV8u6cHsiB1dC4r70GHdJ93Efopg0XzmJX27OoRc/K
         cz5XsCsk7QinE1PQAFm4ZSQ643KHXXc8E20VVnqAReBhBWeJSdigsK6c6zIfeH0eXcAx
         9KmYwX5/UfkBUpw9Uv8bfNgMMqE984JnnaR/+BrolnqEutYt/GKH6nvG8G0cbanx9O/g
         ClhEtLO4xNycNfdFsxMmpc1OvXMGHMu/QVcKVQeBZJ7ye2NB6BM35coNMLZMwEQuMjAY
         PF/8rNIPVASQysB39E92bMGz5cIRPuQqtpQ/3GUSRPNSACy+EmABIbloNLvUggPmW63M
         zqTA==
X-Forwarded-Encrypted: i=1; AFNElJ874oM0aiExwrthEpVRFuJjpC9Mxwq9pkFhfrBNrQkVT+Tq4E5NnNudw7NHYxNeCxukU17a5XUCKQ==@kvack.org
X-Gm-Message-State: AOJu0YzNlTmT7rMOvVuymSNeeQSScctiPKmqfJeFO/z6gQ3A+V3U/yBX
	iv1GuL4GnRr5Wk1MfVYh6nlBYL4LtH8lOMsjzEox+PNqZ/Rj20fj20PMVJKzoNgjpv6o/1737/3
	kRVfujNKXCA==
X-Gm-Gg: Acq92OHNDCuER14YHud2H1Q+RCQWqjqwnnM0LK7D7VcJhRsR9gAYy64wwo2PstKq2cl
	bvQt9MmXOc9SNq8R7ycW/PJVD3ZSjV+G97asJBMLFKsdsSfoM7x0TqUBGGR7Kr4IlQ5v1V7yHRy
	StAnipLs4jYx+mJS57zsncliB9xtV/xYEwGPfVW+VbmOPaS3tr/rhl9Ht8zhp9jnkldk7rXILLi
	x/5I5rKttqFaNdXhDNjKeOkmGyZKD9rSrwJLCJeYTKuB+kXIYInftc4jQYvJFasoCAxyfSjGAVX
	U+roKxR9dKz7w7CN1GXoKWdOLfAdu7pbySzUJPVoRVcLV+Ae76V0q49bWVKQAAOOyebgO0VsHCE
	eVDf4wMvt9agw+ZXaRjfp0xNkLyqLy4zMgfILuqxJhkswrMgLp3ldeClFTEIzfoYfovNfAs2RLA
	YjoHsVMptk/ytQpA06RUzmwq9TJ0A31FeocLWrzljIsm0y+Cmp2y271iA8O4m+YWC2Qa2whQW11
	V7LV/QTNqo=
X-Received: by 2002:a05:6402:268f:b0:68e:4c0:f599 with SMTP id 4fb4d7f45d1cf-68fa4c16b80mr2156480a12.5.1780674866047;
        Fri, 05 Jun 2026 08:54:26 -0700 (PDT)
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com. [209.85.208.51])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-68e65c542c7sm4074576a12.31.2026.06.05.08.54.25
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2026 08:54:25 -0700 (PDT)
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6914a658115so57967a12.0
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 08:54:25 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+6jQL6XUPOHCqRB1CMRnBXScSf02fR8TxjD95/u7ZdUy6Cfzkqo3VSCLo612c4tbUXUi7P8TF8wQ==@kvack.org
X-Received: by 2002:a17:907:741:b0:bef:d760:93ea with SMTP id
 a640c23a62f3a-bf37234c965mr227182666b.30.1780674864895; Fri, 05 Jun 2026
 08:54:24 -0700 (PDT)
MIME-Version: 1.0
References: <f919874c-065e-48be-ac5b-300c4ab86d4e@samba.org>
 <20260603211736.755139-1-safinaskar@gmail.com> <20260604100609.6b37f500@pumpkin>
 <CAHk-=wjvb56qo27-axALOKCY-CjLsj9_294zeBovPVJaYm14dA@mail.gmail.com>
 <20260604183829.63c35fd9@pumpkin> <CAHk-=wip3mwLOHOYJ9TtjDxOaq9YUXmuCg2AycyASGgeY6qqUw@mail.gmail.com>
 <20260604223216.73468830@pumpkin> <CAHk-=wh1Avi8FGbWkt9k0Z-KXWB0spo5mQyowO8PB2sJ3unbkw@mail.gmail.com>
 <87se71jps4.fsf@oldenburg.str.redhat.com>
In-Reply-To: <87se71jps4.fsf@oldenburg.str.redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 5 Jun 2026 08:54:07 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjkZSAhxykvG6tQM5DnBoS30_XCKkYpCsQwEGcxJb=i3Q@mail.gmail.com>
X-Gm-Features: AVVi8CdvqDsmiM-EYrTUflKR5aYKg4JuQO6h_hoIzVtXJtUhEM3tfPOlti75Shw
Message-ID: <CAHk-=wjkZSAhxykvG6tQM5DnBoS30_XCKkYpCsQwEGcxJb=i3Q@mail.gmail.com>
Subject: Re: [PATCH 2/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Florian Weimer <fweimer@redhat.com>
Cc: David Laight <david.laight.linux@gmail.com>, Askar Safin <safinaskar@gmail.com>, metze@samba.org, 
	akpm@linux-foundation.org, axboe@kernel.dk, brauner@kernel.org, 
	david@kernel.org, dhowells@redhat.com, hch@infradead.org, jack@suse.cz, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu, 
	netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de, 
	viro@zeniv.linux.org.uk, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 036192000F
X-Rspam-User: 
X-Stat-Signature: 1ygkwzh6hwrumu733cq396dio7gj7m3u
X-HE-Tag: 1780674867-617707
X-HE-Meta: U2FsdGVkX1+FPh9q3cFZF4KfGp2b2xfy7UdWQYuPNZcrhE97ATIeNNDdeMFgGfT5rjcM/Ej4i+NcSPaWbDqxO1f3Qo21MBefJcQwyuJDsz1VBuRISneOAcnAELgJQ6JdzXylRo5ONg010ZO4XYbQ6ottsqjqaTGw0ucy+3nKxVoG9kINF2FZ6TpsofHMzfg9eZBSsLdMa+tOR2VsGtFRb63/JzpoxMYTZ0ObtYP9e/8J/WiLAKCIGKyFCUmwoRz4YzFwe6WZgfT9HzYrHNjV18c991l0KhsPh/6zLQqES8vpZa1MY+vfMet8s7wAZvQtLjEOiaqctTzQ9iSLYUThrS1ToKB/OZAyJnt24te0torzAlUtbGInvz3I4zN7dOXNBYVrVENUgQrQBVSl0mhsW1SI+xfE+b+y7LqAAw4bsPdCfYFZcwHA7IR8mo1UXk/T32I9D2Y4Vv2hXvvYED4UhoK990KmPa8MJ4j9G2LvAAC8WGM1yuT4QrN7JdqHoAqllt5bYor1P8rk3sitmKE/wBMO83oKzOAJ0dgCBS6xXteRoHZJlZoV9Z6lKcaJLboDGem+h++BJACsZuQTxaCYsxS68nTc1kAW6ejgJ4+20s+ObwVks9t4s1ol0DCzjoRLGNoxndJkL0/rGEnfFXolc8lzomQNLpqhrO8FikXN8tDscaHjBlL2k7zEBegovDTPOArqDDQU6ZQQHeQzwRvssCIyp9ZP19TwwgvCghEBMRZQv8pNTEF0z5y6TrGTSyBST73Dl/oAjW+Y8rteIJINiH5XBLTv/5FcRLCpBRum1kGyEnGIQRyNEctFKAms36BGvy96lnV6AAUbzfvuLl7ueBQVHt9AVdAovHYVFisxxJDir4Iz7ej/nuF66GC+SZyp60kUDf0s8QfVZxRQUYATFgef2bq+t4ggJsZ76Dl1LwGfLQWgkm5Y9DEgtsrIxdKdzP9NM3gLNP0nx7WK8ir
 v7mT4L17
 1TSFqNZHfi79hGlHQEBQptLhDWxNiQ7GPjPpAV/UMGWGUMjaV5WnKiaCQhFOGbtHf03Gnt+m9N/OqUG3RPP76kG4WC/Ai+oHf/W39C7lSWDImaW8g6mW+v95xdvwlOnb4i8QpJIfXIbcIzC6lzgJxsOeWR0Bh+r5Lpy/e9az5AX/0ydGzMZjYnzaa7K9wgGf98WhUIjkzSSIiwrqLDubR/jrgwCe8kF/euu522lVHRD7eAGEfJHaXsV1NANBhYuB6TnBDwLYxCfbyx1UFOujVGljF5auqmiR956rmfZz0K9KThYnlo/kp1ganyUgqqvk2LCbzth1/RfBisGGH+7ntdAcMV7E4O9VUn1Kmee1MnyJtDGjZWgVbi4b5CbK6kBi28d6plh3TO4y5OnlqDhRULDt1MW14SHVCrHHQaEbMSR1U7n/EMIoLOKl8HG2PLw1Y3U8hVn6t31z1zoNQPzKPlJC1SWLPEEVdv9SgiqfSX3uoyKN/OE3887PCt/5YH0JDFr9CkyFgCfYajt03ZT/VXByuAucCkiwKeyZxJ0KEK7nzu+aw1qYZt5YnFyLJ4mrVqHR5K6OHeVfoAHfqcT5ryzen1agqQq5vZxO8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 5 Jun 2026 at 02:33, Florian Weimer <fweimer@redhat.com> wrote:
>
> * Linus Torvalds:
>
> > x86 really doesn't *care*. If the caller zero-extends or leaves high
> > bits set randomly, according to the x86 ABI that's perfectly fine: the
> > callee will only care about the low 32 bits. So the high bits are
> > simply not relevant for the ABI.
>
> Please note that Clang does not implement the x86-64 ABI and requires
> zero extension.  We see increasing problems from that, now that we have
> more C code calling Rust code.

Uhhuh. But that is only specific to 'bool', right?

If it were to have the same issue that powerpc(*) had - that 'unsigned
int' has to be passed to functions with well-defined high bits - that
would be bad.

And I'm pretty sure that clang doesn't do that.

Anyway, for the kernel, this shouldn't be an issue simply because we
typically avoid 'bool' in arguments or structures that are exposed to
outside.

(I say 'typically' because I'm sure it happens in some broken UAPI
thing anyway).

                  Linus

(*) I may mis-remember. Maybe it was s390, not powerpc. The s390
compat layer independently had a similar issue wrt pointers, where bit
31 had to be cleared. s390 dropped the 31-bit code entirely fairly
recently, but it caused some "interesting" code in the already
disgusting syscall argument handling wrapper macros.

