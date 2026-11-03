Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 446FF606A32D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 11:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=r26bKKjz
Received: by kanga.kvack.org (Postfix)
	id 634226B05BD; Tue,  3 Nov 2026 06:52:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E55D6B05BE; Tue,  3 Nov 2026 06:52:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FC7B6B05BF; Tue,  3 Nov 2026 06:52:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2F04B6B05BD
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:52:09 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B6D39401D2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:52:08 +0000 (UTC)
X-FDA: 85393644336.12.E196341
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf04.hostedemail.com (Postfix) with ESMTP id 937CA4000D
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:52:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=r26bKKjz;
	spf=pass (imf04.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793706727;
	b=hzRm++bjFNib5HGrP2rjh1DovsG4A4LNfTZU8ni9tmzY2tgsLzr/kFA0tAU6VZ7IgrKxSD
	AQSY9iVNCiQ+ryhVzy4sKzNHF+ZNfmJ/H79O24CHrXkNioQh2WM4afw/NCSWRzy/LAN8pG
	qfkuoi2WGsRpqzDirrdck0lJq715+zo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=r26bKKjz;
	spf=pass (imf04.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793706727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eI4CVv+ydIY1wa3rrW/Odp3qY0sHcQj8Jj1GQUapMZo=;
	b=zZpuae1ch2TlpFuJtV6arC+82VP20bfhXjjJWWzSR5bMjX6Uu5eyOBCZNUGY3zra8FvvXh
	m0Ob34zFW5RR41TLjt7vCPO8Ox3Xv+xCU/ndnnpy/CUBTjKdEmLEg2uzeJ5eo3IGx1x1Tz
	HUC3eGVHbTwhkV+tbMjrs0DfJSFFANc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=eI4CVv+ydIY1wa3rrW/Odp3qY0sHcQj8Jj1GQUapMZo=; b=r26bKKjz1RxbYOpykqB9PYTHT2
	RrsgjuOIdrXMvpVMWJNvYLrdz8gy2PEpCUs5b9Sjl3NcHHlWNfLz9Rf5D6lZjf4krWvMajTSihUOQ
	lMLqmSzi59qhLI17XqMtmPOSU4mcVOjOrcnBv63pa4FK6J6wZnivAUcW7DqYQ/gGMsZbBRw+Q0HTe
	/yswu39KjLyquVmUnrjlrA8kYQ0V/sGP5q4tFiIjAR5ghbIQG3ZGAoCJoJ5P5p8Xh6sX1lhCVAjRF
	zXUWRWolS0rMreglj+beiVoiC26YySEdsW3joRAtJmwnWN1Fdn/rcH/Lh0rVEOf9Beb5+WDLHqyOr
	Lj+2z3kQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOD3Y-0000000Bt6e-2ENh;
	Tue, 03 Nov 2026 11:52:00 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id C62F9300322; Tue, 03 Nov 2026 12:51:59 +0100 (CET)
Date: Tue, 3 Nov 2026 12:51:59 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH 3/5] locking/rwsem: add down_read[_killable]_nosteal()
Message-ID: <20261103115159.GK1813469@noisy.programming.kicks-ass.net>
References: <20261103-khugepaged-latency-fix-v1-0-a07ab16ac860@kernel.org>
 <20261103-khugepaged-latency-fix-v1-3-a07ab16ac860@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103-khugepaged-latency-fix-v1-3-a07ab16ac860@kernel.org>
X-Stat-Signature: fxp47f7wdrn9akqynpfizr98g6xw4xry
X-Rspamd-Queue-Id: 937CA4000D
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793706726-58917
X-HE-Meta: U2FsdGVkX194KZXtozpeL9Gxnhl74xlOkaVYlmqqOlmeN0dnlvq0GFdvXLDYDL8ASAP4BF0/Rbu1MQKimKjminGkvsuY1yu+V45y9MWCNRXBE8K2JKSXYvKeRSuSpvhhhBF+loFFCmI5jYZNwO/ZKj97x5020XIneGgR7Rz7VQ8seRBU64Phjp8Xh6WYsfWhsJMLFUU+KO5U+QhspdpDmSADa9MwGc/KQGJKs6/m4VyomFbLki3rx09rDmvlowUEeqFLr5/W/PRNXxNb+k8weJqZaAY3sEOSAZ59v/nSoEtk5WMACidiD96lnPoPdAAuFHR+8A/ApjGeXjmxrJuyM61Yq6mrOssddQFzZInpLttCpe7ewBwCmciqUm53hqgFo2cJ++l75xBMikmMgB0fFS442ko2dqWZqpNHR+wt+JcIM3xtiGwmPdbpkh4m9ZLUjk9wk6yzgnGNzc+4sN2htJqvCtJ4sVoJvmTbC9VTS/j+2VC7d+xwa6PrH0F12KWJIgZUBsJ8HgF8yMVLF/fL7ImIl7bDgVzlasy0FRhWGMnniB6goXnZ+a70ibVqacAcLqQlSNMx1wvooKffDcQ4Tc2XbHQbK0YiRnDpywzz2Ht4Pt+VAbfeNkimKZxmBe0FwhsYc/r/HvVRz+Iuv5gffkin7PZQDBsVfHlpXZRbLv85edDZU+C9Whhm48gU76TgH2/5bWqS7i3jgg+Q5hys4GUxpEC46Y1jFv589fU4y0SxKYQAyJ8BKLcfZAfHuzwwGIJiCbVABsIoSZOLC0YLjAHgl/IMpfuCJ3B33JN+nVCqeV+fHfEE0m+Hxv/AMonWQOvOlzgwuO7EEh0CSmnVMCX+5O4xgCL9FsCyhJZ6pbPyFVRhX1G6A0Wwr8eYFTuKLmrJzDOjDlJpj9/GS/sJfrLCYhq7xMn+z/tIE8MW7KfMP8Qtprf+3EVTUIUjR3xkO6jgMhzP0Coeu0f+Yki
 mS5g6sS9
 bV8iqLHYGRJQC4vy05hNdSRZlkWhw/iHB1jOy90iVagRsh4GSn8Hln6SRn1j0br3nUCoRJKi9D3+SiZTlGr670YUlnJ7cv7M3lhIvJXkQJNqrlg5AidHDkovdOxIUPbHvWuw4rUfu3/H4DDM41rBqxMhLVXALI7/Ciq2P6KNjypcIu0rIAVczcWde1OAqDyqLdnIUrBh3+0LvRZSMma3y2GWncqZBo7/SHShA0q+fBlQ0q5l2Xb1awZ9Ii+IrII8w8fL2N1ci4EsVyH1ajNoZf8qL8CJ7aAjOTn6K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 08:27:44AM +0000, Lorenzo Stoakes (ARM) wrote:
> Since commit 1a728dff855a ("locking/rwsem: Enable reader optimistic lock
> stealing") a sleeping, queued writer whose handoff timeout hasn't expired
> can have its lock stolen by a read lock issued before a woken queued writer
> was able to acquire a lock.
> 
> To avoid write lock starvation, this is only permitted if no other read
> locks are held.
> 
> However, this behaviour defeats the purpose of a reader periodically
> dropping the lock to allow writers in, as doing so only works if the write
> lock is acquired first, another read lock is held, or a queued writer's
> handoff timeout has expired.
> 
> Provide a means of indicating this intent via down_read_nosteal() and
> down_read_killable_nosteal().
> 
> Implement it by exposing a steal parameter to rwsem_down_read_slowpath(),
> update the starvation logic to modify this parameter and modify the steal
> branch to check it first.
> 
> Also drop the duplicated RWSEM_WRITER_LOCKED check and remove the
> goto as the steal condition makes this redundant.
> 
> Exposing this function is safe as it only makes the lock more pessimistic,
> so does not impact lock contention.

Not generally a fan of this -- can't we tweak the steal thing to never
steal if there are pending writers?

