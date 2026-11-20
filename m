Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD0CB606A692
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 22:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=jPlmbchX
Received: by kanga.kvack.org (Postfix)
	id CB10E6B05B3; Fri, 20 Nov 2026 17:13:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C89076B05B4; Fri, 20 Nov 2026 17:13:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B781F6B05B5; Fri, 20 Nov 2026 17:13:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B6906B05B3
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 17:13:24 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 19F5F1401E0
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 22:13:24 +0000 (UTC)
X-FDA: 85456899528.21.5E51339
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf10.hostedemail.com (Postfix) with ESMTP id 22583C000A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 22:13:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=jPlmbchX;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795212802;
	b=1OnFsTNCz7o6N+nTl+i134ydgipXqKRLBzRLjr+UWuQg0XGQpPhIGBG0z55rnqHqUaZUG4
	LpgMx53ioxDi01rfASbp61/8UY51vFM4rrDZihyG2Dv0XzwcW8KNyCf9akJI1IHWYcefw4
	j7i69znCmAbl+wjNHBV2j479MnGWjEI=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795212802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rOA0kle+ETDmz8eQFgvwrDcZAmSvRA8CUZ0yI4t+KI8=;
	b=diVmrsFdg7sD8S1kQ2Zq1ZdDws/Tzos+m+D9c7hXFNxShz/Qw5TkViIK5Oz/FLIgV/xcEt
	9PcH3RsQJRR2Jqkfyn25PLZlUlbmXTBWwTQ4qv0+uIw52PPUh5JixYWjny6h6ehsDx4H8V
	NtqeX4za6HCqRVxcxRFwet3iKSyTPps=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=jPlmbchX;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-533202fe429so86651cf.0
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:13:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795212801; cv=none;
        d=google.com; s=arc-20260327;
        b=PvH3lBi+U4p1ZRRkncuiAX6MavGZdRyRPT0hSKdiLrcoqLuJuor2ocaphASfvaiQ/K
         /w69v9s41cM5Q5Q1eY07RWXUF7TPvhX5nkzUPRWWofIVDJ+LZXEzDUM52sGH/rNmZC/q
         wcGoJrWpGk2R5B2ggcTqVnOtoSyx2YjJgXu3VqsxREclGdmPJVlmsyaGJtgZ2Pola+RB
         aeo35Z5eUVO0w8Oxd6ewm+B+zsm+Boz3QtdwkgcfRqFIRfeG/igSQLL7/uQ3yUmGs4pT
         XSCkEVF11JT/jpApCG93GdJ/UhrIqJpxvD4RSA8g2LnzEgGAydIQG1KxqaKqYhqS1wI9
         i79g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rOA0kle+ETDmz8eQFgvwrDcZAmSvRA8CUZ0yI4t+KI8=;
        fh=vZah5Pl2aiGZM9RVkj7l3cLZO2uDzJZu41k9RqHbVgs=;
        b=PXYA8MdiSnL8HgQo6HOyxWAv1omMiQQFlFfhgpaQwLxxjsaVO72DKgo9reFFZMXzpU
         Y9Qr8wM2XR+0bru7R3jKRmfXh6qCbRwuTs8ZuqUV4yuwPIMPkN37+aLielPdAL71kexl
         Dm7e00V6HYpdDQcx+o8KNO5XR5Kv+dc8KmkOQ/hgAfq5LloGhixVP/6NaKdWNLQN1IPA
         hkPubO0+Lg98oVEOBEDvlLSWbK6qPWexOdYsrH03OzHgCncOlzBEwZdzfdSh40H8n5u7
         a6clli/UMWPq5N7gSszjHqnd9Rte2QoS91ynRpsI+CKfkYBC9NlXACzV9Cg+Yj4M+JBK
         Sk6w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795212801; x=1795817601; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rOA0kle+ETDmz8eQFgvwrDcZAmSvRA8CUZ0yI4t+KI8=;
        b=jPlmbchX2IbFN/oL8a+LXcyXp5+suwjD1bWTl1xlOAiprz/6ozkK2vCGN9g/AoFpqh
         dBkNYzn+PNqiQw+1yAydmfnG4AI7iWx8fGPbB3uPqbzg/mZXSmQGA9A8NKbELxWc4OwN
         9pJBQHV02oi/P14D2HR+3W70jZ/KDEz1+VPbZ14tKCZqPMeznoACTsH1AsMuEa7bz6Jc
         AYV/tMyo5cDMpgJsB0lJ+Y48Pf5L2MEwuzBXvkMqYtpI5Bbb3cH5fqaxCKzGR88E22PA
         pWZtfv4kU0AXqW7hQfGbXA9ZasSWSTeNGKuNic4k5C2KFjRQOyPxLiuTLTN8kNO9L0Lt
         wBPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795212801; x=1795817601;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rOA0kle+ETDmz8eQFgvwrDcZAmSvRA8CUZ0yI4t+KI8=;
        b=0ii8FNHdIjWJn/L2Rat6AE8IsJ73dFpYYTyD+7dGX2LjCMHK0e6unrLe2hkWRXIw8U
         0pcBCvMLvS4JNMWKbK/YQlBd32W8inw0guy0FjolnxRJRLclBY1BcQoslLqV3JDX+Ps7
         gJ8MUXllOkf8JWL5evtEPlr2UFVApdFmdO3KPkq59phT1cBv/pz7+zVTHikCulRya0Ds
         rD62Wl/CJEDUuKjhu2eb2RKlJVpgwZearQA/g6iYZuhhNamc83yv1OfDTz56pnYX41qR
         c1GQlUuZ4Tsa/9dT/eYuJgCNlYxNLc8AY7paiVhjHwu0vBl5aPKsFwBzwlzVrOT/Zodq
         DPQg==
