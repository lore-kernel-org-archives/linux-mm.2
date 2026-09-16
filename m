Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C0E9C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 11:14:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91E9E6B0088; Wed, 16 Sep 2026 07:14:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CFCA6B008C; Wed, 16 Sep 2026 07:14:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E5826B0092; Wed, 16 Sep 2026 07:14:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 64B746B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 07:14:27 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CD8E3A5D98
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:14:26 +0000 (UTC)
X-FDA: 85219366932.19.3C27C49
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3F8EA4000C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:14:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ICBk4m4r;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf12.hostedemail.com: domain of xiangzao@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=xiangzao@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789557264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ErpIMsnziAOCfbktdoYdQ0qID5bjRfutEUyuO+0PJYw=;
	b=eD01vR/YR6oIvey22lLzXQC6NYIlcFcOTTO5dZmoMkDeLx2DxCSdmyeue2pyYpzYFriGra
	Y3JC+pr/u2TzmpRBsmXnQxDLMvAZMDDrS3gMvKn+fMCeidh7ntfqw62ERFl1OvQnkNjZHV
	CCs/2P8nPouqVT6m9mAbkAi/OUM1vRk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789557264;
	b=ksFVnT2m6N1XzmIuLnbhBeJ9s5DOz9+eAjRuoWHQMqIfEagcR+Mdk0/24MvaNi/uvGqfyH
	opYlVME+Y0Ln6xGWT+Af6M+4dDEbN0F1LzDqEihnanXjwkYxt0ZQhjpN7wBwBCykGT80SS
	+ipVKfsLE2PZp0jkbdnW4EhGCE/YDSQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ICBk4m4r;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf12.hostedemail.com: domain of xiangzao@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=xiangzao@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789557260; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=ErpIMsnziAOCfbktdoYdQ0qID5bjRfutEUyuO+0PJYw=;
	b=ICBk4m4rmZOx4soLkdeDO0pn/beBru341f7cy14eM6LwkIywCFrU0XZP+os+3IccMmK1dbYHNZasAU6VP/JMR+muKGgx+FkJXlmNwHGgzwOokB3ZOR/tjqy5c9XetL04QFsUYu9oG4/9SDAa3xawiVVIiaemCbTOfXTdMfWmlN4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=xiangzao@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XB4kUmw_1789557248;
