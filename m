Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EC2F609C05D
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 20:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KazNcZp6
Received: by kanga.kvack.org (Postfix)
	id 542816B05B3; Wed,  4 Nov 2026 15:56:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5190D6B05B4; Wed,  4 Nov 2026 15:56:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 455F66B05B5; Wed,  4 Nov 2026 15:56:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2504C6B05B3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 15:56:33 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B4A02120817
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 20:56:32 +0000 (UTC)
X-FDA: 85398645024.28.41FDDDA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id C89EB12000C
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 20:56:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KazNcZp6;
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793825790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=osWOTOTQBxibmdk7vYQvxdot4PKbfhI2tgBU79UNrUk=;
	b=cCqaOW8ZWzy8y0gCcX/VRT3XpIf49a4C+Tn7MCiM5QCKaPALGGns5WEKTD7jEPaZwXJ0gq
	7ivdg60Yd1JZIxWEROD9ZjiH/Qns2Yc1JjxNxkYE/ldr3c76Tlce66r8/BMU2fooE2nKCf
	G4RF9rjBIlH3v/ohZLuTtIUgTrT8Vqk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KazNcZp6;
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793825790;
	b=Vnc6XICLhLNRwN6FLhfbNEkjIWJaiIKcRGvPOKBGcNM0TQcQe2FmF/xDDoXk8IyUFmeAjQ
	YWpJVxNyTVKkMxdZiBhPrUC27y1h0+4UqFklW/rJDFdfJlQ41moJ4HX1Ghf2RZJp85kjCa
	Uk7nGJeunL6LdOioWSMWjN63V9dL/xI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E7B462CC9
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 20:56:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450871F00A1D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 20:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793825789;
	bh=osWOTOTQBxibmdk7vYQvxdot4PKbfhI2tgBU79UNrUk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=KazNcZp6qfpRdpx0Oe5j+F8/M9LJGR2nQOeCHm5RYvPEKVOnFU9V9UfLJR1KMsW9B
	 bJvBnjkwNdj2C8cn/tLvyj7KgG3kxBlB5vj+bmXwEQ7TrHN8Myj4tDSEODHN6kEV6z
	 RZP1RffojHsRoeuIK4m6s85Vaw8N4qWOXCeeSBydy+CXMxnmJxxtnhokkSPrVawA0u
	 zULvzQrlmtRimkxL4Cxcdep7XIoTUK4+YtoP/PoJX1/E/eEsnrR1VAuUL19Bz8bped
	 Q4MiiD80HzVkRzPSl44k0WY/HWUP0E5kYcf3ARkXoastBoOSwUY0xhempTBPZstDJi
	 NNw3Jlt/v4jyw==
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-5eae12762c9so421926e0c.1
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 12:56:29 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBzzeUE/YIg3Iz7QHqxbucVh+T32c0J+z2WYIU+mfnZPync/JnnDn7flVC6e5ftx1E7r4z4l2ARWxQ==@kvack.org
X-Gm-Message-State: APuU4Z8f2lswL1Hnd5BYegHDnXbXgD1fRLLDYhVa6Od25yOSskqmaSKk
	VLemmqE0M+L+RCnZZWs08x6Ugv5TEVOXRT66Ug33A8NatundBZe0gaRHpCIF5/CViBSCR/9NsBK
	JPkA7IwXu/Ez6jYHUzdc2wxwUTjQdHpE=
X-Received: by 2002:a05:6122:32d5:b0:5e9:6d96:a910 with SMTP id
 71dfb90a1353d-5ec6850f9a8mr7100215e0c.3.1793825788528; Wed, 04 Nov 2026
 12:56:28 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261104130817.849089-1-ridong.chen@linux.dev> <20261104130817.849089-8-ridong.chen@linux.dev>
