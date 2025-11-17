Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74A53CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 13:06:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEBE36B0007; Mon, 17 Nov 2025 08:06:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC37D6B000A; Mon, 17 Nov 2025 08:06:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD91E6B0008; Mon, 17 Nov 2025 08:06:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 97DC98E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 08:06:16 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5BB531A0CFD
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 13:06:16 +0000 (UTC)
X-FDA: 84120122352.07.3519A83
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7276F180017
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 13:06:14 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EDBZ46tK;
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763384774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dzmClbvPyvBeE+q//jkriOQoEKo3zwFbzk31wn2QdMo=;
	b=YU5LWnSZmGfCPHSg+ck4aphT5AjglP+t7yx8HWeBh9WKTo4l5MTIE8EJ78QsB7ida6KezR
	16mEnDjDi1ymHju8gu9MsAgI9CfEev44tbPSCHwyYwulgTxW0a84uAMjU7IRPP30CNdw35
	dq047UcE6RCscCPYjreUzmekjftgmEs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763384774; a=rsa-sha256;
	cv=none;
	b=halgOC47gVyCy+SmbSvi1XfUmM6wiPnp85jrIOe/c09QJ4y27VwE8a4pYbMDSZ5cqagw5R
	Rav0eygo4B0dSPA7E2rQk4MToL7+sGWRWFwtxXfWUewYhr2g4YcbzuA0g/Vn1/7hhM6xw7
	+L5WrtHjW+l4ejQwoiyDIGbmDpwxZWk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EDBZ46tK;
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b73a9592fb8so99521766b.1
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 05:06:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763384772; x=1763989572; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dzmClbvPyvBeE+q//jkriOQoEKo3zwFbzk31wn2QdMo=;
        b=EDBZ46tKckn283JA08em9+7q2Zww1QNSpQY/y9B8HPqJ/xX3pCtWLdmM1BwIH4NCR8
         8tU7LtSGlTK47FBoRrjW53StsZ7ZpQycphs8wQqzjRcXMFrOSRzIGVlp4MjJT/42aQXQ
         z9mNz4Ga2pTd/1p3+6IKPqGI1rAJuCP6NBrMT5JZdvkF+3XFZVC2NjUZmlyFTyXPLQ89
         RBHrPuifFrZeBgvjtpabnLxKEQz+UKKp/I60LaabeCoYB9XLrTxeUUMJT3sIvPlEU8x5
         Whb8DRDF9t8DgSL36M+Txv0QAFguWeTmF7e1snLEm65XptRyrIEeahrbpHz8ZVFNnnE2
         e0tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763384772; x=1763989572;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dzmClbvPyvBeE+q//jkriOQoEKo3zwFbzk31wn2QdMo=;
        b=h6tyoHTabgmuyQDaCqW26GZ1sAIm1bx5rwEoqDevT047Wkdrz7IW10sAiM+MXphjxx
         xfGvy//5VE9iaGJqO5guqS+lndRgJwAFx393cbCAhMVTBOSMK4kkyGQKygiG7ah7DyDk
         0zagyDtAj0R5MVTb2IpsNkrttpTG/ck+0y0tFAZzzfS63pl4sX35/+9FboFdSa3ocw36
         xYQ7FwnHAJuUVuaXOnEoRaDnEkfMgWt4FtvsebcMZC5A5RDrujhE8uEBtbhBYOIiGzA9
         WhBumBEjaeUP6cuQYDRt/dthGVN6Tsgfev/39rJeAJ+LyE82NSP9THzDE8yueG+XWlzA
         LqZA==
X-Gm-Message-State: AOJu0YyaIqeg6yDvPR8jOtaan/B5sVgHdejXVc4M++ct9DG0gsZy8rJU
	hbW2i0oINOqKsFYS2qzYjr+kJ01q0YjhoXzOOeH5osfzSb/gtmAuUaugxw6mfDt2JEbixo4UoDd
	znZ8v/EYoN8bqch1zjGpXjuT7PCz8fsDZj2v5qzXdGA==
X-Gm-Gg: ASbGncuGq57+EAHfCOyFjvpXSy/+CUZJ5i6uhpbXuF3cFLT6YPPK/2QtMgEDvZ/YfA7
	W0wtyTXByMv7PvAGn/tzPPz73d6FxCcrYK/bKImjrhnkfn+P4DwkZ7fkY2D3trvQ7h/SZqL85Vq
	eaeOKMpNAoWhRSb6BhwKAGgCarCNCgP/clgsLrK6rhBU+NTkwENlCXMxL5OQzEVEIoIrHtT2jMf
	6N8sFt6Oydo9TqEvhvkDa++60xaleXKl/pa6b7x4r/s2yQH4+gJAbBVjmTPGsM8xMjOQBHQTiuo
	hRx/W1guQ233xGOStxnCGa/Zy+j9U/c=