X-Forwarded-Encrypted: i=1; AL+hErHZ6Lcm3sW0guKwXQ3godMsvGMrLZbq/nXNxB9bxTWKKNILHPbUmtK1dXOq0VrgeKTkICfQJA/cEw==@kvack.org
X-Gm-Message-State: APuU4Z8apZjMwRRdiRX6zWnhpluTNz+TN29QEsCfQiLgrLdGNj3soWeM
	QVJHcIWcIWpFoOMxwRqeAQFK9Ku+b2ETJyn66T0eN3L7jP7/UdrHVt0N+MdqW9CpTfZsNfzuh1Z
	gWPqN1UkBGB3e/JcUC573gk3+AV6GzSCX3csXKS9H
X-Gm-Gg: AYBFou0/wzQAiPnEF9LgDSprPXBQ3/2n5xICpN3fIxzJGFOHnHmo16DYvySQ8GwaA/W
	jH0SoGOQZ9ij6ZZbwfVmqRkF266nH6PPGm1W54+dk7ssdFsbY57cPjlaYA3NFjcVCYOuR8xhwRf
	I0e4LDJ67qhT3H1pfnmgf07rgnMwM3fRhSg8ISDJ7kT71FZVh5D9OuqPagIAQuzfst6Aw9EUvrZ
	wTrkWMjuIoWTogcWp/lsx72VsKurlg1BQx1xfOdNGb8uA6t8jBkgMdo3nHvB/3KamX9OI22uqMR
	HkyAYAGLiNA6pdlexXcD53TuJV7QnajAqKUP/1avmD2t/Wgpw/ISy80tSUIYUDHSPyoX/0KbVZB
	HV0KYHt43Xlvn+Kixle2/EA1+Bdu4bK41jljjZ71wu70v6IQBMtXPd0O0o03IuAs3ypbVGxZzca
	QDyI0aaqtUpdCdPnjCG5ZVZJPhzLSgMjqYXBOdkK11zqOtqA==
X-Received: by 2002:a05:622a:5a12:b0:536:6ea4:e6a0 with SMTP id
 d75a77b69052e-55d89047301mr1602591cf.11.1795212800722; Fri, 20 Nov 2026
 14:13:20 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261116071325.263682-1-hao.ge@linux.dev> <20261116071325.263682-5-hao.ge@linux.dev>
 <4c233641-15ad-4e5a-a106-423bc31f357c@arm.com>
