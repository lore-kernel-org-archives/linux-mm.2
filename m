Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B097606A32D
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 07:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PN1E+pwW
Received: by kanga.kvack.org (Postfix)
	id 730936B05B0; Wed, 11 Nov 2026 02:38:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 707EA6B05B1; Wed, 11 Nov 2026 02:38:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61E526B05B2; Wed, 11 Nov 2026 02:38:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 450616B05B0
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 02:38:42 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D40811A0234
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:38:41 +0000 (UTC)
X-FDA: 85422036042.14.C5D31F6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3000C40007
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:38:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PN1E+pwW;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794382720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lhmlExdf0MelZAKOqNzZFBntyVoNsKlbfDLeJzzqUFo=;
	b=bpuaJ1Ow2n+Kf8vRtqKpi/ecUqwi97RBLtgnwyxflJyO4++d6ceUsEyd1V9eoFWHmjKUZW
	EGdDPHZkFHugIZnNEywRejpyMNdN+qyzeTu54FcS75yUbTjMC/HmSg4K8Rn0iMZ/Y+/kLs
	bxu6X49OY6d2AhjYOprWCCaEijmfNjs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794382720;
	b=b6e8NVa8JeNdjRgGmXZkn+PjDBXgrL8n5I7cGB+AP/xggPdoLItXnDJNbKpyawht1fUG1x
	Y4dyZwJzjH3pwq/+eztu6OEDB7+cqQpntGgawZBGEKsk9BLwIkQnTQkde0aHrQ5olrEMtV
	fK4sGiI38YRPzNAejhqIWVFfBysqXds=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PN1E+pwW;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5C28B403B7;
	Wed, 11 Nov 2026 07:38:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D89E1F00A05;
	Wed, 11 Nov 2026 07:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794382719;
	bh=lhmlExdf0MelZAKOqNzZFBntyVoNsKlbfDLeJzzqUFo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=PN1E+pwWbP1/aBIuYWozEVC6Onp39zGoaiIzH1Lwx4Th1BngqUKaljpCtCCWPVdz1
	 cCknZguzdtZm2tVsO0wcJGjmSjElVXCIn0OsxW75VTDDpfuZ8y5HhKAZ/FIDOF8fc8
	 T4CQAbVKBFFNV9/F3wlZsFyvdOFENBqkkyLtvWaUEyUoJ37eGCQg7hU3txaiqEy3hi
	 MGA3gqq6mEFJJNtKbN7ZCSjpuT+j6Z8IeQcdcT2ZsYF0qoZx2C/yjIGJFyfYXjPvXD
	 z+vLNhYcUlpJT1KluTAgpiAmK8hA8jL+ZvtT4YfhDopXOZSSnJdURFE8lLe0E7JMt9
	 AgNqrrnGZvLfA==
From: David Hildenbrand <david@kernel.org>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, 
 Yuan-Hao Hsu <aa9736195201@gmail.com>, stable@vger.kernel.org
In-Reply-To: <20261110-refactor_gup_fast-v4-0-e779a7674274@arm.com>
References: <20261110-refactor_gup_fast-v4-0-e779a7674274@arm.com>
Subject: Re: [PATCH v4 0/6] mm: gup: batch PTE-mapped large folios in
 gup_fast_pte_range()
