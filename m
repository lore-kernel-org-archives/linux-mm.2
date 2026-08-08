Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E06C3C5AD2B
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 00:07:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D1476B00A5; Fri,  7 Aug 2026 20:07:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6824E6B00A7; Fri,  7 Aug 2026 20:07:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 598E96B00AB; Fri,  7 Aug 2026 20:07:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 282186B00A5
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:07:49 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7576540299
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 00:07:48 +0000 (UTC)
X-FDA: 85076163816.08.8378689
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id DCBC840008
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 00:07:46 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZoFR3W53;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786147666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jURskxvxN8Et2Wft8lg3avApYLlxcoCblCUkQrEksBE=;
	b=roT+V4MDie5nKuDL8ScjLIyx1FPF8N+utkl1f5EhpncnYUqJ5LJDzF9EZVWj6dOGlpVWOD
	4IQ6iwm4M0sNS+66zvzt+8Et67HOqsXbvF6mFR/0Q0hjv0RqwM3SQIL8DCXw/MJCHVEMV7
	B4B+h0g7WOeWUuobS2cOU6MrmNKeUA8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786147666;
	b=zHP5l6AsvFNVmOetJFfJcZ/+fx+2I5vTsYRNzIr6hrEbT9COdqcrMJKQOyJH/kGLEltSiY
	oOfSsBLRtf4ZO/c8g8J9IOP4cSAM2CqIiaD8qSFc537kEVcIoB27c9IuX74EbpQXz37Tfi
	uxIYFRqqIFUpso8qRh7RWBW8peuNcy8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZoFR3W53;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 244D140B94;
	Sat,  8 Aug 2026 00:07:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3EC1F000E9;
	Sat,  8 Aug 2026 00:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786147666;
	bh=jURskxvxN8Et2Wft8lg3avApYLlxcoCblCUkQrEksBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZoFR3W535iIJL7/T3VlGOvG4vWl1jyomma/oC/XHtmSdwpFzeG8s6nNVD3/3WBcWU
	 9TTIXF0owhgDtfiVGEd19jH3fF5ghW1lTOj2doZh7Up6zVGP8R9sBvX4y4GvRP3cPC
	 TIUvmqUmf30++8P8yZIda5tD4IzmwzUpipQ5sh3aYB73bGFvmlCfxKdr6gLPMbRY3e
	 Wo50B0fql//H0hbOUv86hcq1vpOVtfHnA7/EJPqatDy2zm3tHikTi+KbnVpkmlqmUy
	 t8qft6XxZuxRcj8tHsm3/aKsQKRiW7LgLediOtap3G3plM6iWzBWgxvyj0PZR1xWD7
	 OKXE0Gr7+JGVA==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH 2/2] mm/damon: skip deactivated schemes in watermark checks and add fallback sleep
