Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A76A6C44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:22:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1978D6B0005; Wed, 21 Jan 2026 11:22:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14F166B0088; Wed, 21 Jan 2026 11:22:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 051596B0089; Wed, 21 Jan 2026 11:22:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E8A6E6B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:22:57 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9C6E01607C1
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:22:57 +0000 (UTC)
X-FDA: 84356489994.15.2BD856A
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf26.hostedemail.com (Postfix) with ESMTP id A50DF14000C
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:22:55 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LLGqK3Co;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf26.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769012575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zZKKP+4IZYFDaCDFilC88QfoYGNpM2dFv0WidsWIKI4=;
	b=Ny8932pjGkmVDYJzLIMIseUBTnqM2jrI47trqAu7RadktcsPhXYiZ4PvwOHkhIU8O8L6Ou
	ihtYUwHYys0sevE/kzSW/rbSe0k481x/ptGXxtkCAa/guQLL9FNYazTQkKvNt8v2dVTJyY
	rlOIR6jhMwOflI44d/EcKFDZItkFTRc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769012575; a=rsa-sha256;
	cv=pass;
	b=Ir8A/exXGnOK2bBpy1CZPtHPxDoGPuHgXfJDacv5VjOx6ha6PQrSs9+6A8M5PeYY8NhU2x
	OBrasUiCvLsXnyzMXK2lJ6bS93ZH2r0gYCSb/2fW0DFSsPPuW49PhtDpmNwdA1cMsxit6c
	g/AEmRawcab3k8/1VS+K20zZ1uzMdjE=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LLGqK3Co;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf26.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-5014b5d8551so474251cf.0
        for <linux-mm@kvack.org>; Wed, 21 Jan 2026 08:22:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769012575; cv=none;
        d=google.com; s=arc-20240605;
        b=ZR3Qb4wx9n4FNo8/1r4y02ZmHKmh4m9J4z1pHiuwExhwUsx+2DwQ37ORJ2Gn4xa1Hy
         alpMzZtwg7/DI78MBfQ+aYJnN22sZoiArc9cDTWYsrNGW35X39yR/IWD1DJZgC0L5vg2
         FXTLqJgSGo3LQHFhKoh0sTmgpFaxVUn0MqFfEg0+cSbYqS1J5xr8TxudxEUYT4Ug0C7q
         uePGJWxGv8W71fOoRq9WDdjq1u/pS8y13xuL7GvEvaXMRLdiynzfZqwXvIkCVHNvV4lv
         fUQoQYFtYvJjAbAXR13H7G+s6RFAo7xcJLPyKeKfEHnkILLTko9jik62iuaw5hSKVzvb
         cYEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zZKKP+4IZYFDaCDFilC88QfoYGNpM2dFv0WidsWIKI4=;
        fh=UVrln/cM8u/WURCFtdAszmpp6N3prc02pnFkwJVs8TQ=;
        b=Lix7OqJdcaPpDnwT+wjC3KBqai3bdP3xq22/vADos24m2Rhxw1+gGH2dqGMwePxFnD
         fGFcvYJhVo1q3bJ9a/sjfwJuUJz7OUh4JIT2e/BsFGoUck6JzEP7mi1YV/m37PFRj3V4
         z3DT41HrqjgDYrizX6Z2RkozLZyVj+4YCDkAlqM1uNW/fA7obowbRACGogmKhwO5R7mP
         O8O779HuVjqsZyeIVizRojrVqhLy+7s27EnEIUhKO+0M4ADaPggXb3EYbYxPGi5mf5za
         E2VsiMmZPTGnKhuEFRKSSdKQYrZQR/2vwz1e08FWv6AU8/18Cy4l7yEvdX/B0HGbSG+o
         NlBA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769012575; x=1769617375; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zZKKP+4IZYFDaCDFilC88QfoYGNpM2dFv0WidsWIKI4=;
        b=LLGqK3CoEDZ1YilEsdo3RZW1DKAhr/eQ0SaEC8VmPoz5z13OHUmmuAhprMaGjIFvu8
         pQgfpqCXy29YfknjVPfAwumyK2NnwWt1H41d/sPQwtp8Pm0bI5CxBEpT2xru/4lncKb/
         s3n1JRflflMb9AI2GxynDqHZnYbyyI+qFDxW+clXyf/Cp6nHJuhNeTn2BU9+laWkPhLx
         aLxiOgJPTVsQJ1eLsaqDDRwl55ehjG5rBNtgHTv/V/1hMgosHZTtl7BCeKxlNYj8jLb0
         eyYoYrZ/M8T6TEGdpXM3OWljgK96XULkgeBPtkBuP657CC3nwLAXMQH40u8J1vIwu5Od
         XtnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769012575; x=1769617375;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zZKKP+4IZYFDaCDFilC88QfoYGNpM2dFv0WidsWIKI4=;
        b=pd3/znQPE4b1EpPhr8zdKCyW9ZqNJEJwIAVJDRrmb88WkyA3PHWrH4FIM3mLE5h2Sz
         7whUWVkoodu9ZsVJ+mqEi96NlX8aBrIjadHaUVLjmyuvS3zrfjyTK0oHddQ21A9GtJQC
         GSDj73UdcnZeuDi9t7ph5CkKlsySgmjJxEo8Cp4nemO1UZFystimCZpPOWk6R434Tgaw
         sO4Oy+a7b6IXCp6JJQf1LSG2AynGetzM/xxksRZkubXcHyTM8AWyDgl5+qv2bjA79UU8
         9B1HV43FXIdJ1bgTDlvtwaMDOp4fjUMLUtOp5slwtfZzN6TpMXHVoxccY7CMDYpS6TlG
         PJWw==
