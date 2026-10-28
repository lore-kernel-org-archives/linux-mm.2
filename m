Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5802660A261A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 21:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=GsTrEEyF
Received: by kanga.kvack.org (Postfix)
	id 5825A6B05B1; Wed, 28 Oct 2026 17:19:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5129B6B05B5; Wed, 28 Oct 2026 17:19:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 338306B05B5; Wed, 28 Oct 2026 17:19:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 09C896B05B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:19:38 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7587D8011D
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 21:19:38 +0000 (UTC)
X-FDA: 85373301636.03.DD6816E
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf29.hostedemail.com (Postfix) with ESMTP id B6D15120002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 21:19:36 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=GsTrEEyF;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793222376;
	b=kTwfjF7+FEkS86xj66Awcw08JgpUq3O9z/UTRkAOu+x872rn5HfSLn7FwKIOwR8BLHlOqL
	mvZR7040gwe7buJVaSoqWP4qJV7/BFDkY4GQDmFmgOEk+xb8/FhS2gRYmXhPCJpd8uQqol
	7g56x37doa2IZaxo1BayqOMqnZhBPcE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=GsTrEEyF;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793222376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PNVblBHL+6qDLjWQDk2wT/AjEGUD/LVbbIDhYzYguRI=;
	b=UxuNZ/dwed12GSXum64lwny4AMMXYF3jeaemf26ZV0s7Rsy0k7TM7bxx/Wg8g3ZhFcdwJ5
	FFyw3zghF28T+PrWlcK3yOSk+qmfsoAETmHUUT2OaBPbzdXMR7RJDLQZE1T7flU01Xtr8G
	9yGkXoWkkOXdGdezF/0CB1WB7Fw2hi4=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-5364d86f7f0so20698281cf.1
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793222376; x=1793827176; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PNVblBHL+6qDLjWQDk2wT/AjEGUD/LVbbIDhYzYguRI=;
        b=GsTrEEyF4m+VdaovxbKTVL9Z9V71DOYmxR0eqNm6y0GNIj08cU8jLe++pIceTSNgIh
         bdZpuc8sUc6ynrMt1gjiTgZjOQJcuOB9ajUeY9xGlHTpbwDYzfAXXQLSSFoeLaCl8Rdt
         y1s+m/5v+EyjFYnunYQgvexYTGp9G/LeZikSOEpImjmSVE2FY8iZYCRJ5s7BK+kOD0As
         sJPNYQjD3VSZSdG8cbPlZYrIqQ16mkdtvEBzIQTI5VRE+B1cEkHqydTG/aJrWKTPS/A2
         38k0APEhNOKyLBVX0T881qdDm0XNq5HFqbbrAq5BChWF6H/ZgucRd0aocN3rESq1kLqD
         FGOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793222376; x=1793827176;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PNVblBHL+6qDLjWQDk2wT/AjEGUD/LVbbIDhYzYguRI=;
        b=S/+GskiyiAInqg7XiY/JM8ykKbcctRaOKsWnQkOt6pz2y/8Zr4Pu+F8HtHvABon/Dh
         oa83Z1rP6acoMA/ea1ZEteLIpQKuV/EATygAeaaqyRk7OxnzKotPcbSDKIT1ZfSoUqKO
         NGzyVxLRmPTlzpS7NbQScXBHk0fS6WeTQ+Akkj/V2Dmr2vvI3j47ZYnKPtRn4+ZLxqll
         GNfVx1uyLJB+voy5DEFkIptkFKwh4cUuF1gZWRP2gZV2AF69yCeXfWPoasigV3GkDuVx
         wQS7CQ6Z3fzn5WnNjT3C9iMCAyxwptM3DImgHFHD6RPPsfpAlaDtvg+xQ5rHHJOSwxX3
         bdew==
X-Gm-Message-State: AFq9FYLPEAmUjTRBBTLtVlluFDmzfi5vcE1aWMRGA0473v0tg65FrFmo
	XXqJtmyeejSWltf7AjUlLv/CHU3DYohvxMiowFZSAbj4Kg6Ji6BXNYXbOLmW/MbJLo0Jkd9hiu6
	7Dv/ZBXs=
