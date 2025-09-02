Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 908FFCA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 11:59:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE4848E000F; Tue,  2 Sep 2025 07:59:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6D6F8E0001; Tue,  2 Sep 2025 07:59:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5C9F8E000F; Tue,  2 Sep 2025 07:59:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C638A8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 07:59:17 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 657E286692
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:59:17 +0000 (UTC)
X-FDA: 83844164754.08.1823755
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf09.hostedemail.com (Postfix) with ESMTP id 85D6E140010
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:59:15 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kZjAahoF;
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756814355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x/rRTNTgDeV7WZN8C7XdtIQtoR+krIiqqTl6aPopePc=;
	b=FoG9uTgUZWltTuCc0uwPcpBHqPdJyo1IsZPCY+b08sm/N7TJb3Q+nrZBr21s+AuMKT5jHV
	bJOyQcPFArai3JU3DXrNuif4KA4mle7ojhz5neHA1iXl2rSslFCVt/pvTXbdyLApiGgmHP
	h3E32TL2rdzVrV55k6JunLOx+Xjlzdc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kZjAahoF;
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756814355; a=rsa-sha256;
	cv=none;
	b=nLzeOrNYbS9vzn1fKcnxrLCkSiXDvq4HY9T09Fu+8R0zzpqwAQfnC+0j4THqGZ9Fg5mudp
	lV6YI4uqpPUYBIBL3+hCqGq1ev0dV3gy6TzKZMDOhw5IbYGr0bCl4gKjaz4+gUZIwCvqzr
	2mTuSqDIvkJLFO+enbgP8I0I5nnEwos=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b00a9989633so548719166b.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 04:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756814354; x=1757419154; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x/rRTNTgDeV7WZN8C7XdtIQtoR+krIiqqTl6aPopePc=;
        b=kZjAahoFx2HmRI7eJX1l/1Yp3obN9TKqUCP/tl9mzU9NJxme4cRfkmxCJTMvRfmPqp
         bENydHDAuwHF0IZR/N6a1xttPX+gQ8N9UxIfdzrW4MnH9TeqLXUnwRa94+wg69CE6X5L
         Wf89PcxcVsdLVkYMYgUJLnMV5aNgEv3JR+89Q0kAMKNs2w8jSyNiPJvEkdUzxZztAXZE
         ykszgq+9WQzkse+85IFDGwayaCPQZXgAo9PQtRRnX71lRWT4j8EioB9m88WJEOY3suyZ
         aXUJKqXWIIgAM3D8XzoCEB08zSg5qgUIUw2P7aALFm7S0PSTTC5QwQzS7E5QRxiU0xXE
         PfxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756814354; x=1757419154;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x/rRTNTgDeV7WZN8C7XdtIQtoR+krIiqqTl6aPopePc=;
        b=nF/a4d4D+jfjJZvI6UhEIUFZx26jYyQ3zc+95V5rdyEIP8+5EfaifIhi055PdYQPRn
         OPa1/KxdQJ1exF0ow659cNOxOwKz84n1awpJxior5BADZp27Wv9t0gbwdG28Tf3Uy/VO
         k+1dfn+R3hteChAh58yjc0uvY6mFjxlaE3nGHd7cb9/uucnoyWn96bIM7XjMpA2WGDXo
         SMbUAEexVYmhCa/xyLyE60lh8zQY71cJdYJN2FdBfOW2W4yKvb5nkqZ8CLM5aHQBAf2L
         8jc2uTMiba9+bFZUHGexbjGsRHKLWjeLbO1b3Brw8YlYe5uVQ2lRSmHxssOsO3+TSU58
         WRSQ==
X-Gm-Message-State: AOJu0YzRHpX1pZDZpsVDf7QcUsCQBjAyJhuB5gDIgXZpAVUBzLIUutSi
	JCz0qGDn2lGrXTzD50M4ISA1stANbBYEDiKhoYUwnBNPn3TWuclDJhgOnzv4+C41KbhHNXB6NXY
	04d4VfmvVo2/y6B30lL+U+8pXBDf/iRA=
X-Gm-Gg: ASbGncvVuF2cd62s53GPjmQnUV2yabij5ZlXAdBECHwnk6s/2lft7zafP9LtE1dTL3i
	W/TyBqT80VZERbh1y0LUPQv+5grVDVzAcHQpYDLmOhlk6seMKv3NAlRMqIrJHZV5Jwpqn1lvjfz
	TmPC2Rbci65/1/wssPzw63x5JNejelxeE5ShQRFUpkgS6Zsv4vW9nX7unVuru443AJ2foUt5VNt
	9Ed5yk6HKKE5uFW1NZlVA==
X-Google-Smtp-Source: AGHT+IH96vNCRDYjRrmA8BrrQLQupz7l9Z3JuWlZeRrzq3CZkEVPsZwF1xPwnw1X52AfWmVbpiXurN+uWD1JeqFq2qY=
X-Received: by 2002:a17:907:940a:b0:afe:159:14b1 with SMTP id
 a640c23a62f3a-b01d8a8b621mr1294060366b.9.1756814353782; Tue, 02 Sep 2025
 04:59:13 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-7-ryncsn@gmail.com>
 <CAGsJ_4yRa65ogB0d90LmtOigGTqQ9mM-eUU6VbmcX63j6vgHEg@mail.gmail.com>
In-Reply-To: <CAGsJ_4yRa65ogB0d90LmtOigGTqQ9mM-eUU6VbmcX63j6vgHEg@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 2 Sep 2025 19:58:37 +0800
X-Gm-Features: Ac12FXzMS08RqhaPgBLjPU1ESc3Sp741JjUDRDBoHqptC_mA9p4mUNoPzbg6dBo
Message-ID: <CAMgjq7A5Gr2V9TDFg=_S+SjZ1r1gWXTtRGNofuzAgWNYLMW_DQ@mail.gmail.com>
Subject: Re: [PATCH 6/9] mm, swap: use the swap table for the swap cache and
 switch API
