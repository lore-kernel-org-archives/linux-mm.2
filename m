Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0827C83F17
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 12:34:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68E036B00A3; Thu, 31 Jul 2025 08:34:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 665986B00A4; Thu, 31 Jul 2025 08:34:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57BB46B00A5; Thu, 31 Jul 2025 08:34:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 464776B00A3
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 08:34:22 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D92651DBE1C
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:34:21 +0000 (UTC)
X-FDA: 83724502722.21.E32C1C4
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3232540005
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:34:19 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=4kozBWDA;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=xdAvVktV;
	spf=pass (imf17.hostedemail.com: domain of tglx@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=tglx@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753965260; a=rsa-sha256;
	cv=none;
	b=TYezWO/kaC86VGO9nUNT2aM0NUcDlAS4VB4RFwF/FNHzggSLYTO2UBJCwJnUZi/XFwHwOo
	jw6wLOyINJxKbqM8+D7AwB+8rrPlJ70Wg6xNDOCFeU7JBPOWsiUIH4GTIxKc83OoppINpq
	IUPFVLzPDdB/jJ8Um08v5jML/clC5UI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=4kozBWDA;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=xdAvVktV;
	spf=pass (imf17.hostedemail.com: domain of tglx@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=tglx@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753965260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=piJPPQK15+eacRq11wpIMXBC/ANS/3ROU0AjgU8/DEw=;
	b=Mr6l/aYm8bsKtQsNtW5FyhppdVYb774V/GBJcMuWq+lOZwupzhCnM53Uu5/8u+r/uqFW0A
	z3s8OiCwTfhLbw9FyB+7Bd8P/KVmTa1tpeIXxkrUqlZPDQC2KQ5lYhhguxJTGMEDQIGTrG
	BJD/W2aYNJGzKYJZruc1h+RrBuUUOWU=
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1753965257;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=piJPPQK15+eacRq11wpIMXBC/ANS/3ROU0AjgU8/DEw=;
	b=4kozBWDACIVhk4AgSuW/LaKzqZqADa6eKZMGovRkMoOf/hzdNjOpwtk8qagoGPrIWVZAG9
	xissf/I8eiGpk7XaKSz90Ag8avWnR19R5ZV0tUKIih9Uv5pi8r91+7Nym6Qdaeqle85DL/
	xzxbzFCkWyqVOZSFGS9xveczlMO4v85xXNe2DJR5NbHvSVrLnojhHUzOAhWphaLMtaVBbi
	Wiwj+t2kt1kO3PXeebnupBSEbO/shcHDWGoYVGr06cvfIgQWpTSq3g/WIUoWLlxmQawxbR
	SfbXH6Z68mTgyNSnCoztqDKb/kbtz2nB1ISFaEjTf5VypiWKVXhs/1T4BXmpcQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1753965257;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=piJPPQK15+eacRq11wpIMXBC/ANS/3ROU0AjgU8/DEw=;
	b=xdAvVktV1g1FyNPxMs0xsHnY1ekC79OJ0tsUeBduMM8PqPzOb1qQE+MUlHSyRMdQAHFOn9
	jgz20NZw3U6fN3DQ==
To: Oliver Sang <oliver.sang@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, oe-lkp@lists.linux.dev,
 lkp@intel.com, linux-kernel@vger.kernel.org, x86@kernel.org, Sebastian
 Andrzej Siewior <bigeasy@linutronix.de>, linux-mm@kvack.org,
 ltp@lists.linux.it, oliver.sang@intel.com
Subject: Re: [tip:locking/futex] [futex]  56180dd20c:
 BUG:sleeping_function_called_from_invalid_context_at_kernel/nsproxy.c
In-Reply-To: <aIrJipeLsGUM92+R@xsang-OptiPlex-9020>
References: <202507231021.dcf24373-lkp@intel.com> <87a54usty4.ffs@tglx>
 <aINKAQt3qcj2s38N@xsang-OptiPlex-9020> <87seikp94v.ffs@tglx>
 <aIgUUhKWesDpM0BJ@xsang-OptiPlex-9020> <87wm7ro3r7.ffs@tglx>
 <aIrJipeLsGUM92+R@xsang-OptiPlex-9020>
Date: Thu, 31 Jul 2025 14:34:15 +0200
Message-ID: <87cy9gilo8.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3232540005
X-Stat-Signature: fnbbfktbfxo6j73xwrxfurqrk8ru53cd
X-HE-Tag: 1753965259-719771
X-HE-Meta: U2FsdGVkX1/Vk4gdaV9u5TnogPTBIMZTKTMrcJkGnDrNwLhtYcoxXRwN6uKsIH3CdbUiuaYECH5oM76Qz7KwvKDzDqmifHMp7IiOKaalFf4iNDF/MftP9OFHVwg/ZNiOr1cceHadmYSmUOCk/gOhmvXs8Q0EpSwFaT9gpcTFAe/zvOTHTpRp5/patQiqnXJkjkgAIHMKkSCsTC9lVWPBBjKLYzWxtoZmBQxFUz1MtYOKwTxRs+5c3DWjSe2HqvT9uVBw3pR6VEtqhV0D99K0YDJj5L362JTknu7HIwQr6o9/FEf8X15Umob6hKQ59G7ziQAqBWsYIbYApMabYyFX2sSoGcJMT1ILilQZGPB4mFSCXi4HVJ+mm1EV9Y4L+ELwsRS31Sp5pW8x4Q0XruMirYWFPczcopH9o7688XD+3miakQvUgqBJlJTldlswuqiuKWRypadF93L9ayRXIYX2GgrDtijOvZ5Cln4jJYGqP80u9Zj6O5hozjmx8uIroX95Kd8lhVpnZjqgYivUxrJJzPeUUjWq+wywecLPyGuOSpBK5fuo0iXuUhbmzvVB1eclcDhD0s+P4OR5fkM/eX3FjAyxmSekcCgzcK6taDDi5XTBxj2VeSRUoC8CUxoqY5/eyRwixTJS5Md7jIWFlFDLUI3+HynlfxAs5hsvW5KpJ5J+vtoPK3FpWhqB+a+vD2iu6yZXQjqHuqm1iV6dQWUnQ/0bHKp0J4rfgu7187LLD/RJfIcFGTMx16EyGSmxDeuSncuQlO5xZ4gX0SSOdSpyeqjVSHTVcTYzHi7sIUokgTFBom7W6ywAxRRjEic2wKRhrAQ6nSSAsOmHPl0C86019yuce7M45wJVWLkqICWhaKxYoRoEQ9GbfZCiiuXnvY/Q7GRGJDoK5U18u0qUAwZiskYqgHmapFIcOhowIxxSB8hiefyLYcW9CEOkq5XpCqdTX150bXbqkYxAl+wDES5
 cwqH82b5
 MTM1EqKw/VFykjiUPoguZdjiLBB/ESSLEhQdcl2lwiMYMccnPq/x4+x/v18JWXtTT7V7z8XWLH3gZILiyQwgF7ZM3PaB92pWpfLN4+HedVls7hHdbvJogapTISWwkUsnNdnafi9oxt21A/ty1+SJ6AmeVN7291PzARQ+znO9GQaF0RiZep/ocMVyLrjYc902P9SPGpm1WcAvrnClOlGQyPA4ZwAKZkIvwqnvn5y3AcryV2fo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Oliver!

On Thu, Jul 31 2025 at 09:40, Oliver Sang wrote:
> On Tue, Jul 29, 2025 at 09:27:56AM +0200, Thomas Gleixner wrote:
>> > but bot seems not be able to capture other new dmesg stats.
>> 
>> Ah. The tracer does not dump on warnings by default. You need
>> 'panic_on_warn' on the command line as well. Forgot about that earlier.
>
> attached one dmesg FYI.

Hmm, that trace dump was cut off before it completed by a reset
(probably your test timeout).

Either you make the timeout longer or try the following on the kernel
command line instead of 'ftrace_dump_on_cpu':

       ftrace_dump_on_oops=orig_cpu trace_buf_size=100K

That reduces the output to the CPU which triggers the problem and with a
smaller buffer.

Thanks,

        tglx

