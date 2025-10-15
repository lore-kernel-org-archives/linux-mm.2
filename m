Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB18BCCD192
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 14:28:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39AE28E0044; Wed, 15 Oct 2025 10:28:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34A628E000A; Wed, 15 Oct 2025 10:28:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 212AC8E0044; Wed, 15 Oct 2025 10:28:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 09CB88E000A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 10:28:45 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AD2F51DA050
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:28:44 +0000 (UTC)
X-FDA: 84000579768.05.D1BD1A2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 23E2914000C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:28:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Mk8kywQE;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of juri.lelli@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=juri.lelli@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760538522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jgeXfG5LCk279qOJi22HRVqctybfIOuy71nuUr9PHL0=;
	b=d24h9SMoooQNOy8OqgzRcPqoKeBR6gvGLobXZ9MD+PvFGthPsuQmMyhTpi1nKCh6C+iVda
	iiuemd2Sr8GEKTEriI4vMDLgHD5A6DXMV+mSmh7eHXWkc61q1+Pcmdnvg6FW6p4geiHwSV
	IZnaKIh9DBIfuQe0dZRE3VPd9y5TOsM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760538522; a=rsa-sha256;
	cv=none;
	b=glRsPGPdJSCyMGTpAhi8j6QtQUapSFYCzbBaaVvGChWTC16p3eX8/YQ+mqEDemDuMeErJR
	IsuBtkVAg2dZsceGQhP8GbXsWnkMRpjo7NTjmgy2up3zMUc6pM4oq9FsWzvqoV0zztkTP2
	kTj9uu7FSyVarWfy10S7l6FuikWoN2Q=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Mk8kywQE;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of juri.lelli@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=juri.lelli@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760538521;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jgeXfG5LCk279qOJi22HRVqctybfIOuy71nuUr9PHL0=;
	b=Mk8kywQE1BwA49/a/CYGqyLprUSx3HWYyCGag6vZTAFfPBNy9QYhztuUeIuXB62g/usua+
	o7qQGT1neejFp0IqLzBBeO//V5uVx6WmfDsEgRRZKKgToMM4fMRp4EyIsWXBvKqHJtA02g
	5xRj5Qr/VaRPA/MxAzRfxp9OwnNXV3A=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-373-ml0W7cjgN3OlNJtYKcKPYw-1; Wed, 15 Oct 2025 10:28:37 -0400
X-MC-Unique: ml0W7cjgN3OlNJtYKcKPYw-1
X-Mimecast-MFC-AGG-ID: ml0W7cjgN3OlNJtYKcKPYw_1760538517
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46e3a049abaso46585595e9.0
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:28:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760538516; x=1761143316;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jgeXfG5LCk279qOJi22HRVqctybfIOuy71nuUr9PHL0=;
        b=F+tIYfnP0VwDc2f0R+VXikLpDraGP2m6iQqVvkuCuNcjBS39qQjfIEsLZD+ns8+fBX
         nMmFNtGfktGvmpk42EnWiftav8lsnbuEs5slMMpH/C/OvwJSiMtMtNslu3iUxnOvZ+Vt
         KYgTG9Xyo3F9KnG18XsUbHl4e/xyDFU0zDzLOhumE5r3XI2hHHAMr7Rz7/QuSYapNAfD
         hk5ofxViE9uq/iNJNNtTGs7T16cbjmbbayEC6EWK9nhP3+skH+5qfSKE1tE+X/c79IIe
         4zc8JfiZgyOVr8PV5t2hBhxeXr4yPMiYRZmtoQJ/CDXWaus/6R3oFEULnhNTT0GrwSf1
         zpgQ==
X-Forwarded-Encrypted: i=1; AJvYcCU5HTiF54scY70XmI3Wl/kgeiZMHy0iYT6WqHcW7UwmxWtn4q13wbpm9WE9yHs9K4qCccrxfCeHyQ==@kvack.org
X-Gm-Message-State: AOJu0YwnevhdzwjpNY8PlgRSNsZUQV8y03itG4mTZn/H6VTOt7WIMwnP
	08EYXFaZs6CJje2OaCNO67OUf9aQN0Xr6qz4onodHqLyo9jY9F3hx+b2NJINkj01jaS1VUcGWfl
	lSyfhN+t//ZCvofzCfWJwZsi2TjjIB4yo5q3Pd606SRWe6uvDdjD+
