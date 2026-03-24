Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB916E9A74B
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 09:26:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D651B6B0005; Tue, 24 Mar 2026 05:26:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D149F6B0088; Tue, 24 Mar 2026 05:26:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C03816B0089; Tue, 24 Mar 2026 05:26:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AD89E6B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 05:26:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6F606CFEA2
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:26:44 +0000 (UTC)
X-FDA: 84580426728.18.CE58581
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id A34778000E
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:26:42 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OBlmG1a8;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774344402; a=rsa-sha256;
	cv=none;
	b=h7fkmp5Gm6YMaLXksfn7Olp/0sl3lhCgGU9ehoZCpgcKnARpigy5tNNDL6L/KC1dltaYL9
	QrueMxNK+yikc01YUUigu94rZSZfzNyR9OJCaITATJn4sYGQsEz7NkuIuOjgQwzO+d+MmS
	Q/LU+C/WJQqXVHcqbfssukG1jSdw0LY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774344402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8xt83ajIDRKJlbO5L8MuCVMa+PHxLliYvnlYeCNZlyY=;
	b=TWdxYTQ3D9AB6HV9Od6U1LfQRC0M5nvqO3olI/XKpl5k4lcV11hYwjgZvvEnHthyJ/1M/A
	BxxTKAzLtkVpoVDPdTa+JFk1hTM6OGUxAVgLs7C0YqsUECIvdS8L+kB6eGKqqlM87SFvuK
	HUS44W+WCt+wmoy3eDxUs6SaWUD3SWQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OBlmG1a8;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9F09B434C7;
	Tue, 24 Mar 2026 09:26:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ED76C19424;
	Tue, 24 Mar 2026 09:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774344401;
	bh=DOqrhUf81JiXlPtqB8dysDG8XysCjmUPjKpWHFPKIBk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OBlmG1a8VRhWR2loCfleHxm+HvmvQ3agIHq/CaJdjDiEVgtG0xHTrBYavqKNw07qK
	 KT9g9D7Wv+VEAOcJRKMODZEMlLi8CoHVNzqKsZxClOEvSJ7+6g7db3s/U0h9/ZdmPy
	 BhgM4w6G5b0qmKEPqVbo3SRKOpcEuL2Ra/z0Jul+YVXTJXCfTiRFwDbDIsaoIRL7Gl
	 pVkL5sRM/0lXapMVlKKdo+Jv0h672+xa/I2bBY5L/cgV9DIJ56elYSl4XH3gIJG1WN
	 Ad5x3+6VmZfiQP5ZzW/0N5l5viTDsS3dp2HeYEDHo3FbDvKK8UBLBhVN9G66+vCdGW
	 BRzXr/+NxTe9g==
Message-ID: <ec886c5e-b44b-469e-8d62-0e41caffd77e@kernel.org>
Date: Tue, 24 Mar 2026 10:26:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory: fix PMD/PUD checks in follow_pfnmap_start()
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
 Alex Williamson <alex@shazbot.org>, Max Boone <mboone@akamai.com>,
 stable@vger.kernel.org
References: <20260323-follow_pfnmap_fix-v1-1-5b0ec10872b3@kernel.org>
 <acJNvA97csyxd0Ml@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <acJNvA97csyxd0Ml@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A34778000E
