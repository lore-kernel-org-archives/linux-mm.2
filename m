Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2817E66886
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 02:56:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31A226B0088; Sun, 21 Dec 2025 21:56:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29DB26B0089; Sun, 21 Dec 2025 21:56:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A9266B008A; Sun, 21 Dec 2025 21:56:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 07B6A6B0088
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 21:56:04 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7C3861A09F6
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 02:56:03 +0000 (UTC)
X-FDA: 84245592606.30.7E94A9A
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9C8BB14000E
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 02:56:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X+sI79a3;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766372162; a=rsa-sha256;
	cv=none;
	b=J12wMVjkehtjitFBH9czlBm6F5RU/Xy34DyIY1wj5rCc0Sp9ff23w9+JI4o6/Lng/hJ6o2
	1WImBiUp+tFE025AedVYyWc9HHjT5D3HsapNsnPDAPA7kByKZLxY+PmReL6RtNpkHtaSAY
	90xjoVcsYQTDhGHtm2R/MZp5fqlgkWs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X+sI79a3;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766372162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=may1VAVjkO+zB0UvFCBS01JYcKyy3lFkszihsMfdWYs=;
	b=zA2l8SSyFoRVU/nqlIyxYVoRltjBpCW0Z3AtxQjdMo767KdMelSMKWz51EwWhIWl+szu3k
	yiC5tKEqz9JZhCVFUnaB+PqRvsDzVpx8It1vZ3htk/FBcahCe50GeOqOwn2mJveSik5KJp
	EC4LMIk//q6V+AED9PWhyrITfM5Dznc=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766372158;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=may1VAVjkO+zB0UvFCBS01JYcKyy3lFkszihsMfdWYs=;
	b=X+sI79a3FlFoFhRdYSV/hUyZHjdEV9uc+F61polrYlodt7W7DYCBy5Ew9gGWEPZNl5grZr
	Xbl0hTwwzYRNb+9K/3+5JEiFPLSAM/kd/BauJFTO8kkiB3mdMkw4+lUXIOvl/ShCQZ8FWR
	HTCtndsplIG4A5DNm06wfivP/goFfpY=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.200.81.1.6\))
Subject: Re: [PATCHv2 03/14] mm: Change the interface of prep_compound_tail()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20251218150949.721480-4-kas@kernel.org>
Date: Mon, 22 Dec 2025 10:55:18 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>,
 Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>,
 Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Jonathan Corbet <corbet@lwn.net>,
 kernel-team@meta.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <79633EDC-7CD1-4A2E-BEC9-44866F0D7741@linux.dev>
References: <20251218150949.721480-1-kas@kernel.org>
 <20251218150949.721480-4-kas@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9C8BB14000E
X-Stat-Signature: d68bm7ijsqxaw9nb3wxytc3u6o9zzymr
X-HE-Tag: 1766372161-851985
X-HE-Meta: U2FsdGVkX18rT2JRHojJelxpSikpmy/S4ieF9CsHW1XaoWVI8g7o22HWFFurZFOw9xk6j+S9PvYh6DA0zBs3xsvC+cPgR6E3yilBt/V83iRUg2VEQVKayQsRl1IlpVenKsxUSgEHis2A3Vxx9JZ68Gd219lyuIyerpo6xiXRjeQd+PxOJyiyYpJgt88N/dVjpNf5Y2i01k2GJcdIqG+VoLt7/U7dzW7U4xipbmBnAoRTW/dcXeEe7x5DjHHbwbtfmbqQgs7aGvNtU6ekqZ4FsMQqiHk6o9O2QVERIm3mZN5b/3kfPC2Rcce4b3dGXoHeykSKY39ac5eJDRVMyZUITT+sXCos3y+/SIWgZNjNhi8KYR6/MWW28TUrczoWQ+GC3wFtuNIh0Tu2TzVACI3OnD+GblXa8SWLHslU8svE2xWrWVqrGuNthcapmYpgkA5L6CpKhMbcCh6hmkH+xRKIYubPA1rUN2SZSH+R2LzYGRKyDHA5HngjG2XBL9uHh5HbhHRxIvx37jGfE36+zKeabngKxsdHTSCuX7MZjo11ZkA1i2oo0TcLRsFxu47zcI4ZPODsvz6eBEDiZ1kvZQeeixdZ2U9bT6Rw9y1nSdPiR5ERajdQcNT9LUuunngXKjQMnevKfb0NkuJxQi+iiPhuZkVqCWWwc6FMdahRTJEte4AuNLxc6IGMYY7vK4jNa0Zk6dhXGEgSKVZqSCflaes1+VoyM+yW6VOTAFsm/qmDGZVQQtjqHlBVgGDuAWzVfPV+hQcXyinLy8KXuEWHj2scoTOu/EOi6xV6h50LvG6QI+ZaPDnA8VAx7gauk+vsdA+w9pRdxwGrB0aFRTjqmAFoUTN8p29zyYXe0GcvyjFI6tyZHj/WcAMlIWmm7FanswGwJfCdXBEb5f2+4FgrIaWGdddQZmaFf93dRUXwCs93ekLFZJaxoPJhN+Wy3X7in38y
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Dec 18, 2025, at 23:09, Kiryl Shutsemau <kas@kernel.org> wrote:
> 
> Instead of passing down the head page and tail page index, pass the tail
> and head pages directly, as well as the order of the compound page.
> 
> This is a preparation for changing how the head position is encoded in
> the tail page.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


