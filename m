Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E927AFF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 09:44:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C7816B0088; Tue, 28 Apr 2026 05:44:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 178A56B008A; Tue, 28 Apr 2026 05:44:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08FA96B008C; Tue, 28 Apr 2026 05:44:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ED9176B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 05:44:13 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8EC8F1C093D
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:44:13 +0000 (UTC)
X-FDA: 84707478786.06.648FBE0
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6E8AF18000B
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:44:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777369451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nWrICmexI+A6dB2ZQxQugwwArdZmj01ZZbEQAQDplTY=;
	b=Q6e9GrQ4kereWbcc1MDX4TSW01uIIXtkRC4irZs6DIjjkj6oyB2slpuICAFEYWUd3HJup1
	Yy8UvQMhmLBeww0ZyapnylcUYFMtGJl6ryPKi7omsSEw01bkGFcAmFbqiHvPO2gUXcKGmO
	SQYMUrUEiI5rVMQZD1asWjm2F+mlJXM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777369451; a=rsa-sha256;
	cv=none;
	b=p10ksmfdxrX+sBch45A4RWWbRGeqnbZyXyjYYZpfsnqQ9u4OIuIESF0urp686+cOUFDaQ+
	1uR3Nz9NcNxbef5q4yFEAECM+Cr5SYi8kVInI8Fl+MO7kk6dlsrYUrZxJw5LrXoCpxztlC
	GVWx3jteGuG4pV/ZFeZyaMCxW5wnFHE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-67893fba9c3so10026426a12.2
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 02:44:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777369450; x=1777974250;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nWrICmexI+A6dB2ZQxQugwwArdZmj01ZZbEQAQDplTY=;
        b=Ry8bh0ssIYgd2cPkckz6tsGlFf1C3OAFLucgxzGs3g54wsMjp/4m2bx6li5kcsFMs7
         QkTimLGLtY1mj3homKCsa1d7Llp6PZZxoqaNsxpKehwDfVdYbG42q/i9jJTek+KRZOwb
         jfpgsgr+q4JIxhm648L+9pCYjqMDkKAziKR7K9qkq1qbSAgewWg2ZX5kVpe60qa+Xhej
         T7kAHbHGsMNbAnOScyeTkzoFyM/6Mu7v/QELfoZLh1HIC5f8siX0CLinHqYKWqN2y1lv
         QwEgXlvytVt8NwQLdI+T9AimPCRe6uTUdxEu4dxJLYET4fg9ILukavYzJMT1QRV/skWf
         kldw==
X-Forwarded-Encrypted: i=1; AFNElJ8oEGsUKCI/szMCAC6w3R+q3/Ymdss0h8Mr+7fTcrQ1AzRM9cx6bx5nnmKo0SOwaPRXPxoi+k45WQ==@kvack.org
X-Gm-Message-State: AOJu0YxY7gNgnkJlUSpI7noNjUJ/0c0NotCkakalkn7J7eGu2+vPIacg
	5VVQ3qTIN8kANrSsG8HaeQW5lvpbKs8hQNdYrcF8DreWXGP9bnDx0PRSy3BV5d+hKaw=
X-Gm-Gg: AeBDieuZMbNhlJuD4yJ8G72IIExOsFPTMdY9JdI38ai8vxpd6D9oyTRTHj9SqIVwJPo
	e1IEiaEjI03WK5LIq3HLL3zfEL2tj71Lr3ztbnDpauKs+2gKrwRlgqdQkay9GGTMYNavPHS27gt
	UzAQ6I5NbdJXeEJt3Zlx8qab3U2HdMqdY2qdY5TJpH/J1X37cDNQfbQF69V56ErqNeUE4aBN+11
	40hHFkzgCOrJn9OhyCa70pnEMTtKWpHdRXr1dxdh0UN6/nK5y7jdqj13uBVnrY5hLWmygSZYeRv
	buObpTy+F1oAujPL2lOfN2OC1rQzIZrBbArlaCQEfd/uZla8BHwpY5/Vz0q5cNVg9eXUuJb143+
	J8qB4kHUMDFQL2tggCoDF1loLNU4bm7gKA6I2lJi8XvreyWec6qRoHOw+Be5QJ+2z9bBugDiGbL
	RAc97nm04bXDiDbDPfp4WV9oWvzWpewtAhStN4b51PnexCwhl2yO4N4j4VgVcrzCu7W+evNlU=
