Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2D2EC98307
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 11:49:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D59AC6B008A; Wed, 23 Sep 2026 07:49:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C45DD6B0092; Wed, 23 Sep 2026 07:49:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B344C6B0095; Wed, 23 Sep 2026 07:49:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A1136B008A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:49:17 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2283214078D
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:49:17 +0000 (UTC)
X-FDA: 85244856354.01.846EAC4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 560D0160010
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:49:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P3itmS9D;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790164155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IrKtYgcQ0T4jKisEUBPTEtTxXdK5/Ke9cqOepOoNaqs=;
	b=GtyOh6cA88cyPAiK/srSVvGxr8OJuciWu49tNMv/NBG/IaLswFSgf3z04QDw6ZYeOLoYg5
	1VjsTLp7TSfTxzPi2zlz7pRvZh7G3xXZ1sENx1xmbrL9IVMLgEEZZfz5Akw1B3sZuLNJIT
	vqtgHJT10B6zuOz7niuLtBTakGpy1Qc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P3itmS9D;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790164155;
	b=K294roiy8rdM/SgQnk9T9zG7inACkmAmXqvhhSTFbvONdYutHxr01mIwrcJP59MkzDL7HV
	SLUrWoeQ+AJL302AmAaje0xhrJw0Hynr1STlqmuF6sMJE9WuCE91pku4IjZ2Rj61S82E4i
	yc9jcqnTAQKpDCyKHJn6fReDok7nwcQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9CCD7438D5;
	Wed, 23 Sep 2026 11:49:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A87B1F00893;
	Wed, 23 Sep 2026 11:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790164154;
	bh=IrKtYgcQ0T4jKisEUBPTEtTxXdK5/Ke9cqOepOoNaqs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=P3itmS9DYDgDvfmikjcmWFEWfC3t2tsMqi90IJRsateiPfyLk3EZCln9rBwA91Fqn
	 kphRQKpGSe5EllQFSR+9I14J2v2QPB+m89YtuyOAx2J4mLHbQJylW+39m/4D6sco4A
	 F4KqHhUjTE+hE1zJoAOdKqBDIOnUr12BOjARC+aO0X5sA8ThW5YT/Om1TMiimvdqPm
	 pbQlZBdNYSlYJkDtwpxPfQgyVqyK3SKDQ2I4O8o95+z0v5PCI2d5fVVIsx9zz4kyBE
	 HoXnHLuUStIpFWjBkNu2AhnMliq6ww/8ROzW4Smq5gjRiuTlfxEXoqx2XepkT6Ym/D
	 gzrS3Agl7QcrA==
Message-ID: <3d8f4dac-649c-42e0-8b51-437cf6cc65c2@kernel.org>
Date: Wed, 23 Sep 2026 13:49:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/12] mm/khugepaged: drop redundant mm_struct pin in
 madvise_collapse()
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>
References: <20260916093145.4022188-1-kirill@shutemov.name>
 <20260916093145.4022188-2-kirill@shutemov.name>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260916093145.4022188-2-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: kephi893u8j73y5ud66oxe4j3wiux9dn
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 560D0160010
X-HE-Tag: 1790164155-111157
X-HE-Meta: U2FsdGVkX1+/4Zh7798gXgeIcgs2tC+PcBnCDV5TGWRlVtNj1XkddWsjIvRmg5hhfqcvY12cD2NkrYq7xqtC3j3SZ+WZWcERNJIORU6xET6anBnv9bnoHpHNvyqb/L3WY5CSwKU/IvdXtJc3jA4ALViF7nGpA11mY1EhYcsLZXd3Zf48lCAvbWeXqwXitGgwoPIumpKsQ5puKx79yfMDA26oum3PWdj+byFxJviJQ/wD+RVfzt1//UYbQG9IBKdYSOYPkIBekIzLOx8WEVub22lX38CznJHyNCQ6jekBcE8vL+XgyrDa6RZG0LUzQk4qxiqm1NoJya/a2GeNoLAF/0CVCGpRBrG2xn57IJCljBbvhU0+FJjwrdIdavPa4NXq+yAyaDKy47tW1c1TV1CIVGKtd4rwa42Nt604peEAd5U8tt7qhDk/cakRTtqT/19LSO8QmSqNyxWAy2BnrN6+FAD54sbKknU7l8+Ox9IB0O5k6SvyFyIaY/XEdOIC73+vHbXc2GJS5lA/+EiZSn5qjn+nU3NNBHQMIGFKLtbEK9Ds+ZNRCmt+A79b4+0LzdUurjOm6XT12hzNh0jZ4w9lhIQWh/POtmj298YtZ6ywJrowAmHaT5GSeYDZbSViDLT6D5xhV8dNH8hDeMGHx+3Lf0IayzLzlqSHc+JT56vNelti7K0LzhY/NtgXZeNudrwvpgRztAt6XqdfLRB2oO8oSFULbBKgLIoWAGf3J12+nT5NKolg87uSdjlZ1SJHTTNVAS0pkF+gawlXqdbnbqnXWhDVWUouxZgBdOLyOjrZRZfrrAipySuvxEGeBLwcQuVWDq+iOpnVT6zmgYPYuoJZhU56RkFtZF6Nu9lzcg/d218t3LZF4cFt+A4T9B1TLzMGypH+5qy9mWkREuFFyZ/X5CYt04KzHBcbrgH37Ib7qE9KI5ZhYnw223LfUdlBvJG83QgsHUdAyM/nytibtsf
 20ttAz9l
 X5rW5QTA3e2piRjo1PbWQCyNTb4gmAYbq7pOq9MIltyWaeeGf/yRCplYjK1foVf/Wh96tgKrjARn6ZdBMHDo510dggbRBHvs2kk6ud2D9pELl3ynGR1EVFiz59thoXyvVG5ouTZ8lK+n9tO84UQP5bzzlItP6M0M+Mpg7ZoVRtiMcVdb/f6pOIYpeCwT9ZbJdBoJFf77PkDthRW/gsqmP5USC2VidHBRjgGkgn1hqNclCIn+x8wNj1JXDK6PXo6lNRgqulaAxGN0mrm7l2lOms2Fhcvf8Wba0mN/kqWYk53SL5ctFTu0+nAMCEbhlgJxV13pAxPT3Wn7BJ5DYJ6ntdKHrnlp01xRsxp5codE3gKDB3rzhP5BjdlWEJJqMYaGP6S1T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/16/26 11:31, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> madvise_collapse() holds an mmgrab() reference across its work. It is
> redundant. Every caller already holds mm_users:
> 
>  - madvise(2) works on current->mm, which lives as long as the task is in
>    the syscall;
>  - process_madvise(2) reaches a remote mm through mm_access(), which takes
>    an mm_users reference and holds it until the syscall returns;
>  - io_uring passes current->mm;
>  - DAMON takes one with get_task_mm() and drops it after the call.
> 
> Drop the mmgrab()/mmdrop() pair.
> 
> Assisted-by: LLM
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

