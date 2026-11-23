Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20351606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 01:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=QBsr1zvR
Received: by kanga.kvack.org (Postfix)
	id 095E26B05B3; Sun, 22 Nov 2026 20:43:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0461F6B05B4; Sun, 22 Nov 2026 20:43:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2BFA6B05B5; Sun, 22 Nov 2026 20:43:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A776D6B05B3
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 20:43:28 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2259E407A7
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 01:43:28 +0000 (UTC)
X-FDA: 85464686496.19.D107BA9
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf24.hostedemail.com (Postfix) with ESMTP id 370B1180004
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 01:43:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=QBsr1zvR;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795398206;
	b=H07Y1tqfsm50qNIIqfkdvksoG60DZ8YJPIQrsOTCdOTOHf1W5vvg3ieOaaPTnx2qzAhsjI
	pgLISxkl0Fl4CP6H+dmZxZhFYxXPlRzbzYD5pIunmzmxnDIEFb30EGG4jQBIGlFwoc+EYv
	ht1nqnlhGPEHftT56zho16MUNXAbTGM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795398206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BrVQwSIPnVhHdrsgKZy8tODX9WT1tDuIYLyA3zVqg3w=;
	b=jQzuKM1YBvTWxFbh23kezPsWIoYqn5k/+KtKa0Wtkao1uwnqmacP8k0Q3sBkdM6gBUXtOb
	I+BzjoxAqqawaxrVNGY5QkHoxFJ6oABjQpgTQrGV5zEWIoG8LwDRsAzqXL8Vn6g75K+YA8
	hgvSugRUbKPS3yF1704mmy9gRatQKlE=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=QBsr1zvR;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4bb702a7548so20235225e9.1
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 17:43:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795398205; cv=none;
        d=google.com; s=arc-20260327;
        b=J4h5HAPVv0z98MhUtUVWh+gX76KtwfY8SG6H5A56KV17GgLQV4KBuukaejYC5eZKfX
         Fx28OkYQiT4gE9EYUnt/d3Gf9AjmD7LL+qhIyEBlDJph0r8W3vzNeJrzxD3X3yigwQbk
         GSCZFbPftjaB75Hy00lafhl8d2AdrlVdVkuN7rXvqXVx+N/8LfG4vEvHBTJHXEG/i8EE
         ktYs4g8qOHLTcaSfjxDrhAd1ljfHVl3o8u21DjmT7XlDyzkRpoxHGIXGQ+f3gvaypUTo
         v+slxOUbm/y+qczxyD2VzDqHDQZUiuJ/d+abUtmfa+7Kxbb5Yjoxn+fc+09/wQrSDm8y
         UMIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BrVQwSIPnVhHdrsgKZy8tODX9WT1tDuIYLyA3zVqg3w=;
        fh=BreUFRwPfo8in1YgxdNM3CEmyWeZ42beJhCpvJu1Uhg=;
        b=eYKOG9YQsmbd5KuztzZOdHz7PRgRNta1T4RMX6DR1wlrXxOVYh/N0ljaf+MhZQsFpd
         S1WdjBx8EM1PuOVpRIZFqfiF14dTbrR+ewdWOw7zT3FE+FJVeFh4CPSXLS7SlmlCQl9Y
         Hzgrg5+B1mVI2s4ujy0I4BFkSG8W9fIBSs6jn/igu9yQzTvdRjVeTiMVf/YLPYXY3rN6
         j+kljnK3yuoavKZlEVW5qJuswPMwHh4G7MAVrmMWCDZ+vdsuCa/YvwtxmbjB0e37uVCe
         4VZqx7btntRCb2ZhpFCpWQvfjTcuhsdrRFBdcVsMQCsyr6DdC3jY7MyAln5OLvnJ3dAQ
         +mNg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795398205; x=1796003005; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BrVQwSIPnVhHdrsgKZy8tODX9WT1tDuIYLyA3zVqg3w=;
        b=QBsr1zvRnxPT/LM9BTt3Sd6Ra5Y7sTDC+vKlW7VFjRMA5o+WCvE9PY1S+VIY05pFIb
         xelnkszEME000QI99XnXJwNGnFce08De2+5RmMlFVufiuBfJVD15Oz5TT7fswqbkG9F1
         WQkFm4bbA92gaU4pN+15O8TXMD1S9wPDHQxtEPL2E2uBr3OKIrkxVxWg6Une8pptPkjB
         KQ8nVq9uAh/UABwTAMshpuDShvbrWoHJjIwehuEzRNHVpKcvDmN5ZtheV6E6HKnkgnkc
         UDC2J1vkWrOEiOsjXBKtEmi8dKJhMhy9o8c25E+WGN0k0DqsgP+ak902aDn1kc9WC/9a
         jomg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795398205; x=1796003005;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BrVQwSIPnVhHdrsgKZy8tODX9WT1tDuIYLyA3zVqg3w=;
        b=EyeiHDo0wmW2zFMqwWVxKjENGxVMWd7csbfpOffDLQ8SS9lfgj5ke5EK42awI2cKbM
         pEzfplrQ4uuYSGumV5AgpgJicJDXpDn4P0Sfm0EYl1P0zUJAwmAOL4r9Ms1OqT78TxtD
         X2LMYBfXKrTMC3VsLxS7TrDCiJKUEz8PXVvZTmmzSmlYlwu9kcslMvKijyW5xCOHtE/C
         TBC1fkAD/ZXqPMIJtOAVwU2QECDJdz8zNbUAIROnRhxKj+KZiNtISQvnk4pxLezClhbm
         BXNwosRE4UqJJdfj2q6xOkmN/qBYmFiixKH2X2RDAEyjOR1L4Z199ni0whiaUY2rez+2
         9CKQ==
X-Gm-Message-State: APuU4Z9Nfx/4+3SfAi/q0DX/GUoFzk/LPZzRgQ1+KQSnJMu/fGjO7idu
	9ubC5wFrbJO0+u2PSxIi961HGjPD6+zM6cj841490epkxgBHw9ZSCNysL8Io1KZf/CuOIGLN+Hg
	TsbCe5pvi8jwL2vsuaI4dXcJ/SReQ1bg=
X-Gm-Gg: AZFdTZdfRgtWjGxjdCPW9yFTgulwJa7oL+WqEyEB5LCUNgkKoudTDUebndUFBtx8P9M
	v8RbypuaeS0xtUMy0XImTxN+ti/XZtoatZRjWJKZN+ZySIddkJQ4BdpMMLiZitlU0m34PCm3Pmi
	hoa3yW6b8Q+MiH2a9OMBx9QtnbPzd/jODXx2LiUwHnPgIcdN98FYvMrvOp3M92NrbDHGsJr0epU
	X2NkR4fLcMhc44VCpg3wpXumPJPPXXbWx++/jkKNzuqbhBA1SX/0UArz1+L/dH7bwmMwLvFMEdd
	2c/WElKc+HYQp7pqQLso6DXp3o8POMOOZp8VPLRmlOR8l3Y/udxN9NeBnpnv+KcmpQ1sflsDBcZ
	G47lp6+GwJAobds0ch21fGAd1lGOZmMfsYGw09UgsGQ3LuplkL7Aezf4OEYB3jKc6CJrB5OKuoJ
	HIM+QHwd0qCBfqWU5SAyCOlz78nrjrOkdb990Y//JBWr2C0g+4ZpUCKNIKCQUrtS4V6eCIr08oj
	Q==
X-Received: by 2002:a05:600c:8b11:b0:4bb:6871:8f21 with SMTP id
 5b1f17b1804b1-4bb88822346mr213653915e9.23.1795398204221; Sun, 22 Nov 2026
 17:43:24 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
 <20261119-mglru-fg-v5-16-9eee2fe97a2d@tencent.com> <CAN_Opa-+nb0vxQ+HsENCG2fEEMZoxG9Sy_DBC4CLkWjNLzDWKw@mail.gmail.com>
 <CAMgjq7CEdWvv8m9GtWMG=8OFy+1Sehx3HBJt2D=9hntwvfbf6w@mail.gmail.com>
In-Reply-To: <CAMgjq7CEdWvv8m9GtWMG=8OFy+1Sehx3HBJt2D=9hntwvfbf6w@mail.gmail.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Mon, 23 Nov 2026 09:43:12 +0800
X-Gm-Features: Aa3M54oNBYyw9pCyIXqZNWTI0hkUvgld-jGgCS21qlijWr31Z0q9q7Y9XszeYmQ
Message-ID: <CAN_Opa8L3Ygfu5o7Y8ZD9GTmiEygCXpq2TzAJtwgQChdyb2dSQ@mail.gmail.com>
Subject: Re: [PATCH v5 16/17] mm/mglru: make folio_inc_lru_refs lruvec lockless
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh <ehab.ababneh@intel.com>, 
	Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 370B1180004
X-Stat-Signature: qg9jq6jddc7cai4ucbkj7itsbqkfzcrr
X-HE-Tag: 1795398206-936131
X-HE-Meta: U2FsdGVkX19Sj9/yBpGICcDtbSsR8dOlYyNj5NedlT1DpWIpj5ZRhfBWUCviWIa7hL8pW+q09E24c2GmkKnYeU8LCuaxut+DB27+BdTkPUYncPApYsHwwXrwxrNcpBoO75GzMZ4OKbeNJCJUXyzE7qrMEsUDiXYVKZ24S8X8TRZGbxzi2F0PBkGgaRRGSG3xvs08J8JLk+jiONOFKtXLIe6hKV7ZPPVRTQCt4gIUDxrNw1263c/W6K0bSxmIjtYGPg0VbEuJzzMAKnd02MEznWFuyFEsBQhU4JrNhn7IwKuLWKdIAKLLMnAklhxLDmA8M/yOo0DmpGoJykUEk7VO1WXjpp0O0/QVGdNDbWdmDOye9hWJ9d6Te5gbljXMILuGS5YN0TH2Zbk9tZiAr+2+DDBvv65gZRpO00mhal5Ue3agJZ8HktcKZMX6yWDyRuVMv2YgPwGML9Z07hDXIeWhfKX+Gf1wsao1Au9ue++QvXnmbaJMGgAgD3zKkllcBbXInqwl9OAAUX8sWeRiZKSagYz1+gnXDOPQAXwADlKebHkGt+fUQHSOPK1WIHLee1tBZV9WuEOMLR1k0xG7r61tVs8n4npo+yN0kaus3tB763pVBgPCh5rAi/XxCtZURhKk19qmLeXvl5XOPt5yU8f1lu4igI1ubosUlMk6N6OImCaLZrgVWTZ5a5z5u3UeZMNEtqthK7QY2Ye+AR3beofp/fK0AeVDxw3chUD5X6JohnpOZX24i59eLP1F97u1wUYsXF/z6VSJ2vboeTnV/2ehLPJxfZJMJFRnwP71F+lLMHpejePH/A5qMPINSmg5zkRWwHjNB8dMHzUaOhyTE+LCu6lTXcSRdDTSz0vrfsWDhmjC3u7euAlVQUFQ5N/1eqZ3HNmoamiaiOieN2mvNVBT95R/vVPjoRIPtIgXhvsJyW2aeyBWt1f41DV6yw03RLU6r0QGfkMB25ff1H4FDC/
 1ed6Fj1I
 oG1HXy8hxZIw9ELRSztup9ecf/10JE8nJ7QntHfVZVMlh7YpGXpvjXW1V4ICOnbwVK1bCX23ZLxcNJ5TA6C6YTLz5KlJ8c/Hmwt/ymEEXas4aPwqaQA+LlBF5TgUCAG4Bc2VKS4tjPMP6GcPyxcVTJDZf/rd/TQe4Lw7RCVL44BVNDTnIy8Z5NtA4siOqOaLmF0bfIIpJKuROIkA7UGUm+8a4xIwKVFMeVeywXrPwjxieaULoBpkOBG/wV3uXK3WN76BtBemjYeuSdoolCdPodoMraFmbaOV9DJ9mTzEufHffD5eTFyBfdfBy3xGNkl/rRU5+ZKXAYkT+KJMqYSYvDQxgKOgHAl0XFiLMz4HT7HVbNkVwSblL/N8gxuetbuuZ957g8xuJ64D5LZxz4s4JogIAmT1y+/U7YDpenDMtJpR3+zkC3c5BN5qok8meWH+pMNSvNcqFn9HG9gpXB1sHukEsl9GQRqxHGTXmFTcMZTIdh+s1AsKRqZDooIS+S7GAvZZqrAJ16/7VKXwq7OTP4R1kHJDOezPICEXsmTOkSJR1qSWcf3YEFbyxWgFEm70i82vGqHXBxiIyxhLNPee8F9CqevLqk0BOMZ7SnjLrr8Oa+OjaVq42k1BxX8ZPqT6VZ59wrMEkYTO9MmNVmgYqjT/njA62DE8hkFiVLx+B+aqmbVtu5T+KBrAh/lXgfhyLctqpeVBYSteoqAhuKgW+xdfBmIEHvsa+MttYwepX2S8q3Lc3JXwpRWz1RWb+L8l5sQLXu2TtB+OCNe8XOIAq6pu8xsT3n6AXJ5Wj8/6OPYHo5uImzNJ1rR4JtQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 22, 2026 at 11:33=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wro=
te:
>
> On Fri, Nov 20, 2026 at 5:42=E2=80=AFPM KunWu Chan <kunwu.chan@gmail.com>=
 wrote:
> >
> > On Thu, Nov 19, 2026 at 5:04=E2=80=AFAM Kairui Song via B4 Relay
> > <devnull+kasong.tencent.com@kernel.org> wrote:
> > >
> > > From: Kairui Song <kasong@tencent.com>
> > >
> > > The lruvec spinlock in folio_inc_lru_refs was only taken to keep
> > > concurrent aging from corrupting the size counters.  This is no
> > > longer needed: the per-generation counters are atomic, and the
> > > active/inactive ABI counters are updated per folio and linearized by
> > > the CAS on the folio flags, so concurrent aging can no longer corrupt
> > > them.  The same argument is what lets folio_reset_lru_refs() update
> > > the counters without the lruvec lock.
> > >
> > > Use folio_lruvec_live_get()/folio_lruvec_live_put() to hold the RCU
> > > read lock around the lruvec lookup, and drop the spinlock entirely.
> > >
> > > Without the lock, aging can advance max_seq while a promotion is in
> > > flight.  Generations are indexed by seq % MAX_NR_GENS, so the folio
> > > flags can return to the value read earlier and the cmpxchg succeeds
> > > with a target gen computed from a stale max_seq.  Recheck max_seq aft=
er
> > > a gen-changing cmpxchg: if it moved, account the committed update and
> > > retry with LRU_REF_FORCE, which promotes the folio to the newest gen.
> > > The retry may count the access twice, which is acceptable and avoids
> > > folio_activate(), whose LRU lock causes latency jitter.  smp_rmb()
> > > orders the flags read, including the one returned by a failed
> > > cmpxchg(), before the max_seq read.
> > >
> > > Also simplify the post-CAS accounting guards: gen is only assigned
> > > non-negative values after the old_gen < 0 early exit, so gen !=3D old=
_gen
> > > implies gen >=3D 0, and lru_gen_update_size() needs no explicit guard=
.
> > > The active/inactive ABI update keeps its gen >=3D 0 check because an
> > > off-LRU folio has no lruvec to update.
> > >
> > > Signed-off-by: Kairui Song <kasong@tencent.com>
> > > ---
> > >  include/linux/mm_inline.h | 10 +++++-----
> > >  include/linux/mmzone.h    |  3 ++-
> > >  mm/vmscan.c               | 51 +++++++++++++++++++++++++++++--------=
----------
> > >  3 files changed, 39 insertions(+), 25 deletions(-)
> > >
> > > diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> > > index 77f514143266..2c6cbd0df686 100644
> > > --- a/include/linux/mm_inline.h
> > > +++ b/include/linux/mm_inline.h
> > > @@ -317,10 +317,9 @@ static inline bool lru_gen_is_old(struct lruvec =
*lruvec, int type, int gen)
> > >                gen =3D=3D lru_gen_from_seq(min_seq + 1);
> > >  }
> > >
> > > -static inline void lru_gen_update_size(struct lruvec *lruvec, struct=
 folio *folio,
> > > -                                      int old_gen, int new_gen)
> > > +static inline void lru_gen_update_size(struct lruvec *lruvec, int ty=
pe,
> > > +                                      struct folio *folio, int old_g=
en, int new_gen)
> > >  {
> > > -       int type =3D folio_is_file_lru(folio);
> > >         int zone =3D folio_zonenum(folio);
> > >         int delta =3D folio_nr_pages(folio);
> > >         struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> > > @@ -399,7 +398,7 @@ static inline bool __lru_gen_add_folio(struct lru=
vec *lruvec, struct folio *foli
> > >         /* use the refs from the atomic snapshot to avoid raced updat=
e */
> > >         refs =3D lru_get_refs_flags(flags);
> > >
> > > -       lru_gen_update_size(lruvec, folio, -1, gen);
> > > +       lru_gen_update_size(lruvec, type, folio, -1, gen);
> > >         if (lru_refs_is_active(refs))
> > >                 lru +=3D LRU_ACTIVE;
> > >         __update_lru_size(lruvec, lru, zone, delta);
> > > @@ -429,6 +428,7 @@ static inline bool lru_gen_del_folio(struct lruve=
c *lruvec, struct folio *folio,
> > >         unsigned long flags;
> > >         unsigned int refs;
> > >         int gen;
> > > +       int type =3D folio_is_file_lru(folio);
> > >         int zone =3D folio_zonenum(folio);
> > >         int delta =3D folio_nr_pages(folio);
> > >         enum lru_list lru =3D folio_is_file_lru(folio) * LRU_INACTIVE=
_FILE;
> > > @@ -452,7 +452,7 @@ static inline bool lru_gen_del_folio(struct lruve=
c *lruvec, struct folio *folio,
> > >         if (!reclaiming && ((max_seq - gen) % MAX_NR_GENS) < MIN_NR_G=
ENS)
> > >                 folio_set_active(folio);
> > >
> > > -       lru_gen_update_size(lruvec, folio, gen, -1);
> > > +       lru_gen_update_size(lruvec, type, folio, gen, -1);
> > >         if (lru_refs_is_active(refs))
> > >                 lru +=3D LRU_ACTIVE;
> > >         __update_lru_size(lruvec, lru, zone, -delta);
> > > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > > index 2680e15b6de9..235fb04f8d78 100644
> > > --- a/include/linux/mmzone.h
> > > +++ b/include/linux/mmzone.h
> > > @@ -540,9 +540,10 @@ enum lruvec_flags {
> > >  #define LRU_TIER_MIN           0U
> > >  #define LRU_TIER_MAX           (MAX_NR_TIERS - 1)
> > >
> > > -/* Access source flags for folio_inc_lru_refs() */
> > > +/* Flags for folio_inc_lru_refs() */
> > >  #define LRU_REF_MAPPED         0x1U
> > >  #define LRU_REF_EXEC           0x2U
> > > +#define LRU_REF_FORCE          0x4U
> > >
> > >  #define LRU_REFS_REFERENCED    0x1
> > >  #define LRU_REFS_WORKINGSET    0x2
> > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > index 78a1b4de7076..4576a7a369e3 100644
> > > --- a/mm/vmscan.c
> > > +++ b/mm/vmscan.c
> > > @@ -876,37 +876,35 @@ void folio_inc_lru_refs(struct folio *folio, un=
signed int flags)
> > >         long nr_pages =3D folio_nr_pages(folio);
> > >         struct lru_gen_folio *lrugen;
> > >         struct lruvec *lruvec =3D NULL;
> > > +       bool aged =3D false;
> > >
> > > +retry:
> > >         old_flags =3D READ_ONCE(*folio_flags(folio, 0));
> > >         do {
> > >                 new_flags =3D old_flags;
> > >                 old_gen =3D lru_get_gen_flags(old_flags);
> > >                 old_refs =3D lru_get_refs_flags(old_flags);
> > > -               file =3D folio_flags_is_file_lru(&old_flags);
> > >                 refs =3D old_refs + 1;
> > >                 gen =3D old_gen;
> > > +               file =3D folio_flags_is_file_lru(&old_flags);
> > >                 if (old_gen < 0)
> > >                         goto out;
> > > -               /*
> > > -                * Lock the lruvec if the folio is on-list. We are al=
ready
> > > -                * doing lazy promotion so in theory we don't need th=
is,
> > > -                * but for now, concurrent aging would still corrupt =
the
> > > -                * size counters.  This is a temporary limitation and
> > > -                * will be lifted very soon, so the lock here is not =
a
> > > -                * performance concern.
> > > -                */
> > >                 if (!lruvec) {
> > > -                       lruvec =3D lruvec_live_lock_irq(folio_lruvec(=
folio));
> > > +                       lruvec =3D folio_lruvec_live_get(folio);
> > >                         lrugen =3D &lruvec->lrugen;
> > >                 }
> > > +               /*
> > > +                * Read the flags before max_seq, paired with the sto=
re of a
> > > +                * gen, which samples max_seq first.
> > > +                */
> > > +               smp_rmb();
> > >                 max_seq =3D READ_ONCE(lrugen->max_seq);
> > >                 max_gen =3D lru_gen_from_seq(max_seq);
> > >                 if (old_gen =3D=3D max_gen)
> > >                         goto out;
> > > -
> > > -               if (flags & (LRU_REF_MAPPED | LRU_REF_EXEC)) {
> > > -                       /* Promote second page table access or execut=
able */
> > > -                       if (refs > LRU_REFS_REFERENCED || flags & LRU=
_REF_EXEC)
> > > +               if (flags & (LRU_REF_MAPPED | LRU_REF_EXEC | LRU_REF_=
FORCE)) {
> > > +                       if (lru_refs_is_workingset(refs) ||
> > > +                           flags & (LRU_REF_EXEC | LRU_REF_FORCE))
> > >                                 gen =3D max_gen;
> > >                         /* First access only defers eviction of an ol=
d generation */
> > >                         else if (lru_gen_is_old(lruvec, file, old_gen=
))
> > > @@ -931,9 +929,19 @@ void folio_inc_lru_refs(struct folio *folio, uns=
igned int flags)
> > >                         break;
> > >         } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_=
flags));
> > >
> > > -       if (gen !=3D old_gen)
> > > -               lru_gen_update_size(lruvec, folio, old_gen, gen);
> > > -       if (lru_refs_is_active(old_refs) !=3D lru_refs_is_active(refs=
) && old_gen >=3D 0) {
> > > +       if (gen !=3D old_gen) {
> > > +               /*
> > > +                * Gen-index reuse can fool cmpxchg(). Retry lockless=
ly, accepting
> > > +                * an extra reference to avoid folio_activate() laten=
cy.
> > > +                */
> > > +               if (unlikely(READ_ONCE(lrugen->max_seq) !=3D max_seq)=
) {
> > > +                       flags =3D LRU_REF_FORCE;
> > > +                       aged =3D true;
> > > +               }
> > > +               lru_gen_update_size(lruvec, file, folio, old_gen, gen=
);
> > > +       }
> > > +
> > > +       if (lru_refs_is_active(old_refs) !=3D lru_refs_is_active(refs=
) && gen >=3D 0) {
> > >                 enum lru_list lru =3D file * LRU_INACTIVE_FILE;
> > >
> > >                 __update_lru_size(lruvec, lru + lru_refs_is_active(ol=
d_refs),
> > > @@ -941,8 +949,12 @@ void folio_inc_lru_refs(struct folio *folio, uns=
igned int flags)
> > >                 __update_lru_size(lruvec, lru + lru_refs_is_active(re=
fs),
> > >                                   folio_zonenum(folio), nr_pages);
> >
> > Could this leave the parent's local active count too high?
> > Isolation can debit the child's active count after the refs
> > 2 -> 3 CAS. If CSS_DYING is set before the stats update, the credit
> > can go to the parent. On SMP, reparenting can clamp the child's
> > negative local count to zero.
>
> Thanks again for the careful review.
>
> But hmm, I'm not sure what you mean by "too high". Maybe there is a
> temporary skew of counter due to various races, but we are fine with
> that, it will be consistent soon.
>
> The key here is update is gated on gen >=3D 0, and the gen is part of
> the CAS: only a folio that is actually on an MGLRU list has its
> refs-based active/inactive credit already accounted will be recredit
> the counter update here. An isolated folio has no lruvec to attribute
> it to, so nothing will be changed.
>
> And for reparenting, we are also following the ordering in the
> document: the updater holds rcu_read_lock() over the lruvec lookup and
> the counter update, and reparenting waits for a grace period, so
> either the memcg is already dying and we credit the parent, or the
> update lands on the child and is part of what reparenting moves
> afterwards.
>
> So the credit and the reparent move always cover the same folios and
> land on the same side: there is no path where the parent is credited
> for a folio it does not end up owning, and no debit that lands where
> the credit did not. I don't see anything to fix here.

Thanks for explaining, Kairui. I had isolation after the CAS in
mind, before the stats path rechecks CSS_DYING. I'm happy to leave
that for a follow-up.

Here's my tag for 16/17, also sent in the 15/17 thread.

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

