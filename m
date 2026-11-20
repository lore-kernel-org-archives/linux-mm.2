Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1CA4606A32A
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 06:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=JNHcaRJt
Received: by kanga.kvack.org (Postfix)
	id 86CCD6B00EF; Fri, 20 Nov 2026 01:46:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81D6D6B05B0; Fri, 20 Nov 2026 01:46:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70BCD6B05B1; Fri, 20 Nov 2026 01:46:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 493676B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:46:54 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C2E5040D2F
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:46:53 +0000 (UTC)
X-FDA: 85454564706.06.C9047CC
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf18.hostedemail.com (Postfix) with ESMTP id D8A481C0002
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:46:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=JNHcaRJt;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf18.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795157212;
	b=t2qpxToaVQ8WBJg4428tf6t5z9RvbpjG4CwDfnmZQcyTyTJp7defxJSziwcrG24XLiQnpv
	gCaulFruvGHsqEHxdradPPmpFA6Yl3NWvyftWjQmLnZRwnt8ovM8K/MuR5ZxIH3pJHbwK4
	AbdRBzCVGDRb/Bdxzt13a4YzHbgZSHQ=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795157212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yh5Pw6Ns7Cwi6C95SoPvU5P8PiEbr6Awtt6kTXpPyU8=;
	b=aICzYNbQhHWQw9dydmsCU/sDnbzgYK6Jdbs75kc/PWOcHln+fiJGzHjRuguUWnv3zgb7wI
	a6Es3hClYQK/06wDcXvVT97NWBpcS1tNJEYUAXEb5YhxmrLDzBuH6embRUHtUbKIHBsgzY
	JfqVX+qp3wM9NXFTwIrfuyIkX49aXCg=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=JNHcaRJt;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf18.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4bb64c99d2fso5346295e9.3
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 22:46:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795157210; cv=none;
        d=google.com; s=arc-20260327;
        b=IX4exbMw3DYFn0t8EnpYph/PepJqqGBLi1AObP52mgVyo2oRt7jGKkGiAgsWUB2GQD
         Imqymv8HkHcvHe2p1NSZxKRxncbzkKSad5WnXzFN1LBCLX6FBpWJITFmCqjPmwVeF31d
         S9u4nbP2FTLLNXt6eEuvqbpTacnNNJAuaW6B7SiRU74rFcLHTzQ+O3Y1wS5+F5o8nJYs
         LyIYGTUfQl4cSjUCE6HTPCsfWVhcv5prMDQkN03oCPk5cnBsMX6q/lsgOACLAE7S0vF4
         w40v57JGx94iaqga0SnWunRGQXyFEwob5gw6R1KIDy2PLgCWIz5W17hqE/ic/icjNTUt
         0syw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yh5Pw6Ns7Cwi6C95SoPvU5P8PiEbr6Awtt6kTXpPyU8=;
        fh=01xpVHe4kda/rS6+PGv7HHxY0OOMMTM3Wu/tKcvhHys=;
        b=f5VaLyZSm5fpdcOkgFnhUoOXqoflRLJXLTSsd7FulGVezrdpf46m4EgJyC2cVrCCvT
         q+L7nDLpTp0xKd1JjauwaPhBPwka9lwbMn21fr4K0eHgEzk8wUmQ3QFl98jgknx0CX1R
         vhSQD7ULLxe16Gy2ptJthprLW8i9DYe1k9lMYO/vGUCEqYMsaIGdpax5QQ0cLNwgRT0o
         fP4FtWriehT058LMgNaEDWR6DwTW/NBWFVr29SB939T3bV9OQ+R5TGs3pDM9cH9G3Lbo
         3H7BFT0YEEgBgWe0BLrNTM+jz5DpTOMOvwGCIrqu7lTNpTlJ5T7wY7FAwlIBo2a3mVpS
         hjbw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795157210; x=1795762010; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yh5Pw6Ns7Cwi6C95SoPvU5P8PiEbr6Awtt6kTXpPyU8=;
        b=JNHcaRJtjNii053m1+G3p69CRGRCbViv2tq8ImsYBY4mHSDWrtutCOyHT1ek9J+dAz
         26HXk9TFDy5aXlGMNma7iZklJc/H+n9HYiXVcaE9YJp3NHhMyDjskcDE4ZTvScjDoNfr
         026DHsJCPk2unqMx0uBghT/V6aUbaAQafuhySM23bZsX74GgGO5ZmerxmJc6O4OOZ2PK
         TXOnNCcvRo9llfpuD68P48eNFkmnaKlzAPn4Fb4op0lw8ZLFdHSj6JvMJJIQ9PtU4lhw
         QBo5U8cvNhaSXPUDPNV7YELtr+XZCDrIJMA240xVKnxpknpRH0//HXDPFpBAD/EmI4QF
         Mvnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795157210; x=1795762010;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yh5Pw6Ns7Cwi6C95SoPvU5P8PiEbr6Awtt6kTXpPyU8=;
        b=Wnz52CT1Z5pQMuz6qYupw4KAMMGr5SldV1aH5LHzl+Df9+A3oqkaq8Zfxc6UP+GhDA
         iaTibofRmkA9aoINHp2tuvNeoEcl61ZWX/uuREiJ/tnIeXptnT7aAG440A5HoKY48tFD
         blkIt+5ujt81nEngXivopVWgYRkaQ/Pe6cbm+hsF62tEGlrxl/MCCfI+x9ikFnz5O0jy
         JyuprygebKqpOPsCGvatM3ZzI0GrmjOFRfjZPTzkXPCESVRK9piFw0oZRGKn5HfTubhh
         nizBLPapqi8GKfdptmvxQlpxTH3Skh60k3k0ACpwP48ooo0gIvmZy6KjtutcdBHOhJ8B
         I51A==
