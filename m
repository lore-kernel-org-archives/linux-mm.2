Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D0A0C87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 18:07:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFBAC6B009A; Thu,  7 Aug 2025 14:07:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED3FE6B009D; Thu,  7 Aug 2025 14:07:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE9E26B00A0; Thu,  7 Aug 2025 14:07:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D1D2A6B009A
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 14:07:01 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A5EA8C09D4
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 18:06:59 +0000 (UTC)
X-FDA: 83750742558.16.1231EEE
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	by imf10.hostedemail.com (Postfix) with ESMTP id C52BEC0002
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 18:06:57 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ajWQSkd6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754590017; a=rsa-sha256;
	cv=none;
	b=XO79HkpyHle37sAzilN7cfDEhs+Q9BosrjDshngnu8y4v9VF3aBNb23KeyWUMtfaOEdNC6
	+QNTNeyWOyiZOWL8nvkhKqa8RBoSTQoEe2ySfsjp1clZeAvnnb7yn1sJbML2XJjezBleeD
	lh7/A/1XDKfYKGr9EMAYWnNsIMSqmNw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ajWQSkd6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754590017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zp2kgjsHdQl1y9XZJ6AyOg36IvapsXoaw7KHvWhnVmY=;
	b=X43vehPv2yxLN8kU6FKMF47eOHtk0rH2jXpIVgssR0T/o1NlNOphhUFHILMV+HsfjVJclv
	77QAquNL3Tvmcl9X1RhXa9N2Um1OVqAjRN+HMM0hs8l3EVdyhacXxx+h/aBulxKsTZcGgl
	pMiD9Ih8mB8d1ux89pTaPiCxYDb7CPo=
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-881833b7adbso79423439f.1
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 11:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754590017; x=1755194817; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zp2kgjsHdQl1y9XZJ6AyOg36IvapsXoaw7KHvWhnVmY=;
        b=ajWQSkd6iWVy1dLWyBBWvZ5A3OnztKoZOifn7HF5sdU6WEFw4Dpwn3C53VT/Ux5L2I
         FsZR9Mdoz3VkWvww+G2J7lvACwxx7GcTjQrlju/6ie52QBuLj6PDT9J5uWrA6iBMISr+
         uprS5in3595amFjKQ/QcPCXmkxfdX3l/3VA8j0moXhnJeGqh3o3nj6rr2dLN7lJpCYCO
         5VV7BpbtawHXv2w2PB0ovMTDJJrsaqxvvz+tInxDG8n2EJO7AJEeHSMHsbjNRXM1gDd1
         hs4/HVBB1eyjVXkXx1f38Z0d/GOT+fpQlzzAalhBkR51GwI+0ZeeoHog9GDmlsMX5+Vq
         RANA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754590017; x=1755194817;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zp2kgjsHdQl1y9XZJ6AyOg36IvapsXoaw7KHvWhnVmY=;
        b=NK1CQ5BuPKfUTtT/yNaVdmEr7+2DPkvyXdNpL9JVSF1QULp8ZKPEdiy3RKNeAres7l
         t4YoyklHyvgRtjycu/FhOGE7zVG/9mg5QtZXcJyeeQpf+wa3XaDfVrdyf6+3/zdp+AZi
         INcFUvxJZA3M5rMRZzT0KFy3xlksnMXRDooZxSM/vZXl/V+JQtcgrzYS3wOJ3t2SMXRJ
         GqmzmLd8bQdo9cQ3adZvm3oDwsQISQ6AUWDKQ9p86N2mzN75Kq3s+LTEjOI2OFtjRDEQ
         o+hMmJiCOYfG731Dcn1hxnwDeZZSkYp92LchMTYI9w/QflEbo6BD/khy1eriSp+mD3qO
         A90g==
X-Gm-Message-State: AOJu0YwSgsu1dkC5vpNK9kqRg3CBySyUOBS2iKGfo9UWL0eLT1pSDB+s
	eScEZ6qp82DG+EiWZzrHs57XRGJw7FqIaHsHiLspBuC2D+AB4A6mnCrHr8U74vcK9Ifwuhtl25V
	kOp3RTwzpeXNYEenRxDBGQb+mHM1qViQ=
