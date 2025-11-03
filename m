Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7704CCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 09:10:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEC3C8E004B; Mon,  3 Nov 2025 04:10:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC3E08E002A; Mon,  3 Nov 2025 04:10:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDA2B8E004B; Mon,  3 Nov 2025 04:10:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BCAF98E002A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 04:10:40 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 96B24160A95
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 09:10:40 +0000 (UTC)
X-FDA: 84068725440.18.1EDF37D
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf29.hostedemail.com (Postfix) with ESMTP id B802B120006
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 09:10:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bu+Rpas+;
	spf=pass (imf29.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762161038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QUiZDJyRgD/8ISelZGs9/tsma9n2NV13edtbnKVKZEE=;
	b=iQUdTxH0/DWTbKu4KUEf20jU849+baNK7cIjV6dY8DJOMoKG7/15TfBPnkht39cMlF8HQT
	rDRGfkfubjN4+Raz3Fa6cFotPZSBYynJb9K8DRYmb12llkT69DnV/89vqxrBAVT2gzYWrw
	7rszGF24iU8hdp51a8VxWwWntWmkFIA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bu+Rpas+;
	spf=pass (imf29.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762161038; a=rsa-sha256;
	cv=none;
	b=4CIpdtaqPqDeb+RVOumTR/WFi1fUnYJCHCtjRZLz1dBe4f3UNqm+hIXcItvvTYDLeoN8yS
	2o4r8rZ7wYhG7ZZN4EJy3knj9XnRgaumHu9DZH7acxSY1tbENFhh1lzX+yBnA2PQSVmgC+
	RYKuQXnQmaITK2po58oF/EhPINrACt0=
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-88f8f346c2cso425697085a.0
        for <linux-mm@kvack.org>; Mon, 03 Nov 2025 01:10:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762161038; x=1762765838; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QUiZDJyRgD/8ISelZGs9/tsma9n2NV13edtbnKVKZEE=;
        b=bu+Rpas+hXiQwbhxIe3tfMI8wWBOad/e/CkPqmRYYovw5CT0RcPwXqCoBnAmCQQAXb
         ToF5QQliBx/ilJrn9QP6wXMArDT6rG6Z8fWClsVHCTdPfOtMhOJ/seA9/LWKOG7Ntp0t
         PKaQ0TL91VgRrsVVkx/r/0SpDMexpnFEZjrSWc7YAV5XyPBrliO/MUStG7AGPb2vd1Ma
         +iV/Rs9RBZoiWjjeXWC1FrtyTQeszM/m9+sJRCeyROWAc6nTMOl74lAHeEppIJdibCF1
         Pk2/XecMU5GR0ZmlcxLrwYCQRCy0Pa1SA4cH5JbfRBarDamva3JBbOXsc+FSOnHWYK0r
         DqrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762161038; x=1762765838;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QUiZDJyRgD/8ISelZGs9/tsma9n2NV13edtbnKVKZEE=;
        b=KBjixiAxrMq0B18yOChs0cPLq5gpOalY5xjewHudlbvdejC0FR25G6xQtlToMihkgj
         OzpaIBAXb3xEQbiEmW9usEaICuDb4ghdB10O//UxOSbwAt1SAhwEJZnXX9dU4DDElMSd
         Vg4pfw8CErdHRjRyt/VM2+tcPPkNjaJ3i9qpGXd338rs2LNP3TozL5n8eqTDZ+OjKdMN
         pi01nyWpYAKTN7Y5lkKT5l/uihRqiENTiddN+hSb12Ni6lLSX+2uKxBxz4Rho0rZgn3k
         m61HofH6suJ4/OpfmpWzfVqYVTl9D083S/8KqaVer0DFH57HvEbFSG/mDRRt8ua3wp1k
         U9xg==
X-Forwarded-Encrypted: i=1; AJvYcCXpBQ6k0T75fH2bGTucsaQlhRALJh40QJcwQoDT/oC44eypOXw7vilXw31FWUbkBtKpY6xXklsuXg==@kvack.org
X-Gm-Message-State: AOJu0YwWHCJdcqDyX/3DWWb8ft4zryotMZzkkTmuTC59uR7oZlK/94En
	9+Pax9lGMTdk82sA0fwc/LapyIjP/O5Mgp+dsNEeE5RmkohhDeos7t8+fBmjwrLBWrMvdXIB3Vb
	l0cBRCYEg/Gqhvit1AZagsiIMQQDFvLU=
X-Gm-Gg: ASbGnctB1DR/3Axv+UpASExbzG4ZZsTbQ8YeO9krG0Slud1UvYG9evIVHK3FLudS+/0
	NX1nvCjSHw73l7Wc4GdNkm8RaCnRzHOds7kIGPBt4ZXg7h/UGGt93Ad5+1OfSiatcV2muQ5fazh
	ZRxmOhEfaw+1kiWzEQqd8Jj89icGNZTUkwhVFjQrw8/o6QKPFLWRrCNO6MMtcdgtE//CtnJAfQp
	ZjoCoMY69kDAUTPouj3Z5slwEmyR+uokY4R0dvW45AVyJcbr1jGRtcT8+dpTvv+Uq4lw/X2tDUb
	Zs/jz9WuwUEHsFLRNvrnoTc8ufI=
X-Google-Smtp-Source: AGHT+IExkPs8nlbN6h2EtytDA/E26wg/SoLzvVARgJNEMejaCO7Oe83L2OTAOQHjef9AwC5pLrkqUQzXxOhklPtd2tQ=
X-Received: by 2002:a05:620a:4087:b0:8a9:eb9d:512b with SMTP id
 af79cd13be357-8ab988eda3fmr1352526985a.6.1762161037654; Mon, 03 Nov 2025
 01:10:37 -0800 (PST)
MIME-Version: 1.0
References: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com>
 <20251029-swap-table-p2-v1-1-3d43f3b6ec32@tencent.com> <ufy26fqfvaxqjywneec3hcuky7ozpa2fm63pxcuuberrvicffv@bkblomeix35w>
 <CAGsJ_4x1P0ypm70De7qDcDxqvY93GEPW6X2sBS_xfSUem5_S2w@mail.gmail.com> <CAMgjq7A+OBoH71qo=Vt65BeV7M9uOvkJ+9pQX2eq4-tqcKwVwg@mail.gmail.com>
In-Reply-To: <CAMgjq7A+OBoH71qo=Vt65BeV7M9uOvkJ+9pQX2eq4-tqcKwVwg@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 3 Nov 2025 17:10:26 +0800
X-Gm-Features: AWmQ_bkqWGIOm_V1HEduqJo4E0AkHgk0dtjri9662bFQ_YbNVTPpmfTPLZFhKNE
Message-ID: <CAGsJ_4zryZ-FqxZDo8k6VLx4-ijPdjk4i+txVzP41ZS_koNBgQ@mail.gmail.com>
Subject: Re: [PATCH 01/19] mm/swap: rename __read_swap_cache_async to swap_cache_alloc_folio
To: Kairui Song <ryncsn@gmail.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Youngjun Park <youngjun.park@lge.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B802B120006
X-Stat-Signature: fz65bnrjxdy7resboybj4md4kykzh3h3
X-Rspam-User: 
X-HE-Tag: 1762161038-83727
X-HE-Meta: U2FsdGVkX1/qa9DzVNUZxmJaOSXrnwVKvIyQsyO6VQzFUcdkkNUfY3wrinj0Ds9WPFVeRo5K8MQgbcLOPl1ls4y3ue8WYulqUhWzq7G7F95fy5HI1DTJ0chCX8dUEAO+fwD0G4NooIvHJZo3mqeyH23AO8g3gHHLYH39X5SJoWChr4UDIvymve0ysgoLRzbmT5DHvZwUKavQfyLGWGIt0rxtocHFpsevTOBOEnzTbMRGUKXRBAEcZG25fDLMa6oj7I8bqFq6/GfmvDe5mL5eqGZOkIZ3KxK9QEKYI7jzsK/KBYiCMSreKxyMsSHCOSZpH0rePcrqtP8xA3WppbeMR+nShf+PhCsk5GLkzDBVGjDtgX0RkvDyKC5hX/gkX7nVqzkXchvtbjg1KlK22y0BfafcS+Apsdi4HHeqRWm06AccT2dWk1/QgiPLxpFeKGc85t75TJcCWaUCH2iEpgP13RD6AkeTLTII6AgKbSTSfbCJYf9OI0gNOu6Ym/nMPwEuHaPVyIXuIuoGEzuee2KH6eGBy7+gA5E2BmB2QXEedj1USK6DYW18KHZearrcv6Gwtjcv48oOnBxHZjrzusUiEbn2bmG2BgefRPQwcgGysnD9GEhYCkWOSFD9s5gFGY1FiCWkshF0eVleSUtatkyATEEXpuDxowzr5shwEjjaUjZ/RWqCmiUeDlk0tu7JakSbUppPTQiGcn6xWPFfXAsg8PuRWY9uc1o92IvP+wZs78kZ2TfFHP32EEqueHe96gqgYIgpSY0nFYZB1rvMtX5fGNfxp7frstTLBmDZbX17WhNonG4QuNXn4WoJAug1HN45GXr4/DTXqqljtyHR5AGQLqI7h/AL82WoCq2MKQnNtsfZ0X9ffm0/gcfxj3Te2zF7KTcyXCaWap2hynBoDKBQ33c/NyVkbdzGPR+VD51sU/reT08rEfz4DjXopCX+j4rFelwf96qAKZwyl9RU3Ku
 CoCxkpFY
 C90kiE7+ui87Kfe8A1SxjQGqBeoU/EufKo93izWJ0eGDIRqNTKri38Wn848lf7oXtUbQ4+WIog86Y9wam1+surhcBHz3dISYKmYWbLBuaP7Wz/U83a4a4vF4Skma006baucZv3qxeZU2FdOosSr6UWC2RsGAl93LDt47sDMCHJGehCm/4KnmrO56vDG9R+8SDIkfA1dYyi6YFOmNjUHlurhtSYaV7XqgX3eF17D3LiFMRrR4CzGj10rYBLOeysNfHPaVROjtLb9LUJdfbkkAbToOb83vtBTs5uRCTtBc4dQplqV7iibEhRgkhmTl217PlrCA8uRGVYftGOMh4xvr9gPgWO9LqG7OKjheGW8Q60XjefTufNMmvJ0mzXjHl1jW+arIQNCv9SqpUauxJkxlqliepGg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > I assume you mean avoiding any mention of swap-out? As for swap-out, we=
=E2=80=99re
> > swapping a folio out from the LRU =E2=80=94 we=E2=80=99re not allocatin=
g a new folio.
> >
> > BTW, this sentence also feels a bit odd to me. I=E2=80=99d prefer remov=
ing
> > =E2=80=9Cswap out=E2=80=9D from
> > =E2=80=9Cdoing IO (swap in or swap out)=E2=80=9D.
>
> How about "doing IO (e.g. swap in or zswap writeback)"? Swap-in is a
> very common user, and zswap writeback can be mentioned explicitly.

Yes, that seems much better. Though Yosry seems to view zswap_writeback as =
a
swap-in from zswap followed by a swap-out to the device, I kind of
agree with him :-)

Mentioning the special case separately seems to be the clearest approach.

Thanks
Barry

