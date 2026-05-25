Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75596CD5BC9
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 15:26:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE5D46B008A; Mon, 25 May 2026 11:26:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B96766B008C; Mon, 25 May 2026 11:26:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAC226B0093; Mon, 25 May 2026 11:26:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 97FC96B008A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:26:57 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4325EC0317
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:26:57 +0000 (UTC)
X-FDA: 84806320074.17.437BE0B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id A969C16000B
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:26:55 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RABhSdjt;
	spf=pass (imf08.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779722815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KEioWnHBFrSVOzWNfEkI+OE/2Sc6ORJaNzdndpa/bQE=;
	b=MafUPTji4voNfDhgtTzUQLUQGa8dsWmlxQosz4X70V+G8FmQTbUls8oj+J3zWt1crJKerP
	q4jmxhoEDKTD1WaVCwHc+XmHV6oF71tM3XKVUVBTYlbCVlqUBhBwzxU5aSnX0fU2wyfHDG
	G4PxGqL+TVuVBfpj1pupiLx3MmA4o+8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RABhSdjt;
	spf=pass (imf08.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779722815; a=rsa-sha256;
	cv=none;
	b=jdTMhrVIVLR209EoroQXTQ2tsRRfiK75Q4yGMm+OmpFat1q/O2K+/PVvRyy9QUdFiz5WMi
	S/P0FdF32zz6oKpYxjvTaZ6a1gmh0wt4k4HvLTirzVtoW09H84XkuLNj0HgoJeKFkTVBZe
	AXH8lL7erZWzTLm3wHVX8Zpx0DOkLKg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0E97E600BB;
	Mon, 25 May 2026 15:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33C0E1F000E9;
	Mon, 25 May 2026 15:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779722814;
	bh=KEioWnHBFrSVOzWNfEkI+OE/2Sc6ORJaNzdndpa/bQE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=RABhSdjt5u0xspCBftMJSAFcLnZnPAxEHcgKblhAtxk2MraxplpKc7uBljDlCqvPp
	 zVTmMAHY2/KZRj0OAGoDXPHwZ+Nz/QC/QyXVkUoI3+bv01bgaAmOBagGDm/e+3tbEP
	 jLCLsdybfirYpTfIb9IwBkU4e8p6QlLTxhuA+21yf/lM9yB9+6Xp9rflfRKcdut2K+
	 lGcvKjYnZgffXWdfk55VUWJGpgDn6MHoKiIEuplqxepYfj8mGRLipvfmd+VoUHNXbg
	 7lVlEA2UGcrQYxZpwhnGXh8LcxvUOIk8TDsf9KruXsGr8chSDyJ6nePwJzrUXnlhNJ
	 bZcj708UaTX5w==
From: Pratyush Yadav <pratyush@kernel.org>
To: Yifei Chu <yifeichu24@gmail.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,  Mike Rapoport
 <rppt@kernel.org>,  linux-kernel@vger.kernel.org,  Pratyush Yadav
 <pratyush@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,
  Alexander Graf <graf@amazon.com>,  linux-mm@kvack.org,
  kexec@lists.infradead.org
Subject: Re: [BUG] liveupdate: incoming/outgoing session ioctls accepted in
 wrong phase can panic
In-Reply-To: <CAPJnbgLtEUQ4Kv1ENM4ku0S0JFS8T49MEHFa4MpoT3WRuuVfFA@mail.gmail.com>
	(Yifei Chu's message of "Sun, 24 May 2026 10:44:31 -0400")
References: <CAPJnbgLtEUQ4Kv1ENM4ku0S0JFS8T49MEHFa4MpoT3WRuuVfFA@mail.gmail.com>
Date: Mon, 25 May 2026 17:26:51 +0200
Message-ID: <2vxzjysr7bno.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: e4kcfq7oy9jd7rzsg4egd3igqf4twgj8
X-Rspamd-Queue-Id: A969C16000B
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779722815-781479
X-HE-Meta: U2FsdGVkX1+63fl20HsMsNldJvFk7hJpV6xi6sC3JitNROBzQq9eH878TcZoq8P9k1+IY7nZ5hkfR5vK9XNpoa7HY2w6yxQUIBhgrHyHbvuj38lVduJRencpkk+P/S76CnSglJVDhFUswSxgwGS9WRWXGbA8alIjD46cc27Dl9YphJDsnKywSQ1bhqNLjnJnI/w2rgUArhg9kb0zSRbqOx4+xWI88T41zvVzv7GRloJf2rekPdUP3LEJhrwlZF/o41tz94xNKazacHEE0SFTOTC06zlv+5Vp6LbSXSOnviNRaUnbIke2oPp250jWmBpQ35IQMXtSkNf0cLOpboHsdx8sSwI1nlE9n7Vw9imKl5W+aJ6Av4yj03sQN1Aa+0xI5sBtV9Au6Sh7+rmF+FDkz719x+c33Gdskk/z3zJ+FRslv4LP66ES4eVD6JKJdEYKcS9UMBNLkNxLdfgtrC09jOI/Kpr+yNdSrLXS0DKvkhDMy1gPq0Q+HWsVWh1C2O9zvcQFlDekX6jc4Q2g7hjOMt0RgtxKPRRgPZ1jjkexjjnH5i31SrrKTXT/cqsJG/QD1PYLj0zppukXIXPx4vC5HwDb2ro9N0A1QDHrNNoegY9n+wqHkz8yMm3gBjVI7Wk5Yi4gTOncz7q0zmY4X+UyVgjw7ZeWLwLCasAMaQ8OYObetMxgh4lwilKoMkGJThlrtyfNO5xBlUFMvFq7MQ6PQrtM+t3GRPKAnsIKOk2/5pU1i+TaaDMFkqzV1jNHiZXKqlM3tmt8fX9XRBVEd6U2coRZcdvmTbO6abVWyggO7b1WNKUwJxAu0odQooLiF3AAKYObVitubXOTmsf0YasxxTNWoQhNfW3jFHyHiz3cloSTcDUFZ1vHUyCrEETPjZ/wA6mQXmRBtGTuCCrHxl2BpaNnaFjQ2fLSbRWjlf4wDLm2p7uIpSvGZzXDdYMfZAuXDi+296vLASKyER4/X60
 4bmIGysh
 rk7QTeyQ3jE0FOblwdyw+v2hf2hqXMW7vIknA7phUff8ejpbAnhr8X4v3/2nsHsxSOAzniCGAI9nZz90n/oGObXzKLqDcd4JhgkLUXKf8MVfgAhjnBWVZk5PHxbJB6LsW7jmaPyI3IWKnv8NCcSieItgDufCVhgBAGzic+fZPnfestkwjHnzPRhZjKCQPOsiNIqh1iaS7AC/rK6v+kLPLgERptSt6L21u6l+o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 24 2026, Yifei Chu wrote:

> Hello,
>
> Short version: I found that liveupdate session ioctls can be accepted on the wrong kind of session. In my tests, that
> lets userspace drive memfd LUO into KHO restore paths for current-kernel preserved memory, which hits kho_restore_page()
> warnings and panics with panic_on_warn=1.

I already sent a fix for this:
https://lore.kernel.org/kexec/20260519122428.2378446-1-pratyush@kernel.org/

I need to do a refresh of this patch with some tests.

-- 
Regards,
Pratyush Yadav

