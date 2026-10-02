Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1B2FCA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 01:34:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 656C96B008A; Thu,  1 Oct 2026 21:34:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62EB46B0093; Thu,  1 Oct 2026 21:34:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51D396B0099; Thu,  1 Oct 2026 21:34:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 07F4B6B008A
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 21:34:33 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6B2011205FE
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 01:34:33 +0000 (UTC)
X-FDA: 85275966426.14.811784E
Received: from mail-wr2-f13.google.com (mail-wr2-f13.google.com [74.125.225.77])
	by imf28.hostedemail.com (Postfix) with ESMTP id 815EAC0002
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 01:34:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nP9yM0mI;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf28.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.225.77 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790904871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7kzLbFV0dwlxOBcT/RyJ42nswcrqycHxeUvPWMKQHOM=;
	b=NF/i/wEWWdqgWtpoP5IBYQiyWf0TzMVerILTnBaSM1u+FHgDVafYuWVkzK1IVL6U+U/pGj
	7rNgshbWFLlA8XLzoH+LLOx3FZ8JTDmAjG+tg3Hs7ZoE8Sm3DTsvyO4lxD3zcANbClGeMF
	WYWka8fa7LtZQZq50nKr9IEMfy2rXhM=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nP9yM0mI;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf28.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.225.77 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790904871;
	b=k8yYz2LPJ6/HWSWaSttAVgwImIJiYW5JDKjsZAjFykmcYFq9KED+YWQhqbeg68rUxTeE6B
	mp/3q9BeLfztFq2ngcEaVV6M18NretJck0gxZbWbkuZDobzhXzUCc29PRFKJgYD3ySE7T/
	0M1NhrEWL3gZHCJBfmeYW1/bkBTHU4o=
Received: by mail-wr2-f13.google.com with SMTP id ffacd0b85a97d-48affce98dcso316345f8f.1
        for <linux-mm@kvack.org>; Thu, 01 Oct 2026 18:34:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790904870; cv=none;
        d=google.com; s=arc-20260327;
        b=ZwX9fR6sUfOUXQQesmuwhC7wzW2oNyphHwdlIT9LtX5kPkFiqyicNQ1H6UY9MPGSJz
         0AzEhMm+HIvng9a/lzS14ylNtpvFjreo6S0rTbanBglZqqVJRMeqjxXMqgsNJJ6gxbsg
         zd2k6eYkWP6iNUp8BKQ3ecWzQMRzMxsdfFCqdP8wo+prpotFooBMZ/B1iSjKVZsrcliC
         j5KQBF3JKQXwBnyay8YMc3nfvhh3uwhHHBjy+snLq80G/DzuGGT4wrMiXqq3uW+FZwYn
         QacUai4MGxpi8mjH3nnFCld5GYs/GFK7vICbXK6gnbCHToNPEEdMFees3rwM+0rqKlSH
         cJGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7kzLbFV0dwlxOBcT/RyJ42nswcrqycHxeUvPWMKQHOM=;
        fh=pvKwzCJGb2d8sF7FuYOCixz4frW9yhuiBy3zkgRgD4o=;
        b=QSSCkDgY8j84g2X0i7WyFl3lTU0CN2IwyhM5lDyAplCScSOgp1Rj+xmXM5l0xgP4+Q
         wIevZh116qYD1iXgq7VnwCWozX76ORwPy5XSkGA3vlTIvh1vZ1TKdBLtfOEfrzvZV1WM
         b5L+JNcMcIBNZ3FJqI54rq5c67vyuAypbfISCdChwDR2swyL/YgYeIe8EMhaOoekE1FZ
         p9A+ycEYt1W1oQaY8A3HN4vnDv7kyEMWiwV5pTTu/zR8P+aiYqY4YLvY5Zs9SI47mJE+
         Aehc0m3PoduzVb5zDw/+kgdlWd1F2aaOgltfGAbLCQaECX8i5zsTOPUQdhbQLbSAk8Xg
         WmaA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790904870; x=1791509670; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7kzLbFV0dwlxOBcT/RyJ42nswcrqycHxeUvPWMKQHOM=;
        b=nP9yM0mIAbMSvfN/XVv360LWRy4LtVEuoW0cWPN8LGAdR3GzSXUCGAJ6xPcV8+EvoV
         oLWfaYlF7yCBNwjHt5i+lEnjpMlYAE5tgU9X2CBGD4Z2OW6eopSmx5lXE0xWaMUP2Nor
         93KYyNIiEVWtM5ntEw5KSe4iIz5h2v+rgQyKuwGAdgqdRiHFSPBpT8kCygdH2AAcSv2n
         qHYgZwqzYyOzFnmbqoj7ryrGdVcb7vc8U0kY29yTwphaDlb1nTx9AfvDGXIdKo2DAiv1
         DlASkqfZSf7Qs22CgOXeLbghaIP5Zy/OXKCtBfqq5ANYkRa2tKx4/LTT1OGpnjIrpIyZ
         QlEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790904870; x=1791509670;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7kzLbFV0dwlxOBcT/RyJ42nswcrqycHxeUvPWMKQHOM=;
        b=I//p+1mxWjsa7sHju2onJHYGl1fv6CV6QTSeX9KcpWt4h27e9xiJD1Qxb8KMvyeV+U
         WK3VtZ9RDRJpHuwFTjjDX1VtieYHa87O+SZ/kHVvrd6QHacidimCE8LLx0Pdv/eXXsnc
         cqPNBlqH4rVv+Ge4wNrgUuBgZPeRhwFDLp8CKtmSJdg0thmtMFKohm6DUNiRtkJ7mETp
         rwBIhfvImmavucNsID9CZurWJ8epbP0K27V2x5jUqyCYYOxUaRq5k7HQC6g6Xc027Bpx
         PpuBEMpubfXe1aTFLYuKpIYQnl5VkgcSi8e5p5gHkO1kYiv3FsBlMrEQ/keosxlWPgfZ
         Atfg==
