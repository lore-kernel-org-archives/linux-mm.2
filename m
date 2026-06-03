Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDD4ECD6E57
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 18:23:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED9606B00B1; Wed,  3 Jun 2026 14:23:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8A1C6B00B3; Wed,  3 Jun 2026 14:23:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA0096B00B5; Wed,  3 Jun 2026 14:23:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C65DB6B00B1
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 14:23:45 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 70FB1162DC4
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 18:23:45 +0000 (UTC)
X-FDA: 84839424810.18.C27856D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 907D1100004
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 18:23:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EHqJlmRx;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780511023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XaS4Z/cDlFhn664QfkkC4ehdFJgpU2L+6N9wuaksiC0=;
	b=V0U1zKvDTqPbXDgW726Gosz2Ne7KiOjjcnYjT3uUQDtQLTO/1lfuVHEojuEpkGPHqvb/s9
	ZRRxwxINLp00oak3ZXKKxQYsbONYomZ0itU2pKCQHS+5NhWemmwhPgHS3oGpJwKdbgaUqD
	pLmscGzPZnubu5QJSwkgojq8bAMOR6A=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EHqJlmRx;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780511023;
	b=kaF5tClMgrb8jV9/tMSu6QCNKK+PbNI7knXXk1YeVGmAl6KOqan3C/PNDWJqCN7ct5e8GZ
	X2Oxpvok+Ko6/KiHKnR13mg/Im6qu3wDGAURZt5YbKeI6vv0qKw9EY08YvyZTGBXnHPS/O
	lyExIvptlAiAf6CeosBKf8RVp3lm5ks=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B6A0440499;
	Wed,  3 Jun 2026 18:23:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14C971F00893;
	Wed,  3 Jun 2026 18:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780511022;
	bh=XaS4Z/cDlFhn664QfkkC4ehdFJgpU2L+6N9wuaksiC0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=EHqJlmRxS9TnC0oeUTgnlP4CIOiUGgmKgro752fBbGmgXzWoL24MK6lmqjI/6wXvJ
	 ZO4n/zU80CfBeFdXK68SZNPgk7lpMXjRDzccvWusxFrN3Ck5VwzzfqffqB9fS+gRB2
	 ngm7NGjiLKL2JjAzAcL5Zix82etOfUbykzi2FH2g=
Date: Wed, 3 Jun 2026 11:23:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>, Pedro Falcato <pfalcato@suse.de>,
 stable@vger.kernel.org, jannh@google.com, liam@infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, vbabka@kernel.org,
 chrisl@kernel.org, kasong@tencent.com, baoquan.he@linux.dev,
 youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, kas@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/mincore: handle non-swap entries before !CONFIG_SWAP
 guard
Message-Id: <20260603112341.1d1355a1e1e3a656665a9192@linux-foundation.org>
In-Reply-To: <aiAYt2pNBVAIBaFg@lucifer>
References: <20260602172247.279421-1-usama.arif@linux.dev>
	<ah8XqXQycZdbYFG9@pedro-suse.lan>
	<bcf95603-a04b-489e-8edf-b6bc4a42192c@linux.dev>
	<aiAYt2pNBVAIBaFg@lucifer>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: gbbd3aspkjb15gecxk89rxc1cg448xpq
X-Rspamd-Queue-Id: 907D1100004
X-HE-Tag: 1780511023-225247
X-HE-Meta: U2FsdGVkX18xCSyFz9AAOLKBSC016lrAIsvPHrPom7dx3WmCJfMFX6PakURooz+Xr7qKOJmEMcAirng5jGwwcWs0zcq7vgLdIq5HpccTk5R+07NeF6Mff911fNDBU6PZ0m5KaHR2bUaaDH8CAPDeA9SpJZy87UgQYukWVfPuarYPN7VN70W12fpTf8e4w8Ga13cZ1zHi2U3KJG1/vMEhRR8KWp1jHJ1JWs+/79fB5fBrYQTi8zkG2tca/5W/Aaq+wpIeUHJ793tuX1wPI2eWW9jA+nRTc6eXfoMSCaCrCGMpzqw/llIeWGaTZyaIDeo1ZYRwxLaI5KdUTaKTuneawJvaX3TXpZAiJxUEJnCcH6UOvKJCUYlxCCml6FWswBINC6cfcSVuKFnYRVGpAartK9Rr1Ka/Ro4DePW6TQlYfnTwJVQMI/mclfUbs9N90UrYJVEWzpCiONiePWdhBFr5RCuKFugniGGf8N+jb0573i9nfh13H+4IVnzuawr1A5Ai/6BXH+ODMFpP9jtmtNgMsDTNEg6T6vym6iF7TALUCPrnGmrXW5tj6Hv4jDJnXzkLg6T2AlTAXaGYPwb0EGPpQOieKgwZ1eNdXLnvV7Sn6ueU4mdZUcYnWc1ucEvTydyto7Yv/e2Koy9VLyGMqKfC4vokCNFDVfLbSuBI/1KV7ggAFXLx03ldk+npDumdzzYdNGD0lGij3HR3jIqqAKG1NSHqRMhXNuAIBuEEDwgegawgAYJBGQsYsGJOe8UREUC+vXqBLaY1KUFrOBjKt5ISZhKxsttMrNsOw01Y7qP+HkXTSxclXiv4ZDoiKRPMu8ab9PvzhuFKqe/4+yWGsx1UKzlGhErnoooXGFZ3SJioMzAogV7jo1ChBM/YKPZ77EWe1ynAirP/UB2dwU6phxtL/z0D4c56xnVJJxF6K8KvbrxLg+AlsK+OecCNDqkCpDgmLo+38o9ZxP5ulJ8UDmp
 XEOCknYD
 rv2FlyC9noBer59tDUscJcXiQRZZCyqOg9hX9ph42GzcegpL04t8MTH88Mgh4TllmADrEchyPtx2+IMqqbY5hk6Po0VlRYmUZb7qfivTc1O6rKRRVZRNS6KhQkIk2modS9zums3Y9FHmlT1jfGDyn761MBRKjXvPsuZ/v5PHiD/Lct2qlnigEREQSzj7+/BWPkwwalMO04lqQFnPXXbNpBvEKkCFZIltI4487UegunrPG2oaxC4vuq6RDtJx+u45nTruRp72Ba1o76Bp1R9zLVF9OM7dx21NCmGuDWWFdi1+Iu4cuCUN3hGW+5LlB6A++ZgDrfuiDLx8HMPQt+yoB0qtbiFFB3u2HjSoaALQ9rruV1QiZm5L2D6yVWFd6paWQvVVvsSBsN/2Wkh4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 3 Jun 2026 13:07:04 +0100 Lorenzo Stoakes <ljs@kernel.org> wrote:

> > >> Fixes: 1f2052755c15 ("mm/mincore: use a helper for checking the swap cache")
> > >> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> > >
> > > LGTM, thanks!
> > >
> > > Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> > >
> > > Maybe Cc: stable@kernel.org ?
> > >
> >
> > Ah yes, I have cc-ed stable in the reply to this email, but probably that
> > is not enough?
> 
> Yeah I think a Cc: in the body is required,

It's required for MM patches because we've asked the -stable
maintainers to not auto-pick everything which has a Fixes:.

> but then again Andrew does add Cc's
> for Cc'd parties so maybe it'll be automagically sorted out.

cc:stable management is all manual here.

> Andrew - probably we're good here but just checking to be sure?

Yep, I'd added it thanks.  But please always do check!

