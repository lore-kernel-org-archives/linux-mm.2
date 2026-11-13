Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A3BE606A330
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 21:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F/SJxPUK
Received: by kanga.kvack.org (Postfix)
	id 41F016B05D6; Fri, 13 Nov 2026 16:47:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F6516B05D7; Fri, 13 Nov 2026 16:47:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30D046B05D8; Fri, 13 Nov 2026 16:47:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E7BAF6B05D6
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:47:41 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7B715A78D5
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:47:41 +0000 (UTC)
X-FDA: 85431433122.28.D66E687
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id A7A6140002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:47:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="F/SJxPUK";
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794606459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EVGtKF6FKpBC0GQJpLurENXUpqk/PqZHogG9Hp2Cj40=;
	b=2uEFWSh06ksqHJUSSpXLIBF4Cd3L3aMOsE5t9oa4+tcIpGalCm/1dv+dHDKQuxnXvpz2hx
	RbmaJv0BDJ3315aR8iQmCTQwOltECRc6Kh3w1L4EUXUEcJSuGSenOMwl6zabplOdRPW9T+
	zd9kp7cNDizMFQiiMpgqSW+q8rVMACk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794606459;
	b=UQ9sBWaszmz/X+8RUesGKkj5+JBRDIConf6ap1hvYm9Z/lJocvSl1754hMo6/Iyjg4r+Yf
	xU+RqfVtIaV8fN3L7Ife/cblH4AKOt+/6/wewawg0pLiplCNj9byai2Z485QftDYbmE5sm
	qb3z52MgZCrouL2JpiFZGPbPrOB/My4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="F/SJxPUK";
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F249F46821;
	Fri, 13 Nov 2026 21:47:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A00381F000C7;
	Fri, 13 Nov 2026 21:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794606458;
	bh=EVGtKF6FKpBC0GQJpLurENXUpqk/PqZHogG9Hp2Cj40=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=F/SJxPUKsWw9KwD6IhshhUpHjW6DHQkRPGFOfRnB+uMTJCuqi3lh9o8CkpYnXqZ5D
	 kzK+WAmMR3/5AyZ6epsw2P4kUpiADuP3MqDbhkDChfX94ogsgCcIXm+xuk3fT49aDq
	 yAztse6uk4GBW0X30ShIdtgRBoaB8FbeX4Oefc55jdTZAnQEZJfVp7A0yyMQKn+okC
	 3Uq9JEJrEBNEV6yCYnPGGf3NPFg8+YsRlA2crfzjYVouGPx6BAu8qB2XPJduHjxzaQ
	 XOzJrI0DtOUksjmqflimCbau3dGdkpMDFnUzzdspcWdQ3YT2fhiGdFw2vkMcC8ZnfC
	 GQMK0vB6NFb+A==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 13 Nov 2026 21:45:30 +0000
Subject: [PATCH v2 12/13] percpu: search the whole reserved chunk
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-mason-migrate-et-al-fixes-v2-12-50a2ed382b61@kernel.org>
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
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2143; i=ljs@kernel.org;
 h=from:subject:message-id; bh=27veALNSCwRMr36dOVr3JSTW+zu8/EiCuojiMwW/dj0=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK+t/zKvKyy4bL4m7Alhqfv7PI/mJL01mCltpBt4Z3jN
 5nN9vhKd5SyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAi/y8y/A9e6Cy0vjXu4a+s
 My/VnQszmGKvzg4Sai/i2PXyd/BdIWmGfwqsNqEhyXFcFs/WlW484dUoGi1vav7cR/vbJrPa4Ge
 /OAE=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A7A6140002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 7eg7k16wfxgbjtrtcdf5onfmqigakm8i
