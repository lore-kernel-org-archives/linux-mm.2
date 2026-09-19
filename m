Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65C18C982DE
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 02:44:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01DB06B0088; Fri, 18 Sep 2026 22:44:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0F4C6B008A; Fri, 18 Sep 2026 22:44:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E27826B0092; Fri, 18 Sep 2026 22:44:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BC3A26B0088
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 22:44:24 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AF1D1C0190
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 02:44:23 +0000 (UTC)
X-FDA: 85228968006.25.3CCAF48
Received: from mta0.migadu.com (out-114.mta0.migadu.com [91.218.175.114])
	by imf06.hostedemail.com (Postfix) with ESMTP id 72D49180003
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 02:44:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vZaGl9Ju;
	spf=pass (imf06.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.114 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789785861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VG9QPr62Rpp6ly6hldEkPudeDcBlsTIsUMSmQgU7ScA=;
	b=GczEkrGvvqWDPc+PFrQHy1a5ohB3O7SrJlcHemR1XVZ5FpKPEiJb9gXIEb3T6zgkx5huBe
	26+Yrrq0hpjBkIV/u2Jn4Ucln9Q7+Sut+ivIXwexx9DIiET415MZTKXCGMigr8EtUCyV8M
	cPlVIWEUMJ/VP58N4BFjdFG0s0r6RD0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vZaGl9Ju;
	spf=pass (imf06.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.114 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789785861;
	b=xoMwFyr8YZt+a80ZTqJIh4PPNTcNlSpzQ5cxeueMbRl/GrJ7FG+ZdBE+NnGVFvP7U0PrZ3
	qMWDJgbWjJ4q2Ux/U/LaYFgj9xFxrLwQv2oWxRt/MvI2sI3os98Q9CTPMh8/rddBP3GN+7
	vN/sO24SyLxNo11js1fVR1DoXRKfPDU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=2IjYtgG8aEGlrkRaCldCU7rxmh7eS04P9nOParu7/Do=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789785859; v=1; x=1790390659;
 b=vZaGl9JupkK+ONnb+50e/8KNP1V9VaQ/7SPP+U3m/p9clcug27cnVaWO3927wNUzzX8imRLZ
 s/TYN0O7CklWeDamZ0VKO7MQr0Jf2iWb7QcnAANsTpWqQ9Pw32CF9AbW4OgHaQ4QwSDSlmP9WNc
 Cd0ZvfFm7ooqYUzBczhhf57o=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id b49c6a9b1f2ef0af;
	Sat, 19 Sep 2026 02:44:09 +0000
X-Mizu-Trace-ID: b49c6a9b1f2ef0af
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH 2/2] memcg: remove unused mod_memcg_page_state()
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260918165601.1014666-3-ekffu200098@gmail.com>
Date: Sat, 19 Sep 2026 10:43:56 +0800
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: 7bit
Message-Id: <75CD82DE-A4B4-47D5-9D1D-01009077A16F@linux.dev>
References: <20260918165601.1014666-1-ekffu200098@gmail.com>
 <20260918165601.1014666-3-ekffu200098@gmail.com>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 72D49180003
X-Stat-Signature: 66qnkty8tuymkx1rxk548fbh3suk6tdr
X-Rspam-User: 
X-HE-Tag: 1789785861-624273
X-HE-Meta: U2FsdGVkX18ohKfq3ODlcjbIu6qg1tOHn9gM/f66e8NVhhpLZcDt1iAw3QlNrhMiMqbRb+0wQv0g+7OVUwSETZUVbMqL/SzFteN8R/Ckrp0PAExgfMUF8YpQG2WA2zjeEE0VVYAd+s84EvdinaJCRWqliUxaEZzuNqHOWr+NTxvdt9AOHjDjG9Lgbu5CEqlnWlwIcCR4VLr9Rn9luDeXYEHEQCQ1vmwupDgl6S8AgFjzmFrG3r0kML0z35gu5b1uPewkswpdvi8tQpUxrwE6g3FF5m73pBbmuExoSLPgYZh58L4zghNPNTLhjORT4kdgVuC9Dpjfi7rY6E7MJLT6lduuLbPGmCC903qC2utCtSUJCRsBdztpdaa/G82URKYVZ8/YdV71Qf+0+EMhAOjOrT5iWWdlHNLO8jZBUaJkqQ6xkoXSrnryQG60TLarPws9OPHJ3SZwdESmp2OL6tD0U2qYrM/YkeISixvzk9j7ItNMq/tfFIQJFFuXc32pZjMefUs9j9/+73HRiIWfkidbnRtZK6SWfgRqHeCAb3yOxTppjxQOHpMvlsWIdfB7+sEaDwWs/VhOE7RrVFcCIY6rHoU2YTuFAFTx2LLCSkU18kK5UClZg8qd6CE4b2SW5yKqV5vNtvm5ku2qY24GyosaFP5ogfOBTK8SKYZjx+nVnaf/eXm3XyN00eg9LDqhaEO1MxSj4TM0UKwNdob0hAoeFIomXcTPsfZgaH/IbP54VmJet5Vd002vCpauM7fllBeHAmnPxW1ufybwnLE11B3LPj/5BaBEgDMpLFj4PTY3hwWlvFS13rNvccn4nx6OdPvwxRXMii9TSzIW4uXnocG8KuO7ygcm0vRF6l8Wu13BnFiE9pI14H6aB1B4Pe78eMjh44WhRfonizco2NQSLiGd7xN/ACWDKZjpc18A1+wCHe+Rj+v4TM/AmIFlR8X2fXapiU8EOZl5sc6LQbDD6wb
 QCpBhNny
 wr9IpJjpps4Rz3uGDNn0wbth5nopC7rhiLv6ZZU7XuY3FMMcIRBonR3FZ9nQOjxQJoITauGbjLXk7Zd9oyZYEnuvKEFxcmFMSDC8nucQhNyUxKxVfydxe/qr388pT20G1p5bNp8kVF2oVWfjqW+oUqSGaG+q6f7zd5BFQaG5UiOPAXVfZZYIzOsDAzXyAsS8XRT3cDldWWqF5uVIxQ1bng5R3dxWBnG99XtyFyY8OuaXHqST6z9w9CrcuDokPzDOfrkdK4VyfvYnsFkCYV9QlSD5OMROcDBlvwqTzAl8OhjvtyT+y9BICxLmqckhyTpQ1ApyPKSUJo+nMBmQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 19, 2026, at 00:55, Sang-Heon Jeon <ekffu200098@gmail.com> wrote:
> 
> Since commit c466412c73c3 ("mm: memcontrol: switch to native NR_VMALLOC
> vmstat counter"), mod_memcg_page_state() has no callers.
> 
> So remove it.
> 
> No functional change.
> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

Acked-by: Muchun Song <muchun.song@linux.dev>




