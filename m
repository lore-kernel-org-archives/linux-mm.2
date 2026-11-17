Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54FAD606A330
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 21:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FHDhu7tN
Received: by kanga.kvack.org (Postfix)
	id 748B26B05B3; Tue, 17 Nov 2026 16:35:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F9066B05B4; Tue, 17 Nov 2026 16:35:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E77C6B05B5; Tue, 17 Nov 2026 16:35:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3323A6B05B3
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:35:19 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C10381605D3
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:35:18 +0000 (UTC)
X-FDA: 85445917116.24.1683990
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 24EAB1C0002
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:35:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FHDhu7tN;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794951317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Anks4TzdC4CpR+AsePZScfQOH9LZg4KMnD77+CM5Nlo=;
	b=xNPtUUzB2zv83VzwCGtS5225jeth+8+roQh3dLQdWosYjpGY9o0AuPlxfIjj42Kl+eojFp
	pNEkrM9IOkyfD5mcirVVUq83OmspOJhldTSNr1lgiDIDT9HX3KzGhi7T4H11ndz8PrN/S0
	yPhoVc77SjWN2YnudkEBQr1zqdGEJPo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794951317;
	b=5xMpbc1Yx7+A51Ur5jqEEEdco/KVboeF9KyO+KE71+CCtUfjKn0NxYWywTP8Fvnq0PGvvS
	EKcO90LcJMcKmxzJWQhqOFJsMQMIXaMyunfg+RlnuFU8OXCAGbi0M/RFa8gx9ZNgZPnr1/
	keNSx/LdcAktSPxLkjF75grwed4PakE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FHDhu7tN;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A2B445603;
	Tue, 17 Nov 2026 21:35:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F0A1F000C4;
	Tue, 17 Nov 2026 21:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794951316;
	bh=Anks4TzdC4CpR+AsePZScfQOH9LZg4KMnD77+CM5Nlo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=FHDhu7tNqCDK89se1H/cvw7m/Op6cV5/teGP+OweZ54P/dr3CKVgFjhpZmzt5xdZ0
	 WgalhNtq8RvF+2fCSjb1SW/DEfqQxXCi3jknzizsVUbtGXntkobZzQCaohnxbCoX9m
	 J7Jr9FmUG2riyzekBAWJRUR22joCJdZqddLPcRlokcvixh7XLMgTEE6rnoFM+MJs2N
	 YNfvxL2CeYGOzbItvtNnA77MKOUhYh7FARWjcE6ZdZuPJ5gVlNtFAas+VO7eKiJEoM
	 f4PSx3TxwYh23tEu5hfRJ5HsIm9MSPnwsoSR73B3QrkXxpCMLPiCiDRAwPTb96PrX3
	 Q7C6KqbfbsjOg==
From: David Hildenbrand <david@kernel.org>
To: Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org
In-Reply-To: <20261113-mempolicy_limit-v1-0-16688b2644dc@kernel.org>
References: <20261113-mempolicy_limit-v1-0-16688b2644dc@kernel.org>
Subject: Re: [PATCH 0/2] mm/mempolicy: shared policy limits for
 tmpfs/shmem/guest_memfd
Message-Id: <179495131088.5050.4198726430362880380.b4-ty@b4>
Date: Tue, 17 Nov 2026 22:35:10 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Stat-Signature: kxddashoa1jybyfp9c7dmsnioyciztt4
X-Rspam-User: 
X-Rspamd-Queue-Id: 24EAB1C0002
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794951316-738428
X-HE-Meta: U2FsdGVkX1+LJhnZiZT6hn1dcgnl+8kddbuXblecptHzU0t48WfpcKliHsyhuuweoIOK1AkMEQBXwk7iS1YF3Nbn5DKR3yc6J3oWOjfLyAff+QT6Byt2lSqAKlx7rBZxwrvoffTfmAQSwzAC2bS6wqjjBXa9eWGDr+OWRLOXQTF7Lj+SLA4W5odZFtcYeSV2u+Dn9MpWtASd06JNmlGRpYGISOormAokAWtjii2pI4M8rGNauhC8Fm/4KZC2Z8OMYGwMZ0BJNmsn3ahIUWTJ4tnDJ8chPvXs+gqV/OlAEHOyQpqYI0Zo0j8UxufMW06MgKowSX/ZDxaE+Obownpk2Et3HIGqLDbhCG6hpl5/KLqAyuaPLEM7EPkeg/5OpM76NYMfIHWuK28gDg+bo6MPcd0EfG8PWd+GAhe+TyTLI0oJ40KZ3gyq5Yxe2TzCbteVfUKrUINQuARbb1KxfEysynPxIr4Ljso38aun+Wn9SUMGWkk+IvoVYJaBeRnYgviZ5oBI9gyOT9chRZz+bQ7t+M2H9k/FkXAoZyKhSM1ntY92wFXEl0FRlfjiGDi0RgQWiFJgBuvyAsqjMvCP5OLl2tff/ighCgYdAhSL8IdmQ051zHh9Kj5biDXsydfC6CdgGJziU0PjhP8hjcyqCoaQK2V0Nnl0Lb5VvznkGgabXEGtiPTz6D4MJygfdKEiv9iIf169TAl56tH6XXzX1wYC30hKqtCFiHCyCVksl8E+E6f9XqC8xvXPxrWtgzBIrzZQk//AXI3+hJGHdV/HHReXoUFGzgFqGDMXlc5tckK1uURAf1OyL0FVsyXtlakvT8W4Cs5OczciF9vs0Kn3xvzqzmWJ52A9xubB667YYbObjcR6YCnEH7FPlzAmIhuQu86jp74USXI0sbKeJGRhZ1nGN/7k+uf+OBQr8yTbz2Qs4P+S1ZCnLXt/aVLEWEbdKR3v+Ll9ODBfIlYFaxgRW+6
 dgvFwbZ3
 LgT57U+XRi7t8cLT1eI+ydS/lJTUxYxsvobthQHjCV0mG6Osh7WKZyCmGs9anIF3X7XU+1ZqewCsDY0+OGGKxOHgSAyo4K1X/9irj4l1PU7ZzYWl+0xULJyZOsRw9j5xTdRJ64mZP0Xr5YK5CvdvLdyOiYAgAJ8SjhOSHs6FTR4zWXOnqe3YZWqLFWRVpBTrU0wy4JdNl1pO7bPrgPVzCMviEp8wi3GW0KZZ1DP2Xr417SvdatdrDBDBLeQ2RuUBMB8XPaWuK5HcOZ8os63ENCE6NvCFeetRWMcpjl1SaJgHs3FnlfFiyxXMLwErifo7KI+nhsBdC5uxRFjDsEEj1lt7oOi5yQG4TqyLGgjRcMie5SQI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 13 Nov 2026 22:36:11 +0100, David Hildenbrand (Arm) wrote:
> For some reason we thought it would be a good idea to let users create
> as many shared policy ranges for shmem/tmpfs as they want. And
> guest_memfd inherited that handling.
> 
> Fortunately, at least for guest_memfd we know that we shouldn't really
> have more than one shared policy right now in practice.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: mempolicy-7.5.shared_policy_limit

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/2] mm/mempolicy: merge adjacent shared policy ranges
      https://git.kernel.org/mm/core/c/ca9e4df0
[2/2] mm/mempolicy: limit shared policy ranges per inode
      https://git.kernel.org/mm/core/c/8d93a9af

-- 
Cheers,

David


