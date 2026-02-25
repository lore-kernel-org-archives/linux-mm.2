Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A48CFD45F1
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 21:40:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A4CE6B0088; Wed, 25 Feb 2026 16:40:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 752626B0089; Wed, 25 Feb 2026 16:40:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 634CB6B008A; Wed, 25 Feb 2026 16:40:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 492D86B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:40:15 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 35CE5C287D
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 21:40:14 +0000 (UTC)
X-FDA: 84484297548.19.4A811DE
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1D5051C0009
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 21:40:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=juTu8ecu;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf20.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772055612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MC48NTCQgd8S5WKSeiW9O6obPMz5m4dtdBz9OgbxJ7Y=;
	b=CqvXqy7GRZQXVP6rNsSfz4sTLYWmxaDnM4dWHtrTZnb/ztU45eoYAddCUZ6hXOVH+N/QUS
	c/OWxvGr2N6lKB9i2SoYYHm1BNW3+SWQQeUSNvzzx6LTWlsJJyqkHVl3XO7vGVoDwiQNvi
	6UdKLH9KcsBzUzVigJfsdXkEFVqLbkc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772055612; a=rsa-sha256;
	cv=pass;
	b=a7Rcemo+c26ISQiUEC6/rghGR4IslN85bJkaPlGYZ63gdGtG0mt3xHL/PrRZYy/7jeaoLT
	1VAmdr5qzHf9Mx1i1PgtjsA9+dji288hMtkzEmOmQEE0YEjqaI3vc3I6MNooQggDCdqxTM
	iE73efXJgiRWaj7QHBlcoxzLUlyHVf8=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=juTu8ecu;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf20.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-899afcec41eso2085986d6.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:40:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772055611; cv=none;
        d=google.com; s=arc-20240605;
        b=bZd8pZ8q7Ml/z8cM+ScC6vZVu7iK5ORcU0jIEDJOqsDJ+YNBogs6dfcraRTWc/y2yf
         m9NqOlMn3w4aZxRmekScEqlKNrEqVpCdXFPhUkM0Ni4eRsvviK2OIWyU181LqIlT8DLj
         Q2RXwd5iLX3o+lRdglu3iG+JMKmXHmsc5wHoM7qXKXoDVfrLuNaWApz3d+w/slt6hHKd
         w6GUWcSeG/OQX84dCo9FO+22MRh8WiHgPBicW5hO33uDYX/JFyXTUgoI+7/b3IIq2Hbc
         +Pmj8knXpsWUzZU6AMZmslMCt06gw5GC6tuQcNEfbdnQplTB7Vc3R5iB5JrV4+O5mFyp
         H2cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MC48NTCQgd8S5WKSeiW9O6obPMz5m4dtdBz9OgbxJ7Y=;
        fh=E1072Ew8pceVyonKHvoWOrGVf1qNpk2VPzz/G+P/TXg=;
        b=C+8MzaQQcpu4oY5HXPVXqa4x23FT3scsGTyiirXirrRk1eHc+W98LrhC3KP9ZGlENG
         jqtWRR8TVu8WVp8n3YgazhzY8qaceTlK2amRqufyaKty19IOoLF3BYMyLX17ZGzTBfJY
         6dD/Hvagqy1jPS9KNVi64rrGLNbPQyxuqc/Kr39fh+cgXXHsDDwY4o8ftS7P3km1ap2L
         71Ak/bwOFq2Iral9JgFugofmbcifPvYue/x/eWpmg1DO+EGpXpGFf7L6s0HomSLQ2LHd
         vW1+5HjD1ypN52JpOQj5Bxi8GfZq3HVpsNdPEuOybYyWiDghaE4yeVTFtDzA9iMPt45l
         qM6g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772055611; x=1772660411; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MC48NTCQgd8S5WKSeiW9O6obPMz5m4dtdBz9OgbxJ7Y=;
        b=juTu8ecunnxIT7A3j0RfsGSOjUH/36y8DcbS9eQwYebphJx9C3foyv64yy31RTBbke
         IMZjkqUNnDKEpl6LTmivUMQftsZhombJbesmob+v6aQaP5UO7Cyu/NUGIi/Kh+J0DnvU
         roT+ZLSvQD6nEmh/7l3iAruBvXekzE029VmKQkSD+PZQdYQ3g2KbiRmJv6TQ5b/94NI1
         o4Arxkt8VmThKZe5zI3r+ngyLmJ69aD+J8b3d3hLH9sJGr3EaXsx2joLxt1OniMbkbAc
         xgID9EbeTOz3Agn2BEw2Rq/w5vysv8phevQmw6TLAULMscNZcYunz5Ki9hRoLABogHIN
         yx7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772055611; x=1772660411;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MC48NTCQgd8S5WKSeiW9O6obPMz5m4dtdBz9OgbxJ7Y=;
        b=wrbuHM3mQXp4LdaZ8ujwEHGAGn6OYONQrA+LlcpIA+zWgzl/hGBjuiNrqyGHF4oTwn
         sCfOLSl55oUKGX4QOzRVmLlYWNOMpw/DG0RJlg2ZHDSE1angnhU09sUNpuxPdso+PlcP
         Me/NQXDfh1w1OBGOkbsnz/JSSbbnl+ncv7i8Lr+N2yWsaqL+JLi39+/NGm0VhEwRutUF
         cpQ9nk1Qgdx2e0qqsIeHLPhy6Hye/uEIQed0qpC9uowg3sNREUTvQo1gx0Tnvas8HLit
         dKwJ2/cQLfaxJuZ1iz0fjZwsIOrNMw/mfcLP1xHSMi+ckkpjyvcvARjl2lCy4QqHzwrw
         FUoA==
