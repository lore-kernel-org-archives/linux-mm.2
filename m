Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6BE5606A335
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 19:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=rZi5sbSV
Received: by kanga.kvack.org (Postfix)
	id E27D86B05B7; Sun, 22 Nov 2026 14:02:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB1ED6B05B8; Sun, 22 Nov 2026 14:02:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C79C76B05B9; Sun, 22 Nov 2026 14:02:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9CDD76B05B7
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 14:02:39 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3380FA0542
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:02:39 +0000 (UTC)
X-FDA: 85463676438.01.AF73E69
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4993FC0005
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:02:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=rZi5sbSV;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795374157;
	b=p2+1YB+d2tAIRMB8OX0coS1vu0UCN7C4PL95ZOG5G2eqWnGgvTlX0+wiQ7BgMNS0UY8Ntp
	+AF6hXaDgiE1O79lxgzgUB25v6r9IN5f2QevBKqou1bFYUjuh45K3HUbBYVSvAqmTfEtGf
	XUNyK6Dh61hc0OscR9XM46fk/PLG9R4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795374157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lp0osgtiZVKWMvtaLvxNrKUfcz8WxeL6pbk5OTyZtio=;
	b=YflpC4Qjf/wUKttQBHgjdbt2cBcz76d+ulIM5Wg+tQmBH+Yc8S+8ppox6QKT+5soqSVLxw
	T3qAIVjGKL8g5cBl6BfYjIEhfsjgjVZVuy3k2tjptb8QUXDN1/DGX3wSZXMDPaLByY04RI
	jUZfaBg4umHo126OmIsijcIpM5zuHdY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=rZi5sbSV;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-94999a08973so267316185a.0
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 11:02:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1795374156; x=1795978956; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Lp0osgtiZVKWMvtaLvxNrKUfcz8WxeL6pbk5OTyZtio=;
        b=rZi5sbSVi98LniM556Iw6sqTK5EQc4p8ThnPrxJILkM1QruFSvxTF0IaUl1JKROa5z
         8zd6y8rFCoQak6fmoVKrXS3WLcd96ue0cXE4q4LZ7ccepheHOQzLqTyJfLXsf5kyY9uC
         mnbz2QKN1WTQciHFgoiqDmqgQuTiVoarzJ3QLjm99jHLLlvAkpu4ik35urVMQ+WkFR6w
         jvKrup8YsJyS+n/c3HFNGCmiN4Cmj6EZR8GdnGKYUNC2IrSzB7mR7EKZnkN5FNHiVKeT
         XVtBJZIGCXE/YLNhPwH9cEPGHg7GrzCoOdozBuxSo8nOeBgSPPs98opl81wWIuyvvdMT
         o4bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795374156; x=1795978956;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Lp0osgtiZVKWMvtaLvxNrKUfcz8WxeL6pbk5OTyZtio=;
        b=keMtWwOYR+z7egFDywIAOwzkCSFpcFeO/ZYdMysY7w9X6KiXY7TSYUUOSYQnOhaUL+
         FqPYU2Xta3uj31yRrT+4+BS1AjR76Cphu74eUmYSYKuENqVxZH3m/bh0DG35wrVw5ntg
         u545LdMSEUWIzMHnSS2p2TyTenNyX/jlxVpMbLCWjTAFtkPFfdyNAuTC2HmMHE62raN2
         BxhxG8/RgLaP5Lt59uDa8dPIROOJZ2gSruVkOxQFVrBXiAyylqJ0ZYFkhQNoz88PabdN
         XqrvElxDC5hN9UEcodwutPYGpkNeVUj1rCVuiMQKtwUmTdFFe9j+IZ+yskytUTFF+qNe
         Zd5g==
X-Forwarded-Encrypted: i=1; AL+hErG3NSdKG0ivGJ5dkB503AvbNU1mUr7u8LWmLVl63AxUTf+C1syR/Kjex5h/QqFWOmHRvsWeAZJg+A==@kvack.org
X-Gm-Message-State: APuU4Z8ZkzV3BPyOOqMMDKyC4nL0hOgtNtj4mQMAajGnbaRFoLaanRy/
	zszdPGRpC6+uheUFeTHiRsiIAE3Akxem7bF8+UNb9mXE8V6nw/PoMs+BAeZ+4H7IySE=
