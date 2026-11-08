Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91297606BA68
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 20:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=drJI3pUc
Received: by kanga.kvack.org (Postfix)
	id CDD1D6B05B5; Sun,  8 Nov 2026 15:28:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CADE66B05B8; Sun,  8 Nov 2026 15:28:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF0966B05B5; Sun,  8 Nov 2026 15:28:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8CD3A6B05B5
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 15:28:10 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 08AA21A04F6
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:28:10 +0000 (UTC)
X-FDA: 85413088740.24.18D861B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6C530120008
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:28:08 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=drJI3pUc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794169688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5YaiTR6YvNrjuQTrS8BnXcbgh9AurDD3C2wJRI/aBVM=;
	b=D7cSiBkdE8qtzMNHc3FmkBgXFtvuspr9lJgJyrp2NR/8CrFaZ9FXxZqVEFqCWY68naHwAI
	wt/zigld82G/ydnf6SKYpyIteYgCegv1w7XAqAFlJx86lwILlM42m4H35PCIf5+eae2Djn
	jbDq3x8364AXe0N2PVSMDeXlUXiNBeg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=drJI3pUc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794169688;
	b=5d0c9TsH+bpoMXuwQIzq9sge9Uw/Z39UohZuL/TL4L4wdOXFkDnb0yd0Z/i0x2ntbyiI/y
	ebPBixbD/GqOGg1DLyokht9j19MypdyydElK5SUGBQH4AAhUGJ4xYd5cmXvOobtMIIKfm5
	ua4x6KXv2lZQBL654vUgyC2nMTH/UGA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E0F9061DCD;
	Sun,  8 Nov 2026 20:28:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61B2B1F008A6;
	Sun,  8 Nov 2026 20:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794169687;
	bh=5YaiTR6YvNrjuQTrS8BnXcbgh9AurDD3C2wJRI/aBVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=drJI3pUcu28AmbrSo8Vp2Ld0QhvA3rTIT70Q7TlkET+5DSFDiSPMy2kwY7h7E+hjp
	 3JZ8qRGYgwBa3/2PwT3JQ9jiN2GiESvI7N8pyEQ9fg4wQvdI0KK/t5Dnk1It2HouZU
	 Fzxd8qKTTtguL4YRPBf8GyZdMrm9bMeZ6sXbB9nMQxirougefh3pMwmPCinLYkPB1P
	 xMfKjDxcS/10JvYt55IS17I6ml3xRSxhOQvPwFj2KYqL8Hih6Fn0NxywxPxf1VFdEv
	 /lxa+zT5XQAkaaeE8mYSDdxC/b5an/LHIUv/1D+Kiplz16EH8Yg9cqLiBBtbdoSmfC
	 EqBEHhP3gIJ0g==
From: SJ Park <sj@kernel.org>
To: stable@vger.kernel.org
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6.1.y 1/2] mm/damon/core: skip applying scheme if region split for quota fails
Date: Sun,  8 Nov 2026 12:27:57 -0800
Message-ID: <20261108202759.117377-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261108202759.117377-1-sj@kernel.org>
References: <20261108202759.117377-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6C530120008
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: dq6ann3g1fpdp1ja69u1khqjxfp8yr53
X-HE-Tag: 1794169688-334762
X-HE-Meta: U2FsdGVkX1+7+1/Wt8P2H0l0yvaex7+HLPLEPVxOU5oYEbn4c9RAxcSLy+AJrC8bR0vqIUoqumVN3/xjK3EGVFLiHQCClJF+rr99/IVnD3yFP0Ywy6Xv2kTlN9cVbIa4I8HYgNWzNxsSJzfHBHzfJG0YIE4x+GZdUXa6LdGLyMN47pywsk6y++i7dzusCVazWVMf/4i5GE9KiMQxw+krUYEQrgd2O7MPMrURekDXgO32CCEsr9+gfsS0K6sesS4kDY//+iuCZMSUNATAf9pm5bR6APAGcUuStIXy9U/k+qEQlBHkAvPNH2G3jla93xo1dTAc3cciAiLYd9wVfp1bvldJOZo3In7MytMu2W1vIUMZPi7lJAb4bqqyhhcvNbtgiqbiUIH42IRwfNNClvhXUDq5c8SfkYQSHN9IKOgeMIwACUaEVwcO0CyEO2ivaUBoKevd9ox+3QraIHNCfDwf1UVeVxlm0suSy1IslGMlUPll36/GVbCLvdeUhLcgqa2HVAnRsPQ+KfO6+BiMjtiT5EzCjJrS5P2Y4J04nG7qo+pUf2cXIgVKJyvCPVjVwI/2iSn5EGmaKqLX/LLV9P77q7c6VNDbeB5CwUiAdQx8TbQ/DKaBcdJGS5qAKiUS5JNZkyiy25XZyaExlfLDuu96Nv+OMXz5dB7spPToS/X31uNVl/KZGX5XC+eDIInhAO51awrjgjmvxft10TSAvEgsGGToXObMKmuAPkE3rLsjD+j3uo2ervbljpkJGiRM/rSRIoLz3XqTRouY+mWHtFiaO58L9sAMhQNNzUzarGDHMf+8XtlhFib9iCoebdAx0hV34IUwncVWCUl8nGEA8Usm+R784GCa3JdD3sbeAwU3KcxUBFCijS0LQw0+702Ou8sIpEKvulORa/0tJAUZe1Cx6YacSNMi1/5JbODCWNECcYzpIwuXwG0/qUUjkc3VjdBAN5iOrX313/OT8SoWTgo
 0cxbyrrj
 2uJvty/SPsBjDUOzmr9isHuuDpb0gF1KjM/erAOPV5hGs44RjuD7qgnMqGqoUTBNl4hoXA+zWtj/CdDsVjMD1itprG4B1oKpuUlg0VnjFwhkYtQQy0XwKkLWBNs51w7HDTQJmkZGteXcXaFneezKf03IObD8UQN78ir1j6td/vD63yGRjQlXIh4C53/sZRn23CkPDQfYMrBroicbfxf56GAAOOtLb/o35Jj/5pb2Abafr6FhPGV8pBPHKYupk3G+/3CuNsMt/Bb/TPBlfQm/CYFRV172m/x8HZsFiJjY9FC/e9Owg4jBphvbMGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Patch series "mm/damon: fix DAMOS bugs in core, paddr and vaddr".