X-Gm-Message-State: AOJu0YzaIQQ22Ddz9/cOi8YmQ0ixPM5LYZzTZRO5/MXg+AqSRbmkQOzo
	7fQ1BSo14+6CBSBHHtr2dYHGDRhrQhlNL4fr2NMe116S2Ac71LfAPRFNLI0sXfT6qKJVn6wrukD
	jynmzYYzB0rHrtqFh15M+hioBL1zoT7o=
X-Gm-Gg: ATEYQzz78TxMmqtw+b2ThvBtdWVBIz8akUy6Ov/P5DgwA5vcocHjRgRXciT/k7wo5HR
	34PBmG+ZufArbD4V98BCR3nq5+ScIM93xgX+B/QODZ6AsaoB6kJPGRZItT2fU0HbYZ8EAQeKXcO
	9IZ9UrmIbz2Rann/l93Oy15lAcqogHJngc6cLYHBvhFgiXk5VK3dlXM7/+tYRkVLNICLSQYe4B/
	8xbthAO29ARFUKoP71Wx3sIBuNwn2wKg3Rvtacpt5GYZQ4MdGFEoEV/Uw7aJ5kcTVA/DB5QYAg/
	PosRvA==
X-Received: by 2002:a05:6214:5099:b0:896:a692:cabd with SMTP id
 6a1803df08f44-89979eebfe2mr227932696d6.45.1772055610641; Wed, 25 Feb 2026
 13:40:10 -0800 (PST)
MIME-Version: 1.0
References: <20260220-swap-table-p4-v1-0-104795d19815@tencent.com>
 <20260220-swap-table-p4-v1-12-104795d19815@tencent.com> <CAGsJ_4yv31utMTsZcRf5adeUzC7NnE0DfMKRFi3v1iCxfdXbdw@mail.gmail.com>
 <CAMgjq7AMOuLYRX_A-y8aUuQq-yTPhvj05QbNrLWDQgy+H9MsNA@mail.gmail.com>
In-Reply-To: <CAMgjq7AMOuLYRX_A-y8aUuQq-yTPhvj05QbNrLWDQgy+H9MsNA@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 26 Feb 2026 05:39:59 +0800
X-Gm-Features: AaiRm52x6mqjE0fz0V4-TeY8fmvMuu0CP0XhSo9jwKMgvmqkoqrAkEWcRBaXjRE
Message-ID: <CAGsJ_4zg_C3YbOLduC5dEb-0Ozm033d-KGK7E1Uv5n6NbjGokQ@mail.gmail.com>
Subject: Re: [PATCH RFC 12/15] mm, swap: merge zeromap into swap table
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins <hughd@google.com>, 
	Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Stat-Signature: gda9b1aowjiok3ympf7weqafyh47sawr
