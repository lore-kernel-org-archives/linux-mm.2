Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E969C1098797
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 15:51:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16C616B00D0; Fri, 20 Mar 2026 11:51:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 144706B00D2; Fri, 20 Mar 2026 11:51:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0810B6B00D9; Fri, 20 Mar 2026 11:51:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EBB7C6B00D0
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:51:24 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B681B1602A7
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:51:24 +0000 (UTC)
X-FDA: 84566880888.19.E41F85E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 202E91A0008
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:51:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iPUHva13;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774021883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eOyIQaZRg9b+nYvbn49ngF4Nt0TjZM2HYyvHW1CqHYI=;
	b=xWnegUFdH6kd4E73sB6FpWBptO0ZyYki3/3RLk54FU0ovA9zAxgjE/1b7BU5Z4qA1znHBu
	/ok9fDsMa2WhIKK1iL1emhMLiEXU6spMf/YF0BFDBfCzn4TdSMyNVRxZluxYEDdkSM+5dU
	PyoMQMveTtIG6tkQ/DhnrUYAeLZlalY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iPUHva13;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774021883; a=rsa-sha256;
	cv=none;
	b=oFbyGZgAjcUKWlHQQuYcf8cMw+4fUb4VdX0FGZ6l2GDJiNrJC9qYIpQNx/shyDMnNzyYjq
	hub8DEXnnqWCbHJ2FIbXozgX5V1Me8ivNr9Se11g3LAZwBEcT1/0t1RvyiqauNxtcAAaY0
	M6tYXbPkJFKLDsqUdvJ1chG7fKh0s5Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 91F9B60126;
	Fri, 20 Mar 2026 15:51:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24479C4CEF7;
	Fri, 20 Mar 2026 15:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774021882;
	bh=oLa2yNfLRCVKbcj1mqAupr8pkOcbafxnJnVVjt/KHDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iPUHva13aLssUNKZdyL3hik6iWY1cm/v5s7YTF0Ichg3gjqm6xmraqBL73k8q3jHA
	 wjt4ztB3Czdbf78qu9WzBHKlEI/OlO7aQBjzr4qgB2Pnw5l3XbQS9jEmQcK995Gbpt
	 1SC5r0zbWpAU7o4d2P8wuEUcyju9bdu5f8aodzzuSNkCZ984iUsQeyFiLg3WRKUKoN
	 jFVMj+Io6AUEBaNwZhILTR+OSAfcg46osW+4SCJg07ye6hcPzWGFO98kBVKnJkY8kh
	 ylwveh+bG+FfZT3D4UFdMYNdYsLVuoM8EHMPnB+vJ2lt9Q1bEQV6y4qOeO3mtUJi9m
	 9e+qBdnRiyzdA==
From: SeongJae Park <sj@kernel.org>
To: Josh Law <objecting@objecting.org>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 2/4] mm/damon/sysfs: check contexts->nr before clear_schemes_tried_regions
Date: Fri, 20 Mar 2026 08:51:14 -0700
Message-ID: <20260320155115.101025-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <C65E16CA-8D81-4B88-96EA-59DB554494A0@objecting.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5k89c4stabi89xxqiebs7spafpd8ztor
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 202E91A0008
X-HE-Tag: 1774021882-603476
X-HE-Meta: U2FsdGVkX196G6u5HqzLcbOYAwxpvUV3nMF6CX9COLFjXHdN302fS7+7GjpPaUY+aPoUqmenoXaTlf+NCJIys36kIkn/dmf53zjDJDD2SUYaQcOPlXxwaN+E+z6mcpd0NEOtgQeVqw+5iU+YVQhEOPy1e+OzAtyKbNPN/isfWKqpWbcK0INylEVx4RTobWWnr2G0j5BEEQaSI8m/ojV99To9L1VcSWZ4VJX2C7N6MMqJBRsA5dmn8XzSyyISwiyjGQCc7AHm2HMLIQ38TOnAcF1pKbv5BlUDT+M++byzA4qYS9XlrVDvf8PpjrhfvtKQqP2NEQTObRmihiE/EVNZlGSaH/+cSk/lrxCuFQfRPeFNHuc/0tB2yl3al7ybZIe88BOJ/R8eWKS4DC+z31G3sdVt0QZ4Z0SvKMseGRypB4xDItwfjZ0wqNgsZ2kbg8GRZwiGP/LfGCh22EOCMMJYUKo3uEkGKLZPI4r/Lo8tj9Td48lMC98HM1IToaWj5PvrU8h7L+lHbezsYIPjleuOFCS1B3PA99NX9++2cYbGf8ZB49cgv0ycQJeqm0skRgjDs9ixqTvwnD0ehU8I2TWI4iaEkYQkS4iyrY6bAl0wLfjjSEDM4TZ1EjF/oacL4p6SsJGDlLoRA47oqAUKK00+yGhiW4QaXVz9dfXEnYIn9CtvtYiWW8pHmc8YUZi6nZRw6V7FiDtDKBAg5lqtXMPNEs6w2018fIzGujrZd0om7aCg7WNubhtfDsHEL/cEUELRMGEyvM8vk3jfQzohH1UdsgWM99JoiHAOsV4UcOpwoo7PFG41Y/gjmWqfEURnlLXdY78t5RlY/jpWj7D6cy+l4qtZs48EHESR2fx2qQmEbVZSKY2sr48zRMr8oSQ7XviSYtz6rFJNrNxwfvXXkgiU9oPa4ZpxM5ko3rwtczZzCnKWVJvQDRyMXeuK6+aijs/8r2aECY4ojKRopqFWsLP
 WRcAf0GE
 kPsS3aaF+reHYFhpdwmCJuQ56m+s73lS3uDf5OKMD15/uKcvMBE3gpsaroIDjCAatH/sZartGcI4efw3PrR80AzH3YSjQxhc/MYyPs0bX9PqEKzRRNBNV/iHk4EgfiYlBDeqKP1p2l7sSbkqD/bW2EoL/x0e3SGYyadQGPkNyUs64v+ZhiaygZXvbQvoPHHIxA541jO8y27k+z5ICeyBB9JaB5u6WxoEFF7KO7HiBpLJS7K3wr58y4MP9H95CstpNXbWoJMk6UO5RCKYcMvhvks3g17zWl71sVyuAzR3zVf9IQJdBJzinZRfzjLXUpm90oGO2Od8AKl+AKfg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 20 Mar 2026 15:14:54 +0000 Josh Law <objecting@objecting.org> wrote:

> 
> 
> On 20 March 2026 14:47:40 GMT, SeongJae Park <sj@kernel.org> wrote:
> >On Fri, 20 Mar 2026 07:06:48 +0000 Josh Law <objecting@objecting.org> wrote:
> >
> >> 
> >> 
> >> On 20 March 2026 02:13:17 GMT, SeongJae Park <sj@kernel.org> wrote:
> >> >On Thu, 19 Mar 2026 15:57:40 +0000 Josh Law <objecting@objecting.org> wrote:
[...]
> >> >Not necessarily blocker of this patch, but seems all the issues are in a same
> >> >category.  The third patch of this series is also fixing one of the category
> >> >bugs.  How about fixing all at once by checking kdamond->contexts->nr at the
> >> >beginning of damon_sysfs_handle_cmd(), like below?
> >> >
> >> >--- a/mm/damon/sysfs.c
> >> >+++ b/mm/damon/sysfs.c
> >> >@@ -2404,6 +2404,9 @@ static int damon_sysfs_update_schemes_tried_regions(
> >> > static int damon_sysfs_handle_cmd(enum damon_sysfs_cmd cmd,
> >> >                struct damon_sysfs_kdamond *kdamond)
> >> > {
> >> >+       if (cmd != DAMON_SYSFS_CMD_OFF && kdamond->contexts->nr != 1)
> >> >+               return -EINVAL;
> >> >+
> >> >        switch (cmd) {
> >> >        case DAMON_SYSFS_CMD_ON:
> >> >                return damon_sysfs_turn_damon_on(kdamond);
> >> >
> >> >If we pick this, Fixes: would be deserve to the oldest buggy commit that
> >> >introduced the first bug of this category.  It is indeed quite old.
> >> >
> >> >Fixes: 0ac32b8affb5 ("mm/damon/sysfs: support DAMOS stats")
> >> >Cc: <stable@vger.kernel.org> # 5.18.x
> >> >
> >> >
> >> >Thanks,
> >> >SJ
> >> 
> >> 
> >> 
> >> Hello, did you give Reviewed by you? Or not..
> >
> >Are you meaning Reviewed-by: tag?  If so, no, not yet.  I want to get your
> >answer to above question first.  Could you please answer?
> >
> >
> >Thanks,
> >SJ
> >
> >[...]
> 
> 
> Well, two is in the same catagory. But seperate fixes may be best.  Because patch 3 dont call that function, so it may be screwy, i mean, if you want me to. Ill guard it. But its a bit on the hacky side

I agree there could be more cleaner way.  But these fixes need to go to stable,
so I'd prefer a change that also easier to backport.

So, yes, I want to.  Thank you for kindly accepting my suggestion.

Could you please re-post this series for the first and the fourth patches as
they are, after adding my Reviewed-by:, Fixes: and Cc: stable tags, and a patch
checking kdamond->contexts->nr at the beginning of damon_sysfs_handle_cmd() as
I suggested?


Thanks,
SJ

[...]

