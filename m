Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE4E960A6F5E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 14:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P9ajy5V8
Received: by kanga.kvack.org (Postfix)
	id C13D76B05B0; Mon, 23 Nov 2026 09:53:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC50E6B05B3; Mon, 23 Nov 2026 09:53:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD9616B05B4; Mon, 23 Nov 2026 09:53:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8CBEF6B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:53:56 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 985D01C3D5C
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:53:54 +0000 (UTC)
X-FDA: 85466678388.13.5A65258
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0496C18000A
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:53:52 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P9ajy5V8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795445633;
	b=Dle9fOenBzyOiWOUywqT9o9X76A1hW5h8a7Bc2vRMCUDMrmmtQj+4KZLi6bzqC1id/nvkM
	SYTttcUeEdLj2PFnQD3FMIebpl+xJpJfLlRQNpNklN6WNssxiv6ICCf4rC/GczOYTel6gI
	yHys58nDTTD/XCIsk+zEx2MxPV4Xsbs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795445633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XOgaYnpSDCV8c4FBL+2M/FIYjDvQARUxjvg7P2w/uio=;
	b=aI871a14pAVFT452mWCv29g2jn8pmQp9rEJqDdyKrLoauFBybEmPy2dbPDB8JYCkG/5Jui
	sisCbw3YgcoX1KSn5ai0AkshARoi3RQ17xCRtrJmvHlkHfm8uIgDSXlugrXpNX07NvhaFw
	g7JcVgXqCN9vl0WZ6OXOwT5dVk9hoZU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P9ajy5V8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2DCD545986;
	Mon, 23 Nov 2026 14:53:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 930C01F00AD4;
	Mon, 23 Nov 2026 14:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795445632;
	bh=XOgaYnpSDCV8c4FBL+2M/FIYjDvQARUxjvg7P2w/uio=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=P9ajy5V8xj1bYJOOCY4ozKOGfNE4jQ+9h7s6ubC62eLgBZ9o9p9s/n6iPFeKSMD8I
	 ZoChcmgGPzdbfcDkVqrdoO5oMWzGIWBMeGBiULkTRh2jlx7oxwBzZlu9YoBgoBetVN
	 phKHl+GeDMZHNODGnape4QtIXV53U+URUeAjVsahlv80IeLVkZ/G8AEvadGnzvZc0R
	 Wupnt74DMLYJhzVcgkW5mdH30whTZFriDo1jSeUBe56A04GnWW4NlgZYuuiR0qdOCk
	 iGfDly6kVUgOpGmaDLwYRT07NpjRX4YewRcR5xcMpH8Tq7buMLKS+BLu+vXscUN6an
	 5b5FZFV89I/4A==
Date: Mon, 23 Nov 2026 14:53:50 +0000
From: Harry Yoo <harry@kernel.org>
To: vbabka@kernel.org, akpm@linux-foundation.org, 
	Hao Li <hao.li@linux.dev>
Cc: kernel-team@meta.com, cl@gentwo.org, rientjes@google.com, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	surenb@google.com
Subject: Re: [PATCH] mm/slab: don't set SLAB_MAY_ACCOUNT for
 KMALLOC_PARTITION_CACHES
Message-ID: <awRTBHzBQtxDHTzT@thinkstation>
References: <20261111125628.375624-1-hao.li@linux.dev>
 <179544526759.3606123.1000047458494853310.b4-ty@b4>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179544526759.3606123.1000047458494853310.b4-ty@b4>
