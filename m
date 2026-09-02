Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A3BCC624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 08:23:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32F196B00BC; Wed,  2 Sep 2026 04:23:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29EB46B00BF; Wed,  2 Sep 2026 04:23:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A3816B00BC; Wed,  2 Sep 2026 04:23:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C886C6B00BB
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 04:23:03 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 57A02400B8
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 08:23:03 +0000 (UTC)
X-FDA: 85168131846.10.860024C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 638DF4000A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 08:23:01 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WzsI+juK;
	spf=pass (imf07.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788337381;
	b=uN1P5F+53GrKlunOh3K2dlGPAu0m6/zJqM21n3UnvgMYZmNTD1KhZEZvGtw0y3NJG3ftcA
	rLDf1ZIsPgTod91qjMU5bI5DeyzBjYIQxE7c7flQ7W4P82THCZaaR96tQ0j73VilY6EXNN
	/y0ekLQcryyia8n1J7ZSxN8Go/fssOA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WzsI+juK;
	spf=pass (imf07.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788337381;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+eHzsOkj/0JfxaeZyN12WBihi0qWx0qKn/p6JYm3qNo=;
	b=TMAsPoYGA3S8ZHOU7dgttSuxG9Fch9B0vcLN/AfCS0cd+IWWHlzbnzEPW/xmsbxdGdi/dN
	KP9o1V+7NnViG4KgqHD1lXXvuayTF8pb2VmrzCSDwrVo7ud55/Y+ds6XopgmLCvWlviDxd
	KhvP+df9IFVe86GAxRZcf4JH72bi6tw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9471E438AA;
	Wed,  2 Sep 2026 08:23:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 661A5C2BCFA;
	Wed,  2 Sep 2026 08:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788337380;
	bh=+5j0hNzbRt7EoX7vcWXrnLmcUDM4afqudgCGYcyrSqE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=WzsI+juK01svCEGlyGV1qbLaFotopPEguiB6aYIoA+luLq0V5Ey2VI/RcvLk0Pm2Y
	 cxrYQnq1xBiqMWnLEmDlWrH/Xc5NmKRBUkoSGf7q2aLI5I16pUxu6eUKt98AS7DAor
	 S+yzMmX7g9Y/0jXDNdUAKg62MILM8v+tHMrN6KCfRuDgGe+zwoZ//HCaN6HrmeYmXF
	 Lxt5LeO7K3x9k/fvbxVFbYKIEiE0YVdPhNwNC0YYYOZxsXb6RcCAWuPkFnVmoeyG3q
	 SHgmY0xXxveUwxI6TcLtC2NwN6b+7kP+eJ4rt17FLb+S4u7/PXFu+wuahVB+WK+ZyI
	 B/FB0dtIoommw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4592CC61DFD;
	Wed,  2 Sep 2026 08:23:00 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Wed, 02 Sep 2026 01:22:56 -0700
Subject: [PATCH 1/2] mm: hugetlb: Return -ENOSPC on memcg charge failure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-hugetlb-alloc-folio-memcg-charge-error-handling-v1-1-e3e8942c141b@google.com>
References: <20260902-hugetlb-alloc-folio-memcg-charge-error-handling-v1-0-e3e8942c141b@google.com>
In-Reply-To: <20260902-hugetlb-alloc-folio-memcg-charge-error-handling-v1-0-e3e8942c141b@google.com>
To: Alex Shi <alexs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Dongliang Mu <dzm91@hust.edu.cn>, 
 Hongxiang Lou <louhongxiang@huawei.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Nhat Pham <nphamcs@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Peter Xu <peterx@redhat.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Shuah Khan <skhan@linuxfoundation.org>, jthoughton@google.com, 
 fvdl@google.com, rientjes@google.com, vannapurve@google.com, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Wupeng Ma <mawupeng1@huawei.com>, Yanteng Si <si.yanteng@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Ackerley Tng <ackerleytng@google.com>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788337379; l=2356;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=/vykoq6S6jD//j5trcHGMPdPAWTe6fd8Rz8OBB/ktN8=;
 b=wfhCNMZJJPNgBW2NCuyx+S9kXKexZ/7agd6XgUhL9IqhUo4tUieNAIWP9hMWipNtrK3C44qW0
 13Wicfdb6QrCDmoerV5o/WOzDWglesoWpZgvyIRqJUraxYeITnwVTp2
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Stat-Signature: 8q8e34fwnpf33texjbnkoq4qyut5qgeu
X-Rspamd-Queue-Id: 638DF4000A
X-Rspamd-Server: rspam06
X-HE-Tag: 1788337381-816006
X-HE-Meta: U2FsdGVkX1+RRTrzVgUvVx1Qrlw6azzFU9xGbdwfHCZyYPJ/xtrR3tBywPa2o4oN3IVnqAYwfwzcdx4xFB9R9ct5FTDxDKQKfoETWbuEr9l/9lJuncmmqgLODeEpyTRgL8u0kl5y2NexeWVSfqHI6v3slpc6nnQwyhD6aRN8nu+59RDsmxBk1z3cioO3gyx+GZMdYGRDIOW8oKRRWVpGzbhc1G9Azi9TGvX2DUEceTQl6jTkcKnMg6+PHNyxzYzUuqL6UDT9BZ3WtNtjnHJ/OKNWI/XAI6w3kFbdJFpqCI5W7LPQocenks0r3ecUW9Q+/v6lgP7REn+v3OEIvSmZqeT1bhl+DfGXQNQVD03l6VTJK05TKlaul7Nkm01POiHoltKOj4ej3e3ngPOPbOLCf22LA2W+Ccos3fXmuiiAtupL1YeUxitnuM3MX6s1NV0Kf3d8iLZcncb3gYqGJpm3uOttuxdiz9IT8Uzk7aN3dgM0R84rke7Tf4dEKs1jknnuPV1NSP4rynJw4rJ88wcdEs3eviho0/XQN0D3y9UT+hLl8aYqb04iKIUTyfMhM/Vaa6QnUybqKIL2HqpOx5GGSvBRghD9779Vs4dZ7oJny4hN9IakXuF4Gab7vN1jdXQHBfVANX7PcEX3aW+kJAz/UHTUBAufR2UiyXMak5/uYbfvwj1qld8Y0AhAZn9WsXh34jzunQ5wjyzjEBjlhdQQtaXset9x8kS+uUvWwEX4uj6sTjppp0N130lZeZ67wl/BXpFwEEEg3A7YtFhJzXvINpLYfJf7xuhqzk/V6Yt4ZlLLTrFlGDSYy4B8xVgd9nw7W4bBkz3ogv64RyRkXXYikmkgcl6rySX57+z71eSot55yR/0Su6R0Bdd1M4k03ocjikBfmPLDMrT8IjJslOb0xxDf3NIJvAgPOX8eIqw/0MrJawUq3ZiGf6JlthPahYBkluZM6TV+bLjEsZcAxCj
 hlIaM8D8
 iz3HJ8a8rrE/gU1LCIfv8XwMHd1SaWrQ2ooXzUkxHTg75VTiCqIWMeSO7GkwW5hMz0KL5ZhQqdmQROEFOTJFEpqFxChYpKohMNeip3eZOAG6QWE5Z5MIXcgasyfcVmTOyp5m5Xp7yj+Ys6jmLMzDtpCZaVO4YBOLZ1V1acPdV2ysi+riQ+yDBfT+cX/83kTDiY5nEcqegBh+X7cJYt3i/XJ7GlbF6rrHgIrihOzHIo8+AjmVktzeQ5tIsOfiuFaUWmOEsHNfoawjUqQSC7DFDWZcXsMMN0gajFeucKPxjXkAoU5Y0ctTtNf7ppHY/kNtYyEdz4HWzdaWcxXiFTdi4lbOjA0Yb8WOXQR6zoD766xG9PunMxy74OfIAydAQFmeGAEt/HqeXFOk7gZ5ZosGFNGs2khFwhJJd2iTMqtjVfslxbMxtUT7PJe5rwKclOwARVVijOaSUK3REKP+vKcduDJZxSn/beTTfvJNK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

When mem_cgroup_charge_hugetlb() fails with -ENOMEM, alloc_hugetlb_folio()
currently propagates this error. This results in the page fault handler
returning VM_FAULT_OOM.

Because HugeTLB allocations are high-order and use __GFP_RETRY_MAYFAIL,
they bypass the OOM killer. Returning VM_FAULT_OOM to the #PF handler
without triggering the OOM killer (or having it make progress) leads to
an infinite loop of retrying the fault.

Avoid this loop by returning -ENOSPC when charging fails, which maps to
VM_FAULT_SIGBUS, terminating the process cleanly.

Make mem_cgroup_charge_hugetlb() fault handling use a common error handling
path, the same handling used for hugetlb_cgroup_uncharge_cgroup{,_rsvd}(),
which also don't trigger the OOM killer and hence opt to terminate the
process with a SIGBUS.

Fixes: 991135774c0e0 ("memcg/hugetlb: introduce mem_cgroup_charge_hugetlb")
Cc: stable@vger.kernel.org
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 mm/hugetlb.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 7857728457952..01b57f6d3b804 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2823,7 +2823,6 @@ void wait_for_freed_hugetlb_folios(void)
  *
  * Return: A pointer to the allocated folio, or an ERR_PTR on failure.
  *         -ENOSPC if cgroup charging fails or no folio is available.
- *         -ENOMEM if mem cgroup charging fails.
  */
 struct folio *hugetlb_alloc_folio(struct hstate *h,
 		struct mempolicy_interpreted *mpoli, u8 alloc_flags)
@@ -2896,7 +2895,18 @@ struct folio *hugetlb_alloc_folio(struct hstate *h,
 		 * were committed to the folio and freeing the folio
 		 * would have cleared those up.
 		 */
-		return ERR_PTR(ret);
+		/*
+		 * Return -ENOSPC when this function fails to allocate
+		 * or charge a huge page. If a standard (PAGE_SIZE)
+		 * page allocation fails, the OOM killer is given a
+		 * chance to run, which may resolve the failure on
+		 * retry. However, for HugeTLB allocations, the OOM
+		 * killer is not triggered.  Returning -ENOMEM (or
+		 * anything resulting in VM_FAULT_OOM) would leak to
+		 * the #PF handler, causing it to loop indefinitely
+		 * retrying the fault.
+		 */
+		return ERR_PTR(-ENOSPC);
 	}
 
 	return folio;

-- 
2.55.0.970.g62bdec98f9-goog