X-Gm-Gg: AZFdTZfeUnaDBnLIfi88A/Luwh3ONWylaOxsvXD8nxesI+HyaLwBvHEDUhAdyXEdgLN
	8SpBZYQzRoIfJktd13AphvaQLhPRR3ha3Uv6ptIxLfBv9kwthVlp9B9WjAl4+eXtZaH32pm9Hd/
	hLr5BJV80fDaLK3Qlnol5moVuO06JEIjyqJpHt06cUA61CNV9qgAq8gS249FXb1gxzmOp89X21s
	CcTIhBV0DUZHGYSH54HCiRg3LHe538uJG3lXa6FDDiB2AiO1IGEjV/NWUTiUFcALBkxXdW/Q9uR
	5oEBETB9iNlpvF66p6lLbqptkHEeJehB9k+uAuGQDKxzQ0PBreiSJwvmJsWQuDT3G9fKg3nWcU6
	+qTw//6NfNMHkCQ7wAvfrEseTirclN8j/ZK/LV+dkS5lgYt2E+UUTsqHlOiYmBIlgd7MG4wG296
	WbId3ZSAOdmFvLfFvjTXbHAaqY4CaQce1MfpYxHTQU57screb7E4z98SSN7w0xOrerQvxg0HfTh
	iFLNbJnDXRmAz66KfvvwPfqgKweRP+q/UNsP5iAYL+OyCKVa1R9Ou3PlCCXNfl5p859+b16BAV1
	Yt7SLsHmzaZsy0i0VIE3zloj33sjb/HdnfaSNcrvLDCz8OM4IAbuCQY2mmwYY/yFNiq7aN+tHPR
	KMhgXgJf/igS8v2pI4i62maGfIRmB
X-Received: by 2002:a05:620a:a403:20b0:949:c967:eb68 with SMTP id af79cd13be357-949c967ee7fmr803688985a.1.1795374156268;
        Sun, 22 Nov 2026 11:02:36 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949bb4219c4sm651293585a.41.2026.11.22.11.02.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 11:02:35 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 2/2] mm/migrate: allocate destination folios before
 locking a batch
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 William Kucharski <william.kucharski@oracle.com>, 
 Heiko Carstens <hca@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Miklos Szeredi <miklos@szeredi.hu>, Joanne Koong <joannelkoong@gmail.com>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, stable@vger.kernel.org, 
 Chris Mason <mason@kernel.org>
In-Reply-To: <20261122-migrate_reclaim_deadlock-v1-2-83c56185b0fb@kernel.org>
References: <20261122-migrate_reclaim_deadlock-v1-0-83c56185b0fb@kernel.org>
 <20261122-migrate_reclaim_deadlock-v1-2-83c56185b0fb@kernel.org>
Date: Sun, 22 Nov 2026 14:02:34 -0500
Message-Id: <179537415429.412063.2442586940573913371.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User:
X-Rspamd-Queue-Id: 4993FC0005
X-Stat-Signature: hbmdnmpgqcrjjtn6gxutsm1ho88me96u
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795374157-533967
X-HE-Meta: U2FsdGVkX19mOoRJe18V4QUez47mfyDJiyIHzI6az+TFVPUMokFiBW8b+N/VFylmz3P2bb2L0t45P2xMyHBxBukxm9uWchtjqj5MTV3Qf9uK1n0PcQRDdInA/ystwnFMK+Om7uGhzJGgdC4YrvKwAJKJo648yjwtDpInbrNGY5aUJNNFkdlfI07kVNVzhlaznpm6a0CcwYyd+yFL6rANgn3DM0Aa6u9Q6qXPNbxRekn72zwdaIyEyW3+tKznxgG6S44i7vgsd80VNxR9EHEc4KGPfKSHrlKBP2r4XIUnpNp8vaUGhC66ZC4J8KbRPXqiTkwZ8e/AePKroKSQIcZ/8aLMvsnFKhUn20GDTf9zzcOBcWYHv5747k1uxvXfMXUz0wGtZrtcLdh2VQpVgEazZj5spIEXzZKtOl6gURatb5wa3qdpCV76Tulk82tfjgkyccBGQrssXkAIEZoQZt8Ddwx2Alj1KIVYJfwlcp2L+y+VUCWn8gUeehQ87jyzSVI88TieqQxvYYqJpI0OIr28LC9GsH19kCj9bIgkPADi3ZE4FmAbj4MycMxbC2i8YlMjMmvxXudCdEDZBhpRlP3B4ozakQJfOpStABy1+kQhmh4XBeuy6qFOSUpmVGpY6kOERcFWYUML9ip5VsCNepbA8q9kd3EU/yqbRB2lCHyUSauGVsqKmwE9w1h3V7O+goJsadTUrUxpGV+lgiX0eF2QWZ8UbYFVP6uepnFTcieYGHn3mOoO77jhTM01ddK1YvcOTOPtytrp9a3Y0E6xye3L3mGn/ZErN/rvOZBrYBbSt/ZFcfd2M9utsdgF1UUJHgEKrV8gSMOgPy1YqtSusV/pvzOAnXhlhZPWvL15BN6BJThpy2acSZ43Jy9lMHLrP+v5siZ6AgheyFwCxn82MmGnXoZZUY4XPLSGm13vd9qxcNYtBAWqIfKeVA8My3Rt3IZAQP2WpGPF+yutJ60ItRz
 ebZeV9ET
 eJcyCWB/2ZQqyG1XHhm/II59rIO90l2UNU/q4QADegDA9PUliEmZch5meZcYH3k7/MbzpVJrePUBy59ISzlHklx8CZTQtDbQMwzvEQFrIH4vmR1CEkdHFD/saPCqv3WD4y0KIMFUXLbrih0N3suT/8YMHmOIhw82DGF2LbXH5A8KcYpt6Tlo6FHH1ekGDkvOTbZromo3A3Pl/g/QcVJJCifHFriUJ3ibQRxBELrZ7xm0crLk/HdezTgHy3+r7ZOE4n65LlJy+nF6SmEL+ZC7U9r/Vld0dmw0OK1eWUKD21l2YnURxl0B60E+l6vl20QmsaOJRt46UvTBi+AN7rW161jg4yyU0s3l3aB7f4VpVWOCpve/8HXG4CDtOSjzJJDcfiYESP4yFRIcAPwTkC+eBohOBqTW4WRjI4Tlr4fSCPUB3qEPzoPbVtl1a+yLo36JxGlvWF6NbH2na7HFTox9017VAelIIgYhvQVHE7rwpGweh6ByYy1WHo+rseYAJhTxMZHhdSAFLtuOVeeJ9iwZ2p3kpA6tySx9Fb5HNptxm3QJhIkapX7cGSzzNM6sEYymPEHATwN96mfz0G+ou0pbMY/C8+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-22 13:42 +0100, David Hildenbrand (Arm) wrote:
> Migration locks folios without holding a reference on their inode.
> migrate_pages_batch() keeps a whole batch locked while allocating the
> destinations of the next folios. If such an allocation ends up in direct
> reclaim with __GFP_FS, reclaim can evict an inode through the dcache
> shrinker, and wait in truncate_inode_pages_final() for a folio that we
> hold locked:
> 
>     migrate_pages_batch()
>       migrate_folio_unmap(A)
>         folio_trylock(A)
>       migrate_folio_unmap(B)
>         get_new_folio()
>           try_to_free_pages()
>             super_cache_scan()
>               prune_dcache_sb()
>                 iput_final()
>                   evict()
>                     truncate_inode_pages_final()
>                       folio_lock(A)
> 
> This requires that nothing else holds a reference on the inode, and can
> be triggered most easily with FUSE, which evicts inodes on the last
> reference.
> 
> Consequently, allocations under the folio lock are dangerous if we
> cannot prevent that scenario through an inode reference; and we want to
> avoid grabbing inode references, because we might then drop the last
> one, and would have to evict the inode from migration context, ideally
> without holding any folio locks.
> 
> Allocating in a NOFS scope would be one option, but it would have rather
> bad side effects, such as direct compaction not migrating file folios
> and the OOM killer not being invoked.
> 
> So let's fix it by allocating all destination folios of a batch before
> locking any source folio. Now, we no longer allocate destination folios
> while holding folio locks, which also avoids holding these locks during
> direct reclaim or compaction for these allocations: an improvement on
> its own.
> 
> We keep the destination folio of a folio that we have to retry, instead
> of freeing it and allocating a new one. If we would have to allocate
> while already holding folio locks, which can happen when retrying a
> failed split for longterm pinning, we leave the folio to the synchronous
> fallback in migrate_pages_sync() instead, which migrates folios one by
> one.
> 
> Note that nfs_migrate_folio() still writes back the folio while holding
> its lock in MIGRATE_SYNC mode, which allocates memory. As NFS only
> evicts stale or unlinked inodes on the last reference, this is unlikely
> to deadlock; this must be sorted out in NFS code independently.
> 
> This has medium urgency.
> 
> Fixes: 5dfab109d519 ("migrate_pages: batch _unmap and _move")
> Cc: stable@vger.kernel.org
> Reported-by: Chris Mason <mason@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

I was able to reproduce the issue and validate that this
change fixes it. I used FUSE to do multiple allocations and
migrations while triggering the shrinkers to reclaim dentries /
cause FUSE to reclaim the inodes.

In the base we end up deadlocked, with patch 1 and 2, the
migrations succeed but the reclaimed folios will just end up
freed at the end of it all anyway.  Some migration work gets
wasted either way, but that's fine.

I agree this is better than the NOFS option. 

Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


