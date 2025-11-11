Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8606BCCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 21:56:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D946E8E000C; Tue, 11 Nov 2025 16:56:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6BB18E0002; Tue, 11 Nov 2025 16:56:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C829E8E000C; Tue, 11 Nov 2025 16:56:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B38E58E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 16:56:58 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4E0A712CB3B
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 21:56:58 +0000 (UTC)
X-FDA: 84099686916.16.C297BDC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id E87631C0005
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 21:56:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iwjEVkUs;
	spf=pass (imf21.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762898216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fJQdUI+LXX11RLLs0Qx52DufVkzJbNjuRnkX8eB0oEo=;
	b=upqamcrK7Ciid7TAaeY03/z8bv+I87Am0fEhIldAZMN7FvH7KFkR55sJUpWK+Y6ZcjlcjV
	ro7L8GBCX0fu2kr38Vs1PAo2qn3+7zKcTFzMb8n/gxLjkCwFuuXuelbOSlVg2x3pJ/g8Dt
	s5KglwG+WP6JK5mzkJM3ItKTVfwOyTo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762898216; a=rsa-sha256;
	cv=none;
	b=KpSs0zbXm52Ioe94Od0KMMaoKKHzNyhwSsSUIKT1dXxQqc2i4eZ8BRrZj5KyoX60Rqz56c
	FA7vaFZIQh5gHvHOAPBXLBlnpujfKaJ2RPLwLlts9pbtRWknHmYoYCuf8H9sBqEkDVwvVc
	sH40wrBLu75S3o3M49KebBYMv29MbXI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iwjEVkUs;
	spf=pass (imf21.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762898215;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fJQdUI+LXX11RLLs0Qx52DufVkzJbNjuRnkX8eB0oEo=;
	b=iwjEVkUsVdYTf1/368vXfNisjgJ+JnDHgNbZ7g4Pl9YIgdIX75UejcU/mB1ilNoEiz7Qu0
	6JFHOdPidB25lodjY0o+KLgUB2yh2FtfwNhWO6AwEe0aiiq8zwCx1eSANCs2CrvIAS4M5G
	DY9yNt3AhRmVjdLp7Mr38gLJBVGHhr4=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-271-CTvFAEV8P6SnVwoOeMG7Pg-1; Tue, 11 Nov 2025 16:56:54 -0500
X-MC-Unique: CTvFAEV8P6SnVwoOeMG7Pg-1
X-Mimecast-MFC-AGG-ID: CTvFAEV8P6SnVwoOeMG7Pg_1762898213
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-787cb36b60dso3238667b3.2
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:56:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762898213; x=1763503013;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fJQdUI+LXX11RLLs0Qx52DufVkzJbNjuRnkX8eB0oEo=;
        b=HjR1MdeC2le+/ovldDzwlY1kcW9SUn5tIw69Ggy3qQ/Lt5rP0l0mwT4AVfCrwah/0/
         XJDJ9xlNLRUBHuurhUeJ/wVnDfcPKoalk/ymn9LU1IHS6VIKk00qLLnCaEvSEHJPXTTv
         16qnxYXgRJAxXzeDykX8d1FpjXQ0gK7y1VTnsH1OEjGarteDSvEoj8L7zRKALOKLF9kU
         vW/+Rua/cwoUK+orB2uIbum6bQYHpWhehcLSJRgri8fEvjS0voQ1ev80Uc0zGCBMAWCU
         ivj/I2TM0T1DBYxkD7VvOFqPkVnM23ACXYQNP/ZGITUF0f/XK6H2O1T2sLwzTW1VF2Sc
         cmlw==
X-Forwarded-Encrypted: i=1; AJvYcCXXb59dCPhaDPnV+Oc1BGGeLfvXca097QXayqvZSnjU7MRUFUAk3LEmbcg/xNzREljelxYLvKQbgw==@kvack.org
X-Gm-Message-State: AOJu0YxOUeIR9OtwUIh7H3QIAprjLk1ObQZCUzU/iGUoNOkQ+7VsMJyw
	LN+JTJCEthQNxouj8lalZuu626GkBgw2a8Uv1t8MyWXVS8tBI8dnY2ABWA+1g6F1vqEvfhyXMcd
	hEZbuk7zsgC/yGxqPcl65bqWERN9WTvn+BihmsD/QVvr1qICvri5BINmEubnt0V5AK6pbgu2tS3
	OacVMViMXxm5dyc6ODAKB6mhuZeh8=
X-Gm-Gg: ASbGncs1QRDLhDYXpzuUMZf2niwg0o1doX2Ne6JUbTy2tF8JI+D07CbXUFdsduqWl/1
	mgswA1O7Z5Fp2fa2f2yBr2Pc5DdauhtSXEi/7lOlIwujcK2iQvNfktS46FBVkAG9iLZUrEQapGf
	p3WBElZOjEL8YMeV7GFp0+yDNPY1chB/XKkYTbaqoZO0H6vA4vxDBP6b90hrcHzBSMuA8HHg==
X-Received: by 2002:a05:690c:c341:b0:787:e9bc:f9d8 with SMTP id 00721157ae682-788136a7be5mr8843827b3.52.1762898213572;
        Tue, 11 Nov 2025 13:56:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF+b3xAzqqRUNr4xdfJt+6yqZ+2HXxhopK8ftc8r8sTeifMmau05ZwVAtlGjfvcUgQM5qWXlqEnQddMG63Dwo0=
X-Received: by 2002:a05:690c:c341:b0:787:e9bc:f9d8 with SMTP id
 00721157ae682-788136a7be5mr8843467b3.52.1762898213134; Tue, 11 Nov 2025
 13:56:53 -0800 (PST)
MIME-Version: 1.0
References: <20251022183717.70829-1-npache@redhat.com> <20251022183717.70829-13-npache@redhat.com>
 <20251109020802.g6dytbixd4aygdgh@master>
In-Reply-To: <20251109020802.g6dytbixd4aygdgh@master>
From: Nico Pache <npache@redhat.com>
Date: Tue, 11 Nov 2025 14:56:27 -0700
X-Gm-Features: AWmQ_bn3fKyzIDCH5FNeUuK4AtOvAXqhYr80QM2Hqo2H858Qfygt1YN2wMe4pp8
Message-ID: <CAA1CXcA5pKaAOxw45YQ90ygNcGc73MY8o1X9MqR7GBih9AA1HA@mail.gmail.com>
Subject: Re: [PATCH v12 mm-new 12/15] khugepaged: Introduce mTHP collapse support
To: Wei Yang <richard.weiyang@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, david@redhat.com, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, akpm@linux-foundation.org, baohua@kernel.org, 
	willy@infradead.org, peterx@redhat.com, wangkefeng.wang@huawei.com, 
	usamaarif642@gmail.com, sunnanyong@huawei.com, vishal.moola@gmail.com, 
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com, kas@kernel.org, 
	aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com, 
	catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org, 
	dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org, jglisse@google.com, 
	surenb@google.com, zokeefe@google.com, hannes@cmpxchg.org, 
	rientjes@google.com, mhocko@suse.com, rdunlap@infradead.org, hughd@google.com, 
	lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, jannh@google.com, 
	pfalcato@suse.de
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: DsQuGkCNrEbzSb26_B_2ZX6Kx-WOX9jH0uoJaOfnQhg_1762898213
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: rfpn5ykzrb3dyhzx4mazqmifacfnyt1o
X-Rspam-User: 
X-Rspamd-Queue-Id: E87631C0005
X-Rspamd-Server: rspam01
X-HE-Tag: 1762898215-392193
X-HE-Meta: U2FsdGVkX1+UjgFSL/Cy4KzAJ0lX9gDinGZ45UmwJwJUa48c9Sby5PWf7gm0uADBkrvQYT3XWYfm+qIdlKHj2b8kJn3P1sZVRON8kqfu8y1Og4JanqapotaIWnZVu7AkF6SKHygCYZYh+m4jgB3c2nfXEcZyTLtd3rOGf5kC9pB9rPvU0XT2QekQzYnJjzHA1bLqkMUOsMkY3gzl3fF+yYBjtn3eZT5smmKZ3JZeibciDkbYtH7SC/Kr9z3p3t6w8DrSHvVBv71afgAv4ul/RXXteckd+Q0UsQBP4TS/yBL9yO/DI2xO8w8zGu6Ow0peq9e5qcoprKnr2H0h9b+YPVIS10HAtwlrRR/xNjHfJAzjv7/tv3AhadB2XNSXtxs0AGMvzstTogRMoPFQDR+G7BCIVS8yZkz2HEMa0hK/p8keX4gVj/5ymEMqKKajDjlKh6zlP0LRxMbKcYO5N7otFf7MNvytT1xvfHu6prX0WUF+1ae/IJua3qNKhi1UoHVyVYACsBeftLpYqYH28XdeCOpbJ+nqZwibnygq0ecpWiuCoL16cGePWfHMxcCoBLGZTmB4FExbNayl1n5rArE+0LLJ9ZDm6aoLLnq8fAGbsX1KWFH0hPQk0cPSa0lq22IWNRptO/5lUeh2G3FliMuhcLa2fxNF8HiYHWwCGHTaBK0Cwy4odZuk0MdnOtkegoWmdiHMXKmwTbxukP/SQvEOuiQIr7brNJwxrigpA+qQrc/asMt9JETApHZr1i+MRfcrRgZ0FqVCqqC+xVFUJU4RtP3GNSi0ZB8s3SbabG9t9LXCfjfQaMoYRoNp0UYzMAujPTEFjjzdFJhSTLfhzMBkkR2BvNHR7DgspV0e0ZYEvu+u//4OcF/gC+6cu+nsHZqMo0PxUMKkFRHpCgplRO+qAmG6Ge8JWdQJDTFuX1TIq+f/DIESB+9+466EEppt97iygMyHvUGRbFoWeJyXLGR
 P5BuX8GP
 G0tRZVzi3sWht09P8kMipdZMGMHv6QIEuVeTU1r611WZC3gXxS2i2ncczRtLEjabPjDgQ5irPOVIqPiDWD8jQQgVolbKYH1bhqRZWsNPA8KL1vLF3o3P/CkvSwuPqtJCDX2kuKzwfZeb4I967gXVzfV52pRB69Dl6dU3QZgY4oKRqlfR60dlgJJw4BjnBdDU6iQH6f6jWk3EWCgIPBf/MsHSeFqjpmp3jD+1F8xB0qYZOEYcHvXNXkiGiM8TQsBUnfsbl6I3+KGAZFGs3sIyuP4nnT63ielKXML+K1hbp768BkQ8WA09ztocyjB2rFHmV2SgCTK+fDCu9elRaokkxlWnR9dGXtLxytqms8ocFIlc/mqnfLAHLXBIKQqtgLBGQS+nA5SdEyEObL6QO/UALaarFDA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 8, 2025 at 7:08=E2=80=AFPM Wei Yang <richard.weiyang@gmail.com>=
 wrote:
>
> On Wed, Oct 22, 2025 at 12:37:14PM -0600, Nico Pache wrote:
> >During PMD range scanning, track occupied pages in a bitmap. If mTHPs ar=
e
> >enabled we remove the restriction of max_ptes_none during the scan phase
> >to avoid missing potential mTHP candidates.
> >
> >Implement collapse_scan_bitmap() to perform binary recursion on the bitm=
ap
> >and determine the best eligible order for the collapse. A stack struct i=
s
> >used instead of traditional recursion. The algorithm splits the bitmap
> >into smaller chunks to find the best fit mTHP.  max_ptes_none is scaled =
by
> >the attempted collapse order to determine how "full" an order must be
> >before being considered for collapse.
> >
> >Once we determine what mTHP sizes fits best in that PMD range a collapse
> >is attempted. A minimum collapse order of 2 is used as this is the lowes=
t
> >order supported by anon memory.
> >
> >mTHP collapses reject regions containing swapped out or shared pages.
> >This is because adding new entries can lead to new none pages, and these
> >may lead to constant promotion into a higher order (m)THP. A similar
> >issue can occur with "max_ptes_none > HPAGE_PMD_NR/2" due to a collapse
> >introducing at least 2x the number of pages, and on a future scan will
> >satisfy the promotion condition once again. This issue is prevented via
> >the collapse_allowable_orders() function.
> >
> >Currently madv_collapse is not supported and will only attempt PMD
> >collapse.
> >
> >We can also remove the check for is_khugepaged inside the PMD scan as
> >the collapse_max_ptes_none() function handles this logic now.
> >
> >Signed-off-by: Nico Pache <npache@redhat.com>
>
> Generally LGTM.
>
> Some nit below.
>
> >---
> > include/linux/khugepaged.h |   2 +
> > mm/khugepaged.c            | 128 ++++++++++++++++++++++++++++++++++---
> > 2 files changed, 122 insertions(+), 8 deletions(-)
> >
> >diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
> >index eb1946a70cff..179ce716e769 100644
> >--- a/include/linux/khugepaged.h
> >+++ b/include/linux/khugepaged.h
> >@@ -1,6 +1,8 @@
> > /* SPDX-License-Identifier: GPL-2.0 */
> > #ifndef _LINUX_KHUGEPAGED_H
> > #define _LINUX_KHUGEPAGED_H
> >+#define KHUGEPAGED_MIN_MTHP_ORDER     2
> >+#define MAX_MTHP_BITMAP_STACK (1UL << (ilog2(MAX_PTRS_PER_PTE) - KHUGEP=
AGED_MIN_MTHP_ORDER))
> >
> > #include <linux/mm.h>
> >
> >diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> >index 89a105124790..e2319bfd0065 100644
> >--- a/mm/khugepaged.c
> >+++ b/mm/khugepaged.c
> >@@ -93,6 +93,11 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_hash, MM=
_SLOTS_HASH_BITS);
> >
> > static struct kmem_cache *mm_slot_cache __ro_after_init;
> >
> >+struct scan_bit_state {
> >+      u8 order;
> >+      u16 offset;
> >+};
> >+
> > struct collapse_control {
> >       bool is_khugepaged;
> >
> >@@ -101,6 +106,13 @@ struct collapse_control {
> >
> >       /* nodemask for allocation fallback */
> >       nodemask_t alloc_nmask;
> >+
> >+      /*
> >+       * bitmap used to collapse mTHP sizes.
> >+       */
> >+       DECLARE_BITMAP(mthp_bitmap, HPAGE_PMD_NR);
> >+       DECLARE_BITMAP(mthp_bitmap_mask, HPAGE_PMD_NR);
> >+      struct scan_bit_state mthp_bitmap_stack[MAX_MTHP_BITMAP_STACK];
>
> Looks like an indent issue.

Thanks!
>
> > };
> >
> > /**
> >@@ -1357,6 +1369,85 @@ static int collapse_huge_page(struct mm_struct *m=
m, unsigned long pmd_address,
> >       return result;
> > }
> >
> >+static void push_mthp_bitmap_stack(struct collapse_control *cc, int *to=
p,
> >+                                 u8 order, u16 offset)
> >+{
> >+      cc->mthp_bitmap_stack[++*top] =3D (struct scan_bit_state)
> >+              { order, offset };
> >+}
> >+
>
> For me, I may introduce pop_mth_bitmap_stack() .
>
> And use it ...
>
> >+/*
> >+ * collapse_scan_bitmap() consumes the bitmap that is generated during
> >+ * collapse_scan_pmd() to determine what regions and mTHP orders fit be=
st.
> >+ *
> >+ * Each bit in the bitmap represents a single occupied (!none/zero) pag=
e.
> >+ * A stack structure cc->mthp_bitmap_stack is used to check different r=
egions
> >+ * of the bitmap for collapse eligibility. We start at the PMD order an=
d
> >+ * check if it is eligible for collapse; if not, we add two entries to =
the
> >+ * stack at a lower order to represent the left and right halves of the=
 region.
> >+ *
> >+ * For each region, we calculate the number of set bits and compare it
> >+ * against a threshold derived from collapse_max_ptes_none(). A region =
is
> >+ * eligible if the number of set bits exceeds this threshold.
> >+ */
> >+static int collapse_scan_bitmap(struct mm_struct *mm, unsigned long add=
ress,
> >+              int referenced, int unmapped, struct collapse_control *cc=
,
> >+              bool *mmap_locked, unsigned long enabled_orders)
> >+{
> >+      u8 order, next_order;
> >+      u16 offset, mid_offset;
> >+      int num_chunks;
> >+      int bits_set, threshold_bits;
> >+      int top =3D -1;
> >+      int collapsed =3D 0;
> >+      int ret;
> >+      struct scan_bit_state state;
> >+      unsigned int max_none_ptes;
> >+
> >+      push_mthp_bitmap_stack(cc, &top, HPAGE_PMD_ORDER - KHUGEPAGED_MIN=
_MTHP_ORDER, 0);
> >+
> >+      while (top >=3D 0) {
> >+              state =3D cc->mthp_bitmap_stack[top--];
>
> ... here.

Ack!

>
> >+              order =3D state.order + KHUGEPAGED_MIN_MTHP_ORDER;
>
> We push real_order - KHUGEPAGED_MIN_MTHP_ORDER, and get it by add
> KHUGEPAGED_MIN_MTHP_ORDER.
>
> Maybe we can push real_order ...
>
> >+              offset =3D state.offset;
> >+              num_chunks =3D 1UL << order;
> >+
> >+              /* Skip mTHP orders that are not enabled */
> >+              if (!test_bit(order, &enabled_orders))
> >+                      goto next_order;
> >+
> >+              max_none_ptes =3D collapse_max_ptes_none(order, !cc->is_k=
hugepaged);
> >+
> >+              /* Calculate weight of the range */
> >+              bitmap_zero(cc->mthp_bitmap_mask, HPAGE_PMD_NR);
> >+              bitmap_set(cc->mthp_bitmap_mask, offset, num_chunks);
> >+              bits_set =3D bitmap_weight_and(cc->mthp_bitmap,
> >+                                           cc->mthp_bitmap_mask, HPAGE_=
PMD_NR);
> >+
> >+              threshold_bits =3D (1UL << order) - max_none_ptes - 1;
> >+
> >+              /* Check if the region is eligible based on the threshold=
 */
> >+              if (bits_set > threshold_bits) {
> >+                      ret =3D collapse_huge_page(mm, address, reference=
d,
> >+                                               unmapped, cc, mmap_locke=
d,
> >+                                               order, offset);
> >+                      if (ret =3D=3D SCAN_SUCCEED) {
> >+                              collapsed +=3D 1UL << order;
> >+                              continue;
> >+                      }
> >+              }
> >+
> >+next_order:
> >+              if (state.order > 0) {
>
> ...and if (order > KHUGEPAGED_MIN_MTHP_ORDER) here?
>
> Not sure you would like it.

I went ahead and implemented this based on real order. Thanks for the
suggestion, it's much cleaner now. It made more sense like this when I
had the bitmap compressed into 128 bits.

>
> >+                      next_order =3D state.order - 1;
> >+                      mid_offset =3D offset + (num_chunks / 2);
> >+                      push_mthp_bitmap_stack(cc, &top, next_order, mid_=
offset);
> >+                      push_mthp_bitmap_stack(cc, &top, next_order, offs=
et);
> >+              }
> >+      }
> >+      return collapsed;
> >+}
> >+
> > static int collapse_scan_pmd(struct mm_struct *mm,
> >                            struct vm_area_struct *vma,
> >                            unsigned long start_addr, bool *mmap_locked,
> >@@ -1364,11 +1455,15 @@ static int collapse_scan_pmd(struct mm_struct *m=
m,
> > {
> >       pmd_t *pmd;
> >       pte_t *pte, *_pte;
> >+      int i;
> >       int result =3D SCAN_FAIL, referenced =3D 0;
> >-      int none_or_zero =3D 0, shared =3D 0;
> >+      int none_or_zero =3D 0, shared =3D 0, nr_collapsed =3D 0;
> >       struct page *page =3D NULL;
> >+      unsigned int max_ptes_none;
> >       struct folio *folio =3D NULL;
> >       unsigned long addr;
> >+      unsigned long enabled_orders;
> >+      bool full_scan =3D true;
> >       spinlock_t *ptl;
> >       int node =3D NUMA_NO_NODE, unmapped =3D 0;
> >
> >@@ -1378,16 +1473,29 @@ static int collapse_scan_pmd(struct mm_struct *m=
m,
> >       if (result !=3D SCAN_SUCCEED)
> >               goto out;
> >
> >+      bitmap_zero(cc->mthp_bitmap, HPAGE_PMD_NR);
> >       memset(cc->node_load, 0, sizeof(cc->node_load));
> >       nodes_clear(cc->alloc_nmask);
> >+
> >+      enabled_orders =3D collapse_allowable_orders(vma, vma->vm_flags, =
cc->is_khugepaged);
> >+
> >+      /*
> >+       * If PMD is the only enabled order, enforce max_ptes_none, other=
wise
> >+       * scan all pages to populate the bitmap for mTHP collapse.
> >+       */
> >+      if (cc->is_khugepaged && enabled_orders =3D=3D _BITUL(HPAGE_PMD_O=
RDER))
>
> We sometimes use BIT(), e.g. in collapse_allowable_orders().
> And sometimes use _BITUL().
>
> Suggest to use the same form.

Yeah I caught this after posting, I missed this one!

>
> Nothing else, great job!

Thank you :) I appreciate the reviews!

>
> >+              full_scan =3D false;
> >+      max_ptes_none =3D collapse_max_ptes_none(HPAGE_PMD_ORDER, full_sc=
an);
> >+
> >       pte =3D pte_offset_map_lock(mm, pmd, start_addr, &ptl);
> >       if (!pte) {
> >               result =3D SCAN_PMD_NULL;
> >               goto out;
> >       }
> >
> >-      for (addr =3D start_addr, _pte =3D pte; _pte < pte + HPAGE_PMD_NR=
;
> >-           _pte++, addr +=3D PAGE_SIZE) {
> >+      for (i =3D 0; i < HPAGE_PMD_NR; i++) {
> >+              _pte =3D pte + i;
> >+              addr =3D start_addr + i * PAGE_SIZE;
> >               pte_t pteval =3D ptep_get(_pte);
> >               if (is_swap_pte(pteval)) {
> >                       ++unmapped;
> >@@ -1412,8 +1520,7 @@ static int collapse_scan_pmd(struct mm_struct *mm,
> >               if (pte_none_or_zero(pteval)) {
> >                       ++none_or_zero;
> >                       if (!userfaultfd_armed(vma) &&
> >-                          (!cc->is_khugepaged ||
> >-                           none_or_zero <=3D khugepaged_max_ptes_none))=
 {
> >+                          none_or_zero <=3D max_ptes_none) {
> >                               continue;
> >                       } else {
> >                               result =3D SCAN_EXCEED_NONE_PTE;
> >@@ -1461,6 +1568,8 @@ static int collapse_scan_pmd(struct mm_struct *mm,
> >                       }
> >               }
> >
> >+              /* Set bit for occupied pages */
> >+              bitmap_set(cc->mthp_bitmap, i, 1);
> >               /*
> >                * Record which node the original page is from and save t=
his
> >                * information to cc->node_load[].
> >@@ -1517,9 +1626,12 @@ static int collapse_scan_pmd(struct mm_struct *mm=
,
> > out_unmap:
> >       pte_unmap_unlock(pte, ptl);
> >       if (result =3D=3D SCAN_SUCCEED) {
> >-              result =3D collapse_huge_page(mm, start_addr, referenced,
> >-                                          unmapped, cc, mmap_locked,
> >-                                          HPAGE_PMD_ORDER, 0);
> >+              nr_collapsed =3D collapse_scan_bitmap(mm, start_addr, ref=
erenced, unmapped,
> >+                                            cc, mmap_locked, enabled_or=
ders);
> >+              if (nr_collapsed > 0)
> >+                      result =3D SCAN_SUCCEED;
> >+              else
> >+                      result =3D SCAN_FAIL;
> >       }
> > out:
> >       trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
> >--
> >2.51.0
>
> --
> Wei Yang
> Help you, Help me
>


