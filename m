Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A2B3FED2F9
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 09:42:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 746BF6B0089; Thu, 12 Mar 2026 05:42:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F4006B008A; Thu, 12 Mar 2026 05:42:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 600556B008C; Thu, 12 Mar 2026 05:42:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 500BF6B0089
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 05:42:22 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E301713BEE3
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 09:42:21 +0000 (UTC)
X-FDA: 84536920482.13.A87E060
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1D6F2160006
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 09:42:18 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=P+3yJ7HR;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf08.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773308540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yPWlaauP5LfYdgi3W21fsz1vO9uleriWqeR2AsRR+/U=;
	b=wVwzLG84SENLFcTboZ57oCF8Z/+O1kqUENJGnVmpNispEONlX5QhBS3Gc1V7xEbZYZ3R3A
	RBWOktR+BVfaR4VvEMQIh4D9I3ykg2vwD0ziop/7fPTfT0KGpxWPFdCnAIzIPEAN6C/O70
	d+6irpjaYPDDAbtAOe3oMmGJrCpVssw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773308540; a=rsa-sha256;
	cv=none;
	b=7XknNzmfp7750nnCcthUr+TFH7NC7lY7jcMNsfw3VnAaD53peGtAMtbCfNyW5hFuK+W0oj
	92Tb0UO+wdfiziXswLiOTYzXuuy25mJXGdiT8oIGkVB+XYyVID1YAWAUbB04ZTjNQTPk2B
	3cU/dwGpzdn82biQbOoFtUwMqOLfGG8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=P+3yJ7HR;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf08.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773308536; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=yPWlaauP5LfYdgi3W21fsz1vO9uleriWqeR2AsRR+/U=;
	b=P+3yJ7HRh40TTgrujeIVXKAEcLtUWYPfPD18/9sAffDwOBaX5XN3e2DiubLB4ldxHamxB79r4/aLMRtWruNV0u08zhlcMpMJYTcAnnkCp6HpMybjY24C0XNbeaAdgcjoJqi6K9zuyk46ouv8M6MLj+x7r7iMJJpDME5OvSQXcls=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X-oES69_1773308534;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X-oES69_1773308534 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 12 Mar 2026 17:42:15 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: YeeLi <seven.yi.lee@gmail.com>
Cc: akpm@linux-foundation.org,  david@kernel.org,  dan.j.williams@intel.com,
  linux-mm@kvack.org,  joshua.hahnjy@gmail.com,
  linux-kernel@vger.kernel.org,  Jonathan.Cameron@huawei.com,
  linux-cxl@vger.kernel.org,  dave.jiang@intel.com
Subject: Re: [PATCH] mm/mempolicy: add sysfs interface to override NUMA node
 bandwidth
In-Reply-To: <20260312091207.2016518-1-seven.yi.lee@gmail.com> (YeeLi's
	message of "Thu, 12 Mar 2026 17:12:07 +0800")
