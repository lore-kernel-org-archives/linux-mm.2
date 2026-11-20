Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D65D5606A330
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 11:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jb/YGBIt
Received: by kanga.kvack.org (Postfix)
	id D86626B00EF; Fri, 20 Nov 2026 06:00:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D36DB6B05B0; Fri, 20 Nov 2026 06:00:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4C436B05B1; Fri, 20 Nov 2026 06:00:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A0E336B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:00:09 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A8BF6A0EBC
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:00:07 +0000 (UTC)
X-FDA: 85455202854.28.681EF03
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id DCA26C000E
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:00:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Jb/YGBIt";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795172406;
	b=NjO7YmRMTxp30gh/yotKEbPGIFl+WFDBl+btHmgPwwd9f4EMNLmbARAJdzt828ZylPth+k
	IXiFushGRuQREcllKbhaS0WbBJAPV2dMM+jSWTOIXySF1TMLYk8W2wPLkjB8H4gpGSwOnO
	7HqwZ017cZ8+Rqfxy5qEmJ6LAVyDcsY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795172406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ucmucpZhZx5mCbukB70RKbF2KoPnEE83By/sGDZ9Vsc=;
	b=Mb52+bjBT/Atw1SovfNP+xFQEpGccs4ss6/72Lzg1YMPZOiYfxQKoMEw1dueNvYCyHuta1
	q0BHo9nQzYclC041XCZFlAJcBTkZaCFVpqdxQQJD2G43k86rucnvR/LYARDBFY+4T50A3q
	Wcna81YpzjRIvvz4iJsmB4dCro8xpeI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Jb/YGBIt";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 13E9C444AF;
	Fri, 20 Nov 2026 11:00:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C37381F000CA;
	Fri, 20 Nov 2026 11:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795172404;
	bh=ucmucpZhZx5mCbukB70RKbF2KoPnEE83By/sGDZ9Vsc=;
	h=From:Date:Subject:To:Cc;
	b=Jb/YGBItPaegqxy+e5CuVkAyDvm3pipH241J9nVLKYmP/XcSGrseC+lMdz3MuqgTI
	 MxAxVwrbi2ChLeeL6kSTXdFvW8QndjN9/d0zE4uKaWUsuqDD5t6yOIXfc7NQd+Jf3M
	 vCLm/y0GzG5f63vAJWiuTf84isOh8UceKV6Jvck3m1X7y5t3a454KA64+ZpqXzD5ny
	 Pb6JC4P9FqbErzt6vIz4sb7HL9zOQGmlB9r5wgooeZnyPzaSgW0cp0WRCiNWgScGbG
	 RL2v8bEuXMdTtURoqZIdyNZydlbkGoeadqbN7MHhQ3Kex/8I01kJNJdUCB603dNms6
	 WmEeX2fZAqLLA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 20 Nov 2026 10:59:56 +0000
Subject: [PATCH] mm/msync: return -ENOMEM if page-aligned length overflows
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-msync-enomem-fix-v1-1-80282c8c5beb@kernel.org>
X-B4-Tracking: v=1; b=H4sIACsoAGsC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDQyMD3dziyrxk3dS8/NzUXN20zApdS9M0C2ODVGMD05QUJaC2gqJUoDD
 YyOhYCL+4NCkrNbkEZI5SbS0AJ0o9uHQAAAA=
