Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8D51CDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 01:14:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A6B06B0005; Thu, 25 Jun 2026 21:14:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 757396B0088; Thu, 25 Jun 2026 21:14:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 646246B008A; Thu, 25 Jun 2026 21:14:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 342B86B0005
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 21:14:05 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A74051A02FD
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 01:14:04 +0000 (UTC)
X-FDA: 84920292408.18.88A18AF
Received: from mail-dl1-f66.google.com (mail-dl1-f66.google.com [74.125.82.66])
	by imf05.hostedemail.com (Postfix) with ESMTP id AD56E100010
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 01:14:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=N89TSthO;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.66 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782436442;
	b=lN+uTN/dL3Ajb6xEMHam2j/qg6M0WIAE0pZWDDIWxaqTdk3iHNnfEn7qyLalB9ZK3vrcmA
	EWFfTBQEpItICOcqpBQaqG8qhsrC4XGTbBLf9K8mejqbm/8Laxb/AXIu8zOVQ3PbfCa873
	HyFe3VNk6ray2GiO6VntU1Go6r0vu0Q=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782436442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0QrPux/jb9B/TQh4lL67jDfn0fMtva20UhkYnPdI7a0=;
	b=T5g/3fo0025OrzZMgiw8uhVyDrEFRlu1RvuWb+xc52LtUSBMrmt+tPFwW3A5tfHA2aMpmT
	IJeePno4232Wa9A18SipL21W58MHleSmyhYJN82PeygKBRpv3VEAqnVHjjuVNU6J3la3kP
	/FTZ3R0kskt0u4KmD4xqbeffTZqcLEM=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=N89TSthO;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.66 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
Received: by mail-dl1-f66.google.com with SMTP id a92af1059eb24-139aff562e1so655114c88.1
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 18:14:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782436441; cv=none;
        d=google.com; s=arc-20260327;
        b=JRitJNuUpBkPT1/gvviZWVT3i/skLuv9atBAmyOXTZ2kxjp4/Q094cPWdtMxmhdhEo
         Nmsqj4mkZB1gWRqhigmxhyr7zv1aRvsIg4ZYqr+Ct16uJQAiDj15YuVrOXLBVSu8IWnz
         lZ4BgbdgzPu7bu5RDKKEpMsXHd90nVi8O+M5vezhiZGUkGTEbCvYio7v+mX3B0BE8O0X
         FKNX9nFGSwWuZZC64aEIc9uf187QX9fJBPa5QfEocmJgwI9RAtV7qG12n/YTEjVrIvG0
         dXb+e4WtHLEc1gDsdIIk6Ith0IiVP6RLN7SDJ/ONAwgd43oJvBg64rgsHZM8UaVk9uqF
         X+xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0QrPux/jb9B/TQh4lL67jDfn0fMtva20UhkYnPdI7a0=;
        fh=WfPiwnp/mRGVOg81JlLIn7Dxgcj26n0POC8dG6ZyCKo=;
        b=B7XcQ/ZWNLd+c+k6erJAMQYK6cSZm2FZWMU3k2jg3ongT+FQfAv1xOK+MLH0CwfeDL
         yTAOcxiYM8jqrO45PNHe+YjXtuK84m3rvaizamTCd9VPM6x3kB2sRPMvm6/vURMGKULJ
         s8EuzoQPkQ65WPRyMVhht528s80aXMMqbGyRoOe1SyHIDcPdVHdH+h8UM//Z+F9qCaAs
         UuZQo5N5OWlX91bPdKmmROhAMab05bTe4FkKvWo82TL/J9Jqbl+KLveFN2Ss9fGNJF9l
         SPY+mQaDEHOm0teld1REH8/OUNgYLBPP5RzYZ1T5YNfePQj5hMoDGJO7I9+fb0hlhPsX
         gk0w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782436441; x=1783041241; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0QrPux/jb9B/TQh4lL67jDfn0fMtva20UhkYnPdI7a0=;
        b=N89TSthOAgh0mEupQZ8KdkF+agjs5PuY9UY4EfbWzPgcYf5lKaxclTsbUsVfZykG3X
         cJGAeAudf6KcBTOw7YnTj4kPcbjiSkWM67diugwg35JszEMSKihGeIVv35n2ZHVHvScO
         1K/FRL07cg0cLjrAr2xTbFx0tAOMh62if2t3U+1/n34b87mZW2X5MBrooZmYoyMP9bhO
         BfavdKoPYY2iihf/xjgn5HUSRXWL7N+oIVAmsMa7q+aUDuAFXJa94NCWm65lTdBzrOce
         aiqCjzdxMsVrqziA6a/KG07Yu/65wQMLkkD58c3sXkGZGx83uYdRJzsm+ZL7jmpJktIF
         3HAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782436441; x=1783041241;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0QrPux/jb9B/TQh4lL67jDfn0fMtva20UhkYnPdI7a0=;
        b=akT3fY9OM6UJaTqqQjcik5O0ZjmsB7/JbyMDyomWIPLPnaqUGCS59fQhrydGB0/Ik+
         MLyvXDXAFkpxwYUiJDeE9FNv3sedxoD1KdC3+Q0GTSV2TmYTg7BUk0OK+XR0qHUjYIGp
         KvxaxRs6+f/Bx6cCrujPKodH0uueq/+U2XiBoavJ698sBzAGlfjMFkSH5A/EivMFixBX
         hKR8cYg++NdDihDUdAq1EPCEzcPXFHRekXfs1EQDKcB3SW3fjJ1mvkIUXxUcpUGKMuJ3
         sOqJ98MmtFmJMWBaVqvSBdUXGbV1i0NsK34UqyBg6wFzysjFEB3+8f8zVl0w30GTpNUb
         ikxg==
