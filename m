Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6246C5AC67
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 01:19:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 586036B007B; Thu,  6 Aug 2026 21:19:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 511296B0088; Thu,  6 Aug 2026 21:19:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FF176B008A; Thu,  6 Aug 2026 21:19:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 111DB6B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 21:19:04 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6BFC41C09F8
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 01:19:03 +0000 (UTC)
X-FDA: 85072714566.15.454015C
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9AFEE40003
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 01:19:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ol5X5nRz;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786065541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vWZTZqhIsmEN7JQt45MqdcH8PIGYNJY5P7d2TgZvBw8=;
	b=d4+9SQE8gq1O16Hxcyi27XaDC2KD+mAKK71mfYa50DhNF6FvIknTYZ06s41Xbg9gJQWx6R
	5rtg7EQ7uqFp2MlsAS4oBJRHj4428yTtW64YCmT+2Vu4aZrSTOiNveaaoMAJxCt6ka9JIw
	fHSfk9T2f4GKDg4aVtzgHRgM2Un1OcI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786065541;
	b=peDtUD+I2e0kDYSsWoePs84fmPC4PAaIEIqK1q/5Z0WH7HtucPf+0PA2xTnWhVidRkdaA+
	GDDvXB2eAS/5y4e0pb7o2id2yxXuLGd9XBAXbIcAQCrnr1O0GImoce4qAmsO5dhw++q9as
	balBFXFp70Z4aS+mUs+cHsXv7F2BoDA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ol5X5nRz;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 6 Aug 2026 18:18:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786065539;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vWZTZqhIsmEN7JQt45MqdcH8PIGYNJY5P7d2TgZvBw8=;
	b=Ol5X5nRziZ0zebSd4FdbmNPb99EQQXWFzPAW1WmLDOmUOa9nDYURuDYRSCYRfF/Z7vcS0r
	I9RFXhO8Yfy43wuBsMHEnfeoBsh2rQ4LIsrdiW3qFxPilhUc+Fip7rIlatZru2BW1h/buc
	ctyrYnux8FaOj6+Xxvoz7yHe9oUm4K8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: JP Kobryn <jp.kobryn@linux.dev>
Cc: roman.gushchin@linux.dev, akpm@linux-foundation.org, 
	linux-mm@kvack.org, bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS, mailmap: update email address for JP Kobryn
Message-ID: <anUyXIVVZf3xcBM8@linux.dev>
References: <20260807010226.8995-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260807010226.8995-1-jp.kobryn@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9AFEE40003
X-Stat-Signature: fsmdxg3z1kbj3cirs388agefztgxq1rd
X-Rspam-User: 
X-HE-Tag: 1786065541-630222
X-HE-Meta: U2FsdGVkX1/Jdu8gJcziFCMq7dLqGXTo717hi8tDDHiOvURR0KtjUkHMyajqjZqKRIfLvCluJspOPxvvOhGfDi7VrDENZUXOppYrJ3+5RcEz+k263/xVJo4+jXzR85Iz/N7Lhl9zo3kZnuS2hS0htuv5Jxe7XnOCHyWJuR/EVoarnstOMjHhzDBuYtb9vO6yHMT3+tsrrtmsWySuu2zrrBuyDMoXekIbZDFJ/pWoL8vTwfrZnCQbMzCuv8rTUN7A+jJHX/Kcg6zcQKLHtTMeV13XhfY7gPon+jaGvFlcK04VjfJtAGF/U+80hfgQkDtFM3VYFT9UNni0MoZUDiauT3jnWgiVsj8vvVhx3CMAiEiaRkAS2mn3ApCbNwNeVoVxUT3O/Bzf1zucsL0BdKrdwxsaIns1GvQRSpnREpHDMa422oHrppVjB7plhZTQ85LM3pSa8mYiJmVWjlROCMR5JhrOiVjXgF3Tt5cAUoJOxj0/IO1HWSI7DWpjd0l04JmYd9gPICwEnGeeXESoIfInjLY9SOd86QaS3HhAdseDfjjHjxY8r8Pp4DMxSQRjrGqRcuGZUnfEOUa4I+1Cq2yUJGa0G0jDgm23Ch5qWPwLY/rc/h50+82HSEi0fSwYO/BhzQp7FiXgxg6Lis+FTf86rigBs8BrBrLtuR9PnQ3stUkqQ2Er00xlxUxfY9/asr4mIqwOGqRK2Q2iive2IZnxWxcvZkT5Vn5uIpXZ70ejJ32vCTeRRKRH0nXuK+qhzbqEsNTSka7CL5YF9lqUfPW4YKw/icJxjoKZSJ82j+Q0POiGXlc47jB+nvD9Ie0w2F/vSZemI2KZtKr3MbUPIul0nAsMtzvzCyxzZvNtlzUV80IZTcqmk/ygMVxFRSdwkMiWIKRyZyycilfBnbs1YoeYVj0gwIruEzF+mS3L4b/Oe38kzpTPputLt4a1WoVPGmMrYa2KRoYKbvJYFOygQ60
 Mv6wLCWU
 WXtQuKlVB4XqTTYyUwVf2jE+LGnKtjKut4JMDvGX1a7kIFvROlbZx64XKZb/hBzM3M5iisDZ394a6gJd7lUCkO8nlBftblvzgV3ER9A23RKpLc1Fa9mnLlAIfjsvpqEY1VYkGVPWkr2VVFltC3j3zZyM4PDSjLajdsoGdJGeVwqkoR8pucsTqTxbCNMNlPDFayo/OK+o1ywBudabJoIBdwwAn+1fFas6g7LJ4d0V/uV9eIkcro0g2RXJJLZV9GBwzwQvc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 06:02:26PM -0700, JP Kobryn wrote:
> Switch to my linux.dev address and add previous one to mailmap.
> 
> Signed-off-by: JP Kobryn <jp.kobryn@linux.dev>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

