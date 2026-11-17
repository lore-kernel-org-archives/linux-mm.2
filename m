Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D862606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 09:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ieF745AD
Received: by kanga.kvack.org (Postfix)
	id 89FFC6B05B8; Tue, 17 Nov 2026 04:56:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 877866B05B9; Tue, 17 Nov 2026 04:56:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7672A6B05BA; Tue, 17 Nov 2026 04:56:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 51F816B05B8
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:56:04 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D4C2A1603B1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:56:03 +0000 (UTC)
X-FDA: 85444155006.28.9D5703D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1C9B41C0009
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:56:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ieF745AD;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794909362;
	b=gBKmfsEiTVj3yp+x9jVPst4R4tInhVMLpeMEjJ3kCZBxqP6gqfHsz7ii78fGdDDbV67lif
	8hmDVRGPAEIjuPHD4XKiE4+JHLZHjGfCIsvuoM5NvftyJ4iCz6Me1K0iANezxmZMHpre1E
	ezOJIGrIBeywi5iI3MSC6i6L7i8H2xc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ieF745AD;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794909362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RXpkAmDQM3YL/W8+BChLDkEu3hDU+qLuCPRwmd9apzM=;
	b=epUaCqhcRLVWcztSzmLCtukJ4rd65goV0P8oB+60u6GeNYZkxrD+h6H/sj7wB/ssuK/5nd
	B29k+go3LksTq6LQxkOgEEKEBEPH/LlRKPRJQGi0aetoQFF75CRBArQLbQuT3s93Qc0Ym3
	NoHkBmDScFEjXE1jBr0IPUjv/edo/IA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B178261E81;
	Tue, 17 Nov 2026 09:56:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3D6E1F000C4;
	Tue, 17 Nov 2026 09:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794909361;
	bh=RXpkAmDQM3YL/W8+BChLDkEu3hDU+qLuCPRwmd9apzM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ieF745ADkvptZ7RZ9MjF5EOCbX1p4MyKcv7xpQefcFxuUQt4dykq1m4vjzcAiDDK4
	 Y5SI04smpkSm9CXwMyK82O+uRop1RRfBovG+iN9uWzD7G8ohkUPJp/E2ijYCMFcQ6U
	 50PL0zzXZZ3oFqWsrgDqFYTrOqkTe9vIs0BeoGXCSRagFOmXXGSyxMvYAkrX1s2EmM
	 Pu3I/B4hv2Unp0MBR5GHePMi+ixtbZg6D7ESw0X0vVlii6XHu2mHaxxVOYObCtWd1H
	 mScv5Gfy4GJlJSHNQdt1yjFNUN9ziEauxef79xcUzo0heuKIX22fHyKigjUnSQCss7
	 t7jsB4B7pe/pw==