X-Gm-Gg: AYBFou1y/91d7idTsEnoXQZhj3f8YRbQszvv2y2NP55oTmT4+KpMcE472tkWlkdT446
	JtBQD9UhiY7jBqg/rD5aAeakyoMlmViA5enlw7Mi/qVUn+IymlAaxLyF8uwgbQMj4SWAkzfsgtg
	GX3GaBPJqvVAHL5M7l4jkXEs0Dgza6JB+OFqKu//1T8jOi5NL0bRDl+awlFC87CuTve2/JZL+Vr
	2mQ04/6NMWGqo9Ekf7uK3y4HZws5fN1dtoKTQiknsxHDZQomtBPHO9NbqkycwiMhp+0Bftps+2s
	HmnyyYyJ+ShCntpELammfonyrgjKsjdoTQqg0Ij5VEvUZ8RtJXK8bi9Q9X7gJgNigz1v95hAo1I
	sUgSJ1gEjCmgiDm4W4iET+I4YnuGsaWPgI8rdwuOIBruI3nIk+lplhPn7LYPdnFIHt/Pw+GSZcx
	+uSE6aB9fmvxRYLWpFYs7tUb0DYrqXbNl+ZS2shE3SJSP7GmrwVcEeoT8jPJdhux43WsWhFtRry
	pj4pTU8s39yCEkL0NStcow28e8Xno/zV1dLgV8iaMFuABqS5B+U4meWrsOSB9vBWbbwAq321SV+
	5j9ZtOp2lB5S1H5q6ggFd3HElr0ZzaueNgXIqGaJDorxkuijl8OaSRK+McfiNaeBzMFz8xYfm1Y
	cxoBLT1oNKpYlsU0=
X-Received: by 2002:a05:622a:1a97:b0:536:1f7a:610e with SMTP id d75a77b69052e-53fc8ac8719mr64026671cf.6.1793222375961;
        Wed, 28 Oct 2026 14:19:35 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47a6d598sm139778966d6.3.2026.10.28.14.19.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 14:19:35 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org,
	gourry@gourry.net,
	ziy@nvidia.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	mgorman@techsingularity.net,
	anshuman.khandual@arm.com,
	stable@vger.kernel.org
