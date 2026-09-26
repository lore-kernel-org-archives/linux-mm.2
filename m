Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DC2BC98318
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 09:27:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 818C26B0099; Sat, 26 Sep 2026 05:27:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CA146B009B; Sat, 26 Sep 2026 05:27:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E0526B009D; Sat, 26 Sep 2026 05:27:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4EA216B0099
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 05:27:01 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D50FC16087E
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 09:27:00 +0000 (UTC)
X-FDA: 85255384200.14.81C5F08
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 527DFC0002
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 09:26:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="k320yvC/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790414819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=apeXnFxwzPd45aFiHP0MNpAyA7JkKV4wuaIPOREj6NU=;
	b=8MMDWrcxSkEOUiClcNzVvO4AjnWFdVhZAbe+S8sTatNUVgAWhndRcqi416swGb9WF+pG6O
	agt/0/wUhS4y+xju86uvRCOVsjM8jZJ+s5sMPSgjUpZnZvwq12gxNT/sqXfR6hS9rFwVS7
	Fy3K65qJbkt+zurGeXFXxVTY8AzuLss=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="k320yvC/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790414819;
	b=Vsl4jOskvOwN0IuDn9DHMN09G9UH0mIQStkOk0KusROcquA+Qm6MjaC6N4UeSxR4lBtj+9
	CkiwNPNfYIWnAu3QnaynQmNKEEIbXCNMfsiduZRbvvOCTinUr77EtbpR3ZDUudKooHfhnd
	Diq0mPqo/2RkLj/znP4PWTBEOZhp6wk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E8C5E602C8;
	Sat, 26 Sep 2026 09:26:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEE841F000FF;
	Sat, 26 Sep 2026 09:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790414818;
	bh=apeXnFxwzPd45aFiHP0MNpAyA7JkKV4wuaIPOREj6NU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=k320yvC/8eFUDkUHTucUsYfIFPTBJRLOAqKMjYUGTeuvP/Q89YgerwbE6E2JAe8Xt
	 u1uOdprP1otEhBeIa3MSONT5D76mh8IzLQBsOmK22qZILMF9UPt2IP4GswMo6/kQ2T
	 +K85a5hk0LFQTFyHXVTbW7r+FdW4xBYelMlNH8rpnk2FnJz8VEtzAB/7rVjNWbbeYF
	 xDiIq2bGXGS7DVmB8Q41b+ODN7zBr63uEVBuyAG8Cl/kiZMsbbmkKR0Ca3G0tcVDjB
	 fwAgD4YMPkTfAuOXJeCGMj+pyf6aYRapzk0pD7GGYBrwiedtC+mcr2kl4ZjheBtI79
	 MkstHnVzkERBg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sat, 26 Sep 2026 12:26:31 +0300
Subject: [PATCH v2 2/5] hibernation: ensure secretmem pages don't reach a
 snapshot
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260926-hibernation-v2-2-235f69f3ab2a@kernel.org>
References: <20260926-hibernation-v2-0-235f69f3ab2a@kernel.org>
In-Reply-To: <20260926-hibernation-v2-0-235f69f3ab2a@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Alexander Potapenko <glider@google.com>, 
 David Hildenbrand <david@kernel.org>, Marco Elver <elver@google.com>, 
 "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>, Len Brown <lenb@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Pavel Machek <pavel@kernel.org>, 
 kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-pm@vger.kernel.org
X-Mailer: b4 0.16.1-dev
X-Rspam-User: 
X-Stat-Signature: ei3y5gk8wpnzn3pi71d875ht35w8ykbb
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 527DFC0002
X-HE-Tag: 1790414819-939240
X-HE-Meta: U2FsdGVkX1+CdVzhGyBRSHCw0Z5/6YblbaAxBjeWh04So23uvxk2/whH/ABYGNrnhH/j8TlKUD5DTqjt22t/K4b7veFBC7dAndT2hjZOGF7cGdKcDktnMLAmgqwDEE2dv7NhzbW1Lw0pXI81P5f18FZqJ7/tDMUC+x9Wn2hcNYwYq27N6TkzsZLhlsEP6+0Gy5F2ENqUxtHoMl53DBbFnKSTf9fa1BrcVQ9962IgbldPotD3MLSg04akPrfK6sOtQ/fRjnRdlcZw3bHTwpvWOW8cLPJWusjmZMGYg8qx6ZKxab7XPXAk+7jDvozBeJ1K6IyApRvnx35TtEvbnHJPo1cbITID1vyq1l4MID4XX8+0klbCZzDrNAa+Q7SKyHzOXilhNXoU755Pnlk8s9tQSsenwCMs2WBZIZkg9oigeBWtBG3qEsgH+K+ii68Yr73HkFEuThmHmCW939DgDr7rwOZ+PHQ0BNpRwQZVJA7G+OneF/5ZqcMQ7/y3RnReyFr8IosEKMl+GiflouaK1Ktjpr33fES1hd9Ino2d6nxRhA8CyYkCGYTtUJeFJQz7aur6KJAeaKdybVCYecAnrPM/jMzboLh9u6w0fUjr2kC8UTM0OUU4omIpCBPLjSJfmWZirVgrXUYMyw/YF3zs5ZrfcB0H4zfDdJem8E/GMNfoqVB1LJSuDH4+WgULqjpJJbhqIbJo9iHP1wy+OvvySivgzPp5SXzZJG2bKJFVf+O/jO5vR/J/iA1o+2yuwn2+rggJR2U+HLdhEAzgvMJUaO03iiGB+WwfTLv+JqCz3pagcSxlJZj6bsp6OgMR95ET2h3y/NxpBXYwcnC4HjlegBJ2vaRpK/iYbiWL/XVS8r3gwyiSMMoEHgi3DKRtnHndxMRmOb4NBPd5ulYV9pSiVzkfQmSgABZC++5bqkfE1sUGskOtxriFAyHVBkDxDoNPYFa+A6ZOEImsKV7TRtuN6hC
 8AEpvgw8
 FWwWrMOmCqE4UlUSgaeGaifsOOHqGvApYnxuqXZ2bYpbFofZyXcryEbbwqknqdeTNiyMwD28jVyYkI2QakcX2wo/FuatLIgKi88SLcrmhw9l8v8Wo/6qZtO3U/X0l5v2ogsxQsZuAjNTohyffogpUrHJVnfmZhpGW63y3cCA7tYZWmClW8zGzpfNPgDRk5exIR7a4DyqdBIMgEH+wvez1cyRkK4RsOKodaljUuTZZaGo0F4NTEuatTsxg9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hibernation_available() checks for active secretmem users, but a secretmem
file can be created after this check and its pages may get into the
hibernation snapshot although they should not.

Recheck that hibernation_available() after userspace is frozen and abort
hibernation if it is not.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 kernel/power/hibernate.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index d2479c69d71a..97de677e360f 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -412,6 +412,11 @@ int hibernation_snapshot(int platform_mode)
 	if (error)
 		goto Close;
 
+	if (!hibernation_available()) {
+		error = -EBUSY;
+		goto Thaw;
+	}
+
 	if (hibernation_test(TEST_FREEZER)) {
 
 		/*

-- 
2.53.0


