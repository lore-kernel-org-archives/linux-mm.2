Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3003606A32D
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 09:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ODECxA9y
Received: by kanga.kvack.org (Postfix)
	id B7A466B05B4; Thu, 12 Nov 2026 04:39:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2AF66B05B5; Thu, 12 Nov 2026 04:39:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A19AA6B05B6; Thu, 12 Nov 2026 04:39:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 834D26B05B4
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:39:42 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1CF36A8017
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:39:42 +0000 (UTC)
X-FDA: 85425969804.03.BF7681F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 71BDB20002
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:39:40 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ODECxA9y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794476380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+qZVe7H4KMKBxamxaLHZL9oGHtOAsg+pNoHshyfPpG4=;
	b=t1/a0e17zwf2c0p0iKQVwJGemaDSlzzsl2bMFXJtX5rfgzldZvkXmjBoqIH1FR7KT3TtlT
	C1/XiCMyst6lbGEy4uW1Mybn9X2hgNqLlrkgHbi/Nv8HdFrEyAjapKl7qczAGuOoZ+b41t
	yxGHyew2WNGxocgIRymQFqW+iL38ayA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ODECxA9y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794476380;
	b=W8jHmCQ2HW2gr2i6rtN+fp1oPZOG10GzMPAhOK6LyNfRkrIbxecTkKetEneP0ppvfPMJ8X
	6EibhbhexkjZc6mqfhF31jUM2QDm8S8cLLmCCCI5Y8iWT4t4iwEILVtwccd3bRnZ1X8inx
	all6GL3UE82EEnx5B313TTvx06eLjFA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9B3C043A5A;
	Thu, 12 Nov 2026 09:39:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5761B1F00A05;
	Thu, 12 Nov 2026 09:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794476379;
	bh=+qZVe7H4KMKBxamxaLHZL9oGHtOAsg+pNoHshyfPpG4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=ODECxA9y1Z6siZR8OwuwDYoboqLxQIe+qqo+J8zI+sp0yRBw8eyM3kziDFpXndHzD
	 SzqJb37cgvobwr0NhpIFwN6EKQcHRMQMtWLqjPtFdI7TkHoKwVLstwdAltvciPMEFH
	 uDcWdPxB0/l9k5ljUxPxSlpK9BJavvlwQsqsMQeCe9qv6QmxxVGqG2G7xHjOS0/I4m
	 pm7Azv+TNXUWwscLesUbHMh/wGg7iGAy23eT4GBCeBVnA98fELahFI0yW9V/965Va7
	 XmsaZ18t1AuZZJB9uyJWo214iVZacmLDi9/tKYe5X6ZQpQOA/nI2KKKYY0kJHS5u+I
	 fISEXgbfmoBCQ==
From: David Hildenbrand <david@kernel.org>
To: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261110-khugepaged-latency-fix-v3-0-6eea743cf9a3@kernel.org>
References: <20261110-khugepaged-latency-fix-v3-0-6eea743cf9a3@kernel.org>
Subject: Re: [PATCH v3 0/3] mm/khugepaged: bound mmap_lock hold time when
 walking an mm's VMAs
Message-Id: <179447637396.7058.8722598190835864744.b4-ty@b4>
Date: Thu, 12 Nov 2026 10:39:33 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 71BDB20002
X-Stat-Signature: r1qi9udxuqduptau7oswj7bnmet91eqa
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794476380-748556
X-HE-Meta: U2FsdGVkX19HRxoIpu56eih1Z+l0M7BFHOh1Sh13fNYrH0C1Zy6hgwT+whA6dO4UuzRFFKNenrthl2hEorKLPHjGMuqJTu8EnwgBMVvFbj4ZHihMHPKZ1V5xlwxXnjE0ukEtBQIq/vOlAbIv/YhLlh9XnyT8MG4NvPOebwcy11umliKzEiTihxAdsL1lH8RUFWPZXT8FbE4ap1dt6VUGa5rXP6MFnngwHhrFg2MuYkDGRhcrZr6ruVJsD5ev2elN2ioOD3rryRhwzjNgGnOg8jziArVaqVKL82QfxEadT42P+6VRr90yR83RnTpXupzs6Du+hZMqCSUd7d3EyCWzXoTANTXfDB1suRkZ8pCsY3Bp7rATe9JyUdexHr8OQk+2iwmxZwYVJt1KUrQX442WotdQEpJOYO4D8Z/mrVGsdaotoRcri04rvsy42KbRkobHmZPhcOCktF+TNaWd+Ax6oNV29X0e/7kzSuxid3Py905vuPIu0dex+vfIBe8ZKSCU1BvDscr+O+yfb44lj8CAxuQKyjrJtd1+kMlcPl2ZoJkufPp4+5M9qLm9JIiPHMIfmHSaYPy3VmhMZGr00eEPhlpT7ZmkBAGlY9Rny6a/cITZdD96RgTxs6yfTCVuxGwVjuYuLGDR7TiSRBNVbQe2qrwtu6XpOPfj+J3iNyOOAVqmey5Phpt6Z8zEt+2ZwRNVVTpvy/YwGPm1Ey+9h+xxA4MGpBLXAxVkqSjaDZufnK3wK9SjjiBtXiTohI4EG+j4jkw5MHn+Ie7ZIYQ7dHsIZHTr9aU0bc4yxYIqXlMWW4VeJB4uc2p2/IP66+E5Eh6J100zO+xSmUE/a6Ht/wQG8/FeLlpt3tNF6iDSh7v6mfi3pYhe7Ri+87Dh9GQ5Y3IPdeKvBUV6SplGF7uMIKGfELWJs3HpbUsAQmeYX1YiNv9MCBPJwSbEM31qvEEQSPDsEEk8nx1U8/Kj2shhYTa
 GtTd56A4
 yte6uDtPfR1jDNNDeLwOCOas/ugEjiGVpGWPO1jiVnB/gUkYoKnrjeNUQwP130o5fBT7nu7tTm7Qt7u2OOBeJAkvJp/kRuGexZu6ktkVvfEu7a6Lw283bULAa44U+d2my5BXIPBVPfHrg2iUgZG6PI33J5GflA+yLjMa8efsoFELoifGrk9+r+UVCCXS+Mc7R6Q4ocrS7IXJBgnCau0H4sH4LIAFAfg/Z+NcltgldmZm5KkqWclaQ5G0oDBU55MIFYFJk7JHS4G36Rz7RyMIHJxU8pSymTLD9sAat
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 10 Nov 2026 17:19:10 +0000, Lorenzo Stoakes (ARM) wrote:
> This series introduces a couple small changes to khugepaged to improve its
> behaviour both in the face of mm->mmap_lock contention and to reduce that
> lock contention when possible.
> 
> Looking at the first change - if the mmap lock is contended, an attempted
> mmap trylock in collapse_scan_mm_slot() will result in the scan being
> aborted wherever it happens to be, and when next the mm is processed it
> starts from the beginning again.
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

[1/3] Revert "mm/khugepaged: remove definition of struct khugepaged_mm_slot"
      https://git.kernel.org/mm/core/c/3734f01d
[2/3] mm/khugepaged: scan mm's more efficiently under mmap_lock contention
      https://git.kernel.org/mm/core/c/f4720f7b
[3/3] mm/khugepaged: release contended mmap read lock after scanning enough VMAs
      https://git.kernel.org/mm/core/c/f616e41a

-- 
Cheers,

David


