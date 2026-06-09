Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBADBCD8CA4
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 14:40:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 416686B00A6; Tue,  9 Jun 2026 10:40:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3ED2E6B00A8; Tue,  9 Jun 2026 10:40:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32ABF6B00A9; Tue,  9 Jun 2026 10:40:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 23F4B6B00A6
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:40:15 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E1A8FA05E6
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:40:14 +0000 (UTC)
X-FDA: 84860634348.26.59961FA
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf10.hostedemail.com (Postfix) with ESMTP id 05CDFC000A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:40:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NWYFODOC;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781016013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fmac61i2dwLocCOx7qcTqnbQ43RtfTqLMELLfckgZ38=;
	b=MvCyZ/ral4qfGcL0HETPbSHrTjopka3CkAXXsEsJJlrw9TaEqCegyZDCNMTvt69B5c88/+
	mvbu6X0MzdzggW17ETUACXZZm8OlMhpyjiS6U6YpCOnOqGtrNw0iahWJt6zV1yCOHzZ6UD
	YqiW4GHK/ie5i1Ju/dlOowKx6QEm8zk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NWYFODOC;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781016013;
	b=aM4WkdVHExq87LNlPYUxKlE2ZW1ow8ZmRjVG/GX2bZIwPdqYWwlxeJzGkqXQjc+joi8pyF
	p28UzH11UKitToELnoQeioFxFobMqpZl7nmmkWUVHemTajUq65tQwAq+7UiS0Yayx7i8xd
	mvJ8BGEcjLK9ZIN3sEvI/mlnINC41rQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781016011;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Fmac61i2dwLocCOx7qcTqnbQ43RtfTqLMELLfckgZ38=;
	b=NWYFODOC/z8fN1av0PD2atwJekgdJSlGgtsB7NkKlRnF+0qjL4q6Mu8Wxh0l/VpAyWI8Zt
	Wy6iYczj3eNFCiaIiYg086C5pcDhiihOM+vqBWNagn7Xutgpmko9Ki/FPS+q/j6qsFd4B0
	5nvk5YbJG7OOEMyRaZiGQYmTY2xkTNs=
From: George Guo <dongtai.guo@linux.dev>
To: Mike Rapoport <rppt@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Alexander Graf <graf@amazon.com>,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	George Guo <guodongtai@kylinos.cn>
Subject: Re: [PATCH v3 0/3] LoongArch: add KHO support and selftests
Date: Tue,  9 Jun 2026 22:39:45 +0800
Message-Id: <20260609143945.512688-1-dongtai.guo@linux.dev>
In-Reply-To: <20260601092823.110362-1-dongtai.guo@linux.dev>
References: <20260601092823.110362-1-dongtai.guo@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 05CDFC000A
X-Rspam-User: 
X-Stat-Signature: pafnciiwko9kk5x453dkc3tgqp1ofc9t
X-Rspamd-Server: rspam09
X-HE-Tag: 1781016012-987254
X-HE-Meta: U2FsdGVkX18QWc/4c1KJSbOcdmxr72njz5J5C5AIWdEpRlrVte3yRlXlf1SyoCcGC0Kbpq+PwQUaE0V0FwfHC4WBVMDDskY2D1Z5x1vP/zrMzd0o9qI5RKPShHwQB/h95kqbI5QrftqdKhQbl1V4e/63mBPvNtc5T2FD7WrxGxiNalbnnbUo23m8NUJMOUWHjA91UwwW1EaQuVFCW9HBY7Nw2CCMqNS69HzGKLG4qhW29w2XWJnKoPS2pc5KGMS8IkE4kIGnNLoAIkYAMOA23WvHxYDeVeqE/yvR2D29Ik5uZPjLHfw6mPdURD4qR4fYeV0atwlRAC+Bsb1qtt8owD+TfaQG8MMr+pwCc5gA4TSCoSAIbOVLv5f/yUW90xONRRnmSQgcv6qgIX7c0kwkG7MM7VHoC+PPTJWUDwgjKWi2dIM4rMeHjk2335eXtYdBTZlopL68v8Fk65zP6OxO1yU15TbG1oFl09Dv7WxusNsoj0QwsWdlemHm+ZzcT8tBZcMNvE7bFeGu0rg7Iz8WbgSgUKWoqjWsmzSkYSP2EaD5Ex4nxGLcVVY6k5lsruBW9ijmEjKvkrJMAzDPloeq83JmPR3GEzAeKgug7S9PxEtifrTr9GWBarRu0RGVLpSv3DDYLe2RlzOh0eARwDNIr8UKepKRbV09KCHB32A8hMWierj3OxGwWqtMuEqUddvc3EXIPZg7yeDb6CFJ7wsoEiUgw8DQUFnwqyBhlU43lsDnJ9FKl1T1t8IQnxKK3bq8lYJihuYr00Q5DEjYVsSPMq4cy8O15CEZHn/L8h9w5ICd9m9BrrRP7drP/7zO9o5jjm7swBgOx/kMvFZh9wYSAbEl5vSRP2JkxDr97DsWM01VljgpeF8mst0kuKnDeOt2YO3IcNxDbUXfuByA3OY+ApYk5rRVJZpjzpP9jg+CfZGXLPKSjC+iWe9s7lPLSRiZlJg2OIhVeVRzPeZ+MwM
 a+nJqKSI
 OjMU6E907ePeT+cMyEaMt5P6Byd5RuwLczWkPpp2Ue5tdLUm/sGEb8rQ6YFtkRO+oPNj6NKbitH4YLZVlrHwOSCTZr6P2xVHZGdaQwOO0Gt7sql1nz/zL8K3oPOCw5oHWNArEvkbHjjxNK5CfXTRs1k4dKlx9Mr/xbTtR9KCAkpePO7oXDaMKvRAnJRw4urF2OuRE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike, Huacai,

Gentle ping on this v3. In the v2 review you mentioned you'd wait for
v3 for a more detailed look -- v3 addresses both points (folded the two
selftest patches into one, and replaced the LoongArch-specific kill
loop with timeout(1), with the timeout value set per-arch in the conf).

No rush, just making sure it didn't slip through the cracks. Happy to
spin a rebase if it's gone stale.

Thanks!

--
George

