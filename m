Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64CD1606A333
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 02:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m3Em9F4P
Received: by kanga.kvack.org (Postfix)
	id 0912E6B05BC; Thu,  5 Nov 2026 21:13:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0422D6B05BD; Thu,  5 Nov 2026 21:13:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4BA96B05BE; Thu,  5 Nov 2026 21:13:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C49BD6B05BC
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:13:54 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 58E201609BF
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:13:54 +0000 (UTC)
X-FDA: 85403073588.04.272AB13
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8E3E3140007
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:13:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m3Em9F4P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of wufan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=wufan@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793931232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SwgrBjqkdHVN89k2r7i2yZAHCG31Diqb92PenA1gCr8=;
	b=mNKpcw2ZF6ol+Fg2DWemw0gdamYOCGVqVP6ZOdz8n4PaUD0Hsq7x2CS0TvovpfOnFFPl7Y
	vm+u9VRQj4euCr1VTFxmk+vBgAW1jYu3ayU2dk1pSq48l2OOK6G0pT/6QnQpZiTeFy1dAM
	CAQ3hFiT04WiaXhxzQJGfoSZ2WFpYbQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m3Em9F4P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of wufan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=wufan@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793931232;
	b=UE5lWx5LbIng2+aBsWHBNplKfg2OXQFLs58XyrlglfAtjQ4nVH6cXQ3FsWaUh9J3g4MZnM
	GKOiZnoev9gQO+t5+4imjBCJ8769kT9EDp8g6wro+eRPkvobX59d4gRCJAPEGXLH1dYA/u
	nNyWEG2IuF2EkUi6UKSjSfJtD+/ggsI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AECE94389D;
	Fri,  6 Nov 2026 02:13:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 790111F0089F;
	Fri,  6 Nov 2026 02:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793931231;
	bh=SwgrBjqkdHVN89k2r7i2yZAHCG31Diqb92PenA1gCr8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=m3Em9F4PE9u33zUl2y6LstthDzhfyq4KiXR40nCfdoOgLbNJNF4jB/G4o35jsjeBd
	 Bu32m130jQCns+cycWPMsKi7uBYNzQibEz6nuQw5Jar9DAEVlYxBIc7uoxf0ZlC13S
	 zr7eWzKfM89ubx2jRQ2vMlCZNFZPnRvWGJ3xmXP//BA3yVW3HOUJobBxm6x4olJ/J3
	 Ozb9428qhMeZOhSbxEnFaVhM4m9je+vTe89kaeLXeoEGunJy+1wXuFIgQpPTBmVzko
	 ajpMRaFFDXnoEfOK+n3ExMWm0SO7U606rnluafcz/GcoQ7OdTOJN1xiSvdkxU4BWRU
	 y6P4hTT++7Lnw==
Message-ID: <bd783541-9ba8-46b9-b08b-0bd9d9ea6df8@kernel.org>
Date: Thu, 5 Nov 2026 18:13:49 -0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 13/13] security: convert VMA flag tests to use vma_flags_t
To: Paul Moore <paul@paul-moore.com>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Rik van Riel <riel@surriel.com>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
 Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>,
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>, Pedro Falcato <pfalcato@suse.de>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Leon Romanovsky <leon@kernel.org>,
 SJ Park <sj@kernel.org>, Rakie Kim <rakie.kim@sk.com>,
 David Rientjes <rientjes@google.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Peter Zijlstra
 <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, James Clark
 <james.clark@linaro.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Oleg Nesterov <oleg@redhat.com>, John Johansen
 <john.johansen@canonical.com>, Georgia Garcia
 <georgia.garcia@canonical.com>, James Morris <jmorris@namei.org>,
 "Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>,
 Roberto Sassu <roberto.sassu@huawei.com>,
 Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
 Eric Snowberg <eric.snowberg@oracle.com>,
 Stephen Smalley <stephen.smalley.work@gmail.com>,
 =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 kvm@vger.kernel.org, damon@lists.linux.dev,
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org,
 linux-integrity@vger.kernel.org, selinux@vger.kernel.org
References: <20261105-late-2026-vma-flags-v1-0-0d3cd15ab75f@kernel.org>
 <20261105-late-2026-vma-flags-v1-13-0d3cd15ab75f@kernel.org>
 <CAHC9VhSR=9YNhBxeFBcTR8wgG2yDP1fW590QKjzuc4Kq9ohaiQ@mail.gmail.com>
 <CAHC9VhRDVz4M-m_4UZZDKMgs4uc+j-+-jwYEdBDfSD0rtd-1Og@mail.gmail.com>
