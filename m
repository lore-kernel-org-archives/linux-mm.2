Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7DCFCA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 13:37:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00A658E0051; Mon,  1 Sep 2025 09:36:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFCB18E000C; Mon,  1 Sep 2025 09:36:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9CFC8E0051; Mon,  1 Sep 2025 09:36:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C27CF8E000C
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:36:07 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6F74C160875
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:36:07 +0000 (UTC)
X-FDA: 83840779974.18.B31CE23
Received: from flow-b2-smtp.messagingengine.com (flow-b2-smtp.messagingengine.com [202.12.124.137])
	by imf14.hostedemail.com (Postfix) with ESMTP id A4931100009
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:36:05 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm3 header.b=iqQoAqNv;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="Y ZdEcIT";
	spf=pass (imf14.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.137 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756733765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EkyOW6EUUTV+C/dNjMz2+XFswtE2xmJVWwojlRsa6wQ=;
	b=kEgBQBPVWpo8gG1XS3fqpm0wm4IPg1dEgK0e4EEDTfmE3XNifPMY//DUi8HHmS3xcXyRIu
	iCil4obgVGmYOJktYzBalu7CROxjQndq0X0VO4ZFDyT2647asE4aBMH/D8MHwRr9XOCISZ
	ZuKkvtFnuuXpzTWrGofxS8Lv2xs237k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756733765; a=rsa-sha256;
	cv=none;
	b=KzgPviox4BLYfQXqhZWBeDMsuRJ7o8Ssl3oTJFta3iwITgtaircwT6R8SlsFBcHrzjcY65
	dKgi95Rs7XCTzsRSFqcvScabK/ePRMVc/08HDzOIVMbwIg0rNGPBpk4bv6VMRkAMBuWnGE
	a5GJJqgp/bRi0m8TTGWOD5FZqTUy83Q=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm3 header.b=iqQoAqNv;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="Y ZdEcIT";
	spf=pass (imf14.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.137 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.stl.internal (Postfix) with ESMTP id 7D2251300C7D;
	Mon,  1 Sep 2025 09:36:03 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-05.internal (MEProxy); Mon, 01 Sep 2025 09:36:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1756733763;
	 x=1756740963; bh=EkyOW6EUUTV+C/dNjMz2+XFswtE2xmJVWwojlRsa6wQ=; b=
	iqQoAqNvegrh6j4CIJgpRxtWPa4GfHGJHLJTeEiexLv/cC5adGMhR8mu9arcNl1O
	I+SViigwx5fkDtvAUK3JQvr9LUo9tSyD34ZzpwtKWl4oFpF9VVsko6G0wgKCFOrB
	Wgwk3+poGXpme23gg9tOI5NyS1XAjU0UtkVbuQdc6FHKDGjmCvobEZ9KxeWcp220
	ubS3J54j+pFRzIZl5cfhA3pOQm3sGNXHxwAVgi/uBnkXKL329bISvPyPgjUgQwA9
	8FW2trQiznoacWZhLt9i6H2QSMNg8TYnbJn1BTlhuZoxeGDnw5hk4Tdb29vm1nUY
	bZXVgQ/h5beUsffzWqRmug==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1756733763; x=
	1756740963; bh=EkyOW6EUUTV+C/dNjMz2+XFswtE2xmJVWwojlRsa6wQ=; b=Y
	ZdEcITLqgPB8jj8CHPxaiDUBffgGZ2F11HyGFeXL1aqJLq4I4uY3ERkYEVyLePpp
	o/psznaJhEHGBKJ1kQdFcm4CnwWSHMxVhZ1tegHG4+vQZnEWzWcfLawto2oOCNBm
	Q/nmgawaUaDpiYJcIgjle3tNvGPP7HrGRlkZTVjBSyx3SdL+Ubvbaw2NllbE0UKR
	5PpaPKDdUnQpnidtMabM7ViC4q/rsdCRkhJmrsQb7pfEcghJVlhRRIXKOl1ByAL6
	97jtMnFynzRNFQoG7yviaZDvoKIlFw/RFuOZzAvP0wULCLGRMZMgHnd0YvSE2EEr
	37ywaIwtBcs1nPsRIxnAw==
X-ME-Sender: <xms:QqG1aMBAb1qwptbTZfcieXRiGZJ-sUTLCT0kfm4oU2mfCmb2rLE59w>
    <xme:QqG1aOgtge6O1bXGieZrbSKSwHUnyy_Eoot2uP8L9kA1s2-ybgS8kAo4MwLH_ML4e
    xXpfwuSam7mVev1zuY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdduledvvdelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrnhgu
    uceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvg
    hrnhephfdthfdvtdefhedukeetgefggffhjeeggeetfefggfevudegudevledvkefhvdei
    necuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomheprghrnh
    gusegrrhhnuggsrdguvgdpnhgspghrtghpthhtohephedtpdhmohguvgepshhmthhpohhu
    thdprhgtphhtthhopehvghhuphhtrgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepfi
    hilhhlsehkvghrnhgvlhdrohhrghdprhgtphhtthhopeigkeeisehkvghrnhgvlhdrohhr
    ghdprhgtphhtthhopehlihhnuhigqdhmmheskhhvrggtkhdrohhrghdprhgtphhtthhope
    gurghlihgrsheslhhisggtrdhorhhgpdhrtghpthhtoheprhhitghhrghrugdrhhgvnhgu
    vghrshhonheslhhinhgrrhhordhorhhgpdhrtghpthhtohepvhhinhgtvghnthdrghhuih
    htthhotheslhhinhgrrhhordhorhhgpdhrtghpthhtoheprghnnhgrqdhmrghrihgrsehl
    ihhnuhhtrhhonhhigidruggvpdhrtghpthhtohepthhglhigsehlihhnuhhtrhhonhhigi
    druggv
X-ME-Proxy: <xmx:QqG1aJZQk38pWZPUfRtMdGUj4gUf32jREDDlB8cSddU8-Bte6a_BGA>
    <xmx:QqG1aI0LMalgb6WOOoOvBq_ZHFcA810ON4N6sxEckbEx2UH355DlHQ>
    <xmx:QqG1aBnD05OhcRlHKCFLP4CiLGcm0kJsZXFJNAUtGT5thazjIMDFJw>
    <xmx:QqG1aLuu7r7Df2HXyPIO-14-qQlreeIXRd5bgYb73qe7TD5XXuvCoQ>
    <xmx:Q6G1aKbfgfdq7WHr6K7GavWXAT9kKUqpMQgMvatETMxCn_gjK_opBczb>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 72651700065; Mon,  1 Sep 2025 09:36:02 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AHNSoFB7hZ_J
Date: Mon, 01 Sep 2025 15:35:42 +0200
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
Message-Id: <35893d46-6caf-49ea-bbae-6e1cab6b2914@app.fastmail.com>
In-Reply-To: 
 <20250901-nios2-implement-clone3-v2-4-53fcf5577d57@siemens-energy.com>
References: 
 <20250901-nios2-implement-clone3-v2-0-53fcf5577d57@siemens-energy.com>
 <20250901-nios2-implement-clone3-v2-4-53fcf5577d57@siemens-energy.com>
Subject: Re: [PATCH v2 4/4] nios2: implement architecture-specific portion of
 sys_clone3
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A4931100009
X-Stat-Signature: g5m6acsi836ca6kirgmsifkex4k3r3hy
X-Rspam-User: 
X-HE-Tag: 1756733765-316944
X-HE-Meta: U2FsdGVkX19CHdRlpk1XWIwLEMRlDhX9q+HhO7eTz0mFFI0iCS7Si/vV4SZlEeaKTe4ivZLsK2jVeCRPBQr6H6Mm2Mr3QJC1sjqpQohr35+YivXdTLZyGD+VEJN2FOjr5/lQs2OcfOXdptrGLyKAoUb4CqgluCY0TgXG3Uk6ZMBZd2Jq3UQdtdfXCPrHYKmlfsfrMq4ogavDEgZ15E3vzgqM818bSqBonODNMbXKWlIhassm/FIQ02D+5IHbWQS4aIMimgzSvqKtIGKq4oC2D/+ZHL+7VukvAf0idrZmuMIMSfttcw4HeKQ5f68j4tdP9p5oXbBvCy4C3Riwp9TI7lRICpZr93XjGawspnLHGhG5YERKBB/cKIVBKZomlECQAURhVDvIom1mxdyDMnACwSg/b3jZMtEPUg/x9VwE1M540Xcb75cV7Exr77nzFYmPpfn0d3qH+9oQW3/JD8bcKJK4r3w0i4/5YmUJZ75s+s+9ILm2tsua7yLh+ro6mRgEa5WMKuVrcFppYmrpgqo0QGodNK1HcTmiNe86hjiz95GPlcRzejbUXmJYqLwaL/sReSidhEhN9+xmS3I/rVffgHnAniUgDdogAUfPsHlkz5pmaUyMKQCzVOx9BN24g31/++7AVgW+NhsnSEg+veaE38bU74DdpvFEoK6jKrS7LWBywpbrjg27e/hSlxLUTMeK0wxzrQIGbKk/sSGpfO2Uho9MWOYo0cZBL6TTI5WS2rbXs5khF2/mbzUDJy/aoOQPo6UY05NrT/Ow+NNBZPLdKU1/09HpBe1PqYMx2IwWDW8sknlkfb+TdjsWNQQWUqD2wD+ILstT33URQFGTnXXe94poy62KlfqDy2+qdgy0IFL1qISh5ymIBCqyJu4ZZ1uu2agHvRxPYvPITd0/a/AYJZZhOY6yoSHa0JA+l1OIPm9Cdk1Rq6iDOmRJUgfBsdfbjyzPucgNCKYQ2dvOlY8
 Spdxq0Qd
 XMk2blHv8IB1Pj62Rh/EHh97SJx8VB4R9SVJikAvhd/Pj2SlAivNN+v+MOpsKsXF0L5ybZEhQCsGPQFoLp97VYOFmQw==
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
> This commit adds the sys_clone3 entry point for nios2. An
> architecture-specific wrapper (__sys_clone3) is required to save and
> restore additional registers to the kernel stack via SAVE_SWITCH_STACK
> and RESTORE_SWITCH_STACK.
>
> Signed-off-by: Simon Schuster <schuster.simon@siemens-energy.com>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

