Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E6F4C9830E
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 00:51:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9F796B008A; Fri, 25 Sep 2026 20:50:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B52936B0093; Fri, 25 Sep 2026 20:50:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A16D86B0092; Fri, 25 Sep 2026 20:50:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 57DC36B0093
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:50:55 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DA9B1C078A
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 00:50:54 +0000 (UTC)
X-FDA: 85254083628.05.B308C9F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id E33D5160007
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 00:50:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lFv1O9tr;
	spf=pass (imf08.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790383852;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ENpLf7a01+7xiADPMFWKZWUGHAkiuDMSnzsGfLgbzK4=;
	b=oef9b/LG7eQMz5nuE1t2oTr797R8PA232v/9H4M8oLZ6sG7Ua8/+XkKkVISi7yLeZco4vy
	Cv0pxXdVy0QG2ZtxvRRrwpqePY0/EDoE1pWvIGgbWNS4Tw7q/2D5aOBO1IdDhDc2kCIdrK
	jGZAmVqcyvHGENunXQBIeImB1l+q19E=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lFv1O9tr;
	spf=pass (imf08.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790383852;
	b=Tc+c219VPcXWX+CT7tNnUgh62a/t5CFusyphSJLRBeu2CMxgpF6tXo63Ytq0KpP41HD5TH
	m66bZcKYBZk9avwXaeiBHcwEtP5ObCNL4xqBKWG89QcQpNBXXEn/M2ZbX6cZ8NylbzfFyX
	6d1VzsNtg5/dIs3YhNhNM0T7cJwQrL8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C6EDF60235;
	Sat, 26 Sep 2026 00:50:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 89B74C4AF0D;
	Sat, 26 Sep 2026 00:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790383851;
	bh=ubWWiG+VXO6CUxc0ijGW8hrKTYJibhDz9i2X6M32ZPU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=lFv1O9trofogLXT9o2HZxDATk2aSrmIE9WkGLublAdrSXIuDA/e3ilMYZ25hdQHwh
	 OKwOLnuTg678LTMm8HPTcmBWUUPK2+lX1oPn1Hlnhu25RL7pgCXycOXUTaJL/44vyw
	 C/GwFOX1Vnb4TpI/ptdtbFUpIFqCnYsGcXN77pfxVg8dbWglBRdCGtq1hV2sIvN2Ve
	 h6jIdtcOzKtiXFycKWsQaHgOyK9wqRqTy1MqBsh3GJnXAtckTj/2PkAOHzUqGpZlU8
	 cjmt3ImwG1JlJYJyqvDT23lrUHIB6z84gV2Yv6o3qvxmUJaGj8lssfveD4vY8bBCAy
	 S1EQ3ArhUNzmA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B1FEC9832A;
	Sat, 26 Sep 2026 00:50:51 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 25 Sep 2026 17:50:50 -0700
Subject: [PATCH RFC 03/17] KVM: guest_memfd: Support provider folio
 invalidation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-gmem-tmpfs-backend-v1-3-d36159822d18@google.com>
References: <20260925-gmem-tmpfs-backend-v1-0-d36159822d18@google.com>
In-Reply-To: <20260925-gmem-tmpfs-backend-v1-0-d36159822d18@google.com>
To: Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Sean Christopherson <seanjc@google.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, David Hildenbrand <david@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Shuah Khan <shuah@kernel.org>, 
 vannapurve@google.com, erdemaktas@google.com, jxgao@google.com, 
 rientjes@google.com, fvdl@google.com, jthoughton@google.com, 
 tarunsahu@google.com, pratyush@kernel.org, fuad.tabba@linux.dev, 
 Gregory Price <gourry@gourry.net>, David Woodhouse <dwmw2@infradead.org>, 
 yan.y.zhao@intel.com, michael.roth@amd.com, suzuki.poulose@arm.com, 
 Christian Brauner <brauner@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Nicolin Chen <nicolinc@nvidia.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
 aik@amd.com, aneesh.kumar@kernel.org, Vlastimil Babka <vbabka@kernel.org>
Cc: kernel-team@android.com, kernel-team@meta.com, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790383850; l=3424;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=HcCpVRdef3JCMSn2VvVwvzxMYU+D6iq2rei81oGu4lo=;
 b=eWvF/vgmoEI5Wqhqk1edUIUfKJCkkkuEQ5SluDzgA4sqW7on378bDcWX9fZvhhV6hfBE5zkE3
 p1qPPfnWtm/B6laliCdNe2KkBm/AX2cVnPXANHEBFUmHG4vn88XsHd4
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E33D5160007
X-Stat-Signature: jgmaam41r8fgh8ryr18oz9c9att3xmoh
X-Rspam-User: 
X-HE-Tag: 1790383852-335142
X-HE-Meta: U2FsdGVkX19qFy7pz1ZzJKTJ9R6QIppLGTM4+PqVu9SUsr2XiK6mALM2Gn1nL20L/9J+BWVSoMdKh9nchrRDhKL26NXynETvtxIP58aqeyz829nE1s1uxKXFGymKTGRKKuJ4heD+Oa+yhZkYmRNJ96JLGOSflOS0pSmQ3DwA2b9Wp1yCr312LxmME8bH5oL1TZpEf7pfqrzLxx4Bma8d/6v7hlMjZnOh5/Uepk0QVMx6dOgzSFHBD05MhUSJb4soC4xH1iwNVZVfbEAvWLD9qyokX+XY3qmsG6US4NzR1MhrLIoJUz4RwK0Y9xm94Vz7pKGY3YkBzp2MU7xngb5WW9dT0qsN1YNpy0Ilw522W5E866tucRWVZ2KRfohVnWnMXauZjbaeE28jDjYJPdnrO8h2nDPd6KdbCYPAlj54lLQEQvol2CZMttriJGWPXqY1kLCVHI0iBI/nmEROfEC5omeP0D+vdAE9YDL9B4FK4Kzevt1NGG9s2hfVCkt+ST1WJjSTG2yFcOXzGK/xTskTl/TDo8DhbHjj1pJ50ki6yoiRo1SiCg6LlQ5erAbQ//PjnaCmrI5EQuNuI5PnTVuNJBEDICGM4OFFCSlQ/n6gkIL31Jr8YBXVr8aEAqdOX9rXPzf7NoGaXaAic23wzEP/6XsrT0eglouSOl4HoJ7KGuvzT567BxH/cxvtYwiKieQ0U/izcI6cXDtLfgG/ncm48Foy2jA+H+5apt4EQsFf4VXVZD3q2ZuoKDZPvdrDYZCFqFIuDaPTsQmdnXI2OXhQ/F0C5y1kLjDpP8CCo8DHdseGGUDFL7/C28qW+hyWb0T2t56VVirdYA3Q2o4wtRf7NBzZqZGUGdVBKRq0rHG3qQqbTe3WXwe5uRi8qzHIzWXqqplDuTlGlQUKN5N90Lwge92Y6/i5h+Fz9MJHhwXrBF9dwhr6bUW3vJWKVjztOQjBOUweeFpc1x/IvoZx/4R
 j0fjSs58
 Yl4zV9p0RcDP1Glm/Ql8zcj+xCi9ZxrIqwVfUER8yjNEFuvzvv/I9hOe8/OLeXulvQ0cChKCJ50OXYfyTjAe6y8bc7sBPOGf/PDPvX3VXMGJS4BojKEKyYoHl8zU14Kky5L6cEhP+jjaUKk+l6sblvnFSbxgicNze4eHdr+JQXQStVXwtGbOBwPmWuUox6pYoepnhmTrAGbN+ncGc/rshXM0/3wEKTuBBiNRoNbPeat0c3Wrh4BRoFZ7tg3xy0313CV7CgfHBzfU68Dv0Qjzmaq7eorhHXs+DqXn3+QS1taN9EqwQmcYR3in6WQwa4MPl2HRd0xs/Hj7VE1RgLFvftD7RVoPRLs1Lw/LhiONsLSNzcQCQ30z7cXhjuNoWuIuy69GDPWzHtBsQ/6nZjQkv7oJw1L/MvQF3oPchjBkVQa8RGnTXI+s8qixekVIkmh1dRLq7XVB2zzS8wV0RjJewnSopLBcTvAeD0kp52nig0WEomnNOX8hDDBnxxC+GuSjGy3zW9KWZChR8NcXfbwUgYZybFfXiZlAkaYTW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

tmpfs increments the total number of used pages on the mount at allocation
time, so that number has to be decremented when the folio is removed from
tmpfs' ownership.

In this model where guest_memfd allocates from a tmpfs mount, I believe we
should respect the limits set in the mount, hence I require .alloc_folio()
to increment.

.invalidate_folio() is then the counterpart to .alloc_folio(), for undoing
any provider-specific per-folio work during allocations.

.invalidate_folio() requires mapping_set_release_always(). Not sure how odd
it is to use that mapping flag.

Using .free_folio() is hard because folio->mapping is NULL by then, so I
can't reach provider information. The provider information could also be
stuffed in folio->private? What do people think of that?

Another alternative would be to use a custom truncation function in
guest_memfd, just like shmem_truncate_range() or shmem_undo_range(). The
con is that guest_memfd might at some point support more generic mm stuff
like swap/reclaim, of some form? Or maybe never? Shall we go custom now and
unify later? Or just not think too far ahead?

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 5ac2d558c8dd8..00f3bd0cf21e6 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -64,6 +64,13 @@ static inline struct folio *gmem_provider_alloc_folio(struct gmem_inode *gi,
 	return gi->provider_ops->alloc_folio(gi->provider, index, mpol);
 }
 
+static inline void gmem_provider_invalidate_folio(struct gmem_inode *gi,
+						  struct folio *folio)
+{
+	if (gi->provider_ops && gi->provider_ops->invalidate_folio)
+		gi->provider_ops->invalidate_folio(gi->provider, folio);
+}
+
 #define kvm_gmem_for_each_file(f, inode) \
 	list_for_each_entry(f, &GMEM_I(inode)->gmem_file_list, entry)
 
@@ -166,6 +173,7 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 			int r = filemap_add_folio(inode->i_mapping, folio,
 						  index, GFP_KERNEL);
 			if (r) {
+				gmem_provider_invalidate_folio(gi, folio);
 				folio_put(folio);
 				folio = ERR_PTR(r);
 			} else {
@@ -893,10 +901,24 @@ static void kvm_gmem_free_folio(struct folio *folio)
 }
 #endif
 
+static void kvm_gmem_invalidate_folio(struct folio *folio, size_t offset,
+				      size_t len)
+{
+	struct inode *inode = folio->mapping->host;
+	struct gmem_inode *gi = GMEM_I(inode);
+
+	/* guest_memfd only allows truncating full folios. */
+	if (WARN_ON_ONCE(offset != 0 || len != folio_size(folio)))
+		return;
+
+	gmem_provider_invalidate_folio(gi, folio);
+}
+
 static const struct address_space_operations kvm_gmem_aops = {
 	.dirty_folio = noop_dirty_folio,
 	.migrate_folio	= kvm_gmem_migrate_folio,
 	.error_remove_folio = kvm_gmem_error_folio,
+	.invalidate_folio = kvm_gmem_invalidate_folio,
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_RECLAIM
 	.free_folio = kvm_gmem_free_folio,
 #endif
@@ -935,6 +957,7 @@ static int kvm_gmem_init_inode(struct inode *inode, loff_t size, u64 flags)
 	 */
 	mapping_set_inaccessible(inode->i_mapping);
 	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
+	mapping_set_release_always(inode->i_mapping);
 
 	gi->flags = flags;
 

-- 
2.56.0.rc1.315.gc6ed9934b7-goog



