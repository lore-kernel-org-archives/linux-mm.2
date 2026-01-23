Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 494FFD778AF
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 19:12:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9A216B0545; Fri, 23 Jan 2026 14:12:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A47256B0546; Fri, 23 Jan 2026 14:12:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 953006B0547; Fri, 23 Jan 2026 14:12:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 800566B0545
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 14:12:29 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 43563D18E8
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 19:12:29 +0000 (UTC)
X-FDA: 84364174818.05.8086676
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6302C16000E
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 19:12:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Y2hMq5Z0;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.43 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769195547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iAb3V8FwAoFt+i7QIjKEQtHflVF/O2of2sgUimojvUA=;
	b=ZLVBx2iJEUvv2yeaGu9rsuqqlxlbkaV6N4zXE9y7hOSbzSgiMxTwt5RG1ore6SMboRR7G7
	hMqsICQDZ1aRsNdKXKEkePD53XLkbeZXSemWOfP30acVpfBdcnIBQabiBnm/4zohvBZBFe
	X3y3W4gVJypo/qTV6GNdq5Q4KLjMmwE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Y2hMq5Z0;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.43 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769195547; a=rsa-sha256;
	cv=none;
	b=GNJmsPoEksJtX5qqbwc/KzFvXT7xNqMFxxl4FYrEREQJu26DKsj4xBly5OP5GVMV5174hO
	rOf+8chxqwSRfoAuSvEKRLPvxL0WIpUgbTIc7RX6Com1e1O4m71lfuUEs18v/aAGMmj9RU
	Xm6P5CuWN+I39mktS1h3R084cFcvw0w=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-894724bc5cbso39467316d6.1
        for <linux-mm@kvack.org>; Fri, 23 Jan 2026 11:12:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1769195546; x=1769800346; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iAb3V8FwAoFt+i7QIjKEQtHflVF/O2of2sgUimojvUA=;
        b=Y2hMq5Z0c4CXKoTZQC2xWsIv+EsPmTKQIhAhEGw4Ka8S9qbFiUrb+i3mmnzg8/Ze4C
         8JE1LcHSqOYmTP3qS4yPRMNA18aKh95XqzVLwjuhgrYSpPWlikJqEEYPN9AVTJIoZHXE
         h8oBL9Saoc+pC13n5WmknqC9BQDKz8jxSze+cH+LG3ZhABnFKTsABk14mEIbkezE4yYh
         am6Jd9zW0Ac9aUx8BeKp7nrkAXbMMxykI7JY5gzctK0bVa3pM04Q3tyT3lzA9PXna6ax
         cNys+MO08zqHnYt/0zbc26eepWQDIxPVn97CkX2kPnFsYZr1+uXNNMv3KJARxRmMUtNz
         kOvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769195546; x=1769800346;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iAb3V8FwAoFt+i7QIjKEQtHflVF/O2of2sgUimojvUA=;
        b=v6HuBaXjsUWGfYUe5jfMpnoh4BuChWKujulxmWWtVcJ+hWFOnp3HBtL3APiC/BY92/
         s7MgMOmVDdo9oORTtmnSd90P83hr6LsLyXvFiY7BfnDY8oIbX9lOvxYPUUqh9W1SzSJC
         f2hcDqHfSugzGyAw1UbM8LKlDXMPIgLvZB36LJ0GKJPp6zwuv4A/q1frvXWt5tLFy/NE
         VKSt2YCOxEXXTHcaN+JSmHCjgnBIioSBfGH3nZO3XWzlsAIrsnvYJ4bD5wsodrYSWi1q
         p80KkMQXrOM5FrXnIOlCKnXYenY+zRYNnDpkbl32Nf/b6VZQ8lFQrnDqeUwskHyB+nfl
         qv7g==
X-Forwarded-Encrypted: i=1; AJvYcCXiId1FBfiCLTPTI7Gccz7MDq2brWsL9kgOmYy3FRAwt87VrFt0WHkzZupsNrFnCP8bwd+Z7vy/5A==@kvack.org
X-Gm-Message-State: AOJu0YwGhHJrjLDkFn1SYD5mQrdEjI/GUGcVPq5OboVkhTJG9/n6jK7f
	mCcPqdsgk0cN2XB7GiSwmWaiEqbBiU1gwJkKhcusM9uEdBV5ns4lZrsJTCnaVDLVF8M=
