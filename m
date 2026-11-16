Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 446AE606A32C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 07:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=tCIyRPTC
Received: by kanga.kvack.org (Postfix)
	id 6A33A6B05B6; Mon, 16 Nov 2026 02:14:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6536D6B05B7; Mon, 16 Nov 2026 02:14:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 591066B05B8; Mon, 16 Nov 2026 02:14:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 41DB46B05B6
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 02:14:04 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C97A1A86AE
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:14:03 +0000 (UTC)
X-FDA: 85440117966.01.CC44A5C
Received: from mta0.migadu.com (out-217.mta0.migadu.com [91.218.175.217])
	by imf03.hostedemail.com (Postfix) with ESMTP id DF9A82000B
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:14:01 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tCIyRPTC;
	spf=pass (imf03.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.217 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794813242;
	b=oZn/ZL3GKCyQViGbrCrwU9dZeLiMTegsirt7Z2RESUZlvWeftwrVxrQRySbm5cBrc9G6Fa
	H5m32tDazjinh8ZognB1bUL+T7oGWFheTJ0kC+2erVqlZK/L/2HrZICohh2oFoHnWanflK
	lOWATbyopuJ50COtG5U5RhZJNr8jUMU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tCIyRPTC;
	spf=pass (imf03.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.217 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794813242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Rz7Bn484kYxpLy98US2ixuVoAUb0FWfN9hJiW5Fifg=;
	b=ZeZ/Ez1grBHF2V/bKl0BGKV3FkgC4jmLRri1QIEpemrqGc5JgtmHCERwEhVrDG1vD5l+Z6
	FTEy6DcZ23lIFGukg6K8BfcGSKYwKqZ2c7EQde6y97LZrOXQfPv1+nDH80NjtngiTLGqE8
	CMoUTw1kqkaWlc/zpNdyjbtzUn/O+BM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=4ajKl1LXghEEqa+0NKeoRTLoqb4UzlZy/QlTAAykkoM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794813240; v=1; x=1795418040;
 b=tCIyRPTC63xrH+q0QBT8l7u9/woB2jGMhy/+TZBX0fGRcXnQYwaeuZH1c8ifb48wf0bZGmaU
 MUDtWgWpzHC5JTwJj7ig3NMGjBht6n4hRXay1cde0/EUVwo5xjr0e9DRXl5SDFsz70yR5ONPTdp
 fUbc0a2dlWcnFkZeSRP7zYGc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 98d69bef93d5ff80;
	Mon, 16 Nov 2026 07:14:00 +0000
X-Mizu-Trace-ID: 98d69bef93d5ff80
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Dev Jain <dev.jain@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>
Cc: linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	Hao Ge <hao.ge@linux.dev>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v5 04/11] mm/vmalloc: reject an unaligned range in __vunmap_range_noflush()
Date: Mon, 16 Nov 2026 15:13:18 +0800
Message-Id: <20261116071325.263682-5-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261116071325.263682-1-hao.ge@linux.dev>
References: <20261116071325.263682-1-hao.ge@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4m7x4wt1nwsig6ehxdhe5z87icyf9q7s
X-Rspamd-Queue-Id: DF9A82000B
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794813241-28983
X-HE-Meta: U2FsdGVkX19sT+fvTOI9CbYxOOAESmTqqCxm6uJIU+Me5ECJX3DDFnzt/cAl6a+dSrnkvP5dR9qVkTJVso1IlaR6A9KDzaKeIttTXgO/OLZTsiWzILvqJjbprgvngRvwotmjVZBUs+DXN1XJkrNPBzrJP/yjSS7tCF58Vz+2KCOKhydYe45VtAJSXr+FYinjs1pO26hsu2eum0b7iryT2bQN5wI1r/mfCE8x6QXWNJL8XyNlKYmMsQvjW7B1hruiKewN+0XuUEkSExy3d72JROh5QzFgXOVdjaoudqpnkhhmfjcoiwHMN9UDZoTz4kzN8JPH6y35+snfeTOZs0heUqER0xGk82QDzAI5DPUYTvQuaJnKj2u8AOOwG+biOe5QGbU+zPnqCFrkrODvl+9rXIj1LGGiL9QMOsYtW8jcAn5eTpBvXYVEw+Nw5Y9vfmHqoIuXJciuu0a0lKDQ4F3RVTveozjamXT2DLEXA+n7CSbMqTfE5PeL0DK/pkR5/VYeW6AhOZ1NNciLCTPsDRKhf8TZ1HvmMjqKnaWAZ920i26AkPZdfChKH3Hf7C7i42qgOJq7S9mPGKpZghknPbf1ddnxdPM/9SkpXrmETrFNzPb9vnhjhPQQYlXKqfPgv66FsBzeerZtemrPBJ+79ErxfeZxXopjCodQhd1k2rMUDhMgybMsBBAGi8DTEqwGo6Bu6Y18QCFHXysZI/ImvnVFryyBv/ABlbsjAgRpsbaNocoEk50hBCk5bliq+waXuJBodtLFOMnVXv9vJ/YW14csksWkt/DRtTf0Qh0ZtD1MW5xSfN3+zlnL5dm50jCpjmbtVpeeE7WQsRB1siAHzlfiej+AO5WiagfrSVaxpzA8KuYgq1OzxU4ktSjujpNS6Gw0ErNWfK/4t4r7tGNVpJNmuSTPMUHXp25O+vlT6gjhyzkzG8LXSY6gTWFmZQb3TnUAsJ0Q7/rlQfxHICya0sg
 xMrAZ3h+
 crNryA617wJ6VlvnXgGtmr78McXiC84R2RpaGHj8tkKZywl6BLtXoWFZF3CBR2xaGo39pE5z12tRKETLbFgo1Xo7dzb7rce1OYj5MOyuIYrgI7pF5w7nQwHPanuuT+DacLo0EKbfqh+8XduQ/0WiKtGB2lXcSpAseg8/79s+Z5cTnVy7HrobKxcq++RvTloQCl+URwOoVCtwQsD0uMH+jqwrK0ty58ChmLQY+WoOgEri5XykPN+plJm2UX34sVbW4u4OcWYz0sowP9VLtxIsvf2Nq7l57hH5OtAvbZFck6mrSPqOlGiFcPInxPHpBWHemlr3CzXHout1qxSCM8NoKiVaqI57n3rAoMX59QK/bp7FPBio18ggJYHefaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The PTE loop stops only at addr == end. An unaligned end is never
reached, so the loop keeps clearing past the range. An unaligned
start clears the page below the range first. Both are caller bugs,
and the damage is hard to attribute afterwards.

vmap only installs page aligned mappings, so an unaligned unmap
request is never a legitimate teardown. Warn and bail out at the
entry of __vunmap_range_noflush(), before any PTE is cleared.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/sashiko-outbox-178439@kernel.org/
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 mm/vmalloc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index a168f6f20f4f..e2b63cb1592b 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -523,6 +523,9 @@ void __vunmap_range_noflush(unsigned long start, unsigned long end,
 	pgtbl_mod_mask mask = 0;
 
 	BUG_ON(addr >= end);
+	if (WARN_ON_ONCE(!PAGE_ALIGNED(addr) || !PAGE_ALIGNED(end)))
+		return;
+
 	pgd = pgd_offset_k(addr);
 	do {
 		next = pgd_addr_end(addr, end);
-- 
2.25.1


