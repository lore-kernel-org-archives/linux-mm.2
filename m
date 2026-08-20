Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD1ACC5DF85
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 03:46:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 878B36B008C; Wed, 19 Aug 2026 23:46:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8297B6B0092; Wed, 19 Aug 2026 23:46:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71E276B0095; Wed, 19 Aug 2026 23:46:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 482D06B008C
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 23:46:39 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CA648120386
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 03:46:38 +0000 (UTC)
X-FDA: 85120260876.28.0E02A3C
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf13.hostedemail.com (Postfix) with ESMTP id F1F4920002
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 03:46:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Xdp+RlEg;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787197596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jC8fCaKvIcrP9K//y/TQg06sbF5Whw3fEjhEvbmxngs=;
	b=2moJhOdPt6l7z+NRskisp3NHIWOGpa68VsRB9vSbXFYqF+MT14Y06regITPqWPk5LQUykL
	MrX9KLojYZ/xKrg1RlpcHo87fT3FXfBu3V82Tslim8If8lO9pUOFe/7EFZYrTYwT9q6WmZ
	qNmiRrXzrii5+3bJxmLpbpUVgUEqv2g=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Xdp+RlEg;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787197597;
	b=cLeHW35WchAwDM3dLM477W0Ey7kaLI3TaNXRHzprBSYgvWCv8+tN2ZDtq66ujEbChkk7Il
	d0I0oYQY97T1AYo/qUrl7UXedXl65KqNDtobeYLeLi4t/osFju83zTONE95IjrMyhLBM7v
	f9lLC2H5HspY6kkuwIH78Fgm5vjIDK0=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c2020421077so290129866b.3
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 20:46:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787197595; cv=none;
        d=google.com; s=arc-20260327;
        b=Uw+08tFZFFxsoC263HqbMyguduL7/uHjgkPHCu+b8cAaZZS845UHCmzRaJG/6YKB16
         JTjbRdptZE26UN+U02PtXMtpl1zkfZ6CJH6Z9y2PxUWeU1zF4kp6ZVPwTJyZtXHv1UVU
         lFNOS+ArYxqZl8nMLULEGYYgwa3S6RYB/RvCwJ+ImRUR7JE44nRg/fEpGITQj4zXQzOM
         WAjuKClvVcyI4pL7U+6N9USmIBZTzCHcwXlEsdXBfo6RzF/Yqdd54orXD1ZKH029iltw
         ULFIGhOk5vYMfUbhZoKuSWA86hatPikn1BPjMUMZs6TilX97N4GMhOQAFbBH+LdvR4/9
         RtnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jC8fCaKvIcrP9K//y/TQg06sbF5Whw3fEjhEvbmxngs=;
        fh=Tegm9b/wb9oeluhlaL11P0PiP4fwGOgkoLy+Bqu40rk=;
        b=qwLCvRoWy0NgSLCkalqCyt5LbUCOzNrZQAAfqY1Izkku8g+ZVAw0C5SM+5aVu2P5xH
         /A2Xnv5JoM85+VZ7V8lkvu1ug27uaa3kYsplnymd0+b+7XxeS/XQYkPI+X7w2jA30bsV
         ezONMHUCTkTr/3W8vCvI5lcRsbq7uCL9oXqehykZkwQqnizcBIGq8goeGdVQm9OlqP36
         lTWdT2DFOcHu4IBaBPPldjKvwtdaju56ifvRyad7gJ6HHf16pjAY3bRFeHS4nlY1ikvh
         kwSRWe88f/cxQN8/qBoIg5g+ysD5+9BtYRPRo/jvg33U95lft09uBtPR7jlESH5ainLo
         p1uA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787197595; x=1787802395; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jC8fCaKvIcrP9K//y/TQg06sbF5Whw3fEjhEvbmxngs=;
        b=Xdp+RlEgK+COokN8qx+ej3d+Q3TKwZJ6PYmpiBeX4ESXqSUuGByHXWIuPks0Zi8PEd
         y8ZzW/W2K++aREi00+mAYwuXxhJeMUpr/yTniBmskEYgWgX65EJ7Y2g1EbV7xmXf00d6
         tQHWjLI3GF8AjvbJaQYrn5nZ8mLWW/XLuzHYIajEYaDeImpjjQILdX+1cohRzCV8FUzv
         +hBdvwUeoAxHSJg5V8pAujyWn1hPbGDK9FCKQO1rvEnvrbqiie4EvrgTKLewtze/udic
         3uGKH1kG3VU00JzNhTnkn8ROoaiEiC5V9gPPKXSzaazUAiVupbCf9omLqAQ/K5gOvLe/
         BVoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787197595; x=1787802395;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jC8fCaKvIcrP9K//y/TQg06sbF5Whw3fEjhEvbmxngs=;
        b=AzHBrnaZBUr65aP40WpksWge+nY0nLTCmXdZNws2fIJTJ8qTv0VE9CH5cLUDdxMfhz
         VN8LZVCO22WGTg159qyliNiZZJTyRnMpg2FEnNwXR1nRP1ENysETDs0hatlYqDi3VN00
         4/oQps0VkPUtypQ8IhOS2CAG+1LCVS4V2xjnmwprVUcibfll3xBENynh8BJiOwD1PCho
         CbgMouIr6kTTqfZO9bR9/Emp2SSErpkS5JCNb8clx528Tyhy9vP8svjHGhL/iXhSq0+K
         hoFtCt8Z15LxvWwP5d+mdg2239lT/7NxLmJftvi5YOfaHcwt87HdU3ZksoavXmSmssWW
         LV2w==
