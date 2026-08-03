Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EBF9C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:24:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EA1A6B00B2; Mon,  3 Aug 2026 09:24:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C2616B00B7; Mon,  3 Aug 2026 09:24:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B0956B00B9; Mon,  3 Aug 2026 09:24:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 676666B00B2
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:24:44 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 688F680612
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:38:22 +0000 (UTC)
X-FDA: 85059306444.17.A9CF603
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2EA41180005
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:38:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="iGOhIT/r";
	spf=pass (imf06.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785746300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8qzlmodlEBIbxJqlmoucNkpiYME5cpAY3OvwuNsbT7w=;
	b=bu5/YRusq+CEDvahmfHuOEfJyU0Nxmk4C9UYyOETbPS/h9gfnruf/g1fVHOuaYWVooJQGJ
	aJaTffW/pEG4r2OKBUrNDBYgpqSvGYDOxNLlXQYQwj/GVnHoGNgvEdddMbQ5Ah721376HF
	6aEIZfmllVRCt+fbtWbDDxeX4qddYSA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785746300;
	b=4o9i/8JK2gPWo5fvJjOCZwua2e9wSPnAkuK1Tm9JzxdzjMbd8u2aI8JSWztiPTQHd8jNTN
	luL8dYtfDD5XrCb+zIQZ7uhzLyNSTp104viFKlAVF6SJbMLYmiz9sDnIWkGRZEdIfxBvD4
	iuuyEq5DWxdnGDCyHKMMX4MOqigKTcc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="iGOhIT/r";
	spf=pass (imf06.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8qzlmodlEBIbxJqlmoucNkpiYME5cpAY3OvwuNsbT7w=; b=iGOhIT/rZCy864LHT8ew/VfJLo
	OLuWnwA/E94in/is4ajYmq1OpX0LjjLy9+pRvB3su3w/QlwNEtPcbCebh/kcwZeRHnblHF/txAdGP
	icul/0LVvnbxoMBrGl8S+S3orrIFPE6Iz9tOclMhcMb84nN2W+Bxx359psgjOIckgOny0GXyvcLMY
	ZwP8dcD2eM13KpVOz1jrqyDVbPdwd3T+DyoN5cy+JcQD4/Q80xhSOcG6Ugl/w7DFEcptDVqsc4Iar
	0x6jB5f3BtZOcDUxzOz35yU5NHePIe4qcWjtKh27s0qHS29Q6t7Ft3fwMrcH0+/M6tctvr7znAPe7
	B5ivSTCg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wqoBE-0000000BI5c-1vwb;
	Mon, 03 Aug 2026 08:37:52 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id A2BE9301127; Mon, 03 Aug 2026 10:37:50 +0200 (CEST)
Date: Mon, 3 Aug 2026 10:37:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Eugene Mavick <m@mavick.dev>
Cc: Will Deacon <will@kernel.org>, Boqun Feng <boqun@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, Gary Guo <gary@garyguo.net>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 0/5] tracing: add ref_trace_final_put tracing
Message-ID: <20260803083750.GA49951@noisy.programming.kicks-ass.net>
References: <20260801-refcount-final-put-trace-v4-0-2e58678f0ffd@mavick.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260801-refcount-final-put-trace-v4-0-2e58678f0ffd@mavick.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2EA41180005
X-Stat-Signature: xreqjmjoa8sps9rygoedgosok1ge6tk6
X-HE-Tag: 1785746300-810075
X-HE-Meta: U2FsdGVkX1+eGWMlT1zEU/Avi1WSFuuedGXlPnhdQuiDxMhKEy5d3Yk8RXXVLY9hD5q8M//WNsFvlBhW4SEy4nYXO2887ABmzU8ya0l1xFFOB6cavhDUMz8vuQ7C/Ki79X3v4zt0CsFdNo6Q5uWyAxjy5+w1HlyXC5waeI3ujNXqGKhppeuG+u1WBhv10Et2rJExCo68O+hOapFrDK7JSu36RVfePKE5cH3FEyKB58dgecGpT/KLRrpjDRqnnqlLSU8uThBTAkCIT79qAxI77g2uyE078g01TnDZ66Ew0lbeG3kY+eC0PXfTyubdfrBAXbEE4NGnrl8WW9FP8cqZQuxweSrYgIpOBZ9LGchb4OXVYx8NCbbbGy+moVKJCePYezoaVrj/aPoQoyJuZQopqSB95PA2q7sj4kZIdXIZzSx9ctuT3jCfeERVf77jpBiPRz6S5ai+U+1KtzPTjxDwd52iE8ppJgxJLMKYZUpQY+OsU2JY+LKZPyXgkLPSA4yabaXKYEdk1WL6IXUmxntYXxhWsXY0oF085jAaJL4cuCPpZUkmzdLGlh+7SUzeN/JOGDMQ9SNJz9yTqUj8PSBzTlXVavXAUreqDZ9UtxmeTA/r3hPQiHb3Fc3iNq9oGKVX5zvBCAgqFlI61kkAfgl2es1XGQ7AjUu8PVyQhXqmKZpoe5JDacrTxbcz8iWF8tpToX7B6T7beTpCnI+obcy7fPSkWB5dLVv8kVHSdNCuVrgYIG3Swuydp8ShJLGO4KAVCSPieOp81Rbzj0jyGwG62fuGb/PU5XnybmWyINDePA3gQIoL6e/EtwhMr3Xmea3lsW45tdGnBb84Ql2Qq5J02rSz2TJj2+QISiuzsIZ/MQDHOsCZp8rdq+TdB87wNCxaindP3syGeBjzZ50Fmpuei4z/mUJtkUmsXJtGU2JCiYt7ur5nq/wUKVMni5kZvgOMlMSk8AgfVLfoIOgkuB1
 H0UI/NmY
 WRkVgFICFDigoCDlTuQwDNOaTC7ugYQI5jPOALx/87onWGqFd4jLMnK7Rjm28nSnYo2uD+iss1c5fYUBHW6b864h+Go9hDb6x5R/2OGWzHcHULfvDi2LQ1E30UXLLzXuhQkqbZ6rhyzaz4HEhWC1W9HoJpo8a/ENDQD/kvWs5WxMknjv5k0kijFQUdG5GbhDAheAfTNyzGdn6VaDNothYDAh45l/rEylQondVx66R4JFOf6GzYFgy8MxVnsu85rPtt2z6ukfjfqCVzKVDdP2S9M/tSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 01, 2026 at 06:59:40PM +0800, Eugene Mavick wrote:
> When debugging use-after-free(UAF) bugs, knowing when the object reaches
> 0 references and enters final release can significantly aid the
> debugging process.
> 
> There is currently no universal way to trace this information.
> 
> This patch series implements tracing of the final puts in the
> most widely used refcounting implementations,
> refcount_t(and thus kref which uses it), and percpu-ref.
> 
> The tracepoint records three fields:
> - caller: function that called the refcounting
>   function(refcount_sub_and_test, percpu_ref_put_many)
> - ip: return address of the trace wrapper macro call
> - obj: refcount object(struct percpu_ref, refcount_t)
> 
> Signed-off-by: Eugene Mavick <m@mavick.dev>

I'm not sure this Changelog is convincing me. To me this just looks like
more weight / bloat without benefit.

