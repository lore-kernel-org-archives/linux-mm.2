Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0287CAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 01:23:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F19D8E000B; Tue, 16 Sep 2025 21:23:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DB828E0001; Tue, 16 Sep 2025 21:23:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F20F98E000B; Tue, 16 Sep 2025 21:23:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E1CEF8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 21:23:55 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 89AB013AA2D
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 01:23:55 +0000 (UTC)
X-FDA: 83896995630.21.8FD7FC3
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf05.hostedemail.com (Postfix) with ESMTP id C94E0100005
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 01:23:53 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=s+V9uJDp;
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758072233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W+EiXNx8dtxz/+fZsWvTHPG1d2wMczWl/IjgW9ZTzZA=;
	b=LU2yi2oLK6kd47w3U67wL76nFuF/mQSgVSi6f0iy7b3PRVR7qaWhSHc6lL5IRO3Yva9E2t
	riKn/HhcvdiZjdGeh/FykJLjABBQMBUEE7YhC+nJ5jQt4D2iviMsx4IMrEx04LAto/8Ee9
	n4FFAIUn1SphiB6yXfx/eQU4+fSt++0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758072233; a=rsa-sha256;
	cv=none;
	b=cqlRFEu0ApE9X1LtLIJlHgPHC/S/FpnnC0iYtdCd/w+W5xmKkdUJfE1rjIigkZdo2t3QeK
	ebegya/GD5gZpWuxnL4JlkWagIgr1KgouxEeXSFLPJ8s78oy4yv8RY8b/1Dz1n1uAmbHpU
	2i1mKD5RHIIHRjPAzQlHMzk9yhCxyGI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=s+V9uJDp;
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4b4bcb9638aso271701cf.0
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758072233; x=1758677033; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W+EiXNx8dtxz/+fZsWvTHPG1d2wMczWl/IjgW9ZTzZA=;
        b=s+V9uJDp6TqVJDHICDkvcwQgL+YBPNbKERlBpgMYB7DGaU7lui74B5qX1XkxfRKw9Y
         QL1dnfvh/M9f8JFi7fi7u2tZe+ax7PAYs5MOvMyK4kA3Q7+9Oj5auq/fyAGpOXavuxbY
         DDoBexvyqyKCbYNNUMbsQdSIwHrZkW90awAL5Tl2L6ZwnO3k3g6dzMiAi3643HzWhGX+
         4oSJ/FysYPbMSgQ8biTvyEWut9B3SFB5PsbZD0ED8OAjngPzbTR3aiP45HEnr/fhhpJi
         BLJ+KeEQg35SRuAfWTtURqDdeSeM85pQ/XSkun2KBaw6Y8b6kGB4eklOaex+KCPtkDb4
         7SOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758072233; x=1758677033;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W+EiXNx8dtxz/+fZsWvTHPG1d2wMczWl/IjgW9ZTzZA=;
        b=OHMmzBaSKfnqlw1A6pLRIrnmb00RfSmDM5Fd3aFVHqhdl8hMDQbKmMZ46/3KnBBQ9o
         M++R5qI7ejMSP/cfFnQ+UgsZ2eu9/o7gBxflx3HURbaVDzk+edtJ1EKuHvraJ4uR7VqN
         IbCQsuyVnAc5Cf8lbZv2Pskhw+hdhTZ/bUZg8jHZZ8U3HieAidxMCPpSJCBDklu0/2R/
         YD7QLoLIDCLUXVFaBCtcEAogkjFfLchhKixqxi0RASHlLYwIFESUDYXDoJtqYhw+HZsA
         ezSJktkpDt0HNGjfLsLIFTiZ3YrZNFHt/lf/J0y1dQZsfAFY96dFZEr1BuEQC9VQnvjk
         krCw==