X-Forwarded-Encrypted: i=1; AJvYcCXdI9IO0nQsw5zD5dXFquf8ZtBl+PhDTHEnJClHSp0kh8AaaCeoQ0Kqut6ivgKeIZxcpr05gG39uQ==@kvack.org
X-Gm-Message-State: AOJu0Yz2IzYUjXe5H2ayrTcfz1xkupyIcckvucuoBZGyAvUi/SSnmv7U
	d9ZZ+qvkztoo7ssZ6dRDwsM/k9f7rU1xVAHCEqhGutiC9MD1dkTdokXuQmTjDXRYk7DLP4iVGsE
	VulElnZxvKAW2GWw8kL75z/P3ggNck16VsHMbmX0Z
X-Gm-Gg: AZuq6aIjuRXyRS0unAHzQ8H9D6xg1os3ozJ6iUzgUhYVYzHPIHlph5WrHGAQWyukzBL
	Y8zoj+EF4zi+agCrAzJmCRDg3ql8cWcTrWDfNQMk3M/zsStLConfS0A63OZ6Rol47ib3Z310Tjv
	9y5fmXzet6Y4EtZLLkh9D/PjcvOftJ+RndhmyfDhd4H4HF50IeERChibtook2gwSqF0j1GZMAdm
	/647Ays/gYP6ErRt0laEqZwyESQivryMaHx5SrxrE93y0ntp9/psR6sKwBySLXoJwzTAQUfgHpJ
	c7lu9f5s+iHJULgRRACdHrc=
X-Received: by 2002:ac8:5f49:0:b0:501:197d:32af with SMTP id
 d75a77b69052e-502e0b52d5dmr15160751cf.0.1769012574328; Wed, 21 Jan 2026
 08:22:54 -0800 (PST)
MIME-Version: 1.0
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-11-5595cb000772@suse.cz> <CAJuCfpHaSg2O0vZhfAD+61i7Vq=T3OeQ=NXirXMd-2GCKRAgjg@mail.gmail.com>
 <c17d4413-1ffa-4d3e-8d87-0e7c2b022c16@suse.cz>
In-Reply-To: <c17d4413-1ffa-4d3e-8d87-0e7c2b022c16@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 21 Jan 2026 16:22:43 +0000
X-Gm-Features: AZwV_Qhsac_Z51cYOHKUSuzgrrT7X6Hd2cSKwh2Th8VEqlGKrAYEFKE43eae864
Message-ID: <CAJuCfpFUsSKf89tVe6u29SpN7sL1X_721H5iv2yGwt-Wa6E_xg@mail.gmail.com>
Subject: Re: [PATCH v3 11/21] slab: remove SLUB_CPU_PARTIAL
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, 
	kasan-dev@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Stat-Signature: 33rkfsrrjypkna7j5bj89okz6uwmyuqt
