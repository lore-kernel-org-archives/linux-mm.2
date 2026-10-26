Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30FA5606A31D
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 13:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=UuBOkFgs
Received: by kanga.kvack.org (Postfix)
	id 52E706B05B1; Mon, 26 Oct 2026 09:24:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DE6E6B05B3; Mon, 26 Oct 2026 09:24:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A6586B05B7; Mon, 26 Oct 2026 09:24:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 15AFB6B05B1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:24:43 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 261F5C06ED
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:24:41 +0000 (UTC)
X-FDA: 85364847162.23.2A2D07E
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf28.hostedemail.com (Postfix) with ESMTP id 34211C0002
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:24:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UuBOkFgs;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793021079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1akx8mxhc3uRZxvnnRf5cLwnJZH5AVzhLNQJJ8zSIso=;
	b=0mZjNsvEQy4QSPuIWOoE6A2wea/BMScjQEazJkqU7BWbV3qTiD9wZojnlxrTeZUx41mCWF
	wMSPwhycCVD7Ancuywon4UfOXESL/ywueTaKiKqkXE89ypkkOBIHsmd56Wf5qpTYexPjli
	JGMg4S+p3SpWMLw/o5qXPD3EQahEoxg=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UuBOkFgs;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793021079;
	b=wSZZB4jUWB2bZMWdTcU1dHt/EsRX1oesQKF+GP31WLxH+xkYrz5/Ug8DrKhiX+oKxHfVcr
	UmCeR+ZXPn4XtBqmAJJtXzcFxsjAVqElaRBuSCBPw72fudj/TQOwncBZU3hDQTSNkD2p+H
	7lttmRVvMTvk7aq49GekvKuFnMj3JW0=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6ae14eecc64so3989587a12.1
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 06:24:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793021077; cv=none;
        d=google.com; s=arc-20260327;
        b=dm3QBxoiQa5vqP1BG0hfmzUxZmY1tm85cIfLsH/SyCr9zT80/rVKuHdftOEm+6obrg
         Nvtb+ADo9AxNbGsN0rAyYUPARkbEdaK1ralej2Ej6pjsVSFagoHc8dLVi1VhaepC0zp1
         4kY6mGDtbdp+W/nJZgZg1loscm4HGri+PS65fDca9/t9fFUhRsRhfb/bssyoEMcVQgmY
         7bKHmGE1CMoqRMUB0y3sZA+Mm7JSRf6TuMC6Q6dovrKn0BQt96Wg4XcE3rPuoXEy71w8
         bgbZxxZKLcmCZnnpnTWB992mPhRFJHwAVUmtB4YXes4pk5Fqw67O0sXNQW6Evr7uYC0f
         zKFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1akx8mxhc3uRZxvnnRf5cLwnJZH5AVzhLNQJJ8zSIso=;
        fh=1KJHh9zZQvlDxXebCmvy6Hx4Pr3UYZSzmXGC3+lhuvo=;
        b=Gg0Ykpm1MqQDrjZ6WD0dhvfkxYmhRv76GXegoIqxOAWjUHo57QSYGELHlk/atFNjqY
         KSYe7tfM9+JZCnLVKfJi/cbEmDCLvrQxfSuMVEt54sy8f//x/DzDbbc19HWBj2GMgdfW
         WwO8kX31qyCnrxsxi3czVmTm5FgUtOKGwmM5Eui6RZlUHsDjX+sbrL77qnc8/WsX1Sy2
         +OJp7SBBKQZASjlLu4pcjwQecM6ltSsscSP7uZkERGXNuBDNUtJFNnGjVVwjoOw8kSG5
         zcZt1HwIiBXiyj19ihI6B9XUPhL4CcjgHCzcUxlyTDGjTyFfzlXAPJ6zxkQWcGIt7Sgq
         hy0w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793021077; x=1793625877; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1akx8mxhc3uRZxvnnRf5cLwnJZH5AVzhLNQJJ8zSIso=;
        b=UuBOkFgs6QfwzCB4HTLBQwl3f0R3RbuZlDlv9mLqZUAneXUEidK0XOtvwziJi/+Yye
         gij+SCey70RekCxjVg6OhbxB0wcsAXQDgES4hjPWCstg6brFFrVhgxKeNILHP47V4Egz
         qlNZy/5mVphmPBVh3TuhdmOhPRaNepAzdEVPNvaJla9WqvhaIJxLxfRsscUsCUaLEunk
         J9hkdSVUZ1E2UMrlo8ddyNsVXBtR26yUmpAdLbtGTahO3HKeDmnGRCknyYyHKlRVYhtK
         nteapWP6zwJWCGceu1Zz4VN+7KqurpZ4qziPzeF6YsE0gU6Xn8NayJYrjr1MOGt8g9GL
         xLpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793021077; x=1793625877;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1akx8mxhc3uRZxvnnRf5cLwnJZH5AVzhLNQJJ8zSIso=;
        b=G4EVGqGAAK63Hx01j64RV0h94se3RDvn/ckEbjPGANxPth27WPHM1DlAA4YpWwiIZr
         5Zs69JsAk5vZV54qxM9izKV0BvhezWqf36qZB1/0lDZ31SJ2SDIZq9hS+xDXL3KP+ucR
         4teY+SWoCZyhMIBhfJuc1eWPtqiay6/nAKMqeJGRIuBPTCor4aYdqSizZfm6ZhUgiWI9
         LSIsbNqAZIBc+aOGAF5jz6dgAGvcWUdllgvTviVjRSXtRV7TIaw1AF+s1HKu3/u9rj+7
         hmRnM+Oo0mJfHeTwfljeFKGmqbqIeolmIkW4aepVj+1PAfQuyTgtbQjYxZUUJWAi40oB
         IBcQ==