X-Forwarded-Encrypted: i=1; AJvYcCVMxY9brAXrSAidhFDRdf9oFdO/2DRJ4v+nj7ev/YyOdk9fVgTYc2TnztzYv7B9m1PU1WW1VzAOGw==@kvack.org
X-Gm-Message-State: AOJu0YwfWxWg7ClYKKP4Uz14AknIgpY0ChqwTiKlchtCFrSLmRdPpUIA
	AQq+jrbsi1+u/RRx07xOcjsadYrjgJ7uMu4HjjEcxtPuGKbts428I9wpI91EUngPPrBT1gq7cEO
	ZoeCH6kWF/0Dd1x8h3ocpwn6b41fEDt7EglM9D2OW
X-Gm-Gg: ASbGnctOVQTmaMNwblMNNxOOYnE5ADSDKFV4oFJP1S/ZIiDZF8f8Mpsntx1/T2dFG2m
	y+rCXWzmM9XF0vGniu6Gdmnguk7eTfVvkBWZzL3Yd5xbWQQDJ9HFqlboqOc/il9k7De4KHl6+SC
	aPI5ynb8viQVLtKdmYrIoO5GQ9FGs3g+pz3ObuqeEcCjZPlOxVe3ybph5/77zYUTBeaLA/HbiKr
	0I5S27NzONfD/81d1r66SVmDxYMur0J/KJWB//Zuuw/
X-Google-Smtp-Source: AGHT+IEGfbNLdY9Zz9j0iuWs6cvtGYaYD+/KMgA+FTecFBbknYC9JaklpTiRGCZw+lM+O/GtymNn4cMAIVCqy8k2pLo=
X-Received: by 2002:a05:622a:24a:b0:4b7:a203:259f with SMTP id
 d75a77b69052e-4b9d8d7db1fmr3405451cf.6.1758072232605; Tue, 16 Sep 2025
 18:23:52 -0700 (PDT)
MIME-Version: 1.0
References: <20250916160110.266190-1-surenb@google.com> <4c4e97c1-7f93-4c09-a235-ab169a998ef0@gmail.com>
 <20250916175639.2368772636d5e543faa5b13b@linux-foundation.org>
In-Reply-To: <20250916175639.2368772636d5e543faa5b13b@linux-foundation.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 16 Sep 2025 18:23:41 -0700
X-Gm-Features: AS18NWD0xD4IiCMhfB84LnzUSUy3Z4XU6JKVgWEYvfvpM7oqam2VIITG9wpTel4
Message-ID: <CAJuCfpHQMcGJBu=qjN6Qy0XqmLikqeWfm6SW+S9orOPk=m21Lw@mail.gmail.com>
Subject: Re: [PATCH 1/1] fixup: alloc_tag: mark inaccurate allocation counters
 in /proc/allocinfo output
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Usama Arif <usamaarif642@gmail.com>, kent.overstreet@linux.dev, vbabka@suse.cz, 
	hannes@cmpxchg.org, rientjes@google.com, roman.gushchin@linux.dev, 
	harry.yoo@oracle.com, shakeel.butt@linux.dev, 00107082@163.com, 
	pyyjason@gmail.com, pasha.tatashin@soleen.com, souravpanda@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: gnoxmatcs8a1ittk9r37de84uxyiaq35
