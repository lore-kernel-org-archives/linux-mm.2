Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E85CFCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 00:19:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 375A16B0180; Tue, 26 Aug 2025 20:19:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34CEB6B0182; Tue, 26 Aug 2025 20:19:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 263778E0105; Tue, 26 Aug 2025 20:19:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 141F76B0180
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 20:19:27 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8D5D158B6A
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 00:19:26 +0000 (UTC)
X-FDA: 83820628332.05.7BEF53C
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf09.hostedemail.com (Postfix) with ESMTP id B1B37140004
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 00:19:24 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DtRFxSXv;
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756253964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SE4j56bcgneni+baZfrodSksw7MRxk2x9FNKN/g2SD4=;
	b=w3sAa1/i21neUKkXk3jiKy5/BbVmKOyVkDZKpJ2DymkY0NSQIQ8bnM489Pyae86Tr/Nb65
	jD9YekEndwkByZ/vZKEUXIGU9V/kplBN4rRuONf0sfY5Ni0gZFcHOwWFcxFuBkRR6ZY2xU
	zECfGyA8D5fRpG49Y9dvErPu+AijvcM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DtRFxSXv;
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756253964; a=rsa-sha256;
	cv=none;
	b=rfYg36E1gNggTJhe0DzXIW7pA0V/MPIYDkOD0V/yKtDIEzg1zsMWS4e2Y/pKdsT/sHIHbS
	CPI9Z0ysVjOSfIUKDWKvYG4xpCvoGoE1wZnqdljCN++FnfytUqR+wcxGhgWlzi5t0bB4Rg
	8X5ChwWRN7VBi/gZ6iMZ6jjwoXddV6E=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4b29b715106so80061cf.1
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 17:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756253964; x=1756858764; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SE4j56bcgneni+baZfrodSksw7MRxk2x9FNKN/g2SD4=;
        b=DtRFxSXvEVPkTDAZvYczTKUBlSw1i+xlcdw3Qp2rkPFzVS1ZwIHYMyv9kSDT0vo/16
         jaEWoxenL7JeFW1CghE8Nk+RAUq0qC/m3DXlAQlH1lvi8YTv5mdlFkXXepVDWM6ctREN
         dL/hKNVtK7WOrYMWfbTdgjaP4vyzqlkI1dtoQXtup+5zhMB+VQ5t7BC6SDNCoXwvJzMZ
         VZwNTjXLz+AznqH9jHIMHItsQOhPALQQrgE8j6lUIfySaqIYLfIVpuFblOy4mhSwAG/H
         GO7tOLMJddHDosXDx/cYPLaPseBjGYYLuLjd2m6zjqP14HSYLPJft3Sgf1NDIAjbT4Hx
         n+Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756253964; x=1756858764;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SE4j56bcgneni+baZfrodSksw7MRxk2x9FNKN/g2SD4=;
        b=veOUqV/arf+kqIlNX9cpXSRBJc69T5oosxbdKbkVP+K1yZUboMh242SU+qoz8di5R+
         UNRbDy3/kjUOyWWnXA+ZQ0pE6Czuq6OBszICT4HF/pkERoQxioEel2DlShHTCTUatiE9
         a0VMPBZhyO3pVXPGZFS3CWO0ohGPxefv+ffolpkyS0HVlns35EmpSq2IkhA2rO4vECUT
         nmGcGu5fawzJMq1+5t8bPiPX+qvMGp3DKnvhn1AGwki1DyVHijMdM+Pvj8Rpl1IP0TQE
         H9CV1G0wPnaHrn9FXhlQfmn7w0js07VVkyMu2ke9v9EG1kQqfAw3QcKOxa4hMQAGkpOR
         mTlg==
X-Forwarded-Encrypted: i=1; AJvYcCUTkDMlsqN5xMURcSQbCl0u+vD0olg7RLppasSfbaiciA1Xi1gAfgnab5B1LmrJBIYkjdI40MeDkg==@kvack.org
X-Gm-Message-State: AOJu0YyVytMjptnVbGfGHSMjLmeQ3pmm61XFmfpb3WSUM687S34yDWS5
	l62+2K9bZ3+EFQF8WTXTlvTnS0NSOe8J51iiH7/9dvrdmaMhAqm8zM179dRfguBeCyU8IjvTeh2
	a9Oct2mXH5hXHwd21s7SGoxrzFS1tfT5iYn0L1wFp
