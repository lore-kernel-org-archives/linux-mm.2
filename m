Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D1C7C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 19:56:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 130F76B00B5; Fri,  3 Jul 2026 15:56:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BA176B00B6; Fri,  3 Jul 2026 15:56:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC6376B00B7; Fri,  3 Jul 2026 15:56:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BFC576B00B5
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 15:56:53 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 48D87A0291
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 19:56:53 +0000 (UTC)
X-FDA: 84948523506.04.49310FE
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf06.hostedemail.com (Postfix) with ESMTP id E3A3818000D
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 19:56:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b="fbhDnA/g";
	spf=pass (imf06.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783108611;
	b=SzRt4FXQRcen2StAPTTPQ+ZCiOJ7ymhmoMUrLGNF9ozA3MMaCxAPnD/CP0Ij0KywK3sRFm
	qYultmsTXrC6YT15Hvxxpz0890J5aScETnb1kzw5B2AFX0Wvw6e3KkwTjniLXjROr9uwe+
	c2b+8vy3Kgq/S+ZDDlN3OUUx1GXQtps=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783108611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ec4ooeB81VdLBBWoolmCjIrqAa/mMFqe7GUMG3eUFx0=;
	b=UQTL4CwWkYi/PrjZHcJNCSf4uuqS3nez/fzUWcHqafCLg1Ue2qg2zS+xuGpXbVl6fS4pSJ
	2ObfZHmNhNEgb4vrhTGp9SzNhYjmkFio687AQyfFVKgFT0ehytj/03WfRsaRhcaP+fW8n8
	q76hSU+iU2YJjJoxthQjPHJI9aGrsQ8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b="fbhDnA/g";
	spf=pass (imf06.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id E8A7640E01DB;
	Fri,  3 Jul 2026 19:56:47 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 591k-6jQHESx; Fri,  3 Jul 2026 19:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1783108598; bh=Ec4ooeB81VdLBBWoolmCjIrqAa/mMFqe7GUMG3eUFx0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fbhDnA/gtOESnV9bPd2jExK58X/KJ+kXFtj7TALiu2D/pTjDmFF+sq2Q5S4GTDoZs
	 Rfn5fhAbaqjrt66z5m65Gp/yldPN4Ssmi5cPYyGdlTe7ZNjpcZ3Dqz/kW7Nv8iqp3b
	 QkedMrE1/YPFjPknxed4vUpV0fnVmvTJzrJP4xMkdqJ6SJh4znVRjFxk5eg7GcQxJi
	 cVXNsLkRf/3Z7BxcWNoQzn6i9aR8qN/ZGM7COx03LYky89jAHnso74jYMsfasa5dxU
	 ykabhvjrBh3QhJuoQb+/YvMbUeieDfz142B32N5wS7fFKGWBbYMj0D9HCGeoDCqUox
	 f4GDW8ngLep9gNMJO4JlDs7OfiBRnPIzjAScLuSOwZzLBwtwddJv9MRPUreHp6/aeA
	 kCGiRqVO7WuBnhYBqfdL4Wjxwp2m9JnFoqK+Ido2qLgLsQAzOwd3tyXTWCusWmy2RC
	 2Ks7tRaZj99L2v+VbpEXaKCbyZQMflIkx+YZ8cB1mJ2mXZ6HnKGSvAE56tLI6yRZi8
	 jLl9CP+mLFDS4mTQyW//oyD1Q9w4HDNZXnRCA6FNS1XukmTlJufSbpNlAL2KemskFr
	 OITG3TLxt6kcMu9wf16o/ao7qLJAcQ37ePi9aOi+X7Y4bVRkuGoYdm1DN4hN/VGOtk
	 tCVkVB1slPHiLCfzotXwxa1k=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::e])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5108940E01CE;
	Fri,  3 Jul 2026 19:56:22 +0000 (UTC)
Date: Fri, 3 Jul 2026 12:56:19 -0700
From: Borislav Petkov <bp@alien8.de>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, apopple@nvidia.com, arnd@arndb.de,
	dave.hansen@linux.intel.com, david@kernel.org, kees@kernel.org,
	linux-arch@vger.kernel.org, linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mingo@redhat.com,
	rppt@kernel.org, tglx@kernel.org, x86@kernel.org
Subject: Re: [PATCH v5 7/8] x86/string: extend memcpy_flushcache() fixed-size
 fastpaths
Message-ID: <20260703195619.GGakgT44P7lpcoMVlY@fat_crate.local>
References: <20260702022342.GFakXLrl7ryd-g7gTu@fat_crate.local>
 <20260702073750.73840-1-lizhe.67@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260702073750.73840-1-lizhe.67@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E3A3818000D
