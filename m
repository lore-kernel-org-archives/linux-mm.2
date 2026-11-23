Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C6FA606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 09:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oWRODS8D
Received: by kanga.kvack.org (Postfix)
	id EDD146B05B8; Mon, 23 Nov 2026 04:42:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB4C26B05BE; Mon, 23 Nov 2026 04:42:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCBAD6B05C0; Mon, 23 Nov 2026 04:42:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AA4906B05B8
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:42:50 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1958040814
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:42:50 +0000 (UTC)
X-FDA: 85465894500.21.F1E9FA2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 70E09C0008
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:42:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oWRODS8D;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795426968;
	b=c8TjRI+zeFvcnCSSczBFZf8s3Uqmk2dM9ocOF+WJ/CkXKlTWTt/NCc9LeDFSQXovAZDVVf
	niwRMfL4HZ1Np5GSNScTYpc0GXRkDL2WRs0yCpbS3w59Ck/HfpTrki5jNP8OmCP8UyOgnT
	l7J9oBXdHjJs0w/p8K+0ZGFhyOoG7n8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795426968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ou9HbEx7ssMVBMaWAZro4CSQQpcKzmh3Oi4G3bVclIU=;
	b=BSZ1sdiESeUI1rk5yKEtjDG3P32bnJHx2Q+wxyhATySZIsuAXvuv6w9iR4XokMByZyNDzP
	8Ysats7yJMix7K3J1HPz+1KoGnpyYamg6ediwykvAIwR7jjehmtPoLBrTbw37nyiSHtKoc
	eNZoQ3kHeu6cC8elxt/R3S3XgZF0tDk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oWRODS8D;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9E7314450A;
	Mon, 23 Nov 2026 09:42:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90DF71F000CA;
	Mon, 23 Nov 2026 09:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795426967;
	bh=ou9HbEx7ssMVBMaWAZro4CSQQpcKzmh3Oi4G3bVclIU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oWRODS8DLeadYEUXqdhuAOcb/384tRTJG4ZbW51LNJ3reUaZCz46vEGx6mPoB3eEr
	 tGcw3pzDrf/vZ8JlXoP+lq8eh5rMF+5Y1nz7meZCVVBckNCr3C42T/B/QD+KLdyASJ
	 DMJZDKkgucekWw6EvsyEG6tIxK5zkscmCxjYCRU6BATu5Xk1CxrGZe4+1LElfeMRGx
	 /wTvsef5APv/J47LDC8hRkujWw3UVBcCnF40yWBHuT0HPkIiPB94S8837sTBC4Dizp
	 XTXgzJlFbbu+QrtDKzwFvI8gvSKKTjRJ7mzEKnNmsb9zFlrpkdMF8Toe/fRGnQWb6y
	 YBUAf0K4Gi9MA==
Date: Mon, 23 Nov 2026 10:42:38 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Li Zhe <lizhe.67@bytedance.com>, Andrew Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	James Houghton <jthoughton@google.com>,
	Lance Yang <lance.yang@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 11/11] mm/mm_init: move pageblock migratetype init to
 memmap helpers
