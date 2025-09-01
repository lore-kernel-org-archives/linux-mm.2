Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 896CACA1000
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 13:59:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD4CA8E0063; Mon,  1 Sep 2025 09:59:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D371A8E0006; Mon,  1 Sep 2025 09:59:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C02398E0063; Mon,  1 Sep 2025 09:59:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A35178E0006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:59:36 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 475D6C0878
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:59:36 +0000 (UTC)
X-FDA: 83840839152.12.A351A9F
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	by imf10.hostedemail.com (Postfix) with ESMTP id 12264C0010
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:59:33 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.166.43 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756735174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NmDip3pK7R1bCI3jhASK9yPIU2OeMFz+fVnQvMU5RZM=;
	b=RdU/KVwtWF7aieyxJVxudBscekFF3Xh6p2I81uitqzCEirkkfRQ3PnBFfPxxzlF+1cDcaz
	SrCRWbBkSWkLYXQUlGx3lKjTb9OuEWujQGVcZzsN3aP/fn7buFUt45PA+1WqqjU51tsK/H
	fuu5TkTVSosWPICNOLpOA0hoX52oZhk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756735174; a=rsa-sha256;
	cv=none;
	b=LkbBPl87RS2IycvoLkm+M3C4PU0NRGiVJmmglVlxjHlBrB5t3cH5LDMW0ihLHMe+LuGE5Z
	JANcsuoU3a95dhVaExcknzQ3+gMgTfRTY5qhbMEdW2V+ROPzUW6tvnYQN2RKli8JccKi7p
	hSM1lLbcu8nXMdtMj9dPh8LZcC7LZnY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.166.43 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-8873044d611so46703739f.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 06:59:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756735173; x=1757339973;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NmDip3pK7R1bCI3jhASK9yPIU2OeMFz+fVnQvMU5RZM=;
        b=bbJrXPFG19hTvdib/eFFfr0QRwihbVVzdEt5m8jqjpAU2L3pfbK1rVPd5bWHpA5Y6y
         HA0S+DBixJhGZ5hmwounXyZxukhWYfxWgM//2UU1EHOV4Rji31gj8rdbM7sW99eQUUEq
         Ui0VMIMGIf/xTqcy2OnINcaCh0mfeb+XJgpxM6j/z+9MinuxTE+tTNUkOLREPHwBJ1GP
         PL8YdAKLW5225SydAw88yQ4dE838TqSCeGavdQUjJ7dX6U8t3ZL840B75D1GlPtoA6pD
         SilBQCInZEyRJ+63rLS30WMTJ77QFcYgau2egHBCFBjH/CWvcYaS6dITIz7YH3tQHV5V
         qw7A==
X-Forwarded-Encrypted: i=1; AJvYcCUumtXyOju4kFv+Tm4JGmZYr8sj4dkdogR2kz54kK+TV3yO5ThZ3iU+GmIrNbEq4fXUum6dv/kqiw==@kvack.org
X-Gm-Message-State: AOJu0YyT0teVqI/OaSMS0qE+Zi5NDY62yS6XMzPz6/bFlZkmAHkns3oi
	VTsfLZNcv+Vtr2x46xLI4BHkfVAjXtpUZ0tdC9OyDQwIHPiCsRh569LAdCjec/YU0S4=
X-Gm-Gg: ASbGncskxS1eD9ZfQii+FD+ff8Z/ntgTYbbxIDbARJrXoUQnVSHWUIBjhW7XdF13BgM
	ukSmxA6RzcJcMPrHxP1sI8q1fsf2qVQloLXTn3EzOZKwZv1rOrcHsEdVLZC2aWM0gExhTb7dXWX
	yDtNKS6IuNr/TdvusoPrWEXsesG0oOVhuC/SwDcOFv+0J7H63iRKtH0A50CWj2pspmw4QbbZloJ
	DtiMWjKhFvTezCJW0I7vJyG72OjybuQmNCfY2XRcdBygyaHE0neEF+vf1MhMZLsBdL0SIQgMAYw
	GrMwWIoIenHT2m9/irnT2/pLJFEm8w8izCtOnOP9OYxo3uWaN4WTLk28Z7bjgI3+IlT7nR9LKsh
	2QLUWiRgLYHivk5He3bSaByF/iANyNqFcRHAdh21PQuC8nnpV+sCtxudjCqU3P30V8hhTVPLYMn
	w7EwBLlZPDHg==
