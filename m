Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D38E7CD3423
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 21:04:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 289766B00A7; Fri,  1 May 2026 17:04:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 260326B00A9; Fri,  1 May 2026 17:04:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08BD86B00A8; Fri,  1 May 2026 17:04:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EAA906B00A6
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:04:20 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BACDA88C8C
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:20 +0000 (UTC)
X-FDA: 84720079080.27.11C1694
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9A3C5C0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vBUsA9Bm;
	spf=pass (imf22.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777669458;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yyu4g40vXAPAnGnJ8QVhMdwEWFqxWYMUj7tbkGsuzGE=;
	b=fGjTTIIBUIMttNCHAysHtRARByPU6UnMEe7U5RxY2V/vyStYHk7A/AHM/MbXKkSo/H7/D1
	Qch6THQLU5F9Mjmw1rRd/frlGqeq16KcX4IKOVn91lHMel3qSdr3f4zo4Ai9OUIAhHchJw
	uNCkRAqxD9piVicSgklYrEFbbALJTx0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vBUsA9Bm;
	spf=pass (imf22.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777669458; a=rsa-sha256;
	cv=none;
	b=YmsHVJFrMwVEKg2oSiVn0wtv+BZsZ8oWXcv9D8v1/tvlLHHI0JFi0lbwRv4/cMD/rzQWGG
	JTX0EctStgGDN/embNdXfuG9l10GTr4KwM30lSQzK/LRBcKdUoPnAItz/Bks5J0nu0KSUy
	rgMfWQmAwjX15cKz3kt6AGgZu7B4w9c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 66C374472C;
	Fri,  1 May 2026 21:04:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 473CEC2BCC6;
	Fri,  1 May 2026 21:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777669453;
	bh=m5RrhLaoLypBw5aoyEJ47nhbPvpGV8LZ8VpVCX9MAyQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=vBUsA9BmMV7k+paFfpI1TuIstYuG1OuNs5X1JDjpk4jvQg3bCg0jI2LCKfgmc+lxR
	 Bo9FQ+PXCWWOz7X7nom8s+KRzQq0nnqSATTADz9U1CrcV8BcbrLZYRDKhCeygzgXoK
	 x9ojAGH48F+HRcYDpMAKA3bWOxcS1u4Byy3ShljzI6r/s2Fm4XrlTN3YWvif6VJUYc
	 XG0A9qlWUhoV6DBuEGP51+FidhBrITGN4fWouoKuXRSznxn3T+PAWg0fXQoJtAYBzw
	 /M0EinOQQ4MzDMycqCQlKZSdrqQ38VfLKR2olh5kNf8JEaRDNg0bxqWkcPBkOSuQ4o
	 1qH/V3kcxSkyw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EA6ECCFA13;
	Fri,  1 May 2026 21:04:13 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 02 May 2026 05:04:03 +0800
Subject: [PATCH RFC 17/32] mm/shmem: mark folio as referenced use new
 helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260502-mglru-fg-v1-17-913619b014d9@tencent.com>
References: <20260502-mglru-fg-v1-0-913619b014d9@tencent.com>
In-Reply-To: <20260502-mglru-fg-v1-0-913619b014d9@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Youngjun Park <youngjun.park@lge.com>, 
 Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, linux-kernel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777669448; l=790;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=W5OkGQddy603UwQXhANOZyCkcCJwnjswXrRu8xbbvTA=;
 b=GUAAPFmU7MszYrfNginsHgKTjAvgcDq9vIizybjDxJCcex326WcuVpbP3Hh9Dp2GtnN6N7719
 rpCI6b4Y3uvCwBERqQGsOLtcnYs0KEYEyRMq4NDXYQ6X2mn2AtV3Ild
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9A3C5C0005
X-Rspam-User: 
X-Stat-Signature: 7x3om69frddr76fi4tbos91sgkrfhzr7
X-HE-Tag: 1777669458-647394
X-HE-Meta: U2FsdGVkX182iRx08zTPLg2lxEaDWXQsINSig+iPjy3mB1MwV3PqdY8lMXKLkuOyzL14FmlsVii/lP+FEiLvAmFgtFy8scUBELDJ9hKu2NX57Z5MvuFWrKsma8yLcGbC0hKuTFeYKbG4xQUq+anw/hHOcOcKBXo2Oc+klHHLZfhRKnEhka/2o6KjIAnLC8TjY7xKlKN5VdvpMOylwpWgU2RS3OzogDt7pd2M/fExOHsNIg4IKtBMv5h39jEW7cVpvShOZG8rGv+0X+8XI6hmqeuFTFLVf7QRXIjFazsZ+mapJwMIJrY+DaFIAsnlt8iSffOGvENbkCI0bbhWRokhrc7IkdiPAypAhMhqcLzuJwxQ90+IZ1AJoPuV5cG+gQht0HslkcwRmz381Swwo0Qmd3+wNiVUjv7iTDGZk41VLWWlSO6M/BY7m76SZNh2nxy1guFUWwxvoA55SjZ3bZcpak5FNfIMbnXIASWRNbRV84Sn+4o8HbbcOLHK3ZnZUzRHb2OPstyX/dCZYLpUt7f/2dP+fnV26m5fuqGlGc2IF1OxN38b0wuSaawfVprLIo4BD9krCvk1GsQSH89whSkIRNUMbniltsWRCisNIPsM/gdIXVHYiQhDERXmJKqp6nG7fWFZIhIwGbc3atVpJgOHRCKlajxg/iuy9m/8zHRK4kCmdW2RXeWdKZku2uOc/WO7dHyykvvQN7HYoydXfXYcdiTD6XHKtwXHtQNpAN4oNbvEakq2L6g6EPEBxId5uhnDpitP7lo77C0Po4fSIZx36cew+tLK/dzrfX6F8F612O/xgXhdfnvtrMXEJiTphtZoqjdE7PiByCNt1um1Rh4xi/ZEiTDqYjux2tJJDJeQTgjXvxvl0ASChrcU8mA1/gszZSE/0bYKZ4+/33nn21PJKsXHcM62Wla+AQoqiO6IMgb1hDoYqpgrUq2TEoAlcf7h6aGcGmB6scapKDvGZzs
 m8S/DoqZ
 zF/tbCMXmZi+ZqAlGCDpI3bPM+V5gmde82vz+S6neRyn2s5pbr21vS0Gfvjy8J+uonu1EPXhklx6EP/tAqbjXCa/teEhT+0kPGWmmD+l0wXja2Ps9TaI4COImjAr+wFV+scxrVghrbKCBOFBANc1X42rtS9ExDNDOdDxfCy5S+9TFRwQUV//XOf6Wp3W2zps2VzMO8vIoTCGfly9PSrNll8YV/HkWl5zvbxTTHAAag8r6W7hozb+hSd31d7rZDRtEiaXStCMaLEwZZP17xuUvVdhH+RTcNSRBNPFsjMHpwxWslGLfUvjzwngH5An4xDFoWCV4Eor2zDCjfGrEdW2fvgibP9+mcSnfxXKhFYWKQ1XlJ4yfbvSvBysxGY5sQAbfiXmmMF2ly6/aPlw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Shmem will mark a new allocated folio as referenced for a write request,
convert it to use the new helper. Stay atomic as the folio, although
being locked, is already in shmem mapping and could be sharely used or
even have its flags field modified by others.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/shmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index bab3529af23c..2aed99c9f70e 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2595,7 +2595,7 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 	}
 
 	if (sgp == SGP_WRITE)
-		folio_set_referenced(folio);
+		folio_mark_referenced(folio);
 	/*
 	 * Let SGP_FALLOC use the SGP_WRITE optimization on a new folio.
 	 */

-- 
2.54.0



