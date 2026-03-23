Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F021AD58CBB
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 01:54:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66A446B0005; Sun, 22 Mar 2026 21:54:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61AA96B0088; Sun, 22 Mar 2026 21:54:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 509346B0089; Sun, 22 Mar 2026 21:54:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3B2986B0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 21:54:02 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D7A951B8CF5
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 01:54:01 +0000 (UTC)
X-FDA: 84575657082.19.1624CD5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 26B3314000E
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 01:53:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DjOwOV8G;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774230840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9089UblRmqtbq6mFgc8VxjzYqTS2jW9WIi9l/ae120E=;
	b=msD1w74DpJOmk5Mk+MxVLyOkBZMtu721buTsEOD2t2cBwAfQON1ushpgIju3Q/47K30je0
	L72+08Na/fdF+XxmQkO251fs6V+prhGxV9iG+6VTH32kzGuRAxNhX9aNOzWngz1a2dgSDs
	fAB7GWSJzTOrCa2keNxGpOsMXJP+Fog=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774230840; a=rsa-sha256;
	cv=none;
	b=8ceCfcMPKV7HgnJMqZkqsx8LT5MWk6IbfSray+MXfaux16kGC05q7R5fXrV3Zl48ndoHJZ
	euc+Ez/F9hRIHNJpbq9y6L6nlLuIV3DAr0uU1hcRBnAEmSoBkuA6SsKKZ+EYE1NUvO8d5T
	ZgWqRnAScLqP/ehG1vyKgt6DMmOEAvE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DjOwOV8G;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 608F941B1C;
	Mon, 23 Mar 2026 01:53:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 030C0C19424;
	Mon, 23 Mar 2026 01:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774230839;
	bh=ruC9HWF9oEK5XETPcyJHTSXZVrQdPQPIQsXjSrBOX+I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DjOwOV8G1UiUJj0rYo3i3CjWTQsqdK4Y3ob3KXpGLF/fLE7rSmAwIbvrJqA/D9yrv
	 jJQYi6st2sdrgA9J31dkO5SIddorWAN15xloNrijFdByxAbJcv+4YFcMc3NK2GCMxW
	 tWrEA2wx6C1zknjNJo9sjNXJeTrl+Sj7ZY96gHqMD82AHbVlbt2BYKOynF4iRnnzJ2
	 5cCy3JyMbOoFb1iZHQ5PTGeuT8Oks/dnxp+VMab/esljySMyBH0s/SwmG9j2XPd7LI
	 eyDTNY1/G1JwNS1C+VI/Wl9m9bB7/WZVqlS95izhV8pqVx6DORMo2FTFLwzNDVp/kN
	 o75KfJ1c5h2rg==
Date: Mon, 23 Mar 2026 10:53:57 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Harry Yoo <harry.yoo@oracle.com>, Nathan Chancellor <nathan@kernel.org>,
	Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>,
	Michal Clapinski <mclapinski@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: NULL pointer dereference when booting ppc64_guest_defconfig in
 QEMU on -next
Message-ID: <acCdNX58PwLyDJON@hyeyoo>
References: <20260319233745.GA769346@ax162>
 <abzKcGiRSR_E8lLN@hyeyoo>
 <7780a471-9d99-40a7-ade7-0c4594ac36c7@efficios.com>
 <ab1J9ODkX5iChu-C@hyeyoo>
 <7458d8fd-5922-4e0b-9cd5-91880282aaa3@efficios.com>
 <7a8faee8-0eb5-4e58-a6d5-ef711791e3f4@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7a8faee8-0eb5-4e58-a6d5-ef711791e3f4@efficios.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 26B3314000E
