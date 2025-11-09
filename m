Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E2D0CCFA1A
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 12:49:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8A0A8E0012; Sun,  9 Nov 2025 07:49:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D397E8E0006; Sun,  9 Nov 2025 07:49:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD9FD8E0012; Sun,  9 Nov 2025 07:49:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A78488E0006
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 07:49:43 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5C16212D4D8
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 12:49:43 +0000 (UTC)
X-FDA: 84091050246.10.5321B27
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5D196C000B
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 12:49:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jPk2PPd0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762692581; a=rsa-sha256;
	cv=none;
	b=ha/ri8MqeqQolw2STYjNOgXBMNwO2LjYZPMUU6yiD7lUAa3Di3EoR3gbvlm1XOlYjuX8dP
	6s5OnHq2z+zBWNqQQMi0StI3P7mkVdyI0lMrmklnblgQDnl4A7HAEWW1V9wY+BHZH8NWeZ
	21MWt6jUS7K95G2arjtlV3dAkoyAyLo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jPk2PPd0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762692581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hDZ3xafdhT/YtTTUoql25uDvUJxupIOBYIVvt5riwwA=;
	b=6ARz1KeDRukdYYKK50swZnryBb3nIWfEtwsP7aYXdyyMF802UpfogRExsxBsgbN1Y6yu7W
	ZBVr5FVSvlQp16+/au14OrWrsrIUaKo0kphFRYzrNdMc3HFvreNGWkpyUrIKfAKOxR9kRc
	VBYRv+PyqR41/lBpBNld7vwGep38dQc=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b626a4cd9d6so337130566b.3
        for <linux-mm@kvack.org>; Sun, 09 Nov 2025 04:49:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762692580; x=1763297380; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hDZ3xafdhT/YtTTUoql25uDvUJxupIOBYIVvt5riwwA=;
        b=jPk2PPd0mcgZ7ME92J1xU6Er+2Mvp2WcPBVGYIm6u/vtQmUnrTnfmAPfNy3YB2vn1Z
         Z2Gw9S/JtS3bQuo0OLyufAP4H7XcENHSOhikOf/ZJFjgk/vzgTBihrhImIKmF+t4QN9L
         HFUjgNwwWHCzpV729uWDG4M0qxJrifK86Q7ruT1mG7B6JE5iRa/LrTTMU4gAwQDYtNAe
         l3x5FHyM5G9mQW34xWZQKWLD+62MSogqAYYXMNss2VBLEN/EV2snJENuJkk6BDtwiNtm
         qCU1sHm163KDkz6MvKljojcSj786t3eBwDmc0tXLRxD/SF4pRc/A30rZ8NmqqRpNJxM5
         JOGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762692580; x=1763297380;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hDZ3xafdhT/YtTTUoql25uDvUJxupIOBYIVvt5riwwA=;
        b=htpNE76fAE9cOOUiQBjhAwFkH+MuQe/TTvs3pl4jL9h75yX1rknF6KdkNKdSjzYmh4
         V/nR2PNBqxM5Rbww3S9qnZKX6y5GD6zAEkhaxAqONYg1v1YVxZ3r0Lzv/e6QAp+OHhPw
         ui8K6dO3TSG9Nofv0C5c5j6PFXOL7JFMKM/Ai2KXvZ2dkESgTl5t4FX6K7gYeHj9/uos
         Zq/mHrIhcR3J1jRErz3njruidF9WZg2rra128KDYU7VJc18QeFOSSyxQLYeCdZ/EkUuk
         jczL3/fPwVddUImd4qovv4Z54C8ybUJyso9UnRRMUF9qHNCO3CfQjaEU6UI5lRDvE9eN
         R7Zg==
