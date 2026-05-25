Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67180CD5BBF
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 07:27:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBB7E6B0005; Mon, 25 May 2026 03:27:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6BA96B008C; Mon, 25 May 2026 03:27:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B32F56B0095; Mon, 25 May 2026 03:27:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9ABA26B008C
	for <linux-mm@kvack.org>; Mon, 25 May 2026 03:27:00 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4D646C01B1
	for <linux-mm@kvack.org>; Mon, 25 May 2026 07:27:00 +0000 (UTC)
X-FDA: 84805110600.17.BBAFBB5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 948B740008
	for <linux-mm@kvack.org>; Mon, 25 May 2026 07:26:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kiDkaFUf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779694018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=UchP/YryN8ShfElUF7tvJ8YxQt+G+f06NhHQ/fUyNOQ=;
	b=IpCKeYsTb+gNGJFmVflxwBEbDMkI9wO90mooPoiQ1YNfYArDBE2totPTYrEY23jakTkHao
	1p+qu4JqTy8//E2h3eMB3K6peWcCkMJ6pVDaf9OqYU2ylZP/PjoojzfZK2n+DmB52pfkFr
	WcZL71Wm0tlCEQcdUVcVxFhaEW4AEno=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kiDkaFUf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779694018; a=rsa-sha256;
	cv=none;
	b=Kfs/dOOGeZ02nTYnqeOCk1MdTAJ+wcOduAgHWCKI7NwzYQKSexnX8qTzfFGyfuNSCNzTz/
	ZjT5pQu9+GkPkhZE7S0E5l/msmNtddCO9VBVCX10wZWH0CSFPEsfIQ+lXy/lYsB/cNYbpj
	zuVmdjyW8HNAMMZOJzgs4UyRqGHXvNc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 087CD601F4;
	Mon, 25 May 2026 07:26:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01FCD1F000E9;
	Mon, 25 May 2026 07:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779694017;
	bh=UchP/YryN8ShfElUF7tvJ8YxQt+G+f06NhHQ/fUyNOQ=;
	h=From:Date:Subject:To:Cc;
	b=kiDkaFUfmTi3a9TbqXNzXrgpq6xd912LOz+ISJD6Z/EGHz/wJq7RIIPy6XGxdh6SJ
	 whTZ7QneydfpcNmLKa2/V8n5eMIvuhz8NYMl9uAsnX3TEpsNF/q+dA3/gB8tWCvdIa
	 ZFBeVvYqVwXXN+rtEuUIfN8hjos2gda7dmvYM5SEHxTYL6fveu2UB7PJTBwbvZCrIS
	 M44UjwYdVFgetIO5lOITz/NlKSDA4O8Nh2ZOEB4HQlnDi1mKTqSH/wjXRgsE4z2WOX
	 C0oEXC81Io0JH1p5zcJBjfF71J34FMC0KP91VlKKSXPD3LDMNApY2DbgQD/C1lbj+2
	 bXm0Q5Rd9He0w==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 25 May 2026 09:26:39 +0200
Subject: [PATCH slab] MAINTAINERS: add slab-related scripts and tools to
 SLAB ALLOCATOR
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260525-maint-slab-tools-v1-1-d66b69f1412a@kernel.org>
X-B4-Tracking: v=1; b=H4sIAK75E2oC/yWM0Q6CMBAEf4Xss5fAIdX4K4aHAqeewdb0qjEh/
 LtFH2ezMwtMkorhVC1I8lbTGAo0uwrjzYerkE6FwTW7uuOOHl5DJpv9QDnG2ahtHO/5eHCTtCj
 aM8lFP7/kGdsP/X+113CXMW81rOsXCDm+5noAAAA=
X-Change-ID: 20260525-maint-slab-tools-316242876de3
To: Harry Yoo <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=906; i=vbabka@kernel.org;
 h=from:subject:message-id; bh=o5w8fsGRtApCV6Arf6LHgnRCvlXGR0vVZaYcWuGOsNg=;
 b=owGbwMvMwMG4+8GG0kuuHbMYT6slMWQJ/9xzUpn59Iy3l949s3N7dDRyncv+F1xiK5U/dxilX
 9z6V82kpZPRn4WBkYPBUkyRpXr3CUfRmcoe0zx8P8IMYmUCmSIt0sAABCwMfLmJeaVGOkZ6ptqG
 eoZAho4RAxenAEw1uy4HQ2cu5yXv6rKvLsULfmbO/B2y56qJ96ltzvm8d245vwhqXdb86cz6dtt
 8tgs+0YGShVPmiuy+f9j+/ez5m8P5i9ky5zlnnWxpaAxt+MyyNXejwIXzHQ561VnsHJp+cmV+R0
 6Exrx7ZdHvWbtp20Q7N0/tXJGA7jvPzlTevD/57B33Bcycd3SZ9C98OP0p9UHh//qLnr2rP7/8Z
 +Jt9vPR2ZzExYV1vHMszdU7X71+pcqj42PT8OhJjU7sZ7eQV7tlJDObt0ZeUuPNvXn0kfbVp9ev
 WpybwRaZbz93SULfisQvM1pvfzTZmxrn/MAj18felYeTZZZeVd7/z5UeL8V62AweyVskRq1Y9I7
 5yKsQAA==
