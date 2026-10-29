Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68119606A324
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B+gNQr3I
Received: by kanga.kvack.org (Postfix)
	id 8B2ED6B05D7; Thu, 29 Oct 2026 16:39:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88A986B05D8; Thu, 29 Oct 2026 16:39:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 779956B05D9; Thu, 29 Oct 2026 16:39:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 584D76B05D7
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:39:57 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A846E1A04C6
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:39:56 +0000 (UTC)
X-FDA: 85376830392.25.2EA0E29
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id EA50A40007
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:39:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B+gNQr3I;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793306394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kUEfRiVPdPCg2/KqbNX9PPOiFF/eP69nxT6xONTBQFk=;
	b=fGyPFIVdPcmqaOwgda35mAodtaOE6qsPkthfMHiX9+sczH1JCq+3CzaudM8a9RVLhTYUNj
	TumPHlZrvL16Ns8pXUFW9ALFxFz8QJVq8TytBBsz6y5d7VR3mTwd6vGkhfdMe1EzEQbJy0
	bs7XB4zNJZanZoNFxzJT2KvvE9UBVJc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793306394;
	b=JqyzUXTbFKfzyD4rdbggrfksjrv9VM0mZtspcNn+mzHftgSqEvAibtFuKmmxdthNxCSFQx
	nzL0xfKwb4vhNDc71zw7ufsK4nge/LhatEpK0+9YPPED7MKtld1N8EtrVfx1P1FfqKzuQp
	NYkJwJ9QUpw7r0sgzrVq6tGkpi8JEvo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B+gNQr3I;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8334160629;
	Thu, 29 Oct 2026 20:39:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CA2A1F01824;
	Thu, 29 Oct 2026 20:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793306394;
	bh=kUEfRiVPdPCg2/KqbNX9PPOiFF/eP69nxT6xONTBQFk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=B+gNQr3IgYPjaHbppcw9o3+A/kH5KGFoMEXaT3pmXT0FTMtlv+J0pbqsgNG8qOKhI
	 EzZv32DWC5UMbUTC6nahg8i99r8SlIDGC3mhtb/aPJleJt9pQnXfM7DC3eqXrVeT7x
	 EdKUlx6xc9n+S59O83153Y6MLC9vkrBo3YohvFsMgyPF2XXX8arnY4I/NzKyuM/JEz
	 3ygSXzPCjFoKhHuKLnRUhILHFjQnmeRktJ+2iXs0kQOeWBYEibfl7ylO2Cg8X4ctvj
	 stH0v8Jp4kfpNdJepSKPR7w68ibQTVHXls/i3r3UYfHi7GEl6lgKmrtsNLIYxmrLpp
	 X+MiazDsOENog==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 21:33:21 +0100
Subject: [PATCH v2 26/47] mm/userfaultfd: compare exact registration modes
 before skipping
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_core-v2-26-a64ce7f83abb@kernel.org>
References: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
In-Reply-To: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
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
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, 
 stable@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1463; i=david@kernel.org;
 h=from:subject:message-id; bh=EB1on15q6q+0KCAB0yKS0tRudcnaZpRwYV9wTcssTD0=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIer203CXiXELbMN4o57IvJUo3yzuqG+rPOik++eEpsO
 TjZ80ZFRykLgxgHg6yYIktQ8H2Dly/X1Va78THDzGFlAhnCwMUpABNZu4PhfzavpnbcmeVGF7QM
 sr8/+8rw5RZPRxITd/OkpnP6gn7Fcxj+e2b1ZInfnHld9ZtWi3l+277N38xu99RKLNbot+cSfFn
 GDAA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EA50A40007
