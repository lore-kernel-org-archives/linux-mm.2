Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DD4CC55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 14:57:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EB8B6B007B; Wed,  5 Aug 2026 10:57:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C2536B0088; Wed,  5 Aug 2026 10:57:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DB836B0096; Wed,  5 Aug 2026 10:57:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4B1656B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 10:57:33 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CCD53A0505
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 14:57:32 +0000 (UTC)
X-FDA: 85067519544.18.AE67F19
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 238BF140012
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 14:57:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VnXHPtMq;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785941851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=55aaiUjKWOrtrGUzA5Q+sUeIf4OsAtygZvkP64CqPJI=;
	b=KU5KUldTy6j6PNJ4DBeeGdmfmrIazcv+SxpNwN0aHriNxc5IZobSD2g8WopTJU7YdIvSgE
	sIS1idZu9BXmSuD//6iLqbIl+0BgJr1wYxjOyQ4vikk8HiWyFnc2e/+3geTs2aG0Hex3rF
	I6GWuwFB67m8J7KlHW4sEhd8oI5AlWE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VnXHPtMq;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785941851;
	b=QkBkgEClfgC7ekKpHEYO+Wt96I48pRN2KnmwkXakJtY3tjdGo+n+A64epF8JOnsfJRnixM
	fcJhXGz7YAuwSu+4lhRxQFMVn+v5TyhYJg09yulHR/io1q/77kaXv+hMrDVkckBpp4YO74
	mViy2mk+px4XiAa2O6W+doAjM520yhY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 642FC600AD;
	Wed,  5 Aug 2026 14:57:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C1251F000E9;
	Wed,  5 Aug 2026 14:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785941850;
	bh=55aaiUjKWOrtrGUzA5Q+sUeIf4OsAtygZvkP64CqPJI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VnXHPtMqMZkQnCma9lE4YC3bejdD/ekGRDbqAwQ4I3dQQeHj5WVMh3y/o6jiRAN+3
	 K6BJcdBum4vn4P9UtPTB719n7a46ImGz4TY/cqZBSFgf0C2tcZJvi2zrMWSUXQWm4v
	 J8qkIbdB2SF83lKm6/2WEl9By313Dgchw7Glw04Am2ySq6t7Zg1NcA2lZh8tMPMaMV
	 dwekQ2RA5fxCAArlhoEp0G65BILXJ99b2xf4u5/huDv6y9T5wWREE5Kx9ysq2Myk2x
	 89xdweT3c7L3gRxjxrQoafFqVhVwcihQ7zf70kNUx6d51muTNcXsOUSj8ONo5oMdJx
	 lc5AolS9mOk1A==
Message-ID: <08affab3-3f34-4eea-ac47-a351a36217c4@kernel.org>
Date: Wed, 5 Aug 2026 16:57:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/sparse: keep mem_section_usage_size() internal
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-kernel@vger.kernel.org, muchun.song@linux.dev
References: <20260805022536.1206575-1-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260805022536.1206575-1-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 238BF140012
X-Stat-Signature: to4exmfx1dqboinomu76b5ue1frqoxf3
X-HE-Tag: 1785941850-682487
X-HE-Meta: U2FsdGVkX18pYo75u4iBY7QlS/8KxgfkL0WH2WKDoSjHjSl3KLbQQ8+OsjwZWjEtD+bwXezx5Jt8wKDenuImqFN+GRC+j3Fi1mD4PYHGeEHbF7ti9BQCes0ODF0fXZeLVL7eyaEy4OK/vTr0VyGUfRvwQ7sa0gU+glWCiOlC+vFkavLcWNp7KtPHKO4fC5nWvM3d1yorE9OMu6RKlBIsfRLRh+EKBbTNl3d2GAStgyYVwsMEor6QIyHrv+v+8oWHAIJSC1rsr9cGD0zVBr+vt62OjtlxLw5JrXyZ5CZFsrJJx8C/Gv7yH7mJ+/IgLG7mFKyoZ29Rggob5IvesNa3RtoK64pYoHkFoUl3mYxmoJuiUaIlPiY8SRLC2lZsyWvRLojBNTrhKkQtnvJbL8vo2koY2CNgM1wbHUGKGfpSzqMRKI3vaLFEjYS0fnBFD02mcn/85jbGoFH1pbfZlbdbVPQLHywl7+NPL1bbdZf4vUSMjhhrKb78Rq3uENj6EyDzX6EFDSkeN8nrQouHCPhr9v6WcHWdOXT1PszBlfA79k3BncTlLQwmpi+gI1dO+HuQcP6BIhzrCTJJLHqOfChrso0KIv5r5aus8HnOZKwtOK47OJUhrQAeFDhINGP0Qiw4ya+FVHMw6KUF4QUsyGoTqs+XGs4pXUD3koS3xpwHr/SldxNwDSQJheVXI6+wg7pT2rdk1pWHKD6zY8snVQyTZHdTD4cG36b9i0v5RPEb1UXi9P2p5PhaJub7hhGVQyCh91hirMG2OgTwo4VqGPQqpPgq1RG7Xy4FErtDxxEgPtlTENCwC7AGtxOBCtcxsqEj2X/yRNRTlwYqQAseNqIJA11SOIe4U6a2w4uaiyjzju5PhYy6HxP3/9eYrMcJexiKlBSpvTxS5P3Q1y0YTz9Xtc9C49xqQosP7sFofyj1NrcX4baw1Zy2yyb5RQM59mRSii0G9MQGK/dDfgPkU9+
 6PYXcBYo
 K1Vu8NjPpVNY77DG7XOVECgyPANMhWih+vOBK9CGIpE3HJrkrO6JnDPFP1GK8w8JZKZEpcR3Cxi+pLIVsMj739GdqQjtg6f3e7bYM/Fa4y99kaa9+HZg3jPSP9lMZ9Z+U577IwaKlWIxQfd1aU2z0h45xqNOn99OPD5ox/SJOfZH1BkWANgIUvQCDkn49N/w8HjqKmW/CQO+4n8E1mHoS3Fw5Lo0Qvr1MfIeECPbggwfYvpvN88a7kQu5OQK9j3yMRwVd0QssiCkKK33r/anElwoActWFfGVZMfDGb8rSAPkWcrLMIpm0DI/4uyKXfncRgJirseQryjcKJva3KgZwpjGQ25OCiXX/VKNY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/5/26 04:25, Muchun Song wrote:
> mem_section_usage_size() is only needed by sparsemem implementation code
> after commit ae751d567baa ("mm/bootmem_info: stop marking mem_section_usage
> as MIX_SECTION_INFO"), so keeping the declaration in mmzone.h now exposes
> the helper to all mmzone.h users for no reason.
> 
> Move the helper to sparse.h so sparse.c and sparse-vmemmap.c can share it
> through the internal header. While doing so, calculate the allocation size
> with struct_size_t(), which ties the expression to the pageblock_flags
> trailing array instead of open-coding the struct header plus bitmap size.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

