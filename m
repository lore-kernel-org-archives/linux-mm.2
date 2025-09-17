Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43A93CAC599
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 15:25:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C4608E0040; Wed, 17 Sep 2025 11:25:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 177238E003B; Wed, 17 Sep 2025 11:25:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 062D88E0040; Wed, 17 Sep 2025 11:25:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E92A58E003B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 11:25:03 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AFDAF13A9A2
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:25:03 +0000 (UTC)
X-FDA: 83899115286.19.6002472
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 564B8100016
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:25:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PIRa6xfG;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of gpaoloni@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=gpaoloni@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758122701; a=rsa-sha256;
	cv=none;
	b=u/FqIUh2mM5nn4FPaB7hx8qJRdZ3lUursGRvgOinFBjpuIyQYPfT7n17pgM5TEEHwg+v30
	7rV/4CGE3nlxicU3S5JWiA73fWoft0WD5G8RAcIoPp0SCumIwAAgyCdDVEWLplUBmcaPtD
	bgsUn9i0Ash/et+CWSognQT881yu7Oc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PIRa6xfG;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of gpaoloni@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=gpaoloni@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758122701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nOCE7GBioLoeEPVZjsvaFHh39u6q73Q5ex3kMGocTYI=;
	b=h1Q2ZS8j8pd0sx1myyJq46QXg2Oepx05yVrSRzRsOXhjOYtrnBa0KCG48gFlcSob4fqbBf
	GUaBNHaKagik3AV8McVuyONIz85/g+jRbuC8++1Xnrb/yVSQStTV1mtYy4jQsloxZVdn3f
	A/1ukcwJ1XypXtfyB+bMMjIhSZyJOa8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758122700;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nOCE7GBioLoeEPVZjsvaFHh39u6q73Q5ex3kMGocTYI=;
	b=PIRa6xfGewcl9ziM4Nw6dgQPT6cC6Q72lpeHci9fgqQ87xJr/lJ18LRQd9LWtgTH3vJo3Z
	dAY9YOcuKDkZ+TPBc3fgJAZyQfAqo7g64OXXvTEIEY8rNoMWLcCXLla1gX0Xx37d5Np+pY
	skCnNGAoNSlT3euq8N1FSm3LpMrMLEQ=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-274-x5W2zUrYNcmFJRZMeanaHw-1; Wed, 17 Sep 2025 11:24:58 -0400
X-MC-Unique: x5W2zUrYNcmFJRZMeanaHw-1
X-Mimecast-MFC-AGG-ID: x5W2zUrYNcmFJRZMeanaHw_1758122697
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-4b7a5595a05so75930051cf.3
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 08:24:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758122697; x=1758727497;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nOCE7GBioLoeEPVZjsvaFHh39u6q73Q5ex3kMGocTYI=;
        b=xRP1JIe5Jbf8F3Y3INIgWWV7fH+6f4KmUkuxVuoPLpR9jsdDffQo9dMFeNDFmzbqf5
         NOl1a9bQmchzYMuP9VTSzvw4mN4/xYn6Pprz0xNvl7ZmqkgXPmEZmDDAhFWYXX9DPq84
         8d9UCw0zFl0Z1GmvUG+5NwlqEGhJKSH59/ZpqJ39nVqYeZOrMovojgGt/n+iA330zBT7
         bcy3Y4dV2v9RydDko2h1lkB1bY2k2PMIWKbh3+PUfB3d0FXeGHQNbhUy/q5qkvUXhkOz
         xxuq7u4vn6i1lB0zmZkMdAX9Fs31hzh1zmIYVBZsFVWjlcSqNVe5r9Bz/U2jbDu0lYlG
         OKXQ==
X-Forwarded-Encrypted: i=1; AJvYcCW3LuUIiYFjd6yGQZA1JC8hP2u8TzeLDovL53K8RFtIZYeiLE123ohluLYLH/gBLKBbzkdgArI/hA==@kvack.org
X-Gm-Message-State: AOJu0YwvTX2DhkP8dGtqsaPxZ4EKIJPu2LSDmqyu2LneXek3KNENdwJW
	MqdGuGk23jr2kh/TI33sMc9EGjPQMxTq1uNUySQK7zf1gh8VJYzvqrpkt/suDyPROPtMBU7Vp+N
	Uo0/k0SAEpgtwxukVuKC4RZaAMljlykMH1oWL079G/mk7nTtQX+3ZvvwQOjK0I8v2UgXxF4aLYU
	tHzZPz1xAyeCayy+C5g3/oWwxpALI=