X-Gm-Gg: ASbGncu7LW93sHMbKdlMyS/AhV4ZaTWFO2jK8BSLG0lQ1BF+8panuehftEoiRl5XR1+
	EM+96uFfBp70G3Ngvz1wJAcPa8GH8vbUTgizBKP4xNS2veTX/mvvBvfLtsS8KxjTQhx1kxQOb2U
	Qcu35/KcyUTk2meHRaXeZhvIU6Cd//D0bo3MZQAEns6zOOfxcXf2MYYnQ1rNgiFa+RGZUEXoeXY
	tn9L40ljxIIlpm3zGjVWeJHaTazRQhKxoRwM/JXD+EPHdq+ATS0ra6v9CJSYtNfB56xTOXe8kRc
	ll23mkTr8bonz11QVyBze2AzhjSjPOYNVmYjWAGzbiqnWZvKsQV7gfwrjMLen+Zksiug1dW6
X-Received: by 2002:a05:600d:4346:b0:471:9b5:6fd3 with SMTP id 5b1f17b1804b1-47109b57585mr1427225e9.0.1760538516616;
        Wed, 15 Oct 2025 07:28:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGzbrALSQ0Dm6MxbRBonwa/fKtFwvctLkCr56cdjw1iTmex8obFsv5mNCQ28ZCIBWNfB2voXw==
X-Received: by 2002:a05:600d:4346:b0:471:9b5:6fd3 with SMTP id 5b1f17b1804b1-47109b57585mr1426975e9.0.1760538516058;
        Wed, 15 Oct 2025 07:28:36 -0700 (PDT)
