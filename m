Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94882C98302
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 09:01:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B5606B00A6; Tue, 22 Sep 2026 05:01:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 766096B00A7; Tue, 22 Sep 2026 05:01:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 654BC6B00A9; Tue, 22 Sep 2026 05:01:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 370506B00A6
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:01:33 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3E68316041A
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:01:32 +0000 (UTC)
X-FDA: 85240804824.24.671558C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9D48940006
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:01:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RKTk+bn3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790067690;
	b=ZvsIk+jAgv/gwsET7xJpqlJN/5iP1w7lV+nqeIRCoIBW5crJISbZP8j34UCDPbNdwGujXt
	8rzrn0mK3JHEmM2FgfqVPWdwafgjcrVG/SCdZaBk5EEBwq+PLbr1hFBl97nrM76uRdkpu6
	gAemN+NFv0FHWaYxgAf6BaOti3E0jXY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RKTk+bn3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790067690;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mjGPVOew5ysCF3WUc2TZ8QW0kJr9lTS0DgEOW24GPw4=;
	b=Wwn6v9c92FoM3shtpo3q71huJDW1KPFP9FyzUaPaAuefpHReU+IL+Mxsl0h2b/oLdUnhZU
	g7itGj1moaglyXg115t/7LlfCiRjzjoZC9iUo0pcSykb6I8J0Hx0nUucRNYopFMzBKKi02
	Uc/IP1jbsTo5G2ea+ltIIDE5FQVeBEY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1E75260DDA;
	Tue, 22 Sep 2026 09:01:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03DD21F000FF;
	Tue, 22 Sep 2026 09:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790067689;
	bh=mjGPVOew5ysCF3WUc2TZ8QW0kJr9lTS0DgEOW24GPw4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RKTk+bn3+WrRh+uEPi4QsKpCQMBXdiVXaebzTyFMU52JIHYsRCsBMfXvtU7rub77Q
	 c2fEr37xSa/FgKfpQbOmr0c9p9pK/zq6q4W/drmX1lPcv3vRb3icWMD4gg0qNqTTVp
	 uy4jqLPrcnvvlNYaJ71axxVw70rxXcvMAz1o7bQwK2I4DFT70VIVpDD/fsuuwVCvnA
	 gq5CeO6ZT33+PfALex/ZbfH0KlRpf3mb8fEQaBSo3yx6fPOHe5xxnwc1aQjElG4KjB
	 rL3CjuBhz5Xe/jnj1pnhwqK3B7MWS+9TGPt1ZlARHlpTuVgUjv3joyNdav1qEFlRuN
	 0jXrGWn1YgZuw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 7/9] of: reserved_mem: mark /reserved-memory entries
 with MEMBLOCK_NODUMP
Reply-To: sashiko-reviews@lists.linux.dev
To: robh@kernel.org, "Wandun Chen" <chenwandun1@gmail.com>, m.szyprowski@samsung.com, baoquan.he@linux.dev, rppt@kernel.org
Cc: aou@eecs.berkeley.edu, akpm@linux-foundation.org, pjw@kernel.org, chenhuacai@kernel.org, mingo@redhat.com, kexec@lists.infradead.org, palmer@dabbelt.com, pasha.tatashin@soleen.com, hpa@zytor.com, ruirui.yang@linux.dev, iommu@lists.linux.dev, pratyush@kernel.org, kernel@xen0n.name, linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, robin.murphy@arm.com, devicetree@vger.kernel.org, catalin.marinas@arm.com, alex@ghiti.fr, linux-kernel@vger.kernel.org, x86@kernel.org, will@kernel.org, loongarch@lists.linux.dev, saravanak@kernel.org, linux-riscv@lists.infradead.org, conor+dt@kernel.org, tglx@kernel.org, mark.rutland@arm.com, bp@alien8.de, dave.hansen@linux.intel.com
In-Reply-To: <20260922084256.1515554-8-chenwandun1@gmail.com>
References: <20260922084256.1515554-1-chenwandun1@gmail.com>
 <20260922084256.1515554-8-chenwandun1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 09:01:25 +0000
