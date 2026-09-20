Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 962EEC982DA
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 13:15:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABCDE6B0093; Sun, 20 Sep 2026 09:15:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6C896B0095; Sun, 20 Sep 2026 09:15:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AB046B0096; Sun, 20 Sep 2026 09:15:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 751746B0093
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 09:15:32 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E8DAB80425
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 13:15:31 +0000 (UTC)
X-FDA: 85234187262.30.E945C19
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5640220003
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 13:15:30 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jNNVVhJc;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789910130;
	b=jG6VodvASEsRnB2JZuwWc49U3ztesCbEjpU0acXJKA8kzYK5TpdpY9jUWYc0gtctoqCni4
	NZ5parDHTpA7ADQF36vT4if5obVM4guaNeNyW2ASTSLs3p8rC0we1v6cM+ixJOE8jWc0mR
	kX0gTu7/QwvD966fG3EY4G1GdcJNNE4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jNNVVhJc;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789910130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ClvUqa3gFqi46vuVPqQXMQRykM+sC9yZ5XUitC0GKI=;
	b=s6+vjkrLtaOXakCBV5RMTxRqH/cYm0CJvHcpT6xwV1hd7JuqW/5JRnEPJpJ208lRqWc+m1
	L7E4HAe3GDoizmgcbC9N+JjnBSuz9JH4Jsjgr4bfkmcWsGoAIvRO4JPTW8P1FuF5EjY+pH
	Gry/enp+3/plYP8dodIPdMk2BmG2zYc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D9381601FD;
	Sun, 20 Sep 2026 13:15:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB571F000FF;
	Sun, 20 Sep 2026 13:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789910129;
	bh=2ClvUqa3gFqi46vuVPqQXMQRykM+sC9yZ5XUitC0GKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jNNVVhJc2J27yBQ2EaxxhZUQgKfvsfTeZtyDcVrWX0st4XLFQL5vswTsazFTMwvIb
	 2e5tsoyhxKb9hNf47SEhj97BQ8f+5z6tvMuCqEBlBA4QGADGyZhF2wUM3JTu4UEqpo
	 Qf9HfS7SNP+gdvAxJk6FisVXpe07MPHyneriYq38+7x3xV6zwulbeNLY3GbQUBWOmc
	 ovsekqyPRlI5P9I0W0Wy1NLKKSyJhw8tJGRCFLo6xVs6h5O38nARLT3l9nkDoDbBrd
	 M0QvrhJwTLmEo7zu/2hF6U1CZ7jR/mqnkH8SVlRpY3CkmTYwnD7nMVgL6DvCrKaQkp
	 Y4MSZyXRUHLsw==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 1/3] mm/damon/core: prevent size quota overflow in the temporal goal tuner
Date: Sun, 20 Sep 2026 06:15:24 -0700
Message-ID: <20260920131525.49087-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260920103714.47722-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5640220003
X-Rspam-User: 
X-Stat-Signature: ay98kabgatrnejrg44bhfm9bt9gjc9c6
X-HE-Tag: 1789910130-125363
X-HE-Meta: U2FsdGVkX19WrAlb6807Tzsom4qVicgdz8soRZ8D7fZkTv32bYlTitHLSegQ4BEHkHSFMVBDrwSSBR6ysrE4ZnpL72B8XmtDtQlx4WMZYU0U9DuoeVjJH39F+FgXTc5s0gakxbv/lOnkLtNQp+DXwGI3GcWYoBP44D7RzGt/S/0hkZmZvJNkSFHPpHl2EwGe2ojEiPSIB4Ntbo1leXKUPJ6vi6dCyvW4Ce2GAt/zS5kNFJ00bQjgspQ/3XY1VRSwDODwsJhqcec7e/0X4VQIGzzx3LZSmLXjEVVWAS2FWfeALw0e2IOKDmhUI1SKiE3tLt8RBODppNmnMYApMSruK/xgxidUT5T9OhhwNFNzOqBeURqC6ZfwofGirJhwcp8CAoaZqQZi+Am3Kkn8FVcvZ/FUh2A03eI2vPUMRuClH8rPS33HXPCgbZ628kbLInW5NpLV8FDwtdSWYuvG4SN9wnsyasih9FcDGjlVS59zgIj+pIWrZd3CvnJVFuuaYZj+MndkV4XJLtiskNR8qkvB4BYPIzFqtUHme1s7QfiuMylmOZ4gCGs8k4FZGxrVypgenDakEHdIY7dm3hDNgV1pEZgk4DqpOT7YDkgQjc2qRE4GgzaCB71vaHQryIaWpYIywiHVr1ZglglK/Oitu1PSxmh6a8kUG0FLRwq/rqZXbrV3z8glQIDocy6Ysnc1FtuPt1oXPOELMr5u0UQCIN8Y9FwC/5EBuXri3b7IgXS4kFxk0wHCg4WuBo3abBHOICNZWnVaNBPRl0Zztc/AZLpOOeEMDuQSM00eUkVACiiMi9EEC5hwGXuTJmNb3MHTvqFKjFbTFP1R7EbhELGn5yaDn1BOGXLbaCYnGPRNOuK6Vsi3zxg4DWoZ/6SjXvEWs/J3uJmOFJ+nMyawmvAPN82iBPJEuj3VHSx4C5CR9kjGbcSjiBxFWJJc6PP3ztVN53QmdDZqlX80KRDRDhCGm1L
 JmElAPu+
 OP7pLuHNw5Xoiy10agFiXyOgOIA8TO51/GXkPrdJQnfxu+yTvDnXn+ZTuAfBG2rBMOhE8jhNmIi24R8uFG8THlDPFovLrWsnQg0kdL16C+6pur3uLcpvH6uiQz+B9veznTwftLMZv31NLLxjJI3n9I9Njtk/JzL4OrolOSMFwnxqeRJ4chiSx6XKWMLiz6BEbhQRw3G9lXDG2ysGOjeEMUeEPopQ45GFaOZSuC0bXHHBRTrD3zB9Zb+fsWRqeXMzZclEaPsP5rxyeGpFjp5dhftTk1DMPO//RQOZ9hhwF2ffIyoyXOH09gTjJY39BO4xO9btH4LFP3svOTG4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 20 Sep 2026 03:37:13 -0700 SJ Park <sj@kernel.org> wrote:

> On Sun, 20 Sep 2026 11:31:09 +0900 Donggeun Yoo <donggeunyoo.kernel@gmail.com> wrote:
> 
> > damos_goal_tune_esz_bp_temporal() converts the scheme's size quota into
> > basis points with "quota->esz_bp = quota->sz * 10000", both unsigned long,
> 
> Let's break commit message lines with 72 columns limit.

Zenghui pointed out [1] the documented recommendation is 75 columns limit.
Let's use 75 columns limit.  Sorry for confusing you.

[1] https://lore.kernel.org/20260920131300.48929-1-sj@kernel.org


Thanks,
SJ

[...]

