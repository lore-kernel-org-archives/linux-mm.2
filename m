Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B964E606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 05:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=JH6bewnE
Received: by kanga.kvack.org (Postfix)
	id 4E8E76B05CB; Tue, 27 Oct 2026 01:10:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C5866B05CD; Tue, 27 Oct 2026 01:10:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 362E36B05CE; Tue, 27 Oct 2026 01:10:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0B10F6B05CB
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 01:10:31 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 949E11A05C5
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 05:10:30 +0000 (UTC)
X-FDA: 85367230620.26.25E1750
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf09.hostedemail.com (Postfix) with ESMTP id A6B4F140006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 05:10:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=JH6bewnE;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.208.44 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793077828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U8c13Ig6MUdyuuVgJ6RNI7ksV9FwtObecf4rW8b7B7Y=;
	b=0Ed/Aa9XAdwYaEyiCX8EtnqJAFAyOpTpXPBouhzBjSBuv1emD2CItKMXFs/YNX8JbSY37T
	RPID9EhV0oyQ52Y8wJLz3kFrjmu+31RxG6zKwldQ9yE+Jm4CQ+tHLtw3SKPmuAF3XfxvIC
	ynBJiblpxtgJqydcWpZJkCKBvEDNt+M=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=JH6bewnE;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.208.44 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793077828;
	b=ZDp2vQnNo7ddEItAV9Xwxr0AqsckDWiaCHkmbxEm3+SSDM9ekVrx6nTXWzhVgmQ2q9s+I6
	mV7zJbMrdTbc2LhpPiNAgS7g5+7fHATnkBgIRuytWoHFGWMIUsquRoACz0Pjvqumn9soh3
	a9SRAC4vqMEI1EfEoUsS8M+5lss3Mmk=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6acb57c2b88so4352042a12.2
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793077827; x=1793682627; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=U8c13Ig6MUdyuuVgJ6RNI7ksV9FwtObecf4rW8b7B7Y=;
        b=JH6bewnEQ2WGthgIOYpDS6zqoEDFDJ3sXh3f5BfZMpJZz6WFhlVr7b+CyhnhQbkb1V
         ZyDVf7tIUxk8cGgpEpSp6f0BcbxYG648BYNinF+AMF7yDuzKh2rDU4rD3qtKbCgblYIw
         f9LaTcFVLbxb/aBHq29+2f2FB8tokyPntrl1APs1GWfpOqU6nU6SVZI2ySKcDLnaLCxE
         U3PbGB5nQwvWirsGfTnce7mkCAw0yXVHSf1xGoNIewaiIXzVjG59QRsyFnkCkiTrErks
         9QkU3Z3NhC06vonAWEw7fzE/Oep6E60d831+xvmOVhPQk2c8/bTnLsPctmI6fYedoghc
         rVaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793077827; x=1793682627;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=U8c13Ig6MUdyuuVgJ6RNI7ksV9FwtObecf4rW8b7B7Y=;
        b=oA+bxImAQm7gXjuTHL1ZCs1vlt3Q4ENT/QEu4J3cqJg/AGuHg//0re7IUZR2lZUmkq
         qELIIhNb4WNeI/7s7A1FUct2ZdBuVN/fiPqOeL2l8yu/dF0hPr1VL7J2BIDzZ3PtIqQi
         5kNTUMRzqthpxfK3ygNSDnLW9LM6O0vFWoy5PZu+sp4RsHhEM0OGHCykOObS6gK7xgte
         nff/46E7oWqNPH++WKIN9CyBKjmva+kVbvABzlUWnresNKPtkiqqYQezvHeSTpQ2U2vU
         A2tDwZHjc6tVm4oingFkcJAy4yp+AM0FozznZGr4ElmNZa2ZsAVdgUadzMT2BQCQTelo
         WyIQ==
X-Forwarded-Encrypted: i=1; AKwUvByuLI/GOwMEy9yMXQPdBboTqYkd/c8+FId99pfj4WmPDeQS7NPZCb7qDezncucR95bRXH9A5UBkBg==@kvack.org
X-Gm-Message-State: AFq9FYIvnQZmnS7A5k78p5Xa+/wdfDsSW7VCk2xZa2P5K2SXCxgSysJv
	Xr39ymxg39X4LXT7WKXJlfbEORl2UjSjXoWDEkoYcPUXBs4Ox9wdH6Tw0QjagYoDb7Q=
