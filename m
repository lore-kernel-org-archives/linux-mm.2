Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AE00CE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 11:21:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EA2F8E0009; Mon, 17 Nov 2025 06:21:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C2C18E0003; Mon, 17 Nov 2025 06:21:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1A0A8E0009; Mon, 17 Nov 2025 06:21:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DB5478E0003
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 06:21:02 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 696598A092
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:21:02 +0000 (UTC)
X-FDA: 84119857164.21.DB1BB28
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 36B7E180005
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:21:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I8bYIGgX;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of toke@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=toke@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763378460; a=rsa-sha256;
	cv=none;
	b=oL3Fb6iqJ/8a1374sZ0B2XRb3TmjW5jWU0gLQ5dUY02zRVP0syTCZf+Kw3sJvdMGBOgRWq
	xTSVLO5H7rKpSe0RO6TzaDna8QSmFp0tJjpfy2I1kW01lvzC6fM40QBM8xTeZq50ocQJ4e
	Hq2S34x0ZFIfQuXqWmZiGSuvyFwTCzU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I8bYIGgX;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of toke@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=toke@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763378460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QVf9LxNdBO8TaOKgZFNSQsuTbNOO3hmBDaXVsTWiiWA=;
	b=v6/jguYZbMjzTMV4rLLFs7QPWa4Qkkk4FluckmumxbXoHwSb74jkDxQFnpJ7p7j79wjqGJ
	mUyh1tSm0rSuT4s2BrzirRmQuY/+ZuQmVVWGOH1eUue+bFTwQWsoTs27l/VFSb0+d8H8wS
	BKIw5SDZgZ6Bex3s6xCG12FrN9Gvl8c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763378459;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QVf9LxNdBO8TaOKgZFNSQsuTbNOO3hmBDaXVsTWiiWA=;
	b=I8bYIGgXifOH20wmS9+zXtI6/O28rgITo46ljUCAfuNK9KFeoDV4GFP+ayX56s8zODiBrX
	3Dzkwj3TDLulB8RyEXQhdfjrdXNqxjHfdAf/PgDEA2O2K11s4h88z/g05q2Sz55pRaoFb3
	NQX/2Srd7fH1KA5tXOYfTIbNA/Uc4bA=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-486-lU6dDWxgPSCQsVL0CpEtog-1; Mon, 17 Nov 2025 06:20:58 -0500
X-MC-Unique: lU6dDWxgPSCQsVL0CpEtog-1
X-Mimecast-MFC-AGG-ID: lU6dDWxgPSCQsVL0CpEtog_1763378457
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-640cc916e65so5237982a12.1
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 03:20:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763378457; x=1763983257;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QVf9LxNdBO8TaOKgZFNSQsuTbNOO3hmBDaXVsTWiiWA=;
        b=HY2K5AJW06dF2CIOsSq3g4AjcFOeXqYJYpq3Bk9jwHa51I03Wz4J3L9bzCwg0i2F72
         OlEGZLZP9m/NKra6e2GyawZsvgPh2NcCdnL1vNsH3gep5tG+kqrY+QLCHMQ23A9q5VdE
         t6+v3gNDNyi0CE4dlg8944GrEb0HMB1jxZBHcfE93JbmIKUziOlT+XY6I1Fr0m/B2auG
         25vkGHTCfJCD+T8N1gJvjSEazSmHI7XqYSe6f8KicXv53GOPfj3TDSip8mnEh60CK0gO
         NhV1ySoCKeK1EnFrg3DY9SLuT6rZW2S3D5vGEooKT3YkAw3i5eE3AC2jYiP0nAlCsF4h
         Iccg==
