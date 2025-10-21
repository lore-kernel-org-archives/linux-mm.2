Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 873A8CCD19F
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 03:07:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E38FC8E000C; Mon, 20 Oct 2025 23:07:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E10608E0002; Mon, 20 Oct 2025 23:07:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D26F48E000C; Mon, 20 Oct 2025 23:07:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B87B48E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 23:07:12 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 602685893E
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 03:07:12 +0000 (UTC)
X-FDA: 84020635104.19.5194F88
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7459020003
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 03:07:10 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DkRSbBBK;
	spf=pass (imf13.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761016030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7GvBKGQ+d+ZH0zzVE5EYl9cGgS9Mqi9XdJnDe211TWw=;
	b=X1wYiChkXSxjhsHk+nX9IMcYwbLik4Z9HDgEf8o1tlSCAS0scPUYXZvO835b/kbJvFv0Av
	snySF/XpdydOGuMgNwKgpn9tGh/FUbN/vvOgfuGZBmay9ZdQhBHYlMq1tPwrDcfjZkJgoI
	4XHD1RHxK7QRekdPIhQyk/46t9RMPUM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DkRSbBBK;
	spf=pass (imf13.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761016030; a=rsa-sha256;
	cv=none;
	b=UeS/4hD/ezxWWCZZWvd1XQP3MCFhQR1mzX129xcfFowOI7xNxAbUGo9/GeDl/UFbnpNNsF
	QRbYVrZAxDfo2ZbQmEjOJaijr1tPoBrLraM7rxqH8qqNg+4pnDFRZHD0CTLufmPM1jHKO9
	MjxgSbOFmhGuxzK78KbpEPEcTEXOSgM=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-88e525f912fso760398685a.1
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:07:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761016029; x=1761620829; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7GvBKGQ+d+ZH0zzVE5EYl9cGgS9Mqi9XdJnDe211TWw=;
        b=DkRSbBBKW/dm3XbJMtVui3FDR2x8ZytHT3vfh/bKZ08gfeYRIwFm1fo5N5L1O4Tmtc
         3st7Uqtf3Z86GnB37BKBmpp8Pg1DgiUfZbkFl997ywtBkHRI0SmtcVl+i8HKPfhAOV3z
         XjKE4Lw0HomRN0RTt6+VC+Oz3/pYRkC4HA0RzC6fJFLd7+fw1++aRKFhhciexnMx1MAq
         zXQC6Uk7setTXY6WZ5dv2pzpn/4b4/D8h9B7JDjyfjc7+vmb8LOHhYmf8uC/bF3NKw57
         /O0aNwjbUWIhbR6H/YWGxCbpSBDkqpjMciT2Y15FFUK6ciKNc6A0AOcaA5MAmxioT68D
         ekcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761016029; x=1761620829;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7GvBKGQ+d+ZH0zzVE5EYl9cGgS9Mqi9XdJnDe211TWw=;
        b=J5PM3Bmqd7ee3oJ9el+kjlzRWJtQc/86exadArCkpE4ytglL3oklrC20+MEh7DQ/hO
         Cfy6dBwmxEDy7AV+hl+aXXGsDKKQdzvVGqPhTlIRjP+YnoGfTEi6TjDauHnownGWFFCB
         Mgih21yoqo4aUlCLvW5yEjpNjHmr6juRplgxHnSpGgoajK/2S3Jr0CIQarzdRl0SVMEI
         wEYOASiSeW1Wo07rzP20kCz6U0JdM4t03D5cWLJBKgJk8DKCc5l492x/499Xqr8icfXq
         FuDnJTMuRfNDitWWOt3iangVpBpsMeNGK0MWm4dKHl1etHO6A0c0BC0l0CO1RnzLskyq
         4uKg==
X-Forwarded-Encrypted: i=1; AJvYcCVw1zTTqLfJEUrdCgaGcVwEENxQylnoZ5nBSr2pH+sENKvf3hKtc/lQMOmy4JQVbQb6Ig/qbQ7TUg==@kvack.org
X-Gm-Message-State: AOJu0Ywfbibny3jkgCKkuZbgqUUtmYQENFIUiYzGzh/YBNhnS0oHT4gu
	Wd9hA9UGdTOLIjfQkXTtGVTLEGkNFdqvfMlLiBUJheLligdnFrIEEelfTuUo8A/YlXb6CXQeFNw
	7ejx8IXjonm5/kJZf4WXFhE/NhxofqK8=
X-Gm-Gg: ASbGncv5KgWJDD1qeHJKJUlWxkQR2fVSlJUs66q1v3W8RzAcrm/SFoXRF6Khwc9dawk
	ZNaK4PvPGzDse+lGObkpuExsVTlQO1GLmYZRbcPVzUno0GsC7pTrrKX3gA5IHyJO0EPBM2S+pTg
	tC5Vng5eWMQlWqa0i1UxyVAlxJUP26nBKGyQcL2qJHZM0p+CJI83MATN9R4voiyEaddNXRUgjLu
	SEX2twfgtj/pm51u+byQy7VSJf1KiyMiCC140x3d3D8OMRnB4ZWWrxGITtP1+sjbelCxfr8BysB
	z0vDc1zIgkjZMmxd
X-Google-Smtp-Source: AGHT+IFKcBG378/hUHizh1Mq6MTfEynILFmWTRQbPTkL/+u4MUfK/P1oy2gIbeRmAo75VvO9KFpxlKHn4vldRAI94/I=
X-Received: by 2002:a05:620a:2682:b0:812:c6e3:6663 with SMTP id
 af79cd13be357-8906f260531mr1741885485a.34.1761016029464; Mon, 20 Oct 2025
 20:07:09 -0700 (PDT)
MIME-Version: 1.0
References: <20251020061845.3347258-1-wangkefeng.wang@huawei.com> <20251020061845.3347258-2-wangkefeng.wang@huawei.com>
In-Reply-To: <20251020061845.3347258-2-wangkefeng.wang@huawei.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 21 Oct 2025 16:06:58 +1300
X-Gm-Features: AS18NWBIZM90ioPZoZEqmGnkTRcmpRxfRugewFxj982dlO96yqtoAgRS_hdiPCI
Message-ID: <CAGsJ_4xYhFxEA8vfNkaXE85=2x48GDnnOJOoWq93JQJh0=+EKA@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] mm: mprotect: always skip dma pinned folio in prot_numa_skip()
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-mm@kvack.org, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Liam.Howlett@oracle.com, 
	Sidhartha Kumar <sidhartha.kumar@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: h7e78hmp5g1eet8g1k99x5d4wm44t4ga
X-Rspamd-Queue-Id: 7459020003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761016030-286709
X-HE-Meta: U2FsdGVkX18Ku3ASHwuhEYSZDid1fMP+DaZ/guvmSFs9oWBGBpWGSPp+2YI0yMwHSfuVshuK0iWROeG8iZO67pEL6hjgK63ktuExCBiYgO2P6CPaX+H8fNrSWPxEsDO4ETkc5s5GUCz7awePY8lAYT3aacwjp3iumi87UpKhuVXiJDUb8B6zEFgN+ybZmAaOBswhBma7RuXnH8hxS7iZk477riz0ukxf6Se7N+bVIZxw4hXQldMUgslFba+hqoLSgY/9JyzpGW8VdklJEx9p3n85C1FkZNt1+zuPx28w+hWcaWuam/hPusYXC1+E8Wybz8AUMDBU8JODKCgX1LPSfj6w2Jw5txvNGdHxdjYZl0BwGwzILJXTadUjf67R5uEXn28OC8+lh1EBoxarvnbCUF1Gzu31yS478ULLFm7Jso2WIFJwLiNrOHdGstIuFn40ajCBSO2ls/lfK630Y4qjGfp9cWruxZnI98tuxcMLCZI+7LWhYXqL4psmzML8z3Gg1Q75pHt0PFMm/1W6Q/yRriiqr4WxwAh2B1bCOJbj+DIpZMxc4Eok07MF8chg2XYOdOBrhw1Edns1wSdYF6afoZzYFZOnpGDFp3dV+bxfLELi/2o2kxOynMnp/bzmlN4sBbr5AFNNWFEZrwi93zDfHTktluf7QlyGsh4h4U8ouBpwV18nQ58yvnwktKS59Q/TnfZA1Wc/y4K74yu4YjaLfpbqQ5StRnEYizMjaJFz3oBXiH60FSafk3h1oJ+fQKIwwpy+8BqUmOC99e+RXwnUn8bEdPoubSjXhU/Bwkg1YRykhYsC99LmobKA/dVClCtTrah9CaZEu5yLyPBrHsjS+WVr5/0enwApy0G6aU5EFH08u4SCKe5tepK0Q4UcupDKutuV/iTOj7a8cngkc+VkCrRUBu+FmZNJYhslyxg2idSyvnNdwJnbmbmO8bP4I5SDdiTFn1SD8i4/fKGjvQV
 yBCf8ans
 HeqgXevdEbykGYmqYnpvXc+rotX9k11cNz8NXS15qQGacEPdEdNv9ob6CYVPTDn1nlVt7CiX9E464xA580nSNx/69B7LR+NrOJrIwZsz+8J9DhnCKGLUt5Q/s+WmaLsMCC6Vp+5ku2dEFNWyDFb9FgSBLP45JQK43jH5DYl0VmtUwIQ8BvSSEVpgB3OVbgUJDOL94lDiZf1yWTrItuE9gzbXjILE0gaekSGAD5M9zGDUEeWhaC2Q5BkwpNkX9h6S2AQhFOMNBunICL6N4HdYSPGkegY1yE3nlIZZmxqskY9XrLnM3Gu8FDNOgLYeQ8cpLt95dl0VZqs2KYlAJHdcl3iBDN1R+JrbuHZUTnm20hEsNOYyuj7de5KabUpuvlcO4gVSIiSWQJ8SjoG/9U1ai6nPWtHsbeY9iNKaXWkD/XQZHJlWscKhkXImevjj47Yv+PY8bG7ZeK5AjHShS8gXcVama5FRj+qAAViPaqIZVz0f7EqzqEeKGveFH0rMHH7LfMh/fI+NQhva6F4Kwb9/fHvJpEg9BHVaF7IUW4+jRSVugiQVctHR1foXS22lsNpFDgg3smAsgmgv87yOAWasIiYpISs+rFTFWrTux
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 2:06=E2=80=AFPM Kefeng Wang <wangkefeng.wang@huawei=
.com> wrote:
>
> If the folio (even not CoW folio) is dma pinned, it can't be migrated
> due to the elevated reference count. So always skip a pinned folio
> to avoid wasting cycles when folios are migrated.
>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

LGTM,
Reviewed-by: Barry Song <baohua@kernel.org>

Thanks
Barry

