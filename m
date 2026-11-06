Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CEB5606A32D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 18:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=U9yWwdVK
Received: by kanga.kvack.org (Postfix)
	id 6E1C16B05B4; Fri,  6 Nov 2026 13:35:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 691EC6B05B5; Fri,  6 Nov 2026 13:35:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 581356B05B6; Fri,  6 Nov 2026 13:35:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 28F986B05B4
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:35:59 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0F79D1A0154
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 18:35:57 +0000 (UTC)
X-FDA: 85405548354.06.9BCC514
Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1AB39180006
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 18:35:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=U9yWwdVK;
	spf=pass (imf16.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.221.176 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793990155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ukxaCB5W8lia+D2gnLTRqR2pZy9o2jDKqq7CIfdBjAU=;
	b=ypHqERFDqKcnmeNFnG/lpqkkU+sXGP3hwCp+7FKBP/ngiRRU0A3ToHkMBRg2wbzUZv2QR6
	lju7tE8epRiI7yVWYYfWG68No6vgTqfX5rXEp63eVLw6fety48xy8ywtslZjEp56UYgDQa
	LO7Mb6NLetTJMO4rzANDWqcb7pgk868=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793990155;
	b=tB7sdwvKCPuLSbHXFcWNiy1pxtEdT9rL6or9T5VLG2Xay/znLZ2T8AYEnDTFH5TPtxs8pK
	M044ua0XNZAdYbLfRNoXMhv94ZjBzWQVdN14x3ICzcV/xTM4IjNgaqefIofvhi/H/GOTw+
	qmrJZdT5z+ty01yq8a+88id9Ojbiu9U=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=U9yWwdVK;
	spf=pass (imf16.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.221.176 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-5eaf169fe3dso351642e0c.3
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 10:35:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793990154; cv=none;
        d=google.com; s=arc-20260327;
        b=m0MUeCKlwz90qFApUi4tc+yke6SpVc8+rgv8jiH70top2H/WvlRTzSBlRWZWnm3mIo
         UDmrodWpZYajiQMvb3PTKpF9TwJL4z5GPGiH/zEaX+v2a+6K5V7ywARRkfjrwGLna8cC
         WiRP6gVmzJI2mfycpU+Wvxek0Rj5qAJYnCoxynX5KJqCGWKYdoqU7Qd/smkcBBIlGj0c
         8wWuYXVj4gLXPZ6VuSP+WMXCZnfXreRNOYBABWnt1+BS9s2vfdKBGAdAyTVjuGo8EH0w
         A9e3u3peSMBZSVr7JPSw+XxL0d4jKE2hNdjkaQbeN+OZ03jRxwW3PTa7dRyjwaLgUs/V
         GkQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ukxaCB5W8lia+D2gnLTRqR2pZy9o2jDKqq7CIfdBjAU=;
        fh=gxc8X7bBFKrtamTEW55Bnx4DMmo+5ubkH5KG5cUQoFw=;
        b=LbkqjQSfTETAr2iIUeDtFpzVGsx9qHZm3FdpRocNZEy3H3zKEj06yyh0buwZY+WKsB
         iIFXv4KPIKfwyTdqplNsqg5oXQ6Gab3j18zzDHUaRAJ14ohLzBtHcdRC4tjb5w6u2ivm
         j4Dh8hR/YOQI2PybU/+SNORMaqOmPWK/U7mGiT+1hrt239v6Dlt0g/EbpFACadRXEz+f
         WjDCl8CjY5yo5D9gaTuAZGPFuaAFzwJNLChNOuC/GWtFsD6lb133EM+kU//MteOs7fa/
         yuQTpSUd4S8XxrnsJsBDwt2fIOJF8cMEJNX+Akcy7Om4buLAUkm4vlNS88k4gld9Yz8y
         9FQA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793990154; x=1794594954; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ukxaCB5W8lia+D2gnLTRqR2pZy9o2jDKqq7CIfdBjAU=;
        b=U9yWwdVKNjCVmm5uqIlQGbUVkRhoLr1h38OQfbNmZOvJqv2WoWjP8qzOkeviLMYgJv
         Kao4sSdhogc4li+SqnCWp7frh1yqtoesjXqdkwEQKUsD4l3Rh7jS212DJrKnJ53+uA9S
         JHQ5XcSedXjNfewAN2qLaFwi8vDYsTx950J9qrrm+8r7dVmd7RH8JPzVpvhTWWEAEzTd
         EySd/jBBR/mwCdrHdAI2hKjjbTNiggaV0G8bFIZVEyb0K4FWZ59MMHY9q13uLvr35+/2
         vXf+IocAh1KOXU56IVA58EOaKLLx4U/27w1/I9WUJhzK/PJpDxH3AAPQzxoRHjAw9nto
         n33g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793990154; x=1794594954;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ukxaCB5W8lia+D2gnLTRqR2pZy9o2jDKqq7CIfdBjAU=;
        b=CDsQjTFawfmhj19QoG/Qp2UXU1ZL/Tv07kOIVuERKnw84ytW3mN6JWISARv0CXj5qN
         JpvmkOSkidFheSsVCWOgKfs4UTUn7KNa3tGUu+z+auL2xNZOF3YhBssv2iyJl7oS/oIB
         Y9B1wtYh5pmJHB1twBhZb+gHEYjh5t7HXc8GAHaB+Z3pEbhBwTIT4iE2XfYnSIYvbZS2
         MPeqp1s0UJplwcAbq7oz9D1wTJfx/d9e30bXfC8IERfMTvy2Xl7tjanbe9YQvVhwaN3J
         aH5t9sDotK3ldHANDr8hFolWjEBoSNjZj44GmxUNiaCJlukDk6QjF78zCA+acRCIZEwH
         +5aw==
X-Forwarded-Encrypted: i=1; AKwUvBySzSsQnwLl9af/MXQtqjRTP3DysPSsaLyNuQ5WckHtI8kFY8L8W5JY2+zKss6lCEaNdWUsu9jNyg==@kvack.org
X-Gm-Message-State: APuU4Z9TD+DPDq4Qg1k9Cp3DavwmhPCaJ3uNrn6d8LWsHOmI55Ttqc9D
	FsM5SNtfuXN5/dqKRRBw7E7hHu/OLT/5IWlCaC13uXbXlBJNre1e42ZLOx/l5u8VMMz/UO9h8xz
	8Suos6e7xMAnpAQ5pRaEdWRpoWswIegU=
X-Gm-Gg: AYBFou1x6nj0qeSE9JrdklebmHlmgp5/7lHNq54UmSuJVEtSE/vVRFn+jAxscRasz6G
	LaWuONPK7dRw0e1uPzg0tKRJ2yocgjnDL6MKgtf6Ikm1R7WOpU6PjHAj/3PtLtbR/fCpvwVTOEE
	qs7OTI7ukqt/LIQmLScyBNciBUuMA2AhW60P5Q1rg13MBMqVtR3uy0p7QSgOgZ/+yZ4f/mx37iN
	lJo2vYu6YylrshH2kOJE3FG7G0rVvsWjgLSDQe1RESk3sac0MrREAyRbNtOUf8rJbUWRW6iNlZH
	H8nHDMKIKjtiEM2XBrEcxsoqEUOYPanRq7PJkZ3QiT20mCNRMkw4CwZ3w5h8D4nqJ1I3CwHq4pz
	QX5Whva0/P7+1NQAepoPSnEWmOYKxJ5Ak7bHQDk8BeiJiKghN3ZoB9K4W7YCQa8FE/g2dJgtXKJ
	+zqAuctf7j
X-Received: by 2002:a05:6122:e246:b0:5e9:6d96:aa38 with SMTP id
 71dfb90a1353d-5ecc43be497mr1583490e0c.9.1793990153741; Fri, 06 Nov 2026
 10:35:53 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261106172620.318113-1-joshua.hahnjy@gmail.com>
 <20261106172620.318113-2-joshua.hahnjy@gmail.com> <au4SKZKfJoE0ZgAw@gremlin>
In-Reply-To: <au4SKZKfJoE0ZgAw@gremlin>
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Date: Fri, 6 Nov 2026 13:35:41 -0500
X-Gm-Features: AclHuK-kHtai6vcZgPwo4Pl2jbu5SRtdgIxOG8e-H4KkrJECGF8A65jLRBZWFPg
Message-ID: <CAN+CAwO=RnL2BbLodFZ9cyPH5X0sjmZs_05624vG1Jvr0p9dOw@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm/page_alloc: only skip kswapd nodes below their
 kswapd watermark
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Gregory Price <gourry@gourry.net>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 6jxbn91ygr6zwi8m6yxry7phmskjwukb
X-Rspamd-Queue-Id: 1AB39180006
X-Rspam-User: 
X-HE-Tag: 1793990154-157405
X-HE-Meta: U2FsdGVkX18cfkTj6rGHIN9d+SzVjrUUC4hhuYMJMgGmZGDangpL0cd1X5+gsBDhWsCJzMDY9bufqQShDfU2jb221/HVaVMS7Bw71ycVOfCbhyNr+EA2WmvMJ2dFTrir/wF/dpyzffD9/pfiwYPoe4M0jhaUs055sT/pdcqAkNJa8t72KkuumARuY8FB/Ywemn/Y63CB/AYYddgf80WFTXCMPMr/0KPCAF+3B+NUCS6c5u6jAQ4wlv0l85BCde6P92uNfXV6zuTVGA5kHrnh0+/gOLlh+tYxeKqDqDS99S8rB7Z4937FNxwm4vGFB7fakUEIRLvewiPUs7Cf0IiJKQl1/9s1qj85WsW1Lqm3UZA6e57KzQ3/syg1RMPABbGIw8mNsp2npHQBou7x5T02XDOg62qcRZRAIAONteGo/+eiCF2i9SseTFKfjpFMkTiMCDcpxAAonc/DZD83mIZYB7iqXDxGUjnpIs38ENpLXFZNqt4kc4DNXZLpOEyGhS01SAUOEGu9OycgoOBMVau3i5UTwgOHYgHyQOyQR8NVlkaAVIZAdj9TTsWsSsBeLkPXRt9dlyQqBAd2BoemSUJYjr3i5Til/MHy1YTSBQPJDRs2qyXqqOUuHM1mJtarCECB+zSpyLGul0KX3zrxXuB5soCt1jgYdGbMnRbf1gr+47j/wAnTSg0oUnvuH1xtkgOtYRfKxrKYtocue6QmZ8Dydh5vLf9Z0Lgr1U67yEC/noWHnY/5BxhpusP+LXqx2v1otYHei/0Kr/heV5PsbguXgPkpMJlsJnizS+hprN06y5Yth/uwgAjQcWcL1nAZDZD8DVse9rivCpbmV8jFPSL+bxMl+I7bTHeCgegX3JO9wv5q3uEMzI1wM8lDtxn3v693gCQdKGR0Gu+FlkXld965XLbNvoAqZWyO4OBsBinLaOv9LZMoFJez48QCnzeKSwkT9S7KZsFFYc+sPLvP2Yv
 SaGIX2jP
 mneZPu37emmQvxI8qpejmLhTik05pzzmnBir3/NeCMNKVhRvoS9aTAalib4RCpy+2VPrymHvas9jhjj/h4QJwVo6kkoRRlrqAMI/FK+laj07GsAqX13/OR4J9Q0vUkoKGhHRMmNeirhVZgab00RqgNAzvAtMqEJldX+y0JH1yNC6ULB0iqE0HIOYlI62ugznWvojVQmQ4gcoSjr4OQ8eo4xJ7tNbtyyJimectrG7/uiPs2RE5vAG7ODg9WvhGLbSUknS2g3of2nhEUb0tYebRHPlNgvNMjK6NwHn83iBxukVjWwdE0GZ7OCl9PfXn4GC7ok6Hhyy8P9VpMQHVdKBwz5okpnbs7D+GtYDNiAtUjh5BJ6U6BxviDhxZl15PwhTKAT4hhqyhDt2rFg8aqxhC44lDr4jTpG0FF4lUdIDMaGKOcFBxrFRd88gN+MQXoOTbMzAsH6TgJ2BnDwWTiwZV5IdkwDBjsbV2UWjQLYHQ4iehHX20dwZ0ScyILvgfQX9tzCxg7Deqz+vREiGJhhyXtKiY/JtyKGnuu46CCCRGNPJBrM23PVs9bi5CqshhBYMMqSWcyd44N4htpefwlnbV1LEFFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 6, 2026 at 12:50=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> On Fri, Nov 06, 2026 at 09:26:19AM -0800, Joshua Hahn wrote:
> > Commit 19c5fb83f2a4 ("mm: page_alloc: avoid kswapd thrashing due to
> > NUMA restrictions") makes get_page_from_freelist() skip any node whose
> > kswapd is active to avoid piling on an already-pressured node that is
> > constantly churning to make free space that is immediately consumed.
> >
> > But kswapd can also be woken up for order 9 requests with THP defrag
> > set to defer. This means that a fragmented node with plenty of free
> > memory will have a kswapd thread continuously spinning and preventing
> > order 0 pages from allocating on the node. This causes the opposite
> > problem of piling on pressure on all other nodes.
> >
> > This behavior was observed on some Meta production workloads running on
> > 2-NUMA systems, where processes with a preference for node0 allocations
> > continuously allocated order 0 pages on node1, despite node0 having
> > hundreds of GB of free memory.
> >
> > To prevent piling pressure on any one node, only skip a node during
> > page allocation if the zone also fails the watermark kswapd is
> > reclaiming it up to. This is the high watermark, or the promo watermark
> > if NUMA balancing memory tiering is enabled. Make sure to mask the
> > reserve flags so that __GFP_HIGH / atomic requests in the slowpath
> > do not get a relaxed version of the check.
> >
> > This preserves the existing fix to prevent piling memory on the local
> > node, while also preventing memory pileups on non-local nodes when
> > the local node has memory.
> >
> > On a 2-NUMA VM with a 60G node0 and a 20G node1, with THP enabled=3Dalw=
ays
> > and defrag=3Ddefer, I ran a process that prefers allocating on node0.
> > With a fragmented node0:
> > - Before the patch, 66% of faults were served from node0
> > - After the patch, 100% of faults were served from node0
> >
> > Suggested-by: Daniel Hodges <hodgesd@meta.com>
> > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> > ---
> >  mm/page_alloc.c | 16 ++++++++++------
> >  1 file changed, 10 insertions(+), 6 deletions(-)
> >
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 5423ff4805f84..8e8a2c8d6e6a4 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -3882,14 +3882,18 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned=
 int order, int alloc_flags,
> >               }
> >
> >               /*
> > -              * If kswapd is already active on a node, keep looking
> > -              * for other nodes that might be idle. This can happen
> > -              * if another process has NUMA bindings and is causing
> > -              * kswapd wakeups on only some nodes. Avoid accidental
> > -              * "node_reclaim_mode"-like behavior in this case.
> > +              * If kswapd is already active on a node and the zone is =
below
> > +              * its kswapd watermark for this request, keep looking fo=
r other
> > +              * nodes that might be idle. This can happen if another p=
rocess
> > +              * has NUMA bindings and is causing kswapd wakeups on onl=
y some
> > +              * nodes. Avoid accidental "node_reclaim_mode" behavior.
> >                */
> >               if (skip_kswapd_nodes &&
> > -                 !waitqueue_active(&zone->zone_pgdat->kswapd_wait)) {
> > +                 !waitqueue_active(&zone->zone_pgdat->kswapd_wait) &&
> > +                 !zone_watermark_fast(zone, order, kswapd_wmark_pages(=
zone),
> > +                                      ac->highest_zoneidx,
> > +                                      alloc_flags & ~ALLOC_RESERVES,
> > +                                      gfp_mask)) {
>
> I know this code is hardly the cleanest, but you're now adding a 3rd cond=
ition
> to a branch that was already complicated enough to have a massive comment=
 and
> duplicating a block of code that already dupliclated twice here.
>
> You're also then going against the convention of
>
>         mark =3D ...
>         if (... !zone_watermark_fast(zone, order, mark,
>                                          ac->highest_zoneidx, alloc_flags=
,
>                                          gfp_mask)) {
>
> (Obviously yours varies on alloc_flags too)
>
> And also inlining the mark value.
>
> Could you clean this up a little given this isn't a fix?

Hi Lorenzo,

Thanks for taking a look at the patches! I think your requests are
valid here, let me fold that whole check into a helper function
including the comment block and hopefully that will make
get_page_from_freelist() a bit easier to read @_@. I also found an
unused gfp argument anyways, so I'll fold in some related cleanups and
send a new series.

I'll wait until tomorrow to send it out to see if other folks have
concerns with this. Thanks again, have a great day!
Joshua

> In general extending functionality should pay down some technical debt if
> possible, it's ok to add a preceding patch in the series to do something =
like
> that.
>
> >                       skipped_kswapd_nodes =3D true;
> >                       continue;
> >               }
> > --
> > 2.53.0-Meta
> >
>
> --
> Cheers, Lorenzo

