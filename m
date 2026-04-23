Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C692DFDEE38
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 17:47:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C8546B008C; Thu, 23 Apr 2026 13:47:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39F416B0098; Thu, 23 Apr 2026 13:47:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B5746B00A1; Thu, 23 Apr 2026 13:47:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1D8476B008C
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:47:05 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D3F861B7A69
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:47:04 +0000 (UTC)
X-FDA: 84690551568.27.9058808
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf26.hostedemail.com (Postfix) with ESMTP id EB3FB14000F
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:47:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vQQu5ula;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776966423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hxsr+udpgbwIYSFqjXA38j1VeRgFqtPhxMcbAqGt65A=;
	b=Wcs56ByiEPKN01deSriq1MeUmaXPUnDWGg4um7eEKdd0TDH1n4sK53gZfCLOB8/gA3kSFs
	T5Mi8Kx0/Kmp/dKl0tcs9wBMW0kY762W78lQHJ7wxwbZxnVLx7rIKl8CMMntiKpZgzZ+2R
	ankKlzrY7p62VSFED5wH+g+f/gMR6KU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vQQu5ula;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776966423; a=rsa-sha256;
	cv=none;
	b=6uvc7yGLaP9cOwLjAt+sbTH2JyQuNGqVqyiAtXyaTd1ISC0h+xsCPNG6FMcQrNWs5nLw9V
	BwdCXH8njp3/rZu9sOSSpkRbIltYON2IE5hGah3wDCf6QfVW1B7LUT0ls8K9UTXJpqMijB
	95zRimoSAHVWfW/Rsf9RU43HSqB3ZoY=
Date: Thu, 23 Apr 2026 10:46:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776966420;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Hxsr+udpgbwIYSFqjXA38j1VeRgFqtPhxMcbAqGt65A=;
	b=vQQu5ulazW72Tyv0T5UWjs7MxU9nwVAXIS1eg0GWewP+Ht1SgXyT4DnYC6k6AFCp0fJZ9t
	Ql1oxZJ58pQzxwVJADzvXumiZQxlta99GSevB52Xg2XhkBBEopVx7tMNMg2Ctd6f9MGIhr
	diPBR6XAbkR69VRGs6Yndoz3BmgewHM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Bunyod Suvonov <b.suvonov@sjtu.edu.cn>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, rostedt@goodmis.org, 
	mhiramat@kernel.org, david@kernel.org, mhocko@kernel.org, zhengqi.arch@bytedance.com, 
	ljs@kernel.org, mathieu.desnoyers@efficios.com, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan: add balance_pgdat begin/end tracepoints
Message-ID: <aepavbLy7H3odp6p@linux.dev>
References: <20260423103753.546582-1-b.suvonov@sjtu.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423103753.546582-1-b.suvonov@sjtu.edu.cn>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 1ff3pgcwjg5yc6i1yeb53efmdn4u7m66
X-Rspamd-Queue-Id: EB3FB14000F
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776966422-718457
X-HE-Meta: U2FsdGVkX19UJwO8q/PvuEmQ0WYtSHPPR1uW+nlTgHQXiIOwhGGHX9OCWa2rVDQgWpBwQy/DG273xfudY7OlMP3shzeJeWq6c9PsIros0QAPJq+ZRAdS/m2Wdt7CsxGz7VuPi6Lr263bd1BmxLEYGwMSmRMt1ycLD//0KJkddF71Fl4yZdYdX2veRHRBfQaD2+S/hKvJGTxN23E9kJ64sJIOmU/L3vtateUTUMSgqjfBPoscuyGHinDFjL3etnJObZ4b5ygOSXE2TgCm+jz7AyMN4YygTp0kgv9jPrZVky7m9otrXE+poWj324fOXsooy5P0UAwbMdPytwMSfKivh4MF0UVjP87gN7wK2e2EwTMKChIhjVbRY+sMUGKiZ/np7YVuH4C+0aQCC8bwEEgska/wmayGHwPXOJinsgzHtq/226c/H9dhNjJpx1dme7CxO9mVs3P9V9VxvYIf4ldOSp2b7yxe8MgXTYT+vV1Qnn6G25tNLP5EeFPMatNhNUuWOXURTkhVLfQfbFYq/vnm96XkHjQwVFVJpiEKN76bza/0tZx4EujYkJ91lPZ7JoBDcFykmJ234H5xIHXTBI67siTA8nTZQsmTmAS4Nb0lEj0wTLcS0GQr2YS642cXW3CDBmmMp0OlPBIVT51Cb0uae2qlYt/nQ9Q/YfDtG5HxJR0bI2NPssUxQGV4VncRa5ARhgWtA5v/5jsj3pJ0lkzr8q5BK873O6kEuPxsQaHf4k/XbvImfipC9ZeSZXOxQK3RDDq8M8kvrVhyV3HK4C9Os46QRqOGAhCqdjVJPp9PalMLRYUuDuSHqRt8Ov7W2q67JvdNqFPS60u55zGEyhfVIZn7MEE7aaUROhXQRLIbKXh8lwD7EqL6ikrkTiZLXdPdlBPy7F/j3fHfL3Ej7tn0CCR8oBQg0mBscv00d8QwOT0d2HKj41oZm4xwyq0uXdb9F9PtOVoSDW9YoSA5UMR
 uORl0z9V
 0c89ZQiOqOf4PV+eXdxIOu0IiNNKo8h4DYW9cDmtUljKVeQMbYhAuaI5+cnvo8RjedGF9TE4rI0qrLBXdCujbnmPMbDPd4rTvJkXENCjVOzZCuZcOGdvYNID4R6zVwc9abqqkfKkWQUiCdoMcGYOfdByf0KJiIoyFtgxszJu+aEnAgGKESScxUp3D/Z4TabtYulAnC68agc2ZYqoq5T2Y2GLJPpQIO157DfcQZMb0uG4zyfU5ct+xy2Uk4eN3JIGZSdx8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 06:37:53PM +0800, Bunyod Suvonov wrote:
> Vmscan has six main reclaim entry points: try_to_free_pages() for
> direct reclaim, try_to_free_mem_cgroup_pages() for memcg reclaim,
> mem_cgroup_shrink_node() for memcg soft limit reclaim, node_reclaim()
> for node reclaim, shrink_all_memory() for hibernation reclaim, and
> balance_pgdat() for kswapd reclaim.
> 
> All of them, except for shrink_all_memory() and balance_pgdat(), already
> have begin/end tracepoints. This makes it harder to trace which reclaim
> path is responsible for memory reclaim activity, because kswapd reclaim
> cannot be identified as cleanly as other reclaim entry points, even
> though it is the main background reclaim path under memory pressure.
> There may be no need to trace shrink_all_memory() as it is primarily
> used during hibernation. So this patch adds the missing tracepoint pair
> for balance_pgdat().
> 
> The begin tracepoint records the node id, requested reclaim order, and
> highest_zoneidx. The end tracepoint records the node id, reclaim order
> that balance_pgdat() finished with, highest_zoneidx, and nr_reclaimed.

Do we need to trace highest_zoneidx at the end? Can it change within
balance_pgdat()?

> Together, they show the requested reclaim order and zone bound, whether
> reclaim fell back to a lower order, and how much reclaim work was done.
> 
> Signed-off-by: Bunyod Suvonov <b.suvonov@sjtu.edu.cn>

Overall looks good. 


