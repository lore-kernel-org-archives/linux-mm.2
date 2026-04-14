Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34CBBF9D0F6
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 23:29:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69E3D6B0088; Tue, 14 Apr 2026 19:29:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64EDA6B0089; Tue, 14 Apr 2026 19:29:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 564906B0092; Tue, 14 Apr 2026 19:29:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 486086B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 19:29:10 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E2B23B7803
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 23:29:09 +0000 (UTC)
X-FDA: 84658754418.17.3011761
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 599F3140002
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 23:29:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g4uizB50;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776209348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PB1ZrnX1wzcdV4SqB2hSk+Rpdz0bGVbCMYiVJYC88mc=;
	b=LPDI+HbLXZ8yPK6RLqe1ApZVtqRY2XGpAEX51BFLf2NXzuIuDULbnDHfkqG5JBNjXZyDs+
	FtbeHVl66w7WrDt10VNRiUlAftj8hk1VIFs7WgNv/ssbJOHzHVzV3QXEGx38FmIBs4S3Xi
	B5NVh6LjODb5CD9UIDiCXNCV5q9JFVw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g4uizB50;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776209348; a=rsa-sha256;
	cv=none;
	b=Q74wFdTLai5Krp89Gn94IInfh8U5yNAN7utTERWxsFrhggRXwQtrIzhn8o3ytN47iFWh25
	bdHEcVhJp+KkrVZhw1N3+54xj8A+aB3d2F9n9OVGyQGq0biLtYXYqUdaJYyoi0K4bZyc/G
	7lqlHTuCCnHnfhU5L0VI05Yf5MLZtLo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A6F2960018;
	Tue, 14 Apr 2026 23:29:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07234C19425;
	Tue, 14 Apr 2026 23:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776209347;
	bh=QfX+V1cAThBrIvA4drqcN16V2A/xpxvUcCAxE9nKwEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g4uizB50aarC3jb24UXF+kP3viMzz2i/OCRUF1r5KS1P6vHD7QwqrT0BB9EG8+9Lc
	 3SlCZ5JdcqQOWY9AKdpqeBeMASttzItn6ffdMR3eyMnxeXgXYkKo05PYHKIx7bDdWP
	 8tDxCv2xYy85YgGgM83wRsV+nRIwYg6Fcw/UpBx+k31Is4AxN8Bn9FsSHx983VlQWB
	 xo6rFmdXZAhJerXvbwkEwaZbPfTBSXSDQiYtjmXvn549FKMBG/y0xXOMAKOGDGXzyK
	 2rfWZLIrpXj9x2hNoq/ncnLz0glHMtnili5BsaePK9sOqlpD1Cj+p/h3C3pFYEDfgN
	 LpXZF2hf1lAuA==
From: SeongJae Park <sj@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] MAINTAINERS: drop include/linux/liveupdate from LIVE UPDATE
Date: Tue, 14 Apr 2026 16:29:03 -0700
Message-ID: <20260414232903.97446-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260414121752.1912847-4-pratyush@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 599F3140002
X-Stat-Signature: zqaxrqccx3z9w91eb5mbfbnsus7g45cw
X-HE-Tag: 1776209348-476727
X-HE-Meta: U2FsdGVkX18i5y3jEJgWlz4VUkgMN8RKEwIFCYpXuoZH/Pc5TcGPFpNigfQA3vkTPuVTlE2obpRwfM+YOggorASzQjST2D8zXsdt6Drb3vQtQ9xXaOcFmPwYmkeYJmSgL2CcbDvKM1jl1dBL2SsyV+fO/yXuwCqbTBxGZKEMHx/Q5v6w6frZpezJmPpZsqXc156WA/60yglz1PG9ETs7wXJao8XSbcUlt3XoRPm7zgS9agX7GJRX7rk3xldLzPYtUNXtyvXeWbocQxaoy9owzs7oyOatFvL3MWPHFT1N/98RTYF+3tQzShUpOO9uLkgnyHMZ6amrEKmiMxnGMpcBmnpIyq+qNyGe83dsiICNLZBsuECfpZuo7skrEEbH9y05uDEbskXM2LuuEGFeRmNjC1GT4ahcotYvqSUgDEK//P4yM72fzfHjAGQd8DvSIF0TgaAswzBYkczyr66YzIj6Lxr5z/PhAW4H2tVA6hT1z7MNRmZUuVh0/Z9FUQVKm7Vp3iGcKMFAis5cRSJZZWlrO/EbqmhPV71o6dqTBXwc9Ia5x/7ncM89hcSNDyW82nIVHjFaqG2RsM1G5+i0uAeYKbsClEwDmnHbUsN8RklNvTGfbEphDyoYsWnarkVx0s5l+w3tkFVJIdcWTVfbjcP/dju1ZGwP33/prFKePjjdHJzeQKBjNU8uvbp25H9CTZOhyVJm+3d7hyuWWaU3cZgphxOPG5NPqdv8P1JdOVSE+5We82ZmbjrR0rGWSrAdEFByKYVm3KsylAhZL0q2JHYcCrG+r9mVUWhOg7tGFX50ifqldS01RjSSFNULV1mdk8KH8HStLncWTzI5v02qkzFvwXpL64sQ7v7JDc85FYfrreeQ4TA146n1lw33UmYqNoz14ZHaDWx5qugE6uZCGo4pkilO0f2/xOW385hzS4snigFD+n1yYgIQsolKVR/oeY8CVfsWJqdeImTl3rPdvD5
 RD4M6Bzz
 IvFPWCxaF/tTlVR+wV0XSdgdknSqhLsf5lxMVkSApqz5qU8kgY73zimjGdaWbTLG+wHsR0Rnf5Y5H0l6t6X//NrPqxcPbUkm5CEsl+2rKtfXBVVzixFAHCjPbtjpzCUOxyK6ozgMtu2VrnMw7lkOhzWmfTd0hnvtfmA2pGngaC3GAPDVmRw24jNSgvy181yAcIwDXOrQ8DoPz1db/+EMM79Qz8+LlxnyBZtmOYWMOzdJXZZMT2EvRMhJHkqJxYG6Y0NunwB3p73sKgbw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Apr 2026 12:17:20 +0000 Pratyush Yadav <pratyush@kernel.org> wrote:

> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> The directory does not exist any more.

This gives me an impression that it existed before, but from a time it was
removed but MAINTAINERS file was not appropriately updated.  But seems it
didn't exist in the mainline at all.

    $ git log v7.0 -- include/linux/liveupdate
    $

How about making the fact clarified?

> 
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>

Other than the above trivial one,

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

