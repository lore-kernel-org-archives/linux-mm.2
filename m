Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01EF1C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 21:40:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE7586B007B; Mon,  3 Aug 2026 17:40:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C98496B0088; Mon,  3 Aug 2026 17:40:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAE306B008A; Mon,  3 Aug 2026 17:40:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 994A86B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 17:40:18 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1D93B1C13F2
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 21:40:18 +0000 (UTC)
X-FDA: 85061276916.12.AAAAE66
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1E010C0002
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 21:40:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=b6VwgqfI;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785793216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Bg2LdVq1/Og7fOxQWrSuRusd4/7PR3QXSV1Hts0A/w=;
	b=aocaAm5me6N3vgIBpgRTDC+Ptu4xByX1eCQRQCW5cu260+4V3q7jRYss7xgTjrYFRomu6L
	Je//NBYaYNF9QZwIrnu1m+MESCxdB1PUBva3IUNnsBuYN7JfX4Elk8xLYcfj7UCf9+BKeg
	uAKPCsuDmbnuhnHtn3M40iwcWSmIERk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785793216;
	b=TkaYVeS75qP2C8MAW+e67creMvSZLitLJqhldBEMsS/OU/z9j0DNbQPRWpbQydp8yvrEXv
	juaQ/IKJqu9HzSCzfPXvjIvqTutSv2G4CyP6gcrvQDDlFtvIo1c02/25c27dkG1bnntfhT
	yij5fav/FswIR01A+M3/v1gcxEGy36A=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=b6VwgqfI;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 30C0742ADB;
	Mon,  3 Aug 2026 21:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F4171F000E9;
	Mon,  3 Aug 2026 21:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785793215;
	bh=+Bg2LdVq1/Og7fOxQWrSuRusd4/7PR3QXSV1Hts0A/w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=b6VwgqfILcG8FeFaIWu+DpKiAAl03QgVszTQCrSWT8MAKoNwAbNTlkxRN3uWu50yP
	 NJZ50HtAspJQ2DQlmn8EcJUwz7pLZ2M9ff26SidVSUGVu/s+V1ZwZF8BIh+f8YCjzw
	 F54QgJLm49aXZwLS2fQZ3AegJIsn4oU9jZnbSqdo=
Date: Mon, 3 Aug 2026 14:40:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Li Zhe" <lizhe.67@bytedance.com>
Cc: <apopple@nvidia.com>, <arnd@arndb.de>, <balbirs@nvidia.com>,
 <bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>,
 <kees@kernel.org>, <mingo@redhat.com>, <muchun.song@linux.dev>,
 <rppt@kernel.org>, <tglx@kernel.org>, <linux-arch@vger.kernel.org>,
 <linux-hardening@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>, <x86@kernel.org>
Subject: Re: [PATCH v9 0/8] mm: optimize zone-device memmap initialization
Message-Id: <20260803144014.e2d4ebb83e9471b695f6290d@linux-foundation.org>
In-Reply-To: <20260803070929.86075-1-lizhe.67@bytedance.com>
References: <20260803070929.86075-1-lizhe.67@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-Stat-Signature: ht3t76b6eu17xe763qgdiiehzr39arwx
X-Rspamd-Queue-Id: 1E010C0002
X-HE-Tag: 1785793215-8230
X-HE-Meta: U2FsdGVkX1/TFED2IF+BjqJOkonTBWHiN1bEdgjVq3JNLJWoA0sBq69I8+YjZZq/qVl7CVsk+kPe0dd+A0EQW0OwgbxKQEir6+jAAiUH2ufbpuppwH2aJsHr0I4NEVcTZJBbaKszhkwt2YYrSekP5etkBuoHyoROgzdatnsijHthtQah+Cx1UPD1I4/8M0mZsPdYsa43Slck+vlB1KFVbb0Pw6lv5rOLygpXas1IRKFZkQ4Hbw0FXeE+vz8VYYdo6mXmnppM4NSQ/h+yahYHtmrydFRTYlZnMGBHwL4X6n8N+JK7+tO40GERfqM5WSKtU8h2a1PxaBZvlba6lLzQiRPlmo7IvcKzyXu8/CjPIv0gRCUgBXr14XX8jsIeu1r2/efCoGDGWLB/zq6sGekClO09K8a4rdJgRADA3Z6HO1nxr79hXF8RPJo2qIYB1EMCQ3H/UrfrtvCgeSj5wvYZiYUx0I1axWUlzcVV1KVL/3tozRdeLPurEIMJJ/zRbt2hgJIfYYU7XMhchmUnvPK9MgXS29c+PpcWYYkW/ugkBEQ0qE0vheXHPFT7T9PUJEOUxIvtjtkDs54OmkMw0UyGnux1qnvX+SNCs6PoRyDZvCd1pNxEF9hld0j2m0vrzdghKJCTztIUMpy7sAOutWnuko+6qp+S6HUaEkkjJibfUCdhYhLNjbtdv6/cONENxXLOa2LZFQPQINKMAfQ2WFDcJkgixx9EdWharWdr0jJf8t9Au6PcAq0X9cfveDUf7I2AjYdJ7dJ8+mv8BHL2qjGnENCclBcBwtKbdfMRiS13Pnm5dU7JCNzwegQ1I5S5siQJ3FKMIrtDYKTKC+xdPDIEnI5jmaD2pY/xqzGZFZm8bVZB6Xe+2Cn4DAjYl0XmW8qJsJWpjKYyNB8DqPpct1vjMOyqSP18jC/1iwVInMTum9GoiyZJMUnnk22N9HfmPHYpaRhpPbIicOtWFLRXQQH
 RWSq5rqz
 LNa4d/kfQxqq+3+5XB9mgpMvmdVvFxXUz7x11Pj+1Rv8rNZE4pw1N6UXoFdVTa83LLD9HlFcN0wClan4yodo4LQoQaNdLAwyuPVnXzbxg4XXTcOEMwnAPpQi3+l6bUp2tUd6kcJBKNDDpQJP5k2BM+WqrIM4mfZI3xOVy+SD77kvSVG6CD0Ygh+LIdv36LUWquqAfp949dICqZT29nkFIHIRRYbX7VcH1YC9g5QrYcl6AudJkFGv+JJEbhzgJyaChy0V0NGvIG5A9ZmyT+reHU9dm7XHN9en+vsF+D2jUQdvwXMJHZXVqI3pvJv2tjDMjtZtlqj66Zk7/pzPqGsr+Uan3Lg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  3 Aug 2026 15:09:21 +0800 "Li Zhe" <lizhe.67@bytedance.com> wrote:

> Test procedure:
> Rebind the nd_pmem and dax_pmem drivers 30 times and collect the memmap
> initialization time from the pr_debug() output of
> memmap_init_zone_device().
> 
> Base(v7.2-rc1):
>   Average of nd_pmem rebinds: 244.28 ms
>   Average of dax_pmem rebinds: 273.31 ms
> 
> With this series applied:
>   Average of nd_pmem rebinds: 96.79 ms
>   Average of dax_pmem rebinds: 119.04 ms
> 
> This reduces the average memmap initialization time measured during
> rebind by about 60.4% for nd_pmem and 56.4% for dax_pmem.

Well that's nice.

Review is partial and it's late in the cycle so I'd prefer to schedule
this for the next -rc cycle.

AI review might have found a couple of things, please check?
	https://sashiko.dev/#/patchset/20260803070929.86075-1-lizhe.67@bytedance.com

