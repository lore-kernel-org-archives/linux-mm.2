Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40588C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 11:44:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF6EF6B0088; Fri, 10 Jul 2026 07:44:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA78D6B008A; Fri, 10 Jul 2026 07:44:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C98476B008C; Fri, 10 Jul 2026 07:44:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 988B36B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 07:44:35 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1498BA0409
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 11:44:35 +0000 (UTC)
X-FDA: 84972684510.10.E78F6EA
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2DE7618000D
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 11:44:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kgH6dord;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of devnexen@gmail.com designates 209.85.160.51 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783683873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1W19wWSuG0iYCLEvXWxpxOAlCnPTIm0FeKu7uLWgRBU=;
	b=o+6nusOftFkMlAwdDYH04F2byshZNZ3vaTnD7smKkqdYVur5m3JOHdAv/HZG+Qd332Q1IE
	Xc0cFEShzSdLz7xLiHflDAhfRnvs+g3kHa2TKAeX1fleeHVf4wGX7wGXRYyLsTUsQeD+CW
	p84a1aGkFqLFoXAGq8c2lj75UvyPdb8=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kgH6dord;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of devnexen@gmail.com designates 209.85.160.51 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783683873;
	b=7N+aEjIgRUM7YeFUGxIEXqUWMxiD+On/9xrkRpiwRqidGqawQjsqtqEIc00whtj9Ayj9b8
	Jx5penQLPIM/wNLkRjVBjIE+p/cQLzQCDe4MHRR3YrsazJAEdsu55jH+vRNWzJdvm1DRrN
	rPP9bQ5RKm5oE/IH1/pgCOjAI2Vy8yA=
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-4513435cdd2so306414fac.2
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 04:44:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783683872; cv=none;
        d=google.com; s=arc-20260327;
        b=j1HIDv5bGSra3FiCRoBi90C5wxonIfP4j/fKUO+IYzhDXEuraeSlKulRlzI5O9qPCt
         ujkAWEFALu3gkVo126rdfqbBRTdshYUMo9c7vh8jJq/tCEfeQSoi+pBg9sls6R3cvugN
         1rAx3h2jATpvqYCsYO4+7A5T70LZpLMFA5wikGTISi1f3TGrNZezZgEbrUGfbS2bPZZa
         t86r67rbh/hM6KBCAlZP2OL8qhNAdRjqUHBw8bvSudtrEyNuB1u2u+PnhBGpoBFDv4ei
         FnAYFRgZ2SsxdJs1Krby/NabambLTAftIsQ2q/A97zhcQOkYSRp6zV/2ziRBJuXwhtDp
         AyTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=1W19wWSuG0iYCLEvXWxpxOAlCnPTIm0FeKu7uLWgRBU=;
        fh=wXhEvHOOgs1Vp3vVg9OnQX0DvY+VdJCQjwJKTKjNkUc=;
        b=jvKRl3XzdCEUeU+aYBVTVhTYc4XGEEUlix9PteVd0N3h6WOYieksiuYSqJlA3obfbw
         /2YfouQpWViM+Myu0EWpYYmFq6HM4OZGDNTY5AM/r38Z7UEF+in65niQ1UPOs0X0cY6f
         zL2YcoA2ZuF5cqZN5j3J+zShYX5TquK7NsJGoo6+tHecSfDeW6vq6b7607YP015MUK/s
         +XV/kD80AGiEo0wELa0ts5vJHH5r5EQXmXv4fbHOIgabKQtXcx5+3QLCh4Dw6ZevIWiS
         KVs+b/vVqQx8XgEz/oFkJCmuWQ7Jd93cG3xJiShdtW9+xssicyHJTfv4GKlRQIqtdco8
         2Jfg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783683872; x=1784288672; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1W19wWSuG0iYCLEvXWxpxOAlCnPTIm0FeKu7uLWgRBU=;
        b=kgH6dordyiySyBVREKTQTllOUMcg11HekuD4p7GnJYvJNkkdkFb22OlLtN5DKe9tvC
         evW2wEIrJlOJvy2DTEgNGABkJ4zGdFjTw//JIwt+tcAPfaKkrOISX4xVxx3zQqChhDaf
         IwXGFYNqPAqHshbyANlbzlSj/QrdIttIYmjKv8RH3s1/tN/HMKV4NjSRG8KU+IpL71jM
         sEp+uS7fJEwh5ZYdP6Wku6+dt4Hv3cZkcEG1SZC1E16zmxyYfqH9tlspNPakbZUdCwto
         JpV4YDKoP1KHqvx3OVBwbwJQO7TtN8c6cjaYUXUYBou9aAZv0YBy9wFTE1I1pfvdVAak
         hC2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783683872; x=1784288672;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=1W19wWSuG0iYCLEvXWxpxOAlCnPTIm0FeKu7uLWgRBU=;
        b=VdD7dQLx+CzqxiUHgNgviAFObVh/ERxqiD/6c9in68pY5X/m7dDtzzYMgbhg8pR4IL
         50xYWAu5FJmEnWpttx6iM5SyOuTaOYnOhq209MIraKJICG795GgQkaUiQFKFSeaXC/zZ
         aTUMujIkGEcDc0QdIFd+FluXufp4t9VC2QGsENbU57vobKU6EtgYwHcfSGtkFR8064Rz
         IEGRSkcOFmoSGBrB7jDi1rwS9vr0m/V65eZxcDigyyaHnncEcsDuvBm3a6/5/imQn6qq
         ZIN26EVtz54PvjL50QjmKGaFbv7khl24yWNUk/8KKVV5VzsQ/HMQsR9QdmweDEkBZyJp
         cIXg==
