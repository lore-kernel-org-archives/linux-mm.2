Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF687606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 17:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EEWUUcqa
Received: by kanga.kvack.org (Postfix)
	id 0250A6B05B1; Wed, 18 Nov 2026 12:21:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F18736B05B2; Wed, 18 Nov 2026 12:21:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E063D6B05B3; Wed, 18 Nov 2026 12:21:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BAB256B05B1
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 12:21:18 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3FD7AC07EB
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:21:18 +0000 (UTC)
X-FDA: 85448905836.06.4FCFB51
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9A0674000A
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:21:16 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EEWUUcqa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795022476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hesU+4ldnvOaAaxjWfy9d3z/Vr2tFTg+8pWVNqtk5cU=;
	b=q19b+SGjZQ7EpXrw3QV1syMcNofyLewE1JzfQQIezFBkEMyfmqdMXcPJrnC091pZSDLjtH
	EdSpdOEfkIUhecO1KCeY2GIjWTjmfIHjd7r8gOe5hsvsihVfJh+nb2MDl94YLUjBKCImKT
	q1NaXz0GB3WPW1R0VAG/TF7vFuKNMzY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EEWUUcqa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795022476;
	b=zE3uHfWdKu92aRTcwTJvgfQPsCxGxWR5ci9UQy6TdB+Br16a8Tm16NQz9ZRC2QrPUwcBzP
	n5wWLFwMZiKQmudycDVJyt1XmGc9SUbmxQJsWF4qxpC2X6oGnC8Glz01fJoLFAKCHLj/Xv
	QSrFa1ORRk+FIUTvzhhMfd9DLRF/plo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 89AE46335A;
	Wed, 18 Nov 2026 17:21:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 719561F000C4;
	Wed, 18 Nov 2026 17:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795022475;
	bh=hesU+4ldnvOaAaxjWfy9d3z/Vr2tFTg+8pWVNqtk5cU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EEWUUcqa6leUkgcsEpfc2x29HRzw+OIdEg676QIVErDCbR3H3Ezwu5rlrejP0jH7X
	 lw5CugG/Qbkwi/sl1A86PLQvpSjvi3qJql1cqAUQM+6pZZncpY6crwzk5llTn7WyWt
	 o+KAI1Vgxt9x9SR0FeOA++Scoxwvce/u7eaULOIgwAQf+MrwWLrEoVvng6VziVq8wA
	 Mt4963yUj3GZGBy7po/Xd/pFd2gQ8a41eqmZeeb+BMGoMvSljEeJsVlm9aE0HR91pg
	 vZrYMozjVeF8Yt2c1vKQ7LB18IhCdxIo9XHL+QCmDNF6gdXh/hGfwi4BLpc2LG6d2W
	 lpqqKfEt3Ohkg==
Date: Wed, 18 Nov 2026 17:21:02 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
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
	stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH v2 00/13] mm: batch of (urgentish?) fixes in oomk,
 cachestat, dev-migrate, percpu
Message-ID: <av3dRm-Gkx9kcYWj@gremlin>
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
 <90a961f5-e488-46de-8872-0e1540eaad4c@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90a961f5-e488-46de-8872-0e1540eaad4c@kernel.org>
