Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF34DFF8850
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 21:56:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38F706B00BF; Sun, 26 Apr 2026 17:56:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 341936B00C0; Sun, 26 Apr 2026 17:56:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22ED16B00C1; Sun, 26 Apr 2026 17:56:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0F02A6B00BF
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 17:56:30 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 54A3040664
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:56:29 +0000 (UTC)
X-FDA: 84702066498.12.E657668
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 57E6B180008
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:56:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rb6pp9Pn;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777240587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b/4bh3d0BrzlxAP1xgXJclGgo/cRc8lYFiqz3c4325A=;
	b=iVgDN5e5X7AQTIcmLHQ7BReLRpq7PHgCHTmkUGcK3WOsQ/pEEFKg1sI4UExQi3o7o1DkMc
	4NaF4qeLCNjtKWakFhH+oVhdFDwq0kgCIJ9dSwzE1mEDtEhMSOUQ7nuvx+f10GPCOXrfHA
	6LgYcLN80zUCDS7lrqE45B1UeOCSnLY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rb6pp9Pn;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777240587; a=rsa-sha256;
	cv=none;
	b=gl0XZczLgsdxmNFy8VjaA2YSqlSU/GkIgsERvADp42I5qrE+jtIMynXrd4fWzYipQJlcoc
	drx8dPnNvO4qTlX613Yc/k8ZahbFn93xxRSkXRX/ZzyNAROCaWVddvKEHruHYP7YXxr6le
	4JBpxNG8naKwq6STH/Lk4CyGozm6FxM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 83FC360145
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:56:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2619DC2BCB8
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777240586;
	bh=3JGf8IDsc+ZnZfpt9SxIhtAi8SAtRQCJeYwIFta6fvg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=rb6pp9PnB+58SNksFucRDY8QFPsdE5IwfW6vFGkLNEPfv6BUFINhj/M6AsZxrlj0N
	 R+hj4zRS9TMP//a0l17SV7KsAhnJrfRB5YWrDEKsqVo8tgVxNGiLHHJQ1+1iJz+/YK
	 Gp8BRfqouZificc3eSjrxID1+HzoUFEaI3KSzXgMZUmoe8Q2hS9DBHVZOKX8nmdA56
	 kiHINlhb6NVaJb5qwpIE/ZPb5J59SS2//hNMrO0hXuZKlJFx0tEjfaWyQsPblim2Vk
	 iuuWJzE0/Fo3sYm+xu3h3SAv8AIyAQ8Spt09xidn+O0/9TDlCp0MqFSxGVEMgutMUQ
	 /7XB6VNQSeK5g==
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8a0323830beso63869386d6.0
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 14:56:26 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+I35AKASPpe4yj0iXlsGjE1lW7Qp6mWvc4+V/gk/8rTysrGcZcXFt5OMD1i+/yX95LGREaxNV1+g==@kvack.org
X-Gm-Message-State: AOJu0YybP87u6jP87FQt8fA4SGCFrt3b3CeTvpaBzmGJvQHbABXudaM+
	JNgJK+CrIPHjv5UZYIRE6tEMbcQIsJV1JfvZNDGJ/HZVn7hXBaYMleXdbU2/AQ2vI6sdxjBhl9T
	VqT7Yy259z9acVNKqaKxUgGSWceS1Vxc=
X-Received: by 2002:a05:6214:4792:b0:8a5:fced:6af2 with SMTP id
 6a1803df08f44-8b0281eafc4mr596916726d6.38.1777240585371; Sun, 26 Apr 2026
 14:56:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260418120233.7162-1-baohua@kernel.org> <aeuhMZ_uriPEYpAp@linux.dev>
In-Reply-To: <aeuhMZ_uriPEYpAp@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Mon, 27 Apr 2026 05:56:14 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4y1ngpp1S+GnZ=oCASgT7be+5782fcBEEXuWVgfhK9YPw@mail.gmail.com>
X-Gm-Features: AQROBzD9vd9rqSPA0hTUIeZf7Ts2olo971W97vS5LIv52FbfqurVOiyKdk9GA3k
Message-ID: <CAGsJ_4y1ngpp1S+GnZ=oCASgT7be+5782fcBEEXuWVgfhK9YPw@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: Use folio_mark_accessed to replace
 folio_set_active in PF
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Lance Yang <lance.yang@linux.dev>, 
	Xueyuan Chen <xueyuan.chen21@gmail.com>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, wangzicheng <wangzicheng@honor.com>, 
	Suren Baghdasaryan <surenb@google.com>, Lei Liu <liulei.rjpt@vivo.com>, 
	Matthew Wilcox <willy@infradead.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 57E6B180008
