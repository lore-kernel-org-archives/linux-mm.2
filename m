Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E2A3606A33B
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 11:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oD4PgNyl
Received: by kanga.kvack.org (Postfix)
	id 352A56B00EF; Fri, 20 Nov 2026 06:21:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32A4F6B05B0; Fri, 20 Nov 2026 06:21:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F2066B05B1; Fri, 20 Nov 2026 06:21:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E8DC36B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:21:55 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7DAFF1C4A30
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:21:55 +0000 (UTC)
X-FDA: 85455257790.05.7EE5CBD
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf02.hostedemail.com (Postfix) with ESMTP id 92AA780006
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:21:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=oD4PgNyl;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795173713;
	b=CRWTx/qlWA/m8CNYJXt4aSWnLJYvvvB7E4CUuwV7OaCfAVPl7d1QZz4ooCWAuCIhvl1kx1
	N1jCsF/bHk3geRXGx4m5iM4S6TWX4CdRShmV1vvvPd5cwbMSXSgDjaVgoAP3w1ewPnAvuO
	/MM40fkcW/8SMwgBq9k1Vlcbq9rKeJs=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795173713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O0gyuRcS8updM7cyErWfjNuPYzAePnX33DJmz3Z+xgg=;
	b=fWXt+CYOtlwAenRJoeL8lF+qwx8+hksBNwcwAOy/vEj1euvwCFJrt8XEzLXaqntXfVV5jC
	TT6TbR15FxRdg3fFwCBYdY2hSNKzwlULYeJR3V6vdXAvshUmkpzIGzH4utDkztpQAm2Vw1
	pTIN+ysap7NTpR0wCuw5CY5ZLa+77sA=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=oD4PgNyl;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c511cdd5a82so97808066b.3
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 03:21:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795173712; cv=none;
        d=google.com; s=arc-20260327;
        b=XE9NSWOF1qAe8b5xMaHqXFPnRHM3bPQEBzV2bkJtlSBuIPUrIuKYuVrAUjuYJOrSAQ
         yDKqYjVm7f/twJFbrIY/p8OVn9UgTw0B3iMaAWWVRSn20iASWrpsoSJWqnWRzmhgoIoU
         Hm56ctt1wontn/IXzIGAyrtFbvD46/LYYiJRg2g55D6s/laLgbalXGYYVxPLxHAdwUDL
         gsvmloEmzl/kViCdq9JLnwbHf1IzoUyrfwtKE21VB6lNkfAlqcw89HT4KH1r/MRSneOw
         bTKmUFU77Ast7aHuSC+vwakhKbHCY5+auxBCc1bUN9G2QR/Lbz85ccnWDEwJR8NP/T+S
         Zj7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=O0gyuRcS8updM7cyErWfjNuPYzAePnX33DJmz3Z+xgg=;
        fh=T8CZMS7v8hqzytLXYnmzITZSwL7GsHFkUt82dnSnzkQ=;
        b=Y2WIHjpv9ArfiwBwDAXNHUQ9nEMzibXnwOtrRTbG+DB1CPKtQ7/tL2uJhdIDrYvD9c
         SSWeK2kiMk4iadel3q20byS77WRpUp2KYmngQkNxq6LA3RmK7OwwD/sefkhDW468DO67
         hvmUe4hnHjfmjTfqAc/pjEIcYWwRYCnEzgWvEG++3HFRcridiSlZ+FVnjZNLira4UFit
         ri+x1vFZGtPLA/xie4gSQo07GLaX+sPH+JnutJmGe/Wuyk5bqX9tuCAW/PZsP+/54EJf
         z1lphaj6kyPTesnQaET5K/x/hfn/VXtWh6I9By4LxsZymEI4nRs8uJk/lmzFts9CiYvi
         my1w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795173712; x=1795778512; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=O0gyuRcS8updM7cyErWfjNuPYzAePnX33DJmz3Z+xgg=;
        b=oD4PgNylX+Sk7scCmDuyZpibgqIkdaV4D2qEj0U50PDJg7EmNY+Pq4Esz4bCCG3+RX
         U39tZMLop2RbenTLf6XLv8O1sLSgtpILaR1XjCmp/d29Nx7e4tt+YfmxSC4VF/83Sl2Z
         W4Qm0ANwj8QmTjgHB5KbPI1agnbhBr9I07/Y+1XGXZ8vFjfVKnePuGjVutxvpE5J9Ymw
         Jpu6yf5d9xpOaxZ5sAXBYZXV+P3KK7Uwm4w/gBBcJpcoEYwgBwkh+rI8+oE03UV7aiEc
         8YV5kYoA3SCpvEmpGrTvruB8wiM8xL7T0RSvxmlrg/mXlqYpKxmP/QTJOJ8rPWg91d/s
         gD3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795173712; x=1795778512;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O0gyuRcS8updM7cyErWfjNuPYzAePnX33DJmz3Z+xgg=;
        b=yWvmyIXBmnQKrre71Cahg4oWkYkP66ugDe3MBNULDbjjafvnah6iH9UETBuB1jLs+M
         HnMlMrb0zywzIXgUD1f8njV4xLK73vlUr9ccZzWOoODLxzkZsD3PNb1AMQY0r8CeJjID
         9CE/Xyw4ehaUK/HmZDLYEdEpPbGeh+p4MqKIINreTbJ3EiDoS8nSoZRSFaY8CvwwxFXz
         nknolBjXfAWk/SaZQNoVDsHc94TLKQsQ8KdR1m9UCd9wLAWkTuCCPPVaK5SJuNNZQcKj
         rv71tK3m68mAIJhHJp97uzwLxWRw6qaP3P2ofDp9DhXmcM8XcugXOvDsrzeO/7yRxB+K
         Sn/g==