X-Forwarded-Encrypted: i=1; AKwUvBx31l4fjQyFCHwBeTIGoKOJh2/T1/zIvt7nvBbFh+MIx5A4zYZJ/81UU9/14fBNUKBUdec4vkL2bQ==@kvack.org
X-Gm-Message-State: AFq9FYJnTkK34J5YNG7tX+rg1m9W/jp+++ySSgSAySqrbsRVgsLoEABN
	SMbtdiXkdnniSCLJ/9DSFsJf1fYNEGXp7ugSE57MrufoEnh6EfzkSuqr5wAeA9qzmwukB/VTxTE
	MeKvqHy+/EKC7Qq8CGBdFlBsL/oMtoHE=
X-Gm-Gg: AYBFou1tIlKjaXd5l5agbCwF5b4q2or+LJemOtBxRNHmzikLneSQq6tc6+g2EEbBn9x
	uEw/xGQ7ZKIRUIEXfg9cFa4bvkHpRtb98QZRHHqaQJmAa3vbs3RiDg2bbUSEhq8gdNQnLN8KTiI
	afF9xrUvf82GUGhIOS7AqRppmLK+7hS8gP1/tmilouoPK48h7Z2wOkcKsBjYhWrcaAoMeRchRYw
	Zse4E4+HkoL1N79q3mAHoDk5oo02MUH+6cxF8eU24JNt0vnGvrOgkc8Rm12+5zDkSV3qxCkTZMh
	JP5PZpIlpwo+7sMm+WAOHhBYCl/rrs390g40qey0GBz5Q0qFu4Yz2+w0SkeWu2Xs1Fj4vbMkuaE
	fe2OLS08P9t5hBaeOHptRzmWOJjHZfDp39HdtjPU=
