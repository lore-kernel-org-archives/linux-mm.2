Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B675D1680B
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 10:59:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA7746B0088; Fri,  9 Jan 2026 05:59:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D54556B0089; Fri,  9 Jan 2026 05:59:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0C686B008A; Fri,  9 Jan 2026 05:59:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AE8246B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 05:59:07 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5F43B1A0479
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 10:59:07 +0000 (UTC)
X-FDA: 84312128334.01.F28584F
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 83C2DC0003
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 10:59:05 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=FabLcLrR;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf28.hostedemail.com: domain of smostafa@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=smostafa@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767956345; a=rsa-sha256;
	cv=pass;
	b=jzSZlhj6b4pVOdxz/O51oI1yRqDmkd6I+ZNaHypm3WppZTXBPMiaOrRlKxudbsl5USW8ir
	zuIIZTdK0nF2vMM3JlX3cTmj5lO0vIAus+S2ceCnMuR5XtS9S5SBycwNLFCOfAVvYNwj9U
	BbgmrP28jnnQhsCzl5EW5qtULsBC6YI=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=FabLcLrR;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf28.hostedemail.com: domain of smostafa@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=smostafa@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767956345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vjKpspm5EV7YLDthnD1/PcikwGNL6s6nU4SX0hD4quE=;
	b=Mhd1mO0F5MspDPr+vI+q4lr3ctukVeanGMj53kGzTwgRGP3kud8rFwytZGAmQYvZNCmXRi
	4cs8qpL5wlosWljoD+hnlO3vGfzPm8L2DrFEbdXtlkcK2t4y73CeZgs1QyG/RWvAbZrF35
	uqQtF42e5o/QGlTzW9QikecOMxdBWJs=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4ee147baf7bso322061cf.1
        for <linux-mm@kvack.org>; Fri, 09 Jan 2026 02:59:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767956344; cv=none;
        d=google.com; s=arc-20240605;
        b=EUg9bNJCAb+OLbDIe7FeLXq0oVQYzrUaaLOhHZiN8/kltKfUezknoTjrNr8D/Fq1Im
         yEOJGTurZ6QQ+OjfKTlUANkmU93yD1j20UPK9yTxQz3iVt9koAr2pT1/+iZT8vzpyE0V
         A1BU9d8aU+LYNdBwr9celkwkbJ9+xAgP32sEOXC3jBPh3An0/qGmSzcSnb9PZvYhFZRr
         rCMdw+5inJqrF4e5INuAsSTCnpJdNhZAV3ws0mCA84+xbqkuJHvFcmaOVZyDD3udOxZv
         wJCVzd7QrZcW7mNOm9my8x61nD8Lkxs7NlHQewkOpMkxLyTMZwGdE5FHBnVd/oOgQxsK
         LxpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=vjKpspm5EV7YLDthnD1/PcikwGNL6s6nU4SX0hD4quE=;
        fh=5+AFV9XZ0puVnUwvP9M00PFOtv3FO1LeLex0LaxwMiY=;
        b=KtAK6o5A3m1V+SGl+8YtMWV4bvyAYjgw2JFBdFY0Ky7TpNEsYSuTytm2tu6VbY/k5h
         A/DROdZAh/QM6zHIllO+IRHyGc75voUR9h2/2FtBST5+wnTzjMlPfIQJEtEY9cPHMI6u
         ki0JjvBT1ZGBfYfnozVAqf37J5A9essDJwBIy65Wc+weX2Vhhb3IQTrNqkO5prQtZ8EJ
         ZUwcSZDByjt7i4JAFoqzi2FIz4XXPFJUX3Mnfr2s+LmCLnfVo6HOkxFuCeltsGMWTAmw
         ac3k+DOck8sVteYYhJx7ddt7IkXqfWZUNotc+PYekQFQEAtCZ3rm7dn4rs6FwS/A5pub
         mx9w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767956344; x=1768561144; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vjKpspm5EV7YLDthnD1/PcikwGNL6s6nU4SX0hD4quE=;
        b=FabLcLrR/kb4KuXIHYZiSsxzh+IgPyknZVSwvYKGixt7kP3wUwZwxl2I50KoVGtdac
         ZfK9hd5A82VXG6xcuLOM3F+ntjKzOKY+pWlWc0WRz26UH8xl2IL9BqNcqjdJAWD6MAMI
         IqN8pbYJ7xgqSCcHATM3Gta3Itn23PJIXf4+cgHUyf9joLtLz9LM6jZbxiLaRDvfRdpv
         llO8HYNbrw7/cxAA0hILxc2/WIQgZo6NUxmKgrRBWT8sqQbt85mDhomQvVJGg7vli1bA
         ew15itP7Mh4atp4POjkUYls5OGIyaIAqId0xvzetXWEQlUFpGbKbEv8FXWdsa5ObM8+g
         bFdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767956344; x=1768561144;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vjKpspm5EV7YLDthnD1/PcikwGNL6s6nU4SX0hD4quE=;
        b=DJsMuVtN9kDMgJ57bCvo1cYY/8BGEM/DcZJMoosuCiHrfKqYXpY+ZcgKnn9KTIF7Yv
         HMa3G5jyMVcgS8JLYaHD/gTxNTyxJm80RO0Xbv7mMOeUmHDGunzK+0ekrL4Lz8JchHfJ
         hg/D5jQB3iY+nYzNyoCuLslMnrHq/AvQcuq915Vcsrzq755GwohgmrV57YavQ2nOE4UI
         5S6clKaVihKZqvSu653xqsiAiqS3F0wWp4Y1hP7aqpb8sjCQgJeRN/69DeD+Dp+km7CJ
         NpYXqjaqsItNHUqAMeojGo4qu6jrkQxsWK4ZG6NNv/Y4bByyrgqTJDLig052rnJFkwG+
         I4bQ==
