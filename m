Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F24D5606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 00:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fdolQjQh
Received: by kanga.kvack.org (Postfix)
	id 11C776B03BF; Mon, 19 Oct 2026 20:35:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A5C36B03C0; Mon, 19 Oct 2026 20:35:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAFD36B03C1; Mon, 19 Oct 2026 20:35:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BCE786B03BF
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 20:35:56 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 40F838089C
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 00:35:56 +0000 (UTC)
X-FDA: 85341137112.14.DB2F184
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4879140002
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 00:35:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fdolQjQh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792456554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NtUt4EBp1f75gVbnrDI7LLQPMBNwUZ1wb674GgkrAXQ=;
	b=nGT7a8B4fnvVzPFYdu4As3EyqYdj3IbRcB9xEOFEnNN/G6VWmexR67ij3wpTub5auqRd5J
	q6+JifCBPbzGux27xS6dujQ8clqzqOcOctE3ry27KV7fucQntaF9igFBI9wfn2iqGwhBcj
	eSkl0XINFufQhQu0xzq2BJf77/QFa7I=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fdolQjQh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792456554;
	b=HrLNVfM/pxzhzBp6/n1fBzEsd9Z4woh70vzNBe7FgYo5/zyOu2fe1x/oftbsHVUXrSLmlR
	HQOco5nRAu74bzSUlGynw1xjs6FOt3q3LJKXT8B0dUWQG/DIN1kYC0WAPXyv3DNVDrfANz
	r6KLQGdZ6zsrDVOq4aT0Od8HlyZZqTg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 44CDC4400C
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 00:35:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 203671F000D3
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 00:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792456553;
	bh=NtUt4EBp1f75gVbnrDI7LLQPMBNwUZ1wb674GgkrAXQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=fdolQjQhkL0ujALk1waFv+Nz/s8AQ9DQO/nHMOTG4NsxuA5RKDI2NTHpnn0aFPhAU
	 jRV/jKSlDbi6c8ZYrYs4D2iJDluNi+ZSHo7FcjxbGOXxl6a0LMn8wJdjJVPDuaY8fz
	 KwpyrXuTyMjCKw9MGGwHhERv49qzjZYQveYO4OjHXO4hkNmG90EqqSVo027SpwY1YL
	 1WRm5iqVybI6Qkf5dkcFC7Gqd9fP80oT4nzy/RzbCWuTAk1p37hk08/o1qmfQD0+MM
	 LgOOUivAzl11PjhhxK9dLIGHOTlMERkGdsTs7uYo/nzPa+UWbN2YmCkU+I48qwvTLm
	 AmVDFgW4e0LTw==
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-93e63ee7b4cso306037185a.2
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:35:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzB4JlSyEmC1gDkJL9hDPlTbj2bEkLpiizujKis43uDdEvT5CvPWTg2DiU9422IT+BFw4ad63Wg+A==@kvack.org
X-Gm-Message-State: AFq9FYJ3GSOZJxEkCdBylzup0xXjkq2xLFZHf5zOiKeOeujEMkoyvcPE
	rgNSrJ6AXQSNogOFGvWbIzx/zMJ3ls2G8tXs9TchAj3ny/i35G6wxnweWdRNXAnC4FfNmi8mZ9V
	tfvlmGjlSW4CbsmSYBmHkJToTNwp3DIY=
X-Received: by 2002:a05:620a:394c:b0:93e:5861:34df with SMTP id
 af79cd13be357-93f29d7be8dmr1558868285a.47.1792456552324; Mon, 19 Oct 2026
 17:35:52 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <6ad67231.a20cb897.960b0.0042.GAE@google.com> <20261019164638.c33e70eaefbee802eefb4716@linux-foundation.org>
In-Reply-To: <20261019164638.c33e70eaefbee802eefb4716@linux-foundation.org>
From: Barry Song <baohua@kernel.org>
Date: Tue, 20 Oct 2026 08:35:40 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yjMP8Tq1mKWtV-1GK9NJ0HC581w0=x2V_QMOiDOm-cvw@mail.gmail.com>
X-Gm-Features: AclHuK-KfVTEMdx8AlHQkztAVoG4bf58LyyLDo_u5rI7H9Ara0G6VsLgl9a3zt8
Message-ID: <CAGsJ_4yjMP8Tq1mKWtV-1GK9NJ0HC581w0=x2V_QMOiDOm-cvw@mail.gmail.com>
Subject: Re: [syzbot] [mm?] WARNING in shrink_one
To: Andrew Morton <akpm@linux-foundation.org>
Cc: syzbot <syzbot+54f6a8926b40a171f2c8@syzkaller.appspotmail.com>, david@kernel.org, 
	gourry@gourry.net, joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, rakie.kim@sk.com, syzkaller-bugs@googlegroups.com, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com, linux-ext4@vger.kernel.org, 
	Vlastimil Babka <vbabka@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 4879140002
