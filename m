Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5A05CD37B2
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 15:39:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F22AC6B00DB; Mon, 11 May 2026 11:39:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E862A6B00DC; Mon, 11 May 2026 11:39:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4CDC6B00DF; Mon, 11 May 2026 11:39:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C54536B00DB
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:39:34 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8F3A51C029D
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:39:34 +0000 (UTC)
X-FDA: 84755548668.19.A37C2B0
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf28.hostedemail.com (Postfix) with ESMTP id C2533C0005
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:39:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=pHF4q8JM;
	spf=pass (imf28.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778513972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b69sgv2dXzpZgJDqciacSImGKfghtkSEKpreyIG4ANY=;
	b=2uTQPSVOs/hByEL+VPUynN10/3ekOGR7uN/Zn3AavcTN5LbAKPzPR3kn3buVhHHAj8gmfB
	NlfdkoPo6oRXbsH9Fq22otvHWcRT7pM/To2jVIa74WhTKAv8rIIQ4GB6wXktRISeD2uZYD
	i8xLY7PGaM6QMILEvCcOgnCp3CYwkVY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=pHF4q8JM;
	spf=pass (imf28.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778513972; a=rsa-sha256;
	cv=none;
	b=K7hWPOv3Q0mjR1qEUGjGKLrcpofRgNoPexcD1o7i1WRdqIxJbLDZY3CAmJQARdnPInNXIz
	/8/YYdwY2/yYv2d100swNEEmZsHKHbaAYFKRnrqknzWT2bL8F/QP4G2Bj8tyHCe+ixyhwK
	uexzpXq3H5lUF8OXUkwvrFWIZDZhY4s=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=b69sgv2dXzpZgJDqciacSImGKfghtkSEKpreyIG4ANY=; b=pHF4q8JMOvrjEpRpwvdcA/Y0AJ
	bmSwsdg9aFx2wApYypxub3xgo7pX1pwsntjBMS+3qBBDL4jcJlUirPrArj1scXnVrYnhBDrVV/4nb
	qSoIA8e02BXn1wB3VwCB+Xop+/dS2GDOjlSUezrzHYlfluEkb5JTaURHKTEL1zrCihS+FuLYSLwNl
	Z9oJrgzH/+GsyWuKIImkgvIpbN1ZLRnMNQt54EO1ukZSM3MmUPAcq4IATUW9NJGMKhTORPWzZ3Uiv
	uU3jDYbqiIOePo8Bs7o5aZTb8aqRRjo9yoO7Q0qyKB4sFh1CoZrAveaReS95ZkRFwGExkpn8FJlH6
	NWCrLkgA==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wMSj7-001hV4-0s;
	Mon, 11 May 2026 15:39:25 +0000
From: Breno Leitao <leitao@debian.org>
Date: Mon, 11 May 2026 08:38:35 -0700
Subject: [PATCH v6 1/4] mm/memory-failure: report MF_MSG_KERNEL for
 reserved pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260511-ecc_panic-v6-1-183012ba7d4b@debian.org>
References: <20260511-ecc_panic-v6-0-183012ba7d4b@debian.org>
In-Reply-To: <20260511-ecc_panic-v6-0-183012ba7d4b@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 "Liam R. Howlett" <liam@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, linux-trace-kernel@vger.kernel.org, 
 kernel-team@meta.com, Lance Yang <lance.yang@linux.dev>
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=2532; i=leitao@debian.org;
 h=from:subject:message-id; bh=QI/LnjFxb7VYKP9kMjSn/xHKUbboDh93Ly768NA/Sh0=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqAfggio+Z39e2w7EmkUhdYSq8j8L3EAJysjNpB
 FODq8lSTPSJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCagH4IAAKCRA1o5Of/Hh3
 bWOQEACiBsHHaTmf6qkAQgpaa6psj5wgPRGrykdRJebZdVweBu/5FladzS3IRVJ1nn8r4sIv237
 /Kn8R5feYMah7QSWj4s5mmO5v2efGVHq3yxkl9Zomn5uK533a5eGM9EfvCA2ENMpBUgYQcb65Qz
 E3zpItx14T5EcEMPhQec4ga2godHp86qBhe3fY1jp7mSOsjFvDsBbdbP+o4dmgPUTXrfqmz7O5x
 Qt3nk/3aBCGUW4CdNyviQy/YwaRWkcNslxlXyX26EAsxAalB7r88pShp21mNej+Arduktkk4OfO
 UMMnI+R6IlJwBGZfqAdWpCjNfknHSZ0O4BvEWLZo/Kq0IENtGmuL2taWPNcybeHd0GuTKch49Sv
 qtLwyVy/yDbgFgCy3/cLYOtrFQCiT9PkjFjV+gTHdwLBRpwTuSF45L4OTBZbxhvub687mIpZ/06
 paXT5WGuj27VbrH97RZR+HS1WBqI0WZdXlOo8wxxZvHW0llRpYW4TY7NLqnf3IYk1qFcwQ8CpUb
 lAPUyne3lUEXvO/fZb3qvhDbR3nZPrqHBp9mgz3CqI1RUlbSd7ah7nSviK16/itInpmYTEBi/PJ
 q3964OeR4em/5dSp15ZPmkR1Sx5OzLGPc4DFB0VEH68E86W4IddkvWgTFXu99qc9gPL2DketpkK
 XSmhf4aCOTJPoew==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C2533C0005
X-Stat-Signature: 1k6z3cx4ri96m78awy9dtpw37d1uom1c
X-HE-Tag: 1778513972-584826
X-HE-Meta: U2FsdGVkX1/NwoOfx4t6LeGKi14yqwG+ei/b0kApDtQEi9LjF+5u23LhsaqKLXQ/JGZChg65lWGwoAz78JPo/MNbi0ScxLMwK74aSHjhQnc1w9BXsNwHJGfSN57bXAAvNuoO5pnoils2RI313hK7xt8YpJWVBGodisEjtmYHc0feXNjEzabUeNtZoSqJh1ao8/hWVO5OWJCXl4uzmXomKlAsHkkEWPzjSTu7JFSv/Q8rCRoqhzbKBUUhaDSe1iZ2J04YVaB06eSd4hRQ2VIYqheWjHA+S48+SeT3W2XflMiomkhjqKX0Mk6dzDvGJMC9Ef8kwG3eX7VlxpJz/jfR2bb1vJBcFezyR5KfcOR6Cteqd2teLH7CllzLzCCLNUZpT9ORND1X3acY9nVDiK/gT29GcERGrGVgfgcJjoj9XQ+eihqChZjTflGocgQbDKqNctJVCujKDtbM/tV2szA/G69YgMgFKxNLux1m3FfB6iXkEE5tFMQjzcm/LZi2mF/iRJHeU7F8vow+gQFOkyiw7MQ2Ll1PGQ7PWoP7DwuIkoPgcHKjCWzDyRJgDglj6Yg5bg502zVbQ3SsFlbWwBpVq7SpnK7pN3aAot6J1yPp73oP68mAm4F3W7crKELettMlBjjn56+pJGUtQkyT2D7sNw+VKyL9DA724sTexrsMrAT1n/9xGTdRxpeiSb+7CbD/ikr0znn+WJjR1nJpU7afq/go1IBsvWynmYVa3F2ZfErc+HItyA+WihrH+pZE+S8ezQr56QVyy7wamXCYnr7KoJkCqZjcff/QOp4xA65VfXVsSayaWPnEZGXI3zsfZXgaM6a8bvWkt0TDGirE2wNp325kGJx5FyH7hpPSzlL1B54q9lP55mwD2xd72fIw3YJMjnPvObI2XJSAu6LR9xNiR4nxg3qC/zRDVVApWbur6oueLvwkmIkS/3sfAdYvZvYBOs0t+9uJu49QdO3GZE3
 5Ox7jWNj
 S364kiFN5h+REEKgKqTAzq72FtQ3QyWryXOX2v6tWVc7l4nDsmanOcVA4st+iKXf+UyYQEnPbTEwsRHgCwNJf17kaK7yFq//6lFGpKRaDskZU3+T2O2X6ZlQC+g6zFAsaRrcNGy571dmEUZyV8SBY27vFBrnZC3GVvfu9JGsm1X5uJpdyATTiM48qcXD/WioQZihPNkCEZOO7GGgS2CH/kCdqrwI5SfsZWo6XGHs7JkKRcs91Vm3M1+30JROLmF5w7IZN6Y6GNykuULZtzFQXtFI8aeuYH3EjkX9gitYtPOLhtLlLzfkGgFdrSaSG3SLsqbqgtfkLOfyur/AN5ShC83gSryosVfk/K82lNNzSHWjBW/lYz0SSVifqv9MjFRvRzhr0GJlIjd3qCpNrLnZPLBJvCWxvCI6LxxHHwP9NpqZa2hu+YdYhWbIx2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When get_hwpoison_page() returns a negative value, distinguish
reserved pages from other failure cases by reporting MF_MSG_KERNEL
instead of MF_MSG_GET_HWPOISON. Reserved pages belong to the kernel
and should be classified accordingly for proper handling.

Sample PG_reserved before the get_hwpoison_page() call. In the
MF_COUNT_INCREASED path get_any_page() can drop the caller's
reference before returning -EIO, after which the underlying page may
have been freed and reallocated with page->flags reset; reading
PageReserved(p) at that point would observe stale or unrelated state.
The pre-call snapshot reflects what the page actually was at the
time of the failure event.

Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/memory-failure.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 866c4428ac7ef..f112fb27a8ff6 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2348,6 +2348,7 @@ int memory_failure(unsigned long pfn, int flags)
 	unsigned long page_flags;
 	bool retry = true;
 	int hugetlb = 0;
+	bool is_reserved;
 
 	if (!sysctl_memory_failure_recovery)
 		panic("Memory failure on page %lx", pfn);
@@ -2411,6 +2412,18 @@ int memory_failure(unsigned long pfn, int flags)
 	 * In fact it's dangerous to directly bump up page count from 0,
 	 * that may make page_ref_freeze()/page_ref_unfreeze() mismatch.
 	 */
+	/*
+	 * Pages with PG_reserved set are not currently managed by the
+	 * page allocator (memblock-reserved memory, driver reservations,
+	 * etc.), so classify them as kernel-owned for reporting.
+	 *
+	 * Sample the flag before get_hwpoison_page(): in the
+	 * MF_COUNT_INCREASED path, get_any_page() can drop the caller's
+	 * reference before returning -EIO, after which page->flags may
+	 * have been reset by the allocator.
+	 */
+	is_reserved = PageReserved(p);
+
 	res = get_hwpoison_page(p, flags);
 	if (!res) {
 		if (is_free_buddy_page(p)) {
@@ -2432,7 +2445,11 @@ int memory_failure(unsigned long pfn, int flags)
 		}
 		goto unlock_mutex;
 	} else if (res < 0) {
-		res = action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
+		if (is_reserved)
+			res = action_result(pfn, MF_MSG_KERNEL, MF_IGNORED);
+		else
+			res = action_result(pfn, MF_MSG_GET_HWPOISON,
+					    MF_IGNORED);
 		goto unlock_mutex;
 	}
 

-- 
2.53.0-Meta


