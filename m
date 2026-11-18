Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2086606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 15:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WhY5kEms
Received: by kanga.kvack.org (Postfix)
	id D79B56B05B3; Wed, 18 Nov 2026 10:19:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D51AC6B05B6; Wed, 18 Nov 2026 10:19:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6A516B05BD; Wed, 18 Nov 2026 10:19:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A278A6B05B3
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:19:51 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 483C316011B
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:19:51 +0000 (UTC)
X-FDA: 85448599782.02.900F0F6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 923F91A0004
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:19:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WhY5kEms;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795015189;
	b=MaaZi5CzhGCaA1rP0fOeIhLb67vw8YmjXAD+7YEbgyfl+Lzc9jVfj0sHrNCYK4WZwu1skC
	LvjGBwo0GqI3wjlgXBzff849z/W6j+5hMBaaFzm9xq8WfAgN4SW376ZqyjUSW+LHPOnsai
	CV8RJ/6j4kLv4O29n4LtKB+VxN6WCoM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WhY5kEms;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795015189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LeU/DxXcV0ry5yYe0LgqD+dUS+pwnrp+dk5INqwKWBw=;
	b=HcSwg85jw7u+EvE9J9gxzrwMOvVRuY2Cc10hs6M4GWNKIT57mZpUaz1ES3OznAT2boJZdQ
	uo4dhJUQDo23k8efMRqiHVU8Ofd83QESwitlQSmLWhLcN0w8FbMe65nhLFfiH51kORzUQp
	MEaK8dqX2ewZ7Xc2vwHu+ti0stE+7qM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1489962353;
	Wed, 18 Nov 2026 15:19:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2AF61F000C4;
	Wed, 18 Nov 2026 15:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795015188;
	bh=LeU/DxXcV0ry5yYe0LgqD+dUS+pwnrp+dk5INqwKWBw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=WhY5kEmsWtbqCPSBFQ2nQaxXboUG96EQPOcrbrxf3sO4BB8Tm19kr7KE+iG4TB6T7
	 PIfvCftf6yhI0z/gSSuVSWelQ+KcojCemjhXmawQHN4M8lm9G59rJWiePg41ZCfjrN
	 PTiXDg0szsr0RvvEzTrfcZRDRdJB+saYvIzHKu+1KiMaphpaZRxL/B8C17nK4lXIND
	 5W5iL5YyG94DwOrXeT6A6n1Sje0lSSyR5xqPs+kpFEYkwTWmDT12f9kXD3kAkufpQI
	 6gnmw6UhyvmYKom5DY7ECNpupaFbP0vtsHy/hz2LwtgAFS8e/x4LMVKaqoN8FbGJ3G
	 dYN3/OHJyRueA==
From: David Hildenbrand <david@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>, 
 James Houghton <jthoughton@google.com>, 
 Andrea Arcangeli <aarcange@redhat.com>, 
 Suren Baghdasaryan <surenb@google.com>, Balbir Singh <balbirs@nvidia.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>, 
 Michal Hocko <mhocko@suse.com>, 
 =?utf-8?q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>, 
 Andrei Vagin <avagin@gmail.com>, Muhammad Usama Anjum <usama.anjum@arm.com>, 
 Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, 
 =?utf-8?q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>, 
 Tal Zussman <tz2294@columbia.edu>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, stable@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, 
 =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>, 
 Felix Kuehling <Felix.Kuehling@amd.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Leon Romanovsky <leon@kernel.org>, dri-devel@lists.freedesktop.org, 
 intel-xe@lists.freedesktop.org, nouveau@lists.freedesktop.org, 
 amd-gfx@lists.freedesktop.org
