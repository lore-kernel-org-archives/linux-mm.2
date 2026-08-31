Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7963CC624A5
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 15:13:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E5CA6B00AA; Mon, 31 Aug 2026 11:13:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 773236B00AB; Mon, 31 Aug 2026 11:13:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 638B06B00AC; Mon, 31 Aug 2026 11:13:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 398AD6B00AA
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:13:19 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C03D3A011F
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:13:18 +0000 (UTC)
X-FDA: 85161908076.04.B2609A3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2AE47100004
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:13:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AO8IaFX+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788189197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1HtfgGFiEBh3+uueg+DAhyzc6ww3KykW+NDvD+nmBWs=;
	b=2Jf7jUcan8jOVRjLC/I+vmItIfxviDC5UucUuYnknfn4M/nq8RnLCYHMWpn3A+E/bn8zsn
	qcWd7d0ngtH6YkTihWKVbFzdRyTTb5khgsInS0l+e/HBONLQc7Bv0kM2JJWxC9OctGXkwI
	QZzQnrCjhhx7ciKXQRPKAZJ4Q7RLw74=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AO8IaFX+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788189197;
	b=VLA5Tpe7F0a8Juekgfzwez/tfbZjy3qPgwUNgMqb4tHT+zUKK4OOZZjFwJz8kqwfLEk5Kx
	tdGTedRvXTJwjx0bhI8VRCb7U3vGFZcl1qSfB5ZZ+4Y1rYrJsQ2+4hugvhhGJHyVGk+EhD
	TksDF+uDmVzSWWgcO3rAWpvF5YqOGBg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4B19E41335;
	Mon, 31 Aug 2026 15:13:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC8E01F000E9;
	Mon, 31 Aug 2026 15:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788189196;
	bh=1HtfgGFiEBh3+uueg+DAhyzc6ww3KykW+NDvD+nmBWs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=AO8IaFX+fTD8vDibWVcdOTpG/5DKRXt0IQmtsbiW1CW7xMY36T1FTddiuClFkD2oB
	 58pc8VeSe/KUscbFWUfGA44h89AJ1vNZZuRHYVosvMoELCX6/i+oQygeKryG+hjm1c
	 zDJqLZAfZPqipV5aKzd5hOzooY8fI4PQ8q3bA5UkyHFtRG++JEpXvCoFDIVLImqNL9
	 NaA26YjgLsjG/PRQEr0UzoGb8tNvqcQ6AbNenF7vmSBqOcL+9s9lYIXoM929V1VC7e
	 UhSymhLRtsAmOWFbAnEF8LMwQoFq2P8R2lS94RKnVOCiVdQ4WrHRapASlNyE1Xo+pe
	 7X/eXQ2BYnJ5Q==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Mon, 31 Aug 2026 18:13:02 +0300
Subject: [PATCH 2/2] MAINTAINERS: add memory related docs in core-mm/ to MM
 - MISC section
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260831-docs-memalloc-guide-v1-2-547718c274c1@kernel.org>
References: <20260831-docs-memalloc-guide-v1-0-547718c274c1@kernel.org>
In-Reply-To: <20260831-docs-memalloc-guide-v1-0-547718c274c1@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.17-dev
X-Stat-Signature: pwq37bu4ipsftnfsfmrrfgd5p8rd3jya
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2AE47100004
X-Rspam-User: 
X-HE-Tag: 1788189196-520779
X-HE-Meta: U2FsdGVkX18o+XUynGgixEqpWHy9sgJ7z3xd4ByLLTZv5U0smZ4P2Ou133jwWqLe8RKWYwUFrJJCYgn/QN4T9+0pkqd4HBxLVzqEd67iI5C+cLVZu74sMaWaDh2qXOv38jZwhDc4NSZQa0120dfyobxJr05Jf1QA+GfDxy/V6eHoHazjELtD+tu0VaMBJ9szbXec5Cr7lUr+6matfKLJg/93wZYe/MWUciYefy2vii9C2pYHcj48UefnjAnaCkLvSal4H29iwFDDDs097n57daD6vgGxM9qx/7Qp7ucJEjuDYv2VJRxnQFWu/rHEKxtdBE+g7k+uLpasT8sh9QU3UhAMgYPkO1dyQIJuWoSdfCzKw91Lp7tfoSGOLfDTjk1blZvzxQapmNRlSGlFutq7h+DHS50ZKclULjUCVE+BK4owt42jw5pqIxKkJjr4kyTEgxPS2CDDbjX36iWENvwsnJqAzi+8c853p8hEeQTs9aCfapDhbAiWmwtSZGKq2YlOl0x43ok8j93znVXR9wJozp7Qf62obOggAFJC5V6m0WgPY3zMEv5MjjQxmO97QqOngJ9wtUHtqL91ch8ukZf9qngWr/Bp+pmVfnMh1ebmuYr4wGue9GV2I60X88/ABDX6tFfgHUchKY8x5u37YSIFNwBBWFVxZFKom5SrYe6YRnF6uSRK2tdGETQiRqa6p8sAd/mQ10RT7BKYxBCtoZboRLjC9XpIBPGHadcz2NC8YbNtca3Y1wIbexzhd1Il70cEW9EDv6xwaFFoXAJ+bV9J8BVnHGh4rig4UA+J5/RpY8Mwg2MpEZbc1yAWcYP3fCoeUy12qmbXKOCHK0JiV9woSP4006YNgMSpNm80kAK738DXGVy6KEFun2rpdBr0ZmjJ5EG1afGux9E1fVwcpuGnBgczrLCqKrYKgO7QxLLt+ogGxVKw/ASOWJQCsI5v0t26XYIGCLv3phHSKnKR3E9
 idV1K6/k
 ExbQnVyCEJkRgW+Lxy9oUpXpdSaMMBelujjJ6RcF7oXMrhovde9Y/sGfQoLWufxXqw3XEkd81rXr7HIyx6V8tVDg3G7NoQt0YrRpORJ0UCqKGnUBmgwI/9v7JVQ/kDxmH48lwNVma4n/2J8/M9ypRJNokyRip/EogQKKJObf/mgVvgRKpKo+Bghen0Vp+cvIIRY3p/cnlU2XX6Ar8sROaMCHQ20IGzHm74cx+UQcwwPSADqt2+AC1GcBRkg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Previous efforts to make sure that mm files are properly listed in
MAINTAINERS missed

Documentation/admin-guide/mm/
Documentation/core-api/memory-allocation.rst

Add them to "MEMORY MANAGEMENT - MISC"

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3a19da74d00c9..707f93320ad72 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17275,6 +17275,8 @@ F:	Documentation/ABI/testing/sysfs-kernel-mm-cma
 F:	Documentation/ABI/testing/sysfs-kernel-mm-memory-tiers
 F:	Documentation/ABI/testing/sysfs-kernel-mm-numa
 F:	Documentation/admin-guide/mm/
+F:	Documentation/core-api/memory-allocation.rst
+F:	Documentation/core-api/mm-api.rst
 F:	Documentation/mm/
 F:	drivers/char/mem.c
 F:	include/linux/cma.h

-- 
2.53.0


