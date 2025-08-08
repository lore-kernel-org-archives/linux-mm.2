Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C999C87FDA
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 19:52:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7354D6B008A; Fri,  8 Aug 2025 15:52:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70D866B008C; Fri,  8 Aug 2025 15:52:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 623686B0093; Fri,  8 Aug 2025 15:52:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 45D1A6B008A
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 15:52:30 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E89A61A046F
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 19:52:29 +0000 (UTC)
X-FDA: 83754637218.20.E57B348
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0AD7A180006
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 19:52:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SmEZGEja;
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754682748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TOksUUkmNUo1gJjXyzVJ9JNirYCmT1mcW6HEbUxRrvk=;
	b=EBGn5Yx+Y9+VFoFlU3CUcllQlVpk/sIkCmOYtl3VvWW+kvNjUqmWbk146Mxq63QCv2btdV
	CP0I/3NAnB1AV75DKvpypYy3gG5mDLia/bi34whu22mznAd2MVbf9mcO/TcY7dYboPgUrc
	GONwWqf2bjRghyVq48EtAdHWjzGnVq8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SmEZGEja;
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754682748; a=rsa-sha256;
	cv=none;
	b=8FxYBFUtPlJmw02zHWVwJknlDJe0tRSrwpJBfWcHS+BarkqXoKqkL+fSMUfV6gBCQjJpsX
	PqDhXHXhBPoqFyLcZfbhuqZfppFIJ25GH97vzwEr2rHXnYQHcz7wwuIuSJUJ6bWjh+WeBd
	FmGMadudEh4Xn+vqZtcOhNffULj7joQ=
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-3322d10e29dso20073181fa.0
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 12:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754682746; x=1755287546; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TOksUUkmNUo1gJjXyzVJ9JNirYCmT1mcW6HEbUxRrvk=;
        b=SmEZGEjan1OirgWuU25In8WTX/NfshBTHNQwHPMwKg7Qb/BSojdR5lBPUOsv1qsqi9
         gQ01ii+qPpjuVCojmjvDTneE2lPjvuPs81kIenE92GSHae7eOKwkw4tLZEOJP5X6rXXC
         ECtsn0J3FAcE69t/w1SZWoMV+dUFiFvhW+wfPJMa2Y1tDcj+l0gSkZe+pY8kOuiqtKBS
         zOABogvuKMdjMsj3cF9uH/tPFasFPQz0JLqzRrtz0NA+ITe+0nZ5oHfzE41bY/jlo8KB
         rdq+CFfIHGUQOb4/NUaxsRFJOHD6rKK5HCcuZxU0D2Jq1lLyrhXMV1YiLU50uDszeloV
         FzIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754682746; x=1755287546;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TOksUUkmNUo1gJjXyzVJ9JNirYCmT1mcW6HEbUxRrvk=;
        b=KgLf+PmJ6CUr/zR4+S7KaaJcfy5XqnUu79Sne0Kx7mUk9MPfdCg/UzsnhAHitOS7YM
         r8d2GlbYCakEDnC4/bwXwzk168KSPX5KHxaXf+vnOxAoCZKNB4a8PjeOeLcy/t2piANx
         +qIPr7nGIE7tgqWYhNvFUkXworge0tD0jmivTNdHS9YmKOFMPzczwvpniFfi1F3pWmmd
         RTHN6yWDmTAcnhX887xYrX928u7KSwKNLu+h3dvEzyuWm65t7nMa+tSr9kjpR6vrGdME
         Ot/DSWh6tArggJlLwb1u8ZBLFLWCRy27w28FoUzclyFl7/rAaycuvGqbBfDlUaVRKtI8
         CDdA==
X-Forwarded-Encrypted: i=1; AJvYcCXUpoNzPHqKs97CnD3SVlmrj1vhpIV7+w0/h1Mpq6TXIDXggexZ8Lmyku2zpW6+Zd6s08ArYUNlqQ==@kvack.org
X-Gm-Message-State: AOJu0Yw8BCgZurkCRCkgrtfhUD4VgiHj6hVcTiCQiFKNc6Ze3UaFWtFb
	53nV0AUxbt9arHzaP8nt4WUBq5XCVfuLcxyA300jUi7jQr2fC6kw7/ylwZvKvdjr0f8XH6616ci
	/3yvEoVe8mJpTyPmj1fvLjE5JGK+brvE=
