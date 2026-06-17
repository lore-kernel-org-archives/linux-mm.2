Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26733CD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 14:40:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01BC26B0095; Wed, 17 Jun 2026 10:40:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F360B6B0098; Wed, 17 Jun 2026 10:40:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E23E66B009B; Wed, 17 Jun 2026 10:40:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A0CCA6B0095
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 10:40:15 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0ED7914043D
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:40:15 +0000 (UTC)
X-FDA: 84889664790.05.5AD62B3
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf10.hostedemail.com (Postfix) with ESMTP id 11C0FC0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:40:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="r9/lbg62";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781707213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SrECtSXktFVmwe2HfKzsMsXW5gYWCynhrT414gDrZrU=;
	b=VXM98vcpyZ0nrqaKTsF1n/U5GIPMtHhJgYEkzVClj0m0LK9vDt7++sNE9ctHF+/55q1S+o
	Kfhcdp+3ltX7vp3W3dWN1YTjUnibVKaDPOi3VoNoo/XM/zxinaSv+onlCjusv1ZuWe38e+
	z1rDJNytBiTYmtAmgp5BtF3yLlSiw1s=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="r9/lbg62";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781707213;
	b=4v5/zFtFQ8OijktYphd3859TyLg2veaxm+og1SuOUfRwT0AOfmdUt8TpvCspK3s1A1rhA/
	D9CwbDwr26S3dR974H0qmNNEw5wGZ3sdx6Yn5cc69PH6aKH9yueJZSmlD4Mi+nRHEMzXAW
	zCmtVLg8uYo0xN4poHshqVFEh/XnNS4=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-5175d339e8bso282711cf.0
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 07:40:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781707212; cv=none;
        d=google.com; s=arc-20240605;
        b=BpkRazjK4Es/3RZiUep5tcZnCdXWZxPjE1M3nW5SaqbkFLIr3OC8T9diOYUsbBHkTw
         zob1iAlPKKixciIXZwlhlcd2skMxrBGZMcmEMHhjg47sPDdXE+Rwd8GxwNwn6lPIvXbw
         u/9h6d9YYeDyo8k0bmuXew+sSLMVG2cE+TJ2azPgS83uPOMWURydKtAzCrNVKInXN9y/
         uL0tOqon3Dgv0aoJ73XoRp3ZcFGhyV4zzlJ5sxjbiDHNqgc520rld6WNVIXfzMs/1Pwm
         VwX9NwZ0WwYm31Tybb/dUjVT7/ylptb1h/VGNVUd0aOM7zVJ2JY0o09g+Ccqdkz7n9S6
         8H4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SrECtSXktFVmwe2HfKzsMsXW5gYWCynhrT414gDrZrU=;
        fh=mtEgT1QNFcb023Mh8y3YirQHG5vewRBKr5hacDLirnE=;
        b=iU2z+gEyGKo0JinAAEV/oVrqqr6jRN1glUbDXbq+WEVuiulcTWkO1BZuDZmDK90eCt
         lMDOzblY7d2c8eRztVRkuzO2kC8+3Hgpx0MeqC/QT1nfIhaqDcOdPSGiXxGJv+5BBnjU
         xJmUhMEd9EEPfdVtYrW33fCdOjbumpN7OzS/O+1Wf0v2xo80dlqciRLF8+nsGs+QOPaF
         Vy+je/SMFcRON++T2L2BM/bUnk+hS2pEsaq/pEZbS+jEu9TQFXerNZcJ8n/4bRg/mg1y
         W07OuemjlseFNLMXj9dZFVuQeA1a0jQGatrnwSI7on94ySujlpvIDMmAtvGp+XSHAFAH
         eU4w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781707212; x=1782312012; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SrECtSXktFVmwe2HfKzsMsXW5gYWCynhrT414gDrZrU=;
        b=r9/lbg624sqkikMQWCuNLZYM51KWd97WYDK3joiwIxfPz2E7vTc615IU3zXjjnfprS
         9EBafdaTCxsE/ib9uKFMBqwGEbNSpWeCIVbcrv3D0r6GW32apmDxNC+wRAJm7+/rAJax
         kCtZRu4tYnhWfmg42ko+aCb12CnJ8D6CA1fHbZt2H8YDZCV0L8DJiPJHx9RKgABLirsT
         30MNg5M93BZOjB095UoOnNHahHi/zmhg2xyfxqRf45xNvbPQeJUkf+BxeMahH/ifk0lX
         Or7T+Z3gKrDjnCMYh9b5Bo3N8mnTVZTBM/FAjR+N/nAb3/x7fUCb9CjSlOOc3KOLCUUC
         3uYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781707212; x=1782312012;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SrECtSXktFVmwe2HfKzsMsXW5gYWCynhrT414gDrZrU=;
        b=iU5AX/hqbTlKzAZXOwoPepYVq4V4dQQzIubZTQ02s4gJuycf+BBdSOsTxrvnS0y9FC
         /5Oww+jm9oP0ZK2ybC6Wm9QU6X+JeqT8/tZs+854w7Cp2Eg1lk8d2mYzXacKbmkvO0I7
         x6GmsVjVdZTphDroGR4JiS3wvykofA3JDrKu1ofhPo4B/A1tcuTHY9QUK3Z9zs+DvHjp
         C2BwaN7LD1d7pzSY/TPoBH9zCdnVCdA8G5P4oUoPCWI1/QHBWsstOeFA87ujKT5s8ZOK
         luNhNZ146N9Dp2eUxFj6BgiVY3KW1rNxuKWr7Ry82rvgWv7ftLt0f49fZguSJukQE3lr
         LNlg==