X-Rspamd-Queue-Id: 9A0674000A
X-Rspam-User: 
X-Stat-Signature: sc3qgy7q8fgzg4cptikddo9j1hjad1x9
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795022476-896773
X-HE-Meta: U2FsdGVkX1/jtHS+2YHBbE+wUvacMQ9Rfe/wf5E9RPAHqOZX73w6lRNrQefsHT2c3jRdQ21VAa7r+KNDfjfdLulykk6YMjo7hAsLgj2pDZlfCP/SDWUZSd3eA5A1O5Eaj0Ac12QC9tKk7yAOWB57/Swm4bbctaGahts9HJ00YC4noFv8jSh/OXh9J4rlYNTeq0dtiMRGWZ1HSBiYRckkbhmHeuuinZLYJUMmVpATcJBQ38fN4TRVAem9wIGZ//zVYVnKX8q3TjtU40NOYX9FDHH4bK03a3KyCao9AN168itNNVFFhLUe+Bf528K7BELObNWG5T+/jnJAuFvEMIsvZj09TlF7wYF1lyOaK01xPih+9KtXXkZ6gvMCPL+0zC13GfHI05K4TRIZiy8+OBWMHSy/VUsEfedktRlg/vvFWxOV1ZpTUZK8cPt36Fhs/nq84oCXX/yTojvx30Lz6hBu2Y9ABlFjcMpqbRUvuREQ6RCScFEEXawjr1HvCHkFh8oQ+YApgY2eB+UTUZJuhjP7bX8VC0YatBv80RZCL4UBa2LTgG5hbzoaUtuyvdaqjGa5YZyH6q8Rq43l5FxlQbGC4gYQiPujKQvJJCyZDT2cBdZvDRFEIVbGWxGHZjOjJsBRzPdGjZQjjbF5JXCjeESOdaCV1ndPsunIEQG2bY9cBVg3DGyx5iV/1jER4cN4Cn7MHGMu+XVOCleg3CwO6swRU1JdIigP2fLppZF9C9XT6cIU96y166R+5jpzoc7X8KILE/WqKQ5msAdv4IwxOTg1bjyDkgGVr0Nw8UIx3a+t8sj3dijKUeYu9zalZ1FI6qF3SRnOfpvVjzjJowFvpOiObY1XXHbfVKd26QVwwbdXpPyHrUL+1k6iAA7I3n7XAT7vNTac3DC8YgqQ1FDORWEKrqXUgipVlI3/zCE0+8JC0bSMDUjJ+Qw52py2gr24NmmmAWLzHQpVT8dHKVFJG0K
 4OiZEWIo
 yXTHtyFc1rtRpmW1UyPMvkgqWt/WQAV4n10qmJQ692TiPHD8oIKpfnvpX7rjaVdZz4Eg0suvgsHB6HGet6EPlouzUn7POqIGZq95/knd9d4iDTptdUXhCK4G9XiTYsuqgm929Rr87eKc9OuA5kSOQ7fZ5MZ+HtS5+kT1RjV3iny4OlWLcBplHj6yrREx/YknJPI/MoyjN3IQLP2L6OQe3c5O3y0vOChW294KXqIRdov8oBQz6IAHZ15+dOo6ojGM1G3fGoz8piu5lNFK7oP+aqQAUWh4RzknCOFO51AGqYKDbCJqoIc9vN45RPDhlUOQklTRvOQO0iioDcMsgqniQ+uu0s+aHqt+Bt80VcTWDmIx2sov4ACGqBKpl/NM/ypijU2mY+5MIDjnC6EQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 04:35:32PM +0100, David Hildenbrand (Arm) wrote:
> On 11/13/26 22:45, Lorenzo Stoakes (ARM) wrote:
> > A bunch of fixes for oomk, cachestat, device migration and the per-CPU
> > allocator.
> >
> > These patches were originally AI-generated, tamed into upstreamable state.
> >
> > Some are more reworked than others. Those which needed a significant
> > rethink are submitted as mine and marked as Reported-by the relevant
> > original author, others are smaller edits which are annotated as such in
> > the usual fashion.
> >
> > Please check for correctness, sanity, and whether the cc: stable is
> > warranted (I have not included it for 3 where it seemed unwarranted.)
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
>
> Lorenzo, I would pick up the migrate_device patches now.
>
> Which one should be fast-tracked upstream and which can wait for the next cycle?
>
> Use-after-free, shadow stack and out-of-bounds write ... look rather bad.

I think given Gregory was able to repro nearly all of them, I'd say most. They
are mostly small. So patches 4-9 I think should be.

Actually the shadow stack one (10) is unrepro'd and super borderine and requires
a broken driver and etc. etc. so I'd say that one is less important.

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

