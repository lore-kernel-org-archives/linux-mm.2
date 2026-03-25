Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A95611075269
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 01:24:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89C696B0088; Tue, 24 Mar 2026 21:24:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84D296B0089; Tue, 24 Mar 2026 21:24:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 762F26B008A; Tue, 24 Mar 2026 21:24:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 65AB96B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 21:24:28 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0962D1A05CB
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 01:24:28 +0000 (UTC)
X-FDA: 84582840216.14.0F0D5ED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6E7C1140005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 01:24:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="g5/PSVdV";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774401866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vqa2bWddDU6XV8CM4CDB7LCD3kZXcGd/DfbHcejua3Y=;
	b=YTadCpuZD3GF2SzAxDeUvkEvNKiKwXitpAa5GS1eHPukHY9jpoFzSWROzP8kRPx+eaZhCw
	T+El/6OLFNTI9sCG3S+r/1b6+7pYmFSFmBJoe2y9iKOWKYNq0Vlw7N4CTc7zvt2Jxu3W2g
	nhqM1cTCzAj6UKqT6LZcphjxf0s6IM4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774401866; a=rsa-sha256;
	cv=none;
	b=puQyqiIrM0XMpprtQKkgGUFifnr+FPbbFmoKz5eeZIhPgsE591SNELFo5KbZ8f5b90CYWh
	Y+EdyrQ2eXIO+EG+UuC/9aGfRNf0p7lFQKdz0imTrgVCGRRK+wZgO+qO5s99OQP86s9bCm
	KNQ7AfUDHkpaquo+OhnpsxX2w2GNucc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="g5/PSVdV";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ABA5E600AC;
	Wed, 25 Mar 2026 01:24:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD33C19424;
	Wed, 25 Mar 2026 01:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774401865;
	bh=HmYsbKwFs4P5opJoMQMaxNmUmh60o8lPuHPw/FnXv3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g5/PSVdVo9XAywDdtLl+uLMNuZalgJhlZk9qbPWvpmrnQ0fxSIPK/jUiMm4jZ16M2
	 gQRW3NewP3ajzbI8wXcRzQXiisY4+A9S2QJnfwe4V/OphKcnLt1NLuBQAMI8soaZK5
	 aBpVVerB8tA7HXy+scQNFno3GWDF+JkIIYlaWFDOcfoI9yjS2cKosJ/+XBSeRreDkR
	 4CpO0APDkQfaf8ku9KvXYTqhtmJU9ozUJQ4EPAFtxE0kV5m8pGVOz0deG6OBe9CEHM
	 PXyVFFA7ujEkA6+eVpRkjq/diAx3ppU/L6RzJZNPCpyF1mDXT+w+Ue7fjG9p6DwOco
	 JTxtrT0Jik7UQ==
From: SeongJae Park <sj@kernel.org>
To: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com,
	kernel@gpiccoli.net,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v4 2/2] mm/memblock: Add reserve_mem debugfs info
