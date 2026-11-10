Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A039606A326
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 10:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JarSwNEh
Received: by kanga.kvack.org (Postfix)
	id 9280C6B05B9; Tue, 10 Nov 2026 05:41:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D8AE6B05BA; Tue, 10 Nov 2026 05:41:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77C636B05BB; Tue, 10 Nov 2026 05:41:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 417EC6B05B9
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:41:57 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 98D7EA822F
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:41:56 +0000 (UTC)
X-FDA: 85418869032.29.5D3CE2B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id C31911C0006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:41:54 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JarSwNEh;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794307314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sf5RKSAxCyExCYozothLzGZn1lg1pz7pfFjhL0ZFBV8=;
	b=CLAN19JdwVbJSz+sMed7x0TNj4yDxYLcwbajV906P952CKgtabHMBhI6KZPI9VjLrcp46k
	IO/WqltHqYyTfA/MgArw5qUBXqBMoTDak+D8wSU7rLTWu5jbixylCsRxwh6xVEx8ImtxKI
	ukYqv32FlgFWTj73xA4dOD1y7336Xf4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JarSwNEh;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794307314;
	b=xbdivukPEMMgd2N6b/PDTtxF8YYz2Q8Rqx2JYHVWR/aG5D6t5lKK1QzSvJeJvv1trTqMim
	b1V6M+PLBrjJNcPjncaVAgToFf6mFGsjED1NBDmO4WPWBsg+7PyKxaQhZ2IkxuPB1L5rd/
	w6diT1XKYs2ZZ5sLvrbpBDcIl4TxOw4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2BF3E41864;
	Tue, 10 Nov 2026 10:41:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65D081F008BF;
	Tue, 10 Nov 2026 10:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794307313;
	bh=Sf5RKSAxCyExCYozothLzGZn1lg1pz7pfFjhL0ZFBV8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JarSwNEhuqQeqZKuGdrIJZ2QFEC9r1Q+GuCL05G5EOXpRL4aApaecjxjECfVuG2L4
	 9gIQ33mSV+no5kBy06WsvfHPuas3aEQ+SZC+0QswMKoP9mCluBu6ifOwaRgr+cFonf
	 Zp2NNlfg1QvVn0TJx7d4SGEwObtJ0ZGdz9d09+UH96uoQfLBNslFnxJDYagNAWORfB
	 548ACuIGBLIJ7lBGXG9QriuKXYvgRz7Yv9Nl2hI9IFpqELYUD+b/bOUUEnuw3nrHTk
	 /XYtJqdOdiCGF4WtttMf1Fe9OT6U0jfmsuL59//QckCo8EuWJKAeaQD3IT5KeJc+42
	 Gxeot/Kvu5IqQ==
Message-ID: <322e1cec-1435-480c-9d49-d16b366e1173@kernel.org>
Date: Tue, 10 Nov 2026 11:41:37 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] mm: limit pagecache folio refcount when mapping
 pages
To: Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Song Liu <songliubraving@fb.com>, Rik van Riel <riel@surriel.com>,
 Miklos Szeredi <miklos@szeredi.hu>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Hugh Dickins <hughd@google.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>,
 Kevin Tian <kevin.tian@intel.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>,
 Robin Murphy <robin.murphy@arm.com>,
 Steve Sistare <steven.sistare@oracle.com>, John Hubbard
 <jhubbard@nvidia.com>, "Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 linux-arch@vger.kernel.org, iommu@lists.linux.dev,
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org
References: <20261107-refcount_overflow_stable-v2-0-c38f6809b106@kernel.org>
 <20261107-refcount_overflow_stable-v2-1-c38f6809b106@kernel.org>
 <DMR6VVEKW3XN.23D8JAIT65YIU@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <DMR6VVEKW3XN.23D8JAIT65YIU@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: was9jjx8zcwyzx17j645rrh6ab64mxba
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: C31911C0006
X-HE-Tag: 1794307314-814330
X-HE-Meta: U2FsdGVkX1/Xid2GSbISYkPiQRbhVI/IMXOTugAtLCt+trJA2qsJ0gEdF2vqrwJa9zUdneVZKZK+wJuOdEZjNLvw/zBqDc6PGcns6Q9toVfhcDXwuAupnpWuxkq8GizCrTsOA29YVuvSx3dLDy3bAlBygpmjdGdOj1PVi0SfkgNFd1Tmo/wq5erpjFe13bGvqri2NzT8rvCGz8Q2EeRUOBupVNDgLFP3355loXCE2pfkP/Dj+ELYlDv5doDSFuQM5M+LlYlmwkOvZqCnOay3uzSiCWdqcEYLIq+WCBPKsavfZXqo8YsD57J20YiOQ1aqeHzAbkJQ2Rz0jU+Qwp23Ow9zcaU5NKJTRDzsl8wl946ZhF2ZaLcxgocFCPtP/0pgGxBjcEMPOPlzzv0ZPVfajtMTdDILU76m7jcPspfUs/tFF4uUvzlctwm7ZVRxla+67S+RLSLgwzRUB5RGaWo2PmtVDpNj8L65lWcImNtdkuQXpVwYKluUZXsKuSENT9Itwel+5OZst5lrgL0nDJjrYovdRc2DKiVhtajhr82xyUXlE8u/6kFtbAmlQbmsbvCGxXNIlYbajsvCosa6NH3wd3lzCgFm1CGxElUyn+lzPgsJ3jHFuSvjQf2NDvj+yS/sT/7GF3KA2ag64SrYtOcTAsNYI9XSQnf58P/bQ69w1sdVpKnmYIaY/dwKhwax2ZOLR2t3cl1bce5LjJN3lu9P/yh6ycw8GpBPP8s49EEFsebWrXBg7zhVQ7/JplZKckC52shsIB2YdH84RmzJhxwsvRaYdQmzbKev9mstQQ/WufcWQhWC51+Scyav171Gx0LqLvzvVF0CrZxkLtSfpX0Dk3E2HH2hB9gk7+w7ALP/5citRkaFPSHxFqtZhXJD2uWNelmPzvUXrYwvh6L2PaFR0taQukJnbqzZjzRNWUT3La2ydZYRTKPLWLKZZexWNfjY+ys1vrD401hVLq66+IL
 bLkRy25H
 OL99MkmxKqvSaujF5YS4AGt4jC8OsXtqBShPOpCyStzY8uSJIAuZiTRDXAptJmGAektANmXWiAHN61+L17xyUMY050xVap/Yv+aH3CdvUXoYjhqC0Kb2is3Vv3GEyVUvqYq6CTtmrHghoocEbmD4Ij/Rcjd9tvtGxjEpxfAhQH+pxMk4xqf+U14G4oRkWQoKCiqZxfMXmIJ9NjaUcUlTDnriiyBVs+EaYwcdr1ZMtcf8t8I95z+LCIrGOYwRq+lIF+pkXtEFfdGb1BcpOQJJPfj7aiAlXoMBgLC6BWUzOWWxIOLnvHeTw7ElF7zO/bzOI+XnxppBrQcblPqJg4CGuWwsFLN9gKp2ni5lcahAv0wC9BOiKsaOanfQC2SMu05RVH/Jj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/10/26 03:52, Zi Yan wrote:
> On Sat Nov 7, 2026 at 5:23 PM EST, David Hildenbrand (Arm) wrote:
>> With large file folios, overflowing the folio mapcount and refcount
>> became possible. For anon folios it is currently not really an issue:
>> each large anon folio can only be mapped once into a process; on 4k
>> kernels it would be more processes than usually allowed on a system, and
>> on 16k or 64k kernels the processes alone would consume hundreds of GiB.
>> Something to be sorted out at some point, but it's not as urgent.
>>
>> Being able to overflow the refcount is not really big news, but it's about
>> time that we do something about it because some modern technology might
>> find ways to abuse it :)
>>
>> One of the enablers for that was commit ddc58f27f9ee ("mm: drop tail page
>> refcounting"), however, file thp support was added later.
>>
>> File folios can be mapped multiple times into the same process, allowing
>> for processes to hold many references to the same folio.
>>
>> As a short-term solution, let's introduce two folio refcount limits:
>> one for ordinary consumers and one for admins. Leave some headroom
>> before the refcount goes negative, which we really don't want (having
>> the mapcount go negative is also not expected).
>>
>> Start reporting SIGBUS if we run into limits. When restoring mappings
>> from migration entries, instead zap the pte/pmd entry. We allow for
>> slightly exceeding the limit to keep things simpler.
>>
>> During fork(), prefer not copying page table entries over failing fork.
>> Export __folio_ref_count_over_limit() right away as that will be needed
>> from fuse code next. Use has_capability_noaudit(current, CAP_SYS_RESOURCE),
>> so filesystem credential overrides do not affect access to the admin
>> reserve, and to not generate auditing messages simply because we access
>> optional reserves.
>>
>> This is far from ideal, but better than all easy alternatives we can
>> backport comfortably. For now it fixes the big problem: letting
>> the refcount (+mapcount) go negative and cause trouble.
>>
>> This is only a temporary fix, we'll follow up with something better.
>>
>> Check order 0 folios as well for consistency: each
>> folio_add_file_rmap*() and folio_dup_file_rmap*() needs a prior check.
>>
>> Also, just document -EHWPOISON for copy_present_ptes() while at it.
>>
>> Note: When zapping file migration entries, uffd-wp is preserved using PTE
>> markers, but uffd-rwp protection is lost because there is no corresponding
>> marker. try_to_unmap() already has the same problem when unmapping file
>> folios, so we'll happily ignore it.
>>
>> Note2: For now we don't let migration or PTE table collapse exceed any
>> limits. Admins can always refault, and if we are already operating in
>> admin reserves, something is already off.
>>
>> Reported-by: Chris Mason <mason@kernel.org>
>> Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
>> Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
>> Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> ---
>>  include/linux/mm.h | 30 ++++++++++++++++++++++++++++++
>>  mm/filemap.c       |  6 ++++++
>>  mm/huge_memory.c   | 29 +++++++++++++++++++++++++++--
>>  mm/memory.c        | 35 +++++++++++++++++++++++++++++++----
>>  mm/migrate.c       | 11 +++++++++++
>>  mm/userfaultfd.c   |  4 ++++
>>  mm/util.c          | 12 ++++++++++++
>>  7 files changed, 121 insertions(+), 6 deletions(-)
>>
> 
> LGTM. I wonder if we want to add a VM_WARN_ON_ONCE() refcount check in
> __folio_add_file_rmap() and __folio_dup_file_rmap(), so that no new
> caller will not miss the refcount limit handling. That also requires a
> reproducer for verification, but it might be hard to trigger all
> possible code path. Anyway,
> 

As it is valid to expand into the headroom above the limit, we could really only
check for invalid refcounts (<= 0) there.

We do have a folio_ref_zero_or_close_to_overflow() check in folio_get(). Likely
I should just replace that by a check for <= 0, as that's really what we want to
avoid.

> Acked-by: Zi Yan <ziy@nvidia.com>

Thanks!
-- 
Cheers,

David

