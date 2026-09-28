Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D2A6C9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 08:16:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9AF46B008C; Mon, 28 Sep 2026 04:16:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4B0B6B0092; Mon, 28 Sep 2026 04:16:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D88676B0095; Mon, 28 Sep 2026 04:16:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AF5186B008C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 04:16:07 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2A0EAC012E
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:16:07 +0000 (UTC)
X-FDA: 85262463174.12.27BA3B1
Received: from mta1.migadu.com (out-231.mta1.migadu.com [95.215.58.231])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0D02040002
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:16:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=T37fRs8f;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.231 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790583365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=80PPjy013Wvr5+t5uRxRGRvw8ld2EmP1xVRy6kvWZ7U=;
	b=KTgemcMkBllziXfFRUcdqO0pnt1RQzm6hWc0yTLb4Ur40tTmdI6Y7TUxdk+6FF5dz2vpCS
	iKbYm+KatwZ8HFPQ6BpekA84xl35L1QvZWncuq8DEF33FMgXEHnrHWkisorgsjDVT4feie
	F68p6gGDTat+ZF7NVHXrh/lbnSLOqBk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=T37fRs8f;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.231 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790583365;
	b=WEWDpzhJn1skjmrQyFYZ8jIGvQVYNXMIho2P9WPZlEdmz7osNLr5un8O17kq+aMIBqXS/9
	j4aHTzv9ISuxlS9Ffh2cDubR6VZ7PvBNkJkPbsgBsUtwS2n+qx79QB4THdhe25h952hul2
	5c/hYp1YrRzbnbLUmtce18qZ3NfcZ/4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=4nfGVGrts9wIIS/qPwNM+5g6z35RooC5Zn4qvOag/3E=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790583363; v=1; x=1791188163;
 b=T37fRs8fq5/mX5gQRy7x6R6/ukmUf93gbnnc8xX4WuTmamR7NTFykLhfLqExMYKJlhYgYXHf
 7fpqpd6r6co0iXOP/S3X7dct847lSuq29LqVNxD1LZKR7qhdnuoDF2xwRdmBx2NUZQArmNEDLge
 546e3wfINp2bvP4Rk0MHHMPY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e3fae377f424b059;
	Mon, 28 Sep 2026 08:16:03 +0000
X-Mizu-Trace-ID: e3fae377f424b059
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
Subject: [PATCH v4 0/2] mm/vmalloc: fix vmalloc_dump_obj VA lookup
Date: Mon, 28 Sep 2026 16:15:53 +0800
Message-Id: <20260928-vmalloc_dump_obj-v4-0-6f288a431edc@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADkiumoC/33OywrCMBAF0F+RrI3kZR+u/A+RkmSmNlJbSTQop
 f9uIghFxOWFuefORAJ6h4HsVhPxGF1w45CCWq+I7fRwQuogZSKYKFjNCxovuu9H28D9cm1Gc6Z
 QsZpVSpWyqEmqXT227vEmD8eUjQ5IjdeD7TL06XvUkM87F26jf74fiDyX/mxFThkttVZMgBAK2
 n3vhvtjAxhJ3opiAQj+AxAZkK1FIxG4rb4BuQTUD0AmYGsAUYKWpZFLYJ7nF/ZNjz1RAQAA
