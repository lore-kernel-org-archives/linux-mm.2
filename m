Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 454D9606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 19:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I4WUwhUp
Received: by kanga.kvack.org (Postfix)
	id 61F6B6B05B0; Tue, 17 Nov 2026 14:36:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F6C96B05B7; Tue, 17 Nov 2026 14:36:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5379F6B05B8; Tue, 17 Nov 2026 14:36:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2EBC46B05B0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 14:36:29 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A367FC0585
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 19:36:28 +0000 (UTC)
X-FDA: 85445617656.07.5AC5D60
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id E79AC1C0006
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 19:36:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I4WUwhUp;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794944187;
	b=Wf4Hb83tGrYOezaPrOUGeQoh3EuGyuz26XRxlq/p7GBmXqpbfgLqRbVDTCAtTsWhkishFQ
	rU5059xISMw5zi0yQDdestf1QWj2g39KK6E6lUHeEor1A3V+SXvmyOtKeUnQV/2llu9xkN
	G2uaI4PmDDF/Y21hEvixvNerhnmqneQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I4WUwhUp;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794944187;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zDlghWPDg7BOyFpcLj89lQ1FLk7VaOumG/HX+lKRh1s=;
	b=pUN2MXhYsu4T1tfhq9D32gUFvT7GIwgGnYefJuX66jA1zd5IrLgZYNPV9Caq0G3raLCF/G
	zKbBq8a4V7VlLDkHrnnAgi42EBm7zEigVbPSHYBIro/ADN97Of/0g+SWvUMCVZzxn3+VXE
	prChBuGcIh7gsMTcH6tfXDy3wIm7vCs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BD7E040757;
	Tue, 17 Nov 2026 19:36:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 624F01F000C4;
	Tue, 17 Nov 2026 19:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794944185;
	bh=zDlghWPDg7BOyFpcLj89lQ1FLk7VaOumG/HX+lKRh1s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=I4WUwhUpoTFNuxmBKAEij9cYe4UEYHJkaJshQr9N9JPVbjmSFxTGZKCsQxwdkaQiW
	 ESa0m7Zqw6QUzWuMo+J4PlcMNoXWD+8Zg5fSPf3RvCUa6xH3t5MGXAJfqo59TWDxeW
	 Rc0SxjZ+sS8Eya26hS6oXv0oPBF/Y4LnRQpJ++C97WU5cjL7F4dWVWsu/gOCkNRqI7
	 +E6npgkkklK2NgnBO5c8WngLSeZxfrWAkPouVq8W1kZwrzYRMKLyzj7iSe44MK/obg
	 cbrMsi1m+jcqSn5wDDsqnpZ6bN/IBBhZdMYr8/6A17n3NOY0cizc1A8WG2qZXOIKwM
	 vFfCMQQ2GqdLg==
Message-ID: <sashiko-outbox-219498@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/7] mm/page_ext: fix client data alignment
Reply-To: sashiko-reviews@lists.linux.dev
To: "Muchun Song" <songmuchun@bytedance.com>, "Alexander Potapenko" <glider@google.com>, "Andrew
 Morton" <akpm@linux-foundation.org>
Cc: "Marco Elver" <elver@google.com>, "Dmitry Vyukov" <dvyukov@google.com>, "Chris
 Down" <chris@chrisdown.name>, "David Hildenbrand" <david@kernel.org>, "Liam
 R . Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Brendan
 Jackman" <brendan.jackman@linux.dev>, "Zi Yan" <ziy@nvidia.com>, "Muchun
 Song" <muchun.song@linux.dev>, "Joerg Roedel" <joerg.roedel@amd.com>, "Lu
 Baolu" <baolu.lu@linux.intel.com>, "Pranjal Shrivastava" <praan@google.com>, Ketan <ketan.kishore@oss.qualcomm.com>, "Mostafa
 Saleh" <smostafa@google.com>, "Sang-Heon Jeon" <ekffu200098@gmail.com>, "Jonathan
 Corbet" <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, kasan-dev@googlegroups.com, linux-mm@kvack.org
In-Reply-To: <20261117120627.50601-3-songmuchun@bytedance.com>
References: <20261117120627.50601-1-songmuchun@bytedance.com>
 <20261117120627.50601-3-songmuchun@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 19:36:23 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E79AC1C0006
