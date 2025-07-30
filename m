Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 015ADC87FCB
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 22:08:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BBAB6B007B; Wed, 30 Jul 2025 18:08:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16CDD6B0089; Wed, 30 Jul 2025 18:08:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 083046B008A; Wed, 30 Jul 2025 18:08:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ECBAE6B007B
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 18:08:45 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8ED031A056B
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 22:08:45 +0000 (UTC)
X-FDA: 83722321410.09.0562ECD
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf13.hostedemail.com (Postfix) with ESMTP id F27EF20006
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 22:08:43 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N221wvIa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of mhiramat@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=mhiramat@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753913324; a=rsa-sha256;
	cv=none;
	b=MFguZQj0R9EqADpcVCrHG3JkRgCB9jcAG2f+7TVMMtdctze5qt++4ExBPcgwLijbyHpHcw
	nE2FUrQaNai6e5OtUTnSV/qBITBiOdBWbdIMYADLYThoT7awIxc23yCl7prwbeUwBx81Ge
	eyPlj8nzZoG6C31cIy/DD43IrX/vXjI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N221wvIa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of mhiramat@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=mhiramat@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753913324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ld+hI02OteRejuFWmCXsLMKZto0vVjGswAQltgkpHs0=;
	b=ru1o56EcItWWsMmX5XKG/hCqKn+fFwJOdJkmaWBUNxbo3rkaWr4orRVDkQN4Lclpm3NjAy
	VwovL1dOkkXYtRQSsqrA1kthODTFKr05/mXoDFAGrhzACnjYRH3U4kIiXIyToXEfad8A1J
	ITeO0HtqSd2NOLqezuJTSof/CxaTtXE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 34E6AA554F5;
	Wed, 30 Jul 2025 22:08:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC94CC4CEE3;
	Wed, 30 Jul 2025 22:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753913322;
	bh=5DzTqdWYc14PEiKnsSSikRhRB45dtYdKZX03jUMGTgw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=N221wvIanmHlfTpJcA+rlcJpNPH8kjj3O44sk42ouZRnpMFr8DprkUAqN0EAQFlLc
	 hEup3TP40bmw/eoSvLPUf58EE2tRdMLmBAJEsl1nBLKlsnKUoujL9a25mONcEGFxL0
	 mvRLqv1pkIOHGNO2WPvt+XWI6FZshF5ysUad9nenV1gsZlw0bjqnUam5EzbObopD4F
	 vyyehZwoeCmOehW55Qd9QtCqwft11PIS36V1ZgYYTrPQOJvRCxjoMvnZe0NjaIR5VM
	 UzoTR91CQkwZtLPaKECJRtEMeNKAN2ImRKcFcPE4WTJjo2hw1WlJRhad1MAn5ZccVA
	 HlZHxAKk4QgIw==
Date: Thu, 31 Jul 2025 07:08:36 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: kernel test robot <lkp@intel.com>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 oe-kbuild-all@lists.linux.dev, Mark Rutland <mark.rutland@arm.com>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Andrew Morton
 <akpm@linux-foundation.org>, Linux Memory Management List
 <linux-mm@kvack.org>, Namhyung Kim <namhyung@kernel.org>, Jonathan Corbet
 <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v2 1/2] tracing: Have eprobes have their own config
 option
Message-Id: <20250731070836.69c43401858db35dd3b43ff0@kernel.org>
In-Reply-To: <20250730100155.268d2442@gandalf.local.home>
References: <20250729161912.056641407@kernel.org>
	<202507301452.JPAcMvT0-lkp@intel.com>
	<20250730191101.7e6203f21b94c3f932fa8348@kernel.org>
	<20250730091727.7b3a8b96@gandalf.local.home>
	<20250730225722.c88d2dbd3dfa07310de7edd4@kernel.org>
	<20250730100155.268d2442@gandalf.local.home>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 68mggb4ihyjw31a83onjxwcx7s8mj1dy
