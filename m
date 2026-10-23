Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99DF8606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 19:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=stgolabs.net header.i=@stgolabs.net header.a=rsa-sha256 header.s=dreamhost header.b=XosBg3rY
Received: by kanga.kvack.org (Postfix)
	id 778936B0BD5; Fri, 23 Oct 2026 15:26:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7561B6B0BD6; Fri, 23 Oct 2026 15:26:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 618896B0BD7; Fri, 23 Oct 2026 15:26:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 35AAF6B0BD5
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 15:26:38 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 928A4120176
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 19:26:37 +0000 (UTC)
X-FDA: 85354872834.11.EF12CBB
Received: from rusty.tulip.relay.mailchannels.net (rusty.tulip.relay.mailchannels.net [23.83.218.252])
	by imf15.hostedemail.com (Postfix) with ESMTP id 233D2A000B
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 19:26:34 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=stgolabs.net header.s=dreamhost header.b=XosBg3rY;
	spf=softfail (imf15.hostedemail.com: 23.83.218.252 is neither permitted nor denied by domain of dave@stgolabs.net) smtp.mailfrom=dave@stgolabs.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792783595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0nfMQHsA9FdKA8Y/f3fNR+GnrM1jMaIDHAb/EY3SqX4=;
	b=DqGdAQ85awAMRkdaOnpv9Aw1n+Lb5hczYJUq37Nszoy6HOqYLJF4EmnHVfwLXB36Gm81fg
	mQAyZENB1tXclBRoce0q3mT65EJWk4s+Q0s46v14VKdHNuAM7qVrPF+Pg3qtL9kaGXNiPY
	N8i9hJr6eRZk5bM7SUHEzXxPQNWDQc8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792783595;
	b=oO6DDhiGpxS7uC8x+BmT+kVtxfmlv2NkI2YskQJRZJwhTjZNvRTeGNiiKlGh30OLvD+BEr
	d7w8ikXV4HcyLRLPbEsM07IIRoHBJORGnGNgXkgO7qoj35q+iUprKZzsKCk6A65+amjRQr
	lPufQv6D1yDnZCOhfVwRGg11DWt2LLk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=stgolabs.net header.s=dreamhost header.b=XosBg3rY;
	spf=softfail (imf15.hostedemail.com: 23.83.218.252 is neither permitted nor denied by domain of dave@stgolabs.net) smtp.mailfrom=dave@stgolabs.net;
	dmarc=none
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id AD9773861D5;
	Fri, 23 Oct 2026 19:26:31 +0000 (UTC)
Received: from pdx1-sub0-mail-a203.dreamhost.com (100-96-7-166.trex-nlb.outbound.svc.cluster.local [100.96.7.166])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 515F6386065;
	Fri, 23 Oct 2026 19:26:31 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Print-Harmony: 033eb3f044415263_1792783591484_1067607383
X-MC-Loop-Signature: 1792783591484:1481457281
X-MC-Ingress-Time: 1792783591483
Received: from pdx1-sub0-mail-a203.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.96.7.166 (trex/8.0.2);
	Fri, 23 Oct 2026 19:26:31 +0000
