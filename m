Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C1CF606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 17:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vmmyrz6u
Received: by kanga.kvack.org (Postfix)
	id 2DF626B05B2; Sun, 22 Nov 2026 12:00:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B6AD6B05B4; Sun, 22 Nov 2026 12:00:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CD246B05B5; Sun, 22 Nov 2026 12:00:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DE4AC6B05B2
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:00:35 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 54E24A0773
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 17:00:32 +0000 (UTC)
X-FDA: 85463368704.15.B2939D4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9E86240004
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 17:00:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vmmyrz6u;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795366830;
	b=YpLiS0fyFA5VoFQu4UurQ4aTj8CYke/KdJTVWOTPh28BFgXMl1huuiYUk2KhcnZaMXnCi3
	DJ5h59N7mfpXfWmKyS8TnuFS+8vn0ZU5WwDH48S5/y4WZG7SuIhnYmfueGa/FgTyct5Qdx
	TOLka1yRZJow61UGCaqsGn0+oRNpWmw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795366830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uEqI+Hp2ezJcINVPIUjY03p8JSLOYnYNaqnNBkjZ3rE=;
	b=HsnGqLy+nLaggdxcwIK5DG4+AAu2jmbTPtmj1UB+VN4jwa03+1s4ojn4aQauU3pRZO8Ba1
	oaNmOhs2soCzLtZtQQBAf2F5SYS+8SZQnAjGLWflVBkmg6xBBH46pZqQ1a8zO/qQQ3Plhp
	wa6A9W/kcKCeE04eltOrJ0gdlP3QXMw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vmmyrz6u;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5ACE361120;
	Sun, 22 Nov 2026 17:00:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB0C71F000C0;
	Sun, 22 Nov 2026 17:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795366829;
	bh=uEqI+Hp2ezJcINVPIUjY03p8JSLOYnYNaqnNBkjZ3rE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Vmmyrz6uK/hYFVidaN2kK+me23a5dUvyk0Op1qeTqHLVqOB88p979QDWelJLt4iap
	 Q1sC8F5zSKZsnUF8J+6xDtlQUU5jID1AtgIYKPRDH4joDHKoOdZ9Z0UEKeZAtS4hQx
	 yvEnCcbrfkkVFn4UA1Xad0pMG9ZT2em9iF5BDDR36qpKsYiSWqPFlFM2EpWLlPWNni
	 AFqo/CI+7GxHabb1n9Gz8W7wZ8CkJ7YkvELRNntoSdhJ45I8dnGf7IW2mmXqth+sBq
	 QNCUJ+JztoZssg7tPc2aSRqkemJ25EJPdIv0x9dG+NYWgEVGBcV1LmZgxEIEXdKLDK
	 1svDrLaa66c8A==
From: David Hildenbrand <david@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Peter Xu <peterx@redhat.com>, Konstantin Khorenko <khorenko@virtuozzo.com>
Cc: Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org, 
 =?utf-8?q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Shuah Khan <shuah@kernel.org>, 
 linux-kselftest@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, 
 stable@vger.kernel.org, "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
 Sashiko <sashiko-bot@kernel.org>
In-Reply-To: <20261119-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v6-0-efa7817a2bb3@virtuozzo.com>
References: <20261119-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v6-0-efa7817a2bb3@virtuozzo.com>
Subject: Re: (subset) [PATCH v6 0/4] mm/huge_memory: copy PMDs at fork like
 the PTE path does
