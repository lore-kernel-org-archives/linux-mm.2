Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52AEC606A331
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 21:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PGMr+Sv7
Received: by kanga.kvack.org (Postfix)
	id 382B16B05D8; Fri, 13 Nov 2026 16:47:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 359E96B05D9; Fri, 13 Nov 2026 16:47:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 249C16B05DA; Fri, 13 Nov 2026 16:47:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E30E46B05D8
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:47:51 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5B0A380156
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:47:51 +0000 (UTC)
X-FDA: 85431433542.23.C2EF5F6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 881D640007
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:47:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PGMr+Sv7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794606469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FTr0n6c29l3InOG/A3dk9VOH2uR0C7v9ShMZ2yynIoo=;
	b=V/wkJHMe919GJbud26djAWg2Ac/qKvqLue2a0XH1g1SlLngRBHPcu3sLbhZ8gmWzJhPXAy
	fH//1F9Iu8VNwFU5rL7V1PbRrHRw0DsC4dEyaM14JfLXodtRLGHsCi7+pT2cHxCIjK7HxO
	CbqCXjK+NN4cb2alZpjoR4tOBSYe0H0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PGMr+Sv7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794606469;
	b=ToF2nP3iMsHsOQUBoIbc7uawiF7OIvaUxrHl4Pp71L48MVzypurbHfqR+kRqMWH5z2W6bX
	ihz9fIPTkYYrNIl7ApAgqTJem/g4r3z+ikFqW5r4jVSHrPXSvnWADVdIOPCjtJAkd+asKw
	2FtxJoq8uoZL3rqComFbB895s86Vgq0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 29E6863516;
	Fri, 13 Nov 2026 21:47:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B23D1F000C4;
	Fri, 13 Nov 2026 21:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794606468;
	bh=FTr0n6c29l3InOG/A3dk9VOH2uR0C7v9ShMZ2yynIoo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PGMr+Sv7EKT07nEz9+xiAvd2xjXbw2gGgreuP2uxHhLFmrncYctNU0RdOvNWWZ6oJ
	 ZYu6/Qs7GEXrIuzVpn5qohKdIDVcuD4uoj+y2ONv+pNq74BS6go/1IbjyOpStAeUqG
	 RiGKryzWW+DylAag4v76099Dv75sFjorL8TWLmoQpr8jc90AuLcfhqW0MmF5KmSZmz
	 ow5VDD44nXB55deU738LYpqZOxYLRQCQnTkCntGoxD0OOZyV3k9B23fajP4/JEkihC
	 7ZIdYqrpmOfvGQu/DajITrN56yg6zO0YXw2V244DbW8IJb24JUYfeQX357Vp1fW5/f
	 HBhcITENOpPBw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 13 Nov 2026 21:45:31 +0000
Subject: [PATCH v2 13/13] percpu: queue the balance work on an unbound
 workqueue
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-mason-migrate-et-al-fixes-v2-13-50a2ed382b61@kernel.org>
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
In-Reply-To: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
To: David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
 Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>, 
 =?utf-8?q?J=C3=A9r=C3=B4me_Glisse?= <jglisse@redhat.com>, 
 Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
 Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, 
 Chris Mason <mason@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>, 
 Mark Brown <broonie@kernel.org>, 
 "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2547; i=ljs@kernel.org;
 h=from:subject:message-id; bh=MLkStZW7X9iFR6kCDpPJLu2W2JH8H1JWN4YejVC+cws=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK+t/xSnTCZx/uE9/Jt6v/TeHX8biz5lvzmrKXqRONNp
 0U7MtPudZSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAi3WGMDLtWaec127+d73tw
 07oz5uo6m8qzrdmbPY/zfDHy9fFobWX4xRzjV7gzvJ6xWJV/scB9FvMarcdM++OWP+SK1o981mr
 ABwA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 881D640007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: w1koymw96rjgamfk3kccha16fgcsyte7
