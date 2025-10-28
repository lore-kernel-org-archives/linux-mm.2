Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33E7FCCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 01:25:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92C44800F6; Mon, 27 Oct 2025 21:25:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 903D5800E4; Mon, 27 Oct 2025 21:25:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 819D0800F6; Mon, 27 Oct 2025 21:25:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6AD17800E4
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 21:25:57 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EA0F987BCC
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 01:25:56 +0000 (UTC)
X-FDA: 84045781512.24.0BF1EC4
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1B158A0012
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 01:25:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kUDTTYFA;
	spf=pass (imf25.hostedemail.com: domain of almasrymina@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=almasrymina@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761614755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6+IhRzMSNfrWbx9v4qoylhMH03PgpLB+fsJBfp3BHIo=;
	b=zupPNW45HFiGJyHLREKql3IvMPnkxIkTd9+hFD2fYekSmb4L2QUXOXk4oBzsUY9eCE4kqI
	kvS0MF65Gy/OzXyggnDQSY7fLyLtMifwZ/ZTnhJUIVUQp1HvVt3AUl/FOkS8Wi0vNv49pb
	wgw5KD5AwGo7VQh1+E3KNMBH7KFkUEI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kUDTTYFA;
	spf=pass (imf25.hostedemail.com: domain of almasrymina@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=almasrymina@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761614755; a=rsa-sha256;
	cv=none;
	b=PZHM6wQUI47loD8n0MMo9KA6i1nX3zuj8s2H+DeSn+3Nb9Iw/ir37+kz58JNhz0Dh5cSq7
	x9H5XRwE5Qwht1V03pMfsoKqmNib1AzSMXxz/Bd+/lBOQ8yGQLqbVPGaJtjy8+u/RsXEya
	Lepavx1zbg1Wq3jFmTY7a+zqGTVRpvk=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4ea12242d2eso119411cf.1
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 18:25:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761614754; x=1762219554; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6+IhRzMSNfrWbx9v4qoylhMH03PgpLB+fsJBfp3BHIo=;
        b=kUDTTYFA78Mla6su5F0yIyyvuLm4rfaVBE3B3DS6oM8IMyR027mYkxNy5Ny4BY/J4c
         crzgiY9NEGgZEzWzPOv01+3YZ4cat0mQ7/WbyZTobhwwNgINvQK0sNHzsiE+bouG7Eu+
         7M+3NcX+tSSPRyXHLnOFfyHS5TZPCYaEzpkC/D+Df0ghEKydkFQV2mhRrxTL3q8pjA4g
         tpUUS9HsyxOhokk0zasmzGIPh+MAGDEPy7pA3o9AVkWQwaap43O+RNnDlM+ulnWbbCwd
         NYRrOhZWxvuwmJf22oC99RmIvnvH08uU3hJLnNrBfdxq5r9HpXGMRR1HyJo9bpCVcsS3
         RGZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761614754; x=1762219554;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6+IhRzMSNfrWbx9v4qoylhMH03PgpLB+fsJBfp3BHIo=;
        b=giQxQ7ss3suUG+6tVE5JiF4UY0jBFBpLRcHr/qymV2GjLIpYR9mH+zgu4T+VnnlDwr
         xWCaXT9EHws3yFj9ZV8MRmo9T4nSnVLl7yJE7d8ltgn2Q2kOR+k9Fk7BluH1g8CSH6l3
         M6ATcZIPcPve9nh6NdqLtejo8emjCrG8Kr9TZzJCo4nkwE+55QfqiPog3ntOR6x1KXUE
         1iW8THf+LIyYrzZvQMYU8BuPz/oq44xkyRr9OgwsRUbzEoWgGllG83hXhak1srQo8wHC
         YX1xdFp6PE8Jr9OQVkYNk4HDfdRc2y9t5zhHKHMExy7w56HtCwQ0UOqF8t/vaKBN+9Xx
         g0lg==
X-Gm-Message-State: AOJu0YyEYLve8idYAEd1Zwxqry0Jnuf14R+KCKaWT2h5wY7xUIMQDLsm
	hEhkWaWSrPS/3h4EoVM4KABzgVQ7Aa6kYDvB6rEZEMjfS2d3hgbn3hdR/jqCzvgSG8MAHh802xC
	Kv7B3raAcwlSavp/sMYZN/bNDXxpXuJPxQtRb8Yma
X-Gm-Gg: ASbGnctYp6P2wc5CkG7yMDKTptvbpf8qG2rDMJxcr+GiJVWK75VMvk8rPTTO5LyO4+I
	EUtzRujaEBgAvScHH51gWGd39/1LeiirizbeLq5kH+Uk8mz0lNO1ZCbfMuin8W1InE8ey8OZiJ1
	L9Jxzputs1nferv/pJdK12hmO85jQTaRXk0H0shN1vg+yb1dO9zB7Mn8Rc+q+PZJ/0yfziWLDQ+
	L3w1RnsKr5Sj+OiTx57SR6z3TJueqQ79amn5LbNjnoSiu2Sfgt1XQeeGcbU
X-Google-Smtp-Source: AGHT+IGZpu7KbnVsM8kZ0fYv9D1RFyxoo19HTWIE9dDLgf5qw+saPGsXAmE1ImayYWVIS9arkPI85hHzY2/USWHgdZE=
X-Received: by 2002:a05:622a:190c:b0:4e4:d480:ef3a with SMTP id
 d75a77b69052e-4ed09f734c9mr2176101cf.13.1761614753768; Mon, 27 Oct 2025
 18:25:53 -0700 (PDT)
MIME-Version: 1.0
References: <20251023074410.78650-1-byungchul@sk.com> <20251023074410.78650-2-byungchul@sk.com>
In-Reply-To: <20251023074410.78650-2-byungchul@sk.com>
From: Mina Almasry <almasrymina@google.com>
Date: Mon, 27 Oct 2025 18:25:38 -0700
X-Gm-Features: AWmQ_bltJKoIWK6cFNZ6Knu_i6BSq0jOkYeTZTTOB6G8J-1_KJrKj4k-v2-ULKU
Message-ID: <CAHS8izPM-s2sL_KyGyUyv37PfZxNLf029DrXpQe8fo637Rn+rw@mail.gmail.com>
Subject: Re: [RFC mm v4 1/2] page_pool: check if nmdesc->pp is !NULL to
 confirm its usage as pp for net_iov
To: Byungchul Park <byungchul@sk.com>
Cc: linux-mm@kvack.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel_team@skhynix.com, harry.yoo@oracle.com, ast@kernel.org, 
	daniel@iogearbox.net, davem@davemloft.net, kuba@kernel.org, hawk@kernel.org, 
	john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com, leon@kernel.org, 
	tariqt@nvidia.com, mbloch@nvidia.com, andrew+netdev@lunn.ch, 
	edumazet@google.com, pabeni@redhat.com, akpm@linux-foundation.org, 
	david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	horms@kernel.org, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, 
	ilias.apalodimas@linaro.org, willy@infradead.org, brauner@kernel.org, 
	kas@kernel.org, yuzhao@google.com, usamaarif642@gmail.com, 
	baolin.wang@linux.alibaba.com, toke@redhat.com, asml.silence@gmail.com, 
	bpf@vger.kernel.org, linux-rdma@vger.kernel.org, sfr@canb.auug.org.au, 
	dw@davidwei.uk, ap420073@gmail.com, dtatulea@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1B158A0012
X-Stat-Signature: 74d6um9qiqdh8nhn8843ggeynjimqqra
X-Rspam-User: 
X-HE-Tag: 1761614754-317531
X-HE-Meta: U2FsdGVkX1/WcdMEcpDeYYzCIqkULnyadat+o4U5EYsbF0WB5ZcBwXCV4D35jpyerRwUjKpjKhu3ps8yNlxEudMAhDWzRvkAi2fqZ/NiXMwDHTaRT96x7ozBeFw6+/fWt/K3P14sIyPMkxC3bzClHyTzGD7SG1dMzZKEY8O420xDUaW6yI+ETxlXCSL0XtELul/rZ/gfcPZJPmRzlNssZVRxqVEHnX2plegSgPYqRGx4W1C2twfTYuGHKO7hVSyNwrL2Aqmz/w7xvJi9/GHKm6CbO6bjRIvA1xQulUH/iiiZznIGJKbYPNnTfBfRGgcjM7dg8HLq/Jj+0+X2UcpP8dhc6OKMKtgWRMhn16e8lKe9iseFSxact4GlGMqK4AcghrF8Ga8rCvgIdPtLB3FimidT0lRoUtrMS60obhFHGUwjfWY9yprDF+4R35z9IlodpBkxvgISVGvUW/oCO+gIIl2TkGihphTL4TELL9U5AYE3PK5H+u20SN7eENmOVYj08G5CmR013d/nPDAz4gCjFTvCIOnV+jxI0jzVwtMpE/pM7IjSDB3YRHiyWcr8UpG9FC0PEXSjsYuVDblM6BPMic7LHElgngtLMk0FUCyXK6yoNsnRcQbAlR0Ff89MXhPfJcAV+UL56TJfZuH2sNd8q7pvVU9UjtUHbabZUfvEwn7weRuDdxHMUNGSAEMMtbbVsR42URhUStbq17XFu36kcA+D2QQxYDF2uZqGCNvlYhiFpOwC5UB8s2ep62GIUgsjRdVxctN4+mLPytj+McMnUQIroclocbwdh4hlJ5fawtF3K4yfHHpTz4+7O+MpR/oPzkrTjaa6BENgzQjLm5YyiCFQL2PnDOmMKNUvuy5W8h2jD/8ixfaO2mKBP4a8Q9FofDOwpPb5F3Mho0qidlfO5VATRIP87z+1mjU2VLZNNVJT6HLB1X+UN0GrPnxXVuI9To5DHckBFwzgCfgEpfq
 ocTWy0Ma
 qZvWlxdcpQdUnKGANFIfKd5/XBYAP/7pcYRhSvewSxGaH9iyg3vnXCLCQ3lxTfc7Uwrigz/rT9P4X9/5Awo+E8RiShpTD+IDfDRKjm8g9KqMXJyPW9O4wlmeNXdqSYbi7/H/JdbCg952OzmtAp6Zui+cEurzZWr91aGRcKOAqJ3mpRyivnHtmoeNCCWQAljvQqsf49suXdt6QQif7oZRzLy7+fQuicSKguFmIz5q0Vcb5EPZRhtXVh28Rs0BVINufVhbfAKlido4XKswkl5ZL9cYspkW1lD0tSHfi/qezRd5FBopYG8/5s8lHeIfhdzEBng2km3oWZwPM2cQf7iGbT+g02L9DQRZ2BLPsymbFD6KYy/zmci25lLRK28R+98DdNzsBoW8M5Wu4UOEeLOGTVQB7qNK3JAE/UcgD0xw/iVce4pUkxemdtdAnXDkIE30ap5NEw12gCoYOTT9m9lHHtd4cbWU2U4zz2bMC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 23, 2025 at 12:44=E2=80=AFAM Byungchul Park <byungchul@sk.com> =
wrote:
>
> ->pp_magic field in struct page is current used to identify if a page
> belongs to a page pool.  However, ->pp_magic will be removed and page
> type bit in struct page e.g. PGTY_netpp should be used for that purpose.
>
> As a preparation, the check for net_iov, that is not page-backed, should
> avoid using ->pp_magic since net_iov doens't have to do with page type.
> Instead, nmdesc->pp can be used if a net_iov or its nmdesc belongs to a
> page pool, by making sure nmdesc->pp is NULL otherwise.
>
> For page-backed netmem, just leave unchanged as is, while for net_iov,
> make sure nmdesc->pp is initialized to NULL and use nmdesc->pp for the
> check.
>
> Signed-off-by: Byungchul Park <byungchul@sk.com>
> ---
>  net/core/devmem.c      |  1 +
>  net/core/netmem_priv.h |  8 ++++++++
>  net/core/page_pool.c   | 16 ++++++++++++++--
>  3 files changed, 23 insertions(+), 2 deletions(-)
>
> diff --git a/net/core/devmem.c b/net/core/devmem.c
> index d9de31a6cc7f..f81b700f1fd1 100644
> --- a/net/core/devmem.c
> +++ b/net/core/devmem.c
> @@ -291,6 +291,7 @@ net_devmem_bind_dmabuf(struct net_device *dev,
>                         niov =3D &owner->area.niovs[i];
>                         niov->type =3D NET_IOV_DMABUF;
>                         niov->owner =3D &owner->area;
> +                       niov->desc.pp =3D NULL;

Don't you also need to =3D NULL the niov allocations in io_uring zcrx,
or is that already done? Maybe mention in commit message.

Other than that, looks correct,

Reviewed-by: Mina Almasry <almasrymina@google.com>

