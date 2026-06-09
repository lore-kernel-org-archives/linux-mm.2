Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2BD2CD8CA4
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 10:02:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC8106B00A1; Tue,  9 Jun 2026 06:02:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E513F6B00A4; Tue,  9 Jun 2026 06:02:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D405C6B00A6; Tue,  9 Jun 2026 06:02:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BECEF6B00A1
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 06:02:50 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 66E02C1E46
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:02:50 +0000 (UTC)
X-FDA: 84859935300.14.D35B42D
Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	by imf28.hostedemail.com (Postfix) with ESMTP id 59C5FC0004
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:02:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	spf=pass (imf28.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.221.181 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780999368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J/QDHCd1pzNPKIKT6XsNCXh/My/ujozGgvsOiDCA3LA=;
	b=I+O9MZMwGIPwPpWbl0nPYkO6IGzGopdZQqZ8+gt45wlDcTNhKPPk2eWE8bGPRKnEIKhjOm
	d+tpizTKlVtDer1UjCx0xPsZua6TrGW7obauKsetHtIwqBxHVDxLRUQSMsTZXTwG9eZhvM
	qYFdYGOVoDJ4yEzi6mG4yfdl81ThCqc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.221.181 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780999368;
	b=W1OEjvN2GEZ/sHJRCetwb6qyUdjnDquATPe5FYEZBajzPRhgYAToKzKvpshooMpMI5aQYw
	k205E7UrmmdD88xNdeenixw2Y451au3ieyCJyP3D4mosxlWNdLL5CpM+TtVpqUrSpnE0bp
	Or1R4EK3yPEHBlIFyx2qdWvmhEoaADs=
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-5b22b023e1dso1442336e0c.2
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 03:02:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780999367; x=1781604167;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J/QDHCd1pzNPKIKT6XsNCXh/My/ujozGgvsOiDCA3LA=;
        b=JkiG6WaALv2lggTJ8GG1/WlNjfHi7igIa96/2EZk9+AmDIktm1ctNnUH+LGPRq/A+1
         cGyR6JVPxVMcsm6ivlR9YVbT6AN9O0/xNQjvmULRcax+1V5jJ5QAJClIc+kNpv6dvVr3
         CK2y/z7ATE2EvZEzDZjZNramghvE1eEF2uA1JatuG9808GgvZXXH7mIC1eh77reGP8Kl
         RDeC/IhEyNL0xDkTAEjQ/6AZ5PJm4EpwHeCKiuJ+Jfhedwjmx+jAOFBDI7PM93+V1T3w
         06K7bpZF6OJc8tasX1ZCLvlIVGqBTso1rmk54HtVZZI1mMvXMtt4zpzJWOoe0CTKiFU2
         X4sw==
X-Forwarded-Encrypted: i=1; AFNElJ/httpMZaG4o/kdfD2H/4qxRox1Sh62AEyPfnFM2STxWTPZ202ZNPnh26NIQ7BSwlKqMWRfQhMD/Q==@kvack.org
X-Gm-Message-State: AOJu0YyGYGUgiC94hWra/FuVsSUSkXgovZhJOn3mohbX6agpVnBIAIBK
	fnpug/HPapvkkBJcpNSGX+0u2tV4/wK/BvCzRE+vPiO864aIeu09cjjs8ZLp7Ulo+AQ=
X-Gm-Gg: Acq92OEB7viripT5Zx1tJ9EntqS5zwvF7eADX4aVMk9zfPr+yKiGqS9LKZw7dcWzPKk
	bLZnGbCU0R1lg3P5uSvmz4KFtQnZ6X/00wr1dYuslGtTBYOjXNfSHJw0zrYGsTZKDFa9oMqb5P1
	0k53eOIePSUklo7FbqANyjWah26Y04oKtzXIKHBltkxntb8VztK+OVC1C1BWDSdhKRFnwILRwrN
	b0Ff+mJz/+AYzONU8pWzoVXzfXWs90DzFr5gIIypLwQl52qSWjzgm1xv+Ugup6VXy/q4g4LYKgR
	M46xJsbIFp9txwoO7+nzNQLrpgiV8BXXmejCyi/AEgDxw9ILAPd3EcF3lcavWPaS60C5vrBvm6+
	h+xzPjID9oOwIlfkotAFpNljM5JJKtwvllB/oBtF84IoMKrrtBQyoKmChEnKa+eDVoulTY1EGIo
	SP5ntiIxVbTOVHNAuDHA9NclZfQ73hbwEaPiGpoQXuJ6vHuHhfUXPoTvuSjHOHKP3+lPDqGYE=
X-Received: by 2002:a05:6122:2090:b0:56f:a329:6859 with SMTP id 71dfb90a1353d-5ac50601612mr9721217e0c.7.1780999367186;
        Tue, 09 Jun 2026 03:02:47 -0700 (PDT)
Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com. [209.85.222.54])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5a6d6413983sm16204679e0c.1.2026.06.09.03.02.44
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jun 2026 03:02:45 -0700 (PDT)
Received: by mail-ua1-f54.google.com with SMTP id a1e0cc1a2514c-963b248ef0fso2477998241.2
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 03:02:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8kJvxmo834VMploPPeiHUpU7xW5tdqQ7oqnJma66c/l6NElQ0SnFxxoCSsyOo/jPOVLadNEkxwsg==@kvack.org
X-Received: by 2002:a05:6102:149a:b0:636:984a:1e5d with SMTP id
 ada2fe7eead31-6fef05f052fmr11135049137.11.1780998924802; Tue, 09 Jun 2026
 02:55:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260529150150.1670604-17-ardb+git@google.com>
 <20260529150150.1670604-32-ardb+git@google.com> <CGME20260609062840eucas1p1d49831bfdb3447e38a3cadc803a9afc0@eucas1p1.samsung.com>
 <a1b27e97-182c-485d-a448-56c19c5de2c2@samsung.com> <6a9c0f55-fe98-4063-864b-8f7e1f4fefd7@samsung.com>
