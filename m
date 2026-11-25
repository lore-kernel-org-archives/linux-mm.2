Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6123606A32E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 13:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=YJYhgFsy
Received: by kanga.kvack.org (Postfix)
	id 136CB6B0A0B; Wed, 25 Nov 2026 08:13:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E7436B0A0D; Wed, 25 Nov 2026 08:13:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF0BE6B0A0E; Wed, 25 Nov 2026 08:13:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C83816B0A0B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:13:20 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 67EFDA8D06
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 13:13:20 +0000 (UTC)
X-FDA: 85473682560.07.4CE28F7
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf06.hostedemail.com (Postfix) with ESMTP id 78AEE180009
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 13:13:18 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=YJYhgFsy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795612398;
	b=pRl7D2GcKJEgo6NHGOlncR0VRYtKopKgMmiHBw0m9WGU48szpxbY1h7+JVyMgNmqRHFzI4
	sSQoK0qBH8YxP6BDe+5t/8CDX2n87a5vmtJuwT02kg9I1e82YGCSWl1F+/R6pQ6quijkmE
	LEhEP4eYpfbSzdx29mL34Gn1BNLSZu4=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795612398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Yz7JNlPDDcs8XZFhzYAPoSiu941gv9oYg8JZ/90iT4=;
	b=O2UnqfYPfTIwKmcXI04Y8L9ihYPyWYPNDafN1+4cFFUD47pSys0mP0B+riVOCiOiDV6pJH
	h/HNpiQk+uXlaZiKOFZceLeUQZa5ALc7RnYSFWatgrfYbAjUF1i3NZxttTGX8ckG0cvTx7
	ubgtTDF/Gzs4yiDKDGtLA0Y/xze4Un0=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=YJYhgFsy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c4cac7a7d3cso846676966b.3
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 05:13:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795612397; cv=none;
        d=google.com; s=arc-20260327;
        b=Gs+AFcGV6eC2+MZpURDjzTO6CWFbzR967riHhUQy5nDj1g5f9/CS1s3gle0aEiZR6g
         uZJfdcrCBKIRWSUcYWowkCA5oSufW2Mudl36UlugeKIXGNQp4xvnoMbi3DLCEktTGN3X
         N3Sf8sxC+N12a0br8wv+2QGr0bNitRKtT9XRD57/UEDiW+Mddv7AI2yegoOFRGEn3ozv
         G5ZfPMUTXjNPJscpS3efR3PJglI+xuLzMwzb6N4OptsbFLmrzimM/LAdtq/WOrzfsEQp
         8K15WSK6isiUXTJ/7vHn6lRtN7p3TlKDsWwElBZFiwq6dGlb36FwxEoxiH8lW478Waaf
         4Qkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5Yz7JNlPDDcs8XZFhzYAPoSiu941gv9oYg8JZ/90iT4=;
        fh=aeUgo5tO26BOvI+dB15Jx68m9yedj9daZTDU0EM+G5k=;
        b=H2fWuuIeW/7ai4awXKn6gRQ+zFUCpKe84+zxZRAwnxdckdLtmwLtdLyT6JPJd9PXPF
         FElTwraFA9cmhq9d/JzC7hvA4fnmpaJZ9IZ9T/XoIzDmos6LwQElMXNQKispDj5RwK2o
         IfAwDIG6Y0TPpnvXq4Q9CdKSl6Ku8yLwF99ZfqL1hmIVFsJ1L0B+GYVNlFdLqhgggoxQ
         Qb+RCNGdYSVLJ3553/hv88rNgDjesvE7XduJbaJ8HaFnTKNwqE/ZhuAM7xc7xBijEWZb
         HlK/EImstpIiNyKpZeV0SUzH2buWTqTilrtjPnrfqhM39ENsyImICWQABPlvhDBcvNXG
         AqxA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795612397; x=1796217197; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5Yz7JNlPDDcs8XZFhzYAPoSiu941gv9oYg8JZ/90iT4=;
        b=YJYhgFsylf3eu/gc1rNn+cWhwTLMw8hXXGgC/fjSy+6blj9DmzJr6gABUxHkMiRE8E
         +yk4zMnZgHMGVJebW9XR0mNO8atVq7M5iaONDWtFuNyHdYadc0aoiqUPwX9aj+1mPbta
         ddwfmzyBZvCiJtQCq6Qag0YocNPBGuZtEj4bjRvPof+GIHiQYp81zdJuwG8npPVa2hiW
         sFr0zqScywU/U7piPTKKjH9inowSto9dboJfCEeuD7+iIjXdYjyPkzsA1hwo1wUxqs3s
         rzHoqzVN7aN+P+fs6egDL3IlPajPqfqIQO2pEZd72YN7V2u9vEiWTFyUsPVcaAi38A2z
         HThQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795612397; x=1796217197;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5Yz7JNlPDDcs8XZFhzYAPoSiu941gv9oYg8JZ/90iT4=;
        b=XAqAm9jNnOk5g7e5NMPzxG6LetApenyf7uw3wIS9Fuh7Hy9YqRWIi21S5FUn0YqAcg
         4iI2/GPH5S136Gfu5AEhOLDt4X8LaFOXcKWp/F0oIElIzeMGVhcEMK7nFlUdhPwnJ3/K
         SjvvUIMKVMRUkbVCl9vTMHA9QPHkr9NJIA1ld/jUF2APi9ISpVXNnfV+YU7DWfbxMHQ+
         ZW5oO0LKjyyzrBPURBV3JdLqSvvk266Dx+48UZ46vGtHaEey2/7jtP37zyviNE9zGT9w
         pSLV53hldFI0GFmUfbAb5AH1E1dkzRBrkz+nVwbU198S2KehVp8l6L4nYj7CJv+UW7pw
         tM9w==
