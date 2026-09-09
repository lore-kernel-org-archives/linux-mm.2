Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8382C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 17:11:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36B446B0093; Wed,  9 Sep 2026 13:11:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31BDB6B0095; Wed,  9 Sep 2026 13:11:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 232236B009D; Wed,  9 Sep 2026 13:11:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E54726B0093
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:11:12 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0EDBC402BB
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:11:12 +0000 (UTC)
X-FDA: 85194864384.21.B16EB5F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0848A20010
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:11:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NKGrHxS1;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788973870;
	b=Sj2frmcRYwpji+dHUDcZSMcUL/XrHODO714rruzqrmcXYNF23RHwxiVgShDjuagRIRqXoQ
	vPIJITOaRioOduDwJsa/UHK2EUeCxSKR1gFe9x2aNpXTuh6m3FEgRZ7/KIBsmC3NT9au1M
	VZ/lydfFYCuZZGQfW0ioj8JJ/o5eIoI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NKGrHxS1;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788973870;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rJTEbdSiRoD1a7OqH+BfbV91/NXOsC8g5HlpxdMNyoQ=;
	b=ntwUMrUk2AvUHpaNykmuPwtX3gDQHAgPakOAG86uvf+D+8gmZnk3BDzslCOWbN9z+zaN9p
	POgWTM8j7X4TKxD7mlk5/3Cs+PBcwbKkHwqdPbvfIM6WxN2w7JkXQl9DpflLuVRBRGhhjS
	WPBJm4fv3zFjDNScqHnDM9nrKYq95rQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 28D1C43E08;
	Wed,  9 Sep 2026 17:11:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 02402C2BCB9;
	Wed,  9 Sep 2026 17:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788973869;
	bh=BHXEO/5ApGc8onZolC3w/bocqaSCrODRqIh7iaYmj5M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=NKGrHxS1UroPb5TIhDI3V+HA2cKcmATt/ptd/6h0S05YwRQeG6yCVM7ZgxEp2aPQW
	 rMldgq7YcPws1UsQ0pYMiLf73YoGVHt/R7yjrsCcXfyy96gDI7B9HGyk4xOr6EOqMg
	 d14kGmVVkCfLgMliF9JSFjcafMStrQqbqJWxSy4ffquEzlUZhotTK+IfDmsV5ToJ03
	 43lIbWygXQbdXy3rZaWptnNKd/wqYrZUYEXiFJK6g25BfBp1Hwbe2FVsFjkjy+JA4m
	 ti3alMa16YLFwrya6ccZyMaN0agsrHavAmrbj4cpUpudi6G1RK167m7JP41PSdPno8
	 rhkfZpXVGJ3sg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D077CC79FBD;
	Wed,  9 Sep 2026 17:11:08 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Wed, 09 Sep 2026 10:11:00 -0700
