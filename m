Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A68ACAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 17:09:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 597CF8E0008; Tue, 16 Sep 2025 13:09:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5217D8E0001; Tue, 16 Sep 2025 13:09:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E8E48E0008; Tue, 16 Sep 2025 13:09:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 26BDD8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 13:09:34 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C5FDD13A2A8
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 17:09:33 +0000 (UTC)
X-FDA: 83895749826.10.BED6ECD
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf16.hostedemail.com (Postfix) with ESMTP id E26C8180007
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 17:09:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZyFKzqTj;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758042571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5nObP271o7zKWD/o6CXr8B27todJQZZ/TCUsecAu7bQ=;
	b=N4hPOIRJQgGsT3uAXh0sdaJWrOjMnQnr05CjqbTqDz6+7F4vOE/AAm9ljgECCQtJDrHqC0
	PKMxngvy7IG4JJrQAywwuUeTI98bSERnkYR4TLjvYuA2/M9ioZqyDYA/hKt6ffpmYL7pNV
	exqnY9oLZiK+xzU/1/fDpNXjCsTZ1h0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758042571; a=rsa-sha256;
	cv=none;
	b=G05+BnPaicJEOQDrnd9ho1BY/Y5pmUElQd735EXQSAeZXMWwJ7bSR8rvlqMabzMwt0NLYZ
	QiEJJZd6AWxLxN6v2M/6ZZ6p6Has+i6JyyWIygxw1ly2X20EvRuCXB6D3LJLXjeN3ecuI6
	gQ4c/nrqahh78JQjNg4hxEmsv5/4WDg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZyFKzqTj;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4b796ff6d45so18281cf.1
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 10:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758042571; x=1758647371; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5nObP271o7zKWD/o6CXr8B27todJQZZ/TCUsecAu7bQ=;
        b=ZyFKzqTju7UobgCJpjG9J/ynxJlK+vy28KstXgPHqNL+5K+NNG/Tl71Aex0vOe8SLo
         fvMseq7uO082ea83c7f5R8R9tagauzh8SN/SpzHIKUcz66bWjuLqQ/FfrjDI0cvQrGjN
         zOqZ4YvBMb30kESNYNbK5BTY3RSRvVULJE3AtJptk9RzZUASq4dfKNkqRZkyms3d8tUu
         Jbaoyw0DtGYylEhpnQlcvHK8IEip+VBcmytUgcQsi0sWmQvhKfMYPtbE/hsPiZsElzlr
         dD3anoFr9/YErHqXhSiRKFTW2SuhNuGxgrMgC9DR3kaFLZ2ZYKcA8R+5rLF+K0FXY6GI
         pHgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758042571; x=1758647371;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5nObP271o7zKWD/o6CXr8B27todJQZZ/TCUsecAu7bQ=;
        b=lWy8PSBZD4VqxMshH0KtaNtZKwUjtWQHoBbycPEnHg6YkiXrRvI5/RynR1qS6VZZDz
         8t+CAaQjixMQNFoRwNYmga4Xi4YAF0nCGlQlQkgxjRQ1yWXeGOZuxjwDivWHxZFOIbLO
         sMkqzxBlPxploy5bbw3id8NbXbIiENDBzk8XZjuzWKRjazHgjQ7P5VSwCK46t8jETSL2
         iBX4Mk8HeyTGUpqFcdv0W6mALL/oDVkw2Cxott2oqdwbrwWUjRe5GAkIUmxioguTlP6P
         knNpn6K5ewvMpbc7JNaAMeszlqxbHnWD7tCBv+T4BQKcoHROp4VNTlfgJWVZzSD6AhSd
         rsxQ==
X-Forwarded-Encrypted: i=1; AJvYcCU1Vjtly6q82cWC9Nf6yZoWiaZ2mvoaoudpsE6kiTGLwCoaUjVfSAwo/WqvMJECWw36IDvFu6GtEQ==@kvack.org
X-Gm-Message-State: AOJu0Yx5px5E3SmQ/sZ7QBdf1mI2g5WRwwDNZHer7rl9OM2TLcy+8GQK
	bnhgWTLbqD9Ab+wlV/cegbW2SqLxTcyRQS4Z/WfUbQddiEqXvFvaGRXCX/MvjBcId2gSi6VtBYz
	KHnq0JhfzBwVHi5OqAoczU3mZ6uzsgcr9tPx5gcSS
X-Gm-Gg: ASbGncsMmHPC8uaSe6nGZvb77lDDpAleCtmS8wZ2yA/voaKMjFiPkOFlTG7HYxTM8nh
	WVN8ft2ZKcMOoDDNnYsyt4BbuS9lya76zIcyfSHpYQCZsPCf/XINebau5t6mBBxjGfDMuUjPYfT
	cLu8vvls/f6bBBqLZT2K8sXMn62jHAWTXL7AVgQPdO6ZuhcOKKi5N5oEKyoJhZSPFgW7CSveVcZ
	daJoVPNPxfZnv1tLaDOaTBGz1+hzVaR2sqKU/7bvTlM
