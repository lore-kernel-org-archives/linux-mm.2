Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20B96C83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 22:20:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFAC36B009E; Tue, 22 Jul 2025 18:20:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD2866B009F; Tue, 22 Jul 2025 18:20:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0F996B00A0; Tue, 22 Jul 2025 18:20:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 926486B009E
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 18:20:21 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3DF61160466
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 22:20:21 +0000 (UTC)
X-FDA: 83693320242.01.3E213D3
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3E7944000C
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 22:20:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SEJtZTD7;
	spf=pass (imf04.hostedemail.com: domain of almasrymina@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=almasrymina@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753222819; a=rsa-sha256;
	cv=none;
	b=xi5xDTbKgdX+VZ55wONfOryYnK5nErBVP5LcQdyYPDNdJG/cY/zAZFTviaYj7BjLSivJxH
	nogBXwhC1wn4BPhIpWGmrZ5Ox8a1bp5nBH8TWVq4Df9dUosizsrAzEvmvhTmWElMocgXn7
	xrnRb2Bcj6RaDfi4Eay4tteWRZdI1Eo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SEJtZTD7;
	spf=pass (imf04.hostedemail.com: domain of almasrymina@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=almasrymina@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753222819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EUgAXknrynl1PVAEbmko9jsFy37xoKt232CbGC5xnSo=;
	b=DVocDdPWLBqbSYI+HB9UHftpOxyL3lcstnbrXkxKe4Nnk7fPCBcJaWw/i6qnniuDLH+vcu
	Q8NNsD0pVkMbggYSUzw36SSye6rCEprBHTg7Xrrply5Fj9TQSgZSh7aftVodw8Kq323vYz
	+ju9hTLTjqO+mPsjer3GtxksCxuD1os=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-235e389599fso88125ad.0
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753222818; x=1753827618; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EUgAXknrynl1PVAEbmko9jsFy37xoKt232CbGC5xnSo=;
        b=SEJtZTD7jK5QKfoQNrudF8t7T4QMorZjcCBxgH1Zu1xmGerqZOppQxk/JeQpzS+Em2
         1YATUR18MxQCYmuMxdlg5NzMiY70V+Xy9+PwopXsKL1ngABxqODZ6T5MbU+E1WeR8SNG
         kunlGmbreX+bXhSaxN0hVdm0qjx7l89O4t9K6uiybN/JEFn74ZfMQRZxTlv3SqZt9E7S
         8rXfDl8zIueaxGqYrSVIJFXhD3kOxlRJpw9wTeNmRRqp/b4TuhZ+8eVJogbUjTp/uWEE
         s9ym+1WWC42TsVGrKGk80uk+SDHNWGHaPx7bYhlj3tVPwOpZlhOYg4qmlgZA73S9vy7j
         i7Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753222818; x=1753827618;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EUgAXknrynl1PVAEbmko9jsFy37xoKt232CbGC5xnSo=;
        b=UmxyO2mHShQHZ357mLOG6DZE98jjuVI3KX+iQlEUC3uv56827mdCPqhXAfK/k5uRSf
         hdtO44keClhY/vY+86cptF4Sgu/9ifFqbTHXMsLKSsR26QEhCQ7z5WkN0WohTPG9s58V
         cpcdIh4thgEaNCGtbTDqcDPv39DfIU4qiE5NRrnVLLXIX1FCHu1p+TghawEymGoC7GqP
         zLkb3+g/0sJVwphIM9yfJMK+awl3pD2RJnZ+uyWSGI6H7H+Tc0vGQd8XvdAMfeB3v8SN
         cjE5t/w9EH+80j2BoKw5DNhn7ehKUqo+zQveFexTCX1VWX5NLWyZiSqFBVDbCqkWcmHb
         fKGQ==
X-Forwarded-Encrypted: i=1; AJvYcCWcUEg82mmnxolHfIbt7XETTXAPeFEbbo7zxKLqGBJvXrFOI2F+Xb+jzcqQMWbtbqeVRBCFYH1VJQ==@kvack.org
X-Gm-Message-State: AOJu0YwLuOh+n0neS6bVuBb1p6b8FnG1Eytv7wkY10vzBW1Mr9z2TEtp
	FytWbvsxOC4qFH0CsbBs9jnrp31w50W2rBVAFIp5rdFF3GHajG5dXCZ4VTo8Ou3BfxcKQl3Cqep
	FaswU8iXpOd0hohYU6cQT6fOdMaNcQIT8ef0tz9zp
X-Gm-Gg: ASbGncuIgcFgFnQU2+36sORSmooG84RcoQayF1vb88sjrJ29gDd2S6pSLV9s6GCRw1l
	r7fJ7T4en9j8R/Nf3kasDhMIM1z7fQP3QFwu2oeud5D269QsSa91gcdw2IY4qvS143d3tFN9r6B
	sQm9hKfvAUjMSF89QhNs0JkyCrIbWNaQ1XTTtdg85xYTFahLMyjdyk2/i7347hNLVEJPEc2Fnsh
	Z7rOBqpmn0T6RgjXs2SzuCkRidt7iSOIKqCvlzejrrjGt14
X-Google-Smtp-Source: AGHT+IEJT44DyruhFdmOQYM4W96ZZ3Rqdwh8/66PV5JlsG3oxzJ17BtYsAJ9a8lIS9JPty9YbWXGIDpfJrmGPSXLLK4=
X-Received: by 2002:a17:903:b4f:b0:234:bca7:2934 with SMTP id
 d9443c01a7336-23f9774a735mr1113195ad.6.1753222817810; Tue, 22 Jul 2025
 15:20:17 -0700 (PDT)
MIME-Version: 1.0
References: <20250721054903.39833-1-byungchul@sk.com> <77ee68c4-f265-4e55-9889-43ab08f26efd@gmail.com>
In-Reply-To: <77ee68c4-f265-4e55-9889-43ab08f26efd@gmail.com>
From: Mina Almasry <almasrymina@google.com>
Date: Tue, 22 Jul 2025 15:20:04 -0700
X-Gm-Features: Ac12FXzc1yuJwF_iFb86CzQvJ9VHTzSRxkDhmv6GFozlbXOI8GKQHpDpguZKYVU
Message-ID: <CAHS8izM6h1_qoPnWDHmPiiFj5e_mcJqQFTTLJT9dgBymJuk8rw@mail.gmail.com>
Subject: Re: [PATCH] mm, page_pool: introduce a new page type for page pool in
 page type
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
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3E7944000C
X-Stat-Signature: m3pdwa7w8wfb9xzzysotm168kxt36cwk
X-HE-Tag: 1753222819-139120
X-HE-Meta: U2FsdGVkX19CBUVZwLm0C9P2jGMMeqTM7H1Yzd+tIPFXXNUfHSJoNHbGlyEzA90QxAG+QokuqYMs5UnXaz2ItRHudxy+eeMNlYP4kwp2xkuCrejopXNxbTEG174g3PXB9pCfigIKBXeULq/1b5CFVi2dZgVK0MORRW/GAWeQjedgBts89YL5JPqvNp6QEL0rxwnfIfbzw8fZ5F8Jqmf96kLl+/VtVh0lrehkJJaV+UD8hxW1lTPg/dtmcAJlw9kHqDD8zqqugtXbxXFayVXXfwRkA1yM23xa7RfSnO5zFWPFoeSsq5svQQs0RbxpWx0HLbecrxam7EcxpSAt52lUxcHv+1GZULimGAMP4yqaA5nbUKErX1UNZGFSi6c0tSbTx27GvcBB9ZZiZJpdGT/IRDQmDvkJM9oGcSA8BV6HcJWx6v+oPt/Kz9IQnXeFYvV+s4+DzTMWCXnRoQfuMuKWjtTPQxnA2BMoZXSu1xRwB2obZ2ZgEyyudlVjOsEj/IZp8r6CbF5tWl8hIbQNA828d0dCiNLvt/dPzYU/+IiGXrgcszevXtbfjthmC62/kXEb6j8wkNbWeAYHpRcSH+k51nJfMWkQe0zKuZ58o61+2M5IMy9i+0a5SrP/3HXSGZ8u0c4XBEZNdkktWbNO8lhmcyQSIDp12TSMdtfowJj8Lb9Ea8IskVOpF6RIXwI4onsOSAwYr6f0NZC2+3C3UabT1Ez84WIAlicQuAdRz76ff7JAzD0VlzfY2/HBF8Oga1wRCFEbgPzSLTCQBfQ5basRNnJ1M9aandtLKNMyV6SQ4ZeSAUGlEXdVYcPX77wGm27sD562gBdIwLlnv7U3ns4aZf8Pp2uJTIeue7P8DJqr9nejaRqANh9lWnphJcKw8L0dXpJKDqly+5UiKSYM8WOXHufu1x2QS4C+9rjRECQFsttwiO8VId4SYv6TpxO+leVoyseVX3aj3LzZY8BKLP0
 F+SmwN7N
 846lhL2gQ/UMZyb5ZoaUOQu37dpIqxjgWDSrPecuu99Pyr2CJN9ITeh69CmGkwFNDkutXqHMBLsC+LpY1fIvgg7UQzrjtUDYo5fcrgGLqKkNbw34hJMHuHL4ZtHLrqIhXDNcKO6xE7JmBfY82qVKS2v5byAM2iA0q2XT6gCql3Yi+B9VrA6iu2wTI2Ozu0joKxDKGYdV26yRN/2REhAliRUafWC4BFXE6uCSZe1GloWWuHVuDKs3JvAomEubXLddiqfr8+kpbfYCDgUzaVwSA5lXhHANSgKKaEsg6wv6wf+vgMVak1wYnHazHY5gLyBkI1r22ohOZEZGLpqTsfOF8tOvxodirz/0TfiKZ69K+9rsm5LIqcG9GkN1XnnomgqAxKIUcpjN0bLpTnyc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 21, 2025 at 4:11=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> On 7/21/25 06:49, Byungchul Park wrote:
> > Hi,
> >
> > I focused on converting the existing APIs accessing ->pp_magic field to
> > page type APIs.  However, yes.  Additional works would better be
> > considered on top like:
> >
> >     1. Adjust how to store and retrieve dma index.  Maybe network guys
> >        can work better on top.
> >
> >     2. Move the sanity check for page pool in mm/page_alloc.c to on fre=
e.
>
> Don't be in a hurry, I've got a branch, but as mentioned before,
> it'll be for-6.18. And there will also be more time for testing.
>
> > This work was inspired by the following link by Pavel:
>
> The idea came from David, let's add
>
> Suggested-by: David Hildenbrand <david@redhat.com>
>
> ...> -
> >   static inline bool netmem_is_pp(netmem_ref netmem)
> >   {
> > -     return (netmem_get_pp_magic(netmem) & PP_MAGIC_MASK) =3D=3D PP_SI=
GNATURE;
> > +     if (netmem_is_net_iov(netmem))
>
> This needs to return false for tx niovs. Seems like all callers are
> gated on ->pp_recycle, so maybe it's fine, but we can at least
> check pp. Mina, you've been checking tx doesn't mix with rx, any
> opinion on that?
>
> Question to net maintainers, can a ->pp_recycle marked skb contain
> not page pool originated pages or a mix?
>

IIRC last I looked at the code ->pp_recycle technically means it could
be a mix. Technically it means "consider this netmem for pp recycling
when the skb is freed." and non-pp netmems don't get recycled to the
pp obviously, because napi_pp_put_page rejects recycling them.


--=20
Thanks,
Mina

