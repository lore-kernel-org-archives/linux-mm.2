Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45EAAD41C1D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 10:44:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A53DF6B0008; Thu, 11 Dec 2025 05:44:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2BAA6B000A; Thu, 11 Dec 2025 05:44:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 968A16B000C; Thu, 11 Dec 2025 05:44:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 86A7C6B0008
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 05:44:02 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1A0C114083F
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 10:44:02 +0000 (UTC)
X-FDA: 84206855124.18.82075F0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 78946A000E
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 10:44:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HBoVWUbI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765449840; a=rsa-sha256;
	cv=none;
	b=DLpgLkRpr2IaDNm+lohctiB+YkNEvOlpxDWWmJ1IsjsbkOuYOf8Gat7IHLnJn34sE29IPw
	WEBVvp0UE+imqiF3QLDXoMIeiPataFZB6UMseIaPHdfJ8bU3rfMDm7z5a6l3nLmRTvCh46
	g7+oiCl4Pc3yI66Bt7g6WHpVXVZQyFs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HBoVWUbI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765449840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DXKtenz6DaLMGUShcrB400tfbTGBqWhLKx1FA2IPRio=;
	b=D+9f1XZ3cE9gG8+BNEPs1kP09w94SrVKvNuiNgw5s59Ps8BHhJ70wMfYa25lCBueezKTd7
	S1W1ANFj0tuZwn0Pp21Obi3/yOHeDVYE/B2LMl3K5G8JmC9SfT/YV999MfSDuxYYX40nAn
	a1/wzd0D/c7jwO5JtkvWgIibQrJ7ya4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0DC426014F;
	Thu, 11 Dec 2025 10:44:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B94C4CEF7;
	Thu, 11 Dec 2025 10:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765449839;
	bh=Rsfmd7zbC+kSZ3iat7Z+yufKodHJKLHaalHhwgTU+L8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HBoVWUbIPjgDrlY7e+sbBXcwhv9wyvl/oGC9FVjnkNVQbmXNcvHpSiizWHBTWgmVu
	 676b5JCo+l/vhSxnZkG5ex76Egqqm4ujKFANztBXWD/69rPUxapQR+jv7fWXfH8rMO
	 7bBSCRPpnBWxr7QFRqPeSuCaQv+kuC1EXcei63Z0N4r0T8q7IsyF1cdxJAqLa79re/
	 6S1wWL9Ofd/CVmAMEIKMEM+TCjSxJjn6f5/0o4BDhkIWCohnLcMd/e72uqPy92Txqp
	 TeaIWji2IswH2f6gsDWEVp+tHgksXSMZekCWKawCfVxLWFHlpm2TNBjIjHsJkH5rVD
	 CRfGfp2igqIcw==
Date: Thu, 11 Dec 2025 11:43:54 +0100
From: Alejandro Colomar <alx@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Alejandro Colomar <alx@kernel.org>, Kees Cook <kees@kernel.org>, 
	Christopher Bazley <chris.bazley.wg14@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@suse.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: [PATCH v6 2/4] mm: Fix benign off-by-one bugs
Message-ID: <9c38dd009c17b0219889c7089d9bdde5aaf28a8e.1765449750.git.alx@kernel.org>
X-Mailer: git-send-email 2.51.0
References: <cover.1758806023.git.alx@kernel.org>
 <cover.1765449750.git.alx@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1765449750.git.alx@kernel.org>
