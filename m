Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1673606A332
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 03:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=X8Af7/dP
Received: by kanga.kvack.org (Postfix)
	id 816C66B05B3; Sun, 15 Nov 2026 22:52:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C7EF6B05B4; Sun, 15 Nov 2026 22:52:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 691AB6B05B5; Sun, 15 Nov 2026 22:52:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 23A556B05B3
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 22:52:03 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 91882408BC
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:52:02 +0000 (UTC)
X-FDA: 85439608884.21.0F89C31
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf27.hostedemail.com (Postfix) with ESMTP id AFF6E40003
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:52:00 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="X8Af7/dP";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794801120;
	b=X0u3761jJCuYa4fn+v1eK5WvK3zimXXT9EMMZ+mjYBL5l099gjF9eW/2FHCeAZMOdkhGhq
	+Qg5MwhFb/myOL+g8vpPDjjWhhIM8aP/7n6mrYdC5Lc1aSCNJfYq7PEZvRDj1uF26ROY/I
	k5tkeN8FHM/t0mQ1+b+FbvoXXAo9qHc=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794801120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mHMeLHBcjlpdKQvivDV94WV6xZA1r0k1UiU5sTtS58g=;
	b=cU+vWHNTNB5rGtXFKbrAZqIl+BP6uH6xfkbjUF4jFguP/4c3lYG42ZODw7m3StTWhsiSuC
	0Ct/pmQLsVfVJURXvymEX9/2AbVaXVFTufpdMUqzs33GM9g3jOvbINmSLmWy9Ap9d1lKAE
	LF9Zx3MgROHFgqLo9GGyy1GRocqTMuA=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="X8Af7/dP";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c50cc8e0f84so106556766b.1
        for <linux-mm@kvack.org>; Sun, 15 Nov 2026 19:52:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794801119; cv=none;
        d=google.com; s=arc-20260327;
        b=aEXH1x7308rk5zywtkpGAzOmCFOdvurPJwHAgaItlu/mkWR7G0oCz3+4N1m3F9Uzd7
         LZfKh8sFYetffUGSEcM7H6Ehy0RPIz5VMAwMmFBUgzbioJwza86UX/5hHWLgtpP/Fstc
         NmMDo9+brU7FBM5f+zmN8yYX0FYEQ52KjHhy4PM9486Zp15e0OoO9fGiYU2nRemVlJHb
         cpE0LjQniq+TUz6+hJYaIC7dCM33k3vWy5GYK1oVSHZ9PMJLEXrq6ysEpnaOpUah67z9
         dYREKgiyPkyHuk88mRbDW+f0TZ8ZUFVsB7AQIORBrgHRJgMNPtuGGSp8fe1/Q6NN9L92
         Xa9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mHMeLHBcjlpdKQvivDV94WV6xZA1r0k1UiU5sTtS58g=;
        fh=fSnpxyQFzYBuLIUxwelhy4CB2h483iJp3FJ3zS0Haxs=;
        b=DFFZ/GA6uu7vBVd09l4vJkdPeJ2/UsBgagTfWj/hwpLwSbpE1JvCrMxnsDb5XtzaEF
         aP13qAcex0qWFzsLAm2ESt0amY7ym7EZYOL7nAnocudYHroFuY5h91dcdhSqABeZOewn
         Nl7JIv1Nyj1C0dQjxtf5r9uu4ic4vT27iq4HBviMua0lliF0jub80yUf4MHbuO1MkpSB
         m1PKRbAP1jiRT3SLxGEpRZNZgxIpehLMJepI//oHS6pUCC/fUTYTRGDnubh4/jLfEYlP
         3cQWYZxyvOsdyYwHFpCElNuaMiRTHl1lkpvAB5o8gx20CYgGBV9xUgaRr3xkDdHxMQr9
         FQEA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794801119; x=1795405919; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mHMeLHBcjlpdKQvivDV94WV6xZA1r0k1UiU5sTtS58g=;
        b=X8Af7/dPBdEWeZhx+Iiag8AI3fxTjFXXUIpMyEQJ1/iR79wjhqhdbzWWicBuHXgu8x
         ltkTorJXg9bwPma3+aLz1WLIiq1W+NY8c0g69hYqQf0Tzt+fIgpqVLQpMW57AK3dUZL5
         5+gG9X+V8Ft0fn1HosppoTFjZeLhu1554uW5ule/4WpYpHVGonWbq+xqfsYhupG0Qp7Z
         OWru6wvBtK7MXiecthjDM3tTZ7Nw/A6gAAEQV/m0TfVZ1ypqnOcQCfpwgAIsb/JmZHS4
         a7YBjjaFIvocpWE8UR5KMz0/wKbxKcDX7pnDrghXDz5HG0woqVqlK2zJe8sREAEx4bE8
         M5/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794801119; x=1795405919;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mHMeLHBcjlpdKQvivDV94WV6xZA1r0k1UiU5sTtS58g=;
        b=I8HlbIr4ynKXrnxBRhBxZowHZWhDARY+uImPmZFBkvy8iV4Y58QzHk8E0OEe3krkxe
         rbb+uMb1uBt5RmuuaGJyHDkoigXqAyBg0Wr6TS/yPhxXLW/WL/W+qAwJzkenEIkZwkLm
         Rhb+UwigiR+CC7dCNBwL/71jxNdKTTsJap6cpe/RYgktp99O2Sbg/ThYuwq751rrz1KB
         zCD2yZYBkV/teCOSCeShYGvuhWYB1ELDd98uaaTj1rfiZKRb8gyZOuU8++2Y3nGmpVwI
         3HNiHeEP1J3ectgPSFe0zvKyZoEfvZf34NlnvJC/C/pxKGfcgPP66EWWZqGvoFV/fSc9
         Ui2w==
