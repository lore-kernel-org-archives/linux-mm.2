Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7C66F3ED50
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 18:06:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BCC56B0089; Sat, 11 Apr 2026 14:06:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41F4A6B008A; Sat, 11 Apr 2026 14:06:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C0326B0092; Sat, 11 Apr 2026 14:06:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 177C46B0089
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 14:06:05 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DDA2F1B8C2F
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 18:06:04 +0000 (UTC)
X-FDA: 84647053848.30.4F89DCC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5277AA0006
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 18:06:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qvAePOSa;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775930763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=76jT0Av/PppohLY9e8uNu08CNJdiWrt9ObBqE/Z0s84=;
	b=5e49jc+ya/0Wnbzd2SGfRbeS4fzBycqMswITuBUmYcdiIWF33Z4/5tGqVNgsLBrLXbiplX
	gjnQMVUimaSjWnxuqfmeyuvh9pwzb0EsTLbs69IS5lNhuga90NmPSoN8GXtDPN9rzp0wKH
	fu17gqziLI4QjyGmYDYN7b2UdUdDGLM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qvAePOSa;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775930763; a=rsa-sha256;
	cv=none;
	b=EkcxS4kPsBsXj5GiWIG1NYqK9FAHg5XSnrMOkN8JG/udS3cbDZqdOgw/XpDu3C7eWg3GfT
	grq4xhCcAPcLyoYOnzqV+4vLIaobK3TdO+5crvdNzIKPpBYOs2wUJQwLobkadmyQiSGBsZ
	P58GKmEnvYtgA4AfzR6dR48X4g45rJ0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AB9C06015B
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 18:06:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CEF0C2BCAF;
	Sat, 11 Apr 2026 18:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775930762;
	bh=FT5470fpgMWYmiUdJN7K/tRS99P7K/kQlx5yLr3uiUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qvAePOSajJF1TiS2/hX5RCRKWZ3UQj7Krxe/PiLtBGhgTSYX8dGLuHkqd/EaFuDsr
	 7cdgBrGkU2ATWj23WrZlvBE1nPrrZD4BYHoMPtmMopRPeKO/Bt0vF/Q5Bmu7jizQ1Q
	 zfgQmNuORckDYMJFS8FTCG4CC08xHBh+Ek8nqb3DsJxsKWEfJhmzcNA574CyhWLSw1
	 Rx+7p54UNIrejfHuz6c+U+WG2me8TbfRkIVlOMRQ8pew4MUMmJ/5XszM1shtOP5Mng
	 6u6VRGscPpNODROlrA/ZgQUqosex25eo0av9z4jAz/1Dhs8eJKZ/T0n7/hpkbuHK4X
	 68iHa0ia7kPpg==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH v5.1 03/11] mm/damon/core: introduce failed region quota charge ratio
Date: Sat, 11 Apr 2026 11:05:49 -0700
Message-ID: <20260411180549.79857-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260411164908.77189-4-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5277AA0006
X-Stat-Signature: qmyjrhz56nutaquqr764dz38jo3dff5t
X-Rspam-User: 
X-HE-Tag: 1775930763-144944
X-HE-Meta: U2FsdGVkX196bJb7ofoR5pwgnz50PS+nkyDIwMoLNvRnGn+r/NrUaZFMMlAOyQ1GZABoMWvd+a9SI2OMBlkwFC6pkpaT5QVpGALT06wN96UcdktBRHQn9gE0HvtaSHn5kPR51lqbecUFbHN/FkY4nNE7X/arnDd/EsWvP80ZRi8hYcDA6ggHp83LdIQ2ktJ6LrNqwdFWd/XOPzw5TQhu3N++uDqbtSWzUkzXTrM/PjUJ3EiaNl++oVKr3kpvekFrTNfsZw66lmTnb+WRZ6j/MaJ3xJoMZSmbFR9Z1Vjx8bCGDAsNPp5vQsKHjbZXTkhtAbYSZKXjg1Lruz2Gyi4V459n5PpkRHC+h1BouXp+RZgumDsZi0N+nkcImhGpmoiMKX5SkyohQ0xUmLUxOyRp5IYuWJ3qhLdDCvuGeyD5rt9jh11coH6qEzJnaBC+6W4/WlrpaBJEt6OLGAAi1Ar+NEGjYqw9RAOLd9o45dMHUon6/3Wkl8C2o1Csj8+rCGC6zRGBdT6h9p6Lz8p0aCe2qAMBq1Zn36UmPI9vLl+YKlxveASm6RJ8v0vBcBXC3whVassXaCVWKsLb+ZeTzV+xT3I5h4ffLGxxh+cl2N3Bs0x6vDeD7yMIVp2D2Ga7a71VpA9Y+GW+trBKIB55AUUQP0hoG7kvd13eZDxn8a9HjdmUhpGr44efXRPFGW8XftRQXk0Zxw+o2LEHRTDGQZSFubohDJCe0jb0T/SvgkxLoJhmw4XiGHhSB17jivq198RXgM2QBn2nZ9TwKz9qQ+TniOpzqypS1+HlNCCbYDVFuH2NwTYFBr4xmWbb3WhTa5xmuF4ODBBaJDKwqej/iNzI5/Kd/aw6Am6fO4f9uIUzp2rFFatXTi+yDkisbGnoxIoz6LoKTnboJljkdDAB94JJrvyumxueRmBaKrzs5qIEjIlknxJbB602NJjhu5gY97lvdmHskNhCaOPvM8tUk2R
 FfoAYKTh
 bajKvvq/S6rIFbBLvAdsnlUthgThWwSiT1zo4dNy1GIqq+MZwqlzHnbvjg8XuZwGErgsJvKwca9Bhouz+qckszbZCpxrTnv3CCEik1Vf3bR6pXJI+PtwqcPGRuCIhmVBDciGdyUDuEB1MlCECAtYB5m5dNqizGTMOUd2qcCU+Fq+eYn4gEyPSIQWbKlI1hR6AyiuQfHSmZFCNxWxapafc3E5FgTYigvv1ZIDITr9oMNt7xi/ETIIgO9Y+cDugVC7r7xUBL7B++pHdwXgIIUqPPnwdCYhCZMJPH2SPPwVVpzxb6Lhcf8CqJZlXisSwp6R+Edem/x8o5gBwDZVCCGxcbfH0cA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TL; DR: sashiko found no blocker for this patch.