Message-Id: <179536682240.11318.5673184071692513568.b4-ty@b4>
Date: Sun, 22 Nov 2026 18:00:22 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspam-User:
X-Rspamd-Queue-Id: 9E86240004
X-Stat-Signature: hd1dtcu1rro4gosimp8pzgpsg3dz9s9o
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1795366830-784706
X-HE-Meta: U2FsdGVkX19znZuckRvP3yHBavmKJd4bKwsvNg4s1s9smZVugCTkxcTCYPLrJgZPAnRC6ZQ52GAnO95vxWlJlGg8wK3aOYSecE41RQBdeCwgRS4JFb2AbeCA+rwvP3G+ds7G5tZbRUAaaLlMBqfGVEjju9KLuyKLnDHlsE0BAXV8b/27R2NL310rJNpvcl9iB+rCapRTq9WBQMd6yGmo+mndnTVQRIjdptasYprogiXrHqmBMpbn2T5sCXLQobsfkuVwvwU6VzGPF/XJHzTLCTjDMCKUUgDbFsPnR3+lUq58djFiAu1QHOpLolUSOJv4jjjDycYOUaR5gsVrZzzhAcrZqgtcN2vclmWDR5J8tK6ghAgj7DeC4ExX/gVeilz+CiSkR6y3TJ2BHKXltO/L5urs87X0rgtLEesug5T4VZfNSdveMTaLDlOWluIWyu7SD/CGMTLj/o3OE01D7aUl77qPhMkJe00dIip/jDdsmhiWy/6Vqyrq5+HVWQORQ4Z2TfTzJSAF+kydOuFzxr7MAsI1EOlH7cMym6jtOypEZ+1PL25VBY7qh0QvwGYaD4U3HFkaBdedEEdOYLb6KKKn+l5y7AR7RuNRGE3ERhCg65eb6elxIIIt1UKM2atoyEcy5lOJO0JQgEYRQO3MumDnOYZ9WUBTbWSfofTCXJqLFHL8ghlouQypMcyrBbzX9NVFOJeCOVJhP5fJXmQoU8t/r0EiOKsroYLUZ3l4mCYyajuD1E+cgfawh5o5GHjmuquiB2+XSaM9mJ/BIzr4DzO2NpPZr5nOQK9I+SiGKVwIK6Tah9akRg96lVrFYVWaluKsO0Z6l2B7GwbbAv9Y2SVqlnVerDX6W1AeRAZmwRnlmY9Cj1x/ZX5pnaMNB5OM1P8jC2+iXjpzuzqs9nDoYf+fKSAdHGdpgTeMWlPCe1GPdnGx7ZDPvmTAHUSW3PUa+m8c25AReHYNw9WFCBMF+T4
 H+9jgxDB
 BRJc8+3PqdV3tPKG88OuzJJ6/sJAaJqXLtmEGa5XTRch0E0m0cZ/RMvJ5Gw80S2Q6GMIqxxzxMAEDqsZlYq9BbIp1WRGrkG8HE8jT9uLTKooraxZFCSA+hpzh5C5gDoNcvPw5lSpu1f8dJ+ueLMsGQAktdcDcahE6mBUGgMgmhwPqGMx8pOyaDiPcyojXkA4z1hiynQgn8JFSMqTODPiwKQxvL6o01hbtlXnBrK6zJhL2Lf7+VdKKFFROi4ksIB+54xjVL4dGQgH91sHTqn67akVLoUo3hB7so1cMtJpLSrUNAqYYdAEClR8o6/QWsKbW6hplTvgGJy1pc7AlEgA2odkieEUJbWJodO/20RFYqC6HQDaCKOe9oul6zYq7N/lUCO7WpufSKXQRSj18lgoGjJcrsbEIq64dE9D6nQ7+7egL06xRqu7Dvn9a8CNNESEYkVe01wBM2SBX5Ft4wGMB1aQ4zxJ4logUMQ45DDZAmCXPVU/Y4teyGTTD2nS/iOcUsFl9ATlFrPhXzl+rxzthY8QNbobqOxiGNMDcvo9IEmq3bFCXa63cgsXBgl5jgHDXoyTlJA1GhykYbkDiCZCeKrBPdw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 19 Nov 2026 14:44:01 +0100, Konstantin Khorenko wrote:
> v6 is rebased onto mm/core for-next, as David asked, and patch 2 was
> finished on the way: it now checks the page cache refcount limit before
> it copies a file folio, as copy_present_ptes() and copy_huge_pud() do
> since the refcount overflow fixes. So patch 2 changed after the
> Reviewed-by tags it carries.
> 
> copy_huge_pmd() decides what to copy at fork by its own rules, apart
> from copy_present_ptes(): a lockless check for special PMDs, and a skip
> of every file THP. Following David's review of v3, this series makes it
> decide the way the PTE path does, under the page table lock, with
> vm_normal_page_pmd(). That fixes the two bugs v1-v3 were about. The
> patches:
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: thp-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/4] mm/rmap: duplicate a PMD mapping as one in folio_dup_file_rmap_pmd()
      https://git.kernel.org/mm/core/c/4d47d354
[2/4] mm/huge_memory: copy file THPs at fork like copy_present_ptes() does
      https://git.kernel.org/mm/core/c/e21c5cf9
[3/4] mm/huge_memory: read a special PMD under the lock in copy_huge_pmd()
      https://git.kernel.org/mm/core/c/39b0669b

-- 
Cheers,

David


