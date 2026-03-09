Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4ECAFEA855C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 05:31:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F7496B0088; Mon,  9 Mar 2026 01:31:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A53C6B0089; Mon,  9 Mar 2026 01:31:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B1496B008A; Mon,  9 Mar 2026 01:31:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EB3696B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 01:31:55 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9B3BB140D2E
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 05:31:55 +0000 (UTC)
X-FDA: 84525402990.17.7FA1320
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id EB261140005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 05:31:53 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0OXSgQya;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773034314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iGlvh0iG8om9ac8C832XTdhmJ76uZG1b0g3VYPlePWk=;
	b=WPmuSBaeSbbEScqRQV0BYsZ/bTEV/5tNcVIc9nKfUG304nw6kPUy08Wtj6F+Pt2YSeXL9Z
	2iUy5oNnmBWNYfTZcnv8eXr8No2ihCdCNCnepsF16BtYQP144kld4DQFwiPouZnsm+tJ7u
	BQk8Zs4abA+vpWeGXkbwLp0Rjvlk17k=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0OXSgQya;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773034314; a=rsa-sha256;
	cv=none;
	b=sz4e2O+V7V+6rbGoo9WnQ16tvCF3Isjg0DYe4z9/SiEpRqvn5t6PQItgRrpJRpyRLLTCQp
	oxBydQ1TiwEb7QzjskaLWRMSucEF4octTktfJWe1Ya3pvchyplSq8K0nCggyZ5pUxHiEdK
	uZFA5vjeLtyiQ+eNTCT/8Rh0QjC5318=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 233ED600AE;
	Mon,  9 Mar 2026 05:31:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE9DBC4CEF7;
	Mon,  9 Mar 2026 05:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773034312;
	bh=4vfn24XF5vYM4uKJiPcBNrbK2n+o8o1NwxX6wesI5rI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=0OXSgQyaGKM4/OkMYYNOBGc1jOpQf8k6tBPMlq5b+13lMtXthcgJ/r+gE0DCCY78j
	 BlfPwEhZUvz2DdcsurS3snoWjRBKlD05ghbVxD6YZO19bitVgaTRh6xsYauJbdGTBq
	 7RoJRoO6WFEqvwezzNXMtcXSYC67tTHmeZngWErc=
Date: Sun, 8 Mar 2026 22:31:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Anthony Yznaga <anthony.yznaga@oracle.com>,
 <oe-kbuild-all@lists.linux.dev>, David Hildenbrand <david@kernel.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [akpm-mm:mm-new 286/330] include/dup.h:354:25: error: stray
 '\302' in program
Message-Id: <20260308223152.7c99aaa3c73f819b7844fa07@linux-foundation.org>
In-Reply-To: <aa4QKbYOvGmDEqVG@rli9-mobl>
References: <aa4QKbYOvGmDEqVG@rli9-mobl>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EB261140005
X-Stat-Signature: cf7jhcadfop18ed97i5seueas4ety9hh
X-Rspam-User: 
X-HE-Tag: 1773034313-967960
X-HE-Meta: U2FsdGVkX19q3eSlJGl65B8HiPGKe4UZcgM6H6dNwBE0/ALr2SPRzsihr9I495d1+K/FHYPiobV8oJiVn9OfefRuBwFKVapRjvZ90d2EBDTLG7Yx0lO+MBrGJ7q2wNAyBiJzShlQZKLkr1LAHDGPTMZS1/BJ28EPPeeHRB0FtYaiKClkhlJm/Cb8qyuPxoSxq+O33LlAZvIUCjkGmn9FPn/U9yKJ6A/itzcmhONaH+RU8le4GJ6M7AsViZmO8JjkQzXv8mrh0KxBONnAkl4ZN+LehcY9DnIkIkUr7z4HG8HRcwLy44jmbxFH2Hgsb9b7X1veG3pG2lmfr9wrz7Spf1uJRlUQ3Gtw7Qfx29daqAnVOe9Yg27O2M9lvykQ50TOFsYO6oTqVEMkmJwIlPmI+6OsJ7Z5/aTNK0eBft5qVPpeQwGYTdXevGCMADpxhfZ6J3m0A0AO16MDz62dHwMLYa9/DJtXdomVPOyCw8yNl8fvIGl3FChpOxcFZmDKsPvL0VzvBzNM7ar6pfXewV/UXkZ1poq7sjAe92vHInoJfz4TaDa1ull8ndUVo2Fvt5vzyjhE6FI4UK4alZO8YYx+BewXbgIvEZUl8g4GSxjxtWNjE3L4uqLF89XY9r4NxZJ3Lb0DMNuyi+EI1LuS2ew3gQE6/MMVQHk8/HHrCWEe7oSXjWXuJ4b238NzULpH0dSvmojjeC5symlyGH7g11yoq5M+aqA3FRmN7C6AArOLVu35eiPHq1C9dpR/sxZNuDhIpAIQxYyYVedENMhW8l+c9Y3987lSmg6ZnEIYd6cDrrcVkCZ/pancBHP2c5TXGmmKiXy2CxQPbHREZzYpn7XDnBqPZT3ogCZm3IkyDncbe/8B/4tSW/8wmLnpK/5DGhvOml+CtCmY65RWGcA+iTVm7n5c5PWf92op1MTyEnrWN3EzK8L0k+A0fJGxEOkk53F9xNvjEWTI6SKMFtsAma5
 o7rtKcB5
 R9zKfQOXmYdg8GMIK7sQF9CFi4bz3bsR11smJvFfZEh7kH2Ucj5Q7/NngcdD1O0sf/bhPXJbf83sEclokAuulpKy4ydFnMOANF/Mu4kEJJJj9l31aKoHycyO4HsbyJTJGApa2Z4cPM/fRKHXcy8ipjFVu3Bw1lX8gvdVubCbMQ5x3QO4G9pS5uoqtuBxRgrI2BV2MsIqR0p2lIerIfOXAfLOzIi/AGZmIncOLlubdTT/pkNYC4fBxuZcYeg07AzJ45gBGTXTHp1GWdZQEYlTLLrSwQncKsM5VQDpehAgvoIHyxNpBDQOHvnyQHyrvRLMiYHqlKx0dtuAYtnQledRsvmbRPOZ4SB4EtVQM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 9 Mar 2026 08:11:21 +0800 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> head:   167400fd4c51f9e5ea8fc9d33c89c938799be4be
> commit: 84cd8de2b92a1ccf493c43da8b31bb983d320ca7 [286/330] mm-prevent-dro=
ppable-mappings-from-being-locked-fix
> config: x86_64-allnoconfig-bpf (https://download.01.org/0day-ci/archive/2=
0260309/202603090023.npem8cfw-lkp@intel.com/config)
> compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
> reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archi=
ve/20260309/202603090023.npem8cfw-lkp@intel.com/reproduce)
>=20
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/r/202603090023.npem8cfw-lkp@intel.com/
>=20
> All error/warnings (new ones prefixed by >>):
>=20
>    In file included from vma_internal.h:55,
>                     from shared.h:11,
>                     from main.c:3:
> >> include/dup.h:354:9: warning: ISO C99 requires whitespace after the ma=
cro name
>      354 | #define VM_NO_MLOCK_MASK=A0 =A0 =A0 =A0(VM_SPECIAL | VM_DROPPA=
BLE)
>          |         ^~~~~~~~~~~~~~~~

bah, OK, my attempt to turn the incoming email into something usable
didn't work out,  Let me attempt to repair that.

Anthony, text/plain changelogged, signed-off patches are very much
preferred, thanks.


