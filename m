Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DF3DE6F09F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 16:18:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E77516B008A; Tue, 23 Dec 2025 11:18:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E21696B008C; Tue, 23 Dec 2025 11:18:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB1F96B0092; Tue, 23 Dec 2025 11:18:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B780E6B008A
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 11:18:29 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 823D61381BB
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 16:18:29 +0000 (UTC)
X-FDA: 84251243538.30.D33D8A7
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf05.hostedemail.com (Postfix) with ESMTP id AB457100015
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 16:18:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Ci7tyW6x;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 30sBKaQgKCM84vx57v8w19916z.x97638FI-775Gvx5.9C1@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=30sBKaQgKCM84vx57v8w19916z.x97638FI-775Gvx5.9C1@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766506707; a=rsa-sha256;
	cv=none;
	b=u1VslF8csM/C17YNVNQjyHwoQBmfRSqOp7ExGLkV9y3Mtoo+3jwfgJi9lKD7VCGRZReX3l
	r11gqvYsz1ZWpnlGgzubWL54O83aYdOOBf4izQBjC2KO2eGa7L/tTjL5gKDMkc6oxjxX89
	zfxzFIIDeEgYFPsEuA5tpHYRc4yWkyU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Ci7tyW6x;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 30sBKaQgKCM84vx57v8w19916z.x97638FI-775Gvx5.9C1@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=30sBKaQgKCM84vx57v8w19916z.x97638FI-775Gvx5.9C1@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766506707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ecq4ux8juxn6/rOyJrhpTEUfUCldUGcEOc8fd0njwT4=;
	b=bTe2aC1I4wz64fnMwDQawNXkePMtFcLMNCKXp/qamn9erhOe72nQv5UdBND48mVw8vAj0C
	QgEC+6j5iKGu51RuC0msg5hif1yviv6ZYLEkX3BOveZPiUUI+fZ8evBatnEF/WdUUbxZRD
	aHqRvxmrii3Z8AKi4KGyULpBtViybYI=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-430f433419aso5030507f8f.0
        for <linux-mm@kvack.org>; Tue, 23 Dec 2025 08:18:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766506706; x=1767111506; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ecq4ux8juxn6/rOyJrhpTEUfUCldUGcEOc8fd0njwT4=;
        b=Ci7tyW6xQHNCzy4ujAFb8UH7HquvLrwXpdO5v0EvWeZPnFuBoSK6t/AS+9j/AjLqFI
         CgAFJL5b3jlN8CVF6C7dvnEq/gqEfkme279XtSQifzmt9Q/K/ujReufUjDVZcYN/iF06
         UMlCnXNDlKUHJExLEgUZHzlClHBCbveDVHRfh1fId0yxPmbAShqqPsM0sEO+EaSHl/eF
         ua8tNHVV3JqC+ZcByADSybDsRoPokcJB0hm/MhXk1mdff8r05COou9tBInrw19aXZYtd
         ux+5eKTVe83y+FwMxSwzp8UiujBFN8/cqdMOE2qdANRCrgTfHEolXjck7MX+2cXCuIox
         lKCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766506706; x=1767111506;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ecq4ux8juxn6/rOyJrhpTEUfUCldUGcEOc8fd0njwT4=;
        b=QP8JjESmU1x2TV75J6emM+ibCKtoLjLAy8sYC53iCpd9oAlX2p+HskXaEy2HBKCoCa
         BYnhpdtPx25duRh7d5ZrjByCW0ofwtcQ8R/tE/a+nHeK3cSVZKbcQ0fSiKfAaXQOEYJX
         RpmdI5Sc6CaKLKq5/1cam70JGgAVpWQ1CdnRjqdOvqs/8ufhMGSOqEyMvNNJnyBlLi+x
         kFfxORRQCzZuWj/Q2B9MJYBA2NDw2NrYDzUtPTsEF0yvkTR5fVF+XkJpaz9pBLWZD4Di
         2wIQG36076i6HtLmNHJGd+T9GkLL39KFFqhncAxY+GwbIEY+e41fX2+OStXWRvNEwWQP
         KM3A==