X-Stat-Signature: nui3t6kdzzqhfykccef877qrmaebdheq
X-HE-Tag: 1774344402-954935
X-HE-Meta: U2FsdGVkX19XwNCiKvDZtrvXw2qfCF0Qlnf5OA4UvciculhVpbGRiuUhW+h371a4EFbX1VIXBdhMMAdVAKOBEt/1xbhJBDtTu+leanez6t7UlTNbC0Fwc3LygGIoO6aEhauySTD4f1j2HwAG37KYUDbbUBZ+t8og7WY6l2UL0XwenHt7vOPhbR0+zvt34bwVVRgIE0ux2Mcnz/chADEdDtk6QAvZQJ/HR6oMmwnZel2nLGAsEE1rdw6oM9sgunXdX4KUGaJ7VfWfybW2SjKOwcxHyiTG99I1iQtCexGUuqwQvbFKYdo6ewpkZ/1JPWrcik/rr8m6YpXESETXRyJfpIrd9knl2VTVI8UrrDV/t46mKTJV7RrveNX2G9TNGG8zP8OvT7eS8K2FX+WwJxD51UCAw1m1Hej0vm0O4n4iFjo34p9K70jY3NPa4a6SBwjXraL2sqkIStavfJPjqDe5+2wJaMGDxIrelqR4NgnvMpqvBPAuymjl1C/KiI2+X6eii0zhdu/DFndq+w2aY6g9oKY9+bYvqCmJ+orFlARhTM707SYbHFvK+uyLSDWg4vVPbvk/BrkAKwr2ukTEF4/slhl0IXPMuuFPk/UsoLIqtO32Kl7E8lAO9XUTV+MiyAQs5pkPwhcrAm2Bj9dI+v0oLn6fb8nziqcNEGkkTce4s+nyC4Py7dNAOEvHsEMS0bShQf4Y65Ap3LQMXXGeVnT7sTK7j5L4oKiC+FzHqq1z9XTiAc0btXwTlzizOWdLjfXwVQwljIQeDpf1mp0xM5fHrB3t2i0HSWaaFKwmPzyC18NjGKw79Fq2sjLZ+eLB9VBlEO3jYsPFEIq6Kbj0qxiartA9kK8HXqOHPkxfHSsunAtYFI38+tgMaIH5Mp91VsfYN/0anEv5vfEQMNS9Imjgt887bVajJ22YcB1dMgYwS6mygIzqK7xTVIikXHX0JZ9GyIF3AIDD/D8/leZqlke
 4zbs759q
 fg+GDgMUhDVcmlrg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/24/26 09:39, Mike Rapoport wrote:
> On Mon, Mar 23, 2026 at 09:20:18PM +0100, David Hildenbrand (Arm) wrote:
>> follow_pfnmap_start() suffers from two problems:
>>
>> (1) We are not re-fetching the pmd/pud after taking the PTL
>>
>> Therefore, we are not properly stabilizing what the lock lock actually
> 
>                                                     ^ lock lock

Thanks, Andrew can you fix that up? Thanks!

> 
>> protects. If there is concurrent zapping, we would indicate to the
>> caller that we found an entry, however, that entry might already have
>> been invalidated, or contain a different PFN after taking the lock.
>>
>> Properly use pmdp_get() / pudp_get() after taking the lock.
>>
>> (2) pmd_leaf() / pud_leaf() are not well defined on non-present entries
>>
>> pmd_leaf()/pud_leaf() could wrongly trigger on non-present entries.
>>
>> There is no real guarantee that pmd_leaf()/pud_leaf() returns something
>> reasonable on non-present entries. Most architectures indeed either
>> perform a present check or make it work by smart use of flags.
>>
>> However, for example loongarch checks the _PAGE_HUGE flag in pmd_leaf(),
>> and always sets the _PAGE_HUGE flag in __swp_entry_to_pmd(). Whereby
>> pmd_trans_huge() explicitly checks pmd_present(), pmd_leaf() does not
>> do that.
>>
>> Let's check pmd_present()/pud_present() before assuming "the is a
>> present PMD leaf" when spotting pmd_leaf()/pud_leaf(), like other page
>> table handling code that traverses user page tables does.
>>
>> Given that non-present PMD entries are likely rare in VM_IO|VM_PFNMAP,
>> (1) is likely more relevant than (2). It is questionable how often (1)
>> would actually trigger, but let's CC stable to be sure.
>>
>> This was found by code inspection.
>>
>> Fixes: 6da8e9634bb7 ("mm: new follow_pfnmap API")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> 
>> ---
>> Gave it a quick test in a VM with MM selftests etc, but I am not sure if
>> I actually trigger the follow_pfnmap machinery.
> 
> Most probably not :)
> KVM selftests might, didn't really dig into that. But I doubt any selftest
> would trigger potential races there.

I was wondering whether generic_access_phys() would somehow trigger on
an ordinary system when doing some more involved activities in user space :)

-- 
Cheers,

David

