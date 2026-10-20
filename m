Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5A48606A324
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 22:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=CvpUkYzR
Received: by kanga.kvack.org (Postfix)
	id 199C26B018B; Tue, 20 Oct 2026 18:36:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14A566B018C; Tue, 20 Oct 2026 18:36:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 060346B018F; Tue, 20 Oct 2026 18:36:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DBB0F6B018B
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 18:36:52 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6D8A2A7E90
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:36:52 +0000 (UTC)
X-FDA: 85344465864.20.C01CF57
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id ADB261A0007
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:36:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CvpUkYzR;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792535810;
	b=ns625KmqkRxNq4iEpJycQz+QcuO0GvsXNF5TevaxRYKmGiJWGXgPfDzQqev4+lHsGxeTF8
	WNCg2XaoCNIBBAqeaO0WoBf7AzZdVeBskd5UQ3xEe3gzE+ku+bjFz1l6vwWbra3uel7hq/
	cxgqWBuLvOhhxu/fgP6HNrRfAKbneBw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CvpUkYzR;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792535810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rv30j355ZOn02JMfZ3RVK29kwKID6foC3R1nQuJB9KE=;
	b=rHDGnf6JWoQx+YtPPCUH24VvPUg0HNkLWRSMFuF51fRZbWRGBtSEhwaXCiRVYj14heVWNd
	8zMbRlDn3VordUtmiXRtwZ99N+krqETOOHOAqS2PGm0jxsf946i8Ke0St90uxTOdGU3kn9
	k77IvlVWbfgAn2QFml7ZNRStt4dqzrU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7A6E360098;
	Tue, 20 Oct 2026 22:36:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F7111F000C9;
	Tue, 20 Oct 2026 22:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792535809;
	bh=Rv30j355ZOn02JMfZ3RVK29kwKID6foC3R1nQuJB9KE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=CvpUkYzRfhBVW8RqAWpQuWI7gU2PABbkK5qRUeeF0mF10sMgigl60Fj23MU4UcKj0
	 8qBnMeIY1RNIFU46IX3s9ngCawWnwx3DtDIuthqPYi302K8XWN09HfpQ7uYjOGMrqP
	 zT6EztMOTuOzA5E5gwpaOqsJcawgbYRKjaSxOGpo=
Date: Tue, 20 Oct 2026 15:36:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng
 <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Roman Gushchin
 <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Zi Yan
 <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>, Usama Arif
 <usama.arif@linux.dev>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins
 <hughd@google.com>
Subject: Re: [PATCH v3] mm: unqueue deferred split folios outside the lruvec
 lock
