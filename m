Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30488C44501
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 23:28:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13AB26B0005; Thu,  9 Jul 2026 19:28:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EA396B008A; Thu,  9 Jul 2026 19:28:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0001F6B008C; Thu,  9 Jul 2026 19:28:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D37E66B0005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 19:28:23 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5CB228D175
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 23:28:23 +0000 (UTC)
X-FDA: 84970829286.20.F62C4CA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8AB0420007
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 23:28:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XyeVMPlK;
	spf=pass (imf03.hostedemail.com: domain of linkinjeon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=linkinjeon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783639701;
	b=YYCx6mHmwoCZ/p6nGNkDJLUHLjh1HQmpu6G4FK2Qflf99FwoWnTOTL5yApPELW7aqXXSY3
	G6eJ4vdVXiCev11UEU/Nqw860HKqZswGr4a7LEpS/BUMQWNbQ6VeTEyZDoQpYgo/QfL81U
	D9Cv0uP+fIlDWtKuFcDNqCjhlove3aE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XyeVMPlK;
	spf=pass (imf03.hostedemail.com: domain of linkinjeon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=linkinjeon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783639701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VnEWDzkpJDdab93DctjKcy+iRl+tSdMUNcz4cbIL01E=;
	b=8j2i9qfvIw8D/NrNmpZ48QuADEMRnhmUG/Dg2enK7rvfxw7Mc5Xmy5l2VoeVIB8WRXyfgE
	Un3hSnNfIAUQk55VZrsmpI0fW03m65hdi3qjl3P3LtvJJDT1mDp6/jMooTySODDo3NcktR
	Nd+84GldyazfXg/QzW+Z+ituWYqo8XI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8656E44FAD
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 23:28:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 658891F00ACA
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 23:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783639700;
	bh=VnEWDzkpJDdab93DctjKcy+iRl+tSdMUNcz4cbIL01E=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=XyeVMPlKK+2ugMiNqAcqW0DSUaYretY0munWCo3/pMbU4eh+dv32pLdg4L7k+2hDT
	 ETTSBND7LpIilZ1eZ9AT0zxb6CkwiZADjcw4Q1ybxM/1wAqfsAx7jdiax3UrJnV2o3
	 6JqUJW2H+9dMGNUbe3OXAWZIcaG7dEekZf40UaLUWlj9+blhiVeICMes40BPL+CKxr
	 s3TvKvmexvw2XIJEQRHfgWcqwdRYuvXp4YggIu+v1R6HpAG2X1owoKwcsMuMDsdreI
	 GCe6unNy9Tpx1/XhTLiv6nVbzwc2Amv6BjO9J29BRq//RMhuBfHKuoAXGHucF4Wofq
	 DFlYUPD6fKjug==
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6986578d8c0so437402a12.1
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 16:28:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RokQ2EQ07yHispxsQ+Zz4jhuSlnu7u5Hd+qyXzDsDKXlfZxo75YEGYAf9NFnPHaJ8qJt9/q/9W8ww==@kvack.org
X-Gm-Message-State: AOJu0Ywt7lLz7DwG5E59pBvVvCqzHE8XHavFk0O6rxOxJQ4U0OpdcmqP
	tMvo5qGzqXPfSM9ctwyffAOaaXU1f0zL9eL/+9ZTsnZCapUfzD+GUS2lu+l1BFCrtkLjnRefyiX
	IvFRmI/zonlSAUJnv+tGmse9WfApX4Fg=
X-Received: by 2002:a17:907:1c2a:b0:c15:da6a:c27c with SMTP id
 a640c23a62f3a-c15da6ac90emr301540266b.25.1783639698946; Thu, 09 Jul 2026
 16:28:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260608210618.3437216-1-willy@infradead.org> <20260608210618.3437216-3-willy@infradead.org>
 <CANFS6bYc5uSSYWvwJZ4BgjzF0_bO9rkcFNvX2vVHnzWDi3kpuw@mail.gmail.com> <CANFS6bZZN6455QLhPE=yYi5fAHMt+MuqumtW6BCg__pESLiLaQ@mail.gmail.com>
In-Reply-To: <CANFS6bZZN6455QLhPE=yYi5fAHMt+MuqumtW6BCg__pESLiLaQ@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 10 Jul 2026 08:28:05 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8qPHHNrDkJ29NwR7NrOj7Ny05vRPKzjUPckC870ULeRA@mail.gmail.com>
X-Gm-Features: AUfX_myErJ-4JtqUD5YjlzwNbj0oPPyCpuzOLKwO5B11tKGPbSGvpJAOIzk-OyQ
Message-ID: <CAKYAXd8qPHHNrDkJ29NwR7NrOj7Ny05vRPKzjUPckC870ULeRA@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] ntfs: Remove use of __folio_index in handle_bounds_compressed_page()
To: Hyunchul Lee <hyc.lee@gmail.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, usama.arif@linux.dev, 
	lance.yang@linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8AB0420007
X-Stat-Signature: 5hmbsczeft5nxf65ph69kyud8a3z78i3
X-HE-Tag: 1783639701-582912
X-HE-Meta: U2FsdGVkX1+jnySE3r7HqvTOK01bSDTQuHyI9Olit5PZmjqfUBkbVCKq74DAwKOX6WRObXSkPU33Qhgkq5fBFEONyGt1dvB5TScChY32x1KTq+w2kvvjtPeXxwA67aSq8xS0Gk/yei/hWQxkPgENeVIANJHp3sTSweWaKbXHJNrcVARPYx4EIuI5+Awg3SBVjEFgRS8v74M6YKnMMYAIg88L2VEiZjebM8Ozu/tVfmD9ogtzZpCUdXxHMZv1ygCIefH2nRqY/p1bFX9+xygtMD4tvY8V2z98VCqsXsMbbF87s2/BIio/T3Z7JlkgJ1yMGlBa/xoheXdfpI8AmFhxfv5ufDqKaS5eQlC3PLMsVEJHlhQC2XAgnmStNZ6vYWpF6TZbqNWtY5ySsw1M6LoJw4+rZ0kTnLcD8nwBOsZ4FFNmYUmfHhPBJRHwKJdt2iPAmQPyY5n6QwSYMiFXRXaU2OUccCxPeQUvZqbVIOOx4vJk0qjXvF156HuN4NvrJTgkCR2JelPs5ddo7u2rntHMJVl5DBk/k52GMFiXwCTLHRmERCNam5MtXAEsGwoo6uPxzwLjIuHVLY0PgopDuqAfWllh503uKkeDnzH+KbZL1slWyQjhtOE+lQPJc0oTH7EdLcgYqodP6N8Cjw6Vjs0JUtz3QTOySSe+iB7EI2jKtLH+NmTUCiSRAs/c5Mo8yOqssNRZIjIXlQAUfKH2ExgbxnGfqQiN1BvNqETbBbACz6CMatm+Sk5GWkXS1CpeF2WKCoEWcR0EkM/6uMVC1yCcs3+tiG/yzAKDuxFnhwxhxVwcw0pCY0kCSy2hndcsDO4pCZj6fiFG5fw5AxMaTkjo9XuxG2zkGieGHKqCDdz63QqHPWU3nPFJ9ceRdnn+fjoj1Mqgialn0TXM6DHpqTCxmqHsesFoxFJ06xhg71vw4tL/0n3PtMazRly3EMz2mgynDu90cTeX90ImkW3xl8Q
 MxP4WiO6
 b4np/P5deV9+iDQ1orudJDDzvTyl4/nXhwgWA5yB02RUUYFQWAfwn3Re+mZKLCxIDABnbGQ5UaZoDbjjqP/SYm8Fru2Ax/nUhcoEi4meLOtD9vtbh3Byd+p47yQ9xBytBVJQNBdjSgDwRIjtVvUauCjvxwraLdAyyqPIfK8lE90t7+zNSIeBL25I9Y9InVrZ2itSStt15OSgMTJXT83+yOcMTLm7LwKjQP8NXZaRptWOS5ca/ciTRSekRhKO+PSw4a98t0v+PCXJTn4TCTQILhT8dO+1lR3GhKcWeTvM518cDJu322+Kywf42LaNI413Qa+eDSIaJfEqUkMG7iZGV2Wx8Xt79m/07PKBqNZeZ4ntgFpqoOe5dUr21mOlVlJ5R81g5j1CkxdIMPeyqIgzxNWzX1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > > diff --git a/fs/ntfs/compress.c b/fs/ntfs/compress.c
> > > index c904858dff3d..b279f38636d6 100644
> > > --- a/fs/ntfs/compress.c
> > > +++ b/fs/ntfs/compress.c
> > > @@ -105,13 +105,14 @@ void free_compression_buffers(void)
> > >  static inline void handle_bounds_compressed_page(struct page *page,
> > >                 const loff_t i_size, const s64 initialized_size)
> > >  {
> > > -       if ((page->__folio_index >= (initialized_size >> PAGE_SHIFT)) &&
> > > -                       (initialized_size < i_size)) {
> > > +       loff_t pos = page_offset(page);
> > > +
> > > +       if ((pos >= initialized_size) && (initialized_size < i_size)) {
> >
> > I think the following change would address the review comments for
> > this patch and patch 3/6.
> >
>
> Would you mind if I continue working on this series?
> I would fix the above if-condition and add Co-developed-by for my changes.
>
> Please let me know if that's okay with you.
Could you please provide the updated ntfs patches so I can apply them
to the ntfs tree?
Thanks.

