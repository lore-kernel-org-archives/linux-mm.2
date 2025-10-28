Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DC6BCCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 19:54:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55BF28E0007; Tue, 28 Oct 2025 15:54:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DEB88E0003; Tue, 28 Oct 2025 15:54:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F52C8E0007; Tue, 28 Oct 2025 15:54:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2B07F8E0003
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 15:54:29 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CDA094954F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 19:54:28 +0000 (UTC)
X-FDA: 84048575016.24.DB87C84
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf24.hostedemail.com (Postfix) with ESMTP id DB8F4180002
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 19:54:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GokpmF4j;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761681267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W1vfNH1OtxcVF1Jg9QAf61yzDR/63k5WefYxmSxcqt4=;
	b=GN5vdpfUjemB2R1pf3m4D6HFYosiGANnN4TCF84c4bXss/kAGnu+vu1y/LnElC10XluUJW
	oGsA5QKtw/3TyTo0pYBcpQuQgDpjkcWerkO6xonD7oSNjHIcdtkLO+/OKkheFS6aDC0CFP
	CAztA8jr7E1nPZdNG88i068gHuzOB/4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761681267; a=rsa-sha256;
	cv=none;
	b=XG0rN5LJQd+FQgdWesk42gKTxMm6hEIpR5BxLujUu+DScVTQzkSUGFXLNe+MEaDuLnuYRm
	d8R9hpwfA2h56AgkKYv1Uu+rrz0Hq4hflb6ByoTh1RLrLfH8QBcbGjJePrtO9zmA9UGgCu
	B9S7GPJMkTiyq4n96dbhZehGn/u6KDw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GokpmF4j;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761681264;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W1vfNH1OtxcVF1Jg9QAf61yzDR/63k5WefYxmSxcqt4=;
	b=GokpmF4jfTl+pwsmQbtDT5ic/PNmqZi3UwNtLBQo6WzF05jogM1a4ra3TXZ0+gSmuQhSt9
	0tM68yBrWrIn74Ess33qfXZCGPme1h6MljFE/w427Ce82/ru+IdWwypGezWDhGWJSCFv/D
	y+QdscXaBfltrFgGplzm1qPNl8ODy0M=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
  linux-kernel@vger.kernel.org,  Alexei Starovoitov <ast@kernel.org>,
  Suren Baghdasaryan <surenb@google.com>,  Michal Hocko
 <mhocko@kernel.org>,  Shakeel Butt <shakeel.butt@linux.dev>,  Johannes
 Weiner <hannes@cmpxchg.org>,  Andrii Nakryiko <andrii@kernel.org>,  JP
 Kobryn <inwardvessel@gmail.com>,  linux-mm@kvack.org,
  cgroups@vger.kernel.org,  bpf@vger.kernel.org,  Martin KaFai Lau
 <martin.lau@kernel.org>,  Song Liu <song@kernel.org>,  Kumar Kartikeya
 Dwivedi <memxor@gmail.com>
