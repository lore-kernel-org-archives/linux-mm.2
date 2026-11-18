Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26629606A32C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 09:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GpcaUxFb
Received: by kanga.kvack.org (Postfix)
	id 463C06B05B3; Wed, 18 Nov 2026 04:40:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43B486B05B4; Wed, 18 Nov 2026 04:40:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3515A6B05B6; Wed, 18 Nov 2026 04:40:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 104326B05B3
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:40:00 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A31621C3F82
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:39:59 +0000 (UTC)
X-FDA: 85447743318.14.3ED7159
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id D3E7B80006
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:39:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GpcaUxFb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794994797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kQg3KGb7GYq22ZHkNPQqW4NEqCB8YAgXiGER+D6cdok=;
	b=d5uQ7/utcL4lrf0M40ht+CDHJ+aC4FoDQrw6yBs0ZHSM4gI4E9g1bdy65VeZDmfKKArrJs
	HwEGvqCT7vkFY8DlbO4rqim9FmjwCMB9F4CRUOWCrS5zGk5GMPR8CdMFft6I64jNnr3fyi
	kMifr1t+3CmeQwPU07pYMl4OzkGFM18=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GpcaUxFb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794994797;
	b=ofk6mjLU9qclvU/A4r1P68Qhcekj3pU6ZSh4PrWFzyjjCbWgEKkTQYYGuvU5OuesjAZJan
	mLwNHG37uhbgwMaZmcjgFRXmdAg8Du/bGFls+J5I99n+EGpXRhWDefX4cgAqx4D6+rAYVJ
	hE8qIFyzFFAS1nlnJIiyor7wLpr1bis=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 64CB6609CE;
	Wed, 18 Nov 2026 09:39:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 905DC1F000C4;
	Wed, 18 Nov 2026 09:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794994797;
	bh=kQg3KGb7GYq22ZHkNPQqW4NEqCB8YAgXiGER+D6cdok=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GpcaUxFbHR9dMI5Bvkr3hUHr3/rN1SQXygpuxyMfV/mzR4t+3Zj5WZ3bmdmS9jxH3
	 QUZ/LG78QFpmxhtVN1td0C+3zH50ucLvT7f9SOrIU+Y7SR/teEKcIxEfU8Hkq3MV4T
	 oAkowGalKjtwqxDV9lm3aQDQwKH3OpgElmV4CNbcSfVDeNWiCKbAyb4AirlB/EWuJT
	 ZD4MxMEnRBgL6K/oJpbiy266LNRcpLyfLMUyh3GNAj00rHpgauWG+aiKlCbvROKrje
	 WmS4UBO6YpEIsx94/P7QkA7YpGjUc7m0TLyH9+Nv8xTHKr+942fOdRXQnyN2b8chxb
	 jiRWHQnNPS/JA==
Message-ID: <de532d85-c6f6-425b-86c5-08094cd28a29@kernel.org>
Date: Wed, 18 Nov 2026 10:39:42 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/9] mm/migrate: warn on a writable migration entry
 with the uffd bit set
