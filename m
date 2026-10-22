Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 148AF606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 06:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lXDFI2vo
Received: by kanga.kvack.org (Postfix)
	id 2FFB26B02A8; Thu, 22 Oct 2026 02:50:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AFF06B02A9; Thu, 22 Oct 2026 02:50:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EE856B02AA; Thu, 22 Oct 2026 02:50:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EFF0F6B02A8
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:50:32 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6691D40201
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:50:32 +0000 (UTC)
X-FDA: 85349338704.19.35BDBA3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id C2754A0007
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:50:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lXDFI2vo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792651830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BHhajxLyQjIggPfERX4J5IymxXdQBLrR5tOcaGMBjj8=;
	b=jebbtgBNDppY+1ygG2cRMIv6saiFPxSqePETKffBDgqdKcdZtPULcagsRJFs0qw30NNNI1
	q1UuFERnwKQsAI7HMdrEupLs9f9/YKIKrdgh1QOuxDCTbNZ51pJE2pM40Q4kwoCgxVdRAC
	adgsVmGfI2lY9RQoP+YaK740irLy+bs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lXDFI2vo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792651830;
	b=Emj4o9TA7jbMxfQpguFGkCk3iuyQGXnsW7uD0hRmuSnK4PsszQQgm84gMuR/UYnfVfGOOE
	ivqY0jkDQBQuQZb6Rwk1NcEPK+G53eY8L1EQIqWTF64nskuZtja+3f0cD+T98G7H5wSAgb
	3+HAIU1r0fAer/8RCd3epZ5GRh2o8qY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5338260235;
	Thu, 22 Oct 2026 06:50:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54F431F000C1;
	Thu, 22 Oct 2026 06:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792651830;
	bh=BHhajxLyQjIggPfERX4J5IymxXdQBLrR5tOcaGMBjj8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lXDFI2voqvPVnhrcv3mCBj9iw7gFtv8c2eYodVCu3sABZGnH/1x6vsSoA86M2qZZt
	 SGxInoXRTs4Hb1UUpdTu9mWdoPxjQRMySUj36JXLs+3LqxQ8XzeGq0CRhTBdF2NPrQ
	 vufeC0i1wv+2P0tRBVHE33hq5mgtciSc3PVFIj8AS4TcbkfR9xe8abE8oPeVxuphos
	 dxnjlDcOtCnsDIQEX+7fH2qeuDQs8UDhzwsKoVp3S+V+4Ki7rlYccsvp3YoYse+Sni
	 120oQxaV8rDais8KVHaLvyC130iHgvQv+mpFG+Ogc5iYJckLsK0DGrKE01RHsE/cYS
	 9N6u7nNLn4OKw==
Date: Thu, 22 Oct 2026 09:50:23 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, david@kernel.org, muchun.song@linux.dev,
	osalvador@suse.de, peterx@redhat.com, azpijr@gmail.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 2/3] mm/hugetlb: disable PMD sharing for UFFD missing
 mode
Message-ID: <atmyL8tmB9ZCdSin@kernel.org>
References: <20261022034543.51226-1-lizhe.67@bytedance.com>
 <20261022034543.51226-3-lizhe.67@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261022034543.51226-3-lizhe.67@bytedance.com>
