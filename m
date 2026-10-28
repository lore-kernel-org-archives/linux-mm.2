Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00CDA606A336
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 22:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=cxIIgRrn
Received: by kanga.kvack.org (Postfix)
	id EBEB86B05B1; Wed, 28 Oct 2026 18:54:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6FC46B05B2; Wed, 28 Oct 2026 18:54:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3B7D6B05B3; Wed, 28 Oct 2026 18:54:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9AB2B6B05B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:54:17 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ECE9F8016A
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 22:54:16 +0000 (UTC)
X-FDA: 85373540112.09.7024633
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1A978140002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 22:54:14 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cxIIgRrn;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.208.43 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793228055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1nzL/A4OIGWxPEaAp0V3O0CBZ7XOASlD1R5vK61L67g=;
	b=H0iEiX2qUJMEwUsNGvBqD/4ZVBQ8s7CktjTRVOMQih8UoBrxyduFF6TGrX3SDnrEFJpTg0
	TfjORxeHCCCPSkMqEl9D1LTAt9uhTmP5lXu0h2w6i3NVjEAkIcrWjKxyDb0S2HRs5+SI1x
	M8W0oPY4PVGmL8wptMgSB521/vr0jvQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cxIIgRrn;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.208.43 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793228055;
	b=kmpuHuNmLJRrFWlZr7T/g/4vYd5JvVLPOCIqG2nuFBKjxOqelS3nr1D0WxXHoyrm2PKeJM
	mHjG3yf61qHY+DVYF6P5Ou1g0EX1mELq4BXIjhv3QLNPGnueUV+NrCmPAqBAq/wmyTrPjZ
	XjJnkp8c2eAo7u8GpmwDeLyoTXkaGIg=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6ae14eecc64so2253304a12.1
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793228053; x=1793832853; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=1nzL/A4OIGWxPEaAp0V3O0CBZ7XOASlD1R5vK61L67g=;
        b=cxIIgRrnJ0JTeOwhuC9e75S565Hj9q24/Iaiq5E3JNs9H/Xb7fX0l+eWGqvicGU4ca
         pvHgT3khMhzdWBxsHDenmYzz6lbhPjlBD1u3n1jrbvvPgFujXae9k01KID9Rm0W5Ppdz
         n806Kac0Ad741+963VG6nWri8TBPlRXaiZmbgYYSDsG9z6Q+/KYenJRRoY8ujQdpLG1D
         rrmWLmQmVvLPipfV5bQ5L/lwFaJ7fqLrD8x658khUQYQ/A3tMWLqloSnY7xGreSMV0Vh
         eUaxypF8K8amsc8eqPsAxKO8LN0cT2igXqNfcidG7fu8LOxTs9VUnKJIQ6bWMkV1XAYG
         zwqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793228053; x=1793832853;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1nzL/A4OIGWxPEaAp0V3O0CBZ7XOASlD1R5vK61L67g=;
        b=DFnGJVdSq7ARtzdJkFjHFxSiQI0dZTgohxW+LFedZT6WO2W8R48wqMux9MHyUCET/2
         dBTrIoZRwo1RzbOs5I4JxFrhv8S+I92Oxju3fzdwM/EuZeVHJbTixTy8FuO2VZ0yhUc3
         SvtxcN3+oaU7HY27F8Uy9ZRmrqVcNRCT7qdYpm652Sahg7rU4w0TejW9qocN0MS1gQLN
         pyVScX+CrG1G4ZyUQ+B/TTL12fZfN742qRqYRWf/fVTNCDti68BvtmBh0emLsebWwm2q
         zxqda4WIUPXUBCUxY1dIfSTUdX0EqpqPaU3tH+bmHOP9OH3EbqIp/djheLL+IaTbhFRX
         kfGQ==
