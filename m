Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DFA5CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 13:16:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B18C68E0034; Wed, 15 Oct 2025 09:16:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC8F78E0020; Wed, 15 Oct 2025 09:16:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 990FA8E0034; Wed, 15 Oct 2025 09:16:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7E8798E0020
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:16:24 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E1C021DB93B
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 13:16:23 +0000 (UTC)
X-FDA: 84000397446.29.F223EAA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8701FA000A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 13:16:21 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OR0F3Rd1;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760534181; a=rsa-sha256;
	cv=none;
	b=w+Y+Ip7qtQdYu6RI2yFeEns0yRCr5bt82RWw3kfrbGaLOb1eEEXZRyVoq0Jtg0571DimS+
	N2/SQ2+S5cw/wYCsvqKa4kdk6VG368hUoEzwQTOjcaGJUXswMAGRq0RNYGYwsf09nzW7ql
	kpZo4htmatNodH/Tvue5VKq6Vn1E07o=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OR0F3Rd1;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760534181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yD6dvIl7J8wWJkas/YONpCBWDBu3WvjIWx4zsxh951U=;
	b=HQeS6Jv4R0R476nuSKxLyUSlKifymG4cfH82dwP9Yi/KVOwVcAnsaOzyHb2e2VQPe78u1S
	4ReIvWOmlhlXeZd8luxLcv7nLpuP1TTui0gH/Acdc14hsjwqtUFuS7nz0CqRDp+neRA35p
	CEm6P5T90EHv+fWfaBLFpW1fHrPOnXo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760534180;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yD6dvIl7J8wWJkas/YONpCBWDBu3WvjIWx4zsxh951U=;
	b=OR0F3Rd18+UXyS/ur6I8fgwRmdEiRYxrMTXOkYqtRytU9ouhAtC8UH26QlGdqvgXFeJppJ
	IQkA7GCJAB1qGi+Nh5Rb911P4iicIptHyWaEnQca9KHpjMbRHRlqKmjohv4ZhnCUQzkw1f
	xx1lGccBp0u1AiUu/w0gSwcnXcrbjng=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-36-pUgMDDoKNmuzSjhvFMghmA-1; Wed, 15 Oct 2025 09:16:18 -0400
X-MC-Unique: pUgMDDoKNmuzSjhvFMghmA-1
X-Mimecast-MFC-AGG-ID: pUgMDDoKNmuzSjhvFMghmA_1760534177
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3ee13baf21dso5281223f8f.0
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:16:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760534177; x=1761138977;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yD6dvIl7J8wWJkas/YONpCBWDBu3WvjIWx4zsxh951U=;
        b=iqrjdf0Bzu6/Ba82mirTr8hOgbSwMBvTi9DqfxsKFBeRPaWaP50Das0we0or/epiBs
         5hojhaqyALK//yHl/Lop+XJhfs388I2K7uDkIWVHk2d5Aq7MSiBir5akFkkmTJ1gJW2N
         nmD85KsaRzdUQOnAK4sCKuH/urzscNdlWkHspZgISVfp4iQtt/HzFvypVw/BOLBuqiqG
         a2VCGtVV+edY6v3VlU4ZULD1njk1XNw4KmD1JPbTLskNeVPAZoS7DXUfE9mdiYzteVVE
         9FxjkGe6FRX79AordmcsPG3V6uhRpi0y7/ECGtKn0QSPklKLkkmZhO1rro/mGrYtKIAa
         J0Yw==
X-Forwarded-Encrypted: i=1; AJvYcCU8f1rG4g5ZrsgNspJmpdC9HgpajVnJICjr5aWhhC75CXIi7pUc68wXTkML2lMoBPFAy8ApMNgjdg==@kvack.org
X-Gm-Message-State: AOJu0YyK18q8KywM0PXw86Nc+PSgGm6dtriZpsPHAtNdmDW2uVZgkPzT
	QDqdUreol7ZFgXbda6j7J6Aa1DHxnvPNAaU4Sc1nE64URCEH8RIKNbzAREDNkcjNGOPOxDgFjIF
	k89sh65OCDalo7t+Ea983Z5zCJbbQjCCr82SietFFJYAXebsuPsc/
X-Gm-Gg: ASbGncv5cmeOQJfqXprZsQm5gZo58HIJchNOjQGUY+GszawQjQTlI6pCbt/WzMpsHtf
	TQz0EMJRlqKjsnOgw5lR8OWhtMZSG/M/kbF48KNTxa64UsPgw2UdVxNwXjErL96ObUu3Q6Zg4pZ
	xsFHQ9iFdFxmzjsQuB9s/TITW7Icr3zLk+/dEvkRVTcmO+V20H9A5lil5GBPE6KhGo5ErbH234U
	NpqgcVvQoQHKiRgnRlwQdjGYsQgDWuzE1IboCOYhvp96ZemNRQ4cOJiNvxfJbO7Ts99Xf8G8fwy
	9HduoNnRDbKzxfABcrSvLdjCeloKPi3xvRHa13Moew51lEYyYbXMbcS2El0RWfMuu/WPi5V3a2l
	smmeBhPvPNjo/muZA2xghVpNOeg==
