Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F629606A329
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 10:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XTpt5q+D
Received: by kanga.kvack.org (Postfix)
	id 635356B05C4; Mon,  2 Nov 2026 05:19:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 596DC6B05C5; Mon,  2 Nov 2026 05:19:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45EEC6B05C6; Mon,  2 Nov 2026 05:19:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 229696B05C4
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 05:19:14 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9B61FC0BFC
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:19:13 +0000 (UTC)
X-FDA: 85389781386.16.0D2381B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0B464120004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:19:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XTpt5q+D;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793614752;
	b=j3Q9GLNhHxyca7ZkgZBTixFdJQYv/XZUHsPaLLp87sKwW9CNga0Ke5MKK3zlrGMhj4MQ1r
	sjN4LXjB4Eu7bOv8SmFHJK2Qh2F0XEco/pOFmCSaszdUOQFVkIHTb7rH/IY+v3FF0U7b4r
	2RBujw3HKjjY+1uYZhq3bpOuMLA6Sbw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XTpt5q+D;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793614752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aADuHu477sQH4Tu++GJajWCrL5Sk3CdsR++jz6SNP+4=;
	b=gAqT+q+gcfE2Dz/PjTXOZ8LkNnn0bpltfy1MHIEdruz233PcjC0/VwDKEcHekWDaIslwEk
	9cTuDRINtpP5uvkjIxtmFNOa7okkHqU+3jUsB73I4XUMY9qLdwmeh1OQF5aReyjlH5wvzr
	ne6ck6Qh/UCZ/T1gNxwssLqhxEB107M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4D22E4465C;
	Mon,  2 Nov 2026 10:19:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF2971F00A29;
	Mon,  2 Nov 2026 10:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793614751;
	bh=aADuHu477sQH4Tu++GJajWCrL5Sk3CdsR++jz6SNP+4=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=XTpt5q+D844aIjL3UOk1tzbOum+O9MzTqJm44IaHp2JQE4Ib82zFbyCcDBJHifd8x
	 LDyPpLoGm3vwj3lWd+XuARf4Lj+I5jCImzwUOd0OAbp1xII1XN44sRyuUW2VMG8qL9
	 cmtGSP3dz4saGLGA6gnRp6emsy5f9CWWZXIQcmJxMeFckfIf0VO2NF6HgfzLbQHfa6
	 GTUBjnJUhRDcxmrXGPek1DRRGxMMsHElci5cItc9Xqy7jM+GGKNUxTpxaWomNk4umZ
	 OHL2RIRfMrEbcW2syUF48PpMonIsVm+QluG1dWNafdA0cy3qwCvkMqe597xFOEE5TB
	 lObVuEZBiq8Jw==
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 12/12] mm: hugetlb_vmemmap: make vmemmap PTE
 conversion folio-oriented
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>, 
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Lance Yang <lance.yang@linux.dev>, 
 James Houghton <jthoughton@google.com>, 
 David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261102032525.3597743-13-songmuchun@bytedance.com>
References: <20261102032525.3597743-1-songmuchun@bytedance.com>
 <20261102032525.3597743-13-songmuchun@bytedance.com>
Date: Mon, 02 Nov 2026 12:18:31 +0200
Message-Id: <179361471105.1337633.16877955237876084324.b4-review@b4>
X-Mailer: b4 0.16.1-dev
X-Rspam-User: 
X-Rspamd-Queue-Id: 0B464120004
X-Stat-Signature: jkpfmzbczm66nnet7w3g5ncd5ykn6bdk
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793614751-755473
X-HE-Meta: U2FsdGVkX1+TmG27U8FGHfTOicTKZPU2w1uXNksMwsf7HWFJ63BSPsFUcm/1FxeebHoEGg9ohf35yAyNtDnlz+KBjVWI32JKwsKhElZKuin9TS3HW7FF75nbctnf+YMPLF0ql5ggVibb6aQMRdkfML5pcMdabkEFTuF9CrPvLipq0V+YWA/R+o//jrEatRdegNb6XjJTQyNmjIyxmWDA+YvbY74DnWAynXPtOfDuXcc5uytkAZdhBZiLDCD385g4FxNx8byEuVD7JiJB0fTDw4X2bWKe/e4MFnoNm+l7IAGFLVgM5BF+hRWVILdd5yJx6RfbPNzXNFli0XqsuiwITPeyuMHuMH8IPzS/Z+SFtnOhyOe1R4uaEZstjwaN9Was+QReEuigxF8EU3duIZwZQHaD1DkM6q22BWfhloCRedQEFApdTOJaTiqQJWgzCFRUdXnUf1qJr981YLXHKgaYuZUBThjFRlJvW9a1KMyEBs1xeHwi/yhAhmApYWa9mjedSqjjCaW36Xo+krUlQtq4X/c8pFG4NlzM2fHaYVZtP2RJ//i2UnR1E+cazDzMRaGvHzd/KFDiJWpcQaFphO1KfdM+1Zzu6zFlqz9PHCZvxt/AbZF8XB4DX+iQExFvLc9faO2inQd+qyy92Mprr4y566meHjCV7gqgaTEbuque5Ld7JzQcy5O/iLYG5vGpXOPnfxLA7FHxadNhJDBqrwGHUzIXuALX/Y1uAThShjCRzoKtHbivcJ5JpCbuhF9oZSFk1TqwkQ8pcK91P7+sKSrmuvBGg0NQsya5FH4+wMHaI6RoDSOWezYJ80PlfoS/NAvj3XROtRWbNQdfwpCIZ6W4/9Pr8JlJovcptRQ9w111cZMKozjNMfyZ4SkBcyNkdXRrFBNeuOIb1y7xytHA0DOOJleGrWs4DaqyOxHw58lUJqfg5fqzZ6rozGauiXvT3izG5RNtbNLNeTqvHTPrKB/
 /9J/gpU0
 sbkznIZT9pcc8rJeMW2PP0WR4bgcZKPNwTT5n0xtfAogc17Kp9b3K8coV+zAwvBevtrObJeqtjeTxgYQ0rpKAM+pDPAOyCexfdM8kzgYAAt+Pl1edhEkfDSYo/wD4dBmmVFiAjHHhGLTTIBqKj3lvRXTqf+xsaOmbfXvLuVLV2D0Q1p5bA4MlWAa2CpizGr5gw/3hMiNJLIIj9Jufi/qFS7H4yyisuMN/ljStldhezsj4OStxr9Y/rXCnOgIouCmFHYcSDH0hWoOC95q0KiruBZ5oKiuHoCbwAo0sJyszOZF1nIvkpi1r4uRgWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 02 Nov 2026 11:25:25 +0800, Muchun Song <songmuchun@bytedance.com> wrote:
> Converting a folio's vmemmap mappings from PMDs to PTEs is a per-folio
> operation, but the current interface exposes a raw address range and
> hardcodes deferred TLB flushing.  This splits the common mechanism
> across layers and couples it to the HugeTLB batching policy.
> 
> Make the folio the unit of PTE conversion and let callers select the TLB
> flush policy through the folio-oriented interface.  This keeps
> HugeTLB-specific eligibility and batching outside the common operation.
> 
> [...]

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