X-Forwarded-Encrypted: i=1; AJvYcCWYF0K2H2WNvBjuvYMcc85dYGo3uuCatta3QViGzjlkW3GeSlY0vkaUGVglgPV86pdFaRRraCV0SQ==@kvack.org
X-Gm-Message-State: AOJu0YyfrOYXQxPk/paQjZ1Ll36dUFfj1PxxQSsvn0UpPtMO/4Sr9KqA
	ohYyFxQo4kYklnlzv/oQUceqQCSA6L6DcAZxDCRTvEIh9BHB9S4I3n6Z+3Ni+uILx5yFtxFnMWH
	M7raC4AGOmZHkhcfLvnAT4mLHdxL5K3A=
X-Gm-Gg: ASbGnct2eIRnwWw0ATEtz0tHrKxH6vCdHy5HeLoAs3TVgLeFk9su10d/I30SP5/Gh49
	lhlegBOd0e2w/o1pFx0cdgGJEXljgdogh6In0ZHO48legsoiylYM5GETwRpT7yIuQnxDeqXb5Xz
	haCyf50oinf1vseWeCX+FXNF3QO65nc6XGeK1aqSm0YirUSUeLTt1ioeeekP3oqKl2C3Ryl5HLx
	HwErqA5xaZIogjLCPq8DylfZHwg3gmRt1wAAernhE7Y8XexeJ24vDk0HtNc
X-Google-Smtp-Source: AGHT+IHNVHcrPcoXcfMQAdrM6mfxVNIvqirPfSk4ZwLH/WJQN1X+/EwZuiwM1z9Tvembh+GaQUpS/PpKFfhnQ7ESKbE=
X-Received: by 2002:a17:907:869f:b0:b33:a2ef:c7 with SMTP id
 a640c23a62f3a-b72e058a781mr441932566b.55.1762692579280; Sun, 09 Nov 2025
 04:49:39 -0800 (PST)
MIME-Version: 1.0
References: <cover.1762621567.git.lorenzo.stoakes@oracle.com> <75c2e8fa38de383757a49bcc3f5c081be1e27a40.1762621568.git.lorenzo.stoakes@oracle.com>
In-Reply-To: <75c2e8fa38de383757a49bcc3f5c081be1e27a40.1762621568.git.lorenzo.stoakes@oracle.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sun, 9 Nov 2025 20:49:02 +0800
X-Gm-Features: AWmQ_bm7gm65mOXTd2rtxZ-2sSA2POMXyYBKPT6giX8icbqtDuQMmyxTTsU5nEc
Message-ID: <CAMgjq7AP383YfU3L5ZxJ9U3x-vRPnEkEUtmnPdXD29HiNC8OrA@mail.gmail.com>
Subject: Re: [PATCH v2 04/16] mm: eliminate is_swap_pte() when
 softleaf_from_pte() suffices
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@redhat.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Peter Xu <peterx@redhat.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Arnd Bergmann <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>, 
	SeongJae Park <sj@kernel.org>, Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Jann Horn <jannh@google.com>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Pedro Falcato <pfalcato@suse.de>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, Hugh Dickins <hughd@google.com>, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-s390@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, 
	damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5D196C000B