X-Gm-Gg: AZuq6aKAbF5bAoeZ0h6vBAzVV6LNo/0eRw0AS+7lg0Av5K8UcCyll6Lb1i1AfVJuP+n
	dmUtr7avsXIn35SF+TXvuYN2ja8setYCZI62A9PgBxiLPK057TvYe5+FU6MOalgk8reQFDC+pSC
	k6Aj77i54SCaPfevs+O+6JshJHvshN8Ct2oh0Tip8VgDvDbqiacZWj3+fiFsf00C7uVwd3XVSca
	ClS/pvFVhvrp8KrHBmdUEsE8WMpdSIRfL026ryUYvextXgmRTe3bNPgA9IS4RYtkqajTSUdUZne
	RyFvQEG1g0tXTZyZR0csHjg+ffCtstdoK5rztYxYo9OAw51mv7a8cKvcUsr5LalZafLZ4Z7ncdF
	11jZt1y6Bro/1BLI43fte7svf53TEPuc9OGer6uYgZyVAKPjFbxF9n+Rvmc8e7OR9/Hsi9HQqYQ
	eNVyhG07VrNIA7A9Dqd1MAzCu0FHCBZwdE4zx0TpdNU7/nSUEUsWMhdNo5cL0qIDMY5kwSRPNct
	CQwOHfz
X-Received: by 2002:a05:6214:3008:b0:88a:2ac8:9b3 with SMTP id 6a1803df08f44-8947df771admr103884956d6.9.1769195546348;
        Fri, 23 Jan 2026 11:12:26 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89491823cf0sm23001816d6.8.2026.01.23.11.12.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jan 2026 11:12:25 -0800 (PST)
Date: Fri, 23 Jan 2026 14:12:24 -0500
From: Gregory Price <gourry@gourry.net>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>, linux-mm@kvack.org,
	linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
	kernel-team@meta.com, dan.j.williams@intel.com,
	vishal.l.verma@intel.com, dave.jiang@intel.com, mst@redhat.com,
	jasowang@redhat.com, xuanzhuo@linux.alibaba.com,
	eperezma@redhat.com, osalvador@suse.de, akpm@linux-foundation.org
Subject: Re: [PATCH 3/8] mm/memory_hotplug: add APIs for explicit online type
 control
Message-ID: <aXPIGMVAvVEBgFhJ@gourry-fedora-PF4VCD3F>
References: <20260114085201.3222597-1-gourry@gourry.net>
 <20260114085201.3222597-4-gourry@gourry.net>
 <b3d435d2-643f-4dad-9928-bc7fb5080181@kernel.org>
 <aWfR86RIKEvyZsh6@gourry-fedora-PF4VCD3F>
 <4520e7b0-8218-404d-8ede-e62d95c50825@kernel.org>
 <aXLCAtwMkSMH3DNj@gourry-fedora-PF4VCD3F>
 <20260123182526.00005ee8@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123182526.00005ee8@huawei.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 6302C16000E
