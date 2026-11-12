Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF577606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 09:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Dd2hxb+z
Received: by kanga.kvack.org (Postfix)
	id AE36E6B00EF; Thu, 12 Nov 2026 04:22:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A949F6B05B0; Thu, 12 Nov 2026 04:22:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A9426B05B1; Thu, 12 Nov 2026 04:22:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 763EB6B00EF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:22:16 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0E7BAC02AA
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:22:16 +0000 (UTC)
X-FDA: 85425925872.24.9949A58
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 658D2100007
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:22:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dd2hxb+z;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794475334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lEBNes9WZ6YlYMttj1cy98GuEcLLQz3c97TIzqpDgiw=;
	b=3AY7qvbdIJAX/J/uT4wKSi60z+gbaQJbQEMpewjqYuHRJtYlX/yLlWlMC1MmwdaWujUHXx
	5AEhQVlDrU49+pCnqfqiRuf2VVORWLqDPRbUa+Coe7Y6mh/X2jydJjExjE3n8imoNQ9JI4
	a5qHsXu0L+sgGNjCjVWU3ObcNTBnzq8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794475334;
	b=o6ssnx2OoBbR9+9Cbe5jhKUZ+6TM0uQnbFmDXufTH9CmKiQceI7pzEd937qLY/68VJuEAh
	FAKF/zWQ50VehLthNXjqzl7+/91b7yCliq0Mn9gNiV5/bKa7DmHHFkOWdEe4jAPfBHZfkA
	DyzghsffARdg9IiV1+vTrSN/Y2SOufU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dd2hxb+z;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DF93B61827;
	Thu, 12 Nov 2026 09:22:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83FD41F00A09;
	Thu, 12 Nov 2026 09:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794475333;
	bh=lEBNes9WZ6YlYMttj1cy98GuEcLLQz3c97TIzqpDgiw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Dd2hxb+zBo3V5eqRPFxmMyyaeh4MczoWOPu2fljcl+Hi/GlqKioECJQFEXurY1pdw
	 TYDqVg/w4/8eXZsZHpDG2Jq/2NGiIcUqcWgiPAyCLmc6D0PfavU7/MDwQd+hLVCDvf
	 EBV32TpEIc55z0OwZe2k5xfDu+FcpelKvRRXcA72XT+8nTfWvO3vjanN9LJXVKg/UK
	 fZB373KULjgugUGxbEKFyxz/Lf0imrdqp8Oivzv/QAj6IkXzmh5Q1sI9so9caPLhRj
	 k3Y6l/qM5I7iNaHShYon/2mEOFcgc8GbQRJ94KN391W0H285epX40wECoWnv4DkGST
	 Xs/EkqtHUNTzQ==
From: David Hildenbrand <david@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
 Peter Xu <peterx@redhat.com>, Lokesh Gidra <lokeshgidra@google.com>, 
 Barry Song <baohua@kernel.org>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
 Lance Yang <lance.yang@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Chris Mason <mason@kernel.org>
In-Reply-To: <20261111-pte_table_clamped_end-v1-0-2dbe339c487a@kernel.org>
References: <20261111-pte_table_clamped_end-v1-0-2dbe339c487a@kernel.org>
Subject: Re: [PATCH 0/3] mm: fix PTE table overruns with folded PMDs
Message-Id: <179447532820.4855.13160220470264902013.b4-ty@b4>
Date: Thu, 12 Nov 2026 10:22:08 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 5xgh4bmbuquzztwzz93syk68pfgh7s16
X-Rspamd-Queue-Id: 658D2100007
X-Rspam-User: 
X-HE-Tag: 1794475334-599206
X-HE-Meta: U2FsdGVkX18JrkXbYkl1YBEDTWDPEM2p65RKoPbPxGuG7NYbCeXxNLNVkP/5v3SfHWpiBhpAXsSwvv3bs37N4jssNOO/KcuZRbB6Vr92A9H46z9x6/sHU5LRWlrrOn0y6xdHp/s7EgRKLgI82IO3JF8oCwnyme62S7raG4rmKtTenj7MXnXjKhIx7YqHtjHhY72RShR14vWcUAXR7t9LodD/jPvn1YmRsX0C4gOhMNbgkU5uFxg+y3fE86JsyxYXQ3ipCGtahTbLYp+xX37tdmMhbnX+vbaq4htC5ZUO3fbyYgoK29j0hLA7q3MsKK/d8mIImDfSZ8BSAw98OplQXzbwbVLh2cqHOxg/Lw+cdjEOPcsk9LtOK2o5QPxEHkk0GAaMqzqv9Y+41R2H7ELfXQpSk/GFzfYe6WmQPG19+Twf948TWZw0Ir4Uaj9UqIHShMPxPLGFSdCg90vKFSdMMsDmvC8vhn2o7DNoFVM/MYdgi8hHwBkGjVTnIfATdohUqXdmf0myioWHlnzhgUwEEqGZpxIXSZvviwSx7ve1ifl70OYWg+Gkbn/03vFlpdeqYWVVyCvPKezhHFRed0eA2q1G5sMMbgDTQutFFT27IV3YSDQOU0qMB63MsATWAeHHBnX3v+LYUUBvSLnzx5bhC3MXh+6E/8rfH5kVQwr7EpApbrwOr9hDkEBEv73bXxjzIMaS6OCRNLwcXSPJPwlaj23z+4xZM4Kj/fa9b4yHqrP2h09zkStGhVGvj4ge4aYRq8Mypw2NjP11qpPTO/rCQBogDg5aqIHQAdTLUAGNws5+ZRpILVI+Zmm3zxyi/WZJ+8Iv03GMknF5ftgejRdPvYpElmCAMGWtTw31De02yA/cRbkzwM1W+XqCKDJJLmBXLO40AU8oEmAoiw1mM7mdHQhLrulleGanHIDm0aUdFk92S70H2u4fiaH5SWRqnYmZwGnbQNG+2wbSmNoDhGs
 JLez6K5a
 hOKoPfkQFfIwO36iQRR+3edJBBF76D75B84/LXl+Da7pS4XHRXyR2x9OWPdUEuMaO1OYLCZwUxHlxh/qbQ3knZCshomSRosk5wrrgdacJRPvndPrvxBQuZRFex6c7Wn5aL6N643GlFYb4UNkRM7IVMtsgWgg3IXYsN7me+aghCQPxzFSHYNTJJ+6aui62A0nqPpkQay/0Dg/ZbGYkFsh9pXqPXaNV0kkdKXvPQctEptrjvYA1dW0RH/dLpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 11 Nov 2026 22:59:58 +0100, David Hildenbrand (Arm) wrote:
> Fix 3 pmd_addr_end() abusers that can result in PTE table overruns with
> folded PMDs. Let's factor out a helper from a place where we
> recently stumbled over something related, and use it to fix these 3
> cases.
> 
> I'd call these more urgent because they can corrupt memory, although
> folded PMDs are uncommon.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: for-next-fixes

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/3] mm/userfaultfd: fix PTE table overruns in UFFDIO_MOVE
      https://git.kernel.org/mm/core/c/654b0d18
[2/3] mm/rmap: fix PTE table overruns during batched unmap
      https://git.kernel.org/mm/core/c/bd94d906
[3/3] mm/rmap: fix PTE table overruns during batched reference checks
      https://git.kernel.org/mm/core/c/dbedd8e6

-- 
Cheers,

David


