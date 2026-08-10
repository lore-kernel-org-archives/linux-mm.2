Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12C4FC5AC82
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 03:39:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0346F6B008A; Sun,  9 Aug 2026 23:38:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F000A6B008C; Sun,  9 Aug 2026 23:38:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEF026B0092; Sun,  9 Aug 2026 23:38:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B2A686B008A
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 23:38:58 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 45C5B16065E
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 03:38:58 +0000 (UTC)
X-FDA: 85083953556.26.A54B9B9
Received: from va-2-115.ptr.blmpb.com (va-2-115.ptr.blmpb.com [209.127.231.115])
	by imf19.hostedemail.com (Postfix) with ESMTP id 101181A0002
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 03:38:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=f+qCUT7F;
	spf=pass (imf19.hostedemail.com: domain of linyongting@bytedance.com designates 209.127.231.115 as permitted sender) smtp.mailfrom=linyongting@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786333136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=korNoNZfAXzZjyOdMvauYaWtvPC4odCOcA6M74LpPBw=;
	b=Fu1oTUkqUEQhP7Zw4InkHsV9FGuA8sEoqksp1AMafgqMMFquBMfTgWRnJ8UlEVZUVesZkT
	7Yfp2VEyZElFGmhDMkVmi0u8zqKAFQ1GnTip4d73RzmuJ5rQWA4pdAkcabeYLIt03iFknU
	o3UhtYb4M0Mc3bi0273QwLPxWTk7qjA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=f+qCUT7F;
	spf=pass (imf19.hostedemail.com: domain of linyongting@bytedance.com designates 209.127.231.115 as permitted sender) smtp.mailfrom=linyongting@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786333136;
	b=WK6/utnOEPwSgvjB/F5aWjy/Cp1VPknNebsj+iYJ03VWePlNsHqeq84m0lxw9aXCbK1GAH
	UhEpy4otnXJkVnRGUZf4XQtkVkY7DHXATTvpRG91gSsRBq52GBacAlZIcyz9++Lr2JOyAn
	auRPv05gXQCIPZ8kFY1Q5yAv1+o2LMs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1786333130; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=korNoNZfAXzZjyOdMvauYaWtvPC4odCOcA6M74LpPBw=;
 b=f+qCUT7FHFxHtG8joA+8HtCL3q+o2LmvekGvQd6dtZTHm9XV5UMSCLjQDnRQ00FiedN8dw
 g2l3dxgudkZFwfqVMH8Z70eLd4GK/BTA3zYnWT8z0LhdZdaCx+PTxIb0ha52r5+mlIEZbN
 oiokQNv88Lla2jc+f6Tu9GVEj4ihKefJkoB7NRtPf/ot8Dmi4jetKVpZI/rCFOno4KTk7d
 01FfhSfyFN6pO5w2/56c1Ge0945XlXUOERtje0YgLb+4wTEA2Qeb/gKzQgA0vVZgE/hhtq
 n1d38a7Q9CT8wukSz0uN5FgH0MYoBWocb/sW+3fTLgeBGx9UUMP5YvXmG81BBg==
Cc: <Jonathan.Cameron@huawei.com>, <akpm@linux-foundation.org>, 
	<alok.rathore@samsung.com>, <balbirs@nvidia.com>, <bharata@amd.com>, 
	<byungchul@sk.com>, <dave.hansen@intel.com>, <dave@stgolabs.net>, 
	<david@kernel.org>, <donettom@linux.ibm.com>, <gourry@gourry.net>, 
	<joshua.hahnjy@gmail.com>, <kinseyho@google.com>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<mgorman@techsingularity.net>, <mingo@redhat.com>, <nifan.cxl@gmail.com>, 
	<peterz@infradead.org>, <raghavendra.kt@amd.com>, <riel@surriel.com>, 
	<rientjes@google.com>, <shivankg@amd.com>, <sj@kernel.org>, 
	<weixugc@google.com>, <xuezhengchu@huawei.com>, <yiannis@zptcorp.com>, 
	<ying.huang@linux.alibaba.com>, <yuanchu@google.com>, <ziy@nvidia.com>
