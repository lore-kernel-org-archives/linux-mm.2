Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DF8A606A320
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 15:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K+E3VNgm
Received: by kanga.kvack.org (Postfix)
	id 97EC76B05B0; Wed, 18 Nov 2026 10:17:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92F646B05B8; Wed, 18 Nov 2026 10:17:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 846026B05B9; Wed, 18 Nov 2026 10:17:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 61A0E6B05B0
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:17:38 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 01661A83FC
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:17:37 +0000 (UTC)
X-FDA: 85448594196.29.24E72A0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 38DB51C0013
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:17:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K+E3VNgm;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795015056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9eNFjz8eGoaFkh5ByexY9gtwepGgk8JN1OSK8KUSAaY=;
	b=dbTkQQNF1FfOYQbZ6bNaNsnAbLX/JYcYKaHItaojgActmT1YG/dRX4PhuWH8kRYrpNadE7
	am3bph/O4r7emcMU6vmHsjAR/TmfgBixFqGzHUl5DfUjJtT7VeFKvLvCh5pmEvu9RIttDa
	PYr3eS/bDaykeJC5YH1KCkQ+yInRpxM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795015056;
	b=j/nfyru0AnyE5KvwRgbRqueTzB9FzuFivEicfECtUZKSfjw91ZLcfrQzj+iwzL8SuxH1g2
	0YTFmgD7MWzw1c0uIN0tSVwt+wX1xHxVUHR2RVw2y3lhYAuSd2YYrHpY4EZYJWt1XlAq5q
	CTFfRYgj9jD+b5zDdLNtB1R44zwpC0Y=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K+E3VNgm;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6D7BE41AC0;
	Wed, 18 Nov 2026 15:17:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE121F000C5;
	Wed, 18 Nov 2026 15:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795015055;
	bh=9eNFjz8eGoaFkh5ByexY9gtwepGgk8JN1OSK8KUSAaY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=K+E3VNgmUZ1CtEoIBgh+MLhkxySu15WxG6psA0t/6HrkUXxiH5y8ElLlMW7mU15+1
	 unb0Cpy1bOEi+FwKaWVQUHRKherIi6ozV1MQHOdHT1e+XKFi96seRY+ixDpN6yzUhp
	 LEGJ2Ym/5H4pl+484Qy4zhkH1GmXbrH+l3Wg2wt+wLIZmi2jG/8DlnCNPM/Tb3sWti
	 IlL4dTvvc/IbG43lukUWr6CBeo/sto0yanSZSBgslZiQZu+NT0lbqY1pFZJIMcdlXn
	 KCGe4Tr0Zd8L1xyjR/7poPi0WPQ1unsz0iJ1gRYcH72G4wc7v+bOBHVmjRM1B4L/2u
	 5OmhGoPCraD8Q==
From: David Hildenbrand <david@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Alex Williamson <alex@shazbot.org>, 
 Peter Xu <peterx@redhat.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Wei Liu <wei.liu@kernel.org>, 
 Roman Kisel <romank@linux.microsoft.com>, 
 Saurabh Sengar <ssengar@linux.microsoft.com>, 
 Naman Jain <namjain@linux.microsoft.com>, 
 Michael Kelley <mhklinux@outlook.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Eliav Farber <farbere@amazon.com>, 
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
 "Gregory Price (Meta)" <gourry@gourry.net>
In-Reply-To: <20261117-huge-pfnmap-fault-races-v2-0-276007e73bcb@kernel.org>
References: <20261117-huge-pfnmap-fault-races-v2-0-276007e73bcb@kernel.org>
Subject: Re: [PATCH v2 0/4] mm: fix races between huge and non-huge faults
 in PFN mappings
