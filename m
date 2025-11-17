Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEF66CE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 10:04:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E8A98E0005; Mon, 17 Nov 2025 05:04:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C0B28E0002; Mon, 17 Nov 2025 05:04:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FDAA8E0005; Mon, 17 Nov 2025 05:04:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EBB228E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 05:04:52 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B10FD12F77F
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:04:52 +0000 (UTC)
X-FDA: 84119665224.03.77507CA
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf28.hostedemail.com (Postfix) with ESMTP id C7064C0012
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:04:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PrrHP0Yu;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763373890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L6VEMEq9IfMPXHPv9S3A8GIMsSg3IBK54raGujcJbIU=;
	b=MW2o0P+whoyODPNVKgVwDGZW8fVEXEsa1JWN13QjNN5l6H4n7Y3OJlgM5m1lk6gz+pdXsm
	/THaRB6Vr2uq23OhD8xiRaYNslhkn6qpjJjRywd8YSvrvCxl22UhcvClIam2F1fMtZJCt/
	UOTnys8r2e3M1dIopUdkJpGTgndDaTo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763373890; a=rsa-sha256;
	cv=none;
	b=3uXdmsmSfDSyTfu5UDciYPicmLjuG5eoz4zP00ltQ2vtsgx637Gx5JlPS7WZbRCTd0UsKu
	02UuidoVHPiquoerM1PXu4tQImZESRo349nSaR3C7C41tJ7Lcg3s/Y6X30FtOn8DdXt+w9
	Ubb5ZVRHSJhECpYIhPWuOr6qmpI16ek=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PrrHP0Yu;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b737502f77bso298452166b.2
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 02:04:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763373889; x=1763978689; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L6VEMEq9IfMPXHPv9S3A8GIMsSg3IBK54raGujcJbIU=;
        b=PrrHP0YuxMSc2/M14jRlK2R+J+ZQWg2NNOP2nF1OSg6gwa/0tGKBu3sJF2/8cbBlVI
         5AHoGTTWQQPBh/8a8a58Rp8oHBK76cFZK1L5vuLMN4HyzyBaUpX3J49tYhAFgbPi31Y+
         84yVDin3XLssvDLN9NIFTxs+HmNWadz+yaKX+S5jmQJJXM7ka0wo0f0stFvudc7toxW6
         KXquhiJHae44gFHCPwCbUIcY4o81dCyoYG1MteD0XmD+qs7CuVhbDJI2XtMBY60PoDLF
         0f/nyUYxNJ52ca3dZjtxBcC4u+eGB/v53xHLrYAMqketXv+17Ajq0bPEv56DIrV5Cvkp
         Dg2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763373889; x=1763978689;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=L6VEMEq9IfMPXHPv9S3A8GIMsSg3IBK54raGujcJbIU=;
        b=v4gOtgMXj5IFms1mbQ4Mo1HTJ4cgYe2u4hiCOCZoIUDYRS3OKkvLc34QlZ5rDreV6O
         o32abF4UJSK6jHWyx0zSgdCfhagghyqcoOJjFwLFqnafbwERoO8Y430jYTNoFLKWtE4l
         iDUoXf/y/RTKrQt3pqZNvT5IE80WU4VjbAGbsjSaxgOFkpatkxKy1vZ69ne+covL7Tpi
         NUTfeJ7s1DasLuwosWz1hE4ZMjc8G5n9L5ygL7jHNXZwaDkSjLPhD+LJcZxcZ0v/DL39
         x/YLG0BXZi96qTDk1e0D41GNT6s5QLR7QK956u0KAbn795c7YxkWiZgJljqqJDPNyaq+
         hCRg==
X-Gm-Message-State: AOJu0Yw+oOT8KSEMLWNp5F1W7wDF/GBYVH/7azse+e4LsevDk5QWEajH
	HOriRgiCISkNhy/owRDdcvIk3IU5vCoh1agPZE/HL+/nLwK9rXntulManpRW5dHIA1zwpKdmVqf
	T3x8fhP7dDgXh6m3dWDlBh8NSZCljcsr7q4ADZns=
