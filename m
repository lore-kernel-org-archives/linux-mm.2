Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6529810FCAE4
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 21:33:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C36BB6B0089; Wed,  1 Apr 2026 17:33:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC0136B008A; Wed,  1 Apr 2026 17:33:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EC126B008C; Wed,  1 Apr 2026 17:33:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8C7346B0089
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 17:33:06 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 46E7756D5E
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 21:33:06 +0000 (UTC)
X-FDA: 84611287572.10.4D12BD1
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5E089180007
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 21:33:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=sTU4sW97;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf16.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775079184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/H8Le/lSCc+EAdY9MpvFA1yefQ1AJiCeDzALO0unz3g=;
	b=JLBCiFtCgXXlXkpp3pOGtyXrkCWvv9ARTC+gv5MHgpeC5Ib78p+HDvVa3I9AXSRCoZFjYZ
	X7evz5rCiHBaIo5hFRMjZODh+xIXIl8HU3rR8hbo+Tu4qfzkNwewR6BHSasOGXoQYEzysc
	hdiLK3/9OdIyHqVVGAOLyBeOau1Hyrk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775079184; a=rsa-sha256;
	cv=none;
	b=vN/LbpskDOfXvP5LJeqY5p32neURcNV2wlnlpSaPslpOM5VT4ARqG996Hq//HJC2eBVwin
	hjviLajQevwxVOVac3DHLv92gB17gnmxVTqeXcCg9PP+Mf82FKVeWeSTF2A14e/LpJEbX/
	MqHQsrg3NPBWslNCg7a9+KMsyd5cSZs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=sTU4sW97;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf16.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/H8Le/lSCc+EAdY9MpvFA1yefQ1AJiCeDzALO0unz3g=; b=sTU4sW97F09jY/E5mzq6mswEYa
	R2PheddoUldiP4cY3HvX3ODBHQa/cLIOVO8Sl74FtyNl0DwA46RLDW34iGGoCEKmZOerVrWRtdWTN
	S1F1ZUOcuGNoX7itsb/81qKt7lOrzxF/adEqwqNtKdpUSmeNbdZeFro0eyVuHDdfIFa47UX3Lmujq
	dv6x1PreS0oImZcmyQyYtPCc5nvfa7gS4I5FLEGcnCwwfBuOFiHwHWGm1RtsCvVVj0x7B8duVzH5m
	XbRt73kaFg/OlMxxGDhJzJYm0mv2hLRSZveyG5Yl5uxhgmsakgzUrcuoCEkH3YYDSa5m7Vniyftjd
	k5HU5zdA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w83B9-0000000B3i8-2xWX;
	Wed, 01 Apr 2026 21:32:47 +0000
Date: Wed, 1 Apr 2026 22:32:47 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, david@kernel.org,
	ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
	baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
	weixugc@google.com, hannes@cmpxchg.org, riel@surriel.com,
	kuba@kernel.org, edumazet@google.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/vmpressure: skip socket pressure for costly order
 reclaim
Message-ID: <ac2O_3R--3W7cgCx@casper.infradead.org>
References: <20260401203752.643259-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260401203752.643259-1-jp.kobryn@linux.dev>
X-Rspamd-Queue-Id: 5E089180007
X-Stat-Signature: a5eq46n9ryp8kf3yjzttxttwgmidtps6
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775079183-4802
X-HE-Meta: U2FsdGVkX1+ED7hqHcRH/3pWBJwrEOoaINFMoekB1dbSo8HG9wPnI1+sw4wHYwPNLwG+s0Ebl1d2qapj9x3LhYvGRiDl9L2kJMVg1n7Bpjo2S5TUsxHNUIVDWu4ovW2KMRDWBxwo8rdCBD5mf/16evPE41zm5YQaTvItTfpFSu5lhHQsYN3YPmn1t/ldN2YuV26+wDzhhitHSp1luqjU6Am7r0RLG7t6HsByvaaM22c486UoUEhCc+Y5B1lNF6gCiAFtidwPK7kmdxEh2Sy9bBckljV8UkNdXnewxVDT/OG17BPZVCsI4Sn6lyLgoZjuxFkbi44jQ4BIfyNUiLEX/wUVCr5OPSNt7zQnYLY6+PAnSB92Q/X6tbdpzj0U4p80CHWBoTGkgbjdwRbuU5ySBE9ot866mHLOWnO3rk/eDbnblT9F49f56J58VYZ2wd6TojcvIEr/tKaEqEtpFxyRmVTSPpXLhgK8Nq1ZomB2RkDIwMBzoQ58jb4ImZS5Us7r0yDIy85fc6w2r7w8gbFRCpmeQceorlk/Hdr0m5FCVfqWd84GJcojOvz4pmU5HZpyCAAW+pOZEdcU746MWVUEczWotT+FCnhMZDvTY5ir3iKWlf6FoA7WbEzqQicLn/X8jQxA68WxK+L+n47/UvMJF6FTAkP/psQRsEfbBbhHXmtgAUbW+zb2I4GGNsTbJmKUiD8E9IFxaA7fZtwg0tf3/1wH7/igrx8RKsTS9Q5GReyMsYbdogJLFvw++8krtQdNHp8mSCCSZ4jZm7kSwBBG9FtRsbX4c/P8+0aiNhJe+IcxSX50CPJ3IuaMk82ioZgw85smLOx71r0LAMW0bpbjazIVkR/RMMFSlpiTnfhKjhxL6jfnH55IKwTE554jcg9ukLSk8ZkzQR+2FRRTUjHob4FYze2c9RKQgy9Mso5F0HdEAnwWDhVJwsu7jqcWURAu92FaqGMAxRDLnjUBZvx
 RU1LKn91
 +NBXqwNLcIvtZ+MRICTuKa/lZNwj9SHP2/MQP/6FFwlXLR7KXF7CiyPVDMKbeLeUDY9jIrSh/0z95idnoa4AQd04/5n43fCq1IrMpWm+JJlVeX4zBydfrpBrfZxcFyPrncyE8s5uK5PIi0nQVeNZhORyW5hbT2KNmKTH3fzO07Ezzm3/llUflYZM4DCe44wgbRXlwWJtnIkx4TXsQIqHMSW/Dpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 01:37:52PM -0700, JP Kobryn (Meta) wrote:
>  #ifdef CONFIG_MEMCG
> -extern void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, bool tree,
> -		       unsigned long scanned, unsigned long reclaimed);
> +extern void vmpressure(gfp_t gfp, int order, struct mem_cgroup *memcg,
> +		       bool tree, unsigned long scanned, unsigned long reclaimed);

You can drop the 'extern' while you're changing this line.