X-Google-Smtp-Source: AGHT+IFhO7LKi3RDm020OdVbYH+HQqJvdeWwKwt18VQLHiZCIZLs0YO/H5IhNqMeUrfO6krp5I0xdA==
X-Received: by 2002:a05:6e02:3e05:b0:3f2:34c1:d51e with SMTP id e9e14a558f8ab-3f400475926mr169140315ab.13.1756735172831;
        Mon, 01 Sep 2025 06:59:32 -0700 (PDT)
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com. [209.85.166.181])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50d8f31caa6sm2365633173.43.2025.09.01.06.59.32
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 06:59:32 -0700 (PDT)
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3f05a8fa19bso44594985ab.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 06:59:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV23lDZ7Bd+AbnbteRAS06P2eq36dqcvzJst3aWtoRwCkDSYbX+7y2XuP/eJUFMM6yU5obmMr+vsw==@kvack.org
X-Received: by 2002:a05:6102:3053:b0:52a:c340:11db with SMTP id
 ada2fe7eead31-52b1bb24afcmr2206016137.27.1756734711158; Mon, 01 Sep 2025
 06:51:51 -0700 (PDT)
MIME-Version: 1.0
References: <20250901-nios2-implement-clone3-v2-0-53fcf5577d57@siemens-energy.com>
 <20250901-nios2-implement-clone3-v2-3-53fcf5577d57@siemens-energy.com>
