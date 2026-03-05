Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B4A1F47CAC
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 18:31:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 803DA6B0005; Thu,  5 Mar 2026 13:31:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DB5B6B0089; Thu,  5 Mar 2026 13:31:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B0596B008A; Thu,  5 Mar 2026 13:31:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C1266B0005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 13:31:08 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DCFF5139E08
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 18:31:07 +0000 (UTC)
X-FDA: 84512851374.17.1953A2F
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf27.hostedemail.com (Postfix) with ESMTP id D00B340019
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 18:31:05 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S2Bczv0V;
	spf=pass (imf27.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772735465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=louF0VYT3jVATcdfkHl6P9eqPKqMc0Xl0Ev8Gw/VyXM=;
	b=bUF3n47+fGDfVaDNkf1VAD1mrejzP46GG+Aq4pfxObrTTPAj6Q7c0qS5iQejq1VvUks1q/
	BgU/sAAg1CLpNFGeYGZGN5EPEyfA/TM+FbDW1MsDeIx6uWGVBYrElA8bM/4wvANqN2L/vp
	2dJB2xQUsl15ZjXHmK6EJeKB0rR6J4c=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772735465; a=rsa-sha256;
	cv=pass;
	b=Gs19tHJSaojqdvxcNS4P5eDLK5RdwpxWqTrLrf9ITMmNa6WQt6AefadPDAgK97jQQi93Xz
	ey03YFfmKY4Ldh8UWrLThAwuAmvKck8ceh0ZQtg2ZOrpMKDZmOGnH9C5Glf4h3nrLwPmkC
	Ks4zzxg3qle0OQXiVuGEi3BCB5Ro3Ug=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S2Bczv0V;
	spf=pass (imf27.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-79852e01cd1so3750797b3.0
        for <linux-mm@kvack.org>; Thu, 05 Mar 2026 10:31:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772735465; cv=none;
        d=google.com; s=arc-20240605;
        b=iQMnLsPpznpyOO75+4C+yRakNlsR1N/JnzWot+optn1kXmbu6UFhw6mB6a3SnPPLGU
         xGaTvIB8VmWe4pmrEkJJyokE88um2KvBUs3g7fgo7rmU4ZPot1TTbfqY5iMahDlx6W8k
         ietOqjcsC84l0jgbPsGPYmu1svYyrdm2y/a6OOo5jlQjyspfPfbskBsvmfzG/dDgykmI
         E28kqI26dz6YtD1zpUqkTCLXxpm0m47iCFe5e/Dk4B1wr3zqy7b2tetd7E1mj+4Hqb6W
         tZj45Nrhca5cAmEfSbGIGi1d8XYxnhCEPeu3m+bNbsJN+QcOV0tIkYZBD1vLH8fDEuUN
         F63A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=louF0VYT3jVATcdfkHl6P9eqPKqMc0Xl0Ev8Gw/VyXM=;
        fh=lqqgDE7kV2x60USvIgTQ3R0pu/HCfApDWbLa4zMVoMg=;
        b=boTYRab+E1PxtmG9tHkRW66IEhLL0dhhH2CNN6JPOskw9c0bJqiAm7rz+jvcExnQ1n
         GHYCRcOlYZJdTq6ypdOaYtbQl3UJFxB2YwZX+U0+ixQaDMf9grwJbglka+Zxn3mNTRUR
         hYSZB2tB7geUNVDe6sw2mXOjScp3z7Asxb7xALMzBo9mTupJII7sJybVXDum3GN8wJa2
         mbS5EbVqK+UxXs3A3ykxoXsiy6YshAp74CZcu2RF1pMcvbxzo/0nwwglax+/9QWkcDlr
         LQqI1irAkTYNnlL7rtDxoXbruBSFVvGseemvQAmUneWYIlQ2u8oA9ASzgMr/aTv8Kpyr
         woeg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772735465; x=1773340265; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=louF0VYT3jVATcdfkHl6P9eqPKqMc0Xl0Ev8Gw/VyXM=;
        b=S2Bczv0V3PWBwkkyyKukMRvYanwsGnL2c/bhXGIO19F0nfK2ujyHU6yo3zKV6k65NQ
         +xyccu92wH7Zf6VwlCcyr7NlY5qIIiBZyDckVyqkShglOYkkiBTZVlqus0JC5Mh84hPw
         J6XVMnsmMGJMtEKHkFhk3JUD/Sjrqk1gTdajqdyXvPtYqycqR9jUEq1kxZb+DYjB17Sr
         uaKMhK2EK5HDI+SHoYMN5N3/SYVazz/wPWwVsv7NmQ3fJN5hRVTAj84D975uSGBD1hZt
         1YjfCyiOYmXjLMQc7aYtM7RYNaMqqATgeM90g+o8zhMMvi5klCfOPSnRqJBF2HzGgUI7
         JaqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772735465; x=1773340265;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=louF0VYT3jVATcdfkHl6P9eqPKqMc0Xl0Ev8Gw/VyXM=;
        b=KRjZ6BCeg4/uJa+XUuJtNLHD2ibXraZgo/m1BzG3hL3mD01amtoV9mcafmc/KGLF1x
         M0zBVf5A/9leCXVALKlXHhoF9GkcrGKmLIcdF4uV5zt2YTQmiFuR6y83+FcT02atJ1+B
         ADcukR0PNeVzsRWwK9mLlUzzprc2LQvqySSqOAShXcEbt612WWLPE32Ur2sFd/SAHFat
         2ynBVUSUkR5oU0ScVdGJ8hjH2mkIXT7/4PrLe1jepK7wwXPXlVLJZFV6A4Mz8PBKGotk
         IZm6cpxoIBZ6350Jhj61T1Lf8hakq2IG5c7C2H5iWhiQzZS/J2cDo4XXxX5JrYRZqzj5
         ppcw==
X-Gm-Message-State: AOJu0YwmGpMsd6qqXwE/lQZ78Hj0qwGnKamkA/wEH/9rXiMg/BSZEdRG
	o90Qsw4g2BeEyUE9YPi+M8Dg42wXkXQVCRvHxuTJvs5dJAZQHSVgtOf51txuYAHEJUkcms73LGX
	e//VJKy1F3tAPNuNI83oFBKJS3E79sFw=
X-Gm-Gg: ATEYQzxq8CkydgdJdGSpfYktUzqg5/OwrtGM6OwXxQkolPlmqPw6MbYLiLPRiAh2hNn
	boJuShgVApscQ8OOqAx8Hr7P+ukuJz7w3kr7nr14JIS8DvJ1YJtUmhQBfzfhzzLzlLAyUtIwocg
	cjhXTRXobbahZPK9gnNr03yWSDZaI2yt+qRbYyiXfAnvFhzZdQi+0AfoQx7uF89c7epCtxQ49r5
	ton2L1gecpOTea/1gEGq8fyEylNSbm+tO6DK2q4BHEZ1m0iUKcNYTOIfGc/tXhCW6b0NEVOoM7+
	UmHOxg==
X-Received: by 2002:a05:690c:113:b0:794:ce39:c63a with SMTP id
 00721157ae682-798c6b7f74bmr47076567b3.2.1772735464762; Thu, 05 Mar 2026
 10:31:04 -0800 (PST)
Received: from 95991385052 named unknown by gmailapi.google.com with HTTPREST;
 Thu, 5 Mar 2026 12:31:04 -0600
Received: from 95991385052 named unknown by gmailapi.google.com with HTTPREST;
 Thu, 5 Mar 2026 12:31:03 -0600
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <2f9135c7866c6e0d06e960993b8a5674a9ebc7ec.1771938394.git.ritesh.list@gmail.com>
References: <2f9135c7866c6e0d06e960993b8a5674a9ebc7ec.1771938394.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Date: Thu, 5 Mar 2026 12:31:03 -0600
X-Gm-Features: AaiRm52GZ13axMWytXPAWQiFZUnqLmaKbYqKRkeisNV1Nap28ZH-9coEHa7p224
Message-ID: <CAPAsAGxB6RGSYzMq=tjQQmEDu3QP+v_AqmkbWTRyqkk+K35o-w@mail.gmail.com>
Subject: Re: [PATCH v2] mm/kasan: Fix double free for kasan pXds
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, kasan-dev@googlegroups.com
Cc: linux-mm@kvack.org, Alexander Potapenko <glider@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, linuxppc-dev@lists.ozlabs.org, 
	stable@vger.kernel.org, Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: ifoogin4uc6acpuqg4tam4skoe46k1qz
X-Rspam-User: 
X-Rspamd-Queue-Id: D00B340019
X-Rspamd-Server: rspam12
X-HE-Tag: 1772735465-609143
X-HE-Meta: U2FsdGVkX19iQgUCIGCgg+SEJRvrN1SlNtK6tpbxc6MkD4a/6WEhzB57vLv4j83Vb+4ro1wwla22fS1d1nhFOmio7z1Kp26Q65t2e7seaEi3keLbRQ0a/Z9rnoL0oHg1mXnNjpAHxqTmCUDdXYfZQ8wYKUgsik3FIoJbtmN91TlQHFXRGUINMHYH7ODhIZwttUkuUEpMv/1qxxc67lPot8TzNILcNKcEr7w9Qi2FGLpyi8x1XvVJQUB3xUuCpcPzT7rztfEgL1PogxknJAjM3y2+Q9j+QKQKDgDjCfO5o+6OtzRtUY+cm1XV5nHSY0AnjneGMIfBhYHZ1TsRgXEFde2DRllLzUnao1BFPPkU+M0zsHQYJ8atkfFCseJo8o3s1/vbooW3ZZ16MgOchQvcaPpLYeo0WgNEKBSN/cX1jvTbrgFwj7bG3NXHdA0U2j/dL5pK4YAhZPYJIELRXsFrfRnUwlJUugrRJeJNlTyXT64t++zVTo66O4UE8/TJjy6ftBBedInHavKEQmOg9LXlm0Rx/TyRirUxnj93yWSndiI0CGyF8n6Yuc15nIYiV76Pf1WB4wR6catbt6HOfeMj3Q0aUWbCdC9n8M1Au8XA4lYJ58GWFN0vPgbbzyaxdcF7V+B8YsnL9edHQZ6MhSiwEvTxxxTGJQI7guQXCMYTIdBj2harUX+ShLD36mpBAW8MgPPbsOX4BS50uUwdPv2kYmJIgG/A/PtRrljJzHTfr7s7gVL8vsjVND1fpnNur3GwpvNgxhOLxCRolV+aDuGEacXxxCqoE4lzau27GSh3B+RY+dbeilupHjGPxjN3qfrHnr1+B93f6SFvkzlI+Z4CSW+SR1XY8lFHVSfdWFH8PrYJ4Ro0D86ouTVaHDYmDY89b6qy9wYjwKYEE7fdpBhzRZgaZUJzq30ZQU+ygFRNVOADHefw2iYecJHjNEJoy7DQ7BM/0uR6/Sfd6VURp+y
 78lulD/3
 1oUV7ZcZQ2cH+TXqWTfCVXPQLR0P+I+OvVQ3SYvxYqBILXVu6JyY1uM7Us1LGocE40m1212jMH+aFi9f4ho7mhRnA1CuqU+H47ZTtb2+ShZU5zSx12YAf6mRmT1ckL0pcCfmQpdMdg+C6C+HvQN9oMqK+0dMo2mcTzMTVBMI8iQo78AalpNk7Axed58yh8p8Qdbx5PT4FDh4RD6UnX3VMTnl6vTzHtpaHeJ5wj4XFEgP9blpFC4msFTO9v/yz5rQNYQHhMStUGCiwnzvZ11IZO94mK1Ra3tF6ab0qefcrLOr0CdsDaAu10AN3Cv1W0TmyW0DEZ4HLiQ8wtid07GMXEIAwf0p7XRNUS2UMMeZWFSO/OqYUpghUqm29amGaQAxGG4KVD2z91owCE4j6xt3ZpI9n4kAHJ3IQviuerzr4cfxaqTEeD2uJFoYjo9SyQZfc9L+OLc2vghSQKrWG2Z/a6XTIN2MykP8VYycR42y5fyu+64BMHyqEJVbZNasX4WgN9sIx6LFkKb7IzVgTGCe2WUDBpJ3JygeFlvwN0IQL3I6IxDJXS59j9r3nUXO7ib0YZWOEXBUfYSLweiH8eYu16BWkTZEOtXd84Rly
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Ritesh Harjani (IBM)" <ritesh.list@gmail.com> writes:

> kasan_free_pxd() assumes the page table is always struct page aligned.
> But that's not always the case for all architectures. E.g. In case of
> powerpc with 64K pagesize, PUD table (of size 4096) comes from slab
> cache named pgtable-2^9. Hence instead of page_to_virt(pxd_page()) let's
> just directly pass the start of the pxd table which is passed as the 1st
> argument.
>
> This fixes the below double free kasan issue seen with PMEM:
>
> radix-mmu: Mapped 0x0000047d10000000-0x0000047f90000000 with 2.00 MiB pages
> ==================================================================
> BUG: KASAN: double-free in kasan_remove_zero_shadow+0x9c4/0xa20
...
>
> Fixes: 0207df4fa1a8 ("kernel/memremap, kasan: make ZONE_DEVICE with work with KASAN")
> Cc: stable@vger.kernel.org
> Reported-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
>

Reviewed-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>

