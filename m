Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD9A9606D812
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 15:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D0OBt12S
Received: by kanga.kvack.org (Postfix)
	id 0E9346B05B5; Fri,  6 Nov 2026 10:22:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C11A6B05B6; Fri,  6 Nov 2026 10:22:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F18D76B05B7; Fri,  6 Nov 2026 10:22:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C92E26B05B5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:22:31 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5136B40E15
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:22:31 +0000 (UTC)
X-FDA: 85405060902.09.952F9B9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id A16891C0009
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:22:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D0OBt12S;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793978549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z3y+DELGAxT9V5PmpfgouMZn+gCc4O45ROBPQSi1BPo=;
	b=kFc7KZ7djclroIEoz9T/bWJc8ZRg2ZU+crFxU3pCRcIaAHKrJuVc+KmSTNVJjQURZ/1dKy
	NXnk2ISVJ/CFqhmzrfX9eLe62xEYwBiPv+id2gG4DFtJ4Xx8XvgRuypcn3MJjhNP8M9cid
	xptXRm6Ms/Dbov2QabmQyfMlIXM4u4Y=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D0OBt12S;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793978549;
	b=Tlv45tCfhBTvCqi7MyPqgsCGUaLNwLEwt2El/xY2U2Yy71NZ2SdxS6KQYo+Jf5wDyW3bRt
	Mqx1XmuGOvXgTFa3NYOh6WgGhw9NbZiWQPMmdyVG+sJrKZx53g+9pixxk6xKfEa7HhO/cT
	W5//h4db394W/5VEE/YiY3pfK7zmFwE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E937D601E3;
	Fri,  6 Nov 2026 15:22:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C73F71F0089F;
	Fri,  6 Nov 2026 15:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793978547;
	bh=z3y+DELGAxT9V5PmpfgouMZn+gCc4O45ROBPQSi1BPo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=D0OBt12S5A0/61ajOHRCOvVj9Y496CxzkIZ539OmP2Egd7lJ1ZTg+93+bz35MlhhQ
	 aEcmgJvs2K1rXKjoPty9afP418nmgDzNbNz3R49xM82YI+IZppcn7JPT2+rOR1oP3E
	 aXPgvNxlojcYTHikG/NcZ6k0ko8+NVlu5A2DjoEJYkhK0Y6iRimNr2X51btaRYAQe4
	 3oYkIoHH1FFpK2QL5UAfs5I6l1ULxHTF3yATZiallmsTHKUql1MDHJSRDkOp7LPZaS
	 WDiRcIhr4R/mT8uJ1TsaVWpbDwDHCB8mxh70Ac0iVGTP+nI77JgCBpwlXJfuSijYjQ
	 cOmEIk2xUD+nw==
Date: Fri, 6 Nov 2026 15:22:08 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
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
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>, 
	Roberto Sassu <roberto.sassu@huawei.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, 
	Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej =?utf-8?B?TW9zbsOhxI1law==?= <omosnacek@gmail.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, damon@lists.linux.dev, 
	linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, apparmor@lists.ubuntu.com, 
	linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, selinux@vger.kernel.org
Subject: Re: [PATCH 00/13] mm: continue vma_flags_t conversion
Message-ID: <au3r0-geuwtRYPiC@gremlin>
References: <20261105-late-2026-vma-flags-v1-0-0d3cd15ab75f@kernel.org>
 <d0ea7929-7c12-4245-ba3f-6dd5c0269e6b@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0ea7929-7c12-4245-ba3f-6dd5c0269e6b@kernel.org>