X-Received: by 2002:a05:6000:4553:b0:48a:fb21:57ff with SMTP id
 ffacd0b85a97d-48b126b18a8mr1280078f8f.1.1790904869631; Thu, 01 Oct 2026
 18:34:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260901151818.3191443-1-xueyuan.chen21@gmail.com>
 <20260901151818.3191443-3-xueyuan.chen21@gmail.com> <arvJbQmr9GwToA8R@willie-the-truck>
In-Reply-To: <arvJbQmr9GwToA8R@willie-the-truck>
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
Date: Fri, 2 Oct 2026 09:34:17 +0800
X-Gm-Features: AclHuK_utlXfpNApdIg0tCcQS_k28vJDN8Yu8dMba1JX-4Q5uJzs9ebkm6k6FjA
Message-ID: <CA+qSx6zV32EN18S+GjESz-Es+6=Zh-m8U=-UovA=rsoBnLWWww@mail.gmail.com>
Subject: Re: [PATCH v7 2/3] arm64/mm: add set_direct_map_ro()
To: Will Deacon <will@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	usama.arif@linux.dev, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, kas@kernel.org, 
	rppt@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, 
	linux-arm-kernel@lists.infradead.org, tglx@kernel.org, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	luto@kernel.org, peterz@infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 815EAC0002
X-Stat-Signature: hbagua9fzwngmz3fa33o4x6qy8rc8wgg
X-HE-Tag: 1790904871-40604
X-HE-Meta: U2FsdGVkX1+ZM5V6M3XKACf1nMqzJWQi7WSH6ZIIQK849ayVcDqHXLaBwc0uLihjF71F9/+ZmWcOJPr0uyJiQFABMlumY98+AePJpa8VSuYNJzOI87pLCQZKkSRRDVA7nrDzrfa8aZvu5DeBvXCe4tOzrk7paoccmUN4vmnz6vQHYpCbgrA2UnvLWrK4E04DFoVNbHpH8oBUXeNODYTUmrARBM9nfeX0104CC4nB66MAVDgh93BvqyqlpFVcT9PTU1RlXfxY0uMWrsOOTtnitfCNU8hGCHLYC0NGc5uL0ZzzKDCd2gQBDuDYJItLI0j6zB6u2Ez6HoTPx0EzKoIMsVoMzo8QXo0wZC6EnUmp1iEDsNbSUsYiENgjJrfbZgAlhUedFpHWD8rfaAiKdouIFvYOd8ANDM5ewWqU2XLc72/q89D0DH7CuNtD8UB+pGQR3IVYfqjeFKOyX30+12hqE9s3X1VlpztvnR1mvvLZDTSEFGwpaeIQ8HOYbXKQze0DAM9sjpLO2qL76cYoeSej1D+26mFgObg9WUtjack8MuFYGY1qw4E2LyAqnjJNNsUAR7/P/Dq5ma9vsYpWrxBl/AFlGL2wmFyZu4v0Kt3vIeX4h+HqUZe3CDQoy05qhhxjtD8JEqkms1h4057aiEYT4PdjL/EI2DlYhBrrWDyQlwkyGNjJulXCpaAWAJwyo/z7bQliQi4Z9k33W52g9iH1qBrNLPHLAaBQCq+lEwrND+VOKo/q39S5VKBiXwlQQi5Sz5+ABi6DuqLufwHnBMCcE60nYh7qXe6d3YpeL3Qsd8aP7UCwMZlXcqhO2JN24MmKDIdyECDEEUJZYTHpAWahYI3WEvdtKp9XpqW6K5uSQjt6mDQLNQF7t9EA3SrhErY0dFVidPRLcaVUQjOVjUt667ETotrWw0NeDKITA8PdHp/NIQx1n9yz3h0LoUxcpPBYCQR/JmmidjLZCiUdN4U
 sediKROP
 xeiOckz5oOuQCYC2CRzKNVGCdJGIDPNQDxVSaSmuozMgXwrwLh6jqOB81y76WOsZdLHQj4ulZAo+iffnlvUvzLfXh399Adbs0v4GEdNJR67CmpcOU9qHTjYN08t/6Q5p5xUcfhFg+6LmxqfQo0koS4ELZQgnKZ15gInKmNrAOwRAdJtv/NHj243tWO6Gu6QeJwTI8f+gNUP2nm2ch1D+weMO5dXqzaPXwwXcA5LvGKdRr4Vrcx15lJl0e4L5h92Yzxmg6vpNxqiy8NPJ3n9zKc1OOqt+p3ziojVWXm0jnc1BBdZ+AhYzc24MQxiRqWc+ieGVciLXB90N9yzzWFPMRGijdNBM+SAmCVJSI9GXWOKn4qdoH281pU7D0KZb3DYXyAjpl0Ox5TzyRSSo20fxV9sqBIPmW9KvWzvbLiBIJ/zQhxe+cetnDRN2kVWS+uEgj18Qi6CwS0JkyTZJAXPqWpsjlLK3M4NSNiNZHiK/P+YUXPwoKJzfvJyximgWljZL30jHwo57DcwKM0FIR8cnblhYetA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 29, 2026 at 10:21=E2=80=AFPM Will Deacon <will@kernel.org> wrot=
