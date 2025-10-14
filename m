Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1828CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 13:42:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFD668E0121; Tue, 14 Oct 2025 09:42:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED5748E0120; Tue, 14 Oct 2025 09:42:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEA8B8E0121; Tue, 14 Oct 2025 09:42:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA29A8E0120
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:42:13 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 88BC911B0C5
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:42:13 +0000 (UTC)
X-FDA: 83996833746.29.D98428B
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf05.hostedemail.com (Postfix) with ESMTP id A3983100003
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:42:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OYiVq1Ad;
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760449331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iShRlMjD16vCOvZiANOmQCZA2Q2Y8AtPdzjclXG3tnc=;
	b=YHom2d3u4kEJal7LhmKqyCb56W0UZYlkICtfecpClAK7iqMX//CKD+O2Lbet903I6nLMn8
	QDrgRyU8h15WXI4DMSChEJm9fCNrGz9ZxsP1nAyYW2SwvehDDedv8ppyqB3gUk1wcolJmo
	vMJZKprptoJ+KCUK9tCiXVwR+FcA26k=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OYiVq1Ad;
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760449331; a=rsa-sha256;
	cv=none;
	b=RUVZGv9KH39TI9XsBh449bjs3ohFu9LvII4lko8el8vdyPSUjgW+OIUpdmzw9fCLKhocs3
	cQST1b9e5cBHj9Be2ktnKOeZ/o3ZqzdPJU2PsSBEIGB9M/xGEaPKxB7b4kYR+w5Gwtml8D
	OVb6+BvQirQewYBMn5ald2W9T1VZ6yc=
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-780fe73e33bso41819337b3.1
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 06:42:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760449331; x=1761054131; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iShRlMjD16vCOvZiANOmQCZA2Q2Y8AtPdzjclXG3tnc=;
        b=OYiVq1Ady4nm3ZgOzpd/jCJ5MPmbGgLm1yXAxOOF+0pWuSfPEpcMATCY9J4/VSSZ0m
         5vG+9704153lC1A+UPWXLu3jdpHfTwGx8s49iUIn5XDCCbfl838I5maqGJIHt3UBEmJo
         RYQoKXit9FoM8PhoqwXsK5tgYOqO3yyKPOVG1PNYU3G5605+laj1p0kUgLZ+I9hVsn8n
         ad90alG4aSFFaHI6WGjc1tf+glas+20iGnRvYZ5g3mzaf0QVoGWTHKpOnRNOApUPhMn+
         u/V0eeKZoTN/OCR8qbWt+vxQGEH8rIK6u3ym+yG6eO1HT+X0faVO/GwoJbwQrxLM5okr
         VP4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760449331; x=1761054131;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iShRlMjD16vCOvZiANOmQCZA2Q2Y8AtPdzjclXG3tnc=;
        b=B7lyszONbecYz4C4KFZlOT+0io3NSfkdjPQQC8WRe+SxJmLKjPmJcU2W40w3L0pU+W
         n05X/8S7WQVg7hog5nCz/xEC3vjSM45jt42PqvyRi7GaoRNt6SF1DS8w9/0Xr17aki4p
         ZvmO8DeFQbleKjvxgbFxDyNK5X6NWaJxgxvZz918hN+92A1b7PKlUXNxs4cFJ35xmNnh
         AtQ2hO7rmiot4c9Sy7XAg+8+OpvDsE6OVy8wUPZwKor0DVfQhU9CSAeqQg8y5jhkUqS8
         +dMKbd7CmAsF0+FSRGx6YmVjmVRxjywWSlUoCRnefQDQMqpl7ysrwzs4FBZ95/eROeC3
         3ufQ==
X-Forwarded-Encrypted: i=1; AJvYcCVmLEelRU7nPqlKqhvuByDKT+NhvbLVIGdjpm8tEoiVgHswcvJrmvpNKTif8USSP40I2XBoDTnfww==@kvack.org
X-Gm-Message-State: AOJu0YzNYSPZPKRMkYP9xiqULRmAW/fngqY1I/efJC+Pfp8pHwdmLv38
	r9fPxLtBpBDUNPaA3xQn5j5u/53nw7XFyBQvvMnmRpHZg01a203ngL51
