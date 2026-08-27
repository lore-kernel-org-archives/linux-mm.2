Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06967C61DC6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 11:32:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 216D36B009B; Thu, 27 Aug 2026 07:32:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C7CD6B009D; Thu, 27 Aug 2026 07:32:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 104B86B009E; Thu, 27 Aug 2026 07:32:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E6F966B009B
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:32:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8E5D8A3B8E
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:32:44 +0000 (UTC)
X-FDA: 85146837048.12.FFB5679
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0BC0B40003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:32:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YCitKwHd;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787830363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6AAqqY4OkNSdQHM1gwmpJ5lzM2oTtRJv4IBEa3HgW1Q=;
	b=5iq69WXR4cPgnUHqCIPUJ8mD+5/N3Oi49YxHhcVsksI4p4fyCZDNPDXXElj8GJXAgsVyIu
	SRE1o18st66VhAgPiYjW++WpkF7FChFLqbR895uZ7FioA7Jq8VdVarRxVYt1EdVAZ0rqGe
	wSddzh/tG581tLvMPeAfQa8uvTwhz7s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787830363;
	b=DyR5oVBW6eyuJJjxzVXTzUY2JeZfBMhm9ij3712S8AI24qsKr8WgpPrGuxaP5V6Clo9mUP
	l3XRIyMn/oSw5VebvTkLFMzT+Gr9iAPVb2NmhCFa57wEZBHjTCEt4i4bGj6LkTPb9F/04M
	6ElF6eYVx2Iwq4CTjCCE59pGQYln4FQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YCitKwHd;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 84697600D3;
	Thu, 27 Aug 2026 11:32:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A0F01F000E9;
	Thu, 27 Aug 2026 11:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787830362;
	bh=6AAqqY4OkNSdQHM1gwmpJ5lzM2oTtRJv4IBEa3HgW1Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YCitKwHdBmmXQATMfnf96emOBD0bNGuTQZCIGvu0mBP5yiU9dwKhEi7E5dIgZLcHH
	 X1avs/xMwSZysmmH0oRRdopxhqfq2dOk4RJ+9AJXuoKQr2EqIy8AmdX1z5HoO44WyW
	 K7hlAi6SMU+M7ZQN+RKm5BJCPeWL9QuDyF8tKg7WTPSjvTVzg/ydhecanXaRsHHNu9
	 +16jjMxfS6oKmZWvHz3diEiPMxOmv7LpcWhg9bsaekG079iYr0x8HSs8S6uoE5Cizg
	 D4FriUW44WmRsndIj5Z2ZGPEI36T5HvQ/OKTQSCa6fsV5xiWP1N/ghqXAx+mRdhEug
	 CETbX5v1Hinrw==
Date: Thu, 27 Aug 2026 12:32:35 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Hajime Tazaki <thehajime@gmail.com>
Cc: david@kernel.org, linux-mm@kvack.org, liam@infradead.org, rbm@suse.com, 
	akpm@linux-foundation.org, luto@amacapital.net, brendan.jackman@linux.dev, 
	liuhangbin@gmail.com, corbet@lwn.net, kees@kernel.org, broonie@kernel.org, 
	mhocko@suse.com, rppt@kernel.org, shuah@kernel.org, surenb@google.com, 
	vbabka@kernel.org, wad@chromium.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-um@lists.infradead.org, geert@linux-m68k.org, 
	daniel@thingy.jp
Subject: Re: [PATCH v2 0/2] support kselftest on nommu platform
Message-ID: <apAgQJ5p8LEDj1c5@gremlin>
References: <20260825015945.141739-1-thehajime@gmail.com>
 <f2ac9432-4fea-4007-aab0-ad80597b284c@kernel.org>
 <ao2Tl9CLL7WjHYun@gremlin>
 <bb9a3add-4849-4928-8b6a-0afc0c73b112@kernel.org>
 <ao2l9Ao7BQI6uRKC@gremlin>
 <m2y0dsuf1d.wl-thehajime@gmail.com>
 <ao_541nBaa3SJS9F@gremlin>
 <m2v78wueir.wl-thehajime@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2v78wueir.wl-thehajime@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0BC0B40003
