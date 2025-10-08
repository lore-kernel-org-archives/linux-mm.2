Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E80BCAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 19:36:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C87AD8E0034; Wed,  8 Oct 2025 15:36:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C381B8E0002; Wed,  8 Oct 2025 15:36:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B000D8E0034; Wed,  8 Oct 2025 15:36:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9944F8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:36:47 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2B2D513B991
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 19:36:47 +0000 (UTC)
X-FDA: 83975954454.29.D32D5E5
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf24.hostedemail.com (Postfix) with ESMTP id 51DD7180005
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 19:36:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LKZD3OhR;
	spf=pass (imf24.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759952205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=moKwOhdpUyJ4bZcyz0xhC/UoJ3xCwW2GSEFAUi/lwOw=;
	b=6nW+Fgg2Ed/H7XiKEzHQAVYkbdPMeAF6iK3yJZqoHzMXByxNdVKsKV/XyCcc+VtMS0EKhA
	rd/PCbgopbU0PGgDB4m9jwyK+gbRVDC3OY66rqxJhd8FAvbm7ddIYSP5soCAlwgw8TGUAD
	kudgqi7Dgd7vkcichFtdaulI+abyNW8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LKZD3OhR;
	spf=pass (imf24.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759952205; a=rsa-sha256;
	cv=none;
	b=aEeoGtiY0bMBeplUQIf5hNGyF0+3pFz6j6nJWAWR/xTwOBoO20mr8f6Hz/yFFucbS87Znx
	phDnyiKdTus5bObl2YLiVzRuxIN6l0jInuVEGZFQeIlSQNPA9uPc23kQHLiFWc452RCI1o
	CDLUipWx/TkmuMe3mmCsyAyFhV0TcVI=
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-71d603a269cso2453997b3.1
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 12:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759952204; x=1760557004; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=moKwOhdpUyJ4bZcyz0xhC/UoJ3xCwW2GSEFAUi/lwOw=;
        b=LKZD3OhRKiGeNHulmOeVbK3NRr9aBPhjF9L7UEB94qax+R1Q9ZcJ7jGI/+tK2NaV1b
         00n3i1kBzZJAH7J37K0fb5GSvsPP57Lv3szv/C7JnGeTP8oEmUclSGyRyR36mZoozwQ4
         dUqyGBTReco/TZydBTrTue1KKITQxlZk56zyN/Y2FBk1M6aPOx/d20ML8f9UhzwSLSPX
         25PheG7+RkjyDhk4Yr+2TehGyXj62TA09NKsEKzFR39I+nZ5W6iWGR9R27EhxIbbvVit
         YfeUkjp4wi7+A88626Svm6QVKfiJ+sujT5JXOGAV1DVhn4MXnC53x/UbcCQhJJuuJD4N
         PBpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759952204; x=1760557004;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=moKwOhdpUyJ4bZcyz0xhC/UoJ3xCwW2GSEFAUi/lwOw=;
        b=t6sh6nvx2swGXBMMjU0aAHI563xjv81MnKKCcPu+L6u7s9FXDpjl7iGh8QbBPKVf8p
         NklaYCeTxQ1yt0pZ5z/lckNVFZ8TGBwx2O8KDSwAMPBb3q358aKxbqjhOtJt/B0EMU+e
         jxzxn74vrtEuhZLFDCeYf7bKe2lm7GCjX6TvMdU/mBNAzsxXx3Sj4luGyfi23ESAVOW8
         23U+5SjUWmKEMGNKWdLyp4+RgLNocblL1iwFbCEvwmPB6OjmVdIdPwBZb8tjUbRN1KCp
         trI9sVBrpeZBAYTS953P695NM2VscgyXXkt7UfJZZ1FSYlAYdYo5/Mv/KQ7I2Bce/+i4
         jENg==
X-Forwarded-Encrypted: i=1; AJvYcCVikDMNhOhfQoP9fo/OOKPcGU7mmku8JO3Me8KxgZ2JQWXbXQDQjtArr0C0VbtE88t5FkJGJm+mCQ==@kvack.org
X-Gm-Message-State: AOJu0YyVkN0nuiVsKBtmbWVfQ0aZl9WEikPHNR00HUBLAkE3mNO60qqW
	SLDGdCSTw6Ol6dERlhXcJsbiEOxY+p4EZ48Nnnu9owcF6MUw+3i8eYfQ
X-Gm-Gg: ASbGnctsBrUpSQk5kQ5XwfSQbh3wNHKKQjkck+nrDJ0mvmWGJvMmvKODRUbed+FqbyD
	SXAHTukSZ8RBYwMOAjkYzMHtI3Rsz5vFCy7gMC5d5yOWqVHKUZSsxQWy/AvHXJUt6KWAPLsRYbJ
	DsYmEULt80y6IB4sPpvIzS5QWnZnCqJc5LRZpLtvdIc3zNB86trJOBrJg/M5kFehj+lULEkZG13
	QesoDWklWB588w5kHOg0Z6r+hxgwQN6TFoV0JXkGVy9rVFcKa/fjvfSNZAlrpYpq3m/AflOR+u0
	fHZ0IWAj+WrATLFr7oBIyXTjqcQz9S6HFqs8hD3AdLxCcPyocnEakE/ZuCQOLewW+hdljRPa1uY
	aDAapmweOWMKIhD8QAh/+W6sAmOoOd9HpcEK8olq7iVXIIBc6/NScBRW7/L2X0SjPZExams2fYd
	bcYoLYGo/um30ueQ==
X-Google-Smtp-Source: AGHT+IHtB8Z8ID/pyVnrYXDZZOQNzUqtOOHCwxuT0b7AWpclaN93NeUezX9digLJSKp1/ekVgKu9Tg==
X-Received: by 2002:a05:690c:9a8d:b0:772:72d1:15bd with SMTP id 00721157ae682-780e15bd334mr60790547b3.44.1759952204064;
        Wed, 08 Oct 2025 12:36:44 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:4d::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-77fa89e5b38sm46859517b3.44.2025.10.08.12.36.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 12:36:43 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ying.huang@linux.alibaba.com
Subject: Re: [RFC] [PATCH] mm/page_alloc: pcp->batch tuning
Date: Wed,  8 Oct 2025 12:36:41 -0700
Message-ID: <20251008193642.953032-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <1b72c0b1-4615-4287-bac2-c8806e56f44a@intel.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 51DD7180005
X-Stat-Signature: hwnp75tt4zs31b5jgpms4ynjcypga4cd
X-Rspam-User: 
X-HE-Tag: 1759952205-872415
X-HE-Meta: U2FsdGVkX18RfJa9UNkHpSVpnjBdaZLCXIKPl6jWqNgFRHlK7qh/jzOhNvFZ6oTmYT7nt5+rfsRD9XMoo1c9HWmuF8CiZ0SYeU3LEo0RZIMD10PV7EZUo0817pTS7AjGKv2wgVMz5JHSV0CLhBuQ3WM0T6jKbsykyZpFRuYp0DKpmZRLpMUeRasNT9q/tEuotrLj7f1gkhnqS1ka85ThTYV2z5xYmH5Bqk5yPHtBiUc79phnevEXm84p79LuTv3IdF2zauTmzVrQpRvr7FOt57nckTUzHGnYzIPHITxJfJCb+gGcpyce+9JygiU67Ec4RuRbTPNUMbMKRBgrefvQ6TEpXowutLeDormbwTGnezyoaSWexHUtUjY+p30O/yAo8kBpsGbQb6f7m+yhiMk4uR62xRBPjwR9gYLPJaJTuC/KyEXS8eRUtgXFagg8Yl5o9+rKaOx+IX316py7wNS2THEGHtxD31QJ2/G7ygyf5T47R4uDGnaPKgt1fAgkEP/Tatp1GuBq85fm8v3UAnlB0AK2Qd2fYmbxtHoVjwTuoEyeUgewnxFP6HWzJFz0ATsrnLXtmoaz8Nb/QmaMmx984Z+zERDRByVpWVL02zzbyp6XOibwOHrgj5WlFC3IR2NF9je6HqepGeWR5Tj1zDUi4+kzYB8m4IOgUnaMNbNHYfnj03DT3MfbtiihMNFQ4sYtb9f+q4xKbB5gRqfYqAppmGYN3lCgcRQ4glaWpkJBQVh2g9nzeaD/lPz2Ps1fo2fXD3SrY54Df/QIxuXbfXL2lIdZyPL+sKq/lHUp0TfbcmHDgUb/PxwgEnHBx7SA/uo9MQrxjBm7p2yhJ/yHs1oyESd7ZSsIURxnzwhA1LIJuYS9CaO0LpQnK5Nt6w408XRCu6/sMQbb2NnWvr5LAuBhNbDYHtb7Nfid7E6gBMIhV6KIMHa1J4oPcvH+d/A3uZ4EdIaLBIKznrQME6Snqum
 5fjTl0Af
 wh64VIMgJVs/v4YNvYRHNZutW5ZsPJeUKbJ6KTSv86cl/ycsOvTx9uMtV0SXISDoRxkk95D134Oc5FQFgp5XHOkAfuEY8e8DmvPaLEU4PTiA2zvumsPg2aZfRteKYA5wXy1m9VEiiL/MA/cuUDkfOVuJ3+JOmTSPD3j9A9BpUOnXB5yQarQEO+b27T/0cb/OPoogV7vlPsEf4cnUazo/Ho83kdJbMSI7utPE+XL61J/B3zA7LstWlEpxnCb3aAEnLRILYXGO2A1832UVuLRrFeB+5McsARd9dgTnw9Y/31Dmv9Tfzf+U0z/7Qbxh0A2JftuoGANWO0dLClcZ8GdVvj4YK1k5I45l7k5QlcXsGPl0CzqVxNjY/Zv8HR9X5UOmzbUdCOUv2o23L9/fHQwolu8IMOpaSaVrTfVrt1oaKSj4ctcH3OkOq6GDQuT6UdjuRJODWMv3BhjHxTBuqwdHf7mm5yE5AHjp9+VCa1RQ3nS77p+kTo1Rd3HSF7O2NWyM/F3AtL22tIAL+VXHaTCfaiW9J5eV+rxOq1x8WspG4sLOl4pMcSbaCMqkLDVHB6ewontiV1Z3oRjwZRtk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 8 Oct 2025 08:34:21 -0700 Dave Hansen <dave.hansen@intel.com> wrote:

Hello Dave, thank you for your feedback!

> First of all, I do agree that the comment should go away or get fixed up.
> 
> But...
> 
> On 10/6/25 07:54, Joshua Hahn wrote:
> > This leaves us with a /= 4 with no corresponding *= 4 anywhere, which
> > leaves pcp->batch mistuned from the original intent when it was
> > introduced. This is made worse by the fact that pcp lists are generally
> > larger today than they were in 2013, meaning batch sizes should have
> > increased, not decreased.
> 
> pcp->batch and pcp->high do very different things. pcp->high is a limit
> on the amount of memory that can be tied up. pcp->batch balances
> throughput with latency. I'm not sure I buy the idea that a higher
> pcp->high means we should necessarily do larger batches.

I agree with your observation that a higher pcp->high doesn't mean we should
do larger batches. I think what I was trying to get at here was that if
pcp lists are bigger, some other values might want to scale.

For instance, in nr_pcp_free, pcp->batch is used to determine how many
pages should be left in the pcplist (and the rest be freed). Should this
value scale with a bigger pcp? (This is not a rhetorical question, I really
do want to understand what the implications are here).

Another thing that I would like to note is that pcp->high is actually at
least in part a function of pcp->batch. In decay_pcp_high, we set

pcp->high = max3(pcp->count - (batch << CONFIG_PCP_BATCH_SCALE_MAX), ...)

So here, it seems like a higher batch value would actually lead to a much
lower pcp->high instead. This actually seems actively harmful to the system.
So I'll do a take two of this patch and take your advice below and instead
of getting rid of the /= 4, just fold it in (or add a better explanation)
as to why we do this. Another candidate place to do this seems to be
where we do the rounddown_pow_of_two.

> So I dunno... f someone wanted to alter the initial batch size, they'd
> ideally repeat some of Ying's experiments from: 52166607ecc9 ("mm:
> restrict the pcp batch scale factor to avoid too long latency").

I ran a few very naive and quick tests on kernel builds, and it seems like
for larger machines (1TB memory, 316 processors), this leads to a very
significant speedup in system time during a kernel compilation (~10%).

But for smaller machines (250G memory, 176 processors) and (62G memory and 36
processors), this leads to quite a regression (~5%).

So maybe the answer is that this should actually be defined by the machine's
size. In zone_batchsize, we set the value of the batch to: 

min(zone_managed_pages(zone) >> 10, SZ_1M / PAGE_SIZE)

But maybe it makes sense to let this value grow bigger for larger machines? If
anything, I think that the experiment results above do show that batch size does
have an impact on the performance, and the effect can either be positive or
negative based on the machine's size. I can run some more experiments to 
see if there's an opportunity to better tune pcp->batch.

> Better yet, just absorb the /=4 into the two existing batch assignments.
> It will probably compile to exactly the same code and have no functional
> changes and get rid of the comment.
> 
> Wouldn't this compile to the same thing?
> 
>         batch = zone->managed_pages / 4096;
>         if (batch * PAGE_SIZE > 128 * 1024)
>                 batch = (128 * 1024) / PAGE_SIZE;

But for now, this seems good to me. I'll get rid of the confusing comment,
and try to fold in the batch value and leave a new comment leaving this
as an explanation. 

Thank you for your thoughtful review, Dave. I hope you have a great day!
Joshua

