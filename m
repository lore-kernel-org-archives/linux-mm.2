Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22B90CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 14:12:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B0918E0013; Tue,  2 Sep 2025 10:11:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58A328E0001; Tue,  2 Sep 2025 10:11:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C5548E0013; Tue,  2 Sep 2025 10:11:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 375118E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 10:11:59 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E00A0B6E24
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:11:58 +0000 (UTC)
X-FDA: 83844499116.07.B64AA81
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 22D82C0004
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:11:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uegviDeS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of mhiramat@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mhiramat@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756822317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QGbCDt+q0ztyAOLxL6E1WNxpSnCpGOUVL8aWXtAq2Js=;
	b=Pu3sz/2P6eebo+6XhSdZTT/GsS7TdrqnTjjKC1Ak3KYJ4XqTxoHx/kcMo/LU+YTN9hFROF
	3B4q0kIMElHSqartUqmsEFuIgeREAeSkcfwxUt3haLZXJvKfTTygztQ8GEzDREkGE6VA1P
	/qe03klcKVgKstO6j/54lt09wfdy0AM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uegviDeS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of mhiramat@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mhiramat@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756822317; a=rsa-sha256;
	cv=none;
	b=lboApfJ/Wgqhu1Xj24Y5qqEhDXenR5n0FTUjCT3z3XWI5HvtogoaG0FoE8t7mAcBIAxoMZ
	bRblBLO0iJs0gyojLOsFjF5L/vPt/2JJBSIYzdA9Sk3zUaXrTXG43ffStDv+DZCsrxYzDt
	YE6CxchqZ6HD/SCiNyvW9mt32iJtwkc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C438643218;
	Tue,  2 Sep 2025 14:11:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FEC5C4CEED;
	Tue,  2 Sep 2025 14:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756822315;
	bh=1xFBw0aYZ3pncn46SvO4NtUQ09sWcq0onAb9a8kbZ3Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=uegviDeSHU2tMUPDyq1CrblQFM0ye6D0fJm9e3Uxa8HbcBDCkCWN0PTjRX0VyQ4VQ
	 1kccY/Dp5e52/Ouqqmt3GrrMo7n/70mUGLvD9iMaiqbbrKNjfsx5awdDtjbh9Vswh7
	 yUv7PxIgHutWVZ/EvQSuqoK6SmH6I3PTHIdO04+rNR5cQiOYPN1RmXuvvABMqj2hXh
	 5U4mEtaJ07+78Lm1qi/yDnF7lNwziqOyYMTVPT/nALSp6Iv37XZv/5LQquxEMOZTxV
	 KKUlCEXL/7sCVE3lD0OaB5IEY0ZeiT3PdWVA5msHvssOPypbAVhpMA4NAs2qjPP+pr
	 oqFvDYU8Q+dbg==
Date: Tue, 2 Sep 2025 23:11:52 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: Jinchao Wang <wangjinchao600@gmail.com>
Cc: akpm@linux-foundation.org, naveen@kernel.org, davem@davemloft.net,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 02/13] x86/HWBP: Add arch_reinstall_hw_breakpoint()
 for atomic updates
Message-Id: <20250902231152.442041a74774d888cec39201@kernel.org>
In-Reply-To: <284d5eef-447f-4e12-a121-3742d708c96f@gmail.com>
References: <20250818122720.434981-1-wangjinchao600@gmail.com>
	<20250818122720.434981-2-wangjinchao600@gmail.com>
	<20250818122720.434981-3-wangjinchao600@gmail.com>
	<20250901160602.e25f0107e7b0ef4af1078fb7@kernel.org>
	<284d5eef-447f-4e12-a121-3742d708c96f@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 22D82C0004
