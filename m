Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD48FCA5FCE
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 03:30:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F9756B008A; Sat,  3 Oct 2026 23:30:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AB526B008C; Sat,  3 Oct 2026 23:30:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09CD26B0092; Sat,  3 Oct 2026 23:30:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D482B6B008A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 23:30:45 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4EED8A7BA2
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 03:30:45 +0000 (UTC)
X-FDA: 85283516850.22.27C6C27
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf13.hostedemail.com (Postfix) with ESMTP id 657D120006
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 03:30:43 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sfEEvaQ3;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791084643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ocMEG1JQitysYEbxaeOoYgeb6SO1YjUdEbtsSzCE3S8=;
	b=xZWxD+ZY6aOHj5eiwpcXxBbFpfYEJi1zKxnwU1FlN2gIAZYEsCLwk1UbyoWIBrrM1PA6vs
	S3fDySReN3hIKUj60mZ76HwplONbvSKkxEI/tvyxxQwMMHTIzf7Oqma6wfWrssFzaQX5/w
	jOEjm3PUqF3KVNS9egrY/NrsvpvkQpk=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791084643;
	b=TdJenoVlua2sGJdVUcHGKh7JmXuWzNuk72UV8MZq1JZYpwjJzfl1S+14Rq7hLoisOrh4Hu
	8cnH8ddzOoFGXxydToovuDjqlqsQArsGBwZGevffR/eah37G4NLNruHxglaTORSNHsLw/d
	CTz/QpqqEKjjByPx+t5vYN3iLE3/d10=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sfEEvaQ3;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c2e2db5e8e4so146777466b.0
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 20:30:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791084642; cv=none;
        d=google.com; s=arc-20260327;
        b=SSmnvgoKgAAWHN6mRpJpr8/M5nLdMbEdhI7MkwMFuiqvUBrdsf5QqiCsLGysCIsfum
         YPsAhiw6hlY2S2hy9ckSlCSZ++Z079WEhYKKFFhSONieXRf93it9VM6rm4seDaK9AHV2
         /sX+n8MZpz3jVUoyQ7/s6MBLXIptkvUMclua+vHPx3KcUPosCbWtd+McyGq/t+Jh4K5s
         BmqDwyaKzBP8fE/+uF2/Nb6Ap+PtY//JE6K9cKkXLRCXhQO91e+0LRKw7keS74AEfeSt
         zfqeaVhyex7jsuxQJl/hg71NC4mLjmSIYi4bqkmmmudjNUtS6Hzyo3zbiuc+GMI0/MBQ
         SyvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ocMEG1JQitysYEbxaeOoYgeb6SO1YjUdEbtsSzCE3S8=;
        fh=BYbSZK/dsSzAuShYTml8bxibHfN7B4JboFOsNh+LioU=;
        b=qdcf4Ntrvrw9qa6WoKto+iK80avIouIkyCK/MmgaMBtiKoTDds2VbkwT2B8In2aR4m
         8xfBKjuKL3CyF7sjbc7pk3jWKiokeMNZHG0rR2ClwDsjUGpFuF8HYWSaSbzWz0f3vSxK
         JKcVlgdX966gmStzafDNMbgDGldJAuRSV12zm613jsKHA+QO8zNtLmzBZcF64YNoNlIw
         kHuqwxeh5EFFJLy/lFK7jrjCjPOhY9Q7d+VVLV0hhXSQ/WZ1T5x4lGvmb/L7uShsPUzH
         naGa6c+x9Hu9xYSrJSZ/0tMFGxMYAgWAY8+BB2tUPRovrtLVZO42yXFfEBhslHcLndEc
         ZjNg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791084642; x=1791689442; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ocMEG1JQitysYEbxaeOoYgeb6SO1YjUdEbtsSzCE3S8=;
        b=sfEEvaQ3h/FnOOAbTi0Gf+FgRTmT5YkmARlJxaoJwX9BUT72aBTjthLEhLK+4qdEyw
         P+be4CYeMd9tnqA6/asRlS45qeJ5QNrI26+Vb63DbOqxiIt8ALo3xjT543esknRicxZQ
         HqxPak5uZwu0mjImZ2LfeCTGC7hN8nFDkC9Cdv3yk8+gwXQsVmc1DxMA7QRJDznp3UQ4
         bNSV6bujxv/JQG2zJAAJMeeycB/F8l+d9Fs1v17R4TT/79/4aCjD0vAZFjYc/2ME9vQa
         b2pYR2z1LfWr46Cvv3TjDlCUt4qC1oCSit+5PtZ5IxjPqLfjTdpZM5VUI8dp3fXtxh7B
         mmJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791084642; x=1791689442;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ocMEG1JQitysYEbxaeOoYgeb6SO1YjUdEbtsSzCE3S8=;
        b=U1uSUDkRYBxliwQj8olcaVy9iYiVAt3i5AOSiZbnrkK5xejk+T59GRPpvBy9Mru9eO
         LDXIvDWXPot16wF38aI1/hR18+QVWVxAijb0cL8R8U6QxQRPx/d3m5prGOrP2dmnsVEm
         IdkXmVc6uYP8UCJklPBbZ5DMqY7thlyJcx+A+2MgfByeaSw+C5GEIKkMblN3LpDDdErQ
         /ASpIzHcJskJnnQf0vWgrojv3kwUNURfrWwWkJSj5abTHD8v0EaQUWylkaoFeDuGGUj4
         XvMof4i7O31pZgGnGRWRmeDRiIC0E99FQf20xY8FOCUCimOyGjf9/f4CWTQ44pbiEzjc
         3ZBw==
