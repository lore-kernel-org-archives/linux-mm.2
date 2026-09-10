Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C593EC79FB7
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 00:18:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BB576B008A; Wed,  9 Sep 2026 20:18:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96C826B008C; Wed,  9 Sep 2026 20:18:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85B2D6B0092; Wed,  9 Sep 2026 20:18:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5FEB76B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 20:18:03 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 951AA40393
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 00:17:57 +0000 (UTC)
X-FDA: 85195939794.12.7DC8845
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 13F9540004
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 00:17:55 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XDiIuga1;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788999476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TW3K+AgSrwHemRWw14UWea9xECIj/k6NgLwb2UHRsPk=;
	b=Or5dqeg99244YqeK556p64g8TkDsJ5zXNkOlP7QouobQwHqQCP4nJpBc7YAfyXBQgRAfpe
	6lRqFqrFtMA5BFsXI80nDyXQ7Iz5zzkuOHvTGLbZxudpEbQQy4gwkBCm3jhJFG/Z+EZHPd
	wcPjYx6t5/EjQy4SptOtzWUa23hJVzU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XDiIuga1;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788999476;
	b=gsKOiuMtoo+2AvzvGMXK9FSqf0/V8uEpLQ3JAHsr4oz4dkFQ+noTImvnx9BMzX43orCMu7
	mrg+3vwGjSE2kiH4MhYKy2kgoI3RgUVX3pkdqmlwIvK1zkmTkncDlbEzZc5bjN4xSX72Tv
	xDnfbU6396tNRuCTTir5JNe6gmOq9uQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5A94C600CB;
	Thu, 10 Sep 2026 00:17:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 769F51F000FF;
	Thu, 10 Sep 2026 00:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788999475;
	bh=TW3K+AgSrwHemRWw14UWea9xECIj/k6NgLwb2UHRsPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XDiIuga1MVxrtxfrwhhYXePZoy0JGb+ujz65mh5hUYMY67pz0foKfM7Q5QkCL5v0n
	 lTfa0cCfiS2XfZuigBiP9U0iHcwdRhd2CUM46aewqoVtleZ9nOpf9n/TnU19pVtIA2
	 utUeA+R2k3MqADcMDel8YPg5y/UPtErXdi911fksXcgktppyMIvkEkrLuLBIFVW721
	 RSfj6A+rv2AiJzx7SRLLoqkfDUlSg9Kd+1ykynRnzDYAXahm39nr1ayxpyrCVgbZJU
	 SbdiADH8ni8BbnbdwSnfXengJkE6FhFqUH+qO/l72YS2CRY795lUa5AGNDljhhF/f6
	 gzdzh8H/kx7Jg==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	damon@lists.linux.dev,
	david@kernel.org,
	liam@infradead.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	rdunlap@infradead.org,
	rppt@kernel.org,
	skhan@linuxfoundation.org,
	surenb@google.com,
	vbabka@kernel.org