X-Stat-Signature: tb9ncu8ngen9gxt6w55qsu1g5zwb5ggt
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793306394-623571
X-HE-Meta: U2FsdGVkX191rMfqeQ334racUy9aqrfXJbMH0WTc8U18/3LAhlM73QCrqOMaSqX44nT77ZAZNBpk0OAav58i+2feFFGk/iUUEyXwfogB+3RionLQ8SyMkjhyd9X8Ur9g24SXx52ZASIRh/bgXa0oa1nl31Y6aFdnyRcoMjyxtVcInLrKaO0hP1+5eC47hX1fRo+rLwFa+Y0L4dtCCgsfh0zXLmYqeCgFKr6BwyuQfuqZ0yudTMg0d0wtx0vgDns8pqzoa3wtBEmrqn/ZCwp/JMRTzMXsurgyFFWmpqtjhYHZop1/tnI6LQknckUl49cxQfRETbZYpgZK9vxLHR6/SeFHp+GujS2DzOrKOm6yXJP9M+/FvbuQehKqHOe6WYkaZ3zTrUc5WWKbOQC8M2CUJnqaSyrFIbSOHJ3cPKNUv+D9hD6Z82iIWEpfxquXeFDotHTUqbmxwdRbQQAFBPZ0mouLxEQNasMBZcPG+m9khf5b8yqVZQQ3jMRxHaOGkBk4vhTJO7VQznn5oJRMnWKycy3bJiMEA5sYbUMXHLgvKV3M6sdMeNBDPWRv9f3PgVxeJaNAwtKfdyBVYD7/FAju0bsaO/CLbWsqCywKBq/qZdN/76SxwQIjiYYVpXcivakchA5U3Gppu83xqMatt2nwqw14MVRXLXmKHO9TeQB/1+ddVI2XKYRpHFEEeNYxlKX5FtrK9oV4TjQ5osn+btXI1Bl0tw9K3nIHf7mRQYC5d7IrsG2xw8UoMmgKJ9jm10hmr0ENYW938wEJkMPp1FF57sMeItqkbdditt9+oDokwOOCKvRkq9lO9FtdJLgRxfEHbXp5YQkBVzIQcNz/8RBT4y7pPfCZyQn60wSfiLOq2+Zt8uLT82Dslh5vaFxpgGHgl6YWE+HHWwrvXrE+k6qcViE+BPBI6bWNZSlNpi19L+aCBoC9u4aLHc8wrxlyyd0Yp8W5oASlapVW7fK6xAh
 1lcdzubt
 O3u07+WHfSAE/GF+o4zMywB6ftG0VaO6cjKzjQNphn8pkj8HMUi8gq5seDiuf59qxNgLrgJc/OGpN/xTgTwwW7aL69TlX+BN40iVS35KM7TKCtbgSQhqz10If4Rtmo4ylkBiAGXBpbqdA2+/yjw4xHItGpA6JLF/gxUtt0LIM55YCbDWaChp53arJLmG2uHhg2o2Ud2UDHwm/kXmsyU8gZ4+VcT9/fY2rkVU+ZFDEARGxLAcGQ6fRuZlUWoyPSSYNOjHw+lqi5LQwBFHRC5AEtwc1wYu3peSZzQf4SJgQ/L+avQA/oqkI/zf3amHvSycmZVTDzutMKGBERbWgxn6K9zBuUJNXDKIIvPPGlXi+4n2xSEvw8mzvD90TD5/qf5eE5CvvxTvQ+rpb0P4/UnV8bt7GF/BnMvJJmvrOORsISExK6eI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Gregory Price <gourry@gourry.net>

Changing registration from MISSING|WP to WP returns success but leaves
MISSING enabled. The no-op check sees that WP is already set and skips
the update, so later accesses to missing pages still wait for userspace.

Skip the update only when the current and requested UFFD modes match
exactly.

Fixes: 63b2d4174c4a ("userfaultfd: wp: add the writeprotect API to userfaultfd ioctl")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
[ david: apply fixup from Lorenzo ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/userfaultfd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 03f1b15bfe63..dac696bda19f 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2291,6 +2291,7 @@ static int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
 
 	for_each_vma_range(vmi, vma, end) {
 		const bool any_mode_removed = vma->vm_flags & __VM_UFFD_FLAGS & ~vm_flags;
+		const vma_flags_t curr_vma_flags = vma_flags_and_mask(&vma->flags, __VMA_UFFD_FLAGS);
 
 		cond_resched();
 
@@ -2304,7 +2305,7 @@ static int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
 		 * userfaultfd and with the right tracking mode too.
 		 */
 		if (vma->vm_userfaultfd_ctx.ctx == ctx &&
-		    vma_test_all_mask(vma, vma_flags))
+		    vma_flags_same_pair(&curr_vma_flags, &vma_flags))
 			goto skip;
 
 		/*

-- 
2.43.0


