Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D406EC61DE4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 05:49:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEA936B00C3; Tue,  1 Sep 2026 01:49:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9BC76B00CA; Tue,  1 Sep 2026 01:49:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB1E96B00CC; Tue,  1 Sep 2026 01:49:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B9ACB6B00C3
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 01:49:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4EE7B1402A6
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:49:44 +0000 (UTC)
X-FDA: 85164116688.12.A867691
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4A36B40008
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:49:42 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="iOm5pX/1";
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788241782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uYLfDNhDWWaiAca3YsvDlwUL0hP6uL2nUvfLd7YMwqo=;
	b=kRCW+LZo4d5VNqDNsIpjuDikwgAIlVgKDUgjsokJs0vbHijOimvMTY4GpUmALFU6GZOpmi
	wmh+30DWxLX9/AuDnu7QIt+aWgj7Dt/sohwX0L3vYou3qmYmzVwlZy9s2X+Y/pjNipiGN/
	GI207fHNksWnSTa3u3G45722XMhV/os=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788241782;
	b=AaaKv0tMq7R1hmk7qvt9wtHn6b4pfdSOgMa4xqgRnty1ITdVSfp4+MsFFBKAoDj4Q+dDkF
	hgF16CA37sp4fu/A0nYXqaZqeW7R0BkSPhfBhKaYyDN4twYUjPapHYkZHWtLF7UMIsx7NV
	1StHhD+4dsoUBuSszVkQ3rGN8hK4sfM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="iOm5pX/1";
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 75EE1408F2
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:49:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 597D61F000E9
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788241781;
	bh=uYLfDNhDWWaiAca3YsvDlwUL0hP6uL2nUvfLd7YMwqo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=iOm5pX/1JGT6og1tC01LvrFRUmLHS7UcCU2wNRh7rtdA1z6kBAI35mPLBXTVnvbwz
	 QWJ9MMaiWFzlxIF8ATKVzHRFvJuk/Nx+3qXfaFTyrN4tXTmQr74moa68szFvMvP0hx
	 IKGR2NpY00zyXCUXlgtcaV5BXFY7pCG95YWIK6IhV3gO+FXbGnYNkIE4CSfAAFEvqO
	 Es5U/sJfI5Hyn8bmoFseqphvnlEEdxgPFd1VtKi8kTHuNKRAp+twjL2mqWhtqwqkQq
	 fy78I6TyxUtPefMB0H0NUXjPiIfk6bvKx3Cw9kQz80iYenhGULtMt/6f/90a61Bp7z
	 XWm+Fx0FDf7dg==
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-930f618435cso382064085a.3
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 22:49:41 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RosAKwpynv96HkpcPhxovFpGvjqbEsgI4ZeuXdjDyZfVZt7+fvlTh8G83YbOUAwgEVwzKeN8BdPhw==@kvack.org
X-Gm-Message-State: AFuF++mC3X1BnbJRS4SX0HS+f061LyPB+XB4dr4kuC0ZJz4KzMzooQU1
	+z+OSJV+b2aTQWL2eQQRi9ypghhH94UogWNIaGOH5GwEKUWlavfDTCagKcVf1Vq3Sdrpt3XJzrm
	dOJEclevMIqLIlkuz4Ln9YoN6D5RkL68=
X-Received: by 2002:a05:620a:72c1:20b0:939:124c:b7d8 with SMTP id
 af79cd13be357-93913799c53mr2764427185a.18.1788241780772; Mon, 31 Aug 2026
 22:49:40 -0700 (PDT)
MIME-Version: 1.0
References: <20260901054358.4049095-1-dev.jain@arm.com> <20260901054358.4049095-4-dev.jain@arm.com>
In-Reply-To: <20260901054358.4049095-4-dev.jain@arm.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 1 Sep 2026 13:49:29 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yGFBRv-C3UV-G1tB0HUmhVvJL6ac5x_Dtu9NSGk9BGzw@mail.gmail.com>
X-Gm-Features: AcwNN1WUPeFIq5gB7k0X198Ne-gqn5RAagtInfIzkUUme2aYxDr3aJIXcRpjR3o
Message-ID: <CAGsJ_4yGFBRv-C3UV-G1tB0HUmhVvJL6ac5x_Dtu9NSGk9BGzw@mail.gmail.com>
Subject: Re: [PATCH v2 3/8] mm: move anon-exclusive batch helper to mm.h
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	hughd@google.com, chrisl@kernel.org, kasong@tencent.com, riel@surriel.com, 
	liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com, 
	lance.yang@linux.dev, baolin.wang@linux.alibaba.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, 
	youngjun.park@lge.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, pfalcato@suse.de, 
	ryan.roberts@arm.com, anshuman.khandual@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4A36B40008
