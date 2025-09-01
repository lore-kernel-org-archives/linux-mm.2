Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EDE2CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 13:31:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4AF38E0050; Mon,  1 Sep 2025 09:31:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD4898E000C; Mon,  1 Sep 2025 09:31:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94E398E0050; Mon,  1 Sep 2025 09:31:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 834FF8E000C
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:31:47 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 39BB211835A
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:31:47 +0000 (UTC)
X-FDA: 83840769054.21.2575FA1
Received: from flow-b2-smtp.messagingengine.com (flow-b2-smtp.messagingengine.com [202.12.124.137])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5C16B100014
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:31:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm3 header.b=j6cv+uWE;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="D SMSTkh";
	spf=pass (imf14.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.137 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756733505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Eznu89d4Wi9DxarExeHtKpzVjwvcq68i7OTy3S868gA=;
	b=vrDbDda7ABHDJAuKnJkVuCArzeR5mPp1o6kn44DNVZ8KQEGKGSmwZ19NFk8wU6+mdszhbX
	OUXO87LJpWqC6LZlQHeGDTe2hBF5cIVQMJKExFB6DbOTpY9ME9/QV5Zkf5UYDzG3vdf95D
	54AFfJ98nEbjxLRbs4naRb+FUvCtjn0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm3 header.b=j6cv+uWE;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="D SMSTkh";
	spf=pass (imf14.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.137 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756733505; a=rsa-sha256;
	cv=none;
	b=NAi1D3UE30LRNFVXpp5dgPFaSGDw9/bKmfjsX/Y9ce2NYc6z0PhgXOrxQLDWFxl4h0S0rA
	3nXvgyeV2xSuH4KoABYK+HFmNU6dOVw5JnPype+eTFa7d1GUkQ3+v02moufOiTZHv/e7ZX
	WH4cV9Q50EKN4OagkFp6BaCeF/iVri4=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.stl.internal (Postfix) with ESMTP id 5D0C61300A65;
	Mon,  1 Sep 2025 09:31:43 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-05.internal (MEProxy); Mon, 01 Sep 2025 09:31:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1756733503;
	 x=1756740703; bh=Eznu89d4Wi9DxarExeHtKpzVjwvcq68i7OTy3S868gA=; b=
	j6cv+uWEmN4tRp4L+tzI/9Zq6plmAiANvC3bo2w95zYsUC+H+2erTLZ0M6N7rnUE
	0WJqmOlYYzOb6wa1b0ygTdG8BC5pYAWdzw2aqVPy+8gMQw3BlT0hWNGrjJ5655BK
	jDWe+Joso3PW8J2CnKz3MeMzgwGqXtpLwj39pSqXUuiPUDezRBK0v5/xoU+sFox3
	GWlZUV/LVedziW2nrloxdmm+vcN5X4cO58hdosyWO1W7tMLZTaRBkEP/5cheXfwp
	+K5jjBJhDLT22wliXgMPdBEhiHMG/Km2fCAWR75bU4MZMr7W2ppn+8l8thXubf8x
	H1W/5LtJ+sW5tj5YEJdOHw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1756733503; x=
	1756740703; bh=Eznu89d4Wi9DxarExeHtKpzVjwvcq68i7OTy3S868gA=; b=D
	SMSTkhz+YqIgiIvkfFhIfiL/7qZcqhBI4oCB9ZKy/r9OlCO0VYO0928G7HzW3t1X
	R5CRMBk05X1v8XiPu0gU8Dsn6nFpXoqjPCqceWub8u0XqW6tCJ1OP7wG35dQCrI7
	aSnljlc2n08wq1OFKrRVZX0kwVGoKguuQ/7/Dcw10oaWILbODGBPN66UY2hV+Hsl
	Pxzc3wqxsF+FDOrc6yCoojuU69bPtOK3gY/ELK/7yp9zj2ym+EvtTx/qYimHAc9i
	BoY9nsK3bIOPmDgoDjHr1nj4App+jYB2XmiH3LFMvgce7UfNmWvVI5wf8Kk3A7Gi
	iHW0WInKpkLoSLGn621+A==
X-ME-Sender: <xms:PKC1aIcONhsW8pFWOV14Sq7PTSfGUzdsPiv1pf9lSeQIoeQuUROA1Q>
    <xme:PKC1aKOVe-VGCwHjIr1-HCUTyP2eI6IVsjiZwzoJs8XrW5uMtrI3FpSZ6Dsf67EKk
    UVTmDVgbd78EjylEJU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdduledvvdekucetufdoteggodetrf
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
X-ME-Proxy: <xmx:PKC1aPW1RGYxcaPPwQB08we1CrOb0vWdovfn6r5qNGsSUnTRNoysJw>
    <xmx:PKC1aACPYBlQb5Uv6Ak1zXW3vbtk9zPb7jxSCaujwkmIdsz7VISSsA>
    <xmx:PKC1aBANLPAWF_L6c2MK_OSvCPKCWVpa-XxY8Gz3G2h9a5ymRg7i6Q>
    <xmx:PKC1aOYWrsQphouZ9KK0mtpQNLo0VBdm9yK6cb4vr0A_2uyW7_Wa4w>
    <xmx:P6C1aLu2umbwmZJroLvt1vyRUndw9ctOMRaDydbyr815g78VacSqp4S2>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 68A5D700068; Mon,  1 Sep 2025 09:31:40 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: A1XJ5FccVF4B
Date: Mon, 01 Sep 2025 15:30:20 +0200
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
Message-Id: <78ca3a1f-2ed9-4450-95ef-d690cf4aace1@app.fastmail.com>
In-Reply-To: 
 <20250901-nios2-implement-clone3-v2-3-53fcf5577d57@siemens-energy.com>
References: 
 <20250901-nios2-implement-clone3-v2-0-53fcf5577d57@siemens-energy.com>
 <20250901-nios2-implement-clone3-v2-3-53fcf5577d57@siemens-energy.com>
Subject: Re: [PATCH v2 3/4] arch: copy_thread: pass clone_flags as u64
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5C16B100014
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: yinz17dw11ob898u7oirmy75s89ti8su
X-HE-Tag: 1756733505-704966
X-HE-Meta: U2FsdGVkX1+ZJ+at+tyw+VFHqGGm1Zcx4wj1mrNcdwjORgztW+bJ6c2icWhQDUsxA0t4BPJOk4szUpzN9MAC1SzeMNEqSShSKSpOo0KH9K4qsBBkMagvpT3iN8d/BRrrJ2XCbt8ArakqQRWnxmoUVraRjWS2g8pP1fWCzLiI/nFdqaaOirHFDhjv0LQ+a/3edKv6RJ1cgk9rFxagKrUm+9qlAwUQ2KOZeGn9uhZrBUAHHxwcDVTEcUXqvCtoB+Py9Yb6VHhadofyp29YRwYN8FYSQlz6JkG8oYWRDwubaA7EjW/3nfmlLNOvwWLVtGIWWj+6nDBpvdjTHG6C00b+KRzLaqz2StBKvrffJBSta/RykIwbHeWUdOw1T6Yzm+ZrSBLqaVmko7wL5hVp95BSw1LJpee6Ntv767RjiA2aUUs5jAgTNxwfg9hxnwEkRIV5jnuscpgL1Uke6VAxkt0fc4OH3IArA0I09UcgYQvmclCoVfaQdE7mfthKJyIlhKnVgl4f/othcyX6fw89tXZPYTh4mDJ6y5j2rdoL/mMtjidVteN/+1jpBf/U5dhtvaw8kuz04CaGIclUMjp8KxsB37bFFP9CnkxdnCYwkimESTqNoZQoYUIQ3Zthhzr8ZToyOzrDOxTkr2CupxrbXApO2krWbKm7Xqn48uFA4wgTPsCyWB5dBbPTZH+5Tan1PlEM5E8EgKSXwb2rc0lfYjdS0WkGbTL5mrqXxbmSkD5pGaxVBkYOioUXdOfHzgB52tHTZosiDZqPA+4N6O5cRcMRi44cEa7oHY2z1YrecMsk62UXT2Ozn+si8edmogFJx4mogYZSIkhj6NPdnGiciGxu14XcWTV0YGEKrTTUAZv7hMXp/dEE/YOXYtgTrH/g6L3SWszI558r4SR+/MP19Bv264oeOqlXen9dHauGFVw7Jp4usCkCNxugTycHUpJsUoeaRhzE+t1Sgj/f4ATuARo
 XxSYQiFa
 6Jvrfnc4tsX+32Ic0fJWjfKREeCow/oKGF/f+3liY451Bv4bMv8YtM+YFSyPcE9yGjshInHEKXWkuPduXGRNnQTojcg==
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
> Thus, this commit fixes all relevant interfaces of the copy_thread
> function that is called from copy_process to consistently pass
> clone_flags as u64, so that no truncation to 32-bit integers occurs on
> 32-bit architectures.
>
> Signed-off-by: Simon Schuster <schuster.simon@siemens-energy.com>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

