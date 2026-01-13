Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AAD1CF45D7
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 00:23:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F5296B0005; Mon, 12 Jan 2026 19:23:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CCE66B0088; Mon, 12 Jan 2026 19:23:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CCB66B008A; Mon, 12 Jan 2026 19:23:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0C8976B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 19:23:30 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AD4718E1BA
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 00:23:29 +0000 (UTC)
X-FDA: 84325041738.22.CA70E0A
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3175240005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 00:23:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="BFyTCu9/";
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768263806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JniOifvm0Vzj6b4Lw5mELotZ+645Lbbt+efHkzvLxps=;
	b=8iUi/eeXeMBtS5v4SDfXGvzlbL0AAiX2CbgQNHxMW3b7bSs73ndY5CkEUKgGUzGFkE24R6
	n6+pJi2xlWeuZmq0eaZf3qMQGTBnIKKwWMzWxdvtJtlDqOQExuzmbLaZq+aojnHc7HAWj8
	RMqNQoLW1fygAWTRr4ScqFxEGP+Gk9k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768263806; a=rsa-sha256;
	cv=none;
	b=QzXGdruViMOhtoBXwEfB6OWCRzpgMiswKFLTwuC02MLM5A8MLv2wkdQvvFEHQiTW0Og2Kf
	3OjlM2u82aKjXefq63fIrDYqMIb3frZ+fP1h2LIyZVmHAjyja9aCOHoYlcU5a9Gpg4IsMZ
	Yf7PgUBKjo2Ir60SDgbARNZvIZ4rgBs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="BFyTCu9/";
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Mon, 12 Jan 2026 16:23:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768263804;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JniOifvm0Vzj6b4Lw5mELotZ+645Lbbt+efHkzvLxps=;
	b=BFyTCu9/dziGMM32LOcrDBcuPgHKuuM2p77Bv8VDrwgAr5KvXtq38cnD8LDJEVosDVorfh
	Vbsk8Q6kpRoB+W/58rQAFCJCv7jLhu0chTkZgu6+y7ohVODlQHHU5TSDvNHbabijAFR7VN
	D9ah+6bw5qFnYvsFBDmL/twdwTiCcZo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: optimize stat output for 11% sys time reduce
Message-ID: <uvmqfu2ms7itmfl2bk47yxtbafccscc2hlsw56uq2qy3q6fri3@sl56sf33fvyj>
References: <CAJxJ_jioPFeTL3og-5qO+Xu4UE7ohcGUSQuodNSfYuX32Xj=EQ@mail.gmail.com>
 <20260110042249.31960-1-jianyuew@nvidia.com>
 <20260110153342.7e689e794ce43a0a39c699fc@linux-foundation.org>
 <7210e5e0-2a93-4d3b-a564-85c0fe117ef5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7210e5e0-2a93-4d3b-a564-85c0fe117ef5@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3175240005
X-Rspam-User: 
X-Stat-Signature: 5hzbz6bn56xe31bbddfri9fdc8jskdjz
X-HE-Tag: 1768263805-460150
X-HE-Meta: U2FsdGVkX1+AcQFQWnqig8lDNbzvemDKatnEhwTA11HTD6nmQyucIinyfOIZAGNru+EGyWBAm2osif6Y3vvQ8K9+79MhIZrXQuKnGt/LD7pcqJNYU+ewNBhMeHli3BJ42/sVLDJEFhlILegWvUAhNJytX/7JTc/s+hsVQaLhinc4Bkdcc3OVury81PrrEotS0cJPZOO45oHGl+84pHgjbSR1XN8IJ8HeZU2ZOaWGIDBYHv9dQRrcdzAc+VOIGyK0UyUD68/Y4K2SD48IeaZ/DavfLiEkysaH+Oo3jpoCZqtcYV/E2lVfKc/zqruotETz+p6IdAkGXTlZ8Bz/M7oycRD211dqZ8FxQJmqmy1T1zh1FsSzGuUSBaNzZJyUl1pSD5i+apppbHgU3x7eaLGVmUv2pFBMpF2azDSuQXOvL8WuXtcL/0PENiVhAyWwIEJx+iOwjvn8WJI66tK2vgQYO1umgLZG/lYLunLQM1fmhW4F4OZSR4lh6ANYkCd2klXcjPjhKyOo47riE+qVQwnFPKibQ3d6CCjTICbRKJdYD4A13PoGEQ1aG9DAewcVnUTiqanxCZGYgKojPl1+rAOBpWtnXEUNjXLkpxu/XvYOaVGCH90ZOWS6Z6AcuXc1FU1ERANgOX372VtjcVwbbGJZWpP7eyznXJs5414WhZzGElTYI2hfOacJLpxRgCec6otygxXWaMbTabznn1PdmJVUqspnOVv9QRyr4IGwJZnTxl2RXUzS53s4MRNm+8vFsssdTR+IPBkApsRJ+zadeFGqsW93QB9IDjKlMEyEyZmsPoELLzxLtdzXmUx0VW/aqbYXNSu+L244aGri4K3TGLPqIVRyTHoSCzQ7kxOhFwcFvfg7/MTSMTRqiTSEgwO0lrb44UJ+d9nHmHi9hQUVTu7Qn6B5b++x1MJLQIr5FSfQEUaKyTcmhy734aN9rY48FVJPiFhl/Fo9vHgGSbInet2
 aH+7Vk+f
 kkGLi9kSfspnCj7VnNbRi3w04pljLkuv9fkNVmORc08kW00qJb9wJzT0qprgJfZKLxRs2nEu4SKib8r8FprTADMq0gp1cqJK3UxkT0Feo3LCkD/6+YEweKpIROltlzqz+HYXBKAtLxuGcFOEdaHEhktTizhwrCGRJhUa5/enRuMfNxBVEwRRw8WKcoNI21WoiqUEx854b56dfGk3tC781zKuDQw8W/LFl3CYCtdZHDP3CtGIo49E4foD7gX7lfj5ZbAITE8c1VLusCBYX7YfFofmwfQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 11, 2026 at 12:37:45PM +0800, Jianyue Wu wrote:
> On 1/11/2026 7:33 AM, Andrew Morton wrote:
> > On Sat, 10 Jan 2026 12:22:49 +0800 Jianyue Wu <wujianyue000@gmail.com> wrote:
> > 
> > > Replace seq_printf/seq_buf_printf with lightweight helpers to avoid
> > > printf parsing in memcg stats output.
> > > 
> > I don't understand - your previous email led me to believe that the new
> > BPF interface can be used to address this issue?
> 
> Yes, previously I think can directly use BPF interface to speedup. Later I
> think maybe this is still needed, as some platform didn't have BPF installed
> might still use these sysfs files.
> 

It seems like this patch adds measurable improvement for the traditional
stat readers. The high performance ones can be switched to the bpf based
interface. So, I see no harm in taking this patch in.

