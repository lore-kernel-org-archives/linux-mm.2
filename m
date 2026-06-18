Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C935CD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 14:57:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 345226B009F; Thu, 18 Jun 2026 10:57:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F4D36B00A0; Thu, 18 Jun 2026 10:57:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20C156B00A1; Thu, 18 Jun 2026 10:57:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ED03F6B009F
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 10:57:47 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 799D51C029B
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 14:57:47 +0000 (UTC)
X-FDA: 84893337774.10.134EF5C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id D5405C0004
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 14:57:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W12j0M6c;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781794665;
	b=AWhn8AYbK7Vb/SvVjAgYUb/9+5sRqWOywHenWQTVZdHZeYydJwTD7N7gVPY5x4uSTmVJSt
	n2MVuwJXjaL0G0SK7ZgpBELFmexLrWz+chQWs+uN66cw4AaAF1wTjbNEHxuo3pJ8Av6Arn
	jTC/XYhg+f0AH/Lw9x2g6zCDdsI5Z+I=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W12j0M6c;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781794665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t3xL86x8nOC9fzP2/lF4I4AcTSvtSbWHAyLkAKm7fJU=;
	b=xdJYTpSySdpYNLVNbK6CcIsdKb4j4ywqECfzoRLgcZnV7Y4sVU8MF3XFT/WisVAzNW4kAG
	rEnXVhQMt6b0298wx+VKMAYE4su4qE9FLOObD9mSZIVhCqGclP6atuZ4/nvj4LXo7RRaW6
	uMPJyzcPU2GE04A3ldRmBtTIddhunro=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0903B4037E;
	Thu, 18 Jun 2026 14:57:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D08291F00A3A;
	Thu, 18 Jun 2026 14:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781794664;
	bh=t3xL86x8nOC9fzP2/lF4I4AcTSvtSbWHAyLkAKm7fJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W12j0M6c5efqLeOHgmm52ei6B575a2P5WttXjWtU0UxQvtf6itxeR7+LYaMgP9Yqv
	 ZAuDfZSLK6O7cx2okyKByVpk96FhUUsVErBFrhG/aWPuJIQa6cDBmljptzKR5J1oRR
	 Mq5TRqKwNHwt/aDPRJGmDeBHxHQabUEuoKYSq2coLWmqspMT3/forDNLcRyv2I0BPe
	 QcZj9woH8oXxHLS5YUaywUdbTk+UPbsolqxgnR+uwIbgGTdX4WSgFjAv9y68UkFUyq
	 M2ZEAKMq3tcttfUcIh+UYkKzQxOIHbrZQkTrfDwna4sRsXiubZ+3xAZQ+wbw74LMTq
	 dHswWdJFcByUg==