From: "Yongting Lin" <linyongting@bytedance.com>
Date: Mon, 10 Aug 2026 11:38:14 +0800
X-Lms-Return-Path: <lba+26a7947c8+8188ca+kvack.org+linyongting@bytedance.com>
In-Reply-To: <amjz7kIDuZH6gBx9@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [PATCH v8 0/8] mm: Hot page tracking and promotion infrastructure
Message-Id: <20260810033814.83951-1-linyongting@bytedance.com>
Mime-Version: 1.0
X-Original-From: Yongting Lin <linyongting@bytedance.com>
X-Mailer: git-send-email 2.50.1
References: <amjz7kIDuZH6gBx9@casper.infradead.org>
To: <willy@infradead.org>
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 101181A0002
X-Stat-Signature: ienn5et58qdjxauakimksiw94qzi9kkf
X-HE-Tag: 1786333135-337443
X-HE-Meta: U2FsdGVkX1/TDLlME5Sax2sTz6AdZF5kmlW8EiPlbUONF0dTGdAvQ7QRo3UIhPewFMs6xEpKCegqkq0hc2olR6TXDbiInMq00u2c+HVW5uuP9ShROw7qJJzGADuvaNGXXTaaXNIYHIIYb7L68B2NxTXjoTND1dkHO+5eeVyBvkngpqR/oW67kMN+Jwv4h6myzxAtCnlBVG85gu7PpzflzZkGZvR2rehfwq/oN4NjVugoOxsZHvxqhuH1bKLA7/3w38SPF7RULSZU+d1aD8VyVQ8C9ZGRm5PRcwppyDBwQbsWrS81bQB98ZNy2qmWS941xxrr5EKYdeGyOj8fPTteq/ZxWZZ3eGLYHuDVGrqOMiABiJ5OYTxaQEPxUMVVoWB/aXmS+1fiU0NGylHvsijlaSInNsHv4toGge+u7QNI0g8X6e8x/hMJCGzZkhgL4hLYk/jDFLReIwI58MGB84GaMs7/3aPYB+cn/8bxq5KZAs9hxMY06xoxKzb1KpYUcbuXCI/z/PV8pvwBXEykPNdlxWPtixwzOj6BUs0QfxDv2yIK50wRzG1wffyx6Xyi9yzJXer/dG0MkD83JG5X0/JaAnbydgr4FAlnCu2W91DRJG1v6dTwVGBn7zVy6LOXHsP9MNou6AcUFQYeJZgjZlXj/R3RLzsoVSnzN9yabwGHGKxVXD+wdKvhHGODF8VWwxw7usjLx/M+PwaLLJfg1FopwuTX5lQK/zLoftJVzFMm81md7Gsw4tHrfQoCeoQBpX5s//ulgyFH5rMnDmvbtb55qQtadNFbKxZ9KLx2m5mQZ5DslOmSliMMkNAkeQyW5iY52z2uZ3DXjyPEva7eEXnMVvcKs6DHVJnb9xqvv12+9UF397mUIXJ5I6w/QtsgMdrSHwgSaiTyQQqCwvAQQGMvhEJKARw6mTpzKRpgZ06Q0YgWsOXThdBhQlmnt6QPLIrmlpCC++1h+YCnh+3nww7
 /1HdhHjQ
 dEdx5Ab28rXQUFiYDXFJlB+gBhRD0M6oYdxdXTSeDYEalkQYGLAihnV20C2a5mJV+uibkG/GXU2VbSLK9yPCtbNQ+Ne0+SHGy1t35b9YsXysauN8wO2DeN9tF20f9MLMjtGVybJJowm8+fDOwB6PUhBv5m65fTScDnK35NppBK1Nl4ZxRl46wgn93kK+y+YbpDJWjX+TpwnYByRiBBCLr8LVlO2N77OtIjbIXBAZ1TARRKNGk5CeyF0ceLo/kWLAfyCPD1zpwyAVwL4wtiyrKbosFXbLUP+7nSvwgathMOAJjdKMN8HjqTBr3/Pv8QQCJLoC/5m0iobRzooTPVUfpBxxQ6yozn7MQBs1sO3RqzGsdh5hlUUeXUBG3hw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 07:24:46PM +0100, Matthew Wilcox wrote:
> On Tue, Jul 28, 2026 at 11:14:01AM -0700, Andrew Morton wrote:
> > On Tue, 28 Jul 2026 11:13:48 +0530 Bharata B Rao <bharata@amd.com> wrote:
> > 
> > > This patchset introduces pghot, a subsystem for hot page tracking and
> > > promotion.
> > 
> > Can DAMON be used to do this sort of thing adequately?
> > 
> > Thanks, I'll await review input on this.
> 
> I don't think we should do this.  I don't think it's a use-case that
> customers actually want; I think it's something CPU vendors think their
> customers want.  I've said this repeatedly over the months this patchset
> has been in development.  I say no.
>

From our perspective, this is not merely a hypothetical use case. We
are actively developing and evaluating CXL tiered-memory systems, and
expect promoting CXL-resident pages that become hot back to DRAM to be
a practical requirement.

NUMA balancing mode 2 already provides such a promotion path. What we
are looking for is a better hot-page detection mechanism than NUMA hint
faults. AMD IBS is an interesting option, but the v8 results do not yet
show a clear performance advantage over hint faults.

IBS is not the only possible hardware source. CXL 3.2 defines CHMU for
device-side hotness monitoring, and CHMU has also been discussed in the
DAMON and CXL hotness-monitoring discussions.

CHMU does not normally provide the CPU NUMA node that generated an
access, which complicates target-node selection on multi-socket systems.
However, single-socket systems are also common across data-center CPU
generations. On such systems, the missing requester NUMA node is much
less of a limitation.

This suggests that a configurable framework capable of consuming
different hotness sources, depending on the platform topology and
available hardware, would be useful.

We would also be interested in helping test and compare the different
approaches as implementations become available.

Thanks,
Yongting Lin