Message-Id: <179501504807.12832.2222363605872715262.b4-ty@b4>
Date: Wed, 18 Nov 2026 16:17:28 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Stat-Signature: rd3uheqrja74ix1ety4ztg1rc5fwfd7w
X-Rspam-User: 
X-Rspamd-Queue-Id: 38DB51C0013
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1795015056-905407
X-HE-Meta: U2FsdGVkX19hjkiIO6aCXOCOyxqMWkLt7HuVtrLC05xS8BFLCmwqtM6m06ajkfZ1UNTPoeIjbvOogrDl7iUQXoFn+y50IqCQfK3dlw3i+DknC6BdisLdIze4wo5eExm9Ai86TwHu/OX6MYrUwcA+WxtfuKZwkMh6p5yJtW+I+x3Nhd2xbqYFx8tV6sj/se12AD6vl0IWxwDimbWUMkEF3XJtucxPlj3jyKvh7x2zvNdbaKAQqPKKeg3w4jv91E4Vnirk5jkFhDIkR+QZzJo88VoYg/lQ5m+zHt/SI8rI0pQGcY3eZoan7lNzsYMMoR/PnmUF8sK8tBmnVSjKU9xhNOI8eDB1kNC2ueqYU97+9sHoxk+pm6T5iLTwmiYTdQjgF8BqIc/eH7ExFynEAK9pVIahEgURMEw5xMEsrF+Gd/IEZSUsNoSHi4367j61cElHA09twmgbbNanWjOpi69AyT6TUq1XXs5Pg2qkI2YFr450zcFPzKB6FZZpTF6ARESOM3lgylzEcAcU/SairlcXwSBZvYPIfNBH8LtrcjlaDnPB7eNdScNQ6PTjkdF9Nze67hr87dAMx+nnkh/TiahvpEzBVNUGcPERbJWCDAfaUyKCwfoaoVoAAUhB0UPlLYl/n53mTLBypyHEdw25ypaYIV2U6shCwW3TVCgTULnbEsdz817wlcmEtDvEeya9kzdTysGmehGUGlalXk6+qFJrII3s8/s8+/zLudPVmtnPQflPYHhT6hXJwZSQ2KuIx0aia+ANH0G26dlPz2Q7QLOz7MIz79ZAtcDi862RapETTwBRbFk9n0EhPJ7Wvlj+F/reTvQiCqOmACKPfck1/p6USJqeqcREKtVnDqn0jGl2rtbxeRXPYlaDDUfWP3yZ0Ib9q5Yt1xeG2XwMtpH5j0w8Niqtx9CHgtTWxS5wZP/2wMoXc466QwuWnjC+2LKe6GvkbRIFPPkdPofjs3MrAYu
 YnVU1T6a
 J38Kf1wpfTFr3Zt11W/v0o5P+ZhK55X5SNxsihKJd8+L4rnzhPXSk6BRncskJATGV1KYDD0gDiDaPlvS0F/GBAR10RaXaF7nu6S/6I68KjJe1FSqU7XxjPLbG/rX+sdtKzg97YhQndl1L8eh5PLyZIwJXeAh0QIcCTUm0+m059FZLfPnNp9PX90hCZUBhjKuMgU8iBhd5P1i+lChqYbPiQm7/RF3V4nynxALZ0dlLVaevFnop1HorA5scug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 17 Nov 2026 18:31:31 +0000, Lorenzo Stoakes (ARM) wrote:
> A driver that implements both ->fault and ->huge_fault must anticipate
> concurrent use of both.
> 
> This can happen, for example, if a user calls prctl(PR_SET_THP_DISABLE)
> concurrent with faulting, as that only holds the mmap write lock and thus
> does not exclude faulting threads stabilised by VMA lock.
> 
> [...]

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

[1/4] mm: update walk_to_pmd() to explicitly return an error
      https://git.kernel.org/mm/core/c/977781a1
[2/4] mm/memory: remove racy huge PMD assertion from walk_to_pmd()
      https://git.kernel.org/mm/core/c/dffaff24
[3/4] mm/memory: do not report OOM if insert_pfn() races a huge fault
      https://git.kernel.org/mm/core/c/6aaf0015
[4/4] mm/huge_memory: only compare PFNs of huge entries on huge fault insert
      https://git.kernel.org/mm/core/c/bc5cff91

-- 
Cheers,

David


