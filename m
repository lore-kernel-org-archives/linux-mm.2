Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F135CF64BF
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 05:49:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7E516B0010; Thu, 20 Nov 2025 00:49:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2EB56B002C; Thu, 20 Nov 2025 00:49:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1D366B002F; Thu, 20 Nov 2025 00:49:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BBEAE6B0010
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 00:49:09 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6E593C070D
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 05:49:09 +0000 (UTC)
X-FDA: 84129907218.30.8D80DDD
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf06.hostedemail.com (Postfix) with ESMTP id EAC80180002
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 05:49:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GvOQbs2z;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763617746; a=rsa-sha256;
	cv=none;
	b=aIbOxp70zMYN74TFX4udbPd6rRJvIoQ20IVG1EdjVnYgIhEXb4RqCGJelhtijjZU+nvMMD
	RFwRhJSCKg/WcBOrryxD/DNNjBBFz4/26wtSe2mFLNE26aXbnejsG3OFwao7DumqOi8j1y
	heMnodRISJLM0TPt3uwcxP5MuTdKeQc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GvOQbs2z;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763617746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xHYXCj+PBmqDHq20QynsVeuFscEdivmHkOXz0KSXfp8=;
	b=r7vxFkpEfwsiog7uQbgMAlzCn40im500l9/B8eBfVXGmSv0zfWRa1vxawMMjuGKCt/lrKq
	YPRNvJNzYFZHfyQaJMAaALhZRPGnxtTdqCS+19AdNw8i4SLFQdXGtnWiubbL8Ti74ptzHi
	nO1aAWV4bXbkpZJd3zuDkj/haYg49Uo=
Message-ID: <594f5fdc-567c-443b-8bec-313986bce9be@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763617742;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xHYXCj+PBmqDHq20QynsVeuFscEdivmHkOXz0KSXfp8=;
	b=GvOQbs2zmSPWZv/p9mDvkSsQ6fkjxisB/IeYsK00ktF6cjhDx1wOZ2BcDcuJEyqdUUanzP
	QeHfedJhQbV2UHkvzxh7TdAf2BD9vFqBzYQ3IMPMglOfvAlJ4zmk7w4rq1kz5ysOLkK9Ez
	QGFRlpNAOkuAX+IK9Yw1wiWBOa7KtJ4=
Date: Thu, 20 Nov 2025 13:48:49 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4 1/9] mm: introduce VM_MAYBE_GUARD and make visible in
 /proc/$pid/smaps
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@redhat.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Andrei Vagin <avagin@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
References: <cover.1763460113.git.lorenzo.stoakes@oracle.com>
 <cf8ef821eba29b6c5b5e138fffe95d6dcabdedb9.1763460113.git.lorenzo.stoakes@oracle.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <cf8ef821eba29b6c5b5e138fffe95d6dcabdedb9.1763460113.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EAC80180002
