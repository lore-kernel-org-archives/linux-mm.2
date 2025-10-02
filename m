Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5981BCAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 08:33:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFD768E0011; Thu,  2 Oct 2025 04:33:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD5248E0003; Thu,  2 Oct 2025 04:33:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A11A88E0011; Thu,  2 Oct 2025 04:33:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8E0608E0003
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 04:33:58 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 300541A039B
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:33:58 +0000 (UTC)
X-FDA: 83952511356.04.741BDE9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4EFDC1C0004
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:33:56 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=la+3NCw2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759394036; a=rsa-sha256;
	cv=none;
	b=QMn3WU7TX4hxXFTA4BQbhoFOUUS5Ys34sW1tygBoG30Onq194EWLjW18YlSA9hkHAYhgxP
	RnQoc1BzyCyI46+IzDfcVLIWmBRq05EL7Kpqmu03v8uw3XzEjigH7842svcXsGONjMABWm
	T2D2Xo4ouQWsjc3pz6fNAnMn5T1536E=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=la+3NCw2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759394036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x4RFbBjXBAG5PiKlOmy3Fq2JrTeXcQC1AqKZRPOaaUk=;
	b=t4N7Zstffy+riFVcJ+Cg3i/26IVvZCxZAylGwchYXNMkxMmwW9RgxDJSqo1w0T/xbqXctH
	CwNHTyGmN6F9lpt43eU09Nrb3i5s6kkGIA3ADl7dMP3IBIYN4AdajHgpROTbGkb9LRPYNU
	iFaUASlVVNmyINRKRJ19IuPz564h5AY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BD4CD63D7A
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:33:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69441C4CEFE
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759394035;
	bh=pbVOh0viiaSQxSutfXOGlnV2vsIRoOKRiCLadqZosi0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=la+3NCw2Nb15J3fH82mfJryxEm9q/NcjUgmE1JauOqENFvJ8Bx35Ih2x381Jh0PFB
	 MFIOMmjWNwyDU8i/vbawZU56lc6rMAPZvFSvhr61j+OlLSWpaGfePrgZOIAuDdKDKb
	 Z1+Ut01jFzu+JMhPyu4ryofGNc/PkgfuvRe1RmI8oyGnHdqaqzrKPV1aPVR42vKQ30
	 HzDg5m9bZJD2uRXCP+K2yAm4ze2AQK7vhMF69ca1v+z4u7hSWQPK9QQnvC78BijQY7
	 3gc0c1y0aJG3W0GkP9X4zVW6qRSYa8ChAtyTLfSy9NGDwsfZ3GKSQzNH5Pr25aGWyD
	 AXYsN3zl73VvQ==
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-71d60504bf8so8334657b3.2
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 01:33:55 -0700 (PDT)
X-Gm-Message-State: AOJu0YzFztsEWPDbSc3uqbMvHH51s/0nOxgYE4aIi3+WgOQOyDnrRRQ3
	a5hvfVWhgYNCWSZZLjTvpaXuVy5wDh3+nJYIKuPOVatAGFbSbXwWkIXb5eme3Me6aBwQxd2mFcS
	HgcOQ8R8zwl3Qzt2bZ4NEPxb7dYCNU5Z9aD4ZQlpJAg==
X-Google-Smtp-Source: AGHT+IEnyfZfcCdVQp61svzBmK9LMRvaqLJ0QnUZhYgz/8gqmOIsvWmQ4WliKvfLtqjVPjwjjpMmT0tq8pUlaHvu2K0=
X-Received: by 2002:a05:690e:1a67:b0:5f3:316d:1cf6 with SMTP id
 956f58d0204a3-63b6febacebmr7046308d50.21.1759394034678; Thu, 02 Oct 2025
 01:33:54 -0700 (PDT)