X-Change-ID: 20261120-msync-enomem-fix-95f830e305dd
To: "Liam R. Howlett" <liam@infradead.org>, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Wupeng Ma <mawupeng1@huawei.com>, 
 Ding Feng <dingf3ng@gmail.com>, ljs@kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1643; i=ljs@kernel.org;
 h=from:subject:message-id; bh=G1I4F/4QvlDVu084r5Zhy5KWsBknEl4bznf2Xzz0LRo=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIZNIzWiwmtNEvg2PE9ed15idccj5XDVY8+mPhjf35Oy
 vI/Au8DO0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRe98ZGR503eds9hSe8/7S
 FAVuoZjI76Hixzb7XRecZdW6ZYtgXjIjw7H8npU3FJNNJrPPFA78v6qosqDswwGvH+tLI333RiZ
 /ZAcA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 5uz3s9k5mtq13bcd1qkbi91awd448rod
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DCA26C000E
X-HE-Tag: 1795172405-460748
X-HE-Meta: U2FsdGVkX1+PIYc3gz9pmTmCvezYYZ5NDfqQ6ghs0CXFCymZLlbbUArqOPRebqOlFcW3y9x6ga+OrgHwSFoHcQWBz9ao4RH6zNqdbjffHh2j4dB0zKW1382dADAf9AJV6OJZ2HNvBbZQO2AUsQGcBTm8fqCCx/rzBDdZpvXFf8aI1Fk6RStQnYAH2pnxUQfO/qeZBJ3WIwzKO06woMB/gEDfpH2EaF7Fu1z7HDElhvHBAVQ9yqaFVE7e1ihHaMrRiL2VRDfhI7xq+cOEQedW+GHk3k8th+ovCnXukDl6e84UjVub1Qwu9eRGbwfhWWjYbaZyWzeCRFujMTghGn8+VOfpD5xefl6Ig0M9goMGdXs5NCO7sLklT5bdnp5YYimVG7g5tXsvt50IcoVJZj8AaYUXEOOKrMqvDDr8VoskOOzPqI7Xt2bhjxJcOPV0jMZH9LevsTpGkVkZjoSRZwMRwu74EcnSwElmQz3B7BvHMBQXJi4AEErT9Rywyyvy2Obsdis12qFL1dIqdznyeQ4av2Z14toi1+lILyK7wcw7L/byRC9hFWDn/1d8N7E5WC9P5fc7HYUE3hBROzUPnPa3MuYkHi92gqw85dxVICM/AyvcjUBAP6R2wjXUnqcpiVOFQiSSy47r1q2iYHVEsOCNjD1Ig0jJYJtpKaiDwLFaqv9GA/fkeQzzJM+5ipMCKBgoRWcj2dpUV/yZHxbXfEw1CgD3gvZYD1IbuV/c+XgCKXePVEiZVGphX1Goaazl2cheVV6TdDeWZw9cZ3qljlmaYVvpNWB2d+8+2qCEm17fDFGE4Uf8zIt7lwmP6xqnRRmSaAp2TwfKLHsBrWjBo8w/FzXxbim1oNXczDUOl59h8nnEa3Vopd0XWoeUwS0pEAmyPkxEDgGQNjz5mA2tJvxkXwvr7pl7o1HBPafqUF1bhvLuuBFbvP87lNdWccfK1vFnIc2xbDGTUnkENpNphf4
 7nNMALxJ
 5+47W8towrTYwSsq4KqPTyMYTpBREx0sFgUVb9bnpYhcU2kpDjgVec8J+QbvFlsRIBJOPriqC5mRxJssZPdqI6C21imT9dB2P6dy6r8J9qgTQk2KIS6x/a9sL41m++a+aJjuX2vQtYyUbKkEIlgn0SJwSf2k5ZXm0fmmlqYeKt5gXuS24Bfvw26kqvC4rdOw2CpL1KdU0SnsCDF/vv9LUoxD4kstdrLyVb7x9SJ7zcH8PDEaDB7MGesR7SbaLa0UyjHVUr7ki5A2gHQRqQQSMtW0B0sQJwVRhmbCQ+F6P2d/4/I5rGQgbJK3ZVj+Z0P7BQvZOoy0c0wNUsUinA0DAMEyeLreyNwSr/JBX+7Wk752sfPaO3EF4WGHmSqn3t39SxQtJo30hJrF/KgK1XMw9mqVJNhlNwTHyGzTMK/hF+90vb5BpMnQkNr+g3cKyj6EzcUFbIeFcu96uo5Vo9PZZrRtD1q9bbbO0IMm2480p/eEB8ls7RXsJHRRy/MswXu9UAbcoEVCvr8pf3ik=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Currently the msync() system call will simply return 0 if you provide a
length parameter which, when page-aligned (rounding up) overflows (i.e.
SIZE_MAX - n, where n is in the range [0, PAGE_SIZE - 1).)

This requires broken input, and nobody has complained about this, but for
correctness this should really return -ENOMEM, so do so.

Also, since error is assigned within the following loop, remove the
unnecessary assignments prior to it.

Link: https://lore.kernel.org/linux-mm/20230321074035.1526157-5-mawupeng1@huawei.com/
Reported-by: Ding Feng <dingf3ng@gmail.com>
Closes: https://lore.kernel.org/linux-mm/20261120051413.46167-1-dingf3ng@gmail.com/
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/msync.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/mm/msync.c b/mm/msync.c
index 90b491a27a14..ced41d3c2903 100644
--- a/mm/msync.c
+++ b/mm/msync.c
@@ -46,14 +46,12 @@ SYSCALL_DEFINE3(msync, unsigned long, start, size_t, len, int, flags)
 		goto out;
 	if ((flags & MS_ASYNC) && (flags & MS_SYNC))
 		goto out;
-	error = -ENOMEM;
+	if (!len)
+		return 0;
 	len = (len + ~PAGE_MASK) & PAGE_MASK;
 	end = start + len;
-	if (end < start)
-		goto out;
-	error = 0;
-	if (end == start)
-		goto out;
+	if (end <= start)
+		return -ENOMEM;
 	/*
 	 * If the interval [start,end) covers some unmapped address ranges,
 	 * just ignore them, but return -ENOMEM at the end. Besides, if the

---
base-commit: d12eccbcb79a4fa35c3aa588eb79056af62eb859
change-id: 20261120-msync-enomem-fix-95f830e305dd

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


