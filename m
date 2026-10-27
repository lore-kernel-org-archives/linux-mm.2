Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98E3B606A31D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 19:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mbBcKjaD
Received: by kanga.kvack.org (Postfix)
	id A1F276B08B5; Tue, 27 Oct 2026 15:22:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F7AB6B08B7; Tue, 27 Oct 2026 15:22:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E6746B08B8; Tue, 27 Oct 2026 15:22:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 651686B08B5
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:22:59 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D05DE80AC5
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:22:56 +0000 (UTC)
X-FDA: 85369378752.03.4AD480A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1B1AB40008
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:22:54 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mbBcKjaD;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793128975;
	b=aFSp9ib+BLlUDvCTMrx1zbxdSLaD8gY0budXo+rYkmJ0PcxjMORMfKxKLSmamz8Und4Y/E
	xjPPU1orpZExT6gd2ptWa0yBx0FWuGOhTYlHAIlynTlfor4bU9HNOBY9Zp4LkeyXs+M7uJ
	BmdLPf+LAQmJdrjfZ/GFA425P87E/5g=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mbBcKjaD;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793128975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CmHIg5Am5Rl4OyiVljbueHpe0qSwosHitoSBvm1s4Dg=;
	b=hwKXgYViNY3USdbap03JQSFzI+aJNKM54nJaru6lQZbanE+XAjOSizc21TOcL6g5FNqhPM
	4PzX6SxGfxF/xOzYJIruhTI024tWWDKqEC74p4EmF7/vdwNbMkF74KNYoolQKll11q0ab5
	bFcWR++/9GQmsd/I0udjT6RKS8RUrCg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 748D960534;
	Tue, 27 Oct 2026 19:22:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C501F01825;
	Tue, 27 Oct 2026 19:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793128974;
	bh=CmHIg5Am5Rl4OyiVljbueHpe0qSwosHitoSBvm1s4Dg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mbBcKjaDUzUToQwzCV+6Pgw0tzlFD93S9m1+KWfG1NxVpkyCRRNCeTQwiMNIOfzvn
	 Sepy4cP6buD5heeyq6OynLNzNTGdO00RkWDd0HqkGKmTptI8bihK23QBxhd/Wqlonf
	 HbWh4RvfN3us9Hc0aASVdF6DtQcbxkvLXWp3rkhuItiwQf8kK98x9/vIo3CCT3q+Ag
	 ZeBaYiMvwQBc7P/f1/3KXVozk+l9bV0Uk87EM9uSlMEaK/HEsSJ27Yr2GFx6cacDE/
	 C46o3eLzcUWhsQoYCuflTeg/cKr6z05wLtUyE8LSSSA1LnR+P/p7FBp/xOTeU8yg0W
	 8nFzhp8mMriYg==
Message-ID: <5875ffa2-6d8d-4b30-9998-ffbe290a44b2@kernel.org>
Date: Tue, 27 Oct 2026 20:19:33 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/46] mm/huge_memory: fix list corruption when
 deferred_split_scan() races with deferred_split_folio()
To: Mani Tofigh <mt4022@columbia.edu>, Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>,
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>,
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-cxl@vger.kernel.org, stable@vger.kernel.org,
 Josef Bacik <josef@toxicpanda.com>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-10-6f74bec9a5bb@kernel.org>
 <auCw2-_yjh1_RjiO@cmpxchg.org>
 <5d431bf7-8813-4e2c-a40d-b45d4ff39a5b@kernel.org>
 <208738b1-35df-458c-9955-e2e5318fd2c7@columbia.edu>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <208738b1-35df-458c-9955-e2e5318fd2c7@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1B1AB40008