X-Gm-Message-State: APuU4Z8iou5w+JIFP2WDatTIhMti2kg5yShQnlihOO87TL9fxcD6z71m
	m/kHdgPkJtRh0QN2HVbfZE7rKOnVXKggoCteO2ppdUlazcW8Xj3hkfpL97rIEHMYcQSzLYL/v8Q
	l67UbLZV2n97KBn9Su5t4rVOiyfdduE8=
X-Gm-Gg: AYBFou2WR70b6E8Ce6JeVNdhocm/cUMd6ngN8hlO0Mmu0ayMAxbZjvgTznyiywDGFKP
	7aME0xKS8zEoiOFae3S0AVxe0tyZBz6TN/7DsTtFiwj68MmAFXL+7mHLwi3htRlTu8hbtXv1mQv
	0FqMBYMFP0BOdf0l7M9+qg8bjY6wjrw8v2SpmmyvGKWM5doTMlxtxXUD2M23ZuspCUn+VR51SvU
	Sh1nf4qNNMD4AFnc/KI2RtC6VEN/hQ3z0D7IMN5iMy/TKoySz2Oqteq/tLWTXs5J4mSuntxD5S0
	gmWCrK/gSQSKMKhiXr43Jlfm2Bq7v5vw3n+9gcDSmD4L30cN/I3M15z4VYl77smCQd6SN4S+OnC
	h0RgOTCMGXMj7lmNTT7b20eXB3fnA635fttz9sMcNrL4/cvIoU6+7Wwp3/lulwA0vjJSbWaE+jD
	oY/rBXx5eSMrWBlyg=
X-Received: by 2002:a17:907:b053:20b0:c49:8fa2:4a22 with SMTP id
 a640c23a62f3a-c513acaefdfmr195873966b.41.1795173711896; Fri, 20 Nov 2026
 03:21:51 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
 <20261119-mglru-fg-v5-15-9eee2fe97a2d@tencent.com> <CAN_Opa8jGstV=s9S=c842XFJ_H8m5txc6eJDH2AF=KuJSHAe6Q@mail.gmail.com>