X-Stat-Signature: h6s74hgznr1k9hwmoo4f5m3gew4i68gu
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794944186-225866
X-HE-Meta: U2FsdGVkX1+okUoAonjS82MpXIl95JT0AYsG8TXhunLjHloQqcKJ5tEg6A6FawoJ/eZnLCBqsK7sd3fujO5mCxUX2TYtiZD7lQMalLUEGu7IslAFKADFmfH604Iyr1GlfHoKZ2XWu7BAey2YSp85k5ySzM/03b8AmVDLJg1F3giNl4sZNr0wepnDjCm857mt3M9JKzDY9V5Rb+nbLezEey3pxU5FHhG9nRgmqJ5XN8B8HINFxcg2aCejgv8RfErd5HAy0V8mbJ9bmWY/f50c6RrCL339EOaFJGNqjiBFoM0DKbuSZMH/1hym0MwwuDSJNKoXS+VX5rrnos7v9uyygfTVwv+reT0rEI+Z8apaj2GzzWK9Q/RwqhDUYCWeejC74URx5nMjukwfsK3MZWIMbY6nPXRSLPTLdb5KSaq8kHyoQykRyHgeV8mKOcVBNX+pXB2ZjYmvOTqtCizeWvwk4XcstOr5uVZ/VEjvuLiVrxIZFE9t/r12+q8F8dcOAbHX4DOapfuBOGjdLB+LxvjQ+o0hkAp3eXn9h32ApQcoOyFzN1hHkenhQgMUVrvf2BJ8gwmHLDokIbrQSmRUF3RG8Xi6J08Uz3fuHbrvCHVN3K/3n9nKyhRnpgB2KSeAQ4j919RaS6fZzqxOw4vmme31eCZSjRimMsf3QVxxAOsGQfQ4i29zGcSstL+UQFy1tjVM4t8MMq8WgGUvNyYGfAhvo9SM/y05FVoI1jY+67pin2PFhpo1Km8PCFmlPDAo8hR42/maBja+F/2QALH6+IelecXjoJtc/JXm5R+C/y/ZU8qoQMznMvFm6RNLG0O2FQVHDuClQKekMk38OsLwvgqPnEULB4/Yn5/xFkuHn1gVbqLA7LK9nvMrXQHRA1koL1sqvYFJHuhq2yGhmefR+mdzYqB+Qb4CHIVjMmVPMetQdY3EqHY1Vluf09E0SPQAFpgstk3vWKgMOK1ioPSA8CU
 nq6rzUt7
 JRKWYRIm+tceg2tGelRSyzdfZyUiMW2Ga87kIijyp4Jrioyv+fS7xRKjusKaoI8ppapHxq1uz9A0gACepOHRsY/qi5C+Za57SXwNG9/IZ3LC0akqZvjFx3ZEwrX5SMazNAaX8/Qq1D1+RagyULpLZWiNsgl5FnBkx1XtTe7cS7zRpbtCyOFDNXso10JsvbpuovbQ7v02acD3tXsL+adF2NeSyE0K6dR01fWdIxIub5kTXWTOsKJiLbtwX2PXWSn3f6/PbfThgsTChnUhTRydnRT5YG1UB2B0OW046++9wTuvYCcbxxu0o2Ai3n5sPYzB2gC36WYLzJ67LAZt6c2seYwVyJyEynVyOFH6+zqysVYk7QNir4eUSJUy0oUoZTP4VJz6AX627ramyIHtJdDND7BQkOKlHx2gLsZ0+JWlpryPg/Q+YkFnjFJx+MDi0SCYJJv2QhNgMPnUBJibdCqc5DxL9wxhGqqcH1NVMIHqYBCDiwm72mZnvRBNl0mrQSx1Ouf8Qvu+N1tYr11qIBxxGj+HtATtRVt9OuEN5EKZVHMYd2/iL8lVfwIREP60B4QwTOUzCqNDTYNBCg/XeCzS/o23JWuGf1JEsvf9FEQs0azWRJRX5IYOP8DwwMduIic6ov3Cu3KP59HWxpN0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] mm/page_ext: 4-byte alignment cap in
  page_ext_data_alignment() on 32-bit
--

commit 4ecca9da35d7e4448f4270965043775293174eda
Author: Muchun Song <muchun.song@linux.dev>

mm/page_ext: fix client data alignment

This commit aligns page_ext client offsets and rounds the final entry size =
to
the largest active client alignment.

> diff --git a/mm/page_ext.c b/mm/page_ext.c
> index b679a8c1f7d7e..dbc1bfa258f15 100644
> --- a/mm/page_ext.c
> +++ b/mm/page_ext.c
> @@ -116,8 +116,22 @@ static int __init setup_early_page_ext(char *str)
>  }
>  early_param("early_page_ext", setup_early_page_ext);
> =20
> +static inline size_t page_ext_data_alignment(size_t size)
> +{
> +	if (!size)
> +		return 1;
> +
> +	/*
> +	 * A type's size is a multiple of its natural alignment. The lowest
> +	 * set bit of the size is therefore at least that alignment. Cap it
> +	 * at unsigned long alignment to avoid excessive per-page padding.
> +	 */
> +	return min_t(size_t, 1UL << __ffs(size), __alignof__(unsigned long));
> +}

[Severity: Medium]
Can capping the alignment at __alignof__(unsigned long) leave struct
page_owner misaligned on 32-bit architectures?

struct page_owner contains u64 ts_nsec and u64 free_ts_nsec, which require
8-byte alignment on 32-bit architectures such as ARM EABI, MIPS32, and
PowerPC32 where __alignof__(u64) is 8 but __alignof__(unsigned long) is 4.
With page_owner=3Don, sizeof(struct page_ext) is 4, so invoke_need_callback=
s()
places page_owner_ops.offset at 4 and sets page_ext_size to 68, causing
misaligned 64-bit accesses on ts_nsec and free_ts_nsec.

Capping at __alignof__(u64) instead of __alignof__(unsigned long) would keep
the 8-byte cap while preserving u64 alignment on 32-bit systems.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117120627.5060=
1-1-songmuchun@bytedance.com?part=3D2

