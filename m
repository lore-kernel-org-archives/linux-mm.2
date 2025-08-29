Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F235ACA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 18:47:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47B346B008C; Fri, 29 Aug 2025 14:47:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 452736B0092; Fri, 29 Aug 2025 14:47:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 368216B0093; Fri, 29 Aug 2025 14:47:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 274566B008C
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 14:47:34 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E5AC285864
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:47:33 +0000 (UTC)
X-FDA: 83830678386.07.D1B0453
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id AFC77120003
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:47:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QDPvnxOH;
	spf=pass (imf29.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756493252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nsuUzDWsGSeMqVM+Uwc5Lxipo0/0laPGStf+Z5GqARY=;
	b=budNXUWukeivqB6RVTxVwgfBo1uB6jrPNdzP3HrFKr74xVp9Dp8lksNRxFXI7E+sSkAsGq
	wrYtuJNTDLgO19Qe5eNWfVu+/LpwhbrW+tf4D0aJb6XAcyeUZoiNhsdFhUx2YtnQyEZi2v
	EjjN7k2F6pT5Z69LJOraTZoDtAsnDwc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756493252; a=rsa-sha256;
	cv=none;
	b=Lq+m1GGXLDdWYUuKVAdMn1nNEzMrVraxxd3HC5s9BwwCwTAqsG0sztljN9i33KqhtfKLZY
	HXiF2CxMrd+TgLFVEN0tdAYdbPCctITQEHjyHV6p9xhD0rICrj1jRMWecVsJ/3TXlunMdZ
	p4+LS/fepCg0oYzH8VIhgr/bZ1qwq2Y=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QDPvnxOH;
	spf=pass (imf29.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8846B456EF
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:47:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C354C4CEF7
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756493250;
	bh=EGsrl7rz3n15ufVe4i49SD1EQ18PX9TeDC0B390PTkM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=QDPvnxOHQiaw+V/AJpBaKUWuUvF9UjbrFHSJHT0znUaYPxTkiRUk9F6oBoo9v+sK7
	 3ll/lYPhb1TAxlpZVrfrWoGILcQ3boZDh+mSRKEb/Jfj8F2lMX2xFd2tHaX0OjamrV
	 ijMlZYzFk5IZBuQkS+cKcjhMRtwjiXQiemN+iPGwuzeAxe9wo3byWcIzXNYvbackEM
	 Ifg0XrMLqzVsDhD8wXRwQivSOLhMmxGuHRmcP3HqYQqo53pYTfidmbtRqDEtlJx7Wk
	 b04sfCVlU38IhAZht/21vwPfoTmqDpdVPI2FG+3AkVnx3tShvYVkmYmH/vfoYLo48/
	 6jTbkXFLFKINg==
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-45b7cadd676so8925e9.0
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:47:30 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVfhxZOlDEE7LLsx8SMDhzEGPCSTp8NWb+caPwpc6cniK2jpRo1qLM+ahLud+moQ9Zgs3l9DOzgSA==@kvack.org
X-Gm-Message-State: AOJu0YzrtxA/Sg7nlw8fE8uY7ijk5ZLq3UFWqTwSGAwUu6Fr8cl901kR
	i5vawJ8HpHhPxn22tKObVQ7mguPArDVfSGCKXKS9B23YvT+UXYGVQLmvw6jnaVIaQusJ9JOmf2I
	Rx6Bla+qjDNw3LXjQB/OsMTsTG/Fu2B4nddh7ADly
X-Google-Smtp-Source: AGHT+IG5VqIPsa1pNgB3YpFXWfQW+7in5f1Vpw/ePfgPKB7etQPfYgqx6A7wIUSMvQ3seox/XRRqlLcg0U88oq9rT90=
X-Received: by 2002:a05:600c:4ba3:b0:45a:207a:eb7c with SMTP id
 5b1f17b1804b1-45b84a46376mr105495e9.0.1756493248442; Fri, 29 Aug 2025
 11:47:28 -0700 (PDT)
MIME-Version: 1.0
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-30-pasha.tatashin@soleen.com> <20250826162019.GD2130239@nvidia.com>
 <aLABxkpPcbxyv6m_@kernel.org>
In-Reply-To: <aLABxkpPcbxyv6m_@kernel.org>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 29 Aug 2025 11:47:17 -0700
X-Gmail-Original-Message-ID: <CAF8kJuN+CsXo2QwrMvcSkn=_WB+zqikgLK9=ydqUDj+8Osmf6Q@mail.gmail.com>
X-Gm-Features: Ac12FXylXHzcyalG6rdr2bLhlKKgB6oI5FD3MKZgay4nA6t-yrJgNr96GL2gOCI
Message-ID: <CAF8kJuN+CsXo2QwrMvcSkn=_WB+zqikgLK9=ydqUDj+8Osmf6Q@mail.gmail.com>
Subject: Re: [PATCH v3 29/30] luo: allow preserving memfd
To: Mike Rapoport <rppt@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, pratyush@kernel.org, 
	jasonmiu@google.com, graf@amazon.com, changyuanl@google.com, 
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net, 
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, 
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org, 
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr, 
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com, 
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com, 
	vincent.guittot@linaro.org, hannes@cmpxchg.org, dan.j.williams@intel.com, 
	david@redhat.com, joel.granados@kernel.org, rostedt@goodmis.org, 
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn, 
	linux@weissschuh.net, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org, 
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
	myungjoo.ham@samsung.com, yesanishhere@gmail.com, Jonathan.Cameron@huawei.com, 
	quic_zijuhu@quicinc.com, aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AFC77120003
X-Stat-Signature: 574snkp6gsxqbdxqbfw7wkwogjcqa5st
X-Rspam-User: 
X-HE-Tag: 1756493251-515464
X-HE-Meta: U2FsdGVkX19U16E6oDw43wYGqSkTm2iaBTU6vvr5ByQ6Whk3LF5t6RLa2HBHh++1vHglReQowGwheGGBmn/exUCJWjDv6jd50sue2/8FO26SW4WSx+FIONVPZSHE5VP6vyg3PTD+/3d0jGQbnqujCIIxeJG4T/7uU+ux9fnUfYQ7RCs2ubwoGcuhcxF1WWji8Tpl3cWZ8qYXMLUIwAWyUNHjSSNFsOCZLm8cdRwydcLANP+VD3I14eF1jWnnkfynbc4LmmR4bwz1yXhgK6gznPgaQMnzqJE+FNTZ8Lq7u7kAifezyyOe9bXMejGIjB/Sn0oHJ0ZK7JqAyY1xWZzgybaUcUeb/YbhBJMO0Z9NcCiyZA9APYDMKab971dnVqPFltbskAI8TBsk/S7B6osBqBOaEAwd7X6OzKXkeOAXELo2Tl0lvBnh3833wyLk/GECLCfOxIdVpYQGo7OhyhP8cxX+B1dWpIcyEyGnilXziZuc5I4qAF0zCQQiwYZsbkfk1nhs/c6SgltuDjvA9JpNgfXhVOxZ6PQatKWu5mAILsFzWH4HF02GZI3HZwNWE95kVqE7LJba8qhrsnOqRaTcqEFeLG4HPdDsSsgxFOvaEwycJZZ7Z2zPpt5728m6AcWVclZXOBYyWrEnCC41mFyxkz5b2vnl3XT6rQLeedUuBGccvBWHQ9AV7DdS0c3jJxY4Wo893OJ5OTgSizLuYkh8pWL5HYK0iljn32mtPM77BqQhDmqVw4DKbyPL9oo6Bx/9TN744x50QMsjHCN0+psmejLp3kR2MuW93DjXWYv4grc0TljUBqQLzCHDm5mDO1jIVlwO0151jkmOT0se8EwiDA6AHNQipk1m8+kIFnAB+rtk4svIa6SkgxMZpPwHpGnOP16M6RC/rYoulmo2ov3tpsDn2GXBUqY0qsppMuOid+DiywGF0mkLtRAChgngNPOaj5sJJakKpKR/Y/gFI4X
 n6XNWFIv
 zFufLpKF/ixElEe+LFp3hlCzyV1CockXf6PN9bW/eMDvfnWBcHMZM2dzjfIboWBbdr8xWCxPUoAqfb9Xtck5eRzxjK9VHopmS/YJXERmfjgy0KvjU/WRSERvoSUJup+wvRMk7YGqNWVHCXMn4QFEWrt3vMqicwAJWRsPoyaRBYZbPsPm4hCy3vPovwG31ColvoGfniBqZYN3/6/p2Dq1kZdRRN+8zV5ZzyYGziY3jgZ1oP6i9Y7xP9Yswu4ud+nwdqonA1BQkmRkUOS+6HE7LbDufNugbR7AJV9P062qz1eifvqCSUOaUSpbZoKfG1GPEFRrv3s5oMq4oILeBbbxwnsEDZFeOPLdfXsOk4eEFgsJIO/a9SJnUvZNTLg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 12:14=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wr=
ote:
>
> On Tue, Aug 26, 2025 at 01:20:19PM -0300, Jason Gunthorpe wrote:
> > On Thu, Aug 07, 2025 at 01:44:35AM +0000, Pasha Tatashin wrote:
> >
> > > +   err =3D fdt_property_placeholder(fdt, "folios", preserved_size,
> > > +                                  (void **)&preserved_folios);
> > > +   if (err) {
> > > +           pr_err("Failed to reserve folios property in FDT: %s\n",
> > > +                  fdt_strerror(err));
> > > +           err =3D -ENOMEM;
> > > +           goto err_free_fdt;
> > > +   }
> >
> > Yuk.
> >
> > This really wants some luo helper
> >
> > 'luo alloc array'
> > 'luo restore array'
> > 'luo free array'
> >
> > Which would get a linearized list of pages in the vmap to hold the
> > array and then allocate some structure to record the page list and
> > return back the u64 of the phys_addr of the top of the structure to
> > store in whatever.
> >
> > Getting fdt to allocate the array inside the fds is just not going to
> > work for anything of size.
>
> I agree that we need a side-car structure for preserving large (potential=
ly
> sparse) arrays, but I think it should be a part of KHO rather than LUO.

I agree this can be used by components outside of LUO as well. Ideally
as some helper library so every component can use it. I don't have a
strong opinion on KHO or the stand alone library. I am fine with both.

Chris