Fix misc bugs of DAMOS.  Patch 1 makes DAMOS less stress memory allocator
under extreme situation.  Patches 2 and 3 fix wrong folios walking in
DAMON_PADDR.  Patches 4 and 5 fix wrong folios walking in DAMON_VADDR.
Patches 6-8 handle extreme and unlikely memory situations that can cause
divide by zero and underflow.

All bugs are discovered by Sashiko.

This patch (of 8):

damos_apply_scheme() splits a region and apply the action to the subregion
if it is needed for not violating the quota.  The split operation
(damon_split_region_at()) could fail for allocation failure.  In the case,
the quota could be violated.  From the user's perspective, DAMOS becomes
more aggressive than expected under the extreme situation.  Handle the
failure.

The user impact is not critical.  The failure of damon_split_region_at()
is unlikely since it is arguably too small to fail.  Also DAMOS being
aggressive is limited to the single region.  Users can set min_nr_regions
to set the maximum size of each region.  If it is reasonably set, the
transient overhead shouldn't be critical.

The issue was discovered [1] by Sashiko.

6.1.y porting notes.  Modify damon_split_region_at() to return failures.
It is a part of commit c60874860762 ("mm/damon/core: handle region split
failure in apply_min_nr_regions()").  Without it, build fails.

Link: https://lore.kernel.org/20260901131850.98037-1-sj@kernel.org
Link: https://lore.kernel.org/20260901131850.98037-2-sj@kernel.org
Link: https://lore.kernel.org/20260718171523.87547-1-sj@kernel.org [1]
Fixes: 2b8a248d5873 ("mm/damon/schemes: implement size quota for schemes application speed control")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: <stable@vger.kernel.org> # 5.16.x
(cherry picked from commit 90c2fa6adfed7abe0935506a43cdff3a05c1fff0)
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index f0da5cb2b88a0..9206737d05ae7 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -718,7 +718,7 @@ static void kdamond_reset_aggregated(struct damon_ctx *c)
 	}
 }
 
-static void damon_split_region_at(struct damon_target *t,
+static int damon_split_region_at(struct damon_target *t,
 				  struct damon_region *r, unsigned long sz_r);
 
 static bool __damos_valid_target(struct damon_region *r, struct damos *s)
@@ -810,7 +810,8 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
 						DAMON_MIN_REGION);
 				if (!sz)
 					goto update_stat;
-				damon_split_region_at(t, r, sz);
+				if (damon_split_region_at(t, r, sz))
+					goto update_stat;
 			}
 			ktime_get_coarse_ts64(&begin);
 			sz_applied = c->ops.apply_scheme(c, t, r, s);
@@ -1015,15 +1016,17 @@ static void kdamond_merge_regions(struct damon_ctx *c, unsigned int threshold,
  *
  * r		the region to be split
  * sz_r		size of the first sub-region that will be made
+ *
+ * Return: 0 on success, negative error code otherwise.
  */
-static void damon_split_region_at(struct damon_target *t,
+static int damon_split_region_at(struct damon_target *t,
 				  struct damon_region *r, unsigned long sz_r)
 {
 	struct damon_region *new;
 
 	new = damon_new_region(r->ar.start + sz_r, r->ar.end);
 	if (!new)
-		return;
+		return -ENOMEM;
 
 	r->ar.end = new->ar.start;
 
@@ -1031,6 +1034,7 @@ static void damon_split_region_at(struct damon_target *t,
 	new->last_nr_accesses = r->last_nr_accesses;
 
 	damon_insert_region(new, r, damon_next_region(r), t);
+	return 0;
 }
 
 /* Split every region in the given target into 'nr_subs' regions */
-- 
2.47.3

