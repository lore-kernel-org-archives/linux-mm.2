Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AFDC606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 17:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZlPMPBSq
Received: by kanga.kvack.org (Postfix)
	id 5696C6B05B5; Sun, 22 Nov 2026 12:56:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5416B6B05B6; Sun, 22 Nov 2026 12:56:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 457616B05B7; Sun, 22 Nov 2026 12:56:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 20A086B05B5
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:56:00 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 94E96A794E
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 17:55:59 +0000 (UTC)
X-FDA: 85463508438.26.70F31F5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id C89FB80002
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 17:55:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZlPMPBSq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795370157;
	b=7X/LUhqSi7ZhbNnMxCBZVIJfNtXBM2NnLewfUXNUMg6By41IiyHsd2fsciEBU9y5mVyU+c
	8EzeMOinj0iT8hei0FoADF2oxrNR/jEFllz4eCc1ijRGurZQ9Fx59pigTMe7WSeUL8vjjz
	voZsIEowVtcFn4+0tyMyTEq5idogsDo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795370157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YJuynXecCuAMRPu1fuAj/g8WUJ63sUPX3+ZQ3T0k/jQ=;
	b=mCiQmJWAj34XXXOueSDpMr+M2epaGzC32oC3ggKZRFUj0d8uvo+Nvoz/tiEOvAiZL67bJr
	QCdOvvFiyackjRtZwZrenn+M+NwCsbEqqSyzW6h9VzB2mweQlx79dNbCcC4F7C84+jSCOW
	53kiEudTnx1zMY8ori1dh/+dJm8ZABk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZlPMPBSq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6502C61B2E;
	Sun, 22 Nov 2026 17:55:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 873161F000C0;
	Sun, 22 Nov 2026 17:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795370157;
	bh=YJuynXecCuAMRPu1fuAj/g8WUJ63sUPX3+ZQ3T0k/jQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ZlPMPBSqzDmHZOGkU4054fbMNFlF1IGQXsCUJvAri5JYusQq6Fld+r5likMn8ztyc
	 7Mu9eLJLytazLi5qvR4SRWz2zDpkE7rhOdNUxABvNd9cXZh3w9NVbFT/1fK3G2mQjm
	 T/G50bkDLqZAhz5fG4Qa2/PAI4f5SbSBnyUGRdECOvoORfmjY7nKMarfffarIrcue0
	 4p/dISPdQ38AEu/2E5zXoiDU+qVjyi+aRyDPyIeuectPnv6lWYxDSXN57PcX4bQnT8
	 6paLk+KUayEaB0GxbLKlmu55IsoNjLstoFUqG/1K2dQan7NU+By0RS4eluYAbhRKR8
	 sNWFJkwwLQ9lA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sun, 22 Nov 2026 18:55:20 +0100
Subject: [PATCH v2 3/4] powerpc/spufs: consider vm_pgoff in
 spufs_mem_mmap_access()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261122-access_shite-v2-3-808d8d2aa700@kernel.org>