X-Rspamd-Server: rspam07
X-Stat-Signature: 9oftid519rhjkijbohu9kxik6ytst4cz
X-HE-Tag: 1769195547-174358
X-HE-Meta: U2FsdGVkX19hgLGJWG+zT5Jdzj6J3zmdXelFgbnF43vOf9XQadCPl4RPrVQ+SPkCuqjiLmQU2SlViWkU0sHdCltnVMewEYU3Jhfhvtpqii4aob6qMSwBDr8W6v+L1hSb8bdz5uKCGMGkrOCsKRlyGMbAGhDWr4GALPbXDhskcbCweRuc2ZAD2iT7VcMFiefKNu5CHbwVBsrpPDPuzLEM9zKO8gSu2ejbaouUyqVHNU6jL+tTtk6sWnnYP4mwV7X7HQiZDa6OCPqXECd4nrmrqGerbF1dAzAWAVm92oAosIabWNllT0k92OHe2G0C1OH2RVSXRUNB3+U2MZexEfM2/8Ij3WHTHO1lJNVVlCsaQC/cw/KnJ/kztIFVPksMz9ORV5OQ3yASHpkaTh01IIiGD41uPGF3f1itjV/do2PXftUgRGKsXrtcS6WnFdbgU9GqmhynyP9BZZhmEH1feNAlE+loZUxMIZtzMWlMJvVaTrLeZxOlDzmIH9oFock1DVsjTib/kqL5uy0oE6MLkMbVe4hpLYk5+05iNIpYC+Lzo6yXRMgzC8j8u7ZfZgoifZ+m9sAWCfkjVucHGPB/p4R/6YYfJsmjqsFZ83bRpFrUuNW3icAOazXZGfvnnw87e1uCYznlxsaWjzJ8PFp1nlHdzB1Up49TJS+l6Pr9mz2kSKk9f7FgdOd2zDExQRIBjB8p0f+MaTGfLgY5k8c+J6/4oHOHBUdxOBN6gtmLEciXxzPo7TB3m23sGDXk4oRg6apmeMrzFj8NPGk5MH9PpNlosYfNXGv1sydxg9d+aVB6rgBDFdbPDX1pEpmt9ML4KdUSA+gBlFoZGM41M4rTlTaLK325wdUupDDhex1hgAvPzhixqSYHEJiIGUB7Q1Um9G2FDkJdU8pzynpDzq3E+r/bYSIuDhGzk03bVNAZvrfBsKSTsWToXlZcr9MX+0bxLq6J+7crMevNMz5H7evZOKK
 RUt1EDwo
 SGQZEO0ZVl5IwCQWiVwemAkXLZQPUiZDzvdxd6O8mcjeVSiV5qz0YsNE6DUrolVNlWzhsRJ8e0asyXVAwd68ZKFtrkxoZTuMKwpc3NI2/ef2dk9DsaHu99IXDfIUZyV8d5OYcBb59/ABtJnJQzHU1cItEG57jzEIuO2AmV76Yqvsl5FVcxGo8renOvhCsh0PQrkK+YKli4tXx29c59J6T41m+LmZDXJff0Tjxj8Lac79FYuB6NsnupBtfHKsDIOASgbx3JIW9MuYS3judEizerUHt/ZvDi6v874ID30DeoaopP3BOQBaMyqoUMiJBC4UUEQ6RqqaUujmGB3DDS4h9Qt+LTbd8xp+upTYLsjUm8GUJ084eV2I7BP+uE2YYRdeTPAnUOSpfjhoqbb54neGbXsdfZ5mucDJX7nSkDn78nKxXqUzovZefwG/Vxw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 06:25:26PM +0000, Jonathan Cameron wrote:
> On Thu, 22 Jan 2026 19:34:10 -0500
> Gregory Price <gourry@gourry.net> wrote:
> 
> > On Thu, Jan 22, 2026 at 11:41:24PM +0100, David Hildenbrand (Red Hat) wrote:
> > > 
> > > Right, but I don't want any other OOT kernel module to be able to make use
> > > of add_memory_driver_managed() to do arbitrary things, because we don't know
> > > if it's really user space setting the policy for that memory then.
> > >   
> > 
> > Ah, this was lost on me.
> > 
> > > So either restrict add_memory_driver_managed() to kmem+virtio_mem
> > > completely, or add another variant that will be kmem-only (or however that
> > > dax/cxl module is called).  
> > 
> > unclear to me how to restrict a function to specific drivers, but i can
> > add add_and_online_memory_driver_managed() trivially so no big issue.
> 
> Is EXPORT_SYMBOL_GPL_FOR_MODULE() enough?
> 

Is the issue just that add_memory_driver_manage is `extern`?  If so
yeah, i can just do the EXPORT_*_GPL path.

If you prefer FOR_MODULE, then yes I can do this.

~Gregory

