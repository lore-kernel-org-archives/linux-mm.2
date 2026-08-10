Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C8E0C5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 14:12:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 156266B007B; Mon, 10 Aug 2026 10:12:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E0BB6B008A; Mon, 10 Aug 2026 10:12:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE97B6B008C; Mon, 10 Aug 2026 10:12:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C11336B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:12:10 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4A6BAC0108
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:12:10 +0000 (UTC)
X-FDA: 85085549220.18.98A9CDE
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4EC5AC000B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:12:08 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=D9DaoVnj;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf10.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786371128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n4T+gwRZDRIShJR4gZnLC0NVnW6k5s6US28LrwcXeY4=;
	b=KrVvw5GlQ45fjfOvkcFdag2niW124Y2WAE7qHJPeoCUi7ZMVONbfO9MGQuZfZ1M2ktfOWc
	yVvJSn4tiSQ7MxPALZLUywVyc7S/Gs5/T6Jig1M9aEjZ4RoWJ7g/fMqXSLW8dZkX3O65Kx
	S+4zvd4Dr3vk7DvO14LM0vehEDiDMqw=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=D9DaoVnj;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf10.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786371128;
	b=i+bpuavPXgV6cOkb1/lJAUHq5/Kr49Na72EdDq5lBgUvy0pWfA5+13z86yeJiIOlqy+N7s
	MZMYBO+rDaRa+ABWWrxQLiq2RZzWoKOKVejsXz/dJADX1B/vN2NphdXTh6o6VMJZvTd8st
	SYOSwD0K5d/YKRzLRrIzIg9/rpujc0w=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-49967f24eedso2658655e9.0
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 07:12:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786371127; cv=none;
        d=google.com; s=arc-20260327;
        b=mFvRtnA2lNJvWe0fumhrMbPyeale1ZFM8djt2xkPBMIwjXTB1D8n5ntGBnse9GwQx1
         B1akLAoyE4t45xJ7ESX4pa+PF29YZTf/ITShd12oePAuNz+vaVeM48ZmQJQPWG/FUCtb
         cYfpYQexH9njQn5hVX07TgPwjlDJ9RFqRhDtHXzz4130UTdinyNIOqPMzeB+KNouwgJt
         zCDEFfHRFKG4sKfhenLHNB48A5QnroQ/I0NuSJ3CEczxbK5lgb9+O4ZUAS0fZsz/c0Dm
         /lxvY/05MRO5Rr0IxLadjpAFdoIdn6T1zGLJVSvUASasodl9JTxcSJsnLjlj0Ht6Zuku
         dIAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=n4T+gwRZDRIShJR4gZnLC0NVnW6k5s6US28LrwcXeY4=;
        fh=vm2L+YkNaCVLAiPM4dh9nODtaSjlexPd4n8Q7K0TnYU=;
        b=LG3lRumkJzj+9ndYxLwXYvCfSyBEuVLpAiOw+1UpE+RzTwuLUPDKZePS/pZzzaJ9Zv
         7TTHore0Eo/gB/+pCZJHW007cJsItTvxQ38rlEAIo6TDphssSXrCEkDGrhxBpwop81tY
         SDm1l9eqW8v7Ya/Kvdy1MTknPUr/rfhDOmFRrxrIEMB/ZzT/MHKnu3dC2cMRsMXUIDHd
         NA895+rHeuCMyFyG/XfUfkx0iftDkVZfxlMK/2JjrpRqHKkyLa+f+cwTsw2AsXxEdb/A
         nZtDEGx6VeoIz4w7/zWntnwNezooA6ewdAZysWYfOANtoBkZMqnJUH4GwxDFr5anSSKM
         YBwg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786371127; x=1786975927; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=n4T+gwRZDRIShJR4gZnLC0NVnW6k5s6US28LrwcXeY4=;
        b=D9DaoVnjrUOYznchWOVhiqI+GmSpSL06zft/e3pVBOUhUj3xNjwZIZAyXzyX+w4chF
         Ls4q7zQuPTSPgeIjMJ+JqLQx/JpBqG55TwaGG04rmDXegGtkLnbCBPka3YsR0+NAu2lk
         BD2Eu7wQPyrNL9eAKx5ws/QNcLrj0xC/pOdO2TQuMOBF+EPHSFF2V/al3X1rsnwjmAII
         RIFzAZntloL137+VskdENPyQcRBiVnKjW+8A8YyvI3BdBUmDXqYWBj3mJD8JjIRiPsSC
         Yrfwv2tI4uVcOCTPT8DZG1VeH0g15N9JjmGYH3OXJ3MROJtZ3JAJArkOoQ5+Ayqf0SvD
         0x8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786371127; x=1786975927;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n4T+gwRZDRIShJR4gZnLC0NVnW6k5s6US28LrwcXeY4=;
        b=IMfOvXLsu3kEFwWLnURpaNInZzwsO37PoRYVXCa/fbEJbJ2V2XfCw5BQBIm2JIxf8u
         sZOlHioOZakdBsL3gUc5U7u6pDZd4R16mlQQQLQN8XFJoRhe3FELV0w1hJe0V/47chys
         AzLGK6Z9ogCTI3jGu+qhOHZEeg3kYzwrbLNZLXQkgRWWK/4gpr+gcYODHiUob4I8Sh/t
         O2p8RuCGFJ4dTyPQASL5GF7cGkB5TQegssIXZjl+9bX9pzG0TbwUhOVidMCmwMc43Bp+
         sGaOZPBOOo873rK0pAkIkx068rSFKiUYNvU8mmC8OvDn86Q3wP3JMDFTYiJ4h99n1d44
         E38g==
