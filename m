Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF094606AB41
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 15:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=fExQ5/g4;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=9MPJ7/Rj;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=fExQ5/g4;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=9MPJ7/Rj
Received: by kanga.kvack.org (Postfix)
	id 88B8A6B07F9; Tue, 27 Oct 2026 11:47:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 813786B07FB; Tue, 27 Oct 2026 11:47:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 666C76B07FC; Tue, 27 Oct 2026 11:47:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2EB3D6B07F9
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:47:45 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BE26480A34
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:47:44 +0000 (UTC)
X-FDA: 85368836448.05.D9E3FED
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf29.hostedemail.com (Postfix) with ESMTP id A3379120005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:47:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="fExQ5/g4";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="9MPJ7/Rj";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="fExQ5/g4";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="9MPJ7/Rj";
	spf=pass (imf29.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793116062;
	b=1+7yCjgu4kdP5lZi3SlzEy3GdnDFxizZSPdlwOsWjwN/M47uP2f7glRoAedZ3/RlMxzlbj
	T5jEmqBCwJcIHPzVGAnGiPT83eHBvjQG9ICNS6138+faBgnO73rTQE8/Uhr+lxCLGArcCi
	bRASgPq3T/evZLZd5hMtqB9QDk+j6fs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="fExQ5/g4";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="9MPJ7/Rj";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="fExQ5/g4";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="9MPJ7/Rj";
	spf=pass (imf29.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793116062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Gugmp3BIEkOqv8FF7ZJdq+ktVSv07Or0XQY3RY45wY=;
	b=gIlV8Xf1rUErPNQVsh5cjMRLqWIguZU+6O5ZB+iQzWKrAzbodzpindtrrsYPiBqkEx/xTA
	8VGF1Au3sJ1PufJQaw+a3yuc9jmc+NFumzjehAOSnkWGVtX0GxJdtRb5h6miPmHS/iHY/C
	XL63o5VvH7bL2rUFRlKaEb/GQbBBb/4=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3896F1F454;
	Tue, 27 Oct 2026 15:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793116061; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+Gugmp3BIEkOqv8FF7ZJdq+ktVSv07Or0XQY3RY45wY=;
	b=fExQ5/g4l4jzRnWsMtKXdPLgHby/4FctEIiTmJi06ZdU6sU2b33bbqoWDiz8ZPql4JOeBz
	HX0hfXJplz1L0jtdbp3HcNN5mDaz4NIMkvgQ4ZRXl1E5tbkpzctV5uuT6rg1//TDXkZAyR
	q0kBPoDUw0sL0AhS0wvk513xzDdfbQM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793116061;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+Gugmp3BIEkOqv8FF7ZJdq+ktVSv07Or0XQY3RY45wY=;
	b=9MPJ7/RjJUpKrDqXUMZ3nzgd6sY1UlkFRfN/lmEQwJgJbwyqz6GArEZBt7oGudqXW8R3Xt
	BfVafROpvUosVhBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793116061; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+Gugmp3BIEkOqv8FF7ZJdq+ktVSv07Or0XQY3RY45wY=;
	b=fExQ5/g4l4jzRnWsMtKXdPLgHby/4FctEIiTmJi06ZdU6sU2b33bbqoWDiz8ZPql4JOeBz
	HX0hfXJplz1L0jtdbp3HcNN5mDaz4NIMkvgQ4ZRXl1E5tbkpzctV5uuT6rg1//TDXkZAyR
	q0kBPoDUw0sL0AhS0wvk513xzDdfbQM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793116061;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+Gugmp3BIEkOqv8FF7ZJdq+ktVSv07Or0XQY3RY45wY=;
	b=9MPJ7/RjJUpKrDqXUMZ3nzgd6sY1UlkFRfN/lmEQwJgJbwyqz6GArEZBt7oGudqXW8R3Xt
	BfVafROpvUosVhBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5F08213319;
	Tue, 27 Oct 2026 15:47:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +kHeCpnH4GpVXAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 27 Oct 2026 15:47:37 +0000
Date: Tue, 27 Oct 2026 15:47:35 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, Hugh Dickins <hughd@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Lance Yang <lance.yang@linux.dev>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, Minchan Kim <minchan@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Gregory Price <gourry@gourry.net>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH 06/46] mm/filemap: read mapping->a_ops->free_folio under
 i_lock
Message-ID: <auDG-5bYh2tSQem8@pedro-suse.lan>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-6-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-fixes_core-v1-6-6f74bec9a5bb@kernel.org>
X-Rspamd-Action: no action
X-Spam-Score: -12.01
X-Spam-Level: 
X-Stat-Signature: gc8icphr67oeg7c3gww9pn6kognbtc7g
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A3379120005
X-Rspam-User: 
X-HE-Tag: 1793116062-620529
X-HE-Meta: U2FsdGVkX1+6NeItvCZlWViNM4Fi7MJg+pIm9niw0UmhUusCKvD61MPrkTtERdpD1g8mrfqbfuaerDtVZZ7oVeVa98StZ9iGOY5LARH5+am7dc1mXbJeoFHW5qVesmKQvQgmAkDrmNzuHzfC9yj6KCdFHp378cGU7i0Ot9l2cP+5VAqoKP9VKS+FU3lwphecxRnQFOwuAEYhtYjzhGUs5XWRv0/LQcc+JpiYITOo0GtfmIRYVE+VvCTb5kX3uQRJZmImKdilTY0K7RXWl+cAAyeBsxjeHMKPLISX9kxITs39jsO7OoPaDV6QNNZdC4Qaq9K55fFUl/oFlS9lic+93utFUocX1JTMjJt/opvRrp+jfBJDzf7OYKJ1bxUoLezURc388lo0EGOnV6axaVeJhf8sts9dEmq1IzQ0MX0uJUruTrAlx/vAj7MhacjHJYYwBEwd7FWceTnHWle9rFlLuc+/UjXOUUQER1iVqDM1GYsqzIwH2hS8AZ8826vtF95HjRIzGFk4Ve9JRc9eIurbAIB3BfCc4riowFvllZVKdcCxQo57+xfpkaWRiGWWjlzBt3u4mHmP7By5ljLGs2KK/W5u5h2YKL8PELft3yubISsLXolRitUM9LQdTcUznGpeQZ5hMAFSeZvFLG4WyDU0thyRxoj4146v/el82DKnOwB9nfPq7cZaplST+WJnBE4/GeA87FBTkF+HkcXV5Zbi2+bZm/kRuY9w+1NGfAjW7u0rZRLMNvktmvPgkgha918bgkYLypgpGR+SisspfZq5hRawyJqZKZK3r8T+yJoujahtnJyIZOE4S8qYV9oLhWvwcf+lk/PfETUYtMF06JwdUVrZsWzNEjSUq4dYU+m8ZCyO42YwABuSFdVi8vHIgl6nVcBenCeUsn1pF75QA5z+HFPj9c+rSYeV6akuVU1eBHbKaZzuiUqUn+S1yRCBzI9iXU+frwVy84+8snHR0ek
 wQdhJIsk
 BQtOnBgo84PUX97dKBLjGTlr2nPZp1x6IEyqAGgNxriBgDiyZkQ9DckjZFN/lemgNcQMiMTgQjahIR1GKFtJ9c/ffBg+ruz+AM8e+lIp01mjeOy9hQ19An5Grngtz/u34pOg1cC4nAcfdNkH6IewVRpXOZ3xVVIKMX6V+DNdRhiM1WErpwoJ4qvAPgUZyDBWSldjSAwekgzK4Rzhh8HUrmw0KEzr8k6hsM9q1ixvNAgYvlrhjakJ8G629zJaTBSSlWysHrKFhrvCYz/ZrEt8A4cyp2AA3KwdmRH+UN5ush8OGvLBYC0SkHj5TC5F3F330gZZYr5IZU9DMAgUc7lvGQZlkCwJbNRyJPWtuEMi/OV0vptsRYzjTIQgpfqStwoG6g62RJN00Rqkg1Zbnu8jATACoqlUq5tYiumzSdTc3JNcz4MJL9U6WBgVE8pk6DDjkYIbe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:17:26AM +0100, David Hildenbrand (Arm) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> memory_failure() -> ... -> filemap_remove_folio() can read mapping->a_ops
> after the inode has been freed. Once the folio is deleted from the
> pagecache it no longer pins the mapping, so after i_lock is dropped
> e.g., a concurrent final iput() can evict and free the inode before
> filemap_free_folio() looks up mapping->a_ops->free_folio.

Ok, but after iput() then nothing also pins the filesystem, and thus the
module. So we can be calling into total garbage. So what gives?

You can't just take the pointer, you need to make sure the filesystem
is also still alive.

-- 
Pedro

