Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66CC3606A31F
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 04:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HmhW/KE8
Received: by kanga.kvack.org (Postfix)
	id 3A9A26B05B2; Fri, 27 Nov 2026 23:22:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35B826B05B3; Fri, 27 Nov 2026 23:22:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24AC56B05B4; Fri, 27 Nov 2026 23:22:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A2BCB6B05B2
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 23:22:02 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0EF03405B0
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 04:22:02 +0000 (UTC)
X-FDA: 85483230084.13.86A0A87
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id C0B54120003
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 04:21:59 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HmhW/KE8";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf29.hostedemail.com: domain of devnull+dickson.wu.certik.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+dickson.wu.certik.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795839720;
	b=w7m+QZue63rAiiECgMv+luxD1pR2eMSVUDpsz/VnHQBn1ylmw9RUscChupRX6WuUgIpXJT
	wJZ7OS7YoxPMOBtirKT6LhPD6US/kqEo93a7Fi32SbmVHqhw2zJYiTDk/PPJNyJkafk6rJ
	B+CValE8i2gK7beIEflaGDgnRVQSDt4=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795839720;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lWbpQF+ytgPV8YvJxS4QwACQ+Q0rBA9CNgB0B8ZYfv8=;
	b=bnMBFzfvjzDEN2VgCKqEX3/Ow8xALIWnAJwIMUhO9Eob76XT/HUOtcAMHkwmL3pCUokiVG
	26Yky4XtqfepTe9l4HIGgcSF6jLBcu/yNtOPUjM6ngtFBbimyHuZzFUqY8h6LqFGHgNdJR
	ZTzknCVFaGXttgos8eBHDw+M4nj6hPM=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HmhW/KE8";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf29.hostedemail.com: domain of devnull+dickson.wu.certik.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+dickson.wu.certik.com@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DB52F41954;
	Sat, 28 Nov 2026 04:21:58 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795839718;
	b=3NkyZHqod60fzpv6gWqy+tEB1ldAg9+AY/uymMw6kTf/kO0YNv6AsXFjogUo3Gt7F6yw
	 XJrCNc8jqbmSraPMdXDYWC2wAzpQvN8bnb7IpEhG81SqOgGb1VHozpgLZ1acduxLQqyQa
	 pFEqgvuR+eJcE5Xxqwqsw8wKRCuwFto6RMxuO3TbHrKK+f3LkcVMmTziaB+OMAy89bXHD
	 06SL4hytFGBIyO9XkZClThDE/bLkK5ZNMhwUJtzjcB/87ZuSJZa+/gy05sI0Ux+cSoAWU
	 20BJTU1nVtG+5ET7ZkGldldX9wFyRSpSD8reZkhdLruqOcvQI/IIYpGXAS+BENODhSg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795839718;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:X-B4-Tracking:X-Change-ID:
	 In-Reply-To:References:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key:X-Endpoint-Received:X-Original-From:Reply-To;
	bh=lWbpQF+ytgPV8YvJxS4QwACQ+Q0rBA9CNgB0B8ZYfv8=;
	b=brw8fO+C11CmFqTqy37rc1c3bO2up99bcLkF83nl//sNOUGmUlpkX0s9hhfn6SoHvSMB
	 ThO0HPymCHwN2AktOBxHkoGmjrZtXo9U6jvNve3aSY+Hzfhq89bOBi12n3TjnoyjYydFJ
	 g7xpVTrb8rPs9rvOO5yfxarMKhWzWsU4sZPQ3PcHQl/nbQOYvK+S3Idn7UvCsDM9XApOy
	 r1cqqnpQ9CTbNe0UEAg2o7SLG9peGzTAQy9A0M0VycYylhPOnmOr9bKMkD5hjwz07QGDj
	 259V/lnXYvZy4Lz53ok0Dr9MK71aKQofcPqLk8537WKZlsOe8OWv7+MWzEOnWxvA6tA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 5923E1F0089B;
	Sat, 28 Nov 2026 04:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795839718;
	bh=lWbpQF+ytgPV8YvJxS4QwACQ+Q0rBA9CNgB0B8ZYfv8=;
	h=From:Date:Subject:In-Reply-To:References:To:Cc:Reply-To;
	b=HmhW/KE8zDeSK8Tk0XPxG9X8nyRzNmUVrzGYRwD2EVgNX58GtsPhgHviSaLsHf3ex
	 ylypo/YBjoTnNNxkKLlDJUCuPb0XvESpfrHbLQ2DsAn4CilOuCbUB5pKMImqnFDasa
	 J5uJp8zUYFT8yLe2a70dlhnoBPaG/isajE9GfgeR2rlpI2oaQQSBgUPQM/3qd3rZSP
	 MA9Mt5puV6FdLyn/0A1kZziGUE4tcPVeVOdoCC3fzgKZLaLxgsrenAstSJcN/1VA6g
	 rN+lwJ/VFndxbjr5T8LmZ1rulKeleHDISfgNoMz7XrAw70JIMvGMOvZGvoy2FaykEJ
	 YkX5fGZAekLFg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id DDC824DF9D;
	Sat, 28 Nov 2026 04:21:54 +0000 (UTC)