X-Forwarded-Encrypted: i=1; AJvYcCVRTqiLmX/ULQIrjQ3nO+r9YNSOEeimLTQjKNWz6ev2wBLvT1mPDkvFoAisN7ysyySkE80xrJ54CA==@kvack.org
X-Gm-Message-State: AOJu0Yx4k6bjyymp1nwtFZOFmsWJr0Uv4BsLE1ZJDYy/3d3HRNpTom+t
	gy2npjFRJcrReZlVHtLWhZPxTLvMPb9bnVc/6H3QqSbJ7kO4n2xxs1fKA7p7zaarLyGfe+Cos/f
	8u1qVrps6olQ3rNS9nju0PCCpMlgWAWjI/VB1XYDl
X-Gm-Gg: AY/fxX64XN8Swe87iYGQeDAuqsBT4Q0ek+vB6dcAtu6rdC5LYQubjCQr71JtPoDQxJj
	Pl3WcX0dJYpORWcecCgJBxytQboHX1fzixdDB0MniX1o1pDn+Ed7EaV0FadjAfjtX29Idk+As1F
	fZ9AGpU16hhxAR1T4uscmMna3k3XQsIIURW1slpR1ZZcnFVWajyiKaOKlm8tao8AmHi0STMo8zK
	K+z/oXEfnRIiP/QIwDtw5IozuT+vhLXwNmhdaZj+eGVOP8hwp5t6eGFzb/3ibYS3QqTlrLUkRgb
	mcaFH9NGghUW2nsmXGINj9omUkmh9A==
X-Received: by 2002:ac8:5813:0:b0:4f1:9c3f:2845 with SMTP id
 d75a77b69052e-4ffcb1dbcb5mr7737871cf.9.1767956344270; Fri, 09 Jan 2026
 02:59:04 -0800 (PST)
MIME-Version: 1.0
References: <20260106162200.2223655-1-smostafa@google.com> <20260106162200.2223655-4-smostafa@google.com>
 <aV56BWisUQTMK2Gk@google.com> <aV-PvBqQ0Ktiha8e@google.com>
 <CAFgf54o4Ja7jQwxo6XyW+JaT+aUuj3O2dvLqOTb+YSVCKTdvyQ@mail.gmail.com>
 <d6236413-7385-45c5-94ad-8b0f2007f1ac@linux.intel.com> <aWCviSCK7IBddLTn@google.com>
