Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D85EBC87FC9
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 10:11:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72AB06B008C; Wed, 30 Jul 2025 06:11:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DBFD6B009A; Wed, 30 Jul 2025 06:11:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 618F36B009B; Wed, 30 Jul 2025 06:11:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4F33B6B008C
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 06:11:11 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F0AC080499
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 10:11:10 +0000 (UTC)
X-FDA: 83720513100.15.4138759
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf02.hostedemail.com (Postfix) with ESMTP id 57F498000A
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 10:11:08 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DrE9nbyJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of mhiramat@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=mhiramat@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753870268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Ic/4vS+0kyvSsHOoiWizjaKSS0dtTEDgcNQ3l9hjYI=;
	b=Jwx+sDD1cZWCL5kD/wyUfd2vmG417Ka1tekRjPxqzdGKs0RfVqaf7CZoblDOSZdaFTFays
	T4L5tBbBBit5LkBhjQHEVeW4/P8TH7sTGtr3oOWjF5zk2z51Am8KtWEz7Fzq6RFJvLDKVo
	Y1SXpD4goxEE/+4d3aT2YIOmLuU+E60=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753870268; a=rsa-sha256;
	cv=none;
	b=O7TfCCH+Z5d5gQ35eoFsU8AcLCSQpJ9De+dbm+wWrEoqSzsdn18xs68lUbOZ/L7UhZ0aWf
	wyPr6H096OVYly+0gbvdx2hpJ0XQqXw2kG9Xrx2HH48XqW8khTVPn1JLTIgk40fmIkLX55
	+ST1lOf4TFEv2ZvNjg9Zt/uxxwtlhFg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DrE9nbyJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of mhiramat@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=mhiramat@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 96599A55246;
	Wed, 30 Jul 2025 10:11:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 112E4C4CEE7;
	Wed, 30 Jul 2025 10:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753870267;
	bh=pnGxoS3OSecq/nhtm6H+J4Cjcuia3dKAU/NRqZLtAY0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=DrE9nbyJnXasszyzxe7vuARHwlZqRT4Egs8bU8yW7nxeMXKu+ofCfJWdWI9vY/1E2
	 f+vKgHulgbDiHWElrxhi7ziGMvehBIoDHfaXNhciy32V1IrHXC7o7NfJqC6Qa1qhfG
	 gVUuC5C5bZXcJFeK7Xunxz8EGdXxm0E3qJl118erF6tqja8IFneOstrFfOVPjqUSee
	 64gg/x0fiBrFdMENMIWlxKzvhcLDG3E77FBMts9mXKcz4h7OcWY1rcs+qfBE6z37KW
	 bMi2n1Rk1nSQI6WE8oz65iext9Ry6aWyphwXDVsoQJio8lnqnfii9n2bqk48yfMFt3
	 nmekez5FtSNww==
Date: Wed, 30 Jul 2025 19:11:01 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: kernel test robot <lkp@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 oe-kbuild-all@lists.linux.dev, Masami Hiramatsu <mhiramat@kernel.org>, Mark
 Rutland <mark.rutland@arm.com>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Andrew Morton
 <akpm@linux-foundation.org>, Linux Memory Management List
 <linux-mm@kvack.org>, Namhyung Kim <namhyung@kernel.org>, Jonathan Corbet
 <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v2 1/2] tracing: Have eprobes have their own config
 option
Message-Id: <20250730191101.7e6203f21b94c3f932fa8348@kernel.org>
In-Reply-To: <202507301452.JPAcMvT0-lkp@intel.com>
References: <20250729161912.056641407@kernel.org>
	<202507301452.JPAcMvT0-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 57F498000A
