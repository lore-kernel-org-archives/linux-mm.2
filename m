Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41059C61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 04:21:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2934B6B009E; Fri, 28 Aug 2026 00:21:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 243966B009F; Fri, 28 Aug 2026 00:21:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1823E6B00A0; Fri, 28 Aug 2026 00:21:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E564D6B009E
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 00:21:01 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 19F6C14034F
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 04:21:01 +0000 (UTC)
X-FDA: 85149377922.11.DE24E85
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5523740006
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 04:20:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zjLx3msp;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787890859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ms9ElGpndu/p4gAL+/SKqDdyKJI1gRddTa0Oo3jugRg=;
	b=Tm/rVPlAKunxw5iBlgFIBGUN6/L7IsOj0+5Xzqhxwcq39cvf8WNQEmXC4vCpilZvsnSiK/
	VrecWw4+1Mz1EJ0AdRBh1hOH/nEYqe7rEMWVtVoA8EJ5SY5GLJqlLWdEz5/6nMTC10SxeO
	BrW+Y/AwC9z26Jzx/J2WtDdMLXgX5KI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zjLx3msp;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787890859;
	b=a9yUQcGvG6+E2pPqbLDnCzrGNNNirmbt/tA3RzWDl5jIPIuzu7h2okT00zN7lsMCUpCfq7
	jtN8xUg4rlbiW7IIhQAUa9MMhaSfy0VlU2WdeFnpZAhk5fp39PRrEMpzRHh4yme51R1Lbp
	b88+iZqkzXT8TrdV1fW0V6N7Qlqnclo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 717874074C;
	Fri, 28 Aug 2026 04:20:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E14971F000E9;
	Fri, 28 Aug 2026 04:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787890858;
	bh=Ms9ElGpndu/p4gAL+/SKqDdyKJI1gRddTa0Oo3jugRg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=zjLx3mspMsqvC1HC1b68Q2TAPPBiegAYK1vMXjHWbHsBl6g/VajdsK5FR+eAyvi1F
	 h9ITZW4jAjHz3Jf/1OaOPRdXpT2i0FRvzG+vdptj0x7fqAtE3Fd9WftVeStw48HUK7
	 y785cuFytGJWnBqFNF+dHyeUqtyv5WtSX/XEmMzQ=
Date: Thu, 27 Aug 2026 21:20:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>, David Hildenbrand
 <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, Vlastimil Babka
 <vbabka@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko
 <mhocko@suse.com>, David Laight <david.laight.linux@gmail.com>,
 "Liam R . Howlett" <liam@infradead.org>, Suren Baghdasaryan
 <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Muchun Song <muchun.song@linux.dev>
Subject: Re: [PATCH v5 00/17] mm: Introduce section-based vmemmap
 optimization for HugeTLB
Message-Id: <20260827212057.37cf374d95450d325e5fce63@linux-foundation.org>
In-Reply-To: <20260825084608.47437-1-songmuchun@bytedance.com>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5523740006
X-Stat-Signature: nudsxwcxzezonshdi4xas8uadiqsn69x
X-Rspam-User: 
X-HE-Tag: 1787890859-510802
X-HE-Meta: U2FsdGVkX18dM4VwM/DAa7jubp6bfAfwccyX4kZj25XUTVqTHTLOsZxaN7QIrgF0CxuXKcZOiHORAH/SVXbz5TTnLfVk98WklvQWjtvXAUVo6TiMni0TJ3yKPddw9nfA1MRnbdlCYZ41e2JuBrRAFK6D8PNr0Fue31sm6kA92lUrCZxv+ReyY8+Mh/KMQOYC7sh7JrQX5dUxAU5qsUWpSf8sl5nvXB6vkLMK3+GuX8dqLl6xkByBR6tHPyvV5lFpvmhDoXAEtA28z89QWQ4huWVqjOSi1Lh+uSi2+5a9y7USoxqc/1CvIhI2NB53ROEA6l08N1XVrYXEC2Zr24ZQe0loLEtsyKQU3zzqfG+bjUGtkTOsBj6ig9OWR37zV9K230K9RvI5A+DEJEnDg1AG5U00sOmOX2F3WLnoqOX8v93tAJXZ8t65YHkpmSHBOznNix9oBkq0W4TqrJBwbGNxT4+mH3xyUzPkVDgz87nJ1zQ3qrJTOGFbqMIgWndAdILad1rZv8IQpEAhEvXBrFq85li501kvzXD2jcvuD4lsYK5Ohm5/7JTzeQMHMCSb6KYbSGnxLV3nFC7zIdrmhYbHfaAO2VUwu9nssg9JZru/8uI/lGDpN7U0OSMmKBv47ZwCKG5azx7sd/boeKgljIUUmOsQDLFQh9oStyXCmopfo7TotppsSAwfLPtrgnTit0Mm30x+oyh9SMTwQxE2vOKYxTLQhsjLsjdEyAqnsyydyvbxHk2CfYKlesxwkSolS4G/DvJDAurwExpykSLhV8ohnWS/7hVzWgzgwSA1EKY9owHyoyxRgMN7hRgDdndU9PyL90vrjKbX6zOk/OCmPVqlNSxk+08SqzBb7IIXAR+cXKH6mV3CTy79XirSo1AL+B7UFBtPn6eOGbs+AXdaaCNaWKmf6uWtRu6oZMhp/lE9n7U/JsjZYhEZkabqzN3zXrI++ypE8owoZ3yRQxjYAci
 53MR1mMD
 OLzqnmp1dxZ4YB9v4qrhLjtHuJnMkEYQE32tsefGhhzwDae7OoHt0fFtV4gEzUDMWIOvvqQyrpjWmYWVxzfB0mTsa/YwWEfwrCScooPotOCCeXuGQr4JN+UkdtvQYxoMV0fWYpcqn/5mrQY5QYHkTuQujDs86qp6Was6f+Iv2F8EEjkJr60+c62RCyzU/BMz/3/WiBgWFCKL+vF6Z7mUVfbxCdLavESc2SA2KUcqW6mQOSphUGYVgwrrU2LwQOARtINcCXCDRWgVnhnvDTO55NcfsSH+dgnRPUTaswZ8644JKKzRU4oPK3Wjl5P5+R3+z41tmAd/v8bBmf2rHtnRneKOYnll+aLyVHzsI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 25 Aug 2026 16:45:51 +0800 Muchun Song <songmuchun@bytedance.com> wrote:

> HugeTLB vmemmap optimization currently has its own early boot setup
> path. It pre-populates optimized vmemmap mappings before the normal
> sparse-vmemmap population code runs, and sparsemem carries
> SPARSEMEM_VMEMMAP_PREINIT only to support that special case.
> 
> That makes the HugeTLB vmemmap optimization path harder to share with
> other users of sparse-vmemmap optimization and leaves a fair amount of
> HugeTLB-specific boot-time state in the generic memory initialization
> flow.
> 
> This series introduces section-based vmemmap optimization support in
> the sparse-vmemmap code and switches HugeTLB bootmem pages over to it.
> Instead of having HugeTLB pre-populate optimized vmemmap mappings
> itself, HugeTLB now records the compound page order in the corresponding
> memory sections. The generic sparse-vmemmap population path can then
> allocate or reuse shared tail vmemmap pages based on section metadata.

Thanks, I've added this to mm.git's mm-new branch.  After -rc1 I'll
move it into the mm-unstable branch, and thereby into linux-next.