X-Forwarded-Encrypted: i=1; AJvYcCXo2GW4fRRxR4/LXehR9LB2Z/XR3MyPW83efQRywKoCiUBILY0wsnz5tlKzQJJM/bfbGRFGPspvqQ==@kvack.org
X-Gm-Message-State: AOJu0YwFgnJelYo2wT3HKOK6hhUVxEEsFenhfUxVVbe/QELHSMX3zkjd
	sBgGJA/lc+E8iDdKIUFjFKfWvYFJbATfeqM39D5biExfofk1Em1YSxbd9B4c5kHib7oTHhbOlJb
	AS51uVmoVZnVDLg==
X-Google-Smtp-Source: AGHT+IE63cPLMbu1UcIi3eff/7vrdmKmmwcAwevA03KE9Q9fKYy9YzX+rmosSiA8nVUqbpZhJUEcq4BVB0L3Ow==
X-Received: from wre13.prod.google.com ([2002:a05:6000:4b0d:b0:430:f216:9f71])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:24c7:b0:42f:bc6d:e46c with SMTP id ffacd0b85a97d-4324e4d1032mr17311664f8f.26.1766506706286;
 Tue, 23 Dec 2025 08:18:26 -0800 (PST)
Date: Tue, 23 Dec 2025 16:18:12 +0000
In-Reply-To: <20251223-b4-kunit-user-alloc-v1-0-fb910ae0e50c@google.com>
Mime-Version: 1.0
References: <20251223-b4-kunit-user-alloc-v1-0-fb910ae0e50c@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20251223-b4-kunit-user-alloc-v1-3-fb910ae0e50c@google.com>
Subject: [PATCH 3/3] kunit: test: fix mm_struct leak in kunit_attach_mm()
From: Brendan Jackman <jackmanb@google.com>
To: Brendan Higgins <brendan.higgins@linux.dev>, David Gow <davidgow@google.com>, 
	Rae Moar <raemoar63@gmail.com>, Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AB457100015
