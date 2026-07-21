Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54DF9C44520
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 01:28:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 234AC6B007B; Mon, 20 Jul 2026 21:28:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E5F16B008A; Mon, 20 Jul 2026 21:28:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FC396B008C; Mon, 20 Jul 2026 21:28:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D1AA16B007B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 21:28:12 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 35B1C14031E
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 01:28:12 +0000 (UTC)
X-FDA: 85011048024.21.8D04E3B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 92123180009
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 01:28:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W2uy+ueV;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784597290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ucliq96+aNI+vu1/RJUCbYuu0aOGb4J93fyO7SHloJ8=;
	b=HkF1jrB5BWJZIS9V1MyVEHr2FzABEetHxIHvlR9mnaFWJM52rkXJPBT77ACUXaCHJwlJue
	QufGEtbIocEwYoVHdgFiXL/+sVd5VskgLmHf3jBKHgSTuNc2tBYyjBLJLnAaHL5+n/nK0N
	+kIWYfRq/bP+EmbtKPEgVbZVrn+PQCw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W2uy+ueV;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784597290;
	b=5MeTOmpx0Rn9Fxwt3YlRJxlum/3WAZSFqmPpZlJDM+qD2tZnzwIa9SEVDXXUr4/DUHuHTg
	UYERI3Waje2mL7A3/GBmknw4y6ojQNpqUyGXDnz/5TneF8q2loAuccnhvmAtzxH2+q5Cwj
	RjTAm+Kt6AGxnyjfhDhBWJWJWFTFcTw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C3A5A40198;
	Tue, 21 Jul 2026 01:28:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 790F11F000E9;
	Tue, 21 Jul 2026 01:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784597289;
	bh=Ucliq96+aNI+vu1/RJUCbYuu0aOGb4J93fyO7SHloJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W2uy+ueVatRrqnXjFjpB7iTcWu41nwoyeH9AYoQojxN+yCSUCEL0ohoJP3L/+rM7Q
	 rJ8JwQwvWyLttL24bfjSxJSqbI1oJfHkZCmm8sFtykJ1iGDW1T5e0iHYB6SdnBgkS4
	 rJnN6snNiAEdr57Ozf1VNcitiBaOLSHmKTpXmFenZxjUznZRqG0tlrnptbvb7apJdJ
	 v1lA/w5SV2WMhP3PxfvpAU5KsVyBJRtgvEZicX4sdoYXAcd+dZgb8ecCmdhDUxVvr7
	 15uHQxSRxmU0tKvBolnM7bCoWzufyxXxRqoOlm+SAkm4W/4v8hIQgKgBIxDhhw/Uqc
	 vz8au05MMIB7A==
From: SJ Park <sj@kernel.org>
To: Enze Li <lienze@kylinos.cn>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	enze.li@gmx.com
Subject: Re: [PATCH v2] samples/damon/mtier: use damon_addr_range consistently
Date: Mon, 20 Jul 2026 18:28:00 -0700
Message-ID: <20260721012801.94223-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260720130642.508355-1-lienze@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 92123180009
X-Rspam-User: 
X-Stat-Signature: q7f6yqfoxdyxbscsaoayxdhebbwk9k9b
X-Rspamd-Server: rspam04
X-HE-Tag: 1784597290-950331
X-HE-Meta: U2FsdGVkX19p+ZoD5LSFVy11t3ggPnOSyDZro0sRhZONk9qa9yt5dlPOD1HdbQi3c1gFy7HlQ6BJQqhgtJ5S1b2Bp2tcvOOq6SMgaWMb0RGkhYHXExKfFT4Ro3zDrgySiZYeQb74J+lccf6jnMXZ+NQqXwALBygOQ6uhwpaV1PmTW6xD5gPtMp4PndEv9poF+egMLmzywa+URKL8QzbTndC3NgJrlQ8Ay4W9DKO2cgJ8xtmwH0TjA9IPFmGf5g5u2D6zbbP32tawZE4gIjCCU983wDiNBPec6lOSeFfoUaTYHuwD6MH7v1AZpTnb11NBImVHtNs+i3eL23Hk3ds9rVYGpr1ysnK//9O8c7dNoeqTYbvdl/q3EFIl/QpXRqvm9RQOfxqLkNRDz2U40w9kuWXyXom7ItSnP15VPzvqYonHn3aNUB8oEVcQ7hGUzfgocMbfd7ObocXmNjasWFrQqNcdPYlJSUQIbNhUeLYRSyF4IZYjhSQ/BVWT6qlfwVdCfK6+nYtECRB4WEFpJ9d9BWofe7In6JBrZQiHWJrd4c5R55SN/UNnUPi2bQ/GQhA8cqDZegdvRzbUmqpyVl/5q+ipVH3bHgstGdESJQWS2g6eCZRUK1r/XGnU9yPu8kFz7NTBbQ8n27eeTo4y13ihfEzJPVxiHeq4NXLRJgBuEg60Ovu7S1IdC4vEVt4G1y59I4p6h+Q/jxT+Oqy7Zi1P05CiIxSD77lnc4LGVndootPzioNt88AwYWp3cHLPpIS0fsSF0pQqwJ1T51YBuGYtQzWz6+Xw1x40iaGFh4HJaIi+Dh52ZWXjRJNPLBWq1puxvDstaPVK1J/7XNsuIDW7mXh06Oi9pNFSqT0YB9JX1DOZQn+Gzoeg4R/TOTi5HhOS5HecHqcr+ruxKvEstO9HMC+pKA48D1KTRS44pXXAQgt1lPxHTrK/j4in1KmKcdgxNqSpImR16eNbL45rb/S
 oiJzGGVH
 zTCyzFV6swNbD5HjxESkZ4sZlW7F5YiytgXm+7+HMCqNOJwAo5ZgTZ52ggkil5RTpc/dk9QO5Zu4oYNGhOWtMyMsa18e/zZbStYrF2+P8ldJ+oUeZGRyeAcFaR/jkUjDG6J3PKOkRRNgLjDq6kl4zZMouWYJ7vUlhKrbD2x8ANznq3nbM6nfDRPeMWTERpHpqAujI7VGgr57uHBg2kpER28dJNx+Bg1DU44YNZMlWliiKlJsnE+md7SMj6mDUeafCnBkr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Enze,

On Mon, 20 Jul 2026 21:06:42 +0800 Enze Li <lienze@kylinos.cn> wrote:

> The DAMON provides struct damon_addr_range for unified address range
> management.  However, the mtier sample still defines a local struct
> region_range and mixes its usage with struct damon_addr_range in
> damon_sample_mtier_build_ctx().

damon_addr_range is for DAMON core layer address system that uses 'unsigned
long' as the address type.  Because 'mtier' is dealing directly with physical
address, we use a dedicated struct for that purpose.  On 32bit systems having
more than 4 GiB memory, this may be necessary.

'mtier' doesn't really take care of the >4GiB 32bit system since it is simply
casting the 'phys_addr_t' addresses into 'unsigned long' addresses.  But it
might support it better in future, using the addr_unit parameter.

> 
> This patch removes the local struct region_range and changes the
> parameter type of nid_to_phys() to struct damon_addr_range.  It also
> gets rid of the now-redundant local variable and pass the address range
> directly to damon_set_regions().

So, I don't think this change is required as-is.  I don't really want to add
addr_unit support for >4GiB 32bit system, either, unless it turns out to be
really needed.  I'd like to keep sample modules as simple as possible.  If the
code was confusing you because it is anyway casting the types, adding a comment
explaining the rationale might be a better change, in my opinion.


Thanks,
SJ

[...]