X-Rspamd-Queue-Id: 78946A000E
X-Stat-Signature: qni57hefitosnh1duzqds86w37i4zb4u
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1765449840-300970
X-HE-Meta: U2FsdGVkX18uj/S7SJshYF3Nh18OIRxNd1HGnWy+l2vah5G44RQUcN66MJbnAHncQlJNduFFDvmpI+9GbaPlOnGB/zHcrzmA7JJnax1JlthCGbWfO+WnHD/6sbtuIj4PLjNnAKXrnqSV4Cw8AG2bdiqb0BAXGGx0IY/HuEyhRcVUDQh8l03UMUaR3QVH8zT3h5b5yPxMteSx+EZHpyVWvbI8mXRqe61pHrng9eJ857n+ZVSyOSh4WKzWqULhuExGwGAwo1Nn0ZSCRkBwqUCcDOsZJUbhE+xId4QVfiuN5neIFkMFJITz1SKslEn/8qntAwR3FtQCqXOfTrQf2H/VJBeFifBJozPyKMJ5ta0/nx/n33+CY4YOCCGOTjCxCrtsgbd+05Ir5QCcZVbs9wrZABamQKVQHnuFYCsm/Yt6cchrO6f8NTatSSaZ5tAsCrnBszTyS2SBAgFxyWic/V3oT3ar+7z5xmet6fMJYVfFEMknNsyo/Ily1anPrlBMgfP7jn/9jpw+s5Jxsb9Yr7lDp4WGev0NAUvoFPJnw1KmhUuJoesfmlMHjYnGq1JwAc6vBCPE/8EN9AnC+pa5VROhqJeq6zNwO9NUwWV/hyyaMooRtlbGgXtQOpWF8x/wlEzUWuj1R7w88oHfHrmsN/BDF0hgAg5d/ZrV0xS2EW0tlhf64x+qewhMj9k4iTM4rP4Ap2x75YdgTE7Z856fJKCGa9ntZEOxRWwFfRObR+9eqjiGBfknNuHkZXWaIVHmF9br//gBUA0V8ABBSN9B8z04/cq/+N0UIZyl57OgI8T/31ArDmALP8ya84tIrQfVAvUXIEpONRRoLqyA950F7WBcRT2FNjkLEYS8b7Flm1Av+HcbT5f7noLBQ70+z0xGFKzpxGXDYavy4EbvHUOue2LcPXIgHHeoK4vOI2tEJHv9ZXlNkqLZuB2OQwfee0QzipJClpoJgVqYEKP24Yqhq7s
 UY39olx1
 AfCPYHGtam7cU23Qj7eQvCB18sQOwPNKfUr6VEplFBVq/sAHrZtQtWZRJ0munZR0kWqh35BGKbTGNOn9YgmuT9r9XLPsu0S7LGj+RqkaCggyXZFRw3i7bhNOjEQXHEgJgjKgNCukZb5pHI1Wf8k6BENWYEAHZOzQAqP+5E+7jgZetxCVZVkOPULkgulVFYFoE/CFFHSqbwKHW/2VXSMgWYmuIt9w3wRbqhYzg4JxjRP0C+Z0cmI5e2QAHy+IZYI8Jxo7clNnljZinMZTd7tPBF4DY5Hl7AOoHHOl6bMwzFkK8qOyYza5Ai4XjRbchr/bszb5Y7ExBdhd4JfCe/Q8GRBeD9gFSIRUO+VNMs/QPReFsUO8WXSidaocMX1vjKdYAjvnO6Bpcp3YnJTDjxJDLkN7apBYVWE1MkL+r2CBvi+C8B1mHf6K8qytmNBMk0ofP6bYs/yEOB3P4HrjW6ET7RzFYNeaU/GScBCwu7TUQdu+kD/k4Ef6In/D8bOZcpRpBA2QzpwUMhmKPkkoAJrgG1fMUrweh3uOkP1NI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We were wasting a byte due to an off-by-one bug.  s[c]nprintf()
doesn't write more than $2 bytes including the null byte, so trying to
pass 'size-1' there is wasting one byte.

Acked-by: Marco Elver <elver@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Christopher Bazley <chris.bazley.wg14@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Alejandro Colomar <alx@kernel.org>
Message-ID: <515445ae064d4b8599899bf0d8b480dadd2ff843.1752182685.git.alx@kernel.org>
---
 mm/kfence/kfence_test.c | 4 ++--
 mm/kmsan/kmsan_test.c   | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/kfence/kfence_test.c b/mm/kfence/kfence_test.c
index 00034e37bc9f..5725a367246d 100644
--- a/mm/kfence/kfence_test.c
+++ b/mm/kfence/kfence_test.c
@@ -110,7 +110,7 @@ static bool report_matches(const struct expect_report *r)
 
 	/* Title */
 	cur = expect[0];
-	end = &expect[0][sizeof(expect[0]) - 1];
+	end = ARRAY_END(expect[0]);
 	switch (r->type) {
 	case KFENCE_ERROR_OOB:
 		cur += scnprintf(cur, end - cur, "BUG: KFENCE: out-of-bounds %s",
@@ -140,7 +140,7 @@ static bool report_matches(const struct expect_report *r)
 
 	/* Access information */
 	cur = expect[1];
-	end = &expect[1][sizeof(expect[1]) - 1];
+	end = ARRAY_END(expect[1]);
 
 	switch (r->type) {
 	case KFENCE_ERROR_OOB:
diff --git a/mm/kmsan/kmsan_test.c b/mm/kmsan/kmsan_test.c
index 902ec48b1e3e..b5ad5dfb2c00 100644
--- a/mm/kmsan/kmsan_test.c
+++ b/mm/kmsan/kmsan_test.c
@@ -105,7 +105,7 @@ static bool report_matches(const struct expect_report *r)
 
 	/* Title */
 	cur = expected_header;
-	end = &expected_header[sizeof(expected_header) - 1];
+	end = ARRAY_END(expected_header);
 
 	cur += scnprintf(cur, end - cur, "BUG: KMSAN: %s", r->error_type);
 
-- 
2.51.0