Date: Fri,  7 Aug 2026 17:07:38 -0700
Message-ID: <20260808000739.1308-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260807161840.56993-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: wgk8p5jn9zb67o58nwwacirx84ts8ftc
X-Rspamd-Queue-Id: DCBC840008
X-HE-Tag: 1786147666-227104
X-HE-Meta: U2FsdGVkX18mOOPmO+DnMhTeOl45qNGYp2BFKr8C5OVggR4e44e7TRQ0XftniV/2rReYRO4YI2no43asdKyX2NElEtBI0Ux33/NjptXt7pUgm3vjBXIqczc6cMpccdRuqedsHuArMIfjiWHVLl3iCQKf3dXESOev+cXWmxUYvWpsq5XG7UW2py0ooGMD9qPoGzMFdvn2Lcqf4c+DdnhBDmia75lgh6wxA3TVL5nRcmyVFkFMlg416ugBw8z9SxzXKzDkgDNAiH0g2d3eBMpKU673DcF206xPTqawFxP6O6ihuyA7nCdRmXrY6ZPM5KbbJm6xpieEHU06YQbMgyTEJQqCYjYjGJR/vVHBFhGRI0Lmuszad3h7vW0zAEt5sJYivD0n9Vc382YYcS3KKtDe64X2GIjFJ510TFD/dJ/ub1XBUSxdsaVwNaVIQ0YXe3ekj5oWnzs3TDrXQK9H6APgMqhCbAbn71vDEBCLgJU2dZEfrpM+E+gxLuGbqOWQfGZ2J4VzWnLOtaUT7JD/cAhdFg+6k+FRiugtYquCSaA5z5Q2EjzX6nnP5y6U6OfHHvMaEW19/wR+VAE2bcpe3T6Tbc/4siuV9JIrc2HJvTSK/3ZvTHnKAmgcMdsWHMT5I5N/iW5cmkshabqQ8tvp1yYw4EqgwwiDA7uNhp2LNv0XTaHewqexdVRdZS/hflUk/L9exwe+0Wyu+Q6qNzzeZvA6zIKKuSBXTtzNuS6SI0lDhIl3OxdQVCd4L1jamCKPLOLSMc1bUQmUN11RfAo7pkDoeze7c/xcjdP/8LUPXScmFgpFyQugxTOE0klOQaunZcD+KzzD8o1dgMduhotYe9o7ZQkp+rVn2Av9Q6+oU8peOTE/3m855iDvhKirff/mqve0c44j4FGWbm0gVlkkfq6bP0T1333VTZWjar+L/xQ/fDSEwlITkhJBrtSmIrQWFx8Yd67w1uJiOpc7LqZbBf+
 F7SDPIIt
 ddio3g8kpEkY8P508uLBlVaB+I0mK25vw9fUPWPn3z68+ue5c0SwqGTzfnjAQ9AdznLrDSqwGvaLuJO76MRhaUGjfNeFG8STnmmoBp77g0640CXtdjzoguIJCtB0jkcLyu0m+QQdmU/lScPTJo6LvwwBPEbiWtxn5qBN4TdSAd+1W27nthnMnFvkBEY2JsnNsO+ZySIBl48BEZkJ/8e8fsOERI63BiSudhyIEgMeR+qQ+0a8g/K5jby3NT0dtqBsfOvfy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat,  8 Aug 2026 00:18:40 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Hi SJ,
> 
> On Fri,  7 Aug 2026 07:07:39 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > This is an intended implementation.
> > 
> > When all schemes are deactivated by watermarks, DAMON stops monitoring.  It was
> > implemented in the way because we didn't want DAMON consumes system resource in
> > the case.  But, later it turned out DAMON's resource consumption is really
> > negligible.  Rather, it is turned out that it makes DAMON runs with stale
> > history when it is activated again.  Particularly, regions have 'age' and their
> > start/end addresses that was emerged before the deactivation.  Those are
> > meaningless and could even cause wrong DAMOS decisions.
> > 
> > We don't want that anymore.  For a case the user really want DAMON completely
> > stops, we introduced 'pause'.  For max_nr_snapshot-based deactivation, we don't
> > intend to completely stop DAMON.
> > 
> > Maybe the documentation can be updated to further clarify this.
> 
> Thank you for your detailed explanation! I also glad to hear that
> DAMON's monitoring's resource consumption is negligible, since I plan to
> add a contexts/<N>/always_monitoring parameter later on, allowing users
> to decide for themselves whether to keep monitoring even all schemes is
> deactivated by watermarks.

Unless it is for your real use case, I'd not encourage improving watermarks.

Here are contexts.  Watermarks was initially developed for DAMON_RECLAIM.  But
I found it is difficult to be extended for other use cases.  Also it has the
aobve mentioned problem: losing the monitoring results that was converged over
time.

I'm planning to develop an alternative superior feature and deprecate
watermarks over time.  The plan is not having a high priority because I don't
show real requirement of that.  If anyone wants it for their real use case,
please let me know so that I can prioritize.


Thanks,
SJ

[...]

