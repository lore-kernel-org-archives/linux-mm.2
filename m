Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 487E6CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 04:23:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18CA76B009B; Wed, 17 Jun 2026 00:23:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 163D26B009D; Wed, 17 Jun 2026 00:23:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 079556B009E; Wed, 17 Jun 2026 00:23:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CFB906B009B
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 00:23:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4E3B6140325
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 04:23:44 +0000 (UTC)
X-FDA: 84888111168.28.49FA5CA
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf13.hostedemail.com (Postfix) with ESMTP id 67EE420002
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 04:23:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=C6pEfGcp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781670222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pDWfBHCIgx7ksbfZa1ubRGAaRoFfFBx7ZNK9YSokzdM=;
	b=3V1w5y8Wm45exp8EdXsIXLmaSNmUgm9TNvwqMJyYMeykUsA4TA6uLLlsPeMvRvnHmRuEyT
	CsA+f70WlrP4ah51rWKloCTbZnBH3f82Ljv8TbgxE5LR83aE/0rjClHuLlH5P9MiCsVe91
	n8R7pO4l4UdEME6cyrT6FB/V2kdpMj4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=C6pEfGcp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781670222;
	b=eOHEuVa+UrKUnB/SP3OEAwxE5gaOCt+qZhAol68r8WCnQJoCG4MTaqL8oOdjKANljADNLi
	4Ed/TNnKPH0FYdCuzC5Jrnpp95IUrLRVwY6o8OrrucpHRUC8WaH1fXSBE11oI7d4UDMozo
	+knIjk5/OzsgsVbCiZUwqEDu2cPgKUY=
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-37c64d34032so247965a91.0
        for <linux-mm@kvack.org>; Tue, 16 Jun 2026 21:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781670221; x=1782275021; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pDWfBHCIgx7ksbfZa1ubRGAaRoFfFBx7ZNK9YSokzdM=;
        b=C6pEfGcpy6rc936iEutWAHR2+ntFYjsZo2/sYSloVU0KqhN4YA4ibh+0MuqKtGfwYQ
         DM/nVSfBe25ujcHByXHkNcuXcv4f72lvKS8g1Gm7nRn5Haq85T1Fk+YsyzZqRPXD0bQg
         pTgBZpgBRKZv/cXt4QDPQNOifY35hFcKLYAOjB2n9KtoPhM1FRQcVJSEAmUFUnyCiMxE
         Fc5qdxeY2LGKqv2v3yFCFH6tPtBtf2mbi2VwLGTgJwknDVX0jyxLYFdvyXz8AD4Y+rl4
         qS8qKqcLqNiOM6nCxRuAT4RuBPtuF0dpqKOM8kpxOga8A2iIq0/4vNaR4tJ/bWbwO5sh
         SLqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781670221; x=1782275021;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pDWfBHCIgx7ksbfZa1ubRGAaRoFfFBx7ZNK9YSokzdM=;
        b=J0wcteU2UuWPBbVTJDMnD1MEqDdfNUsk4xKI9UNSdQZIjNCoUjXo1jtIYv+4bNmtqs
         cDI38e5lSWkBVMqsxIG5+Z2y7eBLn57LdHwqiq0B5x5NevY9NQ2DgKXoskqwnGYWKze0
         sTYkklHpQqOqZEVcoit/Vh/r940Dbgv44X38wYkPnDAuR1+IXy8duvTdX2yql/D9qVQG
         kUAU4jZzIpIL4ZMQQDa2uf9CftAgaw7uUDMl8AZgMvjk5kOEvmBfNPOVo8AMxTGQ/V9Q
         31w/jpKzQsFc6KIX28Ta4A/V/85aeQS9MZjtW3eYxsBa5/47d/+0eGmR9u7f9U4/3i7M
         igrQ==
X-Gm-Message-State: AOJu0Yz8D2bEUdU9aWxsdQMC0BMtdvBv+NaPfOL4DBgxKX0c7RJ/fHMV
	atWK/G7jBas/Su1rnSL2rducPmAaMbqBktXGl+ZiNrcGaFZktj0taKdE