X-Gm-Message-State: APuU4Z+63os3HcAZp+lbm8sg7vH2M69F8Juw9C4YVYFi7MlsDPrnTV++
	1/jM8k7JJ2x1i7aKs0bJfmGLgGSuJ/HuQ8fOJEFwZgRDoV4RyVfFnljVklI6d2sAXiylsa7iTMu
	XOB6MPusMmUzXEyHKq50LzCvTicSE3mo=
X-Gm-Gg: AYBFou1UFcbxxIuGIkTT+ZOzI9Vna9Ogw70FzLTeRPGzZi0tq4Hks6mPiGjDm2BF5Ia
	8YUU76DX6cDRNTXMcOO9AcJY50iMWaTa+MX+gVWfbdZbkePSF17kWIKXFirZjytIj2/nG/ZRkVm
	3bsKuptGnYai/8J2E7W9tLWuGSIwKTOVZ1RuRp1ADj4AhFU1j7MYZcAwEGZlA29bEHBYza7iKG5
	rMnl4MBKO8YHoFyTObAIz40+xokyHlvYXLwQyZaELz0l9tvshX074Sw+DN0CJruNf3XctrKrkJC
	GHrK+mjCPf3/3rkHep4M0wyDGiKctl8M5BWfRIzKN6xGMM5WLhGOw0vhOl/670wfv+i4e3hmtT9
	kYkg+j1uV2DtmMTHZs7KtifBEYYRQ4/Q/WFz0a1dNPZMwt1fHDyX5GsybgWY/nuyYzfcuuw==
X-Received: by 2002:a17:907:8687:b0:c4c:f85f:aa2b with SMTP id
 a640c23a62f3a-c509641c620mr670977166b.24.1794801119103; Sun, 15 Nov 2026
 19:51:59 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <cover.1794666741.git.lianux.mm@gmail.com> <62dce3641b589e9cd42edccf0d4e9b31e7d91e36.1794666741.git.lianux.mm@gmail.com>
