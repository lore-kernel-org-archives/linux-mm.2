Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41DEB606A31D
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 13:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ONahoAZC
Received: by kanga.kvack.org (Postfix)
	id 5DFBE6B05B2; Thu, 29 Oct 2026 09:31:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 590EA6B05B3; Thu, 29 Oct 2026 09:31:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 480226B05B4; Thu, 29 Oct 2026 09:31:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 265FD6B05B2
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:31:35 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B13111603DD
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:31:34 +0000 (UTC)
X-FDA: 85375750908.16.ED425E4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id E2407100003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:31:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ONahoAZC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793280693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=N9FnodYZ3kBJhwYghvxHoiPkxtwL/OpTE20Oa6bvLyI=;
	b=UwvLOjLIp+/CKdpUmm+DfxIIRzdF/N9oAJySDbRwXP4OpzWoQGSvEznw2ev6r81sdyKgXt
	6uzQSaTMpDWyeNoHyJk4rnEMWfgYx9c3GLm2E/U5lVUpv7tigNUsgur2RFHLxIykQZKbD1
	EpbxDflCHBrV94zMa26tO60QR5wiVUk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ONahoAZC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793280693;
	b=1xnj5Y4rR++wrQQXtzWO2WOekSqlHunRRU2SyDO1uC0Gur2oUqZZJte05bc/pPD0vjhM++
	9lpKw4kSYLHdvhbiZxevBULAI527AZYKNJyEUmccS+W1BXKYUCRSWLFWF3Se7Iv8D5AZZO
	u7ZNmrTavD7uiI+tHG5XA+PCZE/64Hk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D024C43E9A;
	Thu, 29 Oct 2026 13:31:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A591F01825;
	Thu, 29 Oct 2026 13:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793280691;
	bh=N9FnodYZ3kBJhwYghvxHoiPkxtwL/OpTE20Oa6bvLyI=;
	h=From:Date:Subject:To:Cc;
	b=ONahoAZCw2KJ4Ip3+oj3Vc82Z4vcxvJd7E5UWHxMmHv9YcY/XTkQOH2H1Be1hopK3
	 ZIOznH/netbMBoS/abeX/4nSmNGOEM95BurjlY4RDXEXJKZq3zNN9v7qXiuUZB+BJI
	 hZiG/9OAg/REp6IIZzU5TU+F0PjCHdz1E8gpG06IvM4xjLSQnEHB0SjgwMK9gdutpF
	 rhQ51BnU54FBo3P5Lbwd18qMF3TBzR751uFxu29FuJtreV+XTwf2TMzLoHGDMwq5+u
	 MMdXXTThHYdmtYWkIebO3Ic4X/prC3B9AKqipsKgULC4Hhq8BPt9Ou/XldNwanD3mx
	 BBzKsO7dIzTyQ==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 14:31:24 +0100
Subject: [PATCH RFC] fs: defer reclaim of inodes with I_METADATA_WRITEBACK
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-work-inode-metadata_writeback-deferred-v1-1-7e49f6c12b60@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/2XNQQrCMBAF0KuUWZvQhlKpW8EDuBWRSTK1sZjKJ
 Fqh9O4mFVcu/2f+vBkCsaMAu2IGppcLbvQpVJsCTI/+SsLZlEGVqqlK1Ypp5EE4P1oSd4poMeJ
 lYhdJoxmEpY6YyYq27rZVY3WtWoT07MHUufcKneB42MP5W4anvpGJmchnGgMJzehNn6uMyRWT/
 5j8YTKvYFk+pzWGys0AAAA=
X-Change-ID: 20261029-work-inode-metadata_writeback-deferred-94f716db429a
To: linux-fsdevel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Andreas Gruenbacher <agruenba@redhat.com>, 
 Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2906; i=brauner@kernel.org;
 h=from:subject:message-id; bh=l6UGRopzhmtN4DdQ66yhkoqkIV31utyxLuAkS4gfbXw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ99lrvoNhbZZ9ns3/vj8NbrxzZvfLEgRb+d0u+iGjac
 p+d959nXUcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBExNQZ/pc4t35s7lj77dei
 nUpiHBNlFyis8lRa4afCIuMkk7go4gvD//TcLfe8Vub1ndLXEFnkJKndyhT+r65jec3Np5uTjV7
 3MQEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E2407100003
