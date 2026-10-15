Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7722DCC6B30
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 02:12:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 712A26B0092; Wed, 14 Oct 2026 22:12:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EA5B6B0095; Wed, 14 Oct 2026 22:12:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 600436B0096; Wed, 14 Oct 2026 22:12:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4588B6B0092
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 22:12:04 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CCA54120884
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 02:12:03 +0000 (UTC)
X-FDA: 85323235326.26.FD3CFEB
Received: from mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	by imf20.hostedemail.com (Postfix) with ESMTP id AEB071C0009
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 02:12:01 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=obWgQgFK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.175 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792030322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sagsx23wjvimmBNtf7qRH1UAmiXl6nlbHE9fEVFIDPU=;
	b=acgxduiIrgoz2Mc+2sTsw2sgJmtgkHbfJFHSgpMVF4775o1rxBrwe4b2oEcvynvuf03NGE
	C7Pc0eDIjQgV+nyoWf7+oyd5jEX5NckD01uGO9xaf3Ab94roBR0dzNkBcOvZZpJZUxAWlw
	EflCh9kau11YMN2LXFYe9r98Ild7hAg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=obWgQgFK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.175 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792030322;
	b=vejIDRWEY5VEF9FXYbrZ0YlxORBq4YSaYxG2HSATrMePaS8r0h0B3JVsxtd0OEpaRn9InB
	dwA3KrSFo44nLbBNSXETnGWNM4kz6TNnflPPo4t25UjPHLWKiuvhvh/cKvMEjbFBCZByqe
	QnJK4yyw0yV3Z1HgfrB8WguG/sCbGeE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=OaHjNXyKVR2ly4XZ9rh+SeN1xPX6G78FfZWEiWx20n4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792030320; v=1; x=1792635120;
 b=obWgQgFKylyRSXIAYIH/47rFfzoaJ5EnykGXq4AADvSC/ZAymcJIr/2U8t6KLbFK1LbYUps2
 xXurWVcUwK/OnifeqzavjyWNgS8hk/9e2JLM4F5r+I5j+Wo9fjs/4OE5gNvR+fKndTzPk1DdP5j
 gqO9kZpp0ZItbjiuWXKzI2RM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id cf6ef34820450841;
	Thu, 15 Oct 2026 02:12:00 +0000
X-Mizu-Trace-ID: cf6ef34820450841
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 2/2] mm: memcontrol: remove page_memcg_check()
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261014-memcg-unused-page-helpers-v1-2-240b37c53831@columbia.edu>
Date: Thu, 15 Oct 2026 10:11:45 +0800
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <CFB8FDE5-CA38-4F62-8565-C94D62EB4A76@linux.dev>
References: <20261014-memcg-unused-page-helpers-v1-0-240b37c53831@columbia.edu>
 <20261014-memcg-unused-page-helpers-v1-2-240b37c53831@columbia.edu>
To: Tal Zussman <tz2294@columbia.edu>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Queue-Id: AEB071C0009
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: orgxcximaizq4qg4penefurzjbu5xcew
X-HE-Tag: 1792030321-175587
X-HE-Meta: U2FsdGVkX1+EKVOD6n4hMbHmZbbd3dgDMEti0be3TkwtxlrR11QHoJGru1KuTK58EFM1xuyGgUkKjcclAsAKo8mAyo+bcHZvButOeukygfWJtzuaAN7oGVgJuRIvOyrybCE9/0YDGcoSPmeSZ7WmBUX5b3ppE+Z5ltOhO1RmEd3mh5qPtK0O+E1Gkx1unBpNxUm/r1lhJMUh0oO6RgWitN3BOV61aXu59iabVKLcEWMcQl/eJRL3ehLFGgnlnrEC+bdUzH+1bVU2HtUGS+RETL+BuBPC7xUvNFfVweE3BuPpmXQsqqo31QQz+ftDlQb+Ulpz2imJsOOp4W8+oVhjf+UjL72psNs/UecR3Iv11ef4Iq8yiPzE7mfXf0gyhgzL7BngVRzuhxyfBW6auoSe6vmRdiTLQyulsHRHmL2B86iiuUM0r8g6JbwtU8pr1jLtyUi/aZJQfRS07Fms5KVIk3Atzuo7CEaYnNyL5ixwZ72r7jn0Dy24ZvsQe2Ml6SXlGFzBeLnph+H7tJj6ufX7jTIr/MQei6USNb9adhATn2M7ygSJwVH51cXvrAXJGqy8A88Cyn0xqrGpjpXaEB3q1+oyKmjJnpDMIjV3EQIVPh0AC7M2o0UzsR/ec+4rjS3x7dWzYc2JzZcwK/iS5NRcXa0wvO1Dgl4hfXL6ejlbyz6DNqabhi4Jw8yAC1tmypcAq0toHI0VWtdpWH6wSaNNjwvb/r4uKbXakgOiYQi6WfpHKNme5SzWB8ScNC5WBDrHI8DKUSWTyVEodYqMn8kAhH0vAOe5okuVgWJP7nEZEYC9L8bd9euJTuUsS9XDFqhuCeavsX2RnPGgDlvsbBqqnVVbEhIXfBxShLBn8B4te0rkjsdyRrR7bMtn6TDz8KTqhJPfTp6Yk0uzNhVGJmJLOUbf57RSGIu851JuJndo4NknNCz6st109ob8qudIAG/ZgBDgjOlAo9uuqEHoV9y
 ZPIP84Kx
 DHW82AO/YIwWsSPe+23PKjQiz95qjigTJhiaEGGLiyoSHuRvX2ecXyGimJtScibI9HLZbnbn54ZJM1pthrGAhkvchk/ZJ8WgOCz3ZuGHQ+8H3AzWlKPG0PvLxm7zEQi3i0yN8ncKTHlJPfmVoRrWEmpYTxNWe8Tz2qsxJ1gFdptEG+e1lsLvohXZERlKZcXHYC7qEfQ3J8yh9tHLOcm8/O2VH7m4hpGG7BS7ryG+vJljdt49HUqmv5nA2r6jJPnflbcFAXx9PQ3jFntKwFx2VuH1yxa9Bda4X4jaDwUysU0K43w73MRoZXdOqnmKO9hzn3OreYWsJPZMVEwV3ynyY9S0iMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 15, 2026, at 01:08, Tal Zussman <tz2294@columbia.edu> wrote:
> 
> The last caller was removed in commit 90f095b816e2 ("mm/page_owner: use
> memcg_data snapshot to avoid TOCTOU in print_page_owner_memcg()").
> Remove it.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


