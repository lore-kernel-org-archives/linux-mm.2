Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFB62CCD192
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 13:10:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25A908E0118; Tue, 14 Oct 2025 09:10:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E3BC8E0112; Tue, 14 Oct 2025 09:10:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D3778E0118; Tue, 14 Oct 2025 09:10:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E95288E0112
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:10:46 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B419686693
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:10:46 +0000 (UTC)
X-FDA: 83996754492.20.78AD11B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2465B80018
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:10:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g9+NifUw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760447445; a=rsa-sha256;
	cv=none;
	b=QIWltNYECOCUhZtwUwe75smwHqOp3OkB6jVfADKyejkGoUB447w8BkrtRJvJo96uW+nhJG
	j2Wkyu2hp1h6HFv0yDnGm/1c7c3iyHyJd4/q0y0I6vMIyKL5x4nOduYm/ZT+04nGs86TJg
	maZOQ3aB2rHHbRiS9kLmoqAMb6LgeXA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g9+NifUw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760447445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nsF6PObp6qoqkkCKTQsSNmyL4hK2S7wY4EQepojwbJw=;
	b=WA9D6prfLOwdcurb6lNh08oJGn3omaN6rW1K32TbJFigDKkGQdVj+L4eEOwFUCr4HS44Ic
	X6iyNfnBlIToL0ZAxnDPJkPANWYqtIhWpeicuR6zn+Ybf5H/gTXyMD9o/jwZ21XzUFj3se
	N1TRCqHfvdzecN3tcQxi+y0qGn3bklU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0EF9C622CF;
	Tue, 14 Oct 2025 13:10:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8533FC4CEE7;
	Tue, 14 Oct 2025 13:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760447443;
	bh=1z29qiTz6h5jyAO8g68bo34GcYPLqTUSe9I3ydJUTw8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=g9+NifUwXszKwI+i9b+BADg9CHX9pjgCw2mu/yxA+73glB/SfRpvhpeMLwX+7zeg9
	 cpZyrZdbl6zsMX+Wo90KkdV6hDFv+HpHH+GKnixUqPtsiiuipRTYlBSA+RFLrU6AdF
	 z8MA7ZC0dDyvXrecjZhU8nlLLfZCLEsyyqROyne29Obt+UqzwZBF2jT+f8QUD3imN0
	 gQ5aZfRz1OgEk0IJVCMTbI4VrsIEPNPKNZutUFVMj6TdGeXxePJsX5/R68ibLC+6iv
	 jZYvfqrXGK5MchNQMt25O838FaWOmrFURP+ZyNfLcRWE1zF4CmsEn6AFbRAtwXlHBn
	 SOQ76mXQJoW1Q==
From: Pratyush Yadav <pratyush@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Changyuan Lyu
 <changyuanl@google.com>,  rppt@kernel.org,  akpm@linux-foundation.org,
  linux-kernel@vger.kernel.org,  anthony.yznaga@oracle.com,  arnd@arndb.de,
  ashish.kalra@amd.com,  benh@kernel.crashing.org,  bp@alien8.de,
  catalin.marinas@arm.com,  corbet@lwn.net,  dave.hansen@linux.intel.com,
  devicetree@vger.kernel.org,  dwmw2@infradead.org,  ebiederm@xmission.com,
  graf@amazon.com,  hpa@zytor.com,  jgowans@amazon.com,
  kexec@lists.infradead.org,  krzk@kernel.org,
  linux-arm-kernel@lists.infradead.org,  linux-doc@vger.kernel.org,
  linux-mm@kvack.org,  luto@kernel.org,  mark.rutland@arm.com,
  mingo@redhat.com,  pasha.tatashin@soleen.com,  pbonzini@redhat.com,
  peterz@infradead.org,  robh@kernel.org,  rostedt@goodmis.org,
  saravanak@google.com,  skinsburskii@linux.microsoft.com,
  tglx@linutronix.de,  thomas.lendacky@amd.com,  will@kernel.org,
  x86@kernel.org
