Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CD4B606A31A
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 12:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eih7F8SG
Received: by kanga.kvack.org (Postfix)
	id 902C46B00EF; Sun, 15 Nov 2026 07:56:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B3DC6B05B0; Sun, 15 Nov 2026 07:56:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A2316B05B3; Sun, 15 Nov 2026 07:56:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4FF3E6B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 07:56:46 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D49D5A8391
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 12:56:45 +0000 (UTC)
X-FDA: 85437352770.29.2E65143
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0206E100003
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 12:56:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=eih7F8SG;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794747404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MPjxARwbhT7wpT+NldH9sgjHxyAG1kHYfbUx4elToaA=;
	b=hD8LfnWTV51xETSBS9yTV61aUKL95qQFz1cz/MbsDWS91JGF7Cb94ACKb1FM0EjYYu3XyX
	h6IfPkQrLsrcOYp4X/aCO48VqA34VMCRk+tVKt+5lCL1/i0UV0iAxGTVfnVJvJoBmGgShB
	ZMeKjUwjRvh+lF2WmFfWdsIAXjF+W78=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=eih7F8SG;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794747404;
	b=YcOI5g1W5FGuGM79NtO2gTaUmVVedDDRIIlVx28eSjla5SBNu6Htl9rXgEURwhsPBgBqI0
	PQ89emFYI7lmnHf6AlHR6SH0M/WV1wTV9JNu41CLLmoFU82n+GUfGn2Laun8CP2Obpiro8
	+ipZdW48UZHVmFa7XNonY4792Ozwh+4=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8b904d10882so983979b3a.0
        for <linux-mm@kvack.org>; Sun, 15 Nov 2026 04:56:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794747403; cv=none;
        d=google.com; s=arc-20260327;
        b=dDn0QT6v04dSDxJ8tP267gLRJMj5Ihjt2XndQNbQX2HTy3Tk8cXQjPz2oeR4wfu7QT
         2XEgK8RGTaffLplcEIv4uCTEcyTQtcAR8ijKgIxqxUzcr4PvquPoI1Q/672a0+xE8/kD
         pDElsdFiwh8NKoPj2AECanNqHN5k9amWthfuldpVe8kKqE7HAsFZebclcLL8cilgQYUk
         VvCgImBTy8+5+d0fc23ppRhdV+NN7XyK2PBqEnl+xHU7s5I111pzi1NVvj2NMOCOIJr2
         0Gw+PtGC/4fXVsf78+eJ1/FgYR45mX41Mx9kplICsbcgv/8YeKjrTcaKeB9H9CCuQl83
         G0Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MPjxARwbhT7wpT+NldH9sgjHxyAG1kHYfbUx4elToaA=;
        fh=THs5RMYEBlRkLa4IPsoXWzXTRTDM3Mmatw8w7VmLCXA=;
        b=NJnBLbbHm/CNoDFHlbfk52fk6jj/8UPmshlrWtapk6tbYBqTKVeos5CGAEYoxxG1Nv
         cza1vWYGhNikEBrNHdClia0ll7tHsgY0WFcsslKC9NEIZrNXLeBu1h1Jv2/2pdRqJ7Pl
         YXwtiFBClv6LUvob5gW7xtQuIHVkwn6HvSDPlIgFUiOn5b45PIHEUxw/7/7l2m4qfMH+
         brXKSrPfjovh/SvyGykacD2NBDSAPBH/jMbSdAiCnA0BZESlUFxY28Jri4Nwjg2u1SDT
         R8PnA8zFhSk2UIQveCHtzO+UUvsIi1UY9K/qorx5LdEVepTBjNI9uOCDXxqsFF5nm6Ea
         qBkQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794747403; x=1795352203; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MPjxARwbhT7wpT+NldH9sgjHxyAG1kHYfbUx4elToaA=;
        b=eih7F8SGPf56Gk0Rd0Sp+2O4v9yFUBYQKn8fbBLyZGiKN5bwCXtQhyUbK30ioqqwJ4
         kIi1r3kndV74LH0TWnCt9qdrOmxODAsPgtxrEjP0YY184HnMqgHyGzbMnTo633tTRDvb
         F1xfAPEs7jOUEGbUL4g8WmV9Pd+phL5PRLdMp2BdXx9HlcvbO97XYVk3Ql59NcDVMLHa
         kcQHuKsCpMxSjPzOO4oogaQ1QF/oBtezXgHYrb1+ihDjzhlzob4idYDm2OWWSV+iNwz/
         Y/Ja3jne1PlNaLF3HRQ8wqNvYb/FpY49xaq8l0+ZGswoLUNvUzl+I5cIl9FC+yHy+Msw
         y0kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794747403; x=1795352203;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MPjxARwbhT7wpT+NldH9sgjHxyAG1kHYfbUx4elToaA=;
        b=nnonYBmUl3VP+XEWv1Te5UOOYHtj/iZt1nELwlxg93APov4BjsQcteqSL18eWUJHTl
         /r9x6v+iwBX0oetoOD0/PL+jf5jQyKyzV23uEB4E2qOkZQFsGZYBq6ssiqQeeaCBvPPe
         p+D26p9YCVQgCc/DZyFBCWtpDYUnLQ2EGQlyKUnBpm880ROr8JCm8xi/7S+4vgLDlYtx
         7PjDhxbRR9VXsRXSCFa0ui0AIz5sqFzCQP6nZCSdniqaIhkWjk+Qa+gUrdpJakU7zB/O
         LIcSGfwnGhhGxo39D9GkFEXWefJPS9BmPwItwgHmpClGlKfDMKFbI50zkqrVU6gKuFWA
         ppDQ==
