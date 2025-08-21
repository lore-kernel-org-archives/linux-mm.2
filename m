Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F36FECA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 10:28:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A1868E0011; Thu, 21 Aug 2025 06:28:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7794C8E0003; Thu, 21 Aug 2025 06:28:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B6508E0011; Thu, 21 Aug 2025 06:28:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5A4088E0003
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 06:28:06 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 14BCD160357
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 10:28:06 +0000 (UTC)
X-FDA: 83800389372.14.8BC6443
Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3A0B420002
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 10:28:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IqElPzE5;
	spf=pass (imf13.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.50 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755772084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ELnpUP80gM/anqPaD6FJUI5nOkHoieYS5dIGUYiXjKs=;
	b=gtMRmLplenz+49SkyoNoXfTY3qNiYLYQyxlFI+w7vpJpWs2ID6GUpawAxkcJ2WZaKuxt0A
	EzMm45j7l4FdukMvCiysJ3f7Eumk/cMw6ISjNW/rqceV1Vv1gWi7PVor457ntNO5v7ipRR
	poxU1CfEBLVOo2/99i+oi1vv4rn5SyM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IqElPzE5;
	spf=pass (imf13.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.50 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755772084; a=rsa-sha256;
	cv=none;
	b=hAInFyEcaQWCU2UYaAhNYqkE7+tGsxrFb7wXdFCuH7SyEqsZYWgVRXLwWxrcBzd7NKefiO
	iaXD7Zx4gmLAtwBrzfZrH6vJSacN5SjajZRV1xrQJOty9q7ZnAvm1fSDD7cDttOwtzN42x
	i4xvpodDRPE7fFkVupgz4HNY9oer6gg=
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-8902ee514deso591433241.1
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 03:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755772083; x=1756376883; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ELnpUP80gM/anqPaD6FJUI5nOkHoieYS5dIGUYiXjKs=;
        b=IqElPzE5V9AWKF9wiQV0Awb80tE/rh3uM1oYZkNKL83EDc6NFSjXnTx/FLjGsgU6qF
         +2jH2arEywW/WCXd4f8XMdG/4OmCzfCsTy89AFFoqKmJcp+k/Jy0GeWEd0jD5zYgEEoe
         YjeUtB3sTFWTv4H48QL8ykOIx08onYXAnb3cYa5etE4EJYDUqpwQqa8ZklGTUr4Aq6jp
         bQXAGcz6LVI0FbtQRL2nYqc81igMJL7owFrt0h2MCW5gsrgShmYmLc+8Qi3/WW4pQxxQ
         bnGFqB4Dt05AKMKhz32Za0xGRjbdq4bocBhJsPIswBhhaBcJ1in2wX5haHHdrC0e/Fr6
         DWXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755772083; x=1756376883;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ELnpUP80gM/anqPaD6FJUI5nOkHoieYS5dIGUYiXjKs=;
        b=JIkzBzgLuNZuy2qCJS5K4/eBuVPac53UJTj03+/JBORoxRbHNDtP6SVxoRcrJTXqpK
         TRhgdp/dqTmpN2tCpaRvqVFjV/r3LwvaHeeXXMdeuyGz/rCzW/hU9aYxjpPgBx3ZHKzn
         vJku/wqZxtd9u0BdnXhaQs+u0tBz+Ik4TlnlVjlsdwMAwl+lZfaU8w4idZQj6pwqovTZ
         vZWvPFlUXwVKzVTTza0lRRqZ7bFosy1DCOLMcsp2s6OUn8OPbubsupGfcxPBTrVPssoW
         6wmtMYrKwrd0iGqTZwpmfRk15EMTC9FpiJv1nnDtXdSFphq6FICuUAFezaUjU5MkZIvg
         +Wqg==
X-Forwarded-Encrypted: i=1; AJvYcCXAS7vC0eCrVBOufbLFHhxKYssh+TBpcUi7G/lzlL0VXF4OIzXKx52+zgmTnhh8gvPQmUSCELGaew==@kvack.org
X-Gm-Message-State: AOJu0Yyv4NYxbcoerrOktUM6hnypFBvStfFSWYrcDUllSKOFGew7Nh7p
	qu502o1ua4qrcAHg4kJdUCfR/KWmqmMb0tsMTkTT5fmXax+DK6b+efqlzqGaKZJVa4DYcQaqS5n
	gsrVNvJJISHDQpPtm6HCVtsEyj5DsSbs=
X-Gm-Gg: ASbGncvDycutzXN8yfLbh64RTcEabwDmTYq9pAxsj+pe0kJg3OvN40IlTei+EMNQbLY
	BCyLd31uVhQZx/TN7gmgqUHtRkhPZBVhvvWWmtC4KvFSeIpkOw/LitGbZFF/9tmpI3Ydgsctoxz
	UpmVbYrCFhdLqOA/Zw8GL8qGhAzApLM2Dka7MOhidMcd5IqhyEpdlGVZaNDzc820zDoyOKIcpq7
	aV669I0WVjcsN4Prg==
X-Google-Smtp-Source: AGHT+IGhsHZhpGrX5u3RwtmYG2F9aPC/LyvWwHX9lVj48ZQXQI8Kte0gM2HpALra1byLLMV/IG1fu6eUGcDQRg787Jo=
X-Received: by 2002:a05:6102:54a8:b0:508:c145:4150 with SMTP id
 ada2fe7eead31-51be7c58738mr464375137.4.1755772083184; Thu, 21 Aug 2025
 03:28:03 -0700 (PDT)
MIME-Version: 1.0
References: <20250819193404.46680-1-sj@kernel.org> <CAGsJ_4ygTv1tCJeuF43NhRR4E0kiMLpk6i8c+UHoUMt6LXykww@mail.gmail.com>
 <aKUi7hvcaK0h0oMg@gondor.apana.org.au> <CAGsJ_4z6YvQULrEmNjFjLNrJ4RK6w0+d9uF2-7v06gOYirrYRw@mail.gmail.com>
 <aKUmyl5gUFCdXGn-@gondor.apana.org.au> <CAKEwX=P9T315JcOBOBGK21Zk8XyDruMTv_XEPa0CuD=oAN2QYQ@mail.gmail.com>
In-Reply-To: <CAKEwX=P9T315JcOBOBGK21Zk8XyDruMTv_XEPa0CuD=oAN2QYQ@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 21 Aug 2025 18:27:52 +0800
X-Gm-Features: Ac12FXxHrOX-eRoJHXmtuhny6Df4zWfM_2k3KeDK1nAUUmvXOdnwHKvu18ASyck
Message-ID: <CAGsJ_4yLDLvOZ2=3iVcQhu2jnbWQ+iTQsqVefJsx4_YT4bnEZg@mail.gmail.com>
Subject: Re: [PATCH v4] mm/zswap: store <PAGE_SIZE compression failed page as-is
To: Nhat Pham <nphamcs@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, SeongJae Park <sj@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, kernel-team@meta.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Takero Funaki <flintglass@gmail.com>, David Hildenbrand <david@redhat.com>, Baoquan He <bhe@redhat.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3A0B420002
X-Stat-Signature: pfyijs6x8x8q9tpw84qsacb5r8dsqr5a
X-Rspam-User: 
X-HE-Tag: 1755772084-506994
X-HE-Meta: U2FsdGVkX1/7f+fDRGX5iNU+kOlP5NHywoWktn1MpwGDK+c9mNzkvNbWMRtFoIgVIhujb/C+3+6Mr2mqqw+++lX3eN5fG0gl2QM/dzu4NjIwa7KuldFbDj+JK9EIqq4JJOMuKq4qIZC9TP+Yzy8Le+MN+VWcBfJy2sPdOolvCl5uJQV9J9Mq724rNgF04WDPPGZAwxXvmSG64e/SDY7CE/zSb6BCiugY39GGQw9jposT85FL8xOc/F0evSg1Y3hDkGKE9REcEPKn5jx/f0YsKQo51YubC1G3M7uFEYYC/Hsfi0M5mx5gPBr5mrM7QnTV6IFDfflpz2/bgCU8pUeu8r5iUyFzS63ypt5NloFdSceqgcvOCJ7JEbP6UZ7z5BXNlqtgt6urqRcXp+QoKhdPsKdlilTUhbp8Ci0MV7ZtSJ4qVTZ2DTpFdKd1uD0Bh3zi6kkMsSuXqTcYvzcS4ddcx7wwVmvFlUTVnSmG05dnGcRn91rf9uFeBjY1eypOLKmOgD1ck+PgIZouzdP7gwbIztopAkZo71Gvb8vtkm302xtcRuiR9TW8IScDbdpCgdCQOgT/Wnrx+8iwQwj9plZhv/S1s/J7MOkTIqyQ1ltxKM6D7jniDiq7mHffhuEcTzbAroZIOJPlIbFCZO+LrFc7OMFyvx425fX8sBjfXXCIKvLitfa4xZbflMg3YC4wJT3Aj8xvpzSsmkUoGZVlcphQhJ4h7W2o7U/pO+rTScFMDs3hcMuvfa7/sDqcvBX852xnE4FQx6h6/DZUJrxIMuC3u2FDGDQe4LnrXU8KiK9WtW9TEH6kz9tHRajyxLVMHEhtv7ZhAasfwN2+rHLLz4C8WuBAUWFe1NCRiVNfRTe/Yi8w6rLtfh5hYkYVCPxZOfoN2p66DOFOgGOm+EnfMmbpOog1dBoJRSfOcq892nQjsPcIDydBdboocMNzB6MIEgqxflse8SIyBb2tpXCYUwY
 WxvY0jPz
 CUDKWxGIHfD6RBkNuq/g9RGvsrtu4VJHrA2+2qn7y0j8iAsKE8eGAVRWjGx3HytAXJ6vWnu69Cg9kBa8t/6XgNozVt3DIwbHxONieJ4LgN8uyTi9HYvI3InLnwGi4FFX2IlwOo5YyqQ6LSc/uUI+UZhLouwOJZ/bY19w67/RKsUfLPdRq1IUicvrQXR33pEC1OfGkoOdBG1qDM6fD8QdSYxQBJo7bLAECbkvPsyQao7TAH0YSoRY+w+rwzumyJCFuTA5iv1a3T0Vxsc1H+o8925UgxqK8ogFxe3UZ4Vor33UwiZoECZbiIDo/N3atJqv+2FDDn9ZZnxYzaPZ5VkjlgvUpfFnNn5PLq27j+oLAuP29M/DpOzdc6C6dpNEKQ37e3LH1HrN4+evWRBdQUPGN1zZB53b278AqwbLn+q98oyYfh2lcm8DcFr5pr1lKmJgeMvBvCU5HSh2gk0lmbMkjL44xFjmszDYV/Q2eHUrNXKk3jEg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 1:33=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Tue, Aug 19, 2025 at 6:37=E2=80=AFPM Herbert Xu <herbert@gondor.apana.=
org.au> wrote:
> >
> > On Wed, Aug 20, 2025 at 01:34:01PM +1200, Barry Song wrote:
> > >
> > > We might want to revisit the old thread to check whether it is now sa=
fe for us
> > > to move to PAGE_SIZE in zswap now.
> >
> > It's perfectly safe as LZO was fixed months ago.
>
> Perfect. Then I'll revive Chengming's patch (see [1]) to reduce the
> compression buffer :)

Nice!

But perhaps we should wait until SeongJae sends a new version that
addresses the counter issue? Also, I noticed the following code may
have problems with the patch:

        if (comp_ret =3D=3D -ENOSPC || alloc_ret =3D=3D -ENOSPC)
                zswap_reject_compress_poor++;

Can we still reach the code comp_ret =3D=3D -ENOSPC since we already
handled comp_ret by ...

+       if (comp_ret || !dlen) {
+               zswap_crypto_compress_fail++;
+               dlen =3D PAGE_SIZE;
+       }
+       if (dlen >=3D PAGE_SIZE) {
+               if (!mem_cgroup_zswap_writeback_enabled(
+                                       folio_memcg(page_folio(page)))) {
+                       comp_ret =3D -EINVAL;
+                       goto unlock;
+               }
+               comp_ret =3D 0;
+               dlen =3D PAGE_SIZE;
+               dst =3D kmap_local_page(page);
+       }

Thanks
Barry

