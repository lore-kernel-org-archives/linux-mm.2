Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0D46C5DF8C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 03:35:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81DDE6B009B; Sun, 23 Aug 2026 23:35:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AA446B00A0; Sun, 23 Aug 2026 23:35:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6717A6B00A1; Sun, 23 Aug 2026 23:35:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 38F7E6B009B
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 23:35:50 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BE36316042C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 03:35:49 +0000 (UTC)
X-FDA: 85134748818.09.365E5E1
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by imf17.hostedemail.com (Postfix) with ESMTP id 153BC40006
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 03:35:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=akQ+cDay;
	spf=pass (imf17.hostedemail.com: domain of 3EryLagcKCBUH0z63Az19916z.x97638FI-775Gvx5.9C1@flex--wfelipe.bounces.google.com designates 209.85.210.199 as permitted sender) smtp.mailfrom=3EryLagcKCBUH0z63Az19916z.x97638FI-775Gvx5.9C1@flex--wfelipe.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787542548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DZMAXxlnSgWC5Kd65SinCWudGpzS4DSeLZoz+Rd1kKo=;
	b=TUy/P6zgcuwfomZd5KSURWw1pimoe8Ypeqn3DeA4ZvYsex8XFJ+BbR7kk+FZKjf9OGDyRg
	da5lQoZWNmBoZ20zot/mdbvJ1WF4Ob4YCs1Mb/l/xeWhF6/izs/Ytn2QwOSq+1cZBjiShR
	xF3w7ppPj/1KDjuEm9jJQgpLbX9kXX0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=akQ+cDay;
	spf=pass (imf17.hostedemail.com: domain of 3EryLagcKCBUH0z63Az19916z.x97638FI-775Gvx5.9C1@flex--wfelipe.bounces.google.com designates 209.85.210.199 as permitted sender) smtp.mailfrom=3EryLagcKCBUH0z63Az19916z.x97638FI-775Gvx5.9C1@flex--wfelipe.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787542548;
	b=oeaA2sxVheEeF5JufoaIjaSzP7jF7bzcAqV/S7G/lsRjq+2d5VJdzKDPXjnDHPRR+OEHLv
	axPK4mMO9/D27y7+hQjm3AC9VXSTRUTGfdDW0gFFeUV43diOEGBMCIlzjuIoSHEQzMpkXY
	/OX99gougEnHfuSG2W4okVfR7qdUSkM=
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-84865f326efso2845695b3a.0
        for <linux-mm@kvack.org>; Sun, 23 Aug 2026 20:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787542547; x=1788147347; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DZMAXxlnSgWC5Kd65SinCWudGpzS4DSeLZoz+Rd1kKo=;
        b=akQ+cDayl6DngxT8p44zcn+pHw1Bx0XXSoPD29U0V7uDiHG0cLcu6gMrCegXeEGTRB
         zgjfa/YGv0yFucylgjNl24zARYSAWcyIOTnLOJEb9BfBWvCM1Td9cL5QiJzikCsDCRDY
         Z9Ung2i71Gb7WIs+2RfJEtwM+W05uCurLDTbYGXus1/BWiHxFqzGYUDapb+7lzY6F125
         jnvR/5B0j3v21diGvGT/V0B3Ps5SZkgWoNl8QLA4ez3KRbmM6l/oDvJpZRS2GODosvDZ
         WkXsfR1cx2HiuPN6M24hPprj+0Q7qupYLfQKgX6EpEQNXkqsYvAtIwEA5POo6zAv7A1f
         Z45w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787542547; x=1788147347;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DZMAXxlnSgWC5Kd65SinCWudGpzS4DSeLZoz+Rd1kKo=;
        b=fl/GCUcN0jJgDcCwAOUsUyxazKUcdNecHr847QUGmlEpHNYyaquQllDckPAKv5unpD
         01ah4GBz0SKqRsaAfGMtCOCz/LFahzFipBFecALNtS8Ps3BqHebF2V1G2eG5TBfR+/cd
         usnHQjz3ogiN1BVx/AXmnqUz9yCmamK3qIoLggofUq7hNCz4yeQiefjh8sZ446AVOZLu
         nJqd9b7wKh4W+HaDCIHPkyWCy1/5hww9ent1L9p9VSqL//FBMalU3aDPVBKjWgDHxgj6
         7xFNwdf5CiO/vaQFxokGn7nhV7hvBf8VbWe//8Gi9UNxDdbpUpZ8pfqGkd4OE/Ll2OF5
         YX+A==