MIME-Version: 1.0
References: <20251001043436.41338-1-bhe@redhat.com> <20251001043436.41338-4-bhe@redhat.com>
In-Reply-To: <20251001043436.41338-4-bhe@redhat.com>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 2 Oct 2025 01:33:43 -0700
X-Gmail-Original-Message-ID: <CACePvbWD4BUSqcJkdQdZmXFNjDtGQdEkjUmeHVh0QT3_XTvKEA@mail.gmail.com>
X-Gm-Features: AS18NWA1QR20ITgLru3xXgiW014ykRRuOj5vwo5jmuA5oDR6gbbijd0nssAhenk
Message-ID: <CACePvbWD4BUSqcJkdQdZmXFNjDtGQdEkjUmeHVh0QT3_XTvKEA@mail.gmail.com>
Subject: Re: [PATCH 3/3] mm/swap: remove unneeded swap_active_head
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com, 
	baohua@kernel.org, nphamcs@gmail.com, shikemeng@huaweicloud.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4EFDC1C0004
X-Stat-Signature: ju68k8fiayem9y1tc6s4d4qr4w5jnwsc
X-Rspam-User: 
X-HE-Tag: 1759394036-526632
X-HE-Meta: U2FsdGVkX1+RD6+DhUbOsgGiQYX2+NHNRo+owQ+T2dsgHy6e196mZRQfuOqqwivBOORgdYYUfcQ+YUcvCYuPaqm3uduCtaE28Y/HXYbpUCdxVuwR/fkwx/ImaxGaTGt9pifmPuERmwkn/0uNQGxTif6iKL3yEuiOVmuye6jlijvO7cMLpR6NH1ofdh51doaezi1DkAx4ja/+qDdiFpBxErp+PExv1dsFoHgc0ZHIp/eZws7wJDXgTHPjxovbtwQtI3W/HWlDM6b/gzs1wlVtSPreDVvmGm6R2BVOr9jsUg8Ks2LF9ZKMvHNdjrCup7XV09VoObbNC9eXjTlRFYuDmDsbBCHWNwELyDESWMHV/f8FLaG9ggLVE8gighf0rfnCY1c9+d7KjZBAgL6qMTmXlzwKWHjd7VByQ6+HJbH5osZ7WjAZ8j0tqVedazJJd/qBdDYLwzEMSIXq1bSfT7+ThxVKB22gXAC1EiDST9XYt9IYZA9UpnWdd63FtwVKZNBNNjYYhdb4B8hV3vLqD/cqVerWgvBDp2/jFvYj+pdKz9eyfDXlJ8kUyihmrDYRiM5bRz3C59Nk+jqIxKAdFQaPAp08ePJWORdao961+k/WWklkJ0c8jh+diorGFzpwKILvawNt4oQw9/AZIuY8PjbPmcQD7VxSLDsfFneVZg0c/z/l9+NYmjLhQLR5ChrpKd1wi1oQpA72pCB3o12Dq79VFuC5PlNApm8pbBuMiCy5lzX8Qg16rlrUhjkqpL5uyXtHm6hZlQsb6apDDC1+CZqnBFAPGRswV4MbSQrS2qpCFu9Wzcn4pkhSjdCQgcm+NrXgWLzIIWCnsJRIG4/iJS8oHseyypTSy9gOGlK+r5p2zxAIpco13G2WXjkZppE1M1rKReBvrlk+rtlE4coyi9EAwTtRVwbPI96+ufN5bHOXUxrhEbw6ZUXAjImgcs7dd7/dQZ7yookj1+xLU49HGt8
 HU4lAgku
 NCCTO9FWteDSa5QPHWsdkTI5ErKCmbNbDcI/zu9Knm9WeGVi/1fRc5vJFpnIam7r6z+XDWSy2jz0EdlddH70C4lYoc2fi39gByZJAyaToPUn3dlLyXUwe/ZbYb4ADN/rlAwZa+JlZ7houy7XzK9sIywb92xD2iKOoS83zowmnwyKH9M57zdFmhtJqnn6mbHYm0CjiMMSiZxI27d3Q5XGsn8yQit9bF0aAjvSbI1oqBZYQ2FgPOiqvk4Z8pIskFuJadRKFW6Fs12CRHbMiYQFLCzFtoyMVP4FLC24NH5l+j/v0hmWVmx0AGe6nOGbTdgBGzeHuX9KuF205SQ3mwczg22Y6kEaoWeuTZXh/RQrGZyq4M0OG5weph/WE+35Lvdy5unph
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 30, 2025 at 9:35=E2=80=AFPM Baoquan He <bhe@redhat.com> wrote:
>
> There's no user of swap_active_head, remove it now.

