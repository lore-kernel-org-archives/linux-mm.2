Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C7D2606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 13:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jPk2Chlf
Received: by kanga.kvack.org (Postfix)
	id 6EE106B05BB; Thu, 26 Nov 2026 08:35:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C7146B05BC; Thu, 26 Nov 2026 08:35:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 602946B05BD; Thu, 26 Nov 2026 08:35:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 422D76B05BB
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 08:35:00 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D369E1602BF
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 13:34:59 +0000 (UTC)
X-FDA: 85477365918.11.B7E57C4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 25AE4C0003
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 13:34:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jPk2Chlf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795700098;
	b=Y+WPFxIiAxyzLPJsSPb/wEqBQLc3WS9m5HWOdbfSCwTWaNgpk4A8Ezgt1Zgv4e9djfZS/X
	ftcVLGnN7nxFJM+UTAEYHpU1ALjHqlOLNIKF7xozJucH2N3Wl/KVe/pq5TOSWdaQZ06ZfT
	sIDCXFODevlPRyfn0yW9oq9GeW4nLlY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795700098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DOZLBVC8e5T2seSjbwKw7gp2SlRqgI2Mm69LObxIeMM=;
	b=XrlvY7Lrdzmee7v2VlJooLzzMK+Bf8oGPi2Pj726uwt3zi23qO6qTGoKdtYEO+QvkvOs8f
	WYv1ysR+O7/3r97hYpZKFk2+I/JBa9J3UzyP/7jUfrMlUZaFQTKnle6TEqHgHOr3AEAlYL
	nhqY1xKNQK1psnR98w+kiwZPQwSIIXM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jPk2Chlf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B157F61F63;
	Thu, 26 Nov 2026 13:34:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F4DD1F000CF;
	Thu, 26 Nov 2026 13:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795700097;
	bh=DOZLBVC8e5T2seSjbwKw7gp2SlRqgI2Mm69LObxIeMM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=jPk2Chlfcc+IlMa6Se9qcdVl2MRCZbIG269JsvJ0CbIPZDz1JU66TuQAA+AdJsV1l
	 EGBJzAt2tG/NXMaeDYV5+L1mbNwUYHX79mfAL7PFBE1yOI9FXZMu5ZnJpALpNFlspo
	 PhQElUGVk9bMqYQYZNxJfEMMT/u+h/gDiw4JtJEB9uyQ9SLhjcjEiS/69Nk/tBchK4
	 CeMAzFSbcQhGowxJ3XYiefjwuQBdtmlXkn2cSgsGEv047zb/vAEEySltSxicUCiGFv
	 H2dljJBG7iaK6A798ZvQHvmgTXoD6t+GSL1+JrBDQiahVEzAdecunEzQXBcnCrgfWH
	 2ee3yQ7ER6sGA==
From: David Hildenbrand <david@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
 Willy Tarreau <w@1wt.eu>, Jani Nikula <jani.nikula@linux.intel.com>, 
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, 
 Rodrigo Vivi <rodrigo.vivi@intel.com>, 
 Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>, 
 Simona Vetter <simona@ffwll.ch>, Chris Wilson <chris@chris-wilson.co.uk>, 
 Matthew Auld <matthew.auld@intel.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Shrikanth Hegde <sshegde@linux.ibm.com>, Rik van Riel <riel@redhat.com>, 
 Benjamin Herrenschmidt <benh@kernel.crashing.org>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
 linuxppc-dev@lists.ozlabs.org, Chris Mason <mason@kernel.org>, 
 stable@vger.kernel.org, Felix Kuehling <Felix.Kuehling@amd.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Felix Kuehling <felix.kuehling@amd.com>
In-Reply-To: <20261122-access_shite-v2-0-808d8d2aa700@kernel.org>
References: <20261122-access_shite-v2-0-808d8d2aa700@kernel.org>
Subject: Re: [PATCH v2 0/4] mm,drm/i915,powerpc/spufs: vm_ops->access
 related fixes
