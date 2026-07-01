Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D33AC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 20:04:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF6CC6B00AB; Wed,  1 Jul 2026 16:04:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCE126B00AC; Wed,  1 Jul 2026 16:04:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABFCE6B00AD; Wed,  1 Jul 2026 16:04:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 87BF36B00AB
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:04:56 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1EB73404D7
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 20:04:56 +0000 (UTC)
X-FDA: 84941286192.27.8F39223
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 63A4C140016
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 20:04:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ja9vf6Dc;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782936294;
	b=eW63FlVJ9qMgPgAhaCsnASWH8dHaKwYMy1Bw+T66yiAZjvdhyCjTHxeqdXrH/Qu2bTj0et
	CgZDtI8L4D7uSLBfy+W/iQPTWiWeOIR47GLJkm05I0VHFtq+qTpFbXrBIL06V7qQPQMw/7
	gIvxX7sTfI76Sh2Z8VP+BvpzYxo4k9w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782936294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h8XewL7dOdgjgBlExG7c82KjdEETSt64MZQ6t5MNVB0=;
	b=Wu/l6GG3P/dD0AHezPxc9oNjr2+oFjm+H83SR+U2SuDW6R8XJeuJEeELf03a9dYnsTFl+1
	q0C5Q+ie0VInl3qBE3dofKA+ndN7oLwplw0l41QNGMpTYBrMjVrpU97Uu6C+fBsnD4as3N
	oT9MG3PIsJ7yGpOFV5IeOu5bIh+CIbo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ja9vf6Dc;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D525B60138;
	Wed,  1 Jul 2026 20:04:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D77BD1F000E9;
	Wed,  1 Jul 2026 20:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782936293;
	bh=h8XewL7dOdgjgBlExG7c82KjdEETSt64MZQ6t5MNVB0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Ja9vf6DcKb/bQGd8Q/6iQioxRJ4eHqsokqNUjcwZvoqiQJ4xlXVIG5w6SsTyTCa0x
	 AIKElSpeOeS5ztXPEA85mfpfq9h2psbrIoGnDn4v6qIxUtL6Nwr+roAIz323yRHoGt
	 IMw+wru4cB84D+3LpYLMT+xyHleK9GowCVFeVg4viNgJc23H6UTUYK5TkGrIY5XDlP
	 7oA2IQs9w1B3gegU34I/B0sxiPtGcYKzk5TzKEiFwR5oC5OZSSam2PTUozLOm7RHGH
	 9Kv6IErdBuQ8xnYwZW7UPw38ju1mMtzWcj54ErwyjMSPao217hU0ZHC6NiuiwIyQtY
	 gFZa+wpSeWp2Q==
Message-ID: <b0b66905-c619-463a-8114-73848bc913ca@kernel.org>
Date: Wed, 1 Jul 2026 22:04:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] mm: preparatory patches for PMD level swap entries
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, chrisl@kernel.org,
 kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, kernel-team@meta.com
References: <20260630164143.1595669-1-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260630164143.1595669-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ttpnfrad4exmmq874dsx69zfy3qcoen5
X-Rspam-User: 
X-Rspamd-Queue-Id: 63A4C140016
X-Rspamd-Server: rspam02
X-HE-Tag: 1782936294-63405
X-HE-Meta: U2FsdGVkX18W+y/g5btPicTnT9cX15esvL56CH+uHFQBjOuVopsveDk1bq//lFFRUqZCXHcQxnOgASZYQGK4GeEPEz5orXXjgfTc7QEjEj7vwho+hoZ/s/UX+eVkww1aGS53rmy6/epsxbUkEs1kZPZDT5Tdn1Z8XY0Fs9jSuFfFej7llGAoDmjrIRgF2B5ibJeKTp6maRNYd3q136tR6CILT6gaIo7QSRGtBu/4aJIanxUbHpLXeX99uf6rnGzXtgq6vKspusgEvtARiRno42TVkwuTEGa5ADa7y5YkI6n75HnbfepAFkBS/c2s9X8pw8BFACcJZ2xYUe3CWnBWXldjZFYTjpAtAK9qjAj/MAwDb8uBZ1c/e3HcOL22G2mjXRPYu0uhFaxuR/ONrEhaoeF+A3TxtUwphD9Y35Trq9Vb2F7F/SgIGYVCSV8N2JVO6bsZaBdB6BEgeHenCWh0HD9APtfURnYg2BBtXo9gG/VOCONIcggUC1xDpN0EKvL3SLY3iho1jrzIBsy402y1WtzSPx1LbMfnW1j/Q3OVfS11R5LCE3TnUtlymrHpwFlxx/065G3XucVwdNA5VRN/Iut0cn5jUwwrKG5n/hiTnrQNAbEe9bBZ4ngn7XGtq84YUjk7CMxddF/6j0MNLD42k9OnSEsHNUenFSzVnNO6zxD7yFxb9rr8OZn30+WE8irWVsBk2XmA9wt8w7aOYvqxQ/2d1UG6WseJUKZN70zFgid4v3XiXR8Nbhk4h7g6a9EIHBzuk7FRQMv495PXR5uXT4Uy7g6D4me6aUXWUYVrDX3uK6FBVRG3ykEPodF8D8dhURod8WARPkaj6RoBwOfacXtVpmc1z+Uj/mVUChwViH1z5ywSVVXuay3kjmrsBb/Gt43LCjkhU4x3xQFoiMllnGyn+FBlKef6/kceDZgc0uCD8anRuxahRqLzb3OPW1+Sh7xszb1k1lSmswYY1MI
 XnRyJO/I
 QED2CCVmhr9TU8PDsnxXbDJ1OhgrxFIs+WiyPUuMnPpQiwkdMSuqL5ZVqHrs4GBQR8qlQ4Uu45LnAviPGS2FIYcWzGORNkfkIP/AsSvagXH2jbUkrLw+n9UMrx4iF4dt9o0892rApHXFyebzrPtUo5+RcISyBl4LPvJG778NIwxnzXFldcZOrWQo3RyjMIHWLggDCwSXPVG5gxJO4Mp6uoSbS7uxGxrQ2HyOVpb2u748vN7vVIMVQ+MAG63RrO8tP+yS1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/30/26 18:34, Usama Arif wrote:
> This is the preparatory part of the PMD page table swapin work.  The
> full PMD swap entry series has been split into two parts:
> 
>   1. this preparatory series, which contains the first 6 patches. Zi [1]
>      and Lance [2] suggested to separate this out from the core series.
>   2. the PMD swap entry core series, which depends on this one. I will
>      send this once the preparatory series is merged in mm-new as v3
>      as the combined is currently at v2 [1].
>      I have not marked this prep series as v3, as its not really adding
>      support for PMD swap entries.
> 
> This series does not introduce PMD swap entries and does not install any
> new page-table entry type.  It only cleans up existing PMD softleaf
> helpers and call sites so the follow-up PMD swap entry series can be
> smaller and easier to review.
> 
> It should be safe to merge independently.  

Agreed, thanks for working on this and splitting this part out!

-- 
Cheers,

David

