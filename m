Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38002606A33B
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 19:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JTBMMTbL
Received: by kanga.kvack.org (Postfix)
	id E3C6C6B05C0; Sun,  8 Nov 2026 14:22:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDA616B05BF; Sun,  8 Nov 2026 14:22:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4CB16B05BE; Sun,  8 Nov 2026 14:22:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 005336B05BB
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 14:22:32 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 227E71C27B1
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:22:32 +0000 (UTC)
X-FDA: 85412923344.13.161642F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 654A4160003
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:22:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JTBMMTbL;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794165750;
	b=WLAIU0rr7xyUZUuoWwdiVMvJRnG0xUtw/2k0bh+S5py1uD3Vs5U2H/uaWtn6FljJzQLRO3
	j40z0CPmQLb+C9AN1JD3OcVZjAAy6C91ILdJwJ23JdJXHJShoD5NKpBEj1qY5bY8Fg5WEV
	sDQ8BGLT4MrpOPelWjclKiNhDFzgbO8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JTBMMTbL;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794165750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7xZ+n0JvDN3hrYenLHVXLkTjZ+lK0ATIB/YUR73+pmo=;
	b=hcr53r+14ja/HAW/SCY2L12kCpwpz8oTyyYh24iH0C3ObD6mjT+Tc5UEKrRCWYhsuJvU2C
	s0p1OoNmhJAlrSQP3GDCDFowLvdqNpO8PgP54fLuX0SGQz+w2mnO5UhtpjoQJGbZrC2zqh
	/+x2zTav947xCFBDMj69/jldTvsk/CA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 954B7434D4;
	Sun,  8 Nov 2026 19:22:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A2B1F008A1;
	Sun,  8 Nov 2026 19:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794165749;
	bh=7xZ+n0JvDN3hrYenLHVXLkTjZ+lK0ATIB/YUR73+pmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JTBMMTbLmUld9NcT0MS7oZ0BCP8jdLSQulpaGGpnXINKh66sW+/iol7TkF1T3exKz
	 //Fu+UMBhlvYt1A50YESr532I14L6CUWHmrZvYGcCqIakeRopKz4ruUtOaUIePHsU3
	 zc2c4mO3304UNg4o4VPPoGSfXBdvgARmm9JkH6Eu+TwQpTPbizhqCl45na1haSDuL/
	 TVvif5LeaTXjBL0UllBP56f7WUpx3dWIpGomfHPj+alf7ack/dgXtu8h84cKRE8WWF
	 7Vf7z4Er4lsuS6v9sa3ap3lSh9J1SHclSLbIgXTq60u/pSz9VBkUYghIJiuWoCj8wd
	 HTA2n9CUrAFXg==
