Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FA2FD609D7
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 19:36:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 463C96B0088; Tue, 16 Dec 2025 14:36:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 410686B0089; Tue, 16 Dec 2025 14:36:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D1AA6B008A; Tue, 16 Dec 2025 14:36:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1B9936B0088
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 14:36:23 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C4D5A13BA63
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 19:36:22 +0000 (UTC)
X-FDA: 84226340604.18.002ED64
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 31419C0007
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 19:36:20 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=lFRcUpua;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765913781; a=rsa-sha256;
	cv=none;
	b=a66EiBMYCdwfbKRx6/Uf5+0YIMf+7/ABjutUdL2gILooagr0a8kEgHtq5uFGDluITodqRO
	pwXizXPoURhVyEknaqISeW3uvUmIaKHuuT07i17ntVVwXZZulPt7haJ2U34tTqRzIhqljV
	SQz5esRaKrocnNxj2kChXxdFJN+L38w=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=lFRcUpua;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765913781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EeqJhfLbCmgkqUGXRcfhytzPy1KEY+34ix5Lr223P2U=;
	b=gyUfgv5i6VFonthHXPbp2Mw3mQiNvfqoq8guCXwE5KffqVU8t52dnRzQmnoBfgfWunS0F5
	AygeXPC/HVuDltKabz7XdLdy88diTRYOR4KeuxdW5AmhqCH9jwxQxyHRlvQ5TnaBUttmuj
	86P0K49yrlU8kvbKR/oOPlBf/ynMjW4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 02DF840B3D;
	Tue, 16 Dec 2025 19:36:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E4C8C4CEF1;
	Tue, 16 Dec 2025 19:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765913779;
	bh=2K26rkSUzZxc0jEUoJEjhk6f8rAR6pwlNtCTHpXwVzo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=lFRcUpuaa/yujv/rq5gyQ1Hov3D2+xFdJN5QtCQeKgCDD0/TJQHgvH6lgRVse3BhG
	 6fXEzyZwOrMrol1J00f7EIcmLaO0x3cfewrAFshWMcY3X/2m9HoKf4HbraxN5b2Icm
	 ychdAgwK4a73M8jZQb43hBTBJM2Yv2/FpWGJVphk=
Date: Tue, 16 Dec 2025 11:36:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Weilin Tong <tongweilin@linux.alibaba.com>, Hugh Dickins
 <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/shmem: add mTHP swpout fallback statistics in
 shmem_writeout()
Message-Id: <20251216113619.af93c4c37f8e880a14516a2f@linux-foundation.org>
In-Reply-To: <3c86d612-aab7-4e80-bc6a-3ccf2bab9c34@arm.com>
References: <20251215024632.250149-1-tongweilin@linux.alibaba.com>
	<3c86d612-aab7-4e80-bc6a-3ccf2bab9c34@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 31419C0007
X-Stat-Signature: oi7n3yzfb6r37gzsswaps5s9x5hm56sw
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765913780-382549
X-HE-Meta: U2FsdGVkX19ohquKL2zxTWTficq1QAyYdf3vaFBfOPysSe3NjxTK4iTA4xN7LFUb77QZeh336u+wJo3742AZV6HBCvZ9tCy8Etn7zwuedGgiDtl6V/5LCeXnL/FaUyZ1JdgF3rMIuE6cbSnpJTL0N/MbW9w3FcPEi+XBPSLM2c9a+XsC2lo3Ol3/5IAlLWqATnDWF/bMkh/V/jjhEve9CrU1SrM+vyotU2EfrCrbh7zoPWr9Ft9DxXXd1uFdjmLQT7YXUY7ISUDMoVcSVs0rnLvRcgaS/W8HrAlA2eeWb/xUOBaRNWUxJcqCHa+BFzQMlhLqujL0NufCYYdjdY/7igC9kpycu35IS5j8DszP80pCguPqIx9p1Ejj2ojdKJPJ3yVBTM2dKMBsRa1qyRly53LWLQYUvXowarlvRIkTJIIWzyzZKuSu/CwKBYBY7Zqix0SMz3QKFS9apofvpuNJxnYV+0flCk2+X1d+ICC2xer3du9jGJxOk4SeRW9iePA2guZctR/yRcFqevJo6s4aZaMYAbN5j1btrFl0E3VPvUI4InTAv/GnOWXhSL/wAE829kbcwXUkpPHPvQPib7xpJ++vvNWwvy0Vlf0xs30zyAlSE22+Bw0SN93b4PzT4VYHa0cstizuQbAznXToBSuxQkqckAmwyUJlLFzDYPhjaOdQ4QBdYSFC5LZA1TvnAqGX7QO7ziDSQjhC0WVEUVtKlmvDYTRIb0Z6UX8/Q1wG+gA/PUA/Zq/SEb2CfI7Yx98dvyp08xq/RI0zHeoYEDlDnhTDiNLZDtf+klv7k+RUbNeFpf9hd0uSPJJjAMpw/yrHPDoV6w5OKMLHjMDTU6zNvfnPY+z7uSDuJFBgrbIi4l489GEZakwlD4ac+4dmrHdxjc+FmRo0tokrM9OqnBLserRlc0gzx0zkVrkowbIOtVk1QOdJUozBrAq0+UaZVRwHiQ02yUfHj6c+h0I1TCO
 U9rupKLl
 HR8+vGrpL9HXmWjBRkzWAj5geVGjBTeZDb6tf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 16 Dec 2025 12:04:02 +0530 Anshuman Khandual <anshuman.khandual@arm.com> wrote:

> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -1593,11 +1593,23 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
> >  	}
> >  
> >  	if (split) {
> > +		int order;
> > +
> 
> Could this be moved up near the 'nr_pages' declaration instead ?

It could, but I think it's good practice to restrict the scope of
things to "no more than necessary"?

