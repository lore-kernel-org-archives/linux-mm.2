Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 812C1606A33A
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 11:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=jgdm78Gz
Received: by kanga.kvack.org (Postfix)
	id 9AE2C6B00EF; Wed,  4 Nov 2026 06:28:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 984F76B05B1; Wed,  4 Nov 2026 06:28:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8942B6B05B5; Wed,  4 Nov 2026 06:28:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5CF056B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:28:57 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9129E8066B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:28:56 +0000 (UTC)
X-FDA: 85397214672.16.1FBAEF1
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf14.hostedemail.com (Postfix) with ESMTP id B8BED100003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:28:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=jgdm78Gz;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf14.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793791734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9is/N8s+P77nIizr4iOPWVN8ElLFZtGDMyfkjPVV7ok=;
	b=xA0bTowTZy7QfTOJ4gvxlyyw38aP29Gx/uD5ri/hp41882wnweqJCU/5RehqVCrj2+7dt2
	7+K2vZLDJbYPgrSiLVnggF+1FJv4bi0SyTyddfkDyhPRvAd77DQxLqFC72PVkPUijtcagD
	y4O0xC0uGDna/lhUEpdqJRWJLx/vcOI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=jgdm78Gz;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf14.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793791734;
	b=QPi9FEjsErZjvISHQj73/cm+OE45ILmSB0UCYpCsaIN6tAlPaT14K1dJi5mdhD6VcVIw+C
	xgo+vkZ2m31kfdT0ccBs7Mlh/Dn5Gz0eD4Cz5SMHJDJeg3Ex++O0OoOoP3qt4ug3wnGsgD
	3sdBAdCsAlRUaZHo1bekh/H2G8lh9xk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9is/N8s+P77nIizr4iOPWVN8ElLFZtGDMyfkjPVV7ok=; b=jgdm78Gz9UGB9lEHqxYvlou0CF
	KutGa9kqLufeOHXyPksfalr8TGDd7Qjd3tQH2L7oBQHupX+kTlaaKzW1afMCyCYUaiJJ2iGGB70oX
	yUwrmnE7OVoMMYHZNTAmgbJKDUS5vKef2pVnD0LoEXB9jvIDd7ptVKguMRqbrtt0cXmhCr/XvjZAb
	7Gy6NMigdFntWPLB7BRi98TVcjr6fDcS6ocN6VGuh0+C8sJnMrobb1gCe0+zouonWA3lnpu1nkE8h
	RQ+Voe4lQl/aCzyPhyOrVaick563cL76U22efAn/kPb650EoOY0iEXzUm6cLk6F9GHhuBZQp4RtUI
	ZHYjfeYQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xOZA6-007g5u-2T;
	Wed, 04 Nov 2026 11:28:15 +0000
Date: Wed, 4 Nov 2026 03:28:06 -0800
From: Breno Leitao <leitao@debian.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, kas@kernel.org, 
	kexec@lists.infradead.org, Brendan Jackman <brendan.jackman@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, shakeel.butt@linux.dev, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, rmikey@meta.com, riel@surriel.com, harry@kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v6 3/7] mm/memory-failure: add hwpoison_boot_page() to
 flag an inherited frame
Message-ID: <ausWvcPv20yznl_8@gmail.com>
References: <20261016-hwpoison-kho-v6-0-f304255147da@debian.org>
 <20261016-hwpoison-kho-v6-3-f304255147da@debian.org>
 <aumt-4kfGGtoXuh-@kernel.org>
 <aumvVjoHo4KeuyEp@gmail.com>
 <auovL7i1rEcXCeGS@kernel.org>
 <auo3ScXy6dk0Gr3-@gmail.com>
 <ausLkNhb8ZPz0ra_@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ausLkNhb8ZPz0ra_@kernel.org>
