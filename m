Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCFBECA0FF0
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 02:38:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 281448E0002; Fri, 29 Aug 2025 22:38:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 259008E0001; Fri, 29 Aug 2025 22:38:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1960E8E0002; Fri, 29 Aug 2025 22:38:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 069EB8E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 22:38:46 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7EF331A096C
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 02:38:45 +0000 (UTC)
X-FDA: 83831865810.16.E3372F1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6B0B718000D
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 02:38:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EwITjDox;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756521523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q5z13N84mNtXbB052nFNkQiE1/2lg68HKsEcCvAsNyo=;
	b=P2eALTjIU0TMpvKlF5PV4AOvcIiXBhx8Cf+A9V7cU+YBuie0SGPi04RjEKw2nHnAcQPC3M
	Wt2wOKOcBDqZIDbW65f3Mg2ElQKnQ4cZq8BSNQoVX3yHYVlBd2P5nqWYQ38HQazwARBe9F
	gSSveowQeoNn/O8YVWD/MCM62i1fFTw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EwITjDox;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756521523; a=rsa-sha256;
	cv=none;
	b=hGjFTnc0/dQeZx6v5RuQofwfnitmMdVx7W7m3PzLDx3xXDqf2ARQEUBP9CoT3SrS0kLhE8
	KIlcxLQ9Ml4q7NlDq7txOWgNXyLXmkqpcbPd3dEMPcvEPcyzSj0U7+zVjwOLd14ZZPWf06
	kzb7B7lNRBmrGNfKRgJKkmytbZFFc8Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5BCE3407F3
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 02:38:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C47C4CEF4
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 02:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756521522;
	bh=+p2n4tlZXGaHynIlVJt3ZHWklmLb2NN8iFLRK8WKrfE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=EwITjDoxrM3rp7no35oPvdgmrP1ln2hZRFOawv6iBrhmW0++wNPgbxSuietZjXCrk
	 t9i/I3uWcJf0JdWaF0B9ATrRX4JHIEFC6RlQYS8frnmQaDGdlXS8MY4G+bT3e7nPwY
	 EodzG7n8aHnfhqTxsoYLjvXrN0DIxvJoTNe6rvwPXP+6n736JJa8o3uYZb2VV6+GGE
	 fmAZg49g9m4IUBJzqestbiM+A65GHmqDH/PIjsIkx2KWnQWS49GjScTKXHpcU8C1Qw
	 YPXx5Yt/SOwzG90CFsxk5EbmZ8oxLMuN+KSDUi85LXXlGgXzyL8iJSTmkcWlkykslv
	 Lj9mgBAmukF5w==
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-72019872530so24982987b3.1
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:38:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWMI4l6WC6c/lPCcmyM9kQu2RKx+aAIsd7FTulPmgvTSDEFrLAGtf+BIcM3ZCKtTn7A6FR1jHVQYQ==@kvack.org
X-Gm-Message-State: AOJu0Yy/8gftuwPXyZsDiMf/fcfoH3Hn0dhCDfAtCHLSLJ011TB72+gu
	uigFsmyl053fM2lLSGouwE625m8FgOXvwwBrb7QAqpTk7yNoZA6aDEvG/py/6PvJQfi9AS9xmfo
	YVzq9j1uEU9Oe9pRZH83ryMuUFB51g2WqQxPjhdi9Kg==
X-Google-Smtp-Source: AGHT+IGuBuSwsjhHFtUTKA74QyYXEtkfLGe4VoSYAhkXUSo9fI0UtL8SW/S4muEUQSA+uavvttIEfu1Uod6PEcZakOM=
X-Received: by 2002:a05:690c:6812:b0:721:69f6:d403 with SMTP id
 00721157ae682-7227635732dmr9024847b3.11.1756521521562; Fri, 29 Aug 2025
 19:38:41 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-5-ryncsn@gmail.com>
 <aK5/1so7a0i80+dz@MiWiFi-R3L-srv> <CACePvbU8pnjWCiWcSXRr4UdpuD_wdtrouLMz_fNB_=KRrdHLmQ@mail.gmail.com>
 <aK+YzeWToVUX3WOY@MiWiFi-R3L-srv>
