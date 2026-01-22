Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD5DAD3EE84
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 16:44:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 271896B029E; Thu, 22 Jan 2026 11:44:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 245426B02A4; Thu, 22 Jan 2026 11:44:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 100086B02A6; Thu, 22 Jan 2026 11:44:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EECD76B029E
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:44:43 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A0DB8C1C44
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:44:43 +0000 (UTC)
X-FDA: 84360173646.19.A854430
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
	by imf12.hostedemail.com (Postfix) with ESMTP id 83AE64000E
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:44:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=s+BwpAJ6;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf12.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.46 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769100281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i278ipBKd9t4eNryNmv1UqNg417NlVEpdzsVGz5SQq0=;
	b=SROixFNcGqFIkYUChsVbmrjUCkEmLiXZdItuDlp8o9aIa3Os5ACmOOpGMAGAKdg01zKMpW
	TRF5JNdNvYNeqdEyzjQ9BoTzrselKdrKwPVQa6LeGzdu/DMzqjtDmVIOmEnuwSceOiZBLh
	e8IzTPLBqWiFRqjDaRU9tdk0b/Kgi+Y=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769100281; a=rsa-sha256;
	cv=pass;
	b=SEw4oaZd+KHaC3gTelZGSGrB8HMlcvEOTWdTbdGKfAvyaV12evQiAP2sdAXhVLK75YRNv7
	Npfi+n3j8Sy82B6EsK1mZRsqMIUSKbvGNr2Cka3beDiwz+f4e4S0569j/Gy7WdiKUoPcPg
	chSgclVzHNlbHI6gaBkIuLDbd7vgQa0=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=s+BwpAJ6;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf12.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.46 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-5eea9f9c29bso785910137.2
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 08:44:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769100280; cv=none;
        d=google.com; s=arc-20240605;
        b=Z6FkZXst2KNlGQulBvYD1wyHZxL75ZZ+Y1g9G3dW27sorm178o41NDpTRkzOQs5qbD
         N7pWxOzetVb4BakpBVFkW64OSuEid/6vUtIoZ5/inZ9J5P6TJEtSqi8BUvLNHim58TjL
         +BgLIKr3PrkJZIbrokvLDcC1NOtu8Ev4vXJDQZpX45R1wwU0/IynKHRim/3URX9RWEHI
         uSQyzs2sDxBgjKUJY2u/J3oxJexn49xLL1bKDWpQruUGzjhxmJY7kzOt46rmRkQGS6ph
         v2b2hzlRssNqA9bwcjkh8FKtcs0Hi0ll39bXfv6HYF24koGOPzLs8oPeqhJ3cXhTNL/5
         1yyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=i278ipBKd9t4eNryNmv1UqNg417NlVEpdzsVGz5SQq0=;
        fh=BZ+T760aW5f+/W0gV4PDM7itWRv8fBHkRj3l+4/Sk3k=;
        b=ad4FvJjW5D72pNZRkCEG7s3AdAXP1YbQyLg1OMfX2tMM5voLZFoZ3ik9InAWiOaSB+
         2klbiOdghLtCd2SnpCO8QafnRSk2GYdzx1/AVZSVqEEd1fRENbGFPDSfgW/XneG49iGQ
         M1RID7JdKivaqErC5hsJwsX4CLvMOwqcuiT3OubDzNjy8zdAY4A7WmYSAmbXEu2zVEIZ
         I//dsiXEuRpM/mrcQjveux0Fwl0dyM8GJc3LJFsMYD/h2EKh5WCCoMlGjzdlLf8T13Wb
         CMxvwZn12wyA3vqXYQ//NxUFN/BXw+OWZggPz49ox9G65iGC9ZO1D4K9EV/0zDJHf/MX
         71wA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769100280; x=1769705080; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=i278ipBKd9t4eNryNmv1UqNg417NlVEpdzsVGz5SQq0=;
        b=s+BwpAJ6FlQN8AdDXGBIvUR9XsLMQfa0e8BBOPbj7gcgy61Aj9H6AOkau6GBIRDPmd
         030VuCK7KfruPtu/uVvuMPZp5oW0XWuu8mbUCDMxUrw0d+CYQf03/GFdTGoWn35LUnpC
         syvyO60k0GL1i+jDka54m2N3M3KbAYeNBcoqVi4Oa71DqFUwjd+QPo1zeOxOF9diK8EP
         r4dhL4uQrlwNcGqSQEVekOypR7yrpga8F7bAcyCLIYRJ0RnkME/+3GEW+YjYcu67P1wq
         zDsjqgBk/myAeNUohhIMvQy2ZSvBOH8wN6kF6ev8JlW7DwxM/r4R8b8TTb7PMP7mX6yO
         n4Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769100280; x=1769705080;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i278ipBKd9t4eNryNmv1UqNg417NlVEpdzsVGz5SQq0=;
        b=YxkSO9oUHGfqreI8QUGguPI+a2tH0cTtlgJsfVTqmzIDkHTZmF2FAAPXRNagF8Pbl/
         0FhB8QUD/ozGTDBraChpEJM91zIEAP3428azs/n9QMC5dykLOJ516i/DpdeTLYHxGDiZ
         iUhjRiolhJatnWyLmQ13m2v4aZtAZb+IZfbZlmtlQz9mXBI19sMj06nkKAg9IQyQqEG1
         gRuwDaZd2lcmnN5lvHaCVtrPGZqMGZsBgkU6hLuPkcsDgQ4DNAtdMgH+iuoTuVkXjS2S
         K/rqyax0khf5R7bkyjhgs24Y/QGHNaSdbiQ3yjo8/jSZ/xoqVQe+cWKsimrkAqC3dFUc
         XwQA==