Received: from jlelli-thinkpadt14gen4.remote.csb ([176.206.13.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47101be0c5bsm48687275e9.1.2025.10.15.07.28.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 07:28:35 -0700 (PDT)
Date: Wed, 15 Oct 2025 16:28:32 +0200
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
Message-ID: <aO-vkAAk4FCdnLZu@jlelli-thinkpadt14gen4.remote.csb>
References: <20251010153839.151763-1-vschneid@redhat.com>
 <aO5I2WGtXqSPYFmH@jlelli-thinkpadt14gen4.remote.csb>
 <xhsmhzf9tld2r.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
 <xhsmhwm4wl2zm.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
MIME-Version: 1.0
In-Reply-To: <xhsmhwm4wl2zm.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: p_4bgIvPlgCE7q9Tj_bQcCw1lWWOP6Z_JgGINSr563M_1760538517
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: bm4fstywxxirnrobqqmr3ipxgqardxxq
X-Rspam-User: 
X-Rspamd-Queue-Id: 23E2914000C
X-HE-Tag: 1760538522-133090
X-HE-Meta: U2FsdGVkX18XgTn713k2QICkRxxooF4Geu2LleZzDVzKjZFjZeLblbUywkEVeTi+/nkdPGnfCFjeQrYVwwNT/P3i6wjA4+KqucRC8PvseZR0F0nePl/86XAnKWc31KQlYAp+futEqnOUerOf0sAhlvawVuKhodBmxfskYlATtk7q3pDaXFvWvJ87HvtSk681zHlKg4yHv81G24UOJPblET2huX5nz8pFbn3UixEKWkMmLGyAmd6UbAQCcJMUoD7JndCHykxmxCDwc0lExFFLEVRTDOqHEFr0ZDJbo5Oak2pBERkqnU1v2SkyerVuzZmQUkdaeWrFtQWHooC+YrWUf0J5B458WXSCTUoE31OO4i7m2W+RJZK1oycOYfbmu+EUfwDBd9TaIKrr9RyeTm7m703y4sP69tGJWkCizvyIFpQE3kOvEWsj4sRyJnpTh4BRZ/8AfnOa1W4Y92QQLZ7EcvlixH5zNaE9IGR2hW/UYbpw9VKRYXuBP0zYdZuMvHbL5rKklCbJkSuSI/VOt1/Lrxe4pclmhO6ioo62cWBGluAWpAlzSUOVoU9kCEHIlCQXxZJg648hgXdS86VsYCuE13DtdKV6VQLHMJihXOXy/zfIbHoPJdfPt6cOGfwqCjKwKs/ooxRUN8VmbwV2dxpXF8q8C8R61+2u4yWytIvK7HF5v4p1jW6lwPYXUh0hap3ox+Rm9z4ibgWJS/hGNzkHYvf4kmWJCFiJoiWAFoH2OHVGirI5z1ZXlLcSHPX48TY6Z94cHHMwW2MPvNTqGvP+J44sv4cQkQfum3nxp0qPz+ToiwoiK8gghhAyEOQwQjlHBv/uot2ILmyAsEIUQiQPvjKX/BjdQkXecb39IQyY/di5lDrwARK7V7Uw15uiiOy+PX45EGYh3reFQT8Xr0NFmgY6l7LgUc7PeWSNCwGIwqQ/lsZMoVCJXuDVZXs5ONjEIO3UOJhVo4oLK671MLz
 LYQrao/g
 13+pSHRH6brlq+aWtGB73DeT0yC+Rj6UdwGTAAQRZVnJ5xuFlxM6gPKTmJgb8ADaxnb3USdAYqWhn1nUCOyyRCo4a/1BepM2n0dx5YoIkySmcNr4eA9KC8ou/kQemwm9NRPu7wJMKdx8LIb7uwxGmGeaEA1IjeOpFYcZWuil/nA2cciRAyp5z3MAWQNuxePKGBRXyP32Px0BI4WHSEZsyzOvwjxMFIrzXoyyynwIMeSTygfyo/OPuGefqGKNV6v5onpaKY2o7dkEvQt8I+C3FkAsMDG3UgCmVEODUA0na53b0i039llHB2XzQuPlYkdqwwONQrrGsn/sgjhPadjqsFtsvTgetpZeqvbO0Dh4Xaba4zu3UvXzP9Boh7q+KRwP5sS0QwD0kRRlUgt63pkb/4R/yDVqr3H8GDYCueY5dHyNQErvgSQ/3lS6O56utWvMXMYjAb84Wg/eUd5xverlIHH7sogURQezMVqdQLz+fuS7DKdQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15/10/25 15:16, Valentin Schneider wrote:
> On 14/10/25 17:26, Valentin Schneider wrote:
> > On 14/10/25 14:58, Juri Lelli wrote:
> >>> Noise
> >>> +++++
> >>>
> >>> Xeon E5-2699 system with SMToff, NOHZ_FULL, isolated CPUs.
> >>> RHEL10 userspace.
> >>>
> >>> Workload is using rteval (kernel compilation + hackbench) on housekeeping CPUs
> >>> and a dummy stay-in-userspace loop on the isolated CPUs. The main invocation is:
> >>>
> >>> $ trace-cmd record -e "ipi_send_cpumask" -f "cpumask & CPUS{$ISOL_CPUS}" \
> >>>                 -e "ipi_send_cpu"     -f "cpu & CPUS{$ISOL_CPUS}" \
> >>>                 rteval --onlyload --loads-cpulist=$HK_CPUS \
> >>>                 --hackbench-runlowmem=True --duration=$DURATION
> >>>
> >>> This only records IPIs sent to isolated CPUs, so any event there is interference
> >>> (with a bit of fuzz at the start/end of the workload when spawning the
> >>> processes). All tests were done with a duration of 6 hours.
> >>>
> >>> v6.17
> >>> o ~5400 IPIs received, so about ~200 interfering IPI per isolated CPU
> >>> o About one interfering IPI just shy of every 2 minutes
> >>>
> >>> v6.17 + patches
> >>> o Zilch!
> >>
> >> Nice. :)
> >>
> >> About performance, can we assume housekeeping CPUs are not affected by
> >> the change (they don't seem to use the trick anyway) or do we want/need
> >> to collect some numbers on them as well just in case (maybe more
> >> throughput oriented)?
> >>
> >
> > So for the text_poke IPI yes, because this is all done through
> > context_tracking which doesn't imply housekeeping CPUs.
> >
> > For the TLB flush faff the HK CPUs get two extra writes per kernel entry
> > cycle (one at entry and one at exit, for that stupid signal) which I expect
> > to be noticeable but small-ish. I can definitely go and measure that.
> >
> 
> On that same Xeon E5-2699 system with the same tuning, the average time
> taken for 300M gettid syscalls on housekeeping CPUs is
>   v6.17:          698.64ns ± 2.35ns
>   v6.17 + series: 702.60ns ± 3.43ns
> 
> So noticeable (~.6% worse) but not horrible?

Yeah, seems reasonable.

Thanks for collecting numbers!


