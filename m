Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 466F4606D803
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 10:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YwYtVdd3
Received: by kanga.kvack.org (Postfix)
	id 81F4A6B05C5; Fri,  6 Nov 2026 05:13:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F53A6B05C6; Fri,  6 Nov 2026 05:13:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 697F06B05C7; Fri,  6 Nov 2026 05:13:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 437106B05C5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 05:13:49 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B2635C0D15
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:13:48 +0000 (UTC)
X-FDA: 85404282936.24.83D49D7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1411C40009
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:13:46 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YwYtVdd3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793960027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cFVMR87EGNpkNOCnSwEX2b70j/gGYf8Jkc9yEvS8W5Y=;
	b=I7o9VNEFvC5M7Bap2IYUcXMDXGIYs0bmbnONj3xREr6xskIsYv4ejH23oGoHpw4F+1rSPj
	Q5IJBAbEsemxAgC3jnSxEEbAK5v/vcq5KqXn2teFRKq8iOmLruI/6oQ3jTZRUzmLogaXpH
	Egy5CBk3h06suJcsh+7oumMbhJyV4dA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YwYtVdd3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793960027;
	b=5QMpUKUiKKGJPWpeRzs5aflMeglMNg9cQcSfuaishlQIDKMkLmouy/CM/57tGHrZcobOY8
	apn9ojh1va98NTRDJG3RO9s6fpvsUoB3eLBknt2sm2Ci2SbqGXY5xWmH83j1vgLgUTyOcg
	ZCgSXzCloM7T67VlFBW9xwZMlTOElgo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DCF9160CB9;
	Fri,  6 Nov 2026 10:13:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE401F008A6;
	Fri,  6 Nov 2026 10:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793960025;
	bh=cFVMR87EGNpkNOCnSwEX2b70j/gGYf8Jkc9yEvS8W5Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YwYtVdd3f+9r0rGtBh8d1tRPhVBL4qmvxhKCMZkV8lomBwDWV76lkDV2ZPvzrsUcy
	 trEyAB1TCppduadMVhftHMFVxgeYolc/EMPmtth1hXWiwFgz1kQ0EKU4byddd4Ylof
	 Kw8NW48Kkjzx+SlpAufJOnfBvexabI3n6q9ar/Hme/DA7MCCquYR1YVU8yI3FmAIG8
	 1O4CYPlx4m2ZTD5HMwTNZOFUugRf4D3Ab0jOV8qahLlzSisYMSFxFIYqDA/1U31men
	 TNFTuhw5aLNcrLSy3wXMfK9DUwkHBXM2MWRhS62JTGof+13zFAAyi0DL6QeEKCjKfL
	 pWOWcHUvqbeJQ==
Date: Fri, 6 Nov 2026 10:13:27 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Paul Moore <paul@paul-moore.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Rik van Riel <riel@surriel.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
	Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Shrikanth Hegde <sshegde@linux.ibm.com>, Pedro Falcato <pfalcato@suse.de>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Leon Romanovsky <leon@kernel.org>, SJ Park <sj@kernel.org>, 
	Rakie Kim <rakie.kim@sk.com>, David Rientjes <rientjes@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	John Johansen <john.johansen@canonical.com>, Georgia Garcia <georgia.garcia@canonical.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Mimi Zohar <zohar@linux.ibm.com>, Roberto Sassu <roberto.sassu@huawei.com>, 
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, Eric Snowberg <eric.snowberg@oracle.com>, 
	Fan Wu <wufan@kernel.org>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Ondrej =?utf-8?B?TW9zbsOhxI1law==?= <omosnacek@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	damon@lists.linux.dev, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org, 
	linux-integrity@vger.kernel.org, selinux@vger.kernel.org
Subject: Re: [PATCH 13/13] security: convert VMA flag tests to use vma_flags_t
Message-ID: <au2ny_goOYa9TJ4u@gremlin>
References: <20261105-late-2026-vma-flags-v1-0-0d3cd15ab75f@kernel.org>
 <20261105-late-2026-vma-flags-v1-13-0d3cd15ab75f@kernel.org>
 <CAHC9VhSR=9YNhBxeFBcTR8wgG2yDP1fW590QKjzuc4Kq9ohaiQ@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHC9VhSR=9YNhBxeFBcTR8wgG2yDP1fW590QKjzuc4Kq9ohaiQ@mail.gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1411C40009