In-Reply-To: <20261104130817.849089-8-ridong.chen@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Thu, 5 Nov 2026 04:56:17 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4y_Ay0mYO3ic72oepjtW6KYf2sKRXEHb3Ff8uwKrOJZjQ@mail.gmail.com>
X-Gm-Features: AclHuK83pxTrPui2NSL2YizsStHa_eD5Qfiw1-w_RlgnlnIfhF0-PgLrUc5Gd7I
Message-ID: <CAGsJ_4y_Ay0mYO3ic72oepjtW6KYf2sKRXEHb3Ff8uwKrOJZjQ@mail.gmail.com>
Subject: Re: [PATCH v7 7/7] mm/mglru: add tracepoint for aging
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Dave Chinner <david@fromorbit.com>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Muchun Song <muchun.song@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, 
	"open list:BPF [MISC]:Keyword:(?:b|_)bpf(?:b|_)" <bpf@vger.kernel.org>, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ru7kdeyihcty1xkrei1pcpb1gqb3abho
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C89EB12000C
X-HE-Tag: 1793825790-956240
X-HE-Meta: U2FsdGVkX1/+FIM5fE8oj4JbkY6qRrYWTGo3irmRruYBslQPHje1jOHdrV9Q5aq7m3M7gokIigvdebqPmGs46FnqVgEvfDv3XpLSDbPLh8VfrHZ9RfM+K0q5meAz1LvcyZHQqhDUztcwjTV2zWwPPrEJFo6Vl4vf2Pvjnja88Ecz1jvL2RorJ/eXqBjKjzIP27x+/dRNmj0IBNhtXndJL8RdTMu9MSj6mE5w7DCLv9u5xMIVn1lCpf1B4/InFD8JkHvauB6tidzcJekxAauRkAY9je25grBFihKEiArylWRQpTXx5jTcIgM+C3H/q5ZzzlqH/3+N1NKk5nLPxhgBtECgLZNbjuCbnWuwF/mIxMKjE3jp+oxn9r38YdpAIdDgo2Ifkk76k9iA8XnyyU+gfy+dhSUAWGjHAU7Ze4xRvXsiJaxxOBTlKsbIeFEOBnGo5VyqYFDno961PwFZRoIQ3JChG048lZDBHPFVetU3Av5v6k/6VhbV5ezGUVtf6micxyhwyHbi9cQgql8iX66s/bc/gs70tXlEpsjGQXEULwKGw45v2Sjb8H7HL168ECPjFpLwQFeZIieXOUDqHk4US2H36LD5n/Cs4mwaCr9DXYJS++s8srpkcDesMQvAAxypDRJWo0hQIrDXHqcWekiHkST1NWobmTcsxU0VvinZAu5OoRqMfiXrBDDlnYzhHfswaKEhkD5sjrDNt51PmH/GjZzFHl8+xfzWtLxFMDuX7dyoUCaWwkd0EU6JHH/Hq9a9+YZ7kt+IQqzGJ85T7keRntglyOcu0x47viG0PcNSrp75sINsRp3Bygwi5LjyZp6W8Frq39bCXG3kd/Q6JlWNwygjpG+ONVaF0WL9eEIr1CSXcbpe0CiibVkk1wG2cL6fjdhBIUjL1/PGl0gUCHFHs3XcwMdICo05ma/9G3E+qzrVO/tWfxeHzUzDmBMAB1NUfsnIedtz3bqqEv8N7Or
 TR6CV+5h
 hVc1SJVsxxK+6kJn2+DBjteWlQ1uCE/WB7Asni4G6Jn84TYPr5paza15g1FgDCgheBJE5CcauszjIhRM9JdSNM5hzkbpDbsm/O3EhwDmcNNPOCvmO8KiuCMKXAAW4RDs5JGtqWLvyk1z/66fNC2kzqRODHn0tNBZoghiCPZIPeucLieMK1q+8eAtCGA9dvwRt7e35RycuY3woTaD12u2B0wiBhGsBlvuCG/r7tvaTeFpZKUjHKMQztTyd4P+gLyD5hTSvSfsylD6N/YLqv/1tzD0LIiFMGA4nEfxT/JNt+SY8rAwJR98YGesOhM1Qbm4L2rrVdNNuVqDn2m0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 4, 2026 at 9:10=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev> =
wrote:
>
> From: Ridong Chen <chenridong@xiaomi.com>
>
> Aging in MGLRU advances max_seq to create a new youngest generation.
> It is triggered from try_to_shrink_lruvec() when should_run_aging()
> finds that eviction is no longer possible, or that it would be better
> to age first at the current priority. There is currently no tracepoint
> on this path, so it cannot be observed when and why aging is needed.
>
> Add mm_mglru_aging, emitted in try_to_shrink_lruvec() right before
> try_to_inc_max_seq(), with the node id, memcg id, sc->priority,
> swappiness, max_seq, the anon and file min_seq, and the number of pages
> in each generation for both types, as computed by lruvec_gen_size().
>
> The reason for aging is not reported explicitly, as the logic in
> should_run_aging() may change, e.g. for imbalance-based aging. It can
> be derived from the generation window and the per-generation sizes,
> which are taken before aging, so the youngest generation is populated
> as well.
>
> The nr_anon/nr_file arrays are ordered by seq rather than by generation
> slot: entry i holds the generation max_seq - MAX_NR_GENS + 1 + i, i.e.
> they go from the oldest generation to the newest, the same order as the
> debugfs lru_gen file, so the output can be read directly without mapping
> slots back to seqs. The arrays are printed with __print_array(), so the
> output is hex and its length follows MAX_NR_GENS automatically.
>
> Only the lruvec, sc and swappiness are passed in; everything else,
> including max_seq, is read in TP_fast_assign(), so try_to_shrink_lruvec()
> does no extra work when the event is disabled. Reading max_seq there
> rather than using the caller's copy keeps the window consistent with
> the per-generation sizes read right after it, should another reclaimer
> age the lruvec in between.
>
> The event marks the aging decision, not its result: the following
> try_to_inc_max_seq() may find that aging is already in progress or
> done by another reclaimer, so concurrent reclaimers can each emit it
> for the same max_seq. Whether max_seq was advanced can be seen from the
> following mm_mglru_scan_folios.
>
> Suggested-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---