X-Gm-Message-State: APuU4Z+NlwXqwLKV9TxNC4RI/hJqeRhxu31DvUXLN5fMWVA/8xlT2iCK
	Jb0CVP5CSNKZ6+v//cjkrINQoDCnTdeChT8Lzouqmb9+TSg04HWFFZeifoIvZEEq24nK7PWu9N8
	HXxKYmjRSlb3cHeNf+5sQzYks1ft+G2o=
X-Gm-Gg: AZFdTZeWwBq/1MSouQT1oNd+Oy3SJfOKf9AM6kPShLgI7BGZl5l1vx88i+eCZ6GW+rN
	4LobkHMZ3mLDmfoDsP0c2Qs0LXW6h8kXPZw0QrAXRKD3h15Ymob5lr6yP+Y2/1AOxhK8jXwaiig
	2qxgpMnn9qeOAxq7qB1JTXD95ZXxUABMlYQ+lFxWJvEwlfsl75H4E83ml6grkbzJmfWFISvKE0b
	sO09jm2d8SktQ5jGLkTEBBpPkBmoXKo+ULIX6ew1y5OeqiUnqUTEyTRd1FZi0X5QhmGKgYXF6Tq
	YT5VGGCVXrOicXEQOOsY7sQfbZRAHZucIBF9WSEzTu/n4YwVjytm9OywOWs+IWCx9ZVyq3b6N+F
	vDTpgBUCab2mp9QEck1v2Jj4c/ot75c0+ZHaqbLQE8oztOwYhc0tOrsFOykgfyC+dmN1exw==
X-Received: by 2002:a17:907:9693:b0:c4c:ddd1:d006 with SMTP id
 a640c23a62f3a-c513ab47f40mr1378964566b.38.1795612396826; Wed, 25 Nov 2026
 05:13:16 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
 <20261124-mglru-fg-v6-15-8ffea39934a6@tencent.com> <fc51ad85-16f7-41fb-8eb3-2b8ee595e711@kernel.org>
