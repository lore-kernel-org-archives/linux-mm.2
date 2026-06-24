Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54BB8CDB47C
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 10:31:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A5F86B0088; Wed, 24 Jun 2026 06:31:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07D346B008A; Wed, 24 Jun 2026 06:31:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED6506B008C; Wed, 24 Jun 2026 06:31:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C09716B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 06:31:07 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 44FA51202FC
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:31:07 +0000 (UTC)
X-FDA: 84914438574.18.3351E08
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf06.hostedemail.com (Postfix) with ESMTP id 27320180008
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:31:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qZVMHA52;
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782297065;
	b=x0VebmSCwIGxKy/tHiyjzDaUjheWKCELd2BcapGdcjwUWXQ9wAUUMHYWzySovjyc8twayK
	gEIoqFZsl3R7TmeILz9hKpkkB4tQPdNiqeB1dmeuvC10tm8h14+tIvgoSTcy0deMOQcgz5
	6WT9LXn0c0QdExj3GYBU8roMGV7Eyag=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782297065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+se966a5VAHnUNfIUA8gA6LXITCpw7N9W5LzFL8rlzM=;
	b=IghkTCai/8oH0OxuLWz2uoZjvSA6fPgrPaDhNQ6nSlbfU7DKXzmwSG5usw0fdEzNbV95t6
	EYqfXPQR14f3ZgDOy71pSyPrBUa0YH8RthdZ0cc0U6qVcYW8VZHlKEjVI36jC2a0RtMTOa
	awU4DQnLlxcG5Gv/X5gK084bTXN09eI=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qZVMHA52;
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-693c51a8a19so1512441a12.3
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 03:31:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782297063; cv=none;
        d=google.com; s=arc-20240605;
        b=JP8KsbcaanGi7AyJz7HNliAGAvg3H/PAvDf9vzRo4USlZ+5NK9uImiGYyVLEm1vNPK
         aqjJkiXP0amoOjRKsYEBYzm0VbG3dCigjXk0tmRqrdvSL+Al3RNF6U5MmVPPddMH195z
         eUNaPPprCENnyJcmvuDzpL24EQ7OrPoQvFGtlfz7K9rtE+CVPsWPWF0AQNCKggBZMXPD
         7TOVDo7SOFWgHgL1VM1dNwUCOyscbb/3bVVMeyfyIn3aA1Sm6hDGkqg9ul3EQy+mS814
         omZUD0bcIMl80LVmQ3sej7i7VlFybRkdNiD1A7qVc0gSPwgI2poQGp2vlsyzrc7SJ7Dp
         YfFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+se966a5VAHnUNfIUA8gA6LXITCpw7N9W5LzFL8rlzM=;
        fh=zmVvVXtC6NpKrLv4FXhudukbgcZWRwR+qPn36mhEu6Q=;
        b=QFp2Xd5tciN1kzXEORTeJK+zdQUG+wKXOwUkoslbQ6n0jyAQLdfUrnf36NqO/4B1TE
         AmAfoWMHOuBBgPqYQ05JV2PIBtzuuWWr0Fu1z8QAGGozB9umbSv/1TpzSWOsfxoDTQZm
         +l/BtAz9QTkIDRWWSTybFO5tKy380P0kFXJN+1ed+5MBhniiN8tU1oKzMsXvXXEQ7rGL
         3Wk9/1BstY2EE1l2lLrZFOsz4prpS2ymtWWqTRQ+iG/JIqoq9S29OyVB8ktaRbTj5r3k
         izkB5fbJbYt9YQ8km/CJ35tqFg5Dz0xpJ7HJDRoehFmQjZW6ILNkVEUW5BOXmENg8IAy
         Jrow==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782297063; x=1782901863; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+se966a5VAHnUNfIUA8gA6LXITCpw7N9W5LzFL8rlzM=;
        b=qZVMHA52UZ6WRwJQ2SewBhm/4WRHUIsA4zxHO+itGPrj1F6oy1EgsQ3Qf6fAxM6OFo
         9gT15H9f0HXEdqP7Vxlx2sb1WP1e22j/p1ECBGhnyBDDS7tKMyshLR8HNoDGI2aKgw2m
         5k4Y7tI4stEGDvVHCqQq4kf41C116cKY6WCG6hu/8sVtYJAf8EsmFWd3oQwGZKItDwaW
         ND2EDmsk3OQM6wGtgEIRHjYrsbNBHCN/Qjh2SJPQKr2f+36ONdilQDfecrDdYaN/vQd4
         sFDJ1BDrl/uYBB4LWvfH6uw9468QfOTSmZfpCCZV32hcpPyqDiVLJOsyUR4+896amkKR
         IQag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782297063; x=1782901863;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+se966a5VAHnUNfIUA8gA6LXITCpw7N9W5LzFL8rlzM=;
        b=gAGz4Oru2lwHw117AQ/Ny4rKHa5rQ1cxvvVbY8rfoAPDM8w/JNnRAp8YgXvj63+Vb+
         5HrTVC6RbNvhrMklBTALUEB3bEHuPvfnGPf3RDNikFrlG53L07E6mcJIB6M+UxKXOnP1
         YvQSz1hj7MyFTKp5btJskSrt3mqWVV+bYBekmkMN2+qUVbn4iEKrrrzZIR7RNsviqRaH
         /LgLZQff+BA/WUHf/8V4DfSOJSdITw23zYJD+UONyOihGYE46y1KKcowGPD3P26TmvRD
         YafNvOhnXs2mKq3rgk/Zm31VN341JajMsz6LcunjnJCQKGXStjHXvAlUsGD/LIPbgeVK
         u/oQ==
