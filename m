Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B4E1CD8CAC
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 07:59:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C42F6B0005; Tue,  9 Jun 2026 03:59:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 274806B0088; Tue,  9 Jun 2026 03:59:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13C336B008A; Tue,  9 Jun 2026 03:59:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0440E6B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 03:59:33 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A772816457A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:59:32 +0000 (UTC)
X-FDA: 84859624584.14.5D5BF58
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9ED31A0006
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:59:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ndddBDg2;
	spf=pass (imf15.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780991970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y9PReUu/EaeeDfL8/af6Ad78w7c8MNCmd0FV1i1S2HI=;
	b=wTHIcSAN69C2THP9FE0lU9tbVwvCohJ/Lu28zsjtqBA9Ry4TqaYfTPhoKWVw9pqG36cZLu
	teKsfwij9I8Z6VoB1Hj0yMmaLHq1q/JAuud1Q9+Hjg2BuhqvyOs6oNFY8Ra3AxF6bs7NU0
	wjXDrFQCWTwBITpe4xV6VPfp0FtwQbk=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780991970;
	b=WQwSH33hSth5zSEOMGsZtQaQTyrUKMj2RjOmTbrlROnzynwYivlVx2qBUADFxrHcZgOfK+
	v4GNbNL8Vpr6IpEe8r9S6hX5WtWm8WzZRsGDmQbh53nm45bskPKmqRs+t54nu02ZL/aDXw
	tU8kdYuTl7zM/BuSq72Ib4d7ceaJKFg=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ndddBDg2;
	spf=pass (imf15.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-490d1e54b3bso15119035e9.1
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 00:59:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780991969; cv=none;
        d=google.com; s=arc-20240605;
        b=Gc8d2hVkwXwmc/lGlZn/3qGPaK1Ycl9HKygrMvVTJ/EqAA7wjwF0Epu9tcmi0wkXx7
         4lrRVFJbr7t7LjrbFfl0iBy2mt4VGl4Myf9r1r4BBsBX0l2U3hOOkeOmPWZZRY/1mIjX
         534oW4yejzish9km2HaH+LhRuPBumGvQB7FOOJXan3RtL022cKBuECjCg+/gYZB6mCOy
         oaQY0g1NepuCjYg/idyTR/qguvkugOstwv/JA2SlIIwVU8EyC8CGJNkPWTXrzrYSw8ku
         QYGjFXAFlSXINib8dzEm3sWR4euztFfict7Tk/lG2WbUbHgWrUraFN6OrB/QsEddNlRy
         n9mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Y9PReUu/EaeeDfL8/af6Ad78w7c8MNCmd0FV1i1S2HI=;
        fh=FpROHed4ka+Y6T2OZrtfzsH1TUtz0zJBXJEUiMa8BH8=;
        b=h7xk04iKfSZgOlutc5BYnP/XI7sPltYNLsY1DJe/I5BNhdYvkGdEa8XTVzV9TqooTB
         cnEiJgSKxr+jXqZXcm1REWqQkQ+dzQ9jdh3BzcCW2t+A8bIWxbIL+TjO/HzvXPxSvyNU
         P/tas3I6P4cvdQoNyWycAoiF2Kcs5IqyAbCfez3nTDu30QpMR/EaeI79FnbeM0ALvQkF
         mwGEFAugqmv4IznTf3xzTA2cSUKlrfjAOvqqghFLEbtXrra/JnM0AnR3CpC/F8LIJ0Kx
         BCSebqVY0APjkissLpsGih7NfG/JtsoD/TnGoC65CLoMzazG/ItlV+eUHgRhiWSa9MG3
         +X/w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780991969; x=1781596769; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Y9PReUu/EaeeDfL8/af6Ad78w7c8MNCmd0FV1i1S2HI=;
        b=ndddBDg2J3J/XVgb6s8Iosyq6V6mswXiFphcMozLOEjXB7EhwMNyv2Lpe0pdtz58Rw
         CXljsJF+LqoJsnS2JYMUIAZNAeuQXMED8gbP6gQMCDAOTp8c7BKXdy7PEyeldKLztkPC
         ypQPZwYpw9gcutM6IjSFi7JH8knEjk8kAzxVkoeBVPLR4uAEd6Kdt3rMmSz7EcR5XswR
         Tf6bPa2u5lsh0uUDG5kmgPaOaK01cBR4b+Yr0ypWQPlSgk4Bew0wrmDvm2qNuvdO37kW
         CCjZce50+Rv9GbihD/65dywwhKqrYXN5AhvYYHe4IKMHGfs0KTa+S813IYTDF9EChQLJ
         fW6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780991969; x=1781596769;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y9PReUu/EaeeDfL8/af6Ad78w7c8MNCmd0FV1i1S2HI=;
        b=ICnO+PYmyPVPb8Vw17eg7Qg4zwsnLqOH5ZzQogFc0AA57QOEsolJrSiTkkWiYQxEhm
         eQx0w/RRkBhjvhCXdn2AuL504b1ljH1Eyyodz8vpitmC+d94Q9ohVndWvPxnb7WJPDhs
         YIxPhphbtG5mAtDsoJ/p+MFz9K3y5Jw5ydj5zJcafJ3KYAZc/bDNBeAWDLI2/lybBtT7
         wsRywQs5qy82+KCyG+PBznIX1WmJbSWERywI0LDspZJ6xB2liLki7QIUPVXKr0V5vgTG
         +jSCXaeHRqA6So/6qFPjP0G0i3EjjcTkv4EFjxVcDqTDRlB0DKlIocl+ZsaDe0HbUhKf
         REqw==
X-Forwarded-Encrypted: i=1; AFNElJ/vBfIkuXWyKMaQeh/aqmDS7v9XA7Xq1VRL7Jv46p6eplZ24/+ZYCbDuMWHoJM+wvtAFWNXlrUylg==@kvack.org
X-Gm-Message-State: AOJu0YxlAflNt2fy7c6oHmW6EWCNjxzlgRLwDX+sR5vniem81E+RGC/A
	YvYnW3NAXygIj7q+OEra3hSHlaS4Qpqn7oeqrcFSsgypPYuMA8FYR0letivJv0KX+Qkar20FlBa
	d7dfnFjV7sDIp2UzOVT5INUkiKV65D8A=
X-Gm-Gg: Acq92OEQvccDMX+bn2HPXiWhGBWimgjJqotI5apkktbk6RMOv9mUwIYxhqfQaepBvoW
	Nm5PvvKU7f6RwGXjLCFrNflrd+DdRDl9W4tLcz0TT/A3N8c3cBgY05tpiYX8H0d+rIPYOuOu/BC
	jDDlwBe1YXC98FK0t9td+jX1OnSYgwGjPI2GddYQLxqGiRrhuBGyUkA5PPcJ+r6rk3jAPKB0gmi
	tVKF39IrhTDVwY0vuAFLxtBcE+kJEttv5nvoS1JaMdZoEVbXruYv3isrwsAr+Bgs9wyChMrOOIp
	/EFrjYlZ1ItD/BsvkdDd43kV1TRQk/Nj/5g3+pwlnj4cY++NJ080
X-Received: by 2002:a05:600c:45ce:b0:490:9699:4428 with SMTP id
 5b1f17b1804b1-490c25c8522mr291744375e9.26.1780991968662; Tue, 09 Jun 2026
 00:59:28 -0700 (PDT)
MIME-Version: 1.0
References: <20260605031008.397328-1-kunwu.chan@linux.dev> <20260606005431.89186-1-sj@kernel.org>
In-Reply-To: <20260606005431.89186-1-sj@kernel.org>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Tue, 9 Jun 2026 15:59:17 +0800
X-Gm-Features: AVVi8Cenh6LOLR4E-MN3i51qzuz6qoCTcs-uWq0IAoC8TmllSpH_yFo-hCy9lMU
Message-ID: <CAN_Opa8xR1fP6Bp25ujmGiS4i3NEgXet4Pyt4kFtZZ4+LetCZQ@mail.gmail.com>
Subject: Re: [PATCH] Docs/damon: add TLB flush policy document
To: SeongJae Park <sj@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	damon@lists.linux.dev, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Wang Lian <lianux.mm@gmail.com>
Content-Type: multipart/alternative; boundary="000000000000a3d8720653cd8191"
X-Rspamd-Queue-Id: 9ED31A0006
X-Rspam-User: 
X-Stat-Signature: qsrz6qof1jj3rmuintw11cmxjam7yykh
X-Rspamd-Server: rspam08
X-HE-Tag: 1780991970-334586
X-HE-Meta: U2FsdGVkX18dm981+9ByUIuMO0Ewx8/DdrR/99/1aRA7KrhryvV+cEvCL4/9ViHEQjtkN+knjW+t0kijyqxdoG4Vs/0gH0lY9tBbrxPaur40hKQED7TaurCWOVBQqYsmAn87gfwWJBDuKnWVIgKiL3dTtw+VLB+D53sUHpZtRF/+Ov8wYhWZtLqtNPLdLS9SNoMH5aPwx3DT3AA9dRHjvMLkvC23iQk1ZFeFkY+GIoTHpqwxSYoMN6ZKvh1URFlTQgSqwdv2laZnAq8ELLV7hlBTdjlkmX7I9GIcQIClW4u0tRVyGsX+gayzem1B6rCmP+6xFatd1CtBirnsYqHXW5GOEW+yviNlzOc9FVqQE4BFKzW6qG///JXsKgF1fgZ0D6ZzGUWwCjE88Oxh8I+ptw+aT27fjeLj7y8Fu8nwxCEpAG88g6aGe3qDJEY5bRXKSVWtzbR2zr0KBPAkJz5HsYdSUiUvUPDDe7rdi5YWNw3oFzYP6AHo2cGkM/w0Udt3vuSUW+cKNuxq3IazWgCN24yCyO9D0Z4NvD6F7TbOSKBzT9s2sH1nNhFGYtvSxsvp1FQbUfp/RIbh4h+HymFeXlRQe1gDrP33gvKHvRSgirGxn3kMY2MuOZV2G6DF+hVxNXccPI99DihvzY6wWVDn4fP+ph9DQfFAdbOIzPaHOpTbHS863jYDmJZwQbco36WDdrPxIimzaLNwzf9XyHUYi4Ij6l5i3xEn32h6IFDyVGRzdD+NEUmjJcZMWa5Fn36wjHQWxyU87Gg8qlINnCeWM29tGDBckp50VlKKmZD/x3jxA0XUjBsvhLLurS2CyMgl6+XHIrvQiLz32UrPv/Wbmz18yJd73WVe4r+oJUgyLt1WX2i/DfhBWVSNX5Qxc5FxHvXiLdTjk6k+RWkcRMeTOA7mQNPqkFM3e+PU+RwmZ2/e9bmtaSSy9kLjZPyL/u/csOiWVP+fYoQ+Kr6r46J
 f6smVJbT
 inwvP0km2UrLpIgEVREUVGiJa5NgEuXM0huMO9JJ9vKVhuAnIJFsF3MkSuqoVTxv4+1GhOvhb5EssIOG0hBa4OGcT5XACoP/5XOz7xlu5Xz/uTiTpReDBevGgAn1cXL/tnTNLAyG8fiU7RbtQF3tAtsqRNxnmonjOVLoLNNtZJ5xVIFXgh7Q9hgLmuV4wIgc68zATUUaoJ3y6tpPIXB6m24NwuMT0vJq9uZ3/JJLR8KrEhd0S7eiWTtqUZkCTm+lL4jvdBX3dFCOYHA49mZ8cCxpgXHclb6iBVMRHsVg1suWx+gMj0NUr+D7ZTWxrgLML+kxpTQvrMv4lAKYwanH4t4MsNpfptek4nEOLSQwzrRvAxFSNd7IDXeDqyLs9g8RqG7Cu8yuC851nAa69e8wFXmVH63uHrz3F2rtUszlKuq9+VlErxvurIPVqku7zxT1lfs8F3RJFzEk7zT3WF3ip6k9AvGDsNeFNYl9GptHJgQimq8AkV+Zh6bKbtUpvGD24t3SwGkKDyMkDthXeCiIw0txIki3yYhgUhoKUTM+DmdxRyXIoGiheSN+Lhpe6wbhxnJZQ4DfE/EpgjHWYCknkzhXKAAobgvMlEEqEwN7RvXaMVvNEvvxxgcdsGdsXaxUINgXGy/6rKssxFPC5RYVtLUrZseTFlgnSYEob7iegeOzK8tLVIG9IheKJeJFU72o6dkA81Bl9yOy0R3PoxuiqPhSFivki04ayLkKTOUmV9SxoHs9IvKKSHMnF6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000a3d8720653cd8191
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

SeongJae Park <sj@kernel.org> =E4=BA=8E2026=E5=B9=B46=E6=9C=886=E6=97=A5=E5=
=91=A8=E5=85=AD 08:54=E5=86=99=E9=81=93=EF=BC=9A

> Hi Kunwu and Lian,
>
> On Fri,  5 Jun 2026 11:10:08 +0800 Kunwu Chan <kunwu.chan@gmail.com>
> wrote:
>
> > From: Kunwu Chan <kunwu.chan@gmail.com>
> >
> > DAMON avoids TLB flushes after clearing PTE Accessed bits for sampling.
> > The overhead was measured and found significant [1].  Production
> > workloads with large working sets flush TLB buffers naturally, so
> > accuracy impact is negligible.
> >
> > On systems with large TLB buffers and small test workloads, stale TLB
> > entries persist across sampling intervals and produce false negatives.
> > This comes up repeatedly on the mailing list and in private inquiries
> > [2][3].
> >
> > Add a document on the design decision, trade-offs, test environment
> > problems, and recommendations.
> >
> > Link: https://lore.kernel.org/20200403103059.12762-1-sjpark@amazon.com
> [1]
> > Link: https://lore.kernel.org/20260117020731.226785-3-sj@kernel.org [2]
> > Link: https://lore.kernel.org/all/20260526145034.91594-1-sj@kernel.org
> [3]
>
> Thank you for this great patch!
>
> >
> > Co-developed-by: Wang Lian <lianux.mm@gmail.com>
> > Signed-off-by: Wang Lian <lianux.mm@gmail.com>
> > Signed-off-by: Kunwu Chan <kunwu.chan@gmail.com>
> > ---
> >  Documentation/mm/damon/index.rst     |   1 +
> >  Documentation/mm/damon/tlb_flush.rst | 131 +++++++++++++++++++++++++++
> >  2 files changed, 132 insertions(+)
> >  create mode 100644 Documentation/mm/damon/tlb_flush.rst
> >
> > diff --git a/Documentation/mm/damon/index.rst
> b/Documentation/mm/damon/index.rst
> > index 318f6a7bfea4..5e239437dab3 100644
> > --- a/Documentation/mm/damon/index.rst
> > +++ b/Documentation/mm/damon/index.rst
> > @@ -19,6 +19,7 @@ DAMON is a Linux kernel subsystem for efficient
> :ref:`data access monitoring
> >
> >     faq
> >     design
> > +   tlb_flush
> >     api
> >     maintainer-profile
> >
> > diff --git a/Documentation/mm/damon/tlb_flush.rst
> b/Documentation/mm/damon/tlb_flush.rst
> > new file mode 100644
> [...]
>
> Great document!  That said, it feels like a good complete article or a
> paper,
> rather than DAMON documentation that pursue to be short and essential.  I
> feel
> like this fit more to be published in a blog like DAMON project blog [1],
> or
> news site like LWN.  If you'd like to, please feel free to upload a PR or
> send
> patch for DAMON project blog source [2].

Mainly due to the verbosity, as I above mentionedd, I'm not sure if the
> current
> shape of this patch is the best to be merged as is.  I also find the
> background
> part of the document is a kind of duplicate of some information in
> design.rst.
> What about putting only essential information in a condensed way on the
> design.rst?
>
> Thanks, SJ. I agree =E2=80=94 this document reads more like an article th=
an short
docs.

I'll follow your suggestion and submit it as a blog post to the DAMON
project blog instead.
Will send a PR to [2] soon. Thanks for the clear guidance.



> [1] https://damonitor.github.io/site_about
> [2] https://github.com/damonitor/damonitor.github.io/tree/master/blog_src
>
>
> Thanks,
> SJ
>
> [...]
>

--000000000000a3d8720653cd8191
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote g=
mail_quote_container"><div dir=3D"ltr" class=3D"gmail_attr">SeongJae Park &=
lt;<a href=3D"mailto:sj@kernel.org">sj@kernel.org</a>&gt; =E4=BA=8E2026=E5=
=B9=B46=E6=9C=886=E6=97=A5=E5=91=A8=E5=85=AD 08:54=E5=86=99=E9=81=93=EF=BC=
=9A<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px =
0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">Hi Kunwu and=
 Lian,<br>
<br>
On Fri,=C2=A0 5 Jun 2026 11:10:08 +0800 Kunwu Chan &lt;<a href=3D"mailto:ku=
nwu.chan@gmail.com" target=3D"_blank">kunwu.chan@gmail.com</a>&gt; wrote:<b=
r>
<br>
&gt; From: Kunwu Chan &lt;<a href=3D"mailto:kunwu.chan@gmail.com" target=3D=
"_blank">kunwu.chan@gmail.com</a>&gt;<br>
&gt; <br>
&gt; DAMON avoids TLB flushes after clearing PTE Accessed bits for sampling=
.<br>
&gt; The overhead was measured and found significant [1].=C2=A0 Production<=
br>
&gt; workloads with large working sets flush TLB buffers naturally, so<br>
&gt; accuracy impact is negligible.<br>
&gt; <br>
&gt; On systems with large TLB buffers and small test workloads, stale TLB<=
br>
&gt; entries persist across sampling intervals and produce false negatives.=
<br>
&gt; This comes up repeatedly on the mailing list and in private inquiries<=
br>
&gt; [2][3].<br>
&gt; <br>
&gt; Add a document on the design decision, trade-offs, test environment<br=
>
&gt; problems, and recommendations.<br>
&gt; <br>
&gt; Link: <a href=3D"https://lore.kernel.org/20200403103059.12762-1-sjpark=
@amazon.com" rel=3D"noreferrer" target=3D"_blank">https://lore.kernel.org/2=
0200403103059.12762-1-sjpark@amazon.com</a> [1]<br>
&gt; Link: <a href=3D"https://lore.kernel.org/20260117020731.226785-3-sj@ke=
rnel.org" rel=3D"noreferrer" target=3D"_blank">https://lore.kernel.org/2026=
0117020731.226785-3-sj@kernel.org</a> [2]<br>
&gt; Link: <a href=3D"https://lore.kernel.org/all/20260526145034.91594-1-sj=
@kernel.org" rel=3D"noreferrer" target=3D"_blank">https://lore.kernel.org/a=
ll/20260526145034.91594-1-sj@kernel.org</a> [3]<br>
<br>
Thank you for this great patch!<br>
<br>
&gt; <br>
&gt; Co-developed-by: Wang Lian &lt;<a href=3D"mailto:lianux.mm@gmail.com" =
target=3D"_blank">lianux.mm@gmail.com</a>&gt;<br>
&gt; Signed-off-by: Wang Lian &lt;<a href=3D"mailto:lianux.mm@gmail.com" ta=
rget=3D"_blank">lianux.mm@gmail.com</a>&gt;<br>
&gt; Signed-off-by: Kunwu Chan &lt;<a href=3D"mailto:kunwu.chan@gmail.com" =
target=3D"_blank">kunwu.chan@gmail.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 Documentation/mm/damon/index.rst=C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=
=A01 +<br>
&gt;=C2=A0 Documentation/mm/damon/tlb_flush.rst | 131 +++++++++++++++++++++=
++++++<br>
&gt;=C2=A0 2 files changed, 132 insertions(+)<br>
&gt;=C2=A0 create mode 100644 Documentation/mm/damon/tlb_flush.rst<br>
&gt; <br>
&gt; diff --git a/Documentation/mm/damon/index.rst b/Documentation/mm/damon=
/index.rst<br>
&gt; index 318f6a7bfea4..5e239437dab3 100644<br>
&gt; --- a/Documentation/mm/damon/index.rst<br>
&gt; +++ b/Documentation/mm/damon/index.rst<br>
&gt; @@ -19,6 +19,7 @@ DAMON is a Linux kernel subsystem for efficient :ref=
:`data access monitoring<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 =C2=A0 =C2=A0faq<br>
&gt;=C2=A0 =C2=A0 =C2=A0design<br>
&gt; +=C2=A0 =C2=A0tlb_flush<br>
&gt;=C2=A0 =C2=A0 =C2=A0api<br>
&gt;=C2=A0 =C2=A0 =C2=A0maintainer-profile<br>
&gt;=C2=A0 <br>
&gt; diff --git a/Documentation/mm/damon/tlb_flush.rst b/Documentation/mm/d=
amon/tlb_flush.rst<br>
&gt; new file mode 100644<br>
[...]<br>
<br>
Great document!=C2=A0 That said, it feels like a good complete article or a=
 paper,<br>
rather than DAMON documentation that pursue to be short and essential.=C2=
=A0 I feel<br>
like this fit more to be published in a blog like DAMON project blog [1], o=
r<br>
news site like LWN.=C2=A0 If you&#39;d like to, please feel free to upload =
a PR or send<br>
patch for DAMON project blog source [2].=C2=A0</blockquote><blockquote clas=
s=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid r=
gb(204,204,204);padding-left:1ex">
Mainly due to the verbosity, as I above mentionedd, I&#39;m not sure if the=
 current<br>
shape of this patch is the best to be merged as is.=C2=A0 I also find the b=
ackground<br>
part of the document is a kind of duplicate of some information in design.r=
st.<br>
What about putting only essential information in a condensed way on the<br>
design.rst?<br>
<br></blockquote><p class=3D"gmail-ds-markdown-paragraph" style=3D"margin:1=
6px 0px;color:rgb(15,17,21);font-family:quote-cjk-patch,Inter,system-ui,-ap=
ple-system,BlinkMacSystemFont,&quot;Segoe UI&quot;,Roboto,Oxygen,Ubuntu,Can=
tarell,&quot;Open Sans&quot;,&quot;Helvetica Neue&quot;,sans-serif"><span c=
lass=3D"gmail-">Thanks, SJ. I agree =E2=80=94 this document reads more like=
 an article than short docs.=C2=A0</span></p><p class=3D"gmail-ds-markdown-=
paragraph" style=3D"margin:16px 0px;color:rgb(15,17,21);font-family:quote-c=
jk-patch,Inter,system-ui,-apple-system,BlinkMacSystemFont,&quot;Segoe UI&qu=
ot;,Roboto,Oxygen,Ubuntu,Cantarell,&quot;Open Sans&quot;,&quot;Helvetica Ne=
ue&quot;,sans-serif"><span class=3D"gmail-">I&#39;ll follow your suggestion=
 and submit it as a blog post to the DAMON project blog instead.=C2=A0</spa=
n></p><div><span style=3D"color:rgb(15,17,21);font-family:quote-cjk-patch,I=
nter,system-ui,-apple-system,BlinkMacSystemFont,&quot;Segoe UI&quot;,Roboto=
,Oxygen,Ubuntu,Cantarell,&quot;Open Sans&quot;,&quot;Helvetica Neue&quot;,s=
ans-serif">Will send a PR to [2] soon. Thanks for the clear guidance.</span=
></div><div><span style=3D"color:rgb(15,17,21);font-family:quote-cjk-patch,=
Inter,system-ui,-apple-system,BlinkMacSystemFont,&quot;Segoe UI&quot;,Robot=
o,Oxygen,Ubuntu,Cantarell,&quot;Open Sans&quot;,&quot;Helvetica Neue&quot;,=
sans-serif"><br></span></div><div>=C2=A0</div><blockquote class=3D"gmail_qu=
ote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,20=
4);padding-left:1ex">
[1] <a href=3D"https://damonitor.github.io/site_about" rel=3D"noreferrer" t=
arget=3D"_blank">https://damonitor.github.io/site_about</a><br>
[2] <a href=3D"https://github.com/damonitor/damonitor.github.io/tree/master=
/blog_src" rel=3D"noreferrer" target=3D"_blank">https://github.com/damonito=
r/damonitor.github.io/tree/master/blog_src</a><br>
<br>
<br>
Thanks,<br>
SJ<br>
<br>
[...]<br>
</blockquote></div></div>

--000000000000a3d8720653cd8191--

