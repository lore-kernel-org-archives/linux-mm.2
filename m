Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 272F9CA9EC5
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 00:46:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DDB36B0088; Mon, 12 Oct 2026 20:46:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98E966B008A; Mon, 12 Oct 2026 20:46:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A4626B008C; Mon, 12 Oct 2026 20:46:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5CAB46B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 20:46:38 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C4FFAA0996
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 00:46:37 +0000 (UTC)
X-FDA: 85315762434.26.A983D41
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3F162100006
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 00:46:35 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Syu1u2hR;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791852395;
	b=XIEoDU65MA9+h1EMtdHwaxHBC4ZMdC2rVP+Dpz0P2jZGU+MJqHonyHHEbLE3UnkWiJkmaz
	qq6Qac8vRjiu24BjSClyglC9vl25nbr2kapFDptxc2s6imcindah28YWMNPqeyfSnKnlB8
	NZtjNGfcB+cY0qvE7G5iRwvzI+D8qqE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Syu1u2hR;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791852395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cEwon4gjp+x1MBe2eyFSDvJ62gG0hpSEQDYWtssky3s=;
	b=sOD3Mxwm9TdHF3KQ4jFXkvfktgrjGO0LbqF6KHRPT8WZFMlAkVDdk+sGm7TAXJgwkxX14N
	vFeB95ybqqFF3a7vaNiyp7lC1W0+QcQZ5GDE29MaB//aNXi6tAHUXjhZg7EqPf/ykKSUn1
	yNt367vD6exK4SUw6V+CGn4yHbu8QqI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 989A9600D1;
	Tue, 13 Oct 2026 00:46:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B0101F0089B;
	Tue, 13 Oct 2026 00:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791852394;
	bh=cEwon4gjp+x1MBe2eyFSDvJ62gG0hpSEQDYWtssky3s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Syu1u2hRHcxGtl/rA3LH2AEggJGGZr8G9c9WGPSaSRPfWJtdcNmjPYueQROENPzGF
	 VvgqYqBttA/VA16gR3JcZ54njyWalkuoD4A5bn+9Cp0P3YRGfpV12sNX1Wgza37Jys
	 U4SPZ6QueYu7Fyl0LiGNrn5LS+5Jij0G13D6xQE4=
Date: Mon, 12 Oct 2026 17:46:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nickolai Zeldovich <nickolai@csail.mit.edu>
Cc: Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v1 0/3] ida: fix the allocation failure paths of
 ida_alloc_range()
Message-Id: <20261012174633.6a86cf6ab068f3c1eff94fb3@linux-foundation.org>
In-Reply-To: <20261013002703.773923-1-nickolai@csail.mit.edu>
References: <20261013002703.773923-1-nickolai@csail.mit.edu>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3F162100006
X-Rspam-User: 
X-Stat-Signature: sbk3mg4xu3r39ork1omnqfnis45ax9ms
X-HE-Tag: 1791852395-320435
X-HE-Meta: U2FsdGVkX199NS2bOmj+24YxOcZR2d05P85ksDnDJIRaxxSMCr9wsiq8DRfv/Ih7dBmUyAbw+yWExXNdmK8hAo7a84fAtvk8TwA4+u4iOBlgI/c/Zx64ziKMREMn447Uk/wnTrNJifv4br1wateQXX9pRx5thEmuM3pNTW8e2RBTrZ0nMWVaXK9pzpRIZ3uSFpr1XmGNQZH+T4R+G5NcptkiUhaCWOTZ5gji7eqri+N7H5YYY6NmX/ah1Szch5DNMDwRlbDXhIYicRYFuJMmVYcnbj8TsEVGKQuK0tiXeRJF1deKoIX4SyuIxvu6MK/Ci/P/LW62200Sw1S+UgKY2283i5+c+Z4YktlBnebPNGMRaJbp1O28h3w6Q9pJbStiDNMmBIqPtiqpkMkqyBpWuXfSkb07dktcGfN14Nn1MDUPESS/QTmwlir4BMMQEvb9S+lqeRjrNCehjKxqg6RHRnZyg8dlVHHt+j7TPE0LIKG9RNylKWYOtaNusj9ptBqdFoBR6T1Fv8Yj78YdSS8/pPeORiWcGXwd9zq0xBtY0tv60iptIp3xW5KvOCQh1HgQRt30VkFMelJuwRi41rF6IchtcxEXbekkUF7crD8GrT2sEZjb4XNwBVquPuamhrWeOXdeBUBhyWVRiDHS5cii42rH8lGHCMsZm4a66ioW7RSfoxVj+nqwZ9xRO0/HtLaNEH1W5mvC10iZYBrjnLxDGnEk45CdXV2XLnGcv/3v22CDTMSaQ5Ob8DVEQCvzcf0ag21eJ4uaKbu9vX/aSsV91VML7WtblKashXY40c72iPJC36K4L24mEWflsyhg/jaAbjr2A0q6EImQbydGqcnyMz1VM7uMW/HdrckhoiAPk3yImdjlmH1NIvNpinrzrjPZEuipSleu4kV7Pp93yUrjoElDZPgKRdr08OloKKEHslxlw6pouUl1xTG1z17yG/9M0Ik37UIyyXd+MVYCaM+
 D+BEhCTh
 ZRK7SEjl30z0M8x4K8oaUNTqIuxxlVNu38H4r7djzlt1tiCsjyxjPos7AcfaOF+UmIwqpA2nuHvIrlcXc6Tff1YXQW3ZnZ3jt0j3R2NuCgcKPag3wsbRPYju3mpVysb/f+G0D98qACFRqJtbQwhhtSXl/Cja4C1br4hMJATzJAcWzMqtXZlKGrinhlUXykmb+liVtnJOHKdnXPTLTG9raIIib+9+MdluS8qn7NKYTqrTlxe0a00IyjhRbd85HvjR1Cogd4QdHrvMFkdC4y0Q1BTG6sJk0Hyyv9EZCkrqI3hEg5Uo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 12 Oct 2026 20:27:00 -0400 Nickolai Zeldovich <nickolai@csail.mit.edu> wrote:

> These three patches fix what ida_alloc_range() does when its xas_store()
> fails for want of a node, found while formally verifying the function
> against the kernel binary, where its resource accounting could not be
> established against the code as it is.

Please teach your LLM about the first 32 lines of
Documentation/process/stable-kernel-rules.rst.  Seriously.

Please also tell it that when fixing a bug, it should fully describe
the userspace-visible runtime effects of that bug, especially when
proposing a -stable backport.

Thanks. 

