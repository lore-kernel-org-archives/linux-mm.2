Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A507ACCD18D
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 12:58:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4C178E010C; Tue, 14 Oct 2025 08:58:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E240F8E000D; Tue, 14 Oct 2025 08:58:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D39948E010C; Tue, 14 Oct 2025 08:58:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C05BF8E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:58:11 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 743691A08D5
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:58:11 +0000 (UTC)
X-FDA: 83996722782.28.4BC00FD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4A02640009
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:58:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=F25wjcbo;
	spf=pass (imf27.hostedemail.com: domain of juri.lelli@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=juri.lelli@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760446689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o+P2Dsj3XLhA6fMrQYgh8OLSwYB2MUOQP3SbJkXqJVA=;
	b=TLmQ7cwiyNsxBCxSK7gULzpmUzocNVF+PqLlptT2OgkHH2tzFtojls///AOtHLJSKj30kN
	QS8/cnDJaBkenJVBl+Sh8ZRdUjnjQaMFTjVe+u4p3uuqiHBr3u2UloaXBQEVDEeVfkluuB
	kcHc1CcWbh1cbb3JJbMla0opTbO0feQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=F25wjcbo;
	spf=pass (imf27.hostedemail.com: domain of juri.lelli@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=juri.lelli@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760446689; a=rsa-sha256;
	cv=none;
	b=mH9nUTXoLllRVIQtTFvo92/6RD3+1suWuAELZlc9pobfleGKSsYmhWgB9bBQ6d3fDZiyZO
	oBVEIedy6lNO9N0xz9daabCtPxGupoaC2gzFk7atbMDvdm97DAgo/dPFeqRz1GtHdJXCd9
	hbolpmMYSTOwWWDOu4nsg9RHpjEFzUo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760446688;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o+P2Dsj3XLhA6fMrQYgh8OLSwYB2MUOQP3SbJkXqJVA=;
	b=F25wjcbomtI84IuH63y3uCwMe59HV5IiwauKpiD0sHsUdXIpr1gs8FLbLTlt7g7NNTucDn
	pxXrgcizjcEAVg5AzEb65bkVPcHPq0tEww1Mu2shf//a/rTUEZQSXBZS3zxgeS0OdkZFag
	2sqexAC7GHWcCfQQUcgenQ5DS7xbtiM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-211-GL8oorJ2MZatP693vEaVIw-1; Tue, 14 Oct 2025 08:58:07 -0400
X-MC-Unique: GL8oorJ2MZatP693vEaVIw-1
X-Mimecast-MFC-AGG-ID: GL8oorJ2MZatP693vEaVIw_1760446686
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-426d314d0deso2275266f8f.1
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 05:58:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760446686; x=1761051486;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o+P2Dsj3XLhA6fMrQYgh8OLSwYB2MUOQP3SbJkXqJVA=;
        b=dGVjLHKxZ0tQ3rnaFNnQ/VtJhHt1F2fTxTXfgCJtijLMbpnT/rlTnaptfQ0NsVFJkv
         3CSQSJ+/N4N0wcelmvItbHVHK3CBILRusxRcu91RY2AW+9Yx7UhnX8AwJodperzr+w9B
         pqiYtSy52jTIzx3jUEZRug2gr+D/uz5O6TJrzo7UyB+1sY186QXO0mezU5uLSCkp/Zww
         MCp+NxQ5Rm8k81sHgP4gHHY6PK5n1z9d366hZ7vb8BYcoi+8oQ/rYySCJCPXD36wfv9q
         Mk5ZG6HcICJyDr6vvEJbDazUaIYm8TDgTni3cOKJWRs51iv0auH5ZseXs29icHh4XlSG
         JtOQ==
X-Forwarded-Encrypted: i=1; AJvYcCVhlGlNGeN/MD+hlA6vE7Os4sNlnT4GDBBIo8nyFQP4jufmt89prl9aVVmoUI3VckyGkCchIDBUjg==@kvack.org
X-Gm-Message-State: AOJu0Ywu4J4dA7dOWOKui9EasGJL9xcr4yFiaXQLBAHDLICfsvFgsJU4
	/bzofZaLjygaQgDYSCqHIyDhQgjg6oFd5/kTMnGAp/1qOKQfkg0v/9NV12WqYmkIrRSZok827ov
	aMbBWEfTiow/ad8ZNS9ztjofEFwgwt3wk8ROd/PF9+ldKlvymFeAq
X-Gm-Gg: ASbGncu6HrNYf0nCitWSzNyMRYuAIStCvKCPQ4JEIy9NKV1XTzi0HzYKhFoDqbE1WVm
	FcHXc7/MXFbUaUoIuBGO+uSIkQd1OsnW1YQQ18gQ3DDkbariawB54gU3aZYktx9eM+CdC0j0ztG
	ZsUU8v/3aeHD7niHMpvblEkh2owlaoFdRbRLLqV9kFJqEz7Wrv/MdM80mkA0qaCR1hM5IDUN/TZ
	JpoWK17A7AIY3S0m8OIlnWihD92Ks7Lehsfo1kcxHJaeNVspUmlTot19MiQsQ9je6mrncsvDLvX
	nZKk34jsSfOQ9hiAN3t/bj+tjkfZvN8eNmm6AR52h+vRG7eQazGyLFwePSBBJqXTPlUei6gU
X-Received: by 2002:a05:6000:1888:b0:401:c52f:62de with SMTP id ffacd0b85a97d-42666ac39fdmr14487418f8f.12.1760446686066;
        Tue, 14 Oct 2025 05:58:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHAh3YZ5oKpPdr7WASiDkPJn2IILu8/Rh+37A13TS4n2FwBRRVC0ByNWYf0Uu33Aqxt+5Ldeg==
X-Received: by 2002:a05:6000:1888:b0:401:c52f:62de with SMTP id ffacd0b85a97d-42666ac39fdmr14487377f8f.12.1760446685024;
        Tue, 14 Oct 2025 05:58:05 -0700 (PDT)
Received: from jlelli-thinkpadt14gen4.remote.csb ([176.206.13.103])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce582abcsm23624651f8f.17.2025.10.14.05.58.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 05:58:04 -0700 (PDT)
Date: Tue, 14 Oct 2025 14:58:01 +0200
From: Juri Lelli <juri.lelli@redhat.com>
To: Valentin Schneider <vschneid@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, rcu@vger.kernel.org,
	x86@kernel.org, linux-arm-kernel@lists.infradead.org,
	loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
	linux-arch@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Jason Baron <jbaron@akamai.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mel Gorman <mgorman@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Han Shen <shenhan@google.com>, Rik van Riel <riel@surriel.com>,
	Jann Horn <jannh@google.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Clark Williams <williams@redhat.com>,
	Yair Podemsky <ypodemsk@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel Wagner <dwagner@suse.de>, Petr Tesarik <ptesarik@suse.com>
Subject: Re: [PATCH v6 00/29] context_tracking,x86: Defer some IPIs until a
 user->kernel transition
Message-ID: <aO5I2WGtXqSPYFmH@jlelli-thinkpadt14gen4.remote.csb>
References: <20251010153839.151763-1-vschneid@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20251010153839.151763-1-vschneid@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: O-uya2Fy_gtKx0Susb3R94sS7IPFjv2cRbn-XWO2IfE_1760446686
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4A02640009
X-Stat-Signature: 6karitjyhnf7n6r7iamepo6shxmw1duy
X-Rspam-User: 
X-HE-Tag: 1760446689-951205
X-HE-Meta: U2FsdGVkX18XgNXtRtDiFiX7kehpg+DmnS8dbKjIQyfhuwZys+nk88D3fFGl1MKe5fesyKMc7KQLgLGWB+IQmrBx/VQN5PW0I7A/Fjjrr90ZkreK0nchWUC8VJxYqXF0ndG0Ky46D8H7ATiF2A7YIF8bevszgIhxTNKVHqdarIjgwUvS+wcKCinidn2f8gOf5epEVjhLAmRmePUxtoWMetQlqMrbIGL3qLxTu5RyGDOIptxSDYpjWazOZmQWSxpfNfSlq2ulIF9xW3UkpxNlqT4VpumY7eMs86ykeCgg976QRKIeYw3DBDJWnA5DlSPr4zIY4QgnRYsnwREF3vZyCw7iqR9LmJTl/5vQXCMl5jFEVK1ibQJ2KAQeXWdnpBzd5+3To89G4LKr+tyilUYpxrNq06a4A1bfRMTEopGRV7rDjji5ss1kDs4FNdu5lCnUHwdAIJZDvCcuuqAQe8hzQCMZiPW+uOKWWYhzReanyBlQ32ogolu7XwFSx4y1L7mk4APdF73slZF8F3qpDvUUMzwftIMjfT8OUZe2+/zj2jQxqa3KQ4O5YMOlm15nGR8XYngDukl19Q+TslEj8Rq5/6MzPgOxMOwS4cfKhc/mS9ehQ+4dV4KCDobFsIuN0OVhAHjSWsp7Q3ysq88AVbzfj9CSqn4w8G+Lt698Y7NBnbT+L8ewbIikTZhJrHZ6HmTOgyHABzctT8noF3hg3YANSM23zGECdCpewmsZw0ltdDl/c/0SxaPQ5SoWKP7bxGs84pt1QKBWbebZpOEsUNTLy16OV70Sw+RBMUT79R0anM9spkhNOB4PyVLMlsJXSHUgLRkqVvstZ78ypYziydudRR0I8NiwUCYPd9n80joMLv/6y4BPLLVYPmg0/GaPPzWUaKUC6S7khC8saZM1EbPORCoh4Rdjtdig2QOuOvURkMWuZSiMZMRHca30D71u8wD6MeYdvRO7H79XKV5Ff3X
 EmhNRgiP
 94ZhuDsRdhbYTtldW8OhZArTAa5XB8hzdbonF8P+vuTEdfjQFkZNGjoUy5oZ4IiooPAE3ehH4OiitpdH0K0SAYZLcHwaVrV5cEsMC1wiRMsi4/3unlnbGWJmbUVPRbcVzE6xXAOsZl2zCb8Kn13E+007bbJHb9F6fzqycbbSc+s9b9mlygHUy2hxdlZIov+bpQsVb5y6iA8pYv/Bgq5kjhBdgsovoSQ31ygDIUK0cJ9J3NwkgtRaiLvCN0k6qV22AwKfgIT949scpUBOSrYwOvjLuBU6pV+u+j3kl6ajwjZG4FPNlpxkc+VISG7qem9VCQHiU8562WUy+CF/UssY3qhryw3uSHkWHJJxwwNWzyay/xm9204lgpvppvSx2mGBjMUOZO77PJOWAFMvMO3Rnc/Ets20kljkJa/kxJr/7K7IYmFPuAS7hlTeUveOYZakoSofRiB3uEyw5aC1EBTxGzNPyyFX33njQazUXcGfMmcrBESC/iEdRomvD1zsqc8tVvMeJaF0di58uvUkpSQ3fFlaoLxz6cX6EwCswNjEhEGmcdjLlHkPX83MI1RQQYrERazMOJa4Hg+CNYHs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On 10/10/25 17:38, Valentin Schneider wrote:

...

> Performance
> +++++++++++
> 
> Tested by measuring the duration of 10M `syscall(SYS_getpid)` calls on
> NOHZ_FULL CPUs, with rteval (hackbench + kernel compilation) running on the
> housekeeping CPUs:
> 
> o Xeon E5-2699:   base avg 770ns,  patched avg 1340ns (74% increase)
> o Xeon E7-8890:   base avg 1040ns, patched avg 1320ns (27% increase)
> o Xeon Gold 6248: base avg 270ns,  patched avg 273ns  (.1% increase)
> 
> I don't get that last one, I did spend a ridiculous amount of time making sure
> the flush was being executed, and AFAICT yes, it was. What I take out of this is
> that it can be a pretty massive increase in the entry overhead (for NOHZ_FULL
> CPUs), and that's something I want to hear thoughts on
> 
> Noise
> +++++
> 
> Xeon E5-2699 system with SMToff, NOHZ_FULL, isolated CPUs.
> RHEL10 userspace.
> 
> Workload is using rteval (kernel compilation + hackbench) on housekeeping CPUs
> and a dummy stay-in-userspace loop on the isolated CPUs. The main invocation is:
> 
> $ trace-cmd record -e "ipi_send_cpumask" -f "cpumask & CPUS{$ISOL_CPUS}" \
> 	           -e "ipi_send_cpu"     -f "cpu & CPUS{$ISOL_CPUS}" \
> 		   rteval --onlyload --loads-cpulist=$HK_CPUS \
> 		   --hackbench-runlowmem=True --duration=$DURATION
> 
> This only records IPIs sent to isolated CPUs, so any event there is interference
> (with a bit of fuzz at the start/end of the workload when spawning the
> processes). All tests were done with a duration of 6 hours.
> 
> v6.17
> o ~5400 IPIs received, so about ~200 interfering IPI per isolated CPU
> o About one interfering IPI just shy of every 2 minutes
> 
> v6.17 + patches
> o Zilch!

Nice. :)

About performance, can we assume housekeeping CPUs are not affected by
the change (they don't seem to use the trick anyway) or do we want/need
to collect some numbers on them as well just in case (maybe more
throughput oriented)?

Thanks,
Juri