X-Gm-Gg: AfdE7cmHKbEiRbMNNh0QBM6qnwDvhJwZ91RzCJbYokEpIjFNx4t4YXBBWQDNmFK/3Nm
	sUYwaMtuR7jKzq99QjjF6U69fY+Z9fPx9AYjbSROc9mvK2msGqPYhuY6hHdSl58V3fDvBDMSlOw
	rV10UQ3r5YcwzsekCgNuFZTJylzEfl/Iaou1IxhkC7p/qa2oH+Hv1Eu4RVpMCBM/dVIRipi1Iej
	mmG7QOKc2lZtnWEUt7Ugdt/J6Zxj+WSgOaoSXMDzxg3WVg14odWTs3M1vz1mVKKI9Cv8WyhzaAZ
	x2ya1ZjcC9xXdzyuNizc6Ad5khcl5AuJc6KrVOltZVR0ojryEMP2oKuCNlZuu0cbDCTHellGls1
	13d+5N7pMZUllb8gR0kEQTL2gjS6k6UM9sMCS4DYCsu2HDAeqJkpbCwaXqtkihA6ttI4/HE8wPp
	MZEaSM/EW6VmIndoFNdfPOxl9gVi1KQqSG6ZG+SXjGAax1bMdO/LGIu989Xsniv5pHkWy3
X-Received: by 2002:a17:90b:3ecd:b0:36a:8254:8eb1 with SMTP id 98e67ed59e1d1-37ca6a6c890mr1013456a91.6.1781670221256;
        Tue, 16 Jun 2026 21:23:41 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37ca1dab259sm689079a91.2.2026.06.16.21.23.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 21:23:40 -0700 (PDT)
Date: Wed, 17 Jun 2026 12:23:34 +0800
From: Kairui Song <ryncsn@gmail.com>
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: linux-mm@kvack.org, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	Christophe Leroy <chleroy@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	David Hildenbrand <david@kernel.org>, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, 
	Sayali Patil <sayalip@linux.ibm.com>
Subject: Re: [PATCH v3 1/3] mm, swap: make SWAPFILE_CLUSTER runtime
Message-ID: <ajIUVSWaQbFoez5Y@KASONG-MC4>
References: <cover.1781287297.git.ritesh.list@gmail.com>
 <1e8d7e4d0bb1377277ae8b6561d89fa0e048e7de.1781287297.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e8d7e4d0bb1377277ae8b6561d89fa0e048e7de.1781287297.git.ritesh.list@gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 67EE420002
