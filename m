Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F5B2CF58C8
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 18:31:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3EA96B00B8; Wed, 19 Nov 2025 13:31:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEECF6B00BC; Wed, 19 Nov 2025 13:31:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B6866B00CA; Wed, 19 Nov 2025 13:31:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 86B3A6B00B8
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:31:28 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4D6611A060E
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 18:31:28 +0000 (UTC)
X-FDA: 84128199456.09.8C3EDEB
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf17.hostedemail.com (Postfix) with ESMTP id 391284001B
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 18:31:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YQ2nvujD;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf17.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763577086; a=rsa-sha256;
	cv=none;
	b=G5qMNxfFLKpMxguAo000MWNDt3uzBb7HjAlumWPJnOqXoVJ71rWt/OW8pTWiz570bhv+8s
	zQDMRbBpTlUcnmj1sV/6TS2UISSqPqKM7+Ws/2dJ26SnS7KCEPa56n+HU2KANxZ8fNxtxc
	zluo8AcpUfGAYwFQcDZUy9FsJtLBmQw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YQ2nvujD;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf17.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763577086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=weGVutQ2LTuyRrIexKGakHWLwRw2dTGcy6nHgc/mlhw=;
	b=KM8HXCQVmMCCDvOsjLEB95Y5xRuMkeVzWGMA+3PFYjxLrp1lsnteuhHDa5Tt51teT24rTj
	G+Ebg78SpIOc6G7r1i1TurllUJxQCCLMpnlE/9a+KqDgH2RtM9CbgjPUxoDBKu5i+t3Nym
	UMjPFXolr9A7Q6ubnWRifH0TRIj3uIg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763577085; x=1795113085;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=pBP4WxWi6I4i104La5ws6mRE/2XC7eeQYC/wQJDGoBY=;
  b=YQ2nvujDodvWu6010osbqdweVUNB5oDMLcDQHF1ZzhmvnGY8K5s1wgxU
   qLArEkTIzRoSISwQmQhCoesslZPqKl1KT37atLPbr1tXWmZd/DSNl1u79
   XZMBA16G5/MmMPNrZqTb7e+PsIvwDVn43nWbm1xmslnU417IZtSN5TQan
   1aEi2LPTRVnK3mCCFBipsxHJhhO+fuxt67874FtqAOgH+R6yIhxIPoV2h
   AZWWq5u05TFWOuygSWv3O4ZMq9GXRT0k+6+hAwNK0o6ffOR01X+gmDzrU
   3KjUV0Jmb16gRLWUCpbwDcOta3Az3reaIZ1hQtoDK3HoYMgaEaL5l54pZ
   A==;
X-CSE-ConnectionGUID: bNf4jI6RQoS63pvR9NcESQ==
X-CSE-MsgGUID: LFH57VxcSTaTDng940c9TA==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="76989260"
X-IronPort-AV: E=Sophos;i="6.19,316,1754982000"; 
   d="scan'208";a="76989260"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 10:31:23 -0800
X-CSE-ConnectionGUID: ETFqZbkiSxuEEInIP9he7A==
X-CSE-MsgGUID: 575tS8qWQsWLw7+HkqlsHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,316,1754982000"; 
   d="scan'208";a="191160594"
Received: from puneetse-mobl.amr.corp.intel.com (HELO [10.125.109.180]) ([10.125.109.180])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 10:31:22 -0800
Message-ID: <bad9eaaa-561a-498a-90d1-fe3a3ab8ba37@intel.com>
Date: Wed, 19 Nov 2025 10:31:21 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v7 30/31] x86/mm, mm/vmalloc: Defer kernel TLB flush
 IPIs under CONFIG_COALESCE_TLBI=y
To: Valentin Schneider <vschneid@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, rcu@vger.kernel.org, x86@kernel.org,
 linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
 linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Josh Poimboeuf <jpoimboe@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Arnd Bergmann <arnd@arndb.de>, Frederic Weisbecker <frederic@kernel.org>,
 "Paul E. McKenney" <paulmck@kernel.org>, Jason Baron <jbaron@akamai.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ard Biesheuvel <ardb@kernel.org>,
 Sami Tolvanen <samitolvanen@google.com>,
 "David S. Miller" <davem@davemloft.net>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett
 <josh@joshtriplett.org>, Boqun Feng <boqun.feng@gmail.com>,
 Uladzislau Rezki <urezki@gmail.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
 Masahiro Yamada <masahiroy@kernel.org>, Han Shen <shenhan@google.com>,
 Rik van Riel <riel@surriel.com>, Jann Horn <jannh@google.com>,
 Dan Carpenter <dan.carpenter@linaro.org>, Oleg Nesterov <oleg@redhat.com>,
 Juri Lelli <juri.lelli@redhat.com>, Clark Williams <williams@redhat.com>,
 Yair Podemsky <ypodemsk@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 Daniel Wagner <dwagner@suse.de>, Petr Tesarik <ptesarik@suse.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>