Subject: [PATCH v4 2/8] mm/page_alloc: detect zonelist rebuilds from memory hot-add
Date: Wed, 28 Oct 2026 17:19:24 -0400
Message-ID: <20261028211930.3504634-3-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028211930.3504634-1-gourry@gourry.net>
References: <20261028211930.3504634-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B6D15120002
X-Stat-Signature: dus3h7amp5ecfwpnnqmij9gxuxyrjpzu
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793222376-743730
X-HE-Meta: U2FsdGVkX1+kBSbx9CAd1uc8+RUJP1NbiZsBLahqIoH8K8C9SOeOXXwVKmoBm8BlbvYIdqPP9KaFFHuZnRdNpuS0N+P31uU99jUmmMe6RdNW9i2x9o8X9glhNeiS+CyL7XjDhlJiIGygJ2DgXHjMJ+IRyyx+I8knAawuAuYhWd7tVOahQ7CETFG8nqbrcGsySpT1LjMLqeT/63K/zwYyEPBOfniEhZ/mvc0j1k3yaSGKU8onM1h1zx0MICVwArVhmuE1zj7doBIaavOHi2CzSi4mvs5BDcoxGmeoKSruTGEnFgWoUHO+wFy1yrHl6RChO4I9dft+bvsVl8LVQNwqIikV2WiWrmYKTZZG61BrA/aOtXV9K38z2vOT68Tk43jT/BDfQ2vC1Fi5ksJjcuNO+3SnTCmMUMxS8T6Ae3ZYc1LMtJgw8yO1gku9ga2it+JS7P/rvT0aKvoZXcg13/axqQp3nYm2ixmTQ62CezfJ8CNJGA/kHCpWLgCZJn29g7PQITp0f8WC9eYRgZfkVC/DvUsaTrjgOo18J6/qiN2FKf6cxbiLG3DcyReWOofbfNtllm6L+48LoZwCAA3LO7ELDpKYDDquhaueQN0dINP5FTprwzXD3xdqGgUKaQgH5yHNVFJQH6GN98gQpuXpyvhIUqXLcZttSolkXTPCTmvn9VJ3kBptrjS4eGzBAC1GcQNem3aSBfo42NT/4Hllv0O2tyiTTUiD4gfXFHVxptezD8F5fXCgYcDSb50q0lO3m3OV+7Ey1I7ZEtCKPLx7j3zOTE64MfKzR9odGUiIfuKvwXlxOgv9wYAvx5D00AdSjpntuMFeRyMq1daXLF0EVWz5ygYPUqSgi8GV3V0i0Wr1uLaCsdABE9/Vr1VA3DybcNAjmnhy11jehWKtxm+hmxNxQkcRjsUoYEr9TQfkVIhrD4IxZSkmJeGDEfntSMc6PBx3XqYI5CXSJfg2l2E559Y
 Vj6445ws
 Yv/KR3L5MCc/pk1Gz6BPIJ320L0Ejt6ozRXByeyRJf8SpUJfDpqHQ2TbMhvWcJAx521C57u+mUZQO0QjZNEXYzv5ayusHe3y0BeWH5VTHrqjiZeJdp/NAShyREWv6WvNSMEmtmd9LYdI9/f8HbJ/NnBakSh/XNWOtoCwprz+d5p3KVjTctmtYyWR9r3b+6nHITCDHUl4A/6DCMtdlkrScMS7HYMjg0FYeONG2/tiKIxiVb65UT7V4abEwk79zfr3KxeQNd2ImHS5pyi9KLZH8Up1rPp7jfdyJFgstW0uwsXFoogDqngDesU64X1lCelMVbFH7VKn3O0K4wuoo8beqPkpZRmh0VroWoVRA4vKPwsgoFmuC08604GSOUINhy7Xzt96eB0UTItpDCPmFIJHkA2FTQ1430Tky3fxcbbD64iPGFo7KUd90ZY/5zKCZYXG244gN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The zonelist_update_seq retry was limited to CONFIG_MEMORY_HOTREMOVE,
presumably because only hot-remove takes zones out of a zonelist.

However, build_zonerefs_node() rewrites the zonelists in place, so
onlining the first block of a zone shifts the entries that follow it
in every zonelist containing that zone.  This can cause a spurious
allocation failure for a __GFP_THISNODE caller.

For a node with only ZONE_NORMAL, onlining its first ZONE_MOVABLE block
rewrites the node's ZONELIST_NOFALLBACK list as:

  [NORMAL, NULL] -> [MOVABLE, NULL] -> [MOVABLE, NORMAL, NULL]

A concurrent GFP_KERNEL | __GFP_THISNODE allocation can observe the
intermediate list, skip ZONE_MOVABLE, and find no eligible zone. With
CONFIG_MEMORY_HOTREMOVE=n, check_retry_zonelist() returns 0 and the
allocation fails even though the node has free ZONE_NORMAL memory.

Gate the sequence checks on CONFIG_MEMORY_HOTPLUG, which covers every
configuration that rebuilds zonelists after boot.

Fixes: 3d36424b3b58 ("mm/page_alloc: fix race condition between build_all_zonelists and page allocation")
Cc: stable@vger.kernel.org
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/page_alloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 78569ac6f2d9..52533992ea16 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4404,7 +4404,7 @@ static DEFINE_SEQLOCK(zonelist_update_seq);
 
 static unsigned int zonelist_iter_begin(void)
 {
-	if (IS_ENABLED(CONFIG_MEMORY_HOTREMOVE))
+	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
 		return read_seqbegin(&zonelist_update_seq);
 
 	return 0;
@@ -4412,7 +4412,7 @@ static unsigned int zonelist_iter_begin(void)
 
 static unsigned int check_retry_zonelist(unsigned int seq)
 {
-	if (IS_ENABLED(CONFIG_MEMORY_HOTREMOVE))
+	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
 		return read_seqretry(&zonelist_update_seq, seq);
 
 	return seq;
-- 
2.56.0