X-Gm-Gg: ASbGncv+O1Y2A69+WCR8VrVdKav6PB7E6rVDSQfhP7lCA+x/LyZNQicGXlaqD3+BULa
	ao7iA8CNg4Q2Tn3gPkKOucZvDvQERo5/X73iNr8f66V1EoboglWYZnuCyBKkAuIcSX1B9NURbGx
	LsHsWZh4zSEXFlfnGzftcunWW/aaKnjDuBp9muwt7P/I+pZeVaHuAJKg==
X-Received: by 2002:a05:622a:1e15:b0:4b4:8f2c:ba40 with SMTP id d75a77b69052e-4ba6a5db701mr19915951cf.43.1758122697473;
        Wed, 17 Sep 2025 08:24:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFGX/u0/DWoQ2j8jO01gOLX81vhmFXebVct9qpuqQjgpv8prCPbkq0kI6Uh7cjMspWrlS3R3UWH++SHXByzydM=
X-Received: by 2002:a05:622a:1e15:b0:4b4:8f2c:ba40 with SMTP id
 d75a77b69052e-4ba6a5db701mr19915641cf.43.1758122697037; Wed, 17 Sep 2025
 08:24:57 -0700 (PDT)
MIME-Version: 1.0
References: <20250910170000.6475-1-gpaoloni@redhat.com> <20250910170000.6475-2-gpaoloni@redhat.com>
 <878qifgxbj.fsf@trenco.lwn.net>
In-Reply-To: <878qifgxbj.fsf@trenco.lwn.net>
From: Gabriele Paoloni <gpaoloni@redhat.com>
Date: Wed, 17 Sep 2025 17:24:45 +0200
X-Gm-Features: AS18NWDoDDpQpUCvPoMLIIOoLe9NuL6mhF4S2DmGBGnkJMhA8eLTTv_JNTSuMdM
Message-ID: <CA+wEVJZreV0zpaNT70_FjuWwEujppsP4ZW_miqdRSfcHyXWrmQ@mail.gmail.com>
Subject: Re: [RFC v2 PATCH 1/3] Documentation: add guidelines for writing
 testable code specifications
To: Jonathan Corbet <corbet@lwn.net>
Cc: shuah@kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	gregkh@linuxfoundation.org, linux-mm@kvack.org, 
	safety-architecture@lists.elisa.tech, acarmina@redhat.com, 
	kstewart@linuxfoundation.org, chuckwolber@gmail.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GGYPCh_D3KY6LMy08cYUfWBIHEt5AEIVcMlY3aNelUI_1758122697
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 564B8100016
X-Stat-Signature: axqhu1cq1k5x4cq3gn783j7qj5scan9j
X-Rspam-User: 
X-HE-Tag: 1758122701-108141
X-HE-Meta: U2FsdGVkX18C4i6O8l4xOAygaGBNI/xB6FsjGhdIv82AIRecvaDdG1eTTbfMQZoTFDYknGQr+i7Zqq0uNFX0kYP5HegP67vlDdY0RWkFpBX0hHcZ+4xEUz12Fcnu8/fSvebYTdi/2FhDtp5qFu4JY8vlui6pUut/aUscMaQHUWxr2blbqnjinGhzpudVylLcM+pUwDzMOp8VI+N6x8+6hkSLw07W/MJ6XcjPcYRZ6HkwW2T8QbvE91XGA3VUawaFZPZwB50HUQ/N+Lrz6f+gz3pQ9QvqdMn3fwAer88D1T2y/dFL6ozuiK1EbT3n6CV+ToiESqBuRABtDGZaTsWg3+KZvdTxNkP1PVYfmhVEDtOr4ajxKVusa4oJke5j7R3ra6XKgQPr0I3hKEaBNoUQTqdAZ/KIT1JafC0ISSc7GbHkIEmGR1KmYufXFxRmDh7DOq9fDFKbTvmfWgbtLhfqxGheJUZ5/qGbPqZvzWQ3kwOFUw8z0KNUJVxi4TmLokNkqHwMVhy4jr+dsWB6rFhjwdztMPsWB6h3LcA3MpW2jlXkBQ/gmc5WghDSQFuqGmmeDUkJRhJPe/hsU9t/4lt4BbzwFdvSC+y+n/6JKCJurlmz8ptWVSAkJlKISxg009dSwDfaMfOhvq64YJLkDhXOzMJbEnZKHVGHMZUThoHU/qKe36Qs0M5jQ2OdQ/Yff5aBZJFqB1hukMwTHffsgacNLn+xBZ3hqk3LHL9RifY5Cx3ZmBDnINbCcJumUpAO7E1MLE6qr4Awqw3eNFxNXlHovywu5nFKgAatCsoo/udexaoEMbmhxF6x1wjt7tEdThYrPqw8PxQcR0UYz9ZNCMpdd/skkuN/o2gG5296Ek8t1JnCHOt8Gy0psg/zC+NBQ93ModzS8Z5smlIC7YNBtcNPZBP6NsLvAoPqofp1Fpir/FcTAo87qwXIbZy8YuJLqAsR882zae6QjbTuST+am6r
 kVaMq6e6
 VcSNiTbZmHqCiCZM+59mcmCmc8Oox/Mk6OoOdNuPly3znIb5elMF07h+thU5nJpNjMPed/E02sjnktOfWVEvnEauLHYQyAZfbR3GYyuz5uwR9PaWrHLzbXFHNTQIfAQt9YUDqYzU+yb6elvciQi0ljiWyUuzHI9nPY1YYX6c7u+KDoigR3dTFM29k6adGeGrcYdQJewkLenl5AvfCAn7A/IIcNC0r8R81CZ5SsAXW7f3kgdRhcnILxEQMTd2HvB5MvYsuu0UoKHDdHLRHgeHTYPSxlsLnsJ8RnoLstuhuXPO+Jy3LxnuBuABUtSqBgx1pxaIppNN/KEg1iOYKwrAKTgf45rdqJZJrEFq2VFiLUI15yjYua4Ii9tbZmyM6hBZEdBekvcJtBXPRXvT0p5uyuWqMQ28zB4zf0/At
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jonathan

