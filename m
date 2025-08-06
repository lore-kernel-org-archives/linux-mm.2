Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E259C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 08:19:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F9D16B00A1; Wed,  6 Aug 2025 04:19:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D1086B00A4; Wed,  6 Aug 2025 04:19:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20E346B00A5; Wed,  6 Aug 2025 04:19:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 114126B00A1
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 04:19:43 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CF44211558B
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 08:19:42 +0000 (UTC)
X-FDA: 83745633804.26.C65F95A
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7706A1C000C
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 08:19:39 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=QWJHUWIg;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=pgHLrFBr;
	spf=pass (imf18.hostedemail.com: domain of tglx@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=tglx@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754468381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oVdy8Z7vxFzMcZIpJyuv2XRd6gG/b+uZsIufJIRyPeI=;
	b=Uu6/q2bwt8Sh2r5CqPcncmP2Mx+w66sX+HSmyyXxTEftg+X/Fbyrm/7egE9oheMwMdcEiR
	GZ8f+iutZSzMFDfBdpqIuZkkph7NFjK21fPEsa39YHmHZq2O27087w8bMfUTH0m83CQFED
	DykQuE9cYRB0T+hP21k6zinYO1Kgbs8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754468381; a=rsa-sha256;
	cv=none;
	b=S7ozUGOYfLDvcpAxVoEPPUN0KYSau2uhpB/tqoktx+kPn7Ya5CvkHVfQNW8ssbzVXBb8Bw
	GLPpwlIGpuOZrcWi16E7ohujkbokHMzeoJ/PwIlJuPx55V1Z4dqxxmB8abSb/DZT5LF9jE
	QAsPFLyDaKxeS72pnadTg/i6TY/fJIM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=QWJHUWIg;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=pgHLrFBr;
	spf=pass (imf18.hostedemail.com: domain of tglx@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=tglx@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1754468376;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oVdy8Z7vxFzMcZIpJyuv2XRd6gG/b+uZsIufJIRyPeI=;
	b=QWJHUWIgKOkWwT5562fAfhJ9uJLrMtrpaQzMifCtJqLDgfMH1u0XdXvTrh/CIOCabQaqBQ
	cgVIVQfi+KbJuFCT91ih48QWuiIbiuqxQQmVYbL3MRkooSCRWlld82qxYukk0KBouUC5+s
	sPwO3i1DSbY3/HMlf8cjedZHjTcl/yRhtB5QQuBMhj230CXdpEdwdGa8YSrmsyzG/UgyQA
	1demA3314+qD7tnrtLuzDi6J/CxsthtD+prE43pUGT3U9AhOUyD3mk5ufQ0H9YTqW4LlPs
	mdwNnmjuYXMtUK623HiF/mOvnsFKhx2u2NXrL3mRP/ARU+mAj9214FAQMtPV0g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1754468376;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oVdy8Z7vxFzMcZIpJyuv2XRd6gG/b+uZsIufJIRyPeI=;
	b=pgHLrFBriDWLVZhnxPV/QBPg3icmRlb1PYdcBqzrGiZnZXZRxauEBmaFZGqJidZmTuwGyC
	YjtRtX5quqfdPWBA==
To: Oliver Sang <oliver.sang@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, oe-lkp@lists.linux.dev,
 lkp@intel.com, linux-kernel@vger.kernel.org, x86@kernel.org, Sebastian
 Andrzej Siewior <bigeasy@linutronix.de>, linux-mm@kvack.org,
 ltp@lists.linux.it, oliver.sang@intel.com
Subject: Re: [tip:locking/futex] [futex]  56180dd20c:
 BUG:sleeping_function_called_from_invalid_context_at_kernel/nsproxy.c
In-Reply-To: <aJML8dcu4vu4rbMR@xsang-OptiPlex-9020>
References: <202507231021.dcf24373-lkp@intel.com> <87a54usty4.ffs@tglx>
 <aINKAQt3qcj2s38N@xsang-OptiPlex-9020> <87seikp94v.ffs@tglx>
 <aIgUUhKWesDpM0BJ@xsang-OptiPlex-9020> <87wm7ro3r7.ffs@tglx>
 <aIrJipeLsGUM92+R@xsang-OptiPlex-9020> <87cy9gilo8.ffs@tglx>
 <874iusihka.ffs@tglx> <aJML8dcu4vu4rbMR@xsang-OptiPlex-9020>
Date: Wed, 06 Aug 2025 10:19:36 +0200
Message-ID: <87qzxoeuav.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 7706A1C000C
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: p78izepxmbc1ncri4g38bnh96gje6ncn
X-HE-Tag: 1754468379-459383
X-HE-Meta: U2FsdGVkX1/QM00UAHflgASk42p5CBTCk7vkhnIHoFOqsDzUepRE2028RBgq6Mz+3Yg+l/mLKkpT0PvCuz4wpCJMnZRiKJ9PFmUSJB3ZG0B2gJgi1lZwj0EzWANofTUNq1dv0LSbMadUWUU+R6E5VhJS8Vk/k6StaCcVRgTvnPd1G3+dS3W8vwbrjgkWYbn7GNZMGjQy2Abqfyg1ON/BEAnt+Py6GSA4o6PMzsYDfwvgGQXTCEiLRWPQifTVGRDAcjVciDluUYdr7kiRKcp6b1vslTP0NQ7aeq11lqVI6HmJamXilq7rCRW4BukdmB9ap/c0B8PwYj0FBzMbxfJkoCQBfFIUB4lmh7LUGBRfS3OCWr7AYybBBb/YpiCxGoOuEpVksd23jZP6gC/iQgiA8/0vDjXzvShP1iRst1ed3FD9VMDlaJkPtc2We0rvCNRNUyYWx5r0meoD+anuzJMA55Tq15T+m5QHlJ2/q5TxTjFEB7VHsnrWpQLE4656QdkdCmZNW78ZcR+ss4GkSjF59Nz+gpTdXFVOJOy8WlZrtRERCVTN5htcTsOHiQx1aep3awcXr8bynh1Q+tUUrQPE9dfJf7OXLtapibxzTGXTTkQIJv6/7CUi4LIAFYeY9d+87ui8E5K0V9Q4XPrpGClkXiaq0h6xI+bjJaByakhXL6WfRxGgMlwlK/JIU2F2RITfjDtfj/U9zx1LEkkKDIAFNST6uWQAQ5RW51NIyzmklrUPIUiAh65E6vA4kRCNi5/TMR/CXvod4iK8TIZA99gBnk9R9M4q9Uq4B0m+W423k528M3qQYlV9kVkfDtyc1PMUV/q/pR61Qg0wLVFtx4F27SJFxryiPMN7rYi77ZKPE8Z+sWGOFN3SWPe7QrcKIIg3TjGh9e7HH3f1V2iZ2IbAX9kWOcPHbn+i0F+39pi3BP8Kq0fjc+l5GH6VeWNk1qkBKxnrbC6tXjvv9AUpM7r
 dGvqYubg
 Yk6jQb4qCE/a/plQ3XHHyCwcp1rPRAsRyZMKogSP0QiwfpnZhrNtFZV8MKTGko/3PA0cqXKmI5ipN9JSwoc3mjOjxeREplWTvFELE+JDvKf7zLCdDQRuFHK0iuxGIzG6FbZn3xZJsZGEIvSEaz+QsUEv83ablJspSf0N9mHOEiFNgpXMYFk0dMugact/zEPSgzZTp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Oliver!

On Wed, Aug 06 2025 at 16:01, Oliver Sang wrote:
> On Thu, Jul 31, 2025 at 04:03:01PM +0200, Thomas Gleixner wrote:
>> On Thu, Jul 31 2025 at 14:34, Thomas Gleixner wrote:
>> > Either you make the timeout longer or try the following on the kernel
>> > command line instead of 'ftrace_dump_on_cpu':
>> 
>>   instead of 'ftrace_dump_ooops'
>
> sorry for late, I just took several-day off.

I hope you had a good time!

> attached dmesg FYI.

Thanks for doing this. Now the buffer is too short and as nothing stops
the tracer the interesting stuff goes out of sight.

Can you please apply the patch below and try again?

Thanks,

        tglx
---
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5850,6 +5850,8 @@ void preempt_count_sub(int val)
 	/*
 	 * Underflow?
 	 */
+	if (val > preempt_count())
+		tracing_off();
 	if (DEBUG_LOCKS_WARN_ON(val > preempt_count()))
 		return;
 	/*