Removing swap_active_head for 32 swap devices is less than 1K memory
saving? Only the power off code uses it now so the reduction of
complexity is very limited as well. I consider this series payout is
pretty small but has considerable review overhead.

Another consideration is that swap.tiers is possible to use the
swap_active_head to find swap devices belonging to a tier, because the
swap tier is a range of priority. We can revisit it after the initial
implementation for swap.tiers.

Let's hold off the removal of swap_active_head a bit.

Chris

>
> Signed-off-by: Baoquan He <bhe@redhat.com>
> ---
>  include/linux/swap.h |  1 -
>  mm/swapfile.c        | 20 ++++----------------
>  2 files changed, 4 insertions(+), 17 deletions(-)
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 5b7a39b20f58..dfc0cc9fc166 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -296,7 +296,6 @@ struct swap_info_struct {
>         struct percpu_ref users;        /* indicate and keep swap device =
valid. */
>         unsigned long   flags;          /* SWP_USED etc: see above */
>         signed short    prio;           /* swap priority of this type */
> -       struct plist_node list;         /* entry in swap_active_head */
>         signed char     type;           /* strange name for an index */
>         unsigned int    max;            /* extent of the swap_map */
>         unsigned char *swap_map;        /* vmalloc'ed array of usage coun=
ts */
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 18b52cc20749..80b34dc86a95 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -85,17 +85,10 @@ static const char Bad_offset[] =3D "Bad swap offset e=
ntry ";
>  static const char Unused_offset[] =3D "Unused swap offset entry ";
>
>  /*
> - * all active swap_info_structs
> - * protected with swap_lock, and ordered by priority.
> - */
> -static PLIST_HEAD(swap_active_head);
> -
> -/*
> - * all available (active, not full) swap_info_structs
> - * protected with swap_avail_lock, ordered by priority.
> - * This is used by folio_alloc_swap() instead of swap_active_head
> - * because swap_active_head includes all swap_info_structs,
> - * but folio_alloc_swap() doesn't need to look at full ones.
> + * All available (active, not full) swap_info_structs protected with
> + * swap_avail_lock, ordered by priority.
> + * This is used by folio_alloc_swap() because folio_alloc_swap()
> + * doesn't need to look at full ones.
>   * This uses its own lock instead of swap_lock because when a
>   * swap_info_struct changes between not-full/full, it needs to
>   * add/remove itself to/from this list, but the swap_info_struct->lock
> @@ -2539,7 +2532,6 @@ static void setup_swap_info(struct swap_info_struct=
 *si, int prio,
>          * the plist prio is negated because plist ordering is
>          * low-to-high, while swap ordering is high-to-low
>          */
> -       si->list.prio =3D -si->prio;
>         si->avail_list.prio =3D -si->prio;
>         si->swap_map =3D swap_map;
>         si->cluster_info =3D cluster_info;
> @@ -2553,8 +2545,6 @@ static void _enable_swap_info(struct swap_info_stru=
ct *si)
>
>         assert_spin_locked(&swap_lock);
>
> -       plist_add(&si->list, &swap_active_head);
> -
>         /* Add back to available list */
>         add_to_avail_list(si, true);
>  }
> @@ -2682,7 +2672,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, speci=
alfile)
>         }
>         spin_lock(&p->lock);
>         del_from_avail_list(p, true);
> -       plist_del(&p->list, &swap_active_head);
>         atomic_long_sub(p->pages, &nr_swap_pages);
>         total_swap_pages -=3D p->pages;
>         spin_unlock(&p->lock);
> @@ -2958,7 +2947,6 @@ static struct swap_info_struct *alloc_swap_info(voi=
d)
>                  */
>         }
>         p->swap_extent_root =3D RB_ROOT;
> -       plist_node_init(&p->list, 0);
>         plist_node_init(&p->avail_list, 0);
>         p->flags =3D SWP_USED;
>         spin_unlock(&swap_lock);
> --
> 2.41.0
>