In-Reply-To: <aK+YzeWToVUX3WOY@MiWiFi-R3L-srv>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 29 Aug 2025 19:38:30 -0700
X-Gmail-Original-Message-ID: <CACePvbWX+snaDv9rJKfVe69QDo11ZwHQwuzd8Y8dJ8bS3ZJVEA@mail.gmail.com>
X-Gm-Features: Ac12FXzygJ_nskFfLZf5V2ThWdnbwEO8i2QJvMzIYPH7zqT-9-D6M15Imx23neQ
Message-ID: <CACePvbWX+snaDv9rJKfVe69QDo11ZwHQwuzd8Y8dJ8bS3ZJVEA@mail.gmail.com>
Subject: Re: [PATCH 4/9] mm, swap: tidy up swap device and cluster info helpers
To: Baoquan He <bhe@redhat.com>
Cc: Kairui Song <kasong@tencent.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6B0B718000D
X-Stat-Signature: cq33x177zz4pwnwjzhfcnhoitpf7t5wb
X-Rspam-User: 
X-HE-Tag: 1756521523-157469
X-HE-Meta: U2FsdGVkX1/FgQhJJtxpJzYPZ7KYSaGGHFUhm7Zsj8N/rJAz/6teFS5PIvmSAEndS0NAcQ3K/t6ip8QZK53AzG8SRgbcBQh2m/SXGvP4YFKuIKMpx71AAF5q8CV9zEC0LWXhbEqCp32GDQoUy5gb92YH8cGKWLk/dk68eb1LTpoWbRfVusH8iezsO5/+LpDqQYNZVPnvbo/pTFfxyONTSMXxpd5x5ltGimXr6Wm0WYkAv86rh0GnsbEq6HxxhApVKn3yUSkmDJlI3vVoupNycb+gf8AsmVQ/wkdh69kTxIVrlPnY/jlqF26xWXbltKtI6Oj7+IJG7GbQ1OUcv60Fccvtyzt3jOLCtUqR8k2KDsqw9sVMzcvzczBrWW8FiFxsL83J7WPT+bhKbfE3bHSvRuslnKd+rcUk9sAALWhofz/jtAwW4vuHlBdAhYOpL8nFYYsxkoVxAEMGQakJeVhpgpCngsVRKcXyKXKzhud9URMl/iQP9szIV79VmEr5rVecrR7BxerDQ+mMy9ZZoRN0IgWd8pPZHqJnbPx2xWy/Z3eG/qVpwsA2F6HyI3ixtEt3fSfDEekM/3OOIR9iidfxCBJbo7j3IOis2RXIskiRyuZj9IGddrCJqDvM4iM9w1IuEV22I1pxbXvKOsBMKq1IkHYqMYrI1JlPMJRi2ln0vzLWUDuwu4Uay1lfidz0LoSKr35wLPJFIXffnzS/nVwtJikpYB749tfaNN4siI5DjHtQg7t6ke+qGsNDECUHTQAQatTya+5s+nIOuWn8D9sWAYKgoucYSz4ODRB13NlpMFyoV3XSj0EDwu1R9ugEbqgQhaEpkUzAwnEl00s9fLxoLY7ZIBafcXJiYQzv6gbOPoE0UqUSQfNVUTQESLQ1oA9Cbdbc/S7Sn/qydfuwWxjlah1WeikpLl7yuQQizy8NDtdVE+MldUOu+IjxNkBVmqJJTiG2sH/nRH2u0N1et/p
 wyEV0Ar2
 /xjb65kr/Mi4WvY2cI1hsSkLlkeoFk8ObuMQKuc11TsZt9KIkyha/iz2OkPJ/Jx/V9sjLMUszHrQhcGZJeUEsgWaYPgayjSKnuEnMOXa5UZ0D99XWroL54N2X/EeO0gXJB/C14SwqHV7ThYjD1ngjNBTSjdjSgEFiw1ytrZgpI4GNfCn/2bAwakX6f7QjTaWORKvTXmPPZeijo9cmuTxSeuuvSJUmJ9Yl+9y3qDss6dowsA4bEdNVE+9P+Pza898a87CrZPDSqS/cYL8eVUrbXXaDGBAZtrRlH/Gzt2+Wk4KquqdyIK70JfZKgRXgMynREFKzucpioFb2Il8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 4:46=E2=80=AFPM Baoquan He <bhe@redhat.com> wrote:
>
> On 08/27/25 at 10:44am, Chris Li wrote:
> > On Tue, Aug 26, 2025 at 8:47=E2=80=AFPM Baoquan He <bhe@redhat.com> wro=
te:
> > >
> > > On 08/23/25 at 03:20am, Kairui Song wrote:
> > > ......
> > > > diff --git a/mm/swap.h b/mm/swap.h
> > > > index 223b40f2d37e..7b3efaa51624 100644
> > > > --- a/mm/swap.h
> > > > +++ b/mm/swap.h
> > > > @@ -15,6 +15,8 @@ extern int page_cluster;
> > > >  #define swap_entry_order(order)      0
> > > >  #endif
> > > >
> > > > +extern struct swap_info_struct *swap_info[];
> > > > +
> > > >  /*
> > > >   * We use this to track usage of a cluster. A cluster is a block o=
f swap disk
> > > >   * space with SWAPFILE_CLUSTER pages long and naturally aligns in =
disk. All
> > > > @@ -53,9 +55,28 @@ enum swap_cluster_flags {
> > > >  #include <linux/swapops.h> /* for swp_offset */
> > > >  #include <linux/blk_types.h> /* for bio_end_io_t */
> > > >
> > > > +/*
> > > > + * Callers of all swp_* helpers here must ensure the entry is vali=
d, and
> > > > + * pin the swap device by reference or in other ways.
> > > > + */
> > > > +static inline struct swap_info_struct *swp_type_info(int type)
> > > > +{
> > > > +     struct swap_info_struct *si;
> > > > +
> > > > +     si =3D READ_ONCE(swap_info[type]); /* rcu_dereference() */
> > > > +     VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with=
 swapoff */
> > > > +     return si;
> > > > +}
> > > > +
> > > > +static inline struct swap_info_struct *swp_info(swp_entry_t entry)
> > > > +{
> > > > +     return swp_type_info(swp_type(entry));
> > > > +}
> > >
> > > swp_type_info() is only used by swp_info() in the whole series, can w=
e
> > > open code it in swp_info()?
> >
> > BTW, off topic here. I really don't like the "_info" suffix. Anything
> > you can put into a C struct by definition is some kind of information.
> > Same to the _struct. Anything defined by a struct is a struct. Don't
> > need to say that.
> > The "struct swap_info_struct" gets two of the unnecessary words. It
> > should be something like  "struct swap_file" or "struct swap_device".
> > Renaming it is too invasive to the code base and it will mess up the
> > git annotation history.
>
> I agree. I searched for _info_struct in the current code, only found
> swap_info_struct, ax25_info_struct, vm86plus_info_struct. The latter two
> are seen in very few LOC. Maybe we can rename it later when things are al=
l
> done. And 'struct swap_cluster_info' too.

Agree but might impact Kairui's later part of the patch series. Let's
wait until things stabilize a bit.

Again, no functional change patches are easier to review.

Acked-by: Chris Li <chrisl@kernel.org>

Chris