X-Forwarded-Encrypted: i=1; AKwUvBwK81AcdMAi1FEpPFYoZK9uMnZnqoo3PyrF9o/fTQha4EKe+STBYLegxCs/6YPJAHKBs4I6dSHJ2A==@kvack.org
X-Gm-Message-State: AFq9FYKfgkr1sCqx+yRlozHwm/sz8Ozb1e8UKfxwbw443AbdeoOioQ9B
	xzQe5omFv2mUZ1do6Mc3b3DBaIdL9SksmEGY1sPpFH0MTcGgK3OLfmEgYzfaKs/ksqc=
X-Gm-Gg: AYBFou3l8mY2uQP+v78sI57idhnPLz7GcIrdR4dfFByTf7UWIMapGfbK3+ZIX9pS3YK
	nYsot6V4CtWrjX3kcoeMI//o3IBbR9R6tMdJbWrvVcr9d3kkMX8gq9PDAOc8Nli0QPryxJTIS7A
	/ogA1+YKxh/KMJcXi+K3e8ec5S7K7avuZpl86Pgrz3CVzzPnFbq82G2XhnLJU+1nEseq8E7Jfrd
	mkWrspxrwLaeiHYGnjrJ6dSNdMOp/rdmzCV/OfGQc8tA484B0e2pqrUofLrsl/EqgFwtYAYGW0m
	iLUDp3wPL9DYb+1/2KUD+8vXXFoXj5RdR4Gr3wXogIJ9d1CqvMax+vHBJ42NVj8+Uc9Mh1LGqMZ
	O5392wLrBOpIzTkKclLs3akFRjjFmUkJdsIy9qurcTZ96qVDn1sIkznR6H4S1I5IFUbnyjjnQWQ
	qdlvPKHiSfRLTLgHRznAq12BjysWHw/f+97WpIYowYqVnRmjyZAOR0NM5zStX6u9OcQwQ9V17lI
	AOPeK91mbT/0wRBwsC1BVy2832kfzI3IzvhMbgMk6hIKPmVqAOd5B24HnDTyQP0iNrqkhoeXIVR
	Veb951aVScGteTqjoJ9Tp2Ca/Mb7VER7wYE+aAer15k=
X-Received: by 2002:aa7:d0d3:0:b0:6b4:78c3:b8bf with SMTP id 4fb4d7f45d1cf-6b49cbfe65cmr2043596a12.26.1793228053385;
        Wed, 28 Oct 2026 15:54:13 -0700 (PDT)
Received: from localhost ([2a03:2880:32ff:49::])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b4964601f2sm1991741a12.37.2026.10.28.15.54.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 15:54:12 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 45/46] mm/memory-tiers: unregister empty tiers outside
 memory_tier_lock
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, 
 linux-cxl@vger.kernel.org, stable@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>