X-Gm-Gg: ASbGncsup363Y9KOn7ZLXQfIww+txIKh5ICwhddUGK28Tqw9dbXzIwKu3+a4QyOt18E
	ez4wMPrKHniZJMmGbtBolPvIbScW1ZxL6QTx6rDmdTeStE7c+pf0yLxCxL5cJXVkHr9g0SQxoxJ
	nzmtWQOML68NOH3f8eYA8Bbvm17XU3lC+1g8ZOOFvZPvczJycmXX5nprvx9iJzgvSHEeIvCvXn8
	LUxAUQ=
X-Google-Smtp-Source: AGHT+IHJmhdxrLLs3Pqi9sJOtvva6r1zJo7sfa30BJij0hWkFOlPr3jdMn4zGmXgBA8eCsIvOKwFBRQ4mJSUnJTY95E=
X-Received: by 2002:a2e:a99e:0:b0:332:3a1c:beca with SMTP id
 38308e7fff4ca-333a2144a1amr10160591fa.7.1754682745742; Fri, 08 Aug 2025
 12:52:25 -0700 (PDT)
MIME-Version: 1.0
References: <20250808-swap-scan-list-v2-1-d50e4758ecee@kernel.org>
In-Reply-To: <20250808-swap-scan-list-v2-1-d50e4758ecee@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 9 Aug 2025 03:51:48 +0800
X-Gm-Features: Ac12FXyUrPb8BcGkWY_t-4KAtxH6S2b_tPnxlwBGo-VQL9EFvWOu6cwFLsZK38s
Message-ID: <CAMgjq7DnniGUdpQQA0YF+LuMuL9+FCLQJP2Q04G_Hsd1sztv9A@mail.gmail.com>
Subject: Re: [PATCH v2] mm/swapfile.c: introduce function alloc_swap_scan_list()
To: Chris Li <chrisl@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 0AD7A180006
X-Rspamd-Server: rspam06
X-Stat-Signature: gkgtn9end4ax478os1c8fbj4qtg4crmj
X-HE-Tag: 1754682747-858810
X-HE-Meta: U2FsdGVkX1/JLoDui25R48wNyhf3y2kijNhg29wYeA9Fl9UWxJdgLAxii4UqyST6I9OXAe9+2VYqhYG7IRT+lqTIIH6j1NbjOzFtE7T8F9EOtnlf6UWpFdlygAqTKQnt1HPQMPrxTMNLBP+Sa7Y+6zOHI69uus3ZWq0CzXeC1Df3hmzJ+s0Jio543qvPE+HLOQDrpPeMvd3OmbdqnXhG+bJ4kFmsuj2PwOMpd6A7mCrPmJp2GehBo2N/GA9Eh3RcFDWNv23SN4zNK1nDZtsVn1q+9ScEjCwYs1KBudHAT+Qg9rFfEPpEUzsFMCcoBml8oa8Hy7s0WH2JvPz9T9wHIF78vzTimS4sTVx2b8O7hglCgrLfen8c0gnBpuI49iToIuLnKh7xvDsaYZAI9V/01uOrzVQIpsZdRT60a3jCQSCdvFeDfF0Kyc6/XEHZz3OugO+6jZiD9qTFti5emxa0POcdA4XL2anMInngWTQw5N2Md+ixZR+6h2ZIKXrlqmbzXsA2Wmm6d1GJgF1kNHZsqfz5L5KI1nDzmLNuJgWaYRi3UBmtPxuAt6JGqfJF5BbLYcBFy+2bGUcdX+EAgLuGQ+k+ofNUJ2UhQDIVTmdi0P63ikxXBhSOB7zyjDrDSQ8nkj9dWrCI+Rp+u72gMd+L90zR8j3cmVSVgrRKfgU8boUO67LPwIAwzgOW6X+mKnYJqzNXQB2s7qStHt0gthINIOETnJoAK55PU/2qMg+aaOHMmOi7r1BwaMlR+va06WBEXpZP+YqCVRdIKX+sgRlAfpGK39FquSpUCcUMyszxAGzdE3PhrpZIoMOnLiQVD8XZZZH/Zb3Jj49EbDrx872JbSOCCH0r0mBxFpU2mEQaRzEjNC+cA8xcC69D5fcRdmDRVYihAzTpt5DfilXpVDNHR61sSO0O8WOEaLlg0vGu6GgJtSYjCDF+GY51rd7br/9B5S/EFGPtR9pdelj+xmV
 g+6xqKt4
 Zwlkl/H/OfYbZ/C/75KfUTRehyjw0sC266sz5k1veUQdBcT2D3uhSGyrTyhl/Z4rGpbUyfUXMxemM0MZFat4Xf+xc6GXx3YvIWO+9JExRJtK7fy+ipy1F9mxxCiVXB5clxj+XW9WTYNDgvncFasrCIx9Lt49YZRUNbgcVAdo7k2UNWwqPLS87+WpmpssaQh0uM3I3aj27Nue3Z7kFTBn7CWgpi4hfWi35Ml18K2DxYf2Vz4Sj/nPNqMPKudUHq6ez4fEdPw6HDu8dM1ycflMnF+nRAAkFOdEe6/Umi4gO0v1rQcMwgjYIoZ9Q+ic5VDQlelZhWxYnLI+dqNP3TkkxC/72PBhJMtw0lQm/0xjibBVzSKShyXXXktaE8lYrDmxD9D4HqtAUAmqIR1d7tTslPs6eJZSUoK01blyJPWru0n6bTw42gLEntqbTxj4TFwFLWtFd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 8, 2025 at 3:48=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