X-Forwarded-Encrypted: i=1; AKwUvBzkgehW582royzLd6PxO1qVJEwdQQ/dGkrO1JgS367Ij/xhsMZuqsLrtFWOuscfRdZn3eugiGzbxQ==@kvack.org
X-Gm-Message-State: AFq9FYKtPKlQxOlu92Hhdf+0eQh9vfqS5oa3Td2vSfEL4BZ71P7ksmto
	fWm8sek2Hufv0y5QADmESwlbPF2R7Qi6KEhPAeI3GGwLDyyPCwh4aa3kEl/Znv5e6xyIG/XPByI
	/3v4v8JDdfkLA/HF6hHipvwkMoZN0IXE=
X-Gm-Gg: AYBFou2x/kDpPXq9xFs1uXBEHipSZv2l+H342Q0YwvmKmApRyyBxo19so7r5v7WgWo9
	AOt6T5tp36MRdsbztzcLIsCfSPO0mBqanuh9zp8B5+BpRXrgyx0aac5txNDGJoq+KKECotbgPNF
	I8Q8Pc4FVqHPYzC1OcEK1mjoTfMRF+GboTxVRYu/AxRDPbazr8NIS4BG1S5TLx7V3NAhVyBu+OI
	dRcFlJFOizkJRks+WLEYF8qssz7ETdTBuDr40EO5DZv/LPhGfS19xwjB5m0qa9+tC+VgsKrGiBg
	GHZ4svYHpEmxp2Rutm8+JNQQSvWHcHJsEoMpwo65LBg1PER1dCOiUhqYsJjy81Ul0oSW/oa/e3D
	aMNGQpVHxu3rsdhtixSqLMcpOVK2ShczYrk5vlqYbO8ttqnKzv8sRdAMFW9YOgaf/Gu7q8g==
X-Received: by 2002:a17:907:3e07:b0:c27:420b:7c79 with SMTP id
 a640c23a62f3a-c46bdec7fa6mr869390566b.48.1793021077106; Mon, 26 Oct 2026
 06:24:37 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