X-Gm-Message-State: AFuF++njOtW/iooLVC3neA/OxWPuOYvUa3cQl7v1OL+pvZQGdez/Jos5
	CA7yPJ8TQl2ZYfwYOD1FsJyZlU1aC3bZvBcfR7DoTx3p9baDYi2myNjrCQYKWYlqBBf6xh8Pobv
	sKwOxzrWr6dYugS/OiQXPNYNgjurMTe8=
X-Gm-Gg: AYBFou3nXd6ObiEBT96lWHYfZhh0DqwD8WU7QKazFLz1+njHaWHUE+9vFbU3hvpIQls
	Pop/F7YUX32bi0JYsgibZcDMmmO2xTOLbyjeXPD/ax1p0sjPqWTfUrdF/afrfESJqIfcVmohqrj
	+Ick1NS82zW/UpMijkVIWdoMliD4OQhUuPfhCcWUmc2t4uA+lZO+SS9CcQQnoMV14x/nnw/y4Lc
	lhkYrzGQWPe7xShacKTGo/R0ICWBja9iI5sdCtz/hWT73P/1u8wQaKcGIrc+dqydgwH0r8yFrsA
	qnBMPY5te7t4/z9bWeFrR15zT4FpBy+CJoMlYj8zTU/Ce2IOZtsMAyIswYuX2jSaGIwkHGPt3U2
	VPdsmvb1hrLrpn6cgDZU=
X-Received: by 2002:a17:907:97d3:b0:c29:45f6:6a0b with SMTP id
 a640c23a62f3a-c2e6edba366mr293421166b.34.1791084641659; Sat, 03 Oct 2026
 20:30:41 -0700 (PDT)
MIME-Version: 1.0
References: <20261003-mglru-fg-v3-0-cbd4546a5bd9@tencent.com>
 <20261003-mglru-fg-v3-15-cbd4546a5bd9@tencent.com> <DLVOTZLINBSQ.2FBQBO7G548GA@nvidia.com>
In-Reply-To: <DLVOTZLINBSQ.2FBQBO7G548GA@nvidia.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sun, 4 Oct 2026 11:30:05 +0800
X-Gm-Features: AclHuK_0vu692Azs09lD-vnP7S-2xAgVgXDUAR3MwsA-IVgdqMPkuZxdr53J7D4
Message-ID: <CAMgjq7CNpFbtU5X5bhjMFgb6qcgw0yuLbw73mKOCkE9tpMohkg@mail.gmail.com>
Subject: Re: [PATCH RFC v3 15/17] mm/khugepaged: check folio referenced state
 via LRU refs under MGLRU
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh <ehab.ababneh@intel.com>, 
	zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>, 
	Kunwu Chan <kunwu.chan@gmail.com>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 657D120006
