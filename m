Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80902CD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 17:07:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D97DC6B0088; Fri,  5 Jun 2026 13:07:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D47C76B008C; Fri,  5 Jun 2026 13:07:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C10AF6B0092; Fri,  5 Jun 2026 13:07:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B60DB6B0088
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:07:48 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 59EBBA0248
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:07:48 +0000 (UTC)
X-FDA: 84846491016.10.DEA770B
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7DDB880017
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:07:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=He5LnSLG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.51 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780679266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wfdqaOn+smG9hY8rD85LL22KMJy+2AytX3mGNk8Tobs=;
	b=I/SIQKGyyi4oSDhYpXGlmBK/nwKukv2QvvABuEBF5XY8KiQS+/awZWeZtuLG2IeL/RE0+T
	EYxWKMDoQLXaf9vTf9hNBtEnJumjNkqHXJoVv2y/EkZzaRHwLfbCtOw+bTAdzrBMgfxwSU
	sq/lA+txNtDVs8T1w577La12laQIWQw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=He5LnSLG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.51 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780679266;
	b=A78tntRJbkXFOlXKdKtwuzLlb7X7JzCfQvUMPWpIptK35aGpDq0UIkg8od7ZSI2leQsoe5
	M5WP4VsbCC2s/wKN3WBAmN0C/b0HjAMpQIQftU+XUtOD5D+AR9FsGOhQ5hUMTcRhDQHdiI
	ord55dhUWr3WNKgKbKVF1Yoqs25JZrU=
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7e6ec655c80so1200624a34.0
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 10:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780679265; x=1781284065; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wfdqaOn+smG9hY8rD85LL22KMJy+2AytX3mGNk8Tobs=;
        b=He5LnSLG9uvnmG+Z6xREdai/3BPjD7vVQCBK2vRkU7nKXEbi5qufpexiBYudnRhZ8p
         yWJgjLHEKGL3qRvZs4EmByPa0EDhXppOh6wqLD7nhhcbB8De7yd2nLig0K7LbDSel5OH
         AkLkuSAmPMGrAo02zTMG16qSCWV/3t5tD6fhQ3j5ZNg7XxmfhVqrAopAAIvCqd5cFI+f
         qEMkXMZOWwB1i1UT8Uxch2inz1EZeIMGT3RSUamMPFCILRbf3ANAD5xbXcXt9Yg1F4nb
         8HB2GecyMK1FjdkI5YHjzI+2v9oYTEb4pb9NpsOJoih9U0OpULHSWihJQXga8vd0ffuU
         otgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780679265; x=1781284065;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wfdqaOn+smG9hY8rD85LL22KMJy+2AytX3mGNk8Tobs=;
        b=irmuteODkBzQl2qvrY8BiMow/Cv14ZOqWjfYbfC9EssfqLt1y+zfKK0s98Ef+5XgLi
         rePWnGItua1Naznd9V/4WokKBvrYAFIr8Fz98xJ/gLVOOcEoiJUM5IG8559hHbmRRNP+
         /5MUNzxBbDeDo4iAw02oX75PDI9EauM5BkMTbayujfJbgYgYsE6HqTPiA9Gr7oa0Z7SS
         vx7ToapPMhtKlQ0zbmXf2Xzvxxg9qgJoVKE9oIn51TXI4IA/wxmaH9da98vEOKFq2wXB
         5kTBsD0GWwsCb/vTWDJy5v4ReGlBI1i5iglX1T7DyPmpceNAOipqYxMhQVamCQhPVnya
         EnCw==
X-Forwarded-Encrypted: i=1; AFNElJ81VVCorwmhtxCMI3nhPCneLHyTIbvTjv/MMx9QtrKYdznrA0Allcdp69azSUWst9M4wjnO/qUUXQ==@kvack.org
X-Gm-Message-State: AOJu0YyjmW/EDabyj/pBGAR12O4ordAgA9q99JUmH5p6JHFyJiSYqne/
	9PTY0FmB/K8CkdGmnf9xp3EDcwcibLRsIYQFPpcS1MNfB6cTelpNuzcn0UNRtA==
