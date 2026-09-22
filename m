Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC762C982FE
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 15:31:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B72886B009F; Tue, 22 Sep 2026 11:31:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B498E6B00A2; Tue, 22 Sep 2026 11:31:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5FDD6B00A4; Tue, 22 Sep 2026 11:31:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7B4806B009F
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:31:33 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 083761C2F31
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:31:33 +0000 (UTC)
X-FDA: 85241787666.06.253923C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3EF8880012
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:31:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oxgbajWA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790091091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VFYj6sjedfWGEBuGl++9heS9zoD83sYWZIxoZFH52Mw=;
	b=rKlTXVbaSXER4LSy43mCMLYTS34nf0VUCsU33CEmbaM8H0h9Hr2BjtsXe+vUHDzTYFIChZ
	J3vog2AN71TuUgMzm5FOaXlxJrLjxTx6LBZcjQJQws7b2luu1zBGg07wJd4Xfp15pGm6k9
	J93puntu2pBVKC8XHI+xmcRIMIfwGVg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oxgbajWA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790091091;
	b=Joeumb6X70sn1+Yl2Ivc1Hp2vT3n8LcjqBR+E0dMRhCeHHR4AEieIHYDvWXKytfRMmvMmd
	JqWWoFOBR2iMqPbYz56FwebhHOLEJTY8vyP0C4hpXWoeiQVccUnTuS7mqnKxBhM9iFEEDe
	KPIu20bB1X+pA9/zM9Oj+XurM95H99U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 81B3D40DC1;
	Tue, 22 Sep 2026 15:31:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 971F71F00893;
	Tue, 22 Sep 2026 15:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790091090;
	bh=VFYj6sjedfWGEBuGl++9heS9zoD83sYWZIxoZFH52Mw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oxgbajWAx+ewgz3EYGgJPYtZfNNrVy2jiDvlrL0XB6QieOmgNe9oJ8tWYTAmWkd4E
	 40O1bShYyuGwabzOZg2yryGvTCOWVoLErNmP15TezU6CcK1+IP50a2puK4iDmaw6R3
	 PCwUfPw/jYwdSq8HtaOBJAU/3KQvk7VOfDVSLU+W6MZTQuGVG14os2s8QuaTXuRpZy
	 c1E7BQMp5Oh5V6N9yXEOXRU2Ns8Xz5BjaAREZfd68p1jzII0svn4YeEB6D4D+XgUXP
	 mn6RKCk0xuOhAtFCkmd48wAcJ6k5w8jrTIJhK2olCjTjtXsHqi1z/Ac++TcJ8CKg7E
	 LVSLUkJaZCs2w==
Date: Tue, 22 Sep 2026 15:31:25 +0000
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Nanzhe Zhao <nzzhao.sigma@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>,
	Matthew Brost <matthew.brost@intel.com>,
	Alistair Popple <apopple@nvidia.com>, ceph-devel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>, xen-devel@lists.xenproject.org,
	Gregory Price <gourry@gourry.net>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	linux-fscrypt@vger.kernel.org,
	Shuah Khan <skhan@linuxfoundation.org>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	linux-kernel@vger.kernel.org, Nico Pache <nico.pache@linux.dev>,
	linux-perf-users@vger.kernel.org,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>, linux-fsdevel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Trond Myklebust <trondmy@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, linux-doc@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Hongbo Li <hongbohbli@tencent.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Byungchul Park <byungchul@sk.com>,
	linux-trace-kernel@vger.kernel.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Barry Song <baohua@kernel.org>, Kairui Song <kasong@tencent.com>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Muchun Song <muchun.song@linux.dev>,
	linux-f2fs-devel@lists.sourceforge.net,
	Minchan Kim <minchan@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Thomas Gleixner <tglx@kernel.org>, Anna Schumaker <anna@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alex Markuze <amarkuze@redhat.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	linux-mtd@lists.infradead.org, Chunhai Guo <guochunhai@vivo.com>,
	Jonathan Corbet <corbet@lwn.net>, Dev Jain <dev.jain@arm.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Gao Xiang <xiang@kernel.org>, Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	James Clark <james.clark@linaro.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Borislav Petkov <bp@alien8.de>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Tal Zussman <tz2294@columbia.edu>,
	Ilya Dryomov <idryomov@gmail.com>,
	Oscar Salvador <osalvador@suse.de>, linux-nfs@vger.kernel.org,
	linux-mm@kvack.org, linux-erofs@lists.ozlabs.org,
	Mike Rapoport <rppt@kernel.org>, Ian Rogers <irogers@google.com>,
	Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>,
	Peter Zijlstra <peterz@infradead.org>,
	Dave Young <ruirui.yang@linux.dev>,
	Yuanchu Xie <yuanchu@google.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Yue Hu <zbestahu@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>, Richard Weinberger <richard@nod.at>,
	x86@kernel.org, Ingo Molnar <mingo@redhat.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Usama Arif <usama.arif@linux.dev>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Namhyung Kim <namhyung@kernel.org>, Juergen Gross <jgross@suse.com>,
	kexec@lists.infradead.org, Adrian Hunter <adrian.hunter@intel.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [f2fs-dev] [PATCH v5 00/17] Remove PG_private by using
 page/folio->private checks instead
