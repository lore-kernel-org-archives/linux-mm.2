Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B463CC531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 21:26:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89A406B007B; Mon, 27 Jul 2026 17:26:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84B386B0088; Mon, 27 Jul 2026 17:26:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 715696B008A; Mon, 27 Jul 2026 17:26:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3C4AF6B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 17:26:48 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ACABA1C0261
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 21:26:47 +0000 (UTC)
X-FDA: 85035841254.14.1BE1815
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf06.hostedemail.com (Postfix) with ESMTP id B4FD6180011
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 21:26:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bmPt0xiM;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of shy828301@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=shy828301@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785187605;
	b=znl+bm4DhM9Gy4PoO5zdfbSUWsIsfPj2jYgLIfQtG8rWoL4v1Bcb0G38RIe0szOP2xIL4P
	S4az1vecx4+n1JOuPY7Ve0t3pKAcsfN7RGnDN4fLdP3OFw4q9R8Z3cbKkrTUZY0l/HyKIP
	DkJIO0nhlnuDoswQWWPH0NsTWX6yhL4=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bmPt0xiM;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of shy828301@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=shy828301@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785187605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N9bsPZ3HZQvmOrzVVgTiiLwY68paYMuFlINsGlL75lg=;
	b=cVFeYxJpox954e6RYzYEk/66YP78Pjq3adeDCgBB9VoTBSg600d0a07H3RZYNgpY38JwY1
	EttygkA3uVSD5yT8/6iQIs0Yb2Tp28EYC0mvPchKKMX7SkNT5QZY8HBHdn2L4xrgU/0oP+
	PMjb7bMB3TavrD12dI87QW3deGlICe4=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c15d3cd51b2so410251166b.3
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:26:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785187604; cv=none;
        d=google.com; s=arc-20260327;
        b=ICXSGQAYpGZXDCXkaAsewN6jGZ27LoPpi1SruPJ5gz8Nb3AH5Atonh8avezXLdAHMu
         P9Ap3QWJI188j5jevkkhJupBfl/x83eyB1kAqKtgymLyAfHLwAUsFPQ2HhRmJF+o97b3
         B9cLfoJTc2F5KiFIhftKMA7BXFaFtqhM7UrnfwXBEX9bF0r38ihn4By1WzttaRsIauiE
         jT5z/9npI2jfL9fxCTSiR9wn0Kf3iboJTQVFZbqJ1DJALT/DNWMSNXz7mxQNrTGQ+VWm
         T4HHVXQrvQEJ26g7ngfyIIIGErKSSqtUmzFBVEPuMIB59GbJmIShXi7M+dz84SImcTG+
         V2cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=N9bsPZ3HZQvmOrzVVgTiiLwY68paYMuFlINsGlL75lg=;
        fh=sbOhvPj6wsIv6lGUHl5XxlYCDpAzuulJuKMBr0ttGP0=;
        b=BB3Gjx3zae2YRtJKagA8aoLllqVNYwg+JRlyW9E+LiZjQLqateBNrAKI+8ZGCbDMBJ
         eHNIPa7kTrZM1NIfc480YdmsajokQLe7E7mLkSZEKljOpLj72BaMzgzFtl3vVHgRRRVA
         7XWOgoTFjZFHXoGDI2H36Y5p3RSkDE0R8zJMnts4orhJT43dbJKNcpbMc29YoaQcOV+d
         I7DN3/Cf3oQU4vQIv4pI+wMFw1w5T/eXZDxLNG8wbSnk5TjIqDZHTbc1KwCGUdDsRZgr
         4umEuX3QHD9Lja4Okt1aeCogv4GfRSSt7J8NdKaPkK5PPqPtuTGUpHqtRqUEPe1rwfwW
         +Diw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785187604; x=1785792404; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=N9bsPZ3HZQvmOrzVVgTiiLwY68paYMuFlINsGlL75lg=;
        b=bmPt0xiMh24gAbmCahDWGeM1HYfBFPgy2WGjq46WkLPBQhywZodmQBRy9ZhaTV9Z1J
         FkglnIGV3lKxnUejY4Deo5PdT7/qwoBIw2Ks1eUvhmWNQqDqLLDWMxs35oCCi+7knpQn
         EZ2Rv0gWXWEWbeHxp02qMMGaKdV2u/c4hAc3KmmlgOvqa0CHMx4lvE4sv3GjtkTZHPDj
         w5OG6IH1IsJF/9/eSdA4nzvwP/QLVwryvFl5LMNvX5uwvWiQ8Xlfms5LyunQP82PPdI3
         jgkzx4ZmCqbUGu5llmhseolbfUk18dgGGPTyz8fH1LJ2UvFC4Zakd0Xz4GNH1jOJR4x9
         nHCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785187604; x=1785792404;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=N9bsPZ3HZQvmOrzVVgTiiLwY68paYMuFlINsGlL75lg=;
        b=E+eajMapoXMXpfvCl6pBKaweeDn+ZmHpW8womI5u86875IApdUCl28Enrqhd1pD2hE
         TMUOgcj2MnUM4o8TLFm9t1iwRi3nDwt9JEuVI2vUuSDkHEo8ufqzp3YFHOXgNW9FtOkq
         4dwoO0EWOT5XS1MHmQbqsuaGr//lEnBlUWxAB9dZPp8PprN65sCcY/lv4Lu5wUUMw3f3
         6Ibz/qe5685jVRzuHOj5hhdafMMpaIS/0QL+dciiU4FVEwhyq+55FqfqVfuNM9hoDule
         88iU+qUZqeji/RaE0KmDqSLbx5/tZrZQZwIGhS7SHNnj+nCxDwtJxAD+nhH+EgrMfnaG
         Ibrg==