X-Gm-Gg: AYBFou0GzEO6NNgoxHOaGhITPsjJO3yHLwMsxF4M7pysGWCluGUnpCnib7CWW7z+mSK
	xe++LhTo9JYYhAIfTH5riudcYYHyarsVuGMgKexGn+R0a7BfeySLNIj6zh7Bm6rLncaxYPgM0vG
	OIEamaD9j4CdhxDhgrOwP7Su0AGIez+fPE4a33Txik0NJ2fNTGBi69Da1FBGIjSnURL/8ix3T/i
	kX6WRi9SrFZ3k02ZjvDRhr8J2Ih0w4Sq4XZNL+cG/kZyx1IOWrBdi9V9hN5SXBAMxSbYSQEe9H3
	U8wBtNj9wEf6urx4j+Aw/MWB1BFFcZboMmCOQyB00pXqT73dHOYAspsOQwZSBFkswiD1pnFD7HF
	xdQJz2pcIByllBouBJg8rPKj1yQx9dEf5opsYMTCmK8LTnNytx2waxSHO8OEfjbGvnVlXFKDpvJ
	Ki2oqhUfimuwJZgZBk0eO3cD3gZ4KIRZsfkIqQRDLR47yT/Z7c0AQ19Dd99vg6hFSHF7X/QEOTF
	+D++PfT3ELyoE06nhoa8feTLxJD5pXZNo8La5BbuEg=
X-Received: by 2002:aa7:d642:0:b0:6af:80c4:8981 with SMTP id 4fb4d7f45d1cf-6b443001da4mr6849436a12.26.1793077826967;
        Mon, 26 Oct 2026 22:10:26 -0700 (PDT)
Received: from localhost ([2a03:2880:32ff::])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b445984d85sm4571938a12.29.2026.10.26.22.10.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 22:10:25 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 25/46] mm/userfaultfd: wake waiters when registration
 modes are removed
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
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
 Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, 
 linux-cxl@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <20261027-fixes_core-v1-25-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-25-6f74bec9a5bb@kernel.org>
Date: Mon, 26 Oct 2026 22:10:24 -0700
Message-Id: <179307782442.2301705.17273288326330283268.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: A6B4F140006
X-Stat-Signature: mctyhs46u9jkj1y75o1pko745eoa1xn5
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793077828-798860
X-HE-Meta: U2FsdGVkX1+rku/dBE79wCkOThffT72TvNywoUFsIkv2WjjUo0gnXOjp/PnUBJ+XxufUkYC7y6K9u8ZBXj4NteuWgC4ZtNqBPVJtpBpz3nqE0a2zl7wjvI6e02wEk6gjckWtrNUVB6f6XilllCXmXhNIp4rWRREPK4wa1Ia+QUOy/vQxDV1C7+sfAsvNboI3YvHJuubcCO8KLTvMU2GhD2AYTVBUwBBhN8zGNpOwyQeGgGopvaZ/n9s9pXov1jCupoucECah2V8GhBc0YsBv4cyMrlAytEcYsCZlEYm3fPMfvO94aVxRdfqkRonEPYMgixaCDzZA7yg3/q8HKc4Sekirn/2rH3Bm7cRrdJM7xRpCmhQx71IQXB32UElHamrGT+fgYraal2qukDeMWRe5OJRbDiouV5Axtxg7GzFQJmpSQbu+P34OUzhVUdn/h6+tE+0x9+hlo3uK3/IjqkEuuCBCsyk40uk9ZvcGqQ8wCEFaVfw96Bi8cURJO01niDwn5xDHF2FoYCXEtCTKlfxy8L9JWK5/WoK/15biOQk1SWpS3uLT1TMk/DIYJAB+5kgO+5mImmuPJTerAOamEUMj4+haKRk+4ZixQng0NcLuDK0/xMdwZy/DkFWY9MuZtOJtcN2aH6c5mbE9e5EWxiClN0g7GACq1wmyf0wqW3OpQWRyJUbwUSCkRax62FRBrXieuXiWsXppoK4d9wk3+eniRPf7GBt5PE7f5/4aZU1xLXbpO6DcKaVIRdr7z+x8k0gFKgLMtTBNwnvqMmy1/c8yvn7/uVq/7ZS40Z1EMUTWZJfMvexfRVR128cutghdaSHKopBefzhEZ7VFDdur9C3hY3pEWWz19SF1zt4KUFLW8aJFYIbBNnm5KpgopebZyAFGwlyqWwP/Qq1QMV6PWHaMMaKuw0dWdMzfnt2LT62/93Sgw38+FqweOfKlw0UeVDX6bREA4NIRoSaCbAMfpvG
 V6pTru9Q
 fgDCbXZQj5z5sx9+jCbOhmC5z3yKQvIoiErlByEVfMiWWXf/tWEf7104g7yqQf5BIYcw5cyMlTEpPkaMfp/FDWlwcieNvbLqbdXdZD4MlWWwLGm4xJ7xVQETQckGI9dWjqT3pqps8xYGJez534Ct4omJREVLkqKUCzL9snDd9m9UME0hinZPiKW5KoC1cLzuTx2BcnvaXQWIcfOxZWE2VZUtPOyLzKKt43bo+YB1CGguUB9LTzaIngNHotiJu6F215CaloKRebFhfXG3vYQQTAF3Cyv6l4m/Vn5rkOZD356Afa4XW3iT41FsTeOtBOhacN8SoqIH9BmJfEtuinHCNHB6lP2ahodpVsiCYvaYdfjpLuTg3b/mVRnLfdeiB3RwuvMeEwkMSlkABfZI02BxqDZ7PdxXC4D3WbmlOYJUH8XPGxfKgMPjUl2lk+xC/rCLEAIiQpxDd2q0BHH//JxrdKkPkoxhclIt++oWTi2bj9wZQtokoJXJHIG6Y5A/EGXJ7VV155uvaBX5fkK+F3cgMMX9NmW8QdpwaEd5f2lERxUf+QP74BL/z/KqAWBdYBRMt5331
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-27 00:17 +0100, David Hildenbrand (Arm) wrote:
> UFFDIO_REGISTER can replace MISSING or MINOR tracking without waking
> faults that are already queued. For example, switching an anonymous
> range from MISSING to WP leaves a missing-fault waiter asleep until
> userspace explicitly wakes it.
> 
> When a registration change removes a UFFD mode, wake waiters in the
> affected interval after updating the VMA. The VMA is write-locked at
> this point, so no new faults can queue under the old modes and woken
> threads cannot retry until mmap_write_unlock(). Waiters for retained
> modes in the same interval may also wake and refault.
> 
> The hang reproduces for MISSING-to-WP and MINOR-to-MISSING transitions,
> with both read and unread fault events.
> 
> Fixes: 63b2d4174c4a ("userfaultfd: wp: add the writeprotect API to userfaultfd ioctl")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>