X-Gm-Gg: ASbGnctuLoecVYLUBRHIS4Qgg24cphCbqYNh6DAj1GjduyDgwVABytznaG4fVyFB7dm
	8tkQwtMC7v8LBs8S8LXVP/t85xKPQLHQsDqQe+tOh83PN1c2cNbyuIMC2hqscGcE7nt7SutfOJ4
	Rn3kUPHKuczu1n8/qU9FhRiWffiYmp35eLs5esoMg2LvqAnrZ1fWk4FhyyZ2Or3Ew0tI4wTKDXo
	f6YQGplEFV+2jU+nQ==
X-Google-Smtp-Source: AGHT+IF6dPAP2S0TZkEDfoukOt+XI9zAHN72crWSd6WsyFuYT+/fEx1aYTk25IY/ExVBRYVry+Q6cZfvcPf1ZT8Wd0M=
X-Received: by 2002:a05:6602:26cb:b0:85b:3a51:2923 with SMTP id
 ca18e2360f4ac-8819f414119mr1653264139f.14.1754590016730; Thu, 07 Aug 2025
 11:06:56 -0700 (PDT)
MIME-Version: 1.0
References: <20250807152720.62032-1-ryncsn@gmail.com> <20250807152720.62032-2-ryncsn@gmail.com>
In-Reply-To: <20250807152720.62032-2-ryncsn@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 7 Aug 2025 11:06:44 -0700
X-Gm-Features: Ac12FXzvrnsqjPLSpRzyIBRnWh8E726wBNHUXhmVtmPyFOqC0JBtFx3WCFvljX4
Message-ID: <CAKEwX=P8Qh4mOdv68UfXv-YBSnuZJkhEeuRJezZucbX7sysWvg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/3] mm/mincore, swap: consolidate swap cache checking
 for mincore
To: Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, 
	David Hildenbrand <david@redhat.com>, Chris Li <chrisl@kernel.org>, Barry Song <baohua@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Kemeng Shi <shikemeng@huaweicloud.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: csm59q9ce45h1a3omujf55gug4u581tt
X-Rspam-User: 
X-Rspamd-Queue-Id: C52BEC0002
X-Rspamd-Server: rspam02
X-HE-Tag: 1754590017-708747
X-HE-Meta: U2FsdGVkX19XbPGNntLBZdghmq8KohyUIrUs00yodR5kIXY1krH6RowUXILRW8dhHJ5EN/dbHYfdbMsI6Ju4jcDO9NtOUD40j02+4vcip4MMeXkzP7BQxKLpU6iruZIwCAbuQSMqjUU9Bc/SZS/Jy4pFkCLM82FxSTEcIByUxkT4n29uALy3eBa+Umm1DqXNDW+DwLxoroXphRQReRPUYKpZJB7thwkxU09w7gY0JtgR1lA2w7RFqv5JAEoyizPh467Dd/VWo6XHdBqOmIRuVeywd4ud+I2OOl7s9HSgipHjWMFIg8yYxqRJaFFcOXK7w0BgugN9QXo7hY/1fe9HHXWztIdim6l5c6oXZFvVOmJu+Pj/yEU6Z/XXKNHUg+OHUPbqGyT7roR2PpkXWPkNPdGjT4fn8kQAkXXrnrL1traa/C1/QQbks7sIYyt6/bujFZeVEMlDz/kKXRBXXxvZB5djyoFMf91Yn+3EoAzJ7icv9Qt7iXka5LrKakZX210eM0RCXHDqWR/H0RGlOHABxcilk1PHYahiH1/oqRAK6NA2Pl/nRuVbl1odBxGzlmIJLVepGx7GD1oVqdrMw0ZMHut7Lob0thkV37kvtSsLfKXiLz0Gjzkz0kD7w9WXXWF/4psHV3+abMa0qkPpRs/21vukMSa26tHKcyztVKzP8rg1iZrOkGEQz7u5klLA4Z9reBOqOwY/EZRy+YE9F4Uw9KHMOhPc69zheJ0fhOXvtUzbTZabIY7172/DDd+US8VzC5JAmo0MJOko0N5UdvuId5VDPvzW8/os+TwjcnBA9Xker+05D8pVTyhjVpznt5eswOJR5aE4xjPwFFyjkTj19wQPmS11TUY5pqmMaH61yk4wkW38HDnJ1LL603DbsbTDYjXwBLUKRiM3/JMnEomhWftAKrVJo7/8SqspLx82+tqHl/l/73N5Df6+GEgNrgONRquScUyhqVVhvJsmT5q
 wu5u0AsO
 jdnb4QAZ8UNrOnBdkWoP/BG8DN/FBoLVZaVT+jS8uuBcAYbhxXuYPIzAy38T7+IWz4ZXqdoMVbz5VTAG3GnJvUOoBTcNW1sM23MzIAzrjgHe2ZbBzN0sV1a2L5Zr0WQYEnFiYZa3Cc4j5EKcgkeH8OpbdHiUMdpHLlQSMNF9l1Y2TiyUjWH5HYOiuJsdboAC5IWrVNND7JCJqiCg5+MVuQkBnvCjpssUxKenp49Arov7WjBXrS5asGHap3/DScJjRQli9UZMlVuMrMsOfwK4M+Xuvi/zUNqtNzz5z3edExWcj3YruXQ1gJ3Tz3oaA61NSks3JyUiUiYLzUZvx5y94PJd0RXfJJQmJZs0rX9hacFWKTXLlrrYJukOJP3bl93FgxFqr3UvoPK8BHs5XBuN8EpqPuw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 7, 2025 at 8:27=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrote=
