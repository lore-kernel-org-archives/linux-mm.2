Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A422606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 12:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CsCxIx0m
Received: by kanga.kvack.org (Postfix)
	id ACA326B05BC; Thu, 12 Nov 2026 07:14:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7A816B05BD; Thu, 12 Nov 2026 07:14:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 969B86B05BE; Thu, 12 Nov 2026 07:14:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6DD696B05BC
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:14:48 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5A1D0C0560
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:14:47 +0000 (UTC)
X-FDA: 85426360614.28.85BB6E2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9D075A0005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:14:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CsCxIx0m;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794485685;
	b=rgUPMEbOPngz7aM9qwv3kukyT9Sx1nxQNpZyQyy3hus3UA+MNqZ9cS66YFofTx6Du4tsiy
	8rpbgICt7F0OBGY240dDpuAlm/Tjfe2Nh9ucaHGJD9qIaDXSQ7rbsawKnEDHbRG/gxr7dr
	oNOcNZhUS3x5F5nyOkpS97udBi8JtLg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CsCxIx0m;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794485685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wSnWAvHtOMLFz4uzS2KYZ1SGi9EBgJHHln4xOPRtuRk=;
	b=b5Cits1PqApkBte7oQBq3VPPxfFQFLE2IYmkSjWlRHlfHupTnVXzlZKi9jIRdKFaDozeFL
	h2fjS3vM+t7/vcxtOZy1RkaMdCrR5YBJ7ISmUXfvx8aOH2A0aB27ssiPxWeySA+sfELstS
	PTF7HJLaWh2jS6031nIhjOAuefjWmrk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 17FBD61255;
	Thu, 12 Nov 2026 12:14:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F2E41F00A05;
	Thu, 12 Nov 2026 12:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794485684;
	bh=wSnWAvHtOMLFz4uzS2KYZ1SGi9EBgJHHln4xOPRtuRk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CsCxIx0mR38bvlIFQiBxk6+Y9l6TgU4JRu2TXLPxpT1XJ38vOTZZbnd1ZUZe8XzPb
	 dZATWSN8bWSnf0qiSj/ZV8qjWjo38tSH971twZOTE//E6H7RuMnWH6EZ83OrW7/kDw
	 oid/SOUPKzABd6rrkVbxx5EYkuvgwW81uSn/A2OeHHZgYBQSEKwKF3jpQt8pHj+z3D
	 HXyrC3HAd8WA+VnndLLwi9Oflq7MJ58ptZ+ulVlE2e/x1xoHcHSjCAVGIUAC4hxQGo
	 4MqCwGhcqHsaFME19gmDjPiewxeNNV7+idvhLMxcj7jTNhpL7vEnW4qPnCkPZYmhwq
	 ZmrmnDDcAZhlw==
Date: Thu, 12 Nov 2026 12:14:32 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Michal Hocko <mhocko@suse.com>
Cc: David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>, 
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Yu-cheng Yu <yu-cheng.yu@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, Chris Mason <mason@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	"Borislav Petkov (AMD)" <bp@alien8.de>, Mark Brown <broonie@kernel.org>, 
	"Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH 01/13] mm/mmap: free gathered pages before MMF_OOM_SKIP
Message-ID: <avWsG-zmuniUFio7@gremlin>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-1-3d2454362e8d@kernel.org>
 <avWmfXu39vtp0DM9@tiehlicka>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avWmfXu39vtp0DM9@tiehlicka>
