Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86297D172B8
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 02:32:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBF866B0089; Sun,  1 Feb 2026 21:32:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B69E16B008A; Sun,  1 Feb 2026 21:32:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A79436B008C; Sun,  1 Feb 2026 21:32:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9A1356B0089
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 21:32:10 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5649C160A39
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 02:32:10 +0000 (UTC)
X-FDA: 84397942020.02.3DECEE2
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf26.hostedemail.com (Postfix) with ESMTP id 56360140006
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 02:32:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nKFcBUke;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769999528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jbco1y0UrJcFafKpyZkOGmfOlXkZOI9UM8bDBWoaJ5o=;
	b=yVRiUKqxc0TO2RGKOFpir6GVJnJ9+ZxC41EnBk6/xxtf1cq/g3vl8/gdITo0FSdzCo0kE6
	FY7PpfCLGIBTrPN7xKBwXNRAelmKeUhcxn9Tz+KgIm/MSm6++KkkDPaluofDkeoizKZdDA
	dCIzMKA7gTGEX8ErVhUD56L2e1MmW6s=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769999528; a=rsa-sha256;
	cv=pass;
	b=DAcHXb4YA/2BOqV4sH+4IX6MxnavUWAWaKf7g1Dq6jbzIbJ1YzJg6OMmOeAGb7oMAV5dES
	KdMENvMFFXto/3ogfvq5K2Y7tfnLvuvKfY556l7ilcL4+QtD1MOebFiiBWGqyklhlcuktR
	9zOSv41DHMih5lAP4oWi//ebjtFzzDQ=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nKFcBUke;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b884ad1026cso626991866b.2
        for <linux-mm@kvack.org>; Sun, 01 Feb 2026 18:32:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769999527; cv=none;
        d=google.com; s=arc-20240605;
        b=ahVp9RJ6PUMRTniSIAnW1LVTs/M2JwdkmdRAalfSS+Prv3xvE7h+ZMBuowpCzlgijB
         WH0WilnIR+RGHfFqEJN2Amy8RBWjz1chcX3+JUHC+6eIS6x4dK9DbQFU7oXMwhUZINcM
         H5Q8It/cOvR9GEsyD/WzveRfbJimog+Pbeaq98+ODQ14vlJf27Rb8Fucdy5JRQ/XVfF9
         7DETisFsU+LFAiDFwHl6aKQl3+2W5dyjTZ8p81VD4wr++cZ3c/G45PiYsBuRu2x0n9k2
         UnUE7hvJOCEV0t5q9Acx87xHPZp1G3PVcvuR8S1n9bqtsH6LE2YP2KdNlqN+9DhkWjcI
         /sPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Jbco1y0UrJcFafKpyZkOGmfOlXkZOI9UM8bDBWoaJ5o=;
        fh=/M6izUITbQHV51XpAlhPrY4uuarulwks39xuCYuWN1E=;
        b=R9dJhUm1jVTPzbNaR6XFd5OTnt3HvSO/szlXIdh/PFoYmSMJ2gfkNGN+CLbo9mIPWt
         FFhExbDavFJuGTop2b54Oz5zeERDnizJOKkdVo/Z94NdhI+m6VxjxDk5VZfgC3B0YeX5
         UAwzrruNElWIhKekxxSAwC/0MROcihQ5dN7ItZN6vk/4i6JvO87gpk4owoyO3R/v3fsS
         tnF/rnRRk+CmQ5abbcldKVtdbIuzkqyjpMEqAtrttxIcqhvcGeAcDKKjJbGT9/BNQtuU
         7FJBJmcD+DzlNBB4k3F8QURMBqlvaaalDtn/1fwMtACerKRnNatj2nkZ73eJ2e+NQwUp
         XQBw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769999527; x=1770604327; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jbco1y0UrJcFafKpyZkOGmfOlXkZOI9UM8bDBWoaJ5o=;
        b=nKFcBUke7c2l69V/XMeXSClmQ3V62VtwWG4mQpgIJDQwJcg8PDMNdws9B/Xio8CKbu
         59b/gEg3aQAeuymMLJgRBMBUUW8ihMHJ2QU+p1uMHF6XapdGTm5Zs4N7UuriLQgv44rZ
         ZtZP9hCi3OEs5MmoXVEBXt8IZBxK2e3JA7HJJvt+esVeeEe87yyqhGgo6LrsJzh/zRlh
         JjMI7V6Rajzb21DJmv1MDX80YhsCgwWBo+h9Gvm+vx9aEUIyXDM1ZrwIr1h8j6AYaSpj
         tftsLYhMSCL7r79nhDw16X9OKdKp3zpHFdljau/xu+HRtJ9A+GVSmIi0IvXu1mq7tkJp
         X9gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769999527; x=1770604327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Jbco1y0UrJcFafKpyZkOGmfOlXkZOI9UM8bDBWoaJ5o=;
        b=LC0V1eLT/MO46wk5Iqn2kG20g/B4e7/hYia0H9fMz1X2TAVEwae78wfmW8GTqBACuG
         TUEWqNQeB1dCcFNrlqZF3lCLKGAHB/ol4NL7XxzQ28eCr/Bjw+bYtYMh36z13TSbtu7U
         UTimFHYsAIcw2aVmL9NLs46WRx5xRDkUqZRL3i7Sn2T9E30lMRbgnCcs5rHJ5AfrYy7m
         eMDRhBS11iBhJKN9+HSbwM1hj0l1rDGueUfX1JvsoN273MRsepvIEHKvVsXimAu1xLKL
         TU7L7jX27fw+fXhZDFSaJmbNbug7duhT/M67e71tXWWO0CurL3VrbkVn/UXzW2DYl1oc
         nkcQ==