X-Stat-Signature: n9xrpjjadqoaebzy5ajdebemnqzbmwso
X-HE-Tag: 1762692581-151348
X-HE-Meta: U2FsdGVkX18RPpnIIPakdPoUCW+hlnR/UaKULyHvuNl2pI/9i9eM3NUi/v+UdUyMh7JtA88b8hzRmID0l9yxixsEoFE7MydnXXNmCeyuxFkYztDHFvr57O8VdQ0S1peAadBP6bV1zYUdFN/GI1c1vOG/Zg2jdbgysArUJylu2qXzIMtpgqfp1cHmhjMP7+WJIO0I99sD1ayRaMsdfdEk/sj+VXYHiqA95MOczP5O7jsOGCqxM27IInHguL1pW3UyVJz+me+1UyxSSnzuqFFsHxqz+PgI8Y1h+NfneGE/eAc4xG3tB0bt98Rw+W1GNmClYoQKbcqRc8KOrgWrq/K1nKq+g+IbSLWlEgyk+5F+OYlHFh7W8V9VUVvQITnJaYAXWQwaglP4JfdhOgQAp92oLYNXCIku4dn+3GdMShtxAJbWSfl1o9PTJ439KBYwsaafWx5Aa4+LbparUXNcTgzITY9fRyOmoyVAeb5ZhG99vl9+zmChLvaLKkNKfBQmCgEIT4KN1cI92splkuae2Luz6p/4CnDIidDYK3jmM+eKMcdO7A9xes3iY3yIJZMED+YpGftul4Znfz+J1p4i8OqgamtrAKPfrXGvJWjs3B+p0neKABjl8LaXso/cIL9yMvHVmY8zAIdAUYp2O9/QsWC1dsS9acIlV/qMdf/oB+Wxw8GD8sArJH/eyTg5iATz38lF/oidT5MQKmBxKhrqxS1f2kwJnEdAuiloMC7S1Tfc6Pqo9/d3en/Q+cKdThjI1NLxZYwQNRuXQhJLf5a1X2FbcVH/swa73ifa7o1/DNW+3yBOFTPcovfEe5M/hELaUogkiXmb/ZM2y/ge4Rru+E8z6dj/hrFuqIeO506+mwu06EczF1FX4/lv05jraGEjbusJxCaM4XVxuEL8wXxqwapYCVuAIVIoEppPeMiRNOkkj/hejHvxqyZUZbghIqeMlCxtL2N4lYdYrFbiEv7JpI7
 de5rlMZ6
 v5axSWLGmt7sPhnBVnsmroZMXt1w/umjY9pWTI+brRIIBYV+zz+8RQwu7yY79MrhE3K6nRaf+NujjZxiH0xLl8XhoaeV/p9fiWf34axOLMla6EAlC6CccmwJvqQa0o76mWOJ8TYci/4S5QCzJ5q3ZWR7+hNbQOZpm3g0xOybBy7xedOLSam6F6NOvFXBv7x/Lm8vUYuvbYCKP0pS9WPFdsZHvdeFaUollItSOn0k92SIREP2d0lgFmZ3ZvyXsZVZS6zu5Y9zZia4rSNWLI45f5jKf/LqaSgc3oAEt5A5xO4L5SEXN7n77nTrgFmkPipgMSW8CFEZdNYrYNaYtSTiGaaKqlnDMs+SZc8C29S0daqP+k7ahiF/3Fp4GAt0mLveBHTPjSiDlmBB8SM89N8gY0P59E0dwbUxyHulU2PxnbD69+qiK5RR2ZQd9Y4oYtMbWxGm0hFsS/lAzTEqryGrZrfj1/hVLOT+xt3gkD5jxcbNBCQg5lsvbwpTpC8tMqzKgcDWk75biXnM64epDjfbZviiB8g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 9, 2025 at 2:16=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> In cases where we can simply utilise the fact that softleaf_from_pte()
> treats present entries as if they were none entries and thus eliminate
> spurious uses of is_swap_pte(), do so.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  mm/internal.h   |  7 +++----
>  mm/madvise.c    |  8 +++-----
>  mm/swap_state.c | 12 ++++++------
>  mm/swapfile.c   |  9 ++++-----
>  4 files changed, 16 insertions(+), 20 deletions(-)
>
> diff --git a/mm/internal.h b/mm/internal.h
> index 9465129367a4..f0c7461bb02c 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -15,7 +15,7 @@
>  #include <linux/pagewalk.h>
>  #include <linux/rmap.h>
>  #include <linux/swap.h>
> -#include <linux/swapops.h>
> +#include <linux/leafops.h>
>  #include <linux/swap_cgroup.h>
>  #include <linux/tracepoint-defs.h>
>
> @@ -380,13 +380,12 @@ static inline int swap_pte_batch(pte_t *start_ptep,=
 int max_nr, pte_t pte)