Message-Id: <179438271528.6307.13271652883437039498.b4-ty@b4>
Date: Wed, 11 Nov 2026 08:38:35 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3000C40007
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 7trmw9y37of3hxo8umwxc8sxkxmyhmbm
X-Rspam-User: 
X-HE-Tag: 1794382720-665093
X-HE-Meta: U2FsdGVkX19mK8R1KBLMV9zVPEqnQaPaqZA99BZjA9HUsc81XyS39fcUThxS+NfEMqwSsz2y7Z3XF+CnIfxUD2dOXIoqbgvqIbvrWz0WwEN5ZL1QY8xmhcsLk9KrSrOfvrORfets+/24BKX8dmImv3GVlcC/5sbf/XbfyqnBnQ1F+QMWYwkPxzWFUUnJ/Ylvz2Xx5QcoNiTGBXA+yAY8CEguf+diX7BRT1wmh0du9H+W2jSG7ZoQrfGSh9iteyRHam0n3CxJN2RPyyrsR3CX2JbFKI7bycGV9aF8qmz5pa7BaABhuLCVMTGBLxbqRvk3DflePpvCGgCljTk0K7qfLwdDiXQ15v7NAcvNfgYB6MyrI0W4dHL0ViwE4k8iSU8hzJm0ecMoTGKizGfrjjfm5lDBEMDSWOlJa9ZhjUB8cRQQ+gKfJPSnejXs97G5qrJLP/ahCIlPv+Q+H8Avs58pnFEnhYfQ7HolwJrvzE62Q9ZyUA48dZiqtNaR3/9xAVpYvkpPUcmLW4OEWQm+nQ7zV53h59DjjEwR+qrKTuPwR9XORBqCdDgfey/s3ffQ8lawsc/LVhXMorCkxN5pAoaxxI2n0lbc59mBilUxIwKNLd1XvT5v0fU6y+cT9VZ/o3/zGp71K7024jW8BgVm4nRhdNZWjF0WdQ6+iBWQudlAB1cg/Nz7UDhrZWaREqCVpx4dE8wiiUeF856SCCpy2YeaaP/hxwLctn6tD0J+rd/ABfpAKqbPLcWOEtHjorhKwGuv6OEHyJpXh78lOS863ZsClIwjGQqBs9hUhKKMM5+rW5+am3JM+mKBPvUV2+pLrwqJkorED40p77kDPfixFBPtpt+FtVwZVY2j1z+rkLOUp8fnMEW3YIT3DdGkMPbcrhuP3mkKQhEESWYvm5hyBsmhaxqSYeobAMxisZWXAvW1cSWSqPJZPRYwWlZMVA/gPpBXV5dPzevrOb2Y6Zj1diT
 PRmOo1L7
 TKXf1mrF1gxZKFlA5RWl438wvfy6VtWUSZtrh4PeWzlu1fjKjXCaQJ6sHHwqs2/gSSRS/XdPNNHrC0v6g2fQQmMsXyMwi4L568NVONYo4zwetQFRqIL2K9ayHzChZ9hSxtUN0pioBbC7V6IJ37HjqQY4zrxnjo+B2YsLwps75KikGvNWr8cXS7L1yferAr8KIqmdqrKMAwEBqZ78iwenutQbz+DBq+sjTcZu1XIF8ijHeLQ190YUXF3jXiJlS8a+weGKuOxqo4mS8wsQHmicM3KC169jH4QRf78xo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 10 Nov 2026 22:52:50 +0000, Yeoreum Yun wrote:
> GUP-fast grabs a PTE-mapped large folio one page at a time.  Every PTE
> costs a try_grab_folio_fast() (a refcount cmpxchg, plus the pincount
> atomic, a full barrier and a node stat update for FOLL_PIN), a
> gup_fast_folio_allowed() and a folio_set_referenced(), so a 64 kB mTHP
> pays sixteen of each and a PTE-mapped 2 MB THP pays 512.
> 
> The users are the hot ones: iov_iter_extract_user_pages() pins every
> O_DIRECT buffer through pin_user_pages_fast(), io_uring registers its
> buffers through it, and so does RDMA memory registration.
> With mTHP those buffers are PTE-mapped large folios.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: gup-7.5.ptebatch

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/6] mm: khugepaged: ignore MADV_HUGEPAGE for shadow stacks
      https://git.kernel.org/mm/core/c/0d100a39
[2/6] mm: gup: clarify a reason to check pte/pmd in gup_fast_pte_range()
      https://git.kernel.org/mm/core/c/6ae9ffb6
[3/6] mm: gup: move gup_must_unshare() and INTERNAL_GUP_FLAGS to gup.c
      https://git.kernel.org/mm/core/c/831549f9
[4/6] mm: internal: introduce FPB_LOCKLESS for folio_pte_batch_flags()
      https://git.kernel.org/mm/core/c/300a252f
[5/6] mm: gup: introduce gup_pages_not_requiring_unshare()
      https://git.kernel.org/mm/core/c/1b3ad4f2
[6/6] mm: gup: batch PTE-mapped large folios in gup_fast_pte_range()
      https://git.kernel.org/mm/core/c/3d738020

-- 
Cheers,

David