X-Stat-Signature: fjtojphthjac9uakb83cjbqg3qqx7wt3
X-Rspam-User: 
X-HE-Tag: 1756822316-39700
X-HE-Meta: U2FsdGVkX1/ZMmGEilnuM6IETw6UgiRi/Lnq+cjIbDedehmBWTXeClOmKmsqnwOsZ7wdPQXsY/H8sFnt9CQka8FWF7A89NsXjsa03ECkc3NjNUJptwDKdmE6nbC/+t+38d1FHv7taG1OxZzF3LMUXdEus8hTzokKUXylW3J9aGmm49bde6wtnthi6gNeX768+njoNQESN4DYScq3y1azjHLS+YMNZYcrDkkOBoVQYGZPKHGOavj1PmQzVm3wYvGh8T/geNEsqZLsV3ktnGVXIGsBBVeCWLMsbZeAZ3WjzNOzH9wi6pyiZSqlrmDDP62Wq5CA0NIF93v3t1z1caUBggV4+Ghb96Vjd05aqv4dLZKroIn6MxSpnW0YJsN6szjW7F0ueoiuDTrhSRrQir9RgkfxOz77dVuDxbo5Y9cH/xdQzN6fq4kwLymw4hh7BZcoaOdD43IIYwAFvxuWCw2VlObdIOAMI9SwSXo+i9C7x0dBcShHSRrH+5+qGiJvzGd9SriQhzi4YfRhiFH+zqIQmHj4qaa7O0+gBcjRj7UrQy18KYqzrRFkV4UaKDabBq+F3Dakw3l8kfUoYPSngfgPiN7MJeAWIvj2R963OBniQUdcafVnoajWi0vgzLkE8Zv+3RskNtPTu4jVuSPYDGJlDoRcb88wnIHzD11FtK7KoaCbLHnOQz88w9Xb9Nbf314uzH30QrYZDeuhY9GdY3eb9LPQQeft1DGRK7gksK3vCgLtRQfTWCgkDrxW12nYMkEp+PKZt9kSyAVI6CwznxHJA9COPqhM/fGXlRbV+RSsQUzvtLvWUskoLM9KCHVbH0MQkooXuHEh5vSOngUvNWmT1Ro0qxUou+YqdC07F6h5EaO0TU+IE1Exn2BOzgOqLuqgriYoLB/2uujy9xQ4Q/aDacq6zeH6qRiQU/+bc7xRw3zFRy4uoeulfD5H8KFGBnc6YZNr5pLB/dKb4W6QBXj
 NfcoN3HN
 QW/QR2mgj4pmJyD9jjZ7Dc4jh0fyuKgNmqAVJ2K5Qcmx6+eSRYTrq3CSELAzM6XtMyroadEmAo3H4Y2NUdtkdBF8XZraFTs4OwpHJaNdh8m0z4EjZlmhQu1QMNslgubFH0bpCGhXyCN6f6Yr3Br3N1jmjPaQMGLAjifvusnXgtb0njCOAn6e6/XHnCoK6UyCVSXfwdb8IpOu4qWlf0VK/6sqqTpPWSNkxl9CTM6xS34UoTRf9DR4D7myXRUHjbu28eplwFw8lenJ2iXQmBnKiDrVhf9HjpJZtPpcw2FdDi7JvNVU3Bic3nW9ClX4UspkLycdUkHMKPvR3Yf95pfAlKeZ2ug==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 1 Sep 2025 18:23:44 +0800
Jinchao Wang <wangjinchao600@gmail.com> wrote:

> On 9/1/25 15:06, Masami Hiramatsu (Google) wrote:
> > Hi Jinchao,
> > 
> Hi Masami,
> 
> > On Mon, 18 Aug 2025 20:26:07 +0800
> > Jinchao Wang <wangjinchao600@gmail.com> wrote:
> > 
> >> Add arch_reinstall_hw_breakpoint() to enable atomic context modification
> >> of hardware breakpoint parameters without deallocating and reallocating
> >> the breakpoint slot.
> >>
> >> The existing arch_install_hw_breakpoint() allocates a new debug register
> >> slot, while arch_uninstall_hw_breakpoint() deallocates it. However, some
> >> use cases require modifying breakpoint parameters (address, length, type)
> >> atomically without losing the allocated slot, particularly when operating
> >> in atomic contexts where allocation might fail or be unavailable.
> >>
> >> This is particularly useful for debugging tools like kstackwatch that
> >> need to dynamically update breakpoint targets in atomic contexts while
> >> maintaining consistent hardware state.
> >>
> > 
> > I'm also trying to find this interface for my wprobe. So the idea is good.
> > But this looks hacky and only for x86. I think the interface should be
> > more generic and do not use this arch internal function directly.
> >
> 
> I agree with your point about the architectural dependency. I have been
> considering this problem not only for the hardware breakpoint 
> reinstallation,
> but also for other related parts of the series, such as canary finding and
> stack address resolving. These parts also rely on arch-specific code.

Yes, even though, the hw-breakpoint is an independent feature.
Directly using arch_*() functions (which are expected to be used
internally) introduces a hidden dependency between these two
components and looses maintainability.

> > It seems that the slot is allocated by "type", thus, if this reinstall
> > hwbp without deallocate/allocate slot, it must NOT change the type.
> > See __modify_bp_slot. Also, provide CONFIG_HAVE_... option for checking
> > whether the architecture support that interface.
> > 
> Regarding the slot allocation, I would like to clarify my point. I 
> believe the
> event->attr.type should not be changed when reinstalling a hardware
> breakpoint, as this defines the fundamental nature of the event. The type
> must always be PERF_TYPE_BREAKPOINT.
> 
> The event->attr.bp_type, however, can be changed. For example, from a
> HW_BREAKPOINT_W to a HW_BREAKPOINT_RW without needing to deallocate and
> reallocate the slot. This is useful for future applications, even though the
> current use case for KStackWatch only requires HW_BREAKPOINT_W.

I understand your point, so it also needs another wrapper which checks
the type is compatible on the architecture.

> 
> By the way, I have sent an updated series.
> https://lore.kernel.org/all/20250828073311.1116593-1-wangjinchao600@gmail.com/

Yeah, OK, let me review the series. Thanks for update!

> 
> Thank you again for your valuable review.
> -- 
> Best regards,
> Jinchao


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>