In-Reply-To: <6a9c0f55-fe98-4063-864b-8f7e1f4fefd7@samsung.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 9 Jun 2026 11:55:13 +0200
X-Gmail-Original-Message-ID: <CAMuHMdV-rH7s6GD4FtiKP9++3c2ojwZKm=YGLM_S_+nkj+EBtw@mail.gmail.com>
X-Gm-Features: AVVi8CfDur0wzec2mY_1awm30cbHrLvunVYojJnvz6Cb53IUltKkdZGFSORVN6A
Message-ID: <CAMuHMdV-rH7s6GD4FtiKP9++3c2ojwZKm=YGLM_S_+nkj+EBtw@mail.gmail.com>
Subject: Re: [PATCH v7 15/15] arm64: mm: Unmap kernel data/bss entirely from
 the linear map
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Ard Biesheuvel <ardb+git@google.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Kevin Brodsky <kevin.brodsky@arm.com>, 
	Liz Prucka <lizprucka@google.com>, Seth Jenkins <sethjenkins@google.com>, 
	Kees Cook <kees@kernel.org>, Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-sh@vger.kernel.org, Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 59C5FC0004
X-Stat-Signature: yfrjmrji4eno9dm31xq7uzgxgjmmtqwz
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780999368-992994
X-HE-Meta: U2FsdGVkX181RF+/jXYwKZwa/WO8FbH7KNgskYfxWzk664eU3FrSo8tVSz5Zg1h8qvKt1PLb58hEeqwBGHzgl5AuR3896Ar1ZnRxSp3m6qRl+0/Nl84Q2DlqtOuMeGDppLLZJj7y89SSmSPL6NJzLbe4dIbE0kuYserFbR8664ZWeKm9vAHBTP7TBYyFI3WE5Xp9/tPcr4xfBdwGcpfp0BMcEtqMGCadS1l5gEf8356RpaqgzQMm2+bVKiLcE9AgmEx8OgLAspQrfPzPQbnwvRRVzgwXtIO/ZK7Dl5svrrG5BJ+6Ybh/SeieqzoEy81sbrlNhtUJRcj4F2lXF911T8YBnuPmFN9r87mwWX4dKg2QmJkdJMJ6Y6uVfh8b/t5oDb1p26iJPbMETo2PwawMkpLXDOd19Ev6qrNxXmE0ECE7qMTDeom8Ugnm+d13qQDWn4z5a/MYcv8qU3yCSOmN5cx1+Mr6INIX2DbFzVkc9MKtvBlf5vI5nMy51Pq9qJltrvRUUHuN556cssNv3bC9y6Q+ZMDd3btskxOercgXeXWYHLw8+YcAvVzGJZLVG6iQSv4Mk04Po/upOAphUfVYfC8JhSc2hhjKKiMGV7H2A9S+6zXfErCyBq2ILrObyTX66i0Y29fRYh1IGn4wg22MD4/9ejuoVJlljjxaA3jdlnXIfp+juF7KimngS3w1OfH717ecOVYCvHWQ59l9uC4465x7qicdV+g8rQwuz34UzfjT6X6qsEw0Hg0131R4pfx/mG5eP7fYvFi9DbOpSeoIbxFng9VPeOVmFMPp8rr7frwESothCuf99A5sCXQFueUngx5IeXYPyWTH3hYFFii4W2FxxyV0seFY0KcBaXUP0OwyegdKTUimkfjnohyhE8CK8pghKEBmH7l1axPpkWBozkB7DdONd9CxXBXGLdIP0TBiOFjOSPZ5o1ZXyyJYe5vjV4RmQTeT4Wj1QTKpJQs
 uwjqFjB0
 gs1IpCzzJaZVCiZpQBADPYLLHKnEEfFfDe6X6YMgWGtlPI2KENqcaIl7FRL8k1844ztAePJroUJwOP5HsKMszBfiUEnz2y1hBPhfaeillKgeFyOnRlqBUXmy9oA9on/ZZQOW490NXzCv+QcPzVtJpRRekN/WgLa8Ih6ybz7e8vT0eKC7I+xVIfO7lijeLyO3R5HIGXsJ86t4K+4XZsm3ltZVhHsFtCQn3/NG8Wm0tlvilJGgibHttQipPUOQSzhkfbuAlTKkB0nmxX/5hiyVNPUXWYm97lRiBBl9dVKgWun43anGFWCJcy7KVckLybsSbokMiLcb7I/noRpmAXBSU3YoRGLD2Zi6i1ce+pH6cUpKXbfVGXshygvXZnxB3XN4Is/zi9J53MsnnfaoI3TFu9NftOm+AkC8qsHvkqMyFXDvzqiXRS/oosbpAgUYkhVi+UnW0ZJA0XvIOEtUDB1cQ6oyzoOeicMIWsWgBoHhKUfpt7yBJ4WrZXg7vfFciWcCwWZtS34xAAP6jCB0Umq1YmYcWuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 9 Jun 2026 at 08:28, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> On 09.06.2026 08:22, Marek Szyprowski wrote:
> > On 29.05.2026 17:02, Ard Biesheuvel wrote:
> >> From: Ard Biesheuvel <ardb@kernel.org>
> >>
> >> The linear aliases of the kernel text and rodata are also mapped
> >> read-only in the linear map. Given that the contents of these regions
> >> are mostly identical to the version in the loadable image, mapping them
> >> read-only and leaving their contents visible is a reasonable hardening
> >> measure.
> >>
> >> Data and bss, however, are now also mapped read-only but the contents of
> >> these regions are more likely to contain data that we'd rather not leak.
> >> So let's unmap these entirely in the linear map when the kernel is
> >> running normally.
> >>
> >> When going into hibernation or waking up from it, these regions need to
> >> be mapped, so map the region initially, and toggle the valid bit so
> >> map/unmap the region as needed.
> >>
> >> Doing so is required because pages covering the kernel image are marked
> >> as PageReserved, and therefore disregarded for snapshotting by the
> >> hibernate logic unless they are mapped.
> >>
> >> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > This commit landed in yesterday's linux-next as commit 63e0b6a5b693
> > ("arm64: mm: Unmap kernel data/bss entirely from the linear map").
> > In my tests I found that it breaks booting of RaspberryPi3 and
> > RaspberryPi4 boards with the following kernel panic:

Seeing the same panic on R-Car H3 ES2.0 (Cortex A57/A53), but not
on R-Car V4M (Cortex A76).

> One more comment - reverting 63e0b6a5b693 and 53205d56212c (dependent
> change) on top of next-20260608 fixes this issue.

Confirmed, too.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