X-Rspamd-Queue-Id: 1D5051C0009
X-Rspam-User: 
X-HE-Tag: 1772055611-98718
X-HE-Meta: U2FsdGVkX1/klV5aWlPJaJ3Mrh15zm2uDMl4M4sD8DbuzgcfAz4uqYXbjkAGE6vUxuIzMYG5ZMFabasRKQsBDtSQiPScUDvy08mi4yWLfaWBAlHxAbjt4nT/eTBUzWDATI+v8qzBRvnigqTGv6yyTXaKK/B4JUHR+/f+FyibsaYlXg4q+89gqQchfEXJPq5zkBIOA0MF22XVxHEBV9H4uk/Nq/Ah3+mq/NoyFWUMsvM65iS+PGVh9/2J0o6Gm6h6Zw8UpRrVvXnjrvjdY9Y602RUlW6y13xEa5ZX2pAvjFrYrzbxim/6OUIS1Uvmg3/iAtbneP3WaZEm0JyYD/asb96ShArFAdWSbsPbDA9er/pAH7DlA75bJTCvRWvARmO0hXe6TvcZEOLTLlhCzIZPCAgau26D+4qkBTAhucPVKeYkEMB9Eq7pN1TGY4fgOXqiKk9OQJYxAiOJU127U6zo0U2LinxE3OUjYwoCCp3MrJYLGCXLvHjGNoIxU0F05ylaVEjbEUyHad+NMOVI0kNFCkA988tL/+EFOo13MIleSjkJ5/tBSUvuN7yGPBnXD2+DZN5ry9J/OitxYweP1OX0usJ5rVdEbbr4jw3O1kXyQcsS5IxGpbuFz1Fo2uL7YMI0mGiEbdD/JwZhPkThlrAGGbGMyPInTd+urt+/EgsN+7qmo3wtB1YaLU7qNwYP3UYdcGvyIjCiRfz9V6Z6kMIQHawfDLl2ThMHMAtOry/qgjCNUsiF7q7zNGUt+d4f3Qzk2b2WkvWEb6Wyelu2c9zMtDr+5tgEHRrYCuimc5zwrj4mCkbdIxHzEz9e5C70IzQiW45uRRPycCsAtanJZ8XibIeaVFU7aI8X0o6JLyExVdQ4gAn/2NAPNOy8hzzOByNTfG1TnPLdpnp0Bl8rI80XycIHEbYGWbDaURLRl/x7Ab0bR4yZ0qwV5By5UbeEg6WbPrCJA4V5Uu9vnUsdMlL
 RcaCfdwB
 55xSRyhqJsehbhGog35B4PUJwz8ro16Ag3xfs7zMS4CPW3r8L4A8Wcg5RAApzlGUxNJi59fklalmZmmeQGrUrZiZu9TJrnY5gqdH2giLo0hnzxio/UDIeLdaMMG5gw6oNDv4CvYf4IDz9gGekqK9qX4PZT93zz7oBmUg9w8+iikjpKA0dD/uvLd9fz4NNveFr4ofCrwH/x/ZMDimN3QuBlfWd/aTREFQN2kZEjKyViGyUfhmoWkU2++mtcSkatUdbhPkAx6CkCbYqripVq+sdw5hvXTgroL97lw9rlCWpdFhmhLPPsfEY4dKTKIIeEzD886f+nGgHAabgx+GGOk5t96wmZaegRQJrp8t5Qoxqcokbr8oB24DE52Y6CXCLe8Ndk7iduGXLBQUCs5p10lEMCUyASFrdmu2ILQpXpPiX+WdzjuZWlZnRCtmmssACpAz3/vOZN+tVYmBpucejDuE0wqQWGqExJUiFp4SP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 8:34=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Wed, Feb 25, 2026 at 8:19=E2=80=AFPM Barry Song <21cnbao@gmail.com> wr=
ote:
> >
> > On Fri, Feb 20, 2026 at 7:42=E2=80=AFAM Kairui Song via B4 Relay
> > <devnull+kasong.tencent.com@kernel.org> wrote:
> > >
> > > From: Kairui Song <kasong@tencent.com>
> > >
> > > By reserving one bit for the counting part, we can easily merge the
> > > zeromap into the swap table.
> >
> >
> > Hi Kairui,
> >
> > I know you're saving space by removing the zeromap memory,
> > but do you think a bitmap can sometimes be faster
> > than iterating over multiple data points to set or get bits?
> > Or is the performance difference too small to notice?
> >
> > Thanks
> > Barry
> >
>
> Hi Barry,
>
> It might be even faster this way. Swap table / swap cache is the same
> core data and must be touched upon swapout / swapin, if the bit is
> also in the swap table, then it could save a cache miss.
> Also slightly reduce memory pressure.
>
> For swapin, __swap_cache_check_batch now checks the bit with things
> like memcg info in the same place, and everyinfo is in the swap table.
> Currently it uses two loops in this RFC version but can be merged into
> one loop. Even with two loops it should be more cache friendly.
>
> And "clear_bit(offset + i, si->zeromap)" is just gone, because
> setting the NULL entry also clears the bit.
>
> Page io accesses the bit in the swap table separately, but the timing
> is close to swap table update so probably it's also beneficial to the
> cache.
>
> So I think it might be even faster, or at least the performance
> difference is too trivial to notice, I did some tests, and didn't
> observe any difference.

I did notice that some cache data has been consolidated from two
places=E2=80=94the swap table and the zeromap=E2=80=94into a single locatio=
n.
However, swap_zeromap_batch() previously operated on a bitmap,
whereas it now accesses multiple data. Is that also
expected to be fine?

Thanks
Barry