From: Dickson Wu via B4 Relay <devnull+dickson.wu.certik.com@kernel.org>
Date: Sat, 28 Nov 2026 04:18:01 +0000
Subject: [PATCH 6.6.y] mm: fix uprobe pte be overwritten when expanding vma
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261128-uprobe-66c-v1-1-aadfd58e836f@certik.com>
X-B4-Tracking: v=1; b=H4sIAPhVCmsC/0WNwQ6CMBBEf4Xs2UVb4yL8ivHQlkVqTEu6YDSEf
 7fVg8d5mXmzgnDyLNBVKyR+evEx5KB2FbjRhBuj73MGfdCklD7jMqVoGYkcntqG3LElpmaAPJg
 SD/71lV2AaqrfcP1hWeyd3VxEpWiNMNpkghsLEg79HOMDC9//D2DbPr8XC12gAAAA
X-Change-ID: 20261128-uprobe-66c-5976c396e67f
In-Reply-To: <2025062009-customs-outskirts-5826@gregkh>
References: <2025062009-customs-outskirts-5826@gregkh>
To: stable@vger.kernel.org
Cc: Pu Lehui <pulehui@huawei.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 David Hildenbrand <david@redhat.com>, 
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795839480; l=7675;
 i=dickson.wu@certik.com; s=dickson-b4; h=from:subject:message-id;
 bh=Pxpy5u+zDbncpwIemAT49h1RaeD/R4OBqpJdAtccl90=;
 b=ZcaAzxyJ4dtfcMq8fWyJRezFMjXwULGFL4/XQ70139VGp9a30XjWTnu3z+rSBNz3T7ZkXe/54
 F4jGhulidH6AxmWJC33yVPZDZtlxGKCV5cziQtRBV5mAG7A6GcDinP3
X-Developer-Key: i=dickson.wu@certik.com; a=ed25519;
 pk=fxH7FS4FdojeJSGLJzgKdfO51Rvr4EW30yinj2mc1vg=
X-Endpoint-Received: by B4 Relay for dickson.wu@certik.com/dickson-b4 with
 auth_id=1647
