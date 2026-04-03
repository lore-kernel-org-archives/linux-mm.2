Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D822BE7E36C
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 11:29:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F2F36B008C; Fri,  3 Apr 2026 07:29:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A2FF6B0092; Fri,  3 Apr 2026 07:29:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E0566B0093; Fri,  3 Apr 2026 07:29:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2F6576B008C
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 07:29:15 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CB6AC8C011
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 11:29:14 +0000 (UTC)
X-FDA: 84617023428.15.EA49A53
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3B8BD1C0007
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 11:29:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gU5ih5qs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775215753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KzZY8L8j+iM3cPq/I7dLv2ptABG2XRsTCwTxzvY2IeA=;
	b=wErknyReWiCTWxvDumeGwDLsbyDwhcgmXKzmrcUe4OrLTEWMmqxSyPyeZaVBiO8yk9nw7+
	9NwtC1mPxVn7aYkpbdrBefVItEGWY5A+gqrZQN7gw7+YWFhQ9x+yMQEbDD6JRNTyoXxLPU
	ALNQ3Jd6J2VWy8ewPafP+MschlC8ckU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775215753; a=rsa-sha256;
	cv=none;
	b=evLZ++rXpZYlwgErGAh6foDC/C+pfWK6PnEgc0QVQk5nsnCJLMKNR4HH6zVML1CyPwalH4
	nTPr3maiiR96FGSfUKO9bpjW17klgLO0n+cAbpWaVVaKBxasftHp1tjuZ5x47MQnp3riIu
	KE7G8sexgTBrh5h12gb85mAW2gHKzEs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gU5ih5qs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A79D260008;
	Fri,  3 Apr 2026 11:29:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20139C4CEF7;
	Fri,  3 Apr 2026 11:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775215752;
	bh=iE9kV0f3BkfaTSJVskz3DMLc2zztbYk8PO5i/0ZBG9w=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=gU5ih5qsMO7SmY/P80P2pCZSA3Ljhr1wgGtOkuXRGDoq+rIz+QcjTSlK/sPrEsKCm
	 oUL1goaNVxqbB4MMLX6uhuNJZfpz6RzoX3T5bn4RqecI2ztDVlbm9faKl3jI+Pdp1s
	 eC1QyUQOoK9P3iGg7daPKtkTPBmsX4p6HZwM93ETSmtNunlKFMB+4TP1u6mkuFVyIk
	 e9xcN65pIQFA3w+isBLRUffhruy8GD2yLh9kdmTEJyI+0odbknXoz6nNhaii8KOtjj
	 Zq7R9XrNn4LTkoGTTBbB+bDTaBRT0QYPk4ZB3QNlqmyenTSj2bf1sEpBJS67MaPF3a
	 Y8RhyYHey0ZlA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Graf <graf@amazon.com>,  Mike Rapoport <rppt@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush Yadav
 <pratyush@kernel.org>,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org,  usama.arif@linux.dev,
  SeongJae Park <sj@kernel.org>,  kernel-team@meta.com
Subject: Re: [PATCH v9 5/6] kho: kexec-metadata: track previous kernel chain
In-Reply-To: <20260316-kho-v9-5-ed6dcd951988@debian.org> (Breno Leitao's
	message of "Mon, 16 Mar 2026 04:54:35 -0700")
References: <20260316-kho-v9-0-ed6dcd951988@debian.org>
	<20260316-kho-v9-5-ed6dcd951988@debian.org>
