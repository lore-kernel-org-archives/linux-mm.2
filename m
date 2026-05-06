Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FDA6CD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 05:48:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE4A16B008A; Wed,  6 May 2026 01:48:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D95006B0092; Wed,  6 May 2026 01:48:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAB866B0093; Wed,  6 May 2026 01:48:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BA1976B008A
	for <linux-mm@kvack.org>; Wed,  6 May 2026 01:48:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5A7B1140709
	for <linux-mm@kvack.org>; Wed,  6 May 2026 05:48:37 +0000 (UTC)
X-FDA: 84735915474.20.F39BCF0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9F665160008
	for <linux-mm@kvack.org>; Wed,  6 May 2026 05:48:35 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mfKLAXqi;
	spf=pass (imf08.hostedemail.com: domain of nathan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778046515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EK4autj4hzkSsle1Vl+cGki1JFOxPz71Ob6nOJmJ8KY=;
	b=ozKIkiQ5f832zENYo+wSGSY+PR4pSPkxvBGHx2ZlfwHZ0TRheYfxwjFW/OMJwergL8gBzY
	W9l/kXnCz6Zl+oI7om3QnYjEXC1K+DChCuisuAKm4YutLH9GmC+JvqLG8M6Hi6/VB+s4IR
	7mExE+Xm1ZtVjWqglVXhI2qYeu7xX+g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778046515; a=rsa-sha256;
	cv=none;
	b=DPlze+P2OxNBb1CaaXuDpBFu978hSqjCwsI96t3wfmK++k3+9wFr83fMcUMm6PUXL62zfZ
	JvJTkSeDk5/ttjnxr23unW7DkX3JLodOw2tSJ7cb3cggIgbWhxi29yVCpgkOYqJXEVAayQ
	wbaCHLR01/8DXcy8zKY/kFGzxEbPVII=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mfKLAXqi;
	spf=pass (imf08.hostedemail.com: domain of nathan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 89A1940597;
	Wed,  6 May 2026 05:48:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C866C2BCB8;
	Wed,  6 May 2026 05:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778046514;
	bh=szuDVviJkDzC/oxHmClbDGurn2MmrK8v6p2Bb/N4oFQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mfKLAXqiX0aUDCWn8xnZhaPoLKGt3MieK7LbgzEmMoT/P13+U1zLUaTQIrMfmBTON
	 KdFtWnfI+y8hsXnG6GnQKh3ml2hjyNpL4AFpiJTZOfwnqHN79AWWampzHGXVv1nTgG
	 ETLYvVIGClWrodDRM/aVW+tiXw5w8SiWYEAN7F5b+G6A4e2zcS7reA2Ukl+4G4GOQ/
	 Hfzh/RAse7VDn+X2wfXTC4IgGLD9f5L5BVjjwTzPSVAY3ZJByUmBK3d1ZYoLgI4/qP
	 7zoSTemsBsGefB/1PkINEgKuJO54gWQZsVDXspBZJ2dbyUKEjSPQZGfyo6EQsOXJLI
	 9jSm/fMeV8E+Q==
Date: Wed, 6 May 2026 13:48:28 +0800
From: Nathan Chancellor <nathan@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Rosen Penev <rosenp@gmail.com>, linux-mm@kvack.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:CLANG/LLVM BUILD SUPPORT:Keyword:b(?i:clang|llvm)b" <llvm@lists.linux.dev>
Subject: Re: [PATCH] mm: move phys_mem_access_prot_allowed to header
Message-ID: <20260506054828.GA8550@ax162>
References: <20260505010112.645361-1-rosenp@gmail.com>
 <0f11390f-e8bd-4f8d-aea8-59ef545b2c32@app.fastmail.com>
 <CAKxU2N92s06-L0+e=KZ7EbtU50tCpaCk2MYJD2xTFEHEsAhXUg@mail.gmail.com>
 <df3e889d-ac8c-4d11-a5fe-8ed2769953f0@app.fastmail.com>
 <CAKxU2N_moR8bs=NLUcW054a=oHB--4i+M5XKCBNF9LskYcjAhA@mail.gmail.com>
 <add152a5-09bb-4c6b-a17f-da3d817b93e9@app.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <add152a5-09bb-4c6b-a17f-da3d817b93e9@app.fastmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9F665160008
X-Stat-Signature: zydrtyimbsnu8zyqi7j6w1cwmrkgeh9t
X-Rspam-User: 
X-HE-Tag: 1778046515-978589
X-HE-Meta: U2FsdGVkX19wyskQXBuJ0VJrkju7eSH6R5PixoPdt6+GcqazB/uml3NdlzusZ05arXnmRIIzHUKUuSYQjkGmn0vjUt9buKFrAySC5bEFqQFiEcPIc6zNsJhuPt2wbauaeoDAtoeowZIpIZP5x1VXofiu7PhzHb0jzFyivsP6fG//SYyU+nPY5X4KE9UM4hGdfyeq5bwLBMfEM+y71xMBOjMgDHommbvAlB0+jbCQHqxQVebXvGTmTUXIEIrpHKGbkCLNM8FyoI5MKrfsQR+0crmjfTIkfpkuKyB4iaTVWQCZS1Fz9p03SG9ZONO52E9K1GCIn7gLkmbeCBXpiXRdZd7DuZkKlf3jdOECbNEs0EabP/f7TmMo6ZB1C/oM8/XT55a1Gjfh4qefKxadKgPuBMeXzcg3zcJonTzgsZY5zqjwJxNOGfHp2pTvkvnIkFvWq5zGvbTzMpHZ+AO77pFyybhq80uXDH3o0/xBkTh0h9BC7UiUDNaEkIo9aWVwFz5ihRtJTF4SofxpFcvnvhHfv/3V1IO83Xd6zoJsP/SrvjWKXmIrnGR79zj9RHG63okyX1Dh/zj/mNPK0cUoYPS3pY64jdymr3Lo4t7SK1mY5dyFEBilndbJA8HBLKo+cMZYSb05ZzLMoakGiIX85rpEdi9laQ5Rn4AzmKO+wZU1lYSTmkf6PR5hf9K/nmeWbpS46JeOaoDlSePMROO7ouZLYHVV4F1AxtZeJuSC1u0OpFOTq/37NXKppnd7xAjk0mO34E/ay0psfzPNsJIijwfD1TC9j10CxMSCYxUyjUO40wW11E6oz8jXyEHy4fuqkgQ1uzFNkPBEZzqlBgzWICxMJLvwE1HezZ9F3fjFLzTRYwAnYW2tIoWJK7oDel2XVpitsFdIHLppn2qLzf8lEmJGs60xAyMHLaq7orvbfCils8k/pnhiJHmV+c9aZ0IPSeu5hdnAidPpnoviuGmz8B9
 8ysFI+VZ
 J8NQpFaJheqDNnWFvIYfLfyG0bd/XEKEnPYld+7Qy+3cMyPk1NI4LygUuU6FrLbLVfRtxUcIEqksJJ/Eo1cljmDycwpOZFMZb8lNvDBb7HU36DQq0zMtJMNmCrdggoQTv3PtmM5OpGoiTbRbsh2Ryyj8VZwsK5yzebn1oom8udqcwAobFemEOQ5vlB7aQxXCZsetRtbeJ481+05iA2XiO/gd5shY1U8MiNFIE5+nzF6lNbgoj1kkBCGGsdOnrmAIkuFiswbUJWapOfA1tr6+XH6o7SmfSE+CP9EE6+/LSqqWHrxU18AZ0+dq98Vt2z438r5ijx1faq5QeP+ujeTA6+JcJuQvBK9S8aCt4YBfFSxcXAe9tFAXWIGYSiKa/sEy6y33KAwo9DQbQ8RT8eAl+y+oeE/Z1VSLdO+idMiLhlajXgaqfjkt1oJmI4pjVn7Iwof1O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 05, 2026 at 11:22:13AM +0200, Arnd Bergmann wrote:
> On Tue, May 5, 2026, at 10:54, Rosen Penev wrote:
> > On Tue, May 5, 2026 at 1:29 AM Arnd Bergmann <arnd@arndb.de> wrote:
> >>
> >> Does this happen with both ld.bfd and ld.lld? Which version of clang
> >> and lld are you using?
> > clang version 22.1.3
> > Target: x86_64-pc-linux-gnu
> > Thread model: posix
> > InstalledDir: /usr/bin
> >
> > lld the same.
> 
> Ok. I've tried to reproduce this with Nathan's llvm-22.1.3 build
> from https://mirrors.edge.kernel.org/pub/tools/llvm/, but don't
> see this problem on mips defconfig. Are you using a particular
> configuration, or do you see this on every build?

This is just the same old integrated assembler vs. recordmcount bug:

  https://github.com/ClangBuiltLinux/linux/issues/981
  https://github.com/ClangBuiltLinux/linux/issues/1830

It requires CONFIG_LD_DEAD_CODE_DATA_ELIMINATION=y with ftrace, which
MIPS allmodconfig enables. PowerPC worked around this in commit
f8b2336f15f3 ("powerpc: Avoid dead code/data elimination when using
recordmcount"). Maybe something along the same lines should be done for
MIPS.

Cheers,
Nathan