In-Reply-To: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 26 Oct 2026 21:23:59 +0800
X-Gm-Features: AclHuK_NnGMoCvEgkVlwGinh-S4Fg9jmm7mGH3lQNtt4b6ijBwpE8tzVis4U-Rg
Message-ID: <CAMgjq7B19MT6t3-BisvQ_V8xoxkZyQXHXNH457UT98kwzVMGKg@mail.gmail.com>
Subject: Re: [PATCH 00/16] mm/shmem: various (urgent?) fixes
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>, 
	Hugh Dickins <hughd@google.com>, Lukas Czerner <lczerner@redhat.com>, 
	Carlos Maiolino <cmaiolino@redhat.com>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Stevens <stevensd@chromium.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	William Kucharski <william.kucharski@oracle.com>, Chris Li <chrisl@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Chris Mason <mason@kernel.org>, stable@vger.kernel.org, 
	Josef Bacik <josef@toxicpanda.com>, Eva Kurchatova <eva.kurchatova@virtuozzo.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 34211C0002
X-Stat-Signature: 6zokbsbfeu87666niztwkthctb3ugmuc
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793021079-482395
X-HE-Meta: U2FsdGVkX1+oxYIRhXQ6FxwKWH8A6+zyHw6PeFZg0Tuy8GBrd8vM3/Yy4egI7GTQKkHtF+WInjWnB33YF6xL6+NPZZgtvtwPAUpmqlmivOcf2rxRJsDGl1ADExwyBQXfu2TKj2EPeqxtO8GyLPxEIlrphfEumd4B7U2tALuXJRKk41PYpBgrTHmy0dsIigsvunYwCnyzXUDO2WsXiJ3Ygf3dyKeDBPBR/ADAGc35eJxuqtYVD7FqnqjtonFyUVW9urNdaaZQCmx8lDZvye/nkSbrcqvo3J9MMETrwX9hKofW/EMwb2J6CqxbeaxOZQ5emINRNrmVJqZ7I5LlTmTheUQ5ME3ZdaDaDp4QNGk0eZoHSANc2GKaX2E+oVwTdarMitYAwkW+xWCs2bjaMroRuqmolLiH4u4YbRoXRjFG2vMELtKkuWyvb6fkh3YrFpG3PJNiHVqnWDrrVXEZm4+U4UfNUJvLlT0zeXT1G50iFaYBy8FXtgu6LUzufIjOVg5u7mllPz7Wjuw1bg1TlwW4BlKnOkunkatpk5NC0BKBq9XTxdQj4LBZLO3JUvFxHApxFcFkRc0oCszfWqeNrTVGj+MI2fA/T1RWNAwt80/9KYyZTGNEaXMU73Lhn0TuVA1dxzypRFQ7Sa3lYq0C3X/6T3M6SNsPFx2bApYxevFowNAwVFK7vSTx4442WfNk8XodXq805xbXPZYYTYsAEjIIedupSuVZZKAnA35oc/Kfs3w90JeKiqsjlC+FTy2c+c4PVND63zcFa6WYq870S+bDNjHywBpz67vM5asqTbKbF2W6TLUbYTYgGfTiXv8wNaqy3NhJj55PyyeK99FIGJ4hPak0gLg40V9iljuXFcNv5LBoEmvJhhQGznhGlcSbcuq+JPYNegHELx0x+ShVOsvXnm3Kf6nZKYozOIgkyb+BcLLIzDxl55u221AH4iI/C2WjnwwvxdRJB7T48K3gmca
 EEYh9LOP
 3wE0hKTxRv/JhZYO3j+IRNgigjwG37Bqsz8zgX5eRYE9na2V6vKRedDFlA4bzgl/4xSNHynKqZK7wLLfWTkr0iN12p4XppUpSYuZpDyfZs/JVYmv415DVLkupnmvHbdA9gZLd3+N9jpI9TiwxtP3dHEn6AoUIv6xVJPYgdP6rCN2jlJLN2NWjwYhtrKrsqmwwkBGXifaIOFU7WsH5GBKhLw8OqCVzlLoOIACbIFCrLcRSiai7Z4LBKGJ+minsavwnPGj+NgH70IMc/jGiga2VQf/WD1CnWzt5UwOUeYeL0I48NLl+vIXMtQHxuSY4ZbiloypNGw7d0aww8x8vbBCdxHRTZzVrTiIrrSglpA8fQLX2/EsbCLh5/B9h7LwfghrYAxvV5KTeBU5ls4/BZkp7ggpccAW5gd4dybjM/8YYQ0TPUfNNRm4ejzK9zndOen/jxWoJbBVUvjQhQz3P2qID3kSRTspDA8a7+MQ9K8rtrntJGoERKrMOQNKzwzTEee8IVqbCC79jA/RboJ529wJkm/v/UgTFkNj0+tXi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 5:44=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> Hi,
