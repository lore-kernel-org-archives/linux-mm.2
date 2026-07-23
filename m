Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44C1DC531CA
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 13:47:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BF436B007B; Thu, 23 Jul 2026 09:47:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4978A6B008C; Thu, 23 Jul 2026 09:47:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33B996B0092; Thu, 23 Jul 2026 09:47:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EC45C6B007B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 09:47:11 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 73EF91204B6
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 13:47:11 +0000 (UTC)
X-FDA: 85020167862.26.234F20C
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf26.hostedemail.com (Postfix) with ESMTP id C4F7D140012
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 13:47:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fdz4nRXt;
	spf=pass (imf26.hostedemail.com: domain of ak@linux.intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=ak@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784814429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Fpk2WKAWM+YPzh7ROaNhvy+pn5sojtp4vaQLCD7QZU=;
	b=KBEe06PNM4kGkIq2EAhKpM6x9/hb/JAI2xDUmdW5hFN4z00HLC4iXy16msEDvO/KQ9pNMd
	xHFiTlK4qc2Yle+Zg8UD3pWeKcUWMCj5rMe0ZwXdJ53M2sIeWdUQQTjCoDpCh1m1B8bPiB
	1yd0JGj639JnTauc4s8Jd0ki2taGdwc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784814429;
	b=ErdpprMuvTkRNlMG5cU54nZhwiAWeV9zJulFDxeFyZ8XPeIZVcqsLV/1U5px1giFqiwcqV
	xkOwltku3wADWfx9vrqJElwI0zvaVIlLhEXiR22jBs0vLMYWOp1QIlMvRZsKTgouBZUtHv
	WfjzvR6rjBE2B/ecxoQEq+AxCHQAYAo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fdz4nRXt;
	spf=pass (imf26.hostedemail.com: domain of ak@linux.intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=ak@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784814429; x=1816350429;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=TTOiuNpKd3ZCkUsJNnXQtcBfFIarUNgpz9bYK41z5To=;
  b=fdz4nRXtroDBxeS4KpceBLPGBWyc/nivJBjrYwdPLokxpGFhJ0o7MSBy
   qXGsZBWI3Dy9NmnE7t/wT9TI9+dlKz3+X9cerGLrOuiZstiubK2250ST+
   2ue/Qhic11jQNYk5b2kzauhHqwY//Q9vHdnlHfGABY8t/RIr3zeoNT553
   0sNAGokwH+hLNbVklnoximOpiy57YkdXJtBV9UhfZ8O3+djHcoZc0WAha
   GxuGvqTnfNyyEe5m4OgqfJDUhCzgUQxQ0pCblsGxKm+DOBTp4mVQrGokV
   2g0kdfGDecF8ttHKLRX43LI5M+vZust/KPjktFAUPM8nbK5HhDeoKt3+t
   Q==;
X-CSE-ConnectionGUID: E0CW7FOgSAiDwqLaY0iwsQ==
X-CSE-MsgGUID: +Xd6xE5vTjKIUZFCZLESZQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="88008514"
X-IronPort-AV: E=Sophos;i="6.25,180,1779174000"; 
   d="scan'208";a="88008514"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2026 06:47:07 -0700
X-CSE-ConnectionGUID: 5I8g06L0RzW2DP7JqA5g0A==
X-CSE-MsgGUID: b1+2gPZ+TkuUBaWrc2aoow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,180,1779174000"; 
   d="scan'208";a="261962172"
Received: from tassilo.jf.intel.com (HELO tassilo) ([10.54.38.190])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2026 06:47:07 -0700
Date: Thu, 23 Jul 2026 06:47:00 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Markus Elfring <Markus.Elfring@web.de>
Cc: acpica-devel@lists.linux.dev, bpf@vger.kernel.org,
	coresight@lists.linaro.org, kvm@vger.kernel.org,
	linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-gpio@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-perf-users@vger.kernel.org,
	linux-pm@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, mptcp@lists.linux.dev,
	netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org,
	virtualization@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alex Mastro <amastro@fb.com>, Alex Williamson <alex@shazbot.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Ankur Arora <ankur.a.arora@oracle.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Bartosz Golaszewski <brgl@kernel.org>,
	Bobby Eshleman <bobbyeshleman@meta.com>,
	Christian =?iso-8859-1?Q?Borntr=E4ger?= <borntraeger@linux.ibm.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Chun-Tse Shao <ctshao@google.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Costa Shulyupin <costa.shul@redhat.com>,
	Crystal Wood <crwood@redhat.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Matlack <dmatlack@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Donald Hunter <donald.hunter@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Eric Dumazet <edumazet@google.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Geliang Tang <geliang@kernel.org>, Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Ivan Pravdin <ipravdin.official@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	James Clark <james.clark@linaro.org>,
	Janosch Frank <frankja@linux.ibm.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Jiri Olsa <jolsa@kernel.org>, Joe Damato <joe@dama.to>,
	John Garry <john.g.garry@oracle.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Kaushlendra Kumar <kaushlendra.kumar@intel.com>,
	Kent Gibson <warthog618@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Len Brown <lenb@kernel.org>, Leo Yan <leo.yan@linux.dev>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mat Martineau <martineau@kernel.org>,
	Matthieu Baerts <matttbe@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Mike Leach <mike.leach@arm.com>,
	Mina Almasry <almasrymina@google.com>,
	Mykyta Yatsenko <yatsenko@meta.com>, Nam Cao <namcao@linutronix.de>,
	Namhyung Kim <namhyung@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pawel Chmielewski <pawel.chmielewski@intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Quentin Monnet <qmo@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Saket Dumbre <saket.dumbre@intel.com>,
	Shuah Khan <shuah@kernel.org>, Simon Horman <horms@kernel.org>,
	Song Liu <song@kernel.org>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Swapnil Sapkal <swapnil.sapkal@amd.com>,
	Thomas =?iso-8859-1?Q?Wei=DFschuh?= <linux@weissschuh.net>,
	Tomas Glozar <tglozar@redhat.com>,
	Vipin Sharma <vipinsh@google.com>,
	Wander Lairson Costa <wander@redhat.com>,
	Will Deacon <will@kernel.org>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Willy Tarreau <w@1wt.eu>, Yonghong Song <yonghong.song@linux.dev>,
	Zhang Chujun <zhangchujun@cmss.chinamobile.com>,
	Zhang Rui <rui.zhang@intel.com>,
	LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] tools: Use fputc() calls in some functions
Message-ID: <amIbVOIsOeZgcBZF@tassilo>
References: <48f2d61f-d468-49b7-881e-f00777db073f@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48f2d61f-d468-49b7-881e-f00777db073f@web.de>
X-Rspamd-Queue-Id: C4F7D140012
X-Stat-Signature: ek6qjzx3ncomfmuoizjyuxi9r7hpuagn
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784814428-44459
X-HE-Meta: U2FsdGVkX1+aonvkIZnCdjx0QTGttz8GelMIggJ7yFfSv8/q2vFnicihfGP/XxXP1OdkeioMf3s3OjV3O9oT9iOTn7e9kCt2+37tXnjI/xO6QRw1kPtlDs3zCuvfnZCRuELLihLTe1Fo7xfq/3aUv1DBfd17sRy0MtY6nfrD7AAbg1fMUZj4r9kyIKi/MUyYLmnmkHumGHXEWffCC35ik6XD4EcjYFt7vPHxzjg+c4oI912z8bVlBR7JV/ivqgDn6Cc7hl9NYsm6ceygAsSC2A7JuUe2mAg5o5zECQTHHt5obHCIrkFXr4dTUEoGgibUnqzFZg8hcCyydnq0urSBFJpJS5oM5GDT0aditOKW8EVsRdo+K5oCEslMbIX6t9Eet5M1piCoQHn6krz+5CjcUFI560S3MSBPuyxJyRxNq4ysvDBCMFivBi8UBFtYNSxiIBKYNesZo7T1fDJ277I+pclvQyOpisCV1xF9fzSKO9UZAWQBJgDsbOybo1MVHdHyg31MFUMhsOKHEjwwDRjL0FMJkPGlt/Yya+YvkwqimfBF3Wkd/mIvKVPjWDZZ+LNou8wJkN7BE/0ZL7zBhYN6fOfaUnIN/tEavPjWokegJqtMkwLKGN3G/pdk41BSrUbRbDSqTa730a+3/DmNkn3ngF3OR5hLvtozcHzNsQpXtrQ58lt18LMFXpmTbSB6DppMTzAGodMjfzgdI5ulhqnhNZrc3yowW9SF668IdBRUwzsXmPoDTn2+AwrBxgXpp6ZorqrqfUN0ytdEhybDN8W/DhEuVfsWOyZrUsx/xrl+hTNwDEQEG7f0qhdgtjxyOuF4t+vqnx8chZILkbukOCKzw6xoijhH/4R8wBIBUMPpR433fjG99jBjdFrMypD4ejSJAJqgzPmzpa5r+kSu7vMYWa825+IujhoFtaIJ1zKuHl6k92N/BYdaC1b4C+GC3FxLANnZgjjpKUqVu9i3AEq
 RnrvuA4V
 wEHylboWBt6FTXAeGz6OXQ3xq62VhVfhNqK1qwlKHpig86GRExXYzBs0ioie3AyBwX53itSytL1RkTZFxeS/wRjcbYOokLkjH6Wiveph/d9FlaE7c8OQ1GiI93Ft57Rl+lQSl6Vz6lGS2G0tpMNybnWsCIIbN3twjg2+K8DmBWflXYPZ6mPmYC/bpN4GtFstSBuQBOBuokvjMa5BOzBr45GHKg9fhybYdbDJgtQ7bqfuTNSEHWAOLjM1+9n4jgUf5EWVzjjMimJJO7y4O86mlb9TmVZsXT0UDMMbSdxZePGYT+01wGT5erWd2cuo77XU9fjMhA0v1p//GEzYnGqfQUtEhQESEWxr6ip2iBVe94SSO2eWuoQg3OJjvEwT74NTkKCwj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 12:25:25PM +0200, Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Thu, 23 Jul 2026 11:13:30 +0200
> Subject: [PATCH] tools: Use fputc() calls in some functions
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> Single characters should occasionally be transferred into the output.
> Thus use the corresponding function “fputc” (or even “putchar”).
> 
> The source code was transformed by using the Coccinelle software.

gcc already does this transformation automatically.

