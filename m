Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC6CA606A321
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 22:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jkL+ZB2a
Received: by kanga.kvack.org (Postfix)
	id E0E736B05F9; Thu, 12 Nov 2026 17:09:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE5E56B05FA; Thu, 12 Nov 2026 17:09:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFC526B05FB; Thu, 12 Nov 2026 17:09:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AD3396B05F9
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:09:44 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 42946161C41
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:09:44 +0000 (UTC)
X-FDA: 85427859888.08.A141F2E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7D9221C0007
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:09:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jkL+ZB2a;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794521382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eKtXaU18XWDmrm51FUDVoZxTbd+Jzy0nR5+iJLVT/Yk=;
	b=veLa/PFdlY8bJzvF/uKO7EwWI5OLR0S5T3+emrEWAWAD0BnSYI69xLCEL2rUyInwlx4alE
	+LL2kCtcxb9YvxZ+jCiYWaRKCAgAoqvQortpf89VmN14tph1YsHIMnvhajcsuo8uDVrQYY
	AhZaia7w3sAG1ExakKPNvPo5cr9i6ZQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jkL+ZB2a;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794521382;
	b=GBOX0QnGC8YOOB9QKJVCW0r1FeiWOKke+rKj7rMqmkCIzID8d+PkvR3DpksctCAoyPiwmG
	jgwsBD3JwQEVM7nKW2G3H4oK6pB0bPXUgs7/55V5X3WIkbmG1UqVzkFsa3NIFVzW7qT+Fr
	e8AKb0yyOrTTT8HBYTcaa2LFKd7I3wI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BF1774646C;
	Thu, 12 Nov 2026 22:09:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B891E1F000C4;
	Thu, 12 Nov 2026 22:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794521381;
	bh=eKtXaU18XWDmrm51FUDVoZxTbd+Jzy0nR5+iJLVT/Yk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jkL+ZB2a4fUwx27qOVIEV+ckZQ/gSjMPP3h29FpAk4PlOjb9LirgSuhw4zlbzw+TM
	 9Ys06V8UM5KILDGz4kcDcXHt+QdS6IwpIYUNxkrZqklga3AHuZI28CAqsvB6rRKJQy
	 wQcEkO6mrSXip4E8TRbKqS4h6HYP8KFB6IJW4x5SDlh8OyCRis7XriaS13txq3yP1j
	 VjXVrSbG1x1f/e5ytJhhy+FJeef365J72+LX8ayB4cIYe5oD5G+I9hI6Sh9TFxGJH+
	 0jiRerzzmMrSsTaodVJVb8P7sjITxHF4ma/FIxHnXjPAMdZXmioymUii/zY17u1NVp
	 yh2WD0W8m2Nkg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 12 Nov 2026 23:09:00 +0100
Subject: [PATCH 4/5] powerpc/spufs: consider vm_pgoff in
 spufs_mem_mmap_access()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261112-access_shite-v1-4-988a5c470db2@kernel.org>
References: <20261112-access_shite-v1-0-988a5c470db2@kernel.org>
In-Reply-To: <20261112-access_shite-v1-0-988a5c470db2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1298; i=david@kernel.org;
 h=from:subject:message-id; bh=PQPxNnQpVVFHjjbqHgG191KRAqKJhGnNL5teRs7niOM=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLK+WfwvmXrNbfL1DTr7E26IRJ7XFjTl6ms4FpmrJVG/6
 pnretUTHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAEzkURQjQ9dyu4gpkQX8Sr0C
 BvVLG3omPVjE/fyifL1Ezg6x9ZxvgxgZpgskTX6gKFW7IzR7p2TykkUhix0bJs+usdJ6c5drnc1
 CVgA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7D9221C0007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 7o6cgqhk9ajn1ge3qtzp8frnygg78rs3
X-HE-Tag: 1794521382-62540
X-HE-Meta: U2FsdGVkX19BoZw6w0nRn59cdq4aISv1yUGSB4F6unTJsrq4vXB7dFtPNUwap1EzrYGFE6rTvW/ox3c9pr66HEtufwKAlkYfGbSyKu8Fh3hWuDKog3e4M+5z7PW/OXfkloNMyX053dBaH9yoLNiEC4VedKxJWmnLfinZc0wrZmN8T/vyY+R5PCqD9SGutAl5STgs238NKrNklG02vRJcD88GLi+aeUnvt9f2a6SEEd8HGyn7SAaEF0PpTumoeKuokXUagAdgk3eIQI/hApAVapAG0pMDYz5ti7PctPXi3N+V+hIJeA5JuXP8hHt1YZ8IkEprVgc+nHxLQWEW7Wuz08GSGloIMxCDBLzvVRYrJwbadkku8NziGEHpgUIrczybMl8KrOTiTeHS8EThoLGPMVZkYFwAlC7vGK10XQjHDn+REPWbfJudVdeD8RGPvqjh1LxKI/88EkK/kU4z4iN5kFebnJgLa77oXXWLfdAAbFFyUL9xW6SYkhNjmNvTukSaTx0IH2Tfh3My5cWuUPkIV7ciJM8QuksduOcv2LpG3ysvcExcXS/7y9k4m6b1Ma6Z5wd5b0M83aXdg7J10OSNCDoLjUIug+AVWjdnFlp8n6CEp2JNnY2t/5nmRQQg82+5O8DV0kLAmXj3j6xfHuDASdeA29mV8uJ3R8PRcVKrusgyJA5VGiDp4dzhcma65NmT3E31kAVwUH5pFTBfxpO1oe0/BxbIPxiZhCVNQBkIfRnoQTAWNDVqEPS4y6cNRxxopH1hVvQC/XTMGiShcfb4p/dVXDyMXTNYsDSoGBbe8g2xbWzPwBSBLew2awtao03hRltMS+q1eYBjx8zpk2otK51TSvzPO1OFgz2doQuh2+LJSo7gk0swQt+OiYkKNp2lS8mvHxx1MgJPnT9kXVKSNMCCUBCf2kkV337ppl5L/fq9CsjYqHiyYzmbakoj0+UkXdwq6TxFDBMzNio+Lj1
 fvaLv0l/
 2RobgMbY4CiktJXwssmQky6055v7Z0cmJlrgOZvzikJGuGo2KTGSiEL/kCjSM1oV88YuXbyUBtgI7OQAWenDtaBkV62T4ke6RoV/GVxq/Z/hdddEvV3UD/mwVDyu8NSi4UEUsEmY6I9jrAqCvS2b5JEloWbau9cjpodqUf9b3ONrNV9mTKTw5xCSJAZqLC58v/3L1CmKMXe3txn7GvihEIz/XvkZMX5OV2bfba8UvM/AsBYOeYsJYTuLewo4737ZOFJQlX+C0+ebcNWQeg8mKFdegf1BOadh9N/nhphpEEMlxD14n8TbOyKagGtWxJzoDM6Jg/zPtK+uaP0tfMJVU5w/ZmwBfhVyPjQMA+VmC/20cL+Yh9QqmTYOc1Q==
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
2.43.0


