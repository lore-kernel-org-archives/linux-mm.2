Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 321CACAC5B0
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 00:05:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4904B8E0005; Mon, 29 Sep 2025 20:05:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 467E28E0002; Mon, 29 Sep 2025 20:05:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37D608E0005; Mon, 29 Sep 2025 20:05:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 219C08E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 20:05:09 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7961A87867
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 00:05:08 +0000 (UTC)
X-FDA: 83943971496.27.5860C0F
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	by imf15.hostedemail.com (Postfix) with ESMTP id 80178A0016
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 00:05:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=FFP6elPg;
	spf=pass (imf15.hostedemail.com: domain of almasrymina@google.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=almasrymina@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759190706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qTFYa5j3Us4Va0xzYEn1WzVmgM5S4ZHh6Nsw7evNDJg=;
	b=civoQBir/SMBV52uGSD5IIzdClOLfede8hE+4I18gnZC8GD5jUpJvRIvzGh1L+Zf9yh6jy
	GxIqP0OlXC5/YobkDoeKB7nNy/xdCuZEqmNUTXxqrtGUBmMFOSIpbyl+PwYk/n1G8jXTTt
	y0JqV3VoWgOdt6v5EtdTWd2FsSQzvq4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759190706; a=rsa-sha256;
	cv=none;
	b=yIvmm7Vk+MMziu8+jm2cyeTOT8pfxnA7WYt3XTErW0gaQPtS2xBAGIsQk5BO5TQd/MAB0G
	KF8OiGX/qLP6SlfncvjZJj3ibab8e2vKjryEjxmVtk8PEkjAwYbJI1rg8nJhb1vhh80e65
	En4EQ+05bYiyPab/YTJcrJsrwQbPEMg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=FFP6elPg;
	spf=pass (imf15.hostedemail.com: domain of almasrymina@google.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=almasrymina@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-587bdad8919so3882e87.0
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 17:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759190705; x=1759795505; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qTFYa5j3Us4Va0xzYEn1WzVmgM5S4ZHh6Nsw7evNDJg=;
        b=FFP6elPg2ohnsO1MBQak5+ZMz0YgONyCLDnDKY41Ok2c9+tAO7CheG0t1vkNjBgDiH
         9zaHhtf/vd2U1NHhm1YFopOG4WLP5sbr+CB82r9vQb/XJy3DlKS3FaFvK1iBn27gU8eW
         bf3xB1UK7WD4djF8riCpM45kfxHzDafrCA/n00tpw+W85UjaSwhSZETGPn7Oi6PVoc4t
         Sk860JJ1Bssk1HEQ39fevbDvRv3+f8hXl6UAogmVkdoPC2Ap0ufSQMtlt9vrFWY1TKm0
         GorJv7wOhPxozkmqWBK2vXztu5ouMHJG+fu7mb5+EP3knYLatqlYk5sccCrHHFwUK7tm
         gX6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759190705; x=1759795505;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qTFYa5j3Us4Va0xzYEn1WzVmgM5S4ZHh6Nsw7evNDJg=;
        b=ep2TNa2NVds/3Brr65hvETiKPCs25oOAmyR8B78JND71uZMHG4DppxiWU53rfXxEIw
         0OF9L1F/VIrKtW7cOywefyFp6qyoVs3FedaGv4+aHZPRLKGGiTZKFZNrFKCSa1bghrku
         IlRxHadLMdvuqsY63jLyKeDZz64c92KbZOdnjntzSThEEACyHS3y348/Wbv3Dq8kybaG
         JUpwNzSu9VIa/1+GY1NUQ6fGd/BHnbAKBQA7M865byXAmbxFiERZ8cXF+m37CAe7jzH9
         uHd7LR7tNMz6uszhejP+fcfEzn6jxcEKCIY1bTvamaN65NTYuOgsLAqSCdA+drPRZ/9h
         Q+OA==
X-Forwarded-Encrypted: i=1; AJvYcCXk/xom34t2Hz1mmUtLvG6QK3cRYF2QLoyfA2dFOQk2iqmpGGlHwlIsbXjFvGk3aqwg7q0H0UIB2g==@kvack.org
X-Gm-Message-State: AOJu0YxVCD5QUY7ooClyMu/0rQ9h/i6zUMjZCRWFySyj6wFJd/Su+B0g
	mk3vaMqQop39uAbxu3T7IW5gUZRJMHLSU6JCR1Pc57tFiRF3mHWK8pJ0laIjrTwIcE8ey33nbpA
	6LIqTg6Sri3Gmaplg6lq6ijtInXrr5puHQgAfsJtF
X-Gm-Gg: ASbGncvBE33mBoK8XQHK46aHVCGaxOBK7vT8cjdRSCp8gY9p06MSHPw5cFOlUY3s4VK
	EG8cI4S02vuB8Emql1JUNLEzhy8bnyJrj2c7Uu2MVGONAlVTVctAlrPnnXK4Q+rjR9Udurki9yL
	eR1Q9uOBmlV/SOeQQx/3km0OGWIbMIjPo8k/cYcMDBceeDVhQWqlBaiOxkBujRbQZ+rezNRW2JM
	H1rWwC1TXTUh/L496kpPfX62vMO+oe4/6Bzdex0YJ6kwgF3DCGiMLUcGY5tR+Lpt36REcbBa9Ue
	gHE=
X-Google-Smtp-Source: AGHT+IGIu6ZfUFC6831kj/kQZIrUVyEtrf6F1rhZW2LGImkBg3bJpbAXTgFFPJ3huPmnaWNhKXDuheNSSUczIVpSXDs=
X-Received: by 2002:ac2:43ad:0:b0:579:78f4:9c37 with SMTP id
 2adb3069b0e04-58a96682e41mr102373e87.7.1759190704260; Mon, 29 Sep 2025
 17:05:04 -0700 (PDT)
MIME-Version: 1.0
References: <20250926113841.376461-1-toke@redhat.com>
In-Reply-To: <20250926113841.376461-1-toke@redhat.com>
From: Mina Almasry <almasrymina@google.com>
Date: Mon, 29 Sep 2025 17:04:51 -0700
X-Gm-Features: AS18NWBo6Spv6pqHnyjBYozErlOOQW4NN9hFr99N2o7oXA_HCtzRJ7sGtISz6UA
Message-ID: <CAHS8izMsRq4tfx8603R3HLKPYGqEsLqvPH8qfENFnzeB5Ja8AA@mail.gmail.com>
Subject: Re: [PATCH net] page_pool: Fix PP_MAGIC_MASK to avoid crashing on
 some 32-bit arches
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Jakub Kicinski <kuba@kernel.org>, 
	Helge Deller <deller@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	linux-mm@kvack.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: asmixtqdftpbt8y1b1f88ji8qy1x6917
X-Rspamd-Queue-Id: 80178A0016
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759190706-990190
X-HE-Meta: U2FsdGVkX18CuWXKbNd2sLrO6IK+9oI1Qqn1GVoY1ri33fFVcYX2SEIfm6Na5KphiaF4P/e28hv9BXxJKqBgYTvrBsT8mgWHs0psWSFd5zN4jLzeH/1qjWXNE+JDXXL+l+/Do9xWDVHS+HQU1lF3auJYDlFjRhwklU+7cylTfPo+SshFVvWlilciSEV2JsahDk+rAqiwFSo+JZzwWPjQgAcbHc9atTBLyGdWSUmuV6wGRcH8O/E5BFF/HU3jxnH1p2QPqBu57c13hezqpyEp9eaufbSEUpXUIazbx1m6LIMfFA1cK8yqKEEBbGte5RApwYt2eQ+FlUq4XjTew9KT9aujtaP17PICGPQr6z52eA3HDZbL10G/pw5MckgFavn5GmEapyTgZnnYJjtAmnw2CrSMtZ42sc7ApTPEn+TrpoRzq9z082LlICQQ08v06RcBdIjiIOm+EbU5tfebapycRJgc8kwMcp6yYsrMufTUHGX9jvs5N9bBIQF+eBB56BseQpnX4l+7tpTX6S9LDmnIsudmA1OZTPz5lLri/brHMW+6RodrHBOXt9e6L9enCXqQhHWd/fyCJt28YrnRZG2kNWCVTk2uPqRWm8qjMHgdCgyfsHeT6ETfxu9eLu65p3+562XE7U1txrnvFcqBwgOfpv0Je0z99n5HtaJcr5qTQdw+OjA9SsVJdGxYRfe20NmJva+i+ROHif9BVjCKlvHXxSd62IoGfaFL17IGZlOOSqD4Sr3Xl7KFUR9A+di20g4NtCVdfKnqA/3qN4wLJyJ0A4vsM3apqGlTA9ea8HhIJDBORMTuD5KLa2Y5xGe8TriULwjuNlhBgFsFE99y29+gue03JHEaCc42CvQzOhV4wp98Hl/tPKaVRPyxYVQDLooI8UDAPcaxAdZ9j7bF6F2SK7iRKtX0GF8AxQ3VfrTwjjPKYSE/aY5Q3V/j2G3YB/rWdyBR8RSguhxwvBXOBfn
 JCJdvis2
 hGwMN1r453JUU9EBQO2HLITwAlIwAqykMPrxCmmy3avKCaWpJRuAlmjPgRhxZCWZiygnNeSqM09/yFg7sPuhDWrWqGrpKcXKTUc6KVyzjx8M8SPxRlhj6HY1Ul0CNN7Y90Eq7rD5NcPB3wmlWpqNS3N/ABdqo4lbeaXglqifJ+132lgMGviyc5WmFyDD3xJk9ppF3tivv9+8Z8WsyJnu5iN8tZt2EVlT5T3s27eCFxlWLArpozSdNbsfL8gNfFIKqHdZMYiptBxebec47UmScfV2uX+ELN7wQofnZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 26, 2025 at 4:40=E2=80=AFAM Toke H=C3=B8iland-J=C3=B8rgensen <t=
oke@redhat.com> wrote:
>
> Helge reported that the introduction of PP_MAGIC_MASK let to crashes on
> boot on his 32-bit parisc machine. The cause of this is the mask is set
> too wide, so the page_pool_page_is_pp() incurs false positives which
> crashes the machine.
>
> Just disabling the check in page_pool_is_pp() will lead to the page_pool
> code itself malfunctioning; so instead of doing this, this patch changes
> the define for PP_DMA_INDEX_BITS to avoid mistaking arbitrary kernel
> pointers for page_pool-tagged pages.
>
> The fix relies on the kernel pointers that alias with the pp_magic field
> always being above PAGE_OFFSET. With this assumption, we can use the
> lowest bit of the value of PAGE_OFFSET as the upper bound of the
> PP_DMA_INDEX_MASK, which should avoid the false positives.
>
> Because we cannot rely on PAGE_OFFSET always being a compile-time
> constant, nor on it always being >0, we fall back to disabling the
> dma_index storage when there are no bits available. This leaves us in
> the situation we were in before the patch in the Fixes tag, but only on
> a subset of architecture configurations. This seems to be the best we
> can do until the transition to page types in complete for page_pool
> pages.
>
> Link: https://lore.kernel.org/all/aMNJMFa5fDalFmtn@p100/
> Fixes: ee62ce7a1d90 ("page_pool: Track DMA-mapped pages and unmap them wh=
en destroying the pool")
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
> Sorry for the delay on getting this out. I have only compile-tested it,
> since I don't have any hardware that triggers the original bug. Helge, I'=
m
> hoping you can take it for a spin?
>
>  include/linux/mm.h   | 18 +++++------
>  net/core/page_pool.c | 76 ++++++++++++++++++++++++++++++--------------
>  2 files changed, 62 insertions(+), 32 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 1ae97a0b8ec7..28541cb40f69 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4159,14 +4159,13 @@ int arch_lock_shadow_stack_status(struct task_str=
uct *t, unsigned long status);
>   * since this value becomes part of PP_SIGNATURE; meaning we can just us=
e the
>   * space between the PP_SIGNATURE value (without POISON_POINTER_DELTA), =
and the
>   * lowest bits of POISON_POINTER_DELTA. On arches where POISON_POINTER_D=
ELTA is
> - * 0, we make sure that we leave the two topmost bits empty, as that gua=
rantees
> - * we won't mistake a valid kernel pointer for a value we set, regardles=
s of the
> - * VMSPLIT setting.
> + * 0, we use the lowest bit of PAGE_OFFSET as the boundary if that value=
 is
> + * known at compile-time.
>   *
> - * Altogether, this means that the number of bits available is constrain=
ed by
> - * the size of an unsigned long (at the upper end, subtracting two bits =
per the
> - * above), and the definition of PP_SIGNATURE (with or without
> - * POISON_POINTER_DELTA).
> + * If the value of PAGE_OFFSET is not known at compile time, or if it is=
 too
> + * small to leave some bits available above PP_SIGNATURE, we define the =
number
> + * of bits to be 0, which turns off the DMA index tracking altogether (s=
ee
> + * page_pool_register_dma_index()).
>   */
>  #define PP_DMA_INDEX_SHIFT (1 + __fls(PP_SIGNATURE - POISON_POINTER_DELT=
A))
>  #if POISON_POINTER_DELTA > 0
> @@ -4175,8 +4174,9 @@ int arch_lock_shadow_stack_status(struct task_struc=
t *t, unsigned long status);
>   */
>  #define PP_DMA_INDEX_BITS MIN(32, __ffs(POISON_POINTER_DELTA) - PP_DMA_I=
NDEX_SHIFT)
>  #else
> -/* Always leave out the topmost two; see above. */
> -#define PP_DMA_INDEX_BITS MIN(32, BITS_PER_LONG - PP_DMA_INDEX_SHIFT - 2=
)
> +/* Constrain to the lowest bit of PAGE_OFFSET if known; see above. */
> +#define PP_DMA_INDEX_BITS ((__builtin_constant_p(PAGE_OFFSET) && PAGE_OF=
FSET > PP_SIGNATURE) ? \
> +                             MIN(32, __ffs(PAGE_OFFSET) - PP_DMA_INDEX_S=
HIFT) : 0)

Do you have to watch out for an underflow of __ffs(PAGE_OFFSET) -
PP_DMA_INDEX_SHIFT (at which point we'll presumably use 32 here
instead of the expected 0)? Or is that guaranteed to be positive for
some reason I'm not immediately grasping.

--=20
Thanks,
Mina

