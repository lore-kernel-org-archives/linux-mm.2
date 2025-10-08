Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73602CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 20:59:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB6358E002D; Wed,  8 Oct 2025 16:59:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B67578E0002; Wed,  8 Oct 2025 16:59:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7CB98E002D; Wed,  8 Oct 2025 16:59:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9275A8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 16:59:01 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 509CF1A0719
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 20:59:01 +0000 (UTC)
X-FDA: 83976161682.17.6476C7C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 763F04000C
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 20:58:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ys4ncc22;
	spf=pass (imf12.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759957139; a=rsa-sha256;
	cv=none;
	b=FXXqEZ2a1BYgTYcXdZoATLprrMwoJPKQ4o/6qjzbj+DJ1N+es5J5m4nfRIFWQyJPgNLDND
	6+vVrmSIVIRPQjUjxCed2ahob/QjMmtMilF5WZFGBbX6y3YRELUjXz4oui3MIrcpirdWB9
	Db8X8GG6Ce8UkhQhVd6n1PGG2AsUCPw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ys4ncc22;
	spf=pass (imf12.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759957139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9A0GrbWcnMBRflqGeu9KDRzJI+GI18tNcWSEFBGceUQ=;
	b=07D/DRANGE0012H+rUKdboGC9solkUCDkz2GWc3Hh6iS3f7ipkNHCDoQr7zF6Xr87a3bRL
	aVCBl97zY5tJbyEpE5JWHKZBgLVgHraVijQUcLAaropSwBtl1Q/RxAI4cZsagXFWljCY92
	pYX20VqpkxYt3DgzX3iawvAumRcstsw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9418E604C3
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 20:58:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44CA8C4AF09
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 20:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759957138;
	bh=I/O5cFAIVReUYpBF2BqP5uRgVY4CVJzEBglG9Ag9N1c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Ys4ncc2238l++WKdLlwPuP9Dhfkv0tOhxX6aBWkPTsZd5E1V4elf4rMrzL1Fpk17N
	 4I4EmHUkjsII5KGgMR7AMtvNNlPFZAHepB/l27uboV+Y8Nv9XeNPHt8esi+ThQ/P7n
	 C/zPlGWD3XBMUqWtXR7zo+zaSXyEdVmBgxj5l8iPAeZTSayhg4mh8F6xgFV1zkr7AD
	 rDNBNHJvFqOpCd5UkIF7HzV1WK/JYB1FhX1UQA8wBMdarheSvOnAL9sX8P7Z2qEvE2
	 NaQS/EiFPcRMgPRc+0P9LX+HYxzQ9qwWf1qfn2Nj/XAI4s7JzlMcZ/CcJjCbsJXQqk
	 Y4+wU87lk/ecA==
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-6352c8b683eso394143d50.2
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 13:58:58 -0700 (PDT)
X-Gm-Message-State: AOJu0Yy0KbJA4czzCVtYuLSl3iBPIC0oChk07RS3AiALVYzdfXQ/cfmK
	aLCfEg7lUOHuGw5Ek/F6KAr3G4TD+MNCvkAwmIxjW3OjMsIG+kFifDf7n9x3wJg4OkcncIpANgN
	4JovxVz/Gv/Z2FKaLEDH4I0umntb7Epn595RNAbByvg==
X-Google-Smtp-Source: AGHT+IFmDct8NBJB7hs7xpsIKwGqjrJKi8DA5w41X122GCxOpuP97IsVpRnLD3pg7rvYeA6vDxTtei2PmX8W22XUzTk=
X-Received: by 2002:a53:cb41:0:b0:634:751b:1d13 with SMTP id
 956f58d0204a3-63ccb85da27mr3897822d50.23.1759957137556; Wed, 08 Oct 2025
 13:58:57 -0700 (PDT)
MIME-Version: 1.0
References: <20251007-swap-clean-after-swap-table-p1-v1-0-74860ef8ba74@tencent.com>
 <20251007-swap-clean-after-swap-table-p1-v1-2-74860ef8ba74@tencent.com>
In-Reply-To: <20251007-swap-clean-after-swap-table-p1-v1-2-74860ef8ba74@tencent.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 8 Oct 2025 13:58:45 -0700
X-Gmail-Original-Message-ID: <CACePvbXtWQq0g+K0YtQLi3Sz5ukS5YS3XF-_VDEmUR0Y3f_Agg@mail.gmail.com>
X-Gm-Features: AS18NWDUClHnjux-YVCXQbI0rvRka3sDNL5Dc2iIYoaxaQjpkAmt0AU3DR9zlUc
Message-ID: <CACePvbXtWQq0g+K0YtQLi3Sz5ukS5YS3XF-_VDEmUR0Y3f_Agg@mail.gmail.com>
Subject: Re: [PATCH 2/4] mm, swap: rename helper for setup bad slots
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@redhat.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Ying Huang <ying.huang@linux.alibaba.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 4zz3fxkqr7zmnuc6jfuc8cyfyhgaqie8
X-Rspamd-Queue-Id: 763F04000C
X-Rspamd-Server: rspam09
X-HE-Tag: 1759957139-599658
X-HE-Meta: U2FsdGVkX1/EQfPBh9SaNAQoxJ+4Em2dBJrPFSVqrPUcKNXrUOAlQzKg/wbRwTMG1VaU1Jcfoa+b85CEVJZ7tEWCakH8SIWVD+S9biayUvkoWQLMXDLBK/Haa5v/0K7XPxsnBIdclaBoERjtR5NU3AIqM04Vvm9vZI2zj8WBRcsuy3tnA/2BZ7h04Gs7AAQsxIwT4PnqANaCdMot9Az4I60Xg0fo0YtJnOdNF8QXdFhZUBIfYbj/b/XkLKBnJJZeV7EQ6ilWI5Dg2Cy+ZwBtcZyKNiIA0LRVTqZg/j6OW9nkLIus5+awYmaWoNlBUZ22dB3D2LaY0W+tO7NTVaL3YtdvFgbBhOri/ivDoJKHo0L7T/+CpNf/LEVepVGsMfSkiplzravI6Iis65wMxdUeU0MUp3Tsrmq3KvnCAIZAjVote8soIHiORHucqE2ZV7PQ6QaALE10OaiYMttR1/FTRtPi1wQftMRQkMoEaPwiqgAbguKYDT8T1eWhSjLhNB3HQA73GnPoEOwj3qUv6/e28CEG80BIjes1e215C3fqNmKMolOWenlYYXH5McJYI9byqZOApoSoMaFBAh9yJUVonr3kwVZm832Nfsb1Gf9n/STbUl06qWdzCwN3iEInytySiSsSRgEFKEfLbYqYg+oh1uz088YeqHuCVpGB0+J1RXL/hxh5m4iwgRuGSk5+y64PL7hkDEz1vhjWGiS8eabQ0AkKZTd4/spnX3s0kXNWg+wwZwHWo5+PofZDIJcafRTHGMJNesU37TY47Ry7Kqif4KmFVXov2gh8c4RXKfawFQ7qvaEVCCmLNv40usK96fpiZeJ9hXyXaLkTIq7q8cTGmRB5VoMDcnk9MW3sBS9tbflG6/rinmkGbEzw8lhk9ppgZ4ozdXQScbQDmp1h2QKrySn3iUxWkNH16RoTiHWZbUq2kYqgYCwVnqpXR32shpzagcxG+CZvFgJ4OZCdQDY
 PtSFodKU
 Bg0G3qlPWv2P4xFYCwCVuZiZz2d5thURWUWaDXEemqaGxa442lxAwInloLVQQAoCj673RrnidkMz+MnCjfTRemXEjLJnHOq4o/DhcynxOu17qg82Vz9y+r/YzdcS7ZB1qu7JGCs5mLOeI9uQW44UuFIwxOchVsYMXA9j6OPZah51LTsaKh4QucvmZT6NYNtqvbE4nhz7cjCLS3V18jeES6LoeX+p3h3gjvNj70B4dGoLmEag05PZcLo1FjzEUBhVhJ5PPy6LxBlJDzYzlOPwpCKPcbyZO7c2f13l86YePdNmuzF6dQDSCEH7TsNQu5lGMhU8U
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

On Mon, Oct 6, 2025 at 1:03=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrote=
:
>
> From: Kairui Song <kasong@tencent.com>
>
> The name inc_cluster_info_page is very confusing, as this helper is only
> used during swapon to mark bad slots. Rename it properly and turn the
> VM_BUG_ON in it into WARN_ON to expose more potential issues. Swapon is
> a cold path, so adding more checks should be a good idea.
>
> No feature change except new WARN_ON.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/swapfile.c | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 0d1924f6f495..732e07c70ce9 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -751,14 +751,14 @@ static void relocate_cluster(struct swap_info_struc=
t *si,
>  }
>
>  /*
> - * The cluster corresponding to page_nr will be used. The cluster will n=
ot be
> - * added to free cluster list and its usage counter will be increased by=
 1.
> - * Only used for initialization.
> + * The cluster corresponding to @offset will be accounted as having one =
bad
> + * slot. The cluster will not be added to the free cluster list, and its
> + * usage counter will be increased by 1. Only used for initialization.
>   */
> -static int inc_cluster_info_page(struct swap_info_struct *si,
> -       struct swap_cluster_info *cluster_info, unsigned long page_nr)
> +static int swap_cluster_setup_bad_slot(struct swap_cluster_info *cluster=
_info,
> +                                      unsigned long offset)
>  {
> -       unsigned long idx =3D page_nr / SWAPFILE_CLUSTER;
> +       unsigned long idx =3D offset / SWAPFILE_CLUSTER;
>         struct swap_table *table;
>         struct swap_cluster_info *ci;
>
> @@ -772,8 +772,8 @@ static int inc_cluster_info_page(struct swap_info_str=
uct *si,
>
>         ci->count++;
>
> -       VM_BUG_ON(ci->count > SWAPFILE_CLUSTER);
> -       VM_BUG_ON(ci->flags);
> +       WARN_ON(ci->count > SWAPFILE_CLUSTER);
> +       WARN_ON(ci->flags);
>
>         return 0;
>  }
> @@ -3396,7 +3396,7 @@ static struct swap_cluster_info *setup_clusters(str=
uct swap_info_struct *si,
>          * See setup_swap_map(): header page, bad pages,
>          * and the EOF part of the last cluster.
>          */
> -       err =3D inc_cluster_info_page(si, cluster_info, 0);
> +       err =3D swap_cluster_setup_bad_slot(cluster_info, 0);
>         if (err)
>                 goto err;
>         for (i =3D 0; i < swap_header->info.nr_badpages; i++) {
> @@ -3404,12 +3404,12 @@ static struct swap_cluster_info *setup_clusters(s=
truct swap_info_struct *si,
>
>                 if (page_nr >=3D maxpages)
>                         continue;
> -               err =3D inc_cluster_info_page(si, cluster_info, page_nr);
> +               err =3D swap_cluster_setup_bad_slot(cluster_info, page_nr=
);
>                 if (err)
>                         goto err;
>         }
>         for (i =3D maxpages; i < round_up(maxpages, SWAPFILE_CLUSTER); i+=
+) {
> -               err =3D inc_cluster_info_page(si, cluster_info, i);
> +               err =3D swap_cluster_setup_bad_slot(cluster_info, i);
>                 if (err)
>                         goto err;
>         }
>
> --
> 2.51.0
>

