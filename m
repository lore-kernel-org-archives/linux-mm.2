Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93A9E606A33E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 17:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XeYi0OkW
Received: by kanga.kvack.org (Postfix)
	id 270D26B05B0; Fri, 27 Nov 2026 12:02:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 220DC6B05B1; Fri, 27 Nov 2026 12:02:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 137376B05B2; Fri, 27 Nov 2026 12:02:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8C3FF6B05B0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 12:02:03 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D6635C048F
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 17:02:02 +0000 (UTC)
X-FDA: 85481516484.07.7D6DCF6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1DA1A180017
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 17:02:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XeYi0OkW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795798921;
	b=0yRG+AeO6E4cmYqmIWt9Iaa+RkmWVw2Ci5H/1rfg4ul8EVIKwwQovgpEdOPnv94iB60yQj
	kp4mRNr5fbhkclDKZkel+Zmq612nSIf1HXH/87MbMArDa/mjoBp5dWasqfkrK+wgvkc1P5
	wpZkcgqvaPOlvHaMc8NdPP8A8lYdoqQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795798921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CusP5iuHTQw5y390mYkZWLQu5qzJlFufNmxP7wYDVQ4=;
	b=M+aE2me9oiZBrAZ8n8PUFJQNgdd2Qzd9Hagz+4reKzythGURdjWHxsdbb8zJXaIAdW1RAT
	UsOxwtfssp/1uxB2hQJ0M9hmRkNG6ZecYqOthxZ4iK2PisPMQJ5Zl7yoYCmAFOgiCn5YCL
	9pkj1OrJ8kyTClfDglfCgZsynpedP+I=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XeYi0OkW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 18EA56241D;
	Fri, 27 Nov 2026 17:02:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A33D1F0089F;
	Fri, 27 Nov 2026 17:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795798919;
	bh=CusP5iuHTQw5y390mYkZWLQu5qzJlFufNmxP7wYDVQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XeYi0OkWN5ppbTaXrUv6iFcz5Nx1Xkz5a49XfqbZ2mkuahsqVuuU0z8dtjXmvhDyp
	 UxNo3dc9+cX62dZDYoV5nOUvaf10qRNm14cqRCZ2aroVwtVcy2+nmirmHShiaNq/nI
	 IuW1SoGiMOD998LMyrdjj3a73YieNle0AqAp7Kf/HKIqTUG6nuBeUKUSfoNpGoO+cR
	 GvqoJUUaTkCwO//xhVjyvbhw4eZ8f5jpjGBKACDiPbpcpoCLQa5V7LihZvTOvPyh1F
	 2NKiqEcj+s2bqkvXr6QURZVVOskQqBFcX4Wenk+ENjDf7Mp1U5eyTxoSVdNQAHc+dt
	 qYgibniac2nIg==