In-Reply-To: <20261117-uffd-state-fixes-v3-0-b617009d1a4a@columbia.edu>
References: <20261117-uffd-state-fixes-v3-0-b617009d1a4a@columbia.edu>
Subject: Re: (subset) [PATCH v3 0/9] userfaultfd: assorted fixes (part 1)
Message-Id: <179501517242.13206.4721668826806594112.b4-ty@b4>
Date: Wed, 18 Nov 2026 16:19:32 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspam-User: 
X-Rspamd-Queue-Id: 923F91A0004
X-Stat-Signature: rywthh4wqqzn8z198do9766kej58x6z7
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795015189-466788
X-HE-Meta: U2FsdGVkX1/WSRfdVzdzd8nose1Fgx1o8dj+TxL+MbDprTSgB1H10PokS4ytGhabtl38F5Ka1tnqs7tCQfyztOPsWrD86gBTt9KFDy4gZtv5xUwcq8g7xB8NHacpQm/bEnsWsMubSzl816GGy3UfofIr3JZRabwN9m69DHmJqApauIziGOaanyQFFzSh5/miTpKMI9QXgUkT8CXLRsHpf4bvryPO5zhOIdbdiIsArH4I7pQxelyxREcGHmHSgBEAArQcRhsoEWThjqbzfqx5lC7DTIhtCfeSyu/aaECWJmf4jjUbmtb42sI+ptRp8w/XmXMW2abanX5ENL9eMsiqHDgDH7OX1g/lYMna6Xg5i4JVI3zb2W9oHXDm2ZV5oJ+4SetpB7Qcbb8ioQdhoSHR3L4c349XOtkOchsmFTHAZJK9HHNJ9Fijk0CAlJ4InClvn+evvM5TuLbK5CUxYBBcsANlTHdX2Qzk6RKbQE8AshdC2PFpsIp8CofqS5EH9vKXdXkpD/4vnERWoGMSBHV0ERjDaOm08MrKWCuqZjpxIfJfCUM9UHDh/9wnxJXzMrgpebIwI9QSMYc8EYw2dWxbYuNvRWtvqZ3SheaJMwFM7UJsc3VE/a38VWE10JJeaxrbjzNcN2vGUFU1k36Voc0LEiDve3JRGrAS+a9HC0+u6OUunl1mBflpIUtPvf1X4EwiPr5btLEqRpnW/dH1NLqlD+Btw6Bqcv7esLzebd2wqbzKHC/u6U3pbXvzQ3p9sMAJE9fMZZgGuRKHUsPhx4B2yS/mh0bK9F2P3VdCtOBkXQVcQzsYL4eQiO5xK2hAeklc+wVa3jusW0Adxaxtv55AxcFoAtduo/Tkh0nwk1ZQ3XP93YxNvF+QSJL5EeorXeTICgTw6Q/5lAsQQyOpjZ+RKPi+rnEOiuEQKY3XdgCdkFykqh7/zkWtv+3GRrdpNCZ1EEH1S/kH43gwElEcEKn
 Qpn0RwPp
 V9CXhFXPheN214RUUkQAknEk0NsLXMzDMWp3TZmG4cNSRvLqDfZAOhV/ogZRuL/pEGtwMrRM1sNBnxFzzekvhQLfh6+n/hp9QbLHCdExJ9ZP62cJcPwvGBOCBaZ5sLGH3jWFIbaGBKiHMDkwvGc9NNjGHHnDPJ+LGC8gH1Ywz1I5A7T2q9tAwTr3sZsi+iXopUAO+vlVqa5YnkGbL5Hqi66COXBVaJlgWC+y3a8NrhwigqCrebj5shpXLriTakCwgsL3Riq8BeTq7U2RE2kKJt0Y7hHpPVUOZAeSHT6xH981AnUSW+gxQ0jiOrdODJLN6/Z5H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 17 Nov 2026 23:28:40 -0500, Tal Zussman wrote:
> This is a first batch of userfaultfd fixes, with more to come.
> 
> These were found by a mix of regular old LLM review and by having an LLM
> write a TLA+ model of uffd interactions with PTE bits and other state
> and seeing what issues fell out.
> 
> Most of these fix places where mm code loses uffd-wp or RWP protection
> while moving or migrating an entry. Userspace then either misses writes
> and accesses, or gets pages reported that nobody touched.
> There is also a hang in UFFDIO_MOVE, and UFFDIO_ZEROPAGE modifying a
> file through a private mapping.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: migrate-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[4/9] mm/migrate: warn on a writable migration entry with the uffd bit set
      https://git.kernel.org/mm/core/c/ec53fccd

-- 
Cheers,

David