Many thanks for your review

On Tue, Sep 16, 2025 at 12:34=E2=80=AFAM Jonathan Corbet <corbet@lwn.net> w=
rote:
>
> Gabriele Paoloni <gpaoloni@redhat.com> writes:
>
> [Taking a quick look...]
>
> > The Documentation/doc-guide/kernel-doc.rst chapter describes
> > how to document the code using the kernel-doc format, however
> > it does not specify the criteria to be followed for writing
> > testable specifications; i.e. specifications that can be used
> > to for the semantic description of low level requirements.
> >
> > This patch adds a guideline that defines criteria to formally
> > describe developers=E2=80=99 intent at the function and subfunction
> > level in the form of testable expectations.
> >
> > Signed-off-by: Gabriele Paoloni <gpaoloni@redhat.com>
> > Signed-off-by: Chuck Wolber <chuckwolber@gmail.com>
> > Signed-off-by: Kate Stewart <kstewart@linuxfoundation.org>
> > ---
> >  .../doc-guide/code-specifications.rst         | 208 ++++++++++++++++++
> >  Documentation/doc-guide/index.rst             |   1 +
> >  2 files changed, 209 insertions(+)
> >  create mode 100644 Documentation/doc-guide/code-specifications.rst
> >
> > diff --git a/Documentation/doc-guide/code-specifications.rst b/Document=
ation/doc-guide/code-specifications.rst
> > new file mode 100644
> > index 000000000000..dee1b4f089e1
> > --- /dev/null
> > +++ b/Documentation/doc-guide/code-specifications.rst
> > @@ -0,0 +1,208 @@
> > +.. title:: How-to write testable code specifications
> > +
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +How-to write testable code specifications
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +Introduction
> > +------------
> > +The Documentation/doc-guide/kernel-doc.rst chapter describes how to do=
cument the code using the kernel-doc format, however it does not specify th=
e criteria to be followed for writing testable specifications; i.e. specifi=
cations that can be used to for the semantic description of low level requi=
rements.
>
> Please, for any future versions, stick to the 80-column limit; this is
> especially important for text files that you want humans to read.

Thanks I will stick to 80 chars for future submissions

>
> As a nit, you don't need to start by saying what other documents don't
> do, just describe the purpose of *this* document.

Yes, my goal was to explain the purpose of this doc, however, re-reading
this intro I realize that it uses a negative tone, that is not good.
I will rephrase explaining the it expands on top of kernel-doc.rst
to further specify the expectations from the code and the assumptions
to correctly use it.

>
> More substantially ... I got a way into this document before realizing
> that you were describing an addition to the format of kerneldoc
> comments.  That would be good to make clear from the outset.
>
> What I still don't really understand is what is the *purpose* of this
> formalized text?  What will be consuming it?  You're asking for a fair
> amount of effort to write and maintain these descriptions; what's in it
> for the people who do that work?

The goal is to clearly define what the code is expected to do and how
to correctly invoke it so that:
1) A user of the code does not wrongly invoke it
2) A developer or a maintainer can check if code changes are compliant
    with such expectations (maybe he did wrong changes or the expectations
    need to change)
3) A tester can verify if test cases are correct WRT such expectations and
    complete

>
> How does an author determine whether the specifications they have
> written are correct, both gramatically and semantically?

For grammatical purpose, probably an automated check could be
implemented, for semantic aspects the first level of verification comes
from the community and maintainer review process, whereas the second
level of verification come from selftests that should be written according
to the expectations from the code and should trace to them (as in the
example in patch 3)

Thanks
Gab

>
> Thanks,
>
> jon
>