X-Forwarded-Encrypted: i=1; AJvYcCWazFFQJSnAVtucFordGL8Apv3oVjYjqaaTMR3FMq6okphXVQFz3EKqbLa7qagzu2nq+iU8WHquDA==@kvack.org
X-Gm-Message-State: AOJu0YzU8NVTaEoXwyr2ditkXhGI/Q9VIoEfRY3xPRbSNPbwSbTZ9Hpb
	nzws/90QH8TsdBp4Sug8cxB9cHZIhy1SLLA67Ja6NyZ/um8hvets2y7LOJqRbOu1hq2k1BuU7gS
	CJqT0OxiEPyLb0FQ63t7fm7wXgp/wutENysJ/RRcuVFGLn9n67wqR
X-Gm-Gg: ASbGncu4Ysc+bApeVRWEa7ZDQv1ohCHXoTT0aRBHq6cRiMyPrCthyVub3io96IpcDY+
	W4M511CiCTXHHbgIVnbGM8ZFC6nOMyLAw3Qf2QCKQ94H9w+uFMSOn+57OW3uf1n6/CgKL7kDTZj
	gDSK57js/LPW/7uokJnf3ciJqu+LgfB2y30PfxkoGbHt2ljd7KlMZY8RlHxbzT3HRovUBUvteAD
	IlrqH00vHyJ8QDql639h3QZVk+8o/gfc5OyU+qhWSxlUgRtkrlbK+6BjJ++Y9jCUVSBT2Mcbilr
	NR5gqQD+kWxKjRcLS9YV4+5AXUK08Cb6rSZQOGWX7bZ26fTUzf/YirOFtAXU0+K+9OHR07lDFMJ
	UwaQU2bKwhxRWW6mlfa9uReBYWg==
X-Received: by 2002:a05:6402:51d0:b0:640:b736:6c15 with SMTP id 4fb4d7f45d1cf-64350e23625mr11703557a12.10.1763378456998;
        Mon, 17 Nov 2025 03:20:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF4Wdj00OQMd3S1KCNlU9xBz46Uej0UIJ1gNeKRvwBEkwOcay/vlwA/7tWC70CgNVFMvt+NUw==