In-Reply-To: <62dce3641b589e9cd42edccf0d4e9b31e7d91e36.1794666741.git.lianux.mm@gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 16 Nov 2026 11:51:22 +0800
X-Gm-Features: AclHuK_Gbzghz_9r5pcBeCg-HWxSEX1oN3xYkrnwlrCQzsB1W6e7M40eujJdLuM
Message-ID: <CAMgjq7BnyM76DR8cdaz4o5PEg0=4rBAcGvWwoHqFDfPpoqu4BQ@mail.gmail.com>
Subject: Re: [RFC PATCH v4 10/18] mm/swap: add priority queue for swap device allocation
To: Lian Wang <lianux.mm@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Jihan LIN <linjh22s@gmail.com>, Kunwu Chan <kunwu.chan@linux.dev>, Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, Thomas Gleixner <tglx@kernel.org>, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: AFF6E40003
X-Rspamd-Server: rspam12
X-Stat-Signature: wwgugyz5tke3jo4qmbchac5gfwtpyiug
X-Rspam-User:
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794801120-207413
X-HE-Meta: U2FsdGVkX18Nbluwszk0F0wymKpX38YBOdZRRBnj82r5Cuf4VL6+ImYLpNOn+72PZHmyUrMpTRFKy6pjJkr+WEYSzpjwg/ekiYk0eiiJ2b2bzPKfVKnrsKD8KY4UXU2z33JS0hN3B90SwPSjuufiC4bXId1oW8FAFJiv20emBR3WG9WuNsCYVXGtllMzZj8B2QR0cpxZTA/Q+/15RFenfaK5MU0FnGYW6acLlzbko1b99nyh3LNd43L5v2d41wtkQnLXW0UrJy03WiwgePtA/1OYAYcdMgGGkf5FPpZOTFF7i7WQKmFvjU17vemvMjxqMfW3+2oqMrhfKkMvcidoyCKk/+DOTQqsRfGsrrPhk7OT+Q2qQqF+CthcHFcChI2s0X2nN9KZrn4LNqhzInSNptmucAx11zUs0hbgPXZtltKzl38nDVPb7pb+B7+CII8PdkEgiZY+GJuiGId9f+5xfAVOWkE6RjNzumUq4eWpbGIszYN95HZkhrKlrFTm6f3siEFL+0hjreqPWA3iN4weHNwL34zR+yvcJ6QXmBakQDILa/qEHDrdINTaRUDydPEH1Nf8mYuZaU6CYRyINufH8vl6Wbkvg0OV+XcB6cpccuB1n3sqixeAmQ9oWsQmPGF0uZ/FTzlJeAapKmNG86IgJ4DQt4V7I1Fr1LQryploIIzxFmfxIsqF/RQwpQEwIkDu7OYMA0rEr1nHr/jVSJoYaXtWKRBYRu19VXWn8q/rOQ4sr/ty63dlAVMv2hYnqs2DEiMmgdUScLxM4v82PeJgYxkK67xlvZxstuAtXq/VEZrBD/0j6wIDdrZrjXCww2fE6VLWgsadcwho3mHtyClXPWNX8vaL6RBarhvgicZmUtpk8bcBFMiwgOohxxO1I3bqnH96xktgm0Tmvkcl5lCA/tOsveVjh+qUaQuNHWM+wETc5jCDQH/1pBW2jfJKm9VOUi141nJ3Q1lnJ/WYluQ
 LlANdbif
 l7y0NshbgcjOupjTnCcx4iosHu+0FzYKOID0pBL8KAqHCfw0NMC5v8sLdpZToF5jJM0KqdXcADYTOrap1Fp3EFKgNxLzRXW5a0Wf8EdlITnZEFjCkiJ3BnPGjhaLNlxgBv4npHuLuo5uJ5SdYAIPIBuQnwWuZZJ7qQOVhsjpVBuS6lHgogqfZAIr9F1Wt0oYhHFZkM/uGPJWuNiTNBm+/mgFIHBL/LgTqqr/c+MCBM+SefWZSk1Pbxq0RxatgVlo4Knvb+4uqU4+U2L4WA10HJ7YK623xJSCJksVwLt2fIntaIP/ckP5HTDAShQFFkORMyCGCfPxNEJUztZdAHQjGZsP90w4bAKBhutGeYCy4BTBA0yrnCrNr90vBHQmbvKFWZunCJrMuBM80harrXPVtACSeK41/HAEJejt7xFN6MXAfWByAIQqnFJ3H4DQ61ismDxeqLuHRnsDUxZrWNlToqHkAeLvwRYvETDZtxOmntmN3vMHzdCOmDm1IJTq42oktZTY9PsHBVUNQoAulhelD0rlXhkYrRmDGh0vXxlT7f8x9DynVsYBcTX5sfVl02sGBVXJlxEc4Kb3BeFdpWFKWC3RoZgbkwCwRe/M6GqflqJn0rwVP13bJ1Ud7pUJdcEw1ORAZAXWaDQvd0/jnI5iYUtUzWP/kkM3lDp/+DL7iEZjfSPJZyCQKBXPx3+4uav6ipr/c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 14, 2026 at 10:51=E2=80=AFPM Lian Wang <lianux.mm@gmail.com> wr=