X-Gm-Message-State: AOJu0YzmNl4OoqBXdM/k5W21vB2tt78yjJ6jZqN+JwsYcHdPPUygjP2J
	uhEgxmovjLQcV/Hke3w2h/e0c5A7Da9o1pogL7XDUtYowHi6CgCphC0qUY66leMQ2P/2fR4HaGk
	cFLJgx5r8WMYmDlMaIwTm/qzPL5ACizc=
X-Gm-Gg: AR+sD11rIEPbz3YBn7KyaHjXydbHLfpoEr9kzq8aOIkYqK31amhBiFvjSm1vPoEld3i
	BmTq+p3b2JsYXdgvHnJyp3c3xtn0SAbwDja7HjW4TMrBoTbjEdD1noEy3kUWLyj8kMBM8yFTLHG
	jDjdf5v8bFQQ8LYtywmUaR4I6DFqnl5XyEj5zEK/Jcvs6EgQfSBQF6qLVMs6EhtyIfZ3rmdtncP
	Kip5s2vV3U//hJPlOUlUzYbBxyTOhME6axZOZfYzyZhBvJb2ZocWHrvuBXpmn26TxV1A3UIzGFw
	upEpI7unaCba8XrGMyHZoTf4BuBBLXIR285j4XOjs/WIGa6D8HOBAWT0PcOHSHrk6ALYneUOXBC
	u
X-Received: by 2002:a17:907:3e8a:b0:c20:f871:1018 with SMTP id
 a640c23a62f3a-c242e3f1f87mr631019766b.21.1787197595256; Wed, 19 Aug 2026
 20:46:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
 <20260818-mglru-flags-cleanup-v1-6-8dbbdac0d28c@tencent.com> <5db7dbfe-ec22-4a25-a85d-497e6ed1f8b1@linux.alibaba.com>