X-Rspamd-Queue-Id: C94E0100005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758072233-236069
X-HE-Meta: U2FsdGVkX18de3dNcsXnYcLi0Pf+xCLaCqRcndO3kIPsWAI0Ta6sreLm6xyzDKYG3BmeNjzTs6zkeGY2o4kl39YoKjyyXjq8W0nEJsQ1U+nNOKM6LXU0b4XNeu31puwfiVKGT0vXZaZDJtVPfBubJMSTtxyNtRZoGEx2yaXtYj3a+mDouZnne6GcSjPa8+an0sDlJXsJ9wqKzXAvwXeOennXvQ/PGW07e0R0JOk0GoqbJdxYQpYkV2GGkgrQyXC/wXRTLXng6G+EihR9MFXx1gaM4Ey6jOHjixXNmSD+2jSwDYB7NWYpYaZkHQA2Cs5nS/ny4L6RawtyskTVKeEnOtfqZD9DobXSquynfuKPD9Ia5r3+8lBrSjQ3wpBH5Cje6Zt5gODnzN6KgoOLiekZl7pmoT4e6hxcUHGgklQGD4gT1+FnaGrOQ4dTzBnFHZn9XKFyelX/vb4HP/BNqYFfT7NgwOAHROgkFIPKMaAlVbP99m3P3YyoUKtskrweZC7VHcwnq5PTAYd3s3Va6JlMWROA8la5/hxmcwgASjNk+jc8W1r3KZjSUps0o1BlbfBFWEdEIqBrS4SFDNJW5O7Up87uvxWCwV+jd8rVbLw/F2w66j3TxvVuvDEzQdD47KeiWFmkWZo93XmYluMN8CWK7x7cB4Vx4mOjftzVECN9R0Awd6guQHPx1JFOibeKYsla65staeRDVRAOnhiUeEhuXj7a7yypcgxBOyltprZZ7G/PovgprDaDwpzyUvJw9KfGbk1ooF8DWweXVjGxUTYvBle3EluT8owk2PNIAOffI2Jid9TY99//Lf7ua5yoBuRdWhKY9661wgKaNLgwQwB2njniNIpWr8grWjwMfps8nlVkyToBD/9VdijTqKhZ7X6iA2597FjOZE/xvTLMoY5BGPRgH0I7z2KpHOdx4UqAYFVSnLhJKcFxsCTU51KK6rBdgzLm8To/JLQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 5:56=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Tue, 16 Sep 2025 21:50:51 +0100 Usama Arif <usamaarif642@gmail.com> wr=
ote:
>
> >
> >
> > On 16/09/2025 17:01, Suren Baghdasaryan wrote:
> > > Document new "accurate:no" marker.
> > >
> > > Fixes: 39d117e04d15 ("alloc_tag: mark inaccurate allocation counters =
in /proc/allocinfo output")
> > > Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > > ---
> > > Based on mm-new
> > >
> > >  Documentation/filesystems/proc.rst | 8 ++++++++
> > >  1 file changed, 8 insertions(+)
> > >
> > > diff --git a/Documentation/filesystems/proc.rst b/Documentation/files=
ystems/proc.rst
> > > index 1776a06571c2..17668f82ff1c 100644
> > > --- a/Documentation/filesystems/proc.rst
> > > +++ b/Documentation/filesystems/proc.rst
> > > @@ -1014,6 +1014,14 @@ If file version is 2.0 or higher then each lin=
e may contain additional
> > >  For example if the counters are not accurate, the line will be appen=
ded with
> > >  "accurate:no" pair.
> > >
> > > +Supported markers in v2:
> > > +accurate:no
> > > +              Absolute values of the counters in this line are not
> >
> > s/values/value/ maybe? :)
>
> That's OK as-is.
>
> > +              accurate because of the failure to allocate storage requ=
ired
> >
> > s/storage required/memory/
>
> Sure.
>
>
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-=
output-fix-fix
> Date: Tue Sep 16 05:53:33 PM PDT 2025
>
> simplification per Usama, reflow text
>
> Cc: David Rientjes <rientjes@google.com>
> Cc: David Wang <00107082@163.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Kent Overstreet <kent.overstreet@linux.dev>
> Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: Sourav Panda <souravpanda@google.com>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Usama Arif <usamaarif642@gmail.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Perfect, Thanks!

> ---
>
>  Documentation/filesystems/proc.rst |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> --- a/Documentation/filesystems/proc.rst~alloc_tag-mark-inaccurate-alloca=
tion-counters-in-proc-allocinfo-output-fix-fix
> +++ a/Documentation/filesystems/proc.rst
> @@ -1016,11 +1016,11 @@ For example if the counters are not accu
>
>  Supported markers in v2:
>  accurate:no
> -              Absolute values of the counters in this line are not
> -              accurate because of the failure to allocate storage requir=
ed
> -              to track some of the allocations made at this location.
> -              Deltas in these counters are accurate, therefore counters
> -              can be used to track allocation size and count changes.
> +              Absolute values of the counters in this line are not accur=
ate
> +              because of the failure to allocate memory to track some of=
 the
> +              allocations made at this location.  Deltas in these counte=
rs are
> +              accurate, therefore counters can be used to track allocati=
on size
> +              and count changes.
>
>  Example output.
>
> _
>

