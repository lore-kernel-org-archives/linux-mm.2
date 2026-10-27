Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52DF5606A331
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 13:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jIhYLNBN
Received: by kanga.kvack.org (Postfix)
	id 607A36B0759; Tue, 27 Oct 2026 09:56:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DFBE6B075B; Tue, 27 Oct 2026 09:56:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51C956B075C; Tue, 27 Oct 2026 09:56:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 309DC6B0759
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:56:07 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C9B90A0935
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:56:06 +0000 (UTC)
X-FDA: 85368555132.27.42AEFF3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3936B40007
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:56:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jIhYLNBN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793109365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zr1jTThDFAddOSK457sc66293xmVyHCCi9iGlWUeddU=;
	b=eBvEbKof9RAWRv7T77xDc5jF9UR2U5Y7DbY7v5hstc4vkQXliBP+5V35WDJFSHiO0J02h9
	EXrVLiiRPZFj4fGYueqy2YQt/sHU1H9mhJVoACaM3iXiq4ysxHaS0cWFdRw4Q2ps8m4AI0
	M7Wjlvw6YrMche4l1h+HSs5AgFs0iiE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jIhYLNBN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793109365;
	b=qtpKih127KwkmyF+8nz1iK/g9bmNC3/QEMgIBJYlWAoPCW1lmnbd3M5Hb5QLDx9KhYWQ5U
	skZY+qzIDXGu5BtbOOYX6pbqEqcM8QenujfpGxfCMkqPSuUCzwZRouzWju6gi+zG0Un48Y
	A1qPChxTEsDHWkKahz9UtHbWhktFNeo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 94C686020A;
	Tue, 27 Oct 2026 13:56:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B17E81F01825;
	Tue, 27 Oct 2026 13:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793109364;
	bh=Zr1jTThDFAddOSK457sc66293xmVyHCCi9iGlWUeddU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jIhYLNBNpp0NexZNmMUHOUCY+eEy16NfWjuSuwLJqmFHwNWPY9BdmcaHZW+1fGIg9
	 fiBkl7KehfwTpd4R+QE8pIbz2ex/lWNl//inoU+svKsu/oI0sqh9JGs4nayk/63cZa
	 PuQtRNz2s2eqW5o62hUTfQo+difIHb2bfTQI3wmFE48eH1hqvasX2J061wIVJ/8XLp
	 B8iwzzJIHvVnrgkO1CLMhM/dtnxK1pMp932wcPpTyDMf/mtjlI6T7bM2e0ImgLpb5G
	 itjSlM0i78ybkEbvAJ0jTU2GNXWaOjkHSgMcq3b5iw8EB94IUavJ0yBcssBsMi8xzh
	 0HHSAVhaSG0Nw==
Date: Tue, 27 Oct 2026 13:56:02 +0000
From: Harry Yoo <harry@kernel.org>
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
	Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Hugh Dickins <hughd@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
	Rik van Riel <riel@surriel.com>, Alistair Popple <apopple@nvidia.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
	Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
	Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Gregory Price <gourry@gourry.net>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, stable@vger.kernel.org, 
	Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 02/46] fork: take mmap_lock before copying mm_struct
