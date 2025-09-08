Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7712ECAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 15:02:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D42288E000C; Mon,  8 Sep 2025 11:02:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF22A8E0003; Mon,  8 Sep 2025 11:02:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE1238E000C; Mon,  8 Sep 2025 11:02:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AA88F8E0003
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:02:34 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 635A356772
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:02:34 +0000 (UTC)
X-FDA: 83866399428.02.4E9235B
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf30.hostedemail.com (Postfix) with ESMTP id 791E280007
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:02:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="B9HCdD/V";
	spf=pass (imf30.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757343752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mlk7CEaDWsusV6a6RSbZw0bpsuLPACNzKa/4RBgoKBU=;
	b=Sts+i3NNS+H+aoIB6sUe+dJYKwMV0lxpxcF4IUY1ihzMio1yC2ZR5+PT81Lo9NmneGpNoy
	XIMWwD1sc9fAXWS8X4n420givMY9caDF4wnBSjgfELMlN3t3ouFhmQNEnciHXKeqGbwvWX
	juQi9OCSaVX9SNp1VWUf3D2gKaRibe4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="B9HCdD/V";
	spf=pass (imf30.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757343752; a=rsa-sha256;
	cv=none;
	b=w96mJUTvL2peEsEZBpgGtBLR8xu+p5MfAIJS1NU4yKZT2M77q/eqiO3ZUVaokwOzJFuB26
	3IGKyiJKUL93PwYzPg6sjYMQNuj0PZGvn6rRD5muf7v53aIAORdxccjTNEkMd/OluOUUJz
	iUUnMq9riIMXN+pIpFFT5pQo0JwoasU=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b0418f6fc27so754735766b.3
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 08:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757343751; x=1757948551; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mlk7CEaDWsusV6a6RSbZw0bpsuLPACNzKa/4RBgoKBU=;
        b=B9HCdD/VmLFKWbOxQCMhRFr8+LW0qnt2HEiUEhRlWoiDzJ5/Cc4R4waEspAGNSIYZr
         uj/4Y+8oSyVjHvsWQDeDTjn0KqpysZQoQbtBlwuJoC5mpP1+J31se9swKea2JxuBY0hp
         gkrJXEwV3dGQoMYk/U96ErqD08FcPNpcckIOBMKnRy47o7H2ncPwB/j9gnjJzDd7r0Ge
         qaFax9NiIKWwmRcZSlWqrx8ErbQ+9U3TJEbPrdnVew3yyc1K8EwOIVAZb4gKs6xMbQrX
         FX7dnLKWhFoBUsV/IGVeNhu2zxlkbQQ5TNBxjUPirG1AyLJsF9m4uZj3OohkIx1v+IYV
         Y41Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757343751; x=1757948551;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mlk7CEaDWsusV6a6RSbZw0bpsuLPACNzKa/4RBgoKBU=;
        b=GstEp77+OAs6BwF6edNWuor8j89gF3gjhL7qOqo1vpcuC77v+ifsli5yF0Y0bxiGcc
         xrSp9vS+gnbohEVVieZvlsj/0thjjADCHD4MqShtyALfsDrLSf7fHEz7vd576os/+Kiv
         Lu44n0wqxtuIfoLTUIwThQaLRIOW3shmD1xbSNoXGKJ5evL6LFN/UyfqQ+qVZsuUprK+
         OD9UCSF/npRp8dF9g1R01UdfoG25FXmnfElc0UXSXj466Vl779o1SODfF3iUDMQqQNFQ
         8tMe4IkwMv+3xSlbdsTfBJ7ItgmM4MO/ZaZ76xOWyUG25JVl6q6NaA81Yrm9kex1PHLH
         S0sw==
X-Gm-Message-State: AOJu0YyMf7a+/I8fpvpHks0JWrzz4fcJJ7kjUUwyN6IVNcAsHNjT5usd
	yNJlQGO0crEPkarlMEMAPzaStMhRWq4xSQrRcAUXsYhHHkGgHTFOs9fGylzBn5tCmdqf9xtpiOu
	X6FttUFLryMm+IHLuIu1jVwMLNIP1viE=
X-Gm-Gg: ASbGncslFuM3FMTx6UNmhN9kyk+WXHY7ZSXaWcqo+04B/4+X/K9OEALCtru9fiqtqgh
	Apb8ZvgK/xF5gJ4GlewrgKK5gUvbst0X4lKwK9FBk7F5Osr1o2Exh5vXgfht4y//gO9CmLaequH
	ZwNN6ZC8Pjll/m4pR8IjVLPr5DDYhROHl9GJ5GNgyNW6qhO2Kqvx0z5SEKvuxDJUAFdOcK0w1le
	WVy7qSyKFNsLCA3Lcc78A==
X-Google-Smtp-Source: AGHT+IE8ci9wgo7APiSNqM5pwo2bPVDRU9k7EhSscWIVD5IILts7UIBnfP3kwFE0j3XRjRl3mJu0nnkQhDjsW8W/fiM=
X-Received: by 2002:a17:907:3e0a:b0:b04:31c6:a434 with SMTP id
 a640c23a62f3a-b04b106b9f9mr734265166b.0.1757343750496; Mon, 08 Sep 2025
 08:02:30 -0700 (PDT)
MIME-Version: 1.0
References: <20250905191357.78298-1-ryncsn@gmail.com> <20250905191357.78298-8-ryncsn@gmail.com>
 <84d3ab47-a960-4709-b127-ffbb8d85ac23@redhat.com>
In-Reply-To: <84d3ab47-a960-4709-b127-ffbb8d85ac23@redhat.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 8 Sep 2025 23:01:53 +0800
X-Gm-Features: AS18NWBLumplG5EeNn7dHFCF9A5JT6QjZ8t-wBwCRBv-0-uNMUOyEV26HlI_I5w
Message-ID: <CAMgjq7DjVu5q2w_GaA075YLAtkS0yMKOyTiuwhmEDZQZjBC4Uw@mail.gmail.com>
Subject: Re: [PATCH v2 07/15] mm, swap: tidy up swap device and cluster info helpers
To: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Barry Song <baohua@kernel.org>, Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosryahmed@google.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 791E280007
X-Stat-Signature: zj4mn8unaa7kqaynaqwu9werj5jcing6
X-HE-Tag: 1757343752-547594
X-HE-Meta: U2FsdGVkX1+i94PjofOFcsMc4aoYOpbavTRlxHUb+Hz7TfFHNkGbonsxZy8nr+wITKn3H4IeVLUUhyYrz21pDLcH6249zN2lPKlIXuo8PAKtfhik4HoGMHxKBEQ3rOEvuRL1SdfcJWhRaIc6rwcc+XFr/MJQ7mRT+RP2hxyFiC9tVPpIoQcuOsNxJOvdkOt1PmgNNq3wpZOuRC7+roSWFtTTkcbJSF/xdUFOVz03+hr7m0dABwpRf8Db3PajM9VXlkwynGioqxbWjOXLt/lP1YcUFnLknXgjYWMHO+1ZQTq1CBM7agQ8hqZUkRSAIKvNu3IpQdYp1nc9xhiMdc0z/DZxfDeGzMviuddTu3sHF3e+oUVZIpb1UOds6pP/r5f8ImGOlBWZJCY8eeZ1kODrIm8dLStBP4CwTTZJg50HpOoocqdMEtn4KRHBO/npOyxN9g8tYPaZvGm/hU0amv0TEvwbVVGWv5sH3lVtF4FxQdrC+au3I/5NMmu9F2w5QXXi2tXt47cZFcA+BY2yKmiDZkxa/KduON6IPZl3YN/+F1evuJmFidw7PPH7dgA6dtXhvkCrY39WznLyO1vTB1UzorbGvfOli0IaoNi7Ea7LZt9W5M4znG6btKX6BHe1xauh2KyU53nkYeEqEQSrV3/HAK0zt9AAY9E5zVwCaVWi9eu75ptQsPlB5VOAZigKA6YH5z1hxNSJpjFzL8iv6Q8CPtvDSM3RyRb5NnxW7yHMb05HEdiJROGVEwoV8UEg559TND5ly5UCA791g7TYtBTnu7DVPozZFrwpantiUZis7y1pJLtrmJzvHHHyZWMPofygO7q3eKoerBBJcbgaBeHmyqOE6lPG7+bYL5RcgDjtVzIlmOLvRIbYL1O+T+TdwgH3brkxiCRzkViqIKy4F0SN674qChseWt6GA8BFgnHUTIgm9hDZDhbimxaGMYH5T//L89SYFrxiuAstT6ukmgM
 IyvoXI/a
 bM8E5JHj2IKoCiVV6VJPoTtXV8RqMslOOLK3vMEGq2mvwwwSc1zdJlLKIYl8Tch59aj/dJiuXsdQiHpSV1J8xLl669TkTRozRgZuGoSI9Qb+d3sMlh6dTxqRH9ovtt4MJ66bqOAjveYJZI3nqb4f6+GoWYbZUigNDjBsUJk7mw/84fEyXZcJO0ZqVBbXmLrfcSb6Ta2lFh7P9zzx57BfaW2qpimMo+/isrvU8N/kiWE8mS18Ix+U1cN9/P+UZwbCfp/e8EpbkcZZeQFS2ftzl4I0PonfaVt7AgyiKnsTL9896y3y3yIeoQS6Oag+nDJDQZKj+spjOfQ70fXujmciUV2J2OBfgYKY6NYUlJTRCP77cFVw3LzpVBR4SlyR9PXsCOcijUm3hQrX9rakpwcWJU5w0BmSWLBxkY43d2e8Bsq5OWIM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 8, 2025 at 8:52=E2=80=AFPM David Hildenbrand <david@redhat.com>=
 wrote:
>
> On 05.09.25 21:13, Kairui Song wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > swp_swap_info is the most commonly used helper for retrieving swap info=
.
> > It has an internal check that may lead to a NULL return value, but
> > almost none of its caller checks the return value, making the internal
> > check pointless. In fact, most of these callers already ensured the
> > entry is valid and never expect a NULL value.
> >
> > Tidy this up and shorten the name. If the caller can make sure the
>
> "Tidy this up and improve the function names." ?

Yeah you are right. Most names actually got longer :)

>
> > swap entry/type is valid and the device is pinned, use the new introduc=
ed
> > __swap_entry_to_info/__swap_type_to_info instead. They have more debug
> > sanity checks and lower overhead as they are inlined.
> >
> > Callers that may expect a NULL value should use
> > swap_entry_to_info/swap_type_to_info instead.
> >
> > No feature change. The rearranged codes should have had no effect, or
> > they should have been hitting NULL de-ref bugs already. Only some new
> > sanity checks are added so potential issues may show up in debug build.
> >
> > The new helpers will be frequently used with swap table later when work=
ing
> > with swap cache folios. A locked swap cache folio ensures the entries a=
re
> > valid and stable so these helpers are very helpful.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > Acked-by: Chris Li <chrisl@kernel.org>
> > Reviewed-by: Barry Song <baohua@kernel.org>
> > ---
>
> Acked-by: David Hildenbrand <david@redhat.com>

Thanks!

>
> --
> Cheers
>
> David / dhildenb
>
>

