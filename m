Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECC4BCA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 07:02:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47F928E0007; Tue,  2 Sep 2025 03:02:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 408DD8E0001; Tue,  2 Sep 2025 03:02:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A9C78E0007; Tue,  2 Sep 2025 03:02:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1381C8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 03:02:52 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A668513B6A4
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 07:02:51 +0000 (UTC)
X-FDA: 83843417742.18.21A6A24
Received: from smtp-out3.simply.com (smtp-out3.simply.com [94.231.106.210])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9CA6C8000E
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 07:02:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=gaisler.com header.s=simplycom2 header.b=XV9R3DCg;
	dmarc=pass (policy=none) header.from=gaisler.com;
	spf=pass (imf30.hostedemail.com: domain of andreas@gaisler.com designates 94.231.106.210 as permitted sender) smtp.mailfrom=andreas@gaisler.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756796570; a=rsa-sha256;
	cv=none;
	b=nsHmATEgFntTr2jJV+TnjY7KDzXvy74ijyULDO12HxZ7Wki+Pv9lTRDaWTBKzHf8j0cfcn
	jzssXF4DwMf0b5esbXrU2Nu4oy3knq68g3a+qQEiCLw5nzWsqezuzy2YfZvsTfUvPGJmKH
	iLLmPohfKjgIdJN+hOdktWA6/sdgJX8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=gaisler.com header.s=simplycom2 header.b=XV9R3DCg;
	dmarc=pass (policy=none) header.from=gaisler.com;
	spf=pass (imf30.hostedemail.com: domain of andreas@gaisler.com designates 94.231.106.210 as permitted sender) smtp.mailfrom=andreas@gaisler.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756796570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h7e86hl0UV9Yd9fEU7lHS/lq+4/qNkF5NKsTGqMW0Gs=;
	b=YmfLoYFFUxxwF6SyhCWZAvVZI138c0jfoArHS/z3S2Fz3DprmHgfc3KVUGVz6Y8Ylhc7Re
	3H8oQwl0D5oxQ8Gc+fLH69looscP7Y+Dyi5mHx/csgRRa0JJ/6YUrlluRPVz7KXS8Pb1g5
	3MkwzTtssvwi1M606dhpl7wudP3Ww+4=
Received: from localhost (localhost [127.0.0.1])
	by smtp.simply.com (Simply.com) with ESMTP id 4cGGsM6JC5z1DPkm;
	Tue,  2 Sep 2025 09:02:47 +0200 (CEST)
Received: from [192.168.0.25] (h-98-128-223-123.NA.cust.bahnhof.se [98.128.223.123])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by smtp.simply.com (Simply.com) with ESMTPSA id 4cGGsH2GP0z1FXjK;
	Tue,  2 Sep 2025 09:02:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gaisler.com;
	s=simplycom2; t=1756796567;
	bh=h7e86hl0UV9Yd9fEU7lHS/lq+4/qNkF5NKsTGqMW0Gs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XV9R3DCgzqtpsDdLU5B6YmrRSDSwOb/e+RN3Y/eiKzfpmARJpEfk4rM3nFZX0bFUT
	 Cgk+F60Qfnp/lcw23nKISESK50dxfqXIzcv7lABAQzI+QL2HTB89cK9os+EVA7PGjD
	 2JhF3WzYfsb9MEQHgbmUEpzjWOe7UaJDN1f3QJPTIjlP5MtBhYOcxRaj/x5aIgyAIx
	 VylpL5fKm3LmJNVO1eTnB/fXzhohsODH/8iwc5vr/F7Q+FJODNFYRjy3a+H0jjVZXA
	 zhn5kjjNaRe2tU3x5rK51dkv4aqaegmt92utDpWIUQsQcnBLirXe5OB9CcfJT7NVBK
	 WwxEwsTBW60LQ==
Message-ID: <f2371539-cd4e-4d70-9576-4bb1c677104c@gaisler.com>
Date: Tue, 2 Sep 2025 09:02:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] arch: copy_thread: pass clone_flags as u64
To: schuster.simon@siemens-energy.com, Dinh Nguyen <dinguyen@kernel.org>,
 Christian Brauner <brauner@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 Kees Cook <kees@kernel.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Guo Ren <guoren@kernel.org>,
 Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>,
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Frederic Weisbecker <frederic@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>, Masami Hiramatsu
 <mhiramat@kernel.org>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 John Johansen <john.johansen@canonical.com>,
 Stephen Smalley <stephen.smalley.work@gmail.com>,
 Ondrej Mosnacek <omosnace@redhat.com>,
 Kentaro Takeda <takedakn@nttdata.co.jp>,
 Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
 Richard Henderson <richard.henderson@linaro.org>,
 Matt Turner <mattst88@gmail.com>, Vineet Gupta <vgupta@kernel.org>,
 Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Brian Cain <bcain@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>, Geert Uytterhoeven <geert@linux-m68k.org>,
 Michal Simek <monstr@monstr.eu>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Jonas Bonn <jonas@southpole.se>,
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
 Stafford Horne <shorne@gmail.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>,
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Chris Zankel <chris@zankel.net>,
 Max Filippov <jcmvbkbc@gmail.com>
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
References: <20250901-nios2-implement-clone3-v2-0-53fcf5577d57@siemens-energy.com>
 <20250901-nios2-implement-clone3-v2-3-53fcf5577d57@siemens-energy.com>