>
> This the alloc_swap_scan_list() will scan the whole list or the first
> cluster.

Hi Chris,

This sentence reads strange to me, but English is not my native
language so I'm not very sure about it.

>
> This reduces the repeat patterns of isolating a cluster then scanning
> that cluster. As a result, cluster_alloc_swap_entry() is shorter and shal=
lower.
>
> No functional change.
>
> Signed-off-by: Chris Li <chrisl@kernel.org>
> ---
> This patch goes on top of Kairui's swap improve cluster scan series:
> https://lore.kernel.org/linux-mm/20250806161748.76651-1-ryncsn@gmail.com/
> ---
> Changes in v2:
> - Adjust change base on Andrew's feedback on int type and break out of
>   loop.
> - Link to v1: https://lore.kernel.org/r/20250806-swap-scan-list-v1-1-a5fe=
2d9340a2@kernel.org
> ---
>  mm/swapfile.c | 86 ++++++++++++++++++++++++++++++++---------------------=
------
>  1 file changed, 47 insertions(+), 39 deletions(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 4a0cf4fb348d..f26678d68874 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -820,6 +820,29 @@ static unsigned int alloc_swap_scan_cluster(struct s=
wap_info_struct *si,
>         return found;
>  }
>
> +static unsigned int alloc_swap_scan_list(struct swap_info_struct *si,
> +                                        struct list_head *list,
> +                                        unsigned int order,
> +                                        unsigned char usage,
> +                                        bool scan_all)
> +{
> +       unsigned int found =3D SWAP_ENTRY_INVALID;
> +
> +       do {
> +               struct swap_cluster_info *ci =3D isolate_lock_cluster(si,=
 list);
> +               unsigned long offset;
> +
> +               if (!ci)
> +                       break;
> +               offset =3D cluster_offset(si, ci);
> +               found =3D alloc_swap_scan_cluster(si, ci, offset, order, =
usage);
> +               if (found)
> +                       break;
> +       } while (scan_all);
> +
> +       return found;
> +}
> +
>  static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool=
 force)
