Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D09ECD98C5
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 09:27:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8428A6B0005; Mon, 15 Jun 2026 05:27:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F3336B008A; Mon, 15 Jun 2026 05:27:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7302C6B008C; Mon, 15 Jun 2026 05:27:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 62F386B0005
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 05:27:29 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0B6411A09A7
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 09:27:29 +0000 (UTC)
X-FDA: 84881619018.04.1865118
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5CF36180006
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 09:27:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=XT8kYBOp;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf16.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781515647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CYeIUWAZAMbunjNvtgNf11r755PDjXW4U8h+2x+GW+8=;
	b=O+MF47r1M5SXO+FLgbn7KaiGlrU63TeryIhers2enZqo/uRZ8ZmqhTlPGfIYMRAIuc6if4
	4q/IQMbDWUYuEpWB+uhfJrB1UBw1VQ2agtHdStNAmbqUpOybl/gLVtuI1PT9JXIOCMEDzR
	JAgbVKEO8fL8bAgU8x9NvG7RM5oN1i4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=XT8kYBOp;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf16.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781515647;
	b=LPr3HOYliIOhTkEMg8ViMtJyBqWFpNIvxZ59ydDDP2LJNoa1jc7QMh0N5THsRqZpmOiVPf
	BU3ch5umnP+rLj9li32+hJGeQmpJDRCjQJqGUYoo81sDflTBI8MdFkQDJ8yH8cCZ/iLcp4
	gQd/OMOobpxD82YlXdhimQ/EluN9vMA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CYeIUWAZAMbunjNvtgNf11r755PDjXW4U8h+2x+GW+8=; b=XT8kYBOpELSi+dB+QCLRVVBq0r
	xE3Kp4ltNT4zeToDTjh2HiL/sjP+EJd+acf48B2fcFn7ruEMLFhZMEiBSl2GNnRj7S8vo2zJAjoS7
	BQWXCI1zR8ZSz+wbrHnnRRA/eothFn96GFBDDLo+/+lbre7o8qbUYyJnN90nPhWzc6OcD0aklKf8c
	J4RjY0le5LvE6jMT8hQwJizU2RQkUeeOWFE8D1J0d24+rpRFywmbC4oRXqA9Om0fEiULH82a71/MK
	mJAakOVbb1f0AlrY9X/BBhe72SJHo5G3LPAN/Q82FJAgSy7sFKbJFTovAmv5JR3GjXYSzbaCa/XF8
	HZGvfTvQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wZ3bC-00CyHz-0U;
	Mon, 15 Jun 2026 09:27:18 +0000
Date: Mon, 15 Jun 2026 02:27:13 -0700
From: Breno Leitao <leitao@debian.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, lance.yang@linux.dev, 
	Davidlohr Bueso <dave@stgolabs.net>, Oleg Nesterov <oleg@redhat.com>, Qian Cai <cai@lca.pw>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/kmemleak: avoid soft lockup when scanning task
 stacks
Message-ID: <ai_EVJVfe42glgKI@gmail.com>
References: <20260612-kmemleak-stack-resched-v2-1-53240de79e88@debian.org>
 <aiw9u4BllwZXDH2S@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiw9u4BllwZXDH2S@arm.com>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5CF36180006