In-Reply-To: <20261027-fixes_core-v1-45-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-45-6f74bec9a5bb@kernel.org>
Date: Wed, 28 Oct 2026 15:54:10 -0700
Message-Id: <179322805093.453251.8441529644965692562.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: 1A978140002
X-Rspam-User: 
X-Stat-Signature: h59fazem5hwo8xtp4y96jwhgysdfmy7s
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793228054-835184
X-HE-Meta: U2FsdGVkX1/7NC02ZjsW6g/U7ZAiOwj2M4YvCGT4qOqOqDAaLvBSEFGuC82rVxyrjBzZfrGq6dBQW1Xz94fWVI7aB07awkgJjcFPTzwb8Df86p2Swl7pcSjYIV7WF/D+xhXOQ/sGEJ7jLV1AWYI9gzmScAeaX6/tksrcF2Fik5xX9Lepjt2IBuy2QEHlLCus6Sc46nkZFQnYLoSRPTLWxxjtlE+zkEODmLm2tqQ3JpZahgY7ax4ohHlvS/y0QR42x5qJd9YS+2kye3JmAOfasaN0Q0xlROQqmFl+zy+LfOy6O3vKOo8YdqhAGtJdL3pRsA1sitU5TOiQK1Hb0EMNRqubzwjdSCYar6nu0zwuEqosAGRthYxEFcAigYUGSe36Dn2KyW3rAAD1Rrq9Oi3+egSmeUDRk/cxPy1QwZv+1t9euzN/GTJxXIe0fVGxzfr+ZJFH5jo1IRL93jZ9Qq859ECKuhKs2CQhYdRukNnqkTEfoHFPdncKh3PtGnzlYy0g8OyXY+VGpA4eyM4C428mD7zQmnHVlXiNc/4qFFcBw0iYyRmDB9DYJ5qc8topaSg4FDpwyWihne1bafBw9Q4oqLdCNXHjDa0cQp9DoWxfAgImIVFenWTLcTE81SljMOuEF4SRivutAZH1OYTx2p81LikRejzLIKSjkTJrb/3IfQi7uKHgWmVzJ5chAMps0kym5RrBnThrLU+VDCd/qr5VlfvB2eixRPLaw3+zPTXxQmKAUJ8Y6aryP6SfW9ouekiYhry2+x2fwNSSKvZrIobenvveyPC7e2DgrHiP+RiACn92b51uiLC88S/oF9zlYFU/jOp2L573vAV8CBsyrgycKZCNKkGcpnM5djchQT+vWPVLf3Wj9l9tNabLj9oA3eMizOlfb7O9no+uO2B5nmIhaa+yO8xxeKECg05JHt+kRwqkzbk+mX1e+UaJLiw0nuQyK9Re9hqJZZTk/GFk6Gr
 a30VfisH
 CG2Kj5Yv/JZxqDibOjkjljELaCi6YoBm0tkUBfCiw24LHISqkxbXcsEfeM2wON0kNq3hfhzaR54KKCsLL+UiMhSWpIK1v4Nk5O7NyOmk/GdpRDyj5lG7nG4vbd5XR7pO1W/+UqHagM17hTJCst8Z4aRdiHHxlEQXSFsvLEKdjmIKrBKzILS1k9XGGM8j5knJpQy0ujAwo7eL4mUk2reaC0yZ854SJicGJW7qqjiw2AsBcrwetMOmDgYCFPBmVBKtP/nJ1170lHUj3k4Ag1cJNP5nrgRa7MsFytNlkh8T3RUZnwIXZ7LRAwxeEriFmAGA2LOWb1HG5Y1mWl4WtO4NYLcQy6KMddCH3T+8QVYcI5J7jiRUOhliO/Evf+DFHwqmGM+nQH52+Y9m+Gvs1oAhl3dquJ8+wZmFPWPAY7OsH0GV8DOj5x87D6mrJVhzXxPADlkwW6xzKbU9NK7QDrgmVK5PDPUQSK2CkgZwzROjwyKUXkzTNz6IIofiybwb+noR+2lZipbqSCwdPLBayFJAHkJe7OSo9gnm3qMmgp0NhcTg5MUHge8bE8XIswhv2uhpa8iEC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-27 00:18 +0100, David Hildenbrand (Arm) wrote:
> When offlining a node's last memory empties its tier,
> clear_node_memory_tier() calls device_unregister() while holding
> memory_tier_lock. A concurrent sysfs read can hold a kernfs active
> reference and block in nodelist_show() on that mutex. device_unregister()
> then waits in kernfs_drain() for the read to finish and release its active
> reference, while the reader waits for the offlining task to release the
> mutex.
> 
> Return the node's former tier from clear_node_memory_tier(), making the
> helper more similar to set_node_memory_tier(), which also returns a
> memory_tier pointer. Let the caller unlink an empty tier under
> memory_tier_lock before rebuilding demotion targets, then unregister its
> device after dropping the lock.
> 
> Fixes: 9832fb87834e ("mm/demotion: expose memory tier details via sysfs")
> Cc: stable@vger.kernel.org
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
Gregory Price (Meta) <gourry@gourry.net>