References: <20251114150133.1056710-1-vschneid@redhat.com>
 <20251114151428.1064524-10-vschneid@redhat.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20251114151428.1064524-10-vschneid@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 391284001B
X-Stat-Signature: 8ejt9mtmcjwqo655s4hrh8o45k6nqdc4
X-Rspam-User: 
X-HE-Tag: 1763577084-842545
X-HE-Meta: U2FsdGVkX19ttCWaXbzLn3RbSRO2gijYIMT/Bl1IuU3hEsqEgVLX0Ei9yn4eOl1YyIiTDZzMpGdRmms5EpLhSvwrlzoO2whdAfxo4zb2iM1ThM8K/KO/UD6fDEINVv/jLE/oBtgWBQSlRg589sfERy4WNiEiQCnMIf1Q2yfnJjpw3nNpGtlGVUU4+BAl6ni+IJsrcVumPuU20yfeXD9r3rNHdRlHXCxsf7+bAhpXNANAkakCP5lB74xbZY0J4WfeHzE+267I8IhXOb1LLan+RPvaRsYoLfclbbnMi0yKaUSCLdf0x7QuxuUcqKj30hFvfadoZJxRVMYKUziHd5kzUXED8LRRAhosboBflZpcQCNDe0Xz9RecFq6s2P1CXyhEIlh79scE2FFOO6BZn6ZtFEVFos5NddnI0Lc9gvaxcU/ZVkrxF2VV7Su0vBVF45uICIsCqIvs2s8LzBNCpqE+VZ6cDvDXmHH/BPjGJDyUacfMe5OxkZqSdovHQeby8EqYEWYngPKbsqVZMi0XBUGxyXp6a4nukAxQJndscPn5yqZj4qajCFO0CQzOyoK+rtj9++Y7I5a6MVuoTG3IxGDg4rtz5gOhEdG9WeCjkVeR9D6pB4URCR1N3w/uXcHy4JAOmcJX/LqG91VKawUyZEY4feQ+j47mcdEYAJ2LqqRpRwA8ctOVnnnq38Dsfh+jbMQdlkkeVq5ykrS/2M9kYa256qnxl7LypmszpG5JdRo/0kBD2UIlm6Z49vy/1F21qOetZphcNZmQGLAwqBi392s5veBu1caPVr1M1IGwpdE+EdtKjFgMVx8s9jycvbiVGaeCwPLUxlgfci7AeCxRvxTgq4WqiBqx83MJmLKo/lDGwvevNHkvaJy9cnrU5eOwoC84LcTf2qk7BBHL+jfJ8G0nF+hQgV9rpYjLRVtmKsOLy6WVtBmG0cYXgXp6DZaTgYOaqioBvXorDD7j1ZUC08L
 FvKNH/p6
 MLDEtQ+fq11UHUJf60MgQ0VJcqucRxT8uTxwKvhYsi7J/e8j6KKrmKNVjP+tyU+s4DEGS6/Rz0gcDaKFsxlY463skvMKTRwLpvSVQI5+F67+B3mKkP38WMlY+W2RXkhNSCDJ11h6LZGgFi+Vi3gCvOS0KNbe1m7mm1siegul0ULDidsbVYQd601iiLILBiP9xN1gGhXVyLkfZnXBLaYiQ7CoYj0Snay8Oedx9/sVLCo/4243QO18cQYZAfNPQ8h0887Kj8OgsUGK5zXlQwSR2fnsQVo3wdkBTInYrPX2M1RCdkC8gHvCerfmHIH1ZIwFuC49O
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/14/25 07:14, Valentin Schneider wrote:
> +static bool flush_tlb_kernel_cond(int cpu, void *info)
> +{
> +	return housekeeping_cpu(cpu, HK_TYPE_KERNEL_NOISE) ||
> +	       per_cpu(kernel_cr3_loaded, cpu);
> +}

Is it OK that 'kernel_cr3_loaded' can be be stale? Since it's not part
of the instruction that actually sets CR3, there's a window between when
'kernel_cr3_loaded' is set (or cleared) and CR3 is actually written.

Is that OK?

It seems like it could lead to both unnecessary IPIs being sent and for
IPIs to be missed.

I still _really_ wish folks would be willing to get newer CPUs to get
this behavior rather than going through all this complexity. RAR in
particular was *specifically* designed to keep TLB flushing IPIs from
blipping userspace for too long.

