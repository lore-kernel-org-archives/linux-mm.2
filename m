Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AA7310F9302
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 21:06:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 809C96B0092; Tue, 31 Mar 2026 17:06:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BA776B0095; Tue, 31 Mar 2026 17:06:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A9486B0096; Tue, 31 Mar 2026 17:06:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 58A516B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 17:06:09 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F112B57FCA
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 21:06:08 +0000 (UTC)
X-FDA: 84607590816.29.6CCCE19
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 228E4180013
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 21:06:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ucH3kdOX;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774991167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TceaKgXolQ62GJ3ja6dfsz4/nv1VIjAV3aUetuELvfo=;
	b=u1PIYwB4hcinyM7SYttB9JC5mbx2Z3ej5qRpialNKlGYBiJREOFIfRINW/sRvaWBmQw/qp
	6oA0uWPx+nj/QKIiEix+h8CDs0yExvbN+UnE8mQiDN9QBlv0TZFddLcOGYijsmWuORqhXs
	vCy3QcjN9PcgCeL8DEC7ylrJXZ2NypU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774991167; a=rsa-sha256;
	cv=none;
	b=t2H13qEXpiUUk6PTC2/xmnfKSYHcr1VspXlCkdPPxfJ3U4xn6REZoivoo4xO+8GApXS1+3
	7c90czG9rExyxzAq1kpQNHIVhG8lo/cVdyQKvxGZ+ZXpkbBlwiOMhQcxo2bhvWcSO+G+Er
	sVvRr/1I0Dx3589u8dn3dqI/bsA1xeA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ucH3kdOX;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 41D8541B45;
	Tue, 31 Mar 2026 21:06:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0025EC19423;
	Tue, 31 Mar 2026 21:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774991166;
	bh=fOcKzFMTkefi9WydzDBIg5X7f+UtKqa1WL7RmDTBHak=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ucH3kdOXN0uxyhdYI/xm3vmc5PmctJmmOBxpS2qzQYZ5M3unBIKtnIjz9UNY4NMkL
	 txzS6sEot1DggVtNLS2IedMq++WHdc3Lwt5vhFN/AWTqqKoJOOzgaWEMUFJNljF3dy
	 a+c/0A0zXpizSt+QiFoj7WjI1hOjAPBAHtJ8zZudPUyvX6c3VwYDDT2kqpxe5B9ie3
	 +1b6TmVFxTfvBWMXGUUAIcvJ3ldEC1ePXMj7QqkN8GmMzCayOT0bPxqC/SQjMhmRCS
	 Hy6fun9iK4llkQ8BPUod9BHX137CDshc+Q+xYC0Q1sDmIPEtHy+GazJaVFH9kg5w/H
	 tUwVFZgY9Ut6A==
Message-ID: <df7fec5b-439c-48ef-af53-191fbbfdb88e@kernel.org>
Date: Tue, 31 Mar 2026 23:06:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/sparse: fix preinited section_mem_map clobbering on
 failure path
To: Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <songmuchun@bytedance.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Frank van der Linden <fvdl@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, muchun.song@linux.dev
References: <20260331113724.2080833-1-songmuchun@bytedance.com>
 <20260331131054.0164f3b3ab6f7868add37cd3@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260331131054.0164f3b3ab6f7868add37cd3@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 228E4180013