To: Tal Zussman <tz2294@columbia.edu>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Peter Xu <peterx@redhat.com>, James Houghton <jthoughton@google.com>,
 Andrea Arcangeli <aarcange@redhat.com>,
 Suren Baghdasaryan <surenb@google.com>, Balbir Singh <balbirs@nvidia.com>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Michal Hocko <mhocko@suse.com>,
 =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
 Andrei Vagin <avagin@gmail.com>, Muhammad Usama Anjum <usama.anjum@arm.com>,
 Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 =?UTF-8?Q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20261117-uffd-state-fixes-v3-0-b617009d1a4a@columbia.edu>
 <20261117-uffd-state-fixes-v3-4-b617009d1a4a@columbia.edu>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261117-uffd-state-fixes-v3-4-b617009d1a4a@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: yng4z7xp1fh53aqgxo6p7e8cq7xgwcqd
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D3E7B80006
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794994797-735649
X-HE-Meta: U2FsdGVkX18VKMCnuhlvlnoxjvtwfoLIRv//wq7TZf6NgtUNbJ2yo+8XJBh5nEj0KKfm9JRTrXVrXv8XM/risudqwVrueUiUMExJn/KxZPFwDnEa8v76hk4eDdwWFvIhEX4nhp2tPaqC1VHDA2YecqhKFfuv69PR2DhSh+nkkDfnrpsEvwmk8co+PiKscTfLOkK9o/cXw9qXykkxorBHVIomrbnrBsa/wG8dGSpupv7hIsuzxmUcj1+WNsHbKF9KDvQt7PkiDhrUEnznSQRS96NEDGo0KzJybsPXGAcIvFoWOZPxSBiGgxtKCVke5+HT7QseHAlGogQngQbkfUw/LLpzHfQB3wh7SgewBx+ClVSB/GIOwW6vOn5d/BNozVmMGil1wGcKQXOWuPeymBJpZ/sJc49iqGxg7lk7H5Q5YuAo5kaV8Qkf49HnHzaYGDJe7YDh8N0ey5dMT4MWTKcBm9otFLjGpXld2o5LCxYe+SyzTq+3cF5amUlAp+WrpISVRTD/s0cjBUUBWUIMTzjo9DCBC90fzJOJyYzqfi6uAlPNzbcmDxIaK07aM+Z5s0d3GwQDWCfD2wSU4Cydv7LvpvPTeMUSeJFdrjNog4M6+MpY3byKhu5XKfZ2BJorgCjMVOr+f8zW0PeRWY1t1NyDHf6cKWo+Rv29gVsTeBFF3VcrcrUCBWs0tLTsgi/mpySK9fZG9j7R2sO9UrKZIQ7pmkw1OcU8I/sY9pYPTiNMySXLumPy9wOKNRurh4zj/rFuIEKtSFDV5WAM6C8Mcu2wYvavAr9kD0IpXXv9jHE9Nbc0hq+oq9lw3rvl73EdgRQVghZKwR3KSsTgR+XHXsRDC1lysj/xDbhVXPbo13t6ocOroV2hdin1E72XAtaMr1wx6wiDsFiEJ5YWrsHkEm5C4IINzxC+38SyaBQ6JN4/OGD6F9iakkp23qq8A7rEA/W+c6b97aUM/i4huO1NgSj
 HskRRTmY
 qLiBGvZjv9JfJ//ISTNvfAodQYcXGqfZyDDcOJgJ4j533oBZJi1y8hUzU1RwhxOxNxiI81orr/rSm/GhMhQmNZjnQFagzkP/tTuSuCg1/qiBHg0Lmz1k+7Ywc/81j8v/HMSF5j10WP2R8In3sZ1QeIcV6KK1D6gRS5Q+5NgRmj530k4VlOw08y/kPucCt3gMTy/mzH0K7uAbGK1nrc+sfiIjekLRAhMk0ejEUtTFkWN7RYZA4iM1Vqpz6Q7dCsrGcbUzjIMGhBe3T1Jhb8t/MMQ72F8n1UXuc2vKGVMgjML1tvARRO24nmVL18Chd2gT++Xlwt+kfoTKZuz6h3y9sFaPJ23eL5ObtOLtYBWWUs9M4PHv4n33IPeVvrcEF1xd1TF4m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/18/26 05:28, Tal Zussman wrote:
> A writable migration entry must not have the uffd bit set. Every path
> that sets the bit on a migration entry makes the entry read-only first.
> PAGEMAP_SCAN was the one path that did not, and it now does as well.
> 
> remove_migration_pte() restores such an entry writable and drops the
> uffd bit, while remove_migration_pmd() sets the bit and write-protects
> the PMD.
> 
> Warn in both paths on a writable entry with the uffd bit set. Also make
> the PMD path only set the uffd bit for a read-only entry, like the PTE
> path, so that the two behave the same, as this should never happen.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