X-Google-Smtp-Source: AGHT+IHqj3i2HRsibRzHKXf1dtPdvhXDhojSOWprepzSXOkYrPFcbb3l46Wk1jAyobY6QdZ9jWIdnMjC6+X5l2p7ueM=
X-Received: by 2002:a17:906:fe4d:b0:b72:7e7c:e848 with SMTP id
 a640c23a62f3a-b7348570745mr810309066b.17.1763384772052; Mon, 17 Nov 2025
 05:06:12 -0800 (PST)
MIME-Version: 1.0
References: <20251117-swap-table-p2-v2-14-37730e6ea6d5@tencent.com> <202511171942.psG9jTRx-lkp@intel.com>
In-Reply-To: <202511171942.psG9jTRx-lkp@intel.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 17 Nov 2025 21:05:35 +0800
X-Gm-Features: AWmQ_bnUFnm0x-eDcpgtaE3URJs_3MiIsOAITzpaSFBE-GfFvya8ZTJD0VLBPq0
Message-ID: <CAMgjq7BkVvhsCzk2r53159hDoZ+b+AvP1iUTBHA9zvb+SJFg=Q@mail.gmail.com>
Subject: Re: [PATCH v2 14/19] mm, swap: sanitize swap entry management workflow
To: linux-mm@kvack.org
Cc: kernel test robot <lkp@intel.com>, llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Youngjun Park <youngjun.park@lge.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org, 
	linux-pm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 91putxnkbu9f65rd941ygddgnw7mdxsp
X-Rspam-User: 
X-Rspamd-Queue-Id: 7276F180017
X-Rspamd-Server: rspam01
X-HE-Tag: 1763384774-470100
X-HE-Meta: U2FsdGVkX1/NGe4CWjcRDWUsRtM9RyNeooElY2G7nhD/diOCpCxULHcCQsP8hLnZcKi8XHhONu0NHgMh9Hj2Q3OhY1n+leVTC4KeiTe+dUG+IrpESmPYKLC3wTAnoIb32bJw+eQlPOBYF/JzGO6Q1bUO8k+539F1bP6LidhUoKWm1Co21xHtCPY10ZRaTk8BdIM/05UFo2Yqln9im5hbWO9Bd4a45UZj9MjjI7afUw8W4oXY8YcA91jB/0k69l+cTfeTJnC+WB9214QUY+mh7AjK9ZpsimnasnawD/nBxQxZOFXa/HpKu9Td7oKH3eJRqI5ziGVXxgeBgD2hiMpMvH9AxME66vTDAAMwu8dbJvgGWFmLcQG9oyWm5FTcfexTwrbDjTX3lB3R7dmV89xF4o/w1EThGtzKZD65sWeGcaE7z0SWtpY00Nn6b3sE70U7zwfzZxWZT1NRifW45Hm0BYrtn9oH5Y19dp3BYUAyu/E/D5cAYAwgK0aTLbM/5BrKZKO/8oIuS5f5zT+jXQnpRR6T+RNuZncQE5tDtKY7JnKRfT3jAuesx8uYWKVWsXPkqNYFoQujAd1BZo5/NLZztfD4fav9aSA0oz81lK8QzNBUgRTLXl9afJLsLDIeWc2jSoUIs+WcbrRvPC02dxqPzMT40R+tkKEbRv44iIsr8aKb0QZ4nQCM1BS2CRZnVMvZJZwO6J37doNZfModp83yC7QGwUfzPnODeSza/qKUEp04HDClhISaxhiaBfTn1oMroid/J2HzEQ5bW+MjE3J71MNyY4bIGs5jw5ESS20882URnyLw8KgLzBDyfs9XBEqvy9/Jl7T8Fxc3LkMi9EaFLh5pcL8jvdvQoI5R4Ob3AU18QjQxe8zXRUciYZNSKBzSPg4hUUeahvkClGznf0eKoFK8OpFucwoOCZXF2kCwREfODs+I1o5A5S+l/w5H+j9gBUlBmYmsovwDAsJIsif
 s2r7do5x
 6HdUaWmGaFPoKr8Ee0z+a0U+l8j0PAnHUfsGov5opbbDfgSUFgiTxI+cBv+O3nQa/sn7bLJRYzYXSPuCYQMU5jSt4dOoQke8365MxRzAKrYOB1KG4k8wN7sJ0sAxYqQUTwvauyfxY54nK20obXixQAWTTgKiRoQWj/uf/JprEtcT1/n5R/pBJmnEat+a+Ystm40DXeGZHhNEgSGkJWpuLZHjbWjZX69GjQmrrruhGmtW6XBNU8MzARofJzgY95C8kgMC81LFIlO1Z2WeENe5JgF7i7KZilkRTCNMnSyMXsDa5+Og1YPD2Ew8U/ozmL66gj3T8rBu/MWkhOwt165+SoRU0l26RCO7kx2gIEkaPmbPzmfEJtxTU23ZMScKnwAQ0vags8G2BDxVq+DIz6DsvJoY0m9p/OCTUJIEjPg9u+fsEndophJJw+OKQ1VMaOIIdrMnkCwh0qnVHz6AilwHMdg42HlQWuuw5OcDg49y2KKRYwenfI7rMdEDNDss+CUACLXDL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 7:23=E2=80=AFPM kernel test robot <lkp@intel.com> w=
