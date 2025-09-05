Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B386CCA1017
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 19:44:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 144DA8E0006; Fri,  5 Sep 2025 15:44:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CF168E000E; Fri,  5 Sep 2025 15:44:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F05D78E0006; Fri,  5 Sep 2025 15:44:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DA2168E0006
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:44:16 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AADD01602BF
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:44:16 +0000 (UTC)
X-FDA: 83856222912.28.DDACE2E
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf27.hostedemail.com (Postfix) with ESMTP id BF11D4000C
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:44:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fsH9ty3t;
	spf=pass (imf27.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757101454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5kSIyEkKJPNtcS4C9SW12B6CjFCMmyXxFbHsBSrhHlc=;
	b=mR7TLrxsxlQo4l2ADJT94Pi8g4ZNACTmsqHNIOnUEV25VLYe8kmWhZPnQlGjGZpC9N6Lcp
	i/8gMJVKkPvQFNsC1m1sTWXEb9C1Bw6fpEvBTeo4RU9q518Y/FavBGrGdlbmxmHSL7YvmL
	sANxkimuJNCL4pbNlaFFdoNLjPeBOqE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fsH9ty3t;
	spf=pass (imf27.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757101454; a=rsa-sha256;
	cv=none;
	b=6VbRqlAT9QozwZ6eRcdEp4wG6xN4qBbUIEpcxXndxKXyMQhjnGNdKojgYnS8CDtAuEIV/J
	md9GnESWUOAYW46u2IoGNSMPDxILVyLc9tNiPcP3a8BGffja4RVDR5owzlKV7HKVks5+gD
	5ldQGSREAt0yfDwxJwavmApJzhvvytU=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3df2f4aedc7so1502439f8f.2
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 12:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757101453; x=1757706253; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5kSIyEkKJPNtcS4C9SW12B6CjFCMmyXxFbHsBSrhHlc=;
        b=fsH9ty3ttWzXR9ERPPjv44aFITlNTrsxeyM2QTZMcfqE7NOTmmK8OtVFzWIhclKGXy
         EQOV6JYJRGYEOWjJMsvfDwafEsncM4K9/93S1AJVyOdJ+h9lGGwE4/GHvNpsE+YJoFT9
         3j2EKtbEyJcbDcnQNYTxIOzbKRGJdqB1KZ5tHWpTgllMSrXANRpM5JVF0wXHXUZQoIGK
         7SK7RReoQbshjQvw3LOmFZgUd7lEziakcuxppjsJVXgh+tWK1zPPEZEk2Dk0s5XFAQge
         +3sgPJerATfB3o/wLenm7SDxV1iualJGzUPRfNqDxx0sHS8w5JRWbQNA//x9WhcZiOOs
         Qy+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757101453; x=1757706253;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5kSIyEkKJPNtcS4C9SW12B6CjFCMmyXxFbHsBSrhHlc=;
        b=moYeY11O8DiGp+qEstL1sfxApN3pZPbJGPzXzP+91Pu8wp6xOX3WEAA5cW4poBtMSp
         MBP8h0xkVVQd0Bj3nVTgWJfwec0r1zgjg0vWkY/yX4Jvm100daRaGvGgR3w1zGsuyYYR
         hAZnYOOx0kN+l1vb7jlY8MAhR8iytJp+lj3MLlvbxZksyLtJH8TeomtOEzFu/smRfzu2
         FBO6RBF9SZGgKtrhG1P6rJ0a6xryaxvFrXuy2Vil6jWw79RfMEq/Itsh1q8S17+MoVjZ
         CSKQbxxNumi65jrMMw5Jo+lS9dsNBDpR9vzVUsb5Xu24TzcU8f7FA8X4okTRtXk7AsYb
         fuYw==
X-Forwarded-Encrypted: i=1; AJvYcCU6JUVWGSqxnep0gDltF8MDRBm1M1BSV8WtOc3y51YpRJ1LJxYNIXEmObdiaOLtnekiLRTASjBBzw==@kvack.org
X-Gm-Message-State: AOJu0YxvNCqlXyOen8tyDRL4IUGI9IT5az1xaw7q6Opq//OA0ncv7a5K
	BFAv3sDjZDEu9TtQ+c0m4/vqrfDONKQ8xL5sxZO76KKr1TgNMnFazJ57S1YslW8A36ZLi8I0ucY
	zF4lzwnLj6S1Vdz9wcsF6tz+lE4NU5qQ=
X-Gm-Gg: ASbGncsEFW1woSrjyw4GU0t6//YZoH/R2V6+lVBH+EYk+aUr1NCvIzVNSepyE9CBe87
	Rz7HWV7NIm4H0OL5sxyW/4L3iC1VHT0LNo2FNPY5zYRzcgiGRnAhC7V+5XZETljVuNsV048qicW
	emlJ3sJiRzgtFO7yLTOdtQDarIG8/9jHhrEujPWTJp53hydiSGdHRO1tKALEHVfpNiagkbj6Za7
	ENH7GT+TZZa9IEFZw==
X-Google-Smtp-Source: AGHT+IEIWTbj6iXai5EB56BajMtkwmQ0wX6zSMX9cOQAlzshrXJq4aBijoRGaRfyrquo9vOREnmChUojy9i9giTVk9g=
X-Received: by 2002:adf:b188:0:b0:3cd:44a8:ffcf with SMTP id
 ffacd0b85a97d-3d1dd81e4b7mr13383104f8f.12.1757101453197; Fri, 05 Sep 2025
 12:44:13 -0700 (PDT)
MIME-Version: 1.0
References: <20250820053459.164825-1-bhe@redhat.com> <CA+fCnZdfv+D7sfRtWgbbFAmWExggzC2by8sDaK7hXfTS7viY8w@mail.gmail.com>
 <aLlJtTeNMdtZAA9B@MiWiFi-R3L-srv> <CA+fCnZf2fGTQ6PpoKxDqkOtwcdwyPYx2cFwQw+3xAjOVxjoh6w@mail.gmail.com>
 <75a2eb31-3636-44d4-b2c9-3a24646499a4@gmail.com> <CA+fCnZdWxWD99t9yhmB90VPefi3Gohn8Peo6=cxrvw8Zdz+3qQ@mail.gmail.com>
 <c0bd173c-c84f-41d5-8532-2afb8eca9313@csgroup.eu>
In-Reply-To: <c0bd173c-c84f-41d5-8532-2afb8eca9313@csgroup.eu>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Fri, 5 Sep 2025 21:44:00 +0200
X-Gm-Features: Ac12FXw8jIlx5I_GnULq-nTw7_htdTiBmfe6-tGy9IZcoS0RzVO8mAQjd7gKDAU
Message-ID: <CA+fCnZd9unSjY-UnEwc4rGkSRgZX3nrs=WgBb2eDQNEpZX10cA@mail.gmail.com>
Subject: Re: [PATCH v3 00/12] mm/kasan: make kasan=on|off work for all three modes
To: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Baoquan He <bhe@redhat.com>, snovitoll@gmail.com, 
	glider@google.com, dvyukov@google.com, elver@google.com, linux-mm@kvack.org, 
	vincenzo.frascino@arm.com, akpm@linux-foundation.org, 
	kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, sj@kernel.org, lorenzo.stoakes@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: BF11D4000C
X-Rspam-User: 
X-Stat-Signature: 1csrr1zd1rczu719e8riiop3kjiydudh
X-Rspamd-Server: rspam09
X-HE-Tag: 1757101454-975193
X-HE-Meta: U2FsdGVkX1/zy0aewMFduxIxUmb2p+yPFUdtG+wtRjKlnEov13DGgaYzI2cKAAFl5yOZDXgHWXbJmUfvbQ8NEhpD9RgtByfh+e/EPwUq/0eKIrdp/IXzUHjKTl97PHNd3T4HqgFv5tmT6v1a47LvIGPYNe3vzi0JL2UuIocLkXltc5hmiz2jgkvmTIRWAXo5YFhq7iIlzlABNKgcIT4yEkQDfh/mbONRqRLngymvQBb3VraFAFYr2q3Z0eUk0r/Z0hvFQx1LQoue1R62DY/8LDq6QMb7QyRv5/lzyhkoAO3tivirP6zMrZtMXOBXrKuG8uEF1sRVQ63BepOyghSgHKqkojWepDIways0KRpoSeiocTUCxRHhXdWuPM2+SBqM1rFXuxctinPElv/LtQ2wp2JxJuXLKYhYh6yuCqZmwYKqvxndzpB8Jv695T0WK3NDoVg5m9EYK3IXXMc2l3fTlXOduEhnxva5/9k5nw/xlLunC1O6znbhfhVAnzCrJkaQP8+Tq6DXmoABjUEHtvkeCQyN0FBLS5VJjTEtVLuXsEBR43ki/3S+hCkaQv4Qq7UygF8IaEs6+FbutyaIRiq5UhMbpluEmlNOYUNjfcBvoVZKzcjgQZaYI0JviCtMBuudUaDBB6udTVqcjJWYGHCGu0VcVciuS/GjeRiI2KQ2IRM03YcxpKn0Ce7lY7nklczE1/UkgbYO8aVSZnF91Xi0QrSTrLhfuEtiM07G85VIVr+LAb5FRVDvLElKkmVM0UrEoTYzwfnBSMMNSJgtfuF3kMOCrJkpseW8XMtEnpVqk8o9n6QXmb3B+KzscdycgREeT4fl00Kt7OeG4NbkZaMAax0Ah/KJiqOpYFX37K5Pix/FVhQz+o7mKn5lDvAET+JHSL1VzpOIakTCHDeeedtTPCnbEszbNYgVYJhp4/Hfpm/fpe+GmWq1T3taurWl0MYKxP0ffKl9chEHh0Yg3Qu
 CyN+yXjs
 kDeQpchyEEqbBPqS6zUBpRrQrnx7Tgpyg3CNWLqDnxdl2vkhrvm8BPgroZSHur6eZMOc3QBrIh4V+GnM+Rt+ot97PVJ5NkfILcm0FPP7r2P7IlaYPghj9sX5t6nAu1czlxQowzX1AWC+PqrgC9Ib8pbC9x+Hjm4DHMKdyWdDgTJ3uFFeSEUBLvtc3LY404Tq8r0k06ndDchAQmSlyoAwCI1IG+XguA7duVMqmbAnMU0YAM3L02bqY83v2Tx4CpOqu44wtBexlkxhdHh/yHmunZYPBivLcb4R0o9hfP9WfpvpS5TyL944Hrt45igOhjC2yjKa5IfaKokopfLQ/QAuLHds9ddpGnDOUNqpNSqSwEr9LPxFWM/UjrrpkZXR4C0xCjBYdocogFIdqZStvitmVFc7z6599znpUPH5cxiXoc0H/iRimdfuSYzniFREQU5e3x4lbW0sw2nQ23tCRRtc6zOBLGRhMaiNrpAvsqgnY+HnTaWA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 5, 2025 at 9:13=E2=80=AFPM Christophe Leroy
<christophe.leroy@csgroup.eu> wrote:
>
> > Hm, I thought it worked like that, but then what threw me off just now
> > was seeing that zero_pte_populate()->pte_wrprotect() (on arm64) resets
> > the PTE_WRITE bit and sets the PTE_RDONLY bit. So I thought the
> > kasan_early_shadow_page is marked as read-only and then the
> > instrumentation is disabled for all early code that might write into
> > the page before the proper shadow is set up. Or am I reading this
> > bit-setting code wrong?
>
> But that zero_pte_populate() is called by kasan_init() when everything
> is ready.
>
> kasan_init()->kasan_init_shadow()->kasan_populate_early_shadow()->zero_p4=
d_populate()->zero_pud_populate()->zero_pmd_populate()->zero_pte_populate()
>
> Here we are talking about the shadow set at startup kasan_early_init(),
> aren't we ?

Ah, you're right, thanks!

I was confused by the name of kasan_populate_early_shadow(). I think
we should rename it to kasan_populate_shadow_read_only() or something
like that and also update the comment. As this function is not
intended for populating early shadow (that is done via
kasan_early_init() in the arch code instead), we're populating normal
shadow for pages that can be accessed but whose shadow won't be
written to. Perhaps it makes sense to come up with a better name for
the kasan_early_shadow_page variable too to point out its dual
purpose.

