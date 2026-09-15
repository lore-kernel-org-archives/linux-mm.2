Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2F66C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 17:45:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A79306B0088; Tue, 15 Sep 2026 13:45:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A03336B008C; Tue, 15 Sep 2026 13:45:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A34A6B0092; Tue, 15 Sep 2026 13:45:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5F44F6B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 13:45:05 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EC4041A049B
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 17:45:04 +0000 (UTC)
X-FDA: 85216722528.04.41A79CA
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0612540007
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 17:45:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Kcb0nKSH;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of jannh@google.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=jannh@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Kcb0nKSH;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of jannh@google.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=jannh@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789494303;
	b=PFSkPBeG41z4U8NLmNvTPH/IA5Ftb2bM0mNfCx7ttGeHDQT5aEf/vN7xSXaJ24NzMFKEW5
	zg0oRfmwf6EtDQfE/2s7e/d5ZEs6WQk7RUtIQ012BaUC/I3lH5AaIWUcQpz6ciIJoGHJTP
	+dxQtmJCQd/+wXzno7fiCeR7uW7jTVY=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789494303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xmRfP1DMByF3Rtx2gmf0os+22aeO/oOugKejrIEnKoE=;
	b=YYMqMIWMGv6RGYlJBN3Z7hojxo/qfTWCnGjERj2IFDSdT6Y9FEhGdq3B7kEc6fJn8X3nw+
	3qlt3umj/pST3OxsHPaEIBZzeZ3GSEIqa02pgpV6xVcyGEYPdSSLt2C4tu9Ez+lUJS0urB
	dNbwPQ+tksJVmFjT77YFrA2XrECp4Ik=
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2dd84862f2bso6965ad.1
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:45:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789494302; cv=none;
        d=google.com; s=arc-20260327;
        b=MnWYXywSY2UneCohYmcFnPAJnkNStxFKwlBqZRaqKObmeXpJAYajLSUJBG3NaSpNlX
         +FM8p756XLV2Fi/z5mgwOqTyDle0wQsDS4Ez9adtxn6VCRj6TK0R/R6rXFQTwYukSILZ
         EJDNmCgHbvRXBYiMbpEYSDGhEwpF6SpWlMavjAG4y6ReNQNgYNPDL5hBALBLP/V7CSY2
         uLdt0anCJYGvmvwEnUR2Ev2itI0gwL7Vzbv1qxxIr+viXsrHW/gyeneCPHm0EX5sKNbC
         IpEDxiklr8Wdy7BC4Ha795sd/fjKuKHGfSTBftS5yBp0S/y8U07qOfqp7m32WhlHBScN
         N6pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xmRfP1DMByF3Rtx2gmf0os+22aeO/oOugKejrIEnKoE=;
        fh=KWYXlURf+UU1IwQHcrtMOKiHJsetPbTNN0T0s77JnpQ=;
        b=p2VxaWFJ8N2BF2ULnTZaQs3ebvyANCl+aBnQwMyjbLxc9HTMGn9cLYiDHVYfPyGkJC
         X7Ot0ASd3R7+syyt2W7fQsDKm6cbAX/1vcMQ9YgZlhB5PqcpYlPskDZ0LBeXgHuUKvcS
         J1SxO9XrevJ2joqQCE7Xeqd0eOQ0fp9KwJkjJS1bHd8jesYP46vDfrwVsDhQFoMl9ujJ
         3wVhweTODe1yHJ1zNS1VU0Vzuf3Cj+/Mmxj11aLSX6q4Zt7GHU0uqAAOlYcwXad0tcc9
         801pPZtWcHmSykeGkkPBo+s7fiIj7TkD4tJjGMDvLgFa24bLzyKS4DOoGYlVgdAa964s
         RpBg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789494302; x=1790099102; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xmRfP1DMByF3Rtx2gmf0os+22aeO/oOugKejrIEnKoE=;
        b=Kcb0nKSHj7if011X8sbYHMPi5AqP8Au9bZNaJPo7CoyIx+XQi55Nk5j9m+fjpFrt5y
         m+xFMXPZLgg5Ep8y5vc0sVDYG8bmzQV/3ep+kpo9MEzyUPr+aaO0Z2imJqZt/ifw/2/X
         GSGoI4yU6nNxR0GgbCHyrRjsxnaxuK5tE73pisuP1Cu2bIFuQFlYOgaEwKDNuMwym/4V
         6YNJrvjxXcHuOMtyz3OUwij+o8Grviewemn8N1m2Rtysl5Z2dO/0mg3bbjnuNSPLBKwP
         KhdQrY7dCkUzAIDIuOfGS0lJEcpFmvLrtZanCA91UBKWrX04Yvv9ddyPFfejsCNHdZGT
         tABw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789494302; x=1790099102;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xmRfP1DMByF3Rtx2gmf0os+22aeO/oOugKejrIEnKoE=;
        b=0iOaOdfBJaij+k/uES9zW/XXAQF1DvFXK4MAoeiRBk1qgjgsSSbnjN+I74dsBpVHpQ
         Sk4MKV7sOumxLg9UB29e4Obf2D6opsRSE/V36ARiH4dtseiu8l64VixJ6TambbCTILjj
         cseATu/GGjf/SeuPbTHjt3uWhLeZw2n2Ve2GpqLW0zd+Xd4G2Z1cROywq/ZwFWlBDCg5
         XDjdTuj2xCte8d81ti5oPjhgmXmHlYeq5/C1Q7wEFA0svy8UyIUcRqPToiY5ilUCkRch
         kfFoBi1bf7Evyo+Rj9ZVaGUiGe3eSpvrow0KG4bXf10076FILWyGiwXrHfDshqhaHSrP
         t1Gg==