X-Gm-Message-State: APuU4Z9Jo0Iw2RF5EitNC+8gIHoewbpHc1DxYimlTXB/de291GnHRLHS
	66hnSWK/fn2VOIKEoYq6ndKI1IY/yqhtujtD62tHAb1dlCYC7IypT/cf1w5Ytc0TGfZxOVVWYN0
	QRDb/+GQIHjbWXVWwqiVyu/qQER4Fu74=
X-Gm-Gg: AYBFou1rJj5/ghWHTn+Cd4+ESoHdowZSocyxrZxFNlaU9WCOz5LiZZMTxgC5GeJRNSf
	QquQLfRi2mR7Ok7G2AC3MEj9Iq8lqjWgVLnXKzr32rZJjESgBi4z+Fv6JK29e2S5972q2cssczL
	cYJW74dulc2xbo0Fcba56E6uSCX3sSIT2ugEcTQ8ihu2a/QQopsTTKP7SPwM7CsQiN9LdONocZk
	SNoX3vosCUJNJz9q23uIq556EORjO8xbkNo5BfUp7PFl6zLlfexutc87rkne1hd8Wxh75pjRCoV
	2jdZ/xVpVassuFeAGcoKQJequLaL8DrW3NXwYMLSLkW9E7pRRDP1s5DGmUW7FUpENaAE5Fj8gY8
	bRPsos+//sg+PBqKrO/I3QjFg4VZ60EwM3fpQsOlHg66tbscs48IIep/sfTbydZQNlS0z3g==
X-Received: by 2002:a05:6a00:8011:b0:881:1c64:6723 with SMTP id
 d2e1a72fcca58-8beb6f5c1f9mr6440205b3a.37.1794747402550; Sun, 15 Nov 2026
 04:56:42 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261110151407.789960-1-nphamcs@gmail.com> <20261110151407.789960-3-nphamcs@gmail.com>
In-Reply-To: <20261110151407.789960-3-nphamcs@gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sun, 15 Nov 2026 20:56:02 +0800
X-Gm-Features: AclHuK_5SaXrB5pmLGWhXjUHDXsOmgc2bg3dysnge6viAM7H3emnkg8TzZhuZpQ
Message-ID: <CAMgjq7A9_KRxJEA1gLO8aEuUkbQ-Wh_N3gfTqRuX7A3_Ysh4Ag@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] mm/swap: publish cluster tables after reacquiring
 allocator locks