X-Forwarded-Encrypted: i=1; AFNElJ9LBMx5PDfn6FXxkxwdY/yDA4Jt0MG537gn46Mm/SI7t++ocesCrQeV5TmyxNxR5f62mN2R9Hoocw==@kvack.org
X-Gm-Message-State: AOJu0YzGZ7f0t1QTntU7lLcoKyUkpndqiXh4adWHj1LwDBkzVeMoAdeP
	dTd7/XQodEFtrnd0nkC589/5XJ41GaOGvotFX6erzMsvC59oXfcfCjqDoqS8HNNUrVYYFQzYKTa
	keY0SLVYyitLyWbyCeMEtyPIF2fd19ug=
X-Gm-Gg: AfdE7clWhQNL5uek6cq4k774Y0o8mFXI7cOWd+4cK9BFb2jFE+8ToyA956Suu1kppZg
	eCmZC3IwUaScejKvRGbDuSobHWvnVlSPM5dhFGVRBDb5EZxtYJsY66MqXnoC/mdcSXlMBFR+D1y
	w0sxd4So3Ee1lC0e4xwGgrkCl6VS1TOI+UDUV9M/7B6aSN4eXRpRUFr76Y6bv4T4XjAORkzBr3l
	X1QznjIP3YQ5XelvYmpUK08hzrVVusL1U2sjhg+749HEAXJQlF02cX85f8dglugCaDuvYz+MrKw
	dzMUe3V5KH/z/Cicu5hLL2Z3GY7lGw==
X-Received: by 2002:a17:907:d12:b0:c10:fcb1:1ae1 with SMTP id
 a640c23a62f3a-c10fcb12709mr341011066b.43.1782297063110; Wed, 24 Jun 2026
 03:31:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260624075700.751467-1-alex@ghiti.fr>
