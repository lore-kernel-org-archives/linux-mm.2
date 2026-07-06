Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DB1DC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 19:48:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AD7D6B00A2; Mon,  6 Jul 2026 15:48:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 484796B00A3; Mon,  6 Jul 2026 15:48:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39BB96B00A4; Mon,  6 Jul 2026 15:48:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E1AD6B00A2
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 15:48:55 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7DAED1C797A
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 19:48:54 +0000 (UTC)
X-FDA: 84959389788.16.C54693B
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf01.hostedemail.com (Postfix) with ESMTP id 88EF74000C
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 19:48:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oa9MCfRU;
	spf=pass (imf01.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783367332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CWX2RW1HumNtm6M/k384P/sHqBUZGLI5pEYS4rkWAmY=;
	b=GY0ZnY+uajrgXBsVhmH3UHBTDA2+1XXUoFMd5zHxbpQoNmmZ3Wf68FsZO1tgg0mT3jtLAM
	rIE+UCwQG2u4u6Ir6gBkU5E8xI+iOMGYdI1wR2IVfNqn28rR0mb9ySqEhFs6KqN0fGP7Ds
	o998whHruiDvpUceWh55OHR06OBXvLs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oa9MCfRU;
	spf=pass (imf01.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783367332;
	b=TwZE60jxxG3kYIqBe90TTcOGbhT1ZwyzyboKdSsEUDXagjDDuSAGICUsRkhRrckC0viVF2
	XrJyA1CeNY3wCA9wKXm80PbC04GMqW0BBitO+6NGCKcXriyfw4ypgVLlcE1yL8b2/5pF6f
	t+0cE5Xv2fW58vttryBmQat/9XnVGvM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783367330;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CWX2RW1HumNtm6M/k384P/sHqBUZGLI5pEYS4rkWAmY=;
	b=oa9MCfRUXRzMF16hkwzuVONS1rjnVLN/iWs9OAnpICtFE8D78D5wzHxUApszLYevIl1drt
	38/rgPBMyLDJQN17BSXlpCgMRczydK+oB5BFryPa/4BLyiPwoGUbqyhioZbEldO81VkcNN
	3HZg9UFwu8QCAH8p2dzM/zN8DKi0RZk=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org,  jiayuan.chen@shopee.com,  Johannes Weiner
 <hannes@cmpxchg.org>,  Michal Hocko <mhocko@kernel.org>,  Shakeel Butt
 <shakeel.butt@linux.dev>,  Muchun Song <muchun.song@linux.dev>,  Andrew
 Morton <akpm@linux-foundation.org>,  cgroups@vger.kernel.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] mm: memcg: reset oom_group in css_reset
In-Reply-To: <20260703063826.306878-2-jiayuan.chen@linux.dev> (Jiayuan Chen's
	message of "Fri, 3 Jul 2026 14:38:24 +0800")
References: <20260703063826.306878-1-jiayuan.chen@linux.dev>
	<20260703063826.306878-2-jiayuan.chen@linux.dev>
Date: Mon, 06 Jul 2026 12:48:42 -0700
Message-ID: <877bn7nbl1.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 88EF74000C
X-Stat-Signature: 6zpfm8q77hxi3qpntybjic5a7rouctki
X-HE-Tag: 1783367332-99084
X-HE-Meta: U2FsdGVkX1/6Ra180yQ/15mjlfmmH1j5S4owEBXwLLqs6k/Ev3umXwjlCDWyvprplJWGurLKyo5RjghFChhyg7QYDkI4GVxQe5PnzPupJZ3lirrLrnznGvmuaieUhn6uwOk/+cSg4sf7xktq8ZeC/+dPTsAfwoJ2+pEH5gYTEOnTTH7m6DkIIIspMiEI/fvSvAcg/HkEXo53w5ByT1GioMNNUkZ5rVibA996Y/muSVncw5RR2wOuMJh7E03GSDv82ktzGSWdmD751xd17+iNsROxJSP7TwXcp9xa8YGd5Z+UoX1v4QyiWLH3qeCZkivyYTODtNv2PDbQVSNY/huQSAHMDK9ExKwnOfXWIYT+HujUcAz35rurp3RWfgnz0um+9kFTHbBb8nVbt0P91pZvjymmc3ohFQCOY/BGO7K8YkxpZRyp1jV1Xmu7oNEle2+9ioIQb5guiG8aZ9qD1Nec25rq6PjwBs2yUZUG9eFT5KANF26a2FOAp0EowyXWLr/LlqRm+OBF+seeBAQ4QLtu07s7SeEXlhN0vvuz+8xFxJxiTEgKzjpCoLlTsBTawvbIgSmIornAyylERPEOFsDjieQnZ6slQdxFXICN7CP3LQ/8NqxkP/GaV2ZzEto1BwCYzuLrgmT2bfkPTfbASlTCicieI6rAyjOXjpDHT5k2BdGIn6cnUXaRcEubhQnQL4KcMCrI/G2hsW1Cq/Z9wcVxtoCFx1t8oOpMR5uQK9r0KjbR3gQZKAul9FEOaG9wf+27Yrfh6c+rQzoobfi6gks1cLQ/Ms0SYb6vHIDlTSxP/cF5wcfWpMYmSOrI5IZBFetrSOlavMPik3HhKmI1NUl9V5bMogvUMpHPerO3DZj7BPBjQYWlRa4QWlDX4hx2T8gpf/oDDEwcV1kq2E4Ki1NH/WvIluRXtHF6nIs1HSXo18Vp8Cv9f8knvZ2Fq/QFF5b5e4izO814yx/MSjUdr0U
 Dz4o75Zq
 gchyVN41f3hZixSCwkSiIa+VfLTUn3SnYu9qDij96C2DOkvyLePtZcoDfYy/+OvXfsYFrqZ2h6CTL6ARVPd0aSUKpBAMlX4SXOqdx7IIm1JTM1dqI2o8kGACiplonMfwpKi1PWftF2NDyMeDglLVuUrUZBFCSdNb6cdzIW6qmePizfKRHkVrODJqkNTO/y6plB/aH4UaN8IPNcJxIoQo2dItHt9bNpfzK8vdPfZ085E+M9hGJyBToTHDnsSBnqeSmaZX0gAGAs8nRGOOvGuMdN+EJM40vQLt1zuAylQte9k6dCXguLVSw8xjVBqOmRiz4TcrqWwtdi623uP9llV0thhNk4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Jiayuan Chen <jiayuan.chen@linux.dev> writes:

> From: Jiayuan Chen <jiayuan.chen@shopee.com>
>
> memory.oom.group defaults to disabled, but css_reset did not clear
> memcg->oom_group when a disabled memory css is kept alive by another
> controller dependency.
>
> Reset it with the other memory controller policies so a hidden memcg
> cannot keep applying stale group OOM kill policy.
>
> Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
> Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>

Acked-by: Roman Gushchin <roman.gushchin@linux.dev>

Thanks!