Content-Language: en-US
From: Fan Wu <wufan@kernel.org>
In-Reply-To: <CAHC9VhRDVz4M-m_4UZZDKMgs4uc+j-+-jwYEdBDfSD0rtd-1Og@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8E3E3140007
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: 7kfrnsgnkjgf5uz3h5j4thgnkku11kus
X-HE-Tag: 1793931232-770161
X-HE-Meta: U2FsdGVkX1+MNCWKe8rXdLwUZGQiK+ox8ATGeJVpboJD+gUet9XnMUGz8nV+rMnoi44gyVGRZEknsjuEBubnPN59N3FV4xeUNYjQBXOwG/n8ASv4OXfwQif0Mo0eN50MkQKcGbkHTIXBCuK/5Ovwk4Dzlt5qUcPAN+FCalYIkKETskw93JVgqGSeUzuX5GPARljxVSIaS02xehETF9NmkWy2+SHjDHioXLLnAYpQdnKIF9RVXZ+92KDy8xjvCpLICtOojiYIhg1RJ8BBNShqd1yIO5QGTB2DTON2dtHK+zSw5NyQOqwRgfn3hTVQm18yI7zYHu2oxNNd4J4cFX0Uw6OAi7xtx7e03Hh4iOlU05KfeoPl9+AXtfm429TWZq104huK1Qgr8i5hQtrWzIgMI8v5QCyS0vEcXv60zCLe21Jz/MBTsk7dpq52V+l6ClonEkEVXVtm76ORqEMoqewE7gVAn6PbDhAJLwcdMK9gI33z5FiDQ6X+RWzGYxGsEwzC8MAEfXIiKzjV9vvBzJTwxL4YEzX4e4mr1u/oKQQKDtJmrwrcgwvLTH+kpvPagk7NVPujvy3GdTvYf+pY2xSIT4ORk0vD9c/087KE7y9jNLIP3itIEh3soHC7nlXGMoJbdT2MrzD4rKErqYClQ8JXG3QdZZ5IKKoHn+wZV7JGbOwQP7QFFNHpxaXXHHwtlCVJsdPppCpq6QCTR3exxpjzOte4YAPnG2hWEe9LoShgva/R/ePG3elp/RpUufxsg7KwfzF8pXa1HffqJVRg52a2xw2OtKZYktkReaOd9UcmeGdeIJRm0mQFt9f9u/F2O9vrJk3rM9+5blThU0kS3Yf+Ahi/o0jJroSiqfL3jJRHhreY5CJbrF7OKJMOywRaHqaCcOELifJMpA4TZRk4k8DkRk8sb0KR9GW21gGxtcdQ5239F83ECtXsgCG3tl9tArpDXio2MyNUyZpZmFbr0pT
 3MDldCRt
 U/X4PPI6zKjbXmaRQ5Fz6iBzJEAQKmwNBI2AhbtMraMx2zGTai1oZQDA3uIVoTJVzOCXQS+bd6wzapdUB+YuipomqFsPhGzfjjvJ/b7a3Gbmn3DPMmO0S5x9KbnEfE2U/C07uORBm6KMHIO0msanbgUsEWeEW2NVcgzIrS37n5JJrnLFek6aZ8u8qHVZTuhaCwJHMYFnrvEI2L4xvPdWPmAcw2chA8lxWYi1SOWN9LnCzR0z3eqlEIEODRpXGUhnGSTZYeXfcYrKV5sGPzz7w4j4cbN1siyvEyVp88LgCAe09fjTLs6DZ0vuR+L8r9E5uRdbRZ3gJ1wGpCCXj3Bg6cZV/gBpHqVuJpDjh6lPPahTkQlcKz73Yd3/q/7nW8z9BpCzcKyRa37w+AF9MkZy4K3yNTOOjUUy1b3YV9eAAEAkKawneKaLjhTfn3mOMSCgDpeAf+3E7kNnMeH7jrayGcRoizkzuK3EsBl1TzlyVP3uoh5o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/5/2026 5:22 PM, Paul Moore wrote:
> On Thu, Nov 5, 2026 at 6:17 PM Paul Moore <paul@paul-moore.com> wrote:
>> On Thu, Nov 5, 2026 at 4:35 PM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
>> >
>> > Replace use of the legacy vm_flags_t flags with vma_flags_t values in the
>> > mmap and mprotect LSM hooks of SELinux, AppArmor, IMA and IPE.
>> >
>> > No functional change intended.
>> >
>> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>> > ---
>> >  security/apparmor/lsm.c           |  2 +-
>> >  security/integrity/ima/ima_main.c |  2 +-
>> >  security/ipe/hooks.c              |  2 +-
>> >  security/selinux/hooks.c          | 14 +++++++-------
>> >  4 files changed, 10 insertions(+), 10 deletions(-)
>>
>> Similar to the other patchset you just posted, is there any reason why
>> individual subsystem maintainers can't pick these patches up, or is
>> there some reason I'm missing and they need to go through a single
>> tree?
>>
>> If they can go through multiple trees, can you split this patch up?
>> AppArmor, Integrity/IMA, IPE, and SELinux are all maintained by
>> different groups/people.
> 
> Since there seems to be a desire to bypass normal procedure in favor
> of speed (surely that will never backfire), the SELinux changes look
> fine to me, but please do wait to hear from the AppArmor, IMA, and IPE
> maintainers before merging this patch.
> 
> Acked-by: Paul Moore <paul@paul-moore.com>
> 

For the IPE part:

Acked-by: Fan Wu <wufan@kernel.org>

