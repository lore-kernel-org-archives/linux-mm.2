Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6944F606A323
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 15:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MoupP81X
Received: by kanga.kvack.org (Postfix)
	id 86D8D6B05B9; Sat, 14 Nov 2026 10:07:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81EAA6B05BB; Sat, 14 Nov 2026 10:07:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 734D36B05BC; Sat, 14 Nov 2026 10:07:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 539886B05B9
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 10:07:21 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CC017120431
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:07:20 +0000 (UTC)
X-FDA: 85434053040.19.FAF0C48
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4648AC000C
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:07:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MoupP81X;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794668839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ILj94+WskYmEK4Z/53i495F3j5ydMt0bfq/GRWV5o3k=;
	b=JAth2JzFCnLUrXaqdZH57phjM6Nt4AnfFfMS1wjhuYptN7yjazp5B5HY+7mKJ/amAO/QT6
	QoKb/mt05CsnZZX8f2halY4Be7gICZMLGaxAC3nikmm9TsgsIMVusm4kqzNgmkFCi9YrUB
	Agekj1hCAKXYuEEt9oVmSWU/YaeTPqI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794668839;
	b=ygFFtSCfAHCHWK9Q9Ms+gDfwnb25fGqkT+1jaqiJ09BXXJxEeP2IeE5r7rtv17/raHngjf
	26LxKhAPMhDAJ1RMuyA2syO5g3+/QxT7f83lT2zxnnyxDzwMesA/AJJUx4+JU7aH2xSOQB
	ZzCr0oXVbFIFX7xYin/4+iA7bQNn9Q8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MoupP81X;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9A7B040311;
	Sat, 14 Nov 2026 15:07:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAA5D1F000C4;
	Sat, 14 Nov 2026 15:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794668838;
	bh=ILj94+WskYmEK4Z/53i495F3j5ydMt0bfq/GRWV5o3k=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=MoupP81XEoZLNGgPlnJf1bBzyzyT3Soss/Ait7cAQwp66sjPOLAnZoZyNMmpLCth0
	 n51UaiVYncDWSMJnvjnGBbhWZWI0YoTeK+4XI/ttPFs5mFYeq4GM96UG2y02qRrnZt
	 QAUgqeTwa6Wgi2Nsgg/Blb/ulPi38ZNLnzg7dhh7VsnmsX16MaVjK6ja4DQBrMFRpn
	 668jKuNgUjgAhBzSSPkKeAB1Io8BRtz9y4nedxGSr1LXybl+u80S5Dv9+JnTpnnP3M
	 vlL4Y4lf3I1mIcsHJkM1wH05HvgZmYy/DNs7nUSFcN+L8s/zJaCwJhhGSHunCI/J7s
	 IUUgwUmsADyow==
From: David Hildenbrand <david@kernel.org>
To: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
 =?utf-8?q?Oscar_Alejandro_S=C3=A1nchez_Lucero?= <aleszlucero@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261112-pagewalk-doc-v1-1-6cc5ce7148da@gmail.com>
References: <20261112-pagewalk-doc-v1-1-6cc5ce7148da@gmail.com>
Subject: Re: [PATCH] mm/pagewalk: document missing struct members
Message-Id: <179466883554.4943.14548802291606306999.b4-ty@b4>
Date: Sat, 14 Nov 2026 16:07:15 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam06
X-Stat-Signature: arxsr3bsa3iizfejp96womgo4cyr4sn4
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 4648AC000C
X-Rspam-User: 
X-HE-Tag: 1794668839-773591
X-HE-Meta: U2FsdGVkX1+i3qjhnJr+GZjjsBcimaerxexemON5o+sKMxLjT7KCWyqmDrcgy4aYf6qdeuDPdr74jINex4bSxv/gI0z+HoPUiap+AauHiGRh3c0vZ0BG7otSU8kmcAErpynqCSvtZiP5Tll0Typdg3gR3eXJc1JZTbNV+HY1K2/88citvkfD4fD1kbksQOBr7Ml3IixPe2uvNaehlrI1V/Z2elQSIGypoCAk/UbpnWzr6IheO1oJjNm91zB7q28O4hlABESa5adAryxZTwGGc863sNQFOiBtQtDqOHdgs8lMFizgBBtm3dxGoKiWXjIVz/UN40EaX9GYpgnivrfvGQPxRKppemyqDjGnuYrfn8tSbL6fTjo6d2tmrR1TleyIX4gYQT/rO/jdBH+BViLFCRSCJvh9qX+Sy1DkA9Un+nFJ77S2um+FvvrThv3k8fI3+r3E5ZEsufMKdIZgzW/9+UOpxfugfqFaLtPJ8MNFhqezQr+6vwUiNlwjptFY6ZuukfQSRDqu9aTmXdgI3gkt1OsQ+TFe/Jo4Z2h+IQsC6ce8XTf3Kx0Fb17kmItfXJawUimmqhsFXkX/s+3E4awgHLcf0Wb0Ztj0xhYFAFdZ4z+TNVNttwHQc9LCYUENkTD+cRpqIrdx5WN2ylUF/v0lmcbO7UJz5XCbmlg7+PJyC40W1PrX6ZFyPjLyCKYMHGk11M+NMjqLcHS1HhhUImlM1bKeFc/DhXPTm2HHFPj3/tmhbaKmMe2TOLPRzPqMt4ypBn2BWsjqiCwblPNjNa5jtm6cmuLD4YXmClV/LJmZwbC7dJ7hjqx84qMOpxD15ZssOlsnBhMCYHKKQBG/HiRgM1hfcBZx91De0LP2iQ4Q8prLLm084TgFjKTEGe9O7mFk8M9lQW7OF/Fjc6MkijmMalOmDpc06bNDBj1Am7+wCHqgh2JiFXA7cKPlmGBAqX7WSguMzjTmcI3V5JWzMdj
 XbQQG2go
 +JQYU23ba2cpkxDLxGrxRQaf7V666S4o5XM2tEobM2C95tgWVk1cl+OSL62OuL8Tb+wPg7V+qjd5ZXMifej8nlCZWMe420gsALYK63LQGOnBG4tnblLvbti7KCthLj5CeChuvZmzybqSDhpX3vQSk4ShVfXoCRSS6o82uNnQkjO9mHwxrXdhpeXxRWwG5kHU8qqiqanoI72JhvC98zimwfm7274/QW95vf22BpBbykovKpANytwzP7FDbwAfglG9Jqk1JB7hB+ulHGpE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 12 Nov 2026 18:44:07 -0600, Oscar Alejandro Sánchez Lucero wrote:
> Add missing kernel-doc entries for @walk_lock in struct mm_walk_ops, and
> for @ptep, @pudp, @pmdp, and @vma in struct folio_walk. Also fix @pte,
> @pud, and @pmd descriptions to state they hold entry values, not pointers.

Applied, thanks!

tree: mm/core.git
branch: core-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] mm/pagewalk: document missing struct members
      https://git.kernel.org/mm/core/c/8a834f42

-- 
Cheers,

David


