Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16792CD98C7
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 11:16:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58E786B0005; Mon, 15 Jun 2026 07:16:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53ECA6B008A; Mon, 15 Jun 2026 07:16:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47B686B009B; Mon, 15 Jun 2026 07:16:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 39FE96B0005
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 07:16:09 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 78607120A18
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:16:08 +0000 (UTC)
X-FDA: 84881892816.01.121EE0D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3183E140003
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:16:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cdY4lVPE;
	spf=pass (imf09.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781522166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3uCpF5smpc9mUAlnydhdP+W4oOPGRNWqN7XTyVAHkgI=;
	b=GZifELw9kn2T8MJmcgU75Rd4A/f/KmADnIFJYOeuPxzNOgXGxn8LOltv0M6ik8r23jqYwP
	kwDh9LHTxXl3Lu//8Cu7M+h6tOgbYKMdq46ouvQ8nS0QtJL4MNFC7U4rIsrCzxY3LGxJQ9
	DQaBqdL1bXDcVSPchMuGKfkC2sig0HA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781522166;
	b=TcEf2ysA1VHmywkOf9kW+TWmrdseDqYtTcQ6o0lvQTLEoIf5fe/gIHofWocFn9b6mVsRdg
	CuibkWYAdTvWiqE+N1dpK8IRJtfvHrB7H+Qc0i5dWK//FmZ8SxtAyIobfR6WNteGuUjqS6
	IsEQN60SFKxRD6KiZT/C4J2dXYE5eQA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cdY4lVPE;
	spf=pass (imf09.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C7194328D;
	Mon, 15 Jun 2026 04:15:59 -0700 (PDT)
Received: from arm.com (RQ4T19M611-7.cambridge.arm.com [10.1.32.56])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 17E643F915;
	Mon, 15 Jun 2026 04:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781522164; bh=Gy0LHTdLmlPA2i+iN2Je30fdWIJBmw4l6fKDIDT15Cc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cdY4lVPEYrNPl4E1WB89Pyctf4ei4UjwuF0x5VaUZ/uHD8RP//KUfcDlDlXD/ZTMz
	 4jsOCEDRAult1wHuB6kgB9dPNw4l/aXf3iKX5DOr7uzAVhOh5XiMoI801LGS3cOdFY
	 iYUnfiVA+rR0pNdM9dXCMb8naE0yjNA7UicT2d5I=
Date: Mon, 15 Jun 2026 12:15:58 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, lance.yang@linux.dev,
	Davidlohr Bueso <dave@stgolabs.net>,
	Oleg Nesterov <oleg@redhat.com>, Qian Cai <cai@lca.pw>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/kmemleak: avoid soft lockup when scanning task
 stacks
Message-ID: <ai_e7gfv5vze5tB5@arm.com>
References: <20260612-kmemleak-stack-resched-v2-1-53240de79e88@debian.org>
 <aiw9u4BllwZXDH2S@arm.com>
 <ai_EVJVfe42glgKI@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ai_EVJVfe42glgKI@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3183E140003
X-Stat-Signature: yhxxhfw5etnt8kg8ifebb1ab8cw8yqw5
X-HE-Tag: 1781522165-151713
X-HE-Meta: U2FsdGVkX1/HGcvcali+Zg5PCiRvBnJSe9o+ZxpHu2x6u/AFvrXGUJIGcJIWLj4zEjXSDtH/QVGpeZ5x5DsDOwsRLp3DmnGLljegMe/aPtMYoEl13rGsjTiHKd4qxJyslBko/5YEx0YWlPr6NF+yvo7h4EQQUJHoNrQo4ii9/WWdH8Cuaxvpsc3KGo4FrcikX2PLH9Jqhwpph+k6w4cIiMTZx0+JswQJYHIwACN9qC4x8r8EHJFM2Lr76f6XiChlHZNT3QuP8nVBwiuOuqEqZgaV/inEJV1b11Qbc+nTAiODFEGOXBf8OjFm/cAUGHwDfedWJ8hVePl0TJrY/GPO3vs7Mv32+Za6H+PKFPZfzcUk5gSi6UtB1g8tebVJ9PhrMsy4ZC9U0YPwcaeSRvUbkvifKxM8cP12SPPVmurkjnA9LfOaBQz0x1qiaj4/AGYRRICZPU/1yfvKOqsOEnydGxywP7v732WkuPxZhgDdbEVKFShdk7t3hLaHOw9ZN6BI0AhYEcft3yHhL5HRQADnGPLHV4HVRJheGzD2QJ851m73yqk7oGUNzrF+8rX7v/P3269UHowxBRYH+5KCteihTskkpe/KK4ZBZ6n8tYaBjpwGt+1UfiFu1A6B+UDHb/ywUZtb+CIvwAoXSumA1lbfwV2saX8BkaRQ8RM7sAXhyhx7Zf/qDMcb3Vu/arUGzBnmYI6ifNEtTxWr9Qr0ALbs8ZzVKWJTGF4ESwDeuHIt1ZSdVPkPxSklEUAFshXLWCCPXpfC9jB8B1X1LKYXAaLMxpSxeP//CVAqDUEryDnkEK5gck3g6ln/vy/famDHm8TRmasmw5szcxOhqLVdU2Ke81FWxJgX/ORTF5bSbdgAk1tXM2PbuOdmymiyFzU/Ex6FCBFuhNLC/1ti5ltZIkQ0UdMixZpGJd4nvyDSnc/ZZbHF5HzS0CKR/wY3Vgpi+QRKQacLzp1K/FJM0U6oIKv
 GIsu6sio
 rdrhyvEAzpYbZwyJVksZNLfyQGoeafPLr4iXtwsjez0zQbZllSZvCVEU2RNdyo2gDC4rgkTafl/WpMtmjcSnQRpEgHppsbY9EGIvR6Bou6TOFigF140KHLq5gdueA7g6xMtsAjOqITcN+B4FqEhuTN9LANaVbJ4q7bQOA104CN0VSn7t+nf8vUL6aZhOM03047HsfURIGk5Q0QeXp5yVU7XyTme06djnWp4zDmrOILFACms8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Breno,

On Mon, Jun 15, 2026 at 02:27:13AM -0700, Breno Leitao wrote:
> On Fri, Jun 12, 2026 at 06:11:40PM +0100, Catalin Marinas wrote:
> > 	if (kmemleak_stack_scan) {
> > 		struct pid *pid;
> > 		int nr = 1;
> > 
> > 		do {
> > 			struct task_struct *p = NULL;
> > 
> > 			rcu_read_lock();
> > 			pid = find_ge_pid(nr, &init_pid_ns);
> > 			if (pid) {
> > 				nr = pid_nr(pid) + 1;
> > 				p = pid_task(pid, PIDTYPE_PID);
> > 				if (p)
> > 					get_task_struct(p);
> > 			}
> > 			rcu_read_unlock();
> > 
> > 			if (p) {
> > 				void *stack = try_get_task_stack(p);
> > 
> > 				if (stack) {
> > 					scan_block(stack, stack + THREAD_SIZE,
> > 							NULL);
> > 					put_task_stack(p);
> > 				}
> > 				put_task_struct(p);
> > 			}
> 
> Should we add a scan_should_stop() check here to allow early
> termination?

Ah, yes, I think we should, maybe as 'while (pid && !scan_should_stop())'.

scan_block() already bails out early but it will still go quickly
through all the stacks which we don't need. As a later clean-up, I
wonder whether we should change scan_block() to return non-zero and use
that.

-- 
Catalin