Message-ID: <arKfTXizFeTeKYDx@google.com>
References: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
 <20260922041600.1240429-1-zhaonanzhe@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922041600.1240429-1-zhaonanzhe@xiaomi.com>
X-Rspam-User: 
X-Stat-Signature: 5dijnrsqiqc1qy6ecy7char664jehe35
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3EF8880012
X-HE-Tag: 1790091091-317029
X-HE-Meta: U2FsdGVkX1+4GR8MLGDMTJ/6s61wKt1E2J6Wl0vRPRW6PonUT1Hz2y9LYsJLCUlwNEMi/VHHfVdk2F7LSjZRoRZ4HZMFSVynLFiaH2uvpfuPekKMoMsaSdbcg7qTvXsJuG6txmp92+qWTvkOjrmaMIfZWBBbGSRM8zoZIKPi/6MHkB89qGanHK5nXgEKWcNBRmnHW5FGyhtHcx6r70c9B6NLilSAd4Yzje3DWg1aX2G9ekerSYmd6osCmtkKiFzkndX0+wAqVjVKbgPWigmJeg936mjdqGR2zSL6mL4hdxXmntH9fqmVe4AM3VJYQmiSmSHClsKxK89hs+/ZFbre0CE1SGphoAx0oWrhx6o6a8sJ6rZpfMl6mFo75IWcYy6PjRCPGDR2p1lfDTU+DvooQSaSru9mylEfu2nQ2aN3fF2bsBnlKc079V6DzyMJnrIJ5PxH4CNG6E/dZJ+1L5nWHtBQ57XCD/dEeucDBwibOdgwwGEyG4nrzaPpVipcPvJnKmB4sdstf0gAvBORwxXbqYe9dP/hq6cGlv9dLS1GpyQes8/HKWxXaloj0RpCXoAI6ss9ue18MCiZy5tUvuSFjc0oOh8XyeD8hv9oM8C2QG0ik03eT+8+CCogCCAU582dfwkfEG1ewZXode+PDHj1wUHbBu7VmsXG4o3lArWpCSKyhpeBalMIR4zs/sKQpSvTSHv5m82VyhDEajenglY7B0cFeBsBQ59v9smwe7R34XM0N7fubAU1vQOzyI3WrX9uNNROnGJJW8kdauTjk/C9h98cUoWA86+mBiJR5KS+OTlapZdGNoVAQhk8Nw9LhyZIiXscJlpmWazuzIDaPQwEVkIn7zIc+L1WmDQRBdFYFDMEqbahFml5gFWXkv0kViQgLFQ7czfj9vkIBpdWbD+PobPxT4clSmY3GO69n8KdacYSOvU2d/C4k6xkmINPUJ6OxTN2DFZ9LFrwL41iv13
 1ND4mfW+
 RBeFfzGrnvL4Q3Vj4ZmXXlcsFObuyp5q1ZEvZRaSpWtOTjwSreZ3V/1MR43nIeriFOP+g7iZWI+JDLDPJezzkUSd0lMSNTlMSQt8kNcfhUictNBUttQvEs2KZEfCEe6bY5oWdJTWwsgznk1fWjzETogLIopPqt6Yx6C2Z6JD5KBmfEtw5Y9i4ayfSj+dmZTWsmaCLuu/aM+sbJ48leQobJokG64eE8ZwEckMUmIuY4RrEy2FTHZpE5mL9LLA93oaMp5+FxqRyd59IPSHZoc6DtIwR9EvLrlZCPlGZK8xZG3pXlPtmBlwnGeXRcrrami+RV45BkG0DqxrF1XK7moUVNTsZVm3YgzI59ug+3TBhF6dcptx53rqtUl6r/fDNob4ONPwjMaH/hLB+pMHwzEolUYwLvujKMWPuw3QOjagTpWvhgQIdDlhvTddq2OEzU5dNtxOr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/22, Nanzhe Zhao wrote:
> Hi Zi Yan,
> 
> Thanks for the series. The cleanup is a nice help for the f2fs
> large-folio work -- it removes the page-based private-flag plumbing that
> my series would otherwise have to carry itself.
> 
> My large-folio series v2 [1] can be rebased on top of this series. The
> only overlap is the PAGE_PRIVATE_* flag helpers, which I can re-express
> on top of the F2FS_FOLIO_PRIVATE_* names while keeping the
> f2fs_folio_state indirection.
> 
> Jaegeuk, do you have a preference on the ordering here? My personal
> suggestion would be to review and merge this series first, and I'll
> rebase on top of it.

Let's keep working on the f2fs tree, since we should not merge this in my tree.
Later, we'd need to prepare how to address the merge conflict.

> 
> [1] https://lore.kernel.org/linux-f2fs-devel/20260915041909.2903887-1-zhaonanzhe@xiaomi.com/
> 
> Thanks,
> Nanzhe
> 
> 
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

