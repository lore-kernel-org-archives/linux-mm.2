Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4AEAC55179
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:49:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C197D6B00A7; Mon,  3 Aug 2026 09:49:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF0896B00A9; Mon,  3 Aug 2026 09:49:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2F1D6B00AA; Mon,  3 Aug 2026 09:49:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 920506B00A7
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:49:04 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 66272A1E9A
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:00:27 +0000 (UTC)
X-FDA: 85059362094.28.473C403
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id BDCB2140010
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:00:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="JX/ujSHQ";
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785747625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ENSxpDdo1N9dYuP9eJusu5IRA5To2LtlzCwfm9J0k8=;
	b=SesYUUctXlWYs+ZI2X77W/8xOdr+yTcN7mDrqIRlwbumracdJTueTRLoQ/eM2zAeyxETym
	Mwi68ynCvYDVPMm0bKP2Xd7D3AtgDvPsMn/l3CATZH65cpICY6oqmPB035DLH6tyGUHxKo
	clrKl9fXxlQu49K94FpPGhpp3sPbHt4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785747625;
	b=6XTHcTuIDVVY7Tw1qIcCbH3NQ4yT1veJnwfZ/bUX6z8KtXSU2pM6PCYJW7PXYS8QbGMchf
	Bj+oBNPqYC4OZVjfqqQAiGX9ZDGpFtupYBqgE3EntPlK3fvRSOhhFM+4wDfqD7MgCzZCYu
	n67b0FXOZ2PewQUPuw1peXmlY5xZeo4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="JX/ujSHQ";
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5E20660A67;
	Mon,  3 Aug 2026 09:00:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F561F00A3E;
	Mon,  3 Aug 2026 09:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785747625;
	bh=8ENSxpDdo1N9dYuP9eJusu5IRA5To2LtlzCwfm9J0k8=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=JX/ujSHQtZFhxEiv11F3bAOveZtfwWNeoayNGrl7Hp6JkAJDKZjfst0Uik+TL1Rmk
	 t4/5UfIBaC+rh6BMkgYdsn5Y8K14oYv7AUGwKUiVORX2FpqrFv8vfYv2E+bgTr/ID1
	 BCklATGLFSNYiw4iOU64B1INmZZPHk9ZppzQYhh3CJ2NDIz4limjSSQgmgp+jQHt1h
	 pOpOBoZVsrqUPSZcYWSToMR+4umnRxavcFaw4TEzOnSF1qvdBKoBJewyHdAr3M0AoV
	 KgcG0h/fbtCVnGfA+gwCSAWdX7ZQ/GmkOBC0pEme/3HVISDzKugKYoTSDRwtJqDYOo
	 9MfXeoGKzrU9A==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v6 2/6] tools/lib/mm: add shared file helpers
From: Mike Rapoport <rppt@kernel.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Leon Romanovsky <leon@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, Mark Brown <broonie@kernel.org>, 
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260730140825.238130-3-sarthak.sharma@arm.com>
References: <20260730140825.238130-1-sarthak.sharma@arm.com>
 <20260730140825.238130-3-sarthak.sharma@arm.com>
Date: Mon, 03 Aug 2026 12:00:01 +0300
Message-Id: <178574760161.1561566.15822401997260524037.b4-review@b4>
X-Mailer: b4 0.16-dev
X-Rspamd-Queue-Id: BDCB2140010
X-Stat-Signature: pbcqgtqu1c3zafqy1dwsmgtkqkgszap3
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785747625-797977
X-HE-Meta: U2FsdGVkX18OyX7l+X4Z/XyJ6JddwSVRvlb470yIvk69xR3/ttoEozAoBtH2q+g5pWnRuJIwFgxdS33i4+vs/OpC5DZMenOBNOHjcrxM4hLeoc0QvLhk6osR6tyurwFFBjg5NNI2oSJAtZgszh8L5XUUx+XN0d+Jef63Qnlpg0VJgdIkg3aY0AWZftay6en8jkBNdOIgkEedw/o6QXMTPUwx18QDDfbfV6wjBebpceWjD5xBxzKt0QC2KHfse9ORwfhcf0QFq5oXRIjN1fYu9CEnx6Mxtn/LwY3ww5UG1VwGjwGO57TTyGshf01RqtrHB7Y30aVJB+uPrgTTg+5YPl8JwqgvASDebux0AGvmvBWoE6RN9J7BfMIbFc6+k4mn9jFozvvwxUoL9lLWRBT/McmXnWPJTh9HHdhagpJxwvS9hGJh9a2S03fMGeXlF0+ja0rh+4xpc4UOC9QMDboUbQkxgg37Tl612u45fWTNY9jGfC4XYQqpAnrAd5j3mrf5fqNPz2c8AfhSlwTmcYOlkxr3mi3hKsmaNTH9ZwlKhnvTQ8rJhUcYFO/jOZ6OP0/UGYTVc7Y6YW58XcUvMfry45iErzTNKLCrawri3Ab3CF2vWYvonUkMC96pl9n0AeL263q/PCuLioefGcwr2K19ecfKWdBJ8hibHFFcKQ1o5/1kdUKMnJJrEA7uMgHmZb0LA71FyJPN2yaDeJK6E1asr66sxl8Ks96pPbPI8A8DUW8nWCgH/O/gSm6FL41Q46GP7PnKoYTYpwKHs0rdMQQRCxsc1BuOC0bJqgGkjOk3vFtMAnQ+oXB0pLfcYsNilGVI99RLQ20e9bpNMSY+c51ELPKg+kijuY7hKF4rRP6jAvV9s2ctU6S7Ovrzj1xtGGpG74db/6LY7NdULcFAiyuR66nvC0p5Y3iLB5OCH6zkyk0mlnwX8tBfseARF+0U7Fi3WwatbaxbPZtg8oEGLFO
 34wu+fxw
 bUEZEM3hFQcnkEeyVLYEne/GxcHw/17taKy+VFCkls+4zxUTwKSgzkUqCbtOQvS2pBMkALEF/dULI9A8R7yozKTcAmGiRmcS6LOUsv51Bj2x7W5PVkkNC1A9qM/uomEu0rY7op/CJDhpV8UbJ7WouBcRv6MT0c++8U6zpUT73Rd4CZnlQj13PZpLo18bquRFPCf8xwZ3Ew/VY6AnDpRuTt1VDcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Move read_file(), write_file(), read_num(), and write_num() out of
> tools/testing/selftests/mm/vm_util.c into a new shared helper under
> tools/lib/mm/.
> 
> @@ -187,8 +188,8 @@ TEST_FILES += write_hugetlb_memory.sh
>  
>  include ../lib.mk
>  
> -$(TEST_GEN_PROGS): vm_util.c hugepage_settings.c
> -$(TEST_GEN_FILES): vm_util.c hugepage_settings.c
> +$(TEST_GEN_PROGS): vm_util.c hugepage_settings.c $(top_srcdir)/tools/lib/mm/file_utils.c
> +$(TEST_GEN_FILES): vm_util.c hugepage_settings.c $(top_srcdir)/tools/lib/mm/file_utils.c

I was too lazy to change the Makefile, but we should do something to
compile those once and link to every TEST_PROG that uses them.

-- 
Sincerely yours,
Mike.


