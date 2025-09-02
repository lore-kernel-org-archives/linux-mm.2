Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3485DCA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 07:16:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E83B6B0023; Tue,  2 Sep 2025 03:16:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69E848E0003; Tue,  2 Sep 2025 03:16:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 587818E0001; Tue,  2 Sep 2025 03:16:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 45B306B0023
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 03:16:08 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CAF0486509
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 07:16:07 +0000 (UTC)
X-FDA: 83843451174.13.78FF58C
Received: from outpost1.zedat.fu-berlin.de (outpost1.zedat.fu-berlin.de [130.133.4.66])
	by imf03.hostedemail.com (Postfix) with ESMTP id 892DA20015
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 07:16:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=fu-berlin.de header.s=fub01 header.b=pP7TODQU;
	dmarc=pass (policy=none) header.from=fu-berlin.de;
	spf=pass (imf03.hostedemail.com: domain of glaubitz@zedat.fu-berlin.de designates 130.133.4.66 as permitted sender) smtp.mailfrom=glaubitz@zedat.fu-berlin.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756797366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=75QsosR73EP7Bhx5dXwnnBiSrQlTSAdKIHehZonw/2s=;
	b=Z4PgKjk7WwDa030d1cXnsdp77jfBzpRXM1jTPs+qDVWwsUlHkOOX2IMRdkdYUcjKNOVzU9
	LtWHoGntA8LHLJe2JRmj+sQZL2GCZ/XvAeZ5icuCE/YPL0B9OZtmOZkP1R1kZz2mbKx/c+
	vTWMb5VJr8Qf0GUnUgqINhvkgGZBxUw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=fu-berlin.de header.s=fub01 header.b=pP7TODQU;
	dmarc=pass (policy=none) header.from=fu-berlin.de;
	spf=pass (imf03.hostedemail.com: domain of glaubitz@zedat.fu-berlin.de designates 130.133.4.66 as permitted sender) smtp.mailfrom=glaubitz@zedat.fu-berlin.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756797366; a=rsa-sha256;
	cv=none;
	b=2aGsSU78ujFs+2tH3YAokjUHSd4zN4ciC+jAWYhdnTfcvrJ68rVXFvWgWZdXTuNzuxk/Wu
	D+Ruk1gXqTSxWw+aX3SHYwC/5DlsurVJ52EbDg3XM4edLPU5r/wU6nrHnrJOmZqvHsQf8n
	i1H1wIJiCYYSTHNfd4JzBR2IdLROcUQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=fu-berlin.de; s=fub01; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:From:
	Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To:
	References; bh=75QsosR73EP7Bhx5dXwnnBiSrQlTSAdKIHehZonw/2s=; t=1756797365;
	x=1757402165; b=pP7TODQUs3ySqH09QonUQJREd/07argNEvU4W73xNsnPNwc1CvYTIy75Kzs3e
	6ECGlyadaIrRbEaV5C+CwR8tMf4gB9c4/bc0h6E65mns9ERu19AtM2fbThJmbN2MHODL/YgVjaFzN
	bgFmKNEBFfaW0I6N2NkNA0JS/rc8cUdGBNaPjyMsnTcidl/8e4AAYvZzgqQ1xymcYj4V+HZ2jWc4h
	t5z2DTD//0cgSDL0k3xDK7XOv8OPGSm5Y1weWxQbxFnfpxCKg0XBLMhxWxkEIKGyZBKBUZSXk9wXb
	EFPp27iNVDA2ckq5VBQPVxNwAnp62LJGVxePc6kYxOKr5XTngQ==;
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.98)
          with esmtps (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1utLEY-00000000Jm4-13FP; Tue, 02 Sep 2025 09:15:14 +0200
Received: from p5b13aa34.dip0.t-ipconnect.de ([91.19.170.52] helo=[192.168.178.61])
          by inpost2.zedat.fu-berlin.de (Exim 4.98)
          with esmtpsa (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1utLEX-00000002jxi-2pMt; Tue, 02 Sep 2025 09:15:13 +0200
Message-ID: <11a4d0a953e3a9405177d67f287c69379a2b2f8f.camel@physik.fu-berlin.de>
Subject: Re: [PATCH v2 3/4] arch: copy_thread: pass clone_flags as u64
From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
To: Andreas Larsson <andreas@gaisler.com>,
 schuster.simon@siemens-energy.com,  Dinh Nguyen <dinguyen@kernel.org>,
 Christian Brauner <brauner@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
 Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
 <david@redhat.com>, Lorenzo Stoakes	 <lorenzo.stoakes@oracle.com>, "Liam R.
 Howlett" <Liam.Howlett@oracle.com>,  Vlastimil Babka	 <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan	 <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Ingo Molnar	 <mingo@redhat.com>, Peter
 Zijlstra <peterz@infradead.org>, Juri Lelli	 <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,  Dietmar Eggemann
 <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben
 Segall <bsegall@google.com>,  Mel Gorman <mgorman@suse.de>, Valentin
 Schneider <vschneid@redhat.com>, Kees Cook <kees@kernel.org>,  Paul
 Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>,  Alexandre Ghiti	 <alex@ghiti.fr>, Guo
 Ren <guoren@kernel.org>, Oleg Nesterov <oleg@redhat.com>,  Jens Axboe
 <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara
 <jack@suse.cz>, Tejun Heo <tj@kernel.org>, Johannes Weiner
 <hannes@cmpxchg.org>, Michal =?ISO-8859-1?Q?Koutn=FD?=	 <mkoutny@suse.com>,
 Paul Moore <paul@paul-moore.com>, Serge Hallyn	 <sergeh@kernel.org>, James
 Morris <jmorris@namei.org>, "Serge E. Hallyn"	 <serge@hallyn.com>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>, Frederic Weisbecker
 <frederic@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Masami
 Hiramatsu	 <mhiramat@kernel.org>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet	 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni	 <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Mathieu
 Desnoyers	 <mathieu.desnoyers@efficios.com>, Arnaldo Carvalho de Melo
 <acme@kernel.org>,  Namhyung Kim <namhyung@kernel.org>, Mark Rutland
 <mark.rutland@arm.com>, Alexander Shishkin	
 <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, Ian
 Rogers	 <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, John
 Johansen	 <john.johansen@canonical.com>, Stephen Smalley
 <stephen.smalley.work@gmail.com>,  Ondrej Mosnacek <omosnace@redhat.com>,
 Kentaro Takeda <takedakn@nttdata.co.jp>, Tetsuo Handa	
 <penguin-kernel@I-love.SAKURA.ne.jp>, Richard Henderson	
 <richard.henderson@linaro.org>, Matt Turner <mattst88@gmail.com>, Vineet
 Gupta	 <vgupta@kernel.org>, Russell King <linux@armlinux.org.uk>, Catalin
 Marinas	 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Brian
 Cain	 <bcain@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui	
 <kernel@xen0n.name>, Geert Uytterhoeven <geert@linux-m68k.org>, Michal
 Simek	 <monstr@monstr.eu>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Jonas Bonn	 <jonas@southpole.se>, Stefan Kristiansson
 <stefan.kristiansson@saunalahti.fi>,  Stafford Horne <shorne@gmail.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Helge
 Deller	 <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, Michael
 Ellerman	 <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy	 <christophe.leroy@csgroup.eu>, Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger	
 <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Yoshinori
 Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, Richard
 Weinberger	 <richard@nod.at>, Anton Ivanov
 <anton.ivanov@cambridgegreys.com>, Johannes Berg	
 <johannes@sipsolutions.net>, Borislav Petkov <bp@alien8.de>, Dave Hansen	
 <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin"
 <hpa@zytor.com>,  Chris Zankel <chris@zankel.net>, Max Filippov
 <jcmvbkbc@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-csky@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	cgroups@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, apparmor@lists.ubuntu.com, 
	selinux@vger.kernel.org, linux-alpha@vger.kernel.org, 
	linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-hexagon@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, 
	linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, 
	linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, 
	linux-um@lists.infradead.org
Date: Tue, 02 Sep 2025 09:15:08 +0200
In-Reply-To: <f2371539-cd4e-4d70-9576-4bb1c677104c@gaisler.com>
References: 
	<20250901-nios2-implement-clone3-v2-0-53fcf5577d57@siemens-energy.com>
	 <20250901-nios2-implement-clone3-v2-3-53fcf5577d57@siemens-energy.com>
	 <f2371539-cd4e-4d70-9576-4bb1c677104c@gaisler.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
MIME-Version: 1.0
X-Original-Sender: glaubitz@physik.fu-berlin.de
X-Originating-IP: 91.19.170.52
X-ZEDAT-Hint: PO
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 892DA20015
X-Stat-Signature: bbiokccascahn8e58fadwei575d3ot7i
X-Rspam-User: 
X-HE-Tag: 1756797365-64938
X-HE-Meta: U2FsdGVkX1+cKitKC1/1w1Rd5zQ/vdYD3Z3TsAaEOsuo2GO5RVESQJM02Tg0ZNpH1CgSj00vlbFWmo8sk40J9JCNHHbGn7dAlQLGZO4D9kcyI5I+/8brjxavpm8lw4CnQpYKxbX4+yg8EWTPyMyNAcgvCTONBjJ7RkmqXrnvL8HdIUpOHBnxEle2eeUzirIti3Za74soYmJJkdqtgThnyCin6IkSEb09Czom3aENJ4vd3zRpRN908ytbDrqOshQp/f1RBL4E6wd5IqHRmWMoK5NGB8tTFmzDfdMiPKUT+kLtJuQ9rW0v5hWqPWrdWxsrsggLPbVDtymxRrHQgeJ2VpIZbzNC2VnriwmnzSoRaSlTpZfVYlvU2h+EDfXtZMzRvsjaJ1Fg4mcKIVCnG/Z9sZhJQUmoLd1ucpAdbpn0l28rXTw8xdL8jXw+yVPasKdPVYi2u00P9BS0kzdHyqhLD8NR1SDeGW4s4B8h+fZ6/jEvngOkotv3NpYjF0Qk43LUu3XEYDuLhFvdbpcR+X48MELm3xw8KZPisWYytaXfs61aKxFZ4ic+jfNCDLJv9RCZrLQFicXZQHgNf4yQxY58sGfcsIlyvpjC7m9cCYyW/mgrcc4igTOUpRdZw10fqqS+bbw6tXFpcUEoV3PdEPyF2KRkVjemh5qVrkutDuv60no8/jUWh1dBLzkesUmJCzHfIXvFEfwhRy0Z/rPwYcGmEwzfSqifBmQMvHxcildTx+1ah4E2N2GcrWGH2sds478lPhhOT+0jJ3fuDKfoQk7Ax6gt0xqVH5ItGDn3pJXawRuGsUXuPTAvHNAftLhmSv/3UhZHVFNAxXPSJyWJoFIzrYRXRMPwjas8JscTkswUf+RrRqT0rKCtQ/rnICS3UX9Cr1Ruba/SyZDhuKp0AdMFVfpYvr/3mS3L0r1DBgp/tLLd0SS2ZdJsnz7ZyCEkdwk0wD1mBNSvvpFWEFqVMpX
 kgyBUDLM
 Hvp5SI1wjcqGATDKWPah+VoLpSgcdq/DUeEgeEGYzp5OdMzrJtqJ3yesZWU7qSzNEr90EhJQ+CCAfdNjbUc7Q0oOhc6QWRnzpcCq43If4fwN404r2xyLVxqLoOSfp6ie0lckCApUk1N9V45zRcDmAP+X+oLjYGhE6t505wsw/SNHbnYS7DtL7iRreVeKRu24FqUuBIaD1sGL/sCgUIrtm965/izGnviaEmRwU30ODIPAqFdWs1y7PENMopXcNODmICBKtfpFoyCWo9+eFsIZUx3yqnuCO74+nnGknfo6u76yKYc1pjKU5DQJ1dW9ACeACaOjlBju4FNP2AYw6TfSLlgz68Pqcq1jZgz/2Kn71xCk6Slv1kuZPw4L89jywgbj+UlK/V6r3/oBtBz9l3t/oeiU8Fdjvku1JAfw3s0jJ7TZ1b6dXlbaJPZDmRpao2znZcNYyVHrMGUB6tru+dV1znuYuljFD7lcB/6H1W3NCggSFiHfmxxh7tOLFEUhxmyCoQfgY0WIGnr0QdzTGiyQA38J/V4qMIvZETj2Gnjzlm9wvKuPCPBoLQ6WmS9wVDwkYBR8ZWc3Jsm0Kr8VJnr6V38q9sXgv0TCo0itW1506XDGFS6OI29ZxGoqyhexlXNWpWaAqbhjUQ6sCkTorELau+UiIiZaNov9yHFMhEF9cOUCg59k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andreas,

On Tue, 2025-09-02 at 09:02 +0200, Andreas Larsson wrote:
> On 2025-09-01 15:09, Simon Schuster via B4 Relay wrote:
> > From: Simon Schuster <schuster.simon@siemens-energy.com>
> >=20
> > With the introduction of clone3 in commit 7f192e3cd316 ("fork: add
> > clone3") the effective bit width of clone_flags on all architectures wa=
s
> > increased from 32-bit to 64-bit, with a new type of u64 for the flags.
> > However, for most consumers of clone_flags the interface was not
> > changed from the previous type of unsigned long.
> >=20
> > While this works fine as long as none of the new 64-bit flag bits
> > (CLONE_CLEAR_SIGHAND and CLONE_INTO_CGROUP) are evaluated, this is stil=
l
> > undesirable in terms of the principle of least surprise.
> >=20
> > Thus, this commit fixes all relevant interfaces of the copy_thread
> > function that is called from copy_process to consistently pass
> > clone_flags as u64, so that no truncation to 32-bit integers occurs on
> > 32-bit architectures.
> >=20
> > Signed-off-by: Simon Schuster <schuster.simon@siemens-energy.com>
> > ---
>=20
> Thanks for this and for the whole series! Needed foundation for a
> sparc32 clone3 implementation as well.

Can you implement clone3 for sparc64 as well?

Adrian

--=20
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer
`. `'   Physicist
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913