X-Forwarded-Encrypted: i=1; AKwUvBx/t4aAf1AkBL/OCyHgoE9UXTssJd6boVomEYkRdNV8srXcJdIJFMRR3tEVSxD2opGVaI40NXLooA==@kvack.org
X-Gm-Message-State: AFuF++ko6P00hZ/u0ftLRxf4KlVjcKQcJ1WqiluZX2j+FxRYV62O/0gj
	erI6bMMBVxx8KoKOXhnCfYEWMoNqYOabp9OVbqWvCCiS04n/Qq7gNv6hHsjR3P4itEmBu/d0msj
	V2SKSsLXN5+6gnZn+0EzdYH65Ljpv6CQsWWcs98Mq
X-Gm-Gg: AYBFou0+mNPzXhODSdSodL0QN38uP96vbHAh/qD3S2/bSLnZ/13rjqtaDXoEDtH2B61
	kil3dEcqNy72SQWUgEl612GqEuGUZjrWhgZCIH5KX5bFMmtVpaB029L789G9Iz5X4BG7w6AYQ34
	Wmc0Cyhd98ZssQElu3Q4WQskOmBGjfa1vMYKsrwK6zJ6jo01oZq706KmzObdxJIVB+H2SxjMKON
	x+w7QDG52IHaVUEK8tRmjS841BaN1GmjPCe19YG/egJ9L8K10zyg3sHFAh8zTZFTgmKdG6+7WVG
	nCs9JrTkP2GKByzYBXHRUqetWiFa02Re+8+4fNAkUad0F9KT/YzNPaE97k+V9vQplopjhnFSNRP
	70N5BxCJ7W90YbAe24sLfuyfAQN22Vf3jrjBRpHejHQ==
X-Received: by 2002:a17:902:e948:b0:2dd:3a08:d47b with SMTP id
 d9443c01a7336-2dd89d9ed00mr120845ad.13.1789494301281; Tue, 15 Sep 2026
 10:45:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260907-selinux-pokemem-v3-0-0bafbaeafe50@google.com>
 <20260907-selinux-pokemem-v3-2-0bafbaeafe50@google.com> <aql6gyQJoxEjx0xY@shallyn-amd>
