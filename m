Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3AFCD116EA
	for <linux-mm@archiver.kernel.org>; Sat, 29 Nov 2025 01:36:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEE7F6B0011; Fri, 28 Nov 2025 20:36:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC3F76B0012; Fri, 28 Nov 2025 20:36:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD95B6B0022; Fri, 28 Nov 2025 20:36:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CBCAF6B0011
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 20:36:02 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4FA57C07BA
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 01:36:02 +0000 (UTC)
X-FDA: 84161928564.21.3C700CF
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf22.hostedemail.com (Postfix) with ESMTP id 18D4CC0010
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 01:35:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b="ab/mrw47";
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.43 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764380160; a=rsa-sha256;
	cv=none;
	b=HWyD6Pqg2LfQ3j5Po+NG1qiARTJjIikUVPZaTCyH6pU2ZTnkpUcI7V1lVI4cuWzcAYjrVf
	HjI4JC0KJCcBc0XvtTVK5dbhgijAjxtmY8mv3i9CUi+mngbZrddMUKitLPNXEW6cxYFceM
	mSQrThqW410caF26RdOTKoKEYwTPiHQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b="ab/mrw47";
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.43 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764380160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q/WIom7gz7NUO3fE19+reH06dlDelQ6m/UOlLG0sWa0=;
	b=N8oxsxzoQIKat+4h/sS2Wejo16/MGnX+gzuim/XASJsLB4i897inTH6i1HV+ZU3xO4LzZ3
	tzbVJGrq/QCnYoI+V0EibOiwwk9n44x3qOSOSxoDNWzU2oMKXIZL0GhhahXtWo2hZUoH4p
	ombRm/OzHUUf8LJ3Ych0eZLU1gJYQA0=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b7380f66a8bso372000966b.2
        for <linux-mm@kvack.org>; Fri, 28 Nov 2025 17:35:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1764380158; x=1764984958; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=q/WIom7gz7NUO3fE19+reH06dlDelQ6m/UOlLG0sWa0=;
        b=ab/mrw476+QX4pfGbvhHjJlzGXvm2StRKfEc2OZAM6J1XD+xFjBc7FOlFvjMYiOfZb
         8dOKJFriEJ2+gX05jePUS3RtI25lp5O1CUJhsOXrXgmss5YlPoVdoyscgLZ3I+Bl7eJD
         /IQ7tzdZODEO4SXC/7EueezzjJPmWHrPeuCKI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764380158; x=1764984958;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q/WIom7gz7NUO3fE19+reH06dlDelQ6m/UOlLG0sWa0=;
        b=JQwOpoclQjKvTop6C/M/ccNmJ8phz1DUgAsRzzblHR37kiJY3z5tpOlua1EefSRbBs
         sKh0W3EmqsyKQSg5MynNo7z9SujNzE/01MHt/EZc0gU2bAgQFW+AHEx7MlAiY3lJjw2i
         mLBzUzxiK9oDect/bKvcdX7HJKTvldtMNWCPbi7IPRqC3HbkYnWONeGeyahwiJX8qi44
         Pe6fwVoia0j7uk5Juv7t+h3GIHEthlwcsFS4uQwGRSF7JENNeunIPC9CV39s9Y33ymj7
         mr50e5VL9DKP2CKjBtU0I460IEJ2l4XPim59ogFzvB8oc47UYIWLf0jUtKf1UI+8zvYM
         5zYw==
X-Forwarded-Encrypted: i=1; AJvYcCU1SQJl66boMMM+CbEyIFD7wiA8c2Hb+7GwsC7IuxdDCeY8Za6eT3gLO+ZSoTUvfAYz08BHOJ9r7g==@kvack.org
X-Gm-Message-State: AOJu0YwTBUSkZYSCi0nGjXii6aHK2btNfy3S3jTeC1ai6pIHJJWS6uEf
	P4e2WeT1xorLh6t9SwgP9okiNDL0Fx6Fuqub9Xxi6hR2X/HPgZ4yGjZlzI/pRqdp5QR8JEnQxT6
	XZ+oH6crnFw==
X-Gm-Gg: ASbGncsu7b3IxW0NAogPbpap53dbSNzVreGnzMlNZgtPDPVuhxlhe2MH7h9xpNPp3B/
	f9wVREVsKFGpXjy4onLr1iribfg47yQGpdsiwTogwW+W1f0nwJMLcLdl2YAuSR9BNpc/cxHNqWZ
	jFaWIEjxqEROo3conBvSj7Ah0m0F0YFDYU/g+BlxqNQfkLN5gljGTKMUX1ik+KzTY3Qj0fDn/FH
	UdjKGNlrbzjuf2RwceezPaJJ0Sqe4iuvCOuY9xm4YoDV8MgSJ09CfexIU6OVbqYvSjU5AkQH7jA
	QGL2TfDoxWXNB3uSPe1LqgyzAz6h2ttQWVCsEu6wpD0ZNlb4rb8HKUf7R841Ph3A50cQFBqo2Vk
	LJIrSA7tsgfmVRimJbeWcrv0BH/es1NrX0aHtmk34qELV3HLbtiFGeDGknZeGWoctX0BGGX9d8p
	tYzwqWH32mTtctpOi+LrkVESwswqPO69nMZ5ptQXYxu5qYr7LKTzjdeH0bcBNB