X-Gm-Gg: ASbGncudJ8EsZyRVV+v4XNjqUWkWlQRVYacf4cAHTNg/S0WKoSb8pMwrVVGtL9rlPet
	1PjNKLZ6Bo4GzpwK5S0t94McLMmlRqosT+Y42/l+lrUjfMh0UUWfj10Lcvrxn1xc/XMQsKxgGDM
	mAYcMzqonjrGPinJMCFTQoKuO6VpXqaemguX9J44YW58e2ChZbYEFbkwahxC/MjZE81XvOdvlB6
	z32PSEJgA3p8sQE/GEQm5ASGE1fPkuZq/hZMb3M0uEtaQTtuOwCmYYyRG2ODRMKStuxzve093z0
	WEjgoYQo/W1fLiE7nkIBN1KT5BIrPq7EcMrVEXa2qUQkTEyYi1P/w2jWTDU7U5IOLubPVgLdt/m
	U9xTUp4f25C5uj383QnjbzVF/FO+OBUTtapvT0eI0q4QTb3Xv7pXGpZUOAT6ifXQSIIUkS6n96a
	+JgAiWY5rf2uF9JqJA+a2uU63v+VJPJw==
X-Google-Smtp-Source: AGHT+IHEmGnQT19nB8fpJYZ36lJocxSeUy5ie5UanJzwR4STBWqUUl84lcuO3sceBz22ooJBZ+7W0A==
X-Received: by 2002:a53:accc:0:20b0:63c:f5a7:3e1 with SMTP id 956f58d0204a3-63cf5a70b41mr9090122d50.61.1760449330421;
        Tue, 14 Oct 2025 06:42:10 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:51::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-63cd95e3f9asm4749876d50.21.2025.10.14.06.42.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 06:42:10 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Hillf Danton <hdanton@sina.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v4 0/3] mm/page_alloc: Batch callers of free_pcppages_bulk