Date: Tue, 24 Mar 2026 18:24:23 -0700
Message-ID: <20260325012423.85658-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260324012839.1991765-2-gpiccoli@igalia.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6E7C1140005
X-Stat-Signature: zj9yrqu5tgr1eaofrqxarzdbck78gjyk
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774401866-636810
X-HE-Meta: U2FsdGVkX18gPaAK4aIbFP473ux0Wy/Fw+lik9RToo06LHGxLRevYiy9k24t66K63Is3CTLVtpisd3mqf3aeXV8wHwAZndsYRjQlu1N159cVDHddPWOEYB08M53knsbFYUWaSRU1LF169MlbH+ffxzfT5Uw4zEDIoEEnw+DIcT1qZTuNsb8oZ27pfR1n4T9fJL8txWQwlle2Dp1taXwx0EutGLUxMTXN9r15iRTZscqwzw3B1ZLT5hI1Tk8tnSmg/C4C/QL+F992I56l8qKLP8HyyE215UNV5F1skQ20uaZwSOHNwukxwhAzHQfN0SeQvcrXBeiixOB8N2TdlP0Qsh2fuUOHJ0LS0HXKWmrVUlCGw1NyNN3ANCuEAObKtDW5rUS6lm0ZZ2eSpkk8BhPXosF/15kz9DuRfAzPqcHZZhD3689yrneMy7/+t1YD1xqjzOKiCuWgS8R6G31uBoFQ9sNSqH5CQM1Qym0guZBbiLLRo2M4XhFLwUJZO2yxWRz74QKCRpVbHQmoDQwzTEGDs57i4jjnf1k8r0mu0bjE2HE52GWPhA16UsIwn+wz0gdJgCtwkrVEzf45pzqs+zaEtisUHXp9rdhpPts1LDgWnzo6sf3CbCbsVTC8ke9NuoieZXqJP2BEfM0ASjqU6gmBc1ef0tZE29SkdRNoqkNYwhqMQdP6qxcW7JBunj1a6F45vUg1M1BIyJXHlFidVmpZxiLFdnLP5E12plPvH4MfUyORPU8j9VEbFsnre9gjNVFdbMMCV6n06C6xOwMWAk8FzGunLsXdEay9zsLF+wQZewU29Xm7r+RZ3ZOqerr0+2EQ8EQWq0MTIuCDQ43DATnsi3nCiPgFN+ADnBF7yYyWVzxhBW1KXI6gqtjbf4+T1PPZIQEDfSYCw90lkRF8CmE+C8rP3dlpoF5mHxjoCvGBDj6YkIAKYyZg54ha0U/F5y5JcWFZNou86od+mWSqCW7
 1lZ2QPpy
 B/+He36290pnadz7GDPJwsOyQDge4okeXe6/J5ScIEwQ43qioIqOF8E7Orml3NHrMYz4Vpf42weAtROCRJIilqagdO0V4wuAGvfaVX6mtmOYZgOPKKTHf9rrO5DColjOT3xWXxwwXTPANypOHxH96onrnaP9q+Y2l8F8hyYIVWVeejweiQrTTeezxjDV4Pa7bwH1rvhIn0mY1APY+nvuTAowlGGmJYWj3eSt/SZee4vbo9OG3i4Fe2ePvcObNu7v7RW4yKO8yaj78eA3dlLjGxC3fuSW9PZm/O9wmx5FB44i1OVHMu+0iE0huRq6Bojukl58LJuthvE2+om5UWoSMrapWfaci0l/rjUoDpXFB7JkJW3aCRW1bblXjFybS52FM3s8GISWmEDni/ofs04UlU2odsXrTFDL5OYjP9fWcnTV86iVHCSc7x6qioDiD3NLJgvt4dfWRQ9QO/DbYnnAT/UnDMPnDej+qJuIy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 23 Mar 2026 22:22:18 -0300 "Guilherme G. Piccoli" <gpiccoli@igalia.com> wrote:

> When using the "reserve_mem" parameter, users aim at having an
> area that (hopefully) persists across boots, so pstore infrastructure
> (like ramoops module) can make use of that to save oops/ftrace logs,
> for example.
> 
> There is no easy way to determine if this kernel parameter is properly
> set though; the kernel doesn't show information about this memory in
> memblock debugfs, neither in /proc/iomem nor dmesg. This is a relevant
> information for tools like kdumpst[0], to determine if it's reliable
> to use the reserved area as ramoops persistent storage; checking only
> /proc/cmdline is not sufficient as it doesn't tell if the reservation
> effectively succeeded or not.
> 
> Add here a new file under memblock debugfs showing properly set memory
> reservations, with name and size as passed to "reserve_mem". Notice that
> if no "reserve_mem=" is passed on command-line or if the reservation
> attempts fail, the file is not created.
> 
> [0] https://aur.archlinux.org/packages/kdumpst
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: SeongJae Park <sj@kernel.org>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