X-Received: by 2002:a05:6402:51d0:b0:640:b736:6c15 with SMTP id 4fb4d7f45d1cf-64350e23625mr11703494a12.10.1763378456453;
        Mon, 17 Nov 2025 03:20:56 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk (alrua-x1.borgediget.toke.dk. [2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6433a49806csm9992622a12.18.2025.11.17.03.20.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 03:20:55 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
	id 1D7AF329B3D; Mon, 17 Nov 2025 12:20:54 +0100 (CET)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To: Byungchul Park <byungchul@sk.com>, linux-mm@kvack.org,
 netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
 harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
 davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
 john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com,
 leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
 akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, horms@kernel.org, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, ilias.apalodimas@linaro.org,
 willy@infradead.org, brauner@kernel.org, kas@kernel.org,
 yuzhao@google.com, usamaarif642@gmail.com, baolin.wang@linux.alibaba.com,
 almasrymina@google.com, asml.silence@gmail.com, bpf@vger.kernel.org,
 linux-rdma@vger.kernel.org, sfr@canb.auug.org.au, dw@davidwei.uk,
 ap420073@gmail.com, dtatulea@nvidia.com
Subject: Re: [RFC mm v6] mm: introduce a new page type for page pool in page
 type
In-Reply-To: <20251117052041.52143-1-byungchul@sk.com>
References: <20251117052041.52143-1-byungchul@sk.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date: Mon, 17 Nov 2025 12:20:53 +0100
Message-ID: <87o6p0oqga.fsf@toke.dk>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gLeezaVDq5XVtDlUo2aglPtzhpZD_5Y_F0YMmHwgVd8_1763378457
X-Mimecast-Originator: redhat.com
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 36B7E180005
X-Stat-Signature: 7dru91dan499dw1f9q6m454k6rhset4m
X-HE-Tag: 1763378460-183078
X-HE-Meta: U2FsdGVkX1/PcKgIHuYheX2xytxcAkG+z4uLzccz8WROCM/DVXGVqYUdxV2MIcglfKK/m0hRyvRNlDworbQQw9BUA8mOp4TVfNxidpblh3UZmVSw4gmbV9Ltmro/AV7hyPCkx0jVxaDrPlYAl1h0f4yEDgIWBx+vgc5cE7xmHAC5QwMDz7eGFRgM8lPN6uRhFoc4YPglq0hTx6JuB9+8rAEtlJvwhXhtYaZ9uBUrO3/Bo+t/CflE6dpi890hU3UYW2MLxJS9WgKYCRzsRTn4ngeFTStXc+D3BzFW8+UUFzuH2+6egvrfOcLOP99q0bA3Q0lEV426mwnkPFLtZiqmSKzWXKLoWcZe8eWWqWpMeMe3tPCMuyjxLhvz5erxh1+zHFTtqXcphm+EEivp9X8PWW7olzuiNOOmoP7tr7ZmG3OFhggB7aQpM1vttN0ZBHgvNj1ygUUQLiqO+L2yb5ApYsqT9Gy6IksXR72KTSx4LaIlqbwSLpQgqh3PiGgJja/+07Sd94vmT+Fv7Z3g3MpjO2w4s6xtWve7Ai9JpObXj6zGDZe3CqJmgxJpcRfTdaa6Vjfo4fBe1KImgUmxROPK3THOT1B6Mqiwnpg7n5CxKKenMuRYloh4lre+3rENPjvOM1vCxZBziUggCeOeqJtnOvA4IpvV56FXUl4gPLiA088WEPiH0P0nKjYYIWOXRe4ke7lmIQK81wdjxzetZrsq132VPZLyd9OcaO7DDFTH5QKsA78huce3AlH2uY9pk1ayEmmcwoZx+AKvuVTY4LTudOKQ4i+Kg48Y1PCUbF1+5szxtTnJRsL4lRVppxqiE7WVxasJPZqrJXmgAacL3W8sBkkPooudiEiP5YomtIsCkuIq3nN8ENL4Ojq8af1uU7N/RoqD4NmzC6BcVJift9Q3z5eZCkdgUA3XANnE9hZYA319vPIvI+TTlfad+PIJN29ckoIg7v0MQzR45O9Ei2n
 4wp1iy7A
 hlU1IZB6xEtnMiJsf47B0lQP0waHm6u7rUGehWRRvpifst4UZEA9VR0MNRDCGr+X7vSW6VWsmCAXekrzyxw32/QWTXQNjPMNogIlUdk7pPON9EfP6AvWBLYr9VxqkiWZV7D1uvS/I85Mik4ph715+QQFWeGBdBQ7B/US7F2bg9fCBUkU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Byungchul Park <byungchul@sk.com> writes:

> Currently, the condition 'page->pp_magic == PP_SIGNATURE' is used to
> determine if a page belongs to a page pool.  However, with the planned
> removal of @pp_magic, we should instead leverage the page_type in struct
> page, such as PGTY_netpp, for this purpose.
>
> Introduce and use the page type APIs e.g. PageNetpp(), __SetPageNetpp(),
> and __ClearPageNetpp() instead, and remove the existing APIs accessing
> @pp_magic e.g. page_pool_page_is_pp(), netmem_or_pp_magic(), and
> netmem_clear_pp_magic().
>
> Plus, add @page_type to struct net_iov at the same offset as struct page
> so as to use the page_type APIs for struct net_iov as well.  While at it,
> reorder @type and @owner in struct net_iov to avoid a hole and
> increasing the struct size.
>
> This work was inspired by the following link:
>
>   https://lore.kernel.org/all/582f41c0-2742-4400-9c81-0d46bf4e8314@gmail.com/
>
> While at it, move the sanity check for page pool to on the free path.
>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Co-developed-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: Byungchul Park <byungchul@sk.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Acked-by: Zi Yan <ziy@nvidia.com>
> ---
> I dropped all the Reviewed-by and Acked-by given for network changes
> since I changed how to implement the part on the request from Jakub.
> Can I keep your tags?  Jakub, are you okay with this change?

LGTM, you can keep mine :)

-Toke