X-Forwarded-Encrypted: i=1; AHgh+Rog/1qd1DLUzC+40ngkccoWCVM59rFNt8mwjDxN0V7ZQM6K6DWvFL9TVlA1wIkxfEhouvUlVOpJIQ==@kvack.org
X-Gm-Message-State: AOJu0Yxm3pqhdNOJnqpdpmJ//3HeVEQMZf6NGcpX3Z2TR8B3ngIr+VVV
	lgn2OtO8oie4vK6D1wPDriTmxShSODPxNjnZUGXROq65j7XCzfmlX9+x6ihh0r4dbgvPCr61csA
	eNRvDGpwg8SoHvSqUA7ISKH87/GSUSEE=
X-Gm-Gg: AR+sD13x3ckc9nDTFQVESTE5GaHrzxwBFHSbtDlm5lt5f6HvFL0yCJWQ3nijpX+aIID
	OtJ0TeMXfjbkoQkwH8NXbEukhA4sagoOw9QE4PVmriNS5e1X0fzz18KZMWS3BKpyWsSjpkm5EZV
	BcyreRvSc4VrYv0QfGtCmEiRRCIfgB2rp1bd44bZ1H8O+O8oe9EI3/QtCvYsSH6AG/3Hxx3peE8
	jqwZbK7sT6Fi2hVboRt7pEf4sAqqRZSgRIGqKUMXSiS57jun6VT6LUOM/8Rph4SgnJj6m3svRdI
	veMJ1kzQezP3Nd4DmsdSzHKYDKqhWotxoniuJQreICYEh30u81KeSL2gaM4A50TVt/v4UeQCoYd
	pAMhrrPmHQwVgWPMi8xfVcGPdVcP0vw==
X-Received: by 2002:a05:600c:1387:b0:495:3eb4:3c6d with SMTP id
 5b1f17b1804b1-4994e7b810bmr274599375e9.2.1786371126190; Mon, 10 Aug 2026
 07:12:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260730122304.2496440-1-xueyuan.chen21@gmail.com>
 <20260730122304.2496440-3-xueyuan.chen21@gmail.com> <CAGsJ_4zo_uya7-iFS85W78+mpvjhmfxp7HfxTPKDD=Aiw2c1vQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4zo_uya7-iFS85W78+mpvjhmfxp7HfxTPKDD=Aiw2c1vQ@mail.gmail.com>
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
Date: Mon, 10 Aug 2026 22:11:54 +0800
X-Gm-Features: AUfX_myzk3L8tu8iuyY3KCv2aKO9j3yll3zHn2I8kTwXhIPWsgZ1D2l0l_IZSoo
Message-ID: <CA+qSx6w_EY23GzgfaypXz5pd=h9JoBjiyX5+4Po487QYb4R=aQ@mail.gmail.com>
Subject: Re: [RFC PATCH v5 2/4] mm: distinguish large folio swap allocation failures
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, zhaonanzhe@xiaomi.com, 
	hannes@cmpxchg.org, youngjun.park@lge.com, baolin.wang@linux.alibaba.com, 
	hughd@google.com, chrisl@kernel.org, kasong@tencent.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, qi.zheng@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4EC5AC000B