From: Sasha Levin <sashal@kernel.org>
To: Salvatore Dipietro <dipiets@amazon.it>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	dipietro.salvatore@gmail.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-mm@kvack.org,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: Re: [PATCH 6.18.y v2 0/2] mm/page_alloc: fix iomap buffered write regression from 5d8edfb900d5
Date: Fri, 27 Nov 2026 12:01:03 -0500
Message-ID: <2026-11-26-1-daily-reply-0015@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <5b47ee1e-0b0c-4b0c-9db9-43c9fbaaec96@kernel.org>
References: <5b47ee1e-0b0c-4b0c-9db9-43c9fbaaec96@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4m8661867jrpi3jjyiq5mhrthaijpa1m
X-Rspamd-Queue-Id: 1DA1A180017
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795798920-957611
X-HE-Meta: U2FsdGVkX19AkONvRwlkjCaLG4PriBRVktUCRrwgGWfl+6GIGHjTwYQfdftwzfuVtjt6uk/DFTuhcJu5HITvS0o0vXpsANNY6gRlEH0lJM1pgSfs0eA1znqxvtJvY1VfC6pGacb8DD2Jj4yet7i2GpsAEG5pEbmGT81xGPwRtOnwPXjGQ0zS1r5XvtqPqRj+XqxyAni68oMr2jgMMIXN9ndbJm2VM+eYivGKxg5l8ObmWWPrHQnk75U/zfzkpLp/X7d58MJ2qBUj4iC0ywFzymYF6T1ugof6S/qNJ3nrnAWuNtrEmVt/FwHQMku9AFRckwZzlVMiii6haa/QV9M0jhTQ7RqCZczy1mezx/CaOaB6gaYAOJLF8r99hdQyYIe2TdwGy8wAYv+zUwZ1qW0dKEWR/HvKzikmTu6TV1IvTyRjWakreBcbVttCpdIoN+OVUmQJJ5k++DgKiJ+ptvD9VtaHi6GQFq3nG1WepGeVv5FMNecGRr2KmvaIe7nYfh9Y2z5HJmU5iEEuqvHdQJvH8RXrD2cW7eJ45qsxPbGx5V4w7tREoidCha7tYnJjRnaNPiNkwQGQUdv+5L2VtDkHJG7WmwaVSZjp+8fHMykmcGwZqDOQ5z8TBVeQqW3Z0A2AcSNz8vEOOH4KiAhHMSufnYs7LCwSGmS4VpVSqydvqO3C0t1jWb92Tlm/lAg6V4nexYYukKgWjbJKgpizyGGgQIVs9c+kRqEimdmkaTbK0bqpn8wQXN4DG0hlIWleODcPGFCyc2I3rOVCg7NPKHrl77BDqq+QlHdgjs26wIqttic6ZIG05YlSx1+SkIAL9lnFkhknqFNd2cGFYSEZvcMw+OkTc8WP/aCQhKB3ZxmuFQrQedobeFmkx1kQQNxnubZI+W3yfYUP3Cj52AbrPNA1kSoqztoYicenZXlrj8MsWZlrDyP5Bk0k7hua+WiynxOjS1B/0HxV2QF+ZM8boo7
 1l3GENhM
 u4PXrbFsSGSH1qL50i5qHP+yzDeu9IHMihod2xyxtBLLy8KNRvwl/G9xFY302PJhBpgPMKzL64n9nRRGc95JQg88Ff6IULdWAQkl3G6xHzEu1wsGOVgEpFmb37DPNO2TcOA/bEFq2Bdue3Z4h4Zc2gJDu1OJl9hgJ17S9w6dH6DnX8Nu16hwIoZV2kJ5KvSuaLYK+wMf07xVCR/sUlbTBaoE2PkTOHa4c0jXgraOeiar6hL52T3g4lEQCUuqnh237Zq/u/HZDN3V+mPSwWoWtcYcH9xlTsBbQCnjwFmIU9+bLwpBc2mdif6EW5Gdl8zA6eTqbLpvGuPxRUv3nVZdrBJoIcpWbCAh6yH7S9VtZNzRqnGl7mC6HukaVJr6PCqgGCFshkSN6lb6oaQf8nwjJFQ/rvcpTE4ACE131OQvjIfaOVDi8Gv2JHyE5p5Bo4zU+HBMbK/O74LGFcyBhCaatJjCwV+nMzCGYXw0WJ6wBdHmXx7IdJngDC1uZVGPdWkS2ESj4NvBCYTr4i+oDh9PC/U59rD4meXSfdacX8yFeb5ZprAvWzaMjvaVPLCC5PgHvOKZ92cRlCsb/GzQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> Oops, while checking that I realized I don't like that this was backported
> without also b480cbb071020bd590a0dc0166635b448e9fc46b and especially
> 9f2fd03c9bde366c928c9242fc9b2e2c5111a134. We didn't initially thought those
> worth backporting, but now they should, otherwise we have a weird
> combination of behavior for highatomic pageblocks in the stable kernels.

Queued both for 6.18 and 6.12, thanks.

-- 
Thanks,
Sasha

