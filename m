Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67DED606A326
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 13:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cSQN4V2+
Received: by kanga.kvack.org (Postfix)
	id 7364D6B00EF; Mon,  2 Nov 2026 08:17:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70DBF6B05B1; Mon,  2 Nov 2026 08:17:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 627F46B05B4; Mon,  2 Nov 2026 08:17:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 411D96B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:17:50 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CAAD7160284
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 13:17:49 +0000 (UTC)
X-FDA: 85390231458.09.DC3E901
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 397DEA0006
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 13:17:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cSQN4V2+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793625468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0+T7ZvYRS+pHPYgUXbB4Cw+6ys3nmZ6chNNrmvp+ick=;
	b=eHT+oNkovuSWmfPZI2tjXopSm+HVkWpJOm242tDLD3JCPvC7Wxe4QMGYRgonMZTk4m+vQk
	21+4wHw8AzFHjgWBEkbh4PY4YtyY+7B+mIEvUrBUkvzOzkJEjo1RtOYq4bG8TIRJ7TG6O6
	+cf67nWO/SR/Zq5sJVhC2mQMoLzzzic=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cSQN4V2+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793625468;
	b=lZdUDyKlVHXiVF6Iob44VDgnALocEVCIfLpSPGWuP1yf5JjQiTzVNpDboPXaHg0QC9S91U
	iABXvSxXoZWFeFNE7czA0Byc5zUZqpverHKjdwWBIa4kJu1p59u4VgMY56BevjCrB2/8nD
	HuHPl+H1Vb91kb+4SPcOYivo9dFCtWY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 453D940229;
	Mon,  2 Nov 2026 13:17:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C50921F00A16;
	Mon,  2 Nov 2026 13:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793625467;
	bh=0+T7ZvYRS+pHPYgUXbB4Cw+6ys3nmZ6chNNrmvp+ick=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cSQN4V2+bvOQXrux35oSJ9g3kJC5fmmMIemuMDFXgcVYGeANQKwuMGP4g127ieOtL
	 gJQETMwmAQRWOHVErJwBFql5UGfmTKpfWhCFjVBT2OiEM2ce5EsSEIecBaDCkzvdp2
	 urdbZ72tXwh+VStL1khw+tZI5evwDJouyr8ac21S5OLlzEbVy3mX/gCUAR8w6Qac5C
	 6+mB2DPRRVslrtk5/CrmaFJ4jPAmMaEK2Tku7oGky72l/QQJfJVHqS/X8yXwCBF1Xn
	 /WM2Fc/hb0/gQeoAp4NgbYRThVUCqNPslgW96ne3YYFVfAyYnzt5inStfL4lrDtPeq
	 jIeLMBkPEbtgw==
Date: Mon, 2 Nov 2026 13:17:42 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Josef Bacik <josef@toxicpanda.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org
Subject: Re: [PATCH 3/6] mm/mremap: reaccount on unmap failure only if
 accounted
Message-ID: <auiMsCn7gwbSjcxh@gremlin>
References: <20261030-b4-mremap-pre-split-v1-0-c1829811aed0@toxicpanda.com>
 <20261030-b4-mremap-pre-split-v1-3-c1829811aed0@toxicpanda.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261030-b4-mremap-pre-split-v1-3-c1829811aed0@toxicpanda.com>
