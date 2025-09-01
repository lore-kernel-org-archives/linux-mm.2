Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE90BCA1002
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 13:35:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07DE98E001E; Mon,  1 Sep 2025 09:35:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02E988E000C; Mon,  1 Sep 2025 09:35:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E11658E001E; Mon,  1 Sep 2025 09:35:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CD5338E000C
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:35:34 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6FADC16086C
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:35:34 +0000 (UTC)
X-FDA: 83840778588.03.FE376F6
Received: from flow-b2-smtp.messagingengine.com (flow-b2-smtp.messagingengine.com [202.12.124.137])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5EAF6180012
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:35:32 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm3 header.b=qOIcHpD4;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="T rZ7WmY";
	spf=pass (imf06.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.137 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756733732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AnVy+GFpTqM3XIwnfxspH9w/hhNpLd3QoIWawv7MRX0=;
	b=H5ZxoEjRp6Fqb9+sYEWYPqBDVumhxxeIxrVViH+9LgG+vwyz+KL9mL9KRR7O6XruONkQKG
	XF81rWrLPmn99QUefg9qYNKRKPWedYTRcA2pxWEMcbs1sAPyiVGUJdMG6GMJt19fPPaYJh
	meiR5unCuLHwBMUmKQVChiflDFjF1xM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm3 header.b=qOIcHpD4;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="T rZ7WmY";
	spf=pass (imf06.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.137 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756733732; a=rsa-sha256;
	cv=none;
	b=iH7rfWlv24MUKUmc/OOyEjjD3BmaVLkTLEPQjWJcVeiatGItRsv8EXYkfTzJvLCdq3pss9
	uE340I9XxcMQDUQCRlQRirLQCDtepcxjA7uF97FTgYtVT0T6a6CuVl+NPnge6GlcGlLjZu
	CXhbCsxppq2UMOWs8NOEOCr1SWRQmzU=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.stl.internal (Postfix) with ESMTP id 72DA61300C7D;
	Mon,  1 Sep 2025 09:35:30 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-05.internal (MEProxy); Mon, 01 Sep 2025 09:35:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1756733730;
	 x=1756740930; bh=AnVy+GFpTqM3XIwnfxspH9w/hhNpLd3QoIWawv7MRX0=; b=
	qOIcHpD4d/ZwPxo1YAsCo06kvto8t7fcl/eyXQIg6cyMQZbfFLNJfqA2efdp4Xsl
	SIxwT8NGSQEC1RYPKlI0w/9nHoTAjYhQnSNteytsGnnBue+kcc/ExwpMSrzbmjfu
	+oboS1XJQ4PeLkgo/1t43q1StwLR6V2MDXQTVGUDUXS1g42rUqUbMAM5+WH8VnSH
	kaWZ18CwqCxP7TO5BT4ZAGk7Pn1Z/8/XDfGh4tAITg3Z8HdEgvBouVWrHd0xoAiO
	qv4oRiSq3Mhf0KE3i7RjlwcZNN7oiL5/3iv0waT1HbgOZ3HCFVNC+vRq22I7Wz7v
	QiBDfGjrNaidFxuWoPXK+g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1756733730; x=
	1756740930; bh=AnVy+GFpTqM3XIwnfxspH9w/hhNpLd3QoIWawv7MRX0=; b=T
	rZ7WmYWNKyTbBY0kpjsY07s3bpDNclAvZsAXI08SlFwVW+Ue69i4oCFAyqUpoKm1
	CcQIQxv7Hmp4aVz7nEpjk5GdPWcO1haigrmDuMzTGRMruHZiN4qTX5WBBR4KJm4v
	JJY6GqEOxeOtjDk/rKAh5vtg/2MK/YVpyOLcJNiv/dDj8BBkVSeVfTw7bG3uAS+N
	1QuVYU4DQW5tNXY+Kq5F9HRYmIFo8Dlw5ydb2ovHcxqPGgzlBclh0D3/UtBOQfYF
	MzrQ9r9iIoMLPbV2gpH4YsjASp8H3D4jOs6RAJSARnhDv+kSET/nwrfgFY9tzqLE
	oFX2UPss9JLXwxUKU76TA==
X-ME-Sender: <xms:IKG1aDr3Hqrb31TbMjN78ZTLVNY4RM96ZCFBcQVyAuY4LgHcbrnlEQ>
    <xme:IKG1aNp7u77IIkCCX9bjV4qZW5wWqe7OkAxvJPCwwbE91dmYpG4mpCOLTMXsp-Jm3
    nn8tlWvYObQvbyKOTk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdduledvvdelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrnhgu
    uceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvg
    hrnhephfdthfdvtdefhedukeetgefggffhjeeggeetfefggfevudegudevledvkefhvdei
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnh
    gusegrrhhnuggsrdguvgdpnhgspghrtghpthhtohephedtpdhmohguvgepshhmthhpohhu
    thdprhgtphhtthhopehvghhuphhtrgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepfi
    hilhhlsehkvghrnhgvlhdrohhrghdprhgtphhtthhopeigkeeisehkvghrnhgvlhdrohhr
    ghdprhgtphhtthhopehlihhnuhigqdhmmheskhhvrggtkhdrohhrghdprhgtphhtthhope
    gurghlihgrsheslhhisggtrdhorhhgpdhrtghpthhtoheprhhitghhrghrugdrhhgvnhgu
    vghrshhonheslhhinhgrrhhordhorhhgpdhrtghpthhtohepvhhinhgtvghnthdrghhuih
    htthhotheslhhinhgrrhhordhorhhgpdhrtghpthhtoheprghnnhgrqdhmrghrihgrsehl
    ihhnuhhtrhhonhhigidruggvpdhrtghpthhtohepthhglhigsehlihhnuhhtrhhonhhigi
    druggv
X-ME-Proxy: <xmx:IKG1aLMz2TINr0c9twI8YvaS3Bl-TSQE5dUZWyhg-L_0znn_f0dfPQ>
    <xmx:IKG1aE38YbHUEz7fNiAfpCQE3WrOAZZWG3HU_NyUya0Hi5uZ6Hpw_g>
    <xmx:IKG1aKom2NHpTpyZT_0AwJSkDC2sC6eK75faHFKKsNdr-FTPcJGMHA>
    <xmx:IKG1aEs7wsdixga8FnPAoUQDIFaRRBPGSqTVbhgfbhKfgrnZLF3VgQ>
    <xmx:IqG1aPF5JqcLstqMCk-eCuy-NBIHh4w5lGboHTQV22jCAUfuu3AJWcNC>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 33FF5700065; Mon,  1 Sep 2025 09:35:28 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AWRA786TDMiJ
Date: Mon, 01 Sep 2025 15:35:06 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "schuster.simon@siemens-energy.com" <schuster.simon@siemens-energy.com>,
 "Dinh Nguyen" <dinguyen@kernel.org>,
 "Christian Brauner" <brauner@kernel.org>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "David Hildenbrand" <david@redhat.com>,
 "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 "Vlastimil Babka" <vbabka@suse.cz>, "Mike Rapoport" <rppt@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Ingo Molnar" <mingo@redhat.com>,
 "Peter Zijlstra" <peterz@infradead.org>,
 "Juri Lelli" <juri.lelli@redhat.com>,
 "Vincent Guittot" <vincent.guittot@linaro.org>,
 "Dietmar Eggemann" <dietmar.eggemann@arm.com>,
 "Steven Rostedt" <rostedt@goodmis.org>,
 "Benjamin Segall" <bsegall@google.com>, "Mel Gorman" <mgorman@suse.de>,
 "Valentin Schneider" <vschneid@redhat.com>,
 "Kees Cook" <kees@kernel.org>,
 "Paul Walmsley" <paul.walmsley@sifive.com>,
 "Palmer Dabbelt" <palmer@dabbelt.com>,
 "Albert Ou" <aou@eecs.berkeley.edu>, "Alexandre Ghiti" <alex@ghiti.fr>,
 guoren <guoren@kernel.org>, "Oleg Nesterov" <oleg@redhat.com>,
 "Jens Axboe" <axboe@kernel.dk>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>, "Jan Kara" <jack@suse.cz>,
 "Tejun Heo" <tj@kernel.org>, "Johannes Weiner" <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 "Paul Moore" <paul@paul-moore.com>, "Serge Hallyn" <sergeh@kernel.org>,
 "James Morris" <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>,
 "Anna-Maria Gleixner" <anna-maria@linutronix.de>,
 "Frederic Weisbecker" <frederic@kernel.org>,
 "Thomas Gleixner" <tglx@linutronix.de>,
 "Masami Hiramatsu" <mhiramat@kernel.org>,
 "David S . Miller" <davem@davemloft.net>,
 "Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>,
 "Paolo Abeni" <pabeni@redhat.com>, "Simon Horman" <horms@kernel.org>,
 "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>,
 "Arnaldo Carvalho de Melo" <acme@kernel.org>,
 "Namhyung Kim" <namhyung@kernel.org>,
 "Mark Rutland" <mark.rutland@arm.com>,
 "Alexander Shishkin" <alexander.shishkin@linux.intel.com>,
 "Jiri Olsa" <jolsa@kernel.org>, "Ian Rogers" <irogers@google.com>,
 "Adrian Hunter" <adrian.hunter@intel.com>,
 "John Johansen" <john.johansen@canonical.com>,
 "Stephen Smalley" <stephen.smalley.work@gmail.com>,
 "Ondrej Mosnacek" <omosnace@redhat.com>,
 "Kentaro Takeda" <takedakn@nttdata.co.jp>,
 "Tetsuo Handa" <penguin-kernel@i-love.sakura.ne.jp>,
 "Richard Henderson" <richard.henderson@linaro.org>,
 "Matt Turner" <mattst88@gmail.com>, "Vineet Gupta" <vgupta@kernel.org>,
 "Russell King" <linux@armlinux.org.uk>,
 "Catalin Marinas" <catalin.marinas@arm.com>,
 "Will Deacon" <will@kernel.org>, "Brian Cain" <bcain@kernel.org>,
 "Huacai Chen" <chenhuacai@kernel.org>, "WANG Xuerui" <kernel@xen0n.name>,
 "Geert Uytterhoeven" <geert@linux-m68k.org>,
 "Michal Simek" <monstr@monstr.eu>,
 "Thomas Bogendoerfer" <tsbogend@alpha.franken.de>,
 "Jonas Bonn" <jonas@southpole.se>,
 "Stefan Kristiansson" <stefan.kristiansson@saunalahti.fi>,
 "Stafford Horne" <shorne@gmail.com>,
 "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Helge Deller" <deller@gmx.de>,
 "Madhavan Srinivasan" <maddy@linux.ibm.com>,
 "Michael Ellerman" <mpe@ellerman.id.au>,
 "Nicholas Piggin" <npiggin@gmail.com>,
 "Christophe Leroy" <christophe.leroy@csgroup.eu>,
 "Heiko Carstens" <hca@linux.ibm.com>,
 "Vasily Gorbik" <gor@linux.ibm.com>,
 "Alexander Gordeev" <agordeev@linux.ibm.com>,
 "Christian Borntraeger" <borntraeger@linux.ibm.com>,
 "Sven Schnelle" <svens@linux.ibm.com>,
 "Yoshinori Sato" <ysato@users.sourceforge.jp>,
 "Rich Felker" <dalias@libc.org>,
 "John Paul Adrian Glaubitz" <glaubitz@physik.fu-berlin.de>,
 "Andreas Larsson" <andreas@gaisler.com>,
 "Richard Weinberger" <richard@nod.at>,
 "Anton Ivanov" <anton.ivanov@cambridgegreys.com>,
 "Johannes Berg" <johannes@sipsolutions.net>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, "Chris Zankel" <chris@zankel.net>,
 "Max Filippov" <jcmvbkbc@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org,
 "linux-csky@vger.kernel.org" <linux-csky@vger.kernel.org>,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 cgroups@vger.kernel.org, linux-security-module@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
 linux-perf-users@vger.kernel.org, apparmor@lists.ubuntu.com,
 selinux@vger.kernel.org, linux-alpha@vger.kernel.org,
 linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-hexagon@vger.kernel.org, loongarch@lists.linux.dev,
 linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org,
 "linux-openrisc@vger.kernel.org" <linux-openrisc@vger.kernel.org>,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
 sparclinux@vger.kernel.org, linux-um@lists.infradead.org
Message-Id: <ebe9be04-274b-4791-b883-198320cab886@app.fastmail.com>
In-Reply-To: 
 <20250901-nios2-implement-clone3-v2-2-53fcf5577d57@siemens-energy.com>
References: 
 <20250901-nios2-implement-clone3-v2-0-53fcf5577d57@siemens-energy.com>
 <20250901-nios2-implement-clone3-v2-2-53fcf5577d57@siemens-energy.com>
Subject: Re: [PATCH v2 2/4] copy_process: pass clone_flags as u64 across calltree
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Stat-Signature: nxjrpzbq538x1aoio5dut9gi76y1xpk6
X-Rspam-User: 
X-Rspamd-Queue-Id: 5EAF6180012
X-Rspamd-Server: rspam05
X-HE-Tag: 1756733732-544681
X-HE-Meta: U2FsdGVkX191MpDVT4r1axvRULi/PU9J+7lL91s3tiaJE4c/wFD1jffIPuut0T2EBzDka1ZvZQnMtoe0B50cDKyyiGIJ00zVOcokD1VPjGy34ugR/LlPBLxCNpzLoXN4ose01IKwIuv7HX6F7GcKsisj/qo/9rXqwEwR2gmekrhvtp+clL4Y05WaiXuRuqKBVXtSMTTycYEWwU645uR3cXIKyvnrJwe2QbGSyJCYxw8CG3k+S86Af64089LHZeYtVJgkBZZgEfoRcF39Mu4tWtBe6/Ap/HlibBbJO+IvEkGINmIPU8mZYha1IElpu34CzjPG1wnRvKM2loQYHsKGW111uA+3H/S6Hon39w8zjcJ40qszYLyB0SPEDc9PKJsCfJHOKIUBLhrzF+lbx5ObOOJGycNwuD/nXNXgNeu83hnVcHvdEZR34ixLEqOXCkdK033kg2q7GN2vF+B8PF+lYFg8oXlqwjqRwfkupwGWTXjBrvL7mY+iPWAvXYrHkOo1nyceXCpIdQiqhNu0nmiheRKUuMd2yjuHqv+2iYh9gZROefa7Mtn7MPq0xKWSO0RlsbJH5JatkkfhVJP4LtAQpoFab1fAAI8u0Auy0bs2EXm7XH3yrAyrsdSjBetiqfZTj8ka2+l2jlQB1XnbMhO1CWhFv0lck3xaEJ8JD0Gkt5LyyFqFNSuRRrqYMC8jHRHotmIWAE8KNhASsiZLqc8mWxA5M4pr9bYmwyFqB+uqtusz5PeoyF8iOEIf7rSUhym4SFeeXacPTffmCwqxsrC4RJ+1zG7MJPmJ+DCw6mKImImP58pQcPc5D91swNQG6gUKDfmZBct4awf7TKd4qwTmdJHASxEJOhv3Rd0fDtemWbPPa1kt50JRaQq7sadRUsCqNleg6LS/hv9QvE2iNNbXDVQuqhLEw5WwKLnMpbdY/3Si8q5Q2DiXESly0XLNfRp8/QLrDdhcjxvvK5gLWHH
 rgbB8Wli
 PpuqNk5BGrYzEtg2jh1wFoqFFkY34JfiATMGhIYSs70ZJLyBEmTYHcUvM/ANQJtQY2xTrdmQYbmj7/ntt7er9Md+SIM8//07ULcVtWlIbXhQJ6sMEYPWNorLAM0SOx0y1FKg1HPtA7Qf5TxgKLBQlTIHwsgG/ABDoeZlP3/3bUosnN4WG/I/Tbb4ECo5q2lPuUffuMOk9hfJlqccjF6pCXts0isn5DTj7iYPjJd+UvzKM5sG3/uPiUSUxwAi8h8LeqRTVj+y0kmhfEnX5MYGug8yiRcM9QiFML2efOAZd6NHV3okovyndDqTvlKPV52yhekWq4eRe27gIRHSfO1cBPwilb6INbDcAb6Eo8BXFmuIxkwPcO19aXjgHFlHggdLsHz+egdT+lUtR9TBpCZtyHlm4Ff/fwRRtzuhMLf3DvXk1R1w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 1, 2025, at 15:09, Simon Schuster via B4 Relay wrote:
> From: Simon Schuster <schuster.simon@siemens-energy.com>
>
> With the introduction of clone3 in commit 7f192e3cd316 ("fork: add
> clone3") the effective bit width of clone_flags on all architectures was
> increased from 32-bit to 64-bit, with a new type of u64 for the flags.
> However, for most consumers of clone_flags the interface was not
> changed from the previous type of unsigned long.
>
> While this works fine as long as none of the new 64-bit flag bits
> (CLONE_CLEAR_SIGHAND and CLONE_INTO_CGROUP) are evaluated, this is still
> undesirable in terms of the principle of least surprise.
>
> Thus, this commit fixes all relevant interfaces of callees to
> sys_clone3/copy_process (excluding the architecture-specific
> copy_thread) to consistently pass clone_flags as u64, so that
> no truncation to 32-bit integers occurs on 32-bit architectures.
>
> Signed-off-by: Simon Schuster <schuster.simon@siemens-energy.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