X-Stat-Signature: bmb3hxrwwtdb8bhyg4ehofqt8kwtx177
X-HE-Tag: 1783108610-220373
X-HE-Meta: U2FsdGVkX1+CflDlUfIfhRICvt8BZQyUnqQ7q1Y0o0yXgdQ1XLvifMNnYDIK0ye2zd0J+uPqpHckinHSVh3hgNlCCNTVACmuoocCpE1cYSdxTkSBfsCYBpurmGAmT8NAmSbmrFbP9LhpzuabH7eIPKkm0ykp3xNsB4rEtXI5rgKCjnvo9LWz8ddxBIwQx6Kmlj9/puH18WswmaBBTIxB0LF0820XqOVGIU5cmR4LF2vGAzyfSFvQ/wQZTr1UmaNMBRhv9dK3emV63x3AsG81IE8vl/ULiBZPdhqSWI6v+63ZR652vqWc1PJgrWLC1vQBOpKariIj9HszQFqNSWkVA+sD1fhtXS+PHiOXC89ahfNvYKPerTlg/LVPuikwaBj4GDLdnOx5KzxlEZa42A5S8R7wg3I3H+KI62a/0gd8wAgmOLHhFKrwYyfzOl26wftbiS+dehTy7qyhQ5XZUpLEHU4eO0U5iG6KJCRtLHySEQdaYe+GVp81UsEsMpo0UGVi+iUeUiY9RWbKEy3kAmaZHuvoe0SruuDdrqThXmF3EqBee156OiTeD4EMVYlYzg5b9mH+JtLSfG6l3va+XT22iLDQDaGda/0Le+HUZ1c7iT63VjhAgd/3pLHVmYH+Z44rFrn01hS80vIVAxr1NNra5Mk+I9DZ/9qtTjdbWtFfdl/e0XXK3dF4yjMdeBCU7lyVsBDXI+mUS+0pC09V5sGbTA/6yMaO/53jfXBJIEgNrmD47OGwZqKh+5/mHRQrfxtVnVOn7AEL+ssyC3xoLsA/KuaRI/YHDWoE0NQZ27WwhEhQxObmbfRrV51mAW2c7ljRkgdUUTOEfN7zSbJoG+1bJGX43zTPEzU95YP2/iNn0yEOd4TB5T62oMHDuqN+qTdD4ANGHduVjMtM5uWCO/P2Y4S3G5fQdENp0x10fwSwwTUKPDUmz9m5+eqQ3iKA8ezb1ZpjsAd0S3kumZaGVTA
 Wl+W8cxK
 iubecd93s8W9B6pRx7PSY5UFm2pji6egbUSXsIm/lTeVsSYArGZhFDfFZHQJFBBg2d6NcFgGVYjsj5fF60dYB03g3xFN7tDNdFeDp148bxFeVImhN0NRkYr1rI7/7nAOSf2IetGomFYqLdHeBcqsgF1YCpu6LTcJSuc6uV224LDt97krb0fAeEm3ZicI1mz4TZEv8JEVyrm9GmvPVonEGEvCT+0F8L28uVv53juJsVZjs1bAROsoOIySfVJF9WKJunWAs/GUscvDnJoOpQJBuGW0gLaX7Fy1Wc82RtCZLXLZZKVTshCaKHV7VgjxH+DH/R33pmic5vNQXLcgpJEkg+QVhPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 02, 2026 at 03:37:50PM +0800, Li Zhe wrote:
> The relevant target sizes here are the x86_64 sizeof(struct page)
> values which patch 8 can hit: 64, 80, and 96 bytes.
> 
> On x86_64, CONFIG_HAVE_ALIGNED_STRUCT_PAGE keeps struct page 16-byte
> aligned. That gives 64 bytes in the common case, 80 bytes when
> WANT_PAGE_VIRTUAL or CONFIG_KMSAN adds extra fields, and 96 bytes when
> both are present. I stopped there deliberately because this series does
> not have a current caller which needs larger constant sizes.
> 
> The 32-byte and 48-byte cases were added only as intermediate fixed-size
> combinations used to build those larger struct page-sized copies while
> keeping them on the inline movnti path.

This needs to be in a comment over that code so that it is clear why that
distinction has been made.

> Yes. The separate helper is there exactly because the added
> 32/48/64/80/96-byte cases carry an extra 8-byte destination-alignment
> check, while I left the existing 4/8/16-byte inline cases unchanged.
> 
> The intent was to keep the larger fixed-size cases on the inline
> movnti path only when they already match the alignment assumptions
> used by __memcpy_flushcache(); otherwise they fall back to that
> out-of-line helper, which already handles the misaligned head/tail
> fragments before entering its movnti loops.

Why can't the larger MOVNTI sizes deal with misaligned cases too and thus make
the code even simpler and more straight-forward this way?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