X-Rspam-User: 
X-Rspamd-Queue-Id: F27EF20006
X-Rspamd-Server: rspam02
X-HE-Tag: 1753913323-660102
X-HE-Meta: U2FsdGVkX1/tkveFtUHbmQQHxvYsz81hOiFkBLy8QC/qnHNoAU69DfRKQ2mP2Ll915/rDukKHZ9oP5VuMgnY3pTjJnPy76xKD7sz5F2T0Ibb8FuwjKordvPPCmqljnvhx7bByCI3MDV5oAybGYY9Ov8P0/kVKNiH6WPAMgYqoisg7hO2URlkrvG0yHdVXqfma1oulpUJiKdumAkBpcxRMQoqIvfqi30pWEbPIG5KF4B4GQ6ySYTN6lQQaVdILr/SdRsTDPxExETA8KMFaB1hwZW8hCfQLt4IOT8GI2pDP/Q86L2rZGxhdFDNVfVC3rA7Ll166Sx8auyQCByM7rVAivRUHncDZiBXh00Am9uyHJxQjfWYe9DxZPgiOunKCPa+Q4Z7elUOvQYq3u0R/HTBv3aQxgbkJs+1W+DUShKVDDiSgorzODMAiMMj8ojIQrmcadBKrtdWDQxPPUOLpM40mrbe6hsS+l4KEvoxOvR0hE9/ePBsdTc3foVhEOi4AF4iSgqnmg6V/uusfu6v9EQyCjUfjrxrwqhIPgekcPjxTjT5+Hk6MW2vqM6crRoNe4awci4Shkkk2IqjJAzv84EeRXSW+KOYElIk6mApDzavqjZXrDxFKsIE8Fl7Sax6d27C3Pt1FxAQ+JD2p3ifsCZj0pMMjbX61abit32p1ZM0w2n/WGINK/6royrPiAWgrVuhgjDZ5aLZWkMoEdIe6moRBd70chltose9ibRSLL44WWSWpcFAjKA6YQPrR7sqRilOMdab8i2yUU7UKJQByN8poilL2TbqK1bL90ndPBevmUbE2OGE5v7QOSbk8qJ9O5JwUeX2ar8W8N0aL4bWAWpb0Or4eJvB+tnsi55pMzZLK0cyv3qQsYcZOrimqbC0oxA2G8OQwWcIZ/dhKj3bEq4SnXjVckvlDrtI3El5YDTcKrzJ70adSdo4P9woMxY7DskzI4EGfXKlLYEcDqLYOID
 tNdX1ijL
 zT3JzI72wKeMS73LyunpvNmMaawiTKNIUljSPNtKoj6v0pDDWxVSn3Dtwf7JOm/7zJ/Vg4+z8OHWDRpUSkaDj/fbXroWOjGX11OUTX9hXuyj5RDiPcgUuyEhwKODDOjYfiJJwvrOhZWKa3D5rGGgLDQzQ49bPNtMEPXlJMm3dBZlLKoosUeFQ4NfdKzktr6CzPitPpllHygTqET+hox6mN5TExnjLwu3XfgxxcjLlG1QQps/UYGW0lbjp1tsNjwsn6vGNh491BSrlsRvcW7uWgKNt9XnooJEx6l7/RBWDBpI/DbQwAAKfRGSeOgEcZoKVtrXijV7JpNoEpqc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 30 Jul 2025 10:01:55 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 30 Jul 2025 22:57:22 +0900
> Masami Hiramatsu (Google) <mhiramat@kernel.org> wrote:
> 
> > > I see you already did the probe pull request.  
> > 
> > Ah, I thought this was for the next one... (but I think it is a kind of bugfix?)
> 
> Yeah, as its not adding eprobes, but just making it configurable.
> 
> But you haven't answered my question ;-)
> 
> Do you want to push it to Linus or should I?
> 
> I still have the trace/for-next to push (I've finished testing your last
> "attribute" patch and now I'm just letting it simmer in linux-next before
> doing the pull request). I can still add this to that one if you want.
> 

OK, could you push this to Linus?

Thanks,

> -- Steve
> 


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>

