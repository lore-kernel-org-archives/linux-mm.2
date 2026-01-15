Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4AF0D4116C
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 10:54:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 400B26B0092; Thu, 15 Jan 2026 05:54:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AF196B0093; Thu, 15 Jan 2026 05:54:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 265FC6B0095; Thu, 15 Jan 2026 05:54:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 155D76B0092
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 05:54:42 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9B45C1ADC05
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 10:54:41 +0000 (UTC)
X-FDA: 84333889962.25.9C05DEC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id C2AB3180009
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 10:54:39 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QKNzmbfk;
	spf=pass (imf24.hostedemail.com: domain of chenhuacai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768474479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pdg74zsxBOL+5I6B9wY5tfxbYgcTgy2Lifas/e/Csyw=;
	b=d2zTTa4KX61dHMTk61HEAryQG7oYjHAtTOP5hzpG0vtRwH1Op2UcJOGiZ8jSuw1yqQqUT+
	Art5UhIRvZlAS9R0ZjstYXCe2g6NsVgUknG+PmLtEpefRt1+eCQKAjhA+YGIZHJ0uUfHCq
	O7VOU0NpvRu4FMjTziIFlSA4dkKezoM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QKNzmbfk;
	spf=pass (imf24.hostedemail.com: domain of chenhuacai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768474479; a=rsa-sha256;
	cv=none;
	b=4dBtwOyTd6ioyizAWlaI37S0hGxsl/swTXhZnlhlqG3nCXDZIDut2g8eyIQdxjSwxLbNsz
	SsI69pvi5cFtaXDjeIaqztBZaeJFmkHmEe+Js5H7Uugy25wMPPaIX1bJubW1DDbHKYq5L5
	hjcteQTUKpEOg+FhICh8De8QQ7YR5SY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DC253601B3
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 10:54:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 707C3C116D0
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 10:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768474478;
	bh=/1KAtvLvvLMpDi9CfvfFJ6x5SY4Jp+t4QyV0IUSlh0I=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=QKNzmbfk137GH9cQf861KFuI/s73C1BD2S3Hmbu7L4olXN8PPEoplOGPC3Dn+Fghq
	 d7NNig4oWCpOSIeBtNStaJwz3bg7aVQZat7qFuMIPU0kjjV1Zxa7gbFsWnix0oDnv7
	 ZRKHmxfl/AQ8POyX8V98RhNoPE/yFC0oqIg1E0MtXDoMOAKelQtsVvb3FGZixoZivK
	 Rp7oq4fmbL4nC88WdaO1cINXanI8SNdp86XjdW3uyKEa9nEnZpVBxgV/GT7DBxWNJz
	 MGAMiMltUcK9PHqa/Jgmr9mFgqF0Q1rQRYaIL9ClhIG7TJqwK/Gl5opvhFbV6wah/U
	 wsGtLw2eFS8rQ==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b7cf4a975d2so148872866b.2
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 02:54:38 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCW7EWdz1pzM7d/eA70YIqU3GsOYvDt+6+oy4Ziv/GIispN7IBpkjoX/GNQeN1DVLSOZUif3b0yuyQ==@kvack.org
X-Gm-Message-State: AOJu0YzFAmKSeDjfXtVfOHd6Ox/dTkW7STUS4X3tiFtru9kHawCUh10j
	a33wSkT4TNgQfwLvXCaR9pC/VFDH4c8ZmuF8aT0t0FHgPY6UINV6RKs+ISNLVFMtA28AA8hA7aF
	bUabS4AFKlTgDcKTGvktsO/N+o54Myag=
X-Received: by 2002:a17:907:742:b0:b80:4103:537e with SMTP id
 a640c23a62f3a-b87614066e3mr530726366b.53.1768474476869; Thu, 15 Jan 2026
 02:54:36 -0800 (PST)
MIME-Version: 1.0
References: <20260114134510.1835-1-kalyazin@amazon.com> <20260114134510.1835-2-kalyazin@amazon.com>
In-Reply-To: <20260114134510.1835-2-kalyazin@amazon.com>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Thu, 15 Jan 2026 18:54:27 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6S4bVdpwbER84-iwSE+bQrFu_gF=Ww-bCFxThJ7WiUwQ@mail.gmail.com>
X-Gm-Features: AZwV_QhNEeWPSp4pau3pJiv_muGT_zHnXI7A5fP4Fz_wHAvUMBfJQxrRqBdZrqI
Message-ID: <CAAhV-H6S4bVdpwbER84-iwSE+bQrFu_gF=Ww-bCFxThJ7WiUwQ@mail.gmail.com>
Subject: Re: [PATCH v9 01/13] set_memory: add folio_{zap,restore}_direct_map helpers
To: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "kernel@xen0n.name" <kernel@xen0n.name>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"corbet@lwn.net" <corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org" <oupton@kernel.org>, 
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	"will@kernel.org" <will@kernel.org>, "seanjc@google.com" <seanjc@google.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org" <luto@kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "willy@infradead.org" <willy@infradead.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"ast@kernel.org" <ast@kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>, 
	"andrii@kernel.org" <andrii@kernel.org>, "martin.lau@linux.dev" <martin.lau@linux.dev>, 
	"eddyz87@gmail.com" <eddyz87@gmail.com>, "song@kernel.org" <song@kernel.org>, 
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>, 
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kpsingh@kernel.org" <kpsingh@kernel.org>, 
	"sdf@fomichev.me" <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>, 
	"jolsa@kernel.org" <jolsa@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>, 
	"jannh@google.com" <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>, 
	"shuah@kernel.org" <shuah@kernel.org>, "riel@surriel.com" <riel@surriel.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "jgross@suse.com" <jgross@suse.com>, 
	"yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>, "kas@kernel.org" <kas@kernel.org>, 
	"coxu@redhat.com" <coxu@redhat.com>, "kevin.brodsky@arm.com" <kevin.brodsky@arm.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, "maobibo@loongson.cn" <maobibo@loongson.cn>, 
	"prsampat@amd.com" <prsampat@amd.com>, "mlevitsk@redhat.com" <mlevitsk@redhat.com>, 
	"jmattson@google.com" <jmattson@google.com>, "jthoughton@google.com" <jthoughton@google.com>, 
	"agordeev@linux.ibm.com" <agordeev@linux.ibm.com>, "alex@ghiti.fr" <alex@ghiti.fr>, 
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, 
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "dev.jain@arm.com" <dev.jain@arm.com>, 
	"gor@linux.ibm.com" <gor@linux.ibm.com>, "hca@linux.ibm.com" <hca@linux.ibm.com>, 
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>, "palmer@dabbelt.com" <palmer@dabbelt.com>, 
	"pjw@kernel.org" <pjw@kernel.org>, 
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>, "svens@linux.ibm.com" <svens@linux.ibm.com>, 
	"thuth@redhat.com" <thuth@redhat.com>, "wyihan@google.com" <wyihan@google.com>, 
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>, 
	"vannapurve@google.com" <vannapurve@google.com>, "jackmanb@google.com" <jackmanb@google.com>, 
	"aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, "patrick.roy@linux.dev" <patrick.roy@linux.dev>, 
	"Thomson, Jack" <jackabt@amazon.co.uk>, "Itazuri, Takahiro" <itazur@amazon.co.uk>, 
	"Manwaring, Derek" <derekmn@amazon.com>, "Cali, Marco" <xmarcalx@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: hn5j8cyzenjwmdt79ryfs97b3483iufi
X-Rspam-User: 
X-Rspamd-Queue-Id: C2AB3180009
X-Rspamd-Server: rspam08
X-HE-Tag: 1768474479-328164
X-HE-Meta: U2FsdGVkX18U/YBz2WNkit8RqAVVBjYQnHIHVAfSARmv261tGL/GZO0cz9k0Q0cgbzkWyJ++00tWlZqzbwtt4+Bnc61Dh4um/VaHpCciH3pwUGjagm2P17bsY+u4A3bI2B0JfUiYowH/PWYJHZKNqeJJm42jWiOrLFtF994iY7Vbzpzj7tswan+AcWo3f4PGp2d4mXds4AZvjlbO1IJSbz5QbQqu54kGMHWecrxrGzVyHVD3sk6/nmLByZoVOHD3a3+GMpkROHj+B3eWs/1roZWp+ijw5ap7NTuvotmfenpY2RpivF3ka9flodiP+Fk1BtoLqrULCDTVa3ikhJDHdyg8bm+S+BI77J6BVdbVL9xoQtCts6oM2OYEig5/IgnJckpWTfkrUAdOm7DjewkyhLLP3P0GP5pbXZX67dy/7YJP89+k0oxUJ96fxD+mIG2ffAozlQs1nRPPqOSA5bVaP8u8e+bCjoWhy22MjEsuMf5AVlQi0DNqIpM/cu90nCneoiKAKaY7Qm752jyP7X6VmGaIIeDrxsmlAsH1FzRBXTdyO7Dt9A7jHrrbvgHqO7QFGzhMcaQ05QNb7rvm8/M2NLXiOzJdt/sr+S+wZvpCbNh7zPb+1ZHk33KeLY8BF6607aBxps+EqzMNGFKJOLECUvkG4NHfhyaIlKkl+//5BgEkt5omzpKf/ybWLDyM1s6uOeESxGYzur587MX3zNv+4gWynNWcVItHbiXLlXDv/T/ScEqGOLPAMJtvSkwjEDvcRd5UCTi9WP/5GutcFgCZf1CnwKFOxDAw71WpZCmY0S9C55OQFG2laIQSyGNyJ/WmZ6imBCHei40iReJXpij695rCXtIDTkM7hSW2kBwzU9HbsF1SS8P2I283mhbiAKULYDMNKpv79U5oQjIWDPnJvzC+oyToddgXWae6J/pyy23OPJoTPZKQh6n+8t+od+Mh+D+srGz08F7bsQK/fjL
 U8BEBIl5
 gC7Y5I+1rflM8ZV2VxCufu0JnM1Rv/iAKppPPoYavHPl6Lz/3NsolWzfO6bKpCfp3ToVbR2E7KcIwgJZf56bZ5kcm7nGOmF2bqV/ClFUnmJSqEceRX2BKDta0e7GfDksi0/6peIC0MtJTUa+/Hjm93z323tkqi9RZepNo0J9bmRRCgAeRo3+igsYEW6HFCbRmJ3/r+ck2oCzza/1LTxWS8bTa4I8NktLTePM0nNBqniiYHjiAPACofxub2zUXGJ8Ub3c0aj/Kb9UZR2o2EOBR+1I6LLFF9L/sicb4Ny4qdSNVcLa3i5JvLUkbS7a5F2x0T6b2dB2yiE6BqS+Fmv7TC8Iopw/6T+NjvV5G6oK9mrwf9idrLu/mP/LdSI4xs/2G2oTTbmuU1Z/nLUxFPG8bOy9PgdTz/W3X0abZJKxhSo2cx0fSjRvtgN3emkHHm6zAEr9vTPTNKBsPeC4VN23iX8SWrG96M5ijXuEgyI9E3Ov38UA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Nikita,

On Wed, Jan 14, 2026 at 9:45=E2=80=AFPM Kalyazin, Nikita <kalyazin@amazon.c=
o.uk> wrote:
>
> From: Nikita Kalyazin <kalyazin@amazon.com>
>
> These allow guest_memfd to remove its memory from the direct map.
> Only implement them for architectures that have direct map.
> In folio_zap_direct_map(), flush TLB on architectures where
> set_direct_map_valid_noflush() does not flush it internally.
>
> The new helpers need to be accessible to KVM on architectures that
> support guest_memfd (x86 and arm64).  Since arm64 does not support
> building KVM as a module, only export them on x86.
>
> Direct map removal gives guest_memfd the same protection that
> memfd_secret does, such as hardening against Spectre-like attacks
> through in-kernel gadgets.
>
> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
> ---
>  arch/arm64/include/asm/set_memory.h     |  2 ++
>  arch/arm64/mm/pageattr.c                | 12 ++++++++++++
>  arch/loongarch/include/asm/set_memory.h |  2 ++
>  arch/loongarch/mm/pageattr.c            | 16 ++++++++++++++++
>  arch/riscv/include/asm/set_memory.h     |  2 ++
>  arch/riscv/mm/pageattr.c                | 16 ++++++++++++++++
>  arch/s390/include/asm/set_memory.h      |  2 ++
>  arch/s390/mm/pageattr.c                 | 18 ++++++++++++++++++
>  arch/x86/include/asm/set_memory.h       |  2 ++
>  arch/x86/mm/pat/set_memory.c            | 20 ++++++++++++++++++++
>  include/linux/set_memory.h              | 10 ++++++++++
>  11 files changed, 102 insertions(+)
>
> diff --git a/arch/arm64/include/asm/set_memory.h b/arch/arm64/include/asm=
/set_memory.h
> index 90f61b17275e..d949f1deb701 100644
> --- a/arch/arm64/include/asm/set_memory.h
> +++ b/arch/arm64/include/asm/set_memory.h
> @@ -14,6 +14,8 @@ int set_memory_valid(unsigned long addr, int numpages, =
int enable);
>  int set_direct_map_invalid_noflush(struct page *page);
>  int set_direct_map_default_noflush(struct page *page);
>  int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool va=
lid);
> +int folio_zap_direct_map(struct folio *folio);
> +int folio_restore_direct_map(struct folio *folio);
>  bool kernel_page_present(struct page *page);
>
>  int set_memory_encrypted(unsigned long addr, int numpages);
> diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
> index f0e784b963e6..a94eff324dda 100644
> --- a/arch/arm64/mm/pageattr.c
> +++ b/arch/arm64/mm/pageattr.c
> @@ -357,6 +357,18 @@ int set_direct_map_valid_noflush(struct page *page, =
unsigned nr, bool valid)
>         return set_memory_valid(addr, nr, valid);
>  }
>
> +int folio_zap_direct_map(struct folio *folio)
> +{
> +       return set_direct_map_valid_noflush(folio_page(folio, 0),
> +                                           folio_nr_pages(folio), false)=
;
> +}
> +
> +int folio_restore_direct_map(struct folio *folio)
> +{
> +       return set_direct_map_valid_noflush(folio_page(folio, 0),
> +                                           folio_nr_pages(folio), true);
> +}
> +
>  #ifdef CONFIG_DEBUG_PAGEALLOC
>  /*
>   * This is - apart from the return value - doing the same
> diff --git a/arch/loongarch/include/asm/set_memory.h b/arch/loongarch/inc=
lude/asm/set_memory.h
> index 55dfaefd02c8..9bc80ac420a9 100644
> --- a/arch/loongarch/include/asm/set_memory.h
> +++ b/arch/loongarch/include/asm/set_memory.h
> @@ -18,5 +18,7 @@ bool kernel_page_present(struct page *page);
>  int set_direct_map_default_noflush(struct page *page);
>  int set_direct_map_invalid_noflush(struct page *page);
>  int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool va=
lid);
> +int folio_zap_direct_map(struct folio *folio);
> +int folio_restore_direct_map(struct folio *folio);
>
>  #endif /* _ASM_LOONGARCH_SET_MEMORY_H */
> diff --git a/arch/loongarch/mm/pageattr.c b/arch/loongarch/mm/pageattr.c
> index f5e910b68229..14bd322dd112 100644
> --- a/arch/loongarch/mm/pageattr.c
> +++ b/arch/loongarch/mm/pageattr.c
> @@ -236,3 +236,19 @@ int set_direct_map_valid_noflush(struct page *page, =
unsigned nr, bool valid)
>
>         return __set_memory(addr, 1, set, clear);
>  }
> +
> +int folio_zap_direct_map(struct folio *folio)
> +{
> +       int ret;
> +
> +       ret =3D set_direct_map_valid_noflush(folio_page(folio, 0),
> +                                          folio_nr_pages(folio), false);
> +
> +       return ret;
Why not use a single statement which is the same as the ARM64 version?
The RISCV version has the same problem.

Huacai

> +}
> +
> +int folio_restore_direct_map(struct folio *folio)
> +{
> +       return set_direct_map_valid_noflush(folio_page(folio, 0),
> +                                           folio_nr_pages(folio), true);
> +}
> diff --git a/arch/riscv/include/asm/set_memory.h b/arch/riscv/include/asm=
/set_memory.h
> index 87389e93325a..16557b70c830 100644
> --- a/arch/riscv/include/asm/set_memory.h
> +++ b/arch/riscv/include/asm/set_memory.h
> @@ -43,6 +43,8 @@ static inline int set_kernel_memory(char *startp, char =
*endp,
>  int set_direct_map_invalid_noflush(struct page *page);
>  int set_direct_map_default_noflush(struct page *page);
>  int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool va=
lid);
> +int folio_zap_direct_map(struct folio *folio);
> +int folio_restore_direct_map(struct folio *folio);
>  bool kernel_page_present(struct page *page);
>
>  #endif /* __ASSEMBLER__ */
> diff --git a/arch/riscv/mm/pageattr.c b/arch/riscv/mm/pageattr.c
> index 3f76db3d2769..2c218868114b 100644
> --- a/arch/riscv/mm/pageattr.c
> +++ b/arch/riscv/mm/pageattr.c
> @@ -401,6 +401,22 @@ int set_direct_map_valid_noflush(struct page *page, =
unsigned nr, bool valid)
>         return __set_memory((unsigned long)page_address(page), nr, set, c=
lear);
>  }
>
> +int folio_zap_direct_map(struct folio *folio)
> +{
> +       int ret;
> +
> +       ret =3D set_direct_map_valid_noflush(folio_page(folio, 0),
> +                                          folio_nr_pages(folio), false);
> +
> +       return ret;
> +}
> +
> +int folio_restore_direct_map(struct folio *folio)
> +{
> +       return set_direct_map_valid_noflush(folio_page(folio, 0),
> +                                           folio_nr_pages(folio), true);
> +}
> +
>  #ifdef CONFIG_DEBUG_PAGEALLOC
>  static int debug_pagealloc_set_page(pte_t *pte, unsigned long addr, void=
 *data)
>  {
> diff --git a/arch/s390/include/asm/set_memory.h b/arch/s390/include/asm/s=
et_memory.h
> index 94092f4ae764..fc73652e5715 100644
> --- a/arch/s390/include/asm/set_memory.h
> +++ b/arch/s390/include/asm/set_memory.h
> @@ -63,6 +63,8 @@ __SET_MEMORY_FUNC(set_memory_4k, SET_MEMORY_4K)
>  int set_direct_map_invalid_noflush(struct page *page);
>  int set_direct_map_default_noflush(struct page *page);
>  int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool va=
lid);
> +int folio_zap_direct_map(struct folio *folio);
> +int folio_restore_direct_map(struct folio *folio);
>  bool kernel_page_present(struct page *page);
>
>  #endif
> diff --git a/arch/s390/mm/pageattr.c b/arch/s390/mm/pageattr.c
> index d3ce04a4b248..df4a487b484d 100644
> --- a/arch/s390/mm/pageattr.c
> +++ b/arch/s390/mm/pageattr.c
> @@ -412,6 +412,24 @@ int set_direct_map_valid_noflush(struct page *page, =
unsigned nr, bool valid)
>         return __set_memory((unsigned long)page_to_virt(page), nr, flags)=
;
>  }
>
> +int folio_zap_direct_map(struct folio *folio)
> +{
> +       unsigned long addr =3D (unsigned long)folio_address(folio);
> +       int ret;
> +
> +       ret =3D set_direct_map_valid_noflush(folio_page(folio, 0),
> +                                          folio_nr_pages(folio), false);
> +       flush_tlb_kernel_range(addr, addr + folio_size(folio));
> +
> +       return ret;
> +}
> +
> +int folio_restore_direct_map(struct folio *folio)
> +{
> +       return set_direct_map_valid_noflush(folio_page(folio, 0),
> +                                           folio_nr_pages(folio), true);
> +}
> +
>  bool kernel_page_present(struct page *page)
>  {
>         unsigned long addr;
> diff --git a/arch/x86/include/asm/set_memory.h b/arch/x86/include/asm/set=
_memory.h
> index 61f56cdaccb5..7208af609121 100644
> --- a/arch/x86/include/asm/set_memory.h
> +++ b/arch/x86/include/asm/set_memory.h
> @@ -90,6 +90,8 @@ int set_pages_rw(struct page *page, int numpages);
>  int set_direct_map_invalid_noflush(struct page *page);
>  int set_direct_map_default_noflush(struct page *page);
>  int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool va=
lid);
> +int folio_zap_direct_map(struct folio *folio);
> +int folio_restore_direct_map(struct folio *folio);
>  bool kernel_page_present(struct page *page);
>
>  extern int kernel_set_to_readonly;
> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> index 6c6eb486f7a6..3f0fc30eb320 100644
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c
> @@ -2656,6 +2656,26 @@ int set_direct_map_valid_noflush(struct page *page=
, unsigned nr, bool valid)
>         return __set_pages_np(page, nr);
>  }
>
> +int folio_zap_direct_map(struct folio *folio)
> +{
> +       unsigned long addr =3D (unsigned long)folio_address(folio);
> +       int ret;
> +
> +       ret =3D set_direct_map_valid_noflush(folio_page(folio, 0),
> +                                          folio_nr_pages(folio), false);
> +       flush_tlb_kernel_range(addr, addr + folio_size(folio));
> +
> +       return ret;
> +}
> +EXPORT_SYMBOL_FOR_MODULES(folio_zap_direct_map, "kvm");
> +
> +int folio_restore_direct_map(struct folio *folio)
> +{
> +       return set_direct_map_valid_noflush(folio_page(folio, 0),
> +                                           folio_nr_pages(folio), true);
> +}
> +EXPORT_SYMBOL_FOR_MODULES(folio_restore_direct_map, "kvm");
> +
>  #ifdef CONFIG_DEBUG_PAGEALLOC
>  void __kernel_map_pages(struct page *page, int numpages, int enable)
>  {
> diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
> index 3030d9245f5a..8d1c8a7f7d79 100644
> --- a/include/linux/set_memory.h
> +++ b/include/linux/set_memory.h
> @@ -40,6 +40,16 @@ static inline int set_direct_map_valid_noflush(struct =
page *page,
>         return 0;
>  }
>
> +static inline int folio_zap_direct_map(struct folio *folio)
> +{
> +       return 0;
> +}
> +
> +static inline int folio_restore_direct_map(struct folio *folio)
> +{
> +       return 0;
> +}
> +
>  static inline bool kernel_page_present(struct page *page)
>  {
>         return true;
> --
> 2.50.1
>
>