Message-ID: <auCtP8SCiHFcSGci@thinkstation>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-2-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-fixes_core-v1-2-6f74bec9a5bb@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3936B40007
X-Stat-Signature: jsaf9esokjiw8oiognwpp34wg5bhouk5
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793109365-479024
X-HE-Meta: U2FsdGVkX1/oIkH8anSu0nZtmRW9HuwPH8HbHrsHW4MQsDAjiEhI1V3/4K4694AT9RmGvURbhdPZK5/VPD431mThIAHA80tc+mCQXIgwvCLO6eEc4CZ1fx3IfVu1c0MMAPqDFokMXpkPAyhi/O0jn+/Laer16C7StZKmB5wdCsW2NUPxcwdynzw65LbGl9bUmMxklkL6sdHaqTcO+89YIMqsY/JNKVH5DK5SHGlFZbv9SeBxAgPMookH80f+HTTLjuOenFtTUOOK2I5FSpnAdaK9mDncCA7tOmyw+OObZtq/u0OsFxS7w4xW4ZC6nFByKMXcRVXQKKmZjcAy4eB3RNEDXicpM0EFIRrCz7wyra9iohrDL70ayczU2qZLLpGt4AEjMXXHf/y8+9zT+dyuHIApchkTOqLReGKYaxj502jewQwq4S1KJqRwUQbVHwH1NriHF1dzyVfU6LxyUPeLWX3CNXL5Uw4XdcXY52rKhQuUUUeqI1tIowKnvQb6An+rB+6CnbLeKoZvOWLjTPm5dwF794vLRVDg3zW50g5hhCpXh6FoCra/VxKxWphIjJHMgYPjRSYvJ5yivguVLOo9oD5mDF/0wHrDin0N7wGsF2iUrAY9djJ20VZYxMcW7Dmiatmc1lhH9WCwHJWgAFmPBPBJkMhFoULzz4LTAmRMWgyXg5wUtPQkEt259jN8Twh89vbp5IqjNH3hvvkP2qNGfq62Njwkf2GoZZFX1q+t4DmITEjwShgGV2PXKgwNbpNY7kZqaMX0N/EfGYl3X5+7iDtXvtFc3mofUj+3IqFaz5/VwrDzgz7dX0QAL8gxKlb/TDUlNxtLznCA7oSADPQUZ8pTDqgbkN86rMWnf1dyQijXgf4848y21DT0vn4Clr2o9GTN0oqAnlWiZqZLGpejO8l8diYZ0nI4QbVOjmOtBCvVmHu6ktqSlCJ9dwrhby1TgdXzWzPIGrv/11ucaHX
 ayR9wdf3
 AnNiURJyje/0aDGBTiKFu+IrQ1zIZpdsV4N6E3eEUlVr6KPadku1h5oMxSVtasBUsnEisGrdQ3ZVGs9eynrj1fNq3iZ1KmCVFeR7aFrcQQvpXZCp5dkR5jxLK9KiXEkYRX4s9x1E97lu0jfqH/paAX//GAJO0jOAMJnHUyLDY6+B/sTPXjXbQsG1MPBYQ5ux0gqIL/4+coIopr3dCBazSuxD/QhrxqnkCf6OcxWhE39Irh33tb3i9UcWZg0i2u/TKMaHDvhSnQWyHJdv2tBsPmTE39wGTfyCAJrGw4ttpcUVByd6h5Xr1gignBbukyLbZg9cEHau4YTwOceCJY2pIvIrS2wfcajEkrXE5igDfGs2zEVBiIo87WJtnFdJlMyRCnVTBV4GyjPic6HrhwXoq8oL8xs3R5N5WsIWRotl1Bsx4r0PrZmejZp/tlsG891NXi6Kt1alWCMBO/y0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:17:22AM +0100, David Hildenbrand (Arm) wrote:
> dup_mm() copies the parent's mm_struct before dup_mmap() takes the
> mmap_lock. A concurrent brk() can leave the child with a stale mm->brk
> and newer heap mappings, causing later brk() requests to fail.
> 
> Other operations (e.g., PR_SET_MM) on the parent's mm_struct can similarly
> cause inconsistencies.
> 
> As a simple and robust fix, grab the parent's mmap_lock earlier. This
> way we don't need to update individual mm fields in dup_mmap() and
> keep missing ones. Stop updating the 4 existing members (total_vm, data_vm,
> exec_vm, stack_vm), as that is now no longer required.
> 
> Keep releasing the parent's mmap_lock in dup_mmap(), before
> userfaultfd completion, to avoid moving the userfaultfd handling into the
> caller. This should get cleaned up later.
> 
> Move uprobe_start_dup_mmap() to preserve the lock ordering.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

