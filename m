Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C63BC55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 17:29:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FD966B009F; Tue,  4 Aug 2026 13:29:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D4C06B00A0; Tue,  4 Aug 2026 13:29:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EAC56B00A3; Tue,  4 Aug 2026 13:29:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A7C76B009F
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 13:29:03 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 84F8AA15FA
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 17:29:02 +0000 (UTC)
X-FDA: 85064272524.21.2C16597
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf30.hostedemail.com (Postfix) with ESMTP id 998F380005
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 17:29:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EWg1S6qk;
	spf=pass (imf30.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785864540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IoTO8KW+GDReBkSkpnRl4suzyOO4Gn2RcvhBsIn37Bg=;
	b=43mc+/sfyVaYVwAiy2s9Iy6iMYEG/Ev00tuJg1fG/U7L1iwKDbz45122zdI9AbZWeFtrG+
	8qH7nWXE7I5Wzyc6e2qAjxOaCQzTybTWS5qmd0CTa8rMQGA/Jlymw4GlowD4y9REJV4zV6
	ybPEEp8vlNTEiLkXsl8gLu/5BHdIBLA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785864540;
	b=urt/N2XeT2qCr04nPcK+GFGb8MlfcR2W5ZLcMKfx3jQjZ+ITZp6d4C0a94cv5HZASu5B1u
	R6KsIwoCjFpXcb0eUysGZsopMHDlTQfNisBD/zq9SV8xkz0tCdC7Hc9CGODCyryAkoxv2c
	KT42avfiYNvswWoIUs2w/PCevCip18U=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EWg1S6qk;
	spf=pass (imf30.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2cede6375caso6605ad.0
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 10:29:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785864539; cv=none;
        d=google.com; s=arc-20260327;
        b=ZYELPtVy5zuzTOEeBWGrSQIAc7syEUpcUdf/Rd54ukxDWXLTSqFU4/0frOx8UMBM4K
         CrE+2rdNgbAqj41eiKqhJNTtwV8bM128J5K3OGEKK1E2hQoWmFHg8BLdKUbyVGQfCvRa
         aKxItgaNDXlN/VwL6I0W1uiU9czTxP11OKzPspCocK+tUelrgySFlGBzdnE2J3m03TXj
         VN6Trq2OOj7aOIWtnSmGCHaqscxnj7Jw/sXgwot85wn2SOe896EfBnp2+L+VQR1RjAdz
         9KT6gIx/d+1rRGbo5Z6hiTUxJLW57Pl1/bF21GfKzn3Itq1xkosDJarcTIaAa5DJFMoP
         CmBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IoTO8KW+GDReBkSkpnRl4suzyOO4Gn2RcvhBsIn37Bg=;
        fh=+AAY35rhTsUxj1eoMgbDhnJ3sRAyzUvt7r26Wl8lflI=;
        b=aGEl9v+vy5019k5NY22iVNCV+xczIGutoqAOh0e+g/cwx+kn2VbWiHpcvA/Vjrd/ar
         yFP2NDPp7zHMY9A1bxow2KMbo7l0m7x1fmmTgJnBja+5tGhanUv4VvNMwkuE3arxkXCs
         cNGKPOIm4BWrNhfiYwpOFnNvFFnb7NkuCNsRYdXN9jtLJsEIk9741nFRZFf2iZ96nNTJ
         nbBfRMFN5pafRux0FkQnJIl5BSX7Go1KAKtvk1RK0r/dqsqDQOWJ0tVIHHZRTvcv0WVO
         4SPWKXjyLw3E4UiWamr0E3f5oKaTYkXhzMC4xYYhlYd3RNzyNaufZ8HgpFh67gbCVnB1
         +jWg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785864539; x=1786469339; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IoTO8KW+GDReBkSkpnRl4suzyOO4Gn2RcvhBsIn37Bg=;
        b=EWg1S6qkHxN0llP+SVwHee3GNZwrKDkAEoFWKht+Mr6Zq1XlfAp0ENv1XYc0pdsGEo
         hkLA7Gzv9nvdrCTwJWTc396j876dd37N2nimlEiMPEcqNMAIEHV8bW7tcw/v5FxqiKb2
         1K+sVcgdqHKKNmeXSJh3/8lNOjSWpBogHPt8AeKxMLe+Rr6x7xn/O8ppGsedXW7xXBGH
         Q9U9aHBh3gZasUIkvfJbpOeIo6sZ0YlOyHIXfoibGUkzummpVwdWgMIPvKHjexVEXHjp
         SIcuWkY9TfTjbbujT8f6dseZJcMdsHeWRPe3RgdUDGShQTWggyf2k2O3C90sIOrtDZ+O
         tRQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785864539; x=1786469339;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IoTO8KW+GDReBkSkpnRl4suzyOO4Gn2RcvhBsIn37Bg=;
        b=m6kJmgsXCI2RnxKUuE21H0nXl2Dt4olMdx7tulSIZO+bipWK0MK0Qz5ZGEnbrHvW1Q
         i0BVKfAoKlsJBh+VYLV/ZFbuvvPjq1f/XFw2Ij5Btns1JAJY8K1UiOAWfjcw4kvAo5i+
         Gti0XxAjj6R052ONoHLzxSUQ2H4nvfSVd10bZY3EqjSYSCrOn+Je4sHLq+dGNDxZMfSj
         /NMuy0MMiXI5EHFHmxIT6ZKDBKhWUdXs1D7HGCV6na8eOJI27hvLMa7Y7+QQVn5Q/dBh
         aLylWTm0xOsd0vi3fN1vuujvmlWpoeMECel6sR5UoC08Lu13lK+rlPyWhgrqzzWWfqeS
         AMuA==
X-Forwarded-Encrypted: i=1; AHgh+RpirO9G2z+2a7UNvExnUcS4JQVpj+l6ulZGcAt8Nqclw6cvxNcpw1hWf60b5GPDb593CXNlIxwUuw==@kvack.org
X-Gm-Message-State: AOJu0YybjaL5S24DNWw3H2oAmgxSwySlRRRAw2RLkI93og33ejD2Egcz
	742yEi1DFcr+pnd41kSklbgjep+jWuCThCIZMjB6A2cxJD7E/e6m+85wiBTd4UtTOK5TClxkj/d
	CejCZNTRbWaUgYiSoXvtkUN3JHf2nxPims3bRj6ck
X-Gm-Gg: AR+sD11+Aywfmk9ndpfpB4du6vDJ+gPWJKoXl5OQwd9RcwJnKwFyrQV6Sfx3q0llX/W
	DG4gORH632Ne4SMxltGvJgLiDu4K0O4izXmWodRtMBE51fOZarPp3VQTvQ1PHYFX3H20Fii42zS
	lDRrOslk7sla2uaoun6keXlNNvNQRaIfO8wMz25dHz9Wb+EkKRGtJWoVSqbvA4oSPsRUZGjFZfN
	RS9jS1D2M3Nro7kxMfTzFb94Qs75db9LCr0tUEBp0iLZfGBNa/w6UgGG3VGPRzOPD9hxczlZ6FF
	uje6e13E/PP8UQzRaApCnX+rPXilB4GuYfzsIFG4m21Ix/Wk0akDOMeNUn8C8veLfmcTp7iviNQ
	=
X-Received: by 2002:a17:902:f64b:b0:2c6:a078:bfb7 with SMTP id
 d9443c01a7336-2d0cb6b9a76mr301465ad.7.1785864538734; Tue, 04 Aug 2026
 10:28:58 -0700 (PDT)
MIME-Version: 1.0
References: <d635115cfafcd35c8e3344b418acb1020aba1052.1785794035.git.abhishekbapat@google.com>
 <0b95c0df-8cf6-4ad9-9552-d7c4a657a25c@linux.dev> <7e71f6d4-7bc9-449c-a122-49f0e8397150@linux.dev>
In-Reply-To: <7e71f6d4-7bc9-449c-a122-49f0e8397150@linux.dev>
From: Abhishek Bapat <abhishekbapat@google.com>
Date: Tue, 4 Aug 2026 10:28:47 -0700
X-Gm-Features: AUfX_mzTWJ1d8mXgqjC6vG6rlblnvvC1NJAGSXdHLoVAarBVhoUh2YSDpDTIuZk
Message-ID: <CAL41Mv5Aa3XtmqVbDTnsf8RX4nxC7J7mUXZzFaUZ9NSMyAbpFg@mail.gmail.com>
Subject: Re: [PATCH v3] alloc_tag: expose profiling and compression states
To: Hao Ge <hao.ge@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 998F380005
X-Stat-Signature: cms18by4kay3e37mx6ojai4gwrfn95to
X-Rspam-User: 
X-HE-Tag: 1785864540-616072
X-HE-Meta: U2FsdGVkX1/Uv/guQvfIZg2LkDIST3Ht2RBqYZXBSUV/iktFsMkGKRqrQionRB/k4fR2bQ7NTdVacSKEyyGwR3dlmDXnDw24OYYxk/71T+hftmarawIGumx5zv9iGKtgiqG+EPIlsBZP7EG/sww9TvtnYiWKHXUFdBCZgblMX1962+zUg03G4VXpJpGikm4JVFZEvOQfxLBMyEmZV6V/61DEqM+qEJrDC8zONxS+dKu7Jc4cdZNHlna07RSbAwMEfUQdEJSOTcEcRTHmIMG45TYB7D8f2I6zsuEpZX8i3di4uJuhTOIwjSrl1SoxMg87lc3GGWRoazIq6nlQCPsKTG1T1G+3GCrBncmI+5LlfHClTHwzvZ3pj++wS4tFzCSGwXgpxG4aeIv0xQ0epjVM6/OVMHNdfIao1+s/mWz0SthoCd5FgLv42zoUZXLwUOWbS79Rg+nW+ig+HjuAXC7L1gA0p44pO8HZea4tkIL3MTRFy5d+UPm48ep1Z9uOaE2tFvMv4a7VZkhfeiccEX+jz7Hrnsv6QSUDsr1uk9EnfpIhLANnGZJr7S4E19myzgv8fFzarwZiIPAKhI+vMVs4E8eSMnWnHkzkTYIP/85wUVJGyye0iKqlfuMqL6T1AXRpwXth1aRNwjyCS3GWDS9S3yK+Db+EJ2EJbC0M4fwwZG2X192T5Yowc1VicCSvPLkzV8KHQxrAeq4ncP1lBGqVTZJW6wytw4/Zp5WdZed35s23izmMF6hP1IBwMj2Eoh9gEFZaf7FJKCa2MFwL0VZ0XTphkQyDu5noIKdE9cJNM9y4itbVDHUx26Pd5/zw+E23EY2XWR5qGsuM1cH/9d6Fg1qsGt7vkRVMdnNRCDkaM0lKKBvbDpceF166mmbBzb6hDZQuRfhm1QP6Y5xPPvhcdasWaqO9NppHONyxgbWfi5paupptGP7i1oYoOun5JchObxRElVitNePsDS4p706
 BjQqvnXh
 qTqQD4RSBXednaKYzhF7S680fum0rMHDtm5+yKg0j15YYThoH+4FrbI0w8X6clkl+VbE7aSXmCcE6yfE3uWO3UqQQqwgE61K60JU9h7TLV+UtFWCd2ScsBTw0DUKyVYLcdsXAUPq4HuygKfb+PrUH12Z88n2Mt2YeygvB3fuT2o9RwdbzdbKf2Y/fXXNJpTDEh96zFiCKoI9Rvwc3Jr7gZ5rM+SlrcXm47t5vXFmoKtG+4JwXpUqjEjh/ZnpYKIWEl5X1EEIhkk5jtCQFm+XjfqzezWl/UntxamwViNbEUM2w2Ev4roP3g7xasA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 3, 2026 at 9:14=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
>
>
> On 2026/8/4 10:15, Hao Ge wrote:
> > Hi Abhishek
> >
> >
> > Subject says "profiling and compression states", but this
> >
> > patch only adds the compression sysctl. The profiling state was
> >
> > already exposed via mem_profiling and is untouched here.
> >
> > I think we should make this more precise, like:
> >
> > alloc_tag: expose boot-time compression configuration
> >
> >
> > On 2026/8/4 05:54, Abhishek Bapat wrote:
> >> Currently, userspace has limited visibility into the exact active
> >> runtime state of memory allocation profiling and its page extension
> >> compression ('sysctl.vm.mem_profiling=3D{0|1|never}[,compressed]').
> >
> >
> > Profiling state is already readable via mem_profiling. The gap is
> >
> > only compression. Also, as we discussed, this sysctl reports
> >
> > what the user requested at boot rather than the actual runtime state.
> >
> >
> >> While reading the sysctl provides basic on/off status, it is currently
> >> impossible for userspace to natively determine whether page-tag
> >> compression was successfully enabled without scraping dmesg boot logs.
> >>
> >> Resolve this ambiguity by exposing the active compression state by
> >> adding a new read-only sysctl `vm.mem_profiling_compressed` to output
> >> the
> >> state.
> >>
> >> v3 change:
> >> - Added documentation about the behaviour details of the new sysctl.
> >>
> >> v2 change:
> >> - Moved from displaying the state in /proc/allocinfo to a new read-onl=
y
> >> sysctl.
> >
> >
> > As this is a standalone patch, please put the v2/v3 changelog below
> > the --- line
> >
> > instead of inside the commit message.
> >
> >
> > Thanks
> >
> > Best Regards
> >
> > Hao
> >
> >
> >> Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> >> ---
> >>   Documentation/mm/allocation-profiling.rst | 13 +++++++++++++
> >>   mm/alloc_tag.c                            |  6 ++++++
> >>   2 files changed, 19 insertions(+)
> >>
> >> diff --git a/Documentation/mm/allocation-profiling.rst
> >> b/Documentation/mm/allocation-profiling.rst
> >> index c3a28467955f..3ad1e9aacb9a 100644
> >> --- a/Documentation/mm/allocation-profiling.rst
> >> +++ b/Documentation/mm/allocation-profiling.rst
> >> @@ -43,6 +43,19 @@ sysctl:
> >>     warnings produced by allocations made while profiling is disabled
> >> and freed
> >>     when it's enabled.
> >>   +  /proc/sys/vm/mem_profiling_compressed
> >> +
> >> +  1: Page extension compression is enabled.
> >> +
> >> +  0: Page extension compression is disabled.
> >> +
> >> +  This control is read-only and reflects the compression status
> >> initialized at boot.
> >> +  Note that, unlike `mem_profiling`, which represents the current
> >> state of profiling,
> >> +  `mem_profiling_compressed` represents the state configured at boot
> >> time.
>
>
> Sorry, I forgot to mention this earlier.
>
> I wonder if we could remove this section:
>
>
> >> Turning off
> >> +  profiling at runtime will implicitly make this sysctl effectively
> >> dormant. However, if
> >> +  profiling is toggled off and then toggled on again, it will resume
> >> with compression
> >> +  still enabled as long as the value of `mem_profiling_compressed`
> >> is 1.
>
>
> mem_profiling_compressed only selects the tag storage format (page flags
> vs page_ext).
>
> mem_profiling controls whether allocations are tagged at runtime.
>
> The two are independent: toggling mem_profiling on/off has no effect on
>
> compression. Only shutdown_mem_profiling() tears it down, but by then
>
> the entire allocation profiling subsystem is disabled anyway. There is
>
> no resume path.
>
>

I added this based on Suren's comment on the previous version asking
me to explicitly describe the behaviour in the Documentation. The
original version did not contain it. But personally I do think keeping
this here makes sense.

> >> +
> >>   Runtime info:
> >>     /proc/allocinfo
> >>   diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> >> index 52aece27b00e..877068241f06 100644
> >> --- a/mm/alloc_tag.c
> >> +++ b/mm/alloc_tag.c
> >> @@ -1303,6 +1303,12 @@ static const struct ctl_table
> >> memory_allocation_profiling_sysctls[] =3D {
> >>           .mode        =3D 0644,
> >>           .proc_handler    =3D proc_mem_profiling_handler,
> >>       },
> >> +    {
> >> +        .procname    =3D "mem_profiling_compressed",
> >> +        .data        =3D &mem_profiling_compressed,
> >> +        .mode        =3D 0444,
> >> +        .proc_handler    =3D proc_do_static_key,
> >> +    },
> >>   };
> >>     static void __init sysctl_init(void)
> >>
> >> base-commit: 94f9b3980dd446b56acf1dfed649e9b32a9f3813