X-Stat-Signature: sak7cfyqgtijby7s1yn9mnous4jfmp9h
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792456554-940924
X-HE-Meta: U2FsdGVkX19FnCkS6iZfUhZbO8He4fWEUAAP8HmkVH9cNahnDoaHD7hMzlw3P4ViqYxDXqIeFPW5LgG5ukYm6aBzHQCrj7KprzCZUGa2Ymh4f4itEaVO7Wp+uMRGpxJSJl5rvRSWGJtn2hkUTWVyMgT46VdPZm+5tXPIrBqdGrbEzKUTJ+lj3xusrbP+T8SnwExMFLht1XVWj7TaiVqRZClNmMahITULtgb4ohxqBRSFHnFATxr4mzXv/ofHHKfNbhNQ655xykyxvoQa6ph2tAvPdAd6sJkGkjNOpEWyTtvceMN5Bjv6WyeDTiwQ5iHuw/MAmiC6XHy1iAYF7PFXLQyhvW462/SQQxKGe70zJDdRzE5STmdn4bjAt3MpfKPYBcODFJnR2iFpCBo0yV/BosOxB8nXJYC7BYWpfA7WpPV5cCeqivA6AWcTcvsl0NoATIcmsCMNtimPq1mOTh2w5V3H5i3KpUeGKyonpZID4iQTBes6XQvBDxEFyTvkRW3crBJhaFFRqm9F1Td1M8nUJLTFvbxafGxAbZbKffAh/7EepM/EVJ58pmYDTfIx9SVtIO8UTLcIGoUMhBaufY+b1mTOgoOG3Lk2KJsUuP5q2GmpVJzEwGuQslLonTHKhqtrtu04E2qyYH4iH6XFrCqr3i5K33XkNIwaua3MMC16glXhnGJSr8Nz4QRnmHqgD29otDq47rEQIJ4rjY6NNLS3cTYustNEx9C6dD9cSjoBmyj5kv/Wbn85RdGUzPFyMEGK/9vQICeOkErQZCQLeOZZTbLsxq7AoshLMTQSMjWLN6W2atA9Zkpayu5L3lTeTxCgIxdOPT5g9tNHRY54QHhi7PlxQDoY7Lps68/+Wtj93uNkuHn81ML7xefhJvFyIP7fL0HUv2mWgAdSS7LCnwx8k34l0XvNu/EgSwRBgMThfE1YW5mwJg73qDBBMX1lwfALKWvgJm6/yOkZu8W3l/W
 Tq8h3sGF
 3FkJF9jCfUE6sNO91Fz/zzEF158tGqfhYjH3e21XQJtAmt58rYqu2fod6ITclaZKqC3AaIipPuTT2fHG49E0zpmsPDd6Q7m2xTNcHUr3TL5iPvX27Den73cXLAiNE1ZGKshWCZI0P7SRZe9CPolZOTOWhobzVfjccSOv6AD+8kLFIf7G8rjj1JLUGQwtMOY1riCJ57MNgSvDKZDSJttdiUX6Cu0vcK3jrrahwpN++cTdbcU1iTXAWH/1irFhBLV6aXOshEhNPz53LZClCcwfiW2Hd5fqektJUjJBowm5RGD70QYPjAG5FGwtwM1smU1OHT+o1nbZySa6RQHPmX0JGUnl0lsi82D4nV+GHDMAo2ChsH0K6lc/+YW2ieg0gwLfbA/l+g1hSxvUWsI5esJQ7r+V9yPwYtLSzv1zJ/zc8HpVyBUGD1rNZVRrSJyADOEJznMlWnEmHCoYUD29TIhDnRJxlWd4opdzoyg2yiDtDKYHlgP5IHlOorhhnBAFYu6GY66nzZ6YFjMuRVqReGLpatai7NYi3mytjhn2bWuAoQmru5s9TgEL7OMbfPZ23uMz/0bJrxGBEcKxE1BmGrB9FNj1NXcbOP28vvMtFrTWN0Rufeb0lmn3WdPV3LPQOz3DZCEThw/MeF7IS1v5onC/zXZ/yGQpe6bHeM7a4VY+yX7X2UlbjV0arDomyBkFdv6A+WMsyCH7Vqy3TOfFZQ4/kPdHEVblkiAIyc7oZ+CC/YqPZ//+vKfxvzITBqAnRU7ttTcEH/hcHvK60uegy6rKfZB8uhpuZ0rb1WuHTiW23pyyoIrCY9wx3d7oj6yUbEet5VnMK7zaHcZ/cjdB90fXGXdDCyg1i2Bd9UcLuce3ZJN6ZP1fbyQzHm5Z9cXaf9vemNPIhZDeg3ZrY73GnZU1eP3U+dqVYjn2IEWgR7UBNWba5T2sIZ8rcPomVHK9Ea/Iba3ALO9HlLyE8qgIViSlBwYb3OhhH
 pXRzWS0b
 O2ShCacuzrsFK6+O9vCQ+7aopevxoZJtDMGhP/HU36yP8bKclEBgBtZROva9ZgLE1L1+iBHRkhO7QW4Dfd7At11rYvKq4Zod
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 7:46=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Mon, 19 Oct 2026 12:40:33 -0700 syzbot <syzbot+54f6a8926b40a171f2c8@sy=
zkaller.appspotmail.com> wrote:
>
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    a0ff06b3a7bd Merge tag 'firewire-fixes-7.3-final' of gi=
t:/..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D12cdb20d580=
000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D44ac479246d=
4559b
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3D54f6a8926b40a=
171f2c8
> > compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for=
 Debian) 2.44