X-Rspamd-Queue-Id: A50DF14000C
X-HE-Tag: 1769012575-381841
X-HE-Meta: U2FsdGVkX19SXvzS6IIyByHjaiC+IZsJyzi1/bpiuIO/Zaa6h9P5qY7tQrFsiDMqd4pnsPv4YhRjh9UUUnIME9eUf2tdAyDg1ieh1whffY7o78s1xiuz7wIK70dne5AZJRoxxRG9ahLiZB7vclXhC0nmEywt7qKsmHrELfnzdlr+MH+SnHT/3yEu27nt4lpApRv4KFxuqPos7D4VsTb54ktMAkghnOjen//iiRbiPn0vSwMq7rNmyVcpDZgsAv/e0NK05mVDaA2g2GyiZBaFD2P15AUTtHQOfYqAPJLGrejlM2t7ZAP+gzRg42mjnpJqmIV1sh3obFg6eTT1ppD8ZRleQOs/N70c6lDouNOorhH5gUD+FNQAcpVxyYHPETBET0NE+eLJjzatGDpBmEnu3Ot/F0POulDSucReKQy+JF7wuEF2tnjr84H4iVAwoLJ2Z+2dxA5aQEO0XWb5tTttoyds77F5v1lRwtT/UGgvIDF/gjouhTF/PkSneEbMZ5AIKh+nVXo6RIwFqSUwfQNxSIQ/g2+/ZAwH4ha7mllq0WkioPs8KDnP9GFAMzmupTUlnllYrnNeZTX2+lEc8jXS2oAXOCi56aiGIYyOGG6XoNZ+cl34kpwZvuNAnUntdPwG23S/7GHKSkuL0GgqZM6HOF0KMFN5ekOuVqVQ5CCbjIKaD0MfUkMxrKAZuvgvTZ+PgaDC9dbbaPSoHkrPVCWZZGMPNPosnOB6/BsjmPCUtnIxB/TSW82FQC1kYsIA2m4l4pavEQA+/BHFFWpzb8bU17DdiEtgniPppTPcYXQRG5XppMnoIrMuDqIdAIw3LutKGIK58f6rbe9fA+1yxIxQEfRjf2cbLvd9ZbFbxZaKVZ3q26LBWYijPS4f3f8U57lv0VIzvc+bpp0vk5OGrQkF+b+4zDIAj1sXfUwBgB5eo3/l7NgfbMkze9kVME5OR2ARJEWkee/VcfpTB+LZ9r/
 WtRrjmA2
 B3ConS2o0s/oX89kWHWzuRP2HyxG1ZjC45MZqvcPEHBaRzsf5AMHmcUTPf8BpwhHeBeSK9xQAuC48XZVkYikKsuDoQPZLglQZm0qVmicwFTA9xEutxfjGyRJhgR92wAWj7Ced5CuU3265DAQOmYo1sAhNl2z5SQs3IwmqDxhJtcRrXcUJJk+CXFl4uGdyf6ijMevyiQwFvg8Z8tdUGIgXRe9DdBwT5+b8OaPD1GxShgu309KPBNdyEmI7FVYASpnUOaPqO0PHnTKg810w1l4yqkWnrIpNdf8KYw8/uZOceYWN2bbWgnTDM84W2Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 21, 2026 at 2:22=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> On 1/20/26 23:25, Suren Baghdasaryan wrote:
> > On Fri, Jan 16, 2026 at 2:40=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz=
> wrote:
> >>
> >> We have removed the partial slab usage from allocation paths. Now remo=
ve
> >> the whole config option and associated code.
> >>
> >> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> >
> > I did?
>
> Hmm looks like you didn't. Wonder if I screwed up, or b4 did. Sorry about=
 that.

No worries.

>
> > Well, if so, I missed some remaining mentions about cpu partial caches:
> > - slub.c has several hits on "cpu partial" in the comments.
> > - there is one hit on "put_cpu_partial" in slub.c in the comments.
>
> Should be addressed later by [PATCH v3 18/21] slab: update overview
> comments. I'll grep the result if anything is missing.
>
> > Should we also update Documentation/ABI/testing/sysfs-kernel-slab to
> > say that from now on cpu_partial control always reads 0?
>
> Uh those weird files. Does anyone care? I'd do that separately as well...

I'm fine either way. Thanks!

>
> > Once addressed, please feel free to keep my Reviewed-by.
>
> Thanks!
>