>
> the fixing fun continues.
>
> This is a handful of fixes for shmem/tmpfs. I sneaked in a related
> hugetlb fix that stalled upstream.
>
> Some of the stuff is more urgent (patch #1, F_SEAL_EXEC, truncation
> hangs), others are less urgent but still rather unpleasant.
>
> The majority are fixes from Anthropic that I cleaned up or reworked.
> While doing that, I found a bunch of other issues and tried to fix them
> somewhat cleanly.
>
> In general, shmem + swap handling is a nightmare. shmem_undo_range() is
> such utter garbage it makes me want to cry. I mean, really, WTF did we
> end up creating there. Does any expert here have time to clean that up an=
d
> make it *actually* maintainable.

I had a nightmare understanding what is going on there when I was
trying to fix a few swap related bug... :P, and hesitated to clean it
up... I think we will have a cleaner codebase on this part soon as
Baolin is working on this.

> The following things are still broken in shmem_undo_range():
>
> (1) Truncate/punch of a single page of a large swap-error marker
>
> We don't split. Consequently, read access afterwards will still fail
> instead of returning 0s.
>
> I have a fix to try to split (which can fail), but I don't consider it
> that urgent, really. So I'm not including it. Might send it later
> separately.
>
> Truncate/punch of a partial page can obviously never do the right thing,
> as we cannot poison parts of pages ...
>
> (2) Truncate/punch whole pages within part of a large swap entry
>
> We try to read the entry, but if we are out of memory that might fail.
> Consequently, we will not free up swap space and a re-read will not give
> us 0s but the previous content.
>
> AI proposed a nasty NOFAIL patch which has too many nasty side effects
> IMHO (allowing users to force-read pages and retain them afterwards even
> though memory.max would disallow it). This needs a proper thought. Likely=
,
> support for splitting large swap entries (and large folios in the
> swapcache, which I recall is under development  by Kairui). But splitting
> can fail ...

Right, will post something on that swap cache splitting part soon,
what I found tricky afterward is lazy reclaim of swap cache so I think
a bit further clean up of THP splitting is needed first for better
swap cache splitting.

For shmem side, we don't have to swap in at all when truncating
page-sized holes for large swap entry. There is nothing complex from
swap side, just lock the cluster, then put/free these sub-entries, and
everything is good. It has to do a swapin for shmem right now just to
make the shmem part easier to reuse the folio entry split code and
better synchronize, IIUC. Nothing is blocking this except that we
better cleanup for the large shmem entry splitting code too?

> (3) Truncate/punch of a part of a base-page swap entry
>
> We obviously have to read the page in, in order to 0-out the parts to
> discard. That might obviously fail.
>
> Maybe we should install swapin-error markers if swapping during
> truncate/punchhole fails, to at least tell user space on later access
> that something went wrong? We might affect unrelated data, outside the
> requested range, though. Anyhow, these are long standing issues and
> I don't consider them urgent.
>
> They need a proper solution.

This part is tricky though... perhaps swap side needs to provide some
helpers to trim sub-page sized content on the backend (not sure). If
that's too complex maybe limiting the trim window to just 1 page a
time won't be too ugly?

