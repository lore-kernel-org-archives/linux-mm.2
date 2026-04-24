Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CB56FDEE28
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 00:46:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DC836B0088; Thu, 23 Apr 2026 20:46:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48DA56B008A; Thu, 23 Apr 2026 20:46:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A3A16B008C; Thu, 23 Apr 2026 20:46:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 29D066B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 20:46:35 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 992531B93ED
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 00:46:34 +0000 (UTC)
X-FDA: 84691608708.03.CA7FA14
Received: from smtp186.sjtu.edu.cn (smtp186.sjtu.edu.cn [202.120.2.186])
	by imf11.hostedemail.com (Postfix) with ESMTP id 206774000A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 00:46:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=sjtu.edu.cn header.s=default header.b="KW/W8u26";
	dmarc=pass (policy=none) header.from=sjtu.edu.cn;
	spf=pass (imf11.hostedemail.com: domain of b.suvonov@sjtu.edu.cn designates 202.120.2.186 as permitted sender) smtp.mailfrom=b.suvonov@sjtu.edu.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776991592; a=rsa-sha256;
	cv=none;
	b=pxbJeqT2LfLNeBTM/PlnzB7YMEERQ5ZsZ5FCutKbd7VZ3YPXLHOneoY4amZKrJTrOqlLDm
	RN5uc0V4GZ6SfG4hRCPij9VUyoDtKDYhUHu6qvSriB18JFXnjRwbaSz1IDHavo4R+8dflR
	GA9PP6mdpCmGcPMl1R1nRgVoB5ziUbY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=sjtu.edu.cn header.s=default header.b="KW/W8u26";
	dmarc=pass (policy=none) header.from=sjtu.edu.cn;
	spf=pass (imf11.hostedemail.com: domain of b.suvonov@sjtu.edu.cn designates 202.120.2.186 as permitted sender) smtp.mailfrom=b.suvonov@sjtu.edu.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776991592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZAK8IKDSxXdMLemGAk9GOFPQLpA19ooZlS6+bZBkVxI=;
	b=GCC1tpikSeQ7WvqcH+OkByjcrzcx0DR+dez5T+vbUaRrQT6l1B7kBqjMpGoZFyIcb1j1Lx
	7rqn9EaoUURVM2a4YcxVEvxUI0RI+PJBtJhONC9kmzA5n74v1yiFZD2m6BqavL+4K95Vkn
	bD7E4k+98Po1E8DYVr7khzlRIMcnDIo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=sjtu.edu.cn;
	s=default; t=1776991586;
	bh=aIh3vuNWs698cufhEU48wc0UUTbQ+aQCfDyolphe4Y0=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=KW/W8u26MLjmPK5gqJxgNhzyt0nHC7gcQTPIxf79Cw7UKILQq0OzKqQCXb/R1tSLt
	 97L3wKrTRcshdrb6448Mh5amaJiI+O3KVQ5d++Hyb+vdpfybx5tJnuF2bHLKjbgkOu
	 kkDDAYR0nTUJCIN1D9WmF9HsPQV9lqjq7PgLxvbDGiymwoYpQW4lqudosjRlAFLrFC
	 xNwdWcQu41TAlF1/u+gQrhj7KAaQFubTISgAz1HvsUKzue+yP5mY31ki7FN5e9y8/L
	 jLHQ4BmdycEe69BzSLwJ2Wx0N9skmyYLd379ePo9Bgmr3AObEBIEUsPXsNJjYpUOXG
	 V1L7RhYaUnGOA==
Received: from mta91.sjtu.edu.cn (unknown [10.118.0.91])
	by smtp186.sjtu.edu.cn (Postfix) with ESMTPS id 102562FF455;
	Fri, 24 Apr 2026 00:46:26 +0000 (UTC)
Received: from mstore137.sjtu.edu.cn (unknown [10.118.0.137])
	by mta91.sjtu.edu.cn (Postfix) with ESMTP id A55EF37F802;
	Fri, 24 Apr 2026 08:46:25 +0800 (CST)
Date: Fri, 24 Apr 2026 08:46:24 +0800 (CST)
From: SUVONOV BUNYOD <b.suvonov@sjtu.edu.cn>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, rostedt@goodmis.org, 
	mhiramat@kernel.org, david@kernel.org, mhocko@kernel.org, 
	zhengqi arch <zhengqi.arch@bytedance.com>, ljs@kernel.org, 
	mathieu desnoyers <mathieu.desnoyers@efficios.com>, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Message-ID: <1868971658.1970916.1776991584726.JavaMail.zimbra@sjtu.edu.cn>