ote:
>
> From: Kairui Song <kasong@tencent.com>
>
> Swap device selection rotates swap_avail_head with plist_requeue(),
> serializing cluster transitions on swap_avail_lock. Separate selection
> from device-local cluster allocation with same-priority device rings
> ordered from highest priority to lowest.
>
> Keep membership and sizes stable under swapon_rwsem during each
> allocation walk. Full or disabled devices remain as masked pointers.
> Serialize tag writers with swap_queue_update_lock and use READ_ONCE()
> and WRITE_ONCE() for complete tagged-pointer accesses.
>
> Each CPU has a starting offset and base-page quota per ring. A task-local
> cursor snapshots its starting device so retries visit every peer once,
> even if another task changes the shared reader. Disable migration across
> the sleepable walk. Large folios retry same-priority peers before asking
> the caller to split instead of falling through after one fragmented
> device.
>
> Prepare reader storage with GFP_NOIO outside the topology writer, then
> recheck priority and required length before publication. Transfer the
> prepared storage only on successful installation; otherwise free it
> after unlocking. Keep per-CPU backing allocation outside the writer's
> noreclaim scope because it filters caller GFP flags. Constrain small
> queue/ring allocations with a scoped noreclaim context and
> __GFP_NOMEMALLOC, restoring context before cleanup. Deletion keeps reader
> storage until replacement or an empty queue, avoiding shrinking backing
> allocations beneath the writer.
>
> These boundaries prevent queue updates from reclaiming into a swap
> allocation that would acquire a reader behind the same writer. The
> cluster metadata fallback also avoids direct reclaim while the walk
> retains its outer reader. These recursive paths were identified by
> source inspection rather than reproduced hangs.
>
> Publish swap_file, the live reference, queue membership and SWP_WRITEOK
> under the same writer. Complete the disable flag and queue mask
> transition before releasing that writer, so a new allocation reader
> cannot select a device that is no longer writable.
>
> Mask the off-list flag from the old in-use counter before its full-device
> comparison so concurrent freeing/refilling keeps availability state
> consistent.
>
> Keep the old available plist in parallel while migrating its remaining
> consumers.
>
> Link: https://lore.kernel.org/20260714-swap-pcp-priq-v1-9-de9b164ed419@te=
ncent.com

Hmm, this patch is now quite different from what I posted in the link
above, e.g. there wasn't a "struct swap_queue_cursor", and some of the
naming in it is quite confusing:
e.g. "ring_only", I think what you actually want is "fallback_allowed"
or "no_fallback".

And since there are three iterator-like structs, we better reorganize
the naming; 'iterator' vs 'cursor' is confusing. e.g. maybe reame
swap_ring_iterator to swap_queue_reader_head.

And why do we need a "cursor->valid"? I see a following commit dropped
that, so perhaps accetable to keep it as intermediate step though.