X-Received: by 2002:a17:907:928d:b0:ba7:f5fd:edd6 with SMTP id a640c23a62f3a-bb8015eed4dmr143929666b.10.1777369449819;
        Tue, 28 Apr 2026 02:44:09 -0700 (PDT)
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com. [209.85.218.49])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bb808a3588bsm76918366b.14.2026.04.28.02.44.09
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Apr 2026 02:44:09 -0700 (PDT)
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b9c3e2cf3c0so1898902166b.1
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 02:44:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9GuM1KL1rjqGpPF8i56hY8ghWiATkdnzKKCvpv44Q4v9TDIUJbBdj7eUXjRBtKurIVG6mw9M7d8w==@kvack.org
X-Received: by 2002:a17:907:c80d:b0:ba7:9857:2fa9 with SMTP id
 a640c23a62f3a-bb801ad7348mr148812966b.14.1777369449228; Tue, 28 Apr 2026
 02:44:09 -0700 (PDT)
MIME-Version: 1.0
References: <20260427105810.23761-1-pbonzini@redhat.com> <CAMuHMdUvehWeTwdN1czjvv7OjGsu_XaaYS1R6Tg557mDqP+fSg@mail.gmail.com>
 <CABgObfa+2ERN1TmVeeWxCQKzra_OThkgkVkBGgDfu5yOsjOH1A@mail.gmail.com>
