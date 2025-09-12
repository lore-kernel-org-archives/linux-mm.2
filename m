Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A8C8CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 23:12:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0F548E0002; Fri, 12 Sep 2025 19:12:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 999148E0001; Fri, 12 Sep 2025 19:12:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8123C8E0002; Fri, 12 Sep 2025 19:12:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 690818E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 19:12:44 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1824516090E
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 23:12:44 +0000 (UTC)
X-FDA: 83882149848.20.7AE19D8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8262240009
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 23:12:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uPvN51zy;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757718762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6hRiCf14FcN2dIcM8kd/jn4varhB8P9bDU9Ojl/fz2U=;
	b=f/3Z4317QwofsibTp/3LTjSZ4+zFG9TTJhGy9EDu/aKQpnhV3MykybnZw8rtWh4LGWgWou
	AabOC9EHzmOWPtEpTJ/gDKWprRc29f1QRhKlPBscQs7x67qUa62lFX4ZW4Cn0ahfaIm4pQ
	DvUiJ7sMVYj9qEIPTwzgMY3gz2ZvtLM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uPvN51zy;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757718762; a=rsa-sha256;
	cv=none;
	b=g8hHYcQy6vXl1Qqypc8R28V8uEaPsQBnb84LK9cWIRz2YwNRga8w/nNXd0fX1X7HJVb7po
	VS8GOK9O4ME76FYkwYshkcA5YVI9KpnrqmKP7OIzX9nFTT/aTpyn004JtN+uh/FYKeYUIW
	EhtXFyPsqRPty87y4IvlJhKPufvHYmw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9324A6000A;
	Fri, 12 Sep 2025 23:12:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0316C4CEF1;
	Fri, 12 Sep 2025 23:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757718761;
	bh=thLvIl+wvhNHd/h+/PMgcFZYDNKs/se5pXZ8NvBGink=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=uPvN51zyf0Gk16PKadXMueozooisxs0w/wRwX29tBoqJBTo4x5gLEZpsOMl3SAiZ8
	 toWs4v4s+Isvs0SZ9f6cZt+BntkInj1O5MG9ejH/dcfWaJNIEJiJCuhLdTEqG5LxpN
	 hvsFbObfpXYXO9VjF+Ym6Y3HlQutUmpGWu0QAL64=
Date: Fri, 12 Sep 2025 16:12:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@redhat.com>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, kasan-dev
 <kasan-dev@googlegroups.com>, linux-mm <linux-mm@kvack.org>, open list
 <linux-kernel@vger.kernel.org>, linux-riscv
 <linux-riscv@lists.infradead.org>, linux-s390@vger.kernel.org,
 lkft-triage@lists.linaro.org, Linux Regressions
 <regressions@lists.linux.dev>, Andrew Morton <akpm@linuxfoundation.org>,
 Kevin Brodsky <kevin.brodsky@arm.com>, Andrey Ryabinin
 <ryabinin.a.a@gmail.com>, Dan Carpenter <dan.carpenter@linaro.org>, Arnd
 Bergmann <arnd@arndb.de>, Anders Roxell <anders.roxell@linaro.org>, Ben
 Copeland <benjamin.copeland@linaro.org>
Subject: Re: next-20250912: riscv: s390: mm/kasan/shadow.c
 'kasan_populate_vmalloc_pte' pgtable.h:247:41: error: statement with no
 effect [-Werror=unused-value]
Message-Id: <20250912161240.0a5fac78fed5ed8ddc32450a@linux-foundation.org>
In-Reply-To: <d7a03a2b-d950-4645-80f2-63830bd84f76@redhat.com>
References: <CA+G9fYvQekqNdZpOeibBf0DZNjqR+ZGHRw1yHq6uh0OROZ9sRw@mail.gmail.com>
	<d7a03a2b-d950-4645-80f2-63830bd84f76@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8262240009