X-Debian-User: leitao
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B8BED100003
X-Stat-Signature: p51en3yeksc8o1tj34qn19nm75f8weqd
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793791734-966192
X-HE-Meta: U2FsdGVkX19GnbbhzJnMflET60vTdaYbsgEM13bn0Rw/16009c/xxcP4FwGeaRaYSa+sa7WP3derPk5vfFw1s5s8df5ErdE6XdnYcbLQBwDtczfKIcsI1qKxrxcgbfrRwnrb7dNxocmRi9OR5U0ZLxQwvIM0TagP/kF9IG/e0HLDMQJRLykc0bs3CaM6br1t9r93qWGfr3WDTaEcN0+R91BCGXV4Ba6x54vtRI3FGrXh86D6JzemjKpgKMwN7YN1tGlFYJgkQpyhy6Rrl1gd92zRjOsC6X4fD3u7HqJ4KZTgjZeIvSBmNGbZxwABhWH+FHOpcLCala1Ek9FWtNQfaVjSTZ7YJyZOad9itFnumEBWH7VThkGQcsQxTwoNaz0iOfEQzojk9mQKM1hy7UKy8kXaP0WvKMTGvukSv5M7Em2KGrjjssktjAGmsOSzoqW7tX3SVNKE2OGvO+1E3ZoXS6WycpZ+/3iRqmOV23wSqkeGvEsC6EiyoTEm3u+w/8VjMD7Z0gm2pGs2ZS/J/TCZlBe7mt9FExSC879KfX1VHSXZSyXsCJcykokZ6z7JWTSEiAANzsa0uCfrsvtCp2MMfVUo0B1S2vJCQ9uswcfw5HydTRd3bF6A8HHJ2nYLZsQoSZFrCXq208m2GOu5+8XYXFmEq6fmf0UhPEB7Ykx+D8iXmYQ8w6NrTXO4cqokfMT4cbsVWJZ4ke9o7mHEzahyaxvEuJ5NzmWWiA6FEfY8JDztGDp6aEnsairNm5gJ/T6ezbb+ufzhk++VfmpDrM91Twnh8BuBOhEqD/we8EsK9IkMuaiwzIEhTZYUQKKVUAzNBzjgCg0CuAdj3yDKvkIZxOg81PESEa3/A789wzY1N0h2SDw3QiNYZyBiF/b+oWF+iRXU7v17jjqfF+hiPPz/45ZdYrUN2Tiew+oJvjON3h+U1izDBPOd1WeB1tvq7A31Qb6t/QXkoDBWI4t6XeY
 mc1xFUyC
 AIghpAzewS3fCY/fLGmfdPqm7iAQTa+1XMrRlmtunPT6QTKCzi7fstZ41589A9LWe77D8eOypHvRS0uBJ9dsOgUF511Wunye1SIV2QQoBYU3nkL0eetKjKe5mmVdGCV2iMeod7247hwQWpY4SKhm7i4FSF1VNTXtu0s6B7BrEjR3VkmlG+Vyt74fQU5gGwL4AeKabxzXHBCSqX0kvAgXouZrlEQBLamHW7iRk3KAGNXorble/9CRngF/ZmqLBQjfchppNx+7tVNZyJwSk0o9eWK4/Wjm6E7TEQI2sT8jlLWulg5xvr0qmMQnCgmhzJ/1bukJAZQnetWPSjt9ZfSV0acw1ux4a2qMCwp/Zdi9LJA+EcVW28lwYmNK9ti2wMntG5sqp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 12:40:16PM +0200, Mike Rapoport wrote:
> On Tue, Nov 03, 2026 at 11:49:44AM -0800, Breno Leitao wrote:
> > On Tue, Nov 03, 2026 at 08:59:59PM +0200, Mike Rapoport wrote:
> > > On Tue, Nov 03, 2026 at 02:06:17AM -0800, Breno Leitao wrote:
> > > > On Tue, Nov 03, 2026 at 11:48:43AM +0200, Mike Rapoport wrote:
> > > > > > --- a/mm/internal.h
> > > > > > +++ b/mm/internal.h
> > > > > 
> > > > > We've been splitting internal.h to smaller headers, maybe it's time to add
> > > > > "memory-faulure.h"?
> > > > 
> > > > Ack. I'm happy to move the "mm/memory-failure.c" section out of
> > > > mm/internal.h into a new mm/memory-failure.h, as preparation for this
> > > > patch.
> > > > 
> > > > Since this patchset is moving slowly, I'll start the header split in
> > > > parallel as a separate series, and rebase this patchset on top of it
> > > > when I respin. Is it this ok?
> > > 
> > > Sounds good to me.
> > > 
> > > Just be aware that MM folks are knee deep into fixes this cycle, so both
> > > sets could be moving slowly :)
> > 
> > Appreciate the heads up. In that case, should I hold off on the header
> > split until the next cycle instead of starting it now?
> 
> I believe one header split patch is small enough and not controversial to
> have it this cycle.

Ack, on it!

Thanks,
--breno