X-Developer-Key: i=vbabka@kernel.org; a=openpgp;
 fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
X-Stat-Signature: 7orqx4z43e41d9p5c8x1fbd7kqywmcwy
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 948B740008
X-Rspam-User: 
X-HE-Tag: 1779694018-456603
X-HE-Meta: U2FsdGVkX1+GXSlQ4XnDnpZmVVxcJkDsdgu16by1fC58ZfPhtsHL6wV7cmYrbQxDQQbAWpGVM1h6vUoJjpro09dkwTdRY6mjHe9oZU8uf3Fj1LsUol88h4prUkq9XSIjQHW0hJRfgqOg9/Gpcaqb59geLoc5TTSITQixCxGrpV4KiQjZGmbXdaJ4TeMuU6vNv5wzqCGRrPzD1WCrYRrBq6rnBi/30T3tOrf1+kvKh3S6kpj7ubMp/gTVxpPVGWSARdM9uIKVN6ey0XFM9pdrL+bZaNo/VvrSiHP3pEvBbQgnrGJDlr/ZjgClsRPkHrOSy5fIugwufEJcysTvT+JOPNHKclDP8m8C8pJnTO/dzCecwnghpZoKg+zujcciFkC7TQh4rwzA49/0+7LPWJH6NIMEUCHq/d4lAOOJ9Be3ZZgzTq2S2pa0LbKqxFZ7BPQqGQUP4m/qEF3YB9S60kb7lnjd3mJzq82xUypy4DCJInBvXh4LQUV4O+XonVoh0giqrc9rUROoYpDiG6tVO+2rd4KwkxbZrT6U64rVwExoAo+viJ6MJGOysztaIlaTO2C+fhPBRoPkcuTyNyjhFQ+GlmQYXY1pz0vvZou8Y70ZSt39tNgp6XTtDNKXM+/ntJTC7Tx8tivbJ/DNtlFJxts83ayLzfh3yzh+UvvS2jWcFQ2mW5S1G5q6+kiWp8tIEsbiiehqj52ozMMwdzY4ORPIumn+11tyl/GBy4u2bF/uDYeXcNEzJxSs2cA+/2pfnzGpRbhL1QGLioZ625UQ4vhO+Jk9SNp3A9u7DbBDft2dEPimPjvbXivY3NKaGslWqwh5W80ssJZPdP2f/XA9z0W15Tg179665FdaFnc/XLtn6/6+yuguM1zB8b+O9bELo9eA6K1/alma9b2wjivrgq91Lp/oRsq8GvZJV/W9PsgnxpE+Dl88HI0+J6y+xrFNMdNZd7GqGxWtvg4K1m+eqeQ
 QdT5vmiw
 te3D2p8vVwhpFkLT/uQIVtgJ7OLRUF3SYiwfoh9T8Q/IppZN2Zf8e+mOAFma4XmqVCQKKJ9nxLXF3wiT9XBxihEYfZaM6AMOnNSnTDgDYLCD276VDFSiejnjbDzxSgSrhdvkvmPMrrOX4e9pl2KH4c+CoSlXa9k/6vSpb+BzyLPUvbIKHZKapeta2kC8Mtgx2ZcNzM9XPRPnbi7vC/cBC+OrDcrhpz2DzwY9mshQR9dHx3xKTES1rmx3M5uLxVcbWH6lZAXvIqQ3qAmtOcmt5KVWP2FPYrOrewesARIfRdlHjTao=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make sure the maintainers and reviewers are CC'd on changes to the
scripts and tools that depend on slab internals.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 288866c32ade..9ee06cd35793 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -24555,6 +24555,12 @@ F:	mm/mempool.c
 F:	mm/slab.h
 F:	mm/slab_common.c
 F:	mm/slub.c
+F:	scripts/gdb/linux/slab.py
+F:	tools/cgroup/memcg_slabinfo.py
+F:	tools/include/linux/slab.h
+F:	tools/lib/slab.c
+F:	tools/mm/slabinfo-gnuplot.sh
+F:	tools/mm/slabinfo.c
 
 SLCAN CAN NETWORK DRIVER
 M:	Dario Binacchi <dario.binacchi@amarulasolutions.com>

---
base-commit: 67ea9d353d0ba12bdbc9183ff568dead9e949b80
change-id: 20260525-maint-slab-tools-316242876de3

Best regards,
--  
Vlastimil Babka (SUSE) <vbabka@kernel.org>