In-Reply-To: <CABgObfa+2ERN1TmVeeWxCQKzra_OThkgkVkBGgDfu5yOsjOH1A@mail.gmail.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 28 Apr 2026 11:43:55 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXrt4khjgV41Qt2kDWR3RfMXvOgghi83ovyMnEqJFNU6w@mail.gmail.com>
X-Gm-Features: AVHnY4J_GAQdlnmtDpgrREfPjFiZlxFdEnKGHr11C0hlHFvtBM-VdB5gtX4hf-E
Message-ID: <CAMuHMdXrt4khjgV41Qt2kDWR3RfMXvOgghi83ovyMnEqJFNU6w@mail.gmail.com>
Subject: Re: [PATCH] mm_types: remove references to s390 gmap
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-m68k@lists.linux-m68k.org, "David Hildenbrand (Arm)" <david@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6E8AF18000B
X-Stat-Signature: 5mufqmijob3p4rn1pwgh99rrkc8kzrss
X-Rspam-User: 
X-HE-Tag: 1777369451-769577
X-HE-Meta: U2FsdGVkX1/b04DcpE2OUHtl149jcsveg+esBza3cGJScTUxicWfp5I4+U8vpAr6K635e6tKOLroiFjI/hML7EAflES1h+uaB957xOZLVPMYiL1IaKk2XMIdD/iKviVIq5h+u/rj5980sHBwTouUYIZO/7CnuJuyx6RSlYywRcValDoqPOfxoRF3KogyPQkFcg02Nm3QSdGzqUQjtKd1ja0XUAkWHui84+He3BjYqSQyIlXyD0SAzxPwyBsulL01tSgyc2n1wcGV2E55hIhTgCrVeDYZZVhphTuxCXP5WKeAA7p1xOfWG6pzcUstskbbKVz+9t0JArpjjziTnBZOI5QeNARm05ghkE8WLOYYNux1sGjGiXkAPwudkZ2FPJwgTLP06clbnpxff0b/SZJNT916m0gyKx0P5eLRQQL6NrgB8iZ+rRchOdfClB47qlorDtAqxFo32c5oMH6aFvheKAf1pssKIttrk5aph/b27QFE5WAT9Edrz4PSvE5mJj9cKkPmq9njD2wZZKl5lrjEPmLkCE6lg/U3XBAIGUBhkY2K1ulp6DIAT3ZUd476DTRHQD09ALUmra/KRxzd2Nm2TusyEq8Ukm9/ZoqS7hA0A6BvIowlhGEVGWC1j1eTBsoKn5K/vSvt4fzdoi2jeBLwkG3fYxzZgyA4EF3SBDIlZ5F69JsQUhK4/C8dAAqRCRaQfdF2+SblY/fE2u72+E1KqR+KYznZJqq8Btds4HYWb8jDEIfqkIvTqioG01c5N+uVa1DsqQgTdmBwEgMYp8NFbX65bw0fo9kzk3pl066pQsj6F/zKfrRsdGvuE9+d7grruD92Rz46PxlZ+/5d2dR/oLYiDjIGLPg+qQUk3uflJg1s+beDDqImxhQ+vyd2zAYLqVs5AqwfRUXxiOGcuudNz0XTi9nkB1KbJQt2cdd1ZlEJwt0LVoKrjs2LwkaiRMUjLA1yBvpaEdbenW+Q1Lw
 HtSKUg2m
 v32cX2fCDlNLOPGd6FcW3osZ03QDRC4HT9vFZwfbDPFwxhaDPBMSQl1GvwV4f9t7NuYWclNAo6F3jzpWVY+8YYYco610B+i8f5FZIJu5sdo38u+lRSU5eLl2/Ug8MPGhJLADA1n1ZzfVlPNrVyAu7EeShSRjD+/3ur9+fZo/Xv+1zNvLjxU+F9r6ZSBxeErnhR77D9uZNIcTr1Hkl6My1kmfFAIFz5f4bb3TrU+SSNvXY+AFr1Ifpj5Ojh2HqB3yIDSS+UdbUuGJbuaF1BS5ad9gS7cUfFH7CywjlG+XeOiXXrv8Yhev4Vv7VT08VYz0Cdt3rdMJ09DVO8GyOc75vAAirNCmq1HbKJoeNxeI632UgpzJ37UsKvfNpqq7hU+Vj4RrINsgDDayjbVfsHryQUUHQaY342W7D6hsj+Ibdb/QDV531UwsOq8Q4DGJ5dfwF3C/kN6ok1VrB8jJhfWcz9k8NoQkKSvHYNqHaXev+MGHqM/TiaNW/ZV1Jf5p61jsBSPYc/h7j3tlm0N3Sv4jsr3ecoZ2hn8VURpqH+O9LmYGCqm8iOrx8OQE4GrS3p4RcYhUVcBHlE4yGiDXxmzO8ZxPmMmXf23lnPq1pBy/1g/vWwTqxozkQV6IO+TBcwNfv2Z3fpCwnGcZidbw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Paolo,

On Tue, 28 Apr 2026 at 11:40, Paolo Bonzini <pbonzini@redhat.com> wrote:
> On Tue, Apr 28, 2026 at 8:58=E2=80=AFAM Geert Uytterhoeven <geert@linux-m=
68k.org> wrote:
> > On Mon, 27 Apr 2026 at 12:58, Paolo Bonzini <pbonzini@redhat.com> wrote=
:
> > > s390 does not anymore use special struct page for its shadow page tab=
les.
> > > The honor of giving a special meaning to pt_index is now m68k's, so
> > > rename the fields and adjust them for the desired type.
> > >
> > > Cc: linux-mm@kvack.org
> > > Cc: linux-m68k@lists.linux-m68k.org
> > > Cc: David Hildenbrand (Arm) <david@kernel.org>
> > > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> > > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> >
> > >  arch/m68k/mm/motorola.c  |  2 +-
> >
> > Acked-by: Geert Uytterhoeven <geert@linux-m68k.org> # m68k
>
> Thanks, do you expect it to go through the mm tree or are you taking
> it yourself?

I assumed the mm tree.
Thanks!

Gr{oetje,eeting}s,

                        Geert

--=20
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds

