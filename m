Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBE06C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 22:58:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A95D36B0088; Thu, 27 Aug 2026 18:58:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1F276B008A; Thu, 27 Aug 2026 18:58:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90EE76B008C; Thu, 27 Aug 2026 18:58:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 718516B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 18:58:31 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0403AC020A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 22:58:30 +0000 (UTC)
X-FDA: 85148565222.07.E8B2605
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5BCB840007
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 22:58:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uYjmXJ0o;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787871509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o+CbAiQiCIV+X/Q5GkUr3xptEh0VJF+8loj/KjFok3E=;
	b=xdHJ0XnRA/Mixvs0zuqfqW7Zi/k8+ig0ihz+DtE+IO1fSyIlPeaxOL8dX70o4W406RJzF2
	0J7F0pcWpuB479+23gpDQo5ycpDVHQ+HVNU2Knblb8d9xjeQCmDvsYYP/hy7YnIk7feLaT
	GXrsCa3beQYeaG4kJI5Fg6R+ir2lbpo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uYjmXJ0o;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787871509;
	b=qURU4h6/EGnmjFf/oj2WWs0815P39JC4jDAZ2oVkqDvFD/tbQX9k4exgskOWAx4doZuOqG
	3jQb5+W25L5BWG+lzVD1Wp0pIBth+KBDdLcPWvH9PG+Vt/i6jBGMLe/cn6ZadFBx9GDjiJ
	xUzW8QzgGUryChLxg5HMGbIlWM8jyvE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BDA3D601F3;
	Thu, 27 Aug 2026 22:58:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 191751F000E9;
	Thu, 27 Aug 2026 22:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787871508;
	bh=o+CbAiQiCIV+X/Q5GkUr3xptEh0VJF+8loj/KjFok3E=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=uYjmXJ0o0nclaaJYRmGvcWh+PMXoFy/4V5w+QgCWh8eiWJb/86f00TXFVBhbrLHhB
	 8lQosBwA0un/NICBloB17fuu/r+IR/E6r6IhUBF68l7qps2RaUPak5VGjmfyDXCX/Q
	 bRnygD5L99ynxU0xzCPn1/M1i0SWw9TtVfU7HRFk=
Date: Thu, 27 Aug 2026 15:58:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wilson Felipe Pereira <wfelipe@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
 Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>,
 Tejun Heo <tj@kernel.org>, =?ISO-8859-1?Q?"Michal_Koutn=FD"?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] selftests/cgroup: fixes for test_zswap on single
 core VM
Message-Id: <20260827155827.e40d5d88cee174437a16f432@linux-foundation.org>
In-Reply-To: <20260827034807.2822234-1-wfelipe@google.com>
References: <20260827034807.2822234-1-wfelipe@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: gda89ne98rtjkcsyiafmmbp1j11gesxz
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5BCB840007
X-Rspam-User: 
X-HE-Tag: 1787871509-110355
X-HE-Meta: U2FsdGVkX199NO4o31MjXfQ5eoVrvlBgFpSkUe73OTV31XoCI7Ku5oFlCJ1JW3GBS8TkHLMMr4xT5tyN6urmsL8TUFm+V6oJI59pa1/kKhSo/NMsIWTtYobw8btR/e8oUAz/f/rnULYupi+gpkJT+WMP9X9ciQsNUeBPJ/8EiiXjxvDTensDpNQ689n+aCycEBeTuI9Xh/An6Z0eYYwcJUN3TWIXguXvZmJxrBWn6YWdhXmDrAwBpVRXBs4MN9O5GEhQqS1ZSVtAH06pXAG67b3Fb8eANmBJLzcQUeNMYXvu3ezVQL2ZVi9s5Owf7H6ByeRIi+bw1bNUM+o6Qelwra5MhgB++majBUB6ywVmLmTR74/8lo7oR/+vFqYP5Rgkwr+Wak1OxG+COqZAPKEIxIpnY49VG45Obxw5Fb0PHb2eTKHAwhYjL0xYm/bvzHq4GkKRaV9RUaEOd63xWiifYTiTkg6MDod7edPFyaf3GaS35/6YPCaf1Guuz9ZkXjU/GhIRmYxOUyQXp3ltp9HrgRMNfmSpn+drJf4xgPiZow1yCmtlO0fMcVJLgeW8fWhOM7g0mkVGorh9/Yy708CHDRoSlfV0EQn7jzw6jjnwGi0RvG5VAAfiEXUAVX7P7dHsECB58N/rJ8+RpqU0mjd1XMTvsCOFw8y1Te+IEWi5J7WzOO4jRFLpEaeka0H6g+KlwMe+yHzwhwfqPWvrb6U+c+u5B6ws/jtzvfDGbScu8dYh/HZK2vCpKhxA/WoFRXLeqxjPy5fIsgqLs71T8e9iQ0Klho652jJ7JA0GSAYWWceAgji/yMX4rPErJ3FVRBHtbobM5OC63B4cu4MW/ezMb6ilYQjzs/8jvHS9ivt5nZRMzeoRPX9W24pqxeB+PgA/QZxFeR4l3l9OwPc2lyDiON/TGB3vz/W4quGigTg46z9NXHR+RE2nPI2Riu0s9xIvy1Vw+syKlgT260AoNGL
 YUTau2AE
 AtklCreS85uNZEmKNy2S0zKdoYha5JdWON2ZtMubu1uzgG0LFNWMQ5Ghh1EJW/pBNTXo757F7yyBsiblgyxwlK0U8E9NzDQJriQQcpElse0S8TlP3CFRF2XVo5y4t/c4laeyLYKq9UglunlvaLSYzUzPezGLDw5DrO1RwhHoqVsi/d2XY3NWf2wudqmxWne2m60Q8407+nFACErFBKwH31QgOcve1O9+crYTeIFl1ktcDlkeHFVndIN8sBsyWlC3z72v1y2zQGSz3ndbW+iEb5ihJrr3ORo1S/jPILN89eqORzyEJt0WUuyB75+jsQEwnbZsVpRhtk49ZZnmOfSe64/J11J/CFTVYOJBKOqXEqGzj2TYdtvX+Jp9IE2sBKEUhTK74
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 27 Aug 2026 03:47:40 +0000 Wilson Felipe Pereira <wfelipe@google.com> wrote:

> This series fixes two test failures in test_zswap observed when running on
> a single-core VM (-smp 1) with 4GB of RAM.
> 
> Patch 1 addresses a race condition in test_zswap_writeback() where
> waitpid() returns before the exiting child process is switched away by the
> kernel, causing an immediate write of "+memory" to cgroup.subtree_control
> to fail with -EBUSY. We fix this by waiting for cgroup.events to report
> "populated 0".
> 
> Patch 2 fixes an implicit unsigned conversion bug in test_no_kmem_bypass()
> where small negative timing differences between debugfs stored_pages and
> cgroup zswapped bytes caused the comparison to falsely fail due to
> unsigned promotion.

Thanks.  Sashiko thinks there remain some
signedness/truncation/overflow issues in there:

	https://sashiko.dev/#/patchset/20260827034807.2822234-1-wfelipe@google.com


