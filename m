Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5015CD6E75
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 17:38:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2202B6B0005; Thu,  4 Jun 2026 13:38:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F7A06B0088; Thu,  4 Jun 2026 13:38:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10E2E6B008A; Thu,  4 Jun 2026 13:38:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 02EBC6B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 13:38:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ABEED8C7AD
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 17:38:34 +0000 (UTC)
X-FDA: 84842939748.20.BCD21E6
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf19.hostedemail.com (Postfix) with ESMTP id AD81F1A0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 17:38:32 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=M7Nj8ryM;
	spf=pass (imf19.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780594712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aDxRgk4KLva6cv7jp07s/JuZGm0Suw+6/YbYX6FRPfQ=;
	b=I5GJ6VGzGa6aVNUxyW3z8BtJc6KklIUo6Cf3Sg0J3DovYxB26nJyY++lLplC4jxuz/MO5B
	rkBdofYS4cprIbg8ml5LM21wsqJoJNKOZQplVuX9Xxci7l7+fqmHD9TXieGL3BoT9KmKAT
	Y6BFN3p781Dkf+OsN4xoK4w2aswKu7E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780594712;
	b=fahFkX9NHAhhNvmSIbRR0JFEhE0m3zdsPv0YQNhaCepFeAV7PFT1HhTM/UJ20TtoM1XkRw
	/xYLK9W0uih2YlZx3bfFHjtl7eU48k0+TPzAylFwNS1vUxPAhMGgPQ7+pO5nL+SQyi10Ad
	woF6Euz0unjJ9rVNuQk2KNjpnQ7E3gs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=M7Nj8ryM;
	spf=pass (imf19.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-490b2b037d2so9166005e9.3
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 10:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780594711; x=1781199511; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aDxRgk4KLva6cv7jp07s/JuZGm0Suw+6/YbYX6FRPfQ=;
        b=M7Nj8ryMxzEt8+7w9sMevAfjtgeNqnm6yVad/v7dTT9qdFE8y/SpwvKGJY0o6QUz+q
         SmtunqHE3G5IqCLY/c5E9u0ujYbHIFGUCeMk6utaIsLXEVdaHsREHWwoejZQrmU379yc
         eaiD3BHWskHBxZbU50fplIQvwo1gERi+P5hJiwNG8pOlJhuvu1r3tiEV1qxvy40xGKgt
         eLFRLoHq1YWnh8pDJ/6KbaOmvwRMAZBwVsuhlk/8TcFBlisWMheMIJM0yv77PpDdG19I
         apCUldpcCPEmCoNnrD2ZQx3GbBBA5qxCWQ9pfqtUSnAXPvutezm0DQWiyPd8NsY25cK7
         WMzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780594711; x=1781199511;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aDxRgk4KLva6cv7jp07s/JuZGm0Suw+6/YbYX6FRPfQ=;
        b=Og3XVLAtJfM/UahWHQzTmRzb5Q928J7QAGnq8OpKp+M5qQEcg7awI2noQ0nunLtOS0
         vNKEpKYzahck+CEVO0AJPxpwXVGvSdru4vHVhTgbtPRL+0aTC4akEbsJpFzrwt6EKGzS
         6tFReN6FEBvXstEfQWz5JYAZ42TveFLuhwzlQ1rcZz/ux3VnGXfLqiqVBGpiXYklPuyQ
         WJz5eJT+uc6iwCIaGuGwpQQkG51pTDQ60kUI6GxBrkJagogLs2OrQyl7dpS2CVS7VtwF
         XPILndBhL/iU+Vw3n4/Lk+47xDsWuqNJjHsZ4A1JmuC+XUrG6zUuAZY7BdH4fY7CZOLv
         XBjw==
X-Forwarded-Encrypted: i=1; AFNElJ8IUdjJemKpKf8TGFzGjNJnakm3k5NXCAs16schj4Bj6BdsI8ITj+33f5xFqe28EGy6G0uVLgZCNg==@kvack.org
X-Gm-Message-State: AOJu0YygbuKnazU3TgS/kO0gbg2C9D82faQLWOOiVVM0RoBmAFd9a5n6
	Aw/TJ9uifb6A11VqztctXeJBVayYZrhKdEQ0t15aCk6EwRolAoqS7k17
X-Gm-Gg: Acq92OFcpXWNyAzFdNoAm4nTRaZj6HhYMQOzmCw6jj22K0zNMBKnXRVUYg3QKuPGONw
	WwBzre2l/NW/ckRFjg/HllOcKsraXN6v++w8q6vy6xKwhu2z9KPR5JTsAElBrbBlx0J0hZY59Yb
	XMD9nunAl/+OkCXq1RoEom1U5CG+zs70eUqpIcXZMr7BBtXcAHH0yfuA3ni++KdNf2Qv0KJ2vHT
	/UDx1qV8RSgO6y6OXhzj8+AD8Ed3WcG1AiiC9VLfyc+alIkkbHsGogT2voJRXfBB8ZltvND209P
	pqbyl689wPJ9XGy2nsF7BsmR4c2yuDsT6YJxMXPr+vnMUWs3C4PqpEmVBAHWbTIwZdgWfIctth6
	FSzqIA1p93NSIOTzzU6WCkgE2Yp8TJhjoULsa+BiXu2kOSrADi4T3HqjnjbFTdZaSB2v4BO7dXZ
	GGwGfyzte9clNtTWY7fEKtQK1f/I8WNH3pVW8jpBvfCOvP1mejqWg8bTlpcNSUi8WwDi6ubKA=
X-Received: by 2002:a05:600c:1c13:b0:490:b642:ce29 with SMTP id 5b1f17b1804b1-490b642cea1mr153777325e9.8.1780594710934;
        Thu, 04 Jun 2026 10:38:30 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3cc140sm105657875e9.9.2026.06.04.10.38.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 10:38:30 -0700 (PDT)
Date: Thu, 4 Jun 2026 18:38:29 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Askar Safin <safinaskar@gmail.com>, metze@samba.org,
 akpm@linux-foundation.org, axboe@kernel.dk, brauner@kernel.org,
 david@kernel.org, dhowells@redhat.com, hch@infradead.org, jack@suse.cz,
 linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu,
 netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de,
 viro@zeniv.linux.org.uk, willy@infradead.org
Subject: Re: [PATCH 2/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <20260604183829.63c35fd9@pumpkin>
In-Reply-To: <CAHk-=wjvb56qo27-axALOKCY-CjLsj9_294zeBovPVJaYm14dA@mail.gmail.com>
References: <f919874c-065e-48be-ac5b-300c4ab86d4e@samba.org>
	<20260603211736.755139-1-safinaskar@gmail.com>
	<20260604100609.6b37f500@pumpkin>
	<CAHk-=wjvb56qo27-axALOKCY-CjLsj9_294zeBovPVJaYm14dA@mail.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AD81F1A0005
X-Stat-Signature: y8gtonh7k8n4oj9fweuur5wmjhopfohn
X-HE-Tag: 1780594712-801732
X-HE-Meta: U2FsdGVkX1/RaQ3HNTiSfNpsDHRDS3+FdHQZ8/OaUfRG/89H4AO1UYubVDo+h09IbxUHKAdl2Goo7jutH2NCRliIqCcHgak/dMyU+cWQJhDyHEBryo78fTE1DM0x6c4jrOc89qXRvmy7QjK6W5pfzVJtQxtev74aInL7PT8zhDA2B7/xhF3Q+UzwUICl7lBVSTFRUBMrBL/Dqyb1AaHAj756+pq0gf7TnUjDx7XnUa6x5I44xLoZkcO14EtxKxp97HkVOdrdRCeQ93lsXDTPu1s4vJqiBIz/b+rDimZljsfjkZr8ZQT+ueo3TFEgAO4RlRZdxmBblsuZqiWKf6KWqGuSwOi3rR+Pik2ORQ04D/xxpLwpGt6G863/kxovd0y7abw3RmTmez4X+VB+HnXoQHdzS4JYvQBOQPrQLzRcbhrtSGIWl0+5kcElh/5cEA1PwfEjkdr7Qz7HkIgnNL7LkM+AogHVV3EtVgJkyXkKmq6MF07WhSaQFG6xFgaIBjPyH2I5Y5NQJSd9L3tGTa6kxUHjwXH6jzBKW3+Xp99CewO0bh6o7wO4ovI9/LFpoa6zkGXuEpY6M/IlPnvaEzdsEL28jROAonKbt8fIwFyTISnf91YY71EE/wV+xXA1ZUpe8ekWoN/HtJGlGCDF33Hr8V4UCW18O3nhVoy16U+5iM1nBmNfm2R5Y1xCwrsAWeXEv5+wNVmGNj2M+XAQ5ygtZC4TX3SEfGEYuQh94HZCpx5is/qiq9JIkqxAQ1svjFPAWyYKH3ehLsfB2/6haliMHKWZF9aHOz6GvnM17JXUmUoktkbQ9ZORwT0Z5FnZbyUiXVjEny369RUSPkP37st16fUAls/AR7hesjlflSpdHZ6w3sTBYIe9dOGEgZP2+v24dNs/N8DWXdY9s9j8UPoGOpRLU3kcAyvrcHAloIL69BGynMAjAtLGQ8tTxxjSSXSbvz4RHmRia5z/RcKjVyp
 XIdDepst
 qSGmJcNBozNoxFRGJ6jvpO8mgQ0I80atqpx93yzIs79gJ04KBUeE5/7AU11kyYZU03UH99y2NgpqAhR5VDCe42DTK/bDA2c50jvRFOFz22OtX68eGKmmb6tzZLmLnQAYZhJwLNaRjvUjHMdGVCm9SadyWaTH1h1BayrozmbojdDu1csMkhO2kuBCfGTTaXkqCvJInPYsTGFWn424gGqbaAWTDF1nZK0+StCFSCtpettA9ijre/Lzwf8ZnvhMncProCJs3iMJpKMAeaMX3NeH+0B33NtRLcp4aXjPLr9psOLZmWFLMh15AFYZI9P/UcXvLkCIsrgJ8meAXA788xJGabxv88aMVoziUdr9a+zETXb7lQM/H/tR0SwTte3D5hVe45R6aZBO8PHQC60VXuK2DYpZ5opdRj0TbFzkh5dswDRuLhDObSXHtPk2GDrYWgFW1apzAkUiCVrL0SgiU7jb8/rri3oCTXC+JRsjDaxSvprD1XeSZZpBp51WrTCJUQQA/95gXaE4HiPp8hr0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 4 Jun 2026 07:17:10 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 4 Jun 2026 at 02:06, David Laight <david.laight.linux@gmail.com> wrote:
> >
> > Something needs to ensure that the high 32bits of the fd get masked off
> > on 64bit systems.  
> 
> That something already exists: CLASS(fd, f)(fd);
> 
> It ignores the top bits, because 'fdget()' takes an 'unsigned int'.
> 
> We have been a bit random in how we declare the system calls in
> general, and we mix 'unsigned int' and 'int' and 'unsigned long'
> pretty much randomly when it comes to file descriptor arguments to
> system calls.
> 
> fs/read_write.c in particular uses all three cases with no real logic to it all:
> 
>   SYSCALL_DEFINE3(lseek, unsigned int, fd, ..
>   SYSCALL_DEFINE3(readv, unsigned long, fd, ..
>   SYSCALL_DEFINE4(sendfile, int, out_fd, ..
> 
> but then anything that uses fdget() (through one of the helper classes
> or not) will simply not care.
> 
> Does it make sense? Is it pretty? Nope. Does it matter? Also nope.

I know it has mattered elsewhere, and is easy to get wrong because
'mostly it works'.

At least u32/u64 is reasonably sane - the called function has to ignore
the high bits (at least on x86).

Bool is another matter entirely, (IIRC from a couple of weeks ago)
gcc will assume that the low 8 bits of the parameter register are
either 0 or 1 and clang assumes that the low 32 bits are 0 or 1.
You can't even check with 'if ((u32)bool_param > 1) error()' because
the compiler 'knows' it can't be false.
It all dumps you down one of the UB 'rabbit holes'.

-- David

> 
>                   Linus


