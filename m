Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 752B0CA0FFF
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:03:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A5338E004D; Mon,  1 Sep 2025 11:02:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47C2E8E001F; Mon,  1 Sep 2025 11:02:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05CFC8E004D; Mon,  1 Sep 2025 11:02:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E3E068E001F
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:02:56 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8E5295A2B6
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:02:56 +0000 (UTC)
X-FDA: 83840998752.17.3AF5E5E
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5086640018
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:02:54 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=YtFGIUwV;
	spf=pass (imf17.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756738974; a=rsa-sha256;
	cv=none;
	b=trRMAqJaEk4MRTV95Q5QAjAzv8GPzVBUuSRoysq83HkwN381jTsYN9D0P4jcYTjkNTJ6x/
	NMEJre6+FN8e1oxy300XNvgKMFolOgivU7vjFdKUcG+AMFxc7+aCNdUy5BKcrcOwTqsHnh
	c5PYIUvnnD0zHA44EqQMaFFSCzIl+C8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=YtFGIUwV;
	spf=pass (imf17.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756738974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VGz5s3CgG5oZbwfB15yu/ysF7dSGyM9kka20nq6+kjg=;
	b=ROuylxjMpod2MPf5haCRVBWYvqRG4jrlCcIRu28juFggzcbTjr/TGl5BI6njisauxwWZAt
	edZDRSNaF80J0aJvIXAc0nqQgXSCrVsnhtSKy1sQYnkw3OHx35lWPnlZW1TVWtFh+l8boh
	92JiPwoqfL/Y3A23k8gammQOhM1o2Wk=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-afcb78ead12so723436366b.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 08:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756738973; x=1757343773; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VGz5s3CgG5oZbwfB15yu/ysF7dSGyM9kka20nq6+kjg=;
        b=YtFGIUwVozgKhYKap+9qR5B4h/NAPtE8ViIO2OLa2iEahP+7I00liHApKYMIPi/vd2
         +cFOzQ69QRYfj511fSVz20SQvpUO58JlZeDHLSpNZOjBVU7hcL+DuukKNARUphVTvuuY
         wK+JtgIrGNnSbrWYclzVnopPu+LTYpi4Gfvymoj2Qd4INSxTr3GhRL0XyvtOI96T1ymv
         ucNEs90OuK5YeniCrXSPHk2ZRYRuGF6W5E0nkLInewLCccysuoXexTKm17qgnzu41HVo
         O+BNY1HtUA8cQB1dTYhIHaR4h4N/cYj4Q2zbE0E3dGerszt6RbkU/PJOFMmWpMS6ZTrq
         tO2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756738973; x=1757343773;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VGz5s3CgG5oZbwfB15yu/ysF7dSGyM9kka20nq6+kjg=;
        b=CCWgDbrWJRHBTfaqizClnjabyEZhTIgTFxAftA5BiInBO+zbKLYQtwZD3ShHAgpxw5
         CjRhYmJcMF69wPkkH8qv/NBfb0jqawn0Q28vr/AENtybqBK9DBv48CMsPKOMA5A7Ddx/
         bgPG49j3OugfMbXDJ4QfKomhWDQH1Dnz6kqro0xo18LRulyv3RfOndPw8q4eC/E1251z
         VB67htDWngZjJaCCZWnN7Lk4wljvWAon2dnZLXFb1PiYPxjtwzBSCjAhRXeq7WAuqx00
         WnvAkSKvmpbKV44sOOQbRfv23k1wkmYPMysPOJZ8ZWwKuPVyFFoLvxhX1o3+8W3h/Glm
         H2hQ==
X-Forwarded-Encrypted: i=1; AJvYcCVlx1XDwXqK7Ch9Hp0U/Wf1qKvDGUFr/dkYMWC0YoZaBZWqIEk43BWXI1CUHTfuenHitG+uOpflXQ==@kvack.org
X-Gm-Message-State: AOJu0YzjjwFWwZrUfSlMWRs50CYJxkMul8iaiFBbuqabIvCSl4kzT9Iw
	2uJ8s98lURUZ+YyjzYFmVUSXCH88+H6mMK2p6Dz1mxcsU29ataaXuNPjUHKHJwQCeNDAlhkgwDu
	7YwMuQpSRY+KW94rMUM+gVMAfPKQn5VnQjAspT5hCXQ==
X-Gm-Gg: ASbGncsWdHCvfQTCgb05uzpTWe4D30OAEpFWfGMp9nKU2rSVYVjOcTXoDtn6WpblnKo
	8MI1gcteuQdJT7xiMmLN9Rgma+Rz03h3PAzY6U8GZGvZ+sVgllmaqXtEycvA/smiBSRqvA+M1H1
	uhRx24r0F/GLcRaeCvbv8JVKgjYvEMJ/FSSKS9OFBmhnuAaPfs2de+UTNAKDuLu26jCWSMWQtnq
	UCelBUggI1urm+0q3a1zbTZXLVxdnzceYo=
X-Google-Smtp-Source: AGHT+IFezK1h8zD4ulbO+LoYFx9UJvceg5e5MjfORD1cX6aK9EX6zhmOpTUVOQiq+Ui4qjbP7WefWWIq7O/4+eTMSZU=
X-Received: by 2002:a17:907:3d42:b0:aff:d39:e350 with SMTP id
 a640c23a62f3a-b01d8a25c91mr803197066b.3.1756738972529; Mon, 01 Sep 2025
 08:02:52 -0700 (PDT)
MIME-Version: 1.0
References: <20250901123028.3383461-1-max.kellermann@ionos.com>
 <20250901123028.3383461-7-max.kellermann@ionos.com> <ce720df8-cdf2-492a-9eeb-e7b643bffa91@redhat.com>
In-Reply-To: <ce720df8-cdf2-492a-9eeb-e7b643bffa91@redhat.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Mon, 1 Sep 2025 17:02:41 +0200
X-Gm-Features: Ac12FXwscizWLWhMN1KX5yHTr-lGd0ZaL5gCF07LzPcgk8nWDqkiCbWTaVe_QQY
Message-ID: <CAKPOu+-_E6qKmRo8UXg+5wy9fACX5JHwqjV6uou6aueA_Y7iRA@mail.gmail.com>
Subject: Re: [PATCH v5 06/12] mm, s390: constify mapping related test
 functions for improved const-correctness
To: David Hildenbrand <david@redhat.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com, 
	willy@infradead.org, hughd@google.com, mhocko@suse.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	vishal.moola@gmail.com, linux@armlinux.org.uk, 
	James.Bottomley@hansenpartnership.com, deller@gmx.de, agordeev@linux.ibm.com, 
	gerald.schaefer@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, 
	borntraeger@linux.ibm.com, svens@linux.ibm.com, davem@davemloft.net, 
	andreas@gaisler.com, dave.hansen@linux.intel.com, luto@kernel.org, 
	peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	x86@kernel.org, hpa@zytor.com, chris@zankel.net, jcmvbkbc@gmail.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, weixugc@google.com, 
	baolin.wang@linux.alibaba.com, rientjes@google.com, shakeel.butt@linux.dev, 
	thuth@redhat.com, broonie@kernel.org, osalvador@suse.de, jfalempe@redhat.com, 
	mpe@ellerman.id.au, nysal@linux.ibm.com, linux-arm-kernel@lists.infradead.org, 
	linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org, 
	sparclinux@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5086640018
X-Stat-Signature: a1t4bqnqs1nm9yxe358sffjzs8pxtkk9
X-Rspam-User: 
X-HE-Tag: 1756738974-545515
X-HE-Meta: U2FsdGVkX18diBHMD62mEKIO0bejqgSjJl1HlKCXH/56qmRT4lR19a0LViklP3VdWSuffaipyW53+PSFFaO59wgAhqMXVdIYM3/Td/tmAksccN18wgglLR6i4xqE+u8Nvfp5v64KzTRXG1KGVrK3n8R/fA773LZ2JzdNGKlIaybAQRciJ8hqhA074cqKFmFlxFwCdFs9RViYapONjHdt1VsHtloSvj/+L9oOkvgUPvKkrP/8PhCiLix1qAw6s3IIeAFDl4CW3TeLs0xpCXLpob/REq72TNqvyGBPSwPzZyXBjjoAlUQQ5kpdFSM/PjW4ybYa7VqHJTexUaoo78d3jleBiRs/jiILRW6fJjF7kGoMLqRAhK9vKo/FutfqAmXS7qaKx79xwunTbLHMGsr/Z4CGI3JwngNhtBtPNWoyoZnbQZLhZgbjf5hJgv4j3CoASZlnnREN220tjJk3sRj8eqwfZl7+DteTFxYNyaMUg/IrtoaHDya8aqQD6omTgolJe5aol8LejnNYDLZ93peRbGJyqDKyy+YdKerPYygC7cXXYmVzEetkYnZ956771PUkTsGxM2rfc6N51XGSagUCLt9WtqcdcFv2j/WzXaJ0F0Bwo7YdlC1n4aYs9jfE5EArGcOSOc3nMAdTGK+aRrnBCaQUsfBj6Hbipi2SsIlSvzXcaY5x+TuyGv3yjyGikLdA0cNMDVthA3du7njxJg259UGABjiThgCHGIYYtMAZomuwB7G9MjhSu7jJK8MLS0wPjHwMJziOZ3XFRE4dQGBEaRdbHZeSa53PhpeZTWILyU6UrBEsdoVakpGN/mFOrALt9oitvSRdQ1P2kU8s3Xt2JA885Noyd/9l/iqeFSoiRm1eRDIxCiawAaSDWenn3EXpmTg0ChqaMB/daAfzICA3foIZMPHuxCSudNyVtiNW6/sEnyLnGMBeBV4nmJaCqOw00AEWRQvkJJ84cglbhUV
 oTpezVKn
 aE/rBAvJNKiK+NiNLpyqepM6VyHQBnmBwVGbaLWvlD1xxECoFTFA2Z3H9N6WQGgZbGHYFEn1sDANWliLARGI0xfSQUyri5WFb6z5eGwT0DOCT7jDA9d3kHtKb33GbAwG3AM2736bITGG6C80PAcPHqhLP5yerk6Qe2vCAByCTFgw77yK233QhESClSeA32yfsAORHMQFhPwXU7GOxbVx+QbYKkkXBAuBcgkdOV+npRdcyvi54YRZNLCExWcwGElLrLdBCbsql6RNsCmuQMbxRRt1dTA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 1, 2025 at 3:54=E2=80=AFPM David Hildenbrand <david@redhat.com>=
 wrote:
> > -int vma_is_stack_for_current(struct vm_area_struct *vma);
> > +int vma_is_stack_for_current(const struct vm_area_struct *vma);
>
> Should this also be *const ?

No. These are function protoypes. A "const" on a parameter value
(pointer address, not pointed-to memory) makes no sense on a
prototype.