In-Reply-To: <aepavbLy7H3odp6p@linux.dev>
References: <20260423103753.546582-1-b.suvonov@sjtu.edu.cn> <aepavbLy7H3odp6p@linux.dev>
Subject: Re: [PATCH] mm/vmscan: add balance_pgdat begin/end tracepoints
MIME-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
X-Originating-IP: [116.230.222.59]
X-Mailer: Zimbra 10.0.18_GA_4835 (ZimbraWebClient - FF149 (Linux)/10.0.18_GA_4828)
Thread-Topic: mm/vmscan: add balance_pgdat begin/end tracepoints
Thread-Index: FmqamJoTP0RVjIuNzdboLtlnAuPAew==
X-Rspamd-Queue-Id: 206774000A
X-Rspamd-Server: rspam12
X-Stat-Signature: yiguru1jgc6xktfzcf8jxmomkg7t9jm6
X-Rspam-User: 
X-HE-Tag: 1776991590-982034
X-HE-Meta: U2FsdGVkX1/hJBAM2jgIQdfK5z/agGIERS1HMD6Rd0PV3SBkvHahJvhBsk4X3fJOlqpdjMPUjCgYzyWxu/rPXS9QB6JSwGTk+pfRtRhPt/IoTKChBmhAaZHD7zzKdKfEfjMrxW3S6wZqg8he/xGggHF+8fs+dfhNbubeNYGPL6h06KXm+9KqkHPmUVnbSxlruQpZWtb6bBImQv3GWcUCgPIrVCx7oKNUgETaTpH3+6oESPzqlGv5hom3ZknS7fYRowlSZmAtN7zhg7KGBryEbsnExkqKnpuvt6e8MoZXiP6h15qEXlAeKf5dOWFpdORRjcqxB56ya0M3IX6D0EZGSur4ute+1I46wgvb+olvQv2CIo6Mjq9mVtnKt6qSHk1XlPwxC+aDDg0gxI9EkE+4VqJoIgnJHupKbUESe4frpqMycSKsVZWbH+hqTAzipLq2iKIPsdZn6sXfYwD2SZZW8OpxemxFc5u34LmOo9egiFA6fZY7F7d8X133CL2YOOtrIGiYLrhPJ6j340qH/HXlG811B84MUBhfMOHzgmx+Si25wS632MbionbnhH28+0LIbw2iVrlo4k1fJ9EXqcc/+7z07d5Ojpt2sucLygLfOnTBBVbnkn77k1BlBB4Kzqk6FFYP3joD9ALu4h1szoQ52AcfeCsDf6J0dm4JR671clt/y54WafYOnitEiQmiaBTqRmQTIxVcyV3HDwpDZ83XIgyW1RV7BlhBbGBRaXDXwrpETj4aEoPJge/AOMMTg93/WoH3CW0EBbzkuyz+xgYi1asfIYQ6t6i7hiPsvETDVahI+KIiFpeXEzdf94KCAu1eB0TJOIBi8g8KVDlNCoKHOv8TgIJSBqFr2ZTFg2a65K+DxdwDCosQdj9psOxOS062kwQ6pC8pAi5lyyZOijBmG8sZXm13fLjw/nznh7NsMMMAMPcTISiAeImql2UXJAUARrsN6Fsk4l039sOgtsB
 wMMY9aGI
 g+vD/Xcgi5pAuOzHVjDa/Trf7BMxCSpW1p7OswCsyR483lWRg/Qsbwj9x/oasvcuoXpCsaVcDmjJZMho7ziBe0F9z1pRk576faIJETAOfqa8nSZ4lUadm0XmesVQmNOQCgo7knCNAIuBkJ8JKEOeivWWNdYK4KdCGiPhw4vC494p+1WVEzQBbWPhwbzS4ZqiqPuQ8BtNRTya+es84W35pKTKMFAHy6x8/IO6fon6+ILygEVfzleur3nMcjRm7WPFqqR64j1mQzF5KvP3Uc3km0CABcZQb6uX9gCAdhVgmQJmAe8B/BC8HWK8IDRWLJB78OXQHV3z+8rHHpT2A2QwtKcGnxRs4QwY9m1J1QfPwHScT8x4L5Asnx2OKvwEdX3HpqNv6MiYMDjW5NpUhTLFwEfcbqR7wgoZVn5BDoZ8M/PjD0EeHmqOwabRvCvqSv0/PKmGZ2Ha+QER2iayzubhz6lCrsHMEozi7yLQliArN5mrAXKX/Kur5fFxnWGtzOPXdqiH8QQJIbB5GyqI7bfryUJ/cH0OhBC3jps1il0/cwDuvLNgV09lbYADUBr18Mq+QUXC7V2qkg1gshCDwLL3ZLCeQDir4Ij5FujzLdorb32qyvzK0Vaci3b337jMAddCoQVFFB+2NrLHtM2hGoroClZtGpUVg0n+O8FpRop9BLV+hg+DjtiSQCiNafNEBphtiRdreay//Q6CmIsxz+2sZhhZMHrWUN1A5MwlSLsC8wlPKhtatQWEePQj16g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for reviewing Shakeel,

> Do we need to trace highest_zoneidx at the end? Can it change within
> balance_pgdat()?

highest_zoneidx does not change within a balance_pgdat() invocation. It
is passed in as an argument and remains the classzone bound used for the
balancing checks throughout the function.

I kept highest_zoneidx in the end tracepoint to make the outcome event
self-contained. In principle, begin/end correlation is possible, but
under sustained memory pressure kswapd reclaim can be frequent enough
that consumers may prefer to analyze end events directly, and any
dependence on matching begin/end becomes less convenient and less robust
in the presence of filtering or dropped trace records.

Since nr_reclaimed and the final order are only known at the end, having
highest_zoneidx there allows end-only analysis without correlating with
the begin event.

For example, it lets users answer questions like:
- this pass reclaimed too much or too little memory; what highest_zoneidx
did that result correspond to?
- how much reclaim was done when balancing up to ZONE_NORMAL vs other
classzone bounds?
- when highest_zoneidx == ZONE_NORMAL, how often did reclaim finish at
order=0?

So it is there because it provides context for the end-of-reclaim result.
Do you think this is sufficient justification? If not, then I can drop it
from the end tracepoint in v2.

----- Original Message -----
From: "Shakeel Butt" <shakeel.butt@linux.dev>
To: "Bunyod Suvonov" <b.suvonov@sjtu.edu.cn>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, rostedt@goodmis.org, mhiramat@kernel.org, david@kernel.org, mhocko@kernel.org, "zhengqi arch" <zhengqi.arch@bytedance.com>, ljs@kernel.org, "mathieu desnoyers" <mathieu.desnoyers@efficios.com>, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, linux-kernel@vger.kernel.org
Sent: Friday, April 24, 2026 1:46:55 AM
Subject: Re: [PATCH] mm/vmscan: add balance_pgdat begin/end tracepoints

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