From: SeongJae Park <sj@kernel.org>
To: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Cc: SeongJae Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/3] mm/damon: introduce DAMON_HUGEPAGE for hot region hugepage collapsing
Date: Thu, 18 Jun 2026 07:57:33 -0700
Message-ID: <20260618145734.4477-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <3565736e-f33b-4220-9978-a1461b6d4ee9@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D5405C0004
X-Stat-Signature: wokoziisw155cq9cw6urbkry1r57tx1x
X-HE-Tag: 1781794665-432566
X-HE-Meta: U2FsdGVkX1/LRe3t/VPcyKP38u6xY5CM9QL46+leM7HbBrI+zou8/7SAz8VUfGd52LbKh0fGY0RDCzEzb0zrsH4d3vTCwbpho5pREDJSRv12fM8QDONHTDgqX/uNE6hfbWNdLynWh7MqhVxqK1Mqkgf5Qi0nXQvE201D1baLj5ehpXHcPLU681uNQmiQyXrYzntqZesx+TY2KrQVjpIq9Uxen0J8ZEZFwmCQFzSb3xy3H/4QHweHJzxZ79ZBs8jkTvvtVBQFGFHfPTbK+LvbHEpeItEcNPxyde2VcTCoprDkJV4N3Gb+VjU8m5//Eg2+2lV/xYvtcAkcs51fQmDt47aQbS/cGrKSPxzefvVf3hSocRbagjyXJd2YN2IuOjW+HMR+pC4xC1ipbsk6c6Vfqgj652Oc3NojhUi22vwLT2e5lM3TcSXR7k7/H6hsNpIY2U0IiB8fbdrCAtaXBxz2ssKmrMyp4ItcBKgFiCuyuHYm4QueqSO4fwi2l6Skw4Bxxz1MHnoA293nbROW9AiIg14LlyGRn/LpnMhs/CXKf33Pbh8Xp66a/VTAW9TXBZPFYr4ajsT5cTNeLHIRcmFo5tIpMDfD6kOUdfe/n+ll1pSXEeOYdNj8bpyX+f5gEvv1xtiEojVeYpU377ZoflB67vXNo4K2DSI4g+M2c5kaF0GSkUU7FXbY/JHQKTOEahu0tWc9jMQlLaOJfEMlVQr+SvVkShQVTnyLsnbTIf3P0X5qlW9a61vWOuCRyhi8fAI5mFD3gWCnbtLE6l9VGfKpNBMqS4+WcSqyf9yEuAhjIAlwSRYJ5qaVKPiCJo5oZYM7A02BJaSb3aFaEQbgFNhd6dhk8Q7mW5QF/jiMf91d+nkLt0zoGbzDA+GYr+P54BdSPdlSfZAu3mq3oUJJqFg4bUiDfahAqD9nDVaGTOm3Gyl8SoJbl4GD2sP+Arjy8JnXB3wM046Ri9vfQYmOz/K
 ykGGCqQT
 kMQ776jxmNUrxESJVoffjHcR8WQzoPbDKluvihUl8iJkUbt61BwC6wHX+eNNEEWUvRpXHL3YipOBJuGs1Eu2hNb3g4/ibLXrYwoF1lfhAHtMtdoEXLdhSTeT/Cy3OYokQF8fup1uBnOuQKtMGOhT03UHg4ry6iTcDj/ngNHoUlgcnbtHGbKLHVnLpyNopdX0byYKcRu0mfU45BC8rJI+IIOKexeNdKyVrIr9icWFLDhWk2pIkmO51jpC1MDk9rk7kvL/XxkkV3sMx5I4zFgFA1vI5HVJNSai/QuPxh2dq1x1aIr6MOHbknpNRMOzhTo2Vikh28dVSvkNNE1ZT3mOEyP+esg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 18 Jun 2026 14:51:42 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:

> Hi SJ,
> 
> On 6/18/2026 3:16 AM, SeongJae Park wrote:
> > On Tue, 16 Jun 2026 21:04:52 -0700 SeongJae Park <sj@kernel.org> wrote:
> > 
> >> On Tue, 16 Jun 2026 15:03:15 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> >>
> >>> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> >>>
> >>> This patch introduces a new DAMON module (SAMPLE_DAMON_HPAGE)
> >>> which collapses hot regions into huge pages.
> > 
> > As I mentioned on the previous version of this series, this sample module looks
> > much better than the initial shape to my humble eyes.  Much smaller and
> > simpler.  I really appreciate Asier's efforts on making this.
> > 
> > However... I was asking myself if this module is really needed last night, and
> > still got not real good and confident answer.
> > 
> > After all, this is a sample module.  The purpose is to show sample code thhat
> > helps people understanding how they can use DAMON API.  Maybe we can argue this
> > module can be helpful at understanding how DAMOS quota goal can be used.  But,
> > mtier is already showing that.  So I cannot say what new advantage this module
> > is really bringing.
> You are right, the main goal was to show how this quota goal can be used. 
> > Meanwhile, this patch adds ~200 lines of code.  It is a very small and simple
> > sample module, but still we should maintain it.  I, to be honest, getting
> > little bit concerned about the maintenance overhead now.
> I understand your concerns. I know code need maintenance, and DAMON is already
> growing significantly.
> > So, if Asier has a good reason to add this module that I'm missing, I'd like to
> > humbly ask to consider dropping of this module for now.  I'm so sorry for
> > raising this concern this late.  But, Asier, may I ask what do you think?
> So, are you suggesting to drop the module and upstreaming only the DAMOS quota
> goal stuff?> 

Yes, if you don't mind.


Thanks,
SJ

[...]