X-Gm-Message-State: AOJu0Yz/jRRuOLSDK9j0CUXCfqp22gvTE4LrCLOBp5waVbynXQkHh4Pg
	5b775335eEIYlLT7q09GVPb52apvfupibRZvSAJrFY7EMXz06/49DNMHuHx/J/6djn59Dhp+BaI
	QsGliJt+wS4YSAxGV+LWYuhCwBVM1Q1o=
X-Gm-Gg: AZuq6aIR0ld5mmpwnJnVhFADSHbq6Vhh+MMgb6HavgoqbWp9VOEzG0BX+HBDlJpMmQi
	16wina+T3sfQXP5fB88A7rdzJScfqjjL6r/hMhc67SgbOuZwBshkN3ROin2kpjC1/ZpXyLJe72p
	VFP5DV8j9lJ3OlAcl10n1dqgmp/RQXGjrSfnraqb8/0hLZlOqDHaZ21Axbr1NiyP5zpA3Cwm9QB
	8XVFI27K5ZjPeqO6UMNqmA87YIz04wP97NmzuheLRLRNRkeTWO5AUnxqkC/lnr69/yLdy/wye89
	QmnYwO2iLKLFShrFz2dRnFzLjLBf
X-Received: by 2002:a17:907:8e95:b0:b89:9631:2425 with SMTP id
 a640c23a62f3a-b8dff59afd3mr555512966b.19.1769999526445; Sun, 01 Feb 2026
 18:32:06 -0800 (PST)
MIME-Version: 1.0
References: <20260128-swap-table-p3-v2-0-fe0b67ef0215@tencent.com>
 <20260128-swap-table-p3-v2-2-fe0b67ef0215@tencent.com> <aXsb7tBiG8mZ57NJ@yjaykim-PowerEdge-T330>