:
>
> From: Kairui Song <kasong@tencent.com>
>
> The filemap_get_incore_folio (previously find_get_incore_page) helper
> was introduced by commit 61ef18655704 ("mm: factor find_get_incore_page
> out of mincore_page") to be used by later commit f5df8635c5a3 ("mm: use
> find_get_incore_page in memcontrol"), so memory cgroup charge move code
> can be simplified.
>
> But commit 6b611388b626 ("memcg-v1: remove charge move code") removed
> that user completely, it's only used by mincore now.
>
> So this commit basically reverts commit 61ef18655704 ("mm: factor
> find_get_incore_page out of mincore_page"). Move it back to mincore side
> to simplify the code.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Seems reasonable to me for the most part - just a couple of questions below=
.

> ---
>  mm/mincore.c    | 29 +++++++++++++++++++++++++++--
>  mm/swap.h       | 10 ----------
>  mm/swap_state.c | 38 --------------------------------------
>  3 files changed, 27 insertions(+), 50 deletions(-)
>
> diff --git a/mm/mincore.c b/mm/mincore.c
> index 10dabefc3acc..f0d3c9419e58 100644
> --- a/mm/mincore.c
> +++ b/mm/mincore.c
> @@ -64,8 +64,33 @@ static unsigned char mincore_page(struct address_space=
 *mapping, pgoff_t index)
>          * any other file mapping (ie. marked !present and faulted in wit=
h
>          * tmpfs's .fault). So swapped out tmpfs mappings are tested here=
.
>          */
> -       folio =3D filemap_get_incore_folio(mapping, index);
> -       if (!IS_ERR(folio)) {
> +       if (IS_ENABLED(CONFIG_SWAP) && shmem_mapping(mapping)) {

Do we need CONFIG_SWAP check here? I suppose if !CONFIG_SWAP we'll
never end up with an ordinary swap entry stored here right?

Saves a couple of cycles, I suppose. No strong opinions.

> +               folio =3D filemap_get_entry(mapping, index);
> +               /*
> +                * shmem/tmpfs may return swap: account for swapcache
> +                * page too.
> +                */
> +               if (xa_is_value(folio)) {
> +                       struct swap_info_struct *si;
> +                       swp_entry_t swp =3D radix_to_swp_entry(folio);
> +                       /* There might be swapin error entries in shmem m=
apping. */
> +                       if (non_swap_entry(swp))
> +                               return 0;
> +                       /* Prevent swap device to being swapoff under us =
*/
> +                       si =3D get_swap_device(swp);
> +                       if (si) {
> +                               folio =3D filemap_get_folio(swap_address_=
space(swp),
> +                                                         swap_cache_inde=
x(swp));
> +                               put_swap_device(si);
> +                       } else {
> +                               return 0;
> +                       }
> +               }
> +       } else {
> +               folio =3D filemap_get_folio(mapping, index);
> +       }
> +
> +       if (folio) {

Should this check be "if (!IS_ERR(folio))"? Seems like that's how we
inspect the output of filemap_get_folio() in other locations (for e.g,
in filemap_fault()).

>                 present =3D folio_test_uptodate(folio);
>                 folio_put(folio);
>         }

