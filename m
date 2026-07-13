Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0910DC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 12:31:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDF5A6B0088; Mon, 13 Jul 2026 08:31:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB6E16B008A; Mon, 13 Jul 2026 08:31:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCC5A6B008C; Mon, 13 Jul 2026 08:31:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B2FBD6B0088
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 08:31:26 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 458C640144
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:31:26 +0000 (UTC)
X-FDA: 84983688972.12.2E5C59B
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6556B1C0007
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:31:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LEwTWAxR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783945884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SFB23UDIkU558vFag9ouVrBUfbEP1y+rl+Xg6XT26so=;
	b=BgCfhUwvw+IphiYA1dBvtOtkjt8FHvg9P/q6QWZEBrh6RSidnpiOf7xJNJ3/O9wNAvbbAL
	2bowtMHGc2vt2BlRlSzZN83eK/bQ5YJdpf4ShZCZ/ETGJgEJn2aoH7PaPVwwXm2PTo/LT8
	YOA3rfP5LsfriedT+9gIrp2WKfh35Hw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LEwTWAxR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783945884;
	b=SDexocSeYp5HHyLZG2ksN70l78qIM0klqAZhuVALTZtSvzlyxMdZvIg8CWI3w4sCfCkfk1
	a0gYhh4PmwwolHRmmgAUwqq24Yyuntd74ooE2F1q6t2VMeSvSPooeu6Djon//eTFYRyfjb
	VYt/TkMje6lrA/qZ5fbAWkdEJfPMubg=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783945881;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SFB23UDIkU558vFag9ouVrBUfbEP1y+rl+Xg6XT26so=;
	b=LEwTWAxRdzON92cwYpy3JHRbt9SQS+fjRMDclWI5ejveG2sc0X35nsBV+ea++I8UqIr9kV
	1bqDSd6akUhrhDXJ1uFJnHlQJIfHzmxJyS17qzvSyIfFag5hGTb09wSVQZIbogf6A6pSdT
	9NxhHMzDxrfVqs2ZbcSTyGWpWMAr4mc=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH] mm: memcg-v1: fix wrong linux-mm list address in
 deprecation warnings
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260713085756.2973549-1-guopeng.zhang@linux.dev>
Date: Mon, 13 Jul 2026 20:30:48 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
Content-Transfer-Encoding: 7bit
Message-Id: <3B4076F2-A893-44E4-AC2E-B5451226B618@linux.dev>
References: <20260713085756.2973549-1-guopeng.zhang@linux.dev>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 6556B1C0007
X-Stat-Signature: sushqaps44tjwaiukhpypf6ibb5ctex5
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783945884-384453
X-HE-Meta: U2FsdGVkX1+mxR7H64lvM6c/XftNRjnKSYIF92m0XSieL7rMuaaYBmx3AVatFcqG8rQU4HWzDXvyKmciY206y6bqpBRWDWPexCBhZ/qUIQKQrDdi+wPKIJnycIWOblJ0PSJH/XaqRRP8lK80iXrPIDyCwJ3CgZ0dZnOE/xDT8G7ruRIMl7crAEgCR6fJ6SnCqIDQb+I7rBgkPBYXpP7bmHFDRTyv2ol1g5GSi995QNa9oUBkNMuCNKT7QG6uVnFTRRK9CCVRcZTj/L7WrwLkQWUytJmvrl7dygzkxLuRckYC3PTJyrxaA34+ZVcKr+KXcKCiDE194FLC+Nnry01zv15Ai9zxUwmHHKgEPp21DUF3DjLclaQ/L/2E9xGmI6A0q+oPCX41+fUgSjkK9t09Jhgc16CvrUQhcWWZnM98hNzxlQYpwCoSt0Wo0p6BaL0nmnXgfuRIrTuZ6OqGkPxSlZLagIiNBfnF/J1UFtnHEK8o4bKlfS7nHhM+GSsJ7N/2PuF3Ys1TbJwiTPRxCXvvahZmD1w2xwL1glttdVFNd8pdbxIgfudbAurC49/d0rjkZGPAZigDkYscDv4E+oxFGv8J5eeyx8Y7BeK+EkK73o0ZWssC7LSFf5CsBeAp80fZmSTuBxphNVSeRF5DvYPo7PkawI0nhhiPcIQdI66LTycQhai3tgc85YYFFghK9hFhTNitXw0uKcEedrRjKFWjWEaMyEmG8OEdOfZiYyLtJ2INs37SjV+LmU1IQOFOYl9HwRyafdCGdL7NN3AJZGmK+g9n6ih5m7885Utp5yR1JA1cSq1AEtZL8PpsrHWe/fwDE5je+L/AzT4t+2yv5KHb28xK+VBD//SoROpIW+YLPjCkXlhkx+O1qUp2ZQ0jfZT3uMEwZEXY8Oz13jz0uqMqAI/jgUDW/V45tIU1uRf6bgjPqFlHkHdvExvRhI4ucAu6jEpLu+c08sbnfVNmtW1
 ebHoPzDD
 13/shxqKDpecrPFxZalzFngLtZSBfKZR86UawF+99CdnACU4vwghsvwJPQ5HOjXfWZzUGROIMun1VcISg7MD+HpZHD0mkr59ZHdWlqwmlZXIawGGaaxZarXwZ5idygOA8BcW1cTQVcB+5MiIfu22r/aXZvzJ7wyF/dPv31/anWSwNKKmB98M+dqxRICdjawPD9iC5FvIGeybiz3eWry4Z8HncyZ/ujn+qwH9GHUhotNmEH95mk+qmp35qPBielET/+raCkHZTSHCbfnMohktfwbDE00hG9RLFIdV5ncYrQ0d9nekcU8ICM5fgc2IgHI/xo7Wj64z/3T7c8Qc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 13, 2026, at 16:57, Guopeng Zhang <guopeng.zhang@linux.dev> wrote:
> 
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> The deprecation warnings for memory.oom_control and
> memory.pressure_level use linux-mm-@kvack.org instead of the linux-mm
> mailing list address. Remove the extra hyphen.
> 
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Reviewed-by: Muchun Song <muchun.song@linux.dev>