X-Forwarded-Encrypted: i=1; AJvYcCUvY1PLuM0vUm+36JqqdZI+vXPnzSFPIt0ZUsifG4Ap0+KC1JkM5gvnRX2gGBIWWDtOI+e3JVcsug==@kvack.org
X-Gm-Message-State: AOJu0YyQ2Or4Mmkvs7zBu+tcH+E1/QZJs2c4Jatq8hmpIHDsjVo3aNvX
	QKbMVjUCv248eu1qQ1Mq2EiOJc5EZGVqJQowuzI9i8zY0hzaI+5kiRfqreLquYTnZ/qPJDerHSK
	9cW7St2Khzjc7ulJYGlcO6q+ENs8Pe9ZJHiw+dcu3
X-Gm-Gg: AZuq6aIzKBTJEFE+8gKKE+1oonGBp4X0u/hTcCltuMBZaqoeTbdrtL8GU0UoVWkLO10
	zdh1DwZKWufoju1uZKG/k1Jvxd7S4UbfUYugvK17HQCtxIjQ3AtVCeijet4L+wDosd28for7UkW
	mClx/EraF0nrF1o3D5CCA8iU/LP4LaSrdACk78Kc2MKlbJV3pSWF70MhFJvGENC6OTZYSJIX88u
	w6eXtuhyFb41vZmaP3JKodwRE+jtRnAj8BSjw8Ntaf1AYz/GNotI+S3ndIYs6JcM+Dkzg==
X-Received: by 2002:a05:6102:d89:b0:5ec:c528:4df8 with SMTP id
 ada2fe7eead31-5f54bc628cbmr124387137.28.1769100279450; Thu, 22 Jan 2026
 08:44:39 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 22 Jan 2026 08:44:38 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 22 Jan 2026 08:44:38 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <8c1fb4092547e2453ddcdcfab97f06e273ad17d8.camel@intel.com>
References: <20260114134510.1835-1-kalyazin@amazon.com> <20260114134510.1835-8-kalyazin@amazon.com>
 <ed01838830679880d3eadaf6f11c539b9c72c22d.camel@intel.com>
 <CAGtprH_qGGRvk3uT74-wWXDiQyY1N1ua+_P2i-0UMmGWovaZuw@mail.gmail.com> <8c1fb4092547e2453ddcdcfab97f06e273ad17d8.camel@intel.com>
