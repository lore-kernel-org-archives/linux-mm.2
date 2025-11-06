Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 315E8CCFA03
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 10:02:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92F7C8E000A; Thu,  6 Nov 2025 05:02:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 907868E0002; Thu,  6 Nov 2025 05:02:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81DC98E000A; Thu,  6 Nov 2025 05:02:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 706408E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 05:02:43 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F17DFC065F
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 10:02:42 +0000 (UTC)
X-FDA: 84079742964.16.0336740
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8B8874001A
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 10:02:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CMYqbBsj;
	spf=pass (imf12.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762423360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MVdSTjzPPKZ2l7IW0u0zSr5SxYY9yMb26AdkoDhOwNg=;
	b=DyNzte2TO1YAO355yTYnDYX/9X7B2OVnGO8aCSRfG/rYkwvCiRUHe/GgjTpkow4k7pRioF
	cyCbavUfqethQGNxnrkPIC0kAc3wiRPf0hoaVDcpUILDZblbEYEgtnccpTnzTbiVBarvA4
	4ewtW1U68NMkObF1Wtf/+3tj9tfC/MU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762423360; a=rsa-sha256;
	cv=none;
	b=wXqI3Iu40ISSUr76A2/CRiM0ei7Z5W03geM1gsiplHyKJgOAG5D9ByThiFOplF/PKeCb0Z
	iU8YqsrVhfBrXnasP5YxGxMeW0HzKqbTwLOklTRU9IZRabDIMCJ536gLDZk+mLg6LiGZ25
	DLHtvea5ul5x9obzzsfKFC9JXxOvzcU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CMYqbBsj;
	spf=pass (imf12.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762423359;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MVdSTjzPPKZ2l7IW0u0zSr5SxYY9yMb26AdkoDhOwNg=;
	b=CMYqbBsjNkomkR72XZPvcFlZL/71qwiKhMykVHEXh0NQYzBMWXxJOZJhuIwx3LeklxZ1es
	AQ/TwTtd6UX0xWuxXCliREa40K1QwIMAfPBissOQdcfCnkL4gv1OcFIEKOXOP+l6WLwLs3
	xnXvl+7eZ6+hc6zNjDIajro72eBsj3Y=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-189-zOk351OEN-SDl5qlaQfrzw-1; Thu, 06 Nov 2025 05:02:38 -0500
X-MC-Unique: zOk351OEN-SDl5qlaQfrzw-1
X-Mimecast-MFC-AGG-ID: zOk351OEN-SDl5qlaQfrzw_1762423357
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-429c8d07874so421993f8f.3
        for <linux-mm@kvack.org>; Thu, 06 Nov 2025 02:02:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762423357; x=1763028157;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tvrt5C8X1gp1kp6b+KY8cbLTeVcvbbT6G6kNQJkblK8=;
        b=AmIIByJbpOd64Mq2OUIG+X4sInNFZVoDh3EjskEr4JLT8DHCLHoFKhoYVqD2f1UEye
         phTp3vA2g2U/uvYlzrDsEpYhBGNqaQ/MoubtmoY3TOgmpeDUWPjlWx7IeGowmtj7tt9V
         ra+yt6hHSvMvBJvN710qVEh5FpwXt6+dLy5F7FkpE6ZZwmzwxe4YJiq2C6h/qoGskdno
         QEkTCbOJcozonYXyaJ20ujJZgBs/nowKs2/zdsX1tzvFf9JCNiNL+KT2wpv7ssYOYva0
         H4H1oCbj9x7SVIyD56U0JWeRPJSzSKJlhz7OjQb/IS4d9fkymg4UqWL/HAL7PRLpbaPN
         fa/g==
X-Forwarded-Encrypted: i=1; AJvYcCVBC/FTPGk1W9VQ17j1V0T9HPjtch5LIceKflwd+y39hirB8iojDm6x5sFwh/f9aSEkeEraOkgT7g==@kvack.org
X-Gm-Message-State: AOJu0YzjPPkIkmK9AR+dbqE1tAvIIlFfRS4hK7YqB8+hj4zWtfe52RiZ
	lPrpe9nEY5SPnNlO80Hh2HXdiia4PeHcXW/nB1KySMcnUZV7mk6ZH4Qa5KB8ykUsmrmSoPjLoJP
	IHAmL3E02zcg99v0rEPyO5550VirDyOdHVbZyaNdpVApHKkLAxrbc
X-Gm-Gg: ASbGnctFTBi9jvJMoSqWfLntCwO/okDv043XH2Hds1XUVnGbkcqwKehftt5UaVFeyDI
	bIog8clqXwXrBkBO+Jv/5DH5dGs++DzMtsJAU52SczYh9zDRSPSE2/VBsaNYyaU7JctjjPmyA9D
	PV9xawONvzR+QzjxNYDfGmQ4Ztay6Oc7g3G9tPDc9d/lPhi9LoQdB4UVodfdbhGf0ami0GM6Ax0
	4LwYEzQYqQ4SgiBWm15DVpJtwuZt3JXxeFFqDK+0xOyyBVjrC7GCK3Xw5TZPd/4lut1C05WW/PA
	UhLqbtVlW5d6l7ebeI1r2Hp5q/8TtYSkdXbdjt6LmbTw7x92FzUezRKGDqbn/P63HMqTolphRe+
	3H54L0KYMd+5a3jDMvMPzBLp1uuuQGBgZklBZvxFn7HpB393BDxuFdxdc9yzE
X-Received: by 2002:a05:6000:2007:b0:429:bd09:e7ce with SMTP id ffacd0b85a97d-429e32e3751mr5572194f8f.18.1762423357274;
        Thu, 06 Nov 2025 02:02:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFFeAmOLmzeYzGPgujTP1e064ll50Q3Ih/Pj2s9y519WV4ZUw6Tz0GJFNvPvZOTYQG+myOLaw==
X-Received: by 2002:a05:6000:2007:b0:429:bd09:e7ce with SMTP id ffacd0b85a97d-429e32e3751mr5572131f8f.18.1762423356748;
        Thu, 06 Nov 2025 02:02:36 -0800 (PST)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (213-44-135-146.abo.bbox.fr. [213.44.135.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429eb477203sm4112751f8f.29.2025.11.06.02.02.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 02:02:36 -0800 (PST)
From: Valentin Schneider <vschneid@redhat.com>
To: Frederic Weisbecker <frederic@kernel.org>
Cc: Phil Auld <pauld@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, rcu@vger.kernel.org, x86@kernel.org,
 linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
 linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave
 Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Arnaldo Carvalho de Melo <acme@kernel.org>, Josh Poimboeuf
 <jpoimboe@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Arnd Bergmann
 <arnd@arndb.de>, "Paul E. McKenney" <paulmck@kernel.org>, Jason Baron
 <jbaron@akamai.com>, Steven Rostedt <rostedt@goodmis.org>, Ard Biesheuvel
 <ardb@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, "David S.
 Miller" <davem@davemloft.net>, Neeraj Upadhyay
 <neeraj.upadhyay@kernel.org>, Joel Fernandes <joelagnelf@nvidia.com>, Josh
 Triplett <josh@joshtriplett.org>, Boqun Feng <boqun.feng@gmail.com>,
 Uladzislau Rezki <urezki@gmail.com>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Mel Gorman <mgorman@suse.de>, Andrew
 Morton <akpm@linux-foundation.org>, Masahiro Yamada
 <masahiroy@kernel.org>, Han Shen <shenhan@google.com>, Rik van Riel
 <riel@surriel.com>, Jann Horn <jannh@google.com>, Dan Carpenter
 <dan.carpenter@linaro.org>, Oleg Nesterov <oleg@redhat.com>, Juri Lelli
 <juri.lelli@redhat.com>, Clark Williams <williams@redhat.com>, Yair
 Podemsky <ypodemsk@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 Daniel Wagner <dwagner@suse.de>, Petr Tesarik <ptesarik@suse.com>
Subject: Re: [PATCH v6 00/29] context_tracking,x86: Defer some IPIs until a
 user->kernel transition
In-Reply-To: <aQuNdOEmPYkI03my@localhost.localdomain>
References: <20251010153839.151763-1-vschneid@redhat.com>
 <aQDuY3rgOK-L8D04@localhost.localdomain>
 <xhsmhzf9aov51.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
 <aQJLpSYz3jdazzdb@localhost.localdomain>
 <xhsmh8qgk5txe.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
 <aQuNdOEmPYkI03my@localhost.localdomain>
Date: Thu, 06 Nov 2025 11:02:34 +0100
Message-ID: <xhsmh5xbn5vid.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: TxnIkiNpIvEkgG3D_RJb7iuhECKiLo0oOSzfdE2jln0_1762423357
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: poquzeq43smj57tjaw77tzrzgrjxyizk
X-Rspam-User: 
X-Rspamd-Queue-Id: 8B8874001A
X-Rspamd-Server: rspam01
X-HE-Tag: 1762423360-775573
X-HE-Meta: U2FsdGVkX1+JuxJC5BTCak0MHRoskA3ZPoOtjUCD7a8Tv9NbjWzTBNGb2+oer58ZX+v4/RQP5uD5y6XMDIIkxYExy02ElVZFVa63p+EzfXBNs+0PZgFI8Lv30I1R0l//zFFC9OA08UJ7OHi49i7XH7h7l4Na9Kwqgb0pAO6TZOXSpqWcjURo6dJ4P2wb3yDV3CIoDCNT1hxb/eCI+IwXCLgSCG6zFQnTGib2zZRGY7TQnpS9NVDP7bSOQQ+tfQJxyXJ62bqaT2XOuycUFLAIH/kI42eHAaHDTk/nNnbSYYrEXrYFS4tzbMRLKYi3Ws6Jni9IbLcNaw5ZNv0cjzAemRSiMuZbP6wgePUjX+eAeRMvQsXKwoR57k3JxQP8QpjAnTYQ3zyVROUW9XXEGBhVdjvUxINV/wEwpfTud62GUo5n7l6vNCXyaWZ+DE3A3Y3XIiZ6nVxUa4fsQ9WpGEc/rDc5s5At9pcMOebFneLWWmQmg2rGZTw6tdlB8mmgLp4TSr2AVdAWeFT9qyGtri/4ircOexIp4bzTZHuSSZRmHaV8i/Lbh18mAak1T/yPsflL9Ok8SPCndNyrL5WOpjBvS8SGwMM0+R94VZbm+xmXl65zsXHi5lfDW20dvDyy98dWaFxcicmUSHdoav9qSHrO9GmF3HnYqEtxzrrl5pfxbCo9qrmY3ONX+Yw1OOsMt0ir/tsRHsqOZNjWCk3/8c8CJEvik9zYKAMSiYSZzUbENIq46BL0OzDxhjo5z+vDaV62HMGqI4M6n1/rtCjUPChCkdzVn8que57FtxmtEnMzaplmyOn+E3jvZS/Qh/2pJFl6dSKx4Q6mWwm9C9Ssowp+1LPVlo9iZ4QknZPkbIdgBTVhC+G503f2NL+9eor3T2IF+xs8VAUKhuooixqEyvAk+EHcHywC2taYboynYavDGEX5TvxHhuuxRcExzQsSnS0vUN/ba3FdUNO3Ug+mctR
 uuKk5AFB
 66pjMO05AW9ouMBCphz6fiMtRReR9INND0qlUSsJgoLHiY5NPThmQG4/e4FhcT757is7+lhTLX3+zoASoquvTEAxJMMYj3VZfbZ/2wkRjcuGoGzlWuz3XgLiaWdFCXcPumW0kU77IyU+J8RCoaS+luq4HASGUpCC+PX8dw06fLMPW9bPDf3GyxGJdJWXdQSxzthDKjqy+pp4YZFAZd+Gt3Hxh9xp1J+oc9Ps6TRzsXRy5MSwmqJkfDoZ49gWFPToViRHyNigiuMJ3peNbzOVm/ASIlrBUaMPZ+SzXwWebruLUlJvJ0uhKHIq8y3MHAzLTgd3LyiUjjBSTGJg3eM9wWghg6JooLM3QuqznC6N4Ww4YN/t2UCv2SCajx72/Ab1MlBNN+8Pcp0ZHmlkM0WlfBhdz2JDaJgyViCDYkiNXXMhuF84ZGLIrCTfQc6qjKd6y7QVs/pesb8Aj67MntGWxqjalrVuAzM9tiMl6rZg2VWm9hJ1XpRBUEY6R5KMcjoDuIoczuFj/St7qlAR9XSuHlRL2NQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/11/25 18:46, Frederic Weisbecker wrote:
> Le Wed, Nov 05, 2025 at 05:24:29PM +0100, Valentin Schneider a =C3=A9crit=
 :
>> On 29/10/25 18:15, Frederic Weisbecker wrote:
>> > Le Wed, Oct 29, 2025 at 11:32:58AM +0100, Valentin Schneider a =C3=A9c=
rit :
>> >> I need to have a think about that one; one pain point I see is the co=
ntext
>> >> tracking work has to be NMI safe since e.g. an NMI can take us out of
>> >> userspace. Another is that NOHZ-full CPUs need to be special cased in=
 the
>> >> stop machine queueing / completion.
>> >>
>> >> /me goes fetch a new notebook
>> >
>> > Something like the below (untested) ?
>> >
>>
>> Some minor nits below but otherwise that looks promising.
>>
>> One problem I'm having however is reasoning about the danger zone; what
>> forbidden actions could a NO_HZ_FULL CPU take when entering the kernel
>> while take_cpu_down() is happening?
>>
>> I'm actually not familiar with why we actually use stop_machine() for CP=
U
>> hotplug; I see things like CPUHP_AP_SMPCFD_DYING::smpcfd_dying_cpu() or
>> CPUHP_AP_TICK_DYING::tick_cpu_dying() expect other CPUs to be patiently
>> spinning in multi_cpu_stop(), and I *think* nothing in the entry code up=
 to
>> context_tracking entry would disrupt that, but it's not a small thing to
>> reason about.
>>
>> AFAICT we need to reason about every .teardown callback from
>> CPUHP_TEARDOWN_CPU to CPUHP_AP_OFFLINE and their explicit & implicit
>> dependencies on other CPUs being STOP'd.
>
> You're raising a very interesting question. The initial point of stop_mac=
hine()
> is to synchronize this:
>
>     set_cpu_online(cpu, 0)
>     migrate timers;
>     migrate hrtimers;
>     flush IPIs;
>     etc...
>
> against this pattern:
>
>     preempt_disable()
>     if (cpu_online(cpu))
>         queue something; // could be timer, IPI, etc...
>     preempt_enable()
>
> There have been attempts:
>
>       https://lore.kernel.org/all/20241218171531.2217275-1-costa.shul@red=
hat.com/
>
> And really it should be fine to just do:
>
>     set_cpu_online(cpu, 0)
>     synchronize_rcu()
>     migrate / flush stuff
>

That's what I was thinking as well, at the very least for the
cpu_online_mask bit.

> Probably we should try that instead of the busy loop I proposed
> which only papers over the problem.
>
> Of course there are other assumptions. For example the tick
> timekeeper is migrated easily knowing that all online CPUs are
> not idle (cf: tick_cpu_dying()). So I expect a few traps, with RCU
> for example and indeed all these hotplug callbacks must be audited
> one by one.
>
> I'm not entirely unfamiliar with many of them. Let me see what I can do..=
.
>

Here be dragons :-)


