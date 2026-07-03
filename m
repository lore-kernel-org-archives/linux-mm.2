Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9836CC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 16:20:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C2FE6B00B5; Fri,  3 Jul 2026 12:20:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69A166B00B6; Fri,  3 Jul 2026 12:20:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D73D6B00B7; Fri,  3 Jul 2026 12:20:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2EFF76B00B5
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:20:15 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A16761201FD
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 16:20:14 +0000 (UTC)
X-FDA: 84947977548.20.1573C65
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 01F181C000F
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 16:20:12 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GQKIJlCZ;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783095613;
	b=C90dJm9MRKblpB0l+4Q2ERxUO+RB4tbKnpfgPj112qlujWZdyZPkkKeG5nyZjxyeSqlURi
	2n/7+XDHYKwVfMOLA0+xKbDpX6kMlC4xMbDNJO1R0W9RGP2pev/O3VbYNksnmAYPZXEP2C
	CIvNTo/xhlnoCI0Uo7j5SVXY8rWH0Yg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783095613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ddR7eSoVEyEcl3BhCOBDmoJmT3ubzNn7ZbozMG67wf8=;
	b=QFYbaXVlzDL/kRA0Lra31/ttLhWPNAWCmErcIPwRYcVv4e8qVoLaHJDXzfjtxAsXYtlXEo
	9oqqM4uJ4xZuB2yMuKUuXdd88SJfBC/oG51rIpTQ6wAJhrxKtSjFu/h/H19Ji3GJjpJc9G
	sEDTZ1AAFDVIReyJrpCAZKmJJQTJqPo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GQKIJlCZ;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5DFBB60051;
	Fri,  3 Jul 2026 16:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D86D1F000E9;
	Fri,  3 Jul 2026 16:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783095612;
	bh=ddR7eSoVEyEcl3BhCOBDmoJmT3ubzNn7ZbozMG67wf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GQKIJlCZZUn2DV5SfAx9xQlXxm9b5+UElaU0F1zJ1EKEcgER0WtpdniiXILbaWunq
	 4Yo+U2i5BC7uBQ4yCdMvcGF1vWFXIThq5WjxwXsvYHrq8gaOgDARj2E0kdxW3WNSVc
	 qzCi0fVknpznvPDXa1IQZx8/duK1KnWY5Ipkdv3Yk+E+T3rktQIyy5idJiNwerFMlh
	 FG856nM/SV4CVYsxIDct52HwMNyintmSpvwxwXNL5Iums58wcAvxmaeZ5as3mDTJcU
	 ljZwMqvKtP+ETHuBuOS9GHHSn/lgR8oA6uiS5dCEr8ngKdBwdnWftRjTGFUTPxam79
	 PhmwcYynsw7NA==
From: SJ Park <sj@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] MAINTAINERS: add Usama as a THP reviewer
Date: Fri,  3 Jul 2026 09:20:01 -0700
Message-ID: <20260703162002.104098-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702140257.44780-1-lance.yang@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 01F181C000F
X-Stat-Signature: ob48z4j5y96ass7ey8fex5zqu4yqo37w
X-HE-Tag: 1783095612-635046
X-HE-Meta: U2FsdGVkX19DRWq/4d7CyMH4mmlzM4mOaZzRPaZDUk4oNjR8HOHiUf4zYK62J+wdEVaaywKQaqaQmVY6iCBCGK2XNoIWhFe7/TGPv7EVCXt4tMWN3YNlgXwgOPL28GZ2hn/+mbvDOCtaFPz2QFzTdsoXzZCs7KPYcv23s5Q0ojxAdV7/RWZAotN/z74KbkLOKSDCXI4oku6dxrPHTs+hKgFPwu/EUDADHMB/l1qyIVXUHyWQM2/cdeWN6M2Oms+Ut4gyTwT7bXK+YdB8A50HmbuH068xUYD6tZVutTWyz/rsbn8vuWuQtCBHgmrajwPUKpRoRMKFSstq89Ozr6aFJ+J3j8k62c8nbzpgc5HVMupYNi5tH2ehKSYRCAkNuenX9QYHFrYkoorDtDBimr7JoVq5kpdQdGjy0NcdyQ+vgStTThmz/lb2QfyO0CAnfC7tvxguUhu5VE8S6JG0cV2nVp7UJyrxcQWNCINqcaTvnv0JcrhC6rc4opTq76tP2XdadmJkESZL3NV+fuRal1djcnqQ37N9ZpD6JogFR0uPsLAKDqUyxvjmVtf5bcYtrQ2F4LHr9bP9xPCQ6xZhtmfrPBaBY1h0dlfc/MwNUO0zKTG1ckZfg75V2D2oa9X7uq5OBtkWDMRShZtFxDj0f+YfHJyBscSzmz+9T9tME9XTwsLZ7YdeC1D9g1WVyoYmqt0umUYlLLfsVLif6y2VeqjGfcjaTrrjdV5NHClVqWn2NtAjRL+VTaFY7N0VqlJng6ldoiGLNA4SqU8n8kWFu/qU2miPOQK54zGhBEvi4gusvyDWQ2ogigA3lNxFFQhGhYTfQFvsyYDoVZ0xQrZPq9Gh63nhn6qt3fxeLNceUS2xR/IO/LYO2ouJweGKmYW9/8zsCmePO74uHfJosO/kBnJzqkqOkBy/P0K22aqbXJAaHoCLgKPPS/0nFRNJo9FFk1TYzRN7DCZFQzOOip7lRVS
 ZOPmSSOv
 IpYDqPpTNwfsuBfKcUfIaiEaeLmKvo8htdWpsB6j3zQlY3lamJbb/kYTzBEeA4Okm9B5+4eLNvM3Ftu8cynrlgdO1MglkEVCQzoAuQZbKo5x/q6PAxxszzl0ICZPsi39WQb4vBepRnhf24G1hzfVL1C0HgnvTO4pZxAs9NwO8Ge/NpAK9QdXesatg8Lc8mV0TNVE9Zr4S3Qnk/7S0YJEnuba2FFUjLTMMlyq0NW7jPqRU+Hq3wkedBJNkrjORU83vkv7ayr2JsDfQ1JY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  2 Jul 2026 22:02:57 +0800 Lance Yang <lance.yang@linux.dev> wrote:

> From: Lance Yang <lance.yang@linux.dev>
> 
> Usama has been active around THP, really enjoys working on THPs, and tries
> to review all the patches that come in.
> 
> Let's invite him to the THP party as a reviewer to help with the ongoing
> THP review load.

Awesome choice!

> 
> Signed-off-by: Lance Yang <lance.yang@linux.dev>

Acked-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

