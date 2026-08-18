Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B821C5DF67
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 04:58:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59AA06B0144; Tue, 18 Aug 2026 00:58:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54BF16B0146; Tue, 18 Aug 2026 00:58:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4620F6B0147; Tue, 18 Aug 2026 00:58:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 27C526B0144
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 00:58:52 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A92FAA0AA5
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 04:58:51 +0000 (UTC)
X-FDA: 85113185262.13.87D4779
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id F4021140005
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 04:58:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="U2t/Hnh2";
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787029130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lbvX5zjejzGb7rwtYKC1a37V4CKC0PUwDuNPU4yumtU=;
	b=2ndL4XRmuxXv79Hcl8o1cUWKWBnExzLPjzMilBposLOTQQyNmwfzlyN8x8h3T/tNcF/ddl
	79l1i8hOWot/Qlky8XEnfXZ7ThKKtsV+XJ+JCzCje5Q+VO1V9mJSUYgyraH1gbPLM1f5E/
	/fWlifmpIpXSvs4zqNIGsDQDzbnD9ao=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="U2t/Hnh2";
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787029130;
	b=LUHb5S7QkWgzSxAlTltq3EF3/0/3N8De5StX97pSVsqbxtoop/rUba5/5Qn3I9xBpP3HyV
	kKaFYEJm7+yUMx2yAgZnx+sdn2iGNJm/Otzee5ZUkV02EjS+qS/QD6eusd72MpeKsHNaAl
	ERb+U2uTwzTDlj9DjBlLX7xIZpuzHuE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 36765401BD;
	Tue, 18 Aug 2026 04:58:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF1AB1F000E9;
	Tue, 18 Aug 2026 04:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787029129;
	bh=lbvX5zjejzGb7rwtYKC1a37V4CKC0PUwDuNPU4yumtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U2t/Hnh2GaeTyUJJ8gd7aeudsvOMoTXLBHrHYqhwq9YSyFud/Jig7BLlZuKFZqb4v
	 +B5HJt21edC6UdfnnqVSzYjVmMKCDxd8yjaK4f4Ws4xb46uRdKdhchZkgz3GCkoH6V
	 4WGoxmeGZN/Nwz31ef6M5ZK5ywYv1IL6XrZ9g6yC3bWs34Ab/3GR+YWVdxRd0uKnlQ
	 uhrLD0iw6k/aRHoMbrZx6FreD/2T69vjFeOTjEp0L30VQuIUK4K/u7VGJbDlzbu18q
	 eiMhSqm8vKjtCVSlEbexlRsIgBtQbBXeBYyQ5zeLmdfoF3YlNe+AfHhRUBeTEAohlo
	 AWztxocTqQblw==
From: SJ Park <sj@kernel.org>
To: Jason Angelov <jasonangelov@ucla.edu>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	shu17az@gmail.com,
	jiayuan.chen@shopee.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] mm/damon: add kunit tests for probe_hits handling and probe params validation
Date: Mon, 17 Aug 2026 21:58:38 -0700
Message-ID: <20260818045839.97408-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260818034552.11975-1-jasonangelov@ucla.edu>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F4021140005
X-Stat-Signature: ak3sdqjgby7er5s4o615aa78yh5iztb1
X-Rspam-User: 
X-HE-Tag: 1787029129-877558
X-HE-Meta: U2FsdGVkX1+U2YaR+4b07AhDR3hgpGkCdg54z2I2Ybq+hYghtKkjq0w9Wsl02/RtVCIk1ZZHeRr4YWyUDujDvfpSYZ6Cy3wrWlVE8HNB7zKUhKQWhN/I2kRB3mHpSRdhHl6b/ZXUgid7HBYyNRDhj348N2e4C+UarBe457HiAgtvbT3oGiGjD22rqOtaOPVxXqXlrhzgOddmmGP3Qj7OZyhm0oSq/Pb2pfzDwTD9KMyKLbw0V1h1ZYZE4NE8blUTEwQ7Mrq9HJt/162ZIIbzpVn1PD1cORP2SeKwB5ZZn+wrmcHftGdy+2E+XkFyETOXmJFQzMXwuFddGXs0ZWTEo4lYN6TzPG9kG34qqGGAgVkLhZKK+6Fsvlj8yDXSIlX78olN0/C0HBhKljjqyRm9F+lUflR1VkkXdX30cG26gJP+SKu50LpSTiZ2Ve0r2MQXtQzbXsWCvEDV+8a8GMo1yTsaEoTUY5hiCZqAOwcmi2DAjPTYBsYF8WhMgoVcBmdIPXbsVCckg7fQQWmm+Tq4ezSy5JvHQaps0orFBKhjU6kyDNhW7tGcexyYRzsnWKOt02V15EJAB9v1zx40LPC/EvXrcpX/moVZrgynV/qNVj0HvGXRl1rUd8n4RO1ERbCupVybXUXT+iOZmBMFa42PdtzDG/Re4T5iHjL72UD5p5y1ZxF2C4I+sWtj3EvC6Q1Fd40OJpGj61+J57Y0oOSECAq7B6W4SkVOVK7S7QfXDUGmU3I3To7pMHjG9HnR3x9sDbar4rgYWGAGYCuVzmD/10DFmdpg5YNNnXkPsCvsx4VidSsqLVqULGRRj4N2S0OLKR3n+4s0tkGft554PcOwy0FjRayuSP3MlqcEvzw5/PH3uC/KsnU+aS3Oq1ENHc05vHe3Gh38mDOJ0/SAOZORJ2Sf4B38dkf1M/LnuoU+yJD15Itkzn+lfX5O5EOATCgS4Lgx8bLxxezXZanNmIe
 OQpRGj31
 +zJkImACWfX9QMKouGDmdHOEK7u8KFi82ZC3u5y+C9wmvOILYr+UZYzXZJYMac0NBaP3goumWH2lKZN8lvMOxNVZLN/wCY0RzyZVIfZJnSHle0mniOWei3GwWunJR1YDZi9aMSoNHEkGxtnFVa1XZlYPLPUuoMT/Fy6Rf2s/74GevC2GjzZMkyknzt5854txqlK5+uyxYEzs2jkBofhp3v7aWWqTj1PMglrw4VL1bfNDiUnvPJr0w12vICU3oN0vYdKkq4kcqVH/xfGvFTsbMPCxtvc5xLnfAkCLvZ+cAatDanK3gMlulqTt7iA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 18 Aug 2026 03:45:50 +0000 Jason Angelov <jasonangelov@ucla.edu> wrote:

> DAMON recently introduced probes and probe weights. Add kunit tests
> for the propagation of probe_hits at region split and merge, and the
> rejection of invalid probe parameters by damon_valid_probe_params().

Thank you for this patch, Jason.  All patches look good to me.

I applied this series to damon/next [1] tree.  If this patch is not added to
mm.git in short term (a few weeks), I will ask mm.git maintainer (Andrew
Morton) to pick this.  So, no action from your side is needed for now.

Note that we are in the middle of the merge window for 7.3-rc1.  Andrew may be
too busy to pick this until the end of the merge window.  I will make the
action only after the end of the merge window.

If it seems I also forgot doing that or you cannot wait for my action, please
feel free to directly ask that to Andrew.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

