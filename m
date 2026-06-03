Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 361ABCD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 21:37:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 638876B00AF; Wed,  3 Jun 2026 17:37:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E8A16B00B0; Wed,  3 Jun 2026 17:37:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FE926B00B1; Wed,  3 Jun 2026 17:37:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3CA396B00AF
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 17:37:19 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D8B12120542
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 21:37:18 +0000 (UTC)
X-FDA: 84839912556.04.CEC3142
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf04.hostedemail.com (Postfix) with ESMTP id BA4C940003
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 21:37:16 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=FKGuiYdh;
	spf=pass (imf04.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.210.174 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780522636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jlzwef06CJIrE3LIQnd2Z4dg96b07Ks4mMmqsV33wA0=;
	b=8HI5KCVtg/smSX+z2REGIyHizJK5jHyhtWHN9+Omli+iYAhCjoH+DRSOQFont+RknuTrt7
	9j0A6tnWTXfmhRxri3cS68OxYGkXngGlbDYP2r7rVcxWjqongGwMwRVrN/ovfbJGilE4Dw
	b/gruF1QN5iWS32I/83sgQ6XG/PO0ao=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=FKGuiYdh;
	spf=pass (imf04.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.210.174 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780522636;
	b=6HDMQ5s0Z8f46W04jQph7cgvSdTFVS7YxO9oz13zX0No5xrYNh1LypTM+wIlgd4XonMSQd
	5s9jc2FgzalG/fMo5F4QWCAE/q4UJwOUbdTjUWebED82IvMYfYZToXTrk8q1LahLHyUuO2
	tCPnK03caoKMpkanzB3cfWAf11Kie+g=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8422871b42dso2228b3a.3
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 14:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780522635; x=1781127435; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Jlzwef06CJIrE3LIQnd2Z4dg96b07Ks4mMmqsV33wA0=;
        b=FKGuiYdh5GWO5NJQ+wGz4psVERq6/EwhdtAVHGpPG93N3iRdsCuYmZOHw+J/AEiSKY
         Rh1cc0GgC3VWXFscKHn3uWRNoQcpvhgnxYGelr9wC4Fb9FXvXhzzAoB7kfUaEREiaLTf
         Vbn4A3kNgitcqpzfJd4AneA/3yaMXHjt8UBBs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780522635; x=1781127435;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jlzwef06CJIrE3LIQnd2Z4dg96b07Ks4mMmqsV33wA0=;
        b=bDaBg7HWohc0NLyK7rUKLAkgkoW+oFz7iQr3SNSMdLKixp/Jw2ifoG4kVmFx08yxzL
         1hQptL53OHtP0H/dQqhGZ1DqFY+1bEbAUeIGZFFfTb8VVOfeyCGjzcvd8eYGGxOtOWVY
         NBlzUJN0iqsXuENxWzY7uIXenynB95FRKweJd10VM1VlgUnhRVIGAfrY09uMaFPZufpt
         fXd6SdUBAYzzKg535lmP9j3QiYQF5RENUv3wTV8lu7V/tPX7aRZASk+biBAHrVu6q2Lr
         dCl7oyJqNwpvOegWABVj5qtcjfJsKp9BFF4lO/o8bf6IsFy1I0zT1LBUminQrUhJDQLp
         RNbA==
X-Forwarded-Encrypted: i=1; AFNElJ9KxQlYwDAbqiv+jr+i0M0mSWeP4VF8TwqTf8BJas4BlPApT+4xrmjnyE/si8OJucHWRXlfGj2QPA==@kvack.org
X-Gm-Message-State: AOJu0YwnCba6ov8wsiNbTH+y4s15smolSg28E9O0vhEm2tJ8VLBkDi41
	KyMzXmtHO7vK8LUm6O7fPOyaHy15T0kBO1ZV5x/BiKgM9rpGNu+7g8Yhz2FjzijP6hLMS2vtqbj
	E+x/aKQglLA==
X-Gm-Gg: Acq92OG9OyTePXPc/S4oZ+tNlrAmLS+Te6sQfEK/2f38yEJXw66+fvsoXzfMGPutTqe
	/P1KfYjWJ4VSMwVTzHa35Am5CSZqzvU/Yy2KGqZWd3E/YidngM7kTciWicM/lGYiBwAE/5wf10D
	2TYHkYSAG1wN1AHJihafghibn5RA7iU9gmwtyCcL+ADw1siYTkFr0Pafs1savLcFK7aotR/KHN8
	g2xkQqwf9As8jv6H1E7zsJV04VU7KhPRLAEJuDwa0tLMkNF3kMzIqdVingv67B/GivOMDx+2A65
	BUn4gZJI/ql4KfJ28kk4DsVt87HvuUzFOJr275TF67lJEMN1elsVPvqwZZq3N5xexZPfDQE6AOs
	eu0mkJg4eJiZUgAYXDthk2e+oFG4ANiEBMsd5LfouSOC4E6//CT1ypk6etqUncAeDsxCV5R2gER
	8KqACTKgceWz86Vsps9jPTMUd/raRFbMLGn5TxIewZQunnAMqnNGnV+93g94J/qDR9hQuKDI7hB
	vxjd3iZlIu0AfacZ0+m2yfrmg==
X-Received: by 2002:a05:6a00:a222:b0:842:7867:430b with SMTP id d2e1a72fcca58-84284e8dd18mr5255872b3a.29.1780522635379;
        Wed, 03 Jun 2026 14:37:15 -0700 (PDT)
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com. [209.85.215.169])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-842828e21c8sm4679446b3a.49.2026.06.03.14.37.13
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2026 14:37:13 -0700 (PDT)
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-c858b392697so11037a12.3
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 14:37:13 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/ip/JiaLCbgAhVHq3q+5yWnl1oH8AYRAQvC5Pxyg9M69pz5k2gFEq8dw6KxIQVkJd4IS+PhZfGfw==@kvack.org
X-Received: by 2002:a05:6a20:e196:b0:398:90e5:a9b9 with SMTP id
 adf61e73a8af0-3b4978a0b2amr4845639637.27.1780522633187; Wed, 03 Jun 2026
 14:37:13 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com>
 <20260602225426.122258-1-safinaskar@gmail.com> <CAHk-=wgKy4dP0oQCNKyMQQf3-uVpaigmDyH6_T0Via76gWST9g@mail.gmail.com>
 <CALCETrWx8-Q5-rK1KnAPCxCbXaWCd=Yfs_Pr8qVMa8k8L6of1w@mail.gmail.com>
 <CAHk-=wizkDXRut5xLXRF-CVUVYMaZ5AOexxeghOAoXPb4yAvQg@mail.gmail.com>
 <CALCETrXzxubt4eWue3+wv7Fq9C2m7uu6bWPstqFh6Mo57bPwQQ@mail.gmail.com>
 <CAHk-=wiEwSjfbjfO74xu=UmkkdHXkJg5QNQ8pP-3iYmunmeV9g@mail.gmail.com> <CALCETrW3XcNLuB1Y6PSkxQDSK2o+=EB2AAd25SjWQqcJemwnbw@mail.gmail.com>
In-Reply-To: <CALCETrW3XcNLuB1Y6PSkxQDSK2o+=EB2AAd25SjWQqcJemwnbw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 Jun 2026 14:36:52 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgn3QTLj+F+XccE10dXY-UGWN8+fNLEvhsLw+tik9rOmg@mail.gmail.com>
X-Gm-Features: AVHnY4JdHVy7zfm3YSY570fWNlTEBH8JxW4P9TvGYREa7sUrzYx92vQNA-k2Zxc
Message-ID: <CAHk-=wgn3QTLj+F+XccE10dXY-UGWN8+fNLEvhsLw+tik9rOmg@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Andy Lutomirski <luto@amacapital.net>
Cc: Askar Safin <safinaskar@gmail.com>, akpm@linux-foundation.org, axboe@kernel.dk, 
	brauner@kernel.org, david@kernel.org, dhowells@redhat.com, hch@infradead.org, 
	jack@suse.cz, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu, 
	netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de, 
	viro@zeniv.linux.org.uk, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BA4C940003
X-Stat-Signature: yyn1ocd99ww9sqitptewzkagdqpwhbgj
X-Rspam-User: 
X-HE-Tag: 1780522636-193602
X-HE-Meta: U2FsdGVkX1/HlHIdt2z3p5DBiUSCWp5b+iWLQn5rMptHDQGYDdf/zk9/3ZOyXIN7adGvqYX8dRLHzCcLen7G0iEDfIverKc2m89JEFykx8rysJIVMLqVD21vvwLlk70vOa7aTM5VKLIrnu1NKlhVnEEVJ5ZbyH00NZNyaZMUzBnJq6n4UR/8JEFZ45sOCGZNmHSj5LTszUY+4VSHCGTNzan8dDeQALeFR+Ds7zyQpFplBCbARBiQEgFcArfYBsMXpsVH9lVUdKpZErhZC7+7I5G1bP6inetx6/VZ8kpwXS3ii43fnz6+XdowwCw8GC/24SPgbiJR/9uxOKaTa6U5CoBUs7G+6eP6u7UtkKn0cWE8zhfDLLgoNQa3MHQpZcUgemW6diG8L9jXaMi3RyfraD/dWnahQ3OagpM0rTsrqn+4j89H5F6enOafjdCMZJaNllHuyp2A6dkOkXUjeM9tj0t2rsDCJwRxyeE2xD71jt7yiisrxQ6Lfj7TDVZ90u2hWpqSGOo+5nz+US2bpbDqJLfJRgtQviDBB7Z6fghbaXDPwTy0y5/fPnLr9cVNwPUyVzLzLRzbjkQgeAwHSCEf9+bJyyacTd63t3957wI8fmlk7CrSPY1D/BDgMQmTgJcq66N76TE1521OFIpWVrPbcoI3aqQohaWjOJbQG594fxHSWyLoO81X3eyC6CUyhsF8qhxhFVFNSCW6YeKX0rNvg/w5eFMKDPCxt2DZilpeOUv9ao2qbe9HequdTRYGsCyy/0HQBtELRepnHmKr4mokMF0mjN4SGXgJjPztcxZuK50PdbxVmXyvifixeB6lx9DBSlLWrC4NtRA69veRT97hzPdicqnuX+qLwQ6fp+GyXX9EvvNjp3gjkvbpYeUE3RBLUEbpEkNBD1s1FviMYwFDNEP7/hgHqZoyvdV1QrwQUs1oMHZXf1267HEQ8Th+0db7wg2c/791qOZj+Mpk5FR
 AkYPB/V1
 4NPNlTdo6uEqhbX1EK2EEVaPBjVSPaCUG2J5x3Q2eI0keVJAe3kbP9QVVe+TUg++EXs7FOnjnDHCaBgey17LTSdtLwry7hIdLxw8r5JCLGUzCSqsQbgZatg9DdXPbQd5akSxmbvZaOkoMNFgGqYZUHxdY98hwyHvAgNVR8TjgIMhy21ZKI75CLdxjSJhID2tESMjI6YTaqUrv44WIRifk89S+DQSuPoFmhQDnKEUAAVpZ/ZXhR4H4HPHTIq6wBLn69p8pzsomCS9+ZVLOAXswt2o0dTYybAyg6nx68PNe5sAqNbx5C9R4VjzY2SYCHl+ktoN32FUFwL+tJGgZ3lh6n0gSKMv5CndfjnYFD70coKKmRtjEJSEMcyAJaPMkTcMKpF12kJ72vzAA5lN8NoUW1sgcXgGGT0NEhpzWoHlhrtd3ccgRe7zlHVxHgPnSAKTsz8S/W/1UYjXUNqanaRYWc8geTxCBI/Hy/frhELYXCgfq8qrX7UMVjCnTbE8C1gsD5OhoPpeHS9ZFhMTJZjaB83q/Tx38X67V7JG/I9QVY6GHEMLgB2kiimcDtpmSCUa1E+sczyH3vbvNlP4DwQXb8XQxn3rdGWOqROM+Igoso9XU54AdvG6aGX9jR8lO5x2FXofchup1URn783IK9VQxpPdkrw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 3 Jun 2026 at 14:31, Andy Lutomirski <luto@amacapital.net> wrote:
>
> I think I buried the lede too much and you're arguing against what I
> was trying not to say.
>
> Maybe we should keep an API that does an optimized copy, from one fd
> to another, that can send from a file to the network with at most ONE
> cpu-side copy.  Not aiming for zero like sendfile / splice.  Aiming
> for one.

Oh, absolutely - that's what my completely untested test patch  basically did.

The user space interface was still there.

And the networking side still continued to use the ->splice_write()
thing for writing to the socket.

It was just the filesystem side that basically now instead of exposing
the page cache directly (with filemap_splice_read) now only exposed a
*copy* of the page cache (with copy_splice_read).

                  Linus