In-Reply-To: <4c233641-15ad-4e5a-a106-423bc31f357c@arm.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 20 Nov 2026 22:13:09 +0000
X-Gm-Features: Aa3M54o8iPUi5c4eBLmIEsreudNlx9QkbSDoAuhcBwsY9KLGNvEMLlfilGXZ-DY
Message-ID: <CAJuCfpG5shRGvjHJyEOveSxkPE=x7nGTo4xmy0XLabV7NutrMQ@mail.gmail.com>
Subject: Re: [PATCH v5 04/11] mm/vmalloc: reject an unaligned range in __vunmap_range_noflush()
To: Dev Jain <dev.jain@arm.com>
Cc: Hao Ge <hao.ge@linux.dev>, Uladzislau Rezki <urezki@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Shrikanth Hegde <sshegde@linux.ibm.com>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, Dennis Zhou <dennis@kernel.org>, 
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	Sashiko <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: mddiebfgma5511rxz9cj8iu9h85m5jjj
X-Rspam-User:
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 22583C000A
X-HE-Tag: 1795212802-420482
X-HE-Meta: U2FsdGVkX1/t3J3ZrEP0iBVRacSxzu+t8tbzDL0vP0RGm1jCI4wvtRjc1u0WAGBcuAuoC5EXj9/Vejz52BHYtQ3KH+EbrlXUEV8lq3FPMc3gmAsbkg2wduCMWkjX3QpN9u2q4xCm+tBuqHWgKOyeFwGEv61ASShSdilHOPjCf8jp3BZ2DxkpJLagD5ZMt2gNLKLfCljKkyETqbyUUhYhHu+gT+1bW++U6cfmP44Lw9jMoigmyOfqduGovfiqObbyxKgGOeN4e7k1otLVmHCISVp+llsc3SPUS4wH/KT5A7uk/t4Nkd7TON9oXAGbByJA641VXPsT4l4PHl/yFWyg3u26khGNWBTRfJXh3ydd9ZMQFK7Ai4P6rV4k+N/nc1Ku/lJz7rSxNQgzvyZv38XOko2+FeeXaDvzfpGL0kghRPBMgVTCONIHXc5T4xKadp8QpZBdhu2udZuqK1uDQT/8H2jkBaHrQWKIURUF49SZAF4ex9u7KK9sdkQd/ccUaGs2EiGdEU6O8C3i9Plsgu7kk4uZVZF+ZN4axbzC8c5WLtChlh1Ie1spcRw+HBlsRPnW9dMaSFXCPKANZRHI4cOYcULx0Z8hXccoiwaoEOX7tidxzFEBF2eTf6/TT3xWw2AYGso2HKYv+jT5oEXjlDFxStkuVWUPARY+HSEiqpeU+lPwVy/xbq0M+JPcioz9Z/iwgZ7+p6+2LHjoIoH0Unj4RJHKhAhxoJHmpQLv/sxsbGo4QJxsU5pJKtk6xEm7ThO7ttXRsr/5QpScwG5AsVu2g/lAHrZM2KBUMpPO0RZlIAFQuQGSroxBsGyEeI8Gj0emDnMgD2sBlTjd2zCfKT+1w+IfA1Bs5aRQXN1pdbwP3gnZgXai3eIbZXIeatmDT0aTaCMVJajPmCGdn9Q6Kup4rgSZb4aZEbqNItprJJpLllDF82HxChGbq0xtnts1jDgpjmgkRZzZ/7ZqWYhrTZV
 COs8z+Yd
 O0Ra/HAgXWePjH4cir7QlaP/ZXKLENDpMGBrPjGbXTKaOWi5v3Di184+kYLvstZ2AEewMxcqHpsMIehQfkHhKMBzpwZYEl5UZ6GGekPrnr6dRYSoH/WjQTuIuYE8tbv60NjWFbGM4Cd3rT0ZLHmquwdTTxLM2vcEVU6iojDhNUTm5NAEmK7tc1BTM0SgJq+brmMvd7H440Ex4BlKEfd/tzJlbbCY9ftykd7220ooAoR5tgjAbspXvAeJP1AYXOGsCBPLgzS60Q5ict3e4e0v8HRsZs8xKy+bx4zEx4NFZ5q86M8Lb2RlhcORF1lI+sRQeLbhSzp01nHecGPKzLrt0pPj1JfCoBTNk4sMZV6Qq9SwokOmGYBu7UxIX+IXdlOLOVMhY0Cr4JSkMT0IWeJx7yWJ+XHZgE86kWjp0lkRCd53yIa3dL0h7ATq9bCRdPh8ySecrQib3zATUF9dAKIRbpsJ6XnLaMaaLt9qR/o8dzJQY/8GGYrZw5WOx3W+kzM7KZUe8ja+u7HZFc590wgAlrZqZM95FW81F8e+5gmniDKxeuDT3pNi7L62hW9AfqaUxnIt5FOuzLIBMVCJf8C9CYfvYqnAdFQwkQGHNi2eupVRVG72gMF26OwugmvvMQFX9s+4MIsnRB+88S9kWRN+SukBPLd9zZBQ7bEHQ+IieCIdJBr1J44ZWBO/iJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 6:05=E2=80=AFAM Dev Jain <dev.jain@arm.com> wrote:
>
>
>
> On 16/11/26 12:43 pm, Hao Ge wrote:
> > The PTE loop stops only at addr =3D=3D end. An unaligned end is never
> > reached, so the loop keeps clearing past the range. An unaligned
> > start clears the page below the range first. Both are caller bugs,
> > and the damage is hard to attribute afterwards.
> >
> > vmap only installs page aligned mappings, so an unaligned unmap
> > request is never a legitimate teardown. Warn and bail out at the
> > entry of __vunmap_range_noflush(), before any PTE is cleared.
> >
> > Reported-by: Sashiko <sashiko-bot@kernel.org>
> > Closes: https://lore.kernel.org/all/sashiko-outbox-178439@kernel.org/
> > Signed-off-by: Hao Ge <hao.ge@linux.dev>
> > ---
> >  mm/vmalloc.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index a168f6f20f4f..e2b63cb1592b 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -523,6 +523,9 @@ void __vunmap_range_noflush(unsigned long start, un=
signed long end,
> >       pgtbl_mod_mask mask =3D 0;
> >
> >       BUG_ON(addr >=3D end);
>
> Nit: It is usually a practice to change the existing BUG_ON's to
> WARN_ON's too, if you are changing around that part.
>
>
> > +     if (WARN_ON_ONCE(!PAGE_ALIGNED(addr) || !PAGE_ALIGNED(end)))
> > +             return;

nit: It's also better not to combine multiple conditions into one
warning so that the generated report clearly shows which condition
(code line) caused the warning. IOW:

if (WARN_ON_ONCE(!PAGE_ALIGNED(addr))
        return;

if (WARN_ON_ONCE(!PAGE_ALIGNED(end))
        return;


>
> Reviewed-by: Dev Jain <dev.jain@arm.com>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

>
> > +
> >       pgd =3D pgd_offset_k(addr);
> >       do {
> >               next =3D pgd_addr_end(addr, end);
>

