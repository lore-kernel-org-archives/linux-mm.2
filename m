Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 156F8606A321
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 17:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n0Gp7Ow7
Received: by kanga.kvack.org (Postfix)
	id 091936B05BB; Mon,  9 Nov 2026 12:38:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 042426B05BE; Mon,  9 Nov 2026 12:38:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9C3F6B05BF; Mon,  9 Nov 2026 12:38:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C6B4D6B05BB
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:38:45 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C4334C0769
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 17:38:44 +0000 (UTC)
X-FDA: 85416290568.02.6712775
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 178F718000A
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 17:38:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n0Gp7Ow7;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794245923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fIq1yBbkJ0IjLGAwck60PVaprKRhgS6KxypR6a7tnwY=;
	b=y1tZ9i/ahADNY0Yc4l8FmGqnrkit0dazUE+nqZMcC1wZPRkDhAaOek/WfngOdWWI6PLsZK
	Ct3TwVzyJOOZbgtBadfHjXgQR2ymh87jgA4MKPTelhldizQTV+fpmIrP5bVkcyxP+Wb1FG
	T6Ao53rmAIa81JEOtsji4K2RP83DPTE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n0Gp7Ow7;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794245923;
	b=SUNWakbut4yZMIvbjQkzwhx8SsfcV9NxIQTivh5mbXThGEeDeiwlpEvvfBdG9I6z+rT9gA
	PVeLqJJ9gHFCDBB+gcdC7mlJ4oyyOpZyhmE+5BT6YlhDlweGb20Xpq+XgFbpczd+1XFPCo
	u0gp5LYdgP6wFiG/j3LvabkwMgDyP8c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9EBB741226;
	Mon,  9 Nov 2026 17:38:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432901F0089F;
	Mon,  9 Nov 2026 17:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794245921;
	bh=fIq1yBbkJ0IjLGAwck60PVaprKRhgS6KxypR6a7tnwY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=n0Gp7Ow76OLDPSgQLVPcIwpqZ6AClm2QgIyo6m0ebQ6g7BkTy3jkcTCb99W6UUAC/
	 KtSnzr3HXk1yvCYNCXc/ijwcT/pZ0cHlTW6neQh16mLNnVctpFXgJKCfn+upzUD7BP
	 br4blmMSg+20Zey4ctldNelEaTJQFGDNp0siszpN1QZ+VvJzO5q7y7tdS7aBX3T+Af
	 1nnmcS5MFFc+XuJH1S70ZK+xuF0NUSYg52cXZ3AIuEo/vU5nNNS7Mmg9xYrDEzolVa
	 /ycDuJT3w5+e8A4eVE+iUJrBwgOQWk0M5TBXHXCjO4wsT9XFwwGFP9Gjwh+d/rdag2
	 99L2jc+FunUVQ==
Date: Mon, 9 Nov 2026 17:38:33 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: sashiko-bot@kernel.org, Johannes Weiner <hannes@cmpxchg.org>, 
	Gregory Price <gourry@gourry.net>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, kernel-team@meta.com
Subject: Re: [PATCH 2/2] mm/page_alloc: only skip kswapd nodes below their
 kswapd watermark
Message-ID: <avIFBnXPB2DLLjr6@gremlin>
References: <sashiko-outbox-203103@kernel.org>
 <20261109172742.774437-1-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261109172742.774437-1-joshua.hahnjy@gmail.com>