X-Original-From: Dickson Wu <dickson.wu@certik.com>
Reply-To: dickson.wu@certik.com
X-Rspam-User:
X-Stat-Signature: 4dm88cr5p9g64gwfuxwu4cda5dagz4ei
X-Rspamd-Queue-Id: C0B54120003
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795839719-944121
X-HE-Meta: U2FsdGVkX1920/fqtvZ6I3oy3wGJ3BhMbcl27k8hQcSsipaLgLUcDTHEWgz4Hn8UWeA4MfHgiDcJsU1STaWCht2ZcwFBJtG47XF9Y3kPvdVk96HBtZKbOOMKNluAFW/marDAwPXB+hhNdlTKR2FrdIGsadl2Jl6ILZPKyUhHhti+Z3Uk4iFGma+tRmGTdQaqHrgaKkYljmgFT7oVM680lhKJOrcgdZxe4O+vG68F/wLISmbe0ZE2UFu7zKpPI3I8toZcM/BvzXEFwp7eTFRlbX5OdcvLTaOO2i4wMimU0W0JvNAKmX5y9mkCOk3hWz/jks9CH8Oima7YbKdHBowrtMIX3v93jL+o3tMH/YuTJtxxwbcgIhhihZMyWLA4uGM4vr7OyZfuuRNRjs8+Rpc7x65LM7XTl8jk1KyMKmE0sSWT6qyVTy/ZjRKuiAUopctH689EFEU4t5Ihz5tgyQCuaqe0XppN9uhyRti4P2qC3KaOJxb1vnRqU6fB9zoM+VMFJTN6FaknyLAq0wy+QZBHLhOjQxdkaLy5iOMkVS5KshgJPbajEVdmyML/fzDkatBpuESwil5gZFOsCEicJVNAbh6i+n3Iv5CeWC3LnEnIG7m6jOHgsfiE4aySbwx97tuYl1sUrQNAEee1lsli0T5UILvgdfFJbL0j2PDCQTEc4uw05HAwTwIN1nO/cQWqYDpU8ToDq4cM3WemcPvTnILofDKNV9N8jdU57NphxDpYQalQTSoFtG0jXwPgi/phVcvmG112xPZoXbW1/aqkGiZfRYH1sfJxQa4WqXJ3oEvx+8Qjn0lgLvYXFxT2CzzbKNKvq2O5P26r4eGYIkeNKSxAe0V5qSKjtNb2P/PZfPYZh7ERNPtRJwhmzafcPTdTNH0mGYRX/Wro77Hd9z/Kh8HU4wkz8frztIlZMH57y1t/cG3Ztnk3ds5iScrsbuOzmWAkFSfEwidyEz/2S0ja9fT
 tJVL8K6a
 i68+udW4J8poY6uYhQCb0nXQ6/mYAkRbZ36cBhz2mSKinvE7kUZX9dEbfMF0iarOI8dCW+zYh3D9wH3izBvTQiPwik4doMAINzBW8ZgED5l6gZ7E9JF9wdvqTuuWfa2TCfJWEJENdXiau7UFkTlzYC6RZTUmIINyJCNHai9aJTi5zF9bO1cKDp5TqT0IspnudIEta3otmxDn10OaJHVqEIL10KzhxQQYg9hd+lefQltxq8lfyz19HK6+q7deew+dBEIB2nmrgL6t6tnpp2lu0WX9M7apViGz+yA+4Pm9dDkJIjtlkRIy3nwLobn0jTIGmc0Y1ew8ZcAiLIwGRmjqCTsGFIwHAu5DdAXwjnjRtzEXAQy3G1BvM12yKBQFjCkuxrwv+mX6p2d9rkAd+X/kvlCbceotRDDg9IQO46dTZKYdbWMDc/z4KpVm0m1oafgsONrsd9ZhD+u+Mdlk3sw7TtlR0lfFP4DRg12rmOKUzawst5rdBi1M0v/rX/4Toru9snYVu6nuBb+Yjmi04OXJddBwghgCERNFUevWuYmDKctSM1qIPNIX7KfRC13jev/rydUy+2WZ0iLFUETOczHEAjkV0qhx+W4JcJeLQ72+g604xLVzBvLdP7GMgGseUZDLpHODzMynP24kLFk7GDKRVKWv2KMrQE5mdgyW27Yyps+cyAqF0Ow5TOxTvmjWiFy9wkuulrjXUW5Pqs4afB8LnrYGjY97EMrI7gyXTZ08IZt7cdqcou0YjBDuGQMuwJtpVaRwSW6fqH9ux4+wjEefNXVBqm5Asdkg8oesv3nvMimJ6WyTpBKsRyQLUPFc0+DFrGlcRSjDQ49XfGmJQYkrPdOxBxxNUA5X1FY74W+DbqTxmqfiA9Qflx8WFiMqa8chyHNQO4RZtSF7KnFUv8UWWYyhyNkEmgDaCfR2GmlAB8wMaAMIftSd66NyH4bCAD4GNzSo21Iz+6MF75hlqKp82KcPAqbI0
 az1TBLlW
 UwGlkASZegSEwEWG+kCKRA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Pu Lehui <pulehui@huawei.com>

