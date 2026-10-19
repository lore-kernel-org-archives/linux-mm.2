Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E1D4606A31B
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 18:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=qIYSytT5
Received: by kanga.kvack.org (Postfix)
	id 2AE3F6B0340; Mon, 19 Oct 2026 14:49:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25FA16B0342; Mon, 19 Oct 2026 14:49:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 175556B0343; Mon, 19 Oct 2026 14:49:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E635F6B0340
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:49:01 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 735DF1A0825
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 18:49:01 +0000 (UTC)
X-FDA: 85340262882.02.9C82408
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf13.hostedemail.com (Postfix) with ESMTP id C63AD20006
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 18:48:59 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=qIYSytT5;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792435739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=LLSI7PktqOCoaAdY+nRTbxlJri6KWY7IdvuhfDd+3gM=;
	b=ts8WUaRz8H/E/dwZ9SBcm+LNDkY67SfAMJ6quLfHVCzexch0Kzkt81+vcy2GXAdYRzttui
	Mc0kVb8P8eXpZpLHW+hYlbSv9COikAaorg3raz697lsKcz0hGcGqMzLMImZcNB4UNmJPkT
	Ld4jb8XDJBSJfeeRqY3+uaelaKFhy8s=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=qIYSytT5;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792435739;
	b=mdkMbUqU4LD1If21r9r4EPZrtaoRmPK4Fc1ookExU3jMKgQLz9GmIZs0079zOaxmjQ5xuy
	Epco2ssMFmfFbNjrQxZjbGk4Pq/aUtokU6vTD1RUMWQ7DoERyQvzP91WKFY6IxbcyNksXG
	f4JuZ9L9gf5sdWClRajZK9oaUkAR1NA=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-53512cd2f85so27937001cf.1
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792435739; x=1793040539; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LLSI7PktqOCoaAdY+nRTbxlJri6KWY7IdvuhfDd+3gM=;
        b=qIYSytT5LBW3lzPJPCHYvhcm9xlffu6sY+1iZt70/BlHZEodwdCg7kJXZkztAsoeBt
         OfBarnX/8Jaxpdjqd6oWHA0XbdIoCLc6aCMTnw9MBF1IUhhv37Crhuui+9jDzCAE7upq
         vJM8+097hOFoCy4JugVIV65MYLku0gFzGFeO+hK5Mkxqq519aDJmsAq9Od6eO31Vh98Q
         HhMCKtbL71SqQ30yMrw7fhUqoAB/V6quvYqISEW8xb5FkOTn7GEwj8U17XLHogqDOCtL
         9jIGeMdKd+oZ0XbYfXYj3Hm/wzIhzzCQcEHi8GIx+477YQz1cBn8NCt04elOlTmG2Pp0
         csPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792435739; x=1793040539;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LLSI7PktqOCoaAdY+nRTbxlJri6KWY7IdvuhfDd+3gM=;
        b=IpjZE6KBYUG2WZUB5K/Xu5uZ82GutatH4xXojkLvYYMRD9HCcFqROqABzM9FvfyNLE
         2vsfFJzgL5Y1Xi2tTlzdz9CM12+coY6vN0GfJEdKScGTarFe+0u10owpFiNy4MXkqRuU
         +4gD5OpTU1pS3BTehyvMQlKoTHyh4ROKMWbw0FsFKxrD8iLtkGPb+dYyTQ4PB3TvXUen
         oAocemf3I/Vr49BfEhTb4k/Bsgi8V+pHOmSJBk408PP89xPYp8a5NE8OMbHHk3p0+76L
         fzHAElOgmM8GuqjANgRG8J/Q2FaGLtymndBGaVsOeU53I0rwdaf0GFoCB/A2gJ/THzj1
         vHNg==
X-Gm-Message-State: AFq9FYLYdelrfAw+DreHECH9/+uNYLx1YOjVCVGwjBJsh31kVkmb7rXO
	pyawUh2kP4hGFOQZP/lQc9RrZboDMFdiPEpYSeA6baWbv8UeUWWftNK2E+5X1/w3b1Nb1a4iiHo
	RZ/mP7Zo=
X-Gm-Gg: AYBFou2xCMntuwZuqyeewEn6hZoXEqGmkvV8ipZmDKm9r9Apkha3ZYQeIUdEZwEenHO
	8qYwpIu2JEhdPBMiPjrElXsk80/YWja44KRKHp8BwevwOJSVqILhuVxD4jDKXBcMj7LeiG8AozM
	sqnNL8BP+7sAsgepsAz427IkQPKZFyZjkZOQTIeiKnaOYtfDDH6tHvo/+h4Gigw04ueclgN+WK3
	J77/RApOkM8Jmlg579tFLEecjHvlAq1HCnOJ+eCWgjLhePS4zI4T3bkxg1UNdgT3/QzSZ3/3GXT
	/MsvoH3502tdPUECZ4cJmDhGJNgecy/opZUJK6mkoMP9qScP+2m+Fyj2cMRId1ADVYFo7K6KLL0
	Htpi6R5mqnPHg6C5QOYrbLre1Q3z3/SJub/V+MmhTczdqDNLkYA0T2dRJp5P7IySHNNlrtMcb+G
	w0lRVsikfY0Tuv3M40AYJAaKh+m+xN0UzArHToXQCtLKFau0ABqYdpU+25BkgsZC225uTn37NVc
	oi2c9jbsls7W0S9BnMLCYDm9kQN9PMcvx+CN8tNklQvY0S7Qs+mOBwe8tbR
