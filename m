Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 110D0CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 17:19:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60EDE8E00B9; Fri, 22 Aug 2025 13:19:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E6BB8E009D; Fri, 22 Aug 2025 13:19:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FCC08E00B9; Fri, 22 Aug 2025 13:19:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3DCAA8E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:19:37 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C042D830B4
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:19:36 +0000 (UTC)
X-FDA: 83805055152.22.B6EF0B1
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3A74D1C0006
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:19:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G73CbZDC;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755883175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GExbt+9NkOP7e5N77Re41QVaqPOlBYQr9613Z9xF/fo=;
	b=T/Jwnj0Lo/7iBIXJGY/HdU0sNaVMWAEBV8TlUylQExq3kBytOJeiFnqhRuQTyV8mT9Befw
	Kl4jDBKhdeG95a+OpXNgYpXcJeQMc3OVju25qGjgsLkPK+/7AagiBWjZ1wVk3oaq1DXGLU
	wf+A0IREI9VF0W9QiLMNl75vpus6I84=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G73CbZDC;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755883175; a=rsa-sha256;
	cv=none;
	b=1LYMXkfOBuRBiG2MEwWl1XJEbjIjvbJArN51+9lY6ug2DNnq1E3w2mYwQP8RgExLudSxd/
	9w6lOt/bTyofuoMf11chi9+Sk0DW8hnouApwfjo70c82SSo7f2y1GDluvn9QIRox6yye8H
	hAXnf1j3B2wAJx8pYIz4T6/xNmoUhZs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id A219AA58B34;
	Fri, 22 Aug 2025 17:19:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D1FDC4CEED;
	Fri, 22 Aug 2025 17:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755883174;
	bh=2swlyeBT/bcwBSubBT1dYyvfKoicsRMLgw49qnxgwb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G73CbZDCMKUrbLz74C9Z7C8zuSKg/AfoA8WMBWCumKR7Qv9T3vcqsQ7sVZ2hTBDeC
	 PmFOUcAJXDKQFxMWe+P2HbRHHvynJ8eWBYSr8+nRilaqVBK11MV/50QC7M2C0Fbboo
	 Yo8alWdAVccYKHphkxE+6r+lgp2noo6o/aIpcBQRPfoM3CVyL7qoFHVqdV9qNWbKoM
	 Ly3dF9X/Le8+Pi6Qwtg3Vc2Hh89FDwAIIOhbBB2ziZt+FOPkL+3jwm5uCIRGtXQQ2h
	 WfVVLNP+C0wwqXnFiTRL3P/zRmbYm29D3n6hOUSOat1QXoLJTjvQgk2rHczq5egcb8
	 Hv0HZPNXfSctQ==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [PATCH v2 11/11] mm/damon: add damon_ctx->min_sz_region
Date: Fri, 22 Aug 2025 10:19:32 -0700
Message-Id: <20250822171932.53804-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250822093420.2103803-12-yanquanmin1@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3A74D1C0006
X-Stat-Signature: jtdjrgh3eweidt1grrnotnfr6ftnpfgu
X-Rspam-User: 
X-HE-Tag: 1755883175-568661
X-HE-Meta: U2FsdGVkX1+PzkvrsPlVIB4tKgC9uUEBoQATpntz6a9JMkXrRmBsnt68oWFF2VLUZP4hVSko6bZomZpa7BXlYdhdZjzhywlhGqWz0H2Xnj3DviV1w02x3kDFdIy9QsFALYr9EwlMPJTv/wJvYekjE0N/ZB5YSGs71qeUMR4muYhnVXZ5AKkg6a7AXX13mS4lKhaHpDFVEcjBxKt0Pja9Wbm/mpVg5Lm6wZu9L9IKPTgiMnR0+moMbgc4BOBjrgiIG8Yc2nCQMzS9IzEn+2i+vPuaJvkGjGmDKNJ0JOZKs98VtG5822buNhXjneGEUpRcwKc2vHu3JpTLdDS6Q/Hki7XUHgznA4NtwrHT3ZvtsN0Kyw7JwFB60DqhIftFygtTLkoba47IIgcGoWErCT005JUmbUudEnw4prWzkfyz0GIHtMxUnFfAZ6JtmA5fBXzqIA2Zgg34tOXOjCSd3od+HGW3fMf7rX5LxKFyu3rRibg/FpBI+hnlH8Q2VGFUHZ4MppoObOoUyoaTfctCMoYo0dl5CY7TZK2XBsLxpwIzubQshcO3Rp/5J1H+bG9rUgqE+YL8gxfelQZhs8/Vju575MnXhNmQzSKxPi/ScaqN2g3nTqoIThZoVu/rbFbnYsdRv3Ra18nzFuxT7vRrRcB+N9R6MxOnVsLnnppKlESrL7nm3ea6bc+OOHBqZ4Fbea4xT1NAEcLSLFj83i3T8f9LwF+lieiCpvW/xY1/Xb9LGIcQ580tzQK4Sgv3qDyYGgGYqXhEnPzHyD+BLfMDnKX1mqgb5PW2dMciZq1YY2JMA1U9izNzDcFnFGcsquuKzrRL03kj6a5SGdX2HrmeoURTS7FIsIrE053ouaHIo0UwPN4fTrT3zOpqommK+a82R0OBNGQh+NrQKtsp7tu23b8vpaaZJqbsUX5ehsfzgAcA3mEvG/5xf0ib0CO0WMu9+b9fVzUyfXkhQ0IvXCdTKP8
 FYCpB3oh
 +LTLi6ZFqr0XaLm6iqkxFS15qV5ts57+IWW6ZBNgDAsFx9yz24mVvkEgKZIRD2XX2drn+C6zK6Mx46Yg09m6kfGr2rpVTEg+AXchDML2YR8KeswXuXrG4K6zq+9O49rtBagj14LeertZdm5uNhwvr0OtUSF10hALl6KV/SRIexnCGMkSWWsW9p5OAMztDEntdVoga0Pa33jzRTHrNqbLFd4d8pUFRozLHsw1fNxQ5ksdh4VgtIJhk5DDMaeLK/Pool5czTLJcw7LE8UuBVPkPyBQIrDIndbVFMDigyNWYpjvsNew=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 22 Aug 2025 17:34:19 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> Adopting addr_unit would make DAMON_MINREGION 'addr_unit * 4096'
> bytes and cause data alignment issues[1].
> 
> Add damon_ctx->min_sz_region to change DAMON_MIN_REGION from a global
> macro value to per-context variable.
> 
> [1] https://lore.kernel.org/all/527714dd-0e33-43ab-bbbd-d89670ba79e7@huawei.com
> 
> Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

