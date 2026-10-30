Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B458606A31D
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 09:46:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C5176B05B3; Fri, 30 Oct 2026 05:46:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99C8D6B05B4; Fri, 30 Oct 2026 05:46:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D9F66B05B5; Fri, 30 Oct 2026 05:46:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6C1D26B05B3
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 05:46:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 52619805EA
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 09:46:51 +0000 (UTC)
X-FDA: 85378813422.24.B4CD408
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	by imf08.hostedemail.com (Postfix) with ESMTP id 66459160007
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 09:46:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	spf=pass (imf08.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.161.54 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793353609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q8Bp4lvQqYUsZT0k0dArzQOZC6e3m0dIfgAJwvcDsr4=;
	b=hMw0iv8pRCCwPWZFeiXqPttx//fQaziSNt0naoTOqBrBW2gkNv3RHQgq73C0/iIU/CydPZ
	6gyluzQ38wQhwQIm3iXTXNSNSt+sOdsSdqlnQwFdfK2T0Aebee5sKFYqE5NUFWtnyhi2iw
	FJyjUuu7Dnj45RNeNcQOLUV7n+SW5/g=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.161.54 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793353609;
	b=a8dqejxuY/llQoQYuazkI50FCW95uLtcK2VE1IqKnHkb2q1t4bzKzOnFKPKmU0ZW4hzOzX
	7ME9+JqPObw22SRNlCSakxV3QLXuh/PeTk0XcoGARBjirgk5dBHlz7TPXzSo8LjiYk6jlP
	xPBPtQ3iqaDMuWbNpWto6LwUgLtSzYw=
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-713e6ecf595so509329eaf.0
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 02:46:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793353608; x=1793958408;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=q8Bp4lvQqYUsZT0k0dArzQOZC6e3m0dIfgAJwvcDsr4=;
        b=m4MV+GmXaAt1ldkYDchYvw8kRGihhqdz7dKm92qHr+5QsTZq9X+lDoxPNAcGJkqz1p
         VT6bDWKlIQODo8DAk12tPgahScVuBDkW19e3FxieqDDryFd6YRaf+FakMhJ1x/9XPB+E
         mKFNIbTD7HyhwRM45NkdBIB9cEsqZriDikgGGXz36IFV6YNEFY8KukHP/NKXamUn1Rpo
         P/3i1aia9TBvdYcU/eZgpPLnUFhtw1+s1BWRpY8ffT8mEofzL3rV3mDNz5lfNEjlhwJz
         gavgAFZ5aUIs/LdzPpGMkqgo4zIeGbPwuEGnmblvSf5Iyse2/zYTI19/BRSrGgJj9dSV
         TQ8Q==
X-Forwarded-Encrypted: i=1; AKwUvBzpTjFfjUuBenWE7v+Mw78OCrWK7yjUbMxSTP+L+Tr+oqfspa2suJ35EJqg2ozvlj6Ia/Hq8GuJSA==@kvack.org
X-Gm-Message-State: AFq9FYLjYfIMlvVrxgHEy6mddk6kLuGqFi8bCdVXeH+tvGbOgu+HJCUy
	2EFMsqZnjWGJvl7NTJDqa4YFBglFN4pDNfmJvK4QQ4mSeLIruVbsv8159uekAgxd
X-Gm-Gg: AYBFou01jHmusaQ6jczXQY7wYOPFEztfRHCVuUoxT96kMQ2xZHAv/J06CXFQ0lc2OTA
	ASyDrYxpaWRNl0EKv+nVXrEdFwmR5XNZoxD1sDab0MNiWHqSuuOH8IVI2Oieo8l6j9Pa4K31hAK
	WqnJRSP3mTxqzZfXMB8hj1f4qBd1Bgkh8UrRNkg2/DB78Yn6RkQkottNsxeRYxBGoEmOkFqIVlQ
	3AYW7T5W3nOHG6AonAkj3g9pR11zHJdiU7k7wSjbjImlvHG3EmXzwl0qEGIoBm7/lsPJQgFMvgM
	JIvSCoV1kLpSYWlrqfYeIiyDd1rSgHR9iC6b714bovogoL1gPlrcRudCM0wHGIID2iyB0dWfoLM
	9VUUARPx0Odq1IqmiliabxefT0VYOYJDZOO0EjlP8uIVEnAh5A3lg53HEbYbasKCVEA3kmCDtyR
	7Z6LiNvZnddrBlmHcOYZE0oHqyRckSl3rVosHWMF+b6j/q3sNyK+mKKa3pjhpog7lbVDT/alXS/
	dIFlkPmEXW+yG9Ok/XMzUPatuZ4NcflhcMW/3PhQI7AChWjstOW5cCo+uCKEihFIqWgsOJV6rNJ
	5oX5sXhoBVYA7WPv87OkV36wLVGZ7tnsVYDUKdsTYZrC3KnB/m0mjpuxuNJ/fPdgrrc=
X-Received: by 2002:a05:6820:571a:20b0:6f5:86e1:b020 with SMTP id 006d021491bc7-714f29fa61amr537614eaf.26.1793353608250;
        Fri, 30 Oct 2026 02:46:48 -0700 (PDT)
Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com. [209.85.161.41])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-714f2ce869asm1500119eaf.4.2026.10.30.02.46.47
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2026 02:46:47 -0700 (PDT)
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-713e6ecf595so509324eaf.0
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 02:46:47 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByUDnDmr0QlJVoWNLJJj++uu9teuDY9FXGtaCZMxjghFcpXNgXZGhOKjC2SVqwN2P0ENEkcT+L9Ag==@kvack.org
X-Received: by 2002:a05:6102:605a:b0:7ca:8f2d:5c29 with SMTP id
 ada2fe7eead31-7d0542ccab3mr1591386137.27.1793353163338; Fri, 30 Oct 2026
 02:39:23 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261030083800.599152-1-songmuchun@bytedance.com> <20261030083800.599152-2-songmuchun@bytedance.com>