X-Stat-Signature: sfuspjxdrja9hpxnkk15ukj161q1853c
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793128974-292410
X-HE-Meta: U2FsdGVkX19sOeyxWHy9iSLcm+oSw7snEdJ5Xk86SwP76k6LhMxCwXf7VJtW1GzARjhF3YosInFa7TlHplmyzQ8Nbz4IX3BbeLupRNHWtSzdpPGDtLZBmN+Am4TB+e9R8s+hL7o4oAUKOS/SVF0IiW2BQqLrc9DBSWCEHgYyIEHPVE+tKDD54lJNo0b+iUQMVry8RP3keRR5k8g+blRXyYf+QWeC/4YdXBXSWy5Nqj2EaZmDHuDSHlkh4xyujGAcrB4plMmdtg5PGR1KPBo33YENUP+7COnptGNgbQdja8XxOGwU0lfGKBz6DiuKfsrw+G5qZi7kFj+9UHQ8xQsYLzB/hSoiPYw7lnr2XpvCSAfyPxE1zVg88Wj4fTJOFflZ/7tnnlyzvAqWwoYlNscvIOOWyg6dqFFrr74tuJZaAUoNcplJHfQQD5ZfpE5AOMRaZjrWf2uL1CRZHAVHMwwQuQFVsBlwjBu5cszIx/MSGgklxTvIKHWPtQ/o0gj0E77jmnN1J1i2XhQi91x1jQM2+s9rXCSeVE5xmxGu+3oKW4jotnC9Lxtd3e/kIHilL/f9tk+awJ6kTXHA04FUcyebzL6EyblAH05V/haBkjNfRujFB4vT4wMqrjCtDmllD6rDLMxoLQ/jv8lKWH3LphKnaPYfslYXvzqlc0ZrNbF+NWo8XNsQhWyztFgzUnrZlIFqCErlHGuWpoA3hQo0nPgPgWdleAquifDBuDDxvmO5NXw1c402g+buR0BndqCqw0nUThNcKyf5ZhWmFdjf4ITklcVwSqWbenUZx4kWw3Bp4IeS4RhBLy4MF9TOqz2/ykn9Gs3jhwqiM8EMK9DiYRFI50qAcnRD1R3Fe5OXZMHDheCV8SmVKg+CJSTulHZBdyfx6ouez8Hjd+7auJ7PALCIBl4kXEpMWpST2jOl5yedBWqCy7/52VwxNkgVx9D0gmuEsD37h1TCiE+nrJsR0fr
 vxlequiG
 Hc+9pP/38l8Cbyz1idGrtyB8g5PeZFdl+T6uzjQErlaUpVftk9B14z84r8vTGvNP9gCoqkvaMpP5oM+JN99PCwzjdtSu6067Sy5bfpke3tbArGJyuH+TQxMnlSkyamQ4pYlpKhQYoARuYVCyHONhOZGF22OxYjW/s9qgJssgZOpTsW9lGKrDLtw7xbsH7/4H3km8HH+0/Pv4FQ/5cby3zRAhPSZsn4l41OC+5Zd1QQTZQjW8ayMU8cHJLOx4HhFojy/bpjRIGCT/ZOoWVf2gegoL7BylxiZ2lSuxPPc5RK+KeXsx2Vz8A6y885fqzNfJTcwpsK52B4DChTRvUrPQt4Jd/TA8vrDckQjHzSXyHKQ2V3sT6A/TQD67BCDc6cA3wVM6uPJJMUL6U49Dmwbh1Dm9lHYMD8QYvrSxIaEMz6G/q9xqnLCGPYc7lU7YWvNidAeUxRt5S90D3ZDbR3fBLbygBFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 19:03, Mani Tofigh wrote:
> 
> 
> On 10/27/26 11:15 AM, David Hildenbrand (Arm) wrote:
>> While I have your attention: This variant works, a different proposal used
>>
>> list_del_init_careful()
>>
>> instead. However, that is documented to require list_empty_careful().
>>
>> Do you think it's worth looking into?
>>
>>
>> https://lore.kernel.org/all/20261026-thpsplit-careful-v1-1-
>> d357d70fd6f4@columbia.edu/
> 
> In this case the careful variant is fine without
> list_empty_careful() since it writes ->prev first
> and then ->next with smp_store_release(), and
> __list_lru_add() only writes to the entry after it
> sees -> next == entry so it can't race with the ->prev
> write anymore.
> 
> But your version also covers the PG_partially_mapped
> race your comment mentions, which mine doesn't, so
> it's the more complete fix anyway.

Thanks for checking!

-- 
Cheers,

David

