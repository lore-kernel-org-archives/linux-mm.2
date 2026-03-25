Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66573109C057
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 19:15:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD42C6B0089; Wed, 25 Mar 2026 15:15:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BABEB6B008A; Wed, 25 Mar 2026 15:15:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC1E06B008C; Wed, 25 Mar 2026 15:15:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9D6016B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:15:53 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F2AD4C32F1
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 19:15:52 +0000 (UTC)
X-FDA: 84585540144.12.1C17174
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4F47618000C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 19:15:51 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mXG8lv54;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mXG8lv54;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774466151; a=rsa-sha256;
	cv=none;
	b=gUzB14jritwJsrPkinc3LCdhAiUGWOuHUmYino3y5GihP7h+SOKnQf9hPLw5xTFpNYJfkf
	MqT88G8t0TxOBUavuNmx8Z9Ts44ZWI3Kynd14d71Hrp1gA07Nr2avqiTxgUvnHpF3LdLTP
	hdgNFA9Rg68sYTEzs09P+0OLZxATUgM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774466151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7u6H+oRuirJi4lWes2+fbruWqGGl8TIEYgMbiVOrd8g=;
	b=Z7RyKtb5HHvUVEZindVj+I7xUJPBGfQZNuGKvRkBnzpnvkHEvlKgCU75d9NLBqJlUSpUsC
	nH6qph/IdnMyqUdtjrhV7czQf60cCqOUbGNX0lKhmFQorhebxgdQutABr3DvvuTtwrR+dX
	KomjD3jIuiMSlWoqd4wy2zoFgrRIQb4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B3E1460053;
	Wed, 25 Mar 2026 19:15:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D5F5C2BC9E;
	Wed, 25 Mar 2026 19:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774466150;
	bh=WgV5itUbMScFnVYRiBUqTFqjA/vAu0irE/RDNqR82bw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=mXG8lv54J8Q6XmPk3LXTPOG3VI8V/rho1NeKuZ9CpnskLZfdfF3PkLgkwR/c/zRWM
	 OeZqaFvcDAdLdyS6DPoSj8K8NSUQLJUvO4K4Bt4IVnUA3smAiqk1ayfS8BgU2kYEJ0
	 7FQ6ORJNyyrzP1LlZuxCfnNCgh2rbVvZNFmhbWXQ=
Date: Wed, 25 Mar 2026 12:15:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Vernon Yang
 <vernon2gm@gmail.com>, Wei Yang <richard.weiyang@gmail.com>,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH mm-new v8 2/4] mm: khugepaged: refine scan progress
 number
Message-Id: <20260325121549.2b887a8a8c154d5bf8529ea9@linux-foundation.org>
In-Reply-To: <bddac979-24d2-441e-9c5e-529ca2f58366@lucifer.local>
References: <8a5277e0-d70e-4849-9763-ed90e350a118@kernel.org>
	<CACZaFFPfx=y5Fy+nwT8o8TA=W0QBfOvTqbJnhVPn8B95SFxijg@mail.gmail.com>
	<22dccc17-787c-448e-a571-23c7a9afeaff@lucifer.local>
	<20260325080930.a205fca9e7e61c4a793f5228@linux-foundation.org>
	<3cf94628-3c6a-43ed-9fc1-29bd5a911497@kernel.org>
	<8d2e809c-e4c8-4d35-a2ae-62777b6dfbcc@lucifer.local>
	<0437ad42-612e-461f-906d-6757eb19a8de@kernel.org>
	<20260325091735.bf440358cf83c5d0369e0674@linux-foundation.org>
	<06c83e1b-d7ee-48d5-a5c4-faad39db2f53@lucifer.local>
	<20260325113650.fc6997e07a0a4ad0e46278d5@linux-foundation.org>
	<bddac979-24d2-441e-9c5e-529ca2f58366@lucifer.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4F47618000C