X-Google-Smtp-Source: AGHT+IElCWP97tN7mx5TBGT8Hu0FhPgT+MRNd1p747VYZ30Kebx8Avr6oP3vtDMUIgSlZ9rh1auF6w==
X-Received: by 2002:a17:907:3f1b:b0:b73:544d:b963 with SMTP id a640c23a62f3a-b767159e21amr3196249666b.13.1764380157978;
        Fri, 28 Nov 2025 17:35:57 -0800 (PST)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com. [209.85.208.44])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b76f519a41asm567832466b.16.2025.11.28.17.35.54
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Nov 2025 17:35:55 -0800 (PST)
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-640aa1445c3so3752301a12.1
        for <linux-mm@kvack.org>; Fri, 28 Nov 2025 17:35:54 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCW9mtUfSHvx/Fs7JltRT6A0YfLZWmS9a6Wuec/as7bhIY5IwRZIW2ajM/0HvmODE9C3+ck8iE8LyQ==@kvack.org
X-Received: by 2002:a05:6402:3494:b0:647:5c27:5440 with SMTP id
 4fb4d7f45d1cf-6475c2754b6mr4287616a12.24.1764380154354; Fri, 28 Nov 2025
 17:35:54 -0800 (PST)
MIME-Version: 1.0
References: <20251126090505.3057219-1-wozizhi@huaweicloud.com>
 <33ab4aef-020e-49e7-8539-31bf78dac61a@huaweicloud.com> <CAHk-=wh1Wfwt9OFB4AfBbjyeu4JVZuSWQ4A8OoT3W6x9btddfw@mail.gmail.com>
 <aSgut4QcBsbXDEo9@shell.armlinux.org.uk> <CAHk-=wh+cFLLi2x6u61pvL07phSyHPVBTo9Lac2uuqK4eRG_=w@mail.gmail.com>
 <3d590a6d-07d1-433c-add1-8b7d53018854@huaweicloud.com>
In-Reply-To: <3d590a6d-07d1-433c-add1-8b7d53018854@huaweicloud.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 28 Nov 2025 17:35:37 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjA20ear0hDOvUS7g5-A=YAUifphcf-iFJ1pach0=3ubw@mail.gmail.com>
X-Gm-Features: AWmQ_bn2YLtZkenhhdk984gAsTyb0rIufR4Br-TkPYHMl26wv1MEf1_t31IUh7g
Message-ID: <CAHk-=wjA20ear0hDOvUS7g5-A=YAUifphcf-iFJ1pach0=3ubw@mail.gmail.com>
Subject: Re: [Bug report] hash_name() may cross page boundary and trigger
 sleep in RCU context
To: Zizhi Wo <wozizhi@huaweicloud.com>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, jack@suse.com, brauner@kernel.org, hch@lst.de, 
	akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-arm-kernel@lists.infradead.org, yangerkun@huawei.com, 
	wangkefeng.wang@huawei.com, pangliyuan1@huawei.com, xieyuanbin1@huawei.com, 
	Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 18D4CC0010
