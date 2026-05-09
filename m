Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0614CD3445
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 01:29:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1849A6B02E4; Fri,  8 May 2026 21:29:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 135D16B02E5; Fri,  8 May 2026 21:29:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04B876B02E6; Fri,  8 May 2026 21:29:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E6AA56B02E4
	for <linux-mm@kvack.org>; Fri,  8 May 2026 21:29:36 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 76A971C0387
	for <linux-mm@kvack.org>; Sat,  9 May 2026 01:29:36 +0000 (UTC)
X-FDA: 84746149152.04.604135E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8A7C620006
	for <linux-mm@kvack.org>; Sat,  9 May 2026 01:29:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bTFXSijB;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778290174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S9cWFVJqrAuExa6uSujnt9tS5dSOJEOIPe/948RuRug=;
	b=T2fNSaUXiDIad2b8ZZpLq+tlhuGBQBVHjtgkW9cifXNUt7OOtXypyQ9XAGvBfura+rzsVh
	DN4zxA2zQxrHnlLwO04cpk1sF2Egl9JfeoQbgZnYvY7aBeI+BuFT6b1sYwi8eWMIkzmY22
	7DeaOHys+X8s1bwce4pbPOSn7UH5k1g=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bTFXSijB;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778290174; a=rsa-sha256;
	cv=none;
	b=RtXDcFKSRMtlhPYsyT2mGOdOOltm3uQE0EW9KWmNEB7bk26M/Tr686JvzwDQQ3oJt92jN0
	9JLrQHDBDd+/n+2QR/GXclQK1docm/XRzG/PvcMjf+Tqa9tg4qVaUp8T5GER8Z98Fd2SY+
	vODE1rcKIizKHU/4DVMLyujeb1l065k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 454F740427;
	Sat,  9 May 2026 01:29:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD81EC2BCB0;
	Sat,  9 May 2026 01:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778290173;
	bh=i9QJ5WVSJdg5uQkuaetOnTEwzu0MFHwRbyFFAWZvYmo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=bTFXSijBCGrOC3TaP7CWdWKJavw7s7CgBpYDB5evLFALWV6CljGRhEEZyhD6COQML
	 g3xSfSoD34Z2RuSPnk4KaALCiQMN3zblF6+jqNgJwNrDr27x0zNgJxyoT8BsbUjHy9
	 03zW0zcPgYhT1wVE4102cmwRiVKpDK3obixatNGk=
Date: Fri, 8 May 2026 18:29:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "qiwu.chen" <qiwuchen55@gmail.com>
Cc: rostedt@goodmis.org, mhiramat@kernel.org, hannes@cmpxchg.org,
 david@kernel.org, mhocko@kernel.org, willy@infradead.org,
 linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org, "qiwu.chen"
 <qiwu.chen@transsion.com>
Subject: Re: [PATCH v2] mm: vmscan: rework lru_shrink and write_folio
 tracepoints