X-Gm-Gg: Acq92OElUCgADtcr8oL4as54iRdUxb8yHNGYV40pXJkV9gJmfTrtV/ekTSZa3/0yyCE
	xnac203PaViT+qPtTcZlsrAycRBB1ChALAZJTRLEgKxs4v5ZeItInaf2qx3VEHGS1IKbQyndhSX
	K+zdXbB9Kf7F61TDKskNu0RZQManXn7QPWoekHlArO1846ZiwugsMqcUYwVwqahV9dbjQWc5wj8
	oGiyFBZIdpKMrOyIbVrKiEs6yPRBH98wK5Jy78cfKbik+siKPAC89SqnESItwwTrVC1ocEKF0h4
	SarCzBjq4oGCts5bLV3xsHHygtnkSlWHBdtssZUzv6jrmh/bsH22SvYtskNLiFc3VFvNaC4qCOd
	EhSpwnZGs7nWrOx4yujKghyJ9b8Msh+98C2jEy2eil9DHmPdqtK1OPlTr7ibi9qnWq8GYKgJdXk
	NK6llRokUSVjJGCGGJPzU6f6R/w0warBpIRQYOsvGZXL0EiEWns8X7WWtNEGZ1OvwV
X-Received: by 2002:a05:6820:4dcc:b0:69d:7a88:9ccb with SMTP id 006d021491bc7-69e68b94fe5mr2444413eaf.24.1780679265289;
        Fri, 05 Jun 2026 10:07:45 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:53::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-440d7c42c33sm7420128fac.6.2026.06.05.10.07.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 10:07:44 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 0/6 v3] mm/memcontrol, page_counter: move stock from mem_cgroup to page_counter
Date: Fri,  5 Jun 2026 10:07:42 -0700
Message-ID: <20260605170743.1292597-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260605153603.234296-1-joshua.hahnjy@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ymsffa41my5f7ttzs7t68geteimzs48y
X-Rspamd-Queue-Id: 7DDB880017
X-HE-Tag: 1780679266-65777
X-HE-Meta: U2FsdGVkX1+gsgU5Tud+8SiwtVtzS7tMApbfD8Dd2Rln+tzfa5wdEJ+5v1j8EeAqH+PAo1qi6aXGxs3PIvfdXbzjAj56FqJ9ZEUsNcnuHaagdQxdOAPZurVScfONpIaMgA98Zh6fxPQ2IYcnQe9PRbvHLNU2nJXUv7IctrrOgi0bnNOKD7R3f7Qwixsy0O/cTLykH2D6+ihgIrIl/gVfrB0Qsspfk/Ky59RS0C6cuRPKc1jyahl2aj/WqKei7WTXcyG0kNPEjmXGI5h1j+eMAZrH+xJG5LIoWwCgKErFdkdtCjJ4JMy2NoDdLt6atQZ14X5xPZ8vigQUNj6vyVRPjUKOJspHEhzMNq5h4pNCaqQrQQWWvpPgUOM3dmeDha05cMBR3woB7E8jCAsSNPY1T1DFdk1whN7zHv9VfX8RvH0Pem1J6As7YrKlZyDr/3+y2lTTOVS8dwmzjhyceL2dWKoRGhAmPsw+ph/R7IDi+Eg/AdX+/0hohk9APFvT7LiwPGBFjecH9cvv0KM7MtwtbWp05WMXMDErhwcQ4ShUek0n8tVGuUwipA2kUxvUADJuPiGy/oxwKhfmypCcScd8pkeQzQqlIpQbJ2F04NhkIj1TRcnjZhb2c0DBS3/iwgd/JAs/ByW5yLhe0ZumPCBPonlf5xdGLD54JkZbEWmz1eZD61r9EC6jbJw5mjYy/1fLC8vQGGBRngQwTSR7GH+/sqvtx9MoIWPMYoN/eX3D4UQ1V8tUB1HsB6fOIvGigOPNLEidnSXm7eA5v8XlECw/FSqLkoVRXDwfF1xWvS0W/QUt0I/Pf3S8cXnRgtM5poRYGscZ2OeR3Ld/DixfYwyNsSB4eXRFim3KEJfhfcf4zCpAHAI1PbqRZIGWTiDPt2cE83XG8viyFDOoWCE6lqC9E0KgvNbtUMBOlkB7/08SRd3kBX8xItkOyVKc7OlDlnIfdnuJk5bDh6ZNGzbGce4
 M9az4Jrx
 m4WMl2Ddbbd6/I+MB4iBcwEIacvKrpXiv1wdJNg1aJuhgfW2h3LjC9S6eyh69GDQFS0r/TtoLHn4hOtaUHt4QDqw+NNRsI+k8eJucLcg2Te2Ogihbrggt36w+ZrJTIcNhC+xyYH1Ej1nDKJMHK7/E72nQC5S4PFiJSa2kPuHlN/TIMsUWd4LHBfhjyr8KuL6IIfaN0QkCQuUfW2kWXxxawMxBzcBF2IGjczj4r+wvcvfhyCvAyaepA4N9gR8U5v/5IGkBi4MVUYEI4XmpEIUX6Kfu2vGTQ/tlkRiDorpwRlrN83KAu0buMaOwRhcnSRHW9OlWvuzulM9S2EoQ1D1e1OLE7C+6lQ9WnovF1EcMezJEUKXHd0Srv//3Xk6J5Ef7X5nGhjvgYBeaHJgKg6tR9ceR5QwDSBoaHh5JPCiy0sTeDc3g8SAV5DNnY+viveOEYKOCBrxigK3A1tO3DiQd/qLboITlqYtxg0p7RQuStgJt+tsFO78JDWqptHYjmyZK2dyMJjRvk5sl7n9Mo9XH/P+v0SCEtulyQe2R9d74sM2nx09SnenRN/DMF0GhFdm30bor6k+27Jk2PSwM67pdn5ZYDsVqHPGxEIImnQ8aFTspnyfo0MxR3zKFiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  5 Jun 2026 08:35:56 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> Memcg currently keeps a "stock" of 64 pages per-cpu to cache pre-charged