Forwarding full sashiko review in a reply format with my inline comments below,
for sharing details of my view and doing followup discussions via mails if
needed.

> # review url: https://sashiko.dev/#/patchset/20260411164908.77189-4-sj@kernel.org
> # start of sashiko.dev inline review
> commit cb228850cc3bb33cac86cdc674c79e2557af28a8
> Author: SeongJae Park <sj@kernel.org>
> 
> mm/damon/core: introduce failed region quota charge ratio
> 
> This commit introduces a DAMON core API to set the charge ratio for
> action-failed memory. It allows API callers to specify the ratio flexibly
> using a numerator and denominator to avoid charging failed memory the same
> as successfully applied memory.
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index d04a107df7cfa..3398faeaa4350 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> 
> [ ... ]
> 
> > @@ -2041,6 +2043,23 @@ static void damos_walk_cancel(struct damon_ctx *ctx)
> >  	mutex_unlock(&ctx->walk_control_lock);
> >  }
> >  
> > +static void damos_charge_quota(struct damos_quota *quota,
> > +		unsigned long sz_region, unsigned long sz_applied)
> > +{
> > +	/*
> > +	 * sz_applied could be bigger than sz_region, depending on ops
> > +	 * implementation of the action, e.g., damos_pa_pageout().  Charge only
> > +	 * the region size in the case.
> > +	 */
> > +	if (!quota->fail_charge_denom || sz_applied > sz_region)
> > +		quota->charged_sz += sz_region;
> > +	else
> > +		quota->charged_sz += sz_applied + mult_frac(
> > +				(sz_region - sz_applied),
> > +				quota->fail_charge_num,
> > +				quota->fail_charge_denom);
> 
> Could the mult_frac() calculation silently overflow here?
> 
> The fail_charge_num and fail_charge_denom variables are user-controlled
> unsigned int parameters without bounds checking. The mult_frac(x, numer, denom)
> macro evaluates as quot * numer + (rem * numer) / denom, using the type of x,
> which is unsigned long in this case.
> 
> On a 32-bit architecture, if a user configures a fine-grained ratio like
> 1000000 / 1000000, the remainder could be up to 999999. The intermediate
> calculation for rem * numer would evaluate to nearly 10^12, which overflows
> the 32-bit limit.
> 
> Similarly, on 64-bit architectures, setting fail_charge_num to a very
> large value like UINT_MAX could cause the quot * numer operation to exceed
> the 64-bit limit for large memory regions.
> 
> If an overflow occurs, it would severely under-account the charged size,
> breaking the quota enforcement in damos_quota_is_full() and allowing the
> scheme to silently bypass its configured action limits.
> 
> Does this code need bounds checking for the numerator and denominator, or
> should it use a safer math helper to prevent the quota bypass?

Same sashiko question to the previous patch.  My answer is also same.  I will
keep this as is in favor of simplicity.

> 
> > +}
> 
> 
> # end of sashiko.dev inline review
> # review url: https://sashiko.dev/#/patchset/20260411164908.77189-4-sj@kernel.org


Thanks,
SJ

# hkml [1] generated a draft of this mail.  You can regenerate
# this using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260411164908.77189-4-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