X-Stat-Signature: dusscyuyoa5w7qshju1qrmu7g5wcapby
X-Rspam-User: 
X-HE-Tag: 1774230839-850572
X-HE-Meta: U2FsdGVkX1+iUuTQLPgzNAvKC9vlmyhaHnda2ymGBaqpMyGUOrzdPSU2CeOpsVYw7YOCnl4/iLtuJa1xUuH9/Xcr3F0FaCSjvGSN0u4ZJ/VKgItMIaRl0A0E6pORdvf2iYAlJuUzXQawWvxKWS3rL0MvxI6E2lwVTVXO8g9sKCC9lllmqKQAjhJ17/IgWj8O73flOluKJf6qvYbo6BM9UO2jVRZIl++N1E2s5/xUBgniq89G70x16Y5d55mYQYD23SN54A1jngZSrhMSUeNvF8hr+jmthB/aSs7UJwO3CwWKIT1So/DBw+ZZ2O8u14IVwjUr0nz7nqzzViWOXeltsUWpYdmDOTK0FR7ZhrUugU82CUTQrqvQvPuYN1qDMpCLRH1jNyMZXF2zkBgrEFhNO2YU2aZcsT1H1AmZVIuz4tcuZNkyrczUF11/AHJneL2ab8mqkwNp+PeJFbf/mCRruOdS2w7Tk+5JoesKUrYx5Ehh01jHZAB4Z9GHU8prKGijFtnZy6WV+b/GLuvwx4FmD806k+CGaZEvUXiPNGmCIX7qIKMxNtEip/IF3KWoAB7ZpbXefNQXHjTbvLP0p4IwvKABPyjddmZuZS9r2nPU2lO9A5u2FBCMJXcZ4cX8XvYB3rotTB8zRowIAnIqO9fApS1VTbrmt0gfkELv1yoizwiEblgfgDg+flnzwgnshYPs58+f9endxs/A5PFU++SwujBU017Ah0h8tiBIEUZ3aD1lNMeXmP/T+ZL2O9AXCDoXpHesE9zHNfbSywBhvP+kQ4jQUn174SVkyX76UDtb4Ro0n2iqCMMFWa6gW9rDJHRbQECqi9oEwz9nYpyRWHveXL0ls8F97hHZcpzjgqMuoEwrtodBlWzfSQGEl24X8WSGbSlm4mnwtMmeCAIRI0jiYX0RYYiDyJJWNYKKUsA0tWtfEWYs5QeNRRyLckODyyoP8UbrYIwFn2/i7oaqKit
 7LIvatsa
 q8MWCSJcWhZ1xXGirJ368CEpGpz5rn5AtkjK6mQlfrHdTf3nR5Fp+zpYYAKINbocBTk59awmHi/Iyy/NCtZjq4tCQr8fgJdzOcBAlZqcxnzK2PquyGCpYiVvGcaFTcOP1q3/uQoWDSU6SiwARxv/iPvMykxthraLZwTH0GiG5Ffex02f1F00R48VV9zO6OGCfR4d7KTeJCKovr3696rpLWi/5ujN6nHqdCy5NRUmUKWSEj1SeFmMmdo9oRGO1G1/Tuma1e7DiYkpUNnapZ1FkejrOOgPR+ygshP5y7lpOB1O7c/UmBMo9tWyuUpjUP6TbG/pkCqqTvakCddTyUN5KZozwaqVmgsWe5y5rnADCcLzwkR3pXCxwiWa2JRUhXW5ONIEIzolXzGuFvVUxTli9SGtK6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 10:20:37AM -0400, Mathieu Desnoyers wrote:
> On 2026-03-20 09:31, Mathieu Desnoyers wrote:
> > On 2026-03-20 09:21, Harry Yoo (Oracle) wrote:
> > > On Fri, Mar 20, 2026 at 08:35:46AM -0400, Mathieu Desnoyers wrote:
> > > > On 2026-03-20 00:17, Harry Yoo wrote:
> > > > [...]
> > > > > > [1]: https://lore.kernel.org/20260227153730.1556542-4-
> > > > > > mathieu.desnoyers@efficios.com/
> > > > > 
> > > > > @Mathieu: In patch 1/3 description,
> > > > > > Changes since v7:
> > > > > > - Explicitly initialize the subsystem from start_kernel() right
> > > > > >     after mm_core_init() so it is up and running before
> > > > > > the creation of
> > > > > >     the first mm at boot.
> > > > > 
> > > > > But how does this work when someone calls mm_cpumask() on
> > > > > init_mm early?
> > > > > Looks like it will behave incorrectly because get_rss_stat_items_size()
> > > > > returns zero?
> > > > 
> > > > It doesn't work as expected at all. I missed that all users of
> > > > mm_cpumask()
> > > > end up relying on get_rss_stat_items_size(), which now calls
> > > > percpu_counter_tree_items_size(), which depends on initialization from
> > > > percpu_counter_tree_subsystem_init().
> > > > 
> > > > If you add a call to percpu_counter_tree_subsystem_init in
> > > > arch/powerpc/kernel/setup_arch() just before:
> 
> [...]
> 
> One thing we could do to catch this kind of init sequence issue
> is to add a WARN_ON_ONCE in percpu_counter_tree_items_size:
> 
> size_t percpu_counter_tree_items_size(void)
> {
>         if (WARN_ON_ONCE(!nr_cpus_order))
>                 return 0;
>         return counter_config->nr_items * sizeof(struct percpu_counter_tree_level_item);

Looks good!

-- 
Cheers,
Harry / Hyeonggon