X-Stat-Signature: ptppj57x3bxkystxtrfot7ccfetrrxcg
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: A16891C0009
X-HE-Tag: 1793978549-976092
X-HE-Meta: U2FsdGVkX1/MVxSWBAoGBaNDdvWAZ2gZYGKqsnM/d9G4UNy5XumcbN2AIL4QXPE+Qn5GTcd45eLP+MNhbmQHFgNu3EtFM8VCk+0H93U/ZHx5/40onlw7EfJrVmL6QzhlP9V+5gCW/f2uaO8mX/DmfpPIj1LJilE+oyvHaHB5BrHDiyu9EKFqcReUXCt0sPBCJcC5Iq2rXfTJet1nVav0AfVaZZkObYbie8Lq4LiZq8UxI52Zir3KtYS4BUDaq72km4YvGHVnbjVtfsLj6Kxo2/uHclX9lyLg2JuxQ62QfXQ4o5rkX0zQchieYGtdPOW4QAbRYqmjgXPqAAqz7pYLtgsdbPZoJZ8pACmT4hITZWo33wglLmZI832DEAksMJSqwcZD5Biig3CLs/7RUZa8QDK6jm7LAFRMiEqYjwNv4lgpsZIBlgRo+LV7R9LQDwCzAVSFOm+JV3PkiNTVS5/EiYMZ1uTqvBZql+5sfAWKQILrCqEjhO5cKQ/Qd67wbEXdSE+dDKqEACjYlBaG9cD9ZFfzApFy9V4R2mxQWPPe/OWbv8dhiNc/ZE2B+UDgWn6k+dc20A2EJUpjZ6n/93dWKnUShUHF6tYUP8JNaQr81m6KspTHEFCLWtTEbBFTcQBq0NvDrnAwXTkYv1EKcwq6HBbTJll5oYrGb3V1aR5+pz06g5h2T4sG7L7SDS7h84l9+QPsiALEnREjuVnwcg1W77VXb6Zuork6vErsO6BeGNB+AssVAmuS6GYX0w4X0fDRogjDDpx5Hkp5KKBHPanDmXrGbo4W6KX39GTPlqLU1JGl4X1A88VEieMwjwKfsM+uMTvpLa67GbT/eP7fyXG9e/3FFk8WWPEkVKp5mBSmLJjWZ13W1Xp/f5iKhcTHKWCpzoXLfrxYx63nDRavw9cLRfVkBwim+Ex8wTAkB8GiyRclXwYHoouMS6uwbYQ8Kp/ztNwHVamJ+qT6+waP6PV
 nmQnOX9Z
 2pNSghvz+D9gZjD10FyIRT5E7K+Uy7de4fSFBq1m49YaT6+38jrlZuFoj7ZeeOxbhnGOxtDpAQpnBowNaufihtIj6wAul1qMvzosH7Elu52oHCAKNe72DrjPPrs0Ape3vcCA1cx2Ao+KswPEU16RveaRymUyZFd/vwehyJ85tD/AjbfSgXJKAjHHydRDAjhRjwXsWVv/cHxA/70pXvU1P1Xa/bpdk1Ug2BhkJn0OVftYawGMobIxUiTUTqLAT51zej8HfA9YeJBytgxYJKjxdHZn3Kx5Jlwf1p2w+JFobtmHOG/0YKF3en8F4JhOC0FEv7xqHEIS1HXkSlu2wGXKjcxyO13X877r6PfqssQDkVzIq/rLnRr9+7yFB5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 03:35:01PM +0100, David Hildenbrand (Arm) wrote:
> I agree that this should be picked separately. For example, I will pick
> everything that falls into my realm to reduce conflicts.

Hmm, generally tree-wide mechanical changes are the exception to that rule
no?

It's going to make the rest of the VMA flags/mmap_prepare conversion really
quite difficult if I have to chase every single driver maintainer in the
kernel (literally in both cases pretty much :).

And sometimes there are dependencies which mean you really can't split it
across trees unless you establish functionality in one cycle and callers in
another, but that seems a little silly.

I was thinking that once the VMA tree is separate I'd put mechanical
changes like this through it. Is that not the way to go?

>
> Ideally, patches really only touch one component.

Right, but sometimes functions are declared in one place and called in
others. It is impossible to change the signature of one without also touching
the others.

>
> [PATCH 07/13] mm/madvise: convert madvise_vma_behavior() to use vma_flags_t
>
> is all over the place :)

It's not really all over the place, it's converting vm_flags_t to
vma_flags_t across madvise.c, which involves changing a few function
signatures, whose callers must be updated.

I could split it up into 3 patches where 1 does internal-only, one changes 1
function, and the next changes another, if that works?

But there's no way for that change to only touch madvise() given the
function decl/callers.

--
Cheers, Lorenzo