X-Stat-Signature: qzh899eopz89u7mwc1rinf4s7ysoi77s
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753870268-860033
X-HE-Meta: U2FsdGVkX19ipv/slLyTtcsA1HF0gPrrtHFOacWbQYne8CdC2Ki+bUN/Qf77piHSk9zL8K2To7/ebroINO5dvqhENFMy7Bm19ZsF7TNY9EfYV3IMUHLNgWTTQTWLAUXlrNrvwdlMkn34YvtI+CyVKBoZNozMxGkRTBBZ04erNlvY3HGdQG2hLfW6fAVt+1gh0Ni8M7S441NHvWzDIkEE0leVwYb9lMq98VYI3YFnlOCm7FW49IUMRrFUDmeFoA6qcfpxwSGiL379uoQwgR0pyC7aZHoOPnCqOoeJi0sa0TjNb8DCcTaFnOpJ0T0r6t8n9+RvSAVd/ZVk97deyeqN+A193MU7YxAevSLCS8BorGyzm778fHFkV4D/Y2rHLKKsUVVVXBd1xu1Ym3QPyNr9C1xzQoQAd9OwkM0KqiqEGMSpIoMj73TNgAmXHdUwHOzTDSBAPy0O58sBhcSpZJgMZ0aqJwgUiXXk8mSZYTUrVVjbMQbcgb2ALBl07uSQ5UYE8tNEK+dh3rYCluh1zm7G7276mGUmsReP7ZD9sbj0TMLRC20bn1jstB5rz3GUMXUI4kOCSebNNodYxzgeDzdG0nO4YETbAnGzz4vsIrkBfgEQ1UY/j1jB+rSP7lui0zQdsqFjXwZj/sPcYdcwJ3KuS1DWaHcKf88aNgYLAeolbcDiswkXPzlriF91qarKMMKGUzPwCvELUZnf1QCYBamXbAtkGrDwXsCXXjVrYq53wyCap8GU5qWXeNGmn6lWbdOwNDbzMNz8VSxiUwoVAKxQzzGF2EAC3L0zTJmy2khnv8QeSqMDpYK4c/kdjj6JQj/Cy3UNfYJ03YzngxaGz0jZUYV9ASulrOoZCBdp+B+8fNdH4b/QPfym1yhtLLLJRtVGqwVpOnz3k3390ZHFPZW3ERtm/Mvj4pFUuTYEwsMXCjqsYQb81/em90zPxjt1YYGmecXmiaH/lEe1kK3Miv7
 aIZ9sJ+E
 uhp/9twLtOaNqAjJrbluXC10DnXrRz2zMNgrKQld+t6rALp6JxFRhf3ehSx/0xz97TE9Sl53JK2QIAe8hyzUAJfgv48Syj/nK1fjCabtPZjVT9E26AqzmCV8mnSSZRLx0LhJiNZYu75XrhJ2fXJH28dJnK0jPDFOBMxZtMw/o4bny+PxSD/wA7pLtmn3Hjz7TB8b3YzsRxX86FDErQoM5N5XO+ivcE9Ej3gKyRm7HzBUyfNJS5Cnqo/t6zMMD//nOD6Cv3Mh3I6MlnxgibBqiJh0QdnNfk0yn8YQvTIJbnSkX/l3H+SYrvD/KUqfOJXslO8/+NCDVMbdQHR5tN9CNKsU/it60oLdd4GWY5GaowxsEhwx/qi4ogZmbutF+sIhkDZ7dpqf+3AORZ6GLR1RPzz+UwFLh7o14mggGW69aANHPB5otnZnleUG+Rg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 30 Jul 2025 14:27:08 +0800
kernel test robot <lkp@intel.com> wrote:

> Hi Steven,
> 
> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on trace/for-next]
> [also build test ERROR on lwn/docs-next akpm-mm/mm-everything linus/master v6.16 next-20250729]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Steven-Rostedt/tracing-Have-eprobes-have-their-own-config-option/20250730-001958
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/trace/linux-trace for-next
> patch link:    https://lore.kernel.org/r/20250729161912.056641407%40kernel.org
> patch subject: [PATCH v2 1/2] tracing: Have eprobes have their own config option
> config: xtensa-randconfig-002-20250730 (https://download.01.org/0day-ci/archive/20250730/202507301452.JPAcMvT0-lkp@intel.com/config)
> compiler: xtensa-linux-gcc (GCC) 12.5.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250730/202507301452.JPAcMvT0-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202507301452.JPAcMvT0-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    kernel/trace/trace_probe.c: In function 'parse_probe_arg':
> >> kernel/trace/trace_probe.c:1105:23: error: implicit declaration of function 'regs_query_register_offset'; did you mean 'ftrace_regs_query_register_offset'? [-Werror=implicit-function-declaration]
>     1105 |                 ret = regs_query_register_offset(arg + 1);
>          |                       ^~~~~~~~~~~~~~~~~~~~~~~~~~
>          |                       ftrace_regs_query_register_offset
>    cc1: some warnings being treated as errors


Interesting, this find another issue. Since this is provided by
CONFIG_PROBE_EVENTS, we need to fix CONFIG_PROBE_EVENTS depending
on HAVE_REGS_AND_STACK_ACCESS_API.

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index a3f35c7d83b6..cd239240b0ef 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -792,6 +792,7 @@ config DYNAMIC_EVENTS
        def_bool n
 
 config PROBE_EVENTS
+       depends on HAVE_REGS_AND_STACK_ACCESS_API
        def_bool n
 
 config BPF_KPROBE_OVERRIDE

-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>

