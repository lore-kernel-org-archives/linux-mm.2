Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14FE7D0D15D
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 18:25:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AB7E6B0092; Wed,  7 Jan 2026 13:25:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 458456B0093; Wed,  7 Jan 2026 13:25:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3648C6B0095; Wed,  7 Jan 2026 13:25:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2342D6B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 13:25:33 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D6E171B7DB
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 18:25:32 +0000 (UTC)
X-FDA: 84305995704.17.75062EE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 25257120009
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 18:25:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OYdJTdxo;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767810331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+F/L3ERjh8QxZKnOLN9I6OfgyjPdOlWqTYWA6fO153Q=;
	b=ro/yOkx+YhVYxIyBKRWV+xDMipq/u5l4jofda4fJ6P5rBVesZsBdwFN31LEr5AgC1FLiVP
	6E9XdwrWkcEasq5aiQE1ly25c1u6fzGPiXkqtgeExlUHe0Ql3LTKCgCDq2MLG3eYSySttw
	h4zCY39qc57XvgjcmoDMppy5JrUUYmM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OYdJTdxo;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767810331; a=rsa-sha256;
	cv=none;
	b=W9QNgjQRc0Q+ZAYFSRzwtf7ByK+juSJfVRIDV46a71epN/DNwEA9God4FcNt/+jULwLk+B
	H1QhpbX/D9RbuRAfPMURgYEP5YQ+JqR1MD9UMKTe9DvT/Q+o7FwNfEu7RXEkC2lkK2H2zy
	WvxBcG/oURJVqvF/XiCurNJyLDAOv10=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2789243999;
	Wed,  7 Jan 2026 18:25:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CDD5C4CEF1;
	Wed,  7 Jan 2026 18:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767810330;
	bh=fUoonsvlr9MvY5gvm4U4IfkLPTmvyS2x8j9fCFzYFvM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=OYdJTdxoo8OA3i59ZwD3m9762VjdIbo4AYo5UrE21o50afNAVHGkWkuY4LjRH0faR
	 G+9k461XPQIos6rhbX/FQYzL52tTBFkwr0xD4M14umY1qLOvKLTmX4dG9mfzsC1GYu
	 dNFuaTGXQiCclV3Pa3qr0HzmWT60evnKcjgD+nrY=
Date: Wed, 7 Jan 2026 10:25:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>, David Hildenbrand
 <david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
 <muchun.song@linux.dev>, linux-mm@kvack.org, sidhartha.kumar@oracle.com,
 jane.chu@oracle.com, Zi Yan <ziy@nvidia.com>, Vlastimil Babka
 <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v5 mm-new 0/6] mm: hugetlb: allocate frozen gigantic
 folio
Message-Id: <20260107102529.5dedd2a358cfc32e72347fa0@linux-foundation.org>
In-Reply-To: <4211be25-3fc0-4395-9b24-a5ff0b3caa34@tuxon.dev>
References: <20251230072422.265265-1-wangkefeng.wang@huawei.com>
	<4211be25-3fc0-4395-9b24-a5ff0b3caa34@tuxon.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 25257120009
X-Stat-Signature: uqgyuc6a6cpa6gzwdnn6bf1u1doxwy98
X-Rspam-User: 
X-HE-Tag: 1767810330-790094
X-HE-Meta: U2FsdGVkX1+sm+sqPwR1zGvVdcZc2UBhFslI3bYh4z+r9sRQZho9/4Tms3LpdLbce3aBS8q7a/enlloIrim58d7iqtSr3ioUHzSRa68uL7bSQORlDoRy9rzm8NY0mwwtzWgF2RXbJx94k5L2I4qEeVe/yHh67Qep2zXpKC6uRpCAa9x04fYaYpY8Z55AqKDXFktpgARrP3BZsZQJC4f9ebhgbVrH1tTPYjAWPUW8f4369q4rFMntBLSGz0QR3jIrV2xd7I9OaPi1cMlelE8uT142Vl6ckAIv22XJjV4A7RTfz61MEDTwtCskPn9IBiUsCNHyA9PcVr4/90L0y4MycB117gCNrUDGDXRX6+De/YpcxLhGqvz3ASmXV5p0SNHYW5VTRcyMgbkBA38xsdO3bE8+ammwM4B3AKX0ILVKAebDzwnmV0hQYAh97UHZHkZAA+i/pVzdaQ60Bd+YBmaKY/CKifr0ffcjhdUyQqhU4cq53HQstQdH/Yl9C/J2m0fEMi044Q/HkOEO+p5LgZFZxIwRcDPCo4SmB+eylKHYWjy6/FgADA0DFmjUlcCoIG6ek54Pn/OkTmD47kYb3z6bdHsoR8hlwFHkjAABgZP9syETVnqMlef3RT5F2Egpqr6JPcmb8ADujYOd0kDXg7vPIU1S5mE8kTivPFUer561NdVz4066W+z1BhK+Xi1MUcnoCdvtcKDNrJT/mNAUQPJ/7aHTmgt9XFGl5Xyp5nckDxBRDWIv+cwbK0cXoRP/SO/3D8IkMBPsAsHgmzpNk+S4HW2dkDL5KDG1GQ3LbKb06uDuecSZmhxODfNZtLeDWJOkqTv5X0f4SxH3odiREd8cjmR5roXQJc0gUogjz7w+FNJKDETCZloK8Dz3REBkvmAuBhDKmK0RNRYGVZNtOB4sNJ76Xg7YdB8LWiYtKTeJ/8IXf+8OTIcqM0by7TVOM8OsoqdhQ0X5JeU/21B4gQx
 LCAV0On3
 nuojuws4hG7DGE3Bs0ZmNFn1binqCOzUcHHj6/MfUdmYq+WPSw39h//asCpTZPoYas7AArZmw0eEHNNkt3UB4hOnky/nSPQAVQLK/y9iX2otK1KHPXNbYBuLihtGR2YV9N6LeH5/1zBI+iEnh8roXcxN23FsQI5LxEd6xFZIYeM+VNkWihSfHPPmzLpkseEpBo3lkC1g9GUq6JkRQnWiM3WidksgnA1XQh9XFZhFPxqvJu1+y83BNlXWDGRtGTVc7rrqx2TJxJiZ2sXn03+7BEtgrHA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 7 Jan 2026 19:31:30 +0200 Claudiu Beznea <claudiu.beznea@tuxon.dev> wrote:

> On 12/30/25 09:24, Kefeng Wang wrote:
> > Introduce alloc_contig_frozen_pages() and cma_alloc_frozen_compound()
> > which avoid atomic operation about page refcount, and then convert to
> > allocate frozen gigantic folio by the new helpers in hugetlb to cleanup
> > the alloc_gigantic_folio().
> 
> I'm seeing the following issues on the Renesas RZ/G3S SoC when doing 
> suspend to idle:

Thanks.  For now I'll move this series back into mm.git's mm-new
branch, so it will no longer be published in linux-next.

