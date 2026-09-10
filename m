Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95142C79FBB
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:05:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47BE26B008A; Thu, 10 Sep 2026 19:05:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 406926B008C; Thu, 10 Sep 2026 19:05:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CDC86B0092; Thu, 10 Sep 2026 19:05:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0005A6B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:05:35 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 24045A4FD5
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:05:35 +0000 (UTC)
X-FDA: 85199386230.11.3458679
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 58ED14000E
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:05:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=le70C3Mw;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789081533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=amOPDCiAno1NOdE5Q6HrVP/LyJBGQ/6Zm7f6CaXwps4=;
	b=2nZr5nzYut7zEFo21QZvBeJevibThwRkqu/mYWmemhAAcvpegNBI3xo9hm2foFx8Xendky
	Qhb6B7Ny9bBpF6bGZRipFEppcfgKweQFUbAF2Y+oGFkmgSp7KWP/s7ddUQXeUoSJZLVzPn
	8pqJ8+c0d2rtuccnPEavwex02FWItq4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789081533;
	b=CPd6vlPPx0nhJtQbALLGqZekMD8+Gvb7pM4SJiM/UTBRisOD7/OtmMHce5kCW4Xuml8XD0
	I5Dx+fD51yyx8hZd3NZ+C9QCuQXvb7uWo7eOB+wMoWaZK0pZy9AUpfJCd5mCqjdVoujoLv
	e7VgHi/WuXnUW3lf3ESazY0zNwQqZ6s=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=le70C3Mw;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EC551416AD;
	Thu, 10 Sep 2026 23:05:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A2CA1F0089A;
	Thu, 10 Sep 2026 23:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789081531;
	bh=amOPDCiAno1NOdE5Q6HrVP/LyJBGQ/6Zm7f6CaXwps4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=le70C3MwovpeE01RxcZJn1UDUGEwvptIsnglPECn2vVXSRV/mOw5SMBvnbaToZ4S0
	 qTPlQuNwI5FWDEAR2xG5pt1/LdXA8KsYnFb5axvqc9ICceuZGWpSJuV2FGZ1pCNsNu
	 n22fMkC50Uit+9LFUO5g6CN8eiTL6aPhvywiZC/U=
Date: Thu, 10 Sep 2026 16:05:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>, David Hildenbrand
 <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, Vlastimil Babka
 <vbabka@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko
 <mhocko@suse.com>, David Laight <david.laight.linux@gmail.com>,
 "Liam R . Howlett" <liam@infradead.org>, Suren Baghdasaryan
 <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Muchun Song <muchun.song@linux.dev>
Subject: Re: [PATCH v6 00/17] mm: Introduce section-based vmemmap
 optimization for HugeTLB
Message-Id: <20260910160531.64390c48445e8844b6f672ea@linux-foundation.org>
In-Reply-To: <20260910063256.64386-1-songmuchun@bytedance.com>
References: <20260910063256.64386-1-songmuchun@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3bkabmxgcim3xpm7t65qr354n1puaf1u
X-Rspam-User: 
X-Rspamd-Queue-Id: 58ED14000E
X-Rspamd-Server: rspam03
X-HE-Tag: 1789081533-240189
X-HE-Meta: U2FsdGVkX182Fsz2LSkeVMUZ/QXZqhVjZ1+WL04tZLnrjpbgeYDHPShPj/XVlIgMPKqzH7x1DyHXY9xX2KpRONwbY2JCeSVJcA0ehkBqCO6+1FpqStAYmdRQIME0PtXa1U2Y+kKjj3CqMSBmntnq3poz3QJZj6Ib/i3ahyCRV8FuZJC5uesOevmn6t44HAWAS40jamn8c3dNNObPA4tHYilnQNgQuE+E2X8uVkNxtZ6QZWLMfJZzL8uItALNq9ZvbBv6nYFoFbOOJfgFfbM5QqGerSiT1l5lWg+J1A4aKxS+gtcOgOMd7Q+Y8Y2/lixd2v14dW9/mC8ROmtFIxN9FcSOuryFJEkuK67y5wPi6FKMrL8uBhaxFuXhlY87izX+uIoe+oRiMsty7ebG/XgdINw+ql1twop873U+TVzh50WG3JFOvBJrR7Jv42qfT27/7gxeVl7p825iariBcl3onSDTrR4VJ0BW0xrLTW3d7AAP16t2w9D9t2sx1HaRLwqmAFoN2S7bVPGsJCdq2VAdCKtsZDcDdrbiNUTPATLMpWWX90gWW5qWmK9YVyILxRabffpB5LsqHVfiJWUmGp6wVhBewnM1uySUxIatMRBXpRVfu6VZcRuUKTf7KYMvCa45HZD9TL5E0dSVvnkvy/+RcKkWthsss3LYiFULpcY1rinxzD6HlV/LEjohbUxzYHD3CeSpmH1Up6L2My/YJV0G27pK8koDa0ktVGaUTMF4aRz+0ls5L8YnFtKwxSfXvArtIyY/ZZ+HdSeIzAMDs5rCU4R+ZVpxgHyL3ES3HuiXFZiWd2KAtz7z8l6TRWfip1Mw8hQ0U6F0p1TZ8qc4Rsl2YffCZWTsH0ylpdtr+El7dtiDFZsO1DMmcc1sYksXFa4EojF+ENYRW0mLBr5WocyVlhmB1+nY2UttLdn2aRH1qOzKfmVlP7jllP2PRtXZr/FFEQn0hElZXlJZsRC6ENM
 fxTZAExI
 KS8lPsY9HV4jKlxBkwT78wqG1vF7H24iz40x/aGzunIXjg+lVmZtJAi9U9U+kHb4a2GqngPWKAwMFQMIYcgNNhuNOGdKNrZuk5/8vjM+OyHgqayV6Pdi8VIxcIaRucwY9ATRB8Tkz4bmmh2HWUOFyOeSxqOSC38Zj0Fc7bwcrkdPy7Po8g7rg8JgkQjR3oF3lpDANnScRLtNAu95ak+wKL7EBvZ1GMeVpFgkERZbW/zkzudlgda1y8tokuLjqvNuiGQgg+JeNDV0bX2StK9aP4Cqgi6tDkPxzP11Wvf6437Pxt+rkdLJpxvGMiPLPjqMw99pJC6UhqwS4eDQ22f2YZ7bMcccnxFFBcvB8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 10 Sep 2026 14:32:39 +0800 Muchun Song <songmuchun@bytedance.com> wrote:

> This series is split out from the earlier, larger series "mm: Generalize
> HVO for HugeTLB and device DAX" [1]. While the parent series generalizes
> vmemmap optimization across HugeTLB and device DAX, this subset addresses
> a single, self-contained step: making the generic sparse-vmemmap code
> section-based optimization aware and switching HugeTLB bootmem pages to
> this path.
> 
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

Thanks, I updated mm-unstable with this series.

