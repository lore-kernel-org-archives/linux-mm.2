Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69E8AC55182
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 00:16:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A3F76B008A; Mon,  3 Aug 2026 20:16:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 354976B0092; Mon,  3 Aug 2026 20:16:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26A366B0093; Mon,  3 Aug 2026 20:16:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F28726B008A
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 20:16:18 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 70A541A0805
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 00:16:18 +0000 (UTC)
X-FDA: 85061670036.04.B899114
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id DFD2C1C0008
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 00:16:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UJzNbmEe;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785802576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t5xgPjpI/UQDoZyAQGTHxRjzYdVNuOzHrHoSVqYbckI=;
	b=I4mAKaKExcy2PH6+6+LVDHNzNtJp6dhwuc7JpHKuaNKGiT8BramsbeFKA0lT5br6ETMMW3
	DimMSOkcxqy+Y2K3qiPfvElsZ6a5Wgp9/azvqggqN7ZKWNzpw3/Trg08inEFM7XGk++jn8
	aGBYAX7zCr5eZfVlRKbrZck0FMK+aqk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UJzNbmEe;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785802576;
	b=KkBtVwKWOwd3p32oU5zkhTuXoAkeBQVWrAnjdolvZ6H329zJLojgDI3kS8ynzuec5Veg33
	+O5rRmhGBxEYM5/CXMasrxg8YeOJK29uEuLfd4M/sB1Mq1OUwC5LxZHtJUCvAzS8k+Jt1e
	dSGHVpMCrl7hKfChHOfe+mX6Qe3KO1Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 034E860A71;
	Tue,  4 Aug 2026 00:16:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 740231F000E9;
	Tue,  4 Aug 2026 00:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785802575;
	bh=t5xgPjpI/UQDoZyAQGTHxRjzYdVNuOzHrHoSVqYbckI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UJzNbmEeeLq43qV6kBBMJr5Oo4f9CafdPlTI4dY4IOHuhaCvzOmMo04AGfR+vI41d
	 6UWGY3DV51ODYf0A6r5VzvOSqqz512s6mvR1N0FNczMyH5ls+o/eBFFYSxHyw1CzhY
	 ZJJ30SpNRT48/Q2iDAHgAPh1v/wChK+rE2g+A+9kHra/pCKN++24jE0WmwnIZaM/vf
	 ln0ae3eUYnxC+EcyoE+erjIlvZPsV/EwkViNel7l9BNRH2Mm+QWd3xd+lSJz5u7lb/
	 b9OvoWSkEP4JjePZCXC2Bg2xU+8GmRR6DSfvCsvM+NAh7QndNzCsnL3YxCHxcJK96/
	 gdwt2Q6vffbAQ==
From: SJ Park <sj@kernel.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	stable@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 2/2] mm/damon/lru_sort: error out for >10000 active_mem_bp
Date: Mon,  3 Aug 2026 17:16:05 -0700
Message-ID: <20260804001605.88417-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260803155715.08868ca7@pumpkin>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DFD2C1C0008
X-Stat-Signature: 7ia4t371tzsoqbd4ic9x94rn198z8djz
X-HE-Tag: 1785802576-559673
X-HE-Meta: U2FsdGVkX1+PE2nCnS3PqoPMGVEC9wuqxxtyMyIRZBJwLeYukIk+64wuf+c+lgkl6c3Sn+cS9kEdSktWtN7b/v0Sxb6EqdoTBTtlF6wWRk7dnPK5tcQ5LAD4auo0ngKXmBCzbBnr/b5pmwd+E/fyJMriNFrQXA1lU3xaelM4jKeBYN7V5YmxnVaxco6h6kyMuyMB4UvLLBtt/sJCsdJadSjzXpWlPU/uZn4hGDR9MPAG//31Ck51OMTjfWW0O1eVx7fElj+m8CakcxLLa6psRm43ghByeLtiyySVpN6vK2WELBBtkIFvFaApWNXEchQoplJVcBwWD2vCwkUcr3fIvsfW6mM3YoX2IkKPSD6e4GkS6NOGxp19MoVSqPwlsiYmXQkRve0OHB4ZZKF0FecGmH6d6kDYBL0o9PXk8iiJy8pHx9EZ94SfDrxPP1uBudK689l8bMY6nMYB+2QfG+7418LJe/A0X8RF+34nw6v0KTBNpdrbSG1TRyXPHZuC79iUm052oCQfQYWQEXTDaqO6+cKiZqevhMJMF4xm1xpKE8REYDeU773riAYT3ehEcygUCIlJ4nTI/9D8emIHm8vTAFfe5jsCWRbq1F1mxLjuuXstWVhgkXqrstWkM6bcGynpRPT2dtNr0o48+1PDllFLoLPt5nc8HFx5gtFFzgEWPwqn+Y5V6YRWM4/7fFkOd7HMcr0toToyyrSYmpK4+DCpujT+jRA8iqg8+u1B47s1maB8akDo89A4zz25EZQuwen/WmQqPddHC8Xw+nTairn7HoaGitCHvl8bq8cZhYSPp2Vvsl+12wSf+OvKtyS3Rsp5w0ii+85WtxkEpgOWq/9+gvvJwKgowHZOL+zt6IXD/9o8WxKXL/8Yuf2e1tcEIw30LfCaXdoIvu9hT+YJko/cUDk02LPQB2TCvh7GPrsoMK9g1UAAATu295fqhRY/Bf2J+fF+8ebFaBnAZKEmlHK
 YF6KjmBX
 aDKJYuQrNxsflxbVsbjpP+osomo4ELO5mXmPiMZaizE6Hnhe2D38tXsaA97G3vysiqTPZ/Z8DsIvElHgCjkXQBoHhl8ErfsdbgNYMqxL7iowpoImWLUsOugCGpJ5UnGEEMSB48jASKb/d3omO2YNv1Qob+jx9ACxYsGbJA1jP/RjywT4xhz3Dh0RVoYgqIGZD1a5CjtwRHRLp+0SbghJlXZIE7Cd3dQj2zqFAR6Tz38xeHJjXz5A6yoTh4bx376LghyR/dcsP8oqVsWz3lWzwF7XebxptBhii37sZKYCE65GOspeqHUpoZfqAoJw8fJwXS0QYWxycvZxhc33rv0NFgHJW4ScQI03R60NiLGdprZHi++5llz7ytRhqfg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 3 Aug 2026 15:57:15 +0100 David Laight <david.laight.linux@gmail.com> wrote:

> On Mon,  3 Aug 2026 06:40:33 -0700
> SJ Park <sj@kernel.org> wrote:
[...]
> > --- a/mm/damon/lru_sort.c
> > +++ b/mm/damon/lru_sort.c
> > @@ -233,6 +233,8 @@ static int damon_lru_sort_add_quota_goals(struct damos *hot_scheme,
> >  
> >  	if (!active_mem_bp)
> >  		return 0;
> > +	if (10000 < active_mem_bp)
> 
> That is backwards...

I tend to prefer using only '<' or '<=' because it makes smaller thing comes
left.  But maybe I was overusing that here.  I think 'active_mem_bp > 10000'
should also reads well.  I will think more carefully for this, from the next
time.  Andrew already picked this up and he should be busy for next
merge window preparation.  Hence I'll not revision this for the minor change,
if you don't mind.


Thanks,
SJ

[...]