X-Forwarded-Encrypted: i=1; AHgh+RoPPzOW0ec0muBLSqQbhnyPOEP3CFZyA5jdVa+HcuCTQgKcMnNR0Mh7dWNfCIYJkt72O7A4VaflqQ==@kvack.org
X-Gm-Message-State: AOJu0YzaIC/YMB/j76XGTkmQqzHDODPZpJpmsFs34c/Rmd1bJVb3PIJ4
	QtsGjHj6L3Dt3+Rffub8HF2DKvUT12XMn0+NPyvaJPtta2uSnu/eB4vcncP23eQ++NT4MdpPYez
	GNKsby66qc6oKFXgZaR8mIUljaA1G1wk=
X-Gm-Gg: AfdE7cnr+Z47OmtWMhgKTOqkooTJ+q4KraOU6WugHMuslcDZ8BqL/eEuKKTAc+upJrf
	I2udsonjZ3kM2UE04J8ZEccZSmsmSk0gbsUWFmSII5gAPUX+icmc2wdUdRCHot7q2Pc5wpS6H9j
	q62ARq4kzVDuOtiNUHTiqXScooORWWWsxj9ph0NjnvOijYnl+7d3N+McYT86/j7n/nl9eoTuEnX
	mCQu+6OMGY0u1Weoj+NP9iFFX1zKLHWawZhLjpJvQF7EWIarxi+3WE+z5RQvqFX2+rqZ9Hnsc2Q
	8iCpIHkf4FRc9o9Y8+F+GPBSF9g=
X-Received: by 2002:a05:6870:524b:b0:448:71f4:a28 with SMTP id
 586e51a60fabf-4516373d9d4mr7087933fac.2.1783683872003; Fri, 10 Jul 2026
 04:44:32 -0700 (PDT)
MIME-Version: 1.0
References: <20260710-series-vmap-race-fix-v1-0-5b3794c113fe@kernel.org>
In-Reply-To: <20260710-series-vmap-race-fix-v1-0-5b3794c113fe@kernel.org>
From: David CARLIER <devnexen@gmail.com>
Date: Fri, 10 Jul 2026 12:44:20 +0100
X-Gm-Features: AUfX_myjz4e4hoeh8KGxFCShwyc8M_PHWmZnYqgvQliJ8DmTRF2ndSu2LOcWe1M
Message-ID: <CA+XhMqwpDGYSQvDKrFz9XuQFiaz8_rgW0LupEzFhehSrFvUZaw@mail.gmail.com>
Subject: Re: [PATCH 0/2] mm: fix UAF caused by race between ptdump and vmap
 pgtable freeing
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Suren Baghdasaryan <surenb@google.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Toshi Kani <toshi.kani@hpe.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Dev Jain <dev.jain@arm.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org, 
	syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2DE7618000D
