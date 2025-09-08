Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA93CCA1013
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 05:21:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A3908E0005; Mon,  8 Sep 2025 01:21:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 254838E0001; Mon,  8 Sep 2025 01:21:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 143558E0005; Mon,  8 Sep 2025 01:21:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 01A1C8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 01:21:05 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A1E3216099D
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 05:21:05 +0000 (UTC)
X-FDA: 83864934090.06.D34A638
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf23.hostedemail.com (Postfix) with ESMTP id BD20B14000F
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 05:21:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EQkxRxhS;
	spf=pass (imf23.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757308863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Z309ZEqczozAMKKKB/xzAoGf/4FE4TavsEKgcsqpes=;
	b=KUF6772DKFV930NY5aEBmu//i9tVtU0SPsa9C4r312oXQWAvS5g14Wddzk3r0tpJXyvfri
	gjBGNwVMTTiQFp/5QS1Wouabx/I2TU9aWwGjwj9JzcpXU/IIOhQYF7jIzBwidP/ksxtiwQ
	Gj8fhWoLGNZS4cn+G0n9tk2P0zeUcLM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757308863; a=rsa-sha256;
	cv=none;
	b=U8LSHnezMWj1FXaTWoBiERSb2t9NOpkiSFyOeXGOZqPC5iu1/dYleEHj/BGvnmRYu6mu10
	J9O7Vh5t4jj6/K1pm1FxPner/T3uazA/UXpyaPaFja/UjKUerRtZpZ97uRkuryIk/BrzTb
	mkYAkCVMPv1QM/grB0pZKM8alrxVH5Q=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EQkxRxhS;
	spf=pass (imf23.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3280264a6e8so3033269a91.3
        for <linux-mm@kvack.org>; Sun, 07 Sep 2025 22:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757308862; x=1757913662; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6Z309ZEqczozAMKKKB/xzAoGf/4FE4TavsEKgcsqpes=;
        b=EQkxRxhSGChfnsu0Dp1izldo4HHCZuyv+tftVDkbIvWm9fc1l4gLiSlSI6A4gGF2JK
         Wy0GvkAzU66xIgmQWu7an2n6Zk5Eg8PlERQrKzzL87vBzappOVjaGre3+D8hvmEf0y9Y
         Z/feeZFt6+FiHTCFkg3pDhdu8AbOacr3hDoj3RO48XX9R6pFGIIR8SnMcftA3iLHhBmw
         2YALz1mC5s/i8D8tsPuzUx2095rDEmF3MHigEY90PBJmAPDF9HJTGvRXsK1P/9OYGcgT
         3lbejRVJgWJ26IWVJGBjgX7Ln8AQbdFbDztiCJ1zBSplmB3VV3QlNRnDttiZpNQLQ3CD
         iOYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757308862; x=1757913662;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6Z309ZEqczozAMKKKB/xzAoGf/4FE4TavsEKgcsqpes=;
        b=aztF0+n6SPX59pJePDQ3Ap9486z96iukeenZXwsZ4J6CH3n3KfsXZAL81kZOrHEr7u
         D5CKf4qr9tGOKHOzLM8PZLUaq0LncUkG0M/7wQp47FfLjMw5cKEZ02AU6xzXDazqO/N5
         4soLIJF2T7lmA2pcehM3UwYtzh4j+5FXiNRjlg/7zvjsQ2Ytke1s/VXiGkl8u5hNd7GC
         0SCyR7U+RI2+EQn0g4w9mDHHGHXVbYY7N4MzqtvTdTMRti2vofp4gt8JMjYhC0qYUAWG
         /N7fuy1pJqVZ9zlgmwYPYK1tbkLldIafHw0mzwO14n1inIDVlpY2JjOovQ46VLT2RxD8
         /syg==
X-Forwarded-Encrypted: i=1; AJvYcCXICX91x6k7IkbUFIxg6/DxoEy0MQ1mK6hdJZs41xgcE8p/segl1SEeWzBXLo/oFVNrOefdn6mFXg==@kvack.org
X-Gm-Message-State: AOJu0YzzbaXF6ZeQMEQC9E0iFAssSuPlhhzA+z71zh98t3LN4jpLjv1e
	ne4eXt+dVmYhTPjI+c6xM4Lo2L/Pda4H2bHW4pqfc2HUOCHH36VZhWx3
X-Gm-Gg: ASbGncuRlVxoaFngTJHMCZEN7ZE4FODPlCz+CsJE8h/ywyGZWRX0IOuP0k6I7g7vrSS
	NXXepzFOIKplPSATeJpxzo1qrjMG7oPXPeTs/9Bd4FKDDQHOLob5VcJL9MQ/kReiosb0aVvYAE7
	hacwJJKqoATCzamHXzA5BydcRXkyz9cCs4NP5UKDTRlaoXuQYq9FB/NZysHLbgPUn6EeWPoUix3
	DJvbgJ/h5EKCP1o9G4bUwto+o7Xjxf/TkEEBPZCHNnswjdkbUWpFQ/Am5Rqavo7QrpKawwDybCz
	Mt0r4c2d8zKLSRqhrhD/ORi2fdEERQGc0MbC0vMx6Iloh9ttETPnJdvsonTAh7thYo6tPBPizha
	K6vfefHYm3b7xWRbnhtBrkZJlGBfyzJ7Z8PJRQ7VaUeLJ
X-Google-Smtp-Source: AGHT+IGPcXqmogWZILkA0EiWDB3UUSk4oq5HV5nWmW/FIF6iyzxQCslm6c7L4gk90ECEmg86Ndwr/A==
X-Received: by 2002:a17:90b:4ac9:b0:32b:dfd5:3527 with SMTP id 98e67ed59e1d1-32d43f2e436mr8617642a91.9.1757308862448;
        Sun, 07 Sep 2025 22:21:02 -0700 (PDT)
Received: from localhost ([45.8.220.62])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b4fb15f50d6sm11758299a12.0.2025.09.07.22.21.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Sep 2025 22:21:01 -0700 (PDT)
Date: Mon, 8 Sep 2025 13:20:51 +0800
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Liang, Kan" <kan.liang@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-perf-users@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 05/18] x86/hw_breakpoint: introduce
 arch_reinstall_hw_breakpoint() for atomic context
Message-ID: <aL5ns7h1NaoD9LPg@mdev>
References: <20250904002126.1514566-1-wangjinchao600@gmail.com>
 <20250904002126.1514566-6-wangjinchao600@gmail.com>
 <20250904063832.GT4067720@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904063832.GT4067720@noisy.programming.kicks-ass.net>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BD20B14000F
X-Stat-Signature: e8nyyg9tw7xhx5x51mrpep5g1m6n1n16
X-Rspam-User: 
X-HE-Tag: 1757308863-526105
X-HE-Meta: U2FsdGVkX18O4bSs2/brhKaQAQTOlQZd1b9DQ3p/b/YbhtKXp5pbt2NCpaO3e7yGZkyH+DNXtG8rgAbUOkYpz1osEkUHPagr4i6GbGs67+BR6g7wRI8z++9NWLEPxz8F3qUfmLx5dgY5RdV25e0eWof3fqClCv7jcc3acb3Ai1R5gU7dgx8Yl+IefSyReyK8Ldbu7aZsq2FqNCqoCSmowWRolEIW8/8XZBtjIo2D5CjTysRElShJLKFPAbViYe/d7yPipeH43N/P8dfBzbuUURPM1BCZ3yfjvYddWeiw0y7AXZK5llZYPGQ7Z3BQVksWGWjxGW5gCCwzj2kUFbpzlYZFT2Pgu1FlZ2R2PUNbiSjdJwUaNR0JWnt+l2gKuy8ilN41YdaQphRWpmf3CEeyNukc1BM3dhcxujGMxYLW/np/U4f0pkSsCEgFfvj/m9RtcHsb9dMSUsEkDBcqNwnFEXcixW988EL6pW6YR2qYYluq/ZXxUbnet7IdBs45ZkCqmE5fY4gKz4t66xyfsohaijzcZTpePIvQLSIm2Kg1zhyotUbrhzF4bE1Ep+ifTfo/wocmLUpLbPNuB7UEfwdQCnQXzg3580bfVG+w8GjF9ssi5UtpSNOrr0NK/jo0HZkN2rmC79u7qUSV4ORxIhr5DKCmJypwLmRjfA6dTGuSI4OmRMFExlHUvXcZREh0A8Q4nz6IScUwS2TqOGo7iO9n/S5mbIhRkAvf8+h4R6Di2yZkGOLjVWnfqrIEopFQvjEw+N6SE7EJa4jVMRdqJaFs5eUQTF3BhYEg4dwXiZ6S0PfzRQUlxnND7v3WuCb0HdluD0E2s7tEW0Qr+4UPP1RRMEHj1ydKSRW9NCOSFHrRfJC5GUFyMEYnewt6CLg8VhEoxBPN3XbsQCs+kuqoIy2jBB05tbRnbQCnHuxXSjF3p5uAkoxpQm/Iux7wDbxttdD1B6JyTBPNY1obkyNdqBT
 7yHl5hlq
 Lcl2DhNLmoqFliktGjJvZNhu2tIPNEnH4PdLd2G+C4tDtaGj72plLmlyoEmvyueHOvbLUAOVh/vziDMxUZM3q81Bxqb+/IFRBeCrrQW874EPFFwLJIKETcyvCGkHGTHF+ovcWhRZHJHe3aX59ywdVwTb2+hAzsW4VGNeek1S8iVDxbKBfMp30tZkh++lD5F2caXvhxPfyF0ISa4hRs1NWonUdWc1GpwVS6K1OHemaSrCf47zMyBB/AvQERaER3Q9HLIpaKSUtqtcZIt28auPkF51yzvrxVaVZRwoXR5HGP3yRgJ17jpMEUS+mvLhUf6S+sEtdLDOqEBYOHlA2k0tFu4v9nntDOtg1CCUQHmQgnGgiPMzjjKAmcOkuidTexWQTJdQlj1HKZOl9YhelKMwQaC5XHwHSmTu2qnTiPPJZEVySRJSoVMkykFj0c0rTyFfy1VT4wTgSyEqRUjMAcAk873Q7PKonJ3Uu4/zr6KN/Yha7voe5dUWmTCeLr1bIWazFWMZiuo4tEYxa4x/dvu6xxSQ4ga4q/RL+NC7vcnvwePl0ZhpCHV7VIJIVNChIBeB+3T0K
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04, 2025 at 08:38:32AM +0200, Peter Zijlstra wrote:
> On Thu, Sep 04, 2025 at 08:21:02AM +0800, Jinchao Wang wrote:
> > Introduce arch_reinstall_hw_breakpoint() to update hardware breakpoint
> > parameters (address, length, type) without freeing and reallocating the
> > debug register slot.
> > 
> > This allows atomic updates in contexts where memory allocation is not
> > permitted, such as kprobe handlers.
> > 
> > Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
> > ---
> >  arch/x86/include/asm/hw_breakpoint.h |  1 +
> >  arch/x86/kernel/hw_breakpoint.c      | 50 ++++++++++++++++++++++++++++
> >  2 files changed, 51 insertions(+)
> > 
> > diff --git a/arch/x86/include/asm/hw_breakpoint.h b/arch/x86/include/asm/hw_breakpoint.h
> > index 0bc931cd0698..bb7c70ad22fe 100644
> > --- a/arch/x86/include/asm/hw_breakpoint.h
> > +++ b/arch/x86/include/asm/hw_breakpoint.h
> > @@ -59,6 +59,7 @@ extern int hw_breakpoint_exceptions_notify(struct notifier_block *unused,
> >  
> >  
> >  int arch_install_hw_breakpoint(struct perf_event *bp);
> > +int arch_reinstall_hw_breakpoint(struct perf_event *bp);
> >  void arch_uninstall_hw_breakpoint(struct perf_event *bp);
> >  void hw_breakpoint_pmu_read(struct perf_event *bp);
> >  void hw_breakpoint_pmu_unthrottle(struct perf_event *bp);
> > diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
> > index b01644c949b2..89135229ed21 100644
> > --- a/arch/x86/kernel/hw_breakpoint.c
> > +++ b/arch/x86/kernel/hw_breakpoint.c
> > @@ -132,6 +132,56 @@ int arch_install_hw_breakpoint(struct perf_event *bp)
> >  	return 0;
> >  }
> >  
> > +/*
> > + * Reinstall a hardware breakpoint on the current CPU.
> > + *
> > + * This function is used to re-establish a perf counter hardware breakpoint.
> > + * It finds the debug address register slot previously allocated for the
> > + * breakpoint and re-enables it by writing the address to the debug register
> > + * and setting the corresponding bits in the debug control register (DR7).
> > + *
> > + * It is expected that the breakpoint's event context lock is already held
> > + * and interrupts are disabled, ensuring atomicity and safety from other
> > + * event handlers.
> > + */
> > +int arch_reinstall_hw_breakpoint(struct perf_event *bp)
> > +{
> > +	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
> > +	unsigned long *dr7;
> > +	int i;
> > +
> > +	lockdep_assert_irqs_disabled();
> > +
> > +	for (i = 0; i < HBP_NUM; i++) {
> > +		struct perf_event **slot = this_cpu_ptr(&bp_per_reg[i]);
> > +
> > +		if (*slot == bp)
> > +			break;
> > +	}
> > +
> > +	if (WARN_ONCE(i == HBP_NUM, "Can't find a matching breakpoint slot"))
> > +		return -EINVAL;
> > +
> > +	set_debugreg(info->address, i);
> > +	__this_cpu_write(cpu_debugreg[i], info->address);
> > +
> > +	dr7 = this_cpu_ptr(&cpu_dr7);
> > +	*dr7 |= encode_dr7(i, info->len, info->type);
> > +
> > +	/*
> > +	 * Ensure we first write cpu_dr7 before we set the DR7 register.
> > +	 * This ensures an NMI never see cpu_dr7 0 when DR7 is not.
> > +	 */
> > +	barrier();
> > +
> > +	set_debugreg(*dr7, 7);
> > +	if (info->mask)
> > +		amd_set_dr_addr_mask(info->mask, i);
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(arch_reinstall_hw_breakpoint);
> 
> Yeah, I think not. For one this is an almost verbatim copy of
> arch_install_hw_breakpoint() with zero re-use. Surely you've been taught
> better?
I introduced this to modify bp_addr in atomic context in my RFC series.
I thought it was clearer to split the introduction and refactor.
And then It was used in the wprobe series, so I left it as introduced
in the RFC series.

I agree your suggestion is right. I am willing to refactor after wprobe.

> 
> And why would we want to export guts like this?
I wanted to introduce a real-time stack corruption debugging tool,
which needs a helper to change bp_addr in atomic context (kprobe handler).
And wprobe needs it also.