X-Forwarded-Encrypted: i=1; AFNElJ8KUEDwN+ZqtTIHxFxpXA/CmqpproEDF/8eYC9zURznFVaQHIiLAWQ6LNJ4xmFRQ5KsqMJTTU8AKQ==@kvack.org
X-Gm-Message-State: AOJu0YwCGGPTS7xskEsHjCst2MjTJLzPYNVAbfiyG/LdeRPuoynXiBFx
	Ot7rBaBJkHJMjnMdIgcfNn2ySpckPTpJeGQxEoqAo4JJ78WKmNEf0RvUdN0LwEeuxuwkCHQEGx8
	YsAEHTrgzr0ssVey0efNHFXec3iLaDk/71G5U1EMR
X-Gm-Gg: Acq92OHrxi5g4KI7eNqz4b9Mt7P2ApKfg4x3Qi3En5BX4mDth3hotg5rSIiiIE1lzD+
	+JP4LRZvJOpdJ5sct05A1UXvpPne+VWzXyKQxPh35Te/D2IYZ5B0V1Fv6/9SIduFpffwoVi7iEH
	hzcCBKFis9c3Uc0712kuyQL7cGxUY7+imH/LdmKvvdO9+OenhumtvrnUsUEu7qvmaV29BkDc5Vw
	ZnqeNsj9mQHYQeRB71dYfwY25EGpWj6kfWG/ZG1UJthOUGQawNWsWDQ9dBrqf2nBIoKIS89maBw
	SIPtPpoIwmLCCx5hmA5jHjK0d04=
X-Received: by 2002:a05:622a:1809:b0:516:ccc0:ee38 with SMTP id
 d75a77b69052e-519ad992ba9mr7504101cf.9.1781707211224; Wed, 17 Jun 2026
 07:40:11 -0700 (PDT)
MIME-Version: 1.0
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-7-7190909db118@kernel.org> <f9b7935c-f5f0-496c-b55e-1f3feee5c87a@kernel.org>
 <CAJuCfpE3XfxLmV-DzM5nLqYqGsFJThr-1i4bmEEqMpGZ28RLFQ@mail.gmail.com> <1c63fbca-6ee4-466f-bfb5-5ff25a847607@kernel.org>