To: Nhat Pham <nphamcs@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, hannes@cmpxchg.org, 
	david@kernel.org, mhocko@kernel.org, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, ljs@kernel.org, baohua@kernel.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, willy@infradead.org, 
	brauner@kernel.org, linux-kernel@vger.kernel.org, chrisl@kernel.org, 
	shikemeng@huaweicloud.com, youngjun.park@lge.com, sashiko-bot@kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0206E100003
X-Stat-Signature: 3wssasz4bbt75y5j187f4qr81arpeugp
X-Rspam-User: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794747403-673224
X-HE-Meta: U2FsdGVkX19PuSx4FnSjXEcsbmRJV+VAOsTfe7S82W9VAwyuUz3nbvDnjk79Q4QNinYYDmvuCEllaUeNYoQHoUs+S+BvsiYw1/s+KeDECw4jHDa+gBpcURohmYIi/qMwQ8mMa1xQZ49NDZoZOGoyyR0gi+KThCXHJon59P5CTpnpVIJ/qTvB3eLFuFY8JKdaN7RoAJYNs+SDqpdMnXLHbLPvmvvUVxFcjezaPEAlMAHTtspimSjdVntE1msjCYrqbOsG4UG+8/0/zgstOzV1Q/qmbPAfzhD+Simfc2ZhRLC8ngQS3HcI/KOaLw1gKgbum1xD7KMNGoq4EFiZdfN0sSvldBBGkIrm6NmeNBdVOyPJx3d8FkujUIwhTr3Eb2N4+sKyBb3bkaIZYdw/iHjoPllYqrdzWdtKi7xASk14bf9Qfoj3Peb8+/8yr3eRVKSDiDkZ4erBuhWRCdW59qt+ddjMCnWs+CimLlW2SneiDx+Azx+dRPykCrStEy0397zqb2MwWe0yF+K8GVPrEolkmFEYId+h27hhlsJpw3J1MQL2zQXcTz7NiinPvIV/hMqwHcwA32MjBRazd6TkfmQxL7OrgLcf8X2n/6uHdfwS1yMxufQLmGyp3KWp4LWPwigm7mMrlzpWd9hv8NpXTvUNqa+FEvdFgBRjMS5B6Eyv5G0QYc6fKhVJZ3eH+fvInRqr6ISE2BR2fO0xEyCOfar/bSYU0y2K0jQM7KjQbwhr0AI+WzWIPaK6/6I/tCuSP+Yf3hY9xDfrrhe0JwSjAjQH/3Nab1hEuVF34QvOMHHD9aJNsT8/oIvTl0oWERi1COmdXaJzM8HX22RAGDXXOKQ2POpEBNDUvIkS8d4mjoTBwZKQA2iZ7DGQOYefsoXODIwv+DpoarWVIq8uqShKls3Md4Rgm5rlHK7p6xPSqIm/Fn5YMpMNKk660TELDCPaVHF+u+0bGcf1nQsxDXqjVZo
 Uns3mES3
 j4aIgGID1GcSiazNkMf8PkSXNqDV99R44sdsz46hGAyMdw33wZ44xPs5jmQ7L8pQHsXiNxwf5u1CQJRvQ7gHdTq8ZXal09N/4N21ZGih+V2WXVyH1w//8oX+pQEdRWCBIdKJYCCsGlUak9nHuoLlY8oqZ+oTlBWMkDzgSHilJQUklP67jdvIJaTDIF5r1gZKreZjmBGQEkVpfAOqmB/RDZSC6S+ux1GR5hNx/ZtjZq+B3/Ufg3FwTkpHBd1vMsKPi4CitiMyyEgx4UP0wb2oNHWfjIEyn5iNjlpiTtg/TxI4RAHkU7LRyRsDnh/5HqTkiiN7U6XrvD8qkbcROLadolVL8aK56a92BZE6k/an1W4+DBlYLr9abzYxbbPmHl17fPM0t6LMOTBndRjA8le+Dx5VMW75xu28kpE0DgV4Qms8NI2PY95ZuUfSsiF7mkfW2jWJpmMz3srPMFaq70BrZQoYSvXlWSoRfjUWe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 11:14=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrot=
