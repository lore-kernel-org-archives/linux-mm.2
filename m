Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0FA4606A333
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 15:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ouBLsAtQ
Received: by kanga.kvack.org (Postfix)
	id BED096B05BE; Wed, 18 Nov 2026 10:37:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9C746B05CC; Wed, 18 Nov 2026 10:37:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A64406B05CD; Wed, 18 Nov 2026 10:37:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 838976B05BE
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:37:21 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ECDE2C07A8
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:37:20 +0000 (UTC)
X-FDA: 85448643840.09.C959536
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id D632820006
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:37:18 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ouBLsAtQ;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795016239;
	b=1VGgox+OMeDCMqz36uUdK82JkzMwpWiclTSWT7y2iDvWUwL4SReu6ML4sDQmvWUWm3aEgb
	pGJik46MGlEznUfhcdJHcPNOThU3N2u6NOLnySXiVbDASSXCKXrI2LVGOkF3GlShKGlEcg
	rBuK8iZZQ+ESCMH9PCI7v43SwkyhuaY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ouBLsAtQ;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795016239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RGtuOoXmARbodH7Cw+9F0C3TnVxoO+KV9KQKzi8RPLo=;
	b=RMbur/3Q70BSbveilbixkDkje2ix/MhY/s+ZqnF7VQ4BXZuGoT22GHyDQQE1RXY04dOTLx
	CESYDLDcgSwTXMgjnz4Yflfipee263+0lON7WeoneVavR/n6ug39LgaGPiyMUsjYIogeVh
	xtjrZAWZ95cbesSiga6rp04loxzyge8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 03C4D42D89;
	Wed, 18 Nov 2026 15:37:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC5A11F000C4;
	Wed, 18 Nov 2026 15:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795016237;
	bh=RGtuOoXmARbodH7Cw+9F0C3TnVxoO+KV9KQKzi8RPLo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ouBLsAtQ40oLsAZd1zjg2WJWLNqzwMhUfP/CPv4ev3jpHGU+8ovI1/XzIoAmz8sD/
	 lALlKPHLFGVk4NjtK7nu7+IC9x+zjveLhbSdUOcABwiWN0XcUaBLkBnCKRhfMiJS6j
	 6MuhpQLTkoL6xFlR6wr4KQucYsPJLIIfhxqdi8MPcQo6W1TlysTrTpIr1O0w+OSgI0
	 uWYIlMYVajF4C6MaMZcxEmnBMWa/Cr8RKwpqycTbBpEcLTmMWwnR7X7RQkJRkxLBc9
	 +9akaPTYA131z09+z3n9TjrBVHq1EHMQPMWrUJwPJPfEHVDvJ0Zsuh8UnZ3Xhomzxq
	 S2bEBglFbbZkw==
Message-ID: <bdd849e3-0a0f-4655-9c76-7e40d1e4eb66@kernel.org>
Date: Wed, 18 Nov 2026 16:37:01 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/9] userfaultfd: assorted fixes (part 1)
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
 linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
 Breno Leitao <leitao@debian.org>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
 Felix Kuehling <Felix.Kuehling@amd.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, dri-devel@lists.freedesktop.org,
 intel-xe@lists.freedesktop.org, nouveau@lists.freedesktop.org,
 amd-gfx@lists.freedesktop.org
References: <20261117-uffd-state-fixes-v3-0-b617009d1a4a@columbia.edu>
 <4f23b0bc-b89a-46c1-b8cd-853e7815b7ac@kernel.org>
 <7d31ba34-8b5f-4eb2-9864-145ea80c3412@columbia.edu>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <7d31ba34-8b5f-4eb2-9864-145ea80c3412@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D632820006
