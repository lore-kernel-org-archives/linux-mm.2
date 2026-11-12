Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 892C7606A8A5
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 19:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SPbefH6V
Received: by kanga.kvack.org (Postfix)
	id 8EA466B05D2; Thu, 12 Nov 2026 14:11:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C0FC6B05D3; Thu, 12 Nov 2026 14:11:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FED16B05D4; Thu, 12 Nov 2026 14:11:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 563D76B05D2
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:11:05 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E46EC1A0BDF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:11:04 +0000 (UTC)
X-FDA: 85427409648.05.66BEB73
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4FDA4100003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:11:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SPbefH6V;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794510663;
	b=Y28MdfvkiTnq2aWfHkgc1cVl7uraBx142t7SHqah1rQbr/hh/k89xHZdgXeekrrF+PyJr7
	sCnuqKEYKWOdwHsTy34a+SycYUqx7568BAde/jK2iNUm/LWSOzAJJpxw1jCrROUW1c1SN2
	7GZek0tTSrHvpYpB0jOEZUyTmpzbjjs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SPbefH6V;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794510663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/gw31v8Bft63XKNn3Br3X2FoH4VN3mvM371V5gzzTAM=;
	b=d+169du4WLUDv9l2r52Rkf3KvgKRqrdeUE2Kk6kTdSJniKXVmXPd31lqFPztKERHZE0VGc
	/v+EPXPnZnAX4LV7WZw7G8nztgOyu1JUZxAST4t8h8byoIhVVDuDqPjdIT+RBGhWfx/qXJ
	hb3tzHG3OI/mhRgMecMxiL4RiIDMFqA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D6524623EF;
	Thu, 12 Nov 2026 19:11:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A37F1F000C4;
	Thu, 12 Nov 2026 19:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794510662;
	bh=/gw31v8Bft63XKNn3Br3X2FoH4VN3mvM371V5gzzTAM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SPbefH6V+SmZKkoSlfrGde0d2vD7MrhExaaRt39+4BLZsS8oRxtLfgAA2xCoeBw7X
	 ZhvzYeqntZBqIGOYIQO/GB2Hx1+vcJXp3cuXfuw8TYReN7u25g8kUtBpemZ3I34sLW
	 hZq0KIKRQQInzsuj/jWveLASxL0crZcHkICxAFYZJlTRZuzVsLBvkwGeVYXyNbk+Mo
	 f0kbbZCvB+jv6xrJmmqjFOaN9qcFk7t65cWxC6WiYMLUNCL4f0IKt6SG5nGkkloDqP
	 xPJSDzmabXQ426slGYq4buWaHmau6XK/QiYFyLbdoJKLy5LQvdNemOWHQ/N/OVnMoB
	 5eiaeZYXL3mCw==
Date: Thu, 12 Nov 2026 19:10:50 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Usama Arif <usama.arif@linux.dev>, Kairui Song <kasong@tencent.com>, 
	Balbir Singh <balbirs@nvidia.com>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, 
	Chris Mason <mason@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>, 
	Mark Brown <broonie@kernel.org>, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH 09/13] mm/migrate_device: fix use-after-free of the anon
 rmap
Message-ID: <avYOYgW_lJiSKXH5@gremlin>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-9-3d2454362e8d@kernel.org>
 <179450709690.482102.6960491372735414259.b4-reply@b4>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179450709690.482102.6960491372735414259.b4-reply@b4>
