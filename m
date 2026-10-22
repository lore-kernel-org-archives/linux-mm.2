Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F139606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 16:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=CFqeP8ej
Received: by kanga.kvack.org (Postfix)
	id B162C6B02E3; Thu, 22 Oct 2026 12:32:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABEE76B02E4; Thu, 22 Oct 2026 12:32:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AE0C6B02E5; Thu, 22 Oct 2026 12:32:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 779EF6B02E3
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 12:32:36 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EF9FC160197
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 16:32:35 +0000 (UTC)
X-FDA: 85350805470.03.950F38C
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1A75C180003
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 16:32:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=CFqeP8ej;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf24.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792686754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O+E03NrkWyAgYx/OnIv1Bo6JdTIFdK42G1CbBxjO+jc=;
	b=NArIT0B8/qOY8ky92B38gKfkS09UXo3V0RtuV2apc22bCUw463NOJEsqJOcs1KrCj/t5Vf
	usfJojM/ljYH4d89O8E+4fl8FGtfU7tjVFij1CIOiE95K3YRIfHRpENbUqH3yVUineVkWx
	fhjuPMi14HcElj2Hs8z1EMdboGh5JiA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=CFqeP8ej;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf24.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792686754;
	b=y201Q6CY1t21BEFmPWPLGmD+i2Jfm3ScTMBE8k4JScobi3ebMp8EEXn3EVW/AlyuW2m+4Y
	vVFvoV7waGiSS/K1RbqVDkbk/ugW8jbJBk+/aYxt+K3A6qABstT8ulF+1Jow62SagHKp48
	OekYhM5pumMIXuyqkh3X8zsXKoUKoek=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=O+E03NrkWyAgYx/OnIv1Bo6JdTIFdK42G1CbBxjO+jc=; b=CFqeP8ejq/ch5RAZMGMFhf2vvi
	j7JcjPQ10biIlynhtR6++MCr0kLdhl4bT5RLJV1dUPOu7vH3V3K2aCCk/9R7R8zqDeksgzvYqcGdy
	ljPNXS3YpBmx+hbojquHp6eAsQBFOFfLxUodOB3XC2VIlFEUcO3blNZXkPsyqlsBTgbU24+U4XZgn
	v3IK6jIyKgcNfuHSGFk67VkdYLXOmeV/JP4Yj2jPKaO3XVPCFGTLItKW8QEbsM0UEleARiiHpby+g
	Svxfmf7+Ny8VR1E1N3L+wLMKhaiILB9kmCnCYCPMZDk0PgqD0KyK/Z278FxBankkujXc0hXyKeGvS
	PRKROQow==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xJviO-0000000EUsO-3sxh;
	Thu, 22 Oct 2026 16:32:29 +0000
Date: Thu, 22 Oct 2026 12:32:27 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: Florian Schmaus <florian.schmaus@codasip.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Alice Ryhl <aliceryhl@google.com>, Andrew Ballance <andrewjballance@gmail.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Suren Baghdasaryan <surenb@google.com>, 
	linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/3] maple_tree: fix two bugs when freeing RCU-mode trees
Message-ID: <dtet2zelrbzt36i3jbwgsi5iv3nnwtlhtnhbgdvj3m3kzewcvs@vdgjqdivisf7>
References: <20261015-maple-tree-fix-slab-corruption-v1-0-160d97f7304c@codasip.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015-maple-tree-fix-slab-corruption-v1-0-160d97f7304c@codasip.com>
X-Rspamd-Queue-Id: 1A75C180003
X-Stat-Signature: u11pbqy65sfs1iexzki11sg7kwfx1kqh
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792686752-927745
X-HE-Meta: U2FsdGVkX1+MxqZ1xyp+Uc2XR9CDDpVKtrK6QMu2T/3WcEMTqEhmyDFYbZtkAjzhWUz4X0pPuxvML19gyAAEfD9mLTNoeC1we9FTgI0hP86YVpDpzV1V6uuLxX+RirRq7vU+5zL9WXjsrrQUlGpG6arUkBrKVUY9+GUDPeo7BaXz4iHV4OGLkdaxJwZqhblB0YWhLVY4wOyxfxc7/gUXek59ZDeNVLM6RU5L5YDrjZ1nNHcoUTjQls7KEB6inuhhg4a9DnoaLya9hqj3wgD5i8kzOEAlejloI4DeVuJIg1PTRKft0yEsVrbmeTIVxL9bMcWbMSah0srcB8bFpaIo9Py3UMyD8/blEm3eprGkCyRGC7nAu6Q6DjJ1TBQ7UoPhH6vIPHgS2MiDlpbfko2CN84ZxZtCIVIMl6doXLynsdCzfJYvNmav32/FVYkEJgI5WNDar37tuNPr362fgYcVgO/PQDP8FPSeXfTcenLjHosUzpvIoBH9CalUqhp1/cMgwbGYx8Muxjb8eA7ELrCVaYeyFk4ivatIw0h3l4SVXW28CkYa72k0C7poAm2oQUUppX+NrcBnpUNBUsgv4K0vAWG/hDoeSt5gj8gNXagFzlMtMIY359Oe2TK6DZ5eJJJzVaYBb3e8jh3oQTjNbraEk+9t3we86rPltejxvF5muOV0oolAxP4nsOUGJnkxDWvZCYRtYv7R58C5eUxPk1iVhipZ7it8XBszoIsII77Hn9YxLx/4aNeNrqvmpu+Kt0kd7La6UUhQBNNKo/pTnvwoHqxgf6G5EW19EuyBpTC019H84S+urKeiYW0H0QB1f3zG0foNH8TlV8j36hfiJDlAUoUHiQX9JvnETnf1Vo+JLPqhvLGKyJhK9uMijcjInsPT/PfaCO8V2G+Xzrvf+URbG18uT/rUv2KFMNFNqBqkfC45jK7qKsUNQL1AA9yA3VKYYXd08Phsz+MnJ854Xi7
 PF7hhEfy
 t7dPJ5OulXVVJjDUIf4I+2Bg382dN36cqDs19jFegPCUgEV1Y/8kOL54WUatLFR29htMvsJX5BP6Fpn8qlpAL/w3ijev71dlR5R1fg4ms91FZ+TGZzVFqxyHrlkHEM9hpuZQPJdLEQT7Me/wukyzlPOVMwL7UYI0vy8wAazfmrMffslEIjND6Oj1i2yOGTXqHBP/0qzZ438ne/B58zRctzSYS1Z7ggYm1xrEXF2x/SikdFGkoeH8t+VgvbK1UKyuS1mHclxVEHK56HrL1zE927DijLwdVnhDHNxhMW5YOJOnDA1y45an2iJf7bIpAPA8vMNvX0Q3aB+yM5HkD79lB7RvUjmscDkm07LVEjtD0KFw1gb4+TjKeuMZVYEm3Ow3389WtSuSsZauYrjJHQ51ZLLuQKd01GBLwgQxIs4lHJnu1kB8tNkBoIyhgGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 26/10/15 05:11PM, Florian Schmaus wrote:
> Destroying a non-allocation maple tree with MT_FLAGS_USE_RCU defers freeing
> its nodes to mt_free_walk(). There are two independent bugs on that path,
> both caused by the metadata that a maple_range_64 node may keep in its last
> slot:
> 
>  1. mt_free_walk() takes the metadata of a node with 15 children for a
>     child node and dereferences it.
>     Reproduced with: 2768 ranges / height 4
> 
>  2. mt_destroy_walk() takes the last child of a full node for metadata
>     and corrupts its pointer, so mt_free_walk() frees a bogus address.
>     Reproduced with: 120 ranges / a full root
> 
> Patch 3 adds a regression test for both cases to lib/test_maple_tree.c.
> 
> Testing: on x86_64, in the userspace test harness
> (tools/testing/radix-tree) built with ASan and UBSan, the new test fails at
> 120 ranges without patch 2 and at 2768 ranges without patch 1. With the
> whole series, all maple tree tests pass. The full suite also passes on
> s390x (big-endian) under qemu-user.

Thanks, but did you see Dimitris' patch on the 5th for this [1]?

I believe this should also resolve your issue.

[1]. https://lore.kernel.org/all/20261005-fix-maple-tree-range64-rcu-v3-0-ebe7fb278e20@cslab.ece.ntua.gr/

Thanks,
Liam


> 
> No in-tree user is known to hit either bug, because all in-tree RCU-mode
> trees (mm_mt, sparse_irqs) are allocation trees, whose nodes keep the
> metadata in a separate field.
> 
> We identified these issues on a CHERI [1, 2] system, which provides
> fine-grained memory protection through architectural capabilities. Our
> CHERI Linux port uses plain RCU-mode maple trees for CHERI-based temporal
> safety via revocation and destroys them after every revocation sweep, which
> exercises a path that in-tree users do not reach. Unlike traditional
> MMU-based protection, under which zeroing the low bytes of a node pointer
> silently yields another "valid" address, CHERI invalidated the damaged
> pointer: the partial write cleared its capability tag. Consequently, the
> kernel trapped at the next use of that pointer, and the bounds of the
> faulting capability, exactly one maple node, pointed to a corrupted maple
> node pointer. We then reproduced both bugs without CHERI on x86 with the
> userspace test harness under ASan.
> 
> 1: https://www.cl.cam.ac.uk/research/security/ctsrd/cheri/
> 2: https://codasip.com/solutions/riscv-processor-safety-security/cheri/
> 
> Signed-off-by: Florian Schmaus <florian.schmaus@codasip.com>
> ---
> Florian Schmaus (3):
>       maple_tree: do not descend into metadata in mt_free_walk()
>       maple_tree: do not clear the metadata of a full dead node
>       maple_tree: add a test for destroying RCU-mode trees
> 
>  lib/maple_tree.c      | 19 +++++++++++++++----
>  lib/test_maple_tree.c | 32 ++++++++++++++++++++++++++++++++
>  2 files changed, 47 insertions(+), 4 deletions(-)
> ---
> base-commit: 4056b3c9d3c92ea45955641dbafeb9b960e146ef
> change-id: 20261015-maple-tree-fix-slab-corruption-d1f098521d15
> 
> Best regards,
> --  
> Florian Schmaus <florian.schmaus@codasip.com>
> 

