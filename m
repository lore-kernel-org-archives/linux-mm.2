Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97486CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 04:40:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBC208E00C1; Tue, 12 Aug 2025 00:40:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6D418E00BE; Tue, 12 Aug 2025 00:40:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D830E8E00C1; Tue, 12 Aug 2025 00:40:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C7A118E00BE
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 00:40:58 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1225113469B
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 04:40:58 +0000 (UTC)
X-FDA: 83766855396.13.2FE72DC
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf23.hostedemail.com (Postfix) with ESMTP id 87044140005
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 04:40:56 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VP10vn1P;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754973656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xuWqXu1j5ERMTUbZlDSMGgpz+9UO3OVHMD/JTziTBFA=;
	b=SJT918G9iptvV6lIcxPSjqlBItYhOrhtL1Hn94iRDvdAX13Bh4huEp5w0nlsevgfads+UP
	SsXWQ47ENcq1NDo5XuqCsf6/WxFa+M05oBcVlNYW996o0n01hjJSx8o12NgBIDRdjUoVWN
	c2hXU/9U3re7/SfMODjDhxE1KWJT1Uw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754973656; a=rsa-sha256;
	cv=none;
	b=cjOVWC5oZ3o7fB0qHVM4SdSaIrLNXadAWqfnk2cILTj4ydU9Qh/rN7DTeUPf/Gz9Uchv8u
	UEfBdriBxeFVCt7dQQQLEdqPWFy0IbAZfr71hIWiLpKKFyY6+SogQ0m/vJSRolWYaaC9Si
	JF/3DqCDR8CcaDGV7Gcmap/YSCC4vtY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VP10vn1P;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 335D65C614F;
	Tue, 12 Aug 2025 04:40:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C63C4CEF0;
	Tue, 12 Aug 2025 04:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754973654;
	bh=SgaMmRStB2UhLZxqv6pMOrDE29SweSzVbjPPDpPgtmU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=VP10vn1P+011ti+EqhXQwSG+r/eDBHvTGGQb2lyZrJ45ld3lf3nd4OKR/XGiAXZ/6
	 IlokcWfYSlDDqH4BC3sxL9fzWy7b50tGSGfjf3oN1aMOiD809wR5h3wDZXIeOWb70a
	 GDomZFuifwsQdEbCxMskLCTV5OpzCEEmO424GgdY=
Date: Mon, 11 Aug 2025 21:40:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@redhat.com>
Cc: Qingshuang Fu <fffsqian@163.com>, hannes@cmpxchg.org, mhocko@kernel.org,
 zhengqi.arch@bytedance.com, lorenzo.stoakes@oracle.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Qingshuang Fu <fuqingshuang@kylinos.cn>,
 Yuanchu Xie <yuanchu@google.com>, Axel Rasmussen <axelrasmussen@google.com>
Subject: Re: [PATCH] Fix the data type inconsistency issue of min (tier,
 MAX_CR_TIERS-1) in read_ctrl_pos
Message-Id: <20250811214053.857168fd35e70e73dee1583d@linux-foundation.org>
In-Reply-To: <91d72c49-22df-43ed-aeeb-0b93a9da3bfa@redhat.com>
References: <20250808072106.153449-1-fffsqian@163.com>
	<91d72c49-22df-43ed-aeeb-0b93a9da3bfa@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 87044140005
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: oxsbxsoqc1hprwfcojxxxja79b67zzd8
X-HE-Tag: 1754973656-276598
X-HE-Meta: U2FsdGVkX19XClbWOC1kK6lBmuU1qM0sI3DwQGhF6eu1RNu19QK/LbbLprom5wD5IkvuffVLIqr6P5hruu+WyZMmK3DIuSO0OvwX/b9w1CJvvIGLUwJ/N0IwXAsQW4ArN/O1WcY+aY1HjoxHW+3U8c0u0w6/MxhdYLSsnEXgCVt3H7lNH9rxQOZWnYTNQjJCWDUUwiZgzWzIvf0FlTgm42ctDxnyzwvbOkUsqKZ8j6dgQOFSX+jUW6YFCWyJxzF20hdtoPUY39Ef0tF3mXJgtAxfqTLGk+Gjln4GIYkV1y61axKpqWXUI4z1RsBE4j71EOE956+vmYXT/DSUTSkkN7SCesLsQHiHsz19QGmGQPplofE2MVACtwygKoMMdby8qwpo5p3bgRS1NSiDyYGzKXRzOW0aRPmgDGVEy2JKerQRXNZKkEc9cJRza2YEwnoQA+/0F+DpGvLUndDZlDshisDH99Xj/7SLWv+QadJFAiJn3k/EOTJl2hEvNiRj7/kQv1gvS4j6aP9eeum8xmrCjheP49uApWZCnFzBsrUVKHOqoru1tcjkE51fGMMXZfVMrAm1IXaQWqQs93PGNB/lR7Eey5PWbFYLFWXTHT2r4GSivpkXtkTEoeaVA4uQ9K0ABBYWwgZ3VZg5cDoT9BwDFhPksR+hIY3zwK1qvDpu3ndzEwRi6rHNr9r417Mpv89Sri96Xur6Y1M7BwWkVAZIzzuzowXwrvBpI50gmEqYW5U6WuPAhbIvu8fPj2wvag3vpGlGMdp2f1j8sokBT6ouXmbIPP8UvPxBDzUWNNqj5uqxwNdMo+YPxOWP0Iwvhsx4HDWrniwnLa7AClBDi3tx1uVz2FY1qcUTdUmQi7w5WW9DH6CCzjq0Cpwlpt/BffCE6RWGtv9vRip0qPMUvwK1Y3toNIc1bxV6fgLTdRitImWaRCMZZv4zr3CKtjMJrkIyw3O9I3N14RkRN0C0ZDD
 4t9wIqT5
 gC8+F
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 8 Aug 2025 09:35:19 +0200 David Hildenbrand <david@redhat.com> wrote:

> > 
> > Due to the fact that the tier data type in min (tier, MAX_CR_TIERS -1)
> > is int,but MAX_CR_TIERS is an unsigned type, directly using
> > the min function for comparison will result in an error:
> > from mm/vmscan.c:15:
> > mm/vmscan.c: In function ‘read_ctrl_pos’:
> > ./include/linux/build_bug.h:78:41: error: static assertion failed:
> > "min(tier, 4U - 1) signedness error, fix types or
> > consider umin() before min_t()"
> > And MAX_CR_TIERS is a macro definition defined as 4U,
> > so min_t can be used to convert it to int type before
> > performing the minimum value operation.
> > 
> 
> Please use empty lines to make the description easier to read. Also, I 
> think you can simplify this heavily.
> 
> We should add
> 
> Fixes: 37a260870f2c ("mm/mglru: rework type selection")

I'm not liking read_ctrl_pos() much.

Local variable `i' has the rottenest possible name.  In this case it is
a "tier", so let's call it that.  And its type should be unsigned.

But an incoming arg has that name.  Probably inappropriately.  I'm
suspecting that something like base_tier or start_tier would be more
descriptive.  Hard to tell, because read_ctrl_pos() forgot to get
documented.  And this arg should have unsigned type also.

(cc mglru maintainers, who have yet to reveal themselves in MAINTAINERS)