Message-ID: <awQKjoEei56eyCcw@localhost.localdomain>
References: <20261120100856.16929-1-songmuchun@bytedance.com>
 <20261120100856.16929-12-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120100856.16929-12-songmuchun@bytedance.com>
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 70E09C0008
X-Stat-Signature: gfefkwknrjefimpkdoy7tdwdt8deoqdf
X-HE-Tag: 1795426968-52867
X-HE-Meta: U2FsdGVkX1/bacj0j9l2OIF0nakgfEojNCbB/WORVc4liFkRBoqQHmCDsA4m9QYpUq9zjdvjjVeC/UAkxiS7OnyVdkabX2QBHjyMansDy2IsF45BvF8EJCxqisj/hObAXkIzbFV8nxtBMAH9c23yh3Kr0fBvZkROqdW6n9ds0C/XwreWQDw5O6nePmMiPFexAwDiYzkzMrpRmE1dhtNGcv0JSiZQZRilJPBhiy3UbvXFWBNEmFsDgx85TWLsyQrhtqzH7fw+0SA60douOhr3yb1mohlqCQ+SYyL9vNhy0/Spsk9LD+aRTr76gbtwxRSK4QdOzjwLwAmZwxElTlVKMMO10XmOpA29LNZD7/US0i0ZKdje44ElF9QaMnl7qqytPd2Gd0luhVwmJFkJPsnmcD2CtK/5oDsf9FMDD98nhjztFMIgRG2TDlhUSmgNt+MujeeK/OgWRr2o0Qyi7CoKF2tMdLZ6mdsz9gLxaEgwKBw+rgY8rtNOT9LElV3yhOyGHDpaAOPzkBVMY+naKGtSD2eZcnubkod4SBX/wNahe6+D+xqSH0gw2RtsVUmEbw7j7TuqBTNdCL62aPLZl59Q6P//U7ExR57Ylp5rHXNH38KdS243K+nnCwDuzhpZMYWwWYWrMSBiOWBhsSLf8oW9sSO8eEXpFt/0F1mE81PP7HTab0W2JgVr2t0FCphlbIaYlHZrPAaWMxFLn9BvSNWQS0cWyBEgAZOAwE/wNqeLeQ858WnadshrZaTAEBxjaOBDh16sSUKIeNB5mhlek+BnEP+UxDIGvSoaMVMX6wkkK0qB0PCWCRzkaBBgtYlbcQmAZL92yV7118ebjGdGtaDW6a9jeVI6TIhkIrrbXEd8O9FS/9NdeIvm8t9iGGOYUGN4QWwwYrfo+FYUAr4hIs+PX+zRYQflLKLi2ZpMrJT4gzxGx36FI0uTFa2RUHS/DaS5u712btsL4K7gKaRXE+R
 qkWlWwuI
 2fe06JD4ObDW0JZqHFnMMuuFZTYpbVBqGH/bCUrVtqNagpJP+650ypF5gK3lPHQc94ZgtyGX6yrKZCuuTgS2o00yuJjZ6EW+l3qaj2d9DsD0O/Jq0hniXJ2ccVDdMGioMYANAhc+klKCB9sekvYAYuGD/oOFix82PS8ESuafwcBZbLfilxz4dJFectumi6rRN2JntDJJFTOmUlTSV6tlJNBqLTa+GJC4oxkgHgNu1hwpPJ75eM+SNuzy31zsq57tJDK99Xsd6LV8lvpFpAxPwO9lNhYUcKIFEAZF8xhYCib/YT3QaStknU9d8hVOowu6zHdbrrdMgTnFVtIJ65mIoYkUoCalDHYxg+2KEioQ0BlPIpVhRn/3a0+vxcfV/sGTh0B00ZspSBauGbckgKa59qfYJrZVmry1FAS8IyPEwh7YM/yeky8ZPpy0N93h3yCa2mumL02T8v9s4H7JZsueEU8Efxh4W7TSZQ5uYrBG30ZaZ9MGcoAZrAtG4pYoh4nWK1l3Y9unJenSHDWM7alJ3nUYlhjkJQ4LghDHK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 06:08:56PM +0800, Muchun Song wrote:
> ZONE_DEVICE memmap initialization already initializes pageblock
> migratetype after all struct pages have been initialized, while hugetlb
> bootmem folios have their own duplicate bootmem-specific initialization.
> 
> Move the MIGRATE_MOVABLE pageblock initialization into the frozen memmap
> initialization helpers instead, so the ZONE_DEVICE and hugetlb bootmem
> paths can share the same initialization.
> 
> The old hugetlb_bootmem_init_migratetype() skipped CMA folios via
> folio_test_hugetlb_cma(), but the shared helper always initializes
> pageblocks as MIGRATE_MOVABLE. This is safe because cma_activate_area()
> later overrides the migratetype for CMA pageblocks.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>



-- 
Oscar Salvador
SUSE Labs