X-Stat-Signature: 6oxzuy595j386mwziw88wcqcotz8ntb6
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793960026-615977
X-HE-Meta: U2FsdGVkX1/sZx02AGEemthiqeksFEWjtA/nsRTZgyf8FpSYdvqoNBSxJaYZqeEVtVfE9y0X7jV8UAHgv48ORSasy8a3NYZBVFeMtRhL7SPn2lr9miLJjMcbkKNL4DCfGMo6b2nxuUJyPt+nQigQ7LUsnodHrvrX8N2S3QJ+yX/SpYA+ajCSlce/3LE+XqH8N16gdclf1KtKNAbkwFlMb5NCm4PQro0ZG60NXyZfl/5cVSD4sLKtX1i+ckoxIh0lFzb37ExxHXy8+t330bMsOrVnAiCj/2M9hahPdCei7im0d2p6XGi60qGVHD4Nis1dK5mHgd6UMTT/nXTgpUNrPq8KIvJSzcSuochar1AdUcafqNcC4U+Li5zKEsBOK0K+2NFLmLagO0Vp01XdndBFc3nvshJAupB1wlDPmj/LFRdUhFrn8HriLF+rqhaJ9MLFIrRpKqwWkfomlWAC1JoW+OXck0EwHCPmIaGGM7ELY/MzCLulsRrvT57hStjNsz438e59aGWDEoxF509JulW+4s9P/jKgRwnDeioYuIyuPHMxseWiJd1DJKgkefI0GvzT95ENkNdeI9TS/vJNMaxfai+YkTIBUB/V1O4d/uNE8aB70Xdg9MBaibfhp5nppj0S0LiEr7KdpCgcv6sek0t9atLNY9roJ81LPk2F5RstVMDN2DLvgdFB7UsME0iELtQhNvZWJ++o9Vj6+CoLoBzvnlmZ9k29c61igUw/dYeiPytGfU6rp/cI7GEPTKyB3lsjx+tF6c1AABNz0Ml79wyP9fEwaRL2gWj26R2odDfuScz4qViJLtjan2LLeeBZnR2dWaJ7G0UyHEoPW3ztg8c6iNchPVxEpv1GymAfKOoLfrtfWz8gWAyT2oPqqT8Ga04WKv+bkzyJCh3ze4IL1DOYp/yT8Nrq5Z+KwWVGrH2JJ6vSJWyMljucJT1uV6rzU2EN4zP6H5S2jtsQ1zpoJJV
 yMgh5P8h
 ToHPIb4IbF9AuN9vphRwR3ei9czYhDmZfJ3tKf3BD7UCsLmkbaAFyXeK9qvxu71mdtuy96YsxkRtOhA86WSKS8/OOD1RGhKXUeUmb/iEUjtARW1COM+5PTiMK2lOBjhHoKZYGaYdi9i5zbYmn4xi4B5HF1sZ7+hF+kNfy/K1w+ObJJC5G9miCvgpBTus0gL7Uzb4WtTczBbf3DBwRRvbH4bzfnc8SD29ui8RfKCp1w+c5o/ESHbfIK7fdy+I37Cazf1j520bNFHnGN4MY8DY3A1V2bVf+VFV3AZToxqr6KrlelaYGyNVGT/vat1akuhASLG35v3vkkbfpO+9BuOingTuVjwPM0Hd9XlTIPzzACQ/o5SrVQgrLdHz1Aa15fqgm45SOb6Y/5VsYnZFoSlclYpX95b+nenzWLevzQbJi1UM4N7w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 06:17:47PM -0500, Paul Moore wrote:
> On Thu, Nov 5, 2026 at 4:35 PM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> >
> > Replace use of the legacy vm_flags_t flags with vma_flags_t values in the
> > mmap and mprotect LSM hooks of SELinux, AppArmor, IMA and IPE.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  security/apparmor/lsm.c           |  2 +-
> >  security/integrity/ima/ima_main.c |  2 +-
> >  security/ipe/hooks.c              |  2 +-
> >  security/selinux/hooks.c          | 14 +++++++-------
> >  4 files changed, 10 insertions(+), 10 deletions(-)
>
> Similar to the other patchset you just posted, is there any reason why
> individual subsystem maintainers can't pick these patches up, or is
> there some reason I'm missing and they need to go through a single
> tree?
>
> If they can go through multiple trees, can you split this patch up?
> AppArmor, Integrity/IMA, IPE, and SELinux are all maintained by
> different groups/people.

Sure, they're all independent so you can take the security bits through your
tree, I guess fairly easy for Andrew/David to figure out which went where?

Intentionally made these easy ones given how busy the cycle is, just keeping the
conversion rolling forward :)

--
Cheers, Lorenzo

