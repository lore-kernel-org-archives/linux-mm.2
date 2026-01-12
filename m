Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55038CF45CD
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 21:56:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F9EB6B0088; Mon, 12 Jan 2026 16:56:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CAD76B008A; Mon, 12 Jan 2026 16:56:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8ACF96B008C; Mon, 12 Jan 2026 16:56:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 72D886B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 16:56:58 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DA8925DBEA
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 21:56:57 +0000 (UTC)
X-FDA: 84324672474.25.EBDC211
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf20.hostedemail.com (Postfix) with ESMTP id E5CE21C0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 21:56:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wWDIMgde;
	spf=pass (imf20.hostedemail.com: domain of avagin@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=avagin@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768255015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=APPjDiY27Mom+DuTB7AoGJUBts47hajus/rVrAD6gqs=;
	b=mKHoPO9HIxSC1T2QjA0J7nx2LPVOAqdNur5TO2e79D3JxhEsVMSvHGzvcT+sAmj1iXYhKS
	xI/Wpgxjv/LF6l9nNa26KIum5aRdDyS/LSMgUwuqnxcyM/4kmc1h08hZKDXWjp+fGsWgDC
	rwn9plBKUmqhG/PPKJtPGMtnSQ5oMiI=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wWDIMgde;
	spf=pass (imf20.hostedemail.com: domain of avagin@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=avagin@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768255015; a=rsa-sha256;
	cv=pass;
	b=C6Y0HTp+THXorSu/od3VMBQr/SocbDp8l2MyJLUBPM9uUJ+x+FsfnKDfaxebasFWv+5BpG
	SQ5RYuLvZbvcZSBJja1BaQFxPR7xN4nBaVRJtyghB27j7/ZoFy8vTxj4ykFUTAX2xQ89cG
	4FHveLwitnJVthj9P6SbnwHfDdkNqTM=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4ee147baf7bso40301cf.1
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 13:56:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768255015; cv=none;
        d=google.com; s=arc-20240605;
        b=h8tdElSNAF9/qjy1+ac6+IWFpqxC1MiajvhRkmwZoftQkfLTlUm0s0Iqwp3DKunN3f
         1uStbe1i4DrsqyaRGelvShEmg6igOJEuprcGkdAqDqnrApKketDXJ9UOLH2I8egX3BRy
         mKZj3pxSwaeNKwLLMo55HUUXs2yRZ3HHgd9NM08aOP/uVhQAAndidPgn5u26OVB5gUbX
         0L+9SInOInrqZjgpFVFbPjXnih+C8JvKLY5B6CSEr24CtcfG2OZbvd+UgVfahyHQRs18
         ff1HzfCyaRZDMZQcJ0QXmK24k4XVGOU+a9wwpdImAZOWCl27awpNGLTal/Q7iyndacjS
         GoYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=APPjDiY27Mom+DuTB7AoGJUBts47hajus/rVrAD6gqs=;
        fh=GdNG4ZeaNv6jzJVWbkQOULtwY4gQI1jEQlhHeuCPxSQ=;
        b=DhcnymrJcMz91SQFU2FmECknUD+XRafmAkndSL7MmxrqjSwHHZbFeHjtWzw35OaSCC
         qmm7Z1TD3/8VBF0JsKDU3JmVofYA+SBLHZmiTHlwhjIYJl4osK7zLK1EXMRwm+o1cdGG
         l2tzH3k0xh7jGdR3/98vFIhBI/R6Z28JzAuq9UuiW/ERv583erVkkjDhjyDCbeVlMxIU
         KTxMqAICGLidA2zW2piHTa2kjuvvxfSvef6Vgy8dbINfJpFkgqxr2I0Z24AV/Mzi7bus
         KtH1T1z0qv4Smf9285fZFhACdFyfrLMmGIs9yHDPYyGi2M/neWfjgX8YldWBTQGHN1dl
         eeEQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768255015; x=1768859815; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=APPjDiY27Mom+DuTB7AoGJUBts47hajus/rVrAD6gqs=;
        b=wWDIMgdeVXvRJAi2v2ZH+1GYFCgwmD18KP+AbOPeHKDlAy2i5XUhw2Q35we5z/JQfw
         csWNth4KNPupVlyCIDsUuRWyXZPRe0sNpVwWF+ez6wec6a+91Ze9ynxcx5zZhfawbJ5W
         6JOWSr1k+tWrZpuFjyQsQO3k9wSvGTKh/LRcVdhs8fxwbnctEfck8l/Hk7GytkUZ9QPS
         HIhkLo8FvtYzvv0XbO2CVzg1FjZ5dzQNJx7BUEEFOEWjDkSUEBBrsI3t/3Qm1rSJTu3j
         jfAuqk5hhVMM2lfP/8q1M306wjmUfasN5t33dKHdtw0obCPiKqDfT8gvg/wGKAeABrbX
         z6ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768255015; x=1768859815;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=APPjDiY27Mom+DuTB7AoGJUBts47hajus/rVrAD6gqs=;
        b=o6QWsgNs9SvmANpSLcEPm2clSlFmp1btxvMAc/+6RBzDZ5yfOGStmMFkdXK3+gb8KI
         k0VQsyXc9cCGOOn3IO5Kmwr+bqfD8au+1z+J1yOh4bFfTnrYzN/CzixI5v92dmWqqKJL
         LgsCVhnWJg+UFS4uAy5neUq9KHHfN7pBYzaDOuIrVlwhNSbYuJDNqY+yjzrX5hOFMy02
         Ju7tiXXU4gW0asnw6Ux+XS7hQd+q6qND9AWacKNwrheaeQquLfhDmCWoi9VFbycNXsT6
         Fkf8apQ5X7BITdkAauxDv7ToHTxFWP/Qe+tTZwLFavgQo2DdqWf6MNi8kmdj3irXfp+J
         N8Pg==
X-Forwarded-Encrypted: i=1; AJvYcCUXdUq+Gp21wWD20Z3wctU9d3eaivgT1AlsKyKP64vvr5maFrWa/+wWR4jaqsiJZ5NBQPFD8eKybw==@kvack.org
X-Gm-Message-State: AOJu0YxRVrMC7IL6JXsu0ZnFsBCqIY2FAkV8AA+lM+wuVncWUEPAqWj7
	kHEnP++TrbJ4W2ZNRMLCmD5sKbLwPVc4icMfxW4PYFON3Cewb0lRkRi48lFhmjWoJctt+87UIT5
	+VA6P6PrRh2gaU4mmaO0CoataeLFi7aU2N36/swCT
X-Gm-Gg: AY/fxX7YDIXucFObI2kxqgr94XO+U6ggL7Nnkf3/t6vuZ4LhVBaVCTW3beJF+3dKAbX
	jCi1a9iA8fvnus2B7AxmX0qp0rQE6QfQCc/ixdIASjQDKk9yrrPcbKKEyS1Xw48c5mVlSVhfKR8
	E94C9BLGmz1B8bHWRBDIm+ASCfgziIYKT+OCBYD54ATlEFEHPTw9DF4iO2HqPQyOTg9/8AcGY/i
	AVbf/jZBDrA8IVxnikz6qTfBUwNZoFDp3aEgRDXhqr64QuU0aJPYRdKXQjvEcdiuRSXhGz2
X-Received: by 2002:ac8:5942:0:b0:4ff:cb72:7c03 with SMTP id
 d75a77b69052e-5013af6e61amr909671cf.3.1768255014503; Mon, 12 Jan 2026
 13:56:54 -0800 (PST)
MIME-Version: 1.0
References: <20260108050748.520792-1-avagin@google.com> <20260108050748.520792-3-avagin@google.com>
 <wfl47fj3l4xhffrwuqfn5pgtrrn3s64lxxodnz5forx7d4x443@spsi3sx33lnf>
In-Reply-To: <wfl47fj3l4xhffrwuqfn5pgtrrn3s64lxxodnz5forx7d4x443@spsi3sx33lnf>
From: Andrei Vagin <avagin@google.com>
Date: Mon, 12 Jan 2026 13:56:43 -0800
X-Gm-Features: AZwV_Qj3y2SecqwEZXS9T90QVcHw2aDfPUBTvSnTZm697NLp5ICI8RI9bzunxDQ
Message-ID: <CAEWA0a4BW-7qsewWHTeSeRj7XtdcFX34oW47XeG3JLC+c9cExQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] exec: inherit HWCAPs from the parent process
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, criu@lists.linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, Chen Ridong <chenridong@huawei.com>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Eric Biederman <ebiederm@xmission.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Content-Type: multipart/alternative; boundary="000000000000041313064837f498"
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E5CE21C0005
X-Stat-Signature: quuwgrznfgr6p79w3s6wiijh46sk3ysh
X-HE-Tag: 1768255015-251892
X-HE-Meta: U2FsdGVkX19k8kHpf/7JsN/e4dhZKlP4IyXBA2W47uYhaaj9ub8AHf+MpEvHJP6i1jGx4VuNPPiXqY3/gp5HdvnALqd0JE7o1HTkYR946GT9xf8hg67H0rsErUyOhYQ3snAM+9hCRDlm0o4kkIbkPS+auRRSnO0nrIlQdDn1vrQmVpaYeRwJ3TVH1FnwmAqnrgEdewYqeWmWcVWiviT3IxQVi3GzONkc5GrpFFf8tNCZnV/p/GJ2VF5WKQ0NgsA0EZ5rRIPAePjqgTfVnwTmloFUPkzdxK6iqKseHDo/lI53QYtYs4U5JSfp/jXxlAha9SBfu4q+clKxSVtB5udbdOji1iXLpcvoXSk1HR89D9FS4d94ZnpJ6oQ4O4DwDav/Sh+EVco1tspiq4HjZB5K30DzX990AudI/kSrR755SvcOvFkbq3Kdbbu4ApGjI1oA3eAGocuUDyjN/1a+p1UDv4HmAAOdQ3s2UE5cY14mXDQLJnxJbSS16vVeTiEqh5Y/hkB4WDa6D11+QpMFH4JgpnI/quCi0+OrKNszuh/P9DQIK662oH+izBEeNs9eVE/+CqcBU5NC/gOwUIKbIhRg6GASUm0BtbF9ug26dIIsBK5Bf+CebvLPFbi7TgMsEpbi86E0G0WeHBCCp3mGLENEq6nPVMqa8uvhbdTC9ylHMlWKXBhlVC0+jLJ070CzJgdhv189kswULzTAWoBFIBeu2XRHyeiZ2GwvNlRqH5m0a7lNwyP1Ws6a2UFv+In+mEmzMHPXYQ63WYJqVlxVZn4aTj9F47NNofPe0KQUiHEknpQJvhhLORyieaOkepynU49vwO1mM8+M0bBpOO0QoFwes3B+FwQVj/Q9QWKqyV7lxgpLDMhOXr3HpxhnQ7jJNmRSx4tZGKYk2mjiYZdtjdxP6bHT6GqOaq1dnReAw3E6iq8xYrw5xtP7Vy1C3igVUTV2IelMkTfZ7pQydOz4rFL
 hnfwdAI0
 4f1qYcM3qBH6XsCPyK5E/AkGVw1NqOmsYETjzDl9ppPw3o8iWrU3QvTehXOK6HGYCyNXFMl6T8x+hDuvFEDE5EmVQANILSDISkqr2xmtWCordulzG31blz3l6HRh4oknCmK6FX0rFCSut97da0c+9q1N1jFc0FXRX/RD+sNu3Nq8P07XA8ZlkSXzzr6ZdZxXZtw+axNJOW7PpEQrUmTDMHHCg5y+QLD77CRmi24N/mlGynl26pgV/3AdoJIMIoMDt7Jh9UPkLCruJEOqt+KmgAlBaeFa+Ho9XSLsE0bLhFkwplZ2gko8RGtNLrcGCiXFXuf9PsEuyUBPSfAA1rAhWlaCNLIUudFU8kRMmVlVjxHEG7a3ZkQ5KpypDIHSKpRei1Dh/siFRsfT+6hAjqiQDy97RIaoD+MQMkVoXsQrd6pv/JPY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000041313064837f498
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 12, 2026 at 4:46=E2=80=AFAM Michal Koutn=C3=BD <mkoutny@suse.co=
m> wrote:
>
> On Thu, Jan 08, 2026 at 05:07:47AM +0000, Andrei Vagin <avagin@google.com=
>
wrote:
> > @@ -1780,6 +1791,50 @@ static int bprm_execve(struct linux_binprm *bprm=
)
> >       return retval;
> >  }
> >
> > +static void inherit_hwcap(struct linux_binprm *bprm)
> > +{
> > +     int i, n;
> > +
> > +#ifdef ELF_HWCAP4
> > +     n =3D 4;
> > +#elif defined(ELF_HWCAP3)
> > +     n =3D 3;
> > +#elif defined(ELF_HWCAP2)
> > +     n =3D 2;
> > +#else
> > +     n =3D 1;
> > +#endif
>
> Is it guaranteed that HWCAP n+1 exists only when n does?
> (To make this work.)

It is just a small optimization to stop iterating after handling all
entries.

>
> > +
> > +     for (i =3D 0; n && i < AT_VECTOR_SIZE; i +=3D 2) {
> > +             long val =3D current->mm->saved_auxv[i + 1];
> > +
> > +             switch (current->mm->saved_auxv[i]) {
> > +             case AT_HWCAP:
> > +                     bprm->hwcap =3D val & ELF_HWCAP;
> > +                     break;
> > +#ifdef ELF_HWCAP2
> > +             case AT_HWCAP2:
> > +                     bprm->hwcap2 =3D val & ELF_HWCAP2;
> > +                     break;
> > +#endif
> > +#ifdef ELF_HWCAP3
> > +             case AT_HWCAP3:
> > +                     bprm->hwcap3 =3D val & ELF_HWCAP3;
> > +                     break;
> > +#endif
> > +#ifdef ELF_HWCAP4
> > +             case AT_HWCAP4:
> > +                     bprm->hwcap4 =3D val & ELF_HWCAP4;
> > +                     break;
> > +#endif
> > +             default:
> > +                     continue;
> > +             }
> > +             n--;
> > +     }
> > +     mm_flags_set(MMF_USER_HWCAP, bprm->mm);
>
> Will this work when mm->saved_auxv isn't set by the prctl (it is
> zeroes?)?