In-Reply-To: <CAN_Opa8jGstV=s9S=c842XFJ_H8m5txc6eJDH2AF=KuJSHAe6Q@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 20 Nov 2026 19:21:14 +0800
X-Gm-Features: Aa3M54rMYFW9cBTPV1lgA61bbuCuAwYh6vZiA0Qdy_vRr3vzdcMN80G05Szd5JE
Message-ID: <CAMgjq7C+7=k9f9HVtYn_VwB96TZAJ=D8cbMh0mV7wCsW3m0ZWA@mail.gmail.com>
Subject: Re: [PATCH v5 15/17] mm/mglru: folio LRU refs based active/inactive
 number accounting
To: KunWu Chan <kunwu.chan@gmail.com>
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
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 92AA780006
X-Rspam-User:
X-Stat-Signature: s9wy773i3ffzxy63ykdwoyrz6154bymb
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795173713-246930
X-HE-Meta: U2FsdGVkX19A1fX05zlACtMrJMdKk2pUucClKqvbgo9uHj553rZzYJ521syxT+en68hjcoidl1tSd+qXJBMBvj4Xdr4MbhOBao0HNvVjhpwLOdRKF3c68p6x4pi9HjukNvQpNeSn6n6fZqHP2qiR9lZhtPdyhlC0UmPO4piih4Wpn0+sJzMpJNxAR851fTXRgjj94MnWz/KCRYMGA18JXW3gP3R3Q0Cb911GdgaRSDWaTsCTgJxmdCjgBqKEAPb5MJZHvLu9h9+szqfqzC+ts+9u1BsUS0O4U/LHas0jjoTjkRezgz9orgdrdorajM3cmqsb0vY/F8gMQwbz8nzDBgvBL+WzTlZSFaHz9TDfngCLV++JHhKd3jF9f/qN6nNYH+XymqTOYxJQWp2BBVbSsya9+GpwkLAT/sF7gUmhWP+AQHu4yoa14mXJpiJMfn4bT+S9BlPDRaEgtW11z3e/wSJSoO5fNec04QDzBKo79Go1Pyh6ZOi5kqDl0lGFNkXFi0oNOySVWnTJF/ui/pJ/no57BIxgucA/4YIIuXmHPhP8N8Esc4CL+MgRGxgnXj3bu+FRIcS2N+6f1eX3pMQKui2Jxl7yMzasSBj19H9yUGVGC0HN/+I/B6pOn9zcOFrYo021PMfQT+WerYu+t2fDX8e5JoIdyuuK16Xd/yvCUSueLgg8Zt87fwtLpyQBlvgxv/7NTsgAAHt1aKYrfBZUEp+zDhcoao0W3EImz9TQqa9Wo9rkKJa7CEpxyi3RwmOdUlvLJRkx9GXHilX/6qCu18CBBJ0XEc3OF6ew3JyLBHWRni/kRSczD/Vq5CBQzJJ3MBMuiiTGIMcaLWb0AqgWK0Z/6KU+qsZXyZ+PdfTWJX+cea0a2Khamcw1EU+oEjJZdUdK2OOrq1CWltiHGwlWToYWvu4neuHGzxzHbcMV+/MfI87ZTWbVJYgSHFlk9t5WXtxYZHHc0PrP1u1MePq
 SllhL3i5
 9CUlj6MxYOzac9SqQ9IgtODqp/Lbm0+J3k1C8n8hnG0I1+jky97sXPQvC2KQ9kiYVqn9au6dvUBj8zSVtA5dNzhSvRwBXkSGpNgaLwOodnYy8soTLaf6JGyQS3HPX2GF09bwP/Lt8T3GKkI093hAUJwtHzMC7rqPMuU4zm196gem/LQ3yuOW4MxPQbPCeu/H+Px1Exvi3rbb/lAboGSefaHkq5H5kfpFE6B67XKGCdxcHDAOHQRGDLpZtBEMt6klgqY8id89BG70bcxMofa7SFdoC1iMbORRvb2jBhrP5p88AI6KsU/+bnELM/2g5IdruHuzXeXE77h897TyXvl517IvK+tIARrQmU3NNQqPYHRYsAvoGsWQouXV771Npheuhl4+cXXritEaz0it+U0jmmRHuichg1g0diq3ppsjcxN4P+v4rY7oDK4xwM+Jw4RPNFf+OvRFcjui3xO/6ujJDaceDTK5Ftn1nPm4qk3gpHSUaMcvB0ZQEJrG8M+z5hP2ntRoEF/1Fcj5nDkxG232Dd185ki3KOXhC8E2DnYfXVVFwbCEn8DTZ+vB7E4KYRgEHF6cPIthsZhzE+NMcsT8wyz2W745lyKUMOZemjGDHZSx8NM1Ny5By6zz84EXsDSSc36VSAKJ1BE7WY21UU9Iyx1R/U/cV8EcrF0YF0ZJtHvaa4kUtGUs+1sXhqRIgqlwrPsMNY5w240DB2TCOIkoCEB7/dKcnz6Nc4HHV05aJpF4Zs0nj7NXnnESlNFlBzzTicFhz4jMv3+gpXrWIZOz+Z4c9F7ZK/GmDPOatJBofZh3ncpgGGd2D4rIczs1dWuVTC5r6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 5:30=E2=80=AFPM KunWu Chan <kunwu.chan@gmail.com> w=
