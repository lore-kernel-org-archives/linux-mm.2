Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E309CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 08:29:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 043AD8E0007; Wed,  1 Oct 2025 04:29:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01B508E0002; Wed,  1 Oct 2025 04:29:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E73008E0007; Wed,  1 Oct 2025 04:29:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D42468E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 04:29:04 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7C7545BD58
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 08:29:04 +0000 (UTC)
X-FDA: 83948870208.04.B423679
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 487311C0005
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 08:29:02 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hdKM7ZBn;
	spf=pass (imf18.hostedemail.com: domain of toke@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=toke@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759307342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TH59Sw29O2jzr1UeKiMhScDg0sFiTxNL4gz8DMwSkfs=;
	b=uk+p8x7AXhc+AZ4bWKAUkX9n/cG82bf7Bi255b3Z70gpXO+jfzwv5W/urpmRlTs8aj38rf
	WvsreFfLuJR5CsxDiIYDGsUfJg/Kds+le1672OsfrbOJE2pCBdkGvKekcSWpdxww8SG1vB
	oWXw0TaLyCWOKO928riRLLIZXKJO2DE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759307342; a=rsa-sha256;
	cv=none;
	b=aehnISJ913Lw4NzG3vK/or82/8MTmpz4ApUVGQZU1TxDIZNGbYHPzOMVDw44gyCyprkJcx
	tWkO0ZirV5JuH9Av7OxbWwpQ82i/qlnsef7OqxyIJKa8GT8f5xEnG30kEVCPPnuYupUHVk
	tPwGvPKMgRpyIZ+NivftQABGORoWHcI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hdKM7ZBn;
	spf=pass (imf18.hostedemail.com: domain of toke@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=toke@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759307341;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TH59Sw29O2jzr1UeKiMhScDg0sFiTxNL4gz8DMwSkfs=;
	b=hdKM7ZBnaw/sirsWat4/mE7lwKmhIRXgZHOH+JYBqWcAkJh0Vm8kAtbeZDbUEy2a0g0pjj
	nFx6dCTJWN0dCvEFwVuhHhTMrzNFRGT1wYuF8IR8YddTDBnRMP8M+ZSHoJ7mng6D4S3Fmn
	I8uWSPevyKSjCX8cRyl90t9m7duGNzY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-623-osEcCE7-PmK-eqXZOYjGmw-1; Wed, 01 Oct 2025 04:28:51 -0400
X-MC-Unique: osEcCE7-PmK-eqXZOYjGmw-1
X-Mimecast-MFC-AGG-ID: osEcCE7-PmK-eqXZOYjGmw_1759307330
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6339aa08acfso1099909a12.0
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 01:28:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759307330; x=1759912130;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TH59Sw29O2jzr1UeKiMhScDg0sFiTxNL4gz8DMwSkfs=;
        b=WuN+tSpbWnlmrFb4OV6CXRwu3jSCxwb4gXcnEcr4QhPoX4ux5Ro3rG3MYyIlkcvlKk
         +04DYchhR9U2aNfOrCGiA2L+/TgYcm3Ew6vQR+rlu1/RMxA3XAINlIwz7yRhuCT7PUr1
         XQWH+iwfULawrF9mOl0PTyxK0qcSMoopnJAuqGRGc3hKLmS9s24mgfQjSXd1bKt8iF1y
         zJazpseFR97Q47vPGNYWmcNC1n7LLPD0bgtISNJpP8rnn9hDztSvCQyJjOi5x6N56rWC
         hwVmvUrMpap05QjbXKS0sDzUpxn4Xzq8+maBXLezxnrRJqswQq/b+jTlurlXxGvZmSHp
         fZTg==
X-Forwarded-Encrypted: i=1; AJvYcCWO0uXi1KxFRQdwUjc/FAlafp7HxWe1IeYfwicnwBrI/hHwsly5CQtaWL6d1sc36k88VmkMyu/20A==@kvack.org
X-Gm-Message-State: AOJu0YxxITQnvs/Khu1qad19reqpOwsLpa4D3487XLS+ebMt+4SY25ia
	O5SpPGU6y7N9MTjDd2ZkUrpIaZzGHHvdUE2fuiGw7RP80I+jVjdYY8tljn17j4DdXgkji+1dEFq
	ErLTXV4/CwegnYDse7/87hPHXuWwhbpoKCM/LqMOt7130HKuRBVy+
X-Gm-Gg: ASbGncvvqm0seZ6eIPGXAytoK80yms+DbUffDPeiOqG5Bci1+vyo79JssUC9mlRMdOv
	x/5IfOHp3Gcb/nXMOArYgx5xjHN0VAU08XKvh1BbHjkLnoez5jTCui1jMI+9ETUaR3Eu7aNFiVI
	+O+VB0zhmvc0MA8UC4+nr6/6lwwnEQmONWv5fzgB2Vm7zkx6H+q43RmslShOOxPzOij1dOzSXLN
	7yj5QlnnzF6BdlKLyo8F5pBEnB3q9DojTLuxkuNwPqa18iOxKlZDwITeVs78/TOe8JvaB/Fk+ge
	Xqkfs05URxXx3q9JHuCebKeNVb/OJ/qRC9fUqeTuCewTvIdJ/6mJsyu+tQDxUaR8Efn2fljk
X-Received: by 2002:a05:6402:1e8e:b0:636:6e11:2fd1 with SMTP id 4fb4d7f45d1cf-63678ba63f9mr3429912a12.4.1759307329891;
        Wed, 01 Oct 2025 01:28:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEj+PdPhsJi8Z+hoZrTRC6U/N/PUjMCvkDv55wnRbOMIuFkZ+Ix/bmpUxPMb7w+6Ds4kpGBRQ==
X-Received: by 2002:a05:6402:1e8e:b0:636:6e11:2fd1 with SMTP id 4fb4d7f45d1cf-63678ba63f9mr3429889a12.4.1759307329463;
        Wed, 01 Oct 2025 01:28:49 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (alrua-x1.borgediget.toke.dk. [2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-63662dc0a3csm2990346a12.48.2025.10.01.01.28.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Oct 2025 01:28:48 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
	id AF4DF2779AF; Wed, 01 Oct 2025 10:28:47 +0200 (CEST)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To: Helge Deller <deller@gmx.de>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jesper
 Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas
 <ilias.apalodimas@linaro.org>, Jakub Kicinski <kuba@kernel.org>, Mina
 Almasry <almasrymina@google.com>, linux-parisc
 <linux-parisc@vger.kernel.org>
Cc: stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon
 Horman <horms@kernel.org>, linux-mm@kvack.org, netdev@vger.kernel.org
Subject: Re: [PATCH net v2] page_pool: Fix PP_MAGIC_MASK to avoid crashing
 on some 32-bit arches
In-Reply-To: <03029eb0-921a-4e45-ab23-3cb958199085@gmx.de>
References: <20250930114331.675412-1-toke@redhat.com>
 <03029eb0-921a-4e45-ab23-3cb958199085@gmx.de>
X-Clacks-Overhead: GNU Terry Pratchett
Date: Wed, 01 Oct 2025 10:28:47 +0200
Message-ID: <873483m3eo.fsf@toke.dk>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: YxQ2sTjCMPUwH7z23UH5ueERaGDKPRv_cenMuI1n3-M_1759307330
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 487311C0005
X-Stat-Signature: csgrc5z16idpj45aoea1mfbr9rjka1ky
X-Rspam-User: 
X-HE-Tag: 1759307342-393457
X-HE-Meta: U2FsdGVkX1+i8GIf2/y+NB4mclUdFEeJQFy1it8NNvLKXn5emI73xny4hX2BjWd62qH2sSRXxbwzMwk0jTL80z2YuuQKNpWqTVQMk2snMsdTh0VDRXwuu0mT0aYaQol42nyZSST6ZCscvivgut4Ovte/3yNN8cggBe1HsciUtSj+Kcd1Q52p5JxxoZTzVGn+b6uCiSg8niQooQDxHrYXcNs+d5sE1yKrN5XNdgLJsDtlX+MCyE67yDLNbuSCw9Ofcy6vA1o5GBCqe99ZXsbDYpyScav98dTlJltjq1w/6KJBvLaBEYQi0G/WQf7jB2U7Rx9lF71pBcUFfwdy9a4Eeq7kfxkkmYdtu8aeeOml1pGGBVgsFe4gtV3Sjatc74sOkpAMXZQymat3JAMlkms6IWq95T6Anj1Pu12FQkrJrkP61OkGSzPovMwjTqfCcdYzfHhkF1cuVP/iMvOCB/YOIRgDj/EL0Hx829joKMKp0DL0aQ0jxErEPP+tDVafBjt83UyVQyyhi9UP1iWPOjlxSBf/2MM34uIuwLwlNZnTAfy3uPa1j2NpLegdW+P4cOnoaP9Mpa05/WF4RYfBfifQwIMBkj4B1JOEBD9BBhhoESTsnmTeem4LCFBNuAFmYW5ezu5OIDw+YJ5gMf0/FYM8Tx5uiucXrFZMGR3NSSeFP39Ki4XxjBWcWd5PkBQ4jYHOoYUCN1DbgnOqcV4dYSYwD3K+QSsN9O2BmA4b5TkXPMypVb0qwizkB4f9ngkLdLtpiYcuRPKu7V/ZHyia49wb5erJg4eJfCSuDMU875W6k4MwvM4PwXp2m3kYqR1QAVshwRxKgBLz0hpptFgWQXUQC2zr/S6XS9Unt9hjRK9NajdwEkFPT/8sdpBblDZeZFLQtTMjyWAU5DKQgpRTZr+NEljvzw4KL83QoFE7IVpoxEDKWuaJtJebX9U8OwMwBARHVd1DZdlK/oHhS/7INU6
 YhYJhUj+
 xh/vcElUhuA+2QrSldJ/rxEEA7dvYCnOdpLxx+StQWv3WA3MsuDL+0nsW4aKCn/ad+tVTTXc1p/5F7ypelryxunpOpQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Helge Deller <deller@gmx.de> writes:

> On 9/30/25 13:43, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Helge reported that the introduction of PP_MAGIC_MASK let to crashes on
>> boot on his 32-bit parisc machine. The cause of this is the mask is set
>> too wide, so the page_pool_page_is_pp() incurs false positives which
>> crashes the machine.
>>=20
>> Just disabling the check in page_pool_is_pp() will lead to the page_pool
>> code itself malfunctioning; so instead of doing this, this patch changes
>> the define for PP_DMA_INDEX_BITS to avoid mistaking arbitrary kernel
>> pointers for page_pool-tagged pages.
>>=20
>> The fix relies on the kernel pointers that alias with the pp_magic field
>> always being above PAGE_OFFSET. With this assumption, we can use the
>> lowest bit of the value of PAGE_OFFSET as the upper bound of the
>> PP_DMA_INDEX_MASK, which should avoid the false positives.
>>=20
>> Because we cannot rely on PAGE_OFFSET always being a compile-time
>> constant, nor on it always being >0, we fall back to disabling the
>> dma_index storage when there are not enough bits available. This leaves
>> us in the situation we were in before the patch in the Fixes tag, but
>> only on a subset of architecture configurations. This seems to be the
>> best we can do until the transition to page types in complete for
>> page_pool pages.
>>=20
>> v2:
>> - Make sure there's at least 8 bits available and that the PAGE_OFFSET
>>    bit calculation doesn't wrap
>>=20
>> Link: https://lore.kernel.org/all/aMNJMFa5fDalFmtn@p100/
>> Fixes: ee62ce7a1d90 ("page_pool: Track DMA-mapped pages and unmap them w=
hen destroying the pool")
>> Cc: stable@vger.kernel.org # 6.15+
>> Tested-by: Helge Deller <deller@gmx.de>
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> ---
>>   include/linux/mm.h   | 22 +++++++------
>>   net/core/page_pool.c | 76 ++++++++++++++++++++++++++++++--------------
>>   2 files changed, 66 insertions(+), 32 deletions(-)
>
> I tested this v2 patch (the former tested-by was for v1), and v2
> works too:
>
> Tested-by: Helge Deller <deller@gmx.de>

Great, thank you for re-testing! :)

-Toke