In-Reply-To: <20250901-nios2-implement-clone3-v2-3-53fcf5577d57@siemens-energy.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 1 Sep 2025 15:51:38 +0200
X-Gmail-Original-Message-ID: <CAMuHMdWyCbOgs6XyW=8PG2pVw1-zhWP_VtsXsGz1HeFrZ6kjdA@mail.gmail.com>
X-Gm-Features: Ac12FXxyJUafI_d6iF6chcUi31LuXt_e8cojxsF4wFcxCNHCg2s17r6RQqbjdms
Message-ID: <CAMuHMdWyCbOgs6XyW=8PG2pVw1-zhWP_VtsXsGz1HeFrZ6kjdA@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] arch: copy_thread: pass clone_flags as u64
To: schuster.simon@siemens-energy.com
Cc: Dinh Nguyen <dinguyen@kernel.org>, Christian Brauner <brauner@kernel.org>, 
	Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Kees Cook <kees@kernel.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, Guo Ren <guoren@kernel.org>, 
	Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Anna-Maria Behnsen <anna-maria@linutronix.de>, Frederic Weisbecker <frederic@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Masami Hiramatsu <mhiramat@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	John Johansen <john.johansen@canonical.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, 
	Kentaro Takeda <takedakn@nttdata.co.jp>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, 
	Richard Henderson <richard.henderson@linaro.org>, Matt Turner <mattst88@gmail.com>, 
	Vineet Gupta <vgupta@kernel.org>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Brian Cain <bcain@kernel.org>, 
	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Michal Simek <monstr@monstr.eu>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
	Jonas Bonn <jonas@southpole.se>, 
	Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, Stafford Horne <shorne@gmail.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Yoshinori Sato <ysato@users.sourceforge.jp>, 
	Rich Felker <dalias@libc.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, 
	Andreas Larsson <andreas@gaisler.com>, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
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
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 12264C0010
X-Stat-Signature: eyabxixbwornmyx3qj8jm5t3yyy53k6x
X-HE-Tag: 1756735173-722305
X-HE-Meta: U2FsdGVkX18igkYJiDwA34TIyqhEE81YEMCct6seTR9LIAg8CUCZoOcz2JvXaFtm/ByKCCBPSQ/3by6rQ27ToQNRZvMXvFwMrj1d8Dodt2v3LBiIOyTiW5rFaZ4xXKtwSlEWI66Qn6ANKoZ44x1HNlHwfSMc1iuPhnxuCcmEcJniJfbHD09P3C3QT9dgNOhE1lj6E5J5SOaFSi2VJomYPoZXkFPrB95EO5xk7JCp8Lys4CRF2KBFasOjBewptV0yCVpRW+6hdON84xVVsl5ua/AfHvc8j6VdrGwPG2AHdkRd6o68c36yL1TxoYtXf6wZw2FcFPJLAzO+Xt7zLI/cERfVoaw+CKpnNPeAj9fU6YbsFn5l7afP4sB3jqAG4qVzvVanYP36NNzV3XzXw+cM8UeHA4UDPkaFVoaT5loTN1eNolztPs50byqIIo4FdlRQGAA9ebCSp2c6Dq7LSLdNL6A2scT7C+4Cp8Jzg/poMOL3T4WfRr5Hwulynw+B4b7gjl4oqAbdon8Pal2Y4XoUKBtG26e/8e2EEw5kRjs4DyHCwO9826Snyf+imOVEjBtT21nEVeX6iuNIc7iycSamA4VfCyLs6JewfZ8nqusWKIyFvQxNM4HyVBQ7T93KxP+Tlfwky6ovDCA5Hi2Gg8Bk3wef26oSmCbXsQwiD2/KzMTRutABbM2GmrOGazIteadqa3oKYXf/dC1+DkKikSt5RerlBLxwqUwFGWjKqnO7HP9RanLOfz1Uzc6mYqZt+P4cZXCGaz2UAmJvEVadvLx3Os2Fw/Ltj2Kj4khWGvvjr+1quSZT6j1H6g5JW8UBQamMNUyInTWlPksNLyPr/WqxxRAKD8qSm1tXcSvy/ypuZxPVO1Jt3aDJicBZgQaI+meZa58tHDqc6pQo7494RohshySyKA/uFzz3PO3SPynYYaxJncTxmCupXPdVdBzrE8ZIqJAN0L88NNqyFa4DoZT
 fgWV/i/g
 lMB2wbl2H9ah3RQBQy9I6ZheUlx4f1PfzuaYR27rvIPenPRr3TnAYCnr44/m7Mb68gU+WynhGSb6pd/HzPjK//D/YRHIoSn2zyoS0GoeDl2t9/UHXvRQwVdlocFXsxmnpmvvqfpk+ggD6khQbzJe7QlCsIRLKFvFiFxjheZOqZslrI9CPTeXZVHJWp/luebAe3OwCj5R3Acsol4lZjdtYmnBlaLZzHvVAkuiPD7tggQ71Qyk7s2KG4Ge3XHp7wstRVwPJEHZDFpVuUHxu0/rLDsKjqbFeZYYI0aNTLqAOKLUpB6K3uv0j28Gipu1UfV2IKbYnhau6eMMC86S4WwqqjbayPu/dN2PmmDdQnJN3cj9qCdxrguCT0zYQqDGBsK5crN60n5ryE9rY2bMlwkwbFmm/vxRiJN7Rax3wZsXZqVfLFmKRAUgMcG4EzefkQxXGBJvFz/briQ60f31dsb4uqsQfyC0wNcjL5FaKEzJI15Lyodb9xVf0NesHbmFpdsgBwoioIR885eb1r3HpU9HFFpi+4SLfGcxG/ZsXFYqNkykrz2q4Hh0OoWP+4bvEOMDpaguqeV9YkAsYycw9c1rzJxxdpN8AiXN6p4Df
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 1 Sept 2025 at 15:10, Simon Schuster via B4 Relay
<devnull+schuster.simon.siemens-energy.com@kernel.org> wrote:
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

Fixes: c5febea0956fd387 ("fork: Pass struct kernel_clone_args into copy_thread")

>  arch/m68k/kernel/process.c       | 2 +-

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org> # m68k

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