e:
>
> On Tue, Sep 01, 2026 at 11:18:17PM +0800, Xueyuan Chen wrote:
> > Implement set_direct_map_ro() for arm64 and flush the TLB internally.
> >
> > Co-developed-by: Lance Yang <lance.yang@linux.dev>
> > Signed-off-by: Lance Yang <lance.yang@linux.dev>
> > Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> > ---
> >  arch/arm64/include/asm/set_memory.h |  2 ++
> >  arch/arm64/mm/pageattr.c            | 12 ++++++++++++
> >  2 files changed, 14 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/set_memory.h b/arch/arm64/include/a=
sm/set_memory.h
> > index 0091ba12200e..1be86dc11543 100644
> > --- a/arch/arm64/include/asm/set_memory.h
> > +++ b/arch/arm64/include/asm/set_memory.h
> > @@ -13,6 +13,8 @@ int set_memory_valid(unsigned long addr, int numpages=
, int enable);
> >
> >  int set_direct_map_invalid_noflush(struct page *page, unsigned int num=
pages);
> >  int set_direct_map_default_noflush(struct page *page, unsigned int num=
pages);
> > +int set_direct_map_ro(struct page *page, unsigned int nr);
> > +#define set_direct_map_ro set_direct_map_ro
> >  bool kernel_page_present(struct page *page);
> >
> >  int set_memory_encrypted(unsigned long addr, int numpages);
> > diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
> > index 132938b32eb1..0e95cd904ccb 100644
> > --- a/arch/arm64/mm/pageattr.c
> > +++ b/arch/arm64/mm/pageattr.c
> > @@ -355,6 +355,18 @@ int realm_register_memory_enc_ops(void)
> >       return arm64_mem_crypt_ops_register(&realm_crypt_ops);
> >  }
> >
> > +int set_direct_map_ro(struct page *page, unsigned int nr)
> > +{
> > +     unsigned long addr =3D (unsigned long)page_address(page);
> > +
> > +     if (!can_set_direct_map())
> > +             return 0;
> > +
> > +     return __change_memory_common(addr, PAGE_SIZE * nr,
> > +                                   __pgprot(PTE_RDONLY),
> > +                                   __pgprot(PTE_WRITE));
> > +}
>
> I haven't quite followed whether or not you intend to send a v8
> making set_memory_ro() handle linear addresses, but fwiw the
> implementation you have here at least looks correct to me, so:
>
> Acked-by: Will Deacon <will@kernel.org>

Thanks for taking a look!

>
> Will