X-Stat-Signature: 3gbodp37ar89aocs64yjiks4exzxx37q
X-Rspamd-Queue-Id: 9D075A0005
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794485685-354749
X-HE-Meta: U2FsdGVkX1+XD/hzMwJd7TuOVUbrNqVpCmbrfKCQv7qi1+QoFo5ms9rHv4yMbzpT9exihyl4WbmerzsUnvDKmxLhGkXNQwW0MBqCn0YZZ+dhY/Oh7K1zUlcx8hpWC7nk5hOtQOlEMxK3y26XGvn8nYf6nAOZufKClbUFNwqA8HU4LzDC9P6ceeo7IQBbsRax3g2cyfUB+sx3zrz+NMzSGjXAx+t/MmcMe/19CvckI/H/oWBG35zG6HQImrsoYAcvzqZJ70e787G2PlctbOYvDVILEpUEh4/wwmAMUa4q/DjtLeovdYFSUp9jaZNehZMamJxP/GDAugSyhiz1CJjmwoZaqDiKZDsfS3Iv+deh7nAbVdwY2WD4lBA5h8lqHxhPPZYDgOxrQavYVv1iFnOh+lM9J6UJhc8s28L6QwMqU+64JhI4sSirCds3e/xdPL5QKSTznfz273siuOV3xMJLpKES3LjKdc/r/SpiVhxGamXm8puHtJE7cjw0V14mYb0VZ4QFI4yLxU90B7wIo0GGD+MbcaBGphNAa2oqHl8KlJ3aazZ0Zea6i3wq1goQxd8QHSvqGat9oOx9jqnjN2ziPCLaRqnzQf0B6TuHzdG7B5Gm7/7LAu5zJ1187JleauxUtCRCw3TsKs4BrZOjct7P7XnyZ4Tw8tVe+IcrcxqRZIljVxYl1YNwotVGKia3ZAzmTD6V0DMhm1qCtTvd/ePaA2p0KWtFOkAuZhUw8aOWexWcomgGQBvRp7RRn7leXsiubfAGqrfhPGmaeKNuZhXngQiSF5ciwtVXNPUh6DZ5w7ppjeOG4E47fYueo+8cyx55AtMNGIfPDoY12XLSpY67KtXDo59oD6ndhoWs7oeNY9nT5TLpVjEeAn+frE7Mt+ZQdF3BwKV1SemNzG9Zm2FXRtxHXp2TKD00cI0zP4IPE8F1E6KyLFikDOaDu3WEDuhUQMYyGlgQnhqOzoSIaGo
 gG95eh9n
 Ja4wJlkc12tPDA58qB8mELv/Mrf3xlOzrOXOBywC9Yjq6jdmBDKmn7lrqDwWdoOlIlyYnIkNecNfO4geWX4Sbdk7oieuHhoBMME3di4w/9jN7Rsy+omWokAmIYDJU+4A0VBUDhJIl2LLbAt4cSZBK0NiAUrc+m4+SayncFFdjWeznlJEKHNk/u8vpSZHif9DUoyEJDQ5onJtl3w89wSF6c/fvD60snbxpvDx682PkjIubTBH95OCL4I7CIBSQxpF8d/GW0730hOH7dPwK0IwTf575CMXsSGsyFj0VZgfDJxDKLA8nxSnFMuiMit0DPSAH7adx5iZ4Yqk/mZrVnpEL8DaIjuo1hIjexoOMYjiN6XpIk1XvbqjeOo3QxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 12:43:57PM +0100, Michal Hocko wrote:
> On Wed 11-11-26 18:13:15, Lorenzo Stoakes (ARM) wrote:
> > The OOM killer can quickly trigger again after having selected a
> > victim. That victim might not have freed its memory yet, but its mm will
> > be marked MMF_OOM_SKIP by this point, so the OOM killer will ignore it.
> >
> > This can cause the OOM killer to kill an innocent process when the first
> > might have freed enough memory to relieve the memory pressure.
> >
> > Fix the issue by freeing the memory before marking the mm MMF_OOM_SKIP.
> >
> > Note that the task which calls mmput() might not be the victim - if it
> > took a reference on the mm (e.g. ptrace), it may hold the last reference
> > and release it when it calls mmput().
>
> I do not follow the reasoning here. MMF_OOM_SKIP is called after the
> address space has been unmapped either by the last mmput or the
> oom_reaper (or both when they are racing). Now all your patch does is to
> call tlb_flush_mmu which I suspect is to release batched pages. But why
> is that needed only for the oom victim and why there was no final flush
> in unmap_vmas?

Sorry maybe commit message isn't clear enough. I did have to pare these down
from really massive ones.

And yeah tlb_flush_mmu() is about freeing the batches.

unmap_vmas() doesn't have a final flush, it relies on the caller to figure that
out, and just batches up.

And currently tlb_finish_mmu() comes after MMF_OOM_SKIP is set (in
exit_mmap()), so at that point the memory is unmapped but whatever the last
batch is isn't freed yet, and the batch can be large (PMDs are single
entries if I recall correctly for e.g.).

This only matters for the OOM victim, hence reinstating MMF_OOM_VICTIM, which
made the patch _way_ smaller than the one proposed :)

>
> > diff --git a/mm/mmap.c b/mm/mmap.c
> > index 7618e72766a5..4cb18b217048 100644
> > --- a/mm/mmap.c
> > +++ b/mm/mmap.c
> > @@ -1313,11 +1313,18 @@ void exit_mmap(struct mm_struct *mm)
> >  	/* update_hiwater_rss(mm) here? but nobody should be looking */
> >  	/* Use ULONG_MAX here to ensure all VMAs in the mm are unmapped */
> >  	unmap_vmas(&tlb, &unmap);
> > +
> > +	/*
> > +	 * Free the memory before marking MMF_OOM_SKIP so a re-triggered OOM
> > +	 * killer will only skip this mm if it's already freed all it can.
> > +	 */
> > +	if (mm_is_oom_victim(mm))
> > +		tlb_flush_mmu(&tlb);
> >  	mmap_read_unlock(mm);
> >
> >  	/*
> >  	 * Set MMF_OOM_SKIP to hide this task from the oom killer/reaper
> > -	 * because the memory has been already freed.
> > +	 * because the memory has been already unmapped.
> >  	 */
> >  	mm_flags_set(MMF_OOM_SKIP, mm);
> >  	mmap_write_lock(mm);
>
> --
> Michal Hocko
> SUSE Labs

--
Cheers, Lorenzo

