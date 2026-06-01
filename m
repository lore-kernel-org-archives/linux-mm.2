Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7BEACD6E4C
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 08:12:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CB9A6B02B5; Mon,  1 Jun 2026 04:12:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07B6F6B02B7; Mon,  1 Jun 2026 04:12:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5F916B02B8; Mon,  1 Jun 2026 04:12:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CE9466B02B5
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 04:12:02 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 78B181621E9
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:12:02 +0000 (UTC)
X-FDA: 84830625684.11.B319751
Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	by imf26.hostedemail.com (Postfix) with ESMTP id 67F9914000A
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:12:00 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	spf=pass (imf26.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.221.173 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780301520; a=rsa-sha256;
	cv=none;
	b=YhWMeWoHj1oMOAW5zxJePjPoETKxvYlkRsEKgWwyt9X3IcviA6on9ohG9SJV4imeO3s9gn
	cZMusP6EPiQgSu4HjFnD6bWeNmmqZeG7yZFreLsGYoGXquV+w7iLXViH+qk4K+omOqUzk5
	rXLabC0bwYr03MVYoIyYGnM917SZ8c8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.221.173 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780301520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z6bsjRyMlYCGVZWYk2Y60sUCqRedkIR0Vi6kAvx0wUs=;
	b=to3DrBmPka3tbdn/XfBmpGQtblTmNL0E22SrdwdMg7VAz6ezIPvPCqzrMJ3wV/k55lHKDt
	iaAblSzoCNBrTNi9+y3V0VCO+xqqS/eFYjutnILT4axUq3tUGryWxYwvcUut2lG5Qci+cl
	FqY+Pi0eeOhdTo+kizqRg3YCw/sESZQ=
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-59b24523cbeso1713034e0c.1
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 01:12:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780301519; x=1780906319;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z6bsjRyMlYCGVZWYk2Y60sUCqRedkIR0Vi6kAvx0wUs=;
        b=F6wpApJb5wtA2+r3M+mj6PHmPacUN5ak9IMFTsdVwJTdku9EAKuQIForH16d7w1byE
         fmcyUzP6svP2MAV3jXgslmh+vaeBneJ0VWOoQ49wCKKQ8kOpUpu/Ij1Z4OUeZf+uXZdV
         F7KSOBi0wRZvcQa21tTi1F9f3YFc1fJ815J7J9SZFfCtNJrpKJjmq222LTER/XXowgCB
         7fRZPmK2CpxgiwnF1KNwBG3umGfrQHIh8HOgtD60vu2CdZadz/eOVuZa0DdfOCem9eKC
         GBRogY3VEe/SyKUieYTuqx3o1IceWRmMEXTh7UOwqXT/o7K1dPWOJzntQ4cup9MNJAAO
         z/Kg==
X-Forwarded-Encrypted: i=1; AFNElJ9ROlWbMgDwaWmS+c6dsCdNJpoU79WV9Ob9Z0FsKnH+kd1W9ov/zwx7f9n+ZChZ3akSdDRxkRKYZA==@kvack.org
X-Gm-Message-State: AOJu0Yy2oVtOMFewdZvgMlURUgxY9hBhcGexSuajVlH3DjCnP62v9rLv
	nCkusk4EDb4vKsbqLIUzUseiEwGDRpDwCYTIID6qZgejX8jwBfJmxDqFQAFltfiU
X-Gm-Gg: Acq92OGkNpt5TSOfB3pFQSWDJ1fyTHSpa5bOTIa6k5I1hZHfkuXpS/iIuxUGBpLFPzr
	hTk2nvBk2Ln1n/+FTCi6NK3TJay4GEpOQs4BbmwtQG72hK5inesWskU+IgRnfxlSO3PF4buuq+k
	jXzoeIdDgf+K+5ztS5n8Xk04w734OwXHvHqCB6ARRmvwcDTzcc3NM6hdhqy5P4Ykt7fvTvHmXvc
	jtN+EIIegKWcbR5D1Zg8mAKYUvfCWUR8J8uZMRUGndmXDyFqPPWecw8yoS3Ctm1Md6+xEMM1TpD
	0K6bewv537DU5UFoFUjnP+jqewfIEsMdJ6G5zXdNtdCZBD6SQFRLva3xJ5FYA6gsPXave234bNj
	Af5csGpLGi1sbdfQIfcAfiE2/vU1274PTZ7kS0lf9hJglWTcqI71zUCV/hCRrQntAwXYQBN6kLL
	eOpnl1Vi1nqI7XlO8cejngkYpo/hK7VAdZDf5UjC4btv3ILnZ8kaviPG5xXKB4zVnHNU+0eck=
X-Received: by 2002:a05:6122:208e:b0:56f:bb91:4861 with SMTP id 71dfb90a1353d-59beac05a8fmr4215326e0c.0.1780301519436;
        Mon, 01 Jun 2026 01:11:59 -0700 (PDT)
Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com. [209.85.222.41])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5a1cfd9c343sm1029516e0c.3.2026.06.01.01.11.58
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2026 01:11:58 -0700 (PDT)
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-963d7e5ffddso598807241.2
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 01:11:58 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8fwNh6fBnmgQDhWiWJBXP4b4ziYo+yBIW24ELF73Ae3HVKOhPYnO3as9IELtLFDzGPyeiUoMraSA==@kvack.org
X-Received: by 2002:a05:6102:3ed4:b0:639:4bb7:c916 with SMTP id
 ada2fe7eead31-6c67682807bmr3734166137.3.1780301518249; Mon, 01 Jun 2026
 01:11:58 -0700 (PDT)
MIME-Version: 1.0
References: <20260529150150.1670604-17-ardb+git@google.com> <20260529150150.1670604-29-ardb+git@google.com>
In-Reply-To: <20260529150150.1670604-29-ardb+git@google.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 1 Jun 2026 10:11:45 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXp0qp38vHJTDFMrY-AUDXPSJtc5Dds_qu58FSeS_242w@mail.gmail.com>
X-Gm-Features: AVHnY4I0grL2HGASleAgF6ybT4VX0NqDy8gokQJ4KkNhvH_ouOMg7ryFWIbyvcA
Message-ID: <CAMuHMdXp0qp38vHJTDFMrY-AUDXPSJtc5Dds_qu58FSeS_242w@mail.gmail.com>
Subject: Re: [PATCH v7 12/15] sh: Drop cache flush of the zero page at boot
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, 
	Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Kevin Brodsky <kevin.brodsky@arm.com>, 
	Liz Prucka <lizprucka@google.com>, Seth Jenkins <sethjenkins@google.com>, 
	Kees Cook <kees@kernel.org>, Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-sh@vger.kernel.org, Yoshinori Sato <ysato@users.sourceforge.jp>, 
	Rich Felker <dalias@libc.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, 
	Geert Uytterhoeven <geert+renesas@glider.be>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 67F9914000A
X-Rspamd-Server: rspam03
X-Stat-Signature: 4bwcm9smqg8rgexwyh8qrkxegatpr35a
X-HE-Tag: 1780301520-867413
X-HE-Meta: U2FsdGVkX19RCMAuJnYcP6WdQtmVJvg0wtQlDWrvzQ3OmfpW2R/iJthSTgFrBOqPeZlWYtkIjdj3g/Eh2Ke6ojfd3xu7jYNLhcv+NPwiGrn7vmmI1VQKs1tJ/ColeEx49FcarCqDFboH7zak8GoLlLTOjOm+brH25dbreC2er2QMxGj8NDbhFPMXg58hqnJpNfamqz/JwcGGaXvU62AbuknMvcwTnP3tn9OXPkCwH5JYOIe0unemq/tsd6tUjApJt/8CwJ59EVktydR/DraHdDudJh28WAWTPkWhVfYjFgqrXuFous76eXEYim3YG31OVx6NCqtfEc+bk5hXPbSPOxGihfMMlOziws2PoLo4BT39lgz2BfqFLLdG0mASQ3eW7GhOXrRcmwEN64aENk687boLIffSs7iiAJL+r8YwdoLdKbJWNxAWyet1jQIlsgpdSDHQVZY58B9AQe33g2Q/I1GFz5qfodWIjrL/Q+lTqtd+KPj0nmH+bMEmgGwga7GStrVa//QCbkFjLU3tBtAn+slAGg1zEi9wIZL27uUAh5DZ9hACzmUo7tA3yoqUci+Icsjs86JPyrYTx7dmZa4O3uPhY/p6moFryMv89zFpoimP6H6SdYhnLRCrExKQijq55SF82W4SmLGukriisDf+ZP7t7cHlQS57+vzEPKJXbirY4dj+Ir95bVq6OJrLYLX8itSxhkKAX919p5/ZdjRJwMvmnXB15byFLVnc/Ggz2wOTLW5erkyT2wS7wj7J93jbfAGPoeiM8bgRujGrX8jKGrVB8uTG5/bgaFKdSBr3qOYoSOhXi0oLXzWIU5/eNZ4lRQ0aPka5XJ9wzYZneliLDJ257drZbBcyOyFcwtOLpI0wFvq2MVVIfZvakZ+H0v8l/06W+y+34VPbrPzj5QJrYdd514eNg5uxeMsF5LWPcKRLZcRKnztWl71J5XSARkT2woKkYPmc8vVf9q9xqL9
 7Ac9WthM
 gDTMR722yZiJTHPfApj6MgOyXqpqcv98LYTU14GDRd976DxOQ2VqDK6jqI5hsPdCwJxeiEKp3Cd7uZxr1EPKlq2Q4NptCtN1UvBFoji0l0tlbZDPiDxqFfL+CPyvkI+PStciUoDTzvm9wP9dcY5222I7oSxhQaIVa3wfnKrOPVnF78574y8HyDxcgYHFi5dS+ZLrsOtlBceKdA7ngL3lWklOv0lIX14UzypZqKnil9ge8EF2eN4XdcuVLbVQkTfryg0hISsPvg+v88pwpdU3iJtzdf05Y09shf0zFOIe83Wut1C9kqxiZCwg/01kmaiUUJEMFQgGVf8VGQ4d7avMH2r5yRDbl9kwT0tqvVQn61S5OOzlK4Hz+7RR3CF7xI7f+s2tTHapFrBPL9ZXp7bLvzRyKnGvrUQ4E5gyuLAI5RFfgzfG1sV3XvjXwUAO9/76vsozl55tKH2uRLtLrzsWecMiruaFcgRvW8Hi4qQbzxRU6yD8VGAbecnZPTMk3dfRLbwzLzNUn/g9Ufyt4dPeoR6gIQ1q+OCqOpZlFpVMG6uvy7Wu0ws7uF4alYyUXqiG7U7PaT/vHKak/0hwhjq8ZmdhFGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 29 May 2026 at 17:02, Ard Biesheuvel <ardb+git@google.com> wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
>
> SuperH performs cache maintenance on the zero page during boot,
> presumably because before commit
>
>   6215d9f4470f ("arch, mm: consolidate empty_zero_page")
>
> the zero page did double duty as a boot params region, and was cleared
> separately, as it was not part of BSS. The memset() in question was
> dropped by that commit, but the __flush_wback_region() call remained.
>
> As empty_zero_page[] has been moved to BSS, it can be treated as any
> other BSS memory, and so the cache flush can be dropped.
>
> Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
> Cc: Rich Felker <dalias@libc.org>
> Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Geert Uytterhoeven <geert+renesas@glider.be>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