X-Google-Smtp-Source: AGHT+IHlnZD0xzveloqY1NwivFqIQ3M/IVLjLUBP4FRJ+7Uqzu5AIbMylt6KL7+KR956Bl7yUYehkcOeC/F8nnahyEY=
X-Received: by 2002:ac8:7c56:0:b0:4b3:1617:e617 with SMTP id
 d75a77b69052e-4b7b2d81b34mr6548031cf.11.1758042570374; Tue, 16 Sep 2025
 10:09:30 -0700 (PDT)
MIME-Version: 1.0
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
 <20250913000935.1021068-1-sudarsanm@google.com> <qs3967pq-4nq7-67pq-2025-r7259o0s52p4@vanv.qr>
 <f5792407-d2b9-42b3-bc85-ed14eac945ec@paulmck-laptop> <d1ef1cbb-c18d-4da6-b56b-342e86dca525@suse.cz>
In-Reply-To: <d1ef1cbb-c18d-4da6-b56b-342e86dca525@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 16 Sep 2025 10:09:18 -0700
X-Gm-Features: AS18NWBm5mFEewsCE7hgqPbGCMob1rkMeU0y4GD4Rj9Jw-SRj0_ytqyTNwX9TZE
Message-ID: <CAJuCfpEQ=RUgcAvRzE5jRrhhFpkm8E2PpBK9e9GhK26ZaJQt=Q@mail.gmail.com>
Subject: Re: Benchmarking [PATCH v5 00/14] SLUB percpu sheaves
To: Vlastimil Babka <vbabka@suse.cz>
Cc: paulmck@kernel.org, Jan Engelhardt <ej@inai.de>, 
	Sudarsan Mahendran <sudarsanm@google.com>, Liam.Howlett@oracle.com, cl@gentwo.org, 
	harry.yoo@oracle.com, howlett@gmail.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, maple-tree@lists.infradead.org, rcu@vger.kernel.org, 
	rientjes@google.com, roman.gushchin@linux.dev, urezki@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E26C8180007
X-Stat-Signature: 7nihc4bt6ykg3mhprc7r3aa6hijk9r7j
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758042571-374692
X-HE-Meta: U2FsdGVkX18Kc4QzkYQ+Sg314HdwgBSXOBnIDWAIPBoETYO3FOGb+zAp6ZbluCYm0ZuPq+lBIAWj7n7xONqbNImedxvxyTQqc04gOs1CDzmA5j8yOT+a2nJ4XSxnrVJ/0hCfKPT+KL6ZujWqy3l+NZZNWY8cCJx+grC4CT3QUUuq1JsQq78GCVLJqSsqFl44iJrxQLY7TKVv0/nyAHBysjqFxdosytaNBaR15+byuwl8IWaNOYoHn0VwBUx9OoxtGV9TAmRx/UI0v05hSibEGcm+JhLnzbrLaTvChLcWQVUSK7uSbcY1LetRL+D355PWA7WHsJxByvL6sPAVvAcpiw2Zy0qsh/aslZivk7HnibH01jHSuhMvAm09ithVbqAOIDIp/jN/vyLBt5dX7SWT39gy6sZIiySrtBHTw6Fd/WerQgnoLh3ZMv4OsASWa0TZLVR+fbUuw5AlJ7YSVgCj3QNNAVaSRTV06zsnY+p+LzW1ZGlZ2AVEYPaJDpgtGi7r1nMJckMFi/aq/yT+TeOjWZ/RMZCP/2fcQstit4ClRHj+okAJ3J5NfVPZAzjTWOqlHP6Vc/pfhH9hRyGE7pLa9KLtqv5gsIdlIxoZFa/RfES2wOS6Zv9j92QuXXLXeFS3CZUW50HBw7GPbecfXYjEbDuo4ogFdFcuzHmwLa5ZHBz/FdaViXSVLo72dEVu/F9AC+5FXkv+ncNHIkpbHuNGpmdkJfvErZHlMa6XxI67Gx+iMsbFLkwvxJ6/742F9nx5MlzI7ckiOB4737X8q1cBtbNQfCEDXuoYAhRh7HM9+1YpRT5fqIdewvHUHB3xHTq14U3DNQ/FPjRcHVQ3uMzNjiZH5ehP09LTqcldl35ksKFHrZBuwuT9mNmGT/d6gPEimkl53Z7c70ztbWqCzrlpRpd9+c2KMDGMqw7LavFguM6BziNbuOqDBcgXZEZnX/Yc54f5ubmbEyQVOsxJiaS
 O8V9SpTe
 WgRRsgHNhYOVy4XacAacfFPYidAal8nesB8iVxTp3bGLpUtBsE3KYrge+E3XyMxGWo0tsYGJGDf+fqpuU/3wnWFZkGIV1thwukbwIbJXrP4Cixv47rfv2PvxYqCzQ1ezmG1YoGeLsflynZ20EwSNy/f++Yw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 8:22=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> On 9/15/25 14:13, Paul E. McKenney wrote:
> > On Mon, Sep 15, 2025 at 09:51:25AM +0200, Jan Engelhardt wrote:
> >>
> >> On Saturday 2025-09-13 02:09, Sudarsan Mahendran wrote:
> >> >
> >> >Summary of the results:
>
> In any case, thanks a lot for the results!
>
> >> >- Significant change (meaning >10% difference
> >> >  between base and experiment) on will-it-scale
> >> >  tests in AMD.
> >> >
> >> >Summary of AMD will-it-scale test changes:
> >> >
> >> >Number of runs : 15
> >> >Direction      : + is good
> >>
> >> If STDDEV grows more than mean, there is more jitter,
> >> which is not "good".
> >
> > This is true.  On the other hand, the mean grew way more in absolute
> > terms than did STDDEV.  So might this be a reasonable tradeoff?
>
> Also I'd point out that MIN of TEST is better than MAX of BASE, which mea=
ns
> there's always an improvement for this config. So jitter here means it's
> changing between better and more better :) and not between worse and (mor=
e)
> better.
>
> The annoying part of course is that for other configs it's consistently t=
he
> opposite.

Hi Vlastimil,
I ran my mmap stress test that runs 20000 cycles of mmapping 50 VMAs,
faulting them in then unmapping and timing only mmap and munmap calls.
This is not a realistic scenario but works well for A/B comparison.

The numbers are below with sheaves showing a clear improvement:

Baseline
            avg             stdev
mmap        2.621073        0.2525161631
munmap      2.292965        0.008831973052
total       4.914038        0.2572620923

Sheaves
            avg            stdev           avg_diff        stdev_diff
mmap        1.561220667    0.07748897037   -40.44%        -69.31%
munmap      2.042071       0.03603083448   -10.94%        307.96%
total       3.603291667    0.113209047     -26.67%        -55.99%

Stdev for munmap went high but I see that there was only one run that
was very different from others, so that might have been just a noisy
run.

One thing I noticed is that with my stress testing mmap/munmap in a
loop we get lots of in-flight freed-by-RCU sheaves before the grace
period arrives and they get freed in bulk. Note that Android enables
lazy RCU config, so that affects the grace period and makes it longer
than normal. This results in sheaves being freed in bulk and when that
happens, the barn gets quickly full (we only have 10
(MAX_FULL_SHEAVES) free slots), the rest of the sheaves being freed
are destroyed instead of being reused.

I tried two modifications:
1. Use call_rcu_hurry() instead of call_rcu() when freeing the
sheaves. This should remove the effects of lazy RCU;
2. Keep a running count of in-flight RCU-freed sheaves and once it
reaches the number of free slots for full sheaves in the barn, I
schedule an rcu_barrier() to free all these in-flight sheaves. Note
that I added an additional condition to skip this RCU flush if the
number of free slots for full sheaves is less than MAX_FULL_SHEAVES/2.
That should prevent flushing to free only a small number of sheaves.

With these modifications the numbers get even better:

Sheaves with call_rcu_hurry
            avg                            avg_diff (vs Baseline)
mmap        1.279308                       -51.19%
munmap      1.983921                       -13.48%
total       3.263228                       -33.59%

Sheaves with rcu_barrier
            avg                            avg_diff (vs Baseline)
mmap        1.210455                       -53.82%
munmap      1.963739                       -14.36%
total       3.174194                       -35.41%

I didn't capture stdev because I did not run as many times as the
first two configurations.

Again, the tight loop in my test is not representative of a real
workloads and the numbers are definitely affected by the use of lazy
RCU mode in Android. While this information can be used for later
optimizations, I don't think these findings should block current
deployment of the sheaves.
Thanks,
Suren.


>
> > Of course, if adjustments can be made to keep the increase in mean whil=
e
> > keeping STDDEV low, that would of course be even better.
> >
> >                                                       Thanx, Paul
> >
> >> >|            | MIN        | MAX        | MEAN       | MEDIAN     | ST=
DDEV     |
> >> >|:-----------|:-----------|:-----------|:-----------|:-----------|:--=
---------|
> >> >| brk1_8_processes
> >> >| BASE       | 7,667,220  | 7,705,767  | 7,682,782  | 7,676,211  | 12=
,733     |
> >> >| TEST       | 9,477,395  | 10,053,058 | 9,878,753  | 9,959,360  | 18=
2,014    |
> >> >| %          | +23.61%    | +30.46%    | +28.58%    | +29.74%    | +1=
,329.46% |
> >> >
> >> >| mmap2_256_processes
> >> >| BASE       | 7,483,929  | 7,532,461  | 7,491,876  | 7,489,398  | 11=
,134     |
> >> >| TEST       | 11,580,023 | 16,508,551 | 15,337,145 | 15,943,608 | 1,=
489,489  |
> >> >| %          | +54.73%    | +119.17%   | +104.72%   | +112.88%   | +1=
3,276.75%|
> >>
>