In-Reply-To: <fc51ad85-16f7-41fb-8eb3-2b8ee595e711@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 25 Nov 2026 21:12:40 +0800
X-Gm-Features: Aa3M54rLCFPdJCUVsWAcKF2l0FhpWm6CiFAaLjU-bCfz_TzbQSOhJaNF1aUKI_Q
Message-ID: <CAMgjq7D-EFYsivqq1Z4c60ZMh0pBU2ofgfqVaqp_vbPG8wbSiA@mail.gmail.com>
Subject: Re: [PATCH v6 15/18] mm/huge_memory: mark folio as accessed more
 accurately on split
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Tal Zussman <tz2294@columbia.edu>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
	Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-doc@vger.kernel.org, Tianyi Chen <hi@tychen.cc>, 
	Ridong Chen <ridong.chen@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: a9tzym7y5kdjo7xg45ibjjjcpafubikd
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 78AEE180009
X-Rspam-User:
X-HE-Tag: 1795612398-687813
X-HE-Meta: U2FsdGVkX1+XDfA3W2afSAuU2f5YRtsshq4y+rL5V7uScm/agQGv42a6+OXI4NHCz8dwiQTYyR1DDQa9QjqubRusKjLCZUWXIMFGJt+3EIcYQQ1j2wxLxGWJbp0UPgooWP2A1vR1lAZHN+8rY+SlU0lF5e3D7sUsGCKe3oJ1B5y9bzWo4R4pjxXd2b2C4lIpKomCv2UzCQ07MIGW29a6fVIuSv4UL6WM8ZWiLn1k2lzzdiTS5N+VpZUK3tph2fptzfHi6wmigstQhF/cjjMnrh0mbuoHumARecyznAon9Pz0m+FZ0Cd3NKZTkoRURAY4n9x0xOteATg9iNKMjP/rZ8/3EcN7uiVUUBKyDDYE5b/qwDQqkWKW/wMG9YrFUz2ZdYVcrKhxkF3z2ChyBzur2hzl2McxBw9hHTIFkYZTFMNMZSN6zmEVd3p8u4+A/oFbOv34wasFOQz3oNmnfXcEphi09Gx9+EBV+K6+lH6yF5/U3aEBXXSm94yyYndlzfsVuAABTUpzOJPs9OMtUEHm9E3bWePI3fvv+aBKUaPSDI5LvaKYIjWLOU025p2Eq7XFz0zMiW0oND0F1kKeMZXcIeTzi8+569NhfxTru+csrqNepPPldqgyJevBeFIIDGD95XgX2+cR6E2i8To7SJOP/1VIw6GAxzdNl3E91t9TLF6FrJwI3qoEmPdxBrnmUAOpE2l4WGfCfudgSYrilDihOyXtqbxz7J4kK8NPttxwzDYF1hT6GtVzyrta6iSfsuhKNinlXXHvU5jWGaILTZSgXAOQCmBdEbCXm+fpV8ttVfcCzhMajejhCw1s7FtOYGmOQs9ibwGiDKhlrAXerMQfQWXBFO5GVyMxTVo86dKHUJYpx7w3JeKQhJxj7FOkEYwaHwHpsbsoKkUcqKwNpEmy459tLybC32o6xgoCdMgIAgbir2NrrxsXespD9SUA+unfVK49hI/XTGh9v+zCIm1
 WJJLouKP
 mhpxYxbhYf+gB0jV+0LEeNe8x0vaNrr8ou7/1dNzZULyWiA7voevflFFEkviTwwjxW/lfClkELKzoNGpKKqkRzXa5GCQGm/Fsi2H8tSgCRotkjL3H/3vxXEdht00ky8UACRD51onpturYMB6UNkpYRa4mYVww81uwyAKe/Fa4sII9V9rn2NznJjZeV3z4OPn0wFb6IFyr+wiUXyLDSiiV0oR7EH2JpaurFV4RmcvJgeiH66eJALu6mbciH3Zn/g0JZRXYZUBVwAklmLAqaGxHe+3le79+t102a9YKY/OZYgUfeqDFVD3pIycA3MFabphRbyC388uu+rfWBrtihdI6to+rykyzW+qw2Nbye0BQiuDnWG074UKUo2L4D20oxTsY5wXZY/TQRJlSQVC9Lxi1SnpEi0dQ0+5ZiEUjeUXS5mj119j9jNoYv5r6YZVM6kOz657sxgbEvWPptUbttmIk4qzGF3TquhRhiIjD0gilwDAsCyUlra+SQb0dk5CsoLyE/fiTMHWIG8+lWJZ6bOtfDNvna2eDI6ePQNVOtrH0Tp2X7SHLb5wbWy9LEoeNihF2lEW5iDaDUvSVzshAAyVz3zp8vi/7dat0UtyENdSKQzDrOGsm8jz2rXioBnq29aQt6MNyZr4B72wWBFaOOKfu2xP3cC7MLaR4+k4XGwRvo7sr//Dp0a60THXvToSo/BLM659t8xMKcwg6DSJehqXN1VV763FuVN4MAwC2pL8wbjG8ZU5Y/whF2zDe+F/zqfEJahSseejWgCW8y2A9tIfkwXdkyA/X+jNIdr15ZOftg59CMBpYkjPKBLKLOKWlxIE1Ndd2H/xTe1uGP/+VaJIgxw1Z1mq422bsyV3Ri2LU/MmJQk+iry3sPJawbH6CZpQw1NxQuINDRjOfcRPD0ld1IHF8lqCRKI7Z539COKphpNyxH94=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 6:09=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 11/23/26 19:53, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > The behavior of updating the folio's access info isn't consistent for
> > huge mapping splitting or ordinary unmapping. The page table's young
> > flag has to be translated into folio's access info.
> >
> > Right now it only checks and sets the folio's referenced flag, which is=
n't
> > enough since folio flag updates on access have their own rules. Ordinar=
y
> > unmapping (zapping) calls folio_mark_accessed(), and it also checks
> > if the VMA has recency to avoid false updates.
> >
> > So first just use the right helper here to be more consistent. Keep
> > accounting the young PTE as a cache access, sticking to the current
> > behavior.
> >
> > Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
> > Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> > Tested-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  mm/huge_memory.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 75e8641bf9ff..fa9f6d21e786 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -3122,8 +3122,8 @@ static void __split_huge_pud_locked(struct vm_are=
a_struct *vma, pud_t *pud,
> >
> >       if (!folio_test_dirty(folio) && pud_dirty(old_pud))
> >               folio_mark_dirty(folio);
> > -     if (!folio_test_referenced(folio) && pud_young(old_pud))
> > -             folio_set_referenced(folio);
> > +     if (pud_young(old_pud) && vma_has_recency(vma))
> > +             folio_mark_accessed(folio);
>
> Can we just have a helper that abstracts that? We pass in vma, folio and =
young
> state and it takes care of things?

I think we can have a folio_mark_accessed_vma(), and so it will be:

+     if (pud_young(old_pud))
+             folio_mark_accessed_vma(folio, vma);

Also converts a few other callsites too, also avoid touching too many
other folio_mark_accessed callers, there are a lot of them. We can
audit and see if folio_mark_accessed can benefit more by passing vma
from more places later.