To: Barry Song <21cnbao@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 85D6E140010
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: hehyqgusnnai583kajqqhbnizfp4asxr
X-HE-Tag: 1756814355-183837
X-HE-Meta: U2FsdGVkX1/q1r2kpHORyGxvwgfbRi1P1O0h/2vbrIhgX+MqmCSHXBAlUidr+dKJfEwu94EzR+o1W5T+cVea2kPnrjSqMBqoYStT/D2X9Gab25HmbecL6bOJhuMwkD/KNU1pqqynDTAFy39nCivTPBwwAwKrNBTy4nStQtV2bTxhFTLS66E+0cPG/j8cpluorwo2YwRCdMPnXVlXABxYn3a3BAfUKpd2qeNKib3RW03Sn33cXiT2cknSC+XGYKSc+aXZQzVSJvnCqDAqZ58/to+5UJr2SnmXL3sVKaZdYl4+syYeaP0BcQKHwoMPGI1fe4Chw7ZcwG150/AJZrhDulSavTD0q0VtrfJNDBLYhuML4UHGey+8eav09Sj//dfLDpqPC9W3k3SCMfgVvZE3VPC4xAUIK2NQBtOtyNnbCZsE2ynovB0lLouevft9/z8mXoqIbx3WtiO+OLEdYnztc1BZOm9nCFg/W62Q0suYLxcUpiN5ZXBv7GBMftry1t6pYN2eIdPSSU4aHqYgXOpN4vA6VjZ4qYhnrSerDL5vIbPqtSY9qpfdeBOdxa32SaE82bY36mS8GdJIXk+pR7KgJmtKp1CrNc47XGz5fJX6VwsWoif7x9XaOv01que0EoCWgyV+/aQOTCviNhLFioirF24NnewCsdqNy9W/oXuVqkLbscitblB0ykhgIggh5aeEAnwqjHFaa16dbQkLErNc/3Q+JPSnbVMSQg/auB7K5Ad72jcnY/4s09whuBnHEfMYuG7Hcp8pH6ZnJc16HlILmabiYVb6P2Dlxg/AksJTHKPb+3BTvB2zpNJWgpQmMIFp3kp3KGWl9f6l05H180K5/E3uD4SEK/FdMBL9dTfSPpauuoIJC4Dv68QVlAxdqPN2yIQ6jZFd9+BkNJLUc/g+FrvcvwF8WGvLbhHQ51t+iwpQVeycP6UDa2taJ4F9iAavM6PcY77wpx0wL4h/Q+G
 j2NMAbNg
 Y7maj5vmR0jjPSY0w5+Qa55k7i/ufmuB5vALEuxkImXVV+liG2p5XXF2l2Owiw6CxLTxKdFTaj36y9JCXPNrSBxo4N9+rHZUwc5zyMsHrj3FLQFnE8n8LN2N7KCWsPjEOnN2yJx+kbkYCLbah0Tc8SOxTQ/E2H6cQgyJx1bxPNknp8/la2LdVyX89r/N1py4DGWgllW19eUL1rHZc5RdNaE0ZBRbZ6kndITI1AYwTpBefXWiipXPk+mIrviU2D219ZZ4XxQRq2+6KYKxa82Me3fq8IY+urcUtus3Y9ipBccQz0xuCku2jDahofD674lsxMGP6aB98YAaS5Op7qmYtu3evdIadQvzDRVxd01nZS+G9daRo0HNriAv+P4HrMiuDBVRcQR0mapqgyu8DvOhBjOXTEQDvDS25rScL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 2, 2025 at 6:46=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrote=
:
>
> > +
> > +/*
> > + * Helpers for accessing or modifying the swap table of a cluster,
> > + * the swap cluster must be locked.
> > + */
> > +static inline void __swap_table_set(struct swap_cluster_info *ci,
> > +                                   unsigned int off, unsigned long swp=
_tb)
> > +{
> > +       VM_WARN_ON_ONCE(off >=3D SWAPFILE_CLUSTER);
> > +       atomic_long_set(&ci->table[off], swp_tb);
> > +}
> > +
> > +static inline unsigned long __swap_table_get(struct swap_cluster_info =
*ci,
> > +                                            unsigned int off)
> > +{
> > +       VM_WARN_ON_ONCE(off >=3D SWAPFILE_CLUSTER);
> > +       return atomic_long_read(&ci->table[off]);
> > +}
> > +
>
> Why should this use atomic_long instead of just WRITE_ONCE and
> READ_ONCE?

Hi Barry,

That's a very good question. There are multiple reasons: I wanted to
wrap all access to the swap table to ensure there is no non-atomic
access, since it's almost always wrong to read a folio or shadow value
non-atomically from it. And users should never access swap tables
directly without the wrapper helpers. And in another reply, as Chris
suggested, we can use atomic operations to catch potential issues
easily too.

And most importantly, later phases can make use of things like
atomic_cmpxchg as a fast path to update the swap count of a swap
entry. That's a bit hard to explain for now, short summary is the swap
table will be using a single atomic for both count and folio tracking,
and we'll clean up the folio workflow with swap, so it should be
possible to get an final consistency of swap count by simply locking
the folio, and doing atomic_cmpxchg on swap table with folio locked
will be safe.

For now using atomic doesn't bring any overhead or complexity, only
make it easier to implement other code. So I think it should be good.

>
> Thanks
> Barry
>