In-Reply-To: <20260624075700.751467-1-alex@ghiti.fr>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 24 Jun 2026 18:30:26 +0800
X-Gm-Features: AVVi8CcgW10V3UCiY87k4rEvLXPrdEkc0PzZdrV2HbZg5uuEtD9lmZd49CWYev8
Message-ID: <CAMgjq7CfMp_7bhDWirUmxM0pFzk6d9in9h6wuHsMoeUu-+TC_Q@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: bypass swap readahead for zswap
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, yosry@kernel.org, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, chrisl@kernel.org, baohua@kernel.org, usama.arif@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: jn9iwyuoig35orndweqzg8mn8d7t8aqi
X-Rspam-User: 
X-Rspamd-Queue-Id: 27320180008
X-Rspamd-Server: rspam02
X-HE-Tag: 1782297064-304854
X-HE-Meta: U2FsdGVkX1823SIlImDxKGUmqFTc9YBpXlgDHLfo1v2mKmhYBguw2UpLOT5bgDhs9bV8HjTY5aES8RXwuZL1Q9mWydyuAa/9u+aS+snIdIey4r80dIyLV8pdlBCYBqT50CgkCrqDjmpFp7wGdS/RhsKkAq4C1fjEUvlXLWrpxesi4+HJ2MspmLwHNSF5YknQqAzMXl1rfktSU3lJ3Nod16RE5XEpGCQgGgbdbZIPQfVW0ciKQ43OJCdmXDxb2yUXRht9+LZDpkc4xXlyxBRSVUQhJwraW9BCHjxXad3A0hA52kU9E4LyGo6kg88gym5eH1a1dGo/HpxEETeNLvdyfHvpS1xBd7K6Kn8YYTWo+GvbaHsNM+5pLfuPeroQ3mtM76dSfCW3kRqSoR3vs8Z46seCLDOMskLoFirVHB06zj+wpt4r9ZwWvKeVdoO1nNvI3lDOJ9/fEcSYPjUxF3UIaUDjosOH3lzzFRC4oqyks+2oWBqW8OqAsHiqQLD8Uf3GU7SZE1DU0tD0hSerAKaCBg4wtwqCzBGzneruxYaX8eOlw63iCwUBX2Ywf728nPfdBO+AyHG2KkKdvCOBuTWwwKhVkYkPbW0jC4VWxVEmPZn1pCyH2VNTN0y9X65RLlz2AtWdmX8nfz/q7PwOSWIUxaL4Z0gW3c2Cpu5MzqcGlRiUFVa4p0nVNqMRXnTS5qpDkiZ16OqT5I90Gde1sdeG8IPDUxQbxZN4+o2Q+R6buHj7/oyhJVb9anV0+9QAXmx8bIL5q/QxXGY0+Cr0QJxZyV6idREWC6xtMitOfWn2cGfXMET5mPjJlRrlXo8LluAp5Tp7d66DZ6ul034jBXZtKy9gX19BDvdc27mw3wYm07bV1gF9ARjnKZFjEwvRaTkJrTiNyMNJpNWxbYaTNxHfSNy8lVmjlynwbK6w3odvTRSthTPXqEGVC4OGn4QetB3Pqy8OHrgBRK8vGqci789
 fN1DLcoc
 1SBW0vX6rxWyuSGPPnI8WsaFaHELeszYFnuVN0blaJS9988Xte7BoGDMi4+onnqjd04pXEaMS0aSM6lIvvC04jf40ls1LS0R53/X66r3SpFGOyIDvu6d8R+oQW7bLAG2Vhn2ApPNSpbWBbB5wJPGvwec/CKX7bImWx94zKF05Dc0rk/u63TrBYJMs68+P005rDIpN4iWUo593RuTYptdPRntVJMJGIY18agDJW14ItRYKi5mYn7wStchNnmPq7Xt0dj60viDNz9lA4NWpXn3jsvicK7RTWGSsW17kdXfNosNgjBMbngbQTSTSMnL1bybUA/IqMVLzE9FmpzVhVfQTCdrp9Z4jNUmOriYJbXvBfilJmvmWSpWpf4U3prmQ9zCP/d5abDWQUUQ+nDkj20IqRjmnNXxequydwnj3lsIFRtMLzKoxsTy2qUiRa30VtOm5aN0RYY9hTYMZkGQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 24, 2026 at 3:59=E2=80=AFPM Alexandre Ghiti <alex@ghiti.fr> wro=
