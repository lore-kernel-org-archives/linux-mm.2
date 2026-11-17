Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75938606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 21:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TU0WQ2xQ
Received: by kanga.kvack.org (Postfix)
	id 886AA6B05B0; Tue, 17 Nov 2026 16:38:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 837406B05B2; Tue, 17 Nov 2026 16:38:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74D766B05BB; Tue, 17 Nov 2026 16:38:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 53A7E6B05B0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:38:36 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DF27CC04AD
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:38:34 +0000 (UTC)
X-FDA: 85445925348.02.4358E6F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 318D1A0002
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:38:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TU0WQ2xQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794951513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iXopMQoBtcGz358w9N9nrAJff3scf+1pEvqdTdRCoP0=;
	b=fZ92SB0yOJQP6gWZFfglSbt9d2kfvSOxj23CwiQbB39f6qgw8jb/mxUtlkSA2MgI0isyAe
	6GfhJVyZY4O6sCXRJtwFO15On6ib07bhwFveZeYMV1UE50SSPVv7lxnolTFelzdW5bB+4N
	8RyIkptvJWYFSQT8gwKfcMZGwB2pYCc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TU0WQ2xQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794951513;
	b=bB361VpNSzVp796z9tSYSPm3V1jOaHnPycprVCSrAnGyHNo3bgwF3r2gMX/18zs37MUlfL
	xMtqPNp1czqarvgX9t5w7R+pW/HwXLQ5BQkq8+L5Xw75k+4MEJoezeSl+CiwPLTLiVjrPE
	c3Unsnd5QrnNerV2uIdWgOKJe1y1/wU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3B54E404B7;
	Tue, 17 Nov 2026 21:38:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF2FF1F000C4;
	Tue, 17 Nov 2026 21:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794951512;
	bh=iXopMQoBtcGz358w9N9nrAJff3scf+1pEvqdTdRCoP0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=TU0WQ2xQUMV6milbx0O6Ta2jGZgdBz6gPeO6FBMhhUIo744+53WpaV7L/CgZSomN2
	 zIUWBItGYo/1F1AmPBP18Kf8nJAmdVZATpzBzzIjc67Xg60UcYy0/61iZA9f7LKP81
	 slEGik5OnWmzZnNjy//vaY5sX7JyLqLfV6wdKLD5glHpHwEirtxBPW9YWWw24IToRD
	 ZoW6cMzpW8srAp5BKcQJ5PIn1RWPdajuoIZg3y18bBeWDJslA+mC+7eDwJ++ABLvmX
	 zsYoqBgKAioTA5mWnschkaCzUMJ0wrFa56Z8OV1MA+KteqA6rhZJIv8/bzYozu3M0e
	 4kLOnmHVHvkYQ==
From: David Hildenbrand <david@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
 Nico Pache <nico.pache@linux.dev>, Lance Yang <lance.yang@linux.dev>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Chris Mason <mason@kernel.org>, 
 Daniel Wade <danjwade95@gmail.com>
In-Reply-To: <20261117-khugepaged_mthp_dirty-v1-1-024e4a12c2fa@kernel.org>
References: <20261117-khugepaged_mthp_dirty-v1-1-024e4a12c2fa@kernel.org>
Subject: Re: [PATCH] mm/khugepaged: mark ptes dirty and soft-dirty on mTHP
 collapse
Message-Id: <179495150847.5194.3491297223521480619.b4-ty@b4>
Date: Tue, 17 Nov 2026 22:38:28 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Stat-Signature: 97ddn7c8krszr6n8kbkrfqgb4s98parr
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 318D1A0002
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794951513-381892
X-HE-Meta: U2FsdGVkX19NeKCiGeklgeSRCPiJhmJpZ/mAwq62587LxGQRwh5Wma+v+7YRciLUi+duOD3TZBmSHd+qV6iVtRJ7DItWT617ucw02LypTMzhnZIGaE7iXVxbYbxVl0Qnyw8kV6MDTVGpsLju14cLfgHnNzWv1VvBtiyVTIyEXF/HGf8bCuVrmvI8lBr0JtogtYqin+useoA6uQ5lpqHDS0Zh/WZEc1RcvEGdJnEWKo6pgo6J75F2BZ6JhGlBh/Ek7FUThxPGhSF2yqjFGt5/RDz1hMvOA3OedqcLaNjV0DOOjiBooCfCAW6k6tJPlHOEqoeAAK3VYEtJ8LSy51J0OTLTIENCgQfFq69NagqQ4xqUMYzy3+2cgd/aAnhDnqji4tCq4kCkq855U5q1StlxZkSTVbTBHA3we2DDcNF9G7Hvh1FfRi+a9c8pDyNQ1532lyWN9NzmGF7LQfb7lNdMLvVA+bTEy4P9V/QqgftnjyYdq71P7fkF03vHtGvADf1+e7iqyHW/R1GtS0idF4Y75tvh+11OKet/OUyIt1qmRTBHq7KahYQkaFxmDo/86m5VE9TSyxj3R+aBAKg90Dfb45ynjTMHNVLIEFg7R4vYiXWZJbgOJi3W/+MdWIzf8RBqJADSPF2EtQImu4cDN6QIQ2qEMXcll7ZabCJed29Bs4RVlzSO8T8EogaWWBCrvi8pgF+FSVUHSLipVu9/HFKDSL2E0hzmnUMt45FnZ0JyfVH12L+ih1vcIofmHzaS5STYbPArlpKgTfTQ0sUo0MNgo07eaAeBpDqcP+bNfXy82yIJT+mo5Hb+v+4tgBCuUz1BUf6zcf0BRJkmw2SrjGpgHdhzbBrfSF7QEw/IIWpy0YWMjPWnXhthmJZX6oVNuSRp0d3aKgdGIdiS+mzv7jJvvB2+JPPUxlFWj+ADRS6hAQWL+JNZ9NzKXiTNymo2boLl2FzHlGsK9W2kvIWZPSS
 wVx0CwMT
 HQaaIp5v1si51IsHZqMz3uf6LMnNYLXLdpEZeSJZmhaNGY04pTaYO4MufwcIzU0O+b4/6eEwolLkNq99hXxaGgmrKWEmSdfNlJtvScNHsJkw5mxBLu6JuvL+7WtHrhZfhNbXTB/4BE7Z1jCSeO5vsx/0UBap0SdSMBkCxElglAUa0hz2HRNflFOvlEYtYmiRf8eWkET98NfvVZBpvvGayXiM90eS3r1BmDq92AFjERs8jdYmcKhcXHPvPng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 17 Nov 2026 10:28:18 +0100, David Hildenbrand (Arm) wrote:
> An mTHP collapse can lose soft-dirty PTE bits if pages were written and
> the VMA was then made read-only, and not setting the PTE dirty in
> VMAs without VM_WRITE can interact with a later MADV_FREE on a COW-shared
> page such that all processes lose the data even though a single process
> MADV_FREE'ed it.
> 
> Collapse does not preserve the soft-dirty bits of the old PTEs, so the
> new entries must be marked soft-dirty. map_anon_folio_pte_nopf() relies
> on pte_mkdirty() to do that, but only calls it if the VMA has VM_WRITE.
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

[1/1] mm/khugepaged: mark ptes dirty and soft-dirty on mTHP collapse
      https://git.kernel.org/mm/core/c/5e600d79

-- 
Cheers,

David


