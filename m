Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2441EC83F17
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 18:40:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8917F6B0092; Mon, 28 Jul 2025 14:40:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81B516B0093; Mon, 28 Jul 2025 14:40:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E2F86B0095; Mon, 28 Jul 2025 14:40:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 58EBB6B0092
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 14:40:09 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 09A861603D6
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 18:40:09 +0000 (UTC)
X-FDA: 83714538138.12.9E90423
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf20.hostedemail.com (Postfix) with ESMTP id 122C81C0013
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 18:40:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LjFFSx26;
	spf=pass (imf20.hostedemail.com: domain of almasrymina@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=almasrymina@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753728007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kElooT4IAHvVgVX9pYB8yevgu/UwFxeJsat70xy7zh8=;
	b=CH48RjoUv/zCE6m0Sr0t3eTYZVO8SAHDtjrDSwZHj0lF03hmt0W5QMsfYEDNc3pEbGzv+6
	kIUYOuBd4UzCkRUISWyIvKrLZyaQW331Z6BCXppBmkWKI0irxVoYPYaZC8hGSD98XbVfdL
	8a86iHfXbojv3lIPzg3m4KmY1acGepM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LjFFSx26;
	spf=pass (imf20.hostedemail.com: domain of almasrymina@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=almasrymina@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753728007; a=rsa-sha256;
	cv=none;
	b=oWJ6c+1Tbu2LJ15yvsrcPHebC/o6clnwzCcwSU4zhaIjGGWVgw2+4zwTQS2jAsmjuZecqi
	V2GsLXvAmftH6jJpIcSp6jMppOaosLUaqDoPL20QVtTLsRDqPQqyoX+NTfmZKz9NOWrHiO
	8eLcYDK7MRk467eiWVWOCSKY58qfou4=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-235e389599fso30955ad.0
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 11:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753728006; x=1754332806; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kElooT4IAHvVgVX9pYB8yevgu/UwFxeJsat70xy7zh8=;
        b=LjFFSx26fWsvc318p3tyiBHlPMrdEyRt3OwNBrrEhClsJEwismBqoPeapGmxMUp7aj
         8iYTa+TCw1W8CepL82LkmkbKol3bTgAVxR3tlpe4DTPPu9kxIvctmCMuU9KeV7YSeLbd
         XzjqqHfAWo30zxFPxTe5NmGRaEmj7sSUPcLtRlWf29p3+6Q3UgmGhI/FVVIx+E9urWda
         ruyaEhSDEW2y3E9kdEXTus27bwsCUE3i4T+8hkWUwWRiX54vgJvue4OgB5L6X1NSz8Gr
         UEZwx6BwBEpVnSsYNECSq+g8tJZlCwp0tp//MaaGM8ANxtwAh11E9RD3oyqRSCbcWM7a
         5eGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753728006; x=1754332806;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kElooT4IAHvVgVX9pYB8yevgu/UwFxeJsat70xy7zh8=;
        b=CROHPpERY8DSyLwUyEFLhsh2IfOFC6Vln6UXiYknu3NT/PsSvoyVFHXOFdt7SvLSv+
         fWTCtl6UkWAQdXCD8TcPas4sL2+qVfgPoduk0Sx69YmFf+8dCoACiHDb8Ui5X2sqkuOZ
         SbMpz7oEV2IKJ85G9+VNEOl8e5tZBE3U6wH+XgGBjEUYAIUyOa4LFdnrRH54Dgrf+zYE
         BEQw+CQBd9LSy2Jb3XT10WUgFgfXjw0uWgAiSCbz/sI9xU9WQPY6EEjf4G0SBjwBfpUx
         P15Uu84TnWY151yLYB8qasdZbq67bq+hbeEaliDLJWzDElggM7KQwX5OSF+aCJzzcFr+
         y+lw==
X-Forwarded-Encrypted: i=1; AJvYcCVGQYOdQp3Dv5Bt3GqKmo7tOM0jj59stQSrSnyZVxExtmspmUMYk8KawazsXbbuyO4Qgm5arXE5DQ==@kvack.org
X-Gm-Message-State: AOJu0YztkwAXmd/Cxxw1Y8AuTwgE6V73SRKScVB2ktq27Dv7ojZxlmz7
	pB/cHzjGZqwTY6m0B3Qp/ATNQPteiiq8JhQc3l3Vk0zg0CZ5S6icZGjfthr30992DCpRvuNQiuM
	Jl6Bq+3KNE52nDgDSwk767mCi35MVBLN6BRu09/lG
X-Gm-Gg: ASbGncvDr2Eaq6AWLeapI4zZyjR0ppl8YoG4aYnbLl6nCoK1eQylD6qRRJCKhH8BKcl
	k3uWACwNbfzXcTNA2sKIv66+lkdSDXh9MsKODFKghjN0bqtZRXbqnlp1Ah4byIAI/uF63pfu1oA
	VKxZRBXMVk5UTgDmq6/OwiNW3Z/dhD3UibG1p4XZfG8fAhOz5+WmPYpf7HLpYfAzw1hwiiH4THY
	ElEpzZM2/9od2/xF9Ytm8XIJHQ2X0ts6PTncx/HQyWQ6jBaAEJjR6hz7zc=
X-Google-Smtp-Source: AGHT+IFiTjDeBpEApQbF4hYs7HgiAPbvdpocoITXlbamYX87A4mT1jZoFeAsOSv90fvuk8ivllMPYW7JIqK28FHHq+4=
X-Received: by 2002:a17:902:c949:b0:240:2bd5:7c98 with SMTP id
 d9443c01a7336-24068ef8cdfmr240575ad.11.1753728005408; Mon, 28 Jul 2025
 11:40:05 -0700 (PDT)
MIME-Version: 1.0
References: <20250728052742.81294-1-byungchul@sk.com> <fc1ed731-33f8-4754-949f-2c7e3ed76c7b@gmail.com>
In-Reply-To: <fc1ed731-33f8-4754-949f-2c7e3ed76c7b@gmail.com>
From: Mina Almasry <almasrymina@google.com>
Date: Mon, 28 Jul 2025 11:39:52 -0700
X-Gm-Features: Ac12FXzdEF9xaTcLfGhZyp6hzC9OOZQrKTg5nGgx21xEL8_A7PY-4QwgLa-JD48
Message-ID: <CAHS8izO6t0euQcNyhxXKPbrV7BZ1MfuMjrQiqKr-Y68t5XCGaA@mail.gmail.com>
Subject: Re: [PATCH v2] mm, page_pool: introduce a new page type for page pool
 in page type
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Byungchul Park <byungchul@sk.com>, linux-mm@kvack.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel_team@skhynix.com, harry.yoo@oracle.com, 
	ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net, kuba@kernel.org, 
	hawk@kernel.org, john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com, 
	leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com, andrew+netdev@lunn.ch, 
	edumazet@google.com, pabeni@redhat.com, akpm@linux-foundation.org, 
	david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	horms@kernel.org, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, 
	ilias.apalodimas@linaro.org, willy@infradead.org, brauner@kernel.org, 
	kas@kernel.org, yuzhao@google.com, usamaarif642@gmail.com, 
	baolin.wang@linux.alibaba.com, toke@redhat.com, bpf@vger.kernel.org, 
	linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: dzj6536nqno3wqxcb83ick8uatc69751
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 122C81C0013
X-Rspam-User: 
X-HE-Tag: 1753728006-431244
X-HE-Meta: U2FsdGVkX19Tp39w9gmZKftGQNhFktG9epvB2m6DIu9VAqfEMzL7tGMxo09id6ybsUhT1/Wuov+CA0ACTZTDDfRAMwQ10gvf5n7gjvnYHVMwhF27VFQSEe3G/676bip7hgXgfl5dZM4Myo0dExchHiUbvQFI+hSdlbYIW1Q2s0q1KhGbxDrDLEcW2BCRCoMhXzIUiGDMDcqTdSfCtuBi8Y05sxpV5cqvCwNNAbxC/4touLxqo3+jHDA4FxT110KXqZ8362JcRjlBdepR06ek2+lBD9EW0vg1gz3ZWEkvDGYbbA+C+xBYeAzIQtTzgB0mF/Q6lE62Kca7C+PEeljNHzfiV4ntfdyWr2vbXqpX2upJ7rh+l5/hk2/BcijonY2FsxoQlFrlFtJLzrDujVTBbwk2kC5uM6dVsbBuUDMn5f1R8BlSDZNqqahX/GSY/B7D/Km2iFbZwTumy0ZOL9Quu6C2CWq4UpaYGQ8i4PC+v7UtCMvgQR2clI7VtHwElcdekXVgL5vUfqYSLNynNduZrcjOiNZvF/sc66SiAVkMDnJ6YIJuznePhz/H8z1IER9MxoabajKPG7UZMLd6XYruz1b6cn1wjlMJuUioZ1zehvcRUWUms3yLAHgnLuQBPg5j5kGr9HKT9CAy6E7XT/7xQKHkLdfxYjyADUvdwQb1w2p8ML7Rs/jHOmKJa5+UfAewYQ1ScsQdtHi2YA/MmW7PxK6TBMqoAs5MuCybp/7b6q/KUW0Uz/V0k8Gsn6LL2kq5cAMX/L4v6bq6Wbh48EyUbskUVhXmxMI3Jo/JEr/LA52eCkpQgg4x8b6QaLQm7tIuiUZffaJmbEJVS2LtF0NImubXIk0DBFNVBnzb9mfQDiLKpZOoB92ScawM8bREVHZ4p5qa8FhnECRjWU2T6Qsel4cUINYnv8lij1f/BlaYzBl39XhAcreogp6nTFXsUXq4lODuN0IoZRqa+0H8Ylp
 aWhj4CQX
 JlVTs/3uje1KNjanXe5VI/eLfuij8WqfGxdRMkD+OZ/Sv8h3+j61DAOL4WWdgQezCJRE1GqPV/xfLxOJsKBpsIOnIi0rR0u1yFRdkZohmv7FLktKIMlG30s4VyslUZgbw3wdStzIe4qyP+G5bloI0Uwmq8r7LEjZJOVgBd5gjE87Bi+aSQ0SsCZ9OcFgk8w7+oW6nlSECWMZkbo24YwCqdeag59zexyo41BZLomN8CRzs/PRio1mSKFGYwa6GsGKeRcpLuOgLmp/bRbZg62qkyeceY4j9fthhP+55iQNsocfChGr48K6Vn+SMSbBSNCNJWO90MGhHciXS3MBmax/eDbBIumhc+5xIsWSqQm9VIpgq2k/2DGrabH5TzKeXK3+82g0nMdN7RAKRSkM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 28, 2025 at 11:35=E2=80=AFAM Pavel Begunkov <asml.silence@gmail=
.com> wrote:
>
> On 7/28/25 06:27, Byungchul Park wrote:
> > Changes from v1:
> >       1. Rebase on linux-next.
>
> net-next is closed, looks like until August 11.
>
> >       2. Initialize net_iov->pp =3D NULL when allocating net_iov in
> >          net_devmem_bind_dmabuf() and io_zcrx_create_area().
> >       3. Use ->pp for net_iov to identify if it's pp rather than
> >          always consider net_iov as pp.
> >       4. Add Suggested-by: David Hildenbrand <david@redhat.com>.
>
> Oops, looks you killed my suggested-by tag now. Since it's still
> pretty much my diff spliced with David's suggestions, maybe
> Co-developed-by sounds more appropriate. Even more so goes for
> the second patch getting rid of __netmem_clear_lsb().
>
> Looks fine, just one comment below.
>
> ...> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> > index 100b75ab1e64..34634552cf74 100644
> > --- a/io_uring/zcrx.c
> > +++ b/io_uring/zcrx.c
> > @@ -444,6 +444,7 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *=
ifq,
> >               area->freelist[i] =3D i;
> >               atomic_set(&area->user_refs[i], 0);
> >               niov->type =3D NET_IOV_IOURING;
> > +             niov->pp =3D NULL;
>
> It's zero initialised, you don't need it.
>

This may be my bad since I said we should check if it's 0 initialized.

It looks like on the devmem side as well we kvmalloc_array the niovs,
and if I'm checking through the helpers right, kvmalloc_array does
0-initialize indeed.

--=20
Thanks,
Mina