X-Stat-Signature: jwjcruk6tbhy3zkng43e4bfn881do3aa
X-Rspamd-Queue-Id: 4FDA4100003
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794510663-621367
X-HE-Meta: U2FsdGVkX18RPpCxKcM5w91vBlysygoBeQdp4hAi8gb7umih5KiP6/4ya9zHdluUWEQpf3EvF/Y189T8kemu51m3lMfowNkqikQ9uWlfSLlEhd2ub4a9kmNXHvXBFnC75jrkRJpL7JJJFtrKwgrsApovXthyUDeWU2o7W5+Vnzb1zn7PEpUjvOEzYNJvF6uf0t+4aYc2MZdGLeVWHqwCyEFHcfNH2i6VDOpS02jwO5OoIrB3Xv1TtmqDWTlF7EFinj/m0GlMVvsh3Jmq0i2zuZ9jxIRBzA1PRGDQzAcVc1JwhMKsneYpN1tzg8h40gkSCjpDLd8tl4RLObw1rcF5nQkdEo6a0gCOWFRKM2dHjIZ7kwzRvQ2AgPX8H0/UpsWSGrRaqtwsT9cGz3rE626+3T9+Tsev16QRjGq84vm3Gu7WuVfcYs99C2aEc3gN/kzXJ8LZJwodbYozFP+G22B4n4R2a4IIUI94X//mGmWs8PGFNmoSJfl08rKD0IyshBYMPLjyY2y6iRl1ClzoPqJnSm33gfztuWQbkS7qodHgKI7mmgUoqDTsaGGNgvELMEQtskQniUQoRbxGEZVYipWb7+QVZLVgZL9JMrsE9nNwqArQuu7GjYzNs/1nv6doGdNXNvC5jrOUqq8ZbgnFW2VPVIAeN4hWMkh1l/M1MpVcWILEnC5bS8KT3+X/EXUqF480qiVooaXaTmhS9nOjBs1iU3MpARRoMur5T52Yna+/o48uHr0Yop+Mos/85cuiKaCUK49I+ugKb104LiNncqtGxLrtWRBaQhf8gOP9VGzqz7Sn/HL8b/UlRB1ymUji/6FFU1cMBIqQgzWdzvRO7FlJ5CwgmBksMvNQGr4ycMHuMrigJrnfL8FGZeifw/JPn5QYiB27L5AzFlU5HzBwl4rFgKJG7TgJvAw5F4swEEj79750Lsf8Zw53+lOVHW09i3ZOfCwhjTSpYvCx4PGpHoR
 5jyPftWk
 WE6o8Ymu+AsTP0JPcq0byJP8G0Jo0ZhrIoE3OfEQDtXtXvVloL6t/BMdpTx8oB3XaApREVXh1UqjFY30c3BPFXOzW7K7R+BLZQIEY43Mj0bmea80Rer3mVrE7bcvFeqxM2ydb36idPqXta0RHaml9toh4Rd18LtGjZM1FMazb5rcxKt/BxT50g1KKZtyqBz43Hw2D6nmPLGeaKDTDr1UpZnmxthDI03urcB07P5jVL4zZF4T8Z8CifKoipQr5VCHH/mCWGO0QLRiiTaQK7I8egU4oWYg2CHJPsURu/dYjqnbwyZ4ZJ5oXqFLE1J3D06QrWxXXnoYbLyoxMybIY708dAswzRJCuCaXEJqBLAG0/PRnL0Lk8DX2F8Y+RXoNeb6Dgo7fQXMp6QhEJw/j6DiBglUO8a0oK7ajuH1JyvCN+QZEJZCyPYYKdN/+oNSvZG4JgRs6CCh+OyblsFc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 01:11:36PM -0500, Gregory Price (Meta) wrote:
> On 2026-11-11 18:13 +0000, Lorenzo Stoakes (ARM) wrote:
> > A munmap() of anonymous memory can result in a use-after-free of the
> > anonymous rmap if a concurrent device memory migration occurs and the
> > migration runs without the mmap_lock held.
> >
> > This can occur for a long-term pin of device-coherent memory, or a driver
> > evicting its device memory by PFN.
> >
> > Consider:
> >
> >     eviction                        munmap()
> >     ========                        ========
> >     migrate_device_range()
> >       migrate_device_unmap()
> >         try_to_migrate()
> >                                     zap the migration entry
> >                                     unlink_anon_vmas()
> >                                       last VMA: free the anon_vma
> >     migrate_device_finalize()
> >       remove_migration_ptes()
> >         /* locks and walks the freed anon_vma */
> >
> > If munmap() runs before try_to_migrate() instead, the folio is no longer
> > mapped and gets no migration entry. The walk still runs, and follows the
> > stale folio->mapping to the freed anon_vma.
> >
> > Resolve this by pinning the anon rmap of each folio which possesses one in
> > migrate_device_range(), migrate_device_pfns() and
> > migrate_device_coherent_folio() before its PTEs are replaced, and
> > unpinning it once the walk is done.
> >
> > A folio which is no longer mapped cannot be pinned and has no migration
> > entries to remove, so skip it rather than migrating it.
> >
> > Reported-by: Chris Mason <mason@kernel.org>
> > Fixes: e778406b40db ("mm/migrate_device.c: add migrate_device_range()")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
> Was able to reproduce/observe a slab-UAF in rmap_walk_anon with KASAN
> enabled, and that this patch resolves it.

Great thanks! I guess you have some mega-schlopped setup for triggering testing
like this? (Meant in a complimentary way in this case :P)

>
> Can't say i understand the change well enough to R-by, but I can say
> this resolves a clear bug.

A-b is often the way for that ;) but I don't want to be greedy here :P

>
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>

Thanks! :)

--
Cheers, Lorenzo

