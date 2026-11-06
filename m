Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 086A7606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 16:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=B6MvUc13
Received: by kanga.kvack.org (Postfix)
	id E30886B05B1; Fri,  6 Nov 2026 11:26:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0E106B05B2; Fri,  6 Nov 2026 11:26:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD0D16B05B3; Fri,  6 Nov 2026 11:26:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 931DB6B05B1
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 11:26:19 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 75CAFA0127
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 16:26:18 +0000 (UTC)
X-FDA: 85405221636.26.B9AFCB3
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7E89140003
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 16:26:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=B6MvUc13;
	spf=pass (imf11.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.208.172 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793982376;
	b=J819V2IwxKfmeQVFZlmm2QXlqhOYuzlJERrtGiFzLhxyXpDUtS+xvwpC5HqO7g6cibCYtY
	WnVSJOjTCXOb0RdGdJ/RWMaXNegXFxNihFG4vh0f0VC/mcl9WZ+/yCmT4D3sQsoiPE5f38
	51/ot7m/e03lTWxvdAxdUCrSOKaqAH4=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=B6MvUc13;
	spf=pass (imf11.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.208.172 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793982376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HdRV2fv9sn3Zv1QD3CF2qLLoDxMKfmhR4N5vPY7tcE4=;
	b=bJgWcXVWqcA95yXdYrMHe9j1h3uIYwsBQSZglqdT/O8O34bD7ItjA6nUGrSIo5Hk1K80LG
	TqytbpCsqSmfN9xdKOJ2jh+zQQoWpRNwbKKYm5nFnxpO2VRPahy1fVDpv15f21MptpY+wO
	VnalHtiA8Q7sEEmedSGsN+i0rlXxEN4=
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-3ab4891fc73so5973501fa.0
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 08:26:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793982375; cv=none;
        d=google.com; s=arc-20260327;
        b=OW4JbQ3nejM9xRVxePYI8taLkeSExtqKD0dLrIUKRZWGf5fF4y+IRCU2XwE+Kv0knS
         jkEQ1pEyIbWhK67EPmkYzqzPe4YsFXOm0mPT4k5pTmmI1HWHknDMLdcBhfcQE6uqyIZf
         3Z+5C+KsX0PwLhQJqGlTuVWLY0j/L/vmwPepcy5yocuVGn9pHroXr2UwYn7X9bXu6MAf
         QsQyZK7y+KTH+UnhaJPLCwGfXkb+XL9c1qf+voKdhT7hbtCyQkYCir4NQtzbNEnCVAWl
         hptajYvozaN8UdppUWGqPdYInqiAj6z6kvBjfbp21Dx6LoQ9XjMoFvIFQjYOMwaz/5PX
         vRpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HdRV2fv9sn3Zv1QD3CF2qLLoDxMKfmhR4N5vPY7tcE4=;
        fh=7fr8Pac2sm2EJVrmLnGmNl/vxCQH+rN7wwQ/XKOsYgw=;
        b=cTEAJ+rHHH3AZLJjeSgblbcDFv1bnoSRDyxv+m4qgUREtJFNf5AX4IcVMUSg44+2tU
         YsH7R23UcahiX1jRGLx1keWCLLgXBWdPUi/j4T58kbJJG9L1MKsGzB7VH6DaX9CVmi1c
         HRTlzJWMfSBnqHNQpfZauuY5uEixNrJjTdWnVtQbSq5zox6N0/lJtU1LvIOZc1QHf187
         n63zio6OtOHkcD7J651OZDxiip4JI1GgMv+PS6LCA7SYL8/IvYHTUrNp6RFT8ZSD/Ohk
         TnKdYmvGcpu7fRH549PmLkSCZj00Le4i/n9PDLw7xI1uEFhqLc/h6OTa7qMrK95u9YFZ
         YiyQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793982375; x=1794587175; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HdRV2fv9sn3Zv1QD3CF2qLLoDxMKfmhR4N5vPY7tcE4=;
        b=B6MvUc138LqK9/sUss1pxHGUKHdjnP/x7vYVdLDY60xt7p1jyZoIIooIW15HMZ0bJF
         ha4OoGByNdklR2R/aDnvxiG/rE29lR3uN+IEhMdjqC5EtRG2SM2ff6NW+lfOP/Ghx1ws
         jv5lI0EBe7sGXggAGjdC7FJazzBN+z+E7uPmIeqzsWNynacMT6IRPzlyVVjYW8N8zV9Y
         In2ImVs9GlEJP7a2FeGVPANqAHAbJctPnv0iaO5p+7H/quzLt7JSlzEC+pcEt0Xv/Owx
         yZ7/loBFYNs2nrEWn+7Q5SzDO8Mp9KIwHv04cmHZS6Y332dRninT5gjhX9Dw5JA23Kfu
         29tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793982375; x=1794587175;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HdRV2fv9sn3Zv1QD3CF2qLLoDxMKfmhR4N5vPY7tcE4=;
        b=lc+XItM7GY+A1zK+zfx6u8HzyKwxFmFaMZwy7W9e7zKlsDjLrr9DWgpuR0F5VGGAoh
         hmUyMdvfaWfAOKiUo2LrfyCHDjAhwyX10aVgWjYXjFJe12AewKP0Vxr//WnVNqjClVzu
         eHwZ8o07zEw9GgRJJ21U9OPRYHVJVLbsbAErNghrd8QrrYxBdwLyb27mUn1QVqv+7WdA
         D8K2ftkMYK4sYaEFERtsjnjP1RiEcK4fQc3VuyzVFXc256gRxI4w84+oeeZxrdSW7+3k
         FE8ZdMZyNLbyjv5j/GXE0iXOeJRWfGRcGlqOakM9ilooNz6b0JWSBV4YgveWFcEpQGcZ
         rUUA==
X-Forwarded-Encrypted: i=1; AKwUvBysWNEVUpS65ntiye66/FXhq99t33fMkNElAVW6XDC5lWra4j4iVH13mKi30GXON/n8jWb+nh2miQ==@kvack.org
X-Gm-Message-State: APuU4Z8RTI3f4xaNJScUHxktXFIonxu6gABPN1FJfLvjA6ct7nMhT/ol
	ELdpFRSJkUHhn435T6x8/Hjthd7UoUoWOyk+x5Y8rfLE9kGrLz7g6ghuTA2t3hmxQ2+v11F4bN/
	BdEcgULfUcOSwemnbzCYK43/bh0aUQNY=
X-Gm-Gg: AYBFou1s8F40Y7FYYhvE2SXmphOf3e8dklPaP57dGtf3oWDeTvVU7uab571aT0HcM86
	r8r196E7LcMQjRNcoVXmGv0a6jP9fYOcf6kx0MxxQKmSBx68oA0DO1dt5BcO7Ha7ZZHpRpz+h9p
	FLoyn4ZkraXT2sZONyuqHOsJuGYObRUAqKI5GgSerwga9uOp59QZuL1UfoUEbC9qG4NyvXir1Ob
	KMqpMR6woDTJrOscQXR7aqhweD0Egq3L6s8voQA3p+GRy16hXsftjbMrzXYNcdRZggfQrP3d4zs
	J0rFZQ11gL0tn9ApdMl5A646uNGB6zdL0xlnY9eMa8FAk5jnmtb00Vqf1m+U4KjTZy+8H94DQv8
	UQDBSNUwggAlMVgVyBMeIxJ/lAJ4+u3R6kBaLLEPqQhkr8aXQNN9rH4eSQxHtyzy0/bmB9B1p7V
	xq5Qoyb51Ac8MWaKqOWI+qE2KQrLo50JZRiUMlZdxNb2lVig156aKO
X-Received: by 2002:a05:651c:1581:b0:3ab:3f1c:c2c7 with SMTP id
 38308e7fff4ca-3acf36e3c14mr5753981fa.0.1793982374444; Fri, 06 Nov 2026
 08:26:14 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261105183940.2236717-1-usama.arif@linux.dev> <20261105183940.2236717-17-usama.arif@linux.dev>
In-Reply-To: <20261105183940.2236717-17-usama.arif@linux.dev>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 6 Nov 2026 09:26:01 -0700
X-Gm-Features: AclHuK-EQG1rFsL9_37CcQp4-MiQ2_X7-vdSo7RZgU-ncnM9jHkiaTfyM8fgSFs
Message-ID: <CAKEwX=Od10cXx5Xz8td4Zsg2rsMkU+_t0UdqcQoXx6dZwfFU0Q@mail.gmail.com>
Subject: Re: [PATCH v9 16/32] mm: zswap: reject high-order swap cache
 allocations backed by zswap
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, chrisl@kernel.org, 
	kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org, 
	chenhuacai@kernel.org, ying.huang@linux.alibaba.com, 
	Baoquan He <baoquan.he@linux.dev>, willy@infradead.org, youngjun.park@lge.com, 
	hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, 
	kas@kernel.org, baohua@kernel.org, dev.jain@arm.com, 
	baolin.wang@linux.alibaba.com, Nico Pache <nico.pache@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com, 
	Vlastimil Babka <vbabka@kernel.org>, lance.yang@linux.dev, linux-kernel@vger.kernel.org, 
	shikemeng@huaweicloud.com, yosry@kernel.org, qi.zheng@linux.dev, 
	luizcap@redhat.com, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ddxc9715bjjoiifni4tzku58ece8yxuj
X-Rspamd-Queue-Id: 7E89140003
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793982376-206433
X-HE-Meta: U2FsdGVkX1/WiKhjz6LK2io+Y/XA+UPpfxykwX4dBWwr4IX6DEfOkLTvTI+F3quJ2CAx1Tidwkuggw8IJA75AFQCwhhWkz5XfJCprqzapcnnx4Un1GbPHHdCO90KXoN95f/ib77KmmaEjY5A2SnE8J0KqaUUXOHogacrYYJLnemvMW+9qKS6SOXUK2FyKWr9oG8siUWmwfjeY4KHqnvmIoe1fh1Rw09oIRwzLf4NmTq+rJl3DbL3mlOWrXKXIPMNctuvdo+SZEBgt/uxqXDuMcGRCfX5ZIL0aME+5RFU2agE0ABjKDKyFvEvNupG5FQIZVis3OSEAs4aYBQDmgJm9DJl7TqiA7npLSdV4DcOivqOKNDQvi7zeYoV8xFupCiOwBl8zNnCni5aL0YtRm7bP9f6TQBI1N7hxY8BIc5ZsnI5mGRBvpFIEwWc1UGcvPiyZ8O44R9+7OXyC5hZJ0gq39E1A9kQschw+Mhx4yulsva9g5DTpvzsMVhCl1Ng6Fh2FyUDhn9DvpVZRXGmB2XtQsVCDz2JIFh3Dca5agqUnOfgyC4PEYrRFEGSlSW7KQS6IrzxDNRdNJkcKPkU4eKoHl3+HaBuwZ4aGJmapGr1NMNzTrh9nOn3/zJZW+YJmt9eKzdtRwPQh/jbwNxfZ/xek73KeL/68I7jxdp7ymBC/7xtLHij844HYfYGmRsHsZKEV6bzZprB51lqrq4tjgHTJ3/lUqlpPHDOK3ba1x7jtym0LRxolVVRbiXMQu1hutwiwNwXZ89tlVYVe9XgenHeONTE02/0XV/HSAifjS/9IhjL7egsXnD/jKNqm4eJaIZrrpRLcTPYdBBGHR1ig4/Hdy/+ivvcNcAzg5LQIna4VAVUaZ84bvvQq+02abP/L+sd0hdsmGipx4w9vSqeggfOG0hEhMhSujMcvLhvSzXEjSFaBlj/9jpM8zdoQHeu4oEqlj6KQXxH5KGAHLvt7rj
 DGVTBBCA
 B5wv+YfV05c7yoCoY0YMhyVHXJbASaP7l+wsqChBMGKcIch4rAMpDmhsCJR08RTaGZvtUI5ZTQ7+4E0LOPY2tSf4kQ+/aYx1IEJ97x39iB0uatbZpETNYABUxiVDvzOn0tcXgq+Tt9tNwE3iPHUR4Zo3UCsPUEeidseEEd8CA++63z+QjX2Kumb9adrIheYHgfiUjtms0IbDoysmzEPvJbaLZyxYPiE49W0AM+SuoxdpuzgSC0wi3HLrIYbAcvEMtzGK/agft1dBu5ztQlh2f9mWuWqykcZGJ9GZEeLnAO2C1POcmNzvZx5AEDCuC/KAG4932xtGgl5Kqom6xqA/OVYCwBrin3va/iFWjXHFLCamPK171yHu2cideCJVRUjy8m61Uo4wfBvHnmdfSx0pMfUYCcHrmqui7wnSytfnaamdUGrpD8ilRi6Lk+ktL1Lwe5w8nBtcLT/K+oXl97m2Y+FYhGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 5, 2026 at 11:41=E2=80=AFAM Usama Arif <usama.arif@linux.dev> w=
rote:
>
> zswap stores swapped-out pages one at a time, so a range of swap slots ca=
n
> be split between zswap entries and the backing device. A high-order
> swap-cache folio over such a range cannot be read back in one go: the dis=
k
> read would return stale or zero data for every slot zswap owns.
>
> Reject that in __swap_cache_alloc(). Do the check after the folio is in t=
he
> swap cache: from that point zswap can neither start storing nor start
> writing back any slot in the range, so the answer is stable. Callers
> already fall back to order-0, which zswap_load() handles per page.
>
> Co-developed-by: Alexandre Ghiti <alex@ghiti.fr>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