In-Reply-To: <20261030083800.599152-2-songmuchun@bytedance.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 30 Oct 2026 10:39:10 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVjr+-4GA=jBNpL3nig6QfQ0Fm8ob+c-OkLADPUJSaNqw@mail.gmail.com>
X-Gm-Features: AclHuK-5feC2ixWlfC3xXKJ1XowEcUrdLUZ-UGAaez_2WzCy_48TVc-7hVrg-7U
Message-ID: <CAMuHMdVjr+-4GA=jBNpL3nig6QfQ0Fm8ob+c-OkLADPUJSaNqw@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: remove pagetable_dtor_free()
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Oscar Salvador <osalvador@suse.de>, Alistair Popple <apopple@nvidia.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Yoshinori Sato <ysato@users.sourceforge.jp>, 
	Rich Felker <dalias@libc.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, 
	"David S . Miller" <davem@davemloft.net>, Andreas Larsson <andreas@gaisler.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	linux-m68k@lists.linux-m68k.org, linuxppc-dev@lists.ozlabs.org, 
	linux-s390@vger.kernel.org, linux-sh@vger.kernel.org, 
	sparclinux@vger.kernel.org, linux-arch@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Muchun Song <muchun.song@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 66459160007
X-Stat-Signature: g3unw46tz4frczhqpp6r8qjqws1n9wre
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793353609-783379
X-HE-Meta: U2FsdGVkX1828dO+vZyDivYa2KAqvx2rnp3ZIhDEfNZ84o2ccRh+GUk7WrEDGQqPmmOhbmQqk30V30gk673JfMvS1xHFIlgOb+EBjBI/Ex7QDnU6nWTTy4wW47nrga/JWzpwc94coaRAn3oa/LcCoa8kyfxHNfW0Prm7jKuymqI1p/H78v7iJMdgURLTW7o4vcswi3beYqpyUGVzNUGzsv837xnwQzGW32qYOl7+eJCevl/Lnhtf6cTA54EK7RtF7kOqN6BdDVDsOJpCYIybmr4l2Mazo4g5eHjJMTUIRi2423DWFEOc2TfePXnFLxDeosiLFx+4cM+JfmVck8inMBuuDepg7jC/zth5r8oy2wDgdhNHH0IRWGfUS/h4aA5npywbkgq4myL0DVxijQE+9RP9Uf49RZFGO58vJFccJL9D1W395+i1flqNsrj1QL9odMSj0noaSTz0SetzT8aVC7kYb7mAxB4jsNVPqJ92sVVsbG+gC2bvWoNmKNO0G2+sTZUYWlZem8zVovlLwKaJPr4e/iMkmgFwak+GEKXlg/K94yy1IJbjMrsBnTkx837Nm9Sz9f5pCsxgB7J8W8anittbADJATnPfmEKIhJmwsJHz62eNh/0wf3v0Ek4+5vRh6hnld78w7ey3JS04Jl0HswkpGQRQR34tQix/OxP55YRtOLFQRDB+XsIw5nfzyjxca6NnoBfj9nK+NevwqWHa61wG3EcPX9hckle+IkyJYMgWR4dNERiKYOyctoxXNuXmkAf7jbKmnjF3CSOa5IYYPwy/fkOgltNnKGUjvBzTCAwwEmw0G/eRUb4m4NXBo1rbsOJLPZAMRNYLqH7g3yhVhAJveoLySaIbtvDtjNVhNasB1/X4ikAuJ9AnDA5pnsJ+KJawhiGgqhEJ6sfIpIYYlcdZAUtaaOiiplGXTQ172B9d6KpOnGdubukJCKb8LnnB1cAghhgjrTIhBRXnz4k
 ESS62+/n
 zhzwz4E2HKgZI4mbHxQee/64EjM9iyPpaAtgVz6Z3rAiuM3RBqSFv8F/f8mg78LsEklkM88H/kKl/tJxcx/V1XEb20Ygivu+GASYi189BUSE4Ze2uX1wg+fWu3d2z72YWlPU+5XANJjPWSIa04ydH6YTOfjwPiTiv2P/kj1AUj7c7KYMdFpKe40+fIB0pzPLrHURXsk6e1X7Mv8hoguBA1HXeZ+5wt7Tp6Mmtrhp73hxVsqL9IRWRC56keyMQFduMAkQgN7zIsrKBxp6Pa29cJBTDRpwfiwVLskLmUZl6lPsTtpLLyCswTeGlVrmDzt6ea2ucqzQsT0Q1BefiYNUcttAtH4jLB8XPXsMXndziH7utKYpnfrojYOGVtLu2ZnAWm8PmL//79QunaO7Z1zdI/45l3mJQT4EAw/tSfGGHLs4WBMUB2BUp+E7z9X1qq7KGzcI3iU/+PgyRTUGNQ72+seh1q/jfa+44NcP2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 30 Oct 2026 at 09:38, Muchun Song <songmuchun@bytedance.com> wrote:
> pagetable_free() now runs pagetable_dtor() for pages that have gone
> through a page-table constructor, so pagetable_dtor_free() no longer
> provides distinct behavior.
>
> Use pagetable_free() directly at the remaining call sites and remove
> the redundant helper. This keeps the decision to run the destructor in
> the common free path.
>
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  arch/m68k/include/asm/mcf_pgalloc.h |  4 ++--
>  arch/m68k/mm/motorola.c             |  2 +-

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org> # m68k

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

