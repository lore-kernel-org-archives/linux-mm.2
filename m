Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77F78CF6C1D
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 09:29:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E11D76B0099; Wed,  7 Jan 2026 04:29:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF3A96B00A2; Wed,  7 Jan 2026 04:29:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D13286B00AB; Wed,  7 Jan 2026 04:29:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C1A726B0099
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 04:29:25 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 97C1E1A0223
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 09:29:25 +0000 (UTC)
X-FDA: 84304644690.07.7A6BD31
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf23.hostedemail.com (Postfix) with ESMTP id A154C140002
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 09:29:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="gX/YIXjL";
	spf=pass (imf23.hostedemail.com: domain of mattbobrowski@google.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=mattbobrowski@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767778163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qAmBFvHljQCF3L3oXr+WZULma4DAz/lJTXBequgmr24=;
	b=YB+vKefymQgbjV6ZZuzG2Zbdj3TU0VnvY/yMHjOmOEp8xd2yoZZqo57/J92gwKcoHef6YX
	4dobh/ecqYRgWJFLoEyOxDFboGQdPywCij3aPVFT4s+oEd51pUEMXlyaasJ4I/h/PB+7SD
	BVAc/919/zbRxOP8WHuZYepSY1UpgMg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="gX/YIXjL";
	spf=pass (imf23.hostedemail.com: domain of mattbobrowski@google.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=mattbobrowski@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767778163; a=rsa-sha256;
	cv=none;
	b=AGnDPK5x4QU16512HqEsN0v6KmcBALFNNOeJJfK+ECDV9TXiuJhaTEYnaD0D1Di9i9s1rm
	c54shodZMOx2P473/NejhXbFj6Ls3qCaKFhMs624ofLiqq1FMB1+VXgqpHriuJP6o8fcIH
	lK3lw5pBvY97LWwlokzcvm/Thh5rM9U=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b725ead5800so257762166b.1
        for <linux-mm@kvack.org>; Wed, 07 Jan 2026 01:29:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767778162; x=1768382962; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qAmBFvHljQCF3L3oXr+WZULma4DAz/lJTXBequgmr24=;
        b=gX/YIXjLA5vnDSF8hF/EucYt1VcevubGTMV7PVTE3+pa7XuxKCqmS71FWUdF8YZmZW
         Tc+XUfjNHK0pEETb2lDoc7BoF3zwap5tXZFVdBaZd4zuOnlCXEE5QCsNl65fDQ1OYWqb
         eQzMQCJStqrAtbkTwbLCOKZMdYBmBhYQI+ZmkceJmUDwBsasBcYWPS6t0PwkNJvHesnq
         lGcFP9u5psKK/cAq7i2xB+NTXrLaP5E84lQz9yB1yNsWCNrwfcLwm+1YD3EvB8BwdbCY
         S7rHFLMkpc3ME7c5EFIkZb9ccg0piGpTIWt9pPVPG2gFyIjGnCtbssw7JtHsynHtQPDe
         PQ1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767778162; x=1768382962;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qAmBFvHljQCF3L3oXr+WZULma4DAz/lJTXBequgmr24=;
        b=pieWrmKecZWXJfMZCMirITrYxX9WVU8YzFX3RYJQ6zqUTEY2dpHbAvW6OWUAHquAzk
         cINE1f7HQVIg5MbLPIODz4q/W1gy1oGwUZtfwsxweoAraLXk4hEWsG2kY/1cDgGB4KZO
         5iBhlsJujcmvHp6x4oNF8aBSQJuAn+rBTDtEzLnap4yHRrbXWK0e/Qm5ZD3paHTEY5Jy
         YgUC7+bD0d91oBB7VPqbBer2P9eJLZW4v/t0bzegOfwlBlu5oaQGGvFnRQ8XVXTUp9vO
         i9Dd53Jwxsry7ZeElngXvDTgkrOEa1WnQg1ic+lZkPwUEu/LeJ8OHJvK8LliRgN3RAqY
         b1tg==
X-Forwarded-Encrypted: i=1; AJvYcCWWFSs245XudTXZRdYHrJdoQhEc8yXx5bhpGC5SKEEIGIGF0i8b79EJnyajm3rEQgNA0ZpTPD0P0A==@kvack.org
X-Gm-Message-State: AOJu0YzMC+oz6c4uVk/Qw5S7zMPalvUy3YUCYc9B+gVB1EJIKKoEAP4y
	8M4SDj90pBLUI+R6T+pRig8GigsQxPajdy7iAW+1LbdZ9LE1qifUhQt6K7g3KCqxzA==
X-Gm-Gg: AY/fxX41FwN6H/oOvvlaERvmVwJTQFRY8732YwTBia+gt+yjbcLQq3iggU1zgK1IFUv
	bv0fViponyClrYuSm3DWGMoYocm7JKJn0Z5mENiMeIN4FGDwc4MCc/18u3SvEbQFo8rWqjaqow7
	62MTXP/f07j02T0gPRFTOt6PVkNuTq2lTl0IrG7UnhdJjrUggSAVKlcjce32JGYsix+3cL7QZKv
	MECe8/SU8ev7DFK5sHKHYwNZ0r108718hkXkx2idtHFU/5BsWT0lUL+tcZa7WOiwCIjNxXYXl+e
	Y5M8E2c2IJMZZEaDR18TwfZWTwg7D+y4QaXP4Cvj2c9wzyCw6XAKxTVkNStYL+JMvSalBURmyAS
	UC7DPervojzuFpYWeK2NaFnAtEfwhAQ6ch3GdlpDYMaJ8yQgLzIwBRdVXeXd2MTESBYl4RZm4LU
	2M8dgFaYqBQaAMESwOAloRlKfYCO7cY73maroTyxPd7f83fMmuO69Gug==
X-Google-Smtp-Source: AGHT+IEZ569HZDlJCwAETH6UvXRvz+tkMRRxeKTBnNpUb4XcosV6KbxuzsGMXy5rQgg3tcmEAr8VOQ==
X-Received: by 2002:a17:907:cd0e:b0:b73:5b9a:47c7 with SMTP id a640c23a62f3a-b8445413775mr187603266b.51.1767778161682;
        Wed, 07 Jan 2026 01:29:21 -0800 (PST)
Received: from google.com (14.59.147.34.bc.googleusercontent.com. [34.147.59.14])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b842a4cfd97sm444211066b.36.2026.01.07.01.29.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 01:29:21 -0800 (PST)
Date: Wed, 7 Jan 2026 09:29:16 +0000
From: Matt Bobrowski <mattbobrowski@google.com>
To: Kumar Kartikeya Dwivedi <memxor@gmail.com>, g@google.com
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	bpf <bpf@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
	LKML <linux-kernel@vger.kernel.org>,
	JP Kobryn <inwardvessel@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH bpf-next v4 3/6] mm: introduce bpf_get_root_mem_cgroup()
 BPF kfunc
Message-ID: <aV4nbCaMfIoM0awM@google.com>
References: <20251223044156.208250-1-roman.gushchin@linux.dev>
 <20251223044156.208250-4-roman.gushchin@linux.dev>
 <aVQ1zvBE9csQYffT@google.com>
 <7ia4ms2zwuqb.fsf@castle.c.googlers.com>
 <aVTTxjwgNgWMF-9Q@google.com>
 <CAADnVQLNiMTG5=BCMHQZcPC-+=owFvRW+DDNdSKFdF8RPHGrqQ@mail.gmail.com>
 <aVts9hQyy-yAjlIK@google.com>
 <CAADnVQJr0WqmqA2fQeC0=Jn5F-ujWmUkL-GfT6Jbv8jiQwCAMw@mail.gmail.com>
 <aVwnUUXmgE1uOOj4@google.com>
 <CAP01T75ATFb_gjy5_fSwt6=QMxt7kGSS+12SJN9rz9SfJQ7Qyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAP01T75ATFb_gjy5_fSwt6=QMxt7kGSS+12SJN9rz9SfJQ7Qyg@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A154C140002
X-Stat-Signature: rw9gj1c3ui9bpi8exdgemg6eif86jqfh
X-Rspam-User: 
X-HE-Tag: 1767778163-428800
X-HE-Meta: U2FsdGVkX19bfR/ozdkAP6s14xObF7Q5r7CKsJnwfyJ1BcQK0vZT0mcKhFn6gSDlspU+F7Gz0NLpg2u3AQEjZKeHB1UpWxwgO2UB4qyU11eYhi99g1zev0ZwqwO+viWZSSkNLSZvazlTjVYkVUR/Ir+SPaNa39uOQn+M/SY8PRIWW2woBqCVrcyVHXt3QlPpg0JoD7MeMJn1HZ81Xj2/SQSEo8MHBX7RjsHQM/MU/6hJXdxwbfGb1JyF4psjlV3/DCctAU3tui3gVEbLCBWqeME8w6jopoTNKpWTNDAlP+2kpM7G2mXF40u6xRRjbSoDv2sC1uccFFo5+JnLg6eIR7EeGea3PSUESl0D/IlJ8dQa6x+936cCJ8w1SjAL5CNQ3L47W7QqvLEpX1+/1fScKSFS+SvItUEcoWuX9/PDEYTzExPYYowRlDmsJ2TTyYXT+2fjnI29k7UlOSQY0/IZZ1t8N4Z5p9fm8Uw4aYg9ssndCRp8txnNqmWzmeVxH2jy4V87gnoTi2jKQU08UzTkelBH21azIWJdkEWDTvmShpsLApIagnRlIv2qgZSb5yQx4pRzhQm7dqJyGIH/1s4wgEyLqnbcD8yM6Ti/EuDVSxbFeXGHAN2UyaHhGI/lxnrpvhFl6fPhoyHcQAtN0ieSFQD97vaC3NwOVM8Onw2nnRlB8utF80XWyqQ1bnNxeuq7Zfq/OUt9Ne8dye+5R++G7QlUz3v7p5MWHBGP9lXyXVl2/nySLFGHHqmotUc8PGYr++vHrjO/awvIneNZsBufAgqRqPKqi3ctJj4lzBZ55Bu1mbRARp0dED6eK7IPjcxNy9VdivLsh99atdWf+xfej7nDS7nZgvsVHNw00rYMPTUbSI1B5PUXfqwGV8m9yWDvexkKcJ2wWcCRz0zM3IcdjWP5a1fZvhz8e4qLEGjrVmjFM4HF6G+9W4lv+sqQnSkrk+xcE2ekzBeNeeP1dvB
 qFKbukZi
 +Dw51grPgiTbwh9wtZ592QLNFZnznhZCDZfyttizA545v21GKAwu5JWzJWEa/5Bv65ptGq9qTKOJCM3adOy31PA2tZ1otTukzA8JSNSx9+eIbQ8L+IyYkJjrDVXrisPyZXqsTKos0HXveTUwTXzTyOkGkj0OCYGVkfq8LIA8/6aqSi8TNN0qaqhx7g5S6Nz/bmlU4jGGQbv636eOLmg3QS7G7YVxiIQcjqHOj0WZ15cQpvgHYJuoSXmtt6D9L9P6SnC9YX2c9k6C8yqLZjcmHpR0zadW/Et3Bu/6kUqrAWz+CZTNLbAzrf8+5CGiGFiT6yohIouBq+ChTxwTJhXVpp51VgpHHLHBzKOoImAerlnvjKq8LHcayxSinWProJlMvwPqZgfBwBErOTJVg+sovw6FHtrCHrXp9j7WTYtoyW0RoONo2p9/CBBiuMbK+81CbUq9yjFYp8Ktv+2mfoPup/9tl5A/8yFJokOyAD/OoDbBUgnM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 06, 2026 at 04:13:24PM +0100, Kumar Kartikeya Dwivedi wrote:
> On Mon, 5 Jan 2026 at 22:04, Matt Bobrowski <mattbobrowski@google.com> wrote:
> >
> > On Mon, Jan 05, 2026 at 08:05:54AM -0800, Alexei Starovoitov wrote:
> > > On Sun, Jan 4, 2026 at 11:49 PM Matt Bobrowski <mattbobrowski@google.com> wrote:
> > > >
> > > > >
> > > > > No need for a new KF flag. Any struct returned by kfunc should be
> > > > > trusted or trusted_or_null if KF_RET_NULL was specified.
> > > > > I don't remember off the top of my head, but this behavior
> > > > > is already implemented or we discussed making it this way.
> > > >
> > > > Hm, I do not see any evidence of this kind of semantic currently
> > > > implemented, so perhaps it was only discussed at some point. Would you
> > > > like me to put forward a patch that introduces this kind of implicit
> > > > trust semantic for BPF kfuncs returning pointer to struct types?
> > >
> > > Hmm. What about these:
> > > BTF_ID_FLAGS(func, scx_bpf_cpu_rq)
> > > BTF_ID_FLAGS(func, scx_bpf_locked_rq, KF_RET_NULL)
> > > BTF_ID_FLAGS(func, scx_bpf_cpu_curr, KF_RET_NULL | KF_RCU_PROTECTED)
> > >
> > > I thought they're returning a trusted pointer without acquiring it.
> > > iirc the last one returns trusted in RCU CS,
> > > but the first two return just a legacy ptr_to_btf_id ?
> > > This is something to fix asap then.
> >
> > No, AFAIU they do not. These simply return a regular pointer to BTF ID
> > (PTR_TO_BTF_ID), rather than a formally "trusted" pointer (which would
> > carry the PTR_TRUSTED flag or a ref_obj_id). scx_bpf_cpu_curr returns
> > a MEM_RCU pointer (via KF_RCU_PROTECTED), which is somewhat considered
> > to be trusted within a RCU read-side critical section *ONLY*.
> >
> > Kumar/Tejun,
> 
> Yeah, they don't return a trusted pointer. I think it would make sense
> to change the behavior here by default.

Thanks for chiming in and confirming this Kumar! I also agree that any
BPF kfunc returning a pointer should be treated as being implicitly
trusted by default. I can't think of any scenario whereby a BPF kfunc
would want to return a pointer that'd fundamentally be untrusted, but
there always could be some exceptions. Anyway, I will work on this and
send something through for review soon.

> A non-trusted pointer cannot be passed to kfuncs taking trusted
> arguments, so hopefully it will only make things more permissive and
> doesn't break anything.

We can only hope! ;)