X-Stat-Signature: t1ptw5fkfjjbs1hjh7pebegdi8retjhf
X-HE-Tag: 1786371128-953341
X-HE-Meta: U2FsdGVkX1/F+G1naNUDV3cbn3nf6TBihgO1bE5BHcHf0IebZy0OKzpGaMJnO9xflQpem3eSi6EkYJ0CcHD6ZGoNey07/EvvFPidJkfCr2onCNsABJGtIuxmQocTLZHYLTeEfu2ndRRYew7pGI4jh3evqh5QMx+mf7fKQNLS1LdTR12OrQh8nKqjCSQtC0zMcNop+P8A94gUQ6dfAYUAmSGGqYvCSw0TlIGbuggkdKW8fXTYJhTUVWSP5wEhHypmubmcpq3TUWjG/stqq9oHEAZfwfdCk6Ww1ws58lpQ82Fx2qo3+jDZvPe5wH5BI6+dx/voEvbpHNSoQV9xTjYZJjHJzZIWBcV3un7l+gocr3YLkmEBDB5vc4kgHP5XEioOrGZ4VsCJHupP+PaemTBjg3D8K3lYlMXQQkn3loYXJvki2+U9Hgza7Xpkr6COhnKE7UTOmkDfftvaRvRDVCTVPHYWoC9lqfXy1uON+26vCDIQDnnJUe5sUBXKljfmWbCoTh9/xMYq+4PSssvgkk913AzFoF5FD8I5u5F7p4j6J7oX4FiN4yTj5D6TE0D2Y19nIiv5Digt3uTWLGOn1spO9mzinSVUqrCHlR05ABSffhb8uEGvlK051O++1qqCKSlofSJdjo0ucPM4Xs9udAuGPVJb/okARXXO9oqxwtLN6bIkgiUpgNNV1XqE8UwGGSIhvIYe/beNA/bcI4bo3k2SAg//Khf3YVm47H7bRpbuFc+I/fgwVBvDmnQAvL2qni64XD7tkNtGopRa7CG4tCTAeHaNW+cvccyfepgMJaxiZCsooEoSn455TBE+7cdPx6pvgh8gfJItmRJKQW/6Z9vNP6F352CxP8sEwfc1HeALp6LkWonOiJTuh0TlmlkG012inIkSwaoMLShZhsOc5N5rMhjA/tEB+A/sCaJGHgD+6cyGrhB/9P/VhU/y1GWI8+rPakm9DftYUQ11C3yp4bl
 kViRCJEZ
 U42Tpl0/HaTfZmLDERV7QB8AGnHzWPtFq/NFB0hgXGWMAyBu0MVOzufQUVXpoRIZ9MIXI/tCua5TXVbSH/l6JeJ4B/7RZKKwyg5rVItWumkBr/ghqYCJpHMvxj98jFAdB9pErRmJ6LR1kmyPYnOZE4s49x9A4OtZYDUaFhZEZ1u41K4cnoJUlD08SQIuT02LlbsysjK73VTphSX2udRGJoN6rRt0PvGryzZ7PFjvPZxPjL4Btl8JrgDnBFA45tu06mKZPFljGoLQEyzCC5WIX4GW1NvzeAgLi0lgvmFNMbiTrhkut6XVKmG4POEXJRJgxZohi4d0RIG9H9EVlUv3x/t7d3xYZ/mpbcVnXGg4wkSii3ohgCIuGgtPskp7R+DxXzUwPPqOn62tn30ep3FlTuZkkk3ZdooaJWEjMwikm6PCTI9BP0iZ2pmB95ls+3uc+pl1iIH//SqxbXHiTKFw+RoGZyHW1VZjgBHirIsl5nwT3g/8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 8, 2026 at 7:12=E2=80=AFAM Barry Song <baohua@kernel.org> wrote=
:
>
> On Thu, Jul 30, 2026 at 8:23=E2=80=AFPM Xueyuan Chen <xueyuan.chen21@gmai=
l.com> wrote:
> >
> > folio_alloc_swap() reports most allocation failures with a generic
> > negative error code. Reclaim cannot tell whether splitting a large foli=
o
> > could make progress or whether there is no backing space at all.
> >
> > Keep the global free swap count and the remaining hierarchical memcg sw=
ap
> > margin as separate inputs. The memcg charge path reports only its own
> > margin; folio_alloc_swap() combines the two layers when classifying an
> > allocation failure.
> >
> > Return -E2BIG for large folios when a smaller allocation might still fi=
t,
> > -ENOSPC when no global swap space is available, and -ENOMEM when the
> > failure is not helped by splitting.
> >
> > For early large-folio rejections, check global and memcg swap availabil=
ity
> > instead of returning -E2BIG unconditionally. On a memcg charge failure,
> > swap slot allocation has already succeeded, so use the remaining memcg
> > margin to decide whether a smaller charge might fit.
> >
> > This only refines folio_alloc_swap() return codes. The reclaim callers =
are
> > updated separately.
> >
> [...]
> > +
> > +failed:
> > +       if (get_nr_swap_pages() <=3D 0)
> > +               return -ENOSPC;
>
> I wonder if we can do this earlier when swap is full or disabled.
> We could exit immediately and avoid trying many redundant paths.
> Have you tried this?
>

Hi Barry,

Regarding moving the check earlier, I currently have two concerns:
1. It would add an extra get_nr_swap_pages() atomic read to every
    successful allocation path.
2. If the failure-time check is removed, the earlier snapshot could
    become stale while the allocation is attempted. The failure path
    could then return -E2BIG even if global swap has since been exhausted.

Thanks,
Xueyuan

> > +       if (swap_margin <=3D 0)
> > +               return -ENOMEM;
> > +
> > +       return order ? -E2BIG : -ENOMEM;
>
> Best Regards
> Barry