In-Reply-To: <aql6gyQJoxEjx0xY@shallyn-amd>
From: Jann Horn <jannh@google.com>
Date: Tue, 15 Sep 2026 19:44:23 +0200
X-Gm-Features: AcwNN1XRdfxLKSy49OGqywbafRdvs8vOvOcncc58q2Uu2XpqGH8ksJIePZ107Ts
Message-ID: <CAG48ez3THXFA=jF_R-wRNsEA=BfD8X1=pHm7dtVnbOto+rXW3w@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] proc: query LSMs for introspective mem access (if PROC_MEM_FORCE_ALWAYS)
To: "Serge Hallyn (AMD)" <sergeh@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jeff Xu <jeffxu@google.com>, =?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	Ondrej Mosnacek <omosnace@redhat.com>, selinux@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 0612540007
X-Stat-Signature: fnf57mm3thzs99kua13sc5jtw6ppody9
X-Rspamd-Server: rspam01
X-HE-Tag: 1789494302-762044
X-HE-Meta: U2FsdGVkX1+3uRD05Zwku3n0BD4VOTMKavLkFoD8sp00tBaBqykB9iKUKpwe26dLOZILcIVZQ14k9T+v2lZBGnFpTS0trP+Z89DXog3j7GsFnVXPJOk+8s37aEUlgoa053L+ukk0u9uyln6tTVRAJAyxprMBoPWkucOvHG+0Ho1EFc82Po17segtLTrjh9yQjkE6rDAKe3t/f23fUb+QRpooe4FtPy0hzpdxSmEqYntWuCcvWRmMVaNfxMpVl5uJ9C/LqunjVa8qIqUUHu/2iB8eevSYQ4RLxPhtam10gMCTK7MS5t7mbfUd0vWCyczLXW3DSpOguNKin/OODTJwQ1/wpo7lYfyvecOaJJO/vNDVN7ZwsktO8uqQ6sByfcuL7BzYdXKbz5NmIDM8eyKwQL2cFvZMHkRQdkTFdAPESFw5yR9c0WCClynKweYUArPZnadeo4WH4zSXvKGtMDuIzhb38Al3wSlyxgxgCjVh8RIy0KLAGbQyerQCfbk0auR/CG387WbpkkiMKTLGCZudiB5hUM4uvN9UoTVwxnHTly2A6lL6ypds1RnaCEPE9XSxjyc0C6KwPEULzQ+pmDa1b3bT8tvSOzAzAfKAuVTDNx6jJRqAVVKcky+MygTHf1QN+zUG9Yjb1mfa+nzJNqcFNAWeF8inDiY/O74KI0ctgcMnwkaKDF23NPv/pVlGFF5zDLF7i9ec1weYRQSgTm1ZbhagrXmLnkW/ssOfmTnZnl6AmO4oDhJPJEdRq7OnR3w4H2jUX5gJEuWSwrPP3JMTj/a7AmHJeuHv1NjIIwboljQfq5fiqzXcJTT6jUUCUDXB4VsH1Gppg8frqKtN69VMMrTaIylDbP0HlkvMW9UWT4TZYfBQc4y1ygP2Yd1vJEH9maeL5SeSuoNWILXWUzo5tGCj3eOyNjtpA1GvJMAxVcDYCwD8dtZikKuGgixQL60PiBZLkjq+bEVqHRTE4i6
 PAoHNko1
 BWXw6aZRVxFNM5Ij8BmNd8E9P0861j7aNj+F0KESNEio8NfJ1u8eukCSFSr5I7N6hl80qKIQbli8vJaRVpgZ3rCcJuPtwwh76TfWKSyGUkw6lULAGaEk6E7kuIpUVeRw+Lk69Vpi0NUGivxKu0Xzd0YXqSz/RMW5QOpqdjGNlTjybOZaXw6tqEbe78DwccQPcxV2luJxyRGCQfvYDXIhbrNqxugqA9tQWuygJwDKWb5mFRuQze+Yd/nPru+nEOEvCH+1SEdgYo1u78k6VAyuJ+8gFoZhlhqjiEROq4O59TI9J2xLgXMd3lLZ7tuQjmJgydwPFwq/Na9bPkjtMQr9v0pDyQdMrElaIpOp01AOcXNjZWyHvyjsn01nFTUR3ZTcJXNos
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 7:04=E2=80=AFPM Serge Hallyn (AMD) <sergeh@kernel.o=
rg> wrote:
> On Mon, Sep 07, 2026 at 11:00:17PM +0200, Jann Horn wrote:
> > +/**
> > + * security_mem_foll_force() - Check if FOLL_FORCE is allowed
> > + * @subject: credentials using which /proc/$pid/mem was opened
> > + * @opened_by_owner: whether checks on open() were bypassed because th=
e opener
> > + *                   has the same MM as the target
> > + *
> > + * Check if FOLL_FORCE is allowed for accessing process memory through
> > + * /proc/$pid/mem. opened_by_owner signals whether the opener's MM was=
 the same
> > + * as the target MM, meaning the security_ptrace_access_check() hook w=
as
> > + * bypassed on open().
> > + * (Current current->mm does not matter for this; for example, if writ=
e() is
> > + * called on an FD that was received from another process which obtain=
ed it with
> > + * open("/proc/self/mem"), @opened_by_owner is still true.)
> > + *
> > + * Note that this hook is only designed to be useful in the opened_by_=
owner
> > + * case, where the subject credentials effectively also describe the o=
bject.
>
> Given this, would it make more sense to call the hook something
> like `security_mem_foll_force_self()` and only call it in the
> opened_by_owner=3D=3Dtrue case?
>
> I only suggest it because it seems to lower the cognitive load
> when looking at this code, so it might make it easier to maintain.

I agree with you, and that is what I did in the previous versions. :P

But given that two relevant maintainers disagreed with me, I changed
it in this version.

