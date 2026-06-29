Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 182B9C43602
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:39:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFDEE6B0092; Mon, 29 Jun 2026 10:39:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD6376B0093; Mon, 29 Jun 2026 10:39:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EBD56B0096; Mon, 29 Jun 2026 10:39:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6C7CC6B0092
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:39:57 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EFDD2A0138
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:39:56 +0000 (UTC)
X-FDA: 84933209592.27.8AE9232
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2C11920006
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:39:55 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TOeIjCfo;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782743995;
	b=cc/dw7kF9UXpCfWuQOXV6gVP2/zamWdBdoOPGk+aoScWjvtFmsA0jj5I7gU+jGIP5raeUd
	hZ4Y2HxR2I4+f7P2+kOmigV+YsJ3C0Uo9wqSJmUOwicAMHas5rAWihdNCv51AgGgrDBpZo
	ETkRSpRX/JNOgoDoJCHyfVyD1rKr3Bk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782743995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DuMKsEYZ05nT54sTSWEYfjRA4P6TcC2zt7zo2qBxmsg=;
	b=RSH2uCN4i21qBd+k6ppvzSiyvijdOOSFS6B98nnzkVpUYVPTIj2QTXb6T4+F5e2iCgdqMU
	b2JtrJuJuxLqNiOJHyCHcTt10tUCNu5/nrSdumb1Dg++c5fJj2XP8qTsfrxgESfkRSTxN+
	dP0Yj0vk3w7GJjHlxl6ui0N+ErNnTsI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TOeIjCfo;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 69B6D40DAD;
	Mon, 29 Jun 2026 14:39:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB0DE1F00A3E;
	Mon, 29 Jun 2026 14:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782743994;
	bh=DuMKsEYZ05nT54sTSWEYfjRA4P6TcC2zt7zo2qBxmsg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=TOeIjCfo7zMwju0FALvWyC88HY2iC6CSLAq1JSqWnQVPM56LbgIOLWw8ZJ0QjD/Aw
	 ozj4+rV5s0LPKS9cLaVzm4p4LzDe0sF4tCQfs9InvJgTGjzJ0YmxKImfnnhIqZZ8HE
	 JVfKMA00m3ibwyDTuIffRXNts75e4qXrgb1c5kvObwIIvwfLnZRwS0x+NMMXjTwATy
	 qYLFxu10DJrCQwvT1ghLjXlFES2/a4LNlLvyTXbfiskkKlr3wPORTGmJfTq1FL4qzJ
	 7H2t75310lRZtbCuXuYXoQ0l384A/TjR855SDyWmmsLLOkt+wwoCHxIik8SmISMtpL
	 xcOtdxOD+t7lQ==
Message-ID: <9fe5173c-4beb-42fe-8f7e-385c609f899f@kernel.org>
Date: Mon, 29 Jun 2026 16:39:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] mm/huge_memory: add page->private check back in
 __split_folio_to_order()
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260628-keep-subpage-private-zero-at-free-v1-0-f4ce3930d10f@nvidia.com>
 <20260628-keep-subpage-private-zero-at-free-v1-2-f4ce3930d10f@nvidia.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260628-keep-subpage-private-zero-at-free-v1-2-f4ce3930d10f@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 8gb9g76yw9nqozpsojttnjag1fr8fe6o
