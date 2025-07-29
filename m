Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 757D8C83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 07:28:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 077616B008A; Tue, 29 Jul 2025 03:28:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 027C06B008C; Tue, 29 Jul 2025 03:28:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7F9B6B0092; Tue, 29 Jul 2025 03:28:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D8B956B008A
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 03:28:01 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5F0771A049E
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 07:28:01 +0000 (UTC)
X-FDA: 83716473162.10.FB872A3
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf27.hostedemail.com (Postfix) with ESMTP id A865140011
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 07:27:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=eK4w4i7l;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=8P2C9jOT;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf27.hostedemail.com: domain of tglx@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=tglx@linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753774079; a=rsa-sha256;
	cv=none;
	b=3wJB+/NaENRm9uP3W9IWJuKOtWQFxqOM7blB+GzSZ1M4yj+8nJeamrsCyp7ohj+hCY+zf7
	PQyeZNGxmao0A4cmyxzLrTP14qh/ckEOp84U34jjc/3T56dCKqZso69Z1J7B++SrefJ1SU
	l4hbFCCqne5Qe4TcpvOYgCq4TPvrBTw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=eK4w4i7l;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=8P2C9jOT;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf27.hostedemail.com: domain of tglx@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=tglx@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753774079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8bBYSTZpcRwKvIkblTZvAnTSurmf8yAiPann+WMyjBQ=;
	b=Z0z8sco7Vg2ytOCavDIki2WdOys86YYYgzRk/kXd3mBv9xhZZTPDUE+MaBaYkvwSbWVVVG
	qYDFlro+MYzt64B30eTzcvWFSPPK1whAfoM4buEQsjG6UEh+Hn3fVZdzyIBs8Z86dBzsQA
	HQHNPHfkhbRLhPAB4K1bTXxXEAZQzVU=
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1753774077;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8bBYSTZpcRwKvIkblTZvAnTSurmf8yAiPann+WMyjBQ=;
	b=eK4w4i7lYj7DJFTnZu+4u/xtfibAeUVwOCGmq28M6sv/FW7HGnKxpF0hv3K1NhBMU5JGO8
	yd6Bni0OIPp+rssxWbW6f8aEPOKLfQw9xomuwPvK+5fU3fItddhPKJQVMhOEdSMvtSWRfg
	V3VamnBKS9UxD7I2ejvhfuj5jXwmdsX2XnSnyz6j9WairOFbJM3BoAkCB/6WLXrUROM4aK
	QgtjFS8cQI3auT/EBLlOHx7iy45BKHBxxu0IwSEgrurubfawpexT1Sk3Lp20R6qvjs8OaV
	8LmVxZ5Azpl1uBJCELw0h0kjfkSvyNpWWitpc3UTx1/Qvgq/L/zIBAff6LL4BA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1753774077;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8bBYSTZpcRwKvIkblTZvAnTSurmf8yAiPann+WMyjBQ=;
	b=8P2C9jOTMPv3/SiXxbOC2HqnDfEuJZYCBPU5j0I5WryKLddPUv4BpvbMwSrbtQDpDb6WG2
	mUr6nKY0LXmtDzBA==
To: Oliver Sang <oliver.sang@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, oe-lkp@lists.linux.dev,
 lkp@intel.com, linux-kernel@vger.kernel.org, x86@kernel.org, Sebastian
 Andrzej Siewior <bigeasy@linutronix.de>, linux-mm@kvack.org,
 ltp@lists.linux.it, oliver.sang@intel.com
Subject: Re: [tip:locking/futex] [futex]  56180dd20c:
 BUG:sleeping_function_called_from_invalid_context_at_kernel/nsproxy.c
In-Reply-To: <aIgUUhKWesDpM0BJ@xsang-OptiPlex-9020>
References: <202507231021.dcf24373-lkp@intel.com> <87a54usty4.ffs@tglx>
 <aINKAQt3qcj2s38N@xsang-OptiPlex-9020> <87seikp94v.ffs@tglx>
 <aIgUUhKWesDpM0BJ@xsang-OptiPlex-9020>