From: SJ Park <sj@kernel.org>
To: stable@vger.kernel.org
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6.18.y 1/5] mm/damon/core: skip applying scheme if region split for quota fails
Date: Sun,  8 Nov 2026 11:22:16 -0800
Message-ID: <20261108192221.114362-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261108192221.114362-1-sj@kernel.org>
References: <20261108192221.114362-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: camst3ggr1id3tfmwhkrmh7j39cdh36d
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 654A4160003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794165750-210397
X-HE-Meta: U2FsdGVkX19IPVI57zGWZzCu4+2psSgjLzFDUToM/6O85rKQjr67VLcI8vhyjJwMfzzUruT/cgsxO2cf/3kXa+3k/xzPzP2PdkE6PV24gKHPitcJ3FIU6Ni4xZbrwx7wWMwVQJNGnIqmNsWtgZhEWm4KLm2DFjP5uPi6w3kvtGeHgoeJ4F5dv0yGDebfOw0TlAuMgSFie+AZ6KkcvHdp71EKxvm1n00p9RsFHn0+GxE/VEV3QD1mSMZtWLmwODVGj9pJO8X6jB/unIBFLTbVRx0nwRQI4g0xC96kx03CEOq4btW7wCyVig4LOV9b9IAbRWBHAQH9KjEppz5hGVBjnxbYgCWHFm60pr3L+JZ578GHZv0fLr4+5CqaPehbUb23xROWXV3McKQ8Tq7wqqmFOqny+52MEpnpM0naWZ7oWQJkccv1ShzO4K9iSK07G9flOci2tgXETjbYxZbwe87gEdKrsPhwTn2slNboVgvna5RaYfbniY+Gn/ImYWRNW1MA2AfxZftHV+3gqR2aH0Jv4paYPiuQrDvt4fY7M1WgSFwXB71dpn/jGBV9UC1qys2Dh5n9X+BxMGdNpk28UxqA3nkd1epS6Vto+JG8vFKM57ko5tYTWLJSFmv4pQsQ27mGWtby0GsGWyaG9w2wI7Iq2K/Z0E7yD3xQzwgesmQ9n0oPvNb6hn0kWt6C+A6anvu05HuqkKGjvP/sBH58Fs7l5XUlKeCB/rw7/GDEjJdUSEVN4fO+YdBTs0ROM9z/aBysHbBKRLOJ1N67Lc8wvzRovi+a6813X7r5d6yo8EEpwWPmzy511sYUjm2AUTylPKlu84lOqCFY58c5oDdLcJO4K47K7R9XnemjL2gjyWeSC36cw26O54mMWMbWpHKHuYz4N7h4JAsNTGrb+jjGr91tUeUn3gAgTbSQ2s9dklyVYKb8Phylho9dB9pLUfuvtb97IyV8Ccl/Q8aIW+M5Id4
 Qz19PFdT
 /kfF9dD2evx92zNgXBF+N6zP3I2fCQu9QRkyZn0UEzzwy0qf+F19R3McBcEDY6np5kvlqzf2HmC4FcIncfmXMTxdp63+h17dz4P0HELuFtc/OQhYz3MIezgLrIQQ0nBVRrfTGM6w3oMvLibAfJxVIaCgybwUkacgtOgW9IcDqRd/5UOkdrgvil+PGeeLlGMt3xUEsb2mzmWgsf+IM9SSAKVEShoV7Pj6mDrJ96JMIgNTlHOvZSFn9iq86TEq+vSIspxyhUQXSfNYJ90uj6Hb8aazlK7E5i+jqsQHXHIyVd9EqyamoEIwzRfSZhg==
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

6.18.y porting notes.  Modify damon_split_region_at() to return
failures.  It is a part of commit c60874860762 ("mm/damon/core: handle
region split failure in apply_min_nr_regions()").  Without it, build
fails.

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
index 8fa788b0d709c..4c536a9b958e4 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1700,7 +1700,7 @@ static void kdamond_tune_intervals(struct damon_ctx *c)
 	damon_set_attrs(c, &new_attrs);
 }
 
-static void damon_split_region_at(struct damon_target *t,
+static int damon_split_region_at(struct damon_target *t,
 				  struct damon_region *r, unsigned long sz_r);
 
 static bool __damos_valid_target(struct damon_region *r, struct damos *s)
@@ -2000,7 +2000,8 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 					c->min_sz_region);
 			if (!sz)
 				goto update_stat;
-			damon_split_region_at(t, r, sz);
+			if (damon_split_region_at(t, r, sz))
+				goto update_stat;
 		}
 		if (damos_filter_out(c, t, r, s))
 			return;
@@ -2454,15 +2455,17 @@ static void kdamond_merge_regions(struct damon_ctx *c, unsigned int threshold,
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
 
@@ -2472,6 +2475,7 @@ static void damon_split_region_at(struct damon_target *t,
 	new->nr_accesses = r->nr_accesses;
 
 	damon_insert_region(new, r, damon_next_region(r), t);
+	return 0;
 }
 
 /* Split every region in the given target into 'nr_subs' regions */
-- 
2.47.3

