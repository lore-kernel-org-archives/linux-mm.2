Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43E1FFF886F
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 22:50:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6071E6B008C; Thu, 30 Apr 2026 18:50:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B8076B0093; Thu, 30 Apr 2026 18:50:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D00C6B0095; Thu, 30 Apr 2026 18:50:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3C7666B008C
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 18:50:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CF3C816029C
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 22:50:14 +0000 (UTC)
X-FDA: 84716717148.16.EC7B347
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id C031580003
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 22:50:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aUY4HkFZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777589412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nyIAHMCO2XSEKhIrNQWe82Ob3aOc1tSJG1laNn5OlYg=;
	b=nG3ptk+kgnRkmO3YyV+fZWOeFnVoQwsUjdAfgrvx3o+2hlPJWRhun7nFHuwCkpOcWM5eAO
	TSF3LDB78qIlrbXQCfvAuDY2QRzO5tZUVERp8XxRpb2Y3sUMYLDKPOnmzhYoN4+hm2hfZX
	UuyKwrsCjITwSZfupDH2DRVZBqMUu+E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777589412; a=rsa-sha256;
	cv=none;
	b=e8tOIP84cHw01ngcmoX2ZIIBwGgCDKNYvn+0CPW7AhEGtSuyP/+Ho65d6058xKesd3UhFb
	t9tHTQyjSvdkf8wTxfxqGg5I2rtuTtqTEgT6SW/IyyN1pKB20UYs585CK7gYMcIcte0R0K
	iR/ypM7Vd8MmnUnStf3peLqmvWqQ44M=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aUY4HkFZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C62034182B
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 22:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B6EC2BCB4
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 22:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777589411;
	bh=EwR29NH5HVcLbVvA5ViI57mAmHT3DBCHHsLg0gf7Cic=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=aUY4HkFZ3F+KafBZ6OIkMxG6Y2Y8JS0FkY2PwkYxuTz+cVn9fSvKKE2YQdKg2spvh
	 6raIIT0c0G0ePpmsghCC437gEyvayr78D6J+ZfDO9V5YQtSzd7Q49Txdj8sCrPwiGv
	 nTorLwZPDzKzXj1JaDy4b8bZiPOPzaVu0F5DU33VbFYiekEHXoBc+YKL6EanXCk8OI
	 2OlcfkYa2d//mAOSPB/KGJLahibeY8cRf9qyJuPV45PMMgigulWUS5oBj2Z3DThLd1
	 cE7b5V3TuSZpd3XhhW1dCSSU04W9vcgqB90ZMKhk38hlUlzHFYKkCiSFrBZzOaF+BI
	 gOTxmKJ2LTVbw==
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8a093c784b0so12551856d6.3
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 15:50:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/cVbvTW7hwXwFDJT4HqxzeXMHpAI8N+BJVAGp3ZunIuwB40H6siMAWar1KPHYwjZXHyduT4Mgfkw==@kvack.org
X-Gm-Message-State: AOJu0YylG1hEem94R5v89cofTH9WV8QRdO02SKFG1E7OkUMRA/kvcQH/
	BW1u51S0fJBRbG9KRES+bd3XeEP0ccHlJH7l4ZXrY8XECxRx4IBjyklemu4AaKUjVhVnpvWfko6
	5S0txcQcioZyPAUmrtg8Mx+XyXMeGMaE=
X-Received: by 2002:a05:6214:3f81:b0:899:f092:9da with SMTP id
 6a1803df08f44-8b3fe7bd179mr81439146d6.28.1777589410935; Thu, 30 Apr 2026
 15:50:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260430040427.4672-1-baohua@kernel.org> <afNM-gIqxpyJ6ro7@casper.infradead.org>
In-Reply-To: <afNM-gIqxpyJ6ro7@casper.infradead.org>
From: Barry Song <baohua@kernel.org>
Date: Fri, 1 May 2026 06:49:58 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4w0qcYmukHqsyRd0jomoyYkJjOt8b-Cgp53BgP-8QQghw@mail.gmail.com>
X-Gm-Features: AVHnY4LNqeENq1Hu8yfE3Ha6l6qy4pcPzLhOvHSM0QbVepERNdbmRODWwcwvH-c
Message-ID: <CAGsJ_4w0qcYmukHqsyRd0jomoyYkJjOt8b-Cgp53BgP-8QQghw@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
To: Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, david@kernel.org, 
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, jack@suse.cz, pfalcato@suse.de, 
	wanglian@kylinos.cn, chentao@kylinos.cn, lianux.mm@gmail.com, 
	kunwu.chan@gmail.com, liyangouwen1@oppo.com, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	bhe@redhat.com, youngjun.park@lge.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: C031580003