X-Stat-Signature: 1ac69h5xjtmqoknnbwe5s9xbgscx5oh5
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774991166-983268
X-HE-Meta: U2FsdGVkX19uC7ftDBlgCXnr0wli71dZowainkr7d25/Tg31Zed7NAhfpcDdO3nnuCTHvhe9CWcooFeRgfby0MiXQSaPMZaSs/b7NjaL6w/q4Lnm1dD6ebglI/1cS1cv+yhdh+UDLWBDD0uaEJBvClfHL33S5F78nMFPNV+R7m/aZH24pkdq+eKOEm9x2ZDkYNYsyJRhodf0dz1Nc1ZBkMmdqZgSoYwzz3SgEiShHlYRFaIY/S8bqZgraYXE1Am1eY1zJ7SasGRAuFX40cDUlJkOfVJsXYXxJgnknoHPAXmhFHlpf2GRtdTuiU1TlUNMebXA57P2YSb332ZgThJNtGyiqkHdgsue+7xqeU9tSPp3Sney37ToxrjG3/sabM4GOVNYHVvmhUjOwUilEmQJIrUP3ObPfRdWN/7rSWSuR1efyPnGk3xnSEXXKMKnnB2U11szxmCHGNrNmmUwyT4CWL6vqRLgqeHXF1MIuFlo+G9kXgpXK9gkipWN38Ps3ZHBfQQNn5PXgZsX33TVXtGLQ9JUdR2NQZpQSctE9oeIrhhgypwdd3awpVX/McGF/zzDxOokTS0Ld/xdMDAB0yGxI3GGYA4jmGQu6HQWOgZ6KIa81PSlzS51m8q7SNOOEOqtdZGLpYLvsWmw16ytYEhzvZhY9Y/pfEP5XubLejT/uMdL+cMjP496Q0sGsewvdwdB1PuiJjLl+EIb+yMiSzCiW25u5YIUkmE/KjJ8zC/uibqDU5MTfXG+uur1zoTvUUQ8XdmrK1ukwQQxOLwnghfFHZC/TCBpXgul7JDhFxGHCsXNCIhrdcePBtPXVtC95R4jjeFuUi+XWpUJMZ7siFuUC1lGDG7vGdsACkNMG5b+0QBiRhHVndvpFMJsqCoACoMaOgqZhi5jK7AM8Rt6U7sHiqxjVCkLezjpB0DpzdMV8s/GtYehNdzvZT6wXnkBpf+j953V4Jk+FazpXOV4C1t
 dexY7hj6
 KejPTE/q1Q9ALT5/VK9rHveejyibrueMtdu83CBvHxZRjEnT46Sg4Si0opPWgEOwrmhUEofNKwp2dxJVn7b5QYjuvjFRaQJgC8EU8P+i/Aq7N3P/HB8UfZ7M6bNgVnbsXJuNLzOm+8JaypFyHeT0d7ukckeiE7I4s3MfkQblz6/fDhsqqO3czZBD5baWrWkhJHJYhdRi/eSxlVU52p5Idz6CRmwC58GPdwpk98ufcJToxx8L4jL/PyozrniH0EcuwNEeSze1mdZNooGk6azJY/MJitjm0nHhiZrqC5jUP56J1tywllr4d+Dcc06LG6WbDrxqcdMIgQEt9CMUMkO8zFFGSdJ4ey+h/ixxCPFEG+4Mmjyunal7KinpzR0nRP0F54AkgcfhPCgw8jZg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/31/26 22:10, Andrew Morton wrote:
> On Tue, 31 Mar 2026 19:37:24 +0800 Muchun Song <songmuchun@bytedance.com> wrote:
> 
>> sparse_init_nid() is careful to leave alone every section whose vmemmap
>> has already been set up by sparse_vmemmap_init_nid_early(); it only
>> clears section_mem_map for the rest:
>>
>>         if (!preinited_vmemmap_section(ms))
>>                 ms->section_mem_map = 0;
>>
>> A leftover line after that conditional block
>>
>>         ms->section_mem_map = 0;
>>
>> was supposed to be deleted but was missed in the failure path, causing the
>> field to be overwritten for all sections when memory allocation fails,
>> effectively destroying the pre-initialization check.
>>
>> Drop the stray assignment so that preinited sections retain their
>> already valid state.
> 
> Here I go again ;)  Are there userspace impacts?
> 
> AI review thinks it found a different bug:
> 	https://sashiko.dev/#/patchset/20260331113724.2080833-1-songmuchun@bytedance.com

It speculates about a BUG_ON that we should easily hit with hugetlb
vmemmap optimization during boot I think (which we don't)? That
naturally make me skeptical.

But sounds like something to double check independently of this patch here.

-- 
Cheers,

David