Date: Tue, 29 Jul 2025 09:27:56 +0200
Message-ID: <87wm7ro3r7.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: zbbb19a6756jupsm56a8uz5igiqb64r4
X-Rspam-User: 
X-Rspamd-Queue-Id: A865140011
X-Rspamd-Server: rspam02
X-HE-Tag: 1753774079-571300
X-HE-Meta: U2FsdGVkX18B2iG3IkLVcaHB+amoky+nlQjx3J8oQOOd+QoOTTdVFNBTNRweWxIQyPvUsPwJdgSynmosYnrIteWND4sZPM43JQhSubmucAWXhktc0JLX7yUdc5AdVIkavs78ArJ1IdfpwuZvWEjQHc+hLBjQV2TuLSiKtpePXGZuYFbh+H+Q9glXVhpDTWQCySWkLKyOcbihL72RPxzAZnHY1OSLT3hkUmhKRYfa00weXtKXZRDJTlvaQhdNtHKx5ZRCVJbT8huafmf9yR1l7oCG7TBIhzV6Aa3avgkI99kQXq0IJv8nnzUOMJuxe84qK7joOBi7wsueBFjsNqqiWhr4SvOYKf4N3T2SdR462ffH2UKfjsCms5kAHRScZOuJpB/9Tv1jaSRKxtRoY0JVpK7tRRUdwdad0Qc/fAfjjn4NJ8/YmJSsLDlX5tXzqf4q5jTdvTjz1C8FgsO7gXc4zOXch+OEGWSEhhXNrMAOjY1xEReid0Fgqt56qUolcNZHFwRtFOcMHh0ZkEr2KrvvQEmt7o02kH/Bc5wQjZ4HmY/kFpI1GSHnxTiyYlVDbMdxFCm087+uwFySr7uxvYgeRpuKiXW0fwF7uBtISfYNuEhxEtH19LO5GteTRtBAk5jyZmFl4sNkGSX5FsqxsMf6NebxRAFgsM8Ste+hJk+IC8qm899erW27UUjVZ5RynePzqUZnsIXoLg3qeIN126Pc8VizYr2mk1XvybW7LQgoiFia0yDFojeSajSAjUE5eZ4GsTeqxofqQcRaLyqFj2tw3Hq5OZRKYLYIRTv8FBn9FM8ss3RD83cAviQQA8cdiUL5orfWPavsztzjwqq9rTmS212atG75mryAhxL9kD79AbYhXkg8QhAEHLWsiBOsySVIW+Eh2xEn2Ta/0iIChrvtZF3VjXExbOAOjpoPFZAJCQksM6I9mhUVwlasSUlrWwqn+tfNSXG8pmLVkCbU1ja
 twnd7DZ9
 nTNwbaQoIKmdVr7lNxTgd68Ba2nDmPrSH3LkuyIZ4Q+vNRewiPKwcQzFSTVFo6kfOCNa6hThnfRzK3O4mLDBlw5g637mMs6+yD9sGnNcB5F/Yi9oSSKfrm9Vtgm3vX1n/jJ7AHm8o7sgyTBb/MB4RveC7nIfse8IIjWqDX/lNBqQ/fckv04obJK725FZMgYnNDcIe2Nor9TWNNIE7pVXuKj4VaYDR6sQpqRJJGJnp3lUQwtI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Oliver!

On Tue, Jul 29 2025 at 08:22, Oliver Sang wrote:
> On Fri, Jul 25, 2025 at 05:45:04PM +0200, Thomas Gleixner wrote:
>> Can you please enable CONFIG_PREEMPT_TRACER and add
>> 
>> 'trace_event=preemptirq:preempt_disable,preemptirq:preempt_enable ftrace_dump_on_oops'
>> 
>> to the kernel command line. The latter will dump the recorded
>> preempt_enable/disable events and we can pinpoint the function which is
>> responsible for that.
>
> the config with CONFIG_PREEMPT_TRACER enabled is attached as
> config-6.16.0-rc5-00002-g56180dd20c19
>
> by this config, we still see random
> WARNING:at_kernel/sched/core.c:#preempt_count_sub
...
> but bot seems not be able to capture other new dmesg stats.

Ah. The tracer does not dump on warnings by default. You need
'panic_on_warn' on the command line as well. Forgot about that earlier.

Thanks,

        tglx

