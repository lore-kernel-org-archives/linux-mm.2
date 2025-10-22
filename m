Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50D94CCD1BE
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 20:39:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACED48E000A; Wed, 22 Oct 2025 16:39:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7FE18E0002; Wed, 22 Oct 2025 16:39:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 995778E000A; Wed, 22 Oct 2025 16:39:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 87D878E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 16:39:37 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 31CC81A0962
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 20:39:37 +0000 (UTC)
X-FDA: 84026915994.21.2981DD5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 95A9A40005
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 20:39:35 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=UpJbNPMN;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761165575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IOPw1yGL9RQTl6OuteawxraihBHhJd0oKwJftRfIPAw=;
	b=mqmJsns+G+FmmF3RLcEVyOb3O1RDhq28qlwKfzZ1TfNJor0J6FpKQM2BEtfgt6nVnkIzRD
	9Rls3r+FMXCPvRNoNazB+rtdUOZYnR0ifygLoF+McupBfAwe60Lz9PxnbxF9hi7O3Xtg2Y
	2r/fI4oOTBqhafVIFS/+6v/jEOXtou0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761165575; a=rsa-sha256;
	cv=none;
	b=ZQURgnNc/i9/wtSR3j5y0LNbDORpxtWlRNyChWKug34JBGlh+C+sruhJennIQmiFvKJObU
	mI1mQVSxdvhuOKcWqpLrVJxIrCWPQmm0IQacDPR60EypMHv2zBYrL0khB6ImYAUwm2ot8L
	6NzCMdsv90BWALIpDCixg8C7WTOvKLo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=UpJbNPMN;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 02DD563DFE;
	Wed, 22 Oct 2025 20:39:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877CEC4CEE7;
	Wed, 22 Oct 2025 20:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761165574;
	bh=Mv96Ed+x0MGsCybuHkpz+hgXUvhyD19vRt09uvNP3kE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=UpJbNPMNCZxnQgBXufWkrUDNWXaRkU2uoX4SsZyzBaIruBWzGMHftF6ISsvsJSlaY
	 tQOMu7i3QJDXR0tYconjL8RMNZP/aXpj4p6xIKob1pGpGM/OU8o21ClRsHQAfx4pJo
	 6Ai80zzqEZ3McBKxRvniDh2jBFGV7SHpN1Xfd7a8=
Date: Wed, 22 Oct 2025 13:39:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Remus <jremus@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 bpf@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org, Steven Rostedt
 <rostedt@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, Masami
 Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@kernel.org>, Arnaldo
 Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>, Andrii Nakryiko <andrii@kernel.org>,
 Indu Bhagat <indu.bhagat@oracle.com>, "Jose E. Marchesi" <jemarch@gnu.org>,
 Beau Belgrave <beaub@linux.microsoft.com>, Linus Torvalds
 <torvalds@linux-foundation.org>, Florian Weimer <fweimer@redhat.com>, Kees
 Cook <kees@kernel.org>, "Carlos O'Donell" <codonell@redhat.com>, Sam James
 <sam@gentoo.org>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, David Hildenbrand <david@redhat.com>,
 "H. Peter Anvin" <hpa@zytor.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, Heiko
 Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH v11 00/15] unwind_deferred: Implement sframe handling
Message-Id: <20251022133932.5e8b419d3525da07453b137d@linux-foundation.org>
In-Reply-To: <20251022144326.4082059-1-jremus@linux.ibm.com>
References: <20251022144326.4082059-1-jremus@linux.ibm.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 95A9A40005
X-Rspamd-Server: rspam02
X-Stat-Signature: nq6ioa3iedh8kcho9d9trcnoqemw3qzb
X-HE-Tag: 1761165575-235566
X-HE-Meta: U2FsdGVkX1/+h6VzNY4aE8vwhZvHB7fFeuxFGCW/lQ+iMqMBE2Q9RH/xcJ5TigXONiJIvHbRw6mnU9uj7X4eyiiqANnHMnUWRBMMxg97CopelT50cBo1kkMEH2xqBh8TvbszHDE6RvTUNDMwd9vL8ZWOb7KQkNGNUurbTM68ymj91YAOmAo7ab5T+ACxn/eSlmCqSyIU7DydNUXoLpRXGti7kTNzXVFOLk6dCBzwB9Y+UVSOGdpZYfunZVBHaHx8m+8+srwmd+1PaPoOgngLYpNi2U9SAbiJ0tO4Ix+VA0PSu9I4Q+vluYmZ0nyJaIpnCKLOZ7A11pErj/KBbY4Ffy1xP/Jr+GM8li1JkcOWf0FGbbNu1Bl6fiD26GECkBjpwidgx+7L5IKa1q30nDCC+hU4WMoF9UBrNyhy2A2rURY3xGiTTH9nvmcPlBluJxz+CloWRYfmU5G9clhhlPNOfZktPMBUXbyrehoOhPBwblvgz0K2CZBNpy5i8smxlWhFlfZw5j4hWunzq3TCrIVTAuA9DTmFSK/+0BK8TqUfwigWfgWziZa0VsQyJjn4MlVV2Kff87P+yyRVYWwAYu9eUlRKIDipnrORnqNPsWqMf9krY2pSOiDFrmQhbRSzwH7BXSGHD4Delaj9GKEL8EFAWWOZ1Kn4cn5Oe6re6srvKHO/4GwsyXrnRhahtv+sEd5scetnkc6lA+SG4WiVUPGDAeLW5UYDM40KdpEA7Mh5ArPXBRCu5VnpFeqnhLNYMwQpqQRL3ZulPGWM55xCxXjuePWnaD2qatFE1iPFLzIWIbsuF/HotY23GR33+ha6TPp6cxq5CnFAZODbzeCB2AvsnBYoXGRj5WYP248W4NG+WA7HgLxELZxj6K2dYRh9LJ03xClYX9ftNLttzn9RxebGRVYBGgEqMS4KuTSzILdho3IuIa+eawrTs5JplKfHzQfEf0Oh2ksbYTd4XmvH44J
 Cn6ttUmp
 cIVnwUuZdgttcbfb4JwYRkZ0buEqKs6DDsoE4LBm8DHGlejfZcPQpIMCP1QN7eAvA29FcKHitBBjhLdtEyMTtOi3Qw/pVmr3LtMMd8glDFt+7wehz6jQj56JkLJ4hk2QJvvVPocvPn8jAfY5k/rwdObk85X+dcDw7KvSdpV/8CUksVWEaslNIeCARYJiNNhaGcklEJBqBm4hORitF3PmgzRvq0cuNa5z5CVn379pJZp4bvTZIvkqkpBQlJvX5dClqQ5k2p/jGhqsPC03qIWSguUQRnQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 22 Oct 2025 16:43:11 +0200 Jens Remus <jremus@linux.ibm.com> wrote:

> This is the implementation of parsing the SFrame section in an ELF file.

Presently x86_64-only, it seems.  Can we expect to see this implemented
for other architectures?

Would a selftest for this be appropriate?  To give testers some way of
exercising the code and make to life better for people who are enabling
this on other architectures.

In what tree do you anticipate this project being carried?



