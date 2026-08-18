Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA864C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 10:08:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 743AC6B046E; Tue, 18 Aug 2026 06:08:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71C016B0472; Tue, 18 Aug 2026 06:08:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60B546B050B; Tue, 18 Aug 2026 06:08:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3D7566B046E
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 06:08:39 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C7226160B53
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:08:38 +0000 (UTC)
X-FDA: 85113965916.09.94B7823
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0EAB640007
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:08:36 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=pBXqHchq;
	spf=pass (imf04.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787047717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=18b3yXoATxSl7J4Qohqzo1mLFp4/SDkenmc18eUXtfg=;
	b=dGLki6fUU/d3Mt3xt288OICPAagCCKyQbOS12P2jMlYzPIMzhv/1ha/UMhY9CQjFqAJFqL
	ZLQoKh8RIhoepEQMPHbJBoVTH6UI0pKxd6G5DyH4p71Q/t7iCqJPig2Os7l83tOyu5NEKl
	luHrOpmF29Wtvz/WQsNbNdanDZbk6pY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787047717;
	b=Sc7jwyl+N7I+kbc5hwbhXU2lhdLx/fLWsfce/LQ1esYKgyIVqg4IrJl44s7AwtilGYzYBZ
	qRV42POOTLvq6xEDFCu4HVLd0Rac+pe2RCkQeInA1aogcWxc5jylZhMhfBduO92Ki349xf
	xLExK8/q19mByW3TDv97+69xGUCDGFk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=pBXqHchq;
	spf=pass (imf04.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=18b3yXoATxSl7J4Qohqzo1mLFp4/SDkenmc18eUXtfg=; b=pBXqHchqvMhKy9q2TLfprFQxpv
	oTrVwijpGoNrlS2oCNpfs9soa8XN5XhOMcHuyP99jABYgRv0Z6DTMemrMRLQOhxSGkA5pRa7QExFa
	T6EE0XJMUn0nFaSWs9BT0dbrxuZawIlflqIUyt9ztGwden3S5X63hCNKEOhVzUbkBd7ejGlzpOv1I
	1p+/NxOep7oZjDo1dt0WtfoT/C0L8MG7IYfoONz/plq7eJoxrxvCZr+l2A9ttRLKU5i70U/Bxv+5c
	kFSMae0s/qZKxiGfn232s9yQ6aenykVJCI6pSaAIkP4gIup1u/ksWbtC/VxG/dop73XXJe547P9H8
	KcFmc61g==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wwGk7-008wGb-2X;
	Tue, 18 Aug 2026 10:08:28 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 18 Aug 2026 03:06:24 -0700
Subject: [PATCH v3 2/2] mm: fail the fault on a malformed swap entry
 instead of retrying it
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260818-swap-v3-2-d3fa52598a59@debian.org>
References: <20260818-swap-v3-0-d3fa52598a59@debian.org>
In-Reply-To: <20260818-swap-v3-0-d3fa52598a59@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Peter Xu <peterx@redhat.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
 Chengming Zhou <chengming.zhou@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=1062; i=leitao@debian.org;
 h=from:subject:message-id; bh=dbJ2cob7ug0q0zBMWou2pCCet89ZlFMUpENdIOQ07oI=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqhC8HeqOvC+bUMvfHEdA+WWMzM+GRMPTCTJ0Wi
 zjOPGWeGX2JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaoQvBwAKCRA1o5Of/Hh3
 bVrsD/480wUQJFwAkhlGjW1ypFpLBPmMQ1Hotp+NK4hb+G6+VM4D856NfUR+kncB3McvL0pMrcH
 knib03o9/OqhUG4PVJ6jTUgPH41mwb4iBwzH34IhoTzmUhZoVBsgww4iGZBGAx8FWQCA2vzZxYV
 aSrHQPN/S3pM2RJlzM2eJM+b/eMXOVWiqIm59/crVNLx8HH2liovLJ+28aSSQCC8KTD4oWwq9LA
 8641BzTVdpy3fCuNY7DN/X8eF1SJxmylbO+l/puDJQB0WOsPZ37nOTKYgL5QWAhDboLpWBrxWoH
 6DsJfxIxfJ6hJh/1nL2ZDsJoDN7SSwHKxJC1XA/86rlSKcRHKuew/lXQtVKbaoxfJXlMjTmE4o+
 ryr4R9++j1hklIi0ovdVDzcM4rTGCiHrCmBMx4vAAY7sWfNTdbrR8LRbYgw/gY/M72qTRWL9OBf
 mKEWQ12uUXyS54InQrvQ09GrFdRMQalUArtUqySv2+EFTT5thP+bK0O+t595KrJ7HZKk1L5pesz
 kXam7pHZYZkINg0W880zu99JSOl0UQQ7ags1OW6D2GTAFXbtYVcHD0bRorceAhlwk37+8NzwFcG
 5uviraK1wEIqzzh4bGMgdtpnqu4MTxfR6XPrEJnSGG5M0lzgtic9WHITcRciGeS82CEwNV/DWua
 LTquOjP4JaMbHzw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Stat-Signature: b5ks1yep6bofrjo8obmm7bakm719664w
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0EAB640007
X-HE-Tag: 1787047716-104404
X-HE-Meta: U2FsdGVkX1/IEAg9+t4Gk/9ZfHUPszCi5xrIW+W92B6j4Qn+jeBaqIAz3NSeXpN71ZOEtautjGl5iGQBZ1WMbYa4N+UvvVxcgA972vln3t3zp6h4D/ZlTPejHHxmJF+SCMIL+F0tcD4USZ4nZhx9hWJrj724mh1GvSw2+G2Y803Km60NfZW5Fnx6kirn8Ee8iubHYpAv8djCURN2amV8Ctc3zEIk+t+ef9LZE7WJUKti1FaK6/6sHBDV0SbzBrKGBxHqisin/4LpluoLyUqdRKsWD0WSnLRVsyhETtL/EMzs5jwxHmB0FANxHSD0EX8Ik7GSHaLBGHT/qeGUlJgoy0kAg4A9Sgv1MbdkwHFVzma+4mxM/EJvT3HOjt1ApIhNU2DHktUPQf73QFqjsLcSQiuijxsBhUTabv5PHdRC0oZ9LSnjvStmA+IFREFPFL3ABdDYjOtGH+B3B5Yb1IReOfkCruWZ+cPivLmTWLkccJ5G1m2uQTMHe6PGn4Yr8n5dnZp2eHVwLCoP3/e9gJ0LaF+nBmUrqcRkjlcehPly1s5DdTq3GMCMT+jU/y96IBP340tNhaMjJXIMN8iv0ZzKC9DLGIFSBhi/YB5bm0AHSomnQSb+B3MZMUJWFRH3r9Io712SdXPWFmy9QuXVMXNT7K/Zh8lRCIycytL02SVuaJ5yBSNUIBNRQialdaIDQXXsaEyfv8CAlQDojdNVpGyrxRQ59yix8KlAjcOg1cc1Ai1WwAIqeAfSdxtMeyOKe9H45zcGkYM1Jij8BkNJ+lvVc8iGlUTEm0MAOacV0MofYxKC3HjMszdB+iJ+ugApojYih6qAnlFlPe0IyZC3AhhIN0DedwAqwvDA4ShxlKIIf69HPJNiR9LGHEPfF/tWBZWKq7ju2C/l38Yzf2sqXXzLuWFlxGtjShjA0CBdaZ3J0boIAKIMLN+usIOjZkRP6OPnQoDJAX7bwNfgHyQiiNn
 FdHgdKD0
 rj341Hh1BU45FVflRJV/EnrfxZe5W6OiX/RNKCp7ozu/IYovtz3qXnvi+KlyDmgs2LyvgtrGSJvdzPbQUPFt/71naEFVs27IzoDzv/nHFEhatBxLkcCptrBY9oNY4YEJ7698QXtheEyNgo68i/WjvNp1CLJYIG8a4/3Qh+CkWdOORhyImxRnpDZcdyr5v58uXs6LV2EA4+KGFlyYrvLOi5I+jCJpvwDxY17lEpHNMi18BV0jkqdfWbjY/AyZhS4MlBZ+PCw+/kPj3xw6MSfOIVNGMjyOmvf8QhbNQFhSune8zsu7FlJTAKx9Ad4UKSD6TlfHKCPPjDzNw9MQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

do_swap_page() returns 0 when get_swap_device() fails, which the fault
handler reads as "handled". For an entry that can never become valid
the retry takes the same fault again, so the thread spins forever,
retrying on the same fault.

Return VM_FAULT_SIGBUS (Bad access) for a malformed entry (pr_err() was
called at get_swap_device()).

Acked-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/memory.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index 03d8cf111d0be..d9db4f1ae6f8a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4956,8 +4956,11 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 
 	/* Prevent swapoff from happening to us, and reject a bad entry. */
 	si = get_swap_device(entry);
-	if (IS_ERR_OR_NULL(si))
+	if (IS_ERR_OR_NULL(si)) {
+		if (IS_ERR(si))
+			ret = VM_FAULT_SIGBUS;
 		goto out;
+	}
 
 	folio = swap_cache_get_folio(entry);
 	if (folio)

-- 
2.53.0-Meta