X-Stat-Signature: 9h731r83fw6e7yw5trp91r1645pebkdk
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757718762-617081
X-HE-Meta: U2FsdGVkX19IHioNtYDsdfNLt0xrcXepNBOj5B5PXeX+PoG2qx0n0KyuObtEtjN3EsotudGUDAkQWlrdWeX+gXvSwI+5cHzeX8wam7q4vw5I21WXdqnenBsuzlTjoFiU6D+L/3M1D8Pm1UWQniEVbKhIVyyXMg1OzkmXqiLF3+sHocxNHQxL8gLd8A/0CaW5vWakdhhLgKcgS9HB9FK8LSfWzmAIj6m4Okmh14sbVWca0AmT0I8blvfbS+z7RwAyvMLdlj/ik2rtrazqXO2cpcFUbc4YKhf/e2ZXQH38Z8sxxRYkIXR4FCgzXkzWid6D814/J6sWHuUf7qRuvypgqxQMF66DQKt3VbA54HkE9SAVNfS1TJcFgbZetz2/8PExsWNdqyAUvmaUdZd4dau41qk9NdbLB5jf5vPuMQ1BkO7uY+LEBwrmgOFw2mhBDdmHUYz8WbxZ1izKQpMgsM8DU9F3RX9FQQG5ePIIn2TcwEIX+55EBZJVzB7pJCd13SsuYMS+nFf6d8EXd1he32oWxP9BPKikNcxcgSql0x4sKKMnvNo/xDB8EStWA84BkBtWLHkwCpv9tJ7QwoX5gVO3tHX1LhRqATS2WKbyJTQjx75zyT8mOUZey3+4Mr6AdmiGeUN+ckrJ1DwQmM6qAUwolRYgOcdACZROO1vxFp4YIoerICs0Cpg6fTR66Zx/IGgnhNDcteCjUKffCmeEW7X/VFqRCrSK2szk1bRZrqQxT9YDPz/hbG9f6VY1JrD4OnSSzPyQnQZg9+zRlGfmKUhPDohr04ILvejQ+JaocMTMGSFJK2UsHYkG8vGdB9anMFTUqwiTccAdB7ybyLNvspwa88fiJji6rtAaYgh05lzeLwJadkMhghz2ESSa2FDiDPI+WbicgQE/g2y+3BXd2TjOtSRMi1mrb19p1LJ3RnFv6RunMeVOhFKckafUykyJwU4hetT/NkLom5tbfmHvDq3
 c8LopZWz
 0oXhzdZtdFImTG49rSo7XvsO0RLyxc9EothTQN+1LZmGBMoE/ABaTKklIbe+ozhwXi/ZQHR4GwkJHJ+csRivl4tZNhv6iS5aC6fkmeB0kI3opvWk8/VNZsL7d5TQpK0YbjRmVl/YucxGhIe5J4nrQFmy0dzvCnfLUR5qbrPOQ55ryn74ijVfvJBnvpreaQnz4Cs0OQzG1SeY0tBgpKMqeoVJPUuaX3xsHOCZGCakwQwFiq9lOHZbYqzHBfF2cUSJJKS8ondSNvs6y45oyCXzomIFoBKwwKMCMb8yH5gl3kHbmQo9zMe2kLA6bi80ar+fcnpF0LLJEmD1liA3ZI6vEMsIEidkjAos4RD/i8rbXhYvpAOfrChnqHJxIT8fUMdunJa2TtCaaY6Utjto=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 12 Sep 2025 13:34:37 +0200 David Hildenbrand <david@redhat.com> wrote:

> > [-Werror=unused-value]
> >    247 | #define arch_enter_lazy_mmu_mode()      (LAZY_MMU_DEFAULT)
> >        |                                         ^
> > mm/kasan/shadow.c:322:9: note: in expansion of macro 'arch_enter_lazy_mmu_mode'
> >    322 |         arch_enter_lazy_mmu_mode();
> >        |         ^~~~~~~~~~~~~~~~~~~~~~~~
> > mm/kasan/shadow.c: In function 'kasan_depopulate_vmalloc_pte':
> > include/linux/pgtable.h:247:41: error: statement with no effect
> > [-Werror=unused-value]
> >    247 | #define arch_enter_lazy_mmu_mode()      (LAZY_MMU_DEFAULT)
> >        |                                         ^
> > mm/kasan/shadow.c:497:9: note: in expansion of macro 'arch_enter_lazy_mmu_mode'
> >    497 |         arch_enter_lazy_mmu_mode();
> >        |         ^~~~~~~~~~~~~~~~~~~~~~~~
> > cc1: all warnings being treated as errors
> > 
> 
> 
> I'm afraid these changes landed in -mm-unstable a bit too early.
> 

OK, I'll drop Patch series "Nesting support for lazy MMU mode", v2.