Received: from offworld (unknown [76.167.199.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a203.dreamhost.com (Postfix) with ESMTPSA id 4jBCgV2X4ZzVg;
	Fri, 23 Oct 2026 12:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1792783591;
	bh=0nfMQHsA9FdKA8Y/f3fNR+GnrM1jMaIDHAb/EY3SqX4=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=XosBg3rYGiyqQ56baoxZS6EN9KifLnZHr220PUrYtMgFLUtnJDW73pu8xYnmafcRW
	 IopT9it/YFmIzLUMeYvFZ2G7U2x7knQ6frnTdtLwiA0VYIu5+jI0HcGlJzbBucs/IK
	 iJXmJxz4CHL6V0qiG0geb3B20SqP8kfp1KJueur7Wq1TiLnNvN2dFkEgqnPmdhdlxx
	 /uurKGpvj7OMucvS0aq3hJBM+jc3bjpGYI9ck4VrCnZO8fe1lzQ0gKNbxNVajyCILL
	 IykWEWmW7pWOB5Hr0ulhjUyyXXXsUVfU2Vt2yqZ5IBELVfJImoyKF3eDBldk5NbunV
	 OZstxLWLTcn4g==
Date: Fri, 23 Oct 2026 12:26:27 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, SJ Park <sj@kernel.org>,
	Kees Cook <kees@kernel.org>, Colin Cross <ccross@google.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 2/4] mm/vma: write lock source VMA before duplicating it
 in __split_vma()
Message-ID: <20261023192627.yj5ltdj4fjzydblp@offworld>
Mail-Followup-To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, SJ Park <sj@kernel.org>,
	Kees Cook <kees@kernel.org>, Colin Cross <ccross@google.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
References: <20261023-fix-vma-atomic-v1-0-8ff4fae1fc85@kernel.org>
 <20261023-fix-vma-atomic-v1-2-8ff4fae1fc85@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20261023-fix-vma-atomic-v1-2-8ff4fae1fc85@kernel.org>
User-Agent: NeoMutt/20220429
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 233D2A000B
X-Stat-Signature: cfo5rdhwdqkrpgr4b9hikqssm1nbkmbd
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1792783594-915522
X-HE-Meta: U2FsdGVkX1+ievOMVsGHMDbr37CJ3BNCiqdaidRZZikJwBATNfJZUQ5FKdeGLBYBLheWiFZfn+TB4S46NGGsge8/a1a7y/MFUkEMRUoJGhOyGOrORk9OYp+3+9G8N5nhb7Xr+zECMgq1WoBNWZfd2tzw5DBTarksoLc6UPMhokVMgPCiwwQ2F/PIBVl+2fG4RoABZ7ZIFAN6T+mkFPrywdCwCeBde1OhycmchMzN5adqdJtsdHWELhmByLbd3XcOUObSDKAhIwuQdQBZjdw1osJ0yAwMvw/btfMWjhSCTjN3A/4xqxnA7g7zyBEjQC94r/+c6R1uX6gEXqbDof3J4IARsb+SKtKYdXg79vzlv4tUJxgAdAFZ3EnbqXfST3MMEdQ5QEYLenainLIycSdOAbaBsnw0gHVoSMgJV9kTUmBzBo/HoTuRLTJXgD4qkv7ERCUHYFhqFuOfYRRfVQABadi5kriFr8fNu0s6hxfAJa2zort0MBwdQbDLh8zMkztwt32U+WcqjDWyVBiPkBBAjmOfHU6npvniq5zINkAi5n2NQtTMVMTdYqnK/bXCnAGeFN8stVHFPznTZ9TkLQBC4EpJC2g2fNfKBMVLhh8ywBdGVRjhb6LN1l+5rqzIKaTcakmpeJzpcAuBANIlRLam8A2i51WJkfD7ZyPYFa6q2Bc2nJGFEOT/U7J62wXHxgY6CrLELXqL8iv+xtWYz22f1grtOGscfFKSqz8qvcFyeTXGInRja5zNHupuhyT5O3r8e/isCulHus5LUH+7gxwGcEBIU2E6GHYNbrycwJmxmV2HRjPx1fvoMvjSbGe+TTLWDZ0NmvlqBYcdfkStjiPBFihhGemTaf9I99TZ3eL6gS2tZc+9JkU8J1xbKaPDu61MNUmW7wJmc5TOo6dyVqRGlBP+xf5MEmgMkkv837VE/r9471anHWKMUJfKoE/iQzQlcfUlqUKeB+DKhGkNKRF
 SJ3j5fL0
 YSXv1IR83NIzlWORKkakPBWMhZXQdeZVp0DsQsN0YU9BSKVlKpXVNGYayBiMHU/NwubWa8Lv84Ugk1CnwVAF147wZi9PMQAoFzA8QhhcrIH3ti2tJGsrmQBxX/sZlYlhtqRoqEPnYOXOzJvARe5zvln63Lp8uOu7OqC13cdZ+KbbFJXIVgfFcwpfy0HRkLt7/VpwwjXEDQ3pSu6J2CnJqYQmAN0kC1an92t+xLMqfk7c80Zf3mNfm/k6mBUxgCDcD9Iqe+BFwehFxMC3ip6FUxGpIAgbuQTQT8RArtkXIg1VeBynqMjLn32Qsek24Ko4a0Y20n1nwQLl0JB50M1GAzla4rjtk1dNhAVxQKThU/Myu4irA8elpzk+DuSFeBRRfbGhyKkbcjBW1sFhw3U3xDhBM3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 23 Oct 2026, Lorenzo Stoakes (ARM) wrote:

>From: "David Hildenbrand (Arm)" <david@kernel.org>
>
>__split_vma() duplicates the source VMA before taking its VMA write lock,
>and until the VMA is write-locked, a concurrent thread might set
>VMA_MAYBE_GUARD_BIT, resulting in the duplication missing the flag.
>
>If this happens, then fork may fail to duplicate guard markers and, if a
>file-backed mapping, THP collapse may also discard the markers.
>
>Resolve this by taking the VMA write lock before vm_area_dup() and, since
>all callers of vm_area_dup() now hold the VMA write lock, assert that this
>is the case there, and add a comment to explain why it's needed.
>
>Fixes: 2ab7f1bbafc9 ("mm/madvise: allow guard page install/remove under VMA lock")
>Cc: <stable@vger.kernel.org>
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>[ ljs - add VMA write assert in vm_area_dup(), commit message touchup ]
>Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>

... with one nit below.

>---
> mm/vma.c      | 2 +-
> mm/vma_init.c | 3 +++
> 2 files changed, 4 insertions(+), 1 deletion(-)
>
>diff --git a/mm/vma.c b/mm/vma.c
>index 1be613044b4a..aa59005e2f42 100644
>--- a/mm/vma.c
>+++ b/mm/vma.c
>@@ -538,6 +538,7 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
> 			return err;
> 	}
>
>+	vma_start_write(vma);
> 	new = vm_area_dup(vma);
> 	if (!new)
> 		return -ENOMEM;
>@@ -568,7 +569,6 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
> 	if (new->vm_ops && new->vm_ops->open)
> 		new->vm_ops->open(new);
>
>-	vma_start_write(vma);
> 	vma_start_write(new);
>
> 	init_vma_prep(&vp, vma);
>diff --git a/mm/vma_init.c b/mm/vma_init.c
>index baa7e82f47e3..d661f229a734 100644
>--- a/mm/vma_init.c
>+++ b/mm/vma_init.c
>@@ -127,6 +127,9 @@ struct vm_area_struct *vm_area_dup(struct vm_area_struct *orig)
> {
> 	struct vm_area_struct *new = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
>
>+	/* Must hold a write lock to stabilise atomic VMA flags. */

should just say "stabilize atomic VMA flags".

>+	vma_assert_write_locked(orig);
>+
> 	if (!new)
> 		return NULL;
>
>
>-- 
>2.56.0
>

