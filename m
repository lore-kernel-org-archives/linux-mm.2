Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5ACEFC5913
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 09:53:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 217A06B0089; Thu, 26 Feb 2026 04:53:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C18B6B008A; Thu, 26 Feb 2026 04:53:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D1086B008C; Thu, 26 Feb 2026 04:53:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F139D6B0089
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 04:53:34 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 945825C349
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 09:53:34 +0000 (UTC)
X-FDA: 84486145548.19.9190448
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf25.hostedemail.com (Postfix) with ESMTP id AC3C1A000B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 09:53:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FZBqNtHA;
	spf=pass (imf25.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772099612; a=rsa-sha256;
	cv=pass;
	b=eblDkJXMa9MKMw+XW7w6bKmIC+ZwEji8TeCYO2Qv0yqUsskUFDmC6CXRWdFG+HqJsMenQg
	CDawE29zOZE3AyMKaLW8KR/HOzC/4xlW/e9KzKY8IviNjD6e9FQYhM31aJYd65hfMCXtQ9
	cc8MXm968s/k060JP1hX8LPVi2aj99I=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FZBqNtHA;
	spf=pass (imf25.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772099612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q1V9MBKCdjLBg9I68GTTn3Nt6Dta7BXad7eYAwCnQLM=;
	b=eNRBgIMx0bkCVz2fwcP1xy0zcMuqVc+NXEj0Tk8foWSjyrMOCfjKYROFjBHEV8LEWbvwrC
	SPypwAovxoBHvTOT3rkIcbejkaednF5KHKNtA8WfKpv5ROEiyQ4pc50849AhBrugflQ40/
	PzPGZ2gOd1oa1s0bXZV0ZCj/N8SYH4M=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-896f4627dffso11243836d6.0
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 01:53:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772099612; cv=none;
        d=google.com; s=arc-20240605;
        b=V5UT7aBmhpFxrY6XSVr6Bd9WKx6t0uPQT+tiIxdNOGJKr16BGt/CgpBombmi/Chsev
         isOJo8shULMJnULpZkX9F4grCndiXElfhLTkkb+rrRdK3vQzY8hSX7dTeIsE08UItk49
         Etgp1weAjPlKSLzI+sDuYUgHE1jNDuENe9lG590mpjvzac8PIfuZStE5caQqu6pw42PO
         ktpJVbpnggrE5b/uqbmHc6M+pWJq9QlPT3cq7e4myE/OwkKvShPGk25NCJ0AToas7yYL
         kKaSeo09ycg0pcpQFE8TgwStSvpo477VrOJ8EuKIpCUdg5BMoqsH2wheWfJTNX6dXJaP
         JrKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Q1V9MBKCdjLBg9I68GTTn3Nt6Dta7BXad7eYAwCnQLM=;
        fh=RdUembXHEo3E8JxLre/YYVx1wsjsebpbTgPv+UDpppQ=;
        b=LShA8uDN0Nf//sT56tTkeNFR/VBgQ0fI5RKDQoUMtVrjWpacwj5pHhtmM9ltOlfV07
         NxeoSy2jcy1KBuQ8lMRbZHzazJR/B7dKwjT1pML6N4r6YKd130dgfiCwALw8cW48Kni2
         Rc/9n/p8AJm8taLVjwV93w05Soh8JbSZwWtBdg8umvHOWbtojqjyqlJMpx3Jkq7MIbAu
         kdCwUr45lm35p7j4OKdudZ9jk4m0HP0xK5lCgambVGoOtzIpIy7QvWOubhddIprapKVs
         +WaPw2H56bSL+0QwCUhJ7v6I2HlS3t0AjOzK8ZBiq/Efu0iKRPIlRCFz1EP4OkiXKCpy
         aH+A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772099612; x=1772704412; darn=kvack.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q1V9MBKCdjLBg9I68GTTn3Nt6Dta7BXad7eYAwCnQLM=;
        b=FZBqNtHAbIEiswQt//v21dbDBrHSS4DpDuNJONGIu//ct67lY+JmxRi1sllaJNxRlR
         LKQ9fuos2eKsADeJalPTBcmFtgLR/4C/ZdYnx1xRbFRdB0adBemqc7BKdWEFOrPzCuiU
         t0l3B10cXYReBX17jZTwAQIXuKhvPsHN2nnhkv4PMU0HxYWnVdFKA6NvJSyPE+LbrEK2
         XA9MsmX35Y4rDesUSicaczIUYXIdO+5aH/enHWzGrgaa0bcMyPpc/S4XvsSwFLLFSq9R
         XDhuaFptukFYDNlq1R0KFKQVu95WI/kOsYxcAStXxI3jd4WSZ8iCjkpZ73zzwwbEILUr
         FsQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772099612; x=1772704412;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q1V9MBKCdjLBg9I68GTTn3Nt6Dta7BXad7eYAwCnQLM=;
        b=RqGn/0zsye9rYMh/ql5gt+2WBdv/cCT3GLxiCHsr6+Qj668eHTTmUiJYiIzO5wM0t8
         V06ZU+553tJSGkEAf2YpZWn8LZFunirLGgZw4zlYBKcophxnhdKw5WVpe7vslZXZPmBK
         sb+ReeOuJnkfz5gTMdO+f3+Ud82rbG7kSYka9HdyXvmXOKqM61j9OMCXf9vRT6iY6EBC
         GVoOZOxojVFxhpwUWqkuHP1WHs6PCoC1S8++qlrnDQ+HC5LpjoZ3QBeRroRZ2xfdRUsV
         R89E7VgqRuNCdLFXZjZHz31RQGcvUse1awU+NRNZdrz/xgaqSAZJjuqgDdrkDfJiLBCL
         CnVw==
X-Forwarded-Encrypted: i=1; AJvYcCWL/zcdWMPAFZ1TuVqhP0dupBGFWBv3JzBk1F2Tug9Pr24HtdnJUVRFri8g53b0RjKsYnFyPevqXQ==@kvack.org
X-Gm-Message-State: AOJu0Yzv2cLxeSXdZJbgRQYakgpeOqkSd11BaVQrv5uIaFZCMlyYPMuH
	mgKJS8AfAul8CGZlCvibOmvlXO6zQoDgup5YBqlXE3sXLsvNTF2lxPQlovEt4+4knMH3GbJ5AGy
	1gwFCQBCiduhN1dMogwKiazajK2q3OctuhE/A
X-Gm-Gg: ATEYQzwKiIK4W3rywvZQ1rG1mEXAfcQfZz+jI5XesDi6JkjwwYvn6DERv8Xg2HXmwmY
	cl5sbzRuXhi6xniZT30Yo8PvLsWX1PnbGYAmtT3jiYXpPnTSKzFBmoruzy9QAOaBYcIxtiRtWXk
	mSfYnvL8NQQ6u4JMwvYDBP86XWW7hUS4AOvXZZ1v5IAQkahhjSyllS/FnTbfC4veyzoEPBzQjoG
	/l4Gb3Ws6uRPe4ftLOu17Qb2FPA9xrrQ6ZcuSJDOVJPuzd6U3tp1qg8P5aQOiPMu321HX4oeu3J
	ZXQbQFjX9s5NjKNO
X-Received: by 2002:a05:6214:509b:b0:896:17e6:b3da with SMTP id
 6a1803df08f44-899c7ecae06mr18467786d6.26.1772099611456; Thu, 26 Feb 2026
 01:53:31 -0800 (PST)
MIME-Version: 1.0
References: <CAGsJ_4wFMm4WBM8pi-+wmgsUAu-+W2gC0wNR_UrdecY3-+5uhQ@mail.gmail.com>
 <CAJuCfpH7XEDbuAg75wTr25nLM04a8doMf5hHQZVFcpMqyok6Hg@mail.gmail.com> <hzrnxlu2ukoy5rmwrztrw7nk3icswtwup24jw5nqk2h5xf5crw@e3gqxyjf2pb7>
In-Reply-To: <hzrnxlu2ukoy5rmwrztrw7nk3icswtwup24jw5nqk2h5xf5crw@e3gqxyjf2pb7>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 26 Feb 2026 17:53:19 +0800
X-Gm-Features: AaiRm50Czgjc2NuPXpigadiMT4OWm4zYtOyRgQhKBTyP82CU1lERf_-UulVUooc
Message-ID: <CAGsJ_4wNcXE-X5gVb72CUj2yOV-tbzZdmXM-5VXC9oG+NJWv-w@mail.gmail.com>
Subject: Re: [LSM/MM/BPF TOPIC] Do not hold mmap_lock following folio_lock
 failure in page faults
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Barry Song <21cnbao@gmail.com>, lsf-pc@lists.linux-foundation.org, 
	Linux-MM <linux-mm@kvack.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Matthew Wilcox <willy@infradead.org>, David Hildenbrand <david@kernel.org>, Oven <liyangouwen1@oppo.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: AC3C1A000B
X-Stat-Signature: 8d1ghcfw79ynn3emxxywu4zpdj38am6t
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772099612-860379
X-HE-Meta: U2FsdGVkX1/LNnQCgv4QXPdunljREfWQELbemmrGimT1np5A7zB3xR3+REGcwEcYlo7K1jcwtZ6/eEG8e6orF8n0ci+bVk16eiGy0D5Rc8alCmNK3fexecmPqW9O+iPlQ1+Es4PB/T0A6CtPSnczb25cdVqVftFjFofTIwhIt4DL/E4pd8MdlFBmPEf7mIVScbc2QF741XLeHXXpiEL31fP6kzmREm2rEuvaooKEEov9swNb16IcR2T4SYS+IujujZoaHvPmffg/TJ/IjnQh5w0OPG/NlPJsL165Cjc1a/I48oyOyRz9H9Vde/xpgh7jRmG2NcTwLs2r8jShFaq8lNiuFSExtxviTvRRgyatsFfpEU68lBDRVomewDeBGy6BIAxjyNHn3Bcw2dWooGMi86wA1P6k3e92WQApDA0knUkNTqBQQhYKf/ONs3bIHbVUXpb+WYHs9YxHcUWBFMDaYfHcEMxTdVMgehk+XsA2nRnYwYEG50RFV8m9pjOwIFmcViY9kjtOcCuoQy3EzrM5obhoehzVhzw586yRySrB6PFsqWqW9NbUsgQdq38eoqowFWjvs90PCnnMBrfh2sAY2orfu84iO0hjoXd1XYbOhHkaU9lTlMbOU7wNogTLfTsSXAXxi66Ypm1VHzhFgPC+AYBf1iApnLM7nbeBvCZ0z5IJmSxtgKW6JGWF2/RDwnRVgzFsEB9bxJi8u1Sm30hWAlOkM/vauH1t5g72G9QV2n49F446/sh5UPggny46VvmT/yl1fIOVYyRMUfgEH9Ze1DQmXTnN/Bg8BFYIvwQo7SNeWBoA3MKTpUjUqp6IbTR+oq4WpCPlgYaEIpchKxN504YElcZxO+CHv4Xiu74QTEm20PW1QwjTWrHiRxECeIUzyMsmtqC/PawozvKgMcOiy/vBAclIa4GM6h7Ku4wr4Yy3kab1zAzHb9N5vkn0zl/nP4Q8D8PVFl/i6JKslop
 U/lZo7Eb
 +vlJVvNybFklTIMcGU+PH0LmVCOMy8xfjH16EDlWWUqC5pPgHoXB+winBMkkns6ewYd5jZ+HrjxTFCmLC6FOeu0LpYs18hF252ai61yfmAQ/MtTTcQ/dHzTOUpqbxG5ivB0dLeR+tpjCa+0gkC+sW7iKZFXRMQNsndUdZ/QOZdkTEh30r1JUhc8qRHSNBe0pZ26WjuFRQZBQ+A1SXSWTvhjRAi5yc4auDYydUOPExGFeMwVXnnWhn/UVRR0RfEKeb06LnoPyspQrr7SfjPTJV52v4ZIKpa9WaPZ8gV43kxGhHGCBif9mIDPtfJ8QiVRTfJimIkWloAZYyjK4yaGIwaaHOlTuzwEwP989BD1nlgqj5NaHRAcMOC7EnblvA5Pdl0n1kT78x4GEUD8ecTmWVhw9ucZkAV1DiZ2XxJ5Rnau566b34TizIUKXN6YCWLBrr3Rk/cHkbo3G47c7XqdH5u/5KeVqwO88kqCjAPgaYuKYiVQCsFdVIuFwBTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 5:21=E2=80=AFAM Liam R. Howlett <Liam.Howlett@oracl=
e.com> wrote:
>
> * Suren Baghdasaryan <surenb@google.com> [260224 12:14]:
[...]
> > >
> > > I would appreciate feedback from LSF/MM/BPF on approaches
> > > to eliminate mmap_lock acquisition in page faults triggered
> > > by folio_lock failure, for both I/O wait and PTE-mapping
> > > wait cases, for mainline inclusion.
> >
> > Would love to participate in this discussion. Hope Barry can attend in
> > person this time :)
>
> I would also like to participate in an in-person discussion about this.
>
> ...

Thank you very much to Suren and Liam for showing interest in this topic.
I=E2=80=99ll do my best to attend in person if the opportunity arises, thou=
gh it=E2=80=99s
not yet 100% certain.

Thanks
Barry