Much better now:

~ # echo 1 > /sys/kernel/tracing/events/vmscan/mm_mglru_aging/enable
~ # ./a.out
Mapped 400 MB at 0xffff98a00000
^C
~ # cat /sys/kernel/tracing/trace | grep mglru_aging
         kswapd0-49      [001] .....   104.277689: mm_mglru_aging:
nid=3D0 memcg_id=3D1 priority=3D6 swappiness=3D60 max_seq=3D3 anon_min_seq=
=3D2
file_min_seq=3D1 nr_anon=3D{0x0,0x0,0xd360,0x0}
nr_file=3D{0x0,0x23e2,0x0,0x0}
         kswapd0-49      [001] .....   104.536448: mm_mglru_aging:
nid=3D0 memcg_id=3D1 priority=3D3 swappiness=3D60 max_seq=3D4 anon_min_seq=
=3D2
file_min_seq=3D2 nr_anon=3D{0x0,0x20,0xf8bc,0x0}
nr_file=3D{0x0,0x91a,0xbd,0x0}
           a.out-79      [000] .....   104.689518: mm_mglru_aging:
nid=3D0 memcg_id=3D1 priority=3D4 swappiness=3D60 max_seq=3D5 anon_min_seq=
=3D3
file_min_seq=3D4 nr_anon=3D{0x0,0xf8a0,0x1188,0x0}
nr_file=3D{0x0,0x0,0x2,0x7}
         kswapd0-49      [001] .....   107.282038: mm_mglru_aging:
nid=3D0 memcg_id=3D1 priority=3D2 swappiness=3D60 max_seq=3D6 anon_min_seq=
=3D4
file_min_seq=3D5 nr_anon=3D{0x0,0x6c50,0xa168,0x605}
nr_file=3D{0x0,0x0,0x98,0x18}
         kswapd0-49      [001] .....   107.812598: mm_mglru_aging:
nid=3D0 memcg_id=3D1 priority=3D1 swappiness=3D60 max_seq=3D7 anon_min_seq=
=3D5
file_min_seq=3D6 nr_anon=3D{0x0,0xfe10,0x1721,0x54}
nr_file=3D{0x0,0x0,0x1a,0x3}
           a.out-79      [000] .....   108.936872: mm_mglru_aging:
nid=3D0 memcg_id=3D1 priority=3D2 swappiness=3D60 max_seq=3D8 anon_min_seq=
=3D6
file_min_seq=3D7 nr_anon=3D{0x8,0x7d29,0x8c54,0xc90}
nr_file=3D{0x0,0x0,0x4,0x2}
         kswapd0-49      [001] .....   108.937115: mm_mglru_aging:
nid=3D0 memcg_id=3D1 priority=3D2 swappiness=3D60 max_seq=3D8 anon_min_seq=
=3D6
file_min_seq=3D7 nr_anon=3D{0x0,0x7d15,0x8c94,0xcac}
nr_file=3D{0x0,0x0,0x4,0x2}
         kswapd0-49      [001] .....   109.425258: mm_mglru_aging:
nid=3D0 memcg_id=3D1 priority=3D1 swappiness=3D60 max_seq=3D9 anon_min_seq=
=3D7
file_min_seq=3D8 nr_anon=3D{0x0,0xed69,0x24bc,0x488}
nr_file=3D{0x0,0x0,0x3,0x3}

One thing that looks a bit weird, though. For example:

max_seq=3D3 anon_min_seq=3D2

We have only two generations for anon, but we print four:

nr_anon=3D{0x0,0x0,0xd360,0x0}

The two oldest generations don't actually exist. Ideally,
we would print only the two existing generations:

nr_anon=3D{0xd360,0x0}

you should be able to fix it by:

__print_array(__entry->nr_anon, __entry->max_seq -
__entry->anon_min_seq + 1 , sizeof(unsigned long)),
__print_array(__entry->nr_file, __entry->max_seq -
__entry->file_min_seq + 1, sizeof(unsigned long)))

But I guess it's fine, since the two extra entries are both
zero.

And, I personally prefer the youngest-to-oldest order,
as we usually have:

head ---------- tail

where head is young and tail is old.

Your output uses:

tail ---------- head

But anyway, I guess this is just a matter of whether we
read it from left to right or right to left. Personally, I
find it more natural to read from youngest to oldest.

If you're not tired of working on this and would like to make
a few more improvements, you could address the two issues
above. But it is up to you.

For the patch,

Reviewed-by: Barry Song <baohua@kernel.org>