> allocations, allowing small allocations to avoid walking the expensive
> mem_cgroup hierarchy traversal and atomic operations on each charge.
> This design introduces a fastpath, but there is room for improvement:
> 
> 1. Currently, each CPU tracks up to 7 (NR_MEMCG_STOCK) mem_cgroups. When
>    more than 7 mem_cgroups are actively charging on a single CPU, a
>    random victim is evicted and its associated stock is drained.
> 
> 2. Stock management is tightly coupled to struct mem_cgroup, which makes
>    it difficult to add a new page_counter to mem_cgroup and have
>    multiple sources of stock management, which is required when trying
>    to introduce fastpaths to multiple hard limit checks.
> 
> This series moves the per-cpu stock down into the page_counter which
> consolidates stock limit checking and page_counter limit checking into
> page_counter_try_charge. This eliminates the 7-memcg-per-cpu slot limit,
> the random evictions (drain & refill), and slot traversal.

Hello reviewers,

I was hoping to receive some input on a point that Sashiko raises.
The draining work we do per-cpu uses work_on_cpu(), which does
schedule_work_on() and flush_work() on the system_percpu_wq, which is
not WQ_MEM_RECLAIM. And drain_all_stock() runs from try_charge_memcg()
on the reclaim path, so it actually triggers the check_flush_dependency()
since a wq_mem_reclaim is flushing a !wq_mem_reclaim.

In my testing, I haven't seen this become an issue. The flushing work
and draining only takes a local_lock() and does atomic operations,
and it never allocates, so there is no question on whether we can make
forward progress.

But this does slip up the WARN_ON since this is not obvious to the system.
I see three options here:

1. Trust that this is OK, and document that we can alwyas make forward
   progress.
2. Keep the draining work synchronous, but queue and flush on memcg_wq
   marked WQ_MEM_RECLAIM instead of just using work_on_cpu(). This would
   add 2 words per-cpu-memcg for the work struct backpointer.
3. Go back to asynchronous, which would get rid of all the synchronous
   concerns, but add an additional 2 words per-cpu-memcg for the work
   struct backpointer here as well.

What do you think is the right decision here? I was thinking about this
quite a bit recently but just decided to send it out, but I think I should
have asked for upstream opinion sooner...

I would prefer to keep the memory footprint of this series minimal, and
opting to do things synchronously helped achieve this goal since we can
get rid of the backpointers. But I think this is beginning to show up as
a tradeoff, so I would really appreciate any input on what seems to be
the best decision here.

Thank you very much for your time!
Joshua

