Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AB67C5DF9B
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 14:43:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42D456B00A3; Mon, 24 Aug 2026 10:43:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 403856B00A4; Mon, 24 Aug 2026 10:43:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F2DC6B00A5; Mon, 24 Aug 2026 10:43:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EC6B56B00A3
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:43:11 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E2847A0171
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:43:10 +0000 (UTC)
X-FDA: 85136430540.20.65E7892
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2FDD640003
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:43:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="AlKZbYd/";
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787582589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5GFYVfLZYq0r9iG/4b45yVopptA1WJO2ICLEgAVWy20=;
	b=fK9qeJ6nHFBos6SZuVF5sEjWnmwAhgkyk1rLwubrN00wXp19xwfB/Ux8AOAUBxnk+DyO8m
	/51k/YEMJyIv+A0Fg9ByK8h7PW6vchZaXkw1tVl4uAasAasl4SouwhmWPUAcjjTWF/rXxT
	De+UFsGh537A2UzANBorRRHF5BKmVok=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787582589;
	b=bNLtSEpijm2UgIWSBDqgmBRLHgRrPgEdfZJi8lGsoXbvo6OS7ITVIi5VyW6257V9/2RQ1D
	eZq3SvMWHIW4cuC7uL0lHkvP6VUzHwRUJ9VuNWihHBXNcyZASqkOPMQ5o+EAWj6DvkM7AL
	hxNH6vPoavU5iUFrfcUaLYyMA2bXD1c=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="AlKZbYd/";
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A8912601DE;
	Mon, 24 Aug 2026 14:43:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67481F00A3A;
	Mon, 24 Aug 2026 14:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787582588;
	bh=5GFYVfLZYq0r9iG/4b45yVopptA1WJO2ICLEgAVWy20=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=AlKZbYd/gqBhPNOz0AiQSA5mSiZNAp152sXk75N5tzoj3r9OArCGiokUa5lJlbECv
	 kGcLfrEbcc/udWmZyaV+xn1HkZOqfnZclpvBRYNSva5ti9gRALHmFgNyu4N+0fbvBb
	 qYNSK5GbXErmmfTbmwW0icgbaJUrXaWKSn0Y2aOjl1+GCSWFC7oWQRce8X4w/hvLz7
	 /MHrC8412hiwVSlIvpgO7P17LK6BQsE7abz1FLlMbgR6bVUWr3xen3L4JyWPcteWoY
	 y6Fb0DpI4A3Ec3MtKksPc+/+fV6SncEL0acQxdu9SXApgnX1dBs36j7v4N01XLJ4Hl
	 ioL/51laT+d/A==
Message-ID: <a4650e75-ae01-418a-b695-f8bb15c5d7db@kernel.org>
Date: Mon, 24 Aug 2026 16:42:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] mm/gup: move gup_can_follow_protnone() to gup.c
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Jonathan Corbet <corbet@lwn.net>, Lance Yang <lance.yang@linux.dev>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
 Nico Pache <nico.pache@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Shuah Khan <skhan@linuxfoundation.org>, Steven Rostedt
 <rostedt@goodmis.org>, Suren Baghdasaryan <surenb@google.com>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Zi Yan <ziy@nvidia.com>, linux-doc@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org