Received: from banye.tbsite.net(mailfrom:xiangzao@linux.alibaba.com fp:SMTPD_---0XB4kUmw_1789557248 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 16 Sep 2026 19:14:18 +0800
From: Yuanhe Shu <xiangzao@linux.alibaba.com>
To: vbabka@kernel.org
Cc: akpm@linux-foundation.org,
	mgorman@techsingularity.net,
	linux-mm@kvack.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	henry.willard@oracle.com,
	david@kernel.org,
	Yuanhe Shu <xiangzao@linux.alibaba.com>
Subject: Re: [PATCH] mm/page_alloc: do not boost watermarks in kdump capture kernels
Date: Wed, 16 Sep 2026 19:14:05 +0800
Message-ID: <20260916111405.3687662-1-xiangzao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <1a859476-36de-49a9-872f-a62f6eacb7f4@kernel.org>
References: <20260914131142.2984623-1-xiangzao@linux.alibaba.com> <1a859476-36de-49a9-872f-a62f6eacb7f4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3F8EA4000C
X-Stat-Signature: tg8z87c11z6tcx65aa8aje4r8e15irgo
X-HE-Tag: 1789557262-623074
X-HE-Meta: U2FsdGVkX18LGTEL1gnvUcXu4u5c9YHdZkI/eEoP2DPf0yHLqZRujV+SHQQoddF2NvcJm0sOcB6+4nsFxsNRkq0CW1GceVycsgmLntRtgQ2Wm0cQQTwX8y0Q4wYsgVSoGI9EPmTrBwo7rxMFdD1ixkt25CsRnCZ73KROJgLXZKmq+pbbt5gOGs0Ah9GCdLUoDUYqqxHmdId3lc5PAQ/LoOwWv5DKIYdI4RfYsdkytFdshL78fyx19YgzpnDFdzTt0YE3Ugdca+zO5E62isSzWMwemzkLymW0XeF0RzzziMfkQcRA4qSb/VAg+3nb4tyYbtcsF50CpC0CxqmynxrEMiqK+sjiUFmm4Amukm3o/BKfksehn7Mob6ewLyrI6osbJZzb9ZkbIxCmcCcK7R7z6h9yfIMginUHDE/vZiD3hpz2qr03+Q/dlbw3JMAUIqECJYmAxu4CLMq10cf3kpzKYyopZS7pLqauLSKvPk+GzJFdPqUc4YYFAHK67mEWpaAqwkN0cSZhSAlGAaEnwCus/AIxpOULF9VxfEU1KCWQ4FZ+kSgNG0p6cYTTGBHQ9EEqeidBVYuF1qPy5gHQphOLGlD/JfhFBYYFul0Krs/EHmUE07xNTUVb8gAS0JFTEaPO/JGhKPiqgH5uexQ3WFtaOwtOmVUlCy5rGnd977wnh7iPV9Q19x0PSZ3U1MzCSos8S4ELBjqwXhEf3JL4GJs39/BWKsN5f486J8Z5NF/sOWUoHXoLvT4jOBDBPxqqF/NBavXrhjfA5Q4lKpnZMytOiwlv54/Ztxs2kpWZ33HgmhWVv/5Oxej6uGE/WcT1R4cc661QSkmfjXkyJkR4Qt213I2tisKmZgGGfzMEX07cMNWrCfB2AP2ZAa9l/GSsBsIg2Qr15LnbUcO7uqdV68jd4EY3LFz7MtfpRskzPBMAGcN+LAjmvOQMd/Whh6IqblymbMffxfEEWSMGqbe5gV9
 jtAaaQCz
 BdP0YZIqkzKrEgi+t+VMPfBXu06bXsHL10+0Cdvu9mu/vVeU+SF0izO9FMsAlkqKwtVF8pebKUM6lrK32N2Vyl1bgCeS3scWcS973LEXpMl8pjqdyu4EVqyXvW6eiEGKA9qEI2w93U+M87b5JBVu65SuLCGQ8Evy+dgLFmgXvqE1mVvYURDLZsnD4xBCjVvumafRGtD1FogUF9yKjQUwPcb7voOn+foJ/H7JgFqpDopSP3xI0ks3ThPt+NmiEICbokTL+ypjy/oRdTYUj8hS3tT9k1FjIe3bI+SuDUzw+9P1iuQI8bkwftF32MIJYC7u1wK4k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/15/26 14:02, Vlastimil Babka wrote:
> Sounds like an oversight and we should deboost watermarks first before going
> for an oom kill? But I guess at the same time not boosting in the first
> place in kdump capture kernels makes sense and it's simpler to do.

Agreed. Deboosting before the OOM kill does look like a separate fix
worth doing, but it would change the OOM path for normal kernels too, so
this patch stays limited to the capture kernel.

> Hm while the large pageblocks on 64kb kernels are source of various
> surprises, this at least seems consistent to me. The check together with the
> clamp means we limit the boost to 1/4 of the zone regardless of pageblock
> size, right?

Yes: the check gives pageblock_nr_pages <= zone_managed_pages/4, and with
the large pageblocks here the clamp caps a single boost at one pageblock,
so watermark_boost <= pageblock_nr_pages <= zone_managed_pages/4.

> We should stop mentioning kdump capture kernels here then? They can't reach
> here anymore.

Right, capture kernels now return earlier, so the comment is stale.
I'll drop the kdump mention in a v2.

Thanks for looking at this.

Yuanhe