X-Stat-Signature: 41eaqbdme6kuod79e4i1nrai54jhn4ti
X-HE-Tag: 1763617745-426696
X-HE-Meta: U2FsdGVkX1/D/+p+W9N8P5qrsG7Yd2FkVjOocoQ2MxILiSmFUWK4ulXZbZ2QCuI12pwnjPzc8WqONnFLJuE92UNYpcXJeuHuu7I8wy/JUfGN/f4uFE5mKgStGvA9gCoEzQLHR82i0/mDG4gpb3x+EOiD/NVxTnEpPJu+X/2W2tK4mFT9OmpbMHmYlvQGcdUkoJ17b1uLds/EiYYpKmFDivtJaKNY2NdoVxr3ItsmeKkBRHbTO5mxLCP2maaT4zzms+8/USkNnJfLRxkKnTu8xCRIKuCWRuLRtTvSWT1Vb2YRg66AAkfi/kxb9UU0uJqxSVyJlI5xrLvpsgE4Yrjs3QglYBqfXqCyVAxPqa/nNXYtj7uJPRrojjkNoluKtz3YdJlasx2bIdfIagi4R8GSF1gJ9Q38XXu1jhbLLLTLjhkwQBATSwp+f5BlzP8xNlACyrddSmt9E9jbzps6exfRzCwT0sS7a4iqhT/ZpHIGz9RH6MHd4QNEA7/7/sxhb4zXfWRg1aujG5bGAJ0mAzErZ8SjV8i+oxaJMTPKYP1hB7L8lRxRIm3RsL8/fJ2wEYGhyHRlqtvImYSaK3r17/mrRcjKcF2f8Ip9f0N/BBGQoLo0qDEKauV+M5oi6ViU6EShYJn+qNJ47DnpkyVqogmuDhHUy1K3sITkRLKCtLyF3/xb5YRQzkJpw5TSBENowUdPcZnlqn6NyAcSnafd8wRcgVWga+dJj+KnW9ndC+kHidap3b9DbQXU6FlzgC6KP8TENpYfJ4utIEBkh2AiILXb78VmfdxyXXPbVFNNZg4dtVEcuS0JNN3U35ve2Uh8G0W0Iggoy1q9Oh+sIZEqkdoLjPn757t0OpOp+WANX+31fRvnPtk+tfVcI9Y7hLvlbtdvLNH50P+f/qpy6baaz2+Y+DsoPllLvMC6hp8G0J03j+nMd51RB83slSJWjkyUzVZTnV7IDMz+yA/RBLRLHDm
 B0X+wV/P
 lC/EuklWmp5jcPpYYNsLuu1aXUvTVA+4FpngJttPhEXAqF3BlylKRQteVhhMO+ysQVPxsUacgJ386vW9DYkMO62NWD5ZPJj6nIKy+mZBOBlUm4Tbn12qtr3U08cFL7yQR1SFr1E8FvvzLfynxgdXFcvPq4PCnY4nTQn5UHBAcRkx2whz/llF/kgdwCiEsYnc72P52IE4LAhcqdOFcvds3MdtcoH6batKT7asg1sY+hXOQ5Do7nr794IJSmg9cT+IrSwEsqkWA9V3wCba4wAZ+3etr11SiCTLJrwfKtk774c+RFk8+ZChvlwkBWstCzJadGhZZuPt1YRORu3LKASO4N2fcFD22FSsDnriy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/11/18 18:17, Lorenzo Stoakes wrote:
> Currently, if a user needs to determine if guard regions are present in a
> range, they have to scan all VMAs (or have knowledge of which ones might
> have guard regions).
> 
> Since commit 8e2f2aeb8b48 ("fs/proc/task_mmu: add guard region bit to
> pagemap") and the related commit a516403787e0 ("fs/proc: extend the
> PAGEMAP_SCAN ioctl to report guard regions"), users can use either
> /proc/$pid/pagemap or the PAGEMAP_SCAN functionality to perform this
> operation at a virtual address level.
> 
> This is not ideal, and it gives no visibility at a /proc/$pid/smaps level
> that guard regions exist in ranges.
> 
> This patch remedies the situation by establishing a new VMA flag,
> VM_MAYBE_GUARD, to indicate that a VMA may contain guard regions (it is
> uncertain because we cannot reasonably determine whether a
> MADV_GUARD_REMOVE call has removed all of the guard regions in a VMA, and
> additionally VMAs may change across merge/split).
> 
> We utilise 0x800 for this flag which makes it available to 32-bit
> architectures also, a flag that was previously used by VM_DENYWRITE, which
> was removed in commit 8d0920bde5eb ("mm: remove VM_DENYWRITE") and hasn't
> bee reused yet.
> 
> We also update the smaps logic and documentation to identify these VMAs.
> 
> Another major use of this functionality is that we can use it to identify
> that we ought to copy page tables on fork.
> 
> We do not actually implement usage of this flag in mm/madvise.c yet as we
> need to allow some VMA flags to be applied atomically under mmap/VMA read
> lock in order to avoid the need to acquire a write lock for this purpose.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> ---

LGTM! Feel free to add:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