X-Gm-Gg: ASbGncvOOuUB1qsn9xDw3iFfQ9l0TVH48YSkEc1Jlqrd4BcMLr5e16HWvKHIgvGlxzX
	EiHFV7cBOH+ceyLUai+jAlvaz/XhvEJE1lbW57KB5wT64a/oZC4GLXYjlUAMEvDZNGs3MCB+V47
	NsoPJNEbiQtpQS/0jprSuEWc389IxD/DR7gdPicxhDXy4GwjKbmPs4d9pVBmS7TtZf7VmG1lX+w
	xr7dgaO12Fc+1aIeIxosgNPiW3Q4t+Tgti3tLcuixdNgA3glEAu20id5Uz9nOSHMm96YaSZFvqP
	Khlf9eXchvzP4pMjKqjWFE7HQOGn9kE=
X-Google-Smtp-Source: AGHT+IGAyqeANGLnKR1YDq4YWgQc6ow+acC1Y36P486noxikq+OTT942b4dWFmXtUmUY3zB2QPOIqUbAjECsDNbiJbg=
X-Received: by 2002:a17:907:1c81:b0:b73:42e5:a59e with SMTP id
 a640c23a62f3a-b73677edb7bmr1058753866b.12.1763373888854; Mon, 17 Nov 2025
 02:04:48 -0800 (PST)
MIME-Version: 1.0
References: <20251117-swap-table-p2-v2-0-37730e6ea6d5@tencent.com>
 <20251117-swap-table-p2-v2-2-37730e6ea6d5@tencent.com> <CAGsJ_4y9sQd9x-kOqPZzaNPTtSOhFSYzFdjiRsJFjT2myYEK7w@mail.gmail.com>
In-Reply-To: <CAGsJ_4y9sQd9x-kOqPZzaNPTtSOhFSYzFdjiRsJFjT2myYEK7w@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 17 Nov 2025 18:04:12 +0800
X-Gm-Features: AWmQ_bkCNQO_gSLEfI5CS-8EIvLah7vuMsY5fUjH0rEU9BiAwJlQTJgz6Cd36uE
Message-ID: <CAMgjq7AKWEqzHtMFWcKPCxWtc7jE1j9qGOQ3izsxRef9FCd_+Q@mail.gmail.com>
Subject: Re: [PATCH v2 02/19] mm, swap: split swap cache preparation loop into
 a standalone helper
To: Barry Song <21cnbao@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Youngjun Park <youngjun.park@lge.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: C7064C0012
X-Stat-Signature: sps16yanxkyy3pz5ori6x4obu9rcmmxy
X-HE-Tag: 1763373890-672432
X-HE-Meta: U2FsdGVkX1/ttnt07KotRiOgo1GR8EpSH55YVbFVyBl3p+EPR1JXBpHQc6VYyVj+slgsXSSzFtC0ZkZvWhXjU6gjpk6cvR3avmqKNz0tEzJdL5iscV2NKMtFUN+IOW9B66ysPktLJl4hd7537JMR1uDieR7YtiqzjD7a5+30DliorSiN5kajwtrUyWMsGq10BIyrUHPjH0c/0+0d8mBy54IQwcGZD1Mz97tcqz4sixkym/crptLIU2l7qs9jlZqtm2kU+R4Rpr2fo4QvTb9VbmV2PnY7AMzCXW5m7y9YugTXvjcmYfYvKtG6ivjkkBNazcQNk4nJ0LyygTn61klxNN8B5CdCwCjfDwNiAZuvVpM7+zxCx9Tr/5mypk0o41FqU7tQb+Xkx3WyDQ5/keRNbzgEE2TFNnR0jmbAF3vZ5AGwc5axz16XMoMOoWQSfwPrUjzixVJ9bQ9ZTwiKb9byaNDfep4QdZXM5xtPVlT6srbgSmZ858YjZ4ektaozoMRIN2nX514oMyrBMqwPR/ITNSoQ33lvhVxR3PaXeNZ4Me9HCyCL3GptL2u18y/j3tZybpINcapDVZFPbfSbCT2/pMXqdTKkf9DquINRig3fF/7zkVQuARhv/ABb1nwjPcgOs18PB0HJ248/E6bQn0VTf5clLsNUiwZ4KdG3vUWO00BP9hq2IzjOyI6kqbhe8uj9WwyJdhkdQK/4QLjAT64oR0pqcqmiSErXCDfQ0+Fps4WGNSIUvO3LlGO08zU8eVw52+6Re3gOF9clV3S4whRCIfGm4laULpe5vLI7fnrzIp8Vy1C89LEnzPygk00/VN/sDP/8IbpWiqqQuykj1swDWNw26j0aGG4s4fDjxNckyJKRyicBCuDdcK6Qu/C5COfdAJS8O+6vSChJlzxtSiJR4zbtB/ObFlxGSN9yg5k24Xi+6mqXGr8FH6CZ5BW8iF0V9qMn3agIJ8sIqN+9vZE
 OZe9R4UL
 thW61QfAbkl6AO9fannMANCtois2od8D2BLM+b4EBscqx6Vj6d+eKRxDYyybX5lwaiikOYGPN1WVzdi3dG9pNmj670+ppp+bgv5Uz24UPFC+fuuj9D2WJWpnMGH/kLge8ASBl47Q+LXAtSYMvHyZjfYh6td6FOBM4l28ItpW90ldz5b/DxfUkpnbZZIryO/TvwVFnjLTx61hRznHgKCL/4UIPjaAHtKPkKejLfFpJwtARotC2F3KUFB3JQPG7jppkMXoN05vvQCp9+CyKdQmgmwRoaagbuOV2g0VGqTXxaSBXGKUNKBimRpBCjIqV/wHS9TMasF/L18W2cWUPlN0GlTiX+tmoF+hj4H6rqa1hPgCjbPn7Qsto5OqLTiaXpV83asv3nSYlksfwrIbY0VIhfq2zr+U3c3DDKhQSCoiuIxm+ewQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 4:27=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> On Mon, Nov 17, 2025 at 2:12=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wr=