Subject: [PATCH v2 1/2] mm: hugetlb: Return -ENOSPC on memcg charge failure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260909-hugetlb-alloc-folio-memcg-charge-error-handling-v2-1-4b4a8a19a7f7@google.com>
References: <20260909-hugetlb-alloc-folio-memcg-charge-error-handling-v2-0-4b4a8a19a7f7@google.com>
In-Reply-To: <20260909-hugetlb-alloc-folio-memcg-charge-error-handling-v2-0-4b4a8a19a7f7@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788973868; l=2084;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=wQGY2NqfleEKP3GcsIVv3hSYGK81wAt8iMtpppoPYIU=;
 b=ow2acPS/0lBc9uXTMEil/vfmmYchZdQPHwRPGUjyngNjaKdtya97UdQiXuHsJi/izJCrBL90Q
 x1jKApeeIl+A9bXU7EeN28MfQNXGvQh+Hma84jQ/IKEgnDjk7aUriCZ
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0848A20010
X-Stat-Signature: rwaoag4i7srouq5requ367egyktsfpbn
X-Rspam-User: 
X-HE-Tag: 1788973869-965545
X-HE-Meta: U2FsdGVkX1+e1roHKe8644kMW94f5SKpZDkT0I0PLIQznc9L69vGOtzKFMGReMTmLH53R3Yt2mhuOKft7/TxnQ4kbHdkW5J2xt0/nXr4oQ+4aW+zTfTY0/a8f4AXGxVRcMe5IJw3kNIfcSmp4SfVO3Sy0hLFCejDFhl06eQxp0GdElxQT9g+fWOpIYtnxziNeLo/3nsaEBPg8T5TmCajV5/7yW0EYTMF8vW/h2vautCoJttmedTtN+jXeJBpn15VlJLqqo7EsMFnDuCrPhuqphNF2eU7TTTJPdcF++56FTGXA9KEPfOUMYAWX/xNzv4tiNEUL5txDfDPwfTepLp2/BuS3s1PEoxpuPfBZQsMqA3rd6I0QkjoLzpRJ4htrpFV0m3v/XIBN0vae06dOCh45dJFhiI5WIjUzoGdMkOn4OY4U6aEkDm3595krHpp0afj3l9OQFP02K3pIfJ65d6bV0vxPebqlksZcxq92RKKJmbeSLyJx1ivqf8wOj+Bt7kRGcPWTJFblA7x9L/gp727nCgmc89xkaROOw2eTzzFCSA/t3QQ3ztqaDZo3toA7/C414yzVpirKQX1ogKmGcxYmZ7dg1ip9g5y5YqrDqs8yLA5JO76m9Y607HTCgK5UdnUkUnJEZvdgVBCCcj5m4Zl4WdvHo08LzrgR/TV4wWYKEikta9/PqLkPsWODMD7ZQXHibNulapFjkPGHYu/ZhbKkY5AFy7OyLcW/VGHmPkrrw5K9Z9DszpesV+i2dXZe4A2wpvpOMQiRZc/VRAVPXhRYdk1tNrPJwESpBCLHhxXW143sZAvFpW49r4SzT8Yjsnm2AzhjnRi0W9X/Z5SvCGeIlIt4OCFBvlVEapFPMb6xFka2kVKMYSrA+ZfM62IhuJT80u9eMRToW9sYKfSrLo1UEy9RFUHxVasewYfOH4R0Hy2wKbHeGDBAAtOeT2Di0LEMADvOji61bGAwVCm7d/
 iIipWTEi
 aKmZ2ssdj1OrfbO3Ac9+dCioYZVGPz+63EhlKM15tvnu3wsOSW6Nlb1vEKHZkeZTk+5h32L4JEazhpakCsfoLlD8YjizCu8dBfzqVz+uFyDC/tnW989dpDrWyhWuOGx5L4F1C+PrMZMBYyHKsiH5b6PUY3+eJ/VqSFcUF6LQTfIDEVMZhNMTiiMZVKbbiIuHlAgf7Z1wG0G7fBkdjuSvUwAMTHRnGE7m07+m73w4b9bb089Yf6WFkWrcio7hmbTRjMNKPgnxKJva4BQFRx7wyMNMvRqcqmLy5h+qMMO3AvmxCtV+0JF354ZlPw1la8a2yaF9X51NpN0WPrTF+htqZQdQMZSDP3QcAlfrjniXBs83g7HnAYK2MXY6CdpojcrBAaevU52aQ0Ae2/yY+aa/gNK3/5j01X1Yo2il6giwupOf35c4Pw7eiCrhWPs4lyV5BQLINL5Gwh0DwYFmSxiPboAEcSfpKQ891b37KzhqDoGKEQqBHA3fj+/9Upe7v8OAcdi5u
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
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: stable@vger.kernel.org
---
 mm/hugetlb.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 4f6f58bf3db6c..522487d341841 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2825,7 +2825,6 @@ void wait_for_freed_hugetlb_folios(void)
  *
  * Return: A pointer to the allocated folio, or an ERR_PTR on failure.
  *         -ENOSPC if cgroup charging fails or no folio is available.
- *         -ENOMEM if mem cgroup charging fails.
  */
 struct folio *hugetlb_alloc_folio(struct hstate *h,
 		struct mempolicy_interpreted *mpoli, u8 alloc_flags)
@@ -2898,7 +2897,11 @@ struct folio *hugetlb_alloc_folio(struct hstate *h,
 		 * were committed to the folio and freeing the folio
 		 * would have cleared those up.
 		 */
-		return ERR_PTR(ret);
+		/*
+		 * Return -ENOSPC, since retrying the fault is futile:
+		 * the OOM killer is not triggered for HugeTLB.
+		 */
+		return ERR_PTR(-ENOSPC);
 	}
 
 	return folio;

-- 
2.55.0.1007.g17ff1f9808-goog



