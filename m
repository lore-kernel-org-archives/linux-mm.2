Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75523606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 19:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jf1fDspo
Received: by kanga.kvack.org (Postfix)
	id 56F7E6B05ED; Tue, 27 Oct 2026 15:07:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 549076B0761; Tue, 27 Oct 2026 15:07:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 435A56B0763; Tue, 27 Oct 2026 15:07:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 10E986B0761
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:07:29 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 881F9140AD0
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:07:28 +0000 (UTC)
X-FDA: 85369339776.07.D5F25CE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id BF5554000B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:07:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jf1fDspo;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793128046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4JNAgIKFjPRpfv1PgOMbYf97LYfRcFa+6eIVMdPRyjw=;
	b=k1M2vAnv/VPw/8oJsv6rrmTw358Yi5xSzmWbz38tf9HGlbvPiUj0aRVNeexk1VEf64qIRX
	OnFkFi+vN1b8NMIl0+hULf5GfwjiLKNXqKWStCQ1o4Y1yRR47ThIAylhbn62y7udh4Zrxv
	Vq1MqZ5dCCiAYs8kixy74eED/Dvuavo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jf1fDspo;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793128046;
	b=R17tJ8f564p6uuanK6X4EAujDjY90rkiSOUclqoEpqznIzXn0QIYO6c0VahlViTcquaDZD
	H4CKgvG6aH2MMXfrLOJ5RrNTSh5i1AJbXOwnehICM/OgHHZKSsoFmCbjzQiZsoBvch0qpK
	Bm4l7PwIVTTjp/lowMTxqKdhRqoa0q0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5779E60136;
	Tue, 27 Oct 2026 19:07:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 729AC1F01825;
	Tue, 27 Oct 2026 19:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793128046;
	bh=4JNAgIKFjPRpfv1PgOMbYf97LYfRcFa+6eIVMdPRyjw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jf1fDspo2NgWYuI74LdGEBcYt8altR6P9yRUKqtzDSTFSAnWIf4GPYCpU6SCH2cR4
	 kLKqYwz07l5Zxzm/sG06VNfh8M3YEXLg0g/xDRdxPgQdpFPjuVEjR01moMhjRlhF+T
	 pjPpXSza1JiJ6vbP0VDvf6JnPlSg5bHKRMHCf8gjvuKNvnjEbklK28yyR7bqqPh8uC
	 LRmuSQyxUKj9WGQhuRHWgrbDg7s+hLnc2B2yj63yqn4Wai5qpm3fBCxoqPXWBL+olg
	 28HWBF3L63ZWkWwiog+dmsXfZtM+0ZeN1bDPXJhSyQqkRos7H6AArQhBQMI6vYISQY
	 8xVSAIg2hJR+Q==
Message-ID: <22b819a2-631d-468e-b724-770caf9f94e4@kernel.org>
Date: Tue, 27 Oct 2026 20:07:06 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/46] fork: take mmap_lock before copying mm_struct
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>,
 Hugh Dickins <hughd@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>,
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
 <20261027-fixes_core-v1-2-6f74bec9a5bb@kernel.org>
 <auB-3BQn_rR6IfY8@pedro-suse.tail5790ac.ts.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <auB-3BQn_rR6IfY8@pedro-suse.tail5790ac.ts.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BF5554000B
