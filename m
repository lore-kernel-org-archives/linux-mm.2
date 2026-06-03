Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C262CD6E57
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 18:29:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B5AB6B00B3; Wed,  3 Jun 2026 14:29:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78D666B00B5; Wed,  3 Jun 2026 14:29:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A2B56B00B9; Wed,  3 Jun 2026 14:29:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5811B6B00B3
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 14:29:02 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E8E43162641
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 18:29:01 +0000 (UTC)
X-FDA: 84839438082.14.FB6CB06
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf27.hostedemail.com (Postfix) with ESMTP id BDD5F40005
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 18:28:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=QhrlzeB1;
	spf=pass (imf27.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.216.41 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780511339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8VYe+dW7ZDjb/fodoLbEwUxVzR4phhS+HhNp00MJ/BA=;
	b=2rkB4/XNDWeHQDPyQq+chV/C3iko/qtRuVcvtBl3GSOsaG6c5ypgJlH+ksQoGzZA9KWFTf
	mEiQREchRMDDGYFY/Ma6EA4JFAFOsHaVLoIyAqhj38ARo1Bc83MtsBKnqSsvvZmqVq3hrR
	CD/Ez377GzY+r1TBzsEaY4m0iiBufuE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=QhrlzeB1;
	spf=pass (imf27.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.216.41 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780511339;
	b=aInnYk/GEFfbKT+MM5YeWKggERFcRXicJktPLXqPpwcY/7n1JHmbHXCdftDkFTHzRZbIlQ
	RZ+aGd74qcSo0StrZ3Axi06HHHB00jH/wNlXStpwLSZwDYTuj7cxKCYV/fKuL6co8qyjTM
	jq5fbfs+5tk78ylfec1nrHMwc98eSUQ=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-36d98b9aa9aso3709569a91.3
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 11:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780511338; x=1781116138; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8VYe+dW7ZDjb/fodoLbEwUxVzR4phhS+HhNp00MJ/BA=;
        b=QhrlzeB1GDv2qaapMP8E4Jq8EebpK2RC/X9zOsgE9a8W3Z3hOqVnHoXnz7zc3G5ZI5
         NmSQjyD/m47H7vhWvA0/pYlGBMx1hKXDgzhq+C0wNlLtLOR20gTcBipJcrkcWOWByEe/
         YeiSKBQ7Q6Mvs+p342euXMAcRxtxHzf8A63F4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780511338; x=1781116138;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8VYe+dW7ZDjb/fodoLbEwUxVzR4phhS+HhNp00MJ/BA=;
        b=bO06HvZlde4eFQIMDnWaftU4ShAHY760RT3xdJo4TwmKMEJv/ZFhFVUuf6wB4NOdhq
         ghUzgIy1TpIU6h3HlX/4mexUgwqtCBhbixXmnDqPvgFVctKABbFUYgcicxsD1JkujhTf
         Iyl+vHRaH1LWDW+YlQQOcbUQuzKX66hw1gs+XRPhXYuiNukLrUnYyrhBuA+CML7y3h4P
         JmFDzWKLvCU9iDUjd8CCAmJUw/v7aJl6zjFD++mm/49DaOrEfsx+Sc6GFM99YN+uBeQC
         /TuschYzQWCZW2hylI1svc4uQEWdEhwmGAvxkfq2zlxc2lVLVxkQEjVoZuARcKWcwYs5
         zFKg==
X-Forwarded-Encrypted: i=1; AFNElJ8/WU4GkK/WIZA4o2zuK+U/ZnvAOYO4aPQVlZAiuTdHWJN6fuFU/psDWzTaApQTNU5HPKrvGf2UJQ==@kvack.org
X-Gm-Message-State: AOJu0YwNQY82778jLx8iPW9M6RZ3Sc7V2qFeCi9BdP9R5dWtROIRJPcJ
	pr1F0Ob7EIuFP00cXVBrHsagghDSSK7GMsPs8zgZIvEMnOPcYuh7TsX3lKi/6Vz8EEm1Q54/rKw
	tuK3nHquTLA==
X-Gm-Gg: Acq92OGagyKZ/nvjxzcYOUwKx/cK0qs3FC5jL550mSiXgxUW/VxXYGZYOQ+SHuDO2p9
	JijffGUk5u0ok45Fcpx57T47K3BCRn6c+XZ6LtSuwbMnBj2WIahyZo/H69wLkjDHJLfzU8yuK+o
	2zxB7cSaS8fxYX8kPOX37ar8is6sUPjrlvk60s77Svrvb2TXfVo/Wrye+GgGEwsBPIkvNcYb4zw
	h5CKJchRdrnEC9/Ph++QKpvuDA+01POXNKN9MqZ63hKQVhVzYp0ey3FPKBAlSYbS5NiRmKKAu/h
	NZyfG1z7fJNLV+x1Ip82XbfZO3vDqnmOiEn4Y8x0gq4P2nsneC9zV3iw3TY3tUNlKVLoZJCfqD8
	lkRyEkg/DDTpk85J0efUVx+BehFpUn1BTHYMbvU9uduSkWfYDQYNyad9rRlJG7Ol/vCJVfdCeag
	iWMzBX9DCw0OXLcjTRKGgfOuq/VS3T9o8vDu+7EsXLCRIkWvFNu9ZHdRMeqALHtVUpUljQuuSks
	Snf3ZadfM2OFHQ=
X-Received: by 2002:a17:90b:258e:b0:369:de03:29c8 with SMTP id 98e67ed59e1d1-36e343872dbmr4558240a91.23.1780511338468;
        Wed, 03 Jun 2026 11:28:58 -0700 (PDT)
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com. [209.85.215.181])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36f70a2892esm336962a91.10.2026.06.03.11.28.58
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2026 11:28:58 -0700 (PDT)
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-c8588ec1b44so3432569a12.1
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 11:28:58 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8EK32ZgZreKsurGHlXQOLRAaDiIAu1RocAeHe4Ix9xYIbiMX7JEnrT83sJYnGxg48HKYg+r0RxFw==@kvack.org
X-Received: by 2002:a05:6a21:50e:b0:3b4:736b:da61 with SMTP id
 adf61e73a8af0-3b49790c56cmr5052599637.35.1780511337548; Wed, 03 Jun 2026
 11:28:57 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com>
 <20260602225426.122258-1-safinaskar@gmail.com> <CAHk-=wgKy4dP0oQCNKyMQQf3-uVpaigmDyH6_T0Via76gWST9g@mail.gmail.com>
 <CALCETrWx8-Q5-rK1KnAPCxCbXaWCd=Yfs_Pr8qVMa8k8L6of1w@mail.gmail.com>
 <CAHk-=wizkDXRut5xLXRF-CVUVYMaZ5AOexxeghOAoXPb4yAvQg@mail.gmail.com> <CALCETrXzxubt4eWue3+wv7Fq9C2m7uu6bWPstqFh6Mo57bPwQQ@mail.gmail.com>
In-Reply-To: <CALCETrXzxubt4eWue3+wv7Fq9C2m7uu6bWPstqFh6Mo57bPwQQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 Jun 2026 11:28:37 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiEwSjfbjfO74xu=UmkkdHXkJg5QNQ8pP-3iYmunmeV9g@mail.gmail.com>
X-Gm-Features: AVHnY4I2wCOVMf6tT9iCpMFfYRmksgwgXPr0UvzSy7WYplz1D2yZ52_F3Jv-p8Q
Message-ID: <CAHk-=wiEwSjfbjfO74xu=UmkkdHXkJg5QNQ8pP-3iYmunmeV9g@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Andy Lutomirski <luto@amacapital.net>
Cc: Askar Safin <safinaskar@gmail.com>, akpm@linux-foundation.org, axboe@kernel.dk, 
	brauner@kernel.org, david@kernel.org, dhowells@redhat.com, hch@infradead.org, 
	jack@suse.cz, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu, 
	netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de, 
	viro@zeniv.linux.org.uk, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BDD5F40005
X-Stat-Signature: qikh3zfyojoedrpjka4abu4y5xp1ypkd
X-Rspam-User: 
X-HE-Tag: 1780511339-188255
X-HE-Meta: U2FsdGVkX18oaDW/gARZ1Pmw13MgmjmFThOEh1Zw9Zo3hmX5WBxiVKpXW8eDBV6UKVMGGE1I7UCrudoCnszhPqoqqfgUKbTXTo7GEQYo0y6rKgPLbfN+s4EaxyUaVsYLLJjl9O65jjKQNWtJJETrOe0zaBgdnlR/h9H/oo0GnOrrc4+DDFfyEWJLMXbUNtffibCRrmJRUF/LW95RR5ecd/bYI2jQ/WNanc6ZymPxH7XJVtYYe4ijB4B8aE+wJikPwIEN8+dC55UU19HFULwC+x0b02TZmzGl/vO1sDVQCqI1jGXfD64F5ZF+dm9MTfaIONnWFsHh6Pj3U+5xE9cIbSKk0lUqC4h3g1Ua+6L5N8dx7+0ojU7pmZOdPHULajXkq/KDrSOuqX1whzkaGxmwUaES08dqRVm4zBWY74FnPAaEFr4ex84kCy5C91tZpzdo/YQjPl1knqxTxfbboflZWejqc/GTwihlyI5TgUdYVHK07AoGvg7DLF9sTRHTdZflC+qRYL0qeufT94mMjyJtH2ekbFz0Owf4PF+AKKwB6xM47Hudfzq3XkiJkW8yIUlxhOXtBmY838otunCY3mlNBsUV2ilw42n6pc2k9xB2SgzcLZWMvnrGcwpz9U9SaQaIq+UVqTQZoXS6m5Ht/776vh8YLQ+3jNXhBpQlyCNSOld0ygAa77ZlFAcmeSQSG9CYv/uClTcaVxEFTaCuAGKPK4mi9U660Y9/zpmmNC1HSQn4Uz2XNe6zLy10ZT8JQumEy8RO0W8Y1GGAGM8E3fLmfFTfYyr0UvobVjVb5wfIJS90rYKYrQP+ixW/o+C1Nwwd+w0+Ub5nSRpwoirebCl2IrMT+PN8aK4QGQSCUCguhkg5BZx+PIg1MNUQ1kfQCBDLosLAlx+DmNLxwzlzhNsvZ0tOh/BPC3p+WddDNAoPBuoaBWg39z6GkqZgs5xJ7msEBKlq3QkjsQzX5TsBjp4
 FtIBztxf
 y2L9FcjLuLNcQZhjyeuheOLl6pbpVfLfnGImbhX/pr4g1Q5dj7TAzjBDyZwjTj+rpMRHEgBCqDFubNww8VOe924vkKhzHt/YO5u8boPj8RToBFBEw1mr3rSfM98068zOsx4AQ7wCtwQf9NcW75WWJjJgMnI7tcTaVp86BHtZbzCEmUnGvPorAqBH4W95YUG3l4Xv+6472hep/MQCZsGJIT/+XCHw06Q7oVpQwbpTi1hEuicIQmLDMqd7aU6KHGroPrVWT6rKPyTrO1ZIRzEpFp6rJZ5oaCOmXLM1iUOuzxKQmnOXcFqUsEGaa3JA/0RMFsmFYciVBVss7tRbfBx6rEQ54AvqRuKmhvU1/Cog3tfch7rjeyu9EmL8xAD51XRtAf66XHyjv/kFgxZMLLcGEPqgniRzHJXK/aZB+yKjPBmJp9mNcNNvKoNo8YfeMXQR7N2QBDIpNWvHlpdP4naLeuALu54EP0f1DpFZlM/jXvjouIZRs0jzd4jEDHRwl2Z835QdBuiAAO+KKonuClLWZ1kLNfCA1C97exQ2j95dtWRpdSiKDo1EF3Sc+1xiaUKduhjiq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 3 Jun 2026 at 11:10, Andy Lutomirski <luto@amacapital.net> wrote:
>
> So maybe we should make sure that, if we go down the route of
> disabling all the splice magic, that we leave an API, maybe the
> existing sendfile or maybe something else, that does an optimized copy
> from one fd to another and that is at least capable of sending from a
> file to the network with at most one CPU-side copy.

Why?

That is *LITERALLY* the attack surface - and the complexity - that we
should be removing.

sendfile() was a mistake. It is literally the "file->socket" thing
that has been buggy.

I absolutely refuse to get rid of splice code but keep the buggy sh*t
cases that caused all the problems in the first place.

Because *THAT* would just be completely insane and pointless.

> Even if we=E2=80=99re just doing that, I continue to find it strange that=
 we
> require that a pipe be involved. What=E2=80=99s so special about pipes

Again: it was never splice or the pipe that was the problem. Stop
barking up the wrong tree.

It was "file data to socket" that was the truly horrendous issue.

That said, to explain the pipe: The reason for the pipe is to act as
the kernel-side buffer.

Now, these days we have much more capable iov_iter interfaces than we
used to, and in that sense the "pipe as a buffer" is certainly not the
obvious choice now.

But even then you need to have a *handle* to the buffers for the
general case, and that's what the pipe fd ends up then still
effectively being.

It was also done to avoid the M:N translation problem, because people
wanted to do zero-copy between other things than just "file ->
socket".

But again: we're ABNSOLUTELY NOT keeping that "file -> socket" thing
and getting rid of splice.  That's literally keeping the bath-water
and throwing out the baby.

Splice is the *good* part (well, relatively - splice is bad too).

ile->socket needs to DIE IN A FIRE considering the security problems it has=
 had.

I hope Jakub is right that the problems have been all fixed, and this
is all theoretical, but having seen just *how* many there were, I'm a
bit sceptical.

Because if people think splice is complicated, you haven't looked at
the skb rules. They are completely arbitrary and complex and spread
all over the tree.

               Linus

