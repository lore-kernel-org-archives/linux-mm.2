Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD074C79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 15:03:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 900FE6B008C; Mon,  7 Sep 2026 11:03:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D89E6B0098; Mon,  7 Sep 2026 11:03:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C6F26B0099; Mon,  7 Sep 2026 11:03:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5559A6B008C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:03:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D96101C0AD7
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:03:12 +0000 (UTC)
X-FDA: 85187284224.17.0EC3B3E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 14FD71C000B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:03:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PgTSUEgw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788793391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9uP17uHCuhjFLw8SyL7E1yzczVcF2HWa1IcWs1P6CnI=;
	b=IF5oTyWv8n4Y/gsULdXb9VwNuRHZs2eNcTm+RsZxOfH0m62H11qXhk9riK4pgOWcvoE9bE
	k+PHTXFwyeu7NgvR3ANbZm5GnUv+6idnX67lE1QfoYeCYdYIisr3z0XYTsg2jvV0hYvjRw
	YReCx3GvrvKVOXDOazj6JKMKW/Z3sxE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788793391;
	b=MOXY3FQG9++3srWINcAk/c4ckW9/gxws3yCnW+Q0wvyuWWE0kZOioIMfHwvZszNiFHgQ9+
	CUUF1tETl5Wn3DzcsGKVSMJhc4Ct+noNQEKsrtcxr2MavNRGuWQe4lXjbyoaPynIsWKX1i
	7Tf1IxSW2ACb8dHJA1J2FvKzP1rfgjU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PgTSUEgw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7B29641509;
	Mon,  7 Sep 2026 15:03:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12721F00A3A;
	Mon,  7 Sep 2026 15:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788793389;
	bh=9uP17uHCuhjFLw8SyL7E1yzczVcF2HWa1IcWs1P6CnI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PgTSUEgwMViH9O0Ctr4/qFmBqyKGp8mKypOH/GL3h1tiuiVoXPmvH2PDulvh//mXr
	 6OJgE+08XLyLJUoH6Tun3qo3auANuR++qibQYliCWXIl8WG/HqaS1l8yIXsrF2qrrw
	 Q6/oJj7rQr3YKWtzi3ZmehRZc8li4xJ/8gfBVj6fxOybShSY2DpkfVZvveVgctS1OD
	 gx8Cj6zoeuF9N885LzwELKeiRG3ATJR/bh4plwQfjdoPjQ6I6doV/zkslHoykDT2kE
	 xuSlObK1xmeWQ8MonF0DSj9q54qLj5w+rCOD0leWywfZowEiocPUTjcOXW2psvUPdt
	 f0MSWxQlMo0Ag==
Message-ID: <0afd7bf5-a059-4cf2-b9cf-e028b4eb86dd@kernel.org>
Date: Mon, 7 Sep 2026 17:03:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slub: unify slub stat definitions to simplify metric
 additions
Content-Language: en-US
To: Hao Li <hao.li@linux.dev>, harry@kernel.org
Cc: akpm@linux-foundation.org, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260814071848.46922-1-hao.li@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260814071848.46922-1-hao.li@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 14FD71C000B
X-Stat-Signature: n1746rk6yexc7qkoma9ie441gfkm17r9
X-Rspam-User: 
X-HE-Tag: 1788793390-846337
X-HE-Meta: U2FsdGVkX1+Cmk45zzUafT6+BgGneb9zedDAm78fa2Y95P/0HsDfGoI9Thipn7MGQqMsnXCIFrDmgPuT80n38l/BdSfUmaRS5woCz1Qkz2rh+7GOGb7/dok6xrQMhTThpmYQYO0xHuYSDCBPhm/a/vkwfIXOyL+Caeo0n34A8pscEalkwmZFTdE+r/UA0VV5W8iqbSyJHAKOQSiG5HXx8jbA9iVUWWxLfFz47cT12sJ74+/gpEF2Wq/bOkFSc1o9xlgT9y1Y+zjcDwycP4p9KEnyveregBlyksJpFyaFluKIfn6gjodjzgzksDfrUI7P0fc7BX+yrvkRX6qpLatddVLx0jl++kezCOiVYf22BkeDc0GdQN0RXWV7+v07pIZP21O1LlBH2Q3vBS4lGwlJbZuABwgD4s+lS5eOZDU/sYW55/2kjqT4msnLyHAzOVLNV+sQn3fZv7/ghV4SeRsQj0a++HJqfm/47Jvk10ppkDyb6WT79uO2Gn0dRQbHc8lxCnv6Bsu30m5ggnrLYUH/sjN/LcLRSEEKXeW/YbGrOFAngLdBS+abwCxb60Q+F6Lbw6e19ZTqzl2Uno9Y2iajAuxiXQzVLrIxGitg1DnBPhMouBcSGGknQigmnbhttrPA10FSP+bp80nhWj+D72pXuzzUeRIft8yNhij+J/XnmgnYyy3BSLN2j8e5U1LqI8Ph3YdjUwrWQY+CkrQnkfeAAlFx7EdDiE3fCNC8dLPZttEO6RT4H6y/Sa4TE6NQqiF/5nFL5XWBIxwlmzupjTrUZ08Qh8vOg+JMJwzh6rejOxNYCsd+p9XkSE+Ui4IyX5r287im6O7OT9rlc5SHsZvCtsjVHObCBblWzvIHv9uQC7SPyIkCBu0fRSNPuOglPY2HeIdWdGsQg1JR6jDiI6iJpLaBOlhu92FLJisFHi8foLaL1BQvy3O391qEfCF/7ApoFBMS8smoBc6DAaiA2F/
 wUTvPhx6
 fWB2xas2pk4HvZkFIrdlLQizQOLGMjO+P6yIvVn7MHZ3ugAof/ynLz3HgPvdD0DIWPCPKBovA9ricjz3WuCr+7kjP2jCnxJqrlmnB5iCFJqeQTK1PggpYeZVzPuZNMV5eM6GYodd86CN6ic3HRbyuLVclhwD9ZP8ZNTjXE4dXf25xGFsnXPYmdFv/RBMj/Ao+wjhKAgzL57vuI9c7zNuOuz89X7sfo/uMk9gZcb1NdRL+W/APSaSp3WPiSl74nepuW50V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/14/26 09:17, Hao Li wrote:
> Currently, adding a new slub stat requires modifying three separate
> locations: stat_item, STAT_ATTR, and slab_attrs. This is inconvenient,
> especially when temporarily adding metrics for debugging during
> development.
> 
> This patch borrows the approach from SCHED_FEAT by introducing an ITEM_EXP
> X-macro, which is then temporarily defined as different operations at the
> three locations (stat_item, STAT_ATTR, and slab_attrs) to perform distinct
> macro expansions.
> 
> Going forward, adding a new metric only requires adding a single line:
> ITEM_EXP(XXX, xxx)
> 
> Signed-off-by: Hao Li <hao.li@linux.dev>

Nice, thanks! Added to mm/slab.git slab/for-7.4/misc -> slab/for-next


