Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E813EC61DD6
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 03:18:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C936B6B008A; Sat, 29 Aug 2026 23:18:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6AFE6B008C; Sat, 29 Aug 2026 23:18:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA8606B0092; Sat, 29 Aug 2026 23:18:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A27F76B008A
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 23:18:13 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 239E340246
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 03:18:13 +0000 (UTC)
X-FDA: 85156477266.01.5567D3F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5DDCFA0004
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 03:18:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Bb+SgGBx;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788059891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Rmogpoo8KWdLKv3l3rEZX6LosNLicNjBA0iv6MuuZE=;
	b=0wU+3vZksG4BTzAtl+O5xNO/YWxWPFmm76NI9tS9Y7OQvSLH43YEG+N+JhggkwQqANgPEb
	bWifLbEc8pwO4ivPzRdujXGa5aKwJ/lOPBTt/ML702yCfPct4S6SOtF7eHEUx9ie2reI+A
	aZM59nE4VE0pi3lK4pjgtAVy3VGMjUA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Bb+SgGBx;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788059891;
	b=i8LlQKD3rRdjkl6dFtl7k1Qi/bnX3uQnOOcRZjyV/sy3LZ/McMz4ja+I9Rdrn65Fm2sPg/
	F38hiKsc8gkecAOPzi6xHaqXgUPtPaiLBJp46HPkr7ucLqN3Ev5BwAZqV2AvT5VB/UrVZO
	xHWoRjPYCogpRzAuSgSSQ5GYHG9E+Pg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8CEC140428;
	Sun, 30 Aug 2026 03:18:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 086651F000E9;
	Sun, 30 Aug 2026 03:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788059890;
	bh=3Rmogpoo8KWdLKv3l3rEZX6LosNLicNjBA0iv6MuuZE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Bb+SgGBxOKzxMJ2kJ6B2tmna/h77lEJq+TVY7/5deiw0BvqpCeKG+jjrcRVjxtoVF
	 F2wddFdkB7QonU3Pc9ZBUjf3os4mZQsztwgZTSToGpjPo4gijc6VZG5K9jmG6bJsdT
	 szXBpJXopgU5Ajx0cOT4avtZeT6eH/jHDGqkETac=
Date: Sat, 29 Aug 2026 20:18:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: mawupeng <mawupeng1@huawei.com>
Cc: <liuye@kylinos.cn>, <hannes@cmpxchg.org>, <mhocko@kernel.org>,
 <david@kernel.org>, <ljs@kernel.org>, <hughd@google.com>,
 <mgorman@techsingularity.net>, <yang@os.amperecomputing.com>,
 <zhangqiuhao@huawei.com>, <wangkefeng.wang@huawei.com>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] mm: vmscan: fix scan overshoot and ineligible folio
 scanning
Message-Id: <20260829201809.99fe79c4725413bf80510fed@linux-foundation.org>
In-Reply-To: <f53b5d3a-9f16-460c-a7d7-a0f518c2f21d@huawei.com>
References: <20260811070849.1332165-1-mawupeng1@huawei.com>
	<20260811184241.e423b81c8a50d5f212af1c3b@linux-foundation.org>
	<ef7a72dc-fc5f-4b08-833c-05c4ab416605@huawei.com>
	<f53b5d3a-9f16-460c-a7d7-a0f518c2f21d@huawei.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5DDCFA0004
X-Stat-Signature: h6nniujhbhkneumc1dkikw1c1cmm9ttm
X-Rspam-User: 
X-HE-Tag: 1788059891-194482
X-HE-Meta: U2FsdGVkX187A9+nEpF+QfEIkA6Jc198/iyS3GVRWzl/KtZXvI2n6USdkG5emmcqpj9UjPNbRxHUjr7yz0ZtBRe1BGI3VXbk8xa93kfIBEnunalybCNaP0Md0fyn4l36ABwp45wdXd0YbzrXnytWr4ldiskNxxKoWAM0mqhwwF+ME4JQbWlWQFkBpUkld7TxuO9uO831ZWWX8TKGAwxvyxvignIIlj4BPydNNif+r+OlvwtueTCUORJXkrXNSO6DffMi7f5PKt+p1YdQB0mMa+XM9XtfeqnfO9dokH9512JzNQxepE5mOreBK15tHcKl0IuD3xm2AR+nCoYETeOd+deVUr4moqgbVuEMaeRDw2noLxCmyEJkr71qPP6qOHJjAGc/qw1AxVXTzZ/A9LZ219yreoH5usQ0+EU9mA5bgsVCOiTn1z5DhFj5y6iLJpM8bQ3jnBsMMJ4ajBrC5pR4X6GYt32V9L/38S0iRj0vbpZtmYYpDfRTbj2NuKCIdXm7ye6LFpzlZzLYhg46GWteIa8xdmFjVUMP6Qdkmm+XnOgi9jXRmuisl2pLRonqK6COAXUfmmRgD7q+e+sg9FH/qkRe9H7hVVasQbKhoI5HzDsFPyjwN1E2feB8qQzURw/mA0swMmmq0K3drutqnJWYa0RXgN39Jed91KTw3N4i6S83Y+antRuDSQp77xUSfRdZ3PlmNCyYSffxaxqvEa8MUSOH69Kmr7vaekNfe0J7XCGoiZIyolvHVTuHnz2d6CUAfgh/bhPowBMafOX9I0UqPS1IWyxq3ezmT5cWquAoR4ukCXFgVwCGSBbBSLoFd14xVBaG1WsDaOMicij3kmhOSaJofnzeuz0kWh4Bs8GZNSM2kWqFovCK27+1rMvtILwInZEBZLR1vOZBUjXYxcIGwSk9SRhDuYn1zvjy43oFSoLYxdUWhMg4ofRbTedJIU0UiLbIddYDhSW57/D2AZw
 jhIqQ7AH
 G7ZuP9QcHbVJH7yGcb5H3v8y9DwKXvF6POCWNNwJmsWrrkLHiAEZ6A4ap/gaZYPt1QJxrxEhntTMFjXHafUUCIWfOCYMyrPjkAZ2theLUb5VY0YqTNIT7b9YeL4YdN78gZlQzpJuSZVpwYB99vqhl0K3Vke8evdnjEiDb42VPMxeEBmkn9nq3aJ88J634Xf90iMgrHI551s2uoGl4zCQBD5Oyc3/Obs3CRg3bDxcrESLNundnlmlDdIeDKBAWuTHYndJgB/z04a3jxYEK1cwSEUNz2bjbaH0GafTVhwGsEcrEIhI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 25 Aug 2026 08:59:54 +0800 mawupeng <mawupeng1@huawei.com> wrote:

> Hi, maintainers
>   Kindly ping.

It's been quite a while.  It would be helpful to refresh/retest/resend,
please.

While doing this, please update the changelogging to help reviewers
understand the end-user impact of the issue.

Please also give some though to whether we should backport these fixes
into earlier kernels, with a cc:stable.  Given the unusual
circumstances which are required to hit this, I'm thinking "no", but
feel free to disagree!