X-Rspamd-Queue-Id: C2754A0007
X-Rspam-User: 
X-Stat-Signature: u6yo53dmsbhzoqtiaoeacynd56fzgp45
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792651830-744
X-HE-Meta: U2FsdGVkX188mzoaXrC7VwHsMOSTGxi+U4CVHbxfeMO9E2YcNnXYWFg7F4HA0ytTMLlGA/OvRnX9XzwKlaupA7QI+OEDo1nFrJHJnFvuxoVBQqZ1hYcF1KGvjxgYe7/sO15OWBmIDLz6clFjR9gj8MkoMtTbgYI1VPyTwp9jgmvEaCq6YHw+MboK0tsNQUcOzJRn6tGV8ang+dMSSiGVAJyKUThEezteEwRQs5YTZoFYdundr+enh0/K0O+8xrBv2k3vEf2u4aKWioffKzybl4+zOSEHaqROcSTLLE7x6eFdzK+Fa5pzA69bU2ap4hJh8BnTOhL32xiy249amwSObA1mJDQ1Li0BBRHtjbcsk3Egj8ilVmLkcpu8sWSJ9YFIMWvHZSggsvL+foV5q8jFrXa/O7FhRmem2x5W17cgjN5Bb/wSCk/580+6/B6ohG6uC2P0rbvskhkx8/iYZNv4BRSOt+S3STjqXI3RuOR+C4gCPVKkSWH4MSzBVEHJsOCoHDXcuvr9G425uau6QN3cCXhIVYhop+mpYourpmg7LKiSZASJw801wyKxi/b/A8tqo2KFw8vN5oXrfiW/bxqqFNWFhjFa5eqqMuxBcLZebC33eU3UC29lqy919q9BGDzIs0nvzVP5tmZz5/jOx8zfew6+opIVB7rtYuEmsv/jTVWjSklK0on9t866YRwOCJJlKtPSuATUdSbTOPjQj2LjLyEbehZP7iKvPO1Ost2SWNhLCwdjS6ospjVuVH4uX98+4ffjT+MhIqvvgy/e2pcpwxyJf/AeD5j3+Hcj27T51qCnzK4oYKpIGkxvTm303wS/bESe5koVM88+eDdR2pGp6KKrIj6jPcsjQT9SzoHmbTKFaMdJTY3qAR5c3WfGCcV3b2hbKXM39XbD7sN3RYj1D7n9N0W1canYBwJexho/r047AbrVTRQM7NZmihc1f2aETgIgLKjCG9l6WsQAXVN
 Txnpfk9g
 HGNswfM4L+w5JuVgYm2M8kc25F07veyWpAOGgLQFxkjKn1Ta+uX/NvkIyiGiP+g+iumfzwcnG6XCEyB22+l4PJrGI5gJE7ChV3V/0bnfXXY7kKhnt7b84WZFKHqXJdC6XoHLSYK6ufuoDL/2GKrbcGB38APxTLU0RpopdpV2hKMSqXtsJLsL1Bi5saTjJtQtkc5v4LzaynL/zHzRFvtOvvSeLR8RqhuWqxDvhLSQLOG1E2AnMrPrdk5s86gya+1jpCp6eP3Ty1uLG9Xl8o+S/n+XZoh1dKSYcQA0Jvcx/MfkvaT8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 22, 2026 at 11:45:42AM +0800, Li Zhe wrote:
> From: "David Hildenbrand (Arm)" <david@kernel.org>
> 
> For UFFDIO_POISON to install a poison marker in a hugetlb mapping, it is
> sufficient to have the VMA registered for missing mode.
> 
> However, UFFD missing mode does currently not block PMD table sharing, so
> installing the marker will be visible to everyone using the shared PMD
> table, which is wrong as UFFDIO_POISON must stay local to the process.
> 
> To fix it, make uffd_disable_huge_pmd_share() cover VM_UFFD_MISSING as
> well. With missing mode covered, hugetlb PMD sharing is disabled for all
> userfaultfd registered VMAs, so the helper can simply return whether the
> VMA has a userfaultfd context instead of testing individual UFFD mode
> flags. Add a debug check on the marker installation path.
> 
> The existing registration path will then unshare PMD tables, and
> subsequent faults will not share them while the mapping remains
> registered.
> 
> The alternative would be to unshare PMD tables selectively when
> installing poison markers, which results in way more complexity. Or
> alternatively, simply failing the marker installation, which might break
> some use cases.
> 
> This also disables PMD sharing for userfaultfd registrations that never
> use UFFDIO_POISON.
> 
> Suggested-by: Li Zhe <lizhe.67@bytedance.com>
> Suggested-by: Mike Rapoport <rppt@kernel.org>
> Fixes: 8a13897fb0da ("mm: userfaultfd: support UFFDIO_POISON for hugetlbfs")
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/userfaultfd_k.h | 16 +++-------------
>  mm/hugetlb.c                  |  1 +
>  2 files changed, 4 insertions(+), 13 deletions(-)

-- 
Sincerely yours,
Mike.