X-Stat-Signature: b9uqoarpbsuh7qmi19heoposxbhti14y
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793280692-29511
X-HE-Meta: U2FsdGVkX1+xS5yYS6ljHmRKMeBVCk6OcGF+yOZTIJkb5sHlL+E+cTTqIVhXYog/zJ+rfFS1/suagWPo1IAKz1Rg3ncVjSAQQSRqQ8pS/gw1wpQgmDmemU+B72TPr3KSGZ22PM+n9u53bcY/41HggTaEle+v8sYjtiNaGjF/hR9PCIyXhPBdtWhRfGyplYH22S3wB7SBW4pO4hYAKpv+8eKi8mxA4AH6RLtCYFCso/icQMJtnMQB6ymWlHwHBvANqgu2Fplan5rnBkqEL9Zb3kJ5TlrLZJXWLCHmsWvy3OwTikN2wlZ1AZ4OWSByahfUvRRqxDy9cppWJjaA84OMsVSWTS9ZXDpb5ub6ey7DoQJSs+e/9n53wqZdLjs5U0O/DQRm/tKwCP6vnNZWeWpU1uxSEDWCBwsG3UKgkDe8Sj3jItHoLCqazQKc59vspeP/8FhKu/noLEkPgIdR0v3nxNBTWjnjM4mkR2fuyhGWIFEvjODVv/OFFryxtBmEZYf2VjXQmG1atD3h33Su1UFqfqRuoWDqLfRQdOoly4P3DksATOLw41BCO4wgMykQTPygsjWdeOKhRMh6Ga6dczGNe4+Vh6t27JNsTgLpbowQeJrnMhAB5m969iaNs6llRVANMBDijqtm9bjxNXWy1iHf+GxoMqNLNUQJGGnIAHoM1U5Uxa5OV8uvzGcMhMfXCdTsVfwDTrJB+ukEFLtJAJVTdnh92uO9tUVON1dSMwLi4ilkoOaQfvRXiAeA/nqZuKAAtDotMpfx6uobWQOVTroHhHs979+wP1n42Tx1ZHh+/4d9DEOsP/Tz6+cPrWj8MnSnAcI4182j8AZs8vcOnD5hIc6+8+zbHvLmXH8cX28nCogS0EN6tgGpgIkDE7Fac0eWGbgLsGvq0qKgvhC4ZQ/fjgP2NehKw3DDnLsmSEZ+Z6JRMnUqbwsg7R3/w97lm7xVtJnls/8aIlew+ehT7Ur
 duA/57rj
 Z/Ty/oITL3qOO0WNQGRDzscifcvIFL+8xDLI3jW/HCamm2wuJAY5im0ZaMev2ZG4RVhChGn8Fppcq4fwkkUAuQquWI1gV0Ho+d58S95gepvWbON8cw5DnWNJ/SZC3dw9CKFu7AfsHTlEeCv8B/7dnxrgs/rZJPQ7Y+/3lxz2ditFs2Z7YNJ0FVRPzwCJkkEcgqrhMojLFi7QXFY0Q0dRqxYHz/PT0cl8JrdzhKTpkl0fcyqHLwJaAp5YSNcw3sryXa5onhp9NocbL2IV8twooz5BWQbfAcXVRpoKg0R1HdAWfoBDWdLMW3oj33DSkPkaWHOf7S3yaB+dEnNTXpO6H7tFUByKKokmol6BTOD3qQw806Qk9G1WPTkwRMz3j8U0b4D0t5hGrUbNxxtI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

evict() writes out the metadata that I_METADATA_WRITEBACK tracks for an
inode that isn't being deleted. When the inode shrinker evicts such an
inode that I/O happens from kswapd or direct reclaim. Keeping I/O out of
reclaim is what deferred inode reclaim is for. So hand these inodes to
the deferred reclaim workers.

Don't make the filesystems mark them with I_DEFER_RECLAIM though. On
ext4 without a journal the bit is set by nearly every inode
modification, atime updates included, and the mark can't be cleared
again. So nearly every inode that was ever touched would end up being
deferred. Instead, decide when the inode is isolated. Once a data
integrity writeback has cleared I_METADATA_WRITEBACK the inode is
evicted directly again.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
This goes on top of Jan's deferred inode reclaim v3 (cf. [1]) and my
I_METADATA_WRITEBACK reclaim fixes (cf. [2]). It's an RFC because
neither of them has landed yet. Jan, feel free to just fold it into
your series if you like it.

[2] makes evict() write out what I_METADATA_WRITEBACK tracks. When the
inode shrinker evicts such an inode that write happens from kswapd or
from direct reclaim, which is what deferred inode reclaim is meant to
avoid.

I didn't use mark_inode_reclaim_deferred() for this. ext4 without a
journal sets the bit on nearly every inode modification, atime updates
included, and the mark is permanent. So nearly every inode that was
ever touched would end up being deferred. Looking at the bit when the
inode is isolated defers only the inodes that still need it. That's the
case Andreas asked about (cf. [3]).

Tested with the reproducer from [2] on top of v3: same numbers as with
[2] alone, no OOM in the memory cgroup run, no splats.

[1]: https://lore.kernel.org/r/20261009133253.20102-1-jack@suse.cz
[2]: https://patch.msgid.link/20261029-work-inode-metadata_writeback-v1-0-7d6c678a585d@kernel.org
[3]: https://lore.kernel.org/r/CAHc6FU4Rf9-r8m8SSb=e0k0zyoFhQAdjupHMWvT6rStBshntug@mail.gmail.com
---
 fs/inode.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/inode.c b/fs/inode.c
index c67ec6aa490b..9420afaaf7ce 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1086,7 +1086,12 @@ long prune_icache_sb(struct super_block *sb, struct shrink_control *sc)
 				     inode_lru_isolate, &freeable);
 
 	list_for_each_entry_safe(inode, tmp, &freeable, i_lru) {
-		if (inode_state_read_once(inode) & I_DEFER_RECLAIM) {
+		/*
+		 * evict() writes out what I_METADATA_WRITEBACK tracks, don't
+		 * do that from reclaim.
+		 */
+		if (inode_state_read_once(inode) &
+		    (I_DEFER_RECLAIM | I_METADATA_WRITEBACK)) {
 			deferred++;
 			continue;
 		}

---
base-commit: 548be8616e3e38a9dfc02bd766582ec0acf06647
change-id: 20261029-work-inode-metadata_writeback-deferred-94f716db429a