X-Rspamd-Queue-Id: 397DEA0006
X-Stat-Signature: iyhttrcoatn9sy7cnyxu9xb67zgja5j3
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793625468-233614
X-HE-Meta: U2FsdGVkX18ogR2Sud2v9pS46PdPHueifTYcK2MMaeYYAPLSlWd+tTku1/d9oEzzX5PA1oDGD4HsEt3lUdHFZzCZMN1WPuciPHbYjfLHC39ft1NphYhM6Y4xeq5TMN5J14hCZqmodkFS24cWn/5YXYU8np4TN9Ll5nEUogCRmsZIekpSyN4QmO8P5E1jXzUXOLTgwW0dQci4sSQcMMriSId+dFKjYtEbmjKjY68U1VzJC+pRu/eSKu5YfdaRHuNyMj/MgfNyo3i9jRNQn4A0QKgegXdLQY6uPbf0YDB3UXl1Uz8rXOLlR5wHCwtSkc4Vju/+HXNYVvzwlHyZwij+w82pzCHGQd03hb1M/4DXUur1rQmkxI2uj3Tk+iaXNmPyr48IctkPpBymhRtz7CwZH5EnsP73PTyGxr+bBlBmHo852w+C8si48OmmzUKjR11+WF7bepp37/NypFKa3GOs2mQjQmiuFppH67JfKYb3/MScg5f625zc9ypceAn1wEX90aIeb52LF0dtv7ZCTxXk8bRQDA4sRKz/725/0wE0tuISb93F7fZYqGWFF5dp5YgPoJ56uIpwQ2Elb2YHfjDI1fOyA9pk/LboifmPjmGp94Dng3iRIke+Vo8vz51u/d3kVk3mUfCHt9xpzDNY1Y0cpdBmuEMIEq9ZKkUO4knrcbPvArW/NdnXNpY6sJ6mrXrMRmDJQCze8E/7ddkN0FhwXc0HqAGmbccf0J+p5h0xwqnLvl/fqrJWtjXcyaU5938i3kQ+3j6tQTriTnCzvFvYqWW96KanimXtsGqgMrh28If1C8QQIc1K0xwqBhuj4rMgFefljd+fJcF1P2jrlX8dwOGBcxNm/KbJv7ee8qs4OQISHpdTaGGEA0SHeJhAKhSXJApZCTFrQTw95vWoPUDGbcJiyJlkBiQeu88kUiReq+/8/o0xRdXmOgtfnBgDKFMA4B5/TLsFFFMCCFyuOjM
 ZoLST4P8
 qi3elmSmSYIvjk+6mJ9416ZqtA4iTrs55f8a47Dcw6EojTB8vvaDb1mEHnuTFZRyCPF2/tqBwJ+NH/7jjD6sTsINWRTdL6Rx+dvyBv3pMzQkfhuwAwrJ1bmRavl+Z6mHcSvZVyKvw21HXZhYvia6WENkTKUMukUtLv3ueHKphRjN+e7Zbq6MjnR/5XFI19D2w36b2eVA8f0vkpHXxb9R1sA/Dk01VgqTOcpaR/g41+V4KVVDeAaCXgfMfAT1GvQ4jFIdQtE5UEvdhSnldXMxFk9XsyG7EHS3vfmlU6AOfU8bKYudMuU3FaOenuUz9S+Ivd3xrQR3R09YZy5WB1DE+bhWa7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 02:42:48PM +0000, Josef Bacik wrote:
> When the unmap of the source range fails at the end of an mremap() move,
> the length of the range is charged to vm_committed_as even if the VMA was
> never accounted, for example a MAP_SHARED or MAP_NORESERVE mapping. Nothing
> ever uncharges these pages, so each such failure permanently inflates the
> committed memory count.
>
> This was reproduced with fault injection: each failure on a shmem mapping
> left Committed_AS higher by the size of the moved range after everything
> was unmapped.

I'm guessing this wasn't noticed because it's nigh on impossible to hit these in
reality and if you do the process is doomed anyway.

>
> Fix by charging the range again only when accountable_move is set.
>
> Fixes: b714ccb02a76 ("mm/mremap: complete refactor of move_vma()")

Ugh, I definitely made some mistakes on that one :)

I think this doesn't really need stable in practice as the only way you hit this
in practice is extreme memory pressure + a fatal signal.

And then the process is going away anyway...

> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/mremap.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/mm/mremap.c b/mm/mremap.c
> index cf746bafdee4..6f941aeb1b5f 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -1247,7 +1247,8 @@ static void unmap_source_vma(struct vma_remap_struct *vrm)
>  	vrm->vmi_needs_invalidate = true;
>  	if (err) {
>  		/* OOM: unable to split vma, just get accounts right */
> -		vm_acct_memory(len >> PAGE_SHIFT);
> +		if (accountable_move)
> +			vm_acct_memory(len >> PAGE_SHIFT);
>  		return;
>  	}
>
>
> --
> 2.55.0
>

--
Cheers, Lorenzo