X-Forwarded-Encrypted: i=1; AHgh+RrtkJ4T9qU2Pq3YybkJpA6GCgl3IOPrJxDZ82INKeNck3UjBMdcqlQB/2VIlb7+3+ussgs+Ltq8PQ==@kvack.org
X-Gm-Message-State: AOJu0YyOczW4urkvCQgg72VVu2Zj9IHCLmKOrLVvnfKSFseScN5jYjOY
	/tEkiAD8sGZuGo1d3cTdnodp4BCqAY3cTjNOJgS9S00LUFMgfx2k7WUvhYBUtqbKGTVeohA2Sdh
	oROYCYGQuxUYzXMWbSh8G5m09paI95O8=
X-Gm-Gg: AR+sD11rMpNkpP/o65ruk6hpbrzvPtmrP8hqeADgrr0NtWeFO0qCbm4JrY267qMNKmh
	qVvz+TiwQgegStcTKc844Mv3Dw7EYCntX8QkkdocIBiAZMyJEim/WUMEg6mMiin4Oq5KAYEhIzh
	bEnZNLJnwOSWvpTro7QSqXb25r4ZOawXP7htIEVrh6DWw9+7cwNgnDCBQD/OhVqX0rh32gQUZmX
	WsIRIjBp5PnKOH5B1cBXgOcjgIz0cHnECgFii3MJNFCO5GELhgDviX+
X-Received: by 2002:a17:906:7948:b0:c1c:26fd:4f31 with SMTP id
 a640c23a62f3a-c1f1eeacc9emr434831066b.26.1785187603944; Mon, 27 Jul 2026
 14:26:43 -0700 (PDT)
MIME-Version: 1.0
References: <20260720-b4-scalable-cow-virt-pgoff-v2-0-2d549757a76f@kernel.org> <20260720-b4-scalable-cow-virt-pgoff-v2-13-2d549757a76f@kernel.org>
In-Reply-To: <20260720-b4-scalable-cow-virt-pgoff-v2-13-2d549757a76f@kernel.org>
From: Yang Shi <shy828301@gmail.com>
Date: Mon, 27 Jul 2026 14:26:32 -0700
X-Gm-Features: AUfX_mwcnd_-Gd85nb0fGnZa3ykBWA_00Dmo7Y127h_GI4bez2zlh-yWo1OAW4w
Message-ID: <CAHbLzkrCjALeXSuO7dgho9=W-VZQxD-CXNS8iOva=oCCi1XV1A@mail.gmail.com>
Subject: Re: [PATCH v2 13/15] mm/vma: make MAP_PRIVATE-mapped /dev/zero
 mappings truly anonymous
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B4FD6180011
X-Stat-Signature: ct8stqd8z8uecf88s5tcre6jpno81c53
X-Rspam-User: 
X-HE-Tag: 1785187605-278740
X-HE-Meta: U2FsdGVkX18LIAD82XZr8qTKQhHhBfFtC8W3400ZJNROCFDmNlwlXkYZlOPxGz+2x0tW7tx6FJJ2WLxWwMp3rxKokWlt0IJPAXSTdjW6scF7uB6d8+mimKK+FjCUOXNtOsXf6YDDUj9jWM4a9o5JzKO6usrpAS5XG/y6gG9lPlObgLaLz2wiHZ6SJyOETvW8VYva/YRjRqcuNiR6bT7i3cQr62KUhFxWFFn268S3KieAxNoV+rzWI2RMuG5pKOxY3AOspbrcTjMnklzbbcSCwy0sWFvi0knAXiq0KJqcV6rwI503meHWMl4/t97hNnwxkMihASooKlUHp/s9szFn1/jlsT08P9rr87skU7lB6glhHFfuQUUx1wyDln/WTv/DEr989IPxrKEKL3o1PeeXIP843oRs87NzKITlFccu7ylTVUvM7rKnrMDBqJ+RyqTt6cJ6YtUh6WrnocLN25wipvFb6OuR2GQrirCjhI4rf9mL8Bm99oZnibmd9xOElnmwRV4o/nAbTey7Kf8NUolciR24rSKea7wr3edy9E5Phzj3JHC3rgrPm5R3FyBi5ZfDuhbGcpNLSza4Sg+c4iPayjhW/wLpYgaID9JcLZb9chu6FMqe0SI+12imOArREBwz/EvruQESg4k0i+Od98EPjUPE3qYoVeIFBFJMsVqLgc4OXo+Egxgy2BFgzkdeQlAt3QLp7uGaeHRUi5KCn+eNtCBaLs7s+D9oy+JeOARZwYm45vdO6A1x776LGHqtMLgg8od5/rkqQlTxLpXVlWUBfQm4zpfgNVSeXzk98HvteAEhpnVduwA07PT8i66dlBHQyxuH+hAZmKDP/0WG1W+l6zpSGjGcrmfTz3BnQfNZKc6TCdCbQAlTUUcTHoTXb+jLrhvRk7fVMsNciCc4d64MN1vu28SRNIgJc6MvOljevGaDWzVDEQlmcpP2ZmbFAhcVt8e5XZx/MCZo2ktPw6z
 3wyMhpNC
 sipOoWx4py0CSvHWs800D6gNOS/jpkB/5OmB7ANkRwYL6Zb2fUPftCUafy4toEQ2j1MUW4l6RbRcCRrDpDNcT8tVNhp/8lzbyCssoMlKEKA62VKaoFo/RgLIyD31/q2AUu4SfKzBW0nevep51Rc1GCWRlxeuhpLeVrfD9zcdtgux/6I81vpXW26y8r1xtHBQudaofJ/tDo8xeKA/mYeaRoDjexFWHkwoSmm/np4ptc/Dke7gUMlxqOmhk8gGpArFRyV1zkg+PLk/xv8b0/uYHX0yyI6PXmURNv3C3uB2qYhufXLJoz2dReJKCZiKZw7FQHxmktQMY4JS+zQF9UYHWcOhcstAzgcEHRTM13J88gA6leFffwb86jcTJ98fd3TEebN0nHB6PSSqCi0XiJFUBEBDCrcfjcgnQ4cNjgSPYGaeLEizmWAj/7gRKSIjZr8rEqX2r2eS/KsjGGhKD9wSck3yIum4IjqvgSc6RSQP1TnBbUdHfSxr0YeSuSnUSPwViBEQSrc8vWXa9WPx1jRdvHlxLv9JJdHkEP0JB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 8:30=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> When mapping /dev/zero with MAP_PRIVATE, one ends up with strange VMAs
> originating from Linux's distant past.
>
> These have vma->vm_file set but NULL vma->vm_ops, meaning they satisfy
> vma_is_anonymous() but otherwise resemble a file-backed VMA.
>
> The introduction of virtual page offsets and their subsequent use as
> indexes for MAP_PRIVATE-file-backed mappings mean the rmap does the right
> thing with these but we are left with inconsistencies.
>
> The vma_start_pgoff(vma) =3D=3D vma_start_virt_pgoff(vma) invariant is tr=
ue for
> all other anonymous VMAs, but not these.
>
> These VMAs are also observable as files in /proc/<pid>/[s]maps but
> otherwise behave like anonymous mappings.
>
> Therefore let's make these VMAs actually anonymous at mapping time which
> will activate the anonymous code path for mappings.
>
> This means we no longer have to account for this discrepancy anywhere and
> no longer have to think about these at all.

I'm glad to see this is solved finally. But /proc/<pid>/smaps will not
show /dev/zero anymore. It is user visible. I recalled you were
concerned about it before.
https://lore.kernel.org/linux-mm/c98f68c1-4bfd-4410-9b65-1eb5a1efe271@lucif=
er.local/

Anyway I don't think it is a big deal. It should be harmless. I would
be surprised any real life workload would care whether the anonymous
mapping is backed by /dev/zero or not in 2026.

Thanks,
Yang

