Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD5E3CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 13:42:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D84728E0053; Mon,  1 Sep 2025 09:41:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5B7C8E0008; Mon,  1 Sep 2025 09:41:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFD038E0053; Mon,  1 Sep 2025 09:41:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A213C8E0008
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:41:25 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5901616087D
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:41:25 +0000 (UTC)
X-FDA: 83840793330.11.032DF1C
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	by imf13.hostedemail.com (Postfix) with ESMTP id 34B6420006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:41:22 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=armlinux.org.uk header.s=pandora-2019 header.b=NNSzbKKB;
	spf=none (imf13.hostedemail.com: domain of "linux+linux-mm=kvack.org@armlinux.org.uk" has no SPF policy when checking 78.32.30.218) smtp.mailfrom="linux+linux-mm=kvack.org@armlinux.org.uk";
	dmarc=pass (policy=none) header.from=armlinux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756734083;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RM6LIropo7RLNuOlTPTbxv1QAM+nDQ9b+UYR09aJlMc=;
	b=fRmSCcZDkSSfSBH7Szg8J3BqDDI9FJ76n53JnxhBTWoBhPfA67yGcc2XcWh8aFQ+R83gZB
	SHzOo5UrTBHP0MS9uk35y7TBX6b+RLoGkbCk5hwtLxFhB9GaKcQ6TAd3o+QGM1sxcxgSyL
	Ggj5RDWREw2BHg7f0E830qF8EV4gORY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=armlinux.org.uk header.s=pandora-2019 header.b=NNSzbKKB;
	spf=none (imf13.hostedemail.com: domain of "linux+linux-mm=kvack.org@armlinux.org.uk" has no SPF policy when checking 78.32.30.218) smtp.mailfrom="linux+linux-mm=kvack.org@armlinux.org.uk";
	dmarc=pass (policy=none) header.from=armlinux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756734083; a=rsa-sha256;
	cv=none;
	b=fmcdfXVwpj4SXhJ6z0Lf4ebuOOVJEvFpKCQTZJHpVPBTC5h6v6PjipdAfvH/p986b1Rim7
	xCYsNx0+6BaWYc5CQhm5dtNMFbv3KU+4PuHg6b3GT+ObjwpWlHZP09ASK2p5tqUA0CUf7R
	HFliZ8Xjh+/0AQtzklHQg4JZFeFt/UA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=RM6LIropo7RLNuOlTPTbxv1QAM+nDQ9b+UYR09aJlMc=; b=NNSzbKKBeoEQGxwz3UzllieC1n
	kkE+xlduoA52cvOVJ8jOeYLDnjA7TzQmjejbtL/0tWAG+9d4cE2J/ONuut1GmEa2n3uOYVKgHatSS
	w4Pb99DVV7gUtXUUtv6Qx59huahgFOdJBcfSG4lUebtJeMJaPx19VfAFP2QEL4ctfUaF16C9hBX6y
	UUPVHnFWBwC7t9uM24Paclia8molYqT3MAEK8yHzR94WSPflnoyYPEejoREz0fOEhzCs5Hixi72jB
	Yl/2zQ9LpnM0jtO2PdNy13LLDGJvB2fRUarVsgOUcI8Geow897XPZQtus3nSRYJ6D2M2cBF4hHkXw
	gfRh6OfA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55410)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1ut4kt-000000006Fx-1Z7w;
	Mon, 01 Sep 2025 14:39:31 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.98.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1ut4kV-00000000739-2a6T;
	Mon, 01 Sep 2025 14:39:07 +0100
Date: Mon, 1 Sep 2025 14:39:07 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: schuster.simon@siemens-energy.com
Cc: Dinh Nguyen <dinguyen@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Kees Cook <kees@kernel.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Guo Ren <guoren@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	John Johansen <john.johansen@canonical.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Ondrej Mosnacek <omosnace@redhat.com>,
	Kentaro Takeda <takedakn@nttdata.co.jp>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Richard Henderson <richard.henderson@linaro.org>,
	Matt Turner <mattst88@gmail.com>, Vineet Gupta <vgupta@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Brian Cain <bcain@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Michal Simek <monstr@monstr.eu>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Jonas Bonn <jonas@southpole.se>,
	Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
	Stafford Horne <shorne@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Helge Deller <deller@gmx.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Rich Felker <dalias@libc.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Andreas Larsson <andreas@gaisler.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Chris Zankel <chris@zankel.net>,
	Max Filippov <jcmvbkbc@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
	linux-csky@vger.kernel.org, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-perf-users@vger.kernel.org, apparmor@lists.ubuntu.com,
	selinux@vger.kernel.org, linux-alpha@vger.kernel.org,
	linux-snps-arc@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-hexagon@vger.kernel.org,
	loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org,
	linux-mips@vger.kernel.org, linux-openrisc@vger.kernel.org,
	linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
	sparclinux@vger.kernel.org, linux-um@lists.infradead.org