Message-Id: <20260508182932.ee1931dec680db80a8a8e660@linux-foundation.org>
In-Reply-To: <20260506083652.100160-1-qiwu.chen@transsion.com>
References: <20260506083652.100160-1-qiwu.chen@transsion.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8A7C620006
X-Rspamd-Server: rspam06
X-Stat-Signature: 1y745y9psrrzfnurn48b131jganpdbb6
X-HE-Tag: 1778290174-941908
X-HE-Meta: U2FsdGVkX1+tBNZkWciSojJC7noeYySu0zrTgUiWFx4oXvh8O/1c3ymVvE86BjbnZeXL3UODOiZL/YQkFUN9AsP3XqCwyi5BnktnV5JX68yAqaPQ4UX2LWtRvJ42EuLnDn6yEIJoI+wlWqod/QI59nW06o3e+LLiFJqhWWZ0xLLs/45PPHLAt3zG5ABZpm+BhqsBtZmNxrohdYTaS0ZMG24RFXgYS2Igio7OO5qqoE6ZnmGFe45ihBwlMREtktIj/YtiLcl1BONv6Ebxj6swJ8Q3Wv8+TKNBfE4PUqt2z9//y8jp0z+A5FEeOxgvBXdLbiUriIGJRVdDy6KCKHL8A0pP/1zlpqMd318vR6QiwSk/8zgWgRoKol1zM2VvnnYV07eYysskCAdux2JN4c4QcAWtG/weOItS05UcNpJ4sRugv5GeLCJW6YBqnt/nAjkZGalA6NEbU1OX5kIHwvjqpCu39Xi6yM52q8fks8U055Ie/nlQyvbqRpZNXCyURGjtfPF8fgX/ilkEfvFIoEmO5Kny/n13LKSTprN1TcFPRgzAYyqYQsruNlJgKwm0KSSGiUC8xwZUVeU7brvfWjBEVFC4SkzGl3NPzuMwAYlZuZ/e+4iq+U+DmBMtvnj5HI4JtnujoYMYuIRSWu4Z1xqINbJ6Y831c1IBijCZGr4P+ijSyybJGfzW+iVgc3rxj77tE2D+Thp1pmGX6myaZAbLxtj84VjDqnBjGkTPe2MKycV8Da8ILVUhd5g0+jr8hNArsVtKiZcT1K1KJmV3eQd8VL4N2+owHPnCjqJGkaTcnq5xb5e9rTLQydJpWvag/7MRZrp5khW4aTLbqmTEFUryL9yU4IPU5tkyhdoUt1mXDaFS910JamyEoB8jcM6dK0ce4LMIdJ0WX+qE4vQaOR/i3PGhXg2WoSvXKBhjU9IjlKiDw+2sweNdA8ID+Q8SU8ER1OSC/GFt6OPVG3IKDrA
 QuGS2DB+
 YsQHrVuGef82fKHDY8ObWPkR/+8bdAnmaU0QgsOADTUK/xpakuDy14iu+13mFgjlIy3bnpwSiS6M5GL+syHqIRe6Y5OtqYkCq/9mt8A1dQF48kr/rnRt2Qt6HZj2uotQZ3EV6rutHnKOZtG40T4oN+uUideofdPiM2lZMlsAqi/JykN3BP/kAgYkGYl+Q82N0+Yx0W5jA2K+fkaHqLWOPr1fpoF98l0J/RZUWXS+vhAUhxlkrNhg4TR9svA+bVznh+BG0+xmlJxMOsTItKwwGDTGoIoBjrBYcZ3MR7NbM/YF1ncNUfDZoikMTWS1i770Kw+oc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  6 May 2026 16:36:52 +0800 "qiwu.chen" <qiwuchen55@gmail.com> wrote:

> Currently, reclaim_flags always contains RECLAIM_WB_ASYNC in lru_shrink
> tracepoints since commit 41ac1999c3e35 ("mm: vmscan: do not stall on
> writeback during memory compaction"), which is useless for debugging
> memory pressure issues. Other RECLAIM_WB_* flags are not used anywhere
> else, so they can be directly removed.
> This patch reworks the lru_shrink and write_folio tracepoints for better
> correlation and analysis:
>  - traces each folio lru type instead of reclaim_flags.
>  - traces each lru_shrink with reason.
>  - remove the printing of the unnecessary PFN for mm_vmscan_write_folio.

Applying this to 7.1-rc1, my x86_64 allmodconfig blew up.



In file included from ./include/trace/define_trace.h:132,
                 from ./include/trace/events/vmscan.h:602,
                 from mm/vmscan.c:72:
./include/trace/events/vmscan.h: In function 'trace_raw_output_mm_vmscan_write_folio':
./include/trace/events/vmscan.h:358:19: error: format '%p' expects argument of type 'void *', but argument 3 has type 'long unsigned int' [-Werror=format=]
  358 |         TP_printk("folio=%p lru=%s",
      |                   ^~~~~~~~~~~~~~~~~
./include/trace/trace_events.h:219:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
  219 |         trace_event_printf(iter, print);                                \
      |                                  ^~~~~
./include/trace/trace_events.h:45:30: note: in expansion of macro 'PARAMS'
   45 |                              PARAMS(print));                   \
      |                              ^~~~~~
./include/trace/events/vmscan.h:342:1: note: in expansion of macro 'TRACE_EVENT'
  342 | TRACE_EVENT(mm_vmscan_write_folio,
      | ^~~~~~~~~~~
./include/trace/events/vmscan.h:358:9: note: in expansion of macro 'TP_printk'
  358 |         TP_printk("folio=%p lru=%s",
      |         ^~~~~~~~~
In file included from ./include/trace/trace_events.h:256:
./include/trace/events/vmscan.h:358:27: note: format string is defined here
  358 |         TP_printk("folio=%p lru=%s",
      |                          ~^
      |                           |
      |                           void *
      |                          %ld
./include/trace/events/vmscan.h: In function 'do_trace_event_raw_event_mm_vmscan_write_folio':
./include/trace/events/vmscan.h:354:32: error: assignment to 'long unsigned int' from 'struct folio *' makes integer from pointer without a cast [-Wint-conversion]
  354 |                 __entry->folio = folio;
      |                                ^
./include/trace/trace_events.h:427:11: note: in definition of macro '__DECLARE_EVENT_CLASS'
  427 |         { assign; }                                                     \
      |           ^~~~~~
./include/trace/trace_events.h:435:23: note: in expansion of macro 'PARAMS'
  435 |                       PARAMS(assign), PARAMS(print))                    \
      |                       ^~~~~~
./include/trace/trace_events.h:40:9: note: in expansion of macro 'DECLARE_EVENT_CLASS'
   40 |         DECLARE_EVENT_CLASS(name,                              \
      |         ^~~~~~~~~~~~~~~~~~~
./include/trace/trace_events.h:44:30: note: in expansion of macro 'PARAMS'
   44 |                              PARAMS(assign),                   \
      |                              ^~~~~~
./include/trace/events/vmscan.h:342:1: note: in expansion of macro 'TRACE_EVENT'
  342 | TRACE_EVENT(mm_vmscan_write_folio,
      | ^~~~~~~~~~~
./include/trace/events/vmscan.h:353:9: note: in expansion of macro 'TP_fast_assign'
  353 |         TP_fast_assign(
      |         ^~~~~~~~~~~~~~
In file included from ./include/trace/define_trace.h:133:
./include/trace/events/vmscan.h: In function 'do_perf_trace_mm_vmscan_write_folio':
./include/trace/events/vmscan.h:354:32: error: assignment to 'long unsigned int' from 'struct folio *' makes integer from pointer without a cast [-Wint-conversion]
  354 |                 __entry->folio = folio;
      |                                ^
./include/trace/perf.h:51:11: note: in definition of macro '__DECLARE_EVENT_CLASS'
   51 |         { assign; }                                                     \
      |           ^~~~~~
./include/trace/perf.h:67:23: note: in expansion of macro 'PARAMS'
   67 |                       PARAMS(assign), PARAMS(print))                    \
      |                       ^~~~~~
./include/trace/trace_events.h:40:9: note: in expansion of macro 'DECLARE_EVENT_CLASS'
   40 |         DECLARE_EVENT_CLASS(name,                              \
      |         ^~~~~~~~~~~~~~~~~~~
./include/trace/trace_events.h:44:30: note: in expansion of macro 'PARAMS'
   44 |                              PARAMS(assign),                   \
      |                              ^~~~~~
./include/trace/events/vmscan.h:342:1: note: in expansion of macro 'TRACE_EVENT'
  342 | TRACE_EVENT(mm_vmscan_write_folio,
      | ^~~~~~~~~~~
./include/trace/events/vmscan.h:353:9: note: in expansion of macro 'TP_fast_assign'
  353 |         TP_fast_assign(
      |         ^~~~~~~~~~~~~~
cc1: all warnings being treated as errors
make[3]: *** [scripts/Makefile.build:289: mm/vmscan.o] Error 1
make[2]: *** [scripts/Makefile.build:548: mm] Error 2
make[1]: *** [/usr/src/25/Makefile:2141: .] Error 2
make: *** [Makefile:248: __sub-make] Error 2


