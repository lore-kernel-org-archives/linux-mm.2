Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED0FCCA1002
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 13:20:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 452C18E0014; Mon,  1 Sep 2025 09:20:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 403328E000C; Mon,  1 Sep 2025 09:20:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A37C8E0014; Mon,  1 Sep 2025 09:20:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 137E88E000C
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:20:01 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BFAD7BBD1A
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:20:00 +0000 (UTC)
X-FDA: 83840739360.17.4B77161
Received: from flow-b2-smtp.messagingengine.com (flow-b2-smtp.messagingengine.com [202.12.124.137])
	by imf03.hostedemail.com (Postfix) with ESMTP id AC7B12000B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:19:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm3 header.b=tLTVNY7s;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="I zqfGdU";
	spf=pass (imf03.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.137 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756732798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mw8Cn4/OCWn4lPhhW5QgwqsK4SmxabwHi0TRYO6VF1s=;
	b=M2nrnTMFAgfCXCVOU5iby0HS7BVh4dHKllyuxZIj8RZsj3bG497gl3IhMlXN6YE3TNF6bi
	xrRVtPMG/zaMH0678R2/fu/F2oj02dcDTNCkN58QWxQbXxa0yaAhgx59JQy3Q1G4BC2ssu
	85Ll0lz21dgRYC1QG+mtTSKqpGvFLZI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm3 header.b=tLTVNY7s;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="I zqfGdU";
	spf=pass (imf03.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.137 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756732798; a=rsa-sha256;
	cv=none;
	b=Jx3OgxaqbHVLZQ/VplTfos4KMiWwNyHnmoUfnbQhprqgSeU/pKbOHTpHGrZhe30nJGk8vp
	EDvmU2/XpvnW/2L1HxCrBXMCSVooMgKmu/VnFa7SVXj4wGJ3hUqHw5gsnHOVubmpM8yfr4
	5qOidYajklzX23pk6N4BfI9hgC37Ja8=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.stl.internal (Postfix) with ESMTP id A6FC21300863;
	Mon,  1 Sep 2025 09:19:56 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-05.internal (MEProxy); Mon, 01 Sep 2025 09:19:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1756732796;
	 x=1756739996; bh=Mw8Cn4/OCWn4lPhhW5QgwqsK4SmxabwHi0TRYO6VF1s=; b=
	tLTVNY7szoigfD1bdhldSITh7Kox+Ycn17T1yGQFuN7jiGG9Sp2E3OoIEgt4BlYR
	rNhkEYaaTwW9AY8m/x59u8SKCEV8qlVaBwXQvzGnzQoPzBL4TjVy5CdpcL+u+JqB
	KmJ3jHWtf+GNS20ntReqncPg5QMylzMw0aOyUz8qs6cq7e90TqtTjq8VaJiUu84j
	0Hbrt3spucncVfrk667VYr7pw5WfvWM/7x1uij9C9tbA0VlIJi04Xfi/PwUtHZjH
	tp2QLWr1i5c0AXIenHSE0ClgWTuzdKOBvYNRbC8MWhIAWUeC6kCgPRh8m9F4uMyi
	KzWTcNLbW1JaPQ2Aw11NKg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1756732796; x=
	1756739996; bh=Mw8Cn4/OCWn4lPhhW5QgwqsK4SmxabwHi0TRYO6VF1s=; b=I
	zqfGdUJTZYsd9+VQGEkI1q4f285SfJOyQUijCL8E0cG2BY7oScLcaHaB4U4dSd6C
	amMI/0oCv9Bb0UfFnGfGYioT9dMJyeughesxg0Wy1rdEh8SQOGdyCUffECW6u3Ik
	7Yt199ahGI90eOSQbbYW4SeXGJc3EXxwFehYo9jcgKLtOkWvo9SKPtZekLd+KcYs
	Z/Fffj6kergS+JKtkBMxaKu8MQZtZradNzWqlU+a2WBOqFRrht0dAWPgSu3etycz
	k7O/f+D6scJuUcbaLBYenYfBxURlHHBUlfglvq526uItPCjL8pAUcIHJOR7e07hM
	zb1rPxkwOSlF3dLiDllTQ==
X-ME-Sender: <xms:d521aOf13Zr5ThFIjcbvwdTTV2pPmE198UZ83DSiYsB0vWHFjqexWQ>
    <xme:d521aINZWaZx6d4hdtzCY3ReTpNDHMXU4y76p-zL9tbADaAIKToEoWjoFLEFK0nJN
    uZjL5twG3OOu4Cx9a0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdduledvvdeiucetufdoteggodetrf
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
X-ME-Proxy: <xmx:d521aFWUjfBNEEbfvfRsOXSgs_xr9RfZnAPjyB2Gss4aiPQVe79b8A>
    <xmx:d521aOB9sbKqEptN3OSwQ4xRQk_xYmG1ZydhuFGxz43PvXYNa2Ks1g>
    <xmx:d521aHACv2QrtY793xhqmmRyjqkD5ZVdMHOozOYGDyCY3vyLPOZbWQ>
    <xmx:d521aMbQNOQ3kj5F7xBftwDq3uTM_HtOBAYus1Iszp-XmI0rzGHioA>
    <xmx:fJ21aLW9J1hdKeVm-quvjTtf5v_yEVzzCp7GK-rbIpJMpKdzZjrbFv0P>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 76793700065; Mon,  1 Sep 2025 09:19:51 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AngmsHLdt4H3
Date: Mon, 01 Sep 2025 15:19:31 +0200
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
 sparclinux@vger.kernel.org, linux-um@lists.infradead.org,
 stable@vger.kernel.org
Message-Id: <13f8ca46-92f0-47bb-a046-165402122a44@app.fastmail.com>
In-Reply-To: 
 <20250901-nios2-implement-clone3-v2-1-53fcf5577d57@siemens-energy.com>
References: 
 <20250901-nios2-implement-clone3-v2-0-53fcf5577d57@siemens-energy.com>
 <20250901-nios2-implement-clone3-v2-1-53fcf5577d57@siemens-energy.com>
Subject: Re: [PATCH v2 1/4] copy_sighand: Handle architectures where sizeof(unsigned
 long) < sizeof(u64)
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9jc4gh3qtwt9q5enbzqe93qhdprq1m1k
X-Rspam-User: 
X-Rspamd-Queue-Id: AC7B12000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1756732798-625083
X-HE-Meta: U2FsdGVkX1+4wl7vw7MU8CFxBXmVDQFUuvPdKcCfZvf9F8asOUth9XEwm4II8dDoK87FP++FJUgAQrCMYbqP8YiY/FHzpIAf8euuavH4cefAVhyW7cycgTFiSV5ZrjUH7KjHH6vp38QR82r2pJPzTX+hG8owpcLqDpeX2znT+y9ucBMIcF/2dlZh4pwoAW3+7SB8uLdrMxj5HyK6px0D1KKNO3oxX8bipM/IEi7tinfnCC4W6e72YVTZmkKcPtKeY94iENlof2IQIpoaySNJWRb1owEi1N6iqW94hgkso743sIuNM3o9W6uIBII8NKdnoXAxcbDKEH6+wz/4bBJv3wbvc6JE4mhKx4SBMEiVGKfVD96mzjU3SIWRg++J6KT91mpFEQm0qqiU/of9iIhuBFZgeK4Tuh5xG1Ei8i8Z/Q12v3ku8FQbsngMSapkAZK50VCiZqYcPPX27ovr4Yk0pCzQqT55XuhS9Vzr/WDT0Mu/U3Y4jcTX0m1oQgjDbAvKat7KwDJGmF+jsC3bHY1ipkuETZvzI+AD3XLazznQ/VqasrdST31wXe5KMW5k2c/0L44dP1X0EmCqN+KmCEsIu+iD6HmR1s8YZKRUlsvtYdobZpHihwb42DHpAU4uA7jCA7RROIlXfpW/soQmb74l3TXGKsZynjaXmAwqqfky7vtQG2fOEPMemhVtlLzXtzfWyvEZhUxn1kTAzJrOaH4TzoLMshJbfA1JXgI5q4PSwKgRSUzosWGk0T7DpAihgp87qQHVB1I6j1c9bUa0ws39vIqCFgWt7XIoOJzWc8WaIerrOj98GD5dREqaS32DbbWL72fDRbfX5Yqf4tR9MP4VuCe3dSXguqAi9Ufclt7jKNTcA3aMakKlVwFUSwNy+Jh3ZDzTWoKF90Ws1x6YPT49UReQJAILZlmZ6O2UTdZO4BuUN+hiKgNQ3ONCiQYnhDJki5ZtSYiU64bIKj+dlak
 ldYWVRuj
 LHICrplwQ/YV3TdPSN76yyNxWKRx0BdOGfvH6Ccxz1tJ6LQko1Lg9zr4KHze9lLkTeCQq4xehtc/e1zw1iv33vWtK8PAwq22kOk+cRfBK5NB8cP3rBwPJzqfMcbHNq2FrL4BgHXYQPuXcvngdaYcmIn5gusIpFZbOBdSvyQWmF4gK7B3EvgYIxyx3t5BKG6+wzHD8KGwx8t4WXb2XPn9bLTKot6gpOa6L6bbBx7vFFJjNxsae4zo129q3WB4rJOl/bPcsZ4uU2BE4BQ9gqP7qIYOMR7zxrrpHamXFQfbbpoi4n+/9WLdLUiISdDWGJZEANZBrqWnRFTsxUalIPC5O0oKSHyt6sG6iG0WrIlDHVqnn/6JYwCV54vYd4xlphv5AylXSNN3OMT13h9FsyAQQXPXVin6sKIx4IMiYK93LdJeza+OExEywd3cT25aVrRLZr03HyD+6dNcZs509M2gCXXHHfouzSj6Eo/mAN1fsqWXK4Bg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 1, 2025, at 15:09, Simon Schuster via B4 Relay wrote:

> This commit fixes the bug by always passing clone_flags to copy_sighand
> via their declared u64 type, invariant of architecture-dependent integer
> sizes.
>
> Fixes: b612e5df4587 ("clone3: add CLONE_CLEAR_SIGHAND")
> Cc: stable@vger.kernel.org # linux-5.5+
> Signed-off-by: Simon Schuster <schuster.simon@siemens-energy.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