ote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > To prepare for the removal of swap cache bypass swapin, introduce a new
> > helper that accepts an allocated and charged fresh folio, prepares the
> > folio, the swap map, and then adds the folio to the swap cache.
> >
> > This doesn't change how swap cache works yet, we are still depending on
> > the SWAP_HAS_CACHE in the swap map for synchronization. But all
> > synchronization hacks are now all in this single helper.
> >
> > No feature change.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
>
> Overall,
> Reviewed-by: Barry Song <baohua@kernel.org>
> with a few minor nits.
>
> > ---
> >  mm/swap_state.c | 197 +++++++++++++++++++++++++++++++-----------------=
--------
> >  1 file changed, 109 insertions(+), 88 deletions(-)
> >
> > diff --git a/mm/swap_state.c b/mm/swap_state.c
> > index 08252eaef32f..7b93704fcbe7 100644
> > --- a/mm/swap_state.c
> > +++ b/mm/swap_state.c
> > @@ -402,6 +402,97 @@ void swap_update_readahead(struct folio *folio, st=
ruct vm_area_struct *vma,
> >         }
> >  }
> >
> > +/**
> > + * __swap_cache_prepare_and_add - Prepare the folio and add it to swap=
 cache.
> > + * @entry: swap entry to be bound to the folio.
> > + * @folio: folio to be added.
> > + * @gfp: memory allocation flags for charge, can be 0 if @charged if t=
rue.
> > + * @charged: if the folio is already charged.
> > + * @skip_if_exists: if the slot is in a cached state, return NULL.
> > + *                  This is an old workaround that will be removed sho=
rtly.
> > + *
> > + * Update the swap_map and add folio as swap cache, typically before s=
wapin.
> > + * All swap slots covered by the folio must have a non-zero swap count=
.
> > + *
> > + * Context: Caller must protect the swap device with reference count o=
r locks.
> > + * Return: Returns the folio being added on success. Returns the exist=
ing
> > + * folio if @entry is cached. Returns NULL if raced with swapin or swa=
poff.
>
> Not a native speaker, but I wonder if adding *already* would make the
> comment clearer, for example: "Returns the existing folio if @entry is
> already cached."

Agree, that sounds better, thanks!

>
> BTW, returning NULL may not be the best option. Returning an ERR_PTR
> seems more specific?

I also don't like the idea of returning NULL, but all existing callers
are all using this convention already. To not introduce too much
noise, this maybe better be cleaned up / changed after this series I
think.

