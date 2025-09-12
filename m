Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5484CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 17:11:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C38188E000A; Fri, 12 Sep 2025 13:11:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0F8F8E0002; Fri, 12 Sep 2025 13:11:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4CD78E000A; Fri, 12 Sep 2025 13:11:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9E0AD8E0002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 13:11:39 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5A39F1DF815
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 17:11:39 +0000 (UTC)
X-FDA: 83881239918.15.1A278B1
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7A339C0005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 17:11:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ClJw3EoD;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757697097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fprCWGn72VE9DuQaJWojr/ZxTVZimbI5m22jocZ+qDU=;
	b=I8F61LZTIGT2o8QrAWa4Tc+yEpDnYBF8aTpEYv8q6nIPW3oUOyf5FvzCG3nBleNn75IQn1
	5NGhwZmrvmCHLTGON3pszpYIZI6r2Ww7g0+m4TmmePRPA1tesUD8gBdiEaS+72kSImBq4V
	MRlkJKgW69AuQKMeP5SSgFTbiWYnZmc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757697097; a=rsa-sha256;
	cv=none;
	b=p4J/bEqvxOyQe+rVUbco304qXFwBVaTOHat+4LWmt6YuJ7U3lm9dtvGCidmQNvY1o23gr9
	G1mk3irB6cycmJbWPMc2xCIsQT4Pj6Hxxj4QMClMrBcQs8p/BzNP9DqSz/3wCSKnDvYKi0
	n8ZyrD4907CCzgUp0Dzt4ETvqo8Gqvc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ClJw3EoD;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Fri, 12 Sep 2025 10:11:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757697092;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fprCWGn72VE9DuQaJWojr/ZxTVZimbI5m22jocZ+qDU=;
	b=ClJw3EoDyXV0Db4RAP6KAaSaVee5vTxBuC9Xd1u/SBoRtBYB95Y0Y7PdoN3blzQ1jXpx9A
	WSxQTHeXiSloZevivPW7hITq9jvrmG1tdtHMcg368eaBRS83/WruYXKDrz6qH4coIBHgHe
	zwaAcjCgzjbD8Qcjp1zz8qEP4V6TuZs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, vbabka@suse.cz, 
	harry.yoo@oracle.com, mhocko@suse.com, bigeasy@linutronix.de, andrii@kernel.org, 
	memxor@gmail.com, akpm@linux-foundation.org, peterz@infradead.org, 
	rostedt@goodmis.org, hannes@cmpxchg.org
Subject: Re: [PATCH slab v5 2/6] mm: Allow GFP_ACCOUNT to be used in
 alloc_pages_nolock().
Message-ID: <2kaahuvnmke2bj27cu4tu3sr5ezeohra56btxj2iu4ijof5dim@thdwhzjjqzgd>
References: <20250909010007.1660-1-alexei.starovoitov@gmail.com>
 <20250909010007.1660-3-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909010007.1660-3-alexei.starovoitov@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7A339C0005
X-Stat-Signature: zknzkutyrj5wwzspkst7ef8ub3hdbhze
X-Rspam-User: 
X-HE-Tag: 1757697097-528611
X-HE-Meta: U2FsdGVkX18Fc6dHv3JGdrAmzeXxScP6fiYH398JFjJUCsqpTi7plMOL6y59s1BZGwycktnd9ojhgeCnNo67rXJu6GejnFal9SdI6aHIOayYdeMhujBLCHfrIjDAtouLzE7l0z+N5E+TSZSAHkB6tiBzCllyro+6lW3m8QRhS3TvevXS82dRx54f0GE12D60xY4fMK8BiQ+3PrnVfxiOIxf5YlcVorLLisGJF1/up/SHrYnuEGxRhdo1DgB9oMq45Jvh4l1ACd4aLgl/o87xxUGpr51t/PtFcA9G/wurTKB2CLm96KJhYYR8HkIk/52xl8TMczsEpdvo1SmOdUuXvAWe4bDbEaTsCc3VyHabgQdmmtHOCwfSdNXuolJeHNQJzi6wTY3Ycx+ineeSSSLtmUoidHAWR2AaR9hn+xzxPeR3xsyaosBD/nJ/Q6ZXjgzzf16ow0GwWtXEifpQ/MPVZ8j3d+5cOgwHRgezFTfopX7XDoOu01SbBDoxHdPJFZGWZ95qZXRRNnaL/FyzFRgqkh7Tu5l9jGE3hwzAOoBAPx71WkxgeKafJv6M02Fhwb2B3FQxxulwl7Xy800/hLw9HE2o0V8Ot4T3BDsVC/+aYO3H1mOonC1zasbApFOT1n4TuVVV/54g7p8SFHERFpCnkEXnF9E+LQXgsY3c5SoqLpm4mtmL3ZPbe2x9X62m1F0TGf1OKi2IR4/hw47FralXV6oo0R5XIMccpfyjtG9ZU79pc1FIuHOep+ImWjAgwV/zrYNrvJUCRGb2SSmLfKWN+mkPx526f31rPKF5IBet8EBoLmvAnuFh6qsY3HSEIHowWDGdx79+o5Cr0iC1ASJJbfSb9eNJi9OXmvz8bnvPoJnjgSlpQCEDotAI646ZpfCpbK5F3GwJi6Nz4uCfIFtskq4KvXufMP6dq1SKoLiKH4p2lYkAkfGSBmv1xPqO+IFCY94leDD8c9NbDPVffPv
 PxKW/NgS
 Af6Ohymp/3esobyOjDJLWNMkwEa0XixOTPtFRJdgWfd/63sZK959FdRTpGRqgcKNSZxxas+HGJJ477dr8S2pMMSeb8IRhCnrJmrgVBGLRvg+OgbDN9iImrgxZMUSy/OEOJqC3jHt0qF6SfQz4qmFshFtrjqdV+d//UawPsM06CjT2Pp6q7tHAittKD6pv5AmDvFof6777i3f7fyHYX1pqRcporMmjY4I2y+nSFSfUpnns8ycyVFQ/kwE1cIDNeGkioa8GlFbYfOqUhMj0R+k2w9LPRMfyZNhzNj921p0dYoIa/zCTzrVApp8WX5Au1SMjmRHmsqGGYUc60ue236N4SriZ/vf0CVTRfaYJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 08, 2025 at 06:00:03PM -0700, Alexei Starovoitov wrote:
[...]
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index d1d037f97c5f..30ccff0283fd 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -7480,6 +7480,7 @@ static bool __free_unaccepted(struct page *page)
>  
>  /**
>   * alloc_pages_nolock - opportunistic reentrant allocation from any context
> + * @gfp_flags: GFP flags. Only __GFP_ACCOUNT allowed.

If only __GFP_ACCOUNT is allowed then why not use a 'bool account' in the
parameter and add __GFP_ACCOUNT if account is true?

>   * @nid: node to allocate from
>   * @order: allocation order size
>   *
> @@ -7493,7 +7494,7 @@ static bool __free_unaccepted(struct page *page)
>   * Return: allocated page or NULL on failure. NULL does not mean EBUSY or EAGAIN.
>   * It means ENOMEM. There is no reason to call it again and expect !NULL.
>   */