Subject: Re: [PATCH v2 20/23] sched: psi: implement bpf_psi struct ops
In-Reply-To: <aQEM7LXpZdOpsgvU@slm.duckdns.org> (Tejun Heo's message of "Tue,
	28 Oct 2025 08:35:24 -1000")
References: <20251027232206.473085-1-roman.gushchin@linux.dev>
	<20251027232206.473085-10-roman.gushchin@linux.dev>
	<aQD_-a8oWHfRKcrX@slm.duckdns.org> <877bweswvo.fsf@linux.dev>
	<aQEM7LXpZdOpsgvU@slm.duckdns.org>
Date: Tue, 28 Oct 2025 12:54:16 -0700
Message-ID: <87cy66pztj.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Stat-Signature: dtncb6qinkupeyqfopkijojc7iakmqnz
X-Rspam-User: 
X-Rspamd-Queue-Id: DB8F4180002
X-HE-Tag: 1761681266-107344
X-HE-Meta: U2FsdGVkX18oKgT4eMs+Zd6MbwY/blhtpKaJKPs3p7mXtcHrhFF1Fi4j3biWQIEzZ2mROPph2ErUwceADo5x9hW0xHBBnQdARpKMhyljACtIJRrUvCEPFqnpiU97FHxw49lfcPIMeSt6oLg2kzp+WhKE5nArBmAKY+cY5/EVsJmJgY8hVc0/ICI+mqFu61LzY7N7/SE94qwD8wawFX/usD4GBnlgK+H3WBuBhpSuuXuwOuoN4lH7okHAeLV11aLFM0p4d4AVv6PNzW3MnIefqgbdJFaLp0vPH1Ynepbz4bZbCKSV7Xp1H6W+80Ypouqx+60EA1wXoQSxc6b8eBcy9zrQsvS8lCFML90GbG1TTUHXHVkPCT801WM5C0d2OvogGleTjdqTlr+WU8MoLxZ4AnSho57yAa5fGEi5/H/Kc+ID0hZwCQx3krAkSobOd/80r5+BPNN3hKZTuYsGuqtgELIIJKAzAa4M1eodN7vVB/RXZyvw1bEEkjQAVoBf4bvRzBNl+8QLeeCD6w/LyZtAxcBQfADLVcuFzSI8nI7OQOPfoCCBKmAqkeHnEAECXw8Nn+6FxvifTCdtTpSXsiKGF9RsitOEDhSUJfucDONhBLK1ATUabbzmu58Vx1rt5Q1oeJLdSfYcF4L8XcAFEcwQceMJcW0mFozNobhkpJrE+EqTN/AeqEgMvnxgTz/t9o+b/TyDUFqBlBlAbGU+Q+rkqpBgytH1nS6P/2A8SwrXzSeYZe0cEG8cYTeLdEVmf4Frpyb25EQpa090VlVe33hOJeNeCKH5evM9vdA8AjigmiR2GO/8b3QnDzELYUQ9FE37zofDB62kFkaZ1Sd7Iz9j9vHLeFAkXIrcU8d/u+DIInSPYBWL5/GPyiWBwq+L2U1UzGc8HM56NayRWiFE1dmNww4p3+12zr1sw6WN5Ft03Ly+ivCWAILyuHyhC2E/QKjdZBcv7yyqW9zDslco/vV
 VbAJhs7K
 ap0hn+wN3lj9i4bIF8G0IENcf4LHY7cphZNBIEHh5946lzBTn8m0nWWjinPkiSDwbvOEcOEiGGpZI4itbjORlFQPsTNUdMaECApwUu5BjSWhBGdmjl10D98wK2iaq1xV86tjgsZEbkljIG2bgakupWu+x6jomPeuDzqC/MZUgY3FruqKmRSuGdGpx8z+otlSekIvjiU6xW0Vg9UREGqUa/x1VYk7xsqIZxjk9qVCiD2DMlyY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tejun Heo <tj@kernel.org> writes:

> Hello,
>
> On Tue, Oct 28, 2025 at 11:29:31AM -0700, Roman Gushchin wrote:
>> > Here, too, I wonder whether it's necessary to build a hard-coded
>> > infrastructure to hook into PSI's triggers. psi_avgs_work() is what triggers
>> > these events and it's not that hot. Wouldn't a fexit attachment to that
>> > function that reads the updated values be enough? We can also easily add a
>> > TP there if a more structured access is desirable.
>> 
>> Idk, it would require re-implementing parts of the kernel PSI trigger code
>> in BPF, without clear benefits.
>> 
>> Handling PSI in BPF might be quite useful outside of the OOM handling,
>> e.g. it can be used for scheduling decisions, networking throttling,
>> memory tiering, etc. So maybe I'm biased (and I'm obviously am here), but
>> I'm not too concerned about adding infrastructure which won't be used.
>> 
>> But I understand your point. I personally feel that the added complexity of
>> the infrastructure makes writing and maintaining BPF PSI programs
>> simpler, but I'm open to other opinions here.
>
> Yeah, I mean, I'm not necessarily against adding infrastructure if the need
> is justified - ie. it enables new things which isn't reasonably feasible
> otherwise. However, it's also a good idea to start small, iterate and build
> up. It's always easier to add new things than to remove stuff which is
> already out there. Wouldn't it make more sense to add the minimum mechanism,
> see how things develop and add what's identified as missing in the
> process?

Ok, let me try the TP approach and see how it will look like.
If there won't see any significant downsides, I'll drop the BPF PSI triggers
infrastructure.

Thanks!