Two additional automated reviews independently confirmed a similar
pre-existing issue and generated the same patch (below).

Sashiko filed this as a pre-existing:
https://sashiko.dev/#/map/217050

But this seems directly related to your patch here, so it might be worth
squashing this in:

> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 2122676c4220f..710e913c73bfa 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c

[ ... ]

> @@ -2287,6 +2290,8 @@ static int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
> 		prev = vma;
> 
> 	for_each_vma_range(vmi, vma, end) {
> +		const bool any_mode_removed = vma->vm_flags & __VM_UFFD_FLAGS & ~vm_flags;
> +
> 		cond_resched();
> 
> 		VM_WARN_ON_ONCE(!vma_can_userfault(vma, vm_flags, wp_async));

Could the pre-existing no-op check also require an exact mode match?
It currently does this later in userfaultfd_register_range():

        if (vma->vm_userfaultfd_ctx.ctx == ctx &&
            vma_test_all_mask(vma, vma_flags))
                goto skip;

Registering MISSING|WP, then requesting WP alone, takes this branch.
It leaves missing tracking enabled and bypasses the new wake. A writer
started after the replacement ioctl returns still queues a missing fault.
A writer already waiting before replacement also stays asleep.

Both cases time out on the base and on the full series. Replacing the
predicate with

        (vma->vm_flags & __VM_UFFD_FLAGS) == vm_flags

makes both pass with this series. On the base that change fixes only the
fresh-fault case; the already-pending case still needs this patch's wake.
Would a separate fix for the mode comparison make sense alongside this
patch? This is not introduced by the series.

-- >8 --
From: Gregory Price <gourry@gourry.net>
Subject: [PATCH] mm/userfaultfd: compare exact registration modes before skipping

Changing registration from MISSING|WP to WP returns success but leaves
MISSING enabled. The no-op check sees that WP is already set and skips
the update, so later accesses to missing pages still wait for userspace.

Skip the update only when the current and requested UFFD modes match
exactly.

Fixes: 63b2d4174c4a ("userfaultfd: wp: add the writeprotect API to userfaultfd ioctl")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/userfaultfd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 669f71d485d02..0a28130cebc99 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2299,7 +2299,7 @@ static int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
 		 * userfaultfd and with the right tracking mode too.
 		 */
 		if (vma->vm_userfaultfd_ctx.ctx == ctx &&
-		    vma_test_all_mask(vma, vma_flags))
+		    (vma->vm_flags & __VM_UFFD_FLAGS) == vm_flags)
 			goto skip;
 
 		/*

-- 
Gregory Price <gourry@gourry.net>

