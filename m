Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DBF7C531F7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 17:37:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC31C6B0098; Thu, 23 Jul 2026 13:36:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9B676B0099; Thu, 23 Jul 2026 13:36:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB1546B009B; Thu, 23 Jul 2026 13:36:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A10E96B0098
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 13:36:56 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 20BC016011E
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 17:36:56 +0000 (UTC)
X-FDA: 85020746832.02.C7C7CDD
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf05.hostedemail.com (Postfix) with ESMTP id 460E5100004
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 17:36:54 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=T2WBor7y;
	spf=pass (imf05.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784828214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WVIK4CTS2ebWqFuX16f+6TzH9lK4l3CZHr+WHLsMqrs=;
	b=i+iiR2zw/kpGqSj+ImIzGn99OYAlMiR5NNQlvg/hagfGLwFeUOgPKysx54mpwXuDY/j6Vt
	kfmrWmM2zkPp4kEdkQZPPtWN9Rk+aiusmREFykjYpWCZwCKJ3qeM7Pq8cdXZmpPOywuyEv
	2dto9gJ3DjYT7awhp31zjkamS6QsFcg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=T2WBor7y;
	spf=pass (imf05.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784828214;
	b=cZmpSmoViE2Etyg8yx/1RPfVOtbCviI7N7wDE3G0f53fg4TcgL/3yvQqko7VSaUD4NJaYa
	/ts6fZWG/mwKTAz8XsJ5SzAjX1YTljqTFqVDVI8rJPwwc/MyvIpcNRzQ4UVeHviOwNBwTN
	Jl4Wtr+RglseP6gqyy2NWv1pUoEikhc=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-848761b5897so627389b3a.3
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 10:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784828213; x=1785433013; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WVIK4CTS2ebWqFuX16f+6TzH9lK4l3CZHr+WHLsMqrs=;
        b=T2WBor7yQXbJOrvPA4jSeLOOSAIM7xdaWL2RWGv66E4zzkGCq0VVXkVER6eK+mtsqk
         ZAVx5tWMBpSFmdGt/qOD7kuJ5Ynrdb6EXllJutlsclIXIZ7qQnwIghBR5Gjyyqbfjj79
         RA/df9r143wAHNuV20fDjnuMroIc9ei+MPsGGa/iBgU+QM1dDJ3bPH4oB7cpIVabH+t7
         i/tVSyh+7zUzQyQ/aJuPNX4CRRuBZS9elaPyTkiTFrq+6uSNRtjp1x+LkqU0/PHWpRQd
         lahqXDC+zGO+agV66j55JKzrYutnub3EXxHdVklIad7sF+o7wsdd2JxmYGyJZW1GEnAh
         qA/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784828213; x=1785433013;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WVIK4CTS2ebWqFuX16f+6TzH9lK4l3CZHr+WHLsMqrs=;
        b=bvJBtAcTsUK4JQh0RnRzvpAkXckZq6sWiqWZjwUVvqwISJYR7Fl4DO80j1GZD8MvkT
         zsxW4NEBhfBF4Ly/AVnVi2xzcBJWQntIosj3KKA7TRZTqs0gDJOvfOimb56TyyA7mIXf
         X+Ckfanw8qAVCF5zfrA5upEvC3/dyU2OL56LyadlNVJL1xmgEIHp6+lZ7qekk23bhgg2
         GF4DVdB0T8y6tNCprCuaWh0S95PJvr81dA9qOxiRNPURPeyAWXBLgOrpKacemjOyYXFJ
         eDjvlHCo6fzYXqFFV9rmlv6vZ+rxZ+cIHZYqiQ2oy3WxmhfrIAh+A6Fl73PnnZkNxPGR
         3N7g==
X-Gm-Message-State: AOJu0YxbJ2Axd7e6vE0a5OcQEdDlGBG4yjOg8Wp+WxA8ibJVj61jQKJe
	oZ5S0cnJOA1F9TxvJ4wgr6iIUp4ZHGYIgBt4KWSBQkFPbzd2m9PFdB2+
X-Gm-Gg: AR+sD10SY43+T7pmrht3FkN6ZHzGsxv00k/QMhq4uWfLV0KAgvR+wUVSm5+hnn2ls5P
	EC6/HzEcNAepsQKoEfCf74nf2e0YabKajQ45Uq3RP5DHNXoR821VodC4mHSbxBsbr9oZQ3vLadV
	5XDQdhQymKs+aLtZMlktRw419I22bzvLa5OHwTv1DJusx+kwGCIqzgtSh+h5MMkE/dJQznCRUWJ
	S8fJQ1g+N8O432mSfBW8zcgmEmG7DPPOUpSYrNqdluHT6GoU44NwlXJYpc4esKSdgcvRphOjJ3u
	jPAwzh5Qr5sWhNrs0NgEGNVOjyiOolbqMd6p3Ywrq/4OmzFUAd5L5GnOj/aAhbIxi6E9xZJZB8c
	1MpGKMIO/6ib2+MlbCQId5suv29XgyAC6VQQlwpqudvvfEs1uDir1m9gE0KFmeDRC8tkeboPRsb
	aH8dWmIBDHPQFtHS783VNQlviA+h0ThZY948pduFMdDnh/xgfk
X-Received: by 2002:a05:6a00:278a:b0:848:42d0:bc91 with SMTP id d2e1a72fcca58-84e2b7f4d38mr4894542b3a.12.1784828213088;
        Thu, 23 Jul 2026 10:36:53 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e20622dedsm2691612b3a.11.2026.07.23.10.36.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 10:36:52 -0700 (PDT)
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
Date: Thu, 23 Jul 2026 10:36:37 -0700
Subject: [PATCH v11 5/8] drm/nouveau: Use
 hmm_range_fault_unlocked_timeout() for SVM faults
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-hmm-v10-v11-5-c55b003a4b61@gmail.com>
References: <20260723-hmm-v10-v11-0-c55b003a4b61@gmail.com>
In-Reply-To: <20260723-hmm-v10-v11-0-c55b003a4b61@gmail.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>, 
 "K. Y. Srinivasan" <kys@microsoft.com>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Min Ma <mamin506@gmail.com>, Lizhi Hou <lizhi.hou@amd.com>, 
 Oded Gabbay <ogabbay@kernel.org>, skinsburskii@gmail.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-hyperv@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 nouveau@lists.freedesktop.org, linux-rdma@vger.kernel.org, 
 Jason Gunthorpe <jgg@ziepe.ca>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784828202; l=2163;
 i=skinsburskii@gmail.com; s=20260722; h=from:subject:message-id;
 bh=KaVy0LDD2WZ56zIlG4jDVljfxrz2j27JL0AnOSACkpk=;
 b=KV2nZSPyVg1Dt5uSSiSffiKfkGgb7W3sWOI6CSqvJIxSZb1CjTMqYYugO/lEA7iz8WZFfaBr6
 LbFOvRd/oG3AQDmUr73ZTQ/tVrKY3HQM715K46T+2IVDrVm2X1nPXe2
X-Developer-Key: i=skinsburskii@gmail.com; a=ed25519;
 pk=bDpriHBYgeTdkIDweZDCemxsU93neJBOCn3YLIuJpnE=
X-Rspam-User: 
X-Rspamd-Queue-Id: 460E5100004
X-Rspamd-Server: rspam01
X-Stat-Signature: gzmad9mitskpf8xj7p8i5qri5fznhaga
X-HE-Tag: 1784828214-484989
X-HE-Meta: U2FsdGVkX1/Amb3PC5Tvk1e1xswzHl1rt11cfivFMj2Xwyokrr840RYIyM6pHrSgxBJS2PRjLfH79f/y7uoYaEotLjBNJQvUS+/V8Sl/2hNo79v5qn27BB9YkBMZrGwqUR00hHfNtepGa7NRfpiMMWgXRpP+DvNr5TXB17O6kiWih/CJQBLwrUBRVMgkZPJp7loTaNersLk8iwmNXXrhTyHnA4fnOZxdLzx2f61MGN0kAcC6NJCd3u11XgVNM78kgt1zwrMYF3OYje0/GlBUmJoTAMlYbamAM4+ek1Z8PSX18b1Xaf5dxa1KQmY98YeLmVGlNYRVkNyMZtaypTcxKnhkeQNRSiYhd7ELd0mxXwory4jZti/PyK212VxmGDGM1hsFkfjaMddKDmgsNu6Y753nX07YGTLU0uJK89JMRKx95Y9TMe7V0yRC1jjc7VJCd9kXzj34PY8Yxv69hsAyV0ghToIYn+z2lr7Y0piipwA0x4/hK88VxF2/Wyw3kMg+HgOxXsABkmDtgW+FljvKBJrDRh/w9qibejDZXsuUodnGKXIlEZ2PS9cvr73sNrs1ng1hlX7sXahI06ueYNiSCmAAdi6woHIEemz1CPR4cbYtuJmLPcmt3G7w3rUuhTu6+ZO2tghwIdJ80UUZgQII6g+ab4wf9cDa1woIbc1HD1x3BDb19AYOgl/31/LK07irSCABBUTQEmwHjoIiiYsauvwg49Vsn7Av8th8YqsccNaJyEIc7ZOJTE7G/00KheLDU5qM8U/HhtLEyfN87Su8PP255GP8eSIobCIb/f8OFovVpR7Bz1aYJB/eK1fCM7fa3KyBRmY2rNkmqfQF9bTUE4R8kKMzPXO1SyN4cxWtHuoDMPzNOReZPCARYuY364BEOnic4ptMYOLWY/4711WwY7X3G7HQtXg3XziQMJvH0yPRiBrNAbc6L2gt8w6jSR+2QiUd35JfOEOrluifhqU
 9K88uRFM
 RERPuOFSUiLl3VdN/bIg5rAXrV3lEpZnMFUGR6CK1bC3BSlDfGlXPWfHg/Kte2yT27JqOw1g7IFmW8QteOg/1w5x3Ph1VcvNDX3SVoZ3cBvk0bi4Mz401iFTNI+lp6g0g1CAzIzfH/HjhbyH/tu9U9YjZMtnw3UhyChedkuPu5FMH5TUmLH1d2f4UVgWFp0aqpQLJ0S0OpaQs4SVpw4SWwTxANYz5JIbhXZp+i/gUWr5l748YpBpgLJN6k0xQYrQBfnF64+TNqYN9yE+lb+Ny4NF+Rd7FF3qmt/ggcmH40P3P0u1JSFvkw72lrVmbI+kahRFBguF5Tnus1r6CTn9Uxv+Tp371m/X2/4LkMqMb0/8z+4UGSdG9FWKfHx44GkPcwTNIOIHeAWrAwuWt+1YOv10zfK36oCvv9JLnEvttx7OZo/FYAe/R6aweyPUQVdTZYw21MbIWQNYzflgQXKYTPLNOfG/5ADMf5vXjnZjsRy+t3JfWdYPxc3LhT8sRCzoX/EXOYRA4LAYD6IkZvzBv6mldqXdp+tv6qd+kMjC3UWQQ2kwpShykDpZh0O6D2+mdNH+yPCNfBFNtb3Jurmpu8VruSbbzWW7Fqo33HIRYNJfdDoQ0uWABI/Ak0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

nouveau_range_fault() takes mmap_read_lock() only to call
hmm_range_fault(). It also keeps a single HMM_RANGE_DEFAULT_TIMEOUT
deadline across both HMM -EBUSY retries and post-fault
mmu_interval_read_retry() retries.

Use hmm_range_fault_unlocked_timeout() instead. The HMM helper now owns
the mmap lock and refreshes range->notifier_seq for its internal retries.
Nouveau keeps its existing absolute deadline in the outer loop and passes
the remaining jiffies to the helper for each fault attempt, so retries
caused by mmu_interval_read_retry() do not reset the overall retry budget.

Nouveau still validates the interval notifier sequence while holding
svmm->mutex before programming the GPU mapping.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
---
 drivers/gpu/drm/nouveau/nouveau_svm.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_svm.c b/drivers/gpu/drm/nouveau/nouveau_svm.c
index dcc92131488e..58735446d783 100644
--- a/drivers/gpu/drm/nouveau/nouveau_svm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_svm.c
@@ -678,20 +678,22 @@ static int nouveau_range_fault(struct nouveau_svmm *svmm,
 	range.end = notifier->notifier.interval_tree.last + 1;
 
 	while (true) {
-		if (time_after(jiffies, timeout)) {
+		long remaining = timeout - jiffies;
+
+		/*
+		 * The HMM timeout only bounds retries while HMM is walking and
+		 * faulting the range. This fault is handled by a kernel worker,
+		 * so fatal signals from the faulting process cannot stop an
+		 * endless stream of invalidations here.
+		 */
+		if (time_after_eq(jiffies, timeout)) {
 			ret = -EBUSY;
 			goto out;
 		}
 
-		range.notifier_seq = mmu_interval_read_begin(range.notifier);
-		mmap_read_lock(mm);
-		ret = hmm_range_fault(&range);
-		mmap_read_unlock(mm);
-		if (ret) {
-			if (ret == -EBUSY)
-				continue;
+		ret = hmm_range_fault_unlocked_timeout(&range, remaining);
+		if (ret)
 			goto out;
-		}
 
 		mutex_lock(&svmm->mutex);
 		if (mmu_interval_read_retry(range.notifier,

-- 
2.43.0


