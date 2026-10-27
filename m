Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0CC7606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 19:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j3ud/ZuJ
Received: by kanga.kvack.org (Postfix)
	id DA27A6B0737; Tue, 27 Oct 2026 15:23:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7A266B073E; Tue, 27 Oct 2026 15:23:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C69C56B0742; Tue, 27 Oct 2026 15:23:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A51C26B0737
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:23:29 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 56CE4A8859
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:23:29 +0000 (UTC)
X-FDA: 85369380138.20.FC0039C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 94ABCA000D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:23:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="j3ud/ZuJ";
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793129007;
	b=h8KDn1FTUxO4Po1Obbi7STNRfJIaDI0eyM3ueGYmAcWWKukIWkAPCu0WPIR+IsCBUaPG9O
	Ri00/NTQPYyE12HBN0NlcjTSQxCamPjpjjk2A4oPZxTXJqVdKgS9JsfaRuyNyXa0fyCdKF
	uV9Z3nsxjxCUFGADo6EIYBpT5AcMtfQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="j3ud/ZuJ";
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793129007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J9gSRb3D7ogtqu1SdrAnawsdd8oVJY1XtzaSrPDBAaU=;
	b=XSnWhd6t032FBqAcA3kY2WIt7a1nRVh3vGzpa2iGOIlHcNy7/JFwnxJwyDZJDSePNt+VcU
	sBjvXrhQzyN1eL06XKy1nySK/vzK1KCGrLdPYS4P58CZFuHjYfMjOSgQI8Rgg9CNLGITwf
	odE43faqAMdLfled/h31KP5ddV/u68w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3B474601F6;
	Tue, 27 Oct 2026 19:23:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D6CD1F01825;
	Tue, 27 Oct 2026 19:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793129006;
	bh=J9gSRb3D7ogtqu1SdrAnawsdd8oVJY1XtzaSrPDBAaU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=j3ud/ZuJbVW9Ht6RBnRGEDrT32arwt0VIBU0qKDUNIniXzHqRWI+D+aEx8+VeUx89
	 HqHfaNjLOyNGKRWV6YgOkr68n3/qo9W0eMTZKINy2npz5GIar9UTvOFFdcSrtP0vv5
	 4jBkpsSuk2SY0/VYo17xyO/vRjQmaJgmQ0ymbf30GmQWIepsYBU+WJr0/di38WoRq+
	 kqm7EYhMmPqKzwKCAnGfYtn00aLBJbManBRnsv0Wg6USpxdVWqOa63F7st/2+ucXEw
	 SHdY9czvzINbUIfc9qTtV8eJv4VO6GuzywLfFvmEu/vIFmsGBnaOmiDW2PK2xQnMZa
	 1n5n8XUqi4ceg==
Message-ID: <ba37b2a3-201e-4cd5-a992-c3ec6ab2aadb@kernel.org>
Date: Tue, 27 Oct 2026 20:21:33 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 23/46] mm/userfaultfd: write-lock the VMA before waking
 waiters when unregistering
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
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
 <20261027-fixes_core-v1-23-6f74bec9a5bb@kernel.org>
 <auBityGTDQjXURWg@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <auBityGTDQjXURWg@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 94ABCA000D
X-Stat-Signature: 84bry95s9shrf17eu4iu1m4qxf69xqkd
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793129007-794712
X-HE-Meta: U2FsdGVkX18uzAdnaSh9xle5basrOfIJJgWIVp7d7jN/glbHaQG09j0hDnTHJBwzEPVhS+uYLIOp+7d1uFD+KGUti3Ng0rUvq52wVNviM1VR5qs6nBBXv7L/BOm7fXLlpCv3wUbpLnE16muwHb0adxtlf0s2LrtBrHRmoN7w/eIIJmOcGj7m43vxqwD5pjaEEiKxbirncOZhTsuiXP2DKosX2dubXyZ1gS2BKqa0GzzxwKw4ArDV7F8WEUOA7w4DJJJi0G+RbyYwKUjDJguggD4rc/tWHShuiY9pjFKd0rlnh8uyPSXmvMXu36EBHhdcElMKie1yjFH+j0XFHslq/odltXXa4J0XcxCxPlfDoTAWVsiE4fHfouLxWCRlEYecwNGOPcH7cClB7kDXTGC8+Yliv+/zO6WUxjzVnxvJyMCo3VMwkQb2CEp/VlvcAaK02gFICpWBor4xITInimd1jgYzHGSZ84xEdtwF0b17LXuxlUTahQMfOdWfWKpoJdUo6EmFqDIsS9i31qWPEp89N8LinaVeqC1f1RsMpulFtOa6anEt3aF2KKqm1cFe1lTuKqzmiWmdOLH6yjPPvr74rbcCFgt8X0yoqLylNm/As5PkM3ax1kIly8qBsKefyZZjTFJSX/06NNDb7d+9v7OKmRnxfLliX9P//zOR1mfyq+WlBfn7QtEoILURFsqaCQGGs2RRFpR+9DXht9FaBr7krywcSXwYrotBE4IVCoI02OTa3xZIsMy6vsIKCggT3bIW1QaNtaAcS+zdX7fFiGLpXbqvfTz+lZPJkbKPvbrmGv4ysKXlUO7rFRMNYOi/05bGr3qgXST4ScgRRZF3pJr5llPGlnpjJDfqftXGAm2UoZHV+wiVonARuoukE/94h52fVeYLoQO6gekObPBexSLVv2959XEdjzQ2LDtTGFXXLuVoPQ1D6Av7SNNvKqNlq0x1JhJaROyFArLNJbsIa6w
 ziipu9e1
 4Cln6PRZ2PNV18KPPor9GpahDuIv0OIb4FpIhgXP2lGFpYXyD+rf6FoTY9IJXlj281GpcMFRZrTPWrjDhpM+Iu03asZl2QVii6YOY7agbW2JYJMhUPD7ez7yEIXxWOUt1+/AUXkvoU7cQiD8N/xdUZA9ta9A1zI+i5xAK5C0LZRVGfNmYoMfr/zcSbu1SESwJSHMeRsQEv2D6OlOosaJ0MkXsKjO53B7lC2GTo+5nBlcAhigkmz1LtIpdMNqAJwNo1Ygt19/FPy77q1jjIrVRD1eeneYinyDyG9nmRr4gCErtoxabBeSbiT65Wphm1CeyO8iVc1dQzDuAXE0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 09:43, Lorenzo Stoakes (ARM) wrote:
> On Tue, Oct 27, 2026 at 12:17:43AM +0100, David Hildenbrand (Arm) wrote:
>> userfaultfd_unregister() wakes pending missing faults before clearing the
>> VMA's userfaultfd registration. With per-VMA fault locking, holding
>> mmap_lock for write does not prevent another fault from queuing after
>> the wakeup but before userfaultfd_clear_vma() write-locks the VMA. That
>> waiter can then remain asleep indefinitely.
> 
> Oof.
> 
> I guess userfaultfd_clear_vma() only implicitly takes the VMA write lock via
> vma_modify_flags_uffd().

Yes. And the original AI fix wanted to reshuffle waiting because of that (stupid).

-- 
Cheers,

David