rote:
>
> On Thu, Nov 19, 2026 at 5:04=E2=80=AFAM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > Currently the active/inactive LRU sizes exported through /proc/vmstat
> > and memory.stat are derived from the generation window: folios in the
> > two newest generations are accounted as active, the rest as inactive.
> > This causes several problems:
> >
> > - Unmapped file folios can stay in older gens despite repeated use,
> >   so active files can be under-reported, unlike classical LRU.
> >
> > - The reading is jumpy: on aging, the second-newest gen, previously
> >   active, becomes inactive all at once, causing a huge drop of active
> >   folios without any change in use.
> >
> > - The reading is reversed on swapless machines. When swapping is
> >   disabled or unavailable, MGLRU ages anon by moving the gens directly
> >   without walking or touching any folio, to reduce the overhead. So
> >   inactive anon folios can suddenly count as active, or vice versa,
> >   despite no change in their hotness.
> >
> > With frequency guided promotion, hotness is already tracked per folio b=
y
> > its referenced count, so we can do folio level accounting instead: a
> > folio is active once its refs reach LRU_REFS_ACTIVATED (currently
> > LRU_REFS_PROTECTED).
> >
> > On reaching this threshold, folios are accounted to the active part.
> > On forced per-folio aging or PID protection, refs are capped at
> > LRU_REFS_WORKINGSET, dropping active folios to the inactive part.
> > Note that on swapless machines anon refs are not reset by aging (the
> > shortcut skips the per-folio walk), but the counts no longer oscillate
> > as the generation indices wrap.
> >
> > The accounting is now per folio and lruvec independent, so no size
> > adjustment is needed when reparenting a dying memcg: the hierarchical
> > stats keep the counts in the parent automatically.
> >
> > folio_migrate_lru_refs() also gains off-LRU VM_WARN_ON_ONCE checks and
> > __folio_set_lru_refs() warns when the folio is still on an LRU list.
> >
> > The latter uses lru_get_gen_flags(), so that helper now has to move out=
 of