Date: Fri, 03 Apr 2026 11:29:08 +0000
Message-ID: <2vxzika8cmez.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 3B8BD1C0007
X-Stat-Signature: 7euxmssm84835zg8z7aebzzbe8rnif4u
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775215753-911293
X-HE-Meta: U2FsdGVkX19AejNrdpTMa2P9CkiGlTdBH3Nh619hQJdSI/u5foqruudgAL/XPDKMyZIZyLRoKJ0F1YNzRGTxdD9wJNhV6Y38F6KVVm+VYjoBcoOi5SSPKnEv4I/PJGkSxgoFNOfda5BOY0GNmplgsXF0XEkZnLd/fhBCSYzd67og9IidI3houyodCYJmiDMtbaIWUuanY2NX2FRmXjA1BqqttsWcmdf0jtZcJZD5uBG8yrJyHJk/yqjkHcB8gCNZ/PQDRxEeuydy+WCDzL5QELG27uYMnmg9Cz5Nywm9iMVBBSvaQ+uUi2bcl5LbUAK9s8P4VZNRkkp/OpA+4I22+wN0sS5DbcyLsuYxA+TyRVK1CUibaD2O1qsT7T5zR3kFc4OcQMtXZY4DP206/JnElc3WuFCcuRvXEBbBA2EEuj+EQ3euk9iZizfeMiVzOmxhQywj3Vi/+Ac+/epuWhrKHPcADThAifplog495Jb3zPAg8cUByO6YdaufzKCvcN9n7BsdCq8c3+ODjlRgtD7BbAyHEDzI4OGG2MksQgJ6G1g6Hc2R/Oa756zTPINZHOjNlxQ8li40/x/e79b6NqRZjGK++IM8h9wA4bLlEfmjj5UtFBDgRCbh5eAeyy90tXWzPNXE7dITEiIZpCEzITMJNZ1vlVUeCh4ApCNN+70s+y5nRDssKie6wrsvdtu3N5QCJDRBCPAhi8blIeGBxPYev9lX4rmbqMoAmOapif5y0kPGlQlrEvQthJIltGjYbeBCbRg+5Y4aNJIdoIsm3mzBEWuZoqIMxA27gz2mjuRCm+Po5v830zsb4ve9vzSeiikybH1hWjE65h55kbXCfvPhTHrb3BR4gX2xRDv1cOCqK6i2dZXrpsteWLJ9IiEppEsXhrlV/qsQM01DtZrR4S5zPu4SDZVv7TVeF7z//JolsHCAk3DEN5oNPToY4I2S+ShhdDwAh5M2uqAHAzlB14V
 u/TLNtJK
 RS3LDp2uKuMyf+f/q4nWpSv67eFzrDrm6ELUgiR9BI2HWdHKJyIZCed5tuyL6u7nhhygnb3y+D4PQVmyft9mswdpAMYu/q7EVUk/Vhnj1dQM6h4leXVJoeO+IyNRPyFJekIGnBbHU+t2hw1fmph+smNRrYZccYLWbYeyUMkh/Idq1SDGTyQ7pgAGL68Apd2g44XDMiJ2aE3qq8gpFpqhuHlG6dw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16 2026, Breno Leitao wrote:

> Use Kexec Handover (KHO) to pass the previous kernel's version string
> and the number of kexec reboots since the last cold boot to the next
> kernel, and print it at boot time.
>
> Example output:
>     [    0.000000] KHO: exec from: 6.19.0-rc4-next-20260107 (count 1)
>
> Motivation
> ==========
>
> Bugs that only reproduce when kexecing from specific kernel versions
> are difficult to diagnose. These issues occur when a buggy kernel
> kexecs into a new kernel, with the bug manifesting only in the second
> kernel.
>
> Recent examples include the following commits:
>
>  * commit eb2266312507 ("x86/boot: Fix page table access in
>    5-level to 4-level paging transition")
>  * commit 77d48d39e991 ("efistub/tpm: Use ACPI reclaim memory
>    for event log to avoid corruption")
>  * commit 64b45dd46e15 ("x86/efi: skip memattr table on kexec
>    boot")
>
> As kexec-based reboots become more common, these version-dependent bugs
> are appearing more frequently. At scale, correlating crashes to the
> previous kernel version is challenging, especially when issues only
> occur in specific transition scenarios.
>
> Implementation
> ==============
>
> The kexec metadata is stored as a plain C struct (struct kho_kexec_metadata)
> rather than FDT format, for simplicity and direct field access. It is
> registered via kho_add_subtree() as a separate subtree, keeping it
> independent from the core KHO ABI. This design choice:
>
>  - Keeps the core KHO ABI minimal and stable
>  - Allows the metadata format to evolve independently
>  - Avoids requiring version bumps for all KHO consumers (LUO, etc.)
>    when the metadata format changes
>
> The struct kho_kexec_metadata contains two fields:
>  - previous_release: The kernel version that initiated the kexec
>  - kexec_count: Number of kexec boots since last cold boot
>
> On cold boot, kexec_count starts at 0 and increments with each kexec.
> The count helps identify issues that only manifest after multiple
> consecutive kexec reboots.
>
> Acked-by: SeongJae Park <sj@kernel.org>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Breno Leitao <leitao@debian.org>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