X-Stat-Signature: 1nqwsxee53yhoepie6gojwy41kwwxoec
X-Rspam-User: 
X-HE-Tag: 1764380159-66956
X-HE-Meta: U2FsdGVkX198y8GhprzquGjLqzY9Wig8FQBmBwmHXMlbi1I7jP0I6vBolzJw4hvSm/SGWzZxpl9XtB2A3GpbEPuKA2Xo2u7YEofqXbJH8AVHUiKDvV3lXh7RK2g4mY7WH1fE+s9tf0uJymYTSxwbLD178txUy1ZnRrglFIbnR2wYnje1bxWSrLc803pJv6Ryy6AASWjHPrNWB/YO0Wfnrus34K3b3sgzPgHd8zdvpC5xEbmrh6bpNYAFgJeveojRZPuNJzGBp9vTivSUWASDWvHTTLERjC7T2GvzkLkJ+5pK8twHGWYlnOiK4pfk0eaNXeZja8Wb48osJua+7GLMbBwFYrSCqGEtIqQbUBwr7lhPF1H9xUQx1T4QcFQUJB3385eOPrKfrUe8tTeNrrSbW47qppYtr+0orovZbOwwmgtWNwuDmI/pk+DAcPEIjR4I+aqJnFiNbC6dfN89mu1iUqa1v96eKlRwYvVJGxN9gQOiD4NCGh0mS9UwRr+RPcyvv+kwkNFz6WJ/XM+mkNsw4u+uk7sWNCfGH0SS4jNZfVxV3wOS0RdWC08w6H8kPQfFOa1fMDE/FcaS3LtsncKMGi9z+vlLTXnIpWbvhxG/4EPdZ7LkWR1BtgZsjGQJ3Zw0zqY+B+JYhFxHUvdC4/YtlIuQrfhevq1GS3qrtBCchU5kA67NvmNMf4MVH3emWdWtcipfDbiiRi9L+tqq2BB6lZ5bR3trrkShI/M9AXUvAQEt9yxPrBhc9/9/AFy69Rj7tbLvCH+fRShYvCWe98+2hpSvECdDbWUbuGyyphzSYPRhO9QAfpSSDgcPFjSGBvMWDm7HoVEpMHuc2Sm4TB855jYxdNm/5xgHCmNQQaz2a7tlSjMYMQ1VzYlCjq1QNPXvomlqQ+vHiBXG/WO5mQchqHtJeYs1uqy7u48sZH2RCdYKU+OH+0Pk6hL3MMUy9UFAOGWaXkFNv8iH3J4RPvW
 dY70ANSM
 TjKogCOygATJG58KaaxM/fHnLGZcgT7nmsmKNpco6E/HmLpA3liwIwlPONYYp5dSFOvB7u14v0PriCXmOEymyKNgCioI4j5GJHeehdVBEquVhzN3DjRqeNflkpwnkAVOebmUxjze80ytQHsQKzg1UZqwSsSHP5ULq16tYHVmgpJAsgFTXC6BZg9kU8Oz8hNIfu8CyvwSF6j/QyeafJshVv9vwfFihldJof1iFO72LIOYGjoLdSIkmFzafUzCV/22gxO8c6NqXXFel8xJhQDQbWfA0kD6c3VMx3HCuertXzjPdfFFlqOoFwLvhLmyTlDD60FI8AES9IK7TolxY1i7kl9gy22UMopcku9iGTc6dQRqGYDImGArSmBFO8GECwR0tuFaURqkmeKP2iq0XKePk8Z9iRlttg6qnmHZwAJrOXlW/X5rhKXl0mbvcqOyxwamK3I6xy+5Z/4I2G1WP1t4Mh/Ey+JSWWw8qawbiS8JF38wJfUKbqIVyDc3BIOPlGyfKgIoi7zrvireGmGwN8/q404oMOsDW816WT7KYUljZJ8CVirIwva0x9tQoqGu4y98BOyXvCYMQ6ISmLuQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 28 Nov 2025 at 17:01, Zizhi Wo <wozizhi@huaweicloud.com> wrote:
>
> Thank you for your answer. In fact, this solution is similar to the one
> provided by Al.

Hmm. I'm not seeing the replies from Al for some reason. Maybe he didn't cc me.

> It has an additional check to determine reg:
>
> if (unlikely(addr > TASK_SIZE) && !user_mode(regs))
>         goto no_context;
>
> I'd like to ask if this "regs" examination also needs to be brought
> along?

That seems unnecessary.

Yes, in this case the original problem you reported with sleeping in
an RCU region was triggered by a kernel access, and a user-space
access would never have caused any such issues.

So checking for !user_mode(regs) isn't exactly *wrong*.

But while it isn't wrong, I think it's also kind of pointless.

Because regardless of whether it's a kernel or user space access, an
access outside TASK_SIZE shouldn't be associated with a valid user
space context, so the code might as well just go to the "no_context"
label directly.

That said, somebody should  definitely double-check me - because I
think arm also did the vdso trick at high addresses that i386 used to
do, so there is the fake VDSO thing up there.

But if you get a page fault on that, it's not going to be fixed up, so
even if user space can access it, there's no point in looking that
fake vm area up for page faults.

I think.

> I'm even thinking if we directly have the corresponding processing
> replaced by do_translation_fault(), is that also correct?
>
> ```
> -       { do_page_fault,        SIGSEGV, SEGV_MAPERR,   "page
> translation fault"           },
> +       { do_translation_fault, SIGSEGV, SEGV_MAPERR,   "page
> translation fault"           },

I think that might break kprobes.

Looking around, I think my patch might also be a bit broken: I think
it might be better to move it further down to below the check for
FSR_LNX_PF.

But somebody who knows the exact arm page fault handling better than
me should verify both that and my VDSO gate page thinking.

           Linus