commit 2b12d06c37fd3a394376f42f026a7478d826ed63 upstream.

Patch series "Fix uprobe pte be overwritten when expanding vma".

This patch (of 4):

We encountered a BUG alert triggered by Syzkaller as follows:
   BUG: Bad rss-counter state mm:00000000b4a60fca type:MM_ANONPAGES val:1

And we can reproduce it with the following steps:
1. register uprobe on file at zero offset
2. mmap the file at zero offset:
   addr1 = mmap(NULL, 2 * 4096, PROT_NONE, MAP_PRIVATE, fd, 0);
3. mremap part of vma1 to new vma2:
   addr2 = mremap(addr1, 4096, 2 * 4096, MREMAP_MAYMOVE);
4. mremap back to orig addr1:
   mremap(addr2, 4096, 4096, MREMAP_MAYMOVE | MREMAP_FIXED, addr1);

In step 3, the vma1 range [addr1, addr1 + 4096] will be remap to new vma2
with range [addr2, addr2 + 8192], and remap uprobe anon page from the vma1
to vma2, then unmap the vma1 range [addr1, addr1 + 4096].

In step 4, the vma2 range [addr2, addr2 + 4096] will be remap back to the
addr range [addr1, addr1 + 4096].  Since the addr range [addr1 + 4096,
addr1 + 8192] still maps the file, it will take vma_merge_new_range to
expand the range, and then do uprobe_mmap in vma_complete.  Since the
merged vma pgoff is also zero offset, it will install uprobe anon page to
the merged vma.  However, the upcomming move_page_tables step, which use
set_pte_at to remap the vma2 uprobe pte to the merged vma, will overwrite
the newly uprobe pte in the merged vma, and lead that pte to be orphan.

Since the uprobe pte will be remapped to the merged vma, we can remove the
unnecessary uprobe_mmap upon merged vma.

This problem was first found in linux-6.6.y and also exists in the
community syzkaller:
https://lore.kernel.org/all/000000000000ada39605a5e71711@google.com/T/

Link: https://lkml.kernel.org/r/20250529155650.4017699-1-pulehui@huaweicloud.com
Link: https://lkml.kernel.org/r/20250529155650.4017699-2-pulehui@huaweicloud.com
Fixes: 2b1444983508 ("uprobes, mm, x86: Add the ability to install and remove uprobes breakpoints")
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: stable@vger.kernel.org
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ adapted to 6.6.y: pass skip_vma_uprobe via an internal __vma_merge() ]
Signed-off-by: Dickson Wu <dickson.wu@certik.com>
---
This failed to apply to 6.6.y, which has no vma_merge_struct to carry
the flag. Instead vma_merge() becomes a wrapper around an internal
__vma_merge() that takes skip_vma_uprobe, and only copy_vma() passes
true, for file-backed VMAs. vma_complete() then skips uprobe_mmap()
for that merge as upstream does. init_multi_vma_prep() zeroes the new
field, so other callers keep the old behaviour. The upstream comment
in copy_vma() is dropped since there's no vmg assignment to hang it on.

Tested on 6.6.163 in a QEMU guest with UPROBES and UPROBE_EVENTS: a
small program registers a perf uprobe on a file, mremaps the first
page away and back so copy_vma() merges it. The base kernel logs
"BUG: Bad rss-counter state" and calls uprobe_mmap() three times; with
the patch there's no warning, two calls, and the merge completes. The
mremap_test and mremap_dontunmap selftests pass on both kernels, and a
W=1 build of mmap.o shows no new warnings. I didn't check that the
probe still fires after the merge.

The backport and the test runs were prepared with AI coding tools
(OpenAI Codex agents, with review by Claude). I went over the result
before signing off.
---
 mm/internal.h |  2 ++
 mm/mmap.c     | 35 ++++++++++++++++++++++++++---------
 2 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 1106bab6abc9..da2f1be0cd45 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1231,6 +1231,8 @@ struct vma_prepare {
 	struct vm_area_struct *insert;
 	struct vm_area_struct *remove;
 	struct vm_area_struct *remove2;
+
+	bool skip_vma_uprobe :1;
 };
 
 /* pagewalk.c */