X-Forwarded-Encrypted: i=1; AFNElJ/NeJNzfAT8oBKHSu2t0kxpamkkjzN3zsZPbp3aWMmEk9AMKmCMdZ11y4Hi46SjqjJLvMpJ2ORVuA==@kvack.org
X-Gm-Message-State: AOJu0YwyGUa7WKN8ZdBXffYnNFyEiQ119jecv913zU1DRAfU/dGc7Utk
	w0Mf/uqwt9pOfaL2ZGKQvUk69FYrIPBjE7i/uBgOIuSpI5GWJz7MY7wOal9EXfb9f1XSax3UWfY
	TAR8oyrg2BBIp2a/NF1c/Zr8ckN+8Ig==
X-Gm-Gg: AfdE7ck6EUiDnc0HQUpasPD4lv8R7Oc1pHNaBcu68QGhBkPgLkPrcQWveFQJ00m1XtG
	uLjIhru6GX0UrY7l05JBTeuMVgxQjHWRKS5+Fl/FO5FLWJJo7/rw9QQQS5up4oF+OeKAm5Jz0NR
	clMrsgrlopU55+gnxfbg5XIqHHD0PXRxoPT9+VucrHG7B4PRUQbPoLNMVZlcYLHss4b1hVGcK8r
	IyQccPcIHwsLu7PG6b9PCD7rQVbQi6txgkiPGIYT8dKINt7XBGBvr0Prl2ePULorWzxbA==
X-Received: by 2002:a05:7022:6726:b0:137:f4ec:29ff with SMTP id
 a92af1059eb24-139dbaa660amr3557337c88.22.1782436441314; Thu, 25 Jun 2026
 18:14:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260624001425.77489-1-sj@kernel.org> <a9018e68-866a-c251-9e0a-67e31f4baec2@huawei.com>
In-Reply-To: <a9018e68-866a-c251-9e0a-67e31f4baec2@huawei.com>
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Thu, 25 Jun 2026 18:13:50 -0700
X-Gm-Features: AVVi8CfGl0EXx2soTnROovfPq8W8ILXy4EngHWeoIXW7I1TDJmmJsZwRtoDNA1Q
Message-ID: <CALa+Y15kQbXW8NnZtbjr79_K9ooBBy5JemgHXqASABsNPJRqgw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/6] mm/damon: hardware-sampled access reports
To: Zeng Heng <zengheng4@huawei.com>
Cc: SeongJae Park <sj@kernel.org>, akinobu.mita@gmail.com, damon@lists.linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	akpm@linux-foundation.org, corbet@lwn.net, bijan311@gmail.com, 
	ajayjoshi@micron.com, honggyu.kim@sk.com, yunjeong.mun@sk.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AD56E100010