In-Reply-To: <5db7dbfe-ec22-4a25-a85d-497e6ed1f8b1@linux.alibaba.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 20 Aug 2026 11:45:57 +0800
X-Gm-Features: AcwNN1XL5ZeMYmgyzc-pNkBGMiqarLr5xzciKiSSwUAgpFOLuAjN7e42AmOrbIA
Message-ID: <CAMgjq7Bz5Kz0YxFcVwbWV4bh_T4qQH0vZYbxFCXDtLzeX5hjtQ@mail.gmail.com>
Subject: Re: [PATCH 6/7] mm/mglru: fix potential generation folio number leak
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Chris Li <chrisl@kernel.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>, 
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 6jpni5izchifu3ijrpo6cjac4ydtxeh1
X-Rspamd-Queue-Id: F1F4920002
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787197596-218036
X-HE-Meta: U2FsdGVkX19Gi0NGHHz3N3M6mmeY5HbyvFGthY8WIHfH0rvMXfWl7o08vIJQwmaYeOm1M9EdrBxjrwleriywUOcZouf9xO9Qg6tzyRCSNiPIe9VMOjA2CH/7qy9dF8IfSg3ch3HHAbLREWlKFWaUbQ2ATLaZU31PBZ1Q59+Bt2n+hmVK1i+ofseCgCXTNkU82Ije0kmRUzN73dAKScwkp8yi/X9WxuB76ekU2e9PFr4xFJXDARvq8z4Tsky4m1CXafvsrY+BHfDMpmHUYlpIPZajR6D19B6GlpPx2EWuIQ6PxNo3TAInL7hdSQ3Q8vKGtiwAc7sMH4m2FS1PaCzwsy9oRnEL1vAsUYVeOwQFGOZX0Jxpf9Y1zSDW2HB/cHWzosf/+LPeLmuOW0/zsXilZLfyRoCL0JOnxfY4Z1V6o03WaXMC6T3Tz6UapxFCIRsXJ302uvYeue2OtYnY/1zR07KBDoAWz/2hCmeYHKrPLGxtjSv3wopR36DvbwENJ9m8plOPNwy5Ae7r/eI0R66vPckCx9pF5qL6KV9YdJQjPvokKxh6ax52SHUNZV1A6NUa1efTyEsZ4s+6FD7JSW/JjbqMYeuOOSylN0twhzkzqbd9HbcOZ+Skm+C2FprEHfzVtQDVbqt2yjz0K9tJuW9nsNFU5nNA8m9GMnjviZEXYoLVnMbOFgjz2p9/ZS1ecO93QgGlvFEsWDrLfxWKgJG3htOv9nb0LAifdHba4/MAEhR4TbLt4eR7dL8nvAuFRDdlPAcMusGMATVljSMw/pLeuOCf+f01a6z2dvFkPVSL38Q0YvaJcF9kHnf2noiOlTdwTJTrfHsQ1UKi4rGwkZ/6274xxBBmqkDBgshCwLmPdBBQzgRlnwsAjVqgx2eiooZTlbIprTLtWNu7n2c4gHsiY/C1hAbdk4+ZGSHzW8DlicMy+895R07Zciw1OHi9jk/9p7+Y98krX53twkac9J4
 PqmFSUV/
 EegeJI3LWpmipkHOjVoBDdQDsEIlZxA0ytEhzNalqXIBTNlPkE2gSojX5Z/oKlKILwAVrJUmWWaxDIANP2qxWYdvCMys3+HRwyIaOixDDJYKkzbbF/UiAJ6OvOhiuRx/sY9RKYcJJiuEjs9gEU+Z6eXzGx/S84E9DiCAMq2GaezlxzWbLIquMzfTKl5XFLkcq+essQu6Y6ty2vkDcBEtyH+NW43FMwhRJKc+DmwEs594d8ThELPkDtJsk785iFnwnxoiBteWXNVbWPpDTaDmtmH85CfFcczJlx9rTeRQzjNzFzlH+0gIjxRPVwyGz5iIgUR8YzrprQoxBUBBiYGewpHVzVYo+QFtK1ICtNeu0xd/8tJmnNzyGUlKulUEGhCBeKfn0HOjjMfjgSoQVJEYsD7lODruAZctRsg/4cA+FfyFGGGzBS4cqJsbkXztJYbqFPc0WkloE2F/DVik=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 20, 2026 at 9:52=E2=80=AFAM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