X-Gm-Message-State: AFuF++lfw5Ul3NnvvViMsO/6Y7r6/B1L/sZDDDnTCIGDdxeux9kMDhbe
	IrGzRck+kHyGdkBAV6lIbHA0aCVYIP3DhmmPgOjLy4v0CWyPvz2sxYkoWaLctxEgT6pNsYOmf3i
	fy6+WwcbAeg==
X-Received: from pgnf25.prod.google.com ([2002:a63:7559:0:b0:cc1:513e:8b94])
 (user=wfelipe job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3b89:b0:3c3:7a0a:18a6
 with SMTP id adf61e73a8af0-3cd4bca353cmr29799231637.18.1787542546697; Sun, 23
 Aug 2026 20:35:46 -0700 (PDT)
Date: Mon, 24 Aug 2026 03:33:58 +0000
In-Reply-To: <20260824033533.2147900-1-wfelipe@google.com>
Mime-Version: 1.0
References: <20260824033533.2147900-1-wfelipe@google.com>
X-Mailer: git-send-email 2.55.0.766.g2966f0265a-goog
Message-ID: <20260824033533.2147900-3-wfelipe@google.com>
Subject: [PATCH v2 2/2] selftests/cgroup: test_zswap: fix implicit unsigned
 promotion bug in test_no_kmem_bypass
From: Wilson Felipe Pereira <wfelipe@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Tejun Heo <tj@kernel.org>, 
	"=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Wilson Felipe Pereira <wfelipe@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: n8i3qmiwt45o43na7etq7udtm5xajfba
X-Rspamd-Queue-Id: 153BC40006
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787542547-787309
X-HE-Meta: U2FsdGVkX19Aq1upTje/amf4svguMrnZWSl+zXBjZarQtCeW+B0BEI26TKAhZAJjlHSgMajV5f8D3NtSUJbPv2ogGTVLT9beVNzn8xHUGGOCYvFlixWIcwBBLhrzw8tfmHX72wYcjDUfWPEtS0Q3iSxpIqhZBe0UEHk7StHqkOV+UxTk5ZTGtvw72fIgB7wbXb5j8Vw3ml7YBZ/IkfmWSBqmi/Ykge9wFln7ZZZTeYmhcGPWm1Iunh38BUETS65qSP/tbjS6bdMDJ4oB5agTLMdW2MDS0zvglsc4D+Zeg+tBUjuKmGJOG5UVY/nuiefpWeUH34xzhJHu6RG0yLNwY+G9T+dBCgMWhgiF3HbwH3Co4ljTFywO28cq8knDvfzgTS9lDw/bNF3Ehwd5j0viA2+ORhaVcdT8MuM1aAd0DycQISSwX/LoYfw8Whx3gksfNpu7alTnBh5l7dpscRMshm4JnuCe7IDgCEzxtZtP/V0hj4JMXLPdk+1DPY7/TOu6U5nzQnTDaWX/gk4lgXvIEqWyYpP0CClbieOdZpHCN+eykj6Ol5UZ4KyL23kRfscpAqJQGDeBWDqt6aPEZe7MYJbluuBnDaNaYn+NZyXWmR6nlBZVgyThyVRx3cJ7bigP9OFGVCG+bCYBz8WOq8Gppg8MZlG+O9y23EU7+j5LRmLJ/Huaij/qtYUWzmZAGpEunb5cOzY/xn+vGLwX/raCBkToSCIgq1X8sdcopB5S8KzX6U0NwqxzA32idZTMdE3ZWxc0bkr0ifBkdwhK8KfuwcDo4s80wmOPZAVuBt9jkMgAlQMXl9dI+uzzzbsRBWiLn+IYd3x8mH3hz5Qo9wOL7gAX6qBYUoV24YfLXD2E+IcXg+l+f6utf/h6zwcD7itZyDlB1LURaSw7Fy3aF1svYUPf0ySbyy5+NJbI0wK2lPacxmZ4ilan2P9eRf60GUWdfwvrM/bBgz0ntA7bxML
 JuFVNCjL
 ofAETIG1rQD1el7bLg4bY8uglntJ4cDBPnqCYT0BxhFZufywH0m1nO53dDPORfVCwx8upQz5uBB/PYP9bmtx2DFL0aTL/gHMXL5MKT8KEyUbtDOjaWZwjF2Kh7KPVjz/KRD2gXNpvKPHEZhtReyq7iAWmv3fC/fZPgfUCLLsQikWmMyfUBB8te2VS5zdUOy6MnQmpmTQDWHY8t1yk3l/G9GZwLJpbFiXFxio1NCYpBCWZkSlz83649ooD7TCISQmXj5gA5Pf4iUmHyPp2lmY8+zJxXOUmxBUBs2C0YOxXTtP+iDZ7EvqJkQyRphvHiEr9W652vgW9i0xyOC42UfveZPu1b7YxlnaQBS01MvXSyqgm1zWIL2Y+9jSU8G6538CTcHpbIXp9QrUXvR3C4GknGyTzZwh0gL83k5dnxgK9dsY2GFLlD/WcegZmL10LTkM9FNQYyU7UK/0XdY8GnfPCCuTb/FLwRr6lENcUtCBxa4UB70Iw8Ywe9PTFDxxP+Y6QqqNz44dPe1JifXja4CT/VGd/frmswb6nLpcSER2V8CW1bjey6RlGDu7KNcZ5k+d0QsA96jnRX2+DwUktESYodkC/i7mYEb3E3n4Y+rtisyR3F7zgCTwnERgCql63Df1wf9/4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In test_no_kmem_bypass(), delta (stored_pages * page_size - zswapped) is
checked against stored_pages * page_size / 4 to verify that the pages
pushed to zswap belong to the test memory cgroup.

Due to slight stat update timing differences, delta can evaluate to a small
negative number (e.g. -5MB out of 1GB). Because delta is declared as a
signed int and stored_pages is an unsigned size_t, C's usual arithmetic
conversions implicitly promote a negative delta to a large unsigned 64-bit
integer, causing `delta < stored_pages * page_size / 4` to falsely evaluate
to 0 and fail the test.

Fix this by declaring zswapped and delta as signed longs and comparing
against a signed threshold, ensuring negative deltas correctly evaluate
to true.

Fixes: a549f9f31561a ("selftests: cgroup: add test_zswap with no kmem bypass test")
Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
---
 tools/testing/selftests/cgroup/test_zswap.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index a7ff525c1267..15cc1dfdd1f4 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -621,9 +621,11 @@ static int test_no_kmem_bypass(const char *root)
 			break;
 		/* If memory was pushed to zswap, verify it belongs to memcg */
 		if (stored_pages > stored_pages_threshold) {
-			int zswapped = cg_read_key_long(test_group, "memory.stat", "zswapped ");
-			int delta = stored_pages * page_size - zswapped;
-			int result_ok = delta < stored_pages * page_size / 4;
+			long zswapped = cg_read_key_long(
+				test_group, "memory.stat", "zswapped ");
+			long delta = stored_pages * page_size - zswapped;
+			long max_delta = (long)(stored_pages * page_size / 4);
+			int result_ok = delta < max_delta;
 
 			ret = result_ok ? KSFT_PASS : KSFT_FAIL;
 			break;
-- 
2.55.0.766.g2966f0265a-goog