X-Rspamd-Queue-Id: 2C11920006
X-Rspamd-Server: rspam06
X-HE-Tag: 1782743995-298700
X-HE-Meta: U2FsdGVkX195gfTYlgA9hIpmmgkNxY+JLoMmjFi4KTkQNmvEy/gm5octI0fhqW65irQ4iF+sEZJC4kkOgm5Khq0ZEggK7tuE5ZTk3cSdGbbb0MwdwI9CD4PTC4Rav7X1X9Iy8Z0CMCDUFnXJpSYcZGuhD6fGakBwQAO2WcO/U5XJ0ctyop7YAZrCVdHi3gq2FdOPoxF+jp2Yy5TIdrkik+ZNzQAqpp6w8usOh6Mwgn8pGbny4iyaynOHEOFsvroEBegmVEJtMInGu7HV3C6gJ2fhojA64u7tCmW3f6Hd/w1O+04FLShcB1UKi+azCfk5BhG3VEpDruJd9xN2Ao0nYZukh2FjNnEK4UJ/4GEcvJLnN5gZIS3f5zSK0oLlMqbN+26FBJSVqLTzdq6TV+tVoNm7dqGTS4hboiky9EZ/juWLRW8qtWeT0t+RaqsMUICfbc1D0Nkvzqx+e14ahplFa3jnvaqlJMpvhPnH46TP5krdEcWZy1YxrAfgZUbLDeYnXQ7gwUjnrMBd8z9jqSwrs2mBLmEAnB8PhQhPM33Bb4z/BK1T8p8Re6wy5np63swpyOphaIWIoyT85eXD+u4DifccJIoBa1UZC1wxc/4IvZikPE1kHNfE1Jlyjj5HoHn6jl/Ry0wQ06ju3mN8IGRjxutJsD3omIXka0aYyqWr/mhrIEHj2NqSLmljAk4e8+KDLbk0i4C59cAleKz3t/xOIoFsixDs951xhOdGB88YAyNDOiHqb/EMCIpcJzjwhzSfwVw7foHq+gUO8fJVSDoRHoFJErhFpMEcJ08ZkUosiRp8IjKE04WOD/czchPXkwtDLH/pFkYMiRxYn7+uDFrig8T9dfLs+j0tF81qT21/LSmDQlSiM5PcXxFKSN8Q3J41xf1uJWxOfP3neHk0gdvlusdnJbqCA7SfLlfiVgjNmc+La2zJdvT+jyksw0Hcj7Wu3cOtanuys8GnzEHABzU
 Kt9XkAFS
 AXZXZ6FFHqW+ge9b8W04Mdt6+gd8Lp9P9zddxt8gfiERoEadxSsl/xDqOBF77TydKBZLzl7wGvHWBmaBSX9DYvc0SsUAo9cooeI+c3W4xALcJrhLG6ygLNPkKf8sZ86jZT2eQ7rVZ8qK8B41GsQOFDn3SvDAM+hISbOM6MiYYSzS8HTuz3HqHusQY7QSu/P4xiFE/DYDNSl/cksZKaGT6xdC+mGYezRlKJgSmE+maQy8UXGcWJN8nQyfJu8ujWpldjavZ12BUnT7/I2vVGZlQN0DN4wdJrk8LbB+nxq8yVC7G+S1evNQSsIk7pH++EnbIFaFP2JMnKDRQ4DQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/29/26 04:56, Zi Yan wrote:
> page->private should not be set in tail pages. Commit 4265d67e405a
> ("mm/migrate_device: add THP splitting during migration") removed it
> without a proper reason. Add it back.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>  mm/huge_memory.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 2bccb0a53a0a..037d67fbec6e 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3594,6 +3594,16 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
>  		new_folio->mapping = folio->mapping;
>  		new_folio->index = folio->index + i;
>  
> +		/*
> +		 * page->private should not be set in tail pages. Fix up and warn once
> +		 * if private is unexpectedly set. Do it before swap.val assignment
> +		 * since private overlaps with swap.val.
> +		 */
> +		if (unlikely(new_folio->private)) {
> +			VM_WARN_ON_ONCE_PAGE(true, new_head);
> +			new_folio->private = NULL;
> +		}

The unconditional warning means this is not expected to happen. In that case
it's odd to check and fixup always, but only warn with CONFIG_DEBUG_VM.

If we are reasonably sure the current code is OK, and only want to catch new
mistakes in development, we could just VM_WARN_ON_ONCE_PAGE() without fixup.

If we are paranoid, leave it as it is, but drop the "VM_" ?

> +
>  		if (folio_test_swapcache(folio))
>  			new_folio->swap.val = folio->swap.val + i;
>  
> 