References: <20261122-access_shite-v2-0-808d8d2aa700@kernel.org>
In-Reply-To: <20261122-access_shite-v2-0-808d8d2aa700@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
 Willy Tarreau <w@1wt.eu>, Jani Nikula <jani.nikula@linux.intel.com>, 
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, 
 Rodrigo Vivi <rodrigo.vivi@intel.com>, 
 Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>, 
 Simona Vetter <simona@ffwll.ch>, Chris Wilson <chris@chris-wilson.co.uk>, 
 Matthew Auld <matthew.auld@intel.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Shrikanth Hegde <sshegde@linux.ibm.com>, Rik van Riel <riel@redhat.com>, 
 Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
 linuxppc-dev@lists.ozlabs.org, "David Hildenbrand (Arm)" <david@kernel.org>, 
 stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1348; i=david@kernel.org;
 h=from:subject:message-id; bh=f8MyOmAIcEjLMC9uMSbKvRisK/L7ggF5sRJ95bTUbag=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKZdTpFH06P76o89+bMQV6RhB1rfNnzZyntmJ6i9n3Zg
 XtzTZ5GdJSyMIhxMMiKKbIEBd83ePlyXW21Gx8zzBxWJpAhDFycAjARtlCGv4LXtR5FTwyfuPvV
 mktGH1783zK3bR53UvaTOT9EhOMXVL9g+F9ToTll5fSfRpcOb85ieqIRcuLBUudv8zlK2kTnubP
 HfGAAAA==
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: apy3cqkusstcyxniawdpt99joxegr4fx
X-Rspam-User:
X-Rspamd-Queue-Id: C89FB80002
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795370157-859466
X-HE-Meta: U2FsdGVkX1+h527idvmehi5eMIuL7gcL2WAABBcCoysF0HwHzRuD1bT2U4z0Jfr/OSVO0+QUTZAFZw/DEbrCmUr50V4/hXZc8ZYGtyMB236/Vz6WSRubxRUlvgB+3BVHx6drzlJtEX5+BQRWzZdU/P9WPhBPRXZ6Tq0AX2LpQw9izey0sLOdlDsdoDQK+W04pzAQIL1jFJ8zFtktPMG6IEf9jOSzZwT9GoyXHtFQpUwjTwPN12VGxCsZcezbrgTEliC2VAU1SRoGdR8/1IHlik9F6p+h4W/lltT3+mJ0qs5qQFtPBBPkaeMqwAOvd8/ih2wXRfBZcSMAJvpMpjOLUtnQ+nygJkJWUnWFof8jDRu+cce9NiHrE9TwxjWJ36vbjOFOT5ZKvQCBfB7PukKPM6Wt7ZYunyOVExqF9SmP1lTrA+fXCLFITEcmNgMpxoAz6upINokzXd1/NrVcjremQCl60mDDUs6CQgbdeoInz0wf7PrFOW/XD8w1E2rLiShuQFfNJZkLUG8UrpVykAggRwcoVxD1yah77TZSkvKSZreSxhG5Ebr1vbWFbwKYAXbHFjbjSvEnM7wtfhWutlryFMOYpgrnAZRgVcfOslbSf9N4ZKc8wUz+CyZS3enda8pSDLBdnn6ZoiU+ftqmtzfIugkwdrA1Z9HqU8aanXLTuAOH/78eTxGHV9sLBFoCxEMpb8JX3/UZdlYwMX7Mi8OhTsYEoIiNWpfo8HXZLjD74YNZ0DxXzSxs05YGOpSOdDTFQPMFaevPuy0poAprq9X6kWirOIxJOc+UumgLusd6DgfCUVg8VuIWS2FkXJWb3tAUTmbIB7mUl55auBYi2Fs9XcHpoe1mFYyqtZ6s2zOtAG13fQJepUkD2k3jQ9/g5dvs/Wj0k/5jl3UOAM9ODZog40w9c+9a07K/1BLMikLv07TUm+NlT4aV0FIC4HObRlgaoEkc7BtCAGcDipIB2xA
 MPlF/akU
 n1u8xNTHuyQrcyP4ud9F6KdP8dEpj9KWM5E9lU7Elv8SGVm732QhjqncLgAR28MMmECzu1n+DSHcddL129WsYI5mho4ACP6BKpETF1WfUOMyE2Wd4lFZHdAkqp2DVUN8GT5XYQnGaj56KkH9BqdOShvoX+x9sn4YMBbF9D1qn+hlOtN7VoKP5IvYifRVHC7RGBHq13NGQCCFwHHert7pAOL+dX7Kmfqx6qzwNFpY8GGFA9RVTA9Lb7GJJiNLAtpcTL+2uAgeFsZPELT0cbJib9NBNFvpGDO8ptsrAUK0JwYmoNagayoKizputFrlY/PhfCcrEMBoa7sxZpLp1TL74a3Y0aD+qHyKFyN5JiWoOqlwjUY0MDF5jja9Rci4we1Sf7y9kRSIKaDj622iTAL/obOl+bB21iIhnfYonkH5bzu1ML2Wv4gB/5bnFXOOVDsCUcY/iEYEr01jLwByi9UVV2/6j2Isqj6FdOyYORvFa49lkULGevVPnl2bw6wcdBasbtKTqKYW2YAOla597sQtEZTtLXpDOIWPoHlv+4jNms+JiPK7VFkXLUemiHOObAzkSIXnXYJA8/RKdtV1+SxN7On7QZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

spufs_mem_mmap_access() calculates the local store offset relative to the
start of the VMA and ignores vm_pgoff. After VMA splits, debugger reads and
writes access the wrong part of the local store. Mappings created with a
nonzero file offset have the same problem.

Properly take the vm_pgoff into account, just like spufs_mem_mmap_fault()
already does.

Fixes: a352894d0705 ("spufs: use new vm_ops->access to allow local state access from gdb")
Cc: stable@vger.kernel.org
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/powerpc/platforms/cell/spufs/file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/cell/spufs/file.c b/arch/powerpc/platforms/cell/spufs/file.c
index 98c47bafaf678..0a46d6f7178ab 100644
--- a/arch/powerpc/platforms/cell/spufs/file.c
+++ b/arch/powerpc/platforms/cell/spufs/file.c
@@ -248,7 +248,8 @@ static int spufs_mem_mmap_access(struct vm_area_struct *vma,
 				void *buf, int len, int write)
 {
 	struct spu_context *ctx = vma->vm_file->private_data;
-	unsigned long offset = address - vma->vm_start;
+	unsigned long offset = address - vma->vm_start +
+			       (vma->vm_pgoff << PAGE_SHIFT);
 	char *local_store;
 
 	if (write && !(vma->vm_flags & VM_WRITE))

-- 
2.56.1