X-Rspam-User: 
X-Stat-Signature: hmxq3ybf8pyidkzz994rxaryt8musy6a
X-HE-Tag: 1782436442-178846
X-HE-Meta: U2FsdGVkX1/K0A7GDkwLZ/MSDZJfF+O0AGQZuYjQzpZEiM1pIDvIuASv5MjJX7T4VQcljAuiNqlADCRC+cAdsKGHqbLCakWVG0B8c8n8UpLg8WFYPSjmwWd7LjJ5GxY/Ilw388k3yLJRpsDcalKOvHCN2LJMGy679hepPUoKuOesx1OYB6yD89KqpAmt+IyTkSKty//KVus/6Wgh9MtGJIiNFK+X1JxnF1dcdP4xfL0rHLZm0TxlvqpXKTONaa8BeYfI41lJa1UIsZhUR8rMfAH6bOnUfmm74aTK8dJESyoY1dl96xWF1nxnpSD76iI/d6j6SlLBmq1adUEYlq03fabF7mCdZf1gZMEmaYwq2NiqLm1KGmVdf+AuWElY7GU8X9K/Lj4BJMSfd47t5KK86nNUif9E9Q2v5UA69QSBwzAXhrFXNRy7DOGHh8zpjMeCxR2+nf2+5StyrI7oHISdTfasCBMLzLryTPIVRdgfIYzjJWaI2JPk4Obz/+AQoG1rxV/9Kpd/epHrNB621aJQBiCJeN8J9jpZ8XXre8bqKzUe1+iXpdhK/0qMX3sLabwpQpR4tPVbLmxBagMgey6cjVzV8gpRt/PFPdbcuGEEurNSQ0gz1hE9g/lcfZ980LpF6XQMt88uIvELFpa6fHr44185+COpmmX70w0yqoQAORPoxin4GQWRJhrNYjkeRS8W6JgUpJrwpHPXWhZR54iSs6iFynIO2L9rBwDPUrgMvhD0C7wJaNxhpq8LEXCe3KXgW13u3QEY0EekQC6jU5IYLnF7XUS96NWAvWeaiRCAR9y9T98iekT6TnKPxv5MuDyjTqbL/hXls4fVqT3KEf4leDmOnvu9bvKIbdPs0Zi83nEx2wxXw3DKQqnbOaXlkXVU15DnHkEUjrij0v9XuHdo0hxeuQzrN2+mMyndsADsyfvF0fZjjC2wBg2eMzabUwH1DMze05hu/yg9lPqpSKe
 Xq0bSP1q
 JWZydNNPf37d3JbIbiPxt85NWyLuYkopUIIVTfk7+So4mFtEfhRkoxXQQYVJyrvdBvmPRYKFCfNAuFMwXEDbdQRfZLP+7+SQzeUjIA1qgt0iqzWiSpOUEEczpnsZDx+tDRd7CwmUj2gNxDkUj5cYaCidy8qOJU38xXvtQBDqj/e6KdElUP8xO/Ugxpwk3h75uy8VjLQVcCZ686z0kzjp9i2wU1BZhk+h14zw4/TAjulGcShUJ3Bt011oW8wm08xrlWzoSg4+83O8GtwIQIpMNVNOjLt4OSKTyPBmdkw7/rpp0k9BxxDA5BKG5G/9ohtp3ok0N6XQ86DrnmX5b/CkiUBhYMTkdKlJTXc9/u7VTo5HqU+BeEstbWmOI8Dv18QeCgsNqQxlOHnVxNylHL606EomekHfddOmJmkgF2efFrcrRHTM2nZQnU9R9ySJ7/pE9t7UXdrF3Qcn3civFg9ZJklKIQP32AczI81QLaW8oa3Jz+RivhkYKcy1CRghxwoDc4iwWtY0DLh3oGCoLGz050sZRiSihtZAhyekr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Zeng and SJ,

  Glad the branch built cleanly for you.

  You can also refer to this branch, which carries the same series