X-Gm-Gg: ASbGncsiJqjOr/+NWEQZNKwHezShMoLOelLeSU9Tz2ken9SCVGKAXBGNGAqzCxbhNaW
	QrJTqWrLieiC9sqPRnJsYZL4p1V/F6snHmAcd7st+9qKUDsYT1I9zh7g1YN2fLjUpLEX0gq+SPm
	aa9xPm+JO1K9bF1HWJeaYWllJPag0V2HySncQm/15Dnm6VYay9T0xyuJ0mMz5e7Hvftib/OkHUI
	j7qwcNkwh8Z5gmBcPTqIag=
X-Google-Smtp-Source: AGHT+IHKzkOVA97IoeFOhKzhjh88sPk1YwIXvTlOSZoPINFWeat9lSKrAMubEHDbEHy9C13HrZIHNUop3Q+tYrmsAvA=
X-Received: by 2002:ac8:5a42:0:b0:4b2:939c:9c1a with SMTP id
 d75a77b69052e-4b2e2c4f835mr7873931cf.13.1756253963326; Tue, 26 Aug 2025
 17:19:23 -0700 (PDT)
MIME-Version: 1.0
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
 <20250723-slub-percpu-caches-v5-5-b792cd830f5d@suse.cz> <CAJuCfpHR=hceuAcnaCr3Hg-3mknvsmYy7jSScA8SATn7iwoN_w@mail.gmail.com>
 <711d539d-da4b-4f77-9be6-ca11b6fa5162@suse.cz>
In-Reply-To: <711d539d-da4b-4f77-9be6-ca11b6fa5162@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 26 Aug 2025 17:19:11 -0700
X-Gm-Features: Ac12FXzxRQWqZVSs96sDjlJgMo-UL6e05LwJ4TtNEU1hDljVd05nsUaqKjsm23A
Message-ID: <CAJuCfpFC6XELVof1xbJ2rZoxX3rHQfd34Du3=N_UeinM2DzPVA@mail.gmail.com>
Subject: Re: [PATCH v5 05/14] tools: Add testing support for changes to rcu
 and slab for sheaves
To: Vlastimil Babka <vbabka@suse.cz>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
	maple-tree@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: dt9noyjpwrtun7a4qbbn15771rt134rm
X-Rspam-User: 
X-Rspamd-Queue-Id: B1B37140004
X-Rspamd-Server: rspam01
X-HE-Tag: 1756253964-835735
X-HE-Meta: U2FsdGVkX18xxB9SMDUfhom0kvXc16hTw3IwLBJ2a5jdOcKS+2dCM/RmP9Xqg56BIdMmiEZErfFodwVuDFX5FDkW64xGSMl5qXogzuoyiAHvu1ogovrdR/7devj2ACe0/yu0L5Kty0KUTcv36X+6z54p567x4lZh3aZ52ECLVB+WIycW1Gj+0sxaXz2ue0t7IYWqf1vmvXoh80Sa+1QVqHYHpPDS6t/lYCV+FkJxhUrLTepPhKuiz4YpL76N8zpTAxsYjpKdIcgoua7cVIZtv0hVaOPlIH3FGEVKokvfTJ84qlmCSH1B3xK/HYJEJOO3v8CSq/akpSnO/cQt7NXDtlCMB+nGEvIlmArPebXqoMsyQiO99qhmYzGMxmdtctGGnUUsjkaUI8X4IPql2qSVL8oCX3MXumR5M9u6FQRPI68RYhPJwGsbVOZBo66by7YMLy9cGvOYWz3sHPaOx/2BWgLua3alOIiK4oykMWlVijEhQ7X6yQFFpDNShAowrxvrILokm8PkbpG8qDcQgYngSPz3iOULYw9djFWBGShXE+Nk/3gasE0dmtygNxxlN43S6DGgCeTR1Kq0WbucHxw14LPBdYfhy9aorjh1qE9EIF0gfEKYpTibqYtviaUCbSbycwnfUSwwgCF/bZZ+GcqTmJeQqfUvpSqsE3qlEUjMVE0gPqsrdrCS5du8o8lc7bJ0us0FnmU5X62o3FEeCJmk5KToS1jZ0eBtS7oxOq7zpqJxaaINsmw4UjM+d/6d0Rs2oMRmgDgEXqOk9Rl5QCUatjJoASpB7mfLWIFqGn+lkDDPOTU+G5MWXpuQ/extb6Ij9g6iRmB16QbXjHt09L7PCmzYKyirEDANX5SB3BSFlM0q7yZvfDKusa5T63KTFaBMrmsMEgvoRuzKTKlo1XxHsgiYGn+HK1jVmdluTwc7DkyLy8LVwu1yDEy69pDzfBLIUxS1cddHJHZldH1jJtH
 xyD43rei
 Ifxk9nl3kivUn2T5Elpl5ODeb5hBIvBhf0CnCphU+lZPWWjQVDiKa0cgJWWrTbN/3eJNf1YwDPJLhpWapdgHHdQS1RxrxBAlZtFj2s3PkPgP8bm1WoFMsMMlU7TVywWqVQK0uPv9X6voCFk0MZtinePkbTqhizJ9y/B1hX25ufvZZQacF0VXVirVCK6a9YVt7Z6ZLe3BB9Z6+8avLME/iz72d2QvPFNvV8aP1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 2:32=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> On 8/22/25 18:28, Suren Baghdasaryan wrote:
> >> diff --git a/tools/testing/shared/linux/rcupdate.h b/tools/testing/sha=
red/linux/rcupdate.h
> >> index fed468fb0c78db6f33fb1900c7110ab5f3c19c65..c95e2f0bbd93798e544d7d=
34e0823ed68414f924 100644
> >> --- a/tools/testing/shared/linux/rcupdate.h
> >> +++ b/tools/testing/shared/linux/rcupdate.h
> >> @@ -9,4 +9,26 @@
> >>  #define rcu_dereference_check(p, cond) rcu_dereference(p)
> >>  #define RCU_INIT_POINTER(p, v) do { (p) =3D (v); } while (0)
> >>
> >> +void kmem_cache_free_active(void *objp);
> >> +static unsigned long kfree_cb_offset =3D 0;
> >> +
> >> +static inline void kfree_rcu_cb(struct rcu_head *head)
> >> +{
> >> +       void *objp =3D (void *) ((unsigned long)head - kfree_cb_offset=
);
> >> +
> >> +       kmem_cache_free_active(objp);
> >> +}
> >> +
> >> +#ifndef offsetof
> >> +#define offsetof(TYPE, MEMBER) __builtin_offsetof(TYPE, MEMBER)
> >> +#endif
> >> +
> >
> > We need a comment here that concurrent kfree_rcu() calls are not
> > supported because they would override each other's kfree_cb_offset.
>
> I think it's a bit more complex and related to the commit log sentence "T=
his
> only works with one kmem_cache, and only the first one used.". The first
> call to kfree_rcu sets kfree_cb_offset (but what if the rhv offset is
> actually 0?) so the others won't update it. So concurrent calls will work=
 as
> far as from the same cache thus same offset. But I'd like Liam's
> confirmation and the comment text, if possible :)
>
> > Kinda obvious but I think unusual limitations should be explicitly
> > called out.
> >
> >> +#define kfree_rcu(ptr, rhv)                                          =
  \
> >> +do {                                                                 =
  \
> >> +       if (!kfree_cb_offset)                                         =
  \
> >> +               kfree_cb_offset =3D offsetof(typeof(*(ptr)), rhv);    =
    \
> >> +                                                                     =
  \
> >> +       call_rcu(&ptr->rhv, kfree_rcu_cb);                            =
  \
> >> +} while (0)
> >
> > Any specific reason kfree_rcu() is a macro and not a static inline func=
tion?
>
> Think it's needed for the typeof() to work. The kernel's kfree_rcu() is
> similar in this aspect.

Ah, got it. Thanks!

>
> >> +
> >>  #endif
> >>
> >> --
> >> 2.50.1
> >>
>