References: <20260823-uffd-vm-flags-v1-v1-0-3086981b33cf@kernel.org>
 <20260823-uffd-vm-flags-v1-v1-1-3086981b33cf@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260823-uffd-vm-flags-v1-v1-1-3086981b33cf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: yhsjnqi1rb5gz3nx1mrdqnyohrztkyfu
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2FDD640003
X-HE-Tag: 1787582588-395942
X-HE-Meta: U2FsdGVkX1/yVy3gxj0OQf1zrf82sHjDN7/UkUIQMIMVzhIzMO/T8kbwsiMihaF7bKwwLnOwfYi+QtnBLCmbcr27Onmw0SoGtKarabBRcD8+mozS6x7I/lKraKsPjz7jsg+vgL6225QokedEBGYfVwxASHtUOGHOrX4mhMkKVrOejdfJ3Gogp9OrBSnlbAscjwDZbg7gSsutACiDkAJcnK1r6RcXcA8nfKqfgxVcII8K5DyHVPvBf8x5/cZRxjOeGBpVJZZHHi5f3qx4z6bnFcK7aGouyer94DWUaqRQn+6fLzhoyYIFx7co9Z23NKaHP2MR0pq+Mbr7jNklx4Ze5aoKJYnB9LuNHs5BlcUdYqP4oQIcrje7Tnz2TwpecztW2CFpgLBOaWpdp0PxCwpL88hSiCCmkgmYEnib4r7ZqKCVxHnhcUe+YQsIlWzzSgkInts1AHzgMITSFXs3OeiGXOYsu4/G/itObzY4gLAv6z+TnEQ70ek2QlD+HMNJxGCTBRDsDduwQfvOE+2skhXugEpCKYHcva11aUXLVeggZNgOt9A2Tiu3e3b090a4rt2GjdObEasSa1sch4IYz8AhosP9INGn3483sVeGbmteF11gP64tImdnq/8VL2sUPeenUXJyUpcASuzQ66gDCYltIigiT96ZbofapIRh4OkFYnxUOOs/8jhRTsS5dWEwK9PgGST2T53YF4/dXrrSgTU8/vzPIaDf7y27jDLjxw8ysstFv1LmZpDAoXbVjA57vtar9e1cG7Cnh5cOzgYWS+XR99xD81C7qnv44o/8/vjXD+/YX7dGdeKqjVmOT6DkfRL3iuRM4Tc1mZoan4FFLTkJ2v7dCwrQz22a7YxA/60XETGaXsIglTKHps+ClkBI+ciiECwPrxAH+WYeSZamyrdc/5NFwjcAtH8RUW3B2zxuq3o1dRI7zVY4aBdCNgRsRKEEHcTPjcd2+kHAMSfQ1X5
 VLMcNU3v
 pHvZtgGhTeoYolNYhw11BXwcn9VMzs84OLXg+QMWeD7fiQQOj7m0PHPiMDnFZX/LRloox3eCvL2a8a+K89LrGuBDeN28pT6B48cd9ahLuyyB2yJHvW26uO9ogr4lkKDUOpkWZLI2XLnIFUAo+UkNxAnxl0LCY2Fano3w5nE8dHfHYWCPQLGEbnWZZ8aUx0H1hCDM+SxQuisRy3kzeNK2nHXU2k6TW+UAILLvLrfb16r9ICsf64fZDsucCKiFaEnPwXdLnNNoxfGlj8WYt6oX/Ij6KrsC3bj+ZvIzRZed2ftoRudEl9leic549zIVQYRU4utkWH0ff4qotQgE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/23/26 14:17, Mike Rapoport (Microsoft) wrote:
> gup_can_follow_protnone() is defined in include/linux/mm.h but only used
> by mm/gup.c.
> 
> First, there is no reason to have it in already gigantic header.

Once upon a time there was a user in mm/huge_memory.c, in a beautifully named
function called follow_trans_huge_pmd().

> 
> Next, the upcoming refactoring of userfaultfd flags will make
> gup_can_follow_protnone() depend on userfaultfd_k.h which would cause a
> cyclic header dependency.
> 
> Move gup_can_follow_protnone() to mm/gup.c.
> 
> No functional change.
> 
> Assisted-by: copilot:claude-opus-5
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---


[...]

>  typedef int (*pte_fn_t)(pte_t *pte, unsigned long addr, void *data);
>  extern int apply_to_page_range(struct mm_struct *mm, unsigned long address,
>  			       unsigned long size, pte_fn_t fn, void *data);
> diff --git a/mm/gup.c b/mm/gup.c
> index eb898ea1ee22..500e2aa99e48 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -633,6 +633,44 @@ static struct page *no_page_table(struct vm_area_struct *vma,
>  	return NULL;
>  }
>  
> +/*
> + * Indicates whether GUP can follow a PROT_NONE mapped page, or whether
> + * a (NUMA hinting or userfaultfd RWP) fault is required.
> + */
> +static inline bool gup_can_follow_protnone(const struct vm_area_struct *vma,
> +					   unsigned int flags)

While at it, could switch to double-tab here.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

