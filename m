Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0A29606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 11:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eXNl9UgX
Received: by kanga.kvack.org (Postfix)
	id BC21F6B0919; Thu, 22 Oct 2026 07:48:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6C4E6B091C; Thu, 22 Oct 2026 07:48:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA8716B091D; Thu, 22 Oct 2026 07:48:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 82ADC6B0919
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 07:48:39 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0FAD114077C
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 11:48:39 +0000 (UTC)
X-FDA: 85350089958.07.977A137
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 650F920006
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 11:48:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eXNl9UgX;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792669717;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fYtWczY6+nefmccGK2Ww6cM9jNHPdU6a3MtaqH2s/tk=;
	b=SWBxCbnSBCVA/h4ZPhAnO7KXJ1G5ZqGELkcgQgAiy1kJnky/yP/YrK6jrBPjzxtpy1Nhmj
	+dvwd6TWpUOMqV1tdmELSmLXdVDPaE3NWM1l5t1DGUBhluAy+srcEHD0WY8Z5V+BhXUuQa
	xA4nDeVoMeO/cq0akFq/BcBquLIKb+c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792669717;
	b=mI8jbN8WLoIDJzF5Ror14jlThbjNMLPwCGUN0rxiN5RZJ5+5ImkHyNW4O31fNZcOTfgmld
	5+ozPzIjaSODNqdx/nKK/geCURDBXLEDUom9TgudgOdG3aMdFGhQKy41aQj8BT2xMRQ14Q
	XvyTlL4ELKenCs5zG6AoA/ahaFdpSkw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eXNl9UgX;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A80554148D;
	Thu, 22 Oct 2026 11:48:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D95D61F000C4;
	Thu, 22 Oct 2026 11:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792669716;
	bh=fYtWczY6+nefmccGK2Ww6cM9jNHPdU6a3MtaqH2s/tk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eXNl9UgXjh70gOzaICYY8hQyQPuLH7lJbja/7BOdT2zAL+7swuShx9zFitNnWC6Wl
	 vbGM4P8AyMy7U3KmZs/aBITrAQXotVSHWJYv7NHQUDRUN4cOazXZKKFfm73JmPnZAS
	 Hzgksh3w6N/PBFB4A5JrtdlWz6QVfho101ktnac+bnYfvRVIuPYFTB7hmOPFiriPM8
	 hf49u8b0J2+0kaUBFt7W7XMHU7XaZVS0mOLU76AMkG9q4NO9zBMj89lh4ETaXPCiQy
	 QJElu4cKjtJ2aTlJESbkT/S6Bbf+tmeQiQgz8BjlhYoUfG8fOXsjjogDnsPWp2JBMj
	 eGyN4Ir+wG0TQ==
Message-ID: <sashiko-outbox-181383@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH slab/for-next 02/14] lib/maple_tree: specify
 SLAB_MAY_ACCOUNT for maple_node cache
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?SGFycnkgWW9vIChNZXRhKQ==?= <harry@kernel.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Michal
 Hocko" <mhocko@kernel.org>, "Shakeel Butt" <shakeel.butt@linux.dev>, "Roman
 Gushchin" <roman.gushchin@linux.dev>
Cc: "Hao Li" <hao.li@linux.dev>, "Christoph Lameter" <cl@gentwo.org>, "David
 Rientjes" <rientjes@google.com>, "Muchun Song" <muchun.song@linux.dev>, "Hao
 Ge" <hao.ge@linux.dev>, "Pedro Falcato" <pfalcato@suse.de>, linux-mm@kvack.org, kernel-team@meta.com, "Liam
 R. Howlett" <liam@infradead.org>, "Alice Ryhl" <aliceryhl@google.com>, "Andrew
 Ballance" <andrewjballance@gmail.com>
