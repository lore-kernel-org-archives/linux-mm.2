Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46505CCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 19:50:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2AF68E00E4; Wed, 29 Oct 2025 15:50:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A029D8E00B2; Wed, 29 Oct 2025 15:50:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93FB78E00E4; Wed, 29 Oct 2025 15:50:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 833AA8E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:50:29 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1C4DA12B41C
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:50:29 +0000 (UTC)
X-FDA: 84052193778.14.A4E92FC
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7D1431C0014
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:50:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=IaH0WiB+;
	spf=none (imf21.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761767427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ywMRa9td/qLYvz0QLFt/dHlJeUkQz4iWrYlNlCayuSE=;
	b=nDZXHCW4b2/y3VagzT7eyv5tjZXf086lSPQNBxnZsrLHKBEEyOLuefAykqGJbiPLIgRF2L
	3jBE3TvHfsiEs8D6z2zKzH1/qu/GCvmuzivltd68Xoc/sJyEIbjtYWA+3uPxlqYN4/JM1c
	QZne8pvW3lBlzEW+Kh9KONsf/ivQU1w=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=IaH0WiB+;
	spf=none (imf21.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761767427; a=rsa-sha256;
	cv=none;
	b=UJQ+JerzHORVf9j3En65TgV8dfLbQqJNrOsPhGmpyh9AXJFQADG9x+c9pYRMitBwwm9YBC
	5IdIZ2hSpY9f+J8TL6yDqsnE94Fm/xwWBLy2nVIE+fcjMpE0H59UrAE332CjPgScQjG3Ln
	l5j+GXmyCyY0/L7Gci/BFGiwM0KLBuQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=ywMRa9td/qLYvz0QLFt/dHlJeUkQz4iWrYlNlCayuSE=; b=IaH0WiB+Bb8bae/n25tIQisGQE
	EwhH0nUvAY0WF68tV+bqAjeM5vt1+TFM+p9SWhDN7SSKHd71InQaX+spzoIsKsfRnYzLiPymBfv8b
	G0YUSVRmmHR72tbVjz7S1JCp1h94cR+krcxjkfnjWvoj0qzTCwutfhbayHRtPzVCrp4DBQP6QMP7E
	/5l7sL8Z4TbLmfGLBzrYSVUcbZopibwGw10l95Xv2hyvw2OljCjZDfVaA7JzI0kxcTG+eF758lStl
	ZwIQstpTPU88RRMUCb5P0e0hsxC1roRLf9JTHYYZ9gSRvYXs7n8ZIZ62F6HWHDjILexzwXgNL7cbg
	SLWmox1g==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vECBX-00000002fGY-0vOJ;
	Wed, 29 Oct 2025 19:50:19 +0000
Message-ID: <6c273611-e815-4a4a-822d-f6e55cec3810@infradead.org>
Date: Wed, 29 Oct 2025 12:50:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] mm: introduce VM_MAYBE_GUARD and make visible for
 guard regions
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@redhat.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Andrei Vagin <avagin@gmail.com>
References: <cover.1761756437.git.lorenzo.stoakes@oracle.com>
 <7de40603015dee82970f5d37332a6d5af7532063.1761756437.git.lorenzo.stoakes@oracle.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <7de40603015dee82970f5d37332a6d5af7532063.1761756437.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wdk95qdonft8wq7zf7xm6ph9jqq6831g
X-Rspamd-Queue-Id: 7D1431C0014
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761767426-785192
X-HE-Meta: U2FsdGVkX18p0S61so96UcGMu5rY7Kpb22Jl5FOR6XYGPYvmkLElnQLycd2xmx208ynU0eE5tjMoy1f8tjTcXH/JhdJnIPzL+NcaCpcZX/Tu+wEkVTTNUE97GWUydZjBhnFeQH34bV43Bpq4jxOOkNivktmSge6Init6Sxdic7nHrTG7V16k6zANrekRpwLhS2In5uqC6vrDfKVgemTieDDEDWlzB/I1KZuc2y5R23koXlctrFuttapIvRXg95vLkq42ZSFmyJHwLVJ14k10Gx1EIK3WXJxyI0ty0oKU7c54uO7LNTPrghMpGe4ukX/b/X/DF57zIOBoXy4GXijSPvAsdsVxQQ5CEYTVoahn00I18nLCVGqiHEFe4zlgJeba6D2lccEZQ9808nTdnIRQS++kW/Mp2jP1sNOsvPvpXiu9X/iwva57bwhjSEJqd3dW0RFlr5g1zoMcHYUr6tnfcwl3meSE3BzRVc532xiUImy1yADqup8YxHTaaMY/S/4TwRGNNtCvki1sxUlqGOTi0wrNgFLWHpyCC3yZbxki+OzQmNR5MDEk+dX6n7YmlE3BsAKntjOui3GHqR21NxiQzuTREBHlOvv0Kx85kw1MEVUsR2iAxrEkhu4trIhLbzwpYz/RdpyDdlAwBmFLB4T+5ZsTHRAuGhRRBtOmEtgNRGjywkxTlR7XvIDiycMecmwLB0lKhZjLqnbSB3tpzqYwZeYW/K3i3Z1HuzFX48SODDGb0WKZphcWak7XVif2ckNzlDsdmnA7mnmeqpvj6v8zIn3WUVeD5yv1ywgMNDIHTKmzS47hmlF2++XMqMnEFUK4QhFhvXrBGdP+4uMwP3+OgI/spuxoOuK5rLeOg0QOJ1lHQXW2QbElxU/4iq3q4eHDMU/rchfvDI65vtEKdpGmbweAmMeo4ZEu36HdTMPdPhDKKD+H+LRhz/hnqZyM4gTFyy70r3cABaw3mp9r5ce
 VXOx1uoA
 Yv0mjTdnasiJsdjAxiQ1d14ecdqneVNG8f9Bgr9huHQMqdv+Mi5Kw/22hYYpTN30PE4yvdpV9liQvV6pVNaTogsM/g00lu56uoL2o+zAFGCzR/qDn45eD+Wdh7C87TkYXD+GMgJU/TfHP4Z8nhDfSa7+tCvUWKH1nW5YV4dCUD1Rrf7BFi/JMIfTf3SDVdI+AvL8K3hKpQGNwyrPqf7FbcmLrY1r489NBgwr+Q5qT4lHQVqguoAW7g6joiVvsERIjylBhu1wELGJdCF9XmoPVakxYKxdrQfMTCuA7jKsz+r6X4lur9neYFtPWWJZW6y5hlLzmSQFyliZbnW7hbjbE3lQJjp80rBcf60ZU1bErKw3evQnW5D+Rjk8DC95OJve1dhL/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 10/29/25 9:50 AM, Lorenzo Stoakes wrote:

> diff --git a/mm/memory.c b/mm/memory.c
> index 4c3a7e09a159..a2c79ee43d68 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1478,6 +1478,10 @@ vma_needs_copy(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
>  	if (src_vma->anon_vma)
>  		return true;
>  
> +	/* Guard regions have momdified page tables that require copying. */

	                      modified

> +	if (src_vma->vm_flags & VM_MAYBE_GUARD)
> +		return true;
> +
>  	/*
>  	 * Don't copy ptes where a page fault will fill them correctly.  Fork
>  	 * becomes much lighter when there are big shared or private readonly
-- 
~Randy