X-Stat-Signature: oymnsjqpx9qckab64b66c3t57wyxnwqe
X-HE-Tag: 1787830362-721711
X-HE-Meta: U2FsdGVkX1/3mE0okO8O5ppv8TwXgD3LcSHXRSDY0JLrjXIx/koPXJsqeZpjMxezbyL+jhA2zFf0An3J8BXkURQgApN3DfLiKr8chZOQYjITfLFowXB4FjVV6YrDLkf6ckXN5PMwn8eXTvIQ6CJQzSzt2Rel6g61NTF5h8g0CaX94VRmkLyZ91CY9WYVPQ88bFAiJNFERg2iat6E6yQTlInR3H5zz/tQ58+rONEu6PcH1cEqpGXIqjl9p9IZE3Opzt6XFJ11BjhiTjg9mJbm7A8Ay9syyPbaPaaAv6gEC+V65ZZQ/mIqZGykRTTNIKn5SDqG+2vNJxxq/cNhBzG05pZHIOg1q7T0qXYuAjU0ubrhPlTfHp/35PsZgTa0EU58gEadBLz2v/js6fRDPOzWwOk8rEhBmJf+eJVU7/OnOVt9fOd1yhHO1f/gpegoaEeDf1ZV1ny8jhbY41gukm6x/CfPe51GkU888oO0mmfZcfEL5kNNA61yqUVZZteuqp/H2RosJHGTNClwp2hFcTA8WbCyPRDm6QrYLQBqwZC/BlbZb5uzCDizA03ab3rp8jR7rlX2MGTp6/4MCfZi7vqqnzLXoNkKkzTxtOK2Vtnb9OKU/jsV+z+YvNEBv/qlJktUzsYVNR7J7pRf1eTfPFEyVFMFNIUNUaWbr3XYr36dUhYB7Z90eTygUFt/QA5B85peh3ppkQdmFRKkkDLkxgT4eweh1jeHw1GNsuwYd8/c3q372PtJbTOz9jeZoP4aS5b6twaqq/b2MRPUPsiLly1U0jaLEHYvU+qKh1NmdfjFvC7hheuTOci7dpXcykJTzkOjV8yrefiD/Q4MpS9AOqyfKaHwrwkMPBKUuu3GBhqCro4BfPa8ua3DooCqthQ8OK80v4FYFaNwUiJlLQMsdQmVP24oIFCwdKA40Dm+cIG4yspVdjI+FarPG0836jXkznzOpggqCBuge1EXaRx/y8f
 +96pbYe3
 46hUTcFYWElCni+Bwc7sLzMtobgRFGs44rFO4I4eWTT4IzDOxWk3I4T/eHjLGFvcdTkOgyivnvU3h2CdPs+S8QdaaQZyC8P74aTEGc6f4BgCOejkVZMjDHrx1z5YokCVl8ATdA1UaPkc9IgsIwIkMCkEeXlS9VICz9pvsbRR78YIT6ziR8WLnf/gwpNYdl6J2103FBxTg4XEoklvAbvHIZRDm4jy3ikGWBzDX2X07bxC9lQzBox5cRwwqyoNOlcL4BpIr8+WO4nF0MgoWOoNVcol7yu5kL37D9WpWUzBbWw0m1E8YO2s/gvP4VvjYboWWPBQK+hvE5lvYAbFR/wszfAGp8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 05:57:32PM +0900, Hajime Tazaki wrote:
>
> On Thu, 27 Aug 2026 17:49:58 +0900,
> Lorenzo Stoakes (ARM) wrote:
>
> > BTW did
> > https://lore.kernel.org/all/20260723093633.140989-12-johannes@sipsolutions.net/
> > go upstream? Or another UML nommu mode? I've not been keeping track of all
> > that.
>
> The current consensus (IIUC) is above Johannes's patches are in
> progress.  Another mode which I was originally proposed is postponed
> in order to minimize the impact to UM tree.

Ah ok cool, thanks! Is that headed to 7.3 or more like 7.4?

>
> -- Hajime
>

--
Cheers, Lorenzo