Message-ID: <4851f0db-9305-444e-8037-34bed9ecb6b3@kernel.org>
Date: Tue, 17 Nov 2026 10:55:48 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/9] mm/migrate: keep the uffd bit when restoring a
 writable migration entry
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
References: <20261116-uffd-state-fixes-v2-0-4397a0196479@columbia.edu>
 <20261116-uffd-state-fixes-v2-4-4397a0196479@columbia.edu>
 <2d9ec2ee-8867-4ac2-b2b5-654bf2441513@kernel.org>
 <20e72944-108e-461a-b75f-d8c4f8edbc9d@columbia.edu>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20e72944-108e-461a-b75f-d8c4f8edbc9d@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1C9B41C0009
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: ec6ww4ygn6h4g5hp3qp6axubu15w66oh
X-Rspam-User: 
X-HE-Tag: 1794909361-836228
X-HE-Meta: U2FsdGVkX1/2wra3etsr6ghVePZ0FAo4XoJasrpKibZehq5XRzSXAK3YMN3ueA+JL9GZMd9uDYappY2JJ/5hCk9SEqnYFchgs+0Fhf39+GtiyUfp3qcft9fYNhnjmZai8rsZ0G+pNkTDMz3e0vbvhyfCsHbWbp1TVWVezlatKss6IZ/ZIj0oqPmerou4Do5GKSLk6+hbvbfDgFeACL3rrUGSFWfnewgItUUQnFkL/BDlghi2Hts14FfJQbSFwPk9i173TQt3aTE3lkFoWJZSqHJFX07Um0RMrWcfD1Yyg9Erwf4dNw6jPr1bi/gsmXg8qsMplWYOZcoo5uKImf3E48cN/PqJwEdOgr5Wo+Bhl1snAWkI+N91bwzEX9moFgJB7S+vq0YErB9uFO4+7RDKCin5PiJPRQSILlVFX8q0sQuc6DlMpgzKvm80VeT2plRk+R8FzELVOzTca9MQTW67ohjTo3p3DXepSeTsffTHeR7D2f3OhkliGlONwx6dymTzpFq26+/j31qzwHwNnaHIuxPnX3qI6Pnk6sVOPCkltXrlS/D3faCMeRT/T6t2QOhgYrj65IbJlaZbh1C1oCMBmq5zS8I6H3ZJ5+GfpJfFa4pBUQfbFv35FRZZaAgrfSBLKwJ/5jdtP3mI/ZEF2pyiGKFohbDhakQu8EAay2k5vI/6ep7AcuQolTZ4Tixo7WRozmCrGy25yTFsqE2UQB8TC8RS8RoNevf86ESNlqt3tFaDzOgUzxnL9/hVhTo9Nit8swLc34/sROcVSqgxKQHiGUE+O/k0G6oCzgW2dLlZ3xR4ouJNrjoMcM5S4WBQeJdIAsDmK4mTIRmXZ/AWTR5pel91yc8Ph1NKZKPdZmWhMlcdENDRmlWRu5AbLaTD3KFbTZftECb7ltmrRILxSBLsKx+IkaHx9y04l7syKAu2uwX/Rn1eoAnVXGYGEzu9d+ESUjd+cKRhHDLK6qdzlce
 zqUtd5hL
 CwX2x6S0h9jQ/4dYmWNRrCzLSAUzgBDQlbmVR6IBL5d00MGTnO41dM1UwzuFDs9oP17PBJD0EQ3qTTH42ytJRFo904k9RMFXEWxRH4SdTYQh6koAP56jVN55ArgL9+rDe0xTHZgz76FpJpk34SrlIHwFMHjSaz/uLvF6P9quvqKQ05T/8TFdxZcMw6VGktdUFzDhjeAG5nSVP9ar6VKtjOp1c9mDq3rzy+Pak2eKMoJYiy3iRkCwX8Gw+eX/5murM1/jXKFwwGfnl1amRlYmxORSTBETnr9ST04axKQu0axUA95J+7lmMcogfW/dPaMWaO6vyH7fGzpUUxeg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/16/26 23:42, Tal Zussman wrote:
> On 11/16/26 3:23 PM, David Hildenbrand (Arm) wrote:
>> On 11/16/26 21:02, Tal Zussman wrote:
>>> remove_migration_pte() makes the restored PTE writable for a writable
>>> migration entry, and only looks at the uffd bit of the entry otherwise.
>>> A writable migration entry that has the uffd bit set is therefore
>>> restored as a writable PTE without the uffd bit, and the page is no
>>> longer write-protected.
>>>
>>> An entry with the uffd bit set must be restored write-protected, whether
>>> the entry is writable or not. remove_migration_pmd() gets this right: it
>>> makes the PMD writable and sets the uffd bit as two independent steps,
>>> and pmd_mkuffd() write-protects the result. To fix it, do the same at
>>> the PTE level, where pte_mkuffd() write-protects the PTE as well.
>>>
>>> The only known path that created such entries is PAGEMAP_SCAN. With
>>> PM_SCAN_WP_MATCHING, it write-protects the pages it scans, and it set
>>> the uffd bit on a writable migration entry without downgrading it. Now
>>> that PAGEMAP_SCAN downgrades them like change_protection() does, we
>>> should no longer see them, so this change alone should not be visible to
>>> userspace. If another path ever creates a writable migration entry with
>>> the uffd bit set, the page now stays write-protected instead of losing
>>> the uffd bit.
>>
>> I am severely confused. If it was properly fixed, why should we do the below?
>>
>> You should WARN if we get the uffd-wp bit set on something that is writable, not
>> silently swallow it.
>>
> Yeah, so this is more of a hardening change than a pure fix. I think adding a
> VM_WARN_ON_ONCE here makes sense, but the uffd bit should still be set so
> writes don't go unreported (which is what remove_migration_pmd() does too).
> 
> remove_migration_pmd() should probably grow a warning for this case too then.

I don't like this hardening fix with recovery for something that should never
happen.

Throw in a VM_WARN_ON_ONCE() and call it a day.

-- 
Cheers,

David