Message-Id: <20260922090126.03DD21F000FF@smtp.kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9D48940006
X-Stat-Signature: ac38oxs8uyaj8gumkxhfod3nnu4q3oa7
X-HE-Tag: 1790067690-820795
X-HE-Meta: U2FsdGVkX1841bcikHzoknIxuPArJZAhsUb767NPC5o70q+PID0icWdbixqLtVD30owoRInAxPY8Z7URty9hy2CGoj05jDnf7xCbSdFLjRQOZ2ErUhs4odGGyQh+rlwmMexsVo3l0ARA4PIqvUVOInl0Jp3Cu0C2atcGXNow0Z9oloBF8OkbtJwo3FeimyO+D2ag3BB/NVTF4VQR4fsJb185dacC05tyXA1G+HH64LjCXoE+Ttv2mvPDUG9pTkSdWzfb/2eUBa9Rnza3vqFLaE2oe5UUi8R7aR3EKv7x6GAODqI6D0fYRxSASfoUg+Ui7oj7amIpOfBr2RZyFapJ2RZfTTLm4P1sGsnmyttnTJW0I2a2xaG6etGyDHePs7GvUUldrLRfjtxl+he2NWWdLCb3yKTUODk6pLZ9qzuRUEFpj5EI74QAN4S+1dO/uIamkwHm28gjjaVIbcN+E9l9RKJKy2HemhiuZz3oem6h2BYzpfMnTC6Po6HWzr2PT1HZTpCCWygEqp+5cJino8Q8zlQ6HaBo8e6KkFLovH2589DVv10Li7t6Z8gTfYjjnc/3VI5X5+nsbpJDmtUqhRiMKR/gYzY7okOpscqb7wPkdo92sbJ0cW/l+6TJjg0pbyFbERS1Sehevnd2XDHo30h6sOnDsT/a/n4WrO/f0T3Yo3VQOMBxOhDzL4ClMrJ7HZoID3cpY9nwBvJl6hwdAwOS+7ZU6NsCjpufFmls6DlPjk1RAuqJw3YNe1qpLoeDuCzGus2aRxBZCwMLlUyUhtsNRw1J2kozimd0gFLA8qhyDrfSpFoJPWSax9CHilFTd3++bMuy0Xd5APtqdl5u8XwK/wFp+kc3PC+ztLgBi6qc3gpbLtbaOe4mvsMYJAzxHRANZPIgnO/oiBikbXqgD9UIJVy6vf6g1UKOiUk4itKW6LFeSbNlOHGO5LDUVHSBpot4TkM0kRN8AfiGZyGS9gl
 UqboYqvh
 d3IyeQPcSUb++vrWtaM8OJwAfKEvFw1k23P2ZCkzlEFAM5MpO5m/od3CqdI0ZCsHwZFv/n6HRSFiAwhkdlxnyajVoOjFtAOlE5PmpWgcLXTx+TWEYeWtfebC2gjLI7O6UlRckjxw7v0+KIblXxd+rsZoXBqS7oDFnI6B+uSrtRHSCVlsLdXJDFCUQXDOz8AMGrn+OCLbdVEcq0Ykza4CfL4uNc8YEgISWfOYqMvaII0TsW/EnvIvi2yDdHMOJBfHzhw1WbZ6Ili0Wef/40sxJ5b44wPS19JL8OI22lxwb28kXKUMEiTCtdYLO+ArCk+z4xUZh3G7AyzIdqbl4HinR+PDIz7PioL784iw5umyFk3Y1kIVDF6kUssTw8ZR5zdN2bOqhBBLtt/oYhr2Ix1WhdfUhV+eb0Yw7nJVxfgAwsoC8dYyotqF+W5jQmoEaEP29ZC2QjNnFg6/cbpT8lBXl5DJRCWg+mYGGThjT4Z2hhHErx+twkEs+44waMBgvyX8I9Vgx4sGwqbs+wY3s59bQsNUKNdt9k5ElKf8HniXQ9jzIVd9tX3SBh6Pnek49quNFLNwpV0qwn+yNZkjYJJTpFerdcya6Qrd4R0gqv8Js2hR49NeHDLAC5LDKHCgHypBbcdLLQMXkw1lmtYBeUUE8IcNyBDiVTG7gfEIDuOuBtlDZQ0CjjXtEU5DBu5+V974YEwwc6yzOo7AWhhr+Eqc+kK88iQNVomSdC488pzt97Ylyqwt2NIM767OU3qwxh+FzCd15umtBQKWBcbirVfqSglJgs/mmG8wYo/a1AZ28SkG1AMNVJ41eK+9x6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] of: reserved_mem: unconditional MEMBLOCK_NODUMP breaks firmware de=
bugging
--

commit 70f4cbca539766519d8967f7e857d2db27db4c13
Author: Wandun Chen <chenwandun@lixiang.com>

of: reserved_mem: mark /reserved-memory entries with MEMBLOCK_NODUMP

This commit marks non-dumpable reserved-memory regions with MEMBLOCK_NODUMP
so kdump can omit them from the vmcore. The marking is guarded by
CONFIG_CRASH_DUMP to avoid splitting memblock.memory entries unnecessarily
on non-kdump kernels.

> diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
> --- a/drivers/of/of_reserved_mem.c
> +++ b/drivers/of/of_reserved_mem.c

[ ... ]

> @@ -677,6 +677,21 @@ static void __init fdt_init_reserved_mem_node(...)
>  	reserved_mem_count++;
>  }
> =20
> +void __init fdt_mark_reserve_mem_nodump(void)
> +{
> +	struct reserved_mem *rmem;
> +	int i;
> +
> +	if (!IS_ENABLED(CONFIG_CRASH_DUMP))
> +		return;
> +
> +	for (i =3D 0; i < reserved_mem_count; i++) {
> +		rmem =3D &reserved_mem[i];
> +		if (rmem->size && !rmem->dumpable)
> +			memblock_mark_nodump(rmem->base, rmem->size);

[Severity: High]
Does this unconditional masking prevent debugging of coprocessor memory and
firmware state in vmcores?

Since only the CMA driver sets dumpable to true, it appears all other
generic /reserved-memory regions (such as DSP logs or ramoops) default
to false.

Because fdt_mark_reserve_mem_nodump() unconditionally applies
MEMBLOCK_NODUMP to these regions, and there is no Device Tree property
provided to opt them back in, is there a risk that system administrators
will lose the ability to inspect these regions after a crash?

> +	}
> +}
> +
>  struct rmem_assigned_device {
>  	struct device *dev;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922084256.1515=
554-1-chenwandun1@gmail.com?part=3D7

