Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD1CE606A327
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 03:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pg7DV0Uf
Received: by kanga.kvack.org (Postfix)
	id D95436B05B4; Mon,  2 Nov 2026 22:24:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D46CC6B05B5; Mon,  2 Nov 2026 22:24:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5C776B05B6; Mon,  2 Nov 2026 22:24:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9AAA36B05B4
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:24:18 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 20C2240317
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:24:18 +0000 (UTC)
X-FDA: 85392364596.09.0D4466B
Received: from mta1.migadu.com (out-224.mta1.migadu.com [95.215.58.224])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0EA0F40005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:24:15 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pg7DV0Uf;
	spf=pass (imf11.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.224 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793676256;
	b=fciLecgz1hNu12DS00xo2orM2GoDSo7krpYX+/3Hkhtl523q66f/VzEK/OSgxOtUdty4Zp
	jO8gRlKocrTQH8RU4zHWz9wZwqIKNiT9Cc2Oe1gALjAzMa9S6JoJSwHYpTIRJlA0rmG+i/
	NyllwWSSJ3QIR16NxuSOTpp5+ff5MPk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793676256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wp5wIsqhtLnbvTQSbQDkpP6Lf3VZf9FET+wJGcOPy6c=;
	b=gkTgAVue0lOtQcsgbZ6PpOBGCHj1LEbEBSE0eeGsMzo8BFsQVa/EECquvcJXuxtoeJsl9v
	sqo+UQwRBo96xUBqfwbBEFOHcckSOA3/OAIxUD6Hzj5saCNvphR95FZIo4z6horNekxEHI
	+nLXN8nfxMpnh4W0fl1yekPmIp8ugdU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pg7DV0Uf;
	spf=pass (imf11.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.224 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=WfKCC0CPaetlNjBgBzLRFTMpxvJUSOO4JuL3J0g1AR0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793676251; v=1; x=1794281051;
 b=pg7DV0UfbU/4/aLLusRljQNxRNlkAqmaOmpsqc4y1d2UF3zLuDciHx5aDHN4Lc+F5klOhuVX
 XAwf/+2h8Iq9tlKh8V7EbQJzEAmHDi6WoaL42DY7jCdS+Y4YPSCKX3VSqV83ILCdoMJp1WzPs8R
 a+RI7qify95RqBGNqTwmYnhA=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 9e2c220236658063;
	Tue, 03 Nov 2026 03:24:11 +0000
X-Mizu-Trace-ID: 9e2c220236658063
X-Migadu-Flow: FLOW_OUT
Date: Tue, 3 Nov 2026 11:24:02 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Dave Chinner <david@fromorbit.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	"open list:BPF [MISC]:Keyword:(?:b|_)bpf(?:b|_)" <bpf@vger.kernel.org>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH v5 2/6] mm/vmscan: move vmscan tracepoints to a local
 header
Message-ID: <aulT0u_DOUufMrZZ@fedora>
References: <20261031090041.58574-1-ridong.chen@linux.dev>
 <20261031090041.58574-3-ridong.chen@linux.dev>
 <aufpQS0XL-CD9YW_@bogon>
 <2f272a9b-ea83-4157-8968-0081990cb709@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f272a9b-ea83-4157-8968-0081990cb709@linux.dev>
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Stat-Signature: tmsp8cfnagp7p3mjkchiarow1rpocff4
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 0EA0F40005
X-HE-Tag: 1793676255-249252
X-HE-Meta: U2FsdGVkX18JO2vbzfOQPiwNBS8EqhI626pmrE5zr1ec0/mw80U4ub/VXmGVLjcb88wyMLyhokZGwIRmuCPziDRTevY+h8SQVdaJ49X4hIBeTb5moYRmX8vFZJ8lvx1WQxQNB6/berF38yKxgX8DG2YKvnQllv4sAW5Hyyyojygvm3jvq952ckSSE07Q7q9WfuBHUZWRYdMqVpKaf+5idqUW/ukzX/yXn5dinqH9684OZiN5K8sXcEt/Zp2Y/P49XieQA1cn2B6M9n71G9qDEcfTO3NSQdX8anZgkj74NtNe4Kh6hWZrCOjFZiyKMm405U8QekNxZZQub2oOINaEsPzh6yupfYYoP26ftjmNyrfZV5OA4QGSOz0gDzh1w+BItqu2Nq38EX7smfPaV1b3kfD/o9ZldivUWhZooYpfd9fknFsbfhndM8EREgGusn2dZd8eHieCykfmMyTqnDR6BVP3MgYm9dnho50SkEtxXG8zbwGh4CJYsqOVcoupKHT55HTbl1PaPFLorXyHSPPmZo3VX/Zx9WQgiWPuUkrSmXbJZy8mOQHckTL3xPf5PWsdysdWMI/IYwsttdNzV90k7onfKkArZLdzqAGKSHhypAxVSaPi82p/IxNe81lD7/I28c05Sc84EkTEVkwjrfsFRCICZgdSaMteHMS5+oiin8sVYnYNahxE12kMlEJbvWwTV4Or63vrEGkOfQaYiLbB4mjQ2d3pocJbbg0CPCLALs2LfSEgkC1GDG2mr0Iq6wTyKz31Q1Ql4736lNay7leXsy0uRyz7htwFWc99sjLniy92oQ9t4/BU5/mA00Ht3+fRAe2y3AdKqxkoRhykbANUs7sjh4X2fBeJTOgGkSbLltoLsxo7Dw+cv3uPw4We5jn804/uDLbcs87OaD1gcvvq+12f1Txi5As0zn+9JAnfCXf+/PIPgCesim2B2YrADbyRBTRnyozlRn/0hU8Q5R7
 bc1wNnlw
 q6T4R7NYsSOEgiBKoj7dhPK1EEPaYAAzBfYywV+OpuheybwCm/pY5qp0MKBgLPbKHg1YuxQt0mOsIT5SA4Gl014UMsaNWZNV3mZQlp7Lgi4kPdLzO6sFlPHN1KyWEkpDaUfwnYvCQVqMeWQjNaThhiWMDXHkmBVjkZZF7IkWQpSezZ3YsDkdwNIM1oQISlHtgJC2kehk8DgWJwTrHibKbtkakzfbSowZIiXWGb3f50lHap5WXYV0Iu9AXdy3h+i8ux8y94JELz4/MtnK2cKf0f93GR81dYz25ouvTXlML0WeHRYz6Mn65fHO9Qn8NlB/mQ1OgdC6ZuwURYICpRPSevByXUOyB1e3dXvam2nyYkTQ6Wdkc0fgC6Ry9IYtjoRrJgg1DBWadZ6I1wDnzFVK2IsLwg3cozwAgkjRoqRsHXfnHwsblzhPqNTIQboVnGfy5ISSxAsib7oX/W8/mb5ex7Q6o/fZH9Tu5sCPK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/02/26 at 06:46pm, Ridong Chen wrote:
> 
> 
> On 11/2/2026 9:37 AM, Baoquan He wrote:
> > On 10/31/26 at 05:00pm, Ridong Chen wrote:
> > > From: Ridong Chen <chenridong@xiaomi.com>
> > > 
> > > Move include/trace/events/vmscan.h to mm/trace_vmscan.h so that the
> > > tracepoints can be extended to reference vmscan-internal structures such
> > > as struct scan_control, which is not visible outside mm/.  This mirrors
> > > what several other subsystems already do with their trace headers (e.g.
> > > fs/fuse/fuse_trace.h, fs/gfs2/trace_gfs2.h, fs/lockd/trace.h).  As they
> > > do, set TRACE_INCLUDE_PATH to "." and add mm/ to the include path of
> > > vmscan.o, the only user that defines CREATE_TRACE_POINTS.
> > > 
> > > No functional change.
> > > 
> > > Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> > > Reviewed-by: Barry Song <baohua@kernel.org>
> > > ---
> > >   MAINTAINERS                                        | 2 ++
> > >   mm/Makefile                                        | 1 +
> > >   mm/shrinker.c                                      | 2 +-
> > >   include/trace/events/vmscan.h => mm/trace_vmscan.h | 4 ++++
> > >   mm/vmscan.c                                        | 2 +-
> > >   5 files changed, 9 insertions(+), 2 deletions(-)
> > >   rename include/trace/events/vmscan.h => mm/trace_vmscan.h (99%)
> > > 
> > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > index aaf2825ac945..2ad01107fa05 100644
> > > --- a/MAINTAINERS
> > > +++ b/MAINTAINERS
> > > @@ -17653,6 +17653,7 @@ F:	Documentation/admin-guide/mm/multigen_lru.rst
> > >   F:	Documentation/mm/multigen_lru.rst
> > >   F:	include/linux/mm_inline.h
> > >   F:	include/linux/mmzone.h
> > > +F:	mm/trace_vmscan.h
> > >   F:	mm/vmscan.c
> > >   F:	mm/workingset.c
> > > @@ -17802,6 +17803,7 @@ R:	Shakeel Butt <shakeel.butt@linux.dev>
> > >   R:	Lorenzo Stoakes <ljs@kernel.org>
> > >   L:	linux-mm@kvack.org
> > >   S:	Maintained
> > > +F:	mm/trace_vmscan.h
> > >   F:	mm/vmscan.c
> > >   F:	mm/workingset.c
> > > diff --git a/mm/Makefile b/mm/Makefile
> > > index 2a3ec53d62ee..277b97f7f8d7 100644
> > > --- a/mm/Makefile
> > > +++ b/mm/Makefile
> > > @@ -32,6 +32,7 @@ KCOV_INSTRUMENT_vmstat.o := n
> > >   KCOV_INSTRUMENT_failslab.o := n
> > >   CFLAGS_init-mm.o += -Wno-override-init
> > > +CFLAGS_vmscan.o += -I$(src)
> > 
> > One nit:
> > 
> > Does it really need the above line? It affects mm/shrinker.c too, did your
> > shrinker.o building fail?
> > 
> > Seems it's redundant because kbuild adds -I$(src) -I$(obj) for every object
> > in the directory since commit cdd750bfb1f7 ("kbuild: remove 'addtree' and
> > 'flags' magic for header search paths"). Please correct me if I am
> > wrong.
> > 
> 
> Hi Baoquan,
> 
> Thanks for the review.
> 
> The line is needed for vmscan.o, and mm/shrinker.c is fine without it,
> because the two files include trace_vmscan.h in different ways.
> 
> mm/shrinker.c only does a plain #include "trace_vmscan.h". The lookup
> starts from mm/, where the header lives, so no -I is needed.
> 
> mm/vmscan.c defines CREATE_TRACE_POINTS before including the header.
> In that case <trace/define_trace.h>, included at the end of
> trace_vmscan.h, includes the header again to generate the tracepoint
> definitions:
> 
> #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)  /* -> "./trace_vmscan.h" */
> 
> This #include is in include/trace/define_trace.h, so the lookup starts
> from include/trace/ and only finds the header through -I. Without the
> flag, vmscan.o fails to build:
> 
> ./include/trace/define_trace.h:118:42: fatal error: ./trace_vmscan.h: No
> such file or directory
> 
> As for cdd750bfb1f7, it doesn't add -I$(src) for every build. kbuild
> only adds -I$(src) -I$(obj) automatically when building with O=
> (see "ifdef building_out_of_srctree" in scripts/Makefile.lib). So
> with O= the line is indeed redundant and vmscan.o builds fine without
> it, but a plain in-tree "make" fails with the error above. The
> explicit flag keeps both working.
> 
> To be honest, I had the same worry at first: I thought every .c file
> that includes the header would need a Makefile change. That's why v3
> used a relative TRACE_INCLUDE_PATH (../../mm) instead. Steven corrected
> me and pointed out that the proper way is TRACE_INCLUDE_PATH "." plus
> -I$(src) for the one object that defines CREATE_TRACE_POINTS [1]. That
> turned out to need only this one line. Thanks again to Steven for
> that.

You are right, my nit was wrong. Learned it from you, thanks for the
detailed explanation.

> 
> [1] https://lore.kernel.org/all/20261014124914.21c21559@gandalf.local.home/
> 
> 
> > Other than the nit, this patch looks good to me,
> > 
> > Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> > 
> > Thanks.
> > >   mmu-y			:= nommu.o
> > >   mmu-$(CONFIG_MMU)	:= highmem.o memory.o mincore.o \
> > > diff --git a/mm/shrinker.c b/mm/shrinker.c
> > > index 4fb424e721bc..4fbdade6d2f6 100644
> > > --- a/mm/shrinker.c
> > > +++ b/mm/shrinker.c
> > > @@ -3,7 +3,7 @@
> > >   #include <linux/rwsem.h>
> > >   #include <linux/shrinker.h>
> > >   #include <linux/rculist.h>
> > > -#include <trace/events/vmscan.h>
> > > +#include "trace_vmscan.h"
> > >   #include "internal.h"
> > > diff --git a/include/trace/events/vmscan.h b/mm/trace_vmscan.h
> > > similarity index 99%
> > > rename from include/trace/events/vmscan.h
> > > rename to mm/trace_vmscan.h
> > > index 8a872990b4be..ad90f0e9bf2e 100644
> > > --- a/include/trace/events/vmscan.h
> > > +++ b/mm/trace_vmscan.h
> > > @@ -648,4 +648,8 @@ TRACE_EVENT(mm_vmscan_kswapd_clear_hopeless,
> > >   #endif /* _TRACE_VMSCAN_H */
> > >   /* This part must be outside protection */
> > > +#undef TRACE_INCLUDE_FILE
> > > +#undef TRACE_INCLUDE_PATH
> > > +#define TRACE_INCLUDE_PATH .
> > > +#define TRACE_INCLUDE_FILE trace_vmscan
> > >   #include <trace/define_trace.h>
> > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > index 9959ca158ce8..79d2d614afd0 100644
> > > --- a/mm/vmscan.c
> > > +++ b/mm/vmscan.c
> > > @@ -71,7 +71,7 @@
> > >   #include "swap.h"
> > >   #define CREATE_TRACE_POINTS
> > > -#include <trace/events/vmscan.h>
> > > +#include "trace_vmscan.h"
> > >   struct scan_control {
> > >   	/* How many pages shrink_list() should reclaim */
> > > -- 
> > > 2.43.0
> > > 
> 
> -- 
> Best regards
> Ridong
> 