>  {
>         long to_scan =3D 1;
> @@ -913,32 +936,24 @@ static unsigned long cluster_alloc_swap_entry(struc=
t swap_info_struct *si, int o
>          * to spread out the writes.
>          */
>         if (si->flags & SWP_PAGE_DISCARD) {
> -               ci =3D isolate_lock_cluster(si, &si->free_clusters);
> -               if (ci) {
> -                       found =3D alloc_swap_scan_cluster(si, ci, cluster=
_offset(si, ci),
> -                                                       order, usage);
> -                       if (found)
> -                               goto done;
> -               }
> +               found =3D alloc_swap_scan_list(si, &si->free_clusters, or=
der, usage,
> +                                            false);
> +               if (found)
> +                       goto done;
>         }
>
>         if (order < PMD_ORDER) {
> -               while ((ci =3D isolate_lock_cluster(si, &si->nonfull_clus=
ters[order]))) {
> -                       found =3D alloc_swap_scan_cluster(si, ci, cluster=
_offset(si, ci),
> -                                                       order, usage);
> -                       if (found)
> -                               goto done;
> -               }
> +               found =3D alloc_swap_scan_list(si, &si->nonfull_clusters[=
order],
> +                                            order, usage, 0);

All other alloc_swap_scan_list calls use `false`/`true` but this one
uses `0` for `scan_all`.
And it should be `true`, right?

> +               if (found)
> +                       goto done;
>         }
>
>         if (!(si->flags & SWP_PAGE_DISCARD)) {
> -               ci =3D isolate_lock_cluster(si, &si->free_clusters);
> -               if (ci) {
> -                       found =3D alloc_swap_scan_cluster(si, ci, cluster=
_offset(si, ci),
> -                                                       order, usage);
> -                       if (found)
> -                               goto done;
> -               }
> +               found =3D alloc_swap_scan_list(si, &si->free_clusters, or=
der, usage,
> +                                            false);
> +               if (found)
> +                       goto done;
>         }
>
>         /* Try reclaim full clusters if free and nonfull lists are draine=
d */
> @@ -952,13 +967,10 @@ static unsigned long cluster_alloc_swap_entry(struc=
t swap_info_struct *si, int o
>                  * failure is not critical. Scanning one cluster still
>                  * keeps the list rotated and reclaimed (for HAS_CACHE).
>                  */
> -               ci =3D isolate_lock_cluster(si, &si->frag_clusters[order]=
);
> -               if (ci) {
> -                       found =3D alloc_swap_scan_cluster(si, ci, cluster=
_offset(si, ci),
> -                                                       order, usage);
> -                       if (found)
> -                               goto done;
> -               }
> +               found =3D alloc_swap_scan_list(si, &si->frag_clusters[ord=
er], order,
> +                                            usage, true);

And it should be `false` here.

> +               if (found)
> +                       goto done;
>         }
>
>         /*
> @@ -977,19 +989,15 @@ static unsigned long cluster_alloc_swap_entry(struc=
t swap_info_struct *si, int o
>                  * Clusters here have at least one usable slots and can't=
 fail order 0
>                  * allocation, but reclaim may drop si->lock and race wit=
h another user.
>                  */
> -               while ((ci =3D isolate_lock_cluster(si, &si->frag_cluster=
s[o]))) {
> -                       found =3D alloc_swap_scan_cluster(si, ci, cluster=
_offset(si, ci),
> -                                                       0, usage);
> -                       if (found)
> -                               goto done;
> -               }
> +               found =3D alloc_swap_scan_list(si, &si->frag_clusters[o],
> +                                            0, usage, true);
> +               if (found)
> +                       goto done;
>
> -               while ((ci =3D isolate_lock_cluster(si, &si->nonfull_clus=
ters[o]))) {
> -                       found =3D alloc_swap_scan_cluster(si, ci, cluster=
_offset(si, ci),
> -                                                       0, usage);
> -                       if (found)
> -                               goto done;
> -               }
> +               found =3D alloc_swap_scan_list(si, &si->nonfull_clusters[=
o],
> +                                            0, usage, true);
> +               if (found)
> +                       goto done;
>         }
>  done:
>         if (!(si->flags & SWP_SOLIDSTATE))
>
> ---
> base-commit: f89484324d5876ee10765fa61da0332899fa1a6a
> change-id: 20250806-swap-scan-list-2b89e3424b0a
>
> Best regards,
> --
> Chris Li <chrisl@kernel.org>
>

This makes the code much cleaner, thanks!