Subject: Re: [RFC PATCH] Docs/mm/damon/design: clarify when qt_exceeds increases
Date: Wed,  9 Sep 2026 17:17:46 -0700
Message-ID: <20260910001747.110260-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260909100913.30568-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 13F9540004
X-Stat-Signature: 713tf3eogpdfsztca8jm6963nwhjsr39
X-Rspam-User: 
X-HE-Tag: 1788999475-392597
X-HE-Meta: U2FsdGVkX18WfA4Q9M8ci+9U9eT8fujQLnokJVvx9Cv5dMHmsrOHHMDK6GCw9NOGOLEEUrOOprH8gFKNAebH+5GuIWZ56WsRXKkLBUwtlXYjvBu3M/3XPteoa5H+7GbSILem4wslkrhg+pE6twlIipehag70de5DEI7spo7t4rAu4knblxxf0RA0viOhNoPq3v5xow7negxusn2jbyR3jSjSheOdJgoAtD+SXUtOrHwCHwa4ALpfAjMJMyUISAGW/dPH6ni9LYCoDymZV1KgBzbRAH1m0CpHBUOPRyna9c1+JM9qpCLUQugwOLOMEczErHZ/c+Q26C+V5zCaXlnqU356voPPhHk7Cpo/60HgUWPt3Hr6VT+5doHGYGegvU7pbMv04tnUuzI2kaD/51DqyulsrbabHcpahsgqpaY8x5A02zzZ+FgARiwkQZfuY8l4YV08SGQFUkrwa4thNW9xZFQC6n4NFqdw8NyUji1Akf1lFU5/2Zsx9L3Kb6tA+mwgD/pP2fLqGV5bmeVThbRzW4A9T4QjpI2fblaRuqJOZKkCaeNZIEgauMCo9LpnzkXdXYCS8v/4G0W4ZBCRQRJxl+Jk6M46b3D1LFdXYZBlQWgZMHFpaUVUBgCzoU6Mt9wQCdloBhjSUO8zOSo3KUI9Jq62czdZhfVe3dNAwu8zJqD2qXppNGlTvAGtztANHT7wtkKt6OwY30YWYx+9aYsT5T3LcH0DtVy5W9ka9cXMwttgfVLbuODJFyQQg7H0NnANR8GAgrTzbX+CdalUCtkLha1kMTaQ7V+sToDtXO7VSGPo0O0omvTsl/2WPRsurgZg2eFTrVxWxyLgbuJ9xa7zWQKklE8fENyj0OigzbZgFDzpEdfmLgr01RJihgffZjA6o0xxuPvmuUmEEW+JKYGEVSP0SA4Z7aIrjdUSxi5AHZ9arzgl1TrPmOXS6kgv0ot++PWa19CWjKc+lD0SmVc
 ZnwTz7po
 UGqL26eGxQEsryd3sEtvOkV0DA/RFKN7yKu4A7XyG3edqCXBXde13o+A2E/pnv2BVRcoVOG+i48ZLFyvlU3pGlJDbeKaij83wRuyAt6V505EcngR+47lM4G4ps9+bLs6c9uKN9BbWmBeG5xw2wtQI70De2DNxw4U9WLNf8lN7ETedAo2OM7RcETSbcnDyE1gjMkAhH5Z7aBuCgGW4u7hrN/ao0El1eWzi2Eba8TvJ/kPmeF4bykEjtB5WQiaiOu2fpQeHJPT+wEfa/LCs69/BdnmOPm9rEfo0C47nFyfW9ScifygiaX36eJHM+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  9 Sep 2026 18:07:33 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> On Tue, 08 Sep 2026 17:38:00 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > Hi Liew,
> > 
> > On Wed,  9 Sep 2026 01:50:23 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
[...]
> > > By the way, I found a thing in the design document that confused me.
> > > 
> > >     temporal: More straightforward algorithm. Tries to achieve the goal
> > >     as fast as possible, using maximum allowed quota, but only for a
> > >     temporal short time. ---> When the quota is under-achieved, this
> > >     algorithm keeps tuning quota to a maximum allowed one. Once the
> > >     quota is [over]-achieved <---, this sets the quota zero. Useful for
> > >     deterministic control required environments.
> > > 
> > > I'm not sure if "goal" was accidentally written as "quota" here.  Would
> > > this be better?
> > > 
> > >     When the goal is under-achieved, this algorithm keeps tuning quota
> > >     to a maximum allowed one. Once the goal is [over-]achieved, [...]
> > 
> > Good eyes!  Yes, seems it was only mistakenly written in the way.  Please feel
> > free to send a separate patch or include it into the next version of this
> > patch, whatever better for you.
> 
> I will send a separate patch.

Makes sense to me.

[...]
> > I think the clarification is better to be added to the 'temporal' quota tuner,
> > since this happens only when it is used.  Maybe the clarification could also be
> > shorter.  For example,
[...]
> I agree that would be better.  Although users might look up the
> definition of qt_exceeds first, they are also likely to navigate
> directly to the temporal section.
> 
> I will clarify at the temporal section in the next revision.

Thank you.  Looking forward to patches.


Thanks,
SJ

[...]