>  {
>         pte_t expected_pte =3D pte_next_swp_offset(pte);
>         const pte_t *end_ptep =3D start_ptep + max_nr;
> -       swp_entry_t entry =3D pte_to_swp_entry(pte);
> +       const softleaf_t entry =3D softleaf_from_pte(pte);
>         pte_t *ptep =3D start_ptep + 1;
>         unsigned short cgroup_id;
>
>         VM_WARN_ON(max_nr < 1);
> -       VM_WARN_ON(!is_swap_pte(pte));
> -       VM_WARN_ON(non_swap_entry(entry));
> +       VM_WARN_ON(!softleaf_is_swap(entry));
>
>         cgroup_id =3D lookup_swap_cgroup_id(entry);
>         while (ptep < end_ptep) {
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 2d5ad3cb37bb..58d82495b6c6 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -195,7 +195,7 @@ static int swapin_walk_pmd_entry(pmd_t *pmd, unsigned=
 long start,
>
>         for (addr =3D start; addr < end; addr +=3D PAGE_SIZE) {
>                 pte_t pte;
> -               swp_entry_t entry;
> +               softleaf_t entry;
>                 struct folio *folio;
>
>                 if (!ptep++) {
> @@ -205,10 +205,8 @@ static int swapin_walk_pmd_entry(pmd_t *pmd, unsigne=
d long start,
>                 }
>
>                 pte =3D ptep_get(ptep);
> -               if (!is_swap_pte(pte))
> -                       continue;
> -               entry =3D pte_to_swp_entry(pte);
> -               if (unlikely(non_swap_entry(entry)))
> +               entry =3D softleaf_from_pte(pte);
> +               if (unlikely(!softleaf_is_swap(entry)))
>                         continue;
>
>                 pte_unmap_unlock(ptep, ptl);
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index d20d238109f9..8881a79f200c 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -12,7 +12,7 @@
>  #include <linux/kernel_stat.h>
>  #include <linux/mempolicy.h>
>  #include <linux/swap.h>
> -#include <linux/swapops.h>
> +#include <linux/leafops.h>
>  #include <linux/init.h>
>  #include <linux/pagemap.h>
>  #include <linux/pagevec.h>
> @@ -732,7 +732,6 @@ static struct folio *swap_vma_readahead(swp_entry_t t=
arg_entry, gfp_t gfp_mask,
>         pte_t *pte =3D NULL, pentry;
>         int win;
>         unsigned long start, end, addr;
> -       swp_entry_t entry;
>         pgoff_t ilx;
>         bool page_allocated;
>
> @@ -744,16 +743,17 @@ static struct folio *swap_vma_readahead(swp_entry_t=
 targ_entry, gfp_t gfp_mask,
>
>         blk_start_plug(&plug);
>         for (addr =3D start; addr < end; ilx++, addr +=3D PAGE_SIZE) {
> +               softleaf_t entry;
> +
>                 if (!pte++) {
>                         pte =3D pte_offset_map(vmf->pmd, addr);
>                         if (!pte)
>                                 break;
>                 }
>                 pentry =3D ptep_get_lockless(pte);
> -               if (!is_swap_pte(pentry))
> -                       continue;
> -               entry =3D pte_to_swp_entry(pentry);
> -               if (unlikely(non_swap_entry(entry)))
> +               entry =3D softleaf_from_pte(pentry);
> +
> +               if (!softleaf_is_swap(entry))

Hi Lorenzo,

This part isn't right, is_swap_pte excludes present PTE and non PTE,
but softleaf_from_pte returns a invalid swap entry from a non PTE.

This may lead to a kernel panic as the invalid swap value will be
0x3ffffffffffff on x86_64 (pte_to_swp_entry(0)), the offset value will
cause out of border access.

We might need something like this on top of patch 2:

diff --git a/include/linux/leafops.h b/include/linux/leafops.h
index 1376589d94b0..49de62f96835 100644
--- a/include/linux/leafops.h
+++ b/include/linux/leafops.h
@@ -54,7 +54,7 @@ static inline softleaf_t softleaf_mk_none(void)
  */
 static inline softleaf_t softleaf_from_pte(pte_t pte)
 {
-       if (pte_present(pte))
+       if (pte_present(pte) || pte_none(pte))
                return softleaf_mk_none();

        /* Temporary until swp_entry_t eliminated. */