X-Stat-Signature: eji8gx5dee7gnzcmgikfcgp5ben4k4b5
X-Rspam-User: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793128046-863864
X-HE-Meta: U2FsdGVkX18jcCnHYDTQig3F+c+3qFZ2yhEJhAJNmgwG4yUhDBJdiJKV/s+3pjwB+wxKI/k+Jt6MZRFrAjry8rIFg81jUxmCWpX2/+inIrQIUaM2+95lcKeXaTB/1v8IZhKA0NIPM4j+0Moh20kr5FJnLssmL5LnJT26ukpbwuQ0hEaLXDn3Gc94g8olLmfSH23+gfUrmBCdCS/6FKXMCG2jDV9qH2tKW9pro7SfnllOxCaIDsR+lXzd74nv+7LAyft9m6230qo/2Irdp2I2Txox1PjF6jERrLyQJYrXXsEie2bA49ID5PI+We+OsbsBE9LoGPjCMtM0XJPiJV7Uv5tQuZDuiTlCe3ysCnHJG4p8Knm9PP9uFQ6dOFyOWkVZF2PgGZjSBAXg358TtPCJRKvjbh3TPZE63tRJHemqt+HRfkJiJkfx9cJZgMJvneilHXE5rtqmzUQGDltIYnLp/H4QpIfvRMce8fw/tTMeeF71QZfmd+MzE4bwyx4DXTOwj6DRczeQRj6fc2CLMGziAho8Xo50PESzOg8/3rEDMCt3N/0f9Sf6QNQgP5Wd6ItG6YPiTmNoPiMU2gdcnj9EeeLsgv4az5C876zVKAeC+FWEUGaoF3LiCEVHcRjvwi0kK4PWfL/hfb9cpg66FOgS8qH+1zzPKenn8sVOVltKJl6Sjt6FsZqY02E6H2RpMoUI/ZtIj+TXM4/dCaoITWS44IEgp7egZWbxuh+c7H6lFQv/11CV59gvFjeX+IOL96N2dOsoUcmi5DMkhgIDPC1+G+0xv8x1ysOtAhpuEE4RSyD3HHdH4YrEye1STzW8CUmBYnYkYcri9mHeTXOp8gcblE5taKyEMd8b33mmk9Kb8TLhtAtq/HushmjoT0spUhnwJEiP26XWK9rJQpR3e6+mQPK/h7UTpT5zT7j1Xe6KF5ezUuH34LgJLjx8KTneSXEU9kQoWYSl1+o6TKHD86x
 0itbu7gP
 GdvQwi4j1QfHoKc366jlVljoSyVan6XqtvZeOFPF8baLQBhI9gQk0lM2bQ+VfXfdZmunak/dOnq+QK83O+FaD411c7iUp09Wx4VmRrRhAwXV3iUFaXdn29FuN6ZStyhMgFuhc94diyHucsSzuGPZfI41IxxCed0BFEya6Ccpuv1MRri83oUDk6c8KruZv4ThJSCziHNBzwY/KSA2jgNUGjfXw4/Bhc3TkdlIy75tMgQ3Vy8Qtt2rrgAJGjg//kqWUs7Y8Apb8ec6S4myUvWiIXC6ttQWY0wfK0F0JrCgQIlyi9XKV/IB/rAXz/xcDjF8+QZl3ogE4LmGplf9wGETHRAZnXIk1Rdt9CK7BLo7PUyFFAZA4UP8jobxEgN2yjkcDlaGCTiNg0mcB5O2JZTIWOLrdYd0qNAUkv/qbAObXBbhg3rNwrLvfu6lysf2fng/zPswJ1p1J3vH5hdPYGVwipFU1sQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 11:38, Pedro Falcato wrote:
> On Tue, Oct 27, 2026 at 12:17:22AM +0100, David Hildenbrand (Arm) wrote:
>> dup_mm() copies the parent's mm_struct before dup_mmap() takes the
>> mmap_lock. A concurrent brk() can leave the child with a stale mm->brk
>> and newer heap mappings, causing later brk() requests to fail.
>>
>> Other operations (e.g., PR_SET_MM) on the parent's mm_struct can similarly
>> cause inconsistencies.
>>
>> As a simple and robust fix, grab the parent's mmap_lock earlier. This
>> way we don't need to update individual mm fields in dup_mmap() and
>> keep missing ones. Stop updating the 4 existing members (total_vm, data_vm,
>> exec_vm, stack_vm), as that is now no longer required.
>>
>> Keep releasing the parent's mmap_lock in dup_mmap(), before
>> userfaultfd completion, to avoid moving the userfaultfd handling into the
>> caller. This should get cleaned up later.
>>
>> Move uprobe_start_dup_mmap() to preserve the lock ordering.
>>
>> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>> Cc: stable@vger.kernel.org
>> Reported-by: Josef Bacik <josef@toxicpanda.com>
>> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> 
> FWIW, strictly speaking malloc() isn't usable in a forked
> (multi-threaded) child, but glibc/musl provide this in a best-effort way.

Yeah, I'm more concerned about other things that can race ... :)

-- 
Cheers,

David