> > userspace arch: i386
> >
> > Unfortunately, I don't have any reproducer for this issue yet.
> >
> > Downloadable assets:
> > disk image (non-bootable): https://storage.googleapis.com/syzbot-assets=
/d900f083ada3/non_bootable_disk-a0ff06b3.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/3f4bcbceb92e/vmli=
nux-a0ff06b3.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/bf4df8252e54=
/bzImage-a0ff06b3.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the co=
mmit:
> > Reported-by: syzbot+54f6a8926b40a171f2c8@syzkaller.appspotmail.com
> >
> > ------------[ cut here ]------------
> > current->flags & PF_MEMALLOC
> > WARNING: mm/page_alloc.c:4816 at __alloc_pages_slowpath mm/page_alloc.c=
:4816 [inline], CPU#3: syz-executor/5706
> > WARNING: mm/page_alloc.c:4816 at __alloc_frozen_pages_noprof+0x1eac/0x3=
300 mm/page_alloc.c:5449, CPU#3: syz-executor/5706
>
> Thanks.  The stack trace is missing important bits for some reason, but
> it appears to be ext4 disagreeing with page reclaim.
>
> __alloc_pages_slowpath():
>         if (unlikely(nofail)) {
>                 /*
>                  * We don't support __GFP_NOFAIL without __GFP_DIRECT_REC=
LAIM,
>                  * otherwise, we may result in lockup.
>                  */
>                 WARN_ON_ONCE(!can_direct_reclaim);
>                 /*
>                  * PF_MEMALLOC request from this context is rather bizarr=
e
>                  * because we cannot reclaim anything and only can loop w=
aiting
>                  * for somebody to do a work for us.
>                  */
> -->>            WARN_ON_ONCE(current->flags & PF_MEMALLOC);
>         }
>
> The electrical think machine said:
>
>
> filemap_fault()
>   -> direct reclaim
>      -> shrink_slab()
>         -> super_cache_scan()
>            -> prune_icache_sb()
>               -> evict()
>                  -> ext4_evict_inode()
>                     -> ext4_clear_inode()
>                        -> ext4_discard_preallocations()
>                           -> ext4_mb_load_buddy_gfp(
>                                GFP_NOFS | __GFP_NOFAIL)
>                              -> __filemap_get_folio()
>                                 -> page allocator
>                                    -> WARN_ON(PF_MEMALLOC)
>
>
> The task enters direct reclaim after a filemap allocation failure.
> Reclaim calls shrink_slab(), which evicts an ext4 inode via
> super_cache_scan() and prune_icache_sb().  The eviction path eventually
> calls ext4_discard_preallocations(), which explicitly does:
>
>     err =3D ext4_mb_load_buddy_gfp(sb, group, &e4b,
>                                  GFP_NOFS | __GFP_NOFAIL);
>
> If the buddy-cache folio isn't resident, ext4_mb_load_buddy_gfp()
> allocates one through __filemap_get_folio().  This reaches
> __alloc_pages_slowpath() with __GFP_NOFAIL while PF_MEMALLOC is set,
> triggering the warning.

Right. The problem is that ext4, while running under direct reclaim,
allocates memory with __GFP_NOFAIL, and that allocation can itself
re-enter direct reclaim.

>
> Simply removing __GFP_NOFAIL doesn't look safe.  The preallocations
> have already been detached from the inode's tree, and failure to load
> the buddy information can prevent their space from being released
> correctly.
>
> It seems that ext4 needs a way to complete this mandatory cleanup
> without performing a NOFAIL allocation from the slab-shrinker context.
> Perhaps the preallocation cleanup could be restructured so that it
> doesn't require allocating buddy-cache folios during reclaim?

Checking the code,


   2   5686  fs/ext4/mballoc.c <<ext4_discard_preallocations>>
             err =3D ext4_mb_load_buddy_gfp(sb, group, &e4b,


It does check if (err) there.

                err =3D ext4_mb_load_buddy_gfp(sb, group, &e4b,
                                             GFP_NOFS|__GFP_NOFAIL);
                if (err) {
                        ext4_error_err(sb, -err, "Error %d loading
buddy information for %u",
                                       err, group);
                        continue;
                }

So maybe it's safe to drop __GFP_NOFAIL.
In any case, we need the ext4 folks to look into this.

>
> The syzbot report is at:
> https://syzkaller.appspot.com/bug?extid=3D54f6a8926b40a171f2c8
>

Best Regards
Barry

