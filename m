Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AFF2C9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 12:56:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9910C6B0088; Wed, 23 Sep 2026 08:56:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 969566B008A; Wed, 23 Sep 2026 08:56:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 858236B008C; Wed, 23 Sep 2026 08:56:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5E54E6B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:56:40 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 73FE01607F6
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 12:56:39 +0000 (UTC)
X-FDA: 85245026118.27.19A8DB3
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf29.hostedemail.com (Postfix) with ESMTP id E999A120002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 12:56:36 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=QM48kRVX;
	dmarc=pass (policy=reject) header.from=meta.com;
	spf=pass (imf29.hostedemail.com: domain of "prvs=77262bac03=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=77262bac03=alexghiti@meta.com";
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790168197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w6aYP/WGma+CZxHbYVrCOq+IGJ59B5MNaNiRltaBsIY=;
	b=bNU18qZGiXctGRT6gWAPVxfc2Efa5dwpt8f4zbAiLRais5MLYuPZR+uTUCSNtwj9nvCD1R
	Bvp+VzVL2HIAW5ZV0fYvudz2D0L+biE5QH0pZdb0D9Zc0xv7r4JQBvt6d3QBtRvTFTsy7s
	qv3WP+OOdHHQWScQYvc6md51MG2q/3E=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=QM48kRVX;
	dmarc=pass (policy=reject) header.from=meta.com;
	spf=pass (imf29.hostedemail.com: domain of "prvs=77262bac03=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=77262bac03=alexghiti@meta.com";
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1790168197;
	b=vmJqNwh9m2VSyFSIndwQVhbPGWY7iGB7Wy4jB4tRCk3uXUv4bTBK5Eu2h73lv0DNjLGH2T
	zUJanapFA+tWqQovVF8FdYrFsD6NdFmpFsSvUpffSTIepw3P8Z4SqFPHPuEmj5jAMpySzP
	zQ9/rbR0OUmmwcUWePJF6z+TN9uOIpg=
Received: from pps.filterd (m0528008.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68N8J6CO1145569
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 05:56:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=w6aYP/WGma+CZxHbYVrCOq+IGJ59B5MNaNiRl
	taBsIY=; b=QM48kRVXKpecMA2HKZlUHYTYeblPj2PwDiXNYgaELcY+4blPJCHkl
	WnOq74Qma6mHBWyL7kNLfzD5f724Bn70LINbKvPtz+tosR5For+dsSEdeWOJQz/o
	GxeMcb1gbqjFQ8PoMzoLAteVIo0MU0JUHXxO8NIyAoIsB7jnm45Bl0vXFhMjbV+S
	ptHDR2P3ppPkou99iHDsL/oxrV/hb0QuDiRdlSoPg3G4FYmrDfjzH0NbgHcNon4V
	ShyLuLOEmp7pXksscyUIIMLPnAw0Fz2SUIBxqb+Uj7wzFzCrw1Q1addlXugfLhDY
	OJFT5eTBaWiV1CbYkqR0lWIJzVvI7tmog==
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4gv1a4pann-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 05:56:35 -0700 (PDT)
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-6aab38d12d5so1196738a12.2
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 05:56:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790168194; cv=none;
        d=google.com; s=arc-20260327;
        b=DTEVE6fA0LeNG2zW95dlmyUGZjUVl1XcPLrMKQAv1eDiP3PHTA29HNCiGemrZZgUB1
         9Uhwe1cxXyzekSDklVKzsJPFVCYuVfJSuKBfcl+kQ/JWymknKLD8I11bT6w2nvKoXXKx
         qJKMPDhdo4uInc4BfuwxeQNl4TJKiY8109nDiGoIzrIsDc/9IvMssA+M8OPFxvSCscCL
         csJWLB3Bg5qwzex6F6fbeV7i5z3QeR7+nme7BQyGCRvmqDaGZQnE+++DKRNAEgPD/3uF
         8L4bLCsHVsrRBfaTHFov7bFhUSjTgIJg/gMWEJ17sPG+UiqGeYvkSNwrg43fEBKTtLqZ
         yhrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=bqEiNZo3w6DxJ+jQKjV3KdDyTNPbxkoMRHGCPwXcb/s=;
        fh=OUGrylLeRkVwbhFrdeYl8e9gQykWUMgCqOSqxfwr9MA=;
        b=fS4i7nc8s7ucw61ZrrxUX2dP8LVUf32opolQ25SO9JWerN080AXmvVLtkx/n8VGaXh
         asOaFwiAsi+tNzjQNe/8qhK6K7y7QJ5Uq/RXlnVBNvEbfWl4BLo6c3HA9UNjU0P9sSOA
         Vm8s9JAmVb/LFTGQH/aqJ7goHXHsENuVJ/26P/ho2hxGwOjRRfFVscz8/huccYG8Qr/9
         fCinoya4quQRDRG+mfWrmANoU5qz7pOgFSqAuCxZupTwcrZvE4fx63obxlvd314i0Q2u
         0aFQmwudJ9snP5tdZ0rqGrICDlhrBob0Ky6dT8f6y1aPRUDVVFjSYoA7zOJy1hH4ZTX6
         fIfg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790168194; x=1790772994;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bqEiNZo3w6DxJ+jQKjV3KdDyTNPbxkoMRHGCPwXcb/s=;
        b=mc0BQW/lKDIBdn7EvVDa+tsR3nT8eRUFA0U0IuhXegHaUoC2w69EcNkd2KB39CC/uv
         lHwc30kRYDOGO+N5gtgksp69a+B7AClq52E+/gIfaRoXFO5NVxBJTnbOGqqeQGF1fJyu
         uMumc44/ONAUlNEPLlsi1jqPndlJHSMykHEWhgMKqCkuqdtqkpL7JM/t+51rbgDPKxdl
         piE1p+NwnJEWvbX10dLIPv80Ezi1GpQ2CgKuwPk+/BjGFsRuqIr69GDAZrN2Q0gfub3+
         AQej7oDkww0dr5A22XoZw8lMCj0fVE6WvhDqrfF7p2QjAzThDrcarPQ9DKivshnuG2ao
         pPqw==
X-Forwarded-Encrypted: i=1; AKwUvBy6zZhcmJ8luaZw11180mIZTr3Mz+64EwrK3kgMDhI7eJMIOoOk5F7ppXKZmQBGcedpXDTcndBV8Q==@kvack.org
X-Gm-Message-State: AFuF++lGpzo2dbpm/5FO5e+9nf5+qm2Kq6fucrg62GSwKEbCInJSpOdN
	JuknlEg23j8tXz/eIFgHmGYcdgY/N+u8r9YT4GH3KqhCOmYW4gLYU6BwsDBkptjA/sBuCpCPLSF
	5iElLnxEqA3ianpGWjv9Mzp+E6h3NTEzgh5Ru+VNjWgfRV3Ws74LfFjQXYSsBzxuAxxC5NG5F9n
	uyRIbau3AE/yS10OWd4DRZmqAMyg==
X-Gm-Gg: AYBFou20tWJ7cXjjrSxo0+uMdWvKQ790ZsQAHIbPSzwFSZNsvHYPVfLn60NN7UT28tw
	mphnk7P6z2p9PiJiNy1Y38HnH9ycPCX437K0Ayf5iKyrqy66Q+zSkDlM3y6Bju7byaRFNPIEfYF
	7p4f1cK48+oSgMti7KnfFOPY7vnxZ2h30r2yF2kmSKW0ExyU/2CBDtfr+cFnFA/Awlg9dO6hqgr
	BsTJ8lyEapEVe1OMg==
X-Received: by 2002:a05:6402:3549:b0:6a9:93cf:2367 with SMTP id 4fb4d7f45d1cf-6aab3b82acfmr2389936a12.41.1790168194044;
        Wed, 23 Sep 2026 05:56:34 -0700 (PDT)
X-Received: by 2002:a05:6402:3549:b0:6a9:93cf:2367 with SMTP id
 4fb4d7f45d1cf-6aab3b82acfmr2389903a12.41.1790168193603; Wed, 23 Sep 2026
 05:56:33 -0700 (PDT)
MIME-Version: 1.0
References: <20260722163536.773166-1-alex@ghiti.fr> <20260722165907.784020-1-alex@ghiti.fr>
 <CAKEwX=NJH2nM=vMPk_=ugJ26uNjH4AMdHXeaasuPrbSEGxpJOQ@mail.gmail.com>
In-Reply-To: <CAKEwX=NJH2nM=vMPk_=ugJ26uNjH4AMdHXeaasuPrbSEGxpJOQ@mail.gmail.com>
From: Alexandre Ghiti <alexghiti@meta.com>
Date: Wed, 23 Sep 2026 14:56:22 +0200
X-Gm-Features: AclHuK9iADqo6BDBUkusfSuGCdLOo-LJcD0oUEhsZ8PqoiomeOSbz6M_fQmGJPk
Message-ID: <CAEmasaX8apLztgcRCpGxyDWAs9Vc6hU815o9AG5DZUU_5RpQbA@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] mm: swap: overlap synchronous readahead
 decompression with disk I/O
To: Nhat Pham <nphamcs@gmail.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, akpm@linux-foundation.org,
        hannes@cmpxchg.org, yosry@kernel.org, chengming.zhou@linux.dev,
        david@kernel.org, ljs@kernel.org, liam@infradead.org,
        vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        kasong@tencent.com, ryncsn@gmail.com, chrisl@kernel.org,
        baohua@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIzMDA1MSBTYWx0ZWRfX+ih6VKRrQ6h8
 iwznGoWE+pICABfzE78aaupVb65vLzumPUM91j0JfLJmqYtXNPst1TqA4r+cCtfSOWd5EYxhWsq
 uS39nodzJj1+2bz6JcKCiLcDNfTh99nG9eNoK4Em01DTB0Ex1CaYHQ4BYDOvFHcJVr5VFEvk41G
 GQrZ48CIzMpy5K9bo2xnMN6Cs861K0ne0JcM/FCtNI2VCniKdey+HQvV3qkJdA3N4ArcbwyLulf
 nlbjL1y6E95mKnwdYOIDXfkrSb863OZvwj9heUOyGTKoCNF3MGosiv/3YyyJDnGYWrVmC5dMrV2
 CnadyH9nQNdAymMb/HmvdlY1f6xYhO3IVfbwxkb6O1gPC+dFY191o3sYjHClooANGw9zmkt62GZ
 INoiUhofK/CnOzRv5ndKNzw64682B7k/dqHAiaJbjXd9A0I2NZaE+cLU21q68Ewzc5M2XTsPuYm
 tS1Gdt+sFrf/KE+nghQ==
X-Proofpoint-GUID: lDX0xv1A83yHbC5_AUBc2drdCaDnueDb
X-Proofpoint-ORIG-GUID: lDX0xv1A83yHbC5_AUBc2drdCaDnueDb
X-Authority-Analysis: v=2.4 cv=Pa9qFShd c=1 sm=1 tr=0 ts=6ab3cc83 cx=c_pps
 a=CYpx6mtW7qE8U/l5VCnCPQ==:117 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=_1IyUuN4QrATX339ibzo:22
 a=pGLkceISAAAA:8 a=6U9HwWF0I8vdP4q4yZsA:9 a=QEXdDO2ut3YA:10
 a=22KAYETGZJnyhCxlFjxL:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIzMDA1MSBTYWx0ZWRfXx/fgaYhxIEte
 RZGKRlt0wZbjBREnq5hzT6tnUzcGxzy+KM4XofEZ97xISA7mYzjwdrO0YMz4IVfMhkE0UPQ7b7S
 FUyiX7oqp6b++LgPXG7MzHUTBuvbZ18=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-23_04,2026-09-21_02,2025-10-01_01
X-Rspamd-Queue-Id: E999A120002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 58nszgpifgisjxqb9gdqiduufry5fgn3
X-HE-Tag: 1790168196-447676
X-HE-Meta: U2FsdGVkX1+CCuYXPpvoC2GQFsGGlDLr7iS4etYh52Br/+mreodEKEOLuBeU3JJ6+t87v3Hw3x0g6HxpFOS/dgbdLLPEs/39htJ0ScCfDh1VJV7gdS7PeKLnoxr1KLBHNCn+43cqOa5Iurk0zbtgKj8wAu4VSOxWA+XQv/+G0Ec+IIHCoF52FcPDwxsjG/UxYOT3C4H/Mw6b+pzJXym5jVe25nBWpN94PEZ/8ajgMNQdO29fw4g7IRR7JqQTuTh1uNpWUAHCyXTPtgkZyLw8NZT1qzl+AUoSs2XhAnjm4YyPKzYrku/0J3motwluSBxfT2yOeYbHqUcld4inJ5IoUABUoW0bCGoCErqpsPR8eCkSBl4DTWM3cAtTYT4jZgxW+O7L7aI5QwfdMTeRBdG6818QU5xGYToQkK2Wx6vKpDXc+Tz+biWRxyemp83njWE1fkPlbeuEnh/UXlomUlPsE0kiIW07j8K616j/zpKtCZoSb/J/ygOBNnShGq5ZWLmhhtPgjAIyNmd13xf9plFI+KmHY2W09yLe3HQtfY6nEqdSOKuCzWaX29cottAjVfAKwe9nXy8ATCFK+AP9CWNUkfyacWNggnGRXShzJ9oyJvP77clnV3rulF07JZ9QbivM+hNHcSi1VhwN/gQQFpXp1xgfk3RlCCgWuqWMo93JrYHozIuA5QJcIpIAWu7P1mXS98UmXOTyrdKfa5eaKDyNY90BKJlmLvZXzLss7SHjJ3/+ZyD+DB7nharblfd9x56mxwLRsjUSqSQN5n5o0UvZ2WJiGLYt8Q50YAbFBGx9AWf6CJLkN9hCMuSUttj5yp/ajJSHTqwDHhaj9ZuZXpIcWB5zxekwAChrvKK92Ys1Orksu8cxzxi9ZDxGTpFY4VRSSjtg0bs8RiwzuKM81Wjd2k5vw96MsAq5C6TpfhNWg94mnNJjSAvYPbUIiIOCvdx0SWNmuETDj5nRIhjIODD
 NqV/Piv4
 MWRtvzNQOU9bMvQ+WoejGmRvc5P5pzetgiLPzaS3a95VUNBWs6bEZD1nD/Omet/jV4V/qZyTdK2N7/IH+YiPiRNw/wUGHLma+mIqSQDTmxIGF0+cqA9laFucChUcgILOlGTT9PPfARfkqWoggigtNdPl+Wx3EVIdpmxGQe5EKvQ7GX9EhwpM8bETb1PMEnWacZSvDikZUNvLxORW/4ZLlepJj/zg08A0iol65PKGqWQaLNIrANa0HyfB2IgU+ox0q4bnk3F1qq0waV4rNSF2XOGEMXUjfXPV/JThCPWEgLPU9v1QZIOb6AliVVSAeCvFyuKEY0InCMo4Y+t5/36q4tsuwEZGMY1b8ytZf8XjmJ2jYGzTEiRHcKkgOCQPcRBdZ6x+X15OzTAKcqr3B0daaxIy6J/tjEElrQmjKQKyUeJWDuBWGJVzia+klsBQUIOhmZtgsVlX9wjIdqOHGnZ1ETeQyp4ab4blYg5gV32WTZ4qja3wOMIiCE+pKEBBWct7NoTNM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Nhat,

On Tue, Sep 22, 2026 at 7:07=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote:
>
> >
> On Wed, Jul 22, 2026 at 9:59=E2=80=AFAM Alexandre Ghiti <alex@ghiti.fr> w=
rote:
> >
> > Swap readahead reads the whole window sequentially: the device I/Os are
> > accumulated along the way while the synchronous, zswap-resident entries
> > are decompressed inline. The I/O is only triggered afterwards, at
> > blk_finish_plug(), so the synchronous zswap decompression is pure added
> > latency in front of the read the fault is about to wait on.
> >
> > Trigger the I/O before decompressing the synchronous entries: split the
> > window walk into two passes. Pass 1 issues the async device reads and
> > defers the synchronous neighbours; pass 2 reads the deferred entries
> > while pass 1's I/O is in flight, overlapping the CPU work with the disk
> > reads instead of serialising it in front of them.
> >
> > swap_cluster_readahead() walks a contiguous offset range, which is chea=
p.
> > swap_vma_readahead() instead walks the page tables so we cache the
> > entries we encounter in the first pass to reuse directly in the second
> > pass.
>
> Hmmm does not seem like you're taking advantage of the device-level
> contiguity of swap_cluster_readahead() either way? You're calling
> swap_entry_synchronous() (i.e zswap_is_present(entry, 1)) one entry
> (i.e one tree walk) at a time.
>
> If you're not taking advantage of contiguity, just share the logic haha.

I cannot stash the zswap entries in an array for the cluster readahead
path since the window is not capped like it is for the vma readahead.

So I'll use the contiguity to avoid the zswap tree lookup on each entry, th=
anks.

>
> >
> > Results [vm-scalability mixed zswap+disk swap-in, 256M zswap cap (~73%
> > disk), Sapphire Rapids, zswap=3Dzstd, shrinker off, n=3D3]:
>
> Hmm how do you have disk swapin with shrinker off?

The test workload I used filled the zswap pool so new folios were
written to disk.

>
> >
> >   metric                  mm-new    +patch    delta
> >   swap-in tput (KB/s)    119247    131261    +10.1%
> >   swap-in wall (s)          106       100     -5.7%
> >   swap readahead (pages)   1.56M      1.55M    ~same
> >   zswap-in (MB)            1895       1872     ~same
> >   disk swap-in (MB)        5207       5190     ~same
> >   major faults            260148     260212    ~same
>
> Obviously this would help zswap, but what if the backend is disk swap,
> and all of this is just pure overhead? How would the numbers look?

You're right, I assumed the overhead would be negligible but I haven't
measured it, I'll come back with numbers (I'll test with the
contiguity optimization you mentioned; the overhead should be even
less visible).

Thanks for your review Nhat!

Alex

>
> >
> > Signed-off-by: Alexandre Ghiti <alex@ghiti.fr
>