diff --git a/mm/mmap.c b/mm/mmap.c
index d1cabe718b63..c50f16c85419 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -542,10 +542,13 @@ static inline void vma_complete(struct vma_prepare *vp,
 
 	if (vp->file) {
 		i_mmap_unlock_write(vp->mapping);
-		uprobe_mmap(vp->vma);
 
-		if (vp->adj_next)
-			uprobe_mmap(vp->adj_next);
+		if (!vp->skip_vma_uprobe) {
+			uprobe_mmap(vp->vma);
+
+			if (vp->adj_next)
+				uprobe_mmap(vp->adj_next);
+		}
 	}
 
 	if (vp->remove) {
@@ -860,13 +863,13 @@ can_vma_merge_after(struct vm_area_struct *vma, unsigned long vm_flags,
  * **** is not represented - it will be merged and the vma containing the
  *      area is returned, or the function will return NULL
  */
-struct vm_area_struct *vma_merge(struct vma_iterator *vmi, struct mm_struct *mm,
+static struct vm_area_struct *__vma_merge(struct vma_iterator *vmi, struct mm_struct *mm,
 			struct vm_area_struct *prev, unsigned long addr,
 			unsigned long end, unsigned long vm_flags,
 			struct anon_vma *anon_vma, struct file *file,
 			pgoff_t pgoff, struct mempolicy *policy,
 			struct vm_userfaultfd_ctx vm_userfaultfd_ctx,
-			struct anon_vma_name *anon_name)
+			struct anon_vma_name *anon_name, bool skip_vma_uprobe)
 {
 	struct vm_area_struct *curr, *next, *res;
 	struct vm_area_struct *vma, *adjust, *remove, *remove2;
@@ -1010,6 +1013,7 @@ struct vm_area_struct *vma_merge(struct vma_iterator *vmi, struct mm_struct *mm,
 		goto prealloc_fail;
 
 	init_multi_vma_prep(&vp, vma, adjust, remove, remove2);
+	vp.skip_vma_uprobe = skip_vma_uprobe;
 	VM_WARN_ON(vp.anon_vma && adjust && adjust->anon_vma &&
 		   vp.anon_vma != adjust->anon_vma);
 
@@ -1046,6 +1050,18 @@ struct vm_area_struct *vma_merge(struct vma_iterator *vmi, struct mm_struct *mm,
 	return NULL;
 }
 
+struct vm_area_struct *vma_merge(struct vma_iterator *vmi, struct mm_struct *mm,
+			struct vm_area_struct *prev, unsigned long addr,
+			unsigned long end, unsigned long vm_flags,
+			struct anon_vma *anon_vma, struct file *file,
+			pgoff_t pgoff, struct mempolicy *policy,
+			struct vm_userfaultfd_ctx vm_userfaultfd_ctx,
+			struct anon_vma_name *anon_name)
+{
+	return __vma_merge(vmi, mm, prev, addr, end, vm_flags, anon_vma, file,
+			   pgoff, policy, vm_userfaultfd_ctx, anon_name, false);
+}
+
 /*
  * Rough compatibility check to quickly see if it's even worth looking
  * at sharing an anon_vma.
@@ -3431,10 +3447,11 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 		/* If not registered for remap, uffd context will be cleared. */
 		new_vma = NULL;
 	else
-		new_vma = vma_merge(&vmi, mm, prev, addr, addr + len,
-				    vma->vm_flags, vma->anon_vma, vma->vm_file,
-				    pgoff, vma_policy(vma),
-				    vma->vm_userfaultfd_ctx, anon_vma_name(vma));
+		new_vma = __vma_merge(&vmi, mm, prev, addr, addr + len,
+				      vma->vm_flags, vma->anon_vma, vma->vm_file,
+				      pgoff, vma_policy(vma),
+				      vma->vm_userfaultfd_ctx, anon_vma_name(vma),
+				      vma->vm_file != NULL);
 	if (new_vma) {
 		/*
 		 * Source vma may have been merged into new_vma

---
base-commit: e2bb30811e063ce0db964484357973b855b06572
change-id: 20261128-uprobe-66c-5976c396e67f

Best regards,
--  
Dickson Wu <dickson.wu@certik.com>