X-Received: by 2002:a05:6000:248a:b0:3f2:dc6e:6a89 with SMTP id ffacd0b85a97d-4266e8e4c29mr18416315f8f.57.1760534177098;
        Wed, 15 Oct 2025 06:16:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHcUjf8Yi428dP9FWOn2X364zzJqp12CDvIxSjruyz4UDGZF5I3K12BFelQ7PlgEZWXYUZIhg==
X-Received: by 2002:a05:6000:248a:b0:3f2:dc6e:6a89 with SMTP id ffacd0b85a97d-4266e8e4c29mr18416272f8f.57.1760534176503;
        Wed, 15 Oct 2025 06:16:16 -0700 (PDT)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (213-44-135-146.abo.bbox.fr. [213.44.135.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce57ccb1sm28976327f8f.8.2025.10.15.06.16.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 06:16:15 -0700 (PDT)
From: Valentin Schneider <vschneid@redhat.com>
To: Juri Lelli <juri.lelli@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, rcu@vger.kernel.org,
 x86@kernel.org, linux-arm-kernel@lists.infradead.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
 linux-arch@vger.kernel.org, linux-trace-kernel@vger.kernel.org, Thomas
 Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav
 Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "H.
 Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Peter
 Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo
 <acme@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, Paolo Bonzini
 <pbonzini@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Frederic Weisbecker
 <frederic@kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>, Jason
 Baron <jbaron@akamai.com>, Steven Rostedt <rostedt@goodmis.org>, Ard
 Biesheuvel <ardb@kernel.org>, Sami Tolvanen <samitolvanen@google.com>,
 "David S. Miller" <davem@davemloft.net>, Neeraj Upadhyay
 <neeraj.upadhyay@kernel.org>, Joel Fernandes <joelagnelf@nvidia.com>, Josh
 Triplett <josh@joshtriplett.org>, Boqun Feng <boqun.feng@gmail.com>,
 Uladzislau Rezki <urezki@gmail.com>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Mel Gorman <mgorman@suse.de>, Andrew
 Morton <akpm@linux-foundation.org>, Masahiro Yamada <masahiroy@kernel.org>,
 Han Shen <shenhan@google.com>, Rik van Riel <riel@surriel.com>, Jann Horn
 <jannh@google.com>, Dan Carpenter <dan.carpenter@linaro.org>, Oleg
 Nesterov <oleg@redhat.com>, Clark
 Williams <williams@redhat.com>, Yair Podemsky <ypodemsk@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, Daniel Wagner <dwagner@suse.de>,
 Petr Tesarik <ptesarik@suse.com>
Subject: Re: [PATCH v6 00/29] context_tracking,x86: Defer some IPIs until a
 user->kernel transition
In-Reply-To: <xhsmhzf9tld2r.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
References: <20251010153839.151763-1-vschneid@redhat.com>
 <aO5I2WGtXqSPYFmH@jlelli-thinkpadt14gen4.remote.csb>
 <xhsmhzf9tld2r.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
Date: Wed, 15 Oct 2025 15:16:13 +0200
Message-ID: <xhsmhwm4wl2zm.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _o4YPkxIcRd-Pq6ZBnPfUyMmy1y4dEhL5Hpi2v-yz8Q_1760534177
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8701FA000A
X-Stat-Signature: sfjgkbf3zz3jeknquir3xdk4a31sknrj
X-HE-Tag: 1760534181-876848
X-HE-Meta: U2FsdGVkX18gIV0wOWd/A60Vzcy7ezl4gD6K2Rfd1enWOTQrCjO7fJp92QLwn2jSofWKEQEN1e0hmCyVbjyXgbfzrizG9kJiXYxqoxK2XFVi//UIOr+P8vymiscW+Q6258J6J/ipwr+ygVOS2yBfD41HrNVogcoTNu6T0jYIo1eEhoW0afQBTqri+IXZorZP937FGrLIKSENF/eMAh5GoL8PQCGg1fpTCn1Nyiav3L/ijuOhbQo/UK/UW5ZuEX4iws3do2JKgWderHTdmrwwLaE+2MxmsSlXJTW9+N5J8Rou4GzQau+eAs9PJyYuq05TYZpAbWsN+azF0+zO2ehXaz0oC7zuIZ2Jh/OeqxRJVoE5YkejZVp2tRIPgPs8/ez0vyHGSevSij9JlHOowikNKErkR9ENkP9JDp+BZGLwvkXDyh9sjFHnbbdLz31N1KPph2S2RUO8xe5698lCg03dRo6R8MxKMQKRNVKpP7mZnbSOyziOrCdiR2oe+Ap/Vwwiq5FcyBtzgXH69P7SVv2nI18oqeAcqCIZbR+qZUz5WrHN0qmcFnY9MHBfPovzwq5lNgahCgtiH8/jMSQ8l8jUIEFUo30YAqlKbKOPOW+MS0TgtXY0Ayp4kpccmtsPATaLx8g4A3VDfFcJoIluz1LaT1zz7CPTF0Vf56mNCdSE8pbJ8KF0Qd9vxmnH/K7ed42gs86k67I4YRau+1BVKwGuEQ3bF75L5Mu+dezZ+GTYtoVE79N4xts3Sf6J6I4cLGrQxZd1UpncRohl6MJVrzGCLSVIMWoeMXzvbKwuYeSynrMWV7kXeBwuh93otZftGwoKGlzFp6k773EDMaqIXlb2s9q7iycvvtIEBjSGnwUSJNq5C6EV8tyg/Ho8j3EnWPoH9d0Pe4nhIJ0F9VyKqT6+101n+97dfLSa+Vb27JZIMDyK/VkLrU18MzGQvRoc+KvcrdhMmYohwOIfh9kOTkm
 dRs9Y5nM
 JifanhxMeg0610O6o67wf28N1jj6DfobV+SsgKkVpgnpvAYETltX0Z6QKFiVFDVkWORq+eqDnogeksAZiD52IqLkKf9MrPd7O4dECSL6h4N4FLcweDO1WO7sNbR7sHfSYlNRBcfhsl9a5zYueqMEVsmZjPGkVBTplQQsXtrLnwzB9F5a69bwvfcHuIJnlFzpmf2cvWbG4M2EY13cEQkOuNyu+6J+G3cMT9xlhv6zUmWcr92YaGa/zShAkeIV8WTdT2EplRx2s+1CpxTuv7UNfNbbIgizNN/L4XUL8DIpV1p1D5TYzu1cplcNpSjKeeKDpET0uvMG8JXUJr5NZx8l8SyrsM6ZIqkJIL+FuX7tnMjgOX5CcuLYcgAKGG4uXrwVGZYdCHtGzGdJelVe2tXjAr3nJ3vcpgjl6ybpfygCrA3wxY+DpOGPCpJ9a8evst3m39zsDWlsV+7Zqe44UNb4TMg/AsRpDN4XTwh0IGDjIDurPEDiKQzTwkwHIXVUNW8rqE4eme0BALAWhhlf8jJk+in53hLjGLATxEthyHLdU8xZ8b/imqiflW7BNUpcbyEJvWwnD3RuAeVUr42dWBml0MBlNjRTuN8wtUERV7vhNKOlcDEk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14/10/25 17:26, Valentin Schneider wrote:
> On 14/10/25 14:58, Juri Lelli wrote:
>>> Noise
>>> +++++
>>>
>>> Xeon E5-2699 system with SMToff, NOHZ_FULL, isolated CPUs.
>>> RHEL10 userspace.
>>>
>>> Workload is using rteval (kernel compilation + hackbench) on housekeepi=
ng CPUs
>>> and a dummy stay-in-userspace loop on the isolated CPUs. The main invoc=
ation is:
>>>
>>> $ trace-cmd record -e "ipi_send_cpumask" -f "cpumask & CPUS{$ISOL_CPUS}=
" \
>>>                 -e "ipi_send_cpu"     -f "cpu & CPUS{$ISOL_CPUS}" \
>>>                 rteval --onlyload --loads-cpulist=3D$HK_CPUS \
>>>                 --hackbench-runlowmem=3DTrue --duration=3D$DURATION
>>>
>>> This only records IPIs sent to isolated CPUs, so any event there is int=
erference
>>> (with a bit of fuzz at the start/end of the workload when spawning the
>>> processes). All tests were done with a duration of 6 hours.
>>>
>>> v6.17
>>> o ~5400 IPIs received, so about ~200 interfering IPI per isolated CPU
>>> o About one interfering IPI just shy of every 2 minutes
>>>
>>> v6.17 + patches
>>> o Zilch!
>>
>> Nice. :)
>>
>> About performance, can we assume housekeeping CPUs are not affected by
>> the change (they don't seem to use the trick anyway) or do we want/need
>> to collect some numbers on them as well just in case (maybe more
>> throughput oriented)?
>>
>
> So for the text_poke IPI yes, because this is all done through
> context_tracking which doesn't imply housekeeping CPUs.
>
> For the TLB flush faff the HK CPUs get two extra writes per kernel entry
> cycle (one at entry and one at exit, for that stupid signal) which I expe=
ct
> to be noticeable but small-ish. I can definitely go and measure that.
>

On that same Xeon E5-2699 system with the same tuning, the average time
taken for 300M gettid syscalls on housekeeping CPUs is
  v6.17:          698.64ns =C2=B1 2.35ns
  v6.17 + series: 702.60ns =C2=B1 3.43ns

So noticeable (~.6% worse) but not horrible?

>> Thanks,
>> Juri