Subject: Re: [PATCH v8 01/17] memblock: add MEMBLOCK_RSRV_KERN flag
In-Reply-To: <2ege2jfbevtunhxsnutbzde7cqwgu5qbj4bbuw2umw7ke7ogcn@5wtskk4exzsi>
	(Breno Leitao's message of "Tue, 14 Oct 2025 01:34:07 -0700")
References: <20250509074635.3187114-1-changyuanl@google.com>
	<20250509074635.3187114-2-changyuanl@google.com>
	<ef6wfr72set5wa5el3wbbu4yd5tnc4p2rhtjpb5kpmncv3xs5d@i3c5v3ciioi3>
	<mafs0wm4yluej.fsf@kernel.org> <mafs0h5w2lpqu.fsf@kernel.org>
	<2ege2jfbevtunhxsnutbzde7cqwgu5qbj4bbuw2umw7ke7ogcn@5wtskk4exzsi>
Date: Tue, 14 Oct 2025 15:10:37 +0200
Message-ID: <mafs0cy6pljci.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2465B80018
X-Stat-Signature: th8w8tcyxrafkj4fhhgxhkc8rycjrq1w
X-HE-Tag: 1760447444-783583
X-HE-Meta: U2FsdGVkX1/nUF3Fuphrtp8AUWeqhp9SFtV5zHUM/DpxTuPubmNeTOVAIx60snZ3qVh4UgWEzUOw0WVSkeSehevFp5mFxmwXXdRXD+Ts9ccEUWva248Qos07iQ0NIiHsx3ioth1ORj6RdjFHcMlW5+9G66TEkIpWykTLP6xjP6MHNCYsrxdK/V0Wq68fAc76w+30S5lQFxbh7WqBbPrX/XLP30pBWBciF1DfK9BJHpgu67FCpP6/8+L/CO8S4uLHD1voSpq7STe+Clu2mHWPHVlea7o6M7cWT6RmaYSM6vkmvZkmv6u/V8NsTfSY+pdVFRs7aq0PbAHRE4VMkjeGfHJB10CsjpbwWKAX4rIlPfexsJe6kHsGpSGweADxc2eJnbNIMoK5Ncl26IEcUG8ocn4tRmjfmJxtv8cjLVIyMwcptGFoYzVkQudC7RsAWJ3HR4TpYqvvFwTnkrtzXpBAPv3ZO/5yWgl5g3+9SZmQ3pfqbGrcBFslJZXNfE4qYm/yR616r0X3hdzlTeFuEbv5vnnfkDApeeXj6JclascxNcim9b6v+lHRmi+pZMmxCv4IvVU6yznWuB5Cm1yZTlLPuIsS9bIZtYdrH4KT14ybyJ/gyD/kkIk0KnBFwy8jZtQDN2yyJqETA96oYa+2ylL5v73iSMAOWAhy9IOrqH+DN4Kbu4M7OrWquOdhPfMboQ1jxsiIwUK9A2lDPi9Y/ayfUocxmidbIDhIYkEi6uoMrSJX6NEryv4dbnkJ9w5d+NWRrU2gYPsTcVBkRCHOhRmfUDJ2p7jmXWTtiF9UwceGqCSe4I/CNo5chZoGC+3KDVeB407Ia8YPhVHuwOjbsv4t585nlgo31a+bsXvvP+cTVDAGWEnuHMGMCpzwJ/eW3h6gb33Lqi6tybzJNi3hWudFNVA9Rl602KLU2Qeg/XyuP2peziMuSuiriaay97kXAeRDJIhqYRJSox1nYZo2tLN
 uWKIyNTG
 oelBeeblXw3je8sIceCcFBdT2DS0y2JBuFUYWRLLXS6UimC7kwZRuaPLt4RSHgrSUdAiGhqIUzfwbCEoRXewIZtYuYKDuh5+GTOs7gF317zlMuQ3uao33Omshwrf/hJgs7CruhQXc9nmJ8ye5cM0rQOIwEBYy/OW4abIwZsFRJkKXVtrwbcwFHUy2xsfX+04liJ1/azUWx4eF3ILodmhAySbDAw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14 2025, Breno Leitao wrote:

> Hello Pratyush,
>
> On Mon, Oct 13, 2025 at 06:40:09PM +0200, Pratyush Yadav wrote:
>> On Mon, Oct 13 2025, Pratyush Yadav wrote:
>> >
>> > I suppose this would be useful. I think enabling memblock debug prints
>> > would also be helpful (using the "memblock=debug" commandline parameter)
>> > if it doesn't impact your production environment too much.
>> 
>> Actually, I think "memblock=debug" is going to be the more useful thing
>> since it would also show what function allocated the overlapping range
>> and the flags it was allocated with.
>> 
>> On my qemu VM with KVM, this results in around 70 prints from memblock.
>> So it adds a bit of extra prints but nothing that should be too
>> disrupting I think. Plus, only at boot so the worst thing you get is
>> slightly slower boot times.
>
> Unfortunately this issue is happening on production systems, and I don't
> have an easy way to reproduce it _yet_.
>
> At the same time, "memblock=debug" has two problems:
>
>  1) It slows the boot time as you suggested. Boot time at large
>     environments is SUPER critical and time sensitive. It is a bit
>     weird, but it is common for machines in production to kexec
>     _thousands_ of times, and kexecing is considered downtime.

I don't know if it would make a real enough difference on boot times,
only that it should theoretically affect it, mainly if you are using
serial for dmesg logs. Anyway, that's your production environment so you
know best.

>
>     This would be useful if I find some hosts getting this issue, and
>     then I can easily enable the extra information to collect what
>     I need, but, this didn't pan out because the hosts I got
>     `memblock=debug` didn't collaborate.
>
>  2) "memblock=debug" is verbose for all cases, which also not necessary
>     the desired behaviour. I am more interested in only being verbose
>     when there is a known problem.
>
> That said, my suggestion is to only dump extra information when something goes
> wrong, not affecting the boot time neither boot verbosity.
>

With your proposed change, we only know what the overlapping area is,
but not who allocated it. I don't see how that can be done when the
error is detected. memblock debug lets us know that, which is why I
suggested it.

-- 
Regards,
Pratyush Yadav

