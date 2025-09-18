Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4254CAC5A0
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 15:51:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 298898E0150; Thu, 18 Sep 2025 11:51:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 270BE8E00F6; Thu, 18 Sep 2025 11:51:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 186848E0150; Thu, 18 Sep 2025 11:51:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 08C9C8E00F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:51:21 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A5DCC856EC
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 15:51:20 +0000 (UTC)
X-FDA: 83902810320.12.60DFAEB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id ECAFB80013
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 15:51:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lAxccBgH;
	spf=pass (imf30.hostedemail.com: domain of pjw@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pjw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758210679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fl//kCkijlzCVR9mkoTjy3hmrs7lH+dhZH4qnaeCWrc=;
	b=wLilPELgZQEU6CZDG9++yVIPJioNEwV27mPlPJx4QIs6cjEG2ft90xyDnONJuVdTJZWurK
	XR88TdxtvNfXMsDZxrLatyo8pTmC0XhqgZh9F1RY6tYWGh6lT04TQk84gUvTy7a42Xaflf
	6PPgpUjJiGqsbrKPXga2oXHFrXWGfjY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758210679; a=rsa-sha256;
	cv=none;
	b=T/O9z1IoBfq2wFxVp7D8CasUajEXDZeg5w9HtVlERwjBjHCsNzhqt30yQTHU+PJ+d745UI
	aBdeFIqbC7BmUHGeICAm43AsXZHX14k7YtzEtjC3vD8znM74oBHwACKiqIC6/ruvwn7eOo
	30lB46sot04mllCXdehdclCcAbUReRw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lAxccBgH;
	spf=pass (imf30.hostedemail.com: domain of pjw@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pjw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 30171435D6;
	Thu, 18 Sep 2025 15:51:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D77DBC4CEE7;
	Thu, 18 Sep 2025 15:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758210677;
	bh=e6XJbeklgFNXwruDywAZe7vowNbZUbwBKpZS63m54og=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=lAxccBgHQJMGKL6W5XO/kIBHMi2AladIz8qPWx4MBG7gpBrzHZckIimBwgkALGSoK
	 RTpLe7661eFC5B/7BhfypSLu8ciNLbjbhnW0/Uiw7F9qtuf/K/hOn+NGzmTK4Elius
	 Puw/h1XtP570vHRTCm/o6CmMUjRekyChiJ42E7YZlGDJw6uFwLqKV4izLQfNVxc+1W
	 3GgwOdBMEpO6bPhXxyYgbuGAlwFII7VeYUA20OL3bsW1JzfLATB4CEE7Um16odYOB9
	 O8FOQqOy+9iE5VgV50GipK6qrDd5viCwdSnAqnhpyMVlV7VT8suWp23kcrZWa2l0BA
	 qFbk69uCk7f8g==
Date: Thu, 18 Sep 2025 09:51:07 -0600 (MDT)
From: Paul Walmsley <pjw@kernel.org>
To: Simon Schuster <schuster.simon@siemens-energy.com>
cc: Dinh Nguyen <dinguyen@kernel.org>, Christian Brauner <brauner@kernel.org>, 
    Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, 
    David Hildenbrand <david@redhat.com>, 
    Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
    "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
    Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
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
    =?ISO-8859-15?Q?Michal_Koutn=FD?= <mkoutny@suse.com>, 
    Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, 
    James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
    Anna-Maria Behnsen <anna-maria@linutronix.de>, 
    Frederic Weisbecker <frederic@kernel.org>, 
    Thomas Gleixner <tglx@linutronix.de>, 
    Masami Hiramatsu <mhiramat@kernel.org>, 
    "David S. Miller" <davem@davemloft.net>, 
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
    Andreas Larsson <andreas@gaisler.com>, Richard Weinberger <richard@nod.at>, 
    Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
    Johannes Berg <johannes@sipsolutions.net>, Borislav Petkov <bp@alien8.de>, 
    Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
    "H. Peter Anvin" <hpa@zytor.com>, Chris Zankel <chris@zankel.net>, 
    Max Filippov <jcmvbkbc@gmail.com>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
    linux-csky@vger.kernel.org, linux-block@vger.kernel.org, 
    linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, 
    linux-security-module@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
    netdev@vger.kernel.org, linux-perf-users@vger.kernel.org, 
    apparmor@lists.ubuntu.com, selinux@vger.kernel.org, 
    linux-alpha@vger.kernel.org, linux-snps-arc@lists.infradead.org, 
    linux-arm-kernel@lists.infradead.org, linux-hexagon@vger.kernel.org, 
    loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org, 
    linux-mips@vger.kernel.org, linux-openrisc@vger.kernel.org, 
    linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
    linux-s390@vger.kernel.org, linux-sh@vger.kernel.org, 
    sparclinux@vger.kernel.org, linux-um@lists.infradead.org
Subject: Re: [PATCH v2 3/4] arch: copy_thread: pass clone_flags as u64
In-Reply-To: <20250901-nios2-implement-clone3-v2-3-53fcf5577d57@siemens-energy.com>
Message-ID: <ffb22e54-6b7d-5b88-4217-e67870051c6e@kernel.org>
References: <20250901-nios2-implement-clone3-v2-0-53fcf5577d57@siemens-energy.com> <20250901-nios2-implement-clone3-v2-3-53fcf5577d57@siemens-energy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: ECAFB80013
X-Stat-Signature: wnqedom6cqygccbuwcfyeqirhndt6zbs
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758210678-914680
X-HE-Meta: U2FsdGVkX1+c9kIUIiKGvm0HjROnocHMYajsfyF2ua37ACjOi5GvoSwlp6eNRtgA/o1LXMvZagpzlr6PirCEj/VYxx1ImPM8pcTGi0d4cqdKHXu4nVMq1JP2JKEWi/tzgWu4/C1HkbmyGNvZyyCunipH0QZGuciTvOr29nCIWeklPrY6PI2wmMkl+cd4J6AdCL4O9eyNGz1eN9ca+W65fSOrUTIxWCFFyK2mWR54TGZhu0npsXKiWvCXMbmPveH/LiSwxIX3nf/mLjLKrV96qBFqN3CRasMBiXPsY8Ycp4joEae04T5Q6j0pDT2Q+v1dS+84Qp0PhZyYrA+i7RK1tmOEj1XQnp5NS/bcO2BDW2TapFREx0xYKzlMKVCp39mQ+bStC68zqA4BMmqF3LyuIx+B5cbcrWqEc2/W8kc+UUKB9s7Pfhy3iMzLuOOaZoL+xUpQFn4FDp70gVO0IODWU/DCR0i1mHzwsLCkVYs9JpOVZ7Q2wJLvo/nzU7wBfCptPAiOJ3V4ewqOXnYN5p5tfPEqrsNGuOTHIijnOlWBNHlGxVbHhwgV9L6nSbzPpAsW6VF6m4bbSJLXYcQHoOYqeftVbL8nXaHlIr0uGZdq+4+c2E9gYf6xGUJYDDlghOwGiW1J3XaOBJEEfrR51D3dBRqxZavEcZceVzatTVPFv6QmrO7YaoBRf/u4GS/4Zcd9x6ns6/8OQeA3ETEOOCWcChe9B+glXtDjPVppzdIG6+LzzTXOd/Ve8dCgdWU4uK3+oDCjDxoLPgJFuwvuRDvQbXC/FZ01duK6Ffa/jaDG+He7qqEnMOvf5dUBKbT+GrdEqCx5e+xbuInsi0o8/M6U7H83q20i1ce+bZwis4O34dbVOnCw/IoZtqyMgZ3GugUh7v4Fb67WqhzLqaWZmqJSV5q0jXcsee4IaHxPrN82gnTqZyP/W1WGsDZ04YYCsnfFBmPPx+0PRSFDD14QumQ
 T2TTMPjj
 gJVmGF5C/umynF10U2mv0FgeOb5Mr+hvPKR1i3jbLpS8gKowZM/KeI2zmlV5tuOVIsx0acNVr1CDh8sYw9MimILJ+5yqsfu3l15USZ+KV8mobCJPS+lC1Aow1EutRxWbNPgFZgNxFJZy2QPoAfc38D9X4Y9SHNfu0HJ8aMVRb8vb5OoT1ysYdbOQVApha2PLZBKD6QPNNy56KJcy0ZZPrXEXiFeONhJ3SKODdAzY/PnXOgtRjn3WzLTXpZotIdzSGGxxGzBzafcpBv+X7yuVlJATvaMam15iI+5xjIJ5rnLQX19DElJU9Zwd7l3Qel9J1W80NsJPd/oDFBj7lnjxYfGYI1RmV8YXBjrkt4qKZl7v+iLORi6miHruHvyVNobIYV2ugCZNT8Rz0d4PtqDYr57ff9RdvaNpbkc8xYAXia/hsf5J2IpMPR8Kr7OeFceFicmfLnItq1otGGaKzLvCtzrYwva2tMpQftzJHCr0YPSMzKaZjivkvXEglq3UPeAaiGUnz2RraiIjM9YUF8oxVgEtHbbUszaaStJ9FRUa9OUItRlSq6wht3jDEbybEo27O0qI+uN5EWRbxNqo91HVZggBDb9AOUi3Sg9o7IMx46Fbc3tjpsDxJQMzHmqRlYCLo3wfDoso3tqtiyfoYBqKyar4bVeUEwY2+f1lZWiG6mAXQsX4I3KwZ9mdDh63FH9PcXExl43tATjetBbjKh/s+pKlf6EbFVadJtSKfSYBJuRqSsIUE79lVPg1NK1Em9zJvJYHzYwAEcGhC3AjmyJ4s1q+TdQDMdwdZuICvlmQdMaK6O6aA1gsTfH9RxmflU+B+wspXAcEwExcGrkczqzKTYpUU02MwATOObVnIP3FX6awu5WPbIJFNL3urElLllzxPOvgC0lZUlFvOm6M3UzG0uz5HiUsD0rbhe5bXzLbMDFD5X+xLshGpIBrlhDugfe7Hcfi+Gwz9zKqrqetql3yiT0l5Ka7/
 dmA5S0lE
 OYrhMsGzUxTOTIGoj4MAChzb+o+E+ix6BtThmsRqpoi0eYKoMCAOpeEIvKSkZg/R7WjLvnEgIlg11VQBV7y07gCOXchiwxV7H/JuCtfHN5HAdcvbj3jXJNAQPllD2JNPWn2y0EoJ4sJdXXBZHcdAex9FN1pa7HkYIGOe8JUg9IUru6qes6EvdYCvFRAVRP92iZhRwULgiWUaiy+/RYFPwlNARmQg8elEc/U2FY2YdB+y1qzwaOCGMzTal001cEX2iC+Ik/a9uCr+Z2y5Hm5H5G3EI7Yo34hF4JxiyQ0aHizQ0QI6Oc90ra9JuNUdQ6G6+VK8b6q2SgKvnQnqZ5s6i0v40cFXnra6xpHn+hkL/Yy4Lbu/mhTXcFn6x7+ceJ32wVAcmPf7Sq/XtA9T9WhYFfWn+rkTHwaWT+y5odHh/fRp0Dp+tMOgev7dj782kmob/iDVouN7J1b3fTxNvCJLaw7g3pmGs7xL+OzTJRLw+nemXGVfRPFvX7Lju0vuVAQjzh7MA5JbZ210RJOj2khZi4/9a4dN7kuCr71hh9qspC4ukDESKa0Vh4kG42zH+pQtO8YUeo1BPudCpDOjAP9Fax4hBzvT2b40R0tP/lRAv3vxp8EeDW8BFFNvMus7LGF1CoVcHh0jkluE/KK0zz2dWN0rUNumnCJXliKVdh0S97ZR1/MFxw7t3jwzpWJDoNwMy9SM0CMzkB0CidYTIrzVJgirTjy1uYFd3Q6Fs3k6TD/DSo9t0+8/LS5uVE2G/beA/OVTui8e9SwLn1OqxEhYjNU5vqu1GkL+QcqTTyGeNDxt0V4Ps9l4S39RK166l9k+e6DbEDERRXHXqHGZI8q/jmM3Kha/1X+kbq+DE8T/rETcph1ODkzbWMb5KUujxqLXF+5jiCnhAcuMn9MbUr6MhLgYIk916I8z1/8HghnP1m4qitwr0kSS+fmIxZc8FSKHJPZi4kDbWQo6hNF2pG5TIbWp6ezWt
 qveszjhw
 q0Ca+d/uj03WHgm7VBiW9I+Zk2vZko1e8CSr3cm2PKfDejbbFLwbM7JTrEXGxhZc0q29gtLHceXaqDB8H5CnSmpuNU82jDy+VAfKdZiNTuttEMy/2hY11voAKGuGwAb8HFvIWRzBdFMJo6j4Xiwc0xcXzbz5Wmx9tUjaJt2E9R/p889Y3uNQdnws5Z6RNcZSNBiredQUTATLLnfuFtV/W8s7sb0L3IYeQvNuY07VJy0W3uy/lHkh+NtD0GHnc8RVhL0A844GizKLVtIKrNEyUMi0MwsP2KkZ4n56RX7049LkmqIvYwc8AvYBnAxuyW/M+clkcl3svUGJm9FJ/ixtbRwWg9qjXF9AwaNAWegAEsujIkZKdCmt2miJ7h7b1jWWAIzn65ZdLX2xZoBEPY4l6w919Wl67H18asdaBIRY9CZMvRzXWpXkXTs2Ntnnq0g0FLEvAk7LOJNwLqyRLCKM8g7vtnmIQpCs6cEaGsR/mqpf2K/ENi8R3s8PoG/Gc9XHSV6jokegfZaFxS8Uzt1UVDdMibqrMmZ2eR533K9Y/O23aUyjhRoN9pl1vLIo1lhDPwmYUTT7MtRfeonHs4RJpyYzZUl7RevpVBxA6ejvdwszCZLlFjvls/PZsDgJvS/Xca/5VsVtP5C1N69L8melg7nEZmLzpi9sLMkXEDJajdqBLOfGrBPykbWE5Nlxq3iquMbseahz0/yFQi7+orky+wgl6yeoTKNCwg1dfWJXqBvX2ERjt3ipeYwnXauU5jO+v1TzPEXeMhld5Hy+Ftgenz19dmF4KnXoUFCDmswtJOdGbfMD+h/qhp9NDSl+8FIbjlI8B+uldNRlwJ11vfnheM6bVrXoWh6AM7qo2CryFCPsGWrPutFK6qsD6rlEIZNOMEOl5XOUUSRek5XV/cmtL0UKbCdvACyW9crSruX53udPK0OINqtG/X7SdU6dx2A2TEWVTJ6h60aCfMPYBCA5sQqz0HzCK
 IaZo19dJ
 mMBoy3SnxvKaIYMWb0rDTiMQwe3e0bF0ZqynGWXpjMZIZW7pUdC5IcAa/FVRDLW43u+uA/yo932dac7paE4dvU3KaeUX5ALrV0GBTvP4CsK+d2Rej2L+UtAJFtLaSSB0EsaZEqL/b3BFp7L7l1uynmptFoxcur7XzxVuVjRhnxTbIOdYfp1m3bpsj93LyN4z/CAfKHVnm2/jd0ewxhEmbqipju6to8kAOcyu4wGeJrqhpG6ldDJ1XfR6pn5c5qUo7VamuTYx78SUpMFNVD6NLJiA36P+Ppbyl8k0YB74pO731+2UZolfjzvkYoZ/ezVBYM9dQ5LQZDnmhplDK9y1++OSAOJv7v1o06NhVjxfDEeLnVDzp0cMVLJMnfM5hHPTqNrnXGX3A8xrkMfWD//bgOBz/IKDvH/rWZlDEWofDpKd3XZUL5GI86ygi3fPWHB6ryz1isRbKVS3AA9SIoamc2rxNo+FEGCo6N2dZQWVjCoIT55WTQnU9V0nfEDVaQHhVDetdINX1M1FlXJxw2E9drefbGaZhVsuJuR33GJZGuaA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 1 Sep 2025, Simon Schuster via B4 Relay wrote:

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

Acked-by: Paul Walmsley <pjw@kernel.org> # for RISC-V

Thanks!


- Paul