> On 8/18/26 1:38 PM, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > Each generation of MGLRU accounts anon and file folio numbers
> > separately. The page table walker's update_batch_size() derives the
> > anon / file type of a folio from its current flags, but the page table
> > walk holds neither the lruvec lock nor the folio lock, so the type can
> > change during that period.
>
> Right.
>
> > MADV_FREE's lazyfree path clears PG_swapbacked under the lruvec lock,
> > so the folio is no longer considered on the anon LRU list. Lazyfreed
> > folios can also be changed back to the anon list again. If the flip
> > lands between folio_update_gen()'s cmpxchg and the type read in
> > update_batch_size(), the batched delta pair is applied to the wrong
> > type. The anon and file generation counters then carry phantom deltas
> > that nothing reconciles, permanently skewing lrugen->nr_pages and the
> > reclaim budgets derived from it.
>
> But I think the problem occurs between update_batch_size() and
> sort_folio(). update_batch_size() only updates the anon or file folio
> statistics, while sort_folio() moves promoted folios to the
> corresponding type's list:
>
> /* promoted */
> if (gen !=3D lru_gen_from_seq(lrugen->min_seq[type])) {
>         list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
>         return true;
> }
>
> If the folio's anon/file type changes between these two steps (e.g., a
> lazyfree folio), it would lead to what you described: "The anon and file
> generation counters then carry phantom deltas that nothing reconciles,
> permanently skewing lrugen->nr_pages and the reclaim budgets derived
> from it."

Actually no, the counters follow eventual consistency (note the word
"permanently"), we are fine with a drift as long as it will eventually
be corrected. Lazy promotions creates counter drift from the physical
location, but that is actually fixed by the sort_folio.

Now, for the type issue, use the lazyfree case as example (I think
that's actually the only place,), lru_lazyfree will remove the folio
form lruvec before marking it !PG_swapbacked, so during that removal
period, the gen bits are zero (folio's gen =3D=3D -1), so any lazy
promotion CAS won't touch the counter, and only folio_update_gen will
do it since folio_inc_gen only handles on list folios. The
PG_swapbacked clearing in lazyfree only happens on folio wich has gen
=3D=3D -1 (off-list). And it makes sense since update PG_swapbacked need
to update the counter and move the folio.

And if the CAS happends before the list removal, the list removal, the
folio is on the anon list, so the CAS is moving a folio in the anon
list, folio_update_gen will call update_batch_size asking it to update
the anon counters, we are fine after this commit. (Before this commit,
the CAS is moving a folio in the anon list but update_batch_size may
occur on file coutners). The list removal will update the anon
counter, and the subsequent list addition will account for the right
file counter.

And if the CAS happens after the list add, we are still fine since the
file counter is charged and sees a file type here.

>
> If you agree that this is where the problem lies, I don't see a good way
> to fix it, since the state of a lazyfree folio can change between
> update_batch_size() and sort_folio().

That's the tricky part and I struggled a lot with it since MGLRU-FG
will rely on this kind of lazy promotion very aggressively :)

I plan to do a proper cleanup of MGLRU's gen bits and PG_lru flag, and
introduce a cleaner convention later for all of this, and I think
maybe PG_lru can be merged with the GEN bits. But for now we are still
fine. The CAS change always explicitly checks for gen > 0: so as long
as we don't touch PG_swapbacked for gen >=3D 0 folios, we are fine. So
far every user is following this. We can fix that if an offending user
appears, and it's not hard to add a sanity check to catch
folio_clear/set_swapbacked that happens for gen >=3D 0 folios (maybe
check PG_lru too).

>
> A simple approach would be to skip checking the access flag for lazyfree
> folios during the page table walk, and let shrink_folio_list()
> reactivate accessed lazyfree folios instead. What do you think?

The thing is it can go from !PG_swapbacked to PG_swapbacked, or
PG_swapbacked to !PG_swapbacked. Or maybe lazy free isn't set the
moment you look at it but it got set the next moment?