X-Stat-Signature: a8rni1msdhb6bphbfna15k4y8yby88qi
X-HE-Tag: 1783683873-580990
X-HE-Meta: U2FsdGVkX1+GuZzf/eDW2no9vHdtp7Dsu7Bcdw8K7ai2SufCswC6rTFjpiokkDoamUn36Lsi/zD1SZGzWG+Aj+Qpk+ji4EZC8I+3peoVa08O/DQfvIrwl1f9KDSDS7cZ09TdDuFYVu5fwqiu8rCYV/MCvdcwbh9X4kGm/2HgWbIYO3xTF/p8gBwKt5aWshGY0tUqVCZdbz4+3vGKVvBPzm3WOr1rxOzGLvBqKktWQtfecBsPgvCgqDoZzEr9s+JM71lpAs2ExM2vVnsfkWMNMh+cBmwi6sv0iHyT2dldtbW8w3sjkgTmOyu2sLfRwnfjTvC0f9lFx7heobom7s9VAttJoX10meCB/92S7ybGG8AsXyv44/Ex5yfp2CAxaG+xnQAJGfdPENDYiHLRDxX7nRu+r/rJj253XkoYnylc5FPNZ6nKsVdBvkXfc5cxeTOrwoRFysPcq6zw9oEjt7P16tzqBMctPJHp3m5oHxkMqL5NVHNZe/OjbRZ7fON1JICOTk3U3EZtV44Ba7EvVuo6qpWAnmjX0SztF3Oo2MpfhpTROu6C19GYbYdOiBJboljVLh0WichhlG6iR6NkXKudIsBNmAFaeXdCoIgDqAgJWJoAfUKCpE04yghPEFt+6RdkxvFlV4s17jfWG2Qi+J+1kOblcPlRnwdNMe7SllzamSa0CxZEtipBcEtNGBgZUT+ELCS3WpG7gOk6ltVWFKn46gq9rFmGICD+S+W7I2wYhYGxXTxELiTJuIFfeVAYYf++lbN2F8uEYqHHE0IixjePb0v9z3AMc8kdGRyaX2+G351pthZjmYasQuGRbYffQwX5+QZ3qqkM/3gu8+l7oX+fAPSC1aRS27STpAWKm6fpPhVPi/7Nq4fauvsrdwdVN0a418kqTX6lkeDHOhyWNvrOCZfejx+3bCr/XKJBOB6l6MrtWaYBh7C/OTmGDkdmjPZp0dPKfe2CjdT+sK3uJOZ
 ujs+EyXJ
 m6e4Lu24Y89vE+tVrR0dmWaF+w8td8+tsMm+FkEmTlmqjnBokHA+TeRSg9snyWFPNDx1yWE62mPeY6fiA3+KUYUWbGu+4RFHS+vz7qtcS8o0mFEBIVV48T5MLv5w0zf2tHSglPqSIFdNxUpIG7dAEfPrJrYSW48SyOFSGJYNEfcPYXbo1wBLscv7HrawzFoDnBaENQ+rlDlFU2eTPTik8pW2V8bC3ZJcIWZ60PgMaVwFZan+GmbxB5mog8VZjHU0xI/iQnTzBMfUIPbkQlLUTZOh7vcwnh3X3bDxhTvcUi5tm1vtqZWbKV/SRgxR9/K+murmikOs+OSoIlZ19UBRo2DByY2oEfu1ivXL8nNbIifIJOOJUZSGYOWc0WBAI7HEmPvtzYU6mM6gMOfv3q1A7yYA4jHLttArbq1HsCviCOcNQYq1zuCd5wlRQreET2edf1940OKeRTmrm+VnbVrm1gnKTAOdP4m9KEhLH1U/52K99GUDycxSGENb82lZIMd0YRUsuDjCyKo6mFZ9f+7yGwfvXU9vm/E1nMWuY4V98NTO+I+RRmGYiwduyqoW+mBZnvUtqHeiKgS2ueAo9HCJkLy09Xg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,