X-Gm-Message-State: APuU4Z9xyvdHiXqZSw11K1c5c6qqPp5UISr7UGMXLVPC1a0zOHyQ7JR3
	/ZttgcVIgGwEeLpkJS0FRlVtC7j2xJP08LJtB4quGOjU3QAMM2bYiAv8cqiAK17+uIk/SQypHIY
	ktv7DujQeGH4vV5/ilXwyLfTFKOLty0g=
X-Gm-Gg: AYBFou3hRpGMtSck1bh/+nRMiH6+k4r3MIR0MuySyhA2MRpQBDGwBwMvymZAv10a3Ml
	7WzU4Nhoh1pkCGK9pNS32cX44xnrTf13pIP41KAX5toC4fUP1TdFKeRA9JJArACiS3FGjfpUYrc
	Q8m8JzAx3OLjG5lmIMioq3GyOy+NRB01StFLKvo4vhRyGVgUKrgGHXpGykIcHJ5x/Z4cHBh8y7J
	FoxsrJiEWnETywpgBvy6jY0B9VfsSipWDNsja+3r2KzBEcjDc2Ep/3VP97MiPVTYOWQR2zQ6D3w
	g8OY292esjRtcCNexyRzqMsEZluFpYxywxU5JPHk7QBmzI8qTkp1ddDK1qXMOlqtLaMdjpJYOEa
	vibB1xoVflHCAbgZJu3Wj8fKovoyr9Fmgl9MusKjRTsYBPrO41zhLyF33tSBI7xQ/
X-Received: by 2002:a05:600c:1c08:b0:4bb:7757:fe6d with SMTP id
 5b1f17b1804b1-4bb88804c5fmr50882955e9.11.1795157209745; Thu, 19 Nov 2026
 22:46:49 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119-mglru-fg-v5-1-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-1-9eee2fe97a2d@tencent.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Fri, 20 Nov 2026 14:46:37 +0800
X-Gm-Features: Aa3M54q6diJBPt5X49YJ4xjQARO39_f1G-0YmFpyFCjvJebbL7DyzQ2TCjNUNR8
Message-ID: <CAN_Opa9Gu56Tdx2WVrYZU95BrHdGg0+gf2mpv25gM7WCRULJ0g@mail.gmail.com>
Subject: Re: [PATCH v5 01/17] mm/mglru: rename the generation offset in lru_gen_folio_seq()
To: kasong@tencent.com
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
	Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Hui Zhu <hui.zhu@linux.dev>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D8A481C0002
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: qksuz9erd3ypywzxnndrn4c8e8b1bedg
X-Rspam-User:
X-HE-Tag: 1795157211-948913
X-HE-Meta: U2FsdGVkX18FVRDVthHTu4e7vwgTJiFWckDjNNjZU8XxeclTItPe8zLkNj6WBeEYZ0facgddlpID/T0qAEn6DMXCOKQQTibCSuofvPGEFlyrW1gXmCfxikSbUou1s1x00RjWqI9hFRCkQ3hZSj+fvyvQKf8+vk8KD1nvTCvXOq5IV5RUe5slZvOv9OFia24eg1AYgre9EUrZ3pDaIoYm9zmGRlDBD9It2sfKg+0wISTejWrmGz1Dri3pfKtf/QxgVqgzldh4+++krvFadDwJV9ADcs4zY69Th2gI3xEaSGu4NNtyeyAe+6HS665kq6JiylayuTXQefsEYARuBCa/Zhb8AGc0OQ2VTnirS0akuNUq57J5wgQ3VUMawCRnHE3a6IbImAFrrISvnIcLzXqQ5Talt4OyR9w1/hqbmjjhHI15PGZznJvW1bFS47mqXPzJKfRmsU4yxrfW7tnf0E6kMbi4u8H97lw/LJMfzWNRjhJDZK+EkUT3+eJYHmnKG7cDxHJ31gzIUfN8BMHIP05fOA2BfQu7GNIVDNAsWuIltJRkcRdafaDna1kJHiNdj2RWjmvnO/pGWyD35QpQ4dvC5ULWVOFZxKBiCX0swnj8rhrzHvGNFgq55Ml8xlJa1eoWAmjYSI51akorNhOniVGkvIYGJdC3ljLJZ6OSIwfiXNAJVC4+dNcBzryDq2YOeSaGGsWzY1tqzhZDsCkRdf38Ir/LObsw2XlHw0sss8RipdppR2VYbqZRmqdUmHwxl4bmu27cS6pSTqu9NiMS4+X+FlT/OQpKRUcno7b35eUkBcqT0wt0LMDkPFbdJoYdYF8QQWx74wXWJpQ6K6m2djZXeZLE23sd8iTDlJsZM+VH8zAPNr0mKguuUM5md8eXTtHGTjKpjDFKk72382M8bLDKMAKfAobreIbVgp33KaSfUn7RJUqa537nZusYk6mU5BtLs826ySxON9zFHtSAtiH
 eL81aAlS
 nBX7yHogGbrV4CJAm16gGLkFnISlt0jdU3X+3oX+1Ig4ZlyiElZcJkz5FFrRCIy0swMR6pZ/RBpAMjWeR5kL6FbzY/OtfRvDUTqRBbufhqte03oUV3cn91yC8FYo2OS2vRvOaMFfjfXNOO+z7hIeq2ejEnbG3L47ki5gp9pNynKEQDzK1JSinlLCAnP29CtuAdQ6RYmgZJp/q6TNU7dUqub3ms4nEP98uSKPL/Is2Pz1urbnVFpzMnSRiz68h/K0ZpBPLfNdk5MfdFEGU4JuHu3qsmENU0/ztIcY+BMerIjGI9IjVNc7H2yp+qV4YBFkca3Jlvjj3IB66XwEVywCHYnTpe6qC2D3O2uw9sW+RUtYSWn0VZB0KCU6LrQhuHEvYoRt2GRM7Uf+fwR1coGM2vTqSCnvo7XuwSQcCjuJKE4lN2Rlxe18JGmoqJZCMxBIR2QkHq1pVlxZBiFGRM6KZXU1/tjV/sQVN37K8zv8ylgIhkmpAjXFc/LH5p87TkLDgdVUmn1Ha6rQfJy11XNMwVQRgJEppUdLHHYa/9jAV9p4SWqLYlngGZsKoNautPly4aut174xfhhzr6gL+7QeyM7eDXxyUAwlcQSBYHIkkoehnZZhS9/v9gOz07lg6ivSpGopE7m7iWs7E663pdlSYgEVF6EILljALAaFH4oGDRchWNLp5ISi/9gDvjkyI9eQgIXKKCbaBR6lPOCvDoCySFUbmVgm7NQGmOFUUx9WMF+Wbo0rLBgLoH5S2Y3h7qEjgOUrkjZS8H0SBEsBArCDOZWtO3kvHO3f3FahHvQqy1AN/Sy2W3BvxWA7gXANW9xDDokEX4jPURXbUmIo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