References: <20260312091207.2016518-1-seven.yi.lee@gmail.com>
Date: Thu, 12 Mar 2026 17:42:13 +0800
Message-ID: <878qbxpeoa.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1D6F2160006
X-Stat-Signature: z56f3utxyqm8r8aqahgrauwznbdcskfw
X-Rspam-User: 
X-HE-Tag: 1773308538-286316
X-HE-Meta: U2FsdGVkX1++bxpkMD5oT4PqYGunS5lGEZ9lns8O4JBi8GwiNIEdhkk16hG58ngLvWfUHopqbbxVZKQ1tyHyQvhRoFmH5Y2C8AQkS8xXDKSG3WgJHhPfh0VqNEII/vd8anAnFxi+l5FrtAutNuNfQuZZDmJLWpkwhmEwzSvhGH++mN7VJEexQ+I1BVXxonwlQ1lbCozyMATmRtgjQliDYPZUug3V23bREcpewiuYBzAlUCsyEuv8TGFztj1YyuXgIw7ZE5mDDHbCxsh6pLJ8MM76oIVM4suCUin+KSDLubKygxJEJUpv+rCXIsXoUsMmgzMoJlebD3jr/3NsapJ8le+B/l6hc2YpfLg8hRpAF5/lsmc7V15J3BK2mmE0EOOzy746qkLj1W0O9yZwlvcxl1CMdESxglpApZ6KDQf9bcbpjfxdsmQCHJQPguL/Q67d563qA7dZ1OjNi/zgLWdiq9h+RSF6iCzqWhg14rxgjZkyiStYEjUBGALSkxVFIOwbdVOdBW9VVC+GZ+1tzB1M7ooydlljbGjkY7qBwV9dozBN1smf94RZhNX/DvrAl1DyK/SD3rfHuNX+jcqiCAhponey0UZ7brdC1u9lSgW+wfo+hoRx69NL1pt2zZANnLEU4sJGbq8WuKNgRM3vhQAhnEsZ0nGKYVUVukjQOItSNCZsKm/uudrrJuByvbDsOUaU53oJMsI5fVfEOq+g1cej4maXTXQ/6lOnLCdiHm84R2bA8jIx/YN7+3h6LWtDRpqoZvmvdwWnKO2NXxHhPSyLbgjOUmoCskL9HCVIz/Y6JL5ekve1bTlUPSC76FyTuDzBJH3fZ4WMD7xozCuBZ4v38u+3osBztvnB3HWsK2eURkUS5JQvVCjk5kdc0dF//ApY3+JJJbmvsrkwk2exEFrSZgCrhXgx78aiLD58GBZh17Uy7q2+evvfQzCZankeB1FoJX2KLsZJGc37N7yqPv5
 6P1brPfR
 mgWBPBaktKQBIGpjoiUgA9b1XjUqZAZXj1hIGQqmM+aDWaVwi74Qgfg+VS0e22bdE23GzDBciW+86cDjo/EyLoLqDc2K7PhsevbSjpfR5pyhqFXTQrjcVd4YtguIzB06PcFq2pL2wdcAmnWuusjumqxnf2eFGN0LPcVt3hGTunr2jOa7juzG6K1HsGp5QCRTdcvVovg1eygaXJiGw9AzIu7FNN9kO4Q4zWibM1Y8JsOePToZDTVDHe/4026BKU6G8fjUDPuYUeh95TDp8cUJ/waP5uXna2SginIPTfK6fv4HfuwqCPRM1sSRoS4amKuF2mzFMBxWMRKO8gJvsyRnWzjlWHoiqIb7S2nN5aA+gEJGPLnT4ZcTC/402iDpOT0AFQsoo2o2MxQ9LDFXBpL+V9vq3AqvnjrEBDxdb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

YeeLi <seven.yi.lee@gmail.com> writes:

> From: yeeli <seven.yi.lee@gmail.com>
>
> Automatic tuning for weighted interleaving [1] provides real benefits on
> systems with CXL support. However, platforms that lack HMAT or CDAT
> information cannot make use of this feature.
>
> If the bandwidth reported by firmware or the device deviates from the
> actual measured bandwidth, administrators also lack a clear way to adjust
> the per-node weight values.
>
> This patch introduces an optional Kconfig option,
> CONFIG_NUMA_BW_MANUAL_OVERRIDE (default n), which exposes node bandwidth
> R/W sysfs attributes under:
>
>   /sys/kernel/mm/mempolicy/weighted_interleave/bw_nodeN
>
> The sysfs files are created and removed dynamically on node hotplug
> events, in sync with the existing weighted_interleave/nodeN attributes.
>
> Userspace can write a single bandwidth value (in MB/s) to override both
> read_bandwidth and write_bandwidth for the corresponding NUMA node. The
> value is then propagated to the internal node_bw_table via
> mempolicy_set_node_perf().
>
> This interface is intended for debugging and experimentation only.

How to use this new interface?  Can you provide an example?

---
Best Regards,
Huang, Ying

> [1] Link:
> https://lkml.kernel.org/r/20250505182328.4148265-1-joshua.hahnjy@gmail.com
>

[snip]

