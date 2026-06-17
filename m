Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B435CD98EE
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 09:12:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF4A16B0088; Wed, 17 Jun 2026 05:12:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA6876B008A; Wed, 17 Jun 2026 05:12:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBDB66B008C; Wed, 17 Jun 2026 05:12:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 933AC6B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 05:12:06 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F00B7165FC5
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 09:12:05 +0000 (UTC)
X-FDA: 84888837810.30.89A2AF8
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3103B1C0002
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 09:12:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FLdvoLIl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781687524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wnXsZKwWnAYJLaq3exH8B1gAP/khuSxZ7D/RQAQfYlw=;
	b=O4nw4MFmumX6+rmRD9Gxk/rUu28t3K6T4NpUfJnK80h7lACfyQM0a4Sh3QmALTgfUnmLZD
	x91h20Vr5meVkRSjn3yGl6sga98gc3dFSa9L5nbzM7Kjy9gdn5o9IoXF8vftBJ0V5JPwih
	+IO/fXmDklm0I89dK2aP0kHW4+kRy94=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FLdvoLIl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781687524;
	b=TM6T/jEoyIcTre7Xf4qh+llyChS1xrbQ8++2FGIIjrUdB5oTF/Vad9Dn4D1gaoopRwFN80
	Pm5qBANfX+dWck0V3Sd1AoZNIoHAfipspAe5Tr7k/K2kAC1b05eUk1SQvZLqgyYJ4Oce8D
	4LuTuYPC3izbj8EoBfy3OMSUspkArBU=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781687521;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wnXsZKwWnAYJLaq3exH8B1gAP/khuSxZ7D/RQAQfYlw=;
	b=FLdvoLIlUVtLp2O4vEIyOi6rqWUwJRnxUXGmPLc84ALsuQc/SzDnfT8E+bhddWE70ulCio
	whzhMZfG1wx+MsHuSx27Rk+ioGNKOFMzRumfCNliewij4pwyJN1aG3JtiAJZoXAwjJtMXW
	18szX4jWpca0chAHByET220eozek80Q=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH] mm: shrinker: fix NULL pointer dereference in debugfs
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260617090052.27325-1-qi.zheng@linux.dev>
Date: Wed, 17 Jun 2026 17:10:50 +0800
Cc: akpm@linux-foundation.org,
 david@fromorbit.com,
 roman.gushchin@linux.dev,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <C5352957-F9C3-4B65-8595-8C8AD10DF30C@linux.dev>
References: <20260617090052.27325-1-qi.zheng@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 3103B1C0002
X-Rspam-User: 
X-Stat-Signature: mbtci3kig9jrzpeqro6nahx1xxfx3e1r
X-Rspamd-Server: rspam09
X-HE-Tag: 1781687524-738298
X-HE-Meta: U2FsdGVkX1/i0YWNrrxcgo1IO/cJbPLQq+daLnOkqwOAhO74IM2BM8RwGQxESI710O27W5aqXxSw3ny5m0qAFGcENPgYzPksfqUhsFcfeWsNyFxe9L4BRsHjMq0IVTfy4thvhsM0DqmSsDo9+pDKXgPcLPM/v0qKUklTTSG6PTrdgF1hZ3SWhwE7MXOkUyXoHjDdroS4VElP4k1hgknQh6KaGFw4d+hrjDxz/RvVvztYNvF8pCLvSykhNGjtK44I5d42Cjrilz8efGNF1P4+L20CI+CHoBzcM/ioQDnwY3gO91yMpMvq0Q01rpCy7EKB1cFAKyTKIXmRfdXobXxaReX0ehrTBzncJ+9meQswtjovpkPBNlE7GfB39sEwJPkiaJ6tFNNh7GFRLQj7SHUWAmqs/1lB9gJHQajKfqxWB+YHPtnghyrrJE9gfu7TswBzxqTR9AjfwzvI7EtAL8Iy+SJhRUDDheiLgK6KfsmZk1ZsR/AgBFHztvbtCUAkxWn522TceJPod39l1ttZntt8VrTXSNAJcTw0rKqF6eGYnBCt5rPFXkLkPvBe8rdIVGXRpIC/B/J7iFaHo+nutzd7o8P2znQUZKPaJ8xC+xeaqrI9a/fQUfvLH5B01g5xmIRpIiIukZor2KlMYXpSaq7nZSF3jQG3uhIh2ADslAO+co8p+vU5E30QAKyek4fiC28Wp5mBHIQLEOqlelbsU6fwfQ2VhN4tv68M7od6DePhRW5m8mNEYeKF6iybBnPlzMkd1CYPWBz8n5KfkkzKXSunFHYIRqdX5K5kgmEQNfkHBACcyTPKf/3/irXw00I2NlXK3/pqT4m88idy2cbTO0sFWZ8oNwijmpHUHgMHlIOArIJnTLIxPokhBxByRbU+1AAMbbb/bOYUxFhWjE7NflpR+GxFAyUJdyLin2eUWCeG1BreK48fy4/HKqelm2hmRTSgUYQklp7i7qjzXpSjUbE
 S7Kmbw9v
 iLgcvOVOirkjbF6653iD7/cS2IIE7sNW+NrnpDY8WZuv58bFQbc2bENP2lFW9mSFRehvTjwplwWoboAj6Mzr/kMjB/zhwy4mccamw8NmPgbXSw1i5m0E+IVLaVoGFEltqtBwNbCnwrSL20BHVMxCdgs7IexsJb9GW+rQzhI16NxPWaoMYuoggf80vlz8fSJOUQbZ2nUDs1JOey3l/BuMC90a+QDLB0vbxsP0l4JZPalMEqS2vSOhTzGUGeHAFPlMZUlDsISNsrICL1nQt3IrPcOshexevKLHgKeNZHKXX+m4qMsg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jun 17, 2026, at 17:00, Qi Zheng <qi.zheng@linux.dev> wrote:
>=20
> From: Qi Zheng <zhengqi.arch@bytedance.com>
>=20
> The shrinker_debugfs_add() creates both "count" and "scan" debugfs =
files
> unconditionally.
>=20
> That assumes every shrinker implements both count_objects() and
> scan_objects(), which is not guaranteed. For example, the xen-backend
> shrinker sets count_objects() but leaves scan_objects() NULL, so =
writing
> to its scan file calls through a NULL function pointer and panics the
> kernel:
>=20
> BUG: kernel NULL pointer dereference, address: 0000000000000000
> RIP: 0010:0x0
> Code: Unable to access opcode bytes at 0xffffffffffffffd6.
> Call Trace:
> <TASK>
> shrinker_debugfs_scan_write+0x12e/0x270
> full_proxy_write+0x5f/0x90
> vfs_write+0xde/0x420
> ? filp_flush+0x75/0x90
> ? filp_close+0x1d/0x30
> ? do_dup2+0xb8/0x120
> ksys_write+0x68/0xf0
> ? filp_flush+0x75/0x90
> do_syscall_64+0xb3/0x5b0
> entry_SYSCALL_64_after_hwframe+0x76/0x7e
>=20
> The count path has the same issue in principle if a shrinker omits
> count_objects().
>=20
> To fix it, only create "count" and "scan" debugfs files when the
> corresponding callbacks are present.
>=20
> Fixes: bbf535fd6f06 ("mm: shrinkers: add scan interface for shrinker =
debugfs")
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