Message-Id: <20261020153648.52636815691868735e9699be@linux-foundation.org>
In-Reply-To: <20261019230646.3510790-1-joannelkoong@gmail.com>
References: <20261019230646.3510790-1-joannelkoong@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: ADB261A0007
X-Stat-Signature: w74mymqu8877odikwiz5ri7wcimpanac
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-8.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792535810-805855
X-HE-Meta: U2FsdGVkX19TS8Oec33GiFXLfPXhHwoH0SmyHtDeGbR/Wb3fnsuXHkfeRzw6zAXtwa3lKKU9SV5bOfwjYRb0YigYuue8FCHjVMMSMfiDF0xkC58AkmsD2+nVVwoZgGEdaCs5K0GfiWcjoUZU3kMIn5ZI/V7ELIi2lHiswZsjNzo+uWKrr+VdBgNuFcc/Tkh41a48OocLR5O5YbSJMtnBTo7qPefsLNi4+NbuR1Zi8zIEUHPyhagmt6Y8dv7MZrg+Y1VFiSX2iQLa3JJeM+AyytQq2P23g1tzxk7EU7QsW6cDxYd/U67CZKmyHjljSWuT3Xz2ZeJ3J95uG92OekfBpqNipNG3ixB+ZUCMNb/UE4tgbncrMcsXazTiT1zch0AKtSxH5oGv1XqvB4lZuT2//PIWVOd4Ipp6Y/MRn4KFhYVKv5TwgKhpKC7y63BxeYlIRvMY9ZpArqVqPUlWlxMg3ovK2Aw6gJGgfFYDamDxAtLJthgNIlJ54E/sB/lUn5zd8QBMYjmxzKvyM54kSR74dpCbU2So5/esWY9thh9ooMzVtqM3qmTRaIjTm3/1gyd2bfM1UHTJA2k2Qj2fDIIw79XxW+pkFUDxYhDzwatkY+E7jH192zNJGF1YqHZfB7C9Q6mA4WpS+gqtRwjOQFDckouepZfIBoBAVYtY9gNm5FifYRnX+1vdcLhSsO9OdzMQXYF59V8b2IAPGQdJ/XS5IGMe/6cNFQLmVug/2brGft8vsRPB8UcbXzeVSC0dVh4s/eXCFfQxsKYx5LN647o+1qPBz/7BZMiqz3p3ifqr9JposEf9uk/miCYrN66AoR+RffzTSRHtnqQ6jxzD/wIiLv9sdQuVGepHnMIQ9FHJxAvrbwm6OgXxB4JtkW2UUd6ldkRRuReuTLUOjH5JIUu+M9DP92vEzF7nm2KQFr8PiPs/i47W905E6MpzvzTX10LCJOJwQ/6QIbIb0aIHm03
 sdZqGZrE
 lzYO6AarR34NDLC6Fqss8pS5etUSrm9tdDMoSQPCzvB8p6qZZgJ8/W/pSP5mYdi7afedOfS0W5gdc/AjLtPlcP9UbVWrGwwTQ35CjfMMmOzFOyWH/Sl2Z/jePNlWEvTCDDRA1lvAXXZYAecVF8HtrYjdlr0azKmvija8BVq3YdLoxLTuCZYXNtoeYXew/q3zarZFcLvWTK6sjQGVhfrFnTvh/XbjfU72xrYItBT53k8rRes48y9RH4hdKZU4/SUnbccC4LeJllyxFjdWFYP7VEOOpaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 19 Oct 2026 16:06:46 -0700 Joanne Koong <joannelkoong@gmail.com> wrote:

> move_folios_to_lru(), folio_batch_move_lru() and folios_put_refs() call
> folio_unqueue_deferred_split() on folios where the refcount has dropped
> to zero. In these paths, folio_unqueue_deferred_split() is called with
> the lruvec lock often held (move_folios_to_lru() always holds it and
> folio_batch_move_lru()/folios_put_refs() usually hold it for every folio
> in the batch except the first). However, it's not needed to hold the
> lruvec lock.
> 
> The lruvec lock protects folio->lru and the reclaim LRU lists whereas
> the deferred split queue lives on folio->_deferred_list in
> deferred_split_lru. The deferred_split_lru is a list_lru with its own
> per-memcg per-node lock.
> 
> There are already other existing callers that call
> folio_unqueue_deferred_split() without holding the lruvec lock (eg
> __folio_put(), shrink_folio_list(), __folio_migrate_mapping(), ...).
> 
> Add folio_batch_unqueue_deferred_split() and use it in
> move_folios_to_lru(), folio_batch_move_lru(), and folios_put_refs() to
> unqueue each batch of zero-refcount folios from the deferred split list
> after the lruvec lock is released and before
> mem_cgroup_uncharge_folios(). This helps shorten the lruvec lock's
> critical sections, which run with IRQs disabled and are highly
> contended.

Thanks.

This is a speedup and not a correctness thing, yes?  Let's make it a
7.4-rcX thing, for the 7.5 merge window.

I'll park it in the mm-new branch for now.

If people think the speedup is sufficiently worthwhile then I can add a
cc:stable to it, if clear justification is included in the changelog.