X-Rspamd-Server: rspam04
X-Stat-Signature: bbrahrsjnxth1bsfe6b3kk979xo7wtzz
X-HE-Tag: 1777589412-711990
X-HE-Meta: U2FsdGVkX18iapIO5UzEB4kHxALD+f5tfGQ33ss72fYP+1sja3sAd5ON7TBhboPOb0vqRuKY+nkz8qXWgeNyQx0EnGD6tHCG3+iQT8DyMbAwmxHbqljlIarIh5+Q8aWNpMS+cNRDIOdJa8/tIiHAoWY4c6qsRYX+YT7UKREqSgiyY1zyAqWophPMczFR04NA+XdnToPx+3IB+ZD4n8CRZK0twJ58efiWc713wWK1RE3TS35ar9JvmG1mRUb/3X8MtZY6t1ifOW/feGKD5/WyWyHdhxNu39thFNhpIxVuDDDQscRCO4p4H/a//rRxtoS3EpBaIHCSk+WhOFqBir+MUT7lQTekkYuNOat2qCn1FDPlVqdo4SqPEBdKgVKzloIw3BVpVOPVx8ivVoUE220j80qapQ8GqP6JjH29h2p9hAB23m1b/kbMR/bXqcvPfz+27Mf9JqGY5CAFqJmyRO5USi1BLiDE+5oiO2mmR566YxD78DnOCpQ92t6UEYH66LT9i0Vdos09gDhDhKqdM9rHMMZ/3cbxhRt5DCULiwuttS6hdG6BKaUm5XIDWuWEMhme1QTHVnePYIyuWfjBVHlYcgBQElNhaAouUPMXVEmAhTWHVhZHjqbSpvV5/l0BLQNmYCx3cHGBckY29FDqPL82cHCFke1U0yc2VE8GrUjOsqFwrCtWj4NMrPkDrFxyj30iOUvfrAXggkWfiNBr3+xRlN5vKTGzB6oF6GE98gvmtdM42Wn++dLKQ3rTQu3zof0t+oXG6s9R2HZXcgqeOArsx8DL7RTI+E/0yF5HkuQxTwDpSP70rivWbdWRXN9EV7lalIqyqtqPGu91DatqvW1pI/N51azLmyHIYS5MGPdPCszmT9IpbqY9BLlAvNtMS308Mb0MvlfQcGIHDZzl1Y4eIObP/tEJMdtsyJkV8bkGZmT2tVbY+bkO3QQcBGBu/wxfo6hYF9iWz/RCxGu/JY4
 009JyIMr
 ideS9w37DqVifR5ek33WLcZ2y0jMt5pr+FxXO1DviEIrUwZDGrzRaKr7okOLDjKBJHN6ZqyGG8dZkrMV7uSbTmRNfhD59bYF+mw7b5Bt0ZdVMaSc1VHD8CBbWiCJQ3pX03bnUZE4ToPBQdCVl2RwRlI/ZILqwXnSrBaLb269BSyXzOGUwy5Z7QMCXIFEmeRUciBWaEEXjIc3ZSfhhwC1jLGFjO2x2epq/4jxTKtWRMkjOf+ZKJ4y4S/M6jY8J/TRRxpEz8B2zjaCXlRsms64PwI8asuE5wAH1/r3ArxvugDcctVfMIvEXPZrUe0e/2s9WzDyrEOrCY1g/q+fjEdBI31KI7cssM2DnSXI+WoXzPbMYQbSmUglACkZMFC8EONAkdFucGF7TRS0e8GhA7nOTv7IpE10tmX6vFK464i/EF/29xWJpPhlpOmiD698g89qm1WlVgHaLoNnFcoT4ZblO4bLu1XUc3LaRdJoYWmrc1dCAtR3wmmQndJmdvaekCtrrHFE7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 30, 2026 at 8:37=E2=80=AFPM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Thu, Apr 30, 2026 at 12:04:22PM +0800, Barry Song (Xiaomi) wrote:
> > (1) If we need to wait for I/O completion, we still drop the per-VMA lo=
ck, as
> > current page fault handling already does. Holding it for too long may i=
ntroduce
> > various priority inversion issues on mobile devices. After I/O complete=
s, we
> > retry the page fault with the per-VMA lock, rather than falling back to
> > mmap_lock.
>
> You're going to have to do better than that.  You know I hate the
> additional complexity you're adding.  You need to explain why my idea of
> ripping out all the complexity now that we have per-VMA locks doesn't
> work.

Yep, I know you don=E2=80=99t like the added complexity, but I would rather=
 prioritize
user experience over simplicity. Let me try to explain in more detail.

1. There is no deterministic latency for I/O completion. It depends on
both the hardware and the software stack (bio/request queues and the
block scheduler). Sometimes the latency is short; at other times it can
be quite long. In such cases, a high-priority thread performing operations
such as mprotect, unmap, prctl_set_vma, or madvise may be forced to wait
for an unpredictable amount of time. For example, if low-priority tasks
trigger page faults and issue low-priority I/O, a high-priority task
requiring the write lock may end up waiting for an unknown amount of time,
depending on the block layer and filesystem behavior.

As a result, high-priority tasks are exposed to unpredictable I/O latency
introduced by many low-priority tasks that may generate a large number of
page faults.

On Android, latency in certain tasks can significantly affect user experien=
ce,
such as interactive threads. Priority inversion is particularly problematic=
 and
should be avoided, especially since we have no clear bound on how long we m=
ay
have to wait for I/O from other tasks.

Meanwhile, priority inversion can propagate through a long chain: a writer
waiting on I/O from multiple concurrent page faults may end up blocking oth=
er
writers and readers as well. A long-waiting writer can also amplify
mmap_lock contention, which we still rely on in many cases.

2. VMA sizes can be highly uneven: some VMAs may be very large while others=
 are
small. We used to have many reasons to release mmap_lock when we did not ha=
ve a
per-VMA lock. Since VMA sizes are not uniform, those same considerations ma=
y
still apply to the per-VMA lock when a small number of VMAs account for mos=
t
of a process=E2=80=99s address space. I recall that Suren also mentioned th=
is[1].

So I would prefer that we hold only the per-VMA lock and avoid retrying the
page fault when we are reasonably sure that I/O has already completed and w=
e
are only waiting for short-lived conditions. Uncertainties in the block lay=
er,
filesystem, and GC behavior, as well as latency-induced priority inversion
chains and potentially amplified mmap_lock contention, can significantly hu=
rt
Android user experience.

[1] https://lore.kernel.org/linux-mm/CAJuCfpFVQJtvbj5fV2fmm4APhNZDL1qPg-YEx=
w7gO1pmngC3Rw@mail.gmail.com/

Thanks
Barry