Date: Tue, 14 Oct 2025 06:42:08 -0700
Message-ID: <20251014134208.2826738-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251014112946.8581-1-hdanton@sina.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A3983100003
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: uuxopozsa8789sffgrnx9xw8mqase197
X-HE-Tag: 1760449331-459363
X-HE-Meta: U2FsdGVkX1/hOaCo0927LE58QI6kQiVcJ1aogUAkBbJAY3aIAbNPpKpJbwqulXTFKWBE9vGvFSYPUQxnafVu4g7Cvjr3fV/EPngEqBOoFKXTFsAI9vhzae/5LWieM27/EH5d5sxkLaHn8tBvtQU0zxqtqufAtq40i/+XGn13wWqdMGIHTxtxnhRZkeuJ8sWBDuZV6ZSbrOVb/O6cmuPTg7Wj/KG4R3auccG4xgvBc3H+UFW4WvsWGwJjovdwpOT7KocmAjY2nDUkAa0CWavSlSlQ1s27XGzVgMDid+lY2nj9r6wt8efK1EI7MwBcfTR+7E+061JcaYLSvHnoFVb479r/0R5yQuNy0hdm341tHl7LP0WN6jhNZoOJhD4Vf/Gsdd89rWAXjhdZ7Znzd191QmqWODqcUpO+/fTYjQfLQ93dvEa3dKnEyyCk/BN3L8AnW/KgU5SVVnE1hTM4bYjFOL+K1yqqrxUfbgmQ7pLridUXF7JC8PEYLF7SO/c2t7Rrqo8OpLfyo83AFPWtxtbVYeAA/PaCBn5KFVIOOxu0aU6uctqBGwvEj0Feh1NYzHxdqEbb5GUWZioaoITwm2jAeW8q0+066h734bVE0Zu98cVKDJQUSNSi6wBOinRXnYWdP1ZYCQec1vrCwEUJZd7itDAqq8N+r/f84Fj1dkPXjXr9bDfIt8HdQG5xssoHxIqkVjTSJxG7othTxRLKxZI/IYliQpTfmQNQVFYHKkv6OP7lm3wX75Tn499dPLL78oqadwk9n0aExZ+1O6RFjbG9ud1QOadH+Kc8EwnpT60wO1+8vQ8Hm7xEyLlqrV3es2R+M6LuTbMg+Xh0WbpKuaBehMenO83kLnaAj37LIrIIfpwxFe7wSf4vXUVZiBS4Zh4BrnmI/He3NLyyzwcXWfRYxEkQ1Wh9+hC5xA0m0KAao0ugz0BWnJbgL1yHmTJ+uMTeqvgytFiEONzDCsHi+JM
 wKH54eJh
 47dQSTjwh3NSKCRkWqS/p/SKoB4G2nx9uxQgHvuGAw5UOjrbOsSeBLG0L6QiXHBMwxiz2KzZ/CsSvOYydklTscH9jrhyONmFl4T/KDbQHJYZtk1xqIQBys2VevC2Tmj0Ofy2ZgOSUWqYqWLOwH+815SxTYhcaR+U8zz+cEeqgMZpXcc5FoPeVcKkcbrV+v/Tmq47rzHq2AW4+GaREkWedVzYjViGuvDPQXWHWsPQ8rfhi7hyLK5ln8lFq15/dB/8HmcKn3HD5aGo3u6v91GvSqxkxNHWWc3i+C5vkOY3Pxzb1KfRq3k2HCuVn2gA8PbDbqCA+dpFjzLZk7H6RPO3xFAFp7wLfXatXXQR22rXYg2+Gwc5nMZmJIbxsjGlDr2U64YGOnzyLnB7fJ+GdE1R5YBrPflPACIYfDwLqiTtgYp7+u6oulC2ZFEtI3Qewb2sHx4uO86X+M3qk3/JfTVpshDQgxikbe0JbxwycXyvaSZ/nYu+xzp2NjD3lsjpn2WIjEXbxDANPXXWn8EJdKL04jIB5sDeLiH5hw0xkEpSogZCE7oXGWlsLBeAtKws0l4Cik9rfmyVqFDTi0YM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Oct 2025 19:29:45 +0800 Hillf Danton <hdanton@sina.com> wrote:

> On Mon, 13 Oct 2025 12:08:08 -0700 Joshua Hahn wrote:
> > Motivation & Approach
> > =====================
> > 
> > While testing workloads with high sustained memory pressure on large machines
> > in the Meta fleet (1Tb memory, 316 CPUs), we saw an unexpectedly high number
> > of softlockups. Further investigation showed that the zone lock in
> > free_pcppages_bulk was being held for a long time, and was called to free
> > 2k+ pages over 100 times just during boot.
> > 
> > This causes starvation in other processes for the zone lock, which can lead
> > to the system stalling as multiple threads cannot make progress without the
> > locks. We can see these issues manifesting as warnings:
> > 
> > [ 4512.591979] rcu: INFO: rcu_sched self-detected stall on CPU
> > [ 4512.604370] rcu:     20-....: (9312 ticks this GP) idle=a654/1/0x4000000000000000 softirq=309340/309344 fqs=5426
> > [ 4512.626401] rcu:              hardirqs   softirqs   csw/system
> > [ 4512.638793] rcu:      number:        0        145            0
> > [ 4512.651177] rcu:     cputime:       30      10410          174   ==> 10558(ms)
> > [ 4512.666657] rcu:     (t=21077 jiffies g=783665 q=1242213 ncpus=316)

Hello Hillf, thank you for your review.

> > While these warnings are benign, they do point to the underlying issue of
> 
> No fix is needed if it is benign.