Content-Language: en-US
From: Andreas Larsson <andreas@gaisler.com>
In-Reply-To: <20250901-nios2-implement-clone3-v2-3-53fcf5577d57@siemens-energy.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9CA6C8000E
X-Stat-Signature: wm6ndyqe7srih3o3a85hgj3qzift6ecc
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756796569-526701
X-HE-Meta: U2FsdGVkX18p0t4CASw7VkB7LC5wwd2mPnnTARacRO1Gdx6Jd/nV6lpfUCZMzrvdMmQvViwxL8yPAnq5UH/rYQ2F9Xdv6l+LAreSVLN2+1lub6taap8ABCnR99Zo/8yLKPxOMIHOhkafuhPi9C1PcsHrpaay9AU3kAyxq+LUm0XTv9sXBQ5Esu8ANA4nDT0CVubDmZotZLeWAQ0mrZ+VvDebHJNThTUFheywRxT2eGY6EwlUD+wTGZkZDI8esZBz8HxJk15jEdDxHWCoHMXTnXTwg+TfejNX2Jmck7gr3CuG1OBHh2mvJ5gzPzqHSkFLz2GI4gm1kfHuPI5PmCX7OjR2DrdgO2qN9ojvBYvu8XDeBzuN928hF+cFQQVLfNx2W1NQ1eSKny+svQ91YdSZOg4WsqrsedQMDLsS26JVR840lS6ApTfyMnnFQiHnG/nqSXQpwnZM12YSj1mg4vJYPNw44wqssicco427IH8t4bo4TVXZW8kfw9TzxIMmj9qmMRZUBrVejrJS8EkgrswlZZdON34uLJZOpkSWNmkfL/qOGB9JB8/tpvnB6UehrWhxiit2EII+TdnLkQDCuEkpuaiAhK7ELyMC1qe+GD+dEyigdNuM0DBBctbPbpCUStya/sbIzn/JVK5Lj5Hk5H0h4MZOYMfv4A7l6kV8A6xnm4a4VpZ3cfIuybLmubyuKoeIzGRBNvqTs4NQOHEr+t2QAv2tUToQWahP4lvyAoDzV9YAoCXgU2TK2wZzf1Njg9DZXOLgvdRrCdE/TVVSY86QoEizuoVbuGjDXjKEbv/Jf3knHjnmSlOxFD9x+biSL6w1ayMw+AnVCwfy6QhhH/ROd1aF2YSGY4txi6HW/g20LflU3Cz6pBD+HFgLxYhrnEY3pg4COz4TmZDGbCPTdM8RXBX1o/eq4GVyBEVhH9kEjpF3ZlawDKY6xLfE4yEz90s0nfMRa6WCVFPVf76o68r
 Qcp0RCwx
 S+9xRX49myeZjHSBZ8+YO74HmJf3MPg3SWdXZ7ggtYSfztt3YBEZPNF66N4MGK3KaRgBt3m0R0mVdZGOYBqbPPlvM940CIxkRsA9q52RioGmKWqsP1JSfQbl9zzZFkInqsxvKcKfRt8tD5CufIHPvy1b5aELMfzLV14lWc/9q7sKUcijmokyfgsfEmjvJyQwuZcwf3j4LdSnqJjjQ+zHpouHIgnabn4P3yVc5b6UIGNaMQ8A96S/rbpTxGg6dqZ0bgLaj/Im2/RyEZ5VpyiinKqW/9LADvedYLWMyZlN4P2Djnyn+t8JcGqUdeuEqWcaR+oYk4Lx6hi4gBRKUdaqktdQp/ROz5MCUpE9gfG5zBqamEAwaPc7VdK6vEVlbVUVWjpVLNVQKCVz/vz/PE9cH6zJLWmWyvxTt39D5vMCnPdn60Gf9ISh1SGmaZEPhldQo3Angoyr24LAdIF7u3oqgTmCea7VbUZS1bKmCp4Q8wtwdslOIrwN+fPzTwgUE4ZaCM9HZlHMTPLNnv/yKgIq31+obcqMQGnu5IsWV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-09-01 15:09, Simon Schuster via B4 Relay wrote:
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
> ---

Thanks for this and for the whole series! Needed foundation for a
sparc32 clone3 implementation as well.

>  arch/sparc/kernel/process_32.c   | 2 +-
>  arch/sparc/kernel/process_64.c   | 2 +-

Acked-by: Andreas Larsson <andreas@gaisler.com> # sparc

Cheers,
Andreas