X-Stat-Signature: ks9pjp9w4sacrdaq8iiypqbyuera9gww
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 178F718000A
X-HE-Tag: 1794245922-204540
X-HE-Meta: U2FsdGVkX18x38/FMp2Ru02CWHnN1BbAA8ibZFa0FUBmHYC+Y25SBZzW5ggggBg9Ej6T29gxiZRMJAGmTWmR7tA169X7lXiaFuksNsoTjQ8/SiIVWFIs9Fz+imR6oG1adET8ZnbQUWl+AGWXA75M4RP44u4eYD5vX2FYflcfdBHfikPaFtyw13PZ9J1x5uCUnxKxAVFmv6rXEI797MTuIUmbYWzP8Jpa7n0vmOsSRCyKyaA2QObjSWCYzD6hvMzrIQIPWNWdM0l+WbTNjJ0FvzqC2OnZ6yNVj0DXwzdI9R2FDsa+aqlkzS4j48BUi/NRORnkVXawIiBaTKANbUP56I2gcIcffI3YsUIu824GzoIG3niFPhjNC0ZsAHXUd19uMcmyr4bX120bWrzMt8bQduSAaYr4m+5qcx0nm9Zu9tm/bGDyxO6EjWyU7j7UI1ZgmUf/ZVFA98/xJZtIZN9zZyXrMphQSJEufuaoJz5eKr4MTDQ9prJ7tmNP/1G3N/IcYJyVIG72RkEwO5IvQKWW9Q5Q3dC+DkwNNO5SnHU0a/GcSUvw8KyKfc3Gwgn0/Wr9tijmyHG7nuK1ZTMuC+SMvlKAtC8JVa+yFFWs/lPI3idNnT2TcEDCirFMF1AvYf6nd3W7vp3aN7OohE+UwE8HU4j3H+xIRiKLKT53bpe78kdiIEV+QoYPJHOoDj2AZVLMeP4ZQtlPnHnmKwHBWutLvuz/nCP2APbhXtbLcJhwkbW8x24ALO5H/HLfEzDJXxPasLbh0GiI6lyA1ZbQNiXQowPDjsCKZ0dI9yw5/wRhfSgHpxPFIWSADu5WcYMwDiUcz9YbthWV/AnWABQuELMTiDK+mgFg95q+I62TKpCX7I4jcHXv6q6nO2oZQKDrF/J+RuZCoTbncG4Ea4Z9F33OGyYWEn7n/YImFIrgodtMUO0yDf/SsSeNb1KXBhs8PAx99nYpkz++tgg+l1EnvPg
 FLiGjPQw
 7uo0ZDlpDVTXyPWcDGnuyqYK8RK3KmBNUqickuZT/4w7N8KHqQX6X1mxTuglTzXK3RO8eWI2anWbUYe4xp6evvNXeoc2VqPRNEFG+n1roA3awLvjJ72KTrbpAln8DGypvtmvTYqaQ+9hMxIAn6uVZNHntTgI//e4C11JJcvYOHhl0HjLV+go5JFeocV5IKSneuFyCtGVINXml4HKmGGmZQibwBUTGNDHnU2SRjo5srTPYkE3G+340pSFMmb+ieX/604+zkgYvtUnz99DSXFlNDcRJ7nqZAXoeQYTMuVmjjPE8EbZBgiE4+4acZfdBQUGKkQKWr0H+CI/4orM/PYXtUcUPHd2IoXPNE6hmm3AVtXxCU7GkHZXMJqCGcQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 09, 2026 at 09:27:36AM -0800, Joshua Hahn wrote:
> So initially I did not think this patch did not deserve a Fixes tag
> since it doesn't really fix a correctness issue, it's just adjusting
> a heuristic thatthe page allocator uses.
>
> But thinking about it over the weekend I think this might be worthy of
> a Fixes tag and a CC: stable since it just completely strands memory
> left unused on one NUMA node, which is an unintended consequence of the
> original fix that was proposed.
>
> Lorenzo, if it is OK with you I will opt to send this as a standalone
> fix, and then send the other fixes as a follow-up to make it look
> cleaner (like hoisting this check out into its own helper, and the other
> neighboring cleanups that I found). That way I won't have the cleanup
> patches blocking the fix from getting merged and it will be easier to
> backport in the future.

Ack, sounds reasonable!

>
> Thanks, Sashiko!

:)

--
Cheers, Lorenzo

