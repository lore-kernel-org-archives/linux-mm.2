Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6138BCD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 22:42:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D1E86B0092; Fri, 22 May 2026 18:42:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8537C6B0095; Fri, 22 May 2026 18:42:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7906C6B0096; Fri, 22 May 2026 18:42:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6BDC96B0092
	for <linux-mm@kvack.org>; Fri, 22 May 2026 18:42:07 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 19346A0796
	for <linux-mm@kvack.org>; Fri, 22 May 2026 22:42:07 +0000 (UTC)
X-FDA: 84796530294.11.429AE4E
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf14.hostedemail.com (Postfix) with ESMTP id E50F1100009
	for <linux-mm@kvack.org>; Fri, 22 May 2026 22:42:04 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=RuWfUT5a;
	spf=pass (imf14.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.42 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779489725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P+Cb+Uc7oZT3PJonQSP3vI2NqOWeABlHn7+a2lZVeB4=;
	b=cQCgAB7k9AHdo9BvSePluGoTQbD+Py/CrZn5mWtq6Ghb/TaiKxQrFqBCeQUglvR1oXtrwl
	I6gA72jlIlQfNASstLG9KvF9JfI9YjBKbohciW2nKoq5Y3UOzxoZIk23z8aWOD7inm127c
	WvOXpd2PSUN3ius7lzCOSD2rRL0fNWk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779489725; a=rsa-sha256;
	cv=none;
	b=z8/XXkd77ZFKpFYXSF30Tzx4LPmgzwGbJftfPuFCRZZ2o/7J/hEczFlFj9vmClwPoH5Czo
	kkhey1NVFyQiCLw4pgoqOx89z3hF5zrUmnYB6PWwm/ukVCOLHwfC/Sy8J58vYGvXDd6paP
	weQvs03d0v85iL9Y2+UK/MEV9EXZ2Kw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=RuWfUT5a;
	spf=pass (imf14.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.42 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6804e24803bso299402a12.1
        for <linux-mm@kvack.org>; Fri, 22 May 2026 15:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1779489723; x=1780094523; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=P+Cb+Uc7oZT3PJonQSP3vI2NqOWeABlHn7+a2lZVeB4=;
        b=RuWfUT5aO48jHD58SanNK1yYSHff6FtKjqWTqn99tmoiLhEwG7kn0FV1a17EM7GV6R
         EKJLmLK7aNwdHRBpfVp6dn2DPhrNujjK2toHNgNUtPcevdQLQAwUCHxJKZ3Ppl+44DfY
         pBRRF+OAXxT/rCnht+r12YgGJfGQ9kc/Qjmco=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779489723; x=1780094523;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P+Cb+Uc7oZT3PJonQSP3vI2NqOWeABlHn7+a2lZVeB4=;
        b=TYip+RDJF6AWEemVxLqauamCtVjSLKc7lZjHRKwqExIctcfAkxL6iIn+RedsgYlyNv
         u5r+JMAdeIzqwLff4MZM2fd3s7P3MOMy39MClfRr5d8/hu0r8oww9W/2MvJYwtmk9C7A
         n/9WbCXnlcNk0aKAL2XttX2KN6hg8EwSHfAVlP1KcuotLD57+rKEzOR4iGXdaZYkJOQS
         d3HkpuKytSLSdmhhK0nGIT2nZDpQt8mlx/cyJiLLnzciQlhjCeSg9Pl7WL3+L77+yy6M
         0ThpSh0OyCu/9EdVrkAQRblSHn1DSpLbNjpAViVbgarwDaFbctTr6gy5Uh2FrUXiDomc
         rMGw==
X-Forwarded-Encrypted: i=1; AFNElJ+nvq8hxlmUYqNT5oYAbntqcEzL1pw2ahlPimIuDnk3GFx5cCX0hJaIwx1krZa8aIrVq4qLiBhfHA==@kvack.org
X-Gm-Message-State: AOJu0YyEzHOuf2ZGEbZYbAivTh6MIREBe/AhsQbN1n9FTmyd5pYTtJHl
	aB0+dh6aErLRxRkwn+AfYK3XyuMpwQ1Is364wUpDyhG9p0FFYilmOTMi1u/dMN9rU7vA3M4dVgz
	xACrKR1w=
X-Gm-Gg: Acq92OGYyaTOt9xRhjKO6IyMikm8eAq4vT2hG1MK8sXeqpI6vi1CbWWuhjwzGf4sx/k
	q9zh/N0W6ljMrbAxheiZYXep/G4CTs1iYWb5Z0vxueTYDRpj3S9LXP56zpCYuSUND6rYucV6QSN
	tFRmDDmwT++U147cCrYfwDN7TqZhXXcKCXcrtCiX+FLAEB7rkUzwGcpMBEomNTen8LZzt56hfqd
	rtc87lhmiQFmzqu3LqPi+rd9WIK902NoPFZdv4LXjDCzAdM+Td1Yww0B2q8+i3wVtJn7QPjmq8S
	lpARO/xB7tbb8t9Vr0jGUjV0VxV29LAkHsbM+ZqjjaTMhKLCTIbX/HM5UpMWx3hd1Yz5ROoTzZ2
	KIvblji6PoH91E6J7T2zldN+B0c7SfMHByWd4nCbMmFZyjjnwpsLahSFlykfMnCkXAX6I2JRmXs
	mn6y+BaTUQaECwz3DUEi6ot9K496dpch61Q/KrM3QnlQzFMys9OWCB4PS4geqnsvzCt5EPLHnn
X-Received: by 2002:a17:906:fe01:b0:bd8:f919:5c0 with SMTP id a640c23a62f3a-bdd274caff8mr334220666b.27.1779489723340;
        Fri, 22 May 2026 15:42:03 -0700 (PDT)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com. [209.85.208.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bddc66d22b8sm96478566b.55.2026.05.22.15.42.02
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2026 15:42:02 -0700 (PDT)
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-68896f2e7d0so282472a12.0
        for <linux-mm@kvack.org>; Fri, 22 May 2026 15:42:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9b/AQHmm08rmFDxfmPWZM4ayBPo4tr9BNUoJvxuV+ik/K34+kSW/ihyrg1LITCuzwsLPqqR373NQ==@kvack.org
X-Received: by 2002:a17:907:7803:b0:bd5:e3e:98cf with SMTP id
 a640c23a62f3a-bdd281a5d20mr270251666b.46.1779489721924; Fri, 22 May 2026
 15:42:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260511214226.937793-1-minchan@kernel.org> <20260515-nachdenken-umbenannt-a90006a46e14@brauner>
 <agd--WZpeTq2iKFW@redhat.com> <agefLhQeWpvil14M@google.com>
 <CAHk-=wiHfzbufXD2nuc9BhOVp-pYEmnVUYeThKmfZRXLU0kJ7w@mail.gmail.com>
 <aggE2haQ7yGeHPeF@google.com> <CAHk-=wg08=sZb=hVa22KjN2pD3aNk-diGmKQnizCgmoMMfrvwQ@mail.gmail.com>
 <agzNyXKIirm1zOob@google.com>
In-Reply-To: <agzNyXKIirm1zOob@google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 22 May 2026 15:41:45 -0700
X-Gmail-Original-Message-ID: <CAHk-=whqfr-M9ip9OWAUR1X6aOEy2P4gSWYDkbkTCc3E=jCz_A@mail.gmail.com>
X-Gm-Features: AVHnY4J4xF7INrh69EQAzG7z68YTyOrxLQkqkg7ZrFeZIDyZR4c38ibtE6rv0-8
Message-ID: <CAHk-=whqfr-M9ip9OWAUR1X6aOEy2P4gSWYDkbkTCc3E=jCz_A@mail.gmail.com>
Subject: Re: [PATCH v3] mm: process_mrelease: introduce PROCESS_MRELEASE_REAP_KILL
 flag
To: Minchan Kim <minchan@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Christian Brauner <brauner@kernel.org>, Jann Horn <jannh@google.com>, 
	akpm@linux-foundation.org, hca@linux.ibm.com, linux-s390@vger.kernel.org, 
	david@kernel.org, mhocko@suse.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, surenb@google.com, timmurray@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: E50F1100009
X-Stat-Signature: gpai61u817tffs6fisqy71ss8wq493ji
X-Rspamd-Server: rspam06
X-HE-Tag: 1779489724-554792
X-HE-Meta: U2FsdGVkX1+/O+8DXSc+/z25Fjwct4h8FsPxbnjhPCyKHzuK9G/F9A6wLFIVtBRqtfGpDYYZBU6+df7YbBzCip5ahGxsdOpWite+O3xeBNw/a5Ah+VJqoJ3QRvDCzCdihyZuxZNxBBEA81CDmHFwr8GW2cJXq6x6T+/Qyl5xD5o35HN33tQbrW1YKpiVt0ogF+KXSqnHGp4CKtvPACTdo/FUwf5WVJa2FuvZB2SFxRu56jjLAF8fa9xSizNrgNCeNddtOu7PaH+fOdJrcndqTbT4Es/BNnaAk1IejRPqeCyKjgRMuaigTUu8ALo9PL1gi5jTaySqLE6pM387zFovQN2mt4z/RqIvYSdciwndL2PRSBUCMdFwWRZYiEzsj8uzWqUfRE9AK32qttrOAL2cRRLe24UIZiVjC1igbwFopFNPCm12iYYMYhBG7LWEeWzIGBiG9DKvJQi1+WclcP4izuUQf6rl66CO+L1lOPRPmmkAScldP9dQP1BsxRkRNWch1wBl/WavFWWnfXiWe1Xu9tn7ONlFzHIcBccciNwaCA5Cx5ISqj3GojPMe5nHNYrHLK4oSNVSvp8rUE83BP7voayBfGVf8uUXChQjaGC9wXcU8fqAlxnbf7PZbE1scO3cikR0w76pTwwG7yDarjGbjPPfeNntsNQlGnJvw/Dz/DOYKKujChBuSNoylQnf3EsIn+9lwadkv6JrSmEbkcWp/qz59LcP2m//SmNovDsYYVJXwo4kkJsaVNOeQw4/mAuHbePQkLo9PHHjzkwapH4Zk6aKw5DE8jbloPRrWNcCRGQzQ2Zz9xdNCZn0AsjEmAWv6FUvnKcEOSkwQ+ZH1aCF2QLDJtlJ6itxUwgocGb5+s4r95N6BFZyUPPvxFlkMlj5AZYhg9H1ANLH72c1XRJfsimp1bHGOXgw2K7rXm3YL1UF7gHYSfoQ24IL8N4HrP4mziSzzowO/8JsShNM35N
 leFjtDNd
 8RO41Mw57Q027D2MJhUVPI8TH0hkIMGR7OjJTdP+jAjsEPpH0xoCX5NTDzoRrwUyChCm3tskBBJdxopZOnRTQe3I+zx+JJreVwj9Us1l5KXB+7kzNkZVbFK/nZwhrjT6P/sXdfd7md7VeG47KEf3Qu4bzessuP2akGLBived0XMFuOhktcWJJXd6aRAg2mjQ7JiDbMMSHjPRqTkneThyUvxUMhlwPHdQpZpyNtQhwQiEWHZHmCOz+iILeXoXfYi5wgurr7aZOWRSmahuHaTzoV2KZbrROHtYUGmzb1ZzYqwtmdj+t6Hbmt9r5DvAyfm/grcyWtyblUUh1QCg2jiK6R1TraRaCR3u2+koWP0EMTKcSP4t1y9PMMZkt3M7wMfH/L7Nksv5h6+GKv99gj9qXLX/iaprGv4lyRInbWASW8FGsL3NB7ol0QNehT+e+xzVjexF3/f7McmrdSm9JHLoV1hCNcpaS/Dk5uZL/k/HEvS8vjEiqF0M2/L5HyQxOE3+GgUsjfToZS5iBLjSNDOcnLUe0STTlmNBon3rT5+l/J5cBEXcO8npJ8zutxd7VfjPQyZPJHz1c8l6jxW8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

 On Tue, 19 May 2026 at 13:53, Minchan Kim <minchan@kernel.org> wrote:
>
> First, the -ESRCH race remains unsolved.

Do we really care?

> Without Jann's patch to preserve the mm pointer via task->exit_mm, the
> userspace killer won't even have a chance to attempt reaping.

.. but without the mm_users grab, the memory gets torn down
regardless. The mm_struct remains, but none of the page tables would.

So no, it won't attempt reaping and will get -ESRCH, but the process
will be gone, so what's the difference?

> Second, the latency bottleneck transfers from mmput() to mmap_lock.
> If a low-priority procfs reader is preempted or stalled while holding the
> mmap_read_lock, the exiting process calling exit_mmap() will block indefinitely
> when trying to acquire the mmap_write_lock.

Yes. However, that really does sound like at this point it's no worse
than the PIDFD_SIGNAL_PROCESS_GROUP_EXPEDITE you suggest. That needs
the mmap lock too.

One thing that makes /proc/pid/smap worse is that m_start will take
the lock even completely pointlessly, over and over again.

Even if we just remove the mmget_not_zero() - which I think we should
do, and just rely on the mm_count of the open/close - it *keeps* doing
that silly lock_vma_range() using  lock_ctx->mm - even if the task mm
has long since gone away.

So I think that the code should - in addition to not taking the
mm_users count - then also do

        if (!task->mm) return -ESRCH;

in m_start(), which should simply stop doing any pointless work on a
VM that no longer exist.

At that point it will go through at most one iteration of show_smap()
with the lock held, but that will be true even for your
PIDFD_SIGNAL_PROCESS_GROUP_EXPEDITE case.

             Linus