Maybe this is poor wording on my part. What I mean to say is that these
warning messages can help us understand that the system is trending negatively,
even though the warning messages themselves may not indiate that something
has crashed or broken completely.

> > lock contention. To prevent starvation in both locks, batch the freeing of
> > pages using pcp->batch.
> > 
> > Because free_pcppages_bulk is called with the pcp lock and acquires the zone
> > lock, relinquishing and reacquiring the locks are only effective when both of
> > them are broken together (unless the system was built with queued spinlocks).
> > Thus, instead of modifying free_pcppages_bulk to break both locks, batch the
> > freeing from its callers instead.
> > 
> > A similar fix has been implemented in the Meta fleet, and we have seen
> > significantly less softlockups.
> > 
> Fine, softlockup is not cured.
> 
> > Testing
> > =======
> > The following are a few synthetic benchmarks, made on three machines. The
> > first is a large machine with 754GiB memory and 316 processors.
> > The second is a relatively smaller machine with 251GiB memory and 176
> > processors. The third and final is the smallest of the three, which has 62GiB
> > memory and 36 processors.
> > 
> > On all machines, I kick off a kernel build with -j$(nproc).
> > Negative delta is better (faster compilation).
> > 
> > Large machine (754GiB memory, 316 processors)
> > make -j$(nproc)
> > +------------+---------------+-----------+
> > | Metric (s) | Variation (%) | Delta(%)  |
> > +------------+---------------+-----------+
> > | real       |        0.8070 |  - 1.4865 |
> > | user       |        0.2823 |  + 0.4081 |
> > | sys        |        5.0267 |  -11.8737 |
> > +------------+---------------+-----------+
> > 
> > Medium machine (251GiB memory, 176 processors)
> > make -j$(nproc)
> > +------------+---------------+----------+
> > | Metric (s) | Variation (%) | Delta(%) |
> > +------------+---------------+----------+
> > | real       |        0.2806 |  +0.0351 |
> > | user       |        0.0994 |  +0.3170 |
> > | sys        |        0.6229 |  -0.6277 |
> > +------------+---------------+----------+
> > 
> > Small machine (62GiB memory, 36 processors)
> > make -j$(nproc)
> > +------------+---------------+----------+
> > | Metric (s) | Variation (%) | Delta(%) |
> > +------------+---------------+----------+
> > | real       |        0.1503 |  -2.6585 |
> > | user       |        0.0431 |  -2.2984 |
> > | sys        |        0.1870 |  -3.2013 |
> > +------------+---------------+----------+
> > 
> > Here, variation is the coefficient of variation, i.e. standard deviation / mean.
> > 
> > Based on these results, it seems like there are varying degrees to how much
> > lock contention this reduces. For the largest and smallest machines that I ran
> > the tests on, it seems like there is quite some significant reduction. There
> > is also some performance increases visible from userspace.
> > 
> > Interestingly, the performance gains don't scale with the size of the machine,
> > but rather there seems to be a dip in the gain there is for the medium-sized
> > machine.
> >
> Explaining the dip helps land this work in the next tree.

I do agree that I left this on a bit of a cliffhanger here. I'm a bit confused
as to why there is this kind of behavior as well, although I have a theory
as to why this behavior is seen. Going back to why we see zone lock contention
in the first place, I think it might have to do with the memory vs. processors
ratio that leads to such contention issues.

The lower the memory:processor ratio is, it seems like there is already
less zone lock contention. If we rank these machines by their mem:proc ratio:

Large machine : 2.38
Small machine : 1.72
Medium machine: 1.42

It seems like this is the order in which we see the gains as well. I this
explanation also kind of makes sense -- the more memory we have, the more
memory each pcp will have, and the longer free_pcppages_bulk would have taken
before (and vice versa). This is the case, at least for my setup, where each
machine is onlined in one node (zone) and so the pcp watermarks really
do scale with the size of the system.

I didn't want to include this in the cover letter, because this was purely an
untested conjecture.

I hope this helps!
Joshua