The inherit_hwcap function is only called if MMF_USER_HWCAP is set (auxv wa=
s
modified via prctl). However, even if mm->saved_auxv hasn't been modified,
it still
contains valid values.

Thanks,
Andrei

--000000000000041313064837f498
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><br>On Mon, Jan 12, 2026 at 4:46=E2=80=AFAM Michal Kou=
tn=C3=BD &lt;<a href=3D"mailto:mkoutny@suse.com">mkoutny@suse.com</a>&gt; w=
rote:<br>&gt;<br>&gt; On Thu, Jan 08, 2026 at 05:07:47AM +0000, Andrei Vagi=
n &lt;<a href=3D"mailto:avagin@google.com">avagin@google.com</a>&gt; wrote:=
<br>&gt; &gt; @@ -1780,6 +1791,50 @@ static int bprm_execve(struct linux_bi=
nprm *bprm)<br>&gt; &gt; =C2=A0 =C2=A0 =C2=A0 return retval;<br>&gt; &gt; =
=C2=A0}<br>&gt; &gt;<br>&gt; &gt; +static void inherit_hwcap(struct linux_b=
inprm *bprm)<br>&gt; &gt; +{<br>&gt; &gt; + =C2=A0 =C2=A0 int i, n;<br>&gt;=
 &gt; +<br>&gt; &gt; +#ifdef ELF_HWCAP4<br>&gt; &gt; + =C2=A0 =C2=A0 n =3D =
4;<br>&gt; &gt; +#elif defined(ELF_HWCAP3)<br>&gt; &gt; + =C2=A0 =C2=A0 n =
=3D 3;<br>&gt; &gt; +#elif defined(ELF_HWCAP2)<br>&gt; &gt; + =C2=A0 =C2=A0=
 n =3D 2;<br>&gt; &gt; +#else<br>&gt; &gt; + =C2=A0 =C2=A0 n =3D 1;<br>&gt;=
 &gt; +#endif<br>&gt;<br>&gt; Is it guaranteed that HWCAP n+1 exists only w=
hen n does?<br>&gt; (To make this work.)<br><br>It is just a small optimiza=
tion to stop iterating after handling all entries.<br><br>&gt;<br>&gt; &gt;=
 +<br>&gt; &gt; + =C2=A0 =C2=A0 for (i =3D 0; n &amp;&amp; i &lt; AT_VECTOR=
_SIZE; i +=3D 2) {<br>&gt; &gt; + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 long val =3D current-&gt;mm-&gt;saved_auxv[i + 1];<br>&gt; &gt; +<br>&gt; =
&gt; + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 switch (current-&gt;mm-&gt=
;saved_auxv[i]) {<br>&gt; &gt; + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
case AT_HWCAP:<br>&gt; &gt; + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 bprm-&gt;hwcap =3D val &amp; ELF_HWCAP;<br>&gt; &g=
t; + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
break;<br>&gt; &gt; +#ifdef ELF_HWCAP2<br>&gt; &gt; + =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 case AT_HWCAP2:<br>&gt; &gt; + =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bprm-&gt;hwcap2 =3D val &a=
mp; ELF_HWCAP2;<br>&gt; &gt; + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 break;<br>&gt; &gt; +#endif<br>&gt; &gt; +#ifde=
f ELF_HWCAP3<br>&gt; &gt; + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 case =
AT_HWCAP3:<br>&gt; &gt; + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 bprm-&gt;hwcap3 =3D val &amp; ELF_HWCAP3;<br>&gt; &gt;=
 + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 br=
eak;<br>&gt; &gt; +#endif<br>&gt; &gt; +#ifdef ELF_HWCAP4<br>&gt; &gt; + =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 case AT_HWCAP4:<br>&gt; &gt; + =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bprm-=
&gt;hwcap4 =3D val &amp; ELF_HWCAP4;<br>&gt; &gt; + =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;<br>&gt; &gt; +#endi=
f<br>&gt; &gt; + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 default:<br>&gt;=
 &gt; + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 continue;<br>&gt; &gt; + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br=
>&gt; &gt; + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 n--;<br>&gt; &gt; + =
=C2=A0 =C2=A0 }<br>&gt; &gt; + =C2=A0 =C2=A0 mm_flags_set(MMF_USER_HWCAP, b=
prm-&gt;mm);<br>&gt;<br>&gt; Will this work when mm-&gt;saved_auxv isn&#39;=
t set by the prctl (it is<br>&gt; zeroes?)?<br><div><br></div><div>The inhe=
rit_hwcap function is only called if MMF_USER_HWCAP is set (auxv was</div><=
div>modified via prctl). However, even if mm-&gt;saved_auxv hasn&#39;t been=
 modified, it still</div><div>contains valid values.</div><div><div><br>Tha=
nks,<br>Andrei<br><br></div></div></div>

--000000000000041313064837f498--