rote:
>
> Hi Kairui,
>
> kernel test robot noticed the following build errors:
>
> [auto build test ERROR on 41218ede767f6b218185af65ce919d0cade75f6b]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Kairui-Song/mm-swa=
p-rename-__read_swap_cache_async-to-swap_cache_alloc_folio/20251117-021532
> base:   41218ede767f6b218185af65ce919d0cade75f6b
> patch link:    https://lore.kernel.org/r/20251117-swap-table-p2-v2-14-377=
30e6ea6d5%40tencent.com
> patch subject: [PATCH v2 14/19] mm, swap: sanitize swap entry management =
workflow
> config: s390-defconfig (https://download.01.org/0day-ci/archive/20251117/=
202511171942.psG9jTRx-lkp@intel.com/config)
> compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 0=
bba1e76581bad04e7d7f09f5115ae5e2989e0d9)
> reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archi=
ve/20251117/202511171942.psG9jTRx-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202511171942.psG9jTRx-lkp=
@intel.com/
>
> All errors (new ones prefixed by >>):
>
> >> arch/s390/mm/gmap_helpers.c:35:2: error: call to undeclared function '=
free_swap_and_cache'; ISO C99 and later do not support implicit function de=
clarations [-Wimplicit-function-declaration]
>       35 |         free_swap_and_cache(entry);
>          |         ^
>    arch/s390/mm/gmap_helpers.c:35:2: note: did you mean 'free_swap_cache'=
?
>    include/linux/swap.h:435:6: note: 'free_swap_cache' declared here
>      435 | void free_swap_cache(struct folio *folio);
>          |      ^
>    1 error generated.
>
>
> vim +/free_swap_and_cache +35 arch/s390/mm/gmap_helpers.c
>
> 200197908dc4af Claudio Imbrenda 2025-05-28  19
> 200197908dc4af Claudio Imbrenda 2025-05-28  20  /**
> 6539cf8c98a8cc Lorenzo Stoakes  2025-11-10  21   * ptep_zap_softleaf_entr=
y() - discard a software leaf entry.
> 200197908dc4af Claudio Imbrenda 2025-05-28  22   * @mm: the mm
> 6539cf8c98a8cc Lorenzo Stoakes  2025-11-10  23   * @entry: the software l=
eaf entry that needs to be zapped
> 200197908dc4af Claudio Imbrenda 2025-05-28  24   *
> 6539cf8c98a8cc Lorenzo Stoakes  2025-11-10  25   * Discards the given sof=
tware leaf entry. If the leaf entry was an actual
> 6539cf8c98a8cc Lorenzo Stoakes  2025-11-10  26   * swap entry (and not a =
migration entry, for example), the actual swapped
> 200197908dc4af Claudio Imbrenda 2025-05-28  27   * page is also discarded=
 from swap.
> 200197908dc4af Claudio Imbrenda 2025-05-28  28   */
> 6539cf8c98a8cc Lorenzo Stoakes  2025-11-10  29  static void ptep_zap_soft=
leaf_entry(struct mm_struct *mm, softleaf_t entry)
> 200197908dc4af Claudio Imbrenda 2025-05-28  30  {
> 6539cf8c98a8cc Lorenzo Stoakes  2025-11-10  31          if (softleaf_is_s=
wap(entry))
> 200197908dc4af Claudio Imbrenda 2025-05-28  32                  dec_mm_co=
unter(mm, MM_SWAPENTS);
> 6539cf8c98a8cc Lorenzo Stoakes  2025-11-10  33          else if (softleaf=
_is_migration(entry))
> 6539cf8c98a8cc Lorenzo Stoakes  2025-11-10  34                  dec_mm_co=
unter(mm, mm_counter(softleaf_to_folio(entry)));
> 200197908dc4af Claudio Imbrenda 2025-05-28 @35          free_swap_and_cac=
he(entry);
> 200197908dc4af Claudio Imbrenda 2025-05-28  36  }
> 200197908dc4af Claudio Imbrenda 2025-05-28  37

Ops, not sure why this callsite was missed during the renaming
conversion, probably lost it during a rebase as there are some
conflicts here. This should fix it:

diff --git a/arch/s390/mm/gmap_helpers.c b/arch/s390/mm/gmap_helpers.c
index 549f14ad08af..c3f56a096e8c 100644
--- a/arch/s390/mm/gmap_helpers.c
+++ b/arch/s390/mm/gmap_helpers.c
@@ -32,7 +32,7 @@ static void ptep_zap_softleaf_entry(struct mm_struct
*mm, softleaf_t entry)
                dec_mm_counter(mm, MM_SWAPENTS);
        else if (softleaf_is_migration(entry))
                dec_mm_counter(mm, mm_counter(softleaf_to_folio(entry)));
-       free_swap_and_cache(entry);
+       swap_put_entries_direct(entry, 1);
 }

Will include it in the next update.

