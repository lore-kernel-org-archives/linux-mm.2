Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A87F107760E
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 20:45:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65DB66B02CF; Wed, 18 Mar 2026 16:45:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 635D76B032E; Wed, 18 Mar 2026 16:45:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54B146B032F; Wed, 18 Mar 2026 16:45:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 425216B02CF
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:45:41 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F06D1C0841
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:45:40 +0000 (UTC)
X-FDA: 84560364840.18.B69C550
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 307A6140018
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:45:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="tU3bf1/p";
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773866739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WUTkbyVFip6Wbeky4xXvQswrmPp3VybkE/qv7sI4E9A=;
	b=6Jk8b8+B70s3Jt0at8USyOBKtww6J6zwFDeVMnDr1IIlcxRGZsFAN2HhnlwMS5CRvMnIQJ
	EDUX3YjvOho8TbbE72pzT1g+zeeuG4aLLl0kYJyLarO1ODUinLyHjE4LoyK9oabTgwIwLL
	MEZGi61qhcARUZ35QBcUCWTDxS8nc+k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773866739; a=rsa-sha256;
	cv=none;
	b=n3a5ySNJk1g4svia9fs/7lSIu9lL8G3Q6VCjYez0U9gdeufY/Oxv0q8GKml2/Rxwq9ugls
	bpG/yHXhLFWj11JXDOIZxnICeS2b2uwnZJWFWdBnT/jjwfocGqo4THw1FN4KvrTMPbVnuP
	xmZfivpEnw8lna/MVGvOUxeeHgzxZ3w=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="tU3bf1/p";
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 81ED360121;
	Wed, 18 Mar 2026 20:45:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60453C19421;
	Wed, 18 Mar 2026 20:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773866738;
	bh=zhiEEPWHi0Q+RZZJHd9qlTQu0wk2AvPhIX6cgiIHqVE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tU3bf1/pUIwb22ed55FxfamtkcBn4KbUxGHRym1zix0QxI1yshxGBzV0KRRXZLY92
	 w/oBUkyIBXuIYXLThHFfu8wccS0YSI38SiQWbjCtfrZMungJSI8peNCTFdiaZ9oKgn
	 UIk6hfVMSu2g0GqVwjcgrRV+wsxepsZk/VWGLfnjhWol0saJXWg9MgLZKc+XiaWap5
	 tH13N/3lAuEUyVgarlGGFn8o/Lb0Qkw9J5IWLC5xpD3sDN+RA3drdSkfq6OCvazWEF
	 4Blzopwf5m8/FnJjDfrCE7BogXqTBOwMVY04snvjBCUoVhzzYE0Gl62Ht1IePHOZHe
	 GyZMZfKR25/+w==
Message-ID: <5ce0932d-e8d7-4f0b-acb2-12be43a035e1@kernel.org>
Date: Wed, 18 Mar 2026 21:45:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/8] mm/huge_memory: simplify vma_is_specal_huge()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <cover.1773865827.git.ljs@kernel.org>
 <84712e37721c557f887e4a405759be31a4961100.1773865827.git.ljs@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <84712e37721c557f887e4a405759be31a4961100.1773865827.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 307A6140018
X-Stat-Signature: eux5j87udgdrp3x3dx1sjjmamomur6ir
X-HE-Tag: 1773866739-988616
X-HE-Meta: U2FsdGVkX193lLHPj9d1DAdXgOcx3WX27mGHi4rUPChuG7OIHp+j+dJh20VMLA8I91YXvhk5wgt5KlcFv1I3xvtXJMijaDN/tcVqSkRjAzjzmkzyN4ktLWgjrat9ATCAyB1Tx3FgBf344uYQobh2giNxTzHjdlxid9rdqJR0GCY6Am3Dg+0UT3NV9/zIFbxJmv2Vfz69xt2SDmPun8DyOl+eaKSXNiASbcrcxcnCGmqzkmwsFn6ZtsYsvnGJV+lRywklhlUhqOtpNp4bFAqUmr+19LiSKnMc9Tbq18NjWblwxPTUS8Xtv91dJO6AsQclZ0oGeD1eBq/TJtlrUu/cuoNEmrqFFk3tgNOU3zSNymUk2EWe61PfuoBfYeTF77mWfioN4L3B7Qt16fGMLYfrtZ0gQd6joaxO4LI/Lx9PuqCVAjLdNwvw4l2td3UGyBNY+Gnz60jH77S6lHfvbfWVduHSaD63PBWurDxmjtB+YnvTXjFhAw+Qey6JytFI2/O1O4qDhVBHX1eNT3JmM87ZQqYhNLafBBAnmDLxm9TmHEFCWQ86HdoiSLmgEQ1XBTPzTfaLtywSOfD1aZlw9HfF5ZAXWYaEx9EsL/xYNw1walJn0pZSJNGNCE28la0DTaxo7pJ/e+pVR+cqZU4E2vprL8DkCjydQbiUbgIKTYXFTJ40pX+FyyjNryIRs+D8dKAzn8f2z74S1BpNVbW3Ch0pMAl2FsfoarbaEgz73h5paGsYvpgi36vG9EAeNRBu2XXSkQuUcbC434gLaks6L6iUVVslDXjx80bhzb23eQYS15EeTdylGORzyCbMMO00sf8ZQvyWHpRKd9BVgt6CeWQ+okKdmKbCs/oZYjINqGwRbhoIiXjdSmiZb0B7bk+ymEq0sDlH0MmUK4pwFnZ2t3CwsXh7lNMv+Z0fMjzS4pTIHtVsf7Lcxd0NBvucYi2Y5a6TXFrCqYPYVrj3FEGNytV
 vR6xiYqm
 0TOPGig+bLkw8Kz7kvxWOgx6nVdTERScmfQNJQGw0/BEDPCG2lf28VemwvPD5s32xhIcK/a3tNJfd1avBhDe7qCFWH0N3MHXgnQMI8M1p1PmYREzM+fg5Ozz2BpnScEf2+7XTj6b5dcXj5io/E59Q1pFkr2fKpb2YtnQa8AJ+tyUir/A2x+7fmkP+cY0qYTgYabsKZ6mYmVovI1gfuffm3ep9oTRE7LC4rMDtsxJ2wucJ6Ryono0Bwc2jlo/S87NBXatUKgVjQ7vjL8cY/hTsEZVnRmstpLaCw996f6pOMjICjGiALApgKVSnYwD7QfYFsZ+hhqtNgNK/99M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> +++ b/mm/huge_memory.c
> @@ -100,6 +100,14 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
>  	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
>  }
>  
> +/* If returns true, we are unable to access the VMA's folios. */
> +static bool vma_is_special_huge(struct vm_area_struct *vma)
> +{
> +	if (vma_is_dax(vma))
> +		return false;
> +	return vma_test_any(vma, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
> +}

I was hoping that we could make this whole code look more like PTE code
by using vm_normal_page_pmd() ... :)

-- 
Cheers,

David