X-Stat-Signature: u156zo1otun35bxfhfmhs4j9zs7x6wx9
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795016238-382355
X-HE-Meta: U2FsdGVkX1+ts1zS3ELdcW032Vsty7/xi5SbirG1mW5XtrGyZTGj5kpZesAn8574sjEzi7hp7t4pN3WEfTbRlYz+yMM8ynaaG+Gme1Td2tkcctH1q4285EQQS7Awkc6zYDkIpC/1/7FgMhqr9AmCAGGnjH51JWRrnUoA1QOKjMYu1Xf/wBEBgVQHSjGwZAERFS5kcxEKHrqJux1gUgcKZzMvBmyPgKbtTt8LctS7hecme7jbPoHYTDEsveFqp9b//i81MolLEuP4+2iQSHcFEAut2t3yuao/BR01FnQZCIxipnmsAENxxcsSMAOnrdeJft+pgjO3/66ZIVoGkTpB/tuPFGaWfSdmL46HF8KowxTZSV4d2UuimusjwjfiyXg3NSQ8mUOAyjB43hRAAc9+vWrXleJidA8/poK5krD/8/VuM+59h6QqR8LqvSZn9aCm54bzvbzlF8CFZmIYcKKQirKLP7tFrH/8GzwdmKTR98XrcfwOO3E/2PYwt3qdSKOHf8NOwOPb/8GgYihT7KocWmjM51OYa/0M/zMOFtqV3iVTDVnjvMIHOSYoR2XcnFfNUhM7RUoChVBhpq1Rth4DfOE0i9SLUR7wTUS/f9ul+bO8ZhCp4iSxKM3zjOdBsQhEJR7R9+RHB2siIuRW6bf6kyHA+u1uMkmI7MSgE1Xcy09sHugNBVfC2fM/WG3b0HzHUnFD82yhZGK0WfgqcMSIkfJ6Hfat+vppYED+XOK0rt4l9gv5G5wRausBISn0ccs9voyDboIRVUTRtVOD+260JikeVfIG49FpmIos48lNDaqq9DpfamMWfQtOzN5Sqw7bo+7hNJyi2hGXg2qGCtLvQGYgzU0fAl8de9+9/ElNgL91MpJ5mnEXhk1KwM9g8vTRiwR2rjaEut2AFpZ04WN9SA6v+gGGe/0QFic8we4sIGYNn+7vtSfKXAqn/opqvBdoUgBsXDcd3fuNlSYgDPK
 vuGx3s97
 6xDHvofNceui56mZChshIONrB6U24qW7fBfuvZuygmp2P3xKvAUgVnTncH5+sDqln09EhmWyAOFigQj+hFsa7+qkwdpHgjmUUjUyESJzZQR7phCK2Xg9ur79nQRb0kiEP6OhhV7D+waGpWPtMtJSS/lD1XY606brQjEHucrukYS15RVLa5PJsL6nc7Xlnw7FLw6tlEIScxr6RyaZP65+36waF/cIulwTAWubS8cMt+mZ4hdNpfTIs4NAFVmvsYmlxg5w1YxQMpnpCuxCmr871FDrFU7vOQ9xlvMZYpgejg4eCxU+bVOAaLMbiPQDA/TavJwZTSA2v2IO6dXk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/18/26 16:26, Tal Zussman wrote:
> On 11/18/26 4:41 AM, David Hildenbrand (Arm) wrote:
>> On 11/18/26 05:28, Tal Zussman wrote:
> ...
> 
>>> Patch 6 has little user impact on its own. It is included because,
>>> together with patch 7, it allows removing clear_uffd_wp_pmd().
>>>
> 
> ...> 
>> So, I would be picking up ...
>>
>>> Tal Zussman (9):
>>>       userfaultfd: use anonymous memory for UFFDIO_ZEROPAGE on private file mappings
>>>       userfaultfd: refuse UFFDIO_MOVE into a non-present huge destination PMD
>>>       fs/proc/task_mmu: downgrade writable migration entries in PAGEMAP_SCAN write-protect
>>>       mm/migrate: warn on a writable migration entry with the uffd bit set
>>
>> This
>>
>>>       fs/proc/task_mmu: write-protect device-private THPs in PAGEMAP_SCAN
>>>       mm/huge_memory: build the moved huge zero PMD from the destination VMA
>>
>> This
>>
> 
> So my one concern is that (as per above), the mremap patch removes 
> clear_uffd_wp_pmd() after the huge_memory patch removes the other user.
> Splitting them may break compilation. I would've left clear_uffd_wp_pmd()
> alone but then it throws a nice ugly unused code warning :\

Ah, so it's best Andrew picks that up as well then?

-- 
Cheers,

David

