Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0A19606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 00:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=N1LHKI//
Received: by kanga.kvack.org (Postfix)
	id EF4146B05B2; Wed, 28 Oct 2026 20:50:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA4C16B05B3; Wed, 28 Oct 2026 20:50:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBB306B05B4; Wed, 28 Oct 2026 20:50:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B14C86B05B2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:50:47 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 21184160201
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 00:50:47 +0000 (UTC)
X-FDA: 85373833734.28.5EA637B
Received: from mta1.migadu.com (out-88.mta1.migadu.com [95.215.58.88])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5D0AA40006
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 00:50:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="N1LHKI//";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.88 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793235045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9jlkrZUAzuKmhcNXjcRTmtM2YznGkNKDrF/0myHv2bo=;
	b=b1xCkEDTC+tEUXZj3auqFZSQkTjZ+Q7zopjuqtjD9aPr5xi/0fTb3dmkAjnNHF7BM/JOMX
	BGu+PFVt/aWcktm5/+5HSP8iWraIV20errI281PC0rTcolIXSQ7pj+6MOAcWjojlwkzl+2
	QElxzdq1wSYBAbVE7K6jWCoU5G7yiCg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="N1LHKI//";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.88 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793235045;
	b=ej/FnHg/cgBnVs9ShLkV8pTAsnhcopHzBdeRzMrHDTsvqJR7NLsCLwShoqCGzAdWInqLGo
	U1CfS8zzCsNdwzwZQJjNz+8pg+CFOGCzkOsb+0Jt6DTxOnSbFCyZ56PuLJFjLBkt177RHX
	d0LSqZjMsUyE0uipGWEaTOVcg94EYj8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Q3XJhfTS0tfm47sz6O7siJZeY3EESnjTM2GiE8srlRo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793235040; v=1; x=1793839840;
 b=N1LHKI//MPgf+iXRcT4Q3OYr9L/FbixptrASJHlK+mZPgUk4ZO+aswz3d6BrUGMjs8b7kBvg
 RXAtIY3F3/3avJOnTJ6JHQnobGRSiq9E71ZpUfJJ3JIbcJHsIsZFyZg36N5V1hPl1lVmAxDYmyr
 UeQRMKHMdAf/SSR4Wn3L/WDg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 59cfc123b442d9e5;
	Thu, 29 Oct 2026 00:50:27 +0000
X-Mizu-Trace-ID: 59cfc123b442d9e5
X-Migadu-Flow: FLOW_OUT
Date: Wed, 28 Oct 2026 17:50:21 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v2 2/6] memcg: Reduce nesting in consume_stock() and
 refill_stock().
Message-ID: <auKYO3MwelgnWKgc@linux.dev>
References: <20261028185034.3607746-1-kuniyu@google.com>
 <20261028185034.3607746-3-kuniyu@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028185034.3607746-3-kuniyu@google.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5D0AA40006
X-Stat-Signature: dua5dayc8pxkuw6fno45ruzhbdeoyafn
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793235043-791250
X-HE-Meta: U2FsdGVkX18csMAarOVRIGB3Vwjvrqzc/gdDjy6ls8ZlITNr/PgpvqI2N8txIFTclDYWwYnqPPJi60jguS4B8gyB03lWx+YcCbO5POhTH2CgX21nkPtb+na7tZwi8AXcKMXZqbg6yo07QSIfu/i1Pkm03WuQ3CpBOuWyfkWOTuKj6RjJ17kjZiFq+VHxjqEjdgNRGWGVnqmPPcp09p5uYeYvtsrif0B7IZlzmF36+ZlnKSSJO/n4MpU3/udRV53FctO6avpaKvUQ+3fVA0rFnxiRCLvQs9JUpvudd3peC+9RMiM83xKYjI1mfDIin0rW/ONlv+g6QjGcF5UDkN6443VKPs7sZrgVfav3rq8BXm937qmuQ3e9ftijWCGclk4+jLx1bHxIAPv23Ft84u5Hjv8xrrl5wm191EY6rgscAFwSkvudp4utiWWMvysWz1d0RerqCdh0QLgHzZZJ/Rw71Nf41SYg6sTcy0eEKu/PfgkretfXAnAtLLGZXg/LIrSNgXP0ee3JCksRBlJqoxgnguc+UiL+S3aQiNRnG6za0fVCugPptqxi35FUHgi0rUNqRfD2GhzWtF6K5RWMbNl00jpZ/23tr/IpwnqWqOV/CwnZwCuEoLhtaT/YZ0ZxEksv2e0//i/jSJB6LIEigUMgsMFrkeVeEib41+qpEIAKTuzkCKZx2ECVVJX/3vSoIe2wy5nuOglnsrdG/M4yZQ2ISX9ZxKKIAk/zgacX5JKhr+gMLdp6o75IgpaP6n4sXIJ3jyiPkU4d/9H16+tC3eJ+6AtkISL3OrLNbR/TLY8KdNciZoTQEiaqTlLu4K8/UlmfgVW5WamTmjplXU8Dg1Lv2CFpBT9a4sabuaHwUfr5IL+zPw9JY2B8hbO/oZhuoGp/V3OfljrBzRxQSfUvozU1V8mUh9kPMxzoeqvWAZm2mKAdUenbAqfZEiGnW4BMr2dTp1fC4rd64LWpQMBJrMq
 9x8zfBs0
 1pFyUa6jMeMeKKDZy9xdxtArjQktUt2r1KCppEnuGJlcTLOnuYEACjQh8tvOw9tg+PPvFLzOMBcHxgKutJn+2C+aqfvkDfh685DESsOXEYeImN19LmYBq7XKddH3W5ZVtb0GvebdKZgoHgTJBs9H80RlN1+9XzUesbDmtR3095zzhy3NwsBhAqk1yWB/dGH+l1HLn6XRNr4cdiw8TzM16psj3r3h8RvRwtzld84/nbuFrCr5vvFHv4WPObgN2pOEalxmLL8QmcUTM9eV5ENuaHuFE/sa3OnmL+MYoSgtiQPU+C+ZHfr+H54nGo+vaqtN5ror8o1XiBFW6kJ31+Rv0/Eezeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 06:50:14PM +0000, Kuniyuki Iwashima wrote:
> A later patch adds more code to the most nested block in
> consume_stock() and refill_stock().
> 
> Let's reduce the nesting to make the later change cleaner.
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

