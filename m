Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70415FD4F0F
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 17:58:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 802E96B00A1; Tue, 10 Mar 2026 13:58:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DDFA6B00A3; Tue, 10 Mar 2026 13:58:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DA0B6B00A4; Tue, 10 Mar 2026 13:58:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 470816B00A1
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:58:30 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DEF0A87E95
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 17:58:29 +0000 (UTC)
X-FDA: 84530913138.03.3BF2A6D
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf18.hostedemail.com (Postfix) with ESMTP id 01E241C0005
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 17:58:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=SypbMMah
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773165508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JH1sSMbaLUKQaR2U26oi38QcPA7kc27iYlwkovTchi0=;
	b=d/Aw+FDmLI2atUiJWdCmiYMVCdI+QNq9v0p1kyDz2nFUZHE7xRRyxBrz3DQK3g8AJs2hs/
	DR1wRcx5m58LWNtAhDBE5ro1O5dAKotEllMOPV98aMH+q2fMt7wJj0chp+W7hNHdVLSeWP
	zvx48hzvMI0O9LcbF0fzYraqk2d35y8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773165508; a=rsa-sha256;
	cv=none;
	b=2TzlqXDPKHeY3zlNoTLyfOrGxgOFXFoNpkBsCMt2YEYLtEI5cVUltcZVBk0d7Ra/FJrogO
	kRVGCRHEr17OJRyeVCDVMZtjV2nXfvRy2RB9hC7Rv8TWL03HBJkA5JT/zsuymXVMTo0UiA
	PnuOBcSYysGLbYNpHorzdllZlJnEo+U=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=SypbMMah;
	spf=none (imf18.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=JH1sSMbaLUKQaR2U26oi38QcPA7kc27iYlwkovTchi0=; b=SypbMMahWgaPD75kxHLjIX8ci7
	d2LjiyIDOJ+6eCWDEaECO5Jb7xdW1PAMwU1p/2TfrYW/UBcNCbJC03H7pG6BNDHc23zsLtYI5fOJz
	CCWKFUmG9AfT18DmZJREXZZ90voyrAGWZ3bNqoInvNGSv3+jmlLHl86NiQM4lZfWb4UBJGZzGfSgK
	KZNba0dAXYzRWQgwcXvvc6scv856hV4qt8+Q8J2bO9ojclbbKgIwXMGX7jIBl8godrSljZ2kmMjvB
	ZSwoH1LNRL5TGdDLLsGsl14UV6NW4GnBPEjce+2bZ7N6PKbWidLgouStNagzSRln3zwslCJffbahB
	fKJq+PwQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w01LV-003AaG-Oa; Tue, 10 Mar 2026 17:58:18 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 10 Mar 2026 10:57:10 -0700
Subject: [PATCH v5 4/4] mm: ratelimit min_free_kbytes adjustment messages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-thp_logs-v5-4-686099175bf6@debian.org>
References: <20260310-thp_logs-v5-0-686099175bf6@debian.org>
In-Reply-To: <20260310-thp_logs-v5-0-686099175bf6@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 usamaarif642@gmail.com, kas@kernel.org, kernel-team@meta.com, 
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=2011; i=leitao@debian.org;
 h=from:subject:message-id; bh=sxlnEBDqD6VQeD4cL31JhJmkqEbifkft9mLh3RNg8k0=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpsFubDKOpPMxvzzpIp0J36faXVRPCTVU9M4var
 adKffMbgAKJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCabBbmwAKCRA1o5Of/Hh3
 bXV3D/9nAY2XOL03ruLBHgzp6klnCndqIoao42Xif994eIwg43qlkJbkAW+lIg2NzU4e2+EWyit
 wip+POZAZbWl3ABecbIgGYcwL6MPOhwOwaSWfKgAy+Vn5tOPs8CwiFt1WFTtuNA63/tLIu5uRM7
 1kOevZZ5LyJM7thCB3mvjxPm/Qc83sBJzpGx0AJk/l7Fncs6p5xwiughbE9LqUo339vkF1MUnHu
 1wlScHaOvYtKmLH3Oj+9uj3/YeTNsBBSbj5RVqNURmvpHHcAfpdFoVMksoOOUDFzkEPz5kDQdOI
 LtAjgkPJh8oN9MTkrqkywjxkBVQNBUrQo9SH/q3bmyzW64TS+9ty1GSsxov9sVdAsUn8guMRrDy
 hU7L9PT7woGTR0/GuH/Ugg+ZP6AHM+4r0D5HEhkMj4nE+He2pbYOK1yRpLu7ZYNexnFT3zCRE4d
 NU00Oi2ajRjvzXCZ94Wa6ZDTrcKWNKluIuLiFTntc/nuahW/lu53D7SwPNM3JCZAruMBV3KCo2D
 /XAwrnr2rpILc7Udr+hV7xmGwol4DS6dm6hMpB3CgQOITomUzZ+wA59oDO7kRjLTEYLjypiwbza
 mLHfNTh9goK7a1Ot2ui2LOAreDqFctxaesxEtnbyfP32uYPF70lKKVXgjwVIkJYJNZ4/Vc/Od9g
 SFd1PZcWpkjmfNQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 01E241C0005
X-Stat-Signature: yne9ur7wyecpc8ye9xrjcyq3i83tmhw8
X-Rspam-User: 
X-HE-Tag: 1773165507-986813
X-HE-Meta: U2FsdGVkX18/4Eig40xh76TiAGQVJHFQr6svxHfWX6X2uNJVHaIxwJAMqjXwYugYMgpWWKckyafqpur8z0Hibv2eFrYubJc5EkRSH4zZr9vx/Cq3yS3dW1Z3BkbC04ljsW8YZhTkRuankuivDW5gubRxdbIOCc0v1Cn3OzIn8Hm+2al+8It2U22vBvzxcZdNX9u6S80UjVY5bsOwSrjmAGnUJ2U6Q/uWzPOxqmvuEf20aizKhG8HmeM2gR4Bn5PqWqs2tyTzrtN799qsM6zREHIiNvkvPjnwTm2Ylk+HgaH+X3gTZyL/L6Syfzv9oI3ldNhQ2fjvAOTVa8RLZojyJbhY5AJMySByBIuN9IeMmzW1qKRr1zVxx/KyUpEUtYmig/72NkENSOI4IMFFkcgNIBM6I1T3OWvZfefehiQUjbRje1XORD7zWJ0Q8i2ApmFvSKzzHHsOHUVca81WPoOuYTHPqdhkM2cS7mhkiSQAN7TZ3iZjwCqTS+zOr8YRfPfGu77MQM0dMGZLTpBH6dRGb97RmArMB8MJMpEI8DZdQDx208jwhj7g1DmnyNSVDeJraAJI7zlqz/Wxh1GZst6bagVRIU+dU+rTo47yPt41aNgzXfUT9D0wdQ0pT9uf7A5dqot6RdJaHDOwdXvDglRQE/j7y/PwEztQtaEa3RgoEnNuE6ffYVWsE50sfpXmgARNRIqadHds2PyZB4OT8VP5WxPlFggCfUeMaOis2DlrZPGbb6qgeC9rk6p6eUnN94D6ZrIAKPVzggvtf4a8tCthvcZb8Ag6OPT1O2FxF46xuv9OqOki9GY5VaSW7A9qw7aMsD7oyn62obWcDTdOw55JR54vZpZRx77nj/Xw8uPzVHI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The "raising min_free_kbytes" pr_info message in
set_recommended_min_free_kbytes() and the "min_free_kbytes is not
updated to" pr_warn in calculate_min_free_kbytes() can spam the
kernel log when called repeatedly.

Switch the pr_info in set_recommended_min_free_kbytes() and the
pr_warn in calculate_min_free_kbytes() to their _ratelimited variants
to prevent the log spam for this message.

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/khugepaged.c | 4 ++--
 mm/page_alloc.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 56a41c21b44c9..d44d463ccfd3e 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2671,8 +2671,8 @@ void set_recommended_min_free_kbytes(void)
 
 	if (recommended_min > min_free_kbytes) {
 		if (user_min_free_kbytes >= 0)
-			pr_info("raising min_free_kbytes from %d to %lu to help transparent hugepage allocations\n",
-				min_free_kbytes, recommended_min);
+			pr_info_ratelimited("raising min_free_kbytes from %d to %lu to help transparent hugepage allocations\n",
+					    min_free_kbytes, recommended_min);
 
 		min_free_kbytes = recommended_min;
 	}
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2d4b6f1a554ed..c840c886807bf 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6553,8 +6553,8 @@ void calculate_min_free_kbytes(void)
 	if (new_min_free_kbytes > user_min_free_kbytes)
 		min_free_kbytes = clamp(new_min_free_kbytes, 128, 262144);
 	else
-		pr_warn("min_free_kbytes is not updated to %d because user defined value %d is preferred\n",
-				new_min_free_kbytes, user_min_free_kbytes);
+		pr_warn_ratelimited("min_free_kbytes is not updated to %d because user defined value %d is preferred\n",
+				    new_min_free_kbytes, user_min_free_kbytes);
 
 }
 

-- 
2.52.0