> > the CONFIG_LRU_GEN block and is built with the option off, where
> > LRU_GEN_WIDTH is 0 and LRU_GEN_MASK is zero.  Keep the decoded value in
> > int so the subtraction of the one-off encoding cannot fold to ULONG_MAX
> > before it happens: that is -Woverflow, and fatal with CONFIG_WERROR.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  Documentation/admin-guide/mm/multigen_lru.rst |   4 +-
> >  include/linux/mm_inline.h                     | 118 +++++++-------
> >  include/linux/mmzone.h                        |  23 ++-
> >  mm/folio.c                                    |  39 +----
> >  mm/madvise.c                                  |   2 +-
> >  mm/vmscan.c                                   | 218 +++++++++++++++++-=
--------
> >  mm/workingset.c                               |   2 +-
> >  7 files changed, 230 insertions(+), 176 deletions(-)
> >
> > diff --git a/Documentation/admin-guide/mm/multigen_lru.rst b/Documentat=
ion/admin-guide/mm/multigen_lru.rst
> > index 9cb54b4ff5d9..808d2e97b3f3 100644
> > --- a/Documentation/admin-guide/mm/multigen_lru.rst
> > +++ b/Documentation/admin-guide/mm/multigen_lru.rst
> > @@ -149,8 +149,8 @@ generations less than or equal to ``min_gen_nr``.
> >      ``- memcg_id node_id min_gen_nr [swappiness [nr_to_reclaim]]``
> >
> >  ``min_gen_nr`` should be less than ``max_gen_nr-1``, since
> > -``max_gen_nr`` and ``max_gen_nr-1`` are not fully aged (equivalent to
> > -the active list) and therefore cannot be evicted. ``swappiness``
> > +``max_gen_nr`` and ``max_gen_nr-1`` are not fully aged and therefore
> > +cannot be evicted. ``swappiness``
> >  overrides the default value in ``/proc/sys/vm/swappiness`` and the val=
id
> >  range is [0-200, max], with max being exclusively used for the reclama=
tion
> >  of anonymous memory. ``nr_to_reclaim`` limits the number of pages to e=
vict.
> > diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> > index 14aab2b1ed08..77f514143266 100644
> > --- a/include/linux/mm_inline.h
> > +++ b/include/linux/mm_inline.h
> > @@ -105,6 +105,22 @@ static __always_inline enum lru_list folio_lru_lis=
t(const struct folio *folio)
> >         return lru;
> >  }
> >
> > +/**
> > + * lru_get_gen_flags - Return the LRU generation number from folio fla=
gs.
> > + * @flags: folio flags
> > + *
> > + * Returns: A number between 0 and (MAX_NR_GENS - 1), inclusive. Retur=
ns
> > + * -1 if the flags indicate the folio is off the list (e.g., isolated)=
.
> > + */
> > +static inline int lru_get_gen_flags(unsigned long flags)
> > +{
> > +       int gen =3D (int)((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF);
> > +
> > +       /* The gen is stored offset by one, so zero means off-list */
> > +       VM_WARN_ON_ONCE(gen > MAX_NR_GENS);
> > +       return gen - 1;
> > +}
> > +
> >  #ifdef CONFIG_LRU_GEN
> >
> >  static inline bool lru_gen_switching(void)
> > @@ -168,22 +184,6 @@ static inline void lru_set_gen_flags(unsigned long=
 *flags, int gen)
> >         *flags |=3D (gen + 1UL) << LRU_GEN_PGOFF;
> >  }
> >
> > -/**
> > - * lru_get_gen_flags - Return the LRU generation number from folio fla=
gs.
> > - * @flags: folio flags
> > - *
> > - * Returns: A number between 0 and (MAX_NR_GENS - 1), inclusive. Retur=
ns
> > - * -1 if the flags indicate the folio is off the list (e.g., isolated)=
.
> > - */
> > -static inline int lru_get_gen_flags(unsigned long flags)
> > -{
> > -       int gen =3D ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
> > -
> > -       /* Exclude the legal -1 from the unsigned MAX_NR_GENS compariso=
n */
> > -       VM_WARN_ON_ONCE(gen !=3D -1 && gen >=3D MAX_NR_GENS);
> > -       return gen;
> > -}
> > -
> >  static inline int folio_lru_gen(const struct folio *folio)
> >  {
> >         return lru_get_gen_flags(READ_ONCE(*const_folio_flags(folio, 0)=
));
> > @@ -247,12 +247,21 @@ static inline bool lru_refs_is_workingset(unsigne=
d int refs)
> >         return refs >=3D LRU_REFS_WORKINGSET;
> >  }
> >
> > -static inline void folio_set_lru_refs(struct folio *folio, unsigned in=
t refs)
> > +/**
> > + * __folio_set_lru_refs - Set a folio's LRU refs.
> > + * @folio: the folio
> > + * @refs: the new referenced count (0 .. LRU_REFS_MAX)
> > + *
> > + * Set the folio's LRU refs.  The folio must be off the LRU list (e.g.=
,
> > + * isolated), or use folio_inc_lru_refs or folio_reset_lru_refs instea=
d.
> > + */
> > +static inline void __folio_set_lru_refs(struct folio *folio, unsigned =
int refs)
> >  {
> >         unsigned long new_flags, old_flags =3D READ_ONCE(*folio_flags(f=
olio, 0));
> >
> >         do {
> >                 new_flags =3D old_flags;
> > +               VM_WARN_ON_ONCE(lru_get_gen_flags(old_flags) !=3D -1);
> >                 lru_set_refs_flags(&new_flags, refs);
> >                 if (new_flags =3D=3D old_flags)
> >                         break;
> > @@ -261,12 +270,18 @@ static inline void folio_set_lru_refs(struct foli=
o *folio, unsigned int refs)
> >
> >  #ifdef CONFIG_LRU_GEN
> >  void folio_inc_lru_refs(struct folio *folio, unsigned int flags);
> > +bool folio_reset_lru_refs(struct folio *folio);
> >  #else
> >  static inline void folio_inc_lru_refs(struct folio *folio, unsigned in=
t flags)
> >  {
> >         /* Should not be called with !CONFIG_LRU_GEN */
> >         WARN_ON_ONCE(1);
> >  }
> > +
> > +static inline bool folio_reset_lru_refs(struct folio *folio)
> > +{
> > +       return false;
> > +}
> >  #endif
> >
> >  /**
> > @@ -280,10 +295,18 @@ static inline void folio_inc_lru_refs(struct foli=
o *folio, unsigned int flags)
> >   */
> >  static inline void folio_migrate_lru_refs(struct folio *new, const str=
uct folio *old)
> >  {
> > -       folio_set_lru_refs(new, folio_lru_refs(old));
> > +       VM_WARN_ON_ONCE_FOLIO(folio_test_lru(old), old);
> > +       VM_WARN_ON_ONCE_FOLIO(folio_test_lru(new), new);
> > +       __folio_set_lru_refs(new, folio_lru_refs(old));
> >  }
> >
> >  #ifdef CONFIG_LRU_GEN
> > +static inline bool lru_refs_is_active(unsigned int refs)
> > +{
> > +       VM_WARN_ON_ONCE(refs > LRU_REFS_MAX);
> > +       return refs >=3D LRU_REFS_ACTIVATED;
> > +}
> > +
> >  static inline bool lru_gen_is_old(struct lruvec *lruvec, int type, int=
 gen)
> >  {
> >         unsigned long min_seq =3D READ_ONCE(lruvec->lrugen.min_seq[type=
]);
> > @@ -294,23 +317,12 @@ static inline bool lru_gen_is_old(struct lruvec *=
lruvec, int type, int gen)
> >                gen =3D=3D lru_gen_from_seq(min_seq + 1);
> >  }
> >
> > -static inline bool lru_gen_is_active(const struct lruvec *lruvec, int =
gen)
> > -{
> > -       unsigned long max_seq =3D READ_ONCE(lruvec->lrugen.max_seq);
> > -
> > -       VM_WARN_ON_ONCE(gen >=3D MAX_NR_GENS);
> > -
> > -       /* see the comment on MIN_NR_GENS */
> > -       return gen =3D=3D lru_gen_from_seq(max_seq) || gen =3D=3D lru_g=
en_from_seq(max_seq - 1);
> > -}
> > -
> >  static inline void lru_gen_update_size(struct lruvec *lruvec, struct f=
olio *folio,
> >                                        int old_gen, int new_gen)
> >  {
> >         int type =3D folio_is_file_lru(folio);
> >         int zone =3D folio_zonenum(folio);
> >         int delta =3D folio_nr_pages(folio);
> > -       enum lru_list lru =3D type * LRU_INACTIVE_FILE;
> >         struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> >
> >         VM_WARN_ON_ONCE(old_gen !=3D -1 && old_gen >=3D MAX_NR_GENS);
> > @@ -321,19 +333,6 @@ static inline void lru_gen_update_size(struct lruv=
ec *lruvec, struct folio *foli
> >                 atomic_long_sub(delta, &lrugen->nr_pages[old_gen][type]=
[zone]);
> >         if (new_gen >=3D 0)
> >                 atomic_long_add(delta, &lrugen->nr_pages[new_gen][type]=
[zone]);
> > -
> > -       /* return now if not a promotion */
> > -       if (old_gen < 0 || new_gen < 0)
> > -               return;
> > -
> > -       /* promotion */
> > -       if (!lru_gen_is_active(lruvec, old_gen) && lru_gen_is_active(lr=
uvec, new_gen)) {
> > -               __update_lru_size(lruvec, lru, zone, -delta);
> > -               __update_lru_size(lruvec, lru + LRU_ACTIVE, zone, delta=
);
> > -       }
> > -
> > -       /* demotion requires isolation, e.g., lru_deactivate_fn() */
> > -       VM_WARN_ON_ONCE(lru_gen_is_active(lruvec, old_gen) && !lru_gen_=
is_active(lruvec, new_gen));
> >  }
> >
> >  static inline unsigned long lru_gen_folio_seq(const struct lruvec *lru=
vec,
> > @@ -376,7 +375,8 @@ static inline bool __lru_gen_add_folio(struct lruve=
c *lruvec, struct folio *foli
> >  {
> >         unsigned long seq;
> >         unsigned long flags;
> > -       int gen =3D folio_lru_gen(folio);
> > +       unsigned int refs;
> > +       int gen;
> >         int type =3D folio_is_file_lru(folio);
> >         int zone =3D folio_zonenum(folio);
> >         int delta =3D folio_nr_pages(folio);
> > @@ -384,7 +384,7 @@ static inline bool __lru_gen_add_folio(struct lruve=
c *lruvec, struct folio *foli
> >         struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> >
> >         BUILD_BUG_ON(BIT(LRU_GEN_WIDTH - 1) !=3D MAX_NR_GENS);
> > -       VM_WARN_ON_ONCE_FOLIO(gen !=3D -1, folio);
> > +       VM_WARN_ON_ONCE_FOLIO(folio_lru_gen(folio) !=3D -1, folio);
> >
> >         if (folio_test_unevictable(folio) || !lrugen->enabled)
> >                 return false;
> > @@ -395,10 +395,12 @@ static inline bool __lru_gen_add_folio(struct lru=
vec *lruvec, struct folio *foli
> >         gen =3D lru_gen_from_seq(seq);
> >         flags =3D (gen + 1UL) << LRU_GEN_PGOFF;
> >         /* see the comment on MIN_NR_GENS about PG_active */
> > -       set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK | BIT(PG_acti=
ve), flags);
> > +       flags =3D set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK | B=
IT(PG_active), flags);
> > +       /* use the refs from the atomic snapshot to avoid raced update =
*/
> > +       refs =3D lru_get_refs_flags(flags);
> >
> >         lru_gen_update_size(lruvec, folio, -1, gen);
> > -       if (lru_gen_is_active(lruvec, gen))
> > +       if (lru_refs_is_active(refs))
> >                 lru +=3D LRU_ACTIVE;
> >         __update_lru_size(lruvec, lru, zone, delta);
> >
> > @@ -425,24 +427,33 @@ static inline bool lru_gen_add_rejected_folio(str=
uct lruvec *lruvec, struct foli
> >  static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct fol=
io *folio, bool reclaiming)
> >  {
> >         unsigned long flags;
> > -       int gen =3D folio_lru_gen(folio);
> > +       unsigned int refs;
> > +       int gen;
> >         int zone =3D folio_zonenum(folio);
> >         int delta =3D folio_nr_pages(folio);
> >         enum lru_list lru =3D folio_is_file_lru(folio) * LRU_INACTIVE_F=
ILE;
> > +       unsigned long max_seq =3D READ_ONCE(lruvec->lrugen.max_seq);
> >
> > +       /* Keep LRU_REFS_FLAGS: refs carry access history across isolat=
ion */
> > +       flags =3D set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK, 0)=
;
> > +       gen =3D lru_get_gen_flags(flags);
> > +       refs =3D lru_get_refs_flags(flags);
> >         if (gen < 0)
> >                 return false;
> >
> >         VM_WARN_ON_ONCE_FOLIO(folio_test_active(folio), folio);
> >         VM_WARN_ON_ONCE_FOLIO(folio_test_unevictable(folio), folio);
> >
> > -       /* for folio_migrate_flags() */
> > -       flags =3D !reclaiming && lru_gen_is_active(lruvec, gen) ? BIT(P=
G_active) : 0;
> > -       flags =3D set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK, fl=
ags);
> > -       gen =3D ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
> > +       /*
> > +        * See the comment in lru_gen_folio_seq.  For migration, compac=
tion,
> > +        * or any other isolation of a hot folio, try best to retain it=
s gen
> > +        * info. Ideally we would keep the full gen info.
> > +        */
> > +       if (!reclaiming && ((max_seq - gen) % MAX_NR_GENS) < MIN_NR_GEN=
S)
> > +               folio_set_active(folio);
> >
> >         lru_gen_update_size(lruvec, folio, gen, -1);
> > -       if (lru_gen_is_active(lruvec, gen))
> > +       if (lru_refs_is_active(refs))
> >                 lru +=3D LRU_ACTIVE;
> >         __update_lru_size(lruvec, lru, zone, -delta);
> >         list_del(&folio->lru);
> > @@ -499,6 +510,7 @@ static __always_inline void folio_inc_lru_refs_fast=
(struct folio *folio)
> >                 return;
> >         }
> >
> > +       BUILD_BUG_ON(LRU_REFS_REFERENCED >=3D LRU_REFS_ACTIVATED);
> >         old_flags =3D READ_ONCE(*folio_flags(folio, 0));
> >         do {
> >                 if (lru_get_refs_flags(old_flags))
> > @@ -534,7 +546,7 @@ static inline bool folio_check_lru_refs(const struc=
t folio *folio)
> >  static inline void folio_clear_lru_refs(struct folio *folio)
> >  {
> >         if (lru_gen_enabled())
> > -               folio_set_lru_refs(folio, 0);
> > +               folio_reset_lru_refs(folio);
> >         else
> >                 folio_clear_referenced(folio);
> >  }
>
> Can clear_refs race with disabling MGLRU? Once the static key is
> off, it can drop refs from 3 to 2 on a folio still on a gen list.
> The drain then subtracts it from inactive, though it was counted
> as active.

Thanks for the very careful review!

I think we are fine, folio_reset_lru_refs checks gen >=3D 0 before
touching things, gen >=3D 0 means the folio is manged by MGLRU, right?
The worst could happen is we clear PG_workingset for CLRU, which
really doesn't matter, one metric off by one folio for a very short
period and self healing, not a measurable thing even if you do that on
purpose.

