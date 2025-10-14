Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA91DCCD192
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 15:26:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18F668E0122; Tue, 14 Oct 2025 11:26:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 140898E010A; Tue, 14 Oct 2025 11:26:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 007458E0122; Tue, 14 Oct 2025 11:26:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DE9C58E010A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:26:14 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6F22588867
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 15:26:14 +0000 (UTC)
X-FDA: 83997095868.05.3C0FDD3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 360B14000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 15:26:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RweqxQ+V;
	spf=pass (imf12.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760455572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BPklb6K1+lkU1jV8UO4c/obMd20v1vJ9fV4tt0H1zPw=;
	b=De1kdaTCs6gatsVbuslgQRvdCeV2TaiSxewx9E5Yzmb0euSbyl3pMyUJvGSTorQL/duTM7
	Bt7uVBfqG9PshHMjfNEvLRXLYZ1L/GjaJudWEw6ZYS8qJrInNF0qxxWWx6FmTi8xrJDa7K
	gZrtTtJYhnBFrx0UrL4Zk2SCdJ6e/As=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RweqxQ+V;
	spf=pass (imf12.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760455572; a=rsa-sha256;
	cv=none;
	b=IHZ5Cs+8JL1DEN48c1DXkOytwQY1c1uEdJA5ji7txXQqIcBaEcejFKPU+FvcLDbOCQGQVt
	Ty2Ol42h8x+qbyHgzJf1M9ufJZcPVuAIlX0ACJUXRdZKWcbHL6//l1j43ms6bYM/wqrD/9
	GXDWTCXnh/I5Kvh1nUZxfmS8/xXv2aY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760455571;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BPklb6K1+lkU1jV8UO4c/obMd20v1vJ9fV4tt0H1zPw=;
	b=RweqxQ+V0ktjKiFe9JID4OkFsr51HG2RWDe52/tDj9HfpOdbUz2ReLjxtBgQmlrHm7XOKE
	5FfuReY2J/QsCpjPv0x9ETfBZD5qoUHuXUnZb9Vpa1Br2DxIo8Mj3rEa1yeTDXT3Rrrwqn
	P4DJQZcRlFkROtdwiEiAlI/AObZHZT0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-449-qHiJX1FHNeCxd8-6hSqvfQ-1; Tue, 14 Oct 2025 11:26:08 -0400
X-MC-Unique: qHiJX1FHNeCxd8-6hSqvfQ-1
X-Mimecast-MFC-AGG-ID: qHiJX1FHNeCxd8-6hSqvfQ_1760455567
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-46e4cb3e4deso21106815e9.1
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:26:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760455567; x=1761060367;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BPklb6K1+lkU1jV8UO4c/obMd20v1vJ9fV4tt0H1zPw=;
        b=pgtde9z2oUJGXGmJQZWYanrztxtuHtk9P5mqb293xwg+FKUuhZosEg821fpUV+npAO
         YaEQXZo+TcM5cWNOujT7+SlqfK2JyFPNb+e+YDUv12Wr3i/6ByrwicvdGPumjsCtnoIA
         VR8nQrF81kZKiSoOeEgEEH8qzRWX3329VvjD19L7N2/ibZkYDHLlzwAwFokIrRTowcp0
         zxOprDSRysLo7hEwk7JcdJVLUs0P2KagC0yp5k7YTluo8pJREzTWDFh1J5sEonYofT68
         rFrRHnbC5/48XrBcbnu7opIXthFPoj+92GxXcP8VOUExr4rmPzN719+zx7xHk75PZ04R
         nujA==
X-Forwarded-Encrypted: i=1; AJvYcCVNNOo/QchxdpVqEqjgVOle89y/1OczdBcXH7Emj0Rwu+flyX6pUUtEEdcyJPh1cmExpMT7ZhhN2g==@kvack.org
X-Gm-Message-State: AOJu0YwsuKckxTbP2ML2Ug18+/Icq45hjt0NDrOGB9DzqPDNvuOhQTib
	XPACe5WatopeX8aMc5WYU8kFjmx6fzyAC4aykfcMMsy5zBp8F38DEGIgwoQMR9lzjof/ZRgXvKK
	SrLLgcLh/pcnPkRR61IQnzNOcE3bsWbryzdGI7Wv6iJACxO/PmOqu
X-Gm-Gg: ASbGncvapo/m5P2AQB7iDYp1IpDi/xPCpCHql+aMW448kR7YsLNKoYMQLKrF191idOr
	ZRp7Ieo7yfLcqTCrILq23CB/J5Zvg5TTKzKFo6CI6O1qHa/QhwPvbu76u18rfl8fsT2QN0QkYwj
	PYU9KPCmBsxuSEMZ60rWEj8W/amLaIPiOjp4dykmOHk58q76qwUleuqRtNA6XU0xbIKEOaYB6/T
	IEpYunsxcx6NgajEp8lhEpaVGs159Pm3LienNfHx9/2kOi35WVl3DJXG6REinTSDvX3qH/ert9q
	tzSoyo5RmpDB1UnK4Oo+kNBGAVOtmx65uvETwnZGZHdHN1gbq1d2yYMcKx7AY+7pcdD+/HPhtgW
	Feohy6IOjNZ3OH7ZJyOkL00pX5g==
X-Received: by 2002:a05:600c:8115:b0:46e:711c:efe9 with SMTP id 5b1f17b1804b1-46fa9ec7556mr181899295e9.13.1760455566815;
        Tue, 14 Oct 2025 08:26:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHW593XOgtaLpqw6H4D31qH5lmbNbujonLfE4h+J4hQ9AwSFy0g3uK3ztnKvCXj4YJKI0uSVg==
X-Received: by 2002:a05:600c:8115:b0:46e:711c:efe9 with SMTP id 5b1f17b1804b1-46fa9ec7556mr181898575e9.13.1760455566403;
        Tue, 14 Oct 2025 08:26:06 -0700 (PDT)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (213-44-135-146.abo.bbox.fr. [213.44.135.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce57d3b9sm24483884f8f.11.2025.10.14.08.26.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 08:26:05 -0700 (PDT)
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
 Morton <akpm@linux-foundation.org>, Masahiro Yamada
 <masahiroy@kernel.org>, Han Shen <shenhan@google.com>, Rik van Riel
 <riel@surriel.com>, Jann Horn <jannh@google.com>, Dan Carpenter
 <dan.carpenter@linaro.org>, Oleg Nesterov <oleg@redhat.com>, Clark
 Williams <williams@redhat.com>, Yair Podemsky <ypodemsk@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, Daniel Wagner <dwagner@suse.de>,
 Petr Tesarik <ptesarik@suse.com>
Subject: Re: [PATCH v6 00/29] context_tracking,x86: Defer some IPIs until a
 user->kernel transition
In-Reply-To: <aO5I2WGtXqSPYFmH@jlelli-thinkpadt14gen4.remote.csb>
References: <20251010153839.151763-1-vschneid@redhat.com>
 <aO5I2WGtXqSPYFmH@jlelli-thinkpadt14gen4.remote.csb>
Date: Tue, 14 Oct 2025 17:26:04 +0200
Message-ID: <xhsmhzf9tld2r.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5Peky1Kq56IpjqzJR5noPZGcc4DHUZEQ2zs3YBqbAtc_1760455567
X-Mimecast-Originator: redhat.com
Content-Type: text/plain
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 360B14000D
X-Stat-Signature: gd3etexo6xij83ueq8iiuonc1mtcp6bi
X-Rspam-User: 
X-HE-Tag: 1760455572-766588
X-HE-Meta: U2FsdGVkX1/KvvMfWQe6wzMTPKZ7JtLA3b5joG80dvJz2wSAn4aBY88bYaIKBXhfFRaLcYlE3XV7WqBeiOyLpheUu3XIunhuddK4JEiGKInWRnxpOoV+/M6ZoOE2i2ndNYCMzpewzWg9sanv4njmu0dbxZN0Y5BV9OohlQE/Sq29Qjbv5sYUTyv4RT5VrrG1zithRjeGB2Myf0hxjoCqhiln/YStUQAu3M5srDzmbm/z47BO+/vKOPrVXCNcLkJjdVhLfPS7SCRQegu0GDB4m1kACCCxC+YBlUVS9rKkjcuTFE3CP0HdpUYalt1pgthvvmetlnbx+ZguG26n51k3v+y45SFMe9W5zY9y49a3s9M0Qc8T8sSRkap+G6o7AtHKfiFDungbYq4k3DaP8qEdIiRqO8lzPZK9Z38nIATUODAclSeKHdUB/xWgUQApA7BPPTa43esjnXahgS6b30vs30JLTP/Ca2OkUHqdb/Ynm9xlWbWeEkHhsOZylSOjGhHBmW0zEYIm+TKWvg2OVpZ0CePevFIxeFgSTavSiYgpRC9dJ2WOnRNwrn+dupHLVn9KEm+pMR7GYaFSjSPWmVIDgZ/XTlcaoaQnVEow5fRXT5Gbw5HpeBrs4LiyphHZbMQqY9ZJ268+zPFYqzxF8Z3VVnmcz40zb2euAvHabzvBSdOMAY4OU9+UQ9hlch9/vjcG1ChnRN51DnL555DGHyDu1JFHn0FmR+Pz6Vung7U1RUDcGh4c91eQAOgRQusL0itHp+gGR0Ly51lUiRur6PaORDyBZqFw83srOPK8oSsBGka3kIYoqd8tAAoU02VAqe/H4x269cV7C+anFg1/y8xk50Y0tBhRa1RK2n1lYUgMfQ5RWUPG3faaerFDiPqVjpu8dTMRaibK2s6oklZpom6U12w00d4YKNZ50HPbDvmyAt6NY9EHaHh1bkAyzziZqKCx+RyVinCpJJFPHQUa/kS
 vL2NJPe4
 wfH75ocZHDY3M3l1TnF+/JdEh1dBr1ShLkjmqwwRg9Pm7Te6QeezYHetlv5w9UTCBzxpynFQ3fEfeZi5rQLUcyGnS3e7r8B0SMnB0rd6Jfa6oQbwa36P+YqrkD6UNLYz09VDBUYbeAc6jE4Bpeqw8seIyx/dNYDWmtQsymEH1jBzQ8mvXkzQZZA8PnXRZeYavHhRy6oVPnfGYuoWw6LEjpFPWuEMnUoMcgF7q3HMQufxh3kyoz96/Yv4stUwQBOtP0cUtkVsVqTcxz7lBoGd1F6NSNaqsMoHH/Sxnoqf6OrdGht0Q8px69icweRGcAcPtYkk8+3EEHeGFI61C0HsjAI5OdvFcWUtlQQRIXp/7Rbz29RhnwyeL7fUXUeMVfjU5kXeMw5fNtjnv+5jNLjHF6KU2wgE1UI/JU+1yYD+Ne1GtsKB9RfwZxncGqk1sGUDKUqOVgV1iMb0YJqT8Rz06FG09Xs/ZZhdrBYr5kyTII54xt12oqYFxAG70clScCAJ1KixCvoOV6S686EdOa2a0sBjVsBaGUDQEO5rDpjLY5WAZN2GDYyPtm+UEtQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14/10/25 14:58, Juri Lelli wrote:
>> Noise
>> +++++
>>
>> Xeon E5-2699 system with SMToff, NOHZ_FULL, isolated CPUs.
>> RHEL10 userspace.
>>
>> Workload is using rteval (kernel compilation + hackbench) on housekeeping CPUs
>> and a dummy stay-in-userspace loop on the isolated CPUs. The main invocation is:
>>
>> $ trace-cmd record -e "ipi_send_cpumask" -f "cpumask & CPUS{$ISOL_CPUS}" \
>>                 -e "ipi_send_cpu"     -f "cpu & CPUS{$ISOL_CPUS}" \
>>                 rteval --onlyload --loads-cpulist=$HK_CPUS \
>>                 --hackbench-runlowmem=True --duration=$DURATION
>>
>> This only records IPIs sent to isolated CPUs, so any event there is interference
>> (with a bit of fuzz at the start/end of the workload when spawning the
>> processes). All tests were done with a duration of 6 hours.
>>
>> v6.17
>> o ~5400 IPIs received, so about ~200 interfering IPI per isolated CPU
>> o About one interfering IPI just shy of every 2 minutes
>>
>> v6.17 + patches
>> o Zilch!
>
> Nice. :)
>
> About performance, can we assume housekeeping CPUs are not affected by
> the change (they don't seem to use the trick anyway) or do we want/need
> to collect some numbers on them as well just in case (maybe more
> throughput oriented)?
>

So for the text_poke IPI yes, because this is all done through
context_tracking which doesn't imply housekeeping CPUs.

For the TLB flush faff the HK CPUs get two extra writes per kernel entry
cycle (one at entry and one at exit, for that stupid signal) which I expect
to be noticeable but small-ish. I can definitely go and measure that.

> Thanks,
> Juri