Kunwu

On Thu, Nov 19, 2026 at 5:03=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Ridong Chen <chenridong@xiaomi.com>
>
> lru_gen_folio_seq() computes how many generations below max_seq a folio
> should be added to, but stores it in a variable named "gen". Elsewhere in
> MGLRU "gen" means an index into lrugen->folios[], i.e. seq % MAX_NR_GENS,
> so reusing the name for a relative offset is confusing.
>
> Rename it to "age", which matches what the value means: the newest
> generation is age 1, and a larger age is an older generation.
>
> No functional change.
>
> [kasong: dropped the comment table part, the series rewrites it]
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/mm_inline.h | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index f6f4bc9a704f..2395ca8ee305 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -302,7 +302,7 @@ static inline unsigned long lru_gen_folio_seq(const s=
truct lruvec *lruvec,
>                                               const struct folio *folio,
>                                               bool reclaiming)
>  {
> -       int gen;
> +       int age;
>         int type =3D folio_is_file_lru(folio);
>         const struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
>
> @@ -319,17 +319,17 @@ static inline unsigned long lru_gen_folio_seq(const=
 struct lruvec *lruvec,
>          * |<---------------------------- MAX_NR_GENS -------------------=
--------->|
>          */
>         if (folio_test_active(folio))
> -               gen =3D MIN_NR_GENS - folio_test_workingset(folio);
> +               age =3D MIN_NR_GENS - folio_test_workingset(folio);
>         else if (reclaiming)
> -               gen =3D MAX_NR_GENS;
> +               age =3D MAX_NR_GENS;
>         else if ((!folio_is_file_lru(folio) && !folio_test_swapcache(foli=
o)) ||
>                  (folio_test_reclaim(folio) &&
>                   (folio_test_dirty(folio) || folio_test_writeback(folio)=
)))
> -               gen =3D MIN_NR_GENS;
> +               age =3D MIN_NR_GENS;
>         else
> -               gen =3D MAX_NR_GENS - (folio_test_workingset(folio) || fo=
lio_test_referenced(folio));
> +               age =3D MAX_NR_GENS - (folio_test_workingset(folio) || fo=
lio_test_referenced(folio));
>
> -       return max(READ_ONCE(lrugen->max_seq) - gen + 1, READ_ONCE(lrugen=
->min_seq[type]));
> +       return max(READ_ONCE(lrugen->max_seq) - age + 1, READ_ONCE(lrugen=
->min_seq[type]));
>  }
>
>  static inline bool __lru_gen_add_folio(struct lruvec *lruvec, struct fol=
io *folio,
>
> --
> 2.56.1
>
>

