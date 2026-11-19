Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB408606A335
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 13:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=czdgTeJ/
Received: by kanga.kvack.org (Postfix)
	id D0E9D6B05F1; Thu, 19 Nov 2026 08:27:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBFC06B0648; Thu, 19 Nov 2026 08:27:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD6046B05F7; Thu, 19 Nov 2026 08:27:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9D2616B0648
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:27:39 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 32A7E1A0AD9
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:27:39 +0000 (UTC)
X-FDA: 85451945838.15.301FCAD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8EFDA40004
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:27:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="czdgTeJ/";
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795094857;
	b=zvuaSrHrlqTwrrkZvPtXOV1nixjseWBKExCLowOB1WPfDWUqHoSysIWfDTkm3O8TjklDQ4
	vjEWao/bFugQCkGAeMs9cJAZQ1eamgDHjeMQrOzW7VhUYwnbUNZ+EFYCZQ1WL2amDT15cU
	wYn/dViVy7jq2gA/4VScyHaKIsjhcPw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795094857;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TdonzvW3OSCabp3tACnsTqet4wn+KAC+Xy4s16zQgfI=;
	b=s6CKC546KDjwFyxt200a10cNlCyukKRKiR+8JZdwEbjsYl7ygingHIHM1iwTU+s63WgClh
	bnliKznGjtWdRZxXnfUVu/OE2/gNuYsIXMarz0EmMdSUHG7ziMq2d96IYsrSnYWEX8MMob
	qhM8iOtjxShy8wF6uUXDgnCIEBMWoVI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="czdgTeJ/";
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E17E5637DD;
	Thu, 19 Nov 2026 13:27:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46BF11F000C5;
	Thu, 19 Nov 2026 13:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795094856;
	bh=TdonzvW3OSCabp3tACnsTqet4wn+KAC+Xy4s16zQgfI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=czdgTeJ/fdO5ujJoIxxdN2VPIIj3mhjUDFxXG9L7nPuQboZ2dCGO9IN0yYthfEC6O
	 VmZQS9VY0ElXlSZvXsH75ZbAkLcqrs82lXnHr0E9y5XccMyx/zIVT29gL16tVdDVbC
	 y/Nn3wnr/ca6/3HDZNAsem0VmeuMvKpmsvQt9m4p4FX0/smJzsXtoy89xMlF5+rlb6
	 R66soS34ot2WRJlk3YJ/PfCgfT/WWV/Wc1gDkG4hiuzTi8g0S110s1mnAdAOypXaT2
	 5B5fIj7nVvbpdClbeVJLV6l/iQ3bykV7ix5gHpAfB97P0+KqdsJXR5I3qnqEOfuJo0
	 Ips/0djyFiw4Q==
Message-ID: <sashiko-outbox-223175@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] alloc_tag: Use __ prefixed ELF section names
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ard Biesheuvel" <ardb+git@google.com>, linux-mm@kvack.org
Cc: "Ard Biesheuvel" <ardb@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Kent
 Overstreet" <kent.overstreet@linux.dev>, "Hao Ge" <hao.ge@linux.dev>
In-Reply-To: <20261118132719.632451-2-ardb+git@google.com>
References: <20261118132719.632451-2-ardb+git@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 13:27:35 +0000
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8EFDA40004
X-Rspam-User:
X-Stat-Signature: imdoqk961jw7on4h14kc81nqfdd5foeg
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795094857-550131
X-HE-Meta: U2FsdGVkX1/O3nsSY4V3jYsQx7mLsgu8erOeuZwyA85Cov+LcGl+F6sT3tPhOdm8I47uHOuytYyA73jhcNUztt2q7IN7k1OqKoGLdGwTLGXeTZeDGy+s+v6r/yEJJ6ogvWXqiX+/xcPG4NsgTn20PCiMZIMhq+x6DJ1cc3eD1cdoQbBkRol3Eix/x0NkWTu9Dk7FNJp3U0dkRpQiyfO/kEvzghfVNwW0yp6l8EU6OXn8eupQLspoJAoA11VL1KV+zhH2trYpeUC7Tw18YwIEnO05NyS5CPMMWOIXhnzOwcIdUAdMbH5Rx0TJhY2TWrorteONDDDDvQ3gsA8Su2qSbEE2f2AEfF8ID9ZuQFhnI4gMzZXK8Vk/YoCRushDydULeZyAPHm5oHAc6t+LnbpbOlIH1uPZ6PVslxkGi5Im6i05plhLKwknbOZflUnHMeP5Mx8TA36QT66JamnjlTmxf1XFmcK7HqA8OiH2QW0XGea5/oW+YeUaEWOMJ4KJoBrTIH+0Q8KRWehpX3CwWYqRguytQT2rnEqhIOZCZMweZMex7XX3UCNK6zqJgWoBM1mHiW8YOcIu/IjPbkrzNg/2XO8/gSsXrbhm/KL1OuQxdsVNe95Q3pAE2GU3fdkyQ7fPh9f7VJtZ/PGmW2n92Y9RlEtqY/BFi6MCzcUnGWSJIuRxgY0wTnVMD4mAiSJWXJEChvetGyUpRao0xUAn6L1pDAocs48j8cXNBuOVd9HZ+Mhv0EbbIe1gqUzOs8dvTmRAzzDXhljFs7eB5F6iB6ErNAZOqAo0rzNVVYGjDaWNNg+xpTdwEzJhdS2P+nevmNzGXAlrTAQMZH5XyFbi28mAg5mg9jNlYc8MBlgWIHA9dSB8yLm7p+ug3oeyecBgyNycM0daxKYXI70O3UPXJk+W5io8D+FczA/qm1ipy1pPu146iBQdUAeZVvdbLkXuc+m3rsiJ7TUr92Z3CvMAK6N
 IN/M2Poe
 ++aUVW9pkAKHKpEzMpfWk57h4o0u2y5TR9DnqRTJ2ezSFuD5hl16OiiJEe34vfbx90/WyWvrnDfd44cF3suV1Qdmgk3hNS6BUwRPZI04K6txGcjksHesJXnUiaHrz9YWX6PalU95Y7X4tS3gV7FXrkehXQJgq/TKqpyDx6f1fcIkCnp0r5jMuecxkjJBpRCcNAT5sRC1NFz683D9TgvcfipM6hfsbuzCQKmdZtSCxnZqAPKVqZPjYGVzWqqcmA9gtAAZi+VRp//0QdodBFLhag9NOloJt1oM4YXoxF16RD6nueAfivKtSioQHIGZqkMZf2jv8hNxNv66FaO66H6U+U7hyvj71YTpbkrcHZFpbueWVOEbCd+pwnK3CuYzrPDcPBnv8sN3+1U1RaRJXXhZHoCpVeR4MnTj8lpefxrp+IT9vPbxAkQn+3PUgBPGHcDm4oQ1sBdZFwI7w0zGZA7jOhRjzXyJONBZwiJrwT/yjEX7PqG8MJta5OsML9FvxR8k/m7Ku0dKKGNd5aVX3AWarQnGJt0XFLg42tGuhIBkNMLGtXImKM0EMLgp92NzjqdT+jM3IfVYig9N7npPUu2gR26snNC6Bm7dikYFPVwHuhEpJ8IFqACgUQKij6KLnnIEUtLl0bctDoNba5tHPXHf5LsE3wdLaNJmmZNvza1hwIrAALT15abriO7J7hMtg/25+VdhsgkaZfLLk+5z0SZIpYlChsTpUJgCHiCW1AMEBO7sm5yPAvdn7i20Cdisjas2OTWVIJIjTDBGR5csHQeliAVznmQNyJ6Ef8kBVPV0NLWShRiNbUuUMlCxs9rOx/LbNmIszeSQq6+OZLtChse3H976HZHMTEwVW5wz7srOsTBOEhE+XfH7GAohl0SNlQGEUe0KDplFGOVhTJ+aS/v/kKXZg6I+asvL75b1h
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [High] alloc_tag: SECTION_START() and SECTION_STOP() fail to expand
  macro argument