In-Reply-To: <aWCviSCK7IBddLTn@google.com>
From: Mostafa Saleh <smostafa@google.com>
Date: Fri, 9 Jan 2026 10:58:51 +0000
X-Gm-Features: AQt7F2pEeWJ6MSDs-bAsV_zgpkJn7JOAuCuT0pnnsMA7dTDj8j2QHY6aPfJ6_44
Message-ID: <CAFgf54pWkz19B3TYCqoBTwPLDzV9FfpchC6PrEa5BZ2J52fb+A@mail.gmail.com>
Subject: Re: [PATCH v5 3/4] iommu: debug-pagealloc: Track IOMMU pages
To: Pranjal Shrivastava <praan@google.com>
Cc: Baolu Lu <baolu.lu@linux.intel.com>, linux-mm@kvack.org, iommu@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, corbet@lwn.net, 
	joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, 
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	xiaqinxin@huawei.com, rdunlap@infradead.org
Content-Type: multipart/alternative; boundary="000000000000e173480647f269a6"
X-Rspam-User: 
X-Stat-Signature: dpniwseazmewqe9ij8f3efye9pthh44f
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 83C2DC0003
X-HE-Tag: 1767956345-96166
X-HE-Meta: U2FsdGVkX1+KHXH2HfPRbImxBtrmFGUuS2mOK3GljrmrnxYKGwmO2T5+cQ706H+pNjWiQAMB6Mb+SBu3lv3QVVDSoYCGDX1xw6zcWyv/ASjH4eb6RG9wvrAxYtNl3Dc1OAKRqXc18WjzVgXKx08VZN+qYmTxqBcUtZrESg3rtkTZ6Xuw5IKTa88JGBYtblT1oDAI9S9E54+ij4bDBGn/XVevSrBnf3gE+0LAydVK3FGNsfYFkbOTkFFa8LX8iVA2D0TfIZuDkOTPYpxlZWWE5nN/3zKvUK9epxB0J2gpiJtuCnozZlmwcRJNhevzelNB8FYGZYRw9+NnR6uKKTkLc1ufmpPa1N8htJdEw5cod7+yUYI7laP0MmSgkv2jSaNxpf7dRBdr8sBLhWWbk/5/RuVd4fZPdV/zyd813akE22yciRIMBaqXIQ4WzF3xlqTv4yZcVwOEI2A/tM4DgcXpAwYjOx24/o7VudXmGDMKmj/SDgpm7PfN79ds7lZllXe7+tAKZKPXUicqhxF3PRgt4/UqoFK9xm35rch6nIi6FNMeqkkffHWaO1tNfB+/Dv3voKrxkGwACViqJ9V0Ia3lyR4/TABBCU+z6HHHtFmRc4Obui1UaTd1IJ1m9YO6uTE2MIf8nvmylSWKoVb8WUO3B+pml4MdTc7ZlPqMLl9txaTHeuDAOwBtIzGLEysqLA6iv21Rgza95rw5XGkiVwlun6S6mTh/LRquwiVqnBJlQGVg7vtEn96bVMKlVE3N/KdZMwAYkkG4/tCu8Cjz35t8M+sBvFsJKsTE6gslHCVG3H8cH3gutqXQ0lA0FZr5qAFjiLkeh7kj+1SGmR37em74hBrh/o01WS7wfbfX0nUBNB/+GPsvlHw7+/Q/yvd5vKhxTzVRGqfrm58CYgAKZ2d4MIVCObzhclZS0UJiLvSrFZWvEP/U6E5DZzK6l3EJeYxJP7Ts/O4GtwFUqHKMzhc
 WiE9tpvJ
 SB3ycMR7iXB0KaxLE+lZPqnYKdpyGBtKBDPBLdDP7ymF1Fox3GmyXdcyjT+Q1OmFj/pPbjRsceW1Hv0BuJnDH4pJKAPwOVMKbVr0BOx66/SCh5T0PfCMqdH1KBKmYmHLFQywV4L5rhhmKSFin18kHa4r+LrQusrpDwhg7AlU3l7kIX8E2tb+mXNqhISgsyigvMTx78540gNBBqwlaMrXhgyei2zA81dbzggdEcj634tV+jSWVefufOCfLDNulsc30W4/RH3EYKCM4BwtDijtydvWEAa9NpMNbhAqB2M0Z6XLOIqJ7PQXAm0rwDUdq7USUcgREG4VOV0WfPTvBvJLP5XHaVn87vvoLr+w4cnki1e29pYc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000002, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000e173480647f269a6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I guess both are fine, the condition is so simple that anyone looking at
the code can figure it out.

Thanks,
Mostafa


On Fri, Jan 9, 2026 at 7:34=E2=80=AFAM Pranjal Shrivastava <praan@google.co=
m> wrote:

> On Fri, Jan 09, 2026 at 11:28:32AM +0800, Baolu Lu wrote:
> > On 1/8/26 19:33, Mostafa Saleh wrote:
> > > I have this, it should have the same effect + a WARN, I will include
> > > it in the new version
> > >
> > > diff --git a/drivers/iommu/iommu-debug-pagealloc.c
> > > b/drivers/iommu/iommu-debug-pagealloc.c
> > > index 5353417e64f9..64ec0795fe4c 100644
> > > --- a/drivers/iommu/iommu-debug-pagealloc.c
> > > +++ b/drivers/iommu/iommu-debug-pagealloc.c
> > > @@ -146,16 +146,12 @@ void __iommu_debug_unmap_end(struct iommu_domai=
n
> *domain,
> > >          if (unmapped =3D=3D size)
> > >                  return;
> > >
> > > -       /*
> > > -        * If unmap failed, re-increment the refcount, but if it
> unmapped
> > > -        * larger size, decrement the extra part.
> > > -        */
> > > +       /* If unmap failed, re-increment the refcount. */
> > >          if (unmapped < size)
> > >                  __iommu_debug_update_iova(domain, iova + unmapped,
> > >                                            size - unmapped, true);
> > >          else
> > > -               __iommu_debug_update_iova(domain, iova + size,
> > > -                                         unmapped - size, false);
> > > +               WARN_ONCE(1, "iommu: unmap larger than requested is
> > > not supported in debug_pagealloc\n");
> > >   }
> > >
> > >   void iommu_debug_init(void)
> >
> > How aobut
> >
> >       if ((unmapped =3D=3D size) || WARN_ON_ONCE(unmapped > size))
> >               return;
> >
> >       /* If unmap failed, re-increment the refcount. */
> >       __iommu_debug_update_iova(domain, iova + unmapped, size -
> unmapped, true);
> >
> > ?
> >
>
> That's nice, We could also print the message as Mostafa mentioned, like:
>
>         if ((unmapped =3D=3D size) || WARN_ON_ONCE(unmapped > size,
>         "iommu: unmap larger than requested is not supported in
>         debug_pagealloc\n"))
>
> An explicit "This is unsupported" warning makes it clear IMHO.
> If a driver triggers this, at least we know the sanitizer state isn't
> supported.
>
> Thanks,
> Praan
>

--000000000000e173480647f269a6
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I guess both are fine, the condition is so simple that any=
one looking at the code can figure it out.<div><br></div><div>Thanks,</div>=
<div>Mostafa</div><div><br></div></div><br><div class=3D"gmail_quote gmail_=
quote_container"><div dir=3D"ltr" class=3D"gmail_attr">On Fri, Jan 9, 2026 =
at 7:34=E2=80=AFAM Pranjal Shrivastava &lt;<a href=3D"mailto:praan@google.c=
om">praan@google.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quo=
te" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204=
);padding-left:1ex">On Fri, Jan 09, 2026 at 11:28:32AM +0800, Baolu Lu wrot=
e:<br>
&gt; On 1/8/26 19:33, Mostafa Saleh wrote:<br>
&gt; &gt; I have this, it should have the same effect + a WARN, I will incl=
ude<br>
&gt; &gt; it in the new version<br>
&gt; &gt; <br>
&gt; &gt; diff --git a/drivers/iommu/iommu-debug-pagealloc.c<br>
&gt; &gt; b/drivers/iommu/iommu-debug-pagealloc.c<br>
&gt; &gt; index 5353417e64f9..64ec0795fe4c 100644<br>
&gt; &gt; --- a/drivers/iommu/iommu-debug-pagealloc.c<br>
&gt; &gt; +++ b/drivers/iommu/iommu-debug-pagealloc.c<br>
&gt; &gt; @@ -146,16 +146,12 @@ void __iommu_debug_unmap_end(struct iommu_d=
omain *domain,<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (unmapped =3D=3D size)<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret=
urn;<br>
&gt; &gt; <br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 * If unmap failed, re-increment the =
refcount, but if it unmapped<br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 * larger size, decrement the extra p=
art.<br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0/* If unmap failed, re-increment the =
refcount. */<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (unmapped &lt; size)<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 __i=
ommu_debug_update_iova(domain, iova + unmapped,<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 size - unmapped, true);<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else<br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0__iommu_d=
ebug_update_iova(domain, iova + size,<br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0unmapped - size, false);<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0WARN_ONCE=
(1, &quot;iommu: unmap larger than requested is<br>
&gt; &gt; not supported in debug_pagealloc\n&quot;);<br>
&gt; &gt;=C2=A0 =C2=A0}<br>
&gt; &gt; <br>
&gt; &gt;=C2=A0 =C2=A0void iommu_debug_init(void)<br>
&gt; <br>
&gt; How aobut<br>
&gt; <br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if ((unmapped =3D=3D size) || WARN_ON_ONCE(u=
nmapped &gt; size))<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;<br>
&gt; <br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/* If unmap failed, re-increment the refcoun=
t. */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0__iommu_debug_update_iova(domain, iova + unm=
apped, size - unmapped, true);<br>
&gt; <br>
&gt; ?<br>
&gt; <br>
<br>
That&#39;s nice, We could also print the message as Mostafa mentioned, like=
:<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if ((unmapped =3D=3D size) || WARN_ON_ONCE(unma=
pped &gt; size, <br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot;iommu: unmap larger than requested is not=
 supported in<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 debug_pagealloc\n&quot;))<br>
<br>
An explicit &quot;This is unsupported&quot; warning makes it clear IMHO.<br=
>
If a driver triggers this, at least we know the sanitizer state isn&#39;t<b=
r>
supported.<br>
<br>
Thanks,<br>
Praan<br>
</blockquote></div>

--000000000000e173480647f269a6--