MIME-Version: 1.0
Date: Thu, 22 Jan 2026 08:44:38 -0800
X-Gm-Features: AZwV_QjFiVCL1GgMB61exuGngD3MnDbAOiFUMFZ1rYdJZrzTGdTea8E5DMfoinE
Message-ID: <CAEvNRgEbG-RhCTsX1D8a3MgEKN2dfMuKj0tY0MZZioEzjw=4Xw@mail.gmail.com>
Subject: Re: [PATCH v9 07/13] KVM: guest_memfd: Add flag to remove from direct map
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>
Cc: "david@kernel.org" <david@kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "palmer@dabbelt.com" <palmer@dabbelt.com>, 
	"jgross@suse.com" <jgross@suse.com>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"surenb@google.com" <surenb@google.com>, "riel@surriel.com" <riel@surriel.com>, 
	"pfalcato@suse.de" <pfalcato@suse.de>, "peterx@redhat.com" <peterx@redhat.com>, "x86@kernel.org" <x86@kernel.org>, 
	"rppt@kernel.org" <rppt@kernel.org>, "thuth@redhat.com" <thuth@redhat.com>, 
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "maz@kernel.org" <maz@kernel.org>, 
	"svens@linux.ibm.com" <svens@linux.ibm.com>, "ast@kernel.org" <ast@kernel.org>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"pjw@kernel.org" <pjw@kernel.org>, "alex@ghiti.fr" <alex@ghiti.fr>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"hca@linux.ibm.com" <hca@linux.ibm.com>, "willy@infradead.org" <willy@infradead.org>, 
	"wyihan@google.com" <wyihan@google.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>, "jolsa@kernel.org" <jolsa@kernel.org>, 
	"jmattson@google.com" <jmattson@google.com>, "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, 
	"luto@kernel.org" <luto@kernel.org>, "haoluo@google.com" <haoluo@google.com>, 
	"patrick.roy@linux.dev" <patrick.roy@linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "coxu@redhat.com" <coxu@redhat.com>, 
	"mhocko@suse.com" <mhocko@suse.com>, "mlevitsk@redhat.com" <mlevitsk@redhat.com>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>, "song@kernel.org" <song@kernel.org>, 
	"oupton@kernel.org" <oupton@kernel.org>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>, 
	"kernel@xen0n.name" <kernel@xen0n.name>, "hpa@zytor.com" <hpa@zytor.com>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "martin.lau@linux.dev" <martin.lau@linux.dev>, 
	"jthoughton@google.com" <jthoughton@google.com>, "Yu, Yu-cheng" <yu-cheng.yu@intel.com>, 
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>, "peterz@infradead.org" <peterz@infradead.org>, 
	"eddyz87@gmail.com" <eddyz87@gmail.com>, "yonghong.song@linux.dev" <yonghong.song@linux.dev>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "shuah@kernel.org" <shuah@kernel.org>, 
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>, "prsampat@amd.com" <prsampat@amd.com>, 
	"kevin.brodsky@arm.com" <kevin.brodsky@arm.com>, 
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>, 
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "itazur@amazon.co.uk" <itazur@amazon.co.uk>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>, 
	"dev.jain@arm.com" <dev.jain@arm.com>, "gor@linux.ibm.com" <gor@linux.ibm.com>, 
	"jackabt@amazon.co.uk" <jackabt@amazon.co.uk>, "daniel@iogearbox.net" <daniel@iogearbox.net>, 
	"agordeev@linux.ibm.com" <agordeev@linux.ibm.com>, "andrii@kernel.org" <andrii@kernel.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, "joey.gouly@arm.com" <joey.gouly@arm.com>, 
	"derekmn@amazon.com" <derekmn@amazon.com>, "xmarcalx@amazon.co.uk" <xmarcalx@amazon.co.uk>, 
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, "kpsingh@kernel.org" <kpsingh@kernel.org>, 
	"kalyazin@amazon.co.uk" <kalyazin@amazon.co.uk>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "sdf@fomichev.me" <sdf@fomichev.me>, 
	"jackmanb@google.com" <jackmanb@google.com>, "bp@alien8.de" <bp@alien8.de>, "corbet@lwn.net" <corbet@lwn.net>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "jannh@google.com" <jannh@google.com>, 
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kas@kernel.org" <kas@kernel.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "will@kernel.org" <will@kernel.org>, 
	"seanjc@google.com" <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 83AE64000E
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: wq7gwyze9na4fpi9ccs6y887fxy1amj5
X-HE-Tag: 1769100281-592348
X-HE-Meta: U2FsdGVkX1+NdiFpDLIbp59M01ad3HcbpIeTsAhZy8gg3XcO5uRl2lK88IBMFYwc+A7NNkwRkSyLGdj117AOsm603ZZAcuLhC2U8iCMBqFR+CsfJAtUwdSfMOUxiFMUr9AlVNW+DclC+u1yxRwLJoFgC2mr1YRYRbD5X8Q4ZR9lCSJazoz5lNJ/QZSQwVSeoybTKaZLmtc3UjeiKIsy6S6GbeszDc6YF+qujf0kA8rmYof1zuRDb0cVmOycx90+NjZbf3wtQ32hmGOENIOgJ5rYTVGYmSivDUNIxhHNqT8uwTmK0Etk72AFm7VDUfVZ3zgtxKk8QyqA7q1x/6UcD1P7Qd+tvz9LXDd/WeaFkf3j5lYzJ7U9WxmoZto206XUTCHnQm5lWNnFRsa7TPV82SLj8tBvzh9iUTOOChGzdMrTB6/KLPGKpjmRBVu8Vgy/PdkGpRcjkI2tldb3tvwzbbJ5cFeKyBVF+hH4DsyyJ6im1EFBbYVA6Bskb2Y9a/4KwrWzs5A5sGWLGlmfi8wysZaDRQ1mIA+H/WwTYh/PFNWAA//G93EUm69QLEfKGa9UTMXYNVlq5qjIQ/QDCxycDeEjLs6DlA8KCEKbX05hc9BuBaYwVyJ9xBk5Hc4Qpsf229PMxW9fKfB2nCiljkRov6LwgeWG7QKW6S6khQu09tcOeiqhK3Z8brRX4FKO6Rz+JuccpR8v5DLPExeJKpKVKvlCpy8iZtUwvTrXYkWDUZhbAU2mczBN52fg3lA9meUs0VKf7vP7KEsOqmFVZ9nbZQlINVN8Z1NnTHWv1KHsNxE6eUYWLDPPDaItKOpthe7sNatHKJR1SDWirXKJkX7BNB+jzFx3by1nyWN+xvCQKpEdaoY01onbqHkHOZXKvksSqjg7Rh+/H91/votopTkW/TFR12s+kUdDk/N16iNV6iXAFVTQo8eUllty+aQY6+E5bSBbjKKJYwHi2vz9CnX7
 e6YVpate
 10RPeq4E8PhFgXYGXncFjGq9H2RtseeGUejTVe4Xy4+tVYzBVXVg22lFdUwn9knqNQHg0Ak+068dI6GmQSq/V1huhlk06ENrCpi5iFrgUCuZI+J6iyME0ItchfEk/il8glgckVkna+WLDQoGBT48XymWOZliNrI31xhVUZROKkiGbnNOWSFhgelwvKPfcLx/ylAbwUfsLiWTTrQHuRuxkLB5DWOha5ARw+3UKie19F+7gfVYCtOWQbCGFOpNtgCwE1QUhlzTmyTXqQB+7tokybHFDDD7fnoDAnsew2upZOp4LEKp5dkq1jDZgpkhbmwcq6t5RYG0D+RA5pOxaZFk8GNswIAOtnljZQ398Rr0PZx7HHg1WoJ56kdSTc344xTVN7TQZukA+d+vqLGKVDhd5vod9M/VWR2cm04RJ34KiOUK1lvB+N07cfNumc/hdCtw8C+XFyzjs0ilTab5ZAv3fZ6bRBHfLgjHV5uWIgLDJw/psG5rZGrb9AQ26lwDvB7NiPQq9wlPQ43hVu/I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> writes:

> On Fri, 2026-01-16 at 09:30 -0800, Vishal Annapurve wrote:
>> > TDX does some clearing at the direct map mapping for pages that
>> > comes from gmem, using a special instruction. It also does some
>> > clflushing at the direct map address for these pages. So I think we
>> > need to make sure TDs don't pull from gmem fds with this flag.
>>
>> Disabling this feature for TDX VMs for now seems ok. I assume TDX
>> code can establish temporary mappings to the physical memory and
>> therefore doesn't necessarily have to rely on direct map.
>
> Can, as in, can be changed to? It doesn't now, because the direct map
> is reliable today.
>
>>
>> Is it safe to say that we can remove direct map for guest memory for
>> TDX VMs (and ideally other CC VMs as well) in future as needed?
>
> Linux code doesn't need to read the cipher text of course, but it does
> need to help with memory cleaning on the errata systems. Doing a new
> mapping for each page getting reclaimed would add cost to the shutdown
> path.
>

Can we disable direct map removal for errata systems using TDX only,
instead of all TDX?

If it's complicated to figure that out, we can disable direct map
removal for TDX for now and figure that out later.

> Then there is the clfush. It is not actually required for the most
> part. There is a TDX flag to check to see if you need to do it, so we
> could probably remove the direct map accesses for some systems and
> avoid temporary mappings.
>
> So long term, I don't see a problem. For the old systems it would have
> extra cost of temporary mappings at shutdown, but I would have imagined
> direct map removal would have been costly too.

Is there a way to check if the code is running on the errata system and
set up the temporary mappings only for those?

