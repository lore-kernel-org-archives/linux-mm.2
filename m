Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AED6CC87FCB
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 13:17:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DF4A6B0089; Wed, 30 Jul 2025 09:17:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48FFC6B0099; Wed, 30 Jul 2025 09:17:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CCBB6B009A; Wed, 30 Jul 2025 09:17:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2BE6B6B0089
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 09:17:17 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D9EAA134391
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 13:17:16 +0000 (UTC)
X-FDA: 83720982072.06.BB49191
Received: from relay.hostedemail.com (unirelay06 [10.200.18.69])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2838480011
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 13:17:14 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753881435; a=rsa-sha256;
	cv=none;
	b=L2W4RYHTumEYzGu9eUV5GgMbEdznCjv+jKhHbwjmJoYDQAQYjw07JqeDiVfff5ScgESDKj
	istJJKvIB1tBWM+YHoxZVYX82TInPD4NVKrUnknWD7SS4G21/4HrSl/cy4tNhy2lR+KatA
	Jj/5/opycg1CXJkJOzCxgSglgkqadgs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753881435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2qvQokF8cvGRuzE8UhB7feT9QVRoqI7R7zDmJbOB5Zk=;
	b=HnWdt3GYD89+qoqB+RVAVVv3/+bnzkL6ds133uS4CgizU+BxiBLKk7zca/ull8dGytB6gH
	li8Gd6UXF+ywatA3uYzkOpujwvYyvOFApMCayk5mxPdgduTDGm2sPgzkkVayh8kZxMqhef
	TzSiqgOh5gJ8AIiSME3/VqVS3uTCITc=
Received: from omf09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D242A113F8C;
	Wed, 30 Jul 2025 13:17:13 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf09.hostedemail.com (Postfix) with ESMTPA id 3AD612002A;
	Wed, 30 Jul 2025 13:17:11 +0000 (UTC)
Date: Wed, 30 Jul 2025 09:17:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: kernel test robot <lkp@intel.com>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 oe-kbuild-all@lists.linux.dev, Mark Rutland <mark.rutland@arm.com>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Andrew Morton
 <akpm@linux-foundation.org>, Linux Memory Management List
 <linux-mm@kvack.org>, Namhyung Kim <namhyung@kernel.org>, Jonathan Corbet
 <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v2 1/2] tracing: Have eprobes have their own config
 option
Message-ID: <20250730091727.7b3a8b96@gandalf.local.home>
In-Reply-To: <20250730191101.7e6203f21b94c3f932fa8348@kernel.org>
References: <20250729161912.056641407@kernel.org>
	<202507301452.JPAcMvT0-lkp@intel.com>
	<20250730191101.7e6203f21b94c3f932fa8348@kernel.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX182DQPiz/lC1rskcX/IUATdlgupZxnzmOs=
X-HE-Meta: U2FsdGVkX1/tPPiWpHI8TYw/1NhA5gPWAauOdQvPprILSBnwk+q/t5ftSbAYUXxv6duh04/2u8XgpwEVTm97EKr3RqK9rFetyzYWCLkx4MhSOL6CIrUsELFdMFCdO0ZmzZySUbgS1bUJM5/YYH5yVPJXkNz0FCcbgCLXNEADS/MzibX38qEYwIeE0zwYbz8Z+Zc7rotswMFhc6T/fcPlSS3AsgTrJvVouI775ZBdzGz4g12a5Ab4PxjVUe6NFoC+ui6wjNeKUgaXkcWUfbnc9dPNip2TuznSm6bi8LuLos7h029XFcsQ13ky572sJayDcI0+m2CczjshmB4SCeKwxz5IYfvGXHX4
X-Stat-Signature: x5kmfoc9dirxwaqpen1a8dee8h1esq1n
X-Rspamd-Queue-Id: 2838480011
X-Rspam-User: 
X-HE-Tag-Orig: 1753881431-485616
X-Rspamd-Server: rspam02
X-HE-Tag: 1753881434-619422
X-HE-Meta: U2FsdGVkX1/O6W75aW5djQ2LbtNBbYKSJ917jie6Jgf1D9cLsNKGVC9w+rXB+R9eRjfBJRGGrQ2RbfgrfNM7CAVGVsb3Td08q/LYkTKhq/A8pksX75xVOAw87VByuWLW5Th9dXH049SLPBsTzaq08Fh/ro95CossJFFYTcocYECL0yu7mgycELPMjEOVoa2IOscynThf/WUrmHfhlycCw6j+MWvqWxw17WTmgAAzNRns0K0gniXuQMqCAEvL4seVhK/J8s5ed1grKt9JYLkr7CkE08tAmq3WV+7+G6Z0adE9H7BDXFL0NTIqOaPnB3GtMqNhuVtaFsrha81vw5p9ji7fFgxcWRBGWzKHCyj0dtdBiz3fTWCUU35Pioljt6MCCoCFD0ni/wFXnl1in0o9she4z80F7qXtHLZK8NYD2yPmJ4fFopGRXj1aMl0veE8srxFz8/PYUZpf4AUT5nss6yKzhVEZm7NbYj3LCTyXuMgirU/k/gkc31/fwaUh42inXFcIElN0c+MY/S01wDFai9eqh0qyMqOQsYArZmo7WbsFAmKTjHGRFnG+OibYIkrhPHWXm6UcoGoQAnzy76UrYrkZSzC6H3QO+R0fGxd0208+CGfjpgaEsAF/M1SbxTqDHQZ83+rx0V2f1DfN9NnBtn3371TE1e6AGugYage4f4ZVvc5lQpgmEmkhwmE108ZfW6HyHJFwu1+OW3T/zG0hWbiWm+Bc7dik4JbEDhNJx8HD9pX+4JncuAE5VLCM6wNxhak1w2HvBJfsw/BRK+yFc64IpEAPpcl6RbziN+M9Jit/t+FUJ744gQCR5+lpO1bL0qiP5bKOApEcwOagxmTCdPK/HOyHDh1Tmfi8jmaqBxA9AaEjBKU8qPFuUjpL4eLfDZuu1a9arV+fRUkQRVHSw3uO6v6Dx2i+qWhAgNg9gCFjGPsV5CtPpg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 30 Jul 2025 19:11:01 +0900
Masami Hiramatsu (Google) <mhiramat@kernel.org> wrote:

> Interesting, this find another issue. Since this is provided by
> CONFIG_PROBE_EVENTS, we need to fix CONFIG_PROBE_EVENTS depending
> on HAVE_REGS_AND_STACK_ACCESS_API.
> 
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index a3f35c7d83b6..cd239240b0ef 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -792,6 +792,7 @@ config DYNAMIC_EVENTS
>         def_bool n
>  
>  config PROBE_EVENTS
> +       depends on HAVE_REGS_AND_STACK_ACCESS_API
>         def_bool n
>  
>  config BPF_KPROBE_OVERRIDE

OK, I'll send a v2.

Did you want to take this in the tracing pull request?

I see you already did the probe pull request.

-- Steve