X-Stat-Signature: nxxqazypknhazpgbhn76gmj7wbap1tzh
X-Rspam-User: 
X-HE-Tag: 1781670222-487133
X-HE-Meta: U2FsdGVkX197zFiflCk4bYIx/e7uFWsPtxMgnGWJpV1d5LFOXVNji9ATrazA+bAJ3bWH0uvYNs+AH+mcifcjMVcgaAG+yI9/ja3X/EZBFv/suoe/zqwo6bry1sh0c6z4agk4PYt8+IFkkkJ6PNeMWvJlCkZnc54TmlwIYwB1W3NdIbo/JfBC6KGDI8w3qXPCUgqTGUbcArbYu0lhYG0xU3m/4oOY2Ua2tIHyEE3nP7tb0TwTcyxuZ3eW8jxIf0ehUoqlsdnam25srUM1cjLYy0Shm/l1+LVV8QJrfm5xBhLm+zaIfFCYlC004tyiT4Pk/7sZBtxhVJsgvEbelTaYZED3zxdpF7Hsm2riV109OBCjOxRN5FpuP8OdY5fJxVHkJL+H5HWqyNcpxHHQsNIae7hkVBZvTvfBglChfGS2kX0nBBnn//me+37cLHyCOfgJiEEKsTRaC1VZN44ex/UY3//44v69LYnlTxRe6XHNamIKnXc0dID3ICK8HXdSl3651q/h7kgBXIt7IUGp77Ji6LWdW77IRI15Pr966eefeyDnK6LcrdXMTcdZIYZAlq2QtffTkAp+EFJwywrqqwa8nc5z1NuauuZvZ73mk6cxY3MhxgUuyboNc2sm9rtrN3FSCx59dFFw21JThYm6Lna970eJh4oQ4ELkfAew6eu0Wp1oKM3spKCWy1//0/0D/vgUfwgOiYqcvbm+aTX3ZiB9b1OAaWDEY2womqJ0G9oPpYj6ZzTK3M21xvkfiAiby5WhSNOjDQIreH7HZxC0C6fUmatkrGhRFKxazczWifTtQT1HjuEzpVbUK+7Y3F5k5hsl9D1JPqoR74waRaM4zPM01xPewou6222ELIruiQrgOTKiICG5rnnePnp8jk4KrCSJuDs/yUBqHKO17I3DX4JGxNLtJYHLOKBrPx7C/dkprftTFpJGhRXHanaJXkJiEnFOzGCx7+zR5LGqbQThbev
 EA6DeY1S
 d96Yl4VEkzXFdvaabFSx8o3RdXXw1iyFf4Z/Kr4t8Odm4Flw9JO61gQ14CzawhVqkSxKF1+saOBrAXPhjfW0yo/Ooh2RHzPsxu++45Xbe3Nk16yZ3JL3Dx4L2K/dlfRYRN2bevT8a7BTeKzqt802W4ApCTBJSyHFzdMSD6EaZPCAR3+NEAxNGzx05GZL8F05P0NPDjPA1Lli25tXS05N+9AS3LYlD6QwGF2HaYXAXvU5Zz4JKm+aCF52IxD2TuyL+hvrk21MYXak3RX0mJKN6de4KtUlCHCFOxCVnRx7ijDu2PwgFUaGjvRnQZXwWJoSr8EfORsSWJq66I58G9ZSAJjbAeHGlbt3jFZsrOExWkc+4ggZxng+szkZwxwH2H2fNTd3/kzBQ7BIQFqzCmygKytacDczu5B3/bThE6Wg97REoO9TZLPPDqHK9vzS4RMWw5njP7/9uKQKVZ7pod5yVV25HdhxYmRmx5Ed8q8uePrgGjsEqoN1ubPKooi65TV2DXnLj2Opkh5GFAWOKSZhL8Sa7kuVrb8Dbk+CNtdwiDqYg2YN7TcE/EJvXoPe4hQnLkTOtOtUumVEdgkI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 11:39:15PM +0800, Ritesh Harjani (IBM) wrote:
> On PowerPC Book3S64, MMU is selected at runtime, so macros like
> PMD_SHIFT are effectively runtime variables in the Book3S64 code. THP
> swap code uses these macros to size some of its array data structures
> based on PMD_ORDER e.g. SWAPFILE_CLUSTER macro is used for this very
> purpose.
> Hence this patch initializes SWAPFILE_CLUSTER at runtime and also
> modifies swap_table and swap_memcg_table which were earlier using this
> macro for defining the number of table entries.
> 
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> ---
>  mm/swap.h       |  5 +++--
>  mm/swap_table.h |  6 ++----
>  mm/swapfile.c   | 27 ++++++++++++++++++++++-----
>  3 files changed, 27 insertions(+), 11 deletions(-)

Hi Ritesh,

Thanks for the patch.

> 
> diff --git a/mm/swap.h b/mm/swap.h
> index 77d2d14eda42..956879a69ddd 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -26,11 +26,12 @@ extern int page_cluster;
>  #define SWAP_TABLE_HAS_ZEROFLAG		((BITS_PER_LONG - SWAP_CACHE_PFN_MARK_BITS - \
>  					  SWAP_CACHE_PFN_BITS) > SWAP_COUNT_MIN_BITS)
> 
> +extern unsigned int swap_slots_in_cluster __read_mostly;

Maybe __ro_after_init is better for this kind of use case?

> +#define SWAPFILE_CLUSTER	swap_slots_in_cluster
> +
>  #ifdef CONFIG_THP_SWAP
> -#define SWAPFILE_CLUSTER	HPAGE_PMD_NR

So on Book3S64, HPAGE_PMD_NR is also a variable right? Then we don't really
need to change the SWAPFILE_CLUSTER defination here? We just need to adjust
the users of this macro so the build will pass?

Or maybe use another macro instead of HPAGE_PMD_NR here, whichever is
more arch friendly.

That way if that is a build time constant, all users are folded to
just one mask/shift which is super efficient especially for inline helpers,
and there are a lot of them. Only special archs live with the dynamic
load overhead.