X-Stat-Signature: 7tiuyidi7mphcwwpzomnua8j41qzxm9n
X-HE-Tag: 1788241782-85210
X-HE-Meta: U2FsdGVkX18S5G67/wCnJbZSVEg4/s/iWZZ36JY8TgVLdRCPwfe5dfeANpBEr38g51UaS9zh88DdzeHFIX/esw+/nP3FUHAnL32vFErn81UCUv2k/0IYQDU/NU0gEuU7BlDkkH9ZPTDOivAxe+mcC1OrafNPFlKt0wrrtcvnOATiiorYRnntda1cFE3xxccsMjWbOgj1s2Wv6jTHnIqhEOHJfZDr9g+lzmQASPAd4AnUrDB+UtxXArssoJZerjLxz71w7zHbH8pRvjB4Yo1gNU46NDkBHe49kOJ4lFN1ayBsuTpc4thI7i3s5L4itC2okQ6OLbmzljBngyItJLehqf1Jt7Edf5zQP2jaVmyfKEesjLEtXyYJN5ZbCcJKcf+fnOWaPOgwUktYFfsiNXCRaD01tG8G6vhZwhv61gqbtWqj92Ff1DoDGRY8+EThThMGNG/xi0pAqdKxb+HCkcywTquvv3q+ZgBRw8ju41iBdSz4Tjv5Zm+RC8bXzcgZdhJs9hGCjxJZ/5itjafMO4ovxMMq7lEacn16DxYqeKrlD8qHQsn1OwV1iCDVLkG1tbAt0TrUKbwYR2rK0vGI/g1NkzSMmwf+oGE3XOWzhbVvhVyXk+RxP331NaL9SFQ3goNWpvVtxy2WGL80Y/XRFzvXaaY4E0+a4Ru3FlSZZ/VYlVzdvdFsT6Sa6Ph+jaTKIZQIjWK8umTNKZ5twc3TCk64rJOuKOeJbg1qW2BSGq2wO3r6cfLaY3+iIszfmWJhZ+QnWe1tda0s+vTj0pKGHDbnRkXIBaLMtSShdhwJ4hCBqtJVuPecpOZIpQLKLz1yaxeIEsQk9jcYDCkP3Jo5+IxOHrUaA/oP+1uSKmtZkJDA7yY/oOCbuutbcXUSpv4qKq78TBrtC00QuDIFX3RJFjovmw52jX1OYOPwu4EwQ8K0zKvgHuEz0M62eOuMG1iBeTD+MYYQyCP/HFP2RGbzCAq
 U3bn/cYT
 pg/MQ5Uu1X1PabVXeqtwfA7GDAdA4BXloZ+r9Us2b4PviwmQxi8rIrz1r053Q060u7S55KLWIicKPRbVukYA2W6u7pR6C81bMp2yMprA2kNa/qTU3Qm03+HiNIriKdh4QLDANwOm3TpKsHypfRLPKSWEW+mZJhWsVR6ZuFZGcUugYSA3SMRULswn75+QXT6rJQoPdXUcajJG6aBF306DHuvn+qYFNRRZCihJXoaGha8L57RN4/Bv2eHKRSOubTTwz04vfV4OHauXlw43bGm0PqgICTretocXNgssJOolrumYZo7D0I8dltxyudxJBPwJYISHJ+CBVoVO6Xd/N+YDtHtbwxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 1, 2026 at 1:44=E2=80=AFPM Dev Jain <dev.jain@arm.com> wrote:
>
> In preparation for optimizing large folio unmapping, we need to reuse
> the page_anon_exclusive_batch helper in rmap.c and rmap.h and obey the
> existing use in mprotect.c .
>
> Therefore, move it from mprotect.c to mm.h. Gate with CONFIG_MMU since
> both rmap and mprotect users are built only for CONFIG_MMU.
>
> While at it, change start_idx and max_len to unsigned long type for
> future proofing against THP support at >=3D PUD level. Also shorten
> expected_anon_exclusive -> anon_exclusive.
>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  include/linux/mm.h | 19 +++++++++++++++++++
>  mm/mprotect.c      | 17 -----------------
>  2 files changed, 19 insertions(+), 17 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index dd09c438fa23e..63da8813bc5df 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -244,6 +244,25 @@ static inline unsigned long folio_page_idx(const str=
uct folio *folio,
>         return page - &folio->page;
>  }
>
> +#ifdef CONFIG_MMU
> +/*
> + * Get max length of consecutive PTEs pointing to PageAnonExclusive() pa=
ges or
> + * !PageAnonExclusive() pages, starting from start_idx. Caller must enfo=
rce
> + * that the PTEs point to consecutive pages of the same anon large folio=
.
> + */
> +static __always_inline int page_anon_exclusive_batch(unsigned long start=
_idx,
> +               unsigned long max_len, struct page *first_page, bool anon=
_exclusive)
> +{
> +       int idx;
> +
> +       for (idx =3D start_idx + 1; idx < start_idx + max_len; ++idx) {
> +               if (anon_exclusive !=3D PageAnonExclusive(first_page + id=
x))
> +                       break;
> +       }
> +       return idx - start_idx;
> +}
> +#endif
> +

Hi Dev,

I really don't want everything to become a top-level header
file. If these are only mm-internal things, could we move them
to mm/internal.h or another more appropriate header?

Best Regards
Barry