Subject: Re: [PATCH v2 3/4] arch: copy_thread: pass clone_flags as u64
Message-ID: <aLWh-1ElIVNBYctw@shell.armlinux.org.uk>
References: <20250901-nios2-implement-clone3-v2-0-53fcf5577d57@siemens-energy.com>
 <20250901-nios2-implement-clone3-v2-3-53fcf5577d57@siemens-energy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250901-nios2-implement-clone3-v2-3-53fcf5577d57@siemens-energy.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 34B6420006
X-Stat-Signature: ek7761ch53ku6i8a1wxpe1winaiooutc
X-Rspam-User: 
X-HE-Tag: 1756734082-69689
X-HE-Meta: U2FsdGVkX18OyTZ+d7HF5C2lcrpS+EeayVw7t4HMCG3h48koL1RnWYvYFPvvQg6UcebxMoHRZbFYSMBBPv2wI8dWLgCVbJE2Iag4apEifBQgJ06mp6ZJ8pfH7UmGzkxIPE2B4Rgik1twSp0VgAJLUfataYXV22LWkt8LLcuMlIgIr3svog5xxVZfJsEYG31boH07PVwGUwgqkYwIRQpBYv1Ik/urVLO0nF2ltdPemSJVzhsIjqoGF0un9zYO5aCqaMBFNEdnJQ5RjeyAlWGfhZ8bYPB+SXK7Ebv9CS6PEJI6V0jHoowlImS74vMmRAtKESwSMeTaOEw1lfPX5S16srwosysrxL2W3sS51WwlRcHP6viZEtXvlgtWCeG2xPGH/qB/3EMVA1BQiC2G1bfGidEZPg5VjhOegPwpIYcr6jJMHDyY5nvHJV7330DDeKHKjUVShNwPzOJlzmLufBFN41YVhDX+moKd5vFa5ngH81DWZ8NR2s7zhbyarfAxcj6O3jBTKfQq6w1YatNpk0rCz7S7MvZR7aRlGyabnt3p9VicYqGOdOt+PBoxen83KEJCryLKAHUdwr/cAY7LsEcDC67dExZ/4yt57nzgKN/EnA3kV2n8MirxxXKt3+aXWBJCcKEdahJVfJiJjg5bteqNBjTZG7KkWVx7h17RaFoC7ETDASVjUFn5Yee3YJ3McPQhkzKS2qYvs44KiwpS81uALtz4u+dcYJQURl2zbEiOQlbs7IPjLmweXaNui2t0XChMhGZyGMjvA/fujCKUyKoYbS3sVr07KTOUfT6b7I1f/jWFyBFBJ7SXFIvTuvTLgkSdC9pNGi/PgCjPZyY8JwvW0FFectlXkkhDJF42HXylg4l74aBVurYWkbJjxi/VhcmyWl+DY6VvCiyZ0ozQtx7rwGXWSB32zza6qFIL8jcqWnpYp9RXiTVaJ8+8eHZO6hzbn0hXyZDgNNr2TEN9Zyv
 cvN5q9rx
 h1TeIL1uBkO0Zsv9Py+370ZUWhHX6+p89Wllj2/rmvtMFzseJGmCdDm6t/wR+Uwz4hfzPj72Oa4zfDWrJ6hnwYFIPd0teNMOt+tEgD/VzTVyo9PDw6oMrs76K9aNDC/JcPpnWpJqoAq63ssrJnqdfQ8kYKQrSVkgvu3/qBruROEny4a9/BmTSStS6Tecvu4NU+mcDUuV/dfaXLGKLP2FTGVDBYGBra8ZOJCTT6dmHOzRYIjNB/KZ2WoI/pricwFyDm/7Aoo1rz95/ZmSrHR8gxX9M5OegsQbVXvfrZi1G4srm69vCAqVOypeHT2Nr/HEoLUolSVLrfwQprcCWNY6nFX8yLcKwHIfdqRlsXqV3YVtk9xgKMH2OYiCr+o1ptpliVy/3S46ck8Gje71e8pIyHwKKa9NNeDlqmAlMMkZi8NNsmVRlhKZbKkLz/lnkEt1y3kU7RmgBlcQcfilnvos20vLiWGF8kvJtOEw+aLDO3EceknSzP4RBEyNku3N33rHvSXc2jSmnAWJ7sxG8v56ukswRE2U0XNyV2BncZvIkwLPe6nIXKXlvlv5Wlb3HE+CuvAtB/Jy1a+7lu1bk8wgY6puvolt65UKaWectUAVNaDK8tUjxgrGCKfa2CLlAhmG/bHtFplCVhuKy0a8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 01, 2025 at 03:09:52PM +0200, Simon Schuster via B4 Relay wrote:
> diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
> index e16ed102960c..d7aa95225c70 100644
> --- a/arch/arm/kernel/process.c
> +++ b/arch/arm/kernel/process.c
> @@ -234,7 +234,7 @@ asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
>  
>  int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
>  {
> -	unsigned long clone_flags = args->flags;
> +	u64 clone_flags = args->flags;
>  	unsigned long stack_start = args->stack;
>  	unsigned long tls = args->tls;
>  	struct thread_info *thread = task_thread_info(p);

We only have one user of clone_flags in this function, which is:

        if (clone_flags & CLONE_SETTLS)

I would much rather clone_flags was removed, and this changed to:

	if (args->flags & CLONE_SETTLS)

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