Message-Id: <179570008611.16270.17870262980565551144.b4-ty@b4>
Date: Thu, 26 Nov 2026 14:34:46 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 25AE4C0003
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: iqf3e8wsced4pdqy8uu5qbno36myj6zj
X-HE-Tag: 1795700098-784466
X-HE-Meta: U2FsdGVkX19fSpro8b95getR4VLnJ1+ELerV2YKcKaZvGtX5rNKWI8AXfHN8Gnlp1mAMRXtskykwcsI1Ez/csBtYpeKnS0psvQltulieQxUtLAHxPjYz9HmkLqP1zFeK/j37yPIQzwDu5lRf1hKAAItIBkjc6+fi1lmhDkJBXqSCntKwO3Yuo57kyTNAeiKwR++Sbx6NJ0IwnYQlgMSpHkfzTFOaSNddtLlB2VC8gA+9DO0pfRobQIiGoQbvBc3+tGW8IjkAfJrOT7B263W9hKiS3B8Ct1Iw0sNqvDiy0+fJtkc/R++X4LIjKPR35m7/Osq7baJAGsiTkUCp9Qml/NlmL88Aks4TULBNuGiqLl8fFnc6Y9Ssj+ZD0Seh/2K0zV+O+YQvLQH0fHpmD5lxDj4GFomhMkybZlBFcs56+tEqO0Jwkrfg+/5hTTjn26AFtuxmfvQxFtlBwku8zhj9z4+2zx5pR19Z1lmjOGq5hv5LVIS2nou7xb/8FB62pKNYUDUvTFPkItlz0sTzX3D5hcjAan4JPzbaBanw+59lvk8VJzqB2ZZhdnct8IeF6uMKJc9wjfBt4kWXIGv9QCG6aCsKmUw88UZ9KnUUPHTXwgKo779pzrP9ODkSd29kKePbgdgr9ee6kFps1Kj9zF9VBZEumXrk+0RtOFKnkkp9QBFNUNxFuDETi96zpzsx48bpB6+NLinynCjgh+t21IMBVIazDWdXl7W2vunSLC6g6jBAqvPgZgTdNu5K+LP9ZpUw8Y9Imi2zcF+5QrVyyuvzKoBDXkDHeK25y07TSt3PiFBvcx0mn8NpSAotOcU9Uf4JUcSJWjAN3dJ1K1cqal+ZEUZT8JBlgACet0tNUJg3Ip0mfh9TcFUqWonKiPa+GgEmZD/xmf6r4DWjlDLmbmCFyV7oEX5F8ZgXF22KsXI7nk+keYhpXQfdVeR7aEiN1KZk8sA9jAxODE5NZgKbw6i
 9mfPsDj5
 8plo0pps3Jb4ELdkRX0Z312E3ANELPso9vgLQXmcjh85roNzFyAL0UWcxHkXj3fAOnt7gQle/qdiWQbLllfABCv5ohW+0eXo1GnFjvwtupZ+89qBFcHmuqF65MtYAeUOEOcsvAaIeYWDz2wPtCimAS/nSZvQXqIviZWuTSBHWXICk3v7KoQB2TihcTq+uBC7xtZJ2kj8JZNKepv/o28Po0LGqqEsai0pMhsY41EcF0EEVIV/+6OVSXyYLfv9QGqjasI8pFczu8xK0GVh2Q7ir8e3BN5iI2lSIE3l+feaUDrJ5Ff8JxP8CNLqjF5wY4XCUCNY1u+WyDd5d4KSVJ6aCl8oTqSkhC238lJHkYn+5NDW9P0dPPDeLYQMAAsEtbNjiIjTsXXpPXzcaVBKLst7NQ0Ui6JD8HXBEHJooQy84YYYQZvMK7O9yyQRHLy7rBOKqmKUyEN6Aejy3uIB5H0ITgzY7afd9OoeckH2VIGRPmxybM6XKrLEKuoD0NTQsDH5GtakL+cAnUdESCit0BMyWtKLsEi0YF7dhr+pQCyHLBc+AGjtR5jJdcRup3kABOAI9I7FmbmQNJCIwUNb4IXmMfEEndQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 22 Nov 2026 18:55:17 +0100, David Hildenbrand (Arm) wrote:
> While working on vm_ops->access related fixes in core code for FOLL_ANON
> and VMA access permission + size handling, I stumbled over two driver
> issues.
> 
> Fixing it all in this series, because it's all intertwined. Only allow
> FOLL_FORCE to bypass VMA permissions, similar to what GUP does for other
> VMAs.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: core-7.5.access

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/4] mm: do not call vm_ops->access with FOLL_ANON
      https://git.kernel.org/mm/core/c/775abaa4
[2/4] drm/i915: consider vm_pgoff in vm_access()
      https://git.kernel.org/mm/core/c/95553038
[3/4] powerpc/spufs: consider vm_pgoff in spufs_mem_mmap_access()
      https://git.kernel.org/mm/core/c/50df2688
[4/4] mm: check permissions and bounds for vm_ops->access
      https://git.kernel.org/mm/core/c/8ef1926a

-- 
Cheers,

David