X-Stat-Signature: faob93n1193wc193wqbh7gfaapsfakdw
X-Rspam-User: 
X-HE-Tag: 1774466151-147869
X-HE-Meta: U2FsdGVkX1+Ppd/L0VLwJ/4luy2Uv804R+upPq8/y9TNQu8b7PuFWpSLYIAufBNVis1SSi+8k2ldYFW8+xWgrAOh3Ioxldw4jlI5Mz49rJXfRL+g23pEw9GHPGzuhzq6HthGKal5zxVdZUJTDPL9Ib+2oWCZZ+FIH8R/tvb2CJlkbVESUaKwHXFhrwQ351MS6hm0w4yetqyD6SiPA2xDaFEO5XgrWHOOqv01Lu+e1Mb2eWyY6yUeJd+yfTTHgf0nBaiRC4g306B8AfR/HxGBGVo70w3MvCEloiBxs+IWiMzRjjdQ0pmxk/HPDHXyr0aPcsTcW0EobHRl1tktexTt1cuGDrQyBc8Ib2Ysq9ZIKfMsA68eFiiDY8I1j0Z/GOg/ohZqO0+tO5P9vj/X37+9Qx5L+zxvalg2c0k4Y/HBcPOJ4EOEcSrAFONR1KF/CMVoc2X0G1c0usdqCl/O3DLWaN0dU5MnLkkC9m0uPoex4gK6yulV1yY48socmbBEckUIvoprneCDfyz6J1yGzj4ToojfcajAcdnuiIX6pghAorKabbAMt26v3U1ce49a3AaGNo2bn2fofxqv2odHmgX5+xeF/icCIfxacAUmgWLQvHhv/q5TXPKubpywnBOooRg6mOxEF8iLhTDG6pqgQcqOoPtsKmgCLUM1xN+EpFcsMtHrvThd2CUXIuQpSnAXFR3N7gjYa6gvTfMXd8wpldca6v/Ny4NmBAhbuB4M/EuHA0BPjFQOpWsfGE8stx4TQ7ZJJyCjlQ/y3Jr9XsDoTfHh1uJbw2pbx5q6UipFG9b81ztUhj5VMTONy4jC9AdLJmJwQoUY9vctcHf2hBasZPbTl+lQeGCTvL2yZE98oMkKk0Vpm++J9QkEHl9zSp9lSEJM5nJmnW0UCydIguVSsfHUGdXqA6bbo0bdGBWHE1AYzIHMwzi42kpKerW+go5XqRYE74ZWi56vhJjNTDUK3rZ
 jXgAkUWZ
 Lw2Sim4MXQsx6mYrjbipvTwPPdt+psEmXOZjSdLxvGP8qYJtRR+pAqYPyRpaIw/fV7P+ojSyyJ+bYLIfaU+qhrmtduF80rCFoNcLtynjQJ7FdoeT7y0hy5JKx4wjZZmIiwiYNC+qqa9QOKSs37gQINRcx37olBQvWOZ/j/PqUw38SDCyheQ8ifDvJUw/2pGayRlYAknOnrEcck3+TVm2PD+WoQeEMbSmb+wvb0U9nToXPtxBitdtJukbxfVuR/F6cQoeEMrxWGWKVw/6a/w7HBRP8tFPMi2EMCDx3BFKNJoEjZ4v6ZNDmuSBFik06iYP5sXv5ITqXnDByyvJ7SwJwBcBGqsTP/JJqKpwZ1hdcHt8HMpPw6BLBz68hMfiaOxa+xa2M7KjoO8Vxa2Zn+cCow0HGN40T1/f7O86moCgLEdhzKXmLw5uc2keDV6Cfdo8wt+FF1y+z3ZbalkSX9bktrgplOXRJhLRXuoyhOJqa+F+T3lU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Mar 2026 18:53:40 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> > [akpm@linux-foundation.org: fix spello, add comment]
> > Link: https://lkml.kernel.org/r/20260220151500.13585-1-rioo.tsukatsukii@gmail.com
> > Signed-off-by: Rio <rioo.tsukatsukii@gmail.com>
> > Cc: Joel Granados <joel.granados@kernel.org>
> > Cc: Petr Mladek <pmladek@suse.com>
> > Cc: Wang Jinchao <wangjinchao600@gmail.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> >
> > But these things are usually quite minor and the precipitating
> > discussion can be found by reading the main Link:.
> >
> > > Maybe just directly squash the commits?
> >
> > Not understanding this proposal?
> 
> I mean instead of having a separate commit for the fix, put that fix into the
> patch before it and denote it with a footer as you put above.
> 
> I guess that translates to what you do when you rebase and fold the fixes into
> commits as you do now anyway.
> 
> I don't see any reason not to do that right away, as really it's good to see the
> combined change in one go for all practical purposes (if I resend, I'll be
> combining work, if I can grab it from the tree and avoid a git rebase -i all the
> better).

OK.  So what have we concluded here?

Is it: if I get a -fix, I add that in the usual way, then temporarily
fold it into the base patch and mail the result out for fyi.  Then
after <period> I permanently fold the fix into the base and add the
footer?

If so, what's <period>?