e:
>
> Under memory pressure, swap_cluster_populate() can publish a table
> while its locks are dropped for a sleeping allocation. A cached
> allocator can consume and free that table before the populating
> allocator resumes, leaving the resumed scan with a NULL table.
>
>     CPU0                           CPU1
>     alloc_swap_scan_list()
>       isolate_lock_cluster()
>         swap_cluster_populate()
>           drop local/global/ci locks
>           swap_cluster_alloc_table()
>             rcu_assign_pointer(ci->table, table)
>                                    folio_alloc_swap()
>                                      swap_alloc_fast()
>                                        alloc_swap_scan_cluster()
>                                          __swap_cluster_alloc_entries()
>                                      mem_cgroup_try_charge_swap()
>                                        return -ENOMEM
>                                      swap_cache_del_folio()
>                                        __swap_cache_del_folio()
>                                          __swap_cache_do_del_folio()
>                                            __swap_cluster_free_entries()
>                                              free_cluster()
>                                                __free_cluster()
>                                                  swap_cluster_free_table(=
)
>           reacquire local/global/ci locks
>           return ci
>       alloc_swap_scan_cluster()
>         cluster_scan_range()
>           __swap_table_get()  /* NULL table */
>
> Keep the count table, cgroup table and zero bitmap private until
> swap_cluster_alloc_table() restores all allocator locks. Install them
> under the cluster lock and retain it through the scan. Initial bad-slot
> setup takes only the cluster lock because the device is unpublished.
>
> The allocator releases its locks before the sleeping allocation. A
> reclaimer that dropped ci->lock earlier can then resume and put the
> cluster back on the free list. Abandon installation if the list state
> changes or a table appears, freeing only private allocations. Restore
> locks on allocation failure too, so the caller can return a still-isolate=
d
> cluster to its free list.
>
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Link: https://lore.kernel.org/all/sashiko-outbox-181084@kernel.org/
> Link: https://lore.kernel.org/all/sashiko-outbox-181086@kernel.org/
> Suggested-by: Kairui Song <ryncsn@gmail.com>
> Fixes: cdd77f84d966 ("mm, swap: consolidate cluster allocation helpers")
> Cc: stable@vger.kernel.org
> Signed-off-by: Nhat Pham <nphamcs@gmail.com>
> ---
>  mm/swapfile.c | 106 +++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 74 insertions(+), 32 deletions(-)
>

Thanks for the fix!

> @@ -825,9 +862,13 @@ static int swap_cluster_setup_bad_slot(struct swap_i=
nfo_struct *si,
>
>         ci =3D cluster_info + idx;
>         /* Need to allocate swap table first for initial bad slot marking=
. */
> -       if (!ci->count && swap_cluster_alloc_table(ci, GFP_KERNEL))
> -               return -ENOMEM;
> -       spin_lock(&ci->lock);
> +       if (!ci->count) {
> +               ret =3D swap_cluster_alloc_table(NULL, ci, GFP_KERNEL, fa=
lse);
> +               if (ret)
> +                       goto out;
> +       } else {
> +               spin_lock(&ci->lock);
> +       }
>         /* Check for duplicated bad swap slots. */
>         if (__swap_table_xchg(ci, ci_off, SWP_TB_BAD) !=3D SWP_TB_NULL) {
>                 pr_warn("Duplicated bad slot offset %d\n", offset);
> @@ -835,6 +876,7 @@ static int swap_cluster_setup_bad_slot(struct swap_in=
fo_struct *si,
>         } else {
>                 ci->count++;
>         }
> +out:
>         spin_unlock(&ci->lock);
>
>         WARN_ON(ci->count > SWAPFILE_CLUSTER);
> --
> 2.53.0-Meta

Acked-by: Kairui Song <kasong@tencent.com>