>
> A previous commit gave us map_is_dev_zero() to positively identify these
> mappings, so we expressly only do so for these alone.
>
> The impact of this change should be low as likely very few are relying up=
on
> this in any case, and in using them are asking for anonymous memory, so n=
o
> longer seeing these as file mappings in smaps should have no meaningful
> impact.
>
> Update assert_sane_pgoff(), the comment for vma_start_pgoff() and
> linear_virt_page_index() to reflect the change.
>
> We make this change in call_mmap_prepare() alone as /dev/zero has been
> converted to an mmap_prepare hook and we do not permit nested MAP_PRIVATE
> mapping of /dev/zero.
>
> We also remove the now defunct vma_desc_set_anonymous() and eliminate the
> temporary bisection hazard fix from the previous commit.
>
> Also update the VMA userland tests to reflect the change.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  include/linux/mm.h              | 10 ++--------
>  include/linux/pagemap.h         |  3 +--
>  mm/vma.c                        | 26 +++++++++++++++++---------
>  mm/vma.h                        |  3 ---
>  tools/testing/vma/include/dup.h |  3 +--
>  5 files changed, 21 insertions(+), 24 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 7614afe99c96..7fabe6c66b4b 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1554,11 +1554,6 @@ static inline void vma_set_anonymous(struct vm_are=
a_struct *vma)
>         vma->vm_ops =3D NULL;
>  }
>
> -static inline void vma_desc_set_anonymous(struct vm_area_desc *desc)
> -{
> -       desc->vm_ops =3D NULL;
> -}
> -
>  static inline bool vma_is_anonymous(const struct vm_area_struct *vma)
>  {
>         return !vma->vm_ops;
> @@ -4352,9 +4347,8 @@ static inline unsigned long vma_pages(const struct =
vm_area_struct *vma)
>   * If @vma is a MAP_PRIVATE file-backed mapping, then this returns the
>   * page offset within the file.
>   *
> - * Edge cases: nommu does not abide by these, MAP_PRIVATE-/dev/zero sati=
sfies
> - * vma_is_anonymous() but has file-backed page offset, and MAP_PRIVATE-p=
fnmap
> - * regions have their page offset set to the first PFN in the range.
> + * Edge cases: nommu does not abide by these and CoW MAP_PRIVATE-pfnmap =
regions
> + * have their page offset set to the first PFN in the range.
>   *
>   * Returns: The page offset of the start of @vma.
>   */
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 3307c0551a0a..4e8b2b29f6d3 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -1136,8 +1136,7 @@ static inline pgoff_t linear_virt_page_index(const =
struct vm_area_struct *vma,
>         const pgoff_t pgoff =3D __linear_virt_page_index(vma, address);
>
>         VM_WARN_ON_ONCE(vma_test(vma, VMA_SHARED_BIT));
> -       /* Account for MAP_PRIVATE-/dev/zero which is only semi-anonymous=
. */
> -       if (vma_is_anonymous(vma) && !vma->vm_file)
> +       if (vma_is_anonymous(vma))
>                 VM_WARN_ON_ONCE(pgoff !=3D linear_page_index(vma, address=
));
>
>         return pgoff;
> diff --git a/mm/vma.c b/mm/vma.c
> index 103a6a134dec..d3e0457a11a1 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -2622,6 +2622,13 @@ static bool map_is_dev_zero(const struct mmap_stat=
e *map)
>         return imajor(inode) =3D=3D MEM_MAJOR && iminor(inode) =3D=3D DEV=
ZERO_MINOR;
>  }
>
> +static void map_set_anon(struct mmap_state *map)
> +{
> +       map->file =3D NULL;
> +       map->vm_ops =3D NULL;
> +       map->pgoff =3D map->addr >> PAGE_SHIFT;
> +}
> +
>  static bool map_is_private(const struct mmap_state *map)
>  {
>         return !vma_flags_test(&map->vma_flags, VMA_SHARED_BIT);
> @@ -2629,10 +2636,7 @@ static bool map_is_private(const struct mmap_state=
 *map)
>
>  static bool map_is_anon(const struct mmap_state *map)
>  {
> -       if (!map_is_private(map))
> -               return false;
> -
> -       return !map->file || map_is_dev_zero(map);
> +       return map_is_private(map) && !map->file;
>  }
>
>  /*
> @@ -2664,7 +2668,7 @@ static int __mmap_new_vma(struct mmap_state *map, s=
truct vm_area_struct **vmap,
>
>         vma_iter_config(vmi, map->addr, map->end);
>
> -       if (is_anon && !map->file)
> +       if (is_anon)
>                 vma_set_anonymous(vma);
>
>         vma_set_range(vma, map->addr, map->end, map->pgoff, map->virt_pgo=
ff);
> @@ -2682,10 +2686,6 @@ static int __mmap_new_vma(struct mmap_state *map, =
struct vm_area_struct **vmap,
>         else if (!is_anon)
>                 error =3D shmem_zero_setup(vma);
>
> -       /* Temporary MAP_PRIVATE-/dev/zero workaround. */
> -       if (is_anon && map->file)
> -               vma_set_anonymous(vma);
> -
>         if (error)
>                 goto free_iter_vma;
>
> @@ -2814,6 +2814,14 @@ static int call_mmap_prepare(struct mmap_state *ma=
p,
>         map->vm_ops =3D desc->vm_ops;
>         map->vm_private_data =3D desc->private_data;
>
> +       /*
> +        * MAP_PRIVATE-/dev/zero mappings are an ancient way of getting
> +        * anonymous mappings. Rather than allowing these mappings to be =
odd
> +        * outliers, simply make them truly anonymous.
> +        */
> +       if (map_is_private(map) && map_is_dev_zero(map))
> +               map_set_anon(map);
> +
>         return 0;
>  }
>
> diff --git a/mm/vma.h b/mm/vma.h
> index 94277837ce6e..44fbb50dc3fe 100644
> --- a/mm/vma.h
> +++ b/mm/vma.h
> @@ -267,9 +267,6 @@ static inline void assert_sane_pgoff(struct vm_area_s=
truct *vma, pgoff_t pgoff)
>          */
>         if (!vma_is_anonymous(vma))
>                 return;
> -       /* MAP_PRIVATE-/dev/zero is anon, non-NULL vm_file, but has file =
pgoff. */
> -       if (vma->vm_file)
> -               return;
>         /* If faulted in, could have been remapped. */
>         if (vma->anon_vma)
>                 return;
> diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/=
dup.h
> index c617ee2532bd..c5191b9718fd 100644
> --- a/tools/testing/vma/include/dup.h
> +++ b/tools/testing/vma/include/dup.h
> @@ -1648,8 +1648,7 @@ static inline pgoff_t linear_virt_page_index(const =
struct vm_area_struct *vma,
>         const pgoff_t pgoff =3D __linear_virt_page_index(vma, address);
>
>         VM_WARN_ON_ONCE(vma_test(vma, VMA_SHARED_BIT));
> -       /* Account for MAP_PRIVATE-/dev/zero which is only semi-anonymous=
. */
> -       if (vma_is_anonymous(vma) && !vma->vm_file)
> +       if (vma_is_anonymous(vma))
>                 VM_WARN_ON_ONCE(pgoff !=3D linear_page_index(vma, address=
));
>
>         return pgoff;
>
> --
> 2.55.0
>
>

