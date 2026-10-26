Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74622606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 14:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D20H8oLN
Received: by kanga.kvack.org (Postfix)
	id 93F016B05B1; Mon, 26 Oct 2026 10:43:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 916D96B05B5; Mon, 26 Oct 2026 10:43:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82C716B05B6; Mon, 26 Oct 2026 10:43:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 66E676B05B1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:43:11 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EE455A07EF
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:43:10 +0000 (UTC)
X-FDA: 85365044940.02.7B71235
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 62D4A80007
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:43:09 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D20H8oLN;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793025789;
	b=JNliK32soS+R2UNPl+71yH1xbXC2VG+W8JyrnbKaoOWnXVqwnw6M/jDKSKdjthphYKnFvr
	15lzsUXlGq3wvknMuOplPcfYZVnHNd2OOWnCMtPCXYWtp0P09CvpbwCAjuDTvIPZyAfjEv
	blvY/qEeJi8kcVlgCUC1Ke1bunWHHwU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D20H8oLN;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793025789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RrYs5r78deoBJ9Dw8ytqmVZU3I9/wl2AOXZaDAj5RqE=;
	b=lDm1yGbixqYf2/24PrtyS5GfgOhEVEj+K73y/ZJuTo0+rlFdn9gNMOjlagQDvLsteSNL50
	yICc6ZgsO6Mkyov34VofsopkWOXo8+UY7biNgPk1lWz3u1qfVtGMgjc9U3cc+ZxF30cRdE
	GivO01NA7hdaYVaq/XLoK7x2Uduhveg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E7B2A602C3;
	Mon, 26 Oct 2026 14:43:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 515111F031E1;
	Mon, 26 Oct 2026 14:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793025788;
	bh=RrYs5r78deoBJ9Dw8ytqmVZU3I9/wl2AOXZaDAj5RqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D20H8oLN6BZpOOZUJ1qL0Xv4S4dpsgiCPtzFIyu5ruJIuvlTihAIxGVsuxWioWI/m
	 ULjJ47lKnw0OBl0+YT1jJLLiSw07yLju/PazLSV8+7gLtByV5+DmnK/KwxpT3gupX7
	 jI0Zjp505x3PCsm9T/ZoT8pDgk2D+1RIM/XizPPiBRLmJrqwYHv6D2DqEUc1ZvObSi
	 rJz9G1Ll7LG0xLaZOaui9AUvC8FvmLOYpLgT1PlksU+Uaj+ROciQOQXojTPMHGpaA1
	 nUuvK0DP/PQ5k4ln1IBTRhXC5a4XaaYhyAIThMDoqfkRZ4zLDq3o2YhMmrR4Sc4XIv
	 1hJsjE/64cDhw==
From: SJ Park <sj@kernel.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Manuel Ebner <manuelebnerli@mailbox.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] Docs/admin-guide/mm/damon/lru_sort: fix remaining grammar
Date: Mon, 26 Oct 2026 07:42:55 -0700
Message-ID: <20261026144256.150394-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <179301327249.2.16817896016779044743.damon-docs-grammar-4@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 62D4A80007
X-Stat-Signature: qu8z1666eyfjtggezpkijk3dfsepjizp
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793025789-187676
X-HE-Meta: U2FsdGVkX1+8Q642e3SjtRtZvkgi0XbkiHPJg4M3mnoih1+tkDgcmoEeX4nfqgGl4dVue3QrPNzSF7jeq3GPIXmG8Fmqxr4L4SRJslt54rLbELuBlQV77RXvhohJFJcwYs/0wSR4rFQTRRLHPyOCVeytFGNMUYL06wqcdhQwfFl9mmoR1V50OaPvokwmmbzgKvB/CPbCgVeU7Sy2B1tBwRkgVKP5VTK9oGVE6fc/9C4hngEY8wG/19eZi8uZAe0eIfWH4Y+2ctk+OpxpyqLl6mm2RjDDB0qU8E8QwqhHzvLOWpJtDghtzk9h8Qj+vXZ2yd3QeMaX2a4FU2eqaugM96BCrqu+opMwlR+Fbgm753xvuEDv1S6Ki+8oLoMntGhL+/s+OIoGluqn7cShHr4bAnAnlr4nZzGbbyQp+RhFMXn0Isr4umpKtOIKKneyo1PDsu9W0ImP5+Z8XtYdQ5CGy0h5tgXGzj2M/ZZ7VFZ+BSGenkafRsv1jXqTgjXc1DIvtOqGVA2IKYVd9soZY1+mzzG35ugWBV4SFONVVg82gXxkP7OS1DkRxX4d+/UkPY69FhpjNNwKdY6STR20MWVZCosnFxk457vX+u6/9DGv0ggv+T5zgQETSlSUqc20dVAd2Qs047fMPx5wHdcUyP8bVvNcuozoF08oxifTAzh7lu2rQjVSKHqR+iYtHFbTHm5b0kzeR3k+84r/dsuXTTklLYV53Ai9i95BaE2VVNgqz16sFAO78ns1T6yDb5XrvWlPwSE/HKWyULFHBAnYXqW4Ko97aYHOw2gOBtvy+cHcreiSGTFvV8yBFLm+HXaO7p2Tw7VcqrtRJ7YYeFSiXz5I4mAaecPvL8kFKt43EGybbp3Wb1o85uccfuNcdlIKGtxIhc+UjYSHC2vtlRFZX8UFsXeIU4fjHeGIb7ttMnmPp27x6yUElqr8gy+wLulHUhkIsxUPGs5VrPvFhLOfe6m
 TdU75HWb
 kXHlCvTEgRCg8dbRsi0vHfEUXnpA7gdWDwYnThbPV8VamB5zNntNIsJdcRarTVRh/CKmcao6HndvPy3s0jHmpCwCvdCMSQxYJN/6Gl5BbcIN7lh7Afd5Hu6ypLQaM1PiZSoWqO5psawn8PuwJFpWNLhiiwF/OID3qF829I3uxozjaojr8oMV2q2t4UXB5UQYOoXHB9+qhI5feqvZHJzrfi5ULCyphlUhj1oOlTZVHTce6jYWIwKtabuwC3yILNh/CNqbjELwJ7s7nO/d5D1gmk1bSY/6Z89WNt6zDH0cFiC4xYYc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 26 Oct 2026 22:14:36 +1100 Aveline Noir <jm5905938@gmail.com> wrote:

> Manuel's recent grammar fix for this file, now in damon/next, covered a
> good part of it.  This should take care of the few mistakes that are
> left, like "should automatically activated" and "Make DAMON_LRU_SORT
> reads".  Rewrap where the lines got too long.
> 
> Signed-off-by: Aveline Noir <jm5905938@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