X-Stat-Signature: gj43wf9eopjdd7sbb9rrtgmm6itrw88c
X-HE-Tag: 1781515647-991404
X-HE-Meta: U2FsdGVkX1/UAG1fST978MFEhHHgQZQrJHMlWFn0R6XuXP13JxnLLj1I5eznkqIlDf3z0Zx7K6Ci77atg4dr8aTeuO2V8LBUEpljbXMjSAHxaLkGVjCvcVOvrHnrpzcMBCu89Wl1cWRGn4sffdpLeOQA1IbNwF7iw5AOTYChjHoGZAL6ftUK52g0HZIRHhz32K2Ncld0k+T119ddJOplDRanQgtoRRinL2+YANTEchks8l/v67ViK8vdyBIgj8Lz0/ZawFBDmA5wnTQhuEqzBAKRXTDJDnVC3HAqjze9wlETFNc/7/9IywY9UQ6LxTnQYldiTXUgn4EbwER3ALyohL5nUBTIZU+tjPbmLZMegKfYbresfek1KrNqW0y0ZpD413Pwn4zbC4aKWvroDhtmhsQqeQTO1h/AqwsanRjJ26/Lol3GZ/Tfv08+b5aIgG4EMIsm3jYsnNwDAzFMZXOxPTTamB88GQK5kCCedgVLyG8WRIMTHj++hNDvAsEv1YMbSl6a6aGpKlb0ts3KP5nl2keFOevFzgqsudNdKy5tVamzFHFqZY8ncdVI7fk06o4PYGOCNks3QWU227m8LvF4Si7dEkF1sAWDDRXaB4Y7QbIIyRrAzIwsG5QjtrSKkXhFxNXRE8P45Mx6qMlMJERGDTlsADuk/uMKb/0G4rf8kRzVQmEVHIgxmSZzggzohZMSWz6AS3zTHrMtsjtdQNYN+v3oZtdAwS7fdEAOOSNGpDytOtsDRVlUQXmMsXxKX4QL6qy9DaMKj+QShottsLph5D1fxZf6Jwc3eFzMbT9BrcVPCIiMd0a5Hjpcam2pvWUQ0l4KiQeXc0a2fpYquoEET1yhYtSdKvEwt6hEc9RvRLFy2XnuYZdSJTrtvB1D5jga0+fdZ72U4uTAEr95OlcwstAcFWWr+CuS3iKuxDAWElCMYPI7T9QiUrM13fnmPoQovhQYVMZVLk8cjnLJQMr
 k8Xsew2r
 hsFN1ahGZ3xdq4XB+qI+8dHbslP5I5RXdEZi2TDjvRQiGJwM/VWS99k0XkGH+fGjZc4poH+ZNcC20xOImgfhXQhaF3R+EE1wzSR39Gv4DCGWJ7ibemmEaHU1vtn22USXuhMpoVd7/A0XKj6cDajjYQJghMzgfCm5z1h/Fk0I89mYbK3JdlzL+vAaFO6wfcvln7PJLvC7S7eBRURAP34GbijzPKOhV6MlSMZg/o0Yc9CjHbASl3bs9G0coSaoiPs722Phz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Catalin,

On Fri, Jun 12, 2026 at 06:11:40PM +0100, Catalin Marinas wrote:
> Thanks for addressing this long-standing soft lockup problem.

Happy to help. We run kmemleak on several hosts in Meta's fleet, and
I'm working to improve stability for those systems.

> Yet anther variant below, untested. Basically, it follows the
> next_tgid() or task_seq_get_next() approach (we might as well move this
> to a separate function to avoid excessive indentation):

This is excellent. I explored similar approaches before proposing the
horrendous array-based solution in v1, but didn't arrive at anything
that would work. Thanks!

> 	if (kmemleak_stack_scan) {
> 		struct pid *pid;
> 		int nr = 1;
> 
> 		do {
> 			struct task_struct *p = NULL;
> 
> 			rcu_read_lock();
> 			pid = find_ge_pid(nr, &init_pid_ns);
> 			if (pid) {
> 				nr = pid_nr(pid) + 1;
> 				p = pid_task(pid, PIDTYPE_PID);
> 				if (p)
> 					get_task_struct(p);
> 			}
> 			rcu_read_unlock();
> 
> 			if (p) {
> 				void *stack = try_get_task_stack(p);
> 
> 				if (stack) {
> 					scan_block(stack, stack + THREAD_SIZE,
> 							NULL);
> 					put_task_stack(p);
> 				}
> 				put_task_struct(p);
> 			}

Should we add a scan_should_stop() check here to allow early
termination?

Thanks,
--breno