- [Low] alloc_tag: missing Fixes: trailer for unprefixed alloc_tags
  section name
--

commit 933587991e6a16ab600445b22347397f80335de9
Author: Ard Biesheuvel <ardb@kernel.org>

> alloc_tag: Use __ prefixed ELF section names
>
> The compiler will emit static relocations related to a section .foo into
> a separate section called .rela.foo, i.e., it just appends the section
> name to the string ".rela"
>
> When section names start with . or __, this results in relocation
> section names that are correctly matched by the various pattern rules in
> the various linker scripts across the tree.
>
> Without any such leading delimiter, it may lead to spurious warnings
> such as
>
>   >> ld: warning: orphan section `.relaalloc_tags' from `init/main.o' bei=
ng placed in section `.rela.dyn'
>      ld: warning: dot moved backwards before `.rela.dyn'
>      ld: .tmp_vmlinux1: section `.rela.dyn' can't be allocated in segment=
 1
>
> Fix this by renaming the section to __alloc_tags. While at it, tweak the
> headers so that the definition of the name appears only a single time.
>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Kent Overstreet <kent.overstreet@linux.dev>
> Cc: Hao Ge <hao.ge@linux.dev>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

[Severity: Low]
This fixes the unprefixed alloc_tags section name.  Should it include:

  Fixes: 22d407b164ff ("lib: add allocation tagging support for memory allo=
cation profiling")

> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> index e9b70268eacb0..00a68ab0c409a 100644
> --- a/mm/alloc_tag.c
> +++ b/mm/alloc_tag.c
> @@ -26,8 +26,8 @@
> =20
>  #define ALLOCINFO_FILE_NAME		"allocinfo"
>  #define MODULE_ALLOC_TAG_VMAP_SIZE	(100000UL * sizeof(struct alloc_tag))
> -#define SECTION_START(NAME)		(CODETAG_SECTION_START_PREFIX NAME)
> -#define SECTION_STOP(NAME)		(CODETAG_SECTION_STOP_PREFIX NAME)
> +#define SECTION_START(NAME)		(CODETAG_SECTION_START_PREFIX #NAME)
> +#define SECTION_STOP(NAME)		(CODETAG_SECTION_STOP_PREFIX #NAME)

[Severity: High]
Does #NAME in SECTION_START() and SECTION_STOP() stringify the macro name
"ALLOC_TAG_SECTION_NAME" instead of expanding it to "__alloc_tags"?

In alloc_tag_sec_init(), kallsyms_lookup_name() will look up
"__start_ALLOC_TAG_SECTION_NAME" and "__stop_ALLOC_TAG_SECTION_NAME"
instead of "__start___alloc_tags" and "__stop___alloc_tags", returning 0
for both.  When compressed page allocation profiling is enabled
(sysctl.vm.mem_profiling=3D1,compressed), kernel_tags.count remains 0,
causing idx_to_ref() and ref_to_idx() to misclassify built-in kernel tags
as module tags and dereference an invalid module_tags.first_tag pointer on
page allocation or free.

Using __stringify(NAME) instead of #NAME would expand the argument first.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118132719.6324=
51-2-ardb+git@google.com?part=3D1

