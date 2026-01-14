Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3892D38FE6
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 16:19:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 312636B0089; Wed, 14 Jan 2026 11:19:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BD446B008A; Wed, 14 Jan 2026 11:19:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19F266B008C; Wed, 14 Jan 2026 11:19:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 054556B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:19:07 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A760F1B813
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:19:06 +0000 (UTC)
X-FDA: 84331078692.16.1C1AC80
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf19.hostedemail.com (Postfix) with ESMTP id CCDB61A0009
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:19:04 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cM8gXeUF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768407544; a=rsa-sha256;
	cv=none;
	b=Xho215OKJ5evSqbTZ9gLhH7qbZFXSYcTGuMVTA/RQtHJzOj8dTpwnbWcgE/aHmoWif1VIK
	jv0h6VdE8JRWhFtlItiZ4wu5QjFMYHsPtmQMZ4INHn+NUFXQzpJvSg3q9YpNHZJIokJfV6
	urs85I04h72YWhd3c6v4ZBi263sz8Ow=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cM8gXeUF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768407544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=imfPVRl23dlbK6fVFb/rl6IsVwzLYSHlggMP7T9DiFE=;
	b=ax/MOF/eByNyqQcrOSL6vdmjuGoRWFoyd1ouFg09fnJhO+uFuNngT1JZH/rkkAHplRFbvZ
	ZphFmip2KnkxlUayRW85y9oxvY5QbJhBxl/cNtwR98yOcwrmGCqkeLfK74SS5bs/GZX8kW
	Uwhz181bApjFCpeW8JmP9RT4m7NjawY=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-64d0d41404cso14743213a12.0
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:19:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768407543; x=1769012343; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=imfPVRl23dlbK6fVFb/rl6IsVwzLYSHlggMP7T9DiFE=;
        b=cM8gXeUFFUcspS/5qd/CtH16T8492XFCy3kx4c1pSp/oxQdVI8x2QgO7mmtcN7KPvg
         hRqWZKBtO6MW5yPY7+FROBhMyuCf2WaCUN+KhafNyUEJkEfWpt4OjLYavTspi1XZ7JjT
         3SMrHeey5l8voh4HtrRO7JgbvHJkiyqreNXg+QMr7S/USJEYrqKFzGz+soPJ5OBoj3Qp
         7guBTclEy/i1t/4S/TZKybcjpvrJOQaXlLjji38+W5ftliLrcBLXGRkZlZT92NFzoUli
         YCUv9hfmZRphz4xtt+3rb1Ksz4ojBmIOG/GwRiMGHZs+KTWn507qUTxe2nlfsNrJUqO0
         UHAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768407543; x=1769012343;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=imfPVRl23dlbK6fVFb/rl6IsVwzLYSHlggMP7T9DiFE=;
        b=NhjwlDW1xpyqJsmWtz6J6CM74jfgKCX5kNy3M2Xdw0ZRaAbENh68DvGsBuNvrXmL6l
         8tDkkd6zJpU9bGDco6h6iqiSwiUIQ5oHT9vzmrE5bmTwezL5eqM7I8q0ZsIIZ7yxIMam
         +27rOGenBfr1JYCgRh48Fsx0wm7lZ2LfEidC1wu9bgJ6MKJfWcmrBX/MsCUHkE0Rl59M
         kkvZoaeWuV6H/hnp3r/dqjkhpI2+G21mUq3x3BHRCT3dY5GNeXPBE7f1alx0Y/p4ErUS
         a1RYB+C+fOyQZ4w+rcj0kbPvJY3HmI7cHQGPG3hpo/hhwYS1sb0YnzzG8mDMqdOdsouc
         NzQA==
X-Gm-Message-State: AOJu0YxvXjS/HmRFAxwnUcLObuq9jUgnH7geCUNVz+UqC/jqjYHFMWso
	QFo9evTU2z9OGnSyHopzeLbc+AalRqbIwORdq+jip7MD9ZkHp5eLFk7bfTAxkDMSSZMURg5QTTD
	DomevIgzPYI9Ua72Ooqne8I4u9pNLUcQ=