X-HE-Tag: 1794606469-254491
X-HE-Meta: U2FsdGVkX1/34mKc6ygtmkjuaNfw9RCorntXObAurzWK3ob/eB6pHp9o9M20IVj237ycxY4hkMHsB68oDHpPAaCXjWk1ClMyTS0rSSYl1SAYI4qiqzoG4jPdG9cwIg0trD3keO4yfCLx/RCdGujNAnWfb9rFIc/xR/1NJsNsaqv1baqC3ulGTA9cSxtYyvUumSEFd4wS1BsLF5K/s7pbXufy9+dBAwciZkc5iJKtn8SRjIS4D4pvyMYdjXUIqVIMM/0f+HObCQDr5LLQ4O2D+s6s3TAe73DfFMAVnfOmAjfYpxxqbu9LZ6+8qBJWhrGhp5VU8EDsJTiUx9HTHWyptsZaW25eA0aZbEAaIgDCeNAX8xhcJa0Yxl33Xu9vp4GKeFQr+i/ycj5X78jedP7L6KRVLNOjsbQlsIVCJamscg0xajwaze3LpRzurYaPwzCw2f8Qy0M/8JRV8OSwl5XOb8jD0QAAxP0GiWXCQifSeQ6J+WR+dOzmq0Xvw6FUYn421Q76eWjc8HjTaNf4Vna5pYkY2UAXxYXO/97+NMFEnYvBKKm/eoxlNQjskBY4Q7iOy3m3KEpgBqGWCiTkNxsGnL3T1RrfE7TmqZcAa44gZ+LVGsJz9T1yh+Zt4IXPRpXEE791jfR75uP+OwsHUrb3uVrFg72NgR4WqE/F72rlRyZ5i4+wRcjuIyLGkk7BpCVG3leRis1NphNSH0TK1D3Odor04sJEnoyAGdSVLCmlP8aRdBaZxDzm99xzSkPse4SbYGr44w/P2daOqIEUoDXFRmTDDeJzEYy4wWQ6dIat+MTMng05jrKtEJRLkZxHwXgmd0Ugr4AqzZjobcD/miFz75m+IDK8cpU6R6NP739eZ++ObT6/05SWyLO6AR87BeudiZzwZ9lplQYcD8OXQjfrzHJCBM9pdhMVXaQ7xHvMnaePLWCX2NIWW+PnvtMB2aWHtww7RPOx3hb6h0uMg7D
 woYJucNy
 WZJN89AMHOhTxv+xfqIIccmCS15Fng9j02cq+/XtbW/Z7WI/ZXWvZ6fLVrWGkZUrsh+osVW0/30IjOIE3nu9TSCarJ3tAYP9Hyurb7N0pdNHOi7A74N5kTOSy/7kUF5iQcgDMPLcwcULQI7pPu/IMt+ONry3pkOMsrNcyFtCIKLLOBTzcL69TWvaq3tx9H2ZKbjHuubvhnYwqav2Q7dsAkkNNKeMVNo5CeKjS7SEo2sxG1ZcbgGccz93E7m0oDfC/+O9+oIpqfCeZUDKULllohYh3wD4s20O58XMwvHrad6tvX+qxMJUuVZCW7aXyKl00OgvAEqHo44weH7gDVCK0GgTUPFkeOsnkCzSaKKi+Hfa/DBgvXdJr7Z0Q5h+XNsarxMo5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

A burst of small atomic per-CPU allocations can fail with -ENOMEM while the
machine has free memory and idle CPUs, as atomic per-CPU allocations are
only served from pages that are already populated, and those can be used up
before a worker gets to populate more.

Consider:

    caller on CPU 1                     kworker bound to CPU 1
    ===============                     ======================
    allocates 8 bytes, which leaves
    one empty page and 4088 bytes
      schedule_work()                   woken, waits for CPU 1
    allocates 8 bytes, 1023 times
    next allocation: "no space left"
    gives up CPU 1                      populates pages

The allocator keeps a few empty populated pages in reserve, and the work
item pcpu_balance_work refills them.

pcpu_alloc_noprof() queues the work item using schedule_work(), so only a
worker bound to the CPU of the caller can run the work item.

The issue is that the caller keeps that CPU - a task keeps it for the rest
of its time slice, and a softirq keeps it until the softirq ends.

In that time the caller can use up the reserve, resulting in an atomic
per-CPU allocation failing.

Fix the issue by queueing the work item on an unbound workqueue so that
another CPU can populate pages while the caller keeps allocating.

Gregory Price hammered atomic per-CPU allocations from one CPU with
preemption disabled for about a second, with and without this series:

                           Before     After
    Successful allocs       1,188   131,072
    Failed allocs           4,097         0
    Balance worker runs         0       169
    Successful retries          0     4,096

Fixes: 1a4d76076cda ("percpu: implement asynchronous chunk population")
Signed-off-by: Chris Mason <mason@kernel.org>
[ ljs: tweaked commit message, comment ]
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/percpu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index f87813e6ad73..39cba1710383 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -200,8 +200,9 @@ static bool pcpu_atomic_alloc_failed;
 
 static void pcpu_schedule_balance_work(void)
 {
+	/* Unbound, so another CPU can populate pgs if caller keeps this one. */
 	if (pcpu_async_enabled)
-		schedule_work(&pcpu_balance_work);
+		queue_work(system_dfl_wq, &pcpu_balance_work);
 }
 
 /**

-- 
2.56.0