On Fri, 10 Jul 2026 at 11:50, Lorenzo Stoakes <ljs@kernel.org> wrote:
>
> Kernel page table walkers fall into two broad categories - those ranges
> where no exclusion is required via walk_kernel_page_table_range_lockless()
> and those where exclusion is required via walk_kernel_page_table_range()
> or walk_page_range_debug().
>
> The former category is used only by arm64 arch code operating on ranges it
> both wholly owns and does not concurrently write.
>
> The latter category consists of kernel page table walkers operating on
> ranges that are wholly owned (but which need exclusion against concurrent
> writers).
>
> The lock used for exclusion is the mmap lock, and for kernel ranges this
> the mmap lock on init_mm.
>
> ptdump is a special case being both the only user of
> walk_page_range_debug(), and the only case in which it walks ranges it does
> not own.
>
> This presents a problem, as page tables may be freed under ptdump. And
> indeed there is a use-after-free bug in the kernel as a result, which this
> series addresses.
>
> vmap promotes page tables to huge leaf entries where possible, freeing the
> lower leaf page table when it does. It does this with no meaningful locks
> held against concurrent ptdump walks.
>
> As a result, use-after-free can currently occur. This series addresses the
> issue by having the vmap huge promotion logic acquire the mmap read lock
> while both setting the huge page table entry and freeing the prior leaf
> page table.
>
> The ptdump code already acquires the mmap write lock, so by doing so we
> ensure that the ptdump walker only ever observes either the huge page table
> entry or the existing page table entry, and nothing is freed underneath it.
>
> A mitigation for this issue was already applied for arm64 in commit
> a93b45fd397 ("arm64: Enable vmalloc-huge with ptdump"), which this series

seems it should be fa93b45fd397.

Cheers.
> has to deal with carefully.
>
> This mitigation resolves the issue by acquiring the mmap read lock on
> init_mm on vmap page table free if a ptdump is in progress.
>
> However the fix in this series would cause a deadlock if we were to simply
> apply it for arm64 without also reverting the change.
>
> This is because vmap may acquire the read lock before ptdump attempts to
> acquire the write lock, which then gets queued, and rwsem starvation rules
> mean that the (unacknowledged) nested mmap read lock in the arm64 code
> would also block, meaning the original read lock is never released and thus
> deadlock.
>
> This series works around this by #ifndef CONFIG_ARM64'ing the mmap read
> lock in vmap logic, then partially reverting commit
> a93b45fd397 ("arm64: Enable vmalloc-huge with ptdump"), keeping the
> enablement of huge vmap support, and removing the ifdeffery with the
> partial revert patch.
>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---
> Lorenzo Stoakes (2):
>       mm/vmalloc: acquire init_mm read lock on huge vmap promotion
>       Revert "arm64: Enable vmalloc-huge with ptdump"
>
>  arch/arm64/include/asm/ptdump.h |  2 --
>  arch/arm64/mm/mmu.c             | 43 ++++-------------------------------------
>  arch/arm64/mm/ptdump.c          | 11 ++---------
>  include/linux/mmap_lock.h       |  1 +
>  mm/pagewalk.c                   | 22 +++++++++++----------
>  mm/vmalloc.c                    | 41 ++++++++++++++++++++++++++++++---------
>  6 files changed, 51 insertions(+), 69 deletions(-)
> ---
> base-commit: a635d6748234582ea287c5ffeae28b9b23f91c7e
> change-id: 20260710-series-vmap-race-fix-2a4cac988938
>
> Cheers,
> --
> Lorenzo Stoakes <ljs@kernel.org>
>