te:
>
> Commit 0bcac06f27d7 ("mm, swap: skip swapcache for swapin of synchronous
> device") made SWP_SYNCHRONOUS_IO devices (e.g. zram) skip swap readahead.
>
> zswap is the same kind of in-memory, synchronous backend as zram, not a
> swap device flagged SWP_SYNCHRONOUS_IO so it still goes through
> swapin_readahead().
>
> Here are the results from bypassing readahead for zswap too: it was
> measured with a kernel build (make -j16) in a memcg, zswap=3Dzstd, shrink=
er
> off, on Sapphire Rapids and 3 iterations.
>
>   768M memcg (sustained swap thrash):
>     metric                 mm-new    + bypass    delta
>     build time (s)          405.0       341.7    -15.6%
>     zswap-in (GB)            79.5        53.0     -33%
>     zswap-out (GB)          144.8       115.6     -20%
>     swap readahead (pages)  6.79M       0.45M     -93%
>     swap_ra hit (%)          72.1        89.9     +18pp
>
>   1G memcg (light pressure, build not memory-bound):
>     metric                 mm-new    + bypass    delta
>     build time (s)          177.7       176.0    ~same (no regression)
>     zswap-in (GB)            10.2         7.5     -26%
>     zswap-out (GB)           27.7        25.1      -9%
>     swap readahead (pages)  1.07M       0.08M     -93%
>     swap_ra hit (%)          68.6        87.2     +19pp
>
> The gain is from no longer prefetching pages that are pointless for an
> in-memory backend: readahead inflates anon residency and thrashes the
> page cache (file pages get evicted and re-read), lengthens each fault by
> synchronously (de)compressing a cluster of neighbours, and adds
> compression traffic when those extra pages are reclaimed.
>
> Bypassing swap readahead for zswap therefore makes sense.
>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> ---
>
> - This bypass originally comes from Usama's series that implements
>   large folio zswapin: while working on improving this series, I noticed
>   the gains I got only came from the bypass of readahead.
>
>  include/linux/zswap.h |  6 ++++++
>  mm/memory.c           |  5 +++--
>  mm/zswap.c            | 11 +++++++++++
>  3 files changed, 20 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/zswap.h b/include/linux/zswap.h
> index 30c193a1207e..b6f0e6198b6f 100644
> --- a/include/linux/zswap.h
> +++ b/include/linux/zswap.h
> @@ -35,6 +35,7 @@ void zswap_lruvec_state_init(struct lruvec *lruvec);
>  void zswap_folio_swapin(struct folio *folio);
>  bool zswap_is_enabled(void);
>  bool zswap_never_enabled(void);
> +bool zswap_present_test(swp_entry_t swp);
>  #else
>
>  struct zswap_lruvec_state {};
> @@ -69,6 +70,11 @@ static inline bool zswap_never_enabled(void)
>         return true;
>  }
>
> +static inline bool zswap_present_test(swp_entry_t swp)
> +{
> +       return false;
> +}
> +
>  #endif
>
>  #endif /* _LINUX_ZSWAP_H */
> diff --git a/mm/memory.c b/mm/memory.c
> index ff338c2abe92..5aa1ea9eb48a 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4827,8 +4827,9 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>         if (folio)
>                 swap_update_readahead(folio, vma, vmf->address);
>         if (!folio) {
> -               /* Swapin bypasses readahead for SWP_SYNCHRONOUS_IO devic=
es */
> -               if (data_race(si->flags & SWP_SYNCHRONOUS_IO))
> +               /* Swapin bypasses readahead for SWP_SYNCHRONOUS_IO devic=
es and zswap */
> +               if (data_race(si->flags & SWP_SYNCHRONOUS_IO) ||
> +                   zswap_present_test(entry))

Hi Alexandre

Thanks for the test and patch, very interesting idea.

> diff --git a/mm/zswap.c b/mm/zswap.c
> index 761cd699e0a3..5b85b4d17647 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -234,6 +234,17 @@ static inline struct xarray *swap_zswap_tree(swp_ent=
ry_t swp)
>                 >> ZSWAP_ADDRESS_SPACE_SHIFT];
>  }
>
> +/**
> + * zswap_present_test - check if a swap entry is currently backed by zsw=
ap
> + * @swp: the swap entry to test
> + *
> + * Return: true if @swp has a zswap entry, false otherwise.
> + */
> +bool zswap_present_test(swp_entry_t swp)
> +{
> +       return xa_load(swap_zswap_tree(swp), swp_offset(swp));

Better check zswap_never_enabled first to avoid a xa_load if not needed.

