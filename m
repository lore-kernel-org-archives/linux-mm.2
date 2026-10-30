Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99A60606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 11:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iXv5lIU5
Received: by kanga.kvack.org (Postfix)
	id A912C6B00EF; Fri, 30 Oct 2026 07:08:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3A556B05B2; Fri, 30 Oct 2026 07:08:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94FE26B05B5; Fri, 30 Oct 2026 07:08:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6CFEE6B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 07:08:54 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 11ED9C0691
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 11:08:53 +0000 (UTC)
X-FDA: 85379020146.15.27A80EC
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf23.hostedemail.com (Postfix) with ESMTP id 28D9614000C
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 11:08:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=iXv5lIU5;
	spf=pass (imf23.hostedemail.com: domain of olsajiri@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=olsajiri@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793358531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gdeCa3x7O2p6X4CzDfNArZvHnuzUnaCRCf8ceCdxpuM=;
	b=HYhdjE+yu72HsUVyAkyaH/7lMOZaFsjyG191EwZreoZbw1NiGpsuWRzpPVBSmdTKncIGM6
	tUn4XYQutRww+t/vkU7xyBLgADM1ulo1zZiELs4qzHHH6rtnkGcXkGK65I+BeEfTe8M/vA
	/oGNoKVtdzb3AEbiYXrQXyowhHmbg40=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=iXv5lIU5;
	spf=pass (imf23.hostedemail.com: domain of olsajiri@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=olsajiri@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793358531;
	b=iEOgbNS0tzvGfrqf5MWI89OYRz3bWzTzgLjGwXVWSDuhBp5FeLV7OE30NOON9afdYqnSHw
	G+2q+/1vhZ3dQ67CUE2Jt82Ul+FOsFkLR4oHLDSkGN8uYSr3vUr+dDdpQtIT8Yl71D7CWO
	ZJTtK2yrg9GHVxcV2f5beEoH/JJEwIE=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-48c4be28b82so584667f8f.2
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 04:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793358530; x=1793963330; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gdeCa3x7O2p6X4CzDfNArZvHnuzUnaCRCf8ceCdxpuM=;
        b=iXv5lIU5002IdFVqgjCqmyIF62fE8P9Fbhs8xZ4Ht8cfkYdLmKMlt7Eo56MKKOwNHo
         WXICp4AxEfZLCl5M6FlIVGVXPeGThhTpFIOYMieHrIR0TwGEeGuSe+W9KMydX57G57ro
         OZ6wxs9oiOy2oR1RrakHidMvQKmN/p/i06J7L0oYB/FavmrjxREIvhZ9DwYy1Zj9kgSL
         LAI7ccSeJl1ygO1KLdLlZYInYRXH5CztyoY5zzTdRaQ7iKV6jC7f2ki2hpA61/Qbnj2P
         CpxVJDtIxwvgCS8FLvkw5vz7pipOigDYtV2VJldGGj865u3P45+aftVYpVN141U+ha2Y
         1fVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793358530; x=1793963330;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=gdeCa3x7O2p6X4CzDfNArZvHnuzUnaCRCf8ceCdxpuM=;
        b=lmB3eeu+tpSTJ4WfeeKUZYULBDsBZ1JffYEivDsHmfy2RHxxcy0oxTuAGcedGV/UCQ
         u8FQbyIejpFrbvy7xZ1+deF3aJfJ5RPXnyw6CPDQPd/eRpT63ig4Yi5rHkbolEH7q1i+
         2AbKPFuY/s8RQmL3msfoWK/GSHBYBCIQacvzTYNwz7OnpVSFY9EZH8ao2rAvXFLCx2aU
         VUheU3gWU1kcps4P2wkXeP0MklKxK5GD15q5Nx8+DCTLIeurhAJEjsRZHcZOJnMPwLdJ
         RSFoIeyjb2jASvmjwpoS9UuQZFDbuPI1N4P0M4lA5nRIpNuNj+jEQlh7rxeDpw4ugQnr
         F+Kw==
X-Forwarded-Encrypted: i=1; AKwUvByWP9a39FnHorrMhK19y7HVqedC6BWkNcvXppBftt2v6oXFdzpxq3ahqmmegIOvXssU6TviR/iAeg==@kvack.org
X-Gm-Message-State: AFq9FYI6c+4cFYBib/fdwWCYTdDu9NpOmjG3RQ4+UfeY+E3Q1hEazQGr
	2oLeUponoBB05XLYbeUWJPoE3bGjmjI8Gfx51TmUoDCzTh7fW6HnECEI
X-Gm-Gg: AYBFou3C9NFrv2ikPU8/R6Ot4fuWrXt2qJ/v5kmB9iPYgHnjMJKAYmSSJk5NN7iXMz/
	d2EKP9A1wKM+aa36S/eL33pc2d9I4mx5b42OYndb95Wjp0WEZLVyU8royNG9IyNoPCJW+pD37nO
	X9iRTdaeaZy3VwIWDt8Bl6IWum4Fzv7ZixLmBJfzfEtvhdLUBDWTuddn+pUJqdliIywnUBBqmeT
	hSK7xS/my5lN5+n8KiyOhDrjBa0toZI8MYigLNLIFdXWXa2pbkvwENhkGm8GdA53kF1OBQs37+T
	IYbAWDgm8Nw00F63PUR7qBoLcKBiGaa+2lBmixKKi/fz68LnjSxjxGMI3+OFAr7IH6JDJ72qxeH
	jPYXRzgz9rL3oN2zLvyKxX3zR20MTyvcKFlE/69cxxmsnamQWbTravDpZ7Msio6KrPdl5rIU/9a
	SwiYX8ruF41Po9Mss9XVOBABTVggY1cpb+Dv40OnO3PmVxA/3M3JRkMU9UTpyRhgXx8blmYlc1C
	5u1SUARy4mtgQsvDYFd09myAm4GBGEqBs1u/j/2vY055qqjF66h3024NS7ahYa+O8Civ+YNV71G
	Q186FIjnUmG0A/IJGDEfJfA=
X-Received: by 2002:a5d:5d06:0:b0:487:88b:4681 with SMTP id ffacd0b85a97d-48e6e303c2dmr4961705f8f.10.1793358529616;
        Fri, 30 Oct 2026 04:08:49 -0700 (PDT)
Received: from krava ([2a02:8308:a00c:e200::25dc])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71ba5dc2sm2545582f8f.54.2026.10.30.04.08.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 04:08:49 -0700 (PDT)
From: Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date: Fri, 30 Oct 2026 12:08:47 +0100
To: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
	linux-mm@kvack.org, Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Federico Di Pierro <nierro92@gmail.com>
Subject: Re: [PATCH bpf-next 2/8] bpf: Add user memory kfuncs
Message-ID: <auR6v7rEVTlEALJ-@krava>
References: <20261029212551.56964-1-jolsa@kernel.org>
 <20261029212551.56964-3-jolsa@kernel.org>
 <CAEf4BzaAbWxWfjn4u8vieaWzhjE+Af+KV8sLFH9kfgGT5PtAGw@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEf4BzaAbWxWfjn4u8vieaWzhjE+Af+KV8sLFH9kfgGT5PtAGw@mail.gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 28D9614000C
X-Stat-Signature: oaugxas4i9dpnpczof81mbboottkhgbc
X-Rspam-User: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793358531-235084
X-HE-Meta: U2FsdGVkX1/WnC/r5kyJbudrHOYMFrx4oufCwOCncPLXVSmM7OuLi+u1cXXpe9h9fmLR2VyLZ3OcDYw2Wemnmr83eh+t/+qmXWtcbXASquhhqswifnnLnPum3Ape1+ep31R6yWMK529WSC9fk4SMAUmjfvk92+qjaOEfY9vbghsfuBqAaOljxtPYYrSAwwNNgvT4de4OjNUn57T5DviGq0MJjRuKfV1Z/zstBZyKmEBW+1KJ7/y2HuKMMw81r3MnL9hyWUxYipve+O1Vke3cHRWmeAPe55Tg6PfwSGLXbiV0gTk6bDEHx/qbRxC1IqdnvkfzTOZcjNXkg3TKctuAn8xFNw6Z5JhZ2ays4xaWkeX1AR/GxY8WuCOzZCUgg3yJG9DNfP/O7bdD6L4WrzsklR877fXu7wDbFUT2a6rINPm+AO3AlNYg2Aa58cAw7STL0WuzllV6XiM7FfQ4uk/cKZI6Pdy8nRem1wmRKTr06IcL0UxSKzqz6utv/ho1RqEnmtzFLHA3UHhk0F0P5VUOb0ubnK0D2C0I0QH9Mkr/xM8gV3O7IuRDzWY18yaLAm/I1SdFH7dsd4EryaW9CFffEJSD24+eQkxU0uAhLv270l6Z9Bfi6B4HWIY+QRsa0FJ5HTHKKz9mEmwT/kK7iAsvSpExfRtwXRb836crs7J40tSvKWnMcZO0SvcBFezTOHZull0iCYmj6tZrgAUuNHB1Xa18xXrETqkVocxkLGCiJ6zo9xhVbTPxJjJFN9GDN5wZwXvDy0A5e76WUbMfkDhGTOIwmIjAeCYFVUTlg88RmwXPrkc28Xyvq3R0M0G1YbsWcfNn0cq6sXOybtzxhzZkBljLu5LP7D56NzepNIfRTIvVG4murWD4pw5qU5owoye7Y9jkYScJCHHNLl5LFSnytaRiiDJ5RP0sYSrZN16AJgmn90xg+2S8QDd4zu6IDzMzFcRBtJwFLJ1874oOlnh
 CKLoI5kp
 TwLymSmKHJSkbbCCzBLl9rIOjepN+fe40bBcOOrwFcXaylv9nh2NxE/XAYjI+CVcBhFDQ6BvUmtzdV28StePsz6lqT602WlwplSd9Hx50LmCt8JEaYpTJBibiYaYopAi4g0+qQZ4FGWUfwNjm6gUOQvs3GssJA28DviARy7mS7PSamUd50zrMm6fjuEa2zwfLzg5xPyoDSOEihlJFo1iZAkQjbKXJThYmPYEtPNV33AKSikqe06h4vHOHuwOGF0vcNW40juqr3RFvHfuZv2za8jB/hyzTifSOvpMX1fEZxFcTYwcWaVhXpTPTGZq6DH/B2A9dwOdpX9dql0MvXAcZLMjU2JCziZl3cMRH1X/0UJlEg3SFMVAV8j+ZFxgDuwAQQfYlW6yHN9S1mKLXrUDYvWKdrnYYglFHQSSXOiA6ejQezo2p6wTBB8QG3rbuPyswx3WLkWVkexO67qNKUMbMfH9haxQuu79K3i97IavCs0CIY+6ZaMFzP3Qo1r2qwuS8XzxqgwxMkVwDyFgpJ/IdVgiBSdobbsGdTO6T5wH72by6wvzCD1EO8RtdomORQyvo25nf2Jnoh1dbzPQ7E5pcOOeibDU/Cb9oFeBS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 03:00:50PM -0700, Andrii Nakryiko wrote:
> On Thu, Oct 29, 2026 at 2:26 PM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Add sleepable kfuncs to copy data into a task's address space and to map
> > or unmap private anonymous memory in the current process.
> >
> > Require a usable user mm for mmap and munmap. Register the kfuncs for
> > KPROBE programs and gate them on CAP_SYS_ADMIN BPF token capability and
> > the BPF_WRITE_USER lockdown check.
> >
> > Use FOLL_FORCE | FOLL_WRITE for task memory copies and return -EFAULT
> > when a copy is incomplete.
> >
> > Rename the syscall info-copy helper to bpf_copy_to_user_buf to avoid
> > the name collision.
> >
> > Assisted-by: Codex:GPT-6
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  kernel/bpf/helpers.c | 102 +++++++++++++++++++++++++++++++++++++++++++
> >  kernel/bpf/syscall.c |  10 ++---
> >  2 files changed, 107 insertions(+), 5 deletions(-)
> >
> 
> [...]
> 
> > +/**
> > + * bpf_user_mmap() - Map private anonymous memory into the current process
> > + * @len:  Length of the mapping
> > + * @prot: PROT_* flags of mmap(2), including PROT_EXEC
> > + *
> > + * This maps memory by calling vm_mmap() directly. It does not invoke the
> > + * mmap(2) syscall, so seccomp filters do not mediate this mapping.
> > + *
> > + * Return: The address of the mapping on success, -EPERM if the caller has no
> > + * user mm, or an unsigned-long encoded negative error code, as returned by
> > + * vm_mmap().
> > + */
> > +__bpf_kfunc unsigned long bpf_user_mmap(unsigned long len, unsigned long prot)
> 
> bpf_user_anon_mmap(), so we can conceivably have a more generic
> bpf_user_mmap(struct file*, ...) in the future?

yes, will change

thanks,
jirka