In-Reply-To: <aXsb7tBiG8mZ57NJ@yjaykim-PowerEdge-T330>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 2 Feb 2026 10:31:30 +0800
X-Gm-Features: AZwV_Qhhcf0KSNAcJiashxyMBuVydoegWpdcN5PnenD9-1oJHlZKgn6RFYo42As
Message-ID: <CAMgjq7BLE5mMxR1GcBVps83afxx5g7N_yWKR1T7YfsMZN4zJZg@mail.gmail.com>
Subject: Re: [PATCH v2 02/12] mm, swap: clean up swapon process and locking
To: YoungJun Park <youngjun.park@lge.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	linux-kernel@vger.kernel.org, Chris Li <chrisl@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 56360140006
X-Stat-Signature: pi793judbmqiakob86s8zpx1pb4wmgfa
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769999528-925284
X-HE-Meta: U2FsdGVkX1/WRWWNNxPWK1ePlq0WTB+gzKqi/vzYPqTO3fQiYKvfbRK87+cbQNFFL5NO8mCnZTfZiVQwZR2P9gFIO3EiEL38WE3X+wskCPkUCOx90XH+fpJVIi1/JfvLOszd8nF4n+6UDZNeK3kMlfklI6R+gbJay+XnZLcCtfg+/Ne6fGisLFd8F0+vXhT6fOM7RXRe67vLVWSpRA+kOrq05iHosKZ7vfvXfsauBtEUDiae1pt1VebOxHVUWy0ocKbshZwQRZVM7Kn0K6CmM2FlhNPFpWXZ9j89Bbm+RHCw0ZExABIhh1SsIK0VUjqpXqJZS0JUGFZWqG7c+6WhPLxGGLYCrthnWQiA6kZtnqz4VYK+VRoPUqmabhzdnEqEjsEEHFiFlKQIg9Cbg7ffQdboYyWmvuBAX2nwhe5rle+CuOOuM+gznyvd3jTxrp6M20zO/oZjmYPPbBQxh2lq5i69vFDXpmd6qbV/oajbnlPH3+JvvRnUyneDMO1yLD/zlmQvgB3tFG5H9X1/nLU5NKn3m2r527tfMGGFoNpSBSmc94ghSXpEkO+A+LaG86YoWaeGwLrM7Go4TnwXyC3W07E5x1RDleuAFdSEpcQKnyIxVsIUDKUXQUDTDPnMWP5MyyrKJGhbYgn0/wvT8edV+pZFa+oD0svtxVSbAQONKZ5QHQGlp/J/SfmIVLAixEkoWGGlf5IyNneNjpwXTlL5GzOew7xIBcXEX5dSmg5VkVJUuA6HDEFcFhlDhXRrFuJEf5W1xSUbNBAEcnvWdIe7BY+Rs4jJO4m1E64QSloZiei9UrWWYd1jwZR5eFwj7P/XMiM0e45tXEA36EofNAcepp3gZ6kockCQz8Ka3NS8aLCXYQTFzD0dorqF5+qMSKo+RnREQ4rOmtuIq1mERf2sTYZMPqLFXjGxAohAZDX2Ejoq4yZw8AoeGZp8d0PAarWJdu7cm4BKiw/6lMAxJ20
 dvqZVYZv
 7CEHAlBk+PNvboX/okMR+GVnd4KyGD3bkULB3+51iTIqTj3QX/VRJIQ0jKRGPL+1cAmpf88nQG05HZauLeJtm/XZtYK1DAy81CfC7tSon2nlOCsgLfm6DvfJ4GePqSIZfSzhU1nSUOQRgVBvF7Wb61nawkxHg9CgYGi5g21GcnFKSufgE5hGzYwdp+cjqJpP41phyllORAIOH1Gtcn2uiz3m50CmJYepdV5tgqD5/8AL5GD40mQCdCT3Ji57uEF4hdND0YQM9DPVZ1kphR+ZrctXXRMhYbBw+fcJivOr0aw2vuKJIQeyrGSvUTzw4F2V2jtFpN9ntpzSHARq2QTMuSepI3MZyqRklbl9+7wMX6cISZOFG1SAoJRQl+3FEsO8cop073rGH+BV70sxN66ofAEnpk5oFKOk0QbMpgx6Vgw9kRYf5gGug21dYkuW7UhrP1MX++MQndfzuSJNSI0rglwTyFvLWeaJUeExYbdjXRayod1PAiB4PHlrWhFiY9an6MBpSQCbdtMV31ZFeTwavklzAuQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 4:36=E2=80=AFPM YoungJun Park <youngjun.park@lge.co=
m> wrote:
>
> On Wed, Jan 28, 2026 at 05:28:26PM +0800, Kairui Song wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > Slightly clean up the swapon process. Add comments about what swap_lock
> > protects, introduce and rename helpers that wrap swap_map and
> > cluster_info setup, and do it outside of the swap_lock lock.
> >
> > This lock protection is not needed for swap_map and cluster_info setup
> > because all swap users must either hold the percpu ref or hold a stable
> > allocated swap entry (e.g., locking a folio in the swap cache) before
> > accessing. So before the swap device is exposed by enable_swap_info,
> > nothing would use the swap device's map or cluster.
> >
> > So we are safe to allocate and set up swap data freely first, then
> > expose the swap device and set the SWP_WRITEOK flag.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  mm/swapfile.c | 87 ++++++++++++++++++++++++++++++++-------------------=
--------
> >  1 file changed, 48 insertions(+), 39 deletions(-)
> >
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 521f7713a7c3..53ce222c3aba 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -65,6 +65,13 @@ static void move_cluster(struct swap_info_struct *si=
,
> >                        struct swap_cluster_info *ci, struct list_head *=
list,
> >                        enum swap_cluster_flags new_flags);
> >
> > +/*
> > + * Protects the swap_info array, and the SWP_USED flag. swap_info cont=
ains
> > + * lazily allocated & freed swap device info struts, and SWP_USED indi=
cates
>
> Nit.
>
> Typo: 'struts' -> 'struct'.
> Also, using 'swap_info_struct' instead of "swap device info" would be
> better??

Ack, thanks!