X-Stat-Signature: 3kbit76ccm96tzu9xzzymjkcd8hcwj1f
X-Rspam-User: 
X-HE-Tag: 1791084643-826853
X-HE-Meta: U2FsdGVkX19RyNyY8rn4Qjioa+oPYdm+HafKVAyNAUC7lnNddNkjuB7d7PcQSZIqrNwdxZF5YRQ7gWNzob3FiuoslVKcN4OBsBtup30VGhN1S+GVt7JyV5SQIdhURBBq1vHI5ABK7vJGpTKLkyFOT1MPLTBn6Oe8DE8c+jVO6RhbTdHjpVAvX8SvkhpvTp9YwvpP5+GXt3SozIqVCB9a/yOcB+0ijag1Nzuxe3okxLoF6+wxhdiwbBxeUzbaqquBmpSKBBoSO13aWHxbOCu8Wy+wpmqX1GEKW0zrTfwUX+c1UUoZJtWtRGdTDU6cDlJtix3dxZ/kTLvPG3KK96u9i5GckJdxoLbrJMSpEfKdVSiJtcowp6uWLgwgkq3DXtofDTRsBX0PNGDOLZOzASQo5zBkdSq2ndS2B3TlO0x0Q0zGxYZnQyDwCcJOrDFgS9h6fgVN9DnZTa2Klji/JAnx5BoBCFGN77wKEWrx8LjyXV1FuxzXGZFv7Joj7MouabQnifhKOKaIjO6ihsa2ztmvLFF7NeYScr1vqTi4c0P12vCRqj6uszTPspCiRzHJIiZ00P51LsAQJKY2KBjba3PlEov6Ws+47Trc+ftYjcSB8wCS255TuY3WDGWiTcNmGlMXhWBo1wFncKjJfCy3oZbtlKJgDxku+6giaeNaRk3gLHA3ygMRKPXmaG6vADGt6ASAgKj0SsJEMamk7ix1xs8FMDZTPcQLptmQ/H1PsJMbrHE4MA5ZlRDFCwX8hjz7EVA6/sy5s5xRhEYWZbbX6tVI128HSTMhKQ5ZXSVPRuWMjPdrNYs2bcVk+nfN2z/OCx2XA0S6DuMua9qaYDijZ8nmNpZ5kL9kxPAhzpjtSPdXmp31xLcvHOgYrqZanjKaMCQ2yggg8jMPBH1na1twXpJbHkJHOuw/NoOY9CXJM6hqVllps/tphCYQzoNrKRrdcKhWpWUvkfLhp1OTJ2Rut4k
 os+0azkW
 PNigL8DgN0KLBj2RDusUaCesxCqQ1Thr+WSqMBM4KsqPnM0kEo3u7+YWbxk/RuEDMseWGUtZfkBNKIo9UB+a1M2Yap1reyFG+VdUpzukX+nodmW9YQKgX/UwqoPRaXIgogjOcd7C8FK+2/FrjJ3cv95Go94MfeZ4bmCBP+bXJ/ZxBR5wtsX6tT4MWeDwf/JvYq+HF4yrJX8gCFDa+1hjIlI455q9iwo2EI6POASn3vn2FNzILniw7K39ghLv4XoY2ag5P86W8eiU0s6PuM70R7PbXTGDKYL4PBot82m3EbE1HKRH3elQQ1jGNr/mc5LmBd6qm0ZPPswOeTAn2HJ2h74ku51mZIloNnN0yFbCDFwScR9eIawqRkNP6KLTUFT42d/S2q7plzToNZ0SKvN7a6VnkM4kJBC6gVkeMFA0knzFuRiA4V+0ayjoAU9qlafsGRfLWefEl+0B9bwudSSrrJHnPeSZJgyY5XH10i0LDwEk+YFXXHL9U/4Y/EvGa85QTBca1fhHBmJuc66FZpyftFwjIvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 4, 2026 at 6:11=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>
> On Sat Oct 3, 2026 at 8:55 AM EDT, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > For MGLRU, PG_referenced is only the lowest bit of the folio LRU refs
> > count, so folios with a higher refs count no longer have the bit set.
> > folio_pte_referenced() testing the raw bit misses hot folios at
> > refs >=3D 2, under-counting the referenced folios of a candidate range
> > and aborting otherwise good collapses with SCAN_LACK_REFERENCED_PAGE.
> >
> > Test the refs count directly when MGLRU is enabled, mirroring the
> > smaps conversion.  The classical LRU keeps the plain bit test.
>
> Why not reuse the smaps helper function? You can rename the helper to
> check_folio_referenced() for general use.
>

That's a very nice idea, will use that.

> --
> Best Regards,
> Yan, Zi
>

