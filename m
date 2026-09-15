Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2095DC88E7D
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 16:48:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD2CA6B0092; Tue, 15 Sep 2026 12:48:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C86226B0093; Tue, 15 Sep 2026 12:48:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B99676B0095; Tue, 15 Sep 2026 12:48:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 93E966B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:48:09 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BF25E1C2596
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 16:48:08 +0000 (UTC)
X-FDA: 85216579056.02.ABF61AB
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf19.hostedemail.com (Postfix) with ESMTP id 77AF81A0007
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 16:48:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=aIbYHpJG;
	spf=pass (imf19.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789490887;
	b=dKIDfWzBKN9j3/Vz3fH2VqYDTYASYihqWhM+MYY9dyHslDZOuo8rPTJmXdjqbQd68IUInb
	VqgMo9xqWZNA1956HtPhu0A8qmfJXlGbFX8NtD0Egkno6odEYoDr2yKnu9lLWRRFYdHFrz
	AZyUYQSMD8pX5g8UAlOpRpO/LwioFjk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=aIbYHpJG;
	spf=pass (imf19.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789490887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m/OpHS/VYS6UfWrtjjB6vKPQV7tSQbNLb+wW+QN6Edk=;
	b=JitUgCNzbPpaH3ryL4DQs4vEtXKBczvEpLAj3praxkyKLB2TMX6SyD75aamVz+IKmeqBrX
	FPOYxySgr70fEYDCIzSoLUIAf6O660f00FsjMmma/DFzGhzw8S1bbJsNSKtObKNjUDNtWh
	Wo3GWKJmwyFL5Mok1SQaQRViCxlSB4g=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=m/OpHS/VYS6UfWrtjjB6vKPQV7tSQbNLb+wW+QN6Edk=; b=aIbYHpJGCQkkbgGlUtWFgExpqj
	PJrQf4ZvK2dk0OZG+FgkzeZpqZ/cIaOmpgQRCq9sJGwaYqDShE5UTnQm3hnWk6dZt6YFqHXptJ1um
	a0WOZOTCRnbVD9Z78zMiyvQ7+eG8/9Rph3AbcAMlYLenreGSkMFDjho8Ky1c9ugprtbDwDm/OJbZB
	jNwXGVp49GmIOgAz4+8JQKNYyD5IgU5VW1mcwKrNzna64KWstzp8CUKEIM+hnVkVOlb40YRYEEHmw
	c4SHQZRydjemUgcObL8pU8VdTCn/aBOuLBH8UI+37skTt5HehLAmRK1OkDkhqXHNUOpS4HLH6RZEV
	o8BgDnaA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x6WK8-0000000Gg0s-3PXt;
	Tue, 15 Sep 2026 16:48:00 +0000
Date: Tue, 15 Sep 2026 17:48:00 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Longlong Xia <xialonglong2025@163.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Longlong Xia <xialonglong@kylinos.cn>,
	David Hildenbrand <david@kernel.org>, Xu Xin <xu.xin@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/14] mm/ksm: merge-path cleanups and folio conversion
Message-ID: <aql2wPergPKdfzU8@casper.infradead.org>
References: <20260915151236.5200-1-xialonglong2025@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915151236.5200-1-xialonglong2025@163.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 77AF81A0007
X-Stat-Signature: xsdnyeyewtx6tc1dbioqzzqudrqc4joq
X-HE-Tag: 1789490886-94781
X-HE-Meta: U2FsdGVkX18p1AN9cdZ9yC17Ew7MkPq4gSRfCc2/Zzbfte0rRRm0QzY2gZQhvyrXPrsqe9VG7ZTY4SDsQIJQ7G4z7xLkfUUKiM7fFYnwBg8e6uFiVOJLQR3eNMBUCJ7qv65ZZHKVYVUJtuvD7NypgzXE/+WJ/sFvXToNmw16eIcQeYR9Q47Vi9FJNCvE3wNbQaO5Z4y4WgsTabs6peZt3Fn0Fu/8i1aS9yVXU85PCFYOoFWEne0Jb5eeubDLanKYAgnDTC+QEmLFdA5Lgj40SXsJq3rOa/76ZlAjPamBBYERlD2P/c/48pm962BtFfD8avUaEskZq0hW57ClUwe6zwe2wJ9ndVcYX8zRw+SeJHv9lkRjJoI5mIq0MN/YZdiWI7v6wCOq7QLQepUuvbFsx9NCxSEkNp9AVidw5F7bLCrj5RvnS+tt91fSOaICyXPZiakxcuMEw5EqDEb+iPlx8R9znjZerHbVkj+qkeMCGUNy2aIcMUSh+Aer+DC0Qi7XDbDMhP2sDFqeKaUi2NBWAPfA5XWZ981FpQ6Vw9Xbe+FUp5P2OIoSeAB6Qcpoaqe6LnLu+Vy4pA/6U3jyLMezHmL4RTkof2rJJ7K7GKmpb1o10MqAt2nUp16XLBzvniyJoE9psEj+DFiYO4WOCSzEKbyuhCudMi+FJIu7rjHJ2GP2yR8z0FXupcb3fd2XGuwcycmzsuWOnZmUYz93cbXGYlCqCpO7Y0eE/gBu/5pN1G09P5JNGlx8vcPM608pUout62nmgNrnykXQDuXdg7TcSrH+4XWDywnYuxCGgnjDu/5WbEMWojihZMW77Jjf9bmBZ8YYXP/vTMo1aV7ieL44Nm/3o7pKkv8PPSGivEEQeWb7GpY9wfCRKJm2wcw0ugS+lmnfP4y3fBlenphJSS2l2vNpUzK7/WmOP8dB2x1+tH9A6+QqrD6hJPvFcjVh+T2tU1GB6h0JAHfIz6Mclk9
 qr9iqXiZ
 BcHG4GWgQNgAlDNC2HvDwPwnI65odAAoCfz8z8QdyMELEa4czpJ0yZHGLGRvC5Ke2tPFw+huN+KJWMlukPA0SC0MSQm3Lxe2Bm0gH4yy97quMlrfKg2+KzljOk/QR32dP14jq4I073tX4jcme0WQdsWBNV7tgQhyImxEcifyGwbG8MuF0Aofpk2uhJz0Hx0gBaDhAkwJSc95Ip2kE6q5T9WSy8vakMx2QJl/LFW74XM6kgQbaTqiI2Icik+zVICprxkB/ELDKwLvjx0M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 11:12:14PM +0800, Longlong Xia wrote:
> From: Longlong Xia <xialonglong@kylinos.cn>
> 
> Clean up KSM's scan helpers, advisor naming and sysfs formatting, then
> pass folios through the merge path and update the related comments.

I'm not an expert in KSM, but it's not clear to me whether KSM should be
working in folios or pages.  That's why I stopped where I did, in the
hope that somebody with expertise would step in.  You have 17 commits
to Linux, one in KSM, so I'm not convinced you have relevant expertise.