X-Change-ID: 20260916-vmalloc_dump_obj-d80908447369
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, Ye Liu <liuye@kylinos.cn>
X-Mailer: b4 0.14.3
X-Rspamd-Queue-Id: 0D02040002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 8oo9p9jzx63q6nkgd1thuo8x5b397g9m
X-HE-Tag: 1790583364-951364
X-HE-Meta: U2FsdGVkX18+MRoYuBuHbICW8XjL1t7BaTGwQqPn1EKOQXf0LynAhc6M3UWukOkNIYQqgG5aKWWuBfI7TTuXRy0JOPlMUt6WtvJ/9wRF1S8THltF3LcpVN1OtAKSvZCIkBobs+l4KFqBO7RUApuYqaINp5kTXyMZh9Jaj9hrlGTrjm0iUOlZ5Xcimby2VGsAv1cYzJwP6Bi/MCiunCFN8ogIP6xUg5oyF44O5O71HqEu1qN4Hx+vPXTd+iH/1bP2pLuUBLM+sPJHMtA19iiNKT0mRTUIwiaLyCuMusdH0MdkDBg6Z5y6Hd1A4UP21Mc7o8F+9/E/P9x9cp9p8nUfWhMNItsF2pQ+crcYkdEqNsmOjgCEzl4zcIlK1clIdssX2uea0kGSvSebgjc+nne3HSfCeWdSBPicq7LJZWksWBbItNDQuqnupG+W/rrnLoW+ZI+2FzQKBRzxPZCObL5ztpXclYXX0KiEH281gthvuGG0RN4CgQAtZ1217/ZLAly+OJTihUtkZEzLw92jPhbvCTeaj5qkMCvMGI9CvMMfvRs5ak3QI0og2NnNm/D8SOKP/ZrEiVHDjahNrEBi7BwQZnhtsO6xsJ+RUUSRTDlBAJ+WkmZbxpotjfFHZvesqoyWthwuvhCmFGBLP3Cz2MqrX6YyFywEHYiZnvJiVJNnTdAmSQStC0DYAbON2a1frAo6ZQnq1auCcxXRg6RAk0iQhFYHvQET7zhKhuSJFUdK0LAEN9ltpLcPTP8NKYrklRnjZIGTU+Z803Jpw2hrFL5CiSH2pDGn1+1Ju6mnkDMvhV44NgSrLNDAn/BU8uPoKAvT0PU9cbTeAm/EeheW2EdmwTRqP4LxFhhiIbwgaumDcWYx9FUhbjjjSmIogo6VjPrfarVj65vIXYCDZ4CyPRya05Zwzm3cyWZ14L3xY0bFcRSG1Kpy7UoOJnfJBHnI+HBYNF8O//NeN/AnBtPcW5x
 71AyK+B6
 w4oHvFbrB4iarYgDiR1WitdD7afW2suvibJhBXVzd69R8le9WfDv/ciI1iPgUJ2B/N/p0lbodrE0+Kln64LlGjDlTRhPXVh2vkZSxyiKbC6HU62R6b/R7FAdX3wkTt3wEZt7APOcMu0BIR1rjDwGPj6qban9CypxdCzRxbUtSjkebdy66ulvLGxYE2sfTP1WfHhsi39JV/INYWo8sj2IcePIYCUdASVG2j8X1uP0+Oi1D7aRaRdoy3zPQABZgxh0+2rcqFkNxQ8Qg6N7t+dHzNxo34/B/EjC5h6B8VS9N75VXRcLFjPi8WPy9UQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vmalloc_dump_obj() has two bugs that cause it to miss vmalloc
allocations.

  1. PAGE_ALIGN() rounds up, pushing last-page addresses to va_end
     and outside the VA lookup range.

  2. The function searches only one vmap node, but allocations
     larger than 64 KiB may span multiple vmap zones whose VA
     is stored in a different node's rb-tree.

Patch 1 fixes the alignment, patch 2 fixes the cross-zone search.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
Changes in v4:
- Patch2: Simplify find_vmap_area() to return va directly.
- Patch2: Simplify locked_vn initialization in find_vmap_area_lock().
- Link to v3: https://lore.kernel.org/r/20260924-vmalloc_dump_obj-v3-0-5bdee3da37b3@linux.dev

Changes in v3:
- Patch3 drop.
- Patch2 Extract find_vmap_area_lock as a helper to simplify the code.
- Link to v2: https://lore.kernel.org/r/20260921-vmalloc_dump_obj-v2-0-73fceb3ed1c8@linux.dev

Changes in v2:
- Use is_vmalloc_or_module_addr() instead of is_vmalloc_addr() to
  avoid filtering module/BPF/execmem addresses. (sashiko-bot)
- Link to v1: https://lore.kernel.org/r/20260916-vmalloc_dump_obj-v1-0-7aa402d224df@linux.dev

---
Ye Liu (2):
      mm/vmalloc: fix vmalloc_dump_obj address alignment for last-page lookups
      mm/vmalloc: fix vmalloc_dump_obj cross-zone VA lookup

 mm/vmalloc.c | 110 ++++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 67 insertions(+), 43 deletions(-)
---
base-commit: e6e35979777d646fe3c7c94dca7dd32fb25d45f4
change-id: 20260916-vmalloc_dump_obj-d80908447369

Best regards,
-- 
Ye Liu <ye.liu@linux.dev>


