Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59C8CCCFA04
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 15:29:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C2CE8E014F; Tue,  4 Nov 2025 10:29:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 872F98E0124; Tue,  4 Nov 2025 10:29:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7625C8E014F; Tue,  4 Nov 2025 10:29:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6418A8E0124
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 10:29:33 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0831D4AD6D
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 15:29:33 +0000 (UTC)
X-FDA: 84073309026.03.7B325E5
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2665CC000F
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 15:29:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QIegYlWJ;
	spf=pass (imf10.hostedemail.com: domain of vannapurve@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=vannapurve@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762270171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8GNMbexAGe1nKqMzzLVClEkNd7j6DVDRkgcdOMp8ajQ=;
	b=IZH8xyIT8H1XpPDns58/1l5RjufXyCXwPGA2h+wSFJp5j5DL9rMuiySK6hzI0ETPXkU04C
	x+knMeONbKJ5v0Hj6U6KsOoCyobRfoSOlzTvPW53zHN2o1AHc0GLU8C6xDk8lPhqrQGO1u
	rqdOk7PVACHjL9aIFCIYCrNIoz3IdbY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QIegYlWJ;
	spf=pass (imf10.hostedemail.com: domain of vannapurve@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=vannapurve@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762270171; a=rsa-sha256;
	cv=none;
	b=yCGSo8iHS8KVxA/iTrOj5Qm9cbRZGgEXAQrrZWTBwdk5zh5LnfwUVrqSbez4GkXjn8uRqO
	b3AYBYMKnU5Yy/87DWzvkvljXXYq2QwGT77cPkivH42qpg9HTVgz/mS0cYAbSzX4p5OxPU
	XGrkODzBsDiXelnEF19IS9nNxQzD0ws=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2959197b68eso195615ad.1
        for <linux-mm@kvack.org>; Tue, 04 Nov 2025 07:29:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762270170; x=1762874970; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8GNMbexAGe1nKqMzzLVClEkNd7j6DVDRkgcdOMp8ajQ=;
        b=QIegYlWJgqJ7uw35mokqW9LCjkwFEFZZAGM279zOs4n2ckXZjQGwM1NdUMmJ4y+rkQ
         CjYQMdRZj903O3pobn8VKMUNrJqkaj1ZwpsBYQW+BUCh6Gq4SEKOqQmpvisROVKJT0+Q
         0RzuTLyKHFqoS3eC/K/Oq93MdGXFwYzOGAgp6BzfsmvKWp18DSslSUShqSfd+Xe8lFOm
         DRPZ2wWuMGvN+b8VZNNYopTsqHZBgz88dtW9fLC/r8klrkJKYvTaGO5EXWOX3i/gUV+k
         ok+J8iG8qErt+dN39rDe4Yk1Jidt9TP6/lQXrqSxPHuG6AfN/0hCrNIf8w+7HuXdwi5y
         WXQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762270170; x=1762874970;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8GNMbexAGe1nKqMzzLVClEkNd7j6DVDRkgcdOMp8ajQ=;
        b=izc3RUo2zCPbk3ZIEqSj1Ds8IfqpdljMS/fQoIRsi94yHqU0uhPTz8/8dD6wzN2mQ3
         mRRYYSxTuP7nqEl+rSWENtSHg1OZBJy2v8rz/vJOfV6XngXYj+PEVNN54pvDB0bSCOYA
         ulMqRx04vOdroK88rGtMqpjQUpnvtlVs5CWyZjeSIeZQm+EryRiasW86XdTePwW7t9R4
         XFf775nt8SZrQr9J2rZnxJEY7Tm5S1XgT6gV5uvVHm2ayFgPEK5Mydi8wJZlLzzLBR6V
         p4AUmNtiY3u0tE8X2GN/OZqOAb35yA4HCIX9UL6+W9P9PoERhPzoJqavIngwPq+XT6zz
         UM4A==
X-Forwarded-Encrypted: i=1; AJvYcCWNf4tRLXO8bND/A+uKLyx9bgrdllM8Pjczi2RPjEQnZtULj9t9sosVtZ6RFHTOzmmcKnFhaluVhw==@kvack.org
X-Gm-Message-State: AOJu0YzbBTeIhvrjSPrir0DZj4wxfKcdaFJ6cq2jB6YiqzkRaCo8I156
	6B4eQZaWhefHhnOdQGyEg5yStJeU3J0hQj64Bf+zaZIVaan+ODWi+0cx2x1/x1oFdOKb9jKPhHj
	zO72KAGPNBHKxtXu+zDxnsYDlj39aUsMLPa7gGDM3QpBjyXF3KGH+nFn9tLI=
X-Gm-Gg: ASbGnctPt2DqiOYfh8loeVM03MxC6x9LSPCk3K7RXfbB6jJr1Z/1rhQ8VD05cZR5MHI
	CtYF87yffYIDCBgSJozrCXbBnUIeYDvs7AcG1xq/KC79yycdhZ9Rx0xOCx1/wi0KLGp6wDpO8Xe
	5j9+JekOrAWH2F+cVZWNUJ3ylyLqWYb2iLxYaF/bFkBM17wlxI3UqvZZ/3cq/Yq54qRxfs3WRIy
	qUWNsIdiWdPJMnRarB8sgn0UblkXB3oXWx0Vc16/xUYdStSTb7G9CIzdXJoWAyRK+S4FWgA/lRp
	HVzEXPmf4YCmpr0DBQ==
X-Google-Smtp-Source: AGHT+IH4UAJnle8ScuJWqynVoBOWdaJhxSn6rAs6bqvidoqyAcb3/mjW+zeWXvxPSrbgnMnIJK48J8HHgBswCtIjjHM=
X-Received: by 2002:a17:902:c412:b0:294:d42c:ca0f with SMTP id
 d9443c01a7336-295fd276d54mr4970305ad.2.1762270169379; Tue, 04 Nov 2025
 07:29:29 -0800 (PST)
MIME-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com> <5a4dfc265a46959953e6c24730d22584972b1179.1760731772.git.ackerleytng@google.com>
 <aQnGJ5agTohMijj8@yzhao56-desk.sh.intel.com>
In-Reply-To: <aQnGJ5agTohMijj8@yzhao56-desk.sh.intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Tue, 4 Nov 2025 07:29:14 -0800
X-Gm-Features: AWmQ_bl_ayCFfhnMsugNyyrAbP6HSGsNUxGOugUtPG7U3zm3zMrinB0nHoIiMMY
Message-ID: <CAGtprH9cajbGWrU9PAZWNKMeKJ9DyhoV=nEYk_DnYnR8Fyapww@mail.gmail.com>
Subject: Re: [RFC PATCH v1 11/37] KVM: guest_memfd: Add support for KVM_SET_MEMORY_ATTRIBUTES
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Ackerley Tng <ackerleytng@google.com>, cgroups@vger.kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, x86@kernel.org, 
	akpm@linux-foundation.org, binbin.wu@linux.intel.com, bp@alien8.de, 
	brauner@kernel.org, chao.p.peng@intel.com, chenhuacai@kernel.org, 
	corbet@lwn.net, dave.hansen@intel.com, dave.hansen@linux.intel.com, 
	david@redhat.com, dmatlack@google.com, erdemaktas@google.com, 
	fan.du@intel.com, fvdl@google.com, haibo1.xu@intel.com, hannes@cmpxchg.org, 
	hch@infradead.org, hpa@zytor.com, hughd@google.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, jack@suse.cz, james.morse@arm.com, 
	jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, jhubbard@nvidia.com, 
	jroedel@suse.de, jthoughton@google.com, jun.miao@intel.com, 
	kai.huang@intel.com, keirf@google.com, kent.overstreet@linux.dev, 
	liam.merwick@oracle.com, maciej.wieczor-retman@intel.com, 
	mail@maciej.szmigiero.name, maobibo@loongson.cn, 
	mathieu.desnoyers@efficios.com, maz@kernel.org, mhiramat@kernel.org, 
	mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, mingo@redhat.com, 
	mlevitsk@redhat.com, mpe@ellerman.id.au, muchun.song@linux.dev, 
	nikunj@amd.com, nsaenz@amazon.es, oliver.upton@linux.dev, palmer@dabbelt.com, 
	pankaj.gupta@amd.com, paul.walmsley@sifive.com, pbonzini@redhat.com, 
	peterx@redhat.com, pgonda@google.com, prsampat@amd.com, pvorel@suse.cz, 
	qperret@google.com, richard.weiyang@gmail.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, rostedt@goodmis.org, roypat@amazon.co.uk, 
	rppt@kernel.org, seanjc@google.com, shakeel.butt@linux.dev, shuah@kernel.org, 
	steven.price@arm.com, steven.sistare@oracle.com, suzuki.poulose@arm.com, 
	tabba@google.com, tglx@linutronix.de, thomas.lendacky@amd.com, vbabka@suse.cz, 
	viro@zeniv.linux.org.uk, vkuznets@redhat.com, wei.w.wang@intel.com, 
	will@kernel.org, willy@infradead.org, wyihan@google.com, xiaoyao.li@intel.com, 
	yilun.xu@intel.com, yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2665CC000F
X-Stat-Signature: 4itjc5rn7313gyua1ssumhiidhy3n3bx
X-Rspam-User: 
X-HE-Tag: 1762270170-276550
X-HE-Meta: U2FsdGVkX19nNiSd8Ryg12y4p5+QBkGjtPzSNlRfBRPk/APFY7cLX9RzDAnN/tYssIztsjFwu6L6sDNrJ0u3TAg+H63S9FaumeX2malX9dhT5hejS+rdgZwwXhHFUNeZ5X9EeZb/FzierSiZ2qysT22dy7YvM5uNqi6yjO8wmf3ahijtT8HjYjzk0/XvWsRoUd4dpeImS5yUrv4Mh9154y2FU8GFEmKcJxAzs0q1lhn9RRvSClhfGEhPpOAeqlCIvOEgmZKx7/F29BUZnRYRymvMhaj9lmrVEa8makSSRfevX0yEAyn4LgSfVxF2Qg/ycqUVqpmrt6vM6iDJcnp57am/5Hfz2bSKeBF/pa+wkhKYApM3/z/yE+QOPpKfmi5lAaIgsiJf5hJ5YM/EudsCIQe7yCWHEt9QFP9dSAdGKCyyV3yHytw/L5gLByczoBBQt0WkauW/n94TR5oq/wN5/4P/XGu5DhQCQrpx9AqW2Y6Cb1B0Ak3CwkjdnDLhb9cjnkd1SK7Xq3531wvt6J339z5qC/4diXyW8rMhJUZ28bwbmtxj98ZQN1Qb9+5bdolpEM9g2Qqjjzvjb1D8jaW7J6BWBOvqvmKMDO3d/stFGNoimmqdZvj1iCTwYtGbaTh1OY9WJsYHdAI5D/cfmhGsog5hrQhSG4gy8TXG2vBMWYraNzgMwEI868Men98HFKODXsiKD57+GJdvyJAr2gmBsfpcugfcG9d56G110+1aMaLvoj3rQOh3C6qChoVlgUwB4tk1JCwPZjuy9IEb/ITv8H/am+U5zR9b5oxR6bN7r3uItr9PwOLjxvcw7W5R0CbzIf0hzMAD6B20r7Hbn8ePklQk7teBgJ0ll6nEyKvfmEvp7wVxM6vsZnuLOWsUIdrQxI1UFV6obd764bEuqnYbONu/TnoNQKn3soShv1K4fJRVbs/fnPlUfMm2EMEVo+etMlD6BT7V1TJ4162X7Wf
 gSked9nJ
 qrxEOTBkunVLCnKncrOWC7Wu0NBrt7MrT/t3J3DCZYYds27HYJM4W7OjvEJr+VqAGRnCognwWT3G4Wq+e3oM8v3jnJf0oZN7Hd4X0CIVwCRrmTuohikkGeFu4h3bl77zurZznccz1odi83gTJHc9WNkw790S9O6FfhSun2dduTV/kKqm9Bu4m6YuTVTdJKlEr+gtT9nZq2cQW4aDjHL5d3+5OuaEsQcBtFbmR4eQS8RHu2RCZKUlLlMQu6DVjH2iPhcNPrYWwpX+4F82Q7Z4fMfw8G5IoceQAxeFKuH5yHBW8syKDT4GPaB/Ao7KEUJ6gXnhUnWesoU9jEQVlRVmdYNdhxA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 4, 2025 at 1:27=E2=80=AFAM Yan Zhao <yan.y.zhao@intel.com> wrot=
e:
>
> On Fri, Oct 17, 2025 at 01:11:52PM -0700, Ackerley Tng wrote:
> > For shared to private conversions, if refcounts on any of the folios
> > within the range are elevated, fail the conversion with -EAGAIN.
> >
> > At the point of shared to private conversion, all folios in range are
> > also unmapped. The filemap_invalidate_lock() is held, so no faulting
> > can occur. Hence, from that point on, only transient refcounts can be
> > taken on the folios associated with that guest_memfd.
> >
> > Hence, it is safe to do the conversion from shared to private.
> >
> > After conversion is complete, refcounts may become elevated, but that
> > is fine since users of transient refcounts don't actually access
> > memory.
> >
> > For private to shared conversions, there are no refcount checks. any
> > transient refcounts are expected to drop their refcounts soon. The
> > conversion process will spin waiting for these transient refcounts to
> > go away.
> Where's the code to spin?

When dealing with 4k pages, I think we don't need to spin waiting for
transient refcounts to drop, that logic will be needed when dealing
with huge folios in order to restructure them while handling
conversion. So the specific part can be safely dropped from the commit
message.

