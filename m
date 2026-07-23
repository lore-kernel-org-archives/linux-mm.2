Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4305C531CC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 22:31:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C40576B0088; Thu, 23 Jul 2026 18:31:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF14C6B0092; Thu, 23 Jul 2026 18:31:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B07C56B0095; Thu, 23 Jul 2026 18:31:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 82DF46B0088
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 18:31:08 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0C6571A0217
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 22:31:08 +0000 (UTC)
X-FDA: 85021488216.13.D9A75D8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1EB18140007
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 22:31:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="WoRvO/pI";
	spf=pass (imf26.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784845866;
	b=KRl2y25F9QCyJsaMxg3nMM00JHzVtTiHY5ONTDmuW0TxXlHTICaGzILNHfpjbG+klGEpoL
	EUZakI1jl4buSq+0tMJ6pE27YiGxaB3ZUawSRdGmVsTVho8/rGUguOEhME8U5l1xiIpKmi
	jmLNMi9YZ2dBAgQOjEZABD5W3GpKWKY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="WoRvO/pI";
	spf=pass (imf26.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784845866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h0Mec8/GVZl0xwfSlHmKj3QfvJBgOauId4QfnpHUiNk=;
	b=ZTEUTgl5/LlefO69ru2rUgdIeat/zOs7zg6RGvmaqjTF67SWeo7tT5dqTJ4jhTIDr0Oug1
	f2m7cB7lL5lFkx9bLjtQZW0PeBWT2JMTmcPvdekGeZa15+jVWsQa+mXW50illuRdZNJsxq
	8ZSe15eI9OLTvbc0PotFmFT7qxlAvd0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4B25E439B4
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 22:31:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA031F00A3E
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 22:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784845865;
	bh=h0Mec8/GVZl0xwfSlHmKj3QfvJBgOauId4QfnpHUiNk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=WoRvO/pIvftSP33s+TjIIK04RdirgQFNq3UYfkf05nGwxfuvlyvXGFzGBTT3dDYXm
	 xhMxqiq3uOrm0hELZh9KYbPnGQ8rzENcOYxeeu4tMXQ5rv/Z/PSov7pTZuhGQLIhPE
	 C08ncXdySev81r79Jpp7bOb3+dctXz3QoYaVAOfVh9PV4/2W6kw2cHSirzFZc651CX
	 qge/AJaICSuvHowudt/1jGbw0hm+8m8/y6iwB5wDAVDDE1J8Lrc8Rms4FZc7r1eM+M
	 aWp5Atcy8dYT3RNLu0ig16431HIfzVu/AEYDeHgA1BEo5QmAhXrAR4kQhxH83F/3Ay
	 IaBwuN+EaKcOw==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c197e7e4e94so213556066b.2
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 15:31:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rqxm7vT0xI/RX0HK82vKv1XmygslEy7Old/KWoAECEOlxG7FHJ1mQ/6EFlmnRZHgquJAutbD/DbyQ==@kvack.org
X-Gm-Message-State: AOJu0YywfsP6Jw3tJ8fUmI3oAcCE//qzyIBbR23aVW7Qsqp+zysqo039
	ANpujh9jNnXL/kH8/UtaoZDuijydrdCyxdZjtQtIsEMk7lteRzCVObrszjicTPcHy0hSepeyjbu
	Yf72P87bzeY7WasPFiDKQwZSbbb//6aY=
X-Received: by 2002:a17:907:608f:b0:c19:5db0:edd3 with SMTP id
 a640c23a62f3a-c1c50cf9265mr187233666b.58.1784845864122; Thu, 23 Jul 2026
 15:31:04 -0700 (PDT)
MIME-Version: 1.0
References: <20260629163337.1264881-1-hannes@cmpxchg.org> <amGpEEqxoLq/Y7ZO@yzhao56-desk.sh.intel.com>
 <amIcXrS7nGX-adpG@google.com> <amIrDncrL4K-JRBO@cmpxchg.org>
 <amIxyy4Vg_TTE8Y4@gourry-fedora-PF4VCD3F> <amJKOPczNMb96NJv@cmpxchg.org>
 <amJQAs3Bm99ZR_sF@gourry-fedora-PF4VCD3F> <amJgdSXxFk24e94p@gourry-fedora-PF4VCD3F>
In-Reply-To: <amJgdSXxFk24e94p@gourry-fedora-PF4VCD3F>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 23 Jul 2026 15:30:52 -0700
X-Gmail-Original-Message-ID: <CAO9r8zN2mPsFiRTPYOPTq3gTVZwsj5hODke4asTTY-jXpSioxA@mail.gmail.com>
X-Gm-Features: AUfX_my37iO8kg43fRJAMFzRp5ru5qgHtGIQ_-ffgL4wvv2TG3Cin2cd_aD6SYo
Message-ID: <CAO9r8zN2mPsFiRTPYOPTq3gTVZwsj5hODke4asTTY-jXpSioxA@mail.gmail.com>
Subject: Re: [PATCH] mm: mempolicy: fix automatic numa balancing for shmem
To: Gregory Price <gourry@gourry.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Sean Christopherson <seanjc@google.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, pbonzini@redhat.com, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Neha Gholkar <nehagholkar@gmail.com>, kvm@vger.kernel.org, 
	rick.p.edgecombe@intel.com, vishal.l.verma@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1EB18140007
X-Stat-Signature: io9jipizwaajac5smz77qdzpe5tmcb3c
X-Rspam-User: 
X-HE-Tag: 1784845865-63668
X-HE-Meta: U2FsdGVkX19kwUkiz8JeVu5sGJaAzP31SwPvayHP/UXcCSeelmxkxPiOacQWzRMDzf8FK6DmsBHTHt4OTa3nyKFCsXojT9EqqSqALxI0jnjG31FFbivWo4x1gSLRREVBl6/zTC+GOEXe9NRMBi8075dbBKLJC+NDSBelgKwCj3o/qz1uVl41W53oJDZwVlHG59awUPd52GX6eEWH+2wBLjRm+4aBKNc+XAncTHFKGzSGScuDBmfhOn9xthcUd7dznK2hYes0VtDjUiuk/GfDlUrwuys5fVzAzqZSVSOLVHnG9IvWNZOnCaLLaXFhyssGywuRoAwKCtAhPIzZhQLDLXAnBSCbHJiurM7FjmZnoxp0CsPIhVs9Hl1rG6GBgGBOpRdRvKNTgfoEwlpISvtD7Z8LoEsgdfH8oUSiQ6sQ9Z4/3qDIvACwCAEYcQR7PLOayGOP3WmEx7UV7m68cCwcsj5PH5vRSwkXsG9xrM/VWcSRld+ShiLJlJwbQdGyaWr6LgJCH895Y/6ST5fY563Yzfm2PlXdcCFWtC3V3PVn+9BVX9m0kthztIwaHzmFpuwNTrPbafT0bma7vU9/wCDz/O77QjXiVQJvU1tQVCYpk7jBU54rrA22VVIigVfwrkXNawS95hD1yIKYDJb/uDosepFYzFZHhARXwgrKw+t7RbhXjcEe5NhjHfvK4QWUUUhnsjFz9jnQC23kyiiCH9Bap3taqD/t+TfLG/dobRd4i5fnMw4hMtUiWRTljS2dSjPsqF6H36Ie9THcAXKjwMd5Yp+TAImsq32haFy2rCS+NMC4mHgtm7GkXTC4toj3L8Sk8LVEHrMqX22RqJec0f+ibmxjDnvjljJQtdfUocGw8dukL2OqHY39VxDH1tuqumegJA6NetJ9nHqOchyW1+kQ/3Pg+QtbhPSYoEaQscOdFCUoocG/kvDEgAaFkjov++6jQMBGc0r+UUr9aG2HGXj
 bw0pVuaO
 Ih1izQD0EjNXMIB2+RrkrhlSmd+wW4P7i0iCf7kSnMPEZlDxOLaMzXLYtMJCUGGV4oN/ZQft6I68t8aa/rIoSE3+3LGYyEyZuywctethRv58ofsiOBZDP8dHPR6sxgVNYhYF0anTL8S7hnBbGAnVaQl4X+gHDJpYuHBeAiYGnsqHMse9sCKhNRLcjdBMzRevqF3kHfJIVpQ06oTfOvt4hB+rLZpj2hElfMWNzqv5WoXtWgSSTUXb8JC3Eq8fOcDBO5s2Iv4+OF5m9FH+ESWw7hkYKyz6ecv8eIpRRMHLHUCdS6ZTEkdos78Aaoq2IXiMhOxOv1Hu2Nlq4Nv0yrfKJou7I+Myq7aFrXS1UFpzLbF/WhDx55iKGGQEd/F8vQ0KkDF92zW00iknXg9VosBByPH7eB9+X0WLdCZ6h
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 11:45=E2=80=AFAM Gregory Price <gourry@gourry.net> =
wrote:
>
> On Thu, Jul 23, 2026 at 01:48:27PM -0400, Gregory Price wrote:
> > On Thu, Jul 23, 2026 at 01:07:04PM -0400, Johannes Weiner wrote:
> >
> > So the default global mempolicy is effectively:
> >
> >     (MPOL_PREFERRED | (MPOL_F_MOF | MPOL_F_MORON)
> >
> > which is just MPOL_F_NUMA_BALANCING without MPOL_F_NUMA_BALANCING.
> >
> > The user can't actually see that - because the MOF/MORON flags get
> > stripped out when it's queried (because they're internal only).
> >
> > Maybe we should just set MPOL_F_NUMA_BALANCING in the default/preferred
> > policies and document that the global preferred policy default-enables
> > MPOL_F_NUMA_BALANCING - and that if a user (KVM) doesn't want to be
> > affected by numa balancing it needs to set a policy to disable it.
> >
>
> Walking this all back:
>
>   - MPOL_DEFAULT is the default policy
>   - numa_balancing=3Don means enable NUMA_BALANCING on the defaul policy
>   - shmem was broken and did not respect this
>
> Johannes' fix is correct, and there are no additional changes required.
>
> Users enabling numa balancing while running KVM with shared regions are
> not getting what they're asking for presently - that is a bug.
>
> They should get the performance hit they're asking for (and then either
> turn off numa balancing or set an explicit mempolicy for those tasks /
> memfd's).

Does it make sense to add a pr_warn() or pr_info() to help users
figure this out when they see a regression?