In-Reply-To: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-2-096800aa3330@kernel.org>
References: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-0-096800aa3330@kernel.org>
 <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-2-096800aa3330@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 11:48:35 +0000
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 650F920006
X-Stat-Signature: adxsddn3c5r4779i5jbmose75j36zj14
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792669717-595082
X-HE-Meta: U2FsdGVkX1+CABmYpGw0sgEUFFh/+9rASc59R8TS6XVGLMByzF/AGNG64NN0FpqjDeOeYQA+9qwyGhztibyP5MmIRRRcYsoSguFpWsteVYagTFG5y49IjpmHFXzyJUQDIJH5EPFa7WUz6N5ifUHengZQ4//Qc1fG7YxmRMEvSnOgcTEvXUdEZIXa51E+Lr0sEmxUdi8mYCeKM8GMWJShJ0TZthQpzmgQKhP+S5iK8i5/qtDegbGkekGfsHn3rpWIKGA50oqKK3UJW9h97Vas2q3P/0uTJSWH4xomXyq0nZbbE6ghzdpW4CSp7cn6LOa9kK8Dm4SEBa+8+oJKtt3DmiqOotMdL4D3U2Jmlvt6VdwojvFt5nq7crHie4PNQ/CProojccayr68sPxN8KcTG1oDAVgo6+t8coexKl84VQcvK0F+B1qUt4vkfPfr6Ur3PvN0OAFxRmQSik8fMmMnWpIChT2EHEMnAiggb/Surd1NA+CnADvKaDUQu7nKEAFR+sAGj3rx7stDrSk4MV7poBCz09RMFKZW8yykNheuJ9/DNmrc8QwwjWTcrKiB7LGT+TFykwyGWHmrhjN+w6JlP4sknShuLAapieFEjO9exDfAw6j63M4QszE+811JEneuL6tK6+YeTs9xf+TUqRvHTEUYgB6jJMVOx7gLIfmE8BnlTuaCH2n20i7y5vWkSz6UfkBImqikX4oANNsWHUKQPOO/DBRpzLQS8m9UL2lyscpOBROM7ZxxNVseCcNyOocPsokRwcAu2e/SFFrT0qdvZcYFhVIV7Xdv5fLqnfA79RfXLHMZl6OWprazzIVxBUZ19nQMXusAHEiSS2BfZZWAA7hBOEcVb4F2hE5bNqNH9+O1NfFSpC25QVQd3pYTSouysBxhrkOj8sz+zQxa2jSh1SflUnyYbTuhSjZ7rSDmLVEUQdGDGpFLjKREhx9KB+oNf6bzKtnmSaTSD9DcW3Kl
 jB2BCi2O
 G0rVaeJmYvK8VONFJuQFY/vBLgWpimMiAC31E7LFxT7GF1j5ENALMu6rpbNnuOr6lMLFHEH+5FdeEkGknLrRYyWqD+J8T1N2d4im0G+gswJYN5p2r/eHCQpxGK8DaGjel4z6kfmeI8qVpjzGlXJLVSadWBeUe/gKGVMsMW1oSEbmm7rnLWO/LoOI/bBriWYJI+XDn5SGqM6I7fzvrpFOoUPAW0XZBdT4FoUU2pEwjWtizx3xeVGInSbT9UxKvwXUXJIoc4oBUaOCFwwHWAtPskztwVP/jrGKhfOmM8WBwhsPMCkwwb08iUV7K/LATYVb2pF8NyQesF4yWzz0TWKEIWTVhnLLt5rRUzL5nEYxPLbeATFgnV6pt/34xxBIPyR3r8fF9xPPyK2OoMvJnuyd0+/Z3vGayQHCcT0iJVhd7GYRZ+SqzMna8EX9BbUy4UW53MuJwnEaSQ+El3DVzyarpXM4eC6JPWX/La0A3+OCCG7cuUn75zyLxboSOvkBURw/k8NU5tr45P1vI0O9o14EDNL7RLsiqGlC3tZ1GjOwwkh8lc+UqJeh9vlBbPf5DIRTiHwaNwlfr7PPBj6M/sQuXjmv/W5UXV4zSuNcxjvmpMWeXOL8u82gtTIQqW/ILvDX2dpeJVjnLE7yOhlDV+FkDhj2xuw/wkQj/NxORJyrpbVbn1OQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] lib/maple_tree: missing SLAB_MAY_ACCOUNT in tools/include/linux/=
slab.h
--

commit d151188bc6327587207caf458d171cfa4b32a0d5
Author: Harry Yoo (Meta) <harry@kernel.org>

lib/maple_tree: specify SLAB_MAY_ACCOUNT for maple_node cache

This commit adds SLAB_MAY_ACCOUNT to the maple_node kmem_cache creation in
maple_tree_init() so that maple tree node allocations using __GFP_ACCOUNT
can be charged to a memcg.

> diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> index 1aba6cced7130..e4794b31e5bfc 100644
> --- a/lib/maple_tree.c
> +++ b/lib/maple_tree.c
> @@ -5790,7 +5790,7 @@ void __init maple_tree_init(void)
> =20
>  	maple_node_cache =3D kmem_cache_create("maple_node",
>  			sizeof(struct maple_node), &args,
> -			SLAB_PANIC);
> +			SLAB_PANIC | SLAB_MAY_ACCOUNT);
>  }

[Severity: Medium]
Does this break the build for the userspace test suites in
tools/testing/radix-tree/, tools/testing/vma/, and tools/testing/rbtree/?

Those suites compile tools/testing/shared/maple-shim.c, which includes
tools/include/linux/slab.h and directly includes lib/maple_tree.c:

tools/testing/shared/maple-shim.c:
    #include "maple-shared.h"
    #include <linux/slab.h>

    #include "../../../lib/maple_tree.c"

However, tools/include/linux/slab.h does not define SLAB_MAY_ACCOUNT in
enum _slab_flag_bits or its SLAB_* macros:

tools/include/linux/slab.h:
    enum _slab_flag_bits {
        _SLAB_KMALLOC,
        _SLAB_HWCACHE_ALIGN,
        _SLAB_PANIC,
        _SLAB_TYPESAFE_BY_RCU,
        _SLAB_ACCOUNT,
        _SLAB_FLAGS_LAST_BIT
    };

Should SLAB_MAY_ACCOUNT also be defined in tools/include/linux/slab.h so
that maple_tree_init() continues to compile in userspace tests?

> =20
>  /**

iala

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021-memalloc-p=
rof-dont-waste-slabobj-ext-metadata-v1-0-096800aa3330@kernel.org?part=3D2

