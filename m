Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36DD2106ACED
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 20:55:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 974DB6B00A4; Thu, 12 Mar 2026 16:55:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 946036B00B9; Thu, 12 Mar 2026 16:55:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85F226B00BA; Thu, 12 Mar 2026 16:55:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F58A6B00A4
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:55:18 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0E6E1B966B
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:55:18 +0000 (UTC)
X-FDA: 84538616316.30.C250E20
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 51703140004
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:55:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=q7b66OmU;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773348916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aCGom4+L9l7jW53hELBNgbJjg9gnQYSowLnseml/968=;
	b=b/+kZazyZ3kxSuH4I6PB0FERqoVY5dxuUgk7iUVqkLGci743t7Li4YKybLAT9fK8FhC0kd
	3/q7jVD4jAYbiCCQt0ew8IGN9McGo9O66rb6ohsOW4WFsn6jnQauHRC0GQxlIf2G3ihd9F
	JvEx9rtFeX7aS5w8eE8bJVJBFII9hpY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773348916; a=rsa-sha256;
	cv=none;
	b=r0hcHgSfEntQN07rscIto0zvUMuEQmI3Ey8ZrDagiTfyBgMnE9CgBLS1qjnOC0A8Tz9j8E
	oaEOH9LiJqWcjzn2K71fXROJVHw7EwPKq08UAU5Zfq1IY8vyzk9mX0u8oj1HFsqTVEYczG
	DbDoEocY0lQWbTpHUdX3ZC7WiDzlV10=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=q7b66OmU;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 594C940304;
	Thu, 12 Mar 2026 20:55:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2906C4CEF7;
	Thu, 12 Mar 2026 20:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773348915;
	bh=KKK0LYCG2uYPIFnrX/Vubntl8NnYPUEqVRINxfpaDEQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=q7b66OmUWHmv9dj5zNmdqz+zz6pEB9NHpZjRSmb1+ljWVYWyqKG1i5gzWzFVYxyCZ
	 r+mn8NKfd+JCCn802UOyIVTdVaKylr7REF0jax/e85DyPErtKY548uoKohzIQ0gyiY
	 /uk4kyRGLVDvnT5L1SHIH613/O/Du6c2u0l1eedo=
Date: Thu, 12 Mar 2026 13:55:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Josh Law <hlcj1234567@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Josh Law
 <objecting@objecting.org>
Subject: Re: [PATCH v3 1/2] lib/idr: fix infinite loop in idr_get_next()
Message-Id: <20260312135514.e4fc0fa4c1f50e6fbda2644c@linux-foundation.org>
In-Reply-To: <20260312181948.20020-2-objecting@objecting.org>
References: <20260312181948.20020-1-objecting@objecting.org>
	<20260312181948.20020-2-objecting@objecting.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 51703140004
X-Stat-Signature: paiwi8cksnu87qnqwis5zcgw3g1pats6
X-HE-Tag: 1773348916-680408
X-HE-Meta: U2FsdGVkX1/eSs/TYX8XwvRpjxkbNu7p+lSq1knXfu+XXYjRyHvH+TcH/nGDFQWoKMgPPjz5aGeT3xtXntdc65UOn6IHaWp4QMeqhNasETPYku+HSq02dtamFyYbtsDk2M1fLc4YzPsgVYM1mLt4zVHjdHCMpajxALfBmIJamD3BsJIZ7jXddEmWm0bkMGPvToIccECQ99N4PD/WXR9VFMnAELfaaG5IuC9MTPygYovGvdaD9VvKc0SFNVQ7vCa3gL+g2PYzJ1YuWgZJEkegevtiPD91sPihVOkfcSoA6Z8wM16n9IPNZqDI9HgsVvHy5FKrUo8CP7T8tdHSiC3J1h5Hndf6PBqKnjag/CTiqFrkF9p0IC2nmm2lPTnLUSFbQaUU9vmmDqMOh71XAnVCssYVJETTxjZOpD5GNbmlSPVUw52ngDGqe/nlGn/fjJfDnyoUIcac+SYUVhZRgYQ/7lNkw1lAQBaD5rcnFjxwNOlx4cDKlyvU0kqCaACP9IWupqm5D1dvEpFyn0+qZMObugM5j9NKMQr5wjL5IjXEPBBHuIMaCEUNYUj7Hy/Dpp4isj1HWfCHoAvTa/UbNjxLlIXHcFvK33uPdhbzsisC2CVs6srBsBHVtw7pA1Jvhk7ijrQNPFGRD8Juik2w7LyBqV2oDRPZJJvgtVIWs3Wd6P6Nlqbds6AgMyidbvFdp+jtR55oBoi0WY/hB2/+gHk/f+0iTlxtqlva/VnOodJ6W6sYbqm7Vm57e1Xwq9steSajG4rU24VguEnCec6bcHBTmfevCSKimCe2GHzlnhMPwKkuXI/SdueejIVvAczFiQA5PeWDak1sJXQnnmZX0tQOtOgXQ3HaQJgjRYCGnOryJIftHHMrz4CtyVI5o3akf9N58IVigB9jr9O6+yLPRIZ+qA7jkhQignrXFms3ReZbL+yG/Kbw6LQUAlk3Fo2bgDLSj3vOVv1bhUqefpWmRNS
 LeDiQDVC
 bYOOq8TRLAZ8Dw3L+vlZDYA8ocA3pKn/RSQgFvSl9WCBpc2GGkYe+AoKQeQlpMk1pSsrILQuQTE8Rz9UHoMJ/T5v0x7xHycmo1WWLrpv4OXN6BCjlY9uRoy2PxhQnidxw5Eru16m7xEr/txGUggp35gbHeHTLQCo/0oDNb8ZRBTL734yWK33ByJ/BgZ2j+iNGFDQIH+HsNjoIZluvaYr6+k02Vc6URzDhTieajuCSyv2f8gCQPJ7ASSNCPgYwMPuRkCTWL7dHQ977vRYxKg8MliOr5JPNAdEHTw8fwspg0yD8mjlMz8Xm9fP6fpHgz7kxEOtG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 12 Mar 2026 18:19:47 +0000 Josh Law <hlcj1234567@gmail.com> wrote:

> In idr_get_next(), if the returned id from idr_get_next_ul() is greater
> than INT_MAX, the function issues a warning and returns NULL without
> updating the *nextid pointer. This causes a soft lockup for any caller
> iterating over an IDR (e.g. via idr_for_each_entry) because they will
> receive NULL, fail to advance their index, and repeatedly query the same
> state forever.

This assumes that the idr_get_next() caller ignores the NULL return and
just keeps on looping.  Isn't that a caller bug and if so, do we need
to defend against it here?