X-Received: by 2002:a05:622a:401a:b0:536:5e83:589 with SMTP id d75a77b69052e-5365e8314cdmr96885911cf.71.1792435737103;
        Mon, 19 Oct 2026 11:48:57 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c040a49b4sm3183196d6.24.2026.10.19.11.48.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 11:48:56 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	flyinrm@gmail.com,
	stable@vger.kernel.org
Subject: [PATCH] mm/page_alloc: let the highest memory node recover from hopeless state
Date: Mon, 19 Oct 2026 14:48:50 -0400
Message-ID: <20261019184850.3427905-1-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C63AD20006
X-Stat-Signature: micqwn7gspszk1xeq4u989gnpi8r8bw9
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792435739-524830
X-HE-Meta: U2FsdGVkX18z5M+r0LWT3w/SrWZ3Df6l6HQe6wy96v2YuoZsMcBLcc3cNC5FiUJcS8u5UIhTjTkU9opwRpbXG0bEuvlYtUi1ks1+DDOuzBhDshpH3V/WOToJwcP6vLQTLJ7KtlZsNkkloFaciYNzwE5n7NORKpHs2mWiwnkQWcwiZUY/+1RRYjNTS5BnbCI3EqwRburbpe2MuyHNsCi966QCcFdDiWGY15k/dPHY6A6hocL2GSuaKa2YdBue7iPe0oJ34tijQ3xAykkGJWTX9NZ+S7AZwCLP8PwtJ8nGlcCmx0+59CkLmJDdQsZDJV+MEvkI1r9plrSt0jZvnEygLoyKVE/jfdE2NGVR+NBIhkwJruxIjkpdBN0eDsYewXrl/Ssix2XiJ5PE8ikI8LFO+SWm9bsbCoyVq8EfCM5hidNdpEquT1z/s+Q51bgGEw5ao6YXPyLAnJzwOgzEbLce2iKlUNcdKPe4WYnj5P3aN+NpVZ0tvcQ5/k3EtcYQC5XfaVBO1QUy372zeDgOd/PEjEd5kKXkSoE9o5Tj/vK1T8+/OMTC6O4D4723T2+eoy9NHjudZK6zJBzrFLGheGO2ej09jSwapAd1UZXlK74D1WfrkyoESPkhmKNrAT0PKWQYFhODIYMhpWtOupVq+dPl0bCYwBv2FHkJHtrlgUcDqfwHzzZ1jkrmkcI6cvmPK0LY+tj4Ad5GJ6W5iEILwGJtor8/FRgQoqSfJmqB6BuSLwJAfiSkUgByfF0wd7LBVpp30dhkuqzmBlCIICqS8R+sMiSwfvJa0028aOaPV0Xbecxp0S14TMSq9ynqZrBp9mITARdLh6f6N57Ti3flOoRFzJpIu8CWemCDrKZ4bxH+SkDY6B0NHG9mhVGypLfxInRuY0YXGX1JdyFPXVF2Owvcyp3g5LhcG+YCRJXdhok5yrrdAy6332E3Ug8JpLPjvFPX4aHyBL1ANEDFmLR1NVc
 M6nURTyo
 cF+MpWbCLfiA2I7uBpxYYAtQyR+HPJ+V9gAHA4dpV0Of6ZH5OQ9ZUKn9d66a0K8woyudpnQNN//AWp4XTJOrPZhilzF+fSM8uaspV6u6iO/0TpGzUtgOUFDUXcS23yXjHIC96l8iq+UMB8xIxhp7aKFBRfjrIlaVfOSPrLcWLiSrXI5ONU8gxl3G4L2Q82hxty4DbhE0ClBQMMGZDULZMcaFprdayxKjsxCQZHv+F+usQ9NUtM2H7NoVu70yzdgw9DbOiDVai4fujYm8BXOWh7CX17ODexHtVwzWfMvHMkfSW00hBgohdx+n4EXGCXDrC4Kjsex5rn0WMzAP0VEvNORGUMhb0C/WC99K3+yiHq6uiFWisLFcUNwLXXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

free_frozen_page_commit() clears a hopeless node's kswapd failures once
its zone recovers above the high watermark, but only if another memory
node exists for allocations to fall back to.

The test `next_memory_node(nid) < MAX_NUMNODES` finds only memory nodes
with a higher id. The highest-numbered memory node therefore never
recovers on this path, and its kswapd stays disabled until reclaim on
that node makes progress and balances it, or demotion is re-enabled.

In many cases, direct reclaim many never fully run against a lower
node (CXL/kmem), and that means its kswapd can end up full disabled
in rare situations.

To reproduce, fill the highest memory node with bound, non-THP anonymous
memory and no swap until kswapd gives up, then free it: /proc/zoneinfo
keeps showing node_unreclaimable 1 for that node. A lower node recovers.

Count the memory nodes instead. Adding first_memory_node != nid to the
existing test would also work, but a count says directly what the check
means: some other memory node exists.

Fixes: e7a5f249e6db ("mm: re-enable kswapd when memory pressure subsides or demotion is toggled")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/page_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 417c427b196d9..6d4f03faf96ee 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2929,7 +2929,7 @@ static bool free_frozen_page_commit(struct zone *zone,
 		 * kswapd work again by resetting kswapd_failures.
 		 */
 		if (kswapd_test_hopeless(pgdat) &&
-		    next_memory_node(pgdat->node_id) < MAX_NUMNODES)
+		    num_node_state(N_MEMORY) > 1)
 			kswapd_clear_hopeless(pgdat, KSWAPD_CLEAR_HOPELESS_PCP);
 	}
 	return ret;
-- 
2.53.0-Meta


