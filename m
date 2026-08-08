Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD74DC5AD48
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 22:51:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E9346B00E2; Sat,  8 Aug 2026 18:51:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 299EE6B00E3; Sat,  8 Aug 2026 18:51:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AFCF6B00E4; Sat,  8 Aug 2026 18:51:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DC6EE6B00E2
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 18:51:05 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2079516043D
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 22:51:05 +0000 (UTC)
X-FDA: 85079599290.29.69E6BE7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7B4AD140004
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 22:51:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YPHVB+Rs;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786229463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KkFvMXuG7BcwFpCDdU5hIsGSAAXYTgJuEvWnM2X5PGA=;
	b=3x+SXVaN9Si5eB6kGK/OaAzYgCGjkE2zWKybPYIeDaj6oFlC/l7BwOAbnpHyEZrPHhe7Mb
	0btB+MfwnOfuDVay/YiXiAOcM/dY6mJhqpiZ8hDjjeBaeTRVOJZHmb+EY6/sIsV4vGnAr6
	Os5Ku+mDgn0VKk2mL5wPS2nkZ/X15W4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786229463;
	b=1DKyq1S4lGTEm4BgG9OrI9kVNiQFnHqK4n/tXKkDCU2gwy7eJYziHYwIgzO3Rmw/Hyjbru
	yHr7Fhf8XzYm41569BTSReMEHuhcSFGI7hPD6lpZaLHUa60CK5aHVFHfJGvNweXb/HZhkc
	i1xfLAUE03tKGehxEwnerCn4xCXRfWA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YPHVB+Rs;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 97E4B60054;
	Sat,  8 Aug 2026 22:51:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA7E1F000E9;
	Sat,  8 Aug 2026 22:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786229462;
	bh=KkFvMXuG7BcwFpCDdU5hIsGSAAXYTgJuEvWnM2X5PGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YPHVB+RsV8E8ByYQeqKs4psTqgiGZJiFaUvXjDZL7W756Idf++GXwTy+3W8SIaJ6Z
	 u/baU/vgMOYHfRXSBKOmKjB0V13msSrC0CXt0D/42iHr7kQICeXkzbEJ1961TAbnID
	 jE1rtTqqbLe6cj9oGheVGP9DxxskWP8qAC9Zby1sq7/+s7XqLasthNJIJ7ge8I1jLo
	 VZQHd1Jqv+/uNTqgPCTT6qlYxG1bXOC+9Izg6XWI7Zgd83d6gF3lIZQR8zkM6qMfiU
	 u79ZMfCFqU0QiT6uAeci3EDxjdw3rfy7Gs5SbzorzCBKOsCtj/R65v3S/8wmo01ReX
	 vrqk1EvQAoe4A==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH 2/2] mm/damon: skip deactivated schemes in watermark checks and add fallback sleep
Date: Sat,  8 Aug 2026 15:50:53 -0700
Message-ID: <20260808225053.111143-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260808215554.6045-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7B4AD140004
X-Stat-Signature: nee3w5kfbmzao3ubrd5ckz9kjjatjrug
X-HE-Tag: 1786229463-568642
X-HE-Meta: U2FsdGVkX1/KU+xdKvYQxdEGN6Szzn9m5EBO3irYaLyJ3lIsVuAGSNpxYjKQRE+JhSy3nYS44/D+Q74CaGRBPCqRjf5fPV/SEdzsof1NUGdMqsUQWeIV5pYcjV0yWMCVUpiTHRtyACwaM774qsW/dNw3hvz2avImbc4wzHNwGcGNUpyZmcF4g3ZDort0n1AYAV4oTvs6mFigKT2ONzWGOOZG2Xxbuc/VsrkOIj6fR27/XmXL6nA26V8rskdD073uojXB1vBvwZ72MPy8Su+5/JvCM3uPV0HfBFB3DEnDMI3zAkkqSf02GlUiyXAaqiVwoHZ9jeV94lgoJCF751BMSFlH//X2X13pSa0nbgsMFuiUq9hkkGhjp3zcIoMpTKBvqMBCHjtKpeO6E57I2KeOLNpYtwMbQs5GK/3vbDVPjlWWgmVSac5Y3yWQ3nlMmz5u9BLu8FnioYmky7BI4rLl0y8cV0dhTL1xQk78VhwipQIcwAxBWXEM6Kr3nQSfPmDvRa9vb53ldzjJtBWdCVnJSBeU6Im9fc4+pQgifOamaemGwXiHWW5KdS38iZTOLBDjl7MJXcxFRfKQ5oh7xf7fty0Ln5O5gZ4CxoReaCdQTPi3IC0VINid8flmiikFB5cBx1/I4seHf9aIi3RqfyIhtsP498vzFjZqzKbGZpB4tzZl1FVgP9vwdZvLcFjLRmtl8+R05rNvO4w96X/JHy57mctGTCfb99+tw3sGdbYbS+5f5gWeIgH2fhQHiyBHDxEbWVIO79Ypnk0vnZiMN8WCCLXZb/BX+WQfFiqcvny1RgfrlvvDs172b13WDG32+u/x13/QJTzBROLu20BhV+5VOXDer5sKnKnoFwkDrSGW2dtkiF5I6ULUVtrFVHvMp645LzHsY+8E50RRQ1Swdnl1cEfyBbWZ3s1/bfvhxe6/6EYvtf+8VicUCM9UaJ58N3y/F2WoU0qbKNPwDJaWa67
 TcklwNot
 p7kZDDPCc+QIi8D3LxSRqtLB6GNwqXhskuDx+djEEJNprguH7kernUMQhyuNKuXcFR2mNCRxM8iQzBHd1lBI74aegPZrQqB3UwCN2HV6RPWusEhTRCBUYJGubcN4tBLRfymOUqGzMAvVhFEEinhb8rir2zBca55wAePDA59RanKWMqFnomkoaNHPtDuxFPZKtBu6O/eJ3x3JbbJRq9/JvzTsuKEZew4nX5iz1UCspKatLOZssbP/DhH5w0KXp8Satffhd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun,  9 Aug 2026 05:55:54 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

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
> Wait, according to the documentation and the code, DAMON will still stop
> monitoring when all schemes is deactivated.

That's correct.

[...]
> Should this be changed to monitoring will not stop?

No.  The change you mentioning will be unexpected behavioral change.

> 
> Also this patch (0002) add a new function named damos_is_deactivated(),
> it checks both wmarks.activated and max_nr_snapshot conditions, and I
> replace the wmarks.activated-only with this new function.

Let's distinguish watermarks based deactivation and max_nr_snapshots based
deactivation.  They are completely different things and have different
behaviors.  The current documentation may confused you.

> 
> I am sorry if my commit message has caused you any misunderstanding.

No worry.  The current poor documentation is the one to blame in my opinion.


Thanks,
SJ

[...]