X-Stat-Signature: u4rk6mrq3f3f7ma75w5p7cjn8ek57iwc
X-HE-Tag: 1777240587-705553
X-HE-Meta: U2FsdGVkX19r1ZjpPHFFLwU/jXYvqb41lCZoRPCtWbswL1G5WfpqZAv9VoEcacwSqQPdphUUMmm3I+FyB2p7g4hLRWW3ZVvT11g1JSFxuS752m0UBtNDna2DBYdn5iZbpFEpdrWM420Q9XbKUDLt933IYNYG6d5wOC+YtT5V1HdQzX5j/CBWB8LRVuaFsnoQzhXnCEK8aDyyA67AF7v3I3vSvvSfE4Hs4tWFrC5lpye4nEvLzqU1O8qJ+GOQwCqFulXfJbFERLUGNqF+d/q5O8jZBCAgQN1fueqt+UXzNVZrMuec12LeURZqCmPmzGkkgf5V/OhhBp3nc3aVeF2sFiUH07Fh1+lWripYWQEnT9Kea6LhJqvgD3ro7zCRHAZpXl+Oq0T5PQv/Se2b2L1u1lB3vB+2zemetH/sx9M5ocQrHlcSmQF22O0EONF/c/yv+oqClKBKFRIf+WBbES/beyxPxT2QwsKZYXIkqbf9pP7b70oGjllYS6ap9uC2Y/Q0tKRJ5pa8FnwaLDhaRhlTVGjYrX4pLG2aaDwiMJI0ZOykSKmyRnC9N1YJDWOLXUOg3QnpEX1wzKDjvUvgX7LIWBppvmA0mPqDkW/dEtRRl2uORNX8uQpwJlxUmLuSuFJPT2oM+sJpYE9XX3gYPK/9eERblwOKfyVYVcTtlp4XOZs9NCiR3XgiepLXsFYiSW+TURBvr+pzDGSZ0k4i3mdgJLrP8qXne6J8aNYhYw8sv5BcoJt5FJCQoIQurOjZ1Gx8m9tvm5jL7dKIt7bT/+Pa/B9Du9Txr1XIRUaORSk0zZztWg/R2RU50Dz63vExy4KNL7h3N+WJD8BhNSsqRcTS37P0B8JxZxbtV0E9yTx7QRtWHW29Gzx66hrZnqjJXLAr5wOZ61dU/Go8POfarC4bg92LxeL0IOFWBFG9RE7ToLNKaeLUxrURnIFA3b+LwObMFqqExp615Xt8u2x3yls
 RhV7xDMH
 mqOAZr117CaQMQBalj6Oij6bfHc9c9Fwob6X4LyRxmzturuW2KCjfxeQv9ZqP3gSZkryX+iBZYzRUNTffnA/0lsEDFeH6xzvmYMO6h7w2uZ6lYhwTebZw0jxu6aMzdWzpTzpwOCmTPGcDpy4D+vukJCvOk3dv6mIebVkiJGaZwBawInZ9LpDFoCU2P6fDTGIHKiGrxnZW74C+spABYXJzUqy9IRgVyd0QA4vEsF98+ZI62aL0tb85YnXvc+VA/1Vm+ZoJp5azmUqPGk9nZ7aY5AOhCNNn2T2bpL/p0A2CbnTIPXyEwxP7B5329AmdDbaArFaH8dDJxNDaU67J0fQn1nTVFalwCACpUqFyt5VM9ivHs0ugQrsqUTqmxZTGr3LJjPE4espme68boETPiDeQjJUkIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Apr 25, 2026 at 1:03=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Sat, Apr 18, 2026 at 08:02:33PM +0800, Barry Song (Xiaomi) wrote:
> > MGLRU gives high priority to folios mapped in page tables.
> > As a result, folio_set_active() is invoked for all folios
> > read during page faults. In practice, however, readahead
> > can bring in many folios that are never accessed via page
> > tables.
> >
> > A previous attempt by Lei Liu proposed introducing a separate
> > LRU for readahead[1] to make readahead pages easier to reclaim,
> > but that approach is likely over-engineered.
> >
> > Before commit 4d5d14a01e2c ("mm/mglru: rework workingset
> > protection"), folios with PG_active were always placed in
> > the youngest generation, leading to over-protection and
> > increased refaults. After that commit, PG_active folios
> > are placed in the second youngest generation, which is
> > still too optimistic given the presence of readahead. In
> > contrast, the classic active/inactive scheme is more
> > conservative.
> >
> > This patch switches to folio_mark_accessed(). If
> > folio_check_references() later detects referenced PTEs,
> > the folio will be promoted based on the reference flag
> > set by folio_mark_accessed().
> >
>
> There is a following comment and stat update in lru_gen_refault() which i=
s
> referring to setting active bit which this patch is removing.
>
>         /* see folio_add_lru() where folio_set_active() will be called */
>         if (lru_gen_in_fault())
>                 mod_lruvec_state(lruvec, WORKINGSET_ACTIVATE_BASE + type,=
 delta);
>
> Is this still relevant or need changes?

This seems like a very good question. From a counting
perspective, there is no impact =E2=80=94 in MGLRU, no code depends
on the counting to make decisions, so it is fine. However,
it raises the question of whether we should proactively
call folio_set_active() for some refaulted folios.

In the classic active/inactive case, we mark recently
refaulted folios as active. workingset_test_recent()
measures the refault distance. If the distance is less than
workingset_size, we mark the refaulted folio as active
to protect it.

        if (!workingset_test_recent(shadow, file, &workingset, true))
                goto out;

        folio_set_active(folio);
        workingset_age_nonresident(lruvec, nr);
        mod_lruvec_state(lruvec, WORKINGSET_ACTIVATE_BASE + file, nr);

In MGLRU, we compare the current max_seq with the historical
max_seq. If the gap is less than MAX_NR_GENS,
lru_gen_test_recent() considers it recent:

static bool lru_gen_test_recent(void *shadow, struct lruvec **lruvec,
                                unsigned long *token, bool
*workingset, bool file)
{
        int memcg_id;
        unsigned long max_seq;
        struct mem_cgroup *memcg;
        struct pglist_data *pgdat;

        unpack_shadow(shadow, &memcg_id, &pgdat, token, workingset);

        memcg =3D mem_cgroup_from_private_id(memcg_id);
        *lruvec =3D mem_cgroup_lruvec(memcg, pgdat);

        max_seq =3D READ_ONCE((*lruvec)->lrugen.max_seq);
        max_seq &=3D (file ? EVICTION_MASK : EVICTION_MASK_ANON) >>
LRU_REFS_WIDTH;

        return abs_diff(max_seq, *token >> LRU_REFS_WIDTH) < MAX_NR_GENS;
}

But the existing code never marks any folios other than those
read from PF as active. Instead, MGLRU unconditionally treats
PF as important and non-PF as unimportant. That is what we are
addressing in this patch. We do not think PF-read folios are
always important.

Maybe we can test a =E2=80=9Cvery recent=E2=80=9D case to emulate the class=
ic
LRU workingset_test_recent(). Once it is true, we set the
folio to active, regardless of where it originally came from.

lru_gen_test_refault_hot()
{
      ...
      return abs_diff(max_seq, *token >> LRU_REFS_WIDTH) <=3D MIN_NR_GENS;
}

diff --git a/mm/workingset.c b/mm/workingset.c
index 07e6836d0502..aaf873101091 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -319,9 +319,16 @@ static void lru_gen_refault(struct folio *folio,
void *shadow)

        atomic_long_add(delta, &lrugen->refaulted[hist][type][tier]);

-       /* see folio_add_lru() where folio_set_active() will be called */
-       if (lru_gen_in_fault())
-               mod_lruvec_state(lruvec, WORKINGSET_ACTIVATE_BASE +
type, delta);
+       /*
+        * If the folio was evicted within the recent MIN_GENS, it is
+        * considered very hot and should be protected.
+        */
+       if (lru_gen_test_refault_hot(folio)) {
+               folio_set_active(folio);
+               mod_lruvec_state(lruvec,
+                               WORKINGSET_ACTIVATE_BASE + type,
+                               delta);
+       }

        if (workingset) {
                folio_set_workingset(folio);

Maybe this will handle both sys-call folios and PF folios in a more
sensible way, rather than simply treating PF as high priority.

>
> I have not yet dig deeper into the patch and the heuristic. Will do later=
.

Thanks
Barry