X-Stat-Signature: sdj9oifb787j69t6um8f4jg9ejsfhwni
X-Rspam-User: 
X-HE-Tag: 1766506707-750192
X-HE-Meta: U2FsdGVkX19RmFr72kigiId/BXf/eZ/Vx3H56WRGlFEmdGOmzsqMY594SnHpCD2DO3X3LujGVB8kHpp9DGfKhxdj+J1B4F7rAqMCinyI7q5alag+rx3QKfbU4pMIY8Q3gh3FCc970xmac04366ewEFeMmvKKL7BMEQLVCx44TBoOIyqrQ19N/C7CdRySQKGoZ3uKDaSxNJcWL+Fkh0LyaXEL/mA5g9pIHz46NvVT1QyPCXGCiAay3e2F6tvmU7r5LlqIg1eu4RVP0W8/xFu+aNK67XA5u5bjtUMO0hBoHQTPYVlPRCWCMU18o+lnLmEkIw4zJJS0YScUCJxNJV1cIsjZQCa3u8tk1ZKToKsmvVEGddFNhljs4wK9mcbC6SHkd/8xwGb0L+/Wv11gIMab8x/1k2qyU+mZRNvqwgI+d3ynMH50iKNj4HUHAF8rDtna42c4HBvdXVyF5LBHNT9a1z9wwjcioI5NdCZIvyN/7y63TtVSuU4LbHq8l6BGh2y/b/wDcoyzvrjYHxg0dHTgY1O1z6/MVqcLAAOQBjpT8bLe+HKFL/T1P/o5ihrlwcKRXqxOW0atj7kH7slHowSrhicImg+n6zncRVd6g2F53TtIWusufKauOR/D/iAOoqKThgedNeLtXknVspBrpy4fgCejMuDRwoPE+i1hvAUNW3sapYs8F/VzmGLONhcoVFty7n0YOHrcVTCw5T6wAaChd1LcVpDbr94jE6zpkojQS7OWPjo79jOg4aeQwupUDcbdBCsQcSkLRDFfsovrqhBG/Clusz9CpH2uEtJiRDXt6ARQFsMqiF8jdkF4w8Ei9Wu8EP+RMrh3SzNyxXh1cWk51kMg2QQaSqS4zrTShVz2n2IHfBFMS50BNxHRKs91are27I/1qXp+tonfii0n1XUbKwHxBKas62TfZ6GTdSJaA6sLGQVcV8cgjTgktqB1nmDQfaBU3HlvH48KnGV+xhT
 ubSWzktp
 qOZkgty9IwfGoL+HQgL+Tk7wEIRzy7woTKERDIfQdM3GwM+yDmwMB9q/zisFy8vrEoJYjAeA9Wt6eLbX46PnFbkllNrxIyXdy9xN7dcziVlWLybNk3vvtZ7dSDS6kXq21svkh+w+CzEVzYOyXLtdXznyZeigLthhBVZSZaAs1T5vEZcw84KxW2yu18Mr2a0LMXeU+ntHP3/o/OzDEwaadJkK+Psb0YtgICtEo/7GkpRvotO9aDrlOfywcvuCsrEix11tgkBm8BnnxwTnKUgyLYXkPe24Nlv62LNO2SRfvZces5T/e9b/BZ/g755R5+aJqTjwpZKz0sZkRO/ztM6573NCCBGy/eS1qnB2Gn+T5Sm2xzE/SHkDSycb+oaE41gvzZMJrx3y8GRkR1X4+iqbEfZC6bMhcFOXBkQv7TMjLWmDQYvg8zGpEeyQpp9M2o0bIZlE5eC8iCP1Bg2979sOsHArykHN2VDT4cB56iTmXlBzlgbK3rmV7QnWYvWdZl+6LzRyJt8sP2h/tC07W0r4cV4ODeNsCHlPq26n7OP0unvnbPtd/yCJdiSsKxKmZoayc/jDZB8lVCMGP+VlUcekPCp3U82WFi2/BwTkJFtAoOyDvvWs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Here's how I understand mm refcounts:

  funcs             | counter  | manages lifecycle of...
  --------------------------------------------------------
  mmgrab()/mmdrop() | mm_count | mm_struct and PGD
  --------------------------------------------------------
  mmget()/mmput()   | mm_users | userspace address space

    All mm_users references share a single reference to the mm_struct.

mm_alloc() returns the mm with a single reference to the user address
space, i.e. with mm_users=1, mm_count=1.

kunit_attach_mm() then passes the mm to kthread_use_mm(). It does not
call kthread_unuse_mm(), instead it relies on the kthread exit path to
release the relevant resources. It does this because KUnit's resource
cleanup logic works by running cleanups in a different kthread from the
test. You can't have cleanups that operate on the kthread, because
the kthread is already gone by the time the cleanup is called.

The kthread exit path will indeed drop the reference to the address
space, i.e. it will call mmput(task->mm), decrementing mm_users.
However, it does not release the reference taken on the mm_struct when
kthread_use_mm() called mmgrab().

To fix this, use the new kthread_take_mm() which provides the API KUnit
needs.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 lib/kunit/user_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/kunit/user_alloc.c b/lib/kunit/user_alloc.c
index 564f5566641d5..3fca4ae223f67 100644
--- a/lib/kunit/user_alloc.c
+++ b/lib/kunit/user_alloc.c
@@ -29,7 +29,7 @@ int kunit_attach_mm(void)
 	arch_pick_mmap_layout(mm, &current->signal->rlim[RLIMIT_STACK]);
 
 	/* Attach the mm. It will be cleaned up when the process dies. */
-	kthread_use_mm(mm);
+	kthread_take_mm(mm);
 
 	return 0;
 }

-- 
2.51.2