X-Rspam-User: 
X-HE-Tag: 1794606459-10022
X-HE-Meta: U2FsdGVkX1/XV3du3581VKoIkIzQJTOCddXJX/XlZHgxImBBSyiwwqGVoRFw/B74EQAS3WkRHtJBEyZnF94XcmkoQ1R+0GNJ/iU4SPqajhnvhmdzA/cUxFANS8J9hNrTQ0ga07i3rCPJx5rLwVtwMl63d98VxbIqtXpT15W8bLSjbLw/qBVQvWy718JODQRyBtNY05hVsjPGlLUIt095VTAnfK02o3lmnInCisCeFkNAVFAuvSW6T4tSezKBXSXqOyaT1pawqgtI0lyVpQUMiuuBK3ttVDR2If9xIFNAwxq78iBm/Zl2DtFdf4Yo3oUZVYGgVvii2NPpJH1TMqf4GKmPSPSseU4/lVyga5j/VM3cC6aaqsxu/4My7VQtfzmHbyb4Rx1BPg8AYvmz/dO2DMfnI3KlKb8BHVhotSkBMNsTGSJ1oIaVjJiMDV0Pa+cVcqARvA6TKyEiZJ3+gydnMZLGgKruxzTmwB4eXqM40uxLmdm/vFGM1VYanW5/lMjnklFADpbLbNaWDlJr1ZSB6pjwt5qezfYmPnoM4GG9zB96A2ym7t06Ob01r0nguj9FtZcos8nDCNqTiIg1ptLY4T4r6bwbFgduyhYPUTGmyfIv3hxn1ZVt4iV1IONEmYH4bcsPRsVc4iU+9gdbxvtIik1ti1uXXBSHIq/ssi5P/fKcoTYTfQRfcRog7GNVWjIi26wfAjuJWFPsVnxOXEOR8QMfziU08XbuQpAYTY9+3lWVZJBQJwFasr2G52BNlCB7IB+KJP9IHP+pRaIASkbJ1tuswA1QJdWT42NugRfGlWY+fuspIXwF0i+Y9q373YGS/gh2VjYf4GnqydLI+vGCmDmzhKgZhmAJhZbaVf6BegnKhj4v30a7jFgs4QxMs1UAjjWQNcJ/36YBK1HcisMbrDvFHf+DftQ92zYyJ+uVobr95pA5C0M4bOVxfIjopkk2lCopuSqusd6bUD/XPX7
 +T3BetIf
 wSOKW6jDZuHkN7CnDH3wJ1XXkUcrBUIAaMV6hzXuZizwo8ZNx3xqW5+CeEjjc55LpFUdf/Y+HLoj4G+zg3OEaacHjz83lt0ttSDU/01E0+M+TMM4U78UIaqOKtRRem9QxV7NVnBGBYs/wVhJ17yPads4aIhjUkPm6UlXXzeGQXRxI42v+BcGeH8D296Iu1JR+voAJSJckvma8XhbBXlC4eIOUZuN2Eajjnvz6gOpWQ32uVUFTWCH8URdIsjhv+rIVZPQmS1cSYvtORy7yXagxPicePuNpFMtzycrLFYIodY9iWsTx9qKeROfERnKGeOiKdHI759pvtV169a3p8GEZP88YAE2mDbweCHJoKvmvNMiXOhu4loxvyPRzpNylh38gdLaI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Loading a module with static percpu data can fail with -ENOMEM even
though the reserved chunk has a free area that fits the data.

pcpu_find_block_fit() does not scan the allocation bitmap, rather it
tests the request against hints, starting with the contig_hint of the
chunk, which describes its largest free area. If that area is too small
once aligned, the search gives up even if a smaller free area fits.

Consider:

    request:      256 bytes, aligned to 256 bytes
    contig_hint:  260 bytes, starts 4 bytes after a 256-byte boundary,
                  so 8 bytes remain after alignment
    also free:    256 bytes, starts on a 256-byte boundary

Ordinarily this is fine as the allocator moves on to the next chunk or
creates a new one, but the static percpu data of modules can only come
from the reserved chunk.

Fix this by searching the allocation bitmap of the reserved chunk
directly rather than using hints.

Reported-by: Chris Mason <mason@kernel.org>
Fixes: 13f966373f92 ("percpu: skip chunks if the alloc does not fit in the contig hint")
Fixes: b4c2116cfae6 ("percpu: update pcpu_find_block_fit to use an iterator")
Cc: stable@vger.kernel.org
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/percpu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index dfd3ff0a1ac0..f87813e6ad73 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1771,8 +1771,11 @@ void __percpu *pcpu_alloc_noprof(size_t size, size_t align, bool reserved,
 	if (reserved && pcpu_reserved_chunk) {
 		chunk = pcpu_reserved_chunk;
 
-		off = pcpu_find_block_fit(chunk, bits, bit_align, is_atomic);
-		if (off < 0) {
+		/* No other chunk to fall back on, so don't rely on hints. */
+		off = bitmap_find_next_zero_area(chunk->alloc_map,
+						 pcpu_chunk_map_bits(chunk), 0,
+						 bits, bit_align - 1);
+		if (off >= pcpu_chunk_map_bits(chunk)) {
 			err = "alloc from reserved chunk failed";
 			goto fail_unlock;
 		}

-- 
2.56.0