In-Reply-To: <1c63fbca-6ee4-466f-bfb5-5ff25a847607@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 17 Jun 2026 07:39:59 -0700
X-Gm-Features: AVVi8Ce_vCvZNT5yYs5Y8bQHsLpdQUSPne6OsjaB_y8AFj79h8otRJdz2a0FfJg
Message-ID: <CAJuCfpGiDKygFBTAwwiBaXL+dGJjTR232Rd_ARTyAtjEAMkDZQ@mail.gmail.com>
Subject: Re: [PATCH v2 07/16] mm/slab: replace struct partial_context with slab_alloc_context
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 11C0FC0005
X-Stat-Signature: kko6ydyuegawkp8sgeccydjcbfn71tnp
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781707212-573061
X-HE-Meta: U2FsdGVkX1/nWf4pB9u6ByfIh5aYvhGWgaXdjGMH5C4yZl1Bygyi0eyDY+jHR6z77JyxfsNVnXWzLVhfAULuZTUy9p6kYnHUkUDEDujK5O9zelaKZ+5PBpLwPkf3v9c4IAqcq2YrOu4h0unIHIUhGMAOEw7HW9vT4ygXazdVG16kaJAGxyL3WBmnxcEWwvdzqi5LAsFUg8IKmnZmg61XXgSQcd+yZAMoltTa4/EdMnY6Q9DLl69/D5uMUZPoQd5PCd1k98sCKjJ8wf2+1YxU2iSPvTT+/Yq+0ReuXE0z2FbdclWrJSl60mfak7qdO1vAukLSYdy6SWxybXnZIKMq4mJYOflEfJKq8jfvxgLWPS+1bnJppJtfn8XxoUqt5cqqksJVb+vwmXe3ANYmBgbOztNlFBhKJAkjxLJsXlZ6SNkybrANibmSc8e+NosB7F3cbY652CuIocyvdNoEK2+hQHlaMUaLjb7WM5Dte6xW7sAhYggguITKXHg6Tn18vs2F2s76wJRB7jMBBgeG4YfyEJRqedzq+6JR13LlaYZFlxGXRasIq2qTJ/oC+pDZ8rzFxwT6jyVquTIWZLZGdxNaBuFdsrfJMmsZVEQnTdESJyRzyib6HBzF3k6zo+FMfsEXHmncvTBgSC7IvDWdF12+j6tOz90dWgaTlQ5OkGGWHT26PubIw/OtHFxfoHnguwiWYFDcQuri/yu6ohVEYNFNt+/qDUtvItQ0YvrbATFQNOw5fcmZMebFB536J9goujCXjocg3UUpznDXHnqMbu3HV0y4Z3i6NHiTvogPHnPeVjBzurI8TCVqpUs37EPcsT6CDOAYYXNwrzUH5skf0pJegP9ianDsc+lnKy/lveaUJegzYFTk6iC1/B8bE1y+jm1RPHtsk9gVNy4JuE6vl3+5Sw2WJ1wn0DRhofyGQRhC8o6TP4H1aUdZ+nm8IfMPQbBmKRvtDjHfnpFlFH1yyyC
 NPthfG8J
 c3yrOFxQm+QCCEYjSNBBMp1z08kKdZo8jljpyJKLzTT5LxkuK5nX7m9vTKBEmsYHo+cp5eurh6g9NeINOlU9SnKt8GPgDzBuarNZ53sXWeuRA6VHkgzoB/u13VbBCjPaYm16xgT5d6fxZon0Ga1hORjhT76f/GpPy+BDq3ptW6Z7e0uGjZHfcjzfd3IZO8im+negDevFld50S05vSL9GV80d1BaJzckqE4jd3coXbKjApUzWR/KoBCmC1ZRZsl0/E+8tJ5+alQtmlXymq/4DhXBr/TUxiDFSPLRLNwek9tG1dzkA8dfiTvUYJcKTRqEeoR0GOC7DUzz2fvgT71afFPpdUJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 15, 2026 at 3:01=E2=80=AFAM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> On 6/15/26 04:36, Suren Baghdasaryan wrote:
> > On Wed, Jun 10, 2026 at 11:05=E2=80=AFPM Harry Yoo <harry@kernel.org> w=
rote:
> >>
> >>
> >>
> >> On 6/11/26 12:40 AM, Vlastimil Babka (SUSE) wrote:
> >> > Refactor get_from_partial_node(), get_from_any_partial(),
> >> > get_from_partial() and ___slab_alloc().
> >> >
> >> > Remove struct partial_context, which used to be more substantial but
> >> > shrank as part of the sheaves conversion. Instead pass gfp_flags and
> >> > pointer to the new slab_alloc_context, which together is a superset =
of
> >> > partial_context.
> >> >
> >> > This means alloc_flags are now available and we can use them to
> >> > determine if spinning is allowed, further reducing false positive "n=
ot
> >> > allowed" in the slow path due to gfp flags lacking __GFP_RECLAIM.
> >> >
> >> > Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> >> > ---
> >>
> >> Looks good to me,
> >> Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
> >
> > Ah, nice! The conversion I was anticipating in the previous patch...
> > I would do this removal of partial_context as patch 6 and then convert
> > ___slab_alloc() and get_from_any_partial*() altogether in patch 7. I
> > think that would keep the behavior of the ___slab_alloc() more robust
> > throughout the patchset. But I would say it's nice to have, not a
> > must-have.
>
> OK, so I switched the order of 6 7 and all the changes from
> gfpflags_allow_spinning() to alloc_flags_allow_spinning are now in the
> newly-later patch; the "replace struct partial_context with
> slab_alloc_context" part has no functional changes. Verified that the end
> result is exactly the same, and only updated changelogs a bit.

Thanks for the refactoring. LGTM.

>
> > Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>
> Thanks!
>
> >>
> >> --
> >> Cheers,
> >> Harry / Hyeonggon
>