X-Gm-Gg: AY/fxX5+yDrRg4kxqVmNqLeSelZvQa+EuC6tzWEqBRPLFO+HCcaCU6y5trKqHhJn39/
	aSPUhW272YYRb7YgmNgaxJqaq539FotFVFvsB8GlP17EfMw8U2ExQVUIV2Kii3lz6Whn2RRZDTf
	ZNHubA7vwTzZJ2Jkfu+hoSEmoKFsqn87lpmbJGMQZg8pHXrvK+o8B75hKpxO9gVs/IK5qnXpzcY
	/PUeVzqQL63zv1O5/31E44C4Pf1/ojPkFgFYx5tRxH3S1m4a/4zzhiJRRVEghKbVU9BgGjJBI/2
	KX3bW+3N77jzWXgmIcC+oMgne0mqXDGozfH62fI=
X-Received: by 2002:a05:6402:280b:b0:64b:5885:87d6 with SMTP id
 4fb4d7f45d1cf-653ee1b1d0cmr2161521a12.24.1768407543001; Wed, 14 Jan 2026
 08:19:03 -0800 (PST)
MIME-Version: 1.0
References: <20251220-swap-table-p2-v5-14-8862a265a033@tencent.com> <20260114121654.1029110-1-clm@meta.com>
In-Reply-To: <20260114121654.1029110-1-clm@meta.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 15 Jan 2026 00:18:26 +0800
X-Gm-Features: AZwV_Qj7CkE3W5Y2qsTkRXTs8xTCI3Xbf6SrqUTC_RmOckdRx5H-rx9OxiObNig
Message-ID: <CAMgjq7BKgke-E=2GTvd8eFgkZ2YguogKFVFfBhvd21_t+eY+UA@mail.gmail.com>
Subject: Re: [PATCH v5 14/19] mm, swap: cleanup swap entry management workflow
To: Chris Mason <clm@meta.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Youngjun Park <youngjun.park@lge.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org, 
	linux-pm@vger.kernel.org, "Rafael J. Wysocki (Intel)" <rafael@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: CCDB61A0009
X-Rspamd-Server: rspam06
X-Stat-Signature: 9qp5pof53piy5n9696jobg3619srdtjf
X-Rspam-User: 
X-HE-Tag: 1768407544-711702
X-HE-Meta: U2FsdGVkX19RBvzNhKTLRryesanRazjTyNyGZ/mdNp+Wzqh9bYs/YDme1HwsfKZh5ArSLnaU2RFN/FNi5/EF1yKfnwOkfbPwtUYqT5rq1RHfHh7qIas5i/EsTjjcYHIFIRLhLgEnV3CzxxgpkhedcAj6jU75Rt0t2zRegxPZkYjeib9Wlr2pjlxXwiEf5D/on+dnV06XaScWovG8W8V27OxUIgW5BcOl7F8nfwyyikPcVZAXlR/g4ATiTiWghbQ3XPb880mFcveL6QCVYP5XNIje+uNfLXqPdGUcNnA1WEQ7C/lOcwIAGVOYTim9TtEW9GvvyQblHkdJG/nF2XhyCZGsxfWKTHRUfXPaiUUCsQq0E0YNLyD9LI3qPEKW+BcChzCpkEo0DkZfx1W8sGUGsIIteZwRG9fQawY33H6pM5uyKwZflFFAiJJ8Wq2t/40sgY5TUFePYCujmuUn8aeRUuXG0TRkuLRAaTFjSDxQy8xJ69+ZSpFTY3iMnxb4d3PpbD1kGmmejNPDVUMmjLtKUc0Ok4Qh1ExbeNogMtnTtXGpHtK4K+xXGnfjxSnJkq+C+9uumkkiSYxv2Zx7EbHDecLIqEQfxyO+kEJ5if8Ck92tvWl9ubUXiBpDy54tsaQqXJfAtl5K8jUcM1B/BlytRq/u/0Yw78ICvuft9gqqd+ofNTdR2FBpShOrt0C2iveU8PhiAyj2U8gpIr22BtovAhmEEUvk7ZmZlmS9fN6MrE4xK1607gOF7Ov6xgCpDbNQIwua9qwEZtxwe4hOhLHtdQqLbhvQZogzTuIkqkHS83dzNQ9VGEwvbd+dywAgdlAd529Wtvcop+ar7IERqVIF1NavjfZGzthgz5ki0EChflSfahSv/FpdR2CLcHeHFhPNqmIVE+3feyP1cZc7e0012RuaqQflvQHIMGCfdFSKY6KpRNGwM/xKgcUwG2JodAXcnz2s5gaeaSoaoL2zsrN
 aMEeF/Sk
 VLfjIhgmWWel8FdzIr+Ci0d/ErmVlEGufo1Vh8O4jJpoqSHUdqd7bKafa/bVpNQQHMzp6soTw8Fj9jbBxaZ/gVXfdmtGJVHgc1SOGOo0QhHEE23YnNmDPqEp6lVG7ELXBxbYS+3E0uhgpzmfnv3t0gL82U5NXjO7uU8hHqcRAdnSjcAtABghc70+XKkDitGngVs39T02lO+Ia09VT+F8EabUJbsmaZPE+CaLiB15Fc5nk2UNMg8GzMsVdFHPlimhOutLnPRjgaGE0amUPb0T0v2UlioEHz4slMMmfoGpVTfT/vm799didMyhDIK0olEkEPmsF8dB4dOAre4ALu8VGJrVVhVe2ZnQyzDOUcGpm9OVADs1EffymrycwTQxYRHV94HBrFIa5qf9YIxeFVaOi9YnTwGmIUgksL1NNaP2KlOhLaCLnnUw+yWa65MJlrfciVthihcVpwmNr3HVOAKA3ojBKoN3YEIB0brwYG/TxBSZkL4ucI3+k3xyXobEGyf5LHUcnikHTh9At4wyW1zSWmg+0Pw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 8:17=E2=80=AFPM Chris Mason <clm@meta.com> wrote:
>
> On Sat, 20 Dec 2025 03:43:43 +0800 Kairui Song <ryncsn@gmail.com> wrote:
>
> Hi everyone,
>
> I ran mm-new through the AI review prompts, and this one was flagged:
>
> > diff --git a/kernel/power/swap.c b/kernel/power/swap.c
> > index 8050e51828351..036489d3b01a9 100644
> > --- a/kernel/power/swap.c
> > +++ b/kernel/power/swap.c
>
> [ ... ]
>
> > @@ -186,6 +186,7 @@ sector_t alloc_swapdev_block(int swap)
> >
> >  void free_all_swap_pages(int swap)
> >  {
> > +     unsigned long offset;
> >       struct rb_node *node;
> >
> >       /*
> > @@ -197,8 +198,9 @@ void free_all_swap_pages(int swap)
> >
> >               ext =3D rb_entry(node, struct swsusp_extent, node);
> >               rb_erase(node, &swsusp_extents);
> > -             swap_free_nr(swp_entry(swap, ext->start),
> > -                          ext->end - ext->start + 1);
> > +
> > +             for (offset =3D ext->start; offset < ext->end; offset++)
> > +                     swap_free_hibernation_slot(swp_entry(swap, offset=
));
>                                            ^^^^^^^^^^^
>
> Is this loop missing the final slot at ext->end?
>
> The old code freed (ext->end - ext->start + 1) entries, which is the
> inclusive range [ext->start, ext->end]. Looking at swsusp_extents_insert(=
),
> when a single slot is inserted it sets ext->start =3D ext->end =3D offset=
, and
> merging extends the range by incrementing ext->end or decrementing
> ext->start. This means ext->end is inclusive.
>
> The new loop uses "offset < ext->end" which iterates [ext->start, ext->en=
d),
> missing the slot at ext->end. Should this be "offset <=3D ext->end" inste=
ad?

Wow, nice catch. Indeed that would be one swap leak for each
hibernation snapshot release I think. I only tested normal
hibernations, didn't realize there is issue with the "release before
use" path. `offset <=3D ext->end` is the right one here.