X-Stat-Signature: 78ku8mhfckkwy83w7zj1k6d1f5yxc86x
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0496C18000A
X-HE-Tag: 1795445632-310787
X-HE-Meta: U2FsdGVkX1/56+oyB6LYh3v/zI/OHoFaAeSmLxmS3gD06gJWwXDpGcYp9HxbsnDKLVp5OZLe+yQKpwn0CttKLuoZDkn1AcTQz1hOdKykQ9Pg/msqMNXP6Dc0B0TPo1cWGQiluSbnkwQxRl4MSK5wT8De9/69HPaoiUEmHHP8LZp3ocum+hSE52vHle3FKwNZRCiIJejFE17ITjw5irSY++T/9T8x1BXSM9UaQqSvHHjP7rYoS9bnUFZvq1nw76x1DqREuChJ3G6z1Z+h+3c1kfMAAceHiEzgCsIM1njhj85LmGmbwLHAIgi/Az1ReL7bRcGM2IUbsU0cAwxn9oVcfUI9Xkd652O8aEJTdnJuQNt+WnY8nxKoP7cEHWhgfn0aKv/Gqqs11zdGAkPLW5Zq3ZGsFH8dSHeOe+vC+LaO5dmRaTkquzoFu/FM+vffXASD1eRcEWDKUIhJTMobhwTqji+j2RVuSlY3FshVynTAv+8wdq2wY/yL6Il64mNYtX+nkcbykQdmcIiKmMJ5YyLyL2o3hmWq0rno+bLhY+wDY78ELcre7WGeGA6Z1qNWRhIyIB2IdpwtmaQHo0upj3xaKV+Pf1PlVbjbepx0+NANfZZNRLqivZ7epsrrVOGjYGfp9cb7a9Y2LA1SofI31/ddpTD2aJ4VZ1U3mBLcm9LwVopzfBH1BpVHSMlXNV7TAvAwrKrji2xgOzT9vhAfJsAZpMUIy9T2G9rOb8x+WhB0kMaL4oh7r87+WBICIZt7midkqT/fpAOzaygG14QR4JaTKPcY/0w2wjMI0CXZbtuvN//L5v8Gb2j9FCCXMpCX3p8ABjr98DiMPJo0XXSnNFId3/PckUNe0RpPdzuckql9hNGAynA8Tzgsv38e+fBPacnxLUVbyttyo68XY6DFeB+AO9/tPUlDBfXWNoI2Fwt356+AxDRLcGsVsteyiyZsZIYtqg7X/5j6SLAMhxsCbUX
 GqoEBWK4
 sMsAkZsAR58fNxlNhjgtwF9S7UNSrSINMfgeR64o54zZppPVjPuX17p37hcaT8+nh14iKVhw66jcS+yqxLYjeEHwKjVpsKfH5HmDKU88EXlJqiO+EU6CUgR/O7UIUfCnXXN6K+SRag8P5/krxK73dBwFLcGzpnYM35vzS23UvGQEULtYR8MtCFdJIU38jwNeWCPluzlS0D9TZUw+aGxsncvReBmga+ilfAB69QRs3FbgXbiL6gN625a0yTkNbBcrHuS0xVZJMVMrjf92SY/OxDhPgp6itY5XYI2OwcuZzfpB7C6FW7JE47h0mTV1kpRXFJQKP2wMVBk8ne/4070yguOcRmZWE4psqcd0WBgDbnY+XiYwdibdwQFF2QdHtziSQzLIOpAjhyWwrntb9gWhGXsazq3v1LmCGWsBtWrVMTmx7PZHAcpAeBc0j8FOTP4KoOQSeZERKQezAeU//Vi3fi5g+TLUk3aksGESigFPXkzeogUi2LLlRJWgvJAj++FlZT/Kes28Um20UuEq6Yt7c3lDYgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 02:48:19PM +0000, Harry Yoo (Meta) wrote:
> On Wed, 11 Nov 2026 20:49:10 +0800, Hao Li wrote:
> > An allocation with __GFP_ACCOUNT set (without __GFP_DMA or
> > __GFP_RECLAIMABLE) is redirected to KMALLOC_CGROUP and will never hit
> > KMALLOC_NORMAL or KMALLOC_PARTITION_CACHES. Consequently, neither of
> > these caches requires objcg slots in obj_exts.
> > 
> > While KMALLOC_NORMAL already skips setting SLAB_MAY_ACCOUNT,
> > KMALLOC_PARTITION_CACHES still carries it unnecessarily.
> > 
> > [...]
> 
> Applied to mm/slab.git for-next, thanks!
> 
> [1/1] mm/slab: don't set SLAB_MAY_ACCOUNT for KMALLOC_PARTITION_CACHES
>       commit: ec81fa8f7dbcf89d9b4112544f76f47c8eb5c725

Just for the record I added Fixes: tag per Vlastimil's suggestion
but didn't add Cc: stable (dunno if Android would need it (due to random
kmalloc caches), but it can be backported later if needed).

-- 
Cheers,
Harry / Hyeonggon

