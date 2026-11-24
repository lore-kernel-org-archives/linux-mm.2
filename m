Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 312FE606A321
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kS2U9cG5
Received: by kanga.kvack.org (Postfix)
	id 074E66B0736; Tue, 24 Nov 2026 10:00:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04CA36B0737; Tue, 24 Nov 2026 10:00:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECB7D6B0738; Tue, 24 Nov 2026 10:00:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CF84C6B0736
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:00:52 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 592D11C46EF
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:00:52 +0000 (UTC)
X-FDA: 85470324744.19.6AE9A1A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 581C3140012
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:00:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kS2U9cG5;
	spf=pass (imf26.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795532450;
	b=umOz3SEE+iXJ99BadcYTAV50jOHfxF8p3861pnYG2plej/GoRwSMxgewyzBiRkeOnh1wwW
	VOveS4TL5/7z6NUMpMCJTlyji4UgVMXVn/udYWEUIAnLhIrWttwJknwhq4msQjBw5rXEwU
	hgCqI6yOnez7yDq2B6OKCEB1n+wWh74=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795532450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b67nSDSKlbaduyToerD8/iZoRWrb26B2Xt6ysm6DMx8=;
	b=PzjKleESCoXNvHr7bO/bWVj5q5EMeecRuzJQIb9wI1yUktPlvFjHlj6ZfHRiZvuIPQPQbD
	MPcNBgOxsKbH1/uBFzx3+HH6In5nKNRiU7NSj5iLiWUSizQiiPTQT6RsgCfFIJ60jG6fg7
	9WftsQcMqUfKY8qtQyA5jc1OXeI4jDE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kS2U9cG5;
	spf=pass (imf26.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C1E9D40BEF;
	Tue, 24 Nov 2026 15:00:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59C011F000C6;
	Tue, 24 Nov 2026 15:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795532448;
	bh=b67nSDSKlbaduyToerD8/iZoRWrb26B2Xt6ysm6DMx8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=kS2U9cG5k3BNOeM1o/Yw8hJGE4Ji6v4sydxvExS7m9RLqCcI+DPL31/kMICv4OPKV
	 vT6X/Ojuj4/KkoVQe8jcYVfNoTAVTh9kzW/ZHIfxij2EjaVjkstoeTjJ1vJ/7Byj6H
	 yBLe/IthXY52U3iCM7C+3lx8RJSOjU5X6E7XjPTPNIzWzB1wQspciUisUpVJvuYuPp
	 bl3gy2gLxsc9Sz7KjRuViLZqHHCiZ6Y4dIq3512Ho7+NK8XI6KIVe9EX60TRMjbi/V
	 4S8e9Qa4TowZySUM/kgljM4hQKMHkrgmNlb+xWbNjcUW5XXqslgi+4ezi23RvsYDVH
	 ZJOzpag+LIKeg==
From: Pratyush Yadav <pratyush@kernel.org>
To: "Srivatsa S. Bhat (Microsoft)" <srivatsa@csail.mit.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Baoquan He
 <baoquan.he@linux.dev>,  Mike Rapoport <rppt@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Pratyush Yadav <pratyush@kernel.org>,
  Alexander Graf <graf@amazon.com>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] MAINTAINERS: Add missing files to KEXEC and KHO
 subsystems
In-Reply-To: <20261124-fix-kexec-kdump-maintainers-v1-1-79c6a6144de4@csail.mit.edu>
	(Srivatsa S. Bhat's message of "Tue, 24 Nov 2026 01:37:53 +0530")
References: <20261124-fix-kexec-kdump-maintainers-v1-0-79c6a6144de4@csail.mit.edu>
	<20261124-fix-kexec-kdump-maintainers-v1-1-79c6a6144de4@csail.mit.edu>
Date: Tue, 24 Nov 2026 15:00:44 +0000
Message-ID: <2vxzfqwqz337.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 581C3140012
X-Stat-Signature: rfppq554sjht5fbmamynwcwz17zwyqfw
X-Rspam-User:
X-Spam-Status: No, score=-22.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1795532450-131399
X-HE-Meta: U2FsdGVkX19k5qIiZNR1lsfzHyCyKGN56Y6dI8joQPubEr/peHNNfzUCVjXaWfKDKKnxT96+0OafetKISmGKFykpdWzhwJ+kaMC91Ljo182k2GBzvLa8UNUJXGhkQNui5T8b2t4hP2/KikQX4IQ/KwskXKABfb8aM/5PnLPZknoJr56BZsXyzVJCmYzs8HNGhr97IuozsYDOr3lrHuS8s1imsWzK5/fs5LjiY1WKGrq3dmSAV7vNS7lzQJfwakTvhQQOLu1TxGrKWh/BpJG3JwGeFWSnO81iWtYf4pOl0kar3yuQYMX/YVPFCCghoUQ1nsK4aXB0NUFFUO5B8RPX+YYo1ZVv8XtDxf/lwINACSLbXtlOeQBpJl2Dek62jD7oaXrGGSNWDXq/pA8my+TXX6Ry4nKsFtiUOo2P51xqv3ieyJBJVyQz8mJjI5PK7/sKT8rb1ocDaNMyU3pXWwqo84RLHjm/HQxgateXvQiPVAO7jclkhfJB0hvYHgr9IE+TgB7HyAd9+OJB8fAgFao4UUPpFkOSB+0sEgQ6SBnF7NRSvLcAI0vPaGlEytl4OX7BwwNeAS7DQAY4TSMntihWVViYgc0iqid7kfu080YtyfL07cPlAIcgHZ9KVCmH5mOypL4UVgQiY01ntfmp1OXk907rsELoG2d+uym2xrHukXy3HMeXTD0kUeByhZJcblsCDnTlwlav57sVtCGKRpgfv2g3W14oeIQTRQha7aAMn/CKo//W8F3wjNzb//7ItmaocNrmkAdxQpBnqB1LYklJOdmyn3GKv8QWHpgp8BxAZgytKm1POIJ4SRDP1QyTZbEw7XqWeQ8/0IxZTlPUMmTdkAM+AvIsggJ17aA6+LSOrbp6OHRB46RsY/4DTuEGnQ9rQBZUia86dICuPktnxHksZVwrl8lp1ZvX/Cvaa/ZkGq+izW27N5z/w/YPh2TMD0RzzNFpgtJgoyW1Z+OhvUu
 TdxWicJk
 XGIaOK4dqX5iq+98lMumnaegRMlXhqnU2o9xAFqxwK3Ndrh9wskW9tTvKnrZCWOWMD5wr916z0rjwOnBL2a5TqlfPDHJwWxecl41oeI8sri9KWPl7Dzso5mLrhitHl+di6ydZ82Q8b+iHRPWi0OJ+xLNUZAVbYfYRlISV0AgOFFVWbc0zGojNMqUXD7TwbMwUUmVsWWlrJkQhgYskuu73tMqavM5HBFhXZ89sykgNe0T6Skls0ztxja2SQA2J/Z/RAu3YHMqWsFspwT5MOEMWme53lQ/HHUPb0a/m5sRAW1Mnik/RB6Hxb4AkYn/Hd7OSWq0GemyFfFN1KZMXMYhPawc6jVmqSrXDxLu4NkEsm66Jyg9D+RqUPA4tjh8/Q60m9mFd8ZllSjnfNCEXVfBcgpbhLiC69H8kL7WpyUQMKSBODAOa54LqQtO0qPKth8vmBe3HlqaxN8sbTBvoFVwpH9dFF7i5n+44c3iAVsuIbn7K/QMq2qH2mE+EkB4avA6KVgonXBA8k+QsO1Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24 2026, Srivatsa S. Bhat (Microsoft) wrote:

> Several files related to kexec and Kexec HandOver are missing from their
> subsystem entries in MAINTAINERS. Hence, scripts/get_maintainers.pl does
> not currently recommend the kexec maintainers or the mailing list for
> changes to OF helpers, IRQ shutdown helper, purgatory header and kexec
> selftests.
>
> Fix it by adding these files under the appropriate KEXEC or KHO entries
> while preserving the existing Device Tree, IRQ, selftest and live-update
> coverage for these files.
>
> Signed-off-by: Srivatsa S. Bhat (Microsoft) <srivatsa@csail.mit.edu>
> ---
>  MAINTAINERS | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 012a21e4afcc..bb4d9c20db06 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -14775,10 +14775,14 @@ M:	Pratyush Yadav <pratyush@kernel.org>
>  L:	kexec@lists.infradead.org
>  W:	http://kernel.org/pub/linux/utils/kernel/kexec/
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
> +F:	drivers/of/kexec.c
>  F:	include/linux/kexec.h
> +F:	include/linux/purgatory.h
>  F:	include/uapi/linux/kexec.h
>  F:	kernel/Kconfig.kexec
> +F:	kernel/irq/kexec.c
>  F:	kernel/kexec*
> +F:	tools/testing/selftests/kexec/
>  
>  KEXEC HANDOVER (KHO)
>  M:	Mike Rapoport <rppt@kernel.org>
> @@ -14791,11 +14795,14 @@ S:	Maintained
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
>  F:	Documentation/admin-guide/mm/kho.rst
>  F:	Documentation/core-api/kho/*
> +F:	drivers/of/kexec.c

Only a small part of that is KHO code, but adding it here is still fine I
think. Thanks for fixing this up!

Acked-by: Pratyush Yadav <pratyush@kernel.org>

>  F:	include/asm-generic/kexec_handover.h
>  F:	include/linux/kexec_handover.h
>  F:	include/linux/kho/
>  F:	include/linux/kho_block.h
> +F:	include/linux/kho_radix_tree.h
>  F:	kernel/liveupdate/kexec_handover*
> +F:	kernel/liveupdate/kho_block.c
>  F:	lib/test_kho.c
>  F:	tools/testing/selftests/kho/

-- 
Regards,
Pratyush Yadav