with a few fixes from an internal sashiko run, folded in preparation
for v2.

  https://github.com/ravis-opensrc/linux/tree/damon/perf-event-integrated-r=
fc-v2

  Note this is still based on the v1 sysfs surface (raw type/config
knobs). The v2 I post to the list will reshape that userspace surface
to align with SJ's milestone plan, so the configuration interface will
change:

  https://lore.kernel.org/all/20260525225208.1179-1-sj@kernel.org/

  Happy to help if you hit anything while testing =E2=80=94 particularly
interested in which PMU you're sampling with (PEBS / IBS / something
on your platform).

  Best,
  Ravi

On Wed, Jun 24, 2026 at 4:23=E2=80=AFAM Zeng Heng <zengheng4@huawei.com> wr=
ote:
>
> Hi SeongJae,
>
> On 2026/6/24 8:14, SeongJae Park wrote:
> > Hello Zeng,
> >
> > On Tue, 23 Jun 2026 22:08:03 +0800 Zeng Heng <zengheng4@huawei.com> wro=
te:
> >
> >> Hi Ravi,
> >>
> >> On 2026/5/30 0:56, Ravi Jonnalagadda wrote:
> >>> This series introduces a vendor and PMU-agnostic substrate inside DAM=
ON
> >>> that consumes hardware-sampled access reports through the standard
> >>> perf-event interface.  Userspace selects the PMU through sysfs (raw
> >>> type/config knobs), driving either Intel PEBS L3-miss sampling or AMD
> >>> IBS Op sampling.
> >>>
> >>
> >> [...]
> >>
> >>>
> >>> Ravi Jonnalagadda (6):
> >>>     mm/damon: add struct damon_perf_event{,_attr} and per-ctx perf_ev=
ents
> >>>       list
> >>>     mm/damon/sysfs-sample: expose perf_events configuration via sysfs
> >>>     mm/damon/sysfs: install perf_events on apply
> >>>     mm/damon/core: per-CPU SPSC ring drain and damon_perf_event lifec=
ycle
> >>>     mm/damon/vaddr: implement perf-event access check
> >>>     mm/damon: add damos_node_eligible_mem_bp tracepoint
> >>>
> >>>    include/linux/damon.h        |  80 +++++
> >>>    include/trace/events/damon.h |  49 +++
> >>>    mm/damon/core.c              | 403 ++++++++++++++++++++----
> >>>    mm/damon/ops-common.h        |  39 +++
> >>>    mm/damon/sysfs-common.h      |   6 +
> >>>    mm/damon/sysfs-sample.c      | 579 +++++++++++++++++++++++++++++++=
++++
> >>>    mm/damon/sysfs.c             |   3 +
> >>>    mm/damon/vaddr.c             | 267 ++++++++++++++++
> >>>    8 files changed, 1370 insertions(+), 56 deletions(-)
> >>>
> >>>
> >>> base-commit: 4c8ad15abf15eb480d3ad85f902001e35465ef18
> >>
> >> I wasn't able to apply this patch series to the linux (and linux-next)
> >> mainline branch, and also had trouble identifying the source of the ba=
se
> >> commit.
> >>
> >> Would you mind sharing where this baseline is from?
> >
> > TLDR: I pushed [1] a tree having this series applied on top of the base=
line to
> > GitHub.  Please feel free to use it.
> >
> > I think the baseline was a commit on damon/next tree [2].  Because damo=
n/next
> > is continuously rebased, we cannot get the commit in a simple way.  For=
tunately
> > the commit is still available on my local tree.  So I applied this patc=
h series
> > on top of the commit and pushed [1] to a branch of DAMON kernel tree at=
 GitHub.
> >
> > Note that the branch is not guaranteed to exist there for long term.  B=
ut
> > hopefully this series will be merged into the mainline before that.
> >
> > [1] https://github.com/damonitor/linux/tree/ravi_hw_sampled_access_repo=
rts_rfc_v1
> > [2] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profi=
le.html#scm-trees
> >
> >
> > Thanks,
> > SJ
> >
>
> Thanks a lot for providing the branch on GitHub. I've pulled it and
> confirmed it builds cleanly on my end.
>
> Appreciate the help!
>
>
> Best Regards,
> Zeng Heng

