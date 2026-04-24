Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FE43FED3F2
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 19:15:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9ABB46B0092; Fri, 24 Apr 2026 15:15:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95C7F6B0093; Fri, 24 Apr 2026 15:15:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 873816B0095; Fri, 24 Apr 2026 15:15:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 715C26B0092
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:15:46 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0E56D402DF
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:15:46 +0000 (UTC)
X-FDA: 84694403892.07.7881E91
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 36372100007
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:15:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LpX5I2Zg;
	spf=pass (imf14.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777058144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JRflc675q/1idnGLrRil/l9w6yTxsq35v5W45LMDdpw=;
	b=gwa4ncpsj8FiENbrqgUUE5FxhtCUJkRFmGBaVsDWtGxpxzXD51sY3tHZCy2dTtwyAUkih1
	FVik3Jk/kkcN8jmftHewJ3YEmZIxpWAFZEmjhHa5nU3i8wdxBuS6/dCd5c+Xlv8GIgFc/1
	xmTQP272Ck4rnZ/4Q9DZrpnq05BW8GM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LpX5I2Zg;
	spf=pass (imf14.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777058144; a=rsa-sha256;
	cv=none;
	b=uErTGeGY7/NPya9EzewvRQWUSKDTK42j51HuVJirvDxbV+PKB+qha8GBanh7gO94rW0hpq
	m4bx4jEKkJPst1S4jHqXvq8meXuO/XJgBliwuY8xALoEZ9XqvCi/9Szvzgf59VbZeNv7XD
	tYxU3kH4W3vODikGA0uH3ccZ1M/JFZE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A3DCC600CB
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:15:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51475C2BCC4
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777058143;
	bh=JRflc675q/1idnGLrRil/l9w6yTxsq35v5W45LMDdpw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=LpX5I2Zg/FeuzoeKaWINh/E3uUcwttWiEQeYZas61EYTabJE/piVzjh40m+MZg7ML
	 2egZw8E5YYYz6I/5EL6JXUw2JKP1qA/4FTgjnrLTXGz94iUvNVFyKVaBRr0SdtJnol
	 MnWfPTLfHCAQS8B4K9Lpelxx6imh1ltQJ3Uj9NTqQMUP8OPj7jgq8dp46Y399au+nk
	 eq/MdAvRgGKdRJOfusoBi7GwN5X+7HyHuJe/rsPJh43JMJ/jB2Nf4gg8sGoqsbbZDm
	 dHjlJSEXQ9Ur5ZQ4FNntPqpJD/6qGCCxZgNRccSJSEJdCEqghqIvSYdVbiyFYU+l/3
	 GkdYoGMdsn5BQ==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-bab8ae52954so542888266b.1
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:15:43 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8JPS6EjAhBl8Hd/kpyupFNQEDeCDSwfrKHVzNLUF+bo8iZWMap4hpB3k8Iv/pRmdtVjzKlep63gQ==@kvack.org
X-Gm-Message-State: AOJu0YwNP/gkwBrly3NbM/kGHzkhto+dAgV+CUqb3PiDYDjJMfofvnIC
	7F3IOhNwxw/emHifftBR/v6yl7ZTvWSVjQIByRKM5Rs3+JbHrU4lPBS8AUtBdJpT4U5soN2/wJj
	lYkecnOCDtAmvNQ7RFbqRJMu2pX1wtA8=
X-Received: by 2002:a17:907:3c90:b0:bac:7f7d:2bf8 with SMTP id
 a640c23a62f3a-bac7f7d3864mr493581666b.0.1777058142091; Fri, 24 Apr 2026
 12:15:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260424062528.71951-1-lance.yang@linux.dev> <20260424063024.ce42ee6a5546e4d9337dd007@linux-foundation.org>
 <aetw4aoABYj3keMh@plex> <20260424071533.d28ce90126f05e1c6fc1b740@linux-foundation.org>
 <80ab39c2-efb9-4a23-bd56-46d9bb4e41bb@kernel.org> <20260424073145.b990fe9b925da304508aad71@linux-foundation.org>
 <644e65dc-3d39-4137-b51f-51d953b67d50@kernel.org> <CAO9r8zN1pRfyC0Rh+UdW-Lsret=z3oveT3=gnZftX-Sr_ubyyQ@mail.gmail.com>
 <20260424190141.GA3783056@noisy.programming.kicks-ass.net> <E375C69C-557E-44EB-9B3C-618C9F7BA9D8@nvidia.com>
In-Reply-To: <E375C69C-557E-44EB-9B3C-618C9F7BA9D8@nvidia.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 24 Apr 2026 12:15:30 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOTFUSXc_iZ3i9iL3v9Fw+SOFoROj0vcO_1GwBxO9CVqA@mail.gmail.com>
X-Gm-Features: AQROBzBB23MjqT6n8PBLfDaZ-XYSD37hBuqxK30W4VBXepSt-pjFbfbtLqRUj6c
Message-ID: <CAO9r8zOTFUSXc_iZ3i9iL3v9Fw+SOFoROj0vcO_1GwBxO9CVqA@mail.gmail.com>
Subject: Re: [PATCH 7.2 v10 0/2] skip redundant sync IPIs when TLB flush sent them
To: Zi Yan <ziy@nvidia.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Lance Yang <lance.yang@linux.dev>, dave.hansen@intel.com, dave.hansen@linux.intel.com, 
	ypodemsk@redhat.com, hughd@google.com, will@kernel.org, 
	aneesh.kumar@kernel.org, npiggin@gmail.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com, arnd@arndb.de, 
	ljs@kernel.org, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	shy828301@gmail.com, riel@surriel.com, jannh@google.com, jgross@suse.com, 
	seanjc@google.com, pbonzini@redhat.com, boris.ostrovsky@oracle.com, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	ioworker0@gmail.com, roman.gushchin@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 36372100007
X-Stat-Signature: pbbyu4dopry37s45n7wamfthxenog95u
X-HE-Tag: 1777058144-103599
X-HE-Meta: U2FsdGVkX186b9jYAL4jwVl0LkrLsnvUS+QHefRVld+bi6DBrvruG/Bs5fKUqEebIRRDEWNh8o2YzuOnQkhcewqqrBXq5S3NW0s55PzIiIWhIBmB+natXhjKIGfsK6WTMppOLDJ5wWMbUSqn7SDhGkM8EW9GB7VSmjbgIix6wcTp46CaeSOf+ZgZ/Jdv97kZ4C9GQ7XzvZDSmUL6Jsc77Rua4Lj28Ewg3b/MXrH5V+rljmtrWWKS+gJxbpDrRH0+ghh5850NzZhP6huH0uAkEmTePkaAGQBrg5rH/8I3TtrwlxAYaxxrdQrTecvoziQDL8krbAvYiUMQ581oMxlW14tAK2zuhHzsmX0GIqZxHE2I1hUDW9eRwmX9C8M/34YP+bzy1nwsDl1MJjS9K1bz12P8EdJj8bphD4RzO3OvxsI9HRMLOKpG21tdFckocqGpmHVI9lPHw3VhsCvEKxhne5ohW5D062wDjzGXGJSQwCFbkSLcTLB56um43TunWXtRMluSO5lopkWkJ4Y7qrpCprnWczJy4Rj6Jzz+FZPjuVj5dBJaD6aprnLDW+v2SBEZChrclzJzHO0DPblOLs2aqHgT6kpXFuOjuMkwTsVKttqS9xouSHee0qMi5JCBkcOH9+1oOgq+V7eJML/r16hoLNo9GoqBLTNB59WiLDtUH/JqpI2/0hmfwPEB4Tp1fw+aTMmJVGB2iMSuN/G18mP3xwFhBYhj66yqldI3LGyY4EChD0pV6JbRZVvE+QpSOo5Ny4SUC+VAnG8nfQaofiaUuhoyGpFB2GxC0HLjhfzIt7wX9gzoHQV/w9GvyklzKSm468GEtssgVpj2+1yHRHpwAL8lMu3eLkRrW1J7Yc5Yw4Ei6SwcEGUXU0oVldWJskzjKd/YWzj9NVwWXEIxMnP6sgkDS3jAyM5xedShrg5wLxHTkIjxvrD0AdVlQWUKQNGuVQJA4jAbZTcIfcF50Kq
 1S51oi5R
 M6TvSzqQTTEaL1wFJYS9xYlQbupriA3EES/7zDdxmLj58hOlDDCGjLNkPuoldy3Z4x7IG6/L/r/0imdWvOkBkCRBrc+vxEdgutLCXcVkvSbJRSUpZu4Y/x0Mn+yAek4r1zoHOy+bSJqcbJUXkHahqbKfcU9/4+Q9Spbfkj8r3dfK8ViByn5TAUnWSvYx2ADv2p/BJRYXlDmZAOTkH1TobwZx8mG4EOumFwXIahT4OPeaNsiprAWDbbRKeGYuNnqk4qjOFSNb0wHxmP0ITv9cHaY7uWRvHrwZgDCzqaKXLRo5YnF61qNAaiKggDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 12:12=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>
> On 24 Apr 2026, at 15:01, Peter Zijlstra wrote:
>
> > On Fri, Apr 24, 2026 at 11:50:03AM -0700, Yosry Ahmed wrote:
> >
> >> But I imagine it's useful for reviewers to see Sashiko's feedback as
> >> well (without having to go look on the website).
> >
> > That's why I have a script; if I press 'S' in mutt on an 0/n email, sai=
d
> > script goes and does webrequest to sashiko and inserts the review
> > comments into my local maildir as properly threaded replies to the
> > series at hand.
> >
> > No looking at website needed.
>
> Do you mind sharing that script? It looks like a great work flow. Thanks.

Yeah that sounds great :)

