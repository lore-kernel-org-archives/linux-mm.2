Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B32C60A383E
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 02:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Zw2xFXWL
Received: by kanga.kvack.org (Postfix)
	id 325D76B05B4; Sun,  1 Nov 2026 21:13:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D5246B05B5; Sun,  1 Nov 2026 21:13:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19E026B05B6; Sun,  1 Nov 2026 21:13:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DCBF46B05B4
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 21:13:24 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4C3D1140555
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 02:13:24 +0000 (UTC)
X-FDA: 85388557128.06.0241B48
Received: from mta0.migadu.com (out-252.mta0.migadu.com [91.218.175.252])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3D27520003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 02:13:22 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Zw2xFXWL;
	spf=pass (imf13.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.252 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793585602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yvz+MvufKgYbwZrvLEKvrENqTO+kH2u2+d8MLeEiziI=;
	b=vfpcucye4NlJJYze/CNT5qi3yTx0Y1ZR7UWIi6zFCcNjGHaVGq7fdxlGl9ejaskJKh7o9Q
	QTY0AG92sSsh6/Dw3vs+DpVGwAdT3GnWPIGcNs8Y5ww0IRzj2dZKxxkDPasWj4mGppwJbh
	R5yzfi0x/vQD3ZQOGx4NEqYv/7oH0dA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Zw2xFXWL;
	spf=pass (imf13.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.252 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793585602;
	b=BNJYkUVRn7Y2q5Tegx/58r5SyrqoNv0gQikKeF23ZLfZEaMie3YR1UOnSEqz3Vx95jIjK9
	X71YZQ4ujVCy8beBB/tQmALA00Yh9C8rZdP0kTfWi6QS6+DeC0mobPGDt1u23ETuB0QKwX
	g1rzblkJKnc0lksiGPupHk5SYGh1XzE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Kh1L9N4J0VwonxvRmIWkE389mycuzqTwy4u3dSvyNpo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793585599; v=1; x=1794190399;
 b=Zw2xFXWLjx47d25BX2FbVziM4ibfWj7pIjYmQrxrfL95ItYGXRscMVkixzrOfWc29apRYbAG
 Qe0VMc3L1HjzEAeb3kSSDGBUhFoJ1qGBO+Fseb/FwKQNUvXmOOfzkFZxGMd2Oa3MsbpQ+b4QsWH
 vlE+TZJj2eiLAlHcHWshlOBo=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id d3db1ab78c0e22d4;
	Mon, 02 Nov 2026 02:13:19 +0000
X-Mizu-Trace-ID: d3db1ab78c0e22d4
X-Migadu-Flow: FLOW_OUT
Date: Mon, 2 Nov 2026 10:13:12 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Barry Song <baohua@kernel.org>
Cc: Ridong Chen <ridong.chen@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Dave Chinner <david@fromorbit.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	"open list:BPF [MISC]:Keyword:(?:b|_)bpf(?:b|_)" <bpf@vger.kernel.org>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH v5 6/6] mm/mglru: add tracepoint for inc_max_seq()
Message-ID: <aufxuOaKZWMYqEQi@bogon>
References: <20261031090041.58574-1-ridong.chen@linux.dev>
 <20261031090041.58574-7-ridong.chen@linux.dev>
 <CAGsJ_4zUbkFXBhAesVV74-Ndga5f6xEbestK7Qinqddip8xBrw@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4zUbkFXBhAesVV74-Ndga5f6xEbestK7Qinqddip8xBrw@mail.gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3D27520003
X-Stat-Signature: fa39bohy7j6scurhumx3u4asf8ziby8h
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793585602-522145
X-HE-Meta: U2FsdGVkX1/vDAcbcJ3HhUxXechM3C5I2Bbn7qYizlkoDUpA0vnz7Ip7N69Y/B18gIkngInO0D6tta9zsQjOE3NWYGA0fMUZHBjwNDVGLPkRrZlOkgNaBKzfwFdcFUMLdw93XNtErz6YhvgKTdgqdarz9NbuUF8AxHohSnuIr/ljg5aSIFvnH91SiuEmW1qwjbeCo4gSgy8YIZLlrs2bgGWWE+9feqh+5u3IF0HaNZMyF6xIGDO2xvutqsQLeCzVugE5peDCVjOz6q0Sld/KbN3exOXJabkiVfo8hSjfRx9VPvAL2gHsdjxNEZi90rSMr3Kmd+ZR/NR8aXt+tCNL5A6n39KY/FA4AKdNpHtmTdXv4PZtuJeaoUtInawxVNXFz1cDbM85y1x3LWW2ojtlX9RA/O8yr/7x/7LjGkSEBNUVeh2to6EXjjc8i1dt2WXYxHLfpgdQP+cq8cVdhOMC24s3qtHLOj9EaadVQum0B/1AzZ1oCkNG/0XRF72aSmyz6WbIpeVnju6/eSSSTH/oRbJCCVrM5kVEa8qYYLLBTOWb0ere7bhTYsbgjk+jgT4cWW6CXQ4h3JXKaVGBPP2YJ7aCR79F/a90h6ZK0GGbK/JxYRzv8GHap3bMf1VLruM8BMmV2BcupkGHUiWQATCoG4ZJftwTR+9W98F5V6fBIDITC8R2bMOZjU6DUyQ9bKT6zal1I6tlc2K+OTrWuBickckG/rNcFI+GeVn0JkDFkaBjAp+XtlkJOa4APMn3hImGcCI+2R0+gQckBJ2bPj6g4rnDSUTUZmNm8VrqnaQ/0D1imJxcIUFaNXSIq4n/sYVDbsDvEsWTnuw/qbmQznLOb0kxtUr60DYRa9HAvcw7EPTzyGYHkOG/Phy8evngVPMXckIXoAwCTRJIKxgUIpYUI2z71+DnCw4GzEdtfLe5geEgiiPUDAAR0tav2Ei0rzITKdRIeHzjXRJCfk8eCrY
 S7wt8VKd
 faWOfzIXkleImi2v9wk3wxJIoeQhfApB/yTTq/5sT6rAm3WrVr8wW93esF/DKtM68jIy1fUUA8jA7RkOdYScqqTSfQwk1RhMwpSr6lSrPGUrGfSLfmoCJ5qdsqCf5EJ5RCaAl0uik7gwy4ri3fqtfRO03jKC3kfo4D9XVCZl1Bln4VCS4aVQrqwd+NMKa4JTZNzaZzi5O0YuLYyEHtxbyObSWrg77y0/vRvFRKwZiZSH6K2zQtkYcnP2I1f9qYCOMt4h1bk52ekvHy51acze7NQN2hImu7dpimqoBLG4Is6lnZFg0IXLTW3fcOZJTx+NfsTYyOc6xoUiq5MIA7cDz+a4LFTbB/mGDDT/oFjEE2MoRRGdan6eJL7MmucF5T7Ok3Zu+ya/TKYOYzfE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/01/26 at 05:21am, Barry Song wrote:
> On Sat, Oct 31, 2026 at 5:02 PM Ridong Chen <ridong.chen@linux.dev> wrote:
> >
> > From: Ridong Chen <chenridong@xiaomi.com>
> >
> > Aging in MGLRU advances max_seq via inc_max_seq(), creating a new
> > youngest generation. There is currently no tracepoint on this path, so
> > the moment a new generation is created, and how the min_seq of each type
> > trails behind it, cannot be observed as it happens.
> >
> > Add mm_mglru_inc_max_seq, emitted right after max_seq is bumped while
> > the lruvec lock is still held, with the node id, memcg id, the new
> > max_seq, the anon and file min_seq, and the number of pages in each
> > generation for both types, summed over zones and clamped to >= 0 the
> > same way the debugfs lru_gen file reports them. The nr_anon/nr_file
> > arrays are indexed by generation slot, so the emitted max_seq/min_seq
> > say which slot holds which seq. They are printed with __print_array(),
> > so the output is hex and its length follows MAX_NR_GENS automatically.
> >
> > Only the lruvec is passed in; all of the above is collected in
> > TP_fast_assign(), so inc_max_seq() does no extra work when the event is
> > disabled. Paired with mm_mglru_scan_folios it makes the full
> > aging-to-eviction window observable per memcg.
> >
> > Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> > ---
> >  mm/trace_vmscan.h | 47 +++++++++++++++++++++++++++++++++++++++++++++++
> >  mm/vmscan.c       |  2 ++
> >  2 files changed, 49 insertions(+)
> >
> > diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
> > index 8148b8224422..cddf42b5849a 100644
> > --- a/mm/trace_vmscan.h
> > +++ b/mm/trace_vmscan.h
> > @@ -456,6 +456,53 @@ TRACE_EVENT(mm_mglru_scan_folios,
> >                 __entry->min_seq)
> >  );
> >
> > +TRACE_EVENT(mm_mglru_inc_max_seq,
> > +
> > +       TP_PROTO(struct lruvec *lruvec),
> > +
> > +       TP_ARGS(lruvec),
> > +
> > +       TP_STRUCT__entry(
> > +               __field(u64, memcg_id)
> > +               __field(unsigned long, max_seq)
> > +               __field(unsigned long, anon_min_seq)
> > +               __field(unsigned long, file_min_seq)
> > +               __array(unsigned long, nr_anon, MAX_NR_GENS)
> > +               __array(unsigned long, nr_file, MAX_NR_GENS)
> > +               __field(int, nid)
> > +       ),
> > +
> > +       TP_fast_assign(
> > +               struct lru_gen_folio *lrugen = &lruvec->lrugen;
> > +               int gen, zone;
> > +
> > +               __entry->memcg_id = mem_cgroup_id(lruvec_memcg(lruvec));
> > +               __entry->max_seq = lrugen->max_seq;
> > +               __entry->anon_min_seq = lrugen->min_seq[LRU_GEN_ANON];
> > +               __entry->file_min_seq = lrugen->min_seq[LRU_GEN_FILE];
> > +               /* summed over zones and clamped to >= 0, as debugfs lru_gen does */
> > +               for (gen = 0; gen < MAX_NR_GENS; gen++) {
> > +                       __entry->nr_anon[gen] = 0;
> > +                       __entry->nr_file[gen] = 0;
> > +                       for (zone = 0; zone < MAX_NR_ZONES; zone++) {
> > +                               __entry->nr_anon[gen] +=
> > +                                       max(lrugen->nr_pages[gen][LRU_GEN_ANON][zone], 0L);
> > +                               __entry->nr_file[gen] +=
> > +                                       max(lrugen->nr_pages[gen][LRU_GEN_FILE][zone], 0L);
> > +                       }
> > +               }
> 
> I feel this is wrong. Can we calculate the newest and
> oldest generations from seq, then print them in order
> from newest to oldest?

Agree, from newest to oldest or oldest to newest makes it clearer.

Printing from lrugen->max_seq - MAX_NR_GENS + 1, or from MAX_NR_GENS,
both looks good.

> 
> The nr_pages[] array isn't ordered from newest to
> oldest or vice versa, as we have:
> 
> static inline int lru_gen_from_seq(unsigned long seq)
> {
>         return seq % MAX_NR_GENS;
> }
> 
> And I added a helper here:
> https://lore.kernel.org/linux-mm/20261022220203.91911-11-baohua@kernel.org/
> 
> +static inline unsigned long lruvec_gen_size(struct lru_gen_folio *lrugen,
> + int type, unsigned long seq)
> +{
> +     int gen = lru_gen_from_seq(seq);
> +     unsigned long size = 0;
> +
> +     for (int zone = 0; zone < MAX_NR_ZONES; zone++)
> +          size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
> +     return size;
> +}
> 
> Maybe you could port it here as a separate patch so it
> can land earlier as part of your tracepoints series. We
> could then use it in the next version of the swappiness
> series.
> 
> Best,
> Barry

